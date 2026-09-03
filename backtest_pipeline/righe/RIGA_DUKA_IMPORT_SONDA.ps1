# =====================================================================
#  MARCATORE_RIGA_DUKA_IMPORT_SONDA_v1
#  RIGA_DUKA_IMPORT_SONDA.ps1 -- PASSO 4-5 di DUKASCOPY_PASSO0.md:
#  IMPORTA i tick Dukascopy (CSV mensili U30USD_DK_ticks_*.csv) dentro MT5
#  come CUSTOM SYMBOL U30USD_DK (CustomTicksReplace a blocchi) e poi fa la
#  SONDA di sovrapposizione coi criteri CONGELATI del par. 4a:
#    - mediana |diff bid| al minuto <= 0.05% del prezzo nativo
#    - copertura minuti >= 80%
#    - discriminante DST sui giorni delle settimane sfasate USA/EU
#    - spread mediano DK vs nativo DICHIARATO (non e' un cancello)
#  VERDETTO: tutti dentro -> OK; solo sfasati fuori -> RICONVERTI (DST);
#            altro -> CANCELLO CHIUSO (come gli _EXT in frigo).
# ---------------------------------------------------------------------
#  UN SOLO RUN fa TUTTO: lo script MQL5 (ABTG_ImportaTickEsterno) con
#  InpSoloSonda=false esegue import + sonda + verdetto nella stessa
#  esecuzione (la sonda gira SEMPRE in coda all'OnStart). InpSoloSonda=true
#  (switch -SoloSonda) RI-fa SOLO la sonda sul custom gia' importato: serve
#  DOPO una riconversione DST (i CSV cambiano -> in quel caso NON -SoloSonda:
#  si ri-importa con InpCancellaEsistente=true).
# ---------------------------------------------------------------------
#  >>> SI LANCIA SOLO SUL PC DI BACKTEST. NON e' forward. <<<
#  Lo script MQL5 e' uno SCRIPT (OnStart): non gira nel tester, gira NEL
#  TERMINALE su un grafico. Percio' questa riga LANCIA terminal64 con
#  /config [StartUp] Script=... (stesso pattern di scarica_storico.ps1).
#  Quindi PRETENDE MT5 e MetaEditor CHIUSI (un secondo avvio sulla stessa
#  cartella dati NON esegue lo startup script). Sul PC di backtest il
#  terminale e' collegato al conto VIVO 50503392: la config mette
#  [Experts] AllowLiveTrading=false, cosi' aprire il terminale NON riarma
#  gli EA su grafico (lezione 14/08, come scarica_storico.ps1).
#  L'import scrive un CUSTOM SYMBOL nella cartella dati del terminale di
#  backtest: e' un dato di backtest, non tocca il forward.
# ---------------------------------------------------------------------
#  DOVE STANNO I CSV (misurato in dukascopy_tick.py, riga 448):
#    %USERPROFILE%\dukascopy_lavoro\tick\U30USD_DK_ticks_AAAA-MM.csv
#  Lo script MQL5 li legge da MQL5\Files (FileOpen relativo, niente
#  FILE_COMMON). Percio' questa riga li COPIA in <cartella_dati>\MQL5\Files
#  PRIMA di lanciare. Dichiarato.
# ---------------------------------------------------------------------
#  LA RIGA CHE SI INCOLLA sta in righe\RIGA_DUKA_IMPORT_SONDA_DA_MANDARE.md
#  <PIN> = l'hash del commit che contiene QUESTO pacchetto (dato in chat).
#
#  CODICI D'USCITA:
#    0 = OK: cancello sonda PASSATO (o -SoloControllo passato)
#    3 = QUASI: 1-2 giorni fuori soglia -> leggere QUALI (DST?) nel referto
#    2 = SONDA NON MISURABILE / referto non fresco / timeout (parziale)
#    1 = FERMATA (gate) o CANCELLO CHIUSO (i _DK vanno in frigo)
# =====================================================================
param(
  [string]$Pin             = "",
  [switch]$SoloControllo,
  [switch]$SoloSonda,
  [string]$SimboloSorgente = "U30USD",
  [string]$SimboloDK       = "U30USD_DK",
  [int]$TimeoutMin         = 240
)
$ErrorActionPreference = "Stop"
[Threading.Thread]::CurrentThread.CurrentCulture   = [Globalization.CultureInfo]::InvariantCulture
[Threading.Thread]::CurrentThread.CurrentUICulture = [Globalization.CultureInfo]::InvariantCulture
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$INV = [Globalization.CultureInfo]::InvariantCulture

