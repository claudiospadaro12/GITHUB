# =====================================================================
#  importa_storico_esterno.ps1  --  porta dentro MT5 gli ANNI CHE
#                                   MANCANO, come CUSTOM SYMBOL
# ---------------------------------------------------------------------
#  ### REGOLA D'USO, CONGELATA (report/ASPETTATIVE_REALISTICHE.md) ###
#  I simboli *_EXT prodotti da qui servono SOLO come PROVA DI REGIME,
#  a celle e parametri CONGELATI. Domanda unica ammessa:
#      "questa strategia sopravvive a un mercato orso / a un altro
#       contesto?"
#  NON si tara MAI un parametro su dati di un altro feed: la taratura
#  resta sui simboli BCM nativi, dove si opera davvero. Un parametro
#  pescato qui e' PEGGIO di nessun test, perche' sembra validato.
#
#  PERCHE' ESISTE (14/08/2026):
#  lo storico BCM degli INDICI parte dal 26/09/2024 -> i walk-forward
#  hanno 21 mesi e UN SOLO REGIME (indici in salita). Niente 2022
#  (orso + inflazione), niente 2020 (crollo). E' il rischio numero uno
#  del progetto, piu' grande del rumore statistico. Sul FOREX quegli
#  anni si possono recuperare gratis (HistData.com, barre M1 dal 2000).
#
#  COSA FA, in ordine:
#   1. scarica (o si fa dare a mano) gli ZIP annuali M1 di HistData
#   2. li decomprime e li concatena in un CSV per simbolo
#   3. copia il CSV in MQL5\Files del terminale BCM di backtest
#   4. compila e lancia ABTG_ImportaStoricoEsterno per ogni simbolo:
#      crea EURUSD_EXT clonando le proprieta' di EURUSD (digits, tick
#      value, contract size) e CALIBRA DA SOLO il fuso orario contro
#      lo storico nativo BCM
#   5. raccoglie il referto sul Desktop + zip pronto da mandare
#
#  LE DUE TRAPPOLE CHE DISINNESCA (le tre sono nel report):
#   - FUSO E DST: HistData e' ora di New York, BCM e' GMT+2/+3. Lo
#     script MQL5 prova tutti gli shift da -6 a +6 e sceglie quello che
#     minimizza la differenza fra le chiusure H1 importate e quelle
#     native, stampando la tabella completa.
#   - UNITA' E VALORE PUNTO: il custom symbol e' un CLONE del simbolo
#     BCM, e le proprieta' critiche vengono rilette e confrontate.
#  QUELLA CHE RESTA: spread e commissioni sono quelli che imposti nel
#  tester, non quelli storici. Su stop stretti (EasyTrend 20-25 pips)
#  puo' spostare il verdetto: va detto ogni volta.
#
#  COME SI LANCIA (PC di backtest, MT5 CHIUSO, repo NON clonato):
#   irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/lavoro/backtest_pipeline/importa_storico_esterno.ps1" -OutFile "$env:USERPROFILE\importa_storico_esterno.ps1"
#   powershell -ExecutionPolicy Bypass -File "$env:USERPROFILE\importa_storico_esterno.ps1" -Simboli "EURUSD,GBPUSD" -Da 2018 -A 2024 -Auto
#
#  VARIANTI
#   (niente -Auto)        prepara tutto e stampa le istruzioni manuali
#   -SoloReferto          rilegge l'ultimo referto senza rifare nulla
#   -CartellaZip "..."    dove stanno (o dove mettere) gli ZIP HistData
#   -SaltaDownload        usa solo gli ZIP gia' presenti in cartella
#   -Formato 1            CSV generico invece del formato HistData
#   -ShiftOre 2           shift manuale (richiede -NoAutoShift)
#   -NoAutoShift          spegne la calibrazione automatica del fuso
#
#  !! SUL VPS NON USARE MAI -Auto NE' -ChiudiMT5: chiuderebbero il
#     terminale che tiene su gli EA in forward. Sul VPS si prepara e
#     si trascina lo script a mano.
# =====================================================================
param(
  [string] $Simboli       = "EURUSD",
  [int]    $Da            = 2018,
  [int]    $A             = 2024,
  [string] $CartellaZip   = "",
  [int]    $Formato       = 0,
  [int]    $ShiftOre      = 0,
  [switch] $NoAutoShift,
  [switch] $SaltaDownload,
  [switch] $SoloReferto,
  [switch] $Auto,
  [switch] $ChiudiMT5,
  [int]    $TimeoutMin    = 30
)
$ErrorActionPreference = "Stop"
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$EABranch = "lavoro"
$RawBase  = "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$EABranch"
$RepoRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$Work     = Join-Path $env:USERPROFILE "abtg_storico_esterno"
New-Item -ItemType Directory -Force -Path $Work | Out-Null
if ([string]::IsNullOrWhiteSpace($CartellaZip)) { $CartellaZip = Join-Path $Work "zip" }
New-Item -ItemType Directory -Force -Path $CartellaZip | Out-Null

