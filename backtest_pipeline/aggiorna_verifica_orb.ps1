# =====================================================================
#  aggiorna_verifica_orb.ps1 -- aggiorna ABTG_ORB_Ottimizzato.mq5 (v1.02,
#  ricompilato dal repo `lavoro`) su ENTRAMBE le istanze MT5 del VPS
#  (piccolo 50503392 e -V3/100k 50504263), poi VERIFICA che sia andata
#  bene: versione giusta, Guardian presente, compilazione senza errori.
#
#  Nasce dall'indagine sui gemelli ORB 22/08 (v. report/
#  ORB_GEMELLI_DIVERGENZA_2026-08-22.md): il piccolo girava v1.00 SENZA
#  nessuna integrazione Guardian, il 100k girava v1.01. Questo script
#  porta entrambi allo stesso v1.02 del repo.
#
#  ATTENZIONE (imparato l'08/08, vedi aggiorna_ea.ps1): la ricompilazione
#  da riga di comando SCARICA l'EA dai grafici e NON lo ricarica da sola.
#  Dopo questo script vanno RIAVVIATI entrambi i terminali E ricaricato
#  il preset .set giusto per ogni conto (l'EA torna ai default finche'
#  non lo fai).
#
#  QUANDO lanciarlo: MT5 chiuso o comunque nessuna posizione ORB aperta
#  su nessuno dei due conti (fuori dagli orari U30USD/Dow).
#
#  USO (sul VPS):
#    irm https://raw.githubusercontent.com/claudiospadaro12/GITHUB/lavoro/backtest_pipeline/aggiorna_verifica_orb.ps1 -OutFile aggiorna_verifica_orb.ps1
#    powershell -ExecutionPolicy Bypass -File .\aggiorna_verifica_orb.ps1
# =====================================================================
$ErrorActionPreference = "Stop"
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$EaNome = "ABTG_ORB_Ottimizzato"
$UrlSorgente = "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/lavoro/mql5/Experts/$EaNome.mq5"

Write-Host "=== AGGIORNO E VERIFICO $EaNome SU ENTRAMBE LE ISTANZE ===" -ForegroundColor Cyan

# --- trova tutte le istanze MT5 col loro origin.txt (stesso metodo di
#     estrai_set_forward.ps1: vecchia = 'BCM Markets MT5 Terminal',
#     nuova/100k = 'BCM Markets MT5 Terminal -V3') -----------------------
$root = Join-Path $env:APPDATA "MetaQuotes\Terminal"
$folders = Get-ChildItem $root -Directory -ErrorAction SilentlyContinue | Where-Object {
  Test-Path (Join-Path $_.FullName "origin.txt")
}
$map = @{}
foreach ($f in $folders) { $map[$f.FullName] = (Get-Content (Join-Path $f.FullName "origin.txt") -Raw).Trim() }

$piccolo = $folders | Where-Object { $map[$_.FullName] -like "*BCM*MT5*" -and $map[$_.FullName] -notlike "*-V3*" -and $map[$_.FullName] -notlike "*MT4*" } | Select-Object -First 1
$grande  = $folders | Where-Object { $map[$_.FullName] -like "*BCM*MT5*-V3*" } | Select-Object -First 1

if (-not $piccolo -or -not $grande) {
  Write-Host "Non trovo le due istanze (piccolo 'BCM Markets MT5 Terminal' / grande '...-V3'):" -ForegroundColor Red
  foreach ($f in $folders) { Write-Host ("  {0} -> {1}" -f $f.Name, $map[$f.FullName]) }
  exit 1
}

$istanze = @(
  @{ Etichetta = "PICCOLO (50503392)"; DataFolder = $piccolo.FullName; InstDir = $map[$piccolo.FullName] },
  @{ Etichetta = "GRANDE/100k -V3 (50504263)"; DataFolder = $grande.FullName; InstDir = $map[$grande.FullName] }
)

$risultati = New-Object System.Collections.ArrayList

