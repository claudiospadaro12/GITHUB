# =====================================================================
#  rilancia_validazione_aperture.ps1  --  VALIDAZIONE REAL-TICK
#  delle 2 APERTURE (DAX/Nasdaq) + ORB, coi parametri robusti/vincenti.
# ---------------------------------------------------------------------
#  Dopo che i Live5m sono crollati in real tick (OHLC bugiardo), qui
#  mettiamo alla prova le due aperture e ORB in REAL TICK, rischio 1%:
#    - DAX Apertura : ENTRAMBE + Supertrend ON, floor 200, slippage 100
#    - Nasdaq Apert.: SOLO LONG, floor 0/200/400, slippage 100
#    - ORB          : ENTRAMBE, EntryPoints/TP_R robusti
#
#  ATTENZIONE: real tick = LENTO (ma le aperture fanno 1 trade/giorno,
#  quindi molto piu' veloci dei Live5m). NON tenere MT5 aperto.
#  Risultati in .\risultati_validazione_aperture\ (valid_*).
# =====================================================================
param(
    [switch]$UseSpare,
    [string]$Terminal   = "",
    [string]$MetaEditor = "",
    [string]$DataFolder = "",
    [switch]$Force
)
$ErrorActionPreference = "Stop"
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$Branch  = "lavoro"   # era un branch fermo dal 31/07: scaricava sorgenti VECCHI senza dare errore
$RawBase = "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$Branch"

$Targets = @(
    @{ ea = "ABTG_DAX_Apertura_EU";    ini = "valid_DAX_Apertura";    sym = "D30EUR" },
    @{ ea = "ABTG_Nasdaq_Apertura_US"; ini = "valid_Nasdaq_Apertura"; sym = "NASUSD" },
    @{ ea = "ABTG_ORB";                ini = "valid_ORB";             sym = "NASUSD" },
    @{ ea = "ABTG_DAX_Live5m_v2";      ini = "valid_DAX_Live5m_v2";   sym = "D30EUR" }
)

$Work = if ($PSScriptRoot) { $PSScriptRoot } else { (Get-Location).Path }
Set-Location $Work
Write-Host "=== VALIDAZIONE REAL-TICK APERTURE + ORB (rischio 1%) ===" -ForegroundColor Cyan

# --- 1) scarico EA + .ini -------------------------------------------
Write-Host "`n[1/7] Scarico EA + .ini di validazione..." -ForegroundColor Yellow
New-Item -ItemType Directory -Force -Path (Join-Path $Work "src_v2"),(Join-Path $Work "ini") | Out-Null
$dl = @()
foreach ($t in $Targets) {
    $dl += @{ url = "$RawBase/mql5/Experts/$($t.ea).mq5"; out = "src_v2\$($t.ea).mq5" }
    $dl += @{ url = "$RawBase/backtest_pipeline/ini/$($t.ini).ini"; out = "ini\$($t.ini).ini" }
}
foreach ($d in $dl) {
    $dest = Join-Path $Work $d.out
    try { Invoke-WebRequest -Uri $d.url -OutFile $dest -UseBasicParsing; Write-Host ("   OK  {0}" -f $d.out) -ForegroundColor Green }
    catch { Write-Host ("   ERRORE scaricando {0}`n       {1}" -f $d.url, $_.Exception.Message) -ForegroundColor Red; exit 1 }
}

# --- 2) trovo terminale + cartella dati -----------------------------
Write-Host "`n[2/7] Cerco il terminale BCM..." -ForegroundColor Yellow
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
Write-Host ("   Terminale : {0}" -f $Terminal)
Write-Host ("   Cartella dati: {0}" -f $DataFolder)
if (-not $Terminal   -or -not (Test-Path $Terminal))   { Write-Host "Terminale BCM non trovato. Passa -Terminal <percorso>." -ForegroundColor Red; exit 1 }
if (-not $MetaEditor -or -not (Test-Path $MetaEditor)) { Write-Host "metaeditor64.exe non trovato." -ForegroundColor Red; exit 1 }
if (-not $DataFolder -or -not (Test-Path $DataFolder)) { Write-Host "Cartella dati non trovata. Passa -DataFolder <percorso>." -ForegroundColor Red; exit 1 }

