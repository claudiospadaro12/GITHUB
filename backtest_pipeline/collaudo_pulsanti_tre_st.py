#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Collaudo della v1.01 di mql5/Indicators/ABTG_Pulsanti_Grafico.mq5 (06/10/2026): Supertrend a TRE livelli
(2,5 / 3,0 / 3,5) e indici dei buffer/plot dopo l'aggiunta. Complementare a collaudo_pulsanti_grafico.py
(che resta il collaudo generale e va rilanciato anche lui).

Qui NON c'e' MetaEditor: niente compila l'MQL5 e niente prova il grafico vero. Si prova:

  A) STRUTTURA, su v1.00 (dalla storia git, SHA256 verificato) e su v1.01: indicator_buffers/plots contro le
     SetIndexBuffer (indici 0..n-1 una volta, nomi una volta, buffer disegnati PRIMA di quelli di calcolo);
     per ogni plot il buffer che lo alimenta (camminando i plot nell'ordine, candele colorate = 5 buffer,
     linea = 1) e, per QUEL buffer, l'etichetta #property, il colore impostato in OnInit
     (PlotIndexSetInteger ... PLOT_LINE_COLOR), lo spessore (PLOT_LINE_WIDTH) e l'etichetta runtime
     (PLOT_LABEL) attesi. Ogni indice letterale di PlotIndexSet* < indicator_plots. FillDisplay scrive
     ogni buffer disegnato UNA volta. => un riferimento rimasto al VECCHIO indice viene trovato.
  B) NUMERI, con le funzioni pure VERE estratte dai due file e compilate C++, e le chiamate di OnCalculate
     e FillDisplay ESTRATTE dal sorgente (non ricopiate a mano), su barre reali XAUUSD (M5 e H1 da M1
     HistData in repo), calcolo intero e incrementale come OnCalculate (barra in formazione prima falsa
     poi vera):
       1. linea 3,0 (bStSu/bStGiu) della v1.01 == quella della v1.00, bit per bit;
       2. linea 3,5 della v1.01 == Supertrend del SETUP (kDir2/kVal2) quando i moltiplicatori coincidono;
       3. linee 2,5 e 3,5 == specchio Python (py_stcore del collaudo generale), bit per bit;
       4. per ogni livello e ogni barra: MAI su e giu' insieme; da 'periodo' in poi sempre una delle due.
  CONTRO-ESEMPI costruiti sul sorgente vero (devono essere PRESI): EMA 200 colorata sul plot vecchio (9);
  buffer EMA 9 e ST 2,5 scambiati in SetIndexBuffer; linea 3,0 calcolata col moltiplicatore 2,5; ST giu'
  disegnata col verso su; ST 2,5 col periodo sbagliato.

