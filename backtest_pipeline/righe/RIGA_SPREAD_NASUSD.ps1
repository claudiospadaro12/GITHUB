# =====================================================================
#  MARCATORE_RIGA_SPREAD_NASUSD_v1
#  RIGA_SPREAD_NASUSD.ps1  --  MISURA LO SPREAD REALE di NASUSD dai
#                              TICK STORICI gia' sul disco (166M tick)
# ---------------------------------------------------------------------
#  PERCHE' ESISTE (la domanda che decide):
#  la cassaforte FASE 2 (long PF 1.083) e' un edge SOTTILE: se i costi
#  se lo mangiano, non e' un edge. La corsa cassaforte girava con
#  Spread=0 nell'ini a Model 4 (Ogni tick su tick reali). Ma Model 4
#  usa lo spread VERO solo se i tick portano BID **E** ASK. Se i tick
#  NASUSD sono SOLO-BID, allora Spread=0 = spread ZERO = il PF 1.083
#  e' OTTIMISTA. Questa riga lo VERIFICA o lo SMENTISCE, misurando:
#   1. LA RIGA CHE DECIDE: % tick con ask valido vs % solo-bid.
#   2. distribuzione spread (seduta 14:30-21:00 ora server): mediana,
#      P90, P95, max in PUNTI INDICE.
#
#  ###################################################################
#  #  !!! SI LANCIA SOLO SUL PC DI BACKTEST -- MAI SUL VPS !!!       #
#  #                                                                 #
#  #  Questa riga APRE e CHIUDE MT5 da sola (StartUp Script via      #
#  #  .ini). Sul VPS chiuderebbe il terminale che tiene su la        #
#  #  FLOTTA IN FORWARD: spegneresti gli EA veri. Se trova MT5       #
#  #  gia' APERTO, ESCE 1 e lo dice (non lo ammazza), a meno di      #
#  #  -ChiudiMT5 esplicito. E' la rete che protegge il forward.      #
#  ###################################################################
#
#  NON REINVENTA LO STRUMENTO: usa lo stesso pattern SICURO di
#  scarica_storico.ps1 (trova il terminale BCM, compila col
#  metaeditor, lancia via .ini con AllowLiveTrading=false, attende
#  la riga di chiusura, raccoglie su Desktop + zip). Il MOTORE di
#  misura e' il nuovo Script MQL5 ABTG_SpreadTick.mq5, scaricato
#  DAL PIN e verificato col marcatore (niente copie vecchie).
#
#  NON committa, NON tocca il forward, NON promuove niente.
# =====================================================================
[CmdletBinding()]
param(
  [string]$Pin            = "",              # OBBLIGATORIO sha40: senza, non parte
  [string]$Simbolo        = "NASUSD",        # simbolo BCM da misurare
  [string]$Da             = "2024.09.26",    # inizio finestra (tick reali dal 2024.09.26)
  [string]$A              = "2026.06.30",    # fine finestra
  [int]   $SessInizioMin  = 870,             # seduta: minuti da mezzanotte, ORA SERVER (14:30)
  [int]   $SessFineMin    = 1260,            # seduta: minuti da mezzanotte, ORA SERVER (21:00)
  [double]$PuntiPerIndice = 100.0,           # R97: 1 pto indice = 100 pti MT5 su NASUSD
  [int]   $GiorniBlocco   = 7,               # lettura tick a blocchi di N giorni
  [int]   $TimeoutMin     = 180,             # tetto: 166M tick sono tanti
  [switch]$ChiudiMT5                         # ammazza un MT5 aperto (MAI sul VPS)
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
  Write-Host "    Usa il blocco di lancio del foglio RIGA_SPREAD_NASUSD_DA_MANDARE.md," -ForegroundColor Yellow
  Write-Host "    con l'hash dato in chat. Girare al pin sbagliato vuol dire girare" -ForegroundColor Yellow
  Write-Host "    codice di ieri senza saperlo." -ForegroundColor Yellow
  exit 1
}
$Pin     = $Pin.ToLower()
$Simbolo = $Simbolo.ToUpper()
$RawPin  = "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$Pin"

