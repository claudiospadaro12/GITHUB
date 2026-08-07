# =====================================================================
#  controllo_flotta.ps1  --  VERDE o ROSSO prima di ogni volo
# ---------------------------------------------------------------------
#  PERCHE' ESISTE (07/08/2026)
#  In tre giorni sono venuti fuori: breakeven annidato su 20 EA, guardia
#  "un trade al giorno" mai chiamata su 9, un'etichetta di parametro che
#  diceva il contrario di quello che faceva, due EA che erano lo stesso EA
#  a size doppia, e due configurazioni scelte in campione che fuori
#  campione erano le PEGGIORI delle rispettive tabelle.
#
#  Nessuna di queste e' stata trovata guardando meglio. Sono state trovate
#  tutte da un controllo MECCANICO. E le tre volte che ho guardato con
#  attenzione - posizioni "contemporanee", "ritardo di un'ora", SELL STOP
#  "mancante" - erano tutti e tre FALSI ALLARMI.
#
#  Quindi "controllare tutto per filo e per segno" non puo' voler dire
#  stare piu' attenti: deve voler dire un controllo che gira da solo.
#
#  COSA VERIFICA
#   1. cosa gira DAVVERO (riga CONFIG IN USO del log) contro cosa DEVE
#      girare (flotta_attesa.csv, versionato sul repo)
#   2. l'.ex5 e' piu' recente del .mq5, e l'EA e' ripartito DOPO
#   3. esposizione per simbolo sotto il tetto dichiarato
#   4. nessun EA in stato "doppione" o "bocciato" sopra il rischio minimo
#   5. ogni EA acceso ha una FONTE di misura, o e' dichiarato non validato
#
#  USO (sul VPS, MT5 puo' restare aperto):
#    powershell -ExecutionPolicy Bypass -File .\controllo_flotta.ps1
#    powershell -ExecutionPolicy Bypass -File .\controllo_flotta.ps1 -Tetto 3.0
#
#  ⚠️ La riga CONFIG IN USO stampa "rangemode" e "lati" solo dagli EA
#  ricompilati dal 07/08 in poi. Sui vecchi quei campi mancano: lo script
#  lo dice invece di dare un falso allarme.
# =====================================================================
param(
  [double]$Tetto  = 3.0,      # tetto di rischio sommato per simbolo, in %
  [string]$Data   = "",       # AAAAMMGG. Vuoto = oggi
  [string]$Attesa = "",       # percorso di flotta_attesa.csv. Vuoto = scarica dal repo
  [switch]$Brutale            # tratta anche i gialli come rossi
)
$ErrorActionPreference = "Continue"
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
if (-not $Data) { $Data = (Get-Date).ToString("yyyyMMdd") }

$Rossi  = New-Object System.Collections.ArrayList
$Gialli = New-Object System.Collections.ArrayList
function Rosso($t)  { [void]$Rossi.Add($t) }
function Giallo($t) { [void]$Gialli.Add($t) }

Write-Host ""
Write-Host "=====================================================" -ForegroundColor Cyan
Write-Host " CONTROLLO FLOTTA - $Data" -ForegroundColor Cyan
Write-Host "=====================================================" -ForegroundColor Cyan

# --- 1) la verita' dichiarata -----------------------------------------
if (-not $Attesa) {
  $Attesa = Join-Path $env:TEMP "flotta_attesa.csv"
  try {
    Invoke-WebRequest -UseBasicParsing -Uri "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/lavoro/backtest_pipeline/flotta_attesa.csv" -OutFile $Attesa
  } catch {
    Write-Host "Non riesco a scaricare flotta_attesa.csv dal repo." -ForegroundColor Red; exit 1
  }
}
if (-not (Test-Path $Attesa)) { Write-Host "flotta_attesa.csv non trovato." -ForegroundColor Red; exit 1 }

