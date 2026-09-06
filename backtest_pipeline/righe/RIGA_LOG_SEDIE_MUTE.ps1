# MARCATORE_RIGA_LOG_SEDIE_MUTE_v2
# Sola lettura: legge i log Esperti (MQL5\Logs) del conto PICCOLO (50503392)
# e stampa le righe di ABTG_SupRev_DAX_H4 (970912) e ABTG_GapFill 225JPY (772235).
# NON scrive, NON modifica, NON tocca EA/preset/grafici. Solo un referto su Desktop.
# v2 (06/09): classe 148 - la sedia si identifica dal NOME DEL FILE EA, non dal
#             marcatore [STReversal], condiviso con 770923 su D30EUR H4.
#             + lettura BOM-aware con FileShare::ReadWrite, scarti CONTATI,
#             + ricerca cartella su logs\ E MQL5\Logs, manopola -CartellaDati.
param(
  [int]$Giorni = 21,
  [string]$CartellaDati = ''
)
$ErrorActionPreference = 'Continue'
$INV = [System.Globalization.CultureInfo]::InvariantCulture
$LOGIN_ATTESO = '50503392'
$VIETATI = @('50504263')   # il 100k non c'entra con queste due sedie: se lo trovi, scartalo
$nonLetti = New-Object System.Collections.ArrayList

Write-Host ''
Write-Host '*** SOLA LETTURA: nessun file scritto tranne il referto sul Desktop ***' -ForegroundColor Magenta
Write-Host ('data: ' + (Get-Date).ToString('yyyy.MM.dd HH:mm:ss', $INV)) -ForegroundColor Gray

# --- lettura CONDIVISA e BOM-aware (classe 28-bis: l'encoding si legge, non si impone;
#     MT5 aperto tiene il log del giorno in scrittura -> FileShare::ReadWrite) ------
function Leggi-Righe([string]$path) {
  $b = $null
  try {
    $fs = [IO.File]::Open($path, [IO.FileMode]::Open, [IO.FileAccess]::Read, [IO.FileShare]::ReadWrite)
    $b = New-Object byte[] $fs.Length
    [void]$fs.Read($b, 0, $b.Length)
    $fs.Close()
  } catch { [void]$nonLetti.Add($path + '  -> ' + $_.Exception.Message); return $null }
  if ($null -eq $b -or $b.Count -lt 4) { return @() }
  $utf16 = ($b[0] -eq 0xFF -and $b[1] -eq 0xFE)
  if (-not $utf16) {
    $zeri = 0; $n = [math]::Min(400, $b.Count)
    for ($i = 1; $i -lt $n; $i += 2) { if ($b[$i] -eq 0) { $zeri++ } }
    $utf16 = ($zeri -gt ($n / 4))
  }
  $enc = [Text.Encoding]::UTF8
  if ($utf16) { $enc = [Text.Encoding]::Unicode }
  $s = $enc.GetString($b)
  if ($s.Length -gt 0 -and $s[0] -eq [char]0xFEFF) { $s = $s.Substring(1) }
  return @($s -split "`r`n|`n|`r")
}

# --- trova la cartella dati del conto piccolo -----------------------------
$radici = New-Object System.Collections.ArrayList
if ($env:APPDATA) { [void]$radici.Add((Join-Path $env:APPDATA 'MetaQuotes\Terminal')) }
$candidate = New-Object System.Collections.ArrayList
foreach ($r in $radici) {
  foreach ($c in @(Get-ChildItem -LiteralPath $r -Directory -EA SilentlyContinue)) {
    if (Test-Path -LiteralPath (Join-Path $c.FullName 'MQL5')) { [void]$candidate.Add($c.FullName) }
  }
}
# i processi vivi sono un FATTO: un terminale portable non sta in %APPDATA%
foreach ($p in @(Get-Process terminal64 -EA SilentlyContinue)) {
  $dir = ''
  try { $dir = Split-Path -Parent $p.Path } catch { $dir = '' }
  if ($dir -ne '' -and (Test-Path -LiteralPath (Join-Path $dir 'MQL5')) -and ($candidate -notcontains $dir)) { [void]$candidate.Add($dir) }
}
if ($CartellaDati -ne '' -and ($candidate -notcontains $CartellaDati)) { [void]$candidate.Add($CartellaDati) }

