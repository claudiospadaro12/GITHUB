# =====================================================================
#  verifica_autotest_guardian.ps1 -- verifica AUTOMATICA dell'autotest
#  di ABTG_PausaGuardian.mqh (freno P1 + stop S1, v1.40) senza toccare
#  a mano MetaEditor o lo Strategy Tester.
#  MARCATORE-VERSIONE-SCRIPT: FAIL_TRIPLA_STELLA_v2
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
#  CORREZIONE v2 (22/08/2026, dopo controllo di sicurezza dedicato):
#  il verdetto vero che scrive ABTG_AutotestCaso() e' "*** FAIL ***",
#  non "FAIL" a fine riga -- il gate v1 non avrebbe MAI intercettato
#  un fallimento vero (l'ha solo trovato nei nomi tipo "fail-open",
#  che sono PARTE del nome del caso e finiscono comunque in PASS).
#  Aggiunto anche un controllo POSITIVO (0 PASS trovati = parser
#  cieco, non "tutto ok"), l'isolamento del log per LUNGHEZZA prima/
#  dopo (non piu' per posizione dell'ultimo blocco: un rilancio senza
#  esecuzione vera avrebbe fatto leggere il blocco vecchio come
#  fresco), backup/ripristino del binario se la compilazione fallisce,
#  pulizia della cache del tester, e uccisione mirata del SOLO
#  processo lanciato da questo script (mai uno spazzolone su tutti i
#  terminal64 -- ce ne puo' essere un altro aperto, es. il -V3/100k).
#
#  AGGIORNAMENTO 23/08/2026 (S1): l'include e' passato a v1.40 (stop a
#  OBIETTIVO RAGGIUNTO). Qui sono cambiate tre cose e basta: il pin di
#  versione (1.30 -> 1.40), un gate nuovo che pretende di vedere anche il
#  blocco "STOP S1" nel log, e il numero di casi ATTESI stampato a video
#  (75 per passata = 19 B1/C1 + 26 P1 + 30 S1). Il conteggio resta
#  INFORMATIVO e non fa fallire il gate: il verdetto fatale e' sempre
#  "*** FAIL ***" oppure zero righe lette.
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
if ($verInc -ne "1.40") {
  Write-Host ("SCARICATA LA VERSIONE SBAGLIATA: v" + $verInc + " invece di v1.40 (cache del CDN? aspetta un minuto e rilancia). NON proseguo.") -ForegroundColor Red
  exit 1
}

# --- backup DATATO del binario/sorgente prima di toccarli (checklist 12+54)
$bakEa  = $destEa + ".prima_" + $stamp
$bakEx5 = $ex5    + ".prima_" + $stamp
if (Test-Path -LiteralPath $destEa) { Copy-Item -LiteralPath $destEa -Destination $bakEa -Force }
if (Test-Path -LiteralPath $ex5)    { Copy-Item -LiteralPath $ex5    -Destination $bakEx5 -Force }

# --- compilo SEMPRE (invocazione diretta, non Start-Process: vedi ORB) --
Remove-Item -LiteralPath $ex5 -Force -ErrorAction SilentlyContinue
$logCompile = [System.IO.Path]::ChangeExtension($destEa, ".log")
Remove-Item -LiteralPath $logCompile -Force -ErrorAction SilentlyContinue
& $MetaEditor "/compile:$destEa" "/log:$logCompile" | Out-Null
$rcCompile = $LASTEXITCODE
if (-not (Test-Path -LiteralPath $ex5)) {
  Write-Host ("COMPILAZIONE FALLITA (rc=" + $rcCompile + "). Ultime righe del log:") -ForegroundColor Red
  Get-Content -LiteralPath $logCompile -ErrorAction SilentlyContinue | Select-Object -Last 20 | ForEach-Object { Write-Host ("  " + $_) -ForegroundColor Red }
  if (Test-Path -LiteralPath $bakEa) {
    Copy-Item -LiteralPath $bakEa -Destination $destEa -Force
    Write-Host "Sorgente RIPRISTINATO dal backup (resta allineato al binario vecchio, se c'era)." -ForegroundColor Yellow
  }
  exit 1
}
Write-Host "Compilazione OK." -ForegroundColor Green

