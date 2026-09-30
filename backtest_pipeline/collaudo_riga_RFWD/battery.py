#!/usr/bin/env python3
# -*- coding: ascii -*-
"""
battery.py -- il collaudo a macchina di RIGA_ROUND_RFWD.txt.

Fa girare la riga VERA sotto pwsh (Linux, PowerShell 7) con un driver FINTO (stub_driver.py) che scrive CSV IS/OOS e
per-trade nel formato di OptFrame/ExportTrades, con `irm` servito da un magazzino locale (i file AL PIN, via git show) e con il
confronto_forward_tester.py VERO (python3 al posto di python.exe). Verifica che ogni cancello dichiarato dalla riga scatti quando
deve e NON scatti quando non deve, e che il confronto giri per intero: in particolare che un tester FEDELE dia H_FEDELI e che
uno con l'orologio sfasato di +60 minuti NON lo dia.
NON prova: Windows PowerShell 5.1, MT5, il tester, il tempo, la memoria, i tick.

Uso:  python3 backtest_pipeline/collaudo_riga_RFWD/battery.py [PIN]   (esce 0 se tutto come atteso)
Serve: pwsh, python3, iconv, git. Scrive in $HARNESS_OUT (default /tmp/rfwd_harness).
"""
import json, os, subprocess, sys
QD = os.path.dirname(os.path.abspath(__file__))
REPO = os.path.abspath(os.path.join(QD, "..", ".."))
OUT = os.environ.get("HARNESS_OUT", "/tmp/rfwd_harness")
os.makedirs(OUT, exist_ok=True)
PIN = sys.argv[1] if len(sys.argv) > 1 else subprocess.check_output(["git", "-C", REPO, "rev-parse", "HEAD"]).decode().strip()

SID = {"RFWD1": "770411", "RFWD2": "770101", "RFWD3": "770105", "RFWD4": "771531", "RFWD5": "770202", "RFWD6": "770260", "RFWD7": "770511"}
ZERO = {"pt_zero": True, "rc": 2, "trades": 0, "no_rows": True}

def scen(extra=None, base_forward=True, zeri=True):
    d = {"_pt_forward": base_forward, "_sid": SID}
    if zeri:
        for l in ("RFWD5", "RFWD6", "RFWD7"):
            d[l] = dict(ZERO)
    for k, v in (extra or {}).items():
        d.setdefault(k, {}).update(v)
    return d

