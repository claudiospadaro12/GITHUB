# =====================================================================
#  rilancia_aperture_v2.ps1  --  RI-OTTIMIZZA SOLO LE DUE APERTURE (v2)
# ---------------------------------------------------------------------
#  Perche' esiste:
#    I CSV "aperture" che mi hai mandato erano stati prodotti con la
#    CONFIG VECCHIA: InpUseSupertrend fisso a 0 e NIENTE floor/slippage.
#    Quindi gli accorgimenti del tuo amico (floor SL = spread+slippage+
#    cuscinetto, SKIP se troppo stretto, filtro direzione LONG/SHORT)
#    NON erano mai stati testati. Questo script scarica la versione v2
#    FRESCA e rilancia SOLO DAX e Nasdaq aperture, con quei parametri.
#
#  Cosa fa da solo:
#    1. scarica da GitHub gli EA v2 + ea_config.json + gen_ini.py
#    2. trova il terminale BCM e la sua cartella dati
#    3. copia+compila SOLO i due EA aperture
#    4. genera gli .ini v2 (floor + direzione + slippage nella griglia)
#    5. cancella i vecchi OptResults delle due aperture (giro pulito)
#    6. lancia le DUE ottimizzazioni, una alla volta
#    7. raccoglie i due CSV in .\risultati_aperture_v2\
#
#  Come si lancia (una riga sola, vedi la chat). Oppure, se hai gia'
#  il file:  powershell -ExecutionPolicy Bypass -File rilancia_aperture_v2.ps1
# =====================================================================
param(
    [switch]$UseSpare,   # usa il terminale -V3 (di scorta) invece del principale
    [string]$Terminal   = "",
    [string]$MetaEditor = "",
    [string]$DataFolder = "",
    [string]$Python     = "python",
    [switch]$Force       # prosegui anche se MT5 sembra gia' aperto
)

$ErrorActionPreference = "Stop"
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$Branch  = "lavoro"   # era un branch fermo dal 31/07: scaricava sorgenti VECCHI senza dare errore
$RawBase = "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$Branch"

# i due (soli) EA che ci interessano
$Targets = @(
    @{ file = "ABTG_DAX_Apertura_EU";    csv = "OptResults_ABTG_DAX_Apertura_EU_D30EUR.csv" },
    @{ file = "ABTG_Nasdaq_Apertura_US"; csv = "OptResults_ABTG_Nasdaq_Apertura_US_NASUSD.csv" }
)

# cartella di lavoro = dove sta questo script (o la cartella corrente)
$Work = if ($PSScriptRoot) { $PSScriptRoot } else { (Get-Location).Path }
Set-Location $Work
Write-Host "=== RI-OTTIMIZZAZIONE APERTURE v2 ===" -ForegroundColor Cyan
Write-Host ("Cartella di lavoro: {0}" -f $Work)

# --- 1) scarico i file freschi da GitHub -----------------------------
Write-Host "`n[1/7] Scarico gli EA v2 + config freschi da GitHub..." -ForegroundColor Yellow
New-Item -ItemType Directory -Force -Path (Join-Path $Work "src_v2") | Out-Null
New-Item -ItemType Directory -Force -Path (Join-Path $Work "ini") | Out-Null
$dl = @(
    @{ url = "$RawBase/mql5/Experts/ABTG_DAX_Apertura_EU.mq5";        out = "src_v2\ABTG_DAX_Apertura_EU.mq5" },
    @{ url = "$RawBase/mql5/Experts/ABTG_Nasdaq_Apertura_US.mq5";     out = "src_v2\ABTG_Nasdaq_Apertura_US.mq5" },
    @{ url = "$RawBase/backtest_pipeline/ini/ABTG_DAX_Apertura_EU.ini";    out = "ini\ABTG_DAX_Apertura_EU.ini" },
    @{ url = "$RawBase/backtest_pipeline/ini/ABTG_Nasdaq_Apertura_US.ini"; out = "ini\ABTG_Nasdaq_Apertura_US.ini" }
)
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
$Results    = Join-Path $Work "risultati_aperture_v2"
New-Item -ItemType Directory -Force -Path $MqlExperts,$Results | Out-Null

