# =====================================================================
#  riordina_desktop.ps1 -- mette in ordine il Desktop (14/08/2026)
#  Richiesta di Claudio: "tutto in cartelle in ordine, niente file sparsi".
#
#  COSA FA (in questo ordine):
#    1) crea la struttura ABTG_RISULTATI\<famiglia>, ABTG_ZIP,
#       ABTG_DOCUMENTI (+ ABTG_VARIE solo con -Tutto);
#    2) sposta le cartelle dei round riconosciute dal NOME (bb_, gap_,
#       cost_, larry_, ez_, orb_, oro_, ...) nella famiglia giusta;
#    3) sposta gli .zip in ABTG_ZIP e i documenti sparsi in ABTG_DOCUMENTI;
#    4) scrive un LOG CSV di ogni spostamento, cosi' si puo' ANNULLARE.
#
#  COSA NON TOCCA MAI (per non rompere il Desktop):
#    - collegamenti e programmi (.lnk .url .exe .msi .bat .cmd)
#    - le cartelle gia' tematiche di Claudio (EASYTREND, INDICATORI,
#      PIANO DI TRADING, ...): sono gia' ordine, non si spostano
#    - desktop.ini e i file nascosti/di sistema
#
#  USO (PC di backtest o VPS, PowerShell normale):
#    powershell -ExecutionPolicy Bypass -File .\riordina_desktop.ps1
#        -> ANTEPRIMA: stampa cosa farebbe, NON muove niente
#    powershell -ExecutionPolicy Bypass -File .\riordina_desktop.ps1 -Esegui
#        -> esegue davvero e scrive il log
#    powershell -ExecutionPolicy Bypass -File .\riordina_desktop.ps1 -Esegui -Tutto
#        -> come sopra, ma sposta in ABTG_VARIE anche cio' che non
#           riconosce (sempre tranne programmi e cartelle tematiche)
#    powershell -ExecutionPolicy Bypass -File .\riordina_desktop.ps1 -Annulla
#        -> rimette TUTTO com'era, leggendo l'ultimo log
# =====================================================================
param(
  [switch]$Esegui,
  [switch]$Tutto,
  [switch]$Annulla,
  [string]$Desktop = ""
)
$ErrorActionPreference = "Stop"

if(-not $Desktop -or -not (Test-Path $Desktop)){
  $Desktop = [Environment]::GetFolderPath("Desktop")
}
if(-not (Test-Path $Desktop)){ Write-Host "Desktop non trovato." -ForegroundColor Red; exit 1 }

$LogDir = Join-Path $Desktop "ABTG_ORDINE_LOG"
$stamp  = Get-Date -Format "yyyy-MM-dd_HHmm"

# --- ANNULLA: rilegge l'ultimo log e riporta tutto indietro ---------------
if($Annulla){
  $ultimo = Get-ChildItem $LogDir -Filter "riordino_*.csv" -ErrorAction SilentlyContinue |
            Sort-Object LastWriteTime -Descending | Select-Object -First 1
  if(-not $ultimo){ Write-Host "Nessun log di riordino da annullare." -ForegroundColor Yellow; exit 0 }
  Write-Host "ANNULLO usando $($ultimo.Name)" -ForegroundColor Cyan
  $n = 0
  foreach($r in (Import-Csv $ultimo.FullName)){
    if(Test-Path $r.Destinazione){
      $cartellaOrig = Split-Path -Parent $r.Origine
      if(-not (Test-Path $cartellaOrig)){ New-Item -ItemType Directory -Force -Path $cartellaOrig | Out-Null }
      Move-Item -LiteralPath $r.Destinazione -Destination $r.Origine -Force
      $n++
    }
  }
  Write-Host ("FATTO: {0} elementi rimessi al loro posto." -f $n) -ForegroundColor Green
  exit 0
}

# --- le famiglie: NOME CARTELLA -> lista di pattern sul nome -------------
$Famiglie = [ordered]@{
  "BREAKING_BAND" = @("bb_*","breaking*","funnel_bb*","cal_bb*")
  "GAP_FILL"      = @("gap_*")
  "PUNTE_LARRY"   = @("larry_*","notte_larry*","*_larry")
  "COST_TO_COST"  = @("cost_*")
  "EASY_TREND"    = @("ez_*","easytrend_*","valid_ABTG_EasyTrend*")
  "APERTURE_ORB"  = @("orb_*","orl_*","fade_*","target_*","londra_*","r35_*","gest_*","pertrade_r4*",
                      "dow_*","apert*","ini_apert*","conferma_*","src_dow*","dow_motore*","dow_distanze*")
  "ORO_METALLI"   = @("oro_*","xau*","maxmin*","notte_oro*")
  "ALTRI_ROUND"   = @("r19*","r22*","r33*","ibex_*","suprev_*","gbpjpy_*","fuorilista*","v21_*",
                      "backup_v21*","trades_port*","raccolta_*","verifica_viv*","weekend*","coda_*",
                      "orb_pt7e*","src_v2*","ini_studio*","ini_valid*","test_pagella*")
}

