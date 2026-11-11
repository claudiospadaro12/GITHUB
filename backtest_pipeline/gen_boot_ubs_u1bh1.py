#!/usr/bin/env python3
"""Riga CORTA di U1b-H1 UBS. Modello: righe/BOOT_RIGA_UBS_U1B.txt. Uso: python3 gen_boot_ubs_u1bh1.py <PIN40 della riga lunga> <SHA256 della riga lunga>"""
import sys, os, re
PIN, SHA = sys.argv[1], sys.argv[2].upper()
os.chdir(os.path.dirname(os.path.abspath(__file__)))
t = open('righe/BOOT_RIGA_UBS_U1B.txt', encoding='ascii').read()
def sost(a, b, n=1):
    global t
    assert t.count(a) == n, (t.count(a), a[:80])
    t = t.replace(a, b)
OLD8 = re.search(r"commit inchiodato ([0-9a-f]{8}) ", t).group(1)
OLD40 = list(set(re.findall(r"\b[0-9a-f]{40}\b", t)))[0]
OLDSHA = list(set(re.findall(r"\b[0-9A-F]{64}\b", t)))[0]
sost(OLD40, PIN); sost(OLDSHA, SHA)
sost("RIGA_LANCIA_UBS_U1B.txt", "RIGA_LANCIA_UBS_U1BH1.txt", t.count("RIGA_LANCIA_UBS_U1B.txt"))
sost(OLD8, PIN[:8], t.count(OLD8))
sost("U1b UBS: 37 set oro di Wim in formato UBS, EA Ultimate_Breakout_EA_WSC_V9.5, a lotto fisso, XAUUSD, periodo lungo 2005-2025 per tutti i 37 e 2013-2025 per i 31 non gia nel pilota, deposito 100.000 EUR, per ricalibrare il max DD a 0,01 lotti su BCM: 68 passate, circa 3-4,5 ore, da lasciare girare di notte",
     "U1b-H1 UBS: 9 set oro H1 di Wim in formato UBS (Reaper strategy5-9, Phantom strat6-9), EA Ultimate_Breakout_EA_WSC_V9.5, a lotto fisso, XAUUSD, periodo 2005-2012 (il pezzo saltato per il tetto di barre del tester), deposito 100.000 EUR: 9 passate, circa 30-60 minuti")
sost("report/UBS_U1B_CRITERI_2026-11-10.md", "report/UBS_U1B_CRITERI_2026-11-10.md (sezione U1b-H1)")
sost("(32 KB, passata dal cancello)", "(%d KB, passata dal cancello)" % round(os.path.getsize('righe/RIGA_LANCIA_UBS_U1BH1.txt') / 1024))
open('righe/BOOT_RIGA_UBS_U1BH1.txt', 'w', encoding='ascii').write(t)
print('boot', len(t))
