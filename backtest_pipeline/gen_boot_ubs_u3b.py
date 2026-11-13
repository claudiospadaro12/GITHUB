#!/usr/bin/env python3
"""Riga CORTA di U3b UBS. Modello: righe/BOOT_RIGA_UBS_U3T.txt. Uso: python3 gen_boot_ubs_u3b.py <PIN40 della riga lunga> <SHA256 della riga lunga>"""
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
sost("RIGA_LANCIA_UBS_U3T.txt", "RIGA_LANCIA_UBS_U3B.txt", t.count("RIGA_LANCIA_UBS_U3T.txt"))
sost(OLD8, PIN[:8], t.count(OLD8))
m = re.search(r"Questa e la riga CORTA di (.*?): 18 passate, solo tester", t); assert m
t = t.replace(m.group(1), "U3b UBS (lotto dal rischio con il DD misurato in un ALTRO periodo x 1,5 di cuscinetto): 9 set oro di Wim in formato UBS, EA Ultimate_Breakout_EA_WSC_V9.5, XAUUSD, prova 2019-2025 con DD misurato su 2013-2018 e prova 2013-2018 con DD misurato su 2019-2025, deposito 100.000 EUR, Risk=123 (use Max Risk Per Strategy) al 2%")
sost("report/UBS_U3_CRITERI_2026-11-12.md", "report/UBS_U3B_CRITERI_2026-11-13.md")
sost("(25 KB, passata dal cancello)", "(%d KB, passata dal cancello)" % round(os.path.getsize('righe/RIGA_LANCIA_UBS_U3B.txt') / 1024))
open('righe/BOOT_RIGA_UBS_U3B.txt', 'w', encoding='ascii').write(t)
print('boot', len(t))
