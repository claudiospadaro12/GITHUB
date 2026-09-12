# MARCATORE_SCARICA_STORICO_v3_TERMINALE_BACKTEST
# v3 (08/09): parametro -TerminaleBacktest + CHIUSURA CHIRURGICA dei processi.
#
#   PERCHE' ESISTE, ED E' UN PERICOLO VERO, NON UNA PRECAUZIONE.
#   Fino alla v2 questo script, in modalita' -Auto, chiudeva MT5 cosi':
#       Get-Process -Name "terminal64" | Stop-Process -Force
#   cioe' TUTTI i terminali della macchina, senza guardare quale.
#   Sul VPS i terminali sono QUATTRO, e uno e' il CONTO REALE 10105439
#   (C:\BCM_Reale) CON POSIZIONI APERTE; gli altri due vivi sono il
#   piccolo 50503392 e il 100k 50504263 (-V3). Lanciare li' un download
#   dello storico voleva dire spegnere il terminale dei soldi veri
#   mentre opera: per questo report\SONDA_TICK_ORO_ATTENZIONE.md
#   vietava il VPS a questo script, e il quarto MT5 restava inutile.
#
#   ADESSO: con -TerminaleBacktest "C:\MT5_Backtest" (conto demo
#   50504400, zero EA attaccati) la cartella si NOMINA. Lo script usa
#   quel terminale e chiude SOLO il processo terminal64 il cui Path e'
#   ESATTAMENTE l'eseguibile di quella cartella; gli altri non si
#   toccano e vengono STAMPATI con PID e percorso, prima e dopo. La
#   prova che il forward non e' stato toccato sta nel referto, non
#   nella fiducia.
#
#   SENZA il parametro il comportamento resta IDENTICO alla v2 (chiude
#   tutti), ma prima stampa un avviso rosso con l'elenco di cosa sta
#   per ammazzare, e CHIEDE CONFERMA se non c'e' -Auto.
#
#   Le guardie del parametro sono le STESSE gia' scritte e gia' provate
#   in walkforward_generico.ps1 v4 (punto 7-bis), non ne sono state
#   inventate di nuove: muore se la cartella non esiste, se non contiene
#   terminal64.exe, se manca metaeditor64.exe, se il percorso contiene
#   -V3 (100k 50504263) o BCM_Reale (reale 10105439).
#
#   COMPATIBILITA' DEI MARCATORI: la stringa MARCATORE_SCARICA_STORICO_v2
#   resta qui sotto DI PROPOSITO, cosi' una riga di lancio gia' scritta
#   che la cercasse continua a riconoscere questo file. Cio' che quel
#   marcatore prometteva e' invariato.
#   MARCATORE_SCARICA_STORICO_v2
# v2 (07/09): aggiunto il marcatore, che mancava. Senza, la riga di lancio
#             non puo' verificare di aver scaricato lo script GIUSTO prima
#             di eseguirlo (regola di casa sulle righe di lancio, punto 1).
#             Nessun'altra modifica: il comportamento e' identico.
# =====================================================================
#  scarica_storico.ps1  --  scarica lo STORICO dal broker e dice
#                           SE il broker ce l'ha davvero
# ---------------------------------------------------------------------
#  PERCHE' ESISTE (walk-forward del 05/08/2026):
#  la finestra IS 2024.01-2025.06 produceva 10,0 trade/mese contro i
#  20,4 della OOS, con rapporto 2,03 IDENTICO su D30EUR e NASUSD (e lo
#  stesso segno gia' visto sul Dow). Un EA che fa al massimo 1 trade al
#  giorno, su ~21 giorni di borsa al mese, deve stare intorno a 20.
#  Quindi meta' dei giorni del 2024 NON C'E'. Finche' non e' risolto,
#  nessun confronto IS->OOS e' un test di overfitting valido.
#
#  COSA FA:
#   1. installa e compila ABTG_HistoryDownloader nel terminale BCM
#   2. (con -Auto) lancia MT5 che esegue lo script da solo
#   3. rilegge MQL5\Files\ABTG_StoricoScaricato.csv e stampa il verdetto
#
#  LA COLONNA CHE CONTA e' l'ultima:
#   COMPLETO                      -> a posto, si puo' testare da li'
#   MANCA STORICO LOCALE          -> e' solo da scaricare, rilancia
#   IL BROKER NON HA PIU' STORICO -> inutile insistere: si SPOSTA la
#                                    finestra di test, non si scarica
#
#  COME SI LANCIA (PC di backtest, il repo NON e' clonato):
#   irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/lavoro/backtest_pipeline/scarica_storico.ps1" -OutFile "$env:USERPROFILE\scarica_storico.ps1"
#   powershell -ExecutionPolicy Bypass -File "$env:USERPROFILE\scarica_storico.ps1" -Auto
#
#  VARIANTI (si aggiungono in coda alla seconda riga)
#   -Auto                     fa tutto da solo (richiede MT5 CHIUSO)
#   (niente -Auto)            installa e stampa le istruzioni manuali
#   -Da 2022.01.01            prova a risalire piu' indietro
#   -Simboli "XAUUSD"         altri simboli
#   -SenzaTick                solo barre, niente tick reali (molto piu' veloce)
#   -SoloReferto              rilegge l'ultimo risultato senza rifare nulla
#   -TerminaleBacktest "C:\MT5_Backtest"
#                             usa QUEL terminale (conto demo 50504400) e
#                             chiude SOLO quel processo. E' l'unico modo
#                             ammesso sul VPS.
#
#  !! SUL VPS: -Auto SENZA -TerminaleBacktest CHIUDE TUTTI I TERMINALI,
#     compreso il conto REALE 10105439 che ha posizioni aperte, e i due
#     demo che tengono su gli EA in forward. Sul VPS si passa SEMPRE
#     -TerminaleBacktest "C:\MT5_Backtest": cosi' si chiude solo quel
#     terminale e gli altri tre restano vivi, con la prova stampata
#     (PID + percorso) prima e dopo la chiusura.
# =====================================================================
param(
  [string] $Simboli    = "D30EUR,NASUSD,U30USD",
  [string] $Da         = "2023.01.01",
  [string] $Timeframes = "M1,M5,M15,M30,H1,H4,D1",
  [switch] $SenzaTick,
  [switch] $Auto,
  [switch] $ChiudiMT5,
  [switch] $SoloReferto,
  [int]    $TimeoutMin = 90,
  [string] $TerminaleBacktest = ""   # 08/09/2026 (v3): CARTELLA PROGRAMMA del
                                     #   terminale da usare, nominata a mano.
                                     #   Es. "C:\MT5_Backtest" (VPS, conto demo
                                     #   50504400, zero EA attaccati). Se passato:
                                     #   niente ricerca, niente inferenza, e la
                                     #   chiusura diventa CHIRURGICA (solo quel
                                     #   processo). Muore se la cartella non
                                     #   esiste, se non contiene terminal64.exe /
                                     #   metaeditor64.exe, o se e' un terminale
                                     #   VIETATO (-V3 = 100k 50504263,
                                     #   BCM_Reale = reale 10105439).
                                     #   Vuoto (default) = comportamento di
                                     #   sempre, immutato.
)
$ErrorActionPreference = "Stop"
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

