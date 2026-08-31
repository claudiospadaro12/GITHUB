# =====================================================================
#  MARCATORE_RIGA_DUKA_A_v3
#  RIGA_DUKA_A.ps1  --  MISSIONE A DUKASCOPY: download TICK del Dow
#                       USA30IDXUSD -> CSV mensili U30USD_DK (31/08/2026)
# ---------------------------------------------------------------------
#  v3 (31/08 pomeriggio): MOTORE CURL. Il server datafeed.dukascopy.com
#  strozza l'impronta TLS di python-urllib (WinError 10060/10054 + 503
#  a raffica, anche con User-Agent Mozilla) ma fa passare curl.exe --
#  MISURATO: curl.exe sul canarino EURUSD 200/24043 byte nello stesso
#  minuto in cui lo script urllib moriva. Questa riga passa SEMPRE
#  --motore curl al .py (DUKA-TICK-v2) e pretende curl.exe come gate.
# ---------------------------------------------------------------------
#  COSA FA, IN ORDINE E DA SOLA:
#    1. GATE python  : trova il python VERO (non lo stub del Microsoft
#                      Store, checklist 17) e pretende >= 3.8. Stesso
#                      pattern MISURATO della riga M1 (RIGA_NOTTE2, 20/08).
#    2. GATE disco   : spazio libero sul disco di %USERPROFILE% >=
#                      -MinDiscoGB (default 12: il PASSO 0 stima ~10 GB
#                      per la missione A, +2 di margine). Sotto soglia:
#                      errore onesto e stop, PRIMA di scaricare un byte.
#    3. GATE cache   : la cartella di lavoro e' scrivibile (file di
#                      prova scritto e cancellato).
#    3b. GATE curl   : curl.exe presente (Get-Command curl.exe, SOLO
#                      Application: in PowerShell 5.1 'curl' e' un alias
#                      di Invoke-WebRequest e NON conta). E' il motore
#                      di rete misurato-passante del 31/08.
#    4. dukascopy_tick.py AL PIN (Remove-Item prima, marcatore
#                      DUKA-TICK-v2 preteso dentro il file).
#    5. AUTOTEST del .py PRIMA della corsa (--autotest, senza rete):
#                      se non esce 0 con "AUTOTEST: TUTTO OK." -> STOP
#                      ROSSO, la corsa non parte.
#    6. -SoloControllo: si ferma QUI (referto + zip, exit 0). Nessun
#                      download.
#    7. CORSA VERA   : la missione A con finestra DICHIARATA
#                      2024-10-01 -> 2025-06-16 (sonda; storica 2019-01-01 -> 2024-09-30 dopo il cancello), strumento USA30IDXUSD,
#                      SEMPRE --motore curl (il motore misurato-passante;
#                      urllib resta la via manuale del .py),
#                      --dst usa (default del progetto: il discriminante
#                      congelato in DUKASCOPY_PASSO0.md par. 3c si
#                      esegue DOPO, alla sonda dell'import; se vince
#                      "europa" si riconverte con -SoloCache -Dst europa,
#                      ZERO riscarichi).
#    8. REFERTO + ZIP LEGGERO sul Desktop, SEMPRE (anche a corsa
#                      interrotta): referto, console, elenco/conteggio
#                      CSV, prime/ultime righe campione. MAI i GB di CSV.
#
#  DOVE FINISCE COSA (misurato NEL .py, non supposto):
#    dukascopy_tick.py ha una struttura FISSA sotto --cartella:
#      <cartella>\raw\   la cache per ora scaricata (404 inclusi come
#                        .assente) -- e' LA STESSA cache raw/ di
#                        dukascopy_m1.py, dichiarato nel .py riga ~614.
#      <cartella>\tick\  i CSV mensili U30USD_DK_ticks_AAAA-MM.csv
#                        + referto_dukascopy_tick.txt
#    Percio' questa riga usa -Cartella %USERPROFILE%\dukascopy_lavoro
#    (la cartella che la riga M1 del 20/08 usava gia'): i giorni gia'
#    in cache NON si riscaricano. Il progetto aveva ipotizzato
#    duka_cache/ e duka_csv/: il .py non li prevede, e spostare la
#    cache butterebbe via il gia' scaricato. DICHIARATO, non nascosto.
#
#  QUESTA RIGA NON TOCCA MT5 -- DICHIARATO:
#    il download e' puro HTTP verso datafeed.dukascopy.com. Niente
#    guardia MT5-chiuso: MT5 puo' restare APERTO e le sedie in forward
#    continuano a girare. (L'IMPORT in MT5 e' un ALTRO passo, con la
#    sua riga e i suoi controlli.)
#
#  E' UNA CORSA LUNGA (~15 ore la tranche-sonda; ~5 GIORNI la storica, col ritmo ~4 min/giorno misurato il 18/08):
#    - RIPRENDIBILE: verificato NEL .py (cache per ora, scritture
#      atomiche, 404 memorizzati, CSV mensili scritti appena il mese e'
#      completo; il mese in corso si rifa' dalla cache al rilancio).
#      Rilanciare la STESSA riga riprende da dove era, senza riscaricare.
#    - PROIEZIONE: il .py stampa ogni 25 giorni "RESTANO ~N ORE"; questa
#      riga stampa PRIMA la proiezione col ritmo del 18/08 e la rilegge
#      dal log nel referto.
#    - SOSPENSIONE: il PC NON deve andare in sospensione (la corsa
#      morirebbe: si riprende, ma la notte e' persa). Vedi l'avviso a
#      schermo e la scheda DA_MANDARE (powercfg).
#
#  FINESTRA: la tabella di DUKASCOPY_PASSO0.md par. 4b proponeva
#    2019-09-01 -> 2024-09-26; la missione FIRMATA per questa riga e'
#    2024-10-01 -> 2025-06-16 (sonda; storica 2019-01-01 -> 2024-09-30 dopo il cancello) (piu' lunga in testa, si salda al tick
#    nativo BCM che parte il 2024-09-26 senza sovrapporsi). I default
#    -Da/-A sono questi e il referto li dichiara.
#
#  LA RIGA CHE SI INCOLLA (blocco INTERO, un comando solo -- checklist 21).
#  <PIN> = il commit che contiene QUESTO file: e' l'hash dato in chat.
#
#  & { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
#      $pin='<PIN>'; $p="$env:USERPROFILE\RIGA_DUKA_A.ps1"; Remove-Item $p -EA SilentlyContinue;
#      irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_DUKA_A.ps1" -OutFile $p;
#      if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_RIGA_DUKA_A_v3' -Quiet)){ throw 'SCRIPT VECCHIO' };
#      $global:LASTEXITCODE=0; & $p -Pin $pin -Da '2024-10-01' -A '2025-06-16'; if($LASTEXITCODE -ne 0){ Write-Host 'ESITO: NON COMPLETO - leggi il REFERTO sul Desktop' } }
#
#  -Pin NON HA DEFAULT, apposta (lezione della riga sorella del 20/08):
#  senza -Pin valido lo script si ferma, cosi' non gira mai codice vecchio.
#
#  CODICI D'USCITA DELLA RIGA:
#    0 = OK (corsa completa, o -SoloControllo passato)
#    3 = RIPRENDIBILE (corsa con buchi o interrotta: rilancia la stessa riga)
#    1 = FERMATA (gate fallito, autotest rosso, o corsa fallita)
# =====================================================================
param(
  [string]$Pin        = "",            # OBBLIGATORIO: sha40. Lo passa la riga.
  [string]$Da         = "2019-01-01",  # finestra DICHIARATA della missione A
  [string]$A          = "2024-09-25",  #   (si salda al tick nativo BCM del 2024-09-26)
  [ValidateSet("usa","europa")]
  [string]$Dst        = "usa",         # calendario DST del server (default del progetto)
  [int]$PausaMs       = 250,           # respiro fra richieste, misurato il 15/08
  [double]$MinDiscoGB = 12.0,          # gate disco: stima PASSO 0 ~10 GB + margine
  [switch]$SoloControllo,              # giro a vuoto: python + disco + cache + autotest, NIENTE download
  [switch]$SoloCache                   # riconversione dalla cache, zero rete (per il discriminante DST)
)
$ErrorActionPreference = "Stop"
[Threading.Thread]::CurrentThread.CurrentCulture   = [Globalization.CultureInfo]::InvariantCulture
[Threading.Thread]::CurrentThread.CurrentUICulture = [Globalization.CultureInfo]::InvariantCulture
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$INV = [Globalization.CultureInfo]::InvariantCulture

