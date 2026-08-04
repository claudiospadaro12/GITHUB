# =====================================================================
#  rilancia_indici_v2.ps1  --  OTTIMIZZA IN BATCH GLI EA "INDICI/ORB"
#                              con la DIREZIONE LONG/SHORT separata
# ---------------------------------------------------------------------
#  Stessa filosofia delle aperture v2: proviamo esplicitamente solo-long,
#  solo-short ed entrambe (+ Supertrend dove l'EA ce l'ha), in OHLC 1-min.
#
#  EA inclusi (6):
#    ABTG_ORB (NASUSD), ABTG_ORB_Fibo (NASUSD), ABTG_Nasdaq_Live5m (NASUSD),
#    ABTG_DAX_Live5m (D30EUR), ABTG_DAX_M3 (D30EUR), ABTG_Londra_ORB (GBPUSD)
#
#  NB: le due APERTURE (DAX/Nasdaq) hanno gia' il loro script dedicato
#      (rilancia_aperture_v2.ps1) perche' hanno anche slippage+floor.
#
#  Cosa fa da solo:
#    1. scarica da GitHub gli EA + gli .ini gia' pronti (niente Python)
#    2. trova il terminale BCM e la cartella dati
#    3. CONTROLLA che MT5 non sia gia' aperto (altrimenti 0 CSV)
#    4. copia+compila i 6 EA
#    5. cancella i vecchi OptResults di questi 6
#    6. lancia le 6 ottimizzazioni, una alla volta
#    7. raccoglie i CSV in .\risultati_indici_v2\
#
#  Come si lancia: vedi la riga in chat. Oppure, se hai gia' il file:
#      powershell -ExecutionPolicy Bypass -File rilancia_indici_v2.ps1
# =====================================================================
param(
    [switch]$UseSpare,   # usa il terminale -V3 (di scorta)
    [string]$Terminal   = "",
    [string]$MetaEditor = "",
    [string]$DataFolder = "",
    [switch]$Force       # prosegui anche se MT5 sembra gia' aperto
)

$ErrorActionPreference = "Stop"
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$Branch  = "lavoro"   # era un branch fermo dal 31/07: scaricava sorgenti VECCHI senza dare errore
$RawBase = "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$Branch"

# EA da ottimizzare: file + simbolo (per il nome del CSV di output)
$Targets = @(
    @{ file = "ABTG_ORB";            sym = "NASUSD" },
    @{ file = "ABTG_ORB_Fibo";       sym = "NASUSD" },
    @{ file = "ABTG_Nasdaq_Live5m";  sym = "NASUSD" },
    @{ file = "ABTG_DAX_Live5m";     sym = "D30EUR" },
    @{ file = "ABTG_DAX_M3";         sym = "D30EUR" },
    @{ file = "ABTG_Londra_ORB";     sym = "GBPUSD" }
)

$Work = if ($PSScriptRoot) { $PSScriptRoot } else { (Get-Location).Path }
Set-Location $Work
Write-Host "=== OTTIMIZZAZIONE INDICI/ORB v2 (direzione L/S, OHLC) ===" -ForegroundColor Cyan
Write-Host ("Cartella di lavoro: {0}" -f $Work)

# --- 1) scarico EA + .ini pronti da GitHub ---------------------------
Write-Host "`n[1/7] Scarico gli EA + .ini freschi da GitHub..." -ForegroundColor Yellow
New-Item -ItemType Directory -Force -Path (Join-Path $Work "src_v2"),(Join-Path $Work "ini") | Out-Null
$dl = @()
foreach ($t in $Targets) {
    $dl += @{ url = "$RawBase/mql5/Experts/$($t.file).mq5"; out = "src_v2\$($t.file).mq5" }
    $dl += @{ url = "$RawBase/backtest_pipeline/ini/$($t.file).ini"; out = "ini\$($t.file).ini" }
}
foreach ($d in $dl) {
    $dest = Join-Path $Work $d.out
    try {
        Invoke-WebRequest -Uri $d.url -OutFile $dest -UseBasicParsing
        Write-Host ("   OK  {0}" -f $d.out) -ForegroundColor Green
    } catch {
        Write-Host ("   ERRORE scaricando {0}`n       {1}" -f $d.url, $_.Exception.Message) -ForegroundColor Red
        exit 1
    }
}

# --- 2) trovo il terminale BCM e la cartella dati --------------------
Write-Host "`n[2/7] Cerco il terminale BCM..." -ForegroundColor Yellow
if (-not $Terminal) {
    $allTerm = Get-ChildItem "C:\Program Files","C:\Program Files (x86)" -Recurse -Filter "terminal64.exe" -ErrorAction SilentlyContinue
    if ($UseSpare) {
        $cand = $allTerm | Where-Object { $_.DirectoryName -like "*BCM Markets*" -and $_.DirectoryName -like "*-V3*" } | Select-Object -First 1
    } else {
        $cand = $allTerm | Where-Object { $_.DirectoryName -like "*BCM Markets MT5 Terminal*" -and $_.DirectoryName -notlike "*-V3*" } | Select-Object -First 1
    }
    if (-not $cand) { $cand = $allTerm | Where-Object { $_.DirectoryName -like "*BCM Markets*" } | Select-Object -First 1 }
    if ($cand) { $Terminal = $cand.FullName; $MetaEditor = Join-Path $cand.DirectoryName "metaeditor64.exe" }
}
if ($Terminal -and -not $DataFolder) {
    $instDir  = Split-Path -Parent $Terminal
    $termRoot = Join-Path $env:APPDATA "MetaQuotes\Terminal"
    if (Test-Path $termRoot) {
        $DataFolder = Get-ChildItem $termRoot -Directory -ErrorAction SilentlyContinue | Where-Object {
            $o = Join-Path $_.FullName "origin.txt"
            (Test-Path $o) -and ((Get-Content $o -Raw).Trim() -ieq $instDir)
        } | Select-Object -First 1 -ExpandProperty FullName
    }
}
Write-Host ("   Terminale : {0}" -f $Terminal)
Write-Host ("   MetaEditor: {0}" -f $MetaEditor)
Write-Host ("   Cartella dati: {0}" -f $DataFolder)
if (-not $Terminal   -or -not (Test-Path $Terminal))   { Write-Host "Terminale BCM non trovato. Passa -Terminal <percorso>." -ForegroundColor Red; exit 1 }
if (-not $MetaEditor -or -not (Test-Path $MetaEditor)) { Write-Host "metaeditor64.exe non trovato accanto al terminale." -ForegroundColor Red; exit 1 }
if (-not $DataFolder -or -not (Test-Path $DataFolder)) { Write-Host "Cartella dati non trovata. Passa -DataFolder <percorso>." -ForegroundColor Red; exit 1 }

