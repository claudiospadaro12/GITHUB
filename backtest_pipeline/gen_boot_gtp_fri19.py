#!/usr/bin/env python3
"""Riga CORTA di O-2 per Gold Trade Pro. Modello: righe/BOOT_RIGA_D160_GTP.txt. Uso: python3 gen_boot_gtp_fri19.py <PIN40 della riga lunga> <SHA256 della riga lunga>"""
import sys, os
PIN, SHA = sys.argv[1], sys.argv[2].upper()
os.chdir(os.path.dirname(os.path.abspath(__file__)))
t = open('righe/BOOT_RIGA_D160_GTP.txt', encoding='ascii').read()
def sost(a, b, n=1):
    global t
    assert t.count(a) == n, (t.count(a), a[:80])
    t = t.replace(a, b)
sost("2e2467d20bae47e33b642babe5c6e6992e0d156a", PIN)
sost("8DB352693FD8651D2E1C528DECB423F26DE93E1AE2DAB28D1CF78BBBDEE5AF07", SHA)
sost("RIGA_LANCIA_D160_GTP.txt", "RIGA_LANCIA_GTP_FRI19.txt", 3)
sost("2e2467d2", PIN[:8])
sost("D160 GOLD TRADE PRO: Gold Trade Pro COMBO (XAUUSD D1, stessi input del test a 80k) a DEPOSITO 160.000 EUR, anni 2013, 2020, 2025, per verificare che 160k renda il doppio di 80k: 3 passate", "O-2 GOLD TRADE PRO: Gold Trade Pro COMBO (XAUUSD D1, stessi input del test a 80k) con FridayStopHour=19 (chiusura del venerdi) a DEPOSITO 80.000 EUR, anni 2013, 2018, 2020, 2025, per misurare il costo della chiusura del venerdi: 4 passate")
sost("(17 KB, passata dal cancello)", "(%d KB, passata dal cancello)" % round(os.path.getsize('righe/RIGA_LANCIA_GTP_FRI19.txt') / 1024))
open('righe/BOOT_RIGA_GTP_FRI19.txt', 'w', encoding='ascii').write(t)
print('boot', len(t))
