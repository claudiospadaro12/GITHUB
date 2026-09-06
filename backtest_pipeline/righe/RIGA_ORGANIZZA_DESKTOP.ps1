# MARCATORE_RIGA_ORGANIZZA_DESKTOP_v1
# organizza_desktop.ps1 -- SOLA SIMULAZIONE: legge e stampa, non muove niente.
$ErrorActionPreference = 'Continue'
$INV = [System.Globalization.CultureInfo]::InvariantCulture
$Desktop = [Environment]::GetFolderPath('Desktop')
if (-not (Test-Path -LiteralPath $Desktop)) { Write-Host 'Desktop non trovato.' -ForegroundColor Red; exit 1 }

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
Write-Host '*** SOLO SIMULAZIONE: NESSUNA CARTELLA VIENE SPOSTATA, RINOMINATA O CANCELLATA ***' -ForegroundColor Magenta
Write-Host ("data: " + $stamp + "   Desktop: " + $Desktop) -ForegroundColor Gray

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
  if ($trovata) { [void]$Piano.Add([PSCustomObject]@{ Cartella = $nome; Categoria = $trovata }) }
  else          { [void]$SenzaCategoria.Add($nome) }
}

Write-Host ''
Write-Host '=== PIANO (cosa verrebbe spostato, raggruppato per categoria) ===' -ForegroundColor Cyan
$Piano | Group-Object Categoria | Sort-Object Name | ForEach-Object {
  Write-Host ''
  Write-Host ('  ' + $_.Name + '  (' + $_.Count + ' cartelle)') -ForegroundColor Green
  $_.Group | Sort-Object Cartella | ForEach-Object { Write-Host ('    - ' + $_.Cartella) }
}
Write-Host ''
Write-Host ('=== PROTETTE, MAI TOCCATE (' + $Protette.Count + ') ===') -ForegroundColor Cyan
$Protette | Sort-Object | ForEach-Object { Write-Host ('    - ' + $_) }
Write-Host ''
Write-Host ('=== NESSUNA CATEGORIA RICONOSCIUTA (' + $SenzaCategoria.Count + ' cartelle, resterebbero ferme) ===') -ForegroundColor Yellow
$SenzaCategoria | Sort-Object | ForEach-Object { Write-Host ('    - ' + $_) }

# raccolta: il piano finisce ANCHE in un file sul Desktop (regola di casa), cosi' e' rimandabile
$fileOut = Join-Path $Desktop ('piano_desktop_' + (Get-Date).ToString('yyyy-MM-dd_HHmm', $INV) + '.txt')
$righe = New-Object System.Collections.ArrayList
[void]$righe.Add('PIANO SIMULATO - nessuna cartella spostata')
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
Set-Content -LiteralPath $fileOut -Value $righe -Encoding UTF8

# zip pronto da mandare (regola delle righe di lancio, punto 2)
$zipOut = Join-Path $Desktop ('piano_desktop_' + (Get-Date).ToString('yyyy-MM-dd_HHmm', $INV) + '.zip')
Compress-Archive -LiteralPath $fileOut -DestinationPath $zipOut -Force

Write-Host ''
Write-Host ('TOTALI  categorizzate: ' + $Piano.Count + '   protette: ' + $Protette.Count + '   ferme: ' + $SenzaCategoria.Count) -ForegroundColor White
Write-Host '*** QUESTA E'' SOLO UNA SIMULAZIONE: nessuna cartella e'' stata spostata. ***' -ForegroundColor Magenta
Write-Host 'File attesi sul Desktop (verificane la presenza):' -ForegroundColor Magenta
Write-Host ('  - ' + (Split-Path -Leaf $fileOut)) -ForegroundColor Magenta
Write-Host ('  - ' + (Split-Path -Leaf $zipOut)) -ForegroundColor Magenta
Write-Host 'Mandami lo ZIP. Controlla la riga "data:" in cima: deve essere di ADESSO.' -ForegroundColor Magenta
