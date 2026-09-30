#!/usr/bin/env python3
# -*- coding: ascii -*-
"""
assembla.py -- costruisce backtest_pipeline/righe/RIGA_ROUND_R92BAB.txt (UNA riga fisica) dal sorgente leggibile riga_src.txt.
Le righe del sorgente che cominciano con due # sono commenti e non entrano nella riga; le altre si uniscono con uno spazio.
Segnaposto: __PIN__/__PIN8__ (il commit pinnato, che DEVE contenere driver, walkforward_generico, i 6 file prova, le sorgenti degli EA e l'include),
__HP_x__ (SHA256 del file prova AL PIN), __NP_x__ (righe di input del file prova), __SHA_EA_*__, __SHA_INC__, __SHA_WF__.
Tutto letto con `git show PIN:percorso`, MAI dal disco: la riga giura sul pin.
Uso:  python3 backtest_pipeline/collaudo_riga_R92BAB/assembla.py <PIN_40_hex> [--verifica] [--dest FILE]
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

PROVE = {"P": "R92BAB_P_controllo_positivo.txt", "A": "R92BAB_A_cross22.txt", "B": "R92BAB_B_GBPUSD.txt", "C": "R92BAB_C_cross8.txt",
         "D": "R92BAB_D_cross8_largo.txt", "A2": "R92BAB_A2_cross22_replica.txt"}
src = open(os.path.join(QD, "riga_src.txt"), encoding="ascii").read().split("\n")
t = " ".join(l.strip() for l in src if l.strip() and not l.startswith("##"))
m = {"__PIN__": PIN, "__PIN8__": PIN[:8]}
for k, f in PROVE.items():
    b = git_show("backtest_pipeline/prove/" + f)
    m["__HP_%s__" % k] = sha(b)
    m["__NP_%s__" % k] = str(sum(1 for l in b.decode("ascii").splitlines() if re.match(r"^[A-Za-z][A-Za-z0-9_]*=", l.strip())))
m["__SHA_EA_BULGE__"] = sha(git_show("mql5/Experts/ABTG_Bulge.mq5"))
m["__SHA_EA_DAX__"] = sha(git_show("mql5/Experts/ABTG_DAX_Apertura_EU_Pin9fca.mq5"))
m["__SHA_INC__"] = sha(git_show("mql5/Include/ABTG_PausaGuardian.mqh"))
wf = git_show("backtest_pipeline/walkforward_generico.ps1")
m["__SHA_WF__"] = sha(wf)
drvb = git_show("backtest_pipeline/righe/RIGA_ROUND_VPS.ps1")
assert sha(drvb) == "3341756FB37889DBD6E827A87BAC26893E01C85B6C18343918083B01B4DD3425", "il driver al pin NON e quello approvato: " + sha(drvb)
assert b"MARCATORE_RIGA_ROUND_VPS_v2" in drvb
assert b"MARCATORE_WALKFORWARD_GENERICO_v5_INCLUDE" in wf, "il driver di walk-forward al pin non ha il marcatore v5"
assert m["__SHA_EA_BULGE__"] == "ED4E88B1CFBA36AD81658935E8920FE31462AE3202DD61C9C50A039ACEF57BBD", "ABTG_Bulge.mq5 al pin non e la v5.20 attesa"
assert m["__SHA_INC__"] == "3EC971152E85E0082488CC4243FF45AE09948C191D52AB96050B48F94641A737"
for k, v in m.items():
    assert k in t, "segnaposto non usato nel sorgente: " + k
    t = t.replace(k, v)
resid = re.findall(r"__[A-Z0-9_]+__", t)
assert not resid, "segnaposto rimasti: %s" % resid
t.encode("ascii")
dest = os.path.join(REPO, "backtest_pipeline", "righe", "RIGA_ROUND_R92BAB.txt")
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
