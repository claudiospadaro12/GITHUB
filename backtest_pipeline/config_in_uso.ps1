# =====================================================================
#  config_in_uso.ps1  --  CHE COSA STA DAVVERO GIRANDO, su ogni conto
# ---------------------------------------------------------------------
#  PERCHE' ESISTE (14/08/2026):
#  la mattina del 14/08 il DAX ha perso 1R su TUTTI E DUE i conti, ma
#  i due trade NON sono lo stesso trade:
#    conto 100k  -> commento "DAX Apertura EU RETEST BUY"  (BUY LIMIT)
#    conto piccolo -> commento "DAX Apertura EU BUY"       (BUY STOP)
#  Nel codice quelle due stringhe stanno in due rami diversi e non si
#  incrociano mai: la prima la scrive solo MonitorRetest(), la seconda
#  solo TryPlaceBreakout(). Quindi il conto piccolo ha operato col
#  motore BREAKOUT, cioe' quello bocciato dal walk-forward (R7, R25,
#  R42, R43: "sugli estremi del range non c'e' edge, paga solo il
#  RETEST"), mentre il 100k gira la cella validata.
#
#  Serviva un modo per rispondere alla domanda giusta - non "che cosa
#  dovrebbe girare" ma "che cosa gira" - su TUTTI i terminali insieme.
#  La riga CONFIG IN USO la scrive ogni EA della famiglia Apertura in
#  OnInit: c'e' dentro motore, range, buffer, offset, rischio, TP.
#
#  DIFFERENZA da log_ea.ps1: quello guarda UN giorno solo. La riga
#  CONFIG IN USO pero' si scrive solo all'avvio dell'EA, che puo'
#  essere di giorni fa. Qui si spazzolano TUTTI i log disponibili e si
#  tiene l'ULTIMA riga per ogni terminale + EA: quella e' la verita'
#  di adesso.
#
#  USO (sul VPS, MT5 puo' restare aperto - NON tocca niente):
#    powershell -ExecutionPolicy Bypass -File .\config_in_uso.ps1
#    powershell -ExecutionPolicy Bypass -File .\config_in_uso.ps1 -Filtro "Apertura"
#
#  ATTENZIONE ALLE ORE: le date dei log sono ORA LOCALE del PC (sul VPS
#  = ora italiana = server BCM + 1h). Non e' l'ora del grafico.
# =====================================================================
param(
  [string] $Filtro  = "",                       # regex extra sul testo della riga (vuoto = tutte)
  # 14/08, DOPO il primo lancio: era 30 e ha trovato UNA riga sola. Non
  # perche' giri un EA solo, ma perche' la riga CONFIG IN USO la scrive
  # solo chi si e' RIAVVIATO nel periodo guardato: un EA acceso da tre
  # mesi e mai toccato e' invisibile. 120 giorni li ripesca quasi tutti.
  [int]    $Giorni  = 120,                      # quanti giorni di log guardare indietro
  [switch] $Tutte                               # mostra TUTTE le righe, non solo l'ultima per EA
)
$ErrorActionPreference = "Continue"

$termRoot = Join-Path $env:APPDATA "MetaQuotes\Terminal"
if (-not (Test-Path $termRoot)) {
  Write-Host "Cartella MetaQuotes non trovata: $termRoot" -ForegroundColor Red
  exit 1
}

# --- MT5 scrive i log in UTF-16: con la codifica sbagliata non si trova niente ---
function Leggi-Log($path) {
  foreach ($enc in @("Unicode", "UTF8", "Default")) {
    try {
      $righe = Get-Content -Path $path -Encoding $enc -ErrorAction Stop
      if ($righe | Select-String -Pattern "\d{2}:\d{2}:\d{2}" -Quiet) { return $righe }
    } catch { }
  }
  return @()
}