$Script    = "ABTG_ImportaTickEsterno"
$RefertoCsv= "ABTG_ImportTick_referto.csv"
$Avvio     = Get-Date
$Stamp     = $Avvio.ToString("yyyyMMdd_HHmm", $INV)
$Dsk       = Join-Path $env:USERPROFILE "Desktop"
if(-not (Test-Path -LiteralPath $Dsk)){ $Dsk = $env:USERPROFILE }
$Work      = Join-Path $env:USERPROFILE "abtg_duka_import"
$TickSrc   = Join-Path $env:USERPROFILE "dukascopy_lavoro\tick"
$RawPin    = "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$Pin"

# I giorni campione della SONDA, DENTRO la tranche-sonda 2024-10-01 -> 2025-06-16.
#  2 normali (allineamento base) + 4 nelle DUE settimane DST sfasate che
#  cadono dentro la tranche (27/10-03/11/2024 e 09/03-30/03/2025). Le altre
#  due finestre sfasate del par. 3b (ott-2025, mar-2026) sono FUORI dalla
#  tranche-sonda: si misureranno sulla tranche storica, non qui. Tutti feriali.
$GiorniSonda = "2024.11.20;2025.06.10;2024.10.29;2024.10.31;2025.03.12;2025.03.25"

$Problemi  = New-Object System.Collections.ArrayList
$Rilievi   = New-Object System.Collections.ArrayList
$Fatale    = ""
$Terminale = "n/d"
$Compilato = "NON TENTATA"
$CsvCopiati= 0
$Verdetto  = "NON MISURATO"
$EsitoSonda= "NON MISURATO"
$Modo      = "IMPORT + SONDA"
if($SoloSonda){ $Modo = "SOLO SONDA (custom gia' importato)" }
if($SoloControllo){ $Modo = "CONTROLLO (compila, prepara, NON apre MT5)" }

function Ora(){ return (Get-Date).ToString("HH:mm:ss", $INV) }
function Dico([string]$t,[string]$c="Gray"){ Write-Host ("[" + (Ora) + "] " + $t) -ForegroundColor $c }
function Titolo([string]$t){ Write-Host ""; Write-Host ("=== " + $t + " ===") -ForegroundColor Cyan }

function Scarica([string]$url,[string]$dest,[string]$marcatore){
  Remove-Item -LiteralPath $dest -Force -ErrorAction SilentlyContinue
  Invoke-WebRequest -Uri $url -OutFile $dest -UseBasicParsing -ErrorAction Stop
  if(-not (Test-Path -LiteralPath $dest)){ throw ("scarico fallito: " + $url) }
  if($marcatore -ne "" -and -not (Select-String -Path $dest -SimpleMatch -Pattern $marcatore -Quiet)){
    throw ("file scaricato SENZA il marcatore '" + $marcatore + "': " + $url)
  }
}

# somma di tutti i file sotto <dati>\bases : e' il BATTITO durante l'import
# (CustomTicksReplace fa crescere la base del custom symbol). Solo lettura.
function Battito-Basi([string]$dataFolder){
  $tot = [long]0
  $d = Join-Path $dataFolder "bases"
  if(-not (Test-Path -LiteralPath $d)){ return $tot }
  try{
    $m = Get-ChildItem -LiteralPath $d -Recurse -File -ErrorAction SilentlyContinue |
         Measure-Object -Property Length -Sum
    if($m -and $m.Sum){ $tot = [long]$m.Sum }
  }catch{}
  return $tot
}