# Il sorgente .mq5 si prende da GitHub, come fanno gli altri driver: sul PC
# di backtest il repo NON e' clonato, si scarica un .ps1 alla volta.
# Se invece il repo c'e' (es. sul PC di sviluppo) si usa la copia locale.
$EABranch = "lavoro"
$RawBase  = "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$EABranch"
$RepoRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$Work     = Join-Path $env:USERPROFILE "abtg_storico"
New-Item -ItemType Directory -Force -Path $Work | Out-Null

# ---------------------------------------------------------------------
# 0. FUNZIONI DI SERVIZIO: morte parlante e SCELTA CHIRURGICA dei processi
# ---------------------------------------------------------------------
function Muori($t){ Write-Host ""; Write-Host "!!! $t" -ForegroundColor Red; exit 1 }

function Normalizza-Percorso([string]$p){
  # Confronto fra percorsi: si toglie lo spazio ai bordi, si uniformano
  # gli slash e si ignorano maiuscole/minuscole. NIENTE "-like", niente
  # "assomiglia": o e' lo STESSO eseguibile, o non lo e'. Un match per
  # prefisso farebbe scambiare C:\MT5_Backtest con C:\MT5_Backtest_OLD.
  if([string]::IsNullOrWhiteSpace($p)){ return "" }
  return ($p.Trim() -replace '/','\').TrimEnd('\').ToLowerInvariant()
}

function Scegli-Terminali {
  # Divide i processi terminal64 in DUE liste:
  #   Bersagli    = quelli il cui Path e' ESATTAMENTE $EsePath
  #   Risparmiati = TUTTI gli altri, che non si toccano
  # E' scritta cosi', su una lista passata da fuori invece di chiamare
  # Get-Process dentro, apposta per poterla COLLAUDARE OFFLINE con
  # oggetti finti (Id + Path) senza MT5 e senza Windows. Un cancello che
  # nessuno ha visto scattare non e' un cancello dimostrato.
  param($Processi, [string]$EsePath)
  $bersagli = @(); $risparmiati = @()
  $mira = Normalizza-Percorso $EsePath
  foreach($p in @($Processi)){
    if($null -eq $p){ continue }
    $path = ""
    try { $path = [string]$p.Path } catch { $path = "" }   # Path illeggibile = si risparmia
    if($mira -ne "" -and (Normalizza-Percorso $path) -eq $mira){ $bersagli += $p }
    else { $risparmiati += $p }
  }
  return [pscustomobject]@{ Bersagli = @($bersagli); Risparmiati = @($risparmiati) }
}

function Stampa-Terminali($titolo, $lista, $colore){
  Write-Host $titolo -ForegroundColor $colore
  if(@($lista).Count -eq 0){ Write-Host "      (nessuno)" -ForegroundColor DarkGray; return }
  foreach($p in @($lista)){
    $path = "(percorso non leggibile)"
    try { if($p.Path){ $path = [string]$p.Path } } catch { }
    Write-Host ("      PID {0,-8} {1}" -f $p.Id, $path) -ForegroundColor $colore
  }
}

function Avviso-ChiusuraTotale($processi){
  # NESSUN -TerminaleBacktest: qui si chiude TUTTO, come nella v2. Il
  # comportamento non cambia, ma smette di essere silenzioso.
  Write-Host ""
  Write-Host "#####################################################################" -ForegroundColor Red
  Write-Host "  ATTENZIONE: -TerminaleBacktest NON e' stato passato." -ForegroundColor Red
  Write-Host "  In questa modalita' lo script chiude TUTTI i terminali MT5 della" -ForegroundColor Red
  Write-Host "  macchina, senza distinguere: forward, 100k e CONTO REALE compresi." -ForegroundColor Red
  Write-Host "#####################################################################" -ForegroundColor Red
  Stampa-Terminali "  Terminali che verrebbero chiusi TUTTI:" $processi "Red"
  Write-Host "  Sul VPS la riga giusta e':" -ForegroundColor Yellow
  Write-Host "    -TerminaleBacktest `"C:\MT5_Backtest`"   (conto demo 50504400)" -ForegroundColor Yellow
  if($Auto){
    Write-Host "  -Auto passato: nessuna domanda, vado avanti (ma l'avviso resta stampato)." -ForegroundColor DarkYellow
    return
  }
  $r = Read-Host "  Scrivi CHIUDITUTTO per continuare, qualsiasi altra cosa per fermarti"
  if($r -ne "CHIUDITUTTO"){ Muori "fermato da te: NESSUN terminale e' stato toccato." }
}

# ---------------------------------------------------------------------
# 1. trova terminale BCM + cartella dati
# ---------------------------------------------------------------------
# 1-bis. IL TERMINALE NOMINATO A MANO (-TerminaleBacktest)
#  Le guardie sono quelle GIA' scritte in walkforward_generico.ps1 v4,
#  punto 7-bis: stesse condizioni, stessi messaggi. Se il parametro e'
#  vuoto questo blocco non fa NIENTE e la scelta resta quella di sempre,
#  riga per riga.
$instDir = ""
$ViaTerminale = ""

# ---------------------------------------------------------------------
#  RIPIEGO_BANCO_v1 (12/09/2026) -- IL RIPIEGO PREFERISCE IL BANCO.
#  Stessa riparazione gia' accettata in walkforward_generico.ps1: il
#  ripiego NON sceglie per conto suo, ENTRA NELLO STESSO RAMO di
#  -TerminaleBacktest, cosi' passa dalle STESSE guardie (niente -V3,
#  niente BCM_Reale) e dalla STESSA chiusura chirurgica.
#  Senza questa riga il ripiego qui sotto sceglieva
#  "*BCM Markets MT5 Terminal*" e non "*-V3*", che sul VPS e' IL PICCOLO
#  50503392 CON LE SEDIE VIVE -- e questo script ci COPIA e ci COMPILA
#  ABTG_HistoryDownloader PRIMA ancora di guardare se MT5 e' aperto.
#  E c'e' un secondo effetto, piu' grosso: con $TerminaleBacktest vuoto
#  la chiusura finale prendeva il ramo "else" e faceva
#      Get-Process terminal64 | Stop-Process -Force
#  cioe' ammazzava TUTTI i terminali della macchina, IL CONTO REALE
#  10105439 COMPRESO, mentre ha posizioni aperte. Con -Auto l'avviso non
#  blocca nemmeno. Assegnando qui il banco, quel ramo diventa
#  IRRAGGIUNGIBILE e la chiusura e' sempre quella chirurgica.
#  Se il banco non c'e', NON si ripiega altrove: si muore.
# ---------------------------------------------------------------------
if (-not $TerminaleBacktest) {
  $BANCO_PERC = "C:\MT5_Backtest"
  if (Test-Path -LiteralPath $BANCO_PERC -PathType Container) {
    Write-Host ""
    Write-Host "--- RIPIEGO: NESSUN TERMINALE NOMINATO, PRENDO IL BANCO -------------" -ForegroundColor Yellow
    Write-Host ("    cartella : " + $BANCO_PERC) -ForegroundColor White
    Write-Host "    conto    : 50504400  (demo solo-tester, zero EA attaccati)" -ForegroundColor White
    Write-Host "    NON e' il piccolo 50503392, NON il 100k 50504263, NON il REALE 10105439." -ForegroundColor White
    Write-Host "---------------------------------------------------------------------" -ForegroundColor Yellow
    $TerminaleBacktest = $BANCO_PERC
  } else {
    Write-Host ""
    Write-Host "STOP: -TerminaleBacktest non passato e il banco non c'e'." -ForegroundColor Red
    Write-Host ("    cercato : " + $BANCO_PERC) -ForegroundColor Red
    Write-Host "    NON ripiego su Program Files: li' c'e' il piccolo 50503392, che ha" -ForegroundColor Red
    Write-Host "    le sedie VIVE, e questo script COMPILA dentro il terminale scelto." -ForegroundColor Red
    Write-Host "    Se ti serve un altro terminale, nominalo con -TerminaleBacktest." -ForegroundColor Red
    exit 1
  }
}

if ($TerminaleBacktest) {
  # La guardia di casa NON si allenta perche' il percorso e' scritto a
  # mano: anzi, e' proprio quando si scrive a mano che si sbaglia riga.
  if ($TerminaleBacktest -like "*-V3*" -or $TerminaleBacktest -like "*BCM_Reale*") {
    Muori ("TERMINALE VIETATO in -TerminaleBacktest: '$TerminaleBacktest'`n" +
           "    Il 100k (-V3, conto 50504263) e il conto REALE (BCM_Reale, 10105439)`n" +
           "    non si toccano da questo script, nemmeno nominandoli a mano.`n" +
           "    Il terminale da backtest e' C:\MT5_Backtest (conto demo 50504400).")
  }
  $cartellaBT = $TerminaleBacktest.TrimEnd('\','/')
  if (-not (Test-Path -LiteralPath $cartellaBT -PathType Container)) {
    Muori ("-TerminaleBacktest: la cartella NON esiste.`n" +
           "    cercata  : '$cartellaBT'`n" +
           "    Va passata la CARTELLA PROGRAMMA del terminale, cioe' quella che`n" +
           "    contiene terminal64.exe (non l'exe, non la cartella dati):`n" +
           "      -TerminaleBacktest `"C:\MT5_Backtest`"")
  }
  $exeBT = Join-Path $cartellaBT "terminal64.exe"
  if (-not (Test-Path -LiteralPath $exeBT -PathType Leaf)) {
    Muori ("-TerminaleBacktest: la cartella c'e', ma NON contiene terminal64.exe.`n" +
           "    cartella : '$cartellaBT'`n" +
           "    cercato  : '$exeBT'`n" +
           "    Se il terminale e' installato altrove, passa QUELLA cartella.`n" +
           "    Per vedere le installazioni vive, in sola lettura:`n" +
           "      Get-Process terminal64 | Select-Object Id, MainWindowTitle, Path")
  }
  # il compilatore sta nella stessa cartella: se manca, la corsa morirebbe
  # piu' avanti con un errore che non nomina il terminale. Meglio adesso.
  $medBT = Join-Path $cartellaBT "metaeditor64.exe"
  if (-not (Test-Path -LiteralPath $medBT -PathType Leaf)) {
    Muori ("-TerminaleBacktest: manca metaeditor64.exe, e senza compilatore lo`n" +
           "    script MQL5 non si compila.`n" +
           "    cartella : '$cartellaBT'`n" +
           "    cercato  : '$medBT'")
  }
  $instDir = $cartellaBT
  $ViaTerminale = "parametro esplicito -TerminaleBacktest"
}