$righeAttesa = @(Get-Content $Attesa | Where-Object { $_ -notmatch '^\s*#' -and $_ -match ';' })
$Attese = @($righeAttesa | Select-Object -Skip 1 | ForEach-Object {
  $c = $_ -split ';'
  if ($c.Count -ge 11) {
    [pscustomobject]@{
      ea=$c[0].Trim(); simbolo=$c[1].Trim(); stato=$c[2].Trim(); rischio=$c[3].Trim()
      motore=$c[4].Trim(); rangemode=$c[5].Trim(); range=$c[6].Trim(); buffer=$c[7].Trim()
      lati=$c[8].Trim(); trail=$c[9].Trim(); fonte=$c[10].Trim()
    }
  }
})
Write-Host "  righe dichiarate in flotta_attesa.csv: $($Attese.Count)" -ForegroundColor Gray

# --- 2) cosa gira davvero: ultima CONFIG IN USO per EA ----------------
function Leggi-Log($path) {
  foreach ($enc in @("Unicode","UTF8","Default")) {
    try {
      $r = Get-Content -Path $path -Encoding $enc -ErrorAction Stop
      if ($r | Select-String -Pattern "\d{2}:\d{2}:\d{2}" -Quiet) { return $r }
    } catch { }
  }
  return @()
}
$termRoot = Join-Path $env:APPDATA "MetaQuotes\Terminal"
$Vive = @{}
foreach ($dir in (Get-ChildItem $termRoot -Directory -ErrorAction SilentlyContinue)) {
  $f = Join-Path $dir.FullName "MQL5\Logs\$Data.log"
  if (-not (Test-Path $f)) { continue }
  foreach ($riga in (Leggi-Log $f)) {
    if ($riga -notmatch 'CONFIG IN USO ->') { continue }
    if ($riga -notmatch '\[([^\]]+)\]\s+CONFIG IN USO ->\s*(.+)$') { continue }
    $nome  = $matches[1].Trim()
    $corpo = $matches[2]
    $campi = @{}
    foreach ($pezzo in ($corpo -split '\|')) {
      $kv = $pezzo.Trim() -split '=', 2
      if ($kv.Count -eq 2) { $campi[$kv[0].Trim()] = $kv[1].Trim() }
    }
    $ora = ""
    if ($riga -match '(\d{2}:\d{2}:\d{2})') { $ora = $matches[1] }
    $campi["_ora"] = $ora
    $Vive[$nome] = $campi          # l'ULTIMA riga vince: e' l'avvio piu' recente
  }
}
Write-Host "  EA che hanno scritto CONFIG IN USO oggi: $($Vive.Count)" -ForegroundColor Gray
if ($Vive.Count -eq 0) {
  Rosso "Nessun EA ha scritto CONFIG IN USO oggi: o non sono ripartiti, o il log e' di un altro giorno (-Data AAAAMMGG)."
}

# --- 3) confronto campo per campo -------------------------------------
function Confronta($nomeEa, $etichetta, $atteso, $reale, $campoLog) {
  if ($atteso -eq '*' -or $atteso -eq '') { return }
  if ($null -eq $reale) { Giallo "${nomeEa}: il log non riporta '$campoLog' (EA non ancora ricompilato dal 07/08)"; return }
  if ($reale -ne $atteso) { Rosso "${nomeEa}: $etichetta = '$reale' ma dichiarato '$atteso'" }
}

