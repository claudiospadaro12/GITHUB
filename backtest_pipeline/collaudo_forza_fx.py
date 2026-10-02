#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Collaudo di mql5/Indicators/ABTG_ForzaFX_Dashboard.mq5 (dashboard di SOLA VISIONE).
Specifica: docs/FORZA_FX_SPEC_2026-10-02.md.

Qui NON c'e' MetaEditor: niente compila davvero l'MQL5. Il collaudo fa quello che si puo'
fare onestamente senza terminale (stesso impianto di collaudo_pulsanti_grafico.py):

  S) STATICO sul sorgente: ASCII; parentesi; nessuna funzione di trading / rete / file /
     notifica; ChartSetSymbolPeriod mai sul grafico della dashboard e sempre dopo il controllo
     CHART_EXPERT_NAME (classe 930), ChartOpen seguito dalla sorveglianza del template (951);
     CopyRates solo nei due caricatori; ChartRedraw nel timer solo se qualcosa e' cambiato;
     default degli input (28 coppie = tutte le combinazioni di 8 valute, 7 per valuta; pesi
     1,1,2,3,4,6,10,15,20 = 62; 45/62 = 73%); funzioni chiamate tutte definite o note a MQL5;
     nessuna variabile locale che nasconde una globale; ANCORE sulle righe fuori dal blocco
     puro (classe 1042) con i loro mutanti.
  C) FUNZIONI PURE vere (blocco //@@FFX_PURE_BEGIN..END) estratte dal .mq5, compilate in C++,
     confrontate BIT PER BIT con lo specchio Python e con riferimenti INDIPENDENTI scritti
     dalla specifica (non copiati riga per riga): stato della cella, forza, ordine, punteggio,
     etichetta, TOP, calendario, pianificatore dei caricamenti, testi della diagnosi.
     IDENTITA' ALGEBRICHE della forza (somma dei numeratori = 0 esatto; somma delle forze = 0
     solo a denominatori uguali, e il controesempio con una coppia mancante DEVE scattare;
     antisimmetria; |forza| <= 1 e la distanza massima 2,0); SEGNI base/quotata.
  R) DATI REALI (XAUUSD M1 2024, UTC spostato a UTC+1 come il server BCM): simulazione del
     timer tick per tick con le funzioni VERE compilate: (a) con tutti i tick, stato =
     riferimento a ogni passo e UNA sola CopyRates per candela nuova; (b) campionando solo
     apertura e chiusura del minuto, SENZA correzione M1 gli stati sbagliano (caso che DEVE
     scattare, classe 1014) e CON la correzione tornano giusti a ogni chiusura; (c) tetto di
     caricamento basso + serie in ritardo: nessuna cella si azzera; (d) D1 del lunedi' con la
     candela della domenica (classe 1065): precedente = venerdi'; la regola ingenua sbaglia.
  M) MUTANTI applicati al SORGENTE VERO (classe 1033): ognuno deve essere preso. Comprende i
     mutanti CIECHI del cancello indipendente (02/10, giri 1-4, etichetta [cieco]) sul codice di
     raccordo, presi da 5 controlli di COMPORTAMENTO (nessuna cella azzerata, campi MqlRates,
     indici di cella, livelli dalla locale omonima, pannello forza per valuta) e da ancore; il
     residuo verde (testi/tooltip/impaginazione + 2 equivalenti) e' contato e dichiarato.

Uso:   python3 backtest_pipeline/collaudo_forza_fx.py [--rapido]
       python3 backtest_pipeline/collaudo_forza_fx.py --diag file_journal.txt
         (ricalcola le forze dalle righe "[ForzaFX diag]" copiate dalla scheda Esperti)
Esce con 0 solo se tutti i controlli passano. NON prova la compilazione MQL5 ne' il terminale.
"""
import calendar
import datetime as dt
import math
import os
import random
import re
import shutil
import subprocess
import sys
import tempfile

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
SRC = os.path.join(ROOT, "mql5/Indicators/ABTG_ForzaFX_Dashboard.mq5")
DATI = os.path.join(ROOT, "backtest_pipeline/risultati_prove/oro_m1_utc_2021_2026/XAUUSD_M1_UTC_2024.csv")
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
# Costanti (devono coincidere con i #define del sorgente: controllato in S)
# ===========================================================================
ND, NEUTRO, UP, UPBRK, DN, DNBRK, FAILUP, FAILDN, FAIL2 = -1, 0, 1, 2, 3, 4, 5, 6, 7
NTF, NVAL = 9, 8
VAL = ["EUR", "GBP", "AUD", "NZD", "USD", "CAD", "CHF", "JPY"]
TFN = ["M1", "M5", "M15", "M30", "H1", "H4", "D1", "W1", "MN"]
PESI = [1, 1, 2, 3, 4, 6, 10, 15, 20]
C_OK, C_POCHI, C_INDIETRO, C_FERIALE = 0, 1, 2, 3


def mround(x):
    """MathRound/std::round: meta' lontano da zero (NON l'arrotondamento bancario di Python)."""
    r = math.trunc(x)
    if abs(x - r) >= 0.5:
        r += math.copysign(1.0, x)
    return float(r)


# ===========================================================================
# Specchio Python delle funzioni pure (riga per riga dal blocco PURE)
# ===========================================================================
def py_stato(c, o0, h0, l0, h1, l1):
    if c > h1:
        return UPBRK
    if c < l1:
        return DNBRK
    fu = h0 > h1
    fd = l0 < l1
    if fu and fd:
        return FAIL2
    if fu:
        return FAILUP
    if fd:
        return FAILDN
    if c > o0:
        return UP
    if c < o0:
        return DN
    return NEUTRO


def py_bordo(c, o0):
    return 1 if c > o0 else (-1 if c < o0 else 0)


def py_valore(s):
    return {UPBRK: 2.0, UP: 1.0, FAILDN: 0.5, FAILUP: -0.5, DN: -1.0, DNBRK: -2.0}.get(s, 0.0)


def py_dir(s):
    if s in (UP, UPBRK, FAILDN):
        return 1.0
    if s in (DN, DNBRK, FAILUP):
        return -1.0
    return 0.0


def py_rottura(s):
    return {UPBRK: 1.0, DNBRK: -1.0, FAILUP: -0.5, FAILDN: 0.5}.get(s, 0.0)


def py_dirsan(s):
    if s in (UP, UPBRK):
        return 1
    if s in (DN, DNBRK):
        return -1
    return 0


def py_forza(st, ns, base, quot, peso):
    num = [0.0] * NVAL
    den = [0.0] * NVAL
    for s in range(ns):
        b, q = base[s], quot[s]
        if b < 0 or q < 0 or b == q:
            continue
        for c in range(NTF):
            x = st[s * NTF + c]
            if x == ND or peso[c] <= 0.0:
                continue
            val = py_valore(x) * peso[c]
            num[b] += val
            num[q] -= val
            den[b] += 2.0 * peso[c]
            den[q] += 2.0 * peso[c]
    forza = [(num[k] / den[k]) if den[k] > 0.0 else 0.0 for k in range(NVAL)]
    return num, den, forza


def py_ordina(forza):
    ordv = list(range(len(forza)))
    for i in range(1, len(forza)):
        x = ordv[i]
        j = i - 1
        while j >= 0 and forza[ordv[j]] < forza[x]:
            ordv[j + 1] = ordv[j]
            j -= 1
        ordv[j + 1] = x
    return ordv


def py_componenti(st, off, on, strat):
    na = nb = 0
    sa = sb = 0.0
    for c in range(NTF):
        if on[c] == 0:
            continue
        x = st[off + c]
        if x == ND:
            return False, 0.0, 0.0
        sb += py_rottura(x)
        nb += 1
        if strat[c] != 0:
            sa += py_dir(x)
            na += 1
    if nb == 0:
        return False, 0.0, 0.0
    return True, (sa / na if na > 0 else 0.0), sb / nb


def py_sanity(dc, ds, sg):
    if dc == 0 or ds == 0 or sg == 0:
        return 0
    return 1 if dc == sg * ds else -1


def py_confluenza(a, d, r, s):
    return a * 40.0 + d * 30.0 + r * 20.0 + s * 10.0


def py_punteggio(st, off, on, strat, fb, fq, santf, ds, sg):
    ok, al, ro = py_componenti(st, off, on, strat)
    if not ok:
        return False, 0.0, al, 0.0, ro, 0.0
    df = (fb - fq) / 2.0
    dc = py_dirsan(st[off + santf]) if santf >= 0 else 0
    sa = float(py_sanity(dc, ds, sg) * dc)
    return True, py_confluenza(al, df, ro, sa), al, df, ro, sa


def py_etichetta(score, forte, normale, debole):
    r = mround(score)
    if r >= forte:
        return 3
    if r >= normale:
        return 2
    if r >= debole:
        return 1
    if r <= -forte:
        return -3
    if r <= -normale:
        return -2
    if r <= -debole:
        return -1
    return 0


def py_top(score, ok, topn, soglia):
    out = []
    for _ in range(topn):
        best, besta = -1, 0.0
        for i in range(len(score)):
            if not ok[i]:
                continue
            a = abs(mround(score[i]))
            if a < soglia or i in out:
                continue
            if best < 0 or a > besta:
                best, besta = i, a
        if best < 0:
            break
        out.append(best)
    for i in range(1, len(out)):
        x = out[i]
        j = i - 1
        while j >= 0 and mround(score[out[j]]) < mround(score[x]):
            out[j + 1] = out[j]
            j -= 1
        out[j + 1] = x
    return out


def c_div(a, b):
    """divisione intera C (tronca verso zero)."""
    q = abs(a) // abs(b)
    return q if (a >= 0) == (b > 0) else -q


def c_mod(a, b):
    return a - b * c_div(a, b)


def py_dow(t):
    d = c_div(t, 86400)
    w = c_mod(d + 4, 7)
    if w < 0:
        w += 7
    return w


def py_precferiale(t, salta):
    sab = any(py_dow(x) == 6 for x in t)
    for i in range(len(t) - 2, -1, -1):
        if not salta or sab:
            return i
        w = py_dow(t[i])
        if 1 <= w <= 5:
            return i
    return -1


def py_giorni_da_civile(anno, mese, giorno):
    y = anno - (1 if mese <= 2 else 0)
    era = c_div(y if y >= 0 else y - 399, 400)
    yoe = y - era * 400
    mp = mese - 3 if mese > 2 else mese + 9
    doy = c_div(153 * mp + 2, 5) + giorno - 1
    doe = yoe * 365 + c_div(yoe, 4) - c_div(yoe, 100) + doy
    return era * 146097 + doe - 719468


def py_civile_da_giorni(z0):
    z = z0 + 719468
    era = c_div(z if z >= 0 else z - 146096, 146097)
    doe = z - era * 146097
    yoe = c_div(doe - c_div(doe, 1460) + c_div(doe, 36524) - c_div(doe, 146096), 365)
    doy = doe - (365 * yoe + c_div(yoe, 4) - c_div(yoe, 100))
    mp = c_div(5 * doy + 2, 153)
    g = doy - c_div(153 * mp + 2, 5) + 1
    m = mp + 3 if mp < 10 else mp - 9
    a = yoe + era * 400 + (1 if m <= 2 else 0)
    return a, m, g


def py_prossima(t0, sec, mens):
    if not mens:
        return t0 + sec
    a, m, _ = py_civile_da_giorni(c_div(t0, 86400))
    m += 1
    if m > 12:
        m = 1
        a += 1
    return py_giorni_da_civile(a, m, 1) * 86400


def py_estendi(tt, p, t0, tn, h0, l0):
    if p <= 0.0 or tt < t0 or tt >= tn:
        return False, h0, l0
    ch = False
    if p > h0:
        h0 = p
        ch = True
    if p < l0:
        l0 = p
        ch = True
    return ch, h0, l0


def py_corregg(mt, mh, ml, t0, tn, h0, l0):
    ch = False
    for i in range(len(mt)):
        if mt[i] < t0 or mt[i] >= tn:
            continue
        if mh[i] > h0:
            h0 = mh[i]
            ch = True
        if ml[i] < l0:
            l0 = ml[i]
            ch = True
    return ch, h0, l0


def py_passo(tt, bid, car, t0, tn, h0, l0, cl):
    if not car:
        return 2, h0, l0, cl
    if tt >= tn:
        return 2, h0, l0, cl
    if bid <= 0.0 or tt < t0:
        return 0, h0, l0, cl
    ch, h0, l0 = py_estendi(tt, bid, t0, tn, h0, l0)
    if bid != cl:
        cl = bid
        ch = True
    return (1 if ch else 0), h0, l0, cl


def py_darates(t, o, h, l, c, ttick, sec, mens, d1f):
    got = len(t)
    if got < 2:
        return C_POCHI, None
    last = got - 1
    tn = py_prossima(t[last], sec, mens)
    if ttick > 0 and ttick >= tn:
        return C_INDIETRO, None
    ip = py_precferiale(t, True) if d1f else last - 1
    if ip < 0:
        return C_FERIALE, None
    return C_OK, (t[last], tn, o[last], h[last], l[last], c[last], h[ip], l[ip])


def py_carica(t, o, h, l, c, ttick, bid, sec, mens, d1f):
    e, v = py_darates(t, o, h, l, c, ttick, sec, mens, d1f)
    if e != C_OK:
        return e, None
    a0, an, ao, ah, al, ac, ah1, al1 = v
    if a0 <= ttick < an and bid > 0.0:
        _, ah, al = py_estendi(ttick, bid, a0, an, ah, al)
        ac = bid
    return C_OK, (a0, an, ao, ah, al, ac, ah1, al1)


def py_statocella(cl, o0, h0, l0, h1, l1, st, bo):
    s2 = py_stato(cl, o0, h0, l0, h1, l1)
    b2 = py_bordo(cl, o0)
    return (s2 != st or b2 != bo), s2, b2


def py_valutedanome(nome):
    if len(nome) < 6:
        return False, -1, -1
    b = VAL.index(nome[:3]) if nome[:3] in VAL else -1
    q = VAL.index(nome[3:6]) if nome[3:6] in VAL else -1
    if b < 0 or q < 0 or b == q:
        return False, -1, -1
    return True, b, q


def py_parse(voce):
    v = voce.replace(" ", "")
    a = v.find(">")
    b = v.find(":")
    n = len(v)
    if a <= 0 or b <= a + 1 or b != n - 2:
        return False, "", "", 0
    sg = v[b + 1]
    if sg == "+":
        seg = 1
    elif sg == "-":
        seg = -1
    else:
        return False, "", "", 0
    return True, v[:a], v[a + 1:b], seg


def py_leggiclick(body):
    if body == "tit":
        return 6, -1, -1
    p1 = body.find("_")
    if p1 <= 0:
        return 0, -1, -1
    tipo, resto = body[:p1], body[p1 + 1:]
    if not resto:
        return 0, -1, -1
    p2 = resto.find("_")

    def toint(x):
        m = re.match(r"\s*([+-]?\d+)", x)
        return int(m.group(1)) if m else 0
    a = toint(resto if p2 < 0 else resto[:p2])
    b = toint(resto[p2 + 1:]) if p2 >= 0 else -1
    if tipo in ("s", "gb", "gt"):
        return 1, a, b
    if tipo == "c":
        return (2 if p2 >= 0 else 0), a, b
    if tipo == "to":
        return 3, a, b
    if tipo == "sr":
        return 4, a, b
    if tipo in ("fv", "fb", "fn"):
        return 5, a, b
    return 0, a, b


def py_ricalcola_tutto(st, ns, ni, base, quot, peso, on, strat, santf, sancop, sanseg, coppiasan, topn, soglia):
    num, den, fz = py_forza(st, ns, base, quot, peso)
    ordv = py_ordina(fz)
    esiti = []
    for i in range(ni):
        ds = py_dirsan(st[(ns + i) * NTF + santf]) if santf >= 0 else 0
        dc = py_dirsan(st[sancop[i] * NTF + santf]) if santf >= 0 else 0
        esiti.append(py_sanity(dc, ds, sanseg[i]))
    rows = []
    for s in range(ns):
        b, q = base[s], quot[s]
        if b < 0 or q < 0:
            rows.append((0, 0.0, 0.0, 0.0, 0.0, 0.0))
            continue
        ii = coppiasan[s]
        ds = sg = 0
        stf = -1
        if ii >= 0 and santf >= 0:
            ds = py_dirsan(st[(ns + ii) * NTF + santf])
            sg = sanseg[ii]
            stf = santf
        r = py_punteggio(st, s * NTF, on, strat, fz[b], fz[q], stf, ds, sg)
        rows.append((1 if r[0] else 0,) + tuple(r[1:]) if r[0] else (0, 0.0, r[2], 0.0, r[4], 0.0))
    tn = max(0, min(topn, ns))
    top = py_top([r[1] for r in rows], [r[0] for r in rows], tn, soglia)
    return num, den, fz, ordv, esiti, rows, top


def py_pianifica(serve, dopo, rot, budget, now):
    n = len(serve)
    out = []
    rot_out = rot
    if n <= 0:
        return out, rot_out
    for j in range(n):
        if len(out) >= budget:
            break
        k = (rot + j) % n
        if serve[k] != 0 and dopo[k] <= now:
            out.append(k)
            rot_out = (k + 1) % n
    return out, rot_out


def py_testostato(s):
    return {UPBRK: "+2", UP: "+1", FAILDN: "+0.5", FAILUP: "-0.5", DN: "-1", DNBRK: "-2", ND: "?"}.get(s, "0")


def py_riga(sym, st, off):
    return sym + "[" + ",".join(py_testostato(st[off + c]) for c in range(NTF)) + "]"


# ===========================================================================
# Riferimenti INDIPENDENTI (scritti dalla specifica, non dallo specchio)
# ===========================================================================
def ref_stato(c, o0, h0, l0, h1, l1):
    """insieme delle condizioni della guida (p.5-8) + precedenza della spec. 2.2."""
    cond = set()
    if c > o0 and c <= h1:
        cond.add("UP")
    if c > h1:
        cond.add("UP_BREAK")
    if c < o0 and c >= l1:
        cond.add("DN")
    if c < l1:
        cond.add("DN_BREAK")
    if h0 > h1 and c <= h1:
        cond.add("FAIL_UP")
    if l0 < l1 and c >= l1:
        cond.add("FAIL_DN")
    for nome, cod in (("UP_BREAK", UPBRK), ("DN_BREAK", DNBRK)):
        if nome in cond:
            return cod
    if "FAIL_UP" in cond and "FAIL_DN" in cond:
        return FAIL2
    for nome, cod in (("FAIL_UP", FAILUP), ("FAIL_DN", FAILDN), ("UP", UP), ("DN", DN)):
        if nome in cond:
            return cod
    return NEUTRO


REF_VALORE = {"UPBRK": 2.0, "UP": 1.0, "FAILDN": 0.5, "FAILUP": -0.5, "DN": -1.0, "DNBRK": -2.0}
COD2NOME = {UPBRK: "UPBRK", UP: "UP", FAILDN: "FAILDN", FAILUP: "FAILUP", DN: "DN", DNBRK: "DNBRK"}


def ref_forza_guida(coppie, stati, pesi):
    """formula della guida p.13 alla lettera: score[c] = Somma(stato x peso x segno) /
    (n_coppie[c] x sumPesi x 2), con n_coppie contato sull'elenco. Solo copertura PIENA."""
    somma = {v: 0.0 for v in VAL}
    ncop = {v: 0 for v in VAL}
    sp = float(sum(pesi))
    for nome, row in zip(coppie, stati):
        b, q = nome[:3], nome[3:6]
        ncop[b] += 1
        ncop[q] += 1
        for c in range(NTF):
            v = REF_VALORE.get(COD2NOME.get(row[c], ""), 0.0)
            somma[b] += v * pesi[c] * (+1)
            somma[q] += v * pesi[c] * (-1)
    return {v: (somma[v] / (ncop[v] * sp * 2) if ncop[v] else 0.0) for v in VAL}, ncop


def ref_forza_parziale(coppie, stati, pesi):
    """con celle mancanti (None): denominatore = 2 x somma dei pesi delle celle presenti."""
    num = {v: 0.0 for v in VAL}
    den = {v: 0.0 for v in VAL}
    for nome, row in zip(coppie, stati):
        b, q = nome[:3], nome[3:6]
        for c in range(NTF):
            if row[c] is None:
                continue
            v = REF_VALORE.get(COD2NOME.get(row[c], ""), 0.0)
            num[b] += v * pesi[c]
            num[q] -= v * pesi[c]
            den[b] += 2 * pesi[c]
            den[q] += 2 * pesi[c]
    return {v: (num[v] / den[v] if den[v] else 0.0) for v in VAL}


