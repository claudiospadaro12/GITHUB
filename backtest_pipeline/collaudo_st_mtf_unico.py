#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Collaudo a secco di mql5/Indicators/ABTG_ST_MTF_Unico.mq5 (10/10/2026).

Qui NON c'e' MetaEditor: niente compila l'MQL5 e niente prova il grafico vero. Si prova:

  A) LOGICA del tasto UNICO con le funzioni pure VERE (blocco //@@STU_PURE_BEGIN..END estratto dal
     sorgente, tradotto in C++ con sostituzioni meccaniche e compilato con g++): per OGNI combinazione
     di abilitazione (8) x OGNI stato dei tre ST (8) si confrontano UNI_Acceso e UNI_Clic con una
     SPECIFICA scritta qui dal testo della richiesta (non dal codice). Piu': doppio clic, e
     STU_Coord sui quattro angoli.
  B) IDENTITA' di SW_STCore con quella della SuperWave v4.1 (carattere per carattere): il calcolo e'
     quello gia' collaudato da collaudo_superwave_v41.py, non una riscrittura.
  C) STATICA: input (nomi, tipi, default, ordine, sezioni) contro la specifica degli screenshot; API
     vietate (ordini, file, GlobalVariable, ObjectsDeleteAll); ogni nome di oggetto nasce dal prefisso
     e ogni generatore di nomi e' ripulito in DeleteAllOurs; EventSetTimer/EventKillTimer; parentesi
     bilanciate; ASCII senza BOM; indici dello stato codificato (22 caratteri).
  CONTRO-ESEMPI: mutazioni del sorgente vero che il collaudo DEVE prendere.