$info = @{}
foreach ($c in $candidate) {
  $visti = New-Object System.Collections.Generic.HashSet[string]
  $nfile = 0
  foreach ($sub in @('logs', 'MQL5\Logs')) {
    $dir = Join-Path $c $sub
    if (-not (Test-Path -LiteralPath $dir)) { continue }
    $ff = @(Get-ChildItem -LiteralPath $dir -Filter '*.log' -File -EA SilentlyContinue |
            Where-Object { $_.Length -lt 60000000 } |
            Sort-Object LastWriteTime -Descending | Select-Object -First 15)
    $nfile = $nfile + $ff.Count
    foreach ($f in $ff) {
      $righe = Leggi-Righe $f.FullName
      if ($null -eq $righe) { continue }
      $testo = ($righe -join "`n")
      if ($testo.Contains($LOGIN_ATTESO)) { [void]$visti.Add($LOGIN_ATTESO) }
      foreach ($v in $VIETATI) { if ($testo.Contains($v)) { [void]$visti.Add($v) } }
    }
  }
  $info[$c] = @{ Visti = $visti; NFile = $nfile }
}

Write-Host ''
Write-Host 'CARTELLE GUARDATE:' -ForegroundColor Yellow
foreach ($c in $candidate) {
  Write-Host ('  ' + $c + '   file di log letti=' + $info[$c].NFile + '   login visti: ' + ((@($info[$c].Visti) | Sort-Object) -join ',')) -ForegroundColor Gray
}

# attenzione: $_ dentro un Where-Object annidato ombreggia quello esterno -> si fissa in $cc
$conLogin = @($candidate | Where-Object { $cc = $_; $v = $info[$cc].Visti; $vietata = $false; foreach ($x in $VIETATI) { if ($v.Contains($x)) { $vietata = $true } }; ($v.Contains($LOGIN_ATTESO)) -and (-not $vietata) })
$senzaVietati = @($candidate | Where-Object { $cc = $_; $v = $info[$cc].Visti; $vietata = $false; foreach ($x in $VIETATI) { if ($v.Contains($x)) { $vietata = $true } }; -not $vietata })
$scelta = ''
$comeScelta = ''
if ($CartellaDati -ne '') { $scelta = $CartellaDati; $comeScelta = 'IMPOSTA A MANO con -CartellaDati' }
elseif ($conLogin.Count -eq 1) { $scelta = $conLogin[0]; $comeScelta = 'login ' + $LOGIN_ATTESO + ' trovato nei log' }
elseif ($conLogin.Count -gt 1) {
  Write-Host ('DUE O PIU'' CARTELLE col login ' + $LOGIN_ATTESO + ': non indovino. Rilancia con -CartellaDati ''<percorso>''.') -ForegroundColor Red
  exit 1
}
elseif ($senzaVietati.Count -eq 1) { $scelta = $senzaVietati[0]; $comeScelta = 'RILIEVO: login NON trovato nei log; scelta per ESCLUSIONE (unica candidata senza traccia del 100k)' }
else {
  Write-Host 'NON SO QUALE CARTELLA E'' IL CONTO PICCOLO (zero o piu'' candidate).' -ForegroundColor Red
  Write-Host 'Rilancia indicando la cartella: ... -CartellaDati "C:\percorso\della\cartella"' -ForegroundColor Yellow
  exit 1
}
Write-Host ('cartella dati scelta: ' + $scelta + '   [' + $comeScelta + ']') -ForegroundColor Green

# --- legge i log recenti e filtra le due sedie ----------------------------
# 148: il FILTRO E' IL NOME DEL FILE EA (colonna contesto del log Esperti),
# non il marcatore [STReversal] / [GAP], condiviso da tutta la famiglia.
$logsDir = Join-Path $scelta 'MQL5\Logs'
$soglia = (Get-Date).AddDays(-$Giorni)
$file = @(Get-ChildItem -LiteralPath $logsDir -Filter '*.log' -File -EA SilentlyContinue |
          Where-Object { $_.LastWriteTime -ge $soglia } | Sort-Object Name)

Write-Host ("file di log letti (ultimi $Giorni giorni): " + $file.Count) -ForegroundColor Gray

$righeSupRev  = New-Object System.Collections.ArrayList
$righeVicini  = New-Object System.Collections.ArrayList
$righeGapFill = New-Object System.Collections.ArrayList
$tutteD30 = 0
$tutte225 = 0

foreach ($f in $file) {
  $righe = Leggi-Righe $f.FullName
  if ($null -eq $righe) { continue }
  foreach ($r in $righe) {
    if ($r -match 'D30EUR') { $tutteD30++ }
    if ($r -match '225JPY') { $tutte225++ }
    if ($r -match 'SupRev_DAX_H4')                                { [void]$righeSupRev.Add($f.Name + '  ' + $r); continue }
    if ($r -match 'STReversal' -and $r -match 'D30EUR')            { [void]$righeVicini.Add($f.Name + '  ' + $r); continue }
    if (($r -match 'GapFill' -or $r -match '\[GAP\]') -and $r -match '225JPY') { [void]$righeGapFill.Add($f.Name + '  ' + $r) }
  }
}

