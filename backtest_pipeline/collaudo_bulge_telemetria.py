#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Collaudo STRATO 1 di mql5/Experts/ABTG_Bulge_Telemetria.mq5 (copia di BANCO con telemetria del Bulge VIOLA,
09/10/2026, firma Q4 di Claudio), sul modello di collaudo_bulge_azzurra.py.

Qui NON c'e' MetaEditor e NON c'e' il tester: niente compila l'MQL5, nessun backtest. Il test di accettazione
P0 della spec (Trades/Profit/PF/DD identici a ABTG_Bulge v5.20 nella stessa passata) RESTA da fare nel tester.
Qui si prova a tavolino tutto quello che si puo' provare, e si dice cosa resta fuori.

  Z) ZONE DEL DIFF: la copia deve essere ABTG_Bulge.mq5 (SHA256 ED4E88B1..., verificato) + SOLO le zone
     dichiarate (intestazione, globali [TEL], magic/commento, input InpTelemetria, 7 righe guardate, nome al
     Guardian, funzioni [TEL] in coda).
  S) STATICO: ASCII/LF; parentesi; TUTTE le funzioni di ABTG_Bulge identiche byte per byte tranne OnInit,
     OnDeinit, OnTick, OpenOrder, OnTester, che tolte le righe "if(InpTelemetria) Tel...();" e i commenti
     [TEL] (e col nome al Guardian riportato) sono IDENTICHE; ogni chiamata Tel* fuori dalle Tel* e' guardata
     da if(InpTelemetria); le Tel* chiamano SOLO funzioni della lista bianca (letture, file, stampa): niente
     ordini, GlobalVariable, notifiche, WebRequest, #import, Sleep, TimeGMT; i file si toccano SOLO in TelInit,
     TelScriviPathSegnale, TelScriviFine e NESSUNA delle tre funzioni del ciclo dei segnali (TelNuovaBarra,
     TelPrologoOpenOrder, TelDopoCheckSignal) arriva a una scrittura; nessuna Tel* scrive una globale
     dell'originale; input: stessi nomi/tipi/default tranne InpMagic/InpComment + InpTelemetria=false; magic
     libero in tutto il repo; costanti del percorso = spec; esiti dichiarati; PrintFormat segnaposto=argomenti.
  P) FUNZIONI PURE VERE compilate in C++: TelIndiceBarra1 (contro bisect), TelEsitoOpenOrder/TelEsitoCancelli
     (tavole di verita' e bordi), TelSlTp, TelMfeMae, TelAggiornaEstremi, TelPipSize, TelMotivoUscita,
     l'autotest dell'EA (deve tornare 0), le intestazioni == colonne della spec (lette dalla spec).
  X) DIFFERENZIALE con un TERMINALE FINTO in C++ (posizioni, CTrade, storia, file):
     (1) TelValutaViola contro CheckSignal VERA di ABTG_Bulge (ordini VIOLA registrati) su migliaia di finestre,
         offset 0/1, VIOLA EA/PINE, Lookback 10/20, ADX, ATR, piu' uno specchio Python indipendente;
     (2) OnTick+CheckSignal+OpenOrder VERI dell'originale contro quelli della copia con InpTelemetria 0 e 1:
         STESSI invii, stesso Guardian, stesse stampe, stesso libro posizioni (= "spento bit per bit" e
         "acceso non cambia gli ordini"); e ogni record di telemetria ha l'esito che un oracolo Python
         indipendente ricava dai cancelli (kill, news, Max_Trades, ATR, ADX, HASOPEN, lotti, TP, SL, Guardian,
         rifiuto), con pos_id = posizione aperta; canarini (orfani, divergenze, non risolti) = 0;
     (3) END-TO-END: quattro segnali in sequenza (OPENED long a TP, OPENED short a SL, BLOCK_ATR,
         BLOCK_MAXTRADES), tick, chiusure, percorso a blocchi, fine passata -> i DUE CSV scritti dal codice vero
         -> controlli di formato (CRLF, ASCII, 47/11 colonne, ordine, k, barra 1, orologio vuoto) e valori ->
         backtest_pipeline/sim_bulge_viola_uscite.py --controlla (il lettore esistente, solo richiamato) deve
         dire 2 su 2; CONTRO-ESEMPIO: con un exit_reason falsato deve dire 1 su 2 e uscire con 1.
  M) MUTANTI CIECHI su copie fuori dal repo: ognuno deve far fallire almeno un controllo; quelli di LOGICA
     devono essere presi da P o X (non solo dal diff/statico).

Uso:   python3 backtest_pipeline/collaudo_bulge_telemetria.py [--senza-mutanti]
Esce con 0 solo se tutto passa. NON prova: compilazione MQL5, il tester (P0), CTrade/riempimenti veri,
Guardian vero, iBands/iATR/iADX/CopyRates del terminale, la scrittura reale in Common\\Files.
"""
import difflib
import hashlib
import os
import random
import re
import shutil
import subprocess
import sys
import tempfile

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
SRC_NEW = os.path.join(ROOT, "mql5/Experts/ABTG_Bulge_Telemetria.mq5")
SRC_OLD = os.path.join(ROOT, "mql5/Experts/ABTG_Bulge.mq5")
SPEC = os.path.join(ROOT, "report/BULGE_VIOLA_TELEMETRIA_SPEC_2026-10-08.md")
LETTORE = os.path.join(ROOT, "backtest_pipeline/sim_bulge_viola_uscite.py")
SHA_OLD = "ed4e88b1cfba36ad81658935e8920fe31462ae3202dd61c9c50a039acef57bbd"
PROPRI = {"mql5/Experts/ABTG_Bulge_Telemetria.mq5", "backtest_pipeline/collaudo_bulge_telemetria.py"}
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
# utilita' di lettura del sorgente (stesse di collaudo_bulge_azzurra.py)
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


def blocco_globali(src):
    a = src.index("//=== [TEL] GLOBALI INIZIO")
    b = src.index("//=== [TEL] GLOBALI FINE")
    return src[a:b]


def membri(struct_txt):
    return re.findall(r"(?m)^\s+(?:bool|int|long|double|string|datetime)\s+(\w+);", struct_txt)


def struttura(src, nome):
    m = re.search(r"struct %s\s*\{(.*?)\n\};" % nome, src, re.S)
    return m.group(0) if m else ""


def colonne_spec():
    t = open(SPEC, encoding="utf-8").read()
    a, b, c = t.index("## 2. File 1"), t.index("## 3. File 2"), t.index("## 4.")
    f1, f2 = [], []
    for ln in t[a:b].split("\n"):
        if ln.startswith("|") and not ln.startswith("|---") and not ln.startswith("| #"):
            f1 += re.findall(r"`(\w+)`", ln.split("|")[2])
    for ln in t[b:c].split("\n"):
        if ln.startswith("|") and not ln.startswith("|---") and not ln.startswith("| Colonna"):
            f2 += re.findall(r"`(\w+)`", ln.split("|")[1])
    return f1, f2


# ===========================================================================
# Z) ZONE DEL DIFF (ancorate a ABTG_Bulge.mq5)
# ===========================================================================
ZONE = [
    ("intestazione: nome del file", r"^//\|\s+ABTG_Bulge\.mq5 \|$", r"^//\|\s+ABTG_Bulge\.mq5 \|$", 1),
    ("intestazione: blocco COPIA DI BANCO prima del CHANGELOG", r"^//  CHANGELOG$", r"^//  CHANGELOG$", 1),
    ("globali [TEL] dopo Log()", r"^void Log\(string m\)", r"^void Log\(string m\)", 1),
    ("identita': InpMagic + InpComment", r"^input long   InpMagic", r"^input string InpComment", 1),
    ("input InpTelemetria", r"^input bool   InpAutoTest", r"^input bool   InpAutoTest", 1),
    ("OnInit: TelInit", r"^   if\(InpAutoTest\) AutoTestBulge\(\);$", r"^   if\(InpAutoTest\) AutoTestBulge\(\);$", 1),
    ("OnDeinit: TelChiudi", r"^void OnDeinit\(const int reason\)$", r"^\{$", 1),
    ("OnTick: TelNuovaBarra", r"^      g_lastBarTime\[i\] = barTime;$", r"^      g_lastBarTime\[i\] = barTime;$", 1),
    ("OnTick: TelDopoCheckSignal", r"^      CheckSignal\(i\);$", r"^      CheckSignal\(i\);$", 1),
    ("OnTick: TelFineTick", r"^   UpdateAllTP\(\);$", r"^   UpdateAllTP\(\);$", 1),
    ("OpenOrder: TelPrologoOpenOrder", r"^void OpenOrder\(", r"^\{$", 1),
    ("OpenOrder: nome al Guardian", r'ABTG_GuardiaIngresso\(InpUsaGuardian, "ABTG_Bulge"\)',
     r'ABTG_GuardiaIngresso\(InpUsaGuardian, "ABTG_Bulge"\)', 2),
    ("OnTester: TelScriviFine", r"^double OnTester\(\)$", r"^  \{$", 1),
    ("funzioni [TEL] in coda", r"^//================== fine OPTFRAME inlined", r"^//================== fine OPTFRAME inlined", 1),
]


ZONA_CODA = "funzioni [TEL] in coda"


def zone_istanze(old_lines):
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
    blocchi = tolte = aggiunte = 0
    for tag, i1, i2, j1, j2 in sm.get_opcodes():
        if tag == "equal":
            continue
        blocchi += 1
        tolte += i2 - i1
        aggiunte += j2 - j1
        dove = None
        for k, (nome, s, e) in enumerate(zone):
            ok = (s - 1 <= i1 <= e + 1) if i1 == i2 else (s <= i1 and i2 - 1 <= e)
            if nome == ZONA_CODA and i1 == i2 and i1 >= len(old_lines) - 1 and e == len(old_lines) - 2:
                ok = True                     # inserimento in fondo al file, dopo l'ultima riga dell'originale
            if ok:
                dove = k
                break
        if dove is None:
            check(False, "blocco del diff FUORI dalle zone dichiarate: righe ABTG_Bulge %d-%d (%s) -> %r"
                  % (i1 + 1, i2, tag, "\n".join(new_lines[j1:j2])[:160]), bag, quiet=quiet)
        else:
            usate[dove] = usate.get(dove, 0) + 1
    for k, (nome, s, e) in enumerate(zone):
        check(k in usate, "zona dichiarata con il suo blocco nel diff: %s (riga %d di ABTG_Bulge)" % (nome, s + 1), bag, quiet=quiet)
    if not quiet:
        print("  ..   diff: %d blocchi, %d righe di ABTG_Bulge toccate, %d righe nuove" % (blocchi, tolte, aggiunte))
    check(tolte <= 5, "righe di ABTG_Bulge toccate <= 5 (nome file, magic, commento, 2 x Guardian): sono %d" % tolte, bag, quiet=quiet)


# ===========================================================================
# S) STATICO
# ===========================================================================
DIFFERENTI = {"OnInit": 1, "OnDeinit": 1, "OnTick": 3, "OpenOrder": 1, "OnTester": 1}
PRIMA_RIGA = {"OnDeinit", "OpenOrder", "OnTester"}       # la riga guardata e' la PRIMA istruzione
NUOVE = {"TelNomeFile", "TelAzzeraStato", "TelAzzeraViola", "TelAzzeraSegnale", "TelPipSize", "TelEViola", "TelSlTp",
         "TelEsitoCancelli", "TelEsitoOpenOrder", "TelAdxBlocca", "TelAdxValore", "TelAtrRatio", "TelValutaViola",
         "TelNuovaBarra", "TelNuovoSegnale", "TelCercaAttesa", "TelPrologoOpenOrder", "TelPosGiaNota", "TelRischioMoneta",
         "TelTrovaPosizione", "TelDopoCheckSignal", "TelAggiornaEstremi", "TelMfeMae", "TelMotivoUscita", "TelSegui",
         "TelFinalizza", "TelIndiceBarra1", "TelT", "TelIntestazioneSegnali", "TelIntestazionePath", "TelRigaSegnale",
         "TelRigaPath", "TelScriviPathSegnale", "TelScriviPathPronti", "TelFineTick", "TelScriviFine", "TelAutoTest",
         "TelInit", "TelChiudi"}
INPUT_CAMBIATI = {"InpMagic": ("long", "775100"), "InpComment": ("string", '"BULGE_TEL"')}
INPUT_NUOVI = {"InpTelemetria": ("bool", "false")}
RIGA_GUARDIAN = 'if(!ABTG_GuardiaIngresso(InpUsaGuardian, "ABTG_Bulge_Telemetria")) return;'
RIGA_TEL = re.compile(r"^\s*(//--- \[TEL\].*|if\(InpTelemetria\) Tel\w+\([^;]*\);)\s*$")
GUARDATA = re.compile(r"^\s*if\(InpTelemetria\) (Tel\w+)\([^;]*\);\s*$")
# cosa una Tel* puo' chiamare: letture, file, stampa. Tutto il resto e' un FAIL.
BIANCA = {"HasOpenTrade", "CountOpenTrades", "CalcLots", "IsNewsHour", "AtrOk", "GetBars", "GetATR", "GetATRSeries",
          "GetBB", "GetBBSeries", "GetBBWidthMA", "GetADX", "PurpleReactionOk",
          "SymbolInfoDouble", "SymbolInfoInteger", "NormalizeDouble", "MathAbs", "MathRound", "ArrayResize", "ArraySize",
          "ArraySetAsSeries", "CopyBuffer", "CopyTime", "CopyRates", "iBarShift", "iADX", "IndicatorRelease",
          "TimeCurrent", "TimeToString", "DoubleToString", "IntegerToString", "StringFind",
          "PositionsTotal", "PositionGetTicket", "PositionSelectByTicket", "PositionGetInteger", "PositionGetDouble",
          "PositionGetString", "HistorySelectByPosition", "HistoryDealsTotal", "HistoryDealGetTicket",
          "HistoryDealGetInteger", "HistoryDealGetDouble", "HistoryDealGetString",
          "FileOpen", "FileClose", "FileWriteString", "MQLInfoString", "GetLastError", "PrintFormat"}
PAROLE = {"if", "for", "while", "return", "switch", "sizeof"}
FILE_FN = {"FileOpen", "FileClose", "FileWriteString", "FileWrite", "FileFlush", "FileWriteArray", "FileDelete"}
SCRIVONO = {"TelInit", "TelScriviPathSegnale", "TelScriviFine"}
CICLO = {"TelNuovaBarra", "TelPrologoOpenOrder", "TelDopoCheckSignal"}
VIETATE = r"\b(OrderSend|OrderSendAsync|PositionClose|PositionModify|PositionOpen|GlobalVariable\w*|SendNotification|SendMail|SendFTP|WebRequest|Alert|PlaySound|Sleep|TimeGMT|TimeLocal|TimeTradeServer|TimeGMTOffset|TimeDaylightSavings|ExpertRemove|TesterStop|TesterWithdrawal|TesterDeposit|ChartSetSymbolPeriod|OrderCalcProfit)\b"
GLOBALI_ORIG = ["g_symbols", "g_symbolCount", "g_lastBarTime", "g_sigOff", "g_hBands", "g_hATR", "g_hADX",
                "g_kill_active", "g_kill_reason", "g_kill_today_start", "g_r0Ticket", "g_r0Dist",
                "gDayStartEquity", "gDayMinEquity", "gWorstDayPct", "gDayEqStamp"]
ESITI = {"OPENED", "BLOCK_KILL", "BLOCK_NEWS", "BLOCK_MAXTRADES", "BLOCK_ATR", "BLOCK_ADX", "BLOCK_HASOPEN",
         "SKIP_LOTS", "SKIP_TP", "SKIP_SL", "BLOCK_GUARDIAN_O_RIFIUTO", "NON_RISOLTO", "ATTESA", "INVIO"}
_CACHE_MAGIC = {}


def magic_libero(val):
    """file del repo (tracciati + non tracciati) che contengono il numero, tolti questo EA, il suo collaudo e
    i file che parlano di questa copia di banco (future righe/referti che la citano col suo magic)."""
    if val in _CACHE_MAGIC:
        return _CACHE_MAGIC[val]
    r = subprocess.run(["git", "grep", "-lE", "--untracked", "(^|[^0-9])%s([^0-9]|$)" % val],
                       cwd=ROOT, capture_output=True, text=True)
    altri = []
    for x in sorted(set(x for x in r.stdout.split("\n") if x.strip()) - PROPRI):
        try:
            with open(os.path.join(ROOT, x), "rb") as f:
                if b"bulge_telemetria" in f.read().lower():
                    continue
        except OSError:
            pass
        altri.append(x)
    _CACHE_MAGIC[val] = altri
    return altri


def chiamate(corpo):
    code = maschera(corpo)
    p = code.index("{")
    return set(m.group(1) for m in re.finditer(r"\b([A-Za-z_]\w*)\s*\(", code[p:])) - PAROLE


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
    check(set(fn) - set(fo) == NUOVE, "funzioni nuove = le %d Tel* dichiarate (in piu': %s, mancanti: %s)"
          % (len(NUOVE), sorted(set(fn) - set(fo) - NUOVE), sorted(NUOVE - (set(fn) - set(fo)))), bag, quiet=quiet)
    check(not (set(fo) - set(fn)), "nessuna funzione di ABTG_Bulge sparita (%s)" % sorted(set(fo) - set(fn)), bag, quiet=quiet)
    diverse = sorted(n for n in fo if n in fn and fo[n] != fn[n] and n not in DIFFERENTI)
    check(not diverse, "funzioni non dichiarate identiche byte per byte (%d su %d) %s"
          % (len(fo) - len(DIFFERENTI), len(fo), diverse if diverse else ""), bag, quiet=quiet)
    # le cinque funzioni toccate: tolte le righe [TEL] sono l'originale
    for nome, quante in DIFFERENTI.items():
        t = fn.get(nome, "")
        righe = t.split("\n")
        g = [ln for ln in righe if GUARDATA.match(ln)]
        senza = "\n".join(ln for ln in righe if not RIGA_TEL.match(ln))
        if nome == "OpenOrder":
            check(senza.count('"ABTG_Bulge_Telemetria"') == 2, "OpenOrder: 2 righe del Guardian col nome della copia", bag, quiet=quiet)
            senza = senza.replace('"ABTG_Bulge_Telemetria"', '"ABTG_Bulge"')
        check(senza == fo.get(nome), "%s: tolte le righe [TEL] e' IDENTICA all'originale" % nome, bag, quiet=quiet)
        check(len(g) == quante, "%s: %d righe 'if(InpTelemetria) Tel...();' (attese %d)" % (nome, len(g), quante), bag, quiet=quiet)
        if nome in PRIMA_RIGA:
            corpo = [ln for ln in righe[1:] if ln.strip() not in ("{", "") and not ln.strip().startswith("//")]
            check(bool(corpo) and GUARDATA.match(corpo[0]) is not None, "%s: la riga [TEL] e' la PRIMA istruzione" % nome, bag, quiet=quiet)
    # ogni chiamata Tel* fuori dalle Tel* e' una riga guardata; InpTelemetria solo li'
    corpi_tel = [fn[n] for n in NUOVE if n in fn]
    resto = src
    for c in corpi_tel:
        resto = resto.replace(c, "")
    resto = resto.replace(blocco_globali(src), "")
    mr = maschera(resto)
    righe_r, mrighe = resto.split("\n"), mr.split("\n")
    nchiam = 0
    for i, ln in enumerate(mrighe):
        if re.search(r"\bTel[A-Z]\w*\s*\(", ln):
            nchiam += 1
            check(GUARDATA.match(righe_r[i]) is not None, "chiamata Tel* NON guardata da if(InpTelemetria): %r" % righe_r[i].strip(), bag, quiet=True)
        if re.search(r"\bg_tel\w*", ln):
            check(False, "globale g_tel* usata fuori dalle Tel*: %r" % righe_r[i].strip(), bag, quiet=True)
    check(nchiam == 7, "7 chiamate Tel* nel codice originale, tutte guardate (trovate %d)" % nchiam, bag, quiet=quiet)
    n_inp = len(re.findall(r"\bInpTelemetria\b", mr))
    check(n_inp == 8, "InpTelemetria: dichiarazione + 7 guardie e nient'altro (trovate %d)" % n_inp, bag, quiet=quiet)
    # lista bianca delle chiamate dentro le Tel*
    fuori = {}
    grafo = {}
    for n in NUOVE:
        if n not in fn:
            continue
        ch = chiamate(fn[n])
        grafo[n] = ch
        x = sorted(c for c in ch if c not in BIANCA and c not in NUOVE)
        if x:
            fuori[n] = x
    check(not fuori, "le Tel* chiamano SOLO letture/file/stampa della lista bianca %s" % (fuori if fuori else ""), bag, quiet=quiet)
    viet = sorted(set(m.group(1) for c in corpi_tel for m in re.finditer(VIETATE, maschera(c))))
    check(not viet, "nelle Tel* nessun ordine/modifica/GlobalVariable/notifica/WebRequest/Sleep/TimeGMT %s" % viet, bag, quiet=quiet)
    check(not re.search(r"\btrade\s*\.", "".join(maschera(c) for c in corpi_tel)), "nelle Tel* nessun uso di trade.", bag, quiet=quiet)
    mo = maschera(old)
    for parola in ("#import", "WebRequest", "SendMail", "SendFTP", "Sleep("):
        check(code.count(parola) == mo.count(parola), "'%s' nel codice (commenti esclusi): stesse occorrenze dell'originale (%d)" % (parola, mo.count(parola)), bag, quiet=quiet)
    check(maschera(src).count("SendNotification") == maschera(old).count("SendNotification"),
          "SendNotification: nessuna nuova", bag, quiet=quiet)
    scrive = sorted(n for n in grafo if grafo[n] & FILE_FN)
    check(set(scrive) <= SCRIVONO, "file toccati SOLO da %s (trovate: %s)" % (sorted(SCRIVONO), scrive), bag, quiet=quiet)

    def raggiunte(n, vis=None):
        vis = set() if vis is None else vis
        for c in grafo.get(n, ()):
            if c in NUOVE and c not in vis:
                vis.add(c)
                raggiunte(c, vis)
        return vis
    for n in sorted(CICLO):
        r = raggiunte(n) | {n}
        check(not (r & SCRIVONO) and not any(grafo.get(x, set()) & FILE_FN for x in r),
              "%s (ciclo dei segnali) non arriva a nessuna scrittura (%s)" % (n, sorted(r & SCRIVONO)), bag, quiet=quiet)
    scritte = []
    for c in corpi_tel:
        mc = maschera(c)
        for g in GLOBALI_ORIG:
            if re.search(r"\b%s\b\s*(\[[^\]]*\])?\s*(=(?!=)|\+=|-=|\*=|/=|\+\+|--)" % g, mc) or \
               re.search(r"\b(ArrayResize|ArrayInitialize|ArrayFree|ArraySetAsSeries)\s*\(\s*%s\b" % g, mc):
                scritte.append(g)
    check(not scritte, "nessuna Tel* scrive una globale dell'originale %s" % sorted(set(scritte)), bag, quiet=quiet)
    for n in ("TelInit", "TelScriviFine"):
        fo_ = re.findall(r"FileOpen\(([^;]*)\);", maschera(fn.get(n, "")))
        check(len(fo_) == 1 and all(f in fo_[0] for f in ("FILE_WRITE", "FILE_TXT", "FILE_ANSI", "FILE_COMMON")),
              "%s: FileOpen con FILE_WRITE|FILE_TXT|FILE_ANSI|FILE_COMMON (Common\\Files, come abtg_trades_*)" % n, bag, quiet=quiet)
    fws = re.findall(r"FileWriteString\((.*?)\);\n", "".join(fn.get(n, "") for n in SCRIVONO))
    check(len(fws) == 5 and all(w.endswith('+ "\\r\\n"') for w in fws),
          "ogni FileWriteString chiude la riga con CRLF (%d scritture)" % len(fws), bag, quiet=quiet)
    # strutture: azzeramento completo
    for st, fz, var in (("TelSegnale", "TelAzzeraSegnale", "s"), ("TelViola", "TelAzzeraViola", "v")):
        mem = membri(struttura(src, st))
        manc = [m for m in mem if not re.search(r"\b%s\.%s\s*=" % (var, m), fn.get(fz, ""))]
        check(len(mem) > 10 and not manc, "%s azzera tutti i %d membri di %s %s" % (fz, len(mem), st, manc), bag, quiet=quiet)
    # costanti del percorso = spec
    for nome, val in (("TEL_M1_MINUTI", "180"), ("TEL_H1_DA", "3"), ("TEL_H1_A", "119")):
        check(re.search(r"(?m)^#define %s\s+%s\b" % (nome, val), src) is not None, "#define %s %s (spec par. 3)" % (nome, val), bag, quiet=quiet)
    lett = set(re.findall(r'"((?:BLOCK|SKIP)_\w+|OPENED|NON_RISOLTO|ATTESA|INVIO)"', "".join(corpi_tel)))
    check(lett <= ESITI and {"OPENED", "BLOCK_MAXTRADES", "BLOCK_HASOPEN", "BLOCK_ATR"} <= lett,
          "esiti usati = dichiarati (%s)" % sorted(lett - ESITI), bag, quiet=quiet)
    check(not re.search(r"\bTimeGMT\b", maschera("".join(corpi_tel))), "orologio: nessun TimeGMT nelle Tel* (colonne *_utc vuote)", bag, quiet=quiet)
    # input
    io, inew = inputs(old), inputs(src)
    atteso = dict(io)
    atteso.update(INPUT_CAMBIATI)
    atteso.update(INPUT_NUOVI)
    diff_in = sorted(k for k in set(atteso) | set(inew) if atteso.get(k) != inew.get(k))
    check(not diff_in, "input: identici a ABTG_Bulge tranne InpMagic/InpComment, + InpTelemetria=false (%d input) %s"
          % (len(inew), ["%s: atteso %s, trovato %s" % (k, atteso.get(k), inew.get(k)) for k in diff_in]), bag, quiet=quiet)
    mg = inew.get("InpMagic", ("", ""))[1]
    altri = magic_libero(mg) if re.fullmatch(r"\d+", mg) else ["(magic non numerico)"]
    check(not altri, "magic %s assente da tutto il repo fuori dai file di questa copia (git grep --untracked) %s" % (mg, altri[:5]), bag, quiet=quiet)
    blocco = mg[:4] if len(mg) == 6 else "?"
    altri_b = magic_libero("%s[0-9]{2}" % blocco) if blocco != "?" else ["?"]
    check(not altri_b, "blocco %sxx assente da tutto il repo %s" % (blocco, altri_b[:5]), bag, quiet=quiet)
    com = inew.get("InpComment", ("", '""'))[1].strip('"')
    check(com not in ("BULGE", "BULGE_AZZURRA", "BULGE_V520_FT") and not any(t in com for t in ("_BLU_", "_VIOLA_", "_ARANCIO_", "AZZURRA"))
          and len(com + "_ARANCIO_S") <= 31, "commento '%s' diverso da originale/AZZURRA, senza tag, <= 31 caratteri col suffisso" % com, bag, quiet=quiet)
    # Guardian prima di ogni invio
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
    check(invii == 2, "esattamente 2 invii di apertura, in OpenOrder (%d)" % invii, bag, quiet=quiet)
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
            check(False, "PrintFormat riga %d: %d segnaposto, %d argomenti" % (src[:i].count("\n") + 1, n, len(args) - 1), bag, quiet=quiet)
    check(nfmt >= 20, "PrintFormat/StringFormat controllati: %d" % nfmt, bag, quiet=quiet)
    return src


# ===========================================================================
# C++: shim, estrazione, driver
# ===========================================================================
SHIM_COMUNE = r"""
#include <cmath>
#include <cstdio>
#include <cstdlib>
#include <ctime>
#include <string>
#include <vector>
#include <initializer_list>
#include <iostream>
#include <fstream>
#include <sstream>
typedef std::string string;
typedef long long datetime;      // ulong e uint arrivano gia' da <sys/types.h> (64 e 32 bit su Linux x86_64)
struct Arr {
  std::vector<double> v;
  Arr() {}
  Arr(std::initializer_list<double> l) : v(l) {}
  void chk(int i) const { if(i < 0 || i >= (int)v.size()) { std::printf("OOR %d %d\n", i, (int)v.size()); std::fflush(stdout); std::exit(3); } }
  double &operator[](int i) { chk(i); return v[i]; }
  const double &operator[](int i) const { chk(i); return v[i]; }
};
template<class T> struct Vec {
  std::vector<T> v;
  void chk(int i) const { if(i < 0 || i >= (int)v.size()) { std::printf("OOR vec %d %d\n", i, (int)v.size()); std::fflush(stdout); std::exit(3); } }
  T &operator[](int i) { chk(i); return v[i]; }
  const T &operator[](int i) const { chk(i); return v[i]; }
};
template<class T> static int ArrayResize(Vec<T> &a, int n, int r = 0) { (void)r; if(n < 0) n = 0; a.v.resize(n); return n; }
template<class T> static int ArraySize(const Vec<T> &a) { return (int)a.v.size(); }
static bool ArraySetAsSeries(Arr &, bool) { return true; }
#define INVALID_HANDLE (-1)
static double MathAbs(double x) { return std::fabs(x); }
template<class A, class B> static auto MathMax(A a, B b) -> decltype(a + b) { return a > b ? a : b; }
template<class A, class B> static auto MathMin(A a, B b) -> decltype(a + b) { return a < b ? a : b; }
static double MathFloor(double x) { return std::floor(x); }
static double MathRound(double x) { return std::round(x); }
static double NormalizeDouble(double x, int d) { double p = std::pow(10.0, d); return std::round(x * p) / p; }
static int StringFind(const string &s, const string &t, int st = 0) { size_t p = s.find(t, st); return p == string::npos ? -1 : (int)p; }
static int StringLen(const string &s) { return (int)s.size(); }
static string StringSubstr(const string &s, int st, int len = -1) { if(st >= (int)s.size()) return ""; return len < 0 ? s.substr(st) : s.substr(st, len); }
static string DoubleToString(double v, int d = 8) { char b[96]; std::snprintf(b, 96, "%.*f", d, v); return b; }
static string IntegerToString(long long v) { return std::to_string(v); }
#define TIME_DATE 1
#define TIME_MINUTES 2
#define TIME_SECONDS 4
static string TimeToString(datetime t, int f = TIME_DATE | TIME_MINUTES) {
  time_t tt = (time_t)t; struct tm g; gmtime_r(&tt, &g); char b[48];
  if(f & TIME_SECONDS) std::snprintf(b, 48, "%04d.%02d.%02d %02d:%02d:%02d", g.tm_year + 1900, g.tm_mon + 1, g.tm_mday, g.tm_hour, g.tm_min, g.tm_sec);
  else std::snprintf(b, 48, "%04d.%02d.%02d %02d:%02d", g.tm_year + 1900, g.tm_mon + 1, g.tm_mday, g.tm_hour, g.tm_min);
  return b; }
