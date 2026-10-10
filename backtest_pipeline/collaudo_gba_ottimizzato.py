#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Collaudo STATICO di mql5/Experts/ABTG_GoldBreakoutATR_Ottimizzato.mq5 (v1.20) CONTRO l'originale
mql5/Experts/ABTG_GoldBreakoutATR.mq5 (v1.10, SHA 1381e3dc...). BOZZA, NON passata dal cancello.

La domanda a cui risponde: "con TUTTI i default, la v1.20 si comporta IDENTICA alla v1.10?"
Qui NON c'e' MetaEditor: niente compila l'MQL5, niente gira nel tester. Si prova a tavolino:

  O) l'originale e' ancora la v1.10 congelata (SHA256 1381e3dc...): la base del confronto non si e' mossa.
  D) DIFF: le righe dell'originale sono una SOTTOSEQUENZA delle righe della v1.20, a meno di 4 sostituzioni
     dichiarate (intestazione col nome del file, #property version, magic, stringa "AVVIO v1.x"). Cioe':
     nessuna riga dell'originale tolta, spostata o cambiata fuori da quelle 4; tutto il resto e' AGGIUNTO.
  I) INPUT: stessi nomi/tipi/default dell'originale (tranne InpMagic) + ESATTAMENTE i 4 nuovi, con le soglie a
     0.0 (= spento) e i pin del dossier (M15, 14); magic nuovo fuori dal blocco 7758xx e assente dal repo.
  T) TRADING: nessuna chiamata di trading / rete nuova (conteggio per funzione identico), nessuna funzione nuova
     che ne contenga.
  G) GUARDIA: ogni uso dei nuovi input, handle, stato e funzioni sta dentro un blocco aperto da una guardia
     ammessa (if(GbaMomentoAcceso()) / if(InpRsiMinAligned > 0.0) / if(InpStochMinAligned > 0.0), con
     eventuale "dir != 0 &&"), oppure in una forma inerte elencata per nome (dichiarazione, validazione in
     OnInit, rilascio in OnDeinit, log di avvio in sola lettura). GbaMomentoAcceso e' controllata alla lettera.
     Gli handle si leggono SOLO sotto la propria soglia; si creano SOLO sotto la propria soglia; si rilasciano.
  L) LOOK-AHEAD: ogni lettura di RSI/Stocastico usa come shift esattamente GbaShiftChiusa(g_tfMom, t0)
     (la barra CHIUSA, la stessa funzione v1.10 di EMA e ATR), e GbaLeggiMomento riceve il t0 della barra.
  A) AGGIUNTE: ogni riga aggiunta (non commento, non vuota) sta sotto guardia, in una funzione NUOVA o in una
     forma inerte elencata per nome. Senza questo strato una riga nuova che non usa identificatori nuovi (es.
     "g_lastBar = 0;" in OnTick, o un filtro estraneo in GbaApri) passerebbe D, G e T (mutanti M28-M32).
     L'ambiguita' del diff (due "}" uguali) si risolve facendo scorrere il blocco fra posizioni equivalenti.
  B) BLOCCO nella colla (GbaNuovaBarra): uno solo, DOPO GbaDecidi e PRIMA del primo return; tocca solo
     motivo = GBA_MOMENTO e dir = 0 (piu' i propri locali e contatori); GBA_MOMENTO resta fuori da g_conta[].
  V) versione 1.20, log [GBA] di avvio con i 4 input nuovi, segnaposto == argomenti nei Print/StringFormat.
  P) FUNZIONE PURA GbaMomentoOk estratta dal .mq5 e compilata in C++ (g++ -Wall): soglia 0 passa SEMPRE
     (20.000 casi); con soglia accesa coincide con lo SPECCHIO PYTHON scritto dalla regola del dossier
     (BUY valore >= soglia, SELL 100 - valore >= soglia) su 40.000 casi sulla griglia 0,01 + bordi; e
     l'autotest dell'EA GbaAutotestMomento compilato da' 0 casi falliti.
  M) MUTANTI (contro-esempi) applicati a copie in memoria: default non neutro, filtro che gira da spento,
     guardia >= 0, shift 0 e shift della barra in formazione, handle creato sempre / non rilasciato / letto
     sotto la soglia sbagliata, chiamata di trading nuova, riga v1.10 cambiata, non-ASCII, funzione pura non
     neutra o non specchiata, magic dell'originale, motivo sbagliato, GBA_MOMENTO dentro g_conta[], input usato
     fuori guardia, log senza input, versione vecchia, pin cambiato, originale modificato. Ognuno DEVE essere
     preso; i mutanti di LOGICA della funzione pura devono essere presi dallo strato P (comportamento).

Uso:   python3 backtest_pipeline/collaudo_gba_ottimizzato.py [--senza-mutanti]
Esce con 0 solo se tutto passa.

NON PROVATO (dichiarato): la COMPILAZIONE MQL5 vera (MetaEditor assente: tipi, firme di iRSI/iStochastic,
overload, avvisi); i VALORI NUMERICI delle costanti ENUM_TIMEFRAMES (PERIOD_M15 ecc.) e di MODE_SMA /
STO_LOWHIGH / PRICE_CLOSE: si controlla il NOME, non il numero; il comportamento di iRSI/iStochastic del
terminale (Wilder, K lento) e che i loro buffer siano popolati nel tester su M15 (gate G0 del dossier);
la colla GbaNuovaBarra NON e' eseguita (solo la forma del blocco e' controllata); nessun tick, nessun
backtest. "Neutro" qui vuol dire: con i default nessuna riga nuova cambia stato, ordini o log di trading
della v1.10, a meno di riordini di righe di LOG (la riga [GBA] MOMENTO di avvio e' in piu').
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
sys.path.insert(0, os.path.join(ROOT, "backtest_pipeline"))
from collaudo_gba import maschera, funzioni, inputs, conta_segnaposto, chiusa, argomenti  # noqa: E402

ORIG = os.path.join(ROOT, "mql5/Experts/ABTG_GoldBreakoutATR.mq5")
NUOVO = os.path.join(ROOT, "mql5/Experts/ABTG_GoldBreakoutATR_Ottimizzato.mq5")
SHA_ORIG = "1381e3dc9b4b4e44bcdc0319f023cb1990900ce0d1a6b6a3ec1df5df99e601b1"
PROPRI = {"mql5/Experts/ABTG_GoldBreakoutATR_Ottimizzato.mq5", "backtest_pipeline/collaudo_gba_ottimizzato.py"}
SENZA_MUTANTI = "--senza-mutanti" in sys.argv

