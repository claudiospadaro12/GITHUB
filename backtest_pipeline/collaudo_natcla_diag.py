#!/usr/bin/env python3
# -*- coding: ascii -*-
"""
collaudo_natcla_diag.py -- collaudo STRATO 1 della diagnosi del KO U30USD del pilota F0 di 'Ea Nat&Cla' (07/10/2026):
  mql5/Experts/EA_NatCla_Diag.mq5            (EA diagnostico di SOLA LETTURA)
  backtest_pipeline/righe/NATCLA_DIAG_U30.ps1 (driver: 4 passate singole sul PC di backtest)
  backtest_pipeline/righe/RIGA_LANCIA_NATCLA_DIAG_U30.txt (riga di lancio, generata qui con --genera-riga)

Qui NON c'e' MetaEditor ne' MT5: niente compila l'MQL5, niente gira nel tester. Si prova a tavolino quello che si puo',
e si dice cosa resta fuori.

  S) STATICO sull'EA diagnostico: ASCII; parentesi bilanciate; marcatori dei blocchi una volta; OGNI funzione chiamata e'
     nella lista delle firme note (argomenti contati); NESSUNA funzione d'ordine, di file, di rete, nessun #include/#import;
     guardia 'solo tester' in OnInit PRIMA degli handle; il blocco degli handle e' a TESTO uguale a EA_NatCla OnInit
     (r.1199-1209) e cosi' la condizione INVALID_HANDLE; NC_BARRE/NC_BARRE_MIN uguali all'EA; test di nuova barra di
     OnTick uguale all'EA; risoluzione del TF; default degli input condivisi uguali all'EA; handle inizializzati e TUTTI
     rilasciati; UNA sola Print con '[NatCla-DIAG] ' ed e' in OnDeinit; le chiavi della riga RIASSUNTO (in ordine) ==
     $CHIAVI del driver; righe EV limitate da InpMaxEventi. Driver: input della .ini == file prova F0 (r.157-161,176,178).
  P) BLOCCO PURO compilato in C++ (g++): casi scritti a mano col valore atteso + 20000 casi casuali contro un
     riferimento Python scritto dalle QUATTRO condizioni di CaricaDati.
  C) LA CATENA: il corpo VERO di CaricaDati() estratto da EA_NatCla.mq5 e NCD_Catena/NCD_Completa estratte dall'EA
     diagnostico, compilati in C++ in DUE eseguibili separati (ognuno con le SUE costanti) contro gli STESSI stub che
     registrano ogni chiamata (Bars, BarsCalculated, CopyRates, CopyBuffer, ArraySetAsSeries) con gli argomenti:
     su ~6000 scenari (bordi + casuali) la sequenza di chiamate della catena == quella dell'EA, il risultato == quello
     dell'EA, i valori e i codici d'errore registrati == quelli restituiti; NCD_Completa fa SOLO le chiamate mancanti.
     Contro-esempio: un EA con l'ordine dei BarsCalculated scambiato DEVE essere preso.
  B) BANCO pwsh del driver (finto disco C:, server HTTP locale al pin, terminale/MetaEditor finti): verde (4 passate,
     .ini lette dal finto terminale, zip), guardie, compilazione (fallita, errori con .ex5, .ex5 vecchio bloccato, log in
     italiano), difetti per passata, doppioni di log, log vecchi esclusi, timeout, tetto, Desktop rinominato.
  M) MUTANTI CIECHI su COPIE fuori dal repo (classe 1159): dell'EA (S+P+C devono fallire) e del driver (lo scenario
     mirato deve diventare rosso). Un mutante che passa = buco del collaudo.
  R) RIGA (solo con --pin PIN, working tree == pin): una riga fisica ASCII, impronte dal commit, bersaglio per nome,
     eseguita nel banco con Invoke-Expression (verde, impronta diversa, marcatore assente, VPS, MT5 aperto, EA diverso).

Uso:   python3 -I backtest_pipeline/collaudo_natcla_diag.py [--senza-mutanti] [--rapido] [--pin PIN40]
       python3 -I backtest_pipeline/collaudo_natcla_diag.py --genera-riga PIN40 [--dest FILE] [--senza-origin]
Esce con 0 solo se tutto passa.
NON prova: compilazione MQL5 vera, il comportamento del tester MT5 (calcolo pigro degli indicatori, storia precaricata,
log veri dell'EA diagnostico), Windows PowerShell 5.1 (qui pwsh 7), il ramo AbandonedMutexException.
"""
import hashlib
import http.server
import json
import os
import random
import re
import shutil
import subprocess
import sys
import tempfile
import threading
import time
import zipfile

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
F_DIAG = "mql5/Experts/EA_NatCla_Diag.mq5"
F_EA = "mql5/Experts/EA_NatCla.mq5"
F_PS1 = "backtest_pipeline/righe/NATCLA_DIAG_U30.ps1"
F_PROVA = "backtest_pipeline/prove/NATCLA_F0_conteggio_2026-10-07.txt"
F_RIGA = "backtest_pipeline/righe/RIGA_LANCIA_NATCLA_DIAG_U30.txt"
RAW = "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/"
MARC = "MARCATORE_NATCLA_DIAG_U30_v1"
TERM = "C:\\Program Files\\BCM Markets MT5 Terminal"
ARGV = sys.argv[1:]
RAPIDO = "--rapido" in ARGV
SENZA_MUTANTI = "--senza-mutanti" in ARGV
ESITI = []


def chk(nome, cond, det=""):
    ESITI.append((nome, bool(cond)))
    print("  %s %s%s" % ("ok  " if cond else "FAIL", nome, ("   [" + str(det)[:400] + "]") if (det and not cond) else ""), flush=True)
    return bool(cond)


def leggi(rel):
    with open(os.path.join(ROOT, rel), "rb") as f:
        return f.read()


def sha(b):
    return hashlib.sha256(b).hexdigest().upper()


# ===========================================================================
#  utilita' sul sorgente MQL5 (stesse convenzioni di collaudo_natcla.py)
# ===========================================================================
def maschera(src, stringhe=True):
    """stessa lunghezza: commenti -> spazi, contenuto delle stringhe -> 'x' (virgolette tenute; con stringhe=False restano intatte)."""
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
        if src[i] in "\"'":
            q = src[i]
            j = i + 1
            while j < n and src[j] != q:
                j += 2 if src[j] == "\\" else 1
            if stringhe:
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


def blocco(src, nome):
    a = src.find("//@@" + nome + "_BEGIN")
    b = src.find("//@@" + nome + "_END")
    if a < 0 or b < 0 or b < a:
        return None
    return src[src.index("\n", a) + 1:b]


def nows(s):
    return re.sub(r"\s+", "", s)


def define(src, nome):
    m = re.search(r"^#define\s+" + nome + r"\s+(\S+)", src, re.M)
    return m.group(1) if m else None


def input_default(src, nome):
    m = re.search(r"^input\s+\w+\s+" + nome + r"\s*=\s*([^;]+);", src, re.M)
    return m.group(1).strip() if m else None


API = {
    "iMA": (6, 6), "iATR": (3, 3), "iADX": (3, 3), "iADXWilder": (3, 3), "iBands": (6, 6),
    "CopyBuffer": (5, 5), "CopyRates": (5, 5), "BarsCalculated": (1, 1), "IndicatorRelease": (1, 1),
    "Bars": (2, 4), "iTime": (3, 3), "Print": (1, 64), "IntegerToString": (1, 3), "TimeToString": (1, 2),
    "EnumToString": (1, 1), "StringReplace": (3, 3), "ResetLastError": (0, 0), "GetLastError": (0, 0),
    "ArraySetAsSeries": (2, 2), "MQLInfoInteger": (1, 1), "PeriodSeconds": (0, 1), "SeriesInfoInteger": (3, 3),
    "TerminalInfoInteger": (1, 1),
}
KEYW = {"if", "for", "while", "switch", "return", "sizeof", "else"}
VIETATI = ["OrderSend", "OrderSendAsync", "OrderCheck", "OrderCalcMargin", "PositionOpen", "PositionClose", "PositionModify",
           "CTrade", "Trade", "FileOpen", "FileWrite", "FileWriteString", "FileDelete", "FileMove", "FileCopy", "WebRequest",
           "SocketCreate", "SocketConnect", "SendFTP", "SendMail", "SendNotification", "GlobalVariableSet", "GlobalVariableDel",
           "TerminalClose", "ExpertRemove", "ChartApplyTemplate", "ChartSetSymbolPeriod", "FrameAdd", "ShellExecute"]
CONDIVISI = ["InpEmaLentaPeriodo", "InpEmaTp1", "InpEmaTp2", "InpLogContesto", "InpAtrNormPeriodo", "InpAdxPeriodo", "InpAdxTipo"]


def chiavi_ea(src):
    """le chiavi della riga RIASSUNTO, nell'ordine di stampa: letterali di OnDeinit (i blocchi i0_/u_/ok_ sono le stringhe di ripiego,
       che devono avere le STESSE chiavi di Istantanea)"""
    od = corpo(src, "OnDeinit") or ""
    lits = re.findall(r'"((?:[^"\\]|\\.)*)"', od)
    keys = []
    for lt in lits:
        for k in re.findall(r"(?:^|\s)(\w+)=", lt):
            keys.append(k)
    ist = corpo(src, "Istantanea") or ""
    ik = []
    for lt in re.findall(r'"((?:[^"\\]|\\.)*)"', ist):
        ik += re.findall(r"^(\w+)=", lt)
    oss = corpo(src, "Osserva") or ""
    pref = re.findall(r'\bg(?:I0|U|Ok)=Istantanea\("(\w*)"\)', oss)
    return keys, ik, pref


def chiavi_ps1(t):
    m = re.search(r"^\$CHIAVI = @\(([^)]*)\)", t, re.M)
    return re.findall(r"'(\w+)'", m.group(1)) if m else []


