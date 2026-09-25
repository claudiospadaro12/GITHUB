# PULISCI_DESKTOP_PC.ps1 -- MARCATORE_PULISCI_DESKTOP_PC_v2
# Riordina il Desktop del PC di backtest DESKTOP-H4D7CAJ: NON cancella niente,
# SPOSTA gli elementi in Desktop\ARCHIVIO_DESKTOP_<data>\ divisi per tipo.
# Senza -Esegui: PROVA A SECCO (elenca cosa sposta E cosa salta, con il motivo).
# Con   -Esegui: sposta e scrive ELENCO_SPOSTATI.csv (Origine,Destinazione)
#                dentro l'archivio.
# Con   -Annulla: rimette al loro posto gli elementi dell'ultimo archivio.
# Non tocca MT5, i terminali, la cartella abtg_round, nessun conto.
#
# v2 (cancello strato 2, 25/09/2026): la v1 era la classe 494 (riscritta da
# zero mentre in repo c'era RIGA_ARCHIVIO_DESKTOP.ps1 con le sue guardie).
# Guardie copiate dal gemello, non ricordate:
#   G1 attivita' pianificate, FAIL-CLOSED (classe 458/494)
#   G2 freschezza ricorsiva -OreFerme (classe 61: un round a meta')
#   G3 Desktop dentro il profilo, finisce in \Desktop, niente piattaforme
#   G4 giunzioni / nascosti / di sistema si saltano
#   G5 cartelle-strumento dei gemelli e tematiche di Claudio (classe 142)
#   G6 strumenti (.ps1 .exe ...) e pagelle restano (pulizia_desktop_blocco_A)
#   G7 test MT5 in corso (metatester64 vivo) = RIFIUTO: un round a piu' job
#      rilegge a fine corsa le Desktop\ROUND_<job> dei job finiti, anche
#      di piu' di -OreFerme ore prima (RIGA_R251_SHORT_DAX, raccolta).
#   G8 log CSV + -Annulla (classe 9 / 140 / 140-bis)
param([switch]$Esegui, [switch]$Annulla, [int]$OreFerme = 6)
$ErrorActionPreference = 'Stop'
$INV = [Globalization.CultureInfo]::InvariantCulture
$ORD = [StringComparison]::OrdinalIgnoreCase
function Muori($m) { Write-Host ('RIFIUTO: ' + $m) -ForegroundColor Red; Write-Host 'Non ho spostato niente.' -ForegroundColor Red; exit 1 }

if ($env:COMPUTERNAME -ne 'DESKTOP-H4D7CAJ') { Muori ('solo sul PC di backtest DESKTOP-H4D7CAJ. Qui: ' + $env:COMPUTERNAME) }

# G3 -- il Desktop giusto
$D = ''
try { $D = [Environment]::GetFolderPath('Desktop') } catch { $D = '' }
if ([string]::IsNullOrWhiteSpace($D)) { Muori 'non riesco a ricavare il percorso del Desktop' }
$SEP = [string][IO.Path]::DirectorySeparatorChar
$D = [IO.Path]::GetFullPath($D).TrimEnd($SEP)
if (-not (Test-Path -LiteralPath $D -PathType Container)) { Muori ('Desktop non trovato: ' + $D) }
if ((Split-Path -Leaf $D) -ne 'Desktop') { Muori ('il percorso ricavato non finisce in \Desktop: ' + $D) }
$prof = ''
if ($env:USERPROFILE) { $prof = [IO.Path]::GetFullPath($env:USERPROFILE).TrimEnd($SEP) }
if (-not $prof) { Muori 'USERPROFILE vuoto' }
if (-not $D.StartsWith(($prof + $SEP), $ORD)) { Muori ('il Desktop (' + $D + ') non sta dentro il profilo (' + $prof + ')') }
foreach ($k in @('METAQUOTES','TERMINAL','BCM_REALE','BCM MARKETS','MT5_BACKTEST','PEPPERSTONE','TICKMILL','PROGRAM FILES','\ABTG','REPORT_SCHEDULER')) {
    if ($D.ToUpperInvariant().Contains($k)) { Muori ('il percorso del Desktop contiene ' + $k) }
}