$Lista = @($Simboli -split "," | ForEach-Object { $_.Trim().ToUpper() } | Where-Object { $_ })
if ($Lista.Count -eq 0) { Write-Host "Nessun simbolo indicato." -ForegroundColor Red; exit 1 }

# ---------------------------------------------------------------------
# 1. trova terminale BCM + cartella dati  (stessa logica di
#    scarica_storico.ps1: origin.txt e' l'unico modo affidabile di
#    legare una cartella dati al suo terminale)
# ---------------------------------------------------------------------
$allTerm = Get-ChildItem "C:\Program Files","C:\Program Files (x86)" -Recurse -Filter "terminal64.exe" -ErrorAction SilentlyContinue
$cand = $allTerm | Where-Object { $_.DirectoryName -like "*BCM Markets MT5 Terminal*" -and $_.DirectoryName -notlike "*-V3*" } | Select-Object -First 1
if (-not $cand) { $cand = $allTerm | Where-Object { $_.DirectoryName -like "*BCM Markets*" } | Select-Object -First 1 }
if (-not $cand) { Write-Host "Terminale BCM non trovato." -ForegroundColor Red; exit 1 }

$instDir    = $cand.DirectoryName
$Terminal   = Join-Path $instDir "terminal64.exe"
$MetaEditor = Join-Path $instDir "metaeditor64.exe"
$termRoot   = Join-Path $env:APPDATA "MetaQuotes\Terminal"
$DataFolder = Get-ChildItem $termRoot -Directory -ErrorAction SilentlyContinue | Where-Object {
    $o = Join-Path $_.FullName "origin.txt"
    (Test-Path $o) -and ((Get-Content $o -Raw).Trim() -ieq $instDir)
} | Select-Object -First 1 -ExpandProperty FullName
if (-not $DataFolder) { Write-Host "Cartella dati MT5 non trovata." -ForegroundColor Red; exit 1 }

$FilesDir  = Join-Path $DataFolder "MQL5\Files"
$Referto   = Join-Path $FilesDir "ABTG_ImportEsterno_referto.csv"

# ---------------------------------------------------------------------
# referto: lettura tollerante (MT5 puo' tenerlo ancora aperto)
# ---------------------------------------------------------------------
function Leggi-Referto {
  if (-not (Test-Path $Referto)) { return $null }
  try {
    $fs = [System.IO.File]::Open($Referto, 'Open', 'Read', 'ReadWrite')
    $sr = New-Object System.IO.StreamReader($fs)
    $testo = $sr.ReadToEnd(); $sr.Close(); $fs.Close()
    if ([string]::IsNullOrWhiteSpace($testo)) { return $null }
    return ($testo | ConvertFrom-Csv)
  } catch {
    try {
      $tmp = Join-Path $env:TEMP "abtg_import_peek.csv"
      Copy-Item $Referto $tmp -Force -ErrorAction Stop
      return (Import-Csv $tmp)
    } catch { return $null }
  }
}

