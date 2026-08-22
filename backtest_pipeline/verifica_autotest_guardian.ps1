# =====================================================================
#  verifica_autotest_guardian.ps1 -- verifica AUTOMATICA dell'autotest
#  di ABTG_PausaGuardian.mqh (freno P1 v1.30) senza toccare a mano
#  MetaEditor o lo Strategy Tester.
#
#  PERCHE' ESISTE (22/08/2026): Claudio ha girato l'autotest a mano e
#  gli e' uscito "v1.20" invece di "v1.30" -- l'.ex5 di ABTG_CrossEma
#  era compilato PRIMA che il .mqh fosse aggiornato, e MT5 non si
#  accorge da solo che un file INCLUSO (non il .mq5 principale) e'
#  cambiato. Questo script scarica sorgente FRESCO (EA + .mqh), lo
#  ricompila SEMPRE, lancia un test non-visuale veloce (Model=1, pochi
#  giorni, AllowLiveTrading=false) solo per far scattare OnInit(), e
#  legge da solo il log del tester cercando le righe [AUTOTEST].
#
#  PRETENDE MT5 CHIUSO (compila E lancia un terminale).
#
#  USO (sul PC/VPS dove sta il terminale piccolo):
#    irm https://raw.githubusercontent.com/claudiospadaro12/GITHUB/lavoro/backtest_pipeline/verifica_autotest_guardian.ps1 -OutFile verifica_autotest_guardian.ps1
#    powershell -ExecutionPolicy Bypass -File .\verifica_autotest_guardian.ps1
# =====================================================================
param([switch]$UseSpare)
$ErrorActionPreference = "Stop"
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$INV = [System.Globalization.CultureInfo]::InvariantCulture
$Avvio = Get-Date
$stamp = $Avvio.ToString("yyyyMMdd_HHmmss", $INV)

$EaNome   = "ABTG_CrossEma"
$IncNome  = "ABTG_PausaGuardian.mqh"
$Base     = "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/lavoro"

Write-Host "=== VERIFICO L'AUTOTEST DI $IncNome tramite $EaNome ===" -ForegroundColor Cyan

