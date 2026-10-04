#!/usr/bin/env python3
# -*- coding: ascii -*-
"""
riprove_veri.py -- il lettore del file RIPROVE della riga LATI contro file RIPROVE scritti dal DRIVER VERO (walkforward_generico_RETRY.ps1 @ d949f705, la sua funzione TestoTentativo e
il suo ciclo dei tentativi), non dallo stub di questa riga (classe 1020: il materiale di prova non esce dal generatore che conosce la risposta).
Le fixture LATI_* in riprove_veri/ sono state prodotte da driver_vero/genera_fixture.py: la riga VERA RIGA_ROUND_VPS_RETRY.ps1 + il driver VERO su un file prova LATI vero
(@FRAZIONEIS 1.0: la gamba OOS e' DEGENERE) con un terminale finto che scrive la gamba degenere COME L'HA SCRITTA MT5 il 27/09/2026 (giornale di R263e). Le fixture D* sono quelle di
collaudo_riga_EMAGEM2/riprove_veri (driver vero, due gambe VERE): qui servono da CONTRO-ESEMPIO, perche' per la riga LATI una gamba OOS che e' PARTITA NON e' una gamba degenere.
Le attese sono scritte A MANO leggendo le righe GAMBA dei file, NON ricavate con la stessa regex della riga.
Estrae dalla riga (1) il blocco che legge il RIPROVE ('$rp=@{fr=$false;' ... fino a '$J.rc=$rc;') e (2) il blocco che ne conta tentativi ed esiti e ne controlla la coerenza ('$gI=$rp.g[' ...
fino a '$nMd=0;': IS come prima, OOS = UN tentativo NON_VERIFICABILE senza riprova), e li fa girare su ogni file.
Uso: python3 riprove_veri.py [RIGA.txt]    (esce 0 se tutto come atteso)
"""
import os, subprocess, sys, tempfile
QD = os.path.dirname(os.path.abspath(__file__))
REPO = os.path.abspath(os.path.join(QD, "..", ".."))
riga = open(sys.argv[1] if len(sys.argv) > 1 else os.path.join(REPO, "backtest_pipeline", "righe", "RIGA_ROUND_LATI.txt"), encoding="ascii").read()
i = riga.index("$rp=@{fr=$false;"); j = riga.index("$J.rc=$rc;")
b1 = riga[i:j]
i = riga.index("$gI=$rp.g['IS'];"); j = riga.index("$nMd=0;")
b2 = riga[i:j]
FX = os.path.join(QD, "riprove_veri")
FX2 = os.path.join(QD, "..", "collaudo_riga_EMAGEM2", "riprove_veri")
# file: (tentativi IS, RIPROVATA IS, CSV PRODOTTO IS), (lo stesso OOS), coerenza IS, tentativi totali, PARTITA (solo IS), MORTA_INIT (solo IS), altri esiti IS (tXi), OOS degenere come atteso
CASI = [
 (FX, "LATI_ok",          (("PARTITA", False, True), ("NON_VERIFICABILE", False, True), True, 2, 1, 0, 0, True)),
 (FX, "LATI_riprovata",   (("MORTA_INIT PARTITA", True, True), ("NON_VERIFICABILE", False, True), True, 3, 1, 1, 0, True)),
 (FX, "LATI_ko",          (("MORTA_INIT MORTA_INIT", True, False), ("NON_VERIFICABILE", False, True), True, 3, 0, 2, 0, True)),
 (FX, "LATI_ok_senzacsv", (("PARTITA", False, True), ("NON_VERIFICABILE", False, False), True, 2, 1, 0, 0, True)),
 (FX, "LATI_is_altro",    (("MORTA_ALTRO", False, False), ("NON_VERIFICABILE", False, True), True, 2, 0, 0, 1, True)),
 # contro-esempi: file del driver vero con DUE gambe VERE. Per LATI la gamba OOS partita NON e' degenere: oosDegOk deve essere FALSE.
 (FX2, "D1",          (("MORTA_INIT PARTITA", True, True), ("PARTITA", False, True), True, 3, 1, 1, 0, False)),
 (FX2, "D10",         (("PARTITA", False, True), ("PARTITA", False, True), True, 2, 1, 0, 0, False)),
 (FX2, "D3_nodata",   (("NON_VERIFICABILE", False, False), ("PARTITA", False, True), True, 2, 0, 0, 1, False)),
 (FX2, "D4",          (("MORTA_INIT PARTITA", True, True), ("MORTA_INIT PARTITA", True, True), True, 4, 1, 1, 0, False)),
 (FX2, "D6",          (("MORTA_INIT", False, False), ("PARTITA", False, True), True, 2, 0, 1, 0, False)),
]
def fmt(g):
    return "%s|%s|%s" % (g[0], g[1], g[2])
ok = 0
for fx, nome, (gis, goos, coh, tA, tP, tK, tX, deg) in CASI:
    f = os.path.join(fx, "RIPROVE_%s.txt" % nome)
    ps = ("$rpF='%s'; $tJ=[datetime]::MinValue;\n" % f) + b1 + "\n" + b2 + "\n" + \
         "foreach($k in @('IS','OOS')){ $g=$rp.g[$k]; ($k + ' ' + ($g.es -join ' ') + '|' + $g.rip + '|' + $g.prod) }; 'COH ' + $rpCoh + ' ' + $tA + ' ' + $tP + ' ' + $tK + ' ' + $tXi + ' DEG ' + $oosDegOk + ' nG ' + $rp.nG + ' fr ' + $rp.fr\n"
    d = tempfile.mkdtemp(); open(d + "/t.ps1", "w").write(ps)
    out = subprocess.run(["pwsh", "-NoProfile", "-File", d + "/t.ps1"], capture_output=True, text=True).stdout.strip().split("\n")
    att = ["IS " + fmt(gis), "OOS " + fmt(goos), "COH %s %d %d %d %d DEG %s nG 2 fr True" % (coh, tA, tP, tK, tX, deg)]
    esito = out == att
    ok += 1 if esito else 0
    print(("PASS  " if esito else "FALLITO ") + nome + "  ->  " + " ; ".join(out) + ("" if esito else "   ATTESO: " + " ; ".join(att)))
print("RIPROVE VERI: %d/%d" % (ok, len(CASI)))
sys.exit(0 if ok == len(CASI) else 1)