def statico(diag, ea, ps1, prova, bag):
    try:
        src = diag.decode("ascii")
    except UnicodeDecodeError as ex:
        bag.append("EA diagnostico non ASCII puro: %s" % ex)
        src = diag.decode("latin-1")
    esrc = ea.decode("ascii", "replace")
    code = maschera(src)
    for a, b in ("()", "[]", "{}"):
        if code.count(a) != code.count(b):
            bag.append("parentesi %s%s sbilanciate" % (a, b))
    for nm in ("NCD_PURE", "NCD_CATENA", "NCD_HANDLE"):
        if src.count("//@@" + nm + "_BEGIN") != 1 or src.count("//@@" + nm + "_END") != 1:
            bag.append("marcatori %s non presenti una volta" % nm)
    if "#include" in src or "#import" in src or ".dll" in src.lower():
        bag.append("#include/#import/dll nel sorgente diagnostico")
    for v in VIETATI:
        if re.search(r"\b" + v + r"\b", code):
            bag.append("parola vietata (ordini/file/rete): %s" % v)
    definite = set(re.findall(r"^[ \t]*(?:const\s+)?(?:int|double|bool|void|string|datetime|long|ulong|uint)\s+(\w+)\s*\(", code, re.M))
    macro = set(re.findall(r"^#define\s+(\w+)", code, re.M))
    for m in re.finditer(r"(?<![\w.])([A-Za-z_]\w*)\s*\(", code):
        nome = m.group(1)
        if nome in KEYW or nome in definite or nome in macro:
            continue
        if nome not in API:
            bag.append("funzione non nella lista delle firme note: %s (r.%d)" % (nome, code.count("\n", 0, m.start()) + 1))
            continue
        i = m.end() - 1
        na = len(argomenti(code, i, chiusa(code, i)))
        lo, hi = API[nome]
        if not (lo <= na <= hi):
            bag.append("%s chiamata con %d argomenti (attesi %d-%d)" % (nome, na, lo, hi))
    if re.search(r"\b\w+\.(?!open\b|high\b|low\b|close\b|time\b)[a-z]\w*\s*\(", code):
        bag.append("chiamata di metodo su un oggetto")
    # costanti di CaricaDati
    for nm in ("NC_BARRE", "NC_BARRE_MIN"):
        if define(src, nm) is None or define(src, nm) != define(esrc, nm):
            bag.append("%s diverso dall'EA (%s contro %s)" % (nm, define(src, nm), define(esrc, nm)))
    # blocco handle a testo uguale
    hb = blocco(src, "NCD_HANDLE") or ""
    ea_oi = corpo(esrc, "OnInit") or ""
    a = ea_oi.find("hEma200=iMA(")
    b = ea_oi.find("if(hEma200==INVALID_HANDLE")
    if a < 0 or b < 0 or nows(hb) != nows(ea_oi[a:b]):
        bag.append("blocco degli handle DIVERSO da EA_NatCla OnInit")
    di_oi = corpo(src, "OnInit") or ""
    cE = re.search(r"if\((hEma200==INVALID_HANDLE.*?)\)\s*\{", ea_oi, re.S)
    cD = re.search(r"if\((hEma200==INVALID_HANDLE.*?)\)\s*\{", di_oi, re.S)
    if not cE or not cD or nows(cE.group(1)) != nows(cD.group(1)):
        bag.append("condizione INVALID_HANDLE diversa dall'EA")
    # guardia solo tester PRIMA degli handle
    g = di_oi.find("if(!MQLInfoInteger(MQL_TESTER))")
    if g < 0 or di_oi.find("return(INIT_FAILED)", g) < 0 or di_oi.find("return(INIT_FAILED)", g) > di_oi.find("hEma200=iMA(") or di_oi.find("hEma200=iMA(") < g:
        bag.append("guardia 'solo tester' assente o dopo gli handle")
    # TF
    if "gTF=InpTF;" not in nows(di_oi) or "if(InpTF==PERIOD_CURRENT)gTF=PERIOD_H1;" not in nows(di_oi) or "if(PeriodSeconds(gTF)<PeriodSeconds(PERIOD_H1))" not in nows(di_oi):
        bag.append("risoluzione del TF diversa da EA_NatCla (CURRENT -> H1, sotto H1 rifiutato)")
    # nuova barra
    ea_ot = nows(corpo(esrc, "OnTick") or "")
    di_ot = nows(corpo(src, "OnTick") or "")
    for frag in ("datetimet0=iTime(_Symbol,gTF,0);", "if(t0==0||t0==gUltimaBarra)return;", "gUltimaBarra=t0;"):
        if frag not in ea_ot or frag not in di_ot:
            bag.append("test di nuova barra diverso da EA_NatCla OnTick: %s" % frag)
    # default degli input condivisi
    for nm in CONDIVISI:
        if input_default(src, nm) is None or input_default(src, nm) != input_default(esrc, nm):
            bag.append("default di %s diverso dall'EA (%s contro %s)" % (nm, input_default(src, nm), input_default(esrc, nm)))
    me = re.search(r"enum ENUM_NC_ADXTIPO\s*\{(.*?)\};", esrc, re.S)
    md = re.search(r"enum ENUM_NC_ADXTIPO\s*\{(.*?)\};", src, re.S)
    if not me or not md or re.findall(r"(NC_ADX_\w+)=(\d+)", me.group(1)) != re.findall(r"(NC_ADX_\w+)=(\d+)", md.group(1)):
        bag.append("enum ENUM_NC_ADXTIPO diverso dall'EA")
    # handle inizializzati e rilasciati
    hdecl = set(re.findall(r"\b(h\w+)\s*=\s*INVALID_HANDLE", code))
    hcrea = set(re.findall(r"\b(h\w+)\s*=\s*i(?:MA|ATR|ADX|ADXWilder|Bands)\s*\(", code))
    od = corpo(code, "OnDeinit") or ""
    rel = re.search(r"int\s+hs\s*\[\s*\d+\s*\]\s*=\s*\{([^}]*)\}", od)
    rilasciati = set(x.strip() for x in rel.group(1).split(",")) if rel else set()
    if "IndicatorRelease(hs[i])" not in nows(od):
        bag.append("OnDeinit non rilascia la lista hs[]")
    if len(hcrea) != 8:
        bag.append("handle creati %d invece di 8" % len(hcrea))
    for h in hcrea:
        if h not in hdecl:
            bag.append("handle %s non inizializzato a INVALID_HANDLE" % h)
        if h not in rilasciati:
            bag.append("handle %s non rilasciato" % h)
    # una sola riga [NatCla-DIAG] , in OnDeinit; EV limitate
    tag = maschera(src, stringhe=False).count('"[NatCla-DIAG] ')
    od_raw = corpo(src, "OnDeinit") or ""
    if tag != 1 or od_raw.count('"[NatCla-DIAG] RIASSUNTO ') != 1 or od_raw.count("Print(s);") != 1:
        bag.append("la riga '[NatCla-DIAG] ' deve esistere UNA volta, in OnDeinit (trovate %d)" % tag)
    if re.search(r'"\[NatCla-DIAG\]', maschera(src, stringhe=False).replace('"[NatCla-DIAG] RIASSUNTO ', "", 1)):
        bag.append("altra stringa con il tag esatto [NatCla-DIAG]")
    if 'fine=1"' not in od_raw.replace(" ", "") and '" fine=1"' not in od_raw:
        bag.append("la riga RIASSUNTO non chiude con fine=1")
    oss = corpo(src, "Osserva") or ""
    pe = oss.find('Print("[NatCla-DIAG-EV]')
    if pe < 0 or oss.rfind("if(gEventi<InpMaxEventi)", 0, pe) < 0:
        bag.append("righe EV non limitate da InpMaxEventi")
    # chiavi
    keys, ik, pref = chiavi_ea(src)
    attese = []
    for p in ("i0_", "u_", "ok_"):
        attese += [p + k for k in ik]
    fall = [k for k in keys if re.match(r"^(i0_|u_|ok_)(barre|n|bc|cr|cb)$", k)]
    if sorted(pref) != sorted(["i0_", "u_", "ok_"]) or fall != attese:
        bag.append("chiavi delle istantanee incoerenti: prefissi %s, ripiego %s, attese %s" % (pref, fall, attese))
    ck = chiavi_ps1(ps1.decode("ascii", "replace"))
    if keys != ck or len(set(keys)) != len(keys):
        bag.append("chiavi del RIASSUNTO (EA) != $CHIAVI del driver: %s" % [x for x in keys if x not in ck] + str([x for x in ck if x not in keys]))
    # driver: input della .ini == file prova F0
    t = ps1.decode("ascii", "replace")
    mi = re.search(r"^\$Ingressi = @\(([^)]*)\)", t, re.M)
    ing = re.findall(r"'([^']*)'", mi.group(1)) if mi else []
    pv = dict(re.findall(r"^(Inp\w+)=(\S+)$", prova.decode("ascii", "replace"), re.M))
    for nm in CONDIVISI + ["InpTF"]:
        if ("%s=%s" % (nm, pv.get(nm))) not in ing:
            bag.append("input %s della .ini diverso dal file prova F0 (%s)" % (nm, pv.get(nm)))
    if "InpVerificheSeparate=true" not in ing:
        bag.append("la .ini non chiede le verifiche separate")
    for nm in [x.split("=")[0] for x in ing]:
        if input_default(src, nm) is None:
            bag.append("la .ini passa %s che l'EA diagnostico non ha" % nm)
    if "[Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12" not in t:
        bag.append("TLS 1.2 non impostato nel figlio (classe 1156)")
    if t.splitlines()[1] != "#  " + MARC:
        bag.append("marcatore del driver non alla riga 2")
    return src


# ===========================================================================
#  P) e C): C++
# ===========================================================================
STUB = r'''
#include <cstdio>
#include <string>
#include <vector>
#include <stdexcept>
typedef long long datetime;
typedef std::string string;
typedef int ENUM_TIMEFRAMES;
struct MqlRates { datetime time; double open,high,low,close; long long tick_volume; int spread; long long real_volume; };
template<class T> struct Arr { std::vector<T> v; T& operator[](int i){ return v.at((size_t)i); } };
template<class T> int ArrayResize(Arr<T>&a,int n){ a.v.resize(n<0?0:(size_t)n); return n; }
static std::string LOGS; static int LASTERR=0;
static int S_BARRE=0, S_BC[3], S_CR=0, S_CB[3];
static string _Symbol="SIM";
static int gTF=16385;
static int hEma200=10, hAtrN=11, hAdx=12, hEma14=13, hEma89=14, hEma9=15, hEma21=16, hBands=17;
static Arr<double> gEma, gAtrN, gAdx;
static int hidx(int h){ if(h==hEma200) return 0; if(h==hAtrN) return 1; if(h==hAdx) return 2; throw std::runtime_error("handle inatteso"); }
static std::string nomeArr(Arr<double>&a){ if(&a==&gEma) return "gEma"; if(&a==&gAtrN) return "gAtrN"; if(&a==&gAdx) return "gAdx"; return "loc"; }
static std::string I(long long x){ return std::to_string(x); }
static bool ArraySetAsSeries(Arr<double>&a,bool f){ LOGS+="AS("+nomeArr(a)+","+I(f)+");"; return true; }
static bool ArraySetAsSeries(Arr<MqlRates>&a,bool f){ (void)a; LOGS+="AS(rates,"+I(f)+");"; return true; }
static int Bars(const string &s,int tf){ LOGS+="Bars("+s+","+I(tf)+");"; return S_BARRE; }
static int BarsCalculated(int h){ LOGS+="BC("+I(h)+");"; int v=S_BC[hidx(h)]; if(v<0) LASTERR=4806; return v; }
static int CopyRates(const string &s,int tf,int st,int cnt,Arr<MqlRates>&r){ LOGS+="CR("+s+","+I(tf)+","+I(st)+","+I(cnt)+");"; int v=S_CR; r.v.assign(v>0?(size_t)v:0,MqlRates()); if(v!=cnt) LASTERR=4401; return v; }
static int CopyBuffer(int h,int buf,int st,int cnt,Arr<double>&a){ LOGS+="CB("+I(h)+","+I(buf)+","+I(st)+","+I(cnt)+","+nomeArr(a)+");"; int k=hidx(h); int v=S_CB[k]; a.v.assign(v>0?(size_t)v:0,0.0); if(v!=cnt) LASTERR=4900+k; return v; }
static void ResetLastError(){ LASTERR=0; }
static int GetLastError(){ return LASTERR; }
static bool leggi(){ return scanf("%d %d %d %d %d %d %d %d",&S_BARRE,&S_BC[0],&S_BC[1],&S_BC[2],&S_CR,&S_CB[0],&S_CB[1],&S_CB[2])==8; }
'''

MAIN_EA = r'''
static Arr<double> gO,gH,gL,gC,gLV,gLD,gWa,gWu,gWd; static Arr<datetime> gT; static int gN=0;
%(defs)s
%(body)s
int main(){ while(leggi()){ LOGS.clear(); LASTERR=777; bool ok=false; try{ ok=CaricaDati(); }catch(std::exception &e){ printf("EXC %%s\n",e.what()); continue; }
  printf("%%d %%s\n",ok?1:0,LOGS.c_str()); } return 0; }
'''

MAIN_DIAG = r'''
static int gcBarre, gcN, gcCr, gcCrErr; static int gcBc[3], gcCb[3], gcCbErr[3];
%(pure)s
%(catena)s
static void stato(){ printf("|%%d %%d %%d %%d %%d %%d %%d %%d %%d %%d %%d %%d %%d|",gcBarre,gcN,gcBc[0],gcBc[1],gcBc[2],gcCr,gcCrErr,gcCb[0],gcCbErr[0],gcCb[1],gcCbErr[1],gcCb[2],gcCbErr[2]); }
int main(){ char cmd[16];
 while(scanf("%%15s",cmd)==1){ std::string c(cmd);
  if(c=="CAT"){ if(!leggi()) return 2; LOGS.clear(); LASTERR=777; int m=-1; try{ m=NCD_Catena(); }catch(std::exception &e){ printf("EXC %%s\n",e.what()); continue; }
    printf("%%d %%s",m,LOGS.c_str()); stato(); LOGS.clear(); try{ NCD_Completa(); }catch(std::exception &e){ printf("EXC %%s\n",e.what()); continue; } printf("%%s",LOGS.c_str()); stato(); printf("\n"); }
  else if(c=="FIN"){ int b; if(scanf("%%d",&b)!=1) return 2; printf("%%d\n",NCD_Finestra(b)); }
  else if(c=="PM"){ int a[8]; for(int i=0;i<8;i++) if(scanf("%%d",&a[i])!=1) return 2; printf("%%d\n",NCD_PrimoMotivo(a[0],a[1],a[2],a[3],a[4],a[5],a[6],a[7])); }
  else if(c=="BC"){ int n,b; if(scanf("%%d %%d",&n,&b)!=2) return 2; printf("%%d\n",NCD_CadeBC(n,b)?1:0); }
  else if(c=="CP"){ int n,g; if(scanf("%%d %%d",&n,&g)!=2) return 2; printf("%%d\n",NCD_CadeCopia(n,g)?1:0); }
  else return 3; }
 return 0; }
'''


def to_cxx(t):
    t = re.sub(r"\bMqlRates\s+(\w+)\[\]\s*;", r"Arr<MqlRates> \1;", t)
    t = re.sub(r"\bdouble\s+(\w+)\[\]\s*;", r"Arr<double> \1;", t)
    return t


def compila(testo, tmp, nome):
    cxx = shutil.which("g++") or shutil.which("clang++")
    if not cxx:
        return None, "g++ assente"
    p = os.path.join(tmp, nome + ".cpp")
    open(p, "w").write(testo)
    exe = os.path.join(tmp, nome)
    r = subprocess.run([cxx, "-std=c++17", "-O0", "-Wall", "-o", exe, p], capture_output=True, text=True)
    return (exe if r.returncode == 0 else None), r.stderr


def esegui(exe, inp):
    r = subprocess.run([exe], input=inp, capture_output=True, text=True, timeout=300)
    return r.stdout.splitlines()


def rif(barre, bc, cr, cb):
    """riferimento Python, scritto dalle QUATTRO condizioni di CaricaDati (r.1264-1276), NON dal codice diagnostico"""
    n = barre - 2 if barre - 2 < 1500 else 1500
    if n < 300:
        return 1, n
    if bc[0] < n + 1 or bc[1] < n + 1 or bc[2] < n + 1:
        return 2, n
    if cr != n:
        return 3, n
    if cb[0] != n or cb[1] != n or cb[2] != n:
        return 4, n
    return 0, n