def ref_punteggio(row, on, fb, fq, sanita):
    """spec. sez. 5 con le scelte dichiarate; 'sanita' = (dir_coppia_D1, dir_strumento, segno) o None."""
    attivi = [c for c in range(NTF) if on[c]]
    if any(row[c] == ND for c in attivi):
        return None
    strat = [c for c in attivi if c >= 5]
    up_like = {UP, UPBRK, FAILDN}
    dn_like = {DN, DNBRK, FAILUP}
    al = (sum(1 for c in strat if row[c] in up_like) - sum(1 for c in strat if row[c] in dn_like)) / len(strat) if strat else 0.0
    ro = (sum(1 for c in attivi if row[c] == UPBRK) - sum(1 for c in attivi if row[c] == DNBRK)
          - 0.5 * sum(1 for c in attivi if row[c] == FAILUP) + 0.5 * sum(1 for c in attivi if row[c] == FAILDN)) / len(attivi)
    df = (fb - fq) / 2
    sa = 0.0
    if sanita is not None:
        dc, ds, sg = sanita
        if dc != 0 and ds != 0 and sg != 0:
            sa = float(dc) if dc == sg * ds else float(-dc)
    return 40 * al + 30 * df + 20 * ro + 10 * sa


def ref_top(score, ok, topn, soglia):
    cand = [i for i in range(len(score)) if ok[i] and abs(mround(score[i])) >= soglia]
    cand.sort(key=lambda i: (-abs(mround(score[i])), i))
    sel = cand[:topn]
    return sorted(sel, key=lambda i: (-mround(score[i]), sel.index(i)))


def ref_prossima(t0, sec, mens):
    if not mens:
        return t0 + sec
    d = dt.datetime.utcfromtimestamp(t0)
    y, m = (d.year + 1, 1) if d.month == 12 else (d.year, d.month + 1)
    return calendar.timegm((y, m, 1, 0, 0, 0))


# ===========================================================================
# S) statico
# ===========================================================================
def strip_code(src):
    out = []
    i = 0
    n = len(src)
    while i < n:
        if src.startswith("//", i):
            j = src.find("\n", i)
            i = n if j < 0 else j
            continue
        if src.startswith("/*", i):
            j = src.find("*/", i + 2)
            i = n if j < 0 else j + 2
            continue
        ch = src[i]
        if ch == '"':
            j = i + 1
            while j < n and src[j] != '"':
                j += 2 if src[j] == "\\" else 1
            out.append('""')
            i = j + 1
            continue
        if ch == "'":
            j = i + 1
            while j < n and src[j] != "'":
                j += 2 if src[j] == "\\" else 1
            out.append("' '")
            i = j + 1
            continue
        out.append(ch)
        i += 1
    return "".join(out)


def func_body(src, name):
    m = re.search(r"\n[\w ]+\b" + re.escape(name) + r"\s*\([^)]*\)\s*\n?\s*\{", src)
    if not m:
        return ""
    i = m.end() - 1
    depth = 0
    for j in range(i, len(src)):
        if src[j] == "{":
            depth += 1
        elif src[j] == "}":
            depth -= 1
            if depth == 0:
                return src[i:j + 1]
    return ""


MQL_API = set("""
if for while switch return sizeof case else do
StringTrimLeft StringTrimRight StringSplit StringSubstr StringLen StringFind StringReplace StringToInteger
IntegerToString DoubleToString TimeToString EnumToString TimeCurrent TimeLocal GetTickCount64 GetLastError ResetLastError
ArrayResize ArrayInitialize ArraySize ArraySetAsSeries SymbolSelect SymbolInfoInteger SymbolInfoTick CopyRates PeriodSeconds
MathRound MathAbs Print Alert ChartID ChartGetInteger ChartSetInteger ChartGetString ChartSymbol ChartPeriod ChartSetSymbolPeriod
ChartOpen ChartFirst ChartNext ChartRedraw ObjectFind ObjectCreate ObjectSetInteger ObjectSetString ObjectGetInteger ObjectsDeleteAll
GlobalVariableSet GlobalVariableGet GlobalVariableCheck GlobalVariableDel EventSetTimer EventKillTimer TerminalInfoInteger
C color datetime string double int long ulong bool
""".split())


def static_checks(src):
    print("\n== S) statico sul sorgente")
    check(all(ord(ch) < 128 for ch in src), "sorgente in ASCII puro (niente accenti/emoji: MetaEditor e ANSI)")
    code = strip_code(src)
    check(code.count("{") == code.count("}") and code.count("(") == code.count(")") and code.count("[") == code.count("]"),
          "parentesi bilanciate (graffe %d/%d, tonde %d/%d, quadre %d/%d)" % (
              code.count("{"), code.count("}"), code.count("("), code.count(")"), code.count("["), code.count("]")))
    vietate = ["OrderSend", "OrderSendAsync", "CTrade", "PositionOpen", "PositionClose", "PositionSelect", "OrderSelect",
               "HistorySelect", "PositionsTotal", "OrdersTotal", "AccountInfo", "WebRequest", "SocketCreate", "SocketConnect",
               "FileOpen", "FileWrite", "SendNotification", "SendMail", "SendFTP", "#import", "#include", "ShellExecute",
               "iCustom", "ChartApplyTemplate", "ChartSaveTemplate", "TerminalClose"]
    trovate = [v for v in vietate if v in code]
    check(not trovate, "nessuna funzione di trading/rete/file/notifica/template (trovate: %s)" % trovate)
    # 930: ChartSetSymbolPeriod mai sul grafico 0 / ChartID, sempre dopo il controllo EA nella stessa funzione
    csp = [m.start() for m in re.finditer(r"ChartSetSymbolPeriod\s*\(", code)]
    check(len(csp) == 1, "una sola chiamata a ChartSetSymbolPeriod (%d)" % len(csp))
    check(not re.search(r"ChartSetSymbolPeriod\s*\(\s*(0|ChartID\(\))\s*,", code),
          "ChartSetSymbolPeriod MAI sul grafico della dashboard (0 / ChartID)")
    ag = func_body(strip_code(src), "ApriGrafico")
    i_ea = ag.find("CHART_EXPERT_NAME")
    i_csp = ag.find("ChartSetSymbolPeriod")
    check(0 <= i_ea < i_csp, "ApriGrafico: CHART_EXPERT_NAME letto PRIMA di ChartSetSymbolPeriod (classe 930)")
    check("gVisore!=me" in ag.replace(" ", ""), "ApriGrafico: il grafico di lettura non puo' essere il grafico della dashboard")
    check("gWatchId=nid;" in ag.replace(" ", ""), "ApriGrafico: dopo ChartOpen parte la sorveglianza del template (classe 951)")
    cg = func_body(strip_code(src), "ControllaGraficoNuovo").replace(" ", "")
    check("CHART_EXPERT_NAME" in cg and "Alert(" in cg, "ControllaGraficoNuovo: EA trovato sul grafico nuovo -> Alert")
    check("ControllaGraficoNuovo(now);" in func_body(code, "OnTimer").replace(" ", ""), "la sorveglianza gira nel timer")
    # CopyRates solo nei caricatori
    funcs_cr = set()
    for fn in re.finditer(r"\n(?:[A-Za-z_]\w*[ \t]+)+(\w+)\s*\([^)]*\)\s*\n?\s*\{", code):
        body = func_body(code, fn.group(1))
        if "CopyRates" in body:
            funcs_cr.add(fn.group(1))
    check(funcs_cr == {"CaricaCella", "CorreggiSimbolo"}, "CopyRates solo in CaricaCella e CorreggiSimbolo (%s)" % sorted(funcs_cr))
    ot = func_body(code, "OnTimer")
    otf = ot.replace(" ", "").replace("\n", "")
    check(ot.count("ChartRedraw") == 1 and "if(redraw)ChartRedraw(0);" in otf, "OnTimer ridisegna SOLO se qualcosa e' cambiato")
    check("for(intj=0;j<nl;j++)CaricaCella(gLoadBuf[j],now);" in otf, "CaricaCella solo sulle celle scelte da FFX_Pianifica (tetto per secondo)")
    check(code.count("CaricaCella(") == 2, "CaricaCella chiamata in un solo punto (oltre alla definizione)")
    check("if(gDirty)" in otf, "ricalcolo e disegno solo con gDirty")
    oc = func_body(code, "OnCalculate")
    check("CopyRates" not in oc and "ChartRedraw" not in oc, "OnCalculate non fa niente (niente CopyRates/ChartRedraw a ogni tick)")
    ce = func_body(code, "OnChartEvent")
    check("ChartSetSymbolPeriod" not in ce, "i click non cambiano il grafico della dashboard (nessuna ricarica)")
    # #define coerenti con lo specchio
    defs = dict((m.group(1), m.group(2)) for m in re.finditer(r"#define\s+(FFX_\w+)\s+(\S+)", src))
    attesi = {"FFX_S_ND": "-1", "FFX_S_NEUTRO": "0", "FFX_S_UP": "1", "FFX_S_UPBRK": "2", "FFX_S_DN": "3", "FFX_S_DNBRK": "4",
              "FFX_S_FAILUP": "5", "FFX_S_FAILDN": "6", "FFX_S_FAIL2": "7", "FFX_NTF": "9", "FFX_NVAL": "8",
              "FFX_W_ALLIN": "40.0", "FFX_W_DIFF": "30.0", "FFX_W_ROTT": "20.0", "FFX_W_SAN": "10.0", "FFX_IDX_D1": "6",
              "FFX_C_OK": "0", "FFX_C_POCHI": "1", "FFX_C_INDIETRO": "2", "FFX_C_FERIALE": "3"}
    diff = {k: (defs.get(k), v) for k, v in attesi.items() if defs.get(k) != v}
    check(not diff, "#define di stati/pesi/esiti uguali allo specchio (%s)" % diff)
    # default degli input
    m = re.search(r'input\s+string\s+InpSimboli\s*=\s*"([^"]*)"', src)
    coppie = [x.strip() for x in m.group(1).split(",")] if m else []
    combos = set()
    for i in range(NVAL):
        for j in range(i + 1, NVAL):
            combos.add(frozenset((VAL[i], VAL[j])))
    got = set(frozenset((c[:3], c[3:6])) for c in coppie)
    check(len(coppie) == 28 and len(set(coppie)) == 28 and got == combos,
          "default InpSimboli = le 28 combinazioni di EUR GBP USD AUD NZD CAD CHF JPY, senza doppioni (%d)" % len(coppie))
    per_val = {v: sum(1 for c in coppie if v in (c[:3], c[3:6])) for v in VAL}
    check(all(n == 7 for n in per_val.values()),
          "ogni valuta compare in ESATTAMENTE 7 coppie (%s): la frase della guida 'CHF/AUD/NZD/CAD in meno' e' falsa sulle 28" % per_val)
    pesi = []
    for tf in ["M1", "M5", "M15", "M30", "H1", "H4", "D1", "W1", "MN"]:
        mm = re.search(r"input\s+double\s+InpPeso%s\s*=\s*([\d.]+)" % tf, src)
        pesi.append(float(mm.group(1)) if mm else None)
    check(pesi == [float(x) for x in PESI], "pesi di default = guida p.11/p.13: %s" % pesi)
    if None not in pesi:
        sp = sum(pesi)
        quota = (pesi[6] + pesi[7] + pesi[8]) / sp
        check(sp == 62 and pesi[6] + pesi[7] + pesi[8] == 45 and round(quota * 100) == 73,
              "somma pesi 62, D1+W1+MN = 45, quota %.2f%% (la guida dice 73%%: torna)" % (quota * 100))
    for nome, att in (("InpSogliaForte", "90"), ("InpSogliaNormale", "70"), ("InpSogliaDebole", "40"), ("InpTopOpp", "5"),
                      ("InpCellaPx", "18"), ("InpCorrezioneSec", "60")):
        mm = re.search(r"input\s+\w+\s+%s\s*=\s*([\w.]+)" % nome, src)
        check(mm is not None and mm.group(1) == att, "default %s = %s" % (nome, att))
    check(re.search(r'input\s+string\s+InpSuffisso\s*=\s*""', src) is not None, "InpSuffisso vuoto di default (BCM senza suffissi)")
    check(re.search(r"input\s+bool\s+InpD1SaltaWeekend\s*=\s*true", src) is not None, "D1: salto del weekend acceso di default (classe 1065)")
    # funzioni chiamate tutte definite o note
    definite = set(m.group(1) for m in re.finditer(r"\n[\w ]+?\b(\w+)\s*\([^;{)]*\)\s*\n?\s*\{", "\n" + code))
    chiamate = set(m.group(1) for m in re.finditer(r"\b([A-Za-z_]\w*)\s*\(", code))
    ignote = sorted(c for c in chiamate - definite - MQL_API if not c.startswith("On") and c not in ("C",))
    check(not ignote, "ogni funzione chiamata e' definita nel file o nota a MQL5 (ignote: %s)" % ignote)
    # nessuna locale che nasconde una globale
    glob = set()
    for line in code.split("\n"):
        mm = re.match(r"^(?:int|double|bool|string|long|ulong|datetime|color|ENUM_TIMEFRAMES)\s+(.+);\s*$", line)
        if mm and "(" not in mm.group(1):
            for part in mm.group(1).split(","):
                nm = re.match(r"\s*(\w+)", part)
                if nm:
                    glob.add(nm.group(1))
    glob |= {"P"}
    ombre = []
    for fn in re.finditer(r"\n(?:[A-Za-z_]\w*[ \t]+)+(\w+)\s*\(([^)]*)\)\s*\n?\s*\{", code):
        body = func_body(code, fn.group(1))
        for prm in fn.group(2).split(","):
            mm = re.search(r"(\w+)\s*(\[\s*\])?\s*$", prm.strip())
            if mm and mm.group(1) in glob:
                ombre.append((fn.group(1), mm.group(1)))
        for mm in re.finditer(r"\b(?:int|double|bool|string|long|ulong|datetime|color|ENUM_TIMEFRAMES|MqlRates|MqlTick)\s+(\w+)", body):
            if mm.group(1) in glob:
                ombre.append((fn.group(1), mm.group(1)))
    check(not ombre and len(glob) > 40, "nessuna variabile locale/parametro nasconde una globale (%d globali; ombre: %s)" % (len(glob), ombre))
    # tabelle che decidono cio' che si vede: colori dal pptx della guida, testi delle soglie
    def tabella(fn):
        body = func_body(src, fn)
        return dict((m.group(1), m.group(2).strip()) for m in re.finditer(r"case\s+([\w-]+)\s*:\s*return\s+([^;]+);", body))
    hexrgb = lambda h: "C'%d,%d,%d'" % (int(h[0:2], 16), int(h[2:4], 16), int(h[4:6], 16))
    col = tabella("ColoreStato")
    att_col = {"FFX_S_UPBRK": hexrgb("16A34A"), "FFX_S_UP": hexrgb("22C55E"), "FFX_S_DN": hexrgb("EF4444"), "FFX_S_DNBRK": hexrgb("B91C1C"),
               "FFX_S_FAILUP": hexrgb("1C1C1C"), "FFX_S_FAILDN": hexrgb("6B7280"), "FFX_S_FAIL2": "clrDimGray", "FFX_S_NEUTRO": "clrWhite"}
    check(col == att_col, "COLORI degli stati = pptx della guida (verde scuro/chiaro, rosso chiaro/scuro, nero, grigio) (%s)" % (
        {k: (col.get(k), v) for k, v in att_col.items() if col.get(k) != v}))
    lab = tabella("FFX_TestoEtichetta")
    check(lab == {"3": '"STRONG BUY"', "2": '"BUY"', "1": '"WEAK +"', "-1": '"WEAK -"', "-2": '"SELL"', "-3": '"STRONG SELL"'},
          "TESTI del segnale: 3 STRONG BUY ... -3 STRONG SELL (%s)" % lab)
    ce_ = tabella("ColoreEtichetta")
    check(ce_.get("3") == hexrgb("16A34A") and ce_.get("2") == hexrgb("22C55E") and ce_.get("-3") == hexrgb("B91C1C") and
          ce_.get("1") == ce_.get("-1") == hexrgb("8B949E"), "COLORI del segnale = pptx (STRONG BUY #16A34A, BUY #22C55E, WEAK #8B949E, STRONG SELL #B91C1C)")
    ns_ = tabella("NomeStato")
    vals_ok = all(("(%s)" % v) in ns_.get(k, "") for k, v in (("FFX_S_UPBRK", "+2"), ("FFX_S_UP", "+1"), ("FFX_S_FAILDN", "+0,5"),
                                                               ("FFX_S_FAILUP", "-0,5"), ("FFX_S_DN", "-1"), ("FFX_S_DNBRK", "-2")))
    check(vals_ok, "TOOLTIP: ogni stato dichiara il valore usato nella forza")
    cb_ = func_body(src, "ColoreBordo").replace(" ", "")
    check("if(b>0)returnC'34,197,94';" in cb_ and "if(b<0)returnC'239,68,68';" in cb_, "BORDO: verde sopra l'apertura, rosso sotto")
    # ancore (classe 1042): righe che vivono FUORI dal blocco puro
    flat = code.replace(" ", "").replace("\n", "")
    # le ancore coi colori C'r,g,b' si cercano nel sorgente coi letterali (strip_code li svuota), senza commenti
    flat_c = re.sub(r"//[^\n]*", "", src).replace(" ", "").replace("\n", "")
    for lab, a in ANCHORS:
        check(a in (flat_c if "C'" in a else flat), "ancora: " + lab)
    # --- cancello indipendente 02/10 (classe 1068, giro cieco): controlli di COMPORTAMENTO sul raccordo
    # (1) nessuna cella si azzera fuori da OnInit: l'unica scrittura di gSt[] e' lo stato ricalcolato
    #     in AggiornaStato, e gCar[] fuori da OnInit si scrive solo a true (caricamento riuscito)
    oi_ = func_body(code, "OnInit")
    rest_ = code.replace(oi_, "", 1) if oi_ else code
    w_st = [x.strip() for x in re.findall(r"\bgSt\s*\[[^\]]*\]\s*=(?!=)\s*([^;]*);", rest_)]
    w_car = [x.strip() for x in re.findall(r"\bgCar\s*\[[^\]]*\]\s*=(?!=)\s*([^;]*);", rest_)]
    check(w_st == ["st"] and all(x == "true" for x in w_car) and not re.search(r"Array(Initialize|Fill)\s*\(\s*g(St|Car)\b", rest_),
          "NESSUNA cella azzerata fuori da OnInit: gSt[] scritto solo da AggiornaStato (%s), gCar[] solo a true (%s)" % (w_st, w_car))
    # (2) i campi di MqlRates finiscono ognuno nel suo array (il percorso dei dati non e' nel blocco puro)
    mp_c = dict(re.findall(r"\b(\w+)\[i\]\s*=\s*r\[i\]\.(\w+)", func_body(code, "CaricaCella")))
    mp_m = dict(re.findall(r"\b(\w+)\[i\]\s*=\s*r\[i\]\.(\w+)", func_body(code, "CorreggiSimbolo")))
    check(mp_c == {"t": "time", "o": "open", "h": "high", "l": "low", "cc": "close"} and mp_m == {"mt": "time", "mh": "high", "ml": "low"},
          "MqlRates -> array: time/open/high/low/close al loro posto in CaricaCella (%s) e CorreggiSimbolo (%s)" % (mp_c, mp_m))
    # (3) il pannello forza scrive la valuta della RIGA r (v=gOrd[r]), mai l'indice di riga come valuta
    dfz = func_body(code, "DisegnaForza").replace(" ", "")
    check(not re.search(r"(gForza|gNum|gDen|FFX_VAL)\[r\]", dfz), "pannello forza: numero, nome e tooltip della valuta v=gOrd[r], mai [r]")
    # (4) aritmetica degli indici di cella in TUTTO il raccordo: k = s*FFX_NTF + c, s = k/FFX_NTF,
    #     c = k%FFX_NTF, e il TF di una cella e' FFX_TF[c] (giro cieco 3: indici scambiati erano VERDI)
    fl4 = strip_code(src[src.find("//@@FFX_PURE_END"):]).replace(" ", "").replace("\n", "")   # solo il raccordo
    ks = re.findall(r"(?<!\()\bintk=([^;]*);", fl4)
    dec = re.findall(r"\bints=([^;,]*),c=([^;]*);", fl4)
    tfs = re.findall(r"ENUM_TIMEFRAMEStf=([^;]*);", fl4)
    check(len(ks) >= 4 and all(x == "s*FFX_NTF+c" for x in ks) and len(dec) >= 2 and all(d == ("k/FFX_NTF", "k%FFX_NTF") for d in dec)
          and fl4.count("k/FFX_NTF") == len(dec) and fl4.count("k%FFX_NTF") == len(dec) and tfs == ["FFX_TF[c]"],
          "indici di cella: k=s*FFX_NTF+c ovunque (%d), s=k/FFX_NTF e c=k%%FFX_NTF (%d), TF della cella = FFX_TF[c] (%s)" % (len(ks), len(dec), tfs))
    # (5) i livelli di una cella, fuori da OnInit, si scrivono SOLO dalla locale omonima (giro cieco 4:
    #     estremi riscritti scambiati dopo la correzione M1 erano VERDI)
    rf_ = rest_.replace(" ", "").replace("\n", "")
    lv = {"gH0": "h0", "gL0": "l0", "gO0": "o0", "gCl": "cl", "gH1": "h1", "gL1": "l1", "gT0": "t0", "gNext": "tn"}
    w_lv = [(g, x) for g, loc in lv.items() for x in re.findall(r"\b%s\[k\]=(?!=)([^;]*);" % g, rf_) if x != loc]
    n_lv = sum(len(re.findall(r"\b%s\[k\]=(?!=)" % g, rf_)) for g in lv)
    check(not w_lv and n_lv >= 10, "livelli di cella scritti solo dalla locale omonima (gH0<-h0, gL0<-l0, ... %d scritture; difformi: %s)" % (n_lv, w_lv))


