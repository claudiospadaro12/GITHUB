# =====================================================================
#  MARCATORE_RIGA_DAXREENTRY_v1
#  RIGA_DAXREENTRY.ps1  --  DAX REENTRY: PASSO 0 + MISURA a tick BCM.
#  ABTG_DaxReEntry (sweep+reclaim del range mattutino, da KepiroG/
#  TradingView reimplementato) su D30EUR M5, TICK REALI (Modello 4),
#  2024.09.26->2026.06.30. ASSI VERI del prova (InpBreakPts x InpSide,
#  piu' InpSlFracRange dichiarato ma di fatto a 1 valore): 9 passate,
#  magic FISSO 769300. NIENTE gemelli InpMagic: quel disegno e' della
#  cella fissa, qui la griglia c'e' davvero.
# ---------------------------------------------------------------------
#  QUESTO E' UN PASSO DI MISURA. NON PROMUOVE NIENTE E NON DA' UN VERDETTO
#  DI MERITO: qui si misurano la FREQUENZA reale dello sweep+reclaim di
#  mezzogiorno (colonna Trades della griglia IS, cella per cella), il
#  LORDO medio/operazione contro il cancello S0 (>= 3x lo spread della
#  fascia sottile, implicito nei tick BCM) e la scala del take in PUNTI
#  INDICE. 21 mesi = UN SOLO REGIME (toro): merito sospeso se n<150
#  (R59), rischio SEMPRE.
#
#  >>> FUSO DI CASA (regola fissa CLAUDE.md): D30EUR BCM = ora SERVER
#      (IT-1). DAX apre 08:00 server; range 08:35-11:05, trading
#      11:05-14:15, flat 16:30 server (= cash close 17:30 IT). Il gate
#      RIFIUTA il 9 dell'apertura e il 17 del flat (le ore ITALIANE).
#  >>> D30EUR e' NATIVO BCM: niente import, il tester lo risolve.
#  >>> EA NUOVO, MAI compilato: si compila QUI, prima della corsa, e se
#      FALLISCE quello e' il risultato del passo. L'.ex5 vecchio si cancella.
#  >>> UNA SOLA TRANCHE (FrazioneIS 1.0): la gamba "IS" del generico e' la
#      finestra intera, la "OOS" e' DEGENERE (0 giorni) e si IGNORA. Il
#      rosso del generico sul CSV OOS e' ATTESO: NON rilanciare.
#  >>> PER-TRADE IN GRIGLIA: il nome porta il MAGIC (fisso), ogni passata
#      con uscite lo riscrive -> nel file resta SOLO L'ULTIMA passata.
#      DICHIARATO: serve al controllo overnight e alla scala del take di
#      quella cella, NON come misura della griglia.
#
#  LA RIGA CHE SI INCOLLA sta in righe\RIGA_DAXREENTRY_DA_MANDARE.md
# =====================================================================
[CmdletBinding()]
param(
  [string]$Pin          = "",
  [switch]$SoloControllo,
  [string]$Simbolo      = "D30EUR",
  [string]$Periodo      = "M5",
  [string]$DaQuando     = "2024.09.26",  # pavimento MISURATO dei tick BCM sugli indici
  [string]$Fino         = "2026.06.30",  # dichiarata nel prova (@FINOA) e gattata: MAI ereditata dal default del generico (classe 31/08)
  [double]$FrazioneIS   = 1.0,           # finestra intera; la gamba OOS del generico e' degenere e si ignora
  [int]$Deposito        = 100000
)
$ErrorActionPreference = "Stop"
[Threading.Thread]::CurrentThread.CurrentCulture   = [Globalization.CultureInfo]::InvariantCulture
[Threading.Thread]::CurrentThread.CurrentUICulture = [Globalization.CultureInfo]::InvariantCulture
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$INV = [Globalization.CultureInfo]::InvariantCulture

$EA        = "ABTG_DaxReEntry"
$Avvio     = Get-Date
$Stamp     = $Avvio.ToString("yyyyMMdd_HHmm", $INV)
$Dsk       = Join-Path $env:USERPROFILE "Desktop"
$Work      = Join-Path $env:USERPROFILE "abtg_daxreentry"
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
$Griglia_ok  = "NON TROVATA"
$CacheTxt  = "NON SVUOTATA"
$Overnight_ok = "NON VERIFICATO"
$Modo      = "CORSA"
if($SoloControllo){ $Modo = "CONTROLLO" }

