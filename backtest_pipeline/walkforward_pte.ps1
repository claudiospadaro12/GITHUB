# =====================================================================
#  walkforward_pte.ps1  --  la PTE, misurata per la prima volta
# ---------------------------------------------------------------------
#  PERCHE' ESISTE (07/08/2026)
#  Claudio chiede se la PTE puo' andare bene per una prop. Oggi la
#  risposta onesta e': NON LO SAPPIAMO. Nell'export ci sono 1132 trade
#  chiusi e NESSUNO e' della PTE; in backtest_pipeline non esiste una
#  sola riga di risultati; un driver non c'era. Tutto quello che si e'
#  visto finora e' il PROFITTO FLOTTANTE di una posizione aperta.
#
#  L'IPOTESI, SCRITTA PRIMA DI GUARDARE I NUMERI
#  Il breakeven della PTE ha un solo grilletto: il primo target, che con
#  InpTP1_ATRmult = 0 e' la EMA14 sul TF operativo. Su H4 quella media
#  puo' stare lontanissima, e finche' non ci arriva la posizione resta
#  a rischio pieno. Il 06/08 si e' visto dal vivo: short oro aperto alle
#  16:00, arrivato a +22,29, tornato a +1,41 con lo stop ancora
#  all'originale (4314.19).
#     -> AVVICINARE IL PRIMO TARGET FA SCATTARE PRIMA IL BREAKEVEN E
#        MIGLIORA LA RESA/DD SENZA DISTRUGGERE IL PROFITTO.
#  La leva esiste gia' come parametro: InpTP1_ATRmult (0 = EMA14).
#
#  CRITERIO DI ACCETTAZIONE (dichiarato ora, non dopo):
#    1. positiva in TUTTE E DUE le finestre, non solo fuori campione
#    2. PF >= 1,10 fuori campione
#    3. celle VICINE positive: non un picco isolato
#    4. "Peggior Giornata %" fuori campione sopra -2,5% al rischio 1%
#       (una prop chiude a -5%: sotto il -2,5% al 2% si sfonda)
#  Se una sola non e' soddisfatta, la PTE non e' pronta per una prop.
#
#  ⚠️ PREREQUISITO DA FARE PRIMA -- NON SALTARLO
#  Non sappiamo DA QUANDO parte lo storico dell'oro su BCM. Sugli indici
#  diceva 2024.01.01 e partiva dal 26/09/2024: la finestra IS era la meta'
#  di come si chiamava. Misuralo:
#     powershell -ExecutionPolicy Bypass -File .\scarica_storico.ps1 -Simboli "XAUUSD" -SoloReferto
#  e poi passa la data vera con -DaQuando. Il default qui sotto e' una
#  IPOTESI PRUDENTE copiata dagli indici, non una misura.
#
#  USO (PC di backtest, MT5 CHIUSO):
#    powershell -ExecutionPolicy Bypass -File .\walkforward_pte.ps1 -DaQuando 2024.09.26
#    ...senza -Rifai rifa' solo i CSV mancanti.
# =====================================================================
param(
  [string]$DaQuando = "2024.09.26",   # inizio storico VERO, da misurare prima
  [switch]$Rifai,
  [switch]$UseSpare,[string]$Terminal="",[string]$MetaEditor="",[string]$DataFolder="",[switch]$Force
)
$ErrorActionPreference="Stop"
[Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12
$EABranch="lavoro"
$RawBase="https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$EABranch"

$Jobs=@(
  @{ Nome="PTE_ORO"; EA="ABTG_PTE"; Sym="XAUUSD"; Magic=771301 }
)

# --- le due finestre. Si dividono a meta' lo storico disponibile.
$Inizio = [datetime]::ParseExact($DaQuando,"yyyy.MM.dd",$null)
$Fine   = Get-Date "2026-06-30"
$Meta   = $Inizio.AddDays([math]::Floor(($Fine - $Inizio).TotalDays * 0.40))   # 40% dentro, 60% fuori
$WF=@(
  @{ Tag="IS";  Da=$Inizio.ToString("yyyy.MM.dd"); A=$Meta.ToString("yyyy.MM.dd") },
  @{ Tag="OOS"; Da=$Meta.AddDays(1).ToString("yyyy.MM.dd"); A=$Fine.ToString("yyyy.MM.dd") }
)

# --- FASE N: quando scatta il breakeven, e su quale TF.
#  InpTP1_ATRmult:  0 = EMA14 (quello che gira oggi) | 0,5 | 1,0 | 1,5
#  InpTF: ENUM_TIMEFRAMES. MT5 sugli enum ignora lo STEP e spazzola i
#  membri fra start e stop (misurato il 07/08): da H1 (16385) a H4 (16388)
#  escono H1 H2 H3 H4, quattro celle. La riga NON deve essere degenere.
$Fasi=@(
  @{ Tag="N_breakeven"; Pass=16; Win=$WF
     Sweep="InpTP1_ATRmult=0||0||0.5||1.5||Y`nInpTF=16388||16385||1||16388||Y" }
)

$Blindatura=@"
InpTF=16388||16388||0||16388||N
InpTmaSlow=56||56||0||56||N
InpAtrSlow=100||100||0||100||N
InpMultSlow=2.0||2.0||0||2.0||N
InpTmaFast=14||14||0||14||N
InpAtrFast=30||30||0||30||N
InpMultFast=2.0||2.0||0||2.0||N
InpDojiBodyMaxPct=10.0||10.0||0||10.0||N
InpUseHeikinAshi=1||1||0||1||N
InpRequireOutSlow=0||0||0||0||N
InpRequireColorFlip=1||1||0||1||N
InpAllowLong=1||1||0||1||N
InpAllowShort=1||1||0||1||N
InpUseEma200Bias=0||0||0||0||N
InpEma200Period=200||200||0||200||N
InpEma14Period=14||14||0||14||N
InpUseWPR=0||0||0||0||N
InpWprPeriod=14||14||0||14||N
InpWprOB=-20.0||-20.0||0||-20.0||N
InpWprOS=-80.0||-80.0||0||-80.0||N
InpAtrExitPeriod=14||14||0||14||N
InpSLbufferPips=5.0||5.0||0||5.0||N
InpSLfromDoji=0||0||0||0||N
InpTP1_ATRmult=0.0||0.0||0||0.0||N
InpTP1Pct=50||50||0||50||N
InpBreakeven=1||1||0||1||N
InpTP2_ATRmult=2.0||2.0||0||2.0||N
InpUseTrailing=1||1||0||1||N
InpRiskPercent=1.0||1.0||0||1.0||N
InpMaxTradesPerDay=0||0||0||0||N
InpMaxPositions=1||1||0||1||N
InpUseNewsFilter=0||0||0||0||N
InpNewsMinImpact=3||3||0||3||N
InpNewsBeforeMin=60||60||0||60||N
InpNewsAfterMin=30||30||0||30||N
InpNewsShiftMinutes=0||0||0||0||N
InpMagic=771301||771301||0||771301||N
InpMaxSpread=0||0||0||0||N
InpVerbose=1||1||0||1||N
"@

$Work= if($PSScriptRoot){$PSScriptRoot}else{(Get-Location).Path}; Set-Location $Work
$NPass=0; foreach($f in $Fasi){ $NPass += $f.Pass * $f.Win.Count * $Jobs.Count }
Write-Host "=== WALK-FORWARD PTE (oro) ===" -ForegroundColor Cyan
Write-Host "    IS  $($WF[0].Da) - $($WF[0].A)   (qui si sceglie)" -ForegroundColor Gray
Write-Host "    OOS $($WF[1].Da) - $($WF[1].A)   (qui si verifica, e NON si guarda per scegliere)" -ForegroundColor Gray
Write-Host "    $NPass pass a tick reali." -ForegroundColor Gray
Write-Host ""
Write-Host "    !! Lo storico dell'oro parte davvero dal $DaQuando ?" -ForegroundColor Yellow
Write-Host "       Se non l'hai MISURATO, fermati: sugli indici diceva 2024.01.01" -ForegroundColor Yellow
Write-Host "       e partiva dal 26/09/2024. Meta' finestra IS non esisteva." -ForegroundColor Yellow
Write-Host ""

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
$Results=Join-Path $Work "risultati_pte"
New-Item -ItemType Directory -Force -Path $MqlExperts,$Results,(Join-Path $Work "src_pte")|Out-Null
if((Get-Process -Name "terminal64" -ErrorAction SilentlyContinue) -and -not $Force){
  Write-Host "!!! Chiudi MetaTrader prima di lanciare (altrimenti 0 CSV)." -ForegroundColor Red; exit 1 }

foreach($j in $Jobs){
  $src=Join-Path $Work "src_pte\$($j.EA).mq5"
  try{ Invoke-WebRequest -Uri "$RawBase/mql5/Experts/$($j.EA).mq5" -OutFile $src -UseBasicParsing }
  catch{ Write-Host "    ERRORE download $($j.EA)" -ForegroundColor Red; continue }
  Copy-Item $src -Destination $MqlExperts -Force
  & $MetaEditor "/compile:$(Join-Path $MqlExperts "$($j.EA).mq5")" "/log" | Out-Null
  if(-not (Test-Path (Join-Path $MqlExperts "$($j.EA).ex5"))){ Write-Host "    ERRORE compilazione $($j.EA)" -ForegroundColor Red; continue }
  Write-Host "    compilato $($j.EA)" -ForegroundColor Green
}

foreach($j in $Jobs){
  foreach($fase in $Fasi){
    foreach($w in $fase.Win){
      $tag="$($j.Nome)_$($fase.Tag)_$($w.Tag)"
      $done=Join-Path $Results "$tag.csv"
      if((Test-Path $done) -and -not $Rifai){ Write-Host "    $tag gia' fatto, salto (usa -Rifai per rifarlo)" -ForegroundColor DarkGray; continue }
      if(Test-Path $done){
        $vecchi=Join-Path $Results "vecchi"; New-Item -ItemType Directory -Force -Path $vecchi|Out-Null
        Move-Item $done (Join-Path $vecchi "$tag.csv") -Force
        Write-Host "    ${tag}: il precedente e' stato spostato in 'vecchi\'" -ForegroundColor DarkYellow
      }
      Write-Host ""
      Write-Host "--- $tag   ($($w.Da) -> $($w.A)) ---" -ForegroundColor Cyan

      $BloccoJob="InpMagic=$($j.Magic)||$($j.Magic)||0||$($j.Magic)||N"
      $Righe = @()
      foreach($blocco in @($BloccoJob, $Blindatura, $fase.Sweep)){
        $Righe += @($blocco -split "[`r`n]+" | Where-Object { $_ -match "=" })
      }
      $Visti = @{}
      $Finali = New-Object System.Collections.ArrayList
      for($i=$Righe.Count-1; $i -ge 0; $i--){
        $n = ($Righe[$i] -split "=")[0].Trim()
        if(-not $Visti.ContainsKey($n)){ $Visti[$n] = $true; [void]$Finali.Insert(0, $Righe[$i]) }
      }
      Write-Host "    parametri: $($Finali.Count) righe (tolte $($Righe.Count - $Finali.Count) ripetizioni)" -ForegroundColor DarkGray
      $doppi = @($Finali | ForEach-Object { ($_ -split "=")[0].Trim() } | Group-Object | Where-Object { $_.Count -gt 1 })
      if($doppi.Count -gt 0){
        Write-Host "    ERRORE: parametri ancora duplicati: $($doppi.Name -join ', ')" -ForegroundColor Red
        continue
      }
      $Inputs = ($Finali) -join "`n"

      $ini=Join-Path $Work "pte_$tag.ini"
@"
[Experts]
AllowLiveTrading=false
AllowDllImport=false

[Tester]
Expert=$($j.EA).ex5
Symbol=$($j.Sym)
Period=H1
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
      Write-Host "    avvio $($fase.Pass) pass (tick reali)..." -ForegroundColor Cyan
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

$Attesi = New-Object System.Collections.ArrayList
foreach($j in $Jobs){ foreach($f in $Fasi){ foreach($w in $f.Win){
  [void]$Attesi.Add("$($j.Nome)_$($f.Tag)_$($w.Tag).csv") } } }
$Mancanti = @($Attesi | Where-Object { -not (Test-Path (Join-Path $Results $_)) })

Write-Host ""
Write-Host "=== FINITO ===" -ForegroundColor White
Write-Host ("    CSV attesi: {0}   presenti: {1}   MANCANTI: {2}" -f `
            $Attesi.Count, ($Attesi.Count - $Mancanti.Count), $Mancanti.Count) -ForegroundColor Gray
if($Mancanti.Count -gt 0){
  Write-Host ""
  Write-Host "!!! QUESTI NON SONO STATI PRODOTTI:" -ForegroundColor Red
  foreach($m in $Mancanti){ Write-Host "      $m" -ForegroundColor Red }
  Write-Host "    Rilancia lo STESSO comando SENZA -Rifai: rifa' solo questi." -ForegroundColor Yellow
} else {
  Write-Host "    Tutti prodotti. Sono in 'risultati_pte'." -ForegroundColor Green
}
Write-Host ""
Write-Host "    Il criterio e' scritto in cima a questo file. Non spostarlo dopo." -ForegroundColor Gray
