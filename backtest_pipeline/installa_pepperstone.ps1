# =====================================================================
#  installa_pepperstone.ps1  --  porta il terminale MT5 di PEPPERSTONE
#                                sul PC di backtest e ne scarica lo
#                                STORICO CON TICK REALI
# ---------------------------------------------------------------------
#  PERCHE' ESISTE:
#  lo storico BCM degli indici parte dal 26/09/2024: 21 mesi, UN SOLO
#  regime. Un secondo broker con storico piu' profondo serve come
#  PROVA DI REGIME e come controprova del feed. Questo driver fa solo
#  due cose, e le fa in ordine:
#     FASE 1  installa il terminale (se non c'e' gia')
#     FASE 2  scarica barre + TICK REALI e produce il referto
#  Chi sono i simboli, che fuso ha il server e come si rimappano gli
#  orari degli EA NON lo decide questo script: lo dice il ricognitore
#  (prepara_broker_esterno.ps1), che viene stampato in fondo.
#
#  ### ATTENZIONE: QUESTO SCRIPT SCARICA ED ESEGUE UN INSTALLER ###
#  Prima di eseguirlo stampa a schermo l'URL di provenienza, il
#  percorso del file scaricato e la sua dimensione, e chiede conferma.
#  Non installa mai niente in silenzio.
#
#  ### MAI SUL VPS ###
#  Sul VPS girano gli EA in forward: installare un altro terminale e
#  lanciare MT5 in automatico li disturba (e -Auto pretende MT5
#  chiuso). Questo script si usa SOLO sul PC di backtest.
#
#  ### IL LOGIN NON SI AUTOMATIZZA ###
#  Senza un conto (demo) collegato, il terminale NON scarica NESSUNO
#  storico: il download dei dati e' un servizio del server del broker.
#  La FASE 1 finisce quindi con le istruzioni del login e si ferma.
#
#  COME SI LANCIA (PC di backtest, MT5 CHIUSO, repo NON clonato)
#   -- passo 1: installazione
#   irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/lavoro/backtest_pipeline/installa_pepperstone.ps1" -OutFile "$env:USERPROFILE\installa_pepperstone.ps1"
#   powershell -ExecutionPolicy Bypass -File "$env:USERPROFILE\installa_pepperstone.ps1" -SoloInstalla
#
#   -- passo 2 (dopo il login demo fatto a mano): collaudo corto
#   powershell -ExecutionPolicy Bypass -File "$env:USERPROFILE\installa_pepperstone.ps1" -SoloScarica -Simboli "<NOMI VERI>" -Da 2020.01.01 -Auto
#
#   -- passo 3: il giro grande, solo se il collaudo e' andato
#   powershell -ExecutionPolicy Bypass -File "$env:USERPROFILE\installa_pepperstone.ps1" -SoloScarica -Simboli "<NOMI VERI>" -Da 2018.01.01 -Auto -TimeoutMin 600
#
#  VARIANTI
#   -SenzaTick            solo barre (minuti invece di ore, poco spazio)
#   -UrlInstaller "..."   URL diretto O percorso locale dell'installer
#   -CartellaInstall "..." dove CERCARE il terminale (vedi nota sotto)
#   -SoloReferto          rilegge l'ultimo referto senza rifare nulla
#   -Confermato           salta le domande interattive (spazio disco)
#   (niente -Auto)        prepara tutto e stampa le istruzioni manuali
#
#  NOTA ONESTA su -CartellaInstall: l'installer MetaTrader non ha un
#  parametro documentato per la cartella di destinazione, quindi qui
#  la cartella serve solo a CERCARE il terminale (installazioni fuori
#  dai percorsi standard). Se la destinazione conta davvero, va scelta
#  a mano nella finestra dell'installer (cioe' senza installazione
#  silenziosa).
# =====================================================================
param(
  [string] $Simboli        = "",
  [string] $Da             = "2018.01.01",
  [string] $Timeframes     = "M1,M5,M15,M30,H1,H4,D1",
  [switch] $SenzaTick,
  [switch] $SoloInstalla,
  [switch] $SoloScarica,
  [string] $CartellaInstall = "",
  [string] $UrlInstaller    = "",
  [switch] $Auto,
  [switch] $SoloReferto,
  [switch] $Confermato,
  [int]    $TimeoutMin      = 240,
  [int]    $TimeoutInstallMin = 20
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
  Chiudi-MT5-Pulito
}
$ErrorActionPreference = "Stop"
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$EABranch    = "lavoro"
$RawBase     = "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$EABranch"
$RepoRoot    = Split-Path -Parent $MyInvocation.MyCommand.Path
$Work        = Join-Path $env:USERPROFILE "abtg_pepperstone"
$PaginaUff   = "https://secure.pepperstone.com/downloads/metatrader5"
$NomeBroker  = "Pepperstone"
New-Item -ItemType Directory -Force -Path $Work | Out-Null

Write-Host ""
Write-Host "=====================================================" -ForegroundColor Cyan
Write-Host " INSTALLA PEPPERSTONE + SCARICA STORICO (TICK REALI)" -ForegroundColor Cyan
Write-Host "=====================================================" -ForegroundColor Cyan
Write-Host "!! SOLO sul PC di backtest. MAI sul VPS: li' girano gli EA" -ForegroundColor Yellow
Write-Host "   in forward e un secondo terminale + MT5 in automatico li" -ForegroundColor Yellow
Write-Host "   disturba." -ForegroundColor Yellow
Write-Host ""

# =====================================================================
#  FUNZIONI DI SERVIZIO
#  (duplicate di proposito: un altro driver ne ha di simili, ma qui
#   restano indipendenti cosi' i due file non si rompono a vicenda)
# =====================================================================

# --- mappa terminale -> cartella dati, via %APPDATA%\...\origin.txt ---
function Get-CartellaDati {
  param([string] $DirInstall)
  $termRoot = Join-Path $env:APPDATA "MetaQuotes\Terminal"
  if (-not (Test-Path $termRoot)) { return $null }
  $trovata = Get-ChildItem $termRoot -Directory -ErrorAction SilentlyContinue | Where-Object {
      $o = Join-Path $_.FullName "origin.txt"
      (Test-Path $o) -and ((Get-Content $o -Raw -ErrorAction SilentlyContinue).Trim() -ieq $DirInstall)
    } | Select-Object -First 1
  if ($trovata) { return $trovata.FullName }
  return $null
}

