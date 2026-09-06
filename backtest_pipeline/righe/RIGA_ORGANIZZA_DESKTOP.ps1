# MARCATORE_RIGA_ORGANIZZA_DESKTOP_v3
# organizza_desktop.ps1 -- ANTEPRIMA di default (non muove niente).
#   -Esegui   -> sposta davvero, scrive il log CSV (serve per -Annulla)
#   -Annulla  -> rilegge l'ultimo log DI QUESTO SCRIPT e rimette tutto com'era
#   -MinutiFermo (default 30) -> una cartella scritta piu' di recente di
#     cosi' e' una corsa/round ANCORA IN CORSO: si salta, non si sposta
#     sotto i piedi di chi ci sta scrivendo dentro (vedi archivia_test_desktop.ps1).
param(
  [switch]$Esegui,
  [switch]$Annulla,
  [int]$MinutiFermo = 30
)
$ErrorActionPreference = 'Continue'
$INV = [System.Globalization.CultureInfo]::InvariantCulture
$Desktop = [Environment]::GetFolderPath('Desktop')
if (-not (Test-Path -LiteralPath $Desktop)) { Write-Host 'Desktop non trovato.' -ForegroundColor Red; exit 1 }
$LogDir = Join-Path $Desktop 'ABTG_ORDINE_LOG'

# --- ANNULLA: rilegge l'ultimo log NON VUOTO di QUESTO SCRIPT e riporta tutto indietro ---
if ($Annulla) {
  $ultimo = Get-ChildItem -LiteralPath $LogDir -Filter 'organizza_desktop_*.csv' -ErrorAction SilentlyContinue |
            Sort-Object LastWriteTime -Descending |
            Where-Object { @(Import-Csv -LiteralPath $_.FullName -ErrorAction SilentlyContinue).Count -gt 0 } |
            Select-Object -First 1
  if (-not $ultimo) { Write-Host 'Nessun log di organizza_desktop da annullare (o sono tutti vuoti).' -ForegroundColor Yellow; exit 0 }
  Write-Host ('ANNULLO usando ' + $ultimo.Name) -ForegroundColor Cyan
  $n = 0; $ko = 0
  $rilievi = New-Object System.Collections.ArrayList
  foreach ($r in (Import-Csv -LiteralPath $ultimo.FullName)) {
    try {
      if (-not (Test-Path -LiteralPath $r.Destinazione)) { throw 'la cartella spostata non si trova piu'' (spostata a mano dopo il giro?)' }
      if (Test-Path -LiteralPath $r.Origine) { throw 'esiste di nuovo una cartella al posto di origine: NON la annido dentro, va risolto a mano' }
      $cartellaOrig = Split-Path -Parent $r.Origine
      if (-not (Test-Path -LiteralPath $cartellaOrig)) { New-Item -ItemType Directory -Force -Path $cartellaOrig | Out-Null }
      Move-Item -LiteralPath $r.Destinazione -Destination $r.Origine -ErrorAction Stop
      $n++
    } catch {
      $msg = '  NON rimessa: ' + $r.Destinazione + '  --  ' + $_.Exception.Message
      Write-Host $msg -ForegroundColor Yellow
      [void]$rilievi.Add($msg)
      $ko++
    }
  }
  Write-Host ('Rimesse a posto: ' + $n + '   NON rimesse: ' + $ko) -ForegroundColor White
  $stampA = (Get-Date).ToString('yyyy.MM.dd HH:mm', $INV)
  $rigA = New-Object System.Collections.ArrayList
  [void]$rigA.Add('ESITO ANNULLAMENTO')
  [void]$rigA.Add('data: ' + $stampA)
  [void]$rigA.Add('log usato: ' + $ultimo.Name)
  [void]$rigA.Add('rimesse a posto: ' + $n + '   non rimesse: ' + $ko)
  foreach ($m in $rilievi) { [void]$rigA.Add($m) }
  $fileA = Join-Path $Desktop ('annulla_desktop_' + (Get-Date).ToString('yyyy-MM-dd_HHmmss', $INV) + '.txt')
  Set-Content -LiteralPath $fileA -Value $rigA -Encoding UTF8
  Write-Host ('Referto: ' + $fileA) -ForegroundColor Gray
  if ($ko -gt 0) { Write-Host 'ESITO: PARZIALE -- leggi le righe gialle sopra e il referto.' -ForegroundColor Red; exit 1 }
  Write-Host 'ESITO: OK' -ForegroundColor Green
  exit 0
}