# G8 -- annullamento
if ($Annulla) {
    $arch = @(Get-ChildItem -LiteralPath $D -Directory -Force | Where-Object { $_.Name -like 'ARCHIVIO_DESKTOP_*' -and (Test-Path -LiteralPath (Join-Path $_.FullName 'ELENCO_SPOSTATI.csv')) } | Sort-Object Name -Descending)
    if ($arch.Count -eq 0) { Write-Host 'ESITO_PULIZIA: NIENTE_DA_ANNULLARE' -ForegroundColor Yellow; exit 0 }
    $csv = Join-Path $arch[0].FullName 'ELENCO_SPOSTATI.csv'
    Write-Host ('ANNULLO usando ' + $csv) -ForegroundColor Cyan
    $ok = 0; $ko = 0
    foreach ($r in @(Import-Csv -LiteralPath $csv)) {
        try {
            if (-not (Test-Path -LiteralPath $r.Destinazione)) { throw 'non e piu dove l avevo messo' }
            if (Test-Path -LiteralPath $r.Origine) { throw 'al posto di origine c e di nuovo qualcosa: non annido, va risolto a mano' }
            Move-Item -LiteralPath $r.Destinazione -Destination $r.Origine -ErrorAction Stop
            $ok++
        } catch { $ko++; Write-Host ('NON RIMESSO: ' + $r.Origine + ' -- ' + $_.Exception.Message) -ForegroundColor Red }
    }
    Move-Item -LiteralPath $csv -Destination (Join-Path $arch[0].FullName ('USATO_ELENCO_SPOSTATI_' + (Get-Date).ToString('yyyyMMdd_HHmmss', $INV) + '.csv'))
    Write-Host ('Rimessi a posto: ' + $ok + '   NON rimessi: ' + $ko)
    if ($ko -gt 0) { Write-Host 'ESITO_PULIZIA: ANNULLATO_CON_ERRORI' -ForegroundColor Red; exit 2 }
    Write-Host 'ESITO_PULIZIA: ANNULLATO_OK' -ForegroundColor Green; exit 0
}

# G7 -- un test MT5 in corso
$mt = @(Get-Process -Name 'metatester64' -ErrorAction SilentlyContinue)
if ($mt.Count -gt 0) { Muori ('il tester di MT5 e al lavoro (metatester64 PID ' + (($mt | ForEach-Object { $_.Id }) -join ', ') + '): un round sta girando e rilegge le sue cartelle ROUND_ dal Desktop. Rilancia a round finito.') }

# G1 -- attivita' pianificate, FAIL-CLOSED
$att = ''; $letto = $false
try {
    $tt = @(Get-ScheduledTask -ErrorAction Stop)
    foreach ($t in $tt) { foreach ($a in @($t.Actions)) { $att = $att + ($a | Out-String -Width 8000) + "`n" } }
    if ($tt.Count -gt 0) { $letto = $true }
} catch { $letto = $false }
if (-not $letto) {
    # classe 165: niente Stop sulla chiamata nativa (schtasks scrive su stderr)
    try { $q = (& { $ErrorActionPreference = 'Continue'; & schtasks.exe /query /fo LIST /v 2>$null | Out-String -Width 8000 }); if ($q -and $q.Length -gt 200) { $att = $q; $letto = $true } } catch { $letto = $false }
}
if (-not $letto) { Muori 'non riesco a leggere le attivita pianificate: non so quale elemento del Desktop e l input di un attivita (classe 458: il 16/09 un riordino ha spento ABTG_AggiornaNews).' }
$attU = $att.ToUpperInvariant()

$MaiPerNome = @('ARCHIVIO','ABTG_RISULTATI','ABTG_ZIP','ABTG_DOCUMENTI','ABTG_VARIE','ABTG_ORDINE_LOG','ARCHIVIO_DESKTOP','ARCHIVIO_TEST')
$MaiPerPrefisso = @('ARCHIVIO_DESKTOP_','EASYTREND','INDICATORI','BREAKOUT','NOTTE','PROCE','ALTA VELOCIT','NASDAQ APERTU','DAX E NASD','PIANO DI TRADI','FILE WORD','FILE CHE SCARICO','GITHUB','PAGELLA_')
$EstMai = @('.lnk','.url','.ps1','.psm1','.py','.exe','.bat','.cmd','.msi','.mq5','.mqh','.ex5','.dll','.sys')

