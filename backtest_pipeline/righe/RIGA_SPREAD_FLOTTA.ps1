# =====================================================================
#  MARCATORE_RIGA_SPREAD_FLOTTA_v2
#  RIGA_SPREAD_FLOTTA.ps1  --  SPREAD REALE PER FASCIA ORARIA sui tre
#                              indici della flotta (NASUSD, U30USD,
#                              D30EUR), dai TICK STORICI gia' sul disco
# ---------------------------------------------------------------------
#  PERCHE' ESISTE (direzione di Claudio, 31/08 sera):
#  "dobbiamo usare simboli col minimo attrito". La risposta di casa e'
#  MISURARE lo spread reale su BCM, simbolo per simbolo, ORA per ORA:
#  oggi tutti i prova usano "spread 2.0 [NON MISURATO]". Questa riga
#  mette finalmente in campo il logger promosso il 23/08 (mai lanciato)
#  e lo ESTENDE: v2 = multi-simbolo + tabella oraria (media/mediana/
#  P95/max per ora del giorno SERVER, in punti indice).
#
#  DOVE GIRA, E PERCHE' (scelta del design 23/08, confermata):
#  lo spread NON si raccoglie live: si legge dai TICK STORICI gia'
#  scaricati (CopyTicksRange). Quindi niente VPS, niente mercato
#  aperto, niente giorni di attesa: il "periodo di raccolta" e' la
#  finestra storica dichiarata (default 2024.09.26 -> 2026.06.30,
#  ~21 mesi di tick reali). Serve solo il PC DI BACKTEST con MT5
#  aperto SOLO per la misura (lo apre e lo chiude la riga stessa).
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
#  MOTORE: mql5/Scripts/ABTG_SpreadOrario.mq5 (SPREAD ORARIO
#  MULTI-SIMBOLO v2), scaricato DAL PIN e verificato col marcatore.
#  Un solo Script, un solo grafico: cicla i simboli via SymbolSelect
#  + CopyTicksRange (niente grafici multipli = niente profili da
#  coordinare: e' la via robusta, dichiarata).
#
#  RIPRENDIBILE (pattern DUKA):
#   - il referto REFERTO_SPREAD_FLOTTA.txt viene scritto e flushato
#     SIMBOLO PER SIMBOLO: e' leggibile in ogni momento, anche a
#     meta' corsa;
#   - ogni simbolo scrive il SUO CSV appena finisce;
#   - se la corsa muore a meta', si RILANCIA la stessa riga passando
#     -Simboli con i soli mancanti (la riga li stampa in fondo).
#
#  NON committa, NON tocca il forward, NON promuove niente.
# =====================================================================
[CmdletBinding()]
param(
  [string]$Pin            = "",              # OBBLIGATORIO sha40: senza, non parte
  [string]$Simboli        = "NASUSD,U30USD,D30EUR",  # lista BCM separata da virgole
  [string]$Da             = "2024.09.26",    # inizio finestra (tick reali dal 2024.09.26)
  [string]$A              = "2026.06.30",    # fine finestra
  [double]$PuntiPerIndice = 100.0,           # 1 pto indice = 100 pti MT5 (misurata su tutti e 3)
  [int]   $GiorniBlocco   = 7,               # lettura tick a blocchi di N giorni
  [int]   $TimeoutMin     = 420,             # tetto: 3 simboli x ~150M tick l'uno possibile
  [switch]$ChiudiMT5                         # ammazza un MT5 aperto (MAI sul VPS)
)

$ErrorActionPreference = "Stop"
[Threading.Thread]::CurrentThread.CurrentCulture   = [Globalization.CultureInfo]::InvariantCulture
[Threading.Thread]::CurrentThread.CurrentUICulture = [Globalization.CultureInfo]::InvariantCulture
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$INV = [Globalization.CultureInfo]::InvariantCulture