# --- cerca un terminale del broker: prima le cartelle dati (origin.txt),
#     poi i Program Files, poi l'eventuale -CartellaInstall ------------
function Trova-TerminaleBroker {
  param([string] $Nome, [string] $Extra = "")

  $candidati = New-Object System.Collections.ArrayList

  # 1) via origin.txt: e' la strada piu' affidabile, punta all'install dir
  $termRoot = Join-Path $env:APPDATA "MetaQuotes\Terminal"
  if (Test-Path $termRoot) {
    foreach ($d in (Get-ChildItem $termRoot -Directory -ErrorAction SilentlyContinue)) {
      $o = Join-Path $d.FullName "origin.txt"
      if (-not (Test-Path $o)) { continue }
      $dir = (Get-Content $o -Raw -ErrorAction SilentlyContinue).Trim()
      if (-not $dir) { continue }
      $exe = Join-Path $dir "terminal64.exe"
      if (Test-Path $exe) { [void]$candidati.Add($dir) }
    }
  }

  # 2) scansione dei percorsi di installazione classici
  $radici = @("C:\Program Files", "C:\Program Files (x86)")
  if ($Extra -and (Test-Path $Extra)) { $radici += $Extra }
  foreach ($r in $radici) {
    if (-not (Test-Path $r)) { continue }
    $trovati = Get-ChildItem $r -Recurse -Depth 3 -Filter "terminal64.exe" -ErrorAction SilentlyContinue
    foreach ($t in $trovati) { [void]$candidati.Add($t.DirectoryName) }
  }

  $unici = $candidati | Select-Object -Unique
  foreach ($dir in $unici) {
    $exe = Join-Path $dir "terminal64.exe"
    if (-not (Test-Path $exe)) { continue }
    # riconoscimento del broker: nome cartella, oppure dati di versione
    # dell'eseguibile (i terminali white-label riportano il broker li')
    $etichetta = $dir
    try {
      $vi = (Get-Item $exe).VersionInfo
      $etichetta = $etichetta + " " + $vi.CompanyName + " " + $vi.FileDescription + " " + $vi.ProductName
    } catch { }
    if ($etichetta -like ("*" + $Nome + "*")) {
      return [pscustomobject]@{ Install = $dir; Exe = $exe }
    }
  }
  return $null
}

# --- l'installer scaricato e' davvero un eseguibile? -----------------
#  Due controlli, tutti e due necessari: una pagina di errore HTML pesa
#  pochi KB e comincia con "<", un installer vero pesa MB e comincia
#  con la firma MZ. Senza questo si finisce per LANCIARE una pagina web
#  rinominata .exe.
function Test-Eseguibile {
  param([string] $Percorso, [switch] $Zitto)
  if (-not (Test-Path $Percorso)) { return $false }
  $len = (Get-Item $Percorso).Length
  if ($len -lt 300000) {
    if (-not $Zitto) { Write-Host ("   scartato: solo " + $len + " byte, non e' un installer") -ForegroundColor Yellow }
    return $false
  }
  $b = New-Object byte[] 2
  try {
    $fs = [System.IO.File]::OpenRead($Percorso)
    [void]$fs.Read($b, 0, 2)
    $fs.Close()
  } catch { return $false }
  if ($b[0] -ne 0x4D -or $b[1] -ne 0x5A) {
    if (-not $Zitto) { Write-Host "   scartato: manca la firma MZ, non e' un .exe Windows." -ForegroundColor Yellow }
    return $false
  }
  return $true
}

# --- prende l'installer: (a) pagina ufficiale, (b) -UrlInstaller -----
#  Nessun URL inventato: si prova quello che l'utente passa e la pagina
#  ufficiale (che reindirizza al file). Se la risposta non e' un .exe la
#  si tratta come HTML e si cerca dentro il primo link .exe.
function Ottieni-Installer {
  param([string] $Dest)

  # (b-bis) se -UrlInstaller e' un file gia' sul disco, si usa quello
  if ($UrlInstaller -and (Test-Path $UrlInstaller)) {
    Write-Host ("  installer locale: " + $UrlInstaller) -ForegroundColor White
    Copy-Item $UrlInstaller $Dest -Force
    return (Test-Eseguibile $Dest)
  }

  $sorgenti = New-Object System.Collections.ArrayList
  if ($UrlInstaller -like "http*") { [void]$sorgenti.Add($UrlInstaller) }  # (b) URL dato da fuori: ha la precedenza
  [void]$sorgenti.Add($PaginaUff)                                          # (a) pagina ufficiale

  $tmp = $Dest + ".parziale"
  foreach ($src in $sorgenti) {
    Write-Host ("  provo: " + $src) -ForegroundColor DarkGray
    if (Test-Path $tmp) { Remove-Item $tmp -Force -ErrorAction SilentlyContinue }
    try {
      Invoke-WebRequest -Uri $src -OutFile $tmp -UseBasicParsing -MaximumRedirection 10 -TimeoutSec 600
    } catch {
      Write-Host ("   non raggiungibile: " + $_.Exception.Message) -ForegroundColor Yellow
      continue
    }

    # 1) e' gia' il file? (il link ufficiale reindirizza al .exe)
    if (Test-Eseguibile $tmp -Zitto) {
      Move-Item $tmp $Dest -Force
      Write-Host ("  scaricato da: " + $src) -ForegroundColor Green
      return $true
    }

    # 2) altrimenti e' una pagina: si cerca dentro un link a un .exe
    $html = ""
    try { if ((Get-Item $tmp).Length -lt 20000000) { $html = Get-Content $tmp -Raw -ErrorAction Stop } } catch { }
    if (-not $html) { continue }
    $link = [regex]::Matches($html, '(?i)https?://[^"''<> ]+\.exe') |
            ForEach-Object { $_.Value } | Select-Object -Unique
    if (-not $link) { Write-Host "   nessun link .exe nella pagina." -ForegroundColor Yellow; continue }
    foreach ($l in $link) {
      Write-Host ("   link trovato nella pagina: " + $l) -ForegroundColor DarkGray
      if (Test-Path $tmp) { Remove-Item $tmp -Force -ErrorAction SilentlyContinue }
      try {
        Invoke-WebRequest -Uri $l -OutFile $tmp -UseBasicParsing -MaximumRedirection 10 -TimeoutSec 600
      } catch {
        Write-Host ("   download fallito: " + $_.Exception.Message) -ForegroundColor Yellow
        continue
      }
      if (Test-Eseguibile $tmp) {
        Move-Item $tmp $Dest -Force
        Write-Host ("  scaricato da: " + $l) -ForegroundColor Green
        return $true
      }
    }
  }
  if (Test-Path $tmp) { Remove-Item $tmp -Force -ErrorAction SilentlyContinue }
  return $false
}