def scenari(seed=7, ncas=5000):
    rnd = random.Random(seed)
    out = []
    bordi = [0, 1, 2, 3, 50, 301, 302, 303, 1000, 1501, 1502, 1503, 1504, 9946]
    for b in bordi:
        n = b - 2 if b - 2 < 1500 else 1500
        for bcv in ([n + 1] * 3, [n] * 3, [-1, n + 1, n + 1], [n + 1, -1, n + 1], [n + 1, n + 1, n], [n + 5, n + 1, n + 9]):
            for crv in (n, n - 1, -1, 0):
                for cbv in ([n] * 3, [-1, n, n], [n, n - 1, n], [n, n, -1], [n + 1, n, n]):
                    out.append((b, bcv[0], bcv[1], bcv[2], crv, cbv[0], cbv[1], cbv[2]))
    for _ in range(ncas):
        b = rnd.choice([rnd.randint(-3, 400), rnd.randint(290, 320), rnd.randint(1490, 1510), rnd.randint(0, 20000)])
        n = b - 2 if b - 2 < 1500 else 1500
        def v(ok):
            return rnd.choice([ok, ok, ok, ok - 1, ok + 1, -1, 0, rnd.randint(-2, 3000)])
        out.append((b, v(n + 1), v(n + 1), v(n + 1), v(n), v(n), v(n), v(n)))
    return out


def prova_catena(diag_src, ea_src, tmp, bag, ncas=5000):
    """P + C: ritorna True se tutto torna. I difetti finiscono in bag."""
    pure = blocco(diag_src, "NCD_PURE")
    cat = blocco(diag_src, "NCD_CATENA")
    body = corpo(ea_src, "CaricaDati")
    if pure is None or cat is None or body is None:
        bag.append("blocchi NCD_PURE/NCD_CATENA o CaricaDati non estraibili")
        return False
    defs = "\n".join(l for l in ea_src.splitlines() if re.match(r"^#define\s+NC_BARRE(_MIN)?\s", l))
    exe_ea, err1 = compila(STUB + MAIN_EA % dict(defs=defs, body=to_cxx(body)), tmp, "ea")
    exe_dg, err2 = compila(STUB + MAIN_DIAG % dict(pure=pure, catena=to_cxx(cat)), tmp, "diag")
    if exe_ea is None or exe_dg is None:
        bag.append("compilazione C++ fallita: %s %s" % (err1[-400:] if exe_ea is None else "", err2[-400:] if exe_dg is None else ""))
        return False
    # P) casi a mano
    casi = [("FIN 0", -2), ("FIN 301", 299), ("FIN 302", 300), ("FIN 1502", 1500), ("FIN 1503", 1500), ("FIN 99999", 1500),
            ("PM 299 999 999 999 299 299 299 299", 1), ("PM 300 300 301 301 300 300 300 300", 2), ("PM 300 301 301 300 300 300 300 300", 2),
            ("PM 300 301 301 301 299 300 300 300", 3), ("PM 300 301 301 301 -1 -1 -1 -1", 3), ("PM 300 301 301 301 300 300 300 -1", 4),
            ("PM 300 301 301 301 300 301 300 300", 4), ("PM 300 301 301 301 300 300 300 300", 0), ("PM 1500 1501 1501 1501 1500 1500 1500 1500", 0),
            ("PM 1500 -1 -1 -1 -1 -1 -1 -1", 2), ("BC 300 301", 0), ("BC 300 300", 1), ("BC 0 0", 1), ("BC 0 1", 0), ("CP 300 300", 0), ("CP 300 -1", 1), ("CP 300 301", 1)]
    out = esegui(exe_dg, "\n".join(c for c, _ in casi) + "\n")
    for (c, att), got in zip(casi, out + [""] * len(casi)):
        if got.strip() != str(att):
            bag.append("puro: %s -> %s invece di %s" % (c, got.strip(), att))
    # P) casuali contro il riferimento
    rnd = random.Random(11)
    righe, att = [], []
    for _ in range(20000):
        n = rnd.choice([rnd.randint(-5, 400), rnd.randint(295, 305), 1500])
        vals = [rnd.choice([n + 1, n, -1, n + 2, rnd.randint(-3, 2000)]) for _ in range(3)] + [rnd.choice([n, n - 1, -1, n + 1]) for _ in range(4)]
        righe.append("PM %d %s" % (n, " ".join(map(str, vals))))
        bb = n + 2  # barre che danno questo n (n<1500)
        if n < 1500:
            att.append(rif(bb, vals[0:3], vals[3], vals[4:7])[0])
        else:
            att.append(rif(1502, vals[0:3], vals[3], vals[4:7])[0])
    out = esegui(exe_dg, "\n".join(righe) + "\n")
    diff = sum(1 for a, g in zip(att, out) if str(a) != g.strip()) + abs(len(att) - len(out))
    if diff:
        bag.append("puro: NCD_PrimoMotivo diverso dal riferimento in %d casi su 20000" % diff)
    # C) catena contro il corpo VERO di CaricaDati
    sc = scenari(ncas=ncas)
    inp = "\n".join("%d %d %d %d %d %d %d %d" % s for s in sc) + "\n"
    oe = esegui(exe_ea, inp)
    od = esegui(exe_dg, "".join("CAT %d %d %d %d %d %d %d %d\n" % s for s in sc))
    if len(oe) != len(sc) or len(od) != len(sc):
        bag.append("catena: righe %d/%d invece di %d" % (len(oe), len(od), len(sc)))
        return False
    nlog = nres = nmot = nval = ncomp = 0
    primo = ""
    for s, le, ld in zip(sc, oe, od):
        if le.startswith("EXC") or ld.startswith("EXC"):
            bag.append("catena: eccezione (indice fuori dai limiti?) su %s: %s / %s" % (s, le, ld))
            return False
        res, logE = le.split(" ", 1) if " " in le else (le, "")
        mot_log, st1, logC, st2, _ = ld.split("|")
        mot, logD = mot_log.split(" ", 1) if " " in mot_log else (mot_log, "")
        barre, bc, cr, cb = s[0], list(s[1:4]), s[4], list(s[5:8])
        m_rif, n = rif(barre, bc, cr, cb)
        if logD != logE:
            nlog += 1
            primo = primo or ("%s: EA %s | diag %s" % (s, logE, logD))
        if (res == "1") != (mot == "0"):
            nres += 1
        if int(mot) != m_rif:
            nmot += 1
        v1 = list(map(int, st1.split()))
        # valori attesi dopo la catena: solo le chiamate fatte
        NC = -999
        e = [barre, n] + [NC] * 3 + [NC, 0] + [NC, 0] * 3
        if m_rif != 1:
            for k in range(3):
                e[2 + k] = bc[k]
                if bc[k] < n + 1:
                    break
        if m_rif in (0, 3, 4):
            e[5] = cr
            e[6] = 4401 if cr != n else 0
        if m_rif in (0, 4):
            for k in range(3):
                e[7 + 2 * k] = cb[k]
                e[8 + 2 * k] = (4900 + k) if cb[k] != n else 0
                if cb[k] != n:
                    break
        if v1 != e:
            nval += 1
            primo = primo or ("valori %s: %s invece di %s" % (s, v1, e))
        # completamento: SOLO le chiamate mancanti, e copie solo con n>=1
        v2 = list(map(int, st2.split()))
        attese = []
        for k, h in enumerate((10, 11, 12)):
            if e[2 + k] == NC:
                attese.append("BC(%d);" % h)
        f = list(e)
        for k in range(3):
            f[2 + k] = bc[k]
        if n >= 1:
            if e[5] == NC:
                attese += ["AS(rates,0);", "CR(SIM,16385,1,%d);" % n]
                f[5] = cr
                f[6] = 4401 if cr != n else 0
            for k, nm in enumerate(("gEma", "gAtrN", "gAdx")):
                if e[7 + 2 * k] == NC:
                    attese.append("CB(%d,0,1,%d,%s);" % (10 + k, n, nm))
                    f[7 + 2 * k] = cb[k]
                    f[8 + 2 * k] = (4900 + k) if cb[k] != n else 0
        if logC != "".join(attese) or v2 != f:
            ncomp += 1
            primo = primo or ("completamento %s: %s / %s invece di %s / %s" % (s, logC, v2, "".join(attese), f))
    if nlog:
        bag.append("catena: sequenza di chiamate DIVERSA dall'EA in %d scenari su %d (primo: %s)" % (nlog, len(sc), primo[:300]))
    if nres:
        bag.append("catena: esito diverso da CaricaDati in %d scenari" % nres)
    if nmot:
        bag.append("catena: motivo diverso dal riferimento in %d scenari" % nmot)
    if nval:
        bag.append("catena: valori/errori registrati sbagliati in %d scenari (%s)" % (nval, primo[:300]))
    if ncomp:
        bag.append("completamento: chiamate o valori sbagliati in %d scenari (%s)" % (ncomp, primo[:300]))
    return not (nlog or nres or nmot or nval or ncomp)


# ===========================================================================
#  B) BANCO pwsh del driver
# ===========================================================================
SIM = r'''
import json, os, re, sys, time
kind = os.environ["SIM_KIND"]; scen = json.load(open(os.environ["SIM_SCEN"])); C = os.environ["SIM_CDRIVE"]; LOG = os.environ["SIM_LOG"]
os.makedirs(LOG, exist_ok=True)
def lin(p):
    p = p.strip().strip('"')
    if p.startswith(C): return p
    if re.match(r"^[A-Za-z]:", p): p = p[2:]
    return os.path.join(C, *[x for x in re.split(r"[\\/]", p) if x])
def utf16(s): return b"\xff\xfe" + s.encode("utf-16-le")
def app(p, righe):
    os.makedirs(os.path.dirname(p), exist_ok=True)
    nuovo = not os.path.exists(p)
    with open(p, "ab") as f:
        if nuovo: f.write(b"\xff\xfe")
        f.write(("\r\n".join(righe) + "\r\n").encode("utf-16-le"))
argv = json.loads(os.environ.get("SIM_ARGV_JSON", "[]"))
if kind == "editor":
    open(os.path.join(LOG, "sim_args_editor.txt"), "w").write(json.dumps(argv))
    comp = [a for a in argv if a.startswith("/compile:")]; logp = [a for a in argv if a.startswith("/log:")]
    if len(argv) == 2 and len(comp) == 1 and len(logp) == 1:
        f = lin(comp[0][len("/compile:"):])
        ok = (b"NCD_VER" in open(f, "rb").read()) and not scen.get("compile_fallisce")
        nerr = 0 if ok else 3
        if scen.get("compile_errori_con_ex5"): ok, nerr = True, 2
        w = scen.get("compile_avvisi", 0)
        if scen.get("compile_italiano"):
            righe = ["0\t2026.10.08 09:00:00.000\tCompile\t%s - %d errori, %d avvisi, 1915 ms trascorsi" % (f, nerr, w)]
        else:
            righe = ["0\t2026.10.08 09:00:00.000\tCompile\t%s - %d errors, %d warnings, 1915 ms elapsed, cpu='X64 Regular'" % (f, nerr, w)]
        for k in range(min(w, 3)):
            righe.insert(0, "1\t2026.10.08 09:00:00.000\tCompile\t%s(%d,5) : warning 43: possible loss of data due to type conversion" % (f, 100 + k))
        open(lin(logp[0][len("/log:"):]), "wb").write(utf16("\r\n".join(righe) + "\r\n"))
        if ok: open(f[:-4] + ".ex5", "wb").write(b"EX5NUOVO")
    sys.exit(0)
m = re.search(r'/config:(\S+)', os.environ.get("SIM_ARGS", ""))
ini = lin(m.group(1)) if m else ""
txt = open(ini, "rb").read().decode("ascii") if ini and os.path.exists(ini) else ""
sez = None; tester = {}; inp = {}
for l in txt.splitlines():
    l = l.strip()
    if l.startswith("["): sez = l; continue
    if "=" in l:
        k, v = l.split("=", 1)
        if sez == "[Tester]": tester[k] = v
        elif sez == "[TesterInputs]": inp[k] = v
        elif sez == "[Experts]": tester["EXP_" + k] = v
sym = tester.get("Symbol", "?"); da = tester.get("FromDate", "?"); a = tester.get("ToDate", "?")
open(os.path.join(LOG, "sim_terminale_lanci.txt"), "a").write("Expert=%s Symbol=%s Period=%s FromDate=%s ToDate=%s Model=%s Optimization=%s Live=%s Dll=%s Shutdown=%s INPUT %s\n" % (
    tester.get("Expert"), sym, tester.get("Period"), da, a, tester.get("Model"), tester.get("Optimization"), tester.get("EXP_AllowLiveTrading"), tester.get("EXP_AllowDllImport"),
    tester.get("ShutdownTerminal"), ",".join("%s=%s" % kv for kv in inp.items())))
fault = scen.get("falli", {}).get(sym + "_" + da)
ora = time.strftime("%H:%M:%S")
mk = [0]
def riga(t, sorg="EA_NatCla_Diag"):
    mk[0] += 1
    return "CS\t0\t%s.%03d\t%s (%s,H1)\t%s 00:00:00   %s" % (ora, mk[0] % 1000, sorg, sym, da, t)
chiavi = scen["chiavi"]
val = {"v": "1.00", "sym": sym, "tf": "PERIOD_H1", "adx": "NC_ADX_MT5", "sep": "1", "fine": "1", "nuove": "9946", "prima": da.replace(" ", "_") + "_01:00", "primo_ok": "mai"}
if sym == "U30USD" and da == "2024.09.26":
    val.update(cd_n="9946", cd_ok="0", max_barre="301")
else:
    val.update(cd_ok="9000", cd_n="0", primo_ok=da + "_01:00")
val.update(scen.get("valori", {}).get(sym + "_" + da, {}))
if fault == "sym": val["sym"] = "XXXUSD"
ch = [k for k in chiavi if not (fault == "chiave" and k == "cd_bc")]
rias = "[NatCla-DIAG] RIASSUNTO " + " ".join("%s=%s" % (k, val.get(k, "0")) for k in ch)
if fault == "troncato": rias = rias[:rias.rfind(" eventi=")]
ea = []
if fault == "rifiutato": ea.append(riga("[NatCla-DIAG-AVVIO] RIFIUTATO: EA_NatCla_Diag gira SOLO nello Strategy Tester"))
elif fault != "no_avvio": ea.append(riga("[NatCla-DIAG-AVVIO] v1.00 sym=%s tf=PERIOD_H1 ema=200 atr=14 adx=14/NC_ADX_MT5 contesto=si separate=si | SOLA LETTURA: nessun ordine, nessun file" % sym))
ea.append(riga("[NatCla-DIAG-EV] barra=%s_01:00 motivo=inizio->N nuove=1 barre=3 n=1 bc=nc/nc/nc cr=1/0 cb=1/0,1/0,1/0" % da))
if fault == "guasto": ea.append(riga("critical error in 'EA_NatCla_Diag.mq5': array out of range (321,12)"))
if fault != "no_rias": ea.append(riga(rias))
if fault == "doppio": ea.append(riga(rias.replace("cd_ok=", "cd_ok=1")))
agent = os.path.join(C, "Users", "Master", "AppData", "Roaming", "MetaQuotes", "Tester", "AGENT1", "Agent-127.0.0.1-3000", "logs")
app(os.path.join(agent, "20261008.log"), ea)
# il giornale del terminale: l'intestazione, le righe del tester e una COPIA delle righe dell'EA (stesso contenuto, altro prefisso): il driver deve togliere i doppioni
jd = os.path.join(C, "Users", "Master", "AppData", "Roaming", "MetaQuotes", "Terminal", "ABC123", "Tester", "logs")
gio = ["RD\t0\t%s.100\tTester\tExperts\\EA_NatCla_Diag.ex5 on %s,H1 from %s 00:00 to %s 00:00" % (ora, sym, da, a),
       "CS\t0\t%s.200\tTester\t%s,H1: 2363255 ticks, 9946 bars generated. Environment synchronized in 0:00:00.031. Test passed in 0:00:01.122." % (ora, sym)]
gio += [x.replace("CS\t0\t", "GG\t0\t", 1) for x in ea]
app(os.path.join(jd, "20261008.log"), gio)
'''