$esito = 'COMPLETO'
if ($nonLetti.Count -gt 0) { $esito = 'PARZIALE -- ' + $nonLetti.Count + ' file NON letti' }

Write-Host ''
Write-Host '=== 970912 SupRev DAX H4 -- righe di ABTG_SupRev_DAX_H4_Ottimizzato ===' -ForegroundColor Cyan
if ($righeSupRev.Count -eq 0) { Write-Host '  NESSUNA RIGA TROVATA in questa finestra.' -ForegroundColor Yellow }
else { $righeSupRev | ForEach-Object { Write-Host ('  ' + $_) } }

Write-Host ''
Write-Host '=== VICINI DI CASA su D30EUR (770923 SupertrendReversal ecc.) -- NON sono la 970912 ===' -ForegroundColor DarkYellow
if ($righeVicini.Count -eq 0) { Write-Host '  nessuna.' }
else { $righeVicini | ForEach-Object { Write-Host ('  ' + $_) } }

Write-Host ''
Write-Host '=== 772235 GapFill 225JPY -- righe di ABTG_GapFill su 225JPY ===' -ForegroundColor Cyan
if ($righeGapFill.Count -eq 0) { Write-Host '  NESSUNA RIGA TROVATA in questa finestra.' -ForegroundColor Yellow }
else { $righeGapFill | ForEach-Object { Write-Host ('  ' + $_) } }

Write-Host ''
Write-Host ('righe TOTALI che nominano D30EUR: ' + $tutteD30 + '   che nominano 225JPY: ' + $tutte225) -ForegroundColor Gray
Write-Host ('ESITO LETTURA: ' + $esito) -ForegroundColor Gray
if ($nonLetti.Count -gt 0) { $nonLetti | ForEach-Object { Write-Host ('  NON LETTO: ' + $_) -ForegroundColor Red } }

# --- referto su Desktop ---------------------------------------------------
$Desktop = [Environment]::GetFolderPath('Desktop')
$stamp = (Get-Date).ToString('yyyy-MM-dd_HHmmss', $INV)
$fileOut = Join-Path $Desktop ('log_sedie_mute_' + $stamp + '.txt')
$righeOut = New-Object System.Collections.ArrayList
[void]$righeOut.Add('LOG SEDIE MUTE v2 - sola lettura, nessun file toccato')
[void]$righeOut.Add('data: ' + (Get-Date).ToString('yyyy.MM.dd HH:mm:ss', $INV))
[void]$righeOut.Add('cartella dati: ' + $scelta + '  [' + $comeScelta + ']')
[void]$righeOut.Add('file di log letti: ' + $file.Count + ' (ultimi ' + $Giorni + ' giorni)')
[void]$righeOut.Add('ESITO LETTURA: ' + $esito)
foreach ($x in $nonLetti) { [void]$righeOut.Add('  NON LETTO: ' + $x) }
[void]$righeOut.Add('righe totali che nominano D30EUR: ' + $tutteD30 + ' | 225JPY: ' + $tutte225)
[void]$righeOut.Add('')
[void]$righeOut.Add('=== 970912 SupRev DAX H4 (filtro: nome EA SupRev_DAX_H4) ===')
if ($righeSupRev.Count -eq 0) { [void]$righeOut.Add('  NESSUNA RIGA TROVATA') }
else { $righeSupRev | ForEach-Object { [void]$righeOut.Add('  ' + $_) } }
[void]$righeOut.Add('')
[void]$righeOut.Add('=== VICINI su D30EUR (NON sono la 970912) ===')
if ($righeVicini.Count -eq 0) { [void]$righeOut.Add('  nessuna') }
else { $righeVicini | ForEach-Object { [void]$righeOut.Add('  ' + $_) } }
[void]$righeOut.Add('')
[void]$righeOut.Add('=== 772235 GapFill 225JPY ===')
if ($righeGapFill.Count -eq 0) { [void]$righeOut.Add('  NESSUNA RIGA TROVATA') }
else { $righeGapFill | ForEach-Object { [void]$righeOut.Add('  ' + $_) } }
Set-Content -LiteralPath $fileOut -Value $righeOut -Encoding UTF8

Write-Host ''
Write-Host ('Referto scritto: ' + $fileOut) -ForegroundColor Magenta
Write-Host 'Mandalo in chat cosi'' com''e''.' -ForegroundColor Magenta
exit 0
