# =====================================================================
#  MARCATORE_RIGA_R95_v1
#  RIGA_R95_LIQSWEEP_JPY.ps1  --  R95: sweep + reclaim su EURJPY M15
# ---------------------------------------------------------------------
#  >>> NON SI MANDA A CLAUDIO FINCHE' R95_CRITERI.md NON E' FIRMATO. <<<
#  I criteri sono una BOZZA. Questa riga esiste perche' sia pronta il
#  minuto dopo la firma, non per partire prima.
#
#  COSA FA, in ordine, e DA SOLA:
#    0. si rifiuta di partire se MT5 e' aperto (checklist 7)
#    1. scarica AL PIN driver, include, 5 file prova e il sorgente .mq5
#       - PINNA $EABranch dentro walkforward_generico.ps1 (riga 91: e'
#         scritto fisso su "lavoro", quindi senza questo un pin pinna
#         gli script e NON il motore -- difetto 24)
#       - INSTALLA ABTG_PausaGuardian.mqh, che nessun driver installa
#         (checklist 33-bis: l'EA la include e chiama
#         ABTG_AutotestGuardia(), che esiste solo dalla v1.20)
#       - aggiunge [Charts] MaxBars all'ini del tester, con gate sullo
#         STATO FINALE e non sul replace (checklist 33)
#       - DIFF dei 5 file prova: devono differire in 2 righe su 31
#    2. FASE COMPILA: metaeditor64 /compile, .ex5 SCRITTO ADESSO
#    3. PASSO 0 - E' UN GATE, NON UN CONTORNO. Due passate SINGOLE
#       gemelle sulla cella PIU' DENSA, derivate DAL FILE PROVA che
#       gira davvero (checklist 33: un solo artefatto). Si legge:
#         - la PRIMA DATA del per-trade -> i dati coprono la finestra?
#         - i gemelli sono identici?     -> il banco e' pulito?
#         - "tetto livelli raggiunto"?   -> InpMaxLivelli falsa le celle dense?
#         - la FREQUENZA vera            -> contro la previsione dei criteri
#       Se uno di questi e' rosso, LA CORSA NON PARTE.
#    4. la catena dei 5 file, UNO ALLA VOLTA (una macchina, un lavoro)
#    5. raccolta SEMPRE: cartella sul Desktop + zip, coi numeri attesi
#       dichiarati PRIMA
#
#  QUELLO CHE NON FA, dichiarato:
#    - non giudica nessun numero: produce i CSV e li conta
#    - non tocca nessuna sedia viva, nessun .set, nessun grafico
#    - non ammazza un lavoro in corso allo scadere di -OreMax: smette
#      solo di iniziarne di nuovi (checklist 19)
#
#  LA RIGA CHE SI INCOLLA (blocco INTERO, un comando solo - checklist 21).
#  <PIN> = il commit che contiene QUESTO file: e' l'hash dato in chat.
#
#  & { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
#      if(Get-Process terminal64 -EA SilentlyContinue){ throw 'MT5 APERTO: chiudilo e rilancia.' };
#      $pin='<PIN>'; $p="$env:USERPROFILE\RIGA_R95.ps1"; Remove-Item $p -EA SilentlyContinue;
#      irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_R95_LIQSWEEP_JPY.ps1" -OutFile $p;
#      if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_RIGA_R95_v1' -Quiet)){ throw 'SCRIPT VECCHIO' };
#      $global:LASTEXITCODE=0; & $p -Pin $pin; if($LASTEXITCODE -ne 0){ Write-Host 'ESITO: PARZIALE O FERMO - leggi il REFERTO' } }
#
#  GIRO A VUOTO (dieci secondi, nessun MT5 aperto, nessuna passata):
#    ... & $p -Pin $pin -SoloControllo
#  Il giro a vuoto controlla ESATTAMENTE gli stessi 5 file prova che
#  girano nella corsa vera. Non c'e' un secondo artefatto (checklist 33).
# =====================================================================
param(
  [string]$Pin       = "lavoro",
  [double]$OreMax    = 12.0,       # oltre questo NON si iniziano nuovi file
  [switch]$Rifai,
  [switch]$SoloControllo,
  [switch]$SaltaPasso0            # SOLO per rilanciare una coda gia' gatata.
                                  #   Se lo usi, il referto lo scrive in rosso.
)
$ErrorActionPreference = "Stop"
[Threading.Thread]::CurrentThread.CurrentCulture   = [Globalization.CultureInfo]::InvariantCulture
[Threading.Thread]::CurrentThread.CurrentUICulture = [Globalization.CultureInfo]::InvariantCulture
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$INV = [Globalization.CultureInfo]::InvariantCulture

$Avvio = Get-Date
$Stamp = $Avvio.ToString("yyyyMMdd_HHmm", $INV)
$Dsk   = Join-Path $env:USERPROFILE "Desktop"
$Work  = Join-Path $env:USERPROFILE "abtg_r95"
$Prove = Join-Path $Work "prove"
$Logs  = Join-Path $Work "log_r95"
$SrcDir= Join-Path $Work "src_motori"
$RawPin= "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$Pin"

$Ea       = "ABTG_LiquiditySweep"
$Sym      = "EURJPY"
$Periodo  = "M15"
$DaQuando = "2015.07.01"
$Fino     = "2026.06.30"
$Modello  = 1                 # OHLC M1: i tick BCM partono dal 2024.07.05
$Deposito = 10000
$CelleAttese = 3              # per file, per finestra
$MagicA   = 779500
$MagicB   = 779501

