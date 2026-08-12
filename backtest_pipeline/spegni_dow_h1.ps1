# =====================================================================
#  spegni_dow_h1.ps1 -- 4' spegnimento del fuori-lista (12/08)
#  ABTG_SupRev_DOW_H1_Ottimizzato: IS ROSSO ai tick (referto fuori-lista
#  dell'11/08), lo spegnimento era rinviato per la posizione aperta
#  970916 -- chiusa in TP l'11/08 (pagella). Ora da flat si spegne.
#
#  NON TOCCA ABTG_SupRev_DOW_H4_Ottimizzato (osservato speciale, PF 2,32).
#  Come i primi 3: sposta il .chr in un BACKUP sul Desktop (reversibile).
#  PRIMA: controlla nella scheda Trade che non ci siano posizioni del
#         SupRev DOW H1, poi CHIUDI il vecchio MT5 (il -V3 puo' restare).
#  DOPO: riapri MT5 -> il grafico non c'e' piu'.
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
  $o -like "*BCM*MT5*" -and $o -notlike "*-V3*" -and $o -notlike "*MT4*" } |
  Sort-Object LastWriteTime -Descending | Select-Object -First 1
if (-not $old) { Write-Host "Cartella dati del vecchio MT5 non trovata." -ForegroundColor Red; exit 1 }
Write-Host ("terminal: " + $old.Name) -ForegroundColor Gray

$Kill = @("ABTG_SupRev_DOW_H1_Ottimizzato")

$stamp = Get-Date -Format "yyyyMMdd_HHmm"
$Backup = Join-Path $env:USERPROFILE ("Desktop\backup_dow_h1_" + $stamp)
New-Item -ItemType Directory -Force -Path $Backup | Out-Null
$ChartsRoot = Join-Path $old.FullName "MQL5\Profiles\Charts"

$spenti=@(); $resto=@()
Get-ChildItem $ChartsRoot -Recurse -Filter "*.chr" -ErrorAction SilentlyContinue | ForEach-Object {
  $txt = Get-Content $_.FullName -Raw
  $em = [regex]::Match($txt, "(?s)<expert>.*?path=Experts\\([^\r\n]+)\.ex5")
  if (-not $em.Success) { return }
  $ea = ($em.Groups[1].Value.Trim() -split '\\')[-1]
  $sm = [regex]::Match($txt, "symbol=([A-Za-z0-9#\.]+)")
  $sym = if ($sm.Success) { $sm.Groups[1].Value } else { "?" }
  if ($Kill -contains $ea) {
    Move-Item $_.FullName (Join-Path $Backup ($ea + "_" + $sym + "_" + $_.Name)) -Force
    $spenti += ("{0} @ {1}" -f $ea, $sym)
  } else { $resto += ("{0} @ {1}" -f $ea, $sym) }
}

Write-Host ""; Write-Host ("SPENTI ({0}) -- atteso 1:" -f $spenti.Count) -ForegroundColor Yellow
$spenti | ForEach-Object { Write-Host ("  - " + $_) -ForegroundColor Yellow }
if ($spenti.Count -ne 1) { Write-Host "  !!! NUMERO INATTESO: manda lo screenshot." -ForegroundColor Red }
Write-Host ""; Write-Host ("RESTANO CON EA ({0}):" -f $resto.Count) -ForegroundColor Green
$resto | Sort-Object | ForEach-Object { Write-Host ("  + " + $_) -ForegroundColor Green }
Write-Host ""
Write-Host "Controllo: fra i RESTANO deve esserci SupRev_DOW_H4_Ottimizzato (osservato, NON si spegne)." -ForegroundColor Cyan
Write-Host ("Backup (per tornare indietro): " + $Backup) -ForegroundColor Gray
Write-Host "Ora RIAPRI il vecchio MT5 e controlla le faccine." -ForegroundColor White
