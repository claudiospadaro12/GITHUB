# =====================================================================
#  aggiorna_ea.ps1  --  aggiorna e RICOMPILA gli EA in MT5 (no ottimizz.)
# ---------------------------------------------------------------------
#  Copia i sorgenti .mq5 aggiornati del repo nel terminale BCM e li
#  ricompila. Gli EA gia' attaccati ai grafici si ricaricano da soli
#  (MT5 ricarica l'.ex5 dopo la ricompilazione). NON lancia backtest.
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

$eaFiles = Get-ChildItem -Path $ExpertsSrc -Filter "ABTG_*.mq5"
if ($Only) { $eaFiles = $eaFiles | Where-Object { $_.Name -like "*$Only*" } }
if (-not $eaFiles) { Write-Host "Nessun EA corrisponde a '$Only'." -ForegroundColor Red; exit 1 }
foreach ($f in $eaFiles) { Copy-Item $f.FullName -Destination $MqlExperts -Force }
Write-Host "Copiati $($eaFiles.Count) EA. Compilo..." -ForegroundColor Yellow
foreach ($f in $eaFiles) {
    $src = Join-Path $MqlExperts $f.Name
    & $MetaEditor "/compile:$src" "/log" | Out-Null
    $ex5 = [System.IO.Path]::ChangeExtension($src, ".ex5")
    if (Test-Path $ex5) { Write-Host "   OK  $($f.Name)" -ForegroundColor Green }
    else { Write-Host "   ERRORE $($f.Name)" -ForegroundColor Red }
}
Write-Host "`nFatto. Gli EA sui grafici si ricaricano da soli." -ForegroundColor Cyan
