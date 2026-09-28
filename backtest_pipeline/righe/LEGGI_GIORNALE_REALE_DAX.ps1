# LEGGI_GIORNALE_REALE_DAX.ps1 -- MARCATORE_LEGGI_GIORNALE_REALE_DAX_v1
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
param([string[]]$Giorni = @('20260922','20260925'), [int]$MaxChiave = 80)
$ErrorActionPreference = 'Stop'
if ($env:COMPUTERNAME -ne 'VMI3047753') { Write-Host ('RIFIUTO: solo sul VPS VMI3047753. Qui: ' + $env:COMPUTERNAME) -ForegroundColor Red; exit 1 }
$dir = 'C:\Users\Administrator\AppData\Roaming\MetaQuotes\Terminal\E23E1504A8D02A22179395F0652B86B6\MQL5\Logs'
if (-not (Test-Path -LiteralPath $dir)) { Write-Host ('RIFIUTO: cartella MQL5\Logs del REALE non trovata: ' + $dir) -ForegroundColor Red; exit 1 }

function Leggi-Condiviso($path) {
  $fs = [IO.File]::Open($path, [IO.FileMode]::Open, [IO.FileAccess]::Read, [IO.FileShare]::ReadWrite)
  $b = New-Object byte[] $fs.Length
  [void]$fs.Read($b, 0, $b.Length)
  $fs.Close()
  if ($b.Count -ge 2 -and $b[0] -eq 0xFF -and $b[1] -eq 0xFE) { return [Text.Encoding]::Unicode.GetString($b) }
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
  $righe = @($t -split "`r?`n" | Where-Object { $_ -ne '' })
  Write-Host ('   righe totali nel giornale Esperti: ' + $righe.Count)
  $vita = @($righe | Where-Object { $_ -match 'DAX_Apertura' -and $_ -match '(?i)loaded|removed|initialized|deinit|input' })
  Write-Host ('   righe di vita dell EA (loaded/removed/init/deinit/input): ' + $vita.Count)
  foreach ($r in ($vita | Select-Object -First 20)) { Write-Host ('     ' + $r) }
  $dax = @($righe | Where-Object { $_ -match 'DAX_Apertura_EU' -or $_ -match 'DAX Apertura EU' })
  $col = 'Red'; if ($dax.Count -gt 0) { $col = 'Green' }
  Write-Host ('   righe della DAX Apertura EU in tutto: ' + $dax.Count) -ForegroundColor $col
  if ($dax.Count -eq 0) { Write-Host '   NESSUNA riga della DAX: l EA non era sul grafico, oppure era muto (InpVerbose=false). Confronta con le righe di vita qui sopra.' -ForegroundColor Red }
  $ore = @{}
  foreach ($r in $dax) { if ($r -match '^\S+\s+(\d\d):') { $h = $matches[1]; if ($ore.ContainsKey($h)) { $ore[$h] = $ore[$h] + 1 } else { $ore[$h] = 1 } } }
  foreach ($h in ($ore.Keys | Sort-Object)) { Write-Host ('     ore ' + $h + ': ' + $ore[$h] + ' righe') }
  $chiave = @($dax | Where-Object { $_ -match '(?i)range|rottura|break|buffer|limit|nessun|scad|expir|filtro|spread|guardian|pausa|cap|errore|error|fallit|retcode' })
  Write-Host ('   righe chiave (range/rottura/limit/filtro/guardian/errori): ' + $chiave.Count)
  foreach ($r in ($chiave | Select-Object -First $MaxChiave)) { Write-Host ('     ' + $r) }
  if ($chiave.Count -gt $MaxChiave) { Write-Host ('     ... altre ' + ($chiave.Count - $MaxChiave) + ' righe non stampate') }
  if ($dax.Count -gt 0 -and $chiave.Count -eq 0) { Write-Host '   (nessuna riga chiave: le prime 30 righe della DAX cosi come sono)'; foreach ($r in ($dax | Select-Object -First 30)) { Write-Host ('     ' + $r) } }
}
Write-Host 'FINE. Niente scritto.' -ForegroundColor Green
exit 0
