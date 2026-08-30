# =====================================================================
#  MARCATORE_RIGA_CRT_EXT_v1
#  RIGA_CRT_EXT.ps1  --  CRT TURTLE SOUP: TIEBREAKER DI REGIME.
#  Screening OHLC (Modello 1) su NASUSD_EXT M15, finestra 2020-2024
#  (crollo 2020 + toro 2021 + orso 2022 + 2023). Sweep 3 assi.
#  Nasce DOPO il verdetto tick NASUSD (0/30 celle verdi nel toro): la
#  domanda residua e' se il CRT vive nella TEMPESTA.
# ---------------------------------------------------------------------
#  QUESTO E' UNO SCREENING. NON PROMUOVE NIENTE E NON DA' UN VERDETTO.
#  Prova/criteri: backtest_pipeline\prove\ABTG_CRT_TurtleSoup_EXT.txt
#  Motore CRT Turtle Soup da Neo Malesa (n30dyn4m1c), licenza MIT.
#
#  >>> IL TETTO OHLC INGANNA (load-bearing): Modello 1 su barre M1 HistData
#      del feed _EXT, NON tick reali. Si legge la FORMA (verde/rosso,
#      coerenza fra regimi), MAI i numeri fini. E' gia' OTTIMISTA: se
#      anche l'OHLC e' rosso ovunque, il tick sarebbe peggio.
#
#  >>> IL FUSO E' INVERTITO (critico). Su NASUSD_EXT il feed e' a ora di
#      NEW YORK. Il FLAT RTH e' 16:00 NY -> InpCloseHour=16, NON 21 (ora
#      server BCM, che vale solo per la cella tick). Il gate PRETENDE 16.
#
#  >>> UNA SOLA TRANCHE (FrazioneIS 1.0): la finestra intera 2020-2024 e'
#      la gamba "IS" del generico; la "OOS" e' degenere e si ignora. La
#      lettura per REGIME si fa A MANO dal per-trade CSV in Common\Files.
#
#  PERCHE' ESISTE (come RIGA_CRT ma su _EXT/Modello 1):
#   1. IL PIN (driver + EA). 2. La COMPILAZIONE (l'EA ora ESISTE gia'
#      compilato dal round tick, ma qui si ricompila al pin per sicurezza).
#   3. I GATE sul prova (geometria _EXT, fuso NY 16, pavimento SL, 3 assi).
#   4. IL SIMBOLO CUSTOM: NASUSD_EXT e' storico ESTERNO -> si CONTROLLA che
#      sia importato (bases\Custom\history\NASUSD_EXT), come INVES. Se manca
#      ci si ferma con l'errore onesto: NON lo si costruisce qui.
#   5. LA RACCOLTA sul Desktop + zip.
#
#  LA RIGA CHE SI INCOLLA sta in righe\RIGA_CRT_EXT_DA_MANDARE.md
# =====================================================================
[CmdletBinding()]
param(
  [string]$Pin          = "",       # 40 hex OBBLIGATORIO
  [switch]$SoloControllo,           # giro a vuoto: compila + gate, NON apre MT5
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

$EA     = "ABTG_CRT_TurtleSoup"
$Avvio  = Get-Date
$Stamp  = $Avvio.ToString("yyyyMMdd_HHmm", $INV)
$Dsk    = Join-Path $env:USERPROFILE "Desktop"
$Work   = Join-Path $env:USERPROFILE "abtg_crt_ext"
$Prove  = Join-Path $Work "prove"
$ProvaNome = $EA + "_EXT.txt"
$RawPin = "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$Pin"

$Problemi  = New-Object System.Collections.ArrayList
$Rilievi   = New-Object System.Collections.ArrayList
$Fatale    = ""
$Terminale = "n/d"
$Compilato = "NON TENTATA"
$RiskEA    = "n/d"
$Simbolo_ok= "NON VERIFICATO"
$Modo      = "CORSA"
if($SoloControllo){ $Modo = "CONTROLLO" }

$AssiAttesi = @("InpWickFactor","InpUseMidGate","InpSide")

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

try{
  Titolo ("CRT TURTLE SOUP -- TIEBREAKER DI REGIME (" + $EA + " su _EXT) -- modo " + $Modo)

  # -------------------------------------------------------------------
  #  0. LE GUARDIE
  # -------------------------------------------------------------------
  if($Pin -eq ""){ throw "-Pin obbligatorio: senza, girerebbe la punta del branch spacciandola per un commit congelato." }
  if($Pin -notmatch '^[0-9a-f]{40}$'){ throw ("-Pin deve essere un commit di 40 caratteri esadecimali, ricevuto: " + $Pin) }
  if(Get-Process terminal64,metaeditor64 -ErrorAction SilentlyContinue){
    throw "MT5 O METAEDITOR APERTO: col terminale aperto il tester non gira (zero CSV), con MetaEditor aperto la compilazione torna subito senza compilare."
  }
  if($Periodo -ne "M15"){
    [void]$Rilievi.Add("PERIODO diverso da M15 (" + $Periodo + "): il prova dichiara @PERIODO M15 e il gate lo confronta.")
  }

  Dico ("pin ......... " + $Pin)
  Dico ("simbolo ..... " + $Simbolo + " " + $Periodo + " (feed _EXT a ora NEW YORK: flat RTH 16:00 NY, NON 21 server)")
  Dico ("finestra .... " + $DaQuando + " -> " + $Fino + " (crollo 2020 + toro 2021 + orso 2022 + 2023; FrazioneIS 1.0, una tranche)")
  Dico ("banco ....... MODELLO 1 (OHLC) -- SCREENING, non un verdetto. Deposito " + $Deposito)

  # -------------------------------------------------------------------
  #  1. SCARICO AL PIN
  # -------------------------------------------------------------------
  Titolo "1. SCARICO AL PIN"
  New-Item -ItemType Directory -Force -Path $Work,$Prove | Out-Null

  $drv = Join-Path $Work "walkforward_generico.ps1"
  Scarica ($RawPin + "/backtest_pipeline/walkforward_generico.ps1") $drv
  $t = Get-Content -LiteralPath $drv -Raw
  if($t -notmatch '\$EABranch\s*=\s*"lavoro"'){ throw "walkforward_generico.ps1 non ha la riga \$EABranch attesa: non lo posso pinnare." }
  $t = $t -replace '\$EABranch\s*=\s*"lavoro"', ('$EABranch="' + $Pin + '"')
  Set-Content -LiteralPath $drv -Value $t -Encoding ASCII
  Dico "driver generico scaricato e PINNATO (riscarica l'EA al pin, non dalla punta del branch)" "Green"

  $fProva = Join-Path $Prove $ProvaNome
  Scarica ($RawPin + "/backtest_pipeline/prove/" + $ProvaNome) $fProva
  Dico ("prova scaricato: " + $ProvaNome) "Green"

  # -------------------------------------------------------------------
  #  2. I GATE SUL PROVA
  # -------------------------------------------------------------------
  Titolo "2. GATE SUL PROVA"
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
    if($h.ContainsKey($nome)){ throw ($ProvaNome + ": DUE righe per '" + $nome + "'. In [TesterInputs] un parametro doppio fa fare a MT5 ZERO passate.") }
    $h[$nome] = $val
    if($val -match '\|\|Y\s*$'){ [void]$assiY.Add($nome) }
  }

  if($h["@SIMBOLO"]  -ne $Simbolo){  throw ($ProvaNome + ": @SIMBOLO e' " + $h["@SIMBOLO"] + ", atteso " + $Simbolo) }
  if($h["@PERIODO"]  -ne $Periodo){  throw ($ProvaNome + ": @PERIODO e' " + $h["@PERIODO"] + ", atteso " + $Periodo) }
  if($h["@DAQUANDO"] -ne $DaQuando){ throw ($ProvaNome + ": @DAQUANDO e' " + $h["@DAQUANDO"] + ", atteso " + $DaQuando) }
  if($h["@FINOA"]    -ne $Fino){     throw ($ProvaNome + ": @FINOA e' " + $h["@FINOA"] + ", atteso " + $Fino) }

  $assiOrd = @($assiY | Sort-Object)
  $attesiOrd = @($AssiAttesi | Sort-Object)
  if(($assiOrd -join ",") -ne ($attesiOrd -join ",")){
    throw ($ProvaNome + ": gli assi spazzolati sono {" + ($assiOrd -join ", ") + "}, attesi {" + ($attesiOrd -join ", ") + "}.")
  }

  foreach($ax in $AssiAttesi){
    $p = $h[$ax] -split '\|\|'
    if($p.Count -lt 4){ throw ($ProvaNome + ": l'asse " + $ax + " non ha il formato default||start||step||stop||Y.") }
    if($p[1] -eq $p[3]){ throw ($ProvaNome + ": l'asse " + $ax + " ha start==stop (" + $p[1] + "): sweep degenere, zero celle.") }
  }

  $mfloor = ($h["InpMinStopPts"] -split '\|\|')[0]
  if($mfloor -eq "0"){ throw ($ProvaNome + ": InpMinStopPts=0 VIETATO (R109): il pavimento SL e' 500, mai 0.") }
  if($mfloor -ne "500"){ throw ($ProvaNome + ": InpMinStopPts deve essere 500 (R109), trovato '" + $mfloor + "'.") }

  # GATE DEL FUSO INVERTITO: su _EXT il flat RTH e' 16:00 NY, NON 21 server.
  $ch = ($h["InpCloseHour"] -split '\|\|')[0]
  $cm = ($h["InpCloseMin"]  -split '\|\|')[0]
  if($ch -eq "21"){ throw ($ProvaNome + ": InpCloseHour=21 e' l'ora SERVER BCM. Su NASUSD_EXT il fuso e' NY: il flat RTH e' 16:00 NY. Il 21 vale SOLO per la cella tick BCM.") }
  if($ch -ne "16"){ throw ($ProvaNome + ": InpCloseHour deve essere 16 (flat RTH 16:00 NY sul feed _EXT), trovato '" + $ch + "'.") }
  if($cm -ne "0"){  throw ($ProvaNome + ": InpCloseMin deve essere 0 (flat 16:00 NY), trovato '" + $cm + "'.") }

  Dico "geometria _EXT, 3 assi, sweep non degenere, pavimento SL (R109), FUSO NY (flat 16): TUTTI PASSATI" "Green"

  # -------------------------------------------------------------------
  #  3. TERMINALE, SIMBOLO CUSTOM, COMPILAZIONE
  # -------------------------------------------------------------------
  Titolo "3. TERMINALE, SIMBOLO CUSTOM, COMPILAZIONE"
  $allTerm = @(Get-ChildItem "C:\Program Files","C:\Program Files (x86)" -Recurse -Filter "terminal64.exe" -ErrorAction SilentlyContinue)
  $cand = $allTerm | Where-Object { $_.DirectoryName -like "*BCM Markets MT5 Terminal*" -and $_.DirectoryName -notlike "*-V3*" } | Select-Object -First 1
  if(-not $cand){ $cand = $allTerm | Where-Object { $_.DirectoryName -like "*BCM Markets*" } | Select-Object -First 1 }
  if(-not $cand){ throw "terminale BCM non trovato: e' lo stesso selettore del generico." }
  $instDir    = $cand.DirectoryName
  $MetaEditor = Join-Path $instDir "metaeditor64.exe"
  $termRoot   = Join-Path $env:APPDATA "MetaQuotes\Terminal"
  $dataFolder = (Get-ChildItem $termRoot -Directory -ErrorAction SilentlyContinue | Where-Object { $o = Join-Path $_.FullName "origin.txt"; (Test-Path $o) -and ((Get-Content $o -Raw).Trim() -ieq $instDir) } | Select-Object -First 1 -ExpandProperty FullName)
  if(-not $dataFolder){ throw ("cartella dati non trovata per " + $instDir) }
  $Terminale = $instDir
  Dico ("terminale scelto: " + $instDir) "Yellow"

  # IL SIMBOLO CUSTOM (storico ESTERNO): il tester accetta NASUSD_EXT solo se
  # le barre sono state importate. Si CONTROLLA prima; se manca ci si ferma con
  # l'errore ONESTO (come INVES). NON lo si costruisce qui.
  $cartellaSimbolo = Join-Path $dataFolder ("bases\Custom\history\" + $Simbolo)
  if(-not (Test-Path -LiteralPath $cartellaSimbolo)){
    throw ($Simbolo + " non trovato: e' storico ESTERNO e va importato con la Riga dello storico esterno PRIMA di girare. Cercato in: " + $cartellaSimbolo)
  }
  $pesoSimbolo = ((Get-ChildItem -LiteralPath $cartellaSimbolo -Recurse -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum).Sum) / 1MB
  $Simbolo_ok = "TROVATO (" + $pesoSimbolo.ToString("0.0",$INV) + " MB in bases\Custom\history)"
  Dico ("simbolo custom: " + $Simbolo + " " + $Simbolo_ok + ". Se il tester dicesse 'symbol not exist' la REGISTRAZIONE e' persa: si riapre MT5 una volta a mano o si rifa' l'import.") "Green"

  # LA COMPILAZIONE (l'.ex5 vecchio si cancella prima).
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
    throw ("COMPILAZIONE FALLITA: " + $EA + " non ha prodotto l'.ex5. Gli errori sono qui sopra e in COMPILAZIONE_FALLITA.log dentro lo zip.")
  }
  $Compilato = "OK (" + [int]((Get-Item -LiteralPath $ex5).Length/1024) + " KB, " + (Get-Item -LiteralPath $ex5).LastWriteTime.ToString("HH:mm:ss",$INV) + ")"
  Dico ("compilato " + $EA + ": " + $Compilato) "Green"
  $RiskEA = ($h["InpRiskPercent"] -split '\|\|')[0]
  if($RiskEA -eq ""){ $RiskEA = "0.65 (default EA)" }

  if($SoloControllo){
    Dico "SoloControllo: compilazione e gate OK, NON apro MT5. La corsa vera e' la seconda riga." "Green"
  }
  else{
    # -------------------------------------------------------------------
    #  4. LA CORSA -- generico UNA volta, Modello 1 (OHLC), FrazioneIS 1.0
    # -------------------------------------------------------------------
    Titolo "4. LA CORSA (generico, OHLC screening multi-regime)"
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
      [void]$Problemi.Add("il generico e' uscito con codice " + $rc + " (storico _EXT mancante? sweep degenere? CSV non prodotto?).")
    }
  }
}
catch{
  $Fatale = ("" + $_.Exception.Message)
  Write-Host ""
  Write-Host ("!!! FERMATO: " + $Fatale) -ForegroundColor Red
}