$Avvio = Get-Date
$Stamp = $Avvio.ToString("yyyyMMdd_HHmm",$INV)
$Dsk   = [Environment]::GetFolderPath("Desktop")
if([string]::IsNullOrWhiteSpace($Dsk)){ $Dsk = Join-Path $env:USERPROFILE "Desktop" }

$Work = Join-Path $env:USERPROFILE ("abtg_spread_" + $Simbolo.ToLower())
New-Item -ItemType Directory -Force -Path $Work | Out-Null

# --- cartella di raccolta con nome proprio + un solo zip in fondo
$Cart       = Join-Path $Dsk ("SPREAD_" + $Simbolo + "_" + $Stamp)
New-Item -ItemType Directory -Force -Path $Cart | Out-Null
$RefertoOut = Join-Path $Cart ("REFERTO_SPREAD_" + $Simbolo + ".txt")
$CsvRinom   = Join-Path $Cart ("spread_tick_" + $Simbolo + ".csv")

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
Write-Host ("#  MISURA SPREAD REALE DAI TICK -- " + $Simbolo + " @ BCM") -ForegroundColor Cyan
Write-Host "#####################################################################" -ForegroundColor Cyan
Write-Host "  !!! SOLO SUL PC DI BACKTEST -- MAI SUL VPS: apre/chiude MT5 e sul" -ForegroundColor Yellow
Write-Host "      VPS spegnerebbe la FLOTTA IN FORWARD (EA veri)." -ForegroundColor Yellow
Dico ("pin      : " + $Pin)
Dico ("simbolo  : " + $Simbolo)
Dico ("finestra : " + $Da + " -> " + $A)
Dico ("raccolta : " + $Cart)

# =====================================================================
#  F1. TROVA IL TERMINALE BCM + CARTELLA DATI (stessa discovery di
#      scarica_storico.ps1: e' quella collaudata)
# =====================================================================
Titolo "F1 - terminale BCM + cartella dati"
$allTerm = Get-ChildItem "C:\Program Files","C:\Program Files (x86)" -Recurse -Filter "terminal64.exe" -ErrorAction SilentlyContinue
$cand = $allTerm | Where-Object { $_.DirectoryName -like "*BCM Markets MT5 Terminal*" -and $_.DirectoryName -notlike "*-V3*" } | Select-Object -First 1
if(-not $cand){ $cand = $allTerm | Where-Object { $_.DirectoryName -like "*BCM Markets*" } | Select-Object -First 1 }
if(-not $cand){ Write-Host "Terminale BCM non trovato." -ForegroundColor Red; exit 1 }
$instDir    = $cand.DirectoryName
$Terminal   = Join-Path $instDir "terminal64.exe"
$MetaEditor = Join-Path $instDir "metaeditor64.exe"
$termRoot   = Join-Path $env:APPDATA "MetaQuotes\Terminal"
$DataFolder = Get-ChildItem $termRoot -Directory -ErrorAction SilentlyContinue | Where-Object {
    $o = Join-Path $_.FullName "origin.txt"
    (Test-Path $o) -and ((Get-Content $o -Raw).Trim() -ieq $instDir)
} | Select-Object -First 1 -ExpandProperty FullName
if(-not $DataFolder){ Write-Host "Cartella dati MT5 non trovata." -ForegroundColor Red; exit 1 }
Write-Host ("   terminale : " + $instDir) -ForegroundColor Green
Write-Host ("   dati      : " + $DataFolder) -ForegroundColor Green

$FilesDir = Join-Path $DataFolder "MQL5\Files"
$CsvOut   = Join-Path $FilesDir "spread_tick_$Simbolo.csv"
$TxtOut   = Join-Path $FilesDir "REFERTO_SPREAD_$Simbolo.txt"