template<typename... T> static void Print(T... a) { std::ostringstream o; o.precision(10); (void)std::initializer_list<int>{(o << a, 0)...}; std::printf("PRINT %s\n", o.str().c_str()); }
template<typename... T> static void PrintFormat(T...) {}
static void SendNotification(const string &) {}
int    BB_Period = 20; double BB_Deviation = 2.0; int ATR_Period = 14; double SL_ATR_Mult = 3.0;
int    BB_Width_Len = 50; double Bulge_Multi = 1.1; int Lookback_Bars = 20;
bool   Use_Orange = false, Use_Blue = false, Use_Purple = true, Use_Purple_PineReaction = false;
int    Signal_Bar_Offset = 1;
bool   Use_ATR_Filter = true; int ATR_MA_Len = 20; double ATR_Max_Mult = 1.8, ATR_Min_Mult = 0.5;
bool   Use_ADX_Filter = false; int ADX_Period = 14; double ADX_Threshold = 30.0;
bool   ADX_Apply_On_Blue = true, ADX_Apply_On_Purple = false, ADX_Apply_On_Orange = false;
bool   Use_News_Filter = false;
bool   Enable_Partial_Close = false, Manage_Manual_Orders = false;
int    Risk_Mode = 0; double Risk_Percent = 0.8, Total_Risk_Percent = 2.0; int Max_Trades = 4;
#define RISK_PER_TRADE 0
#define RISK_TOTAL_CAP 1
long   InpMagic = 799601; string InpComment = "BULGE_V520_FT";
bool   InpUsaGuardian = true, InpVerbose = true, InpAutoTest = false, InpTelemetria = true;
string g_symbols[1] = {"NZDCHF"}; int g_symbolCount = 1; datetime g_lastBarTime[1] = {0}; int g_sigOff = 1;
double gDayStartEquity = 0, gDayMinEquity = 0, gWorstDayPct = 0; int gDayEqStamp = -1;
string _Symbol = "NZDCHF";
enum { DEAL_REASON_CLIENT = 0, DEAL_REASON_MOBILE, DEAL_REASON_WEB, DEAL_REASON_EXPERT, DEAL_REASON_SL, DEAL_REASON_TP, DEAL_REASON_SO };
struct MqlRates { datetime time; double open, high, low, close; long long tick_volume; int spread; long long real_volume; };
"""

SHIM_TERM = r"""
enum { SYMBOL_ASK = 1, SYMBOL_BID, SYMBOL_POINT, SYMBOL_TRADE_TICK_VALUE, SYMBOL_TRADE_TICK_SIZE, SYMBOL_VOLUME_STEP, SYMBOL_VOLUME_MIN, SYMBOL_VOLUME_MAX };
enum { SYMBOL_DIGITS = 20, SYMBOL_FILLING_MODE, SYMBOL_TRADE_STOPS_LEVEL, SYMBOL_SPREAD };
#define SYMBOL_FILLING_FOK 1
#define SYMBOL_FILLING_IOC 2
typedef int ENUM_ORDER_TYPE_FILLING;
#define ORDER_FILLING_FOK 0
#define ORDER_FILLING_IOC 1
#define ORDER_FILLING_RETURN 2
enum { ACCOUNT_BALANCE = 1, ACCOUNT_EQUITY };
enum { POSITION_MAGIC = 1, POSITION_TYPE, POSITION_IDENTIFIER, POSITION_TICKET, POSITION_TIME };
enum { POSITION_PRICE_OPEN = 10, POSITION_VOLUME, POSITION_SL, POSITION_TP };
enum { POSITION_SYMBOL = 20, POSITION_COMMENT };
#define POSITION_TYPE_BUY 0
#define POSITION_TYPE_SELL 1
#define PERIOD_M1 1
#define PERIOD_H1 16385
enum { DEAL_ENTRY_IN = 0, DEAL_ENTRY_OUT, DEAL_ENTRY_INOUT, DEAL_ENTRY_OUT_BY };
enum { DEAL_TIME = 1, DEAL_ENTRY, DEAL_REASON, DEAL_MAGIC, DEAL_POSITION_ID, DEAL_TYPE };
enum { DEAL_PRICE = 10, DEAL_PROFIT, DEAL_COMMISSION, DEAL_SWAP, DEAL_VOLUME };
enum { DEAL_COMMENT = 20, DEAL_SYMBOL };
#define FILE_WRITE 2
#define FILE_TXT 16
#define FILE_ANSI 32
#define FILE_COMMON 4096
#define MQL_PROGRAM_NAME 0
struct MqlDateTime { int year, mon, day, hour, min, sec, day_of_week, day_of_year; };
struct Pos { ulong ticket; long id; string sym; long magic; string comment; int type; datetime time; double price, vol, sl, tp; };
struct Deal { ulong ticket; long posid; int entry; datetime time; double price; int reason; string comment; double commission, swap, profit; };
struct Term {
  double ask = 1.0, bid = 1.0, point = 0.00001, tv = 1.0, ts = 0.00001, vstep = 0.01, vmin = 0.01, vmax = 100.0, bal = 10000.0;
  int digits = 5; bool canOpen = true, news = false, atrOk = true, guard = true, rejV = false, rejAll = false;
  double adx = -1.0, adxTel = 20.0, widthMA = 0.015, commIn = -0.5;
  datetime now = 0, bar = 0;
  int n = 0; std::vector<double> H, L, O, C, U, W, B, A;
  std::vector<Pos> pos; int sel = -1; std::vector<Deal> deals; std::vector<int> hsel;
  ulong nextTicket = 1000, nextDeal = 50000;
  std::vector<MqlRates> m1, h1; std::vector<double> h1mid, h1atr;
  std::vector<string> fnames, fdata;
} S;
Vec<int> g_hBands, g_hATR, g_hADX;
double SymbolInfoDouble(const string &, int p) {
  switch(p) { case SYMBOL_ASK: return S.ask; case SYMBOL_BID: return S.bid; case SYMBOL_POINT: return S.point;
    case SYMBOL_TRADE_TICK_VALUE: return S.tv; case SYMBOL_TRADE_TICK_SIZE: return S.ts; case SYMBOL_VOLUME_STEP: return S.vstep;
    case SYMBOL_VOLUME_MIN: return S.vmin; case SYMBOL_VOLUME_MAX: return S.vmax; } return 0.0; }
