#!/usr/bin/env python3
"""[OTT1] derivata da gen_riga_d160_oro.py. Tappa 1: Goldbot One Prop (Goldbot_PropFirm_5_2.5.set da combodeal.zip), deposito 80000, BASE + 8 prove 'senza RunStrategyX' x 2 periodi = 18 passate.
Criteri: report/OTT1_GOLDBOT_PROP_CRITERI_2026-11-13.md. Uso: python3 gen_riga_ott1.py <PIN40> <SHA256 di righe/ANNO80K_WIM_TESTER.ps1 a quel pin>"""
import re, sys, os
os.chdir(os.path.dirname(os.path.abspath(__file__)))
s = open('gen_riga_d160_oro.py', encoding='utf-8').read()
a = s.index("EAS = ["); b = s.index("N = len(runs)")
nuovo = ("runs = []   # (ex5, zip, anno, fine, periodo, set, imposti, etichetta, deposito)\n"
         "EX5 = 'Goldbot One MT5.ex5'; SET = 'Goldbot_PropFirm_5_2.5.set'\n"
         "for anno, fine, pert in (('2013', '2019.01.01', '2013-2018'), ('2019', '2026.01.01', '2019-2025')):\n"
         "    runs.append((EX5, ZIP, anno, fine, 'D1', SET, '', 'OTT1_BASE_GB_80000_%s' % pert, 80000))\n"
         "    for L in 'ABCDEFGH':\n"
         "        runs.append((EX5, ZIP, anno, fine, 'D1', SET, 'RunStrategy%s=false:b' % L, 'OTT1_NO%s_GB_80000_%s' % (L, pert), 80000))\n")
s = s[:a] + nuovo + s[b:]
s = s.replace("assert N == 24", "assert N == 18")
i = s.index("testa = ("); j = s.index('t = t[:i] + "Write-Host')
testa = ('testa = ("OTT1 GOLDBOT ONE PROP, TAPPA 1: CONTRIBUTO DELLE 8 STRATEGIE A-H. EA Goldbot One MT5.ex5, XAUUSD D1, DEMO, SOLO TESTER, Modello 1, deposito 80000 EUR, set ufficiale Goldbot_PropFirm_5_2.5.set da combodeal.zip. Per due periodi (2013-01-01 -> 2019-01-01 e 2019-01-01 -> 2026-01-01): la BASE (set cosi come e) e otto prove SENZA una strategia (RunStrategyA..H=false, una alla volta): 18 passate. Criteri e previsioni: report/OTT1_GOLDBOT_PROP_CRITERI_2026-11-13.md. Mi mandi la cartella ABTG_RISULTATI\\\\\\\\ANNO_ORO_GRADINI_OTT1_<data> (o gli zip spezzati). Non giudica acquisti, taglie ne lotti. MT5 deve essere CHIUSO. NON e collaudata da agenti: ha passato SOLO il cancello meccanico e il mio controllo.")\n')
s = s[:i] + testa + s[j:]
s = s.replace("The Gold Reaper, The Gold Phantom e Goldbot One devono essere gia installati (Market) su QUESTO terminale, UNA copia sola ciascuno", "Goldbot One MT5.ex5 deve essere gia installato (Market) su QUESTO terminale, UNA copia sola")
s = s.replace("stima 4-5 ore, non misurata", "stima 2-4 ore: una passata annuale del Goldbot dura circa 143 s, non misurata per 6-7 anni")
s = s.replace("if($okl.Count -lt 3){ throw 'Mancano uno o piu EA oro (The Gold Reaper MT5.ex5, The Gold Phantom.ex5, Goldbot One MT5.ex5) in MQL5\\\\Experts di questo terminale. Nessun tester e partito.' }", "if($okl.Count -lt 1){ throw 'Manca Goldbot One MT5.ex5 in MQL5\\\\Experts di questo terminale. Nessun tester e partito.' }")
s = s.replace("t = t.replace('80.000 EUR', 'deposito 80000 o 3745 EUR').replace('80000 EUR', 'deposito 80000 o 3745 EUR')", "pass")
s = s.replace('sost("passate da fare a 80000 EUR: ", "passate da fare (deposito 80000 o 3745 EUR a seconda della passata): ")', 'pass')
s = s.replace("ANNO_ORO_GRADINI_D160ORO_", "ANNO_ORO_GRADINI_OTT1_").replace("RIGA_LANCIA_D160_ORO.txt", "RIGA_LANCIA_OTT1.txt")
sys.argv = ['gen_riga_ott1_tmp.py'] + sys.argv[1:]
exec(compile(s, 'gen_riga_ott1_tmp', 'exec'))
