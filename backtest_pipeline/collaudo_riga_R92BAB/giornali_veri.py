#!/usr/bin/env python3
# -*- coding: ascii -*-
"""
giornali_veri.py -- il lettore di GAMBE della riga R92BAB contro i GIORNALI VERI del tester del 30/09/2026 (scritti da MT5, non da noi):
  - risultati_archivio/ROUND_R92B_2026-09-30/LOG_TESTER/0006_Tester_logs_20260930.log : le prime due gambe di R92b, MORTE (6 righe 'works too long' ciascuna);
  - risultati_archivio/ROUND_RFWD_2026-09-30/LOG_TESTER/0002_Tester_logs_20260930.log : tutto il giorno: 4 gambe MORTE (08:50-09:02) poi 14 PARTITE (RFWD 21:02-21:07).
Estrae dalla riga il blocco che costruisce le gambe (da '$legs=New-Object' a '$nLegOrf=...;') e lo fa girare su quei file con T0 scelto.
Attesi (numeri scritti da chi ha LETTO i giornali, non dal codice): R92B: 2 gambe, tutte KO, 6 righe ciascuna; RFWD con T0 21:00: 14 gambe, nessuna KO, 4 gambe PRIMA dell'avvio.
Uso: python3 giornali_veri.py RIGA.txt    (esce 0 se tutto come atteso)
"""
import os, re, shutil, subprocess, sys, tempfile
QD = os.path.dirname(os.path.abspath(__file__))
REPO = os.path.abspath(os.path.join(QD, "..", ".."))
riga = open(sys.argv[1] if len(sys.argv) > 1 else os.path.join(REPO, "backtest_pipeline", "righe", "RIGA_ROUND_R92BAB.txt"), encoding="ascii").read()
i = riga.index("$legs=New-Object System.Collections.ArrayList"); j = riga.index("$nLegOrf="); j = riga.index(";", j) + 1
blk = riga[i:j]
AR = os.path.join(REPO, "backtest_pipeline", "risultati_archivio")
CASI = [("R92B 30/09 (prime 2 gambe)", os.path.join(AR, "ROUND_R92B_2026-09-30", "LOG_TESTER", "0006_Tester_logs_20260930.log"), "2026-09-30 08:00:00", "legs 2 prima 0 orfane 0", 2, 2, 6),
        ("RFWD 30/09 con T0 21:00", os.path.join(AR, "ROUND_RFWD_2026-09-30", "LOG_TESTER", "0002_Tester_logs_20260930.log"), "2026-09-30 21:00:00", "legs 14 prima 4 orfane 0", 14, 0, 0),
        ("RFWD 30/09 con T0 08:00 (tutto il giorno)", os.path.join(AR, "ROUND_RFWD_2026-09-30", "LOG_TESTER", "0002_Tester_logs_20260930.log"), "2026-09-30 08:00:00", "legs 18 prima 0 orfane 0", 18, 4, 6)]
ok = 0
for nome, src, T0, atteso, nlegs, nko, nw in CASI:
    d = tempfile.mkdtemp(); os.makedirs(d + "/lg")
    shutil.copy(src, d + "/lg/0006_Tester_logs_20260930.log")
    ps = ("$lg='%s/lg'; $T0=[datetime]'%s'; $jobs=@(@{t='J'}); $tIni=@{J=[datetime]'2026-09-30 00:00:00'}; $tDur=@{J=86000.0};\n" % (d, T0)) + blk + \
         "\n'legs '+$legs.Count+' prima '+$legPrima+' orfane '+$nLegOrf; 'KO '+@($legs | Where-Object { $_.ko }).Count; 'PARTITE '+@($legs | Where-Object { $_.fr -ne '' }).Count; 'NW '+(@($legs | ForEach-Object { $_.nW }) -join ',')\n"
    open(d + "/t.ps1", "w").write(ps)
    out = subprocess.run(["pwsh", "-NoProfile", "-File", d + "/t.ps1"], capture_output=True, text=True).stdout.strip().split("\n")
    koN = int(out[1].split()[1]); parN = int(out[2].split()[1]); nwv = [x for x in out[3].split()[1].split(",") if x != ""]
    esito = out[0] == atteso and koN == nko and parN == nlegs - nko and (nw == 0 or all(x == str(nw) for x in nwv if x != "0") and sum(1 for x in nwv if x == str(nw)) == nko)
    ok += 1 if esito else 0
    print(("PASS  " if esito else "FALLITO ") + nome + "  ->  " + " | ".join(out[:3]) + "  | righe 'works too long' per gamba: " + ",".join(nwv))
print("GIORNALI VERI: %d/%d" % (ok, len(CASI)))
sys.exit(0 if ok == len(CASI) else 1)
