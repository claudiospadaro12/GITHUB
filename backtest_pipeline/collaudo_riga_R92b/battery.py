#!/usr/bin/env python3
# -*- coding: ascii -*-
"""
battery.py -- il collaudo a macchina di RIGA_ROUND_R92B.txt (classe 926, 30/09/2026).

Fa girare la riga VERA sotto pwsh (Linux) con un driver FINTO (stub_driver.py) che scrive
CSV e per-trade nel formato di OptFrame/ExportTrades di ABTG_Bulge, e verifica che ogni
cancello dichiarato dalla riga scatti quando deve e NON scatti quando non deve.
NON prova: Windows PowerShell 5.1, MT5, il tester, il tempo, la memoria.

Uso:  python3 backtest_pipeline/collaudo_riga_R92b/battery.py      (esce 0 se tutto come atteso)
Serve: pwsh, python3, iconv. Scrive in $HARNESS_OUT (default /tmp/r92b_harness).
"""
import os, subprocess, sys, glob
QD = os.path.dirname(os.path.abspath(__file__))
OUT = os.environ.get("HARNESS_OUT", "/tmp/r92b_harness")

# (nome, scenario, modifica sed alla riga, grafici, [stringhe che DEVONO esserci], [stringhe che NON devono esserci])
T = [
 ("ok", "scen_ok.json", "", "ok", ["FILE NULLI: nessuno", "ROUND LANCIATI: 6 su 6", "n = Trades IS 77 + Trades OOS 29 = 106", "E3 cella P identica a quella di R92ba", "G1 gemelle identiche"], ["RIGA FERMATA"]),
 ("n01_ctl_low", "scen_n01_ctl_low.json", "", "ok", ["RIGA FERMATA"], ["ROUND LANCIATI: 6 su 6"]),
 ("n02_ctl_130", "scen_n02_ctl_high.json", "", "ok", ["= 130", "FUORI", "RIGA FERMATA", "NON LANCIATI: 5"], []),
 ("n03_ctl_90_dentro", "scen_n03_ctl_90.json", "", "ok", ["= 90, banda", "DENTRO", "FILE NULLI: nessuno"], ["RIGA FERMATA"]),
 ("n04_ctl_122_dentro", "scen_n04_ctl_122.json", "", "ok", ["= 122, banda", "DENTRO", "FILE NULLI: nessuno"], ["RIGA FERMATA"]),
 ("n05_ctl_89_fuori", "scen_n05_ctl_89.json", "", "ok", ["= 89, banda", "FUORI", "RIGA FERMATA"], []),
 ("n06_ctl_123_fuori", "scen_n06_ctl_123.json", "", "ok", ["= 123, banda", "FUORI", "RIGA FERMATA"], []),
 ("n07_offset1_nel_csv_con_n_in_banda", "scen_n07_offset1_in_csv.json", "", "ok", ["= 106, banda", "DENTRO", "P0 PIN DAL CSV DIVERSO", "Signal_Bar_Offset=[1] atteso 0", "RIGA FERMATA"], ["FILE NULLI: nessuno"]),
 ("n08_gemelle_diverse", "scen_n08_twin_diff.json", "", "ok", ["G1 GEMELLE DIVERSE", "RIGA FERMATA"], []),
 ("n09_E3_cella_P_diversa", "scen_n09_E3_P_diversa.json", "", "ok", ["E3 CELLA P DIVERSA", "E3 ROSSA su un altro lavoro", "R92b0, R92be"], ["RIGA FERMATA"]),
 ("n10_prova_mutata", "scen_n10_mut_prova.json", "", "ok", ["prova SHA256 DIVERSO DAL PIN"], ["FILE NULLI: nessuno"]),
 ("n11_EA_mutato", "scen_n11_mut_ea.json", "", "ok", ["ABTG_Bulge.mq5 SHA256 DIVERSO DAL PIN"], ["FILE NULLI: nessuno"]),
 ("n12_asse_diverso", "scen_n12_asse_diverso.json", "", "ok", ["ASSE DIVERSO nel CSV _OOS"], ["FILE NULLI: nessuno"]),
 ("n13_R92ba_senza_righe", "scen_n13_R92ba_vuoto.json", "", "ok", ["RIGA FERMATA: il primo job a finestra lunga (R92ba)", "NON LANCIATI: 4"], []),
 ("n14_R92ba_rc1", "scen_n14_R92ba_rc1.json", "", "ok", ["RIGA FERMATA: il primo job a finestra lunga (R92ba)"], []),
 ("n15_senza_pertrade", "scen_n15_no_pertrade.json", "", "ok", ["FILE NULLI: nessuno", "MANCANTE o vecchio"], ["RIGA FERMATA"]),
 ("n16_controllo_troppo_lento", "scen_n16_tempo.json", r"s/\$minCtl -gt 60/$minCtl -gt 0.01/", "ok", ["RIGA FERMATA: il controllo ha impiegato"], []),
 ("n17_rc2_con_csv_buoni", "scen_n17_rc2_job_d.json", "", "ok", ["rc 2 (NON ATTESO qui"], []),
 ("n18_csv_OOS_assente", "scen_n18_no_OOS_job_d.json", "", "ok", ["R92bd (E0: CSV _OOS NON BUONO (ASSENTE))"], ["RIGA FERMATA"]),
 ("n19_finestra_riga_diversa_dal_file", "scen_ok.json", r"s/fz='0.7275'; ct='Signal_Bar_Offset=0/fz='0.7274'; ct='Signal_Bar_Offset=0/", "ok", ["FINESTRA/SIMBOLO/TF DEL FILE PROVA DIVERSI", "RIGA FERMATA"], []),
 ("n20_grafico_con_EA", "scen_ok.json", "", "ea", ["GUARDIA EA: grafici salvati letti 3, con un EA attaccato 1", "GUARDIA EA: nel profilo del terminale 50503392"], ["ROUND LANCIATI"]),
 ("n21_zero_grafici", "scen_ok.json", "", "zero", ["GUARDIA EA: ho letto ZERO grafici salvati"], ["ROUND LANCIATI"]),
]
fails = 0
for nome, scen, mod, ch, deve, non in T:
    subprocess.run(["bash", os.path.join(QD, "run.sh"), nome, os.path.join(QD, scen), mod, ch], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
    p = os.path.join(OUT, "run_" + nome, "out.txt")
    txt = open(p, encoding="utf-8", errors="replace").read() if os.path.exists(p) else ""
    # aggiunge il riepilogo scritto sul Desktop, se c'e'
    for f in glob.glob(os.path.join(OUT, "run_" + nome, "user", "Desktop", "ROUND_R92b_*", "RIEPILOGO_ROUND_R92b.txt")):
        txt += "\n" + open(f, encoding="ascii", errors="replace").read()
    mancano = [x for x in deve if x not in txt]
    troppo = [x for x in non if x in txt]
    ok = (not mancano) and (not troppo)
    fails += 0 if ok else 1
    print(("PASS " if ok else "FAIL ") + nome + ("" if ok else "   mancano=%r  non-dovevano-esserci=%r" % (mancano, troppo)))
print("ESITO: %d scenari, %d FAIL" % (len(T), fails))
sys.exit(1 if fails else 0)
