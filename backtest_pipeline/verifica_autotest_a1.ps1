# =====================================================================
#  verifica_autotest_a1.ps1 -- MARCATORE_AUTOTEST_A1_v1
#  Verifica AUTOMATICA dell'EA nuovo ABTG_IntradayMomentum (motore A1,
#  v1.00, magic 772800): scarica sorgente fresco (EA + include Guardian),
#  compila, lancia una passata-lampo nel tester SOLO per far scattare
#  OnInit, e legge da solo le righe [A1][AUTOTEST] e [AUTOTEST].
#
#  Costruito sul gemello verifica_autotest_guardian.ps1 CON le correzioni
#  del verificatore del 22/08:
#   - il FAIL vero e' "*** FAIL ***" (checklist 55: un match generico su
#     FAIL prendeva i nomi tipo "fail-open"; e 'FAIL$' non matchava mai
#     perche' la riga finisce con ***);
#   - controllo POSITIVO del parser: 0 falliti senza nemmeno un PASS
#     riconosciuto = parser cieco = esito ROSSO, non verde;
#   - si legge SOLO cio' che il tester ha scritto DOPO il nostro avvio
#     (fotografia delle lunghezze dei log prima del lancio, lettura
#     dall'offset, offset tenuto PARI per l'UTF-16) - niente referti
#     stantii spacciati per freschi;
#   - si uccide SOLO il PID lanciato da noi, mai tutti i terminal64;
#   - WaitForExit con timeout (10 min), niente attese eterne.
#
#  PRETENDE MT5 E METAEDITOR CHIUSI. Sul PC di backtest.
#
#  USO: vedi la riga di lancio pinnata (viene data in chat con lo SHA).
# =====================================================================
param([switch]$UseSpare)
$ErrorActionPreference = "Stop"
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$INV = [System.Globalization.CultureInfo]::InvariantCulture
[System.Threading.Thread]::CurrentThread.CurrentCulture = $INV
$Avvio = Get-Date
$stamp = $Avvio.ToString("yyyyMMdd_HHmmss", $INV)

$EaNome  = "ABTG_IntradayMomentum"
$IncNome = "ABTG_PausaGuardian.mqh"
$Base    = "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/lavoro"

Write-Host "=== VERIFICO L'AUTOTEST DI $EaNome (motore A1) ===" -ForegroundColor Cyan

# --- guardia: MT5 / MetaEditor devono essere CHIUSI -------------------
$vivi = @(Get-Process -Name terminal64,metaeditor64 -ErrorAction SilentlyContinue)
if ($vivi.Count -gt 0) {
  Write-Host "RIFIUTO: MT5 o MetaEditor sono APERTI." -ForegroundColor Red
  foreach ($v in $vivi) { Write-Host ("  " + $v.ProcessName + " pid " + $v.Id) -ForegroundColor Red }
  exit 1
}

# --- trova il terminale (piccolo di default, -UseSpare per il -V3) ----
$allTerm = Get-ChildItem "C:\Program Files","C:\Program Files (x86)" -Recurse -Filter "terminal64.exe" -ErrorAction SilentlyContinue
if ($UseSpare) { $cand = $allTerm | Where-Object { $_.DirectoryName -like "*BCM Markets*" -and $_.DirectoryName -like "*-V3*" } | Select-Object -First 1 }
else           { $cand = $allTerm | Where-Object { $_.DirectoryName -like "*BCM Markets MT5 Terminal*" -and $_.DirectoryName -notlike "*-V3*" } | Select-Object -First 1 }
if (-not $cand) { $cand = $allTerm | Where-Object { $_.DirectoryName -like "*BCM Markets*" } | Select-Object -First 1 }
if (-not $cand) { Write-Host "Terminale BCM non trovato." -ForegroundColor Red; exit 1 }
$Terminal = $cand.FullName
$MetaEditor = Join-Path $cand.DirectoryName "metaeditor64.exe"

