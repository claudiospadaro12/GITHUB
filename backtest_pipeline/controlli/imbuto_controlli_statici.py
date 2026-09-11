# -*- coding: ascii -*-
"""Controlli statici sui .mq5 toccati. DICHIARA cosa prende e cosa no."""
import re, subprocess, sys

RIF = sys.argv[1] if len(sys.argv) > 1 else "HEAD~1"   # commit di confronto

FILES = subprocess.check_output(
    ["git", "diff", "--name-only", RIF, "--", "mql5/Experts"], text=True).split()
err = 0

def bad(f, msg):
    global err
    print("!! [%s] %s" % (f, msg)); err += 1

def spoglia(t):
    """toglie commenti e poi stringhe (in QUESTO ordine: nei commenti
    italiani ci sono apostrofi tipo gia', e se si tolgono prima le
    stringhe l'apostrofo si mangia meta' file -- errore fatto e corretto)"""
    fuori, i, n = [], 0, len(t)
    stato = 0   # 0=codice 1=stringa 2=char 3=// 4=/*
    while i < n:
        c = t[i]; d = t[i:i+2]
        if stato == 0:
            if d == "//": stato = 3; i += 2; continue
            if d == "/*": stato = 4; i += 2; continue
            if c == '"': stato = 1; i += 1; continue
            if c == "'": stato = 2; i += 1; continue
            fuori.append(c); i += 1; continue
        if stato == 1:
            if c == "\\": i += 2; continue
            if c == '"': stato = 0
            i += 1; continue
        if stato == 2:
            if c == "\\": i += 2; continue
            if c == "'": stato = 0
            i += 1; continue
        if stato == 3:
            if c == "\n": stato = 0; fuori.append(c)
            i += 1; continue
        if stato == 4:
            if d == "*/": stato = 0; i += 2; continue
            i += 1; continue
    return "".join(fuori)

for f in FILES:
    src = open(f, "rb").read()
    # 1) ASCII puro
    for i, b in enumerate(src):
        if b > 127:
            bad(f, "byte non ASCII 0x%02x all'offset %d" % (b, i)); break
    t = src.decode("ascii", "replace")
    code = spoglia(t)
    # 2) bilanciamento (NECESSARIO, NON SUFFICIENTE)
    for ap, ch in (("{", "}"), ("(", ")"), ("[", "]")):
        if code.count(ap) != code.count(ch):
            bad(f, "sbilanciamento %s%s: %d vs %d" % (ap, ch, code.count(ap), code.count(ch)))
    # 3) CLASSE 227: ogni globale nuova dichiarata PRIMA del primo uso
    nuove = set(re.findall(r"^(?:long|int|datetime)\s+(c[A-Z][A-Za-z0-9_]*|gImb[A-Za-z]*)", t, re.M))
    nuove |= set(re.findall(r"^long\s+(gImbSnap)\[\]", t, re.M))
    for v in sorted(nuove):
        decl = re.search(r"^(?:long|int|datetime)\s+[^\n;]*\b%s\b" % re.escape(v), t, re.M)
        primo = re.search(r"\b%s\b" % re.escape(v), t)
        if decl is None or primo is None or primo.start() < decl.start():
            bad(f, "CLASSE 227: '%s' usata prima della dichiarazione" % v)
    # input prima dell'uso
    di = t.find("input bool   InpLogImbuto")
    ui = t.find("InpLogImbuto")
    if di < 0: bad(f, "manca l'input InpLogImbuto")
    elif ui < di: bad(f, "CLASSE 227: InpLogImbuto usata prima di essere dichiarata")
    # 4) nessuna funzione doppia
    for fn in ("ImbutoRaccogli", "ImbutoStampa", "ImbutoGiro"):
        n = len(re.findall(r"^void %s\(" % fn, t, re.M))
        if n != 1: bad(f, "funzione %s definita %d volte" % (fn, n))
    # 5) indici di array dentro la ArrayResize dichiarata
    m = re.search(r"void ImbutoRaccogli\(long &v\[\]\)\s*\{?\s*\n\s*\{?\s*ArrayResize\(v,(\d+)\);(.*?)\n  \}", t, re.S)
    if not m: bad(f, "ImbutoRaccogli non riconosciuta")
    else:
        n = int(m.group(1))
        idx = [int(x) for x in re.findall(r"v\[(\d+)\]", m.group(2))]
        if sorted(idx) != list(range(n)):
            bad(f, "ImbutoRaccogli: indici %s contro dimensione %d" % (sorted(idx), n))
        corpo = t[t.index("void ImbutoStampa"):]
        corpo = corpo[:corpo.index("\n  }")]
        usati = [int(x) for x in re.findall(r"d\[(\d+)\]", corpo)]
        if usati and max(usati) >= n:
            bad(f, "ImbutoStampa: indice d[%d] fuori da %d" % (max(usati), n))
    # 6) niente StringFormat aggiunto nel blocco imbuto
    blocco = re.search(r"void ImbutoRaccogli.*?void ImbutoGiro\(\).*?\n  \}", t, re.S)
    if blocco and "StringFormat" in blocco.group(0):
        bad(f, "StringFormat dentro l'imbuto: specificatori da verificare a mano")
    # 7) nessun contatore dentro una CONDIZIONE (deve stare solo come statement)
    for m2 in re.finditer(r"if\s*\([^)]*c[A-Z][A-Za-z0-9_]*\+\+", t):
        bad(f, "contatore dentro una condizione: %s" % m2.group(0))
    # 8) ogni contatore incrementato e' anche raccolto
    inc = set(re.findall(r"\b(c[A-Z][A-Za-z0-9_]*)\+\+", t))
    racc = set(re.findall(r"v\[\d+\]=(c[A-Za-z0-9_]*)", t))
    fuori = sorted(inc - racc)
    if fuori: print("   nota [%s] contatori incrementati ma non stampati dall'imbuto: %s" % (f, fuori))

print("\n== errori bloccanti: %d ==" % err)