try{
  Titolo ("DUKA IMPORT + SONDA -- " + $SimboloSorgente + " -> " + $SimboloDK + " -- modo " + $Modo)

  if($Pin -eq ""){ throw "-Pin obbligatorio: senza, girerebbe la punta del branch spacciandola per un commit congelato." }
  if($Pin -notmatch '^[0-9a-fA-F]{40}$'){ throw ("-Pin deve essere un commit di 40 caratteri esadecimali, ricevuto: " + $Pin) }
  $Pin = $Pin.ToLower()
  $RawPin = "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$Pin"

  # --- GUARDIA MT5 (checklist 7): questo lancia terminal64 con /config.
  #     Un secondo avvio sulla stessa cartella dati NON esegue lo startup
  #     script; con MetaEditor aperto la compilazione torna senza compilare.
  if(Get-Process terminal64,metaeditor64 -ErrorAction SilentlyContinue){
    throw ("MT5 O METAEDITOR APERTO. Questa riga APRE il terminale per far girare lo " +
           "SCRIPT di import: chiudi MT5 e MetaEditor sul PC di backtest e rilancia. " +
           "(NB: e' il PC di BACKTEST, non il VPS: qui chiudere MT5 non spegne nessun forward.)")
  }

  Dico ("pin ......... " + $Pin)
  Dico ("modo ........ " + $Modo)
  Dico ("simboli ..... " + $SimboloSorgente + " (nativo BCM) -> " + $SimboloDK + " (custom, tick Dukascopy)")
  Dico ("sonda ....... mediana<=0.05%, copertura>=80%, discriminante DST; verdetto par.4a")
  Dico ("giorni sonda: " + $GiorniSonda)

  Titolo "1. TERMINALE BCM + CARTELLA DATI (stesso selettore di scarica_storico / CRT_TICK_G)"
  $allTerm = @(Get-ChildItem "C:\Program Files","C:\Program Files (x86)" -Recurse -Filter "terminal64.exe" -ErrorAction SilentlyContinue)
  $cand = $allTerm | Where-Object { $_.DirectoryName -like "*BCM Markets MT5 Terminal*" -and $_.DirectoryName -notlike "*-V3*" } | Select-Object -First 1
  if(-not $cand){ $cand = $allTerm | Where-Object { $_.DirectoryName -like "*BCM Markets*" } | Select-Object -First 1 }
  if(-not $cand){ throw "terminale BCM non trovato." }
  $instDir    = $cand.DirectoryName
  $Terminal   = Join-Path $instDir "terminal64.exe"
  $MetaEditor = Join-Path $instDir "metaeditor64.exe"
  $termRoot   = Join-Path $env:APPDATA "MetaQuotes\Terminal"
  $DataFolder = (Get-ChildItem $termRoot -Directory -ErrorAction SilentlyContinue | Where-Object { $o = Join-Path $_.FullName "origin.txt"; (Test-Path $o) -and ((Get-Content $o -Raw).Trim() -ieq $instDir) } | Select-Object -First 1 -ExpandProperty FullName)
  if(-not $DataFolder){ throw ("cartella dati non trovata per " + $instDir) }
  $Terminale = $instDir
  Dico ("terminale : " + $instDir) "Yellow"
  Dico ("dati      : " + $DataFolder) "Yellow"

  Titolo "2. SCRIPT AL PIN + COMPILAZIONE (metaeditor64 diretto, lezione 22/08)"
  New-Item -ItemType Directory -Force -Path $Work | Out-Null
  $dstScr = Join-Path $DataFolder "MQL5\Scripts"
  New-Item -ItemType Directory -Force -Path $dstScr | Out-Null
  $mq5 = Join-Path $dstScr ($Script + ".mq5")
  Scarica ($RawPin + "/mql5/Scripts/" + $Script + ".mq5") $mq5 "IMP-TICK-v0-BOZZA"
  $ex5 = Join-Path $dstScr ($Script + ".ex5")
  Remove-Item -LiteralPath $ex5 -Force -ErrorAction SilentlyContinue
  $tc0 = Get-Date
  & $MetaEditor ("/compile:" + $mq5) "/log" | Out-Null
  while((-not (Test-Path -LiteralPath $ex5)) -and ((New-TimeSpan -Start $tc0 -End (Get-Date)).TotalSeconds -lt 180)){ Start-Sleep -Seconds 2 }
  if(-not (Test-Path -LiteralPath $ex5)){
    $logC = Join-Path $dstScr ($Script + ".log")
    if(Test-Path -LiteralPath $logC){
      Copy-Item $logC -Destination (Join-Path $Work "COMPILAZIONE_FALLITA.log") -Force
      Get-Content -LiteralPath $logC -Tail 40 | ForEach-Object { Write-Host $_ -ForegroundColor Red }
    }
    throw ("COMPILAZIONE FALLITA: " + $Script + " non ha prodotto l'.ex5 (era una BOZZA MAI COMPILATA: il primo compile e' un passo del lancio).")
  }
  $Compilato = "OK (" + [int]((Get-Item -LiteralPath $ex5).Length/1024) + " KB, " + (Get-Item -LiteralPath $ex5).LastWriteTime.ToString("HH:mm:ss",$INV) + ")"
  Dico ("compilato " + $Script + ": " + $Compilato) "Green"

  Titolo "3. CSV NEL POSTO DOVE LO SCRIPT LI LEGGE (MQL5\Files)"
  $filesDir = Join-Path $DataFolder "MQL5\Files"
  New-Item -ItemType Directory -Force -Path $filesDir | Out-Null
  if($SoloSonda){
    Dico "SoloSonda: NIENTE copia CSV (l'import non gira, si ri-misura solo il custom gia' dentro)." "Yellow"
  }else{
    if(-not (Test-Path -LiteralPath $TickSrc)){
      throw ("CSV NON TROVATI: manca la cartella " + $TickSrc + ". Prima va fatta la corsa DUKA (RIGA_DUKA_A): scarica i tick e produce i CSV mensili.")
    }
    $csvSrc = @(Get-ChildItem -LiteralPath $TickSrc -Filter "U30USD_DK_ticks_*.csv" -ErrorAction SilentlyContinue | Sort-Object Name)
    if($csvSrc.Count -eq 0){
      throw ("ZERO CSV in " + $TickSrc + " (maschera U30USD_DK_ticks_*.csv). La corsa DUKA non ha ancora prodotto mesi: import impossibile.")
    }
    foreach($f in $csvSrc){ Copy-Item -LiteralPath $f.FullName -Destination $filesDir -Force }
    $CsvCopiati = $csvSrc.Count
    $primo = $csvSrc[0].Name; $ultimo = $csvSrc[$csvSrc.Count-1].Name
    Dico ("copiati " + $CsvCopiati + " CSV mensili in MQL5\Files (" + $primo + " ... " + $ultimo + ")") "Green"
  }

  Titolo "4. PRESET .set (input allineati al sorgente, niente stringhe vuote)"
  $PresetDir = Join-Path $DataFolder "MQL5\Presets"
  New-Item -ItemType Directory -Force -Path $PresetDir | Out-Null
  $SetFile = Join-Path $PresetDir "abtg_duka_import.set"
  $soloSondaVal = if($SoloSonda){ "true" }else{ "false" }
  $cancellaVal  = if($SoloSonda){ "false" }else{ "true" }
  @"
InpSimboloSorgente=$SimboloSorgente
InpSimboloNuovo=$SimboloDK
InpMascheraCsv=U30USD_DK_ticks_*.csv
InpCancellaEsistente=$cancellaVal
InpBloccoTick=100000
InpSoloSonda=$soloSondaVal
InpGiorniSonda=$GiorniSonda
InpSogliaDiffPct=0.05
InpSogliaCopertura=80.0
"@ | Set-Content -LiteralPath $SetFile -Encoding ASCII
  Dico ("preset scritto: " + $SetFile) "Green"

  if($SoloControllo){
    Dico "CONTROLLO: script compilato, CSV pronti, preset scritto. NON apro MT5. La corsa vera e' la riga senza -SoloControllo." "Green"
    $Verdetto = "CONTROLLO OK (nessun import, nessuna sonda)"
    $EsitoSonda = "-"
    exit 0
  }

  Titolo "5. LANCIO MT5 (startup script, MT5 era CHIUSO) -- timeout $TimeoutMin min"
  # referto CANCELLATO prima e preteso FRESCO dopo (checklist 23)
  $RefPath = Join-Path $filesDir $RefertoCsv
  Remove-Item -LiteralPath $RefPath -Force -ErrorAction SilentlyContinue
  $t0 = Get-Date

  $Ini = Join-Path $env:TEMP "abtg_duka_import.ini"
  # [Experts] AllowLiveTrading=false: /config APRE IL TERMINALE (conto VIVO
  #  50503392 sul PC di backtest): senza questa riga aprirlo RIARMA gli EA su
  #  grafico che piazzano ordini veri (lezione 14/08). L'import lo fa uno
  #  SCRIPT, che non passa dal permesso di trading dal vivo: non ne risente.
@"
[Experts]
AllowLiveTrading=false
AllowDllImport=false

[Charts]
MaxBars=2000000000

[StartUp]
Script=$Script
ScriptParameters=abtg_duka_import.set
Symbol=$SimboloSorgente
Period=H1
"@ | Set-Content -LiteralPath $Ini -Encoding Unicode

  Start-Process -FilePath $Terminal -ArgumentList "/config:$Ini"
  Dico ("terminale avviato: /config " + $Ini) "Cyan"
  Write-Host "    (import a blocchi + sonda: puo' durare a lungo sui GB di tick; il" -ForegroundColor DarkGray
  Write-Host "     battito e' la crescita di bases\, il log stampa [i/n] per file.)" -ForegroundColor DarkGray

  $logDirW = Join-Path $DataFolder "MQL5\Logs"
  $scaduto = (Get-Date).AddMinutes($TimeoutMin)
  $ultimaBasi = -1
  $ultimoLog  = -1
  $fermoDa    = 0
  $visto      = $false
  $finito     = $false
  $ErrorActionPreference = "Continue"
  while((Get-Date) -lt $scaduto){
    Start-Sleep -Seconds 20

    # FINE = referto FRESCO (lo scrive ScriviReferto in coda all'OnStart,
    #  subito prima delle ultime Print): giudico l'ARTEFATTO, non il silenzio.
    if(Test-Path -LiteralPath $RefPath){
      $lw = (Get-Item -LiteralPath $RefPath).LastWriteTime
      if($lw -ge $t0){ $visto = $true; $finito = $true; break }
    }

    # battito: bases\ (custom ticks) + log
    $basi = Battito-Basi $DataFolder
    $logLen = 0
    if(Test-Path -LiteralPath $logDirW){
      try{
        $lm = Get-ChildItem -LiteralPath $logDirW -Filter "*.log" -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum
        if($lm -and $lm.Sum){ $logLen = [long]$lm.Sum }
      }catch{}
    }
    if($logLen -gt 0){ $visto = $true }

    if($basi -ne $ultimaBasi -or $logLen -ne $ultimoLog){
      $fermoDa = 0
      Write-Host ("  ... bases {0:N0} MB, log {1:N0} KB (vivo)" -f ($basi/1MB), ($logLen/1KB)) -ForegroundColor DarkGray
      $ultimaBasi = $basi; $ultimoLog = $logLen
    }else{
      $fermoDa += 20
      if($fermoDa -ge 1500){   # 25 minuti senza crescita ne referto
        Write-Host "  fermo da 25 minuti senza referto E senza crescita (bases/log): mi fermo." -ForegroundColor Yellow
        [void]$Problemi.Add("Nessun progresso per 25 minuti e nessun referto fresco: MT5 puo' non aver eseguito lo startup script (Max barre? script non aggiornato?). Prova in manuale: trascina " + $Script + " su un grafico " + $SimboloSorgente + " e carica il preset abtg_duka_import.set.")
        break
      }
    }
  }
  $ErrorActionPreference = "Stop"

  Dico "chiudo MT5..." "DarkGray"
  Get-Process -Name "terminal64" -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
  Start-Sleep -Seconds 3

  if(-not $visto){
    throw "TIMEOUT: nessun segno di vita da MT5 (ne log, ne referto). Controlla la scheda Esperti; in manuale trascina lo script sul grafico."
  }

  Titolo "6. LEGGO IL REFERTO DELLA SONDA (giudico l'artefatto, checklist 108/26-bis)"
  $refFresco = $false
  if(Test-Path -LiteralPath $RefPath){ $refFresco = ((Get-Item -LiteralPath $RefPath).LastWriteTime -ge $t0) }
  if(-not $refFresco){
    [void]$Problemi.Add("Il referto " + $RefertoCsv + " NON e' fresco (o assente): la corsa non e' arrivata a scriverlo. Referto PARZIALE.")
    $Verdetto = "SONDA NON MISURABILE (referto non fresco)"
  }else{
    Copy-Item -LiteralPath $RefPath -Destination (Join-Path $Work $RefertoCsv) -Force -ErrorAction SilentlyContinue
    $righe = @()
    try{ $righe = @(Import-Csv -LiteralPath $RefPath) }catch{ $righe = @() }
    if($righe.Count -eq 0){
      $Verdetto = "SONDA NON MISURABILE (referto vuoto/illeggibile)"
      [void]$Problemi.Add("Referto presente ma non parsabile come CSV.")
    }else{
      $ult = $righe[$righe.Count-1]
      if($ult.PSObject.Properties.Name -contains "Verdetto"){ $Verdetto = ("" + $ult.Verdetto).Trim() }
      if($ult.PSObject.Properties.Name -contains "EsitoSonda"){ $EsitoSonda = ("" + $ult.EsitoSonda).Trim() }
      Dico ("VERDETTO ....... " + $Verdetto) "White"
      Dico ("esito sonda .... " + $EsitoSonda) "White"
      if($ult.PSObject.Properties.Name -contains "TickScritti"){ Dico ("tick scritti ... " + $ult.TickScritti) "Gray" }
    }
  }
}
catch{
  $Fatale = ("" + $_.Exception.Message)
  Write-Host ""
  Write-Host ("!!! FERMATO: " + $Fatale) -ForegroundColor Red
}