Write-Host ""
Write-Host "--- confronto con la verita' dichiarata ---" -ForegroundColor Yellow
foreach ($a in $Attese) {
  $v = $Vive[$a.ea]
  if ($null -eq $v) {
    if ($a.stato -eq 'da_decidere' -or $a.stato -eq 'doppione') {
      Giallo "$($a.ea): non risulta acceso oggi (stato dichiarato: $($a.stato))"
    } else {
      Rosso "$($a.ea): DICHIARATO ATTIVO ma non ha scritto nessuna CONFIG IN USO oggi"
    }
    continue
  }
  Confronta $a.ea "motore"    $a.motore    $v["motore"]        "motore"
  Confronta $a.ea "rangemode" $a.rangemode $v["rangemode"]     "rangemode"
  Confronta $a.ea "lati"      $a.lati      $v["lati"]          "lati"
  Confronta $a.ea "trail"     $a.trail     $v["trail"]         "trail"
  if ($a.range  -ne '*') { $r = ($v["range"]  -replace '\D','') ; if ($r -ne $a.range)  { Rosso "$($a.ea): range = '$r' ma dichiarato '$($a.range)'" } }
  if ($a.buffer -ne '*') { $b = ($v["buffer"] -replace '\D','') ; if ($b -ne $a.buffer) { Rosso "$($a.ea): buffer = '$b' ma dichiarato '$($a.buffer)'" } }

  $rReale = 0.0
  if ($v["rischio"] -match '([\d\.,]+)') { $rReale = [double](($matches[1] -replace ',','.')) }
  $rAtteso = [double](($a.rischio -replace ',','.'))
  if ($a.rischio -ne '*') {
    if ($rReale -gt $rAtteso) { Rosso  "$($a.ea): rischio $rReale% SOPRA il dichiarato $rAtteso%" }
    elseif ($rReale -lt $rAtteso) { Giallo "$($a.ea): rischio $rReale% sotto il dichiarato $rAtteso% (piu' prudente, ma il dichiarato va aggiornato)" }
  }
  if ($a.fonte -eq '' -and $a.stato -eq 'validato') {
    Rosso "$($a.ea): dichiarato VALIDATO ma senza fonte di misura"
  }
}

# --- 4) EA accesi che NON sono dichiarati da nessuna parte ------------
foreach ($nome in $Vive.Keys) {
  if (-not ($Attese | Where-Object { $_.ea -eq $nome })) {
    Rosso "$nome : sta girando ma NON e' in flotta_attesa.csv. Niente gira senza essere dichiarato."
  }
}

# --- 5) esposizione per simbolo ---------------------------------------
Write-Host ""
Write-Host "--- esposizione per simbolo (dal log, non dal dichiarato) ---" -ForegroundColor Yellow
$perSym = @{}
foreach ($a in $Attese) {
  $v = $Vive[$a.ea]; if ($null -eq $v) { continue }
  $r = 0.0; if ($v["rischio"] -match '([\d\.,]+)') { $r = [double](($matches[1] -replace ',','.')) }
  if (-not $perSym.ContainsKey($a.simbolo)) { $perSym[$a.simbolo] = 0.0 }
  $perSym[$a.simbolo] += $r
}
foreach ($s in ($perSym.Keys | Sort-Object)) {
  $tot = [math]::Round($perSym[$s], 2)
  $col = if ($tot -gt $Tetto) { "Red" } else { "Green" }
  Write-Host ("    {0,-10} {1,6}%   (tetto {2}%)" -f $s, $tot, $Tetto) -ForegroundColor $col
  if ($tot -gt $Tetto) { Rosso "$s : esposizione sommata $tot% SOPRA il tetto di $Tetto%" }
}

# --- 6) stati che non dovrebbero girare a rischio pieno ---------------
foreach ($a in $Attese) {
  $v = $Vive[$a.ea]; if ($null -eq $v) { continue }
  $r = 0.0; if ($v["rischio"] -match '([\d\.,]+)') { $r = [double](($matches[1] -replace ',','.')) }
  if ($a.stato -eq 'doppione' -and $r -gt 0.5) { Rosso "$($a.ea): stato DOPPIONE ma gira al $r%. Fa lo stesso trade di un altro EA." }
  if ($a.stato -eq 'bocciato' -and $r -gt 0.5) { Rosso "$($a.ea): stato BOCCIATO ma gira al $r%." }
  if ($a.stato -eq 'in_prova' -and $r -gt 1.0) { Giallo "$($a.ea): stato IN PROVA (mai misurato) ma gira al $r%." }
}