SETUP = r'''
function Invoke-RestMethod { [CmdletBinding()] param([string]$Uri, [string]$OutFile)
  $u2 = $Uri.Replace('https://raw.githubusercontent.com/claudiospadaro12/GITHUB/', $env:LOCAL_RAW)
  Microsoft.PowerShell.Utility\Invoke-RestMethod -Uri $u2 -OutFile $OutFile }
function powershell.exe { $a = @($args); $file = $null; $h = @{}
  for($i = 0; $i -lt $a.Count; $i++){ if($a[$i] -eq '-File'){ $file = $a[$i+1]; $i++; continue }
    if(("$($a[$i])").StartsWith('-') -and ($i + 1) -lt $a.Count -and $a[$i] -notin @('-NoProfile','-ExecutionPolicy')){ $h[("$($a[$i])").Substring(1)] = $a[$i+1]; $i++ } }
  & $file @h }
$PSStyle.OutputRendering = 'PlainText'; $ErrorView = 'NormalView'
New-PSDrive -Name C -PSProvider FileSystem -Root $env:CDRIVE | Out-Null
function Start-Sleep { [CmdletBinding()] param([int]$Seconds, [int]$Milliseconds)
  if($env:SLEEP_REALE -eq '1'){ Microsoft.PowerShell.Utility\Start-Sleep -Milliseconds 300 } }
if($env:EX5_BLOCCATO -eq '1'){ function Remove-Item { [CmdletBinding()] param([string]$LiteralPath, [switch]$Force)
  if($LiteralPath -notlike '*.ex5'){ Microsoft.PowerShell.Management\Remove-Item -LiteralPath $LiteralPath -Force -ErrorAction SilentlyContinue } } }
function Start-Process { [CmdletBinding()] param([string]$FilePath, [string[]]$ArgumentList, [switch]$PassThru)
  $env:SIM_ARGS = ($ArgumentList -join ' ')
  $env:SIM_ARGV_JSON = (ConvertTo-Json -InputObject @($ArgumentList) -Compress)
  $o = [pscustomobject]@{ chiuso = $false; marcatore = (Join-Path $env:SIM_LOG 'sim_closemainwindow.txt') }
  if($FilePath -like '*metaeditor64.exe'){ $env:SIM_KIND = 'editor'; & python3 $env:SIM_SCRIPT | Out-Host; $o.chiuso = $true }
  else {
    $env:SIM_KIND = 'terminal'
    Add-Content -LiteralPath (Join-Path $env:SIM_LOG 'sim_lanci_n.txt') -Value ('LANCIO ' + $FilePath)
    $nl = @(Get-Content -LiteralPath (Join-Path $env:SIM_LOG 'sim_lanci_n.txt')).Count
    & python3 $env:SIM_SCRIPT | Out-Host
    if($env:SIM_NOEXIT -ne ('' + $nl)){ $o.chiuso = $true }
  }
  Add-Member -InputObject $o -MemberType ScriptProperty -Name HasExited -Value { $this.chiuso }
  Add-Member -InputObject $o -MemberType ScriptMethod -Name CloseMainWindow -Value { if($env:SIM_NOCLOSE -ne '1'){ $this.chiuso = $true }; Set-Content -LiteralPath $this.marcatore -Value 'close'; $true }
  Add-Member -InputObject $o -MemberType ScriptMethod -Name Kill -Value { $this.chiuso = $true; Set-Content -LiteralPath (Join-Path $env:SIM_LOG 'sim_kill.txt') -Value 'kill' }
  return $o }
'''


def utf16(s):
    return b"\xff\xfe" + s.encode("utf-16-le")


class Srv:
    def __init__(self, pin, files):
        self.hits = []
        s = self

        class H(http.server.BaseHTTPRequestHandler):
            def do_GET(self):
                s.hits.append(self.path)
                p = self.path.split("?")[0].split("/", 2)
                corpo_ = s.files.get(p[2]) if len(p) == 3 and p[1] == pin else None
                if corpo_ is None:
                    self.send_response(404); self.send_header("Content-Length", "0"); self.end_headers(); return
                self.send_response(200); self.send_header("Content-Length", str(len(corpo_))); self.end_headers(); self.wfile.write(corpo_)

            def log_message(self, *a):
                pass
        self.files = files
        self.srv = http.server.ThreadingHTTPServer(("127.0.0.1", 0), H)
        self.base = "http://127.0.0.1:%d/" % self.srv.server_address[1]
        threading.Thread(target=self.srv.serve_forever, daemon=True).start()

    def chiudi(self):
        self.srv.shutdown(); self.srv.server_close()


def costruisci(d, spec):
    c = os.path.join(d, "cdrive")
    user = os.path.join(c, "Users", "Master")
    os.makedirs(os.path.join(user, "Desktop"))
    tdir = os.path.join(c, "Program Files", "BCM Markets MT5 Terminal")
    os.makedirs(tdir)
    open(os.path.join(tdir, "terminal64.exe"), "wb").write(b"x")
    open(os.path.join(tdir, "metaeditor64.exe"), "wb").write(b"x")
    ap = os.path.join(user, "AppData", "Roaming", "MetaQuotes", "Terminal")
    dati = os.path.join(ap, "ABC123")
    for sub in ("Experts", "Include", "Files", "Logs", os.path.join("Profiles", "Charts", "Default")):
        os.makedirs(os.path.join(dati, "MQL5", sub))
    open(os.path.join(dati, "MQL5", "Experts", "EA_NatCla.mq5"), "wb").write(b"// EA_NatCla vero: NON va toccato\n")
    open(os.path.join(dati, "MQL5", "Experts", "EA_NatCla.ex5"), "wb").write(b"EX5 di EA_NatCla")
    if spec.get("ex5_vecchio"):
        open(os.path.join(dati, "MQL5", "Experts", "EA_NatCla_Diag.ex5"), "wb").write(b"EX5VECCHIO")
    os.makedirs(os.path.join(ap, "Common", "Files"))
    open(os.path.join(dati, "origin.txt"), "wb").write(utf16(TERM))
    if spec.get("doppio_dati"):
        os.makedirs(os.path.join(ap, "DDD444", "MQL5"))
        open(os.path.join(ap, "DDD444", "origin.txt"), "wb").write(utf16(TERM))
    if spec.get("altra_inst"):
        os.makedirs(os.path.join(ap, "ZZZ999", "MQL5"))
        open(os.path.join(ap, "ZZZ999", "origin.txt"), "wb").write(utf16("C:\\MT5_Altro"))
    for dd, inst in (("04C7A32B575E40027B4FF8724D14D702", "C:\\MT5_Backtest"), ("2B8180C37317B90DC37E3BF8A8CBE715", "C:\\FundedNext_Manuale")):
        cc = os.path.join(ap, dd, "MQL5", "Profiles", "Charts", "Default")
        os.makedirs(cc)
        open(os.path.join(ap, dd, "origin.txt"), "wb").write(utf16(inst))
        open(os.path.join(cc, "chart01.chr"), "wb").write(utf16("<chart>\nsymbol=EURUSD\n<window>\n<expert>\nname=QUALUNQUE\n</expert>\n</window>\n</chart>\n"))
    cd = os.path.join(dati, "MQL5", "Profiles", "Charts", "Default")
    for i, ch in enumerate(spec.get("chr", [{}])):
        p = os.path.join(cd, "chart%02d.chr" % (i + 1))
        if ch.get("ea"):
            open(p, "wb").write(utf16("<chart>\nsymbol=EURUSD\n<window>\n<expert>\nname=%s\n</expert>\n</window>\n</chart>\n" % ch["ea"]))
        else:
            open(p, "wb").write(utf16("<chart>\nsymbol=EURUSD\n</chart>\n"))
    if spec.get("desktop_vecchio"):
        os.makedirs(os.path.join(user, "Desktop", "NATCLA_DIAG_U30"))
        open(os.path.join(user, "Desktop", "NATCLA_DIAG_U30", "RESIDUO.txt"), "w").write("residuo\n")
        open(os.path.join(user, "Desktop", "NATCLA_DIAG_U30.zip"), "w").write("zip vecchio\n")
    if spec.get("log_vecchio"):
        ag = os.path.join(user, "AppData", "Roaming", "MetaQuotes", "Tester", "AGENT1", "Agent-127.0.0.1-3000", "logs")
        os.makedirs(ag)
        vecchio = "CS\t0\t09:00:00.001\tEA_NatCla_Diag (U30USD,H1)\t2024.09.26 00:00:00   [NatCla-DIAG] RIASSUNTO v=0.99 sym=U30USD tf=PERIOD_H4 fine=1\r\n"
        open(os.path.join(ag, "20261008.log"), "wb").write(utf16(vecchio))
    return c


def snapshot(c):
    escludi = ("Users/Master/Desktop", "Users/Master/abtg_passata", "Users/Master/AppData/Roaming/MetaQuotes/Tester",
               "Users/Master/AppData/Roaming/MetaQuotes/Terminal/ABC123/Tester", "Users/Master/.cache", "Users/Master/.config", "Users/Master/.local")
    consentiti = ("Users/Master/AppData/Roaming/MetaQuotes/Terminal/ABC123/MQL5/Experts/EA_NatCla_Diag.mq5",
                  "Users/Master/AppData/Roaming/MetaQuotes/Terminal/ABC123/MQL5/Experts/EA_NatCla_Diag.ex5")
    out = {}
    for rd, dirs, files in os.walk(c):
        rel = os.path.relpath(rd, c).replace(os.sep, "/")
        if any(rel == e or rel.startswith(e + "/") for e in escludi):
            continue
        for f in files:
            r = (rel + "/" + f).lstrip("./")
            if r in consentiti:
                continue
            out[r] = hashlib.sha256(open(os.path.join(rd, f), "rb").read()).hexdigest()
    return out


