# =====================================================================
#  prepara_broker_esterno.ps1  --  mette in condizione di testare i
#                                  nostri EA su un SECONDO broker
# ---------------------------------------------------------------------
#  PERCHE' ESISTE (14/08/2026):
#  lo storico BCM sugli INDICI parte dal 26/09/2024: 21 mesi e UN SOLO
#  regime. La prova di regime (prove\PROVA_REGIME_CRITERI.md) vuole il
#  2022 (orso) e il 2020 (crollo), e sugli indici quei dati li ha solo
#  un altro broker (demo Pepperstone). Questo script prepara quel
#  terminale e - soprattutto - DISINNESCA LE DUE TRAPPOLE che
#  renderebbero spazzatura ogni verdetto:
#
#   TRAPPOLA A - IL FUSO. I nostri EA hanno gli orari in ORA SERVER
#   (DAX InpSessionHour=8, apertura USA 14:30, box notturno 23:00-04:59,
#   fascia 8-18 dell'EasyTrend). Broker diversi = offset diversi. Qui
#   l'offset non si stima: si MISURA in due modi indipendenti,
#     1) TimeTradeServer - TimeGMT sui due terminali (vale OGGI);
#     2) confronto delle chiusure H1 dei due feed con shift da -6 a +6
#        ore, su DUE finestre (una in ora solare, una in ora legale).
#   Il secondo e' quello che vale per il PASSATO, ed e' anche l'unico
#   che fa vedere se l'offset CAMBIA fra le stagioni: Pepperstone segue
#   il DST americano, l'Europa cambia in date diverse, quindi 2-3
#   settimane l'anno la differenza vale 1 ora invece di 2. Ogni anno.
#
#   TRAPPOLA B - I NOMI DEI SIMBOLI. Su BCM il DAX e' D30EUR, altrove
#   GER40 / DE40 / GER30. Qui NON si inventa nessuna mappa: si elenca
#   quello che il broker ha DAVVERO (ABTG_InfoBroker) e si propongono
#   dei CANDIDATI, che restano da confermare a mano guardando la
#   descrizione. La mappa buona si scrive in docs\BROKER_ESTERNO_MAPPA.md.
#
#  COSA FA, in ordine:
#   1. elenca TUTTI i terminali MT5 installati (da origin.txt)
#   2. sceglie quello che matcha -BrokerPattern
#   3. installa e compila ABTG_InfoBroker e ABTG_HistoryDownloader
#   4. con -SoloElenco: lancia SOLO il ricognitore (fallo SEMPRE per
#      primo: costa due minuti ed evita di scaricare gigabyte inutili)
#   5. altrimenti scarica lo storico dei simboli richiesti
#   6. confronta il fuso col terminale di riferimento (BCM) e stampa
#      la formula di rimappatura + gli orari nuovi dei nostri EA
#   7. raccoglie tutto su Desktop\broker_esterno + zip pronto da mandare
#
#  COME SI LANCIA (PC di backtest, MT5 CHIUSO, repo NON clonato):
#   irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/lavoro/backtest_pipeline/prepara_broker_esterno.ps1" -OutFile "$env:USERPROFILE\prepara_broker_esterno.ps1"
#   powershell -ExecutionPolicy Bypass -File "$env:USERPROFILE\prepara_broker_esterno.ps1" -SoloElenco -Auto
#
#  VARIANTI
#   -BrokerPattern "Pepperstone"   quale terminale usare (default)
#   -BrokerPattern "BCM"           misura il RIFERIMENTO (fallo una volta)
#   -SoloElenco                    solo ricognizione, niente download
#   -SondaStorico                  chiede al server la PRIMA DATA di ogni
#                                  simbolo. ATTENZIONE: blocca. Misurato
#                                  913 s su un solo simbolo (US30, mercato
#                                  chiuso). Usalo SOLO con -Filtro stretto.
#   -SoloMarketWatch               scandisce i 120 del Market Watch, non i
#                                  1722 del broker (una scansione completa
#                                  e' impraticabile: fino a 70 s a simbolo
#                                  per quelli senza dati)
#   -Simboli "GER40,US30,NAS100"   cosa scaricare (nomi VERI del broker)
#   -Da 2018.01.01                 da quando
#   -Filtro "GER"                  restringe l'elenco dei simboli
#   -SenzaTick                     solo barre, niente tick reali
#   -SoloReferto                   rilegge l'ultimo referto, non apre MT5
#   -SimboloGrafico "EURUSD.a"     il grafico su cui far cadere lo script.
#                                  SENZA questo parametro lo script prova
#                                  da solo le varianti note di EURUSD e si
#                                  accorge in 90 secondi se non e' partito
#                                  (il 14/08 un nome sbagliato ci e' costato
#                                  20 minuti di finestra muta).
#
#  !!! SUL VPS NON SI LANCIA MAI QUESTO SCRIPT IN MODALITA' -Auto !!!
#      -Auto (e -ChiudiMT5) chiudono terminal64: spegnerebbero i
#      terminali che tengono su gli EA in forward. Sul VPS: si lancia
#      SENZA -Auto, si installa, e si trascina lo script a mano.
# =====================================================================
param(
  [string] $BrokerPattern      = "Pepperstone",
  [string] $RiferimentoPattern = "BCM",
  [string] $Simboli            = "",
  [string] $Da                 = "2018.01.01",
  [string] $Timeframes         = "M1,M5,M15,M30,H1,H4,D1",
  [string] $Filtro             = "",
  [string] $TF                 = "H1",
  [string] $SimboloFuso        = "",
  [string] $SimboloGrafico     = "EURUSD",
  [string] $FinestraSolare     = "2025.01.06-2025.01.31",
  [string] $FinestraLegale     = "2025.07.01-2025.07.31",
  [int]    $AnniSessione       = 3,
  [switch] $SoloElenco,
  [switch] $SoloMarketWatch,
  [switch] $SondaStorico,
  [switch] $SoloReferto,
  [switch] $SenzaTick,
  [switch] $Auto,
  [switch] $ChiudiMT5,
  [int]    $TimeoutMin         = 90
)

# --- CHIUSURA PULITA DI MT5 (14/08/2026) -----------------------------
#  PERCHE': l'import creava il custom symbol e lo selezionava in Market
#  Watch, ma poi qui si ammazzava il terminale con Stop-Process -Force.
#  Le BARRE sopravvivono (MT5 le scrive man mano in bases\Custom\history),
#  la REGISTRAZIONE del simbolo no: quella viene salvata alla chiusura
#  pulita. Risultato: 148 MB di storico sul disco e un terminale che il
#  giorno dopo dice "symbol GBPUSD_EXT not exist" e non avvia il tester.
#  E' costato l'intero round R50 del 14/08, 32 lanci a vuoto.
#  Adesso si chiede prima la chiusura educata, e si ammazza solo se non
#  obbedisce.
function Chiudi-MT5-Pulito([int]$Secondi = 60) {
  $procs = @(Get-Process -Name "terminal64" -ErrorAction SilentlyContinue)
  if ($procs.Count -eq 0) { return }
  foreach ($p in $procs) {
    try { [void]$p.CloseMainWindow() } catch { }
  }
  $scade = (Get-Date).AddSeconds($Secondi)
  while ((Get-Date) -lt $scade) {
    Start-Sleep -Seconds 2
    if (@(Get-Process -Name "terminal64" -ErrorAction SilentlyContinue).Count -eq 0) {
      Write-Host "  MT5 chiuso in modo pulito (simboli personalizzati salvati)." -ForegroundColor Green
      return
    }
  }
  Write-Host "  MT5 non si e' chiuso da solo entro $Secondi s: lo forzo." -ForegroundColor Yellow
  Write-Host "  ATTENZIONE: i simboli personalizzati creati adesso potrebbero non essere salvati." -ForegroundColor Yellow
  # NOTA (15/08/2026): qui prima c'era una chiamata a Chiudi-MT5-Pulito,
  # cioe' la funzione richiamava SE STESSA: se MT5 non si chiudeva entro
  # i 60 s la ricorsione non finiva piu' e lo script restava appeso per
  # sempre. Adesso si forza davvero.
  foreach ($p in @(Get-Process -Name "terminal64" -ErrorAction SilentlyContinue)) {
    try { Stop-Process -Id $p.Id -Force -ErrorAction SilentlyContinue } catch { }
  }
  Start-Sleep -Seconds 2
}
$ErrorActionPreference = "Stop"
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$EABranch = "lavoro"
$RawBase  = "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$EABranch"
$RepoRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$Work     = Join-Path $env:USERPROFILE "abtg_broker_esterno"
New-Item -ItemType Directory -Force -Path $Work | Out-Null

