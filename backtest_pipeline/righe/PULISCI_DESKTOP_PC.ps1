# PULISCI_DESKTOP_PC.ps1 -- MARCATORE_PULISCI_DESKTOP_PC_v1
# Riordina il Desktop del PC di backtest DESKTOP-H4D7CAJ: NON cancella niente,
# SPOSTA gli elementi in Desktop\ARCHIVIO_DESKTOP_<data>\ divisi per tipo.
# Restano dove sono: collegamenti .lnk/.url, desktop.ini, file nascosti e
# gli archivi ARCHIVIO_DESKTOP_* gia' fatti.
# Senza -Esegui: PROVA A SECCO (elenca soltanto, non scrive niente).
# Con   -Esegui: sposta e scrive ELENCO_SPOSTATI.txt dentro l'archivio.
# Non tocca MT5, i terminali, la cartella abtg_round, nessun conto.
param([switch]$Esegui)
$ErrorActionPreference = 'Stop'
if ($env:COMPUTERNAME -ne 'DESKTOP-H4D7CAJ') {
    Write-Host ('VIETATO: solo sul PC di backtest DESKTOP-H4D7CAJ. Qui: ' + $env:COMPUTERNAME) -ForegroundColor Red
    exit 1
}
$D = [Environment]::GetFolderPath('Desktop')
if (-not (Test-Path -LiteralPath $D)) { Write-Host ('Desktop non trovato: ' + $D) -ForegroundColor Red; exit 1 }
function Scegli {
    @(Get-ChildItem -LiteralPath $D -Force | Where-Object {
        $_.Name -notlike 'ARCHIVIO_DESKTOP_*' -and
        @('.lnk', '.url') -notcontains $_.Extension.ToLower() -and
        $_.Name -ne 'desktop.ini' -and
        -not ($_.Attributes -band [IO.FileAttributes]::Hidden)
    })
}
function Sottocartella($x) {
    if ($x.PSIsContainer -and $x.Name -like 'ROUND_*') { return 'ROUND' }
    if ($x.PSIsContainer) { return 'CARTELLE' }
    $e = $x.Extension.ToLower()
    if ($e -eq '.zip' -and $x.Name -like 'ROUND_*') { return 'ROUND' }
    if ($e -eq '.zip') { return 'ZIP' }
    if (@('.txt', '.csv', '.log', '.md', '.htm', '.html', '.xml', '.set', '.ini') -contains $e) { return 'TESTI_E_DATI' }
    return 'ALTRO'
}
$cosa = Scegli
Write-Host ('Desktop: ' + $D) -ForegroundColor Cyan
if ($cosa.Count -eq 0) { Write-Host 'ESITO_PULIZIA: DESKTOP_GIA_PULITO (niente da spostare)' -ForegroundColor Green; exit 0 }
Write-Host ('Elementi da spostare: ' + $cosa.Count + ' (collegamenti, desktop.ini e nascosti RESTANO)') -ForegroundColor Cyan
$cosa | Sort-Object Name | ForEach-Object {
    $t = if ($_.PSIsContainer) { 'cartella' } else { $_.Extension }
    Write-Host ('  ' + (Sottocartella $_).PadRight(13) + ' <- ' + $_.Name + '   [' + $t + ', ' + $_.LastWriteTime.ToString('dd/MM/yyyy HH:mm') + ']')
}
if (-not $Esegui) { Write-Host 'ESITO_PULIZIA: SECCO_OK (prova a secco: niente spostato)' -ForegroundColor Yellow; exit 0 }
$A = Join-Path $D ('ARCHIVIO_DESKTOP_' + (Get-Date -Format 'yyyyMMdd_HHmmss'))
foreach ($s in 'ROUND', 'ZIP', 'TESTI_E_DATI', 'CARTELLE', 'ALTRO') { New-Item -ItemType Directory -Force -Path (Join-Path $A $s) | Out-Null }
$log = New-Object System.Collections.ArrayList
$err = 0
foreach ($x in $cosa) {
    $sub = Sottocartella $x
    $dst = Join-Path (Join-Path $A $sub) $x.Name
    try {
        Move-Item -LiteralPath $x.FullName -Destination $dst -ErrorAction Stop
        [void]$log.Add($sub + ' <- ' + $x.Name)
    } catch {
        $err++
        [void]$log.Add('NON SPOSTATO (' + $_.Exception.Message + ') ' + $x.Name)
        Write-Host ('NON SPOSTATO: ' + $x.Name + ' -- ' + $_.Exception.Message) -ForegroundColor Red
    }
}
$log | Set-Content -LiteralPath (Join-Path $A 'ELENCO_SPOSTATI.txt') -Encoding ASCII
foreach ($s in 'ROUND', 'ZIP', 'TESTI_E_DATI', 'CARTELLE', 'ALTRO') {
    $p = Join-Path $A $s
    if (@(Get-ChildItem -LiteralPath $p -Force).Count -eq 0) { Remove-Item -LiteralPath $p -Force }
}
$rest = (Scegli).Count
$col = if ($err -eq 0) { 'Green' } else { 'Red' }
Write-Host ('SPOSTATI ' + ($cosa.Count - $err) + ' su ' + $cosa.Count + ' | non spostati ' + $err + ' | rimasti sul Desktop (esclusi collegamenti) ' + $rest) -ForegroundColor $col
Write-Host ('Archivio: ' + $A + ' (elenco in ELENCO_SPOSTATI.txt). NIENTE e stato cancellato: per tornare indietro si rimettono i file sul Desktop.') -ForegroundColor Green
if ($err -eq 0) { Write-Host 'ESITO_PULIZIA: ESEGUITO_OK' -ForegroundColor Green; exit 0 } else { Write-Host 'ESITO_PULIZIA: ESEGUITO_CON_ERRORI' -ForegroundColor Red; exit 2 }
