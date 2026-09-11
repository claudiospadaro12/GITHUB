# -*- coding: ascii -*-
"""CONTRO-PROVA FORTE: si RICOSTRUISCE il file originale togliendo dal
nuovo tutto cio' che e' imbuto. Se il comportamento non e' cambiato, il
risultato deve coincidere con HEAD riga per riga (a meno di spazi e
commenti). Ogni riga residua viene stampata: e' li' che si nasconde un
cambio di comportamento."""
import re, subprocess, sys

RIF = sys.argv[1] if len(sys.argv) > 1 else "HEAD~1"   # commit di confronto

FILES = subprocess.check_output(
    ["git", "diff", "--name-only", RIF, "--", "mql5/Experts"], text=True).split()

def togli_blocchi(testo):
    righe = testo.split("\n")
    out, i = [], 0
    while i < len(righe):
        r = righe[i]
        # blocco INPUT dell'imbuto
        if r.startswith("//--- IMBUTO DI MORTALITA' (11/09/2026): governa SOLO il log"):
            while i < len(righe) and not righe[i].startswith("input bool   InpLogImbuto"):
                i += 1
            i += 1                      # salta anche la riga dell'input
            if i < len(righe) and righe[i].strip() == "":
                i += 1
            if out and out[-1].strip() == "":
                out.pop()
            continue
        # blocco STATO + funzioni dell'imbuto (dal cartiglio alla fine di ImbutoGiro)
        if r.startswith("//====") and i + 1 < len(righe) and re.match(r"^//\s+IMBUTO", righe[i+1]):
            while i < len(righe) and not righe[i].startswith("void ImbutoGiro()"):
                i += 1
            while i < len(righe) and righe[i] != "  }":
                i += 1
            i += 1
            while i < len(righe) and righe[i].strip() == "":
                i += 1
            if out and out[-1].strip() == "":
                out.pop()
            continue
        # chiamate
        if re.match(r"^\s*ImbutoGiro\(\);", r) or re.match(r"^\s*ImbutoStampa\(\"parziale del \"", r):
            i += 1; continue
        # contatori su riga propria
        if re.match(r"^\s*c[A-Z][A-Za-z0-9_]*\+\+;\s*(//.*)?$", r):
            i += 1; continue
        out.append(r); i += 1
    return "\n".join(out)

def norm(s):
    s = re.sub(r"c[A-Z][A-Za-z0-9_]*\+\+;\s*", "", s)       # contatori in linea
    s = re.sub(r"\{\s*return;\s*\}", "return;", s)           # graffe aggiunte attorno al return
    s = re.sub(r"else\s*\{\s*(Log\(.*\);)\s*\}", r"else \1", s)
    s = re.sub(r"//.*$", "", s)
    return re.sub(r"\s+", "", s)

tot = 0
for f in FILES:
    vecchio = subprocess.check_output(["git", "show", RIF + ":" + f], text=True)
    nuovo = togli_blocchi(open(f).read())
    a = [norm(x) for x in vecchio.split("\n")]
    b = [norm(x) for x in nuovo.split("\n")]
    a = [x for x in a if x != ""]
    b = [x for x in b if x != ""]
    import difflib
    d = [x for x in difflib.unified_diff(a, b, lineterm="", n=0) if x[:1] in "+-" and x[:3] not in ("+++", "---")]
    if d:
        print("### %s -- RESIDUO (%d righe)" % (f, len(d)))
        for x in d: print("   " + x)
        tot += len(d)
    else:
        print("OK %s -- ricostruito IDENTICO all'originale" % f)
print("\n== righe residue totali: %d ==" % tot)
