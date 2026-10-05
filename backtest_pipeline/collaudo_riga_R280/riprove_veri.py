#!/usr/bin/env python3
# -*- coding: ascii -*-
"""
riprove_veri.py -- il lettore del file RIPROVE della riga R280 contro file RIPROVE scritti dal DRIVER VERO (walkforward_generico_RETRY.ps1 @ d949f705,
la sua funzione TestoTentativo e il suo ciclo dei tentativi), non dallo stub di questa riga (classe 1020: il materiale di prova non esce dal generatore
che conosce la risposta). Le fixture in riprove_veri/ sono state prodotte facendo girare collaudo_driver_RETRY/battery.py (driver vero, terminale finto)
il 01/10/2026 e copiate tali e quali (solo il percorso del banco sostituito con <banco_collaudo_driver_RETRY>).
Le attese sono scritte A MANO leggendo le righe GAMBA dei file, NON ricavate con la stessa regex della riga.
Estrae dalla riga (1) il blocco che legge il RIPROVE ('$rp=@{fr=$false;' ... fino a '$J.rc=$rc;') e (2) il blocco che ne conta tentativi ed esiti e ne
controlla la coerenza ('$gI=$rp.g[' ... fino a '$nMd=0;'), e li fa girare su ogni file.
Uso: python3 riprove_veri.py [RIGA.txt]    (esce 0 se tutto come atteso)
"""
import os, subprocess, sys, tempfile
QD = os.path.dirname(os.path.abspath(__file__))
REPO = os.path.abspath(os.path.join(QD, "..", ".."))
riga = open(sys.argv[1] if len(sys.argv) > 1 else os.path.join(REPO, "backtest_pipeline", "righe", "RIGA_ROUND_R280.txt"), encoding="ascii").read()
i = riga.index("$rp=@{fr=$false;"); j = riga.index("$J.rc=$rc;")
b1 = riga[i:j]
i = riga.index("$gI=$rp.g['IS'];"); j = riga.index("$nMd=0;")
b2 = riga[i:j]
FX = os.path.join(QD, "riprove_veri")
# file: (tentativi IS, RIPROVATA IS, CSV PRODOTTO IS), (lo stesso OOS), coerente, tentativi totali, PARTITA, MORTA_INIT, altri esiti
CASI = {
 "D1":          (("MORTA_INIT PARTITA", True, True), ("PARTITA", False, True), True, 3, 2, 1, 0),
 "D2":          (("MORTA_INIT MORTA_INIT", True, False), ("PARTITA", False, True), True, 3, 1, 2, 0),
 "D3_altro":    (("MORTA_ALTRO", False, False), ("PARTITA", False, True), True, 2, 1, 0, 1),
 "D3_dead_csv": (("MORTA_INIT", False, True), ("PARTITA", False, True), False, 2, 1, 1, 0),
 "D3_nodata":   (("NON_VERIFICABILE", False, False), ("PARTITA", False, True), True, 2, 1, 0, 1),
 "D3_other_ea": (("ANOMALA", False, False), ("PARTITA", False, True), True, 2, 1, 0, 1),
 "D4":          (("MORTA_INIT PARTITA", True, True), ("MORTA_INIT PARTITA", True, True), True, 4, 2, 2, 0),
 "D6":          (("MORTA_INIT", False, False), ("PARTITA", False, True), True, 2, 1, 1, 0),
 "D8a":         (("MORTA_INIT", False, False), ("PARTITA", False, True), True, 2, 1, 1, 0),
 "D10":         (("PARTITA", False, True), ("PARTITA", False, True), True, 2, 2, 0, 0),
 "R2":          (("PARTITA", False, True), ("PARTITA", False, True), True, 2, 2, 0, 0),
}
def fmt(g):
    return "%s|%s|%s" % (g[0], g[1], g[2])
ok = 0
for nome, (gis, goos, coh, tA, tP, tK, tX) in sorted(CASI.items()):
    f = os.path.join(FX, "RIPROVE_%s.txt" % nome)
    ps = ("$rpF='%s'; $tJ=[datetime]::MinValue;\n" % f) + b1 + "\n" + b2 + "\n" + \
         "foreach($k in @('IS','OOS')){ $g=$rp.g[$k]; ($k + ' ' + ($g.es -join ' ') + '|' + $g.rip + '|' + $g.prod) }; 'COH ' + $rpCoh + ' ' + $tA + ' ' + $tP + ' ' + $tK + ' ' + $tX + ' nG ' + $rp.nG + ' fr ' + $rp.fr\n"
    d = tempfile.mkdtemp(); open(d + "/t.ps1", "w").write(ps)
    out = subprocess.run(["pwsh", "-NoProfile", "-File", d + "/t.ps1"], capture_output=True, text=True).stdout.strip().split("\n")
    att = ["IS " + fmt(gis), "OOS " + fmt(goos), "COH %s %d %d %d %d nG 2 fr True" % (coh, tA, tP, tK, tX)]
    esito = out == att
    ok += 1 if esito else 0
    print(("PASS  " if esito else "FALLITO ") + nome + "  ->  " + " ; ".join(out) + ("" if esito else "   ATTESO: " + " ; ".join(att)))
print("RIPROVE VERI: %d/%d" % (ok, len(CASI)))
sys.exit(0 if ok == len(CASI) else 1)
