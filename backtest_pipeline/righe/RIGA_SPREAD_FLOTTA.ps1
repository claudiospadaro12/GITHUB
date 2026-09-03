# =====================================================================
#  MARCATORE_RIGA_SPREAD_FLOTTA_v3
#  RIGA_SPREAD_FLOTTA.ps1  --  SPREAD REALE PER FASCIA ORARIA sui tre
#                              indici della flotta (NASUSD, U30USD,
#                              D30EUR), dai TICK STORICI gia' sul disco
# ---------------------------------------------------------------------
#  PERCHE' ESISTE (direzione di Claudio, 31/08 sera):
#  "dobbiamo usare simboli col minimo attrito". La risposta di casa e'
#  MISURARE lo spread reale su BCM, simbolo per simbolo, ORA per ORA:
#  oggi tutti i prova usano "spread 2.0 [NON MISURATO]". Questa riga
#  mette finalmente in campo il logger promosso il 23/08 (mai lanciato)
#  e lo ESTENDE: il MOTORE v2 e' multi-simbolo + tabella oraria
#  (media/mediana/P95/max per ora del giorno SERVER, in punti indice).
#  NB: il motore .mq5 e' alla v2, questa riga .ps1 e' alla v3 -- i due
#  numeri di versione sono INDIPENDENTI e i due marcatori pure.
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
#   - se la corsa muore a meta', si usa il BLOCCO DI RIPRESA della
#     pagina passando -Simboli coi soli mancanti (la riga li stampa in
#     fondo, e li scrive nel referto);
#   - per FERMARLA a mano (RAM, o serve il PC): si CHIUDE MT5 e basta.
#     La riga se ne accorge entro 20 s, raccoglie il parziale, fa lo
#     zip e stampa la ripresa. NON serve Ctrl+C.
#
#  NON committa, NON tocca il forward, NON promuove niente.
#
#  ---------------------------------------------------------------------
#  v3 (03/09, dal FAIL del verificatore -- classi 88 / 94-bis / 94-ter /
#      106 / 108 / 110 della CHECKLIST_RIGA_DI_LANCIO.md):
#   1. IL REFERTO DELLA RIGA SI SCRIVE SU **OGNI** RAMO che arriva dopo
#      la creazione della cartella di raccolta (terminale non trovato,
#      scarico del motore fallito, COMPILAZIONE FALLITA, MT5 gia'
#      aperto, giro a vuoto, corsa vera) -- prima usciva 1 in silenzio e
#      sul Desktop non restava NIENTE da mandare (94-bis), mentre la
#      pagina prometteva un referto.
#   2. TRE STATI PER OGNI PASSO (94-ter): motore / compilazione /
#      guardia MT5 / corsa hanno "NON TENTATA" - "FALLITA" - "OK", e il
#      campo si timbra sul ramo che lo DECIDE. Il log di MetaEditor
#      finisce in raccolta come COMPILAZIONE_FALLITA.log.
#   3. RIGA "fine:" NEL REFERTO (110): "data:" e' l'ora di AVVIO e su
#      una corsa di ORE sembra vecchia; adesso il referto porta tutte e
#      due le ore e lo dice a chi legge.
#   4. LA PULIZIA PRE-CORSA NON DISTRUGGE PIU' I REPERTI DELLA CORSA
#      PRIMA (88): il referto e i CSV che stanno in MQL5\Files vengono
#      COPIATI in raccolta (suffisso _PRIMA) e solo dopo cancellati.
#      Serve alla RIPRESA: se la corsa di prima e' stata interrotta a
#      meta', quei file erano l'unica copia.
#   5. SE MT5 SPARISCE (chiuso a mano per liberare RAM, o crollato) la
#      riga se ne accorge entro 20 s, CHIUDE il giro, raccoglie il
#      parziale e stampa la RIPRESA: prima restava a girare a vuoto
#      fino al timeout (fino a 7 ore).
#   6. Compress-Archive non fallisce piu' in silenzio: lo stato dello
#      zip finisce in console e in coda al referto.
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
  [switch]$ChiudiMT5,                        # ammazza un MT5 aperto (MAI sul VPS)
  [switch]$SoloControllo                     # giro a vuoto: trova+compila+preset, NON apre MT5
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
$Zip         = Join-Path $Dsk ("SPREAD_FLOTTA_" + $Stamp + ".zip")

