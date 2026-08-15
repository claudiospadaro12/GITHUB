# =====================================================================
#  aggiorna_news.ps1  --  porta abtg_news.csv dentro MT5 (filtro news EA)
# ---------------------------------------------------------------------
#  Scarica il file news generato dall'agente (data/abtg_news.csv nel repo)
#  e lo copia in MQL5\Files del terminale BCM. Da schedulare ogni mattina
#  sul VPS (dopo il report). L'EA PostNews lo ricarica da solo ogni giorno.
# =====================================================================
$ErrorActionPreference = "Stop"
# ⚠️ IL BRANCH (corretto il 15/08/2026, dopo una pagella vuota)
#  Qui c'era "claude/creating-agents-SgGpD", il vecchio branch di default:
#  fermo al 31/07, con trades_auto.csv che si ferma al 24/07. La pagella
#  settimanale del 15/08 e' uscita con "Nessuno statement con trade nel
#  periodo" per QUESTO - non per un problema di export, di parser o di
#  MT5. Il lavoro sta tutto su `lavoro`.
$RawUrl = "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/lavoro/data/abtg_news.csv"

Write-Host "=== AGGIORNO abtg_news.csv IN MT5 ===" -ForegroundColor Cyan

# --- rileva il terminale BCM + la sua cartella dati ------------------
$allTerm = Get-ChildItem "C:\Program Files","C:\Program Files (x86)" -Recurse -Filter "terminal64.exe" -ErrorAction SilentlyContinue
$cand = $allTerm | Where-Object { $_.DirectoryName -like "*BCM Markets MT5 Terminal*" -and $_.DirectoryName -notlike "*-V3*" } | Select-Object -First 1
if (-not $cand) { $cand = $allTerm | Where-Object { $_.DirectoryName -like "*BCM Markets*" } | Select-Object -First 1 }
if (-not $cand) { Write-Host "Terminale BCM non trovato." -ForegroundColor Red; exit 1 }
$instDir = $cand.DirectoryName
$termRoot = Join-Path $env:APPDATA "MetaQuotes\Terminal"
$DataFolder = Get-ChildItem $termRoot -Directory -ErrorAction SilentlyContinue | Where-Object {
    $o = Join-Path $_.FullName "origin.txt"
    (Test-Path $o) -and ((Get-Content $o -Raw).Trim() -ieq $instDir)
} | Select-Object -First 1 -ExpandProperty FullName
if (-not $DataFolder) { Write-Host "Cartella dati non trovata." -ForegroundColor Red; exit 1 }

$FilesDir = Join-Path $DataFolder "MQL5\Files"
New-Item -ItemType Directory -Force -Path $FilesDir | Out-Null
$Dest = Join-Path $FilesDir "abtg_news.csv"

# --- scarica il file (con retry) -------------------------------------
$ok = $false
for ($i=1; $i -le 4 -and -not $ok; $i++) {
    try {
        Invoke-WebRequest -Uri $RawUrl -OutFile $Dest -UseBasicParsing -TimeoutSec 30
        $ok = $true
    } catch {
        Write-Host "   tentativo $i fallito, riprovo..." -ForegroundColor Yellow
        Start-Sleep -Seconds ([math]::Pow(2,$i))
    }
}
if (-not $ok) { Write-Host "Download fallito." -ForegroundColor Red; exit 1 }

$n = (Get-Content $Dest | Measure-Object -Line).Lines
Write-Host "OK: abtg_news.csv aggiornato ($n eventi) in:" -ForegroundColor Green
Write-Host "   $Dest"
Write-Host "L'EA PostNews lo ricaricera' automaticamente." -ForegroundColor White