# --- il numero di conto sta nel file di configurazione del terminale ---
#  Serve per dire "questa riga e' del conto piccolo" invece di
#  "questa riga e' della cartella 8F9A...". Se non si trova, pazienza:
#  si stampa comunque la cartella.
function Trova-Conto($dirTerminale) {
  $cand = @(
    (Join-Path $dirTerminale "config\accounts.ini"),
    (Join-Path $dirTerminale "config\common.ini")
  )
  foreach ($f in $cand) {
    if (-not (Test-Path $f)) { continue }
    foreach ($enc in @("Unicode", "UTF8", "Default")) {
      try {
        $t = Get-Content -Path $f -Encoding $enc -ErrorAction Stop
        $m = $t | Select-String -Pattern "Login\s*=\s*(\d{4,})" | Select-Object -First 1
        if ($m) { return $m.Matches[0].Groups[1].Value }
      } catch { }
    }
  }
  return ""
}

$limite = (Get-Date).AddDays(-$Giorni)
$out    = New-Object System.Collections.ArrayList
$tot    = 0

Write-Host "=== CONFIG IN USO - che cosa gira davvero ===" -ForegroundColor Cyan
Write-Host "    ultimi $Giorni giorni di log - ora LOCALE del PC (VPS = server BCM + 1h)" -ForegroundColor Gray
if ($Filtro) { Write-Host "    filtro extra: $Filtro" -ForegroundColor Gray }

foreach ($dir in (Get-ChildItem $termRoot -Directory -ErrorAction SilentlyContinue)) {
  $logDir = Join-Path $dir.FullName "MQL5\Logs"
  if (-not (Test-Path $logDir)) { continue }

  $conto = Trova-Conto $dir.FullName
  $etich = if ($conto) { "conto $conto" } else { "cartella $($dir.Name)" }

  # ultima riga vista per ogni EA (chiave = nome fra parentesi quadre)
  $ultima = @{}
  $ordine = New-Object System.Collections.ArrayList

  $files = @(Get-ChildItem $logDir -Filter "*.log" -ErrorAction SilentlyContinue |
             Where-Object { $_.LastWriteTime -ge $limite } |
             Sort-Object Name)
  foreach ($f in $files) {
    $righe = Leggi-Log $f.FullName
    if (-not $righe) { continue }
    foreach ($r in $righe) {
      if ($r -notmatch "CONFIG IN USO") { continue }
      if ($Filtro -and ($r -notmatch $Filtro)) { continue }
      $tot++
      # il nome dell'EA lo scrive ABTGLog fra parentesi quadre: [DAX Apertura EU]
      $nome = "?"
      if ($r -match "\[([^\]]+)\]") { $nome = $matches[1] }
      $riga = "{0}  {1}" -f $f.BaseName, $r.Trim()
      if ($Tutte) {
        if (-not $ordine.Contains($nome)) { [void]$ordine.Add($nome) }
        if (-not $ultima.ContainsKey($nome)) { $ultima[$nome] = New-Object System.Collections.ArrayList }
        [void]$ultima[$nome].Add($riga)
      } else {
        if (-not $ordine.Contains($nome)) { [void]$ordine.Add($nome) }
        $ultima[$nome] = $riga
      }
    }
  }

  if ($ordine.Count -eq 0) { continue }

  $intest = "`n--- $etich  ($($dir.Name)) ---"
  Write-Host $intest -ForegroundColor Yellow
  [void]$out.Add($intest)
  foreach ($nome in $ordine) {
    $v = $ultima[$nome]
    if ($v -is [System.Collections.ArrayList]) {
      foreach ($riga in $v) { Write-Host "  $riga"; [void]$out.Add("  $riga") }
    } else {
      Write-Host "  $v"; [void]$out.Add("  $v")
    }
  }
}