ANCHORS = [
    ("cella da caricare quando FFX_PassoTick dice 2", "gServe[k]=(r==2)?1:0;"),
    ("ricalcolo completo con gli argomenti nell'ordine giusto", "gNTop=FFX_RicalcolaTutto(gSt,gNS,gNI,gBase,gQuot,gPeso,gOn,gStrat,gSanTF,gSanCoppia,gSanSegno,gCoppiaSan,InpTopOpp,InpSogliaDebole,gNum,gDen,gForza,gOrd,gSanEsito,gScore,gAl,gDf,gRo,gSa,gScOk,gTop);"),
    ("TF accesi: ogni input al suo TF", "usa[0]=InpUsaM1;usa[1]=InpUsaM5;usa[2]=InpUsaM15;usa[3]=InpUsaM30;usa[4]=InpUsaH1;usa[5]=InpUsaH4;usa[6]=InpUsaD1;usa[7]=InpUsaW1;usa[8]=InpUsaMN;"),
    ("pesi: ogni input al suo TF", "pw[0]=InpPesoM1;pw[1]=InpPesoM5;pw[2]=InpPesoM15;pw[3]=InpPesoM30;pw[4]=InpPesoH1;pw[5]=InpPesoH4;pw[6]=InpPesoD1;pw[7]=InpPesoW1;pw[8]=InpPesoMN;"),
    ("valute dal nome SENZA suffisso", "if(!FFX_ValuteDaNome(nomi[s],FFX_VAL,vb,vq))"),
    ("base e quotata nell'ordine giusto", "gBase[s]=vb;gQuot[s]=vq;"),
    ("suffisso aggiunto al nome usato col terminale", "gSym[s]=nomi[s]+InpSuffisso;"),
    ("correlazione: indici di coppia e segno", "snomi[gNI]=st;scop[gNI]=idx;sseg[gNI]=seg;"),
    ("pannello forza in ordine dalla piu' forte", "intv=gOrd[r];"),
    ("click sulla cella: coppia e TF giusti", "if(a>=0&&a<gNS&&b>=0&&b<FFX_NTF)ApriGrafico(gSym[a],FFX_TF[b]);"),
    ("click su TOP: la coppia in quella posizione", "if(a>=0&&a<gNTop)ApriGrafico(gSym[gTop[a]],PERIOD_D1);"),
    ("caricamento con il prezzo e l'ora del giro", "inte=FFX_Carica(t,o,h,l,cc,got,gTick[s],gBid[s],PeriodSeconds(tf),(tf==PERIOD_MN1),d1,t0,tn,o0,h0,l0,cl,h1,l1);"),
    ("stato della cella dai suoi livelli", "if(FFX_StatoCella(gCl[k],gO0[k],gH0[k],gL0[k],gH1[k],gL1[k],st,bo))"),
    ("cella attiva: TF acceso o TF della correlazione", "gAttiva[k]=(s<gNS)?gOn[c]:((c==gSanTF)?1:0);"),
    ("ID del grafico di lettura dalle due meta'", "gVisore=FFX_IdDaMeta(GvGet(\"\",0.0),GvGet(\"\",0.0));"),
    ("diagnosi periodica: prossima fra InpDiagMinuti", "DiagStampa(\"\");gDiagNext=TimeLocal()+(datetime)(InpDiagMinuti*60);"),
    ("diagnosi 'copertura completa' una volta, a copertura PIENA", "if(!gCompleta&&tot>0&&cov==tot){gCompleta=true;"),
    ("GlobalVariable legate al grafico (ChartID)", "return\"\"+IntegerToString(ChartID())+\"\"+w;"),
    ("strumenti di correlazione col nome esatto (senza suffisso)", "gSym[s]=snomi[i];"),
    ("nessun TF acceso: parametri rifiutati", "if(nOn==0){Print(\"\");returnINIT_PARAMETERS_INCORRECT;}"),
    ("oggetti tolti alla rimozione", "EventKillTimer();ObjectsDeleteAll(0,P);"),
    ("colore della cella riscritto quando CAMBIA", "if(cf!=gCF[k]){ObjectSetInteger(0,n,OBJPROP_BGCOLOR,cf);gCF[k]=cf;ch=true;}if(cb!=gCB[k]){ObjectSetInteger(0,n,OBJPROP_COLOR,cb);gCB[k]=cb;ch=true;}"),
    ("cella caricata: non piu' in coda", "gCar[k]=true;gServe[k]=0;gDopo[k]=0;gNd[k]=\"\";"),
    ("filtro della matrice dalla funzione pura", "returnFFX_RigaVisibile(gBase[s],gQuot[s],gFiltro);"),
    ("barra dalla funzione pura, colore dal verso", "boolpos=FFX_Barra(f,xz,half,x,w);colorcol=pos?C'34,197,94':C'239,68,68';"),
    ("segnale a video dalla funzione pura", "t=FFX_TestoSegnale(gScore[s],InpSogliaForte,InpSogliaNormale,InpSogliaDebole);"),
    ("TOP: la coppia in posizione i", "ints=gTop[i];"),
    ("correlazione a video dalla funzione pura", "stringesito=FFX_TestoEsito(gSanEsito[i]);"),
    ("copertura dalla funzione pura", "FFX_Copertura(gSt,gAttiva,gNS,cov,tot);"),
    ("riga 'somma' della diagnosi dalla funzione pura", "Print(pre,FFX_RigaSomma(gForza,gDen));"),
    ("filtro dal click sulla valuta", "gFiltro=FFX_FiltroDopoClick(gFiltro,gOrd,a);"),
    ("correlazioni collegate alle coppie", "FFX_CollegaCorrelazioni(gSanCoppia,gNI,gNS,gCoppiaSan);"),
    ("ora del tick dal TICK (non dal server)", "gBid[s]=tk.bid;gTick[s]=tk.time;"),
    ("correzione M1 solo quando e' dovuta, poi fra InpCorrezioneSec", "if(!gSymOk[s]||now<gCorrNext[s])continue;CorreggiSimbolo(s);gCorrNext[s]=now+(long)InpCorrezioneSec*1000;"),
    ("sorveglianza del template per 10 s", "gWatchFino=OraMs()+10000;"),
    ("sorveglianza chiusa solo dopo la scadenza", "if(now>gWatchFino)gWatchId=0;"),
    ("tooltip: massimo e minimo precedenti al loro posto", "\"+Px(s,gH1[k])+\"\"+Px(s,gL1[k])+"),
    ("cambio di stato -> ridisegno", "gSt[k]=st;gBo[k]=bo;gDirty=true;"),
    ("tetto dei caricamenti dall'input", "intbudget=(InpCaricaMax<1)?1:InpCaricaMax;"),
    ("simbolo assente ritentato una volta al minuto", "if(now-gSymRetry[s]>=60000)"),
    ("intestazioni: un TF spento non occupa colonna", "Vis(hn,gOn[c]!=0);if(gOn[c]==0)continue;"),
    ("celle dei TF spenti nascoste", "Vis(n,v&&gOn[c]!=0);"),
    ("un TF spento pesa 0 nella forza", "gPeso[c]=(usa[c]&&pw[c]>0.0)?pw[c]:0.0;"),
    ("TF strategici = H4, D1, W1, MN", "gStrat[c]=(c>=5)?1:0;"),
    ("D1 con salto del weekend copia 7 candele (un sabato si vede sempre, classe 1069)", "boold1=(c==FFX_IDX_D1&&InpD1SaltaWeekend);intnb=d1?7:2;"),
    ("caricamento fallito: livelli NON toccati e ritento", "if(e!=FFX_C_OK){"),
    ("i livelli si scrivono solo dopo l'esito OK", "gT0[k]=t0;gNext[k]=tn;gO0[k]=o0;gH0[k]=h0;gL0[k]=l0;gCl[k]=cl;gH1[k]=h1;gL1[k]=l1;gCar[k]=true;"),
    ("serie in ritardo: si ritenta dopo 1 s, altrimenti dopo 5 s", "gDopo[k]=now+((e==FFX_C_INDIETRO)?1000:5000);"),
    ("correzione M1: 3 candele, celle caricate e non in attesa", "CopyRates(gSym[s],PERIOD_M1,0,3,r);"),
    ("correzione M1 solo su celle caricate", "if(gAttiva[k]==0||!gCar[k]||gServe[k]!=0)continue;"),
    ("etichetta decisa sul numero arrotondato mostrato", "inte=FFX_Etichetta(gScore[s],InpSogliaForte,InpSogliaNormale,InpSogliaDebole);doubler=MathRound(gScore[s]);"),
    ("EA sul grafico di lettura: non si tocca", "if(StringLen(ea)>0){Print("),
    ("riga 'celle' della diagnosi dalla funzione pura", "FFX_RigaCoppia(gNome[s],gSt,s*FFX_NTF)"),
    ("riga 'forze' della diagnosi", "FFX_VAL[v]+\"\"+FFX_Segnato(gNum[v],2)+\"\"+DoubleToString(gDen[v],2)+\"\"+FFX_Segnato(gForza[v],4);"),
    # --- aggiunte dal cancello indipendente del 02/10 (giro cieco: erano righe NON ancorate e verdi)
    ("correzione M1: massimi coi massimi, minimi coi minimi, nella candela della cella", "FFX_CorreggiDaM1(mt,mh,ml,got,gT0[k],gNext[k],h0,l0)"),
    ("prezzo del giro riscritto nei livelli giusti", "if(r==1){gH0[k]=h0;gL0[k]=l0;gCl[k]=cl;AggiornaStato(k);}"),
    ("riempimento dallo STATO, bordo dal BORDO (guida p.10)", "colorcf=ColoreStato(gSt[k]);colorcb=ColoreBordo(gBo[k],gSt[k]);"),
    ("pannello forza: il numero della valuta di quella riga", "doublef=gForza[v];"),
    ("click sul simbolo -> D1 (guida p.9)", "if(a>=0&&a<gNS)ApriGrafico(gSym[a],PERIOD_D1);"),
    ("correlazione a video: cella dello strumento e cella della SUA coppia", "intks=(gNS+i)*FFX_NTF+gSanTF;intkc=sc*FFX_NTF+gSanTF;"),
    ("correlazioni spente se il loro TF e' spento", "if(gSanTF<0||gOn[gSanTF]==0)"),
    ("TOP: verde se positivo, rosso se negativo", "col=(e>0)?C'22,130,60':C'185,28,28';"),
    ("click sulla correlazione: apre lo STRUMENTO al TF della correlazione", "ApriGrafico(gSym[gNS+a],FFX_TF[gSanTF]);"),
    ("grafico nuovo al TF chiesto dal click", "longnid=ChartOpen(sym,tf);"),
    ("segnale '...' finche' mancano dati (mai un numero su celle mancanti)", "if(gScOk[s]==0){t=\"\";"),
    ("doppioni della lista tenuti una volta sola", "for(intj=0;j<gNS;j++)if(nomi[j]==n)dup=true;"),
    ("ogni cella col tick del SUO simbolo", "intr=FFX_PassoTick(gTick[s],gBid[s],gCar[k],gT0[k],gNext[k],h0,l0,cl);"),
]

# mutanti delle ancore (classe 1042): ognuno DEVE far cadere un controllo statico
ANCHOR_MUTANTS = [
    ("cella caricata anche quando PassoTick dice 1", "gServe[k]=(r==2) ? 1 : 0;", "gServe[k]=(r>=1) ? 1 : 0;"),
    ("TF spento che pesa lo stesso", "gPeso[c]=(usa[c] && pw[c]>0.0) ? pw[c] : 0.0;", "gPeso[c]=(pw[c]>0.0) ? pw[c] : 0.0;"),
    ("H1 contato fra gli strategici", "gStrat[c]=(c>=5) ? 1 : 0;", "gStrat[c]=(c>=4) ? 1 : 0;"),
    ("ChartSetSymbolPeriod sul grafico della dashboard", "ChartSetSymbolPeriod(id,sym,tf)", "ChartSetSymbolPeriod(0,sym,tf)"),
    ("ridisegno a ogni secondo", "   if(redraw) ChartRedraw(0);\n  }\n//--- ricalcola", "   ChartRedraw(0);\n  }\n//--- ricalcola"),
    ("etichetta sul numero NON arrotondato", "double r=MathRound(gScore[s]);", "double r=gScore[s];"),
    ("locale che nasconde una globale", "   int budget=(InpCaricaMax<1) ? 1 : InpCaricaMax;", "   int gRot=0; int budget=(InpCaricaMax<1) ? 1 : InpCaricaMax;"),
    ("funzione chiamata ma non definita", "         CorreggiSimbolo(s);\n", "         CorreggiSimbol(s);\n"),
    ("funzione di notifica", "      gCompleta=true;\n", "      gCompleta=true; SendNotification(\"x\");\n"),
    ("parentesi spezzata come quella trovata il 02/10", "(2 x somma pesi usati), in [-1,+1]\",2)) ch=true;", "(2 x somma pesi usati)) ch=true; in [-1,+1]\",2);"),
    ("CopyRates fuori dai caricatori", "   ControllaGraficoNuovo(now);\n", "   ControllaGraficoNuovo(now); MqlRates zz[]; CopyRates(_Symbol,PERIOD_M1,0,2,zz);\n"),
    # --- giro CIECO del cancello indipendente (02/10): 16 mutanti scritti senza guardare le ancore,
    #     su righe di raccordo che decidono dati o cio' che si vede; prima delle aggiunte qui sopra
    #     erano VERDI tutti e 16. Ora ognuno deve far cadere un controllo statico.
    ("[cieco] cella azzerata a caricamento fallito", "      gDopo[k]=now+((e==FFX_C_INDIETRO) ? 1000 : 5000);\n      return;",
     "      gDopo[k]=now+((e==FFX_C_INDIETRO) ? 1000 : 5000);\n      gSt[k]=FFX_S_ND;\n      return;"),
    ("[cieco] cella azzerata a candela nuova", "         gServe[k]=(r==2) ? 1 : 0;\n", "         gServe[k]=(r==2) ? 1 : 0;\n         if(r==2) gSt[k]=FFX_S_ND;\n"),
    ("[cieco] cella dimenticata a candela nuova", "         gServe[k]=(r==2) ? 1 : 0;\n", "         gServe[k]=(r==2) ? 1 : 0;\n         if(r==2) gCar[k]=false;\n"),
    ("[cieco] correzione M1 con massimi e minimi scambiati", "FFX_CorreggiDaM1(mt,mh,ml,got,", "FFX_CorreggiDaM1(mt,ml,mh,got,"),
    ("[cieco] CaricaCella: high e low scambiati", "h[i]=r[i].high; l[i]=r[i].low;", "h[i]=r[i].low; l[i]=r[i].high;"),
    ("[cieco] CorreggiSimbolo: high e low scambiati", "mh[i]=r[i].high; ml[i]=r[i].low;", "mh[i]=r[i].low; ml[i]=r[i].high;"),
    ("[cieco] CaricaCella: open al posto di close", "cc[i]=r[i].close;", "cc[i]=r[i].open;"),
    ("[cieco] click sul simbolo -> H1 invece di D1", "      if(a>=0 && a<gNS) ApriGrafico(gSym[a],PERIOD_D1);", "      if(a>=0 && a<gNS) ApriGrafico(gSym[a],PERIOD_H1);"),
    ("[cieco] bordo invertito a video", "         color cb=ColoreBordo(gBo[k],gSt[k]);", "         color cb=ColoreBordo(-gBo[k],gSt[k]);"),
    ("[cieco] riempimento dal bordo", "         color cf=ColoreStato(gSt[k]);", "         color cf=ColoreStato(gBo[k]>0 ? FFX_S_UP : FFX_S_DN);"),
    ("[cieco] pannello forza: numero della riga e non della valuta", "      double f=gForza[v];", "      double f=gForza[r];"),
    ("[cieco] pannello forza: nome della riga e non della valuta", "      string lab=(v==gFiltro) ? \"[\"+FFX_VAL[v]+\"]\" : FFX_VAL[v];",
     "      string lab=(v==gFiltro) ? \"[\"+FFX_VAL[r]+\"]\" : FFX_VAL[r];"),
    ("[cieco] massimo e minimo del giro scambiati", "            gH0[k]=h0; gL0[k]=l0; gCl[k]=cl;", "            gH0[k]=l0; gL0[k]=h0; gCl[k]=cl;"),
    ("[cieco] TOP: colore invertito", "         col=(e>0) ? C'22,130,60' : C'185,28,28';", "         col=(e<0) ? C'22,130,60' : C'185,28,28';"),
    ("[cieco] correlazione a video: cella della coppia sbagliata", "      int kc=sc*FFX_NTF+gSanTF;", "      int kc=gSanTF;"),
    ("[cieco] correlazioni accese su un TF spento", "      if(gSanTF<0 || gOn[gSanTF]==0)", "      if(gSanTF<0)"),
    # giro cieco 3 del cancello (10 righe fresche, 10/10 VERDI prima dei controlli (4) e delle ancore sopra)
    ("[cieco3] CaricaCella: TF della colonna sbagliata", "   ENUM_TIMEFRAMES tf=FFX_TF[c];", "   ENUM_TIMEFRAMES tf=FFX_TF[c>0 ? c-1 : c];"),
    ("[cieco3] CorreggiSimbolo: celle del simbolo sbagliato", "      int k=s*FFX_NTF+c;\n      if(gAttiva[k]==0 || !gCar[k] || gServe[k]!=0) continue;",
     "      int k=c;\n      if(gAttiva[k]==0 || !gCar[k] || gServe[k]!=0) continue;"),
    ("[cieco3] CaricaCella: simbolo e TF scambiati nell'indice", "   int s=k/FFX_NTF, c=k%FFX_NTF;\n   ENUM_TIMEFRAMES", "   int s=k%FFX_NTF, c=k/FFX_NTF;\n   ENUM_TIMEFRAMES"),
    ("[cieco3] click correlazione: apre la coppia e non lo strumento", "ApriGrafico(gSym[gNS+a],FFX_TF[gSanTF]);", "ApriGrafico(gSym[a],FFX_TF[gSanTF]);"),
    ("[cieco3] segnale mostrato anche senza tutti i dati", "      if(gScOk[s]==0)\n        {\n         t=\"...\";", "      if(false)\n        {\n         t=\"...\";"),
    ("[cieco3] doppioni della lista tenuti", "      for(int j=0;j<gNS;j++) if(nomi[j]==n) dup=true;", "      for(int j=0;j<gNS;j++) if(false) dup=true;"),
    ("[cieco3] grafico nuovo sempre in D1", "   long nid=ChartOpen(sym,tf);", "   long nid=ChartOpen(sym,PERIOD_D1);"),
    # giro cieco 4 (10 righe fresche: 7/10 VERDI prima del controllo (5) e dell'ancora sul tick; i 5 verdi
    # rimasti sono di testo/tooltip e stanno nel RESIDUO dichiarato)
    ("[cieco4] OnTimer: tick del simbolo sbagliato nelle celle", "int r=FFX_PassoTick(gTick[s],gBid[s],", "int r=FFX_PassoTick(gTick[0],gBid[s],"),
    ("[cieco4] CaricaCella: livelli precedenti scritti scambiati", "gH1[k]=h1; gL1[k]=l1;", "gH1[k]=l1; gL1[k]=h1;"),
    ("[cieco4] CorreggiSimbolo: estremi riscritti scambiati", "         gH0[k]=h0; gL0[k]=l0;\n         AggiornaStato(k);", "         gH0[k]=l0; gL0[k]=h0;\n         AggiornaStato(k);"),
    ("[cieco4] filtro valuta: il click ignora la riga", "      gFiltro=FFX_FiltroDopoClick(gFiltro,gOrd,a);", "      gFiltro=FFX_FiltroDopoClick(gFiltro,gOrd,0);"),
    ("[cieco4] colore del riempimento scritto nel bordo", "ObjectSetInteger(0,n,OBJPROP_COLOR,cb); gCB[k]=cb;", "ObjectSetInteger(0,n,OBJPROP_COLOR,cf); gCB[k]=cb;"),
]


