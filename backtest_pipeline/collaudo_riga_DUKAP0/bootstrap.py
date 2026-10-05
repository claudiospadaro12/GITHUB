#!/usr/bin/env python3
# -*- coding: ascii -*-
"""
bootstrap.py -- scrive backtest_pipeline/righe/RIGA_LANCIA_DUKA_P0.txt: il bootstrap CORTO (una riga fisica, ASCII) che Claudio incollera' DOPO i cancelli e la firma F2.
Scarica RIGA_DUKA_P0_CENSIMENTO.ps1 dal commit che la contiene (letta con git show, mai dal disco), controlla SHA256 e marcatore, passa pin e impronta alla riga
(variabili DUKA_P0_PIN e DUKA_P0_SHA, che la riga stampa nel referto) e la esegue con Invoke-Expression: la riga NON ha `exit` ne' param() (statico.py lo prova).
La guardia macchina sta QUI (prima di qualunque download) e dentro la riga (seconda volta).
Il commit passato DEVE essere raggiungibile da origin/lavoro (un commit riscritto da un rebase e' un 404 su GitHub raw).
Uso: python3 backtest_pipeline/collaudo_riga_DUKAP0/bootstrap.py <COMMIT_DELLA_RIGA_40_hex> [--dest FILE]
"""
import hashlib, os, re, subprocess, sys
QD = os.path.dirname(os.path.abspath(__file__))
REPO = os.path.abspath(os.path.join(QD, "..", ".."))
C = sys.argv[1]
assert re.match(r"^[0-9a-f]{40}$", C)
r = subprocess.run(["git", "merge-base", "--is-ancestor", C, "origin/lavoro"], cwd=REPO)
assert r.returncode == 0, "il commit %s NON e' raggiungibile da origin/lavoro: prima push, poi bootstrap" % C[:8]
riga = subprocess.run(["git", "show", "%s:backtest_pipeline/righe/RIGA_DUKA_P0_CENSIMENTO.ps1" % C], cwd=REPO, capture_output=True, check=True).stdout
riga.decode("ascii")
H = hashlib.sha256(riga).hexdigest().upper()
MARC = "MARCATORE_RIGA_DUKA_P0_v3"
assert riga.count(MARC.encode()) == 1
msg = ("BERSAGLIO: SOLO una finestra PowerShell sul PC di backtest DESKTOP-H4D7CAJ (terminale C:\\Program Files\\BCM Markets MT5 Terminal, demo 50503392). "
       "Questa e la riga P0 di SOLA LETTURA del piano Dow Dukascopy (commit %s): NON apre MT5, NON scarica dati Dukascopy, NON lancia python ne curl, NON chiude nessun processo, "
       "NON scrive niente fuori da una cartella DUKA_P0_data sul Desktop e dal suo zip. Legge: spazio disco, cache raw e CSV tick di dukascopy_lavoro, giornali e grafici salvati "
       "del terminale BCM. NON TOCCATI, per nome: il VPS VMI3047753 e tutte le sue cartelle dati -- FTMO trial 1514806751 (C:\\FTMO, ex challenge 541452707), REALE 10105439 "
       "(C:\\BCM_Reale), piccolo 50503392 sul VPS (BCM Markets MT5 Terminal), 100k 50504263 (BCM Markets MT5 Terminal -V3), manuale 50503635 (C:\\MT5_MANUALE), "
       "banco 50504400 (C:\\MT5_Backtest), Pepperstone, Tickmill. Esegue il censimento solo se impronta e marcatore tornano. Se la console mostra >>, Ctrl+C prima di incollare." % C[:8])
assert "'" not in msg
t = ("& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12; Write-Host '" + msg + "' -ForegroundColor Yellow; "
     "if($env:COMPUTERNAME -ne 'DESKTOP-H4D7CAJ'){ throw ('QUESTA RIGA GIRA SOLO SUL PC DI BACKTEST DESKTOP-H4D7CAJ. Qui la macchina si chiama: ' + $env:COMPUTERNAME + '. Sul VPS VMI3047753 non si lancia mai. Nessun download e stato fatto.') }; "
     "$u='https://raw.githubusercontent.com/claudiospadaro12/GITHUB/" + C + "/backtest_pipeline/righe/RIGA_DUKA_P0_CENSIMENTO.ps1'; "
     "$wc=New-Object Net.WebClient; $b=$wc.DownloadData($u); $sha=New-Object Security.Cryptography.SHA256Managed; $h=[BitConverter]::ToString($sha.ComputeHash($b)).Replace('-',''); "
     "if($h -ne '" + H + "'){ Write-Host ('IMPRONTA DIVERSA ('+$h+'): mi fermo, non lancio niente.') -ForegroundColor Red; return }; "
     "Write-Host ('Riga P0 scaricata, impronta OK: '+$h.Substring(0,8)); $t=[Text.Encoding]::ASCII.GetString($b); "
     "if(-not ($t | Select-String -SimpleMatch -Quiet -Pattern '" + MARC + "')){ Write-Host 'Marcatore della riga P0 assente nella riga scaricata: mi fermo.' -ForegroundColor Red; return }; "
     "$DUKA_P0_PIN='" + C + "'; $DUKA_P0_SHA=$h; Invoke-Expression $t }")
t.encode("ascii")
assert "\n" not in t
dest = os.path.join(REPO, "backtest_pipeline", "righe", "RIGA_LANCIA_DUKA_P0.txt")
if "--dest" in sys.argv:
    dest = sys.argv[sys.argv.index("--dest") + 1]
open(dest, "w", newline="").write(t)
print(len(t), "byte; SHA256 della riga", H, "; SHA256 del bootstrap", hashlib.sha256(t.encode("ascii")).hexdigest().upper())
