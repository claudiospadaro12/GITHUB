# =====================================================================
#  MARCATORE_RIGA_MISURA_TICK_NASUSD_v1
#  RIGA_MISURA_TICK_NASUSD.ps1  --  MISURA LA PROFONDITA' DEI TICK
#                                   REALI di NASUSD su BCM
# ---------------------------------------------------------------------
#  PERCHE' ESISTE:
#  A Model 4 (Ogni tick basato su tick reali), se i tick VERI non ci
#  sono, MT5 NON si ferma: ripiega su tick "plausibili ma falsi"
#  generati dalle barre. La profondita' tick di NASUSD non e' MAI stata
#  misurata. La cassaforte FASE 2 conta la finestra 2024.09.26 -> 2026
#  come coperta da tick veri: questa riga lo VERIFICA o lo SMENTISCE.
#
#  COSA MISURA (la colonna che decide):
#   - la PRIMA DATA VERA dei tick di NASUSD e il loro CONTEGGIO;
#   - il muro delle barre M1 (PrimaDataServer): fin dove il broker le ha.
#
#  ESITO ATTESO (ipotesi, DA CONFERMARE): come U30USD (Dow, 20/08),
#  tick reali dal 2024.09.26. Se cosi', la finestra cassaforte
#  2024.09.26 -> 2026 e' coperta da tick VERI e i suoi numeri reggono.
#  SE i tick NASUSD partono DOPO, o sono pochi/assenti, la cassaforte
#  va riletta o rifatta.
#
#  ###################################################################
#  #  !!! SI LANCIA SOLO SUL PC DI BACKTEST -- MAI SUL VPS !!!       #
#  #                                                                 #
#  #  Questa riga passa -Auto a scarica_storico.ps1, che APRE e      #
#  #  CHIUDE MT5 da solo. Sul VPS chiuderebbe il terminale che       #
#  #  tiene su la FLOTTA IN FORWARD: spegneresti gli EA veri.        #
#  #  La regola e' gia' scritta in testa a scarica_storico.ps1       #
#  #  (riga ~36). Qui la ripetiamo perche' e' quella che brucia.     #
#  ###################################################################
#
#  IL PRECEDENTE ESATTO che ha funzionato (U30USD, 20/08), agli atti in
#  risultati_archivio\misura_tick\REFERTO_MISURA_TICK_U30USD.txt:
#    -Simboli U30USD -Da 2022.01.01 -Timeframes M1,M5 -TimeoutMin 240 -Auto
#  -> "TICK REALI DAL 2024.09.26, 67.618.571 tick, PARZIALI".
#  Qui si fa la STESSA identica cosa su NASUSD.
#
#  NON REINVENTA LO STRUMENTO: pilota scarica_storico.ps1, che a sua
#  volta pilota ABTG_HistoryDownloader.mq5 via CopyTicksRange. Questa
#  riga scarica ENTRAMBI DAL PIN (nel layout repo, cosi' scarica_storico
#  usa la copia locale PINNATA del .mq5 e non ne ripesca una dal branch
#  head), lancia la corsa, poi impagina il referto coi nomi attesi:
#     REFERTO_MISURA_TICK_NASUSD.txt  +  misura_tick_NASUSD.csv
#  su Desktop + zip, con l'elenco dei file attesi stampato in console.
#
#  LA GUARDIA MT5:
#  qui NON rifiutiamo un MT5 aperto -- lo gestisce scarica_storico.ps1
#  col suo -Auto (se lo trova aperto ESCE 1 e lo dice, non lo ammazza:
#  e' la rete di sicurezza che protegge il forward). Noi propaghiamo
#  quel codice di uscita.
# =====================================================================
[CmdletBinding()]
param(
  [string]$Pin        = "",            # OBBLIGATORIO sha40: senza, non parte
  [string]$Simbolo    = "NASUSD",      # il simbolo BCM da misurare
  [string]$Da         = "2022.01.01",  # come il precedente U30USD
  [string]$Timeframes = "M1,M5",       # come il precedente U30USD
  [int]   $TimeoutMin = 240            # come il precedente U30USD
)

