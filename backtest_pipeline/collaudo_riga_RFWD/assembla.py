#!/usr/bin/env python3
# -*- coding: ascii -*-
"""
assembla.py -- costruisce backtest_pipeline/righe/RIGA_ROUND_RFWD.txt (UNA riga fisica) dal sorgente leggibile riga_src.txt.
Le righe del sorgente che cominciano con due # sono commenti e non entrano nella riga; le altre si uniscono con uno spazio.
Sostituisce i segnaposto: __PIN__/__PIN8__ (il commit pinnato, che DEVE contenere driver, confronto, forward xlsx e i 7 file prova),
__HPn__ (SHA256 del file prova n AL PIN), __NPn__ (righe di input del file prova n), __SHA_EA_*__ (SHA256 dei sorgenti degli EA AL PIN),
__SHA_INC__, __SHA_CFT__, __SHA_XLSX__. Tutto letto con `git show PIN:percorso`, MAI dal disco: la riga giura sul pin.
Uso:  python3 backtest_pipeline/collaudo_riga_RFWD/assembla.py <PIN_40_hex> [--verifica]
      --verifica: non scrive, confronta con la riga in repo e dice se e identica byte per byte.
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

PROVE = ["RFWD_770411_MAXMIN_DAX_short.txt", "RFWD_770101_DAX_RETEST_long.txt", "RFWD_770105_DAX_RETEST_short.txt",
         "RFWD_771531_EMA200_DOW.txt", "RFWD_770202_DOW_APERTURA.txt", "RFWD_770260_NASDAQ_RETEST.txt", "RFWD_770511_SUPERWAVE_DOW.txt"]
EA = {"__SHA_EA_MAXMIN__": "ABTG_MaxMinNotte_DAX_Short_Ottimizzato", "__SHA_EA_DAX__": "ABTG_DAX_Apertura_EU_Pin9fca",
      "__SHA_EA_EMA200__": "ABTG_EMA200", "__SHA_EA_DOW__": "ABTG_Dow_Apertura_US_Pin9fca",
      "__SHA_EA_NAS__": "ABTG_Nasdaq_Apertura_US_Pin9fca", "__SHA_EA_SW__": "ABTG_SuperWave_DOW_H1_Ottimizzato"}
src = open(os.path.join(QD, "riga_src.txt"), encoding="ascii").read().split("\n")
t = " ".join(l.strip() for l in src if l.strip() and not l.startswith("##"))
m = {"__PIN__": PIN, "__PIN8__": PIN[:8]}
for i, f in enumerate(PROVE, start=1):
    b = git_show("backtest_pipeline/prove/" + f)
    m["__HP%d__" % i] = sha(b)
    m["__NP%d__" % i] = str(sum(1 for l in b.decode("ascii").splitlines() if re.match(r"^[A-Za-z][A-Za-z0-9_]*=", l.strip())))
for k, n in EA.items():
    m[k] = sha(git_show("mql5/Experts/%s.mq5" % n))
m["__SHA_INC__"] = sha(git_show("mql5/Include/ABTG_PausaGuardian.mqh"))
m["__SHA_CFT__"] = sha(git_show("backtest_pipeline/confronto_forward_tester.py"))
m["__SHA_XLSX__"] = sha(git_show("data/statements/FTMO_541452707_cronistorico_2026-09-30.xlsx"))
drv = sha(git_show("backtest_pipeline/righe/RIGA_ROUND_VPS.ps1"))
assert drv == "3341756FB37889DBD6E827A87BAC26893E01C85B6C18343918083B01B4DD3425", "il driver al pin NON e quello approvato: " + drv
assert b"MARCATORE_RIGA_ROUND_VPS_v2" in git_show("backtest_pipeline/righe/RIGA_ROUND_VPS.ps1")
assert b"MARCATORE_CONFRONTO_FORWARD_TESTER_v1" in git_show("backtest_pipeline/confronto_forward_tester.py")
for k, v in m.items():
    assert k in t, "segnaposto non usato nel sorgente: " + k
    t = t.replace(k, v)
assert "__" not in re.sub(r"__PIN__", "", t) or not re.search(r"__[A-Z0-9_]+__", t), "segnaposto rimasti: %s" % re.findall(r"__[A-Z0-9_]+__", t)
t.encode("ascii")
dest = os.path.join(REPO, "backtest_pipeline", "righe", "RIGA_ROUND_RFWD.txt")
if "--verifica" in sys.argv:
    cur = open(dest, encoding="ascii", newline="").read()
    print("IDENTICA byte per byte" if cur == t else "DIVERSA dalla riga in repo")
    sys.exit(0 if cur == t else 1)
open(dest, "w", newline="").write(t)
print(len(t), "byte,", t.count("\n"), "newline")
for k in sorted(m):
    if k.startswith("__HP") or k.startswith("__NP") or k.startswith("__SHA"):
        print(" ", k, m[k])