INPUT_NUOVI = {
    "InpRsiMinAligned": ("double", "0.0"),
    "InpMomTF": ("ENUM_TIMEFRAMES", "PERIOD_M15"),
    "InpMomPeriod": ("int", "14"),
    "InpStochMinAligned": ("double", "0.0"),
}
STATO_NUOVO = ["g_tfMom", "g_hRsi", "g_hSto", "g_contaMomento", "g_contaMomDati", "g_momStampato"]
# funzioni nuove il cui CORPO e' codice del filtro: le loro chiamate devono stare sotto guardia
FUNZ_SOTTO_GUARDIA = ["GbaLeggiMomento", "GbaLogMomento", "GbaStampaContaMomento", "GbaMomTesto"]
FUNZ_NUOVE_ATTESE = {"GbaMomentoOk", "GbaMomentoAcceso", "GbaLeggiMomento", "GbaMomTesto", "GbaLogMomento",
                     "GbaStampaContaMomento", "GbaAutotestMomento"}
IDENT_NUOVI = list(INPUT_NUOVI) + STATO_NUOVO + FUNZ_SOTTO_GUARDIA
GUARDIA = re.compile(r"^if\((?:dir != 0 && )?(?:GbaMomentoAcceso\(\)|InpRsiMinAligned > 0\.0|"
                     r"InpStochMinAligned > 0\.0)\)$")
TRADING = re.compile(r"\btrade\s*\.\s*\w+\s*\(|\bOrderSend(?:Async)?\b|\bOrderModify\b|\bOrderDelete\b|"
                     r"\bPositionClose(?:Partial|By)?\b|\bPositionModify\b|\bWebRequest\b|\bSendMail\b|"
                     r"\bSendNotification\b|\bSendFTP\b|#import\b|#include\b|\bABTG_GuardiaIngresso\b")
_CACHE_GREP = {}


def norm(s):
    return re.sub(r"\s+", " ", s).strip()


class Esito:
    def __init__(self, quiet=False):
        self.quiet, self.fails, self.n = quiet, [], 0

    def check(self, cond, msg, strato):
        self.n += 1
        if not self.quiet:
            print(("  ok   " if cond else "  FAIL ") + "[%s] %s" % (strato, msg))
        if not cond:
            self.fails.append((strato, msg))
        return cond


# ===========================================================================
# struttura del sorgente: blocchi { } con la loro intestazione, funzioni
# ===========================================================================
def blocchi(code):
    """lista di (apre, chiude, intestazione_normalizzata, profondita') per ogni { } del codice mascherato."""
    out, pila, ultimo = [], [], 0
    for i, ch in enumerate(code):
        if ch in ";{}":
            if ch == "{":
                pila.append((i, norm(code[ultimo:i]), len(pila)))
            elif ch == "}" and pila:
                a, h, d = pila.pop()
                out.append((a, i, h, d))
            ultimo = i + 1
    return out


def funzioni_span(code, bl):
    """nome -> (apre, chiude) delle funzioni a profondita' 0."""
    out = {}
    for a, c, h, d in bl:
        if d != 0:
            continue
        m = re.search(r"(\w+)\s*\([^{}]*\)\s*$", h)
        if m and "=" not in h.split("(")[0]:
            out[m.group(1)] = (a, c)
    return out


def contesto(pos, bl, fsp):
    """(funzione che contiene pos o None, intestazioni dei blocchi che contengono pos dal piu' esterno)."""
    f = None
    for nome, (a, c) in fsp.items():
        if a < pos < c:
            f = nome
    hs = [h for a, c, h, d in sorted(bl, key=lambda x: x[0]) if a < pos < c]
    return f, hs


def riga_di(src, pos):
    i = src.rfind("\n", 0, pos) + 1
    j = src.find("\n", pos)
    return src[i:j if j >= 0 else len(src)]


def chiamate(code, nome):
    """(pos_nome, [testo degli argomenti]) per ogni chiamata nome(...) nel codice mascherato."""
    out = []
    for m in re.finditer(r"\b%s\s*\(" % re.escape(nome), code):
        i = code.index("(", m.start())
        j = chiusa(code, i)
        if j < 0:
            continue
        out.append((m.start(), [norm(code[a:b]) for a, b in argomenti(code, i, j)]))
    return out


def grep_repo(pattern):
    if pattern in _CACHE_GREP:
        return _CACHE_GREP[pattern]
    r = subprocess.run(["git", "grep", "-lE", "--untracked", pattern], cwd=ROOT, capture_output=True, text=True)
    altri = []
    for x in sorted(set(x for x in r.stdout.split("\n") if x.strip()) - PROPRI):
        try:
            with open(os.path.join(ROOT, x), "rb") as f:
                if b"ABTG_GoldBreakoutATR_Ottimizzato" in f.read():
                    continue
        except OSError:
            pass
        altri.append(x)
    _CACHE_GREP[pattern] = altri
    return altri