# ---------------------------------------------------------------------
#  IL VECCHIO RIPIEGO SU PROGRAM FILES: TOLTO IL 12/09/2026.
#  Questo blocco e' IRRAGGIUNGIBILE da quando il ripiego assegna il banco
#  qui sopra (l'unica assegnazione di $TerminaleBacktest e' quella, e o
#  assegna o esce 1). Ma lasciarci dentro il selettore vecchio -- quello
#  che prendeva "*BCM Markets MT5 Terminal*" e non "*-V3*", cioe' IL
#  PICCOLO 50503392 CON LE SEDIE VIVE -- sarebbe una trappola per chi
#  legge fra un mese: sembra codice vivo, e se qualcuno togliesse il
#  ripiego di sopra tornerebbe a mordere in silenzio.
#  Quindi resta il controllo, ma senza il selettore: se per qualsiasi
#  ragione arrivassimo qui, si MUORE. Rumoroso batte silenzioso.
# ---------------------------------------------------------------------
if (-not $instDir) {
  Muori ("nessun terminale scelto, e qui NON si ripiega piu' su Program Files.`n" +
         "    Il ripiego automatico adesso prende il banco C:\MT5_Backtest e, se non`n" +
         "    c'e', esce prima di arrivare fin qui. Se leggi questo messaggio, qualcuno`n" +
         "    ha tolto quel blocco: rimettilo, oppure passa -TerminaleBacktest a mano.`n" +
         "    NON si spazzola Program Files: li' c'e' il piccolo 50503392 con le sedie VIVE.")
}