# =====================================================================
#  RACCOLTA -- SEMPRE
# =====================================================================
Titolo "RACCOLTA"
$Cart = Join-Path $Dsk ("CRT_EXT_" + $Modo + "_" + $Stamp)
New-Item -ItemType Directory -Force -Path $Cart | Out-Null

$RefTxt = New-Object System.Collections.ArrayList
[void]$RefTxt.Add("=====================================================================")
[void]$RefTxt.Add(" CRT TURTLE SOUP -- TIEBREAKER DI REGIME (" + $EA + ") su " + $Simbolo + " " + $Periodo)
[void]$RefTxt.Add("=====================================================================")
[void]$RefTxt.Add("modo: " + $Modo + "   <- CONTROLLO = giro a vuoto (compila+gate), NON e' il risultato")
[void]$RefTxt.Add("data: " + $Avvio.ToString("yyyy-MM-dd HH:mm:ss",$INV))
[void]$RefTxt.Add("pin:  " + $Pin)
[void]$RefTxt.Add("finestra: " + $DaQuando + " -> " + $Fino + "  (crollo 2020 + toro 2021 + orso 2022 + 2023; FrazioneIS 1.0)")
[void]$RefTxt.Add("banco: MODELLO 1 (OHLC) -- SCREENING OTTIMISTA, non un verdetto. Deposito " + $Deposito + ", rischio " + $RiskEA + "%.")
[void]$RefTxt.Add("fuso: feed _EXT a ora NEW YORK -> flat RTH 16:00 NY (NON 21 server).")
[void]$RefTxt.Add("terminale: " + $Terminale)
[void]$RefTxt.Add("simbolo custom: " + $Simbolo_ok)
[void]$RefTxt.Add("compilazione: " + $Compilato)
[void]$RefTxt.Add("")
[void]$RefTxt.Add("LA DOMANDA: il CRT (morto a tick nel toro, 0/30) vive nella TEMPESTA?")
[void]$RefTxt.Add("Il TETTO OHLC INGANNA ed e' OTTIMISTA: se anche qui e' rosso ovunque,")
[void]$RefTxt.Add("il tick sarebbe peggio -> sepoltura. Se verde SOLO nella tempesta ->")
[void]$RefTxt.Add("candidato storm-gated (come lo short), da Dukascopy per il tick.")
[void]$RefTxt.Add("")
[void]$RefTxt.Add("COME SI LEGGE (quando i CSV tornano):")
[void]$RefTxt.Add("  - La gamba IS_ohlc e' la GRIGLIA sulla FINESTRA INTERA 2020-2024")
[void]$RefTxt.Add("    (FrazioneIS 1.0, 30 celle); la OOS_ohlc e' degenere e si IGNORA.")
[void]$RefTxt.Add("  - DECISIONE DA UN SOLO RUN: la finestra INCLUDE gia' crollo 2020 e")
[void]$RefTxt.Add("    orso 2022. Se la cella MIGLIORE e' NETTAMENTE ROSSA (PF<1) ->")
[void]$RefTxt.Add("    SEPOLTURA: l'OHLC e' ottimista, la tempesta non l'ha salvato, il")
[void]$RefTxt.Add("    tick sarebbe peggio. Se una cella e' NETTA VERDE (PF>=1) sul totale")
[void]$RefTxt.Add("    2020-2024 -> la tempesta la porta nonostante il toro 2021: STAGE-2")
[void]$RefTxt.Add("    (quella cella sola, magic dedicato, per-trade CSV segmentato per")
[void]$RefTxt.Add("    regime). NB: nello sweep il per-trade CSV a magic unico si")
[void]$RefTxt.Add("    sovrascrive -> la lettura per-regime pulita e' lo stage-2, non qui.")
[void]$RefTxt.Add("")
if($Fatale -ne ""){
  [void]$RefTxt.Add("!!! FERMATO: " + $Fatale)
  [void]$RefTxt.Add("")
}
[void]$RefTxt.Add("PROBLEMI: " + $Problemi.Count)
foreach($p in $Problemi){ [void]$RefTxt.Add("  - " + $p) }
[void]$RefTxt.Add("RILIEVI: " + $Rilievi.Count)
foreach($p in $Rilievi){ [void]$RefTxt.Add("  - " + $p) }
[void]$RefTxt.Add("")
[void]$RefTxt.Add('COME SI RIPRENDE: dalla pagina righe/RIGA_CRT_EXT_DA_MANDARE.md, NON da')
[void]$RefTxt.Add('questa riga: $Pin nasce dentro il blocco e non sopravvive.')

