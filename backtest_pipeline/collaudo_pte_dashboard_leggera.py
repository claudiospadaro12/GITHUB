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
     default degli input == specifica (37 simboli nelle 5 liste dell'originale, H1/H4/D1 accesi, canale
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
}
KEYW = {"if", "for", "while", "switch", "return", "sizeof", "else"}
VIETATI = ["OrderSend", "CTrade", "Trade.mqh", "PositionOpen", "WebRequest", "Socket", "SendMail",
           "SendNotification", "SendFTP", "FileOpen", "FileWrite", "#import", ".dll", "GlobalVariableSet",
           "ChartSetSymbolPeriod", "iCustom", "iATR", "iMA(", "CopyBuffer", "ExpertRemove", "ShellExecute",
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
                          ("if(lb==gUltBarra[k]){gProssimo[k]=ora+InpRicontrolloSec;return(false);}", "barra nuova (cache)"),
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
    # ChartRedraw: solo nel timer sotto gRidisegna, e in OnDeinit
    if code.count("ChartRedraw(") != 2:
        bag.append("ChartRedraw deve comparire 2 volte (timer condizionato + OnDeinit), trovate %d" % code.count("ChartRedraw("))
    ot = norm(corpo(code, "OnTimer") or "")
    if "if(gRidisegna){gRidisegna=false;ChartRedraw(0);}" not in ot:
        bag.append("RACCORDO: ChartRedraw del timer non condizionato a gRidisegna")
    if "while(viste<tot&&fatte<InpCellePerCiclo)" not in ot or "if(Elabora(k,ora))fatte++;" not in ot:
        bag.append("RACCORDO: il timer non limita le copie per ciclo a InpCellePerCiclo")
    od = norm(corpo(code, "OnDeinit") or "")
    if "EventKillTimer();" not in od or "if(gProprietario)ObjectsDeleteAll(0,PD_PREF);" not in od:
        bag.append("RACCORDO: OnDeinit non spegne il timer o non cancella gli oggetti PDL_")
    oi = norm(corpo(code, "OnInit") or "")
    if "EventSetTimer(1);" not in oi:
        bag.append("RACCORDO: timer non a 1 s in OnInit")
    for c_, v_ in PAR_DA_INPUT.items():
        if "gPar.%s=%s;" % (c_, v_) not in oi:
            bag.append("RACCORDO: gPar.%s non e' %s in OnInit" % (c_, v_))
    oc = norm(corpo(code, "OnCalculate") or "")
    if not oc.endswith("{return(rates_total);}"):
        bag.append("OnCalculate deve essere vuoto (return(rates_total))")
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
    if st.count("Rett(") != 3 or st.count("Etic(") != 5:
        bag.append("Struttura: %d Rett e %d Etic (attesi 3 e 5 -> 3+2*nTF+nS*(1+2*nTF) oggetti)" % (st.count("Rett("), st.count("Etic(")))
    if "3+2*gNT+gNS*(1+2*gNT)" not in norm(code):
        bag.append("conteggio oggetti stampato diverso dalla formula")
    if "254 oggetti" not in src:
        bag.append("la testata non dichiara 254 oggetti coi default (3+2*3+35*7)")
    du = norm(corpo(code, "DurataBarra") or "")
    if "if(tf==PERIOD_MN1)return(28*86400);returnPeriodSeconds(tf);".replace("returnPeriodSeconds(tf)", "return(PeriodSeconds(tf))") not in du:
        bag.append("DurataBarra: MN deve usare il mese piu' corto (28 giorni)")


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
    out = re.sub(r"(const\s+)?(double|int|datetime)\s*&\s*(\w+)\[\]",
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
    ("ricerca dalla barra piu' vecchia", "for(int s=1;s<=barre;s++)", "for(int s=barre;s>=1;s--)"),
    ("HA come l'EA con il seme sbagliato", "double haO_prev=(o[shift+2]+c[shift+2])/2.0;", "double haO_prev=(o[shift+1]+c[shift+1])/2.0;"),
    ("giorno della settimana sfasato", "(int)((g+4)%7)*3", "(int)((g+3)%7)*3"),
    ("barre minime senza l'ATR lento", "   b=PD_MaxI(b,s+p.atrS+1);\n", ""),
    ("cache della barra tolta", "   if(lb==gUltBarra[k]){ gProssimo[k]=ora+InpRicontrolloSec; return(false); }   // nessuna barra nuova: niente copia\n", ""),
    ("ChartRedraw a ogni ciclo", "   if(gRidisegna)\n     {\n      gRidisegna=false;\n      ChartRedraw(0);\n     }",
     "   gRidisegna=false;\n   ChartRedraw(0);"),
    ("timer non spento", "   EventKillTimer();\n", ""),
    ("oggetti non cancellati", "   if(gProprietario) ObjectsDeleteAll(0,PD_PREF);\n   ChartRedraw(0);", "   ChartRedraw(0);"),
    ("H4 spento di default", "input bool InpH4  = true;", "input bool InpH4  = false;"),
    ("canale veloce di default", "input ENUM_PD_CANALE InpCanale          = PD_CH_UNO;", "input ENUM_PD_CANALE InpCanale          = PD_CH_VELOCE;"),
    ("lista 4 senza XAUUSD", "USDJPY,XAUUSD,USOIL\"", "USDJPY,USOIL\""),
    ("include di trading", "#property indicator_plots   0\n", "#property indicator_plots   0\n#include <Trade/Trade.mqh>\n"),
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