# ===========================================================================
# strati O, D, I, T, G, L, B, V (statici)
# ===========================================================================
def statico(raw_new, raw_orig, E):
    # --- O: la base del confronto
    E.check(hashlib.sha256(raw_orig).hexdigest() == SHA_ORIG,
            "originale v1.10 intatto (SHA256 1381e3dc...)", "O")
    try:
        src = raw_new.decode("ascii")
        ascii_ok = True
    except UnicodeDecodeError:
        src = raw_new.decode("latin-1")
        ascii_ok = False
    E.check(ascii_ok, "v1.20 in ASCII puro", "V")
    E.check("\r" not in src, "v1.20 fine riga LF", "V")
    orig = raw_orig.decode("latin-1")
    code, ocode = maschera(src), maschera(orig)
    for a, b in ("()", "[]", "{}"):
        E.check(code.count(a) == code.count(b), "parentesi %s%s bilanciate" % (a, b), "V")

    # --- D: le righe dell'originale sono una sottosequenza delle nuove, a meno di 4 sostituzioni dichiarate
    nl, ol = src.split("\n"), orig.split("\n")
    mag = re.search(r"(?m)^input long   InpMagic       = (\d+);", src)
    sost = {
        "//|                                          ABTG_GoldBreakoutATR.mq5 |":
            lambda x: "ABTG_GoldBreakoutATR_Ottimizzato.mq5" in x and x.startswith("//|"),
        '#property version   "1.10"': lambda x: x == '#property version   "1.20"',
        "input long   InpMagic       = 775800; // Magic Number":
            lambda x: bool(re.match(r"^input long   InpMagic       = \d+; // Magic Number", x)),
    }
    avvio = [x for x in ol if '"[GBA] AVVIO v1.10 |' in x]
    if len(avvio) == 1:
        sost[avvio[0]] = lambda x, a=avvio[0]: x == a.replace("AVVIO v1.10", "AVVIO v1.20")
    j, mancanti, sostituite, ot = 0, [], 0, list(ol)
    for k, riga in enumerate(ol):
        prova = sost.get(riga)
        trovata = False
        while j < len(nl):
            if (prova is None and nl[j] == riga) or (prova is not None and prova(nl[j])):
                trovata = True
                sostituite += prova is not None
                ot[k] = nl[j]   # originale "trasformato": le 4 sostituzioni dichiarate gia' applicate
                j += 1
                break
            j += 1
        if not trovata:
            mancanti.append("r.%d: %s" % (k + 1, riga.strip()[:70]))
            break
    E.check(not mancanti, "DIFF: ogni riga v1.10 c'e', nello stesso ordine (sottosequenza) %s" % mancanti[:2], "D")
    E.check(sostituite == 4, "DIFF: esattamente le 4 sostituzioni dichiarate (nome file, versione, magic, "
                             "AVVIO) -- trovate %d" % sostituite, "D")
    E.check(len(nl) > len(ol), "DIFF: %d righe aggiunte, 0 tolte" % (len(nl) - len(ol)), "D")

    # --- I: input
    io, inn = inputs(orig), inputs(src)
    diversi = [k for k in io if k != "InpMagic" and inn.get(k) != io[k]]
    E.check(not diversi, "INPUT: tutti gli input v1.10 identici per tipo e default (tranne InpMagic) %s"
            % diversi, "I")
    nuovi = {k: v for k, v in inn.items() if k not in io}
    E.check(nuovi == INPUT_NUOVI, "INPUT: nuovi = esattamente %s con default neutri/pin; trovati %s"
            % (sorted(INPUT_NUOVI), nuovi), "I")
    E.check(all(float(inn.get(k, ("", "1"))[1]) == 0.0 for k in ("InpRsiMinAligned", "InpStochMinAligned")),
            "INPUT: le due soglie hanno default 0.0 (= filtro SPENTO)", "I")
    mval = mag.group(1) if mag else ""
    E.check(mag is not None and mval != "775800" and not mval.startswith("7758") and len(mval) == 6,
            "MAGIC: default %s diverso da 775800 e fuori dal blocco 7758xx (driver R0)" % mval, "I")
    if mag:
        altri = grep_repo(r"(^|[^0-9])%s([^0-9]|$)" % mval)
        E.check(not altri, "MAGIC: %s assente dal repo fuori dai file propri (git grep --untracked) %s"
                % (mval, altri[:3]), "I")
        altri = grep_repo(r"(^|[^0-9])%s[0-9]{2}([^0-9]|$)" % mval[:4])
        E.check(not altri, "MAGIC: blocco %sxx assente dal repo fuori dai file propri %s" % (mval[:4], altri[:3]), "I")

    # --- T: trading
    bl, obl = blocchi(code), blocchi(ocode)
    fsp, ofsp = funzioni_span(code, bl), funzioni_span(ocode, obl)

    def conta_trading(c, fs):
        out = {}
        for m in TRADING.finditer(c):
            f = None
            for nome, (a, b) in fs.items():
                if a < m.start() < b:
                    f = nome
            key = (f, norm(m.group(0)))
            out[key] = out.get(key, 0) + 1
        return out
    ct, oct_ = conta_trading(code, fsp), conta_trading(ocode, ofsp)
    E.check(ct == oct_, "TRADING: chiamate di trading/rete/include identiche per funzione (%d) %s"
            % (sum(ct.values()), sorted(set(ct.items()) ^ set(oct_.items()))[:3]), "T")
    fn_nuove = set(fsp) - set(ofsp)
    E.check(fn_nuove == FUNZ_NUOVE_ATTESE, "FUNZIONI nuove = esattamente %s; trovate %s"
            % (sorted(FUNZ_NUOVE_ATTESE), sorted(fn_nuove)), "T")
    E.check(set(ofsp) <= set(fsp), "FUNZIONI v1.10 tutte presenti", "T")

    # --- G: guardia
    fn = funzioni(src)
    corpo_acc = norm(maschera(fn.get("GbaMomentoAcceso", "")))
    E.check(corpo_acc == "bool GbaMomentoAcceso() { return (InpRsiMinAligned > 0.0 || InpStochMinAligned > 0.0); }",
            "GUARDIA: GbaMomentoAcceso() = (InpRsiMinAligned > 0.0 || InpStochMinAligned > 0.0), alla lettera", "G")
    corpo_ok = maschera(fn.get("GbaMomentoOk", ""))
    prima = re.search(r"\{\s*([^;]*;)", corpo_ok)
    E.check(prima is not None and norm(prima.group(1)) == "if(soglia <= 0.0) return true;",
            "GUARDIA: GbaMomentoOk comincia con if(soglia <= 0.0) return true; (spento = passa sempre)", "G")
    E.check(corpo_ok != "" and not re.search(r"\b(Inp\w+|g_\w+)\b", corpo_ok),
            "GUARDIA: GbaMomentoOk e' PURA (nessun input ne' globale)", "G")
    fuori = []
    for ident in IDENT_NUOVI:
        for m in re.finditer(r"\b%s\b" % ident, code):
            p = m.start()
            f, hs = contesto(p, bl, fsp)
            riga = norm(maschera(riga_di(src, p)))
            in_guardia = any(GUARDIA.match(h) for h in hs)
            # l'identificatore dentro l'INTESTAZIONE di una guardia ammessa (fra l'ultimo ; { } e la sua {)
            for a, c, h, d in bl:
                if GUARDIA.match(h) and max(code.rfind(";", 0, a), code.rfind("{", 0, a),
                                            code.rfind("}", 0, a)) < p < a:
                    in_guardia = True
            ok = False
            if f is None:
                ok = bool(re.match(r"^input\s", riga)) or bool(
                    re.match(r"^(int|bool|double|ENUM_TIMEFRAMES)\s+%s\s*=\s*[\w.\-]+;" % ident, riga)) or bool(
                    re.match(r"^(bool|void|string|int|double)\s+%s\s*\(" % ident, riga))
            elif f == "GbaMomentoAcceso":
                ok = ident in INPUT_NUOVI
            elif f in FUNZ_SOTTO_GUARDIA:
                ok = True   # corpo del filtro: le sue CHIAMATE sono controllate qui sotto; gli handle dalla regola H
            elif f == "GbaLogAvvio":
                ok = not re.search(r"\b%s\s*(=[^=]|\+\+|--|\+=|-=)" % ident, riga)
            elif f == "OnInit":
                # validazione: "if(...) err += "<testo>";" (nel mascherato il testo della stringa e' fatto di x)
                ok = in_guardia or bool(re.match(r'^if\([^;{}]*\) err \+= "x+";$', riga))
            elif f == "OnDeinit":
                ok = in_guardia or riga in (
                    "if(g_hRsi != INVALID_HANDLE) IndicatorRelease(g_hRsi);",
                    "if(g_hSto != INVALID_HANDLE) IndicatorRelease(g_hSto);",
                    "g_hRsi = INVALID_HANDLE;", "g_hSto = INVALID_HANDLE;")
            else:
                ok = in_guardia
            if not ok:
                fuori.append("%s in %s: %s" % (ident, f, riga[:60]))
    E.check(not fuori, "GUARDIA: ogni uso di input/stato/funzioni nuove e' sotto guardia o in forma inerte "
            "elencata %s" % fuori[:3], "G")
    # regola H: gli handle si toccano solo sotto la PROPRIA soglia (fuori dal rilascio in OnDeinit)
    hfuori = []
    for h, soglia in (("g_hRsi", "if(InpRsiMinAligned > 0.0)"), ("g_hSto", "if(InpStochMinAligned > 0.0)")):
        for m in re.finditer(r"\b%s\b" % h, code):
            f, hs = contesto(m.start(), bl, fsp)
            if f == "OnDeinit" and not hs[1:]:
                continue
            if f is None:
                continue
            if soglia not in hs:
                hfuori.append("%s in %s" % (h, f))
    E.check(not hfuori, "GUARDIA H: g_hRsi/g_hSto letti o creati SOLO sotto la propria soglia %s" % hfuori[:3], "G")
    # creazione e rilascio
    crsi, csto = chiamate(code, "iRSI"), chiamate(code, "iStochastic")
    E.check(len(crsi) == 1 and crsi[0][1] == ["g_sym", "g_tfMom", "InpMomPeriod", "PRICE_CLOSE"],
            "HANDLE: un solo iRSI(g_sym, g_tfMom, InpMomPeriod, PRICE_CLOSE)", "G")
    E.check(len(csto) == 1 and csto[0][1] == ["g_sym", "g_tfMom", "GBA_STOCH_K", "GBA_STOCH_D", "GBA_STOCH_SLOW",
                                              "MODE_SMA", "STO_LOWHIGH"],
            "HANDLE: un solo iStochastic(g_sym, g_tfMom, K, D, slow, MODE_SMA, STO_LOWHIGH)", "G")
    defs = dict(re.findall(r"(?m)^#define (GBA_STOCH_\w+)\s+(\d+)\s*$", src))
    E.check(defs == {"GBA_STOCH_K": "14", "GBA_STOCH_D": "3", "GBA_STOCH_SLOW": "3"},
            "HANDLE: Stocastico (14,3,3) come i pin del dossier ST5", "G")
    for c_, nome in ((crsi, "iRSI"), (csto, "iStochastic")):
        if c_:
            f, hs = contesto(c_[0][0], bl, fsp)
            E.check(f == "OnInit" and "if(GbaMomentoAcceso())" in hs,
                    "HANDLE: %s creato in OnInit SOLO dentro if(GbaMomentoAcceso())" % nome, "G")
    dein = norm(maschera(fn.get("OnDeinit", "")))
    for h in ("g_hRsi", "g_hSto"):
        E.check("if(%s != INVALID_HANDLE) IndicatorRelease(%s);" % (h, h) in dein and "%s = INVALID_HANDLE;" % h in dein,
                "HANDLE: %s rilasciato e azzerato in OnDeinit" % h, "G")
    # chiamate delle funzioni-filtro: sotto guardia o dentro un'altra funzione-filtro
    cfuori = []
    for nome in FUNZ_SOTTO_GUARDIA:
        for p, _ in chiamate(code, nome):
            if re.match(r"^(bool|void|string|int|double)\s+%s\s*\(" % nome, norm(riga_di(code, p))):
                continue
            f, hs = contesto(p, bl, fsp)
            if not (f in FUNZ_SOTTO_GUARDIA or any(GUARDIA.match(h) for h in hs)):
                cfuori.append("%s chiamata in %s" % (nome, f))
    E.check(not cfuori, "GUARDIA: le funzioni del filtro si chiamano solo sotto guardia %s" % cfuori[:3], "G")

    # --- L: look-ahead
    letture = [(h, args) for nome in ("GbaLeggiBuffer", "CopyBuffer") for p, args in chiamate(code, nome)
               for h in ("g_hRsi", "g_hSto") if args and args[0] == h]
    E.check(len(letture) == 2 and all(a[1] == "GbaShiftChiusa(g_tfMom, t0)" for _, a in letture),
            "LOOK-AHEAD: RSI e Stocastico letti una volta ciascuno con shift GbaShiftChiusa(g_tfMom, t0) %s"
            % [(h, a[1]) for h, a in letture], "L")
    lm = chiamate(code, "GbaLeggiMomento")
    lm = [a for p, a in lm if not re.match(r"^bool\s+GbaLeggiMomento\s*\(", norm(riga_di(code, p)))]
    E.check(len(lm) == 1 and lm[0][0] == "t0", "LOOK-AHEAD: GbaLeggiMomento chiamata una volta col t0 della barra", "L")
    sc_o, sc_n = maschera(funzioni(orig).get("GbaShiftChiusa", "")), maschera(fn.get("GbaShiftChiusa", ""))
    E.check(sc_o != "" and sc_o == sc_n, "LOOK-AHEAD: GbaShiftChiusa identica alla v1.10 (barra chiusa = shift + 1)", "L")

    # --- B: il blocco nella colla
    nb = fn.get("GbaNuovaBarra", "")
    nbc = maschera(nb)
    g = [m.start() for m in re.finditer(r"if\(dir != 0 && GbaMomentoAcceso\(\)\)", nbc)]
    i_dec = nbc.find("int dir = GbaDecidi(")
    i_ret = nbc.find("if(motivo == GBA_NO_SEGNALE) return;")
    E.check(len(g) == 1 and 0 <= i_dec < g[0] < i_ret,
            "BLOCCO: uno solo in GbaNuovaBarra, DOPO GbaDecidi e PRIMA di 'if(motivo == GBA_NO_SEGNALE) return;'", "B")
    if len(g) == 1:
        a = nbc.index("{", g[0])
        d, b = 0, -1
        for k in range(a, len(nbc)):
            d += nbc[k] == "{"
            d -= nbc[k] == "}"
            if d == 0:
                b = k
                break
        blk = nbc[a:b + 1]
        locali = {"momRsi", "momSto", "momBarra", "momLetto", "momOk"}
        cattive = []
        for m in re.finditer(r"\b(\w+)\s*(\+\+|--|\+=|-=|\*=|/=|=(?!=))\s*([^;]*);", blk):
            lhs, op, rhs = m.group(1), m.group(2), norm(m.group(3))
            if lhs in locali:
                continue
            if (lhs, op, rhs) in (("motivo", "=", "GBA_MOMENTO"), ("dir", "=", "0"), ("g_momStampato", "=", "true"),
                                  ("g_contaMomento", "++", ""), ("g_contaMomDati", "++", "")):
                continue
            cattive.append("%s %s %s" % (lhs, op, rhs))
        E.check(not cattive, "BLOCCO: assegna solo motivo = GBA_MOMENTO, dir = 0, i propri locali e contatori %s"
                % cattive[:3], "B")
        nblk = norm(blk)
        E.check("motivo = GBA_MOMENTO;" in nblk and "dir = 0;" in nblk and
                re.search(r"if\(!momOk\) \{[^}]*motivo = GBA_MOMENTO; dir = 0; \}", nblk) is not None,
                "BLOCCO: il rifiuto (motivo GBA_MOMENTO, dir 0) avviene solo dentro if(!momOk)", "B")
        E.check("momLetto && GbaMomentoOk(dir, momRsi, InpRsiMinAligned) && GbaMomentoOk(dir, momSto, "
                "InpStochMinAligned);" in nblk,
                "BLOCCO: momOk = lettura riuscita E RSI allineato E Stocastico allineato (fail-closed)", "B")
    dm = dict(re.findall(r"(?m)^#define (GBA_N_MOTIVI|GBA_MOMENTO)\s+(\d+)\s*$", src))
    E.check(dm.get("GBA_N_MOTIVI") == "9" and dm.get("GBA_MOMENTO") == "9",
            "BLOCCO: GBA_MOMENTO = GBA_N_MOTIVI = 9 (fuori da g_conta[]: la riga [GBA-CONTA] non cambia)", "B")
    E.check('if(m == GBA_MOMENTO)    return "momentum non allineato (v1.20)";' in fn.get("GbaMotivoTesto", ""),
            "BLOCCO: GbaMotivoTesto ha il testo del nuovo motivo", "B")

    # --- A: ogni riga AGGIUNTA (non commento, non vuota) e' inerte da spento. Senza questo strato una riga
    #     nuova che NON usa identificatori nuovi (es. "g_lastBar = 0;" in OnTick) passerebbe D, G e T.
    sm = difflib.SequenceMatcher(None, ot, nl, autojunk=False)
    offs, acc = [], 0
    for riga in nl:
        offs.append(acc)
        acc += len(riga) + 1
    nuove_span = {}
    for nome in FUNZ_NUOVE_ATTESE:
        if nome in fsp:
            a, c = fsp[nome]
            nuove_span[nome] = (max(code.rfind(";", 0, a), code.rfind("}", 0, a)) + 1, c)
    def cattive(righe):
        out = []
        for jj in righe:
            seg = code[offs[jj]:offs[jj] + len(nl[jj])]
            if not seg.strip():
                continue
            p = offs[jj] + len(seg) - len(seg.lstrip())
            if not _riga_inerte(code, p, bl, fsp, nuove_span):
                out.append("r.%d: %s" % (jj + 1, norm(nl[jj])[:60]))
        return out
    # Ambiguita' del diff: un blocco inserito [j1, j2) si puo' far SCORRERE di k righe se le righe che entrano e
    # quelle che escono sono uguali (tipico: la "}" di chiusura di una funzione nuova e di quella prima). Tutte
    # le posizioni scorrevoli sono testualmente lo STESSO diff: si prende quella che lo spiega meglio. Una riga
    # aggiunta estranea non ha posizioni equivalenti, quindi resta presa (mutanti M28-M31).
    aggiunte, non_inerti = [], []
    for tag, i1, i2, j1, j2 in sm.get_opcodes():
        if tag == "equal":
            continue
        cand = [(j1, j2)]
        if tag == "insert":
            k = 0
            while j2 + k < len(nl) and nl[j1 + k] == nl[j2 + k]:
                k += 1
                cand.append((j1 + k, j2 + k))
            k = 0
            while j1 - k - 1 >= 0 and nl[j1 - k - 1] == nl[j2 - k - 1]:
                k += 1
                cand.append((j1 - k, j2 - k))
        migliore = min((cattive(range(a, b)) for a, b in cand), key=len)
        aggiunte += range(j1, j2)
        non_inerti += migliore
    E.check(not non_inerti, "AGGIUNTE: %d righe aggiunte, ognuna sotto guardia, in una funzione nuova o in una forma "
            "inerte elencata %s" % (len(aggiunte), non_inerti[:3]), "A")

    # --- V: versione, log, segnaposto, autotest
    E.check('#property version   "1.20"' in src and "//  v1.20 " in src and '"[GBA] AVVIO v1.20 |' in src,
            "VERSIONE 1.20 in #property, changelog e log di avvio", "V")
    la = fn.get("GbaLogAvvio", "")
    E.check(all(("%s=" % k) in la for k in INPUT_NUOVI),
            "LOG: [GBA] di avvio stampa i 4 input nuovi (InpRsiMinAligned/InpMomTF/InpMomPeriod/InpStochMinAligned)", "V")
    male = []
    for nome in ("PrintFormat", "StringFormat"):
        for p, args in chiamate(code, nome):
            if not args:
                continue
            i = code.index("(", p)
            lits = re.findall(r'"((?:[^"\\]|\\.)*)"', _primo_argomento(src, code, i))
            n = conta_segnaposto("".join(lits))
            if n != len(args) - 1:
                male.append("%s r.%d: %d segnaposto, %d argomenti" % (nome, src.count("\n", 0, p) + 1, n, len(args) - 1))
    E.check(not male, "LOG: in ogni PrintFormat/StringFormat segnaposto == argomenti %s" % male[:3], "V")
    E.check("fall += GbaAutotestMomento();" in fn.get("AutoTestGba", ""),
            "AUTOTEST: AutoTestGba somma i casi di GbaAutotestMomento nel verdetto", "V")
    return src


