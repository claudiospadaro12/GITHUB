#!/usr/bin/env python3
# -*- coding: ascii -*-
"""
assembla.py -- costruisce RIGA_ROUND_R92B.txt (UNA riga fisica) dal sorgente leggibile riga_src.txt.
Le righe del sorgente che cominciano con due # sono commenti e non entrano nella riga; le altre si
uniscono con uno spazio. Sostituisce i segnaposto: __PIN__/__PIN8__ (il commit pinnato, che DEVE contenere
i file prova e il driver) e gli SHA256 dei sei file prova (letti dal disco: se il file prova cambia, cambia
l impronta e va rifatto anche il pin).
Uso:  python3 backtest_pipeline/collaudo_riga_R92b/assembla.py <PIN_40_hex> [--verifica]
      --verifica: non scrive, confronta con la riga in repo e dice se e identica byte per byte.
"""
import hashlib, os, re, sys
QD = os.path.dirname(os.path.abspath(__file__))
REPO = os.path.abspath(os.path.join(QD, "..", ".."))
PIN = sys.argv[1]
assert re.match(r"^[0-9a-f]{40}$", PIN), "PIN non valido"
src = open(os.path.join(QD, "riga_src.txt"), encoding="ascii").read().split("\n")
t = " ".join(l.strip() for l in src if l.strip() and not l.startswith("##"))
def h(f):
    return hashlib.sha256(open(os.path.join(REPO, "backtest_pipeline", "prove", f), "rb").read()).hexdigest().upper()
m = {"__PIN__": PIN, "__PIN8__": PIN[:8],
     "__HP0__": h("R92b0_controllo_offset0.txt"), "__HPA__": h("R92ba_asse_ATR.txt"), "__HPB__": h("R92bb_asse_BulgeMulti.txt"),
     "__HPC__": h("R92bc_asse_ADX.txt"), "__HPD__": h("R92bd_asse_Arancio.txt"), "__HPE__": h("R92be_cella_AMPIA.txt")}
for k, v in m.items():
    assert k in t, k
    t = t.replace(k, v)
t.encode("ascii")
dest = os.path.join(REPO, "backtest_pipeline", "righe", "RIGA_ROUND_R92B.txt")
if "--verifica" in sys.argv:
    cur = open(dest, encoding="ascii", newline="").read()
    print("IDENTICA byte per byte" if cur == t else "DIVERSA dalla riga in repo")
    sys.exit(0 if cur == t else 1)
open(dest, "w", newline="").write(t)
print(len(t), "byte,", t.count("\n"), "newline")