function Slug([string]$s){
  $t = ($s -replace '[^A-Za-z0-9]','').ToLower()
  if ($t -eq "") { $t = "broker" }
  return $t
}
$SlugTarget = Slug $BrokerPattern
$SlugRif    = Slug $RiferimentoPattern

Write-Host ""
Write-Host "=====================================================================" -ForegroundColor Cyan
Write-Host " PREPARA BROKER ESTERNO - $BrokerPattern" -ForegroundColor Cyan
Write-Host "=====================================================================" -ForegroundColor Cyan
Write-Host " !! SUL VPS NON USARE -Auto NE' -ChiudiMT5: chiuderebbero i" -ForegroundColor Red
Write-Host "    terminali che tengono su gli EA in forward. Sul VPS si installa" -ForegroundColor Red
Write-Host "    e si trascina lo script a mano." -ForegroundColor Red
Write-Host ""

# =====================================================================
#  1. TUTTI I TERMINALI MT5 INSTALLATI (serve anche come diagnostica:
#     Claudio ha BCM, BCM -V3 e ora Pepperstone)
# =====================================================================
function Trova-Terminali {
  $root = Join-Path $env:APPDATA "MetaQuotes\Terminal"
  $out  = New-Object System.Collections.ArrayList
  if (-not (Test-Path $root)) { return ,$out }
  $i = 0
  foreach ($d in (Get-ChildItem $root -Directory -ErrorAction SilentlyContinue)) {
    if ($d.Name -ieq "Common") { continue }
    $o = Join-Path $d.FullName "origin.txt"
    if (-not (Test-Path $o)) { continue }
    $inst = ""
    try { $inst = (Get-Content $o -Raw -ErrorAction Stop).Trim() } catch { continue }
    if ([string]::IsNullOrWhiteSpace($inst)) { continue }
    $i++
    [void]$out.Add([pscustomobject]@{
      Indice     = $i
      Nome       = (Split-Path $inst -Leaf)
      Install    = $inst
      Dati       = $d.FullName
      Terminal   = (Join-Path $inst "terminal64.exe")
      MetaEditor = (Join-Path $inst "metaeditor64.exe")
      Ok         = (Test-Path (Join-Path $inst "terminal64.exe"))
    })
  }
  return ,$out
}

$Terminali = Trova-Terminali
Write-Host "--- TERMINALI MT5 TROVATI (da %APPDATA%\MetaQuotes\Terminal\*\origin.txt) ---" -ForegroundColor Cyan
if ($Terminali.Count -eq 0) {
  Write-Host "  NESSUNO." -ForegroundColor Red
  Write-Host "  Vuol dire che su questo PC non e' mai stato aperto un MT5, oppure che" -ForegroundColor Yellow
  Write-Host "  gira in modalita' PORTABLE (che non scrive in APPDATA)." -ForegroundColor Yellow
  exit 1
}
foreach ($t in $Terminali) {
  $stato = if ($t.Ok) { "ok" } else { "terminal64.exe NON TROVATO" }
  Write-Host ("  [{0}] {1,-34} {2}" -f $t.Indice, $t.Nome, $stato) -ForegroundColor Gray
  Write-Host ("       install: {0}" -f $t.Install) -ForegroundColor DarkGray
  Write-Host ("       dati   : {0}" -f $t.Dati)    -ForegroundColor DarkGray
}

# =====================================================================
#  2. SCELTA DEL TERMINALE
# =====================================================================
function Scegli-Terminale([string]$pattern, $lista) {
  $c = @($lista | Where-Object { $_.Ok -and ($_.Nome -like "*$pattern*" -or $_.Install -like "*$pattern*") })
  if ($c.Count -eq 0) { return $null }
  # su BCM esiste anche la copia "-V3": vince quella normale
  $primo = @($c | Where-Object { $_.Install -notlike "*-V3*" })
  if ($primo.Count -gt 0) { return $primo[0] }
  return $c[0]
}

$Scelto = Scegli-Terminale $BrokerPattern $Terminali
if (-not $Scelto) {
  Write-Host ""
  Write-Host "=== NON TROVO NESSUN TERMINALE CHE CONTENGA '$BrokerPattern' ===" -ForegroundColor Red
  Write-Host ""
  Write-Host "Non e' un bug: quel broker non e' ancora installato su questo PC," -ForegroundColor Yellow
  Write-Host "oppure non e' mai stato APERTO nemmeno una volta (finche' non lo apri" -ForegroundColor Yellow
  Write-Host "e fai login, MT5 non crea la sua cartella dati e origin.txt)." -ForegroundColor Yellow
  Write-Host ""
  Write-Host "COSA FARE, nell'ordine:" -ForegroundColor White
  Write-Host "  1. apri il sito del broker e chiedi un conto DEMO (bastano email e" -ForegroundColor White
  Write-Host "     password: nessun documento, nessun soldo)" -ForegroundColor White
  Write-Host "  2. scarica il loro MetaTrader 5 e installalo (cartella DIVERSA da BCM)" -ForegroundColor White
  Write-Host "  3. aprilo e fai login col conto demo: aspetta che il Market Watch si" -ForegroundColor White
  Write-Host "     riempia di simboli" -ForegroundColor White
  Write-Host "  4. CHIUDI MT5 e rilancia questo script." -ForegroundColor White
  Write-Host ""
  Write-Host "Se invece il terminale c'e' ma si chiama in un altro modo, guarda la" -ForegroundColor White
  Write-Host "lista qui sopra e passa il nome giusto, es. -BrokerPattern `"Pepper`"." -ForegroundColor White
  exit 1
}

$Terminal   = $Scelto.Terminal
$MetaEditor = $Scelto.MetaEditor
$DataFolder = $Scelto.Dati
$MqlFiles   = Join-Path $DataFolder "MQL5\Files"
$InfoCsv    = Join-Path $MqlFiles "ABTG_InfoBroker.csv"
$H1Csv      = Join-Path $MqlFiles "ABTG_InfoBroker_H1.csv"
$StoricoCsv = Join-Path $MqlFiles "ABTG_StoricoScaricato.csv"

Write-Host ""
Write-Host ("--- SCELTO: [{0}] {1}" -f $Scelto.Indice, $Scelto.Nome) -ForegroundColor Green
Write-Host ("    dati: {0}" -f $DataFolder) -ForegroundColor DarkGray

$Riferimento = $null
$EQuestoIlRiferimento = ($SlugTarget -eq $SlugRif)
if (-not $EQuestoIlRiferimento) {
  $Riferimento = Scegli-Terminale $RiferimentoPattern $Terminali
  if ($Riferimento) {
    Write-Host ("    riferimento fuso: [{0}] {1}" -f $Riferimento.Indice, $Riferimento.Nome) -ForegroundColor DarkGray
  } else {
    Write-Host ("    riferimento '{0}' non trovato: il confronto del fuso non sara' possibile." -f $RiferimentoPattern) -ForegroundColor Yellow
  }
}

# =====================================================================
#  LETTURA DEI REFERTI (le due sezioni del CSV del ricognitore)
# =====================================================================
function Leggi-Testo([string]$path) {
  if (-not (Test-Path $path)) { return $null }
  # lettura condivisa: MT5 puo' avere ancora il file aperto
  try {
    $fs = [System.IO.File]::Open($path, 'Open', 'Read', 'ReadWrite')
    $sr = New-Object System.IO.StreamReader($fs)
    $t  = $sr.ReadToEnd(); $sr.Close(); $fs.Close()
    if ([string]::IsNullOrWhiteSpace($t)) { return $null }
    return $t
  } catch {
    try {
      $tmp = Join-Path $env:TEMP "abtg_peek.csv"
      Copy-Item $path $tmp -Force -ErrorAction Stop
      return (Get-Content $tmp -Raw)
    } catch { return $null }
  }
}

function Leggi-Info([string]$path) {
  $t = Leggi-Testo $path
  if (-not $t) { return $null }
  $righe = $t -split "`r?`n"
  $iSrv = -1; $iSym = -1; $iSes = -1
  for ($k=0; $k -lt $righe.Count; $k++) {
    $r = $righe[$k].Trim()
    if ($r -eq "[SERVER]")   { $iSrv = $k }
    if ($r -eq "[SIMBOLI]")  { $iSym = $k }
    if ($r -eq "[SESSIONI]") { $iSes = $k }
  }
  if ($iSrv -lt 0 -or $iSym -lt 0) { return $null }
  $info = @{}
  # guardia sull'intervallo: in PowerShell 3..1 si INVERTE invece di essere
  # vuoto, e leggerebbe le righe al contrario senza dire niente
  if ($iSym -gt ($iSrv+1)) {
    foreach ($o in (($righe[($iSrv+1)..($iSym-1)]) -join "`n" | ConvertFrom-Csv)) {
      if ($o.Campo) { $info[[string]$o.Campo] = [string]$o.Valore }
    }
  }
  $fineSym = if ($iSes -gt 0) { $iSes - 1 } else { $righe.Count - 1 }
  $simboli = @()
  if ($fineSym -gt $iSym) {
    $simboli = @(($righe[($iSym+1)..$fineSym]) -join "`n" | ConvertFrom-Csv)
  }
  $sessioni = @()
  if ($iSes -gt 0 -and ($righe.Count-1) -gt $iSes) {
    $sessioni = @(($righe[($iSes+1)..($righe.Count-1)]) -join "`n" | ConvertFrom-Csv)
  }
  return [pscustomobject]@{ Info=$info; Simboli=$simboli; Sessioni=$sessioni }
}