def _istruzione(code, p):
    """l'istruzione che contiene p: dall'ultimo ; { } prima di p al primo ; o { dopo p (normalizzata)."""
    a = max(code.rfind(";", 0, p), code.rfind("{", 0, p), code.rfind("}", 0, p)) + 1
    fine = [x for x in (code.find(";", p), code.find("{", p)) if x >= 0]
    b = min(fine) if fine else len(code)
    return norm(code[a:b + 1])


def _riga_inerte(code, p, bl, fsp, nuove_span):
    """True se la riga aggiunta che comincia in p non puo' cambiare il comportamento con i default."""
    for nome, (a, c) in nuove_span.items():          # firma, corpo, graffe di una funzione NUOVA
        if a <= p <= c:
            return True
    f, hs = contesto(p, bl, fsp)
    ist = _istruzione(code, p)
    if f is None:                                    # ambito globale
        return bool(re.match(r"^#define GBA_(MOMENTO|STOCH_K|STOCH_D|STOCH_SLOW) \d+", norm(code[p:code.find("\n", p)]))
                    or re.match(r"^input ", ist)
                    or re.match(r"^(int|bool|double|ENUM_TIMEFRAMES) (%s) = [\w.\-]+;$" % "|".join(STATO_NUOVO), ist))
    if any(GUARDIA.match(h) for h in hs):            # dentro un blocco aperto da una guardia ammessa
        return True
    for a, c, h, d in bl:                            # la guardia stessa: intestazione, { e }
        if GUARDIA.match(h) and (p == a or p == c or (p < a and ";" not in code[p:a] and "}" not in code[p:a])):
            return True
    if f == "OnInit" and re.match(r'^if\([^;{}]*\) err \+= "x+";$', ist):
        return True
    if f == "OnDeinit" and ist in ("if(g_hRsi != INVALID_HANDLE) IndicatorRelease(g_hRsi);",
                                   "if(g_hSto != INVALID_HANDLE) IndicatorRelease(g_hSto);",
                                   "g_hRsi = INVALID_HANDLE;", "g_hSto = INVALID_HANDLE;"):
        return True
    if f == "GbaLogAvvio" and ist.startswith("PrintFormat(") and not re.search(r"[^=!<>]=[^=]", ist):
        return True
    if f == "GbaMotivoTesto" and re.match(r'^if\(m == GBA_MOMENTO\) return "x+";$', ist):
        return True
    if f == "AutoTestGba" and ist == "fall += GbaAutotestMomento();":
        return True
    return False


