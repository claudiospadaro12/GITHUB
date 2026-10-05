#!/usr/bin/env python3
# -*- coding: ascii -*-
"""
bootstrap.py -- scrive backtest_pipeline/righe/RIGA_LANCIA_OMBRA_INSTALL.txt: il bootstrap CORTO (una riga fisica, ASCII) che Claudio incollera' DOPO i cancelli.
Scarica RIGA_OMBRA_INSTALL.ps1 dal commit che la contiene (letta con git show, mai dal disco), controlla SHA256 e marcatore, passa pin e impronta alla riga
(variabili OMBRA_PIN e OMBRA_SHA, che la riga stampa nel referto) e la esegue con Invoke-Expression: la riga NON ha `exit` ne' param() (statico.py lo prova).
La guardia macchina sta QUI (prima di qualunque download) e dentro la riga (seconda volta).
NIENTE A MANO (classe 1093): il BERSAGLIO nasce da questo generatore, e i valori dell'EA (commit, SHA256) li LEGGE dalle costanti dello script al commit e li RICONTROLLA contro git
(l'artefatto al commit dell'EA ha davvero quello SHA256 e il commit e' raggiungibile da origin/lavoro).
Il commit passato DEVE essere raggiungibile da origin/lavoro (un commit riscritto da un rebase e' un 404 su GitHub raw).
Uso: python3 backtest_pipeline/collaudo_riga_OMBRA_INSTALL/bootstrap.py <COMMIT_DELLA_RIGA_40_hex> [--dest FILE]
"""
import hashlib, os, re, subprocess, sys
QD = os.path.dirname(os.path.abspath(__file__))
REPO = os.path.abspath(os.path.join(QD, "..", ".."))
C = sys.argv[1]
assert re.match(r"^[0-9a-f]{40}$", C)


def anc(c):
    return subprocess.run(["git", "merge-base", "--is-ancestor", c, "origin/lavoro"], cwd=REPO).returncode == 0


assert anc(C), "il commit %s NON e' raggiungibile da origin/lavoro: prima push, poi bootstrap" % C[:8]
riga = subprocess.run(["git", "show", "%s:backtest_pipeline/righe/RIGA_OMBRA_INSTALL.ps1" % C], cwd=REPO, capture_output=True, check=True).stdout
txt = riga.decode("ascii")
H = hashlib.sha256(riga).hexdigest().upper()
MARC = "MARCATORE_RIGA_OMBRA_INSTALL_v1"
assert riga.count(MARC.encode()) == 1
ea_pin = re.search(r"\$EaPin\s*=\s*'([0-9a-f]{40})'", txt).group(1)
ea_sha = re.search(r"\$EaSha\s*=\s*'([0-9A-F]{64})'", txt).group(1)
ea_rel = re.search(r"\$EaRel\s*=\s*'([^']+)'", txt).group(1)
assert anc(ea_pin), "il commit dell'EA %s non e' raggiungibile da origin/lavoro" % ea_pin[:8]
ea = subprocess.run(["git", "show", "%s:%s" % (ea_pin, ea_rel)], cwd=REPO, capture_output=True, check=True).stdout
assert hashlib.sha256(ea).hexdigest().upper() == ea_sha, "lo SHA256 dell'EA al commit %s non e' quello dichiarato nello script" % ea_pin[:8]
assert b"OrderSend" not in ea
assert re.search(rb'(?m)^#property\s+version\s+"1\.03"', ea)
msg = ("BERSAGLIO: SOLO una finestra PowerShell sul VPS VMI3047753. Questa riga SOLO COPIA UN FILE (commit %s): ABTG_EMA200_Ombra.mq5 v1.03 (commit %s, SHA256 %s...) "
       "nella cartella MQL5\\Experts del terminale PICCOLO, conto 50503392, programma C:\\Program Files\\BCM Markets MT5 Terminal, dopo averlo riconosciuto per fatti "
       "(origin.txt + giornale con ultimo login 50503392 + giornali recenti). NON compila, NON attacca l EA, NON apre, chiude o riavvia nessun programma, NON tocca grafici, profili, .chr, "
       "preset, EA esistenti, Guardian, config. Scrive UN solo file nel terminale (mai sopra uno esistente) e sul Desktop il referto e lo zip ABTG_OMBRA_INSTALL_*. "
       "Se le cartelle candidate sono zero o piu di una, o il conto non si legge, si ferma senza scrivere. "
       "NON TOCCATI, per nome: REALE 10105439 (C:\\BCM_Reale), FTMO trial 1514806751 (C:\\FTMO), 100k 50504263 (BCM Markets MT5 Terminal -V3), manuale 50503635 (C:\\MT5_MANUALE), "
       "banco 50504400 (C:\\MT5_Backtest), Pepperstone, Tickmill, e il PC di backtest DESKTOP-H4D7CAJ (li esiste un altro terminale con lo STESSO conto 50503392: questa riga li si ferma). "
       "Esegue solo se impronta e marcatore tornano. Se la console mostra >>, Ctrl+C prima di incollare." % (C[:8], ea_pin[:8], ea_sha[:8]))
assert "'" not in msg
t = ("& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12; Write-Host '" + msg + "' -ForegroundColor Yellow; "
     "if($env:COMPUTERNAME -ne 'VMI3047753'){ throw ('QUESTA RIGA GIRA SOLO SUL VPS VMI3047753. Qui la macchina si chiama: ' + $env:COMPUTERNAME + '. Sul PC di backtest DESKTOP-H4D7CAJ non si lancia mai. Nessun download e stato fatto.') }; "
     "$u='https://raw.githubusercontent.com/claudiospadaro12/GITHUB/" + C + "/backtest_pipeline/righe/RIGA_OMBRA_INSTALL.ps1'; "
     "$wc=New-Object Net.WebClient; $b=$wc.DownloadData($u); $sha=New-Object Security.Cryptography.SHA256Managed; $h=[BitConverter]::ToString($sha.ComputeHash($b)).Replace('-',''); "
     "if($h -ne '" + H + "'){ Write-Host ('IMPRONTA DIVERSA ('+$h+'): mi fermo, non lancio niente.') -ForegroundColor Red; return }; "
     "Write-Host ('Riga OMBRA scaricata, impronta OK: '+$h.Substring(0,8)); $t=[Text.Encoding]::ASCII.GetString($b); "
     "if(-not ($t | Select-String -SimpleMatch -Quiet -Pattern '" + MARC + "')){ Write-Host 'Marcatore della riga OMBRA assente nella riga scaricata: mi fermo.' -ForegroundColor Red; return }; "
     "$OMBRA_PIN='" + C + "'; $OMBRA_SHA=$h; Invoke-Expression $t }")
t.encode("ascii")
assert "\n" not in t
dest = os.path.join(REPO, "backtest_pipeline", "righe", "RIGA_LANCIA_OMBRA_INSTALL.txt")
if "--dest" in sys.argv:
    dest = sys.argv[sys.argv.index("--dest") + 1]
open(dest, "w", newline="").write(t)
print(len(t), "byte; SHA256 della riga", H, "; SHA256 del bootstrap", hashlib.sha256(t.encode("ascii")).hexdigest().upper())