$EstensioniProgrammi = @(".lnk",".url",".exe",".msi",".bat",".cmd",".ps1xml")
$EstensioniDocumenti = @(".md",".txt",".csv",".docx",".doc",".pdf",".xlsx",".xls",".json",".ini",".set",".mq5",".ex5",".algo")

# --- cartelle tematiche di Claudio: NON si toccano ------------------------
$NonToccare = @("ABTG_RISULTATI","ABTG_ZIP","ABTG_DOCUMENTI","ABTG_VARIE","ABTG_ORDINE_LOG")

function Famiglia($nome){
  foreach($f in $Famiglie.Keys){
    foreach($pat in $Famiglie[$f]){ if($nome -like $pat){ return $f } }
  }
  return $null
}

$piano = New-Object System.Collections.ArrayList
$voci  = Get-ChildItem -LiteralPath $Desktop -Force | Where-Object { -not $_.Attributes.ToString().Contains("System") }

foreach($v in $voci){
  if($NonToccare -contains $v.Name){ continue }
  if($v.Name -eq "desktop.ini"){ continue }

  if($v.PSIsContainer){
    $fam = Famiglia $v.Name
    if($fam){
      [void]$piano.Add([pscustomobject]@{ Nome=$v.Name; Tipo="cartella round"; Dove="ABTG_RISULTATI\$fam"; Origine=$v.FullName })
    } elseif($Tutto){
      [void]$piano.Add([pscustomobject]@{ Nome=$v.Name; Tipo="cartella"; Dove="ABTG_VARIE"; Origine=$v.FullName })
    }
    continue
  }

  $ext = $v.Extension.ToLower()
  if($EstensioniProgrammi -contains $ext){ continue }        # collegamenti e programmi: MAI
  if($ext -eq ".zip" -or $ext -eq ".7z" -or $ext -eq ".rar"){
    [void]$piano.Add([pscustomobject]@{ Nome=$v.Name; Tipo="archivio"; Dove="ABTG_ZIP"; Origine=$v.FullName })
  } elseif($EstensioniDocumenti -contains $ext){
    [void]$piano.Add([pscustomobject]@{ Nome=$v.Name; Tipo="documento"; Dove="ABTG_DOCUMENTI"; Origine=$v.FullName })
  } elseif($Tutto){
    [void]$piano.Add([pscustomobject]@{ Nome=$v.Name; Tipo="file"; Dove="ABTG_VARIE"; Origine=$v.FullName })
  }
}

Write-Host ""
Write-Host "=== RIORDINO DESKTOP: $Desktop ===" -ForegroundColor Cyan
if($piano.Count -eq 0){ Write-Host "Niente da spostare: il Desktop e' gia' in ordine." -ForegroundColor Green; exit 0 }

$piano | Group-Object Dove | Sort-Object Name | ForEach-Object {
  Write-Host ""
  Write-Host ("  -> {0}   ({1} elementi)" -f $_.Name, $_.Count) -ForegroundColor White
  $_.Group | Select-Object -First 12 | ForEach-Object { Write-Host ("       {0}" -f $_.Nome) -ForegroundColor DarkGray }
  if($_.Count -gt 12){ Write-Host ("       ... e altri {0}" -f ($_.Count-12)) -ForegroundColor DarkGray }
}
Write-Host ""
Write-Host ("TOTALE: {0} elementi da sistemare." -f $piano.Count) -ForegroundColor Yellow
Write-Host "NON verranno toccati: collegamenti, programmi e le tue cartelle tematiche." -ForegroundColor Gray

if(-not $Esegui){
  Write-Host ""
  Write-Host "Questa era solo l'ANTEPRIMA: non ho spostato niente." -ForegroundColor Yellow
  Write-Host "Per farlo davvero rilancia la stessa riga aggiungendo  -Esegui" -ForegroundColor Yellow
  exit 0
}

New-Item -ItemType Directory -Force -Path $LogDir | Out-Null
$log = New-Object System.Collections.ArrayList
foreach($p in $piano){
  $destDir = Join-Path $Desktop $p.Dove
  New-Item -ItemType Directory -Force -Path $destDir | Out-Null
  $dest = Join-Path $destDir $p.Nome
  if(Test-Path -LiteralPath $dest){
    $dest = Join-Path $destDir ("{0}_{1}{2}" -f [IO.Path]::GetFileNameWithoutExtension($p.Nome), $stamp, [IO.Path]::GetExtension($p.Nome))
  }
  Move-Item -LiteralPath $p.Origine -Destination $dest -Force
  [void]$log.Add([pscustomobject]@{ Origine=$p.Origine; Destinazione=$dest })
}
$logFile = Join-Path $LogDir "riordino_$stamp.csv"
$log | Export-Csv -Path $logFile -NoTypeInformation -Encoding UTF8

Write-Host ""
Write-Host ("FATTO: {0} elementi sistemati." -f $log.Count) -ForegroundColor Green
Write-Host ("Log (serve per annullare): {0}" -f $logFile) -ForegroundColor Gray
Write-Host "Se qualcosa non ti piace:  riordina_desktop.ps1 -Annulla   rimette tutto com'era." -ForegroundColor Gray
