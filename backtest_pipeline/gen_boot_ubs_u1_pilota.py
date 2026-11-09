#!/usr/bin/env python3
"""Riga CORTA di U1 pilota UBS. Modello: righe/BOOT_RIGA_GTP_FRI19.txt. Uso: python3 gen_boot_ubs_u1_pilota.py <PIN40 della riga lunga> <SHA256 della riga lunga>"""
import sys, os
PIN, SHA = sys.argv[1], sys.argv[2].upper()
os.chdir(os.path.dirname(os.path.abspath(__file__)))
t = open('righe/BOOT_RIGA_GTP_FRI19.txt', encoding='ascii').read()
def sost(a, b, n=1):
    global t
    assert t.count(a) == n, (t.count(a), a[:80])
    t = t.replace(a, b)
sost("4f152e3095b33846a6521e504df2672708e35e1a", PIN)
sost("B8FC4CD741FC228BB6B87D208BD2BF6C0AB84346906A6911BAE9E1F3085E9E09", SHA)
sost("RIGA_LANCIA_GTP_FRI19.txt", "RIGA_LANCIA_UBS_U1_PILOTA.txt", 3)
sost("4f152e30", PIN[:8])
sost("O-2 GOLD TRADE PRO: Gold Trade Pro COMBO (XAUUSD D1, stessi input del test a 80k) con FridayStopHour=19 (chiusura del venerdi) a DEPOSITO 80.000 EUR, anni 2013, 2018, 2020, 2025, per misurare il costo della chiusura del venerdi: 4 passate", "U1 PILOTA UBS: 6 set oro di Wim in formato UBS (Goldbot dailyA, Gold Trade Pro a, Phantom strat1, Reaper strategy1, strategy4, strategy5), EA Ultimate_Breakout_EA_WSC_V9.5, a lotto fisso, XAUUSD, 2013-2025, deposito 100.000 EUR, per ricalibrare il max DD a 0,01 lotti su BCM: 6 passate")
sost("report/CRITERI_O2_GTP_2026-11-09.md", "report/UBS_U1_CRITERI_2026-11-09.md")
sost("(17 KB, passata dal cancello)", "(%d KB, passata dal cancello)" % round(os.path.getsize('righe/RIGA_LANCIA_UBS_U1_PILOTA.txt') / 1024))
open('righe/BOOT_RIGA_UBS_U1_PILOTA.txt', 'w', encoding='ascii').write(t)
print('boot', len(t))
