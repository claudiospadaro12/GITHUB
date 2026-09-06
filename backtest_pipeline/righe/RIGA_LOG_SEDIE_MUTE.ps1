# MARCATORE_RIGA_LOG_SEDIE_MUTE_v1
# Sola lettura: legge i log Esperti (MQL5\Logs) del conto PICCOLO (50503392)
# e stampa le righe di ABTG_SupRev_DAX_H4 (970912) e ABTG_GapFill 225JPY (772235).
# NON scrive, NON modifica, NON tocca EA/preset/grafici. Solo un referto su Desktop.
param(
  [int]$Giorni = 21
)
$ErrorActionPreference = 'Continue'
$INV = [System.Globalization.CultureInfo]::InvariantCulture
$LOGIN_ATTESO = '50503392'
$VIETATI = @('50504263')   # il 100k non c'entra con queste due sedie: se lo trovi, scartalo

Write-Host ''
Write-Host '*** SOLA LETTURA: nessun file scritto tranne il referto sul Desktop ***' -ForegroundColor Magenta
Write-Host ('data: ' + (Get-Date).ToString('yyyy.MM.dd HH:mm:ss', $INV)) -ForegroundColor Gray

# --- trova la cartella dati del conto piccolo -----------------------------
$radice = Join-Path $env:APPDATA 'MetaQuotes\Terminal'
$candidate = @(Get-ChildItem -LiteralPath $radice -Directory -EA SilentlyContinue)
$scelta = $null
$vistiPerCartella = @{}

foreach ($c in $candidate) {
  $logsDir = Join-Path $c.FullName 'MQL5\Logs'
  if (-not (Test-Path -LiteralPath $logsDir)) { continue }
  $file = @(Get-ChildItem -LiteralPath $logsDir -Filter '*.log' -EA SilentlyContinue |
            Sort-Object LastWriteTime -Descending | Select-Object -First 60)
  $visti = New-Object System.Collections.Generic.HashSet[string]
  foreach ($f in $file) {
    $testo = Get-Content -LiteralPath $f.FullName -Raw -Encoding UTF8 -EA SilentlyContinue
    if (-not $testo) { continue }
    if ($testo.Contains($LOGIN_ATTESO)) { [void]$visti.Add($LOGIN_ATTESO) }
    foreach ($v in $VIETATI) { if ($testo.Contains($v)) { [void]$visti.Add($v) } }
  }
  $vistiPerCartella[$c.FullName] = $visti
  if ($visti.Contains($LOGIN_ATTESO) -and -not ($VIETATI | Where-Object { $visti.Contains($_) })) {
    if (-not $scelta) { $scelta = $c.FullName }
  }
}

if (-not $scelta) {
  Write-Host 'NESSUNA CARTELLA TROVATA col login 50503392 (senza il 100k dentro).' -ForegroundColor Red
  Write-Host 'Cartelle guardate:' -ForegroundColor Yellow
  foreach ($k in $vistiPerCartella.Keys) { Write-Host ('  ' + $k + '  -> visti: ' + (($vistiPerCartella[$k]) -join ',')) }
  exit 1
}
Write-Host ('cartella dati scelta: ' + $scelta) -ForegroundColor Green

# --- legge i log recenti e filtra le due sedie ----------------------------
$logsDir = Join-Path $scelta 'MQL5\Logs'
$soglia = (Get-Date).AddDays(-$Giorni)
$file = @(Get-ChildItem -LiteralPath $logsDir -Filter '*.log' -EA SilentlyContinue |
          Where-Object { $_.LastWriteTime -ge $soglia } | Sort-Object Name)

Write-Host ("file di log letti (ultimi $Giorni giorni): " + $file.Count) -ForegroundColor Gray

$righeSupRev = New-Object System.Collections.ArrayList
$righeGapFill = New-Object System.Collections.ArrayList

foreach ($f in $file) {
  $righe = Get-Content -LiteralPath $f.FullName -Encoding UTF8 -EA SilentlyContinue
  foreach ($r in $righe) {
    if ($r -match 'STReversal' -and $r -match 'D30EUR') { [void]$righeSupRev.Add($f.Name + '  ' + $r) }
    if ($r -match 'GapFill' -and $r -match '225JPY') { [void]$righeGapFill.Add($f.Name + '  ' + $r) }
  }
}

Write-Host ''
Write-Host '=== 970912 SupRev DAX H4 -- righe [STReversal] su D30EUR ===' -ForegroundColor Cyan
if ($righeSupRev.Count -eq 0) { Write-Host '  NESSUNA RIGA TROVATA in questa finestra.' -ForegroundColor Yellow }
else { $righeSupRev | ForEach-Object { Write-Host ('  ' + $_) } }

Write-Host ''
Write-Host '=== 772235 GapFill 225JPY -- righe [GapFill] su 225JPY ===' -ForegroundColor Cyan
if ($righeGapFill.Count -eq 0) { Write-Host '  NESSUNA RIGA TROVATA in questa finestra.' -ForegroundColor Yellow }
else { $righeGapFill | ForEach-Object { Write-Host ('  ' + $_) } }

# --- referto su Desktop ---------------------------------------------------
$Desktop = [Environment]::GetFolderPath('Desktop')
$stamp = (Get-Date).ToString('yyyy-MM-dd_HHmmss', $INV)
$fileOut = Join-Path $Desktop ('log_sedie_mute_' + $stamp + '.txt')
$righeOut = New-Object System.Collections.ArrayList
[void]$righeOut.Add('LOG SEDIE MUTE - sola lettura, nessun file toccato')
[void]$righeOut.Add('data: ' + (Get-Date).ToString('yyyy.MM.dd HH:mm:ss', $INV))
[void]$righeOut.Add('cartella dati: ' + $scelta)
[void]$righeOut.Add('file di log letti: ' + $file.Count + ' (ultimi ' + $Giorni + ' giorni)')
[void]$righeOut.Add('')
[void]$righeOut.Add('=== 970912 SupRev DAX H4 ===')
if ($righeSupRev.Count -eq 0) { [void]$righeOut.Add('  NESSUNA RIGA TROVATA') }
else { $righeSupRev | ForEach-Object { [void]$righeOut.Add('  ' + $_) } }
[void]$righeOut.Add('')
[void]$righeOut.Add('=== 772235 GapFill 225JPY ===')
if ($righeGapFill.Count -eq 0) { [void]$righeOut.Add('  NESSUNA RIGA TROVATA') }
else { $righeGapFill | ForEach-Object { [void]$righeOut.Add('  ' + $_) } }
Set-Content -LiteralPath $fileOut -Value $righeOut -Encoding UTF8

Write-Host ''
Write-Host ('Referto scritto: ' + $fileOut) -ForegroundColor Magenta
Write-Host 'Mandalo in chat cosi'' com''e''.' -ForegroundColor Magenta
exit 0