# --- i 3 assi che il prova DEVE spazzolare (flag Y), e NESSUN ALTRO.
#     InpSlFracRange e' dichiarato ma di FATTO a 1 valore (0.454: il passo
#     0.754 supera lo stop 0.700) -> griglia effettiva 3 x 1 x 3 = 9 passate.
$AssiAttesi = @("InpBreakPts","InpSlFracRange","InpSide")
$PassateAttese = 9
# --- il magic FISSO della griglia (default nell'.mq5, blocco 7693xx
#     verificato libero repo-wide). NON e' un asse.
$MagicAtteso = 769300
# --- la cella fissa attorno agli assi: fuso server, R109, rischio di casa.
#     I 10 valori del fuso hanno un gate DEDICATO piu' sotto.
$FissiAttesi = @{ "InpMinStopPts"="500";
                  "InpRiskPercent"="0.65"; "InpMaxTradesPerDay"="2";
                  "InpMT5PerPuntoIndice"="100";
                  "InpComment"="REENT"; "InpMaxSpread"="0";
                  "InpVerbose"="false"; "InpAutoTest"="true" }

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
  Titolo ("DAX REENTRY -- PASSO 0 + MISURA a tick (" + $EA + ") -- modo " + $Modo)

  if($Pin -eq ""){ throw "-Pin obbligatorio: senza, girerebbe la punta del branch spacciandola per un commit congelato." }
  if($Pin -notmatch '^[0-9a-f]{40}$'){ throw ("-Pin deve essere un commit di 40 caratteri esadecimali, ricevuto: " + $Pin) }
  if(Get-Process terminal64,metaeditor64 -ErrorAction SilentlyContinue){
    throw "MT5 O METAEDITOR APERTO: col terminale aperto il tester non gira (zero CSV), con MetaEditor aperto la compilazione torna subito senza compilare."
  }

  Dico ("pin ......... " + $Pin)
  Dico ("simbolo ..... " + $Simbolo + " " + $Periodo + " (NATIVO BCM, ora SERVER: range 08:35-11:05, trading 11:05-14:15, flat 16:30)")
  Dico ("griglia ..... ASSI VERI " + ($AssiAttesi -join " x ") + " = " + $PassateAttese + " passate | magic FISSO " + $MagicAtteso)
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

  Titolo "2. GATE SUL PROVA (assi veri + magic fisso + FUSO SERVER + R109)"
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

  # LE QUATTRO DIRETTIVE, NUDE E GATTATE (commentate = gate vuoto = ci si
  # ferma). Il batch del 30/08 le aveva COMMENTATE: difetto n.1, gia' pagato.
  if($h["@SIMBOLO"]  -ne $Simbolo){  throw ($ProvaNome + ": @SIMBOLO e' '" + $h["@SIMBOLO"] + "', atteso " + $Simbolo) }
  if($h["@PERIODO"]  -ne $Periodo){  throw ($ProvaNome + ": @PERIODO e' '" + $h["@PERIODO"] + "', atteso " + $Periodo) }
  if($h["@DAQUANDO"] -ne $DaQuando){ throw ($ProvaNome + ": @DAQUANDO e' '" + $h["@DAQUANDO"] + "', atteso " + $DaQuando + " (pavimento MISURATO dei tick BCM sugli indici)") }
  if($h["@FINOA"]    -ne $Fino){     throw ($ProvaNome + ": @FINOA e' '" + $h["@FINOA"] + "', atteso " + $Fino + " (la finestra si dichiara nel prova, non si eredita dal default del generico)") }

  # GLI ASSI: esattamente quelli attesi, nell'insieme (l'ordine non conta).
  if(@($assiY).Count -ne @($AssiAttesi).Count){ throw ($ProvaNome + ": attesi " + @($AssiAttesi).Count + " assi Y {" + ($AssiAttesi -join ", ") + "}, trovati " + @($assiY).Count + " {" + (@($assiY) -join ", ") + "}.") }
  foreach($a in $AssiAttesi){
    if(@($assiY) -notcontains $a){ throw ($ProvaNome + ": manca l'asse Y atteso '" + $a + "'. Trovati: {" + (@($assiY) -join ", ") + "}.") }
  }

  # IL MAGIC: FISSO (non un asse), e quello del blocco 7693xx.
  if(@($assiY) -contains "InpMagic"){ throw ($ProvaNome + ": InpMagic NON deve essere un asse qui (i gemelli sono il disegno della cella fissa; con assi veri il magic resta fisso).") }
  $mg = ($h["InpMagic"] -split '\|\|')[0]
  if($mg -ne ("" + $MagicAtteso)){ throw ($ProvaNome + ": InpMagic e' '" + $mg + "', atteso " + $MagicAtteso + " (blocco 7693xx, verificato libero repo-wide).") }

  foreach($k in @($FissiAttesi.Keys)){
    $v = ($h[$k] -split '\|\|')[0]
    if($v -ne $FissiAttesi[$k]){ throw ($ProvaNome + ": " + $k + " e' '" + $v + "', atteso '" + $FissiAttesi[$k] + "' (cella fissa della MISURA).") }
  }

  # R109: il pavimento SL non e' MAI zero, e qui vale 500 (5 punti indice).
  $mfloor = ($h["InpMinStopPts"] -split '\|\|')[0]
  if($mfloor -eq "0"){ throw ($ProvaNome + ": InpMinStopPts=0 VIETATO (R109): il pavimento SL e' 500 (5 punti indice), mai 0.") }
  if([int]$mfloor -lt 500){ throw ($ProvaNome + ": InpMinStopPts deve essere >= 500 (R109), trovato '" + $mfloor + "'.") }

  # GATE DEL FUSO -- regola fissa CLAUDE.md: D30EUR BCM = ora SERVER (IT-1).
  # DAX apre 08:00 server; il range di KepiroG parte 08:35 server (09:35 CET)
  # e il flat e' 16:30 server (= cash close 17:30 IT). Il 9 e il 17 sono le
  # ore ITALIANE: qui il gate li RIFIUTA per nome.
  $rsH = ($h["InpRangeStartHour"] -split '\|\|')[0]
  $rsM = ($h["InpRangeStartMin"]  -split '\|\|')[0]
  $reH = ($h["InpRangeEndHour"]   -split '\|\|')[0]
  $reM = ($h["InpRangeEndMin"]    -split '\|\|')[0]
  $tsH = ($h["InpTradeStartHour"] -split '\|\|')[0]
  $tsM = ($h["InpTradeStartMin"]  -split '\|\|')[0]
  $teH = ($h["InpTradeEndHour"]   -split '\|\|')[0]
  $teM = ($h["InpTradeEndMin"]    -split '\|\|')[0]
  $clH = ($h["InpCloseHour"]      -split '\|\|')[0]
  $clM = ($h["InpCloseMin"]       -split '\|\|')[0]
  if($rsH -eq "9"){  throw ($ProvaNome + ": InpRangeStartHour=9 e' l'ora ITALIANA (09:35 IT). Su D30EUR BCM (ora server, IT-1) il range parte alle 08:35. Qui va 8, non 9.") }
  if($rsH -ne "8"){  throw ($ProvaNome + ": InpRangeStartHour deve essere 8 (range 08:35 server), trovato '" + $rsH + "'.") }
  if($rsM -ne "35"){ throw ($ProvaNome + ": InpRangeStartMin deve essere 35, trovato '" + $rsM + "'.") }
  if($reH -ne "11"){ throw ($ProvaNome + ": InpRangeEndHour deve essere 11 (fine range 11:05 server), trovato '" + $reH + "'.") }
  if($reM -ne "5"){  throw ($ProvaNome + ": InpRangeEndMin deve essere 5, trovato '" + $reM + "'.") }
  if($tsH -ne "11"){ throw ($ProvaNome + ": InpTradeStartHour deve essere 11 (trading 11:05 server), trovato '" + $tsH + "'.") }
  if($tsM -ne "5"){  throw ($ProvaNome + ": InpTradeStartMin deve essere 5, trovato '" + $tsM + "'.") }
  if($teH -ne "14"){ throw ($ProvaNome + ": InpTradeEndHour deve essere 14 (fine trading 14:15 server), trovato '" + $teH + "'.") }
  if($teM -ne "15"){ throw ($ProvaNome + ": InpTradeEndMin deve essere 15, trovato '" + $teM + "'.") }
  if($clH -eq "17"){ throw ($ProvaNome + ": InpCloseHour=17 e' l'ora ITALIANA del cash close (17:30 IT). Su D30EUR BCM (ora server) il flat e' 16:30. Qui va 16, non 17.") }
  if($clH -ne "16"){ throw ($ProvaNome + ": InpCloseHour deve essere 16 (flat 16:30 server = cash close 17:30 IT), trovato '" + $clH + "'.") }
  if($clM -ne "30"){ throw ($ProvaNome + ": InpCloseMin deve essere 30, trovato '" + $clM + "'.") }

  Dico "direttive nude, 3 assi Y attesi, magic FISSO 769300, cella fissa, pavimento SL (R109), FUSO SERVER (08:35/11:05/14:15/16:30): TUTTI PASSATI" "Green"

  Titolo "3. TERMINALE E COMPILAZIONE (D30EUR nativo BCM, EA NUOVO)"
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
  $Simbolo_ok = "D30EUR (nativo BCM: il tester lo risolve dal server)"

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
  $ptFile = Join-Path $commonFiles (PerTradeNome $MagicAtteso)
  Remove-Item -LiteralPath $ptFile -Force -ErrorAction SilentlyContinue
  Dico ("per-trade CSV vecchio cancellato (" + $MagicAtteso + ", se c'era)") "Gray"

  # LA CACHE DEL TESTER (checklist punto 38): un pass RIPESCATO dalla cache
  # non chiama OnTester() -> niente frame, niente riga nel CSV, nessun
  # per-trade. L'EA e' nuovo, ma la regola non guarda la missione: si svuota
  # SEMPRE, coi conteggi. SOLO Tester\cache (MAI bases\<server>\ticks).
  $cacheT = Join-Path $dataFolder "Tester\cache"
  if(Test-Path -LiteralPath $cacheT){
    $ncPrima = @(Get-ChildItem -LiteralPath $cacheT -Recurse -File -ErrorAction SilentlyContinue).Count
    Remove-Item (Join-Path $cacheT "*") -Recurse -Force -ErrorAction SilentlyContinue
    $ncDopo  = @(Get-ChildItem -LiteralPath $cacheT -Recurse -File -ErrorAction SilentlyContinue).Count
    $CacheTxt = "prima " + $ncPrima + " file, dopo " + $ncDopo
    if($ncDopo -gt 0){
      [void]$Problemi.Add("Tester\cache NON si e' svuotata (prima " + $ncPrima + ", dopo " + $ncDopo + "): pass gia' in cache verrebbero RIPESCATI -> CSV senza righe e nessun per-trade.")
      Dico ("Tester\cache NON SVUOTATA: " + $CacheTxt) "Red"
    }
    else{ Dico ("Tester\cache svuotata: " + $CacheTxt) "Green" }
  }
  else{
    $CacheTxt = "cartella assente (" + $cacheT + "): niente da svuotare"
    Dico ("Tester\cache: " + $CacheTxt) "Yellow"
  }

  if($SoloControllo){
    Dico "SoloControllo: compilazione e gate OK, NON apro MT5. La corsa vera e' la seconda riga." "Green"
  }
  else{
    Titolo "4. LA CORSA (generico, griglia 9 passate, Modello 4 TICK, FrazioneIS 1.0)"
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

    # LA GRIGLIA IS: righe contate (mai Test-Path da solo). Attese 9 passate.
    $Results = Join-Path $Work ("risultati_prove\" + $EA)
    $fIS = Join-Path $Results ($EA + "_" + $Simbolo + "_IS.csv")
    if(Test-Path -LiteralPath $fIS){
      $rIS = @(Get-Content -LiteralPath $fIS).Count - 1
      if($rIS -lt 0){ $rIS = 0 }
      $Griglia_ok = "" + $rIS + " passate nel CSV IS (attese " + $PassateAttese + ")"
      if($rIS -ne $PassateAttese){
        [void]$Problemi.Add("griglia IS con " + $rIS + " passate invece di " + $PassateAttese + " (3 InpBreakPts x 1 InpSlFracRange effettivo x 3 InpSide): pass ripescati dalla cache o ottimizzazione monca.")
      }
    }
    else{
      $Griglia_ok = "CSV IS NON PRODOTTO"
      [void]$Problemi.Add("griglia IS non prodotta (" + $fIS + "): senza, il PASSO 0 non ha la frequenza per cella.")
    }

    # IL PER-TRADE: OPERAZIONI contate (mai Test-Path). In griglia il file e'
    # SOLO l'ultima passata con uscite (magic fisso): dichiarato, non e' la
    # misura della griglia.
    if(Test-Path -LiteralPath $ptFile){
      $ops = @(Get-Content -LiteralPath $ptFile).Count - 1
      if($ops -lt 0){ $ops = 0 }
      $PerTrade_ok = "OPERAZIONI magic " + $MagicAtteso + " -> " + $ops + "   (ULTIMA passata con uscite, NON la griglia: dichiarato)"
      if($ops -eq 0){ [void]$Problemi.Add("per-trade del magic " + $MagicAtteso + ": SOLO l'intestazione, ZERO operazioni. Nessuna passata ha aperto trade: o il motore e' muto (guardare la diagnostica cancelli nel CSV IS) o il banco non ha girato.") }
    }
    else{
      $PerTrade_ok = "NESSUN FILE in Common\Files"
      [void]$Problemi.Add("per-trade del magic " + $MagicAtteso + " NON prodotto in Common\Files (zero uscite in TUTTE le passate? FILE_COMMON non scritto? cache del tester?).")
    }

    # IL VINCOLO ZERO-OVERNIGHT, MISURATO QUI. Dopo il flat di RECUPERO un
    # close_time notturno e' LEGITTIMO (primo tick disponibile): l'ora di
    # chiusura DA SOLA non dice piu' niente. Si confrontano open_time e
    # close_time (colonne 1 e 2). Campione = l'ultima passata (dichiarato).
    $nTot = 0; $nOver = 0; $esempi = New-Object System.Collections.ArrayList
    if(Test-Path -LiteralPath $ptFile){
      $nr = 0
      foreach($riga in @(Get-Content -LiteralPath $ptFile)){
        $nr++
        if($nr -eq 1){ continue }
        if($riga.Trim() -eq ""){ continue }
        $col = $riga -split ';'
        if($col.Count -lt 2){ continue }
        $tChiu = $col[0].Replace('"','').Trim()
        $tApri = $col[1].Replace('"','').Trim()
        if($tApri -eq "?" -or $tApri -eq ""){ continue }
        $nTot++
        $gChiu = ($tChiu -split ' ')[0]
        $gApri = ($tApri -split ' ')[0]
        if($gChiu -ne $gApri){
          $nOver++
          if($esempi.Count -lt 5){ [void]$esempi.Add($tApri + " -> " + $tChiu) }
        }
      }
    }
    if($nTot -eq 0){ $Overnight_ok = "NON MISURABILE (nessuna riga con open_time)" }
    else{
      $pct = [math]::Round(100.0*$nOver/$nTot,2)
      $Overnight_ok = "" + $nOver + " su " + $nTot + " (" + $pct + "%) chiuse in un GIORNO SUCCESSIVO all'apertura (campione: ultima passata)"
      if($esempi.Count -gt 0){ $Overnight_ok += "   es: " + ($esempi -join " ; ") }
      if($pct -gt 5.0){
        [void]$Problemi.Add("OVERNIGHT VERI oltre la soglia dichiarata nel prova (5%): " + $pct + "% (" + $nOver + "/" + $nTot + "). Il file NON e' una misura valida.")
      }
      elseif($nOver -gt 0){
        [void]$Rilievi.Add("overnight per ASSENZA DI TICK: " + $nOver + "/" + $nTot + " (" + $pct + "%), sotto la soglia del 5%. Il flat di recupero ha chiuso al primo tick: gap-risk residuo DICHIARATO, non azzerato.")
      }
    }
  }
}
catch{
  $Fatale = ("" + $_.Exception.Message)
  Write-Host ""
  Write-Host ("!!! FERMATO: " + $Fatale) -ForegroundColor Red
}