# ---------------------------------------------------------------------
#  IL PIN. Senza default apposta: un default vecchio fa girare codice
#  di ieri senza accorgersene (lezione 10/08).
# ---------------------------------------------------------------------
if($Pin -notmatch '^[0-9a-fA-F]{40}$'){
  Write-Host ""
  Write-Host "!!! PIN MANCANTE O NON VALIDO." -ForegroundColor Red
  Write-Host "    Usa il blocco di lancio del foglio RIGA_SPREAD_FLOTTA_DA_MANDARE.md," -ForegroundColor Yellow
  Write-Host "    con l'hash dato in chat. Girare al pin sbagliato vuol dire girare" -ForegroundColor Yellow
  Write-Host "    codice di ieri senza saperlo." -ForegroundColor Yellow
  exit 1
}
$Pin    = $Pin.ToLower()
$RawPin = "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$Pin"

# --- lista simboli pulita ---
$ListaSim = @()
foreach($s in ($Simboli -split ',')){
  $t = $s.Trim().ToUpper()
  if($t -ne ""){ $ListaSim += $t }
}
if($ListaSim.Count -eq 0){
  Write-Host "!!! -Simboli vuoto: niente da misurare." -ForegroundColor Red
  exit 1
}
$SimboliCsv = ($ListaSim -join ",")

$Avvio = Get-Date
$Stamp = $Avvio.ToString("yyyyMMdd_HHmm",$INV)
$Dsk   = [Environment]::GetFolderPath("Desktop")
if([string]::IsNullOrWhiteSpace($Dsk)){ $Dsk = Join-Path $env:USERPROFILE "Desktop" }

# --- cartella di raccolta con nome proprio + un solo zip in fondo
$Cart = Join-Path $Dsk ("SPREAD_FLOTTA_" + $Stamp)
New-Item -ItemType Directory -Force -Path $Cart | Out-Null
$RefertoRiga = Join-Path $Cart "RIGA_REFERTO_SPREAD_FLOTTA.txt"

function Ora(){ return (Get-Date).ToString("HH:mm:ss",$INV) }
function Dico($t,$c="Gray"){ Write-Host ("[" + (Ora) + "] " + $t) -ForegroundColor $c }
function Titolo($t){ Write-Host ""; Write-Host ("=== " + $t + " ===") -ForegroundColor Cyan }

# --- scarico blindato: Remove-Item prima, errore terminante, marcatore
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
Write-Host ("#  SPREAD ORARIO FLOTTA -- " + $SimboliCsv + " @ BCM (v2)") -ForegroundColor Cyan
Write-Host "#####################################################################" -ForegroundColor Cyan
Write-Host "  !!! SOLO SUL PC DI BACKTEST -- MAI SUL VPS: apre/chiude MT5 e sul" -ForegroundColor Yellow
Write-Host "      VPS spegnerebbe la FLOTTA IN FORWARD (EA veri)." -ForegroundColor Yellow
Dico ("pin      : " + $Pin)
Dico ("simboli  : " + $SimboliCsv)
Dico ("finestra : " + $Da + " -> " + $A + " (tick storici su disco)")
Dico ("raccolta : " + $Cart)

# =====================================================================
#  F1. TROVA IL TERMINALE BCM + CARTELLA DATI (stessa discovery
#      collaudata di scarica_storico.ps1 / RIGA_SPREAD_NASUSD)
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
$TxtOut   = Join-Path $FilesDir "REFERTO_SPREAD_FLOTTA.txt"

