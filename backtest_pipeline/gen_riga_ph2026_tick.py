#!/usr/bin/env python3
"""[PH2026] derivata da gen_riga_d160_oro.py. The Gold Phantom Gradino 1 (GoldPhantom_Propfirm.set da combodeal.zip) a TICK REALI (Modello 4), 01/01/2026 -> 13/11/2026, due depositi: 80000 e 5000 EUR = 2 passate.
Criteri: report/CONFRONTO_M1_TICK_REALI_CRITERI_2026-11-14.md (Tappa 3). Uso: python3 gen_riga_ph2026_tick.py <PIN40> <SHA256 di righe/ANNO80K_WIM_TESTER.ps1 a quel pin>"""
import sys, os
os.chdir(os.path.dirname(os.path.abspath(__file__)))
s = open('gen_riga_d160_oro.py', encoding='utf-8').read()
def rep(a, b, n=1):
    global s
    assert s.count(a) == n, (s.count(a), a[:80])
    s = s.replace(a, b)
rep("N = len(runs)\nassert N == 24",
    "runs = [('The Gold Phantom.ex5', ZIP, '2026', '2026.11.13', 'H1', 'GoldPhantom_Propfirm.set', '', 'PH2026_L1_80000_2026', 80000),\n"
    "        ('The Gold Phantom.ex5', ZIP, '2026', '2026.11.13', 'H1', 'GoldPhantom_Propfirm.set', '', 'PH2026_L1_5000_2026', 5000)]\n"
    "N = len(runs)\nassert N == 2")
rep("q(['1'] * N)", "q(['4'] * N)")
i = s.index("testa = ("); j = s.index('t = t[:i] + "Write-Host')
testa = ('testa = ("PH2026 PHANTOM A TICK REALI: The Gold Phantom Gradino 1 (GoldPhantom_Propfirm.set, set UFFICIALE da combodeal.zip, nessun input cambiato), XAUUSD H1, DEMO, SOLO TESTER, Modello 4 (tick reali), dal 01/01/2026 al 13/11/2026, due passate: deposito 80000 EUR (la nostra configurazione P1) e 5000 EUR (per avvicinare il segnale Darwinex di Wim). Serve a capire se il divario tra il Phantom in tester (2025, PF circa 2,9) e il Phantom live (segnale PF circa 1,07; nostro trial) dipende da periodo, capitale piccolo o dai costi. Criteri: report/CONFRONTO_M1_TICK_REALI_CRITERI_2026-11-14.md (Tappa 3). Nessun giudizio su taglie o acquisti.")\n')
s = s[:i] + testa + s[j:]
rep("MOLTE ORE (\" + str(N) + \" passate, stima 4-5 ore, non misurata); timeout 90 minuti per passata (NON 600).", "ORE (\" + str(N) + \" passate a tick reali su 10,5 mesi: una passata del Reaper a tick su 21 mesi ha richiesto circa 3 ore; stima totale 3-6 ore, non misurata); timeout 300 minuti per passata.")
rep('"$TO=90;"', '"$TO=300;"')
rep("ANNO_ORO_GRADINI_D160ORO_", "ANNO_ORO_GRADINI_PH2026_")
rep("RIGA_LANCIA_D160_ORO.txt", "RIGA_LANCIA_PH2026_TICK.txt")
sys.argv = ['gen_riga_ph2026_tmp.py'] + sys.argv[1:]
exec(compile(s, 'gen_riga_ph2026_tmp', 'exec'))
_p = 'righe/RIGA_LANCIA_PH2026_TICK.txt'
_t = open(_p, encoding='ascii').read().replace('deposito 80000 o 3745 EUR', 'deposito 80000 o 5000 EUR (secondo la passata)').replace('3745', '5000')
open(_p, 'w', encoding='ascii').write(_t)
_a = "if($okl.Count -lt 3){ throw 'Mancano uno o piu EA oro (The Gold Reaper MT5.ex5, The Gold Phantom.ex5, Goldbot One MT5.ex5) in MQL5\\Experts di questo terminale. Nessun tester e partito.' }"
_b = "if($okl.Count -lt 1){ throw 'Manca The Gold Phantom.ex5 in MQL5\\Experts di questo terminale. Nessun tester e partito.' }"
assert _t.count(_a) == 1, _t.count(_a)
_t = _t.replace(_a, _b).replace('(secondo la passata) a seconda della passata)', '(secondo la passata))')
open(_p, 'w', encoding='ascii').write(_t)
print('testo deposito corretto:', '3745' not in _t)