Uso:   python3 backtest_pipeline/collaudo_pulsanti_tre_st.py
Esce con 0 solo se tutto passa. NON prova la compilazione MQL5, iMA (EMA degli altri TF) ne' il grafico.
"""
import hashlib
import os
import re
import subprocess
import sys
import tempfile

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
sys.path.insert(0, os.path.join(ROOT, "backtest_pipeline"))
sys.argv = [sys.argv[0], "--rapido"] + sys.argv[1:]      # il modulo importato legge 2024-2026 (piu' veloce)
import collaudo_pulsanti_grafico as CG                    # noqa: E402

SRC = os.path.join(ROOT, "mql5/Indicators/ABTG_Pulsanti_Grafico.mq5")
REL = "mql5/Indicators/ABTG_Pulsanti_Grafico.mq5"
V100_COMMIT = "791da022"
V100_SHA = "eeb5b1af66aad64225b18feaaa4c165189dfc3dd51bc54013ac86fa3883f1e00"
FAILS = []


def check(cond, msg):
    print(("  ok   " if cond else "  FAIL ") + msg)
    if not cond:
        FAILS.append(msg)
    return cond


def v100():
    r = subprocess.run(["git", "-C", ROOT, "show", "%s:%s" % (V100_COMMIT, REL)], capture_output=True)
    if r.returncode != 0:
        return None
    return r.stdout


# ===========================================================================
# A) struttura buffer / plot
# ===========================================================================
PER_TYPE = {"DRAW_COLOR_CANDLES": 5, "DRAW_LINE": 1}
# buffer disegnato -> (etichetta #property, input del colore in OnInit, variabile spessore, etichetta runtime)
EXPECT = {
    "bHo": ("HA Apertura;HA Massimo;HA Minimo;HA Chiusura", None, None, None),
    "bBBu": ("BB alta", "InpColBB", None, None),
    "bBBm": ("BB media", "InpColBB", None, None),
    "bBBl": ("BB bassa", "InpColBB", None, None),
    "bStSu": ("Supertrend su", "InpColStSu", "w2", "gStM"),
    "bStGiu": ("Supertrend giu", "InpColStGiu", "w2", "gStM"),
    "bSt1Su": ("Supertrend 2.5 su", "InpColSt1Su", "w1", "gSt1M"),
    "bSt1Giu": ("Supertrend 2.5 giu", "InpColSt1Giu", "w1", "gSt1M"),
    "bSt3Su": ("Supertrend 3.5 su", "InpColSt3Su", "w3", "gSt3M"),
    "bSt3Giu": ("Supertrend 3.5 giu", "InpColSt3Giu", "w3", "gSt3M"),
    "bE9": ("EMA 9", "InpColEma9", None, "gP9"),
    "bE21": ("EMA 21", "InpColEma21", None, "gP21"),
    "bE50": ("EMA 50", "InpColEma50", None, "gP50"),
    "bE200": ("EMA 200", "InpColEma200", None, "gP200"),
}


def struttura(src, nome, v101):
    """lista di problemi (vuota = ok)"""
    prob = []
    code = CG.strip_code(src)
    nb = int(re.search(r"#property\s+indicator_buffers\s+(\d+)", src).group(1))
    npl = int(re.search(r"#property\s+indicator_plots\s+(\d+)", src).group(1))
    sib = re.findall(r"SetIndexBuffer\(\s*(\d+)\s*,\s*(\w+)\s*,\s*(INDICATOR_\w+)\s*\)", code)
    idx = sorted(int(a) for a, _, _ in sib)
    if idx != list(range(nb)):
        prob.append("SetIndexBuffer: indici %s invece di 0..%d" % (idx, nb - 1))
    names = [b for _, b, _ in sib]
    if len(set(names)) != len(names):
        prob.append("un buffer legato a due indici: %s" % sorted(set(n for n in names if names.count(n) > 1)))
    decl = set()
    for m in re.finditer(r"^double\s+([^;]+);", code, re.M):
        for p in m.group(1).split(","):
            mm = re.match(r"\s*(\w+)\s*\[\s*\]", p)
            if mm:
                decl.add(mm.group(1))
    decl -= set(re.findall(r"ArrayResize\(\s*(\w+)\s*,", code))     # array di lavoro (gItP...), non buffer
    if decl != set(names):
        prob.append("array double[] globali non legati / legati non dichiarati: %s / %s"
                    % (sorted(decl - set(names)), sorted(set(names) - decl)))
    data = sorted((int(a), b) for a, b, k in sib if k in ("INDICATOR_DATA", "INDICATOR_COLOR_INDEX"))
    calc = sorted(int(a) for a, b, k in sib if k == "INDICATOR_CALCULATIONS")
    if data and calc and max(i for i, _ in data) >= min(calc):
        prob.append("buffer di calcolo prima di un buffer disegnato")
    byidx = dict(data)
    # plot -> buffer che lo alimenta
    pos = 0
    plot_buf = {}
    for p in range(1, npl + 1):
        ty = re.search(r"#property\s+indicator_type%d\s+(\w+)" % p, src)
        if not ty:
            prob.append("plot %d senza indicator_type" % p)
            continue
        k = PER_TYPE[ty.group(1)]
        plot_buf[p - 1] = byidx.get(pos)
        pos += k
    if pos != len(data):
        prob.append("i plot consumano %d buffer, quelli disegnati sono %d" % (pos, len(data)))
    for m in re.finditer(r"#property\s+indicator_(?:type|label|color|width|style)(\d+)", src):
        if int(m.group(1)) > npl:
            prob.append("#property per il plot %s oltre indicator_plots=%d" % (m.group(1), npl))
    # indici letterali di PlotIndexSet*
    for m in re.finditer(r"PlotIndexSet(?:Integer|Double|String)\(\s*(\d+)\s*,", code):
        if int(m.group(1)) >= npl:
            prob.append("PlotIndexSet* sull'indice %s >= indicator_plots=%d" % (m.group(1), npl))
    col = dict((int(a), b) for a, b in re.findall(r"PlotIndexSetInteger\(\s*(\d+)\s*,\s*PLOT_LINE_COLOR\s*,\s*(\w+)\s*\)", code))
    wid = dict((int(a), b) for a, b in re.findall(r"PlotIndexSetInteger\(\s*(\d+)\s*,\s*PLOT_LINE_WIDTH\s*,\s*(\w+)\s*\)", code))
    lab = {}
    for m in re.finditer(r"PlotIndexSetString\(\s*(\d+)\s*,\s*PLOT_LABEL\s*,([^;]*)\);", src):
        lab[int(m.group(1))] = m.group(2)
    for p0, b in sorted(plot_buf.items()):
        if b not in EXPECT:
            prob.append("plot %d alimentato da '%s' (sconosciuto)" % (p0, b))
            continue
        elab, ecol, ewid, elab_rt = EXPECT[b]
        pl = re.search(r'#property\s+indicator_label%d\s+"([^"]*)"' % (p0 + 1), src)
        if not pl or pl.group(1) != elab:
            prob.append("plot %d (%s): etichetta #property %s, attesa '%s'" % (p0, b, pl.group(1) if pl else None, elab))
        if ecol is not None and col.get(p0) != ecol:
            prob.append("plot %d (%s): colore %s, atteso %s" % (p0, b, col.get(p0), ecol))
        if v101 and ewid is not None and wid.get(p0) != ewid:
            prob.append("plot %d (%s): spessore %s, atteso %s" % (p0, b, wid.get(p0), ewid))
        if elab_rt is not None and p0 in lab and elab_rt not in lab[p0]:
            prob.append("plot %d (%s): PLOT_LABEL %s non usa %s" % (p0, b, lab[p0].strip(), elab_rt))
        if v101 and elab_rt is not None and b.startswith("bSt") and p0 not in lab:
            prob.append("plot %d (%s): manca PLOT_LABEL" % (p0, b))
    for p0 in col:
        if p0 not in plot_buf:
            prob.append("colore impostato sul plot %d che non esiste" % p0)
    # FillDisplay scrive ogni buffer disegnato UNA volta
    fd = CG.func_body(src, "FillDisplay")
    for _, b in data:
        n = len(re.findall(r"\b%s\[i\]\s*=" % b, fd))
        attese = 2 if b.startswith("bH") else 1          # Heikin Ashi: un ramo acceso e uno spento
        if n != attese:
            prob.append("FillDisplay scrive %s %d volte (attese %d)" % (b, n, attese))
    # residui del vecchio numero di plot
    if v101 and re.search(r"for\s*\(\s*int\s+p\s*=\s*0\s*;\s*p\s*<\s*10\s*;", code):
        prob.append("ciclo PLOT_EMPTY_VALUE fermo a 10 plot")
    return prob, nb, npl, plot_buf


# ===========================================================================
# B) numeri: chiamate di OnCalculate/FillDisplay ESTRATTE dal sorgente, funzioni pure vere in C++
# ===========================================================================
PARAMS = "int gStP=10, gBBP=20; double gStM=3.0, gSuM=3.5, gSt1M=2.5, gSt3M=3.5;\n" \
         "bool gOn[8]={false,false,false,false,true,false,false,false}; bool on1=true, on3=true;\n#define PG_T_ST 4\n"


def estrai(src):
    oc = CG.func_body(src, "OnCalculate")
    calls = re.findall(r"SW_STCore\(high,low,close,rates_total,start,(\w+),(\w+),(\w+),(\w+),(\w+),(\w+),(\w+)\);", oc)
    fd = CG.func_body(src, "FillDisplay")
    disp = re.findall(r"\b(bSt\w*)\[i\]\s*=\s*PG_StLinea\(([^;]*)\);", fd)
    return calls, disp


def driver(calls, disp, out_names):
    arrs = sorted(set(x for c in calls for x in c[2:]) | set(d for d, _ in disp) |
                  set(x for _, a in disp for x in re.findall(r"(\w+)\[i\]", a)))
    s = '#include "shim.h"\n#include "pure.mqh"\n' + PARAMS
    s += "int main(){ int n; if(scanf(\"%d\",&n)!=1) return 2;\n"
    s += " std::vector<double> H(n),L(n),C(n);\n for(int i=0;i<n;i++) if(scanf(\"%lf %lf %lf\",&H[i],&L[i],&C[i])!=3) return 2;\n"
    for mode in ("F", "I"):
        for a in arrs:
            s += " std::vector<double> %s_%s(n,0.0);\n" % (a, mode)
    def corpo(mode, hh, ll, cc, m, fr):
        t = ""
        for per, mult, atr, up, dn, dr, val in calls:
            t += "   SW_STCore(%s,%s,%s,%s,%s,%s,%s,%s_%s.data(),%s_%s.data(),%s_%s.data(),%s_%s.data(),%s_%s.data());\n" % (
                hh, ll, cc, m, fr, per, mult, atr, mode, up, mode, dn, mode, dr, mode, val, mode)
        t += "   for(int i=%s;i<%s;i++){\n" % (fr, m)
        for d, args in disp:
            a = [x.strip() for x in args.split(",")]
            a[1] = a[1].replace("[i]", "_%s[i]" % mode)
            a[2] = a[2].replace("[i]", "_%s[i]" % mode)
            t += "     %s_%s[i]=PG_StLinea(%s);\n" % (d, mode, ",".join(a))
        t += "   }\n"
        return t
    s += " {\n" + corpo("F", "H.data()", "L.data()", "C.data()", "n", "0") + " }\n"
    s += " std::vector<double> HP=H,LP=L,CP=C;\n for(int m=1;m<=n;m++){ for(int pass=0;pass<2;pass++){\n"
    s += "   if(pass==0){ HP[m-1]=H[m-1]+3.0; LP[m-1]=L[m-1]-2.0; CP[m-1]=C[m-1]+1.5; } else { HP[m-1]=H[m-1]; LP[m-1]=L[m-1]; CP[m-1]=C[m-1]; }\n"
    s += "   int fr=m-1;\n" + corpo("I", "HP.data()", "LP.data()", "CP.data()", "m", "fr") + " } }\n"
    s += " for(int i=0;i<n;i++){\n"
    for mode in ("F", "I"):
        for a in out_names:
            s += "  printf(\"%%a \", %s_%s[i]);\n" % (a, mode)
    s += "  printf(\"\\n\"); }\n return 0; }\n"
    return s


def gira(src, calls, disp, out_names, h, l, c, tmp, tag):
    d = os.path.join(tmp, tag)
    os.makedirs(d)
    for nm, txt in (("shim.h", CG.SHIM), ("pure.mqh", CG.to_cxx(CG.pure_block(src))), ("drv.cpp", driver(calls, disp, out_names))):
        with open(os.path.join(d, nm), "w") as f:
            f.write(txt)
    exe = os.path.join(d, "drv")
    r = subprocess.run(["g++", "-std=c++17", "-O0", "-ffp-contract=off", "-o", exe, os.path.join(d, "drv.cpp")],
                       capture_output=True, text=True)
    if r.returncode != 0:
        return None, r.stderr[:800]
    inp = "%d\n" % len(c) + "\n".join("%r %r %r" % (a, b, x) for a, b, x in zip(h, l, c)) + "\n"
    r = subprocess.run([exe], input=inp, capture_output=True, text=True)
    if r.returncode != 0:
        return None, "driver uscito con %d" % r.returncode
    k = len(out_names)
    out = {}
    rows = [ln.split() for ln in r.stdout.strip().split("\n")]
    for j, a in enumerate(out_names):
        out[a + "_F"] = [float.fromhex(x[j]) for x in rows]
        out[a + "_I"] = [float.fromhex(x[k + j]) for x in rows]
    return out, ""


def serie_reali():
    rows = CG.load_real()
    if not rows:
        return []
    out = []
    for mins, n, lab in ((5, 8000, "XAUUSD M5 reale"), (60, 6000, "XAUUSD H1 reale")):
        bars = CG.resample(rows, mins)[-n:]
        o, h, l, c = CG.ohlc(bars)
        out.append((lab, h, l, c))
    return out


def confronta(a, b):
    return sum(1 for x, y in zip(a, b) if x != y) + abs(len(a) - len(b))


def numeri(src1, src0, series, tmp, tag):
    """ritorna dict di conteggi di differenze/violazioni (0 = ok)"""
    calls1, disp1 = estrai(src1)
    calls0, disp0 = estrai(src0)
    res = {}
    for lab, h, l, c in series:
        o1, e1 = gira(src1, calls1, disp1, ["bStSu", "bStGiu", "bSt1Su", "bSt1Giu", "bSt3Su", "bSt3Giu", "kDir2", "kVal2"],
                      h, l, c, tmp, tag + "_1_" + lab.replace(" ", "_"))
        o0, e0 = gira(src0, calls0, disp0, ["bStSu", "bStGiu", "kDir2", "kVal2"], h, l, c, tmp, tag + "_0_" + lab.replace(" ", "_"))
        if o1 is None or o0 is None:
            res[lab] = {"compila": 1, "err": e1 or e0}
            continue
        r = {}
        # 1. linea 3,0 identica alla v1.00 (intero e incrementale)
        r["3,0 == v1.00"] = sum(confronta(o1[x + m], o0[x + m]) for x in ("bStSu", "bStGiu") for m in ("_F", "_I"))
        # setup intatto
        r["setup == v1.00"] = sum(confronta(o1[x + m], o0[x + m]) for x in ("kDir2", "kVal2") for m in ("_F", "_I"))
        # incrementale == intero
        r["incrementale == intero"] = sum(confronta(o1[x + "_F"], o1[x + "_I"]) for x in
                                          ("bStSu", "bStGiu", "bSt1Su", "bSt1Giu", "bSt3Su", "bSt3Giu"))
        # 2. linea 3,5 == Supertrend del setup (moltiplicatori uguali di default)
        su35 = [v if d == 1.0 else CG.DBL_MAX for d, v in zip(o1["kDir2_F"], o1["kVal2_F"])]
        gi35 = [v if d == -1.0 else CG.DBL_MAX for d, v in zip(o1["kDir2_F"], o1["kVal2_F"])]
        r["3,5 == setup"] = confronta(o1["bSt3Su_F"], su35) + confronta(o1["bSt3Giu_F"], gi35)
        # 3. specchio Python
        n = len(c)
        for mult, su, gi in ((2.5, "bSt1Su", "bSt1Giu"), (3.5, "bSt3Su", "bSt3Giu"), (3.0, "bStSu", "bStGiu")):
            a, u, dn, dr, v = CG.st_full(h, l, c, 10, mult)
            ps = [v[i] if dr[i] == 1.0 else CG.DBL_MAX for i in range(n)]
            pg = [v[i] if dr[i] == -1.0 else CG.DBL_MAX for i in range(n)]
            r["%.1f == specchio Python" % mult] = confronta(o1[su + "_F"], ps) + confronta(o1[gi + "_F"], pg)
        # 4. mai su e giu' insieme; da 'periodo' in poi sempre una
        viol = 0
        for su, gi in (("bStSu", "bStGiu"), ("bSt1Su", "bSt1Giu"), ("bSt3Su", "bSt3Giu")):
            for i in range(n):
                a_, b_ = o1[su + "_F"][i] != CG.DBL_MAX, o1[gi + "_F"][i] != CG.DBL_MAX
                if (a_ and b_) or (i >= 10 and not (a_ or b_)) or (i < 10 and (a_ or b_)):
                    viol += 1
        r["su/giu' esclusive"] = viol
        # informativo: quante barre con i tre livelli nello stesso verso
        dirs = [[1 if o1[s + "_F"][i] != CG.DBL_MAX else -1 for s in ("bSt1Su", "bStSu", "bSt3Su")] for i in range(10, n)]
        r["_concordi"] = sum(1 for d in dirs if d[0] == d[1] == d[2]) / float(len(dirs))
        res[lab] = r
    return res


def main():
    print("== Collaudo v1.01 ABTG_Pulsanti_Grafico: tre Supertrend + indici buffer/plot ==")
    src1 = CG.read(SRC)
    raw0 = v100()
    if not check(raw0 is not None, "v1.00 letta dalla storia git (%s)" % V100_COMMIT):
        sys.exit(1)
    check(hashlib.sha256(raw0).hexdigest() == V100_SHA, "v1.00 = SHA256 %s... (il file del cancello del 02/10)" % V100_SHA[:12])
    src0 = raw0.decode("latin-1")
    check('#property version   "1.01"' in src1, "versione 1.01 dichiarata")

    print("== A) STRUTTURA buffer/plot ==")
    p0, nb0, npl0, pb0 = struttura(src0, "v1.00", False)
    check(not p0, "v1.00: %d buffer, %d plot, ogni plot col suo buffer/etichetta/colore (contro-prova del controllore) %s" % (nb0, npl0, p0))
    p1, nb1, npl1, pb1 = struttura(src1, "v1.01", True)
    check(not p1, "v1.01: %d buffer, %d plot, ogni plot col suo buffer/etichetta/colore/spessore %s" % (nb1, npl1, p1))
    check((nb1, npl1) == (46, 14), "v1.01: 46 buffer (34 + 4 disegnati + 8 di calcolo) e 14 plot (10 + 4)")
    print("       plot -> buffer v1.01: %s" % ", ".join("%d:%s" % (k, v) for k, v in sorted(pb1.items())))
    # i plot che c'erano conservano l'ordine relativo, i nuovi stanno fra ST 3,0 e le EMA
    old_order = [pb0[k] for k in sorted(pb0)]
    new_order = [pb1[k] for k in sorted(pb1) if pb1[k] in old_order]
    check(old_order == new_order, "ordine relativo dei plot della v1.00 invariato (%s)" % new_order)
    ins = [pb1[k] for k in sorted(pb1) if pb1[k] not in old_order]
    first_new = min(k for k in pb1 if pb1[k] in ins)
    check(ins == ["bSt1Su", "bSt1Giu", "bSt3Su", "bSt3Giu"] and pb1[first_new - 1] == "bStGiu" and pb1[first_new + 4] == "bE9",
          "nuovi plot 2,5 e 3,5 DOPO lo ST 3,0 e PRIMA delle EMA (che restano disegnate sopra a tutto)")
    # contro-esempi strutturali
    for lab, old, new in (
            ("EMA 200 colorata sul plot vecchio (9)", "PlotIndexSetInteger(13,PLOT_LINE_COLOR,InpColEma200);",
             "PlotIndexSetInteger(9,PLOT_LINE_COLOR,InpColEma200);"),
            ("buffer EMA 9 e ST 2,5 scambiati", "SetIndexBuffer(10,bSt1Su, INDICATOR_DATA)", "SetIndexBuffer(10,bE9, INDICATOR_DATA)"),
            ("ciclo del valore vuoto fermo a 10 plot", "for(int p=0;p<PG_NPLOT;p++)", "for(int p=0;p<10;p++)"),
            ("spessore 2,5 sul plot del 3,5", "PlotIndexSetInteger(8,PLOT_LINE_WIDTH,w3);", "PlotIndexSetInteger(8,PLOT_LINE_WIDTH,w1);"),
            ("indicator_plots non aggiornato", "#property indicator_plots   14", "#property indicator_plots   10")):
        if src1.count(old) != 1:
            check(False, "contro-esempio '%s': testo non trovato una volta (%d)" % (lab, src1.count(old)))
            continue
        try:
            pm, _, _, _ = struttura(src1.replace(old, new, 1).replace("SetIndexBuffer(14,bE9,", "SetIndexBuffer(14,bSt1Su,", 1)
                                    if "scambiati" in lab else src1.replace(old, new, 1), "mut", True)
        except Exception as ex:                   # un mutante che rompe il parser e' comunque PRESO
            pm = ["eccezione %s" % ex]
        check(len(pm) > 0, "contro-esempio PRESO: %s (%s)" % (lab, pm[:2]))

    print("== B) NUMERI: funzioni pure vere + chiamate estratte da OnCalculate/FillDisplay ==")
    calls1, disp1 = estrai(src1)
    check([c[1] for c in calls1] == ["gStM", "gSuM", "gSt1M", "gSt3M"] and all(c[0] == "gStP" for c in calls1),
          "OnCalculate v1.01: 4 chiamate SW_STCore, TUTTE col periodo gStP, moltiplicatori 3,0 / setup / 2,5 / 3,5 (%s)"
          % [c[:2] for c in calls1])
    check(len(disp1) == 6, "FillDisplay v1.01: 6 linee Supertrend (2 per livello) (%d)" % len(disp1))
    series = serie_reali()
    if not check(len(series) == 2, "barre reali XAUUSD (M1 HistData in repo, ricampionate M5 e H1)"):
        sys.exit(1)
    with tempfile.TemporaryDirectory() as tmp:
        res = numeri(src1, src0, series, tmp, "vero")
        for lab, r in res.items():
            if "compila" in r:
                check(False, "%s: il driver C++ compila (%s)" % (lab, r["err"]))
                continue
            for k, v in r.items():
                if k.startswith("_"):
                    continue
                check(v == 0, "%s (%d barre): %s -> %d differenze" % (lab, len(series[0][3]) if "M5" in lab else len(series[1][3]), k, v))
            print("       %s: barre con i tre livelli nello stesso verso %.1f%% (informativo)" % (lab, 100 * r["_concordi"]))
        # contro-esempi numerici sul sorgente vero
        ser = [series[1]]
        for lab, old, new, chiave in (
                ("linea 3,0 col moltiplicatore 2,5", "start,gStP,gStM,kAtr,kUp,", "start,gStP,gSt1M,kAtr,kUp,", "3,0 == v1.00"),
                ("ST 2,5 giu' disegnata col verso su", "bSt1Giu[i]=PG_StLinea(on1,kDir1[i],kVal1[i],-1.0);",
                 "bSt1Giu[i]=PG_StLinea(on1,kDir1[i],kVal1[i],1.0);", "su/giu' esclusive"),
                ("ST 2,5 col periodo sbagliato", "start,gStP,gSt1M,", "start,gBBP,gSt1M,", "2.5 == specchio Python"),
                ("ST 3,5 che scrive nei buffer del 2,5", "gSt3M,kAtr,kUp3,kDn3,kDir3,kVal3", "gSt3M,kAtr,kUp1,kDn1,kDir1,kVal1",
                 "2.5 == specchio Python")):
            if src1.count(old) != 1:
                check(False, "contro-esempio '%s': testo non trovato una volta (%d)" % (lab, src1.count(old)))
                continue
            rm = numeri(src1.replace(old, new, 1), src0, ser, tmp, "mut_" + str(abs(hash(lab))))
            v = list(rm.values())[0]
            check(v.get(chiave, 0) > 0, "contro-esempio PRESO: %s (%s = %s)" % (lab, chiave, v.get(chiave)))

    print()
    if FAILS:
        print("ESITO: %d CONTROLLI FALLITI" % len(FAILS))
        for f in FAILS:
            print("  - " + f)
        sys.exit(1)
    print("ESITO: TUTTO OK (struttura e numeri del Supertrend a tre livelli; NON prova compilazione MQL5, iMA, grafico)")


if __name__ == "__main__":
    main()