def _primo_argomento(src, code, i):
    j = chiusa(code, i)
    a, b = argomenti(code, i, j)[0]
    return src[a:b]


# ===========================================================================
# strato P: la funzione pura compilata in C++
# ===========================================================================
SHIM = r"""
#include <cstdio>
#include <string>
#include <iostream>
typedef std::string string;
static const bool InpVerbose = false;
#define PrintFormat(...) ((void)0)
"""
DRIVER = r"""
#include "shim.h"
#include "pure.h"
int main() {
  std::string cmd;
  while (std::cin >> cmd) {
    if (cmd == "MOM") { int d; double v, s; std::cin >> d >> v >> s; std::printf("%d\n", GbaMomentoOk(d, v, s) ? 1 : 0); }
    else if (cmd == "AUTO") { std::printf("%d\n", GbaAutotestMomento()); }
  }
  return 0;
}
"""


def py_mom(d, v, s):
    """SPECCHIO dalla regola del dossier (sez. 4.2): soglia 0 = spento; BUY v >= s; SELL 100 - v >= s."""
    if s <= 0.0:
        return True
    if d > 0:
        return v >= s
    if d < 0:
        return 100.0 - v >= s
    return False


def pura(src, E, tmp):
    cxx = shutil.which("g++") or shutil.which("clang++")
    if not E.check(cxx is not None, "C++: compilatore presente", "P"):
        return
    fn = funzioni(src)
    try:
        pure = "\n\n".join(fn[n] for n in ("GbaMomentoOk", "GbaCaso", "GbaAutotestMomento"))
    except KeyError as ex:
        E.check(False, "C++: estrazione fallita %s" % ex, "P")
        return
    for nm, txt in (("shim.h", SHIM), ("pure.h", pure), ("drv.cpp", DRIVER)):
        with open(os.path.join(tmp, nm), "w") as f:
            f.write(txt)
    exe = os.path.join(tmp, "drv")
    r = subprocess.run([cxx, "-std=c++17", "-O1", "-ffp-contract=off", "-Wall", "-Wno-unused-variable",
                        "-o", exe, os.path.join(tmp, "drv.cpp")], capture_output=True, text=True)
    if not E.check(r.returncode == 0, "C++: GbaMomentoOk + GbaCaso + GbaAutotestMomento compilano (g++ -Wall) %s"
                   % r.stderr[:200], "P"):
        return
    rnd = random.Random(20261010)
    casi = []
    for _ in range(20000):   # soglia SPENTA: qualunque valore, anche non letto, fuori scala o negativo
        casi.append((rnd.choice((-1, 1)), rnd.choice((-1.0, 0.0, 100.0, rnd.uniform(-50, 150))), 0.0))
    for _ in range(40000):   # soglia accesa, sulla griglia 0,01 per provocare i pareggi
        s = round(rnd.choice((60.0, 65.0, 70.0, 80.0, rnd.randint(1, 10000) / 100.0)), 2)
        v = round(rnd.choice((s, 100.0 - s, rnd.randint(0, 10000) / 100.0, s + 0.01, s - 0.01,
                              100.0 - s + 0.01, 100.0 - s - 0.01)), 2)
        casi.append((rnd.choice((-1, 0, 1)), v, s))
    casi += [(1, 60.0, 60.0), (1, 59.99, 60.0), (-1, 40.0, 60.0), (-1, 40.01, 60.0), (1, -1.0, 60.0),
             (-1, -1.0, 60.0), (0, 50.0, 60.0), (1, 100.0, 100.0), (-1, 0.0, 100.0), (1, 0.0, 1e-9)]
    inp = "".join("MOM %d %r %r\n" % c for c in casi) + "AUTO\n"
    out = subprocess.run([exe], input=inp, capture_output=True, text=True).stdout.split("\n")
    got = out[:len(casi)]
    spenti = [i for i, c in enumerate(casi) if c[2] == 0.0]
    E.check(all(got[i] == "1" for i in spenti),
            "PURA: soglia 0 = passa SEMPRE (%d casi, compresi valori non letti -1 e fuori scala)" % len(spenti), "P")
    diff = [casi[i] for i in range(len(casi)) if got[i] != ("1" if py_mom(*casi[i]) else "0")]
    E.check(not diff, "PURA: GbaMomentoOk == specchio dalla regola del dossier su %d casi %s" % (len(casi), diff[:3]),
            "P")
    E.check(len(out) > len(casi) and out[len(casi)] == "0",
            "PURA: l'autotest dell'EA GbaAutotestMomento da' 0 casi falliti (letto: %s)"
            % (out[len(casi)] if len(out) > len(casi) else "?"), "P")


