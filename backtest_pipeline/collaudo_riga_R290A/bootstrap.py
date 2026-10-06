#!/usr/bin/env python3
# -*- coding: ascii -*-
"""
bootstrap.py -- scrive backtest_pipeline/righe/RIGA_LANCIA_R290A.txt: la RIGA che Claudio incolla (UNA riga fisica, ASCII). Scarica PASSATA_STOP_SUPREV_NAS.ps1 dal commit che la contiene (letta con git show,
mai dal disco), ne controlla l'IMPRONTA SHA256 e il marcatore, la scrive sul disco e RICONTROLLA l'impronta del file scritto, e solo allora la lancia. Stessa forma di collaudo_riga_R280/bootstrap.py
(impronta calcolata qui dal commit, mai dal disco) ma la riga e' anche il lancio: guardia macchina, guardia MT5, bersaglio e NON toccati, tempo atteso, cosa guardare per prima, raccolta.
Il commit passato DEVE essere raggiungibile da origin/lavoro (git merge-base --is-ancestor): un commit riscritto da un rebase e' un 404 su GitHub raw.
Il commit deve contenere ANCHE (la passata li scarica al pin): la prova R290a, il CSV dello spread, l'EA e l'include.
Uso: python3 backtest_pipeline/collaudo_riga_R290A/bootstrap.py <COMMIT_40_hex> [--dest FILE] [--senza-origin]
"""
import hashlib, os, re, subprocess, sys
QD = os.path.dirname(os.path.abspath(__file__))
REPO = os.path.abspath(os.path.join(QD, "..", ".."))
C = sys.argv[1]
assert re.match(r"^[0-9a-f]{40}$", C), "il commit va passato di 40 caratteri esadecimali minuscoli"
if "--senza-origin" not in sys.argv:
    r = subprocess.run(["git", "merge-base", "--is-ancestor", C, "origin/lavoro"], cwd=REPO)
    assert r.returncode == 0, "il commit %s NON e' raggiungibile da origin/lavoro: prima push, poi bootstrap" % C[:8]
FILE = "backtest_pipeline/righe/PASSATA_STOP_SUPREV_NAS.ps1"
for rel in (FILE, "backtest_pipeline/prove/R290a_stop_SUPREV_NASUSD_LS_ancora970913.txt", "backtest_pipeline/risultati_archivio/spread_flotta/spread_orario_NASUSD.csv",
            "mql5/Experts/ABTG_SupertrendReversal.mq5", "mql5/Include/ABTG_PausaGuardian.mqh"):
    assert subprocess.run(["git", "cat-file", "-e", "%s:%s" % (C, rel)], cwd=REPO).returncode == 0, "il commit %s non contiene %s" % (C[:8], rel)
src = subprocess.run(["git", "show", "%s:%s" % (C, FILE)], cwd=REPO, capture_output=True, check=True).stdout
src.decode("ascii")
H = hashlib.sha256(src).hexdigest().upper()
MARC = "MARCATORE_PASSATA_STOP_SUPREV_NAS_v1"
assert src.count(MARC.encode()) >= 1 and src.splitlines()[1].decode() == "#  " + MARC, "il marcatore deve stare alla riga 2 dello script"

bersaglio = ("BERSAGLIO: SOLO una finestra PowerShell sul PC di backtest DESKTOP-H4D7CAJ: terminale C:\\Program Files\\BCM Markets MT5 Terminal (cartella BCM Markets MT5 Terminal), "
             "loggato sul demo 50503392. La passata lo apre e lo chiude da sola (backtest, AllowLiveTrading=false: nessun ordine). "
             "NON TOCCATI, per nome: il VPS VMI3047753 e TUTTE le sue cartelle dati -- FTMO 541452707 (C:\\FTMO), REALE 10105439 (C:\\BCM_Reale), 100k 50504263 (BCM Markets MT5 Terminal -V3), "
             "piccolo 50503392 sul VPS (BCM Markets MT5 Terminal), manuale 50503635 (C:\\MT5_MANUALE), banco 50504400 (C:\\MT5_Backtest), Pepperstone, Tickmill. "
             "Scrive SOLO: la cartella abtg_passata nel profilo utente, MQL5\\Experts e MQL5\\Include del terminale BCM di questa macchina, il Desktop (cartella e zip PASSATA_STOP_SUPREV_NAS).")
cosa = ("PASSATA STOP SUPREV NAS (commit " + C[:8] + ") -- misura la distanza INGRESSO->SL della sedia SupRev NAS 970913: ABTG_SupertrendReversal su NASUSD H1 con la geometria della sedia, "
        "buffer 2253, DUE LATI INSIEME, UNA passata a tick reali 2024.09.26 -> 2026.06.30, deposito 100000. Chiude il cancello di costo stop >= 40 x spread con una MISURA e riproduce r163a (G0).")
tempo = ("TEMPO ATTESO 10-17 MINUTI (11 minuti a cella sul PC di backtest per R238; fino a circa 30 se la passata singola e piu lenta). NON fermarla prima di 45 minuti: il tetto dello script e 60. "
         "Il terminale si apre e si chiude da solo UNA volta. Prerequisito: NESSUN MT5 o MetaEditor aperto su questo PC e NESSUNA sedia attaccata ai grafici salvati del terminale BCM (lo script si ferma e lo dice).")
guarda = ("TRE COSE DA GUARDARE PER PRIME quando torna, scritte PRIMA: (1) ESITO PASSATA: AFFIDABILE oppure NON MISURATO (rc 0 oppure rc 3) e la riga G0 -- se G0 non e raggiunto o la configurazione e rotta, "
          "NESSUN numero di stop si usa e si manda comunque lo zip; (2) la MEDIANA dello stop a buffer 2253, attesa fra 93 e 188 punti indice (sotto 65 la mia ipotesi e smentita); "
          "(3) la banda C3 (PASSA >= 44, FRAGILE 36-44, NON PASSA < 36) a 2253 MISURA e a 3003 / 3378 / 4503 DERIVATI: lo script non promuove niente, SOPRA o SOTTO li scrive il cancello.")
