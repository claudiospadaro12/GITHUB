# =====================================================================
#  maxmin_oro.ps1  --  MAX/MIN della notte sull'ORO, fatto per bene
#
#  Claudio (05/08): "se sono due livelli importanti si potrebbe tenere
#  gia' la strategia max e min della notte con l'oro... pero' prima
#  facciamo le verifiche del caso: backtest in OHLC e poi tick reali,
#  e provare con piu' TF."
#
#  Ha ragione due volte, ed e' esattamente la sequenza giusta:
#
#   FASE 1 - OHLC M1 (Model 1): VELOCE. Serve a scremare la griglia, non
#            a decidere. Su un breakout l'OHLC e' OTTIMISTA (riempie gli
#            stop al prezzo esatto, non vede la sequenza dentro la barra):
#            i numeri usciranno GONFI. Vanno letti in RELATIVO, per
#            confrontare le combinazioni fra loro, mai in assoluto.
#   FASE 2 - TICK REALI (Model 4): LENTO. Solo sulle combinazioni
#            sopravvissute. Questo e' il numero vero.
#
#  Cio' che si spazzola:
#     InpBufferPoints  200/500/1000/2000   quanto oltre l'estremo notte
#     InpMgmtTF        M5/M15/M30/H1       il "piu' TF" chiesto da Claudio
#     InpSLMode        0/1/2               box opposto / ATR / punti fissi
#
#  ⚠️ ATTENZIONE, e va detto prima di lanciare:
#  il ABTG_MaxMinNotte e' un EA di ROTTURA. Compra SOPRA il massimo
#  della notte e vende SOTTO il minimo. Claudio pero' ha descritto
#  un'altra cosa: "si entra sul minimo e si chiude sul massimo", che e'
#  il FADE, la strategia OPPOSTA sugli stessi due livelli.
#  Non esistono entrambe: o il box tiene (e vince il fade) o si rompe
#  (e vince il breakout). A dirlo e' lo studio ABTG_Notte_Study, punto 3
#  ("cosa fa la sessione dopo"): lancia PRIMA quello (studio_notte.ps1),
#  costa due minuti. Questo script misura il ramo BREAKOUT.
#
#  PC di backtest, MetaTrader CHIUSO.
#  Uso:
#    powershell -ExecutionPolicy Bypass -File .\maxmin_oro.ps1
#    .\maxmin_oro.ps1 -Fase 2 -SLMode 1        (dopo avermi mandato la fase 1)
# =====================================================================
param(
  [ValidateSet(1,2)][int]$Fase=1,
  [int]$SLMode=1,            # (fase 2) modalita' di stop vincente in fase 1
  [string]$Sym="XAUUSD",
  [switch]$UseSpare,[string]$Terminal="",[string]$MetaEditor="",[string]$DataFolder="",[switch]$Force
)
$ErrorActionPreference="Stop"
[Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12
$EABranch="lavoro"
$RawBase="https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$EABranch"
$EA="ABTG_MaxMinNotte"

$Work= if($PSScriptRoot){$PSScriptRoot}else{(Get-Location).Path}; Set-Location $Work

# I TF di gestione NON sono numeri consecutivi (M5=5, M15=15, M30=30, H1=16385,
# H4=16388): uno sweep start||step||stop passerebbe da valori inesistenti
# (25, 35...). Quindi si gira un lancio per TF, e dentro si spazzola il resto.
#
# FASE 2: la griglia della fase 1 era messa male e i dati lo hanno detto.
# Due gradienti MONOTONI che puntano entrambi al BORDO della griglia:
#   buffer  200 -> 800 -> 1400 -> 2000 : PF 1,388 · 1,320 · 1,131 · 0,977
#   TF gest. M5 -> M15 -> M30  -> H1   : PF 1,121 · 1,147 · 1,175 · 1,327
# Il migliore sta all'estremo in entrambi i casi, cioe' l'ottimo e' FUORI.
# Qui si guarda dall'altra parte: buffer piu' STRETTI (50/100/200/400) e
# TF piu' ALTI (M30/H1/H4).
if($Fase -eq 1){
  $TFs=@(
    @{Val=5;     Nome="M5"},
    @{Val=15;    Nome="M15"},
    @{Val=30;    Nome="M30"},
    @{Val=16385; Nome="H1"}
  )
  $Model=1; $Etichetta="FASE 1 - OHLC M1 (veloce, numeri gonfi: si legge in relativo)"; $PerTF=12
}else{
  $TFs=@(
    @{Val=30;    Nome="M30"},
    @{Val=16385; Nome="H1"},
    @{Val=16388; Nome="H4"}
  )
  $Model=4; $Etichetta="FASE 2 - TICK REALI (lento, numeri veri)"; $PerTF=4
}
$NPass=$PerTF*$TFs.Count
Write-Host "=== MAX/MIN NOTTE sull'ORO ($Sym) ===" -ForegroundColor Cyan
Write-Host "    $Etichetta -> $NPass pass" -ForegroundColor Gray
Write-Host "    Sweep: buffer x TF di gestione$(if($Fase -eq 1){' x modalita di stop'}else{" (SLMode fissato a $SLMode)"})" -ForegroundColor Gray

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
$Results=Join-Path $Work "risultati_maxmin_oro"
New-Item -ItemType Directory -Force -Path $MqlExperts,$Results,(Join-Path $Work "src_mmo")|Out-Null
if((Get-Process -Name "terminal64" -ErrorAction SilentlyContinue) -and -not $Force){
  Write-Host "!!! Chiudi MetaTrader prima di lanciare (altrimenti 0 CSV)." -ForegroundColor Red; exit 1 }

$src=Join-Path $Work "src_mmo\$EA.mq5"
try{ Invoke-WebRequest -Uri "$RawBase/mql5/Experts/$EA.mq5" -OutFile $src -UseBasicParsing
     Write-Host "    scaricato $EA.mq5 (da $EABranch)" -ForegroundColor Green }
catch{ Write-Host "    ERRORE download $EA" -ForegroundColor Red; exit 1 }
Copy-Item $src -Destination $MqlExperts -Force
& $MetaEditor "/compile:$(Join-Path $MqlExperts "$EA.mq5")" "/log" | Out-Null
if(-not (Test-Path (Join-Path $MqlExperts "$EA.ex5"))){ Write-Host "    ERRORE compilazione" -ForegroundColor Red; exit 1 }
Write-Host "    compilato" -ForegroundColor Green

# --- riga dello stop: in fase 1 e' in sweep, in fase 2 e' fissata ---
if($Fase -eq 1){ $rigaSL="InpSLMode=0||0||1||2||Y" }
else           { $rigaSL="InpSLMode=$SLMode||$SLMode||0||$SLMode||N" }

# --- buffer: in fase 2 si guarda SOTTO i 200 punti, dove la fase 1 puntava ---
if($Fase -eq 1){ $rigaBuffer="InpBufferPoints=200||200||600||2000||Y" }   # 200/800/1400/2000
else           { $rigaBuffer="InpBufferPoints=50||50||100||350||Y" }      # 50/150/250/350

foreach($tf in $TFs){
  Write-Host ""
  Write-Host "--- TF di gestione: $($tf.Nome) ---" -ForegroundColor Cyan

# Box notte 22:00-06:59 SERVER (= 23:00-07:59 italiane). L'oro non ha una
# "apertura" come il DAX: il box e' la notte vera, non un pre-mercato.
# Piazzamento alle 07:00 server, cutoff 09:30, flat alle 17:30.
$Inputs=@"
InpBoxStartHour=22||22||0||22||N
InpBoxStartMin=0||0||0||0||N
InpBoxEndHour=6||6||0||6||N
InpBoxEndMin=59||59||0||59||N
InpMinBoxPts=0||0||0||0||N
InpMaxBoxPts=0||0||0||0||N
InpPlaceHour=7||7||0||7||N
InpPlaceMin=0||0||0||0||N
InpEntryCutoffHour=9||9||0||9||N
InpEntryCutoffMin=30||30||0||30||N
InpCloseHour=17||17||0||17||N
InpCloseMin=30||30||0||30||N
InpCloseAtEnd=1||1||0||1||N
InpOneTradePerDay=1||1||0||1||N
InpPendingExpiryMin=90||90||0||90||N
InpAllowLong=1||1||0||1||N
InpAllowShort=1||1||0||1||N
InpAtrPeriod=14||14||0||14||N
InpAtrSLmult=1.5||1.5||0||1.5||N
InpSLFixedPts=3000||3000||0||3000||N
InpTP1_R=1.0||1.0||0||1.0||N
InpTP1Pct=50||50||0||50||N
InpBreakeven=1||1||0||1||N
InpTP2_R=2.5||2.5||0||2.5||N
InpTP2Pct=50||50||0||50||N
InpUseEMA200Target=1||1||0||1||N
InpEMA200Period=200||200||0||200||N
InpTPfinal_R=4.0||4.0||0||4.0||N
InpRiskPercent=1.0||1.0||0||1.0||N
InpMgmtTF=$($tf.Val)||$($tf.Val)||0||$($tf.Val)||N
$rigaSL
$rigaBuffer
"@

  $tag="oro_maxmin_fase$($Fase)_$($tf.Nome)"
  $ini=Join-Path $Work "mmo_$tag.ini"
@"
[Tester]
Expert=$EA.ex5
Symbol=$Sym
Period=M5
Model=$Model
Optimization=1
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
Report=OptReport_$tag

[TesterInputs]
$Inputs
"@ | Set-Content -Path $ini -Encoding ASCII

  $csv=Join-Path $MqlFiles "OptResults_${EA}_$Sym.csv"
  if(Test-Path $csv){ Remove-Item $csv -Force }
  Write-Host "    avvio $PerTF pass (Model $Model, 2024.01 - 2026.06)..." -ForegroundColor Cyan
  (Start-Process -FilePath $Terminal -ArgumentList "/config:`"$ini`"" -PassThru).WaitForExit()

  $done=Join-Path $Results "$tag.csv"
  if(Test-Path $csv){
    try{ Copy-Item $csv -Destination $done -Force; Remove-Item $csv -Force
         Write-Host "    OK -> $done" -ForegroundColor Green }
    catch{ Write-Host "    salvataggio fallito, il CSV resta in $csv" -ForegroundColor Yellow }
  }else{
    Write-Host "    (nessun CSV per ${tag}: storico mancante su $Sym? oppure MT5 era aperto)" -ForegroundColor Yellow
  }
}

Write-Host ""
if($Fase -eq 1){
  Write-Host "=== FINITO FASE 1 === Mandami 'risultati_maxmin_oro'." -ForegroundColor White
  Write-Host "    Ti dico quale SLMode ha retto, poi lanci:" -ForegroundColor Gray
  Write-Host "    .\maxmin_oro.ps1 -Fase 2 -SLMode <quello che ti dico>" -ForegroundColor Gray
  Write-Host "    NON guardiamo i profitti assoluti della fase 1: in OHLC sono finti." -ForegroundColor DarkGray
}else{
  Write-Host "=== FINITO FASE 2 === Mandami 'risultati_maxmin_oro': questi numeri contano." -ForegroundColor White
}