# Categoria => parole chiave (confronto: sottostringa su nome cartella in minuscolo).
# ORDINE = PRIORITA': la prima che combacia vince, quindi le piu' SPECIFICHE stanno sopra.
$Categorie = [ordered]@{
  'Slippage_Spread'   = @('spreadlog','slippage','sliplog')
  'Collaudo'          = @('collaudo')
  'Canarino'          = @('canarino')
  'Migrazione'        = @('migrazio','deploy_o','deploy_c')
  'Verifica_ORB'      = @('verifica_orb')
  'Censimenti'        = @('censiment')
  'Pulizia_VPS'       = @('pulizia_vps','backup_pul')
  'Backup'            = @('backup_')
  'R81_Uscite'        = @('r81_uscite')
  'Relativo_R117'     = @('relativo')
  'PostNews'          = @('postnews','post_news','_ism_','news_1330')
  'Caccia_Ticket'     = @('caccia_tick')
  'Pagelle'           = @('pagella','pagelle')
  'Backtest'          = @('backtest','pretest')
  'Config'            = @('config_')
  'Fantasmi'          = @('fantasmi')
  'Trades'            = @('trades')
}

# MAI TOCCARE - esclusioni dichiarate dai gemelli (riordina_desktop.ps1 righe 15-16,
# sistema_cartelle.ps1 righe 45-50, archivia_test_desktop.ps1 riga 146).
# Le TEMATICHE di Claudio (EASYTREND, INDICATORI, BREAKOUT, ...) vanno a
# PREFISSO (non a match esatto): "INDICATORI BACKTEST" non e' "INDICATORI",
# e senza il prefisso la parola chiave "backtest" se la porta via (bug
# riprodotto il 06/09, checklist punto 140).
$Escluse = @(
  'ARCHIVIO_DESKTOP','ARCHIVIO_TEST',
  'ABTG_RISULTATI','ABTG_ZIP','ABTG_DOCUMENTI','ABTG_VARIE','ABTG_ORDINE_LOG'
)
$EsclusePrefisso = @(
  'EASYTREND','INDICATORI','BREAKOUT','NOTTE','PROCE','ALTA VELOCIT','NASDAQ APERTU',
  'DAX E NASD','PIANO DI TRADI','FILE WORD','FILE CHE SCARICO'
)

$Piano          = New-Object System.Collections.ArrayList
$SenzaCategoria = New-Object System.Collections.ArrayList
$Protette       = New-Object System.Collections.ArrayList
$Destinazioni   = New-Object System.Collections.ArrayList
$InCorso        = New-Object System.Collections.ArrayList

$stamp = (Get-Date).ToString('yyyy.MM.dd HH:mm', $INV)
Write-Host ''
if ($Esegui) { Write-Host '*** ESECUZIONE: le cartelle qui sotto vengono SPOSTATE davvero (mai cancellate) ***' -ForegroundColor Red }
else         { Write-Host '*** SOLO ANTEPRIMA: NESSUNA CARTELLA VIENE SPOSTATA, RINOMINATA O CANCELLATA ***' -ForegroundColor Magenta }
Write-Host ('data: ' + $stamp + '   Desktop: ' + $Desktop) -ForegroundColor Gray

foreach ($d in @(Get-ChildItem -LiteralPath $Desktop -Directory -Force -ErrorAction SilentlyContinue)) {
  $nome    = $d.Name
  $nomeMin = $nome.ToLowerInvariant()
  # 1) protette: archivi/cartelle di lavoro dei gemelli (match ESATTO)
  $prot = $false
  if ($Escluse -contains $nome) { $prot = $true }
  # 1-bis) tematiche di Claudio (match a PREFISSO, confronto ORDINALE:
  # su una blacklist non si vuole la cultura it-IT del VPS in mezzo)
  if (-not $prot) {
    foreach ($p in $EsclusePrefisso) {
      if ($nome.ToUpperInvariant().StartsWith($p, [System.StringComparison]::Ordinal)) { $prot = $true; break }
    }
  }
  if ($prot) { [void]$Protette.Add($nome); continue }
  # 2) le cartelle-CATEGORIA sono DESTINAZIONI create da questo stesso script,
  # non "protette": dichiararle protette nel referto sarebbe falso (ci si
  # sposta dentro roba, bug riprodotto il 06/09).
  $dest = $false
  foreach ($c in $Categorie.Keys) { if ($nome -eq $c) { $dest = $true; break } }
  if ($dest) { [void]$Destinazioni.Add($nome); continue }
  # 3) corsa/round ANCORA IN CORSO: si guarda l'ultima scrittura, cartella
  # E contenuto (un round scrive dentro per ore mentre gira).
  $ultimaScrittura = $d.LastWriteTime
  foreach ($f in @(Get-ChildItem -LiteralPath $d.FullName -Recurse -Force -ErrorAction SilentlyContinue)) {
    if ($f.LastWriteTime -gt $ultimaScrittura) { $ultimaScrittura = $f.LastWriteTime }
  }
  if ((New-TimeSpan -Start $ultimaScrittura -End (Get-Date)).TotalMinutes -lt $MinutiFermo) {
    [void]$InCorso.Add($nome + '  (ultima scrittura ' + $ultimaScrittura.ToString('yyyy-MM-dd HH:mm:ss', $INV) + ')')
    continue
  }
  # 4) categoria
  $trovata = $null
  foreach ($cat in $Categorie.Keys) {
    foreach ($parola in $Categorie[$cat]) {
      if ($nomeMin.Contains($parola)) { $trovata = $cat; break }
    }
    if ($trovata) { break }
  }
  if ($trovata) { [void]$Piano.Add([PSCustomObject]@{ Cartella = $nome; Categoria = $trovata; Percorso = $d.FullName }) }
  else          { [void]$SenzaCategoria.Add($nome) }
}