# =====================================================================
#  LA MISURA CHE VALE PER IL PASSATO: shift fra due feed sulle H1
#   Stessa idea di CalibraShift in ABTG_ImportaStoricoEsterno.mq5, ma
#   qui i due feed stanno su DUE TERMINALI diversi, quindi il confronto
#   si puo' fare solo fuori da MT5.
#   CONVENZIONE: shift s = ore da SOMMARE all'ora del broker esterno per
#   ottenere l'ora BCM della stessa barra. Quindi
#        ora server BCM = ora server esterno + s
#        ora server esterno = ora server BCM - s
# =====================================================================
function Confronta-Fuso($h1Target, $h1Rif) {
  $esiti = @{}
  $tt = Leggi-Testo $h1Target
  $tr = Leggi-Testo $h1Rif
  if (-not $tt -or -not $tr) { return $null }
  $A = @($tt | ConvertFrom-Csv)
  $B = @($tr | ConvertFrom-Csv)
  if ($A.Count -eq 0 -or $B.Count -eq 0) { return $null }

  foreach ($fin in @("SOLARE","LEGALE")) {
    $a = @($A | Where-Object { $_.Finestra -eq $fin })
    $b = @($B | Where-Object { $_.Finestra -eq $fin })
    if ($a.Count -lt 20 -or $b.Count -lt 20) {
      Write-Host ("  finestra {0}: dati insufficienti ({1} barre esterne, {2} BCM)" -f $fin, $a.Count, $b.Count) -ForegroundColor Yellow
      continue
    }
    $mapB = @{}
    $sommaB = 0.0
    foreach ($r in $b) {
      try {
        $t = [datetime]::ParseExact([string]$r.DataOra, "yyyy.MM.dd HH:mm", [Globalization.CultureInfo]::InvariantCulture)
        $c = [double](([string]$r.Close) -replace ',','.')
      } catch { continue }
      $mapB[$t.ToString("yyyyMMddHH")] = $c
      $sommaB += $c
    }
    $mediaB = if ($mapB.Count -gt 0) { $sommaB / $mapB.Count } else { 0 }

    Write-Host ""
    Write-Host ("  --- FINESTRA {0} ---" -f $fin) -ForegroundColor White
    Write-Host "   shift |  diff media assoluta |  diff media (%)  |  barre H1 confrontate" -ForegroundColor Gray
    $best = $null; $bestDiff = -1.0; $bestN = 0
    for ($s = -6; $s -le 6; $s++) {
      $somma = 0.0; $n = 0
      foreach ($r in $a) {
        try {
          $t = [datetime]::ParseExact([string]$r.DataOra, "yyyy.MM.dd HH:mm", [Globalization.CultureInfo]::InvariantCulture)
          $c = [double](([string]$r.Close) -replace ',','.')
        } catch { continue }
        $k = $t.AddHours($s).ToString("yyyyMMddHH")
        if (-not $mapB.ContainsKey($k)) { continue }
        $somma += [math]::Abs($c - $mapB[$k]); $n++
      }
      # NB: niente "{0,+5}" nel formato: l'allineamento con il segno piu'
      # esplicito fa esplodere String.Format con un FormatException.
      if ($n -eq 0) { Write-Host ("   {0,5} |          (nessuna sovrapposizione)" -f $s) -ForegroundColor DarkGray; continue }
      $media = $somma / $n
      $pct   = if ($mediaB -gt 0) { 100.0 * $media / $mediaB } else { 0 }
      Write-Host ("   {0,5} | {1,20:N2} | {2,15:N4}% | {3,8}" -f $s, $media, $pct, $n) -ForegroundColor Gray
      if ($n -ge 50 -and ($bestDiff -lt 0 -or $media -lt $bestDiff)) { $bestDiff = $media; $best = $s; $bestN = $n }
    }
    if ($null -eq $best) {
      Write-Host "   -> nessuno shift con almeno 50 barre in comune: NON MISURABILE." -ForegroundColor Yellow
    } else {
      Write-Host ("   -> shift migliore: {0:+#;-#;0} ore  (diff media {1:N2} su {2} barre)" -f $best, $bestDiff, $bestN) -ForegroundColor Green
      $esiti[$fin] = $best
    }
  }
  if ($esiti.Count -eq 0) { return $null }
  return $esiti
}

# =====================================================================
#  GLI ORARI DEI NOSTRI EA (tutti in ORA SERVER BCM)
#   Non e' un elenco esaustivo: la regola e' che QUALUNQUE input con
#   Hour/Min nel nome e' in ora server e va rimappato.
# =====================================================================
$OrariEA = @(
  @{ EA="ABTG_DAX_Apertura_EU (+ _Ottimizzato, _Live5m, Apertura_Marco)"; Campo="InpSessionHour / InpSessionMin"; H=8;  M=0;  Nota="apertura cash DAX = 09:00 IT" },
  @{ EA="ABTG_Dow_Apertura_US";                                          Campo="InpSessionHour / InpSessionMin"; H=14; M=30; Nota="apertura cash USA = 15:30 IT" },
  @{ EA="ABTG_Nasdaq_Apertura_US (+ _Ottimizzato, _Live5m)";             Campo="InpSessionHour / InpSessionMin"; H=14; M=30; Nota="apertura cash USA = 15:30 IT" },
  @{ EA="ABTG_EasyTrend";                                                Campo="InpHourStart";                   H=8;  M=0;  Nota="inizio fascia oraria" },
  @{ EA="ABTG_EasyTrend";                                                Campo="InpHourEnd";                     H=18; M=0;  Nota="fine fascia (estremo incluso)" },
  @{ EA="ABTG_MaxMinNotte (+ _DAX_Short_Ottimizzato)";                   Campo="InpBoxStartHour / Min";          H=23; M=0;  Nota="inizio box notturno" },
  @{ EA="ABTG_MaxMinNotte (+ _DAX_Short_Ottimizzato)";                   Campo="InpBoxEndHour / Min";            H=4;  M=59; Nota="fine box notturno" },
  @{ EA="ABTG_MaxMinNotte - variante ORO (prove R17/R19)";               Campo="InpBoxStartHour";                H=22; M=0;  Nota="box notturno oro" },
  @{ EA="ABTG_MaxMinNotte - variante ORO (prove R17/R19)";               Campo="InpBoxEndHour";                  H=6;  M=0;  Nota="box notturno oro" },
  @{ EA="ABTG_Nightly (+ _Ottimizzato)";                                 Campo="InpBoxStartHour / Min";          H=22; M=0;  Nota="inizio box" },
  @{ EA="ABTG_Nightly (+ _Ottimizzato)";                                 Campo="InpBoxEndHour / Min";            H=4;  M=59; Nota="fine box" },
  @{ EA="ABTG_ORB (+ _Ottimizzato)";                                     Campo="InpRangeStartHour / Min";        H=14; M=25; Nota="inizio range USA" },
  @{ EA="ABTG_ORB (+ _Ottimizzato)";                                     Campo="InpRangeEndHour / Min";          H=14; M=30; Nota="fine range = apertura USA" },
  @{ EA="ABTG_ORB (+ _Ottimizzato)";                                     Campo="InpEndHour";                     H=22; M=0;  Nota="chiusura giornata" },
  @{ EA="ABTG_ORB_Fibo";                                                 Campo="InpORStartHour";                 H=14; M=30; Nota="apertura USA" },
  @{ EA="ABTG_Londra_ORB";                                               Campo="InpRangeStartHour";              H=6;  M=0;  Nota="inizio range Londra" },
  @{ EA="ABTG_Londra_ORB";                                               Campo="InpRangeEndHour";                H=7;  M=0;  Nota="apertura Londra" },
  @{ EA="ABTG_DAX_M3";                                                   Campo="InpStartHour";                   H=8;  M=0;  Nota="inizio ingressi" },
  @{ EA="ABTG_DAX_M3";                                                   Campo="InpEndHour";                     H=17; M=0;  Nota="stop nuovi ingressi" },
  @{ EA="ABTG_SupertrendInvert";                                         Campo="InpStartHour";                   H=7;  M=0;  Nota="inizio ingressi" },
  @{ EA="ABTG_SupertrendInvert";                                         Campo="InpEndHour";                     H=20; M=0;  Nota="stop ingressi" }
)

