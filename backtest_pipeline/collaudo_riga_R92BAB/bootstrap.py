#!/usr/bin/env python3
# -*- coding: ascii -*-
"""
bootstrap.py -- scrive backtest_pipeline/righe/RIGA_LANCIA_R92BAB.txt: il bootstrap CORTO che Claudio incolla. Scarica la riga R92BAB dal commit che la contiene
(letta con git show, mai dal disco), ne controlla SHA256 e marcatore, e solo allora la esegue. Stessa forma di RIGA_LANCIA_RFWD.txt.
Uso: python3 backtest_pipeline/collaudo_riga_R92BAB/bootstrap.py <COMMIT_DELLA_RIGA_40_hex> [--dest FILE]
"""
import hashlib, os, re, subprocess, sys
QD = os.path.dirname(os.path.abspath(__file__))
REPO = os.path.abspath(os.path.join(QD, "..", ".."))
C = sys.argv[1]
assert re.match(r"^[0-9a-f]{40}$", C)
riga = subprocess.run(["git", "show", "%s:backtest_pipeline/righe/RIGA_ROUND_R92BAB.txt" % C], cwd=REPO, capture_output=True, check=True).stdout
H = hashlib.sha256(riga).hexdigest().upper()
assert b"MARCATORE_RIGA_ROUND_VPS_" in riga
msg = ("BERSAGLIO: SOLO il PC di backtest DESKTOP-H4D7CAJ (terminale C:\\Program Files\\BCM Markets MT5 Terminal, demo 50503392). NON e il VPS VMI3047753, "
       "NON FTMO 541452707, NON REALE 10105439, NON il piccolo 50503392 sul VPS, NON 100k 50504263, NON manuale 50503635, NON banco 50504400, NON Pepperstone, NON Tickmill. "
       "Esegue la riga diagnostica R92BAB del commit %s solo se impronta e marcatore tornano: le garanzie le dichiara la riga R92BAB nel suo BERSAGLIO. "
       "NON lanciarla se una riga di round sta GIA girando su questo PC, in qualunque finestra (classe 853)." % C[:8])
t = ("& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12; Write-Host '" + msg + "'; "
     "$u='https://raw.githubusercontent.com/claudiospadaro12/GITHUB/" + C + "/backtest_pipeline/righe/RIGA_ROUND_R92BAB.txt'; "
     "$wc=New-Object Net.WebClient; $b=$wc.DownloadData($u); $sha=New-Object Security.Cryptography.SHA256Managed; $h=[BitConverter]::ToString($sha.ComputeHash($b)).Replace('-',''); "
     "if($h -ne '" + H + "'){ Write-Host ('IMPRONTA DIVERSA ('+$h+'): mi fermo, non lancio niente.') -ForegroundColor Red; return }; "
     "Write-Host ('Riga R92BAB scaricata, impronta OK: '+$h.Substring(0,8)); $t=[Text.Encoding]::ASCII.GetString($b); "
     "if(-not ($t | Select-String -SimpleMatch -Quiet -Pattern 'MARCATORE_RIGA_ROUND_VPS_')){ Write-Host 'Marcatore del driver assente nella riga scaricata: mi fermo.' -ForegroundColor Red; return }; "
     "Invoke-Expression $t }")
t.encode("ascii")
dest = os.path.join(REPO, "backtest_pipeline", "righe", "RIGA_LANCIA_R92BAB.txt")
if "--dest" in sys.argv:
    dest = sys.argv[sys.argv.index("--dest") + 1]
open(dest, "w", newline="").write(t)
print(len(t), "byte; SHA256 della riga", H, "; SHA256 del bootstrap", hashlib.sha256(t.encode("ascii")).hexdigest().upper())
