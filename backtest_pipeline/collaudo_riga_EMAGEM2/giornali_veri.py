#!/usr/bin/env python3
# -*- coding: ascii -*-
"""
giornali_veri.py -- il lettore di GAMBE della riga EMAGEM2 (DUE job) contro GIORNALI VERI del tester (scritti da MT5, non da noi).
Estrae dalla riga il blocco che costruisce le gambe e le attribuisce ai job (da '$legs=New-Object' a '$nLegOrf=...;') e lo fa girare su:
  - risultati_archivio/R246/LOG_TESTER/0002_Tester_logs_20260924.log : LO STESSO EA (ABTG_MaxMinNotte_DAX_Short_Ottimizzato), la stessa finestra,
    lo stesso PC. Avvio della riga R246 alle 22:51:48 (RIEPILOGO_R246.txt). Contati con grep/awk: 56 intestazioni '" X64', 32 PRIMA delle 22:51:48,
    24 DOPO (12 job x 2 gambe), nessuna 'cannot be initialized'. Job a = R246i (referto 22:54:16; gambe 22:54:28 e 22:54:55), job b = R246j
    (referto 23:01:30; gambe 23:01:43 e 23:02:08): 2 gambe MaxMin partite ciascuno, finestre 2024.09.26-2025.06.09 e 2025.06.10-2026.06.30.
  - risultati_archivio/ROUND_DAXAP02_20261001_2244/LOG_TESTER/0002_Tester_logs_20261001.log : 14 intestazioni (12 di R92BAB dalle 22:02:08 alle
    22:12:12, 2 di DAXAP02 alle 22:44:54 e 22:45:40), 2 'cannot be initialized' (22:03:43 e 22:09:46). Job a = 22:02:00 + 150 s (la gamba IS del
    controllo positivo P MORTA e la OOS partita), job b = DAXAP02 22:44:21 + 151 s (2 partite): due job lontani nello stesso file.
Uso: python3 giornali_veri.py [RIGA.txt]    (esce 0 se tutto come atteso)
"""
import os, shutil, subprocess, sys, tempfile
QD = os.path.dirname(os.path.abspath(__file__))
REPO = os.path.abspath(os.path.join(QD, "..", ".."))
riga = open(sys.argv[1] if len(sys.argv) > 1 else os.path.join(REPO, "backtest_pipeline", "righe", "RIGA_ROUND_EMAGEM2.txt"), encoding="ascii").read()
i = riga.index("$legs=New-Object System.Collections.ArrayList"); j = riga.index("$nLegOrf="); j = riga.index(";", j) + 1
blk = riga[i:j]
AR = os.path.join(REPO, "backtest_pipeline", "risultati_archivio")
R246 = os.path.join(AR, "R246", "LOG_TESTER", "0002_Tester_logs_20260924.log")
DX2 = os.path.join(AR, "ROUND_DAXAP02_20261001_2244", "LOG_TESTER", "0002_Tester_logs_20261001.log")
MM = "ABTG_MaxMinNotte_DAX_Short_Ottimizzato"
# nome, file, nome nella raccolta, T0, job a (inizio, durata) o None, job b (inizio, durata) o None, atteso "legs prima orfane",
# (gambe a, morte a, partite a con finestra IS, con finestra OOS), (lo stesso per b), EA attesi fra le gambe attribuite
CASI = [
 ("R246 24/09 (stesso EA): job a = R246i, job b = R246j", R246, "0002_Tester_logs_20260924.log", "2026-09-24 22:51:48",
  ("2026-09-24 22:54:16", 65.0), ("2026-09-24 23:01:30", 60.0), "legs 24 prima 32 orfane 20", (2, 0, 1, 1), (2, 0, 1, 1), MM),
 ("R246 24/09: job b NON lanciato (tetto): le sue gambe restano ORFANE", R246, "0002_Tester_logs_20260924.log", "2026-09-24 22:51:48",
  ("2026-09-24 22:54:16", 65.0), None, "legs 24 prima 32 orfane 22", (2, 0, 1, 1), (0, 0, 0, 0), MM),
 ("01/10 R92BAB+DAXAP02: job a = P (una gamba MORTA), job b = DAXAP02", DX2, "0002_Tester_logs_20261001.log", "2026-10-01 22:01:00",
  ("2026-10-01 22:02:00", 150.0), ("2026-10-01 22:44:21", 151.0), "legs 14 prima 0 orfane 10", (2, 1, 0, 0), (2, 0, 1, 1), None),
 ("01/10 con T0 22:44:21 (avvio vero di DAXAP02): le 12 gambe di R92BAB sono PRIMA", DX2, "0002_Tester_logs_20261001.log", "2026-10-01 22:44:21",
  ("2026-10-01 22:44:21", 151.0), None, "legs 2 prima 12 orfane 0", (2, 0, 1, 1), (0, 0, 0, 0), "ABTG_DAX_Apertura_EU"),
]
ok = 0
for (nome, src, dn, T0, ja, jb_, atteso, ea_, eb_, eaexp) in CASI:
    d = tempfile.mkdtemp(); os.makedirs(d + "/lg")
    shutil.copy(src, d + "/lg/" + dn)
    pre = "$lg='%s/lg'; $T0=[datetime]'%s'; $jobs=@(@{t='EMAGEM2a'}, @{t='EMAGEM2b'}); $tIni=@{}; $tDur=@{};\n" % (d, T0)
    if ja:
        pre += "$tIni['EMAGEM2a']=[datetime]'%s'; $tDur['EMAGEM2a']=%s;\n" % ja
    if jb_:
        pre += "$tIni['EMAGEM2b']=[datetime]'%s'; $tDur['EMAGEM2b']=%s;\n" % jb_
    post = "\n'legs '+$legs.Count+' prima '+$legPrima+' orfane '+$nLegOrf;\n"
    for L in ("EMAGEM2a", "EMAGEM2b"):
        post += ("$q=@($legs | Where-Object { $_.job -eq '%s' }); '%s '+$q.Count+' '+@($q | Where-Object { $_.ko }).Count+' '+@($q | Where-Object { $_.fr -eq '2024.09.26' -and $_.ta -eq '2025.06.09' -and $_.sym -eq 'D30EUR' }).Count+' '+@($q | Where-Object { $_.fr -eq '2025.06.10' -and $_.ta -eq '2026.06.30' -and $_.sym -eq 'D30EUR' }).Count+' '+((@($q | ForEach-Object { $_.ea }) | Sort-Object -Unique) -join ',');\n" % (L, L))
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
