# =====================================================================
#  archivia_test_desktop.ps1 -- MARCATORE_ARCHIVIA_V1
#  Mette ORDINE sul Desktop del PC di backtest: tutte le cartelle e gli
#  zip dei TEST finiscono in UNA cartella sola (Desktop\ARCHIVIO_TEST),
#  rinominati con la data davanti (aaaa-mm-gg_hhmm_nome) cosi' l'ordine
#  alfabetico E' l'ordine cronologico: il meno recente in cima, l'ultimo
#  test sempre IN FONDO alla sequenza.
#
#  Richiesta di Claudio del 23/08/2026: "metti in una cartella sola in
#  ordine dal meno recente le cartelle dei test... e quando facciamo un
#  test la cartella zippata deve finire alla fine della sequenza".
#
#  COME FUNZIONA:
#  - SPOSTA (mai cancella) dal Desktop dentro ARCHIVIO_TEST tutto cio'
#    che corrisponde ai pattern dei NOSTRI test (lista chiusa, sotto):
#    niente pattern = niente spostamento. Le cartelle personali non
#    vengono toccate.
#  - Il prefisso data viene dall'ultima modifica del file/cartella.
#  - E' RIESEGUIBILE: ogni nuovo lancio raccoglie solo i test nuovi
#    comparsi sul Desktop e li accoda (la data li mette in fondo da soli).
#  - `-Installa` crea un'attivita' pianificata giornaliera (23:30) che
#    lo rilancia da sola: cosi' il Desktop resta in ordine senza pensarci
#    (stesso schema di scarica_pagella.ps1 -Installa).
#
#  NON tocca MT5, non tocca il repo, non cancella niente.
#
#  USO:
#    powershell -ExecutionPolicy Bypass -File .\archivia_test_desktop.ps1
#    powershell -ExecutionPolicy Bypass -File .\archivia_test_desktop.ps1 -Installa
# =====================================================================
param([switch]$Installa)
$ErrorActionPreference = "Stop"
$INV = [System.Globalization.CultureInfo]::InvariantCulture

function Trova-Desktop {
  foreach ($p in @([Environment]::GetFolderPath("Desktop"),
                   (Join-Path $env:USERPROFILE "Desktop"),
                   (Join-Path $env:USERPROFILE "OneDrive\Desktop"))) {
    if ($p -and (Test-Path $p)) { return $p }
  }
  return $env:USERPROFILE
}
$Desktop = Trova-Desktop
$Archivio = Join-Path $Desktop "ARCHIVIO_TEST"
New-Item -ItemType Directory -Force -Path $Archivio | Out-Null

# --- la LISTA CHIUSA dei pattern dei nostri test ----------------------
#  Solo roba prodotta dalle righe di lancio e dai driver di casa.
#  Un nome che non corrisponde NON viene toccato.
$Pattern = @(
  'R[0-9]+_*',            # R97_ORB_NASUSD_CORSA_*, R100_ORO_FLOTTA_*, ecc. (cartelle e zip)
  'risultati_*',          # test_orb_toolkit e simili
  'verifica_*',           # verifica_orb*, verifica_autotest_*, verifica_a1_*
  'config_dax*',          # config_in_uso
  'config_in_uso*',
  'OptReport*',
  'pagella_*',            # referti serali
  'ini_orb*',
  'src_v2*',
  'walkforward_*',
  'censimento_*',
  'referto_*'
)

$mossi = 0; $saltati = 0
$voci = @(Get-ChildItem -LiteralPath $Desktop -Force -ErrorAction SilentlyContinue |
          Where-Object { $_.Name -ne 'ARCHIVIO_TEST' })
foreach ($v in $voci) {
  $match = $false
  foreach ($pat in $Pattern) { if ($v.Name -like $pat) { $match = $true; break } }
  if (-not $match) { continue }
  $prefisso = $v.LastWriteTime.ToString("yyyy-MM-dd_HHmm", $INV)
  $nuovo = $prefisso + "_" + $v.Name
  # se il nome ha GIA' il prefisso data (rilancio su file gia' archiviati
  # per sbaglio sul Desktop), non raddoppiarlo
  if ($v.Name -match '^\d{4}-\d{2}-\d{2}_\d{4}_') { $nuovo = $v.Name }
  $dest = Join-Path $Archivio $nuovo
  $k = 1
  while (Test-Path -LiteralPath $dest) {
    $dest = Join-Path $Archivio ($nuovo + "_" + $k)
    $k++
    if ($k -gt 99) { break }
  }
  try {
    Move-Item -LiteralPath $v.FullName -Destination $dest -ErrorAction Stop
    Write-Host ("  archiviato: " + $v.Name + "  ->  " + (Split-Path -Leaf $dest)) -ForegroundColor Green
    $mossi++
  } catch {
    Write-Host ("  NON spostato (in uso?): " + $v.Name + "  -- " + $_.Exception.Message) -ForegroundColor Yellow
    $saltati++
  }
}

Write-Host ""
Write-Host ("=== ARCHIVIO TEST ===") -ForegroundColor Cyan
Write-Host ("  spostati in questo giro : " + $mossi)
if ($saltati -gt 0) { Write-Host ("  NON spostati (in uso)   : " + $saltati + "  (chiudi i programmi che li tengono aperti e rilancia)") -ForegroundColor Yellow }
$tot = @(Get-ChildItem -LiteralPath $Archivio -Force -ErrorAction SilentlyContinue).Count
Write-Host ("  totale in ARCHIVIO_TEST : " + $tot)
Write-Host ("  cartella                : " + $Archivio)
Write-Host ("  Ordina per NOME in Esplora risorse: il meno recente sta in cima," ) -ForegroundColor Gray
Write-Host ("  l'ultimo test finisce SEMPRE in fondo (il prefisso data fa da solo).") -ForegroundColor Gray

# --- -Installa: attivita' pianificata giornaliera alle 23:30 ----------
if ($Installa) {
  $me = $MyInvocation.MyCommand.Path
  if (-not $me) { Write-Host "Impossibile installare: script senza percorso (eseguito inline?). Scaricalo con -OutFile e rilancia." -ForegroundColor Red; exit 1 }
  $azione  = New-ScheduledTaskAction -Execute "powershell.exe" -Argument ("-NoProfile -ExecutionPolicy Bypass -File `"" + $me + "`"")
  $innesco = New-ScheduledTaskTrigger -Daily -At 23:30
  Register-ScheduledTask -TaskName "ABTG_ArchiviaTestDesktop" -Action $azione -Trigger $innesco -Description "Archivia le cartelle dei test dal Desktop in ARCHIVIO_TEST (ordine cronologico)" -Force | Out-Null
  Write-Host ""
  Write-Host "Attivita' pianificata installata: ogni sera alle 23:30 il Desktop si riordina da solo." -ForegroundColor Green
  Write-Host ("  script usato dall'attivita': " + $me) -ForegroundColor Gray
}
exit 0