function Rimappa([int]$h, [int]$m, [int]$deltaMin) {
  $tot = (($h*60 + $m + $deltaMin) % 1440 + 1440) % 1440
  return ("{0:00}:{1:00}" -f [math]::Floor($tot/60), ($tot % 60))
}

function Stampa-Rimappatura([int]$deltaMin, [string]$origine) {
  $dh = $deltaMin / 60.0
  Write-Host ""
  Write-Host "=====================================================================" -ForegroundColor Cyan
  Write-Host " FORMULA DI RIMAPPATURA DEGLI ORARI" -ForegroundColor Cyan
  Write-Host "=====================================================================" -ForegroundColor Cyan
  Write-Host ("   ora server {0} = ora server BCM {1}{2} ore" -f $BrokerPattern, $(if($dh -ge 0){"+ "}else{"- "}), [math]::Abs($dh)) -ForegroundColor White
  Write-Host ("   (fonte del numero: {0})" -f $origine) -ForegroundColor DarkGray
  Write-Host ""
  Write-Host ("   {0,-52} {1,-30} {2,7} -> {3,7}   {4}" -f "EA","INPUT","BCM",$BrokerPattern.ToUpper(),"NOTA") -ForegroundColor Gray
  foreach ($o in $OrariEA) {
    $vecchio = ("{0:00}:{1:00}" -f $o.H, $o.M)
    $nuovo   = Rimappa $o.H $o.M $deltaMin
    Write-Host ("   {0,-52} {1,-30} {2,7} -> {3,7}   {4}" -f $o.EA, $o.Campo, $vecchio, $nuovo, $o.Nota) -ForegroundColor White
  }
  Write-Host ""
  Write-Host "   REGOLA GENERALE: qualunque input con Hour/Min nel nome e' in ORA" -ForegroundColor Yellow
  Write-Host "   SERVER e va rimappato. Se te ne dimentichi uno, l'EA opera a un'ora" -ForegroundColor Yellow
  Write-Host "   che non c'entra niente col mercato e il verdetto e' spazzatura." -ForegroundColor Yellow
  Write-Host ""
  Write-Host "   ATTENZIONE DST: questo delta NON e' costante tutto l'anno." -ForegroundColor Red
  Write-Host "   USA cambia ora la 2a domenica di marzo e la 1a di novembre, l'Europa" -ForegroundColor Red
  Write-Host "   l'ultima di marzo e l'ultima di ottobre. Nelle 2-3 settimane in mezzo" -ForegroundColor Red
  Write-Host "   il delta vale UN'ORA DI MENO, e questo si ripete OGNI ANNO del" -ForegroundColor Red
  Write-Host "   backtest. Quei giorni vanno esclusi o dichiarati: vedi la sezione" -ForegroundColor Red
  Write-Host "   FUSO di docs\BROKER_ESTERNO_MAPPA.md." -ForegroundColor Red
}

# =====================================================================
#  CANDIDATI PER LA MAPPA DEI SIMBOLI (proposte, NON verita')
# =====================================================================
$MappaAttesa = @(
  @{ BCM="D30EUR"; Che="DAX 40";        Chiavi=@("GER40","DE40","GER30","DE30","DAX") },
  @{ BCM="U30USD"; Che="Dow Jones 30";  Chiavi=@("US30","DJ30","WS30","DOW") },
  @{ BCM="NASUSD"; Che="Nasdaq 100";    Chiavi=@("NAS100","US100","USTEC","NDX","NAS") },
  @{ BCM="225JPY"; Che="Nikkei 225";    Chiavi=@("JPN225","JP225","NI225","NIKKEI") },
  @{ BCM="F40EUR"; Che="CAC 40";        Chiavi=@("FRA40","FR40","CAC") },
  @{ BCM="E35EUR"; Che="IBEX 35";       Chiavi=@("SPA35","ES35","IBEX") },
  @{ BCM="SPXUSD"; Che="S&P 500";       Chiavi=@("US500","SPX500","SP500","SPX") },
  @{ BCM="UKOIL";  Che="Brent";         Chiavi=@("UKOIL","BRENT","XBR") },
  @{ BCM="USOIL";  Che="WTI";           Chiavi=@("USOIL","WTI","XTI","CRUDE") },
  @{ BCM="XAUUSD"; Che="Oro";           Chiavi=@("XAUUSD","GOLD") },
  @{ BCM="XAGUSD"; Che="Argento";       Chiavi=@("XAGUSD","SILVER") }
)

function Stampa-Candidati($simboli) {
  Write-Host ""
  Write-Host "--- CANDIDATI PER LA MAPPA BCM -> $BrokerPattern (DA CONFERMARE A MANO) ---" -ForegroundColor Cyan
  Write-Host "    Sono solo nomi che ASSOMIGLIANO: la conferma la dai tu leggendo la" -ForegroundColor Yellow
  Write-Host "    descrizione e la prima data. Un nome simile puo' essere un future" -ForegroundColor Yellow
  Write-Host "    con scadenza, un mini, o un indice calcolato in un'altra valuta." -ForegroundColor Yellow
  Write-Host ""
  foreach ($m in $MappaAttesa) {
    $trovati = @()
    foreach ($k in $m.Chiavi) {
      $trovati += @($simboli | Where-Object { ([string]$_.Simbolo).ToUpper() -like "*$k*" })
    }
    $trovati = @($trovati | Sort-Object -Property Simbolo -Unique | Select-Object -First 4)
    if ($trovati.Count -eq 0) {
      Write-Host ("   {0,-8} {1,-14} -> NESSUN CANDIDATO (guarda l'elenco completo)" -f $m.BCM, $m.Che) -ForegroundColor DarkYellow
    } else {
      foreach ($t in $trovati) {
        Write-Host ("   {0,-8} {1,-14} -> {2,-14} prima D1: {3,-12} {4}" -f $m.BCM, $m.Che, $t.Simbolo, $t.PrimaDataD1, $t.Descrizione) -ForegroundColor White
      }
    }
  }
}

