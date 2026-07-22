# =====================================================================
#  scarica_storico.ps1  --  installa lo script SCARICA-STORICO in MT5
# ---------------------------------------------------------------------
#  Copia e compila ABTG_HistoryDownloader dentro il tuo MT5 BCM.
#  Dopo averlo lanciato: apri MT5, vai su "Navigatore > Script",
#  trascina "ABTG_HistoryDownloader" su un grafico qualsiasi e premi OK.
#  (MT5 puo' restare aperto: la compilazione non lo disturba.)
# =====================================================================
$ErrorActionPreference = "Stop"
$RepoRoot = Split-Path -Parent $MyInvocation.MyCommand.Path

Write-Host "=== INSTALLO LO SCARICA-STORICO ===" -ForegroundColor Cyan

# --- rileva terminale BCM + cartella dati (come run_all.ps1) ---------
$allTerm = Get-ChildItem "C:\Program Files","C:\Program Files (x86)" -Recurse -Filter "terminal64.exe" -ErrorAction SilentlyContinue
$cand = $allTerm | Where-Object { $_.DirectoryName -like "*BCM Markets MT5 Terminal*" -and $_.DirectoryName -notlike "*-V3*" } | Select-Object -First 1
if (-not $cand) { $cand = $allTerm | Where-Object { $_.DirectoryName -like "*BCM Markets*" } | Select-Object -First 1 }
if (-not $cand) { Write-Host "Terminale BCM non trovato." -ForegroundColor Red; exit 1 }
$MetaEditor = Join-Path $cand.DirectoryName "metaeditor64.exe"
$instDir    = $cand.DirectoryName

$termRoot = Join-Path $env:APPDATA "MetaQuotes\Terminal"
$DataFolder = Get-ChildItem $termRoot -Directory -ErrorAction SilentlyContinue | Where-Object {
    $o = Join-Path $_.FullName "origin.txt"
    (Test-Path $o) -and ((Get-Content $o -Raw).Trim() -ieq $instDir)
} | Select-Object -First 1 -ExpandProperty FullName
if (-not $DataFolder) { Write-Host "Cartella dati non trovata." -ForegroundColor Red; exit 1 }

Write-Host ("MetaEditor : {0}" -f $MetaEditor)
Write-Host ("Cartella dati: {0}" -f $DataFolder)

# --- copia + compila lo script ---------------------------------------
$src = Join-Path $RepoRoot "..\mql5\Scripts\ABTG_HistoryDownloader.mq5"
if (-not (Test-Path $src)) { Write-Host "Non trovo ABTG_HistoryDownloader.mq5 nel repo." -ForegroundColor Red; exit 1 }
$MqlScripts = Join-Path $DataFolder "MQL5\Scripts"
New-Item -ItemType Directory -Force -Path $MqlScripts | Out-Null
Copy-Item $src -Destination $MqlScripts -Force
$dst = Join-Path $MqlScripts "ABTG_HistoryDownloader.mq5"
& $MetaEditor "/compile:$dst" "/log" | Out-Null
$ex5 = [System.IO.Path]::ChangeExtension($dst, ".ex5")

if (Test-Path $ex5) {
    Write-Host "`nOK! Script installato e compilato." -ForegroundColor Green
    Write-Host "Ora: apri MT5 > Navigatore > Script > trascina 'ABTG_HistoryDownloader' su un grafico." -ForegroundColor White
    Write-Host "  - 1a volta: InpListaSoloNomi = true  (ti crea l'elenco dei simboli)" -ForegroundColor White
    Write-Host "  - poi:      InpListaSoloNomi = false (scarica davvero tutto lo storico)" -ForegroundColor White
} else {
    Write-Host "Compilazione non riuscita. Fammi uno screenshot." -ForegroundColor Red
}
