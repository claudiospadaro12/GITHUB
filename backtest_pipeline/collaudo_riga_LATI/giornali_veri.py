#!/usr/bin/env python3
# -*- coding: ascii -*-
"""
giornali_veri.py -- il lettore di GAMBE della riga LATI (QUATTRO job, UNA gamba vera e UNA gamba OOS DEGENERE per job) contro GIORNALI VERI del tester (scritti da MT5, non da noi).
Estrae dalla riga il blocco che costruisce le gambe e le attribuisce ai job (da '$legs=New-Object' a '$nLegOrf=...;') e lo fa girare su:
  - risultati_archivio/ROUND_CORTI_B_2026-09-27/LOG_TESTER/0002_Tester_logs_20260927.log : DUE gambe OOS DEGENERI VERE, scritte da MT5 su questo stesso PC il 27/09 con @FRAZIONEIS 1.0
    (il caso che la riga LATI aspetta). Contate con un conto indipendente dal parser della riga (regex Python sulle righe del file): 36 intestazioni '" X64' in tutto, la prima alle 09:11:06,
    quindi ZERO prima di T0 = 09:10:43 (RIEPILOGO_ROUND_CORTI_B.txt). Job R263e (referto 09:51:21): intestazione 09:51:37.388 con 'from 2024.09.26 00:00 to 2025.06.30 00:00' su U30USD
    (gamba IS vera), poi intestazione 09:52:19.462 SENZA from/to e con 'set mode to math calculations or adjust testing dates' alle 09:52:19.703 (gamba OOS degenere); il job
    successivo comincia alle 09:52:41.447. Job R261c (referto 09:15:10): intestazione 09:15:26.412 con 'from 2024.09.26 00:00 to 2026.06.30 00:00' su D30EUR, poi intestazione 09:16:05.496
    senza from/to e con 'set mode' alle 09:16:05.718; il job successivo comincia alle 09:16:31.
  - risultati_archivio/R246/LOG_TESTER/0002_Tester_logs_20260924.log e ROUND_DAXAP02_20261001_2244/LOG_TESTER/0002_Tester_logs_20261001.log: i casi di collaudo_riga_EMAGEM2/giornali_veri.py, qui
    per mostrare che una gamba vera NON e' mai scambiata per degenere (deg 0) e che una gamba morta NON e' degenere (la riga che conta le morte e le degeneri non le confonde).
Uso: python3 giornali_veri.py [RIGA.txt]    (esce 0 se tutto come atteso)
"""
import os, shutil, subprocess, sys, tempfile
QD = os.path.dirname(os.path.abspath(__file__))
REPO = os.path.abspath(os.path.join(QD, "..", ".."))
riga = open(sys.argv[1] if len(sys.argv) > 1 else os.path.join(REPO, "backtest_pipeline", "righe", "RIGA_ROUND_LATI.txt"), encoding="ascii").read()
i = riga.index("$legs=New-Object System.Collections.ArrayList"); j = riga.index("$nLegOrf="); j = riga.index(";", j) + 1
blk = riga[i:j]
AR = os.path.join(REPO, "backtest_pipeline", "risultati_archivio")
CB = os.path.join(AR, "ROUND_CORTI_B_2026-09-27", "LOG_TESTER", "0002_Tester_logs_20260927.log")
R246 = os.path.join(AR, "R246", "LOG_TESTER", "0002_Tester_logs_20260924.log")
DX2 = os.path.join(AR, "ROUND_DAXAP02_20261001_2244", "LOG_TESTER", "0002_Tester_logs_20261001.log")
MM = "ABTG_MaxMinNotte_DAX_Short_Ottimizzato"
# nome, file, nome nella raccolta, T0, job a (inizio, durata) o None, job b (inizio, durata) o None, atteso "legs prima orfane",
# (gambe, morte, gambe con finestra data, degeneri) di a, lo stesso di b, (da, a, simbolo) della finestra contata per a e per b, EA attesi fra le gambe di a e di b (None = non controllato)
CASI = [
 ("27/09 R263e + R261c (UNA tranche: gamba OOS DEGENERE vera): job a = R263e, job b = R261c", CB, "0002_Tester_logs_20260927.log", "2026-09-27 09:10:43",
  ("2026-09-27 09:51:21", 65.0), ("2026-09-27 09:15:10", 70.0), "legs 36 prima 0 orfane 32", (2, 0, 1, 1), (2, 0, 1, 1),
  ("2024.09.26", "2025.06.30", "U30USD"), ("2024.09.26", "2026.06.30", "D30EUR"), "ABTG_Nasdaq_Apertura_US", "ABTG_MaxMinNotte"),
 ("27/09: solo R263e (job b NON lanciato): le gambe di R261c restano ORFANE", CB, "0002_Tester_logs_20260927.log", "2026-09-27 09:10:43",
  ("2026-09-27 09:51:21", 65.0), None, "legs 36 prima 0 orfane 34", (2, 0, 1, 1), (0, 0, 0, 0), ("2024.09.26", "2025.06.30", "U30USD"), ("2024.09.26", "2026.06.30", "D30EUR"), "ABTG_Nasdaq_Apertura_US", None),
 ("27/09 con T0 = 09:51:21 (avvio vero di R263e): le gambe prima sono PRIMA, e la degenere conta come gamba del job", CB, "0002_Tester_logs_20260927.log", "2026-09-27 09:51:21",
  ("2026-09-27 09:51:21", 65.0), None, "legs 4 prima 32 orfane 2", (2, 0, 1, 1), (0, 0, 0, 0), ("2024.09.26", "2025.06.30", "U30USD"), ("2024.09.26", "2025.06.30", "U30USD"), "ABTG_Nasdaq_Apertura_US", None),
 ("R246 24/09 (DUE gambe vere, nessuna degenere): job a = R246i, job b = R246j", R246, "0002_Tester_logs_20260924.log", "2026-09-24 22:51:48",
  ("2026-09-24 22:54:16", 65.0), ("2026-09-24 23:01:30", 60.0), "legs 24 prima 32 orfane 20", (2, 0, 1, 0), (2, 0, 1, 0), ("2024.09.26", "2025.06.09", "D30EUR"), ("2024.09.26", "2025.06.09", "D30EUR"), MM, MM),
 ("01/10 R92BAB+DAXAP02: job a = P (UNA gamba MORTA, nessuna degenere), job b = DAXAP02", DX2, "0002_Tester_logs_20261001.log", "2026-10-01 22:01:00",
  ("2026-10-01 22:02:00", 150.0), ("2026-10-01 22:44:21", 151.0), "legs 14 prima 0 orfane 10", (2, 1, 0, 0), (2, 0, 1, 0), ("2024.09.26", "2025.06.09", "D30EUR"), ("2024.09.26", "2025.06.09", "D30EUR"), None, "ABTG_DAX_Apertura_EU"),
]
ok = 0
for (nome, src, dn, T0, ja, jb_, atteso, ea_, eb_, wa, wb, eaa, eab) in CASI:
    d = tempfile.mkdtemp(); os.makedirs(d + "/lg")
    shutil.copy(src, d + "/lg/" + dn)
    pre = "$lg='%s/lg'; $T0=[datetime]'%s'; $jobs=@(@{t='LATIA2L'}, @{t='LATIA2S'}); $tIni=@{}; $tDur=@{};\n" % (d, T0)
    if ja:
        pre += "$tIni['LATIA2L']=[datetime]'%s'; $tDur['LATIA2L']=%s;\n" % ja
    if jb_:
        pre += "$tIni['LATIA2S']=[datetime]'%s'; $tDur['LATIA2S']=%s;\n" % jb_
    post = "\n'legs '+$legs.Count+' prima '+$legPrima+' orfane '+$nLegOrf;\n"
    for L, w in (("LATIA2L", wa), ("LATIA2S", wb)):
        post += ("$q=@($legs | Where-Object { $_.job -eq '%s' }); '%s '+$q.Count+' '+@($q | Where-Object { $_.ko }).Count+' '+@($q | Where-Object { $_.fr -eq '%s' -and $_.ta -eq '%s' -and $_.sym -eq '%s' }).Count+' '+@($q | Where-Object { $_.deg }).Count+' '+((@($q | ForEach-Object { $_.ea }) | Sort-Object -Unique) -join ',');\n" % (L, L, w[0], w[1], w[2]))
    open(d + "/t.ps1", "w").write(pre + blk + post)
    out = subprocess.run(["pwsh", "-NoProfile", "-File", d + "/t.ps1"], capture_output=True, text=True).stdout.strip().split("\n")
    pa = out[1].split(); pb = out[2].split()
    va = tuple(int(x) for x in pa[1:5]); vb = tuple(int(x) for x in pb[1:5])
    esito = out[0] == atteso and va == ea_ and vb == eb_
    if eaa:
        esito = esito and (pa[5] if len(pa) > 5 else "") == eaa
    if eab:
        esito = esito and (pb[5] if len(pb) > 5 else "") == eab
    ok += 1 if esito else 0
    print(("PASS  " if esito else "FALLITO ") + nome + "  ->  " + " | ".join(out))
print("GIORNALI VERI: %d/%d" % (ok, len(CASI)))
sys.exit(0 if ok == len(CASI) else 1)