function Mostra-Info($ref, [string]$titolo) {
  if (-not $ref) { return }
  $i = $ref.Info
  Write-Host ""
  Write-Host "--- $titolo ---" -ForegroundColor Cyan
  foreach ($k in @("Broker","Server","Conto","TipoConto","Valuta","OraServer","OraGMT","OffsetServerGMT_hhmm","MercatoAperto","SimboliBroker","MisuratoIl")) {
    if ($i.ContainsKey($k)) { Write-Host ("    {0,-22} {1}" -f $k, $i[$k]) -ForegroundColor Gray }
  }
  $n = @($ref.Simboli).Count
  Write-Host ("    simboli nel referto    {0}" -f $n) -ForegroundColor Gray
  # --- il referto e' COMPLETO? (15/08/2026: 9 su 1722, e non si vedeva)
  $attesi = 0
  if ($i.ContainsKey("SimboliBroker")) { $attesi = [int]("0" + ($i["SimboliBroker"] -replace "[^0-9]", "")) }
  $inMW = 0
  if ($i.ContainsKey("SimboliMarketWatch")) { $inMW = [int]("0" + ($i["SimboliMarketWatch"] -replace "[^0-9]", "")) }
  if ($attesi -gt 0 -and $n -gt 0 -and $n -lt $attesi -and $n -lt $inMW) {
    Write-Host ""
    Write-Host ("    !!! REFERTO INCOMPLETO: {0} simboli elencati su {1} del broker." -f $n, $attesi) -ForegroundColor Red
    Write-Host  "    La scansione si e' interrotta prima della fine: NON si puo'" -ForegroundColor Red
    Write-Host  "    concludere che un simbolo 'non c'e'' guardando questo elenco." -ForegroundColor Red
    Write-Host  "    Rilancia con -SoloMarketWatch (o con -Filtro stretto)." -ForegroundColor Yellow
  }
  $ses = @($ref.Sessioni | Where-Object { $_.Data -eq "VERDETTO_DST" })
  if ($ses.Count -gt 0) {
    Write-Host ""
    Write-Host ("    APERTURA DI SESSIONE PER STAGIONE ({0}):" -f $ses[0].Simbolo) -ForegroundColor White
    Write-Host ("      ora solare (gen/nov) : {0}" -f $ses[0].PrimaBarra) -ForegroundColor White
    Write-Host ("      ora legale (apr/lug) : {0}" -f $ses[0].UltimaBarra) -ForegroundColor White
    $v = [string]$ses[0].Nota
    $col = if ($v -like "ATTENZIONE*") { "Red" } else { "Green" }
    Write-Host ("      -> {0}" -f $v) -ForegroundColor $col
    if ($v -like "ATTENZIONE*") {
      Write-Host "      Questo server NON segue il DST del mercato: gli EA a orario" -ForegroundColor Red
      Write-Host "      fisso sono sbagliati per meta' anno, anche quelli VIVI." -ForegroundColor Red
    }
  }
}

# =====================================================================
#  RACCOLTA SUL DESKTOP (regola delle righe di lancio)
# =====================================================================
function Raccogli-SulDesktop {
  $dest = Join-Path ([Environment]::GetFolderPath("Desktop")) "broker_esterno"
  New-Item -ItemType Directory -Force -Path $dest | Out-Null
  $attesi = New-Object System.Collections.ArrayList
  foreach ($f in @(
      @{ Da=$InfoCsv;    A=("ABTG_InfoBroker_{0}.csv"    -f $SlugTarget) },
      @{ Da=$H1Csv;      A=("ABTG_InfoBroker_H1_{0}.csv" -f $SlugTarget) },
      @{ Da=$StoricoCsv; A=("ABTG_StoricoScaricato_{0}.csv" -f $SlugTarget) })) {
    if (Test-Path $f.Da) {
      Copy-Item $f.Da (Join-Path $dest $f.A) -Force -ErrorAction SilentlyContinue
      Copy-Item $f.Da (Join-Path $Work $f.A) -Force -ErrorAction SilentlyContinue
      [void]$attesi.Add($f.A)
    }
  }
  # anche le copie del riferimento, se ci sono: servono in chat insieme
  foreach ($f in (Get-ChildItem $Work -Filter ("*_{0}.csv" -f $SlugRif) -ErrorAction SilentlyContinue)) {
    Copy-Item $f.FullName $dest -Force -ErrorAction SilentlyContinue
    [void]$attesi.Add($f.Name)
  }
  $logDir = Join-Path $DataFolder "MQL5\Logs"
  if (Test-Path $logDir) {
    Get-ChildItem $logDir -Filter "*.log" -ErrorAction SilentlyContinue |
      Sort-Object LastWriteTime -Descending | Select-Object -First 2 |
      ForEach-Object { Copy-Item $_.FullName $dest -Force -ErrorAction SilentlyContinue }
  }
  $zip = Join-Path ([Environment]::GetFolderPath("Desktop")) "broker_esterno.zip"
  try { Compress-Archive -Path (Join-Path $dest "*") -DestinationPath $zip -Force } catch { }
  $n = (Get-ChildItem $dest -File -ErrorAction SilentlyContinue | Measure-Object).Count
  Write-Host ""
  Write-Host ("RACCOLTA: {0} file in {1}" -f $n, $dest) -ForegroundColor Green
  Write-Host ("ZIP PRONTO DA MANDARE: {0}" -f $zip) -ForegroundColor Green
  Write-Host "Verifica che dentro ci siano:" -ForegroundColor DarkGray
  foreach ($a in $attesi) { Write-Host ("   - {0}" -f $a) -ForegroundColor DarkGray }
  Write-Host "   - gli ultimi 2 log di MT5 (*.log)" -ForegroundColor DarkGray
}