# ===========================================================================
# C) funzioni pure vere compilate in C++
# ===========================================================================
SHIM = r'''
#include <cmath>
#include <cfloat>
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <ctime>
#include <string>
#include <vector>
#include <algorithm>
typedef long long datetime;
/* ulong: lo definisce gia' glibc (sys/types.h) come unsigned long a 64 bit, come in MQL5 */
static_assert(sizeof(ulong)==8,"ulong deve essere a 64 bit");
typedef std::string string;
inline double MathRound(double a){ return std::round(a); }
inline double MathAbs(double a){ return std::fabs(a); }
inline string DoubleToString(double v,int d){ char b[64]; snprintf(b,sizeof(b),"%.*f",d,v); return string(b); }
inline string StringSubstr(const string &s,int start,int len=-1){ if(start<0||start>=(int)s.size()) return ""; return len<0? s.substr(start): s.substr(start,len); }
inline int StringLen(const string &s){ return (int)s.size(); }
inline int StringFind(const string &s,const string &f,int start=0){ size_t p=s.find(f,start); return p==std::string::npos?-1:(int)p; }
inline int StringReplace(string &s,const string &a,const string &b){ int n=0; size_t p=0; while((p=s.find(a,p))!=std::string::npos){ s.replace(p,a.size(),b); p+=b.size(); n++; } return n; }
inline long long StringToInteger(const string &s){ return atoll(s.c_str()); }
'''

DRIVER = r'''
#include "shim.h"
#include "pure.mqh"
static void pa(double v){ printf("%a ",v); }
static int rd(){ int x; if(scanf("%d",&x)!=1) exit(2); return x; }
static long long rl(){ long long x; if(scanf("%lld",&x)!=1) exit(2); return x; }
static double rf(){ double x; if(scanf("%lf",&x)!=1) exit(2); return x; }
struct Bar { long long t; double o,h,l,c; };
static const long long SEC[9]={60,300,900,1800,3600,14400,86400,604800,2592000};
/* bucket indipendente dalle funzioni pure: aritmetica per i TF fissi, gmtime/timegm per il mese */
static long long bucket(long long t,int c){
  if(c<=6) return t-(t%SEC[c]);
  if(c==7){ long long b=3*86400; long long x=t-b; return b+(x-(x%604800)); }
  time_t tt=(time_t)t; struct tm g; gmtime_r(&tt,&g); g.tm_mday=1; g.tm_hour=0; g.tm_min=0; g.tm_sec=0; return (long long)timegm(&g);
}
int main(){
  char cmd[32];
  while(scanf("%31s",cmd)==1){
    std::string c(cmd);
    if(c=="STATO"){ double a=rf(),b=rf(),d=rf(),e=rf(),f=rf(),g=rf(); printf("%d\n",FFX_Stato(a,b,d,e,f,g)); }
    else if(c=="BORDO"){ double a=rf(),b=rf(); printf("%d\n",FFX_Bordo(a,b)); }
    else if(c=="FUNZ"){ int s=rd(); pa(FFX_Valore(s)); pa(FFX_Dir(s)); pa(FFX_Rottura(s)); printf("%d\n",FFX_DirSanity(s)); }
    else if(c=="FORZA"){
      int ns=rd(); std::vector<int> st(ns*9>0?ns*9:1),b(ns>0?ns:1),q(ns>0?ns:1); double pw[9];
      for(int s=0;s<ns;s++){ b[s]=rd(); q[s]=rd(); for(int k=0;k<9;k++) st[s*9+k]=rd(); }
      for(int k=0;k<9;k++) pw[k]=rf();
      double num[8],den[8],fz[8]; int ord[8];
      FFX_Forza(st.data(),ns,b.data(),q.data(),pw,num,den,fz); FFX_Ordina(fz,8,ord);
      for(int k=0;k<8;k++){ pa(num[k]); pa(den[k]); pa(fz[k]); } for(int k=0;k<8;k++) printf("%d ",ord[k]); printf("\n");
    }
    else if(c=="ORD"){ int n=rd(); std::vector<double> f(n); std::vector<int> o(n); for(int i=0;i<n;i++) f[i]=rf(); FFX_Ordina(f.data(),n,o.data()); for(int i=0;i<n;i++) printf("%d ",o[i]); printf("\n"); }
    else if(c=="PUNT"){
      int st[9],on[9],sr[9]; for(int k=0;k<9;k++) st[k]=rd(); for(int k=0;k<9;k++) on[k]=rd(); for(int k=0;k<9;k++) sr[k]=rd();
      double fb=rf(),fq=rf(); int stf=rd(),ds=rd(),sg=rd(); double sc,al,df,ro,sa;
      bool ok=FFX_Punteggio(st,0,on,sr,fb,fq,stf,ds,sg,sc,al,df,ro,sa); printf("%d ",ok?1:0); pa(sc); pa(al); pa(df); pa(ro); pa(sa); printf("\n");
    }
    else if(c=="ETI"){ double s=rf(),a=rf(),b=rf(),d=rf(); printf("%d\n",FFX_Etichetta(s,a,b,d)); }
    else if(c=="TOP"){ int n=rd(),tn=rd(); double so=rf(); std::vector<double> s(n); std::vector<int> ok(n),out(n>0?n:1);
      for(int i=0;i<n;i++){ s[i]=rf(); ok[i]=rd(); } int m=FFX_TopOpp(s.data(),ok.data(),n,tn,so,out.data()); printf("%d",m); for(int i=0;i<m;i++) printf(" %d",out[i]); printf("\n"); }
    else if(c=="DOW"){ long long t=rl(); printf("%d\n",FFX_Dow(t)); }
    else if(c=="PREC"){ int n=rd(),sw=rd(); std::vector<datetime> t(n); for(int i=0;i<n;i++) t[i]=rl(); printf("%d\n",FFX_PrecFeriale(t.data(),n,sw!=0)); }
    else if(c=="PROSS"){ long long t=rl(); int s=rd(),m=rd(); printf("%lld\n",(long long)FFX_Prossima(t,s,m!=0)); }
    else if(c=="CIV"){ int y=rd(),m=rd(),d=rd(); long long z=FFX_GiorniDaCivile(y,m,d); int a=0,b=0,g=0; FFX_CivileDaGiorni(z,a,b,g); printf("%lld %d %d %d\n",z,a,b,g); }
    else if(c=="EST"){ long long tt=rl(); double p=rf(); long long t0=rl(),tn=rl(); double h=rf(),l=rf(); bool ch=FFX_Estendi(tt,p,t0,tn,h,l); printf("%d ",ch?1:0); pa(h); pa(l); printf("\n"); }
    else if(c=="CORR"){ int n=rd(); long long t0=rl(),tn=rl(); double h=rf(),l=rf(); std::vector<datetime> mt(n>0?n:1); std::vector<double> mh(n>0?n:1),ml(n>0?n:1);
      for(int i=0;i<n;i++){ mt[i]=rl(); mh[i]=rf(); ml[i]=rf(); } bool ch=FFX_CorreggiDaM1(mt.data(),mh.data(),ml.data(),n,t0,tn,h,l); printf("%d ",ch?1:0); pa(h); pa(l); printf("\n"); }
    else if(c=="PASSO"){ long long tt=rl(); double b=rf(); int car=rd(); long long t0=rl(),tn=rl(); double h=rf(),l=rf(),cl=rf();
      int r=FFX_PassoTick(tt,b,car!=0,t0,tn,h,l,cl); printf("%d ",r); pa(h); pa(l); pa(cl); printf("\n"); }
    else if(c=="RATES"){ int got=rd(); long long tt=rl(); int sec=rd(),mens=rd(),d1=rd();
      std::vector<datetime> t(got>0?got:1); std::vector<double> o(got>0?got:1),h(got>0?got:1),l(got>0?got:1),cc(got>0?got:1);
      for(int i=0;i<got;i++){ t[i]=rl(); o[i]=rf(); h[i]=rf(); l[i]=rf(); cc[i]=rf(); }
      datetime t0=-7,tn=-7; double o0=-7,h0=-7,l0=-7,cl=-7,h1=-7,l1=-7;
      int e=FFX_DaRates(t.data(),o.data(),h.data(),l.data(),cc.data(),got,tt,sec,mens!=0,d1!=0,t0,tn,o0,h0,l0,cl,h1,l1);
      printf("%d %lld %lld ",e,(long long)t0,(long long)tn); pa(o0); pa(h0); pa(l0); pa(cl); pa(h1); pa(l1); printf("\n"); }
    else if(c=="PIAN"){ int n=rd(),rot=rd(),bud=rd(); long long now=rl(); std::vector<int> sv(n>0?n:1),out(n>0?n:1); std::vector<long long> dp(n>0?n:1);
      for(int i=0;i<n;i++){ sv[i]=rd(); dp[i]=rl(); } int ro=-1; int m=FFX_Pianifica(sv.data(),dp.data(),n,rot,bud,now,out.data(),ro);
      printf("%d %d",m,ro); for(int i=0;i<m;i++) printf(" %d",out[i]); printf("\n"); }
    else if(c=="RIGA"){ char sym[64]; if(scanf("%63s",sym)!=1) return 2; int st[9]; for(int k=0;k<9;k++) st[k]=rd(); printf("%s\n",FFX_RigaCoppia(string(sym),st,0).c_str()); }
    else if(c=="SEGN"){ double x=rf(); int d=rd(); printf("%s\n",FFX_Segnato(x,d).c_str()); }
    else if(c=="VALNOME"){ char nm[64]; if(scanf("%63s",nm)!=1) return 2; string V[8]={"EUR","GBP","AUD","NZD","USD","CAD","CHF","JPY"}; int b=-9,q=-9; bool ok=FFX_ValuteDaNome(string(nm),V,b,q); printf("%d %d %d\n",ok?1:0,b,q); }
    else if(c=="PARSE"){ char ln[256]; if(scanf(" %255[^\n]",ln)!=1) return 2; string st="x",cp="x"; int sg=9; bool ok=FFX_ParseCorrelazione(string(ln),st,cp,sg); printf("%d [%s] [%s] %d\n",ok?1:0,st.c_str(),cp.c_str(),sg); }
    else if(c=="CLICK"){ char ln[128]; if(scanf("%127s",ln)!=1) return 2; int a=-9,b=-9; int z=FFX_LeggiClick(string(ln),a,b); printf("%d %d %d\n",z,a,b); }
    else if(c=="TFORZA"){ double f=rf(); printf("%s\n",FFX_TestoForza(f).c_str()); }
    else if(c=="SCELLA"){ double a=rf(),b=rf(),d=rf(),e=rf(),f=rf(),g=rf(); int st=rd(),bo=rd(); bool ch=FFX_StatoCella(a,b,d,e,f,g,st,bo); printf("%d %d %d\n",ch?1:0,st,bo); }
    else if(c=="CARICA"){ int got=rd(); long long tt=rl(); double bid=rf(); int sec=rd(),mens=rd(),d1=rd();
      std::vector<datetime> t(got>0?got:1); std::vector<double> o(got>0?got:1),h(got>0?got:1),l(got>0?got:1),cc(got>0?got:1);
      for(int i=0;i<got;i++){ t[i]=rl(); o[i]=rf(); h[i]=rf(); l[i]=rf(); cc[i]=rf(); }
      datetime t0=-7,tn=-7; double o0=-7,h0=-7,l0=-7,cl=-7,h1=-7,l1=-7;
      int e=FFX_Carica(t.data(),o.data(),h.data(),l.data(),cc.data(),got,tt,bid,sec,mens!=0,d1!=0,t0,tn,o0,h0,l0,cl,h1,l1);
      printf("%d %lld %lld ",e,(long long)t0,(long long)tn); pa(o0); pa(h0); pa(l0); pa(cl); pa(h1); pa(l1); printf("\n"); }
    else if(c=="TUTTO"){
      int ns=rd(),ni=rd(); int nt=ns+ni; std::vector<int> st(nt*9),b(nt),q(nt),sc(ni>0?ni:1),sg(ni>0?ni:1),cs(ns),esito(ni>0?ni:1),ok(ns),top(ns);
      for(int s=0;s<nt;s++){ b[s]=rd(); q[s]=rd(); for(int k=0;k<9;k++) st[s*9+k]=rd(); }
      for(int i=0;i<ni;i++){ sc[i]=rd(); sg[i]=rd(); } for(int s=0;s<ns;s++) cs[s]=rd();
      double pw[9]; int on[9],sr[9]; for(int k=0;k<9;k++) pw[k]=rf(); for(int k=0;k<9;k++) on[k]=rd(); for(int k=0;k<9;k++) sr[k]=rd();
      int stf=rd(),tn=rd(); double so=rf();
      double num[8],den[8],fz[8]; int ord[8]; std::vector<double> sco(ns),al(ns),df(ns),ro(ns),sa(ns);
      int m=FFX_RicalcolaTutto(st.data(),ns,ni,b.data(),q.data(),pw,on,sr,stf,sc.data(),sg.data(),cs.data(),tn,so,num,den,fz,ord,esito.data(),
                               sco.data(),al.data(),df.data(),ro.data(),sa.data(),ok.data(),top.data());
      for(int k=0;k<8;k++){ pa(num[k]); pa(den[k]); pa(fz[k]); } for(int k=0;k<8;k++) printf("%d ",ord[k]); printf("\n");
      for(int i=0;i<ni;i++){ printf("%d ",esito[i]); } printf("\n");
      for(int s=0;s<ns;s++){ printf("%d ",ok[s]); pa(sco[s]); pa(al[s]); pa(df[s]); pa(ro[s]); pa(sa[s]); printf("\n"); }
      printf("%d",m); for(int i=0;i<m;i++) printf(" %d",top[i]); printf("\n"); }
    else if(c=="VIS"){ int b=rd(),q=rd(),f=rd(); printf("%d\n",FFX_RigaVisibile(b,q,f)?1:0); }
    else if(c=="BARRA"){ double f=rf(); int xz=rd(),m=rd(); int x=-9,w=-9; bool p=FFX_Barra(f,xz,m,x,w); printf("%d %d %d\n",p?1:0,x,w); }
    else if(c=="TSEG"){ double s=rf(),a=rf(),b=rf(),d=rf(); printf("[%s]\n",FFX_TestoSegnale(s,a,b,d).c_str()); }
    else if(c=="TESITO"){ int e=rd(); printf("%s\n",FFX_TestoEsito(e).c_str()); }
    else if(c=="COPERT"){ int ns=rd(); std::vector<int> st(ns*9>0?ns*9:1),at(ns*9>0?ns*9:1); for(int k=0;k<ns*9;k++){ st[k]=rd(); at[k]=rd(); } int cv=-9,tt=-9; FFX_Copertura(st.data(),at.data(),ns,cv,tt); printf("%d %d\n",cv,tt); }
    else if(c=="RSOMMA"){ double f[8],d[8]; for(int k=0;k<8;k++){ f[k]=rf(); d[k]=rf(); } printf("%s\n",FFX_RigaSomma(f,d).c_str()); }
    else if(c=="FCLICK"){ int fl=rd(),r=rd(); int o[8]; for(int k=0;k<8;k++) o[k]=rd(); printf("%d\n",FFX_FiltroDopoClick(fl,o,r)); }
    else if(c=="COLLEGA"){ int ni=rd(),ns=rd(); std::vector<int> sc(ni>0?ni:1),cs(ns>0?ns:1,-9); for(int i=0;i<ni;i++) sc[i]=rd(); FFX_CollegaCorrelazioni(sc.data(),ni,ns,cs.data()); for(int s=0;s<ns;s++){ printf("%d ",cs[s]); } printf("\n"); }
    else if(c=="IDMETA"){ long long id=rl(); double h=-1,l=-1; FFX_MetaDaId(id,h,l); long long back=FFX_IdDaMeta(h,l); printf("%.17g %.17g %lld\n",h,l,back); }
    else if(c=="FINER"){ int nr=rd(),s=rd(),ns=rd(),pr=rd(); printf("%d\n",FFX_FineRiga(nr,s,ns,pr)?1:0); }
    else if(c=="SIM"){
      /* timer simulato tick per tick con le funzioni VERE; il "terminale" vede TUTTI i tick */
      int mode=rd(),corr=rd(),bud=rd(),lag=rd(),sw=rd(),n=rd();
      std::vector<std::vector<Bar>> ser(9);
      int car[9]={0}; datetime t0[9]={0},tn[9]={0}; double o0[9]={0},h0[9]={0},l0[9]={0},cl[9]={0},h1[9]={0},l1[9]={0}; int sst[9],sbo[9]; for(int k=0;k<9;k++){ sst[k]=-1; sbo[k]=0; }
      int serve[9]={0}; long long dopo[9]={0}; int okl[9]={0},kol[9]={0}; int nuovo[9]={0}; int rot=0; long long step=0;
      std::vector<std::vector<long long>> caricate(9);
      for(int i=0;i<n;i++){
        long long t=rl(); double o=rf(),h=rf(),l=rf(),cc=rf();
        double px[4]; long long tx[4]={t,t+20,t+40,t+59};
        px[0]=o; px[3]=cc; if(cc>=o){ px[1]=l; px[2]=h; } else { px[1]=h; px[2]=l; }
        for(int q=0;q<4;q++){
          long long tt=tx[q]; double p=px[q];
          for(int k=0;k<9;k++){ long long b=bucket(tt,k);
            if(ser[k].empty() || ser[k].back().t!=b){ ser[k].push_back({b,p,p,p,p}); nuovo[k]=1; }
            else { Bar &B=ser[k].back(); if(p>B.h) B.h=p; if(p<B.l) B.l=p; B.c=p; } }
          bool timer=(mode==0) || q==0 || q==3;
          if(!timer) continue;
          for(int k=0;k<9;k++){ int r=FFX_PassoTick(tt,p,car[k]!=0,t0[k],tn[k],h0[k],l0[k],cl[k]); serve[k]=(r==2)?1:0; }
          int out[9]; int ro=rot; int m=FFX_Pianifica(serve,dopo,9,rot,bud,step,out,ro); rot=ro;
          for(int j=0;j<m;j++){ int k=out[j]; int nb=(k==6 && sw)?7:2; int avail=(int)ser[k].size();
            if(lag && nuovo[k]){ avail--; nuovo[k]=0; }
            int got=std::min(nb,avail); if(got<0) got=0;
            std::vector<datetime> T(got>0?got:1); std::vector<double> O(got>0?got:1),H(got>0?got:1),L(got>0?got:1),CC(got>0?got:1);
            for(int x=0;x<got;x++){ const Bar &B=ser[k][avail-got+x]; T[x]=B.t; O[x]=B.o; H[x]=B.h; L[x]=B.l; CC[x]=B.c; }
            datetime a0=0,an=0; double ao=0,ah=0,al=0,ac=0,ah1=0,al1=0;
            int e=FFX_Carica(T.data(),O.data(),H.data(),L.data(),CC.data(),got,tt,p,(int)SEC[k],k==8,k==6 && sw,a0,an,ao,ah,al,ac,ah1,al1);
            if(e==0){
              t0[k]=a0; tn[k]=an; o0[k]=ao; h0[k]=ah; l0[k]=al; cl[k]=ac; h1[k]=ah1; l1[k]=al1; car[k]=1; serve[k]=0; dopo[k]=0; okl[k]++; caricate[k].push_back(a0); }
            else { dopo[k]=step+1; kol[k]++; } }
          if(!lag) for(int k=0;k<9;k++) nuovo[k]=0;
          if(corr && q==3){ int nm=(int)ser[0].size(); int g3=std::min(3,nm); std::vector<datetime> mt(3); std::vector<double> mh(3),ml(3);
            for(int x=0;x<g3;x++){ const Bar &B=ser[0][nm-g3+x]; mt[x]=B.t; mh[x]=B.h; ml[x]=B.l; }
            for(int k=0;k<9;k++) if(car[k] && !serve[k]) FFX_CorreggiDaM1(mt.data(),mh.data(),ml.data(),g3,t0[k],tn[k],h0[k],l0[k]); }
          printf("%lld %d ",tt,q);
          for(int k=0;k<9;k++){ if(car[k]) FFX_StatoCella(cl[k],o0[k],h0[k],l0[k],h1[k],l1[k],sst[k],sbo[k]); int s=car[k]?sst[k]:-1; printf("%c",s<0?'.':(char)('0'+s)); }
          printf(" "); for(int k=0;k<9;k++) printf("%d",serve[k]); printf(" "); pa(h1[6]); pa(l1[6]); printf("\n");
          step++;
        }
      }
      printf("END"); for(int k=0;k<9;k++) printf(" %d %d %d",okl[k],kol[k],(int)ser[k].size()); printf("\n");
      for(int k=0;k<9;k++){ printf("CAR %d",k); for(size_t x=0;x<caricate[k].size();x++) printf(" %lld",caricate[k][x]); printf("\n"); }
      fflush(stdout);
    }
    else return 3;
  }
  return 0;
}
'''


def pure_block(src):
    a = src.index("//@@FFX_PURE_BEGIN")
    b = src.index("//@@FFX_PURE_END")
    return src[a:b]


def to_cxx(src, block):
    """adattamenti MQL5 -> C++: #define del sorgente; array per riferimento -> puntatore; long -> long long."""
    defs = "\n".join(m.group(0) for m in re.finditer(r"^#define\s+FFX_\w+\s+\S+\s*$", src, flags=re.M))
    out = re.sub(r"(const\s+)?(double|int|datetime|long|bool|string)\s*&\s*(\w+)\[\]",
                 lambda m: (m.group(1) or "") + m.group(2) + " *" + m.group(3), block)
    out = re.sub(r"\blong\b", "long long", out)
    return defs + "\n" + out