Titolo "RACCOLTA"
$Cart = Join-Path $Dsk ("DAXREENTRY_" + $Modo + "_" + $Stamp)
New-Item -ItemType Directory -Force -Path $Cart | Out-Null

$RefTxt = New-Object System.Collections.ArrayList
[void]$RefTxt.Add("=====================================================================")
[void]$RefTxt.Add(" DAX REENTRY -- PASSO 0 + MISURA a tick su " + $Simbolo + " " + $Periodo)
[void]$RefTxt.Add("=====================================================================")
[void]$RefTxt.Add("modo: " + $Modo + "   <- CONTROLLO = giro a vuoto, NON e' il risultato")
[void]$RefTxt.Add("data: " + $Avvio.ToString("yyyy-MM-dd HH:mm:ss",$INV))
[void]$RefTxt.Add("pin:  " + $Pin)
[void]$RefTxt.Add("griglia: ASSI VERI InpBreakPts {20,30,40} x InpSlFracRange {0.454, di")
[void]$RefTxt.Add("         fatto 1 valore} x InpSide {0,1,2} = 9 passate | magic FISSO 769300")
[void]$RefTxt.Add("cella fissa: range 08:35-11:05, trading 11:05-14:15, flat 16:30 (SERVER),")
[void]$RefTxt.Add("         pavimento SL 500 (R109), rischio 0.65%, cap 2/gg (1/lato), conv 100 (MISURATA)")
[void]$RefTxt.Add("finestra: " + $DaQuando + " -> " + $Fino + "  (tick BCM, UNA TRANCHE, FrazioneIS " + $FrazioneIS + ")")
[void]$RefTxt.Add("banco: MODELLO 4 (TICK REALI) -- MISURA, non verdetto. Deposito " + $Deposito)
[void]$RefTxt.Add("fuso: D30EUR BCM = ora SERVER (IT-1) -> range 08:35, flat 16:30 (NON 9:35/17:30 IT).")
[void]$RefTxt.Add("terminale: " + $Terminale)
[void]$RefTxt.Add("simbolo: " + $Simbolo_ok)
[void]$RefTxt.Add("compilazione: " + $Compilato + "   <- EA NUOVO: se FALLITA, quello e' il risultato del passo")
[void]$RefTxt.Add("griglia IS: " + $Griglia_ok)
[void]$RefTxt.Add("per-trade CSV: " + $PerTrade_ok)
[void]$RefTxt.Add("cache tester: " + $CacheTxt + "   <- punto 38: un pass ripescato non chiama OnTester")
[void]$RefTxt.Add("overnight veri: " + $Overnight_ok + "   <- open_time vs close_time, NON l'ora di chiusura da sola")
[void]$RefTxt.Add("")
[void]$RefTxt.Add("QUESTO E' IL PASSO 0 + MISURA. NON PROMUOVE NIENTE, NIENTE VERDETTO DI MERITO.")
[void]$RefTxt.Add("COME SI LEGGE (quando i CSV tornano):")
[void]$RefTxt.Add("  - FREQUENZA: colonna Trades del CSV IS, cella per cella (9 righe). Se")
[void]$RefTxt.Add("    n>=150 il MERITO non e' piu' sospeso (R59); il RISCHIO (DD, peggior")
[void]$RefTxt.Add("    giornata, autotest, flat) si giudica SEMPRE.")
[void]$RefTxt.Add("  - CANCELLO S0 (congelato nel prova): il LORDO medio/operazione deve")
[void]$RefTxt.Add("    coprire >= 3x lo SPREAD della fascia mezzogiorno (implicito nei tick")
[void]$RefTxt.Add("    BCM). Se non copre -> STOP, senza leggere nessun PF.")
[void]$RefTxt.Add("  - PER-TRADE (abtg_trades_..._769300.csv): SOLO l'ultima passata con")
[void]$RefTxt.Add("    uscite (magic fisso in griglia, dichiarato). Serve per: overnight")
[void]$RefTxt.Add("    veri, scala del take in PUNTI INDICE (colonna take_idx_pts), lati")
[void]$RefTxt.Add("    (colonna dir). NON e' la misura della griglia.")
[void]$RefTxt.Add("  - DUE LATI: righe InpSide=0 e InpSide=1 del CSV IS, lette separate")
[void]$RefTxt.Add("    (regola di casa 25/08); InpSide=2 e' l'unione.")
[void]$RefTxt.Add("  - DIAGNOSTICA CANCELLI: colonne OnNewBar/Ret* dicono QUALE cancello")
[void]$RefTxt.Add("    ferma le barre (fascia sottile: attesi molti Ret Fuori Fascia).")
[void]$RefTxt.Add("  - Autotest Falliti deve essere 0 in TUTTE le 9 righe.")
[void]$RefTxt.Add("  - OOS: NON ESISTE (FrazioneIS 1.0). Altopiano/promozione: NON QUI.")
[void]$RefTxt.Add("  - IL PASSO DOPO: se S0 passa, round di griglia vero (spazzolata SL,")
[void]$RefTxt.Add("    incrocio giorni-segnale con MaxMinNotte_DAX_Short). NON qui.")
[void]$RefTxt.Add("")
if($Fatale -ne ""){ [void]$RefTxt.Add("!!! FERMATO: " + $Fatale); [void]$RefTxt.Add("") }
[void]$RefTxt.Add("PROBLEMI: " + $Problemi.Count)
foreach($p in $Problemi){ [void]$RefTxt.Add("  - " + $p) }
[void]$RefTxt.Add("RILIEVI: " + $Rilievi.Count)
foreach($p in $Rilievi){ [void]$RefTxt.Add("  - " + $p) }
[void]$RefTxt.Add("")
[void]$RefTxt.Add('COME SI RIPRENDE: dalla pagina righe/RIGA_DAXREENTRY_DA_MANDARE.md, NON da')
[void]$RefTxt.Add('questa riga: $Pin nasce dentro il blocco e non sopravvive.')

