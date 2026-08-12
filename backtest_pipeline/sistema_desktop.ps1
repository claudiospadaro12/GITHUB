# =====================================================================
#  sistema_desktop.ps1 -- mette in ordine il Desktop (PC o VPS).
#  NON CANCELLA NULLA: sposta solo i file/cartelle NOSTRI (riconosciuti
#  per nome) in Desktop\ABTG_archivio\<categoria>. Tutto il resto
#  (roba personale, collegamenti) NON viene toccato.
#  La pagella di OGGI resta sul Desktop (arriva la sera, deve restare
#  a vista); le vecchie vanno in archivio.
#  Riutilizzabile: si puo' rilanciare quando il Desktop si riempie.
# =====================================================================
$ErrorActionPreference = "Stop"

$desk = Join-Path $env:USERPROFILE "Desktop"
$arch = Join-Path $desk "ABTG_archivio"
$oggi = Get-Date -Format "yyyy-MM-dd"

# categoria -> pattern (file E cartelle)
$Categorie = [ordered]@{
  "zip_prove"    = @("r*_*.zip","coda_*.zip","notte_*.zip","alta_v*.zip","v21_report.zip","*fasciaB*.zip","*fascia_b*.zip")
  "cartelle_raccolte" = @("r[0-9]*","coda_*","notte_*","alta_v*","misura_v21","risultati_*","scan_*","valid_*")
  "backup"       = @("backup_*")
  "referti_txt"  = @("verifica_*.txt","v21_config.txt","pagella_*.txt")
}

$mossi = 0; $lasciati = 0
$voci = Get-ChildItem $desk -ErrorAction SilentlyContinue | Where-Object { $_.Name -ne "ABTG_archivio" }
foreach ($v in $voci) {
  $dest = $null
  foreach ($cat in $Categorie.Keys) {
    foreach ($pat in $Categorie[$cat]) {
      if ($v.Name -like $pat) { $dest = $cat; break }
    }
    if ($dest) { break }
  }
  # la pagella di oggi resta a vista
  if ($v.Name -eq ("pagella_" + $oggi + ".txt")) { $dest = $null }
  # mai toccare i collegamenti
  if ($v.Extension -eq ".lnk") { $dest = $null }

  if ($dest) {
    $catDir = Join-Path $arch $dest
    New-Item -ItemType Directory -Force -Path $catDir | Out-Null
    Move-Item $v.FullName -Destination (Join-Path $catDir $v.Name) -Force
    Write-Host ("  -> {0}\{1}" -f $dest, $v.Name) -ForegroundColor Green
    $mossi++
  } else {
    $lasciati++
  }
}

Write-Host ""
Write-Host ("ORDINATI: {0} elementi in Desktop\ABTG_archivio\ (4 categorie)." -f $mossi) -ForegroundColor Cyan
Write-Host ("NON TOCCATI: {0} elementi (personali, collegamenti, pagella di oggi)." -f $lasciati) -ForegroundColor Gray
Write-Host "Niente e' stato cancellato: e' tutto dentro ABTG_archivio, spostabile a mano se serve." -ForegroundColor Gray