# --- spazio libero sul disco della cartella indicata -----------------
function Get-SpazioLiberoGB {
  param([string] $Percorso)
  try {
    $radice = [System.IO.Path]::GetPathRoot($Percorso)
    $lettera = $radice.Substring(0,1)
    $d = Get-PSDrive -Name $lettera -ErrorAction Stop
    if ($d.Free -ne $null) { return [math]::Round($d.Free / 1GB, 1) }
  } catch { }
  try {
    $dev = ([System.IO.Path]::GetPathRoot($Percorso)).Substring(0,2)
    $w = Get-CimInstance Win32_LogicalDisk -Filter ("DeviceID='" + $dev + "'") -ErrorAction Stop
    return [math]::Round($w.FreeSpace / 1GB, 1)
  } catch { }
  return -1
}

# =====================================================================
#  FASE 1 - INSTALLAZIONE
# =====================================================================
$gia = Trova-TerminaleBroker -Nome $NomeBroker -Extra $CartellaInstall
$appenaInstallato = $false

if (-not $SoloScarica -and -not $SoloReferto) {
  Write-Host "--- FASE 1: terminale $NomeBroker ---" -ForegroundColor Cyan

  if ($gia) {
    Write-Host ("  GIA' INSTALLATO: " + $gia.Install) -ForegroundColor Green
    Write-Host "  Salto l'installazione (niente download, niente installer eseguito)." -ForegroundColor Green
  } else {
    Write-Host ("  Nessun terminale " + $NomeBroker + " trovato ne' in %APPDATA%\MetaQuotes\Terminal") -ForegroundColor Yellow
    Write-Host "  (origin.txt) ne' in Program Files." -ForegroundColor Yellow
    Write-Host ""
    Write-Host "  QUESTO SCRIPT STA PER SCARICARE ED ESEGUIRE UN INSTALLER." -ForegroundColor Yellow
    Write-Host ("  Pagina ufficiale: " + $PaginaUff) -ForegroundColor White
    Write-Host ("  Il file finira' in: " + (Join-Path $Work "pepperstone_mt5setup.exe")) -ForegroundColor White
    if (-not $Confermato) {
      $ok = Read-Host "  Procedo con download + installazione silenziosa? (s/n)"
      if ($ok -notmatch '^[sSyY]') { Write-Host "  Annullato da te. Niente e' stato scaricato." -ForegroundColor Yellow; exit 0 }
    }

    $Setup = Join-Path $Work "pepperstone_mt5setup.exe"
    if (Test-Path $Setup) { Remove-Item $Setup -Force -ErrorAction SilentlyContinue }
    if (-not (Ottieni-Installer -Dest $Setup)) {
      Write-Host ""
      Write-Host "NON SONO RIUSCITO A PROCURARMI L'INSTALLER." -ForegroundColor Red
      Write-Host "Non invento URL: si fa a mano, sono due minuti." -ForegroundColor Red
      Write-Host ("  1. apri " + $PaginaUff) -ForegroundColor White
      Write-Host "  2. scarica il file .exe (MT5 per Windows)" -ForegroundColor White
      Write-Host "  3. rilancia questo script aggiungendo:" -ForegroundColor White
      Write-Host '       -UrlInstaller "C:\percorso\del\file_scaricato.exe"' -ForegroundColor White
      Write-Host "     (accetta sia un percorso locale sia un URL diretto)" -ForegroundColor White
      exit 1
    }

    $dimMB = [math]::Round((Get-Item $Setup).Length / 1MB, 1)
    Write-Host ("  file: " + $Setup + "  (" + $dimMB + " MB, firma MZ ok)") -ForegroundColor Green
    Write-Host "  Avvio l'installazione SILENZIOSA (argomento /auto)..." -ForegroundColor Cyan
    Write-Host "  Se invece compare la finestra dell'installer, completala a mano:" -ForegroundColor DarkGray
    Write-Host "  vuol dire che questo installer non accetta /auto." -ForegroundColor DarkGray

    $p = Start-Process -FilePath $Setup -ArgumentList "/auto" -PassThru
    $scadeInst = (Get-Date).AddMinutes($TimeoutInstallMin)
    $installato = $null
    while ((Get-Date) -lt $scadeInst) {
      Start-Sleep -Seconds 10
      $installato = Trova-TerminaleBroker -Nome $NomeBroker -Extra $CartellaInstall
      if ($installato) { break }
      $vivo = Get-Process -Id $p.Id -ErrorAction SilentlyContinue
      if (-not $vivo) {
        # l'installer e' uscito: do' ancora un minuto ai file di finire
        Start-Sleep -Seconds 30
        $installato = Trova-TerminaleBroker -Nome $NomeBroker -Extra $CartellaInstall
        break
      }
    }

    if (-not $installato) {
      Write-Host ""
      Write-Host ("Dopo " + $TimeoutInstallMin + " minuti non trovo terminal64.exe di " + $NomeBroker + ".") -ForegroundColor Red
      Write-Host "Possibili motivi: l'installer chiede conferme a video, l'hai" -ForegroundColor Red
      Write-Host "installato in un percorso non standard, oppure e' ancora in corso." -ForegroundColor Red
      Write-Host "Cosa fare: completa l'installazione a mano, poi rilancia con" -ForegroundColor Red
      Write-Host '  -SoloScarica  (aggiungendo -CartellaInstall "C:\percorso" se serve)' -ForegroundColor Red
      exit 1
    }
    Write-Host ("  INSTALLATO: " + $installato.Install) -ForegroundColor Green
    $gia = $installato
    $appenaInstallato = $true
  }

  # --- il login e' MANUALE ------------------------------------------
  #  Se il terminale c'era gia', le istruzioni non servono ogni volta:
  #  si stampano se e' appena stato installato, oppure se non si vede
  #  traccia di un login (cartella bases\<server> mai creata).
  $dati = Get-CartellaDati -DirInstall $gia.Install
  $loginVisto = $false
  if ($dati) {
    $bd = Join-Path $dati "bases"
    if (Test-Path $bd) {
      $srv = @(Get-ChildItem $bd -Directory -ErrorAction SilentlyContinue |
               Where-Object { $_.Name -notin @("Default", "Custom") })
      if ($srv.Count -gt 0) { $loginVisto = $true }
    }
  }
  if (-not $appenaInstallato -and $loginVisto -and -not $SoloInstalla) {
    Write-Host "  Login gia' fatto (vedo un server in bases\): vado alla FASE 2." -ForegroundColor Green
  } else {
    Write-Host ""
    Write-Host "--- ORA IL LOGIN, CHE NON SI AUTOMATIZZA -----------------" -ForegroundColor Yellow
    Write-Host " Senza un conto collegato il terminale NON scarica NESSUNO" -ForegroundColor Yellow
    Write-Host " storico: i dati arrivano dal server del broker." -ForegroundColor Yellow
    Write-Host ""
    Write-Host "  1. apri il terminale:" -ForegroundColor White
    Write-Host ("     " + $gia.Exe) -ForegroundColor White
    Write-Host "  2. menu File > Apri un conto (Open an Account)" -ForegroundColor White
    Write-Host "  3. nella casella di ricerca scrivi: Pepperstone" -ForegroundColor White
    Write-Host "  4. scegli il server DEMO che compare (la voce con 'Demo')" -ForegroundColor White
    Write-Host "     e premi Avanti" -ForegroundColor White
    Write-Host "  5. scegli 'Apri un conto demo' (NON 'conto reale')" -ForegroundColor White
    Write-Host "  6. compila nome/email/telefono, tipo di conto e leva," -ForegroundColor White
    Write-Host "     accetta le condizioni, Avanti > FINE" -ForegroundColor White
    Write-Host "  7. segnati login/password/server che appaiono a video" -ForegroundColor White
    Write-Host "  8. in basso a destra deve comparire la connessione coi kb/s:" -ForegroundColor White
    Write-Host "     se dice 'Nessuna connessione' il login NON e' andato" -ForegroundColor White
    Write-Host "  9. Strumenti > Opzioni > Grafici > Max barre nel grafico =" -ForegroundColor White
    Write-Host "     ILLIMITATO (senza questo il download si tappa da solo)" -ForegroundColor White
    Write-Host " 10. CHIUDI il terminale (la fase 2 lo riapre lei)" -ForegroundColor White
    if ($dati) { Write-Host ("  (cartella dati: " + $dati + ")") -ForegroundColor DarkGray }
    Write-Host ""
    Write-Host "QUANDO IL LOGIN E' FATTO, rilancia questo script cosi':" -ForegroundColor Cyan
    Write-Host '  powershell -ExecutionPolicy Bypass -File "$env:USERPROFILE\installa_pepperstone.ps1" -SoloScarica -Simboli "<NOMI VERI>" -Da 2020.01.01 -Auto' -ForegroundColor Cyan
    Write-Host "I <NOMI VERI> dei simboli non li invento: li da' il ricognitore" -ForegroundColor Cyan
    Write-Host "(vedi sotto), oppure si leggono nel Market Watch del terminale." -ForegroundColor Cyan
    Write-Host ""
    Write-Host "--- DOPO IL LOGIN, il ricognitore dell'altro driver -------" -ForegroundColor Cyan
    Write-Host '  powershell -ExecutionPolicy Bypass -File "$env:USERPROFILE\prepara_broker_esterno.ps1" -SoloElenco' -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Mi fermo qui: la FASE 2 senza login scaricherebbe il nulla." -ForegroundColor Yellow
    Write-Host "Rilancia con -SoloScarica quando il login e' fatto." -ForegroundColor Yellow
    exit 0
  }
}

