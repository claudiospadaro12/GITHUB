#!/usr/bin/env python3
"""aggregatore_non_legge_csv.py - punto (4): esegue agents/A4/agg_conferma.py dentro questo processo con un audit hook di Python
(sys.addaudithook) che registra open(), listdir/scandir, glob e creazione di sottoprocessi; verifica che NON venga aperto alcun
file .csv ne alcun file fuori dall'elenco ammesso (JSON in ingresso, hash, criteri, codice Python importato, output). Uso: python3 -I aggregatore_non_legge_csv.py"""
import os, runpy, sys, json, tempfile
HERE = os.path.dirname(os.path.abspath(__file__)); sys.path.insert(0, HERE)
import scenari_aggregatore as SA
eventi = []
def hook(ev, args):
    if ev == "open":
        eventi.append(("open", str(args[0]), str(args[1]) if len(args) > 1 else ""))
    elif ev == "os.scandir" and args and isinstance(args[0], int):
        import traceback; eventi.append((ev, "fd=%s da: %s" % (args[0], " <- ".join("%s:%d" % (os.path.basename(f.filename), f.lineno) for f in traceback.extract_stack()[-6:-1])), ""))
    elif ev in ("os.listdir", "os.scandir", "glob.glob", "subprocess.Popen", "os.system", "socket.connect", "os.walk"):
        eventi.append((ev, str(args)[:120], ""))
with tempfile.TemporaryDirectory() as td:
    files = {}
    for sym, trs in SA.SCEN[0]["per"].items():
        j = SA.costruisci(sym, trs); files[sym] = os.path.join(td, sym + ".json"); json.dump(j, open(files[sym], "w"))
    # decoy: un CSV con il nome atteso accanto ai JSON; se l'aggregatore lo aprisse lo vedremmo
    open(os.path.join(td, "ABTG_M1_EURUSD_2015.csv"), "w").write("time;open;high;low;close;tickvol;spread\n")
    sys.argv = [SA.AGG, "--json"] + ["%s=%s" % kv for kv in files.items()] + ["--out", os.path.join(td, "o"), "--hash-codice", SA.HASH_V2, "--criteri", SA.CRITERI]
    sys.addaudithook(hook)
    try:
        runpy.run_path(SA.AGG, run_name="__main__")
    except SystemExit:
        pass
    snap = list(eventi)                    # fotografia subito dopo l'esecuzione: la pulizia della cartella temporanea non conta
csv = [e for e in snap if e[1].lower().endswith(".csv")]
altri = [e for e in snap if e[0] != "open" and "/lib/python" not in e[1] and "dist-packages" not in e[1] and "site-packages" not in e[1]]
aperti = sorted({e[1] for e in snap if e[0] == "open" and not e[1].endswith((".pyc", ".so")) and "/lib/python" not in e[1] and "site-packages" not in e[1]})
print("file aperti dall'aggregatore (esclusi moduli di libreria):")
for a in aperti: print("   ", a.replace(td, "<tmp>"))
print("aperture di file .csv: %d ; listdir/glob/walk/subprocess/socket: %d %s" % (len(csv), len(altri), altri[:3]))
print("ESITO: %s" % ("SUPERATO: nessun CSV letto" if not csv and not altri else "FALLITO"))
