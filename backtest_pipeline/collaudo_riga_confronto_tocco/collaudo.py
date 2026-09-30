#!/usr/bin/env python3
# -*- coding: ascii -*-
"""
collaudo.py -- FA GIRARE la riga RIGA_CONFRONTO_TOCCO_CHIUSURA_M5.txt sotto pwsh (Linux) con un ambiente FINTO
(classe 926: una riga si esegue, non si legge). Finti: USERPROFILE (cartella temporanea), COMPUTERNAME, irm (copia i
file dal repo invece di scaricarli), python.exe (script che chiama python3 e, per gli scenari di guasto, mente).
Scenari: sano; macchina sbagliata; marcatore mancante; SHA256 diverso; CSV assente; CSV nel formato sbagliato;
autotest del confronto che fallisce; autotest dell anatomia che fallisce; misura che esce 2 (file mancanti).
Per ogni scenario si controlla l ESITO ATTESO e il MOTIVO stampato. Uso: python3 collaudo.py
"""
import os, shutil, subprocess, sys, tempfile
from datetime import date, timedelta
QD = os.path.dirname(os.path.abspath(__file__))
REPO = os.path.abspath(os.path.join(QD, "..", ".."))
BP = os.path.join(REPO, "backtest_pipeline")
sys.path.insert(0, BP)
import confronto_tocco_chiusura_m5 as C
import random
RIGA = open(os.path.join(BP, "righe", "RIGA_CONFRONTO_TOCCO_CHIUSURA_M5.txt"), encoding="ascii").read().strip()
PWSH = shutil.which("pwsh")
assert PWSH, "pwsh assente"

def csv_sano(percorso):
    rng = random.Random(3)
    gg = []
    d = date(2015, 1, 5)
    while len(gg) < 40:
        if d.weekday() < 5:
            gg.append((d, C._gen_barre_casuali(rng, 78, 3.0)))
        d += timedelta(days=1)
    d = date(2022, 1, 3)
    n = 0
    while n < 40:
        if d.weekday() < 5:
            gg.append((d, C._gen_barre_casuali(rng, 78, 3.0)))
            n += 1
        d += timedelta(days=1)
    C._scrivi_csv_m1(percorso, gg)

