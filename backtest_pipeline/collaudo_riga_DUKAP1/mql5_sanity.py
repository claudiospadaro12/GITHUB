#!/usr/bin/env python3
# -*- coding: ascii -*-
"""
mql5_sanity.py -- controllo STATICO di ABTG_ImportaTickEsterno.mq5 (v1): su Linux non c'e' MetaEditor, quindi l'unica cosa che si puo' provare e' (a) che il sorgente sia strutturalmente sano
(parentesi, graffe, virgolette bilanciate; chiamate col numero giusto di argomenti) e (b) che PRODUTTORE (l'importer) e CONSUMATORI (la figlia ps1, il valutatore leggi_f2_dk.py) parlino la stessa lingua:
le 13 colonne del file per giorno, i valori di Esito, SI/NO, la versione e il marcatore che la figlia cerca. NON prova che compili: quella e' la riga figlia stessa (compila con metaeditor64 e si ferma
se l'.ex5 non nasce) -> [NON COPERTO] qui.
Uso: python3 mql5_sanity.py   -> ultima riga "MQL5 SANITY: OK" o "MQL5 SANITY: n problemi"
"""
import os, re, sys
QD = os.path.dirname(os.path.abspath(__file__))
REPO = os.path.abspath(os.path.join(QD, "..", ".."))
sys.path.insert(0, os.path.join(REPO, "backtest_pipeline", "dukascopy"))
import leggi_f2_dk as L

SRC = open(os.path.join(REPO, "mql5", "Scripts", "ABTG_ImportaTickEsterno.mq5"), encoding="ascii").read()
IMP = open(os.path.join(REPO, "backtest_pipeline", "righe", "RIGA_DUKA_IMPORT_SONDA.ps1"), encoding="ascii").read()


def toglie(src):
    """via commenti e il contenuto delle stringhe (lasciando le virgolette)"""
    out = []
    for l in src.splitlines():
        l = re.sub(r'"(?:[^"\\]|\\.)*"', '""', l)
        l = re.sub(r"//.*$", "", l)
        out.append(l)
    return "\n".join(out)


def split_args(s):
    args, depth, cur = [], 0, ""
    instr = False
    for ch in s:
        if ch == '"':
            instr = not instr
        if not instr:
            if ch in "([":
                depth += 1
            elif ch in ")]":
                depth -= 1
            elif ch == "," and depth == 0:
                args.append(cur.strip()); cur = ""; continue
        cur += ch
    if cur.strip():
        args.append(cur.strip())
    return args


def chiamata(src, nome, dopo=0):
    """argomenti della prima chiamata `nome(` dopo la posizione `dopo` (parentesi bilanciate, stringhe rispettate)"""
    i = src.index(nome + "(", dopo) + len(nome) + 1
    depth, j, instr = 1, i, False
    while depth:
        ch = src[j]
        if ch == '"':
            instr = not instr
        if not instr:
            depth += ch == "("
            depth -= ch == ")"
        j += 1
    return split_args(src[i:j - 1])