Uso:   python3 backtest_pipeline/collaudo_st_mtf_unico.py
Esce con 0 solo se tutto passa.
"""
import itertools
import os
import re
import subprocess
import sys
import tempfile

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
SRC = os.path.join(ROOT, "mql5/Indicators/ABTG_ST_MTF_Unico.mq5")
V41 = os.path.join(ROOT, "mql5/Indicators/ABTG_SuperWave_Dashboard_v41.mq5")
FAILS = []


def check(cond, msg, quiet=False):
    # quiet = uso interno sulle mutazioni: niente stampa e niente FAIL globale (li conta section_X)
    if quiet:
        return cond
    print(("  ok   " if cond else "  FAIL ") + msg)
    if not cond:
        FAILS.append(msg)
    return cond


def read(p):
    with open(p, "rb") as f:
        return f.read()


# ===========================================================================
# A) logica pura compilata
# ===========================================================================
def pure_block(text):
    m = re.search(r"//@@STU_PURE_BEGIN\n(.*?)//@@STU_PURE_END", text, re.S)
    return m.group(1) if m else None


def to_cpp(block):
    c = block
    c = re.sub(r"const double &(\w+)\[\]", r"const double *\1", c)
    c = re.sub(r"double &(\w+)\[\]", r"double *\1", c)
    return c


DRIVER = r"""
#include <cstdio>
#include <algorithm>
static double MathMax(double a,double b){return std::max(a,b);}
static double MathMin(double a,double b){return std::min(a,b);}
%s
int main(){
  for(int e=0;e<8;e++) for(int o=0;o<8;o++){
    bool e1=e&1,e2=e&2,e3=e&4, o1=o&1,o2=o&2,o3=o&4;
    bool lit=UNI_Acceso(e1,e2,e3,o1,o2,o3);
    bool a=o1,b=o2,c=o3; UNI_Clic(e1,e2,e3,a,b,c);
    bool lit2=UNI_Acceso(e1,e2,e3,a,b,c);
    bool a2=a,b2=b,c2=c; UNI_Clic(e1,e2,e3,a2,b2,c2);
    printf("U %%d %%d %%d %%d%%d%%d %%d %%d%%d%%d\n",e,o,lit,a,b,c,lit2,a2,b2,c2);
  }
  for(int inv=0;inv<2;inv++) for(int off=0;off<=10;off+=10) for(int tot=24;tot<=500;tot+=476) for(int pos=0;pos<=20;pos+=20)
    printf("C %%d %%d %%d %%d %%d\n",inv,off,tot,pos,STU_Coord(inv!=0,off,tot,pos));
  return 0;
}
"""


def run_pure(src_text):
    blk = pure_block(src_text)
    if blk is None:
        return None, "blocco puro non trovato"
    cpp = DRIVER % to_cpp(blk)
    with tempfile.TemporaryDirectory() as td:
        cp = os.path.join(td, "t.cpp")
        ex = os.path.join(td, "t")
        with open(cp, "w") as f:
            f.write(cpp)
        r = subprocess.run(["g++", "-std=c++11", "-Wall", "-Werror", "-O1", "-o", ex, cp],
                           capture_output=True, text=True)
        if r.returncode != 0:
            return None, "g++: " + r.stderr[:600]
        r = subprocess.run([ex], capture_output=True, text=True)
        return r.stdout, None


def spec_unico(e, o):
    """SPECIFICA dal testo della richiesta (non dal codice):
    UNICO acceso solo se tutti gli ST ABILITATI sono accesi (e ce n'e' almeno uno abilitato);
    clic: tutti accesi -> spegne tutti; altrimenti -> accende tutti; i disabilitati non partecipano."""
    en = [bool(e & 1), bool(e & 2), bool(e & 4)]
    on = [bool(o & 1), bool(o & 2), bool(o & 4)]
    E = [k for k in range(3) if en[k]]
    lit = len(E) > 0 and all(on[k] for k in E)
    after = list(on)
    for k in E:
        after[k] = not lit
    return lit, after


def judge(out, verbose):
    """True se l'uscita del C++ rispetta la specifica in tutti i casi."""
    ok = True
    rows = []
    for line in out.splitlines():
        p = line.split()
        if p[0] == "U":
            e, o, lit = int(p[1]), int(p[2]), p[3] == "1"
            after = [p[4][0] == "1", p[4][1] == "1", p[4][2] == "1"]
            lit2 = p[5] == "1"
            after2 = [p[6][0] == "1", p[6][1] == "1", p[6][2] == "1"]
            slit, safter = spec_unico(e, o)
            slit2, safter2 = spec_unico(e, sum((1 << k) for k in range(3) if safter[k]))
            good = (lit == slit and after == safter and lit2 == slit2 and after2 == safter2)
            # proprieta' richieste esplicitamente: dopo un clic, con almeno un ST abilitato,
            # gli abilitati sono TUTTI uguali (tutti accesi o tutti spenti), e due clic alternano
            E = [k for k in range(3) if (e >> k) & 1]
            if E:
                good = good and (len(set(after[k] for k in E)) == 1) and (lit2 != lit)
            ok = ok and good
            rows.append((e, o, lit, after, lit2, good))
        elif p[0] == "C":
            inv, off, tot, pos, got = map(int, p[1:])
            exp = off + tot - pos if inv else off + pos
            ok = ok and (got == exp)
            if verbose:
                check(got == exp, "STU_Coord(inv=%d,off=%d,tot=%d,pos=%d) = %d (atteso %d)" % (inv, off, tot, pos, got, exp))
    return ok, rows


def bits(o):
    return "".join("1" if (o >> k) & 1 else "0" for k in range(3))