def suite(raw_new, raw_orig, quiet=False):
    E = Esito(quiet)
    src = statico(raw_new, raw_orig, E)
    tmp = tempfile.mkdtemp(prefix="gbao_")
    try:
        pura(src, E, tmp)
    finally:
        shutil.rmtree(tmp, ignore_errors=True)
    return E


# ===========================================================================
# strato M: mutanti (contro-esempi). tipo "L" = logica della funzione pura: deve prenderlo lo strato P.
# ===========================================================================
MUTANTI = [
    ("M01", "default RSI non neutro (60)", "InpRsiMinAligned   = 0.0;", "InpRsiMinAligned   = 60.0;", "S"),
    ("M02", "default Stocastico non neutro (70)", "InpStochMinAligned = 0.0;", "InpStochMinAligned = 70.0;", "S"),
    ("M03", "filtro che gira anche da spento", "if(dir != 0 && GbaMomentoAcceso())", "if(dir != 0)", "S"),
    ("M04", "guardia >= 0 (default 0 = ACCESO)", "return (InpRsiMinAligned > 0.0 ||",
     "return (InpRsiMinAligned >= 0.0 ||", "S"),
    ("M05", "shift 0 (barra in formazione: look-ahead)", "GbaLeggiBuffer(g_hRsi, GbaShiftChiusa(g_tfMom, t0), rsi)",
     "GbaLeggiBuffer(g_hRsi, 0, rsi)", "S"),
    ("M06", "shift - 1 sullo Stocastico (look-ahead)", "GbaLeggiBuffer(g_hSto, GbaShiftChiusa(g_tfMom, t0), sto)",
     "GbaLeggiBuffer(g_hSto, GbaShiftChiusa(g_tfMom, t0) - 1, sto)", "S"),
    ("M07", "handle creati anche da spento", "   if(GbaMomentoAcceso())\n   {\n      g_tfMom",
     "   if(true)\n   {\n      g_tfMom", "S"),
    ("M08", "handle RSI non rilasciato", "   if(g_hRsi != INVALID_HANDLE) IndicatorRelease(g_hRsi);\n", "", "S"),
    ("M09", "chiamata di trading nuova nel blocco", "         motivo = GBA_MOMENTO;\n",
     "         motivo = GBA_MOMENTO;\n         trade.PositionClose(0);\n", "S"),
    ("M10", "riga v1.10 cambiata (InpSL_ATR 2.5 -> 3.0)", "input double InpSL_ATR        = 2.5;",
     "input double InpSL_ATR        = 3.0;", "S"),
    ("M11", "logica v1.10 cambiata (rottura non stretta)", "if(close1 > hh && close1 > ema) return 1;",
     "if(close1 >= hh && close1 > ema) return 1;", "S"),
    ("M12", "carattere non ASCII in un commento", "//--- v1.20 R16: il filtro di momentum e' acceso",
     "//--- v1.20 R16: il filtro di momentum \u00e8 acceso", "S"),
    ("M13", "funzione pura non neutra (tolto il ramo soglia <= 0)", "   if(soglia <= 0.0) return true;\n", "", "L"),
    ("M14", "SELL non specchiato", "if(dir < 0) return (100.0 - valore >= soglia);",
     "if(dir < 0) return (valore <= soglia);", "L"),
    ("M15", "confine stretto (> invece di >=)", "if(dir > 0) return (valore >= soglia);",
     "if(dir > 0) return (valore > soglia);", "L"),
    ("M16", "magic dell'originale (775800)", "InpMagic       = 775900;", "InpMagic       = 775800;", "S"),
    ("M17", "rifiuto con il motivo sbagliato (SPREAD)", "         motivo = GBA_MOMENTO;\n",
     "         motivo = GBA_SPREAD;\n", "S"),
    ("M18", "GBA_MOMENTO dentro g_conta[] (8 = TETTO)", "#define GBA_MOMENTO     9", "#define GBA_MOMENTO     8", "S"),
    ("M19", "input nuovo usato fuori guardia (in GbaApri)",
     "void GbaApri(const bool isLong, const double atr, const double spread)\n{\n",
     "void GbaApri(const bool isLong, const double atr, const double spread)\n{\n"
     "   if(InpRsiMinAligned > 50.0) return;\n", "S"),
    ("M20", "log di avvio senza InpStochMinAligned", "| InpStochMinAligned=%.2f%s |", "| Stoch=%.2f%s |", "S"),
    ("M21", "Stocastico letto sotto la soglia RSI",
     "   if(InpStochMinAligned > 0.0)\n   {\n      if(!GbaLeggiBuffer(g_hSto",
     "   if(InpRsiMinAligned > 0.0)\n   {\n      if(!GbaLeggiBuffer(g_hSto", "S"),
    ("M22", "versione non aggiornata", '#property version   "1.20"', '#property version   "1.10"', "S"),
    ("M23", "pin del TF cambiato (H1)", "InpMomTF           = PERIOD_M15;", "InpMomTF           = PERIOD_H1;", "S"),
    ("M24", "RSI sul TF del segnale invece di InpMomTF", "iRSI(g_sym, g_tfMom,", "iRSI(g_sym, g_tfSig,", "S"),
    ("M25", "rifiuto senza azzerare dir (entrerebbe lo stesso)", "         dir    = 0;\n", "", "S"),
    ("M26", "blocco spostato PRIMA di GbaDecidi (dir non ancora deciso)",
     "   int motivo = GBA_NO_SEGNALE;\n", "   int motivo = GBA_NO_SEGNALE;\n   int dirX = 1;\n"
     "   if(dirX != 0 && GbaMomentoAcceso())\n   {\n      g_contaMomento++;\n   }\n", "S"),
    ("M27", "segnaposto in meno nella riga MOMENTO", "| RSI(%d) %s | Stoc K", "| RSI %s | Stoc K", "S"),
    ("M28", "riga aggiunta estranea in OnTick (nessun id nuovo)", "   GbaNuovaBarra(t0);\n}",
     "   GbaNuovaBarra(t0);\n   g_lastBar = 0;\n}", "S"),
    ("M29", "filtro estraneo aggiunto in GbaApri (nessun id nuovo)",
     "void GbaApri(const bool isLong, const double atr, const double spread)\n{\n",
     "void GbaApri(const bool isLong, const double atr, const double spread)\n{\n   if(spread > 1.0) return;\n", "S"),
    ("M30", "lotto raddoppiato in GbaLotti (nessun id nuovo)", "   double v = GbaLottiNorm(grezzi, step, vmin, vmax);\n",
     "   grezzi = grezzi * 2.0;\n   double v = GbaLottiNorm(grezzi, step, vmin, vmax);\n", "S"),
    ("M31", "assegnazione nascosta in una riga di log di avvio", "               InpMomPeriod, GBA_STOCH_K, GBA_STOCH_D, "
     "GBA_STOCH_SLOW);\n", "               InpMomPeriod, GBA_STOCH_K, GBA_STOCH_D, GBA_STOCH_SLOW);\n"
     "   PrintFormat(\"x %d\", g_lastBar = 0);\n", "S"),
    ("M32", "riga v1.10 duplicata (segnale valutato due volte)", "   GbaNuovaBarra(t0);\n}",
     "   GbaNuovaBarra(t0);\n   GbaNuovaBarra(t0);\n}", "S"),
]


