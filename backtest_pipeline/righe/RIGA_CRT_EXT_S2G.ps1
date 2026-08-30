# =====================================================================
#  MARCATORE_RIGA_CRT_EXT_S2G_v1
#  RIGA_CRT_EXT_S2G.ps1  --  CRT STAGE-2 GATED: la cella vincente ADX<=30
#  letta PER REGIME. Cella FISSA (wick 2.0, mid 0, side 2) + GATE ON
#  (ADX(D1)<=30, ATR neutro), UNICO asse Y = InpMagic sui gemelli
#  (769103/769104), Modello 1 OHLC NASUSD_EXT M15 2020-2024. Raccoglie i 2
#  per-trade CSV per segmentarli (crollo 2020 / toro 2021 / orso 2022 / 2023).
# ---------------------------------------------------------------------
#  La domanda: il gate ha reso ~FLAT crollo 2020 e toro 2021 (ADX alto),
#  tenendo il verde del chop? Se si' -> chop-gate CONFERMATO.
#  Pattern INVES (gemelli) + verifica dei parametri del GATE (acceso, ADX=30).
#  OHLC INGANNA (ottimista). FUSO NY: flat RTH 16:00 NY.
#
#  LA RIGA CHE SI INCOLLA sta in righe\RIGA_CRT_EXT_S2G_DA_MANDARE.md
# =====================================================================
[CmdletBinding()]
param(
  [string]$Pin          = "",
  [switch]$SoloControllo,
  [string]$Simbolo      = "NASUSD_EXT",
  [string]$Periodo      = "M15",
  [string]$DaQuando     = "2020.01.01",
  [string]$Fino         = "2024.01.01",
  [int]$Deposito        = 100000
)
$ErrorActionPreference = "Stop"
[Threading.Thread]::CurrentThread.CurrentCulture   = [Globalization.CultureInfo]::InvariantCulture
[Threading.Thread]::CurrentThread.CurrentUICulture = [Globalization.CultureInfo]::InvariantCulture
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$INV = [Globalization.CultureInfo]::InvariantCulture

$EA        = "ABTG_CRT_TurtleSoup"
$Avvio     = Get-Date
$Stamp     = $Avvio.ToString("yyyyMMdd_HHmm", $INV)
$Dsk       = Join-Path $env:USERPROFILE "Desktop"
$Work      = Join-Path $env:USERPROFILE "abtg_crt_ext_s2g"
$Prove     = Join-Path $Work "prove"
$ProvaNome = $EA + "_EXT_S2G.txt"
$RawPin    = "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$Pin"

$Problemi  = New-Object System.Collections.ArrayList
$Rilievi   = New-Object System.Collections.ArrayList
$Fatale    = ""
$Terminale = "n/d"
$Compilato = "NON TENTATA"
$Simbolo_ok= "NON VERIFICATO"
$PerTrade_ok = "NON TROVATO"
$Modo      = "CORSA"
if($SoloControllo){ $Modo = "CONTROLLO" }

# la cella vincente: i 3 assi del motore fissi + il GATE acceso a ADX<=30.
$FissiAttesi = @{ "InpWickFactor"="2.0"; "InpUseMidGate"="0"; "InpSide"="2";
                  "InpUseRegimeGate"="true"; "InpRegimeTF"="16408";
                  "InpAdxMax"="30.0"; "InpAtrMinPts"="100.0" }
# i gemelli sul magic: l'UNICO asse Y. Vergini (769103/769104).
$MagicGemelli = @(769103,769104)

function Ora(){ return (Get-Date).ToString("HH:mm:ss", $INV) }
function Dico([string]$t,[string]$c="Gray"){ Write-Host ("[" + (Ora) + "] " + $t) -ForegroundColor $c }
function Titolo([string]$t){ Write-Host ""; Write-Host ("=== " + $t + " ===") -ForegroundColor Cyan }

function Scarica([string]$url,[string]$dest){
  Remove-Item -LiteralPath $dest -Force -ErrorAction SilentlyContinue
  Invoke-WebRequest -Uri $url -OutFile $dest -UseBasicParsing -ErrorAction Stop
  if(-not (Test-Path -LiteralPath $dest)){ throw ("scarico fallito: " + $url) }
}

function RigheVive([string]$p){
  return @(Get-Content -LiteralPath $p | Where-Object { $_ -notmatch '^\s*#' -and $_ -notmatch '^\s*$' })
}

function CommonFilesDir(){ return (Join-Path $env:APPDATA "MetaQuotes\Terminal\Common\Files") }
function PerTradeNome([int]$magic){ return ("abtg_trades_" + $EA + "_" + $Simbolo + "_" + $magic + ".csv") }