def scenario(nome, comp="DESKTOP-H4D7CAJ", strip_marker=None, append_to=None, csv="ok", fake="", atteso_rc=0, atteso_txt=(), non_txt=()):
    tmp = tempfile.mkdtemp(prefix="collaudo_riga_")
    home = os.path.join(tmp, "home"); served = os.path.join(tmp, "served"); binx = os.path.join(tmp, "bin")
    for d in (home, served, binx):
        os.makedirs(d)
    for f in ("anatomia_aperture.py", "anatomia_movimenti_m5.py", "confronto_tocco_chiusura_m5.py"):
        shutil.copy(os.path.join(BP, f), os.path.join(served, f))
    if strip_marker:
        p = os.path.join(served, strip_marker)
        t = open(p).read().replace("MARCATORE_", "MARCATOR_")
        open(p, "w").write(t)
    if append_to:
        open(os.path.join(served, append_to), "a").write("\n# riga in piu\n")
    if csv == "ok":
        os.makedirs(os.path.join(home, "abtg_storico_indici"))
        csv_sano(os.path.join(home, "abtg_storico_indici", "NASUSD_M1.csv"))
    elif csv == "storto":
        os.makedirs(os.path.join(home, "abtg_storico_indici"))
        open(os.path.join(home, "abtg_storico_indici", "NASUSD_M1.csv"), "w").write("20150105 093000;1;2;3;4;0\n")
    py = os.path.join(binx, "python.exe")
    open(py, "w").write('#!/bin/bash\n'
        'if [ "$FAKE" = "autotest_confronto" ] && [[ "$*" == *confronto_tocco_chiusura_m5.py*--autotest* ]]; then echo "AUTOTEST: 3/5"; exit 1; fi\n'
        'if [ "$FAKE" = "autotest_anatomia" ] && [[ "$*" == *anatomia_movimenti_m5.py*--autotest* ]]; then echo "AUTOTEST: 3/5"; exit 1; fi\n'
        'if [ "$FAKE" = "rc2" ] && [[ "$*" == *confronto_tocco_chiusura_m5.py*--file* ]]; then echo "!!! finto"; exit 2; fi\n'
        'exec python3 "$@"\n')
    os.chmod(py, 0o755)
    wrap = os.path.join(tmp, "wrap.ps1")
    open(wrap, "w").write(
        "$env:USERPROFILE='%s'; $env:COMPUTERNAME='%s'; $env:FAKE='%s'; $env:PATH='%s' + ':' + $env:PATH;\n"
        "Remove-Item Alias:irm -Force;\n"
        "function irm { param([Parameter(Position=0)][string]$Uri, [string]$OutFile) $n=(($Uri -split '/backtest_pipeline/')[1] -split '\\?')[0]; Copy-Item -LiteralPath (Join-Path '%s' $n) -Destination $OutFile -Force }\n"
        "%s\n" % (home, comp, fake, binx, served, RIGA))
    r = subprocess.run([PWSH, "-NoProfile", "-File", wrap], capture_output=True, text=True, timeout=600)
    out = r.stdout + r.stderr
    ok = (r.returncode == 0) == (atteso_rc == 0)
    for t in atteso_txt:
        ok = ok and (t in out)
    for t in non_txt:
        ok = ok and (t not in out)
    extra = ""
    if atteso_rc == 0:
        desk = os.path.join(home, "Desktop")
        zips = [x for x in os.listdir(desk) if x.endswith(".zip")] if os.path.isdir(desk) else []
        ok = ok and len(zips) == 1
        extra = " zip=%s" % zips
    print("%-4s %-44s rc=%d%s" % ("OK" if ok else "KO", nome, r.returncode, extra))
    if not ok or "--mostra" in sys.argv:
        print("     ---- output ----\n" + "\n".join("     " + l for l in out.strip().split("\n")[-25:]))
    shutil.rmtree(tmp, ignore_errors=True)
    return ok

tutti = [
 scenario("sano (CSV sintetico, calibrazione non decisiva)", atteso_txt=("autotest anatomia : AUTOTEST: ", "autotest confronto: AUTOTEST: ", "ZIP DA MANDARE", "tutti i file attesi presenti", "MISURATO CON RILIEVI")),
 scenario("macchina sbagliata (VPS)", comp="VMI3047753", atteso_rc=1, atteso_txt=("QUESTA RIGA GIRA SOLO SUL PC DI BACKTEST",), non_txt=("autotest anatomia :",)),
 scenario("marcatore mancante nel confronto", strip_marker="confronto_tocco_chiusura_m5.py", atteso_rc=1, atteso_txt=("SENZA il marcatore",)),
 scenario("SHA256 diverso nell anatomia", append_to="anatomia_movimenti_m5.py", atteso_rc=1, atteso_txt=("SHA256 DIVERSO",)),
 scenario("SHA256 diverso nel confronto", append_to="confronto_tocco_chiusura_m5.py", atteso_rc=1, atteso_txt=("SHA256 DIVERSO",)),
 scenario("CSV assente", csv="assente", atteso_rc=1, atteso_txt=("CSV M1 NON TROVATO",)),
 scenario("CSV nel formato sbagliato", csv="storto", atteso_rc=1, atteso_txt=("NON e nel Formato 1",)),
 scenario("autotest del confronto fallisce", fake="autotest_confronto", atteso_rc=1, atteso_txt=("AUTOTEST DEL CONFRONTO NON SUPERATO",)),
 scenario("autotest dell anatomia fallisce", fake="autotest_anatomia", atteso_rc=1, atteso_txt=("AUTOTEST DELL ANATOMIA NON SUPERATO",)),
 scenario("misura esce 2 (file mancanti): FALLITO ma zip", fake="rc2", atteso_rc=0, atteso_txt=("FALLITO rc 2", "MANCANO", "ATTENZIONE: la misura NON e riuscita")),
]
print("SCENARI: %d/%d" % (sum(tutti), len(tutti)))
sys.exit(0 if all(tutti) else 1)
