#!/usr/bin/env python3
"""[U3a] derivata da gen_riga_ubs_u2.py. Tappa 1 di U3 (misura del DD a lotto fisso 0,1 su due periodi): 9 set x 2 periodi = 18 passate, set cosi come consegnati, nessun input imposto. Criteri: report/UBS_U3_CRITERI_2026-11-12.md.
Uso: python3 gen_riga_ubs_u3a.py <PIN40> <SHA256 di righe/ANNO80K_WIM_TESTER.ps1 a quel pin>"""
import re, subprocess, sys, os
os.chdir(os.path.dirname(os.path.abspath(__file__)))
s = open('gen_riga_ubs_u2.py', encoding='utf-8').read()
a = s.index("U2SETS = ["); b = s.index("N = len(runs)")
nuovo = ("U3SETS = [('Gold_Phantom_strat8.set', 'H1', 'PH_strat8'), ('Gold_Phantom_strat3.set', 'D1', 'PH_strat3'), ('dailyC.set', 'D1', 'GB_dailyC'), ('GOLDTRADEPRO_E.set', 'D1', 'GTP_E'), ('Gold_c.set', 'D1', 'PHd_c'), ('dailyI.set', 'D1', 'GB_dailyI'), ('GOLDTRADEPRO_a.set', 'D1', 'GTP_a'), ('strategy5_H1.set', 'H1', 'GR_s5_H1'), ('strategy1_Daily.set', 'D1', 'GR_s1_D1')]\n"
         "for st, per, tag in U3SETS:   # tappa 1: set come consegnati (lotto fisso 0,1); P1 = 2013-01-01 -> 2019-01-01, P2 = 2019-01-01 -> 2026-01-01\n"
         "    runs.append((EA, ZIP, '2013', '2019.01.01', per, st, '', 'UBSU3M_%s_100000_2013-2018' % tag, 100000))\n"
         "    runs.append((EA, ZIP, '2019', '2026.01.01', per, st, '', 'UBSU3M_%s_100000_2019-2025' % tag, 100000))\n")
s = s[:a] + nuovo + s[b:]
s = s.replace("RIGA_LANCIA_UBS_U2.txt", "RIGA_LANCIA_UBS_U3A.txt").replace("ANNO_ORO_GRADINI_UBSU2_", "ANNO_ORO_GRADINI_UBSU3M_")
s = s.replace("U2 UBS: LOTTO DAL RISCHIO. 9 set oro", "U3 UBS TAPPA 1 (MISURA DEL DD SU DUE PERIODI). 9 set oro")
s = s.replace("periodo 2013-01-01 -> 2026-01-01. Input imposti: Risk=123 (use Max Risk Per Strategy), MaxRiskPerStrategy_Value=2.0, AdjustLotsizeToVariableValues=true e HistoricalMaxDD: braccio A = DD DICHIARATO dal set, braccio B = DD BCM MISURATO a 0,01 lotti in dollari (U1b). 18 passate (9 set x 2 bracci). Criteri e previsioni: report/UBS_U2_CRITERI_2026-11-11.md.",
              "due periodi: 2013-01-01 -> 2019-01-01 e 2019-01-01 -> 2026-01-01, set COSI COME CONSEGNATI (lotto fisso 0,1, nessun input imposto). 18 passate (9 set x 2 periodi). Criteri e previsioni: report/UBS_U3_CRITERI_2026-11-12.md.")
s = s.replace("assert N == 18", "assert N == 18")
s = s.replace("9 set su 13 anni, 2 bracci", "9 set su 6-7 anni, 2 periodi")
open('/tmp/_gen_u3a_tmp.py', 'w', encoding='utf-8').write(s)
sys.argv = ['gen_riga_ubs_u3a_tmp.py'] + sys.argv[1:]
exec(compile(s, 'gen_riga_ubs_u3a_tmp', 'exec'))
