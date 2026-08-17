# =====================================================================
#  recupera_100k.ps1  --  cerca i DATI del dry-run FTMO sopravvissuti
#                         alla cancellazione del conto 50504263
# ---------------------------------------------------------------------
#  PERCHE' ESISTE (17/08/2026)
#  Claudio: "Non ho piu' il conto da 109k. L'ho cancellato."
#  Il dry-run era acceso dal 09/08 alle 20:22 con il Guardiano e 5 EA a
#  rischio 0,65%: otto giorni, l'unico dato prop VERO del progetto.
#
#  MA MT5 SCRIVE I CSV NELLA CARTELLA DATI, NON DENTRO IL CONTO.
#  Cancellare il conto non cancella i file. Questo script li cerca e li
#  mette sul Desktop in una cartella + zip, pronti da mandare.
#
#  NON TOCCA NIENTE: legge, copia sul Desktop, zippa. Non cancella, non
#  sposta, non apre MT5, non manda ordini. Si puo' lanciare col terminale
#  aperto e sul VPS.
#
#  USO (sul VPS, dove girava l'istanza -V3):
#    powershell -ExecutionPolicy Bypass -File .\recupera_100k.ps1
# =====================================================================
$ErrorActionPreference = "Continue"

$Dest = Join-Path $env:USERPROFILE "Desktop\RECUPERO_100K"
New-Item -ItemType Directory -Force -Path $Dest | Out-Null

Write-Host ""
Write-Host "=== RECUPERO DATI DRY-RUN 100K (conto 50504263, cancellato) ===" -ForegroundColor Cyan
Write-Host "    Lo script NON cancella e NON sposta niente: legge e copia." -ForegroundColor DarkGray
Write-Host ""

# --- 1. dove MT5 tiene i file: tutte le cartelle dati + la Common ----
$TermRoot = Join-Path $env:APPDATA "MetaQuotes\Terminal"
$Trovati  = New-Object System.Collections.ArrayList

if(Test-Path $TermRoot){
  Write-Host "    cerco in $TermRoot ..." -ForegroundColor Gray
  $csv = Get-ChildItem $TermRoot -Recurse -File -ErrorAction SilentlyContinue |
         Where-Object { $_.Name -like "ABTG_Trades*.csv" -or $_.Name -like "abtg_trades_*.csv" }
  foreach($f in $csv){ [void]$Trovati.Add($f) }
}else{
  Write-Host "    ATTENZIONE: $TermRoot non esiste. Sei sulla macchina giusta?" -ForegroundColor Yellow
}

# --- 2. le pagelle serali sul Desktop (scarica_pagella.ps1) ----------
$pag = Get-ChildItem (Join-Path $env:USERPROFILE "Desktop") -File -ErrorAction SilentlyContinue |
       Where-Object { $_.Name -like "pagella_*.txt" }
foreach($f in $pag){ [void]$Trovati.Add($f) }

# --- 3. i log del Guardiano (scrive nel Giornale, non in un file suo:
#        si prendono i .log del terminale dal 09/08 in poi) -----------
if(Test-Path $TermRoot){
  $log = Get-ChildItem $TermRoot -Recurse -File -Filter "*.log" -ErrorAction SilentlyContinue |
         Where-Object { $_.LastWriteTime -ge (Get-Date "2026-08-09") -and $_.FullName -like "*Logs*" }
  foreach($f in $log){ [void]$Trovati.Add($f) }
}

# --- 4. copia con il nome della cartella davanti, per non sovrascrivere
$n = 0
foreach($f in $Trovati){
  $padre = Split-Path -Leaf $f.DirectoryName
  $nome  = "{0}__{1}" -f $padre, $f.Name
  try{ Copy-Item $f.FullName (Join-Path $Dest $nome) -Force; $n++ }catch{}
}

Write-Host ""
$elenco = @(Get-ChildItem $Dest -File -ErrorAction SilentlyContinue)
if($elenco.Count -eq 0){
  Write-Host "=== NIENTE TROVATO ===" -ForegroundColor Red
  Write-Host "    Nessun CSV, nessuna pagella, nessun log dal 09/08." -ForegroundColor Red
  Write-Host "    Prova a lanciarlo anche sull'ALTRA macchina (VPS / PC)." -ForegroundColor Yellow
  exit 0
}

Write-Host ("=== TROVATI {0} FILE ===" -f $elenco.Count) -ForegroundColor Green
$elenco | Sort-Object Length -Descending |
  Select-Object Name, @{n="KB";e={[math]::Round($_.Length/1KB,1)}}, LastWriteTime |
  Format-Table -AutoSize

$Zip = Join-Path $env:USERPROFILE "Desktop\RECUPERO_100K.zip"
Compress-Archive -Path (Join-Path $Dest "*") -DestinationPath $Zip -Force
Write-Host ""
Write-Host "    ZIP PRONTO SUL DESKTOP:" -ForegroundColor Green
Write-Host "      $Zip" -ForegroundColor White
Write-Host ""
Write-Host "    DA CONTROLLARE NELL'ELENCO QUI SOPRA:" -ForegroundColor Cyan
Write-Host "      - un file che contiene 'Trades_100k'  -> i trade del dry-run" -ForegroundColor Gray
Write-Host "      - pagella_2026-08-*.txt               -> le pagelle serali" -ForegroundColor Gray
Write-Host "    Se questi due non ci sono, gli otto giorni sono persi davvero." -ForegroundColor Gray