# =====================================================================
#  F2. SCARICA IL MOTORE DAL PIN + COMPILA
# =====================================================================
Titolo "F2 - ABTG_SpreadTick.mq5 dal pin (con marcatore) + compilazione"
$DstDir = Join-Path $DataFolder "MQL5\Scripts"
New-Item -ItemType Directory -Force -Path $DstDir | Out-Null
$Mq5 = Join-Path $DstDir "ABTG_SpreadTick.mq5"
Scarica ("$RawPin/mql5/Scripts/ABTG_SpreadTick.mq5") $Mq5 'MISURA LO SPREAD REALE dai TICK STORICI'
Write-Host ("   sorgente pinnato -> " + $Mq5) -ForegroundColor Green
& $MetaEditor "/compile:$Mq5" "/log" | Out-Null
$Ex5 = [System.IO.Path]::ChangeExtension($Mq5, ".ex5")
if(-not (Test-Path $Ex5)){ Write-Host "ERRORE di compilazione (nessun .ex5)." -ForegroundColor Red; exit 1 }
Write-Host "   compilato: ABTG_SpreadTick.ex5" -ForegroundColor Green

# =====================================================================
#  F3. PRESET CON I PARAMETRI
# =====================================================================
Titolo "F3 - preset"
$PresetDir = Join-Path $DataFolder "MQL5\Presets"
New-Item -ItemType Directory -Force -Path $PresetDir | Out-Null
$SetFile = Join-Path $PresetDir "abtg_spread.set"
$puntiPI = $PuntiPerIndice.ToString($INV)
@"
InpSimbolo=$Simbolo
InpDataInizio=$Da
InpDataFine=$A
InpSessInizioMin=$SessInizioMin
InpSessFineMin=$SessFineMin
InpPuntiPerIndice=$puntiPI
InpGiorniBlocco=$GiorniBlocco
InpFileCsv=spread_tick_$Simbolo.csv
InpFileTxt=REFERTO_SPREAD_$Simbolo.txt
"@ | Set-Content -Path $SetFile -Encoding ASCII
Write-Host ("   preset: " + $SetFile) -ForegroundColor Green

# =====================================================================
#  F4. GUARDIA MT5: chiuso = si procede; aperto = si rifiuta (protegge
#      il forward), a meno di -ChiudiMT5 esplicito.
# =====================================================================
Titolo "F4 - guardia MT5"
$running = Get-Process -Name "terminal64" -ErrorAction SilentlyContinue
if($running -and $ChiudiMT5){
  Write-Host "   MT5 e' aperto: lo chiudo (-ChiudiMT5)." -ForegroundColor Yellow
  $running | Stop-Process -Force -ErrorAction SilentlyContinue
  Start-Sleep -Seconds 5
  $running = Get-Process -Name "terminal64" -ErrorAction SilentlyContinue
}
if($running){
  Write-Host ""
  Write-Host "   MT5 e' APERTO. In automatico non si puo': un secondo avvio sulla" -ForegroundColor Red
  Write-Host "   stessa cartella dati non esegue lo script." -ForegroundColor Red
  Write-Host "   Aggiungi -ChiudiMT5 per farlo chiudere da solo (MAI SUL VPS: li'" -ForegroundColor Red
  Write-Host "   spegneresti la FLOTTA IN FORWARD)." -ForegroundColor Red
  exit 1
}

# cancella gli output vecchi: cosi' so che il referto e' NUOVO
Remove-Item -LiteralPath $CsvOut -Force -ErrorAction SilentlyContinue
Remove-Item -LiteralPath $TxtOut -Force -ErrorAction SilentlyContinue