def section_A(text):
    print("A) logica UNICO (funzioni pure vere, compilate g++ -Wall -Werror)")
    out, err = run_pure(text)
    if not check(out is not None, "estrazione + compilazione del blocco puro" + ("" if out else " (" + str(err) + ")")):
        return
    ok, rows = judge(out, verbose=True)
    check(ok, "64 casi (8 abilitazioni x 8 stati) = specifica, anche al SECONDO clic")
    print()
    print("  Tabella di verita' con i tre ST ABILITATI (InpEnableST1..3 = true):")
    print("  stato ST(2.5,3.0,3.5) | UNICO prima | dopo 1 clic     | UNICO dopo | dopo 2 clic")
    for e, o, lit, after, lit2, good in rows:
        if e != 7:
            continue
        a = "".join("1" if x else "0" for x in after)
        s2 = "000" if a == "111" else "111"
        print("        %s           |    %-6s   | %s (%s) | %-6s     | %s %s" % (
            bits(o), "VIOLA" if lit else "grigio", a,
            "SPENTI tutti" if a == "000" else "ACCESI tutti", "VIOLA" if lit2 else "grigio", s2,
            "" if good else "<-- FAIL"))
    print()
    print("  Con un ST DISABILITATO (esempio: InpEnableST2=false, il 3.0 non ha tasto):")
    for e, o, lit, after, lit2, good in rows:
        if e != 5 or (o & 2):
            continue
        a = "".join("1" if x else "0" for x in after)
        print("        %s (3.0 fuori) |    %-6s   | %s            | %-6s %s" % (
            bits(o), "VIOLA" if lit else "grigio", a, "VIOLA" if lit2 else "grigio", "" if good else "<-- FAIL"))
    zero = [r for r in rows if r[0] == 0]
    check(all((not r[2]) and r[3] == [bool(r[1] & 1), bool(r[1] & 2), bool(r[1] & 4)] for r in zero),
          "nessun ST abilitato: UNICO mai acceso e il clic non tocca niente")


# ===========================================================================
# B) SW_STCore identica alla v4.1
# ===========================================================================
def stcore(text):
    m = re.search(r"(//--- Supertrend: UNICA implementazione.*?\n  }\n)", text, re.S)
    return m.group(1) if m else None


def section_B(text):
    print("B) SW_STCore identica a quella della SuperWave v4.1")
    a = stcore(text)
    b = stcore(read(V41).decode("utf-8"))
    check(a is not None and b is not None, "funzione trovata in entrambi i file")
    check(a == b, "testo IDENTICO carattere per carattere (%d caratteri)" % (len(a) if a else 0))