try{
  Titolo ("CRT STAGE-2 GATED per REGIME (" + $EA + ") -- modo " + $Modo)

  if($Pin -eq ""){ throw "-Pin obbligatorio: senza, girerebbe la punta del branch spacciandola per un commit congelato." }
  if($Pin -notmatch '^[0-9a-f]{40}$'){ throw ("-Pin deve essere un commit di 40 caratteri esadecimali, ricevuto: " + $Pin) }
  if(Get-Process terminal64,metaeditor64 -ErrorAction SilentlyContinue){
    throw "MT5 O METAEDITOR APERTO: col terminale aperto il tester non gira (zero CSV), con MetaEditor aperto la compilazione torna subito senza compilare."
  }

  Dico ("pin ......... " + $Pin)
  Dico ("simbolo ..... " + $Simbolo + " " + $Periodo + " (feed _EXT a ora NEW YORK: flat 16:00 NY)")
  Dico ("cella ....... wick 2.0, mid 0, side 2 | GATE ON ADX(D1)<=30 | gemelli 769103/769104")
  Dico ("finestra .... " + $DaQuando + " -> " + $Fino + " (crollo 2020 + toro 2021 + orso 2022 + 2023)")
  Dico ("banco ....... MODELLO 1 (OHLC) -- SCREENING. Deposito " + $Deposito)

  Titolo "1. SCARICO AL PIN"
  New-Item -ItemType Directory -Force -Path $Work,$Prove | Out-Null

  $drv = Join-Path $Work "walkforward_generico.ps1"
  Scarica ($RawPin + "/backtest_pipeline/walkforward_generico.ps1") $drv
  $t = Get-Content -LiteralPath $drv -Raw
  if($t -notmatch '\$EABranch\s*=\s*"lavoro"'){ throw "walkforward_generico.ps1 non ha la riga \$EABranch attesa: non lo posso pinnare." }
  $t = $t -replace '\$EABranch\s*=\s*"lavoro"', ('$EABranch="' + $Pin + '"')
  Set-Content -LiteralPath $drv -Value $t -Encoding ASCII
  Dico "driver generico scaricato e PINNATO" "Green"

  $fProva = Join-Path $Prove $ProvaNome
  Scarica ($RawPin + "/backtest_pipeline/prove/" + $ProvaNome) $fProva
  Dico ("prova scaricato: " + $ProvaNome) "Green"

  Titolo "2. GATE SUL PROVA (cella vincente + gate ADX<=30 + gemelli)"
  $righe = RigheVive $fProva
  $h = @{}
  $assiY = New-Object System.Collections.ArrayList
  foreach($r in $righe){
    if($r -match '^@'){
      $parti = ($r -split '\s+',2)
      $h[$parti[0]] = $parti[1].Trim()
      continue
    }
    $i = $r.IndexOf("=")
    if($i -lt 0){ continue }
    $nome = $r.Substring(0,$i).Trim()
    $val  = $r.Substring($i+1).Trim()
    if($h.ContainsKey($nome)){ throw ($ProvaNome + ": DUE righe per '" + $nome + "'.") }
    $h[$nome] = $val
    if($val -match '\|\|Y\s*$'){ [void]$assiY.Add($nome) }
  }

  if($h["@SIMBOLO"]  -ne $Simbolo){  throw ($ProvaNome + ": @SIMBOLO e' " + $h["@SIMBOLO"] + ", atteso " + $Simbolo) }
  if($h["@PERIODO"]  -ne $Periodo){  throw ($ProvaNome + ": @PERIODO e' " + $h["@PERIODO"] + ", atteso " + $Periodo) }
  if($h["@DAQUANDO"] -ne $DaQuando){ throw ($ProvaNome + ": @DAQUANDO e' " + $h["@DAQUANDO"] + ", atteso " + $DaQuando) }
  if($h["@FINOA"]    -ne $Fino){     throw ($ProvaNome + ": @FINOA e' " + $h["@FINOA"] + ", atteso " + $Fino) }

  # GATE: l'UNICO asse Y deve essere InpMagic (i gemelli).
  if(@($assiY).Count -ne 1){ throw ($ProvaNome + ": deve avere ESATTAMENTE un asse Y (InpMagic). Trovati: " + @($assiY).Count + " {" + (@($assiY) -join ", ") + "}.") }
  if($assiY[0] -ne "InpMagic"){ throw ($ProvaNome + ": l'unico asse Y deve essere InpMagic, invece e' " + $assiY[0] + ".") }

  # GATE DELLA CELLA VINCENTE + PARAMETRI DEL GATE DI REGIME (acceso, ADX=30, D1).
  foreach($k in @($FissiAttesi.Keys)){
    $v = ($h[$k] -split '\|\|')[0]
    if($v -ne $FissiAttesi[$k]){ throw ($ProvaNome + ": " + $k + " e' '" + $v + "', atteso '" + $FissiAttesi[$k] + "' (cella vincente / gate ADX<=30 acceso su D1).") }
  }

  # GATE DEI GEMELLI: 769103/769104, vergini.
  $mg = $h["InpMagic"] -split '\|\|'
  if($mg.Count -lt 4){ throw ($ProvaNome + ": InpMagic non ha il formato default||start||step||stop||Y.") }
  $gm = @([int]$mg[1], [int]$mg[3])
  if(($gm | Sort-Object | Out-String) -ne (($MagicGemelli | Sort-Object) | Out-String)){
    throw ($ProvaNome + ": i gemelli magic sono " + ($gm -join "/") + ", attesi " + ($MagicGemelli -join "/") + ".")
  }

  # GATE PAVIMENTO SL (R109) e FUSO NY (flat 16).
  $mfloor = ($h["InpMinStopPts"] -split '\|\|')[0]
  if($mfloor -ne "500"){ throw ($ProvaNome + ": InpMinStopPts deve essere 500 (R109), trovato '" + $mfloor + "'.") }
  $ch = ($h["InpCloseHour"] -split '\|\|')[0]
  $cm = ($h["InpCloseMin"]  -split '\|\|')[0]
  if($ch -eq "21"){ throw ($ProvaNome + ": InpCloseHour=21 e' ora SERVER. Su _EXT il flat RTH e' 16:00 NY.") }
  if($ch -ne "16"){ throw ($ProvaNome + ": InpCloseHour deve essere 16 (flat 16:00 NY sul feed _EXT), trovato '" + $ch + "'.") }
  if($cm -ne "0"){  throw ($ProvaNome + ": InpCloseMin deve essere 0, trovato '" + $cm + "'.") }

  Dico "geometria _EXT, 1 asse Y = InpMagic (gemelli 769103/769104), cella vincente + GATE ADX<=30 (D1), pavimento SL, FUSO NY (16): TUTTI PASSATI" "Green"

  Titolo "3. TERMINALE, SIMBOLO CUSTOM, COMPILAZIONE"
  $allTerm = @(Get-ChildItem "C:\Program Files","C:\Program Files (x86)" -Recurse -Filter "terminal64.exe" -ErrorAction SilentlyContinue)
  $cand = $allTerm | Where-Object { $_.DirectoryName -like "*BCM Markets MT5 Terminal*" -and $_.DirectoryName -notlike "*-V3*" } | Select-Object -First 1
  if(-not $cand){ $cand = $allTerm | Where-Object { $_.DirectoryName -like "*BCM Markets*" } | Select-Object -First 1 }
  if(-not $cand){ throw "terminale BCM non trovato." }
  $instDir    = $cand.DirectoryName
  $MetaEditor = Join-Path $instDir "metaeditor64.exe"
  $termRoot   = Join-Path $env:APPDATA "MetaQuotes\Terminal"
  $dataFolder = (Get-ChildItem $termRoot -Directory -ErrorAction SilentlyContinue | Where-Object { $o = Join-Path $_.FullName "origin.txt"; (Test-Path $o) -and ((Get-Content $o -Raw).Trim() -ieq $instDir) } | Select-Object -First 1 -ExpandProperty FullName)
  if(-not $dataFolder){ throw ("cartella dati non trovata per " + $instDir) }
  $Terminale = $instDir
  Dico ("terminale scelto: " + $instDir) "Yellow"

  $cartellaSimbolo = Join-Path $dataFolder ("bases\Custom\history\" + $Simbolo)
  if(-not (Test-Path -LiteralPath $cartellaSimbolo)){
    throw ($Simbolo + " non trovato: e' storico ESTERNO, va importato PRIMA. Cercato in: " + $cartellaSimbolo)
  }
  $Simbolo_ok = "TROVATO"
  Dico ("simbolo custom: " + $Simbolo + " " + $Simbolo_ok) "Green"

  $mq5 = Join-Path $Work ($EA + ".mq5")
  Scarica ($RawPin + "/mql5/Experts/" + $EA + ".mq5") $mq5
  $dstExp = Join-Path $dataFolder "MQL5\Experts"
  New-Item -ItemType Directory -Force -Path $dstExp | Out-Null
  $dstMq5 = Join-Path $dstExp ($EA + ".mq5")
  Copy-Item $mq5 -Destination $dstMq5 -Force
  $ex5 = Join-Path $dstExp ($EA + ".ex5")
  Remove-Item -LiteralPath $ex5 -Force -ErrorAction SilentlyContinue
  $t0 = Get-Date
  & $MetaEditor ("/compile:" + $dstMq5) "/log" | Out-Null
  while((-not (Test-Path -LiteralPath $ex5)) -and ((New-TimeSpan -Start $t0 -End (Get-Date)).TotalSeconds -lt 180)){ Start-Sleep -Seconds 2 }
  if(-not (Test-Path -LiteralPath $ex5)){
    $logC = Join-Path $dstExp ($EA + ".log")
    if(Test-Path -LiteralPath $logC){
      Copy-Item $logC -Destination (Join-Path $Work "COMPILAZIONE_FALLITA.log") -Force
      Get-Content -LiteralPath $logC -Tail 40 | ForEach-Object { Write-Host $_ -ForegroundColor Red }
    }
    throw ("COMPILAZIONE FALLITA: " + $EA + " non ha prodotto l'.ex5.")
  }
  $Compilato = "OK (" + [int]((Get-Item -LiteralPath $ex5).Length/1024) + " KB, " + (Get-Item -LiteralPath $ex5).LastWriteTime.ToString("HH:mm:ss",$INV) + ")"
  Dico ("compilato " + $EA + ": " + $Compilato) "Green"

  $commonFiles = CommonFilesDir
  foreach($m in $MagicGemelli){
    $pt = Join-Path $commonFiles (PerTradeNome $m)
    Remove-Item -LiteralPath $pt -Force -ErrorAction SilentlyContinue
  }
  Dico "per-trade CSV vecchi cancellati (769103/769104, se c'erano)" "Gray"

  if($SoloControllo){
    Dico "SoloControllo: compilazione e gate OK, NON apro MT5. La corsa vera e' la seconda riga." "Green"
  }
  else{
    Titolo "4. LA CORSA (generico, gemelli, Modello 1, FrazioneIS 1.0)"
    $argv = @("-ExecutionPolicy","Bypass","-File",$drv,
              "-Expert",$EA,
              "-Prova",$fProva,
              "-Simbolo",$Simbolo,
              "-Periodo",$Periodo,
              "-DaQuando",$DaQuando,
              "-Fino",$Fino,
              "-FrazioneIS","1.0",
              "-Modello","1",
              "-Deposito",("" + $Deposito))
    $global:LASTEXITCODE = 0
    & powershell $argv
    $rc = $LASTEXITCODE
    if($rc -ne 0){
      [void]$Problemi.Add("il generico e' uscito con codice " + $rc + ".")
    }
    $trovati = 0
    foreach($m in $MagicGemelli){
      $pt = Join-Path $commonFiles (PerTradeNome $m)
      if(Test-Path -LiteralPath $pt){ $trovati++ }
    }
    if($trovati -gt 0){ $PerTrade_ok = "TROVATI " + $trovati + " su 2 (gemelli 769103/769104)" }
    else{ [void]$Problemi.Add("nessun per-trade CSV prodotto in Common\Files per i gemelli (zero trade? FILE_COMMON non scritto?).") }
  }
}
catch{
  $Fatale = ("" + $_.Exception.Message)
  Write-Host ""
  Write-Host ("!!! FERMATO: " + $Fatale) -ForegroundColor Red
}

Titolo "RACCOLTA"
$Cart = Join-Path $Dsk ("CRT_EXT_S2G_" + $Modo + "_" + $Stamp)
New-Item -ItemType Directory -Force -Path $Cart | Out-Null

$RefTxt = New-Object System.Collections.ArrayList
[void]$RefTxt.Add("=====================================================================")
[void]$RefTxt.Add(" CRT STAGE-2 GATED (ADX<=30) per REGIME su " + $Simbolo + " " + $Periodo)
[void]$RefTxt.Add("=====================================================================")
[void]$RefTxt.Add("modo: " + $Modo + "   <- CONTROLLO = giro a vuoto, NON e' il risultato")
[void]$RefTxt.Add("data: " + $Avvio.ToString("yyyy-MM-dd HH:mm:ss",$INV))
[void]$RefTxt.Add("pin:  " + $Pin)
[void]$RefTxt.Add("cella: wick 2.0, mid 0, side 2 | GATE ON ADX(D1)<=30, ATR neutro 100 | gemelli 769103/769104")
[void]$RefTxt.Add("riferimento gated (griglia): +10135, n=201, PF 1.65, DD 2.60% sul totale 2020-2024")
[void]$RefTxt.Add("finestra: " + $DaQuando + " -> " + $Fino + "  (crollo 2020 + toro 2021 + orso 2022 + 2023)")
[void]$RefTxt.Add("banco: MODELLO 1 (OHLC) -- SCREENING OTTIMISTA. Deposito " + $Deposito)
[void]$RefTxt.Add("fuso: feed _EXT a ora NEW YORK -> flat RTH 16:00 NY.")
[void]$RefTxt.Add("terminale: " + $Terminale)
[void]$RefTxt.Add("simbolo custom: " + $Simbolo_ok)
[void]$RefTxt.Add("compilazione: " + $Compilato)
[void]$RefTxt.Add("per-trade CSV: " + $PerTrade_ok)
[void]$RefTxt.Add("")
[void]$RefTxt.Add("LA DOMANDA: il gate ha reso ~FLAT crollo 2020 e toro 2021 (ADX alto)")
[void]$RefTxt.Add("tenendo il verde del chop? Si legge un per-trade CSV (gemelli identici)")
[void]$RefTxt.Add("segmentato per regime (close_time / net_profit):")
[void]$RefTxt.Add("  - CROLLO 2020 (feb-apr): deve avere POCHI o ZERO trade (gate blocca ADX alto)")
[void]$RefTxt.Add("  - TORO 2021: deve avere POCHI trade / ~flat")
[void]$RefTxt.Add("  - ORSO 2022 + 2023 (chop): il VERDE deve restare qui.")
[void]$RefTxt.Add("Se crollo/toro sono ~flat e il chop resta verde -> CHOP-GATE CONFERMATO.")
[void]$RefTxt.Add("")
if($Fatale -ne ""){ [void]$RefTxt.Add("!!! FERMATO: " + $Fatale); [void]$RefTxt.Add("") }
[void]$RefTxt.Add("PROBLEMI: " + $Problemi.Count)
foreach($p in $Problemi){ [void]$RefTxt.Add("  - " + $p) }
[void]$RefTxt.Add("RILIEVI: " + $Rilievi.Count)
foreach($p in $Rilievi){ [void]$RefTxt.Add("  - " + $p) }
[void]$RefTxt.Add("")
[void]$RefTxt.Add('COME SI RIPRENDE: dalla pagina righe/RIGA_CRT_EXT_S2G_DA_MANDARE.md.')

$refPath = Join-Path $Cart "REFERTO_CRT_EXT_S2G.txt"
Set-Content -LiteralPath $refPath -Value ($RefTxt -join "`r`n") -Encoding ASCII
Write-Host ($RefTxt -join "`r`n")

foreach($f in @("COMPILAZIONE_FALLITA.log")){
  $src = Join-Path $Work $f
  if(Test-Path -LiteralPath $src){ Copy-Item $src -Destination $Cart -Force }
}
$srcProva = Join-Path $Prove $ProvaNome
if(Test-Path -LiteralPath $srcProva){ Copy-Item $srcProva -Destination $Cart -Force }
$commonFiles2 = CommonFilesDir
foreach($m in $MagicGemelli){
  $pt = Join-Path $commonFiles2 (PerTradeNome $m)
  if(Test-Path -LiteralPath $pt){ Copy-Item $pt -Destination $Cart -Force }
}
$Results = Join-Path $Work ("risultati_prove\" + $EA)
foreach($leg in @("IS","OOS")){
  $f = Join-Path $Results ($EA + "_" + $Simbolo + "_" + $leg + "_ohlc.csv")
  if(Test-Path -LiteralPath $f){ Copy-Item $f -Destination $Cart -Force }
}
$zip = $Cart + ".zip"
Remove-Item -LiteralPath $zip -Force -ErrorAction SilentlyContinue
Compress-Archive -Path (Join-Path $Cart "*") -DestinationPath $zip -Force
Write-Host ""
Write-Host ("CARTELLA: " + $Cart) -ForegroundColor Green
Write-Host ("ZIP DA MANDARE: " + $zip) -ForegroundColor Green
Write-Host "FILE ATTESI NELLO ZIP: REFERTO_CRT_EXT_S2G.txt + il prova + i per-trade CSV (abtg_trades_..._769103/769104.csv) + la griglia gemelli" -ForegroundColor Gray

if($Fatale -ne ""){ Write-Host "ESITO: FERMATO" -ForegroundColor Red; exit 1 }
if($Problemi.Count -gt 0){ Write-Host "ESITO: COMPLETATO CON PROBLEMI" -ForegroundColor Yellow; exit 1 }
Write-Host ("ESITO: " + $Modo + " COMPLETATO") -ForegroundColor Green
exit 0