fine = "FILE ATTESI NELLO ZIP sul Desktop (PASSATA_STOP_SUPREV_NAS.zip): RIEPILOGO_PASSATA_NAS.txt + STOP_NAS.csv + passata_NAS.ini + spread_orario_NASUSD.csv (+ il report .htm e il per-trade, se trovati)"
for s in (bersaglio, cosa, tempo, guarda, fine):
    assert "'" not in s, s
    s.encode("ascii")

t = ("& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12; $PIN='" + C + "'; $T0=Get-Date; "
     "Write-Host '" + bersaglio + "' -ForegroundColor Yellow; "
     "if($env:COMPUTERNAME -ne 'DESKTOP-H4D7CAJ'){ throw ('QUESTA RIGA GIRA SOLO SUL PC DI BACKTEST DESKTOP-H4D7CAJ. Qui la macchina si chiama: ' + $env:COMPUTERNAME + '. Sul VPS VMI3047753 non si lancia: la challenge FTMO 541452707 sta operando.') }; "
     "Write-Host 'PRIMA DI CHIUDERE MT5: apri il terminale di QUESTA macchina -- e l UNICO MT5 installato qui, ed e loggato sul DEMO 50503392 -- GUARDA I GRAFICI e stacca eventuali SEDIE. Il 14/08/2026 da questa macchina sono partiti ordini VERI (#3160534/#3160535, -104,60). Poi chiudilo A MANO.' -ForegroundColor Red; "
     "if((@(Get-Process -Name terminal64,metaeditor64 -ErrorAction SilentlyContinue)).Count -gt 0){ throw 'MT5 o MetaEditor risulta APERTO su questo PC. La passata ne apre una copia sua con /config: col terminale gia aperto il tester non parte. Fai quello che dice la riga rossa qui sopra, poi rilancia.' }; "
     "$W=Join-Path $env:USERPROFILE 'abtg_passata'; New-Item -ItemType Directory -Force -Path $W | Out-Null; $S=Join-Path $W 'PASSATA_STOP_SUPREV_NAS.ps1'; Remove-Item -LiteralPath $S -Force -ErrorAction SilentlyContinue; "
     "$u='https://raw.githubusercontent.com/claudiospadaro12/GITHUB/'+$PIN+'/" + FILE + "?cb='+[Guid]::NewGuid().ToString('N'); "
     "$wc=New-Object Net.WebClient; $b=$wc.DownloadData($u); $sha=New-Object Security.Cryptography.SHA256Managed; $h=[BitConverter]::ToString($sha.ComputeHash($b)).Replace('-',''); "
     "if($h -ne '" + H + "'){ Write-Host ('IMPRONTA DIVERSA (' + $h + '): copia vecchia o cache di GitHub. Mi fermo, non lancio niente.') -ForegroundColor Red; return }; "
     "$t=[Text.Encoding]::ASCII.GetString($b); "
     "if(-not ($t | Select-String -SimpleMatch -Quiet -Pattern '" + MARC + "')){ Write-Host 'Marcatore " + MARC + " ASSENTE nello script scaricato: mi fermo.' -ForegroundColor Red; return }; "
     "Set-Content -LiteralPath $S -Value $t -Encoding ASCII -NoNewline; "
     "$h2=(Get-FileHash -LiteralPath $S -Algorithm SHA256).Hash; if($h2 -ne '" + H + "'){ Write-Host ('Il file scritto sul disco ha un altra impronta (' + $h2 + '): mi fermo.') -ForegroundColor Red; return }; "
     "Write-Host ('pc  : ' + $env:COMPUTERNAME) -ForegroundColor Green; Write-Host ('pin : ' + $PIN) -ForegroundColor Green; Write-Host ('impronta script: ' + $h.Substring(0,8) + ' OK, marcatore OK') -ForegroundColor Green; Write-Host ('data: ' + $T0.ToString('yyyy-MM-dd HH:mm:ss')) -ForegroundColor Green; "
     "Write-Host '" + cosa + "' -ForegroundColor Cyan; "
     "Write-Host '" + tempo + "' -ForegroundColor Yellow; "
     "Write-Host '" + guarda + "' -ForegroundColor Yellow; "
     "$ErrorActionPreference='Continue'; & powershell.exe -NoProfile -ExecutionPolicy Bypass -File $S -Pin $PIN; $rc=$LASTEXITCODE; Write-Host ''; "
     "Write-Host ('passata rc ' + $rc + '   (0 = misura AFFIDABILE; 3 = NON MISURATO, lo zip esce lo stesso; 1 = si e fermata prima del tester, il messaggio rosso dice dove)') -ForegroundColor Cyan; "
     "Write-Host ('durata totale minuti: ' + [int](((Get-Date)-$T0).TotalMinutes)) -ForegroundColor Cyan; "
     "Write-Host '" + fine + "' -ForegroundColor Gray }")
t.encode("ascii")
assert "\n" not in t and "\r" not in t
dest = os.path.join(REPO, "backtest_pipeline", "righe", "RIGA_LANCIA_R290A.txt")
if "--dest" in sys.argv:
    dest = sys.argv[sys.argv.index("--dest") + 1]
open(dest, "w", newline="").write(t)
print(len(t), "byte; SHA256 dello script", H, "; SHA256 della riga", hashlib.sha256(t.encode("ascii")).hexdigest().upper())