# =====================================================================
#  RACCOLTA SUL DESKTOP + ZIP (regola righe di lancio, punto 2)
# =====================================================================
Titolo "RACCOLTA"
$Cart = Join-Path $Dsk ("DUKA_IMPORT_SONDA_" + $Stamp)
New-Item -ItemType Directory -Force -Path $Cart | Out-Null

# mappa verdetto -> codice d'uscita
$Codice = 1
$vU = $Verdetto.ToUpper()
if($Fatale -ne ""){ $Codice = 1 }
elseif($vU -like "*OK*CANCELLO PASSATO*" -or $vU -like "*OK: CANCELLO*"){ $Codice = 0 }
elseif($vU -like "*QUASI*"){ $Codice = 3 }
elseif($vU -like "*NON MISURABILE*" -or $vU -like "*MANCANTE*"){ $Codice = 2 }
elseif($vU -like "*CANCELLO CHIUSO*" -or $vU -like "*NON USARE*"){ $Codice = 1 }

$R = New-Object System.Collections.ArrayList
[void]$R.Add("=====================================================================")
[void]$R.Add(" DUKA IMPORT + SONDA -- " + $SimboloSorgente + " -> " + $SimboloDK)
[void]$R.Add("=====================================================================")
[void]$R.Add("data: " + $Avvio.ToString("yyyy-MM-dd HH:mm:ss",$INV) + "  (ORA DI AVVIO)")
[void]$R.Add("modo: " + $Modo)
[void]$R.Add("pin:  " + $Pin)
[void]$R.Add("terminale: " + $Terminale)
[void]$R.Add("compilazione: " + $Compilato)
[void]$R.Add("CSV copiati in MQL5\Files: " + $CsvCopiati)
[void]$R.Add("giorni sonda: " + $GiorniSonda)
[void]$R.Add("")
[void]$R.Add("ESITO SONDA: " + $EsitoSonda)
[void]$R.Add("VERDETTO:    " + $Verdetto)
[void]$R.Add("")
[void]$R.Add("CRITERI CONGELATI (par. 4a): mediana |diff bid| <= 0.05%, copertura >= 80%.")
[void]$R.Add("  - tutti i giorni dentro          -> OK: il custom U30USD_DK e' usabile")
[void]$R.Add("    per VERDETTI A PARAMETRI CONGELATI (NY Retest). Nessuna taratura.")
[void]$R.Add("  - SOLO i giorni delle settimane DST sfasate fuori (2024.10.29/31 e/o")
[void]$R.Add("    2025.03.12/25) -> calendario DST sbagliato: si RICONVERTE con")
[void]$R.Add("    RIGA_DUKA_A -SoloCache -Dst europa, si ri-copiano i CSV e si RI-lancia")
[void]$R.Add("    QUESTA riga (import+sonda, non -SoloSonda: i CSV sono cambiati).")
[void]$R.Add("  - altri giorni fuori             -> CANCELLO CHIUSO: i _DK in frigo,")
[void]$R.Add("    come gli _EXT HistData. Nessun 'pero' quasi'.")
[void]$R.Add("")
[void]$R.Add("SPREAD DK vs nativo: NON e' un cancello, e' DICHIARATO nel log (scheda")
[void]$R.Add("  Esperti / *.log): coi tick veri lo spread storico e' nei prezzi.")
[void]$R.Add("")
[void]$R.Add("NOTA RUNTIME (native ticks): la sonda confronta il custom con i tick")
[void]$R.Add("  NATIVI di " + $SimboloSorgente + " via CopyTicksRange. Se un giorno esce 'tick")
[void]$R.Add("  nativi=0 -> NON confrontabile', il terminale non aveva ancora la storia")
[void]$R.Add("  tick nativa di quel giorno: apri un grafico " + $SimboloSorgente + " M1, lascia")
[void]$R.Add("  che MT5 la scarichi, poi RI-lancia la sonda con -SoloSonda (non ri-importa).")
if($Fatale -ne ""){ [void]$R.Add(""); [void]$R.Add("!!! FERMATO: " + $Fatale) }
[void]$R.Add("")
[void]$R.Add("PROBLEMI: " + $Problemi.Count)
foreach($p in $Problemi){ [void]$R.Add("  - " + $p) }
[void]$R.Add("RILIEVI: " + $Rilievi.Count)
foreach($p in $Rilievi){ [void]$R.Add("  - " + $p) }

