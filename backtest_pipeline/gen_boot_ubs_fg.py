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
sost("RIGA_LANCIA_OTT1.txt", "RIGA_LANCIA_UBS_FG.txt", t.count("RIGA_LANCIA_OTT1.txt"))
sost(OLD8, PIN[:8], t.count(OLD8))
m = re.search(r"Questa e la riga CORTA di (.*?): 18 passate, solo tester", t)
assert m
t = t.replace(m.group(1) + ": 18 passate, solo tester", "UBS US30 g di Wim sul FEED FTMO (US30.cash, terminale FTMO di prova in sola lettura, Modello 1, 2020-2026, deposito 80.000 EUR; serve l EA Ultimate_Breakout_EA_WSC_V9.5.ex5 nel terminale FTMO): 7 passate, solo tester")
sost("report/OTT1_GOLDBOT_PROP_CRITERI_2026-11-13.md", "report/UBS_G_FTMO_CRITERI_2026-11-22.md")
sost("(22 KB, passata dal cancello)", "(%d KB, passata dal cancello)" % round(os.path.getsize('righe/RIGA_LANCIA_UBS_FG.txt') / 1024))
_a = "con MT5 CHIUSO (tutti e QUATTRO: BCM, C:\\MT5_Backtest, C:\\FundedNext_Manuale e C:\\MT5_Backtest\\Mt5_Ftmo_Prova)"
assert t.count(_a) == 1, t.count(_a)
t = t.replace(_a, "con il terminale PRINCIPALE BCM (C:\\Program Files\\BCM Markets MT5 Terminal) CHIUSO e senza altri test del tester in corso: il portatile C:\\MT5_BCM_Opt con l ottimizzazione PUO restare aperto (guardia selettiva: conta solo i processi del terminale principale)")
_x = r"con il terminale PRINCIPALE BCM (C:\Program Files\BCM Markets MT5 Terminal) CHIUSO e senza altri test del tester in corso: il portatile C:\MT5_BCM_Opt con l ottimizzazione PUO restare aperto (guardia selettiva: conta solo i processi del terminale principale)"
assert t.count(_x) == 1, t.count(_x)
t = t.replace(_x, r"con il terminale FTMO di prova (C:\MT5_Backtest\Mt5_Ftmo_Prova) CHIUSO e senza altri test del tester in corso: il portatile C:\MT5_BCM_Opt con l ottimizzazione PUO restare aperto (guardia selettiva)")
_y = "terminale BCM demo 50503392 del PC di backtest"
assert t.count(_y) == 1, t.count(_y)
t = t.replace(_y, "terminale FTMO di prova del PC di backtest (sola lettura)")
open('righe/BOOT_RIGA_UBS_FG.txt', 'w', encoding='ascii').write(t)
print('boot', len(t))
