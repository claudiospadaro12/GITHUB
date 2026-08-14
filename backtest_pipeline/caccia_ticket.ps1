# =====================================================================
#  caccia_ticket.ps1  --  DA QUALE MACCHINA E' PARTITO QUESTO ORDINE?
# ---------------------------------------------------------------------
#  PERCHE' ESISTE (14/08/2026, dalla pagella della sera)
#    Il trade peggiore del conto piccolo del 14/08 (DAX -104,60) e'
#    l'ordine #3160534, e il giornale del PC prova che l'ha piazzato
#    l'istanza NON autorizzata sul PC di backtest, non il VPS.
#    Guardando lo storico del magic 770101 sono saltate fuori altre DUE
#    perdite quasi identiche:
#         06/08  BUY   -102,96   ordine 3088160
#         10/08  SELL  -101,83   ordine 3109763
#         14/08  BUY   -104,60   ordine 3160534   <- gia' PROVATO
#    contro 12 trade dello stesso magic tutti fra +1,71 e +19,17.
#    Tutti e tre valgono circa il 2% di un conto da ~5.150, mentre le
#    vincite valgono lo 0,04-0,37%: il sospetto e' che siano la stessa
#    istanza fantasma, a rischio 2%. Ma il sospetto non e' una prova.
#
#  COME SI PROVA
#    Quando MT5 piazza un ordine scrive nel GIORNALE (logs\, non
#    MQL5\Logs\) una riga tipo:
#      '50503392': order #3160534 buy stop 2/2 D30EUR at 26479.00 done
#    Quella riga sta nel giornale della MACCHINA CHE HA PIAZZATO.
#    Quindi: si lancia questo script SU TUTTE E DUE LE MACCHINE (PC e
#    VPS) e si guarda dove compaiono i numeri.
#
#  ⚠️ IL CONTROLLO POSITIVO, ed e' la parte che rende valido il test:
#    fra i ticket cercati c'e' anche #3160534, di cui SAPPIAMO GIA' la
#    risposta (sta nel giornale del PC). Se lo script non trova nemmeno
#    quello sul PC, allora lo script e' rotto e le altre due risposte
#    non valgono niente. Senza controllo positivo, "non trovato" e'
#    ambiguo: puo' voler dire "non c'e'" oppure "non so cercare".
#
#  USO (non tocca NIENTE, MT5 puo' restare aperto, sicuro sul VPS):
#    powershell -ExecutionPolicy Bypass -File .\caccia_ticket.ps1
# =====================================================================
param(
  [string] $Ticket = "3088160,3109763,3160534",  # gli ultimi due sono da provare, il terzo e' il controllo positivo
  [string] $Simbolo = "D30EUR",                  # per il contesto della giornata
  [string] $Date   = "2026.08.06,2026.08.10,2026.08.14",
  [int]    $Giorni = 45                          # quanto indietro guardare nei log
)
$ErrorActionPreference = "Continue"

$termRoot = Join-Path $env:APPDATA "MetaQuotes\Terminal"
if (-not (Test-Path $termRoot)) {
  Write-Host "Cartella MetaQuotes non trovata: $termRoot" -ForegroundColor Red
  exit 1
}

# --- lettura CONDIVISA: MT5 tiene i log aperti in scrittura ----------
function Leggi-Bytes($path) {
  try {
    $fs = [IO.File]::Open($path, [IO.FileMode]::Open, [IO.FileAccess]::Read, [IO.FileShare]::ReadWrite)
    $b  = New-Object byte[] $fs.Length
    [void]$fs.Read($b, 0, $b.Length)
    $fs.Close()
    return $b
  } catch { return $null }
}
# --- i log MT5 sono UTF-16: col BOM FF FE il byte[1] vale 0xFE, non 0,
#     quindi l'euristica "byte dispari a zero" va usata DOPO il BOM ---
function Leggi-Testo($path) {
  $b = Leggi-Bytes $path
  if ($null -eq $b) { return "" }
  if ($b.Count -lt 4) { return "" }
  $utf16 = ($b[0] -eq 0xFF -and $b[1] -eq 0xFE)
  if (-not $utf16) {
    $zeri = 0; $n = [math]::Min(400, $b.Count)
    for ($i = 1; $i -lt $n; $i += 2) { if ($b[$i] -eq 0) { $zeri++ } }
    $utf16 = ($zeri -gt ($n/4))
  }
  if ($utf16) { return [Text.Encoding]::Unicode.GetString($b) }
  return [Text.Encoding]::UTF8.GetString($b)
}