$refPath = Join-Path $Cart "REFERTO_DAXREENTRY.txt"
Set-Content -LiteralPath $refPath -Value ($RefTxt -join "`r`n") -Encoding ASCII
Write-Host ($RefTxt -join "`r`n")

foreach($f in @("COMPILAZIONE_FALLITA.log")){
  $src = Join-Path $Work $f
  if(Test-Path -LiteralPath $src){ Copy-Item $src -Destination $Cart -Force }
}
$srcProva = Join-Path $Prove $ProvaNome
if(Test-Path -LiteralPath $srcProva){ Copy-Item $srcProva -Destination $Cart -Force }
$commonFiles2 = CommonFilesDir
$pt2 = Join-Path $commonFiles2 (PerTradeNome $MagicAtteso)
if(Test-Path -LiteralPath $pt2){ Copy-Item $pt2 -Destination $Cart -Force }
# griglia: Modello 4 -> suffisso "" (NON _ohlc).
$Results2 = Join-Path $Work ("risultati_prove\" + $EA)
foreach($leg in @("IS","OOS")){
  $f = Join-Path $Results2 ($EA + "_" + $Simbolo + "_" + $leg + ".csv")
  if(Test-Path -LiteralPath $f){ Copy-Item $f -Destination $Cart -Force }
}
$zip = $Cart + ".zip"
Remove-Item -LiteralPath $zip -Force -ErrorAction SilentlyContinue
Compress-Archive -Path (Join-Path $Cart "*") -DestinationPath $zip -Force
Write-Host ""
Write-Host ("CARTELLA: " + $Cart) -ForegroundColor Green
Write-Host ("ZIP DA MANDARE: " + $zip) -ForegroundColor Green
Write-Host "FILE ATTESI NELLO ZIP: REFERTO_DAXREENTRY.txt + il prova + il per-trade CSV (abtg_trades_..._769300.csv) + la griglia IS (9 passate, tick)" -ForegroundColor Gray
Write-Host "NOTA: il CSV *_OOS NON esiste MAI qui (FrazioneIS 1.0 = gamba OOS degenere)." -ForegroundColor Gray
Write-Host "      Il rosso del generico su quel file e' ATTESO: NON rilanciare." -ForegroundColor Gray

if($Fatale -ne ""){ Write-Host "ESITO: FERMATO" -ForegroundColor Red; exit 1 }
if($Problemi.Count -gt 0){ Write-Host "ESITO: COMPLETATO CON PROBLEMI" -ForegroundColor Yellow; exit 1 }
Write-Host ("ESITO: " + $Modo + " COMPLETATO") -ForegroundColor Green
exit 0
