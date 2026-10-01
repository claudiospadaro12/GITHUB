#!/usr/bin/env python3
# -*- coding: ascii -*-
"""
giornali_veri.py -- il lettore di GAMBE della riga DAXAP02 contro GIORNALI VERI del tester (scritti da MT5, non da noi):
  - risultati_archivio/ROUND_R270_USCITA_DAX_2026-09-28/LOG_TESTER/0002_Tester_logs_20260928.log : lo stesso EA, la stessa finestra, lo stesso PC.
    Avvio della riga R270 alle 22:27:26 (RIEPILOGO). Contati con grep/awk da chi ha LETTO il file: 191 righe '" X64' PRIMA delle 22:27:26
    (corse precedenti dello stesso giorno, fra cui 2 'cannot be initialized'), 8 DOPO (4 job x 2 gambe, tutte partite, finestre 2024.09.26-2025.06.09
    e 2025.06.10-2026.06.30).
  - risultati_archivio/ROUND_R92B_2026-09-30/LOG_TESTER/0006_Tester_logs_20260930.log : 2 gambe MORTE (6 righe 'works too long' ciascuna);
  - risultati_archivio/ROUND_R92BAB_20261001_2201/LOG_TESTER/0002_Tester_logs_20261001.log : 12 gambe, 2 MORTE, una delle quali sull'EA DAX a un simbolo.
Estrae dalla riga il blocco che costruisce le gambe (da '$legs=New-Object' a '$nLegOrf=...;') e lo fa girare su quei file con T0 scelto.
Uso: python3 giornali_veri.py [RIGA.txt]    (esce 0 se tutto come atteso)
"""
import os, shutil, subprocess, sys, tempfile
QD = os.path.dirname(os.path.abspath(__file__))
REPO = os.path.abspath(os.path.join(QD, "..", ".."))
riga = open(sys.argv[1] if len(sys.argv) > 1 else os.path.join(REPO, "backtest_pipeline", "righe", "RIGA_ROUND_DAXAP02.txt"), encoding="ascii").read()
i = riga.index("$legs=New-Object System.Collections.ArrayList"); j = riga.index("$nLegOrf="); j = riga.index(";", j) + 1
blk = riga[i:j]
AR = os.path.join(REPO, "backtest_pipeline", "risultati_archivio")
R270 = os.path.join(AR, "ROUND_R270_USCITA_DAX_2026-09-28", "LOG_TESTER", "0002_Tester_logs_20260928.log")
R92B = os.path.join(AR, "ROUND_R92B_2026-09-30", "LOG_TESTER", "0006_Tester_logs_20260930.log")
R92BAB = os.path.join(AR, "ROUND_R92BAB_20261001_2201", "LOG_TESTER", "0002_Tester_logs_20261001.log")
# nome, file, nome nella raccolta, T0, tJ, durata s, atteso "legs prima orfane", KO attesi, PARTITE attese, finestre attese fra le partite (IS, OOS),
# gambe attribuite al job e di queste quante morte. L'ultimo caso e' il giornale di STASERA (R92BAB, 01/10, 22:01-22:12, QUESTO PC): la gamba IS del
# controllo positivo P (EA DAX a un simbolo, 22:02:08) e' MORTA, la OOS (22:04:08) partita; letto a mano con iconv/grep.
CASI = [("R270 28/09 con T0 22:27:26 (avvio vero)", R270, "0002_Tester_logs_20260928.log", "2026-09-28 22:27:26", "2026-09-28 22:27:26", 320.0, "legs 8 prima 191 orfane 0", 0, 8, (4, 4)),
        ("R270 28/09, job finto 22:30:10-22:31:10 (le gambe fuori finestra restano ORFANE)", R270, "0002_Tester_logs_20260928.log", "2026-09-28 22:27:26", "2026-09-28 22:30:10", 60.0, "legs 8 prima 191 orfane 6", 0, 8, (4, 4)),
        ("R92B 30/09 con T0 08:00", R92B, "0006_Tester_logs_20260930.log", "2026-09-30 08:00:00", "2026-09-30 08:00:00", 86000.0, "legs 2 prima 0 orfane 0", 2, 0, (0, 0)),
        ("R92BAB 01/10, job P 22:02:00 + 150 s (una gamba DAX morta, una partita)", R92BAB, "0002_Tester_logs_20261001.log", "2026-10-01 22:01:00", "2026-10-01 22:02:00", 150.0, "legs 12 prima 0 orfane 10", 2, 10, (0, 0))]
ATTR = {0: (8, 0), 1: (2, 0), 2: (2, 2), 3: (2, 1)}
ok = 0
for ic, (nome, src, dn, T0, tJ, dur, atteso, nko, npar, (nis, noos)) in enumerate(CASI):
    d = tempfile.mkdtemp(); os.makedirs(d + "/lg")
    shutil.copy(src, d + "/lg/" + dn)
    ps = ("$lg='%s/lg'; $T0=[datetime]'%s'; $tJ=[datetime]'%s'; $tDur=%s; $LBL='DAXAP02';\n" % (d, T0, tJ, dur)) + blk + \
         "\n'legs '+$legs.Count+' prima '+$legPrima+' orfane '+$nLegOrf; 'KO '+@($legs | Where-Object { $_.ko }).Count; 'PARTITE '+@($legs | Where-Object { $_.fr -ne '' }).Count; " + \
         "'IS '+@($legs | Where-Object { $_.fr -eq '2024.09.26' -and $_.ta -eq '2025.06.09' -and $_.sym -eq 'D30EUR' }).Count; 'OOS '+@($legs | Where-Object { $_.fr -eq '2025.06.10' -and $_.ta -eq '2026.06.30' -and $_.sym -eq 'D30EUR' }).Count; " + \
         "'ATTR '+@($legs | Where-Object { $_.job -eq 'DAXAP02' }).Count+' '+@($legs | Where-Object { $_.job -eq 'DAXAP02' -and $_.ko }).Count; 'EA '+((@($legs | ForEach-Object { $_.ea }) | Sort-Object -Unique) -join ','); 'NW '+(@($legs | ForEach-Object { $_.nW }) -join ',')\n"
    open(d + "/t.ps1", "w").write(ps)
    out = subprocess.run(["pwsh", "-NoProfile", "-File", d + "/t.ps1"], capture_output=True, text=True).stdout.strip().split("\n")
    koN = int(out[1].split()[1]); parN = int(out[2].split()[1]); isN = int(out[3].split()[1]); oosN = int(out[4].split()[1])
    atN = (int(out[5].split()[1]), int(out[5].split()[2]))
    nwv = [x for x in out[7].split()[1].split(",")] if len(out[7].split()) > 1 else []
    esito = out[0] == atteso and koN == nko and parN == npar and isN == nis and oosN == noos and atN == ATTR[ic]
    if nko:
        esito = esito and sum(1 for x in nwv if x == "6") == nko
    ok += 1 if esito else 0
    print(("PASS  " if esito else "FALLITO ") + nome + "  ->  " + " | ".join(out))
print("GIORNALI VERI: %d/%d" % (ok, len(CASI)))
sys.exit(0 if ok == len(CASI) else 1)
