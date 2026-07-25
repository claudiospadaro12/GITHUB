# =====================================================================
#  scarica_ottimizzati.ps1  --  scarica e compila gli EA _Ottimizzato
#                               nella cartella MQL5\Experts di BCM
# ---------------------------------------------------------------------
#  Mette gli EA _Ottimizzato accanto agli originali (magic diversi:
#  girano in PARALLELO senza pestarsi). Poi li trovi in MetaTrader tra
#  gli Expert Advisors, pronti da trascinare sul grafico.
#
#  Lancialo con la riga in chat, oppure:
#      powershell -ExecutionPolicy Bypass -File scarica_ottimizzati.ps1
# =====================================================================
param(
    [switch]$UseSpare,
    [string]$Terminal   = "",
    [string]$MetaEditor = "",
    [string]$DataFolder = ""
)
$ErrorActionPreference = "Stop"
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$Branch  = "claude/creating-agents-SgGpD"
$RawBase = "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$Branch/mql5/Experts"

# EA da installare (i due _Ottimizzato delle aperture)
$EAs = @(
    "ABTG_Nasdaq_Apertura_US_Ottimizzato",
    "ABTG_DAX_Apertura_EU_Ottimizzato"
)

Write-Host "=== INSTALLO GLI EA _OTTIMIZZATO ===" -ForegroundColor Cyan

# --- trova terminale + cartella dati --------------------------------
if (-not $Terminal) {
    $allTerm = Get-ChildItem "C:\Program Files","C:\Program Files (x86)" -Recurse -Filter "terminal64.exe" -ErrorAction SilentlyContinue
    if ($UseSpare) { $cand = $allTerm | Where-Object { $_.DirectoryName -like "*BCM Markets*" -and $_.DirectoryName -like "*-V3*" } | Select-Object -First 1 }
    else           { $cand = $allTerm | Where-Object { $_.DirectoryName -like "*BCM Markets MT5 Terminal*" -and $_.DirectoryName -notlike "*-V3*" } | Select-Object -First 1 }
    if (-not $cand) { $cand = $allTerm | Where-Object { $_.DirectoryName -like "*BCM Markets*" } | Select-Object -First 1 }
    if ($cand) { $Terminal = $cand.FullName; $MetaEditor = Join-Path $cand.DirectoryName "metaeditor64.exe" }
}
if ($Terminal -and -not $DataFolder) {
    $instDir = Split-Path -Parent $Terminal
    $termRoot = Join-Path $env:APPDATA "MetaQuotes\Terminal"
    if (Test-Path $termRoot) {
        $DataFolder = Get-ChildItem $termRoot -Directory -ErrorAction SilentlyContinue | Where-Object {
            $o = Join-Path $_.FullName "origin.txt"; (Test-Path $o) -and ((Get-Content $o -Raw).Trim() -ieq $instDir)
        } | Select-Object -First 1 -ExpandProperty FullName
    }
}
if (-not $DataFolder -or -not (Test-Path $DataFolder)) { Write-Host "Cartella dati BCM non trovata. Passa -DataFolder <percorso>." -ForegroundColor Red; exit 1 }
$MqlExperts = Join-Path $DataFolder "MQL5\Experts"
New-Item -ItemType Directory -Force -Path $MqlExperts | Out-Null
Write-Host ("Experts: {0}" -f $MqlExperts)

foreach ($ea in $EAs) {
    $dst = Join-Path $MqlExperts "$ea.mq5"
    try { Invoke-WebRequest -Uri "$RawBase/$ea.mq5" -OutFile $dst -UseBasicParsing; Write-Host ("   scaricato {0}.mq5" -f $ea) -ForegroundColor Green }
    catch { Write-Host ("   ERRORE download {0}: {1}" -f $ea,$_.Exception.Message) -ForegroundColor Red; continue }
    if ($MetaEditor -and (Test-Path $MetaEditor)) {
        & $MetaEditor "/compile:$dst" "/log" | Out-Null
        if (Test-Path ([System.IO.Path]::ChangeExtension($dst, ".ex5"))) { Write-Host ("   compilato  {0}.ex5" -f $ea) -ForegroundColor Green }
        else { Write-Host ("   (compila a mano con F7: {0})" -f $ea) -ForegroundColor Yellow }
    }
}

Write-Host "`n=== FATTO ===" -ForegroundColor Cyan
Write-Host "In MetaTrader: se non li vedi subito, tasto destro su 'Expert Advisors' > Aggiorna." -ForegroundColor White
Write-Host "Trascina ogni _Ottimizzato sul grafico giusto (D30EUR / NASUSD, M5), AutoTrading ON." -ForegroundColor White