class Cxx:
    def __init__(self, src, tmp):
        self.ok = False
        self.err = ""
        cxx = shutil.which("g++") or shutil.which("clang++")
        if not cxx:
            self.err = "nessun compilatore C++"
            return
        for nm, txt in (("shim.h", SHIM), ("pure.mqh", to_cxx(src, pure_block(src))), ("drv.cpp", DRIVER)):
            with open(os.path.join(tmp, nm), "w") as f:
                f.write(txt)
        self.exe = os.path.join(tmp, "drv")
        r = subprocess.run([cxx, "-std=c++17", "-O1", "-ffp-contract=off", "-Wall", "-Wshadow", "-o", self.exe,
                            os.path.join(tmp, "drv.cpp")], capture_output=True, text=True)
        self.err = r.stderr
        self.ok = (r.returncode == 0)

    def run(self, text):
        r = subprocess.run([self.exe], input=text, capture_output=True, text=True)
        if r.returncode != 0:
            raise RuntimeError("driver C++ uscito con %d: %s" % (r.returncode, r.stderr[:300]))
        return r.stdout.rstrip("\n").split("\n")


def fx(v):
    return float.fromhex(v)


def rnd_state(rng, nd_prob=0.0):
    if rng.random() < nd_prob:
        return ND
    return rng.choice([NEUTRO, UP, UPBRK, DN, DNBRK, FAILUP, FAILDN, FAIL2])


COPPIE28 = ["EURGBP", "EURAUD", "EURNZD", "EURUSD", "EURCAD", "EURCHF", "EURJPY", "GBPAUD", "GBPNZD", "GBPUSD", "GBPCAD",
            "GBPCHF", "GBPJPY", "AUDNZD", "AUDUSD", "AUDCAD", "AUDCHF", "AUDJPY", "NZDUSD", "NZDCAD", "NZDCHF", "NZDJPY",
            "USDCAD", "USDCHF", "USDJPY", "CADCHF", "CADJPY", "CHFJPY"]


def forza_cmd(coppie, st, pesi):
    lines = ["FORZA %d" % len(coppie)]
    for i, nome in enumerate(coppie):
        b = VAL.index(nome[:3]) if nome[:3] in VAL else -1
        q = VAL.index(nome[3:6]) if nome[3:6] in VAL else -1
        lines.append("%d %d %s" % (b, q, " ".join(str(x) for x in st[i * NTF:(i + 1) * NTF])))
    lines.append(" ".join(repr(float(p)) for p in pesi))
    return "\n".join(lines) + "\n"


def parse_forza(line):
    p = line.split()
    num = [fx(p[3 * k]) for k in range(8)]
    den = [fx(p[3 * k + 1]) for k in range(8)]
    fz = [fx(p[3 * k + 2]) for k in range(8)]
    ordv = [int(x) for x in p[24:32]]
    return num, den, fz, ordv


def bq(coppie):
    base = [VAL.index(n[:3]) if n[:3] in VAL else -1 for n in coppie]
    quot = [VAL.index(n[3:6]) if n[3:6] in VAL else -1 for n in coppie]
    return base, quot


