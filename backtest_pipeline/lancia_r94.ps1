# =====================================================================
#  lancia_r94.ps1 -- R94: LA GEOMETRIA DELLE BANDE SUL BREAKING BAND
#                    (Bollinger 37/1.4 del Point Break, fattoriale 2x2)
# ---------------------------------------------------------------------
#  FIRMATO da Claudio il 21/08/2026, PRIMA dei numeri:
#    "metro,frequenza, firmo r93, r94 lancia, e prepara jpy"
#  Criteri: backtest_pipeline\risultati_archivio\R94_CRITERI.md
#
#  LA DOMANDA DEL ROUND NON E' "QUANTO RENDE".
#  La famiglia gira su n OOS di 11 / 13 / 26: il MERITO E' SOSPESO per
#  dichiarazione. R94 chiede una cosa sola: LA FREQUENZA SALE?
#  Se non sale, il profitto non si guarda nemmeno.
#
#  IL DISEGNO -- 6 file prova, 12 celle, 24 passate:
#    per ogni simbolo due file gemelli, P20 e P37. Dentro un file si
#    muove UNA variabile sola (la deviazione 1.4 / 2.0); fra i due file
#    se ne muove un'altra sola (il periodo 20 / 37). I quattro incroci
#    formano il 2x2:
#      P20 dev 2.0 = BASE ATTUALE (canarino)  P20 dev 1.4 = solo deviazione
#      P37 dev 2.0 = solo periodo             P37 dev 1.4 = LA CELLA DEL CORSO
#
#  COSA FA QUESTO SCRIPT, IN ORDINE:
#    1. guardia MT5 aperto e guardia del modello
#    2. scarica gli attrezzi e ne verifica i MARCATORI di versione
#    3. difetto 33: verifica che NON esista un secondo artefatto che
#       descrive le stesse celle (qui il file prova e' l'unico, e la
#       verifica e' attiva: se un giorno qualcuno mette una griglia
#       dentro il driver, questo script muore invece di misurare
#       silenziosamente un'altra cosa)
#    4. difetto 33-bis: legge gli #include del .mq5 e LI INSTALLA lui,
#       verificando lunghezza e marcatore. Il driver scarica solo il
#       .mq5 e poi compila: senza include la compilazione fallisce con
#       "undeclared identifier" a corsa avviata
#    5. pulisce le serie per-trade e le anteprime VECCHIE (difetto 14)
#    6. lancia le 6 celle, una alla volta, controllando LASTEXITCODE
#    7. raccoglie sul Desktop, porta via anche i LOG DEGLI AGENT del
#       tester (li' c'e' il funnel [BB-FUNNEL], che dice se i setup
#       sono diminuiti o se sono stati scartati alla porta) e fa lo zip
#
#  IL PIN NON COPRE L'EA (difetto 24): walkforward_generico.ps1 ha
#  EABranch="lavoro" SCRITTO FISSO alla riga 91 e riscarica il .mq5 da
#  lavoro HEAD ignorando -Rif; se il download fallisce ripiega IN
#  SILENZIO sulla copia locale. Percio' qui NON si usa un SHA: si usa
#  il branch CONGELATO (nessun push su lavoro mentre R94 gira) piu' i
#  marcatori di versione. Un SHA pinnerebbe gli script e NON il motore.
#
#  MARCATORE VERSIONE: R94-LANCIO-v2
#  (v2 = correzioni della verifica del 21/08: cache del tester svuotata,
#   compilazione che aspetta l'artefatto, tre radici per i log, per-trade
#   ripuliti dentro il ciclo, sorgente confrontato per hash a ogni cella)
# =====================================================================
param(
  [string]$Rif      = "lavoro",
  [string]$Cartella = (Join-Path $env:USERPROFILE "r94"),
  [int]$Deposito    = 100000,
  [int]$Modello     = 4,
  [string]$Solo     = "",
  [switch]$Rifai,
  [switch]$SoloControllo
)
$ErrorActionPreference = "Stop"
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$Raw      = "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$Rif"
$DaQuando = "2024.09.26"
$Fino     = "2026.06.30"
$Marcatore = "R94 -- BOLLINGER 37/1.4 SUL BREAKING BAND"
$EA       = "ABTG_BreakingBand"

function Titolo($t) { Write-Host ""; Write-Host $t -ForegroundColor Cyan }
function Muori($t)  { Write-Host ""; Write-Host "!!! $t" -ForegroundColor Red; exit 1 }

function Trova-Desktop {
  $c = @()
  try { $c += [Environment]::GetFolderPath("Desktop") } catch {}
  $c += (Join-Path $env:USERPROFILE "Desktop")
  $c += (Join-Path $env:USERPROFILE "OneDrive\Desktop")
  foreach ($d in $c) { if ($d -and (Test-Path $d)) { return $d } }
  return $env:USERPROFILE
}

Write-Host "=== R94 - GEOMETRIA DELLE BANDE SUL BREAKING BAND (Bollinger 37/1.4) ===" -ForegroundColor Cyan
Write-Host ("MACCHINA: " + $env:COMPUTERNAME + "   utente: " + $env:USERNAME) -ForegroundColor Cyan
Write-Host ("riferimento: " + $Rif) -ForegroundColor DarkGray
Write-Host ("data       : " + (Get-Date -Format "yyyy-MM-dd HH:mm")) -ForegroundColor DarkGray
Write-Host ("finestra   : " + $DaQuando + " -> " + $Fino + "  (identica a R33/R34/R91)") -ForegroundColor DarkGray
Write-Host ""
Write-Host "  LA DOMANDA E' LA FREQUENZA, NON IL PROFITTO. Con n OOS 11/13/26 il" -ForegroundColor Yellow
Write-Host "  merito e' SOSPESO per dichiarazione: da questo round non esce nessuna" -ForegroundColor Yellow
Write-Host "  promozione, in nessun caso." -ForegroundColor Yellow

if (Get-Process -Name "terminal64" -ErrorAction SilentlyContinue) {
  Muori ("MetaTrader e' APERTO. Chiudilo prima di lanciare, altrimenti escono 0 CSV." + "`n" +
         "    (e se sul PC sta girando un altro lavoro - R92, R93, Dukascopy -" + "`n" +
         "     aspetta che finisca: c'e' un solo MT5)")
}

