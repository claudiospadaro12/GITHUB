#!/usr/bin/env python3
"""Riga CORTA di U1b UBS. Modello: righe/BOOT_RIGA_UBS_U1_PILOTA.txt. Uso: python3 gen_boot_ubs_u1b.py <PIN40 della riga lunga> <SHA256 della riga lunga>"""
import sys, os
PIN, SHA = sys.argv[1], sys.argv[2].upper()
os.chdir(os.path.dirname(os.path.abspath(__file__)))
t = open('righe/BOOT_RIGA_UBS_U1_PILOTA.txt', encoding='ascii').read()
def sost(a, b, n=1):
    global t
    assert t.count(a) == n, (t.count(a), a[:80])
    t = t.replace(a, b)
import re
m = re.search(r"commit inchiodato ([0-9a-f]{8}) ", t); assert m
OLD8 = m.group(1)
pins = re.findall(r"\b[0-9a-f]{40}\b", t); assert len(set(pins)) == 1, pins
OLD40 = pins[0]
shas = re.findall(r"\b[0-9A-F]{64}\b", t); assert len(set(shas)) == 1, shas
sost(OLD40, PIN)
sost(shas[0], SHA)
sost("RIGA_LANCIA_UBS_U1_PILOTA.txt", "RIGA_LANCIA_UBS_U1B.txt", t.count("RIGA_LANCIA_UBS_U1_PILOTA.txt"))
sost(OLD8, PIN[:8], t.count(OLD8))
sost("U1 PILOTA UBS: 6 set oro di Wim in formato UBS (Goldbot dailyA, Gold Trade Pro a, Phantom strat1, Reaper strategy1, strategy4, strategy5), EA Ultimate_Breakout_EA_WSC_V9.5, a lotto fisso, XAUUSD, 2013-2025, deposito 100.000 EUR, per ricalibrare il max DD a 0,01 lotti su BCM: 6 passate",
     "U1b UBS: 37 set oro di Wim in formato UBS, EA Ultimate_Breakout_EA_WSC_V9.5, a lotto fisso, XAUUSD, periodo lungo 2005-2025 per tutti i 37 e 2013-2025 per i 31 non gia nel pilota, deposito 100.000 EUR, per ricalibrare il max DD a 0,01 lotti su BCM: 68 passate, circa 3-4,5 ore, da lasciare girare di notte")
sost("report/UBS_U1_CRITERI_2026-11-09.md", "report/UBS_U1B_CRITERI_2026-11-10.md")
sost("(21 KB, passata dal cancello)", "(%d KB, passata dal cancello)" % round(os.path.getsize('righe/RIGA_LANCIA_UBS_U1B.txt') / 1024))
open('righe/BOOT_RIGA_UBS_U1B.txt', 'w', encoding='ascii').write(t)
print('boot', len(t))
