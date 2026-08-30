# =====================================================================
#  MARCATORE_RIGA_CRT_TICK_G_v1
#  RIGA_CRT_TICK_G.ps1  --  CRT GATED TICK BCM: il verdetto vero nel toro.
#  Cella vincente (wick 2.0, mid 0, side 2) + GATE ON ADX(D1)<=30, a TICK
#  REALI (Modello 4) su NASUSD BCM M15, 2024.09.26->2026.06.30. Unico asse Y
#  = InpMagic gemelli (769105/769106). E' un VERDETTO (tick), non OHLC.
# ---------------------------------------------------------------------
#  L'ungated a tick nel toro era PF 0.5 (morto). Il gate taglia i trend-trade:
#  qui si misura se porta il tick a PF>=1 NEL REGIME ATTUALE. Se verde ->
#  edge tick-verificato -> deployabile ora, senza Dukascopy.
#
#  >>> IL FUSO E' QUELLO DI CASA (NON invertito): NASUSD BCM = ora SERVER.
#      FLAT RTH = 21:00 SERVER (16:00 ET). Il gate PRETENDE 21 e RIFIUTA 16
#      (il 16 e' l'ora NY del feed _EXT, un altro round). E' l'OPPOSTO dei
#      round _EXT.
#  >>> NASUSD e' NATIVO BCM (non custom): niente import, il tester lo risolve.
#  >>> 21 mesi = UN SOLO REGIME (toro): merito sospeso se n<150, rischio sempre.
#
#  LA RIGA CHE SI INCOLLA sta in righe\RIGA_CRT_TICK_G_DA_MANDARE.md
# =====================================================================
[CmdletBinding()]
param(
  [string]$Pin          = "",
  [switch]$SoloControllo,
  [string]$Simbolo      = "NASUSD",
  [string]$Periodo      = "M15",
  [string]$DaQuando     = "2024.09.26",
  [string]$Fino         = "2026.06.30",
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
$Work      = Join-Path $env:USERPROFILE "abtg_crt_tick_g"
$Prove     = Join-Path $Work "prove"
$ProvaNome = $EA + "_TICK_G.txt"
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

# la cella vincente + il GATE acceso a ADX<=30. NB: InpCloseHour=21 (SERVER BCM).
$FissiAttesi = @{ "InpWickFactor"="2.0"; "InpUseMidGate"="0"; "InpSide"="2";
                  "InpUseRegimeGate"="true"; "InpRegimeTF"="16408";
                  "InpAdxMax"="30.0"; "InpAtrMinPts"="0.0" }
# i gemelli sul magic: l'UNICO asse Y. Vergini (769105/769106).
$MagicGemelli = @(769105,769106)

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
  Titolo ("CRT GATED TICK BCM -- verdetto nel toro (" + $EA + ") -- modo " + $Modo)

  if($Pin -eq ""){ throw "-Pin obbligatorio: senza, girerebbe la punta del branch spacciandola per un commit congelato." }
  if($Pin -notmatch '^[0-9a-f]{40}$'){ throw ("-Pin deve essere un commit di 40 caratteri esadecimali, ricevuto: " + $Pin) }
  if(Get-Process terminal64,metaeditor64 -ErrorAction SilentlyContinue){
    throw "MT5 O METAEDITOR APERTO: col terminale aperto il tester non gira (zero CSV), con MetaEditor aperto la compilazione torna subito senza compilare."
  }

  Dico ("pin ......... " + $Pin)
  Dico ("simbolo ..... " + $Simbolo + " " + $Periodo + " (NATIVO BCM, ora SERVER: flat RTH 21:00 server)")
  Dico ("cella ....... wick 2.0, mid 0, side 2 | GATE ON ADX(D1)<=30 | gemelli 769105/769106")
  Dico ("finestra .... " + $DaQuando + " -> " + $Fino + " (tick BCM, UN SOLO REGIME toro)")
  Dico ("banco ....... MODELLO 4 (TICK REALI) -- VERDETTO. Deposito " + $Deposito)

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

  Titolo "2. GATE SUL PROVA (cella vincente + gate ADX<=30 + gemelli, TICK BCM)"
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

  if(@($assiY).Count -ne 1){ throw ($ProvaNome + ": deve avere ESATTAMENTE un asse Y (InpMagic). Trovati: " + @($assiY).Count + " {" + (@($assiY) -join ", ") + "}.") }
  if($assiY[0] -ne "InpMagic"){ throw ($ProvaNome + ": l'unico asse Y deve essere InpMagic, invece e' " + $assiY[0] + ".") }

  foreach($k in @($FissiAttesi.Keys)){
    $v = ($h[$k] -split '\|\|')[0]
    if($v -ne $FissiAttesi[$k]){ throw ($ProvaNome + ": " + $k + " e' '" + $v + "', atteso '" + $FissiAttesi[$k] + "' (cella vincente / gate ADX<=30 acceso su D1).") }
  }

  $mg = $h["InpMagic"] -split '\|\|'
  if($mg.Count -lt 4){ throw ($ProvaNome + ": InpMagic non ha il formato default||start||step||stop||Y.") }
  $gm = @([int]$mg[1], [int]$mg[3])
  if(($gm | Sort-Object | Out-String) -ne (($MagicGemelli | Sort-Object) | Out-String)){
    throw ($ProvaNome + ": i gemelli magic sono " + ($gm -join "/") + ", attesi " + ($MagicGemelli -join "/") + ".")
  }

  $mfloor = ($h["InpMinStopPts"] -split '\|\|')[0]
  if($mfloor -ne "500"){ throw ($ProvaNome + ": InpMinStopPts deve essere 500 (R109), trovato '" + $mfloor + "'.") }

  # GATE DEL FUSO -- QUELLO DI CASA (NON invertito): NASUSD BCM = ora server.
  # Il flat RTH e' 21:00 SERVER. Il 16 e' l'ora NY del feed _EXT (altro round):
  # qui il gate lo RIFIUTA e PRETENDE 21.
  $ch = ($h["InpCloseHour"] -split '\|\|')[0]
  $cm = ($h["InpCloseMin"]  -split '\|\|')[0]
  if($ch -eq "16"){ throw ($ProvaNome + ": InpCloseHour=16 e' l'ora NY del feed _EXT. Su NASUSD BCM (ora server) il flat RTH e' 21:00. Qui va 21, non 16.") }
  if($ch -ne "21"){ throw ($ProvaNome + ": InpCloseHour deve essere 21 (flat RTH 21:00 server su NASUSD BCM), trovato '" + $ch + "'.") }
  if($cm -ne "0"){  throw ($ProvaNome + ": InpCloseMin deve essere 0, trovato '" + $cm + "'.") }

  Dico "geometria BCM, 1 asse Y = InpMagic (gemelli 769105/769106), cella vincente + GATE ADX<=30 (D1), pavimento SL, FUSO SERVER (flat 21): TUTTI PASSATI" "Green"

  Titolo "3. TERMINALE E COMPILAZIONE (NASUSD nativo BCM)"
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
  $Simbolo_ok = "NASUSD (nativo BCM: il tester lo risolve dal server)"

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
  Dico "per-trade CSV vecchi cancellati (769105/769106, se c'erano)" "Gray"

  if($SoloControllo){
    Dico "SoloControllo: compilazione e gate OK, NON apro MT5. La corsa vera e' la seconda riga." "Green"
  }
  else{
    Titolo "4. LA CORSA (generico, gemelli, Modello 4 TICK, FrazioneIS 1.0)"
    $argv = @("-ExecutionPolicy","Bypass","-File",$drv,
              "-Expert",$EA,
              "-Prova",$fProva,
              "-Simbolo",$Simbolo,
              "-Periodo",$Periodo,
              "-DaQuando",$DaQuando,
              "-Fino",$Fino,
              "-FrazioneIS","1.0",
              "-Modello","4",
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
    if($trovati -gt 0){ $PerTrade_ok = "TROVATI " + $trovati + " su 2 (gemelli 769105/769106)" }
    else{ [void]$Problemi.Add("nessun per-trade CSV prodotto in Common\Files per i gemelli (zero trade? FILE_COMMON non scritto?).") }
  }
}
catch{
  $Fatale = ("" + $_.Exception.Message)
  Write-Host ""
  Write-Host ("!!! FERMATO: " + $Fatale) -ForegroundColor Red
}

Titolo "RACCOLTA"
$Cart = Join-Path $Dsk ("CRT_TICK_G_" + $Modo + "_" + $Stamp)
New-Item -ItemType Directory -Force -Path $Cart | Out-Null

$RefTxt = New-Object System.Collections.ArrayList
[void]$RefTxt.Add("=====================================================================")
[void]$RefTxt.Add(" CRT GATED TICK BCM (ADX<=30) -- verdetto nel toro su " + $Simbolo + " " + $Periodo)
[void]$RefTxt.Add("=====================================================================")
[void]$RefTxt.Add("modo: " + $Modo + "   <- CONTROLLO = giro a vuoto, NON e' il risultato")
[void]$RefTxt.Add("data: " + $Avvio.ToString("yyyy-MM-dd HH:mm:ss",$INV))
[void]$RefTxt.Add("pin:  " + $Pin)
[void]$RefTxt.Add("cella: wick 2.0, mid 0, side 2 | GATE ON ADX(D1)<=30, ATR OFF (ADX-only) | gemelli 769105/769106")
[void]$RefTxt.Add("finestra: " + $DaQuando + " -> " + $Fino + "  (tick BCM, UN SOLO REGIME toro)")
[void]$RefTxt.Add("banco: MODELLO 4 (TICK REALI) -- VERDETTO. Deposito " + $Deposito)
[void]$RefTxt.Add("fuso: NASUSD BCM = ora SERVER -> flat RTH 21:00 server (NON 16 NY).")
[void]$RefTxt.Add("terminale: " + $Terminale)
[void]$RefTxt.Add("simbolo: " + $Simbolo_ok)
[void]$RefTxt.Add("compilazione: " + $Compilato)
[void]$RefTxt.Add("per-trade CSV: " + $PerTrade_ok)
[void]$RefTxt.Add("")
[void]$RefTxt.Add("RIFERIMENTO: l'UNGATED a tick nel toro era PF 0.5 (morto, 0/30 celle).")
[void]$RefTxt.Add("LA DOMANDA: il gate porta il tick a PF >= 1 nel toro attuale?")
[void]$RefTxt.Add("  - Si legge la griglia (2 gemelli identici): PF, DD%, Profit, n,")
[void]$RefTxt.Add("    peggior giornata. E il per-trade CSV per la concentrazione.")
[void]$RefTxt.Add("  - VERDE (PF>=1, DD sotto muro, pegg.gio sotto 5%) -> edge TICK")
[void]$RefTxt.Add("    verificato nel regime attuale -> DEPLOYABILE piccolo, senza Dukascopy.")
[void]$RefTxt.Add("  - ROSSO -> il gate migliora ma non basta a tick nel toro: resta un")
[void]$RefTxt.Add("    motore da chop, verdetto solo con Dukascopy nel suo regime.")
[void]$RefTxt.Add("  - 21 mesi = UN REGIME: merito sospeso se n<150 (R59), rischio sempre.")
[void]$RefTxt.Add("")
if($Fatale -ne ""){ [void]$RefTxt.Add("!!! FERMATO: " + $Fatale); [void]$RefTxt.Add("") }
[void]$RefTxt.Add("PROBLEMI: " + $Problemi.Count)
foreach($p in $Problemi){ [void]$RefTxt.Add("  - " + $p) }
[void]$RefTxt.Add("RILIEVI: " + $Rilievi.Count)
foreach($p in $Rilievi){ [void]$RefTxt.Add("  - " + $p) }
[void]$RefTxt.Add("")
[void]$RefTxt.Add('COME SI RIPRENDE: dalla pagina righe/RIGA_CRT_TICK_G_DA_MANDARE.md.')

$refPath = Join-Path $Cart "REFERTO_CRT_TICK_G.txt"
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
# griglia gemelli: Modello 4 -> suffisso "" (NON _ohlc).
$Results = Join-Path $Work ("risultati_prove\" + $EA)
foreach($leg in @("IS","OOS")){
  $f = Join-Path $Results ($EA + "_" + $Simbolo + "_" + $leg + ".csv")
  if(Test-Path -LiteralPath $f){ Copy-Item $f -Destination $Cart -Force }
}
$zip = $Cart + ".zip"
Remove-Item -LiteralPath $zip -Force -ErrorAction SilentlyContinue
Compress-Archive -Path (Join-Path $Cart "*") -DestinationPath $zip -Force
Write-Host ""
Write-Host ("CARTELLA: " + $Cart) -ForegroundColor Green
Write-Host ("ZIP DA MANDARE: " + $zip) -ForegroundColor Green
Write-Host "FILE ATTESI NELLO ZIP: REFERTO_CRT_TICK_G.txt + il prova + i per-trade CSV (abtg_trades_..._769105/769106.csv) + la griglia gemelli (IS, tick)" -ForegroundColor Gray

if($Fatale -ne ""){ Write-Host "ESITO: FERMATO" -ForegroundColor Red; exit 1 }
if($Problemi.Count -gt 0){ Write-Host "ESITO: COMPLETATO CON PROBLEMI" -ForegroundColor Yellow; exit 1 }
Write-Host ("ESITO: " + $Modo + " COMPLETATO") -ForegroundColor Green
exit 0
