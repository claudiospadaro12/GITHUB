# =====================================================================
#  aggiorna_verifica_orb.ps1 -- v2 (22/08/2026)
#  MARCATORE-VERSIONE-SCRIPT: ORBVERIFICA-V2
#
#  Aggiorna ABTG_ORB_Ottimizzato.mq5 (v1.02) E la sua dipendenza
#  ABTG_PausaGuardian.mqh su ENTRAMBE le istanze MT5 del VPS
#  (piccolo 50503392 e -V3/100k 50504263), ricompila con il
#  metaeditor64.exe di ciascuna istanza e VERIFICA l'esito.
#
#  Nasce dall'indagine gemelli ORB 22/08 (report/ORB_GEMELLI_
#  DIVERGENZA_2026-08-22.md): il piccolo gira v1.00 SENZA nessuna
#  integrazione Guardian, il 100k v1.01.
#
#  PRETENDE MT5 E METAEDITOR CHIUSI (checklist punto 7): la
#  ricompilazione scarica l'EA dai grafici e una posizione ORB aperta
#  resterebbe senza gestione.
#
#  Dopo: RIAVVIARE entrambi i terminali E ricaricare i preset.
#
#  NOTA IMPORTANTE (non risolta da questo script): il preset del
#  piccolo ha InpTP1Pct=0, quindi anche dopo l'aggiornamento a v1.02
#  il breakeven NON puo' scattare su quell'istanza (vedi report ORB
#  gemelli). Questo giro NON e' pensato per sistemare il trailing.
# =====================================================================
param([string]$VersioneAttesa = "1.02")
$ErrorActionPreference = "Stop"
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$INV   = [System.Globalization.CultureInfo]::InvariantCulture
$Avvio = Get-Date
$stamp = $Avvio.ToString("yyyyMMdd_HHmmss", $INV)

$EaNome      = "ABTG_ORB_Ottimizzato"
$IncNome     = "ABTG_PausaGuardian.mqh"
$Base        = "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/lavoro"
$UrlSorgente = "$Base/mql5/Experts/$EaNome.mq5"
$UrlInclude  = "$Base/mql5/Include/$IncNome"

$risultati = New-Object System.Collections.ArrayList
$problemi  = 0

Write-Host "=== AGGIORNO E VERIFICO $EaNome SU ENTRAMBE LE ISTANZE ===" -ForegroundColor Cyan

# --- guardia: MT5 / MetaEditor devono essere CHIUSI -------------------
$vivi = @(Get-Process -Name terminal64,metaeditor64 -ErrorAction SilentlyContinue)
if ($vivi.Count -gt 0) {
  Write-Host "RIFIUTO: MT5 o MetaEditor sono APERTI." -ForegroundColor Red
  foreach ($v in $vivi) { Write-Host ("  " + $v.ProcessName + " pid " + $v.Id) -ForegroundColor Red }
  Write-Host "  Chiudi ENTRAMBI i terminali e MetaEditor, poi rilancia." -ForegroundColor Yellow
  exit 1
}

# --- scarico in TEMP e CONTROLLO prima di toccare la produzione -------
$tmp = Join-Path $env:TEMP ("orbagg_" + $stamp)
New-Item -ItemType Directory -Path $tmp -Force | Out-Null
$tmpEa  = Join-Path $tmp "$EaNome.mq5"
$tmpInc = Join-Path $tmp $IncNome
try {
  Invoke-WebRequest -Uri $UrlSorgente -OutFile $tmpEa  -UseBasicParsing -ErrorAction Stop
  Invoke-WebRequest -Uri $UrlInclude  -OutFile $tmpInc -UseBasicParsing -ErrorAction Stop
} catch {
  Write-Host ("DOWNLOAD FALLITO: " + $_.Exception.Message) -ForegroundColor Red
  exit 1
}

$testo    = Get-Content -LiteralPath $tmpEa -Raw
$versione = "?"
if ($testo -match '#property\s+version\s+"([^"]+)"') { $versione = $Matches[1] }
$haGuardian = ($testo -match 'ABTG_PausaGuardian\.mqh') -and ($testo -match 'InpUsaGuardian')
$inc = Get-Content -LiteralPath $tmpInc -Raw

if ($versione -ne $VersioneAttesa) {
  Write-Host ("SCARICATA LA VERSIONE SBAGLIATA: " + $versione + " invece di " + $VersioneAttesa) -ForegroundColor Red
  Write-Host "  (cache di raw.githubusercontent, ~5 min: aspetta e rilancia)" -ForegroundColor Yellow
  exit 1
}
if (-not $haGuardian) {
  Write-Host "IL SORGENTE SCARICATO NON HA L'INTEGRAZIONE GUARDIAN: non compilo niente." -ForegroundColor Red
  exit 1
}
if ($inc -notmatch 'bool\s+ABTG_GuardiaIngresso') {
  Write-Host "L'INCLUDE SCARICATO NON DEFINISCE ABTG_GuardiaIngresso: non compilo niente." -ForegroundColor Red
  exit 1
}
Write-Host ("Sorgente v" + $versione + " + include: scaricati e controllati.") -ForegroundColor Green

