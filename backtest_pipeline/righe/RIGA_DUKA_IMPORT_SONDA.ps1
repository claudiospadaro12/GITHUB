# =====================================================================
#  MARCATORE_RIGA_DUKA_IMPORT_SONDA_v2
#  v2 (05/10/2026, piano report/PIANO_REGIME_DOW_DUKASCOPY_2026-10-05.md par. 3.1 P1):
#   - PARAMETRI: -CartellaSorgente, -Maschera (default <SimboloDK>_ticks_*.csv), -GiorniSonda
#     (default i 9 giorni NOMINATI della F2), -PulisciFiles. Prima erano cablati: la cartella
#     dukascopy_lavoro\tick, la maschera U30USD_DK_ticks_*.csv, i 6 giorni del 03/09, e il CSV
#     copiato in MQL5\Files col STESSO nome (un negativo avrebbe sovrascritto il marzo buono).
#   - la condizione (1) della F2 si controlla PER NOME: ciascuno dei giorni di -GiorniSonda deve
#     avere la sua riga MISURATA e DENTRO (mediana <= 0.05, copertura >= 80) nel file per giorno
#     scritto da ABTG_ImportaTickEsterno v1 (col SIMBOLO su ogni riga). Il verdetto "OK: CANCELLO
#     PASSATO" dell'importer NON basta: salta in silenzio i giorni non confrontabili (r.498).
#     Se il verdetto e' OK ma un giorno nominato non e' dentro, il codice d'uscita e' 4, non 0.
#   - il file per giorno e il referto si copiano in Work CON IL NOME DEL SIMBOLO e si cancellano
#     all'inizio (una corsa che muore non spaccia i file della corsa precedente).
#   - GUARDIA "chi LEGGE": l'importer legge TUTTI i file di MQL5\Files che combaciano con la
#     maschera, non solo quelli copiati ora: un file estraneo che combacia fa FERMARE la riga.
#   - -PulisciFiles: a fine corsa toglie da MQL5\Files SOLO i CSV copiati da questa corsa.
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
#    0 = OK: cancello sonda PASSATO E tutti i giorni NOMINATI dentro per nome (o -SoloControllo passato)
#    4 = verdetto OK ma almeno un giorno NOMINATO non e' dentro per nome (non confrontabile, assente, ripetuto, fuori)
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
  [string]$CartellaSorgente = "",
  [string]$Maschera        = "",
  [string]$GiorniSonda     = "2024.11.20;2025.06.10;2024.10.29;2024.10.31;2025.03.12;2025.03.25;2024.12.10;2025.01.14;2025.02.11",
  [switch]$PulisciFiles,
  [string]$WorkDir         = "",
  [string]$ShaMq5          = "",
  [int]$TimeoutMin         = 240
)
$ErrorActionPreference = "Stop"
[Threading.Thread]::CurrentThread.CurrentCulture   = [Globalization.CultureInfo]::InvariantCulture
[Threading.Thread]::CurrentThread.CurrentUICulture = [Globalization.CultureInfo]::InvariantCulture
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$INV = [Globalization.CultureInfo]::InvariantCulture

$Script    = "ABTG_ImportaTickEsterno"
$RefertoCsv= "ABTG_ImportTick_referto.csv"
$GiorniCsv = "ABTG_ImportTick_giorni.csv"
$SogliaDiff = 0.05
$SogliaCop  = 80.0
$Avvio     = Get-Date
$Stamp     = $Avvio.ToString("yyyyMMdd_HHmmss", $INV)
$Dsk       = Join-Path $env:USERPROFILE "Desktop"
if(-not (Test-Path -LiteralPath $Dsk)){ $Dsk = $env:USERPROFILE }
$Work      = Join-Path $env:USERPROFILE "abtg_duka_import"
if($WorkDir -ne ""){ $Work = $WorkDir }
$TickSrc   = Join-Path $env:USERPROFILE "dukascopy_lavoro\tick"
if($CartellaSorgente -ne ""){ $TickSrc = $CartellaSorgente }
$MascheraCsv = $SimboloDK + "_ticks_*.csv"
if($Maschera -ne ""){ $MascheraCsv = $Maschera }
$RawPin    = "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$Pin"