function Trova-Desktop {
  $c = @()
  try { $c += [Environment]::GetFolderPath("Desktop") } catch {}
  $c += (Join-Path $env:USERPROFILE "Desktop")
  $c += (Join-Path $env:USERPROFILE "OneDrive\Desktop")
  foreach ($d in $c) { if ($d -and (Test-Path $d)) { return $d } }
  return $env:USERPROFILE
}

$out = New-Object System.Collections.ArrayList
function Riga($t, $col = "Gray") { Write-Host $t -ForegroundColor $col; [void]$out.Add($t) }

$tk    = @($Ticket -split "," | ForEach-Object { $_.Trim() } | Where-Object { $_ })
$dat   = @($Date   -split "," | ForEach-Object { $_.Trim() } | Where-Object { $_ })
$trovato = @{}
foreach ($t in $tk) { $trovato[$t] = 0 }

Riga "=== DA QUALE MACCHINA E' PARTITO L'ORDINE? ===" "Cyan"
Riga ("MACCHINA: " + $env:COMPUTERNAME + "   utente: " + $env:USERNAME) "Cyan"
Riga ("letto il  " + (Get-Date -Format "yyyy-MM-dd HH:mm:ss"))
Riga ("ticket cercati: " + ($tk -join ", "))
Riga "(l'ULTIMO della lista e' il CONTROLLO POSITIVO: sul PC DEVE uscire.)" "Yellow"
Riga ""

$limite = (Get-Date).AddDays(-$Giorni)
$nFile  = 0

foreach ($dir in (Get-ChildItem $termRoot -Directory -ErrorAction SilentlyContinue)) {
  $cartelle = @()
  foreach ($sub in @("logs", "MQL5\Logs")) {
    $p = Join-Path $dir.FullName $sub
    if (Test-Path $p) { $cartelle += ,@($sub, $p) }
  }
  if ($cartelle.Count -eq 0) { continue }

  $intestato = $false

  foreach ($c in $cartelle) {
    $etichetta = $c[0]   # "logs" = Giornale (il broker) · "MQL5\Logs" = Esperti (l'EA)
    $percorso  = $c[1]
    $files = @(Get-ChildItem $percorso -Filter "*.log" -ErrorAction SilentlyContinue |
               Where-Object { $_.LastWriteTime -ge $limite } | Sort-Object Name)
    foreach ($f in $files) {
      $txt = Leggi-Testo $f.FullName
      if (-not $txt) { continue }
      $nFile++
      $righe = $txt -split "`r?`n"
      foreach ($r in $righe) {
        $hit = $null
        foreach ($t in $tk) { if ($r -match ("#" + $t) -or $r -match ("\b" + $t + "\b")) { $hit = $t; break } }
        if ($hit) {
          if (-not $intestato) { Riga ("--- terminale " + $dir.Name + " ---") "Yellow"; $intestato = $true }
          $trovato[$hit] = $trovato[$hit] + 1
          Riga ("  [" + $etichetta + " " + $f.BaseName + "]  " + $r.Trim()) "Green"
        }
      }
    }
  }
}

Riga ""
Riga "=== RIEPILOGO SU QUESTA MACCHINA ===" "Cyan"
foreach ($t in $tk) {
  if ($trovato[$t] -gt 0) { Riga ("  #" + $t + " : TROVATO (" + $trovato[$t] + " righe)") "Green" }
  else                    { Riga ("  #" + $t + " : non trovato") "Red" }
}
Riga ("  (letti " + $nFile + " file di log negli ultimi " + $Giorni + " giorni)")
Riga ""

# --- il controllo positivo e' l'ULTIMO ticket della lista ------------
$ctrl = $tk[$tk.Count - 1]
if ($trovato[$ctrl] -gt 0) {
  Riga ("CONTROLLO POSITIVO OK: #" + $ctrl + " e' stato trovato, quindi lo script") "Green"
  Riga "sa cercare e i 'non trovato' qui sopra sono risposte VERE." "Green"
} else {
  Riga ("ATTENZIONE: il controllo positivo #" + $ctrl + " NON e' stato trovato.") "Red"
  Riga "Se sei sul PC, questo NON e' un risultato: vuol dire che i log sono" "Red"
  Riga "stati ruotati/cancellati oppure che sto guardando nel posto sbagliato." "Red"
  Riga "In quel caso le altre due righe NON provano niente. Se sei sul VPS," "Red"
  Riga "invece, e' l'esito atteso (quell'ordine e' partito dal PC)." "Yellow"
}
Riga ""

