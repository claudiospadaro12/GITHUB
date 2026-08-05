# =====================================================================
#  aperture_retest_fade.ps1  --  riabilitare due motori bocciati male
#
#  Claudio (05/08, guardando il Nasdaq a 29.941): "ci vorrebbe un sell
#  limit adesso sul livello di resistenza".
#
#  Quella cosa l'EA la sa gia' fare, in due modi diversi:
#    InpEntryMode = 2  RETEST     rompe il livello, poi LIMIT sul livello
#                                 (entri sul ritorno, non sull'inseguimento)
#    InpEntryMode = 3  RANGE_FADE LIMIT sull'estremo del range
#                                 (vendi il massimo, compri il minimo)
#
#  Furono bocciati a LUGLIO. Ma quel test aveva:
#     - TP a 3R   (irraggiungibile: lo si e' scoperto sul Dow il 05/08)
#     - trailing FISSO a 0,07 R (distruttivo: il 04/08 ha catturato 1,90
#       punti dove la base candela ne prendeva 25,64)
#  Cioe' esattamente le due cose che poi si sono rivelate il problema.
#  **Quella bocciatura non vale.** Non si boccia un motore d'ingresso
#  con una gestione che affossa anche il motore che funziona.
#
#  Qui si rifa' con la GESTIONE BUONA, quella validata sul Dow:
#     TP 1,5R · niente parziale · niente breakeven · trailing a base
#     candela M5 · rischio 1% · stop floor 500 punti
#  identica a quella di aperture_trailing.ps1, cosi' i numeri sono
#  CONFRONTABILI con il riferimento gia' in archivio.
#
#  Tre lanci per mercato, 4 pass ciascuno:
#     REF     BREAKOUT (com'e' adesso) x buffer 100/200/300/400
#     RETEST  x InpRetestOffsetPts 0/100/200/300
#     FADE    x InpFadeOffsetPts    0/100/200/300
#
#  E il Nasdaq gira DUE VOLTE, perche' l'audit del 05/08 ha scoperto che
#  in forward usa RangeMode=2 (candela H1 precedente) mentre tutti i
#  nostri test usavano RangeMode=0 (range d'apertura). Qui si misurano
#  tutt'e due: quella confrontabile e quella ACCESA.
#
#  48 pass a tick reali (36 con -SoloLive, che salta il Dow).
#
#  ⚠️ Il Dow serve da CONTROLLO: e' l'unico mercato dove il breakout
#     funziona davvero (PF 1,371 validato in walk-forward). Se RETEST o
#     FADE battono il breakout anche li', vuol dire molto di piu' che
#     batterlo dove il breakout gia' non va da nessuna parte.
#
#  ⚠️ NOTA sul FADE, importante: il suo stop NON usa InpSLMode. Usa
#     AtrValue()*InpAtrSlMult (qui 1,5) con floor a InpMinStopPts.
#     E AtrValue() legge l'ATR sul **TIMEFRAME DEL GRAFICO**:
#         gAtrH = iATR(_Symbol, PERIOD_CURRENT, InpAtrPeriodMgmt);
#     Qui il tester gira su Period=M5, quindi lo stop del fade e' tarato
#     sull'ATR M5. Se un giorno il fade va in forward, l'EA VA MESSO SU
#     UN GRAFICO M5: sul grafico M3 del DAX lo stop sarebbe piu' stretto
#     di quello misurato, e i numeri di questo test non varrebbero.
#     (Sulla configurazione attuale - BREAKOUT + SL_RANGE + trailing a
#     base candela - il grafico NON conta: AtrValue() non viene chiamato.
#     Conta solo se si accende fade, stop ad ATR, trailing ad ATR o il
#     filtro volumi, che legge anch'esso il TF del grafico.)
#     Se il fade mostra qualcosa, il passo dopo e' spazzolare
#     InpAtrSlMult: qui e' pinnato per non confondere le variabili.
#
#  PC di backtest, MetaTrader CHIUSO.
#  Uso:
#    powershell -ExecutionPolicy Bypass -File .\aperture_retest_fade.ps1
#    .\aperture_retest_fade.ps1 -SoloLive        (salta il Dow: 36 pass)
# =====================================================================
param(
  [switch]$SoloLive,
  [int]$TrailTF=5,
  [switch]$UseSpare,[string]$Terminal="",[string]$MetaEditor="",[string]$DataFolder="",[switch]$Force
)
$ErrorActionPreference="Stop"
[Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12
$EABranch="lavoro"
$RawBase="https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$EABranch"

$Jobs=@(
  @{ Nome="DAX";           EA="ABTG_DAX_Apertura_EU";    Sym="D30EUR"; Ora=8;  Min=0;  RMode=0; Ema=0; Vol=0 },
  @{ Nome="NASDAQ_range";  EA="ABTG_Nasdaq_Apertura_US"; Sym="NASUSD"; Ora=14; Min=30; RMode=0; Ema=0; Vol=0 },
  @{ Nome="NASDAQ_prevH1"; EA="ABTG_Nasdaq_Apertura_US"; Sym="NASUSD"; Ora=14; Min=30; RMode=2; Ema=0; Vol=0 },
  @{ Nome="DOW";           EA="ABTG_Dow_Apertura_US";    Sym="U30USD"; Ora=14; Min=30; RMode=0; Ema=1; Vol=0 }
)
if($SoloLive){ $Jobs = $Jobs | Where-Object { $_.Nome -ne "DOW" } }

# i tre lanci: nome, riga dell'EntryMode, riga del parametro in sweep
$Lanci=@(
  @{ Tag="REF_breakout"; Mode="InpEntryMode=0||0||0||0||N"; Sweep="InpBufferPoints=100||100||100||400||Y";      Fisso="InpRetestOffsetPts=0||0||0||0||N`nInpFadeOffsetPts=0||0||0||0||N" },
  @{ Tag="RETEST";       Mode="InpEntryMode=2||2||0||2||N"; Sweep="InpRetestOffsetPts=0||0||100||300||Y";       Fisso="InpBufferPoints=200||200||0||200||N`nInpFadeOffsetPts=0||0||0||0||N" },
  @{ Tag="FADE";         Mode="InpEntryMode=3||3||0||3||N"; Sweep="InpFadeOffsetPts=0||0||100||300||Y";         Fisso="InpBufferPoints=200||200||0||200||N`nInpRetestOffsetPts=0||0||0||0||N" }
)

$Work= if($PSScriptRoot){$PSScriptRoot}else{(Get-Location).Path}; Set-Location $Work
$NPass = $Jobs.Count * $Lanci.Count * 4
Write-Host "=== RETEST e RANGE_FADE con la GESTIONE BUONA ===" -ForegroundColor Cyan
Write-Host "    $($Jobs.Count) configurazioni x 3 lanci x 4 pass = $NPass pass a tick reali." -ForegroundColor Gray
Write-Host "    Gestione: TP 1,5R, trailing base candela M$TrailTF, niente parziale ne BE, rischio 1%." -ForegroundColor Gray

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
$Results=Join-Path $Work "risultati_retest_fade"
New-Item -ItemType Directory -Force -Path $MqlExperts,$Results,(Join-Path $Work "src_rf")|Out-Null
if((Get-Process -Name "terminal64" -ErrorAction SilentlyContinue) -and -not $Force){
  Write-Host "!!! Chiudi MetaTrader prima di lanciare (altrimenti 0 CSV)." -ForegroundColor Red; exit 1 }

# --- scarico e compilo una sola volta per EA ---
$fatti=@{}
# --- BLINDATURA (05/08) -------------------------------------------------
# I parametri NON elencati qui MT5 se li tiene dallo stato precedente del
# terminale, comprese le impostazioni di ottimizzazione. Risultato: nel
# test del trailing e in quello dell'ingresso il terminale ha spazzolato
# da solo InpTrailFixedPts su 8 valori, moltiplicando i pass per 8
# (160 righe invece di 20). I numeri erano giusti - quel parametro e'
# inerte con TrailMode=1 - ma il tempo macchina era 8 volte tanto.
# Da qui in poi si pinna TUTTO. Niente resta al caso.
$Blindatura=@"
InpLevelTF=16385||16385||0||16385||N
InpPrevWindowMin=60||60||0||60||N
InpMinRangePts=0||0||0||0||N
InpMaxRangePts=0||0||0||0||N
InpDelayMinutes=30||30||0||30||N
InpDelayDirMode=0||0||0||0||N
InpGapMinPoints=150||150||0||150||N
InpGapMinRR=1.5||1.5||0||1.5||N
InpStAtrPeriod=10||10||0||10||N
InpStMultiplier=2.5||2.5||0||2.5||N
InpStTF=16385||16385||0||16385||N
InpCorrTF=16385||16385||0||16385||N
InpCorrEmaFast=14||14||0||14||N
InpCorrEmaSlow=100||100||0||100||N
InpVwapTF=15||15||0||15||N
InpAtrSlMult=1.5||1.5||0||1.5||N
InpAtrPeriodMgmt=14||14||0||14||N
InpTrailAtrMult=2.0||2.0||0||2.0||N
InpTrailFixedPts=410||410||0||410||N
InpRoundStep=100.0||100.0||0||100.0||N
InpRoundMinDistPts=50||50||0||50||N
InpNewsMinImpact=3||3||0||3||N
InpNewsBeforeMin=30||30||0||30||N
InpNewsAfterMin=30||30||0||30||N
InpNewsShiftMinutes=0||0||0||0||N
InpNewsFlatten=1||1||0||1||N
InpSlippagePts=0||0||0||0||N
InpAtrFilterBars=20||20||0||20||N
InpAtrFilterMult=1.0||1.0||0||1.0||N
InpMaxSpread=0||0||0||0||N
InpPendingExpiryMin=120||120||0||120||N
InpOCTimeframe=0||0||0||0||N
InpEmaFast=1||1||0||1||N
InpEmaSlow=50||50||0||50||N
InpFilterTF=16388||16388||0||16388||N
InpVolMult=1.5||1.5||0||1.5||N
InpVolAvgBars=20||20||0||20||N
InpVerbose=1||1||0||1||N
"@
# ------------------------------------------------------------------------

foreach($j in $Jobs){
  if($fatti.ContainsKey($j.EA)){ continue }
  $src=Join-Path $Work "src_rf\$($j.EA).mq5"
  try{ Invoke-WebRequest -Uri "$RawBase/mql5/Experts/$($j.EA).mq5" -OutFile $src -UseBasicParsing }
  catch{ Write-Host "    ERRORE download $($j.EA)" -ForegroundColor Red; continue }
  Copy-Item $src -Destination $MqlExperts -Force
  & $MetaEditor "/compile:$(Join-Path $MqlExperts "$($j.EA).mq5")" "/log" | Out-Null
  if(-not (Test-Path (Join-Path $MqlExperts "$($j.EA).ex5"))){ Write-Host "    ERRORE compilazione $($j.EA)" -ForegroundColor Red; continue }
  Write-Host "    compilato $($j.EA)" -ForegroundColor Green
  $fatti[$j.EA]=$true
}

foreach($j in $Jobs){
  if(-not $fatti.ContainsKey($j.EA)){ continue }
  foreach($L in $Lanci){

    $tag="$($j.Nome)_$($L.Tag)"
    Write-Host ""
    Write-Host "--- $tag  ($($j.Sym), RangeMode $($j.RMode)) ---" -ForegroundColor Cyan

    # Tutto pinnato tranne il parametro in sweep. La gestione e' IDENTICA a
    # quella di aperture_trailing.ps1: i numeri sono confrontabili con il
    # riferimento gia' in archivio, non vanno riletti da zero.
    $Inputs=@"
InpSessionHour=$($j.Ora)||$($j.Ora)||0||$($j.Ora)||N
InpSessionMin=$($j.Min)||$($j.Min)||0||$($j.Min)||N
InpRangeMinutes=15||15||0||15||N
InpRangeMode=$($j.RMode)||$($j.RMode)||0||$($j.RMode)||N
InpCloseHour=17||17||0||17||N
InpCloseMin=30||30||0||30||N
InpCloseAtEnd=1||1||0||1||N
InpOneTradePerDay=1||1||0||1||N
InpAllowLong=1||1||0||1||N
InpAllowShort=1||1||0||1||N
InpUseGapFill=0||0||0||0||N
InpUseSupertrend=0||0||0||0||N
InpUseSupertrend3=0||0||0||0||N
InpUseCorrelation=0||0||0||0||N
InpUseVwapFilter=0||0||0||0||N
InpUseRoundLevels=0||0||0||0||N
InpUseNewsFilter=0||0||0||0||N
InpUseAtrFilter=0||0||0||0||N
InpConfirmMode=1||1||0||1||N
InpUseEmaFilter=$($j.Ema)||$($j.Ema)||0||$($j.Ema)||N
InpUseVolumeFilter=$($j.Vol)||$($j.Vol)||0||$($j.Vol)||N
InpRiskPercent=1.0||1.0||0||1.0||N
InpSLMode=0||0||0||0||N
InpMinStopPts=500||500||0||500||N
InpSkipIfTight=0||0||0||0||N
InpTP1_R=0.5||0.5||0||0.5||N
InpTP1_ClosePct=0||0||0||0||N
InpBreakevenAtTP1=0||0||0||0||N
InpBEatR=0||0||0||0||N
InpUseTrailing=1||1||0||1||N
InpTrailMode=1||1||0||1||N
InpTrailTF=$TrailTF||$TrailTF||0||$TrailTF||N
$Blindatura
$($L.Fisso)
$($L.Mode)
$($L.Sweep)
"@

    $ini=Join-Path $Work "rf_$tag.ini"
@"
[Tester]
Expert=$($j.EA).ex5
Symbol=$($j.Sym)
Period=M5
Model=4
Optimization=1
OptimizationCriterion=6
FromDate=2024.09.26
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

    $csv=Join-Path $MqlFiles "OptResults_$($j.EA)_$($j.Sym).csv"
    if(Test-Path $csv){ Remove-Item $csv -Force }
    Write-Host "    avvio 4 pass (TICK REALI M5, 2024.01 - 2026.06)..." -ForegroundColor Cyan
    (Start-Process -FilePath $Terminal -ArgumentList "/config:`"$ini`"" -PassThru).WaitForExit()

    $done=Join-Path $Results "$tag.csv"
    if(Test-Path $csv){
      try{ Copy-Item $csv -Destination $done -Force; Remove-Item $csv -Force
           Write-Host "    OK -> $done" -ForegroundColor Green }
      catch{ Write-Host "    salvataggio fallito, il CSV resta in $csv" -ForegroundColor Yellow }
    }else{
      Write-Host "    (nessun CSV per ${tag}: storico tick mancante su $($j.Sym)?)" -ForegroundColor Yellow
    }
  }
}

Write-Host ""
Write-Host "=== FINITO === Zippa 'risultati_retest_fade' e caricamela." -ForegroundColor White
Write-Host "    Riferimento gia' noto, stessa gestione: DAX breakout -78,78 (PF 0,994)" -ForegroundColor Gray
Write-Host "    Nasdaq breakout -769,01 (PF 0,894) · Dow +3.882 (PF 1,371)." -ForegroundColor Gray
