# =====================================================================
#  MARCATORE_RIGA_NYRETEST_v3
#  RIGA_NYRETEST.ps1  --  NY SESSION RETEST: PASSO 0 + MISURA a tick BCM.
#  ABTG_NySessionRetest (VWAP-retest in trend, VWAP-retest intraday della
#  flotta) su U30USD M15, TICK REALI (Modello 4), 2024.09.26->2026.06.30.
#  CELLA FISSA con gate regime a soglie NEUTRE (slope 0 / exp 0 = OFF
#  dichiarato). Unico asse Y = InpMagic gemelli (769501/769502).
# ---------------------------------------------------------------------
#  QUESTO E' UN PASSO DI MISURA. NON PROMUOVE NIENTE E NON DA' UN VERDETTO
#  DI MERITO: qui si misurano la FREQUENZA reale dei retest-VWAP su M15, la
#  mediana del take in PUNTI INDICE (dal per-trade CSV) e il costo reale
#  (implicito nei tick BCM). Le 2 tarature del gate (vs OFF) arrivano DOPO,
#  attorno alla mediana misurata. 21 mesi = UN SOLO REGIME (toro): merito
#  sospeso se n<150 (R59), rischio SEMPRE.
#
#  >>> IL FUSO E' QUELLO DI CASA (NON invertito): U30USD BCM = ora SERVER.
#      RTH NY 09:30-16:00 ET -> 14:30-21:00 SERVER. Il gate PRETENDE
#      seduta 14:30 e flat 20:55 e RIFIUTA il 9 e il 16 (le ore ET/NY dei
#      feed _EXT: un altro mondo).
#  >>> U30USD e' NATIVO BCM (non custom): niente import, il tester lo risolve.
#  >>> EA NUOVO, MAI compilato: si compila QUI, prima della corsa, e se
#      FALLISCE quello e' il risultato del passo. L'.ex5 vecchio si cancella.
#  >>> UNA SOLA TRANCHE (FrazioneIS 1.0): la gamba "IS" del generico e' la
#      finestra intera, la "OOS" e' DEGENERE (0 giorni) e si IGNORA. Il
#      rosso del generico sul CSV OOS e' ATTESO: NON rilanciare.
#
#  LA RIGA CHE SI INCOLLA sta in righe\RIGA_NYRETEST_DA_MANDARE.md
# =====================================================================
[CmdletBinding()]
param(
  [string]$Pin          = "",
  [switch]$SoloControllo,
  [string]$Simbolo      = "U30USD",
  [string]$Periodo      = "M15",  # 31/08: su H1 il motore e' strutturalmente MUTO (seduta=6 barre, prima esclusa, pendenza VWAP a 5 -> l'unica barra utile chiude oltre il flat 20:55). Misurato: 0 trade su 459 giorni, 9256=7083+2171+2. Il trend resta su H1 (handle dedicato).
  [string]$DaQuando     = "2024.09.26",
  [string]$Fino         = "2026.06.30",  # dichiarata nel prova (@FINOA) e gattata: MAI ereditata dal default del generico (classe 31/08)
  [double]$FrazioneIS   = 1.0,           # finestra intera; la gamba OOS del generico e' degenere e si ignora
  [int]$Deposito        = 100000
)
$ErrorActionPreference = "Stop"
[Threading.Thread]::CurrentThread.CurrentCulture   = [Globalization.CultureInfo]::InvariantCulture
[Threading.Thread]::CurrentThread.CurrentUICulture = [Globalization.CultureInfo]::InvariantCulture
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$INV = [Globalization.CultureInfo]::InvariantCulture

$EA        = "ABTG_NySessionRetest"
$Avvio     = Get-Date
$Stamp     = $Avvio.ToString("yyyyMMdd_HHmm", $INV)
$Dsk       = Join-Path $env:USERPROFILE "Desktop"
$Work      = Join-Path $env:USERPROFILE "abtg_nyretest"
$Prove     = Join-Path $Work "prove"
$ProvaNome = $EA + ".txt"
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