# =====================================================================
#  CONTESTO: cosa ha fatto questo terminale in quelle giornate
# =====================================================================
Riga ("=== CONTESTO: righe su " + $Simbolo + " nelle giornate sospette ===") "Cyan"
foreach ($d in $dat) {
  $stamp = $d -replace "\.", ""      # 2026.08.06 -> 20260806
  Riga ("--- " + $d + " (log " + $stamp + ") ---") "Yellow"
  $n = 0
  foreach ($dir in (Get-ChildItem $termRoot -Directory -ErrorAction SilentlyContinue)) {
    foreach ($sub in @("logs", "MQL5\Logs")) {
      $f = Join-Path $dir.FullName ($sub + "\" + $stamp + ".log")
      if (-not (Test-Path $f)) { continue }
      $txt = Leggi-Testo $f
      if (-not $txt) { continue }
      foreach ($r in ($txt -split "`r?`n")) {
        if ($r -match $Simbolo -and $r -match "(?i)(order|deal|buy|sell)") {
          Riga ("  [" + $dir.Name.Substring(0, [math]::Min(8, $dir.Name.Length)) + " " + $sub + "]  " + $r.Trim())
          $n++
        }
      }
    }
  }
  if ($n -eq 0) { Riga "  (nessuna riga: questo terminale non ha toccato il simbolo quel giorno)" }
  Riga ""
}

Riga "=== COME SI LEGGE ===" "Cyan"
Riga "Un ordine compare nel giornale della macchina CHE L'HA PIAZZATO."
Riga "  - trovato sul PC   -> quell'ordine e' partito dall'istanza del PC;"
Riga "  - trovato sul VPS  -> e' un trade regolare della flotta;"
Riga "  - trovato su TUTTI E DUE -> guarda l'ora: chi lo PIAZZA lo scrive"
Riga "    per primo, l'altro terminale lo vede solo come esecuzione."
Riga "Va lanciato su ENTRAMBE le macchine: una sola meta' non decide niente."

# =====================================================================
#  RACCOLTA SUL DESKTOP + ZIP
# =====================================================================
$desk = Trova-Desktop
$dest = Join-Path $desk "caccia_ticket"
if (Test-Path $dest) { Remove-Item $dest -Recurse -Force -ErrorAction SilentlyContinue }
New-Item -ItemType Directory -Force -Path $dest | Out-Null

$nome = "caccia_ticket_" + $env:COMPUTERNAME + ".txt"
$file = Join-Path $dest $nome
$out | Set-Content -Path $file -Encoding ASCII

$zip = Join-Path $desk "caccia_ticket.zip"
if (Test-Path $zip) { Remove-Item $zip -Force -ErrorAction SilentlyContinue }
Write-Host ""
Write-Host "    FILE ATTESO:" -ForegroundColor White
if (Test-Path $file) { Write-Host ("      OK      " + $nome) -ForegroundColor Green }
else                 { Write-Host ("      MANCA  " + $nome) -ForegroundColor Red }
try {
  Compress-Archive -Path (Join-Path $dest "*") -DestinationPath $zip -Force
  Write-Host ""
  Write-Host ("    ZIP PRONTO DA MANDARE:  " + $zip) -ForegroundColor Cyan
} catch {
  Write-Host ""
  Write-Host ("!!! lo zip NON e' stato creato: " + $_.Exception.Message) -ForegroundColor Red
  Write-Host ("    il referto comunque e' qui: " + $file) -ForegroundColor Yellow
}
Write-Host ""
Write-Host "    ORA RILANCIA LA STESSA RIGA SULL'ALTRA MACCHINA." -ForegroundColor Yellow
Write-Host "    Il nome del file ha dentro il computer, quindi i due referti" -ForegroundColor Gray
Write-Host "    non si sovrascrivono e si leggono affiancati." -ForegroundColor Gray
