# LEGGI_GIORNALE_REALE_DAX.ps1 -- MARCATORE_LEGGI_GIORNALE_REALE_DAX_v2
# SOLA LETTURA. Apre in condivisione (classe 163) il giornale Esperti del
# terminale REALE 10105439 (C:\BCM_Reale, cartella dati
# E23E1504A8D02A22179395F0652B86B6) per i giorni passati con -Giorni e
# STAMPA le righe dell EA ABTG_DAX_Apertura_EU: vita dell EA (loaded /
# removed / init), conteggio per ora, righe chiave (range, rottura, limit,
# filtro, guardian, errori). Non scrive, non copia, non modifica niente.
# Nessun processo aperto o chiuso, nessun terminale toccato.
# Gira SOLO sul VPS VMI3047753. Nato dal confronto FTMO/reale del 28/09
# (report/CONFRONTO_DAX_FTMO_VS_REALE_2026-09-28.md): il 25/09 il reale
# non ha piazzato l ordine DAX e la sonda CODA_09 non dice perche.
# v2 (verificatore stringhe 28/09): (a) l ora si prende dal campo orario
# HH:MM:SS.mmm, perche' la riga vera e' 'ME<TAB>0<TAB>15:17:39.196<TAB>...'
# e la regex v1 '^\S+\s+(\d\d):' non prendeva MAI (conteggio per ora vuoto);
# (b) righe chiave allargate ai rifiuti veri dell EA ('candela < min: niente
# trade', 'saltato', 'armato', 'nuovo giorno', 'avviato'); (c) si legge anche
# il GIORNALE del terminale (Logs, non MQL5\Logs): li' stanno 'loaded' /
# 'removed', Algo Trading e connessione; (d) Leggi-Condiviso identica a
# CODA_09 (try/catch: un giorno illeggibile non ferma l altro); (e) -Giorni
# passato con -File arriva come UNA stringa '20260922,20260925': la v1
# cercava il file '20260922,20260925.log' e diceva ASSENTE. Ora si spezza.
param([string[]]$Giorni = @('20260922','20260925'), [int]$MaxChiave = 80)
$ErrorActionPreference = 'Stop'
# Con powershell -File '-Giorni 20260922,20260925' arriva come UNA stringa
# con la virgola dentro (niente array fuori da -Command): si spezza qui.
$Giorni = @($Giorni | ForEach-Object { $_ -split ',' } | ForEach-Object { $_.Trim() } | Where-Object { $_ -match '^\d{8}$' })
if ($Giorni.Count -eq 0) { Write-Host 'RIFIUTO: nessun giorno valido in -Giorni (formato AAAAMMGG).' -ForegroundColor Red; exit 1 }
if ($env:COMPUTERNAME -ne 'VMI3047753') { Write-Host ('RIFIUTO: solo sul VPS VMI3047753. Qui: ' + $env:COMPUTERNAME) -ForegroundColor Red; exit 1 }
$dir = 'C:\Users\Administrator\AppData\Roaming\MetaQuotes\Terminal\E23E1504A8D02A22179395F0652B86B6\MQL5\Logs'
if (-not (Test-Path -LiteralPath $dir)) { Write-Host ('RIFIUTO: cartella MQL5\Logs del REALE non trovata: ' + $dir) -ForegroundColor Red; exit 1 }

$dirT = 'C:\Users\Administrator\AppData\Roaming\MetaQuotes\Terminal\E23E1504A8D02A22179395F0652B86B6\Logs'
$reOra = '(\d\d):\d\d:\d\d\.\d{3}'

function Leggi-Condiviso($path) {
  $b = $null
  try {
    $fs = [IO.File]::Open($path, [IO.FileMode]::Open, [IO.FileAccess]::Read, [IO.FileShare]::ReadWrite)
    $b = New-Object byte[] $fs.Length
    [void]$fs.Read($b, 0, $b.Length)
    $fs.Close()
  } catch { return '' }
  if ($null -eq $b -or $b.Count -lt 2) { return '' }
  if ($b[0] -eq 0xFF -and $b[1] -eq 0xFE) { return [Text.Encoding]::Unicode.GetString($b) }
  $zeri = 0; $n = [math]::Min(400, $b.Count)
  for ($i = 1; $i -lt $n; $i += 2) { if ($b[$i] -eq 0) { $zeri++ } }
  if ($zeri -gt ($n / 4)) { return [Text.Encoding]::Unicode.GetString($b) }
  return [Text.Encoding]::UTF8.GetString($b)
}

