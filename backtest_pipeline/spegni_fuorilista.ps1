# =====================================================================
#  spegni_fuorilista.ps1 -- spegne i 3 bocciati del fuori-lista (11/08)
#  Decisione di Claudio: "VAI CON LO SPEGNIMENTO".
#  Referto: risultati_archivio/REFERTO_FUORILISTA.md
#
#  SPEGNE (per NOME ESATTO dell'EA -> zero ambiguita' sul Nasdaq):
#    - ABTG_SupRev_DAX_H1_Ottimizzato      (IS rosso ai tick)
#    - ABTG_Nasdaq_Apertura_US_Ottimizzato (doppione mai misurato)
#    - ABTG_DAX_Apertura_EU_Ottimizzato    (doppione mai misurato)
#  NON TOCCA ABTG_SupRev_DOW_H1_Ottimizzato: ha una posizione aperta
#  (970916), si spegne quando torna flat.
#
#  Come pulizia_vps: sposta i .chr in un BACKUP sul Desktop (reversibile).
#  PRIMA: chiudere il VECCHIO MT5 (il -V3 puo' restare acceso).
#  DOPO: riaprire MT5 -> i 3 grafici non ci sono piu'.
# =====================================================================
$ErrorActionPreference = "Stop"

$vecchioAperto = Get-Process -Name "terminal64" -ErrorAction SilentlyContinue |
  Where-Object { $_.Path -like "*BCM Markets MT5 Terminal\*" -and $_.Path -notlike "*-V3*" }
if ($vecchioAperto) {
  Write-Host "!!! Il VECCHIO MT5 e' aperto. Chiudilo e rilancia (il -V3 puo' restare su)." -ForegroundColor Red
  exit 1
}

$root = Join-Path $env:APPDATA "MetaQuotes\Terminal"
$folders = Get-ChildItem $root -Directory -ErrorAction SilentlyContinue | Where-Object {
  Test-Path (Join-Path $_.FullName "origin.txt") }
$old = $folders | Where-Object {
  $o = (Get-Content (Join-Path $_.FullName "origin.txt") -Raw).Trim()
  $o -like "*BCM*MT5*" -and $o -notlike "*-V3*" -and $o -notlike "*MT4*" } | Select-Object -First 1
if (-not $old) { Write-Host "Cartella dati del vecchio MT5 non trovata." -ForegroundColor Red; exit 1 }

$Kill = @("ABTG_SupRev_DAX_H1_Ottimizzato",
          "ABTG_Nasdaq_Apertura_US_Ottimizzato",
          "ABTG_DAX_Apertura_EU_Ottimizzato")

$stamp = Get-Date -Format "yyyyMMdd_HHmm"
$Backup = Join-Path $env:USERPROFILE ("Desktop\backup_fuorilista_" + $stamp)
New-Item -ItemType Directory -Force -Path $Backup | Out-Null
$ChartsRoot = Join-Path $old.FullName "MQL5\Profiles\Charts"

$spenti=@(); $resto=@()
Get-ChildItem $ChartsRoot -Recurse -Filter "*.chr" -ErrorAction SilentlyContinue | ForEach-Object {
  $txt = Get-Content $_.FullName -Raw
  $em = [regex]::Match($txt, "(?s)<expert>.*?path=Experts\\([^\r\n]+)\.ex5")
  if (-not $em.Success) { return }
  $ea = $em.Groups[1].Value.Trim()
  $sm = [regex]::Match($txt, "symbol=([A-Za-z0-9#\.]+)")
  $sym = if ($sm.Success) { $sm.Groups[1].Value } else { "?" }
  if ($Kill -contains $ea) {
    Move-Item $_.FullName (Join-Path $Backup ($ea + "_" + $sym + "_" + $_.Name)) -Force
    $spenti += ("{0} @ {1}" -f $ea, $sym)
  } else { $resto += ("{0} @ {1}" -f $ea, $sym) }
}

Write-Host ""; Write-Host ("SPENTI ({0}) -- attesi 3:" -f $spenti.Count) -ForegroundColor Yellow
$spenti | ForEach-Object { Write-Host ("  - " + $_) -ForegroundColor Yellow }
if ($spenti.Count -ne 3) { Write-Host "  !!! NUMERO INATTESO: manda lo screenshot." -ForegroundColor Red }
Write-Host ""; Write-Host ("RESTANO CON EA ({0}):" -f $resto.Count) -ForegroundColor Green
$resto | Sort-Object | ForEach-Object { Write-Host ("  + " + $_) -ForegroundColor Green }
Write-Host ""
Write-Host "Controllo: fra i RESTANO deve esserci SupRev_DOW_H1_Ottimizzato (si spegne da flat)." -ForegroundColor Cyan
Write-Host ("Backup (per tornare indietro): " + $Backup) -ForegroundColor Gray
Write-Host "Ora RIAPRI il vecchio MT5 e controlla le faccine." -ForegroundColor White