class Banco:
    def __init__(self, base, chiavi):
        self.base = base
        self.chiavi = chiavi
        self.sim = os.path.join(base, "sim_diag.py")
        open(self.sim, "w").write(SIM)

    def gira(self, nome, **spec):
        d = tempfile.mkdtemp(dir=self.base, prefix="s_")
        c = costruisci(d, spec)
        prima = snapshot(c)
        pin = spec.get("pin", "a" * 40)
        files = {F_DIAG: leggi(F_DIAG), F_PS1: leggi(F_PS1)}
        for rel, f in spec.get("muta", {}).items():
            files[rel] = f(files[rel])
        srv = Srv(spec.get("pin_srv", pin), files)
        sd = os.path.join(d, "scen"); os.makedirs(sd)
        scen = dict(spec.get("scen", {})); scen["chiavi"] = self.chiavi
        json.dump(scen, open(os.path.join(sd, "scen.json"), "w"))
        simlog = os.path.join(sd, "simlog"); os.makedirs(simlog)
        user = os.path.join(c, "Users", "Master")
        tmp = os.path.join(sd, "tmp"); os.makedirs(tmp)
        env = dict(os.environ)
        env.update(COMPUTERNAME=spec.get("macchina", "DESKTOP-H4D7CAJ"), USERNAME="Master", USERPROFILE="C:\\Users\\Master", APPDATA="C:\\Users\\Master\\AppData\\Roaming",
                   TEMP=tmp, TMP=tmp, SystemRoot="C:\\Windows", POWERSHELL_TELEMETRY_OPTOUT="1", POWERSHELL_UPDATECHECK="Off", CDRIVE=c, HOME=user,
                   SIM_SCEN=os.path.join(sd, "scen.json"), SIM_LOG=simlog, SIM_CDRIVE=c, SIM_SCRIPT=self.sim, LOCAL_RAW=srv.base,
                   SLEEP_REALE="1" if spec.get("sleep_reale") else "0", SIM_NOEXIT=str(spec.get("no_exit", "")), SIM_NOCLOSE="1" if spec.get("no_close") else "0",
                   EX5_BLOCCATO="1" if spec.get("ex5_bloccato") else "0")
        bindir = os.path.join(sd, "bin"); os.makedirs(bindir)
        vivo = mx = None
        if spec.get("mt5_vivo"):
            shutil.copy(shutil.which("sleep"), os.path.join(bindir, spec["mt5_vivo"]))
            vivo = subprocess.Popen([os.path.join(bindir, spec["mt5_vivo"]), "300"]); time.sleep(0.4)
        if spec.get("mutex_occupato"):
            mx = subprocess.Popen(["pwsh", "-NoProfile", "-Command", "$m = New-Object System.Threading.Mutex($false, 'Global\\ABTG_NATCLA_F0'); [void]$m.WaitOne(); Start-Sleep -Seconds 120"], env=env)
            time.sleep(3)
        shaea = spec.get("sha_ea") or sha(files[F_DIAG])
        try:
            if spec.get("riga"):
                rt = spec["riga"].replace(RAW, srv.base)
                rf = os.path.join(sd, "riga.ps1"); open(rf, "w", newline="").write(rt)
                cmd = SETUP + "\n$ErrorActionPreference='Stop'; $t = Get-Content -Raw -LiteralPath '" + rf + "'; Invoke-Expression $t; 'FINE-HARNESS rc=' + $LASTEXITCODE\n"
            else:
                testo = leggi(F_PS1)
                if spec.get("muta_script"):
                    testo = spec["muta_script"](testo)
                testo = testo.replace(RAW.encode(), srv.base.encode())
                rf = os.path.join(sd, "drv.ps1"); open(rf, "wb").write(testo)
                args = "-Pin %s -ShaEA %s -TimeoutRunMin %d" % (pin, shaea, spec.get("timeout_min", 20))
                cmd = SETUP + "\n$ErrorActionPreference='Stop'; & '" + rf + "' " + args + "; 'FINE-HARNESS rc=' + $LASTEXITCODE\n"
            p = subprocess.run(["pwsh", "-NoProfile", "-Command", cmd], env=env, capture_output=True, text=True, timeout=900)
        finally:
            if vivo:
                vivo.kill(); vivo.wait()
            if mx:
                mx.kill(); mx.wait()
            srv.chiudi()
        dopo = snapshot(c)
        return dict(p=p, c=c, sd=sd, srv=srv, perimetro=(prima == dopo), nome=nome)


def rc_di(r):
    m = re.search(r"FINE-HARNESS rc=(\S+)", r["p"].stdout)
    return m.group(1) if m else None


def lanci(r):
    f = os.path.join(r["sd"], "simlog", "sim_terminale_lanci.txt")
    return open(f).read().splitlines() if os.path.exists(f) else []


def zipd(r, nome="NATCLA_DIAG_U30.zip"):
    z = os.path.join(r["c"], "Users", "Master", "Desktop", nome)
    return zipfile.ZipFile(z) if os.path.exists(z) else None


def tab(z, nome):
    if z is None or nome not in z.namelist():
        return []
    righe = z.read(nome).decode("ascii").splitlines()
    h = righe[0].split(";")
    return [dict(zip(h, x.split(";"))) for x in righe[1:]]


def tutto(r):
    return r["p"].stdout + r["p"].stderr


INGRESSI_ATTESI = "INPUT InpTF=16385,InpEmaLentaPeriodo=200,InpEmaTp1=14,InpEmaTp2=89,InpLogContesto=true,InpAtrNormPeriodo=14,InpAdxPeriodo=14,InpAdxTipo=0,InpVerificheSeparate=true,InpMaxEventi=20"
PASSATE_ATTESE = [("U30USD", "2024.09.26"), ("U30USD", "2025.01.02"), ("D30EUR", "2024.09.26"), ("EURUSD", "2024.09.26")]


# --- i giudizi degli scenari (True = lo script si e' comportato BENE): servono anche ai mutanti
def g_verde(r):
    z = zipd(r)
    m = tab(z, "MANIFEST_DIAG.csv")
    la = lanci(r)
    ok = rc_di(r) == "0" and len(m) == 4 and all(x["stato"] == "OK" for x in m) and len(la) == 4
    ok = ok and [tuple(re.search(r"Symbol=(\S+) Period=\S+ FromDate=(\S+)", x).groups()) for x in la] == PASSATE_ATTESE
    ok = ok and all(("Expert=EA_NatCla_Diag.ex5" in x and "Period=H1" in x and "ToDate=2026.06.30" in x and "Model=1" in x and "Optimization=0" in x and "Live=false" in x and
                     "Dll=false" in x and "Shutdown=1" in x and x.endswith(INGRESSI_ATTESI)) for x in la)
    return ok


def g_si_ferma(msg):
    def f(r):
        return rc_di(r) != "0" and msg in tutto(r) and not lanci(r) and zipd(r) is None and not os.path.exists(os.path.join(r["c"], "Users", "Master", "Desktop", "NATCLA_DIAG_U30"))
    return f


def g_ko_a(msg):
    def f(r):
        m = tab(zipd(r), "MANIFEST_DIAG.csv")
        return (rc_di(r) == "3" and len(m) == 4 and m[0]["stato"] == "KO" and msg in m[0]["motivi"] and all(x["stato"] == "OK" for x in m[1:]))
    return f


def g_comp_fallita(r):
    zc = zipd(r, "NATCLA_DIAG_U30_COMPILAZIONE_FALLITA.zip")
    return rc_di(r) != "0" and not lanci(r) and zipd(r) is None and zc is not None and "compile_natcla_diag.log" in zc.namelist() and "COMPILAZIONE_FALLITA.txt" in zc.namelist()


def g_italiano(r):
    return g_verde(r) and "log di compilazione: 0 errori, 2 avvisi" in r["p"].stdout


def g_ex5_bloccato(r):
    return rc_di(r) != "0" and "vecchio .ex5 non si cancella" in tutto(r) and not lanci(r) and zipd(r, "NATCLA_DIAG_U30_COMPILAZIONE_FALLITA.zip") is not None


def g_log_vecchio(r):
    return g_verde(r)


def g_desktop(r):
    ds = os.path.join(r["c"], "Users", "Master", "Desktop")
    el = os.listdir(ds)
    z = zipd(r)
    return (g_verde(r) and any(x.startswith("NATCLA_DIAG_U30_VECCHIA_") for x in el) and any(x.startswith("NATCLA_DIAG_U30_VECCHIO_") for x in el)
            and z is not None and "RESIDUO.txt" not in z.namelist())


def g_guasto(r):
    z = zipd(r)
    if z is None:
        return False
    lg = [n for n in z.namelist() if n.startswith("log/DIAG_a_")]
    return bool(lg) and "GUASTO" in z.read(lg[0]).decode("ascii") and "array out of range" in z.read(lg[0]).decode("ascii")


def g_timeout(r):
    m = tab(zipd(r), "MANIFEST_DIAG.csv")
    return (len(m) == 4 and m[0]["stato"] == "KO" and "timeout" in m[0]["motivi"] and all(x["stato"] == "OK" for x in m[1:]) and rc_di(r) == "3"
            and os.path.exists(os.path.join(r["sd"], "simlog", "sim_closemainwindow.txt")) and not os.path.exists(os.path.join(r["sd"], "simlog", "sim_kill.txt")))


def g_tetto(r):
    m = tab(zipd(r), "MANIFEST_DIAG.csv")
    return len(m) == 4 and all(x["stato"] == "NON_LANCIATA" for x in m) and not lanci(r) and rc_di(r) == "3"


def banco(chiavi, base):
    print("B) BANCO del driver (pwsh %s)" % (subprocess.run(["pwsh", "-NoProfile", "-Command", "$PSVersionTable.PSVersion.ToString()"], capture_output=True, text=True).stdout.strip()))
    B = Banco(base, chiavi)
    r = B.gira("verde")
    chk("B01 verde: rc 0, 4 passate OK, nell'ordine (a) U30USD 2024.09.26, (b) U30USD 2025.01.02, (c) D30EUR 2024.09.26, (d) EURUSD 2024.09.26; .ini lette dal finto "
        "terminale: Expert=EA_NatCla_Diag.ex5, H1, fino al 2026.06.30, Model=1, Optimization=0, AllowLiveTrading=false, Dll=false, input == file prova F0", g_verde(r), tutto(r)[-900:] + str(lanci(r))[:600])
    z = zipd(r)
    nomi = z.namelist() if z else []
    chk("B02 zip: RIEPILOGO_DIAG.txt, MANIFEST_DIAG.csv, DIAG_RIASSUNTO.csv, EA_NatCla_Diag.mq5, compile_natcla_diag.log, 4 log, 4 ini",
        all(x in nomi for x in ("RIEPILOGO_DIAG.txt", "MANIFEST_DIAG.csv", "DIAG_RIASSUNTO.csv", "EA_NatCla_Diag.mq5", "compile_natcla_diag.log")) and
        sum(n.startswith("log/") for n in nomi) == 4 and sum(n.startswith("ini/") for n in nomi) == 4, nomi)
    rs = tab(z, "DIAG_RIASSUNTO.csv")
    chk("B03 DIAG_RIASSUNTO.csv: 4 righe, una colonna per chiave, valori letti dalla riga RIASSUNTO ((a) cd_n 9946 cd_ok 0 max_barre 301; (d) cd_ok 9000; fine=1 ovunque)",
        len(rs) == 4 and list(rs[0].keys())[4:] == chiavi and rs[0]["cd_n"] == "9946" and rs[0]["cd_ok"] == "0" and rs[0]["max_barre"] == "301" and rs[3]["cd_ok"] == "9000" and all(x["fine"] == "1" for x in rs), rs[:1])
    chk("B04 MetaEditor chiamato con DUE argomenti (/compile e /log, classe 1152); scaricato SOLO l'EA diagnostico al pin",
        len(json.load(open(os.path.join(r["sd"], "simlog", "sim_args_editor.txt")))) == 2 and sorted(set(x.split("?")[0].split("/", 2)[2] for x in r["srv"].hits)) == [F_DIAG], r["srv"].hits)
    chk("B05 il disco FUORI dal perimetro non e' cambiato di un byte (EA_NatCla.mq5/.ex5, installazioni censite, grafici, origin.txt, Common)", r["perimetro"])
    lg = z.read([n for n in nomi if n.startswith("log/DIAG_a_")][0]).decode("ascii") if z else ""
    chk("B06 log della passata (a): AVVIO, una transizione EV, UNA riga RIASSUNTO (la copia nel giornale del terminale e' tolta per contenuto), righe del tester col simbolo ('bars generated')",
        lg.count("[NatCla-DIAG] RIASSUNTO") == 1 and "[NatCla-DIAG-AVVIO]" in lg and "[NatCla-DIAG-EV]" in lg and "bars generated" in lg, lg[:600])
    rp = z.read("RIEPILOGO_DIAG.txt").decode("ascii") if z else ""
    chk("B07 RIEPILOGO con le ATTESE scritte prima (controllo positivo (d), (a) riproduce il KO, quinta passata dichiarata)",
        "ATTESE SCRITTE PRIMA" in rp and "CONTROLLO POSITIVO" in rp and "InpVerificheSeparate=false" in rp, rp[:300])
    chk("B08 console: per ogni passata la CATENA (OK | n<300 | BarsCalculated | CopyRates | CopyBuffer) e la prima barra tutta OK", r["p"].stdout.count("CATENA: OK ") == 4 and "n<300 9946" in r["p"].stdout)
    print("   guardie")
    for nome, msg, kw in (("B10 macchina diversa (VPS)", "gira SOLO sul PC di backtest", dict(macchina="VMI3047753")),
                          ("B11 terminal64 vivo", "APERTO", dict(mt5_vivo="terminal64")),
                          ("B12 metaeditor64 vivo", "APERTO", dict(mt5_vivo="metaeditor64")),
                          ("B13 sedia attaccata a un grafico", "SEDIE ATTACCATE", dict(chr=[{}, {"ea": "ABTG_Qualcosa"}])),
                          ("B14 installazione non censita", "NON censite", dict(altra_inst=True)),
                          ("B15 due cartelle dati", "NON risolta in modo univoco", dict(doppio_dati=True)),
                          ("B16 zero grafici", "ZERO grafici", dict(chr=[])),
                          ("B17 mutex occupato (un lotto F0 in corso)", "ALTRO giro", dict(mutex_occupato=True)),
                          ("B18 SHA256 dell'EA diverso da quello della riga", "SHA256", dict(sha_ea="0" * 64)),
                          ("B19 EA servito con NCD_VER 1.01 (SHA coerente)", "NCD_VER", dict(muta={F_DIAG: lambda b: b.replace(b'#define NCD_VER "1.00"', b'#define NCD_VER "1.01"')})),
                          ("B20 pin senza file (404)", "", dict(pin="b" * 40, pin_srv="a" * 40))):
        rr = B.gira(nome, **kw)
        chk("%s: si ferma, nessun terminale, niente sul Desktop%s" % (nome, (", messaggio '" + msg + "'") if msg else ""), g_si_ferma(msg)(rr), tutto(rr)[-500:])
    print("   compilazione")
    rr = B.gira("B21", scen=dict(compile_fallisce=True))
    chk("B21 compilazione fallita: rc 1, zip NATCLA_DIAG_U30_COMPILAZIONE_FALLITA.zip col log, nessuna passata", g_comp_fallita(rr), tutto(rr)[-400:])
    rr = B.gira("B22", scen=dict(compile_errori_con_ex5=True))
    chk("B22 .ex5 prodotto ma log con 2 errori: si ferma, zip della compilazione", g_comp_fallita(rr), tutto(rr)[-400:])
    rr = B.gira("B23", scen=dict(compile_italiano=True, compile_avvisi=2))
    chk("B23 log di MetaEditor in ITALIANO ('0 errori, 2 avvisi'): letto, prosegue, 4 OK", g_italiano(rr), r["p"].stdout[:300] + rr["p"].stdout[:1200])
    rr = B.gira("B24", ex5_vecchio=True, ex5_bloccato=True)
    chk("B24 .ex5 vecchio che NON si cancella (file bloccato simulato): si ferma prima di compilare, zip della compilazione", g_ex5_bloccato(rr), tutto(rr)[-400:])
    rr = B.gira("B25", ex5_vecchio=True)
    chk("B25 .ex5 vecchio che si cancella: il giro prosegue verde", g_verde(rr), tutto(rr)[-300:])
    print("   difetti per passata (sulla passata (a))")
    for fault, msg in (("no_rias", "RIASSUNTO NON trovata"), ("troncato", "TRONCATA"), ("doppio", "PIU righe RIASSUNTO"), ("sym", "simbolo XXXUSD"),
                       ("chiave", "chiavi assenti nel RIASSUNTO: cd_bc"), ("rifiutato", "RIFIUTATO"), ("no_avvio", "AVVIO] NON trovata")):
        rr = B.gira("B3x" + fault, scen=dict(falli={"U30USD_2024.09.26": fault}))
        chk("B3x %s: (a) KO con '%s', le altre 3 OK, rc 3, lo zip esce" % (fault, msg), g_ko_a(msg)(rr), str(tab(zipd(rr), "MANIFEST_DIAG.csv")[:1]) + tutto(rr)[-300:])
    rr = B.gira("B40", scen=dict(valori={"U30USD_2024.09.26": {"nuove": "0"}}))
    chk("B40 zero barre nuove viste dall'EA: (a) KO", g_ko_a("ZERO barre nuove")(rr))
    rr = B.gira("B41", scen=dict(falli={"U30USD_2024.09.26": "guasto"}))
    chk("B41 riga 'array out of range' del terminale: finisce nel log della passata come GUASTO", g_guasto(rr), tutto(rr)[-300:])
    rr = B.gira("B42", log_vecchio=True)
    chk("B42 log dell'agente con un RIASSUNTO VECCHIO prima del giro: la fotografia lo esclude, 4 OK", g_log_vecchio(rr), str(tab(zipd(rr), "MANIFEST_DIAG.csv")[:1]))
    rr = B.gira("B43", desktop_vecchio=True)
    chk("B43 cartella e zip di un giro precedente RINOMINATI con la data, il residuo non entra nello zip nuovo", g_desktop(rr))
    rr = B.gira("B44", muta_script=lambda b: b.replace(b"$TETTO_MIN = 40", b"$TETTO_MIN = 0"))
    chk("B44 tetto 0 (costante cambiata sulla copia): 4 NON_LANCIATA, nessun terminale, rc 3, lo zip esce", g_tetto(rr), tutto(rr)[-300:])
    if not RAPIDO:
        print("   timeout (reale: ~1 minuto ciascuno)")
        rr = B.gira("B45", timeout_min=1, no_exit=1, sleep_reale=True)
        chk("B45 timeout sulla passata (a): CloseMainWindow (mai Kill), (a) KO 'timeout', le altre 3 OK, rc 3", g_timeout(rr), str(tab(zipd(rr), "MANIFEST_DIAG.csv")) + tutto(rr)[-300:])
        rr = B.gira("B46", timeout_min=1, no_exit=1, no_close=True, sleep_reale=True)
        m = tab(zipd(rr), "MANIFEST_DIAG.csv")
        chk("B46 il terminale non si chiude nemmeno con CloseMainWindow: (a) KO, (b)(c)(d) NON_LANCIATA 'giro fermato', un solo lancio, nessun Kill",
            len(m) == 4 and m[0]["stato"] == "KO" and all(x["stato"] == "NON_LANCIATA" and "giro fermato" in x["motivi"] for x in m[1:]) and len(lanci(rr)) == 1 and
            not os.path.exists(os.path.join(rr["sd"], "simlog", "sim_kill.txt")), str(m) + tutto(rr)[-300:])
    return B


