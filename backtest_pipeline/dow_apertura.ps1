# =====================================================================
#  dow_apertura.ps1  --  IL DOW, il mercato che i dati indicano
#
#  La FASE A (studio del movimento, 8 indici, ~3500 trade) dice che il
#  breakout cieco all'apertura ha aspettativa ZERO o negativa su sette
#  indici, e che l'unico che si stacca e' il DOW:
#      U30USD  +0,074 R/trade cieco
#              +0,126 R/trade col filtro trend H4
#              +0,103 R/trade con TP a 1,5R
#  Terzo riscontro indipendente: ai tick reali col fix gestione il Dow
#  dava PF 1,30, ed era l'unico sopravvissuto alla bocciatura della
#  famiglia breakout.
#
#  Qui si verifica quella misura sui P&L VERI, con costi e slippage.
#
#  Uso (PC di backtest, MetaTrader CHIUSO):
#    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/lavoro/backtest_pipeline/dow_apertura.ps1" | iex
#  oppure, per la seconda fase:
#    .\dow_apertura.ps1 -Fase distanze
# =====================================================================
param(
  [ValidateSet("motore","robustezza","distanze","trailing","trailing2","walkforward")]
  [string]$Fase="motore",
  [string]$Symbol="U30USD",
  [int]$SessionHour=14,                   # ORA SERVER BCM: apertura USA 15:30 IT = 14:30 server
  [int]$SessionMin=30,
  [string]$Tf="M5",
  # nella fase "distanze" si fissa la selezione VINCENTE della fase "motore".
  # I default qui sotto sono l'ipotesi dello studio: si cambiano se i numeri dicono altro.
  [int]$H4=1,                             # 1 = filtro trend H4 acceso
  [int]$Vol=0,                            # 1 = filtro volumi acceso
  [double]$VolMult=1.5,
  [switch]$UseSpare,[string]$Terminal="",[string]$MetaEditor="",[string]$DataFolder="",[switch]$Force
)
$ErrorActionPreference="Stop"
[Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12
$EA="ABTG_Nasdaq_Apertura_US"            # e' l'EA dell'apertura USA: il Dow apre alla stessa ora
$EABranch="lavoro"
$RawBase="https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$EABranch"

# ---------------------------------------------------------------------
#  R del Dow misurato dallo studio: 12532 punti MT5 = ~125 punti indice
#  (U30USD quota a 2 decimali -> 1 punto indice = 100 punti MT5).
#  Serve per tarare il trailing: l'attuale InpTrailFixedPts=410 vale
#  410/12532 = 0,03 R, cioe' il 3% del rischio. Da qui i 39 secondi.
# ---------------------------------------------------------------------
$R_DOW = 12532

# ---------------------------------------------------------------------
#  ATTENZIONE: TpTotalR() nell'EA mette il TP a 3 x InpTP1_R.
#  Quindi InpTP1_R=0.5 -> TP totale a 1,5R (l'ottimo dello studio).
#  Il default 1.0 mette il TP a 3R, oltre tutto cio' che e' stato misurato.
# ---------------------------------------------------------------------

# === FASE "MOTORE": replica lo studio sui P&L veri, e chiede le due domande ===
#     1) il filtro trend H4 aiuta davvero il Dow? (studio: +0,052 R/trade)
#     2) il filtro volumi, l'unico che funziona sul Nasdaq, funziona anche qui?
#     Gestione VOLUTAMENTE nuda: solo stop e TP, niente parziale/BE/trailing,
#     cosi' il confronto con lo studio e' uno a uno.
$Inputs=@"
InpSessionHour=$SessionHour||$SessionHour||0||$SessionHour||N
InpSessionMin=$SessionMin||$SessionMin||0||$SessionMin||N
InpRangeMinutes=15||15||0||15||N
InpCloseHour=17||17||0||17||N
InpCloseMin=30||30||0||30||N
InpCloseAtEnd=1||1||0||1||N
InpOneTradePerDay=1||1||0||1||N
InpEntryMode=0||0||0||0||N
InpRangeMode=0||0||0||0||N
InpBufferPoints=200||200||0||200||N
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
InpRiskPercent=1.0||1.0||0||1.0||N
InpSLMode=0||0||0||0||N
InpMinStopPts=500||500||0||500||N
InpSkipIfTight=0||0||0||0||N
InpTP1_R=0.5||0.5||0||0.5||N
InpTP1_ClosePct=0||0||0||0||N
InpBreakevenAtTP1=0||0||0||0||N
InpBEatR=0||0||0||0||N
InpUseTrailing=0||0||0||0||N
InpTrailFixedPts=$R_DOW||$R_DOW||0||$R_DOW||N
InpEmaFast=1||1||0||1||N
InpEmaSlow=50||50||0||50||N
InpFilterTF=16388||16388||0||16388||N
InpVolAvgBars=20||20||0||20||N
InpUseEmaFilter=0||0||1||1||Y
InpUseVolumeFilter=0||0||1||1||Y
InpVolMult=1.5||1.2||0.3||1.8||Y
"@
$note="12 pass (4 ridondanti: col filtro volumi spento la soglia non conta). Solo stop+TP, gestione nuda."

# === FASE "ROBUSTEZZA": il PF 1,24 e' un altopiano o una punta fortunata? ===
#     Il filtro H4 e' un interruttore, ma dentro ha un numero mai testato:
#     la EMA a 50 periodi. Se il risultato regge da 20 a 200 e' una
#     proprieta' del mercato; se svetta solo a 50, e' rumore su cui non
#     si costruisce niente. 10 pass, un'ora scarsa: costa poco e decide
#     se le 4-8 ore della fase distanze hanno senso.
if($Fase -eq "robustezza"){
  $Inputs=$Inputs -replace "(?m)^InpUseEmaFilter=.*$","InpUseEmaFilter=1||1||0||1||N"
  $Inputs=$Inputs -replace "(?m)^InpUseVolumeFilter=.*$","InpUseVolumeFilter=0||0||0||0||N"
  $Inputs=$Inputs -replace "(?m)^InpVolMult=.*$","InpVolMult=1.5||1.5||0||1.5||N"
  $Inputs=$Inputs -replace "(?m)^InpEmaSlow=.*$","InpEmaSlow=50||20||20||200||Y"
  $note="10 pass: EMA del filtro H4 da 20 a 200. Cerco un ALTOPIANO, non il massimo."
}

# === FASE "TRAILING": l'unico buco lasciato dalla fase distanze ===
#     Li' InpTrailMode era pinnato a 2 (punti fissi) in tutti e 48 i pass,
#     e il verdetto e' stato "il trailing non paga". Ma il 04/08, in
#     forward sul DAX, il trailing a BASE CANDELA (mode 1) ha catturato
#     25,64 punti contro 1,90 del fisso, a parita di simbolo, ora e
#     direzione: 13 volte tanto. Quel tipo di trailing non e' mai stato
#     misurato a backtest.
#     Confronto: ATR (mode 0) e PREVBAR (mode 1), su M1 e M5.
#     Il riferimento da battere e' la gestione NUDA: profit 3917.
#     12 pass, alcuni ridondanti (l'ATR ignora il TF, il PREVBAR ignora
#     il moltiplicatore): le combinazioni distinte sono 5.
if($Fase -eq "trailing"){
  $Inputs=$Inputs -replace "(?m)^InpUseEmaFilter=.*$","InpUseEmaFilter=$H4||$H4||0||$H4||N"
  $Inputs=$Inputs -replace "(?m)^InpUseVolumeFilter=.*$","InpUseVolumeFilter=$Vol||$Vol||0||$Vol||N"
  $Inputs=$Inputs -replace "(?m)^InpVolMult=.*$","InpVolMult=$VolMult||$VolMult||0||$VolMult||N"
  # tutto il resto della gestione resta SPENTO, come dice la fase distanze:
  # qui si isola il solo effetto del TIPO di trailing.
  $Inputs=$Inputs -replace "(?m)^InpUseTrailing=.*$","InpUseTrailing=1||1||0||1||N"
  $Inputs="$Inputs`nInpTrailMode=0||0||1||1||Y"        # 0=ATR, 1=base candela precedente
  $Inputs="$Inputs`nInpTrailTF=1||1||4||5||Y"          # M1 e M5 (inerte con TrailMode=0)
  $Inputs="$Inputs`nInpTrailAtrMult=2.0||1.0||1.0||3.0||Y"  # inerte con TrailMode=1
  $note="12 pass (5 combo distinte): ATR vs base candela, su M1 e M5. Da battere: 3917 della gestione nuda."
}

# === FASE "TRAILING2": oltre M5 migliora ancora? ===
#     Nella fase trailing il profit sale in modo ordinato con la candela:
#     M1 1162 -> M2 2471 -> M3 2652 -> M4 2837 -> M5 3882. M5 era il bordo
#     della griglia, quindi non sappiamo se l'ottimo sta oltre.
#     4 pass: M5, M10, M15, M20.
if($Fase -eq "trailing2"){
  $Inputs=$Inputs -replace "(?m)^InpUseEmaFilter=.*$","InpUseEmaFilter=$H4||$H4||0||$H4||N"
  $Inputs=$Inputs -replace "(?m)^InpUseVolumeFilter=.*$","InpUseVolumeFilter=$Vol||$Vol||0||$Vol||N"
  $Inputs=$Inputs -replace "(?m)^InpVolMult=.*$","InpVolMult=$VolMult||$VolMult||0||$VolMult||N"
  $Inputs=$Inputs -replace "(?m)^InpUseTrailing=.*$","InpUseTrailing=1||1||0||1||N"
  $Inputs="$Inputs`nInpTrailMode=1||1||0||1||N"     # base candela precedente, il vincitore
  $Inputs="$Inputs`nInpTrailTF=5||5||5||20||Y"      # M5, M10, M15, M20 (tutti TF validi)
  $note="4 pass: trailing a base candela su M5/M10/M15/M20. Da battere: 3882 di profit e PF 1,371 di M5."
}

# === FASE "WALKFORWARD": l'ultimo cancello, e l'unico che manca ===
#     Tutti i numeri del Dow sono stati scelti guardando 2024.01-2026.06.
#     Finche' non li si prova su un periodo MAI visto, restano in-sample.
#     Qui si lancia la STESSA griglia su due finestre separate:
#        IS  2024.01.01 - 2025.06.30   (18 mesi)
#        OOS 2025.07.01 - 2026.06.30   (12 mesi, mai usati per scegliere)
#     Non cerco il massimo: cerco se la REGIONE BUONA e' la stessa nelle
#     due finestre. Se lo e', l'edge e' stabile nel tempo. Se in OOS
#     crolla o si sposta, era curve-fitting e il Dow torna in panchina.
#     Griglia: EMA del filtro (10 valori) x TP totale (4) = 40 pass per
#     finestra, 80 in tutto. Il trailing resta fissato a base candela M5.
if($Fase -eq "walkforward"){
  $Inputs=$Inputs -replace "(?m)^InpUseEmaFilter=.*$","InpUseEmaFilter=1||1||0||1||N"
  $Inputs=$Inputs -replace "(?m)^InpUseVolumeFilter=.*$","InpUseVolumeFilter=0||0||0||0||N"
  $Inputs=$Inputs -replace "(?m)^InpVolMult=.*$","InpVolMult=1.5||1.5||0||1.5||N"
  $Inputs=$Inputs -replace "(?m)^InpUseTrailing=.*$","InpUseTrailing=1||1||0||1||N"
  $Inputs=$Inputs -replace "(?m)^InpEmaSlow=.*$","InpEmaSlow=50||20||20||200||Y"
  $Inputs=$Inputs -replace "(?m)^InpTP1_R=.*$","InpTP1_R=0.5||0.33||0.17||0.84||Y"
  $Inputs="$Inputs`nInpTrailMode=1||1||0||1||N"   # base candela: il vincitore del 05/08
  $Inputs="$Inputs`nInpTrailTF=5||5||0||5||N"     # M5
  $note="80 pass su DUE finestre (IS 18 mesi + OOS 12 mesi mai visti). Cerco la REGIONE stabile, non il massimo."
}

# === FASE "DISTANZE": fissata la selezione, QUANTO larghi ===
#     Il trailing e' espresso in FRAZIONI DI R misurato (non piu' a caso):
#       3000 = 0,24 R · 6000 = 0,48 R · 9000 = 0,72 R · 12500 = 1,00 R
#     Contro i 410 punti attuali, che valgono 0,03 R.
if($Fase -eq "distanze"){
  $Inputs=$Inputs -replace "(?m)^InpUseEmaFilter=.*$","InpUseEmaFilter=$H4||$H4||0||$H4||N"
  $Inputs=$Inputs -replace "(?m)^InpUseVolumeFilter=.*$","InpUseVolumeFilter=$Vol||$Vol||0||$Vol||N"
  $Inputs=$Inputs -replace "(?m)^InpVolMult=.*$","InpVolMult=$VolMult||$VolMult||0||$VolMult||N"
  $Inputs=$Inputs -replace "(?m)^InpTP1_ClosePct=.*$","InpTP1_ClosePct=50||50||0||50||N"
  $Inputs=$Inputs -replace "(?m)^InpBreakevenAtTP1=.*$","InpBreakevenAtTP1=1||1||0||1||N"
  $Inputs=$Inputs -replace "(?m)^InpUseTrailing=.*$","InpUseTrailing=1||1||0||1||N"
  $Inputs=$Inputs -replace "(?m)^InpTP1_R=.*$","InpTP1_R=0.5||0.33||0.17||0.84||Y"
  $Inputs=$Inputs -replace "(?m)^InpBEatR=.*$","InpBEatR=0||0||0.5||1.0||Y"
  $Inputs=$Inputs -replace "(?m)^InpTrailFixedPts=.*$","InpTrailFixedPts=6000||3000||3000||12000||Y"
  $Inputs="$Inputs`nInpTrailMode=2||2||0||2||N"
  $note="48 pass: TP totale 1/1,5/2/2,5R x BE 0/0,5/1R x trailing 0,24/0,48/0,72/1,00 R."
}

$EAtag="DOW_apertura_$Fase"
$Work= if($PSScriptRoot){$PSScriptRoot}else{(Get-Location).Path}; Set-Location $Work
Write-Host "=== DOW APERTURA -- fase '$Fase' su $Symbol $Tf a TICK REALI ===" -ForegroundColor Cyan
Write-Host "    apertura SERVER ${SessionHour}:$('{0:d2}' -f $SessionMin) (= $($SessionHour+1):$('{0:d2}' -f $SessionMin) ora italiana)" -ForegroundColor Gray
Write-Host "    $note" -ForegroundColor Gray

New-Item -ItemType Directory -Force -Path (Join-Path $Work "src_dow") | Out-Null
try{
  Invoke-WebRequest -Uri "$RawBase/mql5/Experts/$EA.mq5" -OutFile (Join-Path $Work "src_dow\$EA.mq5") -UseBasicParsing
  Write-Host "    OK src_dow\$EA.mq5 (da $EABranch)" -ForegroundColor Green
}catch{ Write-Host "    ERRORE download $EA da $EABranch" -ForegroundColor Red; exit 1 }

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
$Results=Join-Path $Work "risultati_dow"; New-Item -ItemType Directory -Force -Path $MqlExperts,$Results|Out-Null
if((Get-Process -Name "terminal64" -ErrorAction SilentlyContinue) -and -not $Force){
  Write-Host "!!! Chiudi MetaTrader prima di lanciare (altrimenti 0 CSV)." -ForegroundColor Red; exit 1 }

Copy-Item (Join-Path $Work "src_dow\$EA.mq5") -Destination $MqlExperts -Force
& $MetaEditor "/compile:$(Join-Path $MqlExperts "$EA.mq5")" "/log" | Out-Null
if(-not (Test-Path (Join-Path $MqlExperts "$EA.ex5"))){Write-Host "ERRORE compilazione $EA" -ForegroundColor Red; exit 1}
Write-Host "    compilato $EA.ex5" -ForegroundColor Green

# Una finestra sola per tutte le fasi, DUE per il walkforward.
$Finestre = @( @{Tag=""; Da="2024.01.01"; A="2026.06.30"} )
if($Fase -eq "walkforward"){
  $Finestre = @(
    @{Tag="_IS";  Da="2024.01.01"; A="2025.06.30"},   # qui si sceglie
    @{Tag="_OOS"; Da="2025.07.01"; A="2026.06.30"}    # qui si verifica: mai visto prima
  )
}

foreach($w in $Finestre){
  $tag = "$Fase$($w.Tag)"
  $iniPath = Join-Path $Work "dow_$tag.ini"
@"
[Tester]
Expert=$EA.ex5
Symbol=$Symbol
Period=$Tf
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
Report=OptReport_DOW_$tag

[TesterInputs]
$Inputs
"@ | Set-Content -Path $iniPath -Encoding ASCII

  $csv = Join-Path $MqlFiles "OptResults_${EA}_$Symbol.csv"
  if(Test-Path $csv){ Remove-Item $csv -Force }
  Write-Host "    avvio: $tag  (TICK REALI $Tf, $($w.Da) - $($w.A))... ci vuole parecchio" -ForegroundColor Cyan
  (Start-Process -FilePath $Terminal -ArgumentList "/config:`"$iniPath`"" -PassThru).WaitForExit()

  $done = Join-Path $Results "dow_$tag.csv"
  if(Test-Path $csv){
    try{ Copy-Item $csv -Destination $done -Force; Remove-Item $csv -Force
         Write-Host "    OK -> $done" -ForegroundColor Green }
    catch{ Write-Host "    salvataggio fallito, il CSV resta in $csv" -ForegroundColor Yellow }
  }else{
    Write-Host "    (nessun CSV per $tag: storico tick mancante su $Symbol?)" -ForegroundColor Yellow
  }
}
Write-Host "`n=== FINITO === Zippa la cartella 'risultati_dow' e caricamela." -ForegroundColor White
