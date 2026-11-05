#!/usr/bin/env python3
"""Genera righe/ANNO80K_WIM_FTMO_TESTER.ps1 da righe/ANNO80K_WIM_TESTER.ps1: stesso tester, ma il terminale e' C:\\MT5_Backtest\\Mt5_Ftmo_Prova (FTMO-Demo, conto in SOLA LETTURA con password investitore),
e il terminale BCM diventa un'installazione CENSITA (chiusa, non toccata). Uso: python3 gen_ANNO80K_WIM_FTMO_TESTER.py"""
import hashlib, os
os.chdir(os.path.dirname(os.path.abspath(__file__)))
t = open('righe/ANNO80K_WIM_TESTER.ps1', encoding='ascii').read()
def sost(a, b, n=1):
    global t
    assert t.count(a) == n, (t.count(a), a[:90])
    t = t.replace(a, b)
sost('MARCATORE_ANNO80K_WIM_TESTER_v1', 'MARCATORE_ANNO80K_WIM_FTMO_TESTER_v1', t.count('MARCATORE_ANNO80K_WIM_TESTER_v1'))
sost("$InstAttesa = 'C:\\Program Files\\BCM Markets MT5 Terminal'", "$InstAttesa = 'C:\\MT5_Backtest\\Mt5_Ftmo_Prova'   # FTMO v1 (05/11/2026): terminale di PROVA FTMO sul PC di backtest, conto 1515150476 in SOLA LETTURA (password investitore): non puo operare")
sost("$Censite = @('C:\\MT5_Backtest', 'C:\\FundedNext_Manuale')", "$Censite = @('C:\\MT5_Backtest', 'C:\\FundedNext_Manuale', 'C:\\Program Files\\BCM Markets MT5 Terminal')")
open('righe/ANNO80K_WIM_FTMO_TESTER.ps1', 'w', encoding='ascii', newline='').write(t)
print('ok', len(t), hashlib.sha256(t.encode('ascii')).hexdigest().upper())
