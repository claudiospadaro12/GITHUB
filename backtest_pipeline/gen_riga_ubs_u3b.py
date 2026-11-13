#!/usr/bin/env python3
"""[U3b] derivata da gen_riga_ubs_u2.py. U3b: come la tappa 2 di U3 con il DD misurato x1,5 (cuscinetto): 9 set x 2 incroci = 18 passate. Incrocio X: HistoricalMaxDD misurato su P1 (2013-2018), prova su P2 (2019-2025). Incrocio Y: misurato su P2, prova su P1.
Valori = DD01 x 1,15 da report/D160_dati/ubsu3m.json. Criteri: report/UBS_U3B_CRITERI_2026-11-13.md.
Uso: python3 gen_riga_ubs_u3t.py <PIN40> <SHA256 di righe/ANNO80K_WIM_TESTER.ps1 a quel pin>"""
import re, sys, os, json
os.chdir(os.path.dirname(os.path.abspath(__file__)))
M = json.load(open('../report/D160_dati/ubsu3m.json'))
s = open('gen_riga_ubs_u2.py', encoding='utf-8').read()
a = s.index("U2SETS = ["); b = s.index("N = len(runs)")
nuovo = ("import json\n"
         "M = json.load(open('../report/D160_dati/ubsu3m.json'))\n"
         "U3SETS = [('Gold_Phantom_strat8.set', 'H1', 'PH_strat8'), ('Gold_Phantom_strat3.set', 'D1', 'PH_strat3'), ('dailyC.set', 'D1', 'GB_dailyC'), ('GOLDTRADEPRO_E.set', 'D1', 'GTP_E'), ('Gold_c.set', 'D1', 'PHd_c'), ('dailyI.set', 'D1', 'GB_dailyI'), ('GOLDTRADEPRO_a.set', 'D1', 'GTP_a'), ('strategy5_H1.set', 'H1', 'GR_s5_H1'), ('strategy1_Daily.set', 'D1', 'GR_s1_D1')]\n"
         "for st, per, tag in U3SETS:\n"
         "    base = 'Risk=123:i;MaxRiskPerStrategy_Value=2.0:d;AdjustLotsizeToVariableValues=true:b;'\n"
         "    hx = round(1.5 * 1.15 * M[tag]['dd01_P1'], 2); hy = round(1.5 * 1.15 * M[tag]['dd01_P2'], 2)\n"
         "    runs.append((EA, ZIP, '2019', '2026.01.01', per, st, base + 'HistoricalMaxDD=%s:d' % repr(float(hx)), 'UBSU3B_X_%s_100000_2019-2025' % tag, 100000))\n"
         "    runs.append((EA, ZIP, '2013', '2019.01.01', per, st, base + 'HistoricalMaxDD=%s:d' % repr(float(hy)), 'UBSU3B_Y_%s_100000_2013-2018' % tag, 100000))\n")
s = s[:a] + nuovo + s[b:]
s = s.replace("RIGA_LANCIA_UBS_U2.txt", "RIGA_LANCIA_UBS_U3B.txt").replace("ANNO_ORO_GRADINI_UBSU2_", "ANNO_ORO_GRADINI_UBSU3B_")
s = s.replace("U2 UBS: LOTTO DAL RISCHIO. 9 set oro", "U3b UBS (LOTTO DAL RISCHIO CON DD MISURATO IN UN ALTRO PERIODO x1,5 DI CUSCINETTO). 9 set oro")
s = s.replace("periodo 2013-01-01 -> 2026-01-01. Input imposti: Risk=123 (use Max Risk Per Strategy), MaxRiskPerStrategy_Value=2.0, AdjustLotsizeToVariableValues=true e HistoricalMaxDD: braccio A = DD DICHIARATO dal set, braccio B = DD BCM MISURATO a 0,01 lotti in dollari (U1b). 18 passate (9 set x 2 bracci). Criteri e previsioni: report/UBS_U2_CRITERI_2026-11-11.md.",
              "due prove: 2019-01-01 -> 2026-01-01 con HistoricalMaxDD misurato su 2013-2018 (incrocio X) e 2013-01-01 -> 2019-01-01 con HistoricalMaxDD misurato su 2019-2025 (incrocio Y). Input imposti: Risk=123 (use Max Risk Per Strategy), MaxRiskPerStrategy_Value=2.0, AdjustLotsizeToVariableValues=true e HistoricalMaxDD (DD BCM a 0,01 lotti x 1,15 in dollari x 1,5 di cuscinetto, dalla tappa 1). 18 passate (9 set x 2 incroci). Criteri e previsioni: report/UBS_U3B_CRITERI_2026-11-13.md.")
s = s.replace("9 set su 13 anni, 2 bracci", "9 set su 6-7 anni, 2 incroci")
sys.argv = ['gen_riga_ubs_u3t_tmp.py'] + sys.argv[1:]
exec(compile(s, 'gen_riga_ubs_u3t_tmp', 'exec'))