# --- 08/09/2026: la 37-quater era ancora aperta QUI.
#  Il secondo ripiego qui sopra cerca solo "*BCM Markets*", quindi puo'
#  scegliere il "-V3" (100k 50504263) -- e nessuno controllava il valore
#  scelto. Un ripiego che punta il terminale sbagliato e non lo dice e'
#  il difetto gia' pagato il 07/09. Adesso muore.
#  Segnalato dal verificatore delle stringhe, difetto 6 del giro sulla
#  riga dello storico.
if (($instDir -like "*-V3*") -or ($instDir -like "*BCM_Reale*")) {
  Write-Host ""
  Write-Host "TERMINALE SCELTO VIETATO: '$instDir'" -ForegroundColor Red
  Write-Host "    -V3 = 100k 50504263 . BCM_Reale = REALE 10105439." -ForegroundColor Red
  Write-Host "    Usa -TerminaleBacktest ""C:\MT5_Backtest"" (demo 50504400)." -ForegroundColor Red
  exit 1
}

$Terminal   = Join-Path $instDir "terminal64.exe"
$MetaEditor = Join-Path $instDir "metaeditor64.exe"
$termRoot   = Join-Path $env:APPDATA "MetaQuotes\Terminal"
$DataFolder = Get-ChildItem $termRoot -Directory -ErrorAction SilentlyContinue | Where-Object {
    $o = Join-Path $_.FullName "origin.txt"
    (Test-Path $o) -and ((Get-Content $o -Raw).Trim() -ieq $instDir)
} | Select-Object -First 1 -ExpandProperty FullName
if (-not $DataFolder) { Write-Host "Cartella dati MT5 non trovata." -ForegroundColor Red; exit 1 }

# --- SI DICHIARA SEMPRE QUALE TERMINALE E' STATO SCELTO, E DA QUALE VIA.
#  Con QUATTRO terminali BCM sul VPS (piccolo 50503392, 100k 50504263
#  -V3, reale 10105439 in C:\BCM_Reale, backtest 50504400 in
#  C:\MT5_Backtest) questa riga va LETTA prima di lasciar girare.
Write-Host ""
Write-Host "--- TERMINALE SCELTO ------------------------------------------------" -ForegroundColor Cyan
Write-Host ("    terminal64 : " + $Terminal) -ForegroundColor White
Write-Host ("    cartella   : " + $instDir) -ForegroundColor White
Write-Host ("    dati       : " + $DataFolder) -ForegroundColor White
Write-Host ("    via        : " + $ViaTerminale) -ForegroundColor Yellow
if ($ViaTerminale -like "RIPIEGO*") {
  Write-Host "    (ripiego: nessuna cartella nominata, e la ricerca guarda SOLO sotto" -ForegroundColor DarkYellow
  Write-Host "     Program Files: C:\MT5_Backtest non verrebbe mai trovato da qui." -ForegroundColor DarkYellow
  Write-Host "     Sul VPS rilancia con -TerminaleBacktest `"C:\MT5_Backtest`".)" -ForegroundColor DarkYellow
}
Write-Host "---------------------------------------------------------------------" -ForegroundColor Cyan

$CsvOut = Join-Path $DataFolder "MQL5\Files\ABTG_StoricoScaricato.csv"

# ---------------------------------------------------------------------
# funzione: rilegge il CSV e stampa il referto
# ---------------------------------------------------------------------
# legge il CSV anche se MT5 lo tiene ancora aperto (lettura condivisa,
# copia in temp, e in ultima istanza rinuncia senza far morire lo script)
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
      $tmp = Join-Path $env:TEMP "abtg_storico_peek.csv"
      Copy-Item $CsvOut $tmp -Force -ErrorAction Stop
      return (Import-Csv $tmp)
    } catch { return $null }
  }
}

function Mostra-Referto {
  $righe = Leggi-Csv
  if (-not $righe) {
    Write-Host "`nNessun referto leggibile in:`n  $CsvOut" -ForegroundColor Yellow
    Write-Host "O lo script non e' ancora stato eseguito, o MT5 lo sta ancora scrivendo:" -ForegroundColor Yellow
    Write-Host "chiudi MT5 e rilancia con -SoloReferto." -ForegroundColor Yellow
    return
  }
  Write-Host "`n=== REFERTO STORICO ===" -ForegroundColor Cyan
  Write-Host ("{0}" -f $CsvOut) -ForegroundColor DarkGray
  $righe | Format-Table Simbolo, Timeframe, Barre, PrimaDataLocale, PrimaDataServer, Verdetto -AutoSize

  $bloccati = $righe | Where-Object { $_.Verdetto -like "*NON HA PIU'*" }
  $daRifare = $righe | Where-Object { $_.Verdetto -like "*MANCA STORICO*" }
  if ($bloccati) {
    Write-Host "!! IL BROKER NON HA PIU' STORICO su queste righe:" -ForegroundColor Red
    $bloccati | ForEach-Object { Write-Host ("   {0} {1} -> parte dal {2}" -f $_.Simbolo, $_.Timeframe, $_.PrimaDataServer) -ForegroundColor Red }
    Write-Host "   Non si scarica quello che non esiste: si SPOSTA la finestra IS" -ForegroundColor Red
    Write-Host "   alla prima data disponibile e si rifa' il walk-forward da li'." -ForegroundColor Red
  }
  if ($daRifare) {
    Write-Host "!! Manca solo il download su queste righe: rilancia lo script." -ForegroundColor Yellow
    $daRifare | ForEach-Object { Write-Host ("   {0} {1}" -f $_.Simbolo, $_.Timeframe) -ForegroundColor Yellow }
  }
  if (-not $bloccati -and -not $daRifare) {
    Write-Host "OK: storico completo su tutte le righe. Si puo' rifare la fase IS." -ForegroundColor Green
  }
}

if ($SoloReferto) { Mostra-Referto; exit 0 }

# ---------------------------------------------------------------------
# 2. installa + compila lo script
# ---------------------------------------------------------------------
Write-Host "=== SCARICO STORICO: $Simboli  (da $Da) ===" -ForegroundColor Cyan