function Ora(){ return (Get-Date).ToString("HH:mm:ss",$INV) }
function Dico($t,$c="Gray"){ Write-Host ("[" + (Ora) + "] " + $t) -ForegroundColor $c }
function Titolo($t){ Write-Host ""; Write-Host ("=== " + $t + " ===") -ForegroundColor Cyan }

# ---------------------------------------------------------------------
#  STATO DEI PASSI (checklist 94-ter): ogni campo che finisce nel
#  referto ha TANTI STATI QUANTI I RAMI, e si timbra sul ramo che lo
#  DECIDE -- non solo su quello che lo fa contento.
# ---------------------------------------------------------------------
$StatoMotore  = "NON SCARICATO"
$StatoCompila = "NON TENTATA"
$StatoMT5     = "NON TENTATA"
$StatoCorsa   = "NON TENTATA"
$StatoZip     = "NON FATTO"
$SimFatti     = @()
$SimMancano   = @() + $ListaSim
$haTxt        = $false

# ---------------------------------------------------------------------
#  IL REFERTO DELLA RIGA + LO ZIP, SCRITTI SU OGNI RAMO (94-bis).
#  Un exit che non lascia niente sul Desktop e' un exit su cui la
#  pagina non puo' dire "mandami lo zip".
# ---------------------------------------------------------------------
function ScriviRefertoRiga($esito,$causa){
  $fine  = Get-Date
  $fatti = "nessuno"
  if($script:SimFatti.Count   -gt 0){ $fatti = ($script:SimFatti -join ", ") }
  $manca = "nessuno"
  if($script:SimMancano.Count -gt 0){ $manca = ($script:SimMancano -join ", ") }

  $r = New-Object System.Collections.Generic.List[string]
  [void]$r.Add("RIGA_SPREAD_FLOTTA v3 -- referto della riga")
  [void]$r.Add("data:    " + $script:Avvio.ToString("yyyy-MM-dd HH:mm",$script:INV) + "   <-- ORA DI AVVIO della riga, NON l'ora attuale (la corsa dura ORE)")
  [void]$r.Add("fine:    " + $fine.ToString("yyyy-MM-dd HH:mm",$script:INV) + "   <-- quando questo referto e' stato scritto")
  [void]$r.Add("modo:    PC di backtest, MT5 aperto SOLO per la misura (StartUp .ini, AllowLiveTrading=false); spread letto dai TICK STORICI su disco, non live")
  [void]$r.Add("pin:     " + $script:Pin)
  [void]$r.Add("simboli: " + $script:SimboliCsv)
  [void]$r.Add("finestra: " + $script:Da + " -> " + $script:A)
  [void]$r.Add("")
  [void]$r.Add("PASSI (NON TENTATA = non ci siamo arrivati; FALLITA = tentata e andata male):")
  [void]$r.Add("  motore:       " + $script:StatoMotore)
  [void]$r.Add("  compilazione: " + $script:StatoCompila)
  [void]$r.Add("  guardia MT5:  " + $script:StatoMT5)
  [void]$r.Add("  corsa:        " + $script:StatoCorsa)
  [void]$r.Add("")
  [void]$r.Add("esito:   " + $esito)
  if($causa -ne ""){ [void]$r.Add("causa:   " + $causa) }
  [void]$r.Add("csv freschi:  " + $fatti)
  [void]$r.Add("csv MANCANTI: " + $manca)
  # la RIPRESA si propone SOLO quando c'e' davvero un parziale da riprendere:
  # su una FERMATA (MT5 aperto, compilazione fallita...) la cosa giusta e'
  # togliere l'ostacolo e rilanciare il blocco NORMALE, non la ripresa.
  if($esito -eq "PARZIALE" -and $script:SimMancano.Count -gt 0){
    [void]$r.Add("RIPRESA: usa il BLOCCO DI RIPRESA della pagina con -Simboli """ + ($script:SimMancano -join ",") + """")
  }
  if($script:haTxt){ [void]$r.Add("referto MQL5: REFERTO_SPREAD_FLOTTA.txt fresco (copiato in questa cartella)") }
  else             { [void]$r.Add("referto MQL5: MANCANTE o vecchio") }
  $prima = @(Get-ChildItem -LiteralPath $script:Cart -Filter "*_PRIMA*" -ErrorAction SilentlyContinue | ForEach-Object { $_.Name })
  if($prima.Count -gt 0){
    [void]$r.Add("reperti della corsa PRECEDENTE messi in salvo qui (suffisso _PRIMA, NON sono di questa corsa): " + ($prima -join ", "))
  }
  [void]$r.Add("")
  [void]$r.Add("ATTENZIONE (checklist 106): REFERTO_SPREAD_FLOTTA.txt NON e' cumulativo --")
  [void]$r.Add("il motore lo RISCRIVE da zero a ogni corsa, quindi su una RIPRESA contiene")
  [void]$r.Add("SOLO i simboli di quella ripresa. Il quadro completo e' l'unione delle")
  [void]$r.Add("cartelle SPREAD_FLOTTA_* sul Desktop (i CSV per simbolo non si sovrascrivono).")
  [void]$r.Add("zip atteso: " + $script:Zip)
  $r | Set-Content -Path $script:RefertoRiga -Encoding ASCII

  # --- zip leggero: solo csv + txt (i log restano in cartella) ---
  $script:StatoZip = "NON FATTO"
  $daZip = @()
  $daZip += Get-ChildItem -LiteralPath $script:Cart -Filter "*.csv" -ErrorAction SilentlyContinue | ForEach-Object { $_.FullName }
  $daZip += Get-ChildItem -LiteralPath $script:Cart -Filter "*.txt" -ErrorAction SilentlyContinue | ForEach-Object { $_.FullName }
  if($daZip.Count -gt 0){
    try{
      Compress-Archive -Path $daZip -DestinationPath $script:Zip -Force -ErrorAction Stop
      $script:StatoZip = "OK"
    }catch{
      $script:StatoZip = "FALLITO: " + $_.Exception.Message
    }
  }else{
    $script:StatoZip = "NON FATTO: niente da comprimere"
  }
  if($script:StatoZip -ne "OK"){
    Add-Content -Path $script:RefertoRiga -Value ("zip: " + $script:StatoZip) -Encoding ASCII
    Write-Host ("   ZIP NON FATTO (" + $script:StatoZip + "): manda la CARTELLA " + $script:Cart) -ForegroundColor Yellow
  }
}

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
Write-Host ("#  SPREAD ORARIO FLOTTA -- " + $SimboliCsv + " @ BCM (v3)") -ForegroundColor Cyan
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
if(-not $cand){
  Write-Host "Terminale BCM non trovato." -ForegroundColor Red
  ScriviRefertoRiga "FERMATA" "terminale BCM (terminal64.exe) non trovato in Program Files"
  exit 1
}
$instDir    = $cand.DirectoryName
$Terminal   = Join-Path $instDir "terminal64.exe"
$MetaEditor = Join-Path $instDir "metaeditor64.exe"
$termRoot   = Join-Path $env:APPDATA "MetaQuotes\Terminal"
$DataFolder = Get-ChildItem $termRoot -Directory -ErrorAction SilentlyContinue | Where-Object {
    $o = Join-Path $_.FullName "origin.txt"
    (Test-Path $o) -and ((Get-Content $o -Raw).Trim() -ieq $instDir)
} | Select-Object -First 1 -ExpandProperty FullName
if(-not $DataFolder){
  Write-Host "Cartella dati MT5 non trovata." -ForegroundColor Red
  ScriviRefertoRiga "FERMATA" "cartella dati MT5 non trovata (origin.txt che punta al terminale BCM)"
  exit 1
}
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
try{
  Scarica ($RawPin + "/mql5/Scripts/ABTG_SpreadOrario.mq5") $Mq5 'SPREAD ORARIO MULTI-SIMBOLO v2'
}catch{
  $StatoMotore = "SCARICO FALLITO: " + $_.Exception.Message
  Write-Host ("ERRORE nello scarico del motore dal pin: " + $_.Exception.Message) -ForegroundColor Red
  ScriviRefertoRiga "FERMATA" "motore ABTG_SpreadOrario.mq5 non scaricato dal pin (rete, pin sbagliato, o marcatore assente)"
  exit 1
}
$StatoMotore = "OK (dal pin, marcatore 'SPREAD ORARIO MULTI-SIMBOLO v2' verificato)"
Write-Host ("   sorgente pinnato -> " + $Mq5) -ForegroundColor Green
$Ex5  = [System.IO.Path]::ChangeExtension($Mq5, ".ex5")
$Log5 = [System.IO.Path]::ChangeExtension($Mq5, ".log")
# checklist 33-bis: (1) il .ex5 di ieri fa passare il gate su una compilazione
# FALLITA oggi -> si cancella PRIMA; (2) MetaEditor e' SINGLE-INSTANCE: se ne
# gira gia' una copia il processo torna subito e compila l'altra istanza ->
# si aspetta l'ARTEFATTO, non il ritorno del processo.
Remove-Item -LiteralPath $Ex5  -Force -ErrorAction SilentlyContinue
Remove-Item -LiteralPath $Log5 -Force -ErrorAction SilentlyContinue
$t0 = Get-Date
& $MetaEditor "/compile:$Mq5" "/log" | Out-Null
while((-not (Test-Path -LiteralPath $Ex5)) -and ((New-TimeSpan -Start $t0 -End (Get-Date)).TotalSeconds -lt 180)){ Start-Sleep -Seconds 2 }
if(-not (Test-Path -LiteralPath $Ex5)){
  $StatoCompila = "FALLITA (nessun .ex5 dopo 180 s)"
  Write-Host "ERRORE di compilazione (nessun .ex5 dopo 180 s): vedi COMPILAZIONE_FALLITA.txt in raccolta." -ForegroundColor Red
  if(Test-Path -LiteralPath $Log5){
    Get-Content -LiteralPath $Log5 -ErrorAction SilentlyContinue | Select-Object -Last 40 | ForEach-Object { Write-Host $_ -ForegroundColor DarkYellow }
    # il log degli errori va IN RACCOLTA **con estensione .txt**: e' il
    # risultato del passo, e lo zip prende solo *.csv e *.txt
    Copy-Item -LiteralPath $Log5 -Destination (Join-Path $Cart "COMPILAZIONE_FALLITA.txt") -Force -ErrorAction SilentlyContinue
  }
  Write-Host "   (se MetaEditor era gia' APERTO: chiudilo e rilancia)" -ForegroundColor Yellow
  ScriviRefertoRiga "FERMATA" "compilazione di ABTG_SpreadOrario.mq5 FALLITA (errori in COMPILAZIONE_FALLITA.txt, se MetaEditor ha scritto il log)"
  exit 1
}
$StatoCompila = "OK (.ex5 prodotto in questa corsa)"
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
  $StatoMT5 = "RIFIUTATA: MT5 era gia' APERTO (nessun -ChiudiMT5)"
  Write-Host ""
  Write-Host "   MT5 e' APERTO. In automatico non si puo': un secondo avvio sulla" -ForegroundColor Red
  Write-Host "   stessa cartella dati non esegue lo script." -ForegroundColor Red
  Write-Host "   Aggiungi -ChiudiMT5 per farlo chiudere da solo (MAI SUL VPS: li'" -ForegroundColor Red
  Write-Host "   spegneresti la FLOTTA IN FORWARD)." -ForegroundColor Red
  ScriviRefertoRiga "FERMATA" "MT5 gia' APERTO all'avvio: la riga NON lo ammazza da sola (rete che protegge il forward)"
  exit 1
}
$StatoMT5 = "OK (MT5 chiuso all'avvio)"

if($SoloControllo){
  $StatoCorsa = "NON TENTATA (-SoloControllo: MT5 non aperto)"
  Write-Host ""
  Write-Host "GIRO A VUOTO OK: terminale trovato, motore SCARICATO DAL PIN e COMPILATO," -ForegroundColor Green
  Write-Host "preset scritto, MT5 CHIUSO. Non ho aperto MT5 e non ho toccato nessun file." -ForegroundColor Green
  Write-Host "Per la corsa vera: la stessa riga SENZA -SoloControllo." -ForegroundColor Yellow
  ScriviRefertoRiga "CONTROLLO OK" ""
  Write-Host ("RACCOLTA (giro a vuoto): " + $Cart) -ForegroundColor Green
  exit 0
}

# --- pulizia pre-corsa, CON SALVATAGGIO DEI REPERTI (checklist 88) ------
#  cancellare gli output vecchi serve al gate di freschezza (un file
#  trovato dopo e' NUOVO di sicuro), MA se la corsa di prima e' stata
#  INTERROTTA a meta' quei file sono l'unica copia che esiste: prima si
#  copiano in raccolta col suffisso _PRIMA, poi si cancellano.
if(Test-Path -LiteralPath $TxtOut){
  Copy-Item -LiteralPath $TxtOut -Destination (Join-Path $Cart "REFERTO_SPREAD_FLOTTA_PRIMA.txt") -Force -ErrorAction SilentlyContinue
  Write-Host "   (referto della corsa precedente salvato come REFERTO_SPREAD_FLOTTA_PRIMA.txt)" -ForegroundColor DarkGray
}
Remove-Item -LiteralPath $TxtOut -Force -ErrorAction SilentlyContinue
foreach($s in $ListaSim){
  $c = Join-Path $FilesDir ("spread_orario_" + $s + ".csv")
  if(Test-Path -LiteralPath $c){
    Copy-Item -LiteralPath $c -Destination (Join-Path $Cart ("spread_orario_" + $s + "_PRIMA.csv")) -Force -ErrorAction SilentlyContinue
  }
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
function Csv-Buono($percorso){
  # FRESCO (scritto dopo l'avvio) **E NON VUOTO**: la riga TUTTO deve portare
  # tick_totali > 0. Un CSV di sole 'n/d' e' una misura FALLITA (tick non
  # letti), non una misura completa: non deve far uscire 0.
  if(-not (Test-Path -LiteralPath $percorso)){ return $false }
  try{ $lw = (Get-Item -LiteralPath $percorso).LastWriteTime }catch{ return $false }
  if($lw -lt $script:Avvio){ return $false }
  $ok = $false
  foreach($riga in @(Get-Content -LiteralPath $percorso -ErrorAction SilentlyContinue)){
    if($riga -like "TUTTO,*"){
      $campi = $riga -split ","
      if($campi.Count -ge 2 -and $campi[1] -match '^[0-9]+$' -and [int64]$campi[1] -gt 0){ $ok = $true }
    }
  }
  return $ok
}
function Conta-CsvFreschi {
  # quanti CSV per-simbolo sono FRESCHI e NON VUOTI
  $n = 0
  foreach($s in $script:ListaSim){
    if(Csv-Buono (Join-Path $script:FilesDir ("spread_orario_" + $s + ".csv"))){ $n = $n + 1 }
  }
  return $n
}

Write-Host "   avvio MT5..." -ForegroundColor Cyan
Start-Process -FilePath $Terminal -ArgumentList "/config:$Ini"

$scaduto    = (Get-Date).AddMinutes($TimeoutMin)
$finito     = $false
$mt5Sparito = $false
$giri       = 0
$ErrPref0   = $ErrorActionPreference
$ErrorActionPreference = "Continue"
while((Get-Date) -lt $scaduto){
  Start-Sleep -Seconds 20
  $giri = $giri + 1
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
  # MT5 SPARITO (chiuso a mano per liberare RAM, oppure crollato): non si
  # aspetta il timeout di ore a vuoto. Si esce, si raccoglie il parziale e
  # si stampa la RIPRESA. Sta DOPO i due controlli di fine corsa apposta:
  # se la corsa era finita, il verdetto e' COMPLETA anche se MT5 e' stato
  # chiuso nello stesso giro. I primi 3 giri (60 s) sono di grazia: il
  # terminale ci mette qualche secondo a comparire fra i processi.
  if($giri -ge 3 -and -not (Get-Process -Name "terminal64" -ErrorAction SilentlyContinue)){
    Write-Host "   MT5 NON C'E' PIU' (chiuso da fuori o crollato): chiudo il giro e raccolgo il parziale." -ForegroundColor Yellow
    $mt5Sparito = $true; break
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
  $fresco = Csv-Buono $c
  # si copia comunque quello che c'e' (anche un CSV vuoto e' una prova),
  # ma VUOTO conta come MANCANTE: un parziale non esce 0.
  if(Test-Path -LiteralPath $c){ Copy-Item -LiteralPath $c -Destination $Cart -Force -ErrorAction SilentlyContinue }
  if($fresco){ $SimFatti += $s } else { $SimMancano += $s }
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

# --- stato della corsa, coi suoi rami veri (94-ter) ---
$esito = "PARZIALE"
if($finito -and $SimMancano.Count -eq 0 -and $haTxt){ $esito = "COMPLETA" }
$causa = ""
if($esito -eq "COMPLETA"){
  $StatoCorsa = "OK (riga di chiusura vista, tutti i CSV freschi e non vuoti)"
}elseif($mt5Sparito){
  $StatoCorsa = "INTERROTTA: MT5 e' sparito durante la corsa (chiuso da fuori o crollato)"
  $causa      = "MT5 chiuso/crollato prima della fine: quello che era gia' misurato e' qui, il resto si riprende"
}elseif(-not $finito){
  $StatoCorsa = "INTERROTTA: TIMEOUT di " + $TimeoutMin + " min senza riga di chiusura"
  $causa      = "timeout: la riga di chiusura 'SPREAD FLOTTA FINITA' non e' arrivata"
}else{
  $StatoCorsa = "FINITA ma INCOMPLETA (riga di chiusura vista, ma qualche CSV manca o e' a 0 tick)"
  $causa      = "il motore ha chiuso, ma non tutti i simboli hanno prodotto un CSV con tick > 0"
}

# --- referto della RIGA + zip (stessa funzione di tutti gli altri rami) ---
ScriviRefertoRiga $esito $causa

# stampa a schermo il referto MQL5 se c'e'
if($haTxt){
  Write-Host ""
  Get-Content -LiteralPath (Join-Path $Cart "REFERTO_SPREAD_FLOTTA.txt") | ForEach-Object { Write-Host $_ }
}

Write-Host ""
Write-Host ("RACCOLTA: " + $Cart) -ForegroundColor Green
if($StatoZip -eq "OK"){ Write-Host ("ZIP PRONTO DA MANDARE: " + $Zip) -ForegroundColor Green }
else                  { Write-Host ("ZIP NON FATTO (" + $StatoZip + "): manda la CARTELLA qui sopra.") -ForegroundColor Yellow }
Write-Host "Verifica che dentro ci siano:" -ForegroundColor DarkGray
foreach($s in $ListaSim){
  Write-Host ("   - spread_orario_" + $s + ".csv   (24 righe orarie + riga TUTTO)") -ForegroundColor DarkGray
}
Write-Host "   - REFERTO_SPREAD_FLOTTA.txt   (BID/ASK + tabella oraria per simbolo)" -ForegroundColor DarkGray
Write-Host "   - RIGA_REFERTO_SPREAD_FLOTTA.txt (data/fine/modo/passi/esito della riga)" -ForegroundColor DarkGray
Write-Host ("   la riga data: del referto vale " + $Avvio.ToString("yyyy-MM-dd HH:mm",$INV) + " = ORA DI AVVIO, NON l'ora attuale (" + (Get-Date).ToString("HH:mm",$INV) + "): la riga fine: dice quando ha finito.") -ForegroundColor DarkGray

# =====================================================================
#  CODICE DI USCITA (un parziale NON esce 0)
#   0 -> misura COMPLETA: riga di chiusura vista, TUTTI i CSV freschi,
#        referto fresco. (Esce 0 anche il giro a vuoto -SoloControllo,
#        che pero' scrive "esito: CONTROLLO OK" nel referto: il numero
#        non basta, si legge il referto.)
#   2 -> PARZIALE / RIPRENDIBILE: manca qualcosa; il referto parziale
#        e' comunque leggibile, e la RIPRESA e' stampata qui sopra
#   1 -> fermata prima della corsa (terminale, scarico del motore,
#        COMPILAZIONE, MT5 gia' aperto): da v3 anche questi rami
#        lasciano referto + zip sul Desktop. Unica eccezione: -Pin
#        assente/malformato e -Simboli vuoto, che escono 1 PRIMA che la
#        cartella di raccolta esista (errori di riga, rossi in console).
# =====================================================================
if($esito -eq "COMPLETA"){
  Write-Host ""
  Write-Host "MISURA COMPLETA: tutti i CSV e il referto sono freschi." -ForegroundColor Green
  exit 0
}
Write-Host ""
Write-Host "ATTENZIONE: MISURA PARZIALE (riprendibile)." -ForegroundColor Red
if($mt5Sparito){ Write-Host "  MT5 e' sparito durante la corsa (chiuso da fuori o crollato)." -ForegroundColor Red }
if(-not $finito -and -not $mt5Sparito){ Write-Host "  la riga di chiusura 'SPREAD FLOTTA FINITA' non e' arrivata (timeout?)." -ForegroundColor Red }
if($SimMancano.Count -gt 0){
  Write-Host ("  CSV mancanti (assenti, o presenti con 0 tick letti): " + ($SimMancano -join ", ")) -ForegroundColor Red
  Write-Host ("  RIPRESA: usa il BLOCCO DI RIPRESA della pagina con -Simboli """ + ($SimMancano -join ",") + """") -ForegroundColor Yellow
}
if(-not $haTxt){ Write-Host "  manca il referto txt fresco (il parziale, se c'e', e' in MQL5\Files)." -ForegroundColor Red }
Write-Host "  Quello che c'e' sta comunque in raccolta e nello zip: chi legge decide." -ForegroundColor Yellow
exit 2
