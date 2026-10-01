#!/usr/bin/env python3
# -*- coding: ascii -*-
"""
assembla.py -- costruisce backtest_pipeline/righe/RIGA_ROUND_DAXAP02.txt (UNA riga fisica) dal sorgente leggibile riga_src.txt.
Stessa forma di collaudo_riga_R92BAB/assembla.py. Le righe del sorgente che cominciano con due # sono commenti e non entrano nella riga;
le altre si uniscono con uno spazio.
Segnaposto: __PIN__/__PIN8__ (il commit pinnato, che DEVE contenere driver, walkforward_generico, il file prova, la sorgente dell EA e l include),
__HP__ (SHA256 del file prova AL PIN), __NP__ (righe di input del file prova), __SHA_EA__, __SHA_INC__, __SHA_WF__.
Tutto letto con `git show PIN:percorso`, MAI dal disco: la riga giura sul pin.
In piu' verifica a macchina che il file prova al pin sia R270e (gia' girato il 28/09) con SOLO tre differenze: InpCloseHour diventa l'asse
17||11||2||17||Y, InpTP1_R pinnato a 1 (era l'asse), InpMagic 798102 (era 786325).
Uso:  python3 backtest_pipeline/collaudo_riga_DAXAP02/assembla.py <PIN_40_hex> [--verifica] [--dest FILE]
"""
import hashlib, os, re, subprocess, sys
QD = os.path.dirname(os.path.abspath(__file__))
REPO = os.path.abspath(os.path.join(QD, "..", ".."))
PIN = sys.argv[1]
assert re.match(r"^[0-9a-f]{40}$", PIN), "PIN non valido"

def git_show(path):
    r = subprocess.run(["git", "show", "%s:%s" % (PIN, path)], cwd=REPO, capture_output=True)
    if r.returncode != 0:
        sys.exit("git show %s:%s fallito: %s" % (PIN[:8], path, r.stderr.decode()[:200]))
    return r.stdout

def sha(b):
    return hashlib.sha256(b).hexdigest().upper()

def inputs(b):
    d = {}
    for l in b.decode("ascii").splitlines():
        t = l.strip()
        m = re.match(r"^([A-Za-z][A-Za-z0-9_]*)=(.*)$", t)
        if m:
            assert m.group(1) not in d, "input doppio: " + m.group(1)
            d[m.group(1)] = m.group(2)
    return d

def direttive(b):
    d = {}
    for l in b.decode("ascii").splitlines():
        m = re.match(r"^@(\w+)\s+(.+)$", l.strip())
        if m:
            d[m.group(1).upper()] = m.group(2).strip()
    return d

PROVA = "backtest_pipeline/prove/PRV_DAXAP_02_closehour_770101_D30EUR.txt"
pb = git_show(PROVA)
pb.decode("ascii")
assert b"\r" not in pb and b"\t" not in pb
ip = inputs(pb); dp = direttive(pb)
# il gemello GIA GIRATO (R270e, 28/09, stesso PC, stesso EA): differenze attese e SOLO quelle
rb = git_show("backtest_pipeline/prove/R270e_tp1r_770101_D30EUR.txt")
ir = inputs(rb); dr = direttive(rb)
diff = sorted(k for k in set(ip) | set(ir) if ip.get(k) != ir.get(k))
assert diff == ["InpCloseHour", "InpMagic", "InpTP1_R"], diff
assert ip["InpCloseHour"] == "17||11||2||17||Y" and ir["InpCloseHour"] == "17"
assert ip["InpTP1_R"] == "1" and ir["InpTP1_R"] == "1||0.5||0.5||2||Y"
assert ip["InpMagic"] == "798102" and ir["InpMagic"] == "786325"
assert ip["InpCloseMin"] == "30" and ip["InpRiskPercent"] == "1" and ip["InpAllowLong"] == "true" and ip["InpAllowShort"] == "false"
assert len(ip) == 90, len(ip)
assert dp == {"SIMBOLO": "D30EUR", "PERIODO": "M5", "DAQUANDO": "2024.09.26", "FINOA": "2026.06.30", "FRAZIONEIS": "0.40"}, dp
assert dp == dr, (dp, dr)
assi = [k for k, v in ip.items() if re.match(r"^[^|]*\|\|[^|]*\|\|[^|]*\|\|[^|]*\|\|Y\s*$", v)]
assert assi == ["InpCloseHour"], assi
stringhe = sorted(k for k, v in ip.items() if k not in assi and v not in ("true", "false") and not re.match(r"^-?[0-9]+(\.[0-9]+)?$", v))
assert stringhe == ["InpCorrSymbol", "InpNewsFile"], stringhe