# ===========================================================================
#  M) MUTANTI
# ===========================================================================
MUT_EA = [
    ("D01", "NC_BARRE_MIN 300 -> 299", "#define NC_BARRE_MIN 300 ", "#define NC_BARRE_MIN 299 "),
    ("D02", "NC_BARRE 1500 -> 1501", "#define NC_BARRE     1500", "#define NC_BARRE     1501"),
    ("D03", "finestra barre-1", "? barre-2 : NC_BARRE", "? barre-1 : NC_BARRE"),
    ("D04", "BarsCalculated < n invece di < n+1", "return (bc<n+1);", "return (bc<n);"),
    ("D05", "catena: primo BarsCalculated su hAtrN", "gcBc[0]=BarsCalculated(hEma200);\n   if(NCD_CadeBC(n,gcBc[0]))", "gcBc[0]=BarsCalculated(hAtrN);\n   if(NCD_CadeBC(n,gcBc[0]))"),
    ("D06", "catena: CopyRates dalla barra 0", "gcCr=CopyRates(_Symbol,gTF,1,n,r);", "gcCr=CopyRates(_Symbol,gTF,0,n,r);"),
    ("D07", "catena: niente ResetLastError prima del CopyBuffer ATR", "   ResetLastError();\n   gcCb[1]=CopyBuffer", "   gcCb[1]=CopyBuffer"),
    ("D08", "catena: CopyBuffer ADX cade come CR", "if(NCD_CadeCopia(n,gcCb[2])) return NCD_CB;", "if(NCD_CadeCopia(n,gcCb[2])) return NCD_CR;"),
    ("D09", "completa: BarsCalculated EMA anche se gia' chiesto", "if(gcBc[0]==NCD_NC) gcBc[0]=BarsCalculated(hEma200);", "gcBc[0]=BarsCalculated(hEma200);"),
    ("D10", "completa: copia anche con n<1", "if(gcN<1) return;", "if(gcN<0) return;"),
    ("D11", "handle: ATR a periodo fisso 14", "hAtrN  =iATR(_Symbol,gTF,InpAtrNormPeriodo);", "hAtrN  =iATR(_Symbol,gTF,14);"),
    ("D12", "handle: Bollinger non creato", "      hBands=iBands(_Symbol,gTF,20,0,2.0,PRICE_CLOSE);\n", ""),
    ("D13", "handle: iADX/Wilder scambiati", "if(InpAdxTipo==NC_ADX_WILDER) hAdx=iADXWilder", "if(InpAdxTipo==NC_ADX_MT5) hAdx=iADXWilder"),
    ("D14", "guardia solo tester tolta", "if(!MQLInfoInteger(MQL_TESTER))", "if(false && !MQLInfoInteger(MQL_TESTER))"),
    ("D15", "chiave cd_bc rinominata", '" cd_bc="', '" cd_bcx="'),
    ("D16", "seconda riga col tag [NatCla-DIAG]", 'Print("[NatCla-DIAG-EV] barra="', 'Print("[NatCla-DIAG] barra="'),
    ("D17", "un OrderSend", "   gTick++;\n", "   gTick++;\n   MqlTradeRequest q; MqlTradeResult w; ZeroMemory(q); OrderSend(q,w);\n"),
    ("D18", "un FileOpen", "   for(int m=0;m<5;m++) gCd[m]=0;\n", "   for(int m=0;m<5;m++) gCd[m]=0;\n   int fh=FileOpen(\"x.csv\",FILE_WRITE|FILE_CSV);\n"),
    ("D19", "IndicatorRelease tolto", "IndicatorRelease(hs[i]);", "Print(hs[i]);"),
    ("D20", "nuova barra: ogni tick", "if(t0==0 || t0==gUltimaBarra) return;", "if(t0==0) return;"),
    ("D21", "primo motivo: CopyRates prima di BarsCalculated", "   if(NCD_CadeBC(n,bcE) || NCD_CadeBC(n,bcA) || NCD_CadeBC(n,bcX)) return NCD_BC;\n   if(NCD_CadeCopia(n,cr)) return NCD_CR;\n",
     "   if(NCD_CadeCopia(n,cr)) return NCD_CR;\n   if(NCD_CadeBC(n,bcE) || NCD_CadeBC(n,bcA) || NCD_CadeBC(n,bcX)) return NCD_BC;\n"),
    ("D22", "default ATR 14 -> 10", "input int             InpAtrNormPeriodo  = 14;", "input int             InpAtrNormPeriodo  = 10;"),
    ("D23", "righe EV senza tetto", "if(gEventi<InpMaxEventi)", "if(gEventi>=0)"),
    ("D24", "TF CURRENT -> H4", "if(InpTF==PERIOD_CURRENT) gTF=PERIOD_H1;", "if(InpTF==PERIOD_CURRENT) gTF=PERIOD_H4;"),
    ("D25", "RIASSUNTO senza fine=1", '" fine=1"', '" fine=0"'),
    ("D26", "catena: BarsCalculated ADX cade come N", "if(NCD_CadeBC(n,gcBc[2])) return NCD_BC;", "if(NCD_CadeBC(n,gcBc[2])) return NCD_N;"),
    ("D27", "catena: niente ArraySetAsSeries(gAdx)", " ArraySetAsSeries(gAdx,false);\n   ResetLastError();\n   gcCb[0]", "\n   ResetLastError();\n   gcCb[0]"),
    ("D28", "catena: niente sentinella sui valori non chiesti", "for(int k=0;k<3;k++){ gcBc[k]=NCD_NC; gcCb[k]=NCD_NC; gcCbErr[k]=0; }\n   int barre", "int barre"),
]

