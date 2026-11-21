#!/usr/bin/env python3
"""Riga CORTA di UBS C FOREX. Modello: righe/BOOT_RIGA_OTT1.txt. Uso: python3 gen_boot_ubs_cft.py <PIN40 della riga lunga> <SHA256 della riga lunga>"""
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
sost("RIGA_LANCIA_OTT1.txt", "RIGA_LANCIA_UBS_CFT2.txt", t.count("RIGA_LANCIA_OTT1.txt"))
sost(OLD8, PIN[:8], t.count(OLD8))
m = re.search(r"Questa e la riga CORTA di (.*?): 18 passate, solo tester", t)
assert m
t = t.replace(m.group(1) + ": 18 passate, solo tester", "UBS C FOREX A TICK REALI su 22 mesi (17 set di Wim: scalper, volatility breakout EURUSD, CLI USDJPY D1, OTH; solo Modello 4 tick reali BCM, 01/01/2025 - 13/11/2026, deposito 100.000 EUR, lotto fisso 0,1): 17 passate, solo tester")
sost("report/OTT1_GOLDBOT_PROP_CRITERI_2026-11-13.md", "report/UBS_NON_ORO_F2F7_CRITERI_2026-11-21.md")
sost("(22 KB, passata dal cancello)", "(%d KB, passata dal cancello)" % round(os.path.getsize('righe/RIGA_LANCIA_UBS_CFT2.txt') / 1024))
open('righe/BOOT_RIGA_UBS_CFT2.txt', 'w', encoding='ascii').write(t)
print('boot', len(t))