def applica(src, vecchio, nuovo):
    if src.count(vecchio) != 1:
        return None
    return src.replace(vecchio, nuovo, 1)


def mutanti(src_new, raw_orig):
    print("\nM) MUTANTI (%d + 2 contro-esempi di base), su copie in memoria" % len(MUTANTI))
    presi = 0
    for mid, desc, v, n, tipo in MUTANTI:
        mut = applica(src_new, v, n)
        if mut is None:
            print("  FAIL %s %s: il punto da mutare non e' unico o non esiste (collaudo da aggiornare)" % (mid, desc))
            continue
        E = suite(mut.encode("utf-8"), raw_orig, quiet=True)
        strati = sorted(set(s for s, _ in E.fails))
        ok = bool(strati) and (tipo != "L" or "P" in strati)
        presi += ok
        print(("  ok   " if ok else "  FAIL ") + "%s %-58s preso da [%s]" % (mid, desc, ",".join(strati) or "-"))
    # contro-esempi di base: l'originale passato come "nuovo" e l'originale modificato
    E = suite(raw_orig, raw_orig, quiet=True)
    b1 = bool(E.fails)
    print(("  ok   " if b1 else "  FAIL ") + "B01 la v1.10 stessa al posto della v1.20 (niente filtro)       "
          "preso da [%s]" % ",".join(sorted(set(s for s, _ in E.fails))))
    orig_mod = raw_orig.replace(b"InpChannelBars  = 48;", b"InpChannelBars  = 49;")
    E = suite(src_new.encode("ascii"), orig_mod, quiet=True)
    b2 = any(s == "O" for s, _ in E.fails)
    print(("  ok   " if b2 else "  FAIL ") + "B02 originale v1.10 modificato (base del confronto mossa)      "
          "preso da [%s]" % ",".join(sorted(set(s for s, _ in E.fails))))
    tot = len(MUTANTI) + 2
    ok = presi + b1 + b2
    print(("  ok   " if ok == tot else "  FAIL ") + "contro-esempi presi: %d/%d (logica pura: tutti presi dallo strato P)"
          % (ok, tot))
    return ok == tot