MUT_PS = [
    ("P01", "guardia macchina", b"if($env:COMPUTERNAME -ne 'DESKTOP-H4D7CAJ'){", b"if($env:COMPUTERNAME -eq 'NESSUNO'){", dict(macchina="VMI3047753"), g_si_ferma("")),
    ("P02", "guardia MT5 aperto", b"if((@(Get-Process -Name terminal64, metaeditor64 -ErrorAction SilentlyContinue)).Count -gt 0){", b"if($false){", dict(mt5_vivo="terminal64"), g_si_ferma("")),
    ("P03", "SHA dell'EA non controllato", b"if($hh -ne $ShaEA){", b"if($false){", dict(sha_ea="0" * 64), g_si_ferma("")),
    ("P04", "NCD_VER non controllato", b"if(-not (Select-String -LiteralPath $srcEA -SimpleMatch -Pattern ('#define NCD_VER", b"if($false -and (Select-String -LiteralPath $srcEA -SimpleMatch -Pattern ('#define NCD_VER",
     dict(muta={F_DIAG: lambda b: b.replace(b'#define NCD_VER "1.00"', b'#define NCD_VER "1.01"')}), g_si_ferma("")),
    ("P05", "AllowLiveTrading=true", b"AllowLiveTrading=false", b"AllowLiveTrading=true", {}, g_verde),
    ("P06", "Model=0", b"`r`nModel=1`r`n", b"`r`nModel=0`r`n", {}, g_verde),
    ("P07", "Optimization=1", b"Optimization=0`r`n", b"Optimization=1`r`n", {}, g_verde),
    ("P08", "doppioni del RIASSUNTO non tolti", b"$c0 = 'R|' + $mr.Groups[1].Value.TrimEnd(); if(-not $visti.ContainsKey($c0))", b"$c0 = 'R|' + $mr.Groups[1].Value.TrimEnd(); if($true)", {}, g_verde),
    ("P09", "fine=1 non controllato", b"if($R['fine'] -ne '1')", b"if($false)", dict(scen=dict(falli={"U30USD_2024.09.26": "troncato"})), g_ko_a("TRONCATA")),
    ("P10", "simbolo non controllato", b"if($R['sym'] -ne $ps.Sim)", b"if($false)", dict(scen=dict(falli={"U30USD_2024.09.26": "sym"})), g_ko_a("simbolo XXXUSD")),
    ("P11", "chiavi non controllate", b"if($mancano.Count -gt 0)", b"if($false)", dict(scen=dict(falli={"U30USD_2024.09.26": "chiave"})), g_ko_a("chiavi assenti")),
    ("P12", "fotografia ignorata", b"$off = 0; if($foto.ContainsKey($f.FullName)){ $off = [long]$foto[$f.FullName] }", b"$off = 0", dict(log_vecchio=True), g_log_vecchio),
    ("P13", "CloseMainWindow tolto", b"try{ [void]$p.CloseMainWindow() }catch{ }", b"", dict(timeout_min=1, no_exit=1, sleep_reale=True), g_timeout),
    ("P14", ".ex5 vecchio non controllato", b"if(Test-Path -LiteralPath $ex5){ FermaCompilazione 'il vecchio .ex5", b"if($false){ FermaCompilazione 'il vecchio .ex5", dict(ex5_vecchio=True, ex5_bloccato=True), g_ex5_bloccato),
    ("P15", "regex del risultato solo in inglese", b"'(\\d+)\\s+(?:errors?|errori),\\s*(\\d+)\\s+(?:warnings?|avvisi)'", b"'(\\d+)\\s+errors?,\\s*(\\d+)\\s+warnings?'", dict(scen=dict(compile_italiano=True, compile_avvisi=2)), g_italiano),
    ("P16", "zip della compilazione tolto", b"    Compress-Archive -Path (Join-Path $CartC '*') -DestinationPath $zipC -Force\n", b"", dict(scen=dict(compile_fallisce=True)), g_comp_fallita),
    ("P17", "Desktop vecchio non rinominato", b"if(Test-Path -LiteralPath $Cart){ Move-Item", b"if($false){ Move-Item", dict(desktop_vecchio=True), g_desktop),
    ("P18", "rc 3 -> 0", b"exit 3", b"exit 0", dict(scen=dict(falli={"U30USD_2024.09.26": "no_rias"})), g_ko_a("RIASSUNTO NON trovata")),
    ("P19", "data della passata (b) cambiata", b"Da = '2025.01.02'", b"Da = '2025.01.03'", {}, g_verde),
    ("P20", "mutex con un altro nome", b"New-Object System.Threading.Mutex($false, 'Global\\ABTG_NATCLA_F0')", b"New-Object System.Threading.Mutex($false, 'Global\\ABTG_ALTRO')", dict(mutex_occupato=True), g_si_ferma("")),
    ("P21", "InpAdxTipo=1 nella .ini", b"'InpAdxTipo=0'", b"'InpAdxTipo=1'", {}, g_verde),
    ("P22", "censimento delle installazioni spento", b"if($ignote.Count -gt 0){", b"if($ignote.Count -gt 99){", dict(altra_inst=True), g_si_ferma("")),
    ("P23", "sedie sui grafici non guardate", b"if($conEA.Count -gt 0){", b"if($conEA.Count -gt 99){", dict(chr=[{}, {"ea": "ABTG_Qualcosa"}]), g_si_ferma("")),
    ("P24", "righe di guasto non tenute", b"if($reGuasto.IsMatch($riga)){", b"if($false){", dict(scen=dict(falli={"U30USD_2024.09.26": "guasto"})), g_guasto),
    ("P25", "AVVIO rifiutato non controllato", b"if($a -match 'RIFIUTATO|ERRORE')", b"if($false)", dict(scen=dict(falli={"U30USD_2024.09.26": "rifiutato"})), g_ko_a("RIFIUTATO")),
    ("P26", "zero barre nuove non controllato", b"if($R.ContainsKey('nuove') -and $R['nuove'] -eq '0')", b"if($false)", dict(scen=dict(valori={"U30USD_2024.09.26": {"nuove": "0"}})), g_ko_a("ZERO barre")),
]


def mutanti_ea(diag_raw, ea_raw, ps1_raw, prova_raw, tmp):
    print("M) MUTANTI dell'EA diagnostico (%d)" % len(MUT_EA))
    vivi = []
    src = diag_raw.decode("ascii")
    for mid, desc, old, new in MUT_EA:
        if src.count(old) != 1:
            chk("%s %s: il punto da mutare esiste UNA volta" % (mid, desc), False, "trovato %d volte" % src.count(old))
            vivi.append(mid)
            continue
        ms = src.replace(old, new).encode("ascii")
        bag = []
        statico(ms, ea_raw, ps1_raw, prova_raw, bag)
        if not bag:
            d = tempfile.mkdtemp(dir=tmp, prefix="m_")
            prova_catena(ms.decode("ascii"), ea_raw.decode("ascii", "replace"), d, bag, ncas=800)
        if not bag:
            vivi.append(mid)
        print("    %s %-55s %s" % (mid, desc, ("PRESO: " + bag[0][:90]) if bag else "SOPRAVVISSUTO"), flush=True)
    chk("M-EA: %d mutanti, tutti presi (sopravvissuti: %s)" % (len(MUT_EA), vivi or "nessuno"), not vivi)


def mutanti_ps(B):
    print("M) MUTANTI del driver (%d)" % len(MUT_PS))
    vivi = []
    for mid, desc, old, new, spec, giudice in MUT_PS:
        if RAPIDO and "timeout_min" in spec:
            print("    %s %-45s SALTATO (--rapido)" % (mid, desc))
            continue
        t = leggi(F_PS1)
        if t.count(old) < 1:
            chk("%s %s: il punto da mutare esiste" % (mid, desc), False)
            vivi.append(mid)
            continue
        spec2 = dict(spec)
        spec2["muta_script"] = (lambda o, n: (lambda b: b.replace(o, n)))(old, new)
        r = B.gira(mid, **spec2)
        preso = not giudice(r)
        if not preso:
            vivi.append(mid)
        print("    %s %-45s %s" % (mid, desc, "PRESO" if preso else "SOPRAVVISSUTO"), flush=True)
    chk("M-PS1: mutanti del driver tutti presi (sopravvissuti: %s)" % (vivi or "nessuno"), not vivi)


# ===========================================================================
#  R) RIGA
# ===========================================================================
def git_show(pin, rel):
    return subprocess.run(["git", "show", "%s:%s" % (pin, rel)], cwd=ROOT, capture_output=True, check=True).stdout


def genera_riga(pin, dest=None, senza_origin=False):
    assert re.match(r"^[0-9a-f]{40}$", pin), "il commit va passato di 40 caratteri esadecimali minuscoli"
    if not senza_origin:
        r = subprocess.run(["git", "merge-base", "--is-ancestor", pin, "origin/lavoro"], cwd=ROOT)
        assert r.returncode == 0, "il commit %s NON e' raggiungibile da origin/lavoro: prima push, poi la riga" % pin[:8]
    src = git_show(pin, F_PS1)
    src.decode("ascii")
    H = sha(src)
    SEA = sha(git_show(pin, F_DIAG))
    assert src.splitlines()[1].decode() == "#  " + MARC, "il marcatore deve stare alla riga 2 dello script"
    bersaglio = ("BERSAGLIO: SOLO una finestra PowerShell sul PC di backtest DESKTOP-H4D7CAJ: terminale C:\\Program Files\\BCM Markets MT5 Terminal (cartella BCM Markets MT5 Terminal), "
                 "loggato sul demo 50503392. Lo script lo apre e lo chiude da solo, una volta per passata (4 passate di backtest, AllowLiveTrading=false, EA DIAGNOSTICO EA_NatCla_Diag "
                 "di SOLA LETTURA: nessun ordine, nessun file, fuori dal tester rifiuta di partire). "
                 "NON TOCCATI, per nome, PRIMA SU QUESTO PC (censimento P0 del 05/10): C:\\MT5_Backtest (cartella dati 04C7A32B, conto non censito) e C:\\FundedNext_Manuale (cartella dati 2B8180C3, conto non censito), che devono restare CHIUSI; "
                 "POI il VPS VMI3047753 e TUTTE le sue cartelle dati -- FTMO trial 1514806751 (C:\\FTMO, ex challenge 541452707: le sedie e il Guardian), REALE 10105439 (C:\\BCM_Reale), 100k 50504263 (BCM Markets MT5 Terminal -V3), "
                 "piccolo 50503392 sul VPS (BCM Markets MT5 Terminal), manuale 50503635 (C:\\MT5_MANUALE), banco 50504400 (C:\\MT5_Backtest), Pepperstone, Tickmill. "
                 "NON tocca EA_NatCla.mq5 ne il suo .ex5, CODA.txt, il runner notturno, preset, sedie, conti, taglie. "
                 "Scrive SOLO: la cartella abtg_passata nel profilo utente, MQL5\\Experts\\EA_NatCla_Diag.mq5 e .ex5 del terminale BCM di questa macchina, il Desktop (cartella e zip NATCLA_DIAG_U30). "
                 "NON lanciarla se un lotto NATCLA_F0 o una riga di round sta GIA girando su questo PC (classe 853: lo script si ferma da solo col mutex del F0).")
    avviso_mt5 = ("QUI CI SONO TRE MT5 (C:\\Program Files\\BCM Markets MT5 Terminal = demo 50503392, C:\\MT5_Backtest, C:\\FundedNext_Manuale): devono essere TUTTI CHIUSI, MetaEditor compreso. NON serve aprirne nessuno: lo script controlla da solo "
                  "i grafici salvati del terminale BCM e si ferma se trova una SEDIA attaccata (il 14/08/2026 da questa macchina sono partiti ordini VERI, #3160534/#3160535, -104,60). "
                  "Se uno e aperto, qui sotto compare il suo PID, titolo e cartella: chiudi QUELLO, a mano, e rilancia.")
    cosa = ("NATCLA DIAG U30 (commit " + pin[:8] + ") -- 4 passate singole dell EA diagnostico EA_NatCla_Diag (v1.00, MAI compilato prima: la prima compilazione la fa lo script), Modello 1 (OHLC su M1), H1, fino al 2026.06.30: "
            "(a) U30USD dal 2024.09.26 (riproduce il KO del pilota), (b) U30USD dal 2025.01.02 (circa 3 mesi di storia BCM davanti), (c) D30EUR dal 2024.09.26 (secondo indice), (d) EURUSD dal 2024.09.26 (CONTROLLO POSITIVO). "
            "Dice QUALE delle 4 condizioni di CaricaDati di EA_NatCla cade (n sotto 300, BarsCalculated, CopyRates, CopyBuffer) e da quale barra passano tutte. Nessun PF, nessun DD, nessun ordine. "
            "Il lotto C di F0 resta FERMO finche questo zip non e letto. Da mandare quando finisce: lo zip NATCLA_DIAG_U30.zip dal Desktop di questo PC.")
    tempo = ("TEMPO ATTESO [MISURATO dal pilota 07/10 su H1: 28-40 secondi a passata, il KO U30USD e costato 28 s]: compilazione circa 1 minuto + 4 passate x 28-40 secondi = 3-4 minuti. "
             "Puo durare DI PIU se il terminale deve scaricare lo storico M1 di D30EUR (mai girato in F0 su questo PC): per questo il tetto resta largo. "
             "Il tetto del giro e 40 minuti (ferma l AVVIO di una passata, non la sua fine; ogni passata ha un timeout di 20 minuti, chiuso con CloseMainWindow). "
             "NON fermarla prima di 65 minuti (caso peggiore: compilazione 2 + tetto 40 + ultima passata fino a 20 + chiusura 2; lo zip si scrive solo alla FINE). "
             "Prerequisito: NESSUN MT5 o MetaEditor aperto su questo PC e NESSUNA sedia attaccata ai grafici salvati del terminale BCM (lo script si ferma e lo dice).")
    guarda = ("COSE DA GUARDARE PER PRIME quando torna, scritte PRIMA: (1) la compilazione: 0 errori (se FALLISCE lo script si ferma con rc 1 prima del tester e lo zip da mandare e NATCLA_DIAG_U30_COMPILAZIONE_FALLITA.zip); "
              "(2) (d) EURUSD deve avere cd_ok sopra 0 e la prima barra tutta OK all inizio della finestra: se no la diagnosi e rotta e nient altro si legge; "
              "(3) (a) U30USD dal 2024.09.26 deve avere cd_ok = 0 (riproduce il KO): la colonna fra cd_n, cd_bc, cd_cr e cd_cb che porta le barre e la condizione che cade; "
              "se invece (a) ha cd_ok sopra 0 la diagnosi NON riproduce il KO e serve una quinta passata con InpVerificheSeparate=false (dichiarata, non lanciata qui); "
              "(4) (b) e (c): con storia davanti passa? l altro indice cade allo stesso modo? Lo script CONTA e non giudica.")
    fine = ("FILE ATTESI NELLO ZIP sul Desktop (NATCLA_DIAG_U30.zip): RIEPILOGO_DIAG.txt + MANIFEST_DIAG.csv + DIAG_RIASSUNTO.csv + EA_NatCla_Diag.mq5 + compile_natcla_diag.log + log\\DIAG_<passata>.txt x 4 + ini\\diag_<passata>.ini x 4; "
            "rc 0 = tutte leggibili, rc 3 = almeno una KO o non lanciata (lo zip esce lo stesso), rc 1 = si e fermato prima del tester (se e la COMPILAZIONE, lo zip da mandare e NATCLA_DIAG_U30_COMPILAZIONE_FALLITA.zip)")
    for s in (bersaglio, cosa, tempo, guarda, fine, avviso_mt5):
        assert "'" not in s, s
        s.encode("ascii")
    t = ("& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12; $PIN='" + pin + "'; $T0=Get-Date; "
         "Write-Host '" + bersaglio + "' -ForegroundColor Yellow; "
         "if($env:COMPUTERNAME -ne 'DESKTOP-H4D7CAJ'){ throw ('QUESTA RIGA GIRA SOLO SUL PC DI BACKTEST DESKTOP-H4D7CAJ. Qui la macchina si chiama: ' + $env:COMPUTERNAME + '. Sul VPS VMI3047753 non si lancia: la challenge FTMO sta operando (firma del 21/09/2026: i round girano sul PC di backtest).') }; "
         "Write-Host '" + avviso_mt5 + "' -ForegroundColor Red; "
         "$mp=@(Get-Process -Name terminal64,metaeditor64 -ErrorAction SilentlyContinue); if($mp.Count -gt 0){ Write-Host 'MT5 / MetaEditor APERTI ORA su questo PC (PID, titolo, cartella):' -ForegroundColor Red; $mp | Select-Object Id, MainWindowTitle, Path | Format-Table -AutoSize | Out-String -Width 300 | Write-Host }; "
         "if((@(Get-Process -Name terminal64,metaeditor64 -ErrorAction SilentlyContinue)).Count -gt 0){ throw 'MT5 o MetaEditor risulta APERTO su questo PC. Ogni passata ne apre una copia sua con /config: col terminale gia aperto il tester non parte. Fai quello che dice la riga rossa qui sopra, poi rilancia.' }; "
         "$W=Join-Path $env:USERPROFILE 'abtg_passata'; New-Item -ItemType Directory -Force -Path $W | Out-Null; $S=Join-Path $W 'NATCLA_DIAG_U30.ps1'; Remove-Item -LiteralPath $S -Force -ErrorAction SilentlyContinue; "
         "$u='https://raw.githubusercontent.com/claudiospadaro12/GITHUB/'+$PIN+'/" + F_PS1 + "?cb='+[Guid]::NewGuid().ToString('N'); "
         "$wc=New-Object Net.WebClient; $b=$wc.DownloadData($u); $sha=New-Object Security.Cryptography.SHA256Managed; $h=[BitConverter]::ToString($sha.ComputeHash($b)).Replace('-',''); "
         "if($h -ne '" + H + "'){ Write-Host ('IMPRONTA DIVERSA (' + $h + '): copia vecchia o cache di GitHub. Mi fermo, non lancio niente.') -ForegroundColor Red; return }; "
         "$t=[Text.Encoding]::ASCII.GetString($b); "
         "if(-not ($t | Select-String -SimpleMatch -Quiet -Pattern '" + MARC + "')){ Write-Host 'Marcatore " + MARC + " ASSENTE nello script scaricato: mi fermo.' -ForegroundColor Red; return }; "
         "Set-Content -LiteralPath $S -Value $t -Encoding ASCII -NoNewline; "
         "$h2=(Get-FileHash -LiteralPath $S -Algorithm SHA256).Hash; if($h2 -ne '" + H + "'){ Write-Host ('Il file scritto sul disco ha un altra impronta (' + $h2 + '): mi fermo.') -ForegroundColor Red; return }; "
         "Write-Host ('pc  : ' + $env:COMPUTERNAME) -ForegroundColor Green; Write-Host ('pin : ' + $PIN) -ForegroundColor Green; Write-Host ('impronta script: ' + $h.Substring(0,8) + ' OK, marcatore OK') -ForegroundColor Green; Write-Host ('data: ' + $T0.ToString('yyyy-MM-dd HH:mm:ss')) -ForegroundColor Green; "
         "Write-Host '" + cosa + "' -ForegroundColor Cyan; "
         "Write-Host '" + tempo + "' -ForegroundColor Yellow; "
         "Write-Host '" + guarda + "' -ForegroundColor Yellow; "
         "$ErrorActionPreference='Continue'; & powershell.exe -NoProfile -ExecutionPolicy Bypass -File $S -Pin $PIN -ShaEA " + SEA + " -TimeoutRunMin 20; $rc=$LASTEXITCODE; Write-Host ''; "
         "Write-Host ('NATCLA DIAG U30 rc ' + $rc + '   (0 = tutte le passate leggibili; 3 = almeno una KO o non lanciata, lo zip esce lo stesso; 1 = si e fermato prima del tester, il messaggio rosso dice dove)') -ForegroundColor Cyan; "
         "Write-Host ('durata totale minuti: ' + [int](((Get-Date)-$T0).TotalMinutes)) -ForegroundColor Cyan; "
         "Write-Host '" + fine + "' -ForegroundColor Gray }")
    t.encode("ascii")
    assert "\n" not in t and "\r" not in t
    dest = dest or os.path.join(ROOT, F_RIGA)
    open(dest, "w", newline="").write(t)
    print(len(t), "byte; SHA256 dello script", H, "; SHA256 EA diagnostico", SEA, "; SHA256 della riga", sha(t.encode("ascii")))
    return t, H, SEA