function Mostra-Referto {
  $righe = Leggi-Referto
  if (-not $righe) {
    Write-Host ""
    Write-Host "Nessun referto leggibile in:" -ForegroundColor Yellow
    Write-Host ("  " + $Referto) -ForegroundColor Yellow
    Write-Host "O lo script MQL5 non e' ancora stato eseguito, o MT5 lo sta scrivendo." -ForegroundColor Yellow
    return
  }
  Write-Host ""
  Write-Host "=== REFERTO IMPORT ESTERNO ===" -ForegroundColor Cyan
  Write-Host $Referto -ForegroundColor DarkGray
  $righe | Format-Table SimboloEXT, Barre, PrimaData, UltimaData, ShiftOre, DiffMediaPunti, DiffMediaPct, CoperturaPct, Verdetto -AutoSize

  $rotti   = $righe | Where-Object { $_.Verdetto -like "*ERRORE UNITA*" }
  $sospetti= $righe | Where-Object { $_.Verdetto -like "*SOSPETTO*" }
  $ciechi  = $righe | Where-Object { $_.Verdetto -like "*NON VERIFICATO*" }
  if ($rotti) {
    Write-Host "!! PROPRIETA' SBAGLIATE (digits/tick value/contract size):" -ForegroundColor Red
    $rotti | ForEach-Object { Write-Host ("   " + $_.SimboloEXT) -ForegroundColor Red }
    Write-Host "   Su questi simboli i P&L NON significano nulla: non testarli." -ForegroundColor Red
  }
  if ($sospetti) {
    Write-Host "!! DIFFERENZA GRANDE fra feed importato e nativo:" -ForegroundColor Red
    $sospetti | ForEach-Object { Write-Host ("   " + $_.SimboloEXT + "  diff media " + $_.DiffMediaPct + "%") -ForegroundColor Red }
    Write-Host "   Cause tipiche: simbolo sorgente sbagliato, oppure CSV di un'altra coppia." -ForegroundColor Red
  }
  if ($ciechi) {
    Write-Host "!! SHIFT NON VERIFICATO (nessuna sovrapposizione col nativo):" -ForegroundColor Yellow
    $ciechi | ForEach-Object { Write-Host ("   " + $_.SimboloEXT) -ForegroundColor Yellow }
    Write-Host "   I dati ci sono ma il fuso non e' dimostrato. Scarica prima lo" -ForegroundColor Yellow
    Write-Host "   storico nativo (scarica_storico.ps1) e rilancia l'import." -ForegroundColor Yellow
  }
  if (-not $rotti -and -not $sospetti -and -not $ciechi) {
    Write-Host "OK: import confrontabile col feed BCM." -ForegroundColor Green
    Write-Host "PROMEMORIA: parametri CONGELATI. Qui non si ottimizza niente." -ForegroundColor Green
  }
}

function Raccogli-SulDesktop {
  # regola delle righe di lancio: il risultato arriva SEMPRE pronto da mandare
  $dest = Join-Path ([Environment]::GetFolderPath("Desktop")) "import_esterno"
  New-Item -ItemType Directory -Force -Path $dest | Out-Null
  if (Test-Path $Referto) { Copy-Item $Referto $dest -Force -ErrorAction SilentlyContinue }
  $logDir = Join-Path $DataFolder "MQL5\Logs"
  if (Test-Path $logDir) {
    Get-ChildItem $logDir -Filter "*.log" -ErrorAction SilentlyContinue |
      Sort-Object LastWriteTime -Descending | Select-Object -First 2 |
      ForEach-Object { Copy-Item $_.FullName $dest -Force -ErrorAction SilentlyContinue }
  }
  $zip = Join-Path ([Environment]::GetFolderPath("Desktop")) "import_esterno.zip"
  Compress-Archive -Path (Join-Path $dest "*") -DestinationPath $zip -Force
  $n = (Get-ChildItem $dest -File -ErrorAction SilentlyContinue | Measure-Object).Count
  Write-Host ""
  Write-Host ("RACCOLTA: {0} file in {1}" -f $n, $dest) -ForegroundColor Green
  Write-Host ("ZIP PRONTO DA MANDARE: {0}" -f $zip) -ForegroundColor Green
  Write-Host "Attesi dentro: ABTG_ImportEsterno_referto.csv + gli ultimi 2 log di MT5." -ForegroundColor DarkGray
}

