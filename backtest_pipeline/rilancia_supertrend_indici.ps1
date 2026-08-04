# =====================================================================
#  rilancia_supertrend_indici.ps1  --  porta il SupertrendReversal
#  (edge dimostrato su oro, PF 3.17) su DAX e Nasdaq, H1 e H4.
# ---------------------------------------------------------------------
#  4 PROVE DISTINTE (ognuna col suo CSV separato):
#    - D30EUR H1, D30EUR H4, NASUSD H1, NASUSD H4
#  Ottimizza StMult / StAtrPeriod / TP_RR, rischio 1%.
#  Screen in OHLC 1-min (veloce e affidabile per swing H1/H4).
#  Il vincitore lo validiamo poi in REAL TICK.
#
#  NB: tutti usano lo stesso EA -> lo stesso OptResults. Per tenerli
#  DISTINTI, dopo ogni prova copio+rinomino il CSV e cancello l'originale.
#  Risultati in .\risultati_supertrend_indici\  (valid_SupRev_<sym>_<tf>.csv)
# =====================================================================
param([switch]$UseSpare,[string]$Terminal="",[string]$MetaEditor="",[string]$DataFolder="",[switch]$Force)
$ErrorActionPreference="Stop"
[Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12
$Branch="lavoro"   # era un branch fermo dal 31/07: scaricava sorgenti VECCHI senza dare errore
$RawBase="https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$Branch"
$EA="ABTG_SupertrendReversal"
$Targets=@(
  @{ini="valid_SupRev_D30EUR_M5";sym="D30EUR";tf="M5"},
  @{ini="valid_SupRev_D30EUR_H1";sym="D30EUR";tf="H1"},
  @{ini="valid_SupRev_D30EUR_H4";sym="D30EUR";tf="H4"},
  @{ini="valid_SupRev_NASUSD_M5";sym="NASUSD";tf="M5"},
  @{ini="valid_SupRev_NASUSD_H1";sym="NASUSD";tf="H1"},
  @{ini="valid_SupRev_NASUSD_H4";sym="NASUSD";tf="H4"}
)
$Work= if($PSScriptRoot){$PSScriptRoot}else{(Get-Location).Path}; Set-Location $Work
Write-Host "=== SUPERTREND REVERSAL su DAX/Nasdaq (H1+H4, 4 prove distinte) ===" -ForegroundColor Cyan

# 1) scarico EA + i 4 .ini
New-Item -ItemType Directory -Force -Path (Join-Path $Work "src_v2"),(Join-Path $Work "ini") | Out-Null
$dl=@(@{u="$RawBase/mql5/Experts/$EA.mq5";o="src_v2\$EA.mq5"})
foreach($t in $Targets){$dl+=@{u="$RawBase/backtest_pipeline/ini/$($t.ini).ini";o="ini\$($t.ini).ini"}}
foreach($d in $dl){ try{Invoke-WebRequest -Uri $d.u -OutFile (Join-Path $Work $d.o) -UseBasicParsing; Write-Host "   OK $($d.o)" -ForegroundColor Green} catch{Write-Host "   ERRORE $($d.u)" -ForegroundColor Red; exit 1} }

# 2) terminale + cartella dati
if(-not $Terminal){
  $allTerm=Get-ChildItem "C:\Program Files","C:\Program Files (x86)" -Recurse -Filter "terminal64.exe" -ErrorAction SilentlyContinue
  if($UseSpare){$c=$allTerm|?{$_.DirectoryName -like "*BCM Markets*" -and $_.DirectoryName -like "*-V3*"}|Select -First 1}
  else{$c=$allTerm|?{$_.DirectoryName -like "*BCM Markets MT5 Terminal*" -and $_.DirectoryName -notlike "*-V3*"}|Select -First 1}
  if(-not $c){$c=$allTerm|?{$_.DirectoryName -like "*BCM Markets*"}|Select -First 1}
  if($c){$Terminal=$c.FullName; $MetaEditor=Join-Path $c.DirectoryName "metaeditor64.exe"}
}
if($Terminal -and -not $DataFolder){
  $instDir=Split-Path -Parent $Terminal; $termRoot=Join-Path $env:APPDATA "MetaQuotes\Terminal"
  if(Test-Path $termRoot){$DataFolder=Get-ChildItem $termRoot -Directory -ErrorAction SilentlyContinue|?{$o=Join-Path $_.FullName "origin.txt";(Test-Path $o)-and((Get-Content $o -Raw).Trim() -ieq $instDir)}|Select -First 1 -ExpandProperty FullName}
}
if(-not $DataFolder -or -not(Test-Path $DataFolder)){Write-Host "Cartella dati non trovata." -ForegroundColor Red; exit 1}
$MqlExperts=Join-Path $DataFolder "MQL5\Experts"; $MqlFiles=Join-Path $DataFolder "MQL5\Files"
$Results=Join-Path $Work "risultati_supertrend_indici"; New-Item -ItemType Directory -Force -Path $MqlExperts,$Results|Out-Null

# 3) MT5 chiuso
if((Get-Process -Name "terminal64" -ErrorAction SilentlyContinue) -and -not $Force){Write-Host "!!! Chiudi MetaTrader prima (0 CSV altrimenti)." -ForegroundColor Red; exit 1}

# 4) compilo l'EA
Copy-Item (Join-Path $Work "src_v2\$EA.mq5") -Destination $MqlExperts -Force
& $MetaEditor "/compile:$(Join-Path $MqlExperts "$EA.mq5")" "/log" | Out-Null
if(-not (Test-Path (Join-Path $MqlExperts "$EA.ex5"))){Write-Host "ERRORE compilazione $EA" -ForegroundColor Red; exit 1}
Write-Host "   compilato $EA.ex5" -ForegroundColor Green

# 5) le 4 prove, una alla volta, CIASCUNA rinominata (distinte!)
$src=Join-Path $MqlFiles "OptResults_${EA}_" ; $n=0
foreach($t in $Targets){
  $n++
  $done=Join-Path $Results "valid_SupRev_$($t.sym)_$($t.tf).csv"
  if(Test-Path $done){Write-Host ("   [{0}/{1}] {2} {3} : gia' fatto, salto (ripresa)" -f $n,$Targets.Count,$t.sym,$t.tf) -ForegroundColor DarkGray; continue}
  $csvSrc=Join-Path $MqlFiles "OptResults_${EA}_$($t.sym).csv"
  if(Test-Path $csvSrc){Remove-Item $csvSrc -Force}   # pulizia prima
  Write-Host ("   [{0}/{1}] {2} {3} ..." -f $n,$Targets.Count,$t.sym,$t.tf) -ForegroundColor Cyan
  (Start-Process -FilePath $Terminal -ArgumentList "/config:`"$(Join-Path $Work "ini\$($t.ini).ini")`"" -PassThru).WaitForExit()
  if(Test-Path $csvSrc){
    Copy-Item $csvSrc -Destination (Join-Path $Results "valid_SupRev_$($t.sym)_$($t.tf).csv") -Force
    Remove-Item $csvSrc -Force   # cancello cosi' la prova dopo non si mescola
    Write-Host ("        OK -> valid_SupRev_{0}_{1}.csv" -f $t.sym,$t.tf) -ForegroundColor Green
  } else { Write-Host "        (manca il CSV)" -ForegroundColor Yellow }
}
Write-Host "`n=== FINITO === risultati in $Results" -ForegroundColor Cyan
Write-Host "Mandami i CSV mancanti: ti dico se il SupertrendReversal ha edge su DAX/Nasdaq e su quale TF." -ForegroundColor White