if ($Modello -ne 4) {
  Write-Host ""
  Write-Host "  ATTENZIONE: modello diverso da 4 (tick reali)." -ForegroundColor Yellow
  Write-Host "  La base R34 con cui si confronta il canarino e' a TICK REALI: con un" -ForegroundColor Yellow
  Write-Host "  altro modello il canarino NON puo' tornare, e senza canarino nessun" -ForegroundColor Yellow
  Write-Host "  numero di R94 ha un termine di paragone." -ForegroundColor Yellow
}

# =====================================================================
#  LE 6 CELLE (= 6 file prova). Una variabile alla volta, sempre.
#    K    = etichetta corta, quella che si usa con -Solo
#    Tag  = suffisso nel nome del CSV: un round nuovo non sovrascrive mai
#    Base = questo file contiene il CANARINO (la cella 20 / 2.0)?
# =====================================================================
$celle = @(
  @{ K="A20"; Sym="GBPUSD"; Per=20; Tag="r94a20"; File="R94a_bb_GBPUSD_p20.txt"; Patt="2 (CONT+INV)"; Base=$true;  Cosa="GBPUSD periodo 20 - dev 1.4 vs 2.0 (QUI IL CANARINO)" },
  @{ K="A37"; Sym="GBPUSD"; Per=37; Tag="r94a37"; File="R94a_bb_GBPUSD_p37.txt"; Patt="2 (CONT+INV)"; Base=$false; Cosa="GBPUSD periodo 37 - dev 1.4 vs 2.0" },
  @{ K="B20"; Sym="EURUSD"; Per=20; Tag="r94b20"; File="R94b_bb_EURUSD_p20.txt"; Patt="0 (solo CONT)"; Base=$true;  Cosa="EURUSD periodo 20 - dev 1.4 vs 2.0 (QUI IL CANARINO)" },
  @{ K="B37"; Sym="EURUSD"; Per=37; Tag="r94b37"; File="R94b_bb_EURUSD_p37.txt"; Patt="0 (solo CONT)"; Base=$false; Cosa="EURUSD periodo 37 - dev 1.4 vs 2.0" },
  @{ K="C20"; Sym="AUDUSD"; Per=20; Tag="r94c20"; File="R94c_bb_AUDUSD_p20.txt"; Patt="1 (solo INV)";  Base=$true;  Cosa="AUDUSD periodo 20 - dev 1.4 vs 2.0 (QUI IL CANARINO)" },
  @{ K="C37"; Sym="AUDUSD"; Per=37; Tag="r94c37"; File="R94c_bb_AUDUSD_p37.txt"; Patt="1 (solo INV)";  Base=$false; Cosa="AUDUSD periodo 37 - dev 1.4 vs 2.0" }
)

if ($Solo -ne "") {
  $scelti = @()
  foreach ($s in ($Solo -split ",")) { $scelti += $s.Trim().ToUpper() }
  $celle = @($celle | Where-Object { $scelti -contains $_.K })
  if ($celle.Count -eq 0) { Muori "il filtro -Solo '$Solo' non seleziona nessuna cella." }
  Write-Host ("  -Solo attivo: " + ($scelti -join ", ")) -ForegroundColor Yellow
  Write-Host "  ATTENZIONE: con -Solo il round e' PARZIALE. Se resta fuori una cella" -ForegroundColor Yellow
  Write-Host "  di canarino, i numeri delle altre non hanno termine di paragone." -ForegroundColor Yellow
}

$passateAttese = $celle.Count * 2 * 2   # 2 celle di deviazione x 2 finestre
Write-Host ("  file prova in coda: " + $celle.Count + "  ->  celle " + ($celle.Count * 2) + "  ->  passate " + $passateAttese) -ForegroundColor White

$desk = Trova-Desktop

# =====================================================================
#  1. ATTREZZI (riscaricati sempre, mai la copia vecchia)
# =====================================================================
Titolo "1) attrezzi (riscaricati sempre, da $Rif)"
New-Item -ItemType Directory -Force -Path $Cartella | Out-Null
$Prove = Join-Path $Cartella "prove"
New-Item -ItemType Directory -Force -Path $Prove | Out-Null