Write-Host 'GIORNALE ESPERTI DEL REALE 10105439 (C:\BCM_Reale) -- SOLA LETTURA' -ForegroundColor Cyan
Write-Host 'Le ore sono LOCALI del VPS (= ora italiana); il server BCM e un ora indietro d estate.'
foreach ($g in $Giorni) {
  $p = Join-Path $dir ($g + '.log')
  Write-Host ('=== GIORNO ' + $g + ' ===') -ForegroundColor Cyan
  if (-not (Test-Path -LiteralPath $p)) { Write-Host ('   file ' + $p + ' ASSENTE') -ForegroundColor Red; continue }
  $t = Leggi-Condiviso $p
  if (-not $t) { Write-Host ('   file ' + $p + ' ILLEGGIBILE o vuoto') -ForegroundColor Red; continue }
  $righe = @($t -split "`r?`n" | Where-Object { $_ -ne '' })
  Write-Host ('   righe totali nel giornale Esperti: ' + $righe.Count)
  $vita = @($righe | Where-Object { $_ -match 'DAX_Apertura' -and $_ -match '(?i)loaded|removed|initialized|deinit|input|avviato|nuovo giorno|CONFIG IN USO|riavvio' })
  Write-Host ('   righe di vita dell EA (loaded/removed/init/deinit/input): ' + $vita.Count)
  foreach ($r in ($vita | Select-Object -First 20)) { Write-Host ('     ' + $r) }
  $dax = @($righe | Where-Object { $_ -match 'DAX_Apertura_EU' -or $_ -match 'DAX Apertura EU' })
  $col = 'Red'; if ($dax.Count -gt 0) { $col = 'Green' }
  Write-Host ('   righe della DAX Apertura EU in tutto: ' + $dax.Count) -ForegroundColor $col
  if ($dax.Count -eq 0) { Write-Host '   NESSUNA riga della DAX: l EA non era sul grafico, oppure era muto (InpVerbose=false). Confronta con le righe di vita qui sopra.' -ForegroundColor Red }
  $ore = @{}
  foreach ($r in $dax) { if ($r -match $reOra) { $h = $matches[1]; if ($ore.ContainsKey($h)) { $ore[$h] = $ore[$h] + 1 } else { $ore[$h] = 1 } } }
  foreach ($h in ($ore.Keys | Sort-Object)) { Write-Host ('     ore ' + $h + ': ' + $ore[$h] + ' righe') }
  $chiave = @($dax | Where-Object { $_ -match '(?i)range|rottura|break|buffer|limit|nessun|niente|salt|candela|whipsaw|armat|volumi|tetto|riarm|riprov|scad|expir|filtro|spread|news|guardian|pausa|cap|errore|error|fallit|retcode' })
  Write-Host ('   righe chiave (range/rottura/limit/filtro/guardian/errori): ' + $chiave.Count)
  foreach ($r in ($chiave | Select-Object -First $MaxChiave)) { Write-Host ('     ' + $r) }
  if ($chiave.Count -gt $MaxChiave) { Write-Host ('     ... altre ' + ($chiave.Count - $MaxChiave) + ' righe non stampate') }
  if ($dax.Count -gt 0 -and $chiave.Count -eq 0) { Write-Host '   (nessuna riga chiave: le prime 30 righe della DAX cosi come sono)'; foreach ($r in ($dax | Select-Object -First 30)) { Write-Host ('     ' + $r) } }
  $pT = Join-Path $dirT ($g + '.log')
  Write-Host ('   --- GIORNALE DEL TERMINALE (Logs): EA caricato/rimosso, Algo Trading, connessione, ordini D30EUR ---') -ForegroundColor Cyan
  if (-not (Test-Path -LiteralPath $pT)) { Write-Host ('   file ' + $pT + ' ASSENTE') -ForegroundColor Red; continue }
  $tT = Leggi-Condiviso $pT
  if (-not $tT) { Write-Host ('   file ' + $pT + ' ILLEGGIBILE o vuoto') -ForegroundColor Red; continue }
  $rT = @($tT -split "`r?`n" | Where-Object { $_ -ne '' })
  $jT = @($rT | Where-Object { $_ -match '(?i)DAX_Apertura|automated trading|algo ?trading|D30EUR|connection|disconnect|authoriz|terminal .*(start|exit|shutdown)' })
  Write-Host ('   righe totali: ' + $rT.Count + ' ; righe utili: ' + $jT.Count)
  foreach ($r in ($jT | Select-Object -First $MaxChiave)) { Write-Host ('     ' + $r) }
  if ($jT.Count -gt $MaxChiave) { Write-Host ('     ... altre ' + ($jT.Count - $MaxChiave) + ' righe non stampate') }
}
Write-Host 'FINE. Niente scritto.' -ForegroundColor Green
exit 0
