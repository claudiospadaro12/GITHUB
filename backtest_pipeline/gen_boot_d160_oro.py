#!/usr/bin/env python3
"""Riga CORTA di O-2 (weekend oro). Modello: righe/BOOT_RIGA_WIM_FOREX_OOS.txt. Uso: python3 gen_boot_oro_weekend.py <PIN40 della riga lunga> <SHA256 della riga lunga>"""
import sys, os
PIN, SHA = sys.argv[1], sys.argv[2].upper()
os.chdir(os.path.dirname(os.path.abspath(__file__)))
t = open('righe/BOOT_RIGA_WIM_FOREX_OOS.txt', encoding='ascii').read()
def sost(a, b, n=1):
    global t
    assert t.count(a) == n, (t.count(a), a[:80])
    t = t.replace(a, b)
sost("e79c3208d6d1b0a7296047cd58bedfacb4dff3bd", PIN)
sost("2CC70222A7D063BA17FB4D4E6065394F7EEA410703330887E6826B6EA7B11744", SHA)
sost("RIGA_LANCIA_WIM_FOREX_OOS.txt", "RIGA_LANCIA_D160_ORO.txt", 3)
sost("e79c3208", PIN[:8])
sost("Questa e la riga CORTA dei 4 EA FOREX di Wim (Daytrade Pro, Luna AI Pro, Stability Pro, Apex Trader: FUORI CAMPIONE: 10 set, 7 anni nuovi 2014-2024, 70 passate) a 4.000 EUR, la taglia del conto reale di Claudio, solo tester, terminale BCM demo 50503392 del PC di backtest",
     "Questa e la riga CORTA di D160 ORO: le componenti oro di Wim (Goldbot Prop e Combo, Phantom Gradino 1 e Prop, Reaper Combo) a DEPOSITO 160.000 EUR, anni 2013, 2020, 2025, nessun input cambiato, per verificare che 160k renda il doppio di 80k: 24 passate (rumorose in 2 ripetizioni), solo tester, terminale BCM demo 50503392 del PC di backtest")
sost("(32 KB, passata dal cancello)", "(24 KB, passata dal cancello)")
sost("report/CRITERI_FOREX_TESTATO_BENE_2026-11-07.md", "report/CRITERI_D160_2026-11-08.md")
open('righe/BOOT_RIGA_D160_ORO.txt', 'w', encoding='ascii').write(t)
print('boot', len(t))