$ErrorActionPreference = "Stop"
[Threading.Thread]::CurrentThread.CurrentCulture   = [Globalization.CultureInfo]::InvariantCulture
[Threading.Thread]::CurrentThread.CurrentUICulture = [Globalization.CultureInfo]::InvariantCulture
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$INV = [Globalization.CultureInfo]::InvariantCulture

# ---------------------------------------------------------------------
#  IL PIN. Senza default apposta: nella riga sorella un default vecchio
#  faceva girare codice di ieri senza accorgersene (lezione 10/08).
# ---------------------------------------------------------------------
if($Pin -notmatch '^[0-9a-fA-F]{40}$'){
  Write-Host ""
  Write-Host "!!! PIN MANCANTE O NON VALIDO." -ForegroundColor Red
  Write-Host "    Usa il blocco di lancio del foglio RIGA_MISURA_TICK_NASUSD_DA_MANDARE.md," -ForegroundColor Yellow
  Write-Host "    con l'hash dato in chat. Girare al pin sbagliato vuol dire girare" -ForegroundColor Yellow
  Write-Host "    codice di ieri senza saperlo." -ForegroundColor Yellow
  exit 1
}
$Pin    = $Pin.ToLower()
$Simbolo = $Simbolo.ToUpper()
$RawPin = "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$Pin"

$Avvio = Get-Date
$Stamp = $Avvio.ToString("yyyyMMdd_HHmm",$INV)
$Dsk   = [Environment]::GetFolderPath("Desktop")
if([string]::IsNullOrWhiteSpace($Dsk)){ $Dsk = Join-Path $env:USERPROFILE "Desktop" }

# --- cartella di lavoro nel LAYOUT DEL REPO, cosi' scarica_storico.ps1
#     (che cerca il .mq5 in $RepoRoot\..\mql5\Scripts) usa la copia
#     LOCALE PINNATA e non ne riscarica una dal branch head.
$Base   = Join-Path $env:USERPROFILE ("abtg_misura_tick_" + $Simbolo.ToLower())
$DirBT  = Join-Path $Base "backtest_pipeline"
$DirMQ  = Join-Path $Base "mql5\Scripts"
New-Item -ItemType Directory -Force -Path $DirBT,$DirMQ | Out-Null

# --- cartella di raccolta con nome proprio + un solo zip in fondo
$Cart    = Join-Path $Dsk ("MISURA_TICK_" + $Simbolo + "_" + $Stamp)
New-Item -ItemType Directory -Force -Path $Cart | Out-Null
$RefertoOut = Join-Path $Cart ("REFERTO_MISURA_TICK_" + $Simbolo + ".txt")
$CsvRinom   = Join-Path $Cart ("misura_tick_" + $Simbolo + ".csv")

function Ora(){ return (Get-Date).ToString("HH:mm:ss",$INV) }
function Dico($t,$c="Gray"){ Write-Host ("[" + (Ora) + "] " + $t) -ForegroundColor $c }
function Titolo($t){ Write-Host ""; Write-Host ("=== " + $t + " ===") -ForegroundColor Cyan }

# --- scarico blindato: niente copia vecchia, errore terminante, marcatore
function Scarica($url,$dest,$marcatore){
  Remove-Item -LiteralPath $dest -Force -ErrorAction SilentlyContinue
  Invoke-WebRequest -Uri $url -OutFile $dest -UseBasicParsing -ErrorAction Stop
  if(-not (Test-Path -LiteralPath $dest)){ throw ("scarico fallito: " + $url) }
  if($marcatore -ne "" -and -not (Select-String -LiteralPath $dest -SimpleMatch -Pattern $marcatore -Quiet)){
    throw ("file scaricato SENZA il marcatore atteso '" + $marcatore + "': " + $url)
  }
}

Write-Host ""
Write-Host "#####################################################################" -ForegroundColor Cyan
Write-Host ("#  MISURA PROFONDITA' TICK REALI -- " + $Simbolo + " @ BCM") -ForegroundColor Cyan
Write-Host "#####################################################################" -ForegroundColor Cyan
Write-Host "  !!! SOLO SUL PC DI BACKTEST -- MAI SUL VPS: -Auto apre/chiude MT5" -ForegroundColor Yellow
Write-Host "      e sul VPS spegnerebbe la FLOTTA IN FORWARD (EA veri)." -ForegroundColor Yellow
Dico ("pin      : " + $Pin)
Dico ("simbolo  : " + $Simbolo)
Dico ("lavoro   : " + $Base)
Dico ("raccolta : " + $Cart)