Write-Host ''
if ($Esegui) { Write-Host '=== SPOSTATE (raggruppate per categoria) ===' -ForegroundColor Cyan }
else         { Write-Host '=== PIANO (cosa verrebbe spostato, raggruppato per categoria) ===' -ForegroundColor Cyan }
$Piano | Group-Object Categoria | Sort-Object Name | ForEach-Object {
  Write-Host ''
  Write-Host ('  ' + $_.Name + '  (' + $_.Count + ' cartelle)') -ForegroundColor Green
  $_.Group | Sort-Object Cartella | ForEach-Object { Write-Host ('    - ' + $_.Cartella) }
}
Write-Host ''
Write-Host ('=== PROTETTE, MAI TOCCATE (' + $Protette.Count + ') ===') -ForegroundColor Cyan
$Protette | Sort-Object | ForEach-Object { Write-Host ('    - ' + $_) }
Write-Host ''
Write-Host ('=== CARTELLE-CATEGORIA GIA'' PRESENTI, sono DESTINAZIONI (' + $Destinazioni.Count + ') ===') -ForegroundColor Cyan
$Destinazioni | Sort-Object | ForEach-Object { Write-Host ('    - ' + $_) }
Write-Host ''
Write-Host ('=== IN CORSO (scritte da meno di ' + $MinutiFermo + ' minuti, SALTATE per sicurezza) (' + $InCorso.Count + ') ===') -ForegroundColor Yellow
$InCorso | Sort-Object | ForEach-Object { Write-Host ('    - ' + $_) }
Write-Host ''
Write-Host ('=== NESSUNA CATEGORIA RICONOSCIUTA (' + $SenzaCategoria.Count + ' cartelle, restano ferme) ===') -ForegroundColor Yellow
$SenzaCategoria | Sort-Object | ForEach-Object { Write-Host ('    - ' + $_) }

# --- ESEGUI: sposta davvero e scrive il log CSV --------------------------
$Log = New-Object System.Collections.ArrayList
$KoMossi = 0
$logFile = ''
if ($Esegui) {
  New-Item -ItemType Directory -Force -Path $LogDir | Out-Null
  foreach ($voce in $Piano) {
    try {
      $destDir = Join-Path $Desktop $voce.Categoria
      New-Item -ItemType Directory -Force -Path $destDir | Out-Null
      $dest = Join-Path $destDir $voce.Cartella
      if (Test-Path -LiteralPath $dest) {
        $dest = Join-Path $destDir ($voce.Cartella + '_' + (Get-Date).ToString('yyyy-MM-dd_HHmmss', $INV))
      }
      Move-Item -LiteralPath $voce.Percorso -Destination $dest -ErrorAction Stop
      [void]$Log.Add([PSCustomObject]@{ Origine = $voce.Percorso; Destinazione = $dest })
    } catch {
      Write-Host ('  NON spostata: ' + $voce.Cartella + '  --  ' + $_.Exception.Message) -ForegroundColor Yellow
      $KoMossi++
    }
  }
  # nome del log al SECONDO (non al minuto): un rilancio a vuoto non deve
  # sovrascrivere il log del giro prima, che serve per -Annulla (bug
  # riprodotto il 06/09: il secondo giro e' idempotente, $Log e' vuoto,
  # Export-Csv scrive comunque un file a 0 byte sopra quello buono).
  if ($Log.Count -gt 0) {
    $logFile = Join-Path $LogDir ('organizza_desktop_' + (Get-Date).ToString('yyyy-MM-dd_HHmmss', $INV) + '.csv')
    $Log | Export-Csv -LiteralPath $logFile -NoTypeInformation -Encoding UTF8
  } else {
    $logFile = '(nessuno spostamento in questo giro: nessun log nuovo scritto, quello del giro precedente resta valido per -Annulla)'
  }
}

