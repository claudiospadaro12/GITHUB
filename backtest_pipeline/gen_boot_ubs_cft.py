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
sost("RIGA_LANCIA_OTT1.txt", "RIGA_LANCIA_UBS_CFT.txt", t.count("RIGA_LANCIA_OTT1.txt"))
sost(OLD8, PIN[:8], t.count(OLD8))
m = re.search(r"Questa e la riga CORTA di (.*?): 18 passate, solo tester", t)
assert m
t = t.replace(m.group(1) + ": 18 passate, solo tester", "UBS C FOREX A TICK REALI (7 set di Wim passati in Fase 2: scalper EURUSD x2, GBPUSD, USDJPY x2 e volatility breakout EURUSD f e o; anno 2025, Modello 1 e Modello 4 tick reali sulla stessa finestra, deposito 100.000 EUR, lotto fisso 0,1): 14 passate, solo tester")
sost("report/OTT1_GOLDBOT_PROP_CRITERI_2026-11-13.md", "report/RISULTATI_UBS_C_FOREX_2026-11-15.md")
sost("(22 KB, passata dal cancello)", "(%d KB, passata dal cancello)" % round(os.path.getsize('righe/RIGA_LANCIA_UBS_CFT.txt') / 1024))
open('righe/BOOT_RIGA_UBS_CFT.txt', 'w', encoding='ascii').write(t)
print('boot', len(t))
