# =====================================================================
#  installa_guardian.ps1 -- porta il Guardian v1.10 (firme del 18/08)
#  dentro le cartelle dati di MT5: sorgente, include e preset.
#
#  COSA FA: scarica dal branch lavoro (o dall'hash passato) i tre file
#    mql5/Experts/ABTG_Guardian.mq5      -> MQL5\Experts\
#    mql5/Include/ABTG_PausaGuardian.mqh -> MQL5\Include\
#    mql5/Presets/ABTG_Guardian_FTMO_2Step.set -> MQL5\Presets\
#  in TUTTE le cartelle dati MT5 trovate (piccolo e 100k), con copia
#  .prima_v110 dei file esistenti. NON compila (quello si fa in
#  MetaEditor con F7) e NON tocca i grafici.
#
#  MT5 puo' restare APERTO: qui si aggiungono solo file su disco.
#
#  USO:  .\installa_guardian.ps1 [-Ref <hash o branch, default lavoro>]
# =====================================================================
param(
  [string]$Ref = "lavoro"
)
$ErrorActionPreference = "Stop"
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$base = "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/" + $Ref
$file = @(
  @{ Url = "$base/mql5/Experts/ABTG_Guardian.mq5";            Sotto = "MQL5\Experts";  Nome = "ABTG_Guardian.mq5";            Marcatore = "InpMaxOpenRiskPct" },
  @{ Url = "$base/mql5/Include/ABTG_PausaGuardian.mqh";       Sotto = "MQL5\Include";  Nome = "ABTG_PausaGuardian.mqh";       Marcatore = "PausaGiornoAttiva" },
  @{ Url = "$base/mql5/Presets/ABTG_Guardian_FTMO_2Step.set"; Sotto = "MQL5\Presets";  Nome = "ABTG_Guardian_FTMO_2Step.set"; Marcatore = "InpDailyResetHour" }
)

$tmp = Join-Path $env:TEMP "guardian_v110"
if(-not (Test-Path -LiteralPath $tmp)){ New-Item -ItemType Directory -Path $tmp -Force | Out-Null }

Write-Host "=== INSTALLAZIONE GUARDIAN v1.10 (ref: $Ref) ===" -ForegroundColor White
foreach($f in $file){
  $loc = Join-Path $tmp $f.Nome
  Remove-Item -LiteralPath $loc -ErrorAction SilentlyContinue
  Invoke-RestMethod -Uri $f.Url -OutFile $loc -ErrorAction Stop
  if(-not (Select-String -Path $loc -SimpleMatch -Pattern $f.Marcatore -Quiet)){
    Write-Host ("VERSIONE VECCHIA O DOWNLOAD ROTTO: manca '" + $f.Marcatore + "' in " + $f.Nome + ". NON installo niente.") -ForegroundColor Red
    exit 1
  }
  Write-Host ("  scaricato e controllato: " + $f.Nome) -ForegroundColor Green
}

$root = Join-Path $env:APPDATA "MetaQuotes\Terminal"
$dirs = Get-ChildItem $root -Directory -ErrorAction SilentlyContinue |
        Where-Object { Test-Path (Join-Path $_.FullName "MQL5\Experts") }
if(-not $dirs){ Write-Host "Nessuna cartella dati MT5 trovata." -ForegroundColor Red; exit 1 }

$copiati = 0
foreach($d in $dirs){
  Write-Host ""
  Write-Host ("=== " + $d.Name) -ForegroundColor Cyan
  foreach($f in $file){
    $destDir = Join-Path $d.FullName $f.Sotto
    if(-not (Test-Path -LiteralPath $destDir)){ New-Item -ItemType Directory -Path $destDir -Force | Out-Null }
    $dest = Join-Path $destDir $f.Nome
    if(Test-Path -LiteralPath $dest){ Copy-Item -LiteralPath $dest ($dest + ".prima_v110") -Force }
    Copy-Item -LiteralPath (Join-Path $tmp $f.Nome) $dest -Force
    Write-Host ("  installato: " + $f.Sotto + "\" + $f.Nome) -ForegroundColor Green
    $copiati++
  }
}

Write-Host ""
Write-Host ("File installati: " + $copiati + " (backup .prima_v110 accanto agli originali)") -ForegroundColor White
Write-Host "ADESSO: apri MetaEditor (F4 da MT5), apri ABTG_Guardian.mq5 e premi F7." -ForegroundColor Yellow
Write-Host "Se la compilazione da' errori, manda in chat la riga esatta dell'errore." -ForegroundColor Yellow