# ===========================================================================
# C) statica
# ===========================================================================
SPEC = [
    ("=== Layout Pulsantiera ===", [
        ("ENUM_BASE_CORNER", "InpCorner", "CORNER_LEFT_UPPER"), ("int", "InpOffsetX", "10"),
        ("int", "InpOffsetY", "50"), ("bool", "InpHorizontalLayout", "true"), ("int", "InpButtonPadding", "1")]),
    ("=== Dimensioni UI ===", [
        ("int", "InpTFButtonWidth", "42"), ("int", "InpSTButtonWidth", "72"), ("int", "InpButtonHeight", "24"),
        ("int", "InpMainButtonWidth", "64"), ("int", "InpCommandButtonWidth", "86"),
        ("int", "InpButtonFontSize", "9"), ("string", "InpButtonFont", '"Arial"')]),
    ("=== Parametri SuperTrend ===", [
        ("int", "InpSTPeriod", "10"), ("double", "InpSTMultiplier1", "2.5"), ("double", "InpSTMultiplier2", "3.0"),
        ("double", "InpSTMultiplier3", "3.5"), ("int", "InpBarsToCalculate", "500")]),
    ("=== Abilita SuperTrend ===", [
        ("bool", "InpEnableST1", "true"), ("bool", "InpEnableST2", "true"), ("bool", "InpEnableST3", "true")]),
    ("=== DEFAULT SuperTrend Attivi ===", [
        ("bool", "InpDefaultST1", "false"), ("bool", "InpDefaultST2", "false"), ("bool", "InpDefaultST3", "true")]),
    ("=== Opzioni Avanzate ===", [
        ("bool", "InpOnlyPanelNoLines", "false"), ("bool", "InpLinesInForeground", "true"),
        ("bool", "InpPanelVisibleAtStart", "true"), ("int", "InpTimerSeconds", "1")]),
    ("=== Stile Linee SuperTrend ===", [
        ("ENUM_LINE_STYLE", "InpSTLineStyle1", "STYLE_DASH"), ("ENUM_LINE_STYLE", "InpSTLineStyle2", "STYLE_DASH"),
        ("ENUM_LINE_STYLE", "InpSTLineStyle3", "STYLE_DASH"), ("int", "InpSTLineWidth1", "1"),
        ("int", "InpSTLineWidth2", "1"), ("int", "InpSTLineWidth3", "1")]),
    ("=== Colori Linee per Timeframe ===", [
        ("color", "InpColorM1", "clrSilver"), ("color", "InpColorM3", "clrDeepSkyBlue"),
        ("color", "InpColorM5", "clrWhite"), ("color", "InpColorM15", "clrYellow"), ("color", "InpColorM30", "clrTan"),
        ("color", "InpColorH1", "clrRoyalBlue"), ("color", "InpColorH4", "clrRed"),
        ("color", "InpColorH12", "clrLightCoral"), ("color", "InpColorD1", "clrLime"),
        ("color", "InpColorW1", "clrOrange"), ("color", "InpColorMN1", "clrAqua")]),
    ("=== Label Livelli SuperTrend ===", [
        ("bool", "InpShowLevelLabels", "true"), ("string", "InpLabelFont", '"Arial Narrow"'),
        ("int", "InpLabelFontSize", "8"), ("bool", "InpLabelShowMultiplier", "true"),
        ("bool", "InpLabelShowPrice", "false"), ("string", "InpLabelUpText", '"VERDE"'),
        ("string", "InpLabelDownText", '"ROSSO"'), ("bool", "InpLabelColorByTrend", "true"),
        ("color", "InpLabelUpColor", "clrLime"), ("color", "InpLabelDownColor", "clrRed"),
        ("bool", "InpLabelSameColorAsLine", "false"), ("color", "InpFixedLabelColor", "clrWhite"),
        ("int", "InpLabelRightOffsetPx", "280"), ("int", "InpLabelVerticalOffsetPx", "-8")]),
    ("=== DEFAULT Timeframe Attivi ===", [
        ("bool", "InpDefault" + t, d) for t, d in [
            ("M1", "false"), ("M3", "false"), ("M5", "false"), ("M15", "false"), ("M30", "false"), ("H1", "true"),
            ("H4", "true"), ("H12", "true"), ("D1", "true"), ("W1", "false"), ("MN1", "false")]]),
    ("=== Colori Pulsanti ===", [
        ("color", "InpButtonTextColor", "clrWhite"), ("color", "InpButtonInactiveColor", "clrDimGray"),
        ("color", "InpButtonMainColor", "clrForestGreen"), ("color", "InpButtonOnColor", "clrLime"),
        ("color", "InpButtonOffColor", "clrRed"), ("color", "InpButtonDefaultColor", "clrRoyalBlue"),
        ("color", "InpButtonSTActiveColor", "clrCrimson")]),
    ("=== Pulsante UNICO ===", [
        ("bool", "InpShowUnico", "true"), ("string", "InpUnicoText", '"UNICO"'), ("int", "InpUnicoWidth", "64"),
        ("color", "InpUnicoOnColor", "clrDarkViolet")]),
]


def parse_inputs(text):
    seq = []
    for line in text.splitlines():
        g = re.match(r'\s*input\s+group\s+"([^"]*)"', line)
        if g:
            seq.append(("G", g.group(1)))
            continue
        m = re.match(r'\s*input\s+(\w+)\s+(\w+)\s*=\s*("[^"]*"|[^;]+?)\s*;\s*//\s*(.*)$', line)
        if m:
            seq.append(("I", (m.group(1), m.group(2), m.group(3).strip()), m.group(4)))
    return seq