# I giorni campione della SONDA arrivano dal parametro -GiorniSonda (default: i 9 NOMINATI della F2:
#  i 6 del 03/09 = 2 normali + 4 nelle DUE settimane DST sfasate dentro la tranche 2024-10-01 -> 2025-06-16,
#  piu' i 3 invernali nuovi 2024.12.10, 2025.01.14, 2025.02.11). Tutti feriali.
$ListaGiorni = @(($GiorniSonda -split ';') | ForEach-Object { $_.Trim() } | Where-Object { $_ -ne "" })

$Problemi  = New-Object System.Collections.ArrayList
$Rilievi   = New-Object System.Collections.ArrayList
$PerNome   = New-Object System.Collections.ArrayList     # una riga per giorno NOMINATO: giorno|stato|mediana|copertura
$PerNomeOk = $false
$PerNomeNote = "NON VALUTATO (la corsa non e' arrivata al file per giorno)"
$AltroSimbolo = 0
$filesDir  = ""
$DataFolder = ""      # nasce QUI: la RACCOLTA lo usa anche quando il terminale non e' stato trovato (v1: Join-Path su $null, classe 125)
$RefertoWork = ""
$GiorniWork  = ""
$Copiati   = New-Object System.Collections.ArrayList     # i CSV copiati in MQL5\Files da QUESTA corsa (e solo quelli: -PulisciFiles)
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

# La condizione (1) della F2, PER NOME. Una riga per ciascun giorno nominato, letta nel file per giorno dell'importer
# (che porta il SIMBOLO su ogni riga). Stati: DENTRO | FUORI (misurato ma non dentro) | NON_CONFRONTABILE | ASSENTE | RIPETUTO |
# NON_VALIDO | SOGLIA_DIVERSA | DISCORDANZA. DENTRO solo se mediana <= 0.05 E copertura >= 80 (copertura sotto 80 e' fuori anche
# con la mediana bassa), soglie della riga = soglie congelate, e il PassaImportatore della riga concorda coi numeri.
# Il verdetto "OK: CANCELLO PASSATO" e il conteggio "9/9" NON entrano: un giorno saltato in silenzio dall'importer qui risulta ASSENTE.
function Valuta-GiorniPerNome($righe, [string]$simbolo, $giorni){
  $res = New-Object System.Collections.ArrayList
  foreach($g in $giorni){
    $r = @($righe | Where-Object { ("" + $_.Giorno) -eq $g -and ("" + $_.Simbolo) -eq $simbolo })
    $stato = ""; $med = "-"; $cop = "-"
    if($r.Count -eq 0){ $stato = "ASSENTE" }
    elseif($r.Count -gt 1){ $stato = "RIPETUTO" }
    else {
      $x = $r[0]
      $med = "" + $x.MedianaDiffPct; $cop = "" + $x.CoperturaPct
      if(("" + $x.Esito).Trim() -ne "MISURATO"){ $stato = ("" + $x.Esito).Trim(); if($stato -eq ""){ $stato = "ESITO_VUOTO" } }
      else {
        $d = 0.0; $c = 0.0; $sd = 0.0; $sc = 0.0
        $st = [Globalization.NumberStyles]::Float
        $okn = ([double]::TryParse(("" + $x.MedianaDiffPct), $st, $INV, [ref]$d) -and [double]::TryParse(("" + $x.CoperturaPct), $st, $INV, [ref]$c) -and
                [double]::TryParse(("" + $x.SogliaDiffPct), $st, $INV, [ref]$sd) -and [double]::TryParse(("" + $x.SogliaCoperturaPct), $st, $INV, [ref]$sc))
        if(-not $okn){ $stato = "NON_VALIDO" }
        elseif($sd -ne $SogliaDiff -or $sc -ne $SogliaCop){ $stato = "SOGLIA_DIVERSA" }
        else {
          $dentro = ($d -le $SogliaDiff -and $c -ge $SogliaCop)
          $imp = (("" + $x.PassaImportatore) -eq "SI")
          if($dentro -ne $imp){ $stato = "DISCORDANZA" }
          elseif($dentro){ $stato = "DENTRO" }
          else { $stato = "FUORI" }
        }
      }
    }
    [void]$res.Add($g + "|" + $stato + "|" + $med + "|" + $cop)
  }
  return $res
}