if ($SoloReferto) { Mostra-Referto; Raccogli-SulDesktop; exit 0 }

Write-Host "=== IMPORT STORICO ESTERNO ===" -ForegroundColor Cyan
Write-Host ("  simboli:   " + ($Lista -join ", ")) -ForegroundColor White
Write-Host ("  anni:      {0} - {1}" -f $Da, $A) -ForegroundColor White
Write-Host ("  zip in:    " + $CartellaZip) -ForegroundColor White
Write-Host ("  MT5:       " + $DataFolder) -ForegroundColor DarkGray
Write-Host ""
Write-Host "REGOLA D'USO: i simboli _EXT sono PROVA DI REGIME a parametri" -ForegroundColor Yellow
Write-Host "CONGELATI. Qui non si ottimizza nulla: la taratura resta su BCM." -ForegroundColor Yellow

# ---------------------------------------------------------------------
# 2. DOWNLOAD (strada A: automatico da HistData)
# ---------------------------------------------------------------------
#  HistData non espone un link diretto: il bottone DOWNLOAD e' un form
#  che fa POST a get.php con un token 'tk' generato nella pagina, e il
#  server rifiuta la richiesta senza Referer. Qui si prova; se non
#  funziona NON si insiste (il sito cambia spesso) e si passa alla
#  strada B, che e' documentata riga per riga.
# ---------------------------------------------------------------------
function Nome-Zip($sym, $anno) { return ("HISTDATA_COM_ASCII_{0}_M1_{1}.zip" -f $sym, $anno) }