def strip_code(text):
    """toglie commenti e stringhe (per bilanciamento e ricerca di API)"""
    out = re.sub(r"//[^\n]*", "", text)
    out = re.sub(r"/\*.*?\*/", "", out, flags=re.S)
    out = re.sub(r'"(\\.|[^"\\])*"', '""', out)
    out = re.sub(r"'(\\.|[^'\\])'", "''", out)
    return out


def static_ok(text, verbose=True):
    q = not verbose
    ok = True
    seq = parse_inputs(text)
    exp = []
    for g, items in SPEC:
        exp.append(("G", g))
        for it in items:
            exp.append(("I", it))
    got = [(s[0], s[1]) for s in seq]
    ok &= check(got == exp, "input: %d voci (sezioni+parametri) = specifica, stessi nomi/tipi/default/ordine"
                % len(exp), q)
    if verbose and got != exp:
        for k, (a, b) in enumerate(itertools.zip_longest(got, exp)):
            if a != b:
                print("       prima differenza alla voce %d: sorgente %s, atteso %s" % (k, a, b))
                break
    descr = [s for s in seq if s[0] == "I"]
    ok &= check(all(s[2].startswith(s[1][1] + " - ") for s in descr),
                "ogni descrizione comincia col NOME dell'input (confronto riga per riga con l'originale)", q)
    code = strip_code(text)
    for bad in ["OrderSend", "OrderSendAsync", "CTrade", "PositionClose", "FileOpen", "FileWrite",
                "GlobalVariableSet", "GlobalVariableTemp", "ObjectsDeleteAll", "#include", "WebRequest",
                "SendNotification", "SendMail", "ChartSetInteger", "ChartSetString", "ChartSetDouble",
                "ChartSetSymbolPeriod", "ChartApplyTemplate", "Sleep"]:
        ok &= check(bad not in code, "API vietata assente: " + bad, q)
    # nomi oggetto: solo da Name*(), e Name*() costruiti solo su PFX
    gens = re.findall(r"^string (Name\w+)\([^)]*\)\s*\{\s*return PFX\+", text, re.M)
    ok &= check(sorted(gens) == sorted(["NameState", "NameMain", "NameTF", "NameST", "NameUnico", "NameDef",
                                        "NameL", "NameT"]),
                "8 generatori di nomi, tutti 'return PFX+...': %s" % ",".join(gens), q)
    ok &= check(re.search(r'#define PFX\s+"ABTGSTU_"', text) is not None, 'prefisso "ABTGSTU_"', q)
    creates = re.findall(r"ObjectCreate\(0,(\w+),", code)
    ok &= check(set(creates) <= {"nm", "nl", "nt"} and len(creates) == 4,
                "ObjectCreate solo su variabili nm/nl/nt (%d chiamate)" % len(creates), q)
    # ogni variabile nm/nl/nt passata a ObjectCreate viene da un generatore Name*()
    assigns = re.findall(r"string (nm|nl|nt)=(\w+)", code)
    ok &= check(all(src.startswith("Name") or src == "gBN" for _, src in assigns) and len(assigns) >= 4,
                "nm/nl/nt assegnati solo da Name*() o dall'elenco tasti gBN (riempito solo con Name*())", q)
    badd = re.findall(r"BAdd\((\w+)\(", code)
    ok &= check(len(badd) >= 5 and all(b.startswith("Name") for b in badd),
                "BAdd chiamato solo con Name*(): %s" % ",".join(sorted(set(badd))), q)
    dm = re.search(r"void DeleteAllOurs\(const bool keepState\)(.*?)\n  }\n", text, re.S)
    body = dm.group(1) if dm else ""
    ok &= check(all(("DelObj(" + g + "(") in body for g in gens),
                "DeleteAllOurs toglie TUTTI i generatori di nomi", q)
    od = re.search(r"void OnDeinit\(const int reason\)(.*?)\n  }\n", text, re.S)
    odb = od.group(1) if od else ""
    ok &= check("EventKillTimer();" in odb and "DeleteAllOurs(reason==REASON_CHARTCHANGE)" in odb,
                "OnDeinit: EventKillTimer + DeleteAllOurs (STATO tenuto solo al cambio simbolo/TF)", q)
    ok &= check("EventSetTimer(gTimerSec)" in code and "ClampInt(InpTimerSeconds,1,3600)" in code,
                "EventSetTimer(InpTimerSeconds) con minimo 1 s", q)
    for o, c in [("(", ")"), ("{", "}"), ("[", "]")]:
        ok &= check(code.count(o) == code.count(c), "parentesi %s%s bilanciate (%d)" % (o, c, code.count(o)), q)
    for p in ["indicator_chart_window", "indicator_buffers 0", "indicator_plots   0", 'version     "1.00"']:
        ok &= check(p in text, "#property " + p, q)
    # stato codificato: 5 + 1 + 1 + 11 + 1 + 3 = 22, separatori in 6 e 18, TF da 7, ST da 19
    ok &= check("StringLen(s)!=22" in text and "StringGetCharacter(s,6)!='|'" in text and
                "StringGetCharacter(s,18)!='|'" in text and "7+i" in text and "19+j" in text,
                "indici dello stato codificato coerenti con 'STU1|P|' + 11 TF + '|' + 3 ST = 22", q)
    # i TF dei tasti: 11, nell'ordine dichiarato, M3 e H12 nativi
    tfm = re.search(r"gTf\[STU_NTF\]\s*=\s*\{([^}]*)\}", text)
    tfs = [t.strip() for t in tfm.group(1).split(",")] if tfm else []
    ok &= check(tfs == ["PERIOD_" + t for t in ["M1", "M3", "M5", "M15", "M30", "H1", "H4", "H12", "D1", "W1", "MN1"]],
                "11 TF nell'ordine M1 M3 M5 M15 M30 H1 H4 H12 D1 W1 MN1", q)
    # UNICO a DESTRA dei tre ST: in BuildButtons l'ordine delle BAdd e' ST -> UNICO -> DEFAULT
    bb = re.search(r"void BuildButtons\(\)(.*?)\n  }\n", text, re.S).group(1)
    i_st, i_un, i_df = bb.find("BAdd(NameST("), bb.find("BAdd(NameUnico()"), bb.find("BAdd(NameDef()")
    once = all(bb.count(t) == 1 for t in ["BAdd(NameMain()", "BAdd(NameTF(", "BAdd(NameST(",
                                          "BAdd(NameUnico()", "BAdd(NameDef()"])
    guard = re.search(r"if\(InpShowUnico && NumStEn\(\)>0\)\s*\{\s*bool u=UnicoOn\(\);\s*BAdd\(NameUnico\(\)", bb)
    ok &= check(once and guard is not None and 0 < i_st < i_un < i_df,
                "BuildButtons: ogni tasto aggiunto UNA volta, ordine ST -> UNICO -> DEFAULT, guardia di UNICO "
                "= InpShowUnico && almeno un ST abilitato", q)
    return ok