# =====================================================================
#  F1. SCARICO DAL PIN scarica_storico.ps1 + ABTG_HistoryDownloader.mq5
# =====================================================================
Titolo "F1 - strumenti dal pin (con marcatore)"
$Scar = Join-Path $DirBT "scarica_storico.ps1"
$Mq5  = Join-Path $DirMQ "ABTG_HistoryDownloader.mq5"
Scarica ("$RawPin/backtest_pipeline/scarica_storico.ps1") $Scar 'scarica lo STORICO dal broker'
Scarica ("$RawPin/mql5/Scripts/ABTG_HistoryDownloader.mq5") $Mq5 'Scarica lo STORICO dei prezzi dal broker'
Write-Host ("   scarica_storico.ps1        -> " + $Scar) -ForegroundColor Green
Write-Host ("   ABTG_HistoryDownloader.mq5 -> " + $Mq5 + "   (copia locale pinnata: scarica_storico la usera' cosi' com'e')") -ForegroundColor Green

# =====================================================================
#  F2. LA CORSA -- riga IDENTICA al precedente U30USD del 20/08
# =====================================================================
$rigaArg = ("-Simboli " + $Simbolo + " -Da " + $Da + " -Timeframes " + $Timeframes + " -TimeoutMin " + $TimeoutMin + " -Auto")
Titolo ("F2 - corsa  (" + $rigaArg + ")")
Write-Host "   scarica_storico.ps1 gestisce MT5 col suo -Auto. Se lo trova APERTO," -ForegroundColor DarkGray
Write-Host "   ESCE 1 e lo dice (non lo ammazza): e' la rete che protegge il forward." -ForegroundColor DarkGray
Write-Host "   La fase tick puo' tenere il CSV fermo per parecchio: e' NORMALE," -ForegroundColor DarkGray
Write-Host "   scarica_storico ha gia' il difetto pagato del 'CSV non cresce per ore'." -ForegroundColor DarkGray