def battery(cx, rng, quick, verbose=True):
    """ritorna il numero di differenze/controlli falliti (0 = tutto bene). verbose=False per i mutanti."""
    bad = 0

    def ck(cond, msg):
        nonlocal bad
        if not cond:
            bad += 1
        if verbose:
            check(cond, msg)

    # --- stato della cella: griglia esaustiva di relazioni + casi realistici
    vals = [1.0, 2.0, 3.0, 4.0, 5.0]
    cases = []
    for c in vals:
        for o0 in vals:
            for h1 in vals:
                for l1 in vals:
                    if l1 > h1:
                        continue
                    for h0 in vals:
                        for l0 in vals:
                            if h0 < max(o0, c) or l0 > min(o0, c):
                                continue
                            cases.append((c, o0, h0, l0, h1, l1))
    out = cx.run("".join("STATO %r %r %r %r %r %r\n" % cs for cs in cases))
    d_m = sum(1 for cs, o in zip(cases, out) if int(o) != py_stato(*cs))
    d_r = sum(1 for cs, o in zip(cases, out) if int(o) != ref_stato(*cs))
    ck(d_m == 0 and d_r == 0 and len(cases) > 1500,
       "STATO su %d casi (tutte le relazioni fra C,O0,H0,L0,H1,L1): C++ == specchio (%d diff) == riferimento dalle condizioni della guida (%d diff)" % (len(cases), d_m, d_r))
    # ogni condizione della guida presa DA SOLA da' il suo stato
    soli = {"UP": (3.0, 2.0, 3.0, 2.0, 4.0, 1.0, UP), "UP_BREAK": (5.0, 2.0, 5.0, 2.0, 4.0, 1.0, UPBRK),
            "DN": (2.0, 3.0, 3.0, 2.0, 4.0, 1.0, DN), "DN_BREAK": (0.5, 3.0, 3.0, 0.5, 4.0, 1.0, DNBRK),
            "FAIL_UP": (2.0, 3.0, 4.5, 2.0, 4.0, 1.0, FAILUP), "FAIL_DN": (3.0, 2.0, 3.0, 0.5, 4.0, 1.0, FAILDN)}
    o2 = cx.run("".join("STATO %r %r %r %r %r %r\n" % v[:6] for v in soli.values()))
    ck(all(int(o) == v[6] for o, v in zip(o2, soli.values())), "ognuna delle 6 condizioni della guida, presa da sola, da' il suo stato")
    # sovrapposizione dichiarata: sopra apertura + rottura respinta = FAIL_UP (bordo verde, fill nero)
    o3 = cx.run("STATO 3.5 2.0 4.5 2.0 4.0 1.0\nBORDO 3.5 2.0\nSTATO 2.5 2.5 2.5 2.5 4.0 1.0\nSTATO 2.5 2.5 4.5 0.5 4.0 1.0\n")
    ck(o3 == [str(FAILUP), "1", str(NEUTRO), str(FAIL2)], "sopra l'apertura con rottura respinta = FAIL_UP con bordo +1; pari = NEUTRO; doppio = FAIL2")
    bc = [(rng.choice(vals), rng.choice(vals)) for _ in range(200)]
    ob = cx.run("".join("BORDO %r %r\n" % x for x in bc))
    ck(all(int(o) == py_bordo(*x) for o, x in zip(ob, bc)), "BORDO: C++ == specchio")
    of = cx.run("".join("FUNZ %d\n" % s for s in range(-1, 8)))
    okf = True
    for s, line in zip(range(-1, 8), of):
        p = line.split()
        okf &= (fx(p[0]) == py_valore(s) and fx(p[1]) == py_dir(s) and fx(p[2]) == py_rottura(s) and int(p[3]) == py_dirsan(s))
    ck(okf, "valore/direzione/rottura/direzione-correlazione dei 9 stati: C++ == specchio")
    ck([py_valore(s) for s in (UPBRK, UP, FAILDN, FAILUP, DN, DNBRK)] == [2.0, 1.0, 0.5, -0.5, -1.0, -2.0],
       "valori della guida p.13: +2 +1 +0,5 -0,5 -1 -2")

    # --- FORZA: casuale a copertura piena, contro la formula della guida alla lettera
    pesi = [float(p) for p in PESI]
    base, quot = bq(COPPIE28)
    n_rand = 60 if quick else 300
    diffs_m = diffs_g = diffs_ord = 0
    sum_num_bad = 0
    sum_fz_max = 0.0
    anti_bad = 0
    maxabs = 0.0
    batch = []
    sts = []
    for _ in range(n_rand):
        st = [rnd_state(rng) for _ in range(28 * NTF)]
        sts.append(st)
        batch.append(forza_cmd(COPPIE28, st, pesi))
        flip = {UP: DN, DN: UP, UPBRK: DNBRK, DNBRK: UPBRK, FAILUP: FAILDN, FAILDN: FAILUP}
        st2 = [flip.get(x, x) for x in st]
        sts.append(st2)
        batch.append(forza_cmd(COPPIE28, st2, pesi))
    outs = cx.run("".join(batch))
    for i, st in enumerate(sts):
        num, den, fz, ordv = parse_forza(outs[i])
        pn, pd, pf = py_forza(st, 28, base, quot, pesi)
        if num != pn or den != pd or fz != pf or ordv != py_ordina(pf):
            diffs_m += 1
        rows = [st[s * NTF:(s + 1) * NTF] for s in range(28)]
        g, ncop = ref_forza_guida(COPPIE28, rows, PESI)
        if any(abs(g[VAL[k]] - fz[k]) > 1e-15 for k in range(8)):
            diffs_g += 1
        if sum(num) != 0.0:
            sum_num_bad += 1
        sum_fz_max = max(sum_fz_max, abs(sum(fz)))
        maxabs = max(maxabs, max(abs(x) for x in fz))
        if i % 2 == 1:
            _, _, fprev, _ = parse_forza(outs[i - 1])
            if any(fz[k] != -fprev[k] for k in range(8)):
                anti_bad += 1
        if sorted(ordv) != list(range(8)):
            diffs_ord += 1
    ck(diffs_m == 0, "FORZA su %d matrici casuali: C++ == specchio bit per bit (num, den, forza, ordine) (%d diff)" % (len(sts), diffs_m))
    ck(diffs_g == 0, "FORZA == formula della guida alla lettera Somma(stato x peso x segno)/(n_coppie x 62 x 2) (%d diff)" % diffs_g)
    ck(sum_num_bad == 0, "IDENTITA': somma dei numeratori = 0 ESATTO su tutte le matrici (%d eccezioni)" % sum_num_bad)
    ck(sum_fz_max < 1e-12, "IDENTITA': con le 28 coppie complete (denominatori tutti 868) somma delle forze ~ 0 (max |somma| %.1e)" % sum_fz_max)
    ck(anti_bad == 0, "ANTISIMMETRIA: rovesciando ogni stato tutte le forze cambiano segno esatto (%d eccezioni)" % anti_bad)
    ck(maxabs <= 1.0 and diffs_ord == 0, "|forza| <= 1 su tutte le matrici (max %.4f)" % maxabs)
    # controesempio che DEVE scattare: una coppia mancante -> denominatori diversi -> somma != 0
    cop27 = [c for c in COPPIE28 if c != "EURUSD"]
    b27, q27 = bq(cop27)
    scatta = 0
    batch = []
    st27s = []
    for _ in range(40):
        st = [rnd_state(rng) for _ in range(27 * NTF)]
        st27s.append(st)
        batch.append(forza_cmd(cop27, st, pesi))
    outs = cx.run("".join(batch))
    deneq = True
    for st, line in zip(st27s, outs):
        num, den, fz, _ = parse_forza(line)
        if abs(sum(fz)) > 1e-9:
            scatta += 1
        deneq &= (len(set(den)) == 1)
        g = ref_forza_guida(cop27, [st[s * NTF:(s + 1) * NTF] for s in range(27)], PESI)[0]
        if any(abs(g[VAL[k]] - fz[k]) > 1e-15 for k in range(8)):
            scatta = -999
    ck(scatta >= 30 and not deneq,
       "CONTROESEMPIO (DEVE scattare): senza EURUSD i denominatori di EUR e USD scendono a 744, la somma delle forze NON e' zero in %d casi su 40" % scatta)
    # copertura parziale (celle n/d) contro il riferimento a denominatore per cella
    batch = []
    stp = []
    for _ in range(40):
        st = [rnd_state(rng, 0.2) for _ in range(28 * NTF)]
        stp.append(st)
        batch.append(forza_cmd(COPPIE28, st, pesi))
    outs = cx.run("".join(batch))
    dpar = 0
    for st, line in zip(stp, outs):
        num, den, fz, _ = parse_forza(line)
        rows = [[(None if x == ND else x) for x in st[s * NTF:(s + 1) * NTF]] for s in range(28)]
        r = ref_forza_parziale(COPPIE28, rows, PESI)
        if any(abs(r[VAL[k]] - fz[k]) > 1e-15 for k in range(8)) or sum(num) != 0.0:
            dpar += 1
    ck(dpar == 0, "copertura PARZIALE (20%% celle senza dati): forza == riferimento a denominatore per cella, numeratori sempre a somma 0 (%d diff)" % dpar)
    # SEGNI: solo USDJPY in rottura su tutti i TF -> USD +, JPY -; solo EURUSD -> EUR +, USD -
    st = [NEUTRO] * (28 * NTF)
    iu = COPPIE28.index("USDJPY")
    for c in range(NTF):
        st[iu * NTF + c] = UPBRK
    num, den, fz, _ = parse_forza(cx.run(forza_cmd(COPPIE28, st, pesi))[0])
    att = 2.0 * 62 / 868
    ck(abs(fz[VAL.index("USD")] - att) < 1e-15 and abs(fz[VAL.index("JPY")] + att) < 1e-15 and
       all(fz[k] == 0.0 for k in range(8) if VAL[k] not in ("USD", "JPY")),
       "SEGNI: solo USDJPY in rottura su: USD = +%.6f (base), JPY = -%.6f (quotata), le altre 0" % (att, att))
    st = [NEUTRO] * (28 * NTF)
    ie = COPPIE28.index("EURUSD")
    st[ie * NTF + 6] = DN
    num, den, fz, _ = parse_forza(cx.run(forza_cmd(COPPIE28, st, pesi))[0])
    ck(fz[VAL.index("EUR")] < 0 < fz[VAL.index("USD")],
       "SEGNI: EURUSD D1 in ribasso -> EUR negativo, USD positivo (%+.4f / %+.4f)" % (fz[VAL.index("EUR")], fz[VAL.index("USD")]))
    # estremi: una valuta a +1 e un'altra a -1 INSIEME (distanza 2,0 = massimo)
    st = [NEUTRO] * (28 * NTF)
    for s, nome in enumerate(COPPIE28):
        b, q = nome[:3], nome[3:6]
        for c in range(NTF):
            if b == "GBP" or q == "USD":        # GBPxxx su = GBP forte; xxxUSD su = USD debole
                st[s * NTF + c] = UPBRK
            elif q == "GBP" or b == "USD":      # xxxGBP giu' = GBP forte; USDxxx giu' = USD debole
                st[s * NTF + c] = DNBRK
    num, den, fz, ordv = parse_forza(cx.run(forza_cmd(COPPIE28, st, pesi))[0])
    top, bot = fz[ordv[0]], fz[ordv[-1]]
    ck(top == 1.0 and bot == -1.0 and VAL[ordv[0]] == "GBP" and VAL[ordv[-1]] == "USD",
       "ESTREMI: GBP = +1 e USD = -1 nello stesso istante, distanza 2,0 = il MASSIMO: 'top > +1', 'GBP +1,82' e 'distanza > 2,0' della guida sono impossibili con la sua formula")
    # ORDINE stabile a pari forza
    oo = cx.run("ORD 8 0.1 0.3 0.1 -0.2 0.3 0 0 -0.2\n")[0].split()
    ck([int(x) for x in oo] == py_ordina([0.1, 0.3, 0.1, -0.2, 0.3, 0, 0, -0.2]) == [1, 4, 0, 2, 5, 6, 3, 7],
       "ORDINE: decrescente e stabile a pari forza (vale l'ordine EUR..JPY)")

    # --- PUNTEGGIO: casuale contro specchio e riferimento
    on_full = [1] * 9
    strat = [0, 0, 0, 0, 0, 1, 1, 1, 1]
    dpm = dpr = 0
    batch = []
    cases = []
    for _ in range(400 if not quick else 120):
        row = [rnd_state(rng, 0.05) for _ in range(9)]
        on = [1 if rng.random() > 0.15 else 0 for _ in range(9)]
        if sum(on) == 0:
            on[6] = 1
        fb, fq = rng.uniform(-1, 1), rng.uniform(-1, 1)
        santf = rng.choice([-1, 6])
        ds = rng.choice([-1, 0, 1])
        sg = rng.choice([-1, 0, 1])
        cases.append((row, on, fb, fq, santf, ds, sg))
        batch.append("PUNT %s %s %s %r %r %d %d %d\n" % (" ".join(map(str, row)), " ".join(map(str, on)), " ".join(map(str, strat)), fb, fq, santf, ds, sg))
    outs = cx.run("".join(batch))
    for (row, on, fb, fq, santf, ds, sg), line in zip(cases, outs):
        p = line.split()
        ok = int(p[0]) == 1
        vals2 = [fx(x) for x in p[1:]]
        m = py_punteggio(row, 0, on, strat, fb, fq, santf, ds, sg)
        if ok != m[0] or (ok and vals2 != list(m[1:])):
            dpm += 1
        sanita = (py_dirsan(row[santf]), ds, sg) if santf >= 0 else None
        r = ref_punteggio(row, on, fb, fq, sanita)
        if (r is None) != (not ok) or (r is not None and abs(r - vals2[0]) > 1e-9):
            dpr += 1
    ck(dpm == 0 and dpr == 0, "PUNTEGGIO su %d casi: C++ == specchio (%d) == riferimento dalle scelte della spec. 5 (%d)" % (len(cases), dpm, dpr))
    # massimo teorico e caso 'tutto rialzista'
    line = cx.run("PUNT %s %s %s 1.0 -1.0 6 1 1\n" % (" ".join([str(UPBRK)] * 9), " ".join(["1"] * 9), " ".join(map(str, strat))))[0].split()
    ck(int(line[0]) == 1 and fx(line[1]) == 100.0, "PUNTEGGIO massimo: tutto UP_BREAK, forza base +1 / quotata -1, correlazione ALIGN = +100")
    line = cx.run("PUNT %s %s %s 1.0 -1.0 -1 0 0\n" % (" ".join([str(UPBRK)] * 9), " ".join(["1"] * 9), " ".join(map(str, strat))))[0].split()
    ck(fx(line[1]) == 90.0, "senza correlazione il massimo e' 90 (formula letterale, nessuna rinormalizzazione: dichiarato)")
    line = cx.run("PUNT %s %s %s 0.0 0.0 6 -1 1\n" % (" ".join([str(UP)] * 9), " ".join(["1"] * 9), " ".join(map(str, strat))))[0].split()
    ck(fx(line[5]) == -1.0 and fx(line[1]) == 40.0 - 10.0,
       "correlazione DIVERGE su una coppia rialzista: contributo -10 (allineamento 40 + rotture 0 + diff 0 - 10 = 30)")
    line = cx.run("PUNT %s %s %s 0.0 0.0 6 1 1\n" % (" ".join([str(UP)] * 8 + [str(ND)]), " ".join(["1"] * 9), " ".join(map(str, strat))))[0].split()
    ck(int(line[0]) == 0, "PUNTEGGIO non calcolato se manca una cella accesa (si mostra '...')")

    # --- ETICHETTA: soglie sul numero arrotondato (89,6 -> 90 STRONG BUY)
    et = [(89.6, 3), (89.4, 2), (89.5, 3), (-89.5, -3), (-89.6, -3), (-89.4, -2), (70.0, 2), (69.5, 2), (69.49, 1),
          (40.0, 1), (39.5, 1), (39.4, 0), (-39.5, -1), (-39.4, 0), (0.0, 0), (100.0, 3), (-100.0, -3), (-70.0, -2)]
    oe = cx.run("".join("ETI %r 90 70 40\n" % s for s, _ in et))
    ck(all(int(o) == e == py_etichetta(s, 90, 70, 40) for o, (s, e) in zip(oe, et)),
       "ETICHETTA: soglie 90/70/40 sul numero arrotondato, simmetriche (89,6 -> STRONG BUY; -89,5 -> STRONG SELL; 39,4 -> niente)")

    # --- TOP
    dt_ = 0
    batch = []
    cases = []
    for _ in range(300 if not quick else 80):
        n = rng.randint(1, 28)
        sc = [rng.choice([rng.uniform(-100, 100), float(rng.randint(-100, 100)), 39.5, -39.5, 40.0])  for _ in range(n)]
        ok = [1 if rng.random() > 0.1 else 0 for _ in range(n)]
        tn = rng.randint(0, 8)
        cases.append((sc, ok, tn))
        batch.append("TOP %d %d 40\n%s\n" % (n, tn, " ".join("%r %d" % (s, o) for s, o in zip(sc, ok))))
    outs = cx.run("".join(batch))
    for (sc, ok, tn), line in zip(cases, outs):
        p = [int(x) for x in line.split()]
        got = p[1:1 + p[0]]
        if got != py_top(sc, ok, tn, 40) or got != ref_top(sc, ok, tn, 40):
            dt_ += 1
    ck(dt_ == 0, "TOP su %d casi: C++ == specchio == riferimento (sorted) (%d diff)" % (len(cases), dt_))
    ex = cx.run("TOP 6 5 40\n94 1 87 1 73 1 -81 1 -91 1 60 1\n")[0].split()
    ck([int(x) for x in ex[1:]] == [0, 1, 2, 3, 4], "TOP sull'esempio della guida (+94 +87 +73 -81 -91, piu' un 60): stesso ordine della guida")

    # --- calendario
    dd = 0
    batch = []
    ts = []
    for _ in range(600 if not quick else 150):
        t0 = rng.randint(0, 2 ** 32)
        ts.append(t0)
        batch.append("DOW %d\nPROSS %d 2592000 1\nPROSS %d 86400 0\n" % (t0, t0, t0))
    outs = cx.run("".join(batch))
    for i, t0 in enumerate(ts):
        w = int(outs[3 * i])
        pm = int(outs[3 * i + 1])
        pd_ = int(outs[3 * i + 2])
        refw = (dt.datetime.utcfromtimestamp(t0).weekday() + 1) % 7
        if w != refw or w != py_dow(t0) or pm != ref_prossima(t0, 0, True) or pm != py_prossima(t0, 0, True) or pd_ != t0 + 86400:
            dd += 1
    ck(dd == 0, "CALENDARIO su %d istanti 1970-2106: giorno della settimana e primo del mese dopo == Python datetime (%d diff)" % (len(ts), dd))
    oc = cx.run("PROSS %d 2592000 1\nPROSS %d 2592000 1\nPROSS %d 2592000 1\n" % (
        calendar.timegm((2024, 12, 1, 0, 0, 0)), calendar.timegm((2024, 2, 1, 0, 0, 0)), calendar.timegm((2023, 2, 1, 0, 0, 0))))
    ck([int(x) for x in oc] == [calendar.timegm((2025, 1, 1, 0, 0, 0)), calendar.timegm((2024, 3, 1, 0, 0, 0)), calendar.timegm((2023, 3, 1, 0, 0, 0))],
       "MN: dicembre -> 1 gennaio dell'anno dopo; febbraio bisestile e non")
    fri = calendar.timegm((2024, 6, 7, 0, 0, 0))
    sun = calendar.timegm((2024, 6, 9, 0, 0, 0))
    mon = calendar.timegm((2024, 6, 10, 0, 0, 0))
    thu = calendar.timegm((2024, 6, 6, 0, 0, 0))
    op = cx.run("PREC 4 1 %d %d %d %d\nPREC 4 0 %d %d %d %d\nPREC 2 1 %d %d\n" % (thu, fri, sun, mon, thu, fri, sun, mon, sun, mon))
    ck([int(x) for x in op] == [1, 2, -1], "PRECEDENTE D1: [gio, ven, dom, lun] -> venerdi'; senza salto -> domenica; solo [dom, lun] -> nessuna")

    # --- estremi, passo, caricamento, pianificatore
    oe = cx.run("EST 100 5.0 50 110 4.0 3.0\nEST 110 5.0 50 110 4.0 3.0\nEST 40 5.0 50 110 4.0 3.0\nEST 100 0 50 110 4.0 3.0\nEST 100 2.0 50 110 4.0 3.0\n")
    ck([x.split()[0] for x in oe] == ["1", "0", "0", "0", "1"] and fx(oe[0].split()[1]) == 5.0 and fx(oe[4].split()[2]) == 2.0,
       "ESTENDI: solo prezzi della candela in corso [t0, tNext) e > 0")
    oc = cx.run("CORR 3 120 180 4.0 3.0\n60 9.0 0.5 120 5.0 2.5 180 9.5 0.1\n")
    p = oc[0].split()
    ck(p[0] == "1" and fx(p[1]) == 5.0 and fx(p[2]) == 2.5, "CORREZIONE M1: usa solo le M1 dentro [t0, tNext) (quella prima e quella dopo no)")
    op = cx.run("PASSO 100 5 0 0 0 0 0 0\nPASSO 200 5 1 100 200 4 3 3.5\nPASSO 150 4.5 1 100 200 4 3 3.5\nPASSO 150 3.5 1 100 200 4 3 3.5\nPASSO 90 9 1 100 200 4 3 3.5\n")
    ck([x.split()[0] for x in op] == ["2", "2", "1", "0", "0"], "PASSO: mai caricata -> 2; candela finita -> 2 (stato vecchio tenuto); prezzo nuovo -> 1; uguale -> 0; tick di prima -> 0")
    rr = cx.run("RATES 2 1070 60 0 0\n1000 1 2 0.5 1.5 1060 1.5 1.8 1.2 1.6\nRATES 2 1120 60 0 0\n1000 1 2 0.5 1.5 1060 1.5 1.8 1.2 1.6\nRATES 1 1070 60 0 0\n1060 1.5 1.8 1.2 1.6\n"
                "RATES 3 %d 86400 0 1\n%d 1 2 0.5 1.5 %d 1.5 9 0.1 1.6 %d 1.6 1.9 1.4 1.7\n" % (mon + 10, fri, sun, mon))
    p0, p1, p2, p3 = [x.split() for x in rr]
    ck(p0[0] == "0" and int(p0[1]) == 1060 and int(p0[2]) == 1120 and fx(p0[7]) == 2.0 and fx(p0[8]) == 0.5,
       "CARICAMENTO: candela in corso + precedente; prossima apertura t0+60")
    ck(p1[0] == "2" and p1[1] == "-7" and fx(p1[3]) == -7.0, "CARICAMENTO: serie in ritardo sull'ultimo tick -> esito 2 e livelli NON toccati")
    ck(p2[0] == "1" and p2[1] == "-7", "CARICAMENTO: una sola candela -> esito 1, livelli non toccati")
    ck(p3[0] == "0" and fx(p3[7]) == 2.0 and fx(p3[8]) == 0.5, "CARICAMENTO D1 lunedi': precedente = venerdi' (la domenica, max 9 min 0,1, saltata)")
    # pianificatore: tetto, rotazione, attese
    sv = [1] * 20
    dp = [0] * 20
    opn = cx.run("PIAN 20 0 6 0\n%s\n" % " ".join("%d %d" % x for x in zip(sv, dp)))[0].split()
    ck(int(opn[0]) == 6 and [int(x) for x in opn[2:]] == [0, 1, 2, 3, 4, 5] and int(opn[1]) == 6, "PIANIFICA: al massimo 'budget' celle, a rotazione")
    served = [0] * 20
    rot = 0
    rounds = 0
    pend = [1 if i % 3 else 0 for i in range(20)]
    while any(pend[i] and not served[i] for i in range(20)) and rounds < 10:
        line = cx.run("PIAN 20 %d 3 5\n%s\n" % (rot, " ".join("%d %d" % (pend[i] and not served[i], 0) for i in range(20))))[0].split()
        m, rot = int(line[0]), int(line[1])
        for x in line[2:2 + m]:
            served[int(x)] = 1
        rounds += 1
    ck(rounds == math.ceil(sum(pend) / 3), "PIANIFICA: %d celle in attesa servite tutte in %d giri da 3 (nessuna affamata)" % (sum(pend), rounds))
    line = cx.run("PIAN 4 0 4 100\n1 50 1 101 1 100 0 0\n")[0].split()
    ck([int(x) for x in line[2:]] == [0, 2], "PIANIFICA: una cella in attesa di un nuovo tentativo non si carica prima del tempo")
    # rotazione con un mix casuale vs specchio
    dpp = 0
    for _ in range(100):
        n = rng.randint(1, 30)
        svr = [rng.randint(0, 1) for _ in range(n)]
        dpr_ = [rng.randint(0, 10) for _ in range(n)]
        rt = rng.randint(0, n - 1)
        bud = rng.randint(1, 8)
        now = rng.randint(0, 10)
        line = cx.run("PIAN %d %d %d %d\n%s\n" % (n, rt, bud, now, " ".join("%d %d" % x for x in zip(svr, dpr_))))[0].split()
        out, ro = py_pianifica(svr, dpr_, rt, bud, now)
        if [int(x) for x in line[2:]] != out or int(line[1]) != ro:
            dpp += 1
    ck(dpp == 0, "PIANIFICA su 100 casi casuali: C++ == specchio (%d diff)" % dpp)

    # --- raccordo portato nel blocco puro (classe 1068): valute dal nome, correlazioni, click, testi
    nomi = ["EURUSD", "EURUSD.m", "USDJPY", "GBPJPYpro", "XAUUSD", "EUREUR", "EUR", "usdjpy", "CHFJPY", "NZDCAD#"]
    ov = cx.run("".join("VALNOME %s\n" % n for n in nomi))
    att = [(1, 0, 4), (1, 0, 4), (1, 4, 7), (1, 1, 7), (0, -1, -1), (0, -1, -1), (0, -1, -1), (0, -1, -1), (1, 6, 7), (1, 3, 5)]
    ck([tuple(int(x) for x in o.split()) for o in ov] == att == [(1 if a else 0, b, q) for a, b, q in map(py_valutedanome, nomi)],
       "VALUTE dal nome: EURUSD -> EUR base/USD quotata, il suffisso non conta, XAUUSD/EUREUR/minuscole fuori dalla forza")
    voci = ["D30EUR>EURUSD:+", "100GBP>GBPUSD:-", " 225JPY > USDJPY : + ", "D30EUR>EURUSD", "D30EUR>EURUSD:x", ">EURUSD:+",
            "D30EUR>:+", "A>B:+-", "A:B>C:+", "USOIL>USDCAD:-"]
    op = cx.run("".join("PARSE %s\n" % v for v in voci))
    def fmt(r):
        return "%d [%s] [%s] %d" % (1 if r[0] else 0, r[1], r[2], r[3])
    ck(op == [fmt(py_parse(v)) for v in voci] and op[0] == "1 [D30EUR] [EURUSD] 1" and op[1] == "1 [100GBP] [GBPUSD] -1" and
       op[2] == "1 [225JPY] [USDJPY] 1" and all(o.startswith("0") for o in op[3:9]),
       "CORRELAZIONI: 'STRUMENTO>COPPIA:segno' letto giusto (spazi ignorati), 6 forme sbagliate rifiutate")
    clicks = ["tit", "s_3", "gb_12", "gt_0", "c_5_6", "c_5", "to_2", "sr_1", "fv_7", "fb_0", "fn_4", "bg", "fz", "h_3", "c__2", "x_1"]
    oc2 = cx.run("".join("CLICK %s\n" % b for b in clicks))
    ck([tuple(int(x) for x in o.split()) for o in oc2] == [py_leggiclick(b) for b in clicks] and
       [int(o.split()[0]) for o in oc2] == [6, 1, 1, 1, 2, 0, 3, 4, 5, 5, 5, 0, 0, 0, 2, 0] and oc2[4] == "2 5 6",
       "CLICK: simbolo/segnale -> D1, cella c_5_6 -> coppia 5 TF 6, TOP, correlazione, valuta; sfondo e intestazioni -> niente")
    otf = cx.run("TFORZA 0.3349\nTFORZA -0.1849\nTFORZA %r\n" % (-1e-9))
    ck(otf == ["+0,33", "-0,18", "-0,00"], "pannello: forza a 2 decimali con la virgola (%s)" % otf)
    osc = cx.run("SCELLA 3.5 2 4.5 2 4 1 -1 0\nSCELLA 3.5 2 4.5 2 4 1 %d 1\nSCELLA 2 2 4.5 2 4 1 %d 1\n" % (FAILUP, FAILUP))
    ck(osc == ["1 %d 1" % FAILUP, "0 %d 1" % FAILUP, "1 %d 0" % FAILUP], "STATO CELLA: cambio segnalato quando cambia lo stato O il solo bordo, non altrimenti")
    # caricamento completo (livelli + prezzo di questo giro) contro lo specchio
    dc = 0
    for _ in range(150):
        got = rng.randint(0, 4)
        t0b = 1000 + rng.randint(0, 3) * 60
        ts = [t0b + 60 * i for i in range(got)]
        oo = [[round(rng.uniform(1, 2), 3) for _ in range(4)] for _ in range(got)]
        tt = rng.choice([0, (ts[-1] + 30) if ts else 50, (ts[-1] + 60) if ts else 70, (ts[-1] - 10) if ts else 10])
        bid = rng.choice([0.0, round(rng.uniform(0.5, 2.5), 3)])
        line = cx.run("CARICA %d %d %r 60 0 0\n%s\n" % (got, tt, bid, " ".join("%d %r %r %r %r" % (ts[i], *oo[i]) for i in range(got))))[0].split()
        e, v = py_carica(ts, [x[0] for x in oo], [x[1] for x in oo], [x[2] for x in oo], [x[3] for x in oo], tt, bid, 60, False, False)
        if int(line[0]) != e or (e == 0 and (int(line[1]), int(line[2])) + tuple(fx(x) for x in line[3:9]) != v):
            dc += 1
        if e != 0 and line[1] != "-7":
            dc += 1
    ck(dc == 0, "CARICAMENTO completo (livelli + prezzo del giro) su 150 casi: C++ == specchio, e a esito non OK i livelli restano intatti (%d diff)" % dc)
    # cripto (classe 1069): un SABATO fra le candele lette -> ogni giorno conta
    wed, thu, fri, sat = [calendar.timegm((2024, 6, d, 0, 0, 0)) for d in (5, 6, 7, 8)]
    sun, mon = calendar.timegm((2024, 6, 9, 0, 0, 0)), calendar.timegm((2024, 6, 10, 0, 0, 0))
    ocr = cx.run("PREC 6 1 %d %d %d %d %d %d\nPREC 6 1 %d %d %d %d %d %d\n" % (wed, thu, fri, sat, sun, mon, wed, thu, fri, sun, mon, mon + 86400))
    ck([int(x) for x in ocr] == [4, 4], "D1 cripto (sabato fra le candele lette): il lunedi' il precedente e' la DOMENICA (indice 4); forex senza sabato, martedi': il lunedi' (indice 4) (classe 1069)")
    ocr2 = cx.run("PREC 6 1 %d %d %d %d %d %d\n" % (wed - 86400, wed, thu, fri, sun, mon))
    ck(int(ocr2[0]) == 3, "D1 forex con la candela della domenica (nessun sabato): il lunedi' il precedente e' il VENERDI'")

    # --- RICALCOLO COMPLETO (28 coppie + 5 correlazioni) contro specchio e riferimento indipendente
    mappa = [("D30EUR", "EURUSD", 1), ("100GBP", "GBPUSD", -1), ("225JPY", "USDJPY", 1), ("200AUD", "AUDUSD", 1), ("USOIL", "USDCAD", -1)]
    sancop = [COPPIE28.index(m[1]) for m in mappa]
    sanseg = [m[2] for m in mappa]
    coppiasan = [-1] * 28
    for i, ci in enumerate(sancop):
        coppiasan[ci] = i
    base28, quot28 = bq(COPPIE28)
    dtm = dtr = 0
    tops_nonvuoti = 0
    esiti_visti = set()
    for it in range(80 if quick else 250):
        on = [1 if rng.random() > 0.1 else 0 for _ in range(9)]
        on[6] = 1
        pesi_on = [float(PESI[c2]) if on[c2] else 0.0 for c2 in range(9)]
        strat = [1 if c2 >= 5 else 0 for c2 in range(9)]
        nd = rng.choice([0.0, 0.0, 0.03])
        st = [rnd_state(rng, nd) if on[k % 9] else ND for k in range(33 * 9)]
        if it % 5 == 0:     # coppie molto allineate: punteggi alti, TOP pieno
            for s2 in range(28):
                d = rng.choice([UPBRK, DNBRK])
                for c2 in range(9):
                    if on[c2] and rng.random() < 0.85:
                        st[s2 * 9 + c2] = d
        bb = base28 + [-1] * 5
        qq = quot28 + [-1] * 5
        txt = "TUTTO 28 5\n" + "".join("%d %d %s\n" % (bb[s2], qq[s2], " ".join(map(str, st[s2 * 9:(s2 + 1) * 9]))) for s2 in range(33))
        txt += " ".join("%d %d" % (sancop[i], sanseg[i]) for i in range(5)) + "\n" + " ".join(map(str, coppiasan)) + "\n"
        txt += " ".join(repr(x) for x in pesi_on) + "\n" + " ".join(map(str, on)) + "\n" + " ".join(map(str, strat)) + "\n6 5 40\n"
        out = cx.run(txt)
        num, den, fz, ordv = parse_forza(out[0])
        esiti = [int(x) for x in out[1].split()]
        rows = []
        for s2 in range(28):
            pp = out[2 + s2].split()
            rows.append((int(pp[0]),) + tuple(fx(x) for x in pp[1:]))
        tp = [int(x) for x in out[30].split()]
        top = tp[1:1 + tp[0]]
        m = py_ricalcola_tutto(st, 28, 5, bb, qq, pesi_on, on, strat, 6, sancop, sanseg, coppiasan, 5, 40)
        if (num, den, fz, ordv, esiti, rows, top) != (m[0], m[1], m[2], m[3], m[4], m[5], m[6]):
            dtm += 1
        # riferimento indipendente
        rws = [[(None if x == ND else x) for x in st[s2 * 9:(s2 + 1) * 9]] for s2 in range(28)]
        rf_ = ref_forza_parziale(COPPIE28, rws, [PESI[c2] if on[c2] else 0 for c2 in range(9)])
        dsg = lambda x: 1 if x in (UP, UPBRK) else (-1 if x in (DN, DNBRK) else 0)
        rsc, rok = [], []
        for s2, nome in enumerate(COPPIE28):
            san = None
            for i, (strum, cop, sg) in enumerate(mappa):
                if cop == nome:
                    san = (dsg(st[s2 * 9 + 6]), dsg(st[(28 + i) * 9 + 6]), sg)
            r = ref_punteggio(st[s2 * 9:(s2 + 1) * 9], on, rf_[nome[:3]], rf_[nome[3:6]], san)
            rok.append(0 if r is None else 1)
            rsc.append(0.0 if r is None else r)
        rtop = ref_top(rsc, rok, 5, 40)
        bad_ = any(abs(rf_[VAL[k]] - fz[k]) > 1e-15 for k in range(8))
        bad_ |= any(rok[s2] != rows[s2][0] or (rok[s2] and abs(rsc[s2] - rows[s2][1]) > 1e-9) for s2 in range(28))
        bad_ |= (top != rtop)
        for i, (strum, cop, sg) in enumerate(mappa):
            dc_, ds_ = dsg(st[COPPIE28.index(cop) * 9 + 6]), dsg(st[(28 + i) * 9 + 6])
            atteso = 0 if (dc_ == 0 or ds_ == 0) else (1 if dc_ == sg * ds_ else -1)
            bad_ |= (esiti[i] != atteso)
            esiti_visti.add(esiti[i])
        if bad_:
            dtr += 1
        if top:
            tops_nonvuoti += 1
    ck(dtm == 0, "RICALCOLO COMPLETO (forza, ordine, 5 correlazioni, 28 punteggi, TOP): C++ == specchio (%d diff)" % dtm)
    ck(dtr == 0 and tops_nonvuoti > 10 and esiti_visti == {-1, 0, 1},
       "RICALCOLO COMPLETO == riferimento indipendente scritto dalla spec (%d diff; TOP non vuoto in %d giri; esiti visti %s)" % (dtr, tops_nonvuoti, sorted(esiti_visti)))

    # --- cio' che si vede (classe 1068: portato nel blocco puro e provato per comportamento)
    ov = cx.run("VIS 0 4 -1\nVIS 0 4 0\nVIS 0 4 4\nVIS 0 4 7\nVIS -1 -1 3\nVIS -1 -1 -1\n")
    ck(ov == ["1", "1", "1", "0", "0", "1"], "FILTRO valuta: la coppia si vede se la valuta e' la base O la quotata; senza filtro tutte (%s)" % ov)
    ob = cx.run("BARRA 0.33 200 90\nBARRA -0.18 200 90\nBARRA 0.0 200 90\nBARRA -1.0 200 90\nBARRA 1.0 200 90\nBARRA -0.001 200 90\n")
    ck(ob == ["1 200 30", "0 184 16", "1 200 1", "0 110 90", "1 200 90", "0 199 1"],
       "BARRE: positive a destra dell'asse in verde, negative a sinistra in rosso, lunghezza |forza| x 90 px (%s)" % ob)
    ts_ = cx.run("TSEG 93.6 90 70 40\nTSEG -81.2 90 70 40\nTSEG 23.4 90 70 40\nTSEG -0.3 90 70 40\nTSEG 39.5 90 70 40\nTSEG -89.5 90 70 40\n")
    ck(ts_ == ["[STRONG BUY +94]", "[SELL -81]", "[+23]", "[+0]", "[WEAK + +40]", "[STRONG SELL -90]"],
       "SEGNALE a video: etichetta e numero arrotondato coerenti (%s)" % ts_)
    te_ = cx.run("TESITO 1\nTESITO -1\nTESITO 0\n")
    ck(te_ == ["ALIGN", "DIVERGE", "MIXED"], "CORRELAZIONE a video: +1 ALIGN, -1 DIVERGE, 0 MIXED")
    stc = [rnd_state(rng, 0.3) for _ in range(5 * 9)]
    atc = [rng.randint(0, 1) for _ in range(5 * 9)]
    oc_ = cx.run("COPERT 4\n%s\n" % " ".join("%d %d" % (stc[k], atc[k]) for k in range(4 * 9)))[0].split()
    ck([int(x) for x in oc_] == [sum(1 for k in range(36) if atc[k] and stc[k] != ND), sum(atc[:36])],
       "COPERTURA: celle con dati sulle celle attive delle sole coppie (%s)" % oc_)
    num27 = parse_forza(cx.run(forza_cmd([x for x in COPPIE28 if x != "EURUSD"], [rnd_state(rng) for _ in range(27 * 9)], [float(p) for p in PESI]))[0])
    num28 = parse_forza(cx.run(forza_cmd(COPPIE28, [rnd_state(rng) for _ in range(28 * 9)], [float(p) for p in PESI]))[0])
    rs = cx.run("RSOMMA %s\nRSOMMA %s\n" % (" ".join("%r %r" % (num27[2][k], num27[1][k]) for k in range(8)),
                                              " ".join("%r %r" % (num28[2][k], num28[1][k]) for k in range(8))))
    ck("denominatori uguali=no" in rs[0] and "denominatori uguali=si" in rs[1] and rs[1].startswith("somma forze=+0.000000") or
       rs[1].startswith("somma forze=-0.000000"),
       "DIAGNOSI 'somma': 27 coppie -> denominatori uguali=no; 28 -> si e somma 0 (%s | %s)" % (rs[0][:60], rs[1][:60]))
    ordx = [3, 0, 7, 1, 2, 4, 5, 6]
    of_ = cx.run("FCLICK -1 0 %s\nFCLICK 3 0 %s\nFCLICK 3 2 %s\nFCLICK 5 9 %s\n" % tuple([" ".join(map(str, ordx))] * 4))
    ck(of_ == ["3", "-1", "7", "5"], "CLICK sulla valuta: filtra la valuta che sta in QUELLA riga (ordine per forza); di nuovo = tutte (%s)" % of_)
    ol_ = cx.run("COLLEGA 5 28 %s\n" % " ".join(str(COPPIE28.index(x)) for x in ("EURUSD", "GBPUSD", "USDJPY", "AUDUSD", "USDCAD")))[0].split()
    att_l = [-1] * 28
    for i, x in enumerate(("EURUSD", "GBPUSD", "USDJPY", "AUDUSD", "USDCAD")):
        att_l[COPPIE28.index(x)] = i
    ck([int(x) for x in ol_] == att_l, "CORRELAZIONI collegate alle loro coppie (EURUSD<-DAX ... USDCAD<-WTI), le altre 23 senza")

    ids = [128968168864101576, 133157212547890123, 2 ** 53 + 1, 2 ** 62 + 12345, 4294967295, 4294967296, 1]
    oi = cx.run("".join("IDMETA %d\n" % x for x in ids))
    ck(all(int(o.split()[2]) == x for o, x in zip(oi, ids)) and all(float(o.split()[0]) < 2 ** 32 and float(o.split()[1]) < 2 ** 32 for o in oi),
       "ID del grafico di lettura (oltre 2^53) salvato in due meta' e ricostruito ESATTO (7 ID, compresi 2^53+1 e 2^32)")
    ck(float(2 ** 53 + 1) != 2 ** 53 + 1, "controesempio: lo stesso ID in UN double si perde (2^53+1 -> 2^53): per questo le due meta'")
    of2 = cx.run("FINER 7 6 28 7\nFINER 2 29 30 7\nFINER 3 20 30 7\nFINER 1 0 1 7\n")
    ck(of2 == ["1", "1", "0", "1"], "DIAGNOSI: riga stampata quando ha 7 coppie O all'ultima coppia (lista di 30: le ultime 2 non si perdono)")

    # --- testi della diagnosi
    rows = [[rnd_state(rng, 0.1) for _ in range(9)] for _ in range(30)]
    orr = cx.run("".join("RIGA EURUSD %s\n" % " ".join(map(str, r)) for r in rows))
    ck(all(o == py_riga("EURUSD", r, 0) for o, r in zip(orr, rows)), "RIGA della diagnosi: C++ == specchio")
    os_ = cx.run("SEGN 0.1234567 4\nSEGN -0.5 2\nSEGN 0 2\nSEGN 868 2\nSEGN -0.0 0\nSEGN %r 0\n" % mround(-0.3))
    ck(os_ == ["+0.1235", "-0.50", "+0.00", "+868.00", "+0", "+0"],
       "numeri con segno della diagnosi e del SEGNALE; lo zero negativo di MathRound(-0,3) esce '+0', non '+-0' (%s)" % os_)

    # --- cancello indipendente 02/10: una coppia con base == quotata (es. "EUREUR" scritta a mano)
    #     non deve toccare NE' il numeratore NE' il denominatore (altrimenti la forza di EUR si diluisce)
    st28 = [rnd_state(rng) for _ in range(28 * NTF)]
    o28 = parse_forza(cx.run(forza_cmd(COPPIE28, st28, pesi))[0])
    o29 = parse_forza(cx.run(forza_cmd(COPPIE28 + ["EUREUR"], st28 + [UPBRK] * NTF, pesi))[0])
    ck(o28 == o29, "FORZA: una coppia con base == quotata (EUREUR) resta FUORI da numeratore e denominatore")
    return bad


