#!/usr/bin/env python3
"""Riga CORTA di UBS R (ReverseTrades sui set oro). Modello: righe/BOOT_RIGA_OTT1.txt. Uso: python3 gen_boot_ubs_r.py <PIN40 della riga lunga> <SHA256 della riga lunga>"""
import sys, os, re
PIN, SHA = sys.argv[1], sys.argv[2].upper()
os.chdir(os.path.dirname(os.path.abspath(__file__)))
t = open('righe/BOOT_RIGA_OTT1.txt', encoding='ascii').read()
def sost(a, b, n=1):
    global t
    assert t.count(a) == n, (t.count(a), a[:80])
    t = t.replace(a, b)
OLD40 = list(set(re.findall(r"\b[0-9a-f]{40}\b", t)))[0]; OLD8 = OLD40[:8]
OLDSHA = list(set(re.findall(r"\b[0-9A-F]{64}\b", t)))[0]
sost(OLD40, PIN); sost(OLDSHA, SHA)
sost("RIGA_LANCIA_OTT1.txt", "RIGA_LANCIA_UBS_R.txt", t.count("RIGA_LANCIA_OTT1.txt"))
sost(OLD8, PIN[:8], t.count(OLD8))
m = re.search(r"Questa e la riga CORTA di (.*?): 18 passate, solo tester", t)
assert m
t = t.replace(m.group(1) + ": 18 passate, solo tester", "UBS R (prova di ReverseTrades=true su 9 set oro di Wim, XAUUSD, Modello 1, deposito 100.000 EUR, due periodi 2013-2018 e 2019-2025, set come consegnati con solo quell input cambiato): 18 passate, solo tester")
sost("report/OTT1_GOLDBOT_PROP_CRITERI_2026-11-13.md", "report/UBS_ORO_NON_CORRELATI_REVERSE_CRITERI_2026-11-15.md")
sost("(22 KB, passata dal cancello)", "(%d KB, passata dal cancello)" % round(os.path.getsize('righe/RIGA_LANCIA_UBS_R.txt') / 1024))
open('righe/BOOT_RIGA_UBS_R.txt', 'w', encoding='ascii').write(t)
print('boot', len(t))
