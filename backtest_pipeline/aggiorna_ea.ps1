# =====================================================================
#  aggiorna_ea.ps1  --  aggiorna e RICOMPILA gli EA in MT5 (no ottimizz.)
# ---------------------------------------------------------------------
#  Copia i sorgenti .mq5 aggiornati del repo nel terminale BCM e li
#  ricompila. ATTENZIONE (imparato l'08/08): la ricompilazione SCARICA
#  gli EA dai grafici e NON li ricarica -> dopo, RIAVVIARE MetaTrader.
#
#  USO:
#    .\aggiorna_ea.ps1              -> aggiorna TUTTI gli EA
#    .\aggiorna_ea.ps1 PostNews     -> aggiorna SOLO gli EA il cui nome
#                                       contiene "PostNews" (consigliato
#                                       sul VPS a mercato aperto: tocca
#                                       solo quello, non disturba gli altri)
# =====================================================================
param([string]$Only = "")
$ErrorActionPreference = "Stop"
$RepoRoot = Split-Path -Parent $MyInvocation.MyCommand.Path

Write-Host "=== AGGIORNO E RICOMPILO GLI EA ===" -ForegroundColor Cyan

# --- rileva terminale BCM + cartella dati ----------------------------
$allTerm = Get-ChildItem "C:\Program Files","C:\Program Files (x86)" -Recurse -Filter "terminal64.exe" -ErrorAction SilentlyContinue
$cand = $allTerm | Where-Object { $_.DirectoryName -like "*BCM Markets MT5 Terminal*" -and $_.DirectoryName -notlike "*-V3*" } | Select-Object -First 1
if (-not $cand) { $cand = $allTerm | Where-Object { $_.DirectoryName -like "*BCM Markets*" } | Select-Object -First 1 }
if (-not $cand) { Write-Host "Terminale BCM non trovato." -ForegroundColor Red; exit 1 }
$MetaEditor = Join-Path $cand.DirectoryName "metaeditor64.exe"
$instDir = $cand.DirectoryName
$termRoot = Join-Path $env:APPDATA "MetaQuotes\Terminal"
$DataFolder = Get-ChildItem $termRoot -Directory -ErrorAction SilentlyContinue | Where-Object {
    $o = Join-Path $_.FullName "origin.txt"
    (Test-Path $o) -and ((Get-Content $o -Raw).Trim() -ieq $instDir)
} | Select-Object -First 1 -ExpandProperty FullName
if (-not $DataFolder) { Write-Host "Cartella dati non trovata." -ForegroundColor Red; exit 1 }

$ExpertsSrc = Join-Path $RepoRoot "..\mql5\Experts"
$MqlExperts = Join-Path $DataFolder "MQL5\Experts"
New-Item -ItemType Directory -Force -Path $MqlExperts | Out-Null

if (Test-Path $ExpertsSrc) {
  # PC col repo clonato: si copia da li'.
  $eaFiles = Get-ChildItem -Path $ExpertsSrc -Filter "ABTG_*.mq5"
  if ($Only) { $eaFiles = $eaFiles | Where-Object { $_.Name -like "*$Only*" } }
  if (-not $eaFiles) { Write-Host "Nessun EA corrisponde a '$Only'." -ForegroundColor Red; exit 1 }
  foreach ($f in $eaFiles) { Copy-Item $f.FullName -Destination $MqlExperts -Force }
} else {
  # 09/08: VPS, niente repo clonato -> si scarica dal repo il SOLO EA chiesto.
  #  Serve il NOME ESATTO (cosi' non si toccano i fratelli con nomi simili:
  #  "SupertrendReversal" da solo prenderebbe anche _Multi e _Ottimizzato).
  if (-not $Only) {
    Write-Host "Qui non c'e' il repo clonato: serve il nome esatto dell'EA." -ForegroundColor Red
    Write-Host "  Esempio:  .\aggiorna_ea.ps1 ABTG_SupertrendReversal" -ForegroundColor Yellow
    exit 1
  }
  [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
  $nome = $Only -replace '\.mq5$',''
  if ($nome -notlike "ABTG_*") { $nome = "ABTG_" + $nome }
  $dest = Join-Path $MqlExperts "$nome.mq5"
  try {
    Invoke-WebRequest -Uri "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/lavoro/mql5/Experts/$nome.mq5" -OutFile $dest -UseBasicParsing
  } catch {
    Write-Host "Download fallito per '$nome.mq5': nome esatto? rete?" -ForegroundColor Red; exit 1
  }
  $eaFiles = @(Get-Item $dest)
  Write-Host "Scaricato dal repo: $nome.mq5" -ForegroundColor Green
}
Write-Host "Copiati $($eaFiles.Count) EA. Compilo..." -ForegroundColor Yellow
foreach ($f in $eaFiles) {
    $src = Join-Path $MqlExperts $f.Name
    & $MetaEditor "/compile:$src" "/log" | Out-Null
    $ex5 = [System.IO.Path]::ChangeExtension($src, ".ex5")
    if (Test-Path $ex5) { Write-Host "   OK  $($f.Name)" -ForegroundColor Green }
    else { Write-Host "   ERRORE $($f.Name)" -ForegroundColor Red }
}
Write-Host ""
#  08/08: FALSO che si ricarichino da soli. La compilazione da riga di
#  comando fa 'removed' dell'EA dal grafico e NON lo ricarica: l'EA torna
#  solo al riavvio del terminale (Giornale: removed 14:16:41, loaded
#  14:19:54 - tre minuti SENZA EA, e nessuno se n'era accorto).
Write-Host "!!! ORA RIAVVIA METATRADER: la ricompilazione SCARICA gli EA dai grafici" -ForegroundColor Red
Write-Host "    e NON li ricarica da sola. Tornano su solo al riavvio del terminale." -ForegroundColor Red
