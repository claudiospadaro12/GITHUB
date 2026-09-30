#!/usr/bin/env python3
# -*- coding: ascii -*-
"""
assembla.py -- costruisce backtest_pipeline/righe/RIGA_CONFRONTO_TOCCO_CHIUSURA_M5.txt (UNA riga fisica) dal
sorgente leggibile riga_src.txt. Le righe del sorgente che cominciano con due # sono commenti e non entrano
nella riga; le altre si uniscono con uno spazio. Sostituisce __PIN__/__PIN8__ (il commit pinnato) e gli SHA256
dei tre script, LETTI DAL DISCO e VERIFICATI contro il commit pinnato (git show PIN:file): se un file sul disco
non e quello del pin, si rifiuta (classe 4 della checklist: lo SHA deve contenere quello che si annuncia).
Uso:  python3 backtest_pipeline/collaudo_riga_confronto_tocco/assembla.py <PIN_40_hex> [--verifica]
      --verifica: non scrive, confronta con la riga in repo e dice se e identica byte per byte.
"""
import hashlib, os, re, subprocess, sys
QD = os.path.dirname(os.path.abspath(__file__))
REPO = os.path.abspath(os.path.join(QD, "..", ".."))
PIN = sys.argv[1]
assert re.match(r"^[0-9a-f]{40}$", PIN), "PIN non valido"
src = open(os.path.join(QD, "riga_src.txt"), encoding="ascii").read().split("\n")
t = " ".join(l.strip() for l in src if l.strip() and not l.startswith("##"))
FILES = {"__H_AP__": "anatomia_aperture.py", "__H_M5__": "anatomia_movimenti_m5.py",
         "__H_CF__": "confronto_tocco_chiusura_m5.py"}
m = {"__PIN__": PIN, "__PIN8__": PIN[:8]}
for k, f in FILES.items():
    rel = "backtest_pipeline/" + f
    disco = open(os.path.join(REPO, rel), "rb").read()
    nelpin = subprocess.check_output(["git", "-C", REPO, "show", PIN + ":" + rel])
    assert disco == nelpin, "%s sul disco e DIVERSO da quello nel pin %s: rifare il pin" % (f, PIN[:8])
    m[k] = hashlib.sha256(disco).hexdigest().upper()
for k, v in m.items():
    if k != "__PIN8__":
        assert k in t, k
    t = t.replace(k, v)
t.encode("ascii")
dest = os.path.join(REPO, "backtest_pipeline", "righe", "RIGA_CONFRONTO_TOCCO_CHIUSURA_M5.txt")
if "--verifica" in sys.argv:
    cur = open(dest, encoding="ascii", newline="").read()
    print("IDENTICA byte per byte" if cur == t else "DIVERSA dalla riga in repo")
    sys.exit(0 if cur == t else 1)
open(dest, "w", newline="").write(t)
print(len(t), "byte,", t.count("\n"), "newline")
