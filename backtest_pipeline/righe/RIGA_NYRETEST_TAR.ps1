# =====================================================================
#  MARCATORE_RIGA_NYRETEST_TAR_v1
#  RIGA_NYRETEST_TAR.ps1  --  NY SESSION RETEST: TARATURA DEL GATE a tick.
#  ABTG_NySessionRetest su U30USD M15, TICK REALI (Modello 4),
#  2024.09.26->2026.06.30, GRIGLIA 4x4x3 = 48 celle:
#    InpVwapSlopeMin  0/15/30/45   (punti indice, spostamento VWAP su 5 barre)
#    InpExpansionMin  0/60/120/180 (punti indice, range di 10 barre M15)
#    InpSlLookback    3/5/7        (il prova del passo 0 diceva 3/5/8: la
#                                   griglia MT5 e' aritmetica -> 3/5/7,
#                                   scarto dichiarato nel prova)
#  MAGIC FISSO 769503 (vergine repo-wide). NIENTE gemelli: il determinismo
#  lo garantisce la cella OFF (slope 0/exp 0/sl 5), che deve RIPRODURRE il
#  PASSO 0 v5 (n 625, PF 1.002).
# ---------------------------------------------------------------------
#  LA DOMANDA: il gate costitutivo slope+espansione MORDE? Criteri congelati
#  nel prova prove\ABTG_NySessionRetest_Tar.txt PRIMA dei numeri:
#  (a) n cala e PF si muove in modo ORDINATO al crescere delle soglie;
#  (b) fascia candidata PF>=1.3 e DD<8% in un ALTOPIANO (centro, mai picco);
#  (c) confronto col nudo SOLO per-trade/risk-adjusted, MAI profitto totale;
#  (d) OFF==ON ovunque -> gate decorativo -> scarto.
#
#  >>> IL PER-TRADE CSV DEL 769503 E' SPAZZATURA PER COSTRUZIONE: 48 passate
#      scrivono lo stesso file e sopravvive l'ultima. Questa riga lo cancella
#      PRIMA della corsa (solo il 769503: MAI i per-trade di altri magic),
#      NON lo raccoglie e il referto lo dichiara. NON leggerlo.
#  >>> LA CACHE DEL TESTER E' DI NUOVO LOAD-BEARING: la cella OFF di questa
#      griglia coincide con la corsa v5 appena girata (stesso simbolo,
#      periodo, finestra, modello, deposito). Senza svuotare Tester\cache i
#      pass combacianti verrebbero RIPESCATI: niente OnTester, niente riga
#      nel CSV. Si svuota SOLO Tester\cache, MAI bases\<server>\ticks.
#  >>> IL FUSO E' QUELLO DI CASA (NON invertito): U30USD BCM = ora SERVER.
#      Seduta 14:30, flat 20:55. Il gate RIFIUTA il 9 e il 16 (ore ET/NY).
#  >>> UNA SOLA TRANCHE (FrazioneIS 1.0): la gamba OOS del generico e'
#      DEGENERE (0 giorni) e si IGNORA. Il rosso sul CSV *_OOS e' ATTESO:
#      NON rilanciare.
#
#  LA RIGA CHE SI INCOLLA sta in righe\RIGA_NYRETEST_TAR_DA_MANDARE.md
# =====================================================================
[CmdletBinding()]
param(
  [string]$Pin          = "",
  [switch]$SoloControllo,
  [string]$Simbolo      = "U30USD",
  [string]$Periodo      = "M15",
  [string]$DaQuando     = "2024.09.26",
  [string]$Fino         = "2026.06.30",  # dichiarata nel prova (@FINOA) e gattata: MAI ereditata dal default del generico
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
$Work      = Join-Path $env:USERPROFILE "abtg_nyretest_tar"
$Prove     = Join-Path $Work "prove"
$ProvaNome = $EA + "_Tar.txt"
$RawPin    = "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$Pin"

$Problemi  = New-Object System.Collections.ArrayList
$Rilievi   = New-Object System.Collections.ArrayList
$Fatale    = ""
$Terminale = "n/d"
$Compilato = "NON TENTATA"
$Simbolo_ok= "NON VERIFICATO"
$Griglia_ok= "NON VERIFICATA"
$Baseline_ok = "NON VERIFICATA"
$CacheTxt  = "NON SVUOTATA"
$BiteMap   = New-Object System.Collections.ArrayList
$Modo      = "CORSA"
if($SoloControllo){ $Modo = "CONTROLLO" }

# I FISSI della taratura: TUTTI come il PASSO 0 v5. Cambiano SOLO gli assi.
$FissiAttesi = @{ "InpEmaTrend"="200";
                  "InpVwapSlopePeriod"="5"; "InpExpansionLookback"="10";
                  "InpSlBufferPts"="300"; "InpRetestBufferPts"="0";
                  "InpCloseAtEnd"="true";
                  "InpAllowLong"="true"; "InpAllowShort"="true";
                  "InpRiskPercent"="0.65"; "InpMaxTradesPerDay"="2" }
# GLI ASSI, ESATTI: griglia dichiarata nel prova, gattata QUI riga per riga.
$AssiAttesi = @{ "InpVwapSlopeMin"="0.00||0||15||45||Y";
                 "InpExpansionMin"="0.00||0||60||180||Y";
                 "InpSlLookback"="5||3||2||7||Y" }
$SetSlope = @(0,15,30,45)
$SetExp   = @(0,60,120,180)
$SetSl    = @(3,5,7)
$NCelleAttese = 48     # 4 x 4 x 3, contate nel prova e nella scheda
$MagicFisso   = 769503 # vergine repo-wide; 769500 forward, 769501/2 passo 0
# la baseline che la cella OFF deve riprodurre (PASSO 0 v5, pin 50551fa)
$BaseTrades = 625
$BasePF     = 1.002

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
function Num([string]$s){ return [double]::Parse($s.Trim(), $INV) }

try{
  Titolo ("NY SESSION RETEST -- TARATURA DEL GATE (" + $EA + ") -- modo " + $Modo)

  if($Pin -eq ""){ throw "-Pin obbligatorio: senza, girerebbe la punta del branch spacciandola per un commit congelato." }
  if($Pin -notmatch '^[0-9a-f]{40}$'){ throw ("-Pin deve essere un commit di 40 caratteri esadecimali, ricevuto: " + $Pin) }
  if(Get-Process terminal64,metaeditor64 -ErrorAction SilentlyContinue){
    throw "MT5 O METAEDITOR APERTO: col terminale aperto il tester non gira (zero CSV), con MetaEditor aperto la compilazione torna subito senza compilare."
  }

  Dico ("pin ......... " + $Pin)
  Dico ("simbolo ..... " + $Simbolo + " " + $Periodo + " (NATIVO BCM, ora SERVER: seduta 14:30, flat 20:55)")
  Dico ("griglia ..... slope 0/15/30/45 x exp 0/60/120/180 x sl 3/5/7 = " + $NCelleAttese + " celle | magic FISSO " + $MagicFisso)
  Dico ("finestra .... " + $DaQuando + " -> " + $Fino + " (tick BCM, UNA TRANCHE, FrazioneIS " + $FrazioneIS + ")")
  Dico ("banco ....... MODELLO 4 (TICK REALI). Deposito " + $Deposito)

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

  Titolo "2. GATE SUL PROVA (griglia esatta + magic fisso + FUSO SERVER)"
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
  if($h["@FINOA"]    -ne $Fino){     throw ($ProvaNome + ": @FINOA e' '" + $h["@FINOA"] + "', atteso " + $Fino + " (stessa finestra del PASSO 0: la baseline interna vale solo a finestra identica)") }

  # GLI ASSI: esattamente 3, con NOME e GRIGLIA esatti (la cella OFF
  # slope=0/exp=0 sta dentro per costruzione: start=0 su entrambi).
  if(@($assiY).Count -ne 3){ throw ($ProvaNome + ": devono esserci ESATTAMENTE 3 assi Y (slope, exp, SlLookback). Trovati: " + @($assiY).Count + " {" + (@($assiY) -join ", ") + "}.") }
  foreach($k in @($AssiAttesi.Keys)){
    if($assiY -notcontains $k){ throw ($ProvaNome + ": manca l'asse " + $k + " (assi trovati: " + (@($assiY) -join ", ") + ").") }
    if($h[$k] -ne $AssiAttesi[$k]){ throw ($ProvaNome + ": " + $k + " e' '" + $h[$k] + "', atteso '" + $AssiAttesi[$k] + "' (griglia dichiarata nel prova, ancorata alle scale misurate del PASSO 0).") }
  }

  foreach($k in @($FissiAttesi.Keys)){
    $v = ($h[$k] -split '\|\|')[0]
    if($v -ne $FissiAttesi[$k]){ throw ($ProvaNome + ": " + $k + " e' '" + $v + "', atteso '" + $FissiAttesi[$k] + "' (i fissi sono la cella del PASSO 0: la taratura muove SOLO gli assi).") }
  }

  # MAGIC FISSO: 769503, vergine, e NON deve essere un asse.
  $mg = $h["InpMagic"] -split '\|\|'
  if($mg.Count -ne 1){ throw ($ProvaNome + ": InpMagic deve essere FISSO (un solo valore, niente ||): in griglia i gemelli non si usano e un magic-asse rifarebbe il pasticcio dei per-trade.") }
  if($mg[0] -ne ("" + $MagicFisso)){ throw ($ProvaNome + ": InpMagic e' '" + $mg[0] + "', atteso " + $MagicFisso + " (vergine repo-wide; 769500 forward, 769501/769502 passo 0).") }

  $mfloor = ($h["InpMinStopPts"] -split '\|\|')[0]
  if($mfloor -eq "0"){ throw ($ProvaNome + ": InpMinStopPts=0 VIETATO (R109): il pavimento SL e' 500 (5 punti indice), mai 0.") }
  if($mfloor -ne "500"){ throw ($ProvaNome + ": InpMinStopPts deve essere 500 (R109), trovato '" + $mfloor + "'.") }

  # GATE DEL FUSO -- QUELLO DI CASA (NON invertito): U30USD BCM = ora server.
  # Il 9 e il 16 sono le ore ET/NY dei feed _EXT: qui il gate li RIFIUTA per nome.
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

  Dico ("direttive nude, 3 assi esatti (griglia " + $NCelleAttese + " celle con la cella OFF dentro), fissi = passo 0, magic FISSO 769503, pavimento SL (R109), FUSO SERVER (14:30 / 20:55): TUTTI PASSATI") "Green"

  Titolo "3. TERMINALE E COMPILAZIONE (U30USD nativo BCM)"
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
    throw ("COMPILAZIONE FALLITA: " + $EA + " non ha prodotto l'.ex5. Gli errori sono qui sopra e in COMPILAZIONE_FALLITA.log dentro lo zip.")
  }
  $Compilato = "OK (" + [int]((Get-Item -LiteralPath $ex5).Length/1024) + " KB, " + (Get-Item -LiteralPath $ex5).LastWriteTime.ToString("HH:mm:ss",$INV) + ")"
  Dico ("compilato " + $EA + ": " + $Compilato) "Green"

  # IL PER-TRADE DEL 769503: spazzatura di griglia (48 passate, un file solo,
  # sopravvive l'ultima). Si cancella SOLO il suo, cosi' un residuo di un giro
  # precedente non si spaccia per fresco. MAI toccare i per-trade di ALTRI
  # magic (769501/769502 sono la misura del passo 0).
  $commonFiles = CommonFilesDir
  $pt503 = Join-Path $commonFiles (PerTradeNome $MagicFisso)
  Remove-Item -LiteralPath $pt503 -Force -ErrorAction SilentlyContinue
  Dico ("per-trade del 769503 cancellato se c'era (in griglia e' INUTILIZZABILE e non va letto); gli altri magic NON si toccano") "Gray"

  # LA CACHE DEL TESTER (checklist punto 38) -- DI NUOVO LOAD-BEARING: la
  # cella OFF (slope 0/exp 0/sl 5) di questa griglia coincide con la corsa v5
  # APPENA girata (stesso simbolo, periodo, finestra, modello, deposito).
  # Un pass RIPESCATO dalla cache non chiama OnTester(): niente frame,
  # niente riga nel CSV -> griglia monca senza nessun errore a schermo.
  # Si svuota SOLO Tester\cache (MAI bases\<server>\ticks, che e' lo storico).
  $cacheT = Join-Path $dataFolder "Tester\cache"
  if(Test-Path -LiteralPath $cacheT){
    $ncPrima = @(Get-ChildItem -LiteralPath $cacheT -Recurse -File -ErrorAction SilentlyContinue).Count
    Remove-Item (Join-Path $cacheT "*") -Recurse -Force -ErrorAction SilentlyContinue
    $ncDopo  = @(Get-ChildItem -LiteralPath $cacheT -Recurse -File -ErrorAction SilentlyContinue).Count
    $CacheTxt = "prima " + $ncPrima + " file, dopo " + $ncDopo
    if($ncDopo -gt 0){
      [void]$Problemi.Add("Tester\cache NON si e' svuotata (prima " + $ncPrima + ", dopo " + $ncDopo + "): i pass combacianti con le corse precedenti verrebbero RIPESCATI -> griglia monca nel CSV.")
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
    Titolo ("4. LA CORSA (generico, griglia " + $NCelleAttese + " celle, Modello 4 TICK, FrazioneIS 1.0)")
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

    # IL CSV DELLA GRIGLIA SI CONTA, NON SI Test-Path (checklist, regola 2):
    # righe dati == celle, assi con i valori CHIESTI, autotest a 0, e la
    # cella OFF che riproduce il passo 0. Tutto rimisurato QUI sugli
    # artefatti: il codice d'uscita del figlio non e' un verdetto (regola 3).
    $csvIS = Join-Path $Work ("risultati_prove\" + $EA + "\" + $EA + "_" + $Simbolo + "_IS.csv")
    if(-not (Test-Path -LiteralPath $csvIS)){
      [void]$Problemi.Add("CSV della griglia NON prodotto: " + $csvIS)
      $Griglia_ok = "NESSUN FILE"
    }
    else{
      $lin = @(Get-Content -LiteralPath $csvIS | Where-Object { $_.Trim() -ne "" })
      $nRighe = $lin.Count - 1
      if($nRighe -lt 0){ $nRighe = 0 }
      $Griglia_ok = "" + $nRighe + " righe su " + $NCelleAttese + " celle chieste"
      if($nRighe -ne $NCelleAttese){
        [void]$Problemi.Add("GRIGLIA MONCA: " + $nRighe + " righe nel CSV, " + $NCelleAttese + " celle chieste. Cache del tester non svuotata o pass falliti: la griglia non si legge.")
      }
      if($nRighe -gt 0){
        $head = $lin[0] -split ','
        $ix = @{}
        for($i2=0;$i2 -lt $head.Count;$i2++){ $ix[$head[$i2].Trim()] = $i2 }
        $servono = @("Profit Factor","Trades","Equity DD %","Autotest Falliti","InpVwapSlopeMin","InpExpansionMin","InpSlLookback")
        $manca = New-Object System.Collections.ArrayList
        foreach($cName in $servono){
          if(-not $ix.ContainsKey($cName)){ [void]$manca.Add($cName) }
        }
        if($manca.Count -gt 0){
          [void]$Problemi.Add("nel CSV mancano le colonne: " + ($manca -join ", ") + " (header cambiato nell'EA? griglia illeggibile).")
        }
        else{
          $vistiSlope = @{}; $vistiExp = @{}; $vistiSl = @{}
          $autoKo = 0
          $maxIx = 0
          foreach($cName in $servono){
            if($ix[$cName] -gt $maxIx){ $maxIx = $ix[$cName] }
          }
          $righeDati = New-Object System.Collections.ArrayList
          for($i2=1;$i2 -lt $lin.Count;$i2++){
            $c = $lin[$i2] -split ','
            if($c.Count -le $maxIx){ continue }
            $o = @{ pf = (Num $c[$ix["Profit Factor"]]);
                    tr = (Num $c[$ix["Trades"]]);
                    dd = (Num $c[$ix["Equity DD %"]]);
                    at = (Num $c[$ix["Autotest Falliti"]]);
                    sl = [math]::Round((Num $c[$ix["InpVwapSlopeMin"]]),4);
                    ex = [math]::Round((Num $c[$ix["InpExpansionMin"]]),4);
                    lb = [math]::Round((Num $c[$ix["InpSlLookback"]]),4) }
            [void]$righeDati.Add($o)
            $vistiSlope[("" + $o.sl)] = 1
            $vistiExp[("" + $o.ex)]   = 1
            $vistiSl[("" + $o.lb)]    = 1
            if($o.at -ne 0){ $autoKo++ }
          }
          if($autoKo -gt 0){ [void]$Problemi.Add("Autotest Falliti diverso da 0 in " + $autoKo + " righe: il motore DIVERGE, i numeri non si usano.") }
          $sSlope = @($vistiSlope.Keys | ForEach-Object { [double]$_ } | Sort-Object)
          $sExp   = @($vistiExp.Keys   | ForEach-Object { [double]$_ } | Sort-Object)
          $sSl    = @($vistiSl.Keys    | ForEach-Object { [double]$_ } | Sort-Object)
          if(($sSlope -join "/") -ne ($SetSlope -join "/")){ [void]$Problemi.Add("valori InpVwapSlopeMin nel CSV: " + ($sSlope -join "/") + ", chiesti " + ($SetSlope -join "/") + ".") }
          if(($sExp   -join "/") -ne ($SetExp   -join "/")){ [void]$Problemi.Add("valori InpExpansionMin nel CSV: " + ($sExp -join "/") + ", chiesti " + ($SetExp -join "/") + ".") }
          if(($sSl    -join "/") -ne ($SetSl    -join "/")){ [void]$Problemi.Add("valori InpSlLookback nel CSV: " + ($sSl -join "/") + ", chiesti " + ($SetSl -join "/") + ".") }

          # LA CELLA OFF (slope 0/exp 0/sl 5) DEVE RIPRODURRE IL PASSO 0 v5:
          # e' il determinismo del banco (qui non ci sono gemelli).
          $off = $null
          foreach($o in $righeDati){
            if($o.sl -eq 0 -and $o.ex -eq 0 -and $o.lb -eq 5){ $off = $o; break }
          }
          if($null -eq $off){
            [void]$Problemi.Add("la cella OFF (slope 0/exp 0/sl 5) NON e' nel CSV: manca la baseline interna, il confronto ON vs OFF non si fa.")
            $Baseline_ok = "CELLA OFF ASSENTE"
          }
          else{
            $Baseline_ok = "OFF: n=" + $off.tr + " PF=" + $off.pf.ToString("0.000",$INV) + " DD=" + $off.dd.ToString("0.00",$INV) + "%  (attesi dal passo 0 v5: n=" + $BaseTrades + " PF=" + $BasePF.ToString("0.000",$INV) + ")"
            $scTr = [math]::Abs($off.tr - $BaseTrades)
            $scPF = [math]::Abs($off.pf - $BasePF)
            if(($scTr -gt [math]::Ceiling($BaseTrades*0.02)) -or ($scPF -gt 0.05)){
              [void]$Problemi.Add("BASELINE NON RIPRODOTTA: la cella OFF fa n=" + $off.tr + " PF=" + $off.pf.ToString("0.000",$INV) + " contro n=" + $BaseTrades + " PF=" + $BasePF.ToString("0.000",$INV) + " del passo 0 v5 (magic diverso NON deve cambiare la logica): banco non deterministico, griglia non leggibile.")
            }
          }

          # LA MAPPA DEL MORSO (solo stampa, il verdetto e' della lettura):
          # scansioni MARGINALI a sl=5 -- n e PF per soglia. Qui si vede a
          # occhio se il gate morde (n cala, PF ordinato) o e' decorativo.
          foreach($vv in $SetSlope){
            foreach($o in $righeDati){
              if($o.lb -eq 5 -and $o.ex -eq 0 -and $o.sl -eq $vv){
                [void]$BiteMap.Add("slope>=" + $vv + " (exp 0, sl 5): n=" + $o.tr + "  PF=" + $o.pf.ToString("0.000",$INV) + "  DD=" + $o.dd.ToString("0.00",$INV) + "%")
                break
              }
            }
          }
          foreach($vv in $SetExp){
            foreach($o in $righeDati){
              if($o.lb -eq 5 -and $o.sl -eq 0 -and $o.ex -eq $vv){
                [void]$BiteMap.Add("exp>=" + $vv + " (slope 0, sl 5): n=" + $o.tr + "  PF=" + $o.pf.ToString("0.000",$INV) + "  DD=" + $o.dd.ToString("0.00",$INV) + "%")
                break
              }
            }
          }
          if($null -ne $off){
            $tuttiUguali = $true
            foreach($o in $righeDati){
              if($o.lb -ne 5){ continue }
              if($o.tr -ne $off.tr){ $tuttiUguali = $false; break }
            }
            if($tuttiUguali -and $righeDati.Count -gt 1){
              [void]$Rilievi.Add("a sl=5 TUTTE le celle hanno lo stesso n della cella OFF: quadro da GATE DECORATIVO (criterio d del prova). Il verdetto formale spetta alla lettura, ma il segnale e' questo.")
            }
          }
        }
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
$Cart = Join-Path $Dsk ("NYRETEST_TAR_" + $Modo + "_" + $Stamp)
New-Item -ItemType Directory -Force -Path $Cart | Out-Null

$RefTxt = New-Object System.Collections.ArrayList
[void]$RefTxt.Add("=====================================================================")
[void]$RefTxt.Add(" NY SESSION RETEST -- TARATURA DEL GATE a tick su " + $Simbolo + " " + $Periodo)
[void]$RefTxt.Add("=====================================================================")
[void]$RefTxt.Add("modo: " + $Modo + "   <- CONTROLLO = giro a vuoto, NON e' il risultato")
[void]$RefTxt.Add("data: " + $Avvio.ToString("yyyy-MM-dd HH:mm:ss",$INV))
[void]$RefTxt.Add("pin:  " + $Pin)
[void]$RefTxt.Add("griglia: slope 0/15/30/45 x exp 0/60/120/180 (PUNTI INDICE) x sl 3/5/7")
[void]$RefTxt.Add("         = " + $NCelleAttese + " celle | magic FISSO " + $MagicFisso + " | fissi = cella passo 0 v5")
[void]$RefTxt.Add("finestra: " + $DaQuando + " -> " + $Fino + "  (tick BCM, UNA TRANCHE, FrazioneIS " + $FrazioneIS + ")")
[void]$RefTxt.Add("banco: MODELLO 4 (TICK REALI). Deposito " + $Deposito)
[void]$RefTxt.Add("fuso: U30USD BCM = ora SERVER -> seduta 14:30, flat 20:55 (NON 9:30/16 ET).")
[void]$RefTxt.Add("terminale: " + $Terminale)
[void]$RefTxt.Add("simbolo: " + $Simbolo_ok)
[void]$RefTxt.Add("compilazione: " + $Compilato)
[void]$RefTxt.Add("cache tester: " + $CacheTxt + "   <- LOAD-BEARING: la cella OFF coincide con la corsa v5, senza svuotare verrebbe RIPESCATA")
[void]$RefTxt.Add("griglia CSV: " + $Griglia_ok)
[void]$RefTxt.Add("baseline OFF: " + $Baseline_ok)
[void]$RefTxt.Add("per-trade CSV: NON RACCOLTO E NON LEGGIBILE (magic fisso in griglia: 48 passate")
[void]$RefTxt.Add("               scrivono lo stesso file, sopravvive l'ultima -> spazzatura dichiarata).")
[void]$RefTxt.Add("")
if($BiteMap.Count -gt 0){
  [void]$RefTxt.Add("LA MAPPA DEL MORSO (scansioni marginali a sl=5 -- il gate morde se n CALA")
  [void]$RefTxt.Add("e il PF si muove in modo ORDINATO al crescere della soglia):")
  foreach($b in $BiteMap){ [void]$RefTxt.Add("  " + $b) }
  [void]$RefTxt.Add("")
}
[void]$RefTxt.Add("COME SI LEGGE (criteri CONGELATI nel prova " + $ProvaNome + "):")
[void]$RefTxt.Add("  (a) MORDE: n cala e PF ordinato al crescere delle soglie (vs cella OFF).")
[void]$RefTxt.Add("  (b) fascia candidata: PF >= 1.3 su TICK e DD < 8% in un ALTOPIANO --")
[void]$RefTxt.Add("      CENTRO, mai il picco; una cella outlier isolata non e' un altopiano.")
[void]$RefTxt.Add("  (c) confronto col nudo SOLO per-trade/risk-adjusted (PF, profit/DD,")
[void]$RefTxt.Add("      peggior giornata) -- MAI profitto totale (lezione anti-filtro 31/08).")
[void]$RefTxt.Add("  (d) OFF==ON ovunque -> gate decorativo -> scarto del candidato.")
[void]$RefTxt.Add("  La gamba OOS del generico e' DEGENERE (FrazioneIS 1.0): il rosso sul")
[void]$RefTxt.Add("  CSV *_OOS e' ATTESO, NON rilanciare.")
[void]$RefTxt.Add("")
if($Fatale -ne ""){ [void]$RefTxt.Add("!!! FERMATO: " + $Fatale); [void]$RefTxt.Add("") }
[void]$RefTxt.Add("PROBLEMI: " + $Problemi.Count)
foreach($p in $Problemi){ [void]$RefTxt.Add("  - " + $p) }
[void]$RefTxt.Add("RILIEVI: " + $Rilievi.Count)
foreach($p in $Rilievi){ [void]$RefTxt.Add("  - " + $p) }
[void]$RefTxt.Add("")
[void]$RefTxt.Add('COME SI RIPRENDE: dalla pagina righe/RIGA_NYRETEST_TAR_DA_MANDARE.md, NON')
[void]$RefTxt.Add('da questa riga: $Pin nasce dentro il blocco e non sopravvive.')

$refPath = Join-Path $Cart "REFERTO_NYRETEST_TAR.txt"
Set-Content -LiteralPath $refPath -Value ($RefTxt -join "`r`n") -Encoding ASCII
Write-Host ($RefTxt -join "`r`n")

foreach($f in @("COMPILAZIONE_FALLITA.log")){
  $src = Join-Path $Work $f
  if(Test-Path -LiteralPath $src){ Copy-Item $src -Destination $Cart -Force }
}
$srcProva = Join-Path $Prove $ProvaNome
if(Test-Path -LiteralPath $srcProva){ Copy-Item $srcProva -Destination $Cart -Force }
# griglia: Modello 4 -> suffisso "" (NON _ohlc). Il per-trade del 769503 NON
# si raccoglie (spazzatura dichiarata) e quelli di ALTRI magic non si toccano.
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
Write-Host "FILE ATTESI NELLO ZIP: REFERTO_NYRETEST_TAR.txt + il prova + la griglia (ABTG_NySessionRetest_U30USD_IS.csv, 48 righe)" -ForegroundColor Gray
Write-Host "NOTA: il CSV *_OOS NON esiste MAI qui (FrazioneIS 1.0 = gamba OOS degenere)." -ForegroundColor Gray
Write-Host "      Il rosso del generico su quel file e' ATTESO: NON rilanciare." -ForegroundColor Gray
Write-Host "      Il per-trade del 769503 NON e' nello zip: in griglia e' spazzatura." -ForegroundColor Gray

if($Fatale -ne ""){ Write-Host "ESITO: FERMATO" -ForegroundColor Red; exit 1 }
if($Problemi.Count -gt 0){ Write-Host "ESITO: COMPLETATO CON PROBLEMI" -ForegroundColor Yellow; exit 1 }
Write-Host ("ESITO: " + $Modo + " COMPLETATO") -ForegroundColor Green
exit 0
