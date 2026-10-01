#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Collaudo di mql5/Indicators/ABTG_SuperWave_Dashboard_v41.mq5 (SuperWave 4.1).

Qui NON c'e' MetaEditor: niente compila davvero l'MQL5. Il collaudo fa quello che si
puo' fare onestamente senza terminale, nello stile di test_abtg_confluenza.py:

  S) STATICO sul sorgente: ASCII, parentesi bilanciate, buffer/plot contati, nessuna
     funzione di trading/rete, niente StringFormat/PrintFormat, default di Claudio
     invariati rispetto al file ricevuto, ogni identificatore 'g*/Inp*/k*/w*/SW_*'
     dichiarato, ogni funzione chiamata definita o nota a MQL5.
  C) Le FUNZIONI PURE vere (blocco //@@SW41_PURE_BEGIN..END) ESTRATTE dal .mq5,
     compilate come C++ con uno shim minimo, confrontate BIT PER BIT con lo specchio
     Python su serie sintetiche e su dati REALI (XAUUSD M1 HistData 2021-2026,
     ricampionati). Piu' MUTANTI: ogni mutazione del blocco deve essere vista
     (classe 972: insiemi di prova con i rami attivi e i confini).
  M) MISURE con lo specchio (validato in C):
     M1 v4.00 ricevuta: griglia (ATR Wilder, 90 barre) contro grafico (iATR = SMA del
        TR, storico intero): direzioni e inversioni che divergono, per TF; lampeggi
        M3/H4 con il grafico discorde (segnalazione di Claudio del 01/10).
     M2 v4.1: barre necessarie perche' la finestra agganci lo stato dello storico
        intero (classe 950 "need window"); contro-esempio a finestra corta.
     M3 v4.1: setup dalla finestra (regola della zona affidabile) == setup dallo
        storico intero; contro-esempio senza la regola.
     M4 confluenza modo 0 contro modo 1 su dati reali (quota di tempo, eventi/giorno).
  L) LOGICA nuova su casi costruiti con risposta NOTA, piu' un caso che DEVE scattare
     (classe 1014): confluenza, ingresso fisso tick per tick (contro-esempio: la regola
     v4.00 "ingresso = ultimo prezzo" cambia a ogni tick), cache + rotazione + dati non
     pronti (specchio del flusso di UpdateSlot), tocchi stop/TP.

Uso:   python3 backtest_pipeline/collaudo_superwave_v41.py [--rapido]
Esce con 0 solo se tutti i controlli passano. NON prova la compilazione MQL5.
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
V41 = os.path.join(ROOT, "mql5/Indicators/ABTG_SuperWave_Dashboard_v41.mq5")
RICEVUTO = os.path.join(ROOT, "docs/sorgenti_ricevuti/ABTG_SuperWave_Dashboard_ricevuto_2026-10-01.mq5")
DATI = os.path.join(ROOT, "backtest_pipeline/risultati_prove/oro_m1_utc_2021_2026")
RAPIDO = "--rapido" in sys.argv

FAILS = []


def check(cond, msg):
    print(("  ok   " if cond else "  FAIL ") + msg)
    if not cond:
        FAILS.append(msg)
    return cond


def read(p):
    with open(p, "r", encoding="latin-1") as f:
        return f.read()


# ===========================================================================
# Specchio Python delle funzioni pure (riga per riga dal blocco PURE del .mq5)
# ===========================================================================
def py_stcore(h, l, c, n, frm, per, mult, atr, up, dn, dr, val):
    if per < 1:
        return 0
    st = max(frm, 0)
    for i in range(st, n):
        if i < per:
            atr[i] = 0.0; up[i] = 0.0; dn[i] = 0.0; dr[i] = 0.0; val[i] = 0.0
            continue
        s = 0.0
        for k in range(i - per + 1, i + 1):
            s += max(h[k], c[k - 1]) - min(l[k], c[k - 1])
        a = s / per
        atr[i] = a
        mid = (h[i] + l[i]) / 2.0
        ub = mid + mult * a
        lb = mid - mult * a
        if i == per:
            up[i] = ub; dn[i] = lb
            dr[i] = 1.0 if c[i] >= mid else -1.0
        else:
            up[i] = ub if (ub < up[i - 1] or c[i - 1] > up[i - 1]) else up[i - 1]
            dn[i] = lb if (lb > dn[i - 1] or c[i - 1] < dn[i - 1]) else dn[i - 1]
            if c[i] > up[i - 1]:
                dr[i] = 1.0
            elif c[i] < dn[i - 1]:
                dr[i] = -1.0
            else:
                dr[i] = dr[i - 1]
        val[i] = dn[i] if dr[i] > 0.0 else up[i]
    return n


def st_full(h, l, c, per, mult):
    n = len(c)
    a = [0.0] * n; u = [0.0] * n; d = [0.0] * n; r = [0.0] * n; v = [0.0] * n
    py_stcore(h, l, c, n, 0, per, mult, a, u, d, r, v)
    return a, u, d, r, v


def py_bsf(dr, last, first):
    if last <= first:
        return -1
    for i in range(last, first, -1):
        if dr[i] != dr[i - 1]:
            return last - i
    return -1


def py_lastflip(dr, last, first):
    bs = py_bsf(dr, last, first)
    return -1 if bs < 0 else last - bs


def py_lit(d, bs, fb):
    return d != 0 and bs >= 0 and bs < fb


def py_confl(mode, dH4, bsH4, dM3, bsM3, flipM3, stableH4):
    if dH4 == 0 or dM3 == 0:
        return 0
    if mode == 0:
        return dH4 if dH4 == dM3 else 0
    if bsM3 < 0 or bsM3 >= flipM3:
        return 0
    if dM3 != dH4:
        return 0
    if stableH4 > 0 and bsH4 >= 0 and bsH4 < stableH4:
        return 0
    return dH4


