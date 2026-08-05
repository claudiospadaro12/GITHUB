# =====================================================================
#  walkforward_aperture.ps1  --  il passaggio che separa un edge dal caso
#
#  Il 05/08 sono uscite tre piste. Una e' gia' caduta:
#    ❌ OPENCONFIRM   una cella positiva su otto, cambia segno con
#                     timeframe, volumi e mercato. Bocciato.
#    🟡 RANGE 35 min  gradiente monotono su 5 valori, 4/4 in utile su
#                     entrambi i mercati, campione pieno (420 trade)
#    🟡 DELAYED+vol   PF 1,197 e 1,200 su due mercati, ma 120 e 99 trade
#
#  Le due superstiti hanno lo stesso identico difetto: sono **il migliore
#  di N combinazioni sullo stesso periodo**. E' esattamente il modo in cui
#  si trova rumore e lo si scambia per edge.
#
#  Qui si fa quello che si e' fatto sul Dow, l'unico EA validato che
#  abbiamo: la stessa griglia girata su DUE finestre separate.
#
#     IS   2024.09.26 -> 2025.06.30   (9,1 mesi: qui si sceglie - BCM non ha nulla prima)
#     OOS  2025.07.01 -> 2026.06.30   (12 mesi: qui si verifica)
#
#  ⚠️ LA REGOLA, e vale piu' del test: **l'OOS non si guarda per
#     scegliere.** Si sceglie sull'IS, poi si va a vedere se quella
#     scelta regge. Se si sceglie guardando l'OOS, l'OOS diventa un
#     secondo IS e il test non vale piu' niente.
#
#  Cosa deve succedere perche' il 35 sia vero:
#    - il gradiente monotono (5 -> 35) si rivede anche nell'OOS
#    - la cella scelta sull'IS resta positiva nell'OOS
#  Se il 35 vince sull'IS e perde sull'OOS, era rumore. Meglio saperlo
#  adesso che con i soldi.
#
#  FASE A - geometria: RangeMinutes 5/15/25/35/45 x Buffer 100/300/500/700
#           20 pass x 2 finestre x 2 mercati = 80 pass
#  FASE B - motore: tutti i modi d'ingresso x volumi OFF/ON, con il
#           RangeMinutes candidato (35). Dice se il DELAYED regge fuori
#           campione, e se regge ANCHE con il range lungo.
#           12 pass x 2 finestre x 2 mercati = 48 pass
#  FASE C - IL COSTO, ed e' il test che ha piu' probabilita' di uccidere
#           tutto. Il tester riempie gli ordini pendenti STOP al prezzo
#           ESATTO del livello: su un breakout e' ottimista per
#           costruzione, perche' nella realta' si entra peggio.
#           InpSlippagePts peggiora l'entry di N punti.
#           ⚠️ Funziona SOLO sul breakout: DELAYED e OPENCONFIRM entrano
#           a mercato (gTrade.Buy), pagano gia' ask/bid e quindi il tester
#           li simula onestamente - uno slippage extra su un market order
#           non e' nemmeno riproducibile dall'EA. Ma va bene cosi': e' il
#           breakout il motore ottimista, ed e' li' che vive il range 35.
#           RangeMinutes 5/15/25/35/45 x slippage 0/100/200/300 punti
#           (= 0/1/2/3 punti indice), sul periodo INTERO: il costo non e'
#           una domanda di sovradattamento, e cosi' costa la meta'.
#           20 pass x 1 finestra x 2 mercati = 40 pass
#
#  168 pass a tick reali in tutto. E' roba da notte piena.
#  (-SoloGeometria = 80 · -SoloMotore = 48 · -SoloSlippage = 40)
#
#  Gestione fissata a quella validata: TP 1,5R, trailing base candela M5,
#  niente parziale ne' BE, rischio 1%. Non e' quella accesa in forward -
#  vedi report/AUDIT_live_vs_backtest.md - ma e' quella con cui sono
#  confrontabili tutti i numeri del 05/08.
#
#  PC di backtest, MetaTrader CHIUSO.
#  Uso:
#    powershell -ExecutionPolicy Bypass -File .\walkforward_aperture.ps1
# =====================================================================
param(
  [switch]$SoloGeometria,
  [switch]$SoloMotore,
  [switch]$SoloSlippage,
  [int]$TrailTF=5,
  [int]$RangeCandidato=35,
  [switch]$UseSpare,[string]$Terminal="",[string]$MetaEditor="",[string]$DataFolder="",[switch]$Force
)
$ErrorActionPreference="Stop"
[Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12
$EABranch="lavoro"
$RawBase="https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$EABranch"

$Jobs=@(
  @{ Nome="DAX";    EA="ABTG_DAX_Apertura_EU";    Sym="D30EUR"; Ora=8;  Min=0;  Vol=0 },
  @{ Nome="NASDAQ"; EA="ABTG_Nasdaq_Apertura_US"; Sym="NASUSD"; Ora=14; Min=30; Vol=0 }
)

# Le due finestre del walk-forward. NON si sovrappongono: e' tutto il punto.
$WF=@(
  @{ Tag="IS";  Da="2024.09.26"; A="2025.06.30" },
  @{ Tag="OOS"; Da="2025.07.01"; A="2026.06.30" }
)
# La FASE C non e' una domanda di sovradattamento, e' una domanda di COSTI:
# gira sul periodo intero, che e' anche piu' economico.
$TUTTO=@(
  @{ Tag="FULL"; Da="2024.09.26"; A="2026.06.30" }
)

# Le due fasi. In FASE A il motore e' pinnato e si spazzola la geometria;
# in FASE B e' il contrario. Nota: InpEntryMode e' un ENUM e MT5, sugli
# enum, IGNORA start||step||stop e li spazzola TUTTI - scoperto il 05/08.
# Quindi in FASE B bastano due righe per avere sei motori.
$Fasi=@(
  @{ Tag="A_geometria"; Pass=20; Win=$WF
     Sweep="InpEntryMode=0||0||0||0||N`nInpRangeMinutes=15||5||10||45||Y`nInpBufferPoints=300||100||200||700||Y`nInpUseVolumeFilter=0||0||0||0||N`nInpSlippagePts=0||0||0||0||N" },
  @{ Tag="B_motore";    Pass=12; Win=$WF
     Sweep="InpRangeMinutes=$RangeCandidato||$RangeCandidato||0||$RangeCandidato||N`nInpBufferPoints=200||200||0||200||N`nInpEntryMode=0||0||5||5||Y`nInpUseVolumeFilter=0||0||1||1||Y`nInpSlippagePts=0||0||0||0||N" },
  # FASE C - IL COSTO. Il tester riempie gli ordini pendenti STOP al prezzo
  # esatto del livello: su un breakout e' ottimista per costruzione. Nella
  # realta' si entra PEGGIO. InpSlippagePts peggiora l'entry, e funziona
  # SOLO sul breakout - gli altri motori entrano a mercato (gTrade.Buy) e
  # pagano gia' ask/bid, quindi il tester li simula onestamente e uno
  # slippage extra non e' nemmeno riproducibile dall'EA.
  # Qui si spazzola tutto il gradiente del range contro quattro livelli di
  # costo: la domanda non e' "il 35 vince", ma "il 35 vince ANCORA quando
  # l'entry costa 1, 2 o 3 punti indice in piu'".
  @{ Tag="C_slippage";  Pass=20; Win=$TUTTO
     Sweep="InpEntryMode=0||0||0||0||N`nInpBufferPoints=200||200||0||200||N`nInpUseVolumeFilter=0||0||0||0||N`nInpRangeMinutes=15||5||10||45||Y`nInpSlippagePts=0||0||100||300||Y" }
)
if($SoloGeometria){ $Fasi = $Fasi | Where-Object { $_.Tag -eq "A_geometria" } }
if($SoloMotore)   { $Fasi = $Fasi | Where-Object { $_.Tag -eq "B_motore" } }
if($SoloSlippage) { $Fasi = $Fasi | Where-Object { $_.Tag -eq "C_slippage" } }

$Work= if($PSScriptRoot){$PSScriptRoot}else{(Get-Location).Path}; Set-Location $Work
$NPass=0; foreach($f in $Fasi){ $NPass += $f.Pass * $f.Win.Count * $Jobs.Count }
Write-Host "=== WALK-FORWARD DELLE APERTURE ===" -ForegroundColor Cyan
Write-Host "    IS  2024.09.26 - 2025.06.30   (qui si sceglie)" -ForegroundColor Gray
Write-Host "    OOS 2025.07.01 - 2026.06.30   (qui si verifica, e NON si guarda per scegliere)" -ForegroundColor Gray
Write-Host "    $NPass pass a tick reali." -ForegroundColor Gray

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
$Results=Join-Path $Work "risultati_walkforward"
New-Item -ItemType Directory -Force -Path $MqlExperts,$Results,(Join-Path $Work "src_wf")|Out-Null
if((Get-Process -Name "terminal64" -ErrorAction SilentlyContinue) -and -not $Force){
  Write-Host "!!! Chiudi MetaTrader prima di lanciare (altrimenti 0 CSV)." -ForegroundColor Red; exit 1 }

foreach($j in $Jobs){
  $src=Join-Path $Work "src_wf\$($j.EA).mq5"
  try{ Invoke-WebRequest -Uri "$RawBase/mql5/Experts/$($j.EA).mq5" -OutFile $src -UseBasicParsing }
  catch{ Write-Host "    ERRORE download $($j.EA)" -ForegroundColor Red; continue }
  Copy-Item $src -Destination $MqlExperts -Force
  & $MetaEditor "/compile:$(Join-Path $MqlExperts "$($j.EA).mq5")" "/log" | Out-Null
  if(-not (Test-Path (Join-Path $MqlExperts "$($j.EA).ex5"))){ Write-Host "    ERRORE compilazione $($j.EA)" -ForegroundColor Red; continue }
  Write-Host "    compilato $($j.EA)" -ForegroundColor Green
}

# --- BLINDATURA: i parametri non elencati MT5 se li tiene dallo stato
# precedente del terminale, impostazioni di ottimizzazione comprese.
# Il 05/08 stava spazzolando da solo InpTrailFixedPts su 8 valori,
# moltiplicando i pass per 8. Qui si pinna tutto.
$Blindatura=@"
InpLevelTF=16385||16385||0||16385||N
InpPrevWindowMin=60||60||0||60||N
InpMinRangePts=0||0||0||0||N
InpMaxRangePts=0||0||0||0||N
InpRetestOffsetPts=0||0||0||0||N
InpFadeOffsetPts=0||0||0||0||N
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

foreach($j in $Jobs){
  foreach($fase in $Fasi){
    foreach($w in $fase.Win){

      $tag="$($j.Nome)_$($fase.Tag)_$($w.Tag)"
      $done=Join-Path $Results "$tag.csv"
      if(Test-Path $done){ Write-Host "    $tag gia' fatto, salto" -ForegroundColor DarkGray; continue }

      Write-Host ""
      Write-Host "--- $tag   ($($w.Da) -> $($w.A)) ---" -ForegroundColor Cyan

      $Inputs=@"
InpSessionHour=$($j.Ora)||$($j.Ora)||0||$($j.Ora)||N
InpSessionMin=$($j.Min)||$($j.Min)||0||$($j.Min)||N
InpRangeMode=0||0||0||0||N
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
InpUseEmaFilter=0||0||0||0||N
InpConfirmMode=1||1||0||1||N
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
$($fase.Sweep)
"@

      $ini=Join-Path $Work "wf_$tag.ini"
@"
[Tester]
Expert=$($j.EA).ex5
Symbol=$($j.Sym)
Period=M5
Model=4
Optimization=1
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
$Inputs
"@ | Set-Content -Path $ini -Encoding ASCII

      $csv=Join-Path $MqlFiles "OptResults_$($j.EA)_$($j.Sym).csv"
      if(Test-Path $csv){ Remove-Item $csv -Force }
      Write-Host "    avvio $($fase.Pass) pass (tick reali M5)..." -ForegroundColor Cyan
      (Start-Process -FilePath $Terminal -ArgumentList "/config:`"$ini`"" -PassThru).WaitForExit()

      if(Test-Path $csv){
        try{ Copy-Item $csv -Destination $done -Force; Remove-Item $csv -Force
             Write-Host "    OK -> $tag.csv" -ForegroundColor Green }
        catch{ Write-Host "    salvataggio fallito, il CSV resta in $csv" -ForegroundColor Yellow }
      }else{
        Write-Host "    (nessun CSV per ${tag}: MT5 era aperto? storico mancante?)" -ForegroundColor Yellow
      }
    }
  }
}

Write-Host ""
Write-Host "=== FINITO === Zippa 'risultati_walkforward' e caricamela." -ForegroundColor White
Write-Host "    Devono esserci 12 CSV: 8 di walk-forward + 4 di slippage." -ForegroundColor Gray
Write-Host "    NON guardare l'OOS per scegliere: e' l'unica regola che conta qui." -ForegroundColor Yellow