if($Pin -notmatch '^[0-9a-fA-F]{40}$'){
  Write-Host ""
  Write-Host "!!! PIN MANCANTE O NON VALIDO." -ForegroundColor Red
  Write-Host "    Questa riga NON ha un pin di ripiego: girare al pin sbagliato" -ForegroundColor Yellow
  Write-Host "    vuol dire girare codice di ieri senza accorgersene." -ForegroundColor Yellow
  Write-Host "    Usa il blocco di lancio scritto in testa al file, con l'hash dato in chat." -ForegroundColor Yellow
  exit 1
}
$Pin = $Pin.ToLower()

$Avvio    = Get-Date
$Stamp    = $Avvio.ToString("yyyyMMdd_HHmm", $INV)
$Dsk      = Join-Path $env:USERPROFILE "Desktop"
if(-not (Test-Path -LiteralPath $Dsk)){ $Dsk = $env:USERPROFILE }
$Lavoro   = Join-Path $env:USERPROFILE "dukascopy_lavoro"   # struttura FISSA del .py: raw\ + tick\
$RawDir   = Join-Path $Lavoro "raw"
$TickDir  = Join-Path $Lavoro "tick"
$RefPy    = Join-Path $TickDir "referto_dukascopy_tick.txt"
$DukaPy   = Join-Path $Lavoro "dukascopy_tick.py"
$RawPin   = "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$Pin"
$Simbolo  = "USA30IDXUSD"   # Dukascopy; il .py lo mappa su U30USD_DK (tabella STRUMENTI)

