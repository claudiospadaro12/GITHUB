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

# --- 1) PERCORSI: RILEVAMENTO AUTOMATICO -----------------------------
# Lo script trova DA SOLO il terminale BCM e la sua cartella dati, su
# QUALSIASI macchina (VPS o PC fisso). Lancialo sul PC dove vuoi fare i
# test (quello con MT5 BCM aperto almeno una volta e loggato al demo).
#
# Se vuoi forzare percorsi specifici, scrivili qui (altrimenti lasciali
# vuoti "" = rilevamento automatico):
$Terminal     = ""   # es. "C:\Program Files\BCM Markets MT5 Terminal\terminal64.exe"
$MetaEditor   = ""   # es. "C:\Program Files\BCM Markets MT5 Terminal\metaeditor64.exe"
$DataFolder   = ""   # es. "C:\Users\Master\AppData\Roaming\MetaQuotes\Terminal\<hash>"
$Python       = "python"
# ---------------------------------------------------------------------

$ErrorActionPreference = "Stop"
$RepoRoot   = Split-Path -Parent $MyInvocation.MyCommand.Path

Write-Host "=== OTTIMIZZAZIONE AUTOMATICA EA ===" -ForegroundColor Cyan

# --- rileva il terminale BCM (preferisce quello NON -V3) -------------
if (-not $Terminal) {
    $allTerm = Get-ChildItem "C:\Program Files","C:\Program Files (x86)" -Recurse -Filter "terminal64.exe" -ErrorAction SilentlyContinue
    $cand = $allTerm | Where-Object { $_.DirectoryName -like "*BCM Markets MT5 Terminal*" -and $_.DirectoryName -notlike "*-V3*" } | Select-Object -First 1
    if (-not $cand) { $cand = $allTerm | Where-Object { $_.DirectoryName -like "*BCM Markets*" } | Select-Object -First 1 }
    if ($cand) { $Terminal = $cand.FullName; $MetaEditor = Join-Path $cand.DirectoryName "metaeditor64.exe" }
}
# --- rileva la cartella dati abbinata (via origin.txt) ---------------
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

Write-Host ("Terminale : {0}" -f $Terminal)
Write-Host ("MetaEditor: {0}" -f $MetaEditor)
Write-Host ("Cartella dati: {0}" -f $DataFolder)

# controlli preliminari
if (-not $Terminal -or -not (Test-Path $Terminal)) { Write-Host "Terminale BCM non trovato. Scrivi il percorso a mano in cima ($Terminal)." -ForegroundColor Red; exit 1 }
if (-not $MetaEditor -or -not (Test-Path $MetaEditor)) { Write-Host "metaeditor64.exe non trovato accanto al terminale." -ForegroundColor Red; exit 1 }
if (-not $DataFolder -or -not (Test-Path $DataFolder)) { Write-Host "Cartella dati non trovata. Scrivila a mano in cima ($DataFolder)." -ForegroundColor Red; exit 1 }

$ExpertsSrc = Join-Path $RepoRoot "..\mql5\Experts"
$IniDir     = Join-Path $RepoRoot "ini"
$MqlExperts = Join-Path $DataFolder "MQL5\Experts"
$MqlFiles   = Join-Path $DataFolder "MQL5\Files"
$Results    = Join-Path $RepoRoot "risultati_ottimizzazione"
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