# =====================================================================
#  IL REFERTO COMPLETO (usato sia dopo il lancio sia con -SoloReferto)
# =====================================================================
function Mostra-Referto {
  $ref = Leggi-Info $InfoCsv
  if (-not $ref) {
    Write-Host ""
    Write-Host "Nessun referto leggibile in:" -ForegroundColor Yellow
    Write-Host ("  {0}" -f $InfoCsv) -ForegroundColor Yellow
    Write-Host "O il ricognitore non e' ancora stato eseguito, o MT5 lo sta ancora" -ForegroundColor Yellow
    Write-Host "scrivendo: chiudi MT5 e rilancia con -SoloReferto." -ForegroundColor Yellow
    return
  }
  Mostra-Info $ref ("REFERTO SERVER - {0}" -f $BrokerPattern)

  $sym = @($ref.Simboli)
  if ($sym.Count -gt 0) {
    Write-Host ""
    Write-Host ("--- SIMBOLI DEL BROKER: {0} righe ---" -f $sym.Count) -ForegroundColor Cyan
    $sym | Select-Object Simbolo, Digits, Point, ContractSize, TickValue, PrimaDataTF, PrimaDataD1, Stato, Descrizione |
      Format-Table -AutoSize
    Stampa-Candidati $sym
  }

  # --- il fuso contro il riferimento
  $deltaMin = $null; $origine = ""
  $rifInfoLocale = Join-Path $Work ("ABTG_InfoBroker_{0}.csv" -f $SlugRif)
  $rifH1Locale   = Join-Path $Work ("ABTG_InfoBroker_H1_{0}.csv" -f $SlugRif)
  if ($Riferimento) {
    $rifInfoVivo = Join-Path $Riferimento.Dati "MQL5\Files\ABTG_InfoBroker.csv"
    $rifH1Vivo   = Join-Path $Riferimento.Dati "MQL5\Files\ABTG_InfoBroker_H1.csv"
    if (Test-Path $rifInfoVivo) { Copy-Item $rifInfoVivo $rifInfoLocale -Force -ErrorAction SilentlyContinue }
    if (Test-Path $rifH1Vivo)   { Copy-Item $rifH1Vivo   $rifH1Locale   -Force -ErrorAction SilentlyContinue }
  }

  if ($EQuestoIlRiferimento) {
    Write-Host ""
    Write-Host "Questo E' il terminale di riferimento: niente confronto da fare." -ForegroundColor DarkGray
    Write-Host "Adesso rilancia lo stesso comando con -BrokerPattern `"Pepperstone`"." -ForegroundColor DarkGray
  }
  elseif (Test-Path $rifInfoLocale) {
    $rifRef = Leggi-Info $rifInfoLocale
    Mostra-Info $rifRef ("REFERTO SERVER - {0} (riferimento)" -f $RiferimentoPattern)

    # 1) delta di OGGI, dagli offset GMT misurati
    if ($rifRef -and $rifRef.Info.ContainsKey("OffsetServerGMT_min") -and $ref.Info.ContainsKey("OffsetServerGMT_min")) {
      $dOggi = [int]$ref.Info["OffsetServerGMT_min"] - [int]$rifRef.Info["OffsetServerGMT_min"]
      Write-Host ""
      Write-Host ("   DELTA DI OGGI (offset GMT misurati): {0:+#;-#;0} minuti = {1:N2} ore" -f $dOggi, ($dOggi/60.0)) -ForegroundColor White
      $deltaMin = $dOggi; $origine = "offset GMT misurati OGGI sui due terminali"
    }

    # 2) delta SUI DATI (l'unico valido per il passato)
    if (Test-Path $rifH1Locale) {
      Write-Host ""
      Write-Host "--- SHIFT MISURATO SUI DATI (chiusure H1, shift da -6 a +6) ---" -ForegroundColor Cyan
      Write-Host "    Convenzione: ora BCM = ora broker esterno + shift." -ForegroundColor DarkGray
      $esiti = Confronta-Fuso $H1Csv $rifH1Locale
      if ($esiti) {
        $sSol = if ($esiti.ContainsKey("SOLARE")) { $esiti["SOLARE"] } else { $null }
        $sLeg = if ($esiti.ContainsKey("LEGALE")) { $esiti["LEGALE"] } else { $null }
        if ($null -ne $sSol -and $null -ne $sLeg) {
          if ($sSol -ne $sLeg) {
            Write-Host ""
            Write-Host "   !!! L'OFFSET FRA I DUE BROKER NON E' COSTANTE !!!" -ForegroundColor Red
            Write-Host ("   ORA SOLARE: shift {0}   ORA LEGALE: shift {1}" -f $sSol, $sLeg) -ForegroundColor Red
            Write-Host "   MISURATO SUI DATI, non dedotto. Vuol dire che i due server" -ForegroundColor Red
            Write-Host "   seguono calendari di ora legale DIVERSI: una rimappatura con" -ForegroundColor Red
            Write-Host "   un solo numero e' sbagliata per una parte dell'anno." -ForegroundColor Red
            Write-Host "   Va dichiarato nel referto e nella mappa." -ForegroundColor Red
          } else {
            Write-Host ""
            Write-Host ("   Shift IDENTICO nelle due stagioni ({0}): l'offset fra i due" -f $sSol) -ForegroundColor Green
            Write-Host "   server e' costante nelle finestre misurate." -ForegroundColor Green
          }
        }
        $usa = if ($null -ne $sLeg) { $sLeg } else { $sSol }
        if ($null -ne $usa) {
          # ora esterno = ora BCM - shift  ->  delta da sommare agli orari BCM
          $deltaMin = -1 * [int]$usa * 60
          $origine  = "confronto delle chiusure H1 fra i due feed (misura sui DATI)"
        }
      } else {
        Write-Host "   Confronto non riuscito: mancano le barre H1 di una delle finestre." -ForegroundColor Yellow
        Write-Host "   Scarica lo storico (senza -SoloElenco) e rilancia." -ForegroundColor Yellow
      }
    } else {
      Write-Host ""
      Write-Host ("   Manca l'export H1 del riferimento ({0})." -f $rifH1Locale) -ForegroundColor Yellow
      Write-Host "   Il delta qui sotto e' quello di OGGI, NON quello storico." -ForegroundColor Yellow
    }
  }
  else {
    Write-Host ""
    Write-Host ("   NON HO IL RIFERIMENTO {0}: non posso calcolare la rimappatura." -f $RiferimentoPattern) -ForegroundColor Yellow
    Write-Host "   Misuralo cosi' (una volta sola, MT5 chiuso):" -ForegroundColor Yellow
    Write-Host ("     powershell -ExecutionPolicy Bypass -File `"{0}`" -BrokerPattern `"BCM`" -SoloElenco -Auto -Filtro `"D30EUR`" -SimboloFuso `"D30EUR`" -SimboloGrafico `"D30EUR`"" -f $PSCommandPath) -ForegroundColor White
  }

  if ($null -ne $deltaMin) { Stampa-Rimappatura ([int]$deltaMin) $origine }

  # --- referto dello storico, se c'e'
  $st = Leggi-Testo $StoricoCsv
  if ($st) {
    $righe = @($st | ConvertFrom-Csv)
    if ($righe.Count -gt 0) {
      Write-Host ""
      Write-Host "--- REFERTO STORICO SCARICATO ---" -ForegroundColor Cyan
      $righe | Format-Table Simbolo, Timeframe, Barre, PrimaDataLocale, PrimaDataServer, Verdetto -AutoSize
      $bloccati = @($righe | Where-Object { $_.Verdetto -like "*NON HA PIU'*" })
      if ($bloccati.Count -gt 0) {
        Write-Host "!! IL BROKER NON HA PIU' STORICO su queste righe:" -ForegroundColor Red
        foreach ($b in $bloccati) { Write-Host ("   {0} {1} -> parte dal {2}" -f $b.Simbolo, $b.Timeframe, $b.PrimaDataServer) -ForegroundColor Red }
        Write-Host "   Non si scarica quello che non esiste: si SPOSTA la finestra." -ForegroundColor Red
      }
    }
  }

  Write-Host ""
  Write-Host "=====================================================================" -ForegroundColor Cyan
  Write-Host " PROMEMORIA (criteri congelati, prove\PROVA_REGIME_CRITERI.md)" -ForegroundColor Cyan
  Write-Host "=====================================================================" -ForegroundColor Cyan
  Write-Host " Il confronto di merito si fa SEMPRE dentro lo STESSO feed: periodo" -ForegroundColor White
  Write-Host " calante contro periodo crescente sui dati di QUESTO broker. Mai" -ForegroundColor White
  Write-Host " 'Pepperstone 2022 contro BCM 2025': spread e commissioni diversi" -ForegroundColor White
  Write-Host " rendono il confronto assoluto fra feed privo di significato." -ForegroundColor White
  Write-Host " E i parametri NON si ritarano qui: la taratura resta su BCM." -ForegroundColor White
}

if ($SoloReferto) { Mostra-Referto; Raccogli-SulDesktop; exit 0 }

# =====================================================================
#  3. INSTALLA E COMPILA I DUE SCRIPT NEL TERMINALE SCELTO
# =====================================================================
function Installa-Script([string]$nome) {
  $dstDir = Join-Path $DataFolder "MQL5\Scripts"
  New-Item -ItemType Directory -Force -Path $dstDir | Out-Null
  $locale = Join-Path $RepoRoot ("..\mql5\Scripts\{0}.mq5" -f $nome)
  if (Test-Path $locale) {
    Copy-Item $locale -Destination $dstDir -Force
    Write-Host ("    {0}: sorgente dal repo locale" -f $nome) -ForegroundColor DarkGray
  } else {
    $tmp = Join-Path $Work ("{0}.mq5" -f $nome)
    try {
      Invoke-WebRequest -Uri ("{0}/mql5/Scripts/{1}.mq5" -f $RawBase, $nome) -OutFile $tmp -UseBasicParsing
      Copy-Item $tmp -Destination $dstDir -Force
      Write-Host ("    {0}: scaricato da GitHub ({1})" -f $nome, $EABranch) -ForegroundColor DarkGray
    } catch {
      Write-Host ("ERRORE: non riesco a procurarmi {0}.mq5" -f $nome) -ForegroundColor Red
      Write-Host $_.Exception.Message -ForegroundColor Red
      exit 1
    }
  }
  $mq5 = Join-Path $dstDir ("{0}.mq5" -f $nome)
  & $MetaEditor "/compile:$mq5" "/log" | Out-Null
  $ex5 = [System.IO.Path]::ChangeExtension($mq5, ".ex5")
  if (-not (Test-Path $ex5)) {
    Write-Host ("ERRORE di compilazione di {0}. Apri MetaEditor e guarda gli errori." -f $nome) -ForegroundColor Red
    exit 1
  }
  Write-Host ("    {0}: compilato" -f $nome) -ForegroundColor Green
}

Write-Host ""
Write-Host "--- INSTALLAZIONE SCRIPT ---" -ForegroundColor Cyan
Installa-Script "ABTG_InfoBroker"
Installa-Script "ABTG_HistoryDownloader"

# --- i preset
$PresetDir = Join-Path $DataFolder "MQL5\Presets"
New-Item -ItemType Directory -Force -Path $PresetDir | Out-Null

$TFNum = @{ "M1"=1; "M5"=5; "M15"=15; "M30"=30; "H1"=16385; "H4"=16388; "D1"=16408 }
$tfInfo = if ($TFNum.ContainsKey($TF.ToUpper())) { $TFNum[$TF.ToUpper()] } else { 16385 }

# -SoloMarketWatch: 120 simboli invece di 1722. Il 15/08 la scansione
# completa e' risultata impraticabile: ogni simbolo SENZA dati costa
# fino a 70 secondi, e 1722 simboli farebbero giorni. Il Market Watch
# di Pepperstone contiene gia' i maggiori indici.
$mwStr = if ($SoloMarketWatch) { "true" } else { "false" }
# -SondaStorico: chiedere al server la prima data BLOCCA. Misurato il
# 15/08 su US30 a mercato chiuso: 913 secondi PER UN SIMBOLO. Di default
# la scansione elenca i NOMI e basta; le date si chiedono dopo, con un
# -Filtro stretto e possibilmente a mercato aperto.
$sondaStr = if ($SondaStorico) { "true" } else { "false" }
if (-not $SimboloFuso -and $SimboloGrafico) { $SimboloFuso = $SimboloGrafico }
$SetInfo = Join-Path $PresetDir "abtg_infobroker.set"
@"
InpFiltro=$Filtro
InpSoloMarketWatch=$mwStr
InpSondaStorico=$sondaStr
InpNonBloccare=true
InpMaxSecScansione=600
InpTF=$tfInfo
InpSimboloFuso=$SimboloFuso
InpTFSessione=5
InpAnniSessione=$AnniSessione
InpDateCampione=01.15,03.20,04.15,07.15,10.15,10.28,11.20
InpEsportaH1=true
InpFinestraSolare=$FinestraSolare
InpFinestraLegale=$FinestraLegale
"@ | Set-Content -Path $SetInfo -Encoding ASCII
Write-Host "    preset: MQL5\Presets\abtg_infobroker.set" -ForegroundColor Green