src = open(os.path.join(QD, "riga_src.txt"), encoding="ascii").read().split("\n")
t = " ".join(l.strip() for l in src if l.strip() and not l.startswith("##"))
m = {"__PIN__": PIN, "__PIN8__": PIN[:8], "__HP__": sha(pb), "__NP__": str(len(ip))}
m["__SHA_EA__"] = sha(git_show("mql5/Experts/ABTG_DAX_Apertura_EU.mq5"))
m["__SHA_INC__"] = sha(git_show("mql5/Include/ABTG_PausaGuardian.mqh"))
wf = git_show("backtest_pipeline/walkforward_generico.ps1")
m["__SHA_WF__"] = sha(wf)
drvb = git_show("backtest_pipeline/righe/RIGA_ROUND_VPS.ps1")
assert sha(drvb) == "3341756FB37889DBD6E827A87BAC26893E01C85B6C18343918083B01B4DD3425", "il driver al pin NON e quello approvato: " + sha(drvb)
assert b"MARCATORE_RIGA_ROUND_VPS_v2" in drvb
assert b'macchina = "DESKTOP-H4D7CAJ"' in drvb and b'perc     = "C:\\Program Files\\BCM Markets MT5 Terminal"' in drvb, "la tabella del driver al pin non porta DESKTOP-H4D7CAJ -> C:\\Program Files\\BCM Markets MT5 Terminal"
assert b"MARCATORE_WALKFORWARD_GENERICO_v5_INCLUDE" in wf, "il driver di walk-forward al pin non ha il marcatore v5"
# lo stesso motore di R270 (28/09, = binario in campo su FTMO per 770101/770105) e lo stesso include
assert m["__SHA_EA__"] == "E33C6B8B81262FAAE561D4033559A7133FD965EA635FEC1ACF7E47CBA20C89AC", "ABTG_DAX_Apertura_EU.mq5 al pin non e quello di R270: " + m["__SHA_EA__"]
assert m["__SHA_INC__"] == "3EC971152E85E0082488CC4243FF45AE09948C191D52AB96050B48F94641A737"
for k, v in m.items():
    assert k in t, "segnaposto non usato nel sorgente: " + k
    t = t.replace(k, v)
resid = re.findall(r"__[A-Z0-9_]+__", t)
assert not resid, "segnaposto rimasti: %s" % resid
t.encode("ascii")
assert "\n" not in t and "\r" not in t and "\t" not in t
dest = os.path.join(REPO, "backtest_pipeline", "righe", "RIGA_ROUND_DAXAP02.txt")
if "--dest" in sys.argv:
    dest = sys.argv[sys.argv.index("--dest") + 1]
if "--verifica" in sys.argv:
    cur = open(dest, encoding="ascii", newline="").read()
    print("IDENTICA byte per byte" if cur == t else "DIVERSA dalla riga in repo")
    sys.exit(0 if cur == t else 1)
open(dest, "w", newline="").write(t)
print(len(t), "byte,", t.count("\n"), "newline, SHA256", sha(t.encode("ascii")))
for k in sorted(m):
    print("  ", k, m[k][:16])
print("   file prova al pin = R270e salvo InpCloseHour (asse), InpTP1_R (pinnato 1), InpMagic (798102); stringhe non confrontate:", stringhe)
