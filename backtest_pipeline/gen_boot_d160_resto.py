#!/usr/bin/env python3
"""Riga CORTA di D160 per Daytrade Pro Max9 o Gold Trade Pro Combo. Modello: righe/BOOT_RIGA_D160_ORO.txt. Uso: python3 gen_boot_d160_resto.py <dtp|gtp> <PIN40 della riga lunga> <SHA256 della riga lunga>"""
import sys, os
KIND, PIN, SHA = sys.argv[1], sys.argv[2], sys.argv[3].upper()
os.chdir(os.path.dirname(os.path.abspath(__file__)))
t = open('righe/BOOT_RIGA_D160_ORO.txt', encoding='ascii').read()
def sost(a, b, n=1):
    global t
    assert t.count(a) == n, (t.count(a), a[:80])
    t = t.replace(a, b)
size = '%d KB' % round(os.path.getsize('righe/RIGA_LANCIA_D160_%s.txt' % KIND.upper()) / 1024)
if KIND == 'dtp':
    desc = "Daytrade Pro WSC V4.5 con il set ufficiale Max9%DD lowrisk a DEPOSITO 160.000 EUR, anni 2013, 2020, 2025, nessun input cambiato, per verificare che 160k renda il doppio di 80k: 3 passate"
else:
    desc = "Gold Trade Pro COMBO (XAUUSD D1, stessi input del test a 80k) a DEPOSITO 160.000 EUR, anni 2013, 2020, 2025, per verificare che 160k renda il doppio di 80k: 3 passate"
sost("e4b451cfe7225803eeb4c0e92a690dcc067158c1", PIN)
sost("5090D3C1F9D6254DE8400FE07FF2F72BDAA93BE77B667AB6FC6C7D32F448B133", SHA)
sost("RIGA_LANCIA_D160_ORO.txt", "RIGA_LANCIA_D160_%s.txt" % KIND.upper(), 3)
sost("e4b451cf", PIN[:8])
sost("D160 ORO: le componenti oro di Wim (Goldbot Prop e Combo, Phantom Gradino 1 e Prop, Reaper Combo) a DEPOSITO 160.000 EUR, anni 2013, 2020, 2025, nessun input cambiato, per verificare che 160k renda il doppio di 80k: 24 passate (rumorose in 2 ripetizioni)", "D160 %s: %s" % ('DAYTRADE PRO' if KIND == 'dtp' else 'GOLD TRADE PRO', desc))
sost("(24 KB, passata dal cancello)", "(%s, passata dal cancello)" % size)
open('righe/BOOT_RIGA_D160_%s.txt' % KIND.upper(), 'w', encoding='ascii').write(t)
print('boot', KIND, len(t))
