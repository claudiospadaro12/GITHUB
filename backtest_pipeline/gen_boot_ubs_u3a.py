#!/usr/bin/env python3
"""Riga CORTA di U3a UBS. Modello: righe/BOOT_RIGA_UBS_U2.txt. Uso: python3 gen_boot_ubs_u3a.py <PIN40 della riga lunga> <SHA256 della riga lunga>"""
import sys, os, re
PIN, SHA = sys.argv[1], sys.argv[2].upper()
os.chdir(os.path.dirname(os.path.abspath(__file__)))
t = open('righe/BOOT_RIGA_UBS_U2.txt', encoding='ascii').read()
def sost(a, b, n=1):
    global t
    assert t.count(a) == n, (t.count(a), a[:80])
    t = t.replace(a, b)
OLD40 = list(set(re.findall(r"\b[0-9a-f]{40}\b", t)))[0]; OLD8 = OLD40[:8]
OLDSHA = list(set(re.findall(r"\b[0-9A-F]{64}\b", t)))[0]
sost(OLD40, PIN); sost(OLDSHA, SHA)
sost("RIGA_LANCIA_UBS_U2.txt", "RIGA_LANCIA_UBS_U3A.txt", t.count("RIGA_LANCIA_UBS_U2.txt"))
sost(OLD8, PIN[:8], t.count(OLD8))
sost("la riga CORTA di U2 UBS (lotto dal rischio): 9 set oro di Wim in formato UBS, EA Ultimate_Breakout_EA_WSC_V9.5, XAUUSD, periodo 2013-2025, deposito 100.000 EUR, Risk=123 (use Max Risk Per Strategy) al 2%, con il DD DICHIARATO (braccio A) o il DD BCM MISURATO (braccio B): 18 passate",
     "la riga CORTA di U3 UBS tappa 1 (misura del DD su due periodi): 9 set oro di Wim in formato UBS, EA Ultimate_Breakout_EA_WSC_V9.5, XAUUSD, periodi 2013-2018 e 2019-2025, deposito 100.000 EUR, set come consegnati a lotto fisso 0,1, nessun input imposto: 18 passate")
sost("report/UBS_U2_CRITERI_2026-11-11.md", "report/UBS_U3_CRITERI_2026-11-12.md")
sost("(24 KB, passata dal cancello)", "(%d KB, passata dal cancello)" % round(os.path.getsize('righe/RIGA_LANCIA_UBS_U3A.txt') / 1024))
open('righe/BOOT_RIGA_UBS_U3A.txt', 'w', encoding='ascii').write(t)
print('boot', len(t))
