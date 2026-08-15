# =====================================================================
#  raccogli_storico.ps1  --  TROVA il referto dello storico e lo METTE
#                            SUL DESKTOP, con lo zip pronto da mandare
# ---------------------------------------------------------------------
#  PERCHE' ESISTE (15/08/2026)
#    scarica_storico.ps1 scriveva il referto SOLO in
#      <cartella dati>\MQL5\Files\ABTG_StoricoScaricato.csv
#    cioe' sepolto sotto %APPDATA%\MetaQuotes\Terminal\<codice lunghissimo>.
#    Era l'unico script del progetto senza la raccolta sul Desktop (punto 2
#    della regola delle righe di lancio), e Claudio si e' trovato a cercare
#    un file che non sapeva dove fosse. Adesso scarica_storico raccoglie da
#    solo, ma per le corse GIA' FATTE serviva questo.
#
#  COSA FA
#    Cerca il referto in TUTTE le cartelle dati MT5 della macchina (ce n'e'
#    una per terminale), prende la copia PIU' RECENTE, la mette su
#    Desktop\storico_bcm insieme agli ultimi log, fa lo zip e stampa il
#    contenuto a schermo.
#
#  COSA NON FA
#    Non apre MT5, non scarica niente, non tocca nessun dato. Solo copie.
#
#  USO (PC di backtest o VPS, indifferente)
#    powershell -ExecutionPolicy Bypass -File .\raccogli_storico.ps1
# =====================================================================
param(
  [string] $Nome = "ABTG_StoricoScaricato.csv"
)
$ErrorActionPreference = "Continue"

function Riga($t, $c = "Gray") { Write-Host $t -ForegroundColor $c }

Riga "=== RACCOLGO IL REFERTO DELLO STORICO SUL DESKTOP ===" "Cyan"
Riga ("MACCHINA: " + $env:COMPUTERNAME + "   utente: " + $env:USERNAME) "Cyan"
Riga ""

# --- 1. dove cercare -------------------------------------------------
#  Le cartelle dati di MT5 stanno sotto %APPDATA%\MetaQuotes\Terminal,
#  una per terminale, con un nome che e' un codice esadecimale lungo.
#  Si guarda anche in Program Files, per le installazioni "portable".
$radici = @(
  (Join-Path $env:APPDATA "MetaQuotes\Terminal"),
  "C:\Program Files",
  "C:\Program Files (x86)"
) | Where-Object { Test-Path $_ }

Riga "1) cerco il referto" "Yellow"
$trovati = @()
foreach ($r in $radici) {
  $trovati += @(Get-ChildItem $r -Recurse -Filter $Nome -ErrorAction SilentlyContinue)
}

if ($trovati.Count -eq 0) {
  Riga ""
  Riga ("NON TROVATO da nessuna parte: " + $Nome) "Red"
  Riga "Vuol dire che la corsa non ha mai prodotto il referto." "Yellow"
  Riga "Cause tipiche, in ordine:" "Yellow"
  Riga "  - MT5 era ancora aperto (un'altra corsa in corso) e lo script si e' fermato" "Gray"
  Riga "  - lo script e' andato in timeout: guarda la scheda ESPERTI di MT5" "Gray"
  Riga "Rilancia scarica_storico.ps1 con MT5 CHIUSO." "Cyan"
  exit 1
}

$trovati = $trovati | Sort-Object LastWriteTime -Descending
foreach ($f in $trovati) {
  Riga ("   " + $f.FullName + "   (" + $f.LastWriteTime + ")") "Green"
}
$best = $trovati[0]
Riga ("   -> uso il piu' recente") "DarkGray"

# --- 2. raccolta -----------------------------------------------------
$dest = Join-Path ([Environment]::GetFolderPath("Desktop")) "storico_bcm"
New-Item -ItemType Directory -Force -Path $dest | Out-Null
Copy-Item $best.FullName $dest -Force

# gli ultimi log del terminale a cui appartiene il referto
$dataFolder = Split-Path (Split-Path $best.FullName -Parent) -Parent   # ...\MQL5
$logDir = Join-Path $dataFolder "Logs"
if (Test-Path $logDir) {
  Get-ChildItem $logDir -Filter "*.log" -ErrorAction SilentlyContinue |
    Sort-Object LastWriteTime -Descending | Select-Object -First 2 |
    ForEach-Object { Copy-Item $_.FullName $dest -Force -ErrorAction SilentlyContinue }
}

$zip = Join-Path ([Environment]::GetFolderPath("Desktop")) "storico_bcm.zip"
try { Compress-Archive -Path (Join-Path $dest "*") -DestinationPath $zip -Force } catch { }

# --- 3. e intanto lo stampa qui --------------------------------------
Riga ""
Riga "2) il referto (la colonna che serve e' PrimaDataServer)" "Yellow"
Riga ""
Get-Content $best.FullName | ForEach-Object { Write-Host ("   " + $_) -ForegroundColor White }

Riga ""
Riga ("RACCOLTA: " + $dest) "Green"
Riga ("ZIP PRONTO DA MANDARE: " + $zip) "Green"
Riga "Verifica che dentro ci siano:" "DarkGray"
Riga ("   - " + $Nome) "DarkGray"
Riga "   - gli ultimi 2 log di MT5 (*.log)" "DarkGray"
Riga ""
Riga "PrimaDataServer della riga GBPUSD = la data da passare a -DaQuando." "Cyan"