$MqlExperts = Join-Path $DataFolder "MQL5\Experts"
$MqlFiles   = Join-Path $DataFolder "MQL5\Files"
$IniDir     = Join-Path $Work "ini"
$Results    = Join-Path $Work "risultati_validazione_aperture"
New-Item -ItemType Directory -Force -Path $MqlExperts,$Results | Out-Null

# --- 3) MT5 non deve essere aperto ----------------------------------
$running = Get-Process -Name "terminal64" -ErrorAction SilentlyContinue
if ($running) {
    Write-Host "`n!!! MetaTrader e' GIA' APERTO: chiudilo (i lanci verrebbero ignorati = 0 CSV)." -ForegroundColor Red
    if (-not $Force) { exit 1 }
    Write-Host "    -Force attivo: proseguo comunque." -ForegroundColor DarkGray
}

# --- 4) compilo -----------------------------------------------------
Write-Host "`n[4/7] Compilo gli EA..." -ForegroundColor Yellow
foreach ($t in $Targets) {
    $src = Join-Path $Work ("src_v2\{0}.mq5" -f $t.ea)
    Copy-Item $src -Destination $MqlExperts -Force
    $dst = Join-Path $MqlExperts ("{0}.mq5" -f $t.ea)
    & $MetaEditor "/compile:$dst" "/log" | Out-Null
    if (Test-Path ([System.IO.Path]::ChangeExtension($dst, ".ex5"))) { Write-Host ("   OK  {0}.ex5" -f $t.ea) -ForegroundColor Green }
    else { Write-Host ("   ERRORE compilazione {0}" -f $t.ea) -ForegroundColor Red; exit 1 }
}

# --- 5) pulisco i vecchi OptResults ---------------------------------
Write-Host "`n[5/7] Pulisco i vecchi risultati..." -ForegroundColor Yellow
foreach ($t in $Targets) {
    $old = Join-Path $MqlFiles ("OptResults_{0}_{1}.csv" -f $t.ea, $t.sym)
    if (Test-Path $old) { Remove-Item $old -Force; Write-Host ("   rimosso {0}" -f (Split-Path $old -Leaf)) -ForegroundColor DarkGray }
}

# --- 6) lancio le validazioni (REAL TICK) ---------------------------
Write-Host "`n[6/7] Avvio le validazioni real-tick (una alla volta)..." -ForegroundColor Yellow
$n=0
foreach ($t in $Targets) {
    $n++
    $ini = Join-Path $IniDir ("{0}.ini" -f $t.ini)
    if (-not (Test-Path $ini)) { Write-Host ("   [{0}/{1}] .ini mancante {2}, salto" -f $n,$Targets.Count,$t.ini) -ForegroundColor Red; continue }
    Write-Host ("   [{0}/{1}] Valido {2} (real tick)..." -f $n,$Targets.Count,$t.ea) -ForegroundColor Cyan
    $proc = Start-Process -FilePath $Terminal -ArgumentList "/config:`"$ini`"" -PassThru
    $proc.WaitForExit()
    Write-Host "        fatto." -ForegroundColor Green
}

# --- 7) raccolgo i CSV ----------------------------------------------
Write-Host "`n[7/7] Raccolgo i risultati..." -ForegroundColor Yellow
$found=0
foreach ($t in $Targets) {
    $src = Join-Path $MqlFiles ("OptResults_{0}_{1}.csv" -f $t.ea, $t.sym)
    $dst = Join-Path $Results ("valid_{0}_{1}.csv" -f $t.ea, $t.sym)
    if (Test-Path $src) { Copy-Item $src -Destination $dst -Force; $found++; Write-Host ("   OK  valid_{0}_{1}.csv" -f $t.ea,$t.sym) -ForegroundColor Green }
    else { Write-Host ("   (manca) {0}" -f (Split-Path $src -Leaf)) -ForegroundColor Yellow }
}

Write-Host ("`n=== FINITO ({0}/{1} CSV) ===" -f $found,$Targets.Count) -ForegroundColor Cyan
Write-Host ("I CSV real-tick sono in:  {0}" -f $Results) -ForegroundColor White
Write-Host "Mandameli: ti do il verdetto VERO su aperture + ORB." -ForegroundColor White