# =====================================================================
#  F2. SCARICA IL MOTORE DAL PIN + COMPILA
# =====================================================================
Titolo "F2 - ABTG_SpreadOrario.mq5 dal pin (con marcatore) + compilazione"
$DstDir = Join-Path $DataFolder "MQL5\Scripts"
New-Item -ItemType Directory -Force -Path $DstDir | Out-Null
$Mq5 = Join-Path $DstDir "ABTG_SpreadOrario.mq5"
Scarica ($RawPin + "/mql5/Scripts/ABTG_SpreadOrario.mq5") $Mq5 'SPREAD ORARIO MULTI-SIMBOLO v2'
Write-Host ("   sorgente pinnato -> " + $Mq5) -ForegroundColor Green
& $MetaEditor "/compile:$Mq5" "/log" | Out-Null
$Ex5 = [System.IO.Path]::ChangeExtension($Mq5, ".ex5")
if(-not (Test-Path $Ex5)){ Write-Host "ERRORE di compilazione (nessun .ex5)." -ForegroundColor Red; exit 1 }
Write-Host "   compilato: ABTG_SpreadOrario.ex5" -ForegroundColor Green

# =====================================================================
#  F3. PRESET CON I PARAMETRI
# =====================================================================
Titolo "F3 - preset"
$PresetDir = Join-Path $DataFolder "MQL5\Presets"
New-Item -ItemType Directory -Force -Path $PresetDir | Out-Null
$SetFile = Join-Path $PresetDir "abtg_spread_flotta.set"
$puntiPI = $PuntiPerIndice.ToString($INV)
@"
InpSimboli=$SimboliCsv
InpDataInizio=$Da
InpDataFine=$A
InpPuntiPerIndice=$puntiPI
InpGiorniBlocco=$GiorniBlocco
InpPrefissoCsv=spread_orario_
InpFileTxt=REFERTO_SPREAD_FLOTTA.txt
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

# cancella gli output vecchi DEI SIMBOLI RICHIESTI: cosi' un file
# trovato dopo e' NUOVO di sicuro (gate onesto sulla freschezza)
Remove-Item -LiteralPath $TxtOut -Force -ErrorAction SilentlyContinue
foreach($s in $ListaSim){
  $c = Join-Path $FilesDir ("spread_orario_" + $s + ".csv")
  Remove-Item -LiteralPath $c -Force -ErrorAction SilentlyContinue
}

# =====================================================================
#  F5. LANCIA MT5 CHE ESEGUE LO SCRIPT (StartUp), poi ATTENDI
# ---------------------------------------------------------------------
#  AllowLiveTrading=false NON e' cosmetica: /config apre IL TERMINALE
#  (non un tester), che ricarica l'ultimo profilo con gli EA su
#  grafico. Sul PC di backtest quel terminale e' sul conto VIVO
#  50503392: senza questa riga si RIARMANO gli EA veri. Lezione del
#  14/08. Lo Script di misura non apre ordini: legge tick e conta.
# =====================================================================
Titolo ("F5 - corsa (timeout " + $TimeoutMin + " min, " + $ListaSim.Count + " simboli)")
$Ini = Join-Path $env:TEMP "abtg_spread_flotta.ini"
$primoSim = $ListaSim[0]
@"
[Experts]
AllowLiveTrading=false
AllowDllImport=false

[Charts]
MaxBars=2000000000

[StartUp]
Script=ABTG_SpreadOrario
ScriptParameters=abtg_spread_flotta.set
Symbol=$primoSim
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
function Conta-CsvFreschi {
  # quanti CSV per-simbolo sono comparsi FRESCHI (scritti dopo l'avvio)
  $n = 0
  foreach($s in $script:ListaSim){
    $c = Join-Path $script:FilesDir ("spread_orario_" + $s + ".csv")
    if(Test-Path -LiteralPath $c){
      $lw = (Get-Item -LiteralPath $c).LastWriteTime
      if($lw -ge $script:Avvio){ $n = $n + 1 }
    }
  }
  return $n
}

Write-Host "   avvio MT5..." -ForegroundColor Cyan
Start-Process -FilePath $Terminal -ArgumentList "/config:$Ini"

