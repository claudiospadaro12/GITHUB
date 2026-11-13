#!/usr/bin/env python3
"""Riga CORTA di OTT1 (Goldbot One Prop tappa 1). Modello: righe/BOOT_RIGA_OTT1.txt. Uso: python3 gen_boot_ott1.py <PIN40 della riga lunga> <SHA256 della riga lunga>"""
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
sost("RIGA_LANCIA_OTT1.txt", "RIGA_LANCIA_OTT1R.txt", t.count("RIGA_LANCIA_OTT1.txt"))
sost(OLD8, PIN[:8], t.count(OLD8))
m = re.search(r"Questa e la riga CORTA di (.*?): 18 passate, solo tester", t)
assert m
t = t.replace(m.group(1), "OTT1R (ripetizione di 2 passate KO della tappa 1 del Goldbot One Prop: la BASE e la prova senza la strategia G, periodo 2019-2025, set ufficiale Goldbot_PropFirm_5_2.5.set da combodeal.zip, deposito 80.000 EUR)")
t = t.replace(": 18 passate, solo tester", ": 2 passate, solo tester")
sost("(22 KB, passata dal cancello)", "(%d KB, passata dal cancello)" % round(os.path.getsize('righe/RIGA_LANCIA_OTT1R.txt') / 1024))
open('righe/BOOT_RIGA_OTT1R.txt', 'w', encoding='ascii').write(t)
print('boot', len(t))