# --- trova le due istanze, e PRETENDE che siano una e una -------------
$root = Join-Path $env:APPDATA "MetaQuotes\Terminal"
$folders = @(Get-ChildItem -LiteralPath $root -Directory -ErrorAction SilentlyContinue |
             Where-Object { Test-Path (Join-Path $_.FullName "origin.txt") })
$map = @{}
foreach ($f in $folders) { $map[$f.FullName] = (Get-Content -LiteralPath (Join-Path $f.FullName "origin.txt") -Raw).Trim() }

$piccoloTutti = @($folders | Where-Object { $map[$_.FullName] -like "*BCM*MT5*" -and $map[$_.FullName] -notlike "*-V3*" -and $map[$_.FullName] -notlike "*MT4*" })
$grandeTutti  = @($folders | Where-Object { $map[$_.FullName] -like "*BCM*MT5*-V3*" })

if ($piccoloTutti.Count -ne 1 -or $grandeTutti.Count -ne 1) {
  Write-Host ("ISTANZE AMBIGUE: piccolo=" + $piccoloTutti.Count + " grande=" + $grandeTutti.Count + " (ne serve 1 e 1)") -ForegroundColor Red
  foreach ($f in $folders) { Write-Host ("  {0} -> {1}" -f $f.Name, $map[$f.FullName]) }
  exit 1
}

$istanze = @(
  @{ Etichetta = "PICCOLO (50503392)";         Corto = "piccolo"; DataFolder = $piccoloTutti[0].FullName; InstDir = $map[$piccoloTutti[0].FullName] },
  @{ Etichetta = "GRANDE/100k -V3 (50504263)"; Corto = "grande";  DataFolder = $grandeTutti[0].FullName;  InstDir = $map[$grandeTutti[0].FullName] }
)

$logDaRaccogliere = New-Object System.Collections.ArrayList

