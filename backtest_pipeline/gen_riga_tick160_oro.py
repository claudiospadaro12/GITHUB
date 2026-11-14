#!/usr/bin/env python3
"""[TICK160] derivata da gen_riga_d160_oro.py. Componenti oro di P1/P4 a TICK REALI (Modello 4), solo 2025, deposito 160000, set ufficiali di combodeal.zip: Goldbot L0, Phantom L1, Reaper L3 (1 passata ciascuno) = 3 passate.
Criteri: report/CONFRONTO_M1_TICK_REALI_CRITERI_2026-11-14.md (Tappa 2). Uso: python3 gen_riga_tick160_oro.py <PIN40> <SHA256 di righe/ANNO80K_WIM_TESTER.ps1 a quel pin>"""
import sys, os
os.chdir(os.path.dirname(os.path.abspath(__file__)))
s = open('gen_riga_d160_oro.py', encoding='utf-8').read()
def rep(a, b, n=1):
    global s
    assert s.count(a) == n, (s.count(a), a[:80])
    s = s.replace(a, b)
rep("ANNI = ['2013', '2020', '2025']", "ANNI = ['2025']")
rep("COMP = [('GB', 'L0', 1), ('GB', 'L3', 1), ('PH', 'L1', 2), ('PH', 'L0', 2), ('GR', 'L3', 2)]", "COMP = [('GB', 'L0', 1), ('PH', 'L1', 1), ('GR', 'L3', 1)]")
rep("'D160_R%d_%s_%s_160000_%s' % (rep, liv, tag, anno)", "'TICK160_R%d_%s_%s_160000_%s' % (rep, liv, tag, anno)")
rep("assert N == 24", "assert N == 3")
rep("q(['1'] * N)", "q(['4'] * N)")
i = s.index("testa = ("); j = s.index('t = t[:i] + "Write-Host')
testa = ('testa = ("TICK160 ORO: I COMPONENTI ORO DI P1 E P4 A TICK REALI. The Gold Reaper Combo 3GOLD (L3), The Gold Phantom Gradino 1 (L1) e Goldbot One Prop (L0): UNA passata ciascuno sul 2025 (01/01/2025 - 01/01/2026), XAUUSD, DEMO, SOLO TESTER, Modello 4 (tick reali), deposito 160000 EUR, set UFFICIALI da combodeal.zip, NESSUN input cambiato. Serve a misurare quanto cambiano i risultati rispetto alle passate a candele da 1 minuto gia fatte. 3 passate. Criteri: report/CONFRONTO_M1_TICK_REALI_CRITERI_2026-11-14.md (Tappa 2). Nessun giudizio su taglie o acquisti.")\n')
s = s[:i] + testa + s[j:]
rep("MOLTE ORE (\" + str(N) + \" passate, stima 4-5 ore, non misurata); timeout 90 minuti per passata (NON 600).", "ORE (\" + str(N) + \" passate a tick reali: un anno del Reaper a tick ha richiesto circa 2-3 ore in test precedenti, stima totale 4-8 ore, non misurata); timeout 300 minuti per passata.")
rep('"$TO=90;"', '"$TO=300;"')
rep("ANNO_ORO_GRADINI_D160ORO_", "ANNO_ORO_GRADINI_TICK160_")
rep("RIGA_LANCIA_D160_ORO.txt", "RIGA_LANCIA_TICK160_ORO.txt")
sys.argv = ['gen_riga_tick160_tmp.py'] + sys.argv[1:]
exec(compile(s, 'gen_riga_tick160_tmp', 'exec'))
