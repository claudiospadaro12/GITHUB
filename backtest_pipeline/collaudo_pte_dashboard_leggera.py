#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Collaudo STRATO 1 di mql5/Indicators/ABTG_PTE_Dashboard_Leggera.mq5 (dashboard PTE leggera, 07/10/2026).

Qui NON c'e' MetaEditor: niente compila l'MQL5, niente gira nel terminale. Si prova quello che si puo'
provare a tavolino e si dichiara il resto.

  S) STATICO sul sorgente vero: ASCII puro; parentesi bilanciate (fuori da commenti/stringhe); blocco puro
     //@@PD_PURE_BEGIN..END una volta; ogni funzione MQL5 chiamata e' in una lista di firme note (numero di
     argomenti controllato chiamata per chiamata); StringFormat/PrintFormat: segnaposto == argomenti;
     NIENTE trading/rete/file/handle (OrderSend, CTrade, WebRequest, FileOpen, iATR, iCustom, CopyBuffer...);
     default degli input == specifica (35 simboli nelle 5 liste, 37 nell'originale: domanda a Claudio; H1/H4/D1 accesi, canale
     "uno dei due", alert spenti, confronto spento); funzioni COPIATE dall'EA ABTG_PTE.mq5 identiche nel
     testo (ciclo TMA, IsDoji, Heikin Ashi a 2 barre di seme).
  R) RACCORDO (il codice NON puro, quello che parla col terminale): la copia dei dati sta dietro al
     controllo "barra nuova" e all'orario della prossima barra; copia col numero MINIMO di barre
     (gBisogno = PD_Bisogno); ChartRedraw solo se qualcosa e' cambiato; oggetti toccati solo se testo/colore
     cambiano; timer acceso/spento; oggetti cancellati in OnDeinit; alert solo su segnale nuovo
     dell'ultima barra chiusa e mai al primo calcolo; OnCalculate vuoto; numero di oggetti dichiarato.
  P) FUNZIONI PURE VERE estratte dal .mq5 e compilate in C++: casi scritti a mano col valore atteso
     (doji al bordo del 10%, ATR, TMA dell'EA, TMA centrata, uscita "stretta" dal canale, testo delle celle
     su date note, barre minime = 131 coi default), e i controlli di storico corto.
  N) NUMERI su barre REALI dell'oro (XAUUSD M1 HistData in repo -> H1/H4/D1, orologio +6 h come
     collaudo_natcla.py: NON e' il feed BCM): PD_Ultimo sulla FINESTRA minima di barre (come la copia del
     terminale) == specchio Python INDIPENDENTE calcolato sull'intera serie (somme cumulative, iATR a somma
     mobile, Heikin Ashi dalla prima barra), su 6 configurazioni; testo delle celle == datetime di Python su
     2000 istanti casuali. CONTRO-ESEMPI: con 2 sole barre di seme la Heikin Ashi ricorsiva DIVERGE (il
     confronto morde); un ATR alla Wilder si distingue dall'iATR di MT5.
     INFORMATIVO (non e' un verdetto): quante celle si accendono per TF, e quanto la TMA dell'EA
     (non-repaint) concorda con la TMA centrata (ipotesi dell'originale).
  M) MUTANTI CIECHI: mutazioni del sorgente applicate a una COPIA in una cartella temporanea FUORI dal repo
     (classe 1159); per ognuna si rigira la stessa suite ridotta: deve FALLIRE almeno un controllo.

  V) v1.10 (07/10/2026 sera): tasti HIDE/REFRESH/HA/DOJI/EMA 9-21/ST 3 LIV, click su simbolo/cella/TF, candele HA
     disegnate, frecce doji, EMA con incrocio, Supertrend 3 livelli. STRUTTURA buffer/plot (indici, nomi, tipi, colori);
     RACCORDO (click con la riga/colonna della cella cliccata, SymbolSelect, grafico nuovo o questo; REFRESH azzera TUTTE
     le cache e non copia nell'handler; HIDE = nessuna copia e il tasto resta; DOJI OFF = niente frecce e niente
     calcolo; stato dei tasti in GlobalVariable con ChartID); funzioni COPIATE identiche da ABTG_Pulsanti_Grafico.mq5
     (SW_STCore anche = NC_STCore di EA_NatCla.mq5); NUMERI: PD_Bersaglio su tutte le celle 35x3 + 28 nomi da rifiutare
     (contro-esempio riga/colonna scambiata), EMA e Supertrend bit per bit con lo specchio, seme e indipendenza
     dall'inizio della finestra, HA incrementale con barra provvisoria (contro-esempio da = prev_calculated), frecce doji
     == tutte le doji dello specchio e la prima == la cella; MODELLO ESEGUIBILE dei colori (funzioni VERE estratte,
     grafico finto, due istanze: ricarico da click nei due ordini, crash, toggle, clrNONE come 4294967295 e -1).

