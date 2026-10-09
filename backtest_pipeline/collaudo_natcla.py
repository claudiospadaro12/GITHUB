#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Collaudo STRATO 1 di mql5/Experts/EA_NatCla.mq5 ("Ea Nat&Cla", 07/10/2026).

Qui NON c'e' MetaEditor: niente compila l'MQL5, niente gira nel tester. Si prova quello che si puo' provare
a tavolino, e si dice cosa resta fuori.

  S) STATICO sul sorgente vero: ASCII puro; parentesi tonde/quadre/graffe bilanciate (fuori da commenti e
     stringhe); blocco puro //@@NC_PURE_BEGIN..END una volta; OGNI funzione MQL5 chiamata e' nella lista
     delle firme note (numero di argomenti controllato chiamata per chiamata), idem i metodi CTrade;
     StringFormat/PrintFormat: segnaposto == argomenti; handle inizializzati a INVALID_HANDLE e TUTTI
     rilasciati in OnDeinit; ogni funzione che fa CopyBuffer controlla BarsCalculated; ogni invio di
     APERTURA (Buy/Sell/BuyLimit/SellLimit) sta in una funzione che chiama ABTG_GuardiaIngresso PRIMA e
     rifiuta sl<=0; nessuna rete/DLL/#import; nessun orario hard-coded (.hour, InpSessionHour);
     default degli input == specifica (rischio 0,25 DA FIRMARE, bandiere spente, guardian on, placebo 0,
     magic 0 = automatico nel blocco 778600-778699); AVVISO in log per ogni bandiera accesa; imbuto: nomi
     == contatori, ogni 'return' delle quattro funzioni di valutazione porta il suo Esito (quadratura);
     magic 7786xx libero nel repo fuori dai file Nat&Cla.
  P) FUNZIONI PURE VERE estratte dal .mq5 e compilate C++ (stesso metodo di collaudo_pulsanti_tre_st.py):
     casi scritti a mano con il valore atteso (stop, TP EMA, validita', lotti per difetto, contesto,
     scala, pesi, meta' candela, direzione EMA, inclinazione) + proprieta' su 3000 casi casuali dei lotti
     (sum lotto x perdita <= R, multipli dello step, mai alzati al minimo).
  N) NUMERI su barre REALI dell'oro (M1 HistData in repo, orologio +6 h come la specifica par. 5.4):
     - NC_STCore == SW_STCore della casa (testo) e == specchio Python py_stcore, bit per bit, 3 livelli;
     - tocchi/episodi/contatore (NC_Tocco/NC_Episodi, C++ vero) == specchio Python INDIPENDENTE scritto in
       avanti (macchina a stati, non scansione all'indietro) su ogni barra, 4 linee, 3 configurazioni
       (base; SFIORA + azzeramento per distacco; placebo 1 ATR);
     - la finestra di 1500 barre dell'EA da' lo stesso risultato della serie intera (e una finestra di 40
       barre NO: contro-esempio che prova che il controllo morde);
     - conteggio setup/anno AUDIO H1 2024-07-10 -> 2026-09-18 contro la specifica (151/121/97 episodi,
       101/84/88 entro il limite, 37/34/37 con ADX Wilder <= 20; ricontati 40/36/36). L'EA usa iADX di MT5
       (specifica par. 2.1, scelta confermata dal cancello 07/10): 16/18/16 con lo specchio di ADX.mq5
       (scritto a memoria, ricostruito in modo indipendente dal cancello con lo stesso esito; NON
       verificato col terminale), controllato dentro 14-20.
  R) RACCORDO (cancello 07/10): invarianti SEMANTICI sul codice non puro -- lato dell'ordine nel ramo
     (s>0), lotto/SL/TP passati come variabili controllate, ogni filtro arriva a NC_Contesto, ADX dal
     buffer 0, nessuna ora locale ne' costante oraria, riga d'avvio che stampa le variabili giuste.
  T) TESTER PIGRO (v1.05): CaricaDati VERA estratta dal sorgente e compilata in C++ contro quattro modelli del calcolo degli
     indicatori (pigro sincrono = quello che riproduce i numeri misurati dalla diagnosi NATCLA_DIAG_U30; pigro differito;
     zelante = dal vivo; contro-esempio "ricalcola solo per copie di piu' elementi"). La stessa CaricaDati SENZA il tocco e'
     la v1.04: resta bloccata (= passate (e)(f)), la v1.05 parte alla barra 302 (= passate (a)(c)), con storia davanti e dal
     vivo sono IDENTICHE barra per barra. Piu': la v1.05 e' la v1.04 del commit 290e1b74 + il SOLO tocco (confronto senza
     commenti, una volta, sul sorgente vero).
  V) v1.10 STOP (decisione di Claudio 08/10, data/natcla/LEGGIMI.md risposta 2): NC_StopSetup / NC_FamigliaStop VERI in C++.
     (a) INVARIANZA: con InpStopModo = GEOMETRIA_ATTUALE (default) NC_StopSetup == NC_Stop BIT PER BIT (stringa %a) su 4000
     casi casuali con argomenti nuovi a caso, e sulle barre vere dell'oro; il raccordo passa a NC_StopSetup gli STESSI argomenti
     che la v1.05 passava a NC_Stop; e la v1.10 senza commenti differisce dalla v1.05 (pin d6586360) SOLO in righe che portano
     un simbolo della v1.10 (guardia del diff, con contro-esempio). (b) OLTRE_LINEA_ESTERNA: casi a mano (long/short, linea
     esterna discorde, dentro la scala = X4, stop <= 0) + specchio Python INDIPENDENTE su ogni barra H1 dell'oro, 4 linee,
     famiglia ST3,5 / EMA200 calcolata dallo specchio py_stcore / py_ema (non dal C++). (c) invarianti di raccordo 32-41.
  W) v1.11 OLTRE_PIU_ESTERNA (Claudio 09/10 "Proviamole entrambe"): NC_PiuEsterna VERA in C++ (casi a mano: long/short, EMA o ST3,5
     dal lato opposto, tutte e due opposte, non calcolabili) + specchio Python sull'oro (scelta della linea e stop, 4 linee) + la
     lettura LETTERALE ("la piu' bassa/alta delle due") coincide dove almeno una linea e' dal lato del setup. IDENTITA' v1.10 -> v1.11:
     NC_StopSetup del pin v1.10 (aeebb11d) e della v1.11 compilate fianco a fianco, modi 0 e 1, stessa stringa %a su casi casuali e
     sull'oro (con contro-esempio), e guardia del diff v1.10 -> v1.11. Mutanti W1-W15.
  M) MUTANTI CIECHI: 116 mutazioni del sorgente (66 fino alla v1.02 + J1/J2 della v1.03: rifiuto della modalita' PDF + K1-K5 della v1.04: manopole solo-PDF, valori dell'enum del magic + T1-T7 della v1.05: il tocco degli handle + V1-V21 della v1.10: la regola di stop OLTRE_LINEA_ESTERNA + W1-W15 della v1.11: OLTRE_PIU_ESTERNA) (logica pura, codice d'ordine, raccordo) applicate a una COPIA in
     una cartella temporanea FUORI dal repo (classe 1159: niente mutanti committati); per ognuna si rigira
     la STESSA suite (S + P + N ridotto) senza sapere quale mutazione c'e': deve FALLIRE almeno un
     controllo. Un mutante che passa = buco del collaudo.

Uso:   python3 backtest_pipeline/collaudo_natcla.py [--senza-mutanti]
Esce con 0 solo se tutto passa. NON prova: compilazione MQL5, CTrade/riempimenti, Guardian, iADX/iATR/iMA
del terminale, tick reali, orologio BCM (il feed e' HistData, NON BCM), e QUALE dei modelli T e' il tester vero (il
modello 0 spiega i numeri della diagnosi, non li dimostra: lo dice il lotto C0 di NATCLA_F0).
"""
import datetime as dt
import math
import os
import random
import re
import shutil
import subprocess
import sys
import tempfile
import zipfile

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
SRC = os.path.join(ROOT, "mql5/Experts/EA_NatCla.mq5")
PULS = os.path.join(ROOT, "mql5/Indicators/ABTG_Pulsanti_Grafico.mq5")
ZIPDIR = os.path.join(ROOT, "backtest_pipeline/risultati_prove/oro_m1_histdata_zip")
sys.path.insert(0, os.path.join(ROOT, "backtest_pipeline"))
_argv = sys.argv
sys.argv = [sys.argv[0], "--rapido"]
import collaudo_pulsanti_grafico as CG          # noqa: E402  (SHIM, to_cxx, py_stcore: convenzioni di casa)
sys.argv = _argv

SENZA_MUTANTI = "--senza-mutanti" in sys.argv
FAILS = []


def check(cond, msg, quiet=False, bag=None):
    if bag is not None:
        if not quiet:
            print(("  ok   " if cond else "  FAIL ") + msg)
        if not cond:
            bag.append(msg)
        return cond
    if not quiet:
        print(("  ok   " if cond else "  FAIL ") + msg)
    if not cond:
        FAILS.append(msg)
    return cond


def leggi(p):
    with open(p, "rb") as f:
        return f.read()


# ===========================================================================
# S) STATICO
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


def chiusa(code, i):
    """indice della parentesi che chiude quella aperta in i (code[i]=='(')"""
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
    """argomenti top-level fra code[i]=='(' e code[j]==')' (posizioni assolute)"""
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


def corpo(src, nome):
    m = re.search(r"\n[A-Za-z_][\w ]*?\b" + re.escape(nome) + r"\s*\([^;{]*\)\s*\{", src)
    if not m:
        return None
    i = src.index("{", m.start())
    d = 0
    for j in range(i, len(src)):
        if src[j] == "{":
            d += 1
        elif src[j] == "}":
            d -= 1
            if d == 0:
                return src[m.start():j + 1]
    return None


# firme MQL5 note: nome -> (min, max) argomenti. Fonte: documentazione MQL5 (firme pubbliche).
API = {
    "iMA": (6, 6), "iATR": (3, 3), "iADX": (3, 3), "iADXWilder": (3, 3), "iBands": (6, 6),
    "CopyBuffer": (5, 5), "CopyRates": (5, 5), "BarsCalculated": (1, 1), "IndicatorRelease": (1, 1),
    "Bars": (2, 4), "iTime": (3, 3), "iOpen": (3, 3),
    "SymbolInfoDouble": (2, 3), "SymbolInfoInteger": (2, 3), "SymbolInfoString": (2, 3),
    "AccountInfoDouble": (1, 1), "AccountInfoInteger": (1, 1), "StringLen": (1, 1),
    "OrderCalcProfit": (6, 6), "PositionsTotal": (0, 0), "PositionGetTicket": (1, 1), "PositionGetString": (1, 2),
    "PositionGetInteger": (1, 2), "PositionGetDouble": (1, 2), "PositionSelectByTicket": (1, 1),
    "OrdersTotal": (0, 0), "OrderGetTicket": (1, 1), "OrderGetString": (1, 2), "OrderGetInteger": (1, 2),
    "HistorySelect": (2, 2), "HistoryDealsTotal": (0, 0), "HistoryDealGetTicket": (1, 1),
    "HistoryDealGetInteger": (2, 3), "HistoryDealGetDouble": (2, 3), "HistoryDealGetString": (2, 3),
    "FileOpen": (2, 4), "FileWrite": (2, 64), "FileFlush": (1, 1), "FileClose": (1, 1),
    "Print": (1, 64), "PrintFormat": (1, 64), "StringFormat": (1, 64),
    "DoubleToString": (1, 2), "IntegerToString": (1, 3), "TimeToString": (1, 2), "EnumToString": (1, 1),
    "StringFind": (2, 3), "StringToUpper": (1, 1), "StringSplit": (3, 3),
    "TimeCurrent": (0, 1), "TimeToStruct": (2, 2), "PeriodSeconds": (0, 1), "MQLInfoInteger": (1, 1),
    "MQLInfoString": (1, 1), "GetLastError": (0, 0),
    "ArrayResize": (2, 3), "ArraySetAsSeries": (2, 2), "ArrayInitialize": (2, 2),
    "MathMax": (2, 2), "MathMin": (2, 2), "MathAbs": (1, 1), "MathFloor": (1, 1), "MathRound": (1, 1),
    "MathPow": (2, 2), "NormalizeDouble": (2, 2),
    "TesterStatistics": (1, 1), "FrameAdd": (4, 4), "FrameFilter": (2, 2), "FrameNext": (5, 5), "FrameInputs": (3, 3),
    "ABTG_GuardiaIngresso": (1, 13),
}
CTRADE = {
    "SetExpertMagicNumber": (1, 1), "SetTypeFillingBySymbol": (1, 1), "SetDeviationInPoints": (1, 1),
    "Buy": (1, 6), "Sell": (1, 6), "BuyLimit": (2, 8), "SellLimit": (2, 8), "OrderDelete": (1, 1),
    "PositionClose": (1, 2), "PositionClosePartial": (2, 3), "PositionModify": (3, 3),
    "ResultRetcode": (0, 0), "ResultRetcodeDescription": (0, 0),
}
KEYW = {"if", "for", "while", "switch", "return", "sizeof", "else"}
VIETATI = ["WebRequest", "SocketCreate", "SocketConnect", "SendFTP", "SendMail", "SendNotification", "#import",
           ".dll", "ShellExecute", "TerminalClose", "ExpertRemove", "OrderSendAsync"]
DEFAULT_ATTESI = {
    "InpModalita": "NC_AUDIO", "InpTF": "PERIOD_CURRENT", "InpDirezione": "NC_DIR_ENTRAMBI",
    "InpStAtrPeriodo": "10", "InpStMult1": "2.5", "InpStMult2": "3.0", "InpStMult3": "3.5",
    "InpEmaLentaPeriodo": "200", "InpEmaTp1": "14", "InpEmaTp2": "89", "InpAtrNormPeriodo": "14",
    "InpTocchiMaxEma": "0", "InpToccoDef": "NC_TOCCO_RAGGIUNGE", "InpSfioraAtr": "0.10",
    "InpTocchiMax25": "-1", "InpTocchiMax30": "-1", "InpTocchiMax35": "-1", "InpResetConteggio": "NC_RESET_AL_FLIP",
    "InpDistaccoAtr": "1.0", "InpChiudeVicinoAtr": "-1", "InpTimingTocco": "NC_TIMING_IGNORA",
    "InpAdxMax": "20", "InpAdxPeriodo": "14", "InpAdxAmbito": "NC_ADX_SOLO_ST35", "InpAdxTipo": "NC_ADX_MT5",
    "InpInclBarre": "20", "InpInclMinAtr": "0", "InpInclVerso": "NC_INCL_QUALSIASI", "InpConflTolAtr": "0.5",
    "InpMaxSpreadPunti": "0", "InpUnita": "NC_UNITA_AUTO_CLASSE", "InpScalaAnticipo": "5", "InpScalaOltre": "5",
    "InpPdfDistanzaSecondo": "20", "InpPdfAperturaLontana": "NC_LONTANA_SALTA", "InpPdfLontanoAtr": "0.5",
    "InpScadenzaBarre": "1", "InpMaxSetupAperti": "1", "InpRischioSetupPct": "0.25", "InpRischioMaxSetupPct": "0",
    "InpPesiScala": "NC_PESI_1_1_1", "InpPesiPdf": "NC_PESI_1_1", "InpMoltConfluenza": "1.0",
    "InpSLBuffer": "5", "InpSLEstremoBarre": "3", "InpTPDistanza": "10", "InpRRMin": "-1",
    "InpParzialeTP1Pct": "0", "InpDurataMaxMin": "0", "InpCancelloCostoX": "40", "InpCommissionePrezzo": "0",
    "InpUsaGuardian": "true", "InpMagic": "0", "InpLogImbuto": "true", "InpSoloConta": "false",
    "InpPlaceboAtr": "0", "InpLogContesto": "true",
    # v1.10: la regola di stop nuova e' SPENTA di default (default neutro = v1.05); 20 u = il numero di Claudio (08/10)
    "InpStopModo": "NC_STOP_GEOMETRIA_ATTUALE", "InpStopOltreU": "20.0",
}
TRI_DA_MODALITA = ["InpUsaST25", "InpUsaST30", "InpUsaST35", "InpMotoreEma200", "InpConfermaApertura",
                   "InpAdxUsa", "InpInclUsa", "InpBEalTP1"]


def statico(raw, bag):
    """controlli statici: appende i difetti in bag"""
    try:
        src = raw.decode("ascii")
    except UnicodeDecodeError as ex:
        bag.append("non ASCII puro: %s" % ex)
        src = raw.decode("latin-1")
    code = maschera(src)
    for a, b in ("()", "[]", "{}"):
        if code.count(a) != code.count(b):
            bag.append("parentesi %s%s sbilanciate: %d contro %d" % (a, b, code.count(a), code.count(b)))
    d = 0
    for ch in code:
        d += 1 if ch == "{" else (-1 if ch == "}" else 0)
        if d < 0:
            bag.append("graffa chiusa prima di essere aperta")
            break
    if src.count("//@@NC_PURE_BEGIN") != 1 or src.count("//@@NC_PURE_END") != 1:
        bag.append("marcatori del blocco puro non presenti una volta")
    # funzioni definite nel file
    definite = set(re.findall(r"^[ \t]*(?:const\s+)?(?:int|double|bool|void|string|datetime|long|ulong|uint)\s+(\w+)\s*\(",
                              code, re.M))
    # chiamate (non metodi)
    for m in re.finditer(r"(?<![\w.])([A-Za-z_]\w*)\s*\(", code):
        nome = m.group(1)
        if nome in KEYW or nome in definite:
            continue
        # dichiarazioni di prototipi/definizioni gia' escluse; i cast (int)( non matchano
        if nome not in API:
            bag.append("funzione MQL5 non nella lista delle firme note: %s (r.%d)" % (nome, code.count("\n", 0, m.start()) + 1))
            continue
        i = m.end() - 1
        j = chiusa(code, i)
        na = len(argomenti(code, i, j))
        lo, hi = API[nome]
        if not (lo <= na <= hi):
            bag.append("%s chiamata con %d argomenti (attesi %d-%d) r.%d" % (nome, na, lo, hi, code.count("\n", 0, m.start()) + 1))
    for m in re.finditer(r"\bgTrade\.(\w+)\s*\(", code):
        nome = m.group(1)
        if nome not in CTRADE:
            bag.append("metodo CTrade sconosciuto: %s" % nome)
            continue
        i = m.end() - 1
        na = len(argomenti(code, i, chiusa(code, i)))
        lo, hi = CTRADE[nome]
        if not (lo <= na <= hi):
            bag.append("gTrade.%s con %d argomenti (attesi %d-%d)" % (nome, na, lo, hi))
    if re.search(r"\b(?!gTrade\b)\w+\.(?!open\b|high\b|low\b|close\b|time\b|type\b|day_of_year\b)[a-z]\w*\s*\(", code):
        bag.append("chiamata di metodo su oggetto diverso da gTrade")
    # segnaposto di StringFormat/PrintFormat
    for m in re.finditer(r"\b(StringFormat|PrintFormat)\s*\(", code):
        i = m.end() - 1
        j = chiusa(code, i)
        args = argomenti(code, i, j)
        a0, b0 = args[0]
        lit = src[a0:b0].strip()
        if not (lit.startswith('"') and lit.endswith('"')):
            bag.append("%s senza formato letterale" % m.group(1))
            continue
        spec = re.findall(r"%(?!%)[-+ #0]*\d*(?:\.\d+)?(?:I64|ll|l|h)?[diouxXeEfgGsc]", lit.replace("%%", ""))
        if len(spec) != len(args) - 1:
            bag.append("%s r.%d: %d segnaposto contro %d argomenti" % (m.group(1), code.count("\n", 0, m.start()) + 1,
                                                                       len(spec), len(args) - 1))
    # handle
    hdecl = re.findall(r"\b(h\w+)\s*=\s*INVALID_HANDLE", code)
    hcrea = set(re.findall(r"\b(h\w+)\s*=\s*i(?:MA|ATR|ADX|ADXWilder|Bands)\s*\(", code))
    ondeinit = corpo(code, "OnDeinit") or ""
    rel = re.search(r"int\s+hs\s*\[\s*\d+\s*\]\s*=\s*\{([^}]*)\}", ondeinit)
    rilasciati = set(x.strip() for x in rel.group(1).split(",")) if rel else set()
    if "IndicatorRelease(hs[i])" not in ondeinit.replace(" ", ""):
        bag.append("OnDeinit non rilascia la lista hs[]")
    for h in hcrea:
        if h not in hdecl:
            bag.append("handle %s non inizializzato a INVALID_HANDLE" % h)
        if h not in rilasciati:
            bag.append("handle %s non rilasciato in OnDeinit" % h)
    if not hcrea:
        bag.append("nessun handle creato (parser?)")
    for nome in sorted(definite):
        b = corpo(code, nome)
        if b and "CopyBuffer(" in b and "BarsCalculated(" not in b:
            bag.append("%s usa CopyBuffer senza BarsCalculated" % nome)
    # invii di APERTURA: Guardian prima, sl<=0 rifiutato
    for m in re.finditer(r"\bgTrade\.(Buy|Sell|BuyLimit|SellLimit)\s*\(", code):
        # funzione che contiene la chiamata
        start = code.rfind("\n", 0, m.start())
        fn = None
        for nome in definite:
            b = corpo(code, nome)
            if b:
                k = code.find(b)
                if 0 <= k <= m.start() <= k + len(b):
                    fn, fb, fk = nome, b, k
                    break
        if fn is None:
            bag.append("invio %s fuori da una funzione riconosciuta" % m.group(1))
            continue
        prima = code[fk:m.start()]
        if "ABTG_GuardiaIngresso(" not in prima:
            bag.append("invio %s in %s senza ABTG_GuardiaIngresso PRIMA" % (m.group(1), fn))
        if not re.search(r"if\s*\(\s*sl\s*<=\s*0\s*\)\s*\{[^}]*return\s+false", prima):
            bag.append("invio %s in %s senza il rifiuto di sl<=0" % (m.group(1), fn))
        i = m.end() - 1
        args = argomenti(code, i, chiusa(code, i))
        idx_sl = 3 if m.group(1) in ("Buy", "Sell", "BuyLimit", "SellLimit") else None
        if idx_sl is not None and len(args) > idx_sl:
            a, b = args[idx_sl]
            if code[a:b].strip() in ("0", "0.0", "0.0f"):
                bag.append("invio %s con SL letterale 0" % m.group(1))
    for v in VIETATI:
        if v in code:
            bag.append("vietato presente: %s" % v)
    if re.search(r"\.hour\b|InpSessionHour|\bhour\s*[<>=]", code):
        bag.append("orario hard-coded (.hour / InpSessionHour)")
    # default degli input
    inputs = dict(re.findall(r"^\s*input\s+[\w]+\s+(Inp\w+)\s*=\s*([^;]+);", code, re.M))
    for k, v in DEFAULT_ATTESI.items():
        if k not in inputs:
            bag.append("input mancante: %s" % k)
        elif inputs[k].strip() != v:
            bag.append("default di %s = %s, atteso %s" % (k, inputs[k].strip(), v))
    for k in TRI_DA_MODALITA:
        if inputs.get(k, "").strip() != "NC_TRI_DA_MODALITA":
            bag.append("%s non e' DA_MODALITA" % k)
    for k in ("InpTipoIngresso", "InpSLCriterio", "InpTPCriterio", "InpConfluenza"):
        if not inputs.get(k, "").strip().endswith("DA_MODALITA"):
            bag.append("%s non e' DA_MODALITA" % k)
    rl = re.search(r"input\s+double\s+InpRischioSetupPct[^\n]*", src)
    if not rl or "DA FIRMARE DA CLAUDIO" not in rl.group(0):
        bag.append("InpRischioSetupPct senza la dicitura 'DA FIRMARE DA CLAUDIO'")
    if re.search(r"input\s+double\s+\w*Lott\w*|InpLots\b|InpLotto\b", code):
        bag.append("input di lotto fisso presente")
    # bandiere: AVVISO condizionato all'input diverso dal default
    for cond in ("InpPesiScala!=NC_PESI_1_1_1", "InpPesiPdf!=NC_PESI_1_1", "InpMoltConfluenza!=1.0"):
        # v1.04: "if(InpPesiPdf!=NC_PESI_1_1)" compare anche nel blocco solo-PDF di Risolvi: basta che UNA occorrenza abbia l'AVVISO
        ks = [m.start() for m in re.finditer(re.escape("if(" + cond + ")"), src)]
        if not any("AVVISO BANDIERA" in src[k:k + 300] for k in ks):
            bag.append("manca l'AVVISO in log per la bandiera %s" % cond)
    # magic: blocco e risoluzione
    if "gMagic<778600 || gMagic>778699" not in code:
        bag.append("controllo del blocco magic 778600-778699 assente")
    if "778600+10*(long)InpModalita+cifraTF" not in code:
        bag.append("schema del magic automatico diverso dalla specifica")
    # placebo bloccato fuori dal tester; TF sotto H1 rifiutato
    if "InpPlaceboAtr!=0 && !MQLInfoInteger(MQL_TESTER)" not in code:
        bag.append("placebo non bloccato fuori dal tester")
    if "PeriodSeconds(gTF)<PeriodSeconds(PERIOD_H1)" not in code:
        bag.append("TF sotto H1 non rifiutato")
    # imbuto: nomi == contatori; ogni return delle valutazioni porta un Esito
    nimb = int(re.search(r"#define\s+IMB_N\s+(\d+)", code).group(1))
    idx = sorted(int(x) for x in re.findall(r"#define\s+IMB_(?!N\b|ULTIMO_ESITO\b)\w+\s+(\d+)", code))
    if idx != list(range(nimb)):
        bag.append("indici IMB_ non 0..IMB_N-1 una volta: %s" % idx)
    nomi = re.search(r"gImbNome\[IMB_N\]\s*=\s*\{(.*?)\};", src, re.S)
    if not nomi or len(re.findall(r'"[^"]*"', nomi.group(1))) != nimb:
        bag.append("gImbNome non ha IMB_N nomi")
    for fn in ("ValutaScala", "ValutaPdf", "ArmaScala", "EntraPdf"):
        b = corpo(code, fn)
        if not b:
            bag.append("funzione %s non trovata" % fn)
            continue
        for ln in b.split("\n"):
            if re.search(r"\breturn\b", ln) and "Esito(" not in ln:
                bag.append("%s: 'return' senza Esito sulla stessa riga: %s" % (fn, ln.strip()[:80]))
    for fn in ("ValutaScala", "ValutaPdf"):
        b = corpo(code, fn) or ""
        if b.count("Esito(IMB_VAL)") != 1:
            bag.append("%s: Esito(IMB_VAL) non una volta" % fn)
    # CSV per-setup: stesse colonne nell'intestazione e nelle due righe
    hm = re.search(r'FileWrite\(gFh,"(tipo;[^"]*)"\)', src)
    ncol = hm.group(1).count(";") + 1 if hm else -1
    for fn in ("void ScriviRiga", "void ScriviConta"):
        i = src.find(fn)
        j = src.find("FileWrite(gFh,r);", i)
        m = re.search(r"string r=(.*?);\n", src[i:j], re.S) if i >= 0 and j >= 0 else None
        if not m:
            bag.append("%s: riga CSV non trovata" % fn)
            continue
        nc = sum(x.count(";") for x in re.findall(r'"((?:[^"\\]|\\.)*)"', m.group(1))) + 1
        if nc != ncol:
            bag.append("%s: %d colonne contro %d dell'intestazione" % (fn, nc, ncol))
    for fn, fine in (("ArmaScala", "Esito(IMB_ARMATO)"), ("EntraPdf", "Esito(IMB_ENTRATO)")):
        b = corpo(code, fn) or ""
        if fine not in b:
            bag.append("%s: manca %s" % (fn, fine))
    invarianti_raccordo(src, code, bag)
    return src


def invarianti_raccordo(src, code, bag):
    """INVARIANTI SEMANTICI sul raccordo (cancello 07/10, classi 1068/1076): il primo giro di 8 mutanti
    ciechi del cancello sul codice NON puro ne lasciava passare 6 (lato invertito, SL azzerato,
    ADX e inclinazione scollegati, orologio, riga d'avvio). Qui si controlla il SIGNIFICATO del
    raccordo, non un testo: residuo dichiarato nelle note (par. 5)."""
    # (1) LATO: un acquisto parte SOLO nel ramo s>0, una vendita SOLO nel ramo opposto
    for m in re.finditer(r"\bgTrade\.(Buy|BuyLimit|Sell|SellLimit)\s*\(", code):
        nome = m.group(1)
        prima = code[max(0, m.start() - 200):m.start()]
        stmt = prima[prima.rfind(";") + 1:]
        if nome.startswith("Buy") and not re.search(r"\(\s*s\s*>\s*0\s*\)\s*\?\s*$", stmt):
            bag.append("RACCORDO: gTrade.%s non e' nel ramo (s>0) ? ... (lato)" % nome)
        if nome.startswith("Sell") and not re.search(r"\(\s*s\s*>\s*0\s*\)\s*\?\s*gTrade\.Buy\w*\s*\(.*\)\s*:\s*$", stmt, re.S):
            bag.append("RACCORDO: gTrade.%s non e' nel ramo ':' di (s>0) ? Buy... (lato)" % nome)
        # (2) SL/TP/LOTTO: gli argomenti sono le variabili controllate (if(sl<=0) ...), non espressioni
        args = argomenti(code, m.end() - 1, chiusa(code, m.end() - 1))
        txt = [code[a:b].strip() for a, b in args]
        att = {"Buy": (0, 3, 4), "Sell": (0, 3, 4), "BuyLimit": (0, 3, 4), "SellLimit": (0, 3, 4)}[nome]
        if len(txt) > 4 and (txt[att[0]], txt[att[1]], txt[att[2]]) != ("lot", "sl", "tp"):
            bag.append("RACCORDO: gTrade.%s con lotto/SL/TP %s invece di (lot, sl, tp)" % (nome, txt[:5]))
    # (3) FILTRI: ogni filtro risolto in Risolvi arriva a NC_Contesto come variabile, non come costante
    cb = corpo(code, "Contesto") or ""
    mc = re.search(r"\bNC_Contesto\s*\(", cb)
    if not mc:
        bag.append("RACCORDO: Contesto non chiama NC_Contesto")
    else:
        a = [cb[x:y].strip() for x, y in argomenti(cb, mc.end() - 1, chiusa(cb, mc.end() - 1))]
        att = ["s", "adxApplica", "adx", "InpAdxMax", "gInclUsa", "incl", "InpInclMinAtr", "(int)InpInclVerso",
               "gConfl", "dc", "InpConflTolAtr"]
        if a != att:
            bag.append("RACCORDO: NC_Contesto chiamata con %s invece di %s" % (a, att))
        md = re.search(r"\bbool\s+adxApplica\s*=\s*([^;]+);", cb)
        if not md or not re.match(r"gAdxUsa\s*&&", md.group(1).strip()) or "L!=NC_LEMA" not in md.group(1).replace(" ", ""):
            bag.append("RACCORDO: adxApplica non parte da gAdxUsa && L!=NC_LEMA")
        if not re.search(r"\badx\s*=\s*gAdx\s*\[\s*k\s*\]", cb) or not re.search(r"\bincl\s*=\s*NC_Inclinazione\s*\(\s*gEma\s*,\s*gAtrN\s*,\s*k\s*,\s*InpInclBarre\s*\)", cb):
            bag.append("RACCORDO: ADX/inclinazione non letti alla barra k del contesto")
    # (4) ADX: la riga principale e' il buffer 0 sia di iADX sia di iADXWilder
    if not re.search(r"CopyBuffer\s*\(\s*hAdx\s*,\s*0\s*,", code):
        bag.append("RACCORDO: CopyBuffer di hAdx non legge il buffer 0 (riga ADX)")
    # (5) OROLOGIO: nessuna ora locale, nessuno spostamento orario cablato
    for v in ("TimeLocal", "TimeGMT", "TimeGMTOffset", "TimeDaylightSavings"):
        if re.search(r"\b%s\s*\(" % v, code):
            bag.append("RACCORDO: orologio non del server (%s)" % v)
    if re.search(r"(?<![\w.])(3600|7200|10800|-3600)(?![\w.])", code):
        bag.append("RACCORDO: costante oraria cablata (3600/7200/10800): l'EA non ha regole d'orario")
    # (6) RIGA D'AVVIO: le etichette che contano stampano la variabile giusta
    ma = re.search(r'string\s+avvio\s*=\s*StringFormat\s*\(', code)
    if not ma:
        bag.append("RACCORDO: riga d'avvio non trovata")
    else:
        i = ma.end() - 1
        args = argomenti(code, i, chiusa(code, i))     # posizioni dal codice mascherato, testo dal sorgente
        lit = src[args[0][0]:args[0][1]].strip()[1:-1].replace("%%", "")
        pezzi = re.split(r"%[-+ #0]*\d*(?:\.\d+)?[dfs]", lit)
        val = [src[a:b].strip() for a, b in args[1:]]
        mappa = {"rischio setup ": "InpRischioSetupPct", "placebo ": "InpPlaceboAtr", "magic ": "IntegerToString(gMagic)",
                 "modalita' ": "NomeModalita()", "ADX ": 'gAdxUsa ? "ACCESO" : "spento"', "max ": "InpAdxMax",
                 "periodo ": "InpAdxPeriodo", "stop ": "StopDescr()"}
        for k_, v_ in mappa.items():
            pos = [j for j, p in enumerate(pezzi[:-1]) if p.endswith(k_)]
            if len(pos) != 1 or pos[0] >= len(val) or val[pos[0]] != v_:
                bag.append("RACCORDO: riga d'avvio, '%s' non stampa %s" % (k_.strip(), v_))
    nospazi = re.sub(r"\s+", "", code)
    # (7) DATI: barre e buffer copiati dalla STESSA posizione (1 = ultima chiusa) e nello stesso numero
    cd = corpo(code, "CaricaDati") or ""
    for m in re.finditer(r"\b(CopyRates|CopyBuffer)\s*\(", cd):
        a = [cd[x:y].strip() for x, y in argomenti(cd, m.end() - 1, chiusa(cd, m.end() - 1))]
        if m.group(1) == "CopyBuffer" and len(a) == 5 and a[4] == "tocco":
            continue                     # v1.05: il TOCCO (1 elemento, esito ignorato) e' controllato dall'invariante (31)
        if len(a) != 5 or a[2] != "1" or a[3] != "n":
            bag.append("RACCORDO: %s in CaricaDati con inizio/numero %s invece di (1, n)" % (m.group(1), a[2:4]))
    # (8) SEMAFORO: al primo riempimento si cancellano le ALTRE linee armate, non quella riempita
    if "if(K!=L&&gSet[K].attivo&&!gSet[K].riempito&&gSet[K].tipo==NC_TIPO_SCALA)" not in nospazi:
        bag.append("RACCORDO: il semaforo non cancella le ALTRE linee armate (K!=L, non riempite) [ancora]")
    # (9) CONTEGGIO: armabile se il numero del tocco e' <= max, cioe' si scarta solo con '>' stretto
    for m in re.finditer(r"(\w+)\s*(>=|<=|>|<|==)\s*gTocchiMax\s*\[", code):
        if m.group(2) != ">" or m.group(1) not in ("prossimo", "nEp"):
            bag.append("RACCORDO: confronto col massimo dei tocchi '%s %s gTocchiMax' (atteso: n > max scarta)" % (m.group(1), m.group(2)))
    # (10) DA_MODALITA: la risoluzione dei default == colonne AUDIO / PDF / EMA200 della specifica par. 1
    attese = ["gUsaLinea[NC_L25]=DaModB(InpUsaST25,true,false,false)", "gUsaLinea[NC_L30]=DaModB(InpUsaST30,true,false,false)",
              "gUsaLinea[NC_L35]=DaModB(InpUsaST35,true,true,false)", "gUsaLinea[NC_LEMA]=DaModB(InpMotoreEma200,false,false,true)",
              "gTocchiMax[NC_L25]=DaModI(InpTocchiMax25,1,0,1)", "gTocchiMax[NC_L30]=DaModI(InpTocchiMax30,1,0,1)",
              "gTocchiMax[NC_L35]=DaModI(InpTocchiMax35,2,0,2)", "gChiudeVicino=DaModD(InpChiudeVicinoAtr,0.0,0.5,0.0)",
              "gConferma=DaModB(InpConfermaApertura,false,true,false)", "gAdxUsa=DaModB(InpAdxUsa,true,false,false)",
              "gInclUsa=DaModB(InpInclUsa,true,false,true)", "gRRMin=DaModD(InpRRMin,0.0,1.0,0.0)", "gBE=DaModB(InpBEalTP1,false,true,false)",
              "gConfl=(InpConfluenza==NC_CONFL_DA_MODALITA)?((InpModalita==NC_PDF)?2:1)",
              "gIngresso=(InpTipoIngresso==NC_ING_DA_MODALITA)?((InpModalita==NC_PDF)?1:0)",
              "gSLCrit=(InpSLCriterio==NC_SL_DA_MODALITA)?((InpModalita==NC_PDF)?1:0)",
              "gTPCrit=(InpTPCriterio==NC_TP_DA_MODALITA)?((InpModalita==NC_PDF)?2:0)",
              "if(InpTF==PERIOD_CURRENT)gTF=(InpModalita==NC_PDF)?PERIOD_H4:PERIOD_H1"]
    for a in attese:
        if a not in nospazi:
            bag.append("RACCORDO: risoluzione DA_MODALITA diversa dalla specifica: manca '%s'" % a)
    # (11) STOP: il 'profondo' passato a NC_Stop e' l'ultimo ordine del setup (scala p[2], PDF p[1]).
    #      v1.10: in ArmaScala e ScriviConta lo stop passa da NC_StopSetup, che in GEOMETRIA_ATTUALE E' NC_Stop: i SEI argomenti
    #      della v1.05 (criterio, lato, linea, profondo, estremo, buffer) devono essere gli STESSI, nello stesso ordine, dopo il modo
    #      (= invarianza al raccordo); in coda la linea esterna, la sua direzione, InpStopOltreU*gU, l'esito. EntraPdf (codice morto) resta su NC_Stop.
    sei105 = {"ArmaScala": ["gSLCrit", "s", "lv", "p[2]", "Estremo(s,last)", "InpSLBuffer*gU"],
              "ScriviConta": ["gSLCrit", "s", "lv0", "p[2]", "Estremo(s,last)", "InpSLBuffer*gU"]}
    for fn, att in (("ArmaScala", "p[2]"), ("EntraPdf", "p[1]"), ("ScriviConta", "p[2]")):
        b = corpo(code, fn) or ""
        if fn in sei105:
            m = re.search(r"\bNC_StopSetup\s*\(", b)
            a = [re.sub(r"\s+", "", b[x:y]) for x, y in argomenti(b, m.end() - 1, chiusa(b, m.end() - 1))] if m else []
            if len(a) != 11 or a[0] != "(int)InpStopModo" or a[1:7] != sei105[fn] or a[7:] != ["lest", "dest", "InpStopOltreU*gU", "es"]:
                bag.append("RACCORDO v1.10: NC_StopSetup in %s con %s (attesi (int)InpStopModo, %s, lest, dest, InpStopOltreU*gU, es)" % (fn, a, sei105[fn]))
            if re.search(r"\bNC_Stop\s*\(", b):
                bag.append("RACCORDO v1.10: %s chiama ancora NC_Stop direttamente (la regola nuova verrebbe saltata)" % fn)
            continue
        m = re.search(r"\bNC_Stop\s*\(", b)
        a = [b[x:y].strip() for x, y in argomenti(b, m.end() - 1, chiusa(b, m.end() - 1))] if m else []
        if len(a) != 6 or a[3] != att or a[0] != "gSLCrit" or a[5] != "InpSLBuffer*gU":
            bag.append("RACCORDO: NC_Stop in %s con %s (atteso gSLCrit, ..., profondo %s, ..., InpSLBuffer*gU)" % (fn, a, att))
    # (12) PERDITA PER LOTTO: 1 lotto, distanza intera (ancora: OrderCalcProfit non gira fuori dal terminale)
    if ("OrderCalcProfit(ORDER_TYPE_BUY,_Symbol,1.0,px,px-dist,prof)" not in nospazi or "loss=(dist/tsz)*tv;" not in nospazi):
        bag.append("RACCORDO: PerditaPerLotto non calcola 1 lotto sulla distanza intera [ancora]")
    # (13) X10: i residui si cancellano alla PRIMA USCITA (meno posizioni vive di quelle viste), non al primo riempimento
    if "if(no>0&&np<gSet[L].nPosId&&!gSet[L].residuiCancellati)" not in nospazi:
        bag.append("RACCORDO: X10 non scatta alla prima uscita del setup [ancora]")
    # (14) NETTING rifiutato e retcode: solo DONE / PLACED / DONE_PARTIAL contano come invio riuscito
    if "if(AccountInfoInteger(ACCOUNT_MARGIN_MODE)!=ACCOUNT_MARGIN_MODE_RETAIL_HEDGING)" not in nospazi:
        bag.append("RACCORDO: conto non HEDGING non rifiutato [ancora]")
    eo = re.sub(r"\s+", "", corpo(code, "EsitoOk") or "")
    if sorted(re.findall(r"TRADE_RETCODE_\w+", eo)) != ["TRADE_RETCODE_DONE", "TRADE_RETCODE_DONE_PARTIAL", "TRADE_RETCODE_PLACED"]:
        bag.append("RACCORDO: EsitoOk accetta retcode diversi da DONE/PLACED/DONE_PARTIAL")

    # ---- seconda lettura del cancello 07/10: i 6 residui VERDI del terzo giro + il raccordo del rischio
    stc = "".join(sc if mc == "x" else mc for mc, sc in zip(code, src))     # commenti via, stringhe tenute
    ns = lambda t: re.sub(r"\s+", "", t or "")
    # (15) RISCHIO al raccordo: la funzione pura era provata, la CHIAMATA no (rischio x10 al chiamante restava VERDE)
    if "returnNC_RischioSoldi(AccountInfoDouble(ACCOUNT_BALANCE),InpRischioSetupPct,InpMoltConfluenza,dc,InpConflTolAtr,gRischioMax);" not in ns(corpo(code, "RischioSoldi")):
        bag.append("RACCORDO: RischioSoldi non passa (saldo, InpRischioSetupPct, InpMoltConfluenza, dc, tolleranza, tetto) [ancora]")
    cl = ns(corpo(code, "CalcolaLotti"))
    for a in ("pl[i]=(w[i]>0)?PerditaPerLotto(MathAbs(p[i]-sl)):0.0;", "NC_LottiSetup(RischioSoldi(dc),w,pl,3,step,vmin,vmax,lot);",
              "doublestep=SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_STEP);", "doublevmin=SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_MIN);",
              "doublevmax=SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_MAX);"):
        if a not in cl:
            bag.append("RACCORDO: CalcolaLotti senza '%s' [ancora]" % a)
    # (16) SCADENZA: la scala e' GTC (riprezzata a ogni barra), il PDF porta la sua scadenza
    for fn, att in (("ArmaScala", "0"), ("EntraPdf", "gSet[L].tScadenza")):
        b = corpo(code, fn) or ""
        m = re.search(r"\bInviaLimit\s*\(", b)
        a = [b[x:y].strip() for x, y in argomenti(b, m.end() - 1, chiusa(b, m.end() - 1))] if m else []
        if len(a) != 8 or a[5] != att:
            bag.append("RACCORDO: InviaLimit in %s con scadenza %s (attesa %s)" % (fn, a[5:6], att))
    if "if(scad>0&&gScadServer){tt=ORDER_TIME_SPECIFIED;ex=scad;}" not in ns(corpo(code, "InviaLimit")):
        bag.append("RACCORDO: InviaLimit non applica la scadenza solo se scad>0 e il simbolo la accetta [ancora]")
    # (17) TP1: verso del raggiungimento, del pareggio e della liceita' rispetto allo stops level
    g1 = ns(corpo(code, "GestisciTP1"))
    for a in ("boolhit=(s>0)?(bid>=gSet[L].tp1):(ask<=gSet[L].tp1);", "boolmigliora=(s>0)?(medio>slNow):(medio<slNow||slNow==0);",
              "boollecito=(s>0)?(medio<bid-md):(medio>ask+md);"):
        if a not in g1:
            bag.append("RACCORDO: GestisciTP1 senza '%s' (verso del TP1/pareggio) [ancora]" % a)
    # (18) DURATA: minuti dell'input x 60 contro secondi dal riempimento
    if "TimeCurrent()-gSet[L].tRiempimento>=(long)InpDurataMaxMin*60" not in ns(corpo(code, "Sincronizza")):
        bag.append("RACCORDO: durata massima non in minuti x 60 dal primo riempimento [ancora]")
    # (19) UNITA': metalli 1,0 USD; forex (modo di calcolo o valute) = pip; il resto 1,0
    cu = ns(corpo(stc, "CalcolaUnita"))
    if not re.search(r'if\(StringFind\(sy,"XAU"\)==0\|\|StringFind\(sy,"XAG"\)==0\)\{descr="[^"]*";return1\.0;\}', cu):
        bag.append("RACCORDO: CalcolaUnita, oro/argento non a 1,0 USD [ancora]")
    if cu.count("returnPipMT();") != 3 or not cu.endswith('descr="AUTO_CLASSEindice/CFD:1,0punto";return1.0;}'):
        bag.append("RACCORDO: CalcolaUnita, forex non a pip (a mano, modo di calcolo, valute) o indice non a 1,0 [ancora]")
    if "returnNC_Pip((int)SymbolInfoInteger(_Symbol,SYMBOL_DIGITS),_Point);" not in ns(corpo(code, "PipMT")):
        bag.append("RACCORDO: PipMT non passa cifre e punto del simbolo [ancora]")
    # (20) CONFERMA PDF: la candela dopo apre dal lato del trend (s x (open - linea) > 0)
    vp = ns(corpo(code, "ValutaPdf"))
    for a in ("doubleop0=iOpen(_Symbol,gTF,0);", "doublelv0=LineaPrezzo(last,s);", "if(gConferma&&!(s*(op0-lv0)>0))"):
        if a not in vp:
            bag.append("RACCORDO: conferma PDF senza '%s' [ancora]" % a)
    # (21) ADOZIONE al riavvio: OnInit adotta, le posizioni si adottano, i pendenti senza posizione si cancellano
    oi = ns(corpo(code, "OnInit"))
    if not oi.endswith("AdottaEsistenti();return(INIT_SUCCEEDED);}"):
        bag.append("RACCORDO: OnInit non chiama AdottaEsistenti() subito prima di INIT_SUCCEEDED [ancora]")
    ae = ns(corpo(code, "AdottaEsistenti"))
    if "if(np>0){AdottaLinea(L);" not in ae or "elseif(no>0)CancellaOrdiniLinea(L," not in ae:
        bag.append("RACCORDO: AdottaEsistenti non adotta le posizioni / non cancella i pendenti senza posizione [ancora]")
    if "gSet[L].attivo=true;gSet[L].riempito=true;gSet[L].adottato=true;" not in ns(corpo(code, "AdottaLinea")):
        bag.append("RACCORDO: AdottaLinea non marca il setup attivo e riempito [ancora]")
    # (22) PENDENTI ORFANI: una linea senza setup in memoria e senza posizioni non tiene pendenti vivi
    if "if(np==0&&no>0&&TimeCurrent()-gOrfTent[L]>=NC_ORF_PAUSA_SEC){gOrfTent[L]=TimeCurrent();CancellaOrdiniLinea(L," not in ns(corpo(code, "Sincronizza")):
        bag.append("RACCORDO: Sincronizza non cancella (cadenzato) i pendenti di una linea senza setup (cancellazione fallita prima) [ancora]")
    # (22b) terza lettura 07/10: il ritentativo e' cadenzato (1..60 s) e il cronometro parte da zero all'avvio
    mp = re.search(r"#define\s+NC_ORF_PAUSA_SEC\s+(\d+)", src)
    if not mp or not (1 <= int(mp.group(1)) <= 60):
        bag.append("RACCORDO: NC_ORF_PAUSA_SEC assente o fuori da 1-60 s (raffica di OrderDelete o orfano lasciato vivo troppo)")
    if "gOrfTent[L]=0;" not in ns(corpo(code, "OnInit")):
        bag.append("RACCORDO: OnInit non azzera gOrfTent[] (primo ritentativo non immediato)")
    # (25) terza lettura 07/10: OGNI scansione di ordini/posizioni filtra simbolo E magic (ordini manuali e altre
    #      istanze non si toccano). Il filtro tolto in CancellaOrdiniLinea restava VERDE.
    cc = ns(code)
    fo = cc.count("if(OrderGetString(ORDER_SYMBOL)!=_Symbol||OrderGetInteger(ORDER_MAGIC)!=gMagic)continue;")
    fp = (cc.count("if(PositionGetString(POSITION_SYMBOL)!=_Symbol||PositionGetInteger(POSITION_MAGIC)!=gMagic)continue;")
          + cc.count("if(PositionGetString(POSITION_SYMBOL)==_Symbol&&PositionGetInteger(POSITION_MAGIC)==gMagic&&"))
    if cc.count("OrderGetTicket(") != fo or cc.count("PositionGetTicket(") != fp:
        bag.append("RACCORDO: una scansione di ordini/posizioni non filtra simbolo E magic (ordini %d/%d, posizioni %d/%d)"
                   % (fo, cc.count("OrderGetTicket("), fp, cc.count("PositionGetTicket(")))
    # (26) terza lettura 07/10: parziale al TP1 per difetto allo step, e il residuo resta >= minimo
    g1b = ns(corpo(code, "GestisciTP1"))
    for a in ("doublestep=SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_STEP),vmin=SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_MIN);",
              "doublecv=NC_LottoGiu(v*InpParzialeTP1Pct/100.0,step,vmin,0);if(cv>0&&cv<v&&v-cv>=vmin-1e-12)gTrade.PositionClosePartial(tk,cv);"):
        if a not in g1b:
            bag.append("RACCORDO: GestisciTP1 senza '%s' (parziale con residuo >= minimo)" % a)
    # (27) terza lettura 07/10: VERIFICA ADX e' SOLA LETTURA (stampa e basta: non spegne, non ferma, non cambia stato)
    vb = ns(corpo(code, "VerificaAdx"))
    if (not vb or "ExpertRemove" in vb or "return" in vb or re.search(r"\b(g[A-Z]\w*|Inp\w+)(\[[^\]]*\])?(=(?!=)|\+\+|--|\+=|-=)", vb)):
        bag.append("RACCORDO: VerificaAdx non e' sola lettura (assegna uno stato globale, ritorna o ferma l'EA)")
    # (23) DATI N/D: la scala armata non sopravvive a una barra senza dati
    if "if(gSet[L].attivo&&!gSet[L].riempito&&gSet[L].tipo==NC_TIPO_SCALA){CancellaSetupNonRiempito(L," not in ns(corpo(code, "OnNewBar")):
        bag.append("RACCORDO: OnNewBar senza dati non cancella la scala armata [ancora]")
    # (24) VERIFICA ADX: terminale (buffer letto alla barra chiusa) contro i due ricalcoli sulle stesse barre
    va = ns(corpo(code, "VerificaAdx"))
    for a in ("doublet=gAdx[gN-1];", "doublee=NC_AdxUltimo(gH,gL,gC,gN,InpAdxPeriodo,0);", "doublew=NC_AdxUltimo(gH,gL,gC,gN,InpAdxPeriodo,1);"):
        if a not in va:
            bag.append("RACCORDO: VerificaAdx senza '%s'" % a)
    if "if(ok&&!gAdxVerificato){VerificaAdx();gAdxVerificato=true;}" not in ns(corpo(code, "OnNewBar")):
        bag.append("RACCORDO: la riga VERIFICA ADX non e' stampata alla prima barra con dati")
    # (28) v1.03, decisione di Claudio 07/10/2026 (data/natcla/LEGGIMI.md): la modalita' PDF e' ESCLUSA.
    #      OnInit la rifiuta come PRIMA istruzione (prima di stato, handle, file), con INIT_PARAMETERS_INCORRECT
    #      e il messaggio in chiaro. Il default AUDIO e' gia' in DEFAULT_ATTESI. Mutanti J1/J2.
    ob = corpo(code, "OnInit") or ""
    oi_ = code.find(ob) if ob else -1
    oin = ns(stc[oi_:oi_ + len(ob)]) if oi_ >= 0 else ""
    rif = ('intOnInit(){if(InpModalita==NC_PDF){Print("[NatCla]AVVIORIFIUTATO:modalitaPDFesclusadaClaudioil07/10/2026:'
           'EaNat&Claseguesologliaudio");return(INIT_PARAMETERS_INCORRECT);}')
    if not oin.startswith(rif):
        bag.append("RACCORDO: OnInit non rifiuta InpModalita=PDF come prima istruzione con INIT_PARAMETERS_INCORRECT "
                   "e il messaggio della decisione del 07/10")
    # (29) v1.04 (cancello sulla v1.03): in AUDIO/EMA200 Risolvi rifiuta le manopole nate SOLO dal PDF (sulle variabili
    #      RISOLTE, dopo gBE e prima del magic), e il blocco NON tocca la scala AUDIO (InpPesiScala), lo stop (gSLCrit,
    #      asse A8) ne' il TP dal riempimento (gTPCrit==1, asse A1). Mutanti K1-K4.
    rb = ns(corpo(stc, "Risolvi"))
    attese29 = ["if(gIngresso==1)pdfx+=", "if(gTPCrit==2)pdfx+=", "if(gConferma)pdfx+=", "if(gChiudeVicino>0)pdfx+=",
                "if(InpTimingTocco!=NC_TIMING_IGNORA)pdfx+=", "if(gBE)pdfx+=", "if(InpParzialeTP1Pct>0)pdfx+=",
                "if(gRRMin>0)pdfx+=", "if(InpPesiPdf!=NC_PESI_1_1)pdfx+=", "if(gConfl==2)pdfx+="]
    i0, i1 = rb.find('stringpdfx="";'), rb.find('if(pdfx!=""){err="manopolenateSOLOdalPDF')
    ibe, imag = rb.find("gBE=DaModB("), rb.find("if(InpMagic==0)")
    blocco = rb[i0:i1] if 0 <= i0 < i1 else ""
    if not blocco or not (0 <= ibe < i0 and i1 < imag) or "+pdfx;returnfalse;}" not in rb[i1:i1 + 120]:
        bag.append("RACCORDO: Risolvi senza il blocco delle manopole solo-PDF (dopo gBE, prima del magic, con return false)")
    for c in attese29:
        if blocco.count(c) != 1:
            bag.append("RACCORDO: blocco solo-PDF senza '%s'" % c)
    if blocco.count("if(") != len(attese29) or any(t in blocco for t in ("InpPesiScala", "gSLCrit", "gTPCrit==1", "gTPCrit!=")):
        bag.append("RACCORDO: il blocco solo-PDF tocca altro (scala AUDIO, stop, TP dal riempimento o una condizione in piu')")
    # (30) v1.04: il magic automatico 7786+10*InpModalita+TF dipende dai VALORI dell'enum. NC_PDF=1 resta (escluso ma non
    #      cancellato) perche' AUDIO resti 77860x e EMA200 resti 77862x: un enum rinumerato sposterebbe il magic M2. Mutante K5.
    if not re.search(r"enumENUM_NC_MODALITA\{NC_AUDIO=0,NC_PDF=1,NC_EMA200=2\}", ns(code)):
        bag.append("RACCORDO: ENUM_NC_MODALITA non e' piu' AUDIO=0, PDF=1, EMA200=2 (il magic automatico di EMA200 si sposterebbe)")
    # (31) v1.05 (diagnosi NATCLA_DIAG_U30 07/10, classi 1170/1171): in CaricaDati il TOCCO dei tre handle che CaricaDati
    #      controlla (hEma200, hAtrN, hAdx), UNO per handle, 1 elemento a shift 1, viene PRIMA di ogni uscita e di ogni
    #      BarsCalculated; e' un'istruzione a se' (esito IGNORATO: niente if, niente assegnamento, niente confronto) e
    #      l'array del tocco non e' letto da nessuna parte. Dopo, i controlli di sempre, intatti. Mutanti T1-T7.
    cdm = corpo(code, "CaricaDati") or ""
    tocchi = list(re.finditer(r"\bCopyBuffer\s*\(\s*(\w+)\s*,\s*0\s*,\s*1\s*,\s*1\s*,\s*tocco\s*\)", cdm))
    if sorted(m.group(1) for m in tocchi) != ["hAdx", "hAtrN", "hEma200"]:
        bag.append("RACCORDO v1.05: il tocco in CaricaDati non e' uno per handle su hEma200, hAtrN, hAdx (trovati %s)" % [m.group(1) for m in tocchi])
    ibc = cdm.find("BarsCalculated(")
    mret = re.search(r"\breturn\b", cdm)
    for m in tocchi:
        if ibc < 0 or not mret or not (m.start() < ibc and m.start() < mret.start()):
            bag.append("RACCORDO v1.05: il tocco di %s non e' PRIMA di ogni uscita e di ogni BarsCalculated di CaricaDati" % m.group(1))
        prima, dopo = cdm[:m.start()].rstrip(), cdm[m.end():].lstrip()
        if not (prima.endswith(";") or prima.endswith("{")) or not dopo.startswith(";"):
            bag.append("RACCORDO v1.05: l'esito del tocco di %s e' usato (deve essere un'istruzione a se', esito ignorato)" % m.group(1))
    if not re.search(r"\bdouble\s+tocco\s*\[\s*1\s*\]\s*;", cdm) or len(re.findall(r"\btocco\b", cdm)) != 1 + len(tocchi) or len(re.findall(r"\btocco\b", code)) != len(re.findall(r"\btocco\b", cdm)):
        bag.append("RACCORDO v1.05: l'array del tocco non e' 'double tocco[1]' usato SOLO dai tocchi in CaricaDati")
    if "if(BarsCalculated(hEma200)<n+1||BarsCalculated(hAtrN)<n+1||BarsCalculated(hAdx)<n+1)returnfalse;" not in ns(cdm) or "if(n<NC_BARRE_MIN)returnfalse;" not in ns(cdm):
        bag.append("RACCORDO v1.05: i controlli di sempre di CaricaDati (n minimo, BarsCalculated dei tre handle) non sono intatti")
    if '#define NC_VER "1.11"' not in src or not re.search(r'#property\s+version\s+"1\.11"', src):
        bag.append("RACCORDO v1.11: NC_VER / #property version non sono 1.11")
    invarianti_stop(src, code, stc, bag)


def invarianti_stop(src, code, stc, bag):
    """v1.10 (decisione di Claudio 08/10): il RACCORDO della regola di stop nuova. Le funzioni pure sono provate in unitari() e
    sulle barre vere; qui si prova che il codice non puro le chiama coi dati giusti e che in GEOMETRIA_ATTUALE non fa niente di nuovo."""
    ns = lambda t: re.sub(r"\s+", "", t or "")
    # (32) enum: GEOMETRIA_ATTUALE=0 (il default), OLTRE_LINEA_ESTERNA=1 (NC_StopSetup riconosce SOLO 1)
    if not re.search(r"enumENUM_NC_STOPMODO\{NC_STOP_GEOMETRIA_ATTUALE=0,NC_STOP_OLTRE_LINEA_ESTERNA=1,NC_STOP_OLTRE_PIU_ESTERNA=2\}", ns(code)):
        bag.append("RACCORDO v1.11: ENUM_NC_STOPMODO non e' GEOMETRIA_ATTUALE=0, OLTRE_LINEA_ESTERNA=1, OLTRE_PIU_ESTERNA=2")
    # (33) ArmaScala: linea esterna e direzione lette SOLO in OLTRE, alla barra 'last', normalizzate come lv; esito 1 = SCARTO prima
    #      di ogni ordine (con Esito e return), esito 2 contato; il setup registra linea esterna ed esito.
    ar = ns(corpo(stc, "ArmaScala"))
    for a in ("doublelest=0,dest=0;", "intes=0;",
              "if(InpStopModo==NC_STOP_OLTRE_LINEA_ESTERNA){lest=NormPrezzo(LineaEsternaPrezzo(last,s));dest=gXD[last];}",
              "if(es==2)gImb[IMB_O_STOPX4]++;", "gSet[L].lineaStop=lest;gSet[L].stopEsito=es;",
              "if(InpStopModo==NC_STOP_OLTRE_PIU_ESTERNA){lest=NormPrezzo(LineaPiuEsternaPrezzo(L,last,s,dest));}"):
        if ar.count(a) != 1:
            bag.append("RACCORDO v1.10/v1.11: ArmaScala senza '%s'" % a)
    m33 = re.search(r"if\(es==1\)\{gImb\[IMB_O_STOPEST\]\+\+;.*?gArmatoPrima\[L\]=false;Esito\(IMB_NESSUNORD\);return;\}", ar)
    if not m33 or not (0 <= m33.start() < ar.find("ValidaOrdine(")):
        bag.append("RACCORDO v1.10: ArmaScala non SCARTA il setup con esito 1 (Esito IMB_NESSUNORD + return) PRIMA di validare gli ordini")
    # (34) ScriviConta: stessa lettura (senza NormPrezzo, come la v1.05), stop_ped a 0 se esito 1, tre colonne in coda
    sc = ns(corpo(stc, "ScriviConta"))
    for a in ("doublelest=0,dest=0;", "intes=0;", "if(InpStopModo==NC_STOP_OLTRE_LINEA_ESTERNA){lest=LineaEsternaPrezzo(last,s);dest=gXD[last];}",
              "if(InpStopModo==NC_STOP_OLTRE_PIU_ESTERNA){lest=LineaPiuEsternaPrezzo(L,last,s,dest);}",
              'D((ped>0&&es!=1)?MathAbs(p[0]-sl)/ped:0,1)', 'D((ped>0&&es!=1)?MathAbs(p[1]-sl)/ped:0,1)', 'D((ped>0&&es!=1)?MathAbs(p[2]-sl)/ped:0,1)',
              '"0;0;0;0;0;SOLO_CONTA;"+IntegerToString((int)InpStopModo)+";"+P(lest)+";"+IntegerToString(es);'):
        if sc.count(a) != 1:
            bag.append("RACCORDO v1.10: ScriviConta senza '%s'" % a)
    # (35) ScriviRiga: le tre colonne in coda vengono dal setup (modo dell'input, linea esterna ed esito registrati in ArmaScala)
    if '+motivo+";"+IntegerToString((int)InpStopModo)+";"+P(gSet[L].lineaStop)+";"+IntegerToString(gSet[L].stopEsito);' not in ns(corpo(stc, "ScriviRiga")):
        bag.append("RACCORDO v1.10: ScriviRiga senza le colonne stop_modo/linea_stop/stop_esito in coda")
    if not re.search(r'FileWrite\(gFh,"tipo;[^"]*;durata_min;motivo;stop_modo;linea_stop;stop_esito"\)', src):
        bag.append("RACCORDO v1.10: intestazione del CSV senza ';stop_modo;linea_stop;stop_esito' IN CODA dopo 'motivo'")
    # (36) OnNewBar: la linea esterna si calcola SOLO in OLTRE, DOPO la linea di setup e PRIMA della valutazione
    nb = ns(corpo(code, "OnNewBar"))
    if ("CalcolaLinea(L);if(InpStopModo==NC_STOP_OLTRE_LINEA_ESTERNA)CalcolaLineaEsterna(L);if(InpStopModo==NC_STOP_OLTRE_PIU_ESTERNA)CalcolaLineaEsterna(L);"
            "if(gIngresso==0)ValutaScala(L);") not in nb:
        bag.append("RACCORDO v1.10/v1.11: OnNewBar non calcola la linea esterna (solo nei due modi OLTRE) fra CalcolaLinea e ValutaScala")
    # (37) CalcolaLineaEsterna: famiglia da NC_FamigliaStop; EMA200 = gEma + NC_EmaDir; Supertrend = NC_STCore col MOLTIPLICATORE
    #      della famiglia (gMultLinea[F] = InpStMult3) e lo STESSO periodo ATR della linea di setup; array PROPRI (gLV/gLD intatti)
    ce = ns(corpo(code, "CalcolaLineaEsterna"))
    for a in ("intF=NC_FamigliaStop(L);", "if(F==NC_LEMA){for(inti=0;i<gN;i++)gXV[i]=gEma[i];NC_EmaDir(gC,gEma,gN,gXD);return;}",
              "NC_STCore(gH,gL,gC,gN,0,InpStAtrPeriodo,gMultLinea[F],gXa,gXu,gXdn,gXD,gXV);",
              "if(InpStopModo==NC_STOP_OLTRE_PIU_ESTERNA){ArrayResize(gXE,gN);NC_EmaDir(gC,gEma,gN,gXE);}"):
        if a not in ce:
            bag.append("RACCORDO v1.10: CalcolaLineaEsterna senza '%s'" % a)
    if re.search(r"\bg(LV|LD|Wa|Wu|Wd)\b", ce):
        bag.append("RACCORDO v1.10: CalcolaLineaEsterna tocca gli array della linea di setup (gLV/gLD/gWa/gWu/gWd)")
    if "returngXV[k]+s*InpPlaceboAtr*gAtrN[k];" not in ns(corpo(code, "LineaEsternaPrezzo")):
        bag.append("RACCORDO v1.10: LineaEsternaPrezzo non e' gXV[k] + s x placebo x ATR[k] (stessa regola di LineaPrezzo)")
    # (42) v1.11: LineaPiuEsternaPrezzo = EMA200 sola in M2; nei Supertrend NC_PiuEsterna fra ST3,5 (gXV/gXD, placebo) ed EMA200
    #      (gEma/gXE, STESSO placebo), alla barra k e col lato s
    if ns(corpo(code, "LineaPiuEsternaPrezzo")) != ns("doubleLineaPiuEsternaPrezzo(constintL,constintk,constints,double&dir){if(NC_FamigliaStop(L)==NC_LEMA){dir=gXD[k];returnLineaEsternaPrezzo(k,s);}"
                                                      "returnNC_PiuEsterna(s,LineaEsternaPrezzo(k,s),gXD[k],gEma[k]+s*InpPlaceboAtr*gAtrN[k],gXE[k],dir);}"):
        bag.append("RACCORDO v1.11: LineaPiuEsternaPrezzo non e' (M2: EMA200 sola; Supertrend: NC_PiuEsterna fra ST3,5 ed EMA200 col placebo su entrambe)")
    # (38) gXD/gXV letti SOLO dentro i rami OLTRE (in GEOMETRIA_ATTUALE non sono nemmeno dimensionati)
    letti = [m.start() for m in re.finditer(r"\bgX[VDE]\s*\[\s*[^\]\s]", code)]      # [] vuote = dichiarazione, non lettura
    for fn in ("CalcolaLineaEsterna", "LineaEsternaPrezzo", "LineaPiuEsternaPrezzo", "ArmaScala", "ScriviConta"):
        b = corpo(code, fn) or ""
        k = code.find(b) if b else -1
        letti = [x for x in letti if not (k >= 0 and k <= x < k + len(b))]
    if letti:
        bag.append("RACCORDO v1.10/v1.11: gXV/gXD/gXE letti fuori dalle cinque funzioni della regola di stop (%d punti)" % len(letti))
    # (39) Risolvi: in OLTRE rifiuta InpStopOltreU <= 0 e InpSLCriterio impostato a mano (due regole di stop)
    rb = ns(corpo(stc, "Risolvi"))
    for a in ('if(InpStopModo!=NC_STOP_GEOMETRIA_ATTUALE){if(!(InpStopOltreU>0)){err=', 'if(InpSLCriterio!=NC_SL_DA_MODALITA){err='):
        if a not in rb:
            bag.append("RACCORDO v1.10: Risolvi senza '%s'" % a)
    # (40) riga d'avvio e #cfg;Stop: il modo stampato e' quello dell'input
    sd = ns(corpo(stc, "StopDescr"))
    if sd != ns('stringStopDescr(){if(InpStopModo==NC_STOP_OLTRE_LINEA_ESTERNA)return"OLTRE_LINEA_ESTERNA "+DoubleToString(InpStopOltreU,2)+" u";'
                'if(InpStopModo==NC_STOP_OLTRE_PIU_ESTERNA)return"OLTRE_PIU_ESTERNA "+DoubleToString(InpStopOltreU,2)+" u";return"GEOMETRIA_ATTUALE";}'):
        bag.append("RACCORDO v1.10: StopDescr non stampa il modo dell'input (OLTRE_LINEA_ESTERNA N u / GEOMETRIA_ATTUALE)")
    if 'Cfg("Stop",StopDescr(),' not in ns(corpo(stc, "StampaConfigurazione")):
        bag.append("RACCORDO v1.10: manca la riga #cfg;Stop nel CSV / CFG Stop nel Giornale")
    # (41) EntraPdf (codice morto) NON chiama la regola nuova: il PDF resta escluso e la sua geometria e' quella della v1.04
    # (43) v1.11: NC_StopSetup tratta il modo 2 come il modo 1 (stessa regola, linea scelta dal chiamante); ogni altro modo e' NC_Stop
    if "if(modo!=1&&modo!=2)returnNC_Stop(criterio,s,linea,profondo,estremo,buf);" not in ns(corpo(code, "NC_StopSetup")):
        bag.append("RACCORDO v1.11: NC_StopSetup non riserva NC_Stop ai modi diversi da 1 e 2")
    if "NC_StopSetup" in (corpo(code, "EntraPdf") or ""):
        bag.append("RACCORDO v1.10: EntraPdf (codice morto del PDF) chiama NC_StopSetup")


def magic_libero():
    # v1.05: escluse anche le cartelle/file del passo F0 e della diagnosi di Nat&Cla (sono file Nat&Cla: citano i SUOI magic).
    # Prima di questa riga il collaudo usciva ROSSO (1 controllo) per tre righe di collaudo_natcla_f0/ (banco, bootstrap, prova_pins).
    r = subprocess.run(["git", "-C", ROOT, "grep", "-nE", r"\b7786[0-9]{2}\b", "--", ".",
                        ":!.claude", ":!mql5/Experts/EA_NatCla.mq5", ":!mql5/Experts/EA_NatCla_Diag.mq5", ":!backtest_pipeline/collaudo_natcla.py",
                        ":!backtest_pipeline/collaudo_natcla_diag.py", ":!backtest_pipeline/collaudo_natcla_f0", ":!backtest_pipeline/leggi_natcla_f0.py",
                        ":!backtest_pipeline/righe/NATCLA_*", ":!backtest_pipeline/righe/RIGA_LANCIA_NATCLA_*", ":!backtest_pipeline/prove/NATCLA_*",
                        ":!backtest_pipeline/risultati_archivio/NATCLA_*", ":!report/NATCLA_*", ":!data/natcla",
                        # cancello 07/10 notte: il referto della giornata del 07/10 CITA la regola del magic di Nat&Cla (r.120-121, '778600 + 10*modalita'...',
                        # 'blocco 778600-778699'): e' una citazione, non un EA che usa il blocco. Senza questa riga il collaudo usciva ROSSO (1 controllo) gia' al pin
                        # d6586360, mentre l'ESITO dichiarava 'TUTTO OK'. Esclusione per NOME del file, non per estensione: un .md che ASSEGNASSE il blocco a un altro EA
                        # (registro dei magic, censimento) deve restare visibile.
                        ":!report/giornata_2026-10-07.md",
                        # v1.10 (09/10): la nota EA_GBA del 09/10 r.94 CITA un CSV di Nat&Cla per nome ('natcla_setup_XAUUSD_778601.csv', '778621'):
                        # citazione di un file Nat&Cla, non un EA che usa il blocco. Il collaudo era gia' ROSSO per questa riga PRIMA della v1.10
                        # (misurato sulla v1.05 il 09/10). Esclusione per NOME del file, come sopra.
                        ":!report/EA_GBA_NOTE_2026-10-09.md"], capture_output=True, text=True)
    return [ln for ln in r.stdout.splitlines() if ln.strip()]


# ===========================================================================
# P) FUNZIONI PURE in C++
# ===========================================================================
SHIM_EXTRA = "inline double MathPow(double a,double b){ return std::pow(a,b); }\n"

DRIVER = r'''
#include "shim.h"
#include "pure.mqh"
static std::vector<double> rd(int n){ std::vector<double> v(n); for(int i=0;i<n;i++) if(scanf("%lf",&v[i])!=1) exit(2); return v; }
int main(){
  char cmd[32];
  while(scanf("%31s",cmd)==1){
    std::string c(cmd);
    if(c=="SERIE"){
      int n,per,defT,reset; double m0,m1,m2,sf,pl,dist;
      if(scanf("%d %d %lf %lf %lf %d %lf %lf %d %lf",&n,&per,&m0,&m1,&m2,&defT,&sf,&pl,&reset,&dist)!=10) return 2;
      std::vector<double> H=rd(n),Lo=rd(n),C=rd(n),E=rd(n),A=rd(n);
      double mu[3]={m0,m1,m2};
      for(int L=0;L<4;L++){
        std::vector<double> a(n),u(n),d(n),dr(n),v(n);
        if(L<3) NC_STCore(H.data(),Lo.data(),C.data(),n,0,per,mu[L],a.data(),u.data(),d.data(),dr.data(),v.data());
        else { v=E; NC_EmaDir(C.data(),E.data(),n,dr.data()); }
        for(int i=0;i<n;i++){
          int seg,ne,tl,ei; bool nu;
          bool ok=NC_Episodi(H.data(),Lo.data(),C.data(),v.data(),dr.data(),A.data(),0,i,defT,sf,pl,reset,dist,seg,ne,tl,nu,ei);
          printf("%a %a %d %d %d %d %d %d\n",v[i],dr[i],ok?1:0,seg,ne,tl,nu?1:0,ei);
        }
      }
    } else if(c=="FIN"){
      int n,per,W,step; double mu;
      if(scanf("%d %d %lf %d %d",&n,&per,&mu,&W,&step)!=5) return 2;
      std::vector<double> H=rd(n),Lo=rd(n),C=rd(n),A=rd(n);
      std::vector<double> a(n),u(n),d(n),dr(n),v(n);
      NC_STCore(H.data(),Lo.data(),C.data(),n,0,per,mu,a.data(),u.data(),d.data(),dr.data(),v.data());
      int casi=0,mv=0,me=0,tr=0;
      for(int e=W-1;e<n;e+=step){
        int o=e-W+1; casi++;
        std::vector<double> a2(W),u2(W),d2(W),dr2(W),v2(W);
        NC_STCore(H.data()+o,Lo.data()+o,C.data()+o,W,0,per,mu,a2.data(),u2.data(),d2.data(),dr2.data(),v2.data());
        if(v2[W-1]!=v[e] || dr2[W-1]!=dr[e]) mv++;
        int s1,n1,t1,e1,s2,n2,t2,e2; bool u1,u2b;
        bool k1=NC_Episodi(H.data(),Lo.data(),C.data(),v.data(),dr.data(),A.data(),0,e,0,0.0,0.0,0,1.0,s1,n1,t1,u1,e1);
        bool k2=NC_Episodi(H.data()+o,Lo.data()+o,C.data()+o,v2.data(),dr2.data(),A.data()+o,0,W-1,0,0.0,0.0,0,1.0,s2,n2,t2,u2b,e2);
        if(k2 && s2==0) tr++;
        if(k1!=k2 || n1!=n2 || t1!=t2 || u1!=u2b || (e1>=0 ? e1!=e2+o : e2!=-1)) me++;
      }
      printf("%d %d %d %d\n",casi,mv,me,tr);
    } else if(c=="STOP"){
      int cr,s; double li,pr,es,bu; if(scanf("%d %d %lf %lf %lf %lf",&cr,&s,&li,&pr,&es,&bu)!=6) return 2;
      printf("%a\n",NC_Stop(cr,s,li,pr,es,bu));
    } else if(c=="STOPSET"){
      int mo,cr,s,e=-7; double li,pr,es,bu,le,de,ol;
      if(scanf("%d %d %d %lf %lf %lf %lf %lf %lf %lf",&mo,&cr,&s,&li,&pr,&es,&bu,&le,&de,&ol)!=10) return 2;
      double r=NC_StopSetup(mo,cr,s,li,pr,es,bu,le,de,ol,e); printf("%a %d %a\n",r,e,NC_Stop(cr,s,li,pr,es,bu));
    } else if(c=="PIU"){
      int s; double v1,d1,v2,d2; if(scanf("%d %lf %lf %lf %lf",&s,&v1,&d1,&v2,&d2)!=5) return 2;
      double dp=-7; double lp=NC_PiuEsterna(s,v1,d1,v2,d2,dp); printf("%a %a\n",lp,dp);
    } else if(c=="STOP2"){
      int cr,s,e=-7; double li,pr,es,bu,v1,d1,v2,d2,ol;
      if(scanf("%d %d %lf %lf %lf %lf %lf %lf %lf %lf %lf",&cr,&s,&li,&pr,&es,&bu,&v1,&d1,&v2,&d2,&ol)!=11) return 2;
      double dp=-7; double lp=NC_PiuEsterna(s,v1,d1,v2,d2,dp);
      double r=NC_StopSetup(2,cr,s,li,pr,es,bu,lp,dp,ol,e); printf("%a %a %a %d\n",lp,dp,r,e);
    } else if(c=="FAM"){
      int L; if(scanf("%d",&L)!=1) return 2; printf("%d\n",NC_FamigliaStop(L));
    } else if(c=="TPEMA"){
      int s; double in,sl,e14,e89,rr; if(scanf("%d %lf %lf %lf %lf %lf",&s,&in,&sl,&e14,&e89,&rr)!=6) return 2;
      double t1=-1; double t=NC_TpEma(s,in,sl,e14,e89,rr,t1); printf("%a %a\n",t,t1);
    } else if(c=="TPFISSO"){
      int cr,s; double li,in,di; if(scanf("%d %d %lf %lf %lf",&cr,&s,&li,&in,&di)!=5) return 2;
      printf("%a\n",NC_TpFisso(cr,s,li,in,di));
    } else if(c=="VALIDO"){
      int s; double in,sl,tp,mu,rr; if(scanf("%d %lf %lf %lf %lf %lf",&s,&in,&sl,&tp,&mu,&rr)!=6) return 2;
      printf("%d\n",NC_OrdineValido(s,in,sl,tp,mu,rr));
    } else if(c=="LOTTO"){
      double v,st,mn,mx; if(scanf("%lf %lf %lf %lf",&v,&st,&mn,&mx)!=4) return 2;
      printf("%a\n",NC_LottoGiu(v,st,mn,mx));
    } else if(c=="LOTTI"){
      double R,st,mn,mx; int n; if(scanf("%lf %d",&R,&n)!=2) return 2;
      std::vector<double> w=rd(n),pl=rd(n); if(scanf("%lf %lf %lf",&st,&mn,&mx)!=3) return 2;
      std::vector<double> lo(n); NC_LottiSetup(R,w.data(),pl.data(),n,st,mn,mx,lo.data());
      for(int i=0;i<n;i++) printf("%a ",lo[i]); printf("\n");
    } else if(c=="CTX"){
      int s,aa,iu,iv,cf; double adx,am,inc,im,dc,ct;
      if(scanf("%d %d %lf %lf %d %lf %lf %d %d %lf %lf",&s,&aa,&adx,&am,&iu,&inc,&im,&iv,&cf,&dc,&ct)!=11) return 2;
      printf("%d\n",NC_Contesto(s,aa!=0,adx,am,iu!=0,inc,im,iv,cf,dc,ct));
    } else if(c=="SCALA"){
      int s; double li,an,ol,u; if(scanf("%lf %d %lf %lf %lf",&li,&s,&an,&ol,&u)!=5) return 2;
      double p[3]; NC_PrezziScala(li,s,an,ol,u,p); printf("%a %a %a\n",p[0],p[1],p[2]);
    } else if(c=="PESO"){
      int a,b,i; if(scanf("%d %d %d",&a,&b,&i)!=3) return 2; printf("%a\n",NC_Peso(a,b,i));
    } else if(c=="META"){
      long long x,y; if(scanf("%lld %lld",&x,&y)!=2) return 2; printf("%d\n",NC_MetaTocco(x,y));
    } else if(c=="CIFRE"){
      double s; if(scanf("%lf",&s)!=1) return 2; printf("%d\n",NC_CifreLotto(s));
    } else if(c=="EMADIR"){
      int n; if(scanf("%d",&n)!=1) return 2; std::vector<double> C=rd(n),E=rd(n),d(n);
      NC_EmaDir(C.data(),E.data(),n,d.data()); for(int i=0;i<n;i++) printf("%a ",d[i]); printf("\n");
    } else if(c=="INCL"){
      int n,i,nb; if(scanf("%d %d %d",&n,&i,&nb)!=3) return 2; std::vector<double> E=rd(n),A=rd(n);
      printf("%a\n",NC_Inclinazione(E.data(),A.data(),i,nb));
    } else if(c=="TOCCO"){
      int n,i,defT; double sf,pl; if(scanf("%d %d %d %lf %lf",&n,&i,&defT,&sf,&pl)!=5) return 2;
      std::vector<double> H=rd(n),Lo=rd(n),C=rd(n),V=rd(n),D=rd(n),A=rd(n);
      printf("%d\n",NC_Tocco(H.data(),Lo.data(),C.data(),V.data(),D.data(),A.data(),i,defT,sf,pl));
    } else if(c=="PIP"){
      int d; double p; if(scanf("%d %lf",&d,&p)!=2) return 2; printf("%a\n",NC_Pip(d,p));
    } else if(c=="LATO"){
      int d,s; if(scanf("%d %d",&d,&s)!=2) return 2; printf("%d\n",NC_LatoAmmesso(d,s)?1:0);
    } else if(c=="RISCHIO"){
      double sa,pc,mo,dc,to,mx; if(scanf("%lf %lf %lf %lf %lf %lf",&sa,&pc,&mo,&dc,&to,&mx)!=6) return 2;
      printf("%a\n",NC_RischioSoldi(sa,pc,mo,dc,to,mx));
    } else if(c=="PEND"){
      int s; double pr,sl,tp,ak,bd,md; if(scanf("%d %lf %lf %lf %lf %lf %lf",&s,&pr,&sl,&tp,&ak,&bd,&md)!=7) return 2;
      printf("%d\n",NC_ControllaPendente(s,pr,sl,tp,ak,bd,md));
    } else if(c=="ADX"){
      int n,per,tipo; if(scanf("%d %d %d",&n,&per,&tipo)!=3) return 2;
      std::vector<double> H=rd(n),Lo=rd(n),C=rd(n);
      printf("%a\n",NC_AdxUltimo(H.data(),Lo.data(),C.data(),n,per,tipo));
    } else return 3;
    fflush(stdout);
  }
  return 0;
}
'''


def blocco_puro(src):
    a = src.index("//@@NC_PURE_BEGIN")
    b = src.index("//@@NC_PURE_END")
    return src[a:b]


class Cxx:
    def __init__(self, src, tmp):
        self.ok, self.err = False, ""
        cxx = shutil.which("g++") or shutil.which("clang++")
        if not cxx:
            self.err = "g++ assente"
            return
        os.makedirs(tmp, exist_ok=True)
        for nm, txt in (("shim.h", CG.SHIM + SHIM_EXTRA), ("pure.mqh", CG.to_cxx(blocco_puro(src))), ("drv.cpp", DRIVER)):
            with open(os.path.join(tmp, nm), "w") as f:
                f.write(txt)
        self.exe = os.path.join(tmp, "drv")
        r = subprocess.run([cxx, "-std=c++17", "-O2", "-ffp-contract=off", "-Wall", "-o", self.exe,
                            os.path.join(tmp, "drv.cpp")], capture_output=True, text=True)
        self.err = r.stderr
        self.ok = (r.returncode == 0)

    def run(self, text):
        r = subprocess.run([self.exe], input=text, capture_output=True, text=True)
        if r.returncode != 0:
            raise RuntimeError("driver C++ uscito con %d" % r.returncode)
        return r.stdout.strip("\n").split("\n")


def fx(x):
    return float.fromhex(x)


# ===========================================================================
# T) IL TESTER PIGRO (v1.05, diagnosi NATCLA_DIAG_U30 del 07/10): CaricaDati VERA, estratta dal sorgente, compilata in C++
#    contro quattro modelli di come il terminale calcola gli indicatori. Non e' MT5: e' la spiegazione dei numeri misurati.
#    MODELLO 0 PIGRO SINCRONO  = quello che RIPRODUCE i sei numeri della diagnosi (risultati_archivio/NATCLA_DIAG_U30_20261007):
#             alla creazione (OnInit) un handle e' calcolato se le barre bastano (ATR/ADX si', EMA200 con 116 barre no: min_bc
#             -1/116/116); dopo, un handle si ricalcola SOLO quando qualcuno chiede un suo buffer, e con meno barre del periodo
#             resta -1 (in (a) BarsCalculated cade 84 volte = barre 117..200, CopyBuffer 83 = 117..199, e alla barra 302
#             bc=301/301/301 = calcolato all'evento prima).
#    MODELLO 1 PIGRO DIFFERITO = la richiesta viene servita all'evento DOPO (variante: la conclusione non deve dipendere da questo).
#    MODELLO 2 ZELANTE         = ricalcola tutto a ogni evento (il terminale dal vivo): v1.04 e v1.05 devono dare la STESSA sequenza.
#    MODELLO 3 CONTRO-ESEMPIO  = un tester che ricalcola SOLO per richieste di PIU' di 1 elemento: li' il tocco NON basta.
#             Dichiarato: se il tester vero fosse cosi', il lotto C0 lo vede (niente VERIFICA ADX, zero CONTA) e il lotto C resta fermo.
# ===========================================================================
MODELLO_CPP = r'''
#include <vector>
#include <cstdio>
#include <cstdlib>
typedef long long datetime;
struct MqlRates { datetime time; double open, high, low, close; long long tick_volume; int spread; long long real_volume; };
static const char* _Symbol = "SIM";
static int gTF = 16385;
#define NC_BARRE 1500
#define NC_BARRE_MIN 300
static int MODELLO = 0;
static int BARS = 0;
static const int PER[4] = {0, 200, 14, 28};      // EMA200, ATR14, ADX14 (DI + media: ~2 x 14 barre)
static int CALC[4] = {0, -1, -1, -1};
static bool PEND[4] = {false, false, false, false};
static long long NRICH[4] = {0, 0, 0, 0};
static int hEma200 = 1, hAtrN = 2, hAdx = 3;
static std::vector<double> gO, gH, gL, gC, gEma, gAtrN, gAdx, gLV, gLD, gWa, gWu, gWd;
static std::vector<datetime> gT;
static int gN = 0;
static void calcola(int h){ CALC[h] = (BARS >= PER[h]) ? BARS : -1; }
static int Bars(const char*, int){ return BARS; }
static int BarsCalculated(int h){ return (h >= 1 && h <= 3) ? CALC[h] : -1; }
static int richiesta(int h, int start, int count){
  if(h < 1 || h > 3) return -1;
  NRICH[h]++;
  bool scatta = (MODELLO == 0 || MODELLO == 1) || (MODELLO == 3 && count > 1);
  if(scatta){ if(MODELLO == 1) PEND[h] = true; else calcola(h); }
  return (CALC[h] >= start + count) ? count : -1;      // -1 = 4806, dati non pronti
}
template<size_t N> static int CopyBuffer(int h, int, int start, int count, double (&a)[N]){
  int r = richiesta(h, start, count); if(r > 0) for(int i = 0; i < r && i < (int)N; i++) a[i] = 1.0; return r; }
static int CopyBuffer(int h, int, int start, int count, std::vector<double>& a){
  int r = richiesta(h, start, count); if(r > 0) a.assign(r, 1.0); return r; }
static int CopyRates(const char*, int, int start, int count, std::vector<MqlRates>& r){
  if(BARS < start + count) return -1; r.assign(count, MqlRates()); return count; }
template<class T> static bool ArraySetAsSeries(T&, bool){ return true; }
template<class T> static int ArrayResize(std::vector<T>& v, int n){ v.resize(n); return n; }
//@@CARICADATI@@
int main(int argc, char** argv){
  if(argc != 4) return 2;
  MODELLO = atoi(argv[1]); int b0 = atoi(argv[2]); int nuove = atoi(argv[3]);
  BARS = b0;
  for(int h = 1; h <= 3; h++) calcola(h);             // creazione degli handle in OnInit
  long long ok = 0, primo = -1, cade_n = 0; unsigned long long firma = 1469598103934665603ULL;
  for(int k = 1; k <= nuove; k++){
    BARS = b0 + k;
    if(MODELLO == 1) for(int h = 1; h <= 3; h++) if(PEND[h]){ calcola(h); PEND[h] = false; }
    if(MODELLO == 2) for(int h = 1; h <= 3; h++) calcola(h);
    int n = (BARS - 2 < NC_BARRE) ? BARS - 2 : NC_BARRE;
    if(n < NC_BARRE_MIN) cade_n++;
    bool r = CaricaDati();
    if(r){ ok++; if(primo < 0) primo = BARS; }
    firma = (firma ^ (unsigned long long)(r ? 1 : 0)) * 1099511628211ULL;
  }
  printf("%lld %lld %lld %llu %lld %lld %lld\n", ok, primo, cade_n, firma, NRICH[1], NRICH[2], NRICH[3]);
  return 0;
}
'''

# i numeri MISURATI dalla diagnosi (riga RIASSUNTO completa di ogni passata), scritti qui PRIMA di girare il modello:
# (barre alla creazione = barre del primo evento - 1, nuove barre, cd_ok, primo_ok_barre, cd_n)
DIAG_U30 = (116, 9946, 9761, 302, 185)        # (a) con verifiche separate = guarisce; (e) catena fedele = cd_ok 0, cd_bc 9761
DIAG_D30 = (115, 9639, 9453, 302, 186)        # (c) / (f)
DIAG_U30_STORIA = (1462, 8600, 8600, 1463, 0)  # (b) storia davanti: dalla prima barra


def tocchi_via(cd):
    """CaricaDati SENZA il tocco (= la catena della v1.04): via la dichiarazione e le istruzioni 'CopyBuffer(...,tocco);'"""
    cd = re.sub(r"[ \t]*double\s+tocco\s*\[\s*1\s*\]\s*;[^\n]*\n", "", cd)
    return re.sub(r"[ \t]*CopyBuffer\s*\(\s*\w+\s*,\s*0\s*,\s*1\s*,\s*1\s*,\s*tocco\s*\)\s*;[^\n]*\n", "", cd)


class ModelloTester:
    def __init__(self, cd_testo, tmp):
        self.ok, self.err = False, ""
        cxx = shutil.which("g++") or shutil.which("clang++")
        if not cxx or not cd_testo:
            self.err = "g++ assente o CaricaDati non trovata"
            return
        os.makedirs(tmp, exist_ok=True)
        cd = re.sub(r"\bMqlRates\s+(\w+)\s*\[\s*\]\s*;", r"std::vector<MqlRates> \1;", cd_testo)
        cpp = os.path.join(tmp, "modello.cpp")
        with open(cpp, "w") as f:
            f.write(MODELLO_CPP.replace("//@@CARICADATI@@", "static " + cd.lstrip()))
        self.exe = os.path.join(tmp, "modello")
        r = subprocess.run([cxx, "-std=c++17", "-O2", "-o", self.exe, cpp], capture_output=True, text=True)
        self.err = r.stderr
        self.ok = (r.returncode == 0)

    def gira(self, modello, b0, nuove):
        r = subprocess.run([self.exe, str(modello), str(b0), str(nuove)], capture_output=True, text=True)
        if r.returncode != 0:
            raise RuntimeError("modello del tester uscito con %d" % r.returncode)
        ok, primo, cade_n, firma, r1, r2, r3 = r.stdout.split()
        return dict(ok=int(ok), primo=int(primo), cade_n=int(cade_n), firma=firma, rich=(int(r1), int(r2), int(r3)))


def tester_pigro(src, tmp, bag, verbose):
    """CaricaDati del sorgente (v1.05) e la stessa SENZA il tocco (v1.04 per costruzione) nei quattro modelli"""
    cd5 = corpo(src, "CaricaDati")
    if not cd5:
        bag.append("MODELLO: CaricaDati non trovata nel sorgente")
        return
    cd4 = tocchi_via(cd5)
    m5, m4 = ModelloTester(cd5, os.path.join(tmp, "v105")), ModelloTester(cd4, os.path.join(tmp, "v104"))
    if not (m5.ok and m4.ok):
        bag.append("MODELLO: CaricaDati non compila nel modello del tester (%s)" % (m5.err or m4.err)[:200])
        return
    b0, nu, okd, prd, cnd = DIAG_U30
    a4, a5 = m4.gira(0, b0, nu), m5.gira(0, b0, nu)
    check(a4["ok"] == 0 and a4["cade_n"] == cnd and a4["rich"][0] == 0,
          "MODELLO 0 (pigro sincrono) U30USD, catena SENZA tocco (= v1.04, = passata (e)): %d barre valutate (misurato 0), %d con n<300 (misurato %d), "
          "%d richieste di buffer EMA200 (stallo: mai una)" % (a4["ok"], a4["cade_n"], cnd, a4["rich"][0]), quiet=not verbose, bag=bag)
    check(a5["ok"] == okd and a5["primo"] == prd,
          "MODELLO 0 U30USD, v1.05 col tocco: %d barre valutate dalla barra %d (misurato in (a) con le richieste separate: %d dalla %d)"
          % (a5["ok"], a5["primo"], okd, prd), quiet=not verbose, bag=bag)
    b0, nu, okd, prd, cnd = DIAG_D30
    d4, d5 = m4.gira(0, b0, nu), m5.gira(0, b0, nu)
    check(d4["ok"] == 0 and d5["ok"] == okd and d5["primo"] == prd and d5["cade_n"] == cnd,
          "MODELLO 0 D30EUR: v1.04 %d (misurato (f) 0), v1.05 %d dalla barra %d (misurato (c) %d dalla %d)" % (d4["ok"], d5["ok"], d5["primo"], okd, prd),
          quiet=not verbose, bag=bag)
    b0, nu, okd, prd, cnd = DIAG_U30_STORIA
    s4, s5 = m4.gira(0, b0, nu), m5.gira(0, b0, nu)
    check(s4["ok"] == okd and s4["primo"] == prd and s4["firma"] == s5["firma"] and s5["ok"] == okd,
          "MODELLO 0 U30USD con storia davanti (= (b)): v1.04 %d dalla %d, v1.05 IDENTICA barra per barra (%s) -- misurato %d dalla %d"
          % (s4["ok"], s4["primo"], "si" if s4["firma"] == s5["firma"] else "NO", okd, prd), quiet=not verbose, bag=bag)
    b0, nu, okd, prd, cnd = DIAG_U30
    f4, f5 = m4.gira(1, b0, nu), m5.gira(1, b0, nu)
    check(f4["ok"] == 0 and f5["ok"] == okd and f5["primo"] == prd,
          "MODELLO 1 (pigro DIFFERITO, variante): v1.04 %d, v1.05 %d dalla barra %d (la conclusione non dipende da sincrono/differito)"
          % (f4["ok"], f5["ok"], f5["primo"]), quiet=not verbose, bag=bag)
    z4, z5 = m4.gira(2, b0, nu), m5.gira(2, b0, nu)
    check(z4["firma"] == z5["firma"] and z4["ok"] == z5["ok"] == okd,
          "MODELLO 2 (zelante = dal vivo): v1.04 e v1.05 IDENTICHE barra per barra (%d e %d barre valutate): il tocco non cambia il comportamento dal vivo"
          % (z4["ok"], z5["ok"]), quiet=not verbose, bag=bag)
    c4, c5 = m4.gira(3, b0, nu), m5.gira(3, b0, nu)
    check(c4["ok"] == 0 and c5["ok"] == 0,
          "CONTRO-ESEMPIO MODELLO 3 (ricalcola solo per richieste di PIU' elementi): v1.05 resta bloccata (%d barre): il tocco di 1 elemento NON basta li'. "
          "Dichiarato: lo decide il lotto C0 (VERIFICA ADX e righe CONTA)" % c5["ok"], quiet=not verbose, bag=bag)
    cr = m5.gira(0, b0, nu)["rich"]
    check(cr[0] >= nu and cr[1] >= nu and cr[2] >= nu,
          "CARICO: con la v1.05 ogni handle e' chiesto a ogni barra (EMA200 %d, ATR %d, ADX %d richieste su %d barre): 3 copie di 1 elemento in piu' per barra"
          % (cr[0], cr[1], cr[2], nu), quiet=not verbose, bag=bag)


def py_stop_v105(cr, s, li, pr, es, bu):
    """specchio di X1-X4 scritto dalla SPECIFICA (non copiato dal C++): base = ordine profondo + buffer; criterio 1 = estremo + buffer,
    2 = linea + buffer, altrimenti la base; si tiene il piu' LONTANO dal prezzo (long: il piu' basso, short: il piu' alto)"""
    base = pr - s * bu
    cand = {1: es - s * bu, 2: li - s * bu}.get(cr, base)
    return min(cand, base) if s > 0 else max(cand, base)


def py_stop_oltre(s, pr, bu, le, de, ol):
    """specchio della regola di Claudio (08/10) scritto dalla decisione: lo stop sta 'ol' OLTRE la linea esterna, dal lato del rischio;
    la linea esterna deve stare dal lato del setup (direzione == s) e valere > 0; X4 resta (mai piu' vicino dell'ordine profondo + buffer).
    Ritorna (stop, esito): esito 1 = scartato (stop 0), 2 = vince X4, 0 = regola."""
    if de != s or not le > 0:
        return 0.0, 1
    cand = le - s * ol
    x4 = pr - s * bu
    lontano = min(cand, x4) if s > 0 else max(cand, x4)
    esito = 0 if lontano == cand else 2
    if not lontano > 0:
        return 0.0, 1
    return lontano, esito


def py_piu_esterna(s, v1, d1, v2, d2):
    """specchio della v1.11 scritto dalla decisione: fra ST3,5 (v1, d1) ed EMA200 (v2, d2) si tengono SOLO le linee dal lato del setup
    (direzione == s, valore > 0); long la piu' bassa, short la piu' alta. Nessuna -> (0, 0): il setup si scarta come nella v1.10."""
    cand = [v for v, d in ((v1, d1), (v2, d2)) if d == s and v > 0]
    if not cand:
        return 0.0, 0.0
    return (min(cand) if s > 0 else max(cand)), float(s)


def stop_v111_unitari(cx, bag):
    """v1.11: NC_PiuEsterna e la catena NC_PiuEsterna -> NC_StopSetup(2, ...). Valori attesi scritti qui."""
    def one(cmd):
        return cx.run(cmd + "\n")[0].split()
    casi = [("PIU 1 95 1 90 1", 90.0, 1.0, "long, tutte e due dal lato del setup: la piu' BASSA (EMA200)"),
            ("PIU 1 85 1 90 1", 85.0, 1.0, "long: la piu' bassa e' la ST3,5"),
            ("PIU -1 105 -1 110 -1", 110.0, -1.0, "short: la piu' ALTA"),
            ("PIU 1 95 1 120 -1", 95.0, 1.0, "long, EMA200 dal lato opposto (sopra il prezzo): resta la ST3,5"),
            ("PIU 1 120 -1 90 1", 90.0, 1.0, "long, ST3,5 dal lato opposto: resta la EMA200"),
            ("PIU 1 120 -1 130 -1", 0.0, 0.0, "long, tutte e due dal lato opposto: nessuna (scarto)"),
            ("PIU -1 90 1 110 -1", 110.0, -1.0, "short, ST3,5 dal lato opposto: EMA200"),
            ("PIU -1 90 1 80 1", 0.0, 0.0, "short, tutte e due dal lato opposto: nessuna"),
            ("PIU 1 95 0 90 1", 90.0, 1.0, "ST3,5 non calcolabile (dir 0): EMA200"),
            ("PIU 1 95 1 0 1", 95.0, 1.0, "EMA200 a 0: ST3,5"),
            ("PIU 1 95 1 95 1", 95.0, 1.0, "linee uguali")]
    for cmd, att, ad, lab in casi:
        o = one(cmd)
        check(fx(o[0]) == att and fx(o[1]) == ad, "PIU %s: %s -> %s %s (atteso %s %s)" % (lab, cmd, fx(o[0]), fx(o[1]), att, ad), quiet=True, bag=bag)
    casi2 = [("STOP2 0 1 100 95 90 5 100 1 70 1 20", 70.0, 50.0, 0, "long, EMA200 oltre la ST3,5: 20 sotto la EMA200"),
             ("STOP2 0 1 100 95 90 5 100 1 120 -1 20", 100.0, 80.0, 0, "long, EMA200 sopra il prezzo: 20 sotto la ST3,5 (= v1.10)"),
             ("STOP2 0 1 100 95 90 5 110 -1 130 -1 20", 0.0, 0.0, 1, "long, tutte e due dal lato opposto: scartato"),
             ("STOP2 0 1 100 95 90 5 110 -1 80 1 20", 80.0, 60.0, 0, "long, ST3,5 discorde ma EMA200 dal lato giusto: si arma (v1.10 scartava)"),
             ("STOP2 0 -1 100 105 110 5 100 -1 130 -1 20", 130.0, 150.0, 0, "short, EMA200 oltre: 20 sopra la EMA200"),
             ("STOP2 0 1 100 95 90 5 115 1 112 1 20", 112.0, 90.0, 2, "long, la piu' esterna (112) dentro la scala: vince X4")]
    for cmd, al, att, ea, lab in casi2:
        o = one(cmd)
        check(fx(o[0]) == al and fx(o[2]) == att and int(o[3]) == ea, "STOP2 %s: %s -> linea %s stop %s esito %s (atteso %s %s %d)" % (lab, cmd, fx(o[0]), fx(o[2]), o[3], al, att, ea),
              quiet=True, bag=bag)
    rnd = random.Random(1111)
    righe1, righe2, casi = [], [], []
    for _ in range(4000):
        sg = rnd.choice([1, -1])
        u = rnd.choice([0.0001, 0.01, 1.0])
        li = rnd.choice([rnd.uniform(0.5, 2.0), rnd.uniform(1000, 40000), rnd.uniform(50, 200)])
        p2 = li - sg * rnd.choice([5, 10]) * u
        bu = 5 * u
        v1 = li - sg * rnd.uniform(-25, 60) * u if rnd.random() > 0.05 else 0.0
        v2 = li - sg * rnd.uniform(-60, 90) * u if rnd.random() > 0.05 else 0.0
        d1 = sg if rnd.random() > 0.2 else rnd.choice([-sg, 0])
        d2 = sg if rnd.random() > 0.35 else rnd.choice([-sg, 0])
        ol = rnd.choice([10, 20, 30]) * u
        casi.append((sg, p2, bu, v1, d1, v2, d2, ol))
        righe2.append("STOP2 0 %d %r %r %r %r %r %d %r %d %r" % (sg, li, p2, li, bu, v1, d1, v2, d2, ol))
        lp, dp = py_piu_esterna(sg, v1, d1, v2, d2)
        righe1.append("STOPSET 1 0 %d %r %r %r %r %r %r %r" % (sg, li, p2, li, bu, lp, dp, ol))
    o2 = cx.run("\n".join(righe2) + "\n")
    o1 = cx.run("\n".join(righe1) + "\n")
    dif = uguali1 = viste = 0
    for a, b, (sg, p2, bu, v1, d1, v2, d2, ol) in zip(o2, o1, casi):
        a = a.split(); b = b.split()
        lp, dp = py_piu_esterna(sg, v1, d1, v2, d2)
        pv, pe = py_stop_oltre(sg, p2, bu, lp, dp, ol)
        if (fx(a[0]), fx(a[1]), fx(a[2]), int(a[3])) != (lp, dp, pv, pe):
            dif += 1
        if a[2] != b[0] or a[3] != b[1]:
            uguali1 += 1
        viste |= {0: 1, 1: 2, 2: 4}[pe]
    check(dif == 0 and uguali1 == 0 and viste == 7 and len(o2) == 4000,
          "OLTRE_PIU_ESTERNA: C++ == specchio indipendente su 4000 casi (diversi %d); a parita' di linea scelta il modo 2 == modo 1 bit per bit (diversi %d); "
          "esiti 0/1/2 visitati %s" % (dif, uguali1, viste == 7), quiet=True, bag=bag)


def stop_v110_unitari(cx, bag):
    """v1.10: NC_StopSetup / NC_FamigliaStop. Casi a mano col valore scritto qui + invarianza BIT PER BIT del modo 0 + proprieta' del modo 1"""
    def one(cmd):
        return cx.run(cmd + "\n")[0].split()
    for L, att in ((0, 2), (1, 2), (2, 2), (3, 3)):
        check(int(one("FAM %d" % L)[0]) == att, "NC_FamigliaStop(%d) = %d (Supertrend -> ST3,5; EMA200 -> EMA200)" % (L, att), quiet=True, bag=bag)
    # STOPSET modo criterio s linea profondo estremo buffer lineaEst dirEst oltre -> (stop, esito)
    casi = [("STOPSET 1 0 1 100 95 90 5 100 1 20", 80.0, 0, "long ST3,5 = linea del setup: 20 sotto"),
            ("STOPSET 1 0 1 100 95 90 5 92 1 20", 72.0, 0, "long ST2,5 con ST3,5 piu' in basso: 20 sotto la ST3,5"),
            ("STOPSET 1 0 1 100 95 90 5 115 1 20", 90.0, 2, "long, ST3,5 dentro la scala (115-20=95 sopra 90): vince X4"),
            ("STOPSET 1 0 1 100 95 90 5 110 1 20", 90.0, 0, "long, 110-20 = 90 = X4 esatto: regola (non X4)"),
            ("STOPSET 1 0 1 100 95 90 5 100 -1 20", 0.0, 1, "long con ST3,5 al ribasso (discorde): scartato"),
            ("STOPSET 1 0 1 100 95 90 5 100 0 20", 0.0, 1, "long con ST3,5 non calcolabile (dir 0): scartato"),
            ("STOPSET 1 0 1 100 95 90 5 0 1 20", 0.0, 1, "linea esterna 0: scartato"),
            ("STOPSET 1 0 1 15 10 5 5 15 1 20", 0.0, 1, "long, 15-20 < 0: stop impossibile, scartato"),
            ("STOPSET 1 0 -1 100 105 110 5 100 -1 20", 120.0, 0, "short: 20 SOPRA la linea"),
            ("STOPSET 1 0 -1 100 105 110 5 108 -1 20", 128.0, 0, "short ST2,5 con ST3,5 piu' in alto"),
            ("STOPSET 1 0 -1 100 105 110 5 85 -1 20", 110.0, 2, "short, ST3,5 dentro la scala: vince X4"),
            ("STOPSET 1 0 -1 100 105 110 5 100 1 20", 0.0, 1, "short con ST3,5 al rialzo: scartato"),
            ("STOPSET 1 1 1 100 95 50 5 100 1 20", 80.0, 0, "OLTRE ignora il criterio (ESTREMO_RECENTE darebbe 45)"),
            ("STOPSET 1 0 1 1.1 1.0995 1.09 0.0005 1.1 1 0.002", 1.1 - 0.002, 0, "EURUSD, 20 pip sotto 1,1000"),
            ("STOPSET 0 1 1 100 95 90 5 777 -1 3", 85.0, 0, "GEOMETRIA_ATTUALE: e' NC_Stop (estremo 90 + 5), argomenti nuovi ignorati"),
            ("STOPSET 0 0 -1 100 105 110 5 0 0 0", 110.0, 0, "GEOMETRIA_ATTUALE short: ordine profondo + 5")]
    for cmd, att, ea, lab in casi:
        o = one(cmd)
        check(fx(o[0]) == att and int(o[1]) == ea, "STOPSET %s: %s -> %s esito %s (atteso %s esito %d)" % (lab, cmd, fx(o[0]), o[1], att, ea), quiet=True, bag=bag)
    # INVARIANZA (a): modo 0 == NC_Stop BIT PER BIT (stringa %a identica), con argomenti nuovi a caso; == specchio della specifica
    rnd = random.Random(1010)
    righe, casi0 = [], []
    for _ in range(4000):
        s = rnd.choice([1, -1])
        li = rnd.choice([rnd.uniform(0.5, 2.0), rnd.uniform(1000, 40000), rnd.uniform(50, 200)])
        u = rnd.choice([0.0001, 0.01, 1.0])
        pr = li - s * rnd.choice([5, 10]) * u
        es = li - s * rnd.uniform(-30, 60) * u
        bu = rnd.choice([5, 10]) * u
        cr = rnd.choice([0, 1, 2])
        le, de, ol = rnd.uniform(-5, 5e4), rnd.choice([-1, 0, 1]), rnd.uniform(-50, 50)
        casi0.append((cr, s, li, pr, es, bu))
        righe.append("STOPSET 0 %d %d %r %r %r %r %r %d %r" % (cr, s, li, pr, es, bu, le, de, ol))
    out = cx.run("\n".join(righe) + "\n")
    bit = sum(1 for o in out if o.split()[0] != o.split()[2] or o.split()[1] != "0")
    spe = sum(1 for o, c in zip(out, casi0) if fx(o.split()[0]) != py_stop_v105(*c))
    check(bit == 0 and spe == 0 and len(out) == 4000,
          "INVARIANZA v1.10: GEOMETRIA_ATTUALE == NC_Stop della v1.05 BIT PER BIT su 4000 casi (diversi %d) e == specchio della specifica (diversi %d)" % (bit, spe),
          quiet=True, bag=bag)
    # OLTRE (b): == specchio indipendente, e proprieta': stop OLTRE tutti e tre gli ordini, mai piu' vicino di X4, esito 0 = esattamente lineaEst -/+ oltre
    righe, casi1 = [], []
    for _ in range(4000):
        s = rnd.choice([1, -1])
        u = rnd.choice([0.0001, 0.01, 1.0])
        li = rnd.choice([rnd.uniform(0.5, 2.0), rnd.uniform(1000, 40000), rnd.uniform(50, 200)])
        an, ol2 = rnd.choice([5, 10]), rnd.choice([5, 10])
        p = [li + s * an * u, li, li - s * ol2 * u]
        bu = 5 * u
        le = li - s * rnd.uniform(-25, 60) * u if rnd.random() > 0.05 else 0.0
        de = s if rnd.random() > 0.15 else rnd.choice([-s, 0])
        ol = rnd.choice([20, 10, 30]) * u
        casi1.append((s, p, bu, le, de, ol))
        righe.append("STOPSET 1 0 %d %r %r %r %r %r %d %r" % (s, li, p[2], li, bu, le, de, ol))
    out = cx.run("\n".join(righe) + "\n")
    dif = viol = n0 = n1 = n2 = 0
    for o, (s, p, bu, le, de, ol) in zip(out, casi1):
        v, e = fx(o.split()[0]), int(o.split()[1])
        pv, pe = py_stop_oltre(s, p[2], bu, le, de, ol)
        if (v, e) != (pv, pe):
            dif += 1
        n0 += e == 0; n1 += e == 1; n2 += e == 2
        if e == 1:
            viol += v != 0.0
            continue
        if not all(s * (x - v) > 0 for x in p) or s * ((p[2] - s * bu) - v) < 0:
            viol += 1
        if e == 0 and v != le - s * ol:
            viol += 1
    check(dif == 0 and viol == 0 and n0 > 1000 and n1 > 200 and n2 > 200,
          "OLTRE_LINEA_ESTERNA: C++ == specchio indipendente su 4000 casi (diversi %d), stop oltre i tre ordini e mai dentro X4 (violazioni %d); "
          "esiti 0/1/2 = %d/%d/%d (tutti e tre visitati)" % (dif, viol, n0, n1, n2), quiet=True, bag=bag)


def unitari(cx, bag):
    """casi a mano: valore atteso scritto qui, non ricalcolato con la stessa formula"""
    def one(cmd):
        return cx.run(cmd + "\n")[0].split()
    # NC_Stop: long linea 100, profondo 95, estremo 90, buffer 5
    casi = [("STOP 0 1 100 95 90 5", 90.0), ("STOP 1 1 100 95 90 5", 85.0), ("STOP 2 1 100 95 90 5", 90.0),
            ("STOP 1 1 100 95 99 5", 90.0),                      # estremo piu' vicino del profondo: vince X4
            ("STOP 0 -1 100 105 110 5", 110.0), ("STOP 1 -1 100 105 110 5", 115.0), ("STOP 1 -1 100 105 101 5", 110.0),
            ("STOP 2 -1 100 105 110 5", 110.0)]
    for cmd, att in casi:
        v = fx(one(cmd)[0])
        check(abs(v - att) < 1e-12, "%s -> %s (atteso %s)" % (cmd, v, att), quiet=True, bag=bag)
    stop_v110_unitari(cx, bag)
    stop_v111_unitari(cx, bag)
    # NC_TpEma
    for cmd, att, att1 in (("TPEMA 1 100 90 105 120 1", 120, 105), ("TPEMA 1 100 90 105 103 1", 110, 105),
                           ("TPEMA 1 100 90 95 120 1", 120, 0), ("TPEMA 1 100 90 95 98 1", 110, 0),
                           ("TPEMA 1 100 90 95 98 0", 0, 0), ("TPEMA -1 100 110 95 80 2", 80, 95),
                           ("TPEMA -1 100 110 95 97 2", 80, 95), ("TPEMA -1 100 110 101 102 1", 90, 0)):
        o = one(cmd)
        check(abs(fx(o[0]) - att) < 1e-12 and abs(fx(o[1]) - att1) < 1e-12, "%s -> %s %s (atteso %s %s)" % (cmd, fx(o[0]), fx(o[1]), att, att1), quiet=True, bag=bag)
    for cmd, att in (("TPFISSO 0 1 100 105 10", 110), ("TPFISSO 1 1 100 105 10", 115), ("TPFISSO 0 -1 100 95 10", 90),
                     ("TPFISSO 1 -1 100 95 10", 85)):
        check(abs(fx(one(cmd)[0]) - att) < 1e-12, "%s -> atteso %s" % (cmd, att), quiet=True, bag=bag)
    # NC_OrdineValido
    for cmd, att in (("VALIDO 1 100 90 110 1 1", 0), ("VALIDO 1 100 90 100.5 1 0", 1), ("VALIDO 1 100 90 101 1 0", 0),
                     ("VALIDO 1 100 90 110 1 2", 2), ("VALIDO 1 100 101 110 1 0", 3), ("VALIDO 1 100 90 0 1 0", 1),
                     ("VALIDO -1 100 110 90 1 1", 0), ("VALIDO -1 100 110 99.5 1 0", 1), ("VALIDO -1 100 99 90 1 0", 3),
                     ("VALIDO 1 1.10000 1.09950 1.10010 0.0001 0", 0), ("VALIDO 1 100 95 100 1 0", 1)):
        check(int(one(cmd)[0]) == att, "%s -> atteso %d" % (cmd, att), quiet=True, bag=bag)
    # NC_LottoGiu
    for cmd, att in (("LOTTO 0.299999999 0.01 0.01 100", 0.29), ("LOTTO 0.3 0.01 0.01 100", 0.30), ("LOTTO 0.009 0.01 0.01 100", 0.0),
                     ("LOTTO 150 0.01 0.01 100", 100.0), ("LOTTO 0.157 0.1 0.1 50", 0.1), ("LOTTO 0 0.01 0.01 100", 0.0),
                     ("LOTTO 0.07 0.01 0.01 0", 0.07), ("LOTTO 2.9999999997 1 1 10", 3.0), ("LOTTO 0.019 0.01 0.02 100", 0.0)):
        v = fx(one(cmd)[0])
        check(abs(v - att) < 1e-12, "%s -> %r (atteso %r)" % (cmd, v, att), quiet=True, bag=bag)
    for cmd, att in (("CIFRE 0.01", 2), ("CIFRE 0.1", 1), ("CIFRE 1", 0), ("CIFRE 0.001", 3), ("CIFRE 0.5", 1)):
        check(int(one(cmd)[0]) == att, "%s -> %d" % (cmd, att), quiet=True, bag=bag)
    # NC_Contesto: s aa adx am iu inc im iv cf dc ct
    for cmd, att in (("CTX 1 1 20 20 0 0 0 0 0 0 0.5", 0), ("CTX 1 1 20.01 20 0 0 0 0 0 0 0.5", 1), ("CTX 1 0 50 20 0 0 0 0 0 0 0.5", 0),
                     ("CTX 1 0 0 20 1 0.5 0.69 0 0 0 0.5", 2), ("CTX 1 0 0 20 1 0.69 0.69 0 0 0 0.5", 0),
                     ("CTX 1 0 0 20 1 -0.8 0.69 0 0 0 0.5", 0), ("CTX 1 0 0 20 1 -0.8 0.69 1 0 0 0.5", 2),
                     ("CTX -1 0 0 20 1 -0.8 0.69 1 0 0 0.5", 0), ("CTX 1 0 0 20 1 0 0 0 0 0 0.5", 0),
                     ("CTX 1 0 0 20 0 0 0 0 2 0.5 0.5", 0), ("CTX 1 0 0 20 0 0 0 0 2 0.51 0.5", 3), ("CTX 1 0 0 20 0 0 0 0 1 9 0.5", 0)):
        check(int(one(cmd)[0]) == att, "%s -> atteso %d" % (cmd, att), quiet=True, bag=bag)
    for cmd, att in (("SCALA 100 1 5 5 1", (105, 100, 95)), ("SCALA 100 -1 5 5 1", (95, 100, 105)), ("SCALA 100 1 10 5 1", (110, 100, 95)),
                     ("SCALA 1.1 1 5 10 0.0001", (1.1005, 1.1, 1.099))):
        v = [fx(x) for x in one(cmd)]
        check(all(abs(a - b) < 1e-12 for a, b in zip(v, att)), "%s -> %s (atteso %s)" % (cmd, v, att), quiet=True, bag=bag)
    for cmd, att in (("PESO 3 0 0", 1), ("PESO 3 0 1", 1), ("PESO 3 1 1", 2), ("PESO 3 1 0", 1), ("PESO 3 1 2", 1),
                     ("PESO 2 0 1", 1), ("PESO 2 1 1", 2), ("PESO 2 1 0", 1)):
        check(fx(one(cmd)[0]) == att, "%s -> %s" % (cmd, att), quiet=True, bag=bag)
    for cmd, att in (("META 0 3600", 1), ("META 1799 3600", 1), ("META 1800 3600", 2), ("META 3599 3600", 2)):
        check(int(one(cmd)[0]) == att, "%s -> %d" % (cmd, att), quiet=True, bag=bag)
    # cancello 07/10: funzioni spostate nel blocco puro (pip, lato, rischio in soldi)
    for cmd, att in (("PIP 5 0.00001", 0.0001), ("PIP 3 0.001", 0.01), ("PIP 2 0.01", 0.01), ("PIP 1 0.1", 0.1), ("PIP 4 0.0001", 0.0001)):
        v = fx(one(cmd)[0])
        check(abs(v - att) < 1e-15, "%s -> %r (atteso %r)" % (cmd, v, att), quiet=True, bag=bag)
    for cmd, att in (("LATO 0 1", 1), ("LATO 0 -1", 1), ("LATO 1 1", 1), ("LATO 1 -1", 0), ("LATO 2 1", 0), ("LATO 2 -1", 1)):
        check(int(one(cmd)[0]) == att, "%s -> %d" % (cmd, att), quiet=True, bag=bag)
    # saldo pct molt dc tol tetto: 10000 x 0,25% = 25; B3 x2 con confluenza troncata al tetto 0,25 -> 25; tetto 0,5 -> 50
    for cmd, att in (("RISCHIO 10000 0.25 1 0.1 0.5 0.25", 25.0), ("RISCHIO 10000 0.25 2 0.1 0.5 0.25", 25.0),
                     ("RISCHIO 10000 0.25 2 0.1 0.5 0.5", 50.0), ("RISCHIO 10000 0.25 2 0.9 0.5 0.5", 25.0),
                     ("RISCHIO 2000 0.5 1 9 0.5 0.5", 10.0)):
        v = fx(one(cmd)[0])
        check(abs(v - att) < 1e-9, "%s -> %r (atteso %r)" % (cmd, v, att), quiet=True, bag=bag)
    # NC_ControllaPendente: s prezzo sl tp ask bid md (ask 100,02, bid 100,00, md 0,05)
    for cmd, att in (("PEND 1 99 98 101 100.02 100 0.05", 0), ("PEND 1 99.98 98 101 100.02 100 0.05", 1),
                     ("PEND 1 99 99.5 101 100.02 100 0.05", 2), ("PEND 1 99 98.97 101 100.02 100 0.05", 2),
                     ("PEND 1 99 98 99.03 100.02 100 0.05", 2), ("PEND -1 101 102 99 100.02 100 0.05", 0),
                     ("PEND -1 100.04 102 99 100.02 100 0.05", 1), ("PEND -1 101 100.5 99 100.02 100 0.05", 2),
                     ("PEND -1 101 102 100.97 100.02 100 0.05", 2), ("PEND 1 101 98 103 100.02 100 0.05", 1)):
        check(int(one(cmd)[0]) == att, "%s -> atteso %d" % (cmd, att), quiet=True, bag=bag)
    o = [fx(x) for x in one("EMADIR 5 1 2 2 1 5 1.5 1.5 2 1.5 0")]
    check(o == [-1.0, 1.0, 1.0, -1.0, 0.0], "EMADIR: chiusura == EMA tiene la direzione, EMA<=0 -> 0 (%s)" % o, quiet=True, bag=bag)
    v = fx(one("INCL 4 3 2 10 11 12 14 1 1 1 2")[0])
    check(abs(v - 1.5) < 1e-12, "INCL (14-11)/2 = 1,5 (%s)" % v, quiet=True, bag=bag)
    v = fx(one("INCL 4 1 2 10 11 12 14 1 1 1 2")[0])
    check(v == 0.0, "INCL non calcolabile -> 0 (%s)" % v, quiet=True, bag=bag)
    # NC_Tocco a mano: long, linea in vigore 100 (val[0]), barra 1 low 100 = raggiunge
    base = "TOCCO 2 1 %d %s %s  101 105  99 100  102 101  100 100.5  1 1  2 2"
    check(int(one(base % (0, "0", "0"))[0]) == 1, "TOCCO: low == linea in vigore -> tocco long", quiet=True, bag=bag)
    base2 = "TOCCO 2 1 %d %s %s  101 105  99 100.1  102 101  100 100.5  1 1  2 2"
    check(int(one(base2 % (0, "0", "0"))[0]) == 0, "TOCCO: low 0,1 sopra la linea -> niente (RAGGIUNGE)", quiet=True, bag=bag)
    check(int(one(base2 % (1, "0.10", "0"))[0]) == 1, "TOCCO: low 0,1 sopra la linea, SFIORA 0,1 x ATR 2 = 0,2 -> tocco", quiet=True, bag=bag)
    base3 = "TOCCO 2 1 0 0 0  101 105  99 99  102 99.5  100 100.5  1 1  2 2"
    check(int(one(base3)[0]) == 0, "TOCCO: chiusura sotto la linea in vigore -> NON e' un tocco valido", quiet=True, bag=bag)
    base4 = "TOCCO 2 1 0 0 0  101 105  99 100  102 101  100 100.5  1 -1  2 2"
    check(int(one(base4)[0]) == 0, "TOCCO: flip sulla barra -> NON e' un tocco", quiet=True, bag=bag)
    base5 = "TOCCO 2 1 0 0 1  101 105  99 101.5  102 103  100 100.5  1 1  2 2"
    check(int(one(base5)[0]) == 1, "TOCCO: placebo 1 ATR (linea 102): low 101,5 tocca", quiet=True, bag=bag)
    base6 = "TOCCO 2 1 0 0 0  99 101  95 96  98 97  100 99.5  -1 -1  2 2"
    check(int(one(base6)[0]) == -1, "TOCCO: short, high 101 >= ceiling 100 -> -1", quiet=True, bag=bag)
    # proprieta' dei lotti su casi casuali
    rnd = random.Random(7)
    viol = 0
    lines = []
    casi = []
    for _ in range(3000):
        n = 3 if rnd.random() < 0.6 else 2
        R = rnd.uniform(0.5, 2000)
        w = [rnd.choice([0, 1, 1, 2]) for _ in range(n)]
        pl = [rnd.uniform(0.2, 900) if rnd.random() > 0.05 else 0.0 for _ in range(n)]
        st = rnd.choice([0.01, 0.1, 1.0])
        mn = st * rnd.choice([1, 1, 2, 5])
        mx = rnd.choice([0.0, 50.0, 500.0])
        casi.append((R, n, w, pl, st, mn, mx))
        lines.append("LOTTI %r %d %s %s %r %r %r" % (R, n, " ".join(map(repr, map(float, w))), " ".join(map(repr, pl)), st, mn, mx))
    out = cx.run("\n".join(lines) + "\n")
    eq = 0
    for (R, n, w, pl, st, mn, mx), o in zip(casi, out):
        lo = [fx(x) for x in o.split()]
        perd = sum(a * b for a, b in zip(lo, pl))
        if perd > R * (1 + 1e-9):
            viol += 1
        for a, wi in zip(lo, w):
            if a != 0 and (a < mn - 1e-9 or abs(a / st - round(a / st)) > 1e-6):
                viol += 1
            if wi == 0 and a != 0:
                viol += 1
            if mx > 0 and a > mx + 1e-9:
                viol += 1
        if n == 3 and w == [1, 1, 1] and pl[0] == pl[1] == pl[2] and pl[0] > 0:
            eq += 1
            if not (lo[0] == lo[1] == lo[2]):
                viol += 1
    check(viol == 0, "NC_LottiSetup su 3000 casi casuali: sum(lotto x perdita) <= R, multipli dello step, mai sotto il minimo, peso 0 -> 0 (violazioni %d)" % viol, quiet=True, bag=bag)
    o = [fx(x) for x in cx.run("LOTTI 300 3 1 1 1 100 100 100 0.01 0.01 0\n")[0].split()]
    check(o == [1.0, 1.0, 1.0], "pesi 1:1:1, stessa perdita -> stesso lotto (%s)" % o, quiet=True, bag=bag)
    o = [fx(x) for x in cx.run("LOTTI 400 3 1 2 1 100 100 100 0.01 0.01 0\n")[0].split()]
    check(o == [1.0, 2.0, 1.0], "pesi 1:2:1 (bandiera B1) a parita' di R: 1/2/1 lotti (%s)" % o, quiet=True, bag=bag)
    o = [fx(x) for x in cx.run("LOTTI 0.5 3 1 1 1 100 100 100 0.01 0.01 0\n")[0].split()]
    check(o == [0.0, 0.0, 0.0], "rischio sotto il lotto minimo -> TUTTI scartati, mai alzati al minimo (%s)" % o, quiet=True, bag=bag)


# ===========================================================================
# N) DATI REALI: oro M1 HistData (ora di New York) -> +6 h come la specifica par. 5.4
# ===========================================================================
_M1 = None


def carica_m1():
    global _M1
    if _M1 is not None:
        return _M1
    ep = dt.datetime(1970, 1, 1)
    rows = {}
    if not os.path.isdir(ZIPDIR):
        _M1 = []
        return _M1
    for fn in sorted(os.listdir(ZIPDIR)):
        if not fn.endswith(".zip"):
            continue
        with zipfile.ZipFile(os.path.join(ZIPDIR, fn)) as z:
            for nm in z.namelist():
                if not nm.lower().endswith(".csv"):
                    continue
                for ln in z.read(nm).decode("ascii", "replace").splitlines():
                    p = ln.split(";")
                    if len(p) < 5:
                        continue
                    d, t = p[0].split(" ")
                    tt = dt.datetime(int(d[:4]), int(d[4:6]), int(d[6:8]), int(t[:2]), int(t[2:4]))
                    m = int((tt - ep).total_seconds() // 60) + 6 * 60
                    rows[m] = (float(p[1]), float(p[2]), float(p[3]), float(p[4]))
    _M1 = sorted((k,) + v for k, v in rows.items())
    return _M1


def ricampiona(rows, mins):
    out = []
    cur = None
    for t, o, h, l, c in rows:
        b = t // mins
        if b != cur:
            cur = b
            out.append([b * mins, o, h, l, c])
        else:
            bar = out[-1]
            if h > bar[2]:
                bar[2] = h
            if l < bar[3]:
                bar[3] = l
            bar[4] = c
    return out


def py_ema(c, per):
    a = 2.0 / (per + 1.0)
    e = [0.0] * len(c)
    for i in range(len(c)):
        e[i] = c[0] if i == 0 else c[i] * a + e[i - 1] * (1.0 - a)
    return e


def py_atr(h, l, c, per):
    """iATR di MT5: media semplice del true range (TR[0] = H-L)"""
    n = len(c)
    tr = [h[0] - l[0]] + [max(h[i], c[i - 1]) - min(l[i], c[i - 1]) for i in range(1, n)]
    a = [0.0] * n
    s = 0.0
    for i in range(n):
        s += tr[i]
        if i >= per:
            s -= tr[i - per]
        a[i] = s / per if i >= per - 1 else 0.0
    return a


def py_adx_wilder(h, l, c, per):
    n = len(c)
    adx = [100.0] * n
    tr = [0.0] * n; pdm = [0.0] * n; ndm = [0.0] * n
    for i in range(1, n):
        up, dn = h[i] - h[i - 1], l[i - 1] - l[i]
        pdm[i] = up if (up > dn and up > 0) else 0.0
        ndm[i] = dn if (dn > up and dn > 0) else 0.0
        tr[i] = max(h[i], c[i - 1]) - min(l[i], c[i - 1])
    str_, sp, sn = sum(tr[1:per + 1]), sum(pdm[1:per + 1]), sum(ndm[1:per + 1])
    dxs = []
    a = None
    for i in range(per, n):
        if i > per:
            str_ = str_ - str_ / per + tr[i]
            sp = sp - sp / per + pdm[i]
            sn = sn - sn / per + ndm[i]
        pdi = 100 * sp / str_ if str_ > 0 else 0
        ndi = 100 * sn / str_ if str_ > 0 else 0
        dx = 100 * abs(pdi - ndi) / (pdi + ndi) if pdi + ndi > 0 else 0
        if a is None:
            dxs.append(dx)
            if len(dxs) == per:
                a = sum(dxs) / per
                adx[i] = a
        else:
            a = (a * (per - 1) + dx) / per
            adx[i] = a
    return adx


def py_adx_mt5(h, l, c, per):
    """specchio di ADX.mq5 (iADX): DI per barra, medie esponenziali 2/(n+1)"""
    n = len(c)
    k = 2.0 / (per + 1.0)
    pdi = [0.0] * n; ndi = [0.0] * n; adx = [0.0] * n
    for i in range(1, n):
        tp, tn = h[i] - h[i - 1], l[i - 1] - l[i]
        tp = max(tp, 0.0); tn = max(tn, 0.0)
        if tp > tn:
            tn = 0.0
        elif tp < tn:
            tp = 0.0
        else:
            tp = tn = 0.0
        tr = max(abs(h[i] - l[i]), abs(h[i] - c[i - 1]), abs(l[i] - c[i - 1]))
        pd, nd = (100.0 * tp / tr, 100.0 * tn / tr) if tr != 0 else (0.0, 0.0)
        pdi[i] = pd * k + pdi[i - 1] * (1 - k)
        ndi[i] = nd * k + ndi[i - 1] * (1 - k)
        s = pdi[i] + ndi[i]
        dx = 100.0 * abs((pdi[i] - ndi[i]) / s) if s != 0 else 0.0
        adx[i] = dx * k + adx[i - 1] * (1 - k)
    return adx


def py_emadir(c, e):
    d = [0.0] * len(c)
    for i in range(len(c)):
        if e[i] <= 0:
            d[i] = 0.0
        elif c[i] > e[i]:
            d[i] = 1.0
        elif c[i] < e[i]:
            d[i] = -1.0
        else:
            d[i] = d[i - 1] if i > 0 else 0.0
    return d


def py_episodi_avanti(h, l, c, val, dr, atr, defT, sf, pl, reset, dist):
    """specchio INDIPENDENTE: macchina a stati in avanti (l'EA scandisce all'indietro dall'ultimo flip)"""
    n = len(c)
    out = [None] * n
    seg = nEp = 0
    prev = False
    epI = -1
    for i in range(n):
        d = dr[i]
        if i == 0 or d == 0.0:
            out[i] = (0, -1, 0, 0, 0, -1)
            continue
        if dr[i - 1] != d:
            seg, nEp, prev, epI = i, 0, False, -1
            out[i] = (1, seg, 0, 0, 0, -1)
            continue
        lv = val[i - 1] + d * pl * atr[i - 1]
        tol = sf * atr[i - 1] if defT == 1 else 0.0
        if d > 0:
            t = 1 if (c[i] >= lv and l[i] <= lv + tol) else 0
        else:
            t = -1 if (c[i] <= lv and h[i] >= lv - tol) else 0
        tc = t != 0
        if reset == 1 and not tc and nEp > 0:
            dd = (h[i] - lv) if d > 0 else (lv - l[i])
            if dd >= dist * atr[i - 1]:
                nEp = 0
        nu = 0
        if tc and not prev:
            nEp += 1
            epI = i
            nu = 1
        prev = tc
        out[i] = (1, seg, nEp, t, nu, epI)
    return out


def serie_tf(mins, da_anno):
    m1 = carica_m1()
    if not m1:
        return None
    ep = dt.datetime(1970, 1, 1)
    t0 = int((dt.datetime(da_anno, 1, 1) - ep).total_seconds() // 60)
    bars = [b for b in ricampiona(m1, mins) if b[0] >= t0]
    t = [b[0] for b in bars]
    o = [b[1] for b in bars]; h = [b[2] for b in bars]; l = [b[3] for b in bars]; c = [b[4] for b in bars]
    return t, o, h, l, c


CONFIG = [("base: RAGGIUNGE, reset al flip, niente placebo", 0, 0.0, 0.0, 0, 1.0),
          ("SFIORA 0,10 + azzeramento per distacco 1,0 ATR", 1, 0.10, 0.0, 1, 1.0),
          ("placebo 1,0 ATR", 0, 0.0, 1.0, 0, 1.0)]


def gira_serie(cx, h, l, c, e, a, cfg):
    _, defT, sf, pl, reset, dist = cfg
    n = len(c)
    txt = "SERIE %d 10 2.5 3.0 3.5 %d %r %r %d %r\n" % (n, defT, sf, pl, reset, dist)
    for arr in (h, l, c, e, a):
        txt += " ".join(repr(x) for x in arr) + "\n"
    out = cx.run(txt)
    res = []
    for L in range(4):
        rows = out[L * n:(L + 1) * n]
        v, d, k, seg, ne, tl, nu, ei = [], [], [], [], [], [], [], []
        for r in rows:
            p = r.split()
            v.append(fx(p[0])); d.append(fx(p[1])); k.append(int(p[2])); seg.append(int(p[3])); ne.append(int(p[4]))
            tl.append(int(p[5])); nu.append(int(p[6])); ei.append(int(p[7]))
        res.append((v, d, k, seg, ne, tl, nu, ei))
    return res


def confronta_numeri(cx, ser, bag, verbose, configs=CONFIG):
    t, o, h, l, c = ser
    e = py_ema(c, 200)
    a = py_atr(h, l, c, 14)
    n = len(c)
    ris = None
    for cfg in configs:
        res = gira_serie(cx, h, l, c, e, a, cfg)
        for L in range(4):
            v, d, k, seg, ne, tl, nu, ei = res[L]
            if L < 3:
                pa, pu, pd, pr, pv = CG.st_full(h, l, c, 10, (2.5, 3.0, 3.5)[L])
                diff = sum(1 for i in range(n) if pv[i] != v[i] or pr[i] != d[i])
                check(diff == 0, "[%s] linea %s: NC_STCore C++ == py_stcore bit per bit (%d differenze su %d barre)"
                      % (cfg[0], ("2.5", "3.0", "3.5")[L], diff, n), quiet=not verbose, bag=bag)
                vv, dd = pv, pr
            else:
                dd = py_emadir(c, e)
                vv = e
                diff = sum(1 for i in range(n) if dd[i] != d[i] or v[i] != e[i])
                check(diff == 0, "[%s] linea EMA200: NC_EmaDir == specchio (%d differenze)" % (cfg[0], diff), quiet=not verbose, bag=bag)
            py = py_episodi_avanti(h, l, c, vv, dd, a, cfg[1], cfg[2], cfg[3], cfg[4], cfg[5])
            diff = 0
            for i in range(n):
                pk, ps, pn, pt, pnu, pe = py[i]
                if k[i] != pk:
                    diff += 1
                elif pk == 1 and (seg[i], ne[i], tl[i], nu[i], ei[i]) != (ps, pn, pt, pnu, pe):
                    diff += 1
            nep = sum(nu)
            check(diff == 0, "[%s] linea %s: NC_Episodi (all'indietro, C++) == macchina in avanti (Python) su ogni barra: %d differenze, %d episodi"
                  % (cfg[0], ("2.5", "3.0", "3.5", "EMA200")[L], diff, nep), quiet=not verbose, bag=bag)
        if ris is None:
            ris = res
    return ris, e, a


def stop_su_barre(cx, ser, res, e, bag, verbose):
    """v1.10/v1.11 sulle barre VERE dell'oro (u = 1 USD, scala 5/5, buffer 5, oltre 20): per ogni barra con la linea definita, la scala che l'EA
    armerebbe per la barra dopo e lo stop nei TRE modi. Le linee candidate (ST3,5 ed EMA200, con le direzioni) sono calcolate dallo SPECCHIO
    Python (py_stcore 3,5 / py_ema + py_emadir), la famiglia e la scelta della linea in Python: il C++ deve dare (a) in GEOMETRIA_ATTUALE lo
    stesso valore di NC_Stop bit per bit, (b) in OLTRE_LINEA_ESTERNA e (c) in OLTRE_PIU_ESTERNA lo stesso (linea, stop, esito) dello specchio.
    (d) dove almeno una candidata e' dal lato del setup, la scelta coincide con la lettura LETTERALE ("la piu' bassa/alta delle due").
    Ritorna, per modo (1, 2) e per linea, esito e distanza per barra."""
    t, o, h, l, c = ser
    n = len(c)
    _a, _u, _d, pr35, pv35 = CG.st_full(h, l, c, 10, 3.5)
    ed = py_emadir(c, e)
    righe, chiavi = [], []
    for L in range(4):
        v, d = res[L][0], res[L][1]
        lev, led = (e, ed) if L == 3 else (pv35, pr35)
        for i in range(1, n):
            if d[i] == 0.0:
                continue
            s = int(d[i])
            lv = v[i]
            p2 = lv - s * 5.0
            est = min(l[max(0, i - 2):i + 1]) if s > 0 else max(h[max(0, i - 2):i + 1])
            righe.append("STOPSET 0 0 %d %r %r %r 5 %r %r 20" % (s, lv, p2, est, lev[i], led[i]))
            righe.append("STOPSET 1 0 %d %r %r %r 5 %r %r 20" % (s, lv, p2, est, lev[i], led[i]))
            if L == 3:
                righe.append("STOPSET 2 0 %d %r %r %r 5 %r %r 20" % (s, lv, p2, est, e[i], ed[i]))
            else:
                righe.append("STOP2 0 %d %r %r %r 5 %r %r %r %r 20" % (s, lv, p2, est, pv35[i], pr35[i], e[i], ed[i]))
            chiavi.append((L, i, s, lv, p2, est, lev[i], led[i], pv35[i], pr35[i], e[i], ed[i]))
    out = cx.run("\n".join(righe) + "\n")
    bit = dif = dif2 = lett = 0
    per_modo = {1: {L: {} for L in range(4)}, 2: {L: {} for L in range(4)}}
    for k, (L, i, s, lv, p2, est, le, de, v35, d35, ve, dE) in enumerate(chiavi):
        o0, o1, o2 = out[3 * k].split(), out[3 * k + 1].split(), out[3 * k + 2].split()
        if o0[0] != o0[2] or o0[1] != "0" or fx(o0[0]) != py_stop_v105(0, s, lv, p2, est, 5.0):
            bit += 1
        pv, pe = py_stop_oltre(s, p2, 5.0, le, de, 20.0)
        if (fx(o1[0]), int(o1[1])) != (pv, pe):
            dif += 1
        per_modo[1][L][i] = (int(o1[1]), abs(lv - fx(o1[0])) if int(o1[1]) != 1 else None)
        if L == 3:
            lp, dp = (ve, dE) if (dE == s and ve > 0) else (0.0, 0.0)
            pv2, pe2 = py_stop_oltre(s, p2, 5.0, ve, dE, 20.0)
            got = (fx(o2[0]), int(o2[1]))
        else:
            lp, dp = py_piu_esterna(s, v35, d35, ve, dE)
            pv2, pe2 = py_stop_oltre(s, p2, 5.0, lp, dp, 20.0)
            got = (fx(o2[2]), int(o2[3]))
            if fx(o2[0]) != lp:
                dif2 += 1
            if dp != 0.0 and lp != (min(v35, ve) if s > 0 else max(v35, ve)):
                lett += 1
        if got != (pv2, pe2):
            dif2 += 1
        per_modo[2][L][i] = (got[1], abs(lv - got[0]) if got[1] != 1 else None)
    check(bit == 0 and len(chiavi) > 4 * 0.9 * n,
          "INVARIANZA v1.10 sull'oro H1: GEOMETRIA_ATTUALE == NC_Stop v1.05 bit per bit su %d scale (4 linee, ogni barra): diverse %d" % (len(chiavi), bit),
          quiet=not verbose, bag=bag)
    check(dif == 0, "OLTRE_LINEA_ESTERNA sull'oro H1: C++ == specchio (famiglia ST3,5 / EMA200 dallo specchio Python) su %d scale: diverse %d" % (len(chiavi), dif),
          quiet=not verbose, bag=bag)
    check(dif2 == 0, "v1.11 OLTRE_PIU_ESTERNA sull'oro H1: linea scelta e stop del C++ == specchio (ST3,5 ed EMA200 dallo specchio Python) su %d scale: diverse %d"
          % (len(chiavi), dif2), quiet=not verbose, bag=bag)
    check(lett == 0, "v1.11: dove almeno una fra ST3,5 ed EMA200 e' dal lato del setup, la linea scelta == lettura LETTERALE (min long / max short delle due): "
          "diverse %d (escludere le linee dal lato opposto cambia solo il caso 'tutte e due opposte')" % lett, quiet=not verbose, bag=bag)
    return per_modo


def conteggi(t, h, l, c, res, verbose):
    ep = dt.datetime(1970, 1, 1)
    da = int((dt.datetime(2024, 7, 10) - ep).total_seconds() // 60)
    a = int((dt.datetime(2026, 9, 19) - ep).total_seconds() // 60)
    anni = (dt.datetime(2026, 9, 18) - dt.datetime(2024, 7, 10)).days / 365.25
    adxw = py_adx_wilder(h, l, c, 14)
    adxm = py_adx_mt5(h, l, c, 14)
    lim = (1, 1, 2)
    righe = []
    for L in range(3):
        v, d, k, seg, ne, tl, nu, ei = res[L]
        idx = [i for i in range(len(c)) if da <= t[i] < a and nu[i] == 1]
        entro = [i for i in idx if ne[i] <= lim[L]]
        w = [i for i in entro if adxw[i] <= 20]
        m = [i for i in entro if adxm[i] <= 20]
        warm = [i for i in entro if adxw[i - 1] <= 20]
        righe.append((len(idx) / anni, len(entro) / anni, len(w) / anni, len(m) / anni, len(warm) / anni))
    return righe, anni


# ===========================================================================
# SUITE (la stessa per il vero e per i mutanti)
# ===========================================================================
STOP_BARRE = None      # v1.10: esiti e distanze dello stop OLTRE sulle barre dell'oro (solo per la stampa informativa del sorgente vero)


def suite(raw, tmp, ser, verbose):
    bag = []
    src = statico(raw, bag)
    cx = Cxx(src, tmp)
    if not cx.ok:
        bag.append("il blocco puro non compila in C++: %s" % cx.err[:300])
        return bag, None
    try:
        tester_pigro(src, tmp, bag, verbose)
        unitari(cx, bag)
        res, e, a = confronta_numeri(cx, ser, bag, verbose)
        global STOP_BARRE
        STOP_BARRE = stop_su_barre(cx, ser, res, e, bag, verbose)
        # VERIFICA ADX (seconda lettura 07/10): il ricalcolo dell'EA (riga "VERIFICA ADX") == specchi Python
        # della serie intera, e le due formule si DISTINGUONO (altrimenti la riga non deciderebbe niente)
        t_, o_, h_, l_, c_ = ser
        am_, aw_ = py_adx_mt5(h_, l_, c_, 14), py_adx_wilder(h_, l_, c_, 14)
        W = 1500
        dm_ = dw_ = 0.0
        distinti = casi_ = 0
        for e_ in range(W - 1, len(c_), max(1, (len(c_) - W) // 12)):
            o0 = e_ - W + 1
            arrs = (h_[o0:e_ + 1], l_[o0:e_ + 1], c_[o0:e_ + 1])
            txt = "".join("ADX %d 14 %d\n" % (W, tp_) + "\n".join(" ".join(repr(x) for x in arr) for arr in arrs) + "\n"
                          for tp_ in (0, 1))
            r0, r1 = [fx(x) for x in cx.run(txt)]
            dm_ = max(dm_, abs(r0 - am_[e_])); dw_ = max(dw_, abs(r1 - aw_[e_]))
            distinti += 1 if abs(r0 - r1) > 0.05 else 0
            casi_ += 1
        check(casi_ >= 5 and dm_ < 1e-6 and dw_ < 1e-6,
              "VERIFICA ADX: ricalcolo dell'EA su 1500 barre == specchi della serie intera (%d punti, scarto max MetaQuotes %.1e, Wilder %.1e)"
              % (casi_, dm_, dw_), quiet=not verbose, bag=bag)
        check(distinti >= casi_ - 1, "CONTRO-ESEMPIO: le due formule ADX differiscono di > 0,05 in %d punti su %d (la riga VERIFICA ADX le distingue)"
              % (distinti, casi_), quiet=not verbose, bag=bag)
        # finestra di 1500 barre (EA) contro la serie intera
        t, o, h, l, c = ser
        n = len(c)
        for mult in (2.5, 3.5):
            txt = "FIN %d 10 %r 1500 37\n" % (n, mult) + "\n".join(" ".join(repr(x) for x in arr) for arr in (h, l, c, a)) + "\n"
            casi, mv, me, tr = map(int, cx.run(txt)[0].split())
            check(mv == 0 and me == 0 and casi > 50, "finestra EA 1500 barre == serie intera (ST %.1f): %d punti, %d differenze linea, %d differenze episodi, %d segmenti troncati"
                  % (mult, casi, mv, me, tr), quiet=not verbose, bag=bag)
        txt = "FIN %d 10 3.5 40 37\n" % n + "\n".join(" ".join(repr(x) for x in arr) for arr in (h, l, c, a)) + "\n"
        casi, mv, me, tr = map(int, cx.run(txt)[0].split())
        check(me > 0 or mv > 0, "CONTRO-ESEMPIO: con una finestra di 40 barre il controllo VEDE differenze (%d linea, %d episodi su %d)" % (mv, me, casi),
              quiet=not verbose, bag=bag)
    except Exception as ex:                 # un mutante che fa crollare il driver e' comunque PRESO
        bag.append("eccezione: %s" % ex)
        return bag, None
    return bag, res


TOCCO = "   CopyBuffer(hEma200,0,1,1,tocco);\n   CopyBuffer(hAtrN,0,1,1,tocco);\n   CopyBuffer(hAdx,0,1,1,tocco);\n"
DOPO_TOCCO = "   int barre=Bars(_Symbol,gTF);\n   int n=(barre-2<NC_BARRE) ? barre-2 : NC_BARRE;\n   if(n<NC_BARRE_MIN) return false;\n"
BC_LINEA = "   if(BarsCalculated(hEma200)<n+1 || BarsCalculated(hAtrN)<n+1 || BarsCalculated(hAdx)<n+1) return false;\n"
V104_COMMIT = "290e1b74"      # ultimo commit con EA_NatCla v1.04 (lettura della diagnosi NATCLA_DIAG_U30)


def solo_il_tocco(src105):
    """NESSUN'ALTRA MODIFICA: la v1.05 senza commenti, senza il tocco e con le due stringhe di versione riportate a 1.04 deve
    essere IDENTICA (spazi a parte) alla v1.04 del commit V104_COMMIT. Gira solo sul sorgente vero (un mutante la romperebbe sempre)."""
    r = subprocess.run(["git", "-C", ROOT, "show", "%s:mql5/Experts/EA_NatCla.mq5" % V104_COMMIT], capture_output=True)
    if r.returncode != 0:
        return None, "v1.04 non leggibile da git (%s)" % V104_COMMIT
    def senza_commenti(s):
        m = maschera(s)
        return "".join(sc if mc == "x" else mc for mc, sc in zip(m, s))
    a = senza_commenti(r.stdout.decode("ascii"))
    b = senza_commenti(src105)
    b = re.sub(r"[ \t]*double\s+tocco\s*\[\s*1\s*\]\s*;[ \t]*\n", "", b)
    b = re.sub(r"[ \t]*CopyBuffer\s*\(\s*\w+\s*,\s*0\s*,\s*1\s*,\s*1\s*,\s*tocco\s*\)\s*;[ \t]*\n", "", b)
    b = b.replace('#property version   "1.05"', '#property version   "1.04"').replace('#define NC_VER "1.05"', '#define NC_VER "1.04"')
    na, nb = re.sub(r"\s+", "", a), re.sub(r"\s+", "", b)
    if na == nb:
        return True, ""
    k = next(i for i in range(min(len(na), len(nb)) + 1) if i == min(len(na), len(nb)) or na[i] != nb[i])
    return False, "prima differenza: v1.04 '...%s' contro v1.05 '...%s'" % (na[max(0, k - 40):k + 40], nb[max(0, k - 40):k + 40])


V105_COMMIT = "d6586360"      # pin della v1.05 (sha256 7d89a3df...c9ac, lotti F0 C0/C/A): la base della v1.10
FUNZ_NUOVE_V110 = ("NC_FamigliaStop", "NC_StopSetup", "CalcolaLineaEsterna", "LineaEsternaPrezzo", "StopDescr", "NC_PiuEsterna", "LineaPiuEsternaPrezzo")
TOK_V110 = ("InpStopModo", "InpStopOltreU", "NC_StopSetup", "NC_FamigliaStop", "CalcolaLineaEsterna", "LineaEsternaPrezzo", "StopDescr",
            "gXV", "gXD", "gXa", "gXu", "gXdn", "lineaStop", "stopEsito", "ENUM_NC_STOPMODO", "NC_STOP_", "IMB_O_STOPEST", "IMB_O_STOPX4",
            "lest", "dest", "intes=0;", "es==1", "es==2", "es!=1", "stop_modo", "stoplineaesterna", '"1.10"', "|stop%s",
            "gXE", '"1.11"')   # v1.11: la guardia v1.05 -> sorgente corrente vale per la v1.10 + la v1.11 insieme
# righe della v1.05 (senza commenti e spazi) che la v1.10 puo' togliere o riscrivere: SOLO queste, elencate per nome
TOLTE_OK_V110 = (
    '#propertyversion"1.05"', '#defineNC_VER"1.05"', "#defineIMB_N35", '"riempimenti","setupchiusi"',
    "doublesl=NormPrezzo(NC_Stop(gSLCrit,s,lv,p[2],Estremo(s,last),InpSLBuffer*gU));",
    "doublesl=NC_Stop(gSLCrit,s,lv0,p[2],Estremo(s,last),InpSLBuffer*gU);",
    'D((ped>0)?MathAbs(p[0]-sl)/ped:0,1)+";"+D((ped>0)?MathAbs(p[1]-sl)/ped:0,1)+";"+D((ped>0)?MathAbs(p[2]-sl)/ped:0,1)+";"+',
    '"0;0;0;0;0;SOLO_CONTA";',
    'D(gSet[L].rischioSoldi,2)+";"+IntegerToString(nRiemp)+";"+D(soldi,2)+";"+D(R,3)+";"+D(dur,1)+";"+motivo;',
    'InpUsaGuardian?"ON(neltesterFAIL-OPEN)":"OFF",InpSoloConta?"SI":"no",InpPlaceboAtr);',
)
# righe della v1.05 che la v1.10 RISCRIVE con una trasformazione esatta: (prefisso, (vecchio pezzo, nuovo pezzo)); la riga trasformata DEVE essere fra le aggiunte
TRASFORMA_V110 = (('stringavvio=StringFormat("AVVIOv%s|', ('(PDFescluso07/10)",', '(PDFescluso07/10)|stop%s",')),
                  ('FileWrite(gFh,"tipo;barra;', ('motivo");', 'motivo;stop_modo;linea_stop;stop_esito");')))
AGGIUNTE_OK_V110 = ("{", "}", "};", "#defineIMB_N37", '"riempimenti","setupchiusi",',
                    'D(gSet[L].rischioSoldi,2)+";"+IntegerToString(nRiemp)+";"+D(soldi,2)+";"+D(R,3)+";"+D(dur,1)+";"+motivo+";"+')


def senza_commenti_sorgente(s):
    m = maschera(s)
    return "".join(sc if mc == "x" else mc for mc, sc in zip(m, s))


def diff_v105_v110(a105, b110):
    """lista dei difetti: righe tolte dalla v1.05 fuori da TOLTE_OK_V110, righe aggiunte senza un simbolo della v1.10 (fuori dalle funzioni NUOVE)"""
    return diff_versioni(a105, b110, FUNZ_NUOVE_V110, TOK_V110, TOLTE_OK_V110, AGGIUNTE_OK_V110, TRASFORMA_V110)


# v1.11 (Claudio 09/10, "Proviamole entrambe"): guardia del diff v1.10 (pin V110_COMMIT) -> v1.11
V110_COMMIT = "aeebb11d"      # EA v1.10 sha256 af034d87...020a (cancello strato 2: PASS con riserve, 135cb9a5)
FUNZ_NUOVE_V111 = ("NC_PiuEsterna", "LineaPiuEsternaPrezzo")
TOK_V111 = ("NC_STOP_OLTRE_PIU_ESTERNA", "OLTRE_PIU_ESTERNA", "gXE", "LineaPiuEsternaPrezzo", "NC_PiuEsterna", '"1.11"')
TOLTE_OK_V111 = ('#propertyversion"1.10"', '#defineNC_VER"1.10"', "NC_STOP_OLTRE_LINEA_ESTERNA=1",
                 "if(InpStopModo==NC_STOP_OLTRE_LINEA_ESTERNA)", "if(modo!=1)returnNC_Stop(criterio,s,linea,profondo,estremo,buf);")
AGGIUNTE_OK_V111 = ("{", "}", "};", "NC_STOP_OLTRE_LINEA_ESTERNA=1,", "if(InpStopModo!=NC_STOP_GEOMETRIA_ATTUALE)",
                    "if(modo!=1&&modo!=2)returnNC_Stop(criterio,s,linea,profondo,estremo,buf);")


def diff_versioni(va, vb, funz_nuove, tok, tolte, aggiunte_ok, trasforma):
    """lista dei difetti del passaggio va -> vb: righe tolte da va fuori da 'tolte' (o dalle trasformazioni esatte), righe aggiunte senza un
    simbolo di 'tok' fuori dalle funzioni NUOVE e da 'aggiunte_ok'. Commenti e spazi non contano."""
    import difflib
    dif = []
    a = senza_commenti_sorgente(va)
    b = senza_commenti_sorgente(vb)
    for fn in funz_nuove:
        if corpo(a, fn):
            dif.append("la funzione 'nuova' %s esiste gia' nella versione di partenza" % fn)
        cb = corpo(b, fn)
        if not cb:
            dif.append("funzione nuova %s assente nella v1.10" % fn)
            continue
        b = b.replace(cb, "\n", 1)
    la = [x for x in (re.sub(r"\s+", "", r) for r in a.split("\n")) if x]
    lb = [x for x in (re.sub(r"\s+", "", r) for r in b.split("\n")) if x]
    ops = difflib.SequenceMatcher(None, la, lb, autojunk=False).get_opcodes()
    aggiunte = set(r for op, i1, i2, j1, j2 in ops if op in ("replace", "insert") for r in lb[j1:j2])
    for op, i1, i2, j1, j2 in ops:
        if op in ("replace", "delete"):
            for r in la[i1:i2]:
                if r in tolte:
                    continue
                tr = [r.replace(v_, n_, 1) for pref, (v_, n_) in trasforma if r.startswith(pref) and v_ in r]
                if tr and tr[0] in aggiunte:
                    continue
                dif.append("riga della versione di partenza tolta o cambiata fuori dall'elenco: %s" % r[:110])
        if op in ("replace", "insert"):
            for r in lb[j1:j2]:
                if r not in aggiunte_ok and not any(t in r for t in tok):
                    dif.append("riga aggiunta senza un simbolo della versione nuova: %s" % r[:110])
    return dif


def solo_lo_stop(src110):
    """v1.10 = v1.05 (pin V105_COMMIT) + SOLO la regola di stop: ogni riga tolta e' nell'elenco, ogni riga aggiunta porta un simbolo della v1.10.
    Con DUE contro-esempi costruiti qui (una riga di logica cambiata, una riga di logica aggiunta senza simbolo): la guardia li deve vedere."""
    r = subprocess.run(["git", "-C", ROOT, "show", "%s:mql5/Experts/EA_NatCla.mq5" % V105_COMMIT], capture_output=True)
    if r.returncode != 0:
        return None, "v1.05 non leggibile da git (%s)" % V105_COMMIT, None
    v105 = r.stdout.decode("ascii")
    dif = diff_v105_v110(v105, src110)
    ce1 = src110.replace("#define NC_BARRE_MIN 300", "#define NC_BARRE_MIN 301", 1)
    ce2 = src110.replace("   if(!(gU>0)){ err=", "   gU=gU*2.0;\n   if(!(gU>0)){ err=", 1)
    ce_ok = (ce1 != src110 and ce2 != src110 and len(diff_v105_v110(v105, ce1)) > 0 and len(diff_v105_v110(v105, ce2)) > 0)
    return (not dif), "; ".join(dif[:4]), ce_ok


STOPSET_MIN = r'''
#include "shim.h"
#include "pure.mqh"
int main(){
  char cmd[32];
  while(scanf("%31s",cmd)==1){
    int mo,cr,s,e=-7; double li,pr,es,bu,le,de,ol;
    if(scanf("%d %d %d %lf %lf %lf %lf %lf %lf %lf",&mo,&cr,&s,&li,&pr,&es,&bu,&le,&de,&ol)!=10) return 2;
    double r=NC_StopSetup(mo,cr,s,li,pr,es,bu,le,de,ol,e); printf("%a %d\n",r,e);
  }
  return 0;
}
'''


def compila_stopset(src, cartella):
    """il blocco puro di 'src' con un driver che chiama SOLO NC_StopSetup (esiste dalla v1.10): None se non compila"""
    cxx = shutil.which("g++") or shutil.which("clang++")
    if not cxx:
        return None
    os.makedirs(cartella, exist_ok=True)
    for nm, txt in (("shim.h", CG.SHIM + SHIM_EXTRA), ("pure.mqh", CG.to_cxx(blocco_puro(src))), ("drv.cpp", STOPSET_MIN)):
        with open(os.path.join(cartella, nm), "w") as f:
            f.write(txt)
    exe = os.path.join(cartella, "drv")
    r = subprocess.run([cxx, "-std=c++17", "-O2", "-ffp-contract=off", "-o", exe, os.path.join(cartella, "drv.cpp")], capture_output=True, text=True)
    return exe if r.returncode == 0 else None


def identita_v110(src111, ser, tmp):
    """GEOMETRIA_ATTUALE e OLTRE_LINEA_ESTERNA della v1.11 == v1.10 (pin V110_COMMIT) BIT PER BIT: le due NC_StopSetup compilate fianco a fianco
    sugli STESSI ingressi (8000 casuali + ogni scala dell'oro H1 con ST3,5 / EMA200 vere, modi 0 e 1). Contro-esempio: una v1.11 con lo stop
    OLTRE dal lato sbagliato deve dare differenze. Ritorna (n righe, diverse, diverse nel contro-esempio, esito della guardia del diff, dettaglio)."""
    r = subprocess.run(["git", "-C", ROOT, "show", "%s:mql5/Experts/EA_NatCla.mq5" % V110_COMMIT], capture_output=True)
    if r.returncode != 0:
        return None, None, None, None, "v1.10 non leggibile (%s)" % V110_COMMIT
    v110 = r.stdout.decode("ascii")
    e10 = compila_stopset(v110, os.path.join(tmp, "v110"))
    e11 = compila_stopset(src111, os.path.join(tmp, "v111"))
    ce_src = src111.replace("double oltreLinea=lineaEst-s*oltre;", "double oltreLinea=lineaEst+s*oltre;", 1)
    ece = compila_stopset(ce_src, os.path.join(tmp, "v111ce"))
    if not (e10 and e11 and ece) or ce_src == src111:
        return None, None, None, None, "compilazione del confronto fallita"
    rnd = random.Random(1011)
    righe = []
    for _ in range(8000):
        sg = rnd.choice([1, -1]); u = rnd.choice([0.0001, 0.01, 1.0])
        li = rnd.choice([rnd.uniform(0.5, 2.0), rnd.uniform(1000, 40000), rnd.uniform(50, 200)])
        righe.append("S %d %d %d %r %r %r %r %r %d %r" % (rnd.choice([0, 1]), rnd.choice([0, 1, 2]), sg, li, li - sg * rnd.choice([5, 10]) * u,
                     li - sg * rnd.uniform(-30, 60) * u, 5 * u, li - sg * rnd.uniform(-25, 60) * u if rnd.random() > 0.05 else 0.0,
                     sg if rnd.random() > 0.15 else rnd.choice([-sg, 0]), rnd.choice([10, 20, 30]) * u))
    t, o, h, l, c = ser
    e = py_ema(c, 200); ed = py_emadir(c, e)
    for mult in (2.5, 3.0, 3.5):
        _a, _u, _d, pr_, pv_ = CG.st_full(h, l, c, 10, mult)
        _a, _u, _d, pr35, pv35 = CG.st_full(h, l, c, 10, 3.5)
        for i in range(1, len(c)):
            if pr_[i] == 0.0:
                continue
            sg = int(pr_[i]); lv = pv_[i]
            for mo in (0, 1):
                righe.append("S %d 0 %d %r %r %r 5 %r %r 20" % (mo, sg, lv, lv - sg * 5.0, min(l[max(0, i - 2):i + 1]) if sg > 0 else max(h[max(0, i - 2):i + 1]), pv35[i], pr35[i]))
    for i in range(1, len(c)):
        if ed[i] != 0.0:
            sg = int(ed[i])
            for mo in (0, 1):
                righe.append("S %d 0 %d %r %r %r 5 %r %r 20" % (mo, sg, e[i], e[i] - sg * 5.0, e[i], e[i], ed[i]))
    txt = "\n".join(righe) + "\n"
    g = lambda exe: subprocess.run([exe], input=txt, capture_output=True, text=True).stdout.split("\n")
    a, b, cc = g(e10), g(e11), g(ece)
    diverse = sum(1 for x, y in zip(a, b) if x != y) + abs(len(a) - len(b))
    diverse_ce = sum(1 for x, y in zip(a, cc) if x != y)
    gd = diff_versioni(v110, src111, FUNZ_NUOVE_V111, TOK_V111, TOLTE_OK_V111, AGGIUNTE_OK_V111, ())
    ce1 = diff_versioni(v110, src111.replace("double x4=profondo-s*buf;", "double x4=profondo-s*buf*2.0;", 1), FUNZ_NUOVE_V111, TOK_V111, TOLTE_OK_V111, AGGIUNTE_OK_V111, ())
    ce2 = diff_versioni(v110, src111.replace("   if(es==2) gImb[IMB_O_STOPX4]++;", "   if(es==2) gImb[IMB_O_STOPX4]++;\n   gU=gU*2.0;", 1),
                        FUNZ_NUOVE_V111, TOK_V111, TOLTE_OK_V111, AGGIUNTE_OK_V111, ())
    return len(righe), diverse, diverse_ce, (not gd and len(ce1) > 0 and len(ce2) > 0), "; ".join(gd[:4])


def mutanti(raw, ser):
    src = raw.decode("ascii")
    M = [
        ("tocco con < invece di <=", "return (l[i]<=lv+tol) ? 1 : 0;", "return (l[i]<lv+tol) ? 1 : 0;"),
        ("ogni barra che tocca conta come episodio", "if(tc && !prev)", "if(tc)"),
        ("azzeramento per distacco a 1", "if(dist>=distaccoAtr*atrN[i-1]) nEp=0;", "if(dist>=distaccoAtr*atrN[i-1]) nEp=1;"),
        ("stop: vince il piu' VICINO", "if(s>0) return MathMin(crit,base);", "if(s>0) return MathMax(crit,base);"),
        ("lotto arrotondato e non per difetto", "double lot=MathFloor(v/step+1e-9)*step;", "double lot=MathRound(v/step)*step;"),
        ("lotto sotto il minimo ALZATO al minimo", "if(lot<vmin-1e-12) return 0.0;", "if(lot<vmin-1e-12) return vmin;"),
        ("ADX con < invece di <=", "if(adxApplica && !(adx<=adxMax)) return 1;", "if(adxApplica && !(adx<adxMax)) return 1;"),
        ("ordine oltre dal lato sbagliato", "p[2]=linea-s*oltre*u;", "p[2]=linea+s*oltre*u;"),
        ("Supertrend con la chiusura sbagliata nel ratchet", "upF[i]=(ub<upF[i-1] || c[i-1]>upF[i-1]) ? ub : upF[i-1];",
         "upF[i]=(ub<upF[i-1] || c[i]>upF[i-1]) ? ub : upF[i-1];"),
        ("placebo col segno sbagliato", "return val[i-1]+dir[i-1]*placeboAtr*atrN[i-1];", "return val[i-1]-dir[i-1]*placeboAtr*atrN[i-1];"),
        ("Guardian tolto dall'invio dei limit", "if(!ABTG_GuardiaIngresso(InpUsaGuardian,\"EA_NatCla\")){ gImb[IMB_O_GUARDIAN]++; if(logga)",
         "if(false){ gImb[IMB_O_GUARDIAN]++; if(logga)"),
        ("rischio di default 1%", "input double InpRischioSetupPct    = 0.25;", "input double InpRischioSetupPct    = 1.0;"),
        ("bandiera B1 accesa di default", "input ENUM_NC_PESI3 InpPesiScala   = NC_PESI_1_1_1;", "input ENUM_NC_PESI3 InpPesiScala   = NC_PESI_1_2_1;"),
        ("handle ADX non rilasciato", "int hs[8]={hEma200,hEma14,hEma89,hEma9,hEma21,hAtrN,hAdx,hBands};",
         "int hs[8]={hEma200,hEma14,hEma89,hEma9,hEma21,hAtrN,hBands,hBands};"),
        ("StringFormat con un argomento in meno", "gTag[L],Lato(s),toccoN,P(lv),P(sl),piazzati,adx,incl,dc));",
         "gTag[L],Lato(s),toccoN,P(lv),P(sl),piazzati,adx,incl));"),
        ("TP EMA89 confrontata con l'ingresso invece che col TP1", "if(s*(e89-rif)>0.0) return e89;", "if(s*(e89-ingresso)>0.0) return e89;"),
        ("X5 senza la distanza minima", "if(tp==0.0 || g<minU*(1.0-1e-9)) return 1;", "if(tp==0.0 || g<0.0) return 1;"),
        ("EMA200: chiusura == EMA diventa long", "if(c[i]>e[i]) dir[i]=1.0;", "if(c[i]>=e[i]) dir[i]=1.0;"),
        ("tolto il rifiuto di sl<=0 dal mercato", "   if(sl<=0){ gImb[IMB_O_SLND]++; return false; }     // MAI un ordine senza stop\n   if(!ABTG_GuardiaIngresso(InpUsaGuardian,\"EA_NatCla\")){ gImb[IMB_O_GUARDIAN]++; Log(",
         "   if(!ABTG_GuardiaIngresso(InpUsaGuardian,\"EA_NatCla\")){ gImb[IMB_O_GUARDIAN]++; Log("),
        ("CSV: una colonna in meno nella riga del setup", "IntegerToString(gSet[L].toccoN)+\";;;;;;;\"",
         "IntegerToString(gSet[L].toccoN)+\";;;;;;\""),
        ("magic fuori dal blocco", "gMagic=778600+10*(long)InpModalita+cifraTF;", "gMagic=770600+10*(long)InpModalita+cifraTF;"),
        # --- giro cieco del cancello 07/10 sul RACCORDO (6 su 8 erano VERDI prima di invarianti_raccordo)
        ("C1 lato invertito sui limit", "bool ok=(s>0) ? gTrade.BuyLimit(lot,price,_Symbol,sl,tp,tt,ex,cm)",
         "bool ok=(s<0) ? gTrade.BuyLimit(lot,price,_Symbol,sl,tp,tt,ex,cm)"),
        ("C2 SL azzerato sul SellLimit", "                 : gTrade.SellLimit(lot,price,_Symbol,sl,tp,tt,ex,cm);",
         "                 : gTrade.SellLimit(lot,price,_Symbol,sl*0,tp,tt,ex,cm);"),
        ("C3 lotto non arrotondato", "         lotti[i]=NC_LottoGiu(w[i]*b,step,vmin,vmax);", "         lotti[i]=w[i]*b;"),
        ("C4 conteggio non azzerato al flip", "   while(s0>first && dir[s0-1]==d) s0--;", "   while(s0>first) s0--;"),
        ("C5 ADX scollegato", "   bool adxApplica=gAdxUsa && L!=NC_LEMA", "   bool adxApplica=false && L!=NC_LEMA"),
        ("C6 inclinazione scollegata", "   int r=NC_Contesto(s,adxApplica,adx,InpAdxMax,gInclUsa,incl,",
         "   int r=NC_Contesto(s,adxApplica,adx,InpAdxMax,false,incl,"),
        ("C7 orologio spostato di un'ora", "   if(TimeCurrent()-gTbar0>NC_GRAZIA_SEC)", "   if(TimeCurrent()+3600-gTbar0>NC_GRAZIA_SEC)"),
        ("C8 riga d'avvio: rischio stampato dal placebo",
         "\"MERCATO_PIU_PENDENTE\",InpRischioSetupPct,", "\"MERCATO_PIU_PENDENTE\",InpPlaceboAtr,"),
        # --- secondo giro cieco del cancello 07/10 (10 su 10 VERDI prima di blocco puro + invarianti 7-13)
        ("D1 ATR letto con shift 2", "if(CopyBuffer(hAtrN,0,1,n,gAtrN)!=n) return false;", "if(CopyBuffer(hAtrN,0,2,n,gAtrN)!=n) return false;"),
        ("D2 semaforo cancella la linea riempita", "if(K!=L && gSet[K].attivo && !gSet[K].riempito", "if(K==L && gSet[K].attivo && !gSet[K].riempito"),
        ("D3 conteggio con >=", "if(gTocchiMax[L]>0 && prossimo>gTocchiMax[L])", "if(gTocchiMax[L]>0 && prossimo>=gTocchiMax[L])"),
        ("D4 solo LONG blocca i long", "   if(direzione==1 && s<0) return false;", "   if(direzione==1 && s>0) return false;"),
        ("D5 max tocchi 3.5 AUDIO a 1", "gTocchiMax[NC_L35]=DaModI(InpTocchiMax35,2,0,2);", "gTocchiMax[NC_L35]=DaModI(InpTocchiMax35,1,0,2);"),
        ("D6 stop agganciato all'ordine sulla linea", "double sl=NormPrezzo(NC_StopSetup((int)InpStopModo,gSLCrit,s,lv,p[2],", "double sl=NormPrezzo(NC_StopSetup((int)InpStopModo,gSLCrit,s,lv,p[1],"),
        ("D7 rischio x10", "   return saldo*p/100.0;", "   return saldo*p/10.0;"),
        ("D8 perdita per lotto dimezzata", "OrderCalcProfit(ORDER_TYPE_BUY,_Symbol,1.0,px,px-dist,prof)", "OrderCalcProfit(ORDER_TYPE_BUY,_Symbol,1.0,px,px-dist*0.5,prof)"),
        ("D9 pip x10", "   return (cifre==3 || cifre==5) ? punto*10.0 : punto;", "   return (cifre==3 || cifre==5) ? punto*100.0 : punto;"),
        ("E1 BuyLimit: controllo prezzo rovesciato", "if(price>=ask-md) return 1;", "if(price<=ask-md) return 1;"),
        ("E2 SellLimit: SL dal lato sbagliato accettato", "if(sl<=price || sl-price<md) return 2;", "if(sl>=price || sl-price<md) return 2;"),
        ("E7 requote preso per buono", "return(rc==TRADE_RETCODE_DONE || rc==TRADE_RETCODE_PLACED", "return(rc==TRADE_RETCODE_DONE || rc==TRADE_RETCODE_REQUOTE || rc==TRADE_RETCODE_PLACED"),
        ("E8 netting accettato", "if(AccountInfoInteger(ACCOUNT_MARGIN_MODE)!=ACCOUNT_MARGIN_MODE_RETAIL_HEDGING)", "if(AccountInfoInteger(ACCOUNT_MARGIN_MODE)==ACCOUNT_MARGIN_MODE_RETAIL_HEDGING)"),
        ("D10 X10 al primo riempimento", "if(no>0 && np<gSet[L].nPosId && !gSet[L].residuiCancellati)", "if(no>0 && np<=gSet[L].nPosId && !gSet[L].residuiCancellati)"),
        # --- seconda lettura del cancello 07/10: sei mutanti sui percorsi di denaro (il primo era VERDE)
        ("F1 rischio x10 al chiamante", "InpRischioSetupPct,InpMoltConfluenza,dc,InpConflTolAtr,gRischioMax);",
         "InpRischioSetupPct*10,InpMoltConfluenza,dc,InpConflTolAtr,gRischioMax);"),
        ("F2 perdita per lotto dimezzata nel ripiego", "loss=(dist/tsz)*tv;", "loss=(dist/tsz)*tv*0.5;"),
        ("F3 buffer dello stop dal lato sbagliato", "double base=profondo-s*buf;", "double base=profondo+s*buf;"),
        ("F4 SL=0 sull'ordine a mercato", "gTrade.Buy(lot,_Symbol,px,sl,tp,cm)", "gTrade.Buy(lot,_Symbol,px,0,tp,cm)"),
        ("F5 lotto quasi per eccesso", "double lot=MathFloor(v/step+1e-9)*step;", "double lot=MathFloor(v/step+0.999)*step;"),
        ("F6 Guardian saltato sul mercato", "if(!ABTG_GuardiaIngresso(InpUsaGuardian,\"EA_NatCla\")){ gImb[IMB_O_GUARDIAN]++; Log(",
         "if(false){ gImb[IMB_O_GUARDIAN]++; Log("),
        # --- i sei residui VERDI del terzo giro del primo cancello (ora invarianti 16-21)
        ("G1 scadenza applicata alla scala", "InviaLimit(s,p[i],lot[i],sl,tp[i],0,cm,!gArmatoPrima[L])",
         "InviaLimit(s,p[i],lot[i],sl,tp[i],gTbar0+PeriodSeconds(gTF),cm,!gArmatoPrima[L])"),
        ("G2 verso del TP1", "bool hit=(s>0) ? (bid>=gSet[L].tp1) : (ask<=gSet[L].tp1);", "bool hit=(s>0) ? (bid<=gSet[L].tp1) : (ask>=gSet[L].tp1);"),
        ("G3 durata in secondi", ">=(long)InpDurataMaxMin*60)", ">=(long)InpDurataMaxMin)"),
        ("G4 unita' dell'oro a 0,1", "descr=\"AUTO_CLASSE metallo: 1,0 USD\"; return 1.0;", "descr=\"AUTO_CLASSE metallo: 1,0 USD\"; return 0.1;"),
        ("G5 conferma PDF rovesciata", "if(gConferma && !(s*(op0-lv0)>0))", "if(gConferma && (s*(op0-lv0)>0))"),
        ("G6 adozione al riavvio tolta", "   AdottaEsistenti();\n   return(INIT_SUCCEEDED);", "   return(INIT_SUCCEEDED);"),
        # --- le tre righe aggiunte dalla seconda lettura
        ("H1 ricalcolo ADX MetaQuotes con 1/n", "   double k=2.0/(per+1.0);", "   double k=1.0/per;"),
        ("H2 pendenti orfani lasciati vivi", "if(np==0 && no>0 && TimeCurrent()", "if(np==0 && no<0 && TimeCurrent()"),
        ("H3 scala viva senza dati", "if(gSet[L].attivo && !gSet[L].riempito && gSet[L].tipo==NC_TIPO_SCALA)\n           { CancellaSetupNonRiempito(L,\"dati",
         "if(false && gSet[L].attivo && !gSet[L].riempito && gSet[L].tipo==NC_TIPO_SCALA)\n           { CancellaSetupNonRiempito(L,\"dati"),
        ("H4 verifica ADX sulla barra sbagliata", "   double t=gAdx[gN-1];", "   double t=gAdx[gN-2];"),
        # --- terza lettura del cancello 07/10: sette mutanti sui percorsi nuovi (I3, I4, I7 erano VERDI)
        ("I1 cancellazione degli orfani rimossa", "{ gOrfTent[L]=TimeCurrent(); CancellaOrdiniLinea(L,\"pendenti senza setup",
         "{ gOrfTent[L]=TimeCurrent(); Log(\"pendenti senza setup"),
        ("I2 orfani: np==0 invertita", "if(np==0 && no>0 && TimeCurrent()", "if(np!=0 && no>0 && TimeCurrent()"),
        ("I3 filtro magic tolto nella cancellazione",
         "      if(OrderGetString(ORDER_SYMBOL)!=_Symbol || OrderGetInteger(ORDER_MAGIC)!=gMagic) continue;\n      if(LineaDaCommento(OrderGetString(ORDER_COMMENT))!=L) continue;\n      if(gTrade.OrderDelete",
         "      if(OrderGetString(ORDER_SYMBOL)!=_Symbol) continue;\n      if(LineaDaCommento(OrderGetString(ORDER_COMMENT))!=L) continue;\n      if(gTrade.OrderDelete"),
        ("I4 parziale che lascia il residuo sotto il minimo", "if(cv>0 && cv<v && v-cv>=vmin-1e-12) gTrade", "if(cv>0 && cv<v) gTrade"),
        ("I5 VERIFICA ADX che spegne una linea", "         \" -> il terminale coincide con: \",chi);\n",
         "         \" -> il terminale coincide con: \",chi);\n   if(StringFind(chi,\"NESSUNA\")==0) gUsaLinea[2]=false;\n"),
        ("I6 ritentativo degli orfani a ogni tick", "if(np==0 && no>0 && TimeCurrent()-gOrfTent[L]>=NC_ORF_PAUSA_SEC)", "if(np==0 && no>0)"),
        ("I7 filtro simbolo tolto nella cancellazione",
         "      if(OrderGetString(ORDER_SYMBOL)!=_Symbol || OrderGetInteger(ORDER_MAGIC)!=gMagic) continue;\n      if(LineaDaCommento(OrderGetString(ORDER_COMMENT))!=L) continue;\n      if(gTrade.OrderDelete",
         "      if(OrderGetInteger(ORDER_MAGIC)!=gMagic) continue;\n      if(LineaDaCommento(OrderGetString(ORDER_COMMENT))!=L) continue;\n      if(gTrade.OrderDelete"),
        # --- v1.03 (decisione di Claudio 07/10/2026): modalita' PDF esclusa in OnInit (invariante 28)
        ("J1 rifiuto della modalita' PDF rimosso",
         "   if(InpModalita==NC_PDF)\n     { Print(\"[NatCla] AVVIO RIFIUTATO: modalita PDF esclusa da Claudio il 07/10/2026: Ea Nat&Cla segue solo gli audio\"); return(INIT_PARAMETERS_INCORRECT); }\n",
         ""),
        ("J2 rifiuto della modalita' PDF che fa partire l'EA", "segue solo gli audio\"); return(INIT_PARAMETERS_INCORRECT); }",
         "segue solo gli audio\"); return(INIT_SUCCEEDED); }"),
        # --- v1.04 (cancello sulla v1.03): manopole solo-PDF rifiutate in Risolvi (invariante 29)
        ("K1 blocco solo-PDF che non rifiuta piu'", "   if(pdfx!=\"\"){ err=\"manopole nate SOLO dal PDF (escluso da Claudio il 07/10/2026):\"+pdfx; return false; }\n",
         "   if(pdfx!=\"\") Print(\"[NatCla] AVVISO manopole PDF:\",pdfx);\n"),
        ("K2 TP EMA14/EMA89 di nuovo ammesso in AUDIO", "   if(gTPCrit==2) pdfx+=\" InpTPCriterio=EMA14_POI_EMA89\";\n", ""),
        ("K3 il blocco spegne anche la scala AUDIO 1:2:1", "   if(InpPesiPdf!=NC_PESI_1_1) pdfx+=",
         "   if(InpPesiPdf!=NC_PESI_1_1 || InpPesiScala!=NC_PESI_1_1_1) pdfx+="),
        ("K4 confluenza: rifiutata l'etichetta AUDIO invece dell'obbligatoria", "   if(gConfl==2) pdfx+=", "   if(gConfl==1) pdfx+="),
        ("K5 enum rinumerato: EMA200=3 (magic M2 77862x -> 77863x)", "   NC_EMA200=2     // EMA200:", "   NC_EMA200=3     // EMA200:"),
        # --- v1.05 (diagnosi NATCLA_DIAG_U30 07/10): il tocco degli handle in CaricaDati (invariante 31 + modello del tester pigro)
        ("T1 tocco su UN solo handle (EMA200)", "   CopyBuffer(hAtrN,0,1,1,tocco);\n   CopyBuffer(hAdx,0,1,1,tocco);\n", ""),
        ("T2 tocco DOPO il controllo BarsCalculated", TOCCO + DOPO_TOCCO + BC_LINEA, DOPO_TOCCO + BC_LINEA + TOCCO),
        ("T3 esito del tocco usato per uscire", "   CopyBuffer(hEma200,0,1,1,tocco);\n", "   if(CopyBuffer(hEma200,0,1,1,tocco)!=1) return false;\n"),
        ("T4 tocco dopo l'uscita per barre insufficienti", TOCCO + DOPO_TOCCO, DOPO_TOCCO + TOCCO),
        ("T5 tocco sull'handle sbagliato (EMA14 invece di EMA200)", "   CopyBuffer(hEma200,0,1,1,tocco);\n", "   CopyBuffer(hEma14,0,1,1,tocco);\n"),
        ("T6 esito del tocco assegnato e usato", "   CopyBuffer(hAdx,0,1,1,tocco);\n", "   int tk=CopyBuffer(hAdx,0,1,1,tocco); if(tk<0) return false;\n"),
        ("T7 versione rimasta 1.10 (v1.11)", '#define NC_VER "1.11"', '#define NC_VER "1.10"'),
        # --- v1.10 (decisione di Claudio 08/10): la regola di stop OLTRE_LINEA_ESTERNA (unitari V, barre vere, invarianti 32-41, guardia del diff)
        ("V1 stop OLTRE dal lato sbagliato", "double oltreLinea=lineaEst-s*oltre;", "double oltreLinea=lineaEst+s*oltre;"),
        ("V2 X4 tolto sul long", "   if(s>0 && oltreLinea>x4) { r=x4; esito=2; }\n", ""),
        ("V3 linea esterna discorde non scartata", "if(dirEst!=(double)s || !(lineaEst>0.0)) { esito=1; return 0.0; }", "if(!(lineaEst>0.0)) { esito=1; return 0.0; }"),
        ("V4 GEOMETRIA_ATTUALE che legge la linea esterna", "if(modo!=1 && modo!=2) return NC_Stop(criterio,s,linea,profondo,estremo,buf);",
         "if(modo!=1 && modo!=2) return (lineaEst>0.0 && dirEst==(double)s) ? MathMin(NC_Stop(criterio,s,linea,profondo,estremo,buf),lineaEst) : NC_Stop(criterio,s,linea,profondo,estremo,buf);"),
        ("V5 default OLTRE (default non neutro)", "InpStopModo = NC_STOP_GEOMETRIA_ATTUALE;", "InpStopModo = NC_STOP_OLTRE_LINEA_ESTERNA;"),
        ("V6 default 10 u invece di 20", "input double InpStopOltreU      = 20.0;", "input double InpStopOltreU      = 10.0;"),
        ("V7 CSV del conteggio sempre in GEOMETRIA_ATTUALE", "double sl=NC_StopSetup((int)InpStopModo,gSLCrit,s,lv0,", "double sl=NC_StopSetup(0,gSLCrit,s,lv0,"),
        ("V8 linea di setup al posto della linea esterna", "lest=NormPrezzo(LineaEsternaPrezzo(last,s)); dest=gXD[last];", "lest=lv; dest=gXD[last];"),
        ("V9 linea esterna col moltiplicatore della linea di setup", "gMultLinea[F],gXa", "gMultLinea[L],gXa"),
        ("V10 famiglia: EMA200 misurata sulla ST3,5", "return (L==3) ? 3 : 2;", "return (L==3) ? 2 : 2;"),
        ("V11 oltre non moltiplicato per l'unita'", "InpStopOltreU*gU,es));", "InpStopOltreU,es));"),
        ("V12 esito 1 che non scarta", "if(es==1){ gImb[IMB_O_STOPEST]++;", "if(es==7){ gImb[IMB_O_STOPEST]++;"),
        ("V13 placebo senza verso sulla linea esterna", "return gXV[k]+s*InpPlaceboAtr*gAtrN[k];", "return gXV[k]+InpPlaceboAtr*gAtrN[k];"),
        ("V14 CSV: linea_stop scritta dalla linea di setup", "P(gSet[L].lineaStop)", "P(gSet[L].linea)"),
        ("V15 stop_ped calcolato su uno stop scartato", "D((ped>0 && es!=1) ? MathAbs(p[0]-sl)/ped : 0,1)", "D((ped>0) ? MathAbs(p[0]-sl)/ped : 0,1)"),
        ("V16 linea esterna calcolata anche in GEOMETRIA_ATTUALE", "if(InpStopModo==NC_STOP_OLTRE_LINEA_ESTERNA) CalcolaLineaEsterna(L);", "CalcolaLineaEsterna(L);"),
        ("V17 criterio a mano accettato con OLTRE", "if(InpSLCriterio!=NC_SL_DA_MODALITA){ err=", "if(false){ err="),
        ("V18 linea esterna scritta sugli array della linea di setup", "gMultLinea[F],gXa,gXu,gXdn,gXD,gXV);", "gMultLinea[F],gXa,gXu,gXdn,gLD,gLV);"),
        ("V19 X4 dello short contato come regola", "if(s<0 && oltreLinea<x4) { r=x4; esito=2; }", "if(s<0 && oltreLinea<x4) { r=x4; esito=0; }"),
        ("V20 X4 dello short rovesciato", "if(s<0 && oltreLinea<x4)", "if(s<0 && oltreLinea>x4)"),
        ("V21 colonne nuove fuori dalla coda (stop_modo prima di motivo)", "durata_min;motivo;stop_modo;linea_stop;stop_esito", "durata_min;stop_modo;motivo;linea_stop;stop_esito"),
        # --- v1.11 (Claudio 09/10 "Proviamole entrambe"): OLTRE_PIU_ESTERNA (unitari W, oro, invarianti 32-43)
        ("W1 long: la piu' ALTA invece della piu' bassa", "return (s>0) ? MathMin(v1,v2) : MathMax(v1,v2);", "return (s>0) ? MathMax(v1,v2) : MathMax(v1,v2);"),
        ("W2 EMA200 dal lato opposto accettata", "bool ok2=(d2==(double)s && v2>0.0);", "bool ok2=(v2>0.0);"),
        ("W3 nessuna linea dal lato del setup ma direzione s (setup non scartato)", "dirOut=(ok1 || ok2) ? (double)s : 0.0;", "dirOut=(double)s;"),
        ("W4 modo 2 ricade su NC_Stop (GEOMETRIA_ATTUALE)", "if(modo!=1 && modo!=2) return NC_Stop(", "if(modo!=1) return NC_Stop("),
        ("W5 EMA200 senza placebo fra le candidate", "gEma[k]+s*InpPlaceboAtr*gAtrN[k],gXE[k],dir);", "gEma[k],gXE[k],dir);"),
        ("W6 direzione dell'EMA200 presa dalla ST3,5", "gAtrN[k],gXE[k],dir);", "gAtrN[k],gXD[k],dir);"),
        ("W7 direzione dell'EMA200 mai calcolata", "{ ArrayResize(gXE,gN); NC_EmaDir(gC,gEma,gN,gXE); }", "{ ArrayResize(gXE,gN); }"),
        ("W8 CSV del conteggio senza il modo 2", "   if(InpStopModo==NC_STOP_OLTRE_PIU_ESTERNA){ lest=LineaPiuEsternaPrezzo(L,last,s,dest); }\n", ""),
        ("W9 ordini in modo 2 con la linea del modo 1", "lest=NormPrezzo(LineaPiuEsternaPrezzo(L,last,s,dest));", "lest=NormPrezzo(LineaEsternaPrezzo(last,s)); dest=gXD[last];"),
        ("W10 riga AVVIO del modo 2 come modo 1", "return \"OLTRE_PIU_ESTERNA \"+", "return \"OLTRE_LINEA_ESTERNA \"+"),
        ("W11 linee esterne non calcolate in modo 2", "      if(InpStopModo==NC_STOP_OLTRE_PIU_ESTERNA) CalcolaLineaEsterna(L);\n", ""),
        ("W12 Risolvi controlla solo il modo 1", "   if(InpStopModo!=NC_STOP_GEOMETRIA_ATTUALE)\n     {", "   if(InpStopModo==NC_STOP_OLTRE_LINEA_ESTERNA)\n     {"),
        ("W13 short: la piu' BASSA", "? MathMin(v1,v2) : MathMax(v1,v2);", "? MathMin(v1,v2) : MathMin(v1,v2);"),
        ("W14 ST3,5 dal lato opposto accettata", "bool ok1=(d1==(double)s && v1>0.0);", "bool ok1=(v1>0.0);"),
        ("W15 enum del modo 2 a 3 (NC_StopSetup lo tratterebbe come GEOMETRIA_ATTUALE)", "NC_STOP_OLTRE_PIU_ESTERNA=2", "NC_STOP_OLTRE_PIU_ESTERNA=3"),
    ]
    base = tempfile.mkdtemp(prefix="natcla_mutanti_")     # FUORI dal repo (classe 1159)
    assert not os.path.abspath(base).startswith(os.path.abspath(ROOT))
    presi = 0
    try:
        for k, (lab, old, new) in enumerate(M):
            if src.count(old) != 1:
                check(False, "mutante '%s': testo non trovato una volta (%d)" % (lab, src.count(old)))
                continue
            mut = src.replace(old, new, 1)
            d = os.path.join(base, "m%02d" % k)
            os.makedirs(d)
            p = os.path.join(d, "EA_NatCla.mq5")
            with open(p, "w", encoding="ascii") as f:
                f.write(mut)
            bag, _ = suite(leggi(p), os.path.join(d, "cxx"), ser, False)
            if check(len(bag) > 0, "MUTANTE CIECO PRESO: %s (%d controlli falliti, es. %s)" % (lab, len(bag), (bag[0][:90] if bag else "-"))):
                presi += 1
    finally:
        shutil.rmtree(base, ignore_errors=True)
    return presi, len(M)


def main():
    print("== Collaudo strato 1 EA_NatCla.mq5 (NON prova compilazione MQL5, tester, Guardian, iADX del terminale) ==")
    raw = leggi(SRC)
    print("== S) STATICO ==")
    bag = []
    src = statico(raw, bag)
    check(not bag, "controlli statici sul sorgente vero (%d difetti) %s" % (len(bag), bag[:6]))
    nfun = len(set(re.findall(r"(?<![\w.])([A-Za-z_]\w*)\s*\(", maschera(src))) & set(API))
    print("       funzioni MQL5 distinte chiamate e controllate: %d; metodi CTrade: %d" %
          (nfun, len(set(re.findall(r"\bgTrade\.(\w+)\s*\(", maschera(src))))))
    sw = CG.read(PULS)
    a = re.search(r"int SW_STCore\(.*?\n  \}\n", sw, re.S).group(0)
    b = re.search(r"int NC_STCore\(.*?\n  \}\n", src, re.S).group(0)
    norm = lambda x: re.sub(r"\s+", "", CG.strip_code(x))
    check(norm(a).replace("SW_STCore", "NC_STCore") == norm(b), "NC_STCore == SW_STCore della casa (testo, a meno del nome)")
    altri = magic_libero()
    check(not altri, "blocco magic 7786xx libero nel repo fuori dai file Nat&Cla (%s)" % altri[:3])
    # v1.10: la prova del tocco resta, sulla v1.05 del suo pin (storia: la v1.05 e' la base della v1.10)
    r105 = subprocess.run(["git", "-C", ROOT, "show", "%s:mql5/Experts/EA_NatCla.mq5" % V105_COMMIT], capture_output=True)
    esito, det = solo_il_tocco(r105.stdout.decode("ascii")) if r105.returncode == 0 else (None, "v1.05 non leggibile (%s)" % V105_COMMIT)
    check(esito is True, "v1.05 (pin %s) = v1.04 (commit %s) + il SOLO tocco in CaricaDati + le due stringhe di versione: nessun'altra modifica di logica, CSV, magic, input %s"
          % (V105_COMMIT, V104_COMMIT, det))
    esito, det, ce = solo_lo_stop(src)
    check(esito is True, "v1.11 = v1.05 (pin %s) + SOLO le regole di stop (v1.10 + v1.11): righe tolte nell'elenco, righe aggiunte con un simbolo della v1.10/v1.11 %s" % (V105_COMMIT, det))
    check(ce is True, "CONTRO-ESEMPIO della guardia del diff: NC_BARRE_MIN 300 -> 301 e una riga 'gU=gU*2.0;' aggiunta in Risolvi sono VISTE")

    print("== P + N) funzioni pure C++ e numeri su barre reali dell'oro (HistData, +6 h, NON BCM) ==")
    ser = serie_tf(60, 2023)
    if not check(ser is not None and len(ser[4]) > 15000, "barre H1 dell'oro dal 2023 (%d)" % (len(ser[4]) if ser else 0)):
        sys.exit(1)
    with tempfile.TemporaryDirectory() as tmpi:
        nr, dv, dce, guardia, det = identita_v110(src, ser, tmpi)
        check(nr is not None and nr > 100000 and dv == 0,
              "IDENTITA' v1.10 (pin %s) -> v1.11: NC_StopSetup in GEOMETRIA_ATTUALE e OLTRE_LINEA_ESTERNA, %s ingressi (8000 casuali + ogni scala dell'oro H1, 4 linee), "
              "uscite diverse %s %s" % (V110_COMMIT, nr, dv, det))
        check(dce is not None and dce > 1000, "CONTRO-ESEMPIO dell'identita': una v1.11 con lo stop OLTRE dal lato sbagliato da' %s uscite diverse dalla v1.10" % dce)
        check(guardia is True, "v1.11 = v1.10 (pin %s) + SOLO il modo OLTRE_PIU_ESTERNA (guardia del diff, con 2 contro-esempi visti) %s" % (V110_COMMIT, det))
    with tempfile.TemporaryDirectory() as tmp:
        bag, res = suite(raw, os.path.join(tmp, "vero"), ser, True)
        check(not bag, "suite completa sul sorgente vero (%d difetti) %s" % (len(bag), bag[:6]))
        if res is not None:
            t, o, h, l, c = ser
            righe, anni = conteggi(t, h, l, c, res, True)
            spec = ((151, 101, 37, 40), (121, 84, 34, 36), (97, 88, 37, 36))
            print("       finestra 2024-07-10 -> 2026-09-18 (%.2f anni), AUDIO H1, per anno:" % anni)
            print("       linea | episodi (spec) | entro 1/1/2 (spec) | +ADX Wilder<=20 (spec 37/34/37, ricontato 40/36/36) | +iADX MT5<=20 | Wilder alla barra prima")
            for L, (ep_, en_, w_, m_, pw_) in enumerate(righe):
                s = spec[L]
                print("       %s  | %6.1f (%d)    | %6.1f (%d)        | %6.1f                                              | %6.1f        | %6.1f"
                      % (("2.5", "3.0", "3.5")[L], ep_, s[0], en_, s[1], w_, m_, pw_))
                check(abs(ep_ - s[0]) <= 0.03 * s[0], "linea %s: episodi/anno %.1f entro il 3%% della specifica (%d)" % (("2.5", "3.0", "3.5")[L], ep_, s[0]))
                check(abs(en_ - s[1]) <= 0.03 * s[1], "linea %s: entro il limite audio %.1f entro il 3%% della specifica (%d)" % (("2.5", "3.0", "3.5")[L], en_, s[1]))
                check(33 <= w_ <= 42, "linea %s: setup/anno con ADX Wilder <= 20 = %.1f dentro 33-42 (specifica 35-40)" % (("2.5", "3.0", "3.5")[L], w_))
                check(14 <= m_ <= 20, "linea %s: setup/anno con iADX MT5 <= 20 (default EA) = %.1f dentro 14-20 (specifica corretta 07/10: 16/18/16)" % (("2.5", "3.0", "3.5")[L], m_))
            # v1.10 (informativo, NON un criterio): la regola OLTRE sui SETUP dell'oro H1 (HistData, NON BCM), stop 20 USD oltre la linea esterna.
            #      La scala che si riempie alla barra i e' quella armata alla chiusura della barra i-1: esito e distanza si leggono li'.
            if STOP_BARRE is not None:
                ep_ = dt.datetime(1970, 1, 1)
                da_ = int((dt.datetime(2024, 7, 10) - ep_).total_seconds() // 60)
                a_ = int((dt.datetime(2026, 9, 19) - ep_).total_seconds() // 60)
                print("       v1.10 OLTRE_LINEA_ESTERNA 20 u sull'oro H1 (u = 1 USD), sui setup 2024-07-10 -> 2026-09-18 (episodi entro 1/1/2, EMA200 illimitato):")
                print("       linea | setup | regola | discorde/scartato | vince X4 | distanza linea->stop (ordine sulla linea) USD: mediana / P10-P90 | /pedaggio 0,25")
                for L in range(4):
                    v_, d_, k_, seg_, ne_, tl_, nu_, ei_ = res[L]
                    lim_ = (1, 1, 2, 0)[L]
                    idx_ = [i for i in range(1, len(c)) if da_ <= t[i] < a_ and nu_[i] == 1 and (lim_ == 0 or ne_[i] <= lim_) and (i - 1) in STOP_BARRE[1][L]]
                    es_ = [STOP_BARRE[1][L][i - 1] for i in idx_]
                    di_ = sorted(x[1] for x in es_ if x[1] is not None)
                    q = lambda f: di_[min(len(di_) - 1, int(f * (len(di_) - 1) + 0.5))] if di_ else float("nan")
                    print("       %-5s | %5d | %6d | %17d | %8d | %6.1f / %.1f-%.1f | %6.0fx" % (("ST25", "ST30", "ST35", "E200")[L], len(es_), sum(1 for x in es_ if x[0] == 0),
                          sum(1 for x in es_ if x[0] == 1), sum(1 for x in es_ if x[0] == 2), q(.5), q(.1), q(.9), q(.5) / 0.25))
                    if L in (2, 3):
                        check(all(x[0] == 0 and x[1] is not None and abs(x[1] - 20.0) < 1e-6 for x in es_) and es_,
                              "v1.10: linea %s = linea esterna di se stessa: su TUTTI i %d setup stop esattamente 20 u oltre la linea, nessuno scartato, nessun X4"
                              % (("ST25", "ST30", "ST35", "E200")[L], len(es_)))
                print("       v1.11 OLTRE_PIU_ESTERNA 20 u, stessi setup: per linea esito e allargamento dello stop rispetto a OLTRE_LINEA_ESTERNA (USD)")
                print("       linea | setup | regola | scartato | vince X4 | distanza linea->stop mediana (P10-P90) | allargati / mediana allargamento | armati in piu' (v1.10 scartava)")
                for L in range(4):
                    v_, d_, k_, seg_, ne_, tl_, nu_, ei_ = res[L]
                    lim_ = (1, 1, 2, 0)[L]
                    idx_ = [i for i in range(1, len(c)) if da_ <= t[i] < a_ and nu_[i] == 1 and (lim_ == 0 or ne_[i] <= lim_) and (i - 1) in STOP_BARRE[2][L]]
                    e2_ = [STOP_BARRE[2][L][i - 1] for i in idx_]
                    e1_ = [STOP_BARRE[1][L][i - 1] for i in idx_]
                    di_ = sorted(x[1] for x in e2_ if x[1] is not None)
                    q = lambda f: di_[min(len(di_) - 1, int(f * (len(di_) - 1) + 0.5))] if di_ else float("nan")
                    al_ = sorted(b_[1] - a1[1] for a1, b_ in zip(e1_, e2_) if a1[1] is not None and b_[1] is not None and b_[1] - a1[1] > 1e-9)
                    piu_ = sum(1 for a1, b_ in zip(e1_, e2_) if a1[0] == 1 and b_[0] != 1)
                    print("       %-5s | %5d | %6d | %8d | %8d | %6.1f (%.1f-%.1f) | %4d / %6.1f | %4d" % (("ST25", "ST30", "ST35", "E200")[L], len(e2_), sum(1 for x in e2_ if x[0] == 0),
                          sum(1 for x in e2_ if x[0] == 1), sum(1 for x in e2_ if x[0] == 2), q(.5), q(.1), q(.9), len(al_),
                          al_[len(al_) // 2] if al_ else float("nan"), piu_))
                    if L == 3:
                        check(e2_ == e1_ and e2_, "v1.11: linea E200 (M2): OLTRE_PIU_ESTERNA == OLTRE_LINEA_ESTERNA su tutti i %d setup (una sola linea)" % len(e2_))
                    else:
                        check(all(b_[1] is None or a1[1] is None or b_[1] >= a1[1] - 1e-9 for a1, b_ in zip(e1_, e2_)),
                              "v1.11: linea %s: lo stop OLTRE_PIU_ESTERNA non e' mai PIU' VICINO di OLTRE_LINEA_ESTERNA (sui setup armati in tutti e due i modi)"
                              % ("ST25", "ST30", "ST35")[L])
            # H4/D1 solo informativi: dipendono dall'orologio (specifica par. 5.4)
            for mins, lab in ((240, "H4"), (1440, "D1")):
                s2 = serie_tf(mins, 2021)
                e2 = py_ema(s2[4], 200); a2 = py_atr(s2[2], s2[3], s2[4], 14)
                cx2 = Cxx(src, os.path.join(tmp, "tf%d" % mins))
                r2 = gira_serie(cx2, s2[2], s2[3], s2[4], e2, a2, CONFIG[0])
                rr, an = conteggi(s2[0], s2[2], s2[3], s2[4], r2, False)
                print("       %s (informativo, dipende dall'orologio): episodi/anno %s; entro il limite %s; +ADX Wilder %s"
                      % (lab, "/".join("%.0f" % x[0] for x in rr), "/".join("%.0f" % x[1] for x in rr), "/".join("%.0f" % x[2] for x in rr)))

    if not SENZA_MUTANTI:
        print("== M) MUTANTI CIECHI (copia in cartella temporanea FUORI dal repo; suite ridotta: H1 2025-2026) ==")
        ser_m = serie_tf(60, 2025)
        presi, tot = mutanti(raw, ser_m)
        check(presi == tot, "mutanti presi %d su %d" % (presi, tot))

    print()
    if FAILS:
        print("ESITO: %d CONTROLLI FALLITI" % len(FAILS))
        for f in FAILS:
            print("  - " + f)
        sys.exit(1)
    print("ESITO: TUTTO OK (strato 1: statico, funzioni pure, numeri sull'oro HistData, mutanti). NON prova: compilazione MQL5, "
          "tester, riempimenti, Guardian, iADX/iATR/iMA del terminale, orologio BCM.")


if __name__ == "__main__":
    main()