# --- fotografo la LUNGHEZZA di ogni log gia' esistente: dopo il test
#     leggo SOLO i byte scritti dopo, cosi' non serve indovinare quale
#     file e' "nuovo" ne' affidarmi a un'ancora di testo nell'ultimo
#     blocco (un rilancio senza esecuzione vera farebbe rileggere il
#     blocco vecchio come fresco) ------------------------------------
$TesterRadici = @(
  (Join-Path $DataFolder "Tester"),
  (Join-Path $instDir "Tester"),
  (Join-Path $env:APPDATA "MetaQuotes\Tester")
)
$primaLen = @{}
foreach ($rad in $TesterRadici) {
  if (-not (Test-Path -LiteralPath $rad)) { continue }
  foreach ($f in @(Get-ChildItem -LiteralPath $rad -Recurse -Filter "*.log" -File -ErrorAction SilentlyContinue)) {
    $primaLen[$f.FullName] = $f.Length
  }
}

# --- pulisco la cache del tester per questa cartella dati: senza,
#     una passata con stessi input/simbolo/periodo puo' essere
#     RIPESCATA dalla cache e non esegue OnInit -> zero righe stampate
#     (checklist 38). MAI toccare bases\<server>\ticks. -----------------
$cacheDir = Join-Path $DataFolder "Tester\cache"
if (Test-Path -LiteralPath $cacheDir) {
  Remove-Item -LiteralPath (Join-Path $cacheDir "*") -Recurse -Force -ErrorAction SilentlyContinue
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
$proc = Start-Process -FilePath $Terminal -ArgumentList "/config:`"$ini`"" -PassThru
$uscitoDaSolo = $proc.WaitForExit(600000)
if (-not $uscitoDaSolo) {
  Write-Host "Il terminale non e' uscito da solo in 10 minuti (dialogo bloccato in avvio?). Lo chiudo IO, solo questo PID." -ForegroundColor Yellow
  try { $proc.Kill() } catch { }
} else {
  # ShutdownTerminal=1 di solito chiude da solo; se resta un residuo dello
  # STESSO pid (raro) lo aspetto un altro po' prima di forzare
  for ($w = 0; $w -lt 10; $w++) {
    $ancoraVivo = Get-Process -Id $proc.Id -ErrorAction SilentlyContinue
    if (-not $ancoraVivo) { break }
    Start-Sleep -Seconds 2
  }
  $ancoraVivo = Get-Process -Id $proc.Id -ErrorAction SilentlyContinue
  if ($ancoraVivo) { try { Stop-Process -Id $proc.Id -Force -ErrorAction SilentlyContinue } catch { } }
}
Start-Sleep -Seconds 2

# --- leggo SOLO i byte scritti dopo la fotografia (offset pari, UTF-16) -
function Leggi-TestoNuovo($path, $da) {
  try {
    $fs = [IO.File]::Open($path, [IO.FileMode]::Open, [IO.FileAccess]::Read, [IO.FileShare]::ReadWrite)
  } catch { return "" }
  $len = $fs.Length
  if ($da % 2 -ne 0) { $da = $da - 1 }
  if ($da -lt 0) { $da = 0 }
  if ($da -ge $len) { $fs.Close(); return "" }
  if ($da -gt 0) { [void]$fs.Seek($da, [IO.SeekOrigin]::Begin) }
  $n = [int]($len - $da)
  $b = New-Object byte[] $n
  $letti = 0
  while ($letti -lt $n) {
    $q = $fs.Read($b, $letti, $n - $letti)
    if ($q -le 0) { break }
    $letti += $q
  }
  $fs.Close()
  if ($b.Count -lt 4) { return "" }
  $utf16 = ($da -eq 0 -and $b[0] -eq 0xFF -and $b[1] -eq 0xFE)
  if (-not $utf16) {
    $zeri = 0; $n2 = [math]::Min(400, $b.Count)
    for ($i = 1; $i -lt $n2; $i += 2) { if ($b[$i] -eq 0) { $zeri++ } }
    $utf16 = ($zeri -gt ($n2/4))
  }
  if ($utf16) { return [Text.Encoding]::Unicode.GetString($b) }
  return [Text.Encoding]::UTF8.GetString($b)
}

$righeAutotest = New-Object System.Collections.ArrayList
$logLetti = 0
foreach ($rad in $TesterRadici) {
  if (-not (Test-Path -LiteralPath $rad)) { continue }
  foreach ($f in @(Get-ChildItem -LiteralPath $rad -Recurse -Filter "*.log" -File -ErrorAction SilentlyContinue)) {
    $da = 0
    if ($primaLen.ContainsKey($f.FullName)) { $da = $primaLen[$f.FullName] }
    if ($f.Length -le $da) { continue }
    $logLetti++
    $testo = Leggi-TestoNuovo $f.FullName $da
    if (-not $testo) { continue }
    foreach ($r in ($testo -split "`r?`n")) {
      if ($r -match "\[AUTOTEST\]") { [void]$righeAutotest.Add($r.Trim()) }
    }
  }
}

Write-Host ""
if ($righeAutotest.Count -eq 0) {
  Write-Host "NESSUNA RIGA [AUTOTEST] TROVATA." -ForegroundColor Red
  Write-Host ("Log cresciuti trovati: " + $logLetti) -ForegroundColor Yellow
  Write-Host "Possibili cause: InpAutoTest non passato correttamente, storico EURUSD assente nel periodo, o il terminale non e' proprio partito." -ForegroundColor Yellow
} else {
  Write-Host ("Trovate " + $righeAutotest.Count + " righe [AUTOTEST]:") -ForegroundColor Green
  foreach ($r in $righeAutotest) { Write-Host ("  " + $r) }
}

# il verdetto vero che scrive ABTG_AutotestCaso() e' "*** FAIL ***" (non
# "FAIL" a fine riga): un match generico su "FAIL" prende anche
# descrizioni come "fail-open" che sono PARTE DEL NOME del caso (e
# finiscono comunque in PASS) - il bug esatto trovato il 22/08: 12 "FAIL"
# tutti falsi allarmi cosi', e il pattern vecchio non avrebbe MAI
# intercettato un fallimento vero.
$fallite = @($righeAutotest | Where-Object { $_ -cmatch '\*\*\*\s*FAIL\s*\*\*\*' })
$passate = @($righeAutotest | Where-Object { $_.TrimEnd() -cmatch 'PASS$' })
$haV140  = @($righeAutotest | Where-Object { $_ -match "v1\.40" }).Count -gt 0
$haP1    = @($righeAutotest | Where-Object { $_ -match "FRENO P1" }).Count -gt 0
$haS1    = @($righeAutotest | Where-Object { $_ -match "STOP S1" }).Count -gt 0

Write-Host ""
Write-Host ("casi PASS trovati            : " + $passate.Count) -ForegroundColor (@{$true="Green";$false="Red"}[$passate.Count -gt 0])
Write-Host ("versione v1.40 vista nel log : " + $haV140) -ForegroundColor (@{$true="Green";$false="Red"}[$haV140])
Write-Host ("blocco FRENO P1 visto        : " + $haP1)   -ForegroundColor (@{$true="Green";$false="Red"}[$haP1])
Write-Host ("blocco STOP S1 visto         : " + $haS1)   -ForegroundColor (@{$true="Green";$false="Red"}[$haS1])
Write-Host ("casi attesi nel sorgente     : 75 (19 B1/C1 + 26 P1 + 30 S1) per passata") -ForegroundColor Gray
Write-Host ("righe *** FAIL ***           : " + $fallite.Count) -ForegroundColor (@{$true="Red";$false="Green"}[$fallite.Count -gt 0])
if ($passate.Count -eq 0 -and $righeAutotest.Count -gt 0) {
  Write-Host "PARSER CIECO: righe [AUTOTEST] trovate ma nessun verdetto PASS riconosciuto - non fidarti di questo esito." -ForegroundColor Red
}

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
  [void]$out.Add("casi PASS trovati: " + $passate.Count)
  [void]$out.Add("v1.40 vista nel log: " + $haV140)
  [void]$out.Add("blocco FRENO P1 visto: " + $haP1)
  [void]$out.Add("blocco STOP S1 visto: " + $haS1)
  [void]$out.Add("casi attesi nel sorgente: 75 per passata (19 B1/C1 + 26 P1 + 30 S1)")
  [void]$out.Add("righe *** FAIL ***: " + $fallite.Count)
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

if ($righeAutotest.Count -eq 0 -or $passate.Count -eq 0 -or $fallite.Count -gt 0 -or -not $haV140 -or -not $haP1 -or -not $haS1) { exit 1 }
exit 0