# =====================================================================
#  FASE 2 - DOWNLOAD STORICO + TICK REALI
# =====================================================================
if (-not $gia) {
  Write-Host ("Terminale " + $NomeBroker + " non trovato.") -ForegroundColor Red
  Write-Host "Lancia prima la FASE 1 (senza -SoloScarica), oppure indica dove" -ForegroundColor Red
  Write-Host 'sta con -CartellaInstall "C:\percorso\del\terminale".' -ForegroundColor Red
  exit 1
}

$instDir    = $gia.Install
$Terminal   = $gia.Exe
$MetaEditor = Join-Path $instDir "metaeditor64.exe"
$DataFolder = Get-CartellaDati -DirInstall $instDir
if (-not $DataFolder) {
  Write-Host "Cartella dati del terminale non trovata (origin.txt)." -ForegroundColor Red
  Write-Host "Apri il terminale UNA VOLTA e richiudilo: la cartella dati nasce li'." -ForegroundColor Red
  exit 1
}
$CsvOut = Join-Path $DataFolder "MQL5\Files\ABTG_StoricoScaricato.csv"

# ---------------------------------------------------------------------
#  referto + raccolta sul Desktop
# ---------------------------------------------------------------------
function Leggi-Csv {
  if (-not (Test-Path $CsvOut)) { return $null }
  try {
    $fs = [System.IO.File]::Open($CsvOut, 'Open', 'Read', 'ReadWrite')
    $sr = New-Object System.IO.StreamReader($fs)
    $testo = $sr.ReadToEnd(); $sr.Close(); $fs.Close()
    if ([string]::IsNullOrWhiteSpace($testo)) { return $null }
    return ($testo | ConvertFrom-Csv)
  } catch {
    try {
      $tmp = Join-Path $env:TEMP "abtg_pepperstone_peek.csv"
      Copy-Item $CsvOut $tmp -Force -ErrorAction Stop
      return (Import-Csv $tmp)
    } catch { return $null }
  }
}