$Cart     = Join-Path $Dsk ("DUKA_A_" + $Stamp)
$Zip      = Join-Path $Dsk ("DUKA_A_" + $Stamp + ".zip")
$Referto  = Join-Path $Cart "REFERTO_DUKA_A.txt"
$Console  = Join-Path $Cart ("console_duka_a_" + $Stamp + ".txt")
$StatoFile= Join-Path $Dsk $(if($SoloControllo){"STATO_DUKA_A_GIROAVUOTO.txt"}else{"STATO_DUKA_A.txt"})

$Problemi = New-Object System.Collections.ArrayList
$Note     = New-Object System.Collections.ArrayList
$Modo     = "CORSA VERA"
if($SoloControllo){ $Modo = "SOLO CONTROLLO (nessun download)" }
elseif($SoloCache){ $Modo = "SOLO CACHE (riconversione, zero rete)" }
$EsitoRiga = "NON PARTITA"
$RcPy      = -1
$refFresco = $false
$Python    = ""
$CurlExe   = ""

function Ora(){ return (Get-Date).ToString("HH:mm:ss", $INV) }
function Dico($t,$c="Gray"){ Write-Host ("[" + (Ora) + "] " + $t) -ForegroundColor $c }
function Titolo($t){ Write-Host ""; Write-Host ("=== " + $t + " ===") -ForegroundColor Cyan }

# --- scarico blindato: niente copia vecchia, errore terminante, marcatore
function Scarica($url,$dest,$marcatore){
  Remove-Item -LiteralPath $dest -Force -ErrorAction SilentlyContinue
  Invoke-WebRequest -Uri $url -OutFile $dest -UseBasicParsing -ErrorAction Stop
  if(-not (Test-Path -LiteralPath $dest)){ throw ("scarico fallito: " + $url) }
  if($marcatore -ne "" -and -not (Select-String -Path $dest -SimpleMatch -Pattern $marcatore -Quiet)){
    throw ("file scaricato SENZA il marcatore '" + $marcatore + "': " + $url)
  }
}

# --- lancio di un eseguibile ESTERNO con log e codice d'uscita onesto.
#     Copiato dalla riga M1 (RIGA_NOTTE2, 20/08): $ErrorActionPreference='Stop'
#     + '2>&1' su un processo nativo fa esplodere PowerShell 5.1 alla PRIMA
#     riga di stderr. Si abbassa la guardia SOLO intorno alla chiamata.
function EseguiNativo($exe,$argv,$logfile){
  $vecchio = $ErrorActionPreference
  $ErrorActionPreference = "Continue"
  $global:LASTEXITCODE = 0
  try{
    & $exe @argv 2>&1 | Tee-Object -FilePath $logfile | Out-Host
    $rc = $LASTEXITCODE
  }catch{
    $rc = 99
    Write-Host ("    eccezione lanciando " + $exe + ": " + $_.Exception.Message) -ForegroundColor Red
  }finally{
    $ErrorActionPreference = $vecchio
  }
  if($null -eq $rc){ $rc = 0 }
  return [int]$rc
}

# --- i giorni che dukascopy_tick.py ITERA davvero: tutti tranne il SABATO
#     (funzione giorni() del .py: weekday != 5; la domenica si tiene).
function GiorniIterati($da,$a){
  $n=0; $d=$da
  while($d -le $a){ if($d.DayOfWeek -ne [DayOfWeek]::Saturday){ $n++ }; $d=$d.AddDays(1) }
  return $n
}

Write-Host ""
Write-Host "#####################################################################" -ForegroundColor Cyan
Write-Host "#  MISSIONE A DUKASCOPY -- TICK DOW (USA30IDXUSD -> U30USD_DK)      #" -ForegroundColor Cyan
Write-Host "#  puro HTTP: MT5 puo' restare APERTO, le sedie continuano.         #" -ForegroundColor Cyan
Write-Host "#####################################################################" -ForegroundColor Cyan
Dico ("pin      : " + $Pin)
Dico ("modo     : " + $Modo)
Dico ("motore   : curl (misurato-passante 31/08: il server strozza python-urllib)")
Dico ("finestra : " + $Da + " -> " + $A + "   strumento: " + $Simbolo + "   dst: " + $Dst)
Dico ("lavoro   : " + $Lavoro + "  (cache raw\ CONDIVISA con dukascopy_m1)")
Dico ("raccolta : " + $Cart)