def controlla(SRC, IMP):
    prob = []
    pulito = toglie(SRC)
    for a, b, nome in (("(", ")", "parentesi tonde"), ("{", "}", "graffe"), ("[", "]", "quadre")):
        if pulito.count(a) != pulito.count(b):
            prob.append("%s non bilanciate: %d aperte, %d chiuse" % (nome, pulito.count(a), pulito.count(b)))
    if SRC.count('"') % 2:
        prob.append("virgolette dispari")
    # (b) l'intestazione scritta da ApriGiorni == le colonne che il valutatore pretende
    a = chiamata(SRC, "FileWrite", SRC.index("int ApriGiorni()"))
    cols = [x.strip().strip('"') for x in a[1:]]
    if cols != L.COL_GIORNI:
        prob.append("intestazione di ApriGiorni != COL_GIORNI del valutatore: %s contro %s" % (cols, L.COL_GIORNI))
    # la riga: 1 (handle) + 13 colonne
    r = chiamata(SRC, "FileWrite", SRC.index("void RigaGiorno("))
    if len(r) != 1 + len(L.COL_GIORNI):
        prob.append("FileWrite di RigaGiorno ha %d argomenti, attesi %d" % (len(r), 1 + len(L.COL_GIORNI)))
    # i punti di chiamata di RigaGiorno: 11 argomenti (la firma)
    firma = chiamata(SRC, "void RigaGiorno")
    n_firma = len(firma)
    pos = 0
    chiamate = 0
    while True:
        k = SRC.find("RigaGiorno(fhGiorni", pos)
        if k < 0:
            break
        arg = chiamata(SRC, "RigaGiorno", k)
        chiamate += 1
        if len(arg) != n_firma:
            prob.append("chiamata RigaGiorno con %d argomenti, la firma ne ha %d" % (len(arg), n_firma))
        pos = k + 5
    if chiamate != 3:
        prob.append("attese 3 chiamate di RigaGiorno (MISURATO, NON_CONFRONTABILE, DATA_MALFORMATA), trovate %d" % chiamate)
    # i valori di Esito e SI/NO
    for lit in ('"MISURATO"', '"NON_CONFRONTABILE"', '"DATA_MALFORMATA"'):
        if lit not in SRC:
            prob.append("literal Esito mancante: " + lit)
    if '(passa ? "SI" : "NO")' not in SRC:
        prob.append('il PassaImportatore non e\' scritto come "SI"/"NO"')
    if not re.search(r'#define VERSIONE "%s[^"]*"' % re.escape(L.PREFISSO_VERSIONE), SRC):
        prob.append("VERSIONE non comincia con %s" % L.PREFISSO_VERSIONE)
    m = re.search(r'#define VERSIONE "([^"]+)"', SRC)
    if not m or ('"%s"' % m.group(1)) not in IMP:
        prob.append("il marcatore che la figlia cerca nello script scaricato non e' la VERSIONE del sorgente")
    if '#define REFERTO_GIORNI "ABTG_ImportTick_giorni.csv"' not in SRC or '$GiorniCsv = "ABTG_ImportTick_giorni.csv"' not in IMP:
        prob.append("il nome del file per giorno non coincide fra importer e figlia")
    # il file si TRONCA (FILE_WRITE senza FILE_READ) e si chiude
    ap = SRC[SRC.index("int ApriGiorni()"):SRC.index("void RigaGiorno(")]
    if "FILE_WRITE" not in ap or "FILE_READ" in ap:
        prob.append("ApriGiorni deve aprire in sola scrittura (troncare)")
    if "FileClose(fhGiorni)" not in SRC:
        prob.append("il file per giorno non viene chiuso")
    # le soglie scritte nelle righe sono quelle degli input
    if "DoubleToString(InpSogliaDiffPct, 8), DoubleToString(InpSogliaCopertura, 4)" not in SRC:
        prob.append("le soglie nelle righe non vengono dagli input")
    return prob


def autotest():
    """il controllo statico DEVE vedere il male: la sorgente vera da' 0 problemi, ogni mutazione ne da' almeno 1"""
    base = controlla(SRC, IMP)
    ko = []
    if base:
        ko.append("la sorgente vera ha problemi: %s" % base)
    muts = [
        ("colonna rinominata", lambda s: s.replace('"MedianaDiffPct","CoperturaPct"', '"Mediana","CoperturaPct"')),
        ("argomento in piu'", lambda s: s.replace('"DATA_MALFORMATA", 0, 0, 0, 0, 0, 0, false', '"DATA_MALFORMATA", 0, 0, 0, 0, 0, 0, 0, false')),
        ("FileClose tolto", lambda s: s.replace("if(fhGiorni != INVALID_HANDLE) FileClose(fhGiorni);", "")),
        ("graffa sbilanciata", lambda s: s.replace("void RigaGiorno(", "}\nvoid RigaGiorno(", 1)),
        ("versione v0", lambda s: s.replace('"IMP-TICK-v1-GIORNI"', '"IMP-TICK-v0-BOZZA"', 1)),
        ("SI diventa YES", lambda s: s.replace('(passa ? "SI" : "NO")', '(passa ? "YES" : "NO")')),
        ("apertura in lettura", lambda s: s.replace('int fh = FileOpen(REFERTO_GIORNI, FILE_WRITE|', 'int fh = FileOpen(REFERTO_GIORNI, FILE_READ|FILE_WRITE|')),
        ("soglie non dagli input", lambda s: s.replace("DoubleToString(InpSogliaDiffPct, 8)", "DoubleToString(0.05, 8)")),
        ("nome file diverso", lambda s: s.replace('#define REFERTO_GIORNI "ABTG_ImportTick_giorni.csv"', '#define REFERTO_GIORNI "ABTG_ImportTick_giorno.csv"')),
    ]
    for nome, f in muts:
        s2 = f(SRC)
        if s2 == SRC:
            ko.append("mutazione non applicata: " + nome); continue
        if not controlla(s2, IMP):
            ko.append("il controllo statico NON vede: " + nome)
    for k in ko:
        print("  X " + k)
    print("AUTOTEST MQL5 SANITY: %d mutazioni, %s" % (len(muts), "TUTTE VISTE" if not ko else "%d problemi" % len(ko)))
    return 0 if not ko else 1


def main():
    if "--autotest" in sys.argv:
        return autotest()
    prob = controlla(SRC, IMP)
    for p in prob:
        print("  X " + p)
    print("MQL5 SANITY: " + ("OK" if not prob else "%d problemi" % len(prob)))
    return 0 if not prob else 1


if __name__ == "__main__":
    sys.exit(main())