# =====================================================================
#  F5. LANCIA MT5 CHE ESEGUE LO SCRIPT (StartUp), poi ATTENDI
# ---------------------------------------------------------------------
#  AllowLiveTrading=false NON e' cosmetica: /config apre IL TERMINALE
#  (non un tester), che ricarica l'ultimo profilo con gli EA su grafico.
#  Sul PC di backtest quel terminale e' sul conto VIVO 50503392: senza
#  questa riga si RIARMANO gli EA veri. Lezione del 14/08. Lo Script di
#  misura non passa dal permesso di trading: gli basta leggere i tick.
# =====================================================================
Titolo ("F5 - corsa (timeout " + $TimeoutMin + " min)")
$Ini = Join-Path $env:TEMP "abtg_spread.ini"
@"
[Experts]
AllowLiveTrading=false
AllowDllImport=false

[Charts]
MaxBars=2000000000

[StartUp]
Script=ABTG_SpreadTick
ScriptParameters=abtg_spread.set
Symbol=$Simbolo
Period=M5
"@ | Set-Content -Path $Ini -Encoding Unicode

# fotografia dei log PRIMA di partire: dopo si legge solo il NUOVO
$logDirW  = Join-Path $DataFolder "MQL5\Logs"
$lenPrima = @{}
if(Test-Path $logDirW){
  foreach($f in (Get-ChildItem $logDirW -Filter "*.log" -ErrorAction SilentlyContinue)){
    $lenPrima[$f.FullName] = $f.Length
  }
}
function Coda-Log {
  # legge SOLO cio' che i log hanno scritto DOPO la fotografia $lenPrima
  # (difetto pagato in scarica_storico: il '=== FINITO' di ieri preso
  #  per oggi -> file non cresciuto = niente da leggere, si salta).
  if(-not (Test-Path $logDirW)){ return "" }
  $tutto = ""
  foreach($f in (Get-ChildItem $logDirW -Filter "*.log" -ErrorAction SilentlyContinue)){
    $da = 0
    if($lenPrima.ContainsKey($f.FullName)){ $da = [int64]$lenPrima[$f.FullName] }
    if($da % 2 -ne 0){ $da = $da - 1 }
    try{
      $fs = New-Object System.IO.FileStream($f.FullName, [System.IO.FileMode]::Open, [System.IO.FileAccess]::Read, [System.IO.FileShare]::ReadWrite)
      if($da -ge $fs.Length){ $fs.Close(); continue }
      if($da -gt 0){ [void]$fs.Seek($da, [System.IO.SeekOrigin]::Begin) }
      $sr = New-Object System.IO.StreamReader($fs, [System.Text.Encoding]::Unicode, $false)
      $tutto = $tutto + $sr.ReadToEnd(); $sr.Close(); $fs.Close()
    }catch{ }
  }
  return $tutto
}

Write-Host "   avvio MT5..." -ForegroundColor Cyan
Start-Process -FilePath $Terminal -ArgumentList "/config:$Ini"

$scaduto  = (Get-Date).AddMinutes($TimeoutMin)
$finito   = $false
$visto    = $false
$ErrPref0 = $ErrorActionPreference
$ErrorActionPreference = "Continue"
while((Get-Date) -lt $scaduto){
  Start-Sleep -Seconds 15
  $coda = Coda-Log
  if($coda -match "ABTG_SpreadTick"){ $visto = $true }
  if($coda -match "SPREAD FINITO"){
    Write-Host "   lo script ha stampato la sua riga di chiusura: ha finito." -ForegroundColor Green
    $finito = $true; $visto = $true; break
  }
  # rete: il referto txt scritto DOPO l'avvio = fatto anche se il log sfugge
  if(Test-Path -LiteralPath $TxtOut){
    $lw = (Get-Item -LiteralPath $TxtOut).LastWriteTime
    if($lw -ge $Avvio){
      Write-Host "   referto txt fresco trovato: ha finito." -ForegroundColor Green
      $finito = $true; $visto = $true; break
    }
  }
  $csvLen = 0
  if(Test-Path -LiteralPath $CsvOut){ try{ $csvLen = (Get-Item -LiteralPath $CsvOut).Length }catch{ $csvLen = 0 } }
  Write-Host ("   ... in corso (lettura tick), CSV " + $csvLen + " byte") -ForegroundColor DarkGray
}
$ErrorActionPreference = $ErrPref0