def py_phase(confl, blink, sec, now, ev):
    if confl == 0:
        return 0
    if (not blink) or sec <= 0:
        return 1
    el = (now - ev) & 0xFFFFFFFF
    if el >= ((sec & 0xFFFFFFFF) * 1000) & 0xFFFFFFFF:
        return 1
    return 2 if (el // 1000) % 2 == 0 else 3


def py_dim(c, t, f):
    r, g, b = c & 0xFF, (c >> 8) & 0xFF, (c >> 16) & 0xFF
    r2, g2, b2 = t & 0xFF, (t >> 8) & 0xFF, (t >> 16) & 0xFF
    R = int(r + (r2 - r) * f); G = int(g + (g2 - g) * f); B = int(b + (b2 - b) * f)
    return ((B << 16) | (G << 8) | R) & 0xFFFFFFFF


def cround(x):
    # std::round: meta' lontano da zero
    if x >= 0:
        fl = math.floor(x)
        return fl + 1.0 if x - fl >= 0.5 else float(fl)
    return -cround(-x)


def normd(v, d):
    p = 10.0 ** d
    return cround(v * p) / p


def py_lots(v, step, vmin, vmax):
    st = step if step > 0.0 else 0.01
    if v <= 0.0:
        return 0.0, 1
    dg = 0
    t = st
    while dg < 8 and abs(t - cround(t)) > 1e-9:
        t *= 10.0
        dg += 1
    k = math.floor(v / st + 1e-7)
    lot = normd(k * st, dg)
    flag = 0
    if vmax > 0.0 and lot > vmax:
        k = math.floor(vmax / st + 1e-7)
        lot = normd(k * st, dg)
        flag = 2
    if lot <= 0.0 or lot < vmin:
        return 0.0, 1
    return lot, flag


def py_setupok(d, e, s):
    if d > 0:
        return s > 0.0 and s < e
    if d < 0:
        return s > e
    return False


def py_hits(h, l, frm, n, d, stop, t1, t2, t3):
    iS = i1 = i2 = i3 = -1
    for i in range(frm, n):
        if d > 0:
            if iS < 0 and l[i] <= stop: iS = i
            if i1 < 0 and h[i] >= t1: i1 = i
            if i2 < 0 and h[i] >= t2: i2 = i
            if i3 < 0 and h[i] >= t3: i3 = i
        else:
            if iS < 0 and h[i] >= stop: iS = i
            if i1 < 0 and l[i] <= t1: i1 = i
            if i2 < 0 and l[i] <= t2: i2 = i
            if i3 < 0 and l[i] <= t3: i3 = i
    return iS, i1, i2, i3


def py_state(iS, i1, i2, i3):
    best = 0
    if i1 >= 0 and (iS < 0 or i1 < iS): best = 1
    if i2 >= 0 and (iS < 0 or i2 < iS): best = 2
    if i3 >= 0 and (iS < 0 or i3 < iS): best = 3
    if iS < 0:
        return best, best
    if best > 0:
        return 5, best
    if i1 == iS or i2 == iS or i3 == iS:
        return 6, best
    return 4, best


def py_gpre(tl, key, ok):
    if tl <= 0:
        return 1
    if ok and key == tl:
        return 0
    return 2


def py_gpost(got, mn, want, synced, lastT, tl):
    if got < mn:
        return 1
    if lastT != tl:
        return 1
    if not synced:
        return 3 if got >= want else 1
    return 2


# ===========================================================================
# Dati: sintetici e reali
# ===========================================================================
def synth(n, seed, start=1000.0):
    rnd = random.Random(seed)
    out_h, out_l, out_c = [], [], []
    p = start
    vol = 1.0
    drift = 0.0
    for i in range(n):
        if i % 300 == 0:
            drift = rnd.choice((-0.15, 0.0, 0.15))
            vol = rnd.choice((0.5, 1.0, 2.0))
        o = p
        c = o + drift + rnd.gauss(0, vol)
        h = max(o, c) + abs(rnd.gauss(0, vol * 0.6))
        l = min(o, c) - abs(rnd.gauss(0, vol * 0.6))
        # prezzi a 2 decimali come l'oro (cosi' le uguaglianze esatte capitano davvero)
        h = round(h, 2); l = round(l, 2); c = round(c, 2)
        if l > c: l = c
        if h < c: h = c
        out_h.append(h); out_l.append(l); out_c.append(c)
        p = c
    return out_h, out_l, out_c


_REAL = None


def load_real():
    """XAUUSD M1 2021-2026 (HistData, UTC). None se i file non ci sono."""
    global _REAL
    if _REAL is not None:
        return _REAL
    if not os.path.isdir(DATI):
        _REAL = False
        return _REAL
    T, H, L, C = [], [], [], []
    import datetime as dt
    ep = dt.datetime(1970, 1, 1)
    for y in range(2021, 2027):
        f = os.path.join(DATI, "XAUUSD_M1_UTC_%d.csv" % y)
        if not os.path.exists(f):
            continue
        with open(f) as fh:
            fh.readline()
            for ln in fh:
                p = ln.rstrip("\n").split(",")
                if len(p) < 5:
                    continue
                t = dt.datetime.strptime(p[0], "%Y-%m-%d %H:%M")
                T.append(int((t - ep).total_seconds() // 60))
                C.append(float(p[1])); H.append(float(p[2])); L.append(float(p[3]))
    idx = sorted(range(len(T)), key=lambda i: T[i])
    _REAL = ([T[i] for i in idx], [H[i] for i in idx], [L[i] for i in idx], [C[i] for i in idx])
    return _REAL


def resample(mins, last=None):
    """barre del TF (in minuti) dal M1 reale: (t_inizio_min, h, l, c)."""
    T, H, L, C = load_real()
    tt, hh, ll, cc = [], [], [], []
    cur = None
    for i in range(len(T)):
        b = T[i] // mins
        if b != cur:
            cur = b
            tt.append(b * mins); hh.append(H[i]); ll.append(L[i]); cc.append(C[i])
        else:
            if H[i] > hh[-1]: hh[-1] = H[i]
            if L[i] < ll[-1]: ll[-1] = L[i]
            cc[-1] = C[i]
    if last:
        tt, hh, ll, cc = tt[-last:], hh[-last:], ll[-last:], cc[-last:]
    return tt, hh, ll, cc


# ===========================================================================
# S) controlli statici
# ===========================================================================
MQL_BUILTINS = set("""
SetIndexBuffer PlotIndexSetDouble PlotIndexSetInteger PlotIndexSetString IndicatorSetString IndicatorSetInteger
iMA iATR iTime iBarShift CopyRates CopyBuffer BarsCalculated IndicatorRelease SeriesInfoInteger
ObjectCreate ObjectDelete ObjectsDeleteAll ObjectFind ObjectSetInteger ObjectSetDouble ObjectSetString
ObjectGetString ObjectGetInteger ObjectsTotal ObjectName ChartRedraw ChartSetSymbolPeriod ChartGetInteger
ChartGetString ChartOpen
ChartSetInteger ChartID EventSetTimer EventKillTimer GetTickCount GetLastError ResetLastError Print
StringSplit StringTrimLeft StringTrimRight StringLen StringFind StringSubstr StringToInteger StringGetCharacter
IntegerToString DoubleToString TimeToString EnumToString TimeLocal SymbolSelect SymbolInfoDouble
AccountInfoDouble ArrayResize ArraySize ArraySort ArraySetAsSeries ArrayInitialize PeriodSeconds
GlobalVariableSet GlobalVariableGet GlobalVariableCheck GlobalVariablesDeleteAll GlobalVariablesTotal
GlobalVariableName GlobalVariableDel MathMax MathMin MathAbs MathFloor MathRound NormalizeDouble
if for while return switch sizeof
""".split())
MQL_CONSTANTS = set("""
ACCOUNT_BALANCE CHART_EXPERT_NAME ANCHOR_BOTTOM ANCHOR_LEFT ANCHOR_RIGHT_UPPER ANCHOR_TOP BORDER_FLAT CHARTEVENT_OBJECT_CLICK
CHART_COLOR_CANDLE_BEAR CHART_COLOR_CANDLE_BULL CHART_COLOR_CHART_DOWN CHART_COLOR_CHART_LINE CHART_COLOR_CHART_UP
CORNER_LEFT_UPPER CORNER_RIGHT_UPPER DRAW_COLOR_CANDLES DRAW_COLOR_LINE DRAW_LINE EMPTY_VALUE ENUM_CHART_PROPERTY_INTEGER
ENUM_MA_METHOD ENUM_TIMEFRAMES INDICATOR_CALCULATIONS INDICATOR_COLOR_INDEX INDICATOR_DATA INDICATOR_DIGITS
INDICATOR_SHORTNAME INIT_PARAMETERS_INCORRECT INIT_SUCCEEDED INIT_FAILED INVALID_HANDLE MODE_SMA OBJPROP_ANCHOR
OBJPROP_ARROWCODE OBJPROP_BACK OBJPROP_BGCOLOR OBJPROP_BORDER_TYPE OBJPROP_COLOR OBJPROP_CORNER OBJPROP_FONT
OBJPROP_FONTSIZE OBJPROP_HIDDEN OBJPROP_PRICE OBJPROP_SELECTABLE OBJPROP_STATE OBJPROP_STYLE OBJPROP_TEXT OBJPROP_TIME
OBJPROP_TIMEFRAMES OBJPROP_TOOLTIP OBJPROP_WIDTH OBJPROP_XDISTANCE OBJPROP_XSIZE OBJPROP_YDISTANCE OBJPROP_YSIZE
OBJ_ALL_PERIODS OBJ_ARROW OBJ_BUTTON OBJ_HLINE OBJ_LABEL OBJ_NO_PERIODS OBJ_RECTANGLE_LABEL OBJ_TEXT PERIOD_CURRENT
PERIOD_D1 PERIOD_H1 PERIOD_H4 PERIOD_M1 PERIOD_M15 PERIOD_M3 PERIOD_M5 PLOT_EMPTY_VALUE PRICE_CLOSE REASON_CHARTCLOSE
REASON_REMOVE SERIES_SYNCHRONIZED STYLE_DASH STYLE_DOT STYLE_SOLID SYMBOL_TRADE_TICK_SIZE SYMBOL_TRADE_TICK_VALUE
SYMBOL_TRADE_TICK_VALUE_LOSS SYMBOL_VOLUME_MAX SYMBOL_VOLUME_MIN SYMBOL_VOLUME_STEP TIME_DATE TIME_MINUTES TIME_SECONDS
_Digits _Period _Point _Symbol clrAqua clrLime clrLimeGreen clrNONE clrOrange clrRed clrTomato clrWhite
""".split())
FORBIDDEN = ["OrderSend", "OrderSendAsync", "CTrade", "PositionOpen", "PositionClose", "OrderCalcMargin",
             "WebRequest", "SocketCreate", "SendFTP", "SendMail", "StringFormat", "PrintFormat",
             "#include <Trade", "FileOpen", "DLL", "#import"]
TYPES = r"(?:int|double|bool|string|color|datetime|uint|long|ulong|ushort|short|char|void|MqlRates|ENUM_[A-Z_]+)"


# regole che vivono FUORI dal blocco puro: righe ancorate (spazi tolti, sul codice senza commenti/stringhe)
ANCHORS = [
    ("griglia: CopyRates a barre CHIUSE", "CopyRates(sym,tf,1,gGridBars,r)", 1),
    ("seme escluso dalle inversioni", "intfirst=InpAtrPeriod+1;", 1),
    ("zona affidabile", "inttrustFrom=first+SW_TRUST_BARS;", 1),
    ("setup solo dentro la zona affidabile", "if(fi>=trustFrom)", 1),
    ("setup: direzione della barra di inversione", "gCSuDir[k]=(int)wDir[fi];", 1),
    ("setup: ingresso = chiusura della barra di inversione", "gCSuE[k]=wC[fi];", 1),
    ("setup: stop = Supertrend sulla barra di inversione", "gCSuS[k]=wV[fi];", 1),
    ("setup: ora = barra di inversione", "gCSuT[k]=r[fi].time;", 1),
    ("setup tenuto solo nel verso attuale", "if(oldOk&&oldT>0&&oldT<tb&&gCSuDir[k]==d)", 1),
    ("memoria solo nel verso attuale", "if(d!=curDir)returnfalse;", 1),
    ("indice H4", "if(TFS[c]==PERIOD_H4)gIdxH4=c;", 1),
    ("indice M3", "if(TFS[c]==PERIOD_M3)gIdxM3=c;", 1),
    ("confluenza: H4 primo, M3 secondo", "SW_Confl((int)InpConflMode,gCDir[kH],gCBs[kH],gCDir[kM],gCBs[kM],InpConflFlipBars,InpConflH4Stable)", 1),
    ("cella accesa con InpFlipBars (disegno e clic)", "SW_CellLit(gCDir[k],gCBs[k],InpFlipBars)", 2),
    ("setup selezionato indipendente dal TF del grafico", "ENUM_TIMEFRAMEStf=sel?gSelTf:_Period;", 1),
    ("OnDeinit ripristina sempre le candele", "voidOnDeinit(constintreason){EventKillTimer();ColsRestore();", 1),
    ("stato dei tasti tolto solo alla rimozione", "if(reason==REASON_REMOVE||reason==REASON_CHARTCLOSE)GvClear();", 1),
    ("lotti: perdita per lotto = R/tick size x tick value", "doublelossPerLot=(tickSz>0)?(risk/tickSz)*tickVal:0;", 1),
    ("classe 930: EA sul grafico -> il grafico non si tocca", "if(StringLen(ChartGetString(0,CHART_EXPERT_NAME))>0)", 1),
]
ANCHOR_MUTANTS = [
    ("ingresso = chiusura dell'ULTIMA barra (regola v4.00)", "gCSuE[k]=wC[fi];", "gCSuE[k]=wC[last];"),
    ("H4 e M3 scambiati", "gCDir[kH],gCBs[kH],gCDir[kM],gCBs[kM]", "gCDir[kM],gCBs[kM],gCDir[kH],gCBs[kH]"),
    ("selezione ignorata", "ENUM_TIMEFRAMES tf=sel ? gSelTf : _Period;", "ENUM_TIMEFRAMES tf=_Period;"),
]


def missing_anchors(code):
    flat = re.sub(r"\s+", "", code)
    return [lab for lab, a, n in ANCHORS if flat.count(a) != n]


def strip_code(src):
    """toglie commenti, stringhe e caratteri (sostituiti da spazi/segnaposto)."""
    out = []
    i, n = 0, len(src)
    while i < n:
        ch = src[i]
        if src.startswith("//", i):
            j = src.find("\n", i)
            i = n if j < 0 else j
            continue
        if src.startswith("/*", i):
            j = src.find("*/", i + 2)
            i = n if j < 0 else j + 2
            continue
        if ch == '"' or ch == "'":
            q = ch
            j = i + 1
            while j < n and src[j] != q:
                j += 2 if src[j] == "\\" else 1
            out.append(' "S" ' if q == '"' else " 0 ")
            i = j + 1
            continue
        out.append(ch)
        i += 1
    return "".join(out)


def declared_names(code):
    names = set()
    # firme di funzione: tipo nome( params )
    for m in re.finditer(r"\b" + TYPES + r"\s+(\w+)\s*\(([^()]*)\)\s*\{", code):
        names.add(m.group(1))
        for prm in m.group(2).split(","):
            mm = re.search(r"(\w+)\s*(\[\s*\])?\s*(=[^,]*)?$", prm.strip())
            if mm:
                names.add(mm.group(1))
    # dichiarazioni: istruzioni che cominciano con (input|const|static)? tipo
    for stmt in re.split(r"[;{}()]", code):
        s = stmt.strip()
        m = re.match(r"^(?:input\s+|const\s+|static\s+)*" + TYPES + r"\s+(.*)$", s, re.S)
        if not m:
            continue
        body = m.group(1)
        depth = 0
        cur = ""
        parts = []
        for ch in body:
            if ch in "[(":
                depth += 1
            elif ch in "])":
                depth -= 1
            if ch == "," and depth == 0:
                parts.append(cur); cur = ""
            else:
                cur += ch
        parts.append(cur)
        for p in parts:
            mm = re.match(r"\s*&?\s*(\w+)", p)
            if mm:
                names.add(mm.group(1))
    for m in re.finditer(r"#define\s+(\w+)", code):
        names.add(m.group(1))
    for m in re.finditer(r"enum\s+(\w+)\s*\{([^}]*)\}", code):
        names.add(m.group(1))
        for e in m.group(2).split(","):
            mm = re.match(r"\s*(\w+)", e)
            if mm:
                names.add(mm.group(1))
    return names


def static_checks(src, recv):
    print("== S) STATICO sul sorgente v4.1 ==")
    nonascii = [i for i, ch in enumerate(src) if ord(ch) > 127]
    check(len(nonascii) == 0, "sorgente ASCII puro (%d caratteri non ASCII)" % len(nonascii))
    code = strip_code(src)
    for a, b in ("()", "{}", "[]"):
        check(code.count(a) == code.count(b), "parentesi %s%s bilanciate (%d/%d)" % (a, b, code.count(a), code.count(b)))
    # contenuto delle macro #define toglie falsi allarmi: le righe # restano
    nb = int(re.search(r"#property\s+indicator_buffers\s+(\d+)", src).group(1))
    npl = int(re.search(r"#property\s+indicator_plots\s+(\d+)", src).group(1))
    idx = [int(x) for x in re.findall(r"SetIndexBuffer\(\s*(\d+)\s*,", code)]
    check(sorted(idx) == list(range(nb)), "SetIndexBuffer 0..%d tutti presenti una volta (%d chiamate)" % (nb - 1, len(idx)))
    types = re.findall(r"#property\s+indicator_type(\d+)", src)
    check(len(types) == npl and sorted(int(t) for t in types) == list(range(1, npl + 1)),
          "indicator_plots=%d coincide con i tipi dichiarati" % npl)
    calc = re.findall(r"SetIndexBuffer\(\s*(\d+)\s*,\s*\w+\s*,\s*INDICATOR_CALCULATIONS", code)
    data = re.findall(r"SetIndexBuffer\(\s*(\d+)\s*,\s*\w+\s*,\s*INDICATOR_(?:DATA|COLOR_INDEX)", code)
    check(max(int(x) for x in data) < min(int(x) for x in calc), "i buffer di calcolo stanno DOPO quelli disegnati")
    for f in FORBIDDEN:
        check(f not in src, "nessun '%s' (sola visione, niente rete, niente StringFormat)" % f)
    check("ChartSetSymbolPeriod(0,NULL" not in code.replace(" ", ""),
          "nessun ChartSetSymbolPeriod(0,NULL,...) per ricalcolare (i tasti non ricaricano)")
    n_cssp = len(re.findall(r"ChartSetSymbolPeriod\s*\(", code))
    check(n_cssp == 1, "ChartSetSymbolPeriod chiamato in un solo punto (GoTo), trovati %d" % n_cssp)
    # default di Claudio invariati: ogni input del RICEVUTO esiste con lo stesso tipo e default
    rin = dict((m.group(2), (m.group(1), m.group(3).strip())) for m in
               re.finditer(r"^input\s+(\w+)\s+(\w+)\s*=\s*([^;]+);", recv, re.M))
    vin = dict((m.group(2), (m.group(1), m.group(3).strip())) for m in
               re.finditer(r"^input\s+(\w+)\s+(\w+)\s*=\s*([^;]+);", src, re.M))
    for k, v in rin.items():
        check(k in vin and vin[k] == v, "input %s del ricevuto invariato (%s = %s)" % (k, v[0], v[1]))
    new = {"InpConflMode": "CONFL_INVERSIONE_M3", "InpConflFlipBars": "3", "InpConflH4Stable": "3",
           "InpBlinkSeconds": "20", "InpBatch": "6", "InpGridBars": "1000", "InpClickCambiaTF": "true",
           "InpDiagnosi": "false"}
    for k, v in new.items():
        check(k in vin and vin[k][1] == v, "input nuovo %s = %s" % (k, v))
    # identificatori del progetto dichiarati (avrebbe preso 'gShST' al posto di 'gShowST')
    decl = declared_names(code)
    ids = set(re.findall(r"\b((?:g|k|w)[A-Z]\w*|Inp\w+|SW_\w+)\b", code))
    und = sorted(i for i in ids if i not in decl)
    check(not und, "identificatori g*/k*/w*/Inp*/SW_* tutti dichiarati (non dichiarati: %s)" % und)
    # costanti MQL5 scritte giuste (un refuso tipo OBJPROP_TOOLTP non sarebbe un identificatore 'g*')
    caps = set(re.findall(r"\b([A-Z][A-Z0-9_]{2,}|clr[A-Za-z]+|_[A-Z][a-z]+)\b", code))
    badc = sorted(x for x in caps if x not in MQL_CONSTANTS and x not in decl and not x.startswith("CONFL_"))
    check(not badc, "ogni costante MQL5 usata e' nell'elenco delle costanti note (sconosciute: %s)" % badc)
    # funzioni chiamate: definite qui o note a MQL5
    defined = set(m.group(1) for m in re.finditer(r"\b" + TYPES + r"\s+(\w+)\s*\([^;{]*\)\s*\{", code))
    nodef = re.sub(r"^\s*#define.*$", "", code, flags=re.M)      # le macro non sono chiamate
    calls = set(re.findall(r"\b([A-Za-z_]\w*)\s*\(", nodef))
    known = defined | MQL_BUILTINS | set(TYPES.replace("(?:", "").replace(")", "").split("|"))
    unknown = sorted(c for c in calls if c not in known and not c.startswith("ENUM_"))
    check(not unknown, "ogni funzione chiamata e' definita o nota a MQL5 (sconosciute: %s)" % unknown)
    # ogni funzione definita una volta sola
    dup = [f for f in defined if len(re.findall(r"\b" + TYPES + r"\s+" + f + r"\s*\(", code)) > 1]
    check(not dup, "nessuna funzione definita due volte (%s)" % dup)
    # un controllo che DEVE fallire: il sorgente col refuso vero di stesura (gShST) va preso
    bad = code.replace("gShowST &&", "gShST &&", 1)
    und2 = sorted(i for i in set(re.findall(r"\b((?:g|k|w)[A-Z]\w*|Inp\w+|SW_\w+)\b", bad)) if i not in declared_names(bad))
    check(und2 == ["gShST"], "contro-esempio: il refuso 'gShST' viene trovato dal controllo (%s)" % und2)
    # ANCORE delle regole che vivono FUORI dal blocco puro (classe 1042, cancello del 01/10):
    # un mutante su queste righe (es. ingresso = chiusura dell'ULTIMA barra, la regola v4.00) NON
    # cambia nessuna funzione pura e passava tutto il collaudo. L'ancora prende la riga CAMBIATA;
    # NON prova che la riga sia giusta (quello lo dice lo specchio della sezione L, che e' Python).
    miss = missing_anchors(code)
    check(not miss, "ancore delle regole fuori dal blocco puro presenti (%d/%d; mancanti: %s)"
          % (len(ANCHORS) - len(miss), len(ANCHORS), miss))
    for lab, old_t, new_t in ANCHOR_MUTANTS:
        m2 = missing_anchors(code.replace(old_t, new_t, 1)) if code.count(old_t) >= 1 else ["(testo non trovato)"]
        check(len(m2) > 0, "contro-esempio ancore: '%s' viene preso (%s)" % (lab, m2))


# ===========================================================================
# C) funzioni pure VERE compilate in C++
# ===========================================================================
SHIM = r'''
#include <cmath>
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <string>
#include <vector>
typedef unsigned int color;
typedef unsigned int uint;
inline double MathMax(double a,double b){ return a>b?a:b; }
inline double MathMin(double a,double b){ return a<b?a:b; }
inline double MathAbs(double a){ return std::fabs(a); }
inline double MathFloor(double a){ return std::floor(a); }
inline double MathRound(double a){ return std::round(a); }
inline double NormalizeDouble(double v,int d){ double p=std::pow(10.0,d); return std::round(v*p)/p; }
'''

DRIVER = r'''
#include "shim.h"
#include "pure.mqh"
int main(){
  char cmd[32];
  while(scanf("%31s",cmd)==1){
    std::string c(cmd);
    if(c=="ST"){
      int n,per; double mult; if(scanf("%d %d %lf",&n,&per,&mult)!=3) return 2;
      std::vector<double> h(n),l(n),cl(n);
      for(int i=0;i<n;i++) if(scanf("%lf %lf %lf",&h[i],&l[i],&cl[i])!=3) return 2;
      std::vector<double> a(n),u(n),d(n),r(n),v(n);
      int ret=SW_STCore(h.data(),l.data(),cl.data(),n,0,per,mult,a.data(),u.data(),d.data(),r.data(),v.data());
      /* incrementale come OnCalculate: la barra in formazione si calcola prima con valori diversi, poi con i veri */
      std::vector<double> hp=h,lp=l,cp=cl, a2(n),u2(n),d2(n),r2(n),v2(n);
      for(int m=1;m<=n;m++){
        hp[m-1]=h[m-1]+3.0; lp[m-1]=l[m-1]-2.0; cp[m-1]=cl[m-1]+1.5;
        SW_STCore(hp.data(),lp.data(),cp.data(),m,m-1,per,mult,a2.data(),u2.data(),d2.data(),r2.data(),v2.data());
        hp[m-1]=h[m-1]; lp[m-1]=l[m-1]; cp[m-1]=cl[m-1];
        SW_STCore(hp.data(),lp.data(),cp.data(),m,m-1,per,mult,a2.data(),u2.data(),d2.data(),r2.data(),v2.data());
      }
      int inc=0;
      for(int i=0;i<n;i++) if(a[i]!=a2[i]||u[i]!=u2[i]||d[i]!=d2[i]||r[i]!=r2[i]||v[i]!=v2[i]) inc++;
      printf("R %d %d\n",ret,inc);
      for(int i=0;i<n;i++)
        printf("%a %a %a %d %a %d %d\n",a[i],u[i],d[i],(int)r[i],v[i],
               SW_BarsSinceFlip(r.data(),i,per+1),SW_LastFlip(r.data(),i,per+1));
    } else if(c=="CONFL"){
      int m,a,b,cc,dd,e,f; if(scanf("%d %d %d %d %d %d %d",&m,&a,&b,&cc,&dd,&e,&f)!=7) return 2;
      printf("%d\n",SW_Confl(m,a,b,cc,dd,e,f));
    } else if(c=="LIT"){
      int d,bs,fb; if(scanf("%d %d %d",&d,&bs,&fb)!=3) return 2; printf("%d\n",SW_CellLit(d,bs,fb)?1:0);
    } else if(c=="PHASE"){
      int cf,bl,sec; unsigned now,ev; if(scanf("%d %d %d %u %u",&cf,&bl,&sec,&now,&ev)!=5) return 2;
      printf("%d\n",SW_BoxPhase(cf,bl!=0,sec,now,ev));
    } else if(c=="DIM"){
      unsigned c1,c2; double f; if(scanf("%u %u %lf",&c1,&c2,&f)!=3) return 2; printf("%u\n",(unsigned)SW_Dim(c1,c2,f));
    } else if(c=="LOTS"){
      double v,st,mn,mx; int fl=-9; if(scanf("%lf %lf %lf %lf",&v,&st,&mn,&mx)!=4) return 2;
      double r=SW_NormLots(v,st,mn,mx,fl); printf("%a %d\n",r,fl);
    } else if(c=="SETUP"){
      int d; double e,s; if(scanf("%d %lf %lf",&d,&e,&s)!=3) return 2; printf("%d\n",SW_SetupOk(d,e,s)?1:0);
    } else if(c=="HITS"){
      int n,fr,d; double st,t1,t2,t3; if(scanf("%d %d %d %lf %lf %lf %lf",&n,&fr,&d,&st,&t1,&t2,&t3)!=7) return 2;
      std::vector<double> h(n),l(n); for(int i=0;i<n;i++) if(scanf("%lf %lf",&h[i],&l[i])!=2) return 2;
      int iS,i1,i2,i3,best; SW_Hits(h.data(),l.data(),fr,n,d,st,t1,t2,t3,iS,i1,i2,i3);
      int s=SW_SetupState(iS,i1,i2,i3,best); printf("%d %d %d %d %d %d\n",iS,i1,i2,i3,s,best);
    } else if(c=="GPRE"){
      long long tl,key; int ok; if(scanf("%lld %lld %d",&tl,&key,&ok)!=3) return 2; printf("%d\n",SW_GatePre(tl,key,ok!=0));
    } else if(c=="GPOST"){
      int got,mn,want,sy; long long lt,tl; if(scanf("%d %d %d %d %lld %lld",&got,&mn,&want,&sy,&lt,&tl)!=6) return 2;
      printf("%d\n",SW_GatePost(got,mn,want,sy!=0,lt,tl));
    } else return 3;
  }
  return 0;
}
'''


def pure_block(src):
    a = src.index("//@@SW41_PURE_BEGIN")
    b = src.index("//@@SW41_PURE_END")
    return src[a:b]


def to_cxx(block):
    """unici adattamenti MQL5 -> C++: array per riferimento -> puntatore; long -> long long."""
    out = re.sub(r"(const\s+)?(double|int)\s*&\s*(\w+)\[\]", lambda m: (m.group(1) or "") + m.group(2) + " *" + m.group(3), block)
    out = re.sub(r"\blong\b", "long long", out)
    return out


class Cxx:
    def __init__(self, block, tmp):
        self.ok = False
        cxx = shutil.which("g++") or shutil.which("clang++")
        if not cxx:
            return
        for nm, txt in (("shim.h", SHIM), ("pure.mqh", to_cxx(block)), ("drv.cpp", DRIVER)):
            with open(os.path.join(tmp, nm), "w") as f:
                f.write(txt)
        self.exe = os.path.join(tmp, "drv")
        r = subprocess.run([cxx, "-std=c++17", "-O0", "-ffp-contract=off", "-o", self.exe, os.path.join(tmp, "drv.cpp")],
                           capture_output=True, text=True)
        self.err = r.stderr
        self.ok = (r.returncode == 0)

    def run(self, text):
        r = subprocess.run([self.exe], input=text, capture_output=True, text=True)
        if r.returncode != 0:
            raise RuntimeError("driver C++ uscito con %d" % r.returncode)
        return r.stdout.split("\n")


def series_cases():
    cases = []
    for seed in (3, 11, 29):
        cases.append(("sintetica seed %d" % seed,) + synth(1500, seed))
    # seme in parita' esatta (close == mid sulla barra 'per'): prende la mutazione >= -> >
    h, l, c = synth(400, 7)
    per = 10
    c[per] = (h[per] + l[per]) / 2.0
    cases.append(("sintetica seme in parita'", h, l, c))
    # seme GIU' e inversione SU sulla barra subito dopo: prende la mutazione "inversioni: include il seme"
    h, l, c = synth(300, 13)
    c[per] = l[per]                                  # chiusura sul minimo: seme -1
    for k in range(per + 1, per + 4):                # tre barre di rottura enorme al rialzo
        c[k] = c[k - 1] + 80.0; h[k] = c[k] + 0.5; l[k] = c[k - 1] - 0.1
    cases.append(("sintetica inversione sulla barra dopo il seme", h, l, c))
    # PAREGGI ESATTI con le bande (cancello indipendente 01/10): chiusura == banda alta della barra
    # prima con ST giu', == banda bassa con ST su. Senza questo caso il mutante 'c[i]>upF[i-1] -> >='
    # passava tutto il collaudo: nei dati reali il pareggio esatto non capita mai.
    h, l, c = synth(600, 17)
    j = 40
    for want_dir, band in ((-1, "u"), (1, "d")) * 3:
        a, u, d, r, v = st_full(h, l, c, per, 3.5)
        while j < len(c) - 5 and r[j - 1] != want_dir:
            j += 1
        if j >= len(c) - 5:
            break
        c[j] = u[j - 1] if band == "u" else d[j - 1]
        j += 30
    cases.append(("sintetica pareggi esatti con le bande", h, l, c))
    if load_real():
        for nm, mins, last in (("XAUUSD M3 reale", 3, 2500), ("XAUUSD H4 reale", 240, 2500), ("XAUUSD M1 reale", 1, 2500)):
            t, h, l, c = resample(mins, last)
            cases.append((nm, h, l, c))
    return cases


def run_identity(cx, quick_cases=None, label=""):
    """confronta C++ (blocco vero) e specchio Python. Ritorna il numero di differenze."""
    diffs = 0
    cases = quick_cases if quick_cases is not None else series_cases()
    for per, mult in ((10, 3.5), (10, 2.5), (7, 5.0), (1, 3.0)):
        for nm, h, l, c in cases:
            n = len(c)
            inp = "ST %d %d %r\n" % (n, per, mult) + "\n".join("%r %r %r" % (h[i], l[i], c[i]) for i in range(n)) + "\n"
            out = cx.run(inp)
            head = out[0].split()
            if int(head[2]) != 0:
                diffs += int(head[2])          # incrementale != batch
            a, u, d, r, v = st_full(h, l, c, per, mult)
            for i in range(n):
                p = out[1 + i].split()
                got = (float.fromhex(p[0]), float.fromhex(p[1]), float.fromhex(p[2]), int(p[3]), float.fromhex(p[4]), int(p[5]), int(p[6]))
                want = (a[i], u[i], d[i], int(r[i]), v[i], py_bsf(r, i, per + 1), py_lastflip(r, i, per + 1))
                if got != want:
                    diffs += 1
    rnd = random.Random(5)
    lines, want = [], []
    for mode in (0, 1):
        for dH4 in (-1, 0, 1):
            for dM3 in (-1, 0, 1):
                for bsH4 in range(-1, 8):
                    for bsM3 in range(-1, 7):
                        for fl in (0, 1, 3, 5):
                            for stb in (0, 1, 3, 6):
                                lines.append("CONFL %d %d %d %d %d %d %d" % (mode, dH4, bsH4, dM3, bsM3, fl, stb))
                                want.append(str(py_confl(mode, dH4, bsH4, dM3, bsM3, fl, stb)))
    for d in (-1, 0, 1):
        for bs in range(-1, 6):
            for fb in range(0, 4):
                lines.append("LIT %d %d %d" % (d, bs, fb)); want.append("1" if py_lit(d, bs, fb) else "0")
    for _ in range(4000):
        cf = rnd.choice((-1, 0, 1)); bl = rnd.choice((0, 1)); sec = rnd.choice((0, 1, 5, 20, -3))
        ev = rnd.randrange(0, 2 ** 32)
        el = rnd.choice((0, 999, 1000, 1999, 2000, sec * 1000 - 1, sec * 1000, sec * 1000 + 1, rnd.randrange(0, 60000))) % (2 ** 32)
        now = (ev + el) % (2 ** 32)
        lines.append("PHASE %d %d %d %d %d" % (cf, bl, sec, now, ev)); want.append(str(py_phase(cf, bl, sec, now, ev)))
    for _ in range(2000):
        c1 = rnd.randrange(0, 2 ** 24); c2 = rnd.randrange(0, 2 ** 24); f = rnd.choice((0.0, 0.55, 1.0, rnd.random()))
        lines.append("DIM %d %d %r" % (c1, c2, f)); want.append(str(py_dim(c1, c2, f)))
    lot_cases = [(0.3, 0.01, 0.01, 100.0), (0.29999999999, 0.01, 0.01, 100.0), (0.07, 0.01, 0.01, 100.0),
                 (0.004, 0.01, 0.01, 100.0), (1.0, 0.1, 0.1, 50.0), (2.5, 1.0, 1.0, 100.0), (120.0, 0.01, 0.01, 100.0),
                 (0.0, 0.01, 0.01, 100.0), (-1.0, 0.01, 0.01, 100.0), (0.123456, 0.001, 0.001, 10.0),
                 (5.0, 0.5, 0.5, 4.75), (0.3, 0.0, 0.01, 100.0), (0.5, 0.01, 0.01, 0.0), (33.33, 0.01, 0.01, 50.0)]
    for _ in range(3000):
        st = rnd.choice((0.01, 0.1, 1.0, 0.001, 0.5))
        lot_cases.append((rnd.choice((rnd.random() * 3, round(rnd.random() * 3, 2), rnd.randrange(1, 300) * st)), st,
                          st * rnd.choice((1, 1, 10)), rnd.choice((100.0, 1.0, 0.0, 2.5))))
    for v, st, mn, mx in lot_cases:
        lines.append("LOTS %r %r %r %r" % (v, st, mn, mx))
        r, fl = py_lots(v, st, mn, mx)
        want.append(("LOTS", r, fl))
    for _ in range(2000):
        d = rnd.choice((-1, 0, 1)); e = rnd.choice((100.0, 1.2345)); s = rnd.choice((e, e + 1, e - 1, 0.0, -1.0))
        lines.append("SETUP %d %r %r" % (d, e, s)); want.append("1" if py_setupok(d, e, s) else "0")
    for _ in range(1500):
        n = rnd.randrange(1, 40); d = rnd.choice((-1, 1)); e = 100.0
        stp = e - d * rnd.choice((1.0, 2.0)); risk = abs(e - stp)
        t1, t2, t3 = e + d * risk, e + d * 2 * risk, e + d * 3 * risk
        hh, ll = [], []
        for i in range(n):
            m = e + rnd.choice((-1, 1)) * rnd.choice((0, 1, 2, 3, 4)) * risk * rnd.random()
            hh.append(round(m + rnd.random() * risk * 2, 1)); ll.append(round(m - rnd.random() * risk * 2, 1))
            if rnd.random() < 0.15: hh[-1] = t1 if d > 0 else stp     # tocchi ESATTI (confini <= / >=)
            if rnd.random() < 0.15: ll[-1] = stp if d > 0 else t1
        fr = rnd.choice((0, 1))
        lines.append("HITS %d %d %d %r %r %r %r\n" % (n, fr, d, stp, t1, t2, t3) + "\n".join("%r %r" % (hh[i], ll[i]) for i in range(n)))
        iS, i1, i2, i3 = py_hits(hh, ll, fr, n, d, stp, t1, t2, t3)
        st, best = py_state(iS, i1, i2, i3)
        want.append("%d %d %d %d %d %d" % (iS, i1, i2, i3, st, best))
    for tl in (0, -5, 100, 200):
        for key in (0, 100, 200):
            for ok in (0, 1):
                lines.append("GPRE %d %d %d" % (tl, key, ok)); want.append(str(py_gpre(tl, key, ok)))
    for got in (-1, 0, 15, 16, 399, 400, 1000):
        for sy in (0, 1):
            for lt in (100, 200):
                lines.append("GPOST %d %d %d %d %d %d" % (got, 16, 1000 if got != 399 else 400, sy, lt, 100))
                want.append(str(py_gpost(got, 16, 1000 if got != 399 else 400, sy, lt, 100)))
    out = cx.run("\n".join(lines) + "\n")
    for i, w in enumerate(want):
        if isinstance(w, tuple):            # lotti: si confronta il NUMERO (%a di C e float.hex scrivono zeri diversi)
            p = out[i].split()
            if float.fromhex(p[0]) != w[1] or int(p[1]) != w[2]:
                diffs += 1
        elif out[i].strip() != w:
            diffs += 1
    return diffs


MUTANTS = [
    ("confluenza M3: >= flipM3 -> > flipM3", "if(bsM3<0 || bsM3>=flipM3) return 0;", "if(bsM3<0 || bsM3>flipM3) return 0;"),
    ("H4 stabile: < stableH4 -> <= stableH4", "bsH4<stableH4) return 0;", "bsH4<=stableH4) return 0;"),
    ("verso M3 contro H4 non controllato", "if(dM3!=dH4) return 0;", "if(false) return 0;"),
    ("modo 0 senza confronto", "return (dH4==dM3) ? dH4 : 0;", "return dH4;"),
    ("lotti senza tolleranza", "double k=MathFloor(v/st+1e-7);", "double k=MathFloor(v/st);"),
    ("lotti senza tetto massimo", "if(vmax>0.0 && lot>vmax)", "if(false && lot>vmax)"),
    ("banda alta con c[i] invece di c[i-1]", "upF[i]=(ub<upF[i-1] || c[i-1]>upF[i-1])", "upF[i]=(ub<upF[i-1] || c[i]>upF[i-1])"),
    ("ATR con un TR in meno", "for(int k=i-per+1;k<=i;k++)", "for(int k=i-per+1;k<i;k++)"),
    ("seme: >= mid -> > mid", "dir[i]=(c[i]>=mid) ? 1.0 : -1.0;", "dir[i]=(c[i]>mid) ? 1.0 : -1.0;"),
    ("gate: non sincronizzata sempre provvisoria", "if(!synced) return (got>=want) ? 3 : 1;", "if(!synced) return 3;"),
    ("gate: chiave ignora ok", "if(ok && key==tl) return 0;", "if(key==tl) return 0;"),
    ("lampeggio: >= -> >", "if(el>=(uint)blinkSec*1000) return 1;", "if(el>(uint)blinkSec*1000) return 1;"),
    ("inversioni: include il seme", "for(int i=last;i>first;i--)", "for(int i=last;i>=first;i--)"),
    ("tocchi: stop con < invece di <=", "if(iStop<0 && l[i]<=stop) iStop=i;", "if(iStop<0 && l[i]<stop) iStop=i;"),
    ("stato: TP1 nella barra dello stop contato come prima", "if(i1>=0 && (iStop<0 || i1<iStop)) best=1;", "if(i1>=0 && (iStop<0 || i1<=iStop)) best=1;"),
    ("cella: bs < flipBars -> <=", "return (d!=0 && bs>=0 && bs<flipBars);", "return (d!=0 && bs>=0 && bs<=flipBars);"),
    ("ST: pareggio con la banda alta conta come rottura", "         if(c[i]>upF[i-1])\n", "         if(c[i]>=upF[i-1])\n"),
    ("ST: pareggio con la banda bassa conta come rottura", "            if(c[i]<dnF[i-1])\n", "            if(c[i]<=dnF[i-1])\n"),
]


def section_c(src):
    print("== C) funzioni PURE vere (estratte dal .mq5, compilate C++) == specchio Python ==")
    block = pure_block(src)
    with tempfile.TemporaryDirectory() as tmp:
        cx = Cxx(block, tmp)
        if not cx.ok:
            if shutil.which("g++") or shutil.which("clang++"):
                check(False, "il blocco PURE compila come C++ (errori: %s)" % cx.err[:600])
            else:
                print("  SALTATO: nessun compilatore C++ -> si prova SOLO lo specchio")
            return
        d = run_identity(cx)
        check(d == 0, "C++ del blocco vero == specchio Python, bit per bit, batch e incrementale (%d differenze)" % d)
        quick = series_cases()[:6]
        for label, old, new in MUTANTS:
            if block.count(old) != 1:
                check(False, "mutante '%s': testo da mutare non trovato una volta sola" % label)
                continue
            with tempfile.TemporaryDirectory() as t2:
                cm = Cxx(block.replace(old, new, 1), t2)
                if not cm.ok:
                    check(False, "mutante '%s' non compila" % label)
                    continue
                md = run_identity(cm, quick_cases=quick)
                check(md > 0, "mutante RILEVATO: %s (%d differenze)" % (label, md))


# ===========================================================================
# M) misure
# ===========================================================================
def iatr_mt5(h, l, c, P):
    """ATR.mq5 di serie: TR[0]=0, primo valore = media dei TR 1..P, poi somma che scorre."""
    n = len(c); tr = [0.0] * n; a = [0.0] * n
    for i in range(1, n):
        tr[i] = max(h[i], c[i - 1]) - min(l[i], c[i - 1])
    f = 0.0
    for i in range(1, P + 1):
        f += tr[i]
    f /= P
    a[P] = f
    for i in range(P + 1, n):
        a[i] = a[i - 1] + (tr[i] - tr[i - P]) / P
    return a


def recv_chart(h, l, c, P, mult):
    """v4.00, grafico: ComputeST con iATR (r.189-209 del ricevuto)."""
    n = len(c); a = iatr_mt5(h, l, c, P); up = [0.0] * n; dn = [0.0] * n; val = [None] * n; d = [0] * n
    for i in range(P + 1, n):
        if a[i] == 0:
            continue
        mid = (h[i] + l[i]) / 2.0; ub = mid + mult * a[i]; lb = mid - mult * a[i]
        if i == P + 1:
            up[i] = ub; dn[i] = lb; val[i] = lb; d[i] = 1
            continue
        up[i] = ub if (ub < up[i - 1] or c[i - 1] > up[i - 1]) else up[i - 1]
        dn[i] = lb if (lb > dn[i - 1] or c[i - 1] < dn[i - 1]) else dn[i - 1]
        if c[i] > up[i - 1]: dd = 1
        elif c[i] < dn[i - 1]: dd = -1
        else: dd = 1 if val[i - 1] == dn[i - 1] else -1
        val[i] = dn[i] if dd > 0 else up[i]; d[i] = dd
    return d


def recv_grid_at(h, l, c, e, P, mult, need):
    """v4.00, griglia: STdir (r.436-471): Wilder su 'need' barre con la formante e+1; legge n-2."""
    s = e + 2 - need
    if s < 0:
        return 0, False
    n = need
    H = h[s:s + n]; L = l[s:s + n]; C = c[s:s + n]
    atr = [0.0] * n; sm = 0.0
    for i in range(1, n):
        tr = max(H[i] - L[i], max(abs(H[i] - C[i - 1]), abs(L[i] - C[i - 1])))
        if i <= P:
            sm += tr; atr[i] = sm / P
        else:
            atr[i] = (atr[i - 1] * (P - 1) + tr) / P
    up = [0.0] * n; dn = [0.0] * n; d = [0] * n; st = P + 1
    for i in range(st, n - 1):
        mid = (H[i] + L[i]) / 2.0; ub = mid + mult * atr[i]; lb = mid - mult * atr[i]
        if i == st:
            up[i] = ub; dn[i] = lb; d[i] = 1 if C[i] >= mid else -1
            continue
        up[i] = ub if (ub < up[i - 1] or C[i - 1] > up[i - 1]) else up[i - 1]
        dn[i] = lb if (lb > dn[i - 1] or C[i - 1] < dn[i - 1]) else dn[i - 1]
        if C[i] > up[i - 1]: d[i] = 1
        elif C[i] < dn[i - 1]: d[i] = -1
        else: d[i] = d[i - 1]
    last = n - 2
    if last < st + 1:
        return 0, False
    return d[last], (last > st and d[last] != d[last - 1])


def m1_recv(P=10, MULT=3.5):
    print("== M1) v4.00 ricevuta: griglia (Wilder, 90 barre) contro grafico (iATR SMA, storico intero) su XAUUSD reale ==")
    NEED = P + 80
    res = {}
    plan = (("M1", 1, 20000), ("M3", 3, 60000 if RAPIDO else 150000), ("M5", 5, 30000), ("M15", 15, 30000),
            ("H1", 60, None), ("H4", 240, None), ("D1", 1440, None))
    for name, m, last in plan:
        T, H, L, C = resample(m, last)
        dc = recv_chart(H, L, C, P, MULT)
        n = len(C); dg = [0] * n; fg = [False] * n
        for e in range(NEED, n - 1):
            dg[e], fg[e] = recv_grid_at(H, L, C, e, P, MULT, NEED)
        rng = range(max(NEED, 300), n - 1)
        dmis = sum(1 for e in rng if dg[e] != dc[e])
        fc = set(e for e in rng if dc[e] != dc[e - 1]); fgs = set(e for e in rng if fg[e])
        print("  %-3s barre %6d | direzione griglia != grafico: %5d (%.2f%%) | inversioni grafico %4d, griglia %4d, "
              "solo grafico %4d, solo griglia %4d" % (name, len(rng), dmis, 100.0 * dmis / len(rng), len(fc), len(fgs),
                                                      len(fc - fgs), len(fgs - fc)))
        res[name] = (T, dg, dc, dmis)
    check(all(v[3] > 0 for v in res.values()), "difetto 5 CONFERMATO: la griglia v4.00 e il grafico divergono su ogni TF")
    T4, g4, c4, _ = res["H4"]
    T3, g3, c3, _ = res["M3"]
    import bisect
    ends4 = [t + 240 for t in T4]
    tot = fg_ = fc_ = falsi = 0
    for k in range(400, len(T3) - 1):
        j = bisect.bisect_right(ends4, T3[k] + 3) - 1
        if j < 400:
            continue
        tot += 1
        G = g4[j] != 0 and g4[j] == g3[k]
        Cc = c4[j] != 0 and c4[j] == c3[k]
        fg_ += G; fc_ += Cc
        if G and not Cc:
            falsi += 1
    print("  confluenza v4.00 (stessa direzione) su %d barre M3 (%.0f giorni): griglia %.1f%% del tempo, grafico %.1f%%"
          % (tot, (T3[-1] - T3[-tot]) / 1440.0, 100.0 * fg_ / tot, 100.0 * fc_ / tot))
    print("  LAMPEGGIA ma sul grafico H4 e M3 NON concordano: %d barre M3 = %.2f%% del tempo, %.1f%% dei lampeggi"
          % (falsi, 100.0 * falsi / tot, 100.0 * falsi / max(1, fg_)))
    check(falsi > 0, "segnalazione di Claudio RIPRODOTTA: simboli che lampeggiano con H4/M3 discordi sul grafico")
    check(0.40 < fg_ / tot < 0.60, "difetto 1 MISURATO: in modo 0 il simbolo e' in confluenza ~meta' del tempo (%.1f%%)" % (100.0 * fg_ / tot))


def lag_from(H, L, C, s, du, uf, nf, per, mult, maxlen):
    n = min(len(C), s + maxlen)
    up = dn = 0.0; d = 0
    for i in range(s + per, n):
        sm = 0.0
        for k in range(i - per + 1, i + 1):
            sm += max(H[k], C[k - 1]) - min(L[k], C[k - 1])
        a = sm / per; mid = (H[i] + L[i]) / 2.0; ub = mid + mult * a; lb = mid - mult * a
        if i == s + per:
            up = ub; dn = lb; d = 1 if C[i] >= mid else -1
        else:
            pu, pd = up, dn
            up = ub if (ub < pu or C[i - 1] > pu) else pu
            dn = lb if (lb > pd or C[i - 1] < pd) else pd
            if C[i] > pu: d = 1
            elif C[i] < pd: d = -1
        if d == du[i] and up == uf[i] and dn == nf[i]:
            return i - s + 1
    return None


def m2_need(src, per=10):
    print("== M2) v4.1: barre perche' la finestra agganci lo stato dello storico intero (classe 950) ==")
    W = int(re.search(r"input int\s+InpGridBars\s*=\s*(\d+)", src).group(1))
    trust = int(re.search(r"#define SW_TRUST_BARS\s+(\d+)", src).group(1))
    rnd = random.Random(9)
    worst = {}
    for name, m in (("M1", 1), ("M3", 3), ("M5", 5), ("M15", 15), ("H1", 60), ("H4", 240), ("D1", 1440)):
        T, H, L, C = resample(m, 40000 if not RAPIDO else 15000)
        N = len(C)
        for mult in (3.5, 5.0):
            a, u, d, r, v = st_full(H, L, C, per, mult)
            du = [int(x) for x in r]
            nstart = min(1500 if not RAPIDO else 400, max(0, N - 1600))
            starts = rnd.sample(range(500, N - 1100), nstart) if N > 1700 else list(range(200, max(201, N - 900), 3))
            lags = [lag_from(H, L, C, s, du, u, d, per, mult, 1000) for s in starts]
            mai = sum(1 for x in lags if x is None)
            vals = sorted(x for x in lags if x is not None)
            mx = vals[-1] if vals else None
            worst[(name, mult)] = (mx, mai)
            print("  %-3s mult %.1f: %4d partenze, lag mediano %3s, p99 %3s, MASSIMO %3s, mai agganciate entro 1000: %d"
                  % (name, mult, len(starts), vals[len(vals) // 2] if vals else "-",
                     vals[int(len(vals) * 0.99)] if vals else "-", mx, mai))
    mx35 = max(v[0] for k, v in worst.items() if k[1] == 3.5)
    mx50 = max(v[0] for k, v in worst.items() if k[1] == 5.0)
    nev = sum(v[1] for v in worst.values())
    check(nev == 0, "ogni partenza aggancia lo stato entro 1000 barre")
    check(mx35 < trust and mx50 < trust, "massimo aggancio (3,5: %d; 5,0: %d) sotto SW_TRUST_BARS=%d" % (mx35, mx50, trust))
    check(trust + 100 <= W, "finestra di default %d = zona affidabile %d + almeno 100 barre" % (W, trust))
    # contro-esempio: finestra CORTA (60 barre) deve dare stati diversi dallo storico intero
    T, H, L, C = resample(3, 20000)
    a, u, d, r, v = st_full(H, L, C, per, 3.5)
    bad = 0
    ends = rnd.sample(range(2000, len(C)), 400)
    for e in ends:
        s = e - 60 + 1
        a2, u2, d2, r2, v2 = st_full(H[s:e + 1], L[s:e + 1], C[s:e + 1], per, 3.5)
        if not (r2[-1] == r[e] and u2[-1] == u[e] and d2[-1] == d[e]):
            bad += 1
    check(bad > 0, "contro-esempio: a 60 barre lo stato della finestra NON coincide (%d/400 diversi)" % bad)
    bad = 0
    for e in ends[:150]:
        s = e - W + 1
        if s < 0:
            continue
        a2, u2, d2, r2, v2 = st_full(H[s:e + 1], L[s:e + 1], C[s:e + 1], per, 3.5)
        if not (r2[-1] == r[e] and u2[-1] == u[e] and d2[-1] == d[e]):
            bad += 1
    check(bad == 0, "a %d barre lo stato della finestra coincide con lo storico intero (%d/150 diversi)" % (W, bad))


def window_setup(H, L, C, e, W, per, mult, trust, use_trust=True):
    """setup come UpdateSlot: finestra di W barre chiuse che finisce in e. Ritorna (t_idx_globale, dir, entry, stop) o None."""
    s = e - W + 1
    a, u, d, r, v = st_full(H[s:e + 1], L[s:e + 1], C[s:e + 1], per, mult)
    last = W - 1
    first = per + 1
    fi = py_lastflip(r, last, first)
    if fi < 0:
        return None
    if use_trust and fi < first + trust:
        return "NON_AFFIDABILE"
    return (s + fi, int(r[fi]), C[s + fi], v[fi])


def m3_setup(src, per=10, mult=3.5):
    print("== M3) v4.1: setup dalla finestra (zona affidabile) == setup dallo storico intero ==")
    W = int(re.search(r"input int\s+InpGridBars\s*=\s*(\d+)", src).group(1))
    trust = int(re.search(r"#define SW_TRUST_BARS\s+(\d+)", src).group(1))
    rnd = random.Random(21)
    tot_bad = tot_bad_nt = tot_nt = tot = 0
    for name, m in (("M1", 1), ("M3", 3), ("M15", 15), ("H1", 60), ("H4", 240)):
        T, H, L, C = resample(m, 30000 if not RAPIDO else 12000)
        a, u, d, r, v = st_full(H, L, C, per, mult)
        ends = rnd.sample(range(W + 50, len(C)), min(300 if not RAPIDO else 80, len(C) - W - 50))
        bad = nt = bad_nt = 0
        for e in ends:
            fi = py_lastflip(r, e, per + 1)
            full = (fi, int(r[fi]), C[fi], v[fi]) if fi >= 0 else None
            ws = window_setup(H, L, C, e, W, per, mult, trust, True)
            wn = window_setup(H, L, C, e, W, per, mult, trust, False)
            if ws == "NON_AFFIDABILE":
                nt += 1
            elif ws != full:
                bad += 1
            if wn != full:
                bad_nt += 1
        print("  %-3s %3d punti: setup diverso dallo storico intero %d | rifiutati (zona non affidabile) %d | "
              "SENZA la regola: diversi %d" % (name, len(ends), bad, nt, bad_nt))
        tot += len(ends); tot_bad += bad; tot_nt += nt; tot_bad_nt += bad_nt
    check(tot_bad == 0, "con la zona affidabile nessun setup sbagliato (%d su %d)" % (tot_bad, tot))
    # contro-esempio COSTRUITO (risposta nota): rialzo lungo e regolare senza inversioni per 2000 barre;
    # la finestra di W barre parte su una barra che chiude sul minimo (seme GIU'): la finestra "inverte"
    # al rialzo dopo poche barre, lo storico intero no. Senza la regola quella inversione diventa un setup.
    h, l, c = trend_bars(2200, 100.0, 0.4, 8, noise=0.02)
    a, u, d, r, v = st_full(h, l, c, per, mult)
    e = len(c) - 1
    s0 = e - W + 1
    c[s0 + per] = l[s0 + per]                       # seme della finestra GIU'
    a, u, d, r, v = st_full(h, l, c, per, mult)     # lo storico intero ricalcolato con la stessa barra
    fif = py_lastflip(r, e, per + 1)
    ws = window_setup(h, l, c, e, W, per, mult, trust, True)
    wn = window_setup(h, l, c, e, W, per, mult, trust, False)
    full = (fif, int(r[fif]), c[fif], v[fif]) if fif >= 0 else None
    check(fif < s0, "costruito: nello storico intero l'ultima inversione e' PRIMA della finestra (%d < %d)" % (fif, s0))
    check(wn is not None and wn != full, "costruito: SENZA la regola la finestra fissa un setup FALSO (%s)" % (wn,))
    check(ws == "NON_AFFIDABILE", "costruito: CON la regola quel setup e' rifiutato (%s)" % (ws,))
    # e nei dati veri? si cercano finestre la cui ultima inversione e' diversa dallo storico intero
    nat = 0
    for name, m in (("M1", 1), ("M3", 3), ("M15", 15), ("H1", 60), ("H4", 240), ("D1", 1440)):
        T, H, L, C = resample(m, 60000 if not RAPIDO else 20000)
        a, u, d, r, v = st_full(H, L, C, per, mult)
        last_flip = -1
        for e in range(per + 2, len(C)):
            if r[e] != r[e - 1]:
                last_flip = e
            if e - W + 1 < 0 or last_flip < 0 or e - last_flip < W - trust:
                continue                               # inversione vera nella zona affidabile: niente da cercare
            if (e - last_flip) % 25:
                continue
            wn2 = window_setup(H, L, C, e, W, per, mult, trust, False)
            ws2 = window_setup(H, L, C, e, W, per, mult, trust, True)
            fullsu = (last_flip, int(r[last_flip]), C[last_flip], v[last_flip])
            if wn2 != fullsu:
                nat += 1
                check(ws2 == "NON_AFFIDABILE" or ws2 == fullsu, "reale %s barra %d: setup spurio fermato dalla regola" % (name, e))
    print("  casi REALI di inversione che esiste solo nella finestra (senza la regola = setup falso): %d" % nat)


def m4_confl(per=10, mult=3.5):
    print("== M4) confluenza su XAUUSD reale: modo 0 (v4.00) contro modo 1 (v4.1), stesso algoritmo v4.1 ==")
    import bisect
    T3, H3, L3, C3 = resample(3, 60000 if RAPIDO else 150000)
    T4, H4, L4, C4 = resample(240)
    a, u, d, r3, v = st_full(H3, L3, C3, per, mult)
    a, u, d, r4, v = st_full(H4, L4, C4, per, mult)
    bs3 = [py_bsf(r3, i, per + 1) if i > per + 1 else -1 for i in range(len(C3))]
    # bs di H4 in O(n): scorrendo
    bs4 = [-1] * len(C4)
    lastflip = -1
    for i in range(per + 2, len(C4)):
        if r4[i] != r4[i - 1]:
            lastflip = i
        bs4[i] = (i - lastflip) if lastflip >= 0 else -1
    ends4 = [t + 240 for t in T4]
    out = {}
    for mode, fl, stb in ((0, 3, 3), (1, 3, 0), (1, 3, 1), (1, 3, 3), (1, 3, 6), (1, 1, 3), (1, 5, 3)):
        on = ev = tot = 0
        prev = 0
        for k in range(2000, len(C3)):
            j = bisect.bisect_right(ends4, T3[k] + 3) - 1
            if j < 50:
                continue
            tot += 1
            cf = py_confl(mode, int(r4[j]), bs4[j], int(r3[k]), bs3[k], fl, stb)
            if cf != 0:
                on += 1
                if cf != prev:
                    ev += 1
            prev = cf
        days = (T3[-1] - T3[2000]) / 1440.0
        out[(mode, fl, stb)] = (on / tot, ev / days)
        print("  modo %d M3<%d H4stab %d: in confluenza %5.1f%% del tempo, eventi (accensioni) %.1f al giorno"
              % (mode, fl, stb, 100.0 * on / tot, ev / days))
    check(out[(1, 3, 3)][0] < out[(0, 3, 3)][0] / 5, "modo 1 accende il simbolo molto meno del modo 0 (%.1f%% contro %.1f%%)"
          % (100 * out[(1, 3, 3)][0], 100 * out[(0, 3, 3)][0]))


# ===========================================================================
# L) logica nuova su casi con risposta nota
# ===========================================================================
def trend_bars(n, start, step, seed, noise=0.05):
    rnd = random.Random(seed)
    h, l, c = [], [], []
    p = start
    for i in range(n):
        o = p
        cl = o + step + rnd.uniform(-noise, noise)
        h.append(max(o, cl) + 0.05); l.append(min(o, cl) - 0.05); c.append(cl)
        p = cl
    return h, l, c


def l_confl():
    print("== L1) confluenza: casi costruiti con risposta NOTA (classe 1014: un caso DEVE scattare) ==")
    per, mult = 10, 3.5
    # H4: rialzo lungo e regolare -> direzione SU stabile
    h4, l4, c4 = trend_bars(200, 100.0, 0.5, 1)
    a, u, d, r4, v = st_full(h4, l4, c4, per, mult)
    dH4 = int(r4[-1]); bsH4 = py_bsf(r4, len(c4) - 1, per + 1)
    check(dH4 == 1 and (bsH4 < 0 or bsH4 >= 3), "H4 costruito: SU e stabile (dir %d, inv %d barre fa)" % (dH4, bsH4))
    # M3: ribasso lungo, poi barra di rottura ENORME al rialzo: l'inversione cade ESATTAMENTE su quella barra
    h3, l3, c3 = trend_bars(150, 200.0, -0.3, 2)
    jump = len(c3)
    o = c3[-1]
    c3.append(o + 40.0); h3.append(o + 40.5); l3.append(o - 0.1)
    for k in range(6):                      # dopo: lieve salita (nessuna nuova inversione)
        o = c3[-1]; c3.append(o + 0.2); h3.append(o + 0.3); l3.append(o - 0.05)
    a, u, d, r3, v = st_full(h3, l3, c3, per, mult)
    fi = py_lastflip(r3, len(c3) - 1, per + 1)
    check(fi == jump and r3[fi] == 1, "M3 costruito: inversione SU esattamente sulla barra di rottura (%d == %d)" % (fi, jump))
    fired = []
    for last in range(jump - 2, len(c3)):
        bs3 = py_bsf(r3, last, per + 1)
        fired.append(py_confl(1, dH4, bsH4, int(r3[last]), bs3, 3, 3))
    # prima della rottura: 0 (M3 giu' contro H4 su); barre jump, jump+1, jump+2: +1; dopo: 0
    want = [0, 0, 1, 1, 1, 0, 0, 0, 0]
    check(fired == want, "DEVE scattare: confluenza BUY per 3 barre M3 dall'inversione, poi spenta (%s)" % fired)
    # stesso M3 ma H4 appena girato (non stabile) -> non scatta
    check(py_confl(1, 1, 1, 1, 0, 3, 3) == 0, "H4 girato 1 barra fa (non stabile): niente confluenza")
    check(py_confl(1, 1, 1, 1, 0, 3, 0) == 1, "stessa situazione con stabilita' H4 non richiesta (0): confluenza")
    check(py_confl(1, -1, 10, 1, 0, 3, 3) == 0, "M3 gira SU con H4 GIU': niente confluenza")
    check(py_confl(0, 1, 50, 1, 40, 3, 3) == 1, "modo 0 (v4.00): stessa direzione da 40 barre = confluenza (il 'sempre acceso')")
    check(py_confl(1, 1, 50, 1, 40, 3, 3) == 0, "modo 1: stessa situazione = nessuna confluenza (nessuna inversione recente)")


def l_entry():
    print("== L2) ingresso FISSO tick per tick (M1 reale -> barre M5 in formazione) ==")
    per, mult = 10, 3.5
    if not load_real():
        print("  SALTATO: dati reali assenti")
        return
    T, H, L, C = load_real()
    T, H, L, C = T[-60000:], H[-60000:], L[-60000:], C[-60000:]
    # costruzione M5 incrementale: a ogni M1 la barra M5 in formazione cambia
    bt, bh, bl, bc = [], [], [], []
    entries_fixed = {}
    entries_v400 = {}
    changes_fixed_within = 0
    flips_seen = 0
    prev_setup = None
    cache_t = None
    W = 1000
    for i in range(len(T)):
        b = T[i] // 5
        if not bt or bt[-1] != b:
            bt.append(b); bh.append(H[i]); bl.append(L[i]); bc.append(C[i])
            newbar = True
        else:
            bh[-1] = max(bh[-1], H[i]); bl[-1] = min(bl[-1], L[i]); bc[-1] = C[i]
            newbar = False
        n = len(bc)
        if n < W + 2:
            continue
        # v4.1: setup dalle sole barre CHIUSE (0..n-2), ricalcolo solo a barra nuova (cache)
        if newbar or cache_t is None:
            s = (n - 1) - W
            a, u, d, r, v = st_full(bh[s:n - 1], bl[s:n - 1], bc[s:n - 1], per, mult)
            fi = py_lastflip(r, W - 1, per + 1)
            setup = (bt[s + fi], bc[s + fi], v[fi], int(r[fi])) if fi >= per + 1 + 300 else prev_setup
            cache_t = bt[n - 2]
            if setup != prev_setup and prev_setup is not None:
                flips_seen += 1
                # deve cambiare solo se l'ultima barra chiusa E' la barra di inversione
                if setup[0] != bt[n - 2]:
                    changes_fixed_within += 1
            prev_setup = setup
        entries_fixed.setdefault(bt[-1], set()).add(prev_setup[1] if prev_setup else None)
        entries_v400.setdefault(bt[-1], set()).add(bc[-1])      # v4.00: ingresso = ultimo prezzo
    multi_fixed = sum(1 for k, s in entries_fixed.items() if len(s) > 1)
    multi_v400 = sum(1 for k, s in entries_v400.items() if len(s) > 1)
    check(multi_fixed == 0, "v4.1: dentro ogni barra l'ingresso non cambia mai (%d barre M5 con piu' ingressi)" % multi_fixed)
    check(changes_fixed_within == 0, "v4.1: l'ingresso cambia SOLO alla chiusura di una barra di inversione (%d eccezioni su %d cambi)"
          % (changes_fixed_within, flips_seen))
    check(flips_seen > 50, "il test ha visto davvero delle inversioni (%d)" % flips_seen)
    check(multi_v400 > 1000, "contro-esempio v4.00: l'ingresso cambia a ogni tick (%d barre M5 su %d con piu' ingressi)"
          % (multi_v400, len(entries_v400)))


def l_cache():
    print("== L3) cache + rotazione + dati non pronti (specchio del flusso di UpdateSlot/ProcessSymbol) ==")
    # 29 simboli x 7 TF, 1 giorno simulato a secondi; un simbolo con dati che mancano a tratti
    TFm = [1, 3, 5, 15, 60, 240, 1440]
    nsym, batch = 29, 6
    rnd = random.Random(4)
    key = [[0] * 7 for _ in range(nsym)]
    ok = [[False] * 7 for _ in range(nsym)]
    state = [[None] * 7 for _ in range(nsym)]
    nd = [[""] * 7 for _ in range(nsym)]
    copies = 0
    lateness = []
    rot = 0
    zeroed = 0
    retained = 0
    secs = 86400 if not RAPIDO else 21600
    closed_at = {}
    for t in range(60, secs):
        for j in range(batch):
            s = rot
            rot = (rot + 1) % nsym
            for c in range(7):
                tl = (t // (TFm[c] * 60) - 1) * TFm[c] * 60   # ora (s) dell'ultima barra chiusa
                g = py_gpre(tl if tl > 0 else 0, key[s][c], ok[s][c])
                if g == 0:
                    continue
                if g == 1:
                    nd[s][c] = "iTime"
                    continue
                copies += 1
                broken = (s == 7 and rnd.random() < 0.3)
                got = -1 if broken else 1000
                g2 = py_gpost(got, 16, 1000, True, tl, tl)
                if g2 == 1:
                    if state[s][c] is not None:
                        retained += 1
                    nd[s][c] = "CopyRates"
                    continue
                if state[s][c] is not None and nd[s][c]:
                    pass
                state[s][c] = tl
                key[s][c] = tl
                ok[s][c] = True
                nd[s][c] = ""
                if s != 7:                     # il simbolo "rotto" ritenta: il suo ritardo e' voluto
                    lateness.append(t - (tl + TFm[c] * 60))
        # una cella con stato non deve MAI tornare vuota
        for s in range(nsym):
            for c in range(7):
                if ok[s][c] and state[s][c] is None:
                    zeroed += 1
    per_min = copies / (secs / 60.0)
    v400_per_min = 29 * 7 * 20.0
    mx = max(lateness)
    print("  CopyRates al minuto: v4.1 %.1f (da 1000 barre) contro v4.00 %.0f (da 90 barre, ogni 3 s)" % (per_min, v400_per_min))
    print("  ritardo fra chiusura della barra e ricalcolo della cella: massimo %d s (rotazione %d simboli/s su %d)" % (mx, batch, nsym))
    check(per_min < v400_per_min / 50, "v4.1 fa almeno 50 volte meno CopyRates della v4.00 (%.1f contro %.0f al minuto)" % (per_min, v400_per_min))
    check(mx <= math.ceil(nsym / batch) + 1, "ogni cella si aggiorna entro un giro di rotazione (%d s <= %d s)" % (mx, math.ceil(nsym / batch) + 1))
    check(zeroed == 0, "dati non pronti: nessuna cella con stato e' mai tornata vuota")
    check(retained > 0, "il simbolo con dati mancanti ha tenuto lo stato precedente %d volte (caso che DEVE capitare)" % retained)


def l_hits():
    print("== L4) stato del setup dai tocchi: casi noti ==")
    e, stp = 100.0, 98.0
    t1, t2, t3 = 102.0, 104.0, 106.0
    cases = [
        ("niente toccato", [101, 101.5], [99.5, 99], (0, 0)),
        ("TP1 poi TP2", [102.0, 104.5], [99, 101], (2, 2)),
        ("stop esatto prima di tutto", [101, 103], [98.0, 99], (4, 0)),
        ("TP1 poi stop", [102.5, 101], [99, 97], (5, 1)),
        ("stop e TP1 nella stessa barra", [102.0], [97.5], (6, 0)),
    ]
    for nm, hh, ll, want in cases:
        hh2 = [e] + hh; ll2 = [e] + ll
        iS, i1, i2, i3 = py_hits(hh2, ll2, 1, len(hh2), 1, stp, t1, t2, t3)
        st, best = py_state(iS, i1, i2, i3)
        check((st, best) == want, "BUY %s -> stato %d, TP %d (atteso %s)" % (nm, st, best, want))
    # SELL simmetrico: stop sopra
    iS, i1, i2, i3 = py_hits([100, 101, 102.0], [100, 98.0, 99], 1, 3, -1, 102.0, 98.0, 96.0, 94.0)
    st, best = py_state(iS, i1, i2, i3)
    check((st, best) == (5, 1), "SELL: TP1 toccato poi stop toccato esatto -> stato 5, TP1 (%d,%d)" % (st, best))


def main():
    src = read(V41)
    recv = read(RICEVUTO)
    static_checks(src, recv)
    section_c(src)
    l_confl()
    l_hits()
    l_cache()
    if load_real():
        m1_recv()
        m2_need(src)
        m3_setup(src)
        m4_confl()
        l_entry()
    else:
        print("== M) SALTATE: dati reali XAUUSD non trovati in %s ==" % DATI)
    print()
    if FAILS:
        print("ESITO: %d CONTROLLI FALLITI" % len(FAILS))
        for f in FAILS:
            print("  - " + f)
        sys.exit(1)
    print("ESITO: TUTTO OK (logica e funzioni pure; NON prova la compilazione MQL5 ne' il comportamento nel terminale)")


if __name__ == "__main__":
    main()
