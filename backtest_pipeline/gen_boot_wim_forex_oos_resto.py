#!/usr/bin/env python3
"""Riga CORTA della passata Apex Elevated 2024 (resto del giro A). Uso: python3 gen_boot_wim_forex_oos_resto.py <PIN40 della riga lunga> <SHA256 della riga lunga>"""
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
sost("RIGA_LANCIA_WIM_FOREX_OOS.txt", "RIGA_LANCIA_WIM_FOREX_OOS_RESTO.txt", 3)
sost("e79c3208", PIN[:8])
sost("Questa e la riga CORTA dei 4 EA FOREX di Wim (Daytrade Pro, Luna AI Pro, Stability Pro, Apex Trader: FUORI CAMPIONE: 10 set, 7 anni nuovi 2014-2024, 70 passate) a 4.000 EUR",
     "Questa e la riga CORTA di UNA SOLA PASSATA da rifare del giro A forex fuori campione: Apex Trader, ApexElevatedGrid, anno 2024, a 4.000 EUR, con timeout di 40 minuti (la passata era KO per il salvataggio del report bloccato)")
sost("(32 KB, passata dal cancello)", "(20 KB, passata dal cancello)")
open('righe/BOOT_RIGA_WIM_FOREX_OOS_RESTO.txt', 'w', encoding='ascii').write(t)
print('boot', len(t))