# (nome, scenario, sed sulla riga, grafici, pin, macchina, python, mutazione servita, [DEVE esserci], [NON deve esserci])
T = [
 ("ok_fedele", scen(), "", "ok", PIN, "DESKTOP-H4D7CAJ", "si", "",
  ["FILE NULLI: nessuno", "ROUND LANCIATI: 7 su 7", "G1 per-trade gemelli identici", "AUTOTEST: 47/47 -- superato", "confronto eseguito (rc 0)", "ESITO: H_FEDELI",
   "ZERO CONTRO ZERO", "L1 3 su 3", "FILE ATTESI TROVATI: 49 su 49", "ZIP PRONTO DA MANDARE", "PASSATE viste nel giornale dell agente: 28 su 28 attese",
   "GUARDIA EA: grafici salvati letti 2, con un EA attaccato o illeggibili 0", "CLASSE 166/892: il motore compilato e quello del pin in tutti i 7 round partiti"],
  ["FILE NULLI: nessuno-", "RIGA FERMATA", "ILLEGGIBILE", "MANCA ROUND_", "CATENA ROTTA"]),
 ("orologio_piu60", scen({"RFWD1": {"shift": 60}, "RFWD2": {"shift": 60}, "RFWD3": {"shift": 60}, "RFWD4": {"shift": 60}}), "", "ok", PIN, "DESKTOP-H4D7CAJ", "si", "",
  ["FILE NULLI: nessuno", "confronto eseguito (rc 0)", "H_DIVERSI, ORARI (L1+L2 >= 50%, L1 <= 20%, mediana scarto >= 45 min): SI"], ["ESITO: H_FEDELI"]),
 ("rc1_su_RFWD2", scen({"RFWD2": {"rc1": True}}), "", "ok", PIN, "DESKTOP-H4D7CAJ", "si", "",
  ["FILE NULLO: rc 1 (non e partito)", "PARTITI (rc diverso da 1): 6 su 7", "RFWD2 (rc 1 (non e partito)"], ["FILE NULLI: nessuno"]),
 ("EA_mutato", scen({"RFWD1": {"mut_ea": True}}), "", "ok", PIN, "DESKTOP-H4D7CAJ", "si", "",
  ["ABTG_MaxMinNotte_DAX_Short_Ottimizzato.mq5 SHA256 DIVERSO DAL PIN", "MOTORE DIVERSO DAL PIN in 1 round"], ["FILE NULLI: nessuno"]),
 ("prova_mutata", scen({"RFWD3": {"mut_prova": True}}), "", "ok", PIN, "DESKTOP-H4D7CAJ", "si", "",
  ["prova SHA256 DIVERSO DAL PIN"], ["FILE NULLI: nessuno"]),
 ("pertrade_principale_mancante", scen({"RFWD1": {"pt_missing_main": True}}), "", "ok", PIN, "DESKTOP-H4D7CAJ", "si", "",
  ["E0 PER-TRADE del magic 793411 MANCANTE o vecchio"], ["FILE NULLI: nessuno"]),
 ("pertrade_con_gamba_IS", scen({"RFWD2": {"pt_old_dates": True}}), "", "ok", PIN, "DESKTOP-H4D7CAJ", "si", "",
  ["PRIMA del 2026.09.21", "la gamba IS non e stata sovrascritta"], ["FILE NULLI: nessuno"]),
 ("gemelli_diversi", scen({"RFWD1": {"twin_diff": True}}), "", "ok", PIN, "DESKTOP-H4D7CAJ", "si", "",
  ["G1 PER-TRADE GEMELLI DIVERSI", "RFWD1 ("], ["FILE NULLI: nessuno"]),
 ("asse_csv_diverso", scen({"RFWD4": {"axis_vals": [793531, 793999]}}), "", "ok", PIN, "DESKTOP-H4D7CAJ", "si", "",
  ["ASSE DIVERSO nel CSV _OOS"], ["FILE NULLI: nessuno"]),
 ("pin_dal_csv_diverso", scen({"RFWD5": {"bad_pin": True, "trades": 3, "pt_zero": False, "rc": 3, "no_rows": False}}), "", "ok", PIN, "DESKTOP-H4D7CAJ", "si", "",
  ["P0 PIN DAL CSV _OOS DIVERSO"], ["FILE NULLI: nessuno"]),
 ("csv_OOS_assente", scen({"RFWD6": {"no_OOS": True}}), "", "ok", PIN, "DESKTOP-H4D7CAJ", "si", "",
  ["E0: CSV _OOS NON FRESCO (ASSENTE)"], ["FILE NULLI: nessuno"]),
 ("finestra_riga_diversa_dal_file", scen(), r"s/\$FZ='0.38'; \$OOS0/\$FZ='0.39'; \$OOS0/", "ok", PIN, "DESKTOP-H4D7CAJ", "si", "",
  ["RIGA RFWD INCOERENTE"], ["ROUND LANCIATI"]),
 ("tetto_60_minuti", scen(), r"s/\$minAvv -ge 60/$minAvv -ge 0/", "ok", PIN, "DESKTOP-H4D7CAJ", "si", "",
  ["NON LANCIATO (tetto di 60 minuti", "NON LANCIATI (tetto): 7"], ["ROUND LANCIATI: 7 su 7"]),
 ("macchina_sbagliata", scen(), "", "ok", PIN, "VMI3047753", "si", "",
  ["QUESTA RIGA GIRA SOLO SUL PC DI BACKTEST DESKTOP-H4D7CAJ"], ["ROUND LANCIATI", "GUARDIA EA"]),
 ("grafico_con_EA", scen(), "", "ea", PIN, "DESKTOP-H4D7CAJ", "si", "",
  ["GUARDIA EA: grafici salvati letti 3, con un EA attaccato o illeggibili 1", "GUARDIA EA: nel profilo del terminale 50503392"], ["ROUND LANCIATI"]),
 ("grafico_illeggibile", scen(), "", "rotto", PIN, "DESKTOP-H4D7CAJ", "si", "",
  ["ILLEGGIBILE", "GUARDIA EA: nel profilo del terminale 50503392"], ["ROUND LANCIATI"]),
 ("zero_grafici", scen(), "", "zero", PIN, "DESKTOP-H4D7CAJ", "si", "",
  ["GUARDIA EA: ho letto ZERO grafici salvati"], ["ROUND LANCIATI"]),
 ("confronto_mutato_sha", scen(), "", "ok", PIN, "DESKTOP-H4D7CAJ", "si", "cft",
  ["confronto_forward_tester.py scaricato con SHA256 DIVERSO"], ["ROUND LANCIATI"]),
 ("driver_mutato_sha", scen(), "", "ok", PIN, "DESKTOP-H4D7CAJ", "si", "drv",
  ["RIGA_ROUND_VPS.ps1 scaricata con SHA256 DIVERSO"], ["ROUND LANCIATI"]),
 ("xlsx_mutato_sha", scen(), "", "ok", PIN, "DESKTOP-H4D7CAJ", "si", "xlsx",
  ["il forward xlsx scaricato ha SHA256 DIVERSO"], ["ROUND LANCIATI"]),
 ("python_assente", scen(), "", "ok", PIN, "DESKTOP-H4D7CAJ", "no", "",
  ["PYTHON ASSENTE", "il confronto NON e stato eseguito", "ZIP PRONTO DA MANDARE", "FILE NULLI: nessuno"], ["confronto eseguito (rc 0)"]),
 ("autotest_rosso", scen(), "SED_AUTOTEST", "ok", PIN, "DESKTOP-H4D7CAJ", "si", "cftrot",
  ["AUTOTEST DEL CONFRONTO NON SUPERATO", "il confronto NON e stato eseguito", "ZIP PRONTO DA MANDARE"], ["confronto eseguito (rc 0)"]),
 ("pertrade_della_gamba_IS_zero_operazioni", scen({"RFWD5": {"pt_old_mtime": True}}), "", "ok", PIN, "DESKTOP-H4D7CAJ", "si", "",
  ["NON PIU RECENTE del CSV _IS", "zero operazioni NON dimostrate"], ["FILE NULLI: nessuno"]),
 ("nessun_log_agente", scen({"RFWD1": {"no_logs": True}}), "", "ok", PIN, "DESKTOP-H4D7CAJ", "si", "",
  ["FILE NULLI: nessuno"], ["RIGA FERMATA"]),
 # classe 938 (controllo preventivo 30/09): gamba OOS morta per "Tester cannot be initialized" (R258k, 28/09): rc 2 come uno zero-operazioni,
 # la riga deve dire NULLO, attribuire il guasto al job per nome e dare il rimedio (cache + rilancio), e la sintesi deve nominare chi ne resta fuori
 ("guasto_tester_init_OOS", scen({"RFWD2": {"init_fail": True, "no_OOS": True, "pt_old_mtime": True, "rc": 2}}), "", "ok", PIN, "DESKTOP-H4D7CAJ", "si", "",
  ["E0: CSV _OOS NON FRESCO (ASSENTE)", "GUASTO DEL TESTER (classe 909), Tester cannot be initialized: 1 volte -> RFWD2 alle", "PRIMA DI RILANCIARE",
   "Tester\\cache", "RFWD2 ("], ["FILE NULLI: nessuno", "job non attribuito"]),
 ("sintesi_per_nome", scen({"RFWD1": {"pt_missing_main": True}}), "", "ok", PIN, "DESKTOP-H4D7CAJ", "si", "",
  ["NON MISURATA", "E0 PER-TRADE del magic 793411 MANCANTE"], ["FILE NULLI: nessuno"]),
]