# --- le due date: valide, ordinate, dichiarate PRIMA di ogni altra cosa
$dtDa = [datetime]::MinValue; $dtA = [datetime]::MinValue
if(-not [datetime]::TryParseExact($Da,"yyyy-MM-dd",$INV,[Globalization.DateTimeStyles]::None,[ref]$dtDa)){
  Write-Host ("!!! -Da '" + $Da + "' non e' una data yyyy-MM-dd. Mi fermo.") -ForegroundColor Red; exit 1
}
if(-not [datetime]::TryParseExact($A,"yyyy-MM-dd",$INV,[Globalization.DateTimeStyles]::None,[ref]$dtA)){
  Write-Host ("!!! -A '" + $A + "' non e' una data yyyy-MM-dd. Mi fermo.") -ForegroundColor Red; exit 1
}
if($dtA -le $dtDa){
  Write-Host "!!! La finestra e' rovesciata (-A non e' dopo -Da). Mi fermo." -ForegroundColor Red; exit 1
}
$GiorniTot = GiorniIterati $dtDa $dtA
$StimaOre  = $GiorniTot * 4.0 / 60.0   # ritmo ~4 min/giorno MISURATO il 18/08

New-Item -ItemType Directory -Force -Path $Cart | Out-Null

$CodiceUscita = 1
try{

  # ===================================================================
  #  GATE 1 - PYTHON VERO (checklist 17). Stesso pattern della riga M1.
  # ===================================================================
  Titolo "GATE 1 - python funzionante (pattern misurato della riga M1)"
  $Python = (Get-Command python.exe -ErrorAction SilentlyContinue |
             Where-Object { $_.Source -notlike "*\WindowsApps\*" } |
             Select-Object -First 1 -ExpandProperty Source)
  if(-not $Python){ $Python = (Get-Command py.exe -ErrorAction SilentlyContinue | Select-Object -First 1 -ExpandProperty Source) }
  if(-not $Python){
    throw "PYTHON ASSENTE: installalo da python.org spuntando 'Add python.exe to PATH'. Senza python questa missione non e' eseguibile."
  }
  $rcv = EseguiNativo $Python @("-c","import sys; print(sys.version); sys.exit(0 if sys.version_info>=(3,8) else 1)") (Join-Path $Cart "python_versione.txt")
  if($rcv -ne 0){ throw ("PYTHON TROPPO VECCHIO O NON FUNZIONANTE (serve >= 3.8): " + $Python) }
  Dico ("python: " + $Python) "Green"

  # ===================================================================
  #  GATE 2 - DISCO: il PASSO 0 stima ~10 GB (cache + CSV + base MT5).
  #  Soglia dichiarata -MinDiscoGB (default 12). Errore ONESTO se sotto.
  # ===================================================================
  Titolo ("GATE 2 - spazio disco (soglia dichiarata: " + $MinDiscoGB.ToString("0.0",$INV) + " GB)")
  $radice  = [System.IO.Path]::GetPathRoot($env:USERPROFILE)
  $drive   = New-Object System.IO.DriveInfo($radice)
  $liberiGB = $drive.AvailableFreeSpace / 1GB
  Dico ("disco " + $radice + " : " + $liberiGB.ToString("0.0",$INV) + " GB liberi")
  if($liberiGB -lt $MinDiscoGB){
    throw ("DISCO INSUFFICIENTE: " + $liberiGB.ToString("0.0",$INV) + " GB liberi su " + $radice +
           ", la soglia dichiarata e' " + $MinDiscoGB.ToString("0.0",$INV) +
           " GB (stima PASSO 0: ~10 GB per la missione A). Libera spazio e rilancia: NON parto a meta'.")
  }
  Dico "spazio disco: OK" "Green"

  # ===================================================================
  #  GATE 3 - CACHE SCRIVIBILE: si scrive e si cancella un file di prova.
  # ===================================================================
  Titolo "GATE 3 - cartella di lavoro scrivibile"
  New-Item -ItemType Directory -Force -Path $Lavoro,$RawDir,$TickDir | Out-Null
  $probe = Join-Path $RawDir ("prova_scrittura_" + $Stamp + ".tmp")
  Set-Content -LiteralPath $probe -Value "prova" -Encoding ASCII
  if(-not (Test-Path -LiteralPath $probe)){ throw ("la cache NON e' scrivibile: " + $RawDir) }
  Remove-Item -LiteralPath $probe -Force
  Dico ("cache scrivibile: " + $RawDir) "Green"

  # ===================================================================
  #  GATE 3B - CURL.EXE: il motore di rete della corsa (misurato 31/08:
  #  il server strozza l'impronta TLS di python-urllib, curl passa).
  #  NB Windows PowerShell 5.1: 'curl' e' un ALIAS di Invoke-WebRequest,
  #  quindi si pretende curl.exe ESPLICITO e SOLO CommandType Application.
  # ===================================================================
  Titolo "GATE 3B - curl.exe presente (motore di rete misurato-passante)"
  $CurlExe = (Get-Command curl.exe -CommandType Application -ErrorAction SilentlyContinue |
              Select-Object -First 1 -ExpandProperty Source)
  if(-not $CurlExe){
    throw ("CURL.EXE ASSENTE: la corsa usa --motore curl perche' il server strozza " +
           "python-urllib (misurato 31/08). Su Windows 10 1803+ curl.exe sta in " +
           "C:\Windows\System32: se manca, il PC va sistemato prima. " +
           "NB: 'curl' senza .exe in PowerShell e' Invoke-WebRequest e NON conta.")
  }
  Dico ("curl.exe: " + $CurlExe) "Green"

  # ===================================================================
  #  PASSO 4 - LO SCRIPT AL PIN, col marcatore DUKA-TICK-v2
  # ===================================================================
  Titolo "PASSO 4 - dukascopy_tick.py al pin (marcatore DUKA-TICK-v2)"
  Scarica ("$RawPin/backtest_pipeline/dukascopy/dukascopy_tick.py") $DukaPy 'DUKA-TICK-v2'
  Dico "dukascopy_tick.py scaricato al pin, marcatore verificato" "Green"

  # ===================================================================
  #  PASSO 5 - AUTOTEST PRIMA DELLA CORSA (senza rete esterna: il caso
  #  curl usa un server HTTP locale acceso dall'autotest). Rosso = stop.
  # ===================================================================
  Titolo "PASSO 5 - autotest del .py (10 controlli, senza rete esterna)"
  $logAuto = Join-Path $Cart "autotest.txt"
  $rcA = EseguiNativo $Python @("-u",$DukaPy,"--autotest") $logAuto
  $autoOk = $false
  if(Test-Path -LiteralPath $logAuto){
    $autoOk = (Select-String -Path $logAuto -SimpleMatch -Pattern "AUTOTEST: TUTTO OK." -Quiet)
  }
  if($rcA -ne 0 -or -not $autoOk){
    throw ("AUTOTEST FALLITO (rc=" + $rcA + ", riga finale " +
           $(if($autoOk){"presente"}else{"ASSENTE"}) + "): la corsa NON parte. Leggi " + $logAuto)
  }
  Dico "autotest: TUTTO OK (rc 0)" "Green"

  # ===================================================================
  #  PASSO 6 - SOLO CONTROLLO: ci si ferma qui, con referto.
  #  NB: niente 'return' dentro il try -- a livello di script salterebbe
  #  la coda DOPO il finally e l'exit finale non girerebbe (checklist 14:
  #  il giro a vuoto deve uscire col codice giusto). Si usa il guard.
  # ===================================================================
  if($SoloControllo){
    $EsitoRiga = "SOLO CONTROLLO: TUTTI I GATE PASSATI (python, disco, cache, curl.exe, autotest). Nessun download eseguito."
    Dico $EsitoRiga "Green"
    Write-Host ""
    Write-Host ("    Proiezione della corsa vera: " + $GiorniTot + " giorni iterati x ~4 min/giorno") -ForegroundColor Yellow
    Write-Host ("    (ritmo MISURATO il 18/08) = ~" + $StimaOre.ToString("0",$INV) + " ORE = ~" + ($StimaOre/24.0).ToString("0.0",$INV) + " GIORNI di PC ACCESO, giorno E notte.") -ForegroundColor Yellow
    $CodiceUscita = 0
  }

  # ===================================================================
  #  PASSO 7 - LA CORSA VERA (o la riconversione -SoloCache)
  # ===================================================================
  if(-not $SoloControllo){
  Titolo ("PASSO 7 - " + $Modo)
  Write-Host ("    finestra DICHIARATA : " + $Da + " -> " + $A + "  (" + $GiorniTot + " giorni iterati, sabato escluso)") -ForegroundColor White
  Write-Host ("    strumento           : " + $Simbolo + " -> U30USD_DK") -ForegroundColor White
  Write-Host ("    motore di rete      : curl (" + $CurlExe + ") -- misurato-passante 31/08") -ForegroundColor White
  Write-Host ("    dst                 : " + $Dst + "  (discriminante congelato: si esegue DOPO, alla sonda dell'import)") -ForegroundColor White
  if(-not $SoloCache){
    Write-Host ""
    Write-Host ("    PROIEZIONE col ritmo del 18/08 (~4 min/giorno): ~" + $StimaOre.ToString("0",$INV) + " ORE = ~" + ($StimaOre/24.0).ToString("0.0",$INV) + " GIORNI di PC ACCESO, giorno E notte.") -ForegroundColor Yellow
    Write-Host "    Il .py stampa ogni 25 giorni la proiezione VERA ('RESTANO ~N ORE'):" -ForegroundColor Yellow
    Write-Host "    se il ritmo e' molto peggio, CTRL+C e si ridiscute -- non si insiste." -ForegroundColor Yellow
    Write-Host ""
    Write-Host "    RIPRENDIBILE: cache per ora scaricata, scritture atomiche, CSV mensili" -ForegroundColor Yellow
    Write-Host "    scritti appena il mese e' completo. Rilanciare la STESSA riga riprende" -ForegroundColor Yellow
    Write-Host "    da dove era senza riscaricare (verificato nel .py)." -ForegroundColor Yellow
    Write-Host ""
    Write-Host "    MT5 puo' restare APERTO: questa corsa e' puro HTTP, non tocca MT5." -ForegroundColor Yellow
    Write-Host "    MA il PC NON deve andare in SOSPENSIONE. Per la notte:" -ForegroundColor Yellow
    Write-Host "      powercfg /change standby-timeout-ac 0" -ForegroundColor White
    Write-Host "    (0 = mai; per rimettere com'era: powercfg /change standby-timeout-ac 30)" -ForegroundColor DarkGray
  }

  # STATO sul Desktop PRIMA di partire: se la corsa muore (sospensione,
  # riavvio), le istruzioni di ripresa sono gia' scritte fuori dal log.
  $st = New-Object System.Collections.ArrayList
  [void]$st.Add("STATO MISSIONE A DUKASCOPY -- avviata " + $Avvio.ToString("yyyy-MM-dd HH:mm:ss",$INV))
  [void]$st.Add("pin " + $Pin + "   finestra " + $Da + " -> " + $A + "   dst " + $Dst)
  [void]$st.Add("")
  [void]$st.Add("IL DOWNLOAD E' RIPRENDIBILE: rilancia la stessa riga per continuare.")
  [void]$st.Add("(cache in " + $RawDir + ", CSV mensili in " + $TickDir + ")")
  Set-Content -LiteralPath $StatoFile -Value $st -Encoding ASCII

  # referto del .py CANCELLATO prima e preteso riscritto adesso (checklist 23)
  Remove-Item -LiteralPath $RefPy -Force -ErrorAction SilentlyContinue
  $t0 = Get-Date
  $argv = @("-u",$DukaPy,"--simboli",$Simbolo,"--da",$Da,"--a",$A,
            "--dst",$Dst,"--fuso","server","--motore","curl",
            "--pausa-ms",("" + $PausaMs),"--cartella",$Lavoro)
  if($SoloCache){ $argv += "--solo-cache" }
  $RcPy = EseguiNativo $Python $argv $Console
  $durataH = (New-TimeSpan -Start $t0 -End (Get-Date)).TotalHours

  # gate sull'ARTEFATTO, non solo sul codice d'uscita (checklist 26-bis)
  $refFresco = $false
  if(Test-Path -LiteralPath $RefPy){ $refFresco = ((Get-Item -LiteralPath $RefPy).LastWriteTime -ge $t0) }
  $esitoPy = "(referto del .py assente: corsa interrotta prima della fine)"
  if($refFresco){
    $mm = [regex]::Match((Get-Content -LiteralPath $RefPy -Raw),'(?m)^ESITO\s*:\s*(.+)$')
    if($mm.Success){ $esitoPy = $mm.Groups[1].Value.Trim() }
  }

  if($RcPy -eq 0 -and $refFresco){
    $EsitoRiga = "OK: corsa COMPLETA (" + $durataH.ToString("0.0",$INV) + " h). Esito .py: " + $esitoPy
    $CodiceUscita = 0
  } elseif($RcPy -eq 3){
    $EsitoRiga = "COMPLETA MA CON BUCHI (rc 3, " + $durataH.ToString("0.0",$INV) + " h). Esito .py: " + $esitoPy
    [void]$Problemi.Add("Ci sono ore in errore: la copertura NON e' garantita. RILANCIA LA STESSA RIGA: la cache non riscarica quello che c'e' gia'.")
    $CodiceUscita = 3
  } elseif($RcPy -eq 130){
    $EsitoRiga = "INTERROTTA A MANO (CTRL+C dopo " + $durataH.ToString("0.0",$INV) + " h). Cache e mesi gia' scritti VALIDI."
    [void]$Problemi.Add("Corsa interrotta: i mesi CSV gia' scritti restano buoni, il mese in corso si rifa' dalla cache. RILANCIA LA STESSA RIGA per continuare.")
    $CodiceUscita = 3
  } else {
    $EsitoRiga = "FALLITA (rc " + $RcPy + " dopo " + $durataH.ToString("0.0",$INV) + " h). Esito .py: " + $esitoPy
    [void]$Problemi.Add("La corsa e' uscita con rc " + $RcPy + ". Leggi la console (" + (Split-Path $Console -Leaf) + ") dal fondo: controllo positivo fallito, ban 503, o divisore non decidibile. Se e' un ban, aspetta e rilancia la stessa riga.")
    $CodiceUscita = 1
  }
  Dico ("esito: " + $EsitoRiga) $(if($CodiceUscita -eq 0){"Green"}else{"Yellow"})
  } # fine guard -not SoloControllo

}catch{
  $EsitoRiga = "FERMATA: " + $_.Exception.Message
  [void]$Problemi.Add($_.Exception.Message)
  Write-Host ""
  Write-Host ("!!! " + $EsitoRiga) -ForegroundColor Red
  $CodiceUscita = 1
}finally{

  # ===================================================================
  #  PASSO 8 - REFERTO + ZIP LEGGERO, SEMPRE (anche a corsa fermata).
  #  SOLO referto + console + elenco/campione CSV. MAI i GB di CSV.
  # ===================================================================
  try{
    $csv = @()
    if(Test-Path -LiteralPath $TickDir){
      $csv = @(Get-ChildItem -LiteralPath $TickDir -Filter "U30USD_DK_ticks_*.csv" -ErrorAction SilentlyContinue | Sort-Object Name)
    }
    $csvMB = 0.0
    foreach($f in $csv){ $csvMB += $f.Length / 1MB }
    $mesiAttesi = (($dtA.Year - $dtDa.Year) * 12) + ($dtA.Month - $dtDa.Month) + 1

    # giorni completati e MB scaricati: MISURATI dall'ultima riga di
    # progresso del .py nella console ("N/M giorni ... X.X MB ... RESTANO ~Y ORE")
    $giorniFatti = "?"; $mbScaricati = "?"; $restanoOre = "-"
    if(Test-Path -LiteralPath $Console){
      $prog = @(Select-String -Path $Console -Pattern '(\d+)/(\d+) giorni' | Select-Object -Last 1)
      if($prog.Count -gt 0){
        $m = [regex]::Match($prog[0].Line,'(\d+)/(\d+) giorni')
        $giorniFatti = $m.Groups[1].Value
        $mMB = [regex]::Match($prog[0].Line,'([0-9.]+) MB')
        if($mMB.Success){ $mbScaricati = $mMB.Groups[1].Value }
        $mRe = [regex]::Match($prog[0].Line,'RESTANO ~([0-9.]+) ORE')
        if($mRe.Success){ $restanoOre = $mRe.Groups[1].Value }
      }
    }

    $r = New-Object System.Collections.ArrayList
    [void]$r.Add("=== REFERTO MISSIONE A DUKASCOPY -- TICK DOW (RIGA_DUKA_A v3) ===")
    [void]$r.Add("data     : " + (Get-Date).ToString("yyyy-MM-dd HH:mm:ss",$INV) + "  (avvio " + $Avvio.ToString("yyyy-MM-dd HH:mm:ss",$INV) + ")")
    [void]$r.Add("modo     : " + $Modo)
    [void]$r.Add("pin      : " + $Pin)
    [void]$r.Add("finestra : " + $Da + " -> " + $A + "  (" + $GiorniTot + " giorni iterati, sabato escluso)")
    [void]$r.Add("strumento: " + $Simbolo + " -> U30USD_DK   dst: " + $Dst + "   fuso: server")
    [void]$r.Add("motore   : curl" + $(if($CurlExe){ " (" + $CurlExe + ")" }else{ " (NON TROVATO: gate 3B fermato)" }) + "  -- misurato-passante 31/08, urllib strozzato dal server")
    [void]$r.Add("python   : " + $(if($Python){ $Python }else{ "NON TROVATO" }))
    [void]$r.Add("")
    [void]$r.Add("ESITO    : " + $EsitoRiga)
    [void]$r.Add("")
    [void]$r.Add("CONTEGGI (misurati, non stimati):")
    [void]$r.Add("  giorni completati / totali : " + $giorniFatti + " / " + $GiorniTot + "  (dall'ultima riga di progresso del .py)")
    [void]$r.Add("  MB .bi5 scaricati (questa corsa): " + $mbScaricati)
    if($restanoOre -ne "-"){ [void]$r.Add("  proiezione del .py: RESTANO ~" + $restanoOre + " ORE") }
    [void]$r.Add("  CSV mensili prodotti       : " + $csv.Count + " su ~" + $mesiAttesi + " mesi attesi  (" + $csvMB.ToString("0.0",$INV) + " MB in " + $TickDir + ")")
    [void]$r.Add("")
    [void]$r.Add("IL DOWNLOAD E' RIPRENDIBILE: rilancia la stessa riga per continuare.")
    [void]$r.Add("(cache per ora scaricata in " + $RawDir + ", 404 memorizzati, scritture")
    [void]$r.Add(" atomiche; i mesi CSV gia' scritti restano validi, il mese in corso si")
    [void]$r.Add(" rifa' dalla cache senza riscaricare.)")
    [void]$r.Add("")
    [void]$r.Add("MT5: NON toccato da questa riga (download puro HTTP). L'import in MT5")
    [void]$r.Add("     e' il passo DOPO, con la sua riga e la sonda (DUKASCOPY_PASSO0.md par. 4).")
    if($csv.Count -gt 0){
      [void]$r.Add("")
      [void]$r.Add("ELENCO CSV MENSILI (nome / MB):")
      foreach($f in $csv){ [void]$r.Add(("  {0}  {1} MB" -f $f.Name, ($f.Length/1MB).ToString("0.0",$INV))) }
      [void]$r.Add("")
      [void]$r.Add("CAMPIONE (controllo dell'ordine di grandezza: un Dow sta fra 8000 e 70000):")
      $primo = $csv[0]; $ultimo = $csv[$csv.Count-1]
      [void]$r.Add("  prime righe di " + $primo.Name + ":")
      foreach($l in @(Get-Content -LiteralPath $primo.FullName -TotalCount 3)){ [void]$r.Add("    " + $l) }
      [void]$r.Add("  ultime righe di " + $ultimo.Name + ":")
      foreach($l in @(Get-Content -LiteralPath $ultimo.FullName -Tail 2)){ [void]$r.Add("    " + $l) }
    }
    if($Problemi.Count -gt 0){
      [void]$r.Add("")
      [void]$r.Add("PROBLEMI:")
      foreach($p in $Problemi){ [void]$r.Add("  - " + $p) }
    }
    if($Note.Count -gt 0){
      [void]$r.Add("")
      [void]$r.Add("NOTE:")
      foreach($n in $Note){ [void]$r.Add("  - " + $n) }
    }
    [void]$r.Add("")
    [void]$r.Add("PASSO DOPO: mandare a Claude SOLO lo zip leggero " + (Split-Path $Zip -Leaf))
    [void]$r.Add("(referto + console + campioni). MAI zippare i GB di CSV: quelli restano")
    [void]$r.Add("in " + $TickDir + " per il passo di import.")
    Set-Content -LiteralPath $Referto -Value $r -Encoding ASCII

    # copia del referto del .py: SOLO nel ramo vero e SOLO se FRESCO (classe
    # "il giro a vuoto si porta via il referto della notte prima", 31/08)
    if(-not $SoloControllo -and $refFresco -and (Test-Path -LiteralPath $RefPy)){
      Copy-Item -LiteralPath $RefPy -Destination (Join-Path $Cart ("referto_py_" + $Stamp + ".txt")) -Force -ErrorAction SilentlyContinue
    }

    # ZIP LEGGERO: solo la cartella di raccolta (referto+console+log), MAI i CSV
    Remove-Item -LiteralPath $Zip -Force -ErrorAction SilentlyContinue
    Compress-Archive -Path (Join-Path $Cart "*") -DestinationPath $Zip -Force

    # STATO sul Desktop aggiornato con l'esito finale
    $st2 = New-Object System.Collections.ArrayList
    [void]$st2.Add("STATO MISSIONE A DUKASCOPY -- aggiornato " + (Get-Date).ToString("yyyy-MM-dd HH:mm:ss",$INV))
    [void]$st2.Add("ESITO: " + $EsitoRiga)
    [void]$st2.Add("IL DOWNLOAD E' RIPRENDIBILE: rilancia la stessa riga per continuare.")
    Set-Content -LiteralPath $StatoFile -Value $st2 -Encoding ASCII

    Write-Host ""
    Write-Host ("RACCOLTA  : " + $Cart) -ForegroundColor Cyan
    Write-Host ("ZIP PRONTO: " + $Zip + "  (LEGGERO: referto+console, niente CSV)") -ForegroundColor Cyan
    Write-Host ("Attesi dentro: " + ((Get-ChildItem -LiteralPath $Cart | Sort-Object Name | Select-Object -ExpandProperty Name) -join ", ")) -ForegroundColor Cyan
  }catch{
    Write-Host ("!! raccolta non completata: " + $_.Exception.Message) -ForegroundColor Red
    if($CodiceUscita -eq 0){ $CodiceUscita = 3 }
  }
}

Write-Host ""
Write-Host ("ESITO RIGA: " + $EsitoRiga) -ForegroundColor $(if($CodiceUscita -eq 0){"Green"}elseif($CodiceUscita -eq 3){"Yellow"}else{"Red"})
exit $CodiceUscita