$refPath = Join-Path $Cart "REFERTO_CRT_EXT.txt"
Set-Content -LiteralPath $refPath -Value ($RefTxt -join "`r`n") -Encoding ASCII
Write-Host ($RefTxt -join "`r`n")

foreach($f in @("COMPILAZIONE_FALLITA.log")){
  $src = Join-Path $Work $f
  if(Test-Path -LiteralPath $src){ Copy-Item $src -Destination $Cart -Force }
}
$srcProva = Join-Path $Prove $ProvaNome
if(Test-Path -LiteralPath $srcProva){ Copy-Item $srcProva -Destination $Cart -Force }
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
Write-Host "FILE ATTESI NELLO ZIP: REFERTO_CRT_EXT.txt + ABTG_CRT_TurtleSoup_EXT.txt + i CSV IS_ohlc/OOS_ohlc (nella CORSA)" -ForegroundColor Gray

if($Fatale -ne ""){ Write-Host "ESITO: FERMATO" -ForegroundColor Red; exit 1 }
if($Problemi.Count -gt 0){ Write-Host "ESITO: COMPLETATO CON PROBLEMI" -ForegroundColor Yellow; exit 1 }
Write-Host ("ESITO: " + $Modo + " COMPLETATO") -ForegroundColor Green
exit 0