long long SymbolInfoInteger(const string &, int p) { if(p == SYMBOL_DIGITS) return S.digits; if(p == SYMBOL_FILLING_MODE) return 1; return 0; }
double AccountInfoDouble(int) { return S.bal; }
datetime TimeCurrent() { return S.now; }
void TimeToStruct(datetime t, MqlDateTime &d) { time_t tt = (time_t)t; struct tm g; gmtime_r(&tt, &g);
  d.year = g.tm_year + 1900; d.mon = g.tm_mon + 1; d.day = g.tm_mday; d.hour = g.tm_hour; d.min = g.tm_min; d.sec = g.tm_sec; d.day_of_week = g.tm_wday; d.day_of_year = g.tm_yday; }
datetime iTime(const string &, int, int) { return S.bar; }
int PositionsTotal() { return (int)S.pos.size(); }
ulong PositionGetTicket(int i) { if(i < 0 || i >= (int)S.pos.size()) { S.sel = -1; return 0; } S.sel = i; return S.pos[i].ticket; }
bool PositionSelectByTicket(ulong t) { for(int i = 0; i < (int)S.pos.size(); i++) if(S.pos[i].ticket == t) { S.sel = i; return true; } S.sel = -1; return false; }
long long PositionGetInteger(int p) { if(S.sel < 0) return 0; const Pos &q = S.pos[S.sel];
  switch(p) { case POSITION_MAGIC: return q.magic; case POSITION_TYPE: return q.type; case POSITION_IDENTIFIER: return q.id;
    case POSITION_TICKET: return (long long)q.ticket; case POSITION_TIME: return q.time; } return 0; }
double PositionGetDouble(int p) { if(S.sel < 0) return 0.0; const Pos &q = S.pos[S.sel];
  switch(p) { case POSITION_PRICE_OPEN: return q.price; case POSITION_VOLUME: return q.vol; case POSITION_SL: return q.sl; case POSITION_TP: return q.tp; } return 0.0; }
string PositionGetString(int p) { if(S.sel < 0) return ""; const Pos &q = S.pos[S.sel]; if(p == POSITION_SYMBOL) return q.sym; if(p == POSITION_COMMENT) return q.comment; return ""; }
struct CTradeStub {
  void SetTypeFilling(int) {}
  bool apri(int type, double lots, const string &sym, double price, double sl, double tp, const string &comment) {
    std::printf("SEND %d %s %.17g %.17g %.17g %.17g %s\n", type, sym.c_str(), lots, price, sl, tp, comment.c_str());
    bool viola = comment.find("_VIOLA_") != string::npos;
    if(S.rejAll || (S.rejV && viola)) { std::printf("REJECT\n"); return false; }
    Pos q; q.ticket = S.nextTicket++; q.id = (long)q.ticket; q.sym = sym; q.magic = InpMagic; q.comment = comment; q.type = type;
    q.time = S.now; q.price = price; q.vol = lots; q.sl = sl; q.tp = tp; S.pos.push_back(q);
    Deal d; d.ticket = S.nextDeal++; d.posid = q.id; d.entry = DEAL_ENTRY_IN; d.time = S.now; d.price = price; d.reason = DEAL_REASON_EXPERT;
    d.comment = comment; d.commission = S.commIn; d.swap = 0.0; d.profit = 0.0; S.deals.push_back(d);
    return true; }
  bool Buy(double lots, const string &sym, double price, double sl, double tp, const string &c) { return apri(0, lots, sym, price, sl, tp, c); }
  bool Sell(double lots, const string &sym, double price, double sl, double tp, const string &c) { return apri(1, lots, sym, price, sl, tp, c); }
  string ResultRetcodeDescription() { return "rifiuto"; }
} trade;
bool ABTG_GuardiaIngresso(bool attiva, const string &chi) { std::printf("GUARD %s\n", chi.c_str()); if(!attiva) return true; return S.guard; }
void KillSwitchDailyReset() {}
bool KillSwitchCanTrade() { return S.canOpen; }
bool IsNewsHour() { return S.news; }
void DoPartialCloseIfNeeded() { std::printf("MGMT_PC\n"); }
void ManageManualOrders() { std::printf("MGMT_MAN\n"); }
void ManageBeAndTrailing() { std::printf("MGMT_BE\n"); }
void UpdateAllTP() { std::printf("MGMT_TP\n"); }
static bool cp(const std::vector<double> &src, int start, int count, Arr &dst) {
  if(start < 0 || count < 0 || start + count > (int)src.size()) return false;
  dst.v.assign(src.begin() + start, src.begin() + start + count); return true; }
bool GetBars(string, int count, Arr &h, Arr &l, Arr &o, Arr &c) { return cp(S.H, 0, count, h) && cp(S.L, 0, count, l) && cp(S.O, 0, count, o) && cp(S.C, 0, count, c); }
bool GetBBSeries(int, int start, int count, Arr &u, Arr &l, Arr &b) { return cp(S.U, start, count, u) && cp(S.W, start, count, l) && cp(S.B, start, count, b); }
bool GetBB(int, int idx, double &u, double &l, double &b) { if(idx < 0 || idx >= S.n) return false; u = S.U[idx]; l = S.W[idx]; b = S.B[idx]; return true; }
bool GetATRSeries(int, int start, int count, Arr &a) { return cp(S.A, start, count, a); }
double GetATR(int, int idx = 1) { if(idx < 0 || idx >= S.n) return 0.0; return S.A[idx]; }
bool AtrOk(int) { return S.atrOk; }
double GetBBWidthMA(int) { return S.widthMA; }
double GetADX(int, int = 1) { return S.adx; }
int CopyBuffer(int h, int, int, int count, Arr &a) { if(h != 303) return -1; a.v.assign(count, S.adxTel); return count; }
int CopyBuffer(int h, int, datetime x, datetime z, Arr &a) {
  if(h != 101 && h != 202) return -1; a.v.clear();
  for(size_t i = 0; i < S.h1.size(); i++) if(S.h1[i].time >= x && S.h1[i].time <= z) a.v.push_back(h == 101 ? S.h1mid[i] : S.h1atr[i]);
  return (int)a.v.size(); }
int CopyTime(const string &, int, datetime x, datetime z, Vec<datetime> &o) { o.v.clear();
  for(size_t i = 0; i < S.h1.size(); i++) if(S.h1[i].time >= x && S.h1[i].time <= z) o.v.push_back(S.h1[i].time); return (int)o.v.size(); }
int CopyRates(const string &, int tf, datetime x, datetime z, Vec<MqlRates> &o) { o.v.clear();
  const std::vector<MqlRates> &src = (tf == PERIOD_M1) ? S.m1 : S.h1;
  for(size_t i = 0; i < src.size(); i++) if(src[i].time >= x && src[i].time <= z) o.v.push_back(src[i]); return (int)o.v.size(); }
int iBarShift(const string &, int, datetime t, bool) { int nOk = 0, j = -1;
  for(size_t i = 0; i < S.h1.size(); i++) { if(S.h1[i].time <= S.now) nOk++; if(S.h1[i].time <= t) j = (int)i; }
  if(j < 0) return -1; return nOk - 1 - j; }
bool HistorySelectByPosition(long id) { S.hsel.clear(); for(size_t i = 0; i < S.deals.size(); i++) if(S.deals[i].posid == id) S.hsel.push_back((int)i); return true; }
int HistoryDealsTotal() { return (int)S.hsel.size(); }
ulong HistoryDealGetTicket(int i) { if(i < 0 || i >= (int)S.hsel.size()) return 0; return S.deals[S.hsel[i]].ticket; }
static const Deal *trovaDeal(ulong t) { for(size_t i = 0; i < S.deals.size(); i++) if(S.deals[i].ticket == t) return &S.deals[i]; return 0; }
long long HistoryDealGetInteger(ulong t, int p) { const Deal *d = trovaDeal(t); if(!d) return 0;
  switch(p) { case DEAL_TIME: return d->time; case DEAL_ENTRY: return d->entry; case DEAL_REASON: return d->reason; case DEAL_POSITION_ID: return d->posid; } return 0; }
double HistoryDealGetDouble(ulong t, int p) { const Deal *d = trovaDeal(t); if(!d) return 0.0;
  switch(p) { case DEAL_PRICE: return d->price; case DEAL_PROFIT: return d->profit; case DEAL_COMMISSION: return d->commission; case DEAL_SWAP: return d->swap; } return 0.0; }
string HistoryDealGetString(ulong t, int p) { const Deal *d = trovaDeal(t); if(!d) return ""; if(p == DEAL_COMMENT) return d->comment; return ""; }
int FileOpen(const string &name, int flags) { S.fnames.push_back(name + "|" + std::to_string(flags)); S.fdata.push_back(""); std::printf("FOPEN %s %d\n", name.c_str(), flags); return 10 + (int)S.fnames.size() - 1; }
unsigned int FileWriteString(int h, const string &s) { int k = h - 10; if(k < 0 || k >= (int)S.fdata.size()) { std::printf("FWBAD %d\n", h); return 0; } S.fdata[k] += s; return (unsigned int)s.size(); }
void FileClose(int h) { std::printf("FCLOSE %d\n", h); }
int GetLastError() { return 0; }
string MQLInfoString(int) { return "ABTG_Bulge_Telemetria"; }
int iADX(const string &, int, int) { return 303; }
bool IndicatorRelease(int) { return true; }
"""

SHIM_RAW = r"""
struct Scn { int n = 0; std::vector<double> H, L, O, C, U, W, B, A; double widthMA = 1.0; bool atrOk = true; double adx = -1.0; } S;
static bool cp(const std::vector<double> &src, int start, int count, Arr &dst) {
  if(start < 0 || count < 0 || start + count > (int)src.size()) return false;
  dst.v.assign(src.begin() + start, src.begin() + start + count); return true; }
bool GetBars(string, int count, Arr &h, Arr &l, Arr &o, Arr &c) { return cp(S.H, 0, count, h) && cp(S.L, 0, count, l) && cp(S.O, 0, count, o) && cp(S.C, 0, count, c); }
bool GetBBSeries(int, int start, int count, Arr &u, Arr &l, Arr &b) { return cp(S.U, start, count, u) && cp(S.W, start, count, l) && cp(S.B, start, count, b); }
bool GetBB(int, int idx, double &u, double &l, double &b) { if(idx < 0 || idx >= S.n) return false; u = S.U[idx]; l = S.W[idx]; b = S.B[idx]; return true; }
bool GetATRSeries(int, int start, int count, Arr &a) { return cp(S.A, start, count, a); }
double GetATR(int, int idx = 1) { if(idx < 0 || idx >= S.n) return 0.0; return S.A[idx]; }
bool AtrOk(int) { return S.atrOk; }
double GetBBWidthMA(int) { return S.widthMA; }
double GetADX(int, int = 1) { return S.adx; }
void OpenOrder(string sym, bool isLong, double atr, double bbBasis, string comment) {
  std::printf("ORD %d %.17g %.17g %s\n", isLong ? 1 : 0, atr, bbBasis, comment.c_str()); }
