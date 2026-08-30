# =====================================================================
#  MARCATORE_RIGA_CHAOS_v1
#  RIGA_CHAOS.ps1  --  CHAOS LYAPUNOV: screening del GATE LLE (mappa il
#  gate, non lo giudica). EMA-cross 9/21 gated dall'esponente di Lyapunov
#  piu' grande (opera SOLO in regime leggibile). ABTG_ChaosLyapunov su
#  NASUSD_EXT M15, OHLC (Modello 1), finestra intera 2020-2024, sweep a 3
#  assi (InpLyaThreshold x InpLyaLookback x InpSlAtrMult). EA NUOVO.
# ---------------------------------------------------------------------
#  QUESTO E' UNO SCREENING. NON PROMUOVE NIENTE E NON DA' UN VERDETTO.
#  Prova/criteri congelati PRIMA dei numeri:
#    backtest_pipeline\prove\ABTG_ChaosLyapunov_Lya.txt
#  Gate LLE Chaos/Lyapunov da jojoale (jojoalb), MQL5 Code Base 76446.
#
#  LA DOMANDA: il gate LLE trasforma un EMA-cross mediocre in un edge,
#  concentrando i trade in un regime leggibile? Se muovendo InpLyaThreshold
#  NIENTE cambia (stessi trade, stesso PF) il gate e' DECORATIVO e il
#  candidato cade. Se stringendo il gate il PF sale e i trade calano in
#  modo ordinato, il gate morde ed e' l'edge.
#
#  ------------------------------------------------------------------
#  >>> IL TETTO DEL BANCO, DICHIARATO E LOAD-BEARING: gira a MODELLO 1
#      (OHLC su barre M1 HistData del feed _EXT), NON a tick reali BCM.
#      OHLC INGANNA: qui si legge la FORMA del gate (verde/rosso, ordini
#      di grandezza, se il gate MORDE), MAI i numeri fini. Il verdetto a
#      tick e' possibile SOLO sulla cassaforte recente BCM 2024.09->2026
#      (un solo regime toro), che si apre DOPO. Questa corsa NON tocca il
#      forward: e' una MISURA, non una promozione.
#
#  >>> IL MOTORE E' NUDO (screening del gate SUL MOTORE NUDO): InpCloseAtEnd
#      default false -> tiene overnight, come il feed _EXT. Lo step 2
#      (intraday-flat + tick recente) arriva DOPO, SE il gate morde. Qui
#      NON c'e' logica di sessione: nessun gate del fuso.
#
#  >>> IL PAVIMENTO SL (R109): InpMinStopPts=500 (5 punti indice), MAI 0.
#      Il gate lo pretende pinnato e RIFIUTA 0.
#
#  >>> UNA SOLA TRANCHE, DICHIARATO: finestra 2020.01.01 -> 2026.06.30
#      (crollo 2020 + toro 2021 + orso 2022 + ripartenza 2023 + ...). NON
#      c'e' split IS/OOS interno: il gate si MAPPA sulla finestra intera.
#      Il driver generico pretende una FrazioneIS: gli si passa 1.0, cosi'
#      la sua gamba "IS" e' la FINESTRA INTERA e la "OOS" e' degenere (0
#      giorni, zero passate) e si IGNORA. La lettura per REGIME si fa A
#      MANO dal per-trade CSV in Common\Files.
#
#  ------------------------------------------------------------------
#  PERCHE' ESISTE QUESTO FILE (come RIGA_CRT / RIGA_INVES):
#   1. IL PIN. Senza, girerebbe la punta del branch spacciandola per un
#      commit congelato. Qui il pin vale per il driver E per l'EA.
#   2. LA COMPILAZIONE. ABTG_ChaosLyapunov e' NUOVO, MAI compilato. Il
#      generico NON compila: pretende l'.ex5. Qui si compila PRIMA, e se
#      FALLISCE quello e' il risultato del passo. L'.ex5 vecchio si cancella.
#   3. IL SIMBOLO CUSTOM. NASUSD_EXT e' storico ESTERNO (HistData): il
#      tester lo accetta solo se importato. Si CONTROLLA
#      (bases\Custom\history\NASUSD_EXT) e se manca ci si ferma con
#      l'errore onesto (NON lo si costruisce qui).
#   4. I GATE SUL PROVA + LA RACCOLTA (regola di casa).
#
#  LA RIGA CHE SI INCOLLA sta in righe\RIGA_CHAOS_DA_MANDARE.md
# =====================================================================
[CmdletBinding()]
param(
  [string]$Pin          = "",       # 40 hex OBBLIGATORIO
  [switch]$SoloControllo,           # giro a vuoto: compila + gate, NON apre MT5
  [string]$Simbolo      = "NASUSD_EXT",
  [string]$Periodo      = "M15",
  [string]$DaQuando     = "2020.01.01",
  [string]$Fino         = "2026.06.30",
  [double]$FrazioneIS   = 1.0,      # finestra intera; la gamba OOS del generico e' degenere e si ignora
  [int]$Deposito        = 100000
)
$ErrorActionPreference = "Stop"
[Threading.Thread]::CurrentThread.CurrentCulture   = [Globalization.CultureInfo]::InvariantCulture
[Threading.Thread]::CurrentThread.CurrentUICulture = [Globalization.CultureInfo]::InvariantCulture
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$INV = [Globalization.CultureInfo]::InvariantCulture

