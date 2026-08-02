# =====================================================================
#  conferma_apertura_dax.ps1  --  CONFERMA col motore APERTURA REALE
#  (ABTG_DAX_Apertura_EU) l'apertura DAX, confrontando STOP vs RETEST.
#
#  Gemello di conferma_apertura_us.ps1 ma per il DAX (D30EUR, M5):
#   - EA:  ABTG_DAX_Apertura_EU
#   - orario apertura: 08:00 SERVER (= 09:00 IT, regola fuso BCM -1h)
#   - filtro H4 SPENTO: sul DAX peggiora l'edge (finding 30/07). Qui
#     confrontiamo puramente il MOTORE d'ingresso (stop vs limit).
#
#  PC FISSO, MetaTrader CHIUSO. Ripresa: salta i simboli gia' fatti.
#
#  Uso (default = OHLC veloce, BREAKOUT attuale):
#    powershell -ExecutionPolicy Bypass -File .\conferma_apertura_dax.ps1
#
#  CONFRONTO MOTORE a TICK REALI (la vera domanda: limit batte lo stop?):
#    powershell -ExecutionPolicy Bypass -File .\conferma_apertura_dax.ps1 -Model 4 -EntryMode 0
#    powershell -ExecutionPolicy Bypass -File .\conferma_apertura_dax.ps1 -Model 4 -EntryMode 2
#    -> due set di CSV separati (..._brk_... vs ..._retest_...), poi si confrontano.
#
#  ENTRATA RITARDATA/CONFERMATA (motore #4 della caccia, dopo il fade):
#    .\conferma_apertura_dax.ps1 -Model 4 -EntryMode 4
#    Aspetta N minuti dall'apertura, poi entra A MERCATO dalla parte che il
#    mercato ha scelto -> niente stop da inseguire, niente slippage di rottura.
#    Griglia automatica: attesa 15/30/45 min x direzione break/mid/candela.
#    CSV in ..._delay_realtick.
#
#  ⭐ CONFIGURAZIONE DEI DOCUMENTI (PDF ABTG + slide) - aggiungi -Doc a qualunque motore:
#    .\conferma_apertura_dax.ps1 -Model 4 -EntryMode 4 -Doc     <- il PDF: "entra DOPO la chiusura
#                                                    della candela di breakout, non durante"
#    .\conferma_apertura_dax.ps1 -Model 4 -EntryMode 0 -Doc     <- le slide Nasdaq: ordini STOP su H1
#    -> CSV in ..._doc_delay_... / ..._doc_brk_...
# =====================================================================
param(
  [string[]]$Symbols=@("D30EUR"),
  [int]$Model=1,                              # 1=OHLC (veloce) · 4=tick reali (verita')
  [int]$EntryMode=0,                          # 0=BREAKOUT (stop) · 2=RETEST (limit) · 3=RANGE_FADE (fada gli estremi) · 4=DELAYED (entrata ritardata)
  [double]$RetestOffset=0,                     # (solo RETEST) offset del limit DENTRO il livello, in punti
  [double]$FadeOffset=0,                        # (solo RANGE_FADE) offset del limit OLTRE l'estremo, in punti
  [int]$RangeMin=0,                            # se >0 forza InpRangeMinutes (es. 15 = ORB dei primi 15 min)
  [int]$DelayMin=0,                            # (solo DELAYED) minuti d'attesa; 0 = griglia 15/30/45
  [int]$DelayDir=-1,                           # (solo DELAYED) 0=break 1=mid 2=candela; -1 = griglia su tutti e 3
  [switch]$Doc,                                # accende la CONFIGURAZIONE DEI DOCUMENTI (blocco piu' sotto)
  [string]$Filters,                            # (con -Doc) quali filtri accendere, es. "vol,atr". Omesso = tutti; "" = nessuno
  [string]$EABranch="claude/chat-ea-market-openings-zoba2j", # branch con l'EA aggiornato
  [switch]$UseSpare,[string]$Terminal="",[string]$MetaEditor="",[string]$DataFolder="",[switch]$Force
)
$ErrorActionPreference="Stop"
[Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12
$EA="ABTG_DAX_Apertura_EU"                     # motore DAX/EU
$RawBase="https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$EABranch"

# --- INPUT: apertura DAX 08:00 server, filtro H4 SPENTO; buffer in mini-griglia ---
$Inputs=@"
InpSessionHour=8||8||0||8||N
InpSessionMin=0||0||0||0||N
InpUseEmaFilter=0||0||0||0||N
InpUseSupertrend=0||0||0||0||N
InpUseCorrelation=0||0||0||0||N
InpUseVwapFilter=0||0||0||0||N
InpAllowLong=1||1||0||1||N
InpAllowShort=1||1||0||1||N
InpRiskPercent=1.0||1.0||0||1.0||N
InpBufferPoints=200||100||100||400||Y
"@

# --- modalita' d'ingresso: BREAKOUT (0) / RETEST (2) / RANGE_FADE (3) ---
$Inputs += "`nInpEntryMode=$EntryMode||$EntryMode||0||$EntryMode||N"
if($EntryMode -eq 2){ $Inputs += "`nInpRetestOffsetPts=$RetestOffset||$RetestOffset||0||$RetestOffset||N" }
if($EntryMode -eq 3){ $Inputs += "`nInpFadeOffsetPts=$FadeOffset||$FadeOffset||0||$FadeOffset||N" }
if($EntryMode -eq 4){
  # DELAYED: si entra a MERCATO -> il buffer del pendente non serve, lo fisso e uso
  # la griglia per ATTESA (15/30/45 min) x MODO DIREZIONE (break / mid / candela).
  $Inputs = $Inputs -replace 'InpBufferPoints=200\|\|100\|\|100\|\|400\|\|Y','InpBufferPoints=200||200||0||200||N'
  if($DelayMin -gt 0){ $Inputs += "`nInpDelayMinutes=$DelayMin||$DelayMin||0||$DelayMin||N" }
  else               { $Inputs += "`nInpDelayMinutes=30||15||15||45||Y" }
  if($DelayDir -ge 0){ $Inputs += "`nInpDelayDirMode=$DelayDir||$DelayDir||0||$DelayDir||N" }
  else               { $Inputs += "`nInpDelayDirMode=0||0||1||2||Y" }
}
if($RangeMin -gt 0){ $Inputs += "`nInpRangeMinutes=$RangeMin||$RangeMin||0||$RangeMin||N" }

# --- imposta un input SENZA duplicare la chiave (sostituisce se c'e' gia', altrimenti aggiunge) ---
function Set-Inp([string]$txt,[string]$k,[string]$v){
  $line = "$k=$v||$v||0||$v||N"
  if($txt -match "(?m)^$k="){ return ($txt -replace "(?m)^$k=.*$", $line) }
  return ($txt + "`n" + $line)
}

# --- come Set-Inp ma con una GRIGLIA (start/step/stop) da ottimizzare ---
function Set-InpGrid([string]$txt,[string]$k,[string]$v,[string]$start,[string]$step,[string]$stop){
  $line = "$k=$v||$start||$step||$stop||Y"
  if($txt -match "(?m)^$k="){ return ($txt -replace "(?m)^$k=.*$", $line) }
  return ($txt + "`n" + $line)
}
if($Doc){
  # === CONFIGURAZIONE PRESCRITTA DAI DOCUMENTI (PDF ABTG + "Piano di trading Europeo") ===
  #  livelli : max/min del GIORNO PRECEDENTE (PDF breakout classico: livelli da D1/W1/MN).
  #            Il Piano Europeo NON prescrive un ORB sul DAX.
  #  filtri  : vol=volumi>=+50% · atr=ATR>=media · st3=TRE Supertrend 2.5/3.0/3.5 concordi
  #            ("quando cambiano tutti e tre posso entrare") · corr=SPXUSD · news
  #  rischio : max 2% del capitale
  #  NB: filtro EMA H4 sempre SPENTO -> sul DAX peggiora l'edge (finding 30/07).
  # --- quali filtri accendere: -Filters "vol,atr,..." per l'ABLAZIONE; se non lo passi, TUTTI ---
  $fl = if($PSBoundParameters.ContainsKey('Filters')){ $Filters } else { "vol,atr,st3,corr,news" }
  $on = @($fl -split ',' | ForEach-Object { $_.Trim().ToLower() } | Where-Object { $_ })
  $useVol=[int]($on -contains 'vol'); $useAtr=[int]($on -contains 'atr')
  $useSt3=[int]($on -contains 'st3'); $useCorr=[int]($on -contains 'corr'); $useNews=[int]($on -contains 'news')

  $Inputs = Set-Inp $Inputs "InpRangeMode"        "2"
  $Inputs = Set-Inp $Inputs "InpLevelTF"          "16408"     # D1 = giorno precedente
  $Inputs = Set-Inp $Inputs "InpRiskPercent"      "2.0"
  $Inputs = Set-Inp $Inputs "InpUseVolumeFilter"  "$useVol"
  $Inputs = Set-Inp $Inputs "InpUseAtrFilter"     "$useAtr"
  $Inputs = Set-Inp $Inputs "InpUseSupertrend3"   "$useSt3"
  $Inputs = Set-Inp $Inputs "InpStTF"             "16385"     # H1
  $Inputs = Set-Inp $Inputs "InpUseCorrelation"   "$useCorr"
  $Inputs = Set-Inp $Inputs "InpUseNewsFilter"    "$useNews"

  # --- parametri INERTI in questa configurazione: li INCHIODO ---
  #  (con InpRangeMode=2 il range in minuti non viene usato; se resta "Y" ereditato da una
  #   ottimizzazione precedente, MT5 lo spazzola comunque e moltiplica i pass a vuoto:
  #   e' successo il 02/08, 136 pass per 4 risultati veri)
  $Inputs = Set-Inp $Inputs "InpRangeMinutes"  "15"
  $Inputs = Set-Inp $Inputs "InpTrailFixedPts" "410"

  # --- griglia: SOLO parametri che mordono, e solo se il filtro relativo e' acceso ---
  $Inputs = Set-InpGrid $Inputs "InpBufferPoints" "100" "25" "25" "200"
  if($useVol){ $Inputs = Set-InpGrid $Inputs "InpVolMult" "1.5" "1.2" "0.3" "1.8" }
  else       { $Inputs = Set-Inp     $Inputs "InpVolMult" "1.5" }
  if($useAtr){ $Inputs = Set-InpGrid $Inputs "InpAtrFilterMult" "1.0" "0.8" "0.2" "1.2" }
  else       { $Inputs = Set-Inp     $Inputs "InpAtrFilterMult" "1.0" }
}

$mtag = if($Model -eq 4){"realtick"}else{"ohlc"}
$etag = if($EntryMode -eq 4){"delay"}elseif($EntryMode -eq 3){"fade"}elseif($EntryMode -eq 2){"retest"}else{"brk"}
if($Doc){
  $etag = "doc_$etag"
  # se sto facendo l'ablazione, il set di filtri finisce nel nome del CSV (niente collisioni)
  if($PSBoundParameters.ContainsKey('Filters')){
    $ftag = if($Filters.Trim()){ ($Filters -replace '[^a-zA-Z0-9]','') } else { "nofilt" }
    $etag = "${etag}_$ftag"
  }
}
if($RangeMin -gt 0){ $etag = "${etag}_orb$RangeMin" }
$EAtag="APERT_DAX_M5_${etag}_$mtag"
$Work= if($PSScriptRoot){$PSScriptRoot}else{(Get-Location).Path}; Set-Location $Work
Write-Host "=== CONFERMA APERTURA DAX (M5, Model $Model, $etag) su $($Symbols -join ', ') ===" -ForegroundColor Cyan
New-Item -ItemType Directory -Force -Path (Join-Path $Work "src_v2"),(Join-Path $Work "ini_apert") | Out-Null
try{Invoke-WebRequest -Uri "$RawBase/mql5/Experts/$EA.mq5" -OutFile (Join-Path $Work "src_v2\$EA.mq5") -UseBasicParsing; Write-Host "   OK src_v2\$EA.mq5" -ForegroundColor Green}
catch{Write-Host "   ERRORE download $EA" -ForegroundColor Red; exit 1}

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
$Results=Join-Path $Work "risultati_$EAtag"; New-Item -ItemType Directory -Force -Path $MqlExperts,$Results|Out-Null
if((Get-Process -Name "terminal64" -ErrorAction SilentlyContinue) -and -not $Force){Write-Host "!!! Chiudi MetaTrader prima (0 CSV altrimenti)." -ForegroundColor Red; exit 1}
Copy-Item (Join-Path $Work "src_v2\$EA.mq5") -Destination $MqlExperts -Force
& $MetaEditor "/compile:$(Join-Path $MqlExperts "$EA.mq5")" "/log" | Out-Null
if(-not (Test-Path (Join-Path $MqlExperts "$EA.ex5"))){Write-Host "ERRORE compilazione $EA" -ForegroundColor Red; exit 1}
Write-Host "   compilato $EA.ex5" -ForegroundColor Green

$n=0
foreach($sym in $Symbols){
  $n++
  $done=Join-Path $Results "apert_${EAtag}_$sym.csv"
  if(Test-Path $done){Write-Host ("   [{0}/{1}] {2}: gia' fatto, salto" -f $n,$Symbols.Count,$sym) -ForegroundColor DarkGray; continue}
  $iniPath=Join-Path $Work "ini_apert\apert_${EAtag}_$sym.ini"
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
Report=OptReport_${EAtag}_$sym

[TesterInputs]
$Inputs
"@ | Set-Content -Path $iniPath -Encoding ASCII
  $csv=Join-Path $MqlFiles "OptResults_${EA}_$sym.csv"; if(Test-Path $csv){Remove-Item $csv -Force}
  Write-Host ("   [{0}/{1}] {2} (M5 Model $Model)..." -f $n,$Symbols.Count,$sym) -ForegroundColor Cyan
  (Start-Process -FilePath $Terminal -ArgumentList "/config:`"$iniPath`"" -PassThru).WaitForExit()
  # il tester a volte lascia terminal64 appeso (es. simbolo senza storico) -> lo chiudo,
  # cosi' il test successivo (o lo script successivo) non si blocca su "Chiudi MetaTrader".
  for($__w=0;$__w -lt 20;$__w++){ if(-not (Get-Process -Name terminal64 -ErrorAction SilentlyContinue)){break}; Start-Sleep -Seconds 3 }
  Get-Process -Name terminal64 -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
  Start-Sleep -Seconds 2
  if(Test-Path $csv){
    # salvataggio ROBUSTO: la cartella dei risultati puo' non esserci piu' (sync/AV la
    # rimuovono se e' vuota) -> la ricreo qui. E se il salvataggio fallisce NON cancello
    # il CSV sorgente e NON abortisco: gli altri simboli devono comunque girare.
    try{
      if(-not (Test-Path $Results)){ New-Item -ItemType Directory -Force -Path $Results | Out-Null }
      Copy-Item $csv -Destination $done -Force
      Remove-Item $csv -Force
      Write-Host ("        OK -> apert_${EAtag}_$sym.csv") -ForegroundColor Green
    }catch{
      Write-Host ("        !! SALVATAGGIO FALLITO: {0}" -f $_.Exception.Message) -ForegroundColor Red
      Write-Host ("        Il CSV NON e' stato cancellato, lo trovi qui: {0}" -f $csv) -ForegroundColor Yellow
      Write-Host ("        (copialo a mano in {0} e mandamelo)" -f $Results) -ForegroundColor Yellow
    }
  }
  else{Write-Host ("        (no CSV: {0} senza storico/nome diverso? verifica)" -f $sym) -ForegroundColor Yellow}
}
Write-Host "`n=== FINITO === risultati in $Results" -ForegroundColor Cyan
Write-Host "Zippa risultati_$EAtag e caricamela: confronto STOP vs RETEST sul DAX." -ForegroundColor White
