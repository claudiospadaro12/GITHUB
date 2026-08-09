# =====================================================================
#  estrai_set_forward.ps1 -- estrae i parametri degli EA dai grafici
#  del VECCHIO MT5 (file .chr) e scrive i .set nella cartella Presets
#  della NUOVA istanza (BCM MT5 PROP), col rischio gia' cambiato:
#  0.65% per tutti, 0.3% per l'ORB (taratura dal referto portafoglio).
#
#  PRIMA DI LANCIARE: CHIUDERE il vecchio MT5 (scrive i .chr su disco
#  con i valori correnti). Poi si puo' riaprire subito.
#
#  USO:  powershell -ExecutionPolicy Bypass -File .\estrai_set_forward.ps1
# =====================================================================
$ErrorActionPreference = "Stop"

$root = Join-Path $env:APPDATA "MetaQuotes\Terminal"
$folders = Get-ChildItem $root -Directory -ErrorAction SilentlyContinue | Where-Object {
  Test-Path (Join-Path $_.FullName "origin.txt")
}
$map = @{}
foreach ($f in $folders) { $map[$f.FullName] = (Get-Content (Join-Path $f.FullName "origin.txt") -Raw).Trim() }

$new = $folders | Where-Object { $map[$_.FullName] -like "*PROP*" } | Select-Object -First 1
$old = $folders | Where-Object { $map[$_.FullName] -notlike "*PROP*" -and $map[$_.FullName] -like "*BCM*" } | Select-Object -First 1

if (-not $new -or -not $old) {
  Write-Host "Non trovo le due istanze (vecchia BCM / nuova con 'PROP' nel percorso):" -ForegroundColor Red
  foreach ($f in $folders) { Write-Host ("  {0} -> {1}" -f $f.Name, $map[$f.FullName]) }
  exit 1
}
Write-Host ("VECCHIA istanza: " + $map[$old.FullName]) -ForegroundColor Gray
Write-Host ("NUOVA istanza  : " + $map[$new.FullName]) -ForegroundColor Gray

$dest = Join-Path $new.FullName "MQL5\Presets"
New-Item -ItemType Directory -Force -Path $dest | Out-Null

# EA -> nome set | rischio da impostare
$targets = @{
  "ABTG_DAX_Apertura_EU"                    = "dax_forward|0.65"
  "ABTG_Dow_Apertura_US"                    = "dow_forward|0.65"
  "ABTG_MaxMinNotte_DAX_Short_Ottimizzato"  = "maxmin_forward|0.65"
  "ABTG_SupertrendReversal"                 = "nikkei_forward|0.65"
  "ABTG_ORB_Ottimizzato"                    = "orb_forward|0.3"
}

$chrs = Get-ChildItem (Join-Path $old.FullName "Profiles\Charts") -Recurse -Filter "*.chr" -ErrorAction SilentlyContinue |
        Sort-Object LastWriteTime -Descending
if (-not $chrs) { Write-Host "Nessun grafico (.chr) trovato nella vecchia istanza." -ForegroundColor Red; exit 1 }

foreach ($ea in $targets.Keys) {
  $parts = $targets[$ea] -split '\|'
  $setName = $parts[0]; $rischio = $parts[1]
  $trovato = $false
  foreach ($chr in $chrs) {
    $txt = Get-Content $chr.FullName -Raw
    if ($txt -notmatch [regex]::Escape("Experts\$ea.ex5")) { continue }
    $em = [regex]::Match($txt, "(?s)<expert>.*?</expert>")
    if (-not $em.Success) { continue }
    $im = [regex]::Match($em.Value, "(?s)<inputs>(.*?)</inputs>")
    if (-not $im.Success) { continue }
    $lines = @()
    $vecchioRischio = "?"
    foreach ($l in ($im.Groups[1].Value -split "`r?`n")) {
      $l = $l.Trim()
      if ($l -eq "") { continue }
      if ($l -match "^InpRiskPercent=(.*)$") { $vecchioRischio = $Matches[1]; $l = "InpRiskPercent=$rischio" }
      $lines += $l
    }
    if ($lines.Count -eq 0) { continue }
    $out = Join-Path $dest "$setName.set"
    $lines | Set-Content -Path $out -Encoding ASCII
    Write-Host ("OK  {0,-42} -> {1}.set  ({2} parametri, rischio {3} -> {4}, grafico salvato {5:dd/MM HH:mm})" -f `
      $ea, $setName, $lines.Count, $vecchioRischio, $rischio, $chr.LastWriteTime) -ForegroundColor Green
    $trovato = $true
    break
  }
  if (-not $trovato) { Write-Host ("MANCA: {0}  (nessun grafico del vecchio MT5 ce l'ha sopra)" -f $ea) -ForegroundColor Red }
}

Write-Host ""
Write-Host "Controllo: le date 'grafico salvato' devono essere di POCHI MINUTI FA" -ForegroundColor Yellow
Write-Host "(= vecchio MT5 chiuso appena prima del lancio). Se una data e' vecchia," -ForegroundColor Yellow
Write-Host "quel .set puo' essere stantio: chiudere il vecchio MT5 e rilanciare." -ForegroundColor Yellow
