#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Collaudo di mql5/Indicators/ABTG_Pulsanti_Grafico.mq5 (barra di pulsanti, sola visione).

Qui NON c'e' MetaEditor: niente compila davvero l'MQL5. Il collaudo fa quello che si puo'
fare onestamente senza terminale (stesso impianto di collaudo_superwave_v41.py):

  S) STATICO sul sorgente: ASCII; parentesi; buffer/plot; nessuna funzione di trading, rete,
     file, ChartSetSymbolPeriod, StringFormat/PrintFormat; identificatori dichiarati; costanti e
     funzioni note a MQL5; nessuna variabile locale/parametro che NASCONDE una globale (l'avviso
     'c2' della v4.1: il rilevatore e' provato sul sorgente v4.1 vero, DEVE trovare 'c2');
     default degli input; testi italiani; funzioni riusate IDENTICHE alle originali (SW_* della
     v4.1, Cols*/RepairInvisibleNative di ABTG_Segnali_EMA_BB_ST); ANCORE sulle righe che vivono
     FUORI dal blocco puro (classe 1042) con i loro mutanti, che devono essere presi.
  C) FUNZIONI PURE vere (blocco //@@PG_PURE_BEGIN..END) estratte dal .mq5, compilate C++,
     confrontate BIT PER BIT con lo specchio Python (batch e incrementale come OnCalculate),
     piu' riferimenti INDIPENDENTI (pstdev, iATR di MT5, forma chiusa dell'EMA), su serie
     sintetiche, costruite (pareggi esatti, costanti) e REALI (XAUUSD M1 2021-2026).
     MUTANTI applicati al SORGENTE VERO (classe 1033): ognuno deve essere preso.
  L) LIVELLI e SETUP su dati reali con risposta nota: giorno precedente del lunedi' = venerdi'
     anche con la candela della domenica (caso che DEVE scattare, classe 1014), settimana e mese
     precedenti, notte come ComputeBox delle sedie MaxMinNotte, swing H4 non superato, numeri
     tondi; setup ORDINE simulato tick per tick (ingresso fisso dentro la barra e fra le barre
     senza inversione; contro-esempio: ingresso sulla barra in formazione = ingresso mobile).

Uso:   python3 backtest_pipeline/collaudo_pulsanti_grafico.py [--rapido]
Esce con 0 solo se tutti i controlli passano. NON prova la compilazione MQL5 ne' il terminale.
"""
import datetime as dt
import math
import os
import random
import re
import shutil
import statistics
import subprocess
import sys
import tempfile

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
SRC = os.path.join(ROOT, "mql5/Indicators/ABTG_Pulsanti_Grafico.mq5")
V41 = os.path.join(ROOT, "mql5/Indicators/ABTG_SuperWave_Dashboard_v41.mq5")
SEGN = os.path.join(ROOT, "mql5/Indicators/ABTG_Segnali_EMA_BB_ST.mq5")
DATI = os.path.join(ROOT, "backtest_pipeline/risultati_prove/oro_m1_utc_2021_2026")
RAPIDO = "--rapido" in sys.argv
DBL_MAX = sys.float_info.max

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
# Specchio Python delle funzioni pure (riga per riga dal blocco PURE)
# ===========================================================================
def py_stcore(h, l, c, n, frm, per, mult, atr, up, dn, dr, val):
    if per < 1:
        return 0
    for i in range(max(frm, 0), n):
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


def py_ema(c, per):
    n = len(c)
    e = [0.0] * n
    a = 2.0 / (per + 1.0)
    for i in range(n):
        e[i] = c[0] if i == 0 else c[i] * a + e[i - 1] * (1.0 - a)
    return e


def py_bb(c, per, dev):
    n = len(c)
    up = [DBL_MAX] * n; mid = [DBL_MAX] * n; lo = [DBL_MAX] * n
    for i in range(n):
        if i < per - 1:
            continue
        s = 0.0
        for j in range(i - per + 1, i + 1):
            s += c[j]
        m = s / per
        q = 0.0
        for k in range(i - per + 1, i + 1):
            dd = c[k] - m
            q += dd * dd
        sd = math.sqrt(q / per)
        mid[i] = m; up[i] = m + dev * sd; lo[i] = m - dev * sd
    return up, mid, lo


def py_ha(o, h, l, c):
    n = len(c)
    ho = [0.0] * n; hh = [0.0] * n; hl = [0.0] * n; hc = [0.0] * n
    for i in range(n):
        xc = (o[i] + h[i] + l[i] + c[i]) / 4.0
        xo = (o[i] + c[i]) / 2.0 if i == 0 else (ho[i - 1] + hc[i - 1]) / 2.0
        ho[i] = xo; hc[i] = xc
        hh[i] = max(h[i], max(xo, xc)); hl[i] = min(l[i], min(xo, xc))
    return ho, hh, hl, hc


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


def py_setupok(d, e, s):
    if d > 0:
        return s > 0.0 and s < e
    if d < 0:
        return s > e
    return False


def py_setup(c, dr, val, lc, first, trust):
    f = py_lastflip(dr, lc, first)
    if f < 0:
        return 1, -1, 0, 0.0, 0.0
    if f < first + trust:
        return 2, -1, 0, 0.0, 0.0
    d = int(dr[f]); e = c[f]; s = val[f]
    if not py_setupok(d, e, s):
        return 3, f, d, e, s
    return 0, f, d, e, s


def py_dow(t):
    return ((t // 86400) + 4) % 7


def py_giornoprec(t, tutti=False):
    for i in range(len(t) - 2, -1, -1):
        if tutti or 1 <= py_dow(t[i]) <= 5:
            return i
    return -1


def py_notte(now, back, daH, daM, aH, aM):
    day = (now // 86400) * 86400 - back * 86400
    te = day + aH * 3600 + aM * 60
    ts = day + daH * 3600 + daM * 60
    if ts >= te:
        ts -= 86400
    return ts, te


def cround(x):
    if x >= 0:
        fl = math.floor(x)
        return fl + 1.0 if x - fl >= 0.5 else float(fl)
    return -cround(-x)


def normd(v, d):
    p = 10.0 ** d
    return cround(v * p) / p


def py_tondi(price, step, dg):
    if step <= 0.0:
        return 0.0, 0.0
    q = price / step
    r = cround(q)
    if abs(q - r) < 1e-9:
        so, st = (r + 1.0) * step, (r - 1.0) * step
    else:
        fl = math.floor(q)
        st, so = fl * step, (fl + 1.0) * step
    return normd(so, dg), normd(st, dg)


def py_passo(fx, oro, dg, price):
    if oro:
        return 10.0
    if fx:
        return 1.0 if dg <= 3 else 0.01
    return 1000.0 if price >= 30000.0 else 100.0


def py_swing(h, l, n, k, alto):
    """riferimento INDIPENDENTE (forza bruta): dal piu' recente, il primo swing non superato."""
    kk = max(k, 1)
    for i in range(n - 2 - kk, kk - 1, -1):
        if alto:
            sw = all(h[i] >= h[i - j] and h[i] >= h[i + j] for j in range(1, kk + 1))
            if sw and all(h[j] <= h[i] for j in range(i + 1, n)):
                return i
        else:
            sw = all(l[i] <= l[i - j] and l[i] <= l[i + j] for j in range(1, kk + 1))
            if sw and all(l[j] >= l[i] for j in range(i + 1, n)):
                return i
    return -1


def py_impila(y, gap):
    out = []
    for i, v in enumerate(y):
        if i > 0 and v < out[-1] + gap:
            v = out[-1] + gap
        out.append(v)
    return out


def py_migliaia(s):
    dot = s.find(".")
    ip = s if dot < 0 else s[:dot]
    dp = "" if dot < 0 else s[dot + 1:]
    sg = ""
    if ip.startswith("-"):
        sg, ip = "-", ip[1:]
    grp = []
    while len(ip) > 3:
        grp.insert(0, ip[-3:]); ip = ip[:-3]
    grp.insert(0, ip)
    return sg + ".".join(grp) + ("," + dp if dot >= 0 else "")


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


def py_contrasto(c):
    r, g, b = c & 0xFF, (c >> 8) & 0xFF, (c >> 16) & 0xFF
    return 0x000000 if r * 299 + g * 587 + b * 114 >= 150000 else 0xFFFFFF


def py_dim(c, t, f):
    r, g, b = c & 0xFF, (c >> 8) & 0xFF, (c >> 16) & 0xFF
    r2, g2, b2 = t & 0xFF, (t >> 8) & 0xFF, (t >> 16) & 0xFF
    R = int(r + (r2 - r) * f); G = int(g + (g2 - g) * f); B = int(b + (b2 - b) * f)
    return ((B << 16) | (G << 8) | R) & 0xFFFFFFFF


def py_lotti_tot(rm, risk, ts, tv):
    if rm <= 0 or risk <= 0 or ts <= 0 or tv <= 0:
        return 0.0
    return rm / ((risk / ts) * tv)


def py_cifre(step):
    t = step if step > 0.0 else 0.01
    sd = 0
    while sd < 8 and abs(t - cround(t)) > 1e-9:
        t *= 10.0
        sd += 1
    return sd


# ===========================================================================
# Dati
# ===========================================================================
def synth(n, seed, start=1000.0):
    rnd = random.Random(seed)
    O, H, L, C = [], [], [], []
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
        o = round(o, 2); h = round(h, 2); l = round(l, 2); c = round(c, 2)
        h = max(h, o, c); l = min(l, o, c)
        O.append(o); H.append(h); L.append(l); C.append(c)
        p = c
    return O, H, L, C


_REAL = None


