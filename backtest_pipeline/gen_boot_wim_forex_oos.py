#!/usr/bin/env python3
"""Riga CORTA del giro A forex fuori campione: parte da BOOT_RIGA_WIM_FOREX_4K.txt. Uso: python3 gen_boot_wim_forex_oos.py <PIN40 della riga lunga> <SHA256 della riga lunga>"""
import sys, os
PIN, SHA = sys.argv[1], sys.argv[2].upper()
os.chdir(os.path.dirname(os.path.abspath(__file__)))
t = open('righe/BOOT_RIGA_WIM_FOREX_4K.txt', encoding='ascii').read()
def sost(a, b, n=1):
    global t
    assert t.count(a) == n, (t.count(a), a[:80])
    t = t.replace(a, b)
sost("9b00d94809ce04b42d34bd789e777e2730db8a9e", PIN)
sost("D99D6C08AD124495B0182FB9A4A6AA32CDD22C790B28C92A866BA8910BE20140", SHA)
sost("RIGA_LANCIA_WIM_FOREX_4K.txt", "RIGA_LANCIA_WIM_FOREX_OOS.txt", 3)
sost("9b00d948", PIN[:8])
sost("14 set, 5 anni, 70 passate", "FUORI CAMPIONE: 10 set, 7 anni nuovi 2014-2024, 70 passate")
sost("report/CRITERI_FOREX_4K_2026-11-05.md", "report/CRITERI_FOREX_TESTATO_BENE_2026-11-07.md")
open('righe/BOOT_RIGA_WIM_FOREX_OOS.txt', 'w', encoding='ascii').write(t)
print('boot', len(t))