function Mostra-Referto {
  $righe = Leggi-Csv
  if (-not $righe) {
    Write-Host ""
    Write-Host ("Nessun referto leggibile in: " + $CsvOut) -ForegroundColor Yellow
    Write-Host "O lo script MQL5 non e' ancora stato eseguito, o MT5 lo sta" -ForegroundColor Yellow
    Write-Host "ancora scrivendo: chiudi MT5 e rilancia con -SoloReferto." -ForegroundColor Yellow
    return
  }

  $barre = $righe | Where-Object { $_.Timeframe -ne "TICK" }
  $tick  = $righe | Where-Object { $_.Timeframe -eq "TICK" }

  Write-Host ""
  Write-Host "=== REFERTO BARRE ===" -ForegroundColor Cyan
  Write-Host $CsvOut -ForegroundColor DarkGray
  if ($barre) { $barre | Format-Table Simbolo, Timeframe, Barre, PrimaDataLocale, PrimaDataServer, Verdetto -AutoSize }

  Write-Host "=== REFERTO TICK REALI ===" -ForegroundColor Cyan
  if ($tick) {
    # nel CSV dello script MQL5 le righe TICK riusano le stesse colonne:
    # Barre = numero di tick, PrimaDataLocale = prima data dei tick
    $tick | Select-Object Simbolo,
      @{ n = "NumeroTick";   e = { $_.Barre } },
      @{ n = "PrimaDataTick"; e = { $_.PrimaDataLocale } },
      Verdetto | Format-Table -AutoSize
  } else {
    Write-Host "  nessuna riga TICK (lanciato con -SenzaTick?)" -ForegroundColor DarkGray
  }

  $bloccati = $righe | Where-Object { $_.Verdetto -like "*NON HA PIU'*" }
  $daRifare = $righe | Where-Object { $_.Verdetto -like "*MANCA STORICO*" }
  $senzaTk  = $tick  | Where-Object { $_.Verdetto -like "*NESSUN TICK*" }
  $tkParz   = $tick  | Where-Object { $_.Verdetto -like "*PARZIALI*" }

  if ($bloccati) {
    Write-Host "!! IL BROKER NON HA PIU' STORICO su queste righe:" -ForegroundColor Red
    $bloccati | ForEach-Object { Write-Host ("   " + $_.Simbolo + " " + $_.Timeframe + " -> parte dal " + $_.PrimaDataServer) -ForegroundColor Red }
    Write-Host "   Non si scarica quello che non esiste: si SPOSTA la finestra." -ForegroundColor Red
  }
  if ($daRifare) {
    Write-Host "!! Manca solo il download su queste righe: rilancia lo script." -ForegroundColor Yellow
    $daRifare | ForEach-Object { Write-Host ("   " + $_.Simbolo + " " + $_.Timeframe) -ForegroundColor Yellow }
  }
  if ($senzaTk) {
    Write-Host "!! NESSUN TICK REALE su questi simboli:" -ForegroundColor Red
    $senzaTk | ForEach-Object { Write-Host ("   " + $_.Simbolo) -ForegroundColor Red }
    Write-Host "   Senza tick il backtest 'Ogni tick sulla base dei tick reali'" -ForegroundColor Red
    Write-Host "   NON e' possibile: il tester ripiegherebbe sui tick simulati." -ForegroundColor Red
  }
  if ($tkParz) {
    Write-Host "!! TICK PARZIALI (il broker li tiene solo da una certa data):" -ForegroundColor Yellow
    $tkParz | ForEach-Object { Write-Host ("   " + $_.Simbolo + " -> dal " + $_.PrimaDataLocale) -ForegroundColor Yellow }
    Write-Host "   La finestra di test a tick reali parte da QUELLA data, non prima." -ForegroundColor Yellow
  }
  if (-not $bloccati -and -not $daRifare -and -not $senzaTk -and -not $tkParz) {
    Write-Host "OK: barre e tick completi su tutte le righe." -ForegroundColor Green
  }
}

function Raccogli-SulDesktop {
  # regola delle righe di lancio: il risultato arriva SEMPRE pronto da mandare
  $dest = Join-Path ([Environment]::GetFolderPath("Desktop")) "pepperstone_storico"
  New-Item -ItemType Directory -Force -Path $dest | Out-Null
  if (Test-Path $CsvOut) { Copy-Item $CsvOut $dest -Force -ErrorAction SilentlyContinue }
  $elenco = Join-Path $DataFolder "MQL5\Files\ABTG_SimboliBroker.txt"
  if (Test-Path $elenco) { Copy-Item $elenco $dest -Force -ErrorAction SilentlyContinue }
  $logDir = Join-Path $DataFolder "MQL5\Logs"
  if (Test-Path $logDir) {
    Get-ChildItem $logDir -Filter "*.log" -ErrorAction SilentlyContinue |
      Sort-Object LastWriteTime -Descending | Select-Object -First 2 |
      ForEach-Object { Copy-Item $_.FullName $dest -Force -ErrorAction SilentlyContinue }
  }
  # nota di contesto: senza questa, fra un mese non si sa piu' di che giro era
  $nota = Join-Path $dest "COME_E_STATO_FATTO.txt"
  @(
    "installa_pepperstone.ps1 - referto storico Pepperstone",
    ("data          : " + (Get-Date -Format "yyyy-MM-dd HH:mm")),
    ("terminale     : " + $instDir),
    ("cartella dati : " + $DataFolder),
    ("simboli       : " + $Simboli),
    ("timeframes    : " + $Timeframes),
    ("da            : " + $Da),
    ("tick reali    : " + $(if ($SenzaTick) { "NO (-SenzaTick)" } else { "SI" })),
    "",
    "ATTENZIONE: gli orari degli EA sono in ORA SERVER. Il server",
    "Pepperstone puo' avere un fuso DIVERSO da BCM: prima di qualunque",
    "test vanno rimappati (vedi prepara_broker_esterno.ps1)."
  ) | Set-Content -Path $nota -Encoding ASCII
  $zip = Join-Path ([Environment]::GetFolderPath("Desktop")) "pepperstone_storico.zip"
  Compress-Archive -Path (Join-Path $dest "*") -DestinationPath $zip -Force
  $n = (Get-ChildItem $dest -File -ErrorAction SilentlyContinue | Measure-Object).Count
  Write-Host ""
  Write-Host ("RACCOLTA: " + $n + " file in " + $dest) -ForegroundColor Green
  Write-Host ("ZIP PRONTO DA MANDARE: " + $zip) -ForegroundColor Green
  Write-Host "Attesi dentro: ABTG_StoricoScaricato.csv, COME_E_STATO_FATTO.txt," -ForegroundColor DarkGray
  Write-Host "gli ultimi 2 log di MT5 (e ABTG_SimboliBroker.txt se c'e')." -ForegroundColor DarkGray
}