foreach ($ist in $istanze) {
  Write-Host ""
  Write-Host ("--- {0} ---" -f $ist.Etichetta) -ForegroundColor Yellow
  Write-Host ("    istanza: " + $ist.InstDir) -ForegroundColor Gray

  $MetaEditor = Join-Path $ist.InstDir "metaeditor64.exe"
  if (-not (Test-Path -LiteralPath $MetaEditor)) {
    Write-Host "    ERRORE: metaeditor64.exe non trovato in questa istanza." -ForegroundColor Red
    [void]$risultati.Add(("{0}: ERRORE metaeditor64.exe non trovato" -f $ist.Etichetta))
    $problemi++
    continue
  }

  $MqlExperts = Join-Path $ist.DataFolder "MQL5\Experts"
  $MqlInclude = Join-Path $ist.DataFolder "MQL5\Include"
  New-Item -ItemType Directory -Force -Path $MqlExperts | Out-Null
  New-Item -ItemType Directory -Force -Path $MqlInclude | Out-Null
  $dest    = Join-Path $MqlExperts "$EaNome.mq5"
  $ex5     = [System.IO.Path]::ChangeExtension($dest, ".ex5")
  $destInc = Join-Path $MqlInclude $IncNome

  # versione che c'era PRIMA (e' la prova di cosa girava)
  $vecchia = "assente"
  if (Test-Path -LiteralPath $dest) {
    $t0 = Get-Content -LiteralPath $dest -Raw
    if ($t0 -match '#property\s+version\s+"([^"]+)"') { $vecchia = $Matches[1] } else { $vecchia = "?" }
  }

  # backup DATATO, mai sovrascritto (checklist 12 + 54)
  $bakMq5 = $dest + ".prima_" + $stamp
  $bakEx5 = $ex5  + ".prima_" + $stamp
  if (Test-Path -LiteralPath $dest) { Copy-Item -LiteralPath $dest -Destination $bakMq5 -Force }
  if (Test-Path -LiteralPath $ex5)  { Copy-Item -LiteralPath $ex5  -Destination $bakEx5 -Force }
  if (Test-Path -LiteralPath $destInc) {
    $bakInc = $destInc + ".prima_" + $stamp
    if (-not (Test-Path -LiteralPath $bakInc)) { Copy-Item -LiteralPath $destInc -Destination $bakInc -Force }
  }

  # copia + verifica sul CONTENUTO (checklist 27-ter)
  $okCopia = $true
  foreach ($c in @(@{S=$tmpInc; D=$destInc}, @{S=$tmpEa; D=$dest})) {
    Copy-Item -LiteralPath $c.S -Destination $c.D -Force
    $len = (Get-Item -LiteralPath $c.S).Length
    $v = Get-Item -LiteralPath $c.D -ErrorAction SilentlyContinue
    if (-not $v -or $v.PSIsContainer -or $v.Length -ne $len) { $okCopia = $false }
  }
  if (-not $okCopia) {
    Write-Host "    ERRORE: copia NON verificata (lunghezza diversa o e' una cartella)." -ForegroundColor Red
    [void]$risultati.Add(("{0}: ERRORE copia non verificata" -f $ist.Etichetta))
    $problemi++
    continue
  }

  # snapshot del .ex5 PRIMA (niente finestre di 5 minuti)
  $ex5Prima = (Get-Date).AddYears(-100)
  if (Test-Path -LiteralPath $ex5) { $ex5Prima = (Get-Item -LiteralPath $ex5).LastWriteTime }

  $logFile = [System.IO.Path]::ChangeExtension($dest, ".log")
  Remove-Item -LiteralPath $logFile -Force -ErrorAction SilentlyContinue

  $proc = Start-Process -FilePath $MetaEditor -ArgumentList "`"/compile:$dest`"","`"/log:$logFile`"" -Wait -PassThru -NoNewWindow
  $rc = $proc.ExitCode

  $ex5Dopo = $null
  if (Test-Path -LiteralPath $ex5) { $ex5Dopo = (Get-Item -LiteralPath $ex5).LastWriteTime }
  $compileOk = ($ex5Dopo -ne $null) -and ($ex5Dopo -gt $ex5Prima)

  if ($compileOk) {
    $bollino = "OK"
    $inEsecuzione = $VersioneAttesa + " (dopo il riavvio del terminale)"
  } else {
    $bollino = "ERRORE"
    $problemi++
    # sorgente e binario devono restare la STESSA versione (punto 54)
    if (Test-Path -LiteralPath $bakMq5) {
      Copy-Item -LiteralPath $bakMq5 -Destination $dest -Force
      Write-Host "    .mq5 RIPRISTINATO dal backup: sorgente e .ex5 restano allineati." -ForegroundColor Yellow
    }
    $inEsecuzione = $vecchia + " -- ATTENZIONE: QUESTO CONTO CONTINUA CON LA VERSIONE VECCHIA"
  }

  $coloreCompile  = "Red"; if ($compileOk)  { $coloreCompile  = "Green" }
  $coloreGuardian = "Red"; if ($haGuardian) { $coloreGuardian = "Green" }

  Write-Host ("    versione PRIMA      : {0}" -f $vecchia) -ForegroundColor Gray
  Write-Host ("    versione scaricata  : {0}" -f $versione) -ForegroundColor Gray
  Write-Host ("    Guardian nel .mq5   : {0}" -f $haGuardian) -ForegroundColor $coloreGuardian
  Write-Host ("    include installato  : {0}" -f $destInc) -ForegroundColor Gray
  Write-Host ("    compilazione        : {0} (metaeditor rc={1})" -f $bollino, $rc) -ForegroundColor $coloreCompile
  Write-Host ("    IN ESECUZIONE       : {0}" -f $inEsecuzione) -ForegroundColor $coloreCompile

  if (-not $compileOk) {
    Write-Host "    --- ultime righe del log di MetaEditor ---" -ForegroundColor Red
    $ultime = @(Get-Content -LiteralPath $logFile -ErrorAction SilentlyContinue | Select-Object -Last 15)
    if ($ultime.Count -eq 0) { Write-Host "      (nessun log prodotto)" -ForegroundColor Red }
    foreach ($r in $ultime) { Write-Host ("      " + $r) -ForegroundColor Red }
  }
  if (Test-Path -LiteralPath $logFile) { [void]$logDaRaccogliere.Add(@{ File = $logFile; Nome = ("compile_" + $ist.Corto + ".log") }) }

  # preset presenti in questa istanza (non si inventano nomi)
  $presetDir = Join-Path $ist.DataFolder "MQL5\Presets"
  $set = @(Get-ChildItem -LiteralPath $presetDir -Filter "*.set" -ErrorAction SilentlyContinue | Where-Object { $_.Name -like "*ORB*" })
  Write-Host ("    preset .set con 'ORB' in questa istanza: " + $set.Count) -ForegroundColor Gray
  foreach ($s in $set) { Write-Host ("      " + $s.Name) -ForegroundColor Gray }

  [void]$risultati.Add(("{0}: prima={1}  scaricata={2}  guardian={3}  compile={4}  in_esecuzione={5}  backup={6}" -f `
      $ist.Etichetta, $vecchia, $versione, $haGuardian, $bollino, $inEsecuzione, $bakMq5))
}

Write-Host ""
Write-Host "!!! ORA RIAVVIA ENTRAMBI I TERMINALI !!!" -ForegroundColor Red
Write-Host "    La ricompilazione da riga di comando SCARICA l'EA dai grafici e NON lo" -ForegroundColor Red
Write-Host "    ricarica da sola: torna su solo al riavvio del terminale." -ForegroundColor Red
Write-Host "    VERIFICA DOPO IL RIAVVIO: nella finestra input dell'EA sul PICCOLO deve" -ForegroundColor Yellow
Write-Host "    comparire InpUsaGuardian. Se non c'e', sta girando ancora la v1.00." -ForegroundColor Yellow
Write-Host "    Poi RICARICA il preset .set giusto su OGNI conto, PRIMA di lunedi'" -ForegroundColor Yellow
Write-Host "    alle 14:25 ORA SERVER (15:25 ora italiana), o l'ORB parte sui default." -ForegroundColor Yellow
Write-Host "    NOTA: il preset del piccolo ha InpTP1Pct=0 -> il breakeven NON puo'" -ForegroundColor Yellow
Write-Host "    scattare nemmeno con la v1.02. Questo giro NON sistema il trailing." -ForegroundColor Yellow

# --- raccolta sul Desktop + zip (regola delle righe di lancio) --------
function Trova-Desktop {
  foreach ($p in @([Environment]::GetFolderPath("Desktop"),
                   (Join-Path $env:USERPROFILE "Desktop"),
                   (Join-Path $env:USERPROFILE "OneDrive\Desktop"))) {
    if ($p -and (Test-Path $p)) { return $p }
  }
  return $env:USERPROFILE
}
$desktop = Trova-Desktop
$cart = Join-Path $desktop ("verifica_orb_" + $stamp)
$zip  = Join-Path $desktop ("verifica_orb_" + $stamp + ".zip")
$refertoPath = Join-Path $cart "verifica_orb.txt"
$zipOk = $false
$motivo = ""
$esito = "OK"
if ($problemi -gt 0) { $esito = ("FALLITO -- " + $problemi + " problemi") }
try {
  if (Test-Path -LiteralPath $cart) { Remove-Item -LiteralPath $cart -Recurse -Force -ErrorAction Stop }
  New-Item -ItemType Directory -Path $cart -Force -ErrorAction Stop | Out-Null
  $righe = New-Object System.Collections.ArrayList
  [void]$righe.Add("data: " + $Avvio.ToString("yyyy-MM-dd HH:mm:ss", $INV) + " (ora locale del VPS)")
  [void]$righe.Add("versione attesa: " + $VersioneAttesa)
  [void]$righe.Add("")
  foreach ($r in $risultati) { [void]$righe.Add($r) }
  [void]$righe.Add("")
  [void]$righe.Add("esito: " + $esito)
  $righe | Set-Content -LiteralPath $refertoPath -Encoding ASCII
  foreach ($l in $logDaRaccogliere) { Copy-Item -LiteralPath $l.File -Destination (Join-Path $cart $l.Nome) -Force -ErrorAction SilentlyContinue }
  if (Test-Path -LiteralPath $zip) { Remove-Item -LiteralPath $zip -Force -ErrorAction Stop }
  Compress-Archive -Path (Join-Path $cart "*") -DestinationPath $zip -Force -ErrorAction Stop
  $zipOk = Test-Path -LiteralPath $zip
} catch {
  $motivo = $_.Exception.Message
}

Write-Host ""
Write-Host "=== RACCOLTA ===" -ForegroundColor Cyan
if ($zipOk) {
  Write-Host "  zip da mandare: $zip" -ForegroundColor Green
  Write-Host "  File attesi: verifica_orb.txt (+ compile_piccolo.log / compile_grande.log se c'e' stato un errore)" -ForegroundColor Gray
  Write-Host ("  Nel referto la riga 'data:' deve essere di ADESSO e 'esito:' deve dire OK.") -ForegroundColor Gray
} else {
  Write-Host "  ZIP NON CREATO" -ForegroundColor Yellow
  if ($motivo) { Write-Host ("  motivo: " + $motivo) -ForegroundColor Red }
  Write-Host "  MANDAMI DIRETTAMENTE L'OUTPUT QUI SOPRA: va bene uguale." -ForegroundColor Yellow
}

Remove-Item -LiteralPath $tmp -Recurse -Force -ErrorAction SilentlyContinue
Write-Host ""
Write-Host ("ESITO: " + $esito) -ForegroundColor Cyan
if ($problemi -gt 0) { exit 1 }
exit 0