# --- referto SEMPRE scritto, anche a zero righe: il "non trovato" e' informazione ---
$dest = Join-Path $env:USERPROFILE "config_in_uso.txt"
if ($tot -eq 0) {
  Write-Host "`nNessuna riga CONFIG IN USO trovata negli ultimi $Giorni giorni." -ForegroundColor Yellow
  Write-Host "Vuol dire che nessun EA della famiglia Apertura si e' riavviato in questo periodo." -ForegroundColor Gray
  Write-Host "Prova con -Giorni 90." -ForegroundColor Gray
  [void]$out.Add("NESSUNA RIGA TROVATA (giorni guardati: $Giorni)")
  [void]$out.Add("Cartelle log viste:")
  foreach ($dir in (Get-ChildItem $termRoot -Directory -ErrorAction SilentlyContinue)) {
    $logDir = Join-Path $dir.FullName "MQL5\Logs"
    $n = 0
    if (Test-Path $logDir) { $n = @(Get-ChildItem $logDir -Filter "*.log" -EA SilentlyContinue).Count }
    [void]$out.Add(("   {0}  log: {1}" -f $dir.Name, $n))
  }
}
$out | Set-Content -Path $dest -Encoding ASCII

# --- raccolta sul Desktop + zip (regola delle righe di lancio) -------
#  Il Desktop si cerca in TRE modi: GetFolderPath puo' tornare vuoto
#  (Desktop reindirizzato, OneDrive, profilo di servizio) e allora non
#  usciva ne' lo zip ne' un motivo. E niente SilentlyContinue: un
#  fallimento muto e' peggio di un fallimento.
function Trova-Desktop {
  foreach ($p in @([Environment]::GetFolderPath("Desktop"),
                   (Join-Path $env:USERPROFILE "Desktop"),
                   (Join-Path $env:USERPROFILE "OneDrive\Desktop"))) {
    if ($p -and (Test-Path $p)) { return $p }
  }
  return $env:USERPROFILE
}
$desktop = Trova-Desktop
$cart = Join-Path $desktop "config_dax"
$zip   = Join-Path $desktop "config_dax.zip"
$zipOk = $false
$motivo = ""
try {
  if (Test-Path $cart) { Remove-Item $cart -Recurse -Force -ErrorAction Stop }
  New-Item -ItemType Directory -Path $cart -Force -ErrorAction Stop | Out-Null
  Copy-Item $dest $cart -Force -ErrorAction Stop
  if (Test-Path $zip) { Remove-Item $zip -Force -ErrorAction Stop }
  Compress-Archive -Path (Join-Path $cart "*") -DestinationPath $zip -Force -ErrorAction Stop
  $zipOk = Test-Path $zip
} catch {
  $motivo = $_.Exception.Message
}

Write-Host "`n!!! COSA QUESTO REFERTO NON PUO' DIRE !!!" -ForegroundColor Yellow
Write-Host "    Compare solo chi si e' RIAVVIATO negli ultimi $Giorni giorni." -ForegroundColor Gray
Write-Host "    Un EA acceso da mesi e mai toccato NON scrive CONFIG IN USO e" -ForegroundColor Gray
Write-Host "    quindi NON compare: assenza non vuol dire 'non gira'." -ForegroundColor Gray
Write-Host "    Per sapere chi e' ATTACCATO adesso: elenco_ea_attaccati.ps1" -ForegroundColor Gray

Write-Host "`n=== RACCOLTA ===" -ForegroundColor Cyan
Write-Host "  righe trovate : $tot"
Write-Host "  referto       : $dest"
if ($zipOk) {
  Write-Host "  zip da mandare: $zip" -ForegroundColor Green
  Write-Host "`nFile attesi nello zip (1):" -ForegroundColor Gray
  Get-ChildItem $cart -ErrorAction SilentlyContinue | ForEach-Object {
    Write-Host ("   {0}  ({1} byte)" -f $_.Name, $_.Length)
  }
} else {
  Write-Host "  ZIP NON CREATO" -ForegroundColor Yellow
  if ($motivo) { Write-Host ("  motivo        : " + $motivo) -ForegroundColor Red }
  Write-Host "  Desktop usato : $desktop" -ForegroundColor Gray
  Write-Host "  MANDAMI DIRETTAMENTE IL REFERTO QUI SOPRA: va bene uguale." -ForegroundColor Yellow
}