$rcChild = 0
$oldEA = $ErrorActionPreference
$ErrorActionPreference = "Continue"
$global:LASTEXITCODE = 0
try{
  & powershell -ExecutionPolicy Bypass -File $Scar `
      -Simboli $Simbolo -Da $Da -Timeframes $Timeframes -TimeoutMin $TimeoutMin -Auto
  $rcChild = $LASTEXITCODE
}catch{
  $rcChild = 99
  Write-Host ("   eccezione lanciando scarica_storico.ps1: " + $_.Exception.Message) -ForegroundColor Red
}finally{ $ErrorActionPreference = $oldEA }
if($null -eq $rcChild){ $rcChild = 0 }
Write-Host ("   scarica_storico.ps1 uscito con codice: " + $rcChild) -ForegroundColor $(if($rcChild -eq 0){"Green"}else{"Yellow"})

# =====================================================================
#  F3. TROVA IL CSV VERO PRODOTTO DALLA CORSA
#  Primaria: la cartella dati del terminale BCM (stessa discovery di
#  scarica_storico.ps1). Riserva: la copia che scarica_storico lascia
#  su Desktop\storico_bcm\ABTG_StoricoScaricato.csv.
#  In tutti i casi si accetta solo un file SCRITTO DOPO l'avvio di
#  questa riga: un CSV di IERI non e' la misura di oggi (difetto gia'
#  pagato in scarica_storico: il '=== FINITO' di ieri preso per oggi).
# =====================================================================
Titolo "F3 - trova il CSV prodotto"
function TrovaCsvDati(){
  $allTerm = Get-ChildItem "C:\Program Files","C:\Program Files (x86)" -Recurse -Filter "terminal64.exe" -ErrorAction SilentlyContinue
  $cand = $allTerm | Where-Object { $_.DirectoryName -like "*BCM Markets MT5 Terminal*" -and $_.DirectoryName -notlike "*-V3*" } | Select-Object -First 1
  if(-not $cand){ $cand = $allTerm | Where-Object { $_.DirectoryName -like "*BCM Markets*" } | Select-Object -First 1 }
  if(-not $cand){ return $null }
  $instDir = $cand.DirectoryName
  $termRoot = Join-Path $env:APPDATA "MetaQuotes\Terminal"
  $df = Get-ChildItem $termRoot -Directory -ErrorAction SilentlyContinue | Where-Object {
    $o = Join-Path $_.FullName "origin.txt"
    (Test-Path $o) -and ((Get-Content $o -Raw).Trim() -ieq $instDir)
  } | Select-Object -First 1 -ExpandProperty FullName
  if(-not $df){ return $null }
  return (Join-Path $df "MQL5\Files\ABTG_StoricoScaricato.csv")
}

$csvFonte = $null
$candidati = @()
$c1 = TrovaCsvDati
if($c1){ $candidati += $c1 }
$candidati += (Join-Path $Dsk "storico_bcm\ABTG_StoricoScaricato.csv")
foreach($c in $candidati){
  if($c -and (Test-Path -LiteralPath $c)){
    $lw = (Get-Item -LiteralPath $c).LastWriteTime
    if($lw -ge $Avvio.AddMinutes(-1)){
      $csvFonte = $c
      Write-Host ("   CSV trovato (fresco): " + $c) -ForegroundColor Green
      break
    } else {
      Write-Host ("   scartato (vecchio, LastWrite " + $lw.ToString("yyyy-MM-dd HH:mm",$INV) + "): " + $c) -ForegroundColor DarkYellow
    }
  }
}

# =====================================================================
#  F4. IMPAGINA IL REFERTO coi nomi attesi (formato del precedente U30USD)
# =====================================================================
Titolo "F4 - referto"
$righeCsv = @()
$noteReferto = ""
if($csvFonte){
  try{
    Copy-Item -LiteralPath $csvFonte -Destination $CsvRinom -Force
    $tutte = Import-Csv -LiteralPath $CsvRinom
    $righeCsv = @($tutte | Where-Object { $_.Simbolo -eq $Simbolo })
    if($righeCsv.Count -eq 0){
      $noteReferto = "IL CSV ESISTE MA NON HA NESSUNA RIGA " + $Simbolo + " (misura non prodotta per questo simbolo)."
    }
  }catch{
    $noteReferto = "CSV trovato ma NON leggibile: " + $_.Exception.Message
  }
} else {
  $noteReferto = "NESSUN CSV FRESCO TROVATO: la corsa non ha prodotto un referto scritto dopo l'avvio (rc=" + $rcChild + ")."
}

$tickRow = @($righeCsv | Where-Object { $_.Timeframe -eq "TICK" }) | Select-Object -First 1
$m1Row   = @($righeCsv | Where-Object { $_.Timeframe -eq "M1" })   | Select-Object -First 1

$L = New-Object System.Collections.ArrayList
[void]$L.Add("MISURA DELLA PROFONDITA' DEI TICK REALI -- " + $Simbolo + " @ BCM")
[void]$L.Add("data: " + (Get-Date).ToString("yyyy-MM-dd HH:mm:ss",$INV) + "   (corsa partita alle " + $Avvio.ToString("yyyy-MM-dd HH:mm:ss",$INV) + ")")
[void]$L.Add("script: scarica_storico.ps1 pinnato a " + $Pin)
[void]$L.Add("riga: " + $rigaArg)
[void]$L.Add("codice di uscita (scarica_storico.ps1): " + $rcChild)
[void]$L.Add("")

if($tickRow){
  [void]$L.Add("I TICK REALI DI " + $Simbolo + " PARTONO DAL " + $tickRow.PrimaDataLocale +
               "   (" + $tickRow.Barre + " tick, verdetto: " + $tickRow.Verdetto + ")")
} else {
  [void]$L.Add("TICK REALI: NESSUNA RIGA TICK NEL CSV -- i tick NON sono stati misurati")
  [void]$L.Add("            (download interrotto, -SenzaTick, o simbolo assente).")
}
if($m1Row){
  [void]$L.Add("MURO DELLE BARRE M1, colonna PrimaDataServer: " + $m1Row.PrimaDataServer)
} else {
  [void]$L.Add("MURO DELLE BARRE M1: nessuna riga M1 nel CSV.")
}
[void]$L.Add("")
foreach($r in $righeCsv){
  [void]$L.Add(($r.Simbolo + " " + $r.Timeframe + " barre=" + $r.Barre +
               " locale=" + $r.PrimaDataLocale + " server=" + $r.PrimaDataServer +
               " -> " + $r.Verdetto))
}
if($noteReferto -ne ""){
  [void]$L.Add("")
  [void]$L.Add("NOTA: " + $noteReferto)
}
[void]$L.Add("")
[void]$L.Add("COME SI LEGGE:")
[void]$L.Add(" - la colonna che DECIDE e' la prima data VERA dei tick + il conteggio.")
[void]$L.Add(" - se i tick partono dal 2024.09.26 (come U30USD): la finestra cassaforte")
[void]$L.Add("   FASE 2 2024.09.26 -> 2026 e' coperta da tick VERI, i suoi numeri reggono.")
[void]$L.Add(" - se partono DOPO, o sono pochi/assenti: a Model 4 MT5 ha usato tick")
[void]$L.Add("   FINTI e la cassaforte va RILETTA o RIFATTA.")

Set-Content -LiteralPath $RefertoOut -Value $L -Encoding ASCII
Get-Content -LiteralPath $RefertoOut | ForEach-Object { Write-Host $_ }

# =====================================================================
#  F5. RACCOLTA su Desktop + zip, con elenco dei file attesi in console
# =====================================================================
Titolo "F5 - raccolta + zip"
# porta anche gli ultimi log di MT5 se scarica_storico li ha raccolti
$srcLog = Join-Path $Dsk "storico_bcm"
if(Test-Path -LiteralPath $srcLog){
  Get-ChildItem -LiteralPath $srcLog -Filter "*.log" -ErrorAction SilentlyContinue |
    Sort-Object LastWriteTime -Descending | Select-Object -First 2 |
    ForEach-Object { Copy-Item -LiteralPath $_.FullName -Destination $Cart -Force -ErrorAction SilentlyContinue }
}
$Zip = Join-Path $Dsk ("MISURA_TICK_" + $Simbolo + "_" + $Stamp + ".zip")
try{ Compress-Archive -Path (Join-Path $Cart "*") -DestinationPath $Zip -Force }catch{ }

Write-Host ""
Write-Host ("RACCOLTA: " + $Cart) -ForegroundColor Green
Write-Host ("ZIP PRONTO DA MANDARE: " + $Zip) -ForegroundColor Green
Write-Host "Verifica che dentro ci siano:" -ForegroundColor DarkGray
Write-Host ("   - REFERTO_MISURA_TICK_" + $Simbolo + ".txt") -ForegroundColor DarkGray
Write-Host ("   - misura_tick_" + $Simbolo + ".csv") -ForegroundColor DarkGray
Write-Host "   - gli ultimi log di MT5 (*.log), se prodotti" -ForegroundColor DarkGray

# =====================================================================
#  CODICE DI USCITA (checklist 19.2: un parziale NON esce 0)
#   0  -> misura completa: c'e' una riga TICK e la corsa e' finita bene
#   2  -> PARZIALE: manca la riga TICK, o scarica_storico e' uscito != 0
#   1  -> gia' uscito prima su pin/scarico
# =====================================================================
if($tickRow -and $rcChild -eq 0){
  Write-Host ""
  Write-Host "MISURA COMPLETA: riga TICK presente e corsa terminata bene." -ForegroundColor Green
  exit 0
}
Write-Host ""
Write-Host "ATTENZIONE: MISURA PARZIALE." -ForegroundColor Red
if(-not $tickRow){ Write-Host "  manca la riga TICK nel CSV." -ForegroundColor Red }
if($rcChild -ne 0){ Write-Host ("  scarica_storico.ps1 e' uscito con " + $rcChild + " (2 = timeout/parziale).") -ForegroundColor Red }
Write-Host "  Il referto e lo zip ci sono lo stesso: chi legge decide." -ForegroundColor Yellow
exit 2