function Ultima($x) {
    $t = $x.LastWriteTime
    if ($x.PSIsContainer) {
        # la data della cartella NON cambia se si scrive in una sottocartella (classe 61)
        foreach ($f in @(Get-ChildItem -LiteralPath $x.FullName -Recurse -Force -ErrorAction SilentlyContinue)) { if ($f.LastWriteTime -gt $t) { $t = $f.LastWriteTime } }
    }
    return $t
}
function Perche($x) {
    $n = $x.Name; $nU = $n.ToUpperInvariant()
    if ([string]::Equals($n, 'desktop.ini', $ORD)) { return 'desktop.ini di Windows' }
    if (($x.Attributes -band [IO.FileAttributes]::ReparsePoint) -ne 0) { return 'giunzione/collegamento di cartella' }
    if (($x.Attributes -band [IO.FileAttributes]::Hidden) -ne 0 -or ($x.Attributes -band [IO.FileAttributes]::System) -ne 0) { return 'nascosto o di sistema' }
    foreach ($m in $MaiPerNome) { if ([string]::Equals($n, $m, $ORD)) { return 'cartella-strumento di un gemello (il suo log/annulla la cerca sul Desktop)' } }
    foreach ($p in $MaiPerPrefisso) { if ($nU.StartsWith($p, $ORD)) { return 'protetto per nome (archivio, tematica di Claudio, copia di GitHub o pagella)' } }
    if (-not $x.PSIsContainer) { $e = $x.Extension.ToLowerInvariant(); if ($EstMai -contains $e) { return ('strumento o collegamento (' + $e + '): le righe o le icone lo usano da li') } }
    if ($attU.Contains($x.FullName.ToUpperInvariant()) -or $attU.Contains('\' + $nU)) { return 'lo usa un ATTIVITA PIANIFICATA (classe 458)' }
    $u = Ultima $x
    if ((New-TimeSpan -Start $u -End (Get-Date)).TotalHours -lt $OreFerme) { return ('FRESCO: scritto ' + $u.ToString('dd/MM HH:mm', $INV) + ', meno di ' + $OreFerme + ' ore fa (round in corso?)') }
    return ''
}
function Sottocartella($x) {
    if ($x.PSIsContainer -and $x.Name -like 'ROUND_*') { return 'ROUND' }
    if ($x.PSIsContainer) { return 'CARTELLE' }
    $e = $x.Extension.ToLowerInvariant()
    if ($e -eq '.zip' -and $x.Name -like 'ROUND_*') { return 'ROUND' }
    if ($e -eq '.zip') { return 'ZIP' }
    if (@('.txt', '.csv', '.log', '.md', '.htm', '.html', '.xml', '.set', '.ini') -contains $e) { return 'TESTI_E_DATI' }
    return 'ALTRO'
}

$cosa = New-Object System.Collections.ArrayList
$salt = New-Object System.Collections.ArrayList
foreach ($x in @(Get-ChildItem -LiteralPath $D -Force)) {
    $w = Perche $x
    if ($w -eq '') { [void]$cosa.Add($x) } else { [void]$salt.Add(($x.Name + '   <-- ' + $w)) }
}
Write-Host ('Desktop: ' + $D + '   (attivita pianificate lette: si, guardia ATTIVA)') -ForegroundColor Cyan
if ($salt.Count -gt 0) {
    Write-Host ('RESTANO sul Desktop (' + $salt.Count + '), con il motivo:') -ForegroundColor Yellow
    foreach ($s in ($salt | Sort-Object)) { Write-Host ('  ' + $s) -ForegroundColor DarkYellow }
}
if ($cosa.Count -eq 0) { Write-Host 'ESITO_PULIZIA: DESKTOP_GIA_PULITO (niente da spostare)' -ForegroundColor Green; exit 0 }
Write-Host ('Elementi da spostare: ' + $cosa.Count) -ForegroundColor Cyan
foreach ($x in ($cosa | Sort-Object Name)) {
    $t = if ($x.PSIsContainer) { 'cartella' } else { $x.Extension }
    Write-Host ('  ' + (Sottocartella $x).PadRight(13) + ' <- ' + $x.Name + '   [' + $t + ']')
}
if (-not $Esegui) { Write-Host 'ESITO_PULIZIA: SECCO_OK (prova a secco: niente spostato)' -ForegroundColor Yellow; exit 0 }

$A = Join-Path $D ('ARCHIVIO_DESKTOP_' + (Get-Date).ToString('yyyyMMdd_HHmmss', $INV))
if (Test-Path -LiteralPath $A) { Muori ('l archivio ' + $A + ' esiste gia: rilancia fra un secondo') }
foreach ($s in 'ROUND', 'ZIP', 'TESTI_E_DATI', 'CARTELLE', 'ALTRO') { New-Item -ItemType Directory -Force -Path (Join-Path $A $s) | Out-Null }
$log = New-Object System.Collections.ArrayList
$fal = New-Object System.Collections.ArrayList
foreach ($x in $cosa) {
    $sub = Join-Path $A (Sottocartella $x)
    try {
        # destinazione = la SOTTOCARTELLA (niente nome del file nel -Destination:
        # un nome con [ ] non passa mai dal motore dei wildcard)
        Move-Item -LiteralPath $x.FullName -Destination $sub -ErrorAction Stop
        [void]$log.Add([pscustomobject]@{ Origine = $x.FullName; Destinazione = (Join-Path $sub $x.Name) })
    } catch {
        [void]$fal.Add(('NON SPOSTATO: ' + $x.Name + ' -- ' + $_.Exception.Message))
        Write-Host ('NON SPOSTATO: ' + $x.Name + ' -- ' + $_.Exception.Message) -ForegroundColor Red
    }
}
if ($log.Count -gt 0) { $log | Export-Csv -LiteralPath (Join-Path $A 'ELENCO_SPOSTATI.csv') -NoTypeInformation -Encoding UTF8 }
$ref = @('ESITO PULIZIA DESKTOP', ('data: ' + (Get-Date).ToString('yyyy.MM.dd HH:mm:ss', $INV)), ('spostati: ' + $log.Count + '   non spostati: ' + $fal.Count + '   restati per guardia: ' + $salt.Count), '', '--- NON SPOSTATI ---') + @($fal) + @('', '--- RESTATI PER GUARDIA ---') + @($salt | Sort-Object)
Set-Content -LiteralPath (Join-Path $A 'ESITO_PULIZIA.txt') -Value $ref -Encoding UTF8
foreach ($s in 'ROUND', 'ZIP', 'TESTI_E_DATI', 'CARTELLE', 'ALTRO') {
    $p = Join-Path $A $s
    if (@(Get-ChildItem -LiteralPath $p -Force).Count -eq 0) { Remove-Item -LiteralPath $p -Force }
}
$col = if ($fal.Count -eq 0) { 'Green' } else { 'Red' }
Write-Host ('SPOSTATI ' + $log.Count + ' su ' + $cosa.Count + ' | non spostati ' + $fal.Count + ' | restati per guardia ' + $salt.Count) -ForegroundColor $col
Write-Host ('Archivio: ' + $A + ' (ELENCO_SPOSTATI.csv + ESITO_PULIZIA.txt). NIENTE e stato cancellato.') -ForegroundColor Green
Write-Host ('Per tornare indietro: powershell -NoProfile -ExecutionPolicy Bypass -File "' + $PSCommandPath + '" -Annulla') -ForegroundColor Gray
if ($fal.Count -eq 0) { Write-Host 'ESITO_PULIZIA: ESEGUITO_OK' -ForegroundColor Green; exit 0 } else { Write-Host 'ESITO_PULIZIA: ESEGUITO_CON_ERRORI' -ForegroundColor Red; exit 2 }
