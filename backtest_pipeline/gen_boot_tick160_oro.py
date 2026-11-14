#!/usr/bin/env python3
"""Riga CORTA di TICK160 ORO (P1/P4 a tick reali 2025). Modello: righe/BOOT_RIGA_OTT1.txt. Uso: python3 gen_boot_tick160_oro.py <PIN40 della riga lunga> <SHA256 della riga lunga>"""
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
sost("RIGA_LANCIA_OTT1.txt", "RIGA_LANCIA_TICK160_ORO.txt", t.count("RIGA_LANCIA_OTT1.txt"))
sost(OLD8, PIN[:8], t.count(OLD8))
m = re.search(r"Questa e la riga CORTA di (.*?): 18 passate, solo tester", t)
assert m
t = t.replace(m.group(1) + ": 18 passate, solo tester", "TICK160 ORO (componenti oro di P1 e P4 a TICK REALI sul 2025, Modello 4, deposito 160.000 EUR: Goldbot One Prop L0, The Gold Phantom Gradino 1 L1, The Gold Reaper Combo 3GOLD L3, set ufficiali da combodeal.zip, nessun input cambiato): 3 passate, solo tester")
sost("report/OTT1_GOLDBOT_PROP_CRITERI_2026-11-13.md", "report/CONFRONTO_M1_TICK_REALI_CRITERI_2026-11-14.md (Tappa 2)")
sost("(22 KB, passata dal cancello)", "(%d KB, passata dal cancello)" % round(os.path.getsize('righe/RIGA_LANCIA_TICK160_ORO.txt') / 1024))
open('righe/BOOT_RIGA_TICK160_ORO.txt', 'w', encoding='ascii').write(t)
print('boot', len(t))