$Risultati = Join-Path $Work "risultati_prove"
$Problemi = New-Object System.Collections.ArrayList
$Note     = New-Object System.Collections.ArrayList
$Fatale   = ""

function Ora(){ return (Get-Date).ToString("HH:mm:ss", $INV) }
function Dico($t,$c="Gray"){ Write-Host ("[" + (Ora) + "] " + $t) -ForegroundColor $c }
function Titolo($t){ Write-Host ""; Write-Host ("=== " + $t + " ===") -ForegroundColor Cyan }

function Scarica($url,$dest,$marcatore){
  Remove-Item -LiteralPath $dest -Force -ErrorAction SilentlyContinue
  Invoke-WebRequest -Uri $url -OutFile $dest -UseBasicParsing -ErrorAction Stop
  if(-not (Test-Path -LiteralPath $dest)){ throw ("scarico fallito: " + $url) }
  if($marcatore -ne "" -and -not (Select-String -LiteralPath $dest -SimpleMatch -Pattern $marcatore -Quiet)){
    throw ("file scaricato SENZA il marcatore '" + $marcatore + "': " + $url)
  }
}

function L($f,$et,$tf){
  return [pscustomobject]@{ Prova=$f; Et=$et; Tf=$tf; Esito="NON ESEGUITO"; IS=-1; OOS=-1; Min=0.0 }
}
$Lavori = @(
  (L "R95a_liqsweep_m30_EURJPY.txt" "r95a" "M30"),
  (L "R95b_liqsweep_h1_EURJPY.txt"  "r95b" "H1"),
  (L "R95c_liqsweep_h2_EURJPY.txt"  "r95c" "H2"),
  (L "R95d_liqsweep_h3_EURJPY.txt"  "r95d" "H3"),
  (L "R95e_liqsweep_h4_EURJPY.txt"  "r95e" "H4")
)

Write-Host ""
Write-Host "#####################################################################" -ForegroundColor Cyan
Write-Host "#  R95 - SWEEP + RECLAIM su EURJPY M15   (una macchina, un lavoro)  #" -ForegroundColor Cyan
Write-Host "#####################################################################" -ForegroundColor Cyan
Dico ("pin      : " + $Pin)
Dico ("cartella : " + $Work)

# =====================================================================
#  I NUMERI ATTESI, DICHIARATI PRIMA. Se a fine corsa non tornano,
#  il round non si legge.
# =====================================================================
Titolo "NUMERI ATTESI (dichiarati PRIMA della corsa)"
Write-Host "    file prova ...................  5" -ForegroundColor White
Write-Host "    celle per file per finestra ..  3   (InpSwingBars = 4, 8, 12)" -ForegroundColor White
Write-Host "    CSV attesi ...................  10  (5 file x IS/OOS)" -ForegroundColor White
Write-Host "    righe per CSV ................  3" -ForegroundColor White
Write-Host "    passate totali ...............  30" -ForegroundColor White
Write-Host "    passate del PASSO 0 ..........  2   (gemelle, cella piu' densa)" -ForegroundColor White
Write-Host "    modello ......................  1 = OHLC M1  (OHLC, NON tick)" -ForegroundColor Yellow
Write-Host ("    finestra .....................  " + $DaQuando + " -> " + $Fino + "  (split 40/60)") -ForegroundColor White
Write-Host "    IS attesa ....................  2015.07.01 -> 2019.11.23  (CALCOLO: da verificare sull'ini)" -ForegroundColor Gray
Write-Host "    OOS attesa ...................  2019.11.24 -> 2026.06.30  (CALCOLO: da verificare sull'ini)" -ForegroundColor Gray
Write-Host ""
Write-Host "    QUANTO CI METTE: NON LO SO, ed e' un dato che manca." -ForegroundColor Yellow
Write-Host "    Nessuna corsa di questo EA su 11 anni e' mai stata fatta." -ForegroundColor Yellow
Write-Host "    Il PASSO 0 MISURA una passata intera e stampa la stima x30." -ForegroundColor Yellow

