#!/usr/bin/env python3
# -*- coding: ascii -*-
"""
sim_mt5.py -- SIMULATORE dell'esecuzione dello script ABTG_ImportaTickEsterno dentro il terminale (nel banco la funzione Start-Process, che lancerebbe terminal64, lancia questo).
NON e' l'importer: non importa tick e non misura niente. Fa solo quello che la riga figlia deve poter OSSERVARE dall'esterno, secondo uno SCENARIO scritto dal collaudo:
  - legge il preset abtg_duka_import.set scritto dalla riga (simbolo, maschera, giorni, solo-sonda) e i CSV in MQL5\Files che combaciano con la MASCHERA (registra quali: sim_letti_<simbolo>.txt);
  - scrive MQL5\Files\ABTG_ImportTick_giorni.csv (una riga per giorno, col SIMBOLO) e ABTG_ImportTick_referto.csv col verdetto calcolato come l'importer (OK solo se tutti i MISURATI passano:
    un giorno NON_CONFRONTABILE NON conta, e' il difetto r.498 che la riga figlia deve controllare per nome), e un log in MQL5\Logs.
Lo scenario (JSON): {"simboli": {"U30USD_DK": {"2024.11.20": ["MISURATO","0.04","98.0"], ...}}, "righe_grezze": {"U30USD_DK": [[...13 colonne...], ...]}, "non_scrive": ["U30USD_DKNEG"]}
  - "righe_grezze" (se presente per il simbolo) sostituisce le righe fabbricate: serve ai casi avversari (simbolo altro, ripetuti, soglie diverse...).
  - "non_scrive": l'esecuzione non produce nessun file (MT5 non ha eseguito lo script).
Variabili d'ambiente: SIM_DATA (cartella dati reale), SIM_SCEN (file JSON), SIM_ARGS (argomenti di Start-Process), SIM_LOG (cartella dove registrare cio' che ha visto).
"""
import csv, fnmatch, io, json, os, re, sys, time

data = os.environ["SIM_DATA"]
scen = json.load(open(os.environ["SIM_SCEN"]))
log = os.environ["SIM_LOG"]
os.makedirs(log, exist_ok=True)
args = os.environ.get("SIM_ARGS", "")
m = re.search(r"/config:(\S+)", args)
ini = m.group(1) if m else ""
ini_txt = open(ini, "rb").read().decode("utf-16", "replace") if ini and os.path.exists(ini) else ""
preset = os.path.join(data, "MQL5", "Presets", "abtg_duka_import.set")
P = {}
for l in open(preset, encoding="ascii"):
    if "=" in l:
        k, v = l.strip().split("=", 1)
        P[k] = v
sym = P["InpSimboloNuovo"]
with open(os.path.join(log, "sim_lancio_%s.txt" % sym), "w") as f:
    f.write("ini: %s\nAllowLiveTrading=false: %s\npreset: %s\n" % (ini, "AllowLiveTrading=false" in ini_txt, json.dumps(P, sort_keys=True)))
files = os.path.join(data, "MQL5", "Files")
letti = sorted(n for n in os.listdir(files) if fnmatch.fnmatch(n, P["InpMascheraCsv"]))
with open(os.path.join(log, "sim_letti_%s.txt" % sym), "w") as f:
    f.write("\n".join(letti) + "\n")
if sym in scen.get("non_scrive", []):
    sys.exit(0)
days = [d.strip() for d in P["InpGiorniSonda"].split(";") if d.strip()]
righe = []
ver = "IMP-TICK-v1-GIORNI"
if sym in scen.get("righe_grezze", {}):
    righe = scen["righe_grezze"][sym]
else:
    tab = scen["simboli"].get(sym, {})
    for d in days:
        if not re.match(r"^\d{4}\.\d{2}\.\d{2}$", d):
            righe.append([ver, sym, d, "DATA_MALFORMATA", "-", "-", "0", "0", "-", "-", P["InpSogliaDiffPct"], P["InpSogliaCopertura"], "-"]); continue
        v = tab.get(d)
        if v is None or v[0] != "MISURATO":
            righe.append([ver, sym, d, (v[0] if v else "NON_CONFRONTABILE"), "-", "-", "0", "0", "-", "-", "0.05000000", "80.0000", "-"]); continue
        med, cop = float(v[1]), float(v[2])
        passa = "SI" if (med <= 0.05 and cop >= 80.0) else "NO"
        righe.append([ver, sym, d, "MISURATO", "%.8f" % med, "%.4f" % cop, "1000", "1000", "2.5000", "2.5000", "0.05000000", "80.0000", passa])
with open(os.path.join(files, "ABTG_ImportTick_giorni.csv"), "w", newline="") as f:
    w = csv.writer(f, lineterminator="\r\n")
    w.writerow(["Versione", "Simbolo", "Giorno", "Esito", "MedianaDiffPct", "CoperturaPct", "TickNat", "TickDK", "SpreadNat", "SpreadDK", "SogliaDiffPct", "SogliaCoperturaPct", "PassaImportatore"])
    for r in righe:
        w.writerow(r)
misurati = [r for r in righe if r[3] == "MISURATO"]
ok = [r for r in misurati if r[12] == "SI"]
if not misurati:
    verdetto = "SONDA MANCANTE: NON USARE"; esito = "SONDA NON MISURABILE (nessun giorno confrontabile)"
else:
    esito = "%d/%d giorni dentro soglia" % (len(ok), len(misurati))
    verdetto = "OK: CANCELLO PASSATO" if len(ok) == len(misurati) else ("QUASI: leggere QUALI giorni falliscono (DST?)" if len(ok) >= len(misurati) - 2 else "CANCELLO CHIUSO: NON USARE (come gli _EXT in frigo)")
with open(os.path.join(files, "ABTG_ImportTick_referto.csv"), "w", newline="") as f:
    w = csv.writer(f, lineterminator="\r\n")
    w.writerow(["Versione", "SimboloDK", "SimboloSorgente", "Maschera", "FileImportati", "TickScritti", "RigheScartate", "TickFuoriOrdine", "PrimoTick", "UltimoTick", "ProprietaGuaste", "EsitoSonda", "Verdetto"])
    w.writerow([ver, sym, "U30USD", P["InpMascheraCsv"], str(len(letti)), "12345", "0", "0", "2024.10.01 00:00", "2025.06.16 23:59", "0", esito, verdetto])
os.makedirs(os.path.join(data, "MQL5", "Logs"), exist_ok=True)
open(os.path.join(data, "MQL5", "Logs", "20261005.log"), "a").write("sim: import %s eseguito\n" % sym)