$EA     = "ABTG_ChaosLyapunov"
$Avvio  = Get-Date
$Stamp  = $Avvio.ToString("yyyyMMdd_HHmm", $INV)
$Dsk    = Join-Path $env:USERPROFILE "Desktop"
$Work   = Join-Path $env:USERPROFILE "abtg_chaos"
$Prove  = Join-Path $Work "prove"
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

# il prova si chiama ABTG_ChaosLyapunov_Lya.txt (suffisso _Lya), NON come l'EA.
$ProvaName  = "ABTG_ChaosLyapunov_Lya.txt"
# i 3 assi che il prova DEVE spazzolare (flag Y), e NESSUN ALTRO.
$AssiAttesi = @("InpLyaThreshold","InpLyaLookback","InpSlAtrMult")

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
  Titolo ("CHAOS LYAPUNOV -- screening del gate LLE (" + $EA + ") -- modo " + $Modo)

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
  Dico ("simbolo ..... " + $Simbolo + " " + $Periodo + " (feed _EXT custom, OHLC screening)")
  Dico ("finestra .... " + $DaQuando + " -> " + $Fino + " (UNA SOLA TRANCHE, FrazioneIS " + $FrazioneIS + ")")
  Dico ("banco ....... MODELLO 1 (OHLC) -- SCREENING del gate, non un verdetto. Deposito " + $Deposito)

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

  $fProva = Join-Path $Prove $ProvaName
  Scarica ($RawPin + "/backtest_pipeline/prove/" + $ProvaName) $fProva
  Dico ("prova scaricato: " + $ProvaName) "Green"

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
    if($h.ContainsKey($nome)){ throw ($ProvaName + ": DUE righe per '" + $nome + "'. In [TesterInputs] un parametro doppio fa fare a MT5 ZERO passate.") }
    $h[$nome] = $val
    if($val -match '\|\|Y\s*$'){ [void]$assiY.Add($nome) }
  }

  # GATE GEOMETRIA
  if($h["@SIMBOLO"]  -ne $Simbolo){  throw ($ProvaName + ": @SIMBOLO e' " + $h["@SIMBOLO"] + ", atteso " + $Simbolo) }
  if($h["@PERIODO"]  -ne $Periodo){  throw ($ProvaName + ": @PERIODO e' " + $h["@PERIODO"] + ", atteso " + $Periodo) }
  if($h["@DAQUANDO"] -ne $DaQuando){ throw ($ProvaName + ": @DAQUANDO e' " + $h["@DAQUANDO"] + ", atteso " + $DaQuando) }

  # GATE DEI 3 ASSI: esattamente {InpLyaThreshold, InpLyaLookback, InpSlAtrMult}
  $assiOrd = @($assiY | Sort-Object)
  $attesiOrd = @($AssiAttesi | Sort-Object)
  if(($assiOrd -join ",") -ne ($attesiOrd -join ",")){
    throw ($ProvaName + ": gli assi spazzolati sono {" + ($assiOrd -join ", ") + "}, attesi {" + ($attesiOrd -join ", ") + "}.")
  }

  # GATE SWEEP NON DEGENERE: per ogni asse Y, start != stop
  foreach($ax in $AssiAttesi){
    $p = $h[$ax] -split '\|\|'
    if($p.Count -lt 4){ throw ($ProvaName + ": l'asse " + $ax + " non ha il formato default||start||step||stop||Y.") }
    if($p[1] -eq $p[3]){ throw ($ProvaName + ": l'asse " + $ax + " ha start==stop (" + $p[1] + "): sweep degenere, zero celle.") }
  }

  # GATE PAVIMENTO SL (R109): mai 0
  $mfloor = ($h["InpMinStopPts"] -split '\|\|')[0]
  if($mfloor -eq "0"){ throw ($ProvaName + ": InpMinStopPts=0 VIETATO (R109): il pavimento SL e' 500 (5 punti indice), mai 0.") }
  if($mfloor -ne "500"){ throw ($ProvaName + ": InpMinStopPts deve essere 500 (R109, 5 punti indice), trovato '" + $mfloor + "'.") }

  Dico "geometria, 3 assi Lyapunov, sweep non degenere, pavimento SL (R109): TUTTI PASSATI" "Green"
  $RiskEA = ($h["InpRiskPercent"] -split '\|\|')[0]
  if($RiskEA -eq ""){ $RiskEA = "1.0 (default prova)" }

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
  Dico ("terminale scelto: " + $instDir + "  (DEVE essere lo stesso che stampa il generico)") "Yellow"

  # IL SIMBOLO E' CUSTOM (storico ESTERNO): il tester accetta NASUSD_EXT solo
  # se le barre sono state importate. Si CONTROLLA e se manca ci si ferma con
  # l'errore ONESTO -- NON lo si costruisce qui.
  $cartellaSimbolo = Join-Path $dataFolder ("bases\Custom\history\" + $Simbolo)
  if(-not (Test-Path -LiteralPath $cartellaSimbolo)){
    throw ($Simbolo + " non trovato: e' storico ESTERNO e va importato con la Riga dello storico (importa_storico_esterno.ps1) PRIMA di girare. Cercato in: " + $cartellaSimbolo)
  }
  $pesoSimbolo = ((Get-ChildItem -LiteralPath $cartellaSimbolo -Recurse -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum).Sum) / 1MB
  $Simbolo_ok = "TROVATO (" + $pesoSimbolo.ToString("0.0",$INV) + " MB in bases\Custom\history)"
  Dico ("simbolo custom: " + $Simbolo + " " + $Simbolo_ok + ". Se il tester dicesse 'symbol not exist', la REGISTRAZIONE del simbolo e' persa: si riapre MT5 a mano o si rifa' l'import.") "Green"

  # LA COMPILAZIONE. L'.ex5 vecchio si cancella prima.
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
    throw ("COMPILAZIONE FALLITA: " + $EA + " non ha prodotto l'.ex5. E' un EA NUOVO: questo E' il risultato del passo. Gli errori sono qui sopra e in COMPILAZIONE_FALLITA.log dentro lo zip.")
  }
  $Compilato = "OK (" + [int]((Get-Item -LiteralPath $ex5).Length/1024) + " KB, " + (Get-Item -LiteralPath $ex5).LastWriteTime.ToString("HH:mm:ss",$INV) + ")"
  Dico ("compilato " + $EA + ": " + $Compilato) "Green"

  if($SoloControllo){
    Dico "SoloControllo: compilazione e gate OK, NON apro MT5. La corsa vera e' la seconda riga." "Green"
  }
  else{
    # -------------------------------------------------------------------
    #  4. LA CORSA -- generico UNA volta, Modello 1 (OHLC), finestra intera
    # -------------------------------------------------------------------
    Titolo "4. LA CORSA (generico, OHLC screening)"
    $argv = @("-ExecutionPolicy","Bypass","-File",$drv,
              "-Expert",$EA,
              "-Prova",$fProva,
              "-Simbolo",$Simbolo,
              "-Periodo",$Periodo,
              "-DaQuando",$DaQuando,
              "-Fino",$Fino,
              ("-FrazioneIS"),("" + $FrazioneIS),
              "-Modello","1",
              "-Deposito",("" + $Deposito))
    $global:LASTEXITCODE = 0
    & powershell $argv
    $rc = $LASTEXITCODE
    if($rc -ne 0){
      [void]$Problemi.Add("il generico e' uscito con codice " + $rc + " (storico mancante? sweep degenere? CSV non prodotto?).")
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
$Cart = Join-Path $Dsk ("CHAOS_" + $Modo + "_" + $Stamp)
New-Item -ItemType Directory -Force -Path $Cart | Out-Null

$RefTxt = New-Object System.Collections.ArrayList
[void]$RefTxt.Add("=====================================================================")
[void]$RefTxt.Add(" CHAOS LYAPUNOV -- screening del gate LLE (" + $EA + ") su " + $Simbolo + " " + $Periodo)
[void]$RefTxt.Add("=====================================================================")
[void]$RefTxt.Add("modo: " + $Modo + "   <- CONTROLLO = giro a vuoto (compila+gate), NON e' il risultato")
[void]$RefTxt.Add("data: " + $Avvio.ToString("yyyy-MM-dd HH:mm:ss",$INV))
[void]$RefTxt.Add("pin:  " + $Pin)
[void]$RefTxt.Add("finestra: " + $DaQuando + " -> " + $Fino + "  (UNA SOLA TRANCHE, FrazioneIS " + $FrazioneIS + ")")
[void]$RefTxt.Add("banco: MODELLO 1 (OHLC su barre M1 HistData _EXT) -- SCREENING del gate, non un verdetto.")
[void]$RefTxt.Add("       Deposito " + $Deposito + ", rischio " + $RiskEA + "%. Motore NUDO (tiene overnight).")
[void]$RefTxt.Add("terminale: " + $Terminale)
[void]$RefTxt.Add("simbolo custom: " + $Simbolo_ok)
[void]$RefTxt.Add("compilazione: " + $Compilato + "   <- EA NUOVO: se FALLITA, quello e' il risultato del passo")
[void]$RefTxt.Add("")
[void]$RefTxt.Add("QUESTO E' UNO SCREENING. NON PROMUOVE NIENTE E NON DA' UN VERDETTO.")
[void]$RefTxt.Add("OHLC INGANNA: qui si legge la FORMA del gate (se MORDE), MAI i numeri fini.")
[void]$RefTxt.Add("Il verdetto a tick e' possibile SOLO sulla cassaforte BCM 2024.09->2026.")
[void]$RefTxt.Add("")
[void]$RefTxt.Add("COME SI LEGGE (quando i CSV tornano):")
[void]$RefTxt.Add("  - IL GATE MORDE? al crescere di InpLyaThreshold i trade AUMENTANO in modo")
[void]$RefTxt.Add("    monotono (soglia larga = piu' trade). Se il PF e' PIATTO rispetto alla")
[void]$RefTxt.Add("    soglia -> gate DECORATIVO -> il candidato cade.")
[void]$RefTxt.Add("  - Esiste una fascia di soglia con PF>=1.3 su OHLC E DD<8%, NON concentrata")
[void]$RefTxt.Add("    in una cella outlier (centro di un altopiano, non picco)?")
[void]$RefTxt.Add("  - Lettura per REGIME dal per-trade CSV in Common\\Files:")
[void]$RefTxt.Add("      abtg_trades_" + $EA + "_" + $Simbolo + "_<magic>.csv")
[void]$RefTxt.Add("    (crollo 2020 / toro 2021 / orso 2022): l'edge non deve venire da un solo")
[void]$RefTxt.Add("    sotto-periodo di rumore.")
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
[void]$RefTxt.Add('COME SI RIPRENDE: dalla pagina righe/RIGA_CHAOS_DA_MANDARE.md, NON da questa')
[void]$RefTxt.Add('riga: $Pin nasce dentro il blocco e non sopravvive.')

$refPath = Join-Path $Cart "REFERTO_CHAOS.txt"
Set-Content -LiteralPath $refPath -Value ($RefTxt -join "`r`n") -Encoding ASCII
Write-Host ($RefTxt -join "`r`n")

foreach($f in @("COMPILAZIONE_FALLITA.log")){
  $src = Join-Path $Work $f
  if(Test-Path -LiteralPath $src){ Copy-Item $src -Destination $Cart -Force }
}
$srcProva = Join-Path $Prove $ProvaName
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
Write-Host "FILE ATTESI NELLO ZIP: REFERTO_CHAOS.txt + il prova + i CSV IS/OOS_ohlc (nella CORSA)" -ForegroundColor Gray

if($Fatale -ne ""){ Write-Host "ESITO: FERMATO" -ForegroundColor Red; exit 1 }
if($Problemi.Count -gt 0){ Write-Host "ESITO: COMPLETATO CON PROBLEMI" -ForegroundColor Yellow; exit 1 }
Write-Host ("ESITO: " + $Modo + " COMPLETATO") -ForegroundColor Green
exit 0
