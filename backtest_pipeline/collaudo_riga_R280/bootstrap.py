#!/usr/bin/env python3
# -*- coding: ascii -*-
"""
bootstrap.py -- scrive backtest_pipeline/righe/RIGA_LANCIA_R280.txt: il bootstrap CORTO che Claudio incolla. Scarica la riga R280 dal commit che
la contiene (letta con git show, mai dal disco), ne controlla SHA256 e marcatore, e solo allora la esegue. Stessa forma di collaudo_riga_DAXAP03/bootstrap.py.
Il commit passato DEVE essere raggiungibile da origin/lavoro (git merge-base --is-ancestor): un commit riscritto da un rebase e' un 404 su GitHub raw.
Uso: python3 backtest_pipeline/collaudo_riga_R280/bootstrap.py <COMMIT_DELLA_RIGA_40_hex> [--dest FILE]
"""
import hashlib, os, re, subprocess, sys
QD = os.path.dirname(os.path.abspath(__file__))
REPO = os.path.abspath(os.path.join(QD, "..", ".."))
C = sys.argv[1]
assert re.match(r"^[0-9a-f]{40}$", C)
r = subprocess.run(["git", "merge-base", "--is-ancestor", C, "origin/lavoro"], cwd=REPO)
assert r.returncode == 0, "il commit %s NON e' raggiungibile da origin/lavoro: prima push, poi bootstrap" % C[:8]
riga = subprocess.run(["git", "show", "%s:backtest_pipeline/righe/RIGA_ROUND_R280.txt" % C], cwd=REPO, capture_output=True, check=True).stdout
H = hashlib.sha256(riga).hexdigest().upper()
MARC = "MARCATORE_RIGA_ROUND_R280_v1"
assert riga.count(MARC.encode()) == 1 and b"MARCATORE_RIGA_ROUND_VPS_RETRY_v1" in riga
msg = ("BERSAGLIO: SOLO una finestra PowerShell sul PC di backtest DESKTOP-H4D7CAJ (terminale C:\\Program Files\\BCM Markets MT5 Terminal, demo 50503392). "
       "NON e il VPS VMI3047753; NON FTMO trial 1514806751 (C:\\FTMO, ex challenge 541452707), NON REALE 10105439 (C:\\BCM_Reale), NON il piccolo 50503392 sul VPS "
       "(BCM Markets MT5 Terminal), NON 100k 50504263 (BCM Markets MT5 Terminal -V3), NON manuale 50503635 (C:\\MT5_MANUALE), NON banco 50504400 (C:\\MT5_Backtest), "
       "NON Pepperstone, NON Tickmill. Esegue la riga di round R280 (R280e + R280a, due job, ABTG_Nasdaq_Apertura_US su U30USD, Modello 4, deposito 10000, driver con "
       "la riprova) del commit %s solo se impronta e marcatore tornano: le garanzie le dichiara la riga R280 nel suo BERSAGLIO. NON lanciarla se una riga di round "
       "sta GIA girando su questo PC, in qualunque finestra (classe 853)." % C[:8])
assert "'" not in msg
t = ("& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12; Write-Host '" + msg + "' -ForegroundColor Yellow; "
     "$u='https://raw.githubusercontent.com/claudiospadaro12/GITHUB/" + C + "/backtest_pipeline/righe/RIGA_ROUND_R280.txt'; "
     "$wc=New-Object Net.WebClient; $b=$wc.DownloadData($u); $sha=New-Object Security.Cryptography.SHA256Managed; $h=[BitConverter]::ToString($sha.ComputeHash($b)).Replace('-',''); "
     "if($h -ne '" + H + "'){ Write-Host ('IMPRONTA DIVERSA ('+$h+'): mi fermo, non lancio niente.') -ForegroundColor Red; return }; "
     "Write-Host ('Riga R280 scaricata, impronta OK: '+$h.Substring(0,8)); $t=[Text.Encoding]::ASCII.GetString($b); "
     "if(-not ($t | Select-String -SimpleMatch -Quiet -Pattern '" + MARC + "')){ Write-Host 'Marcatore della riga R280 assente nella riga scaricata: mi fermo.' -ForegroundColor Red; return }; "
     "Invoke-Expression $t }")
t.encode("ascii")
dest = os.path.join(REPO, "backtest_pipeline", "righe", "RIGA_LANCIA_R280.txt")
if "--dest" in sys.argv:
    dest = sys.argv[sys.argv.index("--dest") + 1]
open(dest, "w", newline="").write(t)
print(len(t), "byte; SHA256 della riga", H, "; SHA256 del bootstrap", hashlib.sha256(t.encode("ascii")).hexdigest().upper())