$scaduto  = (Get-Date).AddMinutes($TimeoutMin)
$finito   = $false
$ErrPref0 = $ErrorActionPreference
$ErrorActionPreference = "Continue"
while((Get-Date) -lt $scaduto){
  Start-Sleep -Seconds 20
  $coda = Coda-Log
  if($coda -match "SPREAD FLOTTA FINITA"){
    Write-Host "   lo script ha stampato la riga di chiusura di FLOTTA: ha finito." -ForegroundColor Green
    $finito = $true; break
  }
  $csvOk = Conta-CsvFreschi
  # rete: tutti i CSV freschi + referto fresco = fatto anche se il log sfugge
  if($csvOk -eq $ListaSim.Count){
    if(Test-Path -LiteralPath $TxtOut){
      $lw = (Get-Item -LiteralPath $TxtOut).LastWriteTime
      if($lw -ge $Avvio){
        # il referto viene flushato per simbolo: dagli 30s per la coda finale
        Start-Sleep -Seconds 30
        Write-Host "   tutti i CSV freschi + referto fresco: ha finito." -ForegroundColor Green
        $finito = $true; break
      }
    }
  }
  Write-Host ("   ... in corso (lettura tick), CSV per-simbolo freschi: " + $csvOk + "/" + $ListaSim.Count) -ForegroundColor DarkGray
}
$ErrorActionPreference = $ErrPref0

Write-Host "   chiudo MT5..." -ForegroundColor DarkGray
Get-Process -Name "terminal64" -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
Start-Sleep -Seconds 3

# =====================================================================
#  F6. RACCOLTA su Desktop + zip leggero, con conteggio onesto
# =====================================================================
Titolo "F6 - raccolta + zip"
$SimFatti   = @()
$SimMancano = @()
foreach($s in $ListaSim){
  $c = Join-Path $FilesDir ("spread_orario_" + $s + ".csv")
  $fresco = $false
  if(Test-Path -LiteralPath $c){
    $lw = (Get-Item -LiteralPath $c).LastWriteTime
    if($lw -ge $Avvio){ $fresco = $true }
  }
  if($fresco){
    Copy-Item -LiteralPath $c -Destination $Cart -Force -ErrorAction SilentlyContinue
    $SimFatti += $s
  } else {
    $SimMancano += $s
  }
}
$haTxt = $false
if(Test-Path -LiteralPath $TxtOut){
  $lw = (Get-Item -LiteralPath $TxtOut).LastWriteTime
  if($lw -ge $Avvio){
    Copy-Item -LiteralPath $TxtOut -Destination $Cart -Force -ErrorAction SilentlyContinue
    $haTxt = $true
  }
}
# porta anche gli ultimi log di MT5 (leggeri, servono a chi verifica)
if(Test-Path $logDirW){
  Get-ChildItem -LiteralPath $logDirW -Filter "*.log" -ErrorAction SilentlyContinue |
    Sort-Object LastWriteTime -Descending | Select-Object -First 2 |
    ForEach-Object { Copy-Item -LiteralPath $_.FullName -Destination $Cart -Force -ErrorAction SilentlyContinue }
}