foreach ($ist in $istanze) {
  Write-Host ""
  Write-Host ("--- {0} ---" -f $ist.Etichetta) -ForegroundColor Yellow
  Write-Host ("    istanza: " + $ist.InstDir) -ForegroundColor Gray

  $MetaEditor = Join-Path $ist.InstDir "metaeditor64.exe"
  if (-not (Test-Path $MetaEditor)) {
    Write-Host "    ERRORE: metaeditor64.exe non trovato in questa istanza." -ForegroundColor Red
    [void]$risultati.Add(("{0}: ERRORE metaeditor64.exe non trovato" -f $ist.Etichetta))
    continue
  }

  $MqlExperts = Join-Path $ist.DataFolder "MQL5\Experts"
  New-Item -ItemType Directory -Force -Path $MqlExperts | Out-Null
  $dest = Join-Path $MqlExperts "$EaNome.mq5"

  try {
    Invoke-WebRequest -Uri $UrlSorgente -OutFile $dest -UseBasicParsing
  } catch {
    Write-Host "    ERRORE: download del sorgente fallito (rete?)." -ForegroundColor Red
    [void]$risultati.Add(("{0}: ERRORE download fallito" -f $ist.Etichetta))
    continue
  }

  $testo = Get-Content -Path $dest -Raw
  $versione = "?"
  if ($testo -match '#property\s+version\s+"([^"]+)"') { $versione = $Matches[1] }
  $haGuardian = ($testo -match "ABTG_PausaGuardian\.mqh") -and ($testo -match "InpUsaGuardian")

  & $MetaEditor "/compile:$dest" "/log" | Out-Null
  $ex5 = [System.IO.Path]::ChangeExtension($dest, ".ex5")
  $compileOk = (Test-Path $ex5) -and ((Get-Item $ex5).LastWriteTime -gt (Get-Date).AddMinutes(-5))

  $bollino = if ($compileOk) { "OK" } else { "ERRORE" }
  $coloreCompile = if ($compileOk) { "Green" } else { "Red" }
  $coloreGuardian = if ($haGuardian) { "Green" } else { "Red" }

  Write-Host ("    versione scaricata : {0}" -f $versione) -ForegroundColor Gray
  Write-Host ("    Guardian presente   : {0}" -f $haGuardian) -ForegroundColor $coloreGuardian
  Write-Host ("    compilazione        : {0}" -f $bollino) -ForegroundColor $coloreCompile

  [void]$risultati.Add(("{0}: versione={1}  guardian={2}  compile={3}" -f $ist.Etichetta, $versione, $haGuardian, $bollino))
}

Write-Host ""
Write-Host "!!! ORA RIAVVIA ENTRAMBI I TERMINALI !!!" -ForegroundColor Red
Write-Host "    La ricompilazione da riga di comando SCARICA l'EA dai grafici e NON lo" -ForegroundColor Red
Write-Host "    ricarica da sola: torna su solo al riavvio del terminale." -ForegroundColor Red
Write-Host "    Dopo il riavvio: RICARICA il preset .set giusto per ogni conto (per il" -ForegroundColor Yellow
Write-Host "    piccolo: sedia_ABTG_ORB_Ottimizzato_770611.set), altrimenti gli input" -ForegroundColor Yellow
Write-Host "    tornano ai default e si perde la firma." -ForegroundColor Yellow

# --- raccolta sul Desktop + zip (regola delle righe di lancio) -------
function Trova-Desktop {
  foreach ($p in @([Environment]::GetFolderPath("Desktop"),
                   (Join-Path $env:USERPROFILE "Desktop"),
                   (Join-Path $env:USERPROFILE "OneDrive\Desktop"))) {
    if ($p -and (Test-Path $p)) { return $p }
  }
  return $env:USERPROFILE
}
$desktop = Trova-Desktop
$cart = Join-Path $desktop "verifica_orb"
$zip  = Join-Path $desktop "verifica_orb.zip"
$refertoPath = Join-Path $cart "verifica_orb.txt"
$zipOk = $false
$motivo = ""
try {
  if (Test-Path $cart) { Remove-Item $cart -Recurse -Force -ErrorAction Stop }
  New-Item -ItemType Directory -Path $cart -Force -ErrorAction Stop | Out-Null
  $risultati | Set-Content -Path $refertoPath -Encoding ASCII
  if (Test-Path $zip) { Remove-Item $zip -Force -ErrorAction Stop }
  Compress-Archive -Path (Join-Path $cart "*") -DestinationPath $zip -Force -ErrorAction Stop
  $zipOk = Test-Path $zip
} catch {
  $motivo = $_.Exception.Message
}

Write-Host ""
Write-Host "=== RACCOLTA ===" -ForegroundColor Cyan
if ($zipOk) {
  Write-Host "  zip da mandare: $zip" -ForegroundColor Green
  Write-Host "  File attesi nello zip (1): verifica_orb.txt" -ForegroundColor Gray
} else {
  Write-Host "  ZIP NON CREATO" -ForegroundColor Yellow
  if ($motivo) { Write-Host ("  motivo: " + $motivo) -ForegroundColor Red }
  Write-Host "  MANDAMI DIRETTAMENTE L'OUTPUT QUI SOPRA: va bene uguale." -ForegroundColor Yellow
}
