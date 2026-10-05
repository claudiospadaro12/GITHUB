#!/usr/bin/env python3
# -*- coding: ascii -*-
"""
giornali_veri.py -- il lettore di GAMBE della riga R280 (DUE job) contro GIORNALI VERI del tester (scritti da MT5, non da noi).
Estrae dalla riga il blocco che costruisce le gambe e le attribuisce ai job (da '$legs=New-Object' a '$nLegOrf=...;') e lo fa girare su:
  - risultati_archivio/ROUND_CORTI_B_2026-09-27/LOG_TESTER/0002_Tester_logs_20260927.log : LO STESSO EA (ABTG_Nasdaq_Apertura_US), LO STESSO simbolo (U30USD, M5),
    LE STESSE finestre di R280 (IS 2024.09.26-2025.06.30, OOS 2025.07.01-2026.06.30, @FRAZIONEIS 0.4322) e lo stesso PC. Contati con python (intestazioni '" X64',
    una per tentativo): 36 intestazioni in tutto, 14 di ABTG_MaxMinNotte (09:11:06-09:20:07) e 22 di ABTG_Nasdaq_Apertura_US dalle 09:20:29: R263g (2 gambe), R262a
    (09:23:11 e 09:24:57), R262b (09:27:12 e 09:29:01), R262c, R262d, R263a-d, R263e, R263f; nessuna 'cannot be initialized'. Job e = R262a (2 gambe partite), job a = R262b.
  - risultati_archivio/ROUND_DAXAP02_20261001_2244/LOG_TESTER/0002_Tester_logs_20261001.log : 14 intestazioni (12 di R92BAB dalle 22:02:08 alle 22:12:12, 2 di DAXAP02), 2
    'cannot be initialized' (22:03:43 e 22:09:46): una gamba MORTA nel job e, finestre e simbolo diversi da R280 (0 corrispondenze di finestra, atteso).
Uso: python3 giornali_veri.py [RIGA.txt]    (esce 0 se tutto come atteso)
"""
import os, shutil, subprocess, sys, tempfile
QD = os.path.dirname(os.path.abspath(__file__))
REPO = os.path.abspath(os.path.join(QD, "..", ".."))
riga = open(sys.argv[1] if len(sys.argv) > 1 else os.path.join(REPO, "backtest_pipeline", "righe", "RIGA_ROUND_R280.txt"), encoding="ascii").read()
i = riga.index("$legs=New-Object System.Collections.ArrayList"); j = riga.index("$nLegOrf="); j = riga.index(";", j) + 1
blk = riga[i:j]
AR = os.path.join(REPO, "backtest_pipeline", "risultati_archivio")
R262 = os.path.join(AR, "ROUND_CORTI_B_2026-09-27", "LOG_TESTER", "0002_Tester_logs_20260927.log")
DX2 = os.path.join(AR, "ROUND_DAXAP02_20261001_2244", "LOG_TESTER", "0002_Tester_logs_20261001.log")
NS = "ABTG_Nasdaq_Apertura_US"
# nome, file, nome nella raccolta, T0, job e (inizio, durata) o None, job a (inizio, durata) o None, atteso "legs prima orfane",
# (gambe e, morte e, partite e con finestra IS, con finestra OOS), (lo stesso per a), EA atteso fra le gambe attribuite
CASI = [
 ("R262 27/09 (stesso EA, simbolo, finestre): job e = R262a, job a = R262b", R262, "0002_Tester_logs_20260927.log", "2026-09-27 09:23:00",
  ("2026-09-27 09:22:50", 250.0), ("2026-09-27 09:26:55", 245.0), "legs 20 prima 16 orfane 16", (2, 0, 1, 1), (2, 0, 1, 1), NS),
 ("R262 27/09: job a NON lanciato (tetto): le sue gambe restano ORFANE", R262, "0002_Tester_logs_20260927.log", "2026-09-27 09:23:00",
  ("2026-09-27 09:22:50", 250.0), None, "legs 20 prima 16 orfane 18", (2, 0, 1, 1), (0, 0, 0, 0), NS),
 ("R262 27/09 con T0 alle 09:20:00: le 14 gambe MaxMin sono PRIMA, le due di R263g non sono di nessun job", R262, "0002_Tester_logs_20260927.log", "2026-09-27 09:20:20",
  ("2026-09-27 09:22:50", 250.0), ("2026-09-27 09:26:55", 245.0), "legs 22 prima 14 orfane 18", (2, 0, 1, 1), (2, 0, 1, 1), NS),
 ("01/10 R92BAB+DAXAP02: job e = P (una gamba MORTA), job a = DAXAP02: finestre di R280 NON corrispondono", DX2, "0002_Tester_logs_20261001.log", "2026-10-01 22:01:00",
  ("2026-10-01 22:02:00", 150.0), ("2026-10-01 22:44:21", 151.0), "legs 14 prima 0 orfane 10", (2, 1, 0, 0), (2, 0, 0, 0), None),
]
ok = 0
for (nome, src, dn, T0, ja, jb_, atteso, ea_, eb_, eaexp) in CASI:
    d = tempfile.mkdtemp(); os.makedirs(d + "/lg")
    shutil.copy(src, d + "/lg/" + dn)
    pre = "$lg='%s/lg'; $T0=[datetime]'%s'; $jobs=@(@{t='R280e'}, @{t='R280a'}); $tIni=@{}; $tDur=@{};\n" % (d, T0)
    if ja:
        pre += "$tIni['R280e']=[datetime]'%s'; $tDur['R280e']=%s;\n" % ja
    if jb_:
        pre += "$tIni['R280a']=[datetime]'%s'; $tDur['R280a']=%s;\n" % jb_
    post = "\n'legs '+$legs.Count+' prima '+$legPrima+' orfane '+$nLegOrf;\n"
    for L in ("R280e", "R280a"):
        post += ("$q=@($legs | Where-Object { $_.job -eq '%s' }); '%s '+$q.Count+' '+@($q | Where-Object { $_.ko }).Count+' '+@($q | Where-Object { $_.fr -eq '2024.09.26' -and $_.ta -eq '2025.06.30' -and $_.sym -eq 'U30USD' }).Count+' '+@($q | Where-Object { $_.fr -eq '2025.07.01' -and $_.ta -eq '2026.06.30' -and $_.sym -eq 'U30USD' }).Count+' '+((@($q | ForEach-Object { $_.ea }) | Sort-Object -Unique) -join ',');\n" % (L, L))
    open(d + "/t.ps1", "w").write(pre + blk + post)
    out = subprocess.run(["pwsh", "-NoProfile", "-File", d + "/t.ps1"], capture_output=True, text=True).stdout.strip().split("\n")
    pa = out[1].split(); pb = out[2].split()
    va = tuple(int(x) for x in pa[1:5]); vb = tuple(int(x) for x in pb[1:5])
    esito = out[0] == atteso and va == ea_ and vb == eb_
    if eaexp:
        esito = esito and (pa[5] if len(pa) > 5 else "") == eaexp
    ok += 1 if esito else 0
    print(("PASS  " if esito else "FALLITO ") + nome + "  ->  " + " | ".join(out))
print("GIORNALI VERI: %d/%d" % (ok, len(CASI)))
sys.exit(0 if ok == len(CASI) else 1)