function Stampa-Fase3 {
  Write-Host ""
  Write-Host "--- FASE 3: cosa si fa DOPO (non lo lancio io) ------------" -ForegroundColor Cyan
  Write-Host " 1) RICOGNITORE simboli + fuso del server Pepperstone:" -ForegroundColor White
  Write-Host '    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/lavoro/backtest_pipeline/prepara_broker_esterno.ps1" -OutFile "$env:USERPROFILE\prepara_broker_esterno.ps1"' -ForegroundColor White
  Write-Host '    powershell -ExecutionPolicy Bypass -File "$env:USERPROFILE\prepara_broker_esterno.ps1" -SoloElenco' -ForegroundColor White
  Write-Host ""
  Write-Host " 2) AVVERTENZA CHE VALE PIU' DI TUTTO IL RESTO:" -ForegroundColor Yellow
  Write-Host "    negli EA gli orari (InpSessionHour e simili) sono in ORA" -ForegroundColor Yellow
  Write-Host "    SERVER. Il server di questo broker puo' avere un offset" -ForegroundColor Yellow
  Write-Host "    DIVERSO da BCM (che sta 1 ora indietro sull'ora italiana)." -ForegroundColor Yellow
  Write-Host "    Finche' il fuso non e' misurato dal ricognitore, QUALUNQUE" -ForegroundColor Yellow
  Write-Host "    test su questi dati e' da buttare: l'EA aprirebbe all'ora" -ForegroundColor Yellow
  Write-Host "    sbagliata e il risultato non direbbe niente." -ForegroundColor Yellow
}

if ($SoloReferto) { Mostra-Referto; Raccogli-SulDesktop; Stampa-Fase3; exit 0 }

# ---------------------------------------------------------------------
#  controlli PRIMA di partire
# ---------------------------------------------------------------------
Write-Host "--- FASE 2: download storico + tick reali ---" -ForegroundColor Cyan

if (-not $Simboli) {
  Write-Host "Manca -Simboli, e io i nomi NON me li invento." -ForegroundColor Red
  Write-Host "I ticker di questo broker non sono quelli di BCM (D30EUR, NASUSD" -ForegroundColor Red
  Write-Host "e compagnia possono chiamarsi in tutt'altro modo). Prendili cosi':" -ForegroundColor Red
  Write-Host "  - dal Market Watch del terminale appena collegato, oppure" -ForegroundColor Red
  Write-Host "  - dal ricognitore: prepara_broker_esterno.ps1 -SoloElenco" -ForegroundColor Red
  Write-Host 'poi rilancia con -Simboli "NOME1,NOME2".' -ForegroundColor Red
  exit 1
}

$lista = @($Simboli -split "," | ForEach-Object { $_.Trim() } | Where-Object { $_ })
$nsym  = $lista.Count
$ntf   = @($Timeframes -split "," | Where-Object { $_ }).Count

# indizio (non prova) che il terminale abbia mai fatto login: la cartella
# bases\<NomeServer> nasce solo dopo una connessione riuscita
$basi = @()
$baseDir = Join-Path $DataFolder "bases"
if (Test-Path $baseDir) {
  $basi = @(Get-ChildItem $baseDir -Directory -ErrorAction SilentlyContinue |
            Where-Object { $_.Name -notin @("Default", "Custom") })
}
if ($basi.Count -eq 0) {
  Write-Host "!! Non vedo nessuna cartella di server in bases\: e' un INDIZIO" -ForegroundColor Yellow
  Write-Host "   (non una prova) che il terminale non abbia mai fatto login." -ForegroundColor Yellow
  Write-Host "   Senza login il download restituisce zero barre e zero tick." -ForegroundColor Yellow
  Write-Host "   Se il login lo hai fatto, tira dritto." -ForegroundColor Yellow
} else {
  Write-Host ("  server visti in bases\: " + (($basi | ForEach-Object { $_.Name }) -join ", ")) -ForegroundColor DarkGray
}

# --- spazio disco e stima --------------------------------------------
$anni = 5.0
try {
  $d0 = [datetime]::ParseExact($Da, "yyyy.MM.dd", $null)
  $anni = [math]::Round(((Get-Date) - $d0).TotalDays / 365.25, 1)
} catch { Write-Host ("  (data -Da non riconosciuta, uso una stima a 5 anni): " + $Da) -ForegroundColor Yellow }
if ($anni -lt 0.1) { $anni = 0.1 }

$liberoGB = Get-SpazioLiberoGB -Percorso $DataFolder

Write-Host ""
Write-Host ("  simboli:    " + ($lista -join ", ") + "   (" + $nsym + ")") -ForegroundColor White
Write-Host ("  timeframes: " + $Timeframes + "   (" + $ntf + ")") -ForegroundColor White
Write-Host ("  da:         " + $Da + "   (~" + $anni + " anni)") -ForegroundColor White
Write-Host ("  tick reali: " + $(if ($SenzaTick) { "NO (-SenzaTick)" } else { "SI" })) -ForegroundColor White
Write-Host ("  cartella:   " + $DataFolder) -ForegroundColor DarkGray