function Prova-Download($sym, $anno, $destZip) {
  $pagina = "https://www.histdata.com/download-free-forex-historical-data/?/ascii/1-minute-bar-quotes/" + $sym.ToLower() + "/" + $anno
  try {
    $sess = $null
    $r = Invoke-WebRequest -Uri $pagina -SessionVariable sess -UseBasicParsing -TimeoutSec 60
    $tk = [regex]::Match($r.Content, 'id="tk"[^>]*value="([^"]+)"').Groups[1].Value
    if (-not $tk) { $tk = [regex]::Match($r.Content, 'name="tk"[^>]*value="([^"]+)"').Groups[1].Value }
    if (-not $tk) { return $false }
    $body = @{
      tk        = $tk
      date      = "$anno"
      datemonth = "$anno"
      platform  = "ASCII"
      timeframe = "M1"
      fxpair    = $sym.ToUpper()
    }
    $hdr = @{ Referer = $pagina; "User-Agent" = "Mozilla/5.0" }
    Invoke-WebRequest -Uri "https://www.histdata.com/get.php" -Method Post -Body $body `
                      -WebSession $sess -Headers $hdr -OutFile $destZip -UseBasicParsing -TimeoutSec 600
    # verifica che sia davvero uno ZIP: se il sito risponde HTML, il file
    # esiste lo stesso e piu' avanti Expand-Archive morirebbe
    if (-not (Test-Path $destZip)) { return $false }
    $fs = [System.IO.File]::OpenRead($destZip)
    $b1 = $fs.ReadByte(); $b2 = $fs.ReadByte(); $fs.Close()
    if ($b1 -ne 0x50 -or $b2 -ne 0x4B) { Remove-Item $destZip -Force -ErrorAction SilentlyContinue; return $false }
    if ((Get-Item $destZip).Length -lt 50000) { Remove-Item $destZip -Force -ErrorAction SilentlyContinue; return $false }
    return $true
  } catch {
    if (Test-Path $destZip) { Remove-Item $destZip -Force -ErrorAction SilentlyContinue }
    return $false
  }
}

$mancanti = @()
foreach ($sym in $Lista) {
  for ($y = $Da; $y -le $A; $y++) {
    $zipName = Nome-Zip $sym $y
    $zipPath = Join-Path $CartellaZip $zipName
    if (Test-Path $zipPath) { Write-Host ("  gia' presente: " + $zipName) -ForegroundColor DarkGray; continue }
    if ($SaltaDownload)     { $mancanti += ,@($sym, $y, $zipName); continue }
    Write-Host ("  scarico " + $zipName + " ...") -ForegroundColor DarkGray
    if (Prova-Download $sym $y $zipPath) {
      Write-Host ("  OK  " + $zipName) -ForegroundColor Green
    } else {
      Write-Host ("  automatico fallito: " + $zipName) -ForegroundColor Yellow
      $mancanti += ,@($sym, $y, $zipName)
    }
  }
}

# ---------------------------------------------------------------------
# 3. STRADA B: fallback manuale, detto per esteso
# ---------------------------------------------------------------------
if ($mancanti.Count -gt 0) {
  Write-Host ""
  Write-Host "--- SCARICA A MANO QUESTI FILE (5 minuti) --------------------" -ForegroundColor Yellow
  Write-Host "Per ognuno: apri il link, premi il bottone DOWNLOAD, e salva lo" -ForegroundColor Yellow
  Write-Host "ZIP - SENZA rinominarlo - dentro questa cartella:" -ForegroundColor Yellow
  Write-Host ("   " + $CartellaZip) -ForegroundColor White
  Write-Host ""
  foreach ($m in $mancanti) {
    $s = $m[0]; $y = $m[1]; $f = $m[2]
    $link = "https://www.histdata.com/download-free-forex-historical-data/?/ascii/1-minute-bar-quotes/" + $s.ToLower() + "/" + $y
    Write-Host ("   " + $f) -ForegroundColor White
    Write-Host ("      " + $link) -ForegroundColor DarkGray
  }
  Write-Host ""
  Write-Host "Poi rilancia la STESSA riga aggiungendo -SaltaDownload:" -ForegroundColor Yellow
  Write-Host ("   powershell -ExecutionPolicy Bypass -File " + '"$env:USERPROFILE\importa_storico_esterno.ps1"' + " -Simboli " + '"' + ($Lista -join ",") + '"' + " -Da $Da -A $A -SaltaDownload -Auto") -ForegroundColor White
  Write-Host "--------------------------------------------------------------" -ForegroundColor Yellow
  $presenti = @(Get-ChildItem $CartellaZip -Filter "*.zip" -ErrorAction SilentlyContinue)
  if ($presenti.Count -eq 0) {
    Write-Host "Nessuno ZIP disponibile: mi fermo qui." -ForegroundColor Red
    exit 1
  }
  Write-Host ("Procedo con i " + $presenti.Count + " ZIP gia' presenti.") -ForegroundColor Cyan
}

# ---------------------------------------------------------------------
# 4. decompressione + concatenazione per simbolo
# ---------------------------------------------------------------------
#  HistData mette dentro lo ZIP un file DAT_ASCII_<SYM>_M1_<ANNO>.csv.
#  Si concatenano in ordine di anno: cosi' il file arriva gia' ordinato
#  e lo script MQL5 non deve riordinare due milioni di righe.
# ---------------------------------------------------------------------
$Estratti = Join-Path $Work "estratti"
New-Item -ItemType Directory -Force -Path $Estratti | Out-Null

$daImportare = @()
foreach ($sym in $Lista) {
  $dirSym = Join-Path $Estratti $sym
  if (Test-Path $dirSym) { Remove-Item $dirSym -Recurse -Force -ErrorAction SilentlyContinue }
  New-Item -ItemType Directory -Force -Path $dirSym | Out-Null

  $anni = @()
  for ($y = $Da; $y -le $A; $y++) {
    $zipPath = Join-Path $CartellaZip (Nome-Zip $sym $y)
    if (-not (Test-Path $zipPath)) { continue }
    try {
      Expand-Archive -Path $zipPath -DestinationPath $dirSym -Force
      $anni += $y
    } catch {
      Write-Host ("  ZIP illeggibile (riscaricalo): " + (Nome-Zip $sym $y)) -ForegroundColor Red
    }
  }
  if ($anni.Count -eq 0) { Write-Host ("  " + $sym + ": nessun anno disponibile, salto.") -ForegroundColor Yellow; continue }

  $out = Join-Path $Work ($sym + "_M1.csv")
  if (Test-Path $out) { Remove-Item $out -Force }
  $sw = New-Object System.IO.StreamWriter($out, $false, [System.Text.Encoding]::ASCII)
  $tot = 0
  foreach ($y in ($anni | Sort-Object)) {
    $csv = Get-ChildItem $dirSym -Filter ("*" + $sym + "_M1_" + $y + "*.csv") -ErrorAction SilentlyContinue | Select-Object -First 1
    if (-not $csv) { $csv = Get-ChildItem $dirSym -Filter ("*_M1_" + $y + "*.csv") -ErrorAction SilentlyContinue | Select-Object -First 1 }
    if (-not $csv) { Write-Host ("  " + $sym + " " + $y + ": CSV non trovato dentro lo ZIP") -ForegroundColor Yellow; continue }
    $sr = New-Object System.IO.StreamReader($csv.FullName)
    while (($riga = $sr.ReadLine()) -ne $null) {
      if ($riga.Length -lt 10) { continue }
      $sw.WriteLine($riga); $tot++
    }
    $sr.Close()
    Write-Host ("  " + $sym + " " + $y + ": " + $csv.Name) -ForegroundColor DarkGray
  }
  $sw.Close()
  Write-Host ("  " + $sym + ": " + $tot + " righe M1 in " + (Split-Path -Leaf $out)) -ForegroundColor Green
  if ($tot -gt 2000000) {
    # ordine di grandezza misurato a tavolino: una MqlRates pesa ~60 byte,
    # quindi 2,6 milioni di barre (7 anni di forex M1) sono ~160 MB di RAM
    # dentro MT5, piu' il tempo di lettura. Non e' un errore, ma se il
    # terminale si pianta e' questo: si spezza in due lanci per anni.
    Write-Host ("  ATTENZIONE: " + $tot + " barre = circa " + [int]($tot * 60 / 1MB) + " MB di RAM dentro MT5.") -ForegroundColor Yellow
    Write-Host "  Se MT5 non risponde, rifai in due passate con meno anni per volta." -ForegroundColor Yellow
  }

  Copy-Item $out $FilesDir -Force
  $daImportare += ,@($sym, ($sym + "_M1.csv"), ($anni | Sort-Object | Select-Object -First 1), ($anni | Sort-Object | Select-Object -Last 1))
}

if ($daImportare.Count -eq 0) { Write-Host "Niente da importare." -ForegroundColor Red; exit 1 }

# ---------------------------------------------------------------------
# 5. installa + compila lo script MQL5
# ---------------------------------------------------------------------
$Locale = Join-Path $RepoRoot "..\mql5\Scripts\ABTG_ImportaStoricoEsterno.mq5"
if (Test-Path $Locale) {
  $Src = $Locale
  Write-Host "  sorgente:  repo locale" -ForegroundColor DarkGray
} else {
  $Src = Join-Path $Work "ABTG_ImportaStoricoEsterno.mq5"
  try {
    Invoke-WebRequest -Uri "$RawBase/mql5/Scripts/ABTG_ImportaStoricoEsterno.mq5" -OutFile $Src -UseBasicParsing
    Write-Host "  sorgente:  scaricato da GitHub ($EABranch)" -ForegroundColor DarkGray
  } catch {
    Write-Host "ERRORE: non riesco a scaricare ABTG_ImportaStoricoEsterno.mq5 da GitHub." -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
    exit 1
  }
}
$DstDir = Join-Path $DataFolder "MQL5\Scripts"
New-Item -ItemType Directory -Force -Path $DstDir | Out-Null
Copy-Item $Src -Destination $DstDir -Force
$mq5 = Join-Path $DstDir "ABTG_ImportaStoricoEsterno.mq5"
& $MetaEditor "/compile:$mq5" "/log" | Out-Null
$ex5 = [System.IO.Path]::ChangeExtension($mq5, ".ex5")
if (-not (Test-Path $ex5)) { Write-Host "ERRORE di compilazione (vedi il .log accanto al .mq5)." -ForegroundColor Red; exit 1 }
Write-Host "  compilato: ABTG_ImportaStoricoEsterno.ex5" -ForegroundColor Green

# ---------------------------------------------------------------------
# 6. un preset .set per simbolo
# ---------------------------------------------------------------------
$PresetDir = Join-Path $DataFolder "MQL5\Presets"
New-Item -ItemType Directory -Force -Path $PresetDir | Out-Null
$autoShift = if ($NoAutoShift) { "false" } else { "true" }
$presets = @()
foreach ($d in $daImportare) {
  $sym = $d[0]; $csv = $d[1]
  $setName = "abtg_import_" + $sym + ".set"
  $setFile = Join-Path $PresetDir $setName
  $testo = "InpSimboloSorgente=" + $sym + "`r`n" +
           "InpSimboloNuovo=" + $sym + "_EXT`r`n" +
           "InpFileCsv=" + $csv + "`r`n" +
           "InpFormato=" + $Formato + "`r`n" +
           "InpShiftOre=" + $ShiftOre + "`r`n" +
           "InpAutoShift=" + $autoShift + "`r`n" +
           "InpShiftMax=6`r`n" +
           "InpCancellaEsistente=true`r`n"
  Set-Content -Path $setFile -Value $testo -Encoding ASCII
  $presets += ,@($sym, $setName)
  Write-Host ("  preset:    MQL5\Presets\" + $setName) -ForegroundColor Green
}

# ---------------------------------------------------------------------
# 7a. modalita' MANUALE (default, e l'unica ammessa sul VPS)
# ---------------------------------------------------------------------
if (-not $Auto) {
  Write-Host ""
  Write-Host "--- ORA IN MT5 (uno per simbolo) -----------------------------" -ForegroundColor Yellow
  Write-Host " 1. Strumenti > Opzioni > Grafici > Max barre nel grafico = ILLIMITATO" -ForegroundColor Yellow
  Write-Host " 2. Navigatore > Script > tasto destro > Aggiorna" -ForegroundColor Yellow
  Write-Host " 3. Trascina ABTG_ImportaStoricoEsterno su un grafico qualsiasi" -ForegroundColor Yellow
  Write-Host " 4. Nella finestra parametri: Carica > il preset del simbolo:" -ForegroundColor Yellow
  foreach ($p in $presets) { Write-Host ("      " + $p[1]) -ForegroundColor White }
  Write-Host " 5. OK, e guarda la scheda ESPERTI: ci trovi la tabella degli" -ForegroundColor Yellow
  Write-Host "    shift e il confronto delle proprieta'. Ripeti per ogni simbolo." -ForegroundColor Yellow
  Write-Host " 6. Poi torna qui e lancia:" -ForegroundColor Yellow
  Write-Host ("      powershell -ExecutionPolicy Bypass -File " + '"$env:USERPROFILE\importa_storico_esterno.ps1"' + " -SoloReferto") -ForegroundColor White
  Write-Host "--------------------------------------------------------------" -ForegroundColor Yellow
  Mostra-Referto
  exit 0
}

# ---------------------------------------------------------------------
# 7b. modalita' AUTOMATICA (solo PC di backtest, MT5 chiuso)
# ---------------------------------------------------------------------
$running = Get-Process -Name "terminal64" -ErrorAction SilentlyContinue
if ($running -and $ChiudiMT5) {
  Write-Host ""
  Write-Host "MT5 e' aperto: lo chiudo (-ChiudiMT5)." -ForegroundColor Yellow
  $running | Stop-Process -Force -ErrorAction SilentlyContinue
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

if (Test-Path $Referto) { Remove-Item $Referto -Force }   # cosi' so che il referto e' nuovo

$attese = 0
foreach ($p in $presets) {
  $sym = $p[0]; $setName = $p[1]
  Write-Host ""
  Write-Host ("=== IMPORTO " + $sym + " -> " + $sym + "_EXT ===") -ForegroundColor Cyan

  $Ini = Join-Path $env:TEMP ("abtg_import_" + $sym + ".ini")
  $iniTesto = "[Charts]`r`n" +
              "MaxBars=2000000000`r`n`r`n" +
              "[StartUp]`r`n" +
              "Script=ABTG_ImportaStoricoEsterno`r`n" +
              "ScriptParameters=" + $setName + "`r`n" +
              "Symbol=" + $sym + "`r`n" +
              "Period=M5`r`n"
  Set-Content -Path $Ini -Value $iniTesto -Encoding Unicode

  Start-Process -FilePath $Terminal -ArgumentList "/config:$Ini"

  # attesa: si guarda SOLO il numero di righe del referto (una per simbolo).
  # Mai leggere il contenuto mentre MT5 scrive: il file e' in uso.
  $ErrorActionPreference = "Continue"
  $scaduto = (Get-Date).AddMinutes($TimeoutMin)
  $fatto = $false
  while ((Get-Date) -lt $scaduto) {
    Start-Sleep -Seconds 10
    if (-not (Test-Path $Referto)) { continue }
    $righe = Leggi-Referto
    if ($righe -and (@($righe).Count -gt $attese)) { $fatto = $true; break }
  }
  $ErrorActionPreference = "Stop"

  Get-Process -Name "terminal64" -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
  Start-Sleep -Seconds 3

  if ($fatto) {
    $attese++
    Write-Host ("  " + $sym + ": import completato.") -ForegroundColor Green
  } else {
    Write-Host ("  " + $sym + ": TIMEOUT, nessuna riga di referto.") -ForegroundColor Red
    Write-Host "  Guarda MQL5\Logs: di solito e' il CSV che non e' in MQL5\Files." -ForegroundColor Red
  }
}

Mostra-Referto
Raccogli-SulDesktop

Write-Host ""
Write-Host "=== PROSSIMO PASSO ===" -ForegroundColor Cyan
Write-Host "Walk-forward SUI SIMBOLI _EXT, a parametri CONGELATI, modello OHLC M1:" -ForegroundColor White
foreach ($p in $presets) {
  Write-Host ("  .\walkforward_generico.ps1 -Expert <EA> -Simbolo " + $p[0] + "_EXT -DaQuando " + $Da + ".01.01 -Fino " + $A + ".12.31 -Modello 1") -ForegroundColor White
}
Write-Host "Il modello 4 (tick reali) NON si usa: su un simbolo costruito da" -ForegroundColor Yellow
Write-Host "barre M1 i tick reali non esistono." -ForegroundColor Yellow
Write-Host "E ricorda: qui si RISPONDE a 'regge nell'orso?', non si TARA nulla." -ForegroundColor Yellow