def main():
    with open(NUOVO, "rb") as f:
        raw_new = f.read()
    with open(ORIG, "rb") as f:
        raw_orig = f.read()
    print("collaudo ABTG_GoldBreakoutATR_Ottimizzato.mq5 (v1.20) contro ABTG_GoldBreakoutATR.mq5 (v1.10)")
    print("SHA256 v1.20: %s\n" % hashlib.sha256(raw_new).hexdigest())
    E = suite(raw_new, raw_orig)
    mut_ok = True
    if not SENZA_MUTANTI and not E.fails:
        mut_ok = mutanti(raw_new.decode("ascii"), raw_orig)
    print("\nNON PROVATO: compilazione MQL5 (MetaEditor assente); valori numerici di PERIOD_*/MODE_SMA/STO_LOWHIGH/"
          "PRICE_CLOSE (si controlla il nome); iRSI/iStochastic del terminale e buffer popolati su M15 nel tester "
          "(gate G0); la colla GbaNuovaBarra NON eseguita (solo la forma del blocco); nessun tick, NESSUN backtest.")
    if E.fails or not mut_ok:
        print("\nESITO: FAIL (%d controlli%s)" % (len(E.fails), "" if mut_ok else " + mutanti"))
        for s, m in E.fails[:40]:
            print("  - [%s] %s" % (s, m))
        sys.exit(1)
    print("\nESITO: PASS (%d controlli)" % E.n)


if __name__ == "__main__":
    main()