# -PulisciFiles: toglie da MQL5\Files SOLO i CSV che QUESTA corsa ha copiato (nomi registrati in $Copiati) E che combaciano con la maschera.
# Mai il referto, mai file di altri simboli, mai un nome che la corsa non ha copiato.
function Pulisci-Copiati(){
  $n = 0
  if(-not $PulisciFiles){ return "non richiesta" }
  if($filesDir -eq "" -or $Copiati.Count -eq 0){ return "nessun CSV copiato da questa corsa: niente da togliere" }
  foreach($nome in $Copiati){
    if($nome -like $MascheraCsv){
      $pp = Join-Path $filesDir $nome
      Remove-Item -LiteralPath $pp -Force -ErrorAction SilentlyContinue
      if(-not (Test-Path -LiteralPath $pp)){ $n++ }
    }
  }
  return ("rimossi " + $n + " di " + $Copiati.Count + " CSV copiati da questa corsa")
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
  Dico ("giorni sonda: " + ($ListaGiorni -join ";") + "  (" + $ListaGiorni.Count + ", NOMINATI: ciascuno deve essere DENTRO per nome)")
  Dico ("sorgente CSV: " + $TickSrc + "   maschera: " + $MascheraCsv)
  if($ListaGiorni.Count -eq 0){ throw "-GiorniSonda vuoto: nessun giorno da misurare." }
  if($MascheraCsv -notlike ($SimboloDK + "_ticks_*")){ throw ("MASCHERA '" + $MascheraCsv + "' non comincia con '" + $SimboloDK + "_ticks_': il nome del CSV deve portare il simbolo, e' l'unica cosa che impedisce a un negativo di sovrascrivere un CSV buono.") }

  Titolo "1. TERMINALE BCM + CARTELLA DATI (stesso selettore di scarica_storico / CRT_TICK_G)"
  $allTerm = @(Get-ChildItem "C:\Program Files","C:\Program Files (x86)" -Recurse -Filter "terminal64.exe" -ErrorAction SilentlyContinue)
  $cand = $allTerm | Where-Object { $_.DirectoryName -like "*BCM Markets MT5 Terminal*" -and $_.DirectoryName -notlike "*-V3*" } | Select-Object -First 1
  # 12/09/2026: TOLTO IL RIPIEGO CHE ALLARGAVA IL BERSAGLIO.
# Qui c'era: se il selettore stretto non trova niente, cerca "*BCM Markets*"
# e prendi il PRIMO. Due difetti in una riga:
#  - "*BCM Markets*" comprende anche il 100k -V3 (50504263);
#  - "-First 1" su un insieme trovato per RICERCA non e' una scelta, e' un
#    SORTEGGIO (nessun ordinamento: "quello che il filesystem ha dato per
#    primo").
# E questo script COMPILA dentro il terminale che sceglie. Adesso, se il
# selettore stretto non trova niente, si MUORE: il bersaglio non si allarga
# mai da solo.
if(-not $cand){
  # 12/09/2026 (cancello): qui avevo messo "exit 1", e in 30 script su 84
  # quel blocco sta DENTRO un try{} il cui catch{} scrive il referto e fa
  # lo zip da mandare. Con exit il processo muore sul posto: niente catch,
  # niente referto, NIENTE ZIP -- cioe' la regola delle righe di lancio
  # (punto 2: si raccoglie sempre) annullata proprio nel caso in cui serve
  # di piu'. Con throw il catch la raccoglie e la raccolta parte; e dove il
  # try non c'e', throw termina comunque lo script. Sicuro in tutti e due.
  throw "Terminale non trovato col selettore stretto, e NON allargo la ricerca: il ripiego '*BCM Markets*' comprendeva anche il 100k -V3 (50504263), e questo script scrive e compila dentro il terminale che sceglie. Nomina il terminale a mano, oppure passa il banco C:\MT5_Backtest."
}
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
  # i file di Work portano il SIMBOLO e si cancellano ADESSO: una corsa che muore prima di scriverli non puo' spacciare quelli di un'altra
  $RefertoWork = Join-Path $Work ("ABTG_ImportTick_referto_" + $SimboloDK + ".csv")
  $GiorniWork  = Join-Path $Work ("ABTG_ImportTick_giorni_" + $SimboloDK + ".csv")
  Remove-Item -LiteralPath $RefertoWork -Force -ErrorAction SilentlyContinue
  Remove-Item -LiteralPath $GiorniWork -Force -ErrorAction SilentlyContinue
  $dstScr = Join-Path $DataFolder "MQL5\Scripts"
  New-Item -ItemType Directory -Force -Path $dstScr | Out-Null
  $mq5 = Join-Path $dstScr ($Script + ".mq5")
  Scarica ($RawPin + "/mql5/Scripts/" + $Script + ".mq5") $mq5 "IMP-TICK-v1-GIORNI"
  if($ShaMq5 -ne ""){
    $shaMq5Letto = (Get-FileHash -LiteralPath $mq5 -Algorithm SHA256).Hash
    if($shaMq5Letto -ine $ShaMq5){ throw ("IMPRONTA DIVERSA dello script MQL5 scaricato: letta " + $shaMq5Letto + ", attesa " + $ShaMq5 + ". Non compilo niente.") }
    Dico ("script MQL5 al pin, impronta OK: " + $shaMq5Letto.Substring(0,8)) "Green"
  }
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
    $csvSrc = @(Get-ChildItem -LiteralPath $TickSrc -Filter $MascheraCsv -ErrorAction SilentlyContinue | Sort-Object Name)
    if($csvSrc.Count -eq 0){
      throw ("ZERO CSV in " + $TickSrc + " (maschera " + $MascheraCsv + "). La corsa DUKA non ha ancora prodotto mesi: import impossibile.")
    }
    # GUARDIA "chi LEGGE": l'importer legge da MQL5\Files TUTTO cio' che combacia con la maschera, non solo quello che copio io.
    # Un file che combacia e NON e' nella sorgente verrebbe importato in silenzio: ci si ferma.
    $nomiSrc = @($csvSrc | ForEach-Object { $_.Name })
    $estranei = @(Get-ChildItem -LiteralPath $filesDir -Filter $MascheraCsv -ErrorAction SilentlyContinue | Where-Object { $nomiSrc -notcontains $_.Name } | ForEach-Object { $_.Name })
    if($estranei.Count -gt 0){
      throw ("FILE ESTRANEI in MQL5\Files che combaciano con la maschera " + $MascheraCsv + " e NON stanno in " + $TickSrc + ": " + ($estranei -join ", ") + ". L'importer li leggerebbe. Non li cancello io: tolgili a mano e rilancia.")
    }
    foreach($f in $csvSrc){ Copy-Item -LiteralPath $f.FullName -Destination $filesDir -Force; [void]$Copiati.Add($f.Name) }
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
InpMascheraCsv=$MascheraCsv
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
    $pul = Pulisci-Copiati
    Dico ("pulizia MQL5\Files: " + $pul) "DarkGray"
    $Verdetto = "CONTROLLO OK (nessun import, nessuna sonda)"
    $EsitoSonda = "-"
    exit 0
  }

  Titolo "5. LANCIO MT5 (startup script, MT5 era CHIUSO) -- timeout $TimeoutMin min"
  # referto CANCELLATO prima e preteso FRESCO dopo (checklist 23)
  $RefPath = Join-Path $filesDir $RefertoCsv
  $GiorniPath = Join-Path $filesDir $GiorniCsv
  Remove-Item -LiteralPath $RefPath -Force -ErrorAction SilentlyContinue
  Remove-Item -LiteralPath $GiorniPath -Force -ErrorAction SilentlyContinue
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
  # CHIUSURA CHIRURGICA (12/09/2026). Prima ammazzava TUTTI i terminal64
  # della macchina, IL CONTO REALE 10105439 COMPRESO, mentre ha posizioni
  # aperte. Adesso muore SOLO il terminale che questo script ha avviato.
  Get-Process -Name "terminal64" -ErrorAction SilentlyContinue | Where-Object { $_.Path -and ($_.Path -ieq $Terminal) } | Stop-Process -Force -ErrorAction SilentlyContinue
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
    Copy-Item -LiteralPath $RefPath -Destination $RefertoWork -Force -ErrorAction SilentlyContinue
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

  # --- LA CONDIZIONE (1) DELLA F2, PER NOME (classe 1104): dal file per giorno, non dal verdetto ---
  Titolo ("6b. I " + $ListaGiorni.Count + " GIORNI NOMINATI, PER NOME, dal file per giorno col simbolo " + $SimboloDK)
  $gFresco = $false
  if(Test-Path -LiteralPath $GiorniPath){ $gFresco = ((Get-Item -LiteralPath $GiorniPath).LastWriteTime -ge $t0) }
  if(-not $gFresco){
    $PerNomeNote = "NON VALUTABILE: file per giorno " + $GiorniCsv + " assente o non fresco (l'importer in uso non e' IMP-TICK-v1-GIORNI, o la corsa non e' arrivata alla sonda)"
    [void]$Problemi.Add($PerNomeNote)
    Dico $PerNomeNote "Yellow"
  }else{
    Copy-Item -LiteralPath $GiorniPath -Destination $GiorniWork -Force -ErrorAction SilentlyContinue
    $gr = @()
    try{ $gr = @(Import-Csv -LiteralPath $GiorniPath) }catch{ $gr = @() }
    if($gr.Count -eq 0){
      $PerNomeNote = "NON VALUTABILE: il file per giorno e' vuoto o illeggibile"
      [void]$Problemi.Add($PerNomeNote)
    }else{
      $AltroSimbolo = @($gr | Where-Object { ("" + $_.Simbolo) -ne $SimboloDK }).Count
      $PerNome = Valuta-GiorniPerNome $gr $SimboloDK $ListaGiorni
      $nDentro = @($PerNome | Where-Object { $_ -like "*|DENTRO|*" }).Count
      foreach($pn in $PerNome){ Dico ("   " + $pn.Replace("|", "   ")) $(if($pn -like "*|DENTRO|*"){ "Green" }else{ "Yellow" }) }
      if($AltroSimbolo -gt 0){ [void]$Problemi.Add("ATTRIBUZIONE INCOERENTE: " + $AltroSimbolo + " righe del file per giorno hanno un simbolo diverso da " + $SimboloDK) }
      $PerNomeOk = ($nDentro -eq $ListaGiorni.Count -and $AltroSimbolo -eq 0)
      $PerNomeNote = ("" + $nDentro) + " su " + $ListaGiorni.Count + " giorni NOMINATI dentro per nome" + $(if($AltroSimbolo -gt 0){ "; ATTRIBUZIONE INCOERENTE (" + $AltroSimbolo + " righe di un altro simbolo)" }else{ "" })
      Dico ("PER NOME: " + $PerNomeNote) $(if($PerNomeOk){ "Green" }else{ "Yellow" })
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
$Cart = Join-Path $Dsk ("DUKA_IMPORT_SONDA_" + $SimboloDK + "_" + $Stamp)
New-Item -ItemType Directory -Force -Path $Cart | Out-Null

# mappa verdetto -> codice d'uscita
$Codice = 1
$vU = $Verdetto.ToUpper()
if($Fatale -ne ""){ $Codice = 1 }
elseif($vU -like "*OK*CANCELLO PASSATO*" -or $vU -like "*OK: CANCELLO*"){ if($PerNomeOk){ $Codice = 0 }else{ $Codice = 4 } }
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
[void]$R.Add("giorni sonda (NOMINATI): " + ($ListaGiorni -join ";"))
[void]$R.Add("sorgente CSV: " + $TickSrc + "   maschera: " + $MascheraCsv + "   simbolo: " + $SimboloDK)
[void]$R.Add("")
[void]$R.Add("ESITO SONDA: " + $EsitoSonda)
[void]$R.Add("VERDETTO:    " + $Verdetto)
[void]$R.Add("PER NOME:    " + $PerNomeNote + "   (il verdetto OK da solo NON basta: classe 1104)")
foreach($pn in $PerNome){ [void]$R.Add("   " + $pn.Replace("|", "   ")) }
[void]$R.Add("CODICE D USCITA: " + $Codice + "   (0 = verdetto OK e tutti i nominati dentro; 4 = verdetto OK ma non tutti dentro per nome)")
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
$srcRefCsv = $RefertoWork
if($srcRefCsv -ne "" -and (Test-Path -LiteralPath $srcRefCsv)){ Copy-Item -LiteralPath $srcRefCsv -Destination $Cart -Force }
if($GiorniWork -ne "" -and (Test-Path -LiteralPath $GiorniWork)){ Copy-Item -LiteralPath $GiorniWork -Destination $Cart -Force }
$Pul = Pulisci-Copiati
[void]$R.Add("PULIZIA MQL5\Files (-PulisciFiles): " + $Pul)
Write-Host ("pulizia MQL5\Files: " + $Pul)
Set-Content -LiteralPath $RefTxt -Value ($R -join "`r`n") -Encoding ASCII
foreach($f in @("COMPILAZIONE_FALLITA.log")){
  $s = Join-Path $Work $f
  if(Test-Path -LiteralPath $s){ Copy-Item -LiteralPath $s -Destination $Cart -Force }
}
$logDir2 = ""
if($DataFolder -ne ""){ $logDir2 = Join-Path $DataFolder "MQL5\Logs" }
if($logDir2 -ne "" -and (Test-Path -LiteralPath $logDir2)){
  Get-ChildItem -LiteralPath $logDir2 -Filter "*.log" -ErrorAction SilentlyContinue |
    Sort-Object LastWriteTime -Descending | Select-Object -First 2 |
    ForEach-Object { Copy-Item -LiteralPath $_.FullName -Destination $Cart -Force -ErrorAction SilentlyContinue }
}

$Zip = $Cart + ".zip"
Remove-Item -LiteralPath $Zip -Force -ErrorAction SilentlyContinue
try{ Compress-Archive -Path (Join-Path $Cart "*") -DestinationPath $Zip -Force }catch{ Write-Host ("ZIP FALLITO: " + $_.Exception.Message) -ForegroundColor Red }
$ZipPresenti = "(zip non creato)"
if(Test-Path -LiteralPath $Zip){
  try{ Add-Type -AssemblyName System.IO.Compression.FileSystem; $zz = [IO.Compression.ZipFile]::OpenRead((Convert-Path -LiteralPath $Zip)); $ZipPresenti = (@($zz.Entries | ForEach-Object { $_.Name }) -join ", "); $zz.Dispose() }catch{ $ZipPresenti = "(zip illeggibile)" }
}

Write-Host ""
Write-Host ("CARTELLA: " + $Cart) -ForegroundColor Green
Write-Host ("ZIP DA MANDARE: " + $Zip) -ForegroundColor Green
Write-Host "FILE ATTESI: REFERTO_DUKA_IMPORT_SONDA.txt + ABTG_ImportTick_referto_<simbolo>.csv + ABTG_ImportTick_giorni_<simbolo>.csv + ultimi 2 *.log" -ForegroundColor Gray
Write-Host ("FILE PRESENTI NELLO ZIP (letti dallo zip, non dal piano): " + $ZipPresenti) -ForegroundColor Gray

# FRESCHEZZA senza metro che invecchia (checklist 110): l'atteso lo calcola
# la riga stessa dal suo avvio, NON 'adesso'.
Write-Host ""
Write-Host ("Nel REFERTO la riga 'data:' = ORA DI AVVIO (circa " + $Avvio.ToString("yyyy-MM-dd HH:mm",$INV) + "), NON l'ora attuale (" + (Get-Date).ToString("HH:mm",$INV) + ").") -ForegroundColor Cyan
Write-Host "Nel referto CSV dello script guarda la colonna Verdetto dell'ULTIMA riga." -ForegroundColor Cyan

if($Fatale -ne ""){ Write-Host ("ESITO: FERMATO -- " + $Fatale) -ForegroundColor Red; exit 1 }
Write-Host ("ESITO: " + $Verdetto + "  (codice " + $Codice + ")") -ForegroundColor $(if($Codice -eq 0){"Green"}elseif($Codice -eq 3){"Yellow"}else{"Red"})
exit $Codice
