#!/usr/bin/env python3
"""Riga CORTA di UBS C FOREX. Modello: righe/BOOT_RIGA_OTT1.txt. Uso: python3 gen_boot_ubs_cft.py <PIN40 della riga lunga> <SHA256 della riga lunga>"""
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
sost("RIGA_LANCIA_OTT1.txt", "RIGA_LANCIA_UBS_GE.txt", t.count("RIGA_LANCIA_OTT1.txt"))
sost(OLD8, PIN[:8], t.count(OLD8))
m = re.search(r"Questa e la riga CORTA di (.*?): 18 passate, solo tester", t)
assert m
t = t.replace(m.group(1) + ": 18 passate, solo tester", "UBS GOLD TRADE PRO (GTP) ORO D1, PROVA V2 (10 candidati dell ottimizzazione 2013-2022 su XAUUSD D1 2023-2026, Modello 1, deposito 100.000 EUR, lotto 0,1; serve UBS_GTPD1_SET.zip sul Desktop): 10 passate, solo tester")
sost("report/OTT1_GOLDBOT_PROP_CRITERI_2026-11-13.md", "report/GTP_D1_V2_CRITERI_2026-11-24.md")
sost("(22 KB, passata dal cancello)", "(%d KB, passata dal cancello)" % round(os.path.getsize('righe/RIGA_LANCIA_UBS_GE.txt') / 1024))
_a = "con MT5 CHIUSO (tutti e QUATTRO: BCM, C:\\MT5_Backtest, C:\\FundedNext_Manuale e C:\\MT5_Backtest\\Mt5_Ftmo_Prova)"
assert t.count(_a) == 1, t.count(_a)
t = t.replace(_a, "con il terminale PRINCIPALE BCM (C:\\Program Files\\BCM Markets MT5 Terminal) CHIUSO e senza altri test del tester in corso: il portatile C:\\MT5_BCM_Opt con l ottimizzazione PUO restare aperto (guardia selettiva: conta solo i processi del terminale principale)")
open('righe/BOOT_RIGA_UBS_GE.txt', 'w', encoding='ascii').write(t)
print('boot', len(t))