# --- CONTROLLO DI SICUREZZA: MT5 non deve essere gia' aperto ---------
# MetaTrader NON puo' far girare due Strategy Tester insieme sullo stesso
# terminale: se e' gia' aperto (es. un'altra ottimizzazione tipo run_all.ps1
# o il terminale live), i lanci /config vengono IGNORATI e otterresti 0 CSV.
$running = Get-Process -Name "terminal64" -ErrorAction SilentlyContinue
if ($running) {
    Write-Host "`n!!! MetaTrader (terminal64.exe) e' GIA' APERTO." -ForegroundColor Red
    Write-Host "    Non posso lanciare le ottimizzazioni: MT5 non fa girare due tester insieme," -ForegroundColor Red
    Write-Host "    quindi i lanci verrebbero ignorati (0 CSV, come e' successo prima)." -ForegroundColor Red
    Write-Host "    -> Ferma l'altra ottimizzazione (Ctrl+C su run_all.ps1) e CHIUDI MetaTrader," -ForegroundColor Yellow
    Write-Host "       poi rilancia questo script." -ForegroundColor Yellow
    Write-Host "    (Se sei sicuro che nessun tester stia girando, puoi forzare con -Force.)" -ForegroundColor DarkGray
    if (-not $Force) { exit 1 }
    Write-Host "    -Force attivo: proseguo comunque (a tuo rischio)." -ForegroundColor DarkGray
}

# --- 3) copio + compilo SOLO i due EA aperture -----------------------
Write-Host "`n[3/7] Copio e compilo i due EA aperture..." -ForegroundColor Yellow
foreach ($t in $Targets) {
    $src = Join-Path $Work ("src_v2\{0}.mq5" -f $t.file)
    Copy-Item $src -Destination $MqlExperts -Force
    $dst = Join-Path $MqlExperts ("{0}.mq5" -f $t.file)
    & $MetaEditor "/compile:$dst" "/log" | Out-Null
    $ex5 = [System.IO.Path]::ChangeExtension($dst, ".ex5")
    if (Test-Path $ex5) { Write-Host ("   OK  {0}.ex5" -f $t.file) -ForegroundColor Green }
    else { Write-Host ("   ERRORE compilazione {0} (mi fermo)" -f $t.file) -ForegroundColor Red; exit 1 }
}

# --- 4) verifico gli .ini v2 (gia' scaricati pronti, NIENTE Python) --
Write-Host "`n[4/7] Verifico gli .ini v2 (gia' pronti, niente Python)..." -ForegroundColor Yellow
foreach ($t in $Targets) {
    $ini = Join-Path $IniDir ("{0}.ini" -f $t.file)
    if (Test-Path $ini) { Write-Host ("   OK  {0}.ini" -f $t.file) -ForegroundColor Green }
    else { Write-Host ("   ERRORE: manca {0}.ini (download fallito?)" -f $t.file) -ForegroundColor Red; exit 1 }
}

# --- 5) cancello i vecchi OptResults delle due aperture --------------
Write-Host "`n[5/7] Pulisco i vecchi risultati delle aperture..." -ForegroundColor Yellow
foreach ($t in $Targets) {
    $old = Join-Path $MqlFiles $t.csv
    if (Test-Path $old) { Remove-Item $old -Force; Write-Host ("   rimosso vecchio {0}" -f $t.csv) -ForegroundColor DarkGray }
}

# --- 6) lancio le DUE ottimizzazioni, una alla volta -----------------
Write-Host "`n[6/7] Avvio le ottimizzazioni (una alla volta)..." -ForegroundColor Yellow
$n = 0
foreach ($t in $Targets) {
    $n++
    $ini = Join-Path $IniDir ("{0}.ini" -f $t.file)
    if (-not (Test-Path $ini)) { Write-Host ("   [{0}/2] .ini mancante per {1}, salto" -f $n,$t.file) -ForegroundColor Red; continue }
    Write-Host ("   [{0}/2] Ottimizzo {1} ..." -f $n,$t.file) -ForegroundColor Cyan
    $proc = Start-Process -FilePath $Terminal -ArgumentList "/config:`"$ini`"" -PassThru
    $proc.WaitForExit()
    Write-Host "        fatto." -ForegroundColor Green
}

# --- 7) raccolgo i due CSV -------------------------------------------
Write-Host "`n[7/7] Raccolgo i risultati..." -ForegroundColor Yellow
$found = 0
foreach ($t in $Targets) {
    $csv = Join-Path $MqlFiles $t.csv
    if (Test-Path $csv) { Copy-Item $csv -Destination $Results -Force; $found++; Write-Host ("   OK  {0}" -f $t.csv) -ForegroundColor Green }
    else { Write-Host ("   (manca) {0} -- l'ottimizzazione non ha prodotto risultati?" -f $t.csv) -ForegroundColor Yellow }
}

Write-Host "`n=== FINITO ($found/2 CSV) ===" -ForegroundColor Cyan
Write-Host ("I due CSV sono in:  {0}" -f $Results) -ForegroundColor White
Write-Host "Mandameli e faccio le valutazioni sulla v2 vera (floor + direzione + slippage)." -ForegroundColor White