# raccolta: il piano/esito finisce ANCHE in un file sul Desktop (regola di casa), cosi' e' rimandabile
# nome al SECONDO: un secondo giro nello stesso minuto non deve sovrascrivere il referto del primo.
$prefisso = if ($Esegui) { 'esito_desktop_' } else { 'piano_desktop_' }
$fileOut = Join-Path $Desktop ($prefisso + (Get-Date).ToString('yyyy-MM-dd_HHmmss', $INV) + '.txt')
$righe = New-Object System.Collections.ArrayList
if ($Esegui) { [void]$righe.Add('ESITO ESECUZIONE - le cartelle sotto sono state spostate davvero') }
else         { [void]$righe.Add('PIANO SIMULATO - nessuna cartella spostata') }
[void]$righe.Add('data: ' + $stamp)
[void]$righe.Add('Desktop: ' + $Desktop)
$Piano | Group-Object Categoria | Sort-Object Name | ForEach-Object {
  [void]$righe.Add('')
  [void]$righe.Add($_.Name + ' (' + $_.Count + ')')
  $_.Group | Sort-Object Cartella | ForEach-Object { [void]$righe.Add('    - ' + $_.Cartella) }
}
[void]$righe.Add('')
[void]$righe.Add('PROTETTE (' + $Protette.Count + '): ' + (($Protette | Sort-Object) -join ', '))
[void]$righe.Add('CARTELLE-CATEGORIA GIA'' PRESENTI, sono DESTINAZIONI (' + $Destinazioni.Count + '): ' + (($Destinazioni | Sort-Object) -join ', '))
[void]$righe.Add('IN CORSO, SALTATE (' + $InCorso.Count + '): ' + (($InCorso | Sort-Object) -join ' | '))
[void]$righe.Add('SENZA CATEGORIA (' + $SenzaCategoria.Count + '): ' + (($SenzaCategoria | Sort-Object) -join ', '))
if ($Esegui) {
  [void]$righe.Add('')
  [void]$righe.Add('spostate con successo: ' + $Log.Count + '   NON spostate: ' + $KoMossi)
  [void]$righe.Add('Log per annullare: ' + $logFile)
}
Set-Content -LiteralPath $fileOut -Value $righe -Encoding UTF8

# zip pronto da mandare (regola delle righe di lancio, punto 2)
$zipOut = Join-Path $Desktop ($prefisso + (Get-Date).ToString('yyyy-MM-dd_HHmmss', $INV) + '.zip')
Compress-Archive -LiteralPath $fileOut -DestinationPath $zipOut -Force

Write-Host ''
Write-Host ('TOTALI  categorizzate: ' + $Piano.Count + '   protette: ' + $Protette.Count + '   destinazioni: ' + $Destinazioni.Count + '   in corso: ' + $InCorso.Count + '   ferme: ' + $SenzaCategoria.Count) -ForegroundColor White
if ($Esegui) {
  Write-Host ('spostate: ' + $Log.Count + '   NON spostate: ' + $KoMossi) -ForegroundColor White
  Write-Host ('Log (serve per annullare): ' + $logFile) -ForegroundColor Gray
  Write-Host 'Per rimettere tutto com''era: rilancia questa riga aggiungendo -Annulla' -ForegroundColor Gray
} else {
  Write-Host '*** QUESTA E'' SOLO UNA ANTEPRIMA: nessuna cartella e'' stata spostata. ***' -ForegroundColor Magenta
  Write-Host 'Per farlo davvero rilancia la stessa riga aggiungendo -Esegui' -ForegroundColor Magenta
}
Write-Host 'File attesi sul Desktop (verificane la presenza):' -ForegroundColor Magenta
Write-Host ('  - ' + (Split-Path -Leaf $fileOut)) -ForegroundColor Magenta
Write-Host ('  - ' + (Split-Path -Leaf $zipOut)) -ForegroundColor Magenta
Write-Host 'Mandami lo ZIP. Controlla la riga "data:" in cima: deve essere di ADESSO.' -ForegroundColor Magenta

if ($Esegui -and $KoMossi -gt 0) { Write-Host 'ESITO: FALLITO -- alcune cartelle NON sono state spostate (righe gialle sopra e nel referto).' -ForegroundColor Red; exit 1 }
Write-Host 'ESITO: OK' -ForegroundColor Green
exit 0