def section_C(raw):
    print("C) statica")
    check(not raw.startswith(b"\xef\xbb\xbf"), "nessun BOM")
    try:
        raw.decode("ascii")
        asc = True
    except UnicodeDecodeError:
        asc = False
    check(asc, "ASCII puro (come ABTG_Supertrend/Pulsanti_Grafico/ForzaFX)")
    check(b"\r\n" not in raw, "fine riga LF (come gli altri file della cartella)")
    static_ok(raw.decode("ascii", "replace"), verbose=True)


# ===========================================================================
# CONTRO-ESEMPI
# ===========================================================================
def mutants(text):
    m = []
    m.append(("clic che spegne se ALMENO UNO e' acceso",
              text.replace("bool target=!UNI_Acceso(e1,e2,e3,o1,o2,o3);",
                           "bool target=!(o1||o2||o3);")))
    m.append(("clic che ignora l'abilitazione (tocca anche gli ST disabilitati)",
              text.replace("   if(e1) o1=target;\n   if(e2) o2=target;\n   if(e3) o3=target;",
                           "   o1=target;\n   o2=target;\n   o3=target;")))
    m.append(("UNICO acceso con zero ST abilitati",
              text.replace("if(!e1 && !e2 && !e3) return false;", "if(!e1 && !e2 && !e3) return true;")))
    m.append(("UNICO acceso se ne basta uno acceso",
              text.replace("   if(e1 && !o1) return false;\n   if(e2 && !o2) return false;\n   if(e3 && !o3) return false;\n   return true;",
                           "   return (e1&&o1)||(e2&&o2)||(e3&&o3);")))
    m.append(("clic che inverte ognuno (toggle singolo) invece di allinearli",
              text.replace("   if(e1) o1=target;\n   if(e2) o2=target;\n   if(e3) o3=target;",
                           "   if(e1) o1=!o1;\n   if(e2) o2=!o2;\n   if(e3) o3=!o3;")))
    m.append(("angolo destro col segno sbagliato",
              text.replace("if(inverti) return off+tot-pos;", "if(inverti) return off-tot+pos;")))
    return m