# --- guardia: MT5 / MetaEditor devono essere CHIUSI -------------------
$vivi = @(Get-Process -Name terminal64,metaeditor64 -ErrorAction SilentlyContinue)
if ($vivi.Count -gt 0) {
  Write-Host "RIFIUTO: MT5 o MetaEditor sono APERTI." -ForegroundColor Red
  foreach ($v in $vivi) { Write-Host ("  " + $v.ProcessName + " pid " + $v.Id) -ForegroundColor Red }
  Write-Host "  Chiudi ENTRAMBI i terminali e MetaEditor, poi rilancia." -ForegroundColor Yellow
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
Write-Host ("Cartella dati (hash): " + (Split-Path -Leaf $DataFolder)) -ForegroundColor Gray

# --- scarico sorgente FRESCO (EA + include) e verifico che non sia vecchio
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
$incTesto = Get-Content -LiteralPath $destInc -Raw
$verIncM = [regex]::Match($incTesto, 'ABTG_PausaGuardian\s+v([0-9.]+)\s*--\s*nucleo puro')
$verInc = if ($verIncM.Success) { $verIncM.Groups[1].Value } else { "?" }
Write-Host ("Sorgente scaricato: ABTG_PausaGuardian.mqh dichiara v" + $verInc) -ForegroundColor Gray
if ($verInc -ne "1.30") {
  Write-Host ("ATTENZIONE: il sorgente scaricato NON e' v1.30 (e' v" + $verInc + "). Puo' essere cache del CDN: aspetta un minuto e rilancia.") -ForegroundColor Yellow
}

# --- compilo SEMPRE (invocazione diretta, non Start-Process: vedi ORB) --
Remove-Item -LiteralPath $ex5 -Force -ErrorAction SilentlyContinue
$logCompile = [System.IO.Path]::ChangeExtension($destEa, ".log")
Remove-Item -LiteralPath $logCompile -Force -ErrorAction SilentlyContinue
& $MetaEditor "/compile:$destEa" "/log:$logCompile" | Out-Null
$rcCompile = $LASTEXITCODE
if (-not (Test-Path -LiteralPath $ex5)) {
  Write-Host ("COMPILAZIONE FALLITA (rc=" + $rcCompile + "). Ultime righe del log:") -ForegroundColor Red
  Get-Content -LiteralPath $logCompile -ErrorAction SilentlyContinue | Select-Object -Last 20 | ForEach-Object { Write-Host ("  " + $_) -ForegroundColor Red }
  exit 1
}
Write-Host "Compilazione OK." -ForegroundColor Green

# --- pulisco i vecchi log del tester per questa cartella dati, cosi'
#     dopo prendo SOLO quello nuovo senza ambiguita' --------------------
$testerRoot = Join-Path $env:APPDATA ("MetaQuotes\Tester\" + (Split-Path -Leaf $DataFolder))
$primaFile = @()
if (Test-Path $testerRoot) {
  $primaFile = @(Get-ChildItem $testerRoot -Recurse -Filter "*.log" -ErrorAction SilentlyContinue | Select-Object -ExpandProperty FullName)
}

# --- costruisco l'ini per un test non-visuale VELOCE, solo per OnInit --
$Work = if ($PSScriptRoot) { $PSScriptRoot } else { Join-Path $env:USERPROFILE "Desktop" }
New-Item -ItemType Directory -Force -Path $Work | Out-Null
$ini = Join-Path $Work ("verifica_autotest_" + $stamp + ".ini")
@"
[Experts]
AllowLiveTrading=false
AllowDllImport=false

[Tester]
Expert=$EaNome.ex5
Symbol=EURUSD
Period=M5
Model=1
Optimization=0
FromDate=2026.08.10
ToDate=2026.08.20
ForwardMode=0
Deposit=100000
Currency=EUR
Leverage=100
ExecutionMode=0
ReplaceReport=1
ShutdownTerminal=1
Report=verifica_autotest_${stamp}

[TesterInputs]
InpAutoTest=true||true||0||true||N
"@ | Set-Content -Path $ini -Encoding ASCII

Write-Host "Lancio il test (rapido, solo per far scattare OnInit)..." -ForegroundColor Cyan
(Start-Process -FilePath $Terminal -ArgumentList "/config:`"$ini`"" -PassThru).WaitForExit()
for ($w = 0; $w -lt 30; $w++) {
  if (-not (Get-Process -Name terminal64 -ErrorAction SilentlyContinue)) { break }
  Start-Sleep -Seconds 2
}
Get-Process -Name terminal64 -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
Start-Sleep -Seconds 2

# --- trovo il log NUOVO (quello che non c'era prima) -------------------
function Leggi-Testo($path) {
  try {
    $fs = [IO.File]::Open($path, [IO.FileMode]::Open, [IO.FileAccess]::Read, [IO.FileShare]::ReadWrite)
    $b  = New-Object byte[] $fs.Length
    [void]$fs.Read($b, 0, $b.Length)
    $fs.Close()
  } catch { return "" }
  if ($b.Count -lt 4) { return "" }
  $utf16 = ($b[0] -eq 0xFF -and $b[1] -eq 0xFE)
  if (-not $utf16) {
    $zeri = 0; $n = [math]::Min(400, $b.Count)
    for ($i = 1; $i -lt $n; $i += 2) { if ($b[$i] -eq 0) { $zeri++ } }
    $utf16 = ($zeri -gt ($n/4))
  }
  if ($utf16) { return [Text.Encoding]::Unicode.GetString($b) }
  return [Text.Encoding]::UTF8.GetString($b)
}

$dopoFile = @()
if (Test-Path $testerRoot) {
  $dopoFile = @(Get-ChildItem $testerRoot -Recurse -Filter "*.log" -ErrorAction SilentlyContinue | Select-Object -ExpandProperty FullName)
}
$nuovi = @($dopoFile | Where-Object { $primaFile -notcontains $_ })
if ($nuovi.Count -eq 0) {
  # fallback: il log piu' recente di tutti, se non troviamo un "nuovo" netto
  $tutti = @(Get-ChildItem $testerRoot -Recurse -Filter "*.log" -ErrorAction SilentlyContinue | Sort-Object LastWriteTime -Descending)
  if ($tutti.Count -gt 0) { $nuovi = @($tutti[0].FullName) }
}

$righeAutotest = New-Object System.Collections.ArrayList
foreach ($f in $nuovi) {
  $testo = Leggi-Testo $f
  if (-not $testo) { continue }
  foreach ($r in ($testo -split "`r?`n")) {
    if ($r -match "\[AUTOTEST\]") { [void]$righeAutotest.Add($r.Trim()) }
  }
}

Write-Host ""
if ($righeAutotest.Count -eq 0) {
  Write-Host "NESSUNA RIGA [AUTOTEST] TROVATA." -ForegroundColor Red
  Write-Host ("Log controllati: " + $nuovi.Count + " sotto " + $testerRoot) -ForegroundColor Yellow
  Write-Host "Possibili cause: InpAutoTest non passato correttamente, o il test non ha avuto storico per EURUSD nel periodo." -ForegroundColor Yellow
} else {
  Write-Host ("Trovate " + $righeAutotest.Count + " righe [AUTOTEST]:") -ForegroundColor Green
  foreach ($r in $righeAutotest) { Write-Host ("  " + $r) }
}

$fallite = @($righeAutotest | Where-Object { $_ -match "FAIL" })
$haV130  = @($righeAutotest | Where-Object { $_ -match "v1\.30" }).Count -gt 0
$haP1    = @($righeAutotest | Where-Object { $_ -match "FRENO P1" }).Count -gt 0

Write-Host ""
Write-Host ("versione v1.30 vista nel log : " + $haV130) -ForegroundColor (@{$true="Green";$false="Red"}[$haV130])
Write-Host ("blocco FRENO P1 visto        : " + $haP1)   -ForegroundColor (@{$true="Green";$false="Red"}[$haP1])
Write-Host ("righe con FAIL               : " + $fallite.Count) -ForegroundColor (@{$true="Red";$false="Green"}[$fallite.Count -gt 0])

# --- raccolta sul Desktop + zip (regola delle righe di lancio) --------
function Trova-Desktop {
  foreach ($p in @([Environment]::GetFolderPath("Desktop"), (Join-Path $env:USERPROFILE "Desktop"), (Join-Path $env:USERPROFILE "OneDrive\Desktop"))) {
    if ($p -and (Test-Path $p)) { return $p }
  }
  return $env:USERPROFILE
}
$desktop = Trova-Desktop
$cart = Join-Path $desktop ("verifica_autotest_" + $stamp)
$zip  = Join-Path $desktop ("verifica_autotest_" + $stamp + ".zip")
try {
  New-Item -ItemType Directory -Force -Path $cart | Out-Null
  $out = New-Object System.Collections.ArrayList
  [void]$out.Add("data: " + $Avvio.ToString("yyyy-MM-dd HH:mm:ss", $INV))
  [void]$out.Add("versione .mqh scaricata: " + $verInc)
  [void]$out.Add("v1.30 vista nel log: " + $haV130)
  [void]$out.Add("blocco FRENO P1 visto: " + $haP1)
  [void]$out.Add("righe con FAIL: " + $fallite.Count)
  [void]$out.Add("")
  foreach ($r in $righeAutotest) { [void]$out.Add($r) }
  $out | Set-Content -Path (Join-Path $cart "autotest.txt") -Encoding ASCII
  if (Test-Path $zip) { Remove-Item $zip -Force }
  Compress-Archive -Path (Join-Path $cart "*") -DestinationPath $zip -Force
  Write-Host ""
  Write-Host ("zip da mandare: " + $zip) -ForegroundColor Green
} catch {
  Write-Host ("Raccolta fallita: " + $_.Exception.Message) -ForegroundColor Yellow
  Write-Host "Mandami direttamente l'output qui sopra." -ForegroundColor Yellow
}

if ($righeAutotest.Count -eq 0 -or $fallite.Count -gt 0 -or -not $haV130) { exit 1 }
exit 0