$file = @{}
$file["walkforward_generico.ps1"] = "$Raw/backtest_pipeline/walkforward_generico.ps1"
$file["R94_CRITERI.md"]           = "$Raw/backtest_pipeline/risultati_archivio/R94_CRITERI.md"
foreach ($c in $celle) { $file["prove\" + $c.File] = "$Raw/backtest_pipeline/prove/" + $c.File }

foreach ($k in $file.Keys) {
  $dest = Join-Path $Cartella $k
  Remove-Item -LiteralPath $dest -Force -ErrorAction SilentlyContinue
  try {
    Invoke-WebRequest -Uri $file[$k] -OutFile $dest -UseBasicParsing -ErrorAction Stop
    Write-Host ("    ok  " + $k) -ForegroundColor Green
  } catch {
    Muori ("non sono riuscito a scaricare " + $k + " da " + $Rif + "`n    " + $_.Exception.Message)
  }
}

# --- controllo di versione: la cache di raw.githubusercontent tiene ~5
#     minuti. Ogni file prova deve contenere il marcatore del round.
foreach ($c in $celle) {
  $p = Join-Path $Prove $c.File
  if (-not (Select-String -Path $p -SimpleMatch -Pattern $Marcatore -Quiet)) {
    Muori ("il file prova " + $c.File + " non contiene il marcatore R94: e' una copia vecchia o sbagliata." + "`n" +
           "    La cache di raw tiene ~5 minuti: aspetta e rilancia.")
  }
}
$wf = Join-Path $Cartella "walkforward_generico.ps1"
if (-not (Select-String -Path $wf -SimpleMatch -Pattern "WALK-FORWARD GENERICO" -Quiet)) {
  Muori "walkforward_generico.ps1 scaricato non e' quello giusto (manca il marcatore)."
}

Write-Host ""
Write-Host ("    -Rif " + $Rif + ": il branch va CONGELATO per tutta la durata del round.") -ForegroundColor Yellow
Write-Host "    (il driver riscarica l'EA da 'lavoro' HEAD a ogni cella: un push a meta'" -ForegroundColor Yellow
Write-Host "     corsa cambierebbe il motore FRA UNA CELLA E L'ALTRA)" -ForegroundColor Yellow

# =====================================================================
#  1-bis. DIFETTO 33: due artefatti che descrivono la stessa cella.
#  Qui l'artefatto e' UNO SOLO (il file prova) perche' walkforward_
#  generico.ps1 non ha blocchi per-EA come scan_market.ps1. Ma non lo
#  si DICHIARA: lo si VERIFICA, cosi' se un giorno qualcuno aggiunge
#  una griglia dentro il driver questo script muore invece di misurare
#  in silenzio un'altra cosa. Il gate e' sullo STATO FINALE del file.
# =====================================================================
Titolo "1-bis) difetto 33: c'e' un solo artefatto che descrive le celle?"
$sospetti = @(Select-String -Path $wf -Pattern ('"' + $EA + '"') -SimpleMatch)
if ($sospetti.Count -gt 0) {
  Write-Host ""
  foreach ($s in $sospetti) { Write-Host ("      riga " + $s.LineNumber + ": " + $s.Line.Trim()) -ForegroundColor Red }
  Muori ("walkforward_generico.ps1 NOMINA " + $EA + " al suo interno." + "`n" +
         "    Se contiene una griglia per questo EA, gira QUELLA e non il file prova:" + "`n" +
         "    e' il difetto 33 (il giro a vuoto validerebbe l'artefatto che non gira)." + "`n" +
         "    Leggi le righe qui sopra e decidi PRIMA di lanciare.")
}
Write-Host ("    ok  il driver non nomina " + $EA + ": il file prova e' l'unica descrizione delle celle") -ForegroundColor Green
Write-Host "    ok  il giro a vuoto (-SoloControllo) legge lo STESSO file della corsa vera" -ForegroundColor Green

# =====================================================================
#  2. LA CARTELLA DATI DI MT5
# =====================================================================
Titolo "2) il terminale e la sua cartella dati"
$allTerm = Get-ChildItem "C:\Program Files","C:\Program Files (x86)" -Recurse -Filter "terminal64.exe" -ErrorAction SilentlyContinue
$cand = $allTerm | Where-Object { $_.DirectoryName -like "*BCM Markets MT5 Terminal*" -and $_.DirectoryName -notlike "*-V3*" } | Select-Object -First 1
if (-not $cand) { $cand = $allTerm | Where-Object { $_.DirectoryName -like "*BCM Markets*" } | Select-Object -First 1 }
if (-not $cand) { Muori "terminale BCM non trovato." }
$instDir = $cand.DirectoryName
$termRoot = Join-Path $env:APPDATA "MetaQuotes\Terminal"
$DataFolder = Get-ChildItem $termRoot -Directory -ErrorAction SilentlyContinue | Where-Object {
  $o = Join-Path $_.FullName "origin.txt"
  (Test-Path $o) -and ((Get-Content $o -Raw).Trim() -ieq $instDir)
} | Select-Object -First 1 -ExpandProperty FullName
if (-not $DataFolder) { Muori "cartella dati MT5 non trovata." }
Write-Host ("    cartella dati MT5: " + $DataFolder) -ForegroundColor DarkGray
$Common = Join-Path $env:APPDATA "MetaQuotes\Terminal\Common\Files"

# =====================================================================
#  3. DIFETTO 33-bis: GLI #include DELL'EA, INSTALLATI DA QUI
#  walkforward_generico.ps1 scarica SOLO il .mq5 e poi compila. Se un
#  include manca (o e' vecchio di una versione) il sintomo NON e' "il
#  file non c'e'": e' "undeclared identifier" dentro il driver, che
#  stampa ERRORE compilazione ed esce 1 -- e la raccolta partirebbe su
#  zero CSV. Qui gli include si LEGGONO dal sorgente, non si indovinano.
# =====================================================================
Titolo "3) gli #include del sorgente: letti dal .mq5 e installati"
$srcEA = Join-Path $Cartella ($EA + ".mq5")
Remove-Item -LiteralPath $srcEA -Force -ErrorAction SilentlyContinue
try {
  Invoke-WebRequest -Uri "$Raw/mql5/Experts/$EA.mq5" -OutFile $srcEA -UseBasicParsing -ErrorAction Stop
} catch {
  Muori ("non sono riuscito a scaricare " + $EA + ".mq5: " + $_.Exception.Message)
}
$IncDir = Join-Path $DataFolder "MQL5\Include"
New-Item -ItemType Directory -Force -Path $IncDir | Out-Null

$inclusi = @()
foreach ($r in (Select-String -Path $srcEA -Pattern '^\s*#include\s*<([^>]+)>')) {
  $nome = $r.Matches[0].Groups[1].Value
  if ($nome -like "Trade/*" -or $nome -like "Trade\*" -or $nome -notlike "ABTG*") { continue }
  $inclusi += $nome
}
$inclusi = @($inclusi | Select-Object -Unique)
if ($inclusi.Count -eq 0) {
  Write-Host "    il sorgente non ha include ABTG: niente da installare" -ForegroundColor DarkGray
}
foreach ($inc in $inclusi) {
  $tmp = Join-Path $Cartella ($inc -replace "[\\/]", "_")
  Remove-Item -LiteralPath $tmp -Force -ErrorAction SilentlyContinue
  try {
    Invoke-WebRequest -Uri ("$Raw/mql5/Include/" + ($inc -replace "\\", "/")) -OutFile $tmp -UseBasicParsing -ErrorAction Stop
  } catch {
    Muori ("l'EA include <" + $inc + "> ma non sono riuscito a scaricarlo: " + $_.Exception.Message)
  }
  $len = (Get-Item -LiteralPath $tmp).Length
  $dst = Join-Path $IncDir $inc
  New-Item -ItemType Directory -Force -Path (Split-Path -Parent $dst) | Out-Null
  Copy-Item -LiteralPath $tmp -Destination $dst -Force -ErrorAction Stop
  # verifica sul CONTENUTO, non con Test-Path: se in $dst ci fosse una
  # cartella con lo stesso nome, Copy-Item ci metterebbe il file DENTRO
  # e Test-Path direbbe di si'.
  $v = Get-Item -LiteralPath $dst -ErrorAction Stop
  if ($v.PSIsContainer -or $v.Length -ne $len) { Muori ($inc + ": copia NON verificata.") }
  Write-Host ("    ok  MQL5\Include\" + $inc + " (" + $len + " byte)") -ForegroundColor Green
}
# marcatore della versione giusta dell'include del Guardian
$gDst = Join-Path $IncDir "ABTG_PausaGuardian.mqh"
if (Test-Path -LiteralPath $gDst) {
  if (-not (Select-String -Path $gDst -SimpleMatch -Pattern "ABTG_GuardiaIngresso" -Quiet)) {
    Muori "ABTG_PausaGuardian.mqh installato ma non contiene ABTG_GuardiaIngresso: versione sbagliata."
  }
  Write-Host "    ok  marcatore ABTG_GuardiaIngresso presente" -ForegroundColor Green
}

# =====================================================================
#  3-bis. LA COMPILAZIONE, FATTA QUI E NON A CORSA AVVIATA
#  walkforward_generico.ps1 compila alla riga 603, ma -SoloControllo
#  ESCE alla riga 503: cioe' IL GIRO A VUOTO NON COMPILA. Un include
#  mancante o vecchio di una versione non si vedrebbe nel giro a vuoto
#  e salterebbe fuori a corsa avviata, come "undeclared identifier"
#  dentro il driver (difetto 33-bis). Qui si compila SUBITO, anche in
#  -SoloControllo: costa dieci secondi e copre il buco.
#  Niente F7 a mano su un file che sulla macchina di Claudio potrebbe
#  non esserci ancora (punto 20 della checklist).
# =====================================================================
Titolo "3-bis) compilazione di controllo (vale anche nel giro a vuoto)"
$MetaEditor = Join-Path $instDir "metaeditor64.exe"
if (-not (Test-Path -LiteralPath $MetaEditor)) { Muori ("metaeditor64.exe non trovato in " + $instDir) }
$MqlExperts = Join-Path $DataFolder "MQL5\Experts"
New-Item -ItemType Directory -Force -Path $MqlExperts | Out-Null
$dstEA = Join-Path $MqlExperts ($EA + ".mq5")
$ex5   = Join-Path $MqlExperts ($EA + ".ex5")
Copy-Item -LiteralPath $srcEA -Destination $dstEA -Force
# 1) il .ex5 VECCHIO si cancella PRIMA (punto 27): un binario di ieri fa
#    passare il gate su una compilazione fallita oggi.
Remove-Item -LiteralPath $ex5 -Force -ErrorAction SilentlyContinue
if (Test-Path -LiteralPath $ex5) {
  Muori ("non riesco a cancellare " + $ex5 + "." + "`n" +
         "    Di solito vuol dire che MT5 o MetaEditor sono ancora aperti.")
}
Remove-Item -LiteralPath (Join-Path $MqlExperts ($EA + ".log")) -Force -ErrorAction SilentlyContinue

# 2) si aspetta l'ARTEFATTO, NON il ritorno del processo (punto 39).
#    MetaEditor e' SINGLE-INSTANCE: se ne gira gia' una copia, il processo
#    appena lanciato TORNA SUBITO e la compilazione avviene nell'altra
#    istanza. Un controllo fatto sul ritorno del processo fallirebbe su una
#    compilazione perfettamente sana.
$t0 = Get-Date
& $MetaEditor ("/compile:" + $dstEA) "/log" | Out-Null
while ((-not (Test-Path -LiteralPath $ex5)) -and ((New-TimeSpan -Start $t0 -End (Get-Date)).TotalSeconds -lt 180)) {
  Start-Sleep -Seconds 2
}
if (-not (Test-Path -LiteralPath $ex5)) {
  $logC = Join-Path $MqlExperts ($EA + ".log")
  if (Test-Path -LiteralPath $logC) {
    Write-Host ""
    Write-Host "    --- log di compilazione ---" -ForegroundColor Red
    Get-Content -LiteralPath $logC -ErrorAction SilentlyContinue | Select-Object -Last 30 | ForEach-Object { Write-Host ("      " + $_) -ForegroundColor Red }
  }
  Muori ("compilazione FALLITA per " + $EA + ": nessun .ex5 dopo 180 secondi." + "`n" +
         "    Se il log dice 'undeclared identifier' e' l'include: guarda il passo 3." + "`n" +
         "    Se MetaEditor era gia' aperto, chiudilo e rilancia.")
}
$dopoEx5 = (Get-Item -LiteralPath $ex5).LastWriteTime
$secondi = [int](New-TimeSpan -Start $t0 -End (Get-Date)).TotalSeconds
Write-Host ("    ok  " + $EA + ".ex5 prodotto adesso (" + $dopoEx5.ToString("yyyy-MM-dd HH:mm:ss") + ", " + $secondi + "s)") -ForegroundColor Green

# 3) IL CONGELAMENTO DEL BRANCH, MISURATO INVECE CHE DICHIARATO.
#    "nessun push su lavoro mentre gira" e' un post-it: qui diventa
#    un'impronta. Dopo OGNI cella si riconfronta con la copia che
#    walkforward_generico.ps1 si e' riscaricato da lavoro HEAD.
$ImprontaEA = (Get-FileHash -LiteralPath $srcEA -Algorithm SHA256).Hash
Write-Host ("    impronta del sorgente: " + $ImprontaEA.Substring(0,16) + "...") -ForegroundColor DarkGray
Write-Host "    (verra' riconfrontata dopo ogni cella: se cambia, qualcuno ha pushato" -ForegroundColor DarkGray
Write-Host "     a meta' corsa e il confronto FRA CELLE e' morto)" -ForegroundColor DarkGray

# =====================================================================
#  4. GLI ARTEFATTI VECCHI (difetto 14): un file di ieri letto come di
#     oggi e' il referto stantio del 17/08, prodotto in casa.
# =====================================================================
Titolo "4) pulizia degli artefatti vecchi"
Get-ChildItem -Path $Cartella -Filter "anteprima_*.ini" -ErrorAction SilentlyContinue | ForEach-Object {
  try { Remove-Item -LiteralPath $_.FullName -Force } catch {}
}
$sostaAnt = Join-Path $Cartella "anteprime"
if (Test-Path $sostaAnt) { Remove-Item -LiteralPath $sostaAnt -Recurse -Force -ErrorAction SilentlyContinue }

if ((-not $SoloControllo) -and (Test-Path $Common)) {
  $puliti = 0
  Get-ChildItem -Path $Common -Filter ("abtg_trades_" + $EA + "_*.csv") -ErrorAction SilentlyContinue | ForEach-Object {
    try { Remove-Item -LiteralPath $_.FullName -Force; $puliti++ } catch {}
  }
  Write-Host ("    ripulite " + $puliti + " serie per-trade di corse precedenti") -ForegroundColor DarkYellow
}

# --- LA CACHE DEL TESTER (punto 38 della checklist). E' IL PEZZO PIU'
#     IMPORTANTE DI QUESTA SEZIONE, e nasce da un fatto misurato:
#     la cella di canarino di R94 (GBPUSD, BBPeriod 20, BBDev 2.0,
#     MinRR 0, magic 772101, stessa finestra, stesso deposito, stesso
#     modello) E' GIA' STATA CALCOLATA il 21/08 da R91 -- sta in
#     risultati_archivio\r91_csv\ABTG_BreakingBand_GBPUSD_OOS_r91a.csv,
#     Pass 0: Profit 3160.10 | PF 1.73020 | DD 3.4801 | Trades 26.
#     E il sorgente dell'EA non si muove dal 20/08.
#     Senza svuotare la cache, MT5 RIPESCA quel pass invece di eseguirlo:
#     il canarino tornerebbe al centesimo ANCHE CON LO STORICO SPARITO,
#     mentre le celle P37 (in cache non ci sono) girerebbero sui dati
#     veri. Due misure su due mondi diversi: l'esatto contrario di cio'
#     per cui il canarino esiste.
#     ATTENZIONE: SOLO Tester\cache. MAI bases\<server>\ticks, che e'
#     lo STORICO: cancellarlo trasforma un round di ore in una notte.
if (-not $SoloControllo) {
  $tolti = 0
  foreach ($radiceC in @((Join-Path $DataFolder "Tester\cache"), (Join-Path $instDir "Tester\cache"))) {
    if (-not (Test-Path -LiteralPath $radiceC)) { continue }
    $prima = @(Get-ChildItem -LiteralPath $radiceC -Recurse -File -ErrorAction SilentlyContinue).Count
    try { Remove-Item -Path (Join-Path $radiceC "*") -Recurse -Force -ErrorAction Stop } catch {}
    $dopo = @(Get-ChildItem -LiteralPath $radiceC -Recurse -File -ErrorAction SilentlyContinue).Count
    $tolti += ($prima - $dopo)
    if ($dopo -gt 0) {
      Muori ("non riesco a svuotare " + $radiceC + " (restano " + $dopo + " file)." + "`n" +
             "    Di solito vuol dire che MT5 e' ANCORA APERTO." + "`n" +
             "    Senza cache vuota il canarino verrebbe RIPESCATO invece che rigirato," + "`n" +
             "    e non misurerebbe piu' niente (punto 38 della checklist).")
    }
  }
  Write-Host ("    cache del tester svuotata: " + $tolti + " file tolti") -ForegroundColor DarkYellow
  Write-Host "    (le tre celle di canarino RIGIRANO: se una torna in pochi secondi," -ForegroundColor DarkYellow
  Write-Host "     e' un ripescaggio e va detto invece di essere letto come conferma)" -ForegroundColor DarkYellow
}

# --- LO ZIP E LA CARTELLA DI RACCOLTA VECCHI, VIA ADESSO (non alla fine):
#     una Muori anticipata non arriverebbe mai alla sezione 8, e al secondo
#     lancio ravvicinato lo zip di ieri passerebbe il gate dei 15 minuti
#     della riga travestito da risultato di adesso.
$nomeCartella = "R94_BREAKINGBAND_BB37"
$dest = Join-Path $desk $nomeCartella
$zip  = Join-Path $desk ($nomeCartella + ".zip")
foreach ($vecchio in @($zip, $dest)) {
  if (Test-Path -LiteralPath $vecchio) {
    try { Remove-Item -LiteralPath $vecchio -Recurse -Force -ErrorAction Stop } catch {}
    if (Test-Path -LiteralPath $vecchio) {
      Muori ("non riesco a cancellare " + $vecchio + "." + "`n" +
             "    Chiudi chi lo tiene aperto (Esplora risorse, uno zip aperto) e rilancia:" + "`n" +
             "    se resta li', a fine corsa nessuno sa se lo zip e' di adesso o di ieri.")
    }
    Write-Host ("    tolto artefatto vecchio: " + $vecchio) -ForegroundColor DarkYellow
  }
}

$segnaTempo = Get-Date
Write-Host ("    segnatempo di inizio corsa: " + $segnaTempo.ToString("yyyy-MM-dd HH:mm:ss")) -ForegroundColor DarkGray
Write-Host "    (serve alla raccolta dei log: si prendono solo quelli scritti DOPO)" -ForegroundColor DarkGray

# =====================================================================
#  5. IL DATO: cosa il canarino controlla davvero, e cosa no
# =====================================================================
Titolo "5) i dati (e perche' qui non c'e' un passo 0 di scaricamento)"
Write-Host "    R94 gira sugli STESSI tick di R33, R34 e R91 (stessa finestra, stessi" -ForegroundColor DarkGray
Write-Host "    tre cross). R91 e' girato il 21/08 su questi dati: che ci siano non e'" -ForegroundColor DarkGray
Write-Host "    una deduzione, e' un fatto." -ForegroundColor DarkGray
Write-Host ""
Write-Host "    IL CANARINO CONTROLLA I DATI **SOLO PERCHE' LA CACHE E' STATA SVUOTATA**." -ForegroundColor White
Write-Host "    Detto per esteso, perche' la versione corta di questa frase era SBAGLIATA" -ForegroundColor White
Write-Host "    ed e' stata corretta dalla verifica del 21/08:" -ForegroundColor White
Write-Host "      - la cella di canarino e' una passata GIA' CALCOLATA da R91 (stessi" -ForegroundColor Gray
Write-Host "        input, stesso simbolo, stessa finestra, stesso binario);" -ForegroundColor Gray
Write-Host "      - con la cache piena MT5 l'avrebbe RIPESCATA, e una passata ripescata" -ForegroundColor Gray
Write-Host "        NON LEGGE UN TICK: sarebbe tornata al centesimo anche con lo storico" -ForegroundColor Gray
Write-Host "        sparito, mentre le celle P37 avrebbero girato sui dati veri;" -ForegroundColor Gray
Write-Host "      - la sezione 4 ha svuotato Tester\cache, quindi le tre celle di" -ForegroundColor Gray
Write-Host "        canarino RIGIRANO davvero, e il controllo torna a valere." -ForegroundColor Gray
Write-Host "    SPIA: se una cella di canarino torna in pochi secondi, e' stata ripescata" -ForegroundColor Yellow
Write-Host "    lo stesso. Si dice, non si legge come conferma." -ForegroundColor Yellow

# =====================================================================
#  6. LE CORSE
# =====================================================================
$falliti = @()
$ripescate = @()
$i = 0
foreach ($c in $celle) {
  $i++
  $tCella = Get-Date
  Titolo ("6." + $i + ") CELLA " + $c.K + " - " + $c.Cosa)
  Write-Host ("      EA " + $EA + " | " + $c.Sym + " | patt " + $c.Patt + " | periodo " + $c.Per + " | prova " + $c.File) -ForegroundColor DarkGray
  if ($c.Base) {
    Write-Host "      QUESTO FILE PORTA IL CANARINO: la cella dev 2.0 deve riprodurre R34 al centesimo." -ForegroundColor Yellow
  }

  # L'anteprima non porta l'etichetta nel nome (difetto 31): il driver la
  # chiama anteprima_<EA>_<Simbolo>.ini, e qui DUE file prova hanno lo
  # stesso EA e lo stesso simbolo (P20 e P37). Senza questo ne resterebbe
  # UNA sola, quella dell'ultima cella, e nessuno lo direbbe.
  $ant = Join-Path $Cartella ("anteprima_" + $EA + "_" + $c.Sym + ".ini")
  Remove-Item -LiteralPath $ant -Force -ErrorAction SilentlyContinue

  # LE SERIE PER-TRADE VANNO VIA QUI, PRIMA DI OGNI CELLA -- non una volta
  # sola all'inizio. L'EA le chiama abtg_trades_<EA>_<Simbolo>_<Magic>.csv
  # (riga 1521): P20 e P37 dello STESSO simbolo hanno lo stesso nome e lo
  # stesso magic, quindi SCRIVONO LO STESSO FILE. Se la cella P37 non lo
  # riscrivesse, qui sotto verrebbe copiato il file di P20 con l'etichetta
  # di P37, e nessuno se ne accorgerebbe.
  # E c'e' un regalo: un pass RIPESCATO dalla cache non scrive per-trade.
  # Se dopo la cella il file non c'e', la cella non e' girata.
  if ((-not $SoloControllo) -and (Test-Path $Common)) {
    Get-ChildItem -Path $Common -Filter ("abtg_trades_" + $EA + "_" + $c.Sym + "_*.csv") -ErrorAction SilentlyContinue | ForEach-Object {
      try { Remove-Item -LiteralPath $_.FullName -Force } catch {}
    }
  }

  $arg = @("-ExecutionPolicy","Bypass","-File",$wf,$EA,
           "-Simbolo",$c.Sym,
           "-Prova",("prove\" + $c.File),
           "-Modello","$Modello",
           "-Deposito","$Deposito",
           "-DaQuando",$DaQuando,
           "-Fino",$Fino,
           "-Etichetta",$c.Tag)
  if ($SoloControllo) { $arg += "-SoloControllo" }
  if ($Rifai)         { $arg += "-Rifai" }

  $global:LASTEXITCODE = 0
  & powershell $arg

  if (Test-Path -LiteralPath $ant) {
    New-Item -ItemType Directory -Force -Path $sostaAnt | Out-Null
    try { Move-Item -LiteralPath $ant -Destination (Join-Path $sostaAnt ($c.K + "_" + $c.Tag + ".ini")) -Force } catch {}
  }
  if ($LASTEXITCODE -ne 0) {
    Write-Host ("    cella " + $c.K + " uscita con codice " + $LASTEXITCODE + ": vado avanti, la raccolta dira' cosa manca.") -ForegroundColor Yellow
    $falliti += $c.K
    continue
  }
  if ($SoloControllo) { continue }

  # la serie per-trade, subito, con un nome PROPRIO (difetto 26).
  # Si prendono SOLO quelle del simbolo di questa cella e SOLO se scritte
  # dopo che la cella e' partita: cosi' l'etichetta sul file dice il vero.
  $Risultati = Join-Path $Cartella ("risultati_prove\" + $EA)
  $ptPresi = 0
  if (Test-Path $Common) {
    Get-ChildItem -Path $Common -Filter ("abtg_trades_" + $EA + "_" + $c.Sym + "_*.csv") -ErrorAction SilentlyContinue |
      Where-Object { $_.LastWriteTime -ge $tCella } | ForEach-Object {
        New-Item -ItemType Directory -Force -Path $Risultati | Out-Null
        try {
          Copy-Item -LiteralPath $_.FullName -Destination (Join-Path $Risultati ("pertrade_" + $c.Tag + "_" + $_.Name)) -Force
          $ptPresi++
        } catch {}
      }
  }
  if ($ptPresi -eq 0) {
    Write-Host ("    NESSUN per-trade fresco per " + $c.K + ": la cella potrebbe essere stata") -ForegroundColor Yellow
    Write-Host "    RIPESCATA dalla cache invece che eseguita (punto 38). Va detto nel referto." -ForegroundColor Yellow
    $ripescate += $c.K
  }

  # IL CONGELAMENTO DEL BRANCH, MISURATO: walkforward_generico.ps1 si e'
  # appena riscaricato l'EA da 'lavoro' HEAD in src_prove\<EA>.mq5. Se
  # l'impronta e' cambiata, qualcuno ha pushato mentre il round girava e
  # le celle NON sono piu' confrontabili fra loro.
  $srcRis = Join-Path $Cartella ("src_prove\" + $EA + ".mq5")
  if (Test-Path -LiteralPath $srcRis) {
    $h = (Get-FileHash -LiteralPath $srcRis -Algorithm SHA256).Hash
    if ($h -ne $ImprontaEA) {
      Muori ("IL SORGENTE E' CAMBIATO A META' CORSA (dopo la cella " + $c.K + ")." + "`n" +
             "    atteso : " + $ImprontaEA + "`n" +
             "    trovato: " + $h + "`n" +
             "    Qualcuno ha pushato su 'lavoro' mentre R94 girava: il driver riscarica" + "`n" +
             "    l'EA a OGNI cella, quindi le celle gia' fatte e quelle che restano" + "`n" +
             "    girerebbero su DUE MOTORI DIVERSI. Il confronto fra celle e' morto:" + "`n" +
             "    si butta tutto e si rilancia a branch fermo.")
    }
  }
}

# =====================================================================
#  7. GIRO A VUOTO: il codice d'uscita DIPENDE dalle celle (difetto 14)
# =====================================================================
if ($SoloControllo) {
  Titolo "7) ANTEPRIME PRODOTTE (una per file prova, con nome proprio)"
  $senzaAnteprima = @()
  foreach ($c in $celle) {
    $ant = Join-Path $sostaAnt ($c.K + "_" + $c.Tag + ".ini")
    Write-Host ""
    Write-Host ("    --- " + $c.K + "  " + $c.Sym + "  periodo atteso " + $c.Per + " ---") -ForegroundColor White
    if (-not (Test-Path -LiteralPath $ant)) {
      Write-Host "      (nessuna anteprima prodotta: qualcosa si e' fermato prima)" -ForegroundColor Red
      $senzaAnteprima += $c.K
    } else {
      $chiavi = "^(InpBBPeriod|InpBBDev|InpPatternMode|InpTPMode|InpMinRR|InpStdPeriod|InpStdSmaPeriod|InpRiskPercent|InpUsaGuardian|InpBulgeWidthMult|InpBulgeNetMoveATR|InpRetestBufferATR)="
      foreach ($r in (Select-String -Path $ant -Pattern $chiavi)) { Write-Host ("      " + $r.Line) -ForegroundColor Gray }
      foreach ($r in (Select-String -Path $ant -Pattern "^(Symbol|Period|FromDate|ToDate|Deposit)=")) { Write-Host ("      " + $r.Line) -ForegroundColor DarkGray }
    }
  }
  Write-Host ""
  Write-Host ("  Le anteprime stanno in: " + $sostaAnt) -ForegroundColor DarkGray
  Write-Host "  DA CONTROLLARE A OCCHIO, e sono trenta secondi:" -ForegroundColor Yellow
  Write-Host "   1) InpBBPeriod: 20 nelle celle A20/B20/C20, 37 nelle A37/B37/C37." -ForegroundColor Yellow
  Write-Host "      Se una P37 dice 20, il pin non e' arrivato e il round misura" -ForegroundColor Yellow
  Write-Host "      DUE VOLTE la stessa cosa senza dirlo." -ForegroundColor Yellow
  Write-Host "   2) InpBBDev deve essere l'UNICO parametro con la sintassi di" -ForegroundColor Yellow
  Write-Host "      ottimizzazione (start/step/stop). Se ce ne sono due, il round" -ForegroundColor Yellow
  Write-Host "      non e' piu' 'una variabile alla volta'." -ForegroundColor Yellow
  Write-Host "   3) InpPatternMode: 2 su GBPUSD, 0 su EURUSD, 1 su AUDUSD." -ForegroundColor Yellow
  Write-Host "   4) InpRiskPercent = 1.0 (assunzione dichiarata, non firmata)." -ForegroundColor Yellow
  Write-Host "   5) FromDate/ToDate dentro 2024.09.26 -> 2026.06.30, spezzati in IS/OOS" -ForegroundColor Yellow
  Write-Host "      con lo stacco al 2025.06.09/10 (identico a R34)." -ForegroundColor Yellow
  Write-Host "   6) Deposit = 100000. A 10.000 il canarino NON torna." -ForegroundColor Yellow
  Write-Host "  ATTENZIONE: la riga 'Model=' dell'anteprima e' SCRITTA FISSA a 4 dal" -ForegroundColor Yellow
  Write-Host ("  driver (difetto 31): il modello VERO di questo giro e' " + $Modello + ".") -ForegroundColor Yellow
  Write-Host ""
  if ($falliti.Count -gt 0 -or $senzaAnteprima.Count -gt 0) {
    Write-Host ("=== GIRO A VUOTO FALLITO: " + (($falliti + $senzaAnteprima | Select-Object -Unique) -join " ") + " ===") -ForegroundColor Red
    exit 1
  }
  Write-Host "SoloControllo: MT5 non e' stato aperto, nessun CSV da raccogliere." -ForegroundColor Green
  exit 0
}

# =====================================================================
#  8. RACCOLTA SUL DESKTOP + ZIP (regola delle righe di lancio, punto 2)
# =====================================================================
Titolo "8) raccolta sul Desktop"
$nomeCartella = "R94_BREAKINGBAND_BB37"
$dest = Join-Path $desk $nomeCartella
if (Test-Path $dest) { Remove-Item $dest -Recurse -Force -ErrorAction SilentlyContinue }
New-Item -ItemType Directory -Force -Path $dest | Out-Null

$suff = if ($Modello -eq 4) { "" } else { "_ohlc" }
$attesi = @()
$mancanti = @()
foreach ($c in $celle) {
  foreach ($w in @("IS","OOS")) {
    $nome = $EA + "_" + $c.Sym + "_" + $w + $suff + "_" + $c.Tag + ".csv"
    $attesi += $nome
    $src = Join-Path $Cartella ("risultati_prove\" + $EA + "\" + $nome)
    if (Test-Path -LiteralPath $src) {
      Copy-Item -LiteralPath $src -Destination (Join-Path $dest $nome) -Force
    } else {
      $mancanti += $nome
    }
  }
}

# le serie per-trade viaggiano insieme ai numeri
$rp = Join-Path $Cartella ("risultati_prove\" + $EA)
if (Test-Path $rp) {
  Get-ChildItem -Path $rp -Filter "pertrade_*.csv" -ErrorAction SilentlyContinue | ForEach-Object {
    try { Copy-Item -LiteralPath $_.FullName -Destination (Join-Path $dest $_.Name) -Force } catch {}
  }
}
Copy-Item -LiteralPath (Join-Path $Cartella "R94_CRITERI.md") -Destination $dest -Force -ErrorAction SilentlyContinue

# --- I LOG DEGLI AGENT DEL TESTER.
#     In OTTIMIZZAZIONE MT5 non stampa le Print degli agent nella scheda
#     Esperti: finiscono nei log degli agent. Li' c'e' il funnel
#     [BB-FUNNEL], che per un round sulla FREQUENZA e' il numero che
#     spiega il numero: dice se i setup sono DIMINUITI o se sono stati
#     SCARTATI ALLA PORTA (tp / sl / rr / lotto).
#     Raccolta a BEST EFFORT: se non ci sono, il round vive lo stesso
#     (il cancello si legge dalla colonna Trades del CSV), ma va detto.
$logDest = Join-Path $dest "log_agent"
New-Item -ItemType Directory -Force -Path $logDest | Out-Null
$nLog = 0
foreach ($radice in @((Join-Path $DataFolder "Tester"), (Join-Path $instDir "Tester"))) {
  if (-not (Test-Path $radice)) { continue }
  Get-ChildItem -Path $radice -Recurse -Filter "*.log" -ErrorAction SilentlyContinue |
    Where-Object { $_.LastWriteTime -ge $segnaTempo } | ForEach-Object {
      $etichetta = ($_.Directory.Parent.Name + "_" + $_.Directory.Name + "_" + $_.Name)
      try { Copy-Item -LiteralPath $_.FullName -Destination (Join-Path $logDest $etichetta) -Force; $nLog++ } catch {}
    }
}
Write-Host ("    log degli agent raccolti: " + $nLog) -ForegroundColor $(if ($nLog -eq 0) { "Yellow" } else { "Green" })
if ($nLog -eq 0) {
  Write-Host "    (nessun log: il funnel [BB-FUNNEL] non sara' leggibile. Il cancello" -ForegroundColor Yellow
  Write-Host "     della frequenza si legge lo stesso dalla colonna Trades del CSV.)" -ForegroundColor Yellow
}

# il referto porta dentro la sua DATA: quella deve essere di ADESSO
$ref = Join-Path $dest "REFERTO_R94.txt"
$rr = @()
$rr += "R94 - GEOMETRIA DELLE BANDE SUL BREAKING BAND (Bollinger 37/1.4 del Point Break)"
$rr += ("data: " + (Get-Date -Format "yyyy-MM-dd HH:mm") + "   <-- questa data deve essere di ADESSO")
$rr += ("macchina: " + $env:COMPUTERNAME + "   riferimento: " + $Rif)
$rr += ("finestra: " + $DaQuando + " -> " + $Fino + "   modello: " + $Modello + " (4 = tick reali)")
$rr += ("deposito: " + $Deposito + "   rischio: 1,0% (ASSUNZIONE dichiarata da Claude, NON firmata)")
$rr += ("file prova: " + $celle.Count + "   celle: " + ($celle.Count * 2) + "   passate attese: " + $passateAttese)
$rr += ("log degli agent raccolti: " + $nLog)
$rr += ""
$rr += "FILE ATTESI (" + $attesi.Count + " CSV, ognuno con 2 righe = le 2 celle di deviazione):"
foreach ($a in $attesi) { $rr += ("  " + $a) }
$rr += ""
if ($mancanti.Count -gt 0) {
  $rr += ("MANCANTI (" + $mancanti.Count + "):")
  foreach ($m in $mancanti) { $rr += ("  " + $m) }
} else { $rr += "MANCANTI: nessuno." }
if ($falliti.Count -gt 0) { $rr += ("CELLE USCITE IN ERRORE: " + ($falliti -join " ")) }
$rr += ""
$rr += "COSA SI LEGGE PER PRIMO, E NON E' IL PROFITTO (criteri par. 3 e 4):"
$rr += "  1. IL CANARINO. Nei tre CSV _r94a20 / _r94b20 / _r94c20 la riga con"
$rr += "     InpBBDev=2.0 deve riprodurre R34 AL CENTESIMO:"
$rr += "       GBPUSD  IS +2.667,18 PF 2,72613 DD 1,6960 n=13 | OOS +3.160,10 PF 1,73020 DD 3,4801 n=26"
$rr += "       EURUSD  IS +1.457,02 PF 53,79058 DD 0,7797 n=4 | OOS +2.069,82 PF 3,86266 DD 1,2722 n=13"
$rr += "       AUDUSD  IS +1.291,32 PF 47,99127 DD 0,6753 n=5 | OOS +1.840,67 PF 2,74743 DD 1,2695 n=11"
$rr += "     Se non torna, IL ROUND SI FERMA QUI e si cerca il perche'."
$rr += "  2. LA COLONNA Trades. E' il cancello del round:"
$rr += "       GBPUSD  n OOS >= 60 verde | 27-59 giallo | <= 26 archiviata secca"
$rr += "       EURUSD  n OOS >= 30 verde | 14-29 giallo | <= 13 archiviata secca"
$rr += "       AUDUSD  n OOS >= 30 verde | 12-29 giallo | <= 11 archiviata secca"
$rr += "     REGOLA D'INSIEME: deve salire su ALMENO 2 SIMBOLI SU 3."
$rr += "  3. IL DRAWDOWN, che si legge SEMPRE, a qualunque n: cancello DD > 8%."
$rr += "  4. L'aspettativa dei trade AGGIUNTI ="
$rr += "     (Profit_cella - Profit_base) / (n_cella - n_base). Se e' negativa,"
$rr += "     la frequenza e' stata comprata con perdenti: peggioramento anche se n sale."
$rr += "  5. Il funnel [BB-FUNNEL] nei log_agent, se ci sono: dice se i setup sono"
$rr += "     diminuiti o se sono stati scartati alla porta (tp/sl/rr/lotto)."
$rr += "     Il contatore 'lotto' e' anche la verifica dell'assunzione sul rischio:"
$rr += "     se e' 0, il rischio non ha tolto nemmeno un'operazione."
$rr += ""
$rr += "E QUELLO CHE NON SI POTRA' DIRE, IN NESSUN CASO:"
$rr += "  - niente sul MERITO: con n OOS 11/13/26 e' SOSPESO per dichiarazione."
$rr += "  - nessuna promozione, nessun deploy, nessun cambio di preset in forward."
$rr += "  - se la frequenza non sale, il profitto NON SI GUARDA NEMMENO."
$rr | Set-Content -LiteralPath $ref -Encoding ASCII

Write-Host ""
Write-Host ("    file attesi : " + $attesi.Count) -ForegroundColor White
Write-Host ("    mancanti    : " + $mancanti.Count) -ForegroundColor $(if ($mancanti.Count -gt 0) { "Red" } else { "Green" })
foreach ($m in $mancanti) { Write-Host ("      manca: " + $m) -ForegroundColor Red }
Write-Host ("    cartella    : " + $dest) -ForegroundColor White

$zip = Join-Path $desk ($nomeCartella + ".zip")
if (Test-Path $zip) { Remove-Item $zip -Force -ErrorAction SilentlyContinue }
try {
  Compress-Archive -Path (Join-Path $dest "*") -DestinationPath $zip -Force
  Write-Host ""
  Write-Host ("    ZIP PRONTO DA MANDARE:  " + $zip) -ForegroundColor Cyan
} catch {
  Write-Host ""
  Write-Host ("!!! lo zip NON e' stato creato: " + $_.Exception.Message) -ForegroundColor Red
  Write-Host ("    i file comunque sono qui: " + $dest) -ForegroundColor Yellow
}

Write-Host ""
if ($falliti.Count -gt 0 -or $mancanti.Count -gt 0) {
  Write-Host ("=== R94 FINITO PARZIALE: " + $falliti.Count + " celle in errore, " + $mancanti.Count + " file mancanti ===") -ForegroundColor Red
  Write-Host "    Manda lo zip lo stesso: un risultato parziale e' gia' una risposta," -ForegroundColor Yellow
  Write-Host "    ma va detto QUALE pezzo manca prima di leggere gli altri." -ForegroundColor Yellow
  exit 1
}
Write-Host "=== R94 FINITO. Si legge il CANARINO, poi la colonna Trades. Il profitto viene dopo. ===" -ForegroundColor Green
exit 0
