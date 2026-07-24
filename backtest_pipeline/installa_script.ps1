# =====================================================================
#  installa_script.ps1  --  installa e compila TUTTI gli script ABTG
# ---------------------------------------------------------------------
#  Copia mql5\Scripts\ABTG_*.mq5 nel terminale BCM e li compila, cosi'
#  compaiono in "Navigatore > Script" pronti da trascinare su un grafico.
#  (scarica-storico, studio NFP, ecc.). MT5 puo' restare aperto.
# =====================================================================
$ErrorActionPreference = "Stop"
$RepoRoot = Split-Path -Parent $MyInvocation.MyCommand.Path

Write-Host "=== INSTALLO GLI SCRIPT ABTG ===" -ForegroundColor Cyan

# rileva terminale BCM + cartella dati
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

# installa sia gli Script sia gli Indicatori ABTG
$folders = @(
    @{ src = "..\mql5\Scripts";     dst = "MQL5\Scripts";     nome = "Script" },
    @{ src = "..\mql5\Indicators";  dst = "MQL5\Indicators";  nome = "Indicatori" }
)
$tot = 0
foreach ($fo in $folders) {
    $Src = Join-Path $RepoRoot $fo.src
    if (-not (Test-Path $Src)) { continue }
    $Dst = Join-Path $DataFolder $fo.dst
    New-Item -ItemType Directory -Force -Path $Dst | Out-Null
    $files = Get-ChildItem -Path $Src -Filter "ABTG_*.mq5" -ErrorAction SilentlyContinue
    if (-not $files) { continue }
    Write-Host "`n[$($fo.nome)]" -ForegroundColor Yellow
    foreach ($f in $files) {
        Copy-Item $f.FullName -Destination $Dst -Force
        $s = Join-Path $Dst $f.Name
        & $MetaEditor "/compile:$s" "/log" | Out-Null
        $ex5 = [System.IO.Path]::ChangeExtension($s, ".ex5")
        if (Test-Path $ex5) { Write-Host "   OK  $($f.Name)" -ForegroundColor Green; $tot++ }
        else { Write-Host "   ERRORE $($f.Name)" -ForegroundColor Red }
    }
}
Write-Host "`nFatto ($tot compilati). In MT5: Navigatore > Script / Indicatori (tasto destro > Aggiorna)." -ForegroundColor Cyan