$MqlExperts = Join-Path $DataFolder "MQL5\Experts"
$MqlFiles   = Join-Path $DataFolder "MQL5\Files"
$IniDir     = Join-Path $Work "ini"
$Results    = Join-Path $Work "risultati_indici_v2"
New-Item -ItemType Directory -Force -Path $MqlExperts,$Results | Out-Null

# --- 3) CONTROLLO: MT5 non deve essere gia' aperto -------------------
$running = Get-Process -Name "terminal64" -ErrorAction SilentlyContinue
if ($running) {
    Write-Host "`n!!! MetaTrader (terminal64.exe) e' GIA' APERTO." -ForegroundColor Red
    Write-Host "    MT5 non fa girare due tester insieme: i lanci verrebbero ignorati (0 CSV)." -ForegroundColor Red
    Write-Host "    -> Ferma ogni altra ottimizzazione e CHIUDI MetaTrader, poi rilancia." -ForegroundColor Yellow
    Write-Host "    (Con -Force proseguo comunque, a tuo rischio.)" -ForegroundColor DarkGray
    if (-not $Force) { exit 1 }
    Write-Host "    -Force attivo: proseguo comunque." -ForegroundColor DarkGray
}

# --- 4) copio + compilo i 6 EA --------------------------------------
Write-Host "`n[4/7] Copio e compilo i 6 EA..." -ForegroundColor Yellow
foreach ($t in $Targets) {
    $src = Join-Path $Work ("src_v2\{0}.mq5" -f $t.file)
    Copy-Item $src -Destination $MqlExperts -Force
    $dst = Join-Path $MqlExperts ("{0}.mq5" -f $t.file)
    & $MetaEditor "/compile:$dst" "/log" | Out-Null
    $ex5 = [System.IO.Path]::ChangeExtension($dst, ".ex5")
    if (Test-Path $ex5) { Write-Host ("   OK  {0}.ex5" -f $t.file) -ForegroundColor Green }
    else { Write-Host ("   ERRORE compilazione {0} (salto questo EA)" -f $t.file) -ForegroundColor Red }
}

# --- 5) cancello i vecchi OptResults di questi 6 --------------------
Write-Host "`n[5/7] Pulisco i vecchi risultati..." -ForegroundColor Yellow
foreach ($t in $Targets) {
    $csv = "OptResults_{0}_{1}.csv" -f $t.file, $t.sym
    $old = Join-Path $MqlFiles $csv
    if (Test-Path $old) { Remove-Item $old -Force; Write-Host ("   rimosso vecchio {0}" -f $csv) -ForegroundColor DarkGray }
}

# --- 6) lancio le ottimizzazioni, una alla volta -------------------
Write-Host "`n[6/7] Avvio le ottimizzazioni (una alla volta)..." -ForegroundColor Yellow
$n = 0
foreach ($t in $Targets) {
    $n++
    $ini = Join-Path $IniDir ("{0}.ini" -f $t.file)
    $ex5 = Join-Path $MqlExperts ("{0}.ex5" -f $t.file)
    if (-not (Test-Path $ini)) { Write-Host ("   [{0}/{1}] .ini mancante per {2}, salto" -f $n,$Targets.Count,$t.file) -ForegroundColor Red; continue }
    if (-not (Test-Path $ex5)) { Write-Host ("   [{0}/{1}] .ex5 mancante per {2}, salto" -f $n,$Targets.Count,$t.file) -ForegroundColor Red; continue }
    Write-Host ("   [{0}/{1}] Ottimizzo {2} ..." -f $n,$Targets.Count,$t.file) -ForegroundColor Cyan
    $proc = Start-Process -FilePath $Terminal -ArgumentList "/config:`"$ini`"" -PassThru
    $proc.WaitForExit()
    Write-Host "        fatto." -ForegroundColor Green
}

# --- 7) raccolgo i CSV ---------------------------------------------
Write-Host "`n[7/7] Raccolgo i risultati..." -ForegroundColor Yellow
$found = 0
foreach ($t in $Targets) {
    $csv = "OptResults_{0}_{1}.csv" -f $t.file, $t.sym
    $src = Join-Path $MqlFiles $csv
    if (Test-Path $src) { Copy-Item $src -Destination $Results -Force; $found++; Write-Host ("   OK  {0}" -f $csv) -ForegroundColor Green }
    else { Write-Host ("   (manca) {0}" -f $csv) -ForegroundColor Yellow }
}

Write-Host ("`n=== FINITO ({0}/{1} CSV) ===" -f $found,$Targets.Count) -ForegroundColor Cyan
Write-Host ("I CSV sono in:  {0}" -f $Results) -ForegroundColor White
Write-Host "Mandameli (comprimi la cartella) e faccio le valutazioni sulla direzione L/S." -ForegroundColor White
