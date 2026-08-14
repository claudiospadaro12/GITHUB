# =====================================================================
#  notte_larry.ps1 -- LA NOTTE DI LARRY (pipeline AUTONOMA, 13/08/2026)
#  Si lancia UNA volta sul PC di backtest (MT5 CHIUSO) e fa da sola:
#   FASE 1: scan OHLC dei 48 simboli (griglia Pattern x Uscita x Lati)
#   FASE 2: auto-selezione coi CRITERI CONGELATI qui sotto
#   FASE 3: walk-forward a TICK REALI sui promossi (IS/OOS standard)
#  Ogni CSV finito viene PUBBLICATO sul repo (token .gh_report_token.txt
#  come coda_weekend): Claude legge, giudica e scrive il referto senza
#  bisogno di zip.
#
#  CRITERI CONGELATI (scritti PRIMA di qualunque numero, tesi
#  SMASH_DAY_TESI.md):
#   - FASE 2 (selezione dallo scan): un simbolo e' PROMOSSO al tick se
#     la sua MIGLIOR cella OHLC ha Profit > 0, PF >= 1.10, Trades >= 25.
#     Si prendono al massimo i TOP 8 per profitto. Pattern e Uscita
#     della cella migliore vengono PINNATI per la fase 3.
#   - FASE 3 (giudizio, lo fa Claude nel referto): cella scelta
#     sull'IS fra le 4 combinazioni di lati; PROMOSSO se quella cella
#     in OOS fa: profitto > 0, PF >= 1.10, DD < 10%, n >= 8.
#   - Attese gia' dichiarate in tesi: Oops raro sui CFD quasi-24h e
#     ROSSO atteso sul DAX (test Unger); asimmetria dei lati attesa.
# =====================================================================
param(
  [switch]$UseSpare,[string]$Terminal="",[string]$MetaEditor="",[string]$DataFolder="",[switch]$Force
)
$ErrorActionPreference="Stop"
[Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12

$EA="ABTG_PunteLarry"
$EASHA="cb7dc20ab738d4d6791c74ff051ae8130b538fbd"   # commit della v1.00 (pinnato, regola anti-cache)
$Branch="lavoro"
$ApiBase="https://api.github.com/repos/claudiospadaro12/GITHUB"
$RepoDir="backtest_pipeline/risultati_prove/ABTG_PunteLarry/notte"

$Symbols=@(
  "D30EUR","NASUSD","U30USD","SPXUSD","100GBP","F40EUR","E50EUR","E35EUR","200AUD","225JPY",
  "XAUUSD","XAGUSD","XPTUSD","XPDUSD","UKOIL","USOIL","XNGUSD",
  "EURUSD","GBPUSD","USDJPY","USDCHF","USDCAD","AUDUSD","NZDUSD",
  "EURGBP","EURJPY","EURCHF","EURAUD","EURCAD","EURNZD","GBPJPY","GBPCHF","GBPAUD","GBPCAD","GBPNZD",
  "AUDJPY","CADJPY","CHFJPY","NZDJPY","CADCHF","NZDCAD","NZDCHF",
  "EURNOK","USDNOK","EURPLN","USDPLN","EURSEK","USDSEK"
)

# --- token per pubblicare (come coda_weekend) ---
$Token=$null
foreach($p in @((Join-Path $env:USERPROFILE ".gh_report_token.txt"),"C:\ABTG\.gh_report_token.txt","C:\Users\Administrator\.gh_report_token.txt")){
  if(Test-Path $p){ $Token=(Get-Content $p -Raw).Trim(); break }
}
if($Token){ Write-Host "token trovato: pubblico i risultati man mano" -ForegroundColor Green }
else { Write-Host "!!! NESSUN TOKEN (.gh_report_token.txt): i risultati resteranno solo su questo PC" -ForegroundColor Yellow }

function Publish($localPath,$repoPath){
  if(-not $Token){ return }
  try{
    $hdr=@{ Authorization="token $Token"; "User-Agent"="notte-larry" }
    $b64=[Convert]::ToBase64String([IO.File]::ReadAllBytes($localPath))
    $sha=$null
    try{ $cur=Invoke-RestMethod -Method Get -Uri "$ApiBase/contents/$repoPath`?ref=$Branch" -Headers $hdr; $sha=$cur.sha }catch{}
    $body=@{ message="notte_larry: $([IO.Path]::GetFileName($repoPath)) ($(Get-Date -Format 'yyyy-MM-dd HH:mm'))"; content=$b64; branch=$Branch }
    if($sha){ $body.sha=$sha }
    Invoke-RestMethod -Method Put -Uri "$ApiBase/contents/$repoPath" -Headers $hdr -Body ($body|ConvertTo-Json) -ContentType "application/json" | Out-Null
    Write-Host "      pubblicato: $repoPath" -ForegroundColor DarkGreen
  }catch{ Write-Host "      pubblicazione fallita per $repoPath (proseguo)" -ForegroundColor Yellow }
}

$Log=New-Object System.Collections.ArrayList
function Nota($s){ [void]$Log.Add(("[{0}] {1}" -f (Get-Date -Format "HH:mm:ss"),$s)); Write-Host $s -ForegroundColor Cyan }

# --- terminale e cartella dati (come valida_realtick) ---
$Work= if($PSScriptRoot){$PSScriptRoot}else{(Get-Location).Path}; Set-Location $Work
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
if(-not $DataFolder -or -not (Test-Path $DataFolder)){Write-Host "Cartella dati non trovata." -ForegroundColor Red; exit 1}
$MqlExperts=Join-Path $DataFolder "MQL5\Experts"; $MqlFiles=Join-Path $DataFolder "MQL5\Files"
$Results=Join-Path $Work "risultati_notte_larry"; New-Item -ItemType Directory -Force -Path $MqlExperts,$Results|Out-Null
if((Get-Process -Name "terminal64" -ErrorAction SilentlyContinue) -and -not $Force){Write-Host "!!! Chiudi MetaTrader prima (0 CSV altrimenti)." -ForegroundColor Red; exit 1}

# --- EA: scarica PINNATO e compila ---
$src=Join-Path $MqlExperts "$EA.mq5"
irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$EASHA/mql5/Experts/$EA.mq5" -OutFile $src
& $MetaEditor "/compile:$src" "/log" | Out-Null
if(-not (Test-Path (Join-Path $MqlExperts "$EA.ex5"))){
  Write-Host "ERRORE COMPILAZIONE $EA : apri MetaEditor e guarda gli errori. STOP." -ForegroundColor Red
  $logf=Get-ChildItem (Split-Path $src) -Filter "*.log" -ErrorAction SilentlyContinue | Sort LastWriteTime -Desc | Select -First 1
  if($logf){ Get-Content $logf.FullName -Tail 30 }
  exit 1
}
Nota "compilato $EA.ex5"

function RunTester($ini){ (Start-Process -FilePath $Terminal -ArgumentList "/config:`"$ini`"" -PassThru).WaitForExit() }

# =====================================================================
#  FASE 1 -- SCAN OHLC (Model 1), 24 celle/simbolo
# =====================================================================
$ScanInputs=@"
InpTF=16385||16385||0||16385||N
InpRiskPercent=1.0||1.0||0||1.0||N
InpSizeMinATR=0.0||0.0||0||0.0||N
InpSizeMaxATR=0.0||0.0||0||0.0||N
InpSLMode=0||0||0||0||N
InpSLBufferATR=0.1||0.1||0||0.1||N
InpAtrSlMult=1.5||1.5||0||1.5||N
InpAtrPeriodD1=14||14||0||14||N
InpMaxDaysHold=5||5||0||5||N
InpMaxSpreadPts=0||0||0||0||N
InpEntryWindowBars=3||3||0||3||N
InpTP_R=1.5||1.5||0||1.5||N
InpPatternMode=0||0||1||2||Y
InpExitMode=0||0||1||1||Y
InpAllowLong=1||0||1||1||Y
InpAllowShort=1||0||1||1||Y
"@
Nota ("FASE 1: scan OHLC su {0} simboli (24 celle l'uno)" -f $Symbols.Count)
$n=0
foreach($sym in $Symbols){
  $n++
  $done=Join-Path $Results "scan_larry_$sym.csv"
  if(Test-Path $done){ Write-Host ("   [{0}/{1}] {2}: gia' fatto, salto" -f $n,$Symbols.Count,$sym) -ForegroundColor DarkGray; continue }
  $ini=Join-Path $Results "ini_scan_$sym.ini"
  @"
[Experts]
AllowLiveTrading=false
AllowDllImport=false

[Tester]
Expert=$EA.ex5
Symbol=$sym
Period=H1
Model=1
Optimization=2
OptimizationCriterion=6
FromDate=2024.01.01
ToDate=2026.06.30
ForwardMode=0
Deposit=10000
Currency=EUR
Leverage=100
ExecutionMode=0
ReplaceReport=1
ShutdownTerminal=1
Report=OptReport_larry_scan_$sym

[TesterInputs]
$ScanInputs
"@ | Set-Content -Path $ini -Encoding ASCII
  $csv=Join-Path $MqlFiles "OptResults_${EA}_$sym.csv"; if(Test-Path $csv){Remove-Item $csv -Force}
  Write-Host ("   [{0}/{1}] {2} (OHLC)..." -f $n,$Symbols.Count,$sym) -ForegroundColor Cyan
  RunTester $ini
  if(Test-Path $csv){ Copy-Item $csv $done -Force; Remove-Item $csv -Force
    Publish $done "$RepoDir/scan_larry_$sym.csv" }
  else{ Write-Host "        (no CSV per $sym)" -ForegroundColor Yellow }
}

# =====================================================================
#  FASE 2 -- AUTO-SELEZIONE coi criteri congelati
# =====================================================================
Nota "FASE 2: selezione coi criteri congelati (Profit>0, PF>=1.10, n>=25; top 8)"
$cand=@()
foreach($sym in $Symbols){
  $f=Join-Path $Results "scan_larry_$sym.csv"
  if(-not (Test-Path $f)){ continue }
  $rows=Import-Csv $f
  $best=$null
  foreach($r in $rows){
    $p=[double]$r.Profit
    if(-not $best -or $p -gt [double]$best.Profit){ $best=$r }
  }
  if(-not $best){ continue }
  $okP=([double]$best.Profit -gt 0)
  $okPF=([double]$best.'Profit Factor' -ge 1.10)
  $okN=([int]$best.Trades -ge 25)
  if($okP -and $okPF -and $okN){
    $cand+= New-Object psobject -Property @{ Sym=$sym; Profit=[double]$best.Profit; PF=[double]$best.'Profit Factor';
      N=[int]$best.Trades; Pattern=$best.InpPatternMode; Exit=$best.InpExitMode; AL=$best.InpAllowLong; ASh=$best.InpAllowShort }
  }
}
$cand=$cand | Sort-Object Profit -Descending | Select-Object -First 8
if($cand.Count -eq 0){
  Nota "NESSUN SIMBOLO promosso dallo scan: la notte finisce qui (verdetto onesto)."
}else{
  Nota ("promossi al tick: " + (($cand | ForEach-Object { "$($_.Sym)(P$($_.Pattern)/E$($_.Exit))" }) -join ", "))
}
$stato=@("# STATO NOTTE LARRY ($(Get-Date -Format 'yyyy-MM-dd HH:mm'))","",
  "Criteri congelati: best cell Profit>0, PF>=1.10, n>=25; top 8; pattern+exit pinnati dallo scan.","")
foreach($c in $cand){ $stato += ("PROMOSSO {0}: profit {1:F2}, PF {2:F2}, n {3}, pattern {4}, exit {5}, lati {6}/{7}" -f $c.Sym,$c.Profit,$c.PF,$c.N,$c.Pattern,$c.Exit,$c.AL,$c.ASh) }
$stato += ""; $stato += $Log
$stFile=Join-Path $Results "STATO_NOTTE_LARRY.txt"
$stato -join "`r`n" | Set-Content -Path $stFile -Encoding ASCII
Publish $stFile "$RepoDir/STATO_NOTTE_LARRY.txt"

# =====================================================================
#  FASE 3 -- WALK-FORWARD a tick reali sui promossi
#  (pattern+exit pinnati dalla cella migliore; sweep SOLO i lati)
# =====================================================================
$WF=@(
  @{ Tag="IS";  Da="2024.09.26"; A="2025.06.09" },
  @{ Tag="OOS"; Da="2025.06.10"; A="2026.06.30" }
)
foreach($c in $cand){
  $sym=$c.Sym
  $WfInputs=@"
InpTF=16385||16385||0||16385||N
InpRiskPercent=1.0||1.0||0||1.0||N
InpSizeMinATR=0.0||0.0||0||0.0||N
InpSizeMaxATR=0.0||0.0||0||0.0||N
InpSLMode=0||0||0||0||N
InpSLBufferATR=0.1||0.1||0||0.1||N
InpAtrSlMult=1.5||1.5||0||1.5||N
InpAtrPeriodD1=14||14||0||14||N
InpMaxDaysHold=5||5||0||5||N
InpMaxSpreadPts=300||300||0||300||N
InpEntryWindowBars=3||3||0||3||N
InpTP_R=1.5||1.5||0||1.5||N
InpPatternMode=$($c.Pattern)||$($c.Pattern)||0||$($c.Pattern)||N
InpExitMode=$($c.Exit)||$($c.Exit)||0||$($c.Exit)||N
InpAllowLong=1||0||1||1||Y
InpAllowShort=1||0||1||1||Y
"@
  foreach($w in $WF){
    $tag="wf_larry_{0}_{1}" -f $sym,$w.Tag
    $done=Join-Path $Results "$tag.csv"
    if(Test-Path $done){ Write-Host "   $tag gia' fatto, salto" -ForegroundColor DarkGray; continue }
    $ini=Join-Path $Results "ini_$tag.ini"
    @"
[Experts]
AllowLiveTrading=false
AllowDllImport=false

[Tester]
Expert=$EA.ex5
Symbol=$sym
Period=H1
Model=4
Optimization=2
OptimizationCriterion=6
FromDate=$($w.Da)
ToDate=$($w.A)
ForwardMode=0
Deposit=10000
Currency=EUR
Leverage=100
ExecutionMode=0
ReplaceReport=1
ShutdownTerminal=1
Report=OptReport_$tag

[TesterInputs]
$WfInputs
"@ | Set-Content -Path $ini -Encoding ASCII
    $csv=Join-Path $MqlFiles "OptResults_${EA}_$sym.csv"; if(Test-Path $csv){Remove-Item $csv -Force}
    Write-Host ("   {0} (TICK {1} -> {2})..." -f $tag,$w.Da,$w.A) -ForegroundColor Cyan
    RunTester $ini
    if(Test-Path $csv){ Copy-Item $csv $done -Force; Remove-Item $csv -Force
      Publish $done "$RepoDir/$tag.csv" }
    else{ Write-Host "        (no CSV per $tag)" -ForegroundColor Yellow }
  }
}

$fine="FINITO $(Get-Date -Format 'yyyy-MM-dd HH:mm') - promossi al tick: $($cand.Count)"
Add-Content -Path $stFile -Value $fine -Encoding ASCII
Publish $stFile "$RepoDir/STATO_NOTTE_LARRY.txt"
Write-Host "=== NOTTE DI LARRY COMPLETATA === risultati in $Results e sul repo ($RepoDir)" -ForegroundColor Green
