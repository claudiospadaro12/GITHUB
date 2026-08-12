# =====================================================================
#  spegni_v21.ps1 -- stacca NasdaqOpeningBreakout_EA_v21 dal vivo (12/08)
#  Decisione di Claudio: "A: spegnere, PERO' ci lavoriamo" -> prima di
#  spegnere SALVA la config esatta (inputs dal .chr) in
#  Desktop\v21_config.txt: e' la base per l'imbuto nel tester.
#  Match per prefisso "NasdaqOpeningBreakout" (il file ex5 puo' avere
#  suffissi tipo " (1)"). Backup reversibile sul Desktop.
#  PRIMA: chiudi il vecchio MT5 (il -V3 puo' restare).
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

$stamp = Get-Date -Format "yyyyMMdd_HHmm"
$Backup = Join-Path $env:USERPROFILE ("Desktop\backup_v21_" + $stamp)
New-Item -ItemType Directory -Force -Path $Backup | Out-Null
$ChartsRoot = Join-Path $old.FullName "MQL5\Profiles\Charts"
$CfgOut = Join-Path $env:USERPROFILE "Desktop\v21_config.txt"

$spenti=@(); $resto=@(); $cfg=@()
Get-ChildItem $ChartsRoot -Recurse -Filter "*.chr" -ErrorAction SilentlyContinue | ForEach-Object {
  $txt = Get-Content $_.FullName -Raw
  $em = [regex]::Match($txt, "(?s)<expert>.*?path=Experts\\([^\r\n]+)\.ex5")
  if (-not $em.Success) { return }
  $ea = ($em.Groups[1].Value.Trim() -split '\\')[-1]
  $sm = [regex]::Match($txt, "symbol=([A-Za-z0-9#\.]+)")
  $sym = if ($sm.Success) { $sm.Groups[1].Value } else { "?" }
  if ($ea -like "NasdaqOpeningBreakout*") {
    # salva la config PRIMA di spegnere
    $cfg += ("; EA: {0} @ {1}  (da {2}, salvato {3})" -f $ea,$sym,$_.Name,$stamp)
    $pm = [regex]::Match($txt, "period=([0-9]+)")
    if ($pm.Success) { $cfg += ("; period grafico = " + $pm.Groups[1].Value) }
    $im = [regex]::Match($txt, "(?s)<expert>.*?<inputs>(.*?)</inputs>")
    if ($im.Success) {
      foreach ($l in ($im.Groups[1].Value -split "\r?\n")) {
        if ($l -match "^\s*[A-Za-z0-9_]+=") { $cfg += $l.Trim() }
      }
    } else { $cfg += "; ATTENZIONE: blocco inputs non trovato nel .chr" }
    Move-Item $_.FullName (Join-Path $Backup ($ea + "_" + $sym + "_" + $_.Name)) -Force
    $spenti += ("{0} @ {1}" -f $ea, $sym)
  } else { $resto += ("{0} @ {1}" -f $ea, $sym) }
}

if ($cfg.Count -gt 0) {
  $cfg -join "`r`n" | Set-Content -Path $CfgOut -Encoding ASCII
  Write-Host ("CONFIG SALVATA in: " + $CfgOut + " (" + $cfg.Count + " righe)") -ForegroundColor Cyan
}

Write-Host ""; Write-Host ("SPENTI ({0}) -- atteso 1:" -f $spenti.Count) -ForegroundColor Yellow
$spenti | ForEach-Object { Write-Host ("  - " + $_) -ForegroundColor Yellow }
if ($spenti.Count -ne 1) { Write-Host "  !!! NUMERO INATTESO: manda lo screenshot." -ForegroundColor Red }
Write-Host ""; Write-Host ("RESTANO CON EA ({0}) -- attesi 20:" -f $resto.Count) -ForegroundColor Green
$resto | Sort-Object | ForEach-Object { Write-Host ("  + " + $_) -ForegroundColor Green }
Write-Host ""
Write-Host ("Backup (per tornare indietro): " + $Backup) -ForegroundColor Gray
Write-Host "Ora RIAPRI il vecchio MT5 e mandami Desktop\v21_config.txt." -ForegroundColor White