$instDir = $cand.DirectoryName
$termRoot = Join-Path $env:APPDATA "MetaQuotes\Terminal"
$DataFolder = Get-ChildItem $termRoot -Directory -ErrorAction SilentlyContinue | Where-Object {
  $o = Join-Path $_.FullName "origin.txt"
  (Test-Path $o) -and ((Get-Content $o -Raw).Trim() -ieq $instDir)
} | Select-Object -First 1 -ExpandProperty FullName
if (-not $DataFolder) { Write-Host "Cartella dati non trovata per questa istanza." -ForegroundColor Red; exit 1 }
Write-Host ("Istanza: " + $instDir) -ForegroundColor Gray

# --- scarico sorgente FRESCO (EA + include) con controlli -------------
$MqlExperts = Join-Path $DataFolder "MQL5\Experts"
$MqlInclude = Join-Path $DataFolder "MQL5\Include"
New-Item -ItemType Directory -Force -Path $MqlExperts | Out-Null
New-Item -ItemType Directory -Force -Path $MqlInclude | Out-Null
$destEa  = Join-Path $MqlExperts "$EaNome.mq5"
$destInc = Join-Path $MqlInclude $IncNome
$ex5     = [System.IO.Path]::ChangeExtension($destEa, ".ex5")

try {
  Invoke-WebRequest -Uri "$Base/mql5/Experts/$EaNome.mq5" -OutFile $destEa -UseBasicParsing -ErrorAction Stop
  Invoke-WebRequest -Uri "$Base/mql5/Include/$IncNome"    -OutFile $destInc -UseBasicParsing -ErrorAction Stop
} catch {
  Write-Host ("DOWNLOAD FALLITO: " + $_.Exception.Message) -ForegroundColor Red
  exit 1
}
$eaTesto = Get-Content -LiteralPath $destEa -Raw
$okVer   = ($eaTesto -match '#property\s+version\s+"1\.00"')
$okMagic = ($eaTesto -match 'InpMagic\s*=\s*772800')
$okAtst  = ($eaTesto -match '\[A1\]\[AUTOTEST\]')
if (-not ($okVer -and $okMagic -and $okAtst)) {
  Write-Host ("SORGENTE SBAGLIATO O VECCHIO: version1.00=" + $okVer + " magic772800=" + $okMagic + " autotest=" + $okAtst) -ForegroundColor Red
  Write-Host "  (cache di raw.githubusercontent ~5 min: aspetta e rilancia)" -ForegroundColor Yellow
  exit 1
}
$incTesto = Get-Content -LiteralPath $destInc -Raw
if ($incTesto -notmatch 'ABTG_PausaGuardian\s+v1\.40') {
  Write-Host "L'include scaricato NON e' la v1.40 attesa: mi fermo." -ForegroundColor Red
  exit 1
}
Write-Host "Sorgenti scaricati e controllati (EA v1.00 magic 772800, include v1.40)." -ForegroundColor Green

# --- compilo (invocazione DIRETTA, mai Start-Process: bug pagato 22/08)
$logCompile = [System.IO.Path]::ChangeExtension($destEa, ".log")
Remove-Item -LiteralPath $logCompile -Force -ErrorAction SilentlyContinue
& $MetaEditor "/compile:$destEa" "/log:$logCompile" | Out-Null
if (-not (Test-Path -LiteralPath $ex5)) {
  Write-Host "COMPILAZIONE FALLITA. Ultime righe del log:" -ForegroundColor Red
  Get-Content -LiteralPath $logCompile -ErrorAction SilentlyContinue | Select-Object -Last 25 | ForEach-Object { Write-Host ("  " + $_) -ForegroundColor Red }
  exit 1
}
Write-Host "Compilazione OK (.ex5 prodotto)." -ForegroundColor Green