if (-not $SenzaTick) {
  $minGB = [math]::Round(0.4 * $nsym * $anni, 1)
  $maxGB = [math]::Round(2.0 * $nsym * $anni, 1)
  Write-Host ""
  Write-Host "  !!! TICK REALI: DECINE DI GIGABYTE E ORE DI DOWNLOAD !!!" -ForegroundColor Yellow
  Write-Host ("  stima GREZZA e NON VERIFICATA: " + $minGB + " - " + $maxGB + " GB") -ForegroundColor Yellow
  Write-Host "  (0,4-2 GB per simbolo per anno: dipende da quanto e' liquido" -ForegroundColor DarkGray
  Write-Host "   il simbolo e da come il broker comprime i tick. E' un ordine" -ForegroundColor DarkGray
  Write-Host "   di grandezza, non una misura: il numero vero si vede solo" -ForegroundColor DarkGray
  Write-Host "   dopo il primo giro.)" -ForegroundColor DarkGray
  Write-Host "  Tempo: mettici ORE, non minuti. Su piu' anni e piu' simboli" -ForegroundColor Yellow
  Write-Host "  puo' voler dire una notte intera." -ForegroundColor Yellow
}
if ($liberoGB -ge 0) {
  Write-Host ("  spazio libero sul disco: " + $liberoGB + " GB") -ForegroundColor White
} else {
  Write-Host "  spazio libero sul disco: NON RILEVATO (controllalo a mano)" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "  CONSIGLIO, dalle volte che e' andata storta: parti PICCOLO." -ForegroundColor Cyan
Write-Host "  Prima 2 simboli e un periodo corto (es. -Da 2020.01.01), guarda" -ForegroundColor Cyan
Write-Host "  il referto, e SOLO SE torna fai il giro grande. Un download di" -ForegroundColor Cyan
Write-Host "  ore che finisce con 'NESSUN TICK' e' una notte buttata." -ForegroundColor Cyan

if (-not $SenzaTick -and $liberoGB -ge 0 -and $liberoGB -lt 50) {
  Write-Host ""
  Write-Host ("  ATTENZIONE: liberi solo " + $liberoGB + " GB, sotto la soglia di 50 GB.") -ForegroundColor Red
  Write-Host "  I tick reali possono riempire il disco e MT5 in quel caso si" -ForegroundColor Red
  Write-Host "  pianta lasciando lo storico a meta'." -ForegroundColor Red
  if (-not $Confermato) {
    $ok = Read-Host "  Vuoi procedere lo stesso? (s/n)"
    if ($ok -notmatch '^[sSyY]') {
      Write-Host "  Fermato. Libera spazio, oppure usa -SenzaTick / meno simboli." -ForegroundColor Yellow
      exit 0
    }
  } else {
    Write-Host "  (-Confermato: tiro dritto lo stesso, come da tua richiesta)" -ForegroundColor Yellow
  }
}

# ---------------------------------------------------------------------
#  installa + compila lo script MQL5
# ---------------------------------------------------------------------
Write-Host ""
$Locale = Join-Path $RepoRoot "..\mql5\Scripts\ABTG_HistoryDownloader.mq5"
if (Test-Path $Locale) {
  $Src = $Locale
  Write-Host "  sorgente:  repo locale" -ForegroundColor DarkGray
} else {
  $Src = Join-Path $Work "ABTG_HistoryDownloader.mq5"
  try {
    Invoke-WebRequest -Uri "$RawBase/mql5/Scripts/ABTG_HistoryDownloader.mq5" -OutFile $Src -UseBasicParsing
    Write-Host ("  sorgente:  scaricato da GitHub (" + $EABranch + ")") -ForegroundColor DarkGray
  } catch {
    Write-Host "ERRORE: non riesco a scaricare ABTG_HistoryDownloader.mq5 da GitHub." -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
    exit 1
  }
}
$DstDir = Join-Path $DataFolder "MQL5\Scripts"
New-Item -ItemType Directory -Force -Path $DstDir | Out-Null
Copy-Item $Src -Destination $DstDir -Force
$mq5 = Join-Path $DstDir "ABTG_HistoryDownloader.mq5"
if (-not (Test-Path $MetaEditor)) {
  Write-Host ("metaeditor64.exe non trovato in " + $instDir) -ForegroundColor Red
  Write-Host "Senza MetaEditor non posso compilare: apri MT5, F4, e compila a mano." -ForegroundColor Red
  exit 1
}
& $MetaEditor "/compile:$mq5" "/log" | Out-Null
$ex5 = [System.IO.Path]::ChangeExtension($mq5, ".ex5")
if (-not (Test-Path $ex5)) { Write-Host "ERRORE di compilazione." -ForegroundColor Red; exit 1 }
Write-Host "  compilato: ABTG_HistoryDownloader.ex5" -ForegroundColor Green

# ---------------------------------------------------------------------
#  preset
# ---------------------------------------------------------------------
$PresetDir = Join-Path $DataFolder "MQL5\Presets"
New-Item -ItemType Directory -Force -Path $PresetDir | Out-Null
$SetFile = Join-Path $PresetDir "abtg_pepperstone.set"
$tick = if ($SenzaTick) { "false" } else { "true" }
@"
InpSimboli=$Simboli
InpTimeframes=$Timeframes
InpDataInizio=$Da
InpListaSoloNomi=false
InpTuttiBroker=false
InpTimeoutSec=120
InpScaricaTick=$tick
"@ | Set-Content -Path $SetFile -Encoding ASCII
Write-Host "  preset:    MQL5\Presets\abtg_pepperstone.set" -ForegroundColor Green

# ---------------------------------------------------------------------
#  modalita' MANUALE (default)
# ---------------------------------------------------------------------
if (-not $Auto) {
  Write-Host @"

--- ORA IN MT5 (2 minuti di lavoro, poi aspetta) ----------------------
 1. Strumenti > Opzioni > Grafici > "Max barre nel grafico" = ILLIMITATO
    (e' il tappo numero uno: senza questo il download si ferma da solo)
 2. controlla in basso a destra che ci sia la connessione (kb/s)
 3. Navigatore > Script > tasto destro > Aggiorna
 4. trascina ABTG_HistoryDownloader su un grafico qualsiasi
 5. nella finestra parametri: Carica > abtg_pepperstone.set
    (contiene gia' InpSimboli=$Simboli e InpDataInizio=$Da)
 6. OK. Guarda la scheda ESPERTI (non Giornale). I tick reali su piu'
    anni richiedono ORE: lascialo finire, non chiudere MT5.
 7. quando ha finito, torna qui e lancia:
      powershell -ExecutionPolicy Bypass -File "`$env:USERPROFILE\installa_pepperstone.ps1" -SoloReferto
-----------------------------------------------------------------------
"@ -ForegroundColor Yellow
  Mostra-Referto
  Stampa-Fase3
  exit 0
}

# ---------------------------------------------------------------------
#  modalita' AUTOMATICA (solo PC di backtest, MT5 chiuso)
# ---------------------------------------------------------------------
$running = Get-Process -Name "terminal64" -ErrorAction SilentlyContinue
if ($running) {
  Write-Host ""
  Write-Host "MT5 e' APERTO. In automatico non si puo': un secondo avvio sulla" -ForegroundColor Red
  Write-Host "stessa cartella dati non esegue lo script." -ForegroundColor Red
  Write-Host "Chiudi TUTTI i terminali e rilancia, oppure usa la modalita'" -ForegroundColor Red
  Write-Host "manuale (senza -Auto)." -ForegroundColor Red
  Write-Host "SE SEI SUL VPS: non chiudere niente, spegneresti gli EA in forward." -ForegroundColor Red
  exit 1
}

if (Test-Path $CsvOut) { Remove-Item $CsvOut -Force }   # cosi' so che il referto e' nuovo

$primoSym = $lista[0]
$Ini = Join-Path $env:TEMP "abtg_pepperstone.ini"
@"
[Charts]
MaxBars=2000000000

[StartUp]
Script=ABTG_HistoryDownloader
ScriptParameters=abtg_pepperstone.set
Symbol=$primoSym
Period=M5
"@ | Set-Content -Path $Ini -Encoding Unicode

# quanto tempo si tollera senza che il CSV cresca: coi tick un singolo
# simbolo puo' stare mezz'ora senza scrivere una riga, quindi la soglia
# di "ha finito" deve essere generosa, o si taglia un download vivo
$StalloMin = if ($SenzaTick) { 3 } else { 45 }

Write-Host ""
Write-Host ("Avvio MT5 in automatico (timeout " + $TimeoutMin + " min, stallo " + $StalloMin + " min)...") -ForegroundColor Cyan
Write-Host "Non toccare il terminale che si apre: sta lavorando." -ForegroundColor DarkGray
Start-Process -FilePath $Terminal -ArgumentList "/config:$Ini"

$ErrorActionPreference = "Continue"
$scaduto   = (Get-Date).AddMinutes($TimeoutMin)
$ultimaLen = -1
$fermoDa   = 0
$visto     = $false
$finito    = $false
$chiuso    = $false
while ((Get-Date) -lt $scaduto) {
  Start-Sleep -Seconds 30

  # se il terminale non c'e' piu' non ha senso continuare ad aspettare.
  # Si guarda il NOME del processo e non l'Id di Start-Process: MT5 in
  # certi casi si rilancia da solo e l'Id iniziale sparisce.
  $vivo = Get-Process -Name "terminal64" -ErrorAction SilentlyContinue
  if (-not $vivo) {
    Write-Host "  MT5 non e' piu' in esecuzione: leggo quello che c'e'." -ForegroundColor Yellow
    $chiuso = $true
    break
  }

  if (-not (Test-Path $CsvOut)) { continue }
  $visto = $true
  $len = 0
  try { $len = (Get-Item $CsvOut -ErrorAction Stop).Length } catch { continue }
  if ($len -eq $ultimaLen) {
    $fermoDa += 30
    if ($fermoDa -ge ($StalloMin * 60)) { $finito = $true; break }
  } else {
    $fermoDa = 0
    $ultimaLen = $len
    Write-Host ("  ... " + $len + " byte scritti  (" + (Get-Date -Format "HH:mm:ss") + ")") -ForegroundColor DarkGray
  }
}
$ErrorActionPreference = "Stop"

if (-not $visto) {
  Write-Host ""
  Write-Host "Nessun referto prodotto." -ForegroundColor Red
  Write-Host "Le cause tipiche, in ordine: 1) login non fatto, 2) nomi dei" -ForegroundColor Red
  Write-Host "simboli sbagliati (non esistono su questo broker), 3) lo script" -ForegroundColor Red
  Write-Host "non e' partito. Guarda la scheda ESPERTI di MT5, poi riprova" -ForegroundColor Red
  Write-Host "in manuale (senza -Auto)." -ForegroundColor Red
  Chiudi-MT5-Pulito
  exit 1
}
if (-not $finito -and $chiuso) {
  Write-Host ""
  Write-Host "MT5 si e' chiuso prima che il referto smettesse di crescere:" -ForegroundColor Yellow
  Write-Host "il referto qui sotto puo' essere PARZIALE (l'hai chiuso tu, o e'" -ForegroundColor Yellow
  Write-Host "andato in crash: guarda l'ultimo log raccolto sul Desktop)." -ForegroundColor Yellow
}
if (-not $finito -and -not $chiuso) {
  Write-Host ""
  Write-Host ("Timeout di " + $TimeoutMin + " minuti scaduto col download ancora vivo.") -ForegroundColor Yellow
  Write-Host "Il referto qui sotto e' PARZIALE. Rilancia con -TimeoutMin piu'" -ForegroundColor Yellow
  Write-Host "alto (i tick reali su piu' anni vogliono ore), oppure spezza il" -ForegroundColor Yellow
  Write-Host "lavoro in piu' giri da pochi simboli." -ForegroundColor Yellow
}

Write-Host ""
Write-Host "Chiudo MT5..." -ForegroundColor DarkGray
Chiudi-MT5-Pulito
Start-Sleep -Seconds 3

Mostra-Referto
Raccogli-SulDesktop
Stampa-Fase3
