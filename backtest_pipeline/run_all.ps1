# =====================================================================
#  run_all.ps1  --  OTTIMIZZAZIONE AUTOMATICA DI TUTTI GLI EA (VPS)
# ---------------------------------------------------------------------
#  Cosa fa, da solo, in sequenza:
#    1. copia i sorgenti .mq5 del repo nella cartella Experts di MT5
#    2. compila ogni EA (metaeditor64 /compile)
#    3. genera gli .ini di ottimizzazione (gen_ini.py)
#    4. lancia lo Strategy Tester in OTTIMIZZAZIONE per ogni EA, uno
#       alla volta (il terminale si chiude da solo a fine passata)
#    5. raccoglie i CSV dei risultati in .\risultati_ottimizzazione\
#
#  TU devi fare UNA cosa sola: controllare i 3 percorsi qui sotto e
#  poi lanciare questo script (tasto destro > Esegui con PowerShell,
#  oppure:  powershell -ExecutionPolicy Bypass -File run_all.ps1 ).
#
#  Alla fine, comprimi e mandami la cartella .\risultati_ottimizzazione\
#  (i file OptResults_*.csv): li analizzo io e creo gli EA _Ottimizzato.
# =====================================================================

# --- 1) PERCORSI DA CONTROLLARE (VPS) --------------------------------
# Cartella dati del terminale MT5 dove girano gli EA (quella del VPS):
$DataFolder   = "C:\Users\Administrator\AppData\Roaming\MetaQuotes\Terminal\215D85D7767A1C39E22D242C8114BF9F5"
# Eseguibili MT5 (correggi se installato altrove):
$Terminal     = "C:\Program Files\MetaTrader 5\terminal64.exe"
$MetaEditor   = "C:\Program Files\MetaTrader 5\metaeditor64.exe"
# Cartella del repo (dove c'e' questo script). Di norma lasciala com'e':
$RepoRoot     = Split-Path -Parent $MyInvocation.MyCommand.Path
$Python       = "python"    # o percorso completo di python.exe
# ---------------------------------------------------------------------

$ErrorActionPreference = "Stop"
$ExpertsSrc = Join-Path $RepoRoot "..\mql5\Experts"
$IniDir     = Join-Path $RepoRoot "ini"
$MqlExperts = Join-Path $DataFolder "MQL5\Experts"
$MqlFiles   = Join-Path $DataFolder "MQL5\Files"
$Results    = Join-Path $RepoRoot "risultati_ottimizzazione"

Write-Host "=== OTTIMIZZAZIONE AUTOMATICA EA ===" -ForegroundColor Cyan

# controlli preliminari
foreach ($p in @($Terminal, $MetaEditor, $DataFolder)) {
    if (-not (Test-Path $p)) { Write-Host "PERCORSO NON TROVATO: $p" -ForegroundColor Red; Write-Host "Correggi i percorsi in cima allo script."; exit 1 }
}
New-Item -ItemType Directory -Force -Path $MqlExperts | Out-Null
New-Item -ItemType Directory -Force -Path $Results    | Out-Null

# --- 2) copia i sorgenti nel terminale -------------------------------
Write-Host "`n[1/5] Copio i sorgenti .mq5 in MQL5\Experts..." -ForegroundColor Yellow
$eaFiles = Get-ChildItem -Path $ExpertsSrc -Filter "ABTG_*.mq5"
foreach ($f in $eaFiles) { Copy-Item $f.FullName -Destination $MqlExperts -Force }
Write-Host "   copiati $($eaFiles.Count) EA."

# --- 3) compila ------------------------------------------------------
Write-Host "`n[2/5] Compilo gli EA..." -ForegroundColor Yellow
foreach ($f in $eaFiles) {
    $src = Join-Path $MqlExperts $f.Name
    & $MetaEditor "/compile:$src" "/log" | Out-Null
    $ex5 = [System.IO.Path]::ChangeExtension($src, ".ex5")
    if (Test-Path $ex5) { Write-Host "   OK  $($f.Name)" -ForegroundColor Green }
    else { Write-Host "   ERRORE compilazione $($f.Name) (salto)" -ForegroundColor Red }
}

# --- 4) genera gli .ini (opzionale: gli .ini sono gia' nel repo) ------
Write-Host "`n[3/5] Genero i file .ini di ottimizzazione..." -ForegroundColor Yellow
$py = Get-Command $Python -ErrorAction SilentlyContinue
if ($py -and (Test-Path (Join-Path $RepoRoot "gen_ini.py"))) {
    try { & $Python (Join-Path $RepoRoot "gen_ini.py") }
    catch { Write-Host "   gen_ini.py non eseguito: uso gli .ini gia' presenti in ini\." -ForegroundColor Yellow }
} else {
    Write-Host "   Python non trovato: uso gli .ini gia' presenti in ini\ (nessun problema)." -ForegroundColor Yellow
}
if (-not (Test-Path $IniDir) -or @(Get-ChildItem -Path $IniDir -Filter "*.ini" -ErrorAction SilentlyContinue).Count -eq 0) {
    Write-Host "NESSUN file .ini trovato in $IniDir. Impossibile procedere." -ForegroundColor Red; exit 1
}

# --- 5) lancia l'ottimizzazione per ogni EA --------------------------
Write-Host "`n[4/5] Avvio le ottimizzazioni (una alla volta)..." -ForegroundColor Yellow
$inis = Get-ChildItem -Path $IniDir -Filter "*.ini"
$i = 0
foreach ($ini in $inis) {
    $i++
    $name = [System.IO.Path]::GetFileNameWithoutExtension($ini.Name)
    $ex5  = Join-Path $MqlExperts "$name.ex5"
    if (-not (Test-Path $ex5)) { Write-Host "   [$i/$($inis.Count)] $name : .ex5 mancante, salto" -ForegroundColor Red; continue }
    Write-Host "   [$i/$($inis.Count)] Ottimizzo $name ..." -ForegroundColor Cyan
    $proc = Start-Process -FilePath $Terminal -ArgumentList "/config:`"$($ini.FullName)`"" -PassThru
    $proc.WaitForExit()   # ShutdownTerminal=1 -> il terminale si chiude da solo
    Write-Host "        fatto." -ForegroundColor Green
}

# --- 6) raccogli i CSV -----------------------------------------------
Write-Host "`n[5/5] Raccolgo i risultati..." -ForegroundColor Yellow
$csvs = Get-ChildItem -Path $MqlFiles -Filter "OptResults_*.csv" -ErrorAction SilentlyContinue
foreach ($c in $csvs) { Copy-Item $c.FullName -Destination $Results -Force }
Write-Host "   $($csvs.Count) file CSV copiati in:" -ForegroundColor Green
Write-Host "   $Results"

Write-Host "`n=== FINITO ===" -ForegroundColor Cyan
Write-Host "Comprimi la cartella 'risultati_ottimizzazione' e mandamela." -ForegroundColor White