def load_real():
    """XAUUSD M1 2021-2026 (HistData, UTC): (t_minuti, o, h, l, c). False se mancano i file."""
    global _REAL
    if _REAL is not None:
        return _REAL
    if not os.path.isdir(DATI):
        _REAL = False
        return _REAL
    rows = []
    ep = dt.datetime(1970, 1, 1)
    years = range(2024, 2027) if RAPIDO else range(2021, 2027)
    for y in years:
        f = os.path.join(DATI, "XAUUSD_M1_UTC_%d.csv" % y)
        if not os.path.exists(f):
            continue
        with open(f) as fh:
            head = fh.readline().strip().split(",")
            ic, ih, il, io = head.index("close"), head.index("high"), head.index("low"), head.index("open")
            for ln in fh:
                p = ln.rstrip("\n").split(",")
                if len(p) < 5:
                    continue
                t = dt.datetime.strptime(p[0], "%Y-%m-%d %H:%M")
                rows.append((int((t - ep).total_seconds() // 60), float(p[io]), float(p[ih]), float(p[il]), float(p[ic])))
    rows.sort()
    _REAL = rows
    return _REAL


def resample(rows, mins):
    """barre del TF dal M1: lista di (t_inizio_min, o, h, l, c, [stati parziali (o,h,l,c) dopo ogni minuto])."""
    out = []
    cur = None
    for t, o, h, l, c in rows:
        b = t // mins
        if b != cur:
            cur = b
            out.append([b * mins, o, h, l, c, [(o, h, l, c)]])
        else:
            bar = out[-1]
            bar[2] = max(bar[2], h); bar[3] = min(bar[3], l); bar[4] = c
            bar[5].append((bar[1], bar[2], bar[3], bar[4]))
    return out


def ohlc(bars):
    return [b[1] for b in bars], [b[2] for b in bars], [b[3] for b in bars], [b[4] for b in bars]


# ===========================================================================
# S) controlli statici
# ===========================================================================
MQL_BUILTINS = set("""
SetIndexBuffer PlotIndexSetDouble PlotIndexSetInteger PlotIndexSetString IndicatorSetString IndicatorSetInteger
iTime CopyRates ObjectCreate ObjectDelete ObjectsDeleteAll ObjectFind ObjectSetInteger ObjectSetDouble
ObjectSetString ChartRedraw ChartGetInteger ChartSetInteger ChartID ChartTimePriceToXY EventSetTimer
EventKillTimer GetTickCount GetLastError Print StringLen StringFind StringSubstr StringReplace IntegerToString
DoubleToString TimeToString EnumToString TimeCurrent SymbolInfoDouble SymbolInfoInteger AccountInfoDouble
AccountInfoString ArrayResize ArraySize ArraySetAsSeries PeriodSeconds TerminalInfoInteger GlobalVariableSet
GlobalVariableGet GlobalVariableCheck GlobalVariableDel SymbolInfoSessionTrade MathMax MathMin MathAbs MathFloor MathRound MathSqrt
NormalizeDouble if for while return switch sizeof
""".split())
MQL_CONSTANTS = set("""
ACCOUNT_BALANCE ACCOUNT_CURRENCY ANCHOR_RIGHT_LOWER ANCHOR_RIGHT_UPPER BORDER_FLAT CHARTEVENT_CHART_CHANGE
CHARTEVENT_OBJECT_CLICK CHART_COLOR_CANDLE_BEAR CHART_COLOR_CANDLE_BULL CHART_COLOR_CHART_DOWN CHART_COLOR_CHART_LINE
CHART_COLOR_CHART_UP CHART_HEIGHT_IN_PIXELS CORNER_LEFT_UPPER CORNER_RIGHT_UPPER DRAW_COLOR_CANDLES DRAW_LINE
EMPTY_VALUE ENUM_CHART_PROPERTY_INTEGER ENUM_TIMEFRAMES INDICATOR_CALCULATIONS INDICATOR_COLOR_INDEX INDICATOR_DATA
INDICATOR_DIGITS INDICATOR_SHORTNAME INIT_FAILED INIT_SUCCEEDED OBJPROP_ANCHOR OBJPROP_BACK OBJPROP_BGCOLOR
OBJPROP_BORDER_COLOR OBJPROP_BORDER_TYPE OBJPROP_COLOR OBJPROP_CORNER OBJPROP_FONT OBJPROP_FONTSIZE OBJPROP_HIDDEN
OBJPROP_PRICE OBJPROP_SELECTABLE OBJPROP_STATE OBJPROP_STYLE OBJPROP_TEXT OBJPROP_TIMEFRAMES OBJPROP_TOOLTIP
OBJPROP_WIDTH OBJPROP_XDISTANCE OBJPROP_XSIZE OBJPROP_YDISTANCE OBJPROP_YSIZE OBJPROP_ZORDER OBJ_ALL_PERIODS
OBJ_BUTTON OBJ_HLINE OBJ_LABEL OBJ_NO_PERIODS OBJ_RECTANGLE_LABEL PERIOD_D1 PERIOD_H4 PERIOD_M1 PERIOD_MN1
PERIOD_W1 PLOT_EMPTY_VALUE PLOT_LABEL PLOT_LINE_COLOR REASON_CHARTCLOSE REASON_REMOVE STYLE_DASH STYLE_DOT
SATURDAY STYLE_SOLID SYMBOL_BID SYMBOL_CALC_MODE_FOREX SYMBOL_CALC_MODE_FOREX_NO_LEVERAGE SYMBOL_TRADE_CALC_MODE
SYMBOL_TRADE_TICK_SIZE SYMBOL_TRADE_TICK_VALUE SYMBOL_TRADE_TICK_VALUE_LOSS SYMBOL_VOLUME_MAX SYMBOL_VOLUME_MIN
SYMBOL_VOLUME_STEP TERMINAL_SCREEN_DPI TIME_DATE TIME_MINUTES _Digits _Period _Point _Symbol clrBlack clrFireBrick
clrGold clrHotPink clrLightSlateGray clrLime clrLimeGreen clrNONE clrOrangeRed clrRed clrSeaGreen clrWhite
""".split())
FORBIDDEN = ["OrderSend", "OrderSendAsync", "CTrade", "PositionOpen", "PositionClose", "OrderCalcMargin",
             "OrderSelect", "PositionSelect", "WebRequest", "SocketCreate", "SendFTP", "SendMail",
             "SendNotification", "StringFormat", "PrintFormat", "#include", "FileOpen", "#import",
             "ChartSetSymbolPeriod", "ChartOpen", "iCustom", "ChartIndicatorAdd", "ChartApplyTemplate",
             "Alert(", "TerminalClose", "ExpertRemove"]
TYPES = r"(?:int|double|bool|string|color|datetime|uint|long|ulong|ushort|short|char|void|MqlRates|ENUM_[A-Z_]+)"


def strip_code(src):
    """toglie commenti, stringhe e caratteri (sostituiti da segnaposto)."""
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


def decl_in(stmt):
    """nomi dichiarati da UNA istruzione 'tipo a, b=..., c[...]' (vuoto se non e' una dichiarazione)."""
    s = stmt.strip()
    m = re.match(r"^(?:input\s+|const\s+|static\s+)*(" + TYPES + r"|PG_ANGOLO)\s+(.*)$", s, re.S)
    if not m:
        return []
    body = m.group(2)
    if re.match(r"^\w+\s*\(", body):          # prototipo/firma di funzione, non una variabile
        return []
    depth = 0
    cur = ""
    parts = []
    for ch in body:
        if ch in "[({":
            depth += 1
        elif ch in "])}":
            depth -= 1
        if ch == "," and depth == 0:
            parts.append(cur); cur = ""
        else:
            cur += ch
    parts.append(cur)
    names = []
    for p in parts:
        mm = re.match(r"\s*&?\s*(\w+)", p)
        if mm:
            names.append(mm.group(1))
    return names


def scopes(code):
    """(globali, [(funzione, nome) locali e parametri]) leggendo la profondita' delle graffe."""
    glob = set()
    loc = []
    depth = 0
    buf = ""
    fname = None
    i = 0
    n = len(code)
    while i < n:
        ch = code[i]
        if ch == "{":
            if depth == 0:
                m = re.search(r"\b" + TYPES + r"\s+(\w+)\s*\(([^()]*)\)\s*$", buf, re.S)
                if m:
                    fname = m.group(1)
                    for prm in m.group(2).split(","):
                        mm = re.search(r"(\w+)\s*(\[\s*\])?\s*(=[^,]*)?$", prm.strip())
                        if mm and prm.strip():
                            loc.append((fname, mm.group(1)))
                else:
                    fname = None          # enum / inizializzatore di array globale
                    if re.search(r"=\s*$", buf):
                        for nm in decl_in(buf.rstrip().rstrip("=")):
                            glob.add(nm)
                    buf_init = True
                buf = ""
            else:
                if fname:
                    for st in re.split(r"[;]", buf):
                        for part in re.split(r"[()]", st):
                            for nm in decl_in(part):
                                loc.append((fname, nm))
                buf = ""
            depth += 1
            i += 1
            continue
        if ch == "}":
            if depth >= 1 and fname:
                for st in re.split(r"[;]", buf):
                    for part in re.split(r"[()]", st):
                        for nm in decl_in(part):
                            loc.append((fname, nm))
            depth -= 1
            buf = ""
            if depth == 0:
                fname = None
            i += 1
            continue
        if ch == ";" and depth == 0:
            for nm in decl_in(buf):
                glob.add(nm)
            buf = ""
            i += 1
            continue
        if ch == ";" and depth >= 1 and fname:
            for part in re.split(r"[()]", buf):
                for nm in decl_in(part):
                    loc.append((fname, nm))
            buf = ""
            i += 1
            continue
        if ch == "\n" and depth == 0 and buf.lstrip().startswith("#"):
            buf = ""
            i += 1
            continue
        buf += ch
        i += 1
    return glob, loc


def shadows(src):
    code = prep(strip_code(src))
    glob, loc = scopes(code)
    return sorted(set((f, nm) for f, nm in loc if nm in glob)), glob


def prep(code):
    """righe del preprocessore e 'input group' tolte: non sono istruzioni chiuse dal punto e virgola."""
    code = re.sub(r"^\s*#.*$", "", code, flags=re.M)
    return re.sub(r"\binput\s+group\s+\"S\"", "", code)


def declared_names(code):
    names = set()
    for m in re.finditer(r"#define\s+(\w+)", code):
        names.add(m.group(1))
    code = prep(code)
    for m in re.finditer(r"\b" + TYPES + r"\s+(\w+)\s*\(([^()]*)\)\s*\{", code):
        names.add(m.group(1))
        for prm in m.group(2).split(","):
            mm = re.search(r"(\w+)\s*(\[\s*\])?\s*(=[^,]*)?$", prm.strip())
            if mm:
                names.add(mm.group(1))
    for stmt in re.split(r"[;{}()]", code):
        for nm in decl_in(stmt):
            names.add(nm)
    for m in re.finditer(r"#define\s+(\w+)", code):
        names.add(m.group(1))
    for m in re.finditer(r"enum\s+(\w+)\s*\{([^}]*)\}", code):
        names.add(m.group(1))
        for e in m.group(2).split(","):
            mm = re.match(r"\s*(\w+)", e)
            if mm:
                names.add(mm.group(1))
    return names


def flat(code):
    return re.sub(r"\s+", "", code)


# regole che vivono FUORI dal blocco puro: righe ancorate (spazi tolti, codice senza commenti/stringhe)
ANCHORS = [
    ("EMA 200 mostrata dal suo calcolo", "bE200[i]=PG_MostraDa(gOn[PG_T_EMA200],i,gP200-1,kE200[i]);"),
    ("EMA 50 mostrata dal suo calcolo", "bE50[i]=PG_MostraDa(gOn[PG_T_EMA50],i,gP50-1,kE50[i]);"),
    ("EMA 9 col tasto 9/21", "bE9[i]=PG_MostraDa(gOn[PG_T_EMA921],i,gP9-1,kE9[i]);"),
    ("EMA 21 col tasto 9/21", "bE21[i]=PG_MostraDa(gOn[PG_T_EMA921],i,gP21-1,kE21[i]);"),
    ("BB alta", "bBBu[i]=PG_Mostra(gOn[PG_T_BB],kBBu[i]);"),
    ("BB media", "bBBm[i]=PG_Mostra(gOn[PG_T_BB],kBBm[i]);"),
    ("BB bassa", "bBBl[i]=PG_Mostra(gOn[PG_T_BB],kBBl[i]);"),
    ("ST su = verso +1", "bStSu[i]=PG_StLinea(gOn[PG_T_ST],kDir[i],kVal[i],1.0);"),
    ("ST giu = verso -1", "bStGiu[i]=PG_StLinea(gOn[PG_T_ST],kDir[i],kVal[i],-1.0);"),
    ("calcolo EMA 200", "PG_EMA(close,rates_total,start,gP200,kE200);"),
    ("calcolo EMA 50", "PG_EMA(close,rates_total,start,gP50,kE50);"),
    ("calcolo EMA 9", "PG_EMA(close,rates_total,start,gP9,kE9);"),
    ("calcolo EMA 21", "PG_EMA(close,rates_total,start,gP21,kE21);"),
    ("calcolo BB", "PG_BB(close,rates_total,start,gBBP,gBBD,kBBu,kBBm,kBBl);"),
    ("ST del tasto: moltiplicatore della linea", "SW_STCore(high,low,close,rates_total,start,gStP,gStM,kAtr,kUp,kDn,kDir,kVal);"),
    ("ST del setup: STESSO periodo, moltiplicatore del setup", "SW_STCore(high,low,close,rates_total,start,gStP,gSuM,kAtr,kUp2,kDn2,kDir2,kVal2);"),
    ("calcolo HA", "PG_HA(open,high,low,close,rates_total,start,kHo,kHh,kHl,kHc);"),
    ("setup sulle barre CHIUSE (rt-2)", "gSuCode=PG_Setup(close,kDir2,kVal2,rt-2,gStP+1,SW_TRUST_BARS,fi,d,e,s);"),
    ("TP1 a InpTP1_R", "gSuT1=PG_Tp(d,e,rk,InpTP1_R);"),
    ("TP2 a InpTP2_R", "gSuT2=PG_Tp(d,e,rk,InpTP2_R);"),
    ("TP3 a InpTP3_R", "gSuT3=PG_Tp(d,e,rk,InpTP3_R);"),
    ("tocchi dalla barra DOPO l'inversione", "SW_Hits(high,low,fi+1,rt-1,d,s,gSuT1,gSuT2,gSuT3,gCS,gC1,gC2,gC3);"),
    ("tocchi della barra in formazione", "SW_Hits(high,low,rt-1,rt,gSuD,gSuS,gSuT1,gSuT2,gSuT3,fs,f1,f2,f3);"),
    ("rischio in valuta", "doubleriskMoney=bal*InpRiskPct/100.0;"),
    ("lotti totali (argomenti in ordine)", "doubletotLots=PG_LottiTotali(riskMoney,risk,tickSz,tickVal);"),
    ("quota TP1", "doubleL1=SW_NormLots(totLots*InpSize1/100.0,vst,vmn,vmx,f1);"),
    ("quota TP2", "doubleL2=SW_NormLots(totLots*InpSize2/100.0,vst,vmn,vmx,f2);"),
    ("quota TP3", "doubleL3=SW_NormLots(totLots*InpSize3/100.0,vst,vmn,vmx,f3);"),
    ("giorno precedente con la regola lun-ven (sabato: cripto)", "intp=PG_GiornoPrec(tt,got,QuotaSabato(tt,got));"),
    ("valori del giorno precedente", "gLv[0]=r[p].high;gLv[1]=r[p].low;gLv[2]=r[p].close;"),
    ("valori di oggi (barra D1 in corso)", "gLv[3]=r[o].open;gLv[4]=r[o].high;gLv[5]=r[o].low;"),
    ("settimana/mese precedenti = penultima barra", "gLv[iMax]=r[got-2].high;gLv[iMin]=r[got-2].low;"),
    ("settimana: W1 su 6/7", "RefreshPrev(PERIOD_W1,6,7)"),
    ("mese: MN1 su 8/9", "RefreshPrev(PERIOD_MN1,8,9)"),
    ("notte: barre M1 dentro la finestra", "CopyRates(_Symbol,PERIOD_M1,ts,te,r)"),
    ("H4: swing alto", "PG_UltimoSwing(hh,ll,got,gH4K,true)"),
    ("H4: swing basso", "PG_UltimoSwing(hh,ll,got,gH4K,false)"),
    ("resistenza = sopra il prezzo", "boolres=(p>gPrice);"),
    ("OnDeinit ripristina sempre le candele", "voidOnDeinit(constintreason){EventKillTimer();ColsRestore();ObjectsDeleteAll(0,PFX);"),
    ("stato dei tasti tolto solo alla rimozione", "if(reason==REASON_REMOVE||reason==REASON_CHARTCLOSE)GvClear();"),
    ("tasto HA: nascondi/ripristina", "if(t==PG_T_HA){if(gOn[t]){gHealCount=0;ColsHide();}elseColsRestore();}"),
    ("avvio: HA nasconde, altrimenti ripara", "if(gOn[PG_T_HA])ColsHide();elseRepairInvisibleNative();"),
    ("stato iniziale dei tasti", "gOn[t]=PG_StatoIniziale(has,gvOn,gvIn,inp);"),
    ("colore EMA 200 sul suo plot", "PlotIndexSetInteger(9,PLOT_LINE_COLOR,InpColEma200);"),
    ("colore EMA 50 sul suo plot", "PlotIndexSetInteger(8,PLOT_LINE_COLOR,InpColEma50);"),
    ("colore EMA 9 sul suo plot", "PlotIndexSetInteger(6,PLOT_LINE_COLOR,InpColEma9);"),
    ("colore EMA 21 sul suo plot", "PlotIndexSetInteger(7,PLOT_LINE_COLOR,InpColEma21);"),
    ("un clic non ricalcola: riscrive solo cio' che si vede", "FillDisplay(0,gRT);"),
    # --- aggiunte dal cancello indipendente del 02/10 (classe 1068): righe di RACCORDO che 20 mutanti su 23
    #     cambiavano restando VERDI (periodi, stato d'avvio, HA da spento, oggi, notte, chiave GV, rischio...)
    ("periodo EMA 200 dal SUO input", 'gP200=ClampI(InpEma200,1,5000,"S");'),
    ("periodo EMA 50 dal SUO input", 'gP50=ClampI(InpEma50,1,5000,"S");'),
    ("periodo EMA 9 dal SUO input", 'gP9=ClampI(InpEma9,1,5000,"S");'),
    ("periodo EMA 21 dal SUO input", 'gP21=ClampI(InpEma21,1,5000,"S");'),
    ("periodo/deviazione Bollinger dai loro input", 'gBBP=ClampI(InpBBPeriodo,1,200,"S");gStP=ClampI(InpStPeriodo,1,200,"S");gBBD=ClampD(InpBBDev,0.01,10.0,2.0,"S");'),
    ("moltiplicatori linea 3,0 e setup 3,5 dai loro input", 'gStM=ClampD(InpStMolt,0.01,20.0,3.0,"S");gSuM=ClampD(InpSetupMolt,0.01,20.0,3.5,"S");'),
    ("stato d'avvio: l'input del SUO tasto", "boolinp=InputAvvio(t);"),
    ("stato d'avvio: ogni tasto legge il suo InpDefaultAcceso*",
     "switch(t){casePG_T_EMA200:returnInpDefaultAccesoEma200;casePG_T_EMA50:returnInpDefaultAccesoEma50;"
     "casePG_T_EMA921:returnInpDefaultAccesoEma921;casePG_T_BB:returnInpDefaultAccesoBB;casePG_T_ST:returnInpDefaultAccesoST;"
     "casePG_T_LIV:returnInpDefaultAccesoLivelli;casePG_T_HA:returnInpDefaultAccesoHA;casePG_T_ORD:returnInpDefaultAccesoOrdine;}returnfalse;"),
    ("HA disegnate SOLO col tasto acceso, colori su/giu'",
     "boolonHa=gOn[PG_T_HA];"),
    ("HA: acceso = calcolo, spento = vuoto",
     "if(onHa){bHo[i]=kHo[i];bHh[i]=kHh[i];bHl[i]=kHl[i];bHc[i]=kHc[i];bHcol[i]=(kHc[i]>=kHo[i])?0.0:1.0;}"
     "else{bHo[i]=PG_VUOTO;bHh[i]=PG_VUOTO;bHl[i]=PG_VUOTO;bHc[i]=PG_VUOTO;bHcol[i]=0.0;}"),
    ("autoriparazione HA SOLO a tasto acceso", "if(gOn[PG_T_HA]&&gHealCount<3&&"),
    ("setup: R positivo e verso come calcolato", "doublerk=MathAbs(e-s);"),
    ("setup: verso/ingresso/stop copiati come calcolati", "gSuFi=fi;gSuD=d;gSuE=e;gSuS=s;"),
    ("pannello: ingresso e stop del setup FISSO", "doubleentry=gSuE,stop=gSuS;doublerisk=MathAbs(entry-stop);"),
    ("pannello: valore e dimensione del tick", "doubletickVal=SymbolInfoDouble(_Symbol,SYMBOL_TRADE_TICK_VALUE_LOSS);"
     "if(tickVal<=0.0)tickVal=SymbolInfoDouble(_Symbol,SYMBOL_TRADE_TICK_VALUE);doubletickSz=SymbolInfoDouble(_Symbol,SYMBOL_TRADE_TICK_SIZE);"),
    ("linee ORDINE: prezzi fissi, colori ingresso/stop/TP",
     'AddItem(gSuE,"S"+PrezzoIt(gSuE),InpColIngresso,STYLE_DASH);AddItem(gSuS,"S"+PrezzoIt(gSuS),InpStopCol,STYLE_DASH);'
     'AddItem(gSuT1,"S"+PrezzoIt(gSuT1),InpColTP,STYLE_DASH);AddItem(gSuT2,"S"+PrezzoIt(gSuT2),InpColTP,STYLE_DASH);'
     'AddItem(gSuT3,"S"+PrezzoIt(gSuT3),InpColTP,STYLE_DASH);'),
    ("oggi = ULTIMA D1 letta dalla barra 0", "intgot=CopyRates(_Symbol,PERIOD_D1,0,10,r);"),
    ("oggi = indice got-1", "into=got-1;gDayT=r[o].time;"),
    ("sabato riconosciuto nei DATI (classe 1069)", "for(inti=0;i<n;i++)if(PG_Dow(t[i])==6)returntrue;returnfalse;"),
    ("notte: ore dai loro input", 'intdaH=ClampI(InpNotteDaOra,0,23,"S");intdaM=ClampI(InpNotteDaMin,0,59,"S");'
     'intaH=ClampI(InpNotteAOra,0,23,"S");intaM=ClampI(InpNotteAMin,0,59,"S");'),
    ("notte: inizio e fine nell'ordine giusto", "PG_NotteFinestra(now,back,daH,daM,aH,aM,ts,te);"),
    ("chiave GV con la ChartID (niente collisioni fra grafici)", 'return"S"+IntegerToString(ChartID())+"S"+what;'),
    ("pannello SOLO col tasto ORDINE", "if(gOn[PG_T_ORD]){if(gSuCode==0)chg=DrawTradePanel()||chg;elsechg=DrawWaitPanel()||chg;}elsechg=DeletePanel()||chg;"),
    ("linee SOLO coi loro tasti", "gItN=0;if(gOn[PG_T_LIV])AddLevelItems();if(gOn[PG_T_ORD])AddOrderItems();"),
    ("max/min di oggi si allargano col prezzo", "if(gLvOk[4]&&p>gLv[4])gLv[4]=p;if(gLvOk[5]&&p<gLv[5])gLv[5]=p;"),
    ("max/min notte si allargano col prezzo", "if(p>gLv[10])gLv[10]=p;if(p<gLv[11])gLv[11]=p;"),
    ("fusione solo di prezzi UGUALI (mezzo punto)", "doubleeps=_Point*0.5;"),
    ("barra: posizione dagli input", 'gBarY=ClampI(InpBarraY,0,5000,"S");'),
    ("barra: X dall'input", 'intx=ClampI(InpBarraX,0,5000,"S");'),
    ("settimana/mese: lette dalla barra 0 (la penultima e' la precedente)", "intgot=CopyRates(_Symbol,tf,0,3,r);"),
    ("H4: lette dalla barra 0 (quella in corso decide il 'superato')", "intgot=CopyRates(_Symbol,PERIOD_H4,0,gH4N,r);"),
    ("pannello: righe TP con il LORO prezzo e i LORO lotti",
     'strings1="S"+NumIt(InpTP1_R,1)+"S"+PrezzoIt(gSuT1)+"S"+NumIt(L1,ldg);'
     'strings2="S"+NumIt(InpTP2_R,1)+"S"+PrezzoIt(gSuT2)+"S"+NumIt(L2,ldg);'
     'strings3="S"+NumIt(InpTP3_R,1)+"S"+PrezzoIt(gSuT3)+"S"+NumIt(L3,ldg);'),
    ("pannello: rischio in valuta e lotto totale", 'stringsR="S"+NumIt(InpRiskPct,1)+"S"+NumIt(riskMoney,2)+"S"+cur+"S"+NumIt(LT,ldg)+"S";'),
    ("pannello: ora di fissaggio = CHIUSURA della barra di inversione", "datetimefixT=gSuFiT+PeriodSeconds(_Period);"),
    ("stato: prezzo = ultima chiusura", "gHitPrice=close[rt-1];"),
    ("un clic INVERTE il tasto e lo salva", 'gOn[t]=!gOn[t];GvSave("S"+IntegerToString(t),gOn[t]?1.0:0.0);'),
    ("colori dei livelli per famiglia",
     "switch(gLvFam[i]){case0:returnres?InpColResGiorno:InpColSupGiorno;case1:returnres?InpColResSett:InpColSupSett;"
     "case2:returnres?InpColResMese:InpColSupMese;case3:returnres?InpColResNotte:InpColSupNotte;"
     "case4:returnres?InpColResTondo:InpColSupTondo;}returnres?InpColResH4:InpColSupH4;"),
    ("ogni livello acceso/spento dal SUO input",
     "gLvOn[0]=InpLiv_GiornoPrecMax;gLvOn[1]=InpLiv_GiornoPrecMin;gLvOn[2]=InpLiv_GiornoPrecChiusura;"
     "gLvOn[3]=InpLiv_OggiApertura;gLvOn[4]=InpLiv_OggiMax;gLvOn[5]=InpLiv_OggiMin;"
     "gLvOn[6]=InpLiv_SettPrecMax;gLvOn[7]=InpLiv_SettPrecMin;gLvOn[8]=InpLiv_MesePrecMax;gLvOn[9]=InpLiv_MesePrecMin;"
     "gLvOn[10]=InpLiv_NotteMax;gLvOn[11]=InpLiv_NotteMin;gLvOn[12]=InpLiv_TondoSopra;gLvOn[13]=InpLiv_TondoSotto;"
     "gLvOn[14]=InpLiv_H4Max;gLvOn[15]=InpLiv_H4Min;"),
    ("notte: massimo dai massimi, minimo dai minimi", "if(r[i].high>hi)hi=r[i].high;if(r[i].low<lo)lo=r[i].low;"),
    ("H4: massimo/minimo dei LORO swing", "if(ih>=0)gLv[14]=hh[ih];if(il>=0)gLv[15]=ll[il];"),
    ("H4: ampiezza dall'input", 'gH4K=ClampI(InpH4Ampiezza,1,20,"S");gH4N=ClampI(InpH4Barre,20,5000,"S");'),
    ("numeri tondi: il passo dell'input vince", "if(InpTondoPasso>0.0)returnInpTondoPasso;"),
    ("pannello: BUY solo se il verso e' su", 'stringsDir="S"+TfName()+"S"+(dir>0?"S":"S")'),
    ("pannello: quota sotto il minimo dichiarata", 'if(f1==1||f2==1||f3==1)lotNote+="S";if(f1==2||f2==2||f3==2||ft==2)lotNote+="S";'),
    ("pannello: riga SETUP INDICATIVO - NON VALIDATO disegnata", 'LblR(q+"S",RM+6,y+13*LH,warn,C0,InpFont-1);'),
    ("pannello d'attesa: riga NON VALIDATO disegnata", 'LblR(q+"S",RM+6,y+4*LH,warn,C0,InpFont-1);'),
]
ANCHOR_MUTANTS = [
    ("EMA 50 mostra il calcolo della 200", "bE50[i] =PG_MostraDa(gOn[PG_T_EMA50],i,gP50-1,kE50[i]);",
     "bE50[i] =PG_MostraDa(gOn[PG_T_EMA50],i,gP50-1,kE200[i]);"),
    ("EMA 9/21 legata al tasto EMA 50", "bE9[i]  =PG_MostraDa(gOn[PG_T_EMA921]", "bE9[i]  =PG_MostraDa(gOn[PG_T_EMA50]"),
    ("ST giu' disegna il verso su", "bStGiu[i]=PG_StLinea(gOn[PG_T_ST],kDir[i],kVal[i],-1.0);",
     "bStGiu[i]=PG_StLinea(gOn[PG_T_ST],kDir[i],kVal[i],1.0);"),
    ("INGRESSO MOBILE: setup sulla barra in formazione", "PG_Setup(close,kDir2,kVal2,rt-2,", "PG_Setup(close,kDir2,kVal2,rt-1,"),
    ("setup col moltiplicatore della linea (3,0)", "gStP,gSuM,kAtr,kUp2", "gStP,gStM,kAtr,kUp2"),
    ("TP1 alla distanza del TP2", "gSuT1=PG_Tp(d,e,rk,InpTP1_R);", "gSuT1=PG_Tp(d,e,rk,InpTP2_R);"),
    ("LOTTO INVERTITO: argomenti scambiati", "PG_LottiTotali(riskMoney,risk,tickSz,tickVal)", "PG_LottiTotali(risk,riskMoney,tickSz,tickVal)"),
    ("tocchi contati anche sulla barra di inversione", "SW_Hits(high,low,fi+1,rt-1,", "SW_Hits(high,low,fi,rt-1,"),
    ("giorno precedente = penultima barra (domenica compresa)", "int p=PG_GiornoPrec(tt,got,QuotaSabato(tt,got));", "int p=got-2;"),
    ("giorno precedente: weekend sempre contato", "int p=PG_GiornoPrec(tt,got,QuotaSabato(tt,got));", "int p=PG_GiornoPrec(tt,got,true);"),
    ("settimana e mese scambiati", "RefreshPrev(PERIOD_W1,6,7)", "RefreshPrev(PERIOD_MN1,6,7)"),
    ("resistenza/supporto invertiti", "bool res=(p>gPrice);", "bool res=(p<gPrice);"),
    ("OnDeinit senza ripristino delle candele", "   EventKillTimer();\n   ColsRestore();", "   EventKillTimer();\n"),
    ("stato dei tasti cancellato a ogni uscita", "if(reason==REASON_REMOVE || reason==REASON_CHARTCLOSE)\n      GvClear();",
     "GvClear();"),
    ("colore EMA 200 sul plot sbagliato", "PlotIndexSetInteger(9,PLOT_LINE_COLOR,InpColEma200);", "PlotIndexSetInteger(8,PLOT_LINE_COLOR,InpColEma200);"),
    # --- mutanti del cancello indipendente del 02/10: prima del rinforzo erano VERDI (classe 1068)
    ("TP invertiti via rischio negativo", "double rk=MathAbs(e-s);", "double rk=-MathAbs(e-s);"),
    ("verso del setup invertito", "      gSuD=d;\n", "      gSuD=-d;\n"),
    ("pannello: ingresso = prezzo corrente (mobile)", "double entry=gSuE, stop=gSuS;", "double entry=gHitPrice, stop=gSuS;"),
    ("linea INGRESSO al prezzo corrente", "AddItem(gSuE, \"INGRESSO \"+PrezzoIt(gSuE)", "AddItem(gHitPrice, \"INGRESSO \"+PrezzoIt(gHitPrice)"),
    ("tick size sostituito dal point", "double tickSz=SymbolInfoDouble(_Symbol,SYMBOL_TRADE_TICK_SIZE);", "double tickSz=SymbolInfoDouble(_Symbol,SYMBOL_TRADE_TICK_VALUE);"),
    ("oggi = ieri (got-2)", "   int o=got-1;\n", "   int o=got-2;\n"),
    ("D1 lette da shift 1 (tutto sfasato di una D1)", "CopyRates(_Symbol,PERIOD_D1,0,10,r)", "CopyRates(_Symbol,PERIOD_D1,1,10,r)"),
    ("sabato: domenica scambiata per sabato", "if(PG_Dow(t[i])==6)", "if(PG_Dow(t[i])==0)"),
    ("EMA 200 col periodo della 50", "gP200=ClampI(InpEma200,", "gP200=ClampI(InpEma50,"),
    ("EMA 9 col periodo della 21", "gP9  =ClampI(InpEma9,", "gP9  =ClampI(InpEma21,"),
    ("HA disegnate anche a tasto spento", "      if(onHa)\n", "      if(true)\n"),
    ("HA: colori su/giu' invertiti", "bHcol[i]=(kHc[i]>=kHo[i]) ? 0.0 : 1.0;", "bHcol[i]=(kHc[i]>=kHo[i]) ? 1.0 : 0.0;"),
    ("HA nascoste dal timer anche a tasto spento", "   if(gOn[PG_T_HA] && gHealCount<3 &&", "   if(gHealCount<3 &&"),
    ("TASTI ACCESI ALL'AVVIO (inp=true)", "      bool inp=InputAvvio(t);\n", "      bool inp=true;\n"),
    ("HA accesa all'avvio da InputAvvio", "case PG_T_HA:     return InpDefaultAccesoHA;", "case PG_T_HA:     return true;"),
    ("notte: inizio e fine scambiati", "PG_NotteFinestra(now,back,daH,daM,aH,aM,ts,te);", "PG_NotteFinestra(now,back,aH,aM,daH,daM,ts,te);"),
    ("chiave GV senza ChartID (grafici che si pestano)", "return \"ABTGPG_\" + IntegerToString(ChartID()) + \"_\" + what;", "return \"ABTGPG_\" + what;"),
    ("linee ORDINE anche a tasto spento", "   if(gOn[PG_T_ORD])\n      AddOrderItems();", "   AddOrderItems();"),
    ("MAX DI OGGI che non sale", "if(gLvOk[4] && p>gLv[4]) gLv[4]=p;", "if(gLvOk[4] && p<gLv[4]) gLv[4]=p;"),
    ("STOP LOSS col colore dei TP", "AddItem(gSuS, \"STOP LOSS \"+PrezzoIt(gSuS),InpStopCol,", "AddItem(gSuS, \"STOP LOSS \"+PrezzoIt(gSuS),InpColTP,"),
    ("fusione di livelli solo VICINI", "double eps=_Point*0.5;", "double eps=_Point*5000.0;"),
    ("barra: Y fissa, input ignorato", "gBarY=ClampI(InpBarraY,0,5000,\"InpBarraY\");", "gBarY=ClampI(20,0,5000,\"InpBarraY\");"),
    ("settimana/mese precedenti lette da shift 1 (due settimane fa)", "int got=CopyRates(_Symbol,tf,0,3,r);", "int got=CopyRates(_Symbol,tf,1,3,r);"),
    ("H4 lette da shift 1", "CopyRates(_Symbol,PERIOD_H4,0,gH4N,r)", "CopyRates(_Symbol,PERIOD_H4,1,gH4N,r)"),
    ("pannello: lotti di TP1 presi dal TP2", "PrezzoIt(gSuT1)+\"   \"+NumIt(L1,ldg)", "PrezzoIt(gSuT1)+\"   \"+NumIt(L2,ldg)"),
    ("pannello: prezzo di TP3 preso dal TP2", "PrezzoIt(gSuT3)+\"   \"+NumIt(L3,ldg)", "PrezzoIt(gSuT2)+\"   \"+NumIt(L3,ldg)"),
    ("un clic accende sempre (non spegne)", "   gOn[t]=!gOn[t];\n", "   gOn[t]=true;\n"),
    ("stato: prezzo dal massimo", "gHitPrice=close[rt-1];", "gHitPrice=high[rt-1];"),
    ("livelli del giorno col colore della settimana", "case 0: return res ? InpColResGiorno : InpColSupGiorno;", "case 0: return res ? InpColResSett : InpColSupSett;"),
    ("APERTURA DI OGGI accesa a prescindere dall'input", "gLvOn[3]=InpLiv_OggiApertura;", "gLvOn[3]=true;"),
    ("MAX NOTTE preso dai minimi", "if(r[i].high>hi) hi=r[i].high;", "if(r[i].low>hi) hi=r[i].low;"),
    ("ULTIMO MASSIMO H4 preso dal minimo", "if(ih>=0) gLv[14]=hh[ih];", "if(ih>=0) gLv[14]=ll[ih];"),
    ("H4: ampiezza fissa, input ignorato", "gH4K =ClampI(InpH4Ampiezza,1,20,\"InpH4Ampiezza\");", "gH4K =1;"),
    ("tondi: passo dell'input ignorato", "   if(InpTondoPasso>0.0)\n      return InpTondoPasso;", "   if(false)\n      return InpTondoPasso;"),
    ("pannello: SELL scritto BUY", "(dir>0 ? \"BUY\" : \"SELL\")+\", fissato", "(dir!=0 ? \"BUY\" : \"SELL\")+\", fissato"),
    ("pannello: quota sotto il minimo taciuta", "if(f1==1 || f2==1 || f3==1) lotNote", "if(false) lotNote"),
    ("pannello: tolta la riga NON VALIDATO", "   LblR(q+\"warn\",RM+6, y+13*LH,  warn, C'230,180,60', InpFont-1);\n", ""),
]

EXPECTED_INPUTS = {
    "InpBarraX": "4", "InpBarraY": "20", "InpTastoH": "19", "InpTastoFont": "7",
    "InpDefaultAccesoEma200": "false", "InpDefaultAccesoEma50": "false", "InpDefaultAccesoEma921": "false",
    "InpDefaultAccesoBB": "false", "InpDefaultAccesoST": "false", "InpDefaultAccesoLivelli": "false",
    "InpDefaultAccesoHA": "false", "InpDefaultAccesoOrdine": "false",
    "InpEma200": "200", "InpEma50": "50", "InpEma9": "9", "InpEma21": "21",
    "InpColEma200": "clrRed", "InpColEma50": "clrWhite", "InpColEma9": "clrHotPink", "InpColEma21": "clrGold",
    "InpBBPeriodo": "20", "InpBBDev": "2.0", "InpStPeriodo": "10", "InpStMolt": "3.0",
    "InpLiv_GiornoPrecMax": "true", "InpLiv_GiornoPrecMin": "true", "InpLiv_GiornoPrecChiusura": "true",
    "InpLiv_OggiApertura": "true", "InpLiv_OggiMax": "true", "InpLiv_OggiMin": "true",
    "InpLiv_SettPrecMax": "true", "InpLiv_SettPrecMin": "true", "InpLiv_MesePrecMax": "false",
    "InpLiv_MesePrecMin": "false", "InpLiv_NotteMax": "true", "InpLiv_NotteMin": "true",
    "InpLiv_TondoSopra": "false", "InpLiv_TondoSotto": "false", "InpLiv_H4Max": "false", "InpLiv_H4Min": "false",
    "InpNotteDaOra": "23", "InpNotteDaMin": "0", "InpNotteAOra": "4", "InpNotteAMin": "59",
    "InpTondoPasso": "0.0", "InpH4Ampiezza": "2",
    "InpSetupMolt": "3.5", "InpRiskPct": "1.0", "InpTP1_R": "1.0", "InpTP2_R": "2.0", "InpTP3_R": "3.0",
    "InpSize1": "40", "InpSize2": "30", "InpSize3": "30", "InpStopCol": "clrRed", "InpColTP": "C'57,255,20'",
    "InpFont": "8", "InpBuyCol": "C'38,166,91'", "InpSellCol": "C'200,55,50'", "InpPanelCol": "C'16,18,22'",
    "InpGridCol": "C'55,58,66'", "InpTextCol": "C'205,208,214'", "InpHeadCol": "clrWhite",
}
ENGLISH = ["HIGH", "LOW", "SUPPORT", "RESISTANCE", "OPEN", "CLOSE", "PREVIOUS", "DAY", "WEEK", "MONTH", "NIGHT",
           "ROUND", "ENTRY", "TARGET ", "SWING"]


def func_body(src, name):
    m = re.search(r"\n[a-zA-Z]+\s+" + name + r"\s*\(", src)
    if not m:
        return None
    i = src.index("{", m.end())
    depth = 0
    for j in range(i, len(src)):
        if src[j] == "{":
            depth += 1
        elif src[j] == "}":
            depth -= 1
            if depth == 0:
                return src[m.start():j + 1]
    return None


def norm_fn(txt):
    """confronto 'stessa funzione': senza commenti, senza testo dentro le Print, senza spazi."""
    t = strip_code(txt)
    return flat(t)


def static_checks(src):
    print("== S) STATICO sul sorgente ==")
    nonascii = [i for i, ch in enumerate(src) if ord(ch) > 127]
    check(len(nonascii) == 0, "sorgente ASCII puro (%d caratteri non ASCII)" % len(nonascii))
    code = strip_code(src)
    for a, b in ("()", "{}", "[]"):
        check(code.count(a) == code.count(b), "parentesi %s%s bilanciate (%d/%d)" % (a, b, code.count(a), code.count(b)))
    nb = int(re.search(r"#property\s+indicator_buffers\s+(\d+)", src).group(1))
    npl = int(re.search(r"#property\s+indicator_plots\s+(\d+)", src).group(1))
    idx = [int(x) for x in re.findall(r"SetIndexBuffer\(\s*(\d+)\s*,", code)]
    check(sorted(idx) == list(range(nb)), "SetIndexBuffer 0..%d tutti presenti una volta (%d chiamate)" % (nb - 1, len(idx)))
    types = re.findall(r"#property\s+indicator_type(\d+)", src)
    check(len(types) == npl and sorted(int(t) for t in types) == list(range(1, npl + 1)), "indicator_plots=%d coincide con i tipi" % npl)
    # buffer per plot: candele colorate 5, linea 1
    need = 0
    for t in range(1, npl + 1):
        ty = re.search(r"#property\s+indicator_type%d\s+(\w+)" % t, src).group(1)
        need += {"DRAW_COLOR_CANDLES": 5, "DRAW_LINE": 1}[ty]
    calc = re.findall(r"SetIndexBuffer\(\s*(\d+)\s*,\s*\w+\s*,\s*INDICATOR_CALCULATIONS", code)
    data = re.findall(r"SetIndexBuffer\(\s*(\d+)\s*,\s*\w+\s*,\s*INDICATOR_(?:DATA|COLOR_INDEX)", code)
    check(len(data) == need, "buffer disegnati = somma dei plot (%d contro %d)" % (len(data), need))
    check(max(int(x) for x in data) < min(int(x) for x in calc), "i buffer di calcolo stanno DOPO quelli disegnati")
    for f in FORBIDDEN:
        check(f not in code, "nessun '%s' (sola visione: niente ordini, rete, file, cambio grafico, StringFormat)" % f)
    # larghezze e colori delle linee richiesti
    for plot, w, col, lab in ((10, 3, "clrRed", "EMA 200"), (9, 2, "clrWhite", "EMA 50"), (7, 1, "clrHotPink", "EMA 9"),
                              (8, 1, "clrGold", "EMA 21")):
        ok = (re.search(r"#property\s+indicator_width%d\s+%d\b" % (plot, w), src) is not None and
              re.search(r"#property\s+indicator_color%d\s+%s\b" % (plot, col), src) is not None and
              re.search(r'#property\s+indicator_label%d\s+"%s"' % (plot, lab), src) is not None)
        check(ok, "%s: plot %d, %s, spessore %d" % (lab, plot, col, w))
    # input con i default chiesti
    vin = dict((m.group(2), m.group(3).strip()) for m in re.finditer(r"^input\s+(\w+)\s+(\w+)\s*=\s*([^;]+);", src, re.M))
    for k, v in EXPECTED_INPUTS.items():
        check(vin.get(k) == v, "input %s = %s (trovato %s)" % (k, v, vin.get(k)))
    # testi dei tasti e livelli in italiano
    m = re.search(r"string\s+gObjTxt\[PG_NO\]\s*=\s*\{([^}]*)\}", src)
    btn = re.findall(r'"([^"]*)"', m.group(1)) if m else []
    check(btn == ["EMA 200", "EMA 50", "EMA 9", "EMA 21", "BOLLINGER", "SUPERTREND", "LIVELLI", "HEIKIN ASHI",
                  "ORDINE CONSIGLIATO"], "testi dei tasti nell'ordine chiesto (%s)" % btn)
    m = re.search(r"int\s+gObjTog\[PG_NO\]\s*=\s*\{([^}]*)\}", src)
    tog = [x.strip() for x in m.group(1).split(",")] if m else []
    check(tog == ["PG_T_EMA200", "PG_T_EMA50", "PG_T_EMA921", "PG_T_EMA921", "PG_T_BB", "PG_T_ST", "PG_T_LIV",
                  "PG_T_HA", "PG_T_ORD"], "le due meta' di EMA 9/21 accendono LO STESSO tasto, gli altri il proprio")
    m = re.search(r"string\s+gLvName\[PG_NLIV\]\s*=\s*\{([^}]*)\}", src, re.S)
    names = re.findall(r'"([^"]*)"', m.group(1)) if m else []
    check(len(names) == 16, "16 livelli nominati (%d)" % len(names))
    eng = [n for n in names for w in ENGLISH if re.search(r"\b" + w.strip() + r"\b", n)]
    check(not eng, "nomi dei livelli SOLO in italiano (parole inglesi: %s)" % eng)
    for want in ("MAX GIORNO PRECEDENTE", "MIN GIORNO PRECEDENTE", "CHIUSURA GIORNO PRECEDENTE", "APERTURA DI OGGI",
                 "MAX DI OGGI", "MIN DI OGGI", "MAX SETTIMANA PRECEDENTE", "MIN SETTIMANA PRECEDENTE",
                 "MAX MESE PRECEDENTE", "MIN MESE PRECEDENTE", "MAX NOTTE", "MIN NOTTE", "NUMERO TONDO SOPRA",
                 "NUMERO TONDO SOTTO", "ULTIMO MASSIMO H4", "ULTIMO MINIMO H4"):
        check(want in names, "livello '%s' presente" % want)
    for want in ('"INGRESSO "', '"STOP LOSS "', '"TP1 "', '"TP2 "', '"TP3 "',
                 '"SETUP INDICATIVO - NON VALIDATO: i lotti sono indicativi"', '"OPERAZIONE  "'):
        check(want in src, "testo %s presente" % want)
    # identificatori del progetto dichiarati
    decl = declared_names(code)
    ids = set(re.findall(r"\b((?:g|k|b)[A-Z]\w*|Inp\w+|SW_\w+|PG_\w+)\b", code))
    und = sorted(i for i in ids if i not in decl)
    check(not und, "identificatori g*/k*/b*/Inp*/SW_*/PG_* tutti dichiarati (non dichiarati: %s)" % und)
    caps = set(re.findall(r"\b([A-Z][A-Z0-9_]{2,}|clr[A-Za-z]+|_[A-Z][a-z]+)\b", code))
    badc = sorted(x for x in caps if x not in MQL_CONSTANTS and x not in decl)
    check(not badc, "ogni costante MQL5 usata e' nell'elenco delle costanti note (sconosciute: %s)" % badc)
    defined = set(m.group(1) for m in re.finditer(r"\b" + TYPES + r"\s+(\w+)\s*\([^;{]*\)\s*\{", code))
    nodef = re.sub(r"^\s*#.*$", "", code, flags=re.M)
    calls = set(re.findall(r"\b([A-Za-z_]\w*)\s*\(", nodef))
    known = defined | MQL_BUILTINS | set(TYPES.replace("(?:", "").replace(")", "").split("|"))
    unknown = sorted(c for c in calls if c not in known and not c.startswith("ENUM_"))
    check(not unknown, "ogni funzione chiamata e' definita o nota a MQL5 (sconosciute: %s)" % unknown)
    dup = [f for f in defined if len(re.findall(r"\b" + TYPES + r"\s+" + f + r"\s*\(", code)) > 1]
    check(not dup, "nessuna funzione definita due volte (%s)" % dup)
    bad = code.replace("gShowLev", "x", 1)
    und2 = sorted(i for i in set(re.findall(r"\b((?:g|k|b)[A-Z]\w*|Inp\w+|SW_\w+|PG_\w+)\b", bad.replace("gItDrawn=gItN;", "gItDrawnn=gItN;", 1)))
                  if i not in declared_names(bad))
    check(und2 == ["gItDrawnn"], "contro-esempio: un refuso di identificatore viene trovato (%s)" % und2)
    # variabili che NASCONDONO una globale (l'avviso 'c2' della v4.1)
    sh, glob = shadows(src)
    check(len(glob) > 60, "rilevatore: globali lette (%d)" % len(glob))
    check(not sh, "nessuna variabile locale o parametro con il nome di una globale (trovate: %s)" % sh)
    sh41, _ = shadows(read(V41))
    check(any(nm == "c2" for f, nm in sh41),
          "contro-esempio VERO: sul sorgente v4.1 il rilevatore trova l'avviso 'c2' (%s)" % [x for x in sh41 if x[1] == "c2"])
    inj = src.replace("   int fs=gLivFs;\n", "   int fs=gLivFs;\n   int gItN=0;\n", 1)
    shi, _ = shadows(inj)
    check(("DrawItems", "gItN") in shi, "contro-esempio costruito: una locale 'gItN' in DrawItems viene trovata")
    # funzioni RIUSATE identiche alle originali
    v41 = read(V41)
    for fn in ("SW_STCore", "SW_BarsSinceFlip", "SW_LastFlip", "SW_Dim", "SW_NormLots", "SW_SetupOk", "SW_Hits", "SW_SetupState"):
        a, b = func_body(src, fn), func_body(v41, fn)
        check(a is not None and b is not None and norm_fn(a) == norm_fn(b), "%s IDENTICA a quella della SuperWave v4.1" % fn)
    segn = read(SEGN)
    for fn in ("ColOrDefault", "ColsHide", "ColsRestore", "IsNone", "RepairInvisibleNative"):
        a, b = func_body(src, fn), func_body(segn, fn)
        check(a is not None and b is not None and norm_fn(a) == norm_fn(b),
              "%s IDENTICA a quella di ABTG_Segnali_EMA_BB_ST (testi delle Print a parte)" % fn)
    check(norm_fn(func_body(src, "SW_STCore").replace("c[i]>upF[i-1]", "c[i]>=upF[i-1]", 1)) != norm_fn(func_body(v41, "SW_STCore")),
          "contro-esempio: il confronto di identita' vede un solo carattere cambiato")
    # ANCORE (classe 1042) e loro mutanti
    fl = flat(code)
    miss = [lab for lab, a in ANCHORS if fl.count(flat(a)) != 1]
    check(not miss, "ancore delle regole fuori dal blocco puro presenti una volta (%d/%d; mancanti: %s)"
          % (len(ANCHORS) - len(miss), len(ANCHORS), miss))
    for lab, old, new in ANCHOR_MUTANTS:
        if src.count(old) != 1:
            check(False, "mutante ancora '%s': testo da mutare non trovato una volta sola (%d)" % (lab, src.count(old)))
            continue
        fl2 = flat(strip_code(src.replace(old, new, 1)))
        m2 = [l for l, a in ANCHORS if fl2.count(flat(a)) != 1]
        check(len(m2) > 0, "mutante sul sorgente vero PRESO dalle ancore: %s (%s)" % (lab, m2))
    # ridisegno solo quando cambia qualcosa: ogni ChartRedraw in OnCalculate/OnTimer/OnChartEvent e' condizionato
    oc = func_body(src, "OnCalculate")
    check("if(UpdateOverlay())\n      ChartRedraw(0);" in oc and oc.count("ChartRedraw") == 1,
          "OnCalculate ridisegna SOLO se livelli/ordine/pannello sono cambiati")
    ot = func_body(src, "OnTimer")
    check(ot.count("ChartRedraw") == 1 and "if(redraw)\n      ChartRedraw(0);" in ot, "OnTimer ridisegna solo se ha riparato o cambiato qualcosa")
    ce = func_body(src, "OnChartEvent")
    check("if(Reposition())" in ce, "scorrimento/zoom: ridisegno solo se un'etichetta si e' spostata")
    check("CopyRates" not in oc and "CopyRates" not in ot, "nessun CopyRates diretto in OnCalculate/OnTimer (solo tramite RefreshLevels)")


# ===========================================================================
# C) funzioni pure VERE compilate in C++
# ===========================================================================
SHIM = r'''
#include <cmath>
#include <cfloat>
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <string>
#include <vector>
typedef unsigned int color;
typedef unsigned int uint;
typedef long long datetime;
typedef std::string string;
#define PG_VUOTO DBL_MAX
#define clrBlack ((color)0x000000)
#define clrWhite ((color)0xFFFFFF)
inline double MathMax(double a,double b){ return a>b?a:b; }
inline double MathMin(double a,double b){ return a<b?a:b; }
inline double MathAbs(double a){ return std::fabs(a); }
inline double MathFloor(double a){ return std::floor(a); }
inline double MathRound(double a){ return std::round(a); }
inline double MathSqrt(double a){ return std::sqrt(a); }
inline double NormalizeDouble(double v,int d){ double p=std::pow(10.0,d); return std::round(v*p)/p; }
inline int StringLen(const string &s){ return (int)s.size(); }
inline int StringFind(const string &s,const string &f,int start=0){ size_t p=s.find(f,start); return p==std::string::npos?-1:(int)p; }
inline string StringSubstr(const string &s,int start,int len=-1){ if(start<0||start>=(int)s.size()) return ""; return len<0? s.substr(start): s.substr(start,len); }
'''

DRIVER = r'''
#include "shim.h"
#include "pure.mqh"
static void pa(double v){ printf("%a ",v); }
int main(){
  char cmd[32];
  while(scanf("%31s",cmd)==1){
    std::string c(cmd);
    if(c=="SER"){
      int n,p9,p21,p50,p200,bbp,stp; double bbd,stm,sum;
      if(scanf("%d %d %d %d %d %d %lf %d %lf %lf",&n,&p9,&p21,&p50,&p200,&bbp,&bbd,&stp,&stm,&sum)!=10) return 2;
      std::vector<double> o(n),h(n),l(n),cl(n);
      for(int i=0;i<n;i++) if(scanf("%lf %lf %lf %lf",&o[i],&h[i],&l[i],&cl[i])!=4) return 2;
      int NB=19;
      std::vector<std::vector<double>> B(NB,std::vector<double>(n)), Q(NB,std::vector<double>(n));
      /* batch */
      PG_EMA(cl.data(),n,0,p9,B[0].data()); PG_EMA(cl.data(),n,0,p21,B[1].data()); PG_EMA(cl.data(),n,0,p50,B[2].data()); PG_EMA(cl.data(),n,0,p200,B[3].data());
      PG_BB(cl.data(),n,0,bbp,bbd,B[4].data(),B[5].data(),B[6].data());
      SW_STCore(h.data(),l.data(),cl.data(),n,0,stp,stm,B[7].data(),B[8].data(),B[9].data(),B[10].data(),B[11].data());
      std::vector<double> a2(n);
      SW_STCore(h.data(),l.data(),cl.data(),n,0,stp,sum,a2.data(),B[12].data(),B[13].data(),B[14].data(),B[15].data());
      std::vector<double> hc(n);
      PG_HA(o.data(),h.data(),l.data(),cl.data(),n,0,B[16].data(),B[17].data(),B[18].data(),hc.data());
      /* incrementale come OnCalculate: la barra in formazione prima con valori diversi, poi con i veri; from = m-1 */
      std::vector<double> op=o,hp=h,lp=l,cp=cl, a3(n), hc2(n);
      for(int m=1;m<=n;m++){
        for(int pass=0;pass<2;pass++){
          if(pass==0){ hp[m-1]=h[m-1]+3.0; lp[m-1]=l[m-1]-2.0; cp[m-1]=cl[m-1]+1.5; }
          else { hp[m-1]=h[m-1]; lp[m-1]=l[m-1]; cp[m-1]=cl[m-1]; }
          int fr=m-1;
          PG_EMA(cp.data(),m,fr,p9,Q[0].data()); PG_EMA(cp.data(),m,fr,p21,Q[1].data()); PG_EMA(cp.data(),m,fr,p50,Q[2].data()); PG_EMA(cp.data(),m,fr,p200,Q[3].data());
          PG_BB(cp.data(),m,fr,bbp,bbd,Q[4].data(),Q[5].data(),Q[6].data());
          SW_STCore(hp.data(),lp.data(),cp.data(),m,fr,stp,stm,Q[7].data(),Q[8].data(),Q[9].data(),Q[10].data(),Q[11].data());
          SW_STCore(hp.data(),lp.data(),cp.data(),m,fr,stp,sum,a3.data(),Q[12].data(),Q[13].data(),Q[14].data(),Q[15].data());
          PG_HA(op.data(),hp.data(),lp.data(),cp.data(),m,fr,Q[16].data(),Q[17].data(),Q[18].data(),hc2.data());
        }
      }
      int inc=0;
      for(int i=0;i<n;i++){ for(int b=0;b<NB;b++) if(B[b][i]!=Q[b][i]) { inc++; break; } if(hc[i]!=hc2[i]) inc++; }
      printf("R %d\n",inc);
      for(int i=0;i<n;i++){ for(int b=0;b<NB;b++) pa(B[b][i]); pa(hc[i]); printf("\n"); }
    } else if(c=="GPREC"){
      int n,tu; if(scanf("%d %d",&n,&tu)!=2) return 2; std::vector<datetime> t(n); for(int i=0;i<n;i++) if(scanf("%lld",&t[i])!=1) return 2;
      printf("%d\n",PG_GiornoPrec(t.data(),n,tu!=0));
    } else if(c=="DOW"){
      long long t; if(scanf("%lld",&t)!=1) return 2; printf("%d\n",PG_Dow(t));
    } else if(c=="NOTTE"){
      long long now; int b,a1,a2,a3,a4; if(scanf("%lld %d %d %d %d %d",&now,&b,&a1,&a2,&a3,&a4)!=6) return 2;
      datetime ts=0,te=0; PG_NotteFinestra(now,b,a1,a2,a3,a4,ts,te); printf("%lld %lld\n",ts,te);
    } else if(c=="TONDI"){
      double p,s; int dg; if(scanf("%lf %lf %d",&p,&s,&dg)!=3) return 2; double so=0,st=0; PG_Tondi(p,s,dg,so,st); printf("%a %a\n",so,st);
    } else if(c=="PASSO"){
      int fx,oro,dg; double p; if(scanf("%d %d %d %lf",&fx,&oro,&dg,&p)!=4) return 2; printf("%a\n",PG_PassoAuto(fx!=0,oro!=0,dg,p));
    } else if(c=="SWING"){
      int n,k,al; if(scanf("%d %d %d",&n,&k,&al)!=3) return 2; std::vector<double> h(n),l(n);
      for(int i=0;i<n;i++) if(scanf("%lf %lf",&h[i],&l[i])!=2) return 2;
      printf("%d\n",PG_UltimoSwing(h.data(),l.data(),n,k,al!=0));
    } else if(c=="IMPILA"){
      int n,g; if(scanf("%d %d",&n,&g)!=2) return 2; std::vector<int> y(n+1),o2(n+1);
      for(int i=0;i<n;i++) if(scanf("%d",&y[i])!=1) return 2;
      PG_Impila(y.data(),n,g,o2.data()); for(int i=0;i<n;i++) printf("%d ",o2[i]); printf("\n");
    } else if(c=="MIGL"){
      char b[128]; if(scanf("%127s",b)!=1) return 2; printf("%s\n",PG_Migliaia(string(b)).c_str());
    } else if(c=="TP"){
      int d; double e,r,rr; if(scanf("%d %lf %lf %lf",&d,&e,&r,&rr)!=4) return 2; printf("%a\n",PG_Tp(d,e,r,rr));
    } else if(c=="LTOT"){
      double a,b,c2,d; if(scanf("%lf %lf %lf %lf",&a,&b,&c2,&d)!=4) return 2; printf("%a\n",PG_LottiTotali(a,b,c2,d));
    } else if(c=="CIFRE"){
      double s; if(scanf("%lf",&s)!=1) return 2; printf("%d\n",PG_CifreLotto(s));
    } else if(c=="LOTS"){
      double v,st,mn,mx; int fl=-9; if(scanf("%lf %lf %lf %lf",&v,&st,&mn,&mx)!=4) return 2;
      double r=SW_NormLots(v,st,mn,mx,fl); printf("%a %d\n",r,fl);
    } else if(c=="MOSTRA"){
      int on; double v; if(scanf("%d %lf",&on,&v)!=2) return 2; printf("%a\n",PG_Mostra(on!=0,v));
    } else if(c=="MOSTRADA"){
      int on,i,f; double v; if(scanf("%d %d %d %lf",&on,&i,&f,&v)!=4) return 2; printf("%a\n",PG_MostraDa(on!=0,i,f,v));
    } else if(c=="STL"){
      int on; double d,v,vs; if(scanf("%d %lf %lf %lf",&on,&d,&v,&vs)!=4) return 2; printf("%a\n",PG_StLinea(on!=0,d,v,vs));
    } else if(c=="STATO"){
      int a,b,c2,d; if(scanf("%d %d %d %d",&a,&b,&c2,&d)!=4) return 2; printf("%d\n",PG_StatoIniziale(a!=0,b!=0,c2!=0,d!=0)?1:0);
    } else if(c=="CONTR"){
      unsigned x; if(scanf("%u",&x)!=1) return 2; printf("%u\n",(unsigned)PG_Contrasto(x));
    } else if(c=="DIM"){
      unsigned c1,c3; double f; if(scanf("%u %u %lf",&c1,&c3,&f)!=3) return 2; printf("%u\n",(unsigned)SW_Dim(c1,c3,f));
    } else if(c=="HITS"){
      int n,fr,d; double st,t1,t2,t3; if(scanf("%d %d %d %lf %lf %lf %lf",&n,&fr,&d,&st,&t1,&t2,&t3)!=7) return 2;
      std::vector<double> h(n),l(n); for(int i=0;i<n;i++) if(scanf("%lf %lf",&h[i],&l[i])!=2) return 2;
      int iS,i1,i2,i3,best; SW_Hits(h.data(),l.data(),fr,n,d,st,t1,t2,t3,iS,i1,i2,i3);
      int s=SW_SetupState(iS,i1,i2,i3,best); printf("%d %d %d %d %d %d\n",iS,i1,i2,i3,s,best);
    } else if(c=="TICKS"){
      /* setup tick per tick: barre con stati parziali; ST incrementale come OnCalculate; PG_Setup su lc = m-1-lcoff+1 */
      int n,stp,lcclosed; double sum; if(scanf("%d %d %lf %d",&n,&stp,&sum,&lcclosed)!=4) return 2;
      std::vector<double> h,l,cl,a,u,d,r,v; h.reserve(n);
      int intra=0, inter=0, flips=0, setups=0; double lastE=0; int lastFi=-2; int lastCode=-9;
      std::vector<int> fiAtClose(n,-1); std::vector<double> eAtClose(n,0.0);
      for(int m=0;m<n;m++){
        int s; if(scanf("%d",&s)!=1) return 2;
        h.push_back(0); l.push_back(0); cl.push_back(0); a.push_back(0); u.push_back(0); d.push_back(0); r.push_back(0); v.push_back(0);
        double prevE=0; int prevFi=-2; bool first=true;
        for(int k=0;k<s;k++){
          double oo,hh,ll,cc; if(scanf("%lf %lf %lf %lf",&oo,&hh,&ll,&cc)!=4) return 2;
          h[m]=hh; l[m]=ll; cl[m]=cc;
          int fr=(k==0 && m>0)? m-1 : m;
          SW_STCore(h.data(),l.data(),cl.data(),m+1,fr,stp,sum,a.data(),u.data(),d.data(),r.data(),v.data());
          int lc= lcclosed ? m-1 : m;
          int fi=-1,dd=0; double e=0,st=0;
          int code=(lc>=1)? PG_Setup(cl.data(),r.data(),v.data(),lc,stp+1,0,fi,dd,e,st) : 1;
          if(!first && code==0 && (e!=prevE || fi!=prevFi)) intra++;
          prevE=e; prevFi=fi; first=false;
          if(k==s-1){
            fiAtClose[m]=fi; eAtClose[m]=e;
            if(code==0){ setups++; if(lastCode==0 && fi==lastFi && e!=lastE) inter++; }
            if(code==0 && lastCode==0 && fi!=lastFi) flips++;
            lastE=e; lastFi=fi; lastCode=code;
          }
        }
      }
      printf("%d %d %d %d\n",intra,inter,flips,setups);
      for(int m=0;m<n;m++) printf("%d %a\n",fiAtClose[m],eAtClose[m]);
    } else if(c=="SETUP"){
      int n,lc,first,trust; if(scanf("%d %d %d %d",&n,&lc,&first,&trust)!=4) return 2;
      std::vector<double> cc(n),dr(n),vv(n); for(int i=0;i<n;i++) if(scanf("%lf %lf %lf",&cc[i],&dr[i],&vv[i])!=3) return 2;
      int fi,dd; double e,s; int code=PG_Setup(cc.data(),dr.data(),vv.data(),lc,first,trust,fi,dd,e,s);
      printf("%d %d %d %a %a\n",code,fi,dd,e,s);
    } else return 3;
  }
  return 0;
}
'''


def pure_block(src):
    a = src.index("//@@PG_PURE_BEGIN")
    b = src.index("//@@PG_PURE_END")
    return src[a:b]


def to_cxx(block):
    """unici adattamenti MQL5 -> C++: array per riferimento -> puntatore; long -> long long."""
    out = re.sub(r"(const\s+)?(double|int|datetime)\s*&\s*(\w+)\[\]",
                 lambda m: (m.group(1) or "") + m.group(2) + " *" + m.group(3), block)
    out = re.sub(r"\blong\b", "long long", out)
    return out


class Cxx:
    def __init__(self, block, tmp):
        self.ok = False
        self.err = ""
        cxx = shutil.which("g++") or shutil.which("clang++")
        if not cxx:
            return
        for nm, txt in (("shim.h", SHIM), ("pure.mqh", to_cxx(block)), ("drv.cpp", DRIVER)):
            with open(os.path.join(tmp, nm), "w") as f:
                f.write(txt)
        self.exe = os.path.join(tmp, "drv")
        r = subprocess.run([cxx, "-std=c++17", "-O0", "-ffp-contract=off", "-Wall", "-Wshadow", "-o", self.exe,
                            os.path.join(tmp, "drv.cpp")], capture_output=True, text=True)
        self.err = r.stderr
        self.ok = (r.returncode == 0)

    def run(self, text):
        r = subprocess.run([self.exe], input=text, capture_output=True, text=True)
        if r.returncode != 0:
            raise RuntimeError("driver C++ uscito con %d" % r.returncode)
        return r.stdout.split("\n")


PAR_SETS = [(9, 21, 50, 200, 20, 2.0, 10, 3.0, 3.5), (3, 7, 13, 40, 5, 1.5, 7, 2.5, 5.0), (1, 2, 1, 1, 1, 2.0, 1, 3.0, 1.0)]


def series_cases(quick=False):
    cases = []
    for seed in ((3,) if quick else (3, 11, 29)):
        cases.append(("sintetica seed %d" % seed,) + synth(900, seed))
    # pareggi esatti chiusura == banda del Supertrend (prende '>' -> '>=')
    o, h, l, c = synth(600, 17)
    j = 40
    for want_dir, band in ((-1, "u"), (1, "d")) * 3:
        a, u, d, r, v = st_full(h, l, c, 10, 3.0)
        while j < len(c) - 5 and r[j - 1] != want_dir:
            j += 1
        if j >= len(c) - 5:
            break
        c[j] = u[j - 1] if band == "u" else d[j - 1]
        h[j] = max(h[j], c[j]); l[j] = min(l[j], c[j])
        j += 30
    cases.append(("sintetica pareggi esatti con le bande", o, h, l, c))
    # serie costante (risposta nota: EMA = BB = costante, bande chiuse)
    n = 80
    cases.append(("costante", [100.0] * n, [100.0] * n, [100.0] * n, [100.0] * n))
    if not quick and load_real():
        rows = load_real()
        for nm, mins, last in (("XAUUSD M5 reale", 5, 3000), ("XAUUSD H1 reale", 60, 2500)):
            bars = resample(rows[-(last * mins + 5000):], mins)[-last:]
            cases.append((nm,) + tuple(ohlc(bars)))
    return cases


def run_series(cx, cases, sets=PAR_SETS):
    diffs = 0
    inc = 0
    for prm in sets:
        p9, p21, p50, p200, bbp, bbd, stp, stm, sum_ = prm
        for nm, o, h, l, c in cases:
            n = len(c)
            txt = "SER %d %d %d %d %d %d %r %d %r %r\n" % (n, p9, p21, p50, p200, bbp, bbd, stp, stm, sum_)
            txt += "\n".join("%r %r %r %r" % (o[i], h[i], l[i], c[i]) for i in range(n)) + "\n"
            out = cx.run(txt)
            inc += int(out[0].split()[1])
            e9, e21, e50, e200 = py_ema(c, p9), py_ema(c, p21), py_ema(c, p50), py_ema(c, p200)
            bu, bm, bl = py_bb(c, bbp, bbd)
            a, u, d, r, v = st_full(h, l, c, stp, stm)
            a2, u2, d2, r2, v2 = st_full(h, l, c, stp, sum_)
            ho, hh, hl, hc = py_ha(o, h, l, c)
            for i in range(n):
                got = [float.fromhex(x) for x in out[1 + i].split()]
                want = [e9[i], e21[i], e50[i], e200[i], bu[i], bm[i], bl[i], a[i], u[i], d[i], r[i], v[i],
                        u2[i], d2[i], r2[i], v2[i], ho[i], hh[i], hl[i], hc[i]]
                if got != want:
                    diffs += 1
    return diffs, inc


def misc_lines(rnd):
    lines, want = [], []
    # giorno della settimana e giorno precedente
    for t in (0, 86400 * 3, 1727654400, 1727568000, 1727395200, 1727481600):
        lines.append("DOW %d" % t); want.append(str(py_dow(t)))
    for _ in range(400):
        n = rnd.randrange(1, 10)
        base = rnd.randrange(1600000000, 1800000000) // 86400 * 86400
        t = sorted(set(base + 86400 * rnd.randrange(0, 15) + rnd.choice((0, 82800)) for _ in range(n)))
        tu = rnd.choice((0, 1))
        lines.append("GPREC %d %d %s" % (len(t), tu, " ".join(str(x) for x in t))); want.append(str(py_giornoprec(t, tu == 1)))
    for _ in range(600):
        now = rnd.randrange(1600000000, 1800000000)
        b = rnd.randrange(0, 7)
        a1, a2, a3, a4 = rnd.choice(((23, 0, 4, 59), (0, 0, 6, 0), (22, 30, 22, 30), (1, 0, 7, 59), (rnd.randrange(24), rnd.randrange(60), rnd.randrange(24), rnd.randrange(60))))
        lines.append("NOTTE %d %d %d %d %d %d" % (now, b, a1, a2, a3, a4)); want.append("%d %d" % py_notte(now, b, a1, a2, a3, a4))
    # numeri tondi (anche prezzi esattamente su un multiplo)
    tcases = [(24998.25, 100.0, 2), (25000.0, 100.0, 2), (1.08537, 0.01, 5), (1.1, 0.01, 5), (151.234, 1.0, 3),
              (2650.0, 10.0, 2), (2649.99, 10.0, 2), (46012.0, 1000.0, 1), (0.7, 0.1, 5), (3.3, 1.1, 2)]
    for _ in range(500):
        st = rnd.choice((100.0, 10.0, 0.01, 1.0, 1000.0, 0.5))
        dg = rnd.choice((1, 2, 3, 5))
        p = round(rnd.random() * 50000, dg) if rnd.random() < 0.7 else rnd.randrange(1, 500) * st
        tcases.append((p, st, dg))
    for p, s, dg in tcases:
        lines.append("TONDI %r %r %d" % (p, s, dg)); want.append(("F2",) + py_tondi(p, s, dg))
    for fx in (0, 1):
        for oro in (0, 1):
            for dg in (1, 2, 3, 5):
                for p in (1.1, 150.0, 2650.0, 24000.0, 29999.99, 30000.0, 46000.0):
                    lines.append("PASSO %d %d %d %r" % (fx, oro, dg, p)); want.append(("F1", py_passo(fx, oro, dg, p)))
    # impilamento delle etichette
    for _ in range(400):
        n = rnd.randrange(0, 12)
        y = sorted(rnd.randrange(0, 600) for _ in range(n))
        g = rnd.choice((10, 14, 20))
        lines.append("IMPILA %d %d %s" % (n, g, " ".join(str(v) for v in y))); want.append(" ".join(str(v) for v in py_impila(y, g)))
    # formato italiano
    mc = ["24998.25", "1.08537", "123", "-1234.5", "1234567.00", "0.50", "999.9", "1000", "-12", "12345678.901", "100000"]
    for s in mc:
        lines.append("MIGL %s" % s); want.append(py_migliaia(s))
    # TP, lotti, cifre
    for d in (-1, 1):
        for e in (100.0, 24998.25, 1.0855):
            for r in (0.5, 25.0, 0.0012):
                for rr in (1.0, 2.0, 3.0, 1.5):
                    lines.append("TP %d %r %r %r" % (d, e, r, rr)); want.append(("F1", e + rr * r if d > 0 else e - rr * r))
    for rm, risk, ts, tv in ((100.0, 5.0, 0.01, 1.0), (1000.0, 25.0, 0.01, 0.01), (50.0, 0.0012, 0.00001, 1.0),
                             (0.0, 5.0, 0.01, 1.0), (100.0, 0.0, 0.01, 1.0), (100.0, 5.0, 0.0, 1.0), (100.0, 5.0, 0.01, 0.0)):
        lines.append("LTOT %r %r %r %r" % (rm, risk, ts, tv)); want.append(("F1", py_lotti_tot(rm, risk, ts, tv)))
    for s in (0.01, 0.1, 1.0, 0.001, 0.5, 0.0, 0.05):
        lines.append("CIFRE %r" % s); want.append(str(py_cifre(s)))
    # 0.29/0.01 = 28.999999999999996: i MULTIPLI esatti del passo che un MathFloor nudo sbaglia
    for v, st, mn, mx in ((0.3, 0.01, 0.01, 100.0), (0.29, 0.01, 0.01, 100.0), (0.57, 0.01, 0.01, 100.0),
                          (0.58, 0.01, 0.01, 100.0), (1.15, 0.01, 0.01, 100.0), (0.7, 0.1, 0.1, 100.0),
                          (0.08, 0.01, 0.01, 100.0), (0.06, 0.01, 0.01, 100.0),
                          (0.2, 0.01, 0.01, 100.0), (0.004, 0.01, 0.01, 100.0), (120.0, 0.01, 0.01, 100.0)):
        lines.append("LOTS %r %r %r %r" % (v, st, mn, mx)); want.append(("LOTS",) + py_lots(v, st, mn, mx))
    # cosa si mostra
    for on in (0, 1):
        for v in (1.5, -2.0):
            lines.append("MOSTRA %d %r" % (on, v)); want.append(("F1", v if on else DBL_MAX))
            for i, f in ((0, 0), (5, 6), (6, 6), (7, 6), (199, 199), (198, 199)):
                lines.append("MOSTRADA %d %d %d %r" % (on, i, f, v)); want.append(("F1", v if (on and i >= f) else DBL_MAX))
            for d in (-1.0, 0.0, 1.0):
                for vs in (-1.0, 1.0):
                    lines.append("STL %d %r %r %r" % (on, d, v, vs)); want.append(("F1", v if (on and d == vs) else DBL_MAX))
    for a in (0, 1):
        for b in (0, 1):
            for c2 in (0, 1):
                for d in (0, 1):
                    lines.append("STATO %d %d %d %d" % (a, b, c2, d))
                    want.append("1" if ((b if (a and c2 == d) else d)) else "0")
    for col in (0xFFFFFF, 0x0000FF, 0x00D7FF, 0xB469FF, 0x998877, 0x5BA626, 0xFFAA00, 0x000000, 0x28A0EB):
        lines.append("CONTR %d" % col); want.append(str(py_contrasto(col)))
    for _ in range(300):
        c1 = rnd.randrange(0, 2 ** 24); c3 = rnd.randrange(0, 2 ** 24); f = rnd.choice((0.0, 0.78, 1.0, rnd.random()))
        lines.append("DIM %d %d %r" % (c1, c3, f)); want.append(str(py_dim(c1, c3, f)))
    # tocchi e stato (anche tocchi ESATTI sui confini)
    for _ in range(600):
        n = rnd.randrange(1, 30); d = rnd.choice((-1, 1)); e = 100.0
        stp = e - d * rnd.choice((1.0, 2.0)); risk = abs(e - stp)
        t1, t2, t3 = e + d * risk, e + d * 2 * risk, e + d * 3 * risk
        hh, ll = [], []
        for i in range(n):
            m = e + rnd.choice((-1, 1)) * rnd.choice((0, 1, 2, 3, 4)) * risk * rnd.random()
            hh.append(round(m + rnd.random() * risk * 2, 1)); ll.append(round(m - rnd.random() * risk * 2, 1))
            if rnd.random() < 0.15: hh[-1] = t1 if d > 0 else stp
            if rnd.random() < 0.15: ll[-1] = stp if d > 0 else t1
        fr = rnd.choice((0, 1))
        lines.append("HITS %d %d %d %r %r %r %r\n" % (n, fr, d, stp, t1, t2, t3) + "\n".join("%r %r" % (hh[i], ll[i]) for i in range(n)))
        iS, i1, i2, i3 = py_hits(hh, ll, fr, n, d, stp, t1, t2, t3)
        st, best = py_state(iS, i1, i2, i3)
        want.append("%d %d %d %d %d %d" % (iS, i1, i2, i3, st, best))
    # setup: serie costruite (inversione, nessuna, troppo vicina, stop sbagliato)
    for _ in range(300):
        n = rnd.randrange(5, 60)
        cc = [round(100 + rnd.random() * 10, 2) for _ in range(n)]
        dr = []
        cur = rnd.choice((-1.0, 1.0))
        for i in range(n):
            if i < 3:
                dr.append(0.0); continue
            if rnd.random() < 0.15:
                cur = -cur
            dr.append(cur)
        vv = [cc[i] - dr[i] * rnd.choice((1.0, 2.0, -0.5)) for i in range(n)]
        lc = rnd.randrange(1, n); first = 3; trust = rnd.choice((0, 5, 20))
        lines.append("SETUP %d %d %d %d\n" % (n, lc, first, trust) + "\n".join("%r %r %r" % (cc[i], dr[i], vv[i]) for i in range(n)))
        want.append(("SU",) + py_setup(cc, dr, vv, lc, first, trust))
    return lines, want


def compare_misc(out, want):
    diffs = 0
    for i, w in enumerate(want):
        o = out[i].strip()
        if isinstance(w, tuple):
            p = o.split()
            if w[0] == "F1":
                ok = float.fromhex(p[0]) == w[1]
            elif w[0] == "F2":
                ok = float.fromhex(p[0]) == w[1] and float.fromhex(p[1]) == w[2]
            elif w[0] == "LOTS":
                ok = float.fromhex(p[0]) == w[1] and int(p[1]) == w[2]
            else:   # SU
                ok = (int(p[0]), int(p[1]), int(p[2]), float.fromhex(p[3]), float.fromhex(p[4])) == w[1:]
            if not ok:
                diffs += 1
        elif o != w:
            diffs += 1
    return diffs


def run_misc(cx, seed=5):
    lines, want = misc_lines(random.Random(seed))
    out = cx.run("\n".join(lines) + "\n")
    return compare_misc(out, want)


def swing_cases(rnd, real_h4=None):
    cases = []
    for _ in range(200):
        n = rnd.randrange(3, 60)
        h = [round(100 + rnd.gauss(0, 3), 1) for _ in range(n)]
        l = [x - abs(round(rnd.gauss(0, 1), 1)) for x in h]
        cases.append((h, l, rnd.choice((1, 2, 3))))
    # costruito: lo swing piu' recente e' SUPERATO, deve tornare il precedente (DEVE scattare)
    h = [100, 101, 110, 101, 100, 99, 105, 120, 104, 103, 102, 125, 101]
    l = [x - 1 for x in h]
    cases.append(([float(x) for x in h], [float(x) for x in l], 2))
    if real_h4:
        for k in (1, 2, 3):
            for off in range(0, min(len(real_h4[0]) - 300, 1500), 150):
                cases.append((real_h4[0][off:off + 300], real_h4[1][off:off + 300], k))
    return cases


def run_swings(cx, cases):
    lines, want = [], []
    for h, l, k in cases:
        n = len(h)
        for al in (1, 0):
            lines.append("SWING %d %d %d\n" % (n, k, al) + "\n".join("%r %r" % (h[i], l[i]) for i in range(n)))
            want.append(str(py_swing(h, l, n, k, al == 1)))
    out = cx.run("\n".join(lines) + "\n")
    return sum(1 for i, w in enumerate(want) if out[i].strip() != w)


PURE_MUTANTS = [
    ("EMA: alfa 2/(per+2)", "double a=2.0/(per+1.0);", "double a=2.0/(per+2.0);"),
    ("EMA: seme dimezzato", "      if(i==0) e[i]=c[0];", "      if(i==0) e[i]=c[0]*0.5;"),
    ("BB: deviazione campionaria (per-1)", "double sd=MathSqrt(q/per);", "double sd=MathSqrt(q/(per-1.0));"),
    ("BB: banda bassa sopra", "lo[i]=m-dev*sd;", "lo[i]=m+dev*sd;"),
    ("BB: una barra di riscaldamento in piu'", "if(i<per-1)\n", "if(i<per)\n"),
    ("ST: pareggio con la banda alta conta come rottura", "         if(c[i]>upF[i-1])\n", "         if(c[i]>=upF[i-1])\n"),
    ("ST: ATR diviso per+1", "double a=s/per;", "double a=s/(per+1);"),
    ("HA: apertura della prima barra = open (come la v4.1)", "(i==0) ? (o[i]+c[i])/2.0", "(i==0) ? o[i]"),
    ("HA: massimo senza apertura/chiusura HA", "hh[i]=MathMax(h[i],MathMax(xo,xc));", "hh[i]=MathMax(h[i],xc);"),
    ("mostra: riscaldamento EMA > invece di >=", "return (on && i>=first) ? v : PG_VUOTO;", "return (on && i>first) ? v : PG_VUOTO;"),
    ("linea ST: anche il verso opposto", "return (on && dir==verso) ? val : PG_VUOTO;", "return (on && dir!=0.0) ? val : PG_VUOTO;"),
    ("stato iniziale: ignora l'input cambiato", "if(haGv && gvInp==inpOra) return gvOn;", "if(haGv) return gvOn;"),
    ("contrasto: soglia rovesciata", "? clrBlack : clrWhite;", "? clrWhite : clrBlack;"),
    ("giorno precedente: domenica/sabato compresi", "if(tuttiGiorni || (w>=1 && w<=5)) return i;", "return i;"),
    ("giorno precedente: cripto come il forex", "if(tuttiGiorni || (w>=1 && w<=5)) return i;", "if(w>=1 && w<=5) return i;"),
    ("giorno della settimana sfasato", "return (int)((d+4)%7);", "return (int)((d+3)%7);"),
    ("notte: niente scavalco della mezzanotte", "if(tS>=tE) tS-=86400;", "if(tS>tE) tS-=86400;"),
    ("tondi: prezzo sul multiplo = se stesso", "      sotto=(r-1.0)*step;\n", "      sotto=r*step;\n"),
    ("passo: forex JPY come gli altri", "if(forex) return (dg<=3) ? 1.0 : 0.01;", "if(forex) return 0.01;"),
    ("swing H4: pari NON conta", "if(h[i]<h[i-j] || h[i]<h[i+j]) sw=false;", "if(h[i]<=h[i-j] || h[i]<=h[i+j]) sw=false;"),
    ("swing H4: usa la barra in formazione come vicina", "if(i<=n-2-kk && i>=kk)", "if(i<=n-1-kk && i>=kk)"),
    ("swing H4: superato anche a pari", "bool viol=have && (alto ? (ext>h[i]) : (ext<l[i]));", "bool viol=have && (alto ? (ext>=h[i]) : (ext<=l[i]));"),
    ("impila: distanza gap-1", "if(i>0 && v<out[i-1]+gap) v=out[i-1]+gap;", "if(i>0 && v<out[i-1]+gap-1) v=out[i-1]+gap-1;"),
    ("migliaia: separatore ogni 4 cifre", "if(i>0 && (m-i)%3==0) out+=\".\";", "if(i>0 && (m-i)%4==0) out+=\".\";"),
    ("TP al segno sbagliato", "return (d>0) ? e+rr*risk : e-rr*risk;", "return (d>0) ? e-rr*risk : e+rr*risk;"),
    ("LOTTO INVERTITO", "return riskMoney/lossPerLot;", "return lossPerLot/riskMoney;"),
    ("lotti: arrotondamento senza tolleranza (MathFloor nudo)", "double k=MathFloor(v/st+1e-7);", "double k=MathFloor(v/st);"),
    ("INGRESSO MOBILE: chiusura dell'ultima barra chiusa", "entry=c[f];", "entry=c[lc];"),
    ("STOP SBAGLIATO: banda dell'ultima barra", "stop=val[f];", "stop=val[lc];"),
    ("setup: zona affidabile ignorata", "if(f<first+trust) return 2;", "if(false) return 2;"),
    ("tocchi: TP1 con > invece di >=", "if(i1<0 && h[i]>=tp1) i1=i;", "if(i1<0 && h[i]>tp1) i1=i;"),
]


def ticks_input(bars, stp, sum_, lcclosed):
    txt = ["TICKS %d %d %r %d" % (len(bars), stp, sum_, lcclosed)]
    for b in bars:
        states = b[5]
        txt.append("%d" % len(states))
        for o, h, l, c in states:
            txt.append("%r %r %r %r" % (o, h, l, c))
    return "\n".join(txt) + "\n"


def synth_bars_with_states(n, seed):
    rnd = random.Random(seed)
    o, h, l, c = synth(n, seed)
    bars = []
    for i in range(n):
        st = []
        ho, hh, hl = o[i], o[i], o[i]
        k = rnd.randrange(1, 5)
        for j in range(k):
            cc = round(o[i] + (c[i] - o[i]) * (j + 1) / (k + 1) + rnd.gauss(0, 0.3), 2)
            hh = max(hh, cc); hl = min(hl, cc)
            st.append((o[i], min(hh, h[i]), max(hl, l[i]), min(max(cc, l[i]), h[i])))
        st.append((o[i], h[i], l[i], c[i]))
        bars.append([i * 300, o[i], h[i], l[i], c[i], st])
    return bars


def section_c(src):
    print("== C) funzioni PURE vere (estratte dal .mq5, compilate C++) == specchio Python ==")
    block = pure_block(src)
    real_h4 = None
    if load_real():
        b4 = resample(load_real()[-(1700 * 240):], 240)
        real_h4 = ([b[2] for b in b4], [b[3] for b in b4])
    with tempfile.TemporaryDirectory() as tmp:
        cx = Cxx(block, tmp)
        if not cx.ok:
            check(False, "il blocco PURE compila come C++ (errori: %s)" % cx.err[:1500])
            return
        warn = [ln for ln in cx.err.splitlines() if "pure.mqh" in ln and "warning" in ln]
        check(not warn, "il blocco PURE compila con -Wall -Wshadow SENZA avvisi (%s)" % warn[:3])
        cases = series_cases()
        d, inc = run_series(cx, cases)
        check(d == 0, "EMA/BB/Supertrend(x2)/HA: C++ del blocco vero == specchio, bit per bit, %d serie x %d insiemi di parametri (%d barre diverse)"
              % (len(cases), len(PAR_SETS), d))
        check(inc == 0, "calcolo INCREMENTALE come OnCalculate (barra in formazione prima falsa poi vera) == calcolo intero (%d differenze)" % inc)
        dm = run_misc(cx)
        check(dm == 0, "funzioni dei livelli, del pannello, dei tasti e del setup == specchio (%d differenze)" % dm)
        rnd = random.Random(9)
        sw = swing_cases(rnd, real_h4)
        ds = run_swings(cx, sw)
        check(ds == 0, "swing H4 non superato == forza bruta INDIPENDENTE su %d casi (%s) (%d differenze)"
              % (len(sw) * 2, "sintetici + XAUUSD H4 reale" if real_h4 else "solo sintetici", ds))
        # caso costruito che DEVE scattare: swing superato -> si torna al precedente
        hh = [100, 101, 110, 101, 100, 99, 105, 120, 104, 103, 102, 101, 100]
        out = cx.run("SWING %d 2 1\n" % len(hh) + "\n".join("%r %r" % (float(x), float(x) - 1) for x in hh) + "\n")
        check(out[0].strip() == "7", "risposta nota: ultimo swing 120 non superato -> indice 7 (%s)" % out[0].strip())
        hh2 = [100, 101, 130, 101, 100, 99, 105, 120, 104, 103, 102, 101, 121]
        out = cx.run("SWING %d 2 1\n" % len(hh2) + "\n".join("%r %r" % (float(x), float(x) - 1) for x in hh2) + "\n")
        check(out[0].strip() == "2", "caso che DEVE scattare: 120 SUPERATO da 121 della barra in formazione -> torna lo swing 130 (indice 2) (%s)" % out[0].strip())
        # riferimenti INDEPENDENTI (non specchi)
        indep(cx, cases)
        # setup tick per tick
        ticks(cx)
        # MUTANTI sul SORGENTE VERO
        qcases = series_cases(quick=True)
        if load_real():
            bars = resample(load_real()[-(1500 * 5):], 5)[-1500:]
            qcases.append(("XAUUSD M5 reale (mutanti)",) + tuple(ohlc(bars)))
        sw_q = swing_cases(random.Random(9))
        tick_bars = synth_bars_with_states(700, 41)
        for label, old, new in PURE_MUTANTS:
            if src.count(old) != 1:
                check(False, "mutante '%s': testo da mutare non trovato una volta sola nel sorgente (%d)" % (label, src.count(old)))
                continue
            msrc = src.replace(old, new, 1)
            with tempfile.TemporaryDirectory() as t2:
                cm = Cxx(pure_block(msrc), t2)
                if not cm.ok:
                    check(False, "mutante '%s' non compila: %s" % (label, cm.err[:300]))
                    continue
                md, mi = run_series(cm, qcases, sets=PAR_SETS[:2])
                mm = run_misc(cm)
                ms = run_swings(cm, sw_q)
                mt = tick_check(cm, tick_bars)
                tot = md + mi + mm + ms + mt
                check(tot > 0, "mutante sul sorgente vero PRESO: %s (serie %d, incr %d, varie %d, swing %d, tick %d)"
                      % (label, md, mi, mm, ms, mt))


def indep(cx, cases):
    """riferimenti indipendenti: pstdev, iATR di MT5, forma chiusa dell'EMA, costante."""
    # BB contro statistics.pstdev (algoritmo diverso: tolleranza relativa)
    worst = 0.0
    for nm, o, h, l, c in cases:
        if nm == "costante":
            continue
        n = len(c)
        txt = "SER %d 9 21 50 200 20 2.0 10 3.0 3.5\n" % n + "\n".join("%r %r %r %r" % (o[i], h[i], l[i], c[i]) for i in range(n)) + "\n"
        out = cx.run(txt)
        for i in range(19, n, 7):
            p = [float.fromhex(x) for x in out[1 + i].split()]
            w = c[i - 19:i + 1]
            m = sum(w) / 20.0
            sd = statistics.pstdev(w)
            for got, ref in ((p[5], m), (p[4], m + 2 * sd), (p[6], m - 2 * sd)):
                worst = max(worst, abs(got - ref) / max(1.0, abs(ref)))
    check(worst < 1e-9, "Bollinger == media e pstdev (popolazione) di Python, scarto relativo massimo %.2e" % worst)
    # ATR contro ATR.mq5 di MT5 (somma che scorre)
    worst = 0.0
    for nm, o, h, l, c in cases:
        n = len(c)
        if n < 30 or nm == "costante":
            continue
        P = 10
        tr = [0.0] + [max(h[i], c[i - 1]) - min(l[i], c[i - 1]) for i in range(1, n)]
        atr = [0.0] * n
        atr[P] = sum(tr[1:P + 1]) / P
        for i in range(P + 1, n):
            atr[i] = atr[i - 1] + (tr[i] - tr[i - P]) / P
        a, u, d, r, v = st_full(h, l, c, P, 3.0)
        for i in range(P, n):
            worst = max(worst, abs(a[i] - atr[i]) / max(1e-12, abs(atr[i]) if atr[i] else 1.0))
    check(worst < 1e-6, "ATR del Supertrend == iATR di MT5 (ATR.mq5, somma che scorre), scarto relativo massimo %.2e" % worst)
    # EMA: gradino da 0 a 1 -> e_i = 1 - (1-a)^i (forma chiusa)
    n = 60
    c = [0.0] + [1.0] * (n - 1)
    out = cx.run("SER %d 9 21 50 200 20 2.0 10 3.0 3.5\n" % n + "\n".join("%r %r %r %r" % (x, x, x, x) for x in c) + "\n")
    worst = 0.0
    for i in range(n):
        p = [float.fromhex(x) for x in out[1 + i].split()]
        for k, per in enumerate((9, 21, 50, 200)):
            a = 2.0 / (per + 1.0)
            worst = max(worst, abs(p[k] - (1 - (1 - a) ** i)))
    check(worst < 1e-12, "EMA == forma chiusa 1-(1-a)^i sul gradino (scarto %.1e)" % worst)
    # costante: tutto uguale al prezzo, bande chiuse, HA piatta
    out = cx.run("SER 80 9 21 50 200 20 2.0 10 3.0 3.5\n" + "\n".join("100.0 100.0 100.0 100.0" for _ in range(80)) + "\n")
    p = [float.fromhex(x) for x in out[80].split()]
    dev = max(abs(x - 100.0) for x in p[0:7] + p[16:20])
    check(dev < 1e-9, "serie costante: EMA, bande e Heikin Ashi = 100 (risposta nota; scarto %.1e: l'EMA ricorsiva non e' esatta all'ultimo bit)" % dev)
    # Supertrend: caso che DEVE scattare (V: discesa poi salita forte -> esattamente un'inversione SU nella salita)
    down = [200.0 - i for i in range(60)]
    up = [down[-1] + 3 * i for i in range(1, 61)]
    c = down + up
    h = [x + 0.5 for x in c]; l = [x - 0.5 for x in c]; o = [c[0]] + c[:-1]
    out = cx.run("SER %d 9 21 50 200 20 2.0 10 3.0 3.5\n" % len(c) + "\n".join("%r %r %r %r" % (o[i], h[i], l[i], c[i]) for i in range(len(c))) + "\n")
    dirs = [float.fromhex(out[1 + i].split()[10]) for i in range(len(c))]
    flips = [i for i in range(25, len(c)) if dirs[i] != dirs[i - 1]]      # il seme (barra 10) puo' girare subito: si guarda dopo
    check(len(flips) == 1 and dirs[flips[0]] == 1.0 and flips[0] > 60 and dirs[59] == -1.0,
          "caso che DEVE scattare: discesa poi salita -> UNA inversione SU nella salita (inversioni dopo il seme a %s)" % flips)


def tick_check(cx, bars):
    """ritorna le violazioni del setup tick per tick (0 = ingresso fisso)."""
    out = cx.run(ticks_input(bars, 10, 3.5, 1))
    intra, inter, flips, setups = (int(x) for x in out[0].split())
    # contro il calcolo intero: setup alla chiusura di ogni barra
    o, h, l, c = ohlc(bars)
    a, u, d, r, v = st_full(h, l, c, 10, 3.5)
    bad = 0
    for m in range(len(bars)):
        lc = m - 1
        if lc < 1:
            continue
        code, fi, dd, e, s = py_setup(c, r, v, lc, 11, 0)
        p = out[1 + m].split()
        if int(p[0]) != fi or (code == 0 and float.fromhex(p[1]) != e):
            bad += 1
    return intra + inter + bad


def ticks(cx):
    print("  -- setup ORDINE CONSIGLIATO tick per tick --")
    sets = [("sintetica", synth_bars_with_states(1200, 41))]
    if load_real():
        rows = load_real()
        sets.append(("XAUUSD M5 reale (stati = ogni minuto M1)", resample(rows[-(4000 * 5):], 5)[-4000:]))
    for nm, bars in sets:
        out = cx.run(ticks_input(bars, 10, 3.5, 1))
        intra, inter, flips, setups = (int(x) for x in out[0].split())
        nstates = sum(len(b[5]) for b in bars)
        check(intra == 0 and inter == 0,
              "%s: ingresso FISSO (barre CHIUSE): 0 cambi dentro la barra, 0 cambi fra barre senza inversione su %d stati (cambi: %d / %d; inversioni %d; barre con setup %d)"
              % (nm, nstates, intra, inter, flips, setups))
        check(flips > 0 and setups > 0, "%s: il caso misura qualcosa (inversioni %d, setup %d)" % (nm, flips, setups))
        bad = tick_check(cx, bars)
        check(bad == 0, "%s: setup a fine barra == setup dal calcolo intero (%d differenze)" % (nm, bad))
        out = cx.run(ticks_input(bars, 10, 3.5, 0))
        intra0 = int(out[0].split()[0])
        check(intra0 > 0, "%s: contro-esempio: setup sulla barra IN FORMAZIONE = ingresso mobile, cambia %d volte dentro la barra" % (nm, intra0))


# ===========================================================================
# L) LIVELLI su dati reali (giorno, settimana, mese, notte, H4) e pannello
# ===========================================================================
def section_l(src):
    print("== L) LIVELLI su dati reali con risposta nota ==")
    rows = load_real()
    if not rows:
        print("  SALTATO: dati reali non trovati")
        return
    block = pure_block(src)
    with tempfile.TemporaryDirectory() as tmp:
        cx = Cxx(block, tmp)
        if not cx.ok:
            check(False, "blocco PURE non compila")
            return
        # D1 dal M1 (giorno = data UTC del dato, qui fa da 'server')
        days = {}
        for t, o, h, l, c in rows:
            d = t // 1440
            if d not in days:
                days[d] = [o, h, l, c]
            else:
                b = days[d]; b[1] = max(b[1], h); b[2] = min(b[2], l); b[3] = c
        dk = sorted(days)
        tsec = [d * 86400 for d in dk]
        lines = []
        for j in range(1, len(dk)):
            w = tsec[max(0, j - 9):j + 1]
            lines.append("GPREC %d 0 %s" % (len(w), " ".join(str(x) for x in w)))
        out = cx.run("\n".join(lines) + "\n")
        wrong = 0
        sunday_cases = 0
        naive_wrong = 0
        bdays = set(d for d in dk if 1 <= ((d + 4) % 7) <= 5)
        for j in range(1, len(dk)):
            w0 = max(0, j - 9)
            p = int(out[j - 1])
            got = dk[w0 + p] if p >= 0 else None
            # INDIPENDENTE: ultimo giorno lun-ven CON DATI prima di oggi (calendario, non barre D1)
            cands = [d for d in bdays if d < dk[j]]
            ref = max(cands) if cands else None
            if got != ref:
                wrong += 1
            if (dk[j] + 4) % 7 == 1 and (dk[j - 1] + 4) % 7 == 0:      # lunedi' con candela di domenica
                sunday_cases += 1
                if dk[j - 1] != ref:
                    naive_wrong += 1
        check(wrong == 0, "GIORNO PRECEDENTE == ultimo giorno lun-ven con dati (calendario) su %d giorni reali (%d diversi)" % (len(dk) - 1, wrong))
        check(sunday_cases > 100 and naive_wrong == sunday_cases,
              "caso che DEVE scattare (classe 1014): %d lunedi' con la candela della DOMENICA; la regola ingenua 'barra prima' sbaglia in %d, la nostra in 0"
              % (sunday_cases, naive_wrong))
        # max/min del giorno precedente dalla barra D1 == max/min dei minuti di quel giorno (dati grezzi)
        bad = 0
        mins_by_day = {}
        for t, o, h, l, c in rows:
            mins_by_day.setdefault(t // 1440, []).append((h, l, c))
        for j in range(1, len(dk)):
            cands = [d for d in bdays if d < dk[j]]
            if not cands:
                continue
            pd = max(cands)
            mm = mins_by_day[pd]
            if (max(x[0] for x in mm), min(x[1] for x in mm), mm[-1][2]) != (days[pd][1], days[pd][2], days[pd][3]):
                bad += 1
        check(bad == 0, "MAX/MIN/CHIUSURA GIORNO PRECEDENTE == massimo/minimo/ultima chiusura dei minuti di quel giorno (%d diversi)" % bad)
        # settimana (MT5: da domenica) e mese precedenti: penultima barra W1/MN1 == minuti della settimana/mese prima
        def agg(key):
            g = {}
            for t, o, h, l, c in rows:
                k = key(t)
                if k not in g:
                    g[k] = [h, l]
                else:
                    g[k][0] = max(g[k][0], h); g[k][1] = min(g[k][1], l)
            return g
        tmin = [r_[0] for r_ in rows]
        import bisect

        def hl_between(a_min, b_min):
            a_ = bisect.bisect_left(tmin, a_min); b_ = bisect.bisect_left(tmin, b_min)
            if b_ <= a_:
                return None
            return (max(rows[k][2] for k in range(a_, b_)), min(rows[k][3] for k in range(a_, b_)))
        wk = agg(lambda t: (t // 1440) - ((t // 1440 + 4) % 7))
        ks = sorted(wk)
        badw = 0
        nw = 0
        for i in range(1, len(ks)):
            prev = ks[i - 1]
            ref = hl_between(prev * 1440, (prev + 7) * 1440)       # INDIPENDENTE: minuti fra domenica e domenica
            nw += 1
            if ref is None or ref != tuple(wk[prev]):
                badw += 1
        check(badw == 0 and nw > 50, "MAX/MIN SETTIMANA PRECEDENTE (settimana MT5 da domenica) == minuti della settimana prima (%d diverse su %d)" % (badw, nw))
        def month_start(y, m):
            return int((dt.datetime(y, m, 1) - dt.datetime(1970, 1, 1)).total_seconds() // 60)
        mo = agg(lambda t: (dt.datetime(1970, 1, 1) + dt.timedelta(minutes=t)).strftime("%Y%m"))
        km = sorted(mo)
        badm = 0
        for i in range(1, len(km)):
            y, m = int(km[i - 1][:4]), int(km[i - 1][4:])
            y2, m2 = (y + 1, 1) if m == 12 else (y, m + 1)
            ref = hl_between(month_start(y, m), month_start(y2, m2))   # INDIPENDENTE: calendario
            if ref is None or ref != tuple(mo[km[i - 1]]):
                badm += 1
        check(badm == 0 and len(km) > 12, "MAX/MIN MESE PRECEDENTE == minuti del mese prima (%d diversi su %d)" % (badm, len(km) - 1))
        # NOTTE: finestra come ComputeBox (23:00 del giorno prima -> 4:59), con riserva sui giorni senza dati
        rnd = random.Random(3)
        nows = [rows[rnd.randrange(len(rows) // 3, len(rows))][0] * 60 + rnd.randrange(0, 60) for _ in range(400)]
        nows += [ (d * 1440 + 6 * 1440 // 24) * 60 for d in dk[-60:] if (d + 4) % 7 in (6, 0)]   # sabato e domenica mattina
        lines = []
        for now in nows:
            for back in range(7):
                lines.append("NOTTE %d %d 23 0 4 59" % (now, back))
        out = cx.run("\n".join(lines) + "\n")
        bad = 0
        used_back = 0
        for i, now in enumerate(nows):
            res = None
            for back in range(7):
                ts, te = (int(x) for x in out[i * 7 + back].split())
                # INDIPENDENTE: datetime del calendario
                nd = dt.datetime.utcfromtimestamp(now).date() - dt.timedelta(days=back)
                te2 = dt.datetime.combine(nd, dt.time(4, 59)); ts2 = dt.datetime.combine(nd, dt.time(23, 0))
                if ts2 >= te2:
                    ts2 -= dt.timedelta(days=1)
                ep = dt.datetime(1970, 1, 1)
                if (ts, te) != (int((ts2 - ep).total_seconds()), int((te2 - ep).total_seconds())):
                    bad += 1
                if ts > now:
                    continue
                a_ = bisect.bisect_left(tmin, ts // 60); b_ = bisect.bisect_right(tmin, te // 60)
                if b_ > a_:
                    res = (back, max(rows[k][2] for k in range(a_, b_)), min(rows[k][3] for k in range(a_, b_)))
                    break
            if res and res[0] > 0:
                used_back += 1
            if res is None:
                bad += 1
        check(bad == 0, "NOTTE: finestra == calendario (23:00 del giorno prima -> 04:59) su %d istanti, sempre trovata una notte con dati (%d errori)" % (len(nows), bad))
        check(used_back > 0, "NOTTE: caso che DEVE scattare: istanti di weekend/festivi in cui la notte di oggi e' vuota e si usa quella prima (%d)" % used_back)


def section_p(src):
    """pannello e lotti: numeri noti (XAUUSD), formato italiano."""
    print("== P) pannello ORDINE: lotti e formato con risposta nota ==")
    block = pure_block(src)
    with tempfile.TemporaryDirectory() as tmp:
        cx = Cxx(block, tmp)
        if not cx.ok:
            check(False, "blocco PURE non compila")
            return
        # saldo 10.000, rischio 1% = 100; R = 5,00 $ su XAUUSD (tick 0,01 = 1 $ per lotto) -> perdita per lotto 500 -> 0,20 lotti
        out = cx.run("LTOT 100.0 5.0 0.01 1.0\nLOTS 0.08 0.01 0.01 100.0\nLOTS 0.06 0.01 0.01 100.0\nLOTS 0.2 0.01 0.01 100.0\n"
                     "TP 1 2650.0 5.0 1.0\nTP 1 2650.0 5.0 3.0\nTP -1 2650.0 5.0 2.0\nMIGL 24998.25\nMIGL 0.20\n")
        tot = float.fromhex(out[0])
        check(abs(tot - 0.2) < 1e-12, "lotti totali: 100 / ((5,00/0,01) x 1) = 0,20 (%r)" % tot)
        quote = [float.fromhex(out[i].split()[0]) for i in (1, 2, 3)]
        check(quote == [0.08, 0.06, 0.2], "quote 40/30/30 di 0,20 al passo 0,01 = 0,08 / 0,06 / 0,06; totale 0,20 (%s)" % quote)
        tps = [float.fromhex(out[i]) for i in (4, 5, 6)]
        check(tps == [2655.0, 2665.0, 2640.0], "TP: BUY 1R = 2655, 3R = 2665; SELL 2R = 2640 (%s)" % tps)
        check(out[7].strip() == "24.998,25" and out[8].strip() == "0,20", "formato italiano: 24.998,25 e 0,20 (%s / %s)" % (out[7].strip(), out[8].strip()))


def main():
    src = read(SRC)
    static_checks(src)
    section_c(src)
    section_l(src)
    section_p(src)
    print()
    if FAILS:
        print("ESITO: %d CONTROLLI FALLITI" % len(FAILS))
        for f in FAILS:
            print("  - " + f)
        sys.exit(1)
    print("ESITO: TUTTO OK (logica e funzioni pure; NON prova la compilazione MQL5 ne' il comportamento nel terminale)")


if __name__ == "__main__":
    main()