def static_mutants(text):
    m = []
    m.append(("default InpDefaultST3 cambiato", text.replace("InpDefaultST3 = true;", "InpDefaultST3 = false;")))
    m.append(("UNICO spostato DOPO DEFAULT",
              text.replace('      if(InpShowUnico && NumStEn()>0)', '      if(false)', 1)
              .replace('      BAdd(NameDef(),"DEFAULT"',
                       '      BAdd(NameDef(),"DEFAULT",gWCmd,InpButtonDefaultColor,"x");\n'
                       '      if(InpShowUnico) BAdd(NameUnico(),InpUnicoText,gWUni,InpUnicoOnColor,"x");\n'
                       '      BAdd(NameDef(),"DEFAULT"', 1)))
    m.append(("ObjectsDeleteAll globale aggiunto",
              text.replace("   EventKillTimer();\n", "   EventKillTimer();\n   ObjectsDeleteAll(0);\n", 1)))
    m.append(("generatore di nomi dimenticato in DeleteAllOurs",
              text.replace("   DelObj(NameUnico());\n   DelObj(NameDef());\n   for(int i=0;i<STU_NTF;i++)\n      for(int j=0;j<STU_NST;j++)\n        {\n         DelObj(NameL",
                           "   DelObj(NameDef());\n   for(int i=0;i<STU_NTF;i++)\n      for(int j=0;j<STU_NST;j++)\n        {\n         DelObj(NameL", 1)))
    m.append(("sezioni scambiate",
              text.replace('input group "=== Abilita SuperTrend ==="', 'input group "=== XX ==="', 1)))
    m.append(("ordine dei TF sbagliato (H12 prima di H4)",
              text.replace("PERIOD_H4,PERIOD_H12", "PERIOD_H12,PERIOD_H4", 1)))
    return m


def section_X(text):
    print("X) contro-esempi: mutazioni del sorgente vero che DEVONO essere prese")
    for name, mt in mutants(text):
        check(mt != text, "mutazione applicata: " + name)
        out, err = run_pure(mt)
        caught = out is None or not judge(out, verbose=False)[0]
        check(caught, "PRESA: " + name)
    for name, mt in static_mutants(text):
        check(mt != text, "mutazione applicata: " + name)
        check(not static_ok(mt, verbose=False), "PRESA: " + name)


def main():
    raw = read(SRC)
    text = raw.decode("utf-8")
    section_A(text)
    print()
    section_B(text)
    print()
    section_C(raw)
    print()
    section_X(text)
    print()
    real = list(FAILS)
    if real:
        print("ESITO: FAIL (%d)" % len(real))
        for f in real:
            print("  - " + f)
        return 1
    print("ESITO: TUTTO OK")
    return 0


if __name__ == "__main__":
    sys.exit(main())