$RefTxt = Join-Path $Cart "REFERTO_DUKA_IMPORT_SONDA.txt"
Set-Content -LiteralPath $RefTxt -Value ($R -join "`r`n") -Encoding ASCII
Write-Host ($R -join "`r`n")

# copio referto CSV dello script + ultimi log + preset + eventuale log compilazione
$srcRefCsv = Join-Path $Work $RefertoCsv
if(Test-Path -LiteralPath $srcRefCsv){ Copy-Item -LiteralPath $srcRefCsv -Destination $Cart -Force }
foreach($f in @("COMPILAZIONE_FALLITA.log")){
  $s = Join-Path $Work $f
  if(Test-Path -LiteralPath $s){ Copy-Item -LiteralPath $s -Destination $Cart -Force }
}
$logDir2 = Join-Path $DataFolder "MQL5\Logs"
if(Test-Path -LiteralPath $logDir2){
  Get-ChildItem -LiteralPath $logDir2 -Filter "*.log" -ErrorAction SilentlyContinue |
    Sort-Object LastWriteTime -Descending | Select-Object -First 2 |
    ForEach-Object { Copy-Item -LiteralPath $_.FullName -Destination $Cart -Force -ErrorAction SilentlyContinue }
}

$Zip = $Cart + ".zip"
Remove-Item -LiteralPath $Zip -Force -ErrorAction SilentlyContinue
try{ Compress-Archive -Path (Join-Path $Cart "*") -DestinationPath $Zip -Force }catch{}