$Locale = Join-Path $RepoRoot "..\mql5\Scripts\ABTG_HistoryDownloader.mq5"
if (Test-Path $Locale) {
  $Src = $Locale
  Write-Host "  sorgente:  repo locale" -ForegroundColor DarkGray
} else {
  $Src = Join-Path $Work "ABTG_HistoryDownloader.mq5"
  try {
    Invoke-WebRequest -Uri "$RawBase/mql5/Scripts/ABTG_HistoryDownloader.mq5" -OutFile $Src -UseBasicParsing
    Write-Host "  sorgente:  scaricato da GitHub ($EABranch)" -ForegroundColor DarkGray
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
& $MetaEditor "/compile:$mq5" "/log" | Out-Null
$ex5 = [System.IO.Path]::ChangeExtension($mq5, ".ex5")
if (-not (Test-Path $ex5)) { Write-Host "ERRORE di compilazione." -ForegroundColor Red; exit 1 }
Write-Host "  compilato: ABTG_HistoryDownloader.ex5" -ForegroundColor Green

# ---------------------------------------------------------------------
# 3. preset con i parametri
# ---------------------------------------------------------------------
$PresetDir = Join-Path $DataFolder "MQL5\Presets"
New-Item -ItemType Directory -Force -Path $PresetDir | Out-Null
$SetFile = Join-Path $PresetDir "abtg_storico.set"
$tick = if ($SenzaTick) { "false" } else { "true" }
@"
InpSimboli=$Simboli
InpTimeframes=$Timeframes
InpDataInizio=$Da
InpListaSoloNomi=false
InpTuttiBroker=false
InpTimeoutSec=120
InpScaricaTick=$tick
InpTolleranzaGG=4
"@ | Set-Content -Path $SetFile -Encoding ASCII
# InpTolleranzaGG (21/08/2026): giorni di scarto fra la data CHIESTA e la prima
# barra vera. Serve perche' TUTTE le nostre date d'inizio cadono di weekend o
# di festivo (2022.01.01 sabato, 2023.01.01 domenica, 2021.01.01 Capodanno) e
# sul forex li' non esistono barre: con la vecchia tolleranza di 1 giorno il
# ciclo del downloader non usciva MAI e bruciava 120 s pieni su OGNI timeframe,
# D1 compreso. Vedi il commento lungo in ABTG_HistoryDownloader.mq5.
Write-Host "  preset:    MQL5\Presets\abtg_storico.set" -ForegroundColor Green

# ---------------------------------------------------------------------
# 4a. modalita' MANUALE (default, e l'unica ammessa sul VPS)
# ---------------------------------------------------------------------
if (-not $Auto) {
  Write-Host @"

--- ORA IN MT5 (2 minuti) ---------------------------------------------
 1. Strumenti > Opzioni > Grafici > "Max barre nel grafico" = ILLIMITATO
    (e' il tappo numero uno: senza questo il download si ferma da solo)
 2. Navigatore > Script > tasto destro > Aggiorna
 3. Trascina ABTG_HistoryDownloader su un grafico qualsiasi
 4. Nella finestra parametri: Carica > abtg_storico.set
    (contiene gia' InpSimboli=$Simboli e InpDataInizio=$Da)
 5. OK. Guarda la scheda ESPERTI (non Journal). I tick reali su piu'
    anni possono richiedere parecchi minuti: lascialo finire.
 6. Poi torna qui e lancia:
       powershell -ExecutionPolicy Bypass -File "`$env:USERPROFILE\scarica_storico.ps1" -SoloReferto
-----------------------------------------------------------------------
"@ -ForegroundColor Yellow
  Mostra-Referto
  exit 0
}

# ---------------------------------------------------------------------
# 4b. modalita' AUTOMATICA (solo PC di backtest, MT5 chiuso)
# ---------------------------------------------------------------------
# --- PERCHE' QUESTO SCRIPT CHIUDE MT5 (il motivo, prima del rimedio)
#  Il punto 4b non apre un tester: lancia IL TERMINALE con /config e un
#  [StartUp] Script=. MT5 esegue lo script di avvio SOLO quando quella
#  istanza parte davvero; se un terminale sulla STESSA cartella dati e'
#  gia' aperto, il secondo avvio si limita a portarlo in primo piano e
#  lo Script NON parte (referto assente, CSV a zero byte). Il vincolo
#  vero e' quindi "quella installazione dev'essere chiusa", NON "la
#  macchina dev'essere senza MT5": e' esattamente per questo che la
#  chiusura puo' diventare CHIRURGICA senza cambiare nulla del metodo.
$tuttiTerm = @(Get-Process -Name "terminal64" -ErrorAction SilentlyContinue)

if ($TerminaleBacktest) {
  # --- CHIUSURA CHIRURGICA: guardo SOLO il terminale nominato.
  $sel = Scegli-Terminali -Processi $tuttiTerm -EsePath $Terminal
  Write-Host ""
  Write-Host "--- TERMINALI MT5 VISTI ADESSO --------------------------------------" -ForegroundColor Cyan
  Stampa-Terminali "  BERSAGLIO (terminale da backtest, l'unico che posso chiudere):" $sel.Bersagli "Yellow"
  Stampa-Terminali "  LASCIATI VIVI (forward e conto reale: NON li tocco):" $sel.Risparmiati "Green"
  Write-Host "---------------------------------------------------------------------" -ForegroundColor Cyan
  $running = @($sel.Bersagli)
  if ($running.Count -gt 0 -and $ChiudiMT5) {
    Write-Host "`nIl terminale da backtest e' aperto: chiudo SOLO quello (-ChiudiMT5)." -ForegroundColor Yellow
    $running | Stop-Process -Force -ErrorAction SilentlyContinue
    Start-Sleep -Seconds 5
    $running = @((Scegli-Terminali -Processi @(Get-Process -Name "terminal64" -ErrorAction SilentlyContinue) -EsePath $Terminal).Bersagli)
  }
  if ($running.Count -gt 0) {
    Write-Host "`nIL TERMINALE DA BACKTEST E' APERTO. In automatico non si puo': un" -ForegroundColor Red
    Write-Host "secondo avvio sulla stessa cartella dati non esegue lo script." -ForegroundColor Red
    Write-Host ("   " + $Terminal) -ForegroundColor Red
    Write-Host "Aggiungi -ChiudiMT5: verra' chiuso SOLO quel processo, gli altri" -ForegroundColor Red
    Write-Host "terminali (forward e conto reale) restano vivi." -ForegroundColor Red
    exit 1
  }
} else {
  # --- NESSUN PARAMETRO: comportamento IDENTICO alla v2, ma dichiarato.
  Avviso-ChiusuraTotale $tuttiTerm
  # 12/09/2026: QUI C'ERA IL SECONDO KILL DI TUTTI I TERMINALI, gemello di
  # quello gia' scaricato 200 righe piu' sotto. Il ramo e' IRRAGGIUNGIBILE
  # (il ripiego assegna il banco o esce 1), ma la regola l'avevo scritta
  # IO poche righe sotto -- "un ramo morto con l'arma ancora carica resta
  # un'arma" -- e non l'avevo applicata qui. Scritta e non fatta, nello
  # stesso file, sul kill identico.
  Muori ("nessun -TerminaleBacktest, e qui NON si chiudono piu' TUTTI i terminali.`n" +
         "    Chiudere tutti vuol dire chiudere anche il conto REALE 10105439 mentre`n" +
         "    ha posizioni aperte -- e il 10/09 e' successo davvero.`n" +
         "    Se leggi questo messaggio, qualcuno ha tolto il ripiego sul banco:`n" +
         "    rimettilo, oppure passa -TerminaleBacktest a mano.")
  # 12/09/2026 (cancello): qui c'era "$running = @()", e faceva l'OPPOSTO di
  # quello che credevo. Siccome Muori esce, e' codice morto -- innocuo OGGI.
  # Ma domani, se qualcuno togliesse il Muori (che e' ESATTAMENTE lo scenario
  # che il messaggio qui sopra dichiara di temere), un array vuoto renderebbe
  # FALSO l'if ($running) due righe sotto e lo script tirerebbe avanti CON
  # TUTTI I TERMINALI APERTI, senza nessun controllo. Avevo scaricato l'arma
  # e insieme DISINNESCATO la guardia che la sorveglia.
  # Con $tuttiTerm, se il Muori sparisce la guardia MORDE invece di tacere.
  $running = $tuttiTerm
  if ($running) {
    Write-Host "`nMT5 e' APERTO. In automatico non si puo': un secondo avvio" -ForegroundColor Red
    Write-Host "sulla stessa cartella dati non esegue lo script." -ForegroundColor Red
    Write-Host "Aggiungi -ChiudiMT5 per farlo chiudere da solo, oppure usa la" -ForegroundColor Red
    Write-Host "modalita' manuale (senza -Auto)." -ForegroundColor Red
    Write-Host "SUL VPS: NON usare -ChiudiMT5, spegneresti gli EA in forward." -ForegroundColor Red
    Write-Host "SUL VPS la strada e' -TerminaleBacktest `"C:\MT5_Backtest`"." -ForegroundColor Red
    exit 1
  }
}

if (Test-Path $CsvOut) { Remove-Item $CsvOut -Force }   # cosi' so che il referto e' nuovo

$primoSym = ($Simboli -split ",")[0].Trim()
$Ini = Join-Path $env:TEMP "abtg_storico.ini"
# --- 21/08/2026 - [Experts] AllowLiveTrading=false: NON e' cosmetica, ed e'
#  la stessa riga che walkforward_generico.ps1 porta con dodici righe di
#  commento sopra. Il motivo e' identico e vale ANCHE qui:
#  /config NON apre un tester. Apre IL TERMINALE, che carica l'ultimo
#  profilo con i suoi grafici e gli EA attaccati sopra. Sul PC di backtest
#  quel terminale e' collegato al conto VIVO 50503392: senza questa riga,
#  scaricare lo storico RIARMA di fatto gli EA su grafico, che piazzano
#  ordini veri. E' successo il 14/08 (un DAX Apertura partito in breakout
#  da un grafico M3 di prova).
#  Qui morde di piu' che altrove, perche' questo script gira per PRIMO:
#  e' il PASSO 0 dei round, cioe' il gesto piu' innocuo della serata.
#  Il download dello storico non ne risente: lo fa uno Script, che non
#  passa dal permesso di trading dal vivo.
@"
[Experts]
AllowLiveTrading=false
AllowDllImport=false

[Charts]
MaxBars=2000000000

[StartUp]
Script=ABTG_HistoryDownloader
ScriptParameters=abtg_storico.set
Symbol=$primoSym
Period=M5
"@ | Set-Content -Path $Ini -Encoding Unicode

Write-Host "`nAvvio MT5 in automatico (timeout $TimeoutMin min)..." -ForegroundColor Cyan
Start-Process -FilePath $Terminal -ArgumentList "/config:$Ini"

# Attesa: si guarda SOLO la dimensione del file, mai il contenuto.
# (la prima versione faceva Import-Csv qui dentro e moriva con
#  "il file e' in uso da un altro processo", lasciando MT5 aperto)
$ErrorActionPreference = "Continue"

# --- fotografia dei log PRIMA di partire: cosi' dopo si legge solo il nuovo
$logDirW  = Join-Path $DataFolder "MQL5\Logs"
$lenPrima = @{}
if (Test-Path $logDirW) {
  foreach ($f in (Get-ChildItem $logDirW -Filter "*.log" -ErrorAction SilentlyContinue)) {
    $lenPrima[$f.FullName] = $f.Length
  }
}
function Coda-Log-Storico {
  # Legge SOLO cio' che i log hanno scritto DOPO la fotografia $lenPrima.
  # DIFETTO PAGATO (18/08 sera, PASSO 0 di R84): la prima versione, quando
  # un file NON era cresciuto (il log di IERI), saltava il Seek per la
  # condizione "$da -lt Length" e lo RILEGGEVA DA CAPO: il "=== FINITO"
  # della corsa di ieri sera e' stato preso per quello di oggi, MT5 e'
  # stato ammazzato dopo 15 secondi col download appena partito, CSV da
  # 0 byte. Regola: file non cresciuto = NIENTE da leggere, si salta.
  if (-not (Test-Path $logDirW)) { return "" }
  $tutto = ""
  foreach ($f in (Get-ChildItem $logDirW -Filter "*.log" -ErrorAction SilentlyContinue)) {
    $da = 0
    if ($lenPrima.ContainsKey($f.FullName)) { $da = [int64]$lenPrima[$f.FullName] }
    if ($da % 2 -ne 0) { $da = $da - 1 }
    try {
      $fs = New-Object System.IO.FileStream($f.FullName, [System.IO.FileMode]::Open, [System.IO.FileAccess]::Read, [System.IO.FileShare]::ReadWrite)
      if ($da -ge $fs.Length) { $fs.Close(); continue }
      if ($da -gt 0) { [void]$fs.Seek($da, [System.IO.SeekOrigin]::Begin) }
      $sr = New-Object System.IO.StreamReader($fs, [System.Text.Encoding]::Unicode, $false)
      $tutto = $tutto + $sr.ReadToEnd(); $sr.Close(); $fs.Close()
    } catch { }
  }
  return $tutto
}

$scaduto = (Get-Date).AddMinutes($TimeoutMin)
$ultimaLen  = -1
$ultimaBasi = -1
$fermoDa    = 0

# --- IL PROGRESSO VERO E' NELLA CARTELLA bases (imparato il 23/08/2026) ---
#  Il CSV lo scrive ABTG_HistoryDownloader ALLA FINE di ogni blocco: sul
#  primo simbolo con 30+ anni di M1 (AUDUSD dal 1993) MT5 scarica barre
#  per PIU' di 15 minuti con il CSV fermo a 0 byte, e il guardiano qui
#  sotto lo ammazzava a meta' scarico ("0 byte scritti" -> morto = FALSO).
#  Ma mentre scarica, MT5 fa crescere i file di storico in bases\:
#  QUELLO e' il battito. Qui si LEGGONO solo le dimensioni: bases\ non
#  si tocca MAI in scrittura (regola di casa).
function Battito-Basi {
  $tot = [long]0
  #  MISURATO il 24/08: '-File' insieme a un -Path CON WILDCARD torna ZERO
  #  (l'attributo viene applicato agli elementi risolti dal wildcard, che
  #  sono le CARTELLE history/ticks). Niente wildcard dentro -Path: si
  #  enumerano i server e si scende con -LiteralPath, che e' univoco.
  $d = Join-Path $DataFolder "bases"
  if(-not (Test-Path -LiteralPath $d)){ return $tot }
  try {
    foreach($srv in @(Get-ChildItem -LiteralPath $d -Directory -ErrorAction SilentlyContinue)){
      foreach($sub in @("history","ticks")){
        $p = Join-Path $srv.FullName $sub
        if(-not (Test-Path -LiteralPath $p)){ continue }
        $m = Get-ChildItem -LiteralPath $p -Recurse -File -ErrorAction SilentlyContinue |
             Measure-Object -Property Length -Sum
        if($m -and $m.Sum){ $tot += [long]$m.Sum }
      }
    }
  } catch { }
  return $tot
}
$visto      = $false
$finito     = $false
$faseTick   = $false
while ((Get-Date) -lt $scaduto) {
  Start-Sleep -Seconds 15

  # --- HA FINITO DAVVERO? -------------------------------------------
  #  IL SILENZIO NON E' UN SEGNALE DI FINE (imparato il 15/08/2026).
  #  Questo script trattava 60 secondi di silenzio come "ha finito". Ma
  #  il downloader, sul PRIMO simbolo, chiede al server anni di barre e
  #  di tick: sta zitto per minuti prima di scrivere la prima riga. Il
  #  15/08 e' partito QUATTRO volte e ogni volta e' stato ammazzato dopo
  #  la sola riga di intestazione, lasciando un CSV da ZERO byte.
  #  E' lo stesso difetto gia' corretto in prepara_broker_esterno.ps1:
  #  il segnale buono e' la riga di chiusura che lo script MQL5 stampa
  #  da solo. Il silenzio resta solo come rete, e molto piu' lungo.
  $coda = Coda-Log-Storico
  if ($coda -match "=== FINITO") {
    Write-Host "  lo script ha stampato la sua riga di chiusura: ha finito." -ForegroundColor Green
    $visto = $true
    $finito = $true
    break
  }
  if ($coda -match "ABTG_HistoryDownloader") { $visto = $true }

  # --- FASE TICK: il CSV NON CRESCE PER ORE ---------------------------
  #  DIFETTO PAGATO (classe 30 della checklist, 20/08): la riga TICK del
  #  CSV la scrive ABTG_HistoryDownloader.mq5 (righe 219-232) SOLO quando
  #  DownloadTicks ha finito. Fra "TICK : scarico..." e "=== FINITO" il
  #  file resta della STESSA lunghezza anche per ore: il guardiano dei 15
  #  minuti qui sotto ammazzerebbe MT5 in mezzo allo scaricamento dei
  #  tick, e il referto uscirebbe SENZA la riga TICK, con codice 0.
  #  Durante la fase tick l'unico limite ammesso e' -TimeoutMin.
  if ($coda -match "TICK : scarico") { $faseTick = $true }

  $len = 0
  if (Test-Path $CsvOut) {
    $visto = $true
    try { $len = (Get-Item $CsvOut -ErrorAction Stop).Length } catch { $len = 0 }
  }
  $basi = Battito-Basi

  if ($len -ne $ultimaLen -or $basi -ne $ultimaBasi) {
    # --- QUALCOSA CRESCE: CSV o storico in bases\. E' vivo. -----------
    $fermoDa = 0
    if ($basi -ne $ultimaBasi -and $ultimaBasi -ge 0) {
      Write-Host ("  ... CSV {0} byte, storico bases {1:N0} MB (IN CRESCITA: sta scaricando)" -f $len, ($basi/1MB)) -ForegroundColor DarkGray
    } else {
      Write-Host ("  ... CSV {0} byte, storico bases {1:N0} MB" -f $len, ($basi/1MB)) -ForegroundColor DarkGray
    }
    $ultimaLen = $len
    $ultimaBasi = $basi
  } else {
    if ($faseTick) { continue }   # vedi sopra: qui il silenzio e' NORMALE
    $fermoDa += 15
    if ($fermoDa -ge 900) {               # 15 minuti SENZA che nulla cresca (ne' CSV ne' bases)
      Write-Host "  fermo da 15 minuti senza riga di chiusura E senza crescita dello storico: mi fermo qui." -ForegroundColor Yellow
      Write-Host "  ATTENZIONE: il referto potrebbe essere INCOMPLETO." -ForegroundColor Yellow
      break
    }
  }
}
$ErrorActionPreference = "Stop"

if (-not $visto) {
  Write-Host "`nTimeout: nessun referto prodotto." -ForegroundColor Red
  Write-Host "Controlla la scheda ESPERTI di MT5, poi riprova in manuale (senza -Auto)." -ForegroundColor Red
  exit 1
}

Write-Host "`nChiudo MT5..." -ForegroundColor DarkGray
if ($TerminaleBacktest) {
  # --- CHIUSURA CHIRURGICA. Era qui la riga piu' pericolosa dello script:
  #  Get-Process -Name "terminal64" | Stop-Process -Force  ->  TUTTI.
  #  Adesso si chiude SOLO il processo il cui Path e' esattamente
  #  $Terminal, e si STAMPA chi resta vivo: la prova che il forward e il
  #  conto reale non sono stati toccati finisce nel referto.
  $selF = Scegli-Terminali -Processi @(Get-Process -Name "terminal64" -ErrorAction SilentlyContinue) -EsePath $Terminal
  Stampa-Terminali "  CHIUDO SOLO questo (terminale da backtest):" $selF.Bersagli "Yellow"
  Stampa-Terminali "  NON TOCCO questi (forward e conto reale):" $selF.Risparmiati "Green"
  if (@($selF.Bersagli).Count -gt 0) { @($selF.Bersagli) | Stop-Process -Force -ErrorAction SilentlyContinue }
  Start-Sleep -Seconds 3
  $dopo = Scegli-Terminali -Processi @(Get-Process -Name "terminal64" -ErrorAction SilentlyContinue) -EsePath $Terminal
  Write-Host "  --- PROVA, DOPO LA CHIUSURA ---" -ForegroundColor Cyan
  Stampa-Terminali "  ancora vivi (attesi: gli altri terminali, intatti):" $dopo.Risparmiati "Green"
  if (@($dopo.Bersagli).Count -gt 0) {
    Stampa-Terminali "  ATTENZIONE: il terminale da backtest e' ANCORA vivo:" $dopo.Bersagli "Yellow"
  }
} else {
  # 12/09/2026: QUI C'ERA IL KILL DI TUTTI I TERMINALI, conto REALE
  # 10105439 compreso. Il ramo e' IRRAGGIUNGIBILE da quando il ripiego
  # assegna il banco (unica assegnazione di $TerminaleBacktest: o assegna
  # o esce 1). Ma un ramo morto con l'arma ancora carica resta un'arma:
  # basta che domani qualcuno tolga quel blocco e questo torna a sparare,
  # in silenzio. Quindi l'arma si scarica e si lascia il rumore.
  Muori ("nessun -TerminaleBacktest, e qui NON si chiudono piu' TUTTI i terminali.`n" +
         "    Chiudere tutti vuol dire chiudere anche il conto REALE 10105439 mentre`n" +
         "    ha posizioni aperte -- e il 10/09 e' successo davvero.`n" +
         "    Se leggi questo messaggio, qualcuno ha tolto il ripiego sul banco:`n" +
         "    rimettilo, oppure passa -TerminaleBacktest a mano.")
}
Mostra-Referto

# =====================================================================
#  RACCOLTA SUL DESKTOP (regola delle righe di lancio, punto 2)
# ---------------------------------------------------------------------
#  MANCAVA, e il 15/08 e' costata a Claudio una caccia al file: il
#  referto finiva SOLO in <cartella dati>\MQL5\Files, cioe' sepolto
#  sotto %APPDATA%\MetaQuotes\Terminal\<codice lunghissimo>. Tutti gli
#  altri script del progetto raccolgono sul Desktop e fanno lo zip:
#  questo no. Adesso si'.
# =====================================================================
try {
  $dest = Join-Path ([Environment]::GetFolderPath("Desktop")) "storico_bcm"
  New-Item -ItemType Directory -Force -Path $dest | Out-Null
  if (Test-Path $CsvOut) { Copy-Item $CsvOut $dest -Force }
  $logDir = Join-Path $DataFolder "MQL5\Logs"
  if (Test-Path $logDir) {
    Get-ChildItem $logDir -Filter "*.log" -ErrorAction SilentlyContinue |
      Sort-Object LastWriteTime -Descending | Select-Object -First 2 |
      ForEach-Object { Copy-Item $_.FullName $dest -Force -ErrorAction SilentlyContinue }
  }
  $zip = Join-Path ([Environment]::GetFolderPath("Desktop")) "storico_bcm.zip"
  try { Compress-Archive -Path (Join-Path $dest "*") -DestinationPath $zip -Force } catch { }
  Write-Host ""
  Write-Host ("RACCOLTA: " + $dest) -ForegroundColor Green
  Write-Host ("ZIP PRONTO DA MANDARE: " + $zip) -ForegroundColor Green
  Write-Host "Verifica che dentro ci siano:" -ForegroundColor DarkGray
  Write-Host "   - ABTG_StoricoScaricato.csv" -ForegroundColor DarkGray
  Write-Host "   - gli ultimi 2 log di MT5 (*.log)" -ForegroundColor DarkGray
} catch {
  Write-Host ("La raccolta sul Desktop non e' riuscita: " + $_.Exception.Message) -ForegroundColor Yellow
  Write-Host ("Il referto resta comunque qui: " + $CsvOut) -ForegroundColor Yellow
}

Write-Host ""
Write-Host "La colonna che serve e' PrimaDataServer: e' la data VERA da cui" -ForegroundColor Cyan
Write-Host "parte lo storico, quella da passare a -DaQuando." -ForegroundColor Cyan
Write-Host "(sulle righe TICK PrimaDataServer vale sempre '-': li' si legge PrimaDataLocale)" -ForegroundColor Cyan

# --- UN TIMEOUT NON PUO' USCIRE 0 (checklist punto 19.2) -------------
#  Se "=== FINITO" non e' mai arrivato, MT5 e' stato fermato a meta':
#  il referto qui sopra e' PARZIALE. Si esce 2 DOPO la raccolta, cosi'
#  l'artefatto c'e' lo stesso e chi chiama decide (checklist 26-bis).
if (-not $finito) {
  Write-Host ""
  Write-Host "ATTENZIONE: la riga di chiusura '=== FINITO' non e' mai arrivata." -ForegroundColor Red
  Write-Host "MT5 e' stato fermato dal timeout: IL REFERTO E' PARZIALE." -ForegroundColor Red
  exit 2
}