# ===========================================================================
# R) dati reali: simulazione del timer
# ===========================================================================
def load_m1(path, d0, d1):
    rows = []
    with open(path) as f:
        f.readline()
        for line in f:
            p = line.rstrip("\n").split(",")
            t = calendar.timegm(dt.datetime.strptime(p[0], "%Y-%m-%d %H:%M").timetuple()) + 3600   # UTC -> UTC+1 (server BCM)
            if t < d0:
                continue
            if t >= d1:
                break
            rows.append((t, float(p[4]), float(p[2]), float(p[3]), float(p[1])))   # t, o, h, l, c
    return rows


def ref_bucket(t, c):
    d = dt.datetime.utcfromtimestamp(t)
    if c <= 6:
        sec = [60, 300, 900, 1800, 3600, 14400, 86400][c]
        return t - t % sec
    if c == 7:
        dd = dt.datetime(d.year, d.month, d.day) - dt.timedelta(days=(d.weekday() + 1) % 7)
        return calendar.timegm(dd.timetuple())
    return calendar.timegm((d.year, d.month, 1, 0, 0, 0))


def ticks_of(bar):
    t, o, h, l, c = bar
    x1, x2 = (l, h) if c >= o else (h, l)
    return [(t, o), (t + 20, x1), (t + 40, x2), (t + 59, c)]


def reference_states(bars, salta=True):
    """stato VERO a ogni tick, dalle candele costruite con TUTTI i tick (Python datetime per giorni/settimane/mesi)."""
    ser = [[] for _ in range(NTF)]
    out = []
    for bar in bars:
        for q, (tt, p) in enumerate(ticks_of(bar)):
            for c in range(NTF):
                b = ref_bucket(tt, c)
                if not ser[c] or ser[c][-1][0] != b:
                    ser[c].append([b, p, p, p, p])
                else:
                    B = ser[c][-1]
                    B[2] = max(B[2], p)
                    B[3] = min(B[3], p)
                    B[4] = p
            sts = []
            prevd1 = None
            for c in range(NTF):
                S = ser[c]
                cur = S[-1]
                prev = None
                if c == 6 and salta:
                    for B in reversed(S[:-1]):
                        if dt.datetime.utcfromtimestamp(B[0]).weekday() < 5:
                            prev = B
                            break
                elif len(S) >= 2:
                    prev = S[-2]
                if c == 6:
                    prevd1 = prev
                sts.append(ND if prev is None else ref_stato(cur[4], cur[1], cur[2], cur[3], prev[2], prev[3]))
            out.append((tt, q, sts, prevd1))
    return out


def sim(cx, bars, mode, corr, budget, lag, salta):
    txt = "SIM %d %d %d %d %d %d\n" % (mode, corr, budget, lag, 1 if salta else 0, len(bars)) + \
          "".join("%d %r %r %r %r\n" % b for b in bars)
    lines = cx.run(txt)
    steps = []
    end = None
    car = {}
    for ln in lines:
        if ln.startswith("END"):
            p = [int(x) for x in ln.split()[1:]]
            end = [(p[3 * k], p[3 * k + 1], p[3 * k + 2]) for k in range(9)]
        elif ln.startswith("CAR"):
            p = ln.split()
            car[int(p[1])] = [int(x) for x in p[2:]]
        else:
            p = ln.split()
            sts = [ND if ch == "." else int(ch) for ch in p[2]]
            steps.append((int(p[0]), int(p[1]), sts, p[3], fx(p[4]), fx(p[5])))
    return steps, end, car


def py_sim(bars, mode, corr, budget, lag, salta):
    """specchio Python della simulazione (stesse funzioni dello specchio)."""
    SECS = [60, 300, 900, 1800, 3600, 14400, 86400, 604800, 2592000]
    ser = [[] for _ in range(9)]
    car = [0] * 9
    t0 = [0] * 9; tn = [0] * 9; o0 = [0.0] * 9; h0 = [0.0] * 9; l0 = [0.0] * 9; cl = [0.0] * 9; h1 = [0.0] * 9; l1 = [0.0] * 9
    serve = [0] * 9; dopo = [0] * 9; nuovo = [0] * 9
    rot = 0
    step = 0
    out = []
    for bar in bars:
        for q, (tt, p) in enumerate(ticks_of(bar)):
            for k in range(9):
                b = ref_bucket(tt, k)
                if not ser[k] or ser[k][-1][0] != b:
                    ser[k].append([b, p, p, p, p])
                    nuovo[k] = 1
                else:
                    B = ser[k][-1]
                    if p > B[2]:
                        B[2] = p
                    if p < B[3]:
                        B[3] = p
                    B[4] = p
            if not (mode == 0 or q in (0, 3)):
                continue
            for k in range(9):
                r, h0[k], l0[k], cl[k] = py_passo(tt, p, car[k] != 0, t0[k], tn[k], h0[k], l0[k], cl[k])
                serve[k] = 1 if r == 2 else 0
            sel, rot = py_pianifica(serve, dopo, rot, budget, step)
            for k in sel:
                nb = 7 if (k == 6 and salta) else 2
                avail = len(ser[k])
                if lag and nuovo[k]:
                    avail -= 1
                    nuovo[k] = 0
                got = max(0, min(nb, avail))
                S = ser[k][avail - got:avail]
                e, v = py_carica([B[0] for B in S], [B[1] for B in S], [B[2] for B in S], [B[3] for B in S], [B[4] for B in S],
                                 tt, p, SECS[k], k == 8, k == 6 and salta)
                if e == 0:
                    a0, an, ao, ah, al, ac, ah1, al1 = v
                    t0[k], tn[k], o0[k], h0[k], l0[k], cl[k], h1[k], l1[k] = a0, an, ao, ah, al, ac, ah1, al1
                    car[k] = 1
                    serve[k] = 0
                    dopo[k] = 0
                else:
                    dopo[k] = step + 1
            if not lag:
                nuovo = [0] * 9
            if corr and q == 3:
                M = ser[0][-3:]
                for k in range(9):
                    if car[k] and not serve[k]:
                        _, h0[k], l0[k] = py_corregg([B[0] for B in M], [B[2] for B in M], [B[3] for B in M], t0[k], tn[k], h0[k], l0[k])
            sts = [py_stato(cl[k], o0[k], h0[k], l0[k], h1[k], l1[k]) if car[k] else ND for k in range(9)]
            out.append((tt, q, sts, "".join(str(s) for s in serve), h1[6], l1[6]))
            step += 1
    return out


def real_data(cx, quick):
    print("\n== R) dati reali XAUUSD M1 2024 (UTC+1), timer simulato con le funzioni VERE")
    if not os.path.exists(DATI):
        check(False, "dati reali assenti: %s" % DATI)
        return
    d0 = calendar.timegm((2024, 6, 3, 0, 0, 0))
    d1 = calendar.timegm((2024, 6, 22, 0, 0, 0)) if quick else calendar.timegm((2024, 7, 13, 0, 0, 0))
    bars = load_m1(DATI, d0 - 40 * 86400, d1)      # 40 giorni prima: W1/MN con candela precedente
    print("  (finestra %s -> %s, %d candele M1, %d tick)" % (dt.datetime.utcfromtimestamp(bars[0][0]).date(),
                                                            dt.datetime.utcfromtimestamp(bars[-1][0]).date(), len(bars), 4 * len(bars)))
    ref = reference_states(bars, True)
    # (a) tutti i tick, tetto pieno
    st, end, car = sim(cx, bars, 0, 0, 9, 0, True)
    pys = py_sim(bars, 0, 0, 9, 0, True)
    ck_m = sum(1 for a, b in zip(st, pys) if a[0] != b[0] or a[2] != b[2] or a[3] != b[3] or a[4] != b[4] or a[5] != b[5])
    check(len(st) == len(pys) == len(ref) and ck_m == 0, "(a) simulazione C++ == specchio Python passo per passo (%d passi, %d diff)" % (len(st), ck_m))
    diff = sum(1 for a, r in zip(st, ref) if a[2] != r[2])
    nd = sum(1 for a in st for s in a[2] if s == ND)
    check(diff == 0, "(a) TUTTI i tick: stato dei 9 TF == riferimento indipendente a OGNI passo (%d passi, %d diversi; celle n/d iniziali %d)" % (len(st), diff, nd))
    conta = Counter_states(st)
    check(all(conta.get(s, 0) > 0 for s in (UP, UPBRK, DN, DNBRK, FAILUP, FAILDN)),
          "(a) sui dati veri compaiono tutti e 6 gli stati della guida (%s)" % {nm: conta.get(s, 0) for nm, s in
                                                                              (("UP", UP), ("UPBRK", UPBRK), ("DN", DN), ("DNBRK", DNBRK), ("FAILUP", FAILUP), ("FAILDN", FAILDN), ("FAIL2", FAIL2), ("NEUTRO", NEUTRO))})
    # una CopyRates per candela nuova: le candele caricate sono ESATTAMENTE quelle della serie dopo la prima
    okc = True
    msg = []
    for k in range(9):
        okl, kol, nbars = end[k]
        bucks = sorted(set(ref_bucket(tt, k) for b in bars for tt, _ in ticks_of(b)))
        caricate = car.get(k, [])
        first = caricate[0] if caricate else None
        attese = [b for b in bucks if first is not None and b >= first]
        good = caricate == attese and len(set(caricate)) == len(caricate)
        okc &= good
        msg.append("%s %d/%d" % (TFN[k], okl, nbars))
    check(okc, "(a) UNA sola CopyRates riuscita per candela nuova, nessuna saltata, nessuna doppia (%s)" % ", ".join(msg))
    ore = (bars[-1][0] - bars[0][0]) / 3600.0
    tot = sum(e[0] + e[1] for e in end)
    print("  info: %d CopyRates su %.0f ore di mercato = %.1f al minuto per simbolo (28 coppie: ~%.0f/min, piu' %d/min di correzione M1)"
          % (tot, ore, tot / (ore * 60), 28 * tot / (ore * 60), 28 + 5))
    # (b) solo apertura e chiusura del minuto: senza correzione DEVE sbagliare, con correzione no
    refc = [r for r in ref if r[1] == 3]
    st_nc, _, _ = sim(cx, bars, 1, 0, 9, 0, True)
    st_c, _, _ = sim(cx, bars, 1, 1, 9, 0, True)
    py_c = py_sim(bars, 1, 1, 9, 0, True)
    st_nc3 = [a for a in st_nc if a[1] == 3]
    st_c3 = [a for a in st_c if a[1] == 3]
    d_nc = sum(1 for a, r in zip(st_nc3, refc) if a[2] != r[2])
    d_c = sum(1 for a, r in zip(st_c3, refc) if a[2] != r[2])
    fail_persi = sum(1 for a, r in zip(st_nc3, refc) for k in range(9) if r[2][k] in (FAILUP, FAILDN, FAIL2) and a[2][k] != r[2][k])
    check(len(st_c3) == len(refc) and d_nc > 0 and fail_persi > 0,
          "(b) CASO CHE DEVE SCATTARE: campionando solo apertura e chiusura, SENZA correzione M1 %d chiusure su %d hanno stati sbagliati (%d fail invisibili)"
          % (d_nc, len(refc), fail_persi))
    check(d_c == 0, "(b) CON la correzione M1 (3 candele) a ogni chiusura del minuto lo stato == riferimento (%d diversi su %d)" % (d_c, len(refc)))
    mm = sum(1 for a, b in zip(st_c, py_c) if a[2] != b[2] or a[3] != b[3])
    check(mm == 0, "(b) simulazione con correzione: C++ == specchio Python (%d diff)" % mm)
    # (c) tetto basso + serie in ritardo: nessuna cella torna n/d, e a celle ferme lo stato e' giusto
    st_l, end_l, _ = sim(cx, bars, 0, 0, 2, 1, True)
    tornate_nd = 0
    seen = [False] * 9
    for a in st_l:
        for k in range(9):
            if a[2][k] != ND:
                seen[k] = True
            elif seen[k]:
                tornate_nd += 1
    ferme = [(a, r) for a, r in zip(st_l, ref) if a[3] == "000000000"]
    dl = sum(1 for a, r in ferme if a[2] != r[2])
    pend = sum(1 for a in st_l if a[3] != "000000000")
    check(tornate_nd == 0, "(c) tetto 2 CopyRates/passo e serie in ritardo: nessuna cella si azzera dopo il primo stato (%d)" % tornate_nd)
    check(dl == 0 and pend > 0 and sum(e[1] for e in end_l) > 0,
          "(c) %d passi con caricamenti in coda o serie in ritardo (%d tentativi falliti): nei %d passi senza code lo stato == riferimento (%d diversi)"
          % (pend, sum(e[1] for e in end_l), len(ferme), dl))
    # (d) lunedi' con la candela della domenica
    lun = [(a, r) for a, r in zip(st, ref) if dt.datetime.utcfromtimestamp(a[0]).weekday() == 0 and r[3] is not None]
    lun_sun = set()
    bucks_d1 = sorted(set(ref_bucket(b[0], 6) for b in bars))
    for b in bucks_d1:
        if dt.datetime.utcfromtimestamp(b).weekday() == 6:
            lun_sun.add(b + 86400)
    righe = [(a, r) for a, r in lun if ref_bucket(a[0], 6) in lun_sun]
    dd = sum(1 for a, r in righe if a[4] != r[3][2] or a[5] != r[3][3])
    fri_ok = all(dt.datetime.utcfromtimestamp(r[3][0]).weekday() == 4 for a, r in righe)
    check(len(lun_sun) >= 2 and len(righe) > 0 and dd == 0 and fri_ok,
          "(d) %d lunedi' preceduti da una candela D1 della DOMENICA: max/min precedenti == venerdi' a ogni passo (%d passi, %d diversi)"
          % (len(lun_sun), len(righe), dd))
    st_n, _, _ = sim(cx, bars, 0, 0, 9, 0, False)
    dn = sum(1 for a, r in zip(st_n, ref) if ref_bucket(a[0], 6) in lun_sun and (a[4] != r[3][2] or a[5] != r[3][3]))
    dstate = sum(1 for a, r in zip(st_n, ref) if ref_bucket(a[0], 6) in lun_sun and a[2][6] != r[2][6])
    check(dn > 0, "(d) CONTROESEMPIO: la regola ingenua (precedente = candela prima) usa la domenica il lunedi': %d passi con livelli sbagliati, %d con lo stato D1 sbagliato"
          % (dn, dstate))


def Counter_states(st):
    cnt = {}
    for a in st:
        for s in a[2]:
            cnt[s] = cnt.get(s, 0) + 1
    return cnt


