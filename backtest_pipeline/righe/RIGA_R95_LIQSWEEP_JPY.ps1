# =====================================================================
#  MARCATORE_RIGA_R95_v5
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
#       - DIFF dei 5 file prova: 2 righe diverse su 32 (32 e' MISURATA
#         il 21/08 sull'artefatto vero, non scritta a memoria)
#    2. FASE COMPILA: metaeditor64 /compile, .ex5 SCRITTO ADESSO
#    3. PASSO 0-A: scarica lo storico M1+M15 di EURJPY dal broker
#       (-TimeoutMin esplicito). Se non gira si DICHIARA, non si finge.
#    4. PASSO 0-C - E' UN GATE, NON UN CONTORNO. Due passate SINGOLE
#       gemelle sulla cella PIU' DENSA, con magic PROPRI (779500/779501,
#       diversi da quello della griglia), derivate DAL FILE PROVA che
#       gira davvero (checklist 33: un solo artefatto), e messe in
#       SOSTA con nome proprio SUBITO, prima dei controlli (checklist
#       41: l'artefatto del gate deve esistere anche quando il gate e'
#       rosso). Si legge:
#         - G1 il per-trade esiste ed e' popolato?
#         - G2 la PRIMA DATA -> i dati coprono la finestra? (TryParse
#              guardato: "non ho potuto misurare" e "va bene" sono due
#              esiti DIVERSI)
#         - G3 i gemelli sono identici?  -> il banco e' pulito?
#         - G4 "tetto livelli raggiunto" nei log delle TRE radici, e
#              se i log letti sono ZERO l'esito e' NON LETTO, che e'
#              FATALE: un gate che non legge niente non e' verde
#         - la FREQUENZA vera            -> contro la previsione dei criteri
#       Se uno di questi e' rosso, LA CORSA NON PARTE.
#    5. la catena dei 5 file, UNO ALLA VOLTA (una macchina, un lavoro)
#    6. raccolta SEMPRE: cartella sul Desktop + zip, coi numeri attesi
#       dichiarati PRIMA. Tutto cio' che la raccolta usa nasce PRIMA del
#       try che puo' fallire, o il referto non nasce proprio nella corsa
#       fallita (checklist 41-bis). E l'ESITO guarda anche i PROBLEMI:
#       "OK con problemi in elenco" non esiste.
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
#      if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
#      $pin='<PIN>'; $p="$env:USERPROFILE\RIGA_R95.ps1"; Remove-Item $p -EA SilentlyContinue;
#      irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_R95_LIQSWEEP_JPY.ps1" -OutFile $p;
#      if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_RIGA_R95_v5' -Quiet)){ throw 'SCRIPT VECCHIO' };
#      $global:LASTEXITCODE=0; & $p -Pin $pin; if($LASTEXITCODE -ne 0){ Write-Host 'ESITO: PARZIALE O FERMO - leggi il REFERTO' } }
#
#  GIRO A VUOTO (dieci secondi, nessun MT5 aperto, nessuna passata):
#    ... & $p -Pin $pin -SoloControllo
#  Il giro a vuoto controlla ESATTAMENTE gli stessi 5 file prova che
#  girano nella corsa vera. Non c'e' un secondo artefatto (checklist 33).
# =====================================================================
param(
  # -Pin NON ha default: un default silenzioso ("lavoro") farebbe girare la
  #  punta del branch spacciandola per un commit congelato. Meglio morire.
  [string]$Pin       = "",
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
$MagicA   = 779500      # PASSO 0, passata A
$MagicB   = 779501      # PASSO 0, passata B (gemella di controllo)
$MagicGrid= 779502      # LA GRIGLIA. Magic SUO, e non e' un vezzo: ExportTrades()
                        #  gira in OnTester() a ogni passata e il nome del file
                        #  per-trade contiene il MAGIC, non la finestra. Col magic
                        #  condiviso le 30 passate cancellerebbero il per-trade su
                        #  cui il gate del PASSO 0 ha dato il via libera (e' il
                        #  difetto che i criteri par. 1.2 rimproverano a R82).
#--- RIGHE VIVE ATTESE nei file prova. MISURATA il 21/08/2026 su tutti e
#    cinque: 3 direttive @ + 29 parametri = 32. NON scritta a memoria.
#    (La prima stesura diceva 31: la riga muoriva al passo 1d prima di
#     compilare, e il ciclo saltava proprio la riga InpMagic.)
$RigheAttese = 32

#--- TUTTO CIO' CHE LA RACCOLTA USA NASCE QUI, PRIMA DEL try (checklist 41-bis).
#    Nella prima stesura $Comune nasceva DENTRO il try: su un errore precedente
#    la raccolta esplodeva su Join-Path $null e il REFERTO NON VENIVA SCRITTO
#    AFFATTO - proprio nella corsa fallita, che e' l'unica in cui serve.
$Risultati = Join-Path $Work "risultati_prove"
$Comune    = Join-Path $env:APPDATA "MetaQuotes\Terminal\Common\Files"
$Sosta     = Join-Path $Work "sosta"
$Passo0    = @{ Fatto=$false; PrimaData=""; UltimaData=""; N=0; Anni=0.0;
                Gemelli="NON MISURATO"; Tetto="NON MISURATO"; Minuti=0.0; LogLetti=0 }
$Storico   = @{ Eseguito=$false; Esito="NON ESEGUITO" }
$Problemi = New-Object System.Collections.ArrayList
$Note     = New-Object System.Collections.ArrayList
$Fatale   = ""
#  $nAnt NASCE QUI, non dentro il try: la sezione 6 la stampa nel referto e il
#  try puo' saltarne l'assegnazione a meta'. E' il 41-bis alla TERZA occasione
#  (v2: le variabili, v4: una funzione, qui: un contatore). -1 = non misurato.
$nAnt     = -1

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

#  >>> CsvDi STA QUI, SOPRA IL try, E NON E' UN CAPRICCIO DI STILE. <<<
#  In PowerShell una `function` NON e' dichiarativa: e' un'ISTRUZIONE. Se il
#  flusso non ci passa sopra, il nome NON ESISTE - e con
#  $ErrorActionPreference="Stop" la chiamata e' TERMINANTE.
#  Nella v2/v3 stava dentro il try, alla sezione 5. Ma il throw che salta la
#  sezione 5 e' IL CASO NORMALE di questa riga: tutti e quattro i gate del
#  PASSO 0 (G1, G2, G3, G4 compreso Tetto="NON LETTO") lanciano PRIMA, e cosi'
#  il passo 1d, l'1e, la compilazione e la ricerca del terminale. Risultato
#  riprodotto: "raccolta incompleta: The term 'CsvDi' is not recognized",
#  cartella VUOTA sul Desktop, NESSUN REFERTO - proprio nella corsa fermata,
#  che e' l'unica in cui il referto serve a capire perche'.
#  E' il 41-bis: in v2 era stato chiuso per le VARIABILI ($Comune, $Sosta,
#  $Risultati) e lasciato aperto per una FUNZIONE, un centimetro piu' in la'.
#  CHI LA RIPORTA DENTRO IL try RIAPRE IL DIFETTO.
#  $Ea (riga 95), $Sym (96) e $Risultati (121) nascono sopra: gia' disponibili.
function CsvDi($l,$tag){
  return (Join-Path $Risultati ($Ea + "\" + $Ea + "_" + $Sym + "_" + $tag + "_ohlc_" + $l.Et + ".csv"))
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

if($Pin -eq ""){
  Write-Host ""
  Write-Host "!!! MANCA -Pin. Questa riga gira SOLO su un commit congelato." -ForegroundColor Red
  Write-Host "    Rilancia col blocco intero, che passa -Pin <hash>." -ForegroundColor Yellow
  exit 1
}

try{

# =====================================================================
#  0. MT5 E METAEDITOR CHIUSI. Prima di qualunque altra cosa (checklist 7).
#     MetaEditor e' SINGLE-INSTANCE: se ne gira gia' una copia, il nostro
#     metaeditor64.exe /compile torna SUBITO senza aver compilato, e la
#     fase 3 dichiarerebbe "COMPILAZIONE FALLITA" su un sorgente sano.
# =====================================================================
$vivi = @(Get-Process -Name "terminal64","metaeditor64" -ErrorAction SilentlyContinue)
if($vivi.Count -gt 0){
  Write-Host ""
  Write-Host ("!!! APERTO: " + (($vivi | ForEach-Object { $_.ProcessName } | Sort-Object -Unique) -join ", ")) -ForegroundColor Red
  Write-Host "    Non parto: col terminale aperto il tester non gira (zero CSV), e con" -ForegroundColor Red
  Write-Host "    MetaEditor aperto la compilazione torna subito senza compilare." -ForegroundColor Red
  Write-Host "    Chiudi MetaTrader E MetaEditor (tutte le istanze) e rilancia." -ForegroundColor Yellow
  #  DICHIARATO AD ALTA VOCE, perche' D2 era esattamente questo: questo exit 1
  #  sta DENTRO il try e quindi SALTA LA RACCOLTA - niente cartella, niente
  #  referto, niente zip. Qui e' accettabile ed e' una scelta: siamo a due
  #  secondi dal lancio, non e' stato prodotto NIENTE, e non c'e' niente da
  #  raccogliere. Il messaggio a schermo E' il referto di questo caso.
  #  Non vale per nessun altro punto di uscita: tutti gli altri passano dal
  #  throw e quindi dalla raccolta.
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
#     stesso modello: devono differire in 2 righe su $RigheAttese (=32).
function RigheVive($p){
  return @(Get-Content -LiteralPath $p | Where-Object { $_ -notmatch '^\s*#' -and $_ -notmatch '^\s*$' })
}
$base = RigheVive (Join-Path $Prove $Lavori[0].Prova)
if($base.Count -ne $RigheAttese){ throw ("il file prova base ha " + $base.Count + " righe vive, ne attendevo " + $RigheAttese + ": artefatto cambiato, mi fermo.") }
foreach($l in $Lavori){
  if($l.Et -eq "r95a"){ continue }
  $altre = RigheVive (Join-Path $Prove $l.Prova)
  if($altre.Count -ne $RigheAttese){ throw ($l.Prova + " ha " + $altre.Count + " righe vive invece di " + $RigheAttese) }
  $div = 0; for($i=0;$i -lt $RigheAttese;$i++){ if($base[$i] -ne $altre[$i]){ $div++ } }
  if($div -ne 2){ throw ($l.Prova + " differisce dal modello in " + $div + " righe invece di 2 (attese: InpTF_Struttura e InpComment)") }
}
Dico ("diff dei 5 file prova: 2 righe su " + $RigheAttese + " ciascuno, come atteso") "Green"

# --- 1d-bis. IL MAGIC DELLA GRIGLIA, letto NELL'ARTEFATTO CHE GIRA.
#     Non basta averlo scritto nei file: si legge (checklist 34-bis).
foreach($l in $Lavori){
  $mg = [regex]::Match((Get-Content -LiteralPath (Join-Path $Prove $l.Prova) -Raw),'(?m)^InpMagic=(\d+)\r?$')
  if(-not $mg.Success){ throw ($l.Prova + ": non trovo InpMagic") }
  if([int]$mg.Groups[1].Value -ne $MagicGrid){ throw ($l.Prova + ": InpMagic e' " + $mg.Groups[1].Value + " ma la griglia deve girare su " + $MagicGrid + " (779500/779501 sono del PASSO 0)") }
}
Dico ("magic della griglia verificato nei 5 file: " + $MagicGrid + " (PASSO 0: " + $MagicA + "/" + $MagicB + ")") "Green"

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
#  Il marcatore e' 'Livelli Buttati', che esiste SOLO dalla v1.11: con
#  'Livelli Creati' (v1.10) il pin non distinguerebbe le due versioni, e
#  la colonna su cui poggia il criterio par. 3.4 potrebbe non esserci.
Scarica ("$RawPin/mql5/Experts/" + $Ea + ".mq5") (Join-Path $SrcDir ($Ea + ".mq5")) 'Livelli Buttati'
Dico ($Ea + ".mq5 scaricato al pin (marcatore v1.11: colonna 'Livelli Buttati')") "Green"

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
New-Item -ItemType Directory -Force -Path $MqlExperts,$MqlInclude,$Sosta | Out-Null
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
#     >>> SOLO se si corre davvero: un giro a vuoto che cancella gli
#         artefatti di una corsa vera fatta ieri e' un danno, non un controllo.
if($SoloControllo){
  $quanti = @(Get-ChildItem -LiteralPath $Comune -Filter ("abtg_trades_" + $Ea + "_" + $Sym + "_*.csv") -ErrorAction SilentlyContinue).Count
  Dico ("SoloControllo: NON cancello niente (per-trade presenti adesso: " + $quanti + ")") "Yellow"
} else {
  $vecchi = @(Get-ChildItem -LiteralPath $Comune -Filter ("abtg_trades_" + $Ea + "_" + $Sym + "_*.csv") -ErrorAction SilentlyContinue)
  foreach($v in $vecchi){ Remove-Item -LiteralPath $v.FullName -Force -ErrorAction SilentlyContinue }
  Dico ("per-trade vecchi rimossi: " + $vecchi.Count) "Green"
  $OptOld = Join-Path $DataFolder ("MQL5\Files\OptResults_" + $Ea + "_" + $Sym + ".csv")
  Remove-Item -LiteralPath $OptOld -Force -ErrorAction SilentlyContinue
  # --- la CACHE del tester, e SOLO quella. MAI bases\<server>\ticks: li'
  #     dentro c'e' lo storico scaricato, e ributtarlo giu' e' una nottata.
  #     La cache invece fa ripescare a MT5 passate gia' calcolate di griglie
  #     vecchie, che e' il difetto che walkforward_generico segnala alle
  #     righe 690-694 ("un pass non rieseguito NON scrive i per-trade").
  #  >>> CON -LiteralPath IL * NON E' UN WILDCARD. <<<
  #  La prima stesura faceva Remove-Item -LiteralPath (Join-Path $cache "*"):
  #  quel "*" e' il NOME LETTERALE di un file che su Windows non puo'
  #  esistere, Remove-Item non trovava niente, -EA SilentlyContinue mangiava
  #  l'errore e il Dico stampava IN VERDE i file che c'erano PRIMA. Il fix
  #  era INERTE e la console diceva di si'. (checklist 46)
  #  Nel resto dello script -LiteralPath <cartella> -Filter "*.csv" e'
  #  corretto: li' il wildcard sta nel -Filter, non nel percorso.
  #  E NON SI CREDE ALL'INTENZIONE: si conta PRIMA e DOPO.
  $cache = Join-Path $DataFolder "Tester\cache"
  if(Test-Path -LiteralPath $cache){
    $nc = @(Get-ChildItem -LiteralPath $cache -Force -Recurse -File -ErrorAction SilentlyContinue).Count
    Get-ChildItem -LiteralPath $cache -Force -ErrorAction SilentlyContinue | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue
    $nr = @(Get-ChildItem -LiteralPath $cache -Force -Recurse -File -ErrorAction SilentlyContinue).Count
    if($nr -gt 0){
      [void]$Problemi.Add("Tester\cache NON svuotata: " + $nr + " file su " + $nc + " sono rimasti. MT5 puo' ripescare passate gia' calcolate e NON scrivere i per-trade (punto 38).")
      Dico ("Tester\cache: " + $nc + " file prima, " + $nr + " RIMASTI. NON e' stata svuotata.") "Red"
    } else {
      Dico ("Tester\cache svuotata: " + $nc + " file prima, " + $nr + " dopo. bases\<server>\ticks NON toccata.") "Green"
    }
  } else { Dico "Tester\cache non esiste: niente da svuotare." "Gray" }
}

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
# --- ASPETTA L'ARTEFATTO. metaeditor64 puo' tornare prima di aver finito di
#     scrivere .ex5/.log (ed e' single-instance: la guardia sta al passo 0).
#     Senza questa attesa si dichiara "COMPILAZIONE FALLITA" su un sorgente sano.
$scad = (Get-Date).AddMinutes(5)
while((Get-Date) -lt $scad){
  if((Test-Path -LiteralPath $ex5) -and (Test-Path -LiteralPath $log)){
    if((Get-Item -LiteralPath $ex5).LastWriteTime -ge $t0){ break }
  }
  Start-Sleep -Seconds 2
}
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
# --- PASSO 0-A: LO STORICO. I criteri par. 1.3 dicono "e' dentro la riga di
#     lancio, non e' un compito a casa": eccolo. -TimeoutMin messo ESPLICITO
#     per non ereditare il default (90): NON perche' li userebbe - con
#     -SenzaTick il downloader si auto-limita a ~120 s per TF, cioe' ~4 minuti
#     in tutto. 45 e' un tetto largo e sicuro, non una stima.
#     Se non gira, NON si finge: si scrive "NON ESEGUITO" nel referto.
if(-not $SoloControllo -and -not $SaltaPasso0){
  Titolo "4-A. PASSO 0-A - LO STORICO DI EURJPY (M1 + M15) DAL BROKER"
  $ScStorico = Join-Path $Work "scarica_storico.ps1"
  try{
    Scarica ("$RawPin/backtest_pipeline/scarica_storico.ps1") $ScStorico 'REFERTO STORICO'
    #  >>> E ANCHE QUESTO GEMELLO VA PINNATO (difetto 24, seconda occorrenza). <<<
    #  scarica_storico.ps1 ha $EABranch="lavoro" scritto FISSO (riga 55) e da
    #  li' scarica ABTG_HistoryDownloader.mq5 dalla PUNTA del branch (riga 146).
    #  Cioe': la FORMULA CHE CALCOLA IL VERDETTO - quella che il fix D1 ha
    #  appena riletto riga per riga - arriverebbe NON PINNATA, mentre un'altra
    #  sessione lavora sul repo. Il fallback locale non esiste sul PC di
    #  backtest. Stesso trattamento del driver, e gate sullo STATO FINALE.
    $stTxt = Get-Content -LiteralPath $ScStorico -Raw
    $stNew = $stTxt -replace '\$EABranch\s*=\s*"lavoro"', ('$EABranch="' + $Pin + '"')
    if($stNew -eq $stTxt){ throw "non sono riuscito a pinnare EABranch in scarica_storico.ps1: riga non trovata" }
    Set-Content -LiteralPath $ScStorico -Value $stNew -Encoding ASCII
    if(-not (Select-String -LiteralPath $ScStorico -SimpleMatch -Pattern ('$EABranch="' + $Pin + '"') -Quiet)){ throw "pin di EABranch NON verificato in scarica_storico.ps1" }
    Dico ("scarica_storico.ps1 PINNATO: scarichera' ABTG_HistoryDownloader dal commit " + $Pin.Substring(0,[math]::Min(7,$Pin.Length))) "Green"
    $global:LASTEXITCODE = 0
    #  >>> -Da $DaQuando, MAI una data-catchall. <<<
    #  ABTG_HistoryDownloader.mq5 riga 200 calcola il verdetto CONTRO questo
    #  parametro:  else if(srvFirst > from + 86400) -> "IL BROKER NON HA PIU'
    #  STORICO",  con from = InpDataInizio. Con "1995.01.01" nessun broker ha
    #  EURJPY da li', quindi quel verdetto usciva PER COSTRUZIONE su M1 e su
    #  M15, a ogni corsa: due $Problemi garantiti, ESITO PARZIALE e uscita 1
    #  su una finestra perfettamente sana. La domanda giusta non e' "il broker
    #  ha il 1995?" ma "il broker copre la finestra CHE CHIEDO?".
    & powershell.exe -ExecutionPolicy Bypass -File $ScStorico -Simboli $Sym -Da $DaQuando -Timeframes "M1,M15" -SenzaTick -Auto -TimeoutMin 45 2>&1 |
      Tee-Object -FilePath (Join-Path $Logs "passo0a_storico.txt") | Out-Host
    $Storico.Eseguito = $true
    $Storico.Esito = "eseguito, uscita " + $LASTEXITCODE
    if($LASTEXITCODE -ne 0){
      #  uscita 2 = TIMEOUT: MT5 fermato a meta', referto PARZIALE ma ESISTE
      #  (scarica_storico.ps1, ultime righe). Non e' la stessa cosa di un 1.
      $che = if($LASTEXITCODE -eq 2){ "TIMEOUT dei 45 minuti: MT5 fermato a meta', il referto storico e' PARZIALE (ma c'e', e lo leggo lo stesso qui sotto)" }
             else { "errore" }
      [void]$Problemi.Add("PASSO 0-A: scarica_storico.ps1 e' uscito con codice " + $LASTEXITCODE + " -> " + $che + ". Lo scarico NON e' completo: il gate 0-C resta la misura che decide.")
    }
    $csvSt = Join-Path $DataFolder "MQL5\Files\ABTG_StoricoScaricato.csv"
    if(Test-Path -LiteralPath $csvSt){
      #  LE COLONNE VERE le scrive ABTG_HistoryDownloader.mq5 riga 140:
      #    Simbolo,Timeframe,Barre,PrimaDataLocale,PrimaDataServer,Verdetto
      #  La prima stesura leggeva $r.Stato, che NON ESISTE: PowerShell
      #  risponde $null IN SILENZIO e la nota usciva troncata, perdendo
      #  proprio "IL BROKER NON HA PIU' STORICO" - l'unica ragione per cui
      #  il PASSO 0-A esiste. (checklist 46-bis)
      #  E servono ENTRAMBE le date: PrimaDataLocale e' cio' che c'e' GIA'
      #  sul disco, PrimaDataServer e' cio' che il BROKER ha davvero.
      $vistoSym = $false
      foreach($r in (Import-Csv -LiteralPath $csvSt)){
        if(("" + $r.Simbolo).Trim().ToUpper() -ne $Sym.ToUpper()){ continue }
        $vistoSym = $true
        $verd = ("" + $r.Verdetto).Trim()
        [void]$Note.Add("PASSO 0-A: " + $r.Simbolo + " " + $r.Timeframe +
                        " | barre " + $r.Barre +
                        " | disco " + $r.PrimaDataLocale +
                        " | broker " + $r.PrimaDataServer +
                        " -> " + $(if($verd -ne ""){ $verd } else { "VERDETTO VUOTO" }))
        #  >>> LA GUARDIA SI SCRIVE AL POSITIVO. <<<
        #  I verdetti possibili sono CINQUE (ABTG_HistoryDownloader righe
        #  197-201): NESSUN DATO, server non risponde, MANCA STORICO LOCALE,
        #  IL BROKER NON HA PIU' STORICO, COMPLETO. La v3 ne trattava DUE e
        #  gli altri tre - tutti brutti - cadevano nel ramo silenzioso del
        #  "va bene". Scritta cosi', l'UNICO valore che passa e' COMPLETO:
        #  un verdetto NUOVO, o vuoto, non puo' passare per buono. (40-ter)
        if($verd -ne "COMPLETO"){
          $che = if($verd -eq ""){ "VUOTO (formato del referto cambiato: NON e' stato letto)" } else { "'" + $verd + "'" }
          [void]$Problemi.Add("PASSO 0-A: verdetto NON 'COMPLETO' su " + $r.Simbolo + " " + $r.Timeframe +
                              " -> " + $che + " | barre " + $r.Barre +
                              " | disco " + $r.PrimaDataLocale + " | broker " + $r.PrimaDataServer +
                              " | chiesto dal " + $DaQuando +
                              ".  COME SI LEGGE: 'IL BROKER NON HA PIU' STORICO' = inutile insistere, la finestra si SPOSTA. " +
                              "'MANCA STORICO LOCALE: rilancia' = e' SOLO da scaricare, e su M1 e' un esito REALISTICO ANCHE SU UNA CORSA SANA " +
                              "(il downloader insiste 120 s per TF, e 11 anni di M1 EURJPY sono ~4,1 milioni di barre: in due minuti non scendono). " +
                              "In quel caso il round E' GIRATO LO STESSO e il tester si scarica il resto da solo: NON e' 'NON HA PIU' STORICO'. " +
                              "Comunque il gate 0-C e' la misura che decide.")
        }
      }
      if(-not $vistoSym){ [void]$Problemi.Add("PASSO 0-A: nessuna riga per " + $Sym + " nel referto storico.") }
    } else { [void]$Note.Add("PASSO 0-A: ABTG_StoricoScaricato.csv non trovato, referto storico NON letto.") }
  }catch{
    $Storico.Esito = "NON ESEGUITO (" + $_.Exception.Message + ")"
    [void]$Problemi.Add("PASSO 0-A NON ESEGUITO: " + $_.Exception.Message + ". Lo storico NON e' stato scaricato: il gate 0-C resta l'unica misura.")
  }
  Dico ("PASSO 0-A: " + $Storico.Esito) "Gray"
} else {
  $Storico.Esito = "SALTATO (SoloControllo o SaltaPasso0)"
}

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
    #  >>> OGNI $ DI UNA REGEX MULTILINEA SI SCRIVE \r?$ <<<
    #  $inputs e' unito con "`r`n": in .NET il $ multilinea matcha la posizione
    #  PRIMA di \n, e con un \r davanti quella posizione non e' raggiungibile.
    #  Senza \r? questi tre -notmatch sono SEMPRE veri: il throw scattava
    #  sempre, il PASSO 0 non sarebbe partito mai, e il messaggio mandava a
    #  cercare il difetto nel file prova, che era sano. (checklist 40)
    if($inputs -match '\|\|'){ throw "PASSO 0: nell'ini e' rimasto uno sweep '||'. Sarebbe un'ottimizzazione, non una passata singola." }
    if($inputs -notmatch '(?m)^InpSwingBars=4\r?$'){ throw "PASSO 0: InpSwingBars non e' stato pinnato a 4" }
    if($inputs -notmatch '(?m)^InpTF_Struttura=30\r?$'){ throw "PASSO 0: InpTF_Struttura non e' stato pinnato a 30 (M30)" }
    if($inputs -notmatch ('(?m)^InpMagic=' + $magic + '\r?$')){ throw ("PASSO 0: InpMagic non e' stato pinnato a " + $magic) }
    if($inputs -match ('(?m)^InpMagic=' + $MagicGrid + '\r?$')){ throw "PASSO 0: sta girando col magic della GRIGLIA. Le due fasi non condividono il magic." }
    #  E il CONTEGGIO: la derivazione dal file prova deve produrre ESATTAMENTE
    #  i 29 parametri ($RigheAttese meno le 3 direttive @). Uno in meno vuol
    #  dire che una riga si e' persa nel filtro, uno in piu' che ne ha aggiunte.
    $nPar = @($out).Count
    if($nPar -ne ($RigheAttese - 3)){ throw ("PASSO 0: l'ini derivato ha " + $nPar + " parametri invece di " + ($RigheAttese - 3) + ".") }
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
  Write-Host ("    anteprima [TesterInputs] della passata A (" + ($RigheAttese - 3) + " parametri attesi):") -ForegroundColor DarkGray
  Get-Content -LiteralPath $iniA | Select-Object -Last ($RigheAttese - 2) | ForEach-Object { Write-Host ("      " + $_) -ForegroundColor DarkGray }

  if($SoloControllo){
    Dico "SoloControllo: l'ini del PASSO 0 e' scritto e verificato, MT5 NON viene aperto." "Yellow"
  } else {
    #  $tPasso0 marca l'inizio: G4 leggera' SOLO i log scritti dopo di qui,
    #  altrimenti un log di ieri risponderebbe per la corsa di oggi.
    $tPasso0 = Get-Date
    foreach($pp in @(@($iniA,$MagicA),@($iniB,$MagicB))){
      $tp = Get-Date
      Dico ("PASSO 0: passata singola magic " + $pp[1] + " su tutta la finestra...") "Cyan"
      (Start-Process -FilePath $Terminal -ArgumentList ("/config:`"" + $pp[0] + "`"") -PassThru).WaitForExit()
      $Passo0.Minuti = [math]::Round((New-TimeSpan -Start $tp -End (Get-Date)).TotalMinutes,1)
      Dico ("  ... " + $Passo0.Minuti.ToString("0.0",$INV) + " minuti") "Gray"
    }

    # --- SOSTA CON NOME PROPRIO, SUBITO, PRIMA DEI GATE (checklist 41).
    #     L'artefatto di un gate si mette al sicuro appena prodotto: cosi'
    #     esiste anche quando il gate esce ROSSO, che e' proprio il caso in
    #     cui serve. E la raccolta legge da qui, non da Common\Files.
    foreach($m in @($MagicA,$MagicB)){
      $src = Join-Path $Comune ("abtg_trades_" + $Ea + "_" + $Sym + "_" + $m + ".csv")
      if(Test-Path -LiteralPath $src){
        Copy-Item -LiteralPath $src -Destination (Join-Path $Sosta ("passo0_pertrade_" + $m + ".csv")) -Force
      }
    }
    $ptA = Join-Path $Sosta ("passo0_pertrade_" + $MagicA + ".csv")
    $ptB = Join-Path $Sosta ("passo0_pertrade_" + $MagicB + ".csv")
    Dico ("per-trade del PASSO 0 messi in sosta in " + $Sosta) "Green"

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
      #  >>> IL RITORNO DI TryParse SI GUARDA. <<<
      #  TryParse non lancia: e' fatto apposta. Con [void] davanti, una data
      #  illeggibile lasciava $d1 a MinValue, MinValue -gt 2016 e' $false e
      #  IL GATE PASSAVA - cioe' "non ho potuto misurare" e "ho misurato e va
      #  bene" finivano nello stesso ramo. (checklist 40-ter)
      $d1 = [datetime]::MinValue; $d2 = [datetime]::MinValue
      $ok1 = [datetime]::TryParse($Passo0.PrimaData.Replace(".","-"),$INV,[Globalization.DateTimeStyles]::None,[ref]$d1)
      $ok2 = [datetime]::TryParse($Passo0.UltimaData.Replace(".","-"),$INV,[Globalization.DateTimeStyles]::None,[ref]$d2)
      if(-not $ok1 -or -not $ok2){
        $Fatale = "PASSO 0 / G2: non riesco a leggere le date del per-trade (prima='" + $Passo0.PrimaData +
                  "', ultima='" + $Passo0.UltimaData + "'). IL GATE SULLA COPERTURA NON E' STATO ESEGUITO: non e' un via libera."
      } else {
        $limite = [datetime]::ParseExact("2016.01.01","yyyy.MM.dd",$INV)
        $Passo0.Anni = [math]::Round(($d2-$d1).TotalDays/365.25,2)
        if($d1 -gt $limite){
          $Fatale = "PASSO 0 / G2: la prima operazione e' del " + $Passo0.PrimaData + ", oltre il limite 2016.01.01. " +
                    "I dati NON coprono la finestra dichiarata (" + $DaQuando + "): la finestra si ridichiara e il PASSO 0 si rifa'."
        }
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
    #  LE RADICI DEI LOG SONO TRE, non una (checklist 34-ter). Le Print del
    #  tester finiscono nei log degli AGENT, che NON stanno sotto la cartella
    #  dati del terminale: la terza radice e' %APPDATA%\MetaQuotes\Tester.
    #  Con la sola Tester\logs $tetto restava SEMPRE $false e il referto
    #  scriveva "non ha morso": una delle quattro condizioni di stop non
    #  esisteva. E non c'e' alternativa via CSV, perche' gLivCreati viene
    #  incrementato anche quando il livello viene poi buttato.
    $radici = @(
      (Join-Path $DataFolder "Tester"),
      (Join-Path $InstDir    "Tester"),
      (Join-Path $env:APPDATA "MetaQuotes\Tester")
    )
    $tetto = $false; $conteggio = ""; $letti = 0
    foreach($rad in $radici){
      if(-not (Test-Path -LiteralPath $rad)){ continue }
      $files = @(Get-ChildItem -LiteralPath $rad -Filter "*.log" -Recurse -File -ErrorAction SilentlyContinue |
                 Where-Object { $_.LastWriteTime -ge $tPasso0 })
      foreach($lg in $files){
        $tx = ""
        try{
          #  ENCODING SCELTO DAL BOM, mai per decreto: i log MT5 sono UTF-16LE
          #  con BOM, ma non sempre. Un -Encoding fisso legge byte a caso e la
          #  ricerca esce verde per assenza.
          $by = [IO.File]::ReadAllBytes($lg.FullName)
          if($by.Length -ge 2 -and $by[0] -eq 0xFF -and $by[1] -eq 0xFE){ $tx = [Text.Encoding]::Unicode.GetString($by) }
          elseif($by.Length -ge 3 -and $by[0] -eq 0xEF -and $by[1] -eq 0xBB -and $by[2] -eq 0xBF){ $tx = [Text.Encoding]::UTF8.GetString($by) }
          else{ $tx = [Text.Encoding]::Default.GetString($by) }
        }catch{ continue }
        $letti++
        if($tx -match 'tetto livelli raggiunto'){ $tetto = $true }
        $mc = [regex]::Match($tx,'\[LIQSWEEP\]\[CONTEGGIO\][^\r\n]*')
        if($mc.Success){ $conteggio = $mc.Value }
      }
    }
    $Passo0.LogLetti = $letti
    if($conteggio -ne ""){ [void]$Note.Add("PASSO 0, riga del canarino nel log: " + $conteggio) }
    if($letti -eq 0){
      #  UN GATE CHE NON LEGGE NIENTE NON E' UN GATE VERDE.
      $Passo0.Tetto = "NON LETTO"
      if($Fatale -eq ""){
        $Fatale = "PASSO 0 / G4: ZERO log del tester letti nelle tre radici dopo l'avvio delle passate. " +
                  "Il gate sul tetto dei livelli NON E' STATO ESEGUITO: non e' un via libera."
      }
    } else {
      $Passo0.Tetto = if($tetto){ "HA MORSO" } else { "non ha morso" }
      if($tetto -and $Fatale -eq ""){
        $Fatale = "PASSO 0 / G4: 'tetto livelli raggiunto' nei log. InpMaxLivelli=2000 morde gia' sulla cella densa: " +
                  "si rialza il tetto PRIMA di leggere qualunque numero (e la colonna 'Livelli Buttati' dira' di quanto)."
      }
    }
    Dico ("log del tester letti: " + $letti + " (tre radici, solo file scritti dopo l'avvio)") "Gray"
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
    Write-Host ("    durata 1 passata ... " + $Passo0.Minuti.ToString("0.0",$INV) + " min su TUTTA la finestra") -ForegroundColor Yellow
    Write-Host ("    tetto teorico x30 .. " + ([math]::Round($Passo0.Minuti*30/60,1)).ToString("0.0",$INV) + " ore -- E' UN TETTO PER ECCESSO, NON UNA PREVISIONE:") -ForegroundColor Yellow
    Write-Host "                         le 30 passate coprono meta' finestra l'una (IS o OOS)" -ForegroundColor Yellow
    Write-Host "                         e MT5 le distribuisce sugli agent in PARALLELO." -ForegroundColor Yellow
    Write-Host ("    -OreMax e' " + $OreMax.ToString("0.0",$INV) + " h: e' un TETTO sull'INIZIO di nuovi file,") -ForegroundColor Yellow
    Write-Host "                         non una stima e non un'interruzione." -ForegroundColor Yellow

    if($Fatale -ne ""){ throw $Fatale }
    Dico "PASSO 0 SUPERATO: si parte." "Green"
  }
}

# =====================================================================
#  5. LA CATENA. Uno alla volta. Mai in parallelo.
# =====================================================================
Titolo ("5. LA CATENA - " + $Lavori.Count + " file, uno alla volta")
#  (CsvDi e' definita SOPRA IL try, riga ~145: vedi il commento li'.)
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
  #  -Terminal e -DataFolder passati ESPLICITI (checklist 37): il driver
  #  altrimenti ri-cerca il terminale per conto suo, e potrebbe trovarne uno
  #  diverso da quello su cui abbiamo compilato e girato il PASSO 0.
  $arg = @("-ExecutionPolicy","Bypass","-File",$Driver,
           "-Expert",$Ea,"-Prova",(Join-Path $Prove $l.Prova),
           "-Simbolo",$Sym,"-Periodo",$Periodo,
           "-DaQuando",$DaQuando,"-Fino",$Fino,
           "-Etichetta",$l.Et,"-Modello",("" + $Modello),
           "-Deposito",("" + $Deposito),
           "-Terminal",$Terminal,"-MetaEditor",$MetaEditor,"-DataFolder",$DataFolder)
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
  # --- D11: l'ANTEPRIMA del giro a vuoto. Il driver la scrive sempre con lo
  #     stesso nome (anteprima_<EA>_<Simbolo>.ini, senza etichetta): le 5
  #     chiamate si sovrascrivono e ne resterebbe UNA sola. Qui viene messa
  #     in sosta col nome del file prova, e alla fine si CONTA che siano 5.
  if($SoloControllo){
    $ant = Join-Path $Work ("anteprima_" + $Ea + "_" + $Sym + ".ini")
    if(Test-Path -LiteralPath $ant){
      Copy-Item -LiteralPath $ant -Destination (Join-Path $Sosta ("anteprima_" + $l.Et + ".ini")) -Force
      Remove-Item -LiteralPath $ant -Force -ErrorAction SilentlyContinue
    } else { [void]$Problemi.Add("giro a vuoto: nessuna anteprima .ini per " + $l.Prova) }
  }
  Write-Host ("    esito: " + $l.Esito + "   [" + $l.Min.ToString("0.0",$INV) + " min]") -ForegroundColor Gray
}

if($SoloControllo){
  $nAnt = @(Get-ChildItem -LiteralPath $Sosta -Filter "anteprima_r95*.ini" -ErrorAction SilentlyContinue).Count   # dichiarata a -1 sopra il try
  if($nAnt -ne 5){ [void]$Problemi.Add("giro a vuoto: " + $nAnt + " anteprime .ini invece di 5.") }
  Write-Host ""
  Write-Host ("    anteprime .ini in sosta: " + $nAnt + " su 5   -> " + $Sosta) -ForegroundColor White
  Write-Host "    >>> ATTENZIONE LEGGENDO L'ANTEPRIMA: la riga 'Model=4' e' una" -ForegroundColor Yellow
  Write-Host "        COSTANTE del driver (walkforward_generico.ps1 riga 514) e in" -ForegroundColor Yellow
  Write-Host "        anteprima MENTE. La corsa vera gira a Model=1 (OHLC M1)," -ForegroundColor Yellow
  Write-Host "        perche' -Modello 1 lo scrive solo nell'ini della corsa." -ForegroundColor Yellow
  Write-Host "        Cio' che nell'anteprima si legge davvero: FromDate/ToDate," -ForegroundColor Yellow
  Write-Host "        [TesterInputs], e il numero delle celle." -ForegroundColor Yellow
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
#  >>> OGNI ARTEFATTO DICE IN QUALE MODO E' STATO PRODOTTO. <<<
#  Riprodotto eseguendo: in -SoloControllo uscivano cartella, zip e referto
#  con la riga 'data:' FRESCA ed ESITO: OK, uscita 0 - IDENTICI a una corsa
#  vera, con ZERO passate. La contromisura del punto 13 (la data di adesso)
#  NON protegge, perche' quel referto e' nuovo davvero. E il giro a vuoto lo
#  PRESCRIVE il punto 5: quel file sul Desktop c'e' prima di OGNI corsa.
#  Il modo va nel NOME, non solo dentro al file. (checklist 50)
$Modo = if($SoloControllo){ "CONTROLLO" } elseif($SaltaPasso0){ "SENZAPASSO0" } else { "CORSA" }
$Cart = Join-Path $Dsk ("R95_LIQSWEEP_JPY_" + $Modo + "_" + $Stamp)
$Zip  = Join-Path $Dsk ("R95_LIQSWEEP_JPY_" + $Modo + "_" + $Stamp + ".zip")
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
  #  DALLA SOSTA, non da Common\Files: li' dentro il file col magic della
  #  griglia e' stato riscritto 30 volte, e col magic condiviso ci saremmo
  #  portati sul Desktop l'ultima passata di ottimizzazione col nome del gate.
  if($Sosta -and (Test-Path -LiteralPath $Sosta)){
    foreach($f in @(Get-ChildItem -LiteralPath $Sosta -File -ErrorAction SilentlyContinue)){
      Copy-Item -LiteralPath $f.FullName -Destination (Join-Path $Cart $f.Name) -Force
    }
  }

  $R = New-Object System.Collections.ArrayList
  [void]$R.Add("REFERTO R95 - SWEEP + RECLAIM su EURJPY M15  (OHLC M1, NON tick)")
  [void]$R.Add("modo: " + $Modo + $(if($SoloControllo){ "   <<< GIRO A VUOTO: NESSUNA passata, NESSUN CSV, NESSUN numero di round qui dentro" } else { "" }))
  [void]$R.Add("data: " + (Get-Date).ToString("yyyy-MM-dd HH:mm:ss",$INV) + "   (questa data deve essere di ADESSO)")
  [void]$R.Add("     ATTENZIONE: la data fresca NON distingue un giro a vuoto da una corsa.")
  [void]$R.Add("     Quello che lo distingue e' la riga 'modo:' qui sopra e il NOME della cartella.")
  [void]$R.Add("avvio: " + $Avvio.ToString("yyyy-MM-dd HH:mm:ss",$INV) + "   durata: " + ((New-TimeSpan -Start $Avvio -End (Get-Date)).TotalHours).ToString("0.0",$INV) + " ore")
  [void]$R.Add("pin: " + $Pin)
  [void]$R.Add("criteri: risultati_archivio\R95_CRITERI.md")
  [void]$R.Add("")
  [void]$R.Add("--- PASSO 0 (IL GATE) ---")
  [void]$R.Add("  0-A storico ........ " + $Storico.Esito + "   (chiesto dal " + $DaQuando + ", cioe' la finestra dichiarata:")
  [void]$R.Add("                       il verdetto del downloader si calcola CONTRO questa data, non contro una data-catchall)")
  [void]$R.Add("  eseguito ........... " + $Passo0.Fatto)
  [void]$R.Add("  operazioni ......... " + $Passo0.N)
  [void]$R.Add("  prima operazione ... " + $Passo0.PrimaData + "   (limite dei criteri: 2016.01.01)")
  [void]$R.Add("  ultima operazione .. " + $Passo0.UltimaData)
  [void]$R.Add("  gemelli ............ " + $Passo0.Gemelli)
  [void]$R.Add("  tetto livelli ...... " + $Passo0.Tetto + "   (log del tester letti: " + $Passo0.LogLetti + ")")
  [void]$R.Add("     NOTA: 'NON LETTO' NON e' 'non ha morso'. Un gate che non legge")
  [void]$R.Add("     niente non e' un gate verde, ed e' un esito FATALE.")
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
  [void]$R.Add("  2-bis. LA COLONNA 'Livelli Buttati', e si guarda per PRIMA fra le")
  [void]$R.Add("     colonne del canarino: se e' > 0, il tetto InpMaxLivelli ha")
  [void]$R.Add("     buttato livelli VIVI - e butta i piu' VECCHI, cioe' i piu'")
  [void]$R.Add("     AMPI. Regola congelata (criteri par. 3.4): quella cella e'")
  [void]$R.Add("     misurata con la STRUTTURA AMPUTATA, si DICHIARA e NON SI")
  [void]$R.Add("     LEGGE SUL MERITO. Se sono le celle dense, il verdetto sulla")
  [void]$R.Add("     meta' bassa della scala NON C'E'.")
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
  elseif($SoloControllo){
    [void]$R.Add("ESITO: GIRO A VUOTO COMPLETATO -- NESSUNA passata, NESSUN CSV, NESSUN")
    [void]$R.Add("       numero di round in questo file. Anteprime .ini prodotte: " + $nAnt + " su 5.")
    [void]$R.Add("       QUESTO ZIP NON E' IL ROUND: non va mandato come risultato.")
  }
  else{
    #  L'esito guarda ANCHE $Problemi: con -SaltaPasso0 il referto elencava
    #  "la copertura dei dati NON e' verificata" e chiudeva con ESITO: OK,
    #  uscita 0. Un problema in elenco non e' un round completo.
    $ko = @($Lavori | Where-Object { $_.Esito -ne "OK" -and $_.Esito -ne "SOLO CONTROLLO" })
    if($ko.Count -gt 0 -or $Problemi.Count -gt 0){
      [void]$R.Add("ESITO: PARZIALE -- " + $ko.Count + " file su " + $Lavori.Count + " non sono OK, e " + $Problemi.Count + " problemi in elenco. NON e' un round completo.")
    }
    else{ [void]$R.Add("ESITO: OK -- tutti i file hanno prodotto le righe attese, nessun problema in elenco.") }
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
#  >>> NON SI ANNUNCIA UN ARTEFATTO CHE NON ESISTE. <<<
#  E' il punto 22 (istruzioni per un artefatto mai nato) applicato alla riga
#  finale: quando un gate ferma il round la cartella puo' restare VUOTA e
#  Compress-Archive su una cartella vuota fallisce. Stampare comunque il
#  percorso dello zip manda Claudio a cercare un file che non c'e'.
#  Si guarda, e si dice quale dei tre manca.
function Riga3($path,$coda){
  if(Test-Path -LiteralPath $path){ Write-Host ("   " + $path + "   " + $coda) -ForegroundColor White }
  else                            { Write-Host ("   " + $path + "   <<< NON ESISTE") -ForegroundColor Red }
}
Riga3 $Cart    ""
Riga3 $Zip     "<- e' questo che mi mandi"
Riga3 $Referto "<- la riga 'data:' deve essere di ADESSO"
Write-Host "=====================================================================" -ForegroundColor White
if($SoloControllo){
  Write-Host ("  MODO: " + $Modo + " -- GIRO A VUOTO. NESSUNA passata, NESSUN CSV, NESSUN") -ForegroundColor Yellow
  Write-Host "        numero di round. Anteprime .ini attese: 5." -ForegroundColor Yellow
  Write-Host "        QUESTO ZIP NON E' IL ROUND e non va mandato come risultato." -ForegroundColor Yellow
} else {
  Write-Host ("  MODO: " + $Modo) -ForegroundColor White
  Write-Host "  ATTESI:  10 CSV (5 file x IS/OOS), 3 righe l'uno, 30 passate," -ForegroundColor White
  Write-Host "           piu' 2 per-trade del PASSO 0." -ForegroundColor White
}
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
if($ko.Count -gt 0 -or $Problemi.Count -gt 0){
  Write-Host ("ESITO: PARZIALE (" + $ko.Count + " file non OK, " + $Problemi.Count + " problemi)") -ForegroundColor Yellow; exit 1
}
Write-Host "ESITO: OK" -ForegroundColor Green