def run(nome, sc, sed, ch, pin, pc, py, mut):
    sf = os.path.join(OUT, "scen_%s.json" % nome)
    json.dump(sc, open(sf, "w"))
    if sed == "SED_AUTOTEST":
        # il confronto mutato ha un altro SHA: si sostituisce lo SHA della riga con quello del file mutato, cosi' passa il cancello dello SHA e cade sull'autotest
        import hashlib, re
        b = subprocess.check_output(["git", "-C", REPO, "show", "%s:backtest_pipeline/confronto_forward_tester.py" % pin])
        t = b.decode("utf-8").replace('abs(f["t"] - t["t"]) <= tol and', 'abs(f["t"] - t["t"]) < tol and')
        shaM = hashlib.sha256(t.encode("utf-8")).hexdigest().upper()
        riga = open(os.path.join(REPO, "backtest_pipeline", "righe", "RIGA_ROUND_RFWD.txt"), encoding="ascii").read()
        shaP = hashlib.sha256(b).hexdigest().upper()
        assert shaP in riga
        sed = "s/%s/%s/" % (shaP, shaM)
    env = dict(os.environ, HARNESS_OUT=OUT)
    subprocess.run(["bash", os.path.join(QD, "run.sh"), nome, sf, sed, ch, pin, pc, py, mut], env=env, capture_output=True)
    return open(os.path.join(OUT, "run_%s" % nome, "out.txt"), encoding="utf-8", errors="replace").read()

def main():
    ok = 0
    for (nome, sc, sed, ch, pin, pc, py, mut, deve, nondeve) in T:
        out = run(nome, sc, sed, ch, pin, pc, py, mut)
        mancano = [x for x in deve if x not in out]
        troppo = [x for x in nondeve if x in out]
        esito = not mancano and not troppo
        ok += 1 if esito else 0
        print(("PASS  " if esito else "FALLITO ") + nome)
        for x in mancano:
            print("      MANCA nell'uscita:", x)
        for x in troppo:
            print("      NON doveva esserci:", x)
    print("BATTERIA: %d/%d" % (ok, len(T)))
    sys.exit(0 if ok == len(T) else 1)

if __name__ == "__main__":
    main()