Write-Host ""
Write-Host ("CARTELLA: " + $Cart) -ForegroundColor Green
Write-Host ("ZIP DA MANDARE: " + $Zip) -ForegroundColor Green
Write-Host "FILE ATTESI: REFERTO_DUKA_IMPORT_SONDA.txt + ABTG_ImportTick_referto.csv + ultimi 2 *.log" -ForegroundColor Gray

# FRESCHEZZA senza metro che invecchia (checklist 110): l'atteso lo calcola
# la riga stessa dal suo avvio, NON 'adesso'.
Write-Host ""
Write-Host ("Nel REFERTO la riga 'data:' = ORA DI AVVIO (circa " + $Avvio.ToString("yyyy-MM-dd HH:mm",$INV) + "), NON l'ora attuale (" + (Get-Date).ToString("HH:mm",$INV) + ").") -ForegroundColor Cyan
Write-Host "Nel referto CSV dello script guarda la colonna Verdetto dell'ULTIMA riga." -ForegroundColor Cyan

if($Fatale -ne ""){ Write-Host ("ESITO: FERMATO -- " + $Fatale) -ForegroundColor Red; exit 1 }
Write-Host ("ESITO: " + $Verdetto + "  (codice " + $Codice + ")") -ForegroundColor $(if($Codice -eq 0){"Green"}elseif($Codice -eq 3){"Yellow"}else{"Red"})
exit $Codice