$tick = if ($SenzaTick) { "false" } else { "true" }
$SetStorico = Join-Path $PresetDir "abtg_storico.set"
@"
InpSimboli=$Simboli
InpTimeframes=$Timeframes
InpDataInizio=$Da
InpListaSoloNomi=false
InpTuttiBroker=false
InpTimeoutSec=120
InpScaricaTick=$tick
"@ | Set-Content -Path $SetStorico -Encoding ASCII
Write-Host "    preset: MQL5\Presets\abtg_storico.set" -ForegroundColor Green

# =====================================================================
#  4. LANCIO
# =====================================================================
# --- legge la CODA dei log MT5 (solo i byte aggiunti dopo l'avvio) ----
#  Serve a capire se lo script e' PARTITO DAVVERO. I log MT5 sono UTF-16,
#  quindi l'offset da cui si riprende va portato a un numero pari.
function Coda-Log([hashtable]$lunghezzePrima) {
  $logDir = Join-Path $DataFolder "MQL5\Logs"
  if (-not (Test-Path $logDir)) { return "" }
  $tutto = ""
  foreach ($f in (Get-ChildItem $logDir -Filter "*.log" -ErrorAction SilentlyContinue)) {
    $da = 0
    if ($lunghezzePrima.ContainsKey($f.FullName)) { $da = [int64]$lunghezzePrima[$f.FullName] }
    if ($da % 2 -ne 0) { $da = $da - 1 }
    try {
      $fs = New-Object System.IO.FileStream($f.FullName, [System.IO.FileMode]::Open, [System.IO.FileAccess]::Read, [System.IO.FileShare]::ReadWrite)
      if ($da -gt 0 -and $da -lt $fs.Length) { [void]$fs.Seek($da, [System.IO.SeekOrigin]::Begin) }
      $sr = New-Object System.IO.StreamReader($fs, [System.Text.Encoding]::Unicode, $false)
      $tutto = $tutto + $sr.ReadToEnd()
      $sr.Close(); $fs.Close()
    } catch { }
  }
  return $tutto
}

#  $avvioMax = dopo quanti secondi, se lo script NON risulta partito,
#  si smette di aspettare. 0 = aspetta comunque tutto il timeout.
#  PERCHE' (14/08/2026): con -SimboloGrafico "EURUSD.p" (nome preso dal
#  server vecchio) MT5 non apriva nessun grafico, lo script non partiva
#  mai e restavamo 20 minuti davanti a una finestra muta. Adesso la
#  differenza fra "non e' partito" e "sta lavorando" si vede in un minuto.
function Lancia-Auto([string]$scriptName, [string]$setName, [string]$simbolo, [string]$periodo, [string]$fileAtteso, [int]$minuti, [int]$avvioMax = 0) {
  $running = Get-Process -Name "terminal64" -ErrorAction SilentlyContinue
  if ($running -and $ChiudiMT5) {
    Write-Host "MT5 e' aperto: lo chiudo (-ChiudiMT5)." -ForegroundColor Yellow
    Chiudi-MT5-Pulito
    Start-Sleep -Seconds 5
    $running = Get-Process -Name "terminal64" -ErrorAction SilentlyContinue
  }
  if ($running) {
    Write-Host ""
    Write-Host "MT5 e' APERTO. In automatico non si puo': un secondo avvio sulla" -ForegroundColor Red
    Write-Host "stessa cartella dati non esegue lo script." -ForegroundColor Red
    Write-Host "Aggiungi -ChiudiMT5, oppure usa la modalita' manuale (senza -Auto)." -ForegroundColor Red
    Write-Host "SUL VPS: NON usare -ChiudiMT5, spegneresti gli EA in forward." -ForegroundColor Red
    exit 1
  }
  if (Test-Path $fileAtteso) { Remove-Item $fileAtteso -Force -ErrorAction SilentlyContinue }

  $ini = Join-Path $env:TEMP ("abtg_{0}.ini" -f $scriptName)
@"
[Charts]
MaxBars=2000000000

[StartUp]
Script=$scriptName
ScriptParameters=$setName
Symbol=$simbolo
Period=$periodo
"@ | Set-Content -Path $ini -Encoding Unicode

  # fotografia dei log PRIMA di partire: cosi' dopo si legge solo il nuovo
  $lenPrima = @{}
  $logDirL = Join-Path $DataFolder "MQL5\Logs"
  if (Test-Path $logDirL) {
    foreach ($f in (Get-ChildItem $logDirL -Filter "*.log" -ErrorAction SilentlyContinue)) {
      $lenPrima[$f.FullName] = $f.Length
    }
  }

  Write-Host ""
  Write-Host ("Avvio MT5 in automatico: {0} su {1} (timeout {2} min)..." -f $scriptName, $simbolo, $minuti) -ForegroundColor Cyan
  Start-Process -FilePath $Terminal -ArgumentList "/config:$ini"

  $ErrorActionPreference = "Continue"
  $partenza  = Get-Date
  $scaduto   = $partenza.AddMinutes($minuti)
  $ultimaLen = -1
  $fermoDa   = 0
  $visto     = $false
  $partito   = $false
  $script:UltimoAvvioFallito = $false
  while ((Get-Date) -lt $scaduto) {
    Start-Sleep -Seconds 15
    # --- lo script e' partito davvero? (prima di stare li' 20 minuti) ---
    if ($avvioMax -gt 0 -and -not $partito -and -not (Test-Path $fileAtteso)) {
      $coda = Coda-Log $lenPrima
      if ($coda -match [regex]::Escape($scriptName)) {
        $partito = $true
        Write-Host ("  {0} risulta partito (traccia nel log)." -f $scriptName) -ForegroundColor DarkGray
      } elseif (((Get-Date) - $partenza).TotalSeconds -ge $avvioMax) {
        Write-Host ""
        Write-Host ("{0} NON e' partito entro {1} s su '{2}'." -f $scriptName, $avvioMax, $simbolo) -ForegroundColor Yellow
        Write-Host "  Quasi sempre vuol dire: quel simbolo non esiste su questo broker," -ForegroundColor Yellow
        Write-Host "  quindi MT5 non apre nessun grafico e lo script non parte mai." -ForegroundColor Yellow
        Chiudi-MT5-Pulito
        Start-Sleep -Seconds 3
        $ErrorActionPreference = "Stop"
        $script:UltimoAvvioFallito = $true
        return $false
      }
    }
    # --- HA FINITO DAVVERO? -------------------------------------------
    #  Il segnale buono e' la riga di chiusura che lo script MQL5 stampa
    #  da solo ("=== FINITO:"). Il silenzio NON e' un segnale: il
    #  15/08/2026 la ricognizione Pepperstone si e' fermata DUE VOLTE
    #  per questo motivo: a 9 simboli su 1722 (AUDCHF fermo 69,5 s) e
    #  poi a 7 su 120 (US30 fermo 312,9 s). Alzare la soglia non basta:
    #  la causa vera era CopyRates che dentro uno script BLOCCA, ed e'
    #  stata tolta dalla scansione (InpNonBloccare). Qui la soglia resta
    #  solo come rete, e sta sopra al tetto interno dello script.
    $coda2 = Coda-Log $lenPrima
    if ($coda2 -match "=== FINITO") {
      Write-Host "  lo script ha stampato la sua riga di chiusura: ha finito." -ForegroundColor Green
      $visto = $true
      break
    }
    if (-not (Test-Path $fileAtteso)) { continue }
    $visto   = $true
    $partito = $true
    $len = 0
    try { $len = (Get-Item $fileAtteso -ErrorAction Stop).Length } catch { continue }
    if ($len -eq $ultimaLen) {
      $fermoDa += 15
      if ($fermoDa -ge 900) {            # 15 minuti: piu' del tetto interno
        Write-Host "  fermo da 15 minuti senza riga di chiusura: mi fermo qui." -ForegroundColor Yellow
        Write-Host "  ATTENZIONE: il referto potrebbe essere INCOMPLETO." -ForegroundColor Yellow
        break
      }
    } else {
      $fermoDa = 0
      $ultimaLen = $len
      Write-Host ("  ... {0} byte scritti" -f $len) -ForegroundColor DarkGray
    }
  }
  $ErrorActionPreference = "Stop"

  Write-Host "Chiudo MT5..." -ForegroundColor DarkGray
  Chiudi-MT5-Pulito
  Start-Sleep -Seconds 3
  if (-not $visto) {
    Write-Host ("Timeout: {0} non ha prodotto niente." -f $scriptName) -ForegroundColor Red
    Write-Host "Guarda la scheda ESPERTI di MT5, poi riprova in manuale (senza -Auto)." -ForegroundColor Red
    return $false
  }
  return $true
}