# la cella fissa della MISURA: gate regime a soglie NEUTRE (0/0 = OFF
# dichiarato), EMA canonica, SL del sorgente + pavimento R109, due lati,
# rischio di casa. I 4 valori del fuso hanno un gate DEDICATO piu' sotto.
$FissiAttesi = @{ "InpEmaTrend"="200";
                  "InpVwapSlopeMin"="0.00"; "InpExpansionMin"="0.00";
                  "InpVwapSlopePeriod"="5"; "InpExpansionLookback"="10";
                  "InpSlLookback"="5"; "InpSlBufferPts"="300";
                  "InpRetestBufferPts"="0";
                  "InpCloseAtEnd"="true";
                  "InpAllowLong"="true"; "InpAllowShort"="true";
                  "InpRiskPercent"="0.65"; "InpMaxTradesPerDay"="2" }
# i gemelli sul magic: l'UNICO asse Y. Vergini repo-wide (769501/769502);
# il 769500 e' il default dell'EA e resta riservato al forward.
$MagicGemelli = @(769501,769502)

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
  Titolo ("NY SESSION RETEST -- PASSO 0 + MISURA a tick (" + $EA + ") -- modo " + $Modo)

  if($Pin -eq ""){ throw "-Pin obbligatorio: senza, girerebbe la punta del branch spacciandola per un commit congelato." }
  if($Pin -notmatch '^[0-9a-f]{40}$'){ throw ("-Pin deve essere un commit di 40 caratteri esadecimali, ricevuto: " + $Pin) }
  if(Get-Process terminal64,metaeditor64 -ErrorAction SilentlyContinue){
    throw "MT5 O METAEDITOR APERTO: col terminale aperto il tester non gira (zero CSV), con MetaEditor aperto la compilazione torna subito senza compilare."
  }

  Dico ("pin ......... " + $Pin)
  Dico ("simbolo ..... " + $Simbolo + " " + $Periodo + " (NATIVO BCM, ora SERVER: seduta 14:30, flat 20:55)")
  Dico ("cella ....... FISSA, gate regime OFF (slope 0 / exp 0) | gemelli 769501/769502")
  Dico ("finestra .... " + $DaQuando + " -> " + $Fino + " (tick BCM, UNA TRANCHE, FrazioneIS " + $FrazioneIS + ")")
  Dico ("banco ....... MODELLO 4 (TICK REALI) -- MISURA, non verdetto. Deposito " + $Deposito)

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

  Titolo "2. GATE SUL PROVA (cella fissa gate-OFF + gemelli + FUSO SERVER)"
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

  # LE QUATTRO DIRETTIVE, NUDE E GATTATE (commentate = gate vuoto = ci si ferma).
  if($h["@SIMBOLO"]  -ne $Simbolo){  throw ($ProvaNome + ": @SIMBOLO e' '" + $h["@SIMBOLO"] + "', atteso " + $Simbolo) }
  if($h["@PERIODO"]  -ne $Periodo){  throw ($ProvaNome + ": @PERIODO e' '" + $h["@PERIODO"] + "', atteso " + $Periodo) }
  if($h["@DAQUANDO"] -ne $DaQuando){ throw ($ProvaNome + ": @DAQUANDO e' '" + $h["@DAQUANDO"] + "', atteso " + $DaQuando + " (pavimento MISURATO dei tick BCM sugli indici)") }
  if($h["@FINOA"]    -ne $Fino){     throw ($ProvaNome + ": @FINOA e' '" + $h["@FINOA"] + "', atteso " + $Fino + " (la finestra si dichiara nel prova, non si eredita dal default del generico)") }

  if(@($assiY).Count -ne 1){ throw ($ProvaNome + ": deve avere ESATTAMENTE un asse Y (InpMagic). Trovati: " + @($assiY).Count + " {" + (@($assiY) -join ", ") + "}.") }
  if($assiY[0] -ne "InpMagic"){ throw ($ProvaNome + ": l'unico asse Y deve essere InpMagic, invece e' " + $assiY[0] + ".") }

  foreach($k in @($FissiAttesi.Keys)){
    $v = ($h[$k] -split '\|\|')[0]
    if($v -ne $FissiAttesi[$k]){ throw ($ProvaNome + ": " + $k + " e' '" + $v + "', atteso '" + $FissiAttesi[$k] + "' (cella fissa della MISURA, gate regime OFF).") }
  }

  $mg = $h["InpMagic"] -split '\|\|'
  if($mg.Count -lt 4){ throw ($ProvaNome + ": InpMagic non ha il formato default||start||step||stop||Y.") }
  $gm = @([int]$mg[1], [int]$mg[3])
  if(($gm | Sort-Object | Out-String) -ne (($MagicGemelli | Sort-Object) | Out-String)){
    throw ($ProvaNome + ": i gemelli magic sono " + ($gm -join "/") + ", attesi " + ($MagicGemelli -join "/") + ".")
  }

  $mfloor = ($h["InpMinStopPts"] -split '\|\|')[0]
  if($mfloor -eq "0"){ throw ($ProvaNome + ": InpMinStopPts=0 VIETATO (R109): il pavimento SL e' 500 (5 punti indice), mai 0.") }
  if($mfloor -ne "500"){ throw ($ProvaNome + ": InpMinStopPts deve essere 500 (R109), trovato '" + $mfloor + "'.") }

  # GATE DEL FUSO -- QUELLO DI CASA (NON invertito): U30USD BCM = ora server.
  # RTH NY 09:30-16:00 ET -> 14:30-21:00 SERVER. Seduta 14:30, flat 20:55
  # (poco PRIMA del close 21:00 server, dichiarato nell'EA). Il 9 e il 16
  # sono le ore ET/NY dei feed _EXT: qui il gate li RIFIUTA per nome.
  $sh = ($h["InpSessionHour"] -split '\|\|')[0]
  $sm = ($h["InpSessionMin"]  -split '\|\|')[0]
  $ch = ($h["InpCloseHour"]   -split '\|\|')[0]
  $cm = ($h["InpCloseMin"]    -split '\|\|')[0]
  if($sh -eq "9"){  throw ($ProvaNome + ": InpSessionHour=9 e' l'ora ET di New York. Su U30USD BCM (ora server, IT-1) l'apertura RTH e' 14:30. Qui va 14, non 9.") }
  if($sh -ne "14"){ throw ($ProvaNome + ": InpSessionHour deve essere 14 (apertura RTH 14:30 server su U30USD BCM), trovato '" + $sh + "'.") }
  if($sm -ne "30"){ throw ($ProvaNome + ": InpSessionMin deve essere 30, trovato '" + $sm + "'.") }
  if($ch -eq "16"){ throw ($ProvaNome + ": InpCloseHour=16 e' l'ora NY del feed _EXT. Su U30USD BCM (ora server) il flat e' 20:55, poco prima del close RTH 21:00. Qui va 20, non 16.") }
  if($ch -ne "20"){ throw ($ProvaNome + ": InpCloseHour deve essere 20 (flat 20:55 server, prima del close RTH 21:00), trovato '" + $ch + "'.") }
  if($cm -ne "55"){ throw ($ProvaNome + ": InpCloseMin deve essere 55, trovato '" + $cm + "'.") }

  Dico "direttive nude, 1 asse Y = InpMagic (gemelli 769501/769502), cella fissa gate-OFF, pavimento SL (R109), FUSO SERVER (14:30 / 20:55): TUTTI PASSATI" "Green"

  Titolo "3. TERMINALE E COMPILAZIONE (U30USD nativo BCM, EA NUOVO)"
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
  $Simbolo_ok = "U30USD (nativo BCM: il tester lo risolve dal server)"

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
    throw ("COMPILAZIONE FALLITA: " + $EA + " non ha prodotto l'.ex5. E' un EA NUOVO, MAI compilato: questo E' il risultato del passo. Gli errori sono qui sopra e in COMPILAZIONE_FALLITA.log dentro lo zip.")
  }
  $Compilato = "OK (" + [int]((Get-Item -LiteralPath $ex5).Length/1024) + " KB, " + (Get-Item -LiteralPath $ex5).LastWriteTime.ToString("HH:mm:ss",$INV) + ")"
  Dico ("compilato " + $EA + ": " + $Compilato) "Green"

  $commonFiles = CommonFilesDir
  foreach($m in $MagicGemelli){
    $pt = Join-Path $commonFiles (PerTradeNome $m)
    Remove-Item -LiteralPath $pt -Force -ErrorAction SilentlyContinue
  }
  Dico "per-trade CSV vecchi cancellati (769501/769502, se c'erano)" "Gray"

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
              ("-FrazioneIS"),("" + $FrazioneIS),
              "-Modello","4",
              "-Rifai",
              "-Deposito",("" + $Deposito))
    $global:LASTEXITCODE = 0
    & powershell $argv
    $rc = $LASTEXITCODE
    if($rc -ne 0){
      [void]$Problemi.Add("il generico e' uscito con codice " + $rc + " (storico mancante? CSV non prodotto?).")
    }
    $trovati = 0
    $conte = New-Object System.Collections.ArrayList
    foreach($m in $MagicGemelli){
      $pt = Join-Path $commonFiles (PerTradeNome $m)
      if(Test-Path -LiteralPath $pt){
        $ops = @(Get-Content -LiteralPath $pt).Count - 1
        if($ops -lt 0){ $ops = 0 }
        [void]$conte.Add("" + $m + "=" + $ops)
        if($ops -gt 0){ $trovati++ }
        else{ [void]$Problemi.Add("per-trade del magic " + $m + ": SOLO l'intestazione, ZERO operazioni. File troncato da una passata a vuoto (gamba OOS degenere) oppure zero trade veri: in nessuno dei due casi e' una misura.") }
      }
      else{ [void]$Problemi.Add("per-trade del magic " + $m + " NON prodotto in Common\Files (zero trade? FILE_COMMON non scritto? cache del tester?).") }
    }
    if($conte.Count -eq 2){
      $c1 = [int](($conte[0] -split "=")[1]); $c2 = [int](($conte[1] -split "=")[1])
      if($c1 -ne $c2){ [void]$Problemi.Add("GEMELLI DIVERGENTI: " + $c1 + " e " + $c2 + " operazioni. Due passate identiche devono dare lo STESSO numero: se divergono il banco non e' deterministico e la misura non si legge.") }
    }
    if($conte.Count -gt 0){ $PerTrade_ok = "OPERAZIONI per magic -> " + ($conte -join " | ") + "   (file con dati: " + $trovati + " su 2)" }
    else{ $PerTrade_ok = "NESSUN FILE in Common\Files" }
  }
}
catch{
  $Fatale = ("" + $_.Exception.Message)
  Write-Host ""
  Write-Host ("!!! FERMATO: " + $Fatale) -ForegroundColor Red
}