Uso:   python3 backtest_pipeline/collaudo_pte_dashboard_leggera.py [--senza-mutanti]
Esce con 0 solo se tutto passa. NON prova: compilazione MQL5, aspetto grafico (posizioni, font, angoli),
SeriesInfoInteger/CopyRates/oggetti del terminale, il feed BCM, l'equivalenza con la dashboard originale.
"""
import calendar
import datetime as dt
import os
import random
import re
import shutil
import subprocess
import sys
import tempfile
import zipfile

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
SRC = os.path.join(ROOT, "mql5/Indicators/ABTG_PTE_Dashboard_Leggera.mq5")
EA = os.path.join(ROOT, "mql5/Experts/ABTG_PTE.mq5")
ZIPDIR = os.path.join(ROOT, "backtest_pipeline/risultati_prove/oro_m1_histdata_zip")
SENZA_MUTANTI = "--senza-mutanti" in sys.argv
FAILS = []


def check(cond, msg, quiet=False, bag=None):
    if not quiet:
        print(("  ok   " if cond else "  FAIL ") + msg)
    if not cond:
        (bag if bag is not None else FAILS).append(msg)
    return cond


def leggi(p):
    with open(p, "rb") as f:
        return f.read()


# ===========================================================================
# S) STATICO -- maschera/chiusa/argomenti/corpo COPIATE da collaudo_natcla.py
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
        if src[i] == '"' or src[i] == "'":
            q = src[i]
            j = i + 1
            while j < n and src[j] != q:
                j += 2 if src[j] == "\\" else 1
            for k in range(i + 1, min(j, n)):
                out[k] = "x"
            i = j + 1
            continue
        i += 1
    return "".join(out)


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


# firme MQL5 note: nome -> (min, max) argomenti (documentazione MQL5, firme pubbliche)
API = {
    "ObjectFind": (2, 2), "ObjectCreate": (6, 30), "ObjectSetInteger": (4, 5), "ObjectSetString": (4, 5),
    "ObjectsDeleteAll": (1, 4), "ChartRedraw": (0, 1), "EventSetTimer": (1, 1), "EventKillTimer": (0, 0),
    "TimeCurrent": (0, 1), "SeriesInfoInteger": (3, 4), "CopyRates": (5, 5), "SymbolExist": (2, 2),
    "SymbolInfoInteger": (2, 3), "StringSplit": (3, 3), "StringTrimLeft": (1, 1), "StringTrimRight": (1, 1),
    "StringLen": (1, 1), "StringSubstr": (2, 3), "ArrayResize": (2, 3), "ArrayInitialize": (2, 2),
    "ArraySetAsSeries": (2, 2), "IntegerToString": (1, 3), "TimeToString": (1, 2), "StringFormat": (1, 64),
    "PrintFormat": (1, 64), "Print": (1, 64), "PeriodSeconds": (0, 1), "ChartIndicatorsTotal": (2, 2),
    "ChartIndicatorName": (3, 3), "IndicatorSetString": (2, 3), "EnumToString": (1, 1), "Alert": (1, 64),
    "PlaySound": (1, 1), "MathMax": (2, 2), "MathMin": (2, 2), "MathAbs": (1, 1),
    # v1.10 (click, tasti, buffer del grafico, stato in GlobalVariable)
    "StringFind": (2, 3), "StringGetCharacter": (2, 2), "ChartID": (0, 0), "GetLastError": (0, 0),
    "GlobalVariableSet": (2, 2), "GlobalVariableGet": (1, 2), "GlobalVariableCheck": (1, 1), "GlobalVariableDel": (1, 1),
    "ChartGetInteger": (2, 4), "ChartSetInteger": (3, 4), "ChartSetSymbolPeriod": (3, 3), "ChartOpen": (2, 2),
    "SymbolSelect": (2, 2), "SetIndexBuffer": (2, 3), "PlotIndexSetInteger": (3, 4), "PlotIndexSetString": (3, 3),
    "IndicatorSetInteger": (2, 3),
}
KEYW = {"if", "for", "while", "switch", "return", "sizeof", "else"}
VIETATI = ["OrderSend", "CTrade", "Trade.mqh", "PositionOpen", "WebRequest", "Socket", "SendMail",
           "SendNotification", "SendFTP", "FileOpen", "FileWrite", "#import", ".dll", "GlobalVariableTemp",
           "GlobalVariablesDeleteAll", "ChartApplyTemplate", "ChartSaveTemplate", "iCustom", "iATR", "iMA(", "CopyBuffer", "ExpertRemove", "ShellExecute",
           "iTime(", "iClose(", "iOpen(", "iHigh(", "iLow("]
LISTE = {
    "InpLista1": "AUDCAD,AUDCHF,AUDJPY,AUDNZD,AUDUSD,CADCHF,CADJPY,CHFJPY",
    "InpLista2": "EURAUD,EURCAD,EURCHF,EURGBP,EURJPY,EURNZD,EURUSD",
    "InpLista3": "GBPAUD,GBPCAD,GBPCHF,GBPJPY,GBPNZD,GBPUSD,NZDCAD",
    "InpLista4": "NZDCHF,NZDJPY,NZDUSD,USDCAD,USDCHF,USDJPY,XAUUSD,USOIL",
    "InpLista5": "225JPY,D30EUR,SPXUSD,U30USD,NASUSD",
}
DEFAULT_ATTESI = {
    "InpAngolo": "CORNER_LEFT_UPPER", "InpOffsetX": "80", "InpOffsetY": "75", "InpLarghezzaCella": "72",
    "InpAltezzaCella": "18", "InpFontSize": "8", "InpSuffisso": '""', "InpSoloMarketWatch": "true",
    "InpM15": "false", "InpM30": "false", "InpH1": "true", "InpH4": "true", "InpH8": "false", "InpH12": "false",
    "InpD1": "true", "InpW1": "false", "InpMN": "false",
    "InpSoloFuoriCanale": "true", "InpCanale": "PD_CH_UNO", "InpTmaModo": "PD_TMA_EA",
    "InpTmaLento": "56", "InpAtrLento": "100", "InpMultLento": "2.0", "InpTmaVeloce": "14", "InpAtrVeloce": "30",
    "InpMultVeloce": "2.0", "InpCorpoMaxPct": "10.0", "InpCandela": "PD_CAND_HA_EA", "InpUsaCode": "false",
    "InpRapCodaInf": "2.0", "InpRapCodaSup": "2.0", "InpConfermaFlip": "false", "InpBarreIndietro": "30",
    "InpSemeHA": "50", "InpColRialzo": "C'39,174,96'", "InpColRibasso": "C'192,57,43'",
    "InpAlertPopup": "false", "InpAlertSuono": "false", "InpAlertMinuti": "5",
    "InpModoConfronto": "false", "InpCellePerCiclo": "20", "InpRicontrolloSec": "5",
    # v1.10: HA ACCESO di default ("di default c'erano le candele heikenashi"), doji sul grafico accese,
    # tabella visibile, EMA e Supertrend spenti, click sullo STESSO grafico, canali TMA spenti
    "InpHaDefault": "true", "InpDojiDefault": "true", "InpNascostaDefault": "false", "InpEmaDefault": "false",
    "InpStDefault": "false", "InpClickNuovoGrafico": "false", "InpDisegnaCanali": "false", "InpBarreCanali": "300",
    "InpEmaVeloce": "9", "InpEmaLenta": "21", "InpStPeriodo": "10", "InpStMult1": "2.5", "InpStMult2": "3.0",
    "InpStMult3": "3.5",
}
# ogni campo di PD_Par e l'input da cui DEVE arrivare (raccordo: un campo scollegato non lo vede nessun numero)
PAR_DA_INPUT = {"candela": "(int)InpCandela", "tmaModo": "(int)InpTmaModo", "tmaS": "InpTmaLento", "atrS": "InpAtrLento",
                "multS": "InpMultLento", "tmaF": "InpTmaVeloce", "atrF": "InpAtrVeloce", "multF": "InpMultVeloce",
                "corpoMaxPct": "InpCorpoMaxPct", "soloFuori": "InpSoloFuoriCanale", "canale": "(int)InpCanale",
                "usaCode": "InpUsaCode", "rapInf": "InpRapCodaInf", "rapSup": "InpRapCodaSup", "flip": "InpConfermaFlip",
                "semeHA": "InpSemeHA"}


def norm(x):
    return re.sub(r"\s+", "", x)


def statico(raw, bag, ea_src):
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
    if src.count("//@@PD_PURE_BEGIN") != 1 or src.count("//@@PD_PURE_END") != 1:
        bag.append("marcatori del blocco puro non presenti una volta")
        return src
    definite = set(re.findall(r"^[ \t]*(?:const\s+)?(?:int|double|bool|void|string|datetime|long|color)\s+(\w+)\s*\(",
                              code, re.M))
    definite |= set(re.findall(r"#define\s+(\w+)", code))
    for m in re.finditer(r"(?<![\w.])([A-Za-z_]\w*)\s*\(", code):
        nome = m.group(1)
        if nome in KEYW or nome in definite:
            continue
        riga = code.count("\n", 0, m.start()) + 1
        if nome not in API:
            bag.append("funzione MQL5 non nella lista delle firme note: %s (r.%d)" % (nome, riga))
            continue
        i = m.end() - 1
        na = len(argomenti(code, i, chiusa(code, i)))
        lo, hi = API[nome]
        if not (lo <= na <= hi):
            bag.append("%s chiamata con %d argomenti (attesi %d-%d) r.%d" % (nome, na, lo, hi, riga))
    if re.search(r"\b\w+\.(?!open\b|high\b|low\b|close\b|time\b)[a-z]\w*\s*\(", code):
        bag.append("chiamata di metodo su un oggetto (atteso: nessuna)")
    for m in re.finditer(r"\b(StringFormat|PrintFormat)\s*\(", code):
        i = m.end() - 1
        args = argomenti(code, i, chiusa(code, i))
        a0, b0 = args[0]
        lit = src[a0:b0].strip()
        if not (lit.startswith('"') and lit.endswith('"')):
            bag.append("%s senza formato letterale" % m.group(1))
            continue
        spec = re.findall(r"%(?!%)[-+ #0]*\d*(?:\.\d+)?(?:I64|ll|l|h)?[diouxXeEfgGsc]", lit.replace("%%", ""))
        if len(spec) != len(args) - 1:
            bag.append("%s r.%d: %d segnaposto contro %d argomenti" % (m.group(1), code.count("\n", 0, m.start()) + 1,
                                                                       len(spec), len(args) - 1))
    for v in VIETATI:
        if v in code:
            bag.append("vietato presente (sola visione): %s" % v)
    # default degli input
    inputs = dict(re.findall(r"^\s*input\s+\w+\s+(Inp\w+)\s*=\s*([^;]+);", src, re.M))
    for k, v in list(DEFAULT_ATTESI.items()) + [(k, '"%s"' % v) for k, v in LISTE.items()]:
        if k not in inputs:
            bag.append("input mancante: %s" % k)
        elif inputs[k].strip() != v:
            bag.append("default di %s = %s, atteso %s" % (k, inputs[k].strip(), v))
    tutti = ",".join(LISTE[k] for k in sorted(LISTE)).split(",")
    # NB: le 5 liste del mandato fanno 35 simboli (28 forex + XAUUSD + USOIL + 5 indici), non 37: domanda a Claudio
    if len(tutti) != 35 or len(set(tutti)) != 35:
        bag.append("le 5 liste di specifica non fanno 35 simboli distinti (%d)" % len(tutti))
    # enum: valori interni attesi dal blocco puro (canale 0..3, candela 0..2, tma 0..1)
    for nome, val in (("PD_CH_LENTO", 0), ("PD_CH_VELOCE", 1), ("PD_CH_UNO", 2), ("PD_CH_ENTRAMBI", 3),
                      ("PD_CAND_GIAPPONESE", 0), ("PD_CAND_HA_EA", 1), ("PD_CAND_HA_PIENA", 2),
                      ("PD_TMA_EA", 0), ("PD_TMA_CENTRATA", 1)):
        if not re.search(r"\b%s\s*=\s*%d\b" % (nome, val), code):
            bag.append("enum %s non vale %d (il blocco puro conta su quel numero)" % (nome, val))
    # funzioni COPIATE dall'EA: testo identico (a meno degli spazi e del nome della soglia)
    ea = maschera(ea_src)
    tma_loop = norm("double tma=0;for(int k=0;k<m;k++){double s=0;for(int j=0;j<m;j++)s+=c[shift+k+j];tma+=s/m;}tma/=m;")
    if tma_loop not in norm(ea):
        bag.append("riferimento: il ciclo TMA dell'EA e' cambiato (aggiornare il collaudo)")
    if tma_loop not in norm(corpo(code, "PD_TmaEA") or ""):
        bag.append("PD_TmaEA: ciclo TMA NON identico a quello di ABTG_PTE.mq5 TmaBand")
    if "intm=(period+1)/2;if(m<1)m=1;intneed=period+m+shift+5;" not in norm(code) or \
       "intm=(period+1)/2;if(m<1)m=1;intneed=period+m+shift+5;" not in norm(ea):
        bag.append("PD_TmaEA: m e need non identici all'EA")
    dj_ea = "doublerange=h-l;if(range<=0)return(false);return(MathAbs(c-o)<=InpDojiBodyMaxPct/100.0*range);"
    dj = norm(corpo(code, "PD_IsDoji") or "").replace("bodyMaxPct", "InpDojiBodyMaxPct")
    if dj_ea not in norm(ea) or dj_ea not in dj:
        bag.append("PD_IsDoji NON identica a IsDoji dell'EA")
    ha_ea = re.findall(r"double (?:haC|haO_prev|haC_prev|haO)=[^;]*;", ea)
    ha_ea = [norm(x).replace("iOpen(_Symbol,InpTF,shift+2)", "o[shift+2]").replace("iClose(_Symbol,InpTF,shift+2)", "c[shift+2]")
             for x in ha_ea]
    ha_ea = [re.sub(r"i(Open|High|Low|Close)\(_Symbol,InpTF,(shift(?:\+\d)?)\)",
                    lambda m_: {"Open": "o", "High": "h", "Low": "l", "Close": "c"}[m_.group(1)] + "[" + m_.group(2) + "]", x)
             for x in ha_ea]
    cand = norm(corpo(code, "PD_Candela") or "")
    if len(ha_ea) != 4 or any(x not in cand for x in ha_ea):
        bag.append("PD_Candela modo 1: formule Heikin Ashi NON identiche a GetCandle dell'EA (%d trovate)" % len(ha_ea))
    if "H=MathMax(H,MathMax(O,C));L=MathMin(L,MathMin(O,C));" not in cand:
        bag.append("PD_Candela: manca l'allargamento di massimo/minimo al corpo HA (come l'EA)")
    raccordo(src, code, bag)
    return src


def raccordo(src, code, bag):
    """invarianti SEMANTICI sul codice che parla col terminale (non estraibile in C++)"""
    el = norm(corpo(code, "Elabora") or "")
    if not el:
        bag.append("Elabora non trovata")
        return
    if code.count("CopyRates(") != 1 or "CopyRates(" not in el:
        bag.append("CopyRates deve esistere UNA volta sola, dentro Elabora")
    ic = el.find("CopyRates(")
    for pezzo, perche in (("if(ora<gProssimo[k])return(false);", "orario della prossima barra"),
                          ("if(lb!=0&&lb==gUltBarra[k]){gProssimo[k]=ora+InpRicontrolloSec;return(false);}", "barra nuova (cache)"),
                          ("if(gStatoSim[i]!=0)return(false);", "simbolo non disponibile saltato"),
                          ("datetimelb=(datetime)SeriesInfoInteger(s,tf,SERIES_LASTBAR_DATE);", "lettura dell'ultima barra")):
        k = el.find(pezzo)
        if k < 0 or k > ic:
            bag.append("RACCORDO: la copia dei dati non e' preceduta dal controllo '%s'" % perche)
    if "intgot=CopyRates(s,tf,0,gBisogno,gR);" not in el:
        bag.append("RACCORDO: CopyRates non copia gBisogno barre dalla barra 0 nell'array gR")
    if "if(got<gBisogno){Rinvia(k,ora);returntrue;}".replace("returntrue", "return(true)") not in el:
        bag.append("RACCORDO: copia corta non rinviata")
    if "gBisogno=PD_Bisogno(gPar,InpBarreIndietro);" not in norm(code):
        bag.append("RACCORDO: gBisogno non viene da PD_Bisogno(gPar,InpBarreIndietro)")
    if "intr=PD_Ultimo(gO,gH,gL,gC,got,InpBarreIndietro,gPar,sh,a,b,a1,b1);" not in el:
        bag.append("RACCORDO: PD_Ultimo non riceve la finestra copiata, le barre di ricerca e i parametri")
    if "for(intx=0;x<got;x++){gO[x]=gR[x].open;gH[x]=gR[x].high;gL[x]=gR[x].low;gC[x]=gR[x].close;}" not in el:
        bag.append("RACCORDO: gli array O/H/L/C non sono la copia campo per campo di gR")
    if "datetimetseg=(r!=0?gR[sh].time:(datetime)0);" not in el:
        bag.append("RACCORDO: l'ora del segnale non e' l'apertura della candela del segnale (gR[sh].time)")
    if "gUltBarra[k]=gR[0].time;" not in el or "gProssimo[k]=gR[0].time+DurataBarra(tf);" not in el:
        bag.append("RACCORDO: dopo il calcolo la cache non registra la barra e l'orario della prossima")
    if "gDir[k]=r;gTSeg[k]=tseg;gDF[k]=a;gDS[k]=b;gDF1[k]=a1;gDS1[k]=b1;" not in el:
        bag.append("RACCORDO: lo stato della cella non e' quello calcolato")
    if "if(r==PD_NODATI){Rinvia(k,ora);return(true);}" not in el:
        bag.append("RACCORDO: storico corto non rinviato")
    al = "if((InpAlertPopup||InpAlertSuono)&&r!=0&&sh==1&&gPronta[k]&&tseg!=gTSeg[k]&&ora-gUltAllerta[k]>=(long)InpAlertMinuti*60)"
    if al not in el:
        bag.append("RACCORDO: condizione degli alert diversa (segnale nuovo, barra 1, non al primo calcolo, tempo minimo)")
    if el.find(al) > el.find("gDir[k]=r;"):
        bag.append("RACCORDO: l'alert va valutato PRIMA di aggiornare lo stato (altrimenti tseg==gTSeg sempre)")
    if "ArraySetAsSeries(gR,true);" not in norm(code):
        bag.append("RACCORDO: gR non e' in ordine serie (indice 0 = barra in formazione)")
    ri = corpo(code, "Rinvia") or ""
    if "gAttesa[k]=(gAttesa[k]<=0?2:(gAttesa[k]>=150?300:gAttesa[k]*2));gProssimo[k]=ora+gAttesa[k];" not in norm(ri):
        bag.append("RACCORDO: attesa crescente 2..300 s non come dichiarato")
    # ChartRedraw: nel timer sotto gRidisegna, in OnDeinit e UNA volta nel ramo dei tasti di OnChartEvent (v1.10)
    if code.count("ChartRedraw(") != 3:
        bag.append("ChartRedraw deve comparire 3 volte (timer condizionato + OnDeinit + tasti), trovate %d" % code.count("ChartRedraw("))
    ot = norm(corpo(code, "OnTimer") or "")
    if "if(gRidisegna){gRidisegna=false;ChartRedraw(0);}" not in ot:
        bag.append("RACCORDO: ChartRedraw del timer non condizionato a gRidisegna")
    oe_ = norm(corpo(code, "OnChartEvent") or "")
    if oe_.count("ChartRedraw(") != 1 or "if(tasto){" not in oe_ or oe_.find("ChartRedraw(") < oe_.find("if(tasto){"):
        bag.append("RACCORDO: ChartRedraw di OnChartEvent fuori dal ramo dei tasti")
    gc_ = norm(corpo(code, "GiroCelle") or "")
    if "while(viste<tot&&fatte<InpCellePerCiclo)" not in gc_ or "if(Elabora(k,ora))fatte++;" not in gc_:
        bag.append("RACCORDO: il giro delle celle non limita le copie per ciclo a InpCellePerCiclo")
    od = norm(corpo(code, "OnDeinit") or "")
    if "EventKillTimer();" not in od or "if(gProprietario){ObjectsDeleteAll(0,PD_PREF);ObjectsDeleteAll(0,PD_DOJI);}" not in od:
        bag.append("RACCORDO: OnDeinit non spegne il timer o non cancella gli oggetti PDL_ e le frecce PDLG_d_")
    oi = norm(corpo(code, "OnInit") or "")
    if "EventSetTimer(1);" not in oi:
        bag.append("RACCORDO: timer non a 1 s in OnInit")
    for c_, v_ in PAR_DA_INPUT.items():
        if "gPar.%s=%s;" % (c_, v_) not in oi:
            bag.append("RACCORDO: gPar.%s non e' %s in OnInit" % (c_, v_))
    oc = norm(corpo(code, "OnCalculate") or "")
    if "CopyRates(" in oc or "Elabora(" in oc or "SeriesInfoInteger(" in oc:
        bag.append("OnCalculate (grafico corrente) non deve copiare dati ne' toccare la tabella")
    ag = norm(corpo(code, "AggiornaCella") or "")
    for pz in ("if(txt!=gTxt[k]){ObjectSetString(0,NomeT(i,j),OBJPROP_TEXT,txt);gTxt[k]=txt;gRidisegna=true;}",
               "if(bg!=gBg[k]){ObjectSetInteger(0,NomeR(i,j),OBJPROP_BGCOLOR,bg);gBg[k]=bg;gRidisegna=true;}",
               "txt=PD_Testo(gTSeg[k],PeriodSeconds(gTF[j]));", "bg=(gDir[k]>0?InpColRialzo:InpColRibasso);",
               "if(tip!=gTip[k])"):
        if pz not in ag:
            bag.append("RACCORDO AggiornaCella: manca '%s'" % pz[:60])
    if ag.count("ObjectSet") != 4:
        bag.append("AggiornaCella: oggetti toccati fuori dai controlli di cambio (%d ObjectSet, attesi 4)" % ag.count("ObjectSet"))
    st = norm(corpo(code, "Struttura") or "")
    # pannello+titolo+PAIR (3) | per TF: rett+etich (2) | per simbolo: etich (1) + per TF rett+etich (2)
    if st.count("Rett(") != 3 or st.count("Etic(") != 5 or st.count("Bottone(") != 6:
        bag.append("Struttura: %d Rett, %d Etic, %d Bottone (attesi 3, 5, 6 -> 9+2*nTF+nS*(1+2*nTF) oggetti)"
                   % (st.count("Rett("), st.count("Etic("), st.count("Bottone(")))
    if "9+2*gNT+gNS*(1+2*gNT)" not in norm(code):
        bag.append("conteggio oggetti stampato diverso dalla formula")
    if "260 oggetti" not in src:
        bag.append("la testata non dichiara 260 oggetti coi default (9+2*3+35*7)")
    du = norm(corpo(code, "DurataBarra") or "")
    if "if(tf==PERIOD_MN1)return(28*86400);returnPeriodSeconds(tf);".replace("returnPeriodSeconds(tf)", "return(PeriodSeconds(tf))") not in du:
        bag.append("DurataBarra: MN deve usare il mese piu' corto (28 giorni)")
    raccordo_cancello(src, code, bag)
    raccordo_v11(src, code, bag)


def raccordo_cancello(src, code, bag):
    """ANCORE aggiunte dal cancello (controllo-preventivo, 07/10/2026, classe 1068): 16 mutanti ciechi su 20,
    scritti su righe di raccordo NON scelte dall'autore, erano VERDI (fra questi: tabella SEMPRE vuota con
    'gPronta' mai vera, Market Watch invertito, cursore fermo sulla cella 0, titolo '2 COPIE' sempre acceso)."""
    sc = re.sub(r"//[^\n]*", "", src)            # sorgente senza commenti, stringhe intatte
    el = norm(corpo(code, "Elabora") or "")
    ic = el.find("CopyRates(")
    # lb==0 non deve rinviare SENZA copiare: e' la CopyRates che fa costruire la serie
    if "if(lb==0)" in el[:max(ic, 0)]:
        bag.append("CANCELLO: con la serie vuota (lb==0) si rinvia senza mai chiamare CopyRates: la cella puo' non riempirsi MAI")
    # [lettore indipendente 07/10: l'ancora sul solo testo 'if(lb==0)' lasciava VERDE if(!lb) / if(0==lb) / if(lb<=0) / if(lb<1)]
    # STRUTTURALE: prima di CopyRates restano esattamente 3 uscite (stato simbolo, gProssimo, cache sulla barra); una quarta e' la regressione 1170
    if ic < 0 or el[:ic].count("return(") != 3:
        bag.append("CANCELLO: prima di CopyRates ci sono %d uscite (attese 3: stato simbolo, attesa, cache): una uscita in piu' puo' rinviare senza copiare" % (el[:ic].count("return(") if ic >= 0 else -1))
    for pz, perche in (("gPronta[k]=true;", "la cella non diventa mai 'pronta' (tabella sempre vuota)"),
                       ("gAttesa[k]=0;", "l'attesa crescente non si azzera dopo un calcolo riuscito")):
        if pz not in el or el.find(pz) < ic:
            bag.append("CANCELLO Elabora: %s" % perche)
    sa = norm(corpo(code, "AggiornaStatoSimboli") or "")
    for pz, perche in (("if(!SymbolExist(gSym[i],custom))st=2;", "simbolo inesistente"),
                       ("elseif(InpSoloMarketWatch&&SymbolInfoInteger(gSym[i],SYMBOL_SELECT)==0)st=1;", "fuori dal Market Watch"),
                       ("if(st==gStatoSim[i])continue;", "stato invariato saltato"),
                       ("if(st==0){gProssimo[k]=0;gAttesa[k]=0;gUltBarra[k]=0;}", "al rientro nel Market Watch la cella si ricalcola subito")):
        if pz not in sa:
            bag.append("CANCELLO AggiornaStatoSimboli: manca il controllo '%s'" % perche)
    ot = norm(corpo(code, "OnTimer") or "")
    gc = norm(corpo(code, "GiroCelle") or "")
    for pz, perche, dove in (("gCursore=(gCursore+1)%tot;", "il cursore avanza di una cella", gc),
                             ("if(ora-gUltStato>=60)", "stato dei simboli ogni 60 s", gc),
                             ("if(gGiri%10==3)ControllaDoppio();", "controllo delle due copie (ogni 10 s)", ot)):
        if pz not in dove:
            bag.append("CANCELLO OnTimer/GiroCelle: manca '%s'" % perche)
    # il nome vero dell'oggetto si controlla sul sorgente a stringhe INTATTE (nel mascherato qualunque stringa da 8 caratteri passa)
    otv = norm(corpo(sc, "OnTimer") or "")
    if 'if(ObjectFind(0,PD_PREF+"pannello")<0||ObjectFind(0,PD_PREF+"b_hide")<0)Struttura();' not in otv:
        bag.append("CANCELLO OnTimer: manca la ricostruzione degli oggetti coi nomi veri 'pannello' e 'b_hide' (cancellati a mano o dall'istanza vecchia)")
    if gc.find("AggiornaStatoSimboli();") < 0 or gc.find("AggiornaStatoSimboli();") > gc.find("while("):
        bag.append("CANCELLO GiroCelle: AggiornaStatoSimboli non chiamato prima del giro delle celle")
    if "if(n>=2)" not in norm(corpo(code, "ControllaDoppio") or ""):
        bag.append("CANCELLO ControllaDoppio: l'avviso '2 COPIE' deve scattare da 2 copie in su, non da 1")
    ag = norm(corpo(sc, "AggiornaCella") or "")
    for pz in ('if(gStatoSim[i]==1)tip=base+"fuori', 'elseif(gStatoSim[i]==2)tip=base+"simbolo inesistente',
               'elseif(!gPronta[k])tip=base+"dati non ancora', 'elseif(gDir[k]==0)tip=base+"nessuna doji',
               'tip=base+(gDir[k]>0?"doji RIALZISTA (sotto)":"doji RIBASSISTA (sopra)")'):
        if norm(pz) not in ag:
            bag.append("CANCELLO AggiornaCella: tooltip diverso da '%s'" % pz[:60])
    if "colorcs=(gStatoSim[i]==0?InpColTesto:InpColSpento);" not in norm(corpo(code, "Struttura") or ""):
        bag.append("CANCELLO Struttura: colore del simbolo non legato allo stato")
    oi = norm(corpo(code, "OnInit") or "")
    for pz, perche in (("InpBarreIndietro<1||InpBarreIndietro>500", "barre di ricerca 1-500"),
                       ("ArrayInitialize(gStatoSim,-1);", "stato iniziale 'da valutare'"),
                       ("ObjectsDeleteAll(0,PD_PREF);ObjectsDeleteAll(0,PD_DOJI);gProprietario=true;", "pulizia degli oggetti PDL_ e PDLG_d_ rimasti")):
        if pz not in oi:
            bag.append("CANCELLO OnInit: manca '%s'" % perche)
    # secondo giro cieco del cancello: 7 su 8 VERDI (colonna H4 riempita con H8, D1 con W1, suffisso ignorato...)
    so = norm(corpo(sc, "OnInit") or "")
    for nome, per in (("M15", "M15"), ("M30", "M30"), ("H1", "H1"), ("H4", "H4"), ("H8", "H8"), ("H12", "H12"),
                      ("D1", "D1"), ("W1", "W1"), ("MN", "MN1")):
        if 'AggiungiTF(Inp%s,PERIOD_%s,"%s");' % (nome, per, nome) not in so:
            bag.append("CANCELLO OnInit: la colonna %s non e' legata a Inp%s e PERIOD_%s" % (nome, nome, per))
    if so.count("AggiungiTF(") != 9:
        bag.append("CANCELLO OnInit: attese 9 colonne AggiungiTF, trovate %d" % so.count("AggiungiTF("))
    al_ = norm(corpo(code, "AggiungiLista") or "")
    for pz, perche in (("StringTrimLeft(s);StringTrimRight(s);", "spazi attorno ai simboli tolti"),
                       ("if(StringLen(s)==0)continue;", "voci vuote saltate"),
                       ("gSym[gNS]=s+InpSuffisso;", "suffisso del broker aggiunto")):
        if pz not in al_:
            bag.append("CANCELLO AggiungiLista: manca '%s'" % perche)
    val = ("if(InpLarghezzaCella<10||InpAltezzaCella<8||InpFontSize<4||InpBarreIndietro<1||InpBarreIndietro>500||"
           "InpTmaLento<1||InpTmaVeloce<1||InpAtrLento<1||InpAtrVeloce<1||InpMultLento<=0||InpMultVeloce<=0||"
           "InpCorpoMaxPct<=0||InpCellePerCiclo<1||InpRicontrolloSec<1||InpSemeHA<0||InpAlertMinuti<0)")
    if val not in oi:
        bag.append("CANCELLO OnInit: controllo dei parametri diverso da quello dichiarato")
    if "if(InpModoConfronto&&gPronta[k]&&gStatoSim[i]==0)" not in ag:
        bag.append("CANCELLO AggiornaCella: distanze del confronto mostrate anche a cella non pronta")
    rt = norm(corpo(code, "Rett") or "")
    if "ObjectSetInteger(0,nome,OBJPROP_BACK,false);" not in rt:
        bag.append("CANCELLO Rett: i rettangoli devono stare davanti al grafico (OBJPROP_BACK false)")
    if "intb=s+3;" not in norm(corpo(code, "PD_Bisogno") or ""):
        bag.append("CANCELLO PD_Bisogno: la Heikin Ashi dell'EA legge la barra shift+2: servono almeno barre+3 barre")


# ===========================================================================
# v1.10: RACCORDO dei tasti, del click, del grafico (HA, doji, EMA, Supertrend), dello stato
# ===========================================================================
PULSANTI = os.path.join(ROOT, "mql5/Indicators/ABTG_Pulsanti_Grafico.mq5")
NATCLA = os.path.join(ROOT, "mql5/Experts/EA_NatCla.mq5")
# plot -> buffer (plot 0 = 5 buffer delle candele colorate, poi uno per plot), tipo, colore impostato in OnInit
PLOT_BUF = ["bCVs", "bCVi", "bCLs", "bCLi", "bEmaV", "bEmaL", "bIncSu", "bIncGiu",
            "bSt1Su", "bSt1Giu", "bSt2Su", "bSt2Giu", "bSt3Su", "bSt3Giu"]
PLOT_TIPO = ["DRAW_COLOR_CANDLES"] + ["DRAW_LINE"] * 6 + ["DRAW_ARROW"] * 2 + ["DRAW_LINE"] * 6
PLOT_COL = {1: "InpColCanaleV", 2: "InpColCanaleV", 3: "InpColCanaleL", 4: "InpColCanaleL", 5: "InpColEmaVeloce",
            6: "InpColEmaLenta", 7: "InpColIncSu", 8: "InpColIncGiu", 9: "InpColSt1Su", 10: "InpColSt1Giu",
            11: "InpColSt2Su", 12: "InpColSt2Giu", 13: "InpColSt3Su", 14: "InpColSt3Giu"}
CALC_BUF = ["kAtr", "kUp1", "kDn1", "kDir1", "kVal1", "kUp2", "kDn2", "kDir2", "kVal2", "kUp3", "kDn3", "kDir3", "kVal3"]
TASTI = {"b_hide": "Nascondi(!gNascosta);", "b_refresh": "Refresh();", "b_ha": "ImpostaHA(!gHA);",
         "b_doji": "ImpostaDoji(!gDoji);", "b_ema": "ImpostaEma(!gEma);", "b_st": "ImpostaSt(!gSt);"}
COLORI_5 = ["CHART_COLOR_CANDLE_BULL", "CHART_COLOR_CANDLE_BEAR", "CHART_COLOR_CHART_UP", "CHART_COLOR_CHART_DOWN",
            "CHART_COLOR_CHART_LINE"]


def raccordo_v11(src, code, bag):
    sc = re.sub(r"//[^\n]*", "", src)            # senza commenti, stringhe intatte
    def C(nome):
        return norm(corpo(code, nome) or "")
    def S(nome):
        return norm(corpo(sc, nome) or "")
    def need(pz, dove, msg):
        if pz not in dove:
            bag.append("V11 " + msg)
    # --- STRUTTURA dei buffer e dei plot (un riferimento all'indice sbagliato colora/riempie il plot sbagliato)
    nb = re.search(r"#property\s+indicator_buffers\s+(\d+)", src)
    np_ = re.search(r"#property\s+indicator_plots\s+(\d+)", src)
    if not nb or nb.group(1) != "32" or not np_ or np_.group(1) != "15":
        bag.append("V11 indicator_buffers/plots diversi da 32/15")
    sib = re.findall(r"SetIndexBuffer\(\s*(\d+)\s*,\s*(\w+)\s*,\s*(\w+)\s*\)", sc)
    attesi = ["bHAo", "bHAh", "bHAl", "bHAc", "bHAcol"] + PLOT_BUF + CALC_BUF
    if [int(a) for a, _, _ in sib] != list(range(32)) or [b for _, b, _ in sib] != attesi:
        bag.append("V11 SetIndexBuffer: indici/nomi diversi dalla mappa plot->buffer (%s)" % [b for _, b, _ in sib][:8])
    tipi = [t for _, _, t in sib]
    if tipi != ["INDICATOR_DATA"] * 4 + ["INDICATOR_COLOR_INDEX"] + ["INDICATOR_DATA"] * 14 + ["INDICATOR_CALCULATIONS"] * 13:
        bag.append("V11 SetIndexBuffer: tipi (DATA/COLOR_INDEX/CALCULATIONS) fuori posto")
    for k, t in enumerate(PLOT_TIPO):
        m = re.search(r"#property\s+indicator_type%d\s+(\w+)" % (k + 1), src)
        if not m or m.group(1) != t:
            bag.append("V11 plot %d: tipo #property diverso da %s" % (k, t))
    for m in re.finditer(r"PlotIndexSet(?:Integer|String)\((\d+),", sc):
        if int(m.group(1)) >= 15:
            bag.append("V11 PlotIndexSet con indice %s >= 15 plot" % m.group(1))
    oi = S("OnInit")
    for k, col in PLOT_COL.items():
        need("PlotIndexSetInteger(%d,PLOT_LINE_COLOR,%s);" % (k, col), oi, "colore del plot %d non e' %s" % (k, col))
    need("PlotIndexSetInteger(0,PLOT_LINE_COLOR,0,InpColHASu);PlotIndexSetInteger(0,PLOT_LINE_COLOR,1,InpColHAGiu);", oi,
         "colori HA (indice 0 su, 1 giu) non dagli input")
    # --- CLICK
    oe = S("OnChartEvent")
    need("if(id!=CHARTEVENT_OBJECT_CLICK)return;", oe, "OnChartEvent non filtra il click")
    need("if(StringFind(sparam,PD_PREF)!=0)return;", oe, "OnChartEvent non si limita ai NOSTRI oggetti")
    for b, f in TASTI.items():
        need('if(sparam==PD_PREF+"%s")%s' % (b, f) if b == "b_hide" else 'elseif(sparam==PD_PREF+"%s")%s' % (b, f), oe,
             "il tasto %s non chiama %s" % (b, f))
        need('Bottone(PD_PREF+"%s",' % b, S("Struttura"), "il tasto %s non e' creato in Struttura" % b)
        need('Tasto("%s",' % b, S("DipingiTasti"), "il tasto %s non e' dipinto" % b)
    need("if(tasto){ObjectSetInteger(0,sparam,OBJPROP_STATE,false);DipingiTasti();", oe, "il tasto cliccato non torna su (OBJPROP_STATE)")
    need("ObjectSetInteger(0,nome,OBJPROP_STATE,false);", S("Tasto"), "Tasto non rimette su lo stato del bottone")
    for pz, msg in (("inttipo=PD_Bersaglio(sparam,gNS,gNT,i,j);", "il click non passa nome, nS, nT a PD_Bersaglio"),
                    ("if(tipo==0)return;", "click su oggetto non della tabella non ignorato"),
                    ("stringsym=(i>=0?gSym[i]:_Symbol);", "il simbolo del click non e' quello della RIGA cliccata"),
                    ("ENUM_TIMEFRAMEStf=(j>=0?gTF[j]:(ENUM_TIMEFRAMES)_Period);", "il TF del click non e' quello della COLONNA cliccata"),
                    ("VaiA(sym,tf);", "il click non porta a (sym, tf)")):
        need(pz, oe, msg)
    if oe.find("VaiA(") < oe.find("if(tipo==0)return;"):
        bag.append("V11 VaiA prima del controllo del bersaglio")
    for nome, att in (("NomeR", 'return(PD_PREF+"r_"+IntegerToString(i)+"_"+IntegerToString(j));'),
                      ("NomeT", 'return(PD_PREF+"t_"+IntegerToString(i)+"_"+IntegerToString(j));'),
                      ("NomeS", 'return(PD_PREF+"s_"+IntegerToString(i));')):
        need(att, S(nome), "%s: il nome non e' quello che PD_Bersaglio sa leggere" % nome)
    need('Rett(PD_PREF+"hr_"+IntegerToString(j),', S("Struttura"), "nome del rettangolo TF diverso da hr_<j>")
    need('Etic(PD_PREF+"ht_"+IntegerToString(j),', S("Struttura"), "nome dell'etichetta TF diverso da ht_<j>")
    va = S("VaiA")
    need("if(SymbolInfoInteger(sym,SYMBOL_SELECT)==0&&!SymbolSelect(sym,true))", va, "simbolo fuori Market Watch non aggiunto (SymbolSelect)")
    need("if(InpClickNuovoGrafico){if(ChartOpen(sym,tf)==0)", va, "grafico nuovo non aperto su (sym, tf) con InpClickNuovoGrafico")
    need("if(!ChartSetSymbolPeriod(0,sym,tf))", va, "ChartSetSymbolPeriod non su questo grafico con (sym, tf)")
    for f in ("ChartSetSymbolPeriod(", "ChartOpen(", "SymbolSelect("):
        if code.count(f) != 1 or f not in norm(corpo(code, "VaiA") or ""):
            bag.append("V11 %s deve esistere una volta, dentro VaiA" % f)
    # --- REFRESH: TUTTE le cache, nessuna copia nell'handler
    rf = C("Refresh")
    i0 = rf.find("for(intk=0;k<nc;k++){")
    ciclo = rf[i0:rf.find("}", i0)] if i0 >= 0 else ""
    for pz in ("gProssimo[k]=0;", "gAttesa[k]=0;", "gUltBarra[k]=0;", "gPronta[k]=false;", "AggiornaCella(k);"):
        need(pz, ciclo, "REFRESH non azzera '%s' per OGNI cella (dentro il ciclo su nc)" % pz)
    need("intnc=gNS*gNT;", rf, "REFRESH non scorre tutte le celle")
    need("gUltStato=0;", rf, "REFRESH non rilegge lo stato dei simboli")
    for f in ("Refresh", "OnChartEvent", "Nascondi", "ImpostaHA", "ImpostaDoji", "ImpostaEma", "ImpostaSt", "MarcaDoji"):
        b_ = C(f)
        if "CopyRates(" in b_ or "Elabora(" in b_ or "GiroCelle(" in b_ or "SeriesInfoInteger(" in b_:
            bag.append("V11 %s copia dati o ricalcola celle dentro l'handler (deve farlo il timer, a rate)" % f)
    if code.count("Elabora(") != 2 or "Elabora(" not in C("GiroCelle"):
        bag.append("V11 Elabora va chiamata SOLO dal giro delle celle")
    if code.count("GiroCelle(") != 2:
        bag.append("V11 GiroCelle va chiamata SOLO dal timer")
    # --- HIDE: carico zero, il tasto resta
    need("if(!gNascosta)GiroCelle(ora);", C("OnTimer"), "con la tabella NASCOSTA il timer continua a copiare/ricalcolare")
    need('if(gNascosta&&nome!=PD_PREF+"b_hide")return(OBJ_NO_PERIODS);return(OBJ_ALL_PERIODS);', S("Periodi"),
         "HIDE nasconde anche il tasto che la riapre (o non nasconde la tabella)")
    for f in ("Rett", "Etic", "Bottone"):
        need("ObjectSetInteger(0,nome,OBJPROP_TIMEFRAMES,Periodi(nome));", C(f), "%s non applica la visibilita' di HIDE" % f)
    need('gNascosta=on;GvSalva("SHIDE",on?1.0:0.0);Struttura();if(!on)Refresh();', S("Nascondi"),
         "HIDE/SHOW: stato non salvato, oggetti non riapplicati o niente ricalcolo allo SHOW")
    # --- STATO DEI TASTI (GlobalVariable con la ChartID)
    need("return(PD_GV+IntegerToString(ChartID())+\"_\"+cosa);", S("GvChiave"), "chiave della GlobalVariable senza ChartID")
    need("boolon=PG_StatoIniziale(has,gvOn,gvIn,inp);", C("StatoAvvio"), "StatoAvvio non usa PG_StatoIniziale")
    need('GvSalva("S"+cosa,on?1.0:0.0);GvSalva("I"+cosa,inp?1.0:0.0);', S("StatoAvvio"), "StatoAvvio non salva stato e input")
    for nome, inp in (("HIDE", "InpNascostaDefault"), ("HA", "InpHaDefault"), ("DOJI", "InpDojiDefault"), ("EMA", "InpEmaDefault"),
                      ("ST", "InpStDefault")):
        need('=StatoAvvio("%s",%s);' % (nome, inp), oi, "stato iniziale %s non da %s" % (nome, inp))
    salvati = set(re.findall(r'GvSalva\("S(\w+)"', sc))
    if salvati != {"HIDE", "HA", "DOJI", "EMA", "ST"}:
        bag.append("V11 i tasti salvano chiavi diverse da quelle lette all'avvio: %s" % sorted(salvati))
    need('stringt[5]={"HIDE","HA","DOJI","EMA","ST"};', S("GvPulisci"), "GvPulisci non dimentica tutti e 5 i tasti")
    od = C("OnDeinit")
    need("if(reason==REASON_REMOVE||reason==REASON_CHARTCLOSE)GvPulisci();", od,
         "lo stato si cancella al cambio simbolo/TF (deve restare) o non si cancella togliendo l'indicatore")
    # --- HA: colori salvati PRIMA di metterli a clrNONE, ripristinati a OGNI uscita
    ch = C("ColsHide")
    cattura = ch.find("gColBull=ColOrDefault(ChartGetInteger(0,CHART_COLOR_CANDLE_BULL),clrLime);")
    if cattura < 0 or ch.find("gColsHidden=true;") < cattura or ch.find("clrNONE") < ch.find("gColsHidden=true;"):
        bag.append("V11 ColsHide: i colori non si catturano PRIMA di metterli a clrNONE")
    for pr in COLORI_5:
        if ch.count(pr) != 2 or "ChartSetInteger(0,%s,clrNONE)" % pr not in ch or pr not in C("ColsRestore"):
            bag.append("V11 colore %s non catturato/nascosto/ripristinato" % pr)
    need("ColsRestore();", od[:od.find("if(gProprietario)")] if "if(gProprietario)" in od else "", "OnDeinit non ripristina i colori per primo")
    need("if(gHA)ColsHide();elseRepairInvisibleNative();", oi, "OnInit: HA acceso non nasconde / spento non ripara")
    need("if(on){gCure=0;ColsHide();}elseColsRestore();ApplicaPlot();", C("ImpostaHA"), "tasto HA: non nasconde/ripristina")
    need("if(!gHA||gCure>=3)return;", C("CuraColori"), "CuraColori fuori dall'HA acceso o senza limite")
    need("gColsHidden=false;ColsHide();", C("CuraColori"), "CuraColori non ricattura i colori ATTUALI")
    need("CuraColori();", C("OnTimer"), "il timer non cura i colori (ricarico: l'istanza vecchia li ripristina DOPO)")
    ap = C("ApplicaPlot")
    for pz in ("PlotIndexSetInteger(0,PLOT_DRAW_TYPE,gHA?DRAW_COLOR_CANDLES:DRAW_NONE);",
               "for(intp=1;p<=4;p++){PlotIndexSetInteger(p,PLOT_DRAW_TYPE,InpDisegnaCanali?DRAW_LINE:DRAW_NONE);",
               "for(intp=5;p<=6;p++){PlotIndexSetInteger(p,PLOT_DRAW_TYPE,gEma?DRAW_LINE:DRAW_NONE);",
               "for(intp=7;p<=8;p++){PlotIndexSetInteger(p,PLOT_DRAW_TYPE,gEma?DRAW_ARROW:DRAW_NONE);",
               "PlotIndexSetInteger(7,PLOT_ARROW,233);PlotIndexSetInteger(8,PLOT_ARROW,234);",
               "for(intp=9;p<=14;p++){PlotIndexSetInteger(p,PLOT_DRAW_TYPE,gSt?DRAW_LINE:DRAW_NONE);"):
        need(pz, ap, "ApplicaPlot: manca '%s'" % pz[:60])
    for f, v in (("ImpostaEma", 'gEma=on;GvSalva("SEMA",on?1.0:0.0);ApplicaPlot();'),
                 ("ImpostaSt", 'gSt=on;GvSalva("SST",on?1.0:0.0);ApplicaPlot();')):
        need(v, S(f), "%s non salva lo stato o non ridisegna" % f)
    # --- GRAFICO CORRENTE (OnCalculate)
    oc = C("OnCalculate")
    for pz, msg in (("boolpieno=(prev_calculated<=0||prev_calculated>rates_total);intda=(pieno?0:prev_calculated-1);",
                     "ricalcolo incrementale non dalla barra prev_calculated-1 (la barra in formazione si rifa')"),
                    ("PG_HA(open,high,low,close,rates_total,da,bHAo,bHAh,bHAl,bHAc);", "HA non dalle barre del grafico"),
                    ("for(intx=da;x<rates_total;x++)bHAcol[x]=(bHAc[x]>=bHAo[x])?0.0:1.0;", "colore HA non come ABTG_Pulsanti"),
                    ("PG_EMA(close,rates_total,da,InpEmaVeloce,bEmaV);PG_EMA(close,rates_total,da,InpEmaLenta,bEmaL);",
                     "EMA veloce/lenta: periodi o buffer scambiati"),
                    ("SW_STCore(high,low,close,rates_total,da,InpStPeriodo,InpStMult1,kAtr,kUp1,kDn1,kDir1,kVal1);", "ST livello 1"),
                    ("SW_STCore(high,low,close,rates_total,da,InpStPeriodo,InpStMult2,kAtr,kUp2,kDn2,kDir2,kVal2);", "ST livello 2"),
                    ("SW_STCore(high,low,close,rates_total,da,InpStPeriodo,InpStMult3,kAtr,kUp3,kDn3,kDir3,kVal3);", "ST livello 3"),
                    ("bSt1Su[x]=PG_StLinea(true,kDir1[x],kVal1[x],1.0);bSt1Giu[x]=PG_StLinea(true,kDir1[x],kVal1[x],-1.0);", "linee ST 1"),
                    ("bSt2Su[x]=PG_StLinea(true,kDir2[x],kVal2[x],1.0);bSt2Giu[x]=PG_StLinea(true,kDir2[x],kVal2[x],-1.0);", "linee ST 2"),
                    ("bSt3Su[x]=PG_StLinea(true,kDir3[x],kVal3[x],1.0);bSt3Giu[x]=PG_StLinea(true,kDir3[x],kVal3[x],-1.0);", "linee ST 3"),
                    ("intprimo=(InpEmaVeloce>InpEmaLenta?InpEmaVeloce:InpEmaLenta);", "riscaldamento dell'incrocio = periodo maggiore"),
                    ("for(intx=(da<1?1:da);x<rates_total-1;x++){intr=PD_Incrocio(bEmaV,bEmaL,x,primo);",
                     "incrocio valutato anche sulla barra IN FORMAZIONE o con le EMA scambiate"),
                    ("bIncSu[x]=(r>0?bHAl[x]:EMPTY_VALUE);bIncGiu[x]=(r<0?bHAh[x]:EMPTY_VALUE);", "frecce incrocio: verso o posizione"),
                    ("bIncSu[rates_total-1]=EMPTY_VALUE;bIncGiu[rates_total-1]=EMPTY_VALUE;", "freccia sulla barra in formazione non pulita"),
                    ("if(time[rates_total-1]!=gUltBarraGraf){gUltBarraGraf=time[rates_total-1];Istantanea(rates_total,time,open,high,low,close);if(gDoji)MarcaDoji();if(InpDisegnaCanali)Canali();",
                     "doji/canali non SOLO a barra nuova, o doji calcolate a tasto spento")):
        need(pz, oc, msg)
    for b in ("bCVs", "bCVi", "bCLs", "bCLi", "bIncSu", "bIncGiu"):
        need("ArrayInitialize(%s,EMPTY_VALUE);" % b, oc, "%s non pulito al ricalcolo completo" % b)
        need("%s[x]=EMPTY_VALUE;" % b, oc, "%s non pulito sulle barre nuove" % b)
    ist = C("Istantanea")
    for pz in ("intn=(rt<gBisognoGraf?rt:gBisognoGraf);", "inty=rt-1-x;",
               "gXo[x]=open[y];gXh[x]=high[y];gXl[x]=low[y];gXc[x]=close[y];", "gXt[x]=time[y];gXhh[x]=bHAh[y];gXhl[x]=bHAl[y];",
               "gXn=n;gXrt=rt;"):
        need(pz, ist, "Istantanea (ordine SERIE dalle barre del grafico): manca '%s'" % pz)
    need("gBisognoGraf=PD_Bisogno(gPar,(InpDisegnaCanali&&InpBarreCanali>InpBarreIndietro)?InpBarreCanali:InpBarreIndietro);", oi,
         "barre dell'istantanea non sufficienti per doji e canali")
    md = C("MarcaDoji")
    for pz, msg in (("ObjectsDeleteAll(0,PD_DOJI);", "frecce vecchie non cancellate prima di ridisegnare"),
                    ("intnm=PD_Marca(gXo,gXh,gXl,gXc,gXn,InpBarreIndietro,gPar,gMs,gMd,gMf,gMl);", "frecce non con la regola delle celle"),
                    ("boolsu=(gMd[q]>0);", "verso della freccia"),
                    ("doublepr=(su?gXhl[s]:gXhh[s]);", "freccia rialzista non sotto / ribassista non sopra la candela"),
                    ("ObjectCreate(0,nome,OBJ_ARROW,0,gXt[s],pr)", "freccia non sulla candela della doji"),
                    ("ObjectSetInteger(0,nome,OBJPROP_COLOR,su?InpColRialzo:InpColRibasso);", "colore della freccia non per direzione")):
        need(pz, md, "MarcaDoji: " + msg)
    need("gMf[q],gMl[q]", md, "tooltip della freccia senza la distanza in ATR")
    need('if(on)MarcaDoji();else{ObjectsDeleteAll(0,PD_DOJI);gMarcNome="";gRidisegna=true;}', S("ImpostaDoji"),
         "tasto DOJI: OFF non toglie le frecce o ON non le disegna")
    need('gDoji=on;GvSalva("SDOJI",on?1.0:0.0);', S("ImpostaDoji"), "tasto DOJI: stato non salvato")
    # ogni chiamata di MarcaDoji e' sotto DOJI acceso (OFF = nessun calcolo)
    for m in re.finditer(r"MarcaDoji\(\)", code):
        riga = code[code.rfind("\n", 0, m.start()) + 1:code.find("\n", m.end())]
        if "void MarcaDoji" in riga:
            continue
        if "gDoji" not in riga and "if(on)" not in norm(riga):
            bag.append("V11 MarcaDoji chiamata senza DOJI acceso: '%s'" % riga.strip()[:70])
    if code.count("MarcaDoji()") != 5:
        bag.append("V11 MarcaDoji: attese 4 chiamate + definizione, trovate %d" % code.count("MarcaDoji()"))
    need("if(gDoji&&gMarcNome!=\"\"&&ObjectFind(0,gMarcNome)<0)MarcaDoji();", S("OnTimer"), "frecce cancellate dall'istanza vecchia non rifatte")
    ca = C("Canali")
    need("if(PD_Banda(gXh,gXl,gXc,gXn,s,gPar.tmaModo,gPar.tmaF,gPar.atrF,gPar.multF,mid,up,lo,a)){bCVs[x]=up;bCVi[x]=lo;}", ca, "canale veloce")
    need("if(PD_Banda(gXh,gXl,gXc,gXn,s,gPar.tmaModo,gPar.tmaS,gPar.atrS,gPar.multS,mid,up,lo,a)){bCLs[x]=up;bCLi[x]=lo;}", ca, "canale lento")
    need("intx=rt-1-s;", ca, "canali: indice cronologico della barra s")
    # prefissi: le frecce NON stanno sotto PD_PREF (HIDE non le tocca), il click legge solo PD_PREF
    m1 = re.search(r'#define\s+PD_PREF\s+"([^"]+)"', src)
    m2 = re.search(r'#define\s+PD_DOJI\s+"([^"]+)"', src)
    if not m1 or not m2 or m2.group(1).startswith(m1.group(1)) or m1.group(1) != "PDL_":
        bag.append("V11 prefissi: PD_DOJI non deve iniziare con PD_PREF (e PD_PREF = PDL_)")
    # funzioni COPIATE identiche da ABTG_Pulsanti_Grafico.mq5 (e SW_STCore = NC_STCore di EA_NatCla)
    pu = maschera(leggi(PULSANTI).decode("latin-1"))
    nc = maschera(leggi(NATCLA).decode("latin-1"))
    for f in ("SW_STCore", "PG_EMA", "PG_HA", "PG_StLinea", "PG_StatoIniziale"):
        a_, b_ = norm(corpo(code, f) or "x"), norm(corpo(pu, f) or "y")
        if a_ != b_:
            bag.append("V11 %s NON identica a quella di ABTG_Pulsanti_Grafico.mq5" % f)
    if norm(corpo(code, "SW_STCore") or "x") != norm(corpo(nc, "NC_STCore") or "y").replace("NC_STCore", "SW_STCore"):
        bag.append("V11 SW_STCore NON identica a NC_STCore di EA_NatCla.mq5")
    for f in ("ColsHide", "ColsRestore", "ColOrDefault", "IsNone"):
        a_ = re.sub(r'Print\([^;]*\);', "", norm(corpo(code, f) or "x"))
        b_ = re.sub(r'Print\([^;]*\);', "", norm(corpo(pu, f) or "y"))
        if a_ != b_:
            bag.append("V11 %s NON identica (a meno dei messaggi) a quella di ABTG_Pulsanti_Grafico.mq5" % f)


# ===========================================================================
# P) BLOCCO PURO in C++
# ===========================================================================
SHIM = r'''
#include <cmath>
#include <cstdio>
#include <cstdlib>
#include <string>
#include <vector>
typedef long long datetime;
typedef std::string string;
inline double MathMax(double a,double b){ return a>b?a:b; }
inline double MathMin(double a,double b){ return a<b?a:b; }
inline double MathAbs(double a){ return std::fabs(a); }
inline string IntegerToString(long long v){ return std::to_string(v); }
inline string StringSubstr(const string &s,int start,int len=-1){ if(start<0||start>=(int)s.size()) return ""; return len<0? s.substr(start): s.substr(start,len); }
inline int StringLen(const string &s){ return (int)s.size(); }
inline int StringFind(const string &s,const string &f,int start=0){ size_t p=s.find(f,(size_t)start); return p==std::string::npos? -1 : (int)p; }
inline int StringGetCharacter(const string &s,int i){ return (i>=0 && i<(int)s.size())? (unsigned char)s[i] : 0; }
#include <cfloat>
#define EMPTY_VALUE DBL_MAX
'''

DRIVER = r'''
#include "shim.h"
#include "pure.mqh"
static void pa(double v){ printf("%a ",v); }
static bool rpar(PD_Par &p){
  int sf,uc,fl;
  if(scanf("%d %d %d %d %lf %d %d %lf %lf %d %d %d %lf %lf %d %d",&p.candela,&p.tmaModo,&p.tmaS,&p.atrS,&p.multS,
           &p.tmaF,&p.atrF,&p.multF,&p.corpoMaxPct,&sf,&p.canale,&uc,&p.rapInf,&p.rapSup,&fl,&p.semeHA)!=16) return false;
  p.soloFuori=(sf!=0); p.usaCode=(uc!=0); p.flip=(fl!=0); return true;
}
static bool rv(std::vector<double> &v,int n){ v.resize(n); for(int i=0;i<n;i++) if(scanf("%lf",&v[i])!=1) return false; return true; }
int main(){
  char cmd[32];
  while(scanf("%31s",cmd)==1){
    std::string c(cmd);
    if(c=="DOJI"){
      double o,h,l,cl,p; if(scanf("%lf %lf %lf %lf %lf",&o,&h,&l,&cl,&p)!=5) return 2; printf("%d\n",PD_IsDoji(o,h,l,cl,p)?1:0);
    } else if(c=="TESTO"){
      long long t; int s; if(scanf("%lld %d",&t,&s)!=2) return 2; printf("%s\n",PD_Testo(t,s).c_str());
    } else if(c=="ATR"){
      int n,per,sh;
      if(scanf("%d %d %d",&n,&per,&sh)!=3) return 2;
      std::vector<double> h,l,cl;
      if(!rv(h,n)||!rv(l,n)||!rv(cl,n)) return 2;
      double a=-1;
      bool ok=PD_Atr(h.data(),l.data(),cl.data(),n,per,sh,a);
      printf("%d %a\n",ok?1:0,a);
    } else if(c=="TMAEA" || c=="TMAC"){
      int n,per,sh; if(scanf("%d %d %d",&n,&per,&sh)!=3) return 2; std::vector<double> cl; if(!rv(cl,n)) return 2;
      double m=-1; bool ok=(c=="TMAEA")? PD_TmaEA(cl.data(),n,per,sh,m) : PD_TmaCentrata(cl.data(),n,per,sh,m);
      printf("%d %a\n",ok?1:0,m);
    } else if(c=="CAND"){
      int n,sh,mo;
      if(scanf("%d %d %d",&n,&sh,&mo)!=3) return 2;
      std::vector<double> o,h,l,cl;
      if(!rv(o,n)||!rv(h,n)||!rv(l,n)||!rv(cl,n)) return 2;
      double O=0,H=0,L=0,C=0;
      bool ok=PD_Candela(o.data(),h.data(),l.data(),cl.data(),n,sh,mo,O,H,L,C);
      printf("%d %a %a %a %a\n",ok?1:0,O,H,L,C);
    } else if(c=="BIS"){
      PD_Par p; if(!rpar(p)) return 2; int L; if(scanf("%d",&L)!=1) return 2; printf("%d\n",PD_Bisogno(p,L));
    } else if(c=="VAL"){
      PD_Par p; if(!rpar(p)) return 2; int n,sh; if(scanf("%d %d",&n,&sh)!=2) return 2;
      std::vector<double> o,h,l,cl; if(!rv(o,n)||!rv(h,n)||!rv(l,n)||!rv(cl,n)) return 2;
      double a=0,b=0; int r=PD_Valuta(o.data(),h.data(),l.data(),cl.data(),n,sh,p,a,b); printf("%d %a %a\n",r,a,b);
    } else if(c=="SCAN"){
      /* serie cronologica intera; per ogni punto e: finestra in ordine serie di 'win' barre (0 = auto: PD_Bisogno) */
      PD_Par p; if(!rpar(p)) return 2; int N,L,start,step,win;
      if(scanf("%d %d %d %d %d",&N,&L,&start,&step,&win)!=5) return 2;
      std::vector<double> o,h,l,cl; if(!rv(o,N)||!rv(h,N)||!rv(l,N)||!rv(cl,N)) return 2;
      int w= win>0 ? win : PD_Bisogno(p,L);
      printf("W %d\n",w);
      std::vector<double> wo(w),wh(w),wl(w),wc(w);
      for(int e=start;e<N;e+=step){
        if(e-w+1<0) continue;
        for(int i=0;i<w;i++){ wo[i]=o[e-i]; wh[i]=h[e-i]; wl[i]=l[e-i]; wc[i]=cl[e-i]; }
        int sh=0; double a=0,b=0,a1=0,b1=0;
        int r=PD_Ultimo(wo.data(),wh.data(),wl.data(),wc.data(),w,L,p,sh,a,b,a1,b1);
        printf("%d %d %d ",e,r,sh); pa(a); pa(b); pa(a1); pa(b1); printf("\n");
      }
      printf("FINE\n");
    } else if(c=="BERS"){
      char nm[256]; int nS,nT; if(scanf("%255s %d %d",nm,&nS,&nT)!=3) return 2;
      int i=-7,j=-7; int t=PD_Bersaglio(std::string(nm),nS,nT,i,j); printf("%d %d %d\n",t,i,j);
    } else if(c=="SCANM"){
      /* come SCAN, ma PD_Marca (tutte le doji) accanto a PD_Ultimo (la piu' recente) sulla stessa finestra */
      PD_Par p; if(!rpar(p)) return 2; int N,L,start,step,win;
      if(scanf("%d %d %d %d %d",&N,&L,&start,&step,&win)!=5) return 2;
      std::vector<double> o,h,l,cl; if(!rv(o,N)||!rv(h,N)||!rv(l,N)||!rv(cl,N)) return 2;
      int w= win>0 ? win : PD_Bisogno(p,L);
      std::vector<double> wo(w),wh(w),wl(w),wc(w),mf(L+1),ml(L+1); std::vector<int> ms(L+1),md(L+1);
      for(int e=start;e<N;e+=step){
        if(e-w+1<0) continue;
        for(int i=0;i<w;i++){ wo[i]=o[e-i]; wh[i]=h[e-i]; wl[i]=l[e-i]; wc[i]=cl[e-i]; }
        int sh=0; double a=0,b=0,a1=0,b1=0;
        int r=PD_Ultimo(wo.data(),wh.data(),wl.data(),wc.data(),w,L,p,sh,a,b,a1,b1);
        int q=PD_Marca(wo.data(),wh.data(),wl.data(),wc.data(),w,L,p,ms.data(),md.data(),mf.data(),ml.data());
        printf("%d %d %d %d",e,r,sh,q);
        for(int k=0;k<q;k++){ printf(" %d %d ",ms[k],md[k]); pa(mf[k]); pa(ml[k]); }
        printf("\n");
      }
      printf("FINE\n");
    } else if(c=="INC"){
      int n,x,primo; if(scanf("%d %d %d",&n,&x,&primo)!=3) return 2;
      std::vector<double> f,s; if(!rv(f,n)||!rv(s,n)) return 2; printf("%d\n",PD_Incrocio(f.data(),s.data(),x,primo));
    } else if(c=="INCALL"){
      int n,primo; if(scanf("%d %d",&n,&primo)!=2) return 2;
      std::vector<double> f,s; if(!rv(f,n)||!rv(s,n)) return 2;
      for(int x=0;x<n;x++) printf("%d ",PD_Incrocio(f.data(),s.data(),x,primo));
      printf("\n");
    } else if(c=="EMA"){
      int n,per; if(scanf("%d %d",&n,&per)!=2) return 2; std::vector<double> cl,e(n); if(!rv(cl,n)) return 2;
      PG_EMA(cl.data(),n,0,per,e.data()); for(int i=0;i<n;i++) pa(e[i]); printf("\n");
    } else if(c=="ST"){
      int n,per; double mult; if(scanf("%d %d %lf",&n,&per,&mult)!=3) return 2;
      std::vector<double> h,l,cl; if(!rv(h,n)||!rv(l,n)||!rv(cl,n)) return 2;
      std::vector<double> at(n),up(n),dn(n),di(n),va(n);
      /* intera serie dalla barra 0 (il seme e' la barra 'per'): la finestra la sceglie il chiamante */
      SW_STCore(h.data(),l.data(),cl.data(),n,0,per,mult,at.data(),up.data(),dn.data(),di.data(),va.data());
      for(int i=0;i<n;i++){ printf("%d ",(int)di[i]); pa(va[i]); }
      printf("\n");
    } else if(c=="HAINC"){
      /* OnCalculate simulato: per ogni rt la barra rt-1 prima PROVVISORIA (chiusura a meta'), poi definitiva;
         da = prev_calculated-1 (mode 1, come il sorgente) oppure prev_calculated (mode 0, contro-esempio) */
      int n,mode; if(scanf("%d %d",&n,&mode)!=2) return 2;
      std::vector<double> o,h,l,cl; if(!rv(o,n)||!rv(h,n)||!rv(l,n)||!rv(cl,n)) return 2;
      std::vector<double> ho(n),hh(n),hl(n),hc(n),po(n),ph(n),pl(n),pc(n);
      int prev=0;
      for(int rt=1;rt<=n;rt++){
        for(int i=0;i<rt;i++){ po[i]=o[i]; ph[i]=h[i]; pl[i]=l[i]; pc[i]=cl[i]; }
        pc[rt-1]=(o[rt-1]+cl[rt-1])/2.0; ph[rt-1]=MathMax(o[rt-1],pc[rt-1]); pl[rt-1]=MathMin(o[rt-1],pc[rt-1]);
        for(int pass=0;pass<2;pass++){
          if(pass==1){ pc[rt-1]=cl[rt-1]; ph[rt-1]=h[rt-1]; pl[rt-1]=l[rt-1]; }
          int da=(prev<=0 ? 0 : (mode==1 ? prev-1 : prev));
          PG_HA(po.data(),ph.data(),pl.data(),pc.data(),rt,da,ho.data(),hh.data(),hl.data(),hc.data());
          prev=rt;
        }
      }
      for(int i=0;i<n;i++){ pa(ho[i]); pa(hc[i]); pa(hh[i]); pa(hl[i]); }
      printf("\n");
    } else if(c=="STATO"){
      int a,b,d,e; if(scanf("%d %d %d %d",&a,&b,&d,&e)!=4) return 2; printf("%d\n",PG_StatoIniziale(a!=0,b!=0,d!=0,e!=0)?1:0);
    } else if(c=="LINEA"){
      int on; double di,va,ve; if(scanf("%d %lf %lf %lf",&on,&di,&va,&ve)!=4) return 2; pa(PG_StLinea(on!=0,di,va,ve)); printf("\n");
    } else return 3;
    fflush(stdout);
  }
  return 0;
}
'''


def blocco_puro(src):
    return src[src.index("//@@PD_PURE_BEGIN"):src.index("//@@PD_PURE_END")]


def to_cxx(block):
    """unici adattamenti MQL5 -> C++ (convenzione di collaudo_pulsanti_grafico.py): array per riferimento ->
    puntatore; long -> long long."""
    out = re.sub(r"(const\s+)?(double|int|datetime|long)\s*&\s*(\w+)\[\]",
                 lambda m: (m.group(1) or "") + m.group(2) + " *" + m.group(3), block)
    return re.sub(r"\blong\b", "long long", out)


class Cxx:
    def __init__(self, src, tmp):
        self.ok, self.err = False, ""
        cxx = shutil.which("g++") or shutil.which("clang++")
        if not cxx:
            self.err = "g++ assente"
            return
        os.makedirs(tmp, exist_ok=True)
        for nm, txt in (("shim.h", SHIM), ("pure.mqh", to_cxx(blocco_puro(src))), ("drv.cpp", DRIVER)):
            with open(os.path.join(tmp, nm), "w") as f:
                f.write(txt)
        self.exe = os.path.join(tmp, "drv")
        r = subprocess.run([cxx, "-std=c++17", "-O2", "-ffp-contract=off", "-Wall", "-Wshadow", "-o", self.exe,
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


def spar(p):
    """PD_Par -> riga per il driver"""
    return "%d %d %d %d %r %d %d %r %r %d %d %d %r %r %d %d" % (
        p["candela"], p["tma"], p["tmaS"], p["atrS"], p["multS"], p["tmaF"], p["atrF"], p["multF"], p["corpo"],
        1 if p["solo"] else 0, p["canale"], 1 if p["code"] else 0, p["rapInf"], p["rapSup"], 1 if p["flip"] else 0, p["seme"])


BASE = dict(candela=1, tma=0, tmaS=56, atrS=100, multS=2.0, tmaF=14, atrF=30, multF=2.0, corpo=10.0, solo=True,
            canale=2, code=False, rapInf=2.0, rapSup=2.0, flip=False, seme=50)


def cfg(**kw):
    d = dict(BASE)
    d.update(kw)
    return d


CONFIG = [
    ("C1 default (HA come l'EA, TMA EA, uno dei due)", cfg()),
    ("C2 giapponesi, veloce, flip, code", cfg(candela=0, canale=1, flip=True, code=True)),
    ("C3 HA ricorsiva, lento", cfg(candela=2, canale=0)),
    ("C4 senza filtro canale", cfg(solo=False)),
    ("C5 TMA centrata (ipotesi originale)", cfg(tma=1)),
    ("C6 entrambi i canali, giapponesi", cfg(candela=0, canale=3)),
]


def unitari(cx, bag):
    """valori attesi scritti A MANO, non ricalcolati con la stessa formula"""
    def one(cmd):
        return cx.run(cmd + "\n")[0].split()
    for cmd, att in (("DOJI 100 105 100 100.5 10", 1), ("DOJI 100 105 100 100.51 10", 0), ("DOJI 100.5 105 100 100 10", 1),
                     ("DOJI 100 100 100 100 10", 0), ("DOJI 100 101 99 100 10", 1), ("DOJI 100 101.25 98.75 100.25 10", 1),
                     ("DOJI 100 101.25 98.75 100.26 10", 0)):
        check(int(one(cmd)[0]) == att, "%s -> %d" % (cmd, att), quiet=True, bag=bag)
    # ATR: serie [0]=(10,9,9.5) [1]=(12,10,11) [2]=(11,8,10) [3]=(9,7,8); shift 1, periodo 2: TR1=12-10=2, TR2=11-8=3 -> 2,5
    o = one("ATR 4 2 1  10 12 11 9  9 10 8 7  9.5 11 10 8")
    check(o[0] == "1" and fx(o[1]) == 2.5, "ATR a mano 2,5 (%s)" % o, quiet=True, bag=bag)
    o = one("ATR 3 2 1  10 12 11  9 10 8  9.5 11 10")
    check(o[0] == "0", "ATR: manca la chiusura prima dell'ultima barra -> rifiuto (%s)" % o, quiet=True, bag=bag)
    o = one("ATR 4 2 0  10 12 11 9  9 10 8 7  9.5 11 10 8")
    check(o[0] == "1" and fx(o[1]) == 2.0, "ATR shift 0 a mano: TR0=max(10,11)-min(9,11)=2, TR1=max(12,10)-min(10,10)=2 -> 2 (%s)" % o,
          quiet=True, bag=bag)
    # TMA dell'EA: periodo 3 -> m=2; serie c[i]=i+1; shift 0: (c0+2c1+c2)/4 = (1+4+3)/4 = 2; servono 3+2+0+5=10 barre
    o = one("TMAEA 10 3 0  1 2 3 4 5 6 7 8 9 10")
    check(o[0] == "1" and fx(o[1]) == 2.0, "TMA EA a mano = 2 (%s)" % o, quiet=True, bag=bag)
    o = one("TMAEA 9 3 0  1 2 3 4 5 6 7 8 9")
    check(o[0] == "0", "TMA EA: 9 barre < need 10 -> rifiuto (come l'EA)", quiet=True, bag=bag)
    o = one("TMAEA 12 3 2  1 2 3 4 5 6 7 8 9 10 11 12")
    check(o[0] == "1" and fx(o[1]) == 4.0, "TMA EA shift 2: (c2+2c3+c4)/4 = (3+8+5)/4 = 4 (%s)" % o, quiet=True, bag=bag)
    # TMA centrata: meta' 2; shift 1 -> solo passato: (3c1+2c2+c3)/6 = (6+6+4)/6 = 16/6
    o = one("TMAC 6 2 1  1 2 3 4 5 6")
    check(o[0] == "1" and abs(fx(o[1]) - 16.0 / 6.0) < 1e-15, "TMA centrata shift 1 a mano = 16/6 (%s)" % o, quiet=True, bag=bag)
    # shift 3: 3c3 + 2c4 + c5 + 2c2 + c1 (c0 = barra in formazione ESCLUSA) = 12+10+6+6+2 = 36 / 9 = 4
    o = one("TMAC 6 2 3  100 2 3 4 5 6")
    check(o[0] == "1" and fx(o[1]) == 4.0, "TMA centrata shift 3 = 4, la barra in formazione (100) NON entra (%s)" % o, quiet=True, bag=bag)
    o = one("TMAC 5 2 3  1 2 3 4 5")
    check(o[0] == "0", "TMA centrata: storico corto -> rifiuto", quiet=True, bag=bag)
    # barre minime coi default: ATR lento 100 + 30 + 1 = 131
    check(int(one("BIS " + spar(BASE) + " 30")[0]) == 131, "barre minime coi default = 131 (ATR 100 + 30 + 1)", quiet=True, bag=bag)
    check(int(one("BIS " + spar(cfg(atrS=10, atrF=10)) + " 30")[0]) == 119,
          "barre minime con ATR 10: decide la TMA lenta 56+28+30+5 = 119", quiet=True, bag=bag)
    check(int(one("BIS " + spar(cfg(atrS=10, atrF=10, tma=1)) + " 30")[0]) == 87,
          "barre minime TMA centrata, ATR 10: 30+56+1 = 87", quiet=True, bag=bag)
    check(int(one("BIS " + spar(cfg(atrS=10, atrF=10, tmaS=5, tmaF=5, candela=2, seme=80)) + " 30")[0]) == 111,
          "barre minime HA ricorsiva seme 80: 30+1+80 = 111", quiet=True, bag=bag)
    # VALUTA a mano: TMA 3 (m=2), ATR 2, molt 1, candele giapponesi, 12 barre piatte (o=c=100, h=101, l=99),
    # doji sulla barra 1. Corpo 105,2: TMA=(105,2+300)/4=101,3; TR1=105,7-100=5,7, TR2=2 -> ATR 3,85; su=105,15 -> SOPRA
    def barre(o1, h1, l1, c1):
        n = 12
        o_ = [100.0] * n; h_ = [101.0] * n; l_ = [99.0] * n; c_ = [100.0] * n
        o_[1], h_[1], l_[1], c_[1] = o1, h1, l1, c1
        return " ".join(" ".join(repr(x) for x in a) for a in (o_, h_, l_, c_))
    pv = cfg(candela=0, tmaS=3, atrS=2, multS=1.0, tmaF=3, atrF=2, multF=1.0)
    o = one("VAL " + spar(pv) + " 12 1 " + barre(105.2, 105.7, 104.7, 105.2))
    check(int(o[0]) == -1 and abs(fx(o[1]) - (105.2 - 105.15) / 3.85) < 1e-12,
          "VALUTA a mano: doji col corpo 0,05 SOPRA il canale -> ribassista, dist 0,05/3,85 ATR (%s)" % o, quiet=True, bag=bag)
    # corpo 105,0: TMA=101,25, ATR=(5,5+2)/2=3,75, su=105,0: corpo == bordo -> NON fuori (uscita stretta)
    o = one("VAL " + spar(pv) + " 12 1 " + barre(105.0, 105.5, 104.5, 105.0))
    check(int(o[0]) == 0 and abs(fx(o[1])) < 1e-12, "VALUTA a mano: corpo SUL bordo -> niente (uscita stretta) (%s)" % o, quiet=True, bag=bag)
    # specchio rialzista: corpo 94,8: TMA=(94,8+300)/4=98,7; TR1=100-94,3=5,7 -> ATR 3,85; giu'=94,85 -> SOTTO
    o = one("VAL " + spar(pv) + " 12 1 " + barre(94.8, 95.3, 94.3, 94.8))
    check(int(o[0]) == 1, "VALUTA a mano: doji SOTTO il canale -> rialzista (%s)" % o, quiet=True, bag=bag)
    # stessa barra non-doji (corpo 1 su range 1,4) -> niente
    o = one("VAL " + spar(pv) + " 12 1 " + barre(94.3, 95.3, 94.2, 95.3))
    check(int(o[0]) == 0, "VALUTA a mano: fuori canale ma NON doji -> niente (%s)" % o, quiet=True, bag=bag)
    # code: rialzista con coda inferiore 0,5 e superiore 0,5 -> rapporto 1 < 2 -> scartata; con coda sup 0,1 -> 5 >= 2 -> ok
    pc = dict(pv, code=True)
    o = one("VAL " + spar(pc) + " 12 1 " + barre(94.8, 95.3, 94.3, 94.8))
    check(int(o[0]) == 0, "CODE: Dragonfly richiesta, code uguali -> scartata (%s)" % o, quiet=True, bag=bag)
    o = one("VAL " + spar(pc) + " 12 1 " + barre(94.8, 94.9, 94.3, 94.8))
    check(int(o[0]) == 1, "CODE: coda inferiore 0,5 contro superiore 0,1 -> Dragonfly ok (%s)" % o, quiet=True, bag=bag)
    # flip: sulla barra 1 la conferma non e' ancora chiusa -> 0
    o = one("VAL " + spar(dict(pv, flip=True)) + " 12 1 " + barre(94.8, 95.3, 94.3, 94.8))
    check(int(o[0]) == 0, "FLIP: doji sulla barra 1 non ancora confermata -> niente (%s)" % o, quiet=True, bag=bag)
    # testo delle celle su date note (attesi scritti a mano)
    casi = [((2026, 10, 7, 12, 0), 3600, "12:00"), ((2026, 10, 7, 6, 0), 14400, "06:00"), ((2026, 10, 4, 0, 0), 86400, "Sun"),
            ((2026, 10, 5, 0, 0), 86400, "Mon"), ((2026, 10, 1, 0, 0), 86400, "Thu"), ((2026, 10, 2, 0, 0), 86400, "Fri"),
            ((1970, 1, 1, 0, 0), 86400, "Thu"), ((2026, 10, 4, 0, 0), 604800, "04/10"), ((2000, 2, 29, 0, 0), 604800, "29/02"),
            ((2026, 10, 1, 0, 0), 2592000, "Oct"), ((2024, 1, 1, 0, 0), 2592000, "Jan"), ((2026, 10, 7, 9, 45), 900, "09:45"),
            ((2026, 12, 31, 23, 30), 1800, "23:30")]
    for (y, mo, d, hh, mi), tf, att in casi:
        t = calendar.timegm((y, mo, d, hh, mi, 0))
        v = one("TESTO %d %d" % (t, tf))
        check(v == [att], "testo %04d-%02d-%02d %02d:%02d TF %d s -> %s (%s)" % (y, mo, d, hh, mi, tf, att, v), quiet=True, bag=bag)


# ===========================================================================
# N) DATI REALI: oro M1 HistData (NY) -> +6 h (convenzione di collaudo_natcla.py), NON e' BCM
# ===========================================================================
_M1 = None


def carica_m1():
    global _M1
    if _M1 is not None:
        return _M1
    rows = {}
    if os.path.isdir(ZIPDIR):
        ep = dt.datetime(1970, 1, 1)
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


def serie_tf(mins, da_anno, a_anno=9999):
    lo = int((dt.datetime(da_anno, 1, 1) - dt.datetime(1970, 1, 1)).total_seconds() // 60)
    hi = int((dt.datetime(min(a_anno, 9998) + 1, 1, 1) - dt.datetime(1970, 1, 1)).total_seconds() // 60)
    out = []
    cur = None
    for t, o, h, l, c in carica_m1():
        if t < lo or t >= hi:
            continue
        b = t // mins
        if b != cur:
            cur = b
            out.append([b * mins * 60, o, h, l, c])
        else:
            bar = out[-1]
            bar[2] = max(bar[2], h)
            bar[3] = min(bar[3], l)
            bar[4] = c
    if not out:
        return None
    return tuple(list(x) for x in zip(*out))


class Specchio:
    """specchio Python INDIPENDENTE, in ordine cronologico, sull'intera serie: somme cumulative per la TMA
    dell'EA, iATR a somma mobile (come ATR.mq5), Heikin Ashi ricorsiva dalla PRIMA barra della serie."""

    def __init__(self, ser):
        self.t, self.o, self.h, self.l, self.c = ser
        self.n = len(self.c)
        self._tma, self._atr = {}, {}
        o, h, l, c = self.o, self.h, self.l, self.c
        self.ha_o, self.ha_c = [0.0] * self.n, [0.0] * self.n
        for i in range(self.n):
            self.ha_c[i] = (o[i] + h[i] + l[i] + c[i]) / 4.0
            self.ha_o[i] = (o[i] + c[i]) / 2.0 if i == 0 else (self.ha_o[i - 1] + self.ha_c[i - 1]) / 2.0

    def tma_ea(self, P):
        if P not in self._tma:
            m = max(1, (P + 1) // 2)
            cs = [0.0]
            for x in self.c:
                cs.append(cs[-1] + x)
            sma = [None] * self.n
            for y in range(m - 1, self.n):
                sma[y] = (cs[y + 1] - cs[y + 1 - m]) / m
            out = [None] * self.n
            for x in range(2 * m - 2, self.n):
                out[x] = sum(sma[x - k] for k in range(m)) / m
            self._tma[P] = out
        return self._tma[P]

    def atr(self, P):
        if P not in self._atr:
            h, l, c = self.h, self.l, self.c
            tr = [h[0] - l[0]] + [max(h[i], c[i - 1]) - min(l[i], c[i - 1]) for i in range(1, self.n)]
            a = [None] * self.n
            s = 0.0
            for i in range(self.n):
                s += tr[i]
                if i >= P:
                    s -= tr[i - P]
                if i >= P - 1:
                    a[i] = s / P
            self._atr[P] = a
        return self._atr[P]

    def atr_wilder(self, P):
        h, l, c = self.h, self.l, self.c
        a = [None] * self.n
        for i in range(1, self.n):
            tr = max(h[i], c[i - 1]) - min(l[i], c[i - 1])
            a[i] = tr if a[i - 1] is None else (a[i - 1] * (P - 1) + tr) / P
        return a

    def tma_c(self, P, x, e):
        """centrata: pesi P+1-j, a destra solo barre CHIUSE (indice <= e-1, e = barra in formazione)"""
        c = self.c
        num = (P + 1) * c[x]
        den = float(P + 1)
        for j in range(1, P + 1):
            w = P + 1 - j
            num += w * c[x - j]
            den += w
            if x + j <= e - 1:
                num += w * c[x + j]
                den += w
        return num / den

    def candela(self, x, modo):
        o, h, l, c = self.o, self.h, self.l, self.c
        if modo == 0:
            return o[x], h[x], l[x], c[x]
        if modo == 1:
            C = (o[x] + h[x] + l[x] + c[x]) / 4.0
            O = ((o[x - 2] + c[x - 2]) / 2.0 + (o[x - 1] + h[x - 1] + l[x - 1] + c[x - 1]) / 4.0) / 2.0
        else:
            O, C = self.ha_o[x], self.ha_c[x]
        return O, max(h[x], O, C), min(l[x], O, C), C

    def banda(self, x, e, p, lato):
        P, A, M = (p["tmaS"], p["atrS"], p["multS"]) if lato == "S" else (p["tmaF"], p["atrF"], p["multF"])
        mid = self.tma_c(P, x, e) if p["tma"] == 1 else self.tma_ea(P)[x]
        a = self.atr(A)[x]
        return mid, mid + a * M, mid - a * M, a

    def valuta(self, e, s, p):
        x = e - s
        O, H, L, C = self.candela(x, p["candela"])
        mF, uF, lF, aF = self.banda(x, e, p, "F")
        mS, uS, lS, aS = self.banda(x, e, p, "S")
        bhi, blo = max(O, C), min(O, C)
        dF = max(blo - uF, lF - bhi) / aF
        dS = max(blo - uS, lS - bhi) / aS
        margini = [abs(abs(C - O) - p["corpo"] / 100.0 * (H - L)), abs(blo - uF), abs(bhi - lF), abs(blo - uS), abs(bhi - lS)]
        if not (H - L > 0 and abs(C - O) <= p["corpo"] / 100.0 * (H - L)):
            return 0, dF, dS, margini
        if not p["solo"]:
            mc = (blo + bhi) / 2.0
            su, giu = mc > mF, mc < mF
            margini.append(abs(mc - mF))
        else:
            fuori = {"sF": blo > uF, "gF": bhi < lF, "sS": blo > uS, "gS": bhi < lS}
            k = p["canale"]
            if k == 0:
                su, giu = fuori["sS"], fuori["gS"]
            elif k == 1:
                su, giu = fuori["sF"], fuori["gF"]
            elif k == 2:
                su, giu = fuori["sF"] or fuori["sS"], fuori["gF"] or fuori["gS"]
            else:
                su, giu = fuori["sF"] and fuori["sS"], fuori["gF"] and fuori["gS"]
        if su == giu:
            return 0, dF, dS, margini
        d = 1 if giu else -1
        if p["code"]:
            sup, inf = H - bhi, blo - L
            if (d > 0 and inf < p["rapInf"] * sup) or (d < 0 and sup < p["rapSup"] * inf):
                return 0, dF, dS, margini
        if p["flip"]:
            if s < 2:
                return 0, dF, dS, margini
            O1, _, _, C1 = self.candela(x + 1, p["candela"])
            if (d > 0 and not C1 > O1) or (d < 0 and not C1 < O1):
                return 0, dF, dS, margini
        return d, dF, dS, margini

    def ultimo(self, e, L, p):
        d1 = None
        mg = []
        for s in range(1, L + 1):
            r, a, b, m = self.valuta(e, s, p)
            mg.append(min(m))
            if s == 1:
                d1 = (a, b)
            if r != 0:
                return r, s, a, b, d1[0], d1[1], min(mg)
        return 0, 0, 0.0, 0.0, d1[0], d1[1], min(mg)


def scan(cx, ser, p, L, start, step, win=0):
    t, o, h, l, c = ser
    n = len(c)
    txt = "SCAN %s %d %d %d %d %d\n" % (spar(p), n, L, start, step, win)
    txt += "\n".join(" ".join(repr(x) for x in arr) for arr in (o, h, l, c)) + "\n"
    out = cx.run(txt)
    w = int(out[0].split()[1])
    res = {}
    for ln in out[1:]:
        if ln == "FINE":
            break
        z = ln.split()
        res[int(z[0])] = (int(z[1]), int(z[2]), fx(z[3]), fx(z[4]), fx(z[5]), fx(z[6]))
    return w, res


def confronta(cx, sp, ser, p, L, start, step, etichetta, bag, verbose, win=0, tol=1e-7):
    w, res = scan(cx, ser, p, L, start, step, win)
    diff_dir = diff_num = pareggi = 0
    esempio = ""
    accese = 0
    for e, (r, sh, a, b, a1, b1) in res.items():
        R = sp.ultimo(e, L, p)
        if r != 0:
            accese += 1
        if (r, sh) != (R[0], R[1]):
            if R[6] < 1e-9 * max(1.0, abs(sp.c[e])):
                pareggi += 1
            else:
                diff_dir += 1
                if not esempio:
                    esempio = "e=%d C++ (%d,%d) specchio (%d,%d)" % (e, r, sh, R[0], R[1])
            continue
        if max(abs(a - R[2]), abs(b - R[3]), abs(a1 - R[4]), abs(b1 - R[5])) > tol:
            diff_num += 1
            if not esempio:
                esempio = "e=%d dist C++ %.9f/%.9f specchio %.9f/%.9f" % (e, a1, b1, R[4], R[5])
    ok = len(res) > 0 and diff_dir == 0 and diff_num == 0
    check(ok, "%s: finestra minima di %d barre == specchio sull'intera serie (%d punti, %d celle accese, %d diff. segnale, "
              "%d diff. distanze, %d pareggi al bit) %s" % (etichetta, w, len(res), accese, diff_dir, diff_num, pareggi, esempio),
          quiet=not verbose, bag=bag)
    return res, diff_dir, diff_num


def numeri(cx, sers, bag, verbose, rapido=False):
    """sers: dict tf -> serie. Ritorna i risultati di C1 e C5 per le statistiche informative."""
    L = 30
    tenuti = {}
    for tf, ser in sers.items():
        sp = Specchio(ser)
        for nome, p in CONFIG:
            if rapido and tf != "H4":
                continue
            step = (7 if tf == "H1" else 3) if p["tma"] == 1 else (2 if tf == "H1" and not rapido else 1)
            res, _, _ = confronta(cx, sp, ser, p, L, 0, step, "%s %s" % (tf, nome), bag, verbose)
            tenuti[(tf, nome[:2])] = res
        if rapido:
            continue
        # CONTRO-ESEMPIO 1: canali corti (TMA 5, ATR 10) -> la finestra la decide il seme della HA ricorsiva.
        # Controllo: seme 50 == specchio. Contro-esempio: seme 2 DEVE divergere (se no il confronto non morde).
        pk = cfg(candela=2, canale=2, tmaS=5, tmaF=5, atrS=10, atrF=10, multS=0.1, multF=0.1, seme=50)
        confronta(cx, sp, ser, pk, L, 0, 3, "%s HA ricorsiva, canali corti, seme 50" % tf, bag, verbose)
        # seme misurato DIRETTAMENTE sulla candela piu' profonda (shift 30): finestra = 30+1+seme, come PD_Bisogno
        def scarto_seme(seme):
            rnd = random.Random(5)
            righe, xs = [], []
            for _ in range(300):
                e = rnd.randrange(200, sp.n)
                w_ = L + 1 + seme
                arr = [[a_[e - i] for i in range(w_)] for a_ in (sp.o, sp.h, sp.l, sp.c)]
                righe.append("CAND %d %d 2 " % (w_, L) + " ".join(" ".join(repr(v) for v in a_) for a_ in arr))
                xs.append(e - L)
            out = cx.run("\n".join(righe) + "\n")
            return max(abs(fx(z.split()[1]) - sp.ha_o[x]) / sp.c[x] for z, x in zip(out, xs))
        s50, s2 = scarto_seme(50), scarto_seme(2)
        check(s50 < 1e-12, "%s HA ricorsiva: con 50 barre di seme la candela piu' profonda == HA dell'intera serie (scarto rel. %.1e)"
              % (tf, s50), quiet=not verbose, bag=bag)
        check(s2 > 1e-6, "%s CONTRO-ESEMPIO: con 2 barre di seme la stessa candela DIVERGE (scarto rel. %.1e): il confronto morde"
              % (tf, s2), quiet=not verbose, bag=bag)
        # CONTRO-ESEMPIO 2: l'ATR alla Wilder si distingue dall'iATR di MT5 (la scelta della formula si vede)
        aw, am = sp.atr_wilder(100), sp.atr(100)
        rel = max(abs(aw[i] - am[i]) / am[i] for i in range(300, sp.n) if am[i])
        check(rel > 1e-3, "%s CONTRO-ESEMPIO: ATR Wilder contro iATR MT5 differiscono fino al %.1f%% (i numeri distinguono le due formule)"
                         % (tf, 100 * rel), quiet=not verbose, bag=bag)
    return tenuti


def testi_casuali(cx, bag):
    rnd = random.Random(11)
    righe, attesi = [], []
    for _ in range(2000):
        t = rnd.randrange(0, 4102444800)
        tf = rnd.choice([900, 1800, 3600, 14400, 28800, 43200, 86400, 604800, 2592000])
        u = dt.datetime(1970, 1, 1) + dt.timedelta(seconds=t)
        if tf < 86400:
            att = u.strftime("%H:%M")
        elif tf < 604800:
            att = ("Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun")[u.weekday()]
        elif tf < 2419200:
            att = "%02d/%02d" % (u.day, u.month)
        else:
            att = ("Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec")[u.month - 1]
        righe.append("TESTO %d %d" % (t, tf))
        attesi.append(att)
    out = cx.run("\n".join(righe) + "\n")
    bad = sum(1 for a, b in zip(out, attesi) if a != b)
    check(bad == 0 and len(out) == 2000, "testo delle celle == datetime di Python su 2000 istanti casuali 1970-2099 (%d diversi)" % bad,
          quiet=True, bag=bag)


def informativo(tenuti, sers):
    print("  INFORMATIVO (oro HistData, NON BCM, NON la dashboard originale; NON e' un verdetto):")
    print("    quota del tempo in cui la cella e' ACCESA, per barre di ricerca (la doji piu' recente e' entro N barre chiuse):")
    nomi = dict((n[:2], n) for n, _ in CONFIG)
    for tf in ("H1", "H4", "D1"):
        for k in ("C1", "C2", "C3", "C4", "C5", "C6"):
            r = tenuti.get((tf, k))
            if not r:
                continue
            q = ["N=%d %5.1f%%" % (N, 100.0 * sum(1 for v in r.values() if v[0] != 0 and v[1] <= N) / len(r)) for N in (3, 6, 12, 24, 30)]
            print("      %s %-48s %s" % (tf, nomi[k], " | ".join(q)))
    print("      screenshot di Claudio 07/10 20:22: H1 7/37 = 18,9%, H4 0/37 = 0%, D1 4/37 = 10,8% (37 simboli, UN istante)")
    print("    concordanza TMA EA (non-repaint) contro TMA centrata (ipotesi originale), stesso istante:")
    for tf in ("H1", "H4", "D1"):
        a, b = tenuti.get((tf, "C1")), tenuti.get((tf, "C5"))
        if not a or not b:
            continue
        comuni = [e for e in b if e in a]
        uguali = sum(1 for e in comuni if (a[e][0], a[e][1]) == (b[e][0], b[e][1]))
        acc_a = [e for e in comuni if a[e][0] != 0]
        anche = sum(1 for e in acc_a if b[e][0] == a[e][0])
        print("      %s: cella identica %5.1f%% degli istanti; quando la TMA EA e' accesa, la centrata e' dello stesso colore %5.1f%% (%d istanti)"
              % (tf, 100.0 * uguali / max(1, len(comuni)), 100.0 * anche / max(1, len(acc_a)), len(comuni)))


# ===========================================================================
# v1.10: NUMERI e CONTRO-ESEMPI di click, tasti, HA, doji sul grafico, EMA, Supertrend
# ===========================================================================
def py_ema(c, per):
    a = 2.0 / (per + 1.0)
    e = [0.0] * len(c)
    for i in range(len(c)):
        e[i] = c[0] if i == 0 else c[i] * a + e[i - 1] * (1.0 - a)
    return e


def py_st(h, l, c, per, mult):
    """specchio del Supertrend (SW_STCore): stesse operazioni nello stesso ordine -> bit per bit"""
    n = len(c)
    up, dn, di, va = [0.0] * n, [0.0] * n, [0.0] * n, [0.0] * n
    for i in range(n):
        if i < per:
            continue
        s = 0.0
        for k in range(i - per + 1, i + 1):
            s += max(h[k], c[k - 1]) - min(l[k], c[k - 1])
        a = s / per
        mid = (h[i] + l[i]) / 2.0
        ub, lb = mid + mult * a, mid - mult * a
        if i == per:
            up[i], dn[i] = ub, lb
            di[i] = 1.0 if c[i] >= mid else -1.0
        else:
            up[i] = ub if (ub < up[i - 1] or c[i - 1] > up[i - 1]) else up[i - 1]
            dn[i] = lb if (lb > dn[i - 1] or c[i - 1] < dn[i - 1]) else dn[i - 1]
            di[i] = 1.0 if c[i] > up[i - 1] else (-1.0 if c[i] < dn[i - 1] else di[i - 1])
        va[i] = dn[i] if di[i] > 0 else up[i]
    return di, va


def cx_st(cx, h, l, c, per, mult):
    n = len(c)
    out = cx.run("ST %d %d %r\n" % (n, per, mult) + "\n".join(" ".join(repr(x) for x in a) for a in (h, l, c)) + "\n")[0].split()
    return [float(out[2 * i]) for i in range(n)], [fx(out[2 * i + 1]) for i in range(n)]


def cx_ema(cx, c, per):
    out = cx.run("EMA %d %d\n" % (len(c), per) + " ".join(repr(x) for x in c) + "\n")[0].split()
    return [fx(z) for z in out]


def test_click(cx, bag, verbose):
    nS, nT = 35, 3
    righe, att = [], []
    for i in range(nS):
        for j in range(nT):
            for pre in ("r", "t"):
                righe.append("BERS PDL_%s_%d_%d %d %d" % (pre, i, j, nS, nT)); att.append((1, i, j))
        righe.append("BERS PDL_s_%d %d %d" % (i, nS, nT)); att.append((2, i, -1))
    for j in range(nT):
        for pre in ("hr", "ht"):
            righe.append("BERS PDL_%s_%d %d %d" % (pre, j, nS, nT)); att.append((3, -1, j))
    no = ["PDL_r_35_0", "PDL_r_0_3", "PDL_t_2_34", "PDL_s_35", "PDL_ht_3", "PDL_hr_3", "PDL_r_3", "PDL_r_3_x", "PDL_r__1",
          "PDL_r_-1_0", "XDL_r_1_1", "PDL_titolo", "PDL_pannello", "PDL_h_pair", "PDL_b_hide", "PDL_b_refresh", "PDL_b_ha",
          "PDL_b_doji", "PDL_b_ema", "PDL_b_st", "PDLG_d_1696000000", "PDL_r_1_1_1", "PDL_", "PDL_s_", "PDL_r_00001_0",
          "PDL_x_1_1", "pdl_r_1_1", "PDL_r_1_"]
    for nm in no:
        righe.append("BERS %s %d %d" % (nm, nS, nT)); att.append((0, -1, -1))
    out = cx.run("\n".join(righe) + "\n")
    bad = [(r, o) for r, o, a in zip(righe, out, att) if tuple(int(z) for z in o.split()) != a]
    check(not bad and len(out) == len(att), "CLICK: PD_Bersaglio su %d nomi (tutte le celle 35x3, simboli, TF, %d nomi da rifiutare) %s"
          % (len(att), len(no), bad[:3]), quiet=not verbose, bag=bag)
    # CONTRO-ESEMPIO riga/colonna scambiata: la cella (riga 2 = simbolo 2, colonna 1 = H4) NON deve diventare (1, 2);
    # e PDL_t_2_34 (colonna 34 inesistente) NON deve essere letta come riga 34 colonna 2
    o1 = tuple(int(z) for z in cx.run("BERS PDL_r_2_1 35 3\n")[0].split())
    o2 = tuple(int(z) for z in cx.run("BERS PDL_t_2_34 35 3\n")[0].split())
    check(o1 == (1, 2, 1) and o1 != (1, 1, 2) and o2 == (0, -1, -1),
          "CLICK CONTRO-ESEMPIO: r_2_1 -> simbolo 2 / TF 1 (non 1/2: %s); t_2_34 rifiutata (non riga 34: %s)" % (o1, o2),
          quiet=not verbose, bag=bag)


def test_stato_linea_inc(cx, bag, verbose):
    righe, att = [], []
    for a in (0, 1):
        for b in (0, 1):
            for d in (0, 1):
                for e in (0, 1):
                    righe.append("STATO %d %d %d %d" % (a, b, d, e)); att.append(str(b if (a and d == e) else e))
    out = cx.run("\n".join(righe) + "\n")
    check(out == att, "STATO dei tasti (PG_StatoIniziale) sulle 16 combinazioni: vale il salvato SOLO se l'input non e' cambiato",
          quiet=not verbose, bag=bag)
    big = 1.7976931348623157e308
    for cmd, v in (("LINEA 1 1 5 1", 5.0), ("LINEA 1 -1 5 1", big), ("LINEA 1 -1 5 -1", 5.0), ("LINEA 1 0 5 1", big), ("LINEA 0 1 5 1", big)):
        r = fx(cx.run(cmd + "\n")[0].split()[0])
        check(r == v, "PG_StLinea %s -> %s" % (cmd, v), quiet=True, bag=bag)
    # incrocio a mano: veloce f, lenta s (indici 0 = barra piu' vecchia)
    for f, s_, x, primo, a in (([1, 1, 3], [2, 2, 2], 2, 0, 1), ([1, 1, 3], [2, 2, 2], 1, 0, 0), ([3, 3, 1], [2, 2, 2], 2, 0, -1),
                               ([1, 2, 3], [2, 2, 2], 2, 0, 1), ([1, 2, 3], [2, 2, 2], 1, 0, 0), ([1, 1, 3], [2, 2, 2], 2, 3, 0),
                               ([1, 1, 3], [2, 2, 2], 0, 0, 0), ([3, 3, 3], [2, 2, 2], 2, 0, 0), ([1, 3, 1], [2, 2, 2], 2, 0, -1),
                               ([1, 3, 1], [2, 2, 2], 1, 0, 1)):
        r = int(cx.run("INC 3 %d %d " % (x, primo) + " ".join(repr(float(z)) for z in f + s_) + "\n")[0])
        check(r == a, "INCROCIO a mano f=%s s=%s x=%d primo=%d -> %d (%d)" % (f, s_, x, primo, a, r), quiet=True, bag=bag)


def test_ema_st(cx, ser, tf, bag, verbose, rapido):
    t, o, h, l, c = ser
    n = len(c)
    # EMA: bit per bit con lo specchio; incroci == cambio di segno dello specchio (dal periodo maggiore, solo x <= n-2)
    for per in (9, 21):
        e1, e2 = cx_ema(cx, c, per), py_ema(c, per)
        check(e1 == e2, "%s EMA %d: C++ == specchio Python bit per bit (%d barre)" % (tf, per, n), quiet=not verbose, bag=bag)
    fv, fl = py_ema(c, 9), py_ema(c, 21)
    out = cx.run("INCALL %d 21\n" % n + " ".join(repr(z) for z in fv + fl) + "\n")[0].split()
    bad = 0
    for x in range(n):
        a = 0 if (x < 21 or x < 1) else (1 if fv[x] > fl[x] and fv[x - 1] <= fl[x - 1] else (-1 if fv[x] < fl[x] and fv[x - 1] >= fl[x - 1] else 0))
        bad += int(int(out[x]) != a)
    ninc = sum(1 for x in range(21, n - 1) if (fv[x] > fl[x]) != (fv[x - 1] > fl[x - 1]))
    check(bad == 0 and len(out) == n, "%s INCROCIO EMA 9/21: PD_Incrocio == regola scritta su tutte le %d barre (%d incroci sulle chiuse)"
          % (tf, n, ninc), quiet=not verbose, bag=bag)
    # SUPERTREND 3 livelli: bit per bit con lo specchio
    for m in (2.5, 3.0, 3.5):
        d1, v1 = cx_st(cx, h, l, c, 10, m)
        d2, v2 = py_st(h, l, c, 10, m)
        nflip = sum(1 for i in range(11, n) if d2[i] != d2[i - 1])
        check(d1 == d2 and v1 == v2, "%s SUPERTREND 10 x %.1f: C++ == specchio bit per bit (%d inversioni)" % (tf, m, nflip),
              quiet=not verbose, bag=bag)
        if m == 3.0 and not rapido:
            # SEME e indipendenza dall'inizio della finestra: si ricalcola partendo da k barre dopo e si misura
            # dopo quante barre il risultato coincide ESATTAMENTE con quello sull'intera serie
            rnd = random.Random(3)
            lags, morde = [], 0
            for _ in range(12):
                k = rnd.randrange(50, max(51, n // 2))
                ds, vs = cx_st(cx, h[k:], l[k:], c[k:], 10, m)
                diff = [i for i in range(len(ds)) if i >= 10 and (ds[i] != d1[k + i] or vs[i] != v1[k + i])]
                morde += int(bool(diff))
                lags.append((max(diff) + 1) if diff else 10)
            check(max(lags) < 1500 and morde > 0,
                  "%s SUPERTREND: il valore NON dipende dall'inizio della finestra oltre %d barre (12 partenze; seme = barra 'periodo', "
                  "dir = chiusura >= HL2; %d partenze divergono all'inizio: la prova morde)" % (tf, max(lags), morde),
                  quiet=not verbose, bag=bag)
            le = []
            for _ in range(12):
                k = rnd.randrange(50, max(51, n // 2))
                es = cx_ema(cx, c[k:], 21)
                full = py_ema(c, 21)
                diff = [i for i in range(len(es)) if abs(es[i] - full[k + i]) > 1e-12 * abs(full[k + i])]
                le.append((max(diff) + 1) if diff else 0)
            check(max(le) < 600, "%s EMA 21: dopo %d barre dall'inizio della finestra lo scarto relativo e' < 1e-12 (seme = prima chiusura)"
                  % (tf, max(le)), quiet=not verbose, bag=bag)


def test_ha_inc(cx, ser, tf, bag, verbose):
    t, o, h, l, c = ser
    N = 900
    o, h, l, c = o[:N], h[:N], l[:N], c[:N]
    sp = Specchio((t[:N], o, h, l, c))
    def run(mode):
        z = cx.run("HAINC %d %d\n" % (N, mode) + "\n".join(" ".join(repr(x) for x in a) for a in (o, h, l, c)) + "\n")[0].split()
        return [fx(v) for v in z]
    def uguale(z):
        for i in range(N):
            ho, hc, hh, hl = z[4 * i:4 * i + 4]
            if ho != sp.ha_o[i] or hc != sp.ha_c[i] or hh != max(h[i], max(ho, hc)) or hl != min(l[i], min(ho, hc)):
                return i
        return -1
    g, b = uguale(run(1)), uguale(run(0))
    check(g == -1, "%s HA DISEGNATA incrementale (barra in formazione prima provvisoria poi vera, da = prev_calculated-1) == HA "
          "ricorsiva dell'intera serie, seme (o+c)/2 sulla barra piu' vecchia (%d barre)" % (tf, N), quiet=not verbose, bag=bag)
    check(b >= 0, "%s CONTRO-ESEMPIO: con da = prev_calculated (senza -1) la HA resta sulla barra provvisoria (prima differenza alla "
          "barra %d): l'ancora su 'prev_calculated-1' morde" % (tf, b), quiet=not verbose, bag=bag)


def test_marca(cx, sp, ser, tf, bag, verbose, rapido):
    t, o, h, l, c = ser
    L = 30
    for nome, p in CONFIG[:1] + ([] if rapido else [CONFIG[2], CONFIG[4]]):
        step = 5 if rapido else (11 if p["tma"] == 1 else 3)
        txt = "SCANM %s %d %d %d %d %d\n" % (spar(p), len(c), L, 0, step, 0)
        txt += "\n".join(" ".join(repr(x) for x in arr) for arr in (o, h, l, c)) + "\n"
        out = cx.run(txt)
        punti = bad_ult = bad_sp = pareggi = frecce = 0
        es = ""
        for ln in out:
            if ln == "FINE":
                break
            z = ln.split()
            e, r, sh, q = int(z[0]), int(z[1]), int(z[2]), int(z[3])
            lst = [(int(z[4 + 4 * k]), int(z[5 + 4 * k])) for k in range(q)]
            punti += 1
            frecce += q
            if (r == 0) != (q == 0) or (q and (lst[0] != (sh, r))) or any(not 1 <= s_ <= L for s_, _ in lst) or \
               any(lst[k][0] >= lst[k + 1][0] for k in range(q - 1)):
                bad_ult += 1
                es = es or "e=%d ultimo=(%d,%d) marca=%s" % (e, r, sh, lst[:3])
            att = []
            mg = []
            for s_ in range(1, L + 1):
                rr, _, _, m_ = sp.valuta(e, s_, p)
                mg.append(min(m_))
                if rr != 0:
                    att.append((s_, rr))
            if att != lst:
                if min(mg) < 1e-9 * max(1.0, abs(sp.c[e])):
                    pareggi += 1
                else:
                    bad_sp += 1
                    es = es or "e=%d specchio=%s marca=%s" % (e, att[:3], lst[:3])
        check(punti > 0 and bad_ult == 0 and bad_sp == 0,
              "%s DOJI SUL GRAFICO %s: PD_Marca == tutte le doji dello specchio nelle %d barre chiuse, la prima == la cella "
              "(PD_Ultimo), mai la barra in formazione (%d istanti, %d frecce, %d pareggi al bit) %s"
              % (tf, nome[:2], L, punti, frecce, pareggi, es), quiet=not verbose, bag=bag)


def informativo_ha(sers):
    """quante frecce (regola delle celle, default: HA a 2 barre come l'EA) cadono su una candela HA DISEGNATA
    (classica ricorsiva) che a occhio NON e' una doji. Informativo, non un verdetto."""
    print("  INFORMATIVO frecce doji contro candele HA disegnate (oro HistData; default C1 = HA a 2 barre come l'EA,"
          " CONTRO-ESEMPIO = HA ricorsiva, seme 50):")
    for etich, p, ser_tf in (("C1 default", CONFIG[0][1], None), ("HA ricorsiva", cfg(candela=2), None)):
      for tf, ser in sers.items():
        sp = Specchio(ser)
        tot = nodoji = 0
        for x in range(400, sp.n - 1):
            r, _, _, _ = sp.valuta(x + 1, 1, p)
            if r == 0:
                continue
            tot += 1
            O, C = sp.ha_o[x], sp.ha_c[x]
            H, L_ = max(sp.h[x], O, C), min(sp.l[x], O, C)
            if not (H - L_ > 0 and abs(C - O) <= p["corpo"] / 100.0 * (H - L_)):
                nodoji += 1
        print("      %-12s %s: %d frecce, su %d (%.0f%%) la candela HA disegnata NON e' una doji al 10%%"
              % (etich, tf, tot, nodoji, 100.0 * nodoji / max(1, tot)))


# --- modello ESEGUIBILE dei colori: le funzioni VERE estratte dal sorgente, compilate in C++ su un grafico finto,
#     DUE istanze (la vecchia e la nuova del ricarico da click) che condividono lo stesso grafico
COL_SHIM = r'''
#include <cstdio>
#include <map>
#include <string>
typedef unsigned int color;
typedef std::string string;
enum ENUM_CHART_PROPERTY_INTEGER { CHART_COLOR_CANDLE_BULL=1, CHART_COLOR_CANDLE_BEAR, CHART_COLOR_CHART_UP, CHART_COLOR_CHART_DOWN, CHART_COLOR_CHART_LINE };
const color clrNONE=0xFFFFFFFFu, clrLime=0x00FF00u, clrRed=0x0000FFu;
static std::map<int,long long> CH;
static long long NONE_AS=4294967295LL;     /* come il terminale restituisce clrNONE: provati 4294967295 e -1 */
inline long long ChartGetInteger(long long,int p){ return CH[p]; }
inline bool ChartSetInteger(long long,int p,long long v){ CH[p]=((color)v==clrNONE)? NONE_AS : (long long)(color)v; return true; }
template<typename... A> void Print(A...){}
inline int GetLastError(){ return 0; }
'''
COL_FUN = ("ColOrDefault", "ColsHide", "ColsRestore", "IsNone", "RepairInvisibleNative", "CuraColori")
COL_MAIN = r'''
static const int P[5]={CHART_COLOR_CANDLE_BULL,CHART_COLOR_CANDLE_BEAR,CHART_COLOR_CHART_UP,CHART_COLOR_CHART_DOWN,CHART_COLOR_CHART_LINE};
static const long long O[5]={0x111111,0x222222,0x333333,0x444444,0x555555};
static void metti(){ for(int k=0;k<5;k++) CH[P[k]]=O[k]; }
static bool originali(){ for(int k=0;k<5;k++) if(CH[P[k]]!=O[k]) return false; return true; }
static bool tuttenone(){ for(int k=0;k<5;k++) if((color)CH[P[k]]!=clrNONE) return false; return true; }
static bool nessunanone(){ for(int k=0;k<5;k++) if((color)CH[P[k]]==clrNONE) return false; return true; }
static void reset(){ A::gColsHidden=false; B::gColsHidden=false; A::gCure=0; B::gCure=0; }
int main(){
  for(int modo=0;modo<2;modo++){
    NONE_AS = modo==0 ? 4294967295LL : -1LL;
    /* S1 HA acceso all'avvio (default ON) poi rimozione: i colori tornano QUELLI di prima */
    metti(); reset(); A::gHA=true; A::ColsHide(); bool s1a=tuttenone(); A::ColsRestore(); printf("S1 %d\n",(s1a&&originali())?1:0);
    /* S2 click = ricarico, l'OnDeinit della VECCHIA (A) arriva DOPO l'OnInit della NUOVA (B) */
    metti(); reset(); A::gHA=true; A::ColsHide(); B::gHA=true; B::ColsHide(); A::ColsRestore();
    B::CuraColori(); bool s2a=tuttenone(); B::ColsRestore(); printf("S2 %d\n",(s2a&&originali())?1:0);
    /* S3 ricarico nell'ordine "normale": A esce, poi B entra */
    metti(); reset(); A::gHA=true; A::ColsHide(); A::ColsRestore(); B::gHA=true; B::ColsHide(); bool s3a=tuttenone(); B::ColsRestore();
    printf("S3 %d\n",(s3a&&originali())?1:0);
    /* S4 crash con HA acceso (niente OnDeinit) e riavvio con HA spento: le candele tornano VISIBILI */
    metti(); reset(); A::gHA=true; A::ColsHide(); B::gHA=false; B::RepairInvisibleNative(); printf("S4 %d\n",nessunanone()?1:0);
    /* S5 chi nasconde apposta solo le candele (linea visibile) non viene toccato */
    metti(); reset(); CH[P[0]]=(long long)NONE_AS; CH[P[1]]=(long long)NONE_AS; B::RepairInvisibleNative();
    printf("S5 %d\n",((color)CH[P[0]]==clrNONE && CH[P[4]]==O[4])?1:0);
    /* S6 tasto HA acceso/spento due volte */
    metti(); reset(); A::gHA=true; A::ColsHide(); A::ColsRestore(); A::ColsHide(); A::ColsRestore(); printf("S6 %d\n",originali()?1:0);
    /* S7 crash con HA acceso e riavvio con HA ACCESO: si nasconde e alla rimozione tornano visibili (ripiego), mai clrNONE */
    metti(); reset(); A::gHA=true; A::ColsHide(); B::gHA=true; B::ColsHide(); bool s7a=tuttenone(); B::ColsRestore();
    printf("S7 %d\n",(s7a&&nessunanone())?1:0);
  }
  return 0;
}
'''


def modello_colori(src, tmp, bag, verbose):
    cxx = shutil.which("g++") or shutil.which("clang++")
    sc = re.sub(r"//[^\n]*", "", src)
    corpi = []
    for f in COL_FUN:
        b_ = corpo(sc, f)
        if not b_:
            bag.append("V11 colori: funzione %s non trovata" % f)
            return
        corpi.append(re.sub(r"\blong\b", "long long", b_))
    glob = "bool gColsHidden=false; color gColBull=clrNONE,gColBear=clrNONE,gColUp=clrNONE,gColDown=clrNONE,gColLine=clrNONE; " \
           "int gCure=0; bool gHA=false; bool gRidisegna=false;\n"
    testo = COL_SHIM + "".join("namespace %s {\n%s%s\n}\n" % (ns, glob, "\n".join(corpi)) for ns in ("A", "B")) + COL_MAIN
    os.makedirs(tmp, exist_ok=True)
    cp, exe = os.path.join(tmp, "colori.cpp"), os.path.join(tmp, "colori")
    with open(cp, "w") as f:
        f.write(testo)
    r = subprocess.run([cxx, "-std=c++17", "-O1", "-w", "-o", exe, cp], capture_output=True, text=True)
    if r.returncode != 0:
        bag.append("V11 colori: il modello non compila: %s" % r.stderr[:200])
        return
    out = subprocess.run([exe], capture_output=True, text=True).stdout.split("\n")
    esiti = [ln for ln in out if ln.startswith("S")]
    ko = [ln for ln in esiti if not ln.endswith(" 1")]
    check(len(esiti) == 14 and not ko,
          "COLORI (funzioni VERE estratte, grafico finto, due istanze): HA di default ON + rimozione, ricarico da click in "
          "tutti e due gli ordini, crash, toggle; clrNONE come 4294967295 e come -1 -> %d/14 ok %s" % (len(esiti) - len(ko), ko),
          quiet=not verbose, bag=bag)


def test_v11(cx, src, tmp, sers, bag, verbose, rapido):
    test_click(cx, bag, verbose)
    test_stato_linea_inc(cx, bag, verbose)
    modello_colori(src, os.path.join(tmp, "colori"), bag, verbose)
    for tf, ser in sers.items():
        if rapido and tf != "H4":
            continue
        test_ema_st(cx, ser, tf, bag, verbose, rapido)
        test_ha_inc(cx, ser, tf, bag, verbose)
        test_marca(cx, Specchio(ser), ser, tf, bag, verbose, rapido)


# ===========================================================================
# SUITE (la stessa per il vero e per i mutanti)
# ===========================================================================
def suite(raw, tmp, sers, ea_src, verbose, rapido):
    bag = []
    src = statico(raw, bag, ea_src)
    if "//@@PD_PURE_BEGIN" not in src:
        return bag, None
    cx = Cxx(src, tmp)
    if not cx.ok:
        bag.append("il blocco puro non compila in C++: %s" % cx.err[:300])
        return bag, None
    if verbose and cx.err.strip():
        print("  (avvisi del compilatore C++: %s)" % cx.err.strip()[:300])
    check(not cx.err.strip(), "blocco puro: nessun avviso del compilatore C++ (-Wall -Wshadow)", quiet=not verbose, bag=bag)
    try:
        unitari(cx, bag)
        testi_casuali(cx, bag)
        tenuti = numeri(cx, sers, bag, verbose, rapido)
        test_v11(cx, src, tmp, sers, bag, verbose, rapido)
    except Exception as ex:
        bag.append("eccezione: %s" % ex)
        return bag, None
    return bag, tenuti


MUTANTI = [
    ("doji con < invece di <=", "return(MathAbs(c-o) <= bodyMaxPct/100.0*range);", "return(MathAbs(c-o) < bodyMaxPct/100.0*range);"),
    ("TMA EA spostata di una barra", "for(int j=0;j<m;j++) s+=c[shift+k+j];", "for(int j=0;j<m;j++) s+=c[shift+k+j+1];"),
    ("ATR con la chiusura della stessa barra", "s+=MathMax(h[i],c[i+1])-MathMin(l[i],c[i+1]);", "s+=MathMax(h[i],c[i])-MathMin(l[i],c[i]);"),
    ("canale 'uno dei due' diventa 'entrambi'", "sopra=(sF || sS); sotto=(gF || gS);", "sopra=(sF && sS); sotto=(gF && gS);"),
    ("colori invertiti", "int dir=(sotto ? 1 : -1);", "int dir=(sotto ? -1 : 1);"),
    ("uscita dal canale non stretta", "bool sF=(blo>upF), gF=(bhi<loF)", "bool sF=(blo>=upF), gF=(bhi<=loF)"),
    ("ricerca dalla barra piu' vecchia", "for(int s=1;s<=barre;s++)\n     {\n      double a=0.0, b=0.0;\n      int r=PD_Valuta(o,h,l,c,n,s,p,a,b);\n      if(r==PD_NODATI) return(PD_NODATI);",
     "for(int s=barre;s>=1;s--)\n     {\n      double a=0.0, b=0.0;\n      int r=PD_Valuta(o,h,l,c,n,s,p,a,b);\n      if(r==PD_NODATI) return(PD_NODATI);"),
    ("HA come l'EA con il seme sbagliato", "double haO_prev=(o[shift+2]+c[shift+2])/2.0;", "double haO_prev=(o[shift+1]+c[shift+1])/2.0;"),
    ("giorno della settimana sfasato", "(int)((g+4)%7)*3", "(int)((g+3)%7)*3"),
    ("barre minime senza l'ATR lento", "   b=PD_MaxI(b,s+p.atrS+1);\n", ""),
    ("cache della barra tolta", "   if(lb!=0 && lb==gUltBarra[k]){ gProssimo[k]=ora+InpRicontrolloSec; return(false); }   // nessuna barra nuova: niente copia\n", ""),
    ("ChartRedraw a ogni ciclo", "   if(gRidisegna)\n     {\n      gRidisegna=false;\n      ChartRedraw(0);\n     }",
     "   gRidisegna=false;\n   ChartRedraw(0);"),
    ("timer non spento", "   EventKillTimer();\n", ""),
    ("oggetti non cancellati", "      ObjectsDeleteAll(0,PD_PREF);\n      ObjectsDeleteAll(0,PD_DOJI);\n     }\n   if(reason", "     }\n   if(reason"),
    ("H4 spento di default", "input bool InpH4  = true;", "input bool InpH4  = false;"),
    ("canale veloce di default", "input ENUM_PD_CANALE InpCanale          = PD_CH_UNO;", "input ENUM_PD_CANALE InpCanale          = PD_CH_VELOCE;"),
    ("lista 4 senza XAUUSD", "USDJPY,XAUUSD,USOIL\"", "USDJPY,USOIL\""),
    ("include di trading", "#property indicator_plots   15\n", "#property indicator_plots   15\n#include <Trade/Trade.mqh>\n"),
    ("prossima barra 10 volte piu' lontana", "gProssimo[k]=gR[0].time+DurataBarra(tf);", "gProssimo[k]=gR[0].time+DurataBarra(tf)*10;"),
    ("flip sulla barra in formazione", "if(shift<2) return(0);", "if(shift<1) return(0);"),
    ("TMA centrata con la barra in formazione", "if(shift-j>=1){ sum+=k*c[shift-j]; sw+=k; }", "if(shift-j>=0){ sum+=k*c[shift-j]; sw+=k; }"),
    ("coda Dragonfly sul lato sbagliato", "if(dir>0 && !(ci>=p.rapInf*cs)) return(0);", "if(dir>0 && !(cs>=p.rapInf*ci)) return(0);"),
    ("distanza col minimo", "return(MathMax(blo-up,lo-bhi)/atr);", "return(MathMin(blo-up,lo-bhi)/atr);"),
    ("HA ricorsiva ferma una barra prima", "for(int i=n-2;i>=shift;i--)", "for(int i=n-2;i>shift;i--)"),
    ("alert anche al primo calcolo", "r!=0 && sh==1 && gPronta[k] && tseg!=gTSeg[k]", "r!=0 && sh==1 && tseg!=gTSeg[k]"),
    ("testo della cella col TF sbagliato", "txt=PD_Testo(gTSeg[k],PeriodSeconds(gTF[j]));", "txt=PD_Testo(gTSeg[k],PeriodSeconds(gTF[0]));"),
    ("ora del segnale dalla barra dopo", "datetime tseg=(r!=0 ? gR[sh].time : (datetime)0);", "datetime tseg=(r!=0 ? gR[sh-1].time : (datetime)0);"),
    ("senza filtro canale: lato dalla TMA lenta", "sopra=(mc>midF); sotto=(mc<midF);", "sopra=(mc>midS); sotto=(mc<midS);"),
    ("entrambi diventa uno dei due", "else                 { sopra=(sF && sS); sotto=(gF && gS); }",
     "else                 { sopra=(sF || sS); sotto=(gF || gS); }"),
    ("mese sfasato", "mo=(int)(mp<10 ? mp+3 : mp-9);", "mo=(int)(mp<10 ? mp+2 : mp-9);"),
    ("copia di barre fissa", "int got=CopyRates(s,tf,0,gBisogno,gR);", "int got=CopyRates(s,tf,0,100,gR);"),
    ("oggetti toccati sempre", "if(txt!=gTxt[k]){ ObjectSetString", "if(true){ ObjectSetString"),
    ("stato aggiornato prima dell'alert (l'alert non scatterebbe mai)", "   //--- alert: solo un segnale NUOVO",
     "   gDir[k]=r; gTSeg[k]=tseg;\n   //--- alert: solo un segnale NUOVO"),
    ("simbolo fuori Market Watch non saltato", "   if(gStatoSim[i]!=0) return(false);\n   if(ora<gProssimo[k]) return(false);",
     "   if(ora<gProssimo[k]) return(false);"),
    ("timer a 5 s", "   EventSetTimer(1);", "   EventSetTimer(5);"),
    ("rinvio senza crescita", "gAttesa[k]=(gAttesa[k]<=0 ? 2 : (gAttesa[k]>=150 ? 300 : gAttesa[k]*2));", "gAttesa[k]=2;"),
    ("parametro flip non passato", "gPar.flip=InpConfermaFlip;", "gPar.flip=false;"),
    ("rapporti delle code scambiati", "gPar.rapInf=InpRapCodaInf; gPar.rapSup=InpRapCodaSup;", "gPar.rapInf=InpRapCodaSup; gPar.rapSup=InpRapCodaInf;"),
    ("seme HA tolto dalle barre minime", "   if(p.candela==2) b=PD_MaxI(b,s+1+p.semeHA);\n", ""),
    # --- mutanti CIECHI del cancello (controllo-preventivo 07/10/2026): 16 su 20 erano VERDI prima delle ancore
    ("serie vuota rinviata senza copia", "   if(lb!=0 && lb==gUltBarra[k])", "   if(lb==0){ Rinvia(k,ora); return(false); }\n   if(lb!=0 && lb==gUltBarra[k])"),
    ("Market Watch invertito", "SymbolInfoInteger(gSym[i],SYMBOL_SELECT)==0", "SymbolInfoInteger(gSym[i],SYMBOL_SELECT)!=0"),
    ("reset al rientro nel Market Watch tolto", "if(st==0){ gProssimo[k]=0; gAttesa[k]=0; gUltBarra[k]=0; }", ""),
    ("avviso 2 copie con 1 copia", "if(n>=2)", "if(n>=1)"),
    ("stato dei simboli mai riletto", "if(ora-gUltStato>=60)", "if(ora-gUltStato>=600000)"),
    ("colore del simbolo invertito", "color cs=(gStatoSim[i]==0 ? InpColTesto : InpColSpento);", "color cs=(gStatoSim[i]==0 ? InpColSpento : InpColTesto);"),
    ("limite 500 barre tolto", "InpBarreIndietro>500 ||", ""),
    ("tooltip con la direzione scambiata", "(gDir[k]>0 ? \"doji RIALZISTA (sotto)\" : \"doji RIBASSISTA (sopra)\")",
     "(gDir[k]>0 ? \"doji RIBASSISTA (sopra)\" : \"doji RIALZISTA (sotto)\")"),
    ("cella mai pronta (tabella sempre vuota)", "   gPronta[k]=true;\n", ""),
    ("attesa non azzerata dopo il calcolo", "   gAttesa[k]=0;\n   gProssimo[k]=gR[0].time", "   gProssimo[k]=gR[0].time"),
    ("barre minime senza la barra shift+2 della HA", "int b=s+3;", "int b=s+2;"),
    ("pulizia iniziale tolta", "   ObjectsDeleteAll(0,PD_PREF);               // oggetti", "   //ObjectsDeleteAll(0,PD_PREF);               // oggetti"),
    ("tooltip fuori Market Watch mai", "if(gStatoSim[i]==1)      tip=", "if(gStatoSim[i]==7)      tip="),
    ("serie vuota: uscita if(!lb) prima della riga corretta", "   if(lb!=0 && lb==gUltBarra[k])", "   if(!lb){ Rinvia(k,ora); return(false); }\n   if(lb!=0 && lb==gUltBarra[k])"),
    ("serie vuota: uscita if(lb<=0) prima della riga corretta", "   if(lb!=0 && lb==gUltBarra[k])", "   if(lb<=0){ Rinvia(k,ora); return(false); }\n   if(lb!=0 && lb==gUltBarra[k])"),
    ("serie vuota: uscita if(lb<1) con attesa fissa", "   if(lb!=0 && lb==gUltBarra[k])", "   if(lb<1){ gProssimo[k]=ora+60; return(false); }\n   if(lb!=0 && lb==gUltBarra[k])"),
    ("nome oggetto sbagliato nel controllo di OnTimer", "if(ObjectFind(0,PD_PREF+\"pannello\")<0 ||", "if(ObjectFind(0,PD_PREF+\"pannellx\")<0 ||"),
    ("ricostruzione degli oggetti tolta", "   if(ObjectFind(0,PD_PREF+\"pannello\")<0 || ObjectFind(0,PD_PREF+\"b_hide\")<0) Struttura();\n", ""),
    ("cursore fermo sulla cella 0", "gCursore=(gCursore+1)%tot;", "gCursore=(gCursore+0)%tot;"),
    ("stato iniziale gia' 'ok'", "ArrayInitialize(gStatoSim,-1);", "ArrayInitialize(gStatoSim,0);"),
    ("colonna H4 riempita con H8", 'AggiungiTF(InpH4,PERIOD_H4,"H4")', 'AggiungiTF(InpH4,PERIOD_H8,"H4")'),
    ("colonna D1 riempita con W1", 'AggiungiTF(InpD1,PERIOD_D1,"D1")', 'AggiungiTF(InpD1,PERIOD_W1,"D1")'),
    ("suffisso del broker ignorato", "gSym[gNS]=s+InpSuffisso;", "gSym[gNS]=s;"),
    ("spazi attorno ai simboli tenuti", "StringTrimLeft(s); StringTrimRight(s);", ""),
    ("distanze del confronto a cella non pronta", "if(InpModoConfronto && gPronta[k] && gStatoSim[i]==0)", "if(InpModoConfronto && gStatoSim[i]==0)"),
    ("rettangoli dietro al grafico", "   ObjectSetInteger(0,nome,OBJPROP_BACK,false);\n   ObjectSetInteger(0,nome,OBJPROP_SELECTABLE,false);\n   ObjectSetInteger(0,nome,OBJPROP_HIDDEN,true);\n   ObjectSetInteger(0,nome,OBJPROP_TIMEFRAMES,Periodi(nome));\n  }\n\nvoid Etic",
     "   ObjectSetInteger(0,nome,OBJPROP_BACK,true);\n   ObjectSetInteger(0,nome,OBJPROP_SELECTABLE,false);\n   ObjectSetInteger(0,nome,OBJPROP_HIDDEN,true);\n   ObjectSetInteger(0,nome,OBJPROP_TIMEFRAMES,Periodi(nome));\n  }\n\nvoid Etic"),
    ("seme HA negativo accettato", "InpSemeHA<0 ||", ""),
    # --- v1.10 mutanti CIECHI su click, tasti, HA, doji sul grafico, HIDE, REFRESH, EMA, Supertrend
    # CLICK (contro-esempio: riga/colonna scambiata, limiti, prefisso, tipo di evento, destinazione)
    ("click: simbolo preso dalla COLONNA", "string sym=(i>=0 ? gSym[i] : _Symbol);", "string sym=(j>=0 ? gSym[j] : _Symbol);"),
    ("click: TF preso dalla RIGA", "ENUM_TIMEFRAMES tf=(j>=0 ? gTF[j] : (ENUM_TIMEFRAMES)_Period);",
     "ENUM_TIMEFRAMES tf=(i>=0 ? gTF[i] : (ENUM_TIMEFRAMES)_Period);"),
    ("PD_Bersaglio riga e colonna scambiate", "      i=a; j=b;\n      return(1);", "      i=b; j=a;\n      return(1);"),
    ("PD_Bersaglio limite della colonna non stretto", "if(a<0 || a>=nS || b<0 || b>=nT) return(0);", "if(a<0 || a>=nS || b<0 || b>nT) return(0);"),
    ("PD_Bersaglio limiti nS/nT scambiati", "if(a<0 || a>=nS || b<0 || b>=nT) return(0);", "if(a<0 || a>=nT || b<0 || b>=nS) return(0);"),
    ("NomeT con riga e colonna scambiate", 'return(PD_PREF+"t_"+IntegerToString(i)+"_"+IntegerToString(j));',
     'return(PD_PREF+"t_"+IntegerToString(j)+"_"+IntegerToString(i));'),
    ("click sul simbolo porta alla colonna 0", "      i=a;\n      return(2);", "      i=a; j=0;\n      return(2);"),
    ("click sul TF porta al simbolo 0", "      j=b;\n      return(3);", "      i=0; j=b;\n      return(3);"),
    ("filtro del tipo di evento tolto", "   if(id!=CHARTEVENT_OBJECT_CLICK) return;\n   if(StringFind", "   if(StringFind"),
    ("SymbolSelect tolto", "   if(SymbolInfoInteger(sym,SYMBOL_SELECT)==0 && !SymbolSelect(sym,true))",
     "   if(SymbolInfoInteger(sym,SYMBOL_SELECT)<0)"),
    ("grafico nuovo invertito", "   if(InpClickNuovoGrafico)\n     {\n      if(ChartOpen", "   if(!InpClickNuovoGrafico)\n     {\n      if(ChartOpen"),
    ("ChartSetSymbolPeriod sul simbolo corrente", "if(!ChartSetSymbolPeriod(0,sym,tf))", "if(!ChartSetSymbolPeriod(0,_Symbol,tf))"),
    ("ChartOpen sul TF corrente", "if(ChartOpen(sym,tf)==0)", "if(ChartOpen(sym,_Period)==0)"),
    ("default: click apre un grafico nuovo", "input bool InpClickNuovoGrafico = false;", "input bool InpClickNuovoGrafico = true;"),
    ("PD_Numero accetta non-cifre", "      if(ch<'0' || ch>'9') return(-1);\n", ""),
    ("prefisso del nome non controllato", "   if(StringLen(nome)<=lp || StringSubstr(nome,0,lp)!=p) return(0);", "   if(StringLen(nome)<=lp) return(0);"),
    ("il tasto cliccato non torna su", "      ObjectSetInteger(0,sparam,OBJPROP_STATE,false);   // il tasto torna su\n", ""),
    ("click senza controllo del bersaglio", "   if(tipo==0) return;\n", ""),
    ("tasto REFRESH collegato a HA", 'else if(sparam==PD_PREF+"b_refresh") Refresh();', 'else if(sparam==PD_PREF+"b_refresh") ImpostaHA(!gHA);'),
    # HA e colori del grafico
    ("HA di default ON che DIMENTICA di salvare i colori",
     "   gColBull=ColOrDefault(ChartGetInteger(0,CHART_COLOR_CANDLE_BULL),clrLime);\n"
     "   gColBear=ColOrDefault(ChartGetInteger(0,CHART_COLOR_CANDLE_BEAR),clrRed);\n"
     "   gColUp  =ColOrDefault(ChartGetInteger(0,CHART_COLOR_CHART_UP),   clrLime);\n"
     "   gColDown=ColOrDefault(ChartGetInteger(0,CHART_COLOR_CHART_DOWN), clrRed);\n"
     "   gColLine=ColOrDefault(ChartGetInteger(0,CHART_COLOR_CHART_LINE), clrLime);\n", ""),
    ("colori catturati DOPO averli messi a clrNONE", "   gColsHidden=true;   // da qui in poi OGNI uscita ripristina\n   bool ok=true;\n"
     "   ok=ChartSetInteger(0,CHART_COLOR_CANDLE_BULL,clrNONE) && ok;\n",
     "   gColsHidden=true;   // da qui in poi OGNI uscita ripristina\n   bool ok=true;\n"
     "   ok=ChartSetInteger(0,CHART_COLOR_CANDLE_BULL,clrNONE) && ok;\n"
     "   gColBull=ColOrDefault(ChartGetInteger(0,CHART_COLOR_CANDLE_BULL),clrLime);\n"),
    ("colore LINEA non nascosto", "   ok=ChartSetInteger(0,CHART_COLOR_CHART_LINE, clrNONE) && ok;\n", ""),
    ("colore LINEA non ripristinato", "   ChartSetInteger(0,CHART_COLOR_CHART_LINE, gColLine);\n   gColsHidden=false;", "   gColsHidden=false;"),
    ("OnDeinit non ripristina i colori", "   ColsRestore();                             // OGNI motivo", "   //ColsRestore();                             // OGNI motivo"),
    ("HA spento di default", "input bool InpHaDefault         = true;", "input bool InpHaDefault         = false;"),
    ("OnInit con HA acceso non nasconde", "   if(gHA)\n      ColsHide();     // ultimo passo", "   if(false)\n      ColsHide();     // ultimo passo"),
    ("riparazione dopo crash tolta", "   else\n      RepairInvisibleNative();\n   EventSetTimer(1);", "   EventSetTimer(1);"),
    ("cura dei colori non ricattura", "   gColsHidden=false;\n   ColsHide();\n   if(gCure>=3)", "   ColsHide();\n   if(gCure>=3)"),
    ("cura dei colori tolta dal timer", "   CuraColori();\n   if(!gNascosta)", "   if(!gNascosta)"),
    ("tasto HA spento non ripristina", "   else ColsRestore();\n   ApplicaPlot();", "   ApplicaPlot();"),
    ("plot HA invertito", "PlotIndexSetInteger(0,PLOT_DRAW_TYPE,gHA ? DRAW_COLOR_CANDLES : DRAW_NONE);",
     "PlotIndexSetInteger(0,PLOT_DRAW_TYPE,gHA ? DRAW_NONE : DRAW_COLOR_CANDLES);"),
    ("colore HA invertito", "bHAcol[x]=(bHAc[x]>=bHAo[x]) ? 0.0 : 1.0;", "bHAcol[x]=(bHAc[x]>=bHAo[x]) ? 1.0 : 0.0;"),
    ("HA incrementale senza -1 (barra in formazione congelata)", "int da=(pieno ? 0 : prev_calculated-1);", "int da=(pieno ? 0 : prev_calculated);"),
    ("HA col seme sbagliato", "double xo=(i==0) ? (o[i]+c[i])/2.0 : (ho[i-1]+hc[i-1])/2.0;",
     "double xo=(i==0) ? (o[i]+h[i]+l[i]+c[i])/4.0 : (ho[i-1]+hc[i-1])/2.0;"),
    ("stato dimenticato al cambio simbolo/TF", "   if(reason==REASON_REMOVE || reason==REASON_CHARTCLOSE)", "   if(reason==REASON_CHARTCHANGE)"),
    ("GlobalVariable senza ChartID (grafici che si pestano)", 'return(PD_GV+IntegerToString(ChartID())+"_"+cosa);', 'return(PD_GV+cosa);'),
    ("stato HA letto dall'input DOJI", 'gHA=StatoAvvio("HA",InpHaDefault);', 'gHA=StatoAvvio("HA",InpDojiDefault);'),
    ("tasto HA salva una chiave che nessuno legge", 'GvSalva("SHA",on ? 1.0 : 0.0);', 'GvSalva("SHA_",on ? 1.0 : 0.0);'),
    # DOJI sul grafico
    ("DOJI OFF non toglie le frecce", '   else { ObjectsDeleteAll(0,PD_DOJI); gMarcNome=""; gRidisegna=true; }', '   else { gMarcNome=""; gRidisegna=true; }'),
    ("DOJI OFF: le frecce si calcolano lo stesso", "      if(gDoji) MarcaDoji();\n      if(InpDisegnaCanali)", "      MarcaDoji();\n      if(InpDisegnaCanali)"),
    ("REFRESH calcola le frecce a DOJI spento", "   if(gDoji) MarcaDoji();               // dall'istantanea", "   MarcaDoji();               // dall'istantanea"),
    ("frecce doji a ogni tick", "   if(time[rates_total-1]!=gUltBarraGraf)", "   if(true)"),
    ("frecce vecchie non cancellate", "   ObjectsDeleteAll(0,PD_DOJI);\n   gMarcNome=\"\";\n   gRidisegna=true;\n   if(gXn<=0) return;",
     "   gMarcNome=\"\";\n   gRidisegna=true;\n   if(gXn<=0) return;"),
    ("freccia col colore invertito", "OBJPROP_COLOR,su ? InpColRialzo : InpColRibasso", "OBJPROP_COLOR,su ? InpColRibasso : InpColRialzo"),
    ("freccia rialzista sopra la candela", "double pr=(su ? gXhl[s] : gXhh[s]);", "double pr=(su ? gXhh[s] : gXhl[s]);"),
    ("istantanea non in ordine serie", "      int y=rt-1-x;", "      int y=x;"),
    ("PD_Marca dalla barra in formazione", "   for(int s=1;s<=barre;s++)\n     {\n      double a=0.0, b=0.0;\n      int r=PD_Valuta(o,h,l,c,n,s,p,a,b);\n      if(r==PD_NODATI) break;",
     "   for(int s=0;s<=barre;s++)\n     {\n      double a=0.0, b=0.0;\n      int r=PD_Valuta(o,h,l,c,n,s,p,a,b);\n      if(r==PD_NODATI) break;"),
    ("PD_Marca si ferma alla prima doji", "      if(r!=0){ sh[q]=s; dir[q]=r; dF[q]=a; dS[q]=b; q++; }", "      if(r!=0){ sh[q]=s; dir[q]=r; dF[q]=a; dS[q]=b; q++; break; }"),
    ("frecce su una finestra diversa dalle celle", "int nm=PD_Marca(gXo,gXh,gXl,gXc,gXn,InpBarreIndietro,gPar,", "int nm=PD_Marca(gXo,gXh,gXl,gXc,gXn,5,gPar,"),
    ("tooltip della freccia senza distanza", "gMf[q],gMl[q]));", "0.0,0.0));"),
    ("frecce cancellate dall'istanza vecchia mai rifatte", "   if(gDoji && gMarcNome!=\"\" && ObjectFind(0,gMarcNome)<0) MarcaDoji();\n", ""),
    ("DOJI spento di default", "input bool InpDojiDefault       = true;", "input bool InpDojiDefault       = false;"),
    ("istantanea troppo corta per i canali", "gBisognoGraf=PD_Bisogno(gPar,(InpDisegnaCanali && InpBarreCanali>InpBarreIndietro) ? InpBarreCanali : InpBarreIndietro);",
     "gBisognoGraf=PD_Bisogno(gPar,InpBarreIndietro);"),
    ("canale veloce disegnato col lento", "if(PD_Banda(gXh,gXl,gXc,gXn,s,gPar.tmaModo,gPar.tmaF,gPar.atrF,gPar.multF,mid,up,lo,a)){ bCVs[x]=up; bCVi[x]=lo; }",
     "if(PD_Banda(gXh,gXl,gXc,gXn,s,gPar.tmaModo,gPar.tmaS,gPar.atrS,gPar.multS,mid,up,lo,a)){ bCVs[x]=up; bCVi[x]=lo; }"),
    # HIDE
    ("HIDE nasconde anche il suo tasto (non si riapre piu')", '   if(gNascosta && nome!=PD_PREF+"b_hide") return(OBJ_NO_PERIODS);', "   if(gNascosta) return(OBJ_NO_PERIODS);"),
    ("HIDE continua a copiare dati", "   if(!gNascosta) GiroCelle(ora);", "   GiroCelle(ora);"),
    ("SHOW senza ricalcolo", "   if(!on) Refresh();                    // allo SHOW", "   //if(!on) Refresh();                    // allo SHOW"),
    ("HIDE non applicato ai rettangoli", "   ObjectSetInteger(0,nome,OBJPROP_TIMEFRAMES,Periodi(nome));\n  }\n\nvoid Etic", "  }\n\nvoid Etic"),
    ("stato HIDE non salvato", '   GvSalva("SHIDE",on ? 1.0 : 0.0);\n', ""),
    ("ricostruzione solo se manca il pannello (tasto HIDE perso)", ' || ObjectFind(0,PD_PREF+"b_hide")<0) Struttura();', ") Struttura();"),
    ("HIDE di default", "input bool InpNascostaDefault   = false;", "input bool InpNascostaDefault   = true;"),
    # REFRESH (contro-esempio: UNA sola cache azzerata)
    ("REFRESH non azzera gProssimo", "      gProssimo[k]=0;\n", ""),
    ("REFRESH non azzera gAttesa", "      gAttesa[k]=0;\n", ""),
    ("REFRESH non azzera gUltBarra", "      gUltBarra[k]=0;\n", ""),
    ("REFRESH non azzera gPronta", "      gPronta[k]=false;                 // niente alert", "      //gPronta[k]=false;                 // niente alert"),
    ("REFRESH copia tutto in blocco nell'handler", "   gUltStato=0;                         // stato",
     "   for(int z=0;z<nc;z++) Elabora(z,TimeCurrent());\n   gUltStato=0;                         // stato"),
    ("REFRESH su una cella sola", "   for(int k=0;k<nc;k++)\n     {\n      gProssimo[k]=0;", "   for(int k=0;k<1;k++)\n     {\n      gProssimo[k]=0;"),
    ("REFRESH non rilegge lo stato dei simboli", "   gUltStato=0;                         // stato dei simboli", "   gUltStato=gUltStato;                         // stato dei simboli"),
    # EMA 9/21
    ("incrocio sulla barra APERTA", "for(int x=(da<1 ? 1 : da);x<rates_total-1;x++)", "for(int x=(da<1 ? 1 : da);x<rates_total;x++)"),
    ("freccia sulla barra in formazione non pulita", "   bIncSu[rates_total-1]=EMPTY_VALUE; bIncGiu[rates_total-1]=EMPTY_VALUE;\n", ""),
    ("incrocio col segno invertito", "if(f[x]>sl[x] && f[x-1]<=sl[x-1]) return(1);", "if(f[x]>sl[x] && f[x-1]<=sl[x-1]) return(-1);"),
    ("periodi EMA scambiati", "PG_EMA(close,rates_total,da,InpEmaVeloce,bEmaV);", "PG_EMA(close,rates_total,da,InpEmaLenta,bEmaV);"),
    ("EMA scambiate nell'incrocio", "int r=PD_Incrocio(bEmaV,bEmaL,x,primo);", "int r=PD_Incrocio(bEmaL,bEmaV,x,primo);"),
    ("incrocio senza riscaldamento", "   if(x<1 || x<primo) return(0);", "   if(x<1) return(0);"),
    ("incrocio con disuguaglianza stretta (salta il tocco)", "if(f[x]>sl[x] && f[x-1]<=sl[x-1])", "if(f[x]>sl[x] && f[x-1]<sl[x-1])"),
    ("EMA veloce 10 di default", "input int   InpEmaVeloce    = 9;", "input int   InpEmaVeloce    = 10;"),
    ("frecce incrocio sul lato sbagliato", "bIncSu[x]=(r>0 ? bHAl[x] : EMPTY_VALUE);", "bIncSu[x]=(r>0 ? bHAh[x] : EMPTY_VALUE);"),
    ("buffer EMA veloce/lenta scambiati", "ok=SetIndexBuffer(9, bEmaV,  INDICATOR_DATA)         && ok;\n   ok=SetIndexBuffer(10,bEmaL,",
     "ok=SetIndexBuffer(9, bEmaL,  INDICATOR_DATA)         && ok;\n   ok=SetIndexBuffer(10,bEmaV,"),
    ("colore della EMA lenta sul plot delle frecce", "PlotIndexSetInteger(6,PLOT_LINE_COLOR,InpColEmaLenta);", "PlotIndexSetInteger(7,PLOT_LINE_COLOR,InpColEmaLenta);"),
    ("tasto EMA non salva lo stato", '   GvSalva("SEMA",on ? 1.0 : 0.0);\n', ""),
    ("tasto EMA non ridisegna", '   gEma=on;\n   GvSalva("SEMA",on ? 1.0 : 0.0);\n   ApplicaPlot();', '   gEma=on;\n   GvSalva("SEMA",on ? 1.0 : 0.0);'),
    # SUPERTREND 3 LIVELLI
    ("ST livello 2 col moltiplicatore del livello 1", "InpStPeriodo,InpStMult2,kAtr,kUp2", "InpStPeriodo,InpStMult1,kAtr,kUp2"),
    ("ST linea giu del livello 3 col verso su", "bSt3Giu[x]=PG_StLinea(true,kDir3[x],kVal3[x],-1.0);", "bSt3Giu[x]=PG_StLinea(true,kDir3[x],kVal3[x],1.0);"),
    ("ST inversione contro la banda della barra stessa", "         if(c[i]>upF[i-1])\n            dir[i]=1.0;", "         if(c[i]>upF[i])\n            dir[i]=1.0;"),
    ("ST seme col verso invertito", "dir[i]=(c[i]>=mid) ? 1.0 : -1.0;", "dir[i]=(c[i]>=mid) ? -1.0 : 1.0;"),
    ("ST bande non HL2 (chiusura)", "      double mid=(h[i]+l[i])/2.0;", "      double mid=c[i];"),
    ("ST livello 3 a 3,0 di default", "input double InpStMult3   = 3.5;", "input double InpStMult3   = 3.0;"),
    ("ST periodo ATR 14 di default", "input int    InpStPeriodo = 10;", "input int    InpStPeriodo = 14;"),
    ("ST disegnato col tasto EMA", "for(int p=9;p<=14;p++)\n     {\n      PlotIndexSetInteger(p,PLOT_DRAW_TYPE,gSt ?",
     "for(int p=9;p<=14;p++)\n     {\n      PlotIndexSetInteger(p,PLOT_DRAW_TYPE,gEma ?"),
    ("ST livello 1 con la linea del livello 2", "bSt1Su[x]=PG_StLinea(true,kDir1[x],kVal1[x],1.0);", "bSt1Su[x]=PG_StLinea(true,kDir2[x],kVal2[x],1.0);"),
    ("ST: buffer di calcolo come buffer disegnato", "ok=SetIndexBuffer(19,kAtr,   INDICATOR_CALCULATIONS) && ok;", "ok=SetIndexBuffer(19,kAtr,   INDICATOR_DATA) && ok;"),
]


def mutanti(raw, sers, ea_src):
    src = raw.decode("ascii")
    base = tempfile.mkdtemp(prefix="pte_dash_mutanti_")     # FUORI dal repo (classe 1159)
    assert not os.path.abspath(base).startswith(os.path.abspath(ROOT))
    presi = 0
    try:
        for k, (lab, old, new) in enumerate(MUTANTI):
            if src.count(old) != 1:
                check(False, "mutante '%s': testo non trovato una volta (%d)" % (lab, src.count(old)))
                continue
            mut = src.replace(old, new, 1)
            d = os.path.join(base, "m%02d" % k)
            os.makedirs(d)
            p = os.path.join(d, "ABTG_PTE_Dashboard_Leggera.mq5")
            with open(p, "w", encoding="ascii") as f:
                f.write(mut)
            bag, _ = suite(leggi(p), os.path.join(d, "cxx"), sers, ea_src, False, True)
            if check(len(bag) > 0, "MUTANTE CIECO PRESO: %s (%d controlli falliti, es. %s)" % (lab, len(bag), (bag[0][:90] if bag else "-"))):
                presi += 1
    finally:
        shutil.rmtree(base, ignore_errors=True)
    return presi, len(MUTANTI)


def main():
    print("== Collaudo strato 1 ABTG_PTE_Dashboard_Leggera.mq5 (NON prova compilazione MQL5, aspetto grafico, terminale, originale) ==")
    raw = leggi(SRC)
    ea_src = leggi(EA).decode("latin-1")
    print("== S + R) STATICO e RACCORDO ==")
    bag = []
    statico(raw, bag, ea_src)
    check(not bag, "controlli statici e di raccordo sul sorgente vero (%d difetti) %s" % (len(bag), bag[:8]))
    print("== P + N) funzioni pure in C++ e numeri sull'oro (HistData +6 h, NON BCM) ==")
    sers = {"H1": serie_tf(60, 2024), "H4": serie_tf(240, 2022), "D1": serie_tf(1440, 2021)}
    for k, s in sers.items():
        if not check(s is not None and len(s[4]) > 1000, "barre %s dell'oro: %d" % (k, len(s[4]) if s else 0)):
            sys.exit(1)
    with tempfile.TemporaryDirectory() as tmp:
        bag, tenuti = suite(raw, os.path.join(tmp, "vero"), sers, ea_src, True, False)
        check(not bag, "suite completa sul sorgente vero (%d difetti) %s" % (len(bag), bag[:8]))
        if tenuti:
            informativo(tenuti, sers)
            informativo_ha(sers)
    if not SENZA_MUTANTI:
        print("== M) MUTANTI CIECHI (copia in cartella temporanea FUORI dal repo; suite ridotta: H4 2025-2026) ==")
        sers_m = {"H4": serie_tf(240, 2025)}
        presi, tot = mutanti(raw, sers_m, ea_src)
        check(presi == tot, "mutanti presi %d su %d" % (presi, tot))
    print()
    if FAILS:
        print("ESITO: %d CONTROLLI FALLITI" % len(FAILS))
        for f in FAILS:
            print("  - " + f)
        sys.exit(1)
    print("ESITO: TUTTO OK (strato 1: statico, raccordo, funzioni pure, numeri sull'oro HistData, mutanti). NON prova: "
          "compilazione MQL5, aspetto grafico, terminale (SeriesInfoInteger/CopyRates/oggetti), feed BCM, "
          "equivalenza con la dashboard originale.")


if __name__ == "__main__":
    main()