# --- 7) .ex5 piu' recente del .mq5, e riavvio DOPO la compilazione ----
Write-Host ""
Write-Host "--- compilazione e riavvio ---" -ForegroundColor Yellow
$expDirs = @(Get-ChildItem $termRoot -Directory -ErrorAction SilentlyContinue | ForEach-Object { Join-Path $_.FullName "MQL5\Experts" } | Where-Object { Test-Path $_ })
$nMq5 = 0; $nVecchi = 0
foreach ($d in $expDirs) {
  foreach ($mq5 in (Get-ChildItem $d -Filter "ABTG_*.mq5" -ErrorAction SilentlyContinue)) {
    $nMq5++
    $ex5 = [IO.Path]::ChangeExtension($mq5.FullName, ".ex5")
    if (-not (Test-Path $ex5)) { Rosso "$($mq5.Name): manca l'.ex5 (compilazione fallita?)"; continue }
    $tEx5 = (Get-Item $ex5).LastWriteTime
    if ($tEx5 -lt $mq5.LastWriteTime) {
      Rosso "$($mq5.Name): l'.ex5 e' PIU' VECCHIO del .mq5 -> gira codice vecchio"
      $nVecchi++
    }
  }
}
Write-Host ("    controllati {0} file .mq5, {1} con .ex5 non aggiornato" -f $nMq5, $nVecchi) -ForegroundColor Gray

foreach ($nome in $Vive.Keys) {
  $oraAvvio = $Vive[$nome]["_ora"]
  if (-not $oraAvvio) { continue }
  foreach ($d in $expDirs) {
    $cand = Get-ChildItem $d -Filter "*.ex5" -ErrorAction SilentlyContinue |
            Where-Object { $_.LastWriteTime.Date -eq (Get-Date).Date -and $_.LastWriteTime.ToString("HH:mm:ss") -gt $oraAvvio }
    foreach ($c in $cand) {
      Giallo "$nome : e' ripartito alle $oraAvvio ma $($c.Name) e' stato compilato dopo ($($c.LastWriteTime.ToString('HH:mm:ss'))). Se e' il suo, gira ancora il vecchio."
    }
    break
  }
}

# --- VERDETTO ---------------------------------------------------------
if ($Brutale) { foreach ($g in $Gialli) { [void]$Rossi.Add($g) }; $Gialli.Clear() }

Write-Host ""
Write-Host "=====================================================" -ForegroundColor Cyan
if ($Gialli.Count -gt 0) {
  Write-Host " DA GUARDARE ($($Gialli.Count))" -ForegroundColor Yellow
  foreach ($g in $Gialli) { Write-Host "   - $g" -ForegroundColor Yellow }
  Write-Host ""
}
if ($Rossi.Count -eq 0) {
  Write-Host " VERDE - nessun problema bloccante" -ForegroundColor Green
  Write-Host "=====================================================" -ForegroundColor Cyan
  Write-Host ""
  Write-Host " Verde NON vuol dire 'buona per una prop'." -ForegroundColor Gray
  Write-Host " Vuol dire: gira quello che e' scritto in flotta_attesa.csv." -ForegroundColor Gray
  Write-Host " Se li' dentro c'e' scritta una cosa sbagliata, questo controllo la conferma." -ForegroundColor Gray
  exit 0
} else {
  Write-Host " ROSSO - $($Rossi.Count) problemi bloccanti" -ForegroundColor Red
  foreach ($r in $Rossi) { Write-Host "   - $r" -ForegroundColor Red }
  Write-Host "=====================================================" -ForegroundColor Cyan
  Write-Host ""
  Write-Host " Non mettere niente su un conto che conta finche' non e' verde." -ForegroundColor Red
  exit 1
}