Write-Host "   chiudo MT5..." -ForegroundColor DarkGray
Get-Process -Name "terminal64" -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
Start-Sleep -Seconds 3

# =====================================================================
#  F6. RACCOLTA su Desktop + zip, con elenco dei file attesi in console
# =====================================================================
Titolo "F6 - raccolta + zip"
$haCsv = $false; $haTxt = $false
if((Test-Path -LiteralPath $CsvOut) -and ((Get-Item -LiteralPath $CsvOut).LastWriteTime -ge $Avvio)){
  Copy-Item -LiteralPath $CsvOut -Destination $CsvRinom -Force -ErrorAction SilentlyContinue
  $haCsv = $true
}
if((Test-Path -LiteralPath $TxtOut) -and ((Get-Item -LiteralPath $TxtOut).LastWriteTime -ge $Avvio)){
  Copy-Item -LiteralPath $TxtOut -Destination $RefertoOut -Force -ErrorAction SilentlyContinue
  $haTxt = $true
}
# porta anche gli ultimi log di MT5
if(Test-Path $logDirW){
  Get-ChildItem -LiteralPath $logDirW -Filter "*.log" -ErrorAction SilentlyContinue |
    Sort-Object LastWriteTime -Descending | Select-Object -First 2 |
    ForEach-Object { Copy-Item -LiteralPath $_.FullName -Destination $Cart -Force -ErrorAction SilentlyContinue }
}

# stampa a schermo il referto se c'e'
if($haTxt){
  Write-Host ""
  Get-Content -LiteralPath $RefertoOut | ForEach-Object { Write-Host $_ }
}

$Zip = Join-Path $Dsk ("SPREAD_" + $Simbolo + "_" + $Stamp + ".zip")
try{ Compress-Archive -Path (Join-Path $Cart "*") -DestinationPath $Zip -Force }catch{ }

Write-Host ""
Write-Host ("RACCOLTA: " + $Cart) -ForegroundColor Green
Write-Host ("ZIP PRONTO DA MANDARE: " + $Zip) -ForegroundColor Green
Write-Host "Verifica che dentro ci siano:" -ForegroundColor DarkGray
Write-Host ("   - REFERTO_SPREAD_" + $Simbolo + ".txt   (la riga BID/ASK e' quella che decide)") -ForegroundColor DarkGray
Write-Host ("   - spread_tick_" + $Simbolo + ".csv") -ForegroundColor DarkGray
Write-Host "   - gli ultimi log di MT5 (*.log), se prodotti" -ForegroundColor DarkGray

# =====================================================================
#  CODICE DI USCITA (un parziale NON esce 0)
#   0 -> misura completa: referto txt + CSV freschi, corsa finita bene
#   2 -> PARZIALE: manca un output fresco, o e' scaduto il timeout
#   1 -> gia' uscito prima (pin/terminale/compilazione/MT5 aperto)
# =====================================================================
if($finito -and $haTxt -and $haCsv){
  Write-Host ""
  Write-Host "MISURA COMPLETA: referto e CSV freschi, corsa terminata bene." -ForegroundColor Green
  exit 0
}
Write-Host ""
Write-Host "ATTENZIONE: MISURA PARZIALE." -ForegroundColor Red
if(-not $finito){ Write-Host "  la riga di chiusura 'SPREAD FINITO' non e' arrivata (timeout?)." -ForegroundColor Red }
if(-not $haTxt){ Write-Host "  manca il referto txt fresco." -ForegroundColor Red }
if(-not $haCsv){ Write-Host "  manca il CSV fresco." -ForegroundColor Red }
Write-Host "  Il referto e lo zip ci sono lo stesso (se prodotti): chi legge decide." -ForegroundColor Yellow
exit 2