def prova_riga(pin, B, base):
    print("R) RIGA al pin %s" % pin[:8])
    for rel in (F_PS1, F_DIAG):
        if git_show(pin, rel) != leggi(rel):
            chk("R00 working tree == pin per %s" % rel, False, "commit prima, poi la riga")
            return
    riga = open(os.path.join(ROOT, F_RIGA), encoding="ascii").read()
    H = sha(git_show(pin, F_PS1))
    SEA = sha(git_show(pin, F_DIAG))
    chk("R01 una riga fisica ASCII, col pin, TLS 1.2, guardia macchina, timeout 20", "\n" not in riga and "\r" not in riga and riga.isascii() and ("$PIN='" + pin + "'") in riga and "Tls12" in riga and "DESKTOP-H4D7CAJ" in riga and "-TimeoutRunMin 20" in riga)
    chk("R02 impronta dello script e dell'EA nella riga == quelle del commit (git show)", ("$h -ne '" + H + "'") in riga and ("-ShaEA " + SEA + " ") in riga)
    chk("R03 bersaglio per nome (50503392, BCM Markets MT5 Terminal) e i NON toccati (C:\\MT5_Backtest, C:\\FundedNext_Manuale, 541452707, 1514806751, 10105439, 50504263, 50503635, 50504400, Pepperstone, Tickmill)",
        riga.startswith("& { ") and riga.index("BERSAGLIO") < riga.index("DownloadData") and all(x in riga for x in ("50503392", "BCM Markets MT5 Terminal", "C:\\MT5_Backtest", "C:\\FundedNext_Manuale", "541452707", "1514806751", "10105439", "50504263", "50503635", "50504400", "Pepperstone", "Tickmill", "NON tocca EA_NatCla.mq5")))
    chk("R04 la riga dichiara tempo, tetto, file attesi e codici d'uscita", "3-4 minuti" in riga and "65 minuti" in riga and "FILE ATTESI NELLO ZIP" in riga and "rc 3" in riga)
    r = B.gira("R05", riga=riga, pin=pin)
    chk("R05 RIGA verde nel banco: scarica, controlla l'impronta, lancia lo script, 4 passate giuste, rc 0, zip", "NATCLA DIAG U30 rc 0" in r["p"].stdout and g_verde(r) and zipd(r) is not None, tutto(r)[-600:])
    scr = os.path.join(r["c"], "Users", "Master", "abtg_passata", "NATCLA_DIAG_U30.ps1")
    chk("R06 lo script scritto sul disco ha l'impronta della riga", os.path.exists(scr) and sha(open(scr, "rb").read()) == H)
    def scritto(rr):
        return os.path.exists(os.path.join(rr["c"], "Users", "Master", "abtg_passata", "NATCLA_DIAG_U30.ps1"))
    rr = B.gira("R07", riga=riga, pin=pin, muta={F_PS1: lambda b: b + b"#x"})
    chk("R07 script con un byte in piu: IMPRONTA DIVERSA, non scritto, nessun terminale", "IMPRONTA DIVERSA" in rr["p"].stdout and not scritto(rr) and not lanci(rr))
    rr = B.gira("R08", riga=riga, pin=pin, muta={F_PS1: lambda b: b.replace(b"Dico", b"Dic0", 1)})
    chk("R08 script con un byte cambiato (stessa lunghezza): IMPRONTA DIVERSA", "IMPRONTA DIVERSA" in rr["p"].stdout and not scritto(rr) and not lanci(rr))
    senza = leggi(F_PS1).replace(MARC.encode(), b"MARCATORE_ALTRO_v1")
    rr = B.gira("R09", riga=riga.replace(H, sha(senza)), pin=pin, muta={F_PS1: lambda b: senza})
    chk("R09 marcatore assente: si ferma, non scritto, nessun terminale", "ASSENTE nello script scaricato" in rr["p"].stdout and not scritto(rr) and not lanci(rr))
    rr = B.gira("R10", riga=riga, pin=pin, macchina="VMI3047753")
    chk("R10 sul VPS: eccezione, niente scritto", "SOLO SUL PC DI BACKTEST" in tutto(rr) and not scritto(rr) and not lanci(rr))
    rr = B.gira("R11", riga=riga, pin=pin, mt5_vivo="terminal64")
    chk("R11 terminal64 vivo: stampa PID/titolo/cartella e si ferma PRIMA di scaricare", "APERTO" in tutto(rr) and "PID" in rr["p"].stdout and not scritto(rr) and not lanci(rr))
    rr = B.gira("R12", riga=riga.replace("Set-Content -LiteralPath $S -Value $t -Encoding ASCII -NoNewline;", "Set-Content -LiteralPath $S -Value ($t + 'x') -Encoding ASCII -NoNewline;"), pin=pin)
    chk("R12 file scritto con un'altra impronta: si ferma, nessun terminale", "altra impronta" in rr["p"].stdout and not lanci(rr))
    rr = B.gira("R13", riga=riga, pin=pin, muta={F_DIAG: lambda b: b + b"\n//x\n"})
    chk("R13 EA diagnostico diverso da quello pinnato: lo script si ferma sullo SHA256, nessun terminale", "SHA256" in tutto(rr) and not lanci(rr))
    rg = subprocess.run([sys.executable, os.path.join(ROOT, "backtest_pipeline", "controlla_riga.py"), "--oggetto", "riga", "--riga", os.path.join(ROOT, F_RIGA)], capture_output=True, text=True)
    chk("R14 il cancello meccanico (controlla_riga.py --oggetto riga) non trova difetti", "ESITO: nessun difetto meccanico" in rg.stdout, rg.stdout[-600:])


# ===========================================================================
def main():
    if "--genera-riga" in ARGV:
        pin = ARGV[ARGV.index("--genera-riga") + 1]
        dest = ARGV[ARGV.index("--dest") + 1] if "--dest" in ARGV else None
        genera_riga(pin, dest, "--senza-origin" in ARGV)
        return 0
    diag, ea, ps1, prova = leggi(F_DIAG), leggi(F_EA), leggi(F_PS1), leggi(F_PROVA)
    print("S) STATICO")
    bag = []
    statico(diag, ea, ps1, prova, bag)
    for b in bag:
        print("     - " + b)
    chk("S: EA diagnostico e driver passano tutti i controlli statici (%d difetti)" % len(bag), not bag)
    keys, _, _ = chiavi_ea(diag.decode("ascii", "replace"))
    lunghezza = len("[NatCla-DIAG] RIASSUNTO " + " ".join("%s=%s" % (k, "2026.06.29_23:00" if k in ("prima", "ultima", "primo_ok") else "1500/1500/1500,1500/0") for k in keys))
    chk("S: la riga RIASSUNTO, coi valori piu' lunghi, sta sotto i 2000 caratteri (%d)" % lunghezza, lunghezza < 2000)
    base = tempfile.mkdtemp(prefix="nc_diag_")
    try:
        print("P+C) BLOCCO PURO e CATENA in C++ contro il corpo VERO di CaricaDati")
        bag = []
        okc = prova_catena(diag.decode("ascii"), ea.decode("ascii", "replace"), os.path.join(base), bag)
        for b in bag:
            print("     - " + b)
        chk("P+C: casi a mano, 20000 casuali, ~6000 scenari di catena == CaricaDati (chiamate, esito, valori, errori, completamento)", okc and not bag)
        # contro-esempio: un CaricaDati con l'ordine dei BarsCalculated scambiato DEVE essere preso
        es = ea.decode("ascii", "replace").replace("if(BarsCalculated(hEma200)<n+1 || BarsCalculated(hAtrN)<n+1", "if(BarsCalculated(hAtrN)<n+1 || BarsCalculated(hEma200)<n+1")
        bag2 = []
        d2 = tempfile.mkdtemp(dir=base)
        prova_catena(diag.decode("ascii"), es, d2, bag2, ncas=500)
        chk("C contro-esempio: un CaricaDati con i BarsCalculated scambiati e' PRESO dal confronto delle chiamate", any("sequenza di chiamate DIVERSA" in b for b in bag2), bag2)
        es = ea.decode("ascii", "replace").replace("#define NC_BARRE_MIN 300", "#define NC_BARRE_MIN 250")
        bag2 = []
        d2 = tempfile.mkdtemp(dir=base)
        prova_catena(diag.decode("ascii"), es, d2, bag2, ncas=500)
        chk("C contro-esempio: un EA con NC_BARRE_MIN 250 (costanti compilate SEPARATE) e' PRESO", any("esito diverso" in b or "sequenza" in b for b in bag2), bag2)
        B = banco(keys, base)
        if not SENZA_MUTANTI:
            mutanti_ea(diag, ea, ps1, prova, base)
            mutanti_ps(B)
        if "--pin" in ARGV:
            prova_riga(ARGV[ARGV.index("--pin") + 1], B, base)
    finally:
        shutil.rmtree(base, ignore_errors=True)
    falliti = [e for e in ESITI if not e[1]]
    print("COLLAUDO NATCLA DIAG: %d controlli, %d falliti" % (len(ESITI), len(falliti)))
    return 1 if falliti else 0


if __name__ == "__main__":
    sys.exit(main())
