# MARCATORE_RIGA_ORGANIZZA_DESKTOP_v2
# organizza_desktop.ps1 -- ANTEPRIMA di default (non muove niente).
#   -Esegui   -> sposta davvero, scrive il log CSV (serve per -Annulla)
#   -Annulla  -> rilegge l'ultimo log di QUESTO script e rimette tutto com'era
param(
  [switch]$Esegui,
  [switch]$Annulla
)
$ErrorActionPreference = 'Continue'
$INV = [System.Globalization.CultureInfo]::InvariantCulture
$Desktop = [Environment]::GetFolderPath('Desktop')
if (-not (Test-Path -LiteralPath $Desktop)) { Write-Host 'Desktop non trovato.' -ForegroundColor Red; exit 1 }
$LogDir = Join-Path $Desktop 'ABTG_ORDINE_LOG'

# --- ANNULLA: rilegge l'ultimo log DI QUESTO SCRIPT e riporta tutto indietro ---
if ($Annulla) {
  $ultimo = Get-ChildItem -LiteralPath $LogDir -Filter 'organizza_desktop_*.csv' -ErrorAction SilentlyContinue |
            Sort-Object LastWriteTime -Descending | Select-Object -First 1
  if (-not $ultimo) { Write-Host 'Nessun log di organizza_desktop da annullare.' -ForegroundColor Yellow; exit 0 }
  Write-Host ('ANNULLO usando ' + $ultimo.Name) -ForegroundColor Cyan
  $n = 0
  foreach ($r in (Import-Csv -LiteralPath $ultimo.FullName)) {
    if (Test-Path -LiteralPath $r.Destinazione) {
      $cartellaOrig = Split-Path -Parent $r.Origine
      if (-not (Test-Path -LiteralPath $cartellaOrig)) { New-Item -ItemType Directory -Force -Path $cartellaOrig | Out-Null }
      Move-Item -LiteralPath $r.Destinazione -Destination $r.Origine -Force
      $n++
    }
  }
  Write-Host ('FATTO: ' + $n + ' cartelle rimesse al loro posto.') -ForegroundColor Green
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
# sistema_cartelle.ps1 righe 45-50, archivia_test_desktop.ps1 riga 146):
# le cartelle TEMATICHE di Claudio sono gia' ordine suo, piu' gli archivi esistenti.
$Escluse = @(
  'EASYTREND','INDICATORI','BREAKOUT','ARCHIVIO_DESKTOP','ARCHIVIO_TEST',
  'ABTG_RISULTATI','ABTG_ZIP','ABTG_DOCUMENTI','ABTG_VARIE','ABTG_ORDINE_LOG'
)
$EsclusePrefisso = @('NOTTE','PROCE','ALTA VELOCIT','NASDAQ APERTU','DAX E NASD','PIANO DI TRADI','FILE WORD','FILE CHE SCARICO')

$Piano          = New-Object System.Collections.ArrayList
$SenzaCategoria = New-Object System.Collections.ArrayList
$Protette       = New-Object System.Collections.ArrayList

$stamp = (Get-Date).ToString('yyyy.MM.dd HH:mm', $INV)
Write-Host ''
if ($Esegui) { Write-Host '*** ESECUZIONE: le cartelle qui sotto vengono SPOSTATE davvero (mai cancellate) ***' -ForegroundColor Red }
else         { Write-Host '*** SOLO ANTEPRIMA: NESSUNA CARTELLA VIENE SPOSTATA, RINOMINATA O CANCELLATA ***' -ForegroundColor Magenta }
Write-Host ('data: ' + $stamp + '   Desktop: ' + $Desktop) -ForegroundColor Gray

foreach ($d in @(Get-ChildItem -LiteralPath $Desktop -Directory -Force -ErrorAction SilentlyContinue)) {
  $nome    = $d.Name
  $nomeMin = $nome.ToLowerInvariant()
  # 1) protette: tematiche di Claudio, archivi, e le cartelle-CATEGORIA stesse (niente auto-annidamento)
  $prot = $false
  if ($Escluse -contains $nome) { $prot = $true }
  if (-not $prot) { foreach ($p in $EsclusePrefisso) { if ($nome.ToUpperInvariant().StartsWith($p)) { $prot = $true; break } } }
  if (-not $prot) { foreach ($c in $Categorie.Keys) { if ($nome -eq $c) { $prot = $true; break } } }
  if ($prot) { [void]$Protette.Add($nome); continue }
  # 2) categoria
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
Write-Host ('=== NESSUNA CATEGORIA RICONOSCIUTA (' + $SenzaCategoria.Count + ' cartelle, restano ferme) ===') -ForegroundColor Yellow
$SenzaCategoria | Sort-Object | ForEach-Object { Write-Host ('    - ' + $_) }

# --- ESEGUI: sposta davvero e scrive il log CSV --------------------------
$Log = New-Object System.Collections.ArrayList
if ($Esegui) {
  New-Item -ItemType Directory -Force -Path $LogDir | Out-Null
  foreach ($voce in $Piano) {
    $destDir = Join-Path $Desktop $voce.Categoria
    New-Item -ItemType Directory -Force -Path $destDir | Out-Null
    $dest = Join-Path $destDir $voce.Cartella
    if (Test-Path -LiteralPath $dest) {
      $dest = Join-Path $destDir ($voce.Cartella + '_' + (Get-Date).ToString('yyyy-MM-dd_HHmmss', $INV))
    }
    Move-Item -LiteralPath $voce.Percorso -Destination $dest -Force
    [void]$Log.Add([PSCustomObject]@{ Origine = $voce.Percorso; Destinazione = $dest })
  }
  $logFile = Join-Path $LogDir ('organizza_desktop_' + (Get-Date).ToString('yyyy-MM-dd_HHmm', $INV) + '.csv')
  $Log | Export-Csv -LiteralPath $logFile -NoTypeInformation -Encoding UTF8
}

# raccolta: il piano/esito finisce ANCHE in un file sul Desktop (regola di casa), cosi' e' rimandabile
$prefisso = if ($Esegui) { 'esito_desktop_' } else { 'piano_desktop_' }
$fileOut = Join-Path $Desktop ($prefisso + (Get-Date).ToString('yyyy-MM-dd_HHmm', $INV) + '.txt')
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
[void]$righe.Add('SENZA CATEGORIA (' + $SenzaCategoria.Count + '): ' + (($SenzaCategoria | Sort-Object) -join ', '))
if ($Esegui) { [void]$righe.Add(''); [void]$righe.Add('Log per annullare: ' + $logFile) }
Set-Content -LiteralPath $fileOut -Value $righe -Encoding UTF8

# zip pronto da mandare (regola delle righe di lancio, punto 2)
$zipOut = Join-Path $Desktop ($prefisso + (Get-Date).ToString('yyyy-MM-dd_HHmm', $INV) + '.zip')
Compress-Archive -LiteralPath $fileOut -DestinationPath $zipOut -Force

Write-Host ''
Write-Host ('TOTALI  categorizzate: ' + $Piano.Count + '   protette: ' + $Protette.Count + '   ferme: ' + $SenzaCategoria.Count) -ForegroundColor White
if ($Esegui) {
  Write-Host ('*** FATTO: ' + $Log.Count + ' cartelle spostate. ***') -ForegroundColor Green
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