try{

# =====================================================================
#  0. MT5 CHIUSO. Prima di qualunque altra cosa (checklist 7).
# =====================================================================
if(Get-Process -Name "terminal64" -ErrorAction SilentlyContinue){
  Write-Host ""
  Write-Host "!!! MT5 E' APERTO. Non parto: il tester non gira e uscirebbero ZERO CSV." -ForegroundColor Red
  Write-Host "    Chiudi MetaTrader (tutte le istanze) e rilancia la stessa riga." -ForegroundColor Yellow
  exit 1
}

# =====================================================================
#  1. SCARICO AL PIN
# =====================================================================
Titolo "1. SCARICO AL PIN"
New-Item -ItemType Directory -Force -Path $Work,$Prove,$Logs,$SrcDir | Out-Null

$Driver = Join-Path $Work "walkforward_generico.ps1"
Scarica ("$RawPin/backtest_pipeline/walkforward_generico.ps1") $Driver 'RigaSpread'

# --- 1a. IL PIN DEL MOTORE (difetto 24). walkforward_generico.ps1 ha
#     $EABranch="lavoro" scritto FISSO alla riga 91 e riscarica il .mq5
#     dalla PUNTA del branch: senza questa riscrittura un pin pinnerebbe
#     gli script e NON il motore.
$dTxt = Get-Content -LiteralPath $Driver -Raw
$dNew = $dTxt -replace '\$EABranch\s*=\s*"lavoro"', ('$EABranch="' + $Pin + '"')
if($dNew -eq $dTxt){ throw "non sono riuscito a pinnare EABranch nel driver: riga non trovata" }

# --- 1b. IL TETTO DELLE BARRE (PASSO 0-B dei criteri). 100.000 barre M15
#     sono 4,0 anni: se il tester eredita il tetto del terminale, la IS
#     di R95 sarebbe VUOTA e i CSV uscirebbero pieni di numeri falsi.
#     [INFERITO] che il tester onori questa riga: NON e' misurato. Il
#     gate vero resta il PASSO 0-C sulla data del per-trade.
$dNew = $dNew -replace '(?m)^\[Experts\]\r?$', "[Charts]`r`nMaxBars=2000000000`r`n`r`n[Experts]"
Set-Content -LiteralPath $Driver -Value $dNew -Encoding ASCII
# --- gate sullo STATO FINALE, non sul replace (checklist 33)
if(-not (Select-String -LiteralPath $Driver -SimpleMatch -Pattern ('$EABranch="' + $Pin + '"') -Quiet)){ throw "pin di EABranch NON verificato nel driver" }
#     Le occorrenze di [Experts] nel driver sono DUE: l'anteprima del giro
#     a vuoto e l'ini della corsa vera. Devono essere toccate ENTRAMBE, o
#     il giro a vuoto controllerebbe un ini diverso da quello che gira
#     (checklist 33, corollario di traffico). Il gate conta.
$nMax = @(Select-String -LiteralPath $Driver -SimpleMatch -Pattern 'MaxBars=2000000000').Count
if($nMax -ne 2){ throw ("MaxBars scritto " + $nMax + " volte nel driver invece di 2 (anteprima + corsa vera): il driver e' cambiato, mi fermo.") }
Dico ("driver PINNATO (" + $Pin.Substring(0,[math]::Min(7,$Pin.Length)) + ") e con MaxBars alzato") "Green"

# --- 1c. I 5 FILE PROVA
foreach($l in $Lavori){ Scarica ("$RawPin/backtest_pipeline/prove/" + $l.Prova) (Join-Path $Prove $l.Prova) '@SIMBOLO' }
Dico "5 file prova scaricati al pin" "Green"

# --- 1d. IL DIFF DEI 5 FILE PROVA (checklist 33). Sono generati dallo
#     stesso modello: devono differire in 2 righe su 31.
function RigheVive($p){
  return @(Get-Content -LiteralPath $p | Where-Object { $_ -notmatch '^\s*#' -and $_ -notmatch '^\s*$' })
}
$base = RigheVive (Join-Path $Prove $Lavori[0].Prova)
if($base.Count -ne 31){ throw ("il file prova base ha " + $base.Count + " righe vive, ne attendevo 31: artefatto cambiato, mi fermo.") }
foreach($l in $Lavori){
  if($l.Et -eq "r95a"){ continue }
  $altre = RigheVive (Join-Path $Prove $l.Prova)
  if($altre.Count -ne 31){ throw ($l.Prova + " ha " + $altre.Count + " righe vive invece di 31") }
  $div = 0; for($i=0;$i -lt 31;$i++){ if($base[$i] -ne $altre[$i]){ $div++ } }
  if($div -ne 2){ throw ($l.Prova + " differisce dal modello in " + $div + " righe invece di 2 (attese: InpTF_Struttura e InpComment)") }
}
Dico "diff dei 5 file prova: 2 righe su 31 ciascuno, come atteso" "Green"

# --- 1e. IL @DAQUANDO E' SCRITTO IN DUE POSTI: nel file prova e in questo
#     driver. Il driver NON si fida del commento "se cambi qui cambia
#     anche li'": confronta (checklist 33).
foreach($l in $Lavori){
  $m = [regex]::Match((Get-Content -LiteralPath (Join-Path $Prove $l.Prova) -Raw),'(?m)^@DAQUANDO\s+([0-9]{4}\.[0-9]{2}\.[0-9]{2})')
  if(-not $m.Success){ throw ($l.Prova + ": manca @DAQUANDO") }
  if($m.Groups[1].Value -ne $DaQuando){ throw ($l.Prova + ": @DAQUANDO e' " + $m.Groups[1].Value + " ma la riga di lancio dice " + $DaQuando) }
  $s = [regex]::Match((Get-Content -LiteralPath (Join-Path $Prove $l.Prova) -Raw),'(?m)^@SIMBOLO\s+(\S+)')
  if($s.Groups[1].Value -ne $Sym){ throw ($l.Prova + ": @SIMBOLO e' " + $s.Groups[1].Value + " ma la riga dice " + $Sym) }
}
Dico ("@DAQUANDO e @SIMBOLO coincidono in tutti e 5 i file (" + $DaQuando + " / " + $Sym + ")") "Green"

# --- 1f. IL SORGENTE
Scarica ("$RawPin/mql5/Experts/" + $Ea + ".mq5") (Join-Path $SrcDir ($Ea + ".mq5")) 'Livelli Creati'
Dico ($Ea + ".mq5 scaricato al pin (marcatore v1.10: colonna 'Livelli Creati')") "Green"

# =====================================================================
#  2. TERMINALE E CARTELLA DATI (per NOME, mai il primo che capita)
# =====================================================================
Titolo "2. TERMINALE E CARTELLA DATI"
$tutti = @(Get-ChildItem "C:\Program Files","C:\Program Files (x86)" -Recurse -Filter "terminal64.exe" -ErrorAction SilentlyContinue)
$cand  = @($tutti | Where-Object { $_.DirectoryName -like "*BCM Markets MT5 Terminal*" -and $_.DirectoryName -notlike "*-V3*" })
if($cand.Count -eq 0){ throw "non trovo il terminale 'BCM Markets MT5 Terminal' (quello NON -V3). Non tiro a indovinare." }
if($cand.Count -gt 1){ throw ("trovati " + $cand.Count + " terminali che corrispondono: ambiguo, mi fermo.") }
$InstDir    = $cand[0].DirectoryName
$Terminal   = Join-Path $InstDir "terminal64.exe"
$MetaEditor = Join-Path $InstDir "metaeditor64.exe"
if(-not (Test-Path -LiteralPath $MetaEditor)){ throw ("manca metaeditor64.exe in " + $InstDir) }
$termRoot = Join-Path $env:APPDATA "MetaQuotes\Terminal"
$DataFolder = Get-ChildItem $termRoot -Directory -ErrorAction SilentlyContinue | Where-Object {
    $o = Join-Path $_.FullName "origin.txt"
    (Test-Path $o) -and ((Get-Content $o -Raw).Trim() -ieq $InstDir)
  } | Select-Object -First 1 -ExpandProperty FullName
if(-not $DataFolder){ throw "cartella dati MT5 non trovata (origin.txt non punta a nessuna cartella)." }
$MqlExperts = Join-Path $DataFolder "MQL5\Experts"
$MqlInclude = Join-Path $DataFolder "MQL5\Include"
$Comune     = Join-Path $env:APPDATA "MetaQuotes\Terminal\Common\Files"
New-Item -ItemType Directory -Force -Path $MqlExperts,$MqlInclude | Out-Null
Dico ("terminale : " + $Terminal)
Dico ("dati      : " + $DataFolder)

# --- 2a. L'INCLUDE CHE NESSUN DRIVER INSTALLA (checklist 33-bis).
#     L'EA fa #include <ABTG_PausaGuardian.mqh> e chiama
#     ABTG_AutotestGuardia(), che esiste solo dalla v1.20.
#     walkforward_generico.ps1 (riga 142) scarica SOLO il .mq5.
$mqh = Join-Path $MqlInclude "ABTG_PausaGuardian.mqh"
Scarica ("$RawPin/mql5/Include/ABTG_PausaGuardian.mqh") $mqh 'ABTG_AutotestGuardia'
$lung = (Get-Item -LiteralPath $mqh).Length
if($lung -lt 4000){ throw ("ABTG_PausaGuardian.mqh e' lungo " + $lung + " byte: troppo poco, scarico monco.") }
Dico ("include installato: ABTG_PausaGuardian.mqh (" + $lung + " byte, marcatore v1.20 presente)") "Green"

# --- 2b. PULIZIA DEI PER-TRADE VECCHI, PRIMA. Un per-trade rimasto li'
#     da un'altra corsa farebbe leggere il PASSO 0 su dati di ieri.
$vecchi = @(Get-ChildItem -LiteralPath $Comune -Filter ("abtg_trades_" + $Ea + "_" + $Sym + "_*.csv") -ErrorAction SilentlyContinue)
foreach($v in $vecchi){ Remove-Item -LiteralPath $v.FullName -Force -ErrorAction SilentlyContinue }
Dico ("per-trade vecchi rimossi: " + $vecchi.Count) "Green"
$OptOld = Join-Path $DataFolder ("MQL5\Files\OptResults_" + $Ea + "_" + $Sym + ".csv")
Remove-Item -LiteralPath $OptOld -Force -ErrorAction SilentlyContinue

# =====================================================================
#  3. FASE COMPILA. .ex5 SCRITTO ADESSO.
# =====================================================================
Titolo "3. FASE COMPILA"
$mq5 = Join-Path $MqlExperts ($Ea + ".mq5")
$ex5 = Join-Path $MqlExperts ($Ea + ".ex5")
$log = Join-Path $MqlExperts ($Ea + ".log")
$t0  = Get-Date
Copy-Item -LiteralPath (Join-Path $SrcDir ($Ea + ".mq5")) -Destination $mq5 -Force
Remove-Item -LiteralPath $ex5,$log -Force -ErrorAction SilentlyContinue
& $MetaEditor "/compile:$mq5" "/log" | Out-Null
$errori = -1
if(Test-Path -LiteralPath $log){
  $testo = ""
  try{ $testo = (Get-Content -LiteralPath $log -Raw -Encoding Unicode) }catch{ $testo = "" }
  if($testo -notmatch 'error'){ try{ $testo = (Get-Content -LiteralPath $log -Raw) }catch{} }
  $mm = [regex]::Match($testo,'(?i)(\d+)\s+error')
  if($mm.Success){ $errori = [int]$mm.Groups[1].Value }
}
$fresco = $false
if(Test-Path -LiteralPath $ex5){ $fresco = ((Get-Item -LiteralPath $ex5).LastWriteTime -ge $t0) }
if(-not $fresco -or $errori -gt 0){
  throw ("COMPILAZIONE FALLITA per " + $Ea + " (errori=" + $errori + ", ex5 fresco=" + $fresco + "). Il round si ferma qui.")
}
Dico ("COMPILATO " + $Ea) "Green"

# =====================================================================
#  4. PASSO 0 -- IL GATE. Due passate SINGOLE gemelle, cella PIU' DENSA
#     (M30 / 4 barre), derivate DAL FILE PROVA che gira davvero.
# =====================================================================
$Passo0 = @{ Fatto=$false; PrimaData=""; UltimaData=""; N=0; Anni=0.0; Gemelli="NON MISURATO"; Tetto="NON MISURATO"; Minuti=0.0 }
if($SaltaPasso0){
  [void]$Problemi.Add("PASSO 0 SALTATO SU RICHIESTA: la copertura dei dati NON e' verificata in questa corsa.")
  Write-Host "    !! PASSO 0 SALTATO. Il referto lo scrive in rosso." -ForegroundColor Red
} else {
  Titolo "4. PASSO 0 - IL GATE (2 passate singole gemelle, M30 / 4 barre)"

  # --- l'ini si DERIVA dal file prova: un solo artefatto (checklist 33)
  function IniPasso0($magic,$dest){
    $righe = @(Get-Content -LiteralPath (Join-Path $Prove "R95a_liqsweep_m30_EURJPY.txt") |
               Where-Object { $_ -notmatch '^\s*#' -and $_ -notmatch '^\s*$' -and $_ -notmatch '^@' })
    $out = New-Object System.Collections.ArrayList
    foreach($r in $righe){
      $nome = ($r -split '=')[0].Trim()
      switch($nome){
        "InpSwingBars"    { [void]$out.Add("InpSwingBars=4") }        # il gradino piu' denso
        "InpTF_Struttura" { [void]$out.Add("InpTF_Struttura=30") }    # M30, come nel file
        "InpVerbose"      { [void]$out.Add("InpVerbose=1") }          # serve il log del tetto
        "InpAutoTest"     { [void]$out.Add("InpAutoTest=1") }         # si legge UNA volta, qui
        "InpMagic"        { [void]$out.Add("InpMagic=" + $magic) }
        default           { [void]$out.Add($r) }
      }
    }
    $inputs = ($out -join "`r`n")
    # --- gate sullo STATO FINALE (checklist 33): niente sweep residui
    if($inputs -match '\|\|'){ throw "PASSO 0: nell'ini e' rimasto uno sweep '||'. Sarebbe un'ottimizzazione, non una passata singola." }
    if($inputs -notmatch '(?m)^InpSwingBars=4$'){ throw "PASSO 0: InpSwingBars non e' stato pinnato a 4" }
    if($inputs -notmatch '(?m)^InpTF_Struttura=30$'){ throw "PASSO 0: InpTF_Struttura non e' stato pinnato a 30 (M30)" }
    if($inputs -notmatch ('(?m)^InpMagic=' + $magic + '$')){ throw ("PASSO 0: InpMagic non e' stato pinnato a " + $magic) }
    $testo = @"
[Charts]
MaxBars=2000000000

[Experts]
AllowLiveTrading=false
AllowDllImport=false

[Tester]
Expert=$Ea.ex5
Symbol=$Sym
Period=$Periodo
Model=$Modello
Optimization=0
FromDate=$DaQuando
ToDate=$Fino
ForwardMode=0
Deposit=$Deposito
Currency=EUR
Leverage=100
ExecutionMode=0
ReplaceReport=1
ShutdownTerminal=1
Report=OptReport_R95_passo0_$magic

[TesterInputs]
$inputs
"@
    Set-Content -LiteralPath $dest -Value $testo -Encoding ASCII
  }

  $iniA = Join-Path $Work "passo0_a.ini"; IniPasso0 $MagicA $iniA
  $iniB = Join-Path $Work "passo0_b.ini"; IniPasso0 $MagicB $iniB
  Write-Host "    anteprima [TesterInputs] della passata A:" -ForegroundColor DarkGray
  Get-Content -LiteralPath $iniA | Select-Object -Last 32 | ForEach-Object { Write-Host ("      " + $_) -ForegroundColor DarkGray }

  if($SoloControllo){
    Dico "SoloControllo: l'ini del PASSO 0 e' scritto e verificato, MT5 NON viene aperto." "Yellow"
  } else {
    foreach($pp in @(@($iniA,$MagicA),@($iniB,$MagicB))){
      $tp = Get-Date
      Dico ("PASSO 0: passata singola magic " + $pp[1] + " su tutta la finestra...") "Cyan"
      (Start-Process -FilePath $Terminal -ArgumentList ("/config:`"" + $pp[0] + "`"") -PassThru).WaitForExit()
      $Passo0.Minuti = [math]::Round((New-TimeSpan -Start $tp -End (Get-Date)).TotalMinutes,1)
      Dico ("  ... " + $Passo0.Minuti.ToString("0.0",$INV) + " minuti") "Gray"
    }

    $ptA = Join-Path $Comune ("abtg_trades_" + $Ea + "_" + $Sym + "_" + $MagicA + ".csv")
    $ptB = Join-Path $Comune ("abtg_trades_" + $Ea + "_" + $Sym + "_" + $MagicB + ".csv")

    # --- G1: il per-trade esiste ed e' popolato
    if(-not (Test-Path -LiteralPath $ptA)){ $Fatale = "PASSO 0 / G1: nessun per-trade prodotto. Storico assente su $Sym, oppure l'EA non ha aperto niente." }
    if($Fatale -eq ""){
      $righeA = @(Get-Content -LiteralPath $ptA)
      $Passo0.N = $righeA.Count - 1
      if($Passo0.N -lt 2){ $Fatale = "PASSO 0 / G1: il per-trade ha " + $Passo0.N + " operazioni. Non c'e' niente da misurare." }
    }
    # --- G2: la PRIMA DATA. E' il gate vero sulla copertura dei dati.
    if($Fatale -eq ""){
      $Passo0.PrimaData  = (($righeA[1] -split ';')[0]).Trim()
      $Passo0.UltimaData = (($righeA[$righeA.Count-1] -split ';')[0]).Trim()
      $d1 = [datetime]::MinValue; $d2 = [datetime]::MinValue
      [void][datetime]::TryParse($Passo0.PrimaData.Replace(".","-"),$INV,[Globalization.DateTimeStyles]::None,[ref]$d1)
      [void][datetime]::TryParse($Passo0.UltimaData.Replace(".","-"),$INV,[Globalization.DateTimeStyles]::None,[ref]$d2)
      $limite = [datetime]::ParseExact("2016.01.01","yyyy.MM.dd",$INV)
      $Passo0.Anni = [math]::Round(($d2-$d1).TotalDays/365.25,2)
      if($d1 -gt $limite){
        $Fatale = "PASSO 0 / G2: la prima operazione e' del " + $Passo0.PrimaData + ", oltre il limite 2016.01.01. " +
                  "I dati NON coprono la finestra dichiarata (" + $DaQuando + "): la finestra si ridichiara e il PASSO 0 si rifa'."
      }
    }
    # --- G3: i gemelli devono essere identici
    if($Fatale -eq ""){
      if(-not (Test-Path -LiteralPath $ptB)){ $Fatale = "PASSO 0 / G3: manca il per-trade del gemello " + $MagicB }
      else{
        $a = @(Get-Content -LiteralPath $ptA); $b = @(Get-Content -LiteralPath $ptB)
        if($a.Count -ne $b.Count){ $Fatale = "PASSO 0 / G3: i gemelli hanno " + $a.Count + " e " + $b.Count + " righe. Banco sporco." }
        else{
          $div = 0
          for($i=1;$i -lt $a.Count;$i++){
            $ca = ($a[$i] -split ';'); $cb = ($b[$i] -split ';')
            if($ca[0] -ne $cb[0] -or $ca[7] -ne $cb[7]){ $div++ }
          }
          if($div -gt 0){ $Fatale = "PASSO 0 / G3: i gemelli divergono su " + $div + " operazioni. Banco sporco, il round si ferma." }
          else{ $Passo0.Gemelli = "IDENTICI" }
        }
      }
    }
    # --- G4: il tetto dei livelli ha morso?
    $logDir = Join-Path $DataFolder "Tester\logs"
    $ultimo = @(Get-ChildItem -LiteralPath $logDir -Filter "*.log" -ErrorAction SilentlyContinue |
                Sort-Object LastWriteTime -Descending | Select-Object -First 3)
    $tetto = $false; $conteggio = ""
    foreach($lg in $ultimo){
      try{ $tx = Get-Content -LiteralPath $lg.FullName -Raw -ErrorAction Stop }catch{ continue }
      if($tx -match 'tetto livelli raggiunto'){ $tetto = $true }
      $mc = [regex]::Match($tx,'\[LIQSWEEP\]\[CONTEGGIO\][^\r\n]*')
      if($mc.Success){ $conteggio = $mc.Value }
    }
    $Passo0.Tetto = if($tetto){ "HA MORSO" } else { "non ha morso" }
    if($conteggio -ne ""){ [void]$Note.Add("PASSO 0, riga del canarino nel log: " + $conteggio) }
    if($tetto -and $Fatale -eq ""){
      $Fatale = "PASSO 0 / G4: 'tetto livelli raggiunto' nel log. InpMaxLivelli=500 morde, e falserebbe SOLO le celle dense. Si rialza il tetto PRIMA di leggere qualunque numero."
    }
    $Passo0.Fatto = $true

    Write-Host ""
    Write-Host "    --- ESITO DEL PASSO 0 ---" -ForegroundColor White
    Write-Host ("    operazioni ......... " + $Passo0.N) -ForegroundColor White
    Write-Host ("    prima operazione ... " + $Passo0.PrimaData + "   (limite: 2016.01.01)") -ForegroundColor White
    Write-Host ("    ultima operazione .. " + $Passo0.UltimaData) -ForegroundColor White
    if($Passo0.Anni -gt 0){
      $freq = [math]::Round($Passo0.N / $Passo0.Anni,0)
      Write-Host ("    frequenza MISURATA . " + $freq + " op/anno su " + $Passo0.Anni.ToString("0.00",$INV) + " anni") -ForegroundColor White
      Write-Host  "    previsione nei criteri (M30 x 4 barre, 2 ore/lato): 730 op/anno" -ForegroundColor Yellow
      [void]$Note.Add("frequenza MISURATA cella densa: " + $freq + " op/anno contro 730 previsti nei criteri")
    }
    Write-Host ("    gemelli ............ " + $Passo0.Gemelli) -ForegroundColor White
    Write-Host ("    tetto livelli ...... " + $Passo0.Tetto) -ForegroundColor White
    Write-Host ("    durata 1 passata ... " + $Passo0.Minuti.ToString("0.0",$INV) + " min  -> STIMA 30 passate: " + ([math]::Round($Passo0.Minuti*30/60,1)).ToString("0.0",$INV) + " ore") -ForegroundColor Yellow

    if($Fatale -ne ""){ throw $Fatale }
    Dico "PASSO 0 SUPERATO: si parte." "Green"
  }
}

# =====================================================================
#  5. LA CATENA. Uno alla volta. Mai in parallelo.
# =====================================================================
Titolo ("5. LA CATENA - " + $Lavori.Count + " file, uno alla volta")
function CsvDi($l,$tag){
  return (Join-Path $Risultati ($Ea + "\" + $Ea + "_" + $Sym + "_" + $tag + "_ohlc_" + $l.Et + ".csv"))
}
$idx = 0
foreach($l in $Lavori){
  $idx++
  $trascorse = (New-TimeSpan -Start $Avvio -End (Get-Date)).TotalHours
  if($trascorse -ge $OreMax){
    $l.Esito = "NON INIZIATO (tetto ore raggiunto)"
    [void]$Problemi.Add("TEMPO SCADUTO prima di " + $l.Prova + ": il round NON e' completo.")
    continue
  }
  Write-Host ""
  Write-Host "------------------------------------------------------------------" -ForegroundColor Cyan
  Write-Host ("  [" + $idx + "/" + $Lavori.Count + "]  " + $l.Prova + "   (struttura " + $l.Tf + ", 6 passate)") -ForegroundColor Cyan
  Write-Host "------------------------------------------------------------------" -ForegroundColor Cyan
  $tl = Get-Date
  $arg = @("-ExecutionPolicy","Bypass","-File",$Driver,
           "-Expert",$Ea,"-Prova",(Join-Path $Prove $l.Prova),
           "-Simbolo",$Sym,"-Periodo",$Periodo,
           "-DaQuando",$DaQuando,"-Fino",$Fino,
           "-Etichetta",$l.Et,"-Modello",("" + $Modello),
           "-Deposito",("" + $Deposito))
  if($Rifai){ $arg += "-Rifai" }
  if($SoloControllo){ $arg += "-SoloControllo" }
  $global:LASTEXITCODE = 0
  try{
    & powershell.exe $arg 2>&1 | Tee-Object -FilePath (Join-Path $Logs ($l.Et + ".txt")) | Out-Host
  }catch{
    [void]$Problemi.Add($l.Prova + ": il driver e' uscito con eccezione - " + $_.Exception.Message)
  }
  if($LASTEXITCODE -ne 0){
    [void]$Problemi.Add($l.Prova + ": il driver e' uscito con codice " + $LASTEXITCODE)
  }
  $l.Min = [math]::Round((New-TimeSpan -Start $tl -End (Get-Date)).TotalMinutes,1)
  if(-not $SoloControllo){
    foreach($tag in @("IS","OOS")){
      $p = CsvDi $l $tag
      $n = -1; if(Test-Path -LiteralPath $p){ $n = (@(Get-Content -LiteralPath $p).Count) - 1 }
      if($tag -eq "IS"){ $l.IS = $n } else { $l.OOS = $n }
    }
    if($l.IS -eq $CelleAttese -and $l.OOS -eq $CelleAttese){ $l.Esito = "OK" }
    else{
      $l.Esito = "RIGHE SBAGLIATE (IS " + $l.IS + " / OOS " + $l.OOS + ", attese " + $CelleAttese + ")"
      [void]$Problemi.Add($l.Prova + ": " + $l.Esito + ". Cache del tester, oppure l'enum non ha spazzolato: il file NON si legge.")
    }
  } else { $l.Esito = "SOLO CONTROLLO" }
  Write-Host ("    esito: " + $l.Esito + "   [" + $l.Min.ToString("0.0",$INV) + " min]") -ForegroundColor Gray
}

}catch{
  $Fatale = $_.Exception.Message
  Write-Host ""
  Write-Host ("!!! FERMATO: " + $Fatale) -ForegroundColor Red
}

# =====================================================================
#  6. RACCOLTA. Si fa SEMPRE, anche a esito parziale o fermato.
# =====================================================================
Titolo "6. RACCOLTA SUL DESKTOP"
$Cart = Join-Path $Dsk ("R95_LIQSWEEP_JPY_" + $Stamp)
$Zip  = Join-Path $Dsk ("R95_LIQSWEEP_JPY_" + $Stamp + ".zip")
$Referto = Join-Path $Cart "REFERTO_R95.txt"
try{
  New-Item -ItemType Directory -Force -Path $Cart | Out-Null
  if($Risultati){
    foreach($l in $Lavori){
      foreach($tag in @("IS","OOS")){
        $src = CsvDi $l $tag
        if(Test-Path -LiteralPath $src){ Copy-Item -LiteralPath $src -Destination (Join-Path $Cart (Split-Path -Leaf $src)) -Force }
      }
    }
  }
  foreach($m in @($MagicA,$MagicB)){
    $pt = Join-Path $Comune ("abtg_trades_" + $Ea + "_" + $Sym + "_" + $m + ".csv")
    if(Test-Path -LiteralPath $pt){ Copy-Item -LiteralPath $pt -Destination (Join-Path $Cart ("passo0_pertrade_" + $m + ".csv")) -Force }
  }

  $R = New-Object System.Collections.ArrayList
  [void]$R.Add("REFERTO R95 - SWEEP + RECLAIM su EURJPY M15  (OHLC M1, NON tick)")
  [void]$R.Add("data: " + (Get-Date).ToString("yyyy-MM-dd HH:mm:ss",$INV) + "   (questa data deve essere di ADESSO)")
  [void]$R.Add("avvio: " + $Avvio.ToString("yyyy-MM-dd HH:mm:ss",$INV) + "   durata: " + ((New-TimeSpan -Start $Avvio -End (Get-Date)).TotalHours).ToString("0.0",$INV) + " ore")
  [void]$R.Add("pin: " + $Pin)
  [void]$R.Add("criteri: risultati_archivio\R95_CRITERI.md")
  [void]$R.Add("")
  [void]$R.Add("--- PASSO 0 (IL GATE) ---")
  [void]$R.Add("  eseguito ........... " + $Passo0.Fatto)
  [void]$R.Add("  operazioni ......... " + $Passo0.N)
  [void]$R.Add("  prima operazione ... " + $Passo0.PrimaData + "   (limite dei criteri: 2016.01.01)")
  [void]$R.Add("  ultima operazione .. " + $Passo0.UltimaData)
  [void]$R.Add("  gemelli ............ " + $Passo0.Gemelli)
  [void]$R.Add("  tetto livelli ...... " + $Passo0.Tetto)
  [void]$R.Add("")
  [void]$R.Add("--- LAVORI ---   (attese: 3 righe per CSV, 10 CSV, 30 passate)")
  [void]$R.Add(("{0,-32} {1,-6} {2,-5} {3,-5} {4,-8} {5}" -f "FILE","TF","IS","OOS","MIN","ESITO"))
  foreach($l in $Lavori){
    [void]$R.Add(("{0,-32} {1,-6} {2,-5} {3,-5} {4,-8} {5}" -f $l.Prova,$l.Tf,$l.IS,$l.OOS,$l.Min.ToString("0.0",$INV),$l.Esito))
  }
  [void]$R.Add("")
  [void]$R.Add("--- COME SI LEGGE (e in che ordine) ---")
  [void]$R.Add("  1. il PASSO 0 qui sopra. Se e' rosso, i numeri sotto NON esistono.")
  [void]$R.Add("  2. il CANARINO: colonne 'Livelli Creati/Consumati/Invalidati' e")
  [void]$R.Add("     'Segnali Scartati' nei CSV, e la colonna Trades. PRIMA del PF.")
  [void]$R.Add("  3. solo dopo, il conto economico, e con la regola di selezione")
  [void]$R.Add("     dichiarata accanto: CENTRO DELL'ALTOPIANO, MAI IL PICCO.")
  [void]$R.Add("  4. OGNI numero porta scritto 'OHLC, non tick'. R95 NON produce sedie.")
  [void]$R.Add("")
  [void]$R.Add("--- NOTE ---")
  if($Note.Count -eq 0){ [void]$R.Add("  (nessuna)") }
  foreach($n in $Note){ [void]$R.Add("  - " + $n) }
  [void]$R.Add("")
  [void]$R.Add("--- PROBLEMI ---")
  if($Problemi.Count -eq 0){ [void]$R.Add("  (nessuno)") }
  foreach($p in $Problemi){ [void]$R.Add("  - " + $p) }
  [void]$R.Add("")
  if($Fatale -ne ""){ [void]$R.Add("ESITO: FERMATO -- " + $Fatale) }
  else{
    $ko = @($Lavori | Where-Object { $_.Esito -ne "OK" -and $_.Esito -ne "SOLO CONTROLLO" })
    if($ko.Count -gt 0){ [void]$R.Add("ESITO: PARZIALE -- " + $ko.Count + " file su " + $Lavori.Count + " non sono OK. NON e' un round completo.") }
    else{ [void]$R.Add("ESITO: OK -- tutti i file hanno prodotto le righe attese.") }
  }
  Set-Content -LiteralPath $Referto -Value $R -Encoding ASCII

  Remove-Item -LiteralPath $Zip -Force -ErrorAction SilentlyContinue
  Compress-Archive -Path (Join-Path $Cart "*") -DestinationPath $Zip -Force
  Dico ("zip pronto: " + $Zip) "Green"
}catch{
  Write-Host ("!! raccolta incompleta: " + $_.Exception.Message) -ForegroundColor Red
}

# =====================================================================
#  7. COSA DEVE VEDERE CLAUDIO SULLO SCHERMO
# =====================================================================
Write-Host ""
Write-Host "=====================================================================" -ForegroundColor White
Write-Host "  FINITO. File da verificare, uno per uno:" -ForegroundColor White
Write-Host ("   " + $Cart) -ForegroundColor White
Write-Host ("   " + $Zip + "   <- e' questo che mi mandi") -ForegroundColor White
Write-Host ("   " + $Referto + "   <- la riga 'data:' deve essere di ADESSO") -ForegroundColor White
Write-Host "=====================================================================" -ForegroundColor White
Write-Host "  ATTESI:  10 CSV (5 file x IS/OOS), 3 righe l'uno, 30 passate," -ForegroundColor White
Write-Host "           piu' 2 per-trade del PASSO 0." -ForegroundColor White
foreach($l in $Lavori){
  $c = "Green"; if($l.Esito -ne "OK" -and $l.Esito -ne "SOLO CONTROLLO"){ $c = "Yellow" }
  Write-Host ("   " + $l.Prova.PadRight(32) + " " + $l.Esito) -ForegroundColor $c
}
if($Problemi.Count -gt 0){
  Write-Host ""
  Write-Host "   PROBLEMI DA LEGGERE:" -ForegroundColor Red
  foreach($p in $Problemi){ Write-Host ("    - " + $p) -ForegroundColor Red }
}
Write-Host ""
if($Fatale -ne ""){ Write-Host ("ESITO: FERMATO -- " + $Fatale) -ForegroundColor Red; exit 1 }
$ko = @($Lavori | Where-Object { $_.Esito -ne "OK" -and $_.Esito -ne "SOLO CONTROLLO" })
if($ko.Count -gt 0){ Write-Host ("ESITO: PARZIALE (" + $ko.Count + " file non OK)") -ForegroundColor Yellow; exit 1 }
Write-Host "ESITO: OK" -ForegroundColor Green