"""

DRIVER_RAW = r"""
#include "shim.h"
#include "pure.h"
static std::vector<double> rd(int n) { std::vector<double> v(n); for(int i = 0; i < n; i++) std::cin >> v[i]; return v; }
int main() {
  std::string cmd;
  while(std::cin >> cmd) {
    if(cmd == "CFG") {
      int a, b, c, d, e, f, g, j, k, l; double t;
      std::cin >> a >> b >> c >> d >> e >> f >> g >> t >> j >> k >> l;
      g_sigOff = a; Lookback_Bars = b; Use_Orange = c; Use_Blue = d; Use_Purple = e; Use_Purple_PineReaction = f;
      Use_ADX_Filter = g; ADX_Threshold = t; ADX_Apply_On_Blue = j; ADX_Apply_On_Purple = k; ADX_Apply_On_Orange = l;
    } else if(cmd == "SCN") {
      std::string id; std::cin >> id >> S.n >> S.widthMA >> S.atrOk >> S.adx;
      S.H = rd(S.n); S.L = rd(S.n); S.O = rd(S.n); S.C = rd(S.n); S.U = rd(S.n); S.W = rd(S.n); S.B = rd(S.n); S.A = rd(S.n);
      std::printf("BEGIN %s\n", id.c_str());
      CheckSignal(0);
      TelViola v; bool ok = TelValutaViola(0, v);
      std::printf("TV %d %d %d %.17g %.17g %.17g %.17g %.17g %d %d %.17g %.17g %.17g %.17g %.17g %.17g %.17g %.17g\n", ok ? 1 : 0,
        v.okL ? 1 : 0, v.okS ? 1 : 0, v.atrSig, v.bbMidCnf, v.bbUpCnf, v.bbLoCnf, v.widthRatio, v.relDown, v.relUp,
        v.cO, v.cH, v.cL, v.cC, v.sO, v.sH, v.sL, v.sC);
      std::printf("AB %d %d\n", TelAdxBlocca(0) ? 1 : 0, AdxFilterOk(0, "NZDCHF", "VIOLA") ? 1 : 0);
      std::printf("END\n");
    }
  }
  return 0;
}
"""

DRIVER_TERM = r"""
#include "shim.h"
#include "pure.h"
static std::vector<double> rd(int n) { std::vector<double> v(n); for(int i = 0; i < n; i++) std::cin >> v[i]; return v; }
static void reset() {
  S.pos.clear(); S.deals.clear(); S.hsel.clear(); S.sel = -1; S.nextTicket = 1000; S.nextDeal = 50000;
  S.m1.clear(); S.h1.clear(); S.h1mid.clear(); S.h1atr.clear(); S.fnames.clear(); S.fdata.clear();
  g_lastBarTime[0] = 0;
  g_hBands.v.assign(1, 101); g_hATR.v.assign(1, 202); g_hADX.v.assign(1, -1);
#ifdef NUOVO
  TelAzzeraStato(); g_telHAdx.v.assign(1, 303); g_telAdxProprio.v.assign(1, 0); g_telPathH = INVALID_HANDLE;
#endif
}
int main() {
  std::string cmd;
  reset();
  while(std::cin >> cmd) {
    if(cmd == "RESET") { reset(); }
    else if(cmd == "CFG") {
      int a, b, c, d, e, f, g, j, k, l, mt, un, tel, vb, at; double t; std::string sym;
      std::cin >> a >> b >> c >> d >> e >> f >> g >> t >> j >> k >> l >> mt >> un >> tel >> vb >> at >> sym;
      g_sigOff = a; Lookback_Bars = b; Use_Orange = c; Use_Blue = d; Use_Purple = e; Use_Purple_PineReaction = f;
      Use_ADX_Filter = g; ADX_Threshold = t; ADX_Apply_On_Blue = j; ADX_Apply_On_Purple = k; ADX_Apply_On_Orange = l;
      Max_Trades = mt; Use_News_Filter = un; InpTelemetria = tel; InpVerbose = vb; InpAutoTest = at; g_symbols[0] = sym; _Symbol = sym;
    }
    else if(cmd == "MAG") { std::cin >> InpMagic >> InpComment; }
    else if(cmd == "PX") { std::cin >> S.ask >> S.bid >> S.digits >> S.point >> S.tv >> S.ts >> S.vstep >> S.vmin >> S.vmax >> S.bal; }
    else if(cmd == "ST") { std::cin >> S.canOpen >> S.news >> S.atrOk >> S.adx >> S.adxTel >> S.guard >> S.rejV >> S.rejAll >> S.widthMA;
#ifdef NUOVO
      if(S.adxTel < 0) g_telHAdx.v.assign(1, -1); else g_telHAdx.v.assign(1, 303);
#endif
    }
    else if(cmd == "TIME") { std::cin >> S.now >> S.bar; }
    else if(cmd == "NOW") { std::cin >> S.now; }
    else if(cmd == "POS") { Pos q; std::cin >> q.sym >> q.magic >> q.comment >> q.type >> q.price >> q.sl >> q.vol;
      q.ticket = S.nextTicket++; q.id = (long)q.ticket; q.time = S.now; q.tp = 0.0; S.pos.push_back(q); }
    else if(cmd == "DELPOS") { std::string sym; std::cin >> sym; std::vector<Pos> k; for(auto &q : S.pos) if(q.sym != sym) k.push_back(q); S.pos = k; }
    else if(cmd == "SCN") { std::cin >> S.n; S.H = rd(S.n); S.L = rd(S.n); S.O = rd(S.n); S.C = rd(S.n); S.U = rd(S.n); S.W = rd(S.n); S.B = rd(S.n); S.A = rd(S.n); }
    else if(cmd == "ID") { std::string id; std::cin >> id; std::printf("BEGIN %s\n", id.c_str()); }
    else if(cmd == "TICK") { OnTick(); std::printf("ENDTICK\n"); }
    else if(cmd == "BOOK") { for(auto &q : S.pos) std::printf("P %llu %ld %s %ld %s %d %.17g %.17g %.17g %.17g\n", q.ticket, q.id, q.sym.c_str(), q.magic, q.comment.c_str(), q.type, q.price, q.sl, q.tp, q.vol); std::printf("END\n"); }
    else if(cmd == "CLOSE") { long id; datetime t; double px, prof, comm, sw; int reason; std::string com;
      std::cin >> id >> t >> px >> reason >> com >> prof >> comm >> sw;
      for(auto &c : com) if(c == '~') c = ' ';
      std::vector<Pos> k; for(auto &q : S.pos) if(q.id != id) k.push_back(q); S.pos = k;
      Deal d; d.ticket = S.nextDeal++; d.posid = id; d.entry = DEAL_ENTRY_OUT; d.time = t; d.price = px; d.reason = reason; d.comment = com;
      d.commission = comm; d.swap = sw; d.profit = prof; S.deals.push_back(d); }
    else if(cmd == "DEAL") { long id; datetime t; double px, prof, comm, sw; int reason; std::string com;
      std::cin >> id >> t >> px >> reason >> com >> prof >> comm >> sw;
      for(auto &c : com) if(c == '~') c = ' ';
      Deal d; d.ticket = S.nextDeal++; d.posid = id; d.entry = DEAL_ENTRY_OUT; d.time = t; d.price = px; d.reason = reason; d.comment = com;
      d.commission = comm; d.swap = sw; d.profit = prof; S.deals.push_back(d); }
    else if(cmd == "M1") { int n; std::cin >> n; for(int i = 0; i < n; i++) { MqlRates r; std::cin >> r.time >> r.open >> r.high >> r.low >> r.close >> r.spread; r.tick_volume = 0; r.real_volume = 0; S.m1.push_back(r); } }
    else if(cmd == "H1") { int n; std::cin >> n; for(int i = 0; i < n; i++) { MqlRates r; double md, at; std::cin >> r.time >> r.open >> r.high >> r.low >> r.close >> r.spread >> md >> at; r.tick_volume = 0; r.real_volume = 0; S.h1.push_back(r); S.h1mid.push_back(md); S.h1atr.push_back(at); } }
#ifdef NUOVO
    else if(cmd == "INIT") { TelInit(); }
    else if(cmd == "FINE") { TelScriviFine(); }
    else if(cmd == "DUMPDIR") { std::string dir; std::cin >> dir;
      for(size_t i = 0; i < S.fnames.size(); i++) { std::string nm = S.fnames[i].substr(0, S.fnames[i].find('|'));
        std::ofstream f(dir + "/" + nm, std::ios::binary); f << S.fdata[i]; std::printf("FILE %s %s %d\n", nm.c_str(), S.fnames[i].c_str(), (int)S.fdata[i].size()); } }
    else if(cmd == "REC") {
      for(int j = 0; j < g_telN; j++) { const TelSegnale &s = g_tel[j];
        std::printf("R %d %d %s %d %ld %.17g %.17g %.17g %.17g %d %.17g %.17g %.17g %.17g %ld\n", s.sig_id, s.side, s.outcome.c_str(), s.atr_ok, s.pos_id,
          s.entry_ref_price, s.sl_price, s.tp_ini, s.risk_dist, s.imp_bars_ago, s.adx, s.atr_ratio, s.bb_mid_cnf, s.lots, s.spread_entry_pts); }
      std::printf("C %d %d %d %d %d\n", g_telN, g_telOrfani, g_telDivergenze, g_telNonRisolti, ArraySize(g_telAperti)); }
    else if(cmd == "IB") { int n; std::cin >> n; Vec<datetime> T; T.v.resize(n); for(int i = 0; i < n; i++) std::cin >> T.v[i]; datetime t; std::cin >> t; std::printf("%d\n", TelIndiceBarra1(T, n, t)); }
    else if(cmd == "EOO") { int h, n, mx, il; double lots, ask, bid, sl, tp; std::cin >> h >> n >> mx >> lots >> il >> ask >> bid >> sl >> tp;
      std::printf("%s\n", TelEsitoOpenOrder(h, n, mx, lots, il, ask, bid, sl, tp).c_str()); }
    else if(cmd == "EC") { int c, nw, n, mx, a, x; std::cin >> c >> nw >> n >> mx >> a >> x; std::printf("%s\n", TelEsitoCancelli(c, nw, n, mx, a, x).c_str()); }
    else if(cmd == "MM") { int sd; double e, f, a, r, mfe = 0, mae = 0; std::cin >> sd >> e >> f >> a >> r; TelMfeMae(sd, e, f, a, r, mfe, mae); std::printf("%.17g %.17g\n", mfe, mae); }
    else if(cmd == "AE") { int sd, n; double f, a; std::cin >> sd >> f >> a >> n; for(int i = 0; i < n; i++) { double p; std::cin >> p; TelAggiornaEstremi(sd, p, f, a); } std::printf("%.17g %.17g\n", f, a); }
    else if(cmd == "PIP") { std::string s; std::cin >> s; std::printf("%.17g\n", TelPipSize(s)); }
    else if(cmd == "MOT") { long r; std::string c; std::cin >> r >> c; for(auto &ch : c) if(ch == '~') ch = ' '; std::printf("%s\n", TelMotivoUscita(r, c).c_str()); }
    else if(cmd == "SLTP") { int il, dg; double ask, bid, sd, bb, sl = 0, tp = 0; std::cin >> il >> ask >> bid >> sd >> bb >> dg; TelSlTp(il, ask, bid, sd, bb, dg, sl, tp); std::printf("%.17g %.17g\n", sl, tp); }
    else if(cmd == "AUTOTEST") { std::printf("%d\n", TelAutoTest()); }
    else if(cmd == "HDR") { std::printf("%s\n%s\n", TelIntestazioneSegnali().c_str(), TelIntestazionePath().c_str()); }
    else if(cmd == "EVIOLA") { std::string c; std::cin >> c; std::printf("%d\n", TelEViola(c) ? 1 : 0); }
#endif
  }
  return 0;
}
"""


def to_cxx(block):
    out = re.sub(r"(const\s+)?double\s*&\s*(\w+)\[\]", lambda m: (m.group(1) or "") + "Arr &" + m.group(2), block)
    out = re.sub(r"(const\s+)?datetime\s*&\s*(\w+)\[\]", lambda m: (m.group(1) or "") + "Vec<datetime> &" + m.group(2), out)
    out = re.sub(r"\bdouble\s+(\w+\[\](?:\s*,\s*\w+\[\])*)\s*;",
                 lambda m: "Arr " + m.group(1).replace("[]", "") + ";", out)
    out = re.sub(r"(?m)^(\s*)(datetime|MqlRates|int|long|string|TelSegnale)\s+(\w+)\[\]\s*;", r"\1Vec<\2> \3;", out)
    return out


def firma(fn_txt):
    """prototipo C++ (con i default) e definizione senza i default."""
    code = maschera(fn_txt)
    a = code.index("(")
    b = chiusa(code, a)
    sig = fn_txt[:b + 1]
    proto = sig + ";"
    params = fn_txt[a:b + 1]
    senza = re.sub(r"\s*=\s*[^,)]+", "", params)
    return proto, fn_txt[:a] + senza + fn_txt[b + 1:]


ORIG_FN = ["ExtractSignalTag", "GetFillingMode", "CountOpenTrades", "HasOpenTrade", "CalcLots", "OpenOrder",
           "AdxFilterOk", "PurpleReactionCore", "PurpleReactionOk", "CheckSignal", "OnTick"]


def costruisci(exe_dir, shim, driver, pezzi, nuovo, globali=""):
    cxx = shutil.which("g++") or shutil.which("clang++")
    if not cxx:
        return None, "compilatore C++ assente"
    protos, defs = [], []
    for txt in pezzi:
        t = to_cxx(txt)
        p, d = firma(t)
        protos.append(p)
        defs.append(d)
    pure = to_cxx(globali) + "\n" + "\n".join(protos) + "\n\n" + "\n\n".join(defs)
    for nm, txt in (("shim.h", shim), ("pure.h", pure), ("drv.cpp", driver)):
        with open(os.path.join(exe_dir, nm), "w") as f:
            f.write(txt)
    exe = os.path.join(exe_dir, "drv")
    cmd = [cxx, "-std=c++17", "-O1", "-ffp-contract=off", "-Wall", "-Wno-unused-variable", "-Wno-unused-but-set-variable",
           "-Wno-misleading-indentation", "-Wno-unused-function", "-o", exe, os.path.join(exe_dir, "drv.cpp")]
    if nuovo:
        cmd.insert(1, "-DNUOVO")
    r = subprocess.run(cmd, capture_output=True, text=True)
    if r.returncode != 0:
        return None, r.stderr
    return exe, r.stderr


def esegui(exe, testo):
    r = subprocess.run([exe], input=testo, capture_output=True, text=True)
    if r.returncode != 0:
        return None
    return r.stdout.split("\n")


class Build:
    """i tre eseguibili: RAW (CheckSignal VERA + TelValutaViola), ORIG (terminale finto + originale),
    NEW (terminale finto + copia con le Tel*)."""

    def __init__(self, src_new, src_old, tmp, raw_old_exe=None, orig_exe=None):
        self.ok, self.err = False, ""
        fo, fn = funzioni(src_old), funzioni(src_new)
        try:
            glob = blocco_globali(src_new)
            sv = struttura(src_new, "TelViola")
            d_raw = os.path.join(tmp, "raw")
            os.makedirs(d_raw, exist_ok=True)
            pezzi_raw = [fo[n] for n in ("AdxFilterOk", "PurpleReactionCore", "PurpleReactionOk", "CheckSignal")] + \
                        [fn[n] for n in ("TelAzzeraViola", "TelValutaViola", "TelAdxBlocca")]
            self.raw, e = costruisci(d_raw, SHIM_COMUNE + SHIM_RAW, DRIVER_RAW, pezzi_raw, False, globali=sv)
            if not self.raw:
                self.err = "RAW: " + e
                return
            if orig_exe:
                self.orig = orig_exe
            else:
                d_o = os.path.join(tmp, "orig")
                os.makedirs(d_o, exist_ok=True)
                self.orig, e = costruisci(d_o, SHIM_COMUNE + SHIM_TERM, DRIVER_TERM, [fo[n] for n in ORIG_FN], False)
                if not self.orig:
                    self.err = "ORIG: " + e
                    return
            d_n = os.path.join(tmp, "new")
            os.makedirs(d_n, exist_ok=True)
            tel = sorted(n for n in NUOVE if n in fn)
            self.new, e = costruisci(d_n, SHIM_COMUNE + SHIM_TERM, DRIVER_TERM, [fn[n] for n in ORIG_FN] + [fn[n] for n in tel],
                                     True, globali=glob)
            if not self.new:
                self.err = "NEW: " + e
                return
        except (KeyError, ValueError) as ex:
            self.err = "estrazione fallita: %r" % (ex,)
            return
        self.ok = True


# ===========================================================================
# finestre (stesse costruzioni di collaudo_bulge_azzurra.py) e specchio Python del VIOLA
# ===========================================================================
class Win:
    def __init__(self, n):
        self.n = n
        self.H, self.L, self.O, self.C = [0.0] * n, [0.0] * n, [0.0] * n, [0.0] * n
        self.U, self.W, self.B, self.A = [0.0] * n, [0.0] * n, [0.0] * n, [0.0] * n
        self.widthMA, self.atrOk, self.adx = 0.015, 1, -1.0

    def arrays(self):
        return "\n".join(" ".join(repr(float(x)) for x in arr) for arr in (self.H, self.L, self.O, self.C, self.U, self.W, self.B, self.A)) + "\n"

    def specchio(self):
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


def w_viola_long(n=60, imp=6):
    """VIOLA LONG valido scritto a mano (indici come le serie MT5: 0 = in formazione, 1 = iCnf, 2 = iSig)."""
    w = Win(n)
    for k in range(n):
        w.barra(k, 1.005, 1.005, 1.007, 1.003)
        w.U[k], w.W[k], w.B[k], w.A[k] = 1.010, 0.990, 1.000, 0.004
    w.A[1] = 0.0041                       # ATR della conferma != ATR del segnale
    w.B[1] = 0.9993                       # mediana della conferma != mediana del segnale
    w.barra(imp, 1.000, 0.992, 1.001, 0.989)   # impulso ribassista: tocca 0.990, corpo 0.008
    w.barra(3, 0.998, 1.001, 1.002, 0.997)   # attraversa la mediana
    w.barra(2, 0.999, 0.996, 0.999, 0.995)   # iSig
    w.barra(1, 0.993, 0.991, 0.994, 0.989)   # iCnf: tocca la banda bassa, corpo 0.002
    w.barra(0, 0.991, 0.991, 0.991, 0.991)
    return w


class Cfg:
    def __init__(self, **kw):
        self.off, self.lb, self.orange, self.blue, self.purple, self.pine = 1, 20, 0, 0, 1, 0
        self.adx_use, self.adx_thr, self.a_blue, self.a_purple, self.a_orange = 0, 30.0, 1, 0, 0
        self.maxtr, self.use_news, self.tel, self.verbose, self.autotest, self.sym = 4, 0, 1, 1, 0, "NZDCHF"
        self.__dict__.update(kw)

    def riga_raw(self):
        return "CFG %d %d %d %d %d %d %d %r %d %d %d\n" % (self.off, self.lb, self.orange, self.blue, self.purple, self.pine,
                                                       self.adx_use, self.adx_thr, self.a_blue, self.a_purple, self.a_orange)

    def riga(self, tel=None):
        return "CFG %d %d %d %d %d %d %d %r %d %d %d %d %d %d %d %d %s\n" % (
            self.off, self.lb, self.orange, self.blue, self.purple, self.pine, self.adx_use, self.adx_thr, self.a_blue,
            self.a_purple, self.a_orange, self.maxtr, self.use_news, self.tel if tel is None else tel, self.verbose,
            self.autotest, self.sym)


def py_viola(w, cfg):
    """specchio Python della regola VIOLA (v5.20), scritto dalla regola e non tradotto dal C++."""
    B = cfg.off
    iCnf, iSig = B, B + 1
    N = cfg.lb * 2 + 10 + B
    if w.n < N:
        return None
    atrSig = w.A[iSig]
    if atrSig <= 0 or w.widthMA <= 0:
        return None
    up = dn = -1
    for k in range(iSig, N - 1):
        corpo = abs(w.C[k] - w.O[k])
        if dn < 0 and w.L[k] <= w.W[k] and w.C[k] < w.O[k] and corpo >= w.A[k] * 0.2:
            dn = k
        if up < 0 and w.H[k] >= w.U[k] and w.C[k] > w.O[k] and corpo >= w.A[k] * 0.2:
            up = k
        if dn >= 0 and up >= 0:
            break
    rel_dn = dn - B if dn >= 0 else -1
    rel_up = up - B if up >= 0 else -1

    def mid_opp(imp, lungo):
        mid = opp = False
        if imp > B:
            for k in range(iSig, imp):
                if w.H[k] >= w.B[k] and w.L[k] <= w.B[k]:
                    mid = True
                if (lungo and w.H[k] >= w.U[k]) or (not lungo and w.L[k] <= w.W[k]):
                    opp = True
        return mid, opp
    low_flat = abs(w.W[iSig] - w.W[iSig + 6]) <= atrSig * 0.6
    up_flat = abs(w.U[iSig] - w.U[iSig + 6]) <= atrSig * 0.6
    corpo = w.C[iCnf] - w.O[iCnf]
    reac_l = (corpo > 0) if cfg.pine else abs(corpo) <= atrSig * 1.5
    reac_s = (corpo < 0) if cfg.pine else abs(corpo) <= atrSig * 1.5
    out = []
    m, o = mid_opp(dn, True)
    if 1 <= rel_dn <= cfg.lb * 2 and m and not o and w.L[iCnf] <= w.W[iCnf] and low_flat and reac_l:
        out.append((1, atrSig, w.B[iCnf], rel_dn))
    m, o = mid_opp(up, False)
    if 1 <= rel_up <= cfg.lb * 2 and m and not o and w.H[iCnf] >= w.U[iCnf] and up_flat and reac_s:
        out.append((-1, atrSig, w.B[iCnf], rel_up))
    return {"sides": out, "rel_dn": rel_dn, "rel_up": rel_up, "atr": atrSig, "mid": w.B[iCnf],
            "wr": (w.U[iSig] - w.W[iSig]) / w.widthMA,
            "cnf": (w.O[iCnf], w.H[iCnf], w.L[iCnf], w.C[iCnf]), "sig": (w.O[iSig], w.H[iSig], w.L[iSig], w.C[iSig])}


def serie(seed, n=2500):
    rnd = random.Random(seed)
    o, h, l, c = [], [], [], []
    p, sig = 1.0, 0.002
    for _ in range(n):
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


def finestra(dati, t, n=60):
    o, h, l, c, up, dn, md, at = dati
    w = Win(n)
    for k in range(n):
        j = t - k
        w.O[k], w.H[k], w.L[k], w.C[k] = o[j], h[j], l[j], c[j]
        w.U[k], w.W[k], w.B[k], w.A[k] = up[j], dn[j], md[j], at[j]
    return w


def finestre(semi, con_segnale, a_caso, seed):
    """finestre su random walk: quelle con un VIOLA (a offset 0 o 1, EA o PINE) + alcune a caso."""
    rnd = random.Random(seed)
    sig, altre = [], []
    for s in semi:
        dati = serie(s)
        for t in range(80, len(dati[0])):
            w = finestra(dati, t)
            w.widthMA = 0.004 + 0.02 * rnd.random()
            if any(py_viola(w, Cfg(off=b, pine=p))["sides"] for b in (0, 1) for p in (0, 1)):
                sig.append(w)
            elif rnd.random() < 0.02:
                altre.append(w)
    rnd.shuffle(sig)
    rnd.shuffle(altre)
    return sig[:con_segnale] + altre[:a_caso], len(sig)


# ===========================================================================
# X(1): TelValutaViola contro CheckSignal VERA
# ===========================================================================
def parse_blocchi(lines):
    res, cur = {}, None
    for ln in lines:
        if ln.startswith("BEGIN "):
            cur = ln[6:]
            res[cur] = []
        elif ln == "END":
            cur = None
        elif cur is not None:
            res[cur].append(ln)
        elif ln.startswith("OOR"):
            res.setdefault("__OOR__", []).append(ln)
    return res


def scenari_a_mano():
    """(nome, cfg, finestra, lati attesi) scritti A MANO ai bordi di ogni condizione del VIOLA: sulle finestre casuali
    alcune condizioni (banda piatta, finestra dell'impulso, reazione) non decidono quasi mai."""
    out = []
    c0, cp = Cfg(), Cfg(pine=1)
    out.append(("long_valido", c0, w_viola_long(), [1]))
    out.append(("short_specchiato", c0, w_viola_long().specchio(), [-1]))
    w = w_viola_long(); w.W[8] = 0.980
    out.append(("banda_bassa_non_piatta", c0, w, []))
    out.append(("banda_alta_non_piatta_specchiato", c0, w.specchio(), []))
    w = w_viola_long(); w.W[8] = 0.9876
    out.append(("banda_piatta_al_bordo_0_6_ATR", c0, w, [1]))
    w = w_viola_long(); w.barra(3, 0.998, 0.999, 0.9995, 0.997)
    out.append(("mediana_non_attraversata", c0, w, []))
    out.append(("mediana_non_attraversata_specchiato", c0, w.specchio(), []))
    w = w_viola_long(); w.barra(4, 1.005, 1.004, 1.011, 1.003)
    out.append(("banda_opposta_toccata", c0, w, []))
    w = w_viola_long(); w.barra(1, 0.999, 0.989, 0.999, 0.988)
    out.append(("reazione_impulsiva", c0, w, []))
    out.append(("reazione_impulsiva_specchiato", c0, w.specchio(), []))
    w = w_viola_long(); w.barra(1, 0.993, 0.991, 0.994, 0.9905)
    out.append(("conferma_non_tocca_la_banda", c0, w, []))
    out.append(("impulso_rel_40", c0, w_viola_long(imp=41), [1]))
    out.append(("impulso_rel_41", c0, w_viola_long(imp=42), []))
    out.append(("impulso_rel_41_specchiato", c0, w_viola_long(imp=42).specchio(), []))
    out.append(("pine_candela_rossa", cp, w_viola_long(), []))
    w = w_viola_long(); w.barra(1, 0.990, 0.992, 0.993, 0.989)
    out.append(("pine_candela_verde", cp, w, [1]))
    out.append(("offset0_niente", Cfg(off=0), w_viola_long(), []))
    return out


def x1_raw(b, wins, bag, quiet=False):
    cfgs = [Cfg(), Cfg(pine=1), Cfg(off=0), Cfg(lb=10), Cfg(orange=1, blue=1),
            Cfg(adx_use=1, a_purple=1), Cfg(adx_use=1, a_purple=0), Cfg(adx_use=1, a_purple=1, adx_thr=25.0)]
    rnd = random.Random(777)
    txt = ""
    piano = []
    mano = scenari_a_mano()
    for nome, c, w, _ in mano:
        txt += c.riga_raw() + "SCN m_%s %d %r 1 -1.0\n" % (nome, w.n, w.widthMA) + w.arrays()
    for ci, c in enumerate(cfgs):
        txt += c.riga_raw()
        for i, w in enumerate(wins):
            atr_ok = 1 if rnd.random() < 0.85 else 0
            adx = rnd.choice([-1.0, 15.0, 27.0, 31.0, 45.0])
            nid = "r%d_%d" % (ci, i)
            txt += "SCN %s %d %r %d %r\n" % (nid, w.n, w.widthMA, atr_ok, adx) + w.arrays()
            piano.append((nid, c, w, atr_ok, adx))
    out = esegui(b.raw, txt)
    if out is None:
        check(False, "X1: driver RAW uscito con errore", bag, quiet=quiet)
        return
    res = parse_blocchi(out)
    check("__OOR__" not in res, "X1: nessun indice fuori dagli array", bag, quiet=quiet)
    ko = []
    for nome, c, w, att in mano:
        r = res.get("m_" + nome, [])
        tv = next((ln.split() for ln in r if ln.startswith("TV ")), None)
        ords = [ln.split()[1] for ln in r if ln.startswith("ORD ") and ln.endswith(("_VIOLA_L", "_VIOLA_S"))]
        lati = [] if tv is None else ([1] if tv[2] == "1" else []) + ([-1] if tv[3] == "1" else [])
        lati_cs = [1 if o == "1" else -1 for o in ords]
        if lati != att or lati_cs != att:
            ko.append("%s: telemetria %s, CheckSignal %s, atteso %s" % (nome, lati, lati_cs, att))
    check(not ko, "X1: %d scenari scritti a MANO ai bordi (banda piatta, mediana, banda opposta, reazione, finestra 40/41, PINE, offset): telemetria = CheckSignal = atteso %s"
          % (len(mano), ko[:3]), bag, quiet=quiet)
    dis_cs = dis_py = 0
    tot = {1: 0, -1: 0}
    bloccati_atr = bloccati_adx = 0
    for nid, c, w, atr_ok, adx in piano:
        r = res.get(nid)
        if r is None:
            dis_cs += 1
            continue
        ords = [ln.split() for ln in r if ln.startswith("ORD ") and ln.endswith(("_VIOLA_L", "_VIOLA_S"))]
        tv = next(ln.split() for ln in r if ln.startswith("TV "))
        ab = next(ln.split() for ln in r if ln.startswith("AB "))
        ok, okl, oks = int(tv[1]), int(tv[2]), int(tv[3])
        blocca = int(ab[1])
        # (a) la telemetria dice "blocca ADX" esattamente quando AdxFilterOk dice no
        if blocca != (1 - int(ab[2])):
            dis_cs += 1
        # (b) gli ordini VIOLA di CheckSignal = i lati grezzi della telemetria, se ATR e ADX lasciano passare
        att = []
        if ok and atr_ok and not blocca:
            if okl:
                att.append(("1", float(tv[4]), float(tv[5])))
            if oks:
                att.append(("0", float(tv[4]), float(tv[5])))
        got = [(o[1], float(o[2]), float(o[3])) for o in ords]
        if got != att:
            dis_cs += 1
            if not quiet and dis_cs <= 3:
                print("        X1 disaccordo %s: CheckSignal %s / telemetria %s" % (nid, got, att))
        if (okl or oks) and not atr_ok:
            bloccati_atr += 1
        if (okl or oks) and atr_ok and blocca:
            bloccati_adx += 1
        # (c) specchio Python
        py = py_viola(w, c)
        sides = [s[0] for s in py["sides"]] if py else []
        tsides = ([1] if okl else []) + ([-1] if oks else [])
        for s in tsides:
            tot[s] += 1
        okpy = (bool(py) == bool(ok)) and sides == tsides
        if okpy and py:
            okpy = (abs(float(tv[4]) - py["atr"]) < 1e-15 and abs(float(tv[5]) - py["mid"]) < 1e-15
                    and int(tv[9]) == py["rel_dn"] and int(tv[10]) == py["rel_up"] and abs(float(tv[8]) - py["wr"]) < 1e-12
                    and all(abs(float(tv[11 + i]) - py["cnf"][i]) < 1e-15 for i in range(4))
                    and all(abs(float(tv[15 + i]) - py["sig"][i]) < 1e-15 for i in range(4)))
        if not okpy:
            dis_py += 1
            if not quiet and dis_py <= 3:
                print("        X1 specchio %s: telemetria %s / Python %s" % (nid, tv, py and py["sides"]))
    check(dis_cs == 0, "X1: TelValutaViola == CheckSignal VERA di ABTG_Bulge (ordini VIOLA, ATR, ADX) su %d finestre x %d config (disaccordi %d)"
          % (len(wins), len(cfgs), dis_cs), bag, quiet=quiet)
    check(dis_py == 0, "X1: specchio Python indipendente == TelValutaViola (lati, ATR, mediana, impulso, larghezza, OHLC) (disaccordi %d)" % dis_py, bag, quiet=quiet)
    check(tot[1] >= 20 and tot[-1] >= 20 and bloccati_atr >= 10 and bloccati_adx >= 5,
          "X1 MORDE: VIOLA long %d, short %d; registrati anche se ATR blocca %d, se ADX blocca %d" % (tot[1], tot[-1], bloccati_atr, bloccati_adx),
          bag, quiet=quiet)


# ===========================================================================
# X(2): OnTick differenziale + oracolo degli esiti
# ===========================================================================
def norm(x, d):
    p = 10.0 ** d
    v = abs(x) * p
    r = float(int(v + 0.5))
    return (r if x >= 0 else -r) / p


def py_lots(st, sl_dist):
    risk_amt = st["bal"] * 0.8 / 100.0
    if st["ts"] <= 0 or st["tv"] <= 0 or st["point"] <= 0:
        return 0.01
    sl_points = sl_dist / st["point"]
    lots = risk_amt / (sl_points * st["tv"] / st["ts"] * st["point"])
    step = st["vstep"] if st["vstep"] > 0 else 0.01
    lots = int(lots / step) * step
    return norm(max(st["vmin"], min(st["vmax"], lots)), 2)


def oracolo(c, st, book0, w, sends):
    """esito atteso per ogni lato VIOLA, ricavato dalle REGOLE dell'EA (non dal codice della telemetria).
    `sends` = gli invii dell'ORIGINALE in questo tick (servono a sapere cosa c'era aperto al momento del VIOLA)."""
    py = py_viola(w, c) if c.purple else None
    if not py:
        return []
    res = []
    n0 = sum(1 for p in book0 if p["magic"] == st["magic"])
    ok_prima = [s for s in sends if s["ok"] and "_VIOLA_" not in s["comment"]]
    for side, atr, mid, rel in py["sides"]:
        if not st["canOpen"]:
            e = "BLOCK_KILL"
        elif c.use_news and st["news"]:
            e = "BLOCK_NEWS"
        elif n0 >= c.maxtr:
            e = "BLOCK_MAXTRADES"
        elif not st["atrOk"]:
            e = "BLOCK_ATR"
        elif c.adx_use and c.a_purple and st["adx"] >= 0 and st["adx"] >= c.adx_thr:
            e = "BLOCK_ADX"
        else:
            com = st["comment"] + ("_VIOLA_L" if side > 0 else "_VIOLA_S")
            book = [dict(sym=p["sym"], magic=p["magic"], comment=p["comment"]) for p in book0]
            book += [dict(sym=s["sym"], magic=st["magic"], comment=s["comment"]) for s in ok_prima]
            if side < 0:
                book += [dict(sym=s["sym"], magic=st["magic"], comment=s["comment"]) for s in sends if s["ok"] and s["comment"].endswith("_VIOLA_L")]
            has = any(p["sym"] == c.sym and p["magic"] == st["magic"] and p["comment"] == com for p in book)
            nn = sum(1 for p in book if p["magic"] == st["magic"])
            sl_dist = atr * 3.0
            lots = py_lots(st, sl_dist)
            sl = norm(st["ask"] - sl_dist, st["digits"]) if side > 0 else norm(st["bid"] + sl_dist, st["digits"])
            tp = norm(mid, st["digits"])
            if has:
                e = "BLOCK_HASOPEN"
            elif nn >= c.maxtr:
                e = "BLOCK_MAXTRADES"
            elif lots <= 0:
                e = "SKIP_LOTS"
            elif side > 0 and tp <= st["ask"]:
                e = "SKIP_TP"
            elif side > 0 and sl >= st["ask"]:
                e = "SKIP_SL"
            elif side < 0 and tp >= st["bid"]:
                e = "SKIP_TP"
            elif side < 0 and sl <= st["bid"]:
                e = "SKIP_SL"
            elif not st["guard"] or st["rejAll"] or st["rejV"]:
                e = "BLOCK_GUARDIAN_O_RIFIUTO"
            else:
                e = "OPENED"
        res.append((side, e, atr, mid, rel))
    return res


def scenari_fuzz(wins, seed):
    rnd = random.Random(seed)
    out = []
    t_base = 1790000000 // 3600 * 3600
    for i, w in enumerate(wins):
        c = Cfg(off=rnd.choice([1, 1, 1, 0]), lb=rnd.choice([20, 20, 10]), orange=int(rnd.random() < 0.15),
                blue=int(rnd.random() < 0.3), purple=int(rnd.random() < 0.92), pine=int(rnd.random() < 0.2),
                adx_use=int(rnd.random() < 0.4), adx_thr=rnd.choice([25.0, 30.0]), a_blue=int(rnd.random() < 0.5),
                a_purple=int(rnd.random() < 0.5), a_orange=int(rnd.random() < 0.3), maxtr=rnd.choice([1, 2, 3, 4, 4, 4]),
                use_news=int(rnd.random() < 0.3), sym=rnd.choice(["NZDCHF", "NZDJPY", "EURNZD"]))
        digits = 5 if rnd.random() < 0.8 else 2
        point = 10.0 ** -digits
        base = w.C[0]
        r = rnd.random()
        if digits == 2:
            # a 2 decimali, prezzo lontano dalla mediana: se 3 x ATR < mezzo tick lo SL arrotondato cade
            # SUL prezzo (SKIP_SL) mentre il TP resta dalla parte giusta
            base = w.B[c.off] + rnd.choice([-0.03, 0.03])
        elif r < 0.12:
            base = w.B[c.off] + rnd.uniform(0.0, 0.004)       # sopra la mediana: il long salta il TP
        elif r < 0.24:
            base = w.B[c.off] - rnd.uniform(0.0, 0.004)       # sotto: lo short salta il TP
        bid = norm(base, digits)
        ask = norm(bid + (0 if digits == 2 else rnd.choice([0, 1, 2, 12, 30])) * point, digits)
        st = dict(ask=ask, bid=bid, digits=digits, point=point, tv=rnd.choice([1.0, 0.9, 1.3]), ts=point,
                  vstep=0.01, vmin=0.0 if rnd.random() < 0.3 else 0.01, vmax=100.0,
                  bal=rnd.choice([10000.0, 50.0, 50.0, 160000.0]),
                  canOpen=int(rnd.random() < 0.85), news=int(rnd.random() < 0.2), atrOk=int(rnd.random() < 0.85),
                  adx=rnd.choice([-1.0, 15.0, 29.0, 30.0, 41.0]), adxTel=rnd.choice([-1.0, 22.5, 33.0]),
                  guard=int(rnd.random() < 0.9), rejV=int(rnd.random() < 0.06), rejAll=int(rnd.random() < 0.04),
                  magic=799601, comment="BULGE_V520_FT", now=t_base + i * 3600 + 7, bar=t_base + i * 3600)
        book = []
        for _ in range(rnd.choice([0, 0, 1, 2, 3, 4])):
            book.append(dict(sym="EURUSD", magic=799601, comment="BULGE_V520_FT_BLU_L"))
        if rnd.random() < 0.3:
            book.append(dict(sym="GBPUSD", magic=123, comment="ALTRO"))
        if rnd.random() < 0.25:
            book.append(dict(sym=c.sym, magic=799601, comment="BULGE_V520_FT_VIOLA_" + rnd.choice("LS")))
        if rnd.random() < 0.05:
            book.append(dict(sym=c.sym, magic=4242, comment="BULGE_V520_FT_VIOLA_L"))   # stesso commento, ALTRO magic: non conta
        out.append(("f%d" % i, c, st, book, w))
    return forzati(wins, t_base) + out


def forzati(wins, t_base):
    """scenari FORZATI per gli esiti rari, in TESTA alla lista (cosi' stanno anche nella suite ridotta dei mutanti):
    la copertura non deve dipendere dal caso."""
    out = []
    c0 = Cfg()
    sig = [w for w in wins if py_viola(w, c0) and py_viola(w, c0)["sides"]]
    piccoli = [w for w in sig if py_viola(w, c0)["atr"] * 3.0 < 0.0049]
    base_st = dict(tv=1.0, vstep=0.01, vmin=0.01, vmax=100.0, bal=10000.0, canOpen=1, news=0, atrOk=1, adx=-1.0,
                   adxTel=20.0, guard=1, rejV=0, rejAll=0, magic=799601, comment="BULGE_V520_FT")
    k = 0
    for w in sig[:4]:
        side, atr, mid, rel = py_viola(w, c0)["sides"][0]
        lungo = side > 0
        px = norm(w.C[0], 5)
        for tipo in ("LOTS", "HASOPEN", "TP", "GUARD", "OK"):
            st = dict(base_st)
            st.update(ask=px, bid=px, digits=5, point=1e-05, ts=1e-05, now=t_base + 10 ** 6 + k * 3600 + 7, bar=t_base + 10 ** 6 + k * 3600)
            book = []
            if tipo == "LOTS":
                st.update(bal=1.0, vmin=0.0)
            elif tipo == "HASOPEN":
                book.append(dict(sym=c0.sym, magic=799601, comment="BULGE_V520_FT_VIOLA_" + ("L" if lungo else "S")))
            elif tipo == "TP":
                st.update(ask=norm(mid + (0.002 if lungo else -0.002), 5), bid=norm(mid + (0.002 if lungo else -0.002), 5))
            elif tipo == "GUARD":
                st.update(guard=0)
            out.append(("z%d_%s" % (k, tipo), c0, st, book, w))
            k += 1
    for w in piccoli[:3]:
        side, atr, mid, rel = py_viola(w, c0)["sides"][0]
        px = norm(mid - 0.03 if side > 0 else mid + 0.03, 2)
        st = dict(base_st)
        st.update(ask=px, bid=px, digits=2, point=0.01, ts=0.01, now=t_base + 10 ** 6 + k * 3600 + 7, bar=t_base + 10 ** 6 + k * 3600)
        out.append(("z%d_SL" % k, c0, st, [], w))
        k += 1
    return out


def testo_scenario(nid, c, st, book, w, tel):
    t = "RESET\n" + c.riga(tel=tel) + "MAG %d %s\n" % (st["magic"], st["comment"])
    t += "PX %r %r %d %r %r %r %r %r %r %r\n" % (st["ask"], st["bid"], st["digits"], st["point"], st["tv"], st["ts"],
                                               st["vstep"], st["vmin"], st["vmax"], st["bal"])
    t += "ST %d %d %d %r %r %d %d %d %r\n" % (st["canOpen"], st["news"], st["atrOk"], st["adx"], st["adxTel"], st["guard"],
                                           st["rejV"], st["rejAll"], w.widthMA)
    t += "TIME %d %d\n" % (st["now"], st["bar"])
    for p in book:
        t += "POS %s %d %s 0 1.0 0.9 0.10\n" % (p["sym"], p["magic"], p["comment"])
    t += "SCN %d\n" % w.n + w.arrays()
    t += "ID %s\nTICK\nREC\nBOOK\n" % nid
    return t


def parse_term(lines):
    res, cur = {}, None
    for ln in lines:
        if ln.startswith("BEGIN "):
            cur = ln[6:]
            res[cur] = []
        elif ln == "END":
            cur = None
        elif cur is not None:
            res[cur].append(ln)
        elif ln.startswith("OOR"):
            res.setdefault("__OOR__", []).append(ln)
    return res


def osservabile(righe):
    """cio' che l'EA FA: invii, rifiuti, Guardian (nome normalizzato), stampe, gestione, libro posizioni."""
    out = []
    for ln in righe:
        if ln.startswith(("R ", "C ")):
            continue
        out.append(ln.replace("GUARD ABTG_Bulge_Telemetria", "GUARD ABTG_Bulge"))
    return out


def x2_ontick(b, wins, bag, quiet=False, seed=4242):
    sc = scenari_fuzz(wins, seed)
    t_o = t_n1 = t_n0 = ""
    for nid, c, st, book, w in sc:
        t_o += testo_scenario(nid, c, st, book, w, 0)
        t_n1 += testo_scenario(nid, c, st, book, w, 1)
        t_n0 += testo_scenario(nid, c, st, book, w, 0)
    o_o, o_1, o_0 = esegui(b.orig, t_o), esegui(b.new, t_n1), esegui(b.new, t_n0)
    if o_o is None or o_1 is None or o_0 is None:
        check(False, "X2: un driver del terminale finto e' uscito con errore", bag, quiet=quiet)
        return
    ro, r1, r0 = parse_term(o_o), parse_term(o_1), parse_term(o_0)
    check(not any("__OOR__" in r for r in (ro, r1, r0)), "X2: nessun indice fuori dagli array", bag, quiet=quiet)
    d1 = d0 = rec0 = dis = canar = 0
    conta = {}
    invii_viola = 0
    for nid, c, st, book, w in sc:
        a, x1, x0 = ro.get(nid), r1.get(nid), r0.get(nid)
        if a is None or x1 is None or x0 is None:
            dis += 1
            continue
        if osservabile(a) != osservabile(x1):
            d1 += 1
            if not quiet and d1 <= 3:
                print("        X2 acceso != originale %s:\n          %s\n          %s" % (nid, osservabile(a), osservabile(x1)))
        if osservabile(a) != osservabile(x0):
            d0 += 1
        c0 = next((ln for ln in x0 if ln.startswith("C ")), "C ?")
        if c0.split()[1] != "0":
            rec0 += 1
        sends = []
        for k, ln in enumerate(a):
            if ln.startswith("SEND "):
                p = ln.split()
                ok = not (k + 1 < len(a) and a[k + 1] == "REJECT")
                sends.append(dict(sym=p[2], comment=p[7], ok=ok, price=float(p[4]), sl=float(p[5]), tp=float(p[6])))
                if "_VIOLA_" in p[7]:
                    invii_viola += 1
        att = oracolo(c, st, book, w, sends)
        recs = [ln.split() for ln in x1 if ln.startswith("R ")]
        cl = next((ln.split() for ln in x1 if ln.startswith("C ")), None)
        if cl is None or cl[2:5] != ["0", "0", "0"]:
            canar += 1
        bk = [ln.split() for ln in x1 if ln.startswith("P ")]
        ok_s = len(recs) == len(att)
        for r, e in zip(recs, att):
            side, esito = int(r[2]), r[3]
            conta[esito] = conta.get(esito, 0) + 1
            entry = st["ask"] if side > 0 else st["bid"]
            ok = (side == e[0] and esito == e[1] and int(r[4]) == st["atrOk"] and float(r[6]) == entry
                  and abs(float(r[9]) - e[2] * 3.0) < 1e-15 and int(r[10]) == e[4]
                  and float(r[8]) == norm(e[3], st["digits"]) and abs(float(r[13]) - e[3]) < 1e-15
                  and float(r[11]) == (st["adxTel"] if st["adxTel"] >= 0 else -1.0))
            if esito == "OPENED":
                com = st["comment"] + ("_VIOLA_L" if side > 0 else "_VIOLA_S")
                pos = [p for p in bk if p[5] == com and p[3] == c.sym and int(p[4]) == st["magic"]]
                ok = ok and len(pos) >= 1 and int(r[5]) == int(pos[-1][2]) and float(pos[-1][7]) == entry \
                    and float(pos[-1][8]) == float(r[7]) and float(pos[-1][9]) == float(r[8]) and float(r[14]) == float(pos[-1][10])
            else:
                ok = ok and int(r[5]) == 0
            ok_s = ok_s and ok
        if not ok_s:
            dis += 1
            if not quiet and dis <= 4:
                print("        X2 esito %s: telemetria %s / oracolo %s" % (nid, [(r[2], r[3]) for r in recs], [(e[0], e[1]) for e in att]))
    n = len(sc)
    check(d1 == 0, "X2: InpTelemetria=1 -> stessi invii, Guardian, stampe, gestione e libro posizioni dell'ORIGINALE su %d tick (diversi %d)" % (n, d1), bag, quiet=quiet)
    check(d0 == 0 and rec0 == 0, "X2: InpTelemetria=0 -> identico all'originale e ZERO record (diversi %d, con record %d)" % (d0, rec0), bag, quiet=quiet)
    check(dis == 0, "X2: ogni record ha l'esito dell'oracolo dei cancelli (lato, esito, atr_ok, entrata, R, SL, TP, impulso, adx, pos_id = posizione aperta) (disaccordi %d)" % dis, bag, quiet=quiet)
    check(canar == 0, "X2: canarini orfani/divergenze/non risolti = 0 in tutti gli scenari (scenari con canarino %d)" % canar, bag, quiet=quiet)
    attesi = {"OPENED", "BLOCK_KILL", "BLOCK_NEWS", "BLOCK_MAXTRADES", "BLOCK_ATR", "BLOCK_ADX", "BLOCK_HASOPEN",
              "SKIP_LOTS", "SKIP_TP", "SKIP_SL", "BLOCK_GUARDIAN_O_RIFIUTO"}
    check(attesi <= set(conta) and invii_viola >= 20, "X2 MORDE: tutti gli 11 esiti visti %s, invii VIOLA dell'originale %d"
          % (sorted(conta.items()), invii_viola), bag, quiet=quiet)


# ===========================================================================
# X(3): END-TO-END -> i due CSV -> il lettore esistente
# ===========================================================================
T0 = 1790838000          # 2026.10.01 07:00:00 (giovedi'), ora piena
SPREAD = 12


def prezzo_m(m):
    return 0.99100 + 0.0002 * m


def serie_e2e():
    m1, h1 = [], []
    for m in range(0, 6 * 60 + 200):
        o = round(prezzo_m(m), 5)
        m1.append((T0 + m * 60, o, round(o + 0.00015, 5), round(o - 0.00005, 5), round(o + 0.0002, 5), SPREAD))
    h_ini = T0 - 100 * 3600
    for k in range(0, 100 + 6 + 130):
        t = h_ini + k * 3600
        wd = ((t // 86400) + 4) % 7          # 0 = domenica
        ora = (t % 86400) // 3600
        if (wd == 5 and ora >= 22) or wd == 6 or (wd == 0 and ora < 22):
            continue                         # buco del weekend: le righe mancanti NON si riempiono
        o = round(1.0 + 0.00001 * (k % 7), 5)
        mid = round(0.99930 + 0.00001 * (k % 4), 5)        # varia meno di 5 punti: il TP del lettore non si muove
        atr = 0.004 + 0.000001 * k                           # varia: serve a provare la "barra 1"
        h1.append((t, o, round(o + 0.001, 5), round(o - 0.001, 5), o, SPREAD, mid, atr))
    return m1, h1


def e2e_testo():
    m1, h1 = serie_e2e()
    W = w_viola_long()
    t = "RESET\n" + Cfg(autotest=1, verbose=0).riga(tel=1) + "MAG 775100 BULGE_TEL\n"
    t += "M1 %d\n" % len(m1) + "".join("%d %r %r %r %r %d\n" % x for x in m1)
    t += "H1 %d\n" % len(h1) + "".join("%d %r %r %r %r %d %r %r\n" % x for x in h1)
    t += "PX 0.99112 0.991 5 1e-05 1.0 1e-05 0.01 0.01 100.0 10000.0\n"
    t += "ST 1 0 1 -1.0 22.5 1 0 0 0.015\nTIME %d %d\nINIT\n" % (T0, T0)
    t += "SCN %d\n" % W.n + W.arrays()
    t += "TIME %d %d\nTICK\n" % (T0 + 1, T0)                                     # 1: long aperto
    t += "PX 0.99312 0.993 5 1e-05 1.0 1e-05 0.01 0.01 100.0 10000.0\nNOW %d\nTICK\n" % (T0 + 600)
    t += "PX 0.99062 0.9905 5 1e-05 1.0 1e-05 0.01 0.01 100.0 10000.0\nNOW %d\nTICK\n" % (T0 + 1200)
    t += "DEAL 1000 %d 0.997 %d parziale 1.2 -0.25 0.0\n" % (T0 + 30 * 60, 3)          # uscita PARZIALE (DEAL_REASON_EXPERT = 3)
    t += "CLOSE 1000 %d 0.9993 %d tp~0.99930 4.9 -0.5 -0.1\n" % (T0 + 41 * 60, 5)   # DEAL_REASON_TP = 5
    t += "NOW %d\nTICK\n" % (T0 + 42 * 60)
    S = W.specchio()
    t += "SCN %d\n" % S.n + S.arrays()
    t += "PX 1.01512 1.015 5 1e-05 1.0 1e-05 0.01 0.01 100.0 10000.0\nTIME %d %d\nTICK\n" % (T0 + 7200 + 1, T0 + 7200)   # 2: short
    t += "PX 1.02012 1.019 5 1e-05 1.0 1e-05 0.01 0.01 100.0 10000.0\nNOW %d\nTICK\n" % (T0 + 7200 + 1800)
    t += "CLOSE 1001 %d 1.027 %d sl~1.02700 -7.2 -0.5 0.0\n" % (T0 + 7200 + 59 * 60, 4)  # DEAL_REASON_SL = 4
    t += "NOW %d\nTICK\n" % (T0 + 7200 + 60 * 60)
    t += "SCN %d\n" % W.n + W.arrays()
    t += "PX 0.99112 0.991 5 1e-05 1.0 1e-05 0.01 0.01 100.0 10000.0\n"
    t += "ST 1 0 0 -1.0 22.5 1 0 0 0.015\nTIME %d %d\nTICK\n" % (T0 + 5 * 3600 + 1, T0 + 5 * 3600)      # 3: BLOCK_ATR
    t += "ST 1 0 1 -1.0 22.5 1 0 0 0.015\n"
    for _ in range(4):
        t += "POS EURUSD 775100 BULGE_TEL_BLU_L 0 1.1 1.0 0.1\n"
    t += "TIME %d %d\nTICK\n" % (T0 + 6 * 3600 + 1, T0 + 6 * 3600)                                     # 4: BLOCK_MAXTRADES
    t += "DELPOS EURUSD\nTIME %d %d\nTICK\n" % (T0 + 6 * 3600 + 3600 * 60, T0 + 6 * 3600)           # finestre non ancora chiuse
    t += "TIME %d %d\nTICK\n" % (T0 + 6 * 3600 + 3600 * 121, T0 + 6 * 3600)                         # tutte chiuse: percorso a blocchi
    t += "ID e2e\nREC\nFINE\nDUMPDIR {DIR}\nBOOK\n"
    return t, m1, h1


def leggi_csv(p):
    raw = open(p, "rb").read()
    return raw, raw.decode("ascii", "replace").split("\r\n")


def x3_e2e(b, bag, quiet=False, tmp=None):
    d = tempfile.mkdtemp(prefix="tel_e2e_", dir=tmp)
    t, m1, h1 = e2e_testo()
    out = esegui(b.new, t.replace("{DIR}", d))
    if out is None:
        check(False, "X3: driver END-TO-END uscito con errore", bag, quiet=quiet)
        return
    fs = [f for f in os.listdir(d) if f.startswith("abtg_tel_segnali_")]
    fp = [f for f in os.listdir(d) if f.startswith("abtg_tel_path_")]
    check(fs == ["abtg_tel_segnali_ABTG_Bulge_Telemetria_NZDCHF_775100.csv"] and fp == ["abtg_tel_path_ABTG_Bulge_Telemetria_NZDCHF_775100.csv"],
          "X3: nomi dei file = abtg_tel_{segnali,path}_<EA>_<grafico>_<magic>.csv (%s %s)" % (fs, fp), bag, quiet=quiet)
    if not fs or not fp:
        return
    fl = [ln for ln in out if ln.startswith("FILE ")]
    check(all(("|%d" % (2 | 16 | 32 | 4096)) in ln for ln in fl) and len(fl) == 2,
          "X3: FileOpen con FILE_WRITE|FILE_TXT|FILE_ANSI|FILE_COMMON per i due file", bag, quiet=quiet)
    rs, ls = leggi_csv(os.path.join(d, fs[0]))
    rp, lp = leggi_csv(os.path.join(d, fp[0]))
    sp1, sp2 = colonne_spec()
    for nome, raw, righe in (("segnali", rs, ls), ("path", rp, lp)):
        check(raw.endswith(b"\r\n") and raw.count(b"\n") == raw.count(b"\r\n") and all(x < 128 for x in raw),
              "X3: file %s ASCII, ogni riga chiusa da CRLF" % nome, bag, quiet=quiet)
    check(ls[0].split(";") == sp1, "X3: intestazione dei segnali == le 47 colonne della spec, nell'ordine", bag, quiet=quiet)
    check(lp[0].split(";") == sp2, "X3: intestazione del percorso == le 11 colonne della spec", bag, quiet=quiet)
    sig = [r.split(";") for r in ls[1:] if r]
    pth = [r.split(";") for r in lp[1:] if r]
    check(len(sig) == 4 and all(len(r) == 47 for r in sig), "X3: 4 segnali, 47 campi ciascuno", bag, quiet=quiet)
    check(len(pth) > 0 and all(len(r) == 11 for r in pth), "X3: %d righe di percorso, 11 campi ciascuna" % len(pth), bag, quiet=quiet)
    if len(sig) != 4 or any(len(r) != 47 for r in sig) or any(len(r) != 11 for r in pth):
        return
    S = {c: [r[i] for r in sig] for i, c in enumerate(sp1)}
    check(S["outcome"] == ["OPENED", "OPENED", "BLOCK_ATR", "BLOCK_MAXTRADES"] and S["side"] == ["1", "-1", "1", "1"]
          and S["atr_ok"] == ["1", "1", "0", "1"], "X3: esiti %s, lati %s, atr_ok %s" % (S["outcome"], S["side"], S["atr_ok"]), bag, quiet=quiet)
    check(S["bar_open_time_utc"] == [""] * 4 and S["server_utc_offset_h"] == [""] * 4,
          "X3: orologio: bar_open_time_utc e server_utc_offset_h VUOTE (le calcola lo script offline)", bag, quiet=quiet)
    check(all(x.endswith(":00:00") for x in S["bar_open_time"]) and S["bar_open_time"][0] == "2026.10.01 07:00:00",
          "X3: bar_open_time sull'ora piena, in ora server (%s)" % S["bar_open_time"], bag, quiet=quiet)
    v1 = dict(pos_id="1000", entry_ref_price="0.99112", atr_sig="0.00400000", risk_dist="0.01200000", sl_price="0.97912",
              tp_ini="0.99930", spread_entry_pts="12", point="0.00001", pip_size="0.00010", imp_bars_ago="5",
              cnf_open="0.99300", cnf_low="0.98900", sig_close="0.99600", bb_mid_cnf="0.99930", bb_lo_cnf="0.99000",
              bb_width_ratio="1.333333", lots="0.06", risk_money="72.00", commission="-1.25", swap="-0.10", profit="6.10",
              net="4.75", open_time="2026.10.01 07:00:01", open_price="0.99112", exit_time="2026.10.01 07:41:00",
              exit_price="0.99930", exit_reason="tp", mfe_r="0.6817", mae_r="0.0517", bars_held="1", exit_after_path="0", adx="22.5000")
    bad = ["%s=%s (atteso %s)" % (k, S[k][0], v) for k, v in v1.items() if S[k][0] != v]
    check(not bad, "X3: valori del long OPENED (R, SL, TP, lotti, rischio, somme di TUTTI i deal compreso un parziale, uscita = ULTIMO deal OUT, MFE/MAE) %s" % bad, bag, quiet=quiet)
    v2 = dict(pos_id="1001", entry_ref_price="1.01500", sl_price="1.02700", tp_ini="1.00070", exit_reason="sl",
              exit_time="2026.10.01 09:59:00", exit_price="1.02700", net="-8.20", mfe_r="-0.0100", mae_r="1.0000",
              imp_bars_ago="5", exit_after_path="0", bars_held="1", commission="-1.00", lots="0.06")
    bad = ["%s=%s (atteso %s)" % (k, S[k][1], v) for k, v in v2.items() if S[k][1] != v]
    check(not bad, "X3: valori dello short OPENED (SL raggiunto: mae 1 R; mfe -0,01 R = lo spread, mai in profitto) %s" % bad, bag, quiet=quiet)
    vuote = ["lots", "risk_money", "commission", "net", "open_time", "exit_time", "exit_reason", "mfe_r", "bars_held"]
    check(all(S[k][2] == "" and S[k][3] == "" for k in vuote) and S["pos_id"][2:] == ["0", "0"]
          and S["exit_after_path"][2:] == ["0", "0"] and S["sl_price"][2] == "0.97912",
          "X3: segnali NON aperti: campi della posizione vuoti, pos_id 0, ma SL/TP/R che l'ordine avrebbe", bag, quiet=quiet)
    # percorso
    ids = [int(r[0]) for r in pth]
    check(ids == sorted(ids) and sorted(set(ids)) == [1, 2, 3, 4], "X3: percorso ordinato per sig_id, tutti e 4 i segnali (anche i non aperti)", bag, quiet=quiet)
    t0s = {1: T0, 2: T0 + 7200, 3: T0 + 5 * 3600, 4: T0 + 6 * 3600}
    h1t = [x[0] for x in h1]
    import bisect
    import datetime
    bad = []
    for sid in (1, 2, 3, 4):
        rr = [r for r in pth if int(r[0]) == sid]
        tfs = [r[1] for r in rr]
        km = [int(r[2]) for r in rr if r[1] == "M1"]
        kh = [int(r[2]) for r in rr if r[1] == "H1"]
        if tfs != ["M1"] * len(km) + ["H1"] * len(kh):
            bad.append("sig %d: M1 non tutte prima delle H1" % sid)
        if km != list(range(180)):
            bad.append("sig %d: k M1 %s..%s (%d righe), attese 0..179" % (sid, km[:1], km[-1:], len(km)))
        att_h = [k for k in range(3, 120) if (t0s[sid] + k * 3600) in set(h1t)]
        if kh != att_h or len(att_h) >= 117 or len(att_h) < 60:
            bad.append("sig %d: k H1 %d righe, attese %d (buco del weekend saltato)" % (sid, len(kh), len(att_h)))
        for r in rr:
            tt = int((datetime.datetime.strptime(r[3], "%Y.%m.%d %H:%M:%S") - datetime.datetime(1970, 1, 1)).total_seconds())
            k = int(r[2])
            if tt != t0s[sid] + k * (60 if r[1] == "M1" else 3600):
                bad.append("sig %d %s k %d: t_open %s" % (sid, r[1], k, r[3]))
                break
            j = bisect.bisect_right(h1t, tt) - 1
            mid, atr = h1[j - 1][6], h1[j - 1][7]
            if r[9] != "%.5f" % mid or abs(float(r[10]) - atr) > 5e-9:
                bad.append("sig %d %s k %d: mid1/atr1 %s %s, attesi quelli della barra H1 PRIMA (%s %s)" % (sid, r[1], k, r[9], r[10], mid, atr))
                break
        if rr and rr[0][3] != (datetime.datetime(1970, 1, 1) + datetime.timedelta(seconds=t0s[sid])).strftime("%Y.%m.%d %H:%M:%S"):
            bad.append("sig %d: primo M1 non e' bar_open_time" % sid)
    check(not bad, "X3: percorso: M1 k 0..179 poi H1 k 3..119 (buchi saltati, k nominale), t_open coerente, mid1/atr1 = barra H1 numero 1 %s" % bad[:3],
          bag, quiet=quiet)
    rec = [ln for ln in out if ln.startswith("C ")]
    check(rec and rec[0].split()[2:5] == ["0", "0", "0"], "X3: canarini a zero nella sequenza (%s)" % rec[:1], bag, quiet=quiet)
    # il lettore esistente, solo richiamato
    r = subprocess.run([sys.executable, LETTORE, "--controlla", d], capture_output=True, text=True)
    riga = [ln for ln in r.stdout.split("\n") if ln.startswith("OPENED ")]
    check(r.returncode == 0 and riga == ["OPENED 2, rigioco coincidente 2 (100.0%)"],
          "X3: sim_bulge_viola_uscite.py --controlla sui CSV scritti dal codice vero: %s (uscita %d)" % (riga, r.returncode), bag, quiet=quiet)
    # CONTRO-ESEMPIO: un exit_reason falsato deve farlo cadere
    d2 = tempfile.mkdtemp(prefix="tel_ce_", dir=tmp)
    shutil.copy(os.path.join(d, fp[0]), d2)
    ls2 = list(ls)
    c1 = ls2[1].split(";")
    c1[sp1.index("exit_reason")] = "sl"
    ls2[1] = ";".join(c1)
    with open(os.path.join(d2, fs[0]), "wb") as f:
        f.write("\r\n".join(ls2).encode("ascii"))
    r2 = subprocess.run([sys.executable, LETTORE, "--controlla", d2], capture_output=True, text=True)
    riga2 = [ln for ln in r2.stdout.split("\n") if ln.startswith("OPENED ")]
    check(r2.returncode == 1 and riga2 == ["OPENED 2, rigioco coincidente 1 (50.0%)"],
          "X3: CONTRO-ESEMPIO: exit_reason falsato -> il lettore dice %s e esce con %d (il controllo morde)" % (riga2, r2.returncode),
          bag, quiet=quiet)
    shutil.rmtree(d, ignore_errors=True)
    shutil.rmtree(d2, ignore_errors=True)


# ===========================================================================
# P) FUNZIONI PURE
# ===========================================================================
def p_pure(b, bag, quiet=False):
    rnd = random.Random(99)
    txt = "HDR\nAUTOTEST\n"
    # TelIndiceBarra1 contro bisect
    ib = []
    for _ in range(300):
        n = rnd.randrange(1, 12)
        T = sorted(rnd.sample(range(0, 200), n))
        t = rnd.randrange(-5, 205)
        ib.append((T, t))
        txt += "IB %d %s %d\n" % (n, " ".join(map(str, T)), t)
    # TelEsitoOpenOrder: tavola con i bordi
    eoo = []
    for _ in range(600):
        has, n, mx = rnd.randrange(2), rnd.randrange(0, 6), rnd.randrange(1, 5)
        lots = rnd.choice([0.0, -0.01, 0.01, 0.3])
        il = rnd.randrange(2)
        ask, bid = 1.1000, 1.0998
        sl = rnd.choice([1.0900, ask, bid, 1.1100, 1.0999])
        tp = rnd.choice([1.1100, ask, bid, 1.0900, 1.0999])
        eoo.append((has, n, mx, lots, il, ask, bid, sl, tp))
        txt += "EOO %d %d %d %r %d %r %r %r %r\n" % (has, n, mx, lots, il, ask, bid, sl, tp)
    ec = [(c, nw, n, mx, a, x) for c in (0, 1) for nw in (0, 1) for n in (2, 3, 4, 5) for mx in (3, 4) for a in (0, 1) for x in (0, 1)]
    for e in ec:
        txt += "EC %d %d %d %d %d %d\n" % e
    mm = []
    for _ in range(100):
        sd = rnd.choice([1, -1])
        e, f, a, r = 1.1 + rnd.uniform(-0.01, 0.01), 1.1 + rnd.uniform(-0.01, 0.01), 1.1 + rnd.uniform(-0.01, 0.01), rnd.choice([0.003, 0.0, 0.012])
        mm.append((sd, e, f, a, r))
        txt += "MM %d %r %r %r %r\n" % (sd, e, f, a, r)
    ae = []
    for _ in range(100):
        sd = rnd.choice([1, -1])
        px = [1.1 + rnd.uniform(-0.01, 0.01) for _ in range(rnd.randrange(1, 8))]
        ae.append((sd, px))
        txt += "AE %d %r %r %d %s\n" % (sd, px[0], px[0], len(px), " ".join(map(repr, px)))
    pip = [("NZDJPY", 0.01), ("CHFJPY", 0.01), ("NZDCHF", 0.0001), ("EURGBP", 0.0001)]
    for s, _ in pip:
        txt += "PIP %s\n" % s
    mot = [(4, "sl~1.1", "sl"), (5, "tp~1.1", "tp"), (6, "so", "so"), (3, "~", "ea"), (0, "~", "altro"), (4, "end~of~test", "end"), (3, "end~of~test", "end")]
    for r, c_, _ in mot:
        txt += "MOT %d %s\n" % (r, c_)
    sltp = []
    for _ in range(200):
        il, dg = rnd.randrange(2), rnd.choice([5, 3, 2])
        ask = round(1.0 + rnd.random(), dg) + 0.000000123
        bid = ask - 0.0002
        sd, bb = rnd.uniform(0.0001, 0.02), 1.0 + rnd.random() + 0.0000004567
        sltp.append((il, ask, bid, sd, bb, dg))
        txt += "SLTP %d %r %r %r %r %d\n" % (il, ask, bid, sd, bb, dg)
    ev = [("BULGE_V520_FT_VIOLA_L", 1), ("BULGE_V520_FT_VIOLA_S", 1), ("BULGE_V520_FT_BLU_L", 0), ("BULGE_V520_FT_VIOLA_X", 0),
          ("ALTRO_VIOLA_L", 0), ("BULGE_V520_FT_ARANCIO_S", 0)]
    txt0 = "MAG 799601 BULGE_V520_FT\n" + "".join("EVIOLA %s\n" % c for c, _ in ev) + txt
    out = esegui(b.new, txt0)
    if out is None:
        check(False, "P: driver uscito con errore", bag, quiet=quiet)
        return
    out = [x for x in out if x != ""]
    k = 0
    got = out[k:k + len(ev)]
    k += len(ev)
    check(got == [str(v) for _, v in ev], "P: TelEViola riconosce SOLO <commento>_VIOLA_L/_S (%s)" % got, bag, quiet=quiet)
    sp1, sp2 = colonne_spec()
    check(len(sp1) == 47 and out[k] == ";".join(sp1), "P: TelIntestazioneSegnali == colonne della spec (lette dalla spec: %d)" % len(sp1), bag, quiet=quiet)
    check(len(sp2) == 11 and out[k + 1] == ";".join(sp2), "P: TelIntestazionePath == colonne della spec (%d)" % len(sp2), bag, quiet=quiet)
    k += 2
    check(out[k] == "0", "P: TelAutoTest dell'EA (codice vero, compilato) = 0 falliti (%s)" % out[k], bag, quiet=quiet)
    k += 1
    import bisect
    ko = 0
    for T, t in ib:
        j = bisect.bisect_right(T, t) - 1
        att = j - 1 if j >= 1 else -1
        ko += int(out[k]) != att
        k += 1
    check(ko == 0, "P: TelIndiceBarra1 == bisect (barra PRIMA di quella che contiene t) su %d casi (sbagliati %d)" % (len(ib), ko), bag, quiet=quiet)
    ko = 0
    viste = set()
    for has, n, mx, lots, il, ask, bid, sl, tp in eoo:
        if has:
            a = "BLOCK_HASOPEN"
        elif n >= mx:
            a = "BLOCK_MAXTRADES"
        elif lots <= 0:
            a = "SKIP_LOTS"
        elif il and tp <= ask:
            a = "SKIP_TP"
        elif il and sl >= ask:
            a = "SKIP_SL"
        elif not il and tp >= bid:
            a = "SKIP_TP"
        elif not il and sl <= bid:
            a = "SKIP_SL"
        else:
            a = "INVIO"
        viste.add(a)
        ko += out[k] != a
        k += 1
    check(ko == 0 and len(viste) == 6, "P: TelEsitoOpenOrder == ordine dei return di OpenOrder, bordi esatti compresi (%d casi, sbagliati %d)" % (len(eoo), ko), bag, quiet=quiet)
    ko = 0
    for c, nw, n, mx, a, x in ec:
        att = "BLOCK_KILL" if not c else "BLOCK_NEWS" if nw else "BLOCK_MAXTRADES" if n >= mx else "BLOCK_ATR" if not a else "BLOCK_ADX" if x else "ATTESA"
        ko += out[k] != att
        k += 1
    check(ko == 0, "P: TelEsitoCancelli == ordine dei cancelli di OnTick+CheckSignal (%d combinazioni, sbagliate %d)" % (len(ec), ko), bag, quiet=quiet)
    ko = 0
    for sd, e, f, a, r in mm:
        p = out[k].split()
        k += 1
        ae_, be_ = (0.0, 0.0) if r <= 0 else (sd * (f - e) / r, sd * (e - a) / r)
        ko += abs(float(p[0]) - ae_) > 1e-12 or abs(float(p[1]) - be_) > 1e-12
    check(ko == 0, "P: TelMfeMae in R, segno del lato, rischio 0 -> 0 (%d casi, sbagliati %d)" % (len(mm), ko), bag, quiet=quiet)
    ko = 0
    for sd, px in ae:
        p = out[k].split()
        k += 1
        fav, adv = (max(px), min(px)) if sd > 0 else (min(px), max(px))
        ko += float(p[0]) != fav or float(p[1]) != adv
    check(ko == 0, "P: TelAggiornaEstremi (long: max/min del bid; short: min/max dell'ask) (%d casi, sbagliati %d)" % (len(ae), ko), bag, quiet=quiet)
    got = [float(out[k + i]) for i in range(len(pip))]
    k += len(pip)
    check(got == [v for _, v in pip], "P: TelPipSize (JPY 0,01, altri 0,0001)", bag, quiet=quiet)
    got = out[k:k + len(mot)]
    k += len(mot)
    check(got == [m[2] for m in mot], "P: TelMotivoUscita (sl, tp, so, ea, altro, 'end of test' prima di tutto) %s" % got, bag, quiet=quiet)
    ko = 0
    for il, ask, bid, sd, bb, dg in sltp:
        p = out[k].split()
        k += 1
        sl = norm(ask - sd, dg) if il else norm(bid + sd, dg)
        ko += abs(float(p[0]) - sl) > 1e-12 or abs(float(p[1]) - norm(bb, dg)) > 1e-12
    check(ko == 0, "P: TelSlTp == le due righe di OpenOrder (long da ask, short da bid, TP = mediana normalizzata) (%d casi, sbagliati %d)" % (len(sltp), ko), bag, quiet=quiet)


# ===========================================================================
def suite(raw, old, tmp, bag, quiet=False, ridotto=False, orig_exe=None, wins=None):
    strati = {"S": [], "Z": [], "P": [], "X": []}
    statico(raw, old, strati["S"], quiet=quiet)
    try:
        controlla_zone(old, raw.decode("latin-1"), strati["Z"], quiet=quiet)
    except Exception as ex:          # noqa: BLE001
        strati["Z"].append("zone: %s" % ex)
    b = Build(raw.decode("latin-1"), old, tmp, orig_exe=orig_exe)
    if not b.ok:
        strati["P"].append("compilazione C++ fallita: %s" % b.err[:600])
        strati["X"].append("compilazione C++ fallita")
        if not quiet:
            print("  FAIL compilazione C++: %s" % b.err[:1500])
        return strati, b
    passi = (("P", lambda: p_pure(b, strati["P"], quiet=quiet)),
             ("X", lambda: x1_raw(b, wins[:150] if ridotto else wins, strati["X"], quiet=quiet)),
             ("X", lambda: x2_ontick(b, wins[:300] if ridotto else wins, strati["X"], quiet=quiet)),
             ("X", lambda: x3_e2e(b, strati["X"], quiet=quiet, tmp=tmp)))
    for chi, passo in passi:
        try:
            passo()
        except Exception as ex:          # noqa: BLE001  -- un'eccezione e' un difetto preso, non un crash del collaudo
            strati[chi].append("eccezione: %r" % (ex,))
            if not quiet:
                print("  FAIL eccezione nel collaudo: %r" % (ex,))
    return strati, b


# ===========================================================================
# M) MUTANTI
# ===========================================================================
G = 'if(!ABTG_GuardiaIngresso(InpUsaGuardian, "ABTG_Bulge_Telemetria")) return;\n'
MUTANTI = [
    # (id, descrizione, vecchio, nuovo, occorrenza, tipo)   tipo L = logica (deve prenderlo P o X)
    ("L01", "Use_Purple ignorato", "   g_telIni = g_telN;\n   if(!Use_Purple) return;\n", "   g_telIni = g_telN;\n", 0, "L"),
    ("L02", "VIOLA grezzo senza banda piatta", "        lows[iCnf] <= bbLowerCnf && lowerFlat &&\n        reactionLongCnf;",
     "        lows[iCnf] <= bbLowerCnf &&\n        reactionLongCnf;", 0, "L"),
    ("L03", "finestra impulso Lookback invece di Lookback*2", "relImpDown >= 1 && relImpDown <= Lookback_Bars * 2 &&\n        midAfterImpDown",
     "relImpDown >= 1 && relImpDown <= Lookback_Bars &&\n        midAfterImpDown", 0, "L"),
    ("L04", "reazione letta sulla barra del segnale", "PurpleReactionOk(true,  opens[iCnf], closes[iCnf], atrSig);\n   bool reactionShortCnf",
     "PurpleReactionOk(true,  opens[iSig], closes[iSig], atrSig);\n   bool reactionShortCnf", 0, "L"),
    ("L05", "cancelli: news prima del kill", '   if(!canOpen)           return "BLOCK_KILL";\n   if(newsBlock)          return "BLOCK_NEWS";\n',
     '   if(newsBlock)          return "BLOCK_NEWS";\n   if(!canOpen)           return "BLOCK_KILL";\n', 0, "L"),
    ("L06", "cancelli: Max_Trades con > invece di >=", '   if(nOpen >= maxTrades) return "BLOCK_MAXTRADES";\n   if(!atrOk)',
     '   if(nOpen > maxTrades) return "BLOCK_MAXTRADES";\n   if(!atrOk)', 0, "L"),
    ("L07", "OpenOrder: HASOPEN dimenticato", '   if(hasOpen)            return "BLOCK_HASOPEN";\n', "", 0, "L"),
    ("L08", "OpenOrder: TP long con < invece di <=", '      if(tp <= ask) return "SKIP_TP";', '      if(tp < ask) return "SKIP_TP";', 0, "L"),
    ("L09", "prologo: lato invertito", "   int side = isLong ? 1 : -1;\n   int j = TelCercaAttesa", "   int side = isLong ? -1 : 1;\n   int j = TelCercaAttesa", 0, "L"),
    ("L10", "dopo CheckSignal: OPENED senza cercare la posizione",
     "      if(!TelTrovaPosizione(sym, g_tel[j].side, j))\n", "      if(false && !TelTrovaPosizione(sym, g_tel[j].side, j))\n", 0, "L"),
    ("L11", "posizione riconosciuta senza il commento", "      if(PositionGetString(POSITION_COMMENT) != comment)  continue;\n", "", 0, "L"),
    ("L12", "entrata del long sul bid", "   g_tel[n].entry_ref_price  = (side > 0) ? ask : bid;", "   g_tel[n].entry_ref_price  = (side > 0) ? bid : bid;", 0, "L"),
    ("L13", "SL del long calcolato dal bid", "   if(isLong) sl = NormalizeDouble(ask - slDist, digits);", "   if(isLong) sl = NormalizeDouble(bid - slDist, digits);", 0, "L"),
    ("L14", "barra 1 = la barra che contiene t", "   if(j < 1) return -1;\n   return j - 1;", "   if(j < 1) return -1;\n   return j;", 0, "L"),
    ("L15", "MAE senza il segno del lato", "   mae = side * (entry - adv) / risk;", "   mae = (entry - adv) / risk;", 0, "L"),
    ("L16", "estremi: lo short segue il massimo", "      if(px < fav) fav = px;\n      if(px > adv) adv = px;",
     "      if(px > fav) fav = px;\n      if(px > adv) adv = px;", 0, "L"),
    ("L17", "net senza commissioni", "   g_tel[j].net        = prof + comm + swp;", "   g_tel[j].net        = prof + swp;", 0, "L"),
    ("L18", "uscita = il PRIMO deal OUT", "            if(t >= tOut)\n", "            if(tOut == 0)\n", 0, "L"),
    ("L19", "motivo SL scritto tp", '   if(reason == DEAL_REASON_SL)     return "sl";', '   if(reason == DEAL_REASON_SL)     return "tp";', 0, "L"),
    ("L20", "k M1 in ore", "      int k = (int)((m1[q].time - t0) / 60);", "      int k = (int)((m1[q].time - t0) / 3600);", 0, "L"),
    ("L21", "percorso H1 fino a 71", "#define TEL_H1_A        119", "#define TEL_H1_A        71", 0, "L"),
    ("L22", "colonne sl_price e tp_ini scambiate", '   r += ";" + DoubleToString(s.sl_price, d);\n   r += ";" + DoubleToString(s.tp_ini, d);',
     '   r += ";" + DoubleToString(s.tp_ini, d);\n   r += ";" + DoubleToString(s.sl_price, d);', 0, "L"),
    ("L23", "una colonna vuota dell'orologio in meno", '   r += ";";\n   r += ";";\n   r += ";" + s.outcome;', '   r += ";";\n   r += ";" + s.outcome;', 0, "L"),
    ("L24", "intestazione: mfe_r rinominata", "mfe_r;mae_r;bars_held", "mfe;mae_r;bars_held", 0, "L"),
    ("L25", "percorso scritto prima che la finestra sia chiusa", "      if(!tutti && now < fineNom) break;\n", "", 0, "L"),
    ("L26", "exit_after_path invertito", "                                  g_tel[j].exit_time > g_tel[j].path_fine) ? 1 : 0;",
     "                                  g_tel[j].exit_time > g_tel[j].path_fine) ? 0 : 1;", 0, "L"),
    ("L27", "stato non azzerato a inizio passata", "   g_telN                = 0;\n   g_telIni              = 0;\n", "   g_telIni              = 0;\n", 0, "L"),
    ("L28", "ADX: Apply_On_Purple ignorato", "   if(!ADX_Apply_On_Purple) return false;\n", "", 0, "L"),
    ("L29", "atr_ok invertito", "   g_tel[n].atr_ok           = atrOk ? 1 : 0;", "   g_tel[n].atr_ok           = atrOk ? 0 : 1;", 0, "L"),
    ("L30", "kill switch letto al contrario", "   string esito = TelEsitoCancelli(canOpen, news,", "   string esito = TelEsitoCancelli(!canOpen, news,", 0, "L"),
    ("L31", "TelNuovaBarra DOPO i cancelli di OnTick",
     "      //--- [TEL] VIOLA grezzo + esito dei cancelli, PRIMA dei cancelli (sola lettura)\n      if(InpTelemetria) TelNuovaBarra(i, barTime, canOpen);\n\n      if(!canOpen)                          continue; // kill switch: niente nuove aperture\n      if(Use_News_Filter && IsNewsHour())   continue; // filtro news orario\n      if(CountOpenTrades() >= Max_Trades)   continue;\n",
     "\n      if(!canOpen)                          continue; // kill switch: niente nuove aperture\n      if(Use_News_Filter && IsNewsHour())   continue; // filtro news orario\n      if(CountOpenTrades() >= Max_Trades)   continue;\n      if(InpTelemetria) TelNuovaBarra(i, barTime, canOpen);\n", 0, "L"),
    ("L32", "prologo DOPO il controllo HasOpenTrade",
     "   if(InpTelemetria) TelPrologoOpenOrder(sym, isLong, atr, bbBasis, comment);\n   if(HasOpenTrade(sym, comment))      return;\n",
     "   if(HasOpenTrade(sym, comment))      return;\n   if(InpTelemetria) TelPrologoOpenOrder(sym, isLong, atr, bbBasis, comment);\n", 0, "L"),
    ("L33", "rischio in valuta raddoppiato", "   return lots * dist * tickValue / tickSize;", "   return 2.0 * lots * dist * tickValue / tickSize;", 0, "L"),
    ("L34", "mid1 scritto con l'ATR", '   r += ";" + DoubleToString(mid1, digits);', '   r += ";" + DoubleToString(atr1, digits);', 0, "L"),
    ("L35", "spread d'entrata ask+bid", "(long)MathRound((ask - bid) / g_tel[n].point)", "(long)MathRound((ask + bid) / g_tel[n].point)", 0, "L"),
    ("L36", "attesa dell'autotest sbagliata", '!= "BLOCK_HASOPEN")   ko++;', '!= "BLOCK_MAXTRADES")   ko++;', 0, "L"),
    ("L37", "TelEViola accetta anche il BLU", '   if(comment == InpComment + "_VIOLA_S") return true;\n',
     '   if(comment == InpComment + "_VIOLA_S") return true;\n   if(StringFind(comment, "_BLU_") >= 0) return true;\n', 0, "L"),
    ("L38", "VIOLA grezzo senza la mediana dopo l'impulso", "        midAfterImpUp && !oppAfterImpUp &&\n        highs[iCnf]",
     "        !oppAfterImpUp &&\n        highs[iCnf]", 0, "L"),
    ("L39", "TP iniziale dalla mediana del SEGNALE", "   v.bbMidCnf   = bbBasisCnf;", "   v.bbMidCnf   = bbBasisSig;", 0, "L"),
    ("L40", "ATR del segnale letto sulla conferma", "   double atrSig = GetATR(symIdx, iSig);\n   if(atrSig <= 0) return false;",
     "   double atrSig = GetATR(symIdx, iCnf);\n   if(atrSig <= 0) return false;", 0, "L"),
    ("L41", "posizione cercata solo fra le altre gia' note", "      if(TelPosGiaNota(pid)) continue;\n", "      if(!TelPosGiaNota(pid)) continue;\n", 0, "L"),
    ("L42", "MFE/MAE senza il prezzo di uscita",
     "         TelAggiornaEstremi(g_tel[j].side, pOut, fav, adv);\n         g_tel[j].fav_px = fav;", "         g_tel[j].fav_px = fav;", 0, "L"),
    ("L43", "estremi non seguiti ai tick", "      if(PositionSelectByTicket((ulong)g_tel[j].pos_ticket))\n      {\n         TelSegui(j);\n         continue;",
     "      if(PositionSelectByTicket((ulong)g_tel[j].pos_ticket))\n      {\n         continue;", 0, "L"),
    ("L44", "originale toccato: CheckSignal VIOLA senza banda piatta", "           lows[iCnf] <= bbLowerCnf && lowerFlat &&\n           reactionLongCnf;",
     "           lows[iCnf] <= bbLowerCnf &&\n           reactionLongCnf;", 0, "L"),
    ("S01", "InpTelemetria acceso di default", "input bool   InpTelemetria  = false;", "input bool   InpTelemetria  = true;", 0, "S"),
    ("S02", "magic di ABTG_Bulge", "= 775100;", "= 772700;", 0, "S"),
    ("S03", "magic nel blocco dell'AZZURRA", "= 775100;", "= 774520;", 0, "S"),
    ("S04", "commento di default BULGE", '"BULGE_TEL";   // Prefisso', '"BULGE";   // Prefisso', 0, "S"),
    ("S05", "una Tel* chiude una posizione", "      TelFinalizza(j);\n      int last", "      trade.PositionClose(g_tel[j].pos_ticket);\n      TelFinalizza(j);\n      int last", 0, "S"),
    ("S06", "GlobalVariableSet in una Tel*", "   g_telScritto = true;\n", "   g_telScritto = true;\n   GlobalVariableSet(\"TEL\", 1.0);\n", 0, "S"),
    ("S07", "notifica da una Tel*", "   g_telScritto = true;\n", "   g_telScritto = true;\n   SendNotification(\"TEL\");\n", 0, "S"),
    ("S08", "UTC calcolato con TimeGMT", '   r += ";";\n   r += ";";\n', '   r += ";" + TelT(TimeGMT());\n   r += ";";\n', 0, "S"),
    ("S09", "scrittura dal prologo di OpenOrder", "   if(j < 0) { g_telOrfani++; return; }\n",
     "   if(j < 0) { g_telOrfani++; return; }\n   FileWriteString(g_telPathH, \"x\");\n", 0, "S"),
    ("S10", "Sleep in TelFineTick", "   datetime now = TimeCurrent();\n   datetime ora", "   Sleep(1);\n   datetime now = TimeCurrent();\n   datetime ora", 0, "S"),
    ("S11", "una Tel* scrive una globale dell'originale", "   g_telIni = g_telN;\n", "   g_telIni = g_telN;\n   g_lastBarTime[symIdx] = 0;\n", 0, "S"),
    ("S12", "riga Tel non guardata", "   if(InpTelemetria) TelFineTick();\n", "   TelFineTick();\n", 0, "S"),
    ("S13", "FILE_COMMON tolto", "   g_telPathH = FileOpen(fp, FILE_WRITE | FILE_TXT | FILE_ANSI | FILE_COMMON);",
     "   g_telPathH = FileOpen(fp, FILE_WRITE | FILE_TXT | FILE_ANSI);", 0, "S"),
    ("S14", "Risk_Percent cambiato", "Risk_Percent          = 0.8;", "Risk_Percent          = 1.0;", 0, "S"),
    ("S15", "WebRequest aggiunta", "   g_telScritto = true;\n", "   g_telScritto = true;\n   char a[]; char b2[]; string h2; WebRequest(\"GET\", \"x\", \"\", 0, a, b2, h2);\n", 0, "S"),
    ("S16", "#import aggiunto", "#include <Trade\\Trade.mqh>\n", "#include <Trade\\Trade.mqh>\n#import \"kernel32.dll\"\n#import\n", 0, "S"),
    ("S17", "Guardian spostato DOPO il Sell", G + "      if(trade.Sell(lots, sym, bid, sl, tp, comment))",
     "      if(trade.Sell(lots, sym, bid, sl, tp, comment) && ABTG_GuardiaIngresso(InpUsaGuardian, \"ABTG_Bulge_Telemetria\"))", 0, "S"),
    ("S18", "guardia sostituita da if(true)", "   if(InpTelemetria) TelChiudi();", "   if(true) TelChiudi();", 0, "S"),
    ("S19", "continue guardato in OnTick", "      if(InpTelemetria) TelDopoCheckSignal(i);\n",
     "      if(InpTelemetria) TelDopoCheckSignal(i);\n      if(InpTelemetria) continue;\n", 0, "S"),
    ("S20", "CRLF tolto da una scrittura", '         FileWriteString(h, TelRigaSegnale(g_tel[j]) + "\\r\\n");',
     '         FileWriteString(h, TelRigaSegnale(g_tel[j]) + "\\n");', 0, "S"),
    ("S21", "PrintFormat con un argomento in meno", "               g_telOrfani, g_telDivergenze, g_telNonRisolti);",
     "               g_telOrfani, g_telDivergenze);", 0, "S"),
    ("S22", "Max_Trades cambiato", "Max_Trades            = 4;", "Max_Trades            = 6;", 0, "S"),
    ("S23", "kill switch spento di default", "Use_Kill_Switch     = true;", "Use_Kill_Switch     = false;", 0, "S"),
    ("S24", "Signal_Bar_Offset 0 di default", "Signal_Bar_Offset = 1;", "Signal_Bar_Offset = 0;", 0, "S"),
    ("S25", "OrderCalcProfit in una Tel*", "   if(tickSize <= 0 || tickValue <= 0) return 0.0;\n",
     "   if(tickSize <= 0 || tickValue <= 0) return 0.0;\n   double pr = 0; OrderCalcProfit(ORDER_TYPE_BUY, sym, lots, 1.0, 1.1, pr);\n", 0, "S"),
]


def applica(src, vecchio, nuovo, occ):
    n = src.count(vecchio)
    if n <= occ:
        return None
    p = -1
    for _ in range(occ + 1):
        p = src.find(vecchio, p + 1)
    return src[:p] + nuovo + src[p + len(vecchio):]


def mutanti(src, old, orig_exe, wins):
    print("\nM) MUTANTI CIECHI (%d), su copie fuori dal repo" % len(MUTANTI))
    presi = 0
    for mid, desc, v, n, occ, tipo in MUTANTI:
        mut = applica(src, v, n, occ)
        if mut is None:
            check(False, "%s %s: il punto da mutare non esiste (collaudo da aggiornare)" % (mid, desc))
            continue
        tmp = tempfile.mkdtemp(prefix="tel_mut_")
        try:
            strati, _ = suite(mut.encode("latin-1"), old, tmp, [], quiet=True, ridotto=True, orig_exe=orig_exe, wins=wins)
        finally:
            shutil.rmtree(tmp, ignore_errors=True)
        chi = "".join(k for k in "SZPX" if strati[k])
        comportamento = any(strati[k] for k in "PX")
        ok = bool(chi) and (tipo != "L" or comportamento)
        if ok:
            presi += 1
        print(("  ok   " if ok else "  FAIL ") + "%s %-58s preso da [%s]%s" % (
            mid, desc, chi or "-", "" if ok or not chi else "  <- logica presa SOLO dallo statico/diff"))
        if not ok:
            FAILS.append("mutante %s (%s) non preso come richiesto" % (mid, desc))
    check(presi == len(MUTANTI), "mutanti presi: %d/%d (logica: tutti presi da P o X)" % (presi, len(MUTANTI)))


# ===========================================================================
def main():
    raw = leggi(SRC_NEW)
    oldb = leggi(SRC_OLD)
    print("collaudo ABTG_Bulge_Telemetria.mq5 contro ABTG_Bulge.mq5\n")
    check(hashlib.sha256(oldb).hexdigest() == SHA_OLD, "ABTG_Bulge.mq5 e' la v5.20 (SHA256 ED4E88B1...): il confronto e' contro l'originale giusto")
    old = oldb.decode("ascii")
    print("  ..   SHA256 della copia: %s" % hashlib.sha256(raw).hexdigest())
    wins, nsig = finestre((11, 23, 37, 51, 67, 79, 83, 97, 101, 113), 900, 250, seed=5)
    print("  ..   finestre: %d con un VIOLA (su %d trovate) + %d a caso" % (min(900, nsig), nsig, len(wins) - min(900, nsig)))
    tmp = tempfile.mkdtemp(prefix="tel_col_")
    try:
        print("\nS) STATICO")
        b = []
        statico(raw, old, b)
        FAILS.extend(b)
        print("\nZ) ZONE DEL DIFF")
        b = []
        controlla_zone(old, raw.decode("ascii", "replace"), b)
        FAILS.extend(b)
        bl = Build(raw.decode("ascii", "replace"), old, tmp)
        check(bl.ok, "C++: RAW (CheckSignal VERA + TelValutaViola), ORIG e NEW (terminale finto) compilati con g++ -Wall %s" % ("" if bl.ok else bl.err[:2000]))
        if bl.ok:
            print("\nP) FUNZIONI PURE (C++)")
            b = []
            p_pure(bl, b)
            FAILS.extend(b)
            print("\nX1) TelValutaViola contro CheckSignal VERA")
            b = []
            x1_raw(bl, wins, b)
            FAILS.extend(b)
            print("\nX2) OnTick: originale contro copia (telemetria 0/1) + oracolo degli esiti")
            b = []
            x2_ontick(bl, wins, b)
            FAILS.extend(b)
            print("\nX3) END-TO-END: due CSV dal codice vero -> lettore --controlla")
            b = []
            x3_e2e(bl, b, tmp=tmp)
            FAILS.extend(b)
            if not SENZA_MUTANTI and not FAILS:
                print("\nM0) CONTROLLO DI BASE: la suite RIDOTTA dei mutanti passa sul sorgente NON mutato")
                tb = tempfile.mkdtemp(prefix="tel_base_")
                try:
                    strati, _ = suite(raw, old, tb, [], quiet=True, ridotto=True, orig_exe=bl.orig, wins=wins)
                finally:
                    shutil.rmtree(tb, ignore_errors=True)
                difetti = [x for k in "SZPX" for x in strati[k]]
                check(not difetti, "suite ridotta pulita sul sorgente vero (altrimenti un mutante sarebbe 'preso' per niente) %s" % difetti[:3])
                if not difetti:
                    mutanti(raw.decode("ascii"), old, bl.orig, wins)
    finally:
        shutil.rmtree(tmp, ignore_errors=True)
    print("\nNON PROVATO: compilazione MQL5 (MetaEditor assente), test P0 nel tester (Trades/Profit/PF/DD identici a "
          "ABTG_Bulge v5.20), CTrade e Guardian veri, iBands/iATR/iADX/CopyRates/CopyBuffer per data del terminale, "
          "scrittura reale in Common\\Files, il tetto di barre del tester, nessun backtest.")
    if FAILS:
        print("\nESITO: FAIL (%d)" % len(FAILS))
        for f in FAILS[:40]:
            print("  - " + f)
        sys.exit(1)
    print("\nESITO: PASS")


if __name__ == "__main__":
    main()
