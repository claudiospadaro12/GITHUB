# =====================================================================
#  test_orb_toolkit.ps1  --  ORB America secondo il ToolKit ABTG Vol. V,
#  a TICK REALI, isolando UNA variabile alla volta.
#
#  PERCHE':
#  il nostro ABTG_ORB e' a registro come "marginale" (real tick: best PF
#  1,15, DD 16%, 625 trade, 50% pass positivi) e in forward e' stato il
#  miglior EA sul Nasdaq (+329 EUR, ma su 7 trade = niente).
#  Il ToolKit pero' prescrive una strategia DIVERSA da quella nel codice:
#    - range = primi 30 MINUTI DOPO l'apertura (15:30-16:00 IT = 14:30-15:00
#      server). Il nostro usa i 5 minuti PRIMA (15:25-15:30 IT).
#    - ingresso alla CHIUSURA di una candela oltre il livello, con corpo
#      ampio. Il nostro usa ordini STOP pendenti (= entra DURANTE).
#    - filtro EMA 9/21 come CONDIZIONE D'INGRESSO. Il nostro le usa solo
#      per trailing/uscita.
#    - stop impostato una volta e MAI spostato, TP fisso 1:2. Il nostro fa
#      parziale + break-even + trailing.
#
#  LA SCALA (ogni gradino cambia UNA cosa sola rispetto al precedente):
#    A  attuale         range 5 min pre-apertura + pendenti STOP  (baseline)
#    B  +range ToolKit  range 30 min post-apertura + pendenti STOP
#    C  +ingresso       range 30 min + CHIUSURA confermata
#    D  +corpo          C + filtro corpo minimo della candela
#    E  +medie          D + EMA 9/21 allineate e prezzo dalla parte giusta
#    F  +volumi         E + volume della rottura >= 1,5x media(20)
#  Dal gradino B in poi: stop fisso mai spostato, TP 1:2, rischio 2%,
#  news 2 ore prima (tutto come da ToolKit).
#
#  ⚠️ SUL PC DI BACKTEST (non il VPS). MetaTrader CHIUSO. E' lungo (ore).
#  ⚠️ Un backtest alla volta: non lanciarlo insieme all'ablazione.
#
#  Lancia con UNA riga:
#    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/lavoro/backtest_pipeline/test_orb_toolkit.ps1" | iex
# =====================================================================
param(
  [string[]]$Symbols=@("NASUSD","U30USD","SPXUSD"),   # SPXUSD: e' il mercato su cui il ToolKit e' tarato
  [int]$Model=4,
  [string]$EABranch="lavoro",
  [switch]$UseSpare,[string]$Terminal="",[string]$MetaEditor="",[string]$DataFolder="",[switch]$Force
)
$ErrorActionPreference="Stop"
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force
[Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12

# --- 14/08: "powershell -File" passa gli argomenti come STRINGHE letterali,
#     quindi "-Symbols A,B,C" arrivava come UN elemento solo. Normalizzo. ---
if($Symbols.Count -eq 1 -and $Symbols[0] -like "*,*"){
  $Symbols = $Symbols[0].Split(",") | ForEach-Object { $_.Trim() } | Where-Object { $_ -ne "" }
}
$EA="ABTG_ORB"
$RawBase="https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$EABranch"
$Work= if($PSScriptRoot){$PSScriptRoot}else{(Join-Path $env:USERPROFILE "Desktop")}
if(-not (Test-Path $Work)){ $Work=(Get-Location).Path }
Set-Location $Work

# --- imposta un input senza duplicare la chiave ---
function Set-Inp([string]$txt,[string]$k,[string]$v){
  $line="$k=$v||$v||0||$v||N"
  if($txt -match "(?m)^$k="){ return ($txt -replace "(?m)^$k=.*$",$line) }
  return ($txt+"`n"+$line)
}
function Set-InpGrid([string]$txt,[string]$k,[string]$v,[string]$a,[string]$s,[string]$b){
  $line="$k=$v||$a||$s||$b||Y"
  if($txt -match "(?m)^$k="){ return ($txt -replace "(?m)^$k=.*$",$line) }
  return ($txt+"`n"+$line)
}

# --- la scala: ogni gradino cambia UNA cosa ---
$scala=@(
 @{ id="A_attuale";  n="A  attuale (range 5 min PRE-apertura + pendenti STOP)"; range="pre";  close=0; body=0; ema=0; vol=0; gest="vecchia" },
 @{ id="B_range30";  n="B  range 30 min POST-apertura + pendenti STOP";         range="post"; close=0; body=0; ema=0; vol=0; gest="toolkit" },
 @{ id="C_chiusura"; n="C  + ingresso alla CHIUSURA confermata";                range="post"; close=1; body=0; ema=0; vol=0; gest="toolkit" },
 @{ id="D_corpo";    n="D  + filtro CORPO della candela di rottura";            range="post"; close=1; body=1; ema=0; vol=0; gest="toolkit" },
 @{ id="E_medie";    n="E  + filtro EMA 9/21 (prezzo dalla parte giusta)";      range="post"; close=1; body=1; ema=1; vol=0; gest="toolkit" },
 @{ id="F_volumi";   n="F  + VOLUMI della rottura >= 1,5x media (ToolKit pieno)"; range="post"; close=1; body=1; ema=1; vol=1; gest="toolkit" }
)

Write-Host "=== ORB ToolKit - test a tick reali su $($Symbols -join ', ') ===" -ForegroundColor Cyan
New-Item -ItemType Directory -Force -Path (Join-Path $Work "src_v2"),(Join-Path $Work "ini_orb") | Out-Null

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
if((Get-Process -Name "terminal64" -ErrorAction SilentlyContinue) -and -not $Force){Write-Host "!!! Chiudi MetaTrader prima." -ForegroundColor Red; exit 1}

foreach($s in $scala){
  # lo script scaricato puo' sparire dal Desktop tra un run e l'altro (antivirus/sync):
  # riscarico e ricompilo l'EA a ogni gradino
  try{ Invoke-WebRequest -Uri "$RawBase/mql5/Experts/$EA.mq5" -OutFile (Join-Path $Work "src_v2\$EA.mq5") -UseBasicParsing }
  catch{ Write-Host "   ERRORE download $EA : $($_.Exception.Message)" -ForegroundColor Red; break }
  Copy-Item (Join-Path $Work "src_v2\$EA.mq5") -Destination $MqlExperts -Force
  & $MetaEditor "/compile:$(Join-Path $MqlExperts "$EA.mq5")" "/log" | Out-Null
  if(-not (Test-Path (Join-Path $MqlExperts "$EA.ex5"))){Write-Host "ERRORE compilazione $EA" -ForegroundColor Red; break}

  # ---- costruisco gli input del gradino ----
  $I=""
  if($s.range -eq "pre"){   # come oggi: 15:25-15:30 IT = 14:25-14:30 server
    $I=Set-Inp $I "InpRangeStartHour" "14"; $I=Set-Inp $I "InpRangeStartMin" "25"
    $I=Set-Inp $I "InpRangeEndHour"   "14"; $I=Set-Inp $I "InpRangeEndMin"   "30"
  } else {                  # ToolKit: 15:30-16:00 IT = 14:30-15:00 server
    $I=Set-Inp $I "InpRangeStartHour" "14"; $I=Set-Inp $I "InpRangeStartMin" "30"
    $I=Set-Inp $I "InpRangeEndHour"   "15"; $I=Set-Inp $I "InpRangeEndMin"   "0"
  }
  $I=Set-Inp $I "InpUseCloseConfirm" "$($s.close)"
  $I=Set-Inp $I "InpUseEmaFilter"    "$($s.ema)"
  $I=Set-Inp $I "InpUseVolumeFilter" "$($s.vol)"
  $I=Set-Inp $I "InpVolMult"         "1.5"
  $I=Set-Inp $I "InpEmaFast"         "9"
  $I=Set-Inp $I "InpEmaSlow"         "21"
  if($s.body -eq 1){ $I=Set-InpGrid $I "InpMinBodyPct" "50" "30" "20" "70" } else { $I=Set-Inp $I "InpMinBodyPct" "0" }

  if($s.gest -eq "toolkit"){
    # ToolKit: stop UNA volta e mai piu' toccato, TP fisso 1:2, rischio 2%, news 2 ore
    $I=Set-Inp $I "InpSLMode"        "0"     # bordo opposto del range
    $I=Set-Inp $I "InpTP_R"          "2.0"
    $I=Set-Inp $I "InpTP1Pct"        "0"     # nessun parziale
    $I=Set-Inp $I "InpBreakeven"     "0"     # nessun break-even
    $I=Set-Inp $I "InpUseTrailEMA"   "0"     # nessun trailing
    $I=Set-Inp $I "InpExitOnEmaClose" "0"
    $I=Set-Inp $I "InpRiskPercent"   "2.0"
    $I=Set-Inp $I "InpUseNewsFilter" "1"
    $I=Set-Inp $I "InpNewsBeforeMin" "120"
  }
  # con l'ingresso a mercato la distanza del pendente non serve: la inchiodo
  if($s.close -eq 1){ $I=Set-Inp $I "InpEntryPoints" "10" }
  else              { $I=Set-InpGrid $I "InpEntryPoints" "10" "5" "5" "20" }

  $tag="ORB_$($s.id)_realtick"
  $Results=Join-Path $Work "risultati_$tag"; New-Item -ItemType Directory -Force -Path $Results | Out-Null
  Write-Host "`n===== $($s.n) =====" -ForegroundColor Yellow

  foreach($sym in $Symbols){
    $done=Join-Path $Results "orb_${tag}_$sym.csv"
    if(Test-Path $done){ Write-Host "   $sym : gia' fatto, salto" -ForegroundColor DarkGray; continue }
    $ini=Join-Path $Work "ini_orb\orb_${tag}_$sym.ini"
@"
[Tester]
Expert=$EA.ex5
Symbol=$sym
Period=M5
Model=$Model
Optimization=2
OptimizationCriterion=6
FromDate=2024.01.01
ToDate=2026.06.30
ForwardMode=0
Deposit=100000
Currency=EUR
Leverage=100
ExecutionMode=0
ReplaceReport=1
ShutdownTerminal=1
Report=OptReport_${tag}_$sym

[TesterInputs]
$I
"@ | Set-Content -Path $ini -Encoding ASCII
    $csv=Join-Path $MqlFiles "OptResults_${EA}_$sym.csv"; if(Test-Path $csv){Remove-Item $csv -Force}
    Write-Host "   $sym (M5 Model $Model)..." -ForegroundColor Cyan
    (Start-Process -FilePath $Terminal -ArgumentList "/config:`"$ini`"" -PassThru).WaitForExit()
    for($w=0;$w -lt 20;$w++){ if(-not (Get-Process -Name terminal64 -ErrorAction SilentlyContinue)){break}; Start-Sleep -Seconds 3 }
    Get-Process -Name terminal64 -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
    Start-Sleep -Seconds 2
    if(Test-Path $csv){
      try{
        if(-not (Test-Path $Results)){ New-Item -ItemType Directory -Force -Path $Results | Out-Null }
        Copy-Item $csv -Destination $done -Force; Remove-Item $csv -Force
        Write-Host "        OK -> orb_${tag}_$sym.csv" -ForegroundColor Green
      }catch{
        Write-Host "        !! salvataggio fallito: $($_.Exception.Message)" -ForegroundColor Red
        Write-Host "        il CSV resta qui: $csv" -ForegroundColor Yellow
      }
    } else { Write-Host "        (no CSV: $sym senza storico?)" -ForegroundColor Yellow }
  }
}

Write-Host "`n===== ORB TOOLKIT FINITO =====" -ForegroundColor Green
Write-Host "Sul Desktop: 6 cartelle risultati_ORB_A..F_realtick. Zippale TUTTE e caricamele." -ForegroundColor White
Write-Host "Da leggere in ordine: A->B dice se conta il RANGE, B->C se conta l'INGRESSO," -ForegroundColor White
Write-Host "C->D->E->F quanto pesa ogni filtro. Guarda SEMPRE prima il numero di trade." -ForegroundColor White