Titolo "RACCOLTA"
$Cart = Join-Path $Dsk ("NYRETEST_" + $Modo + "_" + $Stamp)
New-Item -ItemType Directory -Force -Path $Cart | Out-Null

$RefTxt = New-Object System.Collections.ArrayList
[void]$RefTxt.Add("=====================================================================")
[void]$RefTxt.Add(" NY SESSION RETEST -- PASSO 0 + MISURA a tick su " + $Simbolo + " " + $Periodo)
[void]$RefTxt.Add("=====================================================================")
[void]$RefTxt.Add("modo: " + $Modo + "   <- CONTROLLO = giro a vuoto, NON e' il risultato")
[void]$RefTxt.Add("data: " + $Avvio.ToString("yyyy-MM-dd HH:mm:ss",$INV))
[void]$RefTxt.Add("pin:  " + $Pin)
[void]$RefTxt.Add("cella: FISSA -- EMA 200, gate regime OFF (slope 0 / exp 0), SL 5 barre")
[void]$RefTxt.Add("       +300 + pavimento 500 (R109), due lati, rischio 0.65%, cap 2/gg,")
[void]$RefTxt.Add("       flat ACCESO | gemelli 769501/769502")
[void]$RefTxt.Add("finestra: " + $DaQuando + " -> " + $Fino + "  (tick BCM, UNA TRANCHE, FrazioneIS " + $FrazioneIS + ")")
[void]$RefTxt.Add("banco: MODELLO 4 (TICK REALI) -- MISURA, non verdetto. Deposito " + $Deposito)
[void]$RefTxt.Add("fuso: U30USD BCM = ora SERVER -> seduta 14:30, flat 20:55 (NON 9:30/16 ET).")
[void]$RefTxt.Add("terminale: " + $Terminale)
[void]$RefTxt.Add("simbolo: " + $Simbolo_ok)
[void]$RefTxt.Add("compilazione: " + $Compilato + "   <- EA NUOVO: se FALLITA, quello e' il risultato del passo")
[void]$RefTxt.Add("per-trade CSV: " + $PerTrade_ok)
[void]$RefTxt.Add("")
[void]$RefTxt.Add("QUESTO E' IL PASSO 0 + MISURA. NON PROMUOVE NIENTE, NIENTE VERDETTO DI MERITO.")
[void]$RefTxt.Add("COME SI LEGGE (quando i CSV tornano):")
[void]$RefTxt.Add("  - FREQUENZA: n trade nella griglia gemelli (2 righe identiche). M15 in seduta:")
[void]$RefTxt.Add("    attesi pochi/settimana. Se n<150 il MERITO resta sospeso (R59);")
[void]$RefTxt.Add("    il RISCHIO (DD, peggior giornata, autotest, flat) si giudica SEMPRE.")
[void]$RefTxt.Add("  - VINCOLO DURO: zero overnight. Colonne Flat Giorni / Flat Chiusure +")
[void]$RefTxt.Add("    orari nel per-trade CSV: un solo trade oltre il flat = file INVALIDO.")
[void]$RefTxt.Add("  - MEDIANA DEL TAKE in PUNTI INDICE: colonna take_idx_pts del per-trade")
[void]$RefTxt.Add("    CSV. E' il numero che decide se il retest M15 paga lo spread U30USD")
[void]$RefTxt.Add("    (implicito nei tick BCM) e la SCALA delle 2 tarature del gate.")
[void]$RefTxt.Add("  - DUE LATI: colonna dir (LONG/SHORT) del per-trade CSV, letti separati.")
[void]$RefTxt.Add("  - DIAGNOSTICA CANCELLI: colonne OnNewBar/Ret*/Regime Ko/Trend Ko dicono")
[void]$RefTxt.Add("    QUALE cancello ferma le barre (qui Regime Ko deve stare a 0: gate OFF).")
[void]$RefTxt.Add("  - Autotest Falliti deve essere 0 (colonna 12 della griglia).")
[void]$RefTxt.Add("  - IL PASSO DOPO: 2 tarature del gate attorno alla mediana misurata di")
[void]$RefTxt.Add("    slope/espansione (gate ON vs OFF) + sweep InpSlLookback. NON qui.")
[void]$RefTxt.Add("")
if($Fatale -ne ""){ [void]$RefTxt.Add("!!! FERMATO: " + $Fatale); [void]$RefTxt.Add("") }
[void]$RefTxt.Add("PROBLEMI: " + $Problemi.Count)
foreach($p in $Problemi){ [void]$RefTxt.Add("  - " + $p) }
[void]$RefTxt.Add("RILIEVI: " + $Rilievi.Count)
foreach($p in $Rilievi){ [void]$RefTxt.Add("  - " + $p) }
[void]$RefTxt.Add("")
[void]$RefTxt.Add('COME SI RIPRENDE: dalla pagina righe/RIGA_NYRETEST_DA_MANDARE.md, NON da')
[void]$RefTxt.Add('questa riga: $Pin nasce dentro il blocco e non sopravvive.')

$refPath = Join-Path $Cart "REFERTO_NYRETEST.txt"
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
Write-Host "FILE ATTESI NELLO ZIP: REFERTO_NYRETEST.txt + il prova + i per-trade CSV (abtg_trades_..._769501/769502.csv) + la griglia gemelli (IS, tick)" -ForegroundColor Gray
Write-Host "NOTA: il CSV *_OOS NON esiste MAI qui (FrazioneIS 1.0 = gamba OOS degenere)." -ForegroundColor Gray
Write-Host "      Il rosso del generico su quel file e' ATTESO: NON rilanciare." -ForegroundColor Gray

if($Fatale -ne ""){ Write-Host "ESITO: FERMATO" -ForegroundColor Red; exit 1 }
if($Problemi.Count -gt 0){ Write-Host "ESITO: COMPLETATO CON PROBLEMI" -ForegroundColor Yellow; exit 1 }
Write-Host ("ESITO: " + $Modo + " COMPLETATO") -ForegroundColor Green
exit 0
