#!/usr/bin/env python3
"""Riga CORTA di OTT1 (Goldbot One Prop tappa 1). Modello: righe/BOOT_RIGA_UBS_U3T.txt. Uso: python3 gen_boot_ott1.py <PIN40 della riga lunga> <SHA256 della riga lunga>"""
import sys, os, re
PIN, SHA = sys.argv[1], sys.argv[2].upper()
os.chdir(os.path.dirname(os.path.abspath(__file__)))
t = open('righe/BOOT_RIGA_UBS_U3T.txt', encoding='ascii').read()
def sost(a, b, n=1):
    global t
    assert t.count(a) == n, (t.count(a), a[:80])
    t = t.replace(a, b)
OLD40 = list(set(re.findall(r"\b[0-9a-f]{40}\b", t)))[0]; OLD8 = OLD40[:8]
OLDSHA = list(set(re.findall(r"\b[0-9A-F]{64}\b", t)))[0]
sost(OLD40, PIN); sost(OLDSHA, SHA)
sost("RIGA_LANCIA_UBS_U3T.txt", "RIGA_LANCIA_OTT1.txt", t.count("RIGA_LANCIA_UBS_U3T.txt"))
sost(OLD8, PIN[:8], t.count(OLD8))
m = re.search(r"Questa e la riga CORTA di (.*?): 18 passate, solo tester", t)
assert m
t = t.replace(m.group(1), "OTT1 (Goldbot One Prop, tappa 1: contributo delle 8 strategie A-H): EA Goldbot One MT5.ex5, XAUUSD D1, set ufficiale Goldbot_PropFirm_5_2.5.set da combodeal.zip, deposito 80.000 EUR, periodi 2013-2018 e 2019-2025, la BASE e otto prove senza una strategia (RunStrategyA..H=false)")
sost("report/UBS_U3_CRITERI_2026-11-12.md", "report/OTT1_GOLDBOT_PROP_CRITERI_2026-11-13.md")
sost("(25 KB, passata dal cancello)", "(%d KB, passata dal cancello)" % round(os.path.getsize('righe/RIGA_LANCIA_OTT1.txt') / 1024))
open('righe/BOOT_RIGA_OTT1.txt', 'w', encoding='ascii').write(t)
print('boot', len(t))
