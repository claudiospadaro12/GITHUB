# =====================================================================
#  log_ea.ps1  --  tira fuori dai log di MT5 le righe di UN EA
# ---------------------------------------------------------------------
#  PERCHE' ESISTE (06/08/2026):
#  il Dow ha piazzato un BUY STOP alle 14:45:00 ma del SELL STOP non
#  c'e' traccia. Le due spiegazioni possibili - il broker l'ha rifiutato,
#  oppure l'EA non l'ha nemmeno provato - portano a conclusioni opposte,
#  e la differenza sta scritta nei log.
#
#  Guarda in DUE posti, perche' le due cose finiscono in file diversi:
#    MQL5\Logs\  = scheda ESPERTI  -> quello che dice l'EA (ABTGLog)
#    logs\       = scheda GIORNALE -> quello che dice il BROKER
#                                     (ordini accettati, rifiutati, retcode)
#  Un rifiuto del broker sta nel Giornale, non negli Esperti: guardare
#  solo uno dei due e' il modo classico per non trovare la causa.
#
#  USO (sul VPS, MT5 puo' restare aperto):
#    powershell -ExecutionPolicy Bypass -File .\log_ea.ps1
#    powershell -ExecutionPolicy Bypass -File .\log_ea.ps1 -Filtro "Nasdaq|NASUSD" -Da 14:25 -A 15:05
#    powershell -ExecutionPolicy Bypass -File .\log_ea.ps1 -Data 20260805 -Tutto
#
#  Scrive tutto in %USERPROFILE%\log_<filtro>_<data>.txt, pronto da mandare.
# =====================================================================
param(
  [string] $Filtro = "Dow|U30USD|770202",   # regex: EA, simbolo, magic
  [string] $Data   = "",                    # AAAAMMGG. Vuoto = oggi
  [string] $Da     = "14:30",               # finestra oraria (ora SERVER, come nei log)
  [string] $A      = "15:10",
  [switch] $Tutto,                          # ignora la finestra oraria
  [switch] $SoloEsperti                     # salta il Giornale
)
$ErrorActionPreference = "Continue"

if (-not $Data) { $Data = (Get-Date).ToString("yyyyMMdd") }

# --- MT5 scrive i log in UTF-16: se si legge male non si trova niente ---
function Leggi-Log($path) {
  foreach ($enc in @("Unicode", "UTF8", "Default")) {
    try {
      $righe = Get-Content -Path $path -Encoding $enc -ErrorAction Stop
      # un log buono ha tabulazioni e orari: se non li trova, era la codifica sbagliata
      if (($righe | Select-String -Pattern "\d{2}:\d{2}:\d{2}" -Quiet)) { return $righe }
    } catch { }
  }
  return @()
}

function InFinestra($riga) {
  if ($Tutto) { return $true }
  if ($riga -notmatch "(\d{2}):(\d{2}):(\d{2})") { return $false }
  $m = [int]$matches[1]*60 + [int]$matches[2]
  $d = [int]($Da -split ":")[0]*60 + [int]($Da -split ":")[1]
  $a = [int]($A  -split ":")[0]*60 + [int]($A  -split ":")[1]
  return ($m -ge $d -and $m -le $a)
}

# --- cerca in TUTTE le cartelle dati: piu' robusto che indovinare quale ---
$termRoot = Join-Path $env:APPDATA "MetaQuotes\Terminal"
if (-not (Test-Path $termRoot)) { Write-Host "Cartella MetaQuotes non trovata." -ForegroundColor Red; exit 1 }

$out = New-Object System.Collections.ArrayList
$trovate = 0

Write-Host "=== LOG MT5 · filtro '$Filtro' · data $Data ===" -ForegroundColor Cyan
if (-not $Tutto) { Write-Host "    finestra $Da - $A (ora SERVER, quella dei log)" -ForegroundColor Gray }

foreach ($dir in (Get-ChildItem $termRoot -Directory -ErrorAction SilentlyContinue)) {
  $fonti = @(
    @{ Nome = "ESPERTI  (cosa dice l'EA)";     File = Join-Path $dir.FullName "MQL5\Logs\$Data.log" }
  )
  if (-not $SoloEsperti) {
    $fonti += @{ Nome = "GIORNALE (cosa dice il BROKER)"; File = Join-Path $dir.FullName "logs\$Data.log" }
  }

  foreach ($f in $fonti) {
    if (-not (Test-Path $f.File)) { continue }
    $righe = Leggi-Log $f.File
    if (-not $righe) { continue }
    $sel = @($righe | Where-Object { $_ -match $Filtro -and (InFinestra $_) })
    if ($sel.Count -eq 0) { continue }

    $trovate += $sel.Count
    $intest = "`n--- $($f.Nome) --- $($f.File)  [$($sel.Count) righe]"
    Write-Host $intest -ForegroundColor Yellow
    [void]$out.Add($intest)
    foreach ($r in $sel) { Write-Host "  $r"; [void]$out.Add("  $r") }
  }
}

if ($trovate -eq 0) {
  Write-Host "`nNessuna riga trovata." -ForegroundColor Yellow
  Write-Host "Prova cosi':" -ForegroundColor Yellow
  Write-Host "  - allarga la finestra:  -Tutto" -ForegroundColor Gray
  Write-Host "  - allarga il filtro:    -Filtro `"U30USD`"" -ForegroundColor Gray
  Write-Host "  - controlla la data:    -Data $Data  (i log sono per giorno, nome AAAAMMGG)" -ForegroundColor Gray
  Write-Host "`nCartelle dati viste:" -ForegroundColor Gray
  Get-ChildItem $termRoot -Directory -EA SilentlyContinue | ForEach-Object {
    $e = Join-Path $_.FullName "MQL5\Logs\$Data.log"
    Write-Host ("   {0}  log di oggi: {1}" -f $_.Name, $(if (Test-Path $e) { "SI" } else { "no" })) -ForegroundColor DarkGray
  }
  exit 0
}

$dest = Join-Path $env:USERPROFILE ("log_" + ($Filtro -replace '[^A-Za-z0-9]','_') + "_$Data.txt")
$out | Set-Content -Path $dest -Encoding UTF8
Write-Host "`n$trovate righe salvate in:" -ForegroundColor Green
Write-Host "  $dest" -ForegroundColor Green
Write-Host "`nMandami questo file." -ForegroundColor Cyan