# --- fotografia dei log del tester PRIMA del lancio (lunghezze) -------
$TesterRadici = @((Join-Path $DataFolder "Tester"), (Join-Path $env:APPDATA ("MetaQuotes\Tester\" + (Split-Path -Leaf $DataFolder))))
$primaLen = @{}
foreach ($rad in $TesterRadici) {
  if (-not (Test-Path -LiteralPath $rad)) { continue }
  foreach ($f in @(Get-ChildItem -LiteralPath $rad -Recurse -Filter "*.log" -File -ErrorAction SilentlyContinue)) { $primaLen[$f.FullName] = $f.Length }
}

# --- ini della passata-lampo (solo per OnInit; sandbox, niente live) --
$Work = Join-Path $env:USERPROFILE "Desktop"
if (-not (Test-Path $Work)) { $Work = $env:USERPROFILE }
$ini = Join-Path $Work ("verifica_a1_" + $stamp + ".ini")
@"
[Experts]
AllowLiveTrading=false
AllowDllImport=false

[Tester]
Expert=$EaNome.ex5
Symbol=NASUSD
Period=M5
Model=1
Optimization=0
FromDate=2026.06.01
ToDate=2026.06.10
ForwardMode=0
Deposit=100000
Currency=EUR
Leverage=100
ExecutionMode=0
ReplaceReport=1
ShutdownTerminal=1
Report=verifica_a1_${stamp}

[TesterInputs]
InpAutoTest=true||true||0||true||N
"@ | Set-Content -Path $ini -Encoding ASCII

Write-Host "Lancio la passata-lampo (NASUSD M5, 8 giorni, solo per l'autotest)..." -ForegroundColor Cyan
$proc = Start-Process -FilePath $Terminal -ArgumentList "/config:`"$ini`"" -PassThru
$fine = $proc.WaitForExit(600000)
if (-not $fine) {
  Write-Host "TIMEOUT 10 minuti: chiudo il terminale lanciato (solo quello)." -ForegroundColor Yellow
  Stop-Process -Id $proc.Id -Force -ErrorAction SilentlyContinue
}
Start-Sleep -Seconds 2

# --- leggo SOLO cio' che e' stato scritto DOPO la fotografia ----------
function Leggi-Nuovo($path, $da) {
  try {
    $fs = [IO.File]::Open($path, [IO.FileMode]::Open, [IO.FileAccess]::Read, [IO.FileShare]::ReadWrite)
    $len = $fs.Length
    if ($da % 2 -ne 0) { $da = $da - 1 }
    if ($da -ge $len) { $fs.Close(); return "" }
    if ($da -gt 0) { [void]$fs.Seek($da, [IO.SeekOrigin]::Begin) }
    $n = [int]($len - $da); $b = New-Object byte[] $n; $letti = 0
    while ($letti -lt $n) { $q = $fs.Read($b, $letti, $n - $letti); if ($q -le 0) { break }; $letti += $q }
    $fs.Close()
  } catch { return "" }
  if ($b.Count -lt 4) { return "" }
  $utf16 = ($b[0] -eq 0xFF -and $b[1] -eq 0xFE)
  if (-not $utf16) {
    $zeri = 0; $n2 = [math]::Min(400, $b.Count)
    for ($i = 1; $i -lt $n2; $i += 2) { if ($b[$i] -eq 0) { $zeri++ } }
    $utf16 = ($zeri -gt ($n2/4))
  }
  if ($utf16) { return [Text.Encoding]::Unicode.GetString($b) }
  return [Text.Encoding]::UTF8.GetString($b)
}

$righeAutotest = New-Object System.Collections.ArrayList
foreach ($rad in $TesterRadici) {
  if (-not (Test-Path -LiteralPath $rad)) { continue }
  foreach ($f in @(Get-ChildItem -LiteralPath $rad -Recurse -Filter "*.log" -File -ErrorAction SilentlyContinue)) {
    $da = 0
    if ($primaLen.ContainsKey($f.FullName)) { $da = $primaLen[$f.FullName] }
    $testo = Leggi-Nuovo $f.FullName $da
    if (-not $testo) { continue }
    foreach ($r in ($testo -split "`r?`n")) {
      if ($r -match "\[AUTOTEST\]") { [void]$righeAutotest.Add($r.Trim()) }
    }
  }
}

Write-Host ""
if ($righeAutotest.Count -eq 0) {
  Write-Host "NESSUNA RIGA [AUTOTEST] SCRITTA DOPO IL NOSTRO AVVIO." -ForegroundColor Red
  Write-Host "Possibili cause: il tester non e' partito (storico NASUSD nel periodo? dialogo in avvio?)." -ForegroundColor Yellow
} else {
  Write-Host ("Righe [AUTOTEST] nuove trovate: " + $righeAutotest.Count) -ForegroundColor Green
  foreach ($r in $righeAutotest) { Write-Host ("  " + $r) }
}

# --- verdetto: FAIL vero = *** FAIL ***; controllo positivo sui PASS --
$fallite = @($righeAutotest | Where-Object { $_ -cmatch '\*\*\*\s*FAIL\s*\*\*\*' })
$passate = @($righeAutotest | Where-Object { $_.TrimEnd() -cmatch 'PASS$' })
$haA1    = @($righeAutotest | Where-Object { $_ -match '\[A1\]\[AUTOTEST\]' }).Count -gt 0

Write-Host ""
Write-Host ("blocco [A1] visto      : " + $haA1)          -ForegroundColor (@{$true="Green";$false="Red"}[$haA1])
Write-Host ("casi PASS riconosciuti : " + $passate.Count) -ForegroundColor (@{$true="Green";$false="Red"}[$passate.Count -gt 0])
Write-Host ("casi *** FAIL ***      : " + $fallite.Count) -ForegroundColor (@{$true="Red";$false="Green"}[$fallite.Count -gt 0])
if ($passate.Count -eq 0 -and $righeAutotest.Count -gt 0) {
  Write-Host "PARSER CIECO: righe trovate ma nessun verdetto PASS riconosciuto -> esito ROSSO." -ForegroundColor Red
}

$esitoOk = ($righeAutotest.Count -gt 0) -and ($haA1) -and ($passate.Count -gt 0) -and ($fallite.Count -eq 0)
$esito = "FALLITO"
if ($esitoOk) { $esito = "OK" }

# --- raccolta sul Desktop + zip ---------------------------------------
$cart = Join-Path $Work ("verifica_a1_" + $stamp)
$zip  = Join-Path $Work ("verifica_a1_" + $stamp + ".zip")
try {
  New-Item -ItemType Directory -Force -Path $cart | Out-Null
  $out = New-Object System.Collections.ArrayList
  [void]$out.Add("data: " + $Avvio.ToString("yyyy-MM-dd HH:mm:ss", $INV))
  [void]$out.Add("EA: $EaNome v1.00 magic 772800")
  [void]$out.Add("blocco [A1] visto: " + $haA1)
  [void]$out.Add("PASS riconosciuti: " + $passate.Count)
  [void]$out.Add("*** FAIL ***: " + $fallite.Count)
  [void]$out.Add("esito: " + $esito)
  [void]$out.Add("")
  foreach ($r in $righeAutotest) { [void]$out.Add($r) }
  $out | Set-Content -Path (Join-Path $cart "autotest_a1.txt") -Encoding ASCII
  if (Test-Path $logCompile) { Copy-Item $logCompile -Destination (Join-Path $cart "compile_a1.log") -Force -ErrorAction SilentlyContinue }
  if (Test-Path $zip) { Remove-Item $zip -Force }
  Compress-Archive -Path (Join-Path $cart "*") -DestinationPath $zip -Force
  Write-Host ""
  Write-Host ("zip da mandare: " + $zip) -ForegroundColor Green
} catch {
  Write-Host ("Raccolta fallita: " + $_.Exception.Message + " - mandami l'output qui sopra.") -ForegroundColor Yellow
}

Write-Host ""
Write-Host ("ESITO: " + $esito) -ForegroundColor Cyan
if ($esitoOk) { exit 0 }
exit 1