# ===========================================================================
# M) mutanti sul sorgente vero (classe 1033)
# ===========================================================================
MUTANTS = [
    ("segno della quotata", "num[q]-=val;", "num[q]+=val;"),
    ("denominatore senza il x2", "den[b]+=2.0*peso[c];", "den[b]+=peso[c];"),
    ("rottura su con >=", "if(c>h1) return FFX_S_UPBRK;", "if(c>=h1) return FFX_S_UPBRK;"),
    ("rottura giu' con <=", "if(c<l1) return FFX_S_DNBRK;", "if(c<=l1) return FFX_S_DNBRK;"),
    ("fail su solo sotto l'apertura", "if(fu) return FFX_S_FAILUP;", "if(fu && c<=o0) return FFX_S_FAILUP;"),
    ("doppio fail tolto", "if(fu && fd) return FFX_S_FAIL2;", ""),
    ("valore FAIL_DN col segno sbagliato", "case FFX_S_FAILDN: return 0.5;", "case FFX_S_FAILDN: return -0.5;"),
    ("i fail NON contano come inversi nell'allineamento", "if(s==FFX_S_UP || s==FFX_S_UPBRK || s==FFX_S_FAILDN) return 1.0;", "if(s==FFX_S_UP || s==FFX_S_UPBRK) return 1.0;"),
    ("nessuna penalita' per il fail su", "if(s==FFX_S_FAILUP) return -0.5;", "if(s==FFX_S_FAILUP) return 0.0;"),
    ("correlazione senza segno atteso", "return (dCoppia==segno*dStrum) ? 1 : -1;", "return (dCoppia==dStrum) ? 1 : -1;"),
    ("etichetta sul numero non arrotondato", "double r=MathRound(score);", "double r=score;"),
    ("differenza di forza senza /2", "diff=(fBase-fQuot)/2.0;", "diff=(fBase-fQuot);"),
    ("domenica valida come giorno precedente", "if(w>=1 && w<=5) return i;", "if(w<=5) return i;"),
    ("dicembre -> gennaio dello stesso anno", "if(m>12) { m=1; a++; }", "if(m>12) { m=1; }"),
    ("estremi estesi anche con tick di altre candele", "if(p<=0.0 || tt<t0 || tt>=tNext) return false;", "if(p<=0.0) return false;"),
    ("candela finita non ricaricata", "   if(tt>=tNext) return 2;\n", "\n"),
    ("correzione M1 con candele precedenti", "if(mt[i]<t0 || mt[i]>=tNext) continue;", "if(mt[i]>=tNext) continue;"),
    ("serie in ritardo accettata", "if(tTick>0 && tTick>=tn) return FFX_C_INDIETRO;", ""),
    ("tetto dei caricamenti ignorato", "for(int j=0;j<n && m<budget;j++)", "for(int j=0;j<n;j++)"),
    ("rotazione ferma", "rotOut=(k+1)%n;", "rotOut=rot;"),
    ("TOP senza valore assoluto", "double a=MathAbs(MathRound(score[i]));", "double a=MathRound(score[i]);"),
    ("ordine non stabile", "while(j>=0 && forza[ord[j]]<forza[x])", "while(j>=0 && forza[ord[j]]<=forza[x])"),
    ("punteggio calcolato con celle mancanti", "if(x==FFX_S_ND) return false;", "if(x==FFX_S_ND) continue;"),
    ("cella senza dati nel denominatore", "if(x==FFX_S_ND || peso[c]<=0.0) continue;", "if(peso[c]<=0.0) continue;"),
    ("bordo verde anche a prezzo pari", "if(c>o0) return 1;", "if(c>=o0) return 1;"),
    ("giorno della settimana sfasato", "int w=(int)((d+4)%7);", "int w=(int)((d+3)%7);"),
    ("prezzo uguale non e' un cambio", "if(bid!=cl) { cl=bid; ch=true; }", "if(bid>cl) { cl=bid; ch=true; }"),
    ("ricalcolo: forza base e quotata scambiate", "bool ok=FFX_Punteggio(st,s*FFX_NTF,on,strat,forza[b],forza[q],sTF,dS,sg,x1,x2,x3,x4,x5);",
     "bool ok=FFX_Punteggio(st,s*FFX_NTF,on,strat,forza[q],forza[b],sTF,dS,sg,x1,x2,x3,x4,x5);"),
    ("ricalcolo: esito correlazione sulla coppia sbagliata", "int dC=(sanTF>=0) ? FFX_DirSanity(st[sanCoppia[i]*FFX_NTF+sanTF]) : 0;",
     "int dC=(sanTF>=0) ? FFX_DirSanity(st[i*FFX_NTF+sanTF]) : 0;"),
    ("ricalcolo: TOP oltre la soglia ignorata", "return FFX_TopOpp(score,scOk,ns,tn,soglia,top);", "return FFX_TopOpp(score,scOk,ns,tn,0.0,top);"),
    ("valute: base e quotata scambiate", "   string sb=StringSubstr(nome,0,3);\n   string sq=StringSubstr(nome,3,3);",
     "   string sb=StringSubstr(nome,3,3);\n   string sq=StringSubstr(nome,0,3);"),
    ("valute: la stessa due volte accettata", "   if(b<0 || q<0 || b==q)\n     {\n      b=-1;", "   if(b<0 || q<0)\n     {\n      b=-1;"),
    ("correlazione: segno - letto come +", "else if(sg==\"-\") segno=-1;", "else if(sg==\"-\") segno=1;"),
    ("correlazione: spazi non tolti", "   StringReplace(v,\" \",\"\");\n   int a=StringFind(v,\">\");", "   int a=StringFind(v,\">\");"),
    ("click: cella senza TF accettata", "if(tipo==\"c\") return (p2>=0) ? 2 : 0;", "if(tipo==\"c\") return 2;"),
    ("click: TF letto al posto della coppia", "if(p2>=0) b=(int)StringToInteger(StringSubstr(resto,p2+1));", "if(p2>=0) b=a;"),
    ("caricamento: prezzo del giro ignorato", "      FFX_Estendi(tTick,bid,a0,an,ah,al);\n      ac=bid;", "      ac=ac;"),
    ("stato cella: cambio di bordo non segnalato", "bool ch=(s2!=st || b2!=bo);", "bool ch=(s2!=st);"),
    ("cripto: sabato non riconosciuto", "      if(FFX_Dow((long)t[i])==6) sab=true;", "      if(FFX_Dow((long)t[i])==0) sab=true;"),
    ("pannello: punto al posto della virgola", "   StringReplace(s,\".\",\",\");\n   return s;", "   return s;"),
    ("filtro solo sulla base", "   return (b==filtro || q==filtro);", "   return (b==filtro);"),
    ("barre negative a destra", "   x=pos ? xz : xz-w;", "   x=xz;"),
    ("segnale senza etichetta", "   if(lab==\"\") return num;\n   return lab+\" \"+num;", "   return num;"),
    ("segnale col numero non arrotondato", "   string num=FFX_Segnato(MathRound(score),0);", "   string num=FFX_Segnato(score,0);"),
    ("ALIGN e DIVERGE scambiati", "   if(e>0) return \"ALIGN\";\n   if(e<0) return \"DIVERGE\";", "   if(e<0) return \"ALIGN\";\n   if(e>0) return \"DIVERGE\";"),
    ("copertura sempre piena", "      if(st[k]!=FFX_S_ND) cov++;", "      cov++;"),
    ("denominatori sempre uguali", "      if(den[v]!=den[0]) uguali=false;", ""),
    ("filtro sulla riga invece che sulla valuta", "   int v=ord[riga];", "   int v=riga;"),
    ("correlazioni non collegate", "      if(sanCoppia[i]>=0 && sanCoppia[i]<ns) coppiaSan[sanCoppia[i]]=i;", "      if(false) coppiaSan[0]=i;"),
    ("ID: meta' scambiate", "   hi=(double)(u/b);\n   lo=(double)(u%b);", "   lo=(double)(u/b);\n   hi=(double)(u%b);"),
    ("diagnosi: ultime coppie perse", "   return (nr>=perRiga || s==ns-1);", "   return (nr>=perRiga);"),
    ("zero negativo stampato '+-0'", "   double y=x+0.0;\n   string s=DoubleToString(y,dg);\n   if(StringSubstr(s,0,1)!=\"-\") s=\"+\"+s;",
     "   string s=DoubleToString(x,dg);\n   if(x>=0.0) s=\"+\"+s;"),
    # cancello indipendente 02/10 (giro cieco, era VERDE): guardia base == quotata nella forza
    ("[cieco] forza: coppia con base == quotata accettata", "      if(b<0 || q<0 || b==q) continue;", "      if(b<0 || q<0) continue;"),
    ("[cieco] ordine stati: fail su prima della rottura giu'", "   if(c<l1) return FFX_S_DNBRK;\n   bool fu=(h0>h1);",
     "   if(h0>h1 && c<l1) return FFX_S_FAILUP;\n   if(c<l1) return FFX_S_DNBRK;\n   bool fu=(h0>h1);"),
]


def mutants(src, quick):
    print("\n== M) mutanti sul sorgente vero (devono essere TUTTI presi)")
    blk = pure_block(src)
    bars = None
    if os.path.exists(DATI):
        d0 = calendar.timegm((2024, 6, 3, 0, 0, 0))
        bars = load_m1(DATI, d0 - 40 * 86400, calendar.timegm((2024, 6, 19, 0, 0, 0)))
        ref = reference_states(bars, True)
        refc = [r for r in ref if r[1] == 3]
    presi = 0
    for lab, old, new in MUTANTS:
        if blk.count(old) != 1:
            check(False, "mutante '%s': testo da mutare non trovato una volta sola nel blocco puro (%d)" % (lab, blk.count(old)))
            continue
        msrc = src.replace(old, new, 1)
        with tempfile.TemporaryDirectory() as tmp:
            cx = Cxx(msrc, tmp)
            if not cx.ok:
                check(False, "mutante '%s' non compila: %s" % (lab, cx.err[:300]))
                continue
            bad = battery(cx, random.Random(7), True, verbose=False)
            sim_bad = 0
            if bars is not None:
                st, end, car = sim(cx, bars, 0, 0, 9, 0, True)
                sim_bad += sum(1 for a, r in zip(st, ref) if a[2] != r[2]) + (len(st) != len(ref))
                stc, _, _ = sim(cx, bars, 1, 1, 9, 0, True)
                sim_bad += sum(1 for a, r in zip([a for a in stc if a[1] == 3], refc) if a[2] != r[2])
                stl, _, _ = sim(cx, bars, 0, 0, 2, 1, True)
                seen = [False] * 9
                for a in stl:
                    for k in range(9):
                        if a[2][k] != ND:
                            seen[k] = True
                        elif seen[k]:
                            sim_bad += 1
            tot = bad + sim_bad
            if tot > 0:
                presi += 1
            check(tot > 0, "mutante PRESO: %s (batteria %d, simulazione %d)" % (lab, bad, sim_bad))
    # mutanti delle ancore: devono far cadere un controllo statico
    for lab, old, new in ANCHOR_MUTANTS:
        if src.count(old) != 1:
            check(False, "mutante d'ancora '%s': testo non trovato una volta sola (%d)" % (lab, src.count(old)))
            continue
        before = len(FAILS)
        import io
        import contextlib
        buf = io.StringIO()
        with contextlib.redirect_stdout(buf):
            static_checks(src.replace(old, new, 1))
        nuovi = FAILS[before:]
        del FAILS[before:]
        check(len(nuovi) > 0, "mutante d'ancora PRESO dallo statico: %s (%d controlli caduti)" % (lab, len(nuovi)))
    print("  (%d/%d mutanti del blocco puro presi)" % (presi, len(MUTANTS)))


# residuo DICHIARATO (classe 1068): mutanti sul raccordo di sola resa a video / UX che nessun controllo
# fuori dal terminale prende. Si eseguono e si CONTANO (non fanno fallire): sono coperti solo dalla
# prova a mano della nota (docs/FORZA_FX_NOTE.md par. 3). Se uno diventa preso, meglio.
RESIDUO = [
    ("decimali dei prezzi nel tooltip fissi", "      gDig[s]=(int)SymbolInfoInteger(gSym[s],SYMBOL_DIGITS);\n      gBid[s]=0.0;", "      gDig[s]=5;\n      gBid[s]=0.0;"),
    ("correzioni M1 tutte nello stesso secondo all'avvio", "      gCorrNext[s]=OraMs()+(long)(s%60)*1000;", "      gCorrNext[s]=OraMs();"),
    ("tooltip non riscritto dopo il caricamento", "   gCT[k]=\"#init#\";            // tooltip", "   //gCT[k]=\"#init#\";            // tooltip"),
    ("valuta filtrata non evidenziata", "      string lab=(v==gFiltro) ? \"[\"+FFX_VAL[v]+\"]\" : FFX_VAL[v];", "      string lab=FFX_VAL[v];"),
    ("celle mai rimpicciolite su un grafico basso", "      if(st2<step) { step=st2; cell=step-2; }", ""),
    ("DPI sotto 96 accettati", "   if(gK<1.0) gK=1.0;", ""),
    ("ridisegno a ogni scorrimento del grafico", "      if(Layout()) { gDirty=true; ChartRedraw(0); }", "      Layout(); gDirty=true; ChartRedraw(0);"),
    ("grafico di lettura cambiato anche se gia' giusto", "      if(ChartSymbol(id)!=sym || ChartPeriod(id)!=tf)\n         if(", "      if(true)\n         if("),
    ("grafico di lettura non portato davanti", "      ChartSetInteger(id,CHART_BRING_TO_TOP,true);", ""),
    ("grafico con EA ancora ricordato come grafico di lettura (lo protegge comunque il controllo prima del riuso)",
     "      if(gVisore==gWatchId) { gVisore=0; SalvaVisore(); }", ""),
    # residuo dei giri ciechi 3 e 4 del cancello indipendente (02/10): equivalenti o di solo testo/tooltip
    ("[cancello, equivalente] tick senza controllo del bid (lo filtra FFX_PassoTick)", "      if(SymbolInfoTick(gSym[s],tk) && tk.bid>0.0)", "      if(SymbolInfoTick(gSym[s],tk))"),
    ("[cancello, equivalente] visore ripreso anche se e' il grafico stesso (lo esclude ApriGrafico)",
     "   if(!GraficoEsiste(gVisore) || gVisore==ChartID()) gVisore=0;", "   if(!GraficoEsiste(gVisore)) gVisore=0;"),
    ("[cancello] righe filtrate lasciano un buco", "      if(v) row++;", "      row++;"),
    ("[cancello] click sul titolo senza diagnosi", "   if(azione==6) { DiagStampa(\"click sul titolo\"); return; }", "   if(azione==6) { return; }"),
    ("[cancello] testo della correlazione col segno atteso invertito", "(gSanSegno[i]>0 ? \"(+)\" : \"(-)\")", "(gSanSegno[i]<0 ? \"(+)\" : \"(-)\")"),
    ("[cancello] tooltip: apertura presa dal massimo", "l'apertura \"+Px(s,gO0[k])+", "l'apertura \"+Px(s,gH0[k])+"),
    ("[cancello] colore del segnale invertito", "         col=ColoreEtichetta(e);", "         col=ColoreEtichetta(-e);"),
    ("[cancello] tooltip D1 'salto weekend' anche a input spento", "      if(c==FFX_IDX_D1 && InpD1SaltaWeekend) t+=", "      if(c==FFX_IDX_D1) t+="),
]


def residuo(src):
    import io
    import contextlib
    print("\n== RESIDUO dichiarato del raccordo (classe 1068): resa a video / UX, NON PROVATO fuori dal terminale")
    verdi = 0
    for lab, old, new in RESIDUO:
        if src.count(old) != 1:
            print("  info testo non trovato (riga cambiata?): %s" % lab)
            continue
        before = len(FAILS)
        with contextlib.redirect_stdout(io.StringIO()):
            static_checks(src.replace(old, new, 1))
        k = len(FAILS) - before
        del FAILS[before:]
        verdi += (k == 0)
        print("  %s %s" % ("verde" if k == 0 else "preso", lab))
    print("  info: %d/%d verdi -> coperti SOLO dalla prova a mano (nota par. 3)" % (verdi, len(RESIDUO)))


# ===========================================================================
# --diag: ricalcolo delle forze dalle righe del Journal
# ===========================================================================
def diag_ricalcola(testo):
    """ritorna una lista di (ok, messaggio) per ogni blocco di diagnosi trovato nel testo."""
    blocchi = []
    cur = None
    for line in testo.splitlines():
        i = line.find("[ForzaFX diag]")
        if i < 0:
            continue
        body = line[i + len("[ForzaFX diag]"):].strip()
        if body.startswith("motivo="):
            cur = {"pesi": None, "celle": [], "forze": None, "somma": None}
            blocchi.append(cur)
            m = re.search(r"\| pesi (.*?) \(somma", body)
            if m:
                cur["pesi"] = {k: float(v) for k, v in re.findall(r"(\w+)=([\d.]+)", m.group(1))}
        elif cur is None:
            continue
        elif body.startswith("celle "):
            for nome, vals in re.findall(r"(\w+)\[([^\]]*)\]", body):
                cur["celle"].append((nome, vals.split(",")))
        elif body.startswith("forze "):
            cur["forze"] = {v: (float(n), float(d), float(f)) for v, n, d, f in
                            re.findall(r"(\w{3}) num=([+-][\d.]+) den=([\d.]+) forza=([+-][\d.]+)", body)}
        elif body.startswith("somma forze="):
            cur["somma"] = body
    esiti = []
    for b in blocchi:
        if not b["pesi"] or not b["celle"] or not b["forze"]:
            esiti.append((False, "blocco incompleto (servono le righe motivo/celle/forze)"))
            continue
        peso = [b["pesi"].get(t, 0.0) for t in TFN]
        num = {v: 0.0 for v in VAL}
        den = {v: 0.0 for v in VAL}
        for nome, vals in b["celle"]:
            bb, qq = nome[:3], nome[3:6]
            if bb not in VAL or qq not in VAL:
                continue
            for c, x in enumerate(vals):
                if x == "?" or peso[c] <= 0:
                    continue
                v = float(x)
                num[bb] += v * peso[c]
                num[qq] -= v * peso[c]
                den[bb] += 2 * peso[c]
                den[qq] += 2 * peso[c]
        diffs = []
        for v in VAL:
            f = num[v] / den[v] if den[v] else 0.0
            pn, pd, pf = b["forze"].get(v, (None, None, None))
            if pf is None or abs(pf - f) > 6e-5 or abs(pd - den[v]) > 0.006 or abs(pn - num[v]) > 0.006:
                diffs.append("%s stampata %s ricalcolata %+.4f" % (v, pf, f))
        somma = sum(num[v] / den[v] if den[v] else 0.0 for v in VAL)
        esiti.append((not diffs, ("forze ricalcolate dalle %d coppie: %s; somma %+.6f, denominatori %s" %
                                  (len(b["celle"]), "TUTTE uguali alle stampate" if not diffs else "DIVERSE: " + "; ".join(diffs),
                                   somma, "uguali" if len(set(den.values())) == 1 else "diversi"))))
    return esiti


def diag_selftest(cx, rng):
    """genera righe di diagnosi con le funzioni VERE (riga celle) e la formattazione del sorgente, poi le ricalcola."""
    st = [rnd_state(rng, 0.05) for _ in range(28 * NTF)]
    base, quot = bq(COPPIE28)
    num, den, fz, _ = parse_forza(cx.run(forza_cmd(COPPIE28, st, [float(p) for p in PESI]))[0])
    righe = cx.run("".join("RIGA %s %s\n" % (n, " ".join(map(str, st[i * NTF:(i + 1) * NTF]))) for i, n in enumerate(COPPIE28)))
    segn = cx.run("".join("SEGN %r 2\nSEGN %r 4\n" % (num[k], fz[k]) for k in range(8)))
    pre = "2026.10.02 10:15:00.123\tABTG_ForzaFX_Dashboard (EURUSD,H1)\t[ForzaFX diag] "
    t = pre + "motivo=prova ora server 2026.10.02 10:15:00 | TF M1,M5,M15,M30,H1,H4,D1,W1,MN | pesi M1=1 M5=1 M15=2 M30=3 H1=4 H4=6 D1=10 W1=15 MN=20 (somma 62) | copertura 250/252 | CopyRates 0\n"
    for i in range(0, 28, 7):
        t += pre + "celle " + " ".join(righe[i:i + 7]) + "\n"
    t += pre + "forze " + " | ".join("%s num=%s den=%.2f forza=%s" % (VAL[k], segn[2 * k], den[k], segn[2 * k + 1]) for k in range(8)) + "\n"
    t += pre + "somma forze=+0.000000 denominatori uguali=no\n"
    es = diag_ricalcola(t)
    check(len(es) == 1 and es[0][0], "--diag: righe generate con le funzioni vere, rilette e RICALCOLATE: %s" % (es[0][1] if es else "nessun blocco"))
    # controesempio: una forza stampata alterata DEVE essere segnalata
    t2 = t.replace("forza=" + segn[1], "forza=" + ("+0.9999" if segn[1] != "+0.9999" else "-0.9999"), 1)
    es2 = diag_ricalcola(t2)
    check(len(es2) == 1 and not es2[0][0], "--diag: una forza stampata ALTERATA viene segnalata (caso che deve scattare)")


# ===========================================================================
def main():
    if "--diag" in sys.argv:
        i = sys.argv.index("--diag")
        if i + 1 >= len(sys.argv):
            print("uso: --diag file.txt")
            return 2
        esiti = diag_ricalcola(read(sys.argv[i + 1]))
        if not esiti:
            print("nessuna riga '[ForzaFX diag]' trovata")
            return 1
        for k, (ok, msg) in enumerate(esiti):
            print("blocco %d: %s %s" % (k + 1, "OK" if ok else "DIVERSO", msg))
        return 0 if all(ok for ok, _ in esiti) else 1
    src = read(SRC)
    static_checks(src)
    print("\n== C) funzioni pure vere compilate in C++ contro specchio e riferimenti")
    with tempfile.TemporaryDirectory() as tmp:
        cx = Cxx(src, tmp)
        check(cx.ok, "blocco puro estratto dal .mq5 compila in C++ con -Wall -Wshadow%s" % ("" if cx.ok else ": " + cx.err[:600]))
        check(cx.ok and "warning" not in cx.err, "nessun avviso del compilatore C++ sul blocco puro (%s)" % cx.err[:300].replace("\n", " "))
        if cx.ok:
            battery(cx, random.Random(20261002), RAPIDO)
            diag_selftest(cx, random.Random(3))
            real_data(cx, RAPIDO)
    if cx.ok:
        mutants(src, RAPIDO)
    residuo(src)
    print("\n== ESITO: %s (%d controlli falliti)" % ("PASS" if not FAILS else "FAIL", len(FAILS)))
    for f in FAILS:
        print("   - " + f)
    return 0 if not FAILS else 1


if __name__ == "__main__":
    sys.exit(main())