# --- referto della RIGA (data:/modo:, esito per simbolo) ---
$esito = "PARZIALE"
if($finito -and $SimMancano.Count -eq 0 -and $haTxt){ $esito = "COMPLETA" }
$r = New-Object System.Collections.Generic.List[string]
[void]$r.Add("RIGA_SPREAD_FLOTTA v2 -- referto della riga")
[void]$r.Add("data:    " + $Avvio.ToString("yyyy-MM-dd HH:mm",$INV))
[void]$r.Add("modo:    PC di backtest, MT5 aperto SOLO per la misura (StartUp .ini, AllowLiveTrading=false); spread letto dai TICK STORICI su disco, non live")
[void]$r.Add("pin:     " + $Pin)
[void]$r.Add("simboli: " + $SimboliCsv)
[void]$r.Add("finestra:" + $Da + " -> " + $A)
[void]$r.Add("esito:   " + $esito)
[void]$r.Add("csv freschi:  " + ($SimFatti -join ", "))
if($SimMancano.Count -gt 0){
  [void]$r.Add("csv MANCANTI: " + ($SimMancano -join ", "))
  [void]$r.Add("RIPRESA: rilancia la stessa riga con -Simboli """ + ($SimMancano -join ",") + """")
}
if($haTxt){ [void]$r.Add("referto MQL5: REFERTO_SPREAD_FLOTTA.txt fresco (copiato)") }
else      { [void]$r.Add("referto MQL5: MANCANTE o vecchio") }
$r | Set-Content -Path $RefertoRiga -Encoding ASCII

# stampa a schermo il referto MQL5 se c'e'
if($haTxt){
  Write-Host ""
  Get-Content -LiteralPath (Join-Path $Cart "REFERTO_SPREAD_FLOTTA.txt") | ForEach-Object { Write-Host $_ }
}

# zip leggero: solo csv + txt (i log restano in cartella, non nello zip)
$Zip = Join-Path $Dsk ("SPREAD_FLOTTA_" + $Stamp + ".zip")
$daZip = @()
$daZip += Get-ChildItem -LiteralPath $Cart -Filter "*.csv" -ErrorAction SilentlyContinue | ForEach-Object { $_.FullName }
$daZip += Get-ChildItem -LiteralPath $Cart -Filter "*.txt" -ErrorAction SilentlyContinue | ForEach-Object { $_.FullName }
if($daZip.Count -gt 0){
  try{ Compress-Archive -Path $daZip -DestinationPath $Zip -Force }catch{ }
}

Write-Host ""
Write-Host ("RACCOLTA: " + $Cart) -ForegroundColor Green
Write-Host ("ZIP PRONTO DA MANDARE: " + $Zip) -ForegroundColor Green
Write-Host "Verifica che dentro ci siano:" -ForegroundColor DarkGray
foreach($s in $ListaSim){
  Write-Host ("   - spread_orario_" + $s + ".csv   (24 righe orarie + riga TUTTO)") -ForegroundColor DarkGray
}
Write-Host "   - REFERTO_SPREAD_FLOTTA.txt   (BID/ASK + tabella oraria per simbolo)" -ForegroundColor DarkGray
Write-Host "   - RIGA_REFERTO_SPREAD_FLOTTA.txt (data/modo/esito della riga)" -ForegroundColor DarkGray

# =====================================================================
#  CODICE DI USCITA (un parziale NON esce 0)
#   0 -> misura COMPLETA: riga di chiusura vista, TUTTI i CSV freschi,
#        referto fresco
#   2 -> PARZIALE / RIPRENDIBILE: manca qualcosa; il referto parziale
#        e' comunque leggibile, e la RIPRESA e' stampata qui sopra
#   1 -> gia' uscito prima (pin/terminale/compilazione/MT5 aperto)
# =====================================================================
if($esito -eq "COMPLETA"){
  Write-Host ""
  Write-Host "MISURA COMPLETA: tutti i CSV e il referto sono freschi." -ForegroundColor Green
  exit 0
}
Write-Host ""
Write-Host "ATTENZIONE: MISURA PARZIALE (riprendibile)." -ForegroundColor Red
if(-not $finito){ Write-Host "  la riga di chiusura 'SPREAD FLOTTA FINITA' non e' arrivata (timeout?)." -ForegroundColor Red }
if($SimMancano.Count -gt 0){
  Write-Host ("  CSV mancanti: " + ($SimMancano -join ", ")) -ForegroundColor Red
  Write-Host ("  RIPRESA: rilancia la stessa riga con -Simboli """ + ($SimMancano -join ",") + """") -ForegroundColor Yellow
}
if(-not $haTxt){ Write-Host "  manca il referto txt fresco (il parziale, se c'e', e' in MQL5\Files)." -ForegroundColor Red }
Write-Host "  Quello che c'e' sta comunque in raccolta e nello zip: chi legge decide." -ForegroundColor Yellow
exit 2
