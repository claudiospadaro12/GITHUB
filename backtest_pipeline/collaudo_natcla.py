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
  M) MUTANTI CIECHI: 43 mutazioni del sorgente (logica pura, codice d'ordine, raccordo) applicate a una COPIA in
     una cartella temporanea FUORI dal repo (classe 1159: niente mutanti committati); per ognuna si rigira
     la STESSA suite (S + P + N ridotto) senza sapere quale mutazione c'e': deve FALLIRE almeno un
     controllo. Un mutante che passa = buco del collaudo.

Uso:   python3 backtest_pipeline/collaudo_natcla.py [--senza-mutanti]
Esce con 0 solo se tutto passa. NON prova: compilazione MQL5, CTrade/riempimenti, Guardian, iADX/iATR/iMA
del terminale, tick reali, orologio BCM (il feed e' HistData, NON BCM).
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
        k = src.find("if(" + cond + ")")
        if k < 0 or "AVVISO BANDIERA" not in src[k:k + 300]:
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
                 "modalita' ": "NomeModalita()"}
        for k_, v_ in mappa.items():
            pos = [j for j, p in enumerate(pezzi[:-1]) if p.endswith(k_)]
            if len(pos) != 1 or pos[0] >= len(val) or val[pos[0]] != v_:
                bag.append("RACCORDO: riga d'avvio, '%s' non stampa %s" % (k_.strip(), v_))
    nospazi = re.sub(r"\s+", "", code)
    # (7) DATI: barre e buffer copiati dalla STESSA posizione (1 = ultima chiusa) e nello stesso numero
    cd = corpo(code, "CaricaDati") or ""
    for m in re.finditer(r"\b(CopyRates|CopyBuffer)\s*\(", cd):
        a = [cd[x:y].strip() for x, y in argomenti(cd, m.end() - 1, chiusa(cd, m.end() - 1))]
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
    # (11) STOP: il 'profondo' passato a NC_Stop e' l'ultimo ordine del setup (scala p[2], PDF p[1])
    for fn, att in (("ArmaScala", "p[2]"), ("EntraPdf", "p[1]"), ("ScriviConta", "p[2]")):
        b = corpo(code, fn) or ""
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


def magic_libero():
    r = subprocess.run(["git", "-C", ROOT, "grep", "-nE", r"\b7786[0-9]{2}\b", "--", ".",
                        ":!.claude", ":!mql5/Experts/EA_NatCla.mq5", ":!backtest_pipeline/collaudo_natcla.py",
                        ":!report/NATCLA_*"], capture_output=True, text=True)
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
def suite(raw, tmp, ser, verbose):
    bag = []
    src = statico(raw, bag)
    cx = Cxx(src, tmp)
    if not cx.ok:
        bag.append("il blocco puro non compila in C++: %s" % cx.err[:300])
        return bag, None
    try:
        unitari(cx, bag)
        res, e, a = confronta_numeri(cx, ser, bag, verbose)
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
        ("D6 stop agganciato all'ordine sulla linea", "double sl=NormPrezzo(NC_Stop(gSLCrit,s,lv,p[2],", "double sl=NormPrezzo(NC_Stop(gSLCrit,s,lv,p[1],"),
        ("D7 rischio x10", "   return saldo*p/100.0;", "   return saldo*p/10.0;"),
        ("D8 perdita per lotto dimezzata", "OrderCalcProfit(ORDER_TYPE_BUY,_Symbol,1.0,px,px-dist,prof)", "OrderCalcProfit(ORDER_TYPE_BUY,_Symbol,1.0,px,px-dist*0.5,prof)"),
        ("D9 pip x10", "   return (cifre==3 || cifre==5) ? punto*10.0 : punto;", "   return (cifre==3 || cifre==5) ? punto*100.0 : punto;"),
        ("E1 BuyLimit: controllo prezzo rovesciato", "if(price>=ask-md) return 1;", "if(price<=ask-md) return 1;"),
        ("E2 SellLimit: SL dal lato sbagliato accettato", "if(sl<=price || sl-price<md) return 2;", "if(sl>=price || sl-price<md) return 2;"),
        ("E7 requote preso per buono", "return(rc==TRADE_RETCODE_DONE || rc==TRADE_RETCODE_PLACED", "return(rc==TRADE_RETCODE_DONE || rc==TRADE_RETCODE_REQUOTE || rc==TRADE_RETCODE_PLACED"),
        ("E8 netting accettato", "if(AccountInfoInteger(ACCOUNT_MARGIN_MODE)!=ACCOUNT_MARGIN_MODE_RETAIL_HEDGING)", "if(AccountInfoInteger(ACCOUNT_MARGIN_MODE)==ACCOUNT_MARGIN_MODE_RETAIL_HEDGING)"),
        ("D10 X10 al primo riempimento", "if(no>0 && np<gSet[L].nPosId && !gSet[L].residuiCancellati)", "if(no>0 && np<=gSet[L].nPosId && !gSet[L].residuiCancellati)"),
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

    print("== P + N) funzioni pure C++ e numeri su barre reali dell'oro (HistData, +6 h, NON BCM) ==")
    ser = serie_tf(60, 2023)
    if not check(ser is not None and len(ser[4]) > 15000, "barre H1 dell'oro dal 2023 (%d)" % (len(ser[4]) if ser else 0)):
        sys.exit(1)
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