function Istruzioni-Manuali([string]$scriptName, [string]$setName) {
  Write-Host @"

--- ORA IN MT5 ($($Scelto.Nome)) --------------------------------------
 1. Strumenti > Opzioni > Grafici > "Max barre nel grafico" = ILLIMITATO
    (e' il tappo numero uno: senza, il download si ferma da solo)
 2. Navigatore > Script > tasto destro > Aggiorna
 3. Trascina $scriptName su un grafico qualsiasi
 4. Nella finestra parametri: Carica > $setName
 5. OK, e guarda la scheda ESPERTI (non Giornale)
 6. Poi torna qui e lancia lo stesso comando con -SoloReferto
-----------------------------------------------------------------------
"@ -ForegroundColor Yellow
}

# --- il simbolo del grafico su cui far partire lo script: sul broker
#     nuovo NON conosciamo i nomi, quindi si usa EURUSD, che c'e'
#     praticamente ovunque. Se il broker lo chiama diversamente, si passa
#     -SimboloGrafico.
if ($SoloElenco) {
  Write-Host ""
  Write-Host "--- MODO RICOGNIZIONE (-SoloElenco): nessun download ---" -ForegroundColor Cyan
  Write-Host "    E' la prima cosa da fare: prima si guarda cosa c'e', poi si" -ForegroundColor Gray
  Write-Host "    scaricano i gigabyte (e solo dei simboli giusti)." -ForegroundColor Gray
  if ($Auto) {
    # --- i nomi da provare per il grafico di lancio ---------------------
    #  Se Claudio passa -SimboloGrafico, si usa SOLO quello (comanda lui).
    #  Altrimenti si provano le varianti con cui i broker chiamano EURUSD:
    #  la ricognizione non dipende dal simbolo, serve solo un grafico su
    #  cui far cadere lo script. Ogni tentativo sbagliato costa 90 secondi,
    #  non 20 minuti.
    $candidati = New-Object System.Collections.ArrayList
    if ($PSBoundParameters.ContainsKey("SimboloGrafico")) {
      [void]$candidati.Add($SimboloGrafico)
    } else {
      foreach ($c in @("EURUSD", "EURUSD.p", "EURUSD.a", "EURUSD.r", "EURUSD.i",
                       "EURUSD.raw", "EURUSD.pro", "EURUSD.sd", "EURUSDx")) {
        [void]$candidati.Add($c)
      }
    }
    $ok = $false
    $fusoScelto = $PSBoundParameters.ContainsKey("SimboloFuso")
    foreach ($sym in $candidati) {
      # se il nome del grafico cambia, cambia anche il simbolo su cui si
      # misurano fuso e sessioni: altrimenti il preset punterebbe a un
      # simbolo che su questo broker non esiste, e [SESSIONI] e l'export
      # H1 uscirebbero vuoti (com'e' successo il 15/08).
      if (-not $fusoScelto) {
        (Get-Content $SetInfo) -replace '^InpSimboloFuso=.*', ("InpSimboloFuso=" + $sym) |
          Set-Content -Path $SetInfo -Encoding ASCII
      }
      $ok = Lancia-Auto "ABTG_InfoBroker" "abtg_infobroker.set" $sym "H1" $InfoCsv 30 90
      if ($ok) { $SimboloGrafico = $sym; break }
      if (-not $script:UltimoAvvioFallito) { break }   # partito ma finito male: inutile cambiare simbolo
      Write-Host ("  provo il nome successivo...") -ForegroundColor DarkGray
    }
    if (-not $ok) {
      Write-Host ""
      Write-Host "=== NESSUN NOME DI GRAFICO HA FUNZIONATO ===" -ForegroundColor Red
      Write-Host "Adesso che il terminale Pepperstone e' LOGGATO ci vogliono dieci secondi:" -ForegroundColor Yellow
      Write-Host "  1. apri MT5 Pepperstone, guarda il Market Watch" -ForegroundColor White
      Write-Host "  2. leggi come si chiama esattamente l'euro-dollaro" -ForegroundColor White
      Write-Host "  3. chiudi MT5 e rilancia questa riga aggiungendo in fondo:" -ForegroundColor White
      Write-Host "       -SimboloGrafico ""<il nome vero>""" -ForegroundColor White
      Raccogli-SulDesktop
      exit 1
    }
  } else {
    Istruzioni-Manuali "ABTG_InfoBroker" "abtg_infobroker.set"
  }
  Mostra-Referto
  Raccogli-SulDesktop
  exit 0
}

# --- download vero
if (-not $Simboli) {
  Write-Host ""
  Write-Host "=== MANCA -Simboli ===" -ForegroundColor Red
  Write-Host "Non invento i nomi: sul broker nuovo il DAX non si chiama D30EUR." -ForegroundColor Yellow
  Write-Host "Prima lancia la ricognizione, leggi l'elenco vero e poi passa i nomi:" -ForegroundColor Yellow
  Write-Host ("  powershell -ExecutionPolicy Bypass -File `"{0}`" -SoloElenco -Auto" -f $PSCommandPath) -ForegroundColor White
  Write-Host ("  powershell -ExecutionPolicy Bypass -File `"{0}`" -Simboli `"GER40,US30,NAS100`" -Da 2018.01.01 -Auto" -f $PSCommandPath) -ForegroundColor White
  exit 1
}

Write-Host ""
Write-Host ("--- DOWNLOAD STORICO: {0}  (da {1}) ---" -f $Simboli, $Da) -ForegroundColor Cyan
$primoSym = ($Simboli -split ",")[0].Trim()
if (-not $SimboloFuso) { $SimboloFuso = $primoSym }

if ($Auto) {
  $ok = Lancia-Auto "ABTG_HistoryDownloader" "abtg_storico.set" $primoSym "M5" $StoricoCsv $TimeoutMin 180
  if ($ok) {
    # ricognizione DOPO il download: adesso le prime date e la tabella
    # delle sessioni sono misurate su dati veri, non su serie vuote
    Write-Host ""
    Write-Host "Rilancio il ricognitore: ora lo storico c'e', quindi la tabella" -ForegroundColor Cyan
    Write-Host "delle sessioni e l'export H1 hanno dati veri sotto." -ForegroundColor Cyan
    $SetInfo2 = Join-Path $PresetDir "abtg_infobroker.set"
    # Qui la sonda storica si PUO' riaccendere: dopo il download le serie
    # sono in locale, quindi SeriesInfoInteger risponde subito e non blocca.
    # (Bloccava solo perche' doveva chiedere al server dati che non c'erano.)
    (Get-Content $SetInfo2) `
      -replace "^InpSimboloFuso=.*",  ("InpSimboloFuso=" + $SimboloFuso) `
      -replace "^InpSondaStorico=.*", "InpSondaStorico=true" |
      Set-Content -Path $SetInfo2 -Encoding ASCII
    Lancia-Auto "ABTG_InfoBroker" "abtg_infobroker.set" $primoSym "H1" $InfoCsv 20 180 | Out-Null
  }
} else {
  Istruzioni-Manuali "ABTG_HistoryDownloader" "abtg_storico.set"
  Write-Host "Poi ripeti col ricognitore ABTG_InfoBroker + abtg_infobroker.set." -ForegroundColor Yellow
}

Mostra-Referto
Raccogli-SulDesktop
Write-Host ""
Write-Host "Manda lo zip in chat: da li' si compila docs\BROKER_ESTERNO_MAPPA.md" -ForegroundColor Cyan
Write-Host "(mappa dei simboli + sezione FUSO) e si decide se il feed passa il" -ForegroundColor Cyan
Write-Host "cancello zero della prova di regime." -ForegroundColor Cyan
