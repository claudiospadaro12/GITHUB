# =====================================================================
#  conto_attivo.ps1  --  SU CHE CONTO E' COLLEGATO OGNI TERMINALE
# ---------------------------------------------------------------------
#  PERCHE' ESISTE (14/08/2026):
#  i referti di config_in_uso.ps1 e elenco_ea_attaccati.ps1 marcavano
#  ogni terminale col numero di conto letto da config\accounts.ini. Ma
#  li' dentro ci sono TUTTI i conti mai salvati su quel terminale, e la
#  funzione prendeva IL PRIMO: se il terminale ne ha memorizzati due,
#  l'etichetta puo' essere di un conto a cui non e' nemmeno collegato.
#  Claudio ha letto sul PC un numero diverso da quello del referto, e
#  l'intera conclusione ("il PC opera sul conto vivo") dipende da quale
#  dei due sia giusto. Non e' un dettaglio: e' la domanda.
#
#  La fonte VERA e' il GIORNALE (logs\AAAAMMGG.log, non MQL5\Logs): a
#  ogni collegamento MT5 ci scrive una riga con dentro
#    '50503392': login on <server>
#  L'ULTIMA di quelle righe e' il conto a cui il terminale e' collegato
#  adesso. accounts.ini resta come ripiego, ma dichiarato per quello
#  che e': l'elenco dei conti SALVATI, non quello attivo.
#
#  USO (su PC e VPS, non tocca niente, MT5 puo' restare aperto):
#    powershell -ExecutionPolicy Bypass -File .\conto_attivo.ps1
# =====================================================================
param(
  [int] $Giorni = 30      # quanti giorni di giornale guardare indietro
)
$ErrorActionPreference = "Continue"

$termRoot = Join-Path $env:APPDATA "MetaQuotes\Terminal"
if (-not (Test-Path $termRoot)) {
  Write-Host "Cartella MetaQuotes non trovata: $termRoot" -ForegroundColor Red
  exit 1
}

# MT5 scrive i log in UTF-16: con la codifica sbagliata non si trova niente
# --- lettura CONDIVISA (14/08/2026) ---------------------------------
#  [IO.File]::ReadAllBytes apre in lettura esclusiva: se MT5 e' aperto e
#  sta scrivendo il log, la chiamata fallisce con "il processo non puo'
#  accedere al file perche' e' in uso da un altro processo". E' successo
#  la sera del 14/08 sul terminale Pepperstone. Con FileShare::ReadWrite
#  si legge anche un file che qualcun altro tiene aperto in scrittura.
function Leggi-Bytes($path) {
  try {
    $fs = [IO.File]::Open($path, [IO.FileMode]::Open, [IO.FileAccess]::Read, [IO.FileShare]::ReadWrite)
    $b  = New-Object byte[] $fs.Length
    [void]$fs.Read($b, 0, $b.Length)
    $fs.Close()
    return $b
  } catch { return $null }
}

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

$out = New-Object System.Collections.ArrayList
function Riga($t, $col = "Gray") { Write-Host $t -ForegroundColor $col; [void]$out.Add($t) }

Riga "=== SU CHE CONTO E' COLLEGATO OGNI TERMINALE ===" "Cyan"
Riga ("MACCHINA: " + $env:COMPUTERNAME + "   utente: " + $env:USERNAME) "Cyan"
Riga ("letto il  " + (Get-Date -Format "yyyy-MM-dd HH:mm:ss"))
Riga ""

$limite = (Get-Date).AddDays(-$Giorni)

foreach ($dir in (Get-ChildItem $termRoot -Directory -ErrorAction SilentlyContinue)) {
  $giornale = Join-Path $dir.FullName "logs"
  $mql      = Join-Path $dir.FullName "MQL5\Logs"
  if (-not (Test-Path $giornale) -and -not (Test-Path $mql)) { continue }

  Riga ("--- cartella " + $dir.Name + " ---") "Yellow"

  # --- 1) IL CONTO ATTIVO: ultima riga di login nel GIORNALE ---------
  $attivo = ""
  $quando = ""
  $server = ""
  if (Test-Path $giornale) {
    $files = @(Get-ChildItem $giornale -Filter "*.log" -ErrorAction SilentlyContinue |
               Where-Object { $_.LastWriteTime -ge $limite } |
               Sort-Object Name)
    foreach ($f in $files) {
      $txt = Leggi-Testo $f.FullName
      if (-not $txt) { continue }
      $mm = [regex]::Matches($txt, "'(\d{5,})': (?:login|authorized) on ([^\r\n\(]+)")
      if ($mm.Count -gt 0) {
        $ultimo = $mm[$mm.Count - 1]
        $attivo = $ultimo.Groups[1].Value
        $server = $ultimo.Groups[2].Value.Trim()
        $quando = $f.BaseName
      }
    }
  }

  if ($attivo) {
    Riga ("  CONTO ATTIVO : " + $attivo + "    server: " + $server) "Green"
    Riga ("  (ultima riga di collegamento nel giornale del " + $quando + ")")
  } else {
    Riga "  CONTO ATTIVO : non trovato nel giornale degli ultimi $Giorni giorni." "Yellow"
    Riga "  Vuol dire che il terminale non si e' ricollegato in questo periodo." "Gray"
  }

  # --- 2) I CONTI SALVATI: quelli in accounts.ini --------------------
  #  Sono utili solo per capire se il terminale ne conosce piu' di uno:
  #  e' il caso in cui l'etichetta dei vecchi referti poteva sbagliare.
  $salvati = New-Object System.Collections.ArrayList
  foreach ($cfg in @((Join-Path $dir.FullName "config\accounts.ini"),
                     (Join-Path $dir.FullName "config\common.ini"))) {
    if (-not (Test-Path $cfg)) { continue }
    $txt = Leggi-Testo $cfg
    if (-not $txt) { continue }
    foreach ($m in [regex]::Matches($txt, "Login\s*=\s*(\d{5,})")) {
      $v = $m.Groups[1].Value
      if (-not $salvati.Contains($v)) { [void]$salvati.Add($v) }
    }
  }
  if ($salvati.Count -gt 0) {
    Riga ("  conti SALVATI: " + ($salvati -join ", "))
    if ($attivo -and ($salvati[0] -ne $attivo)) {
      Riga "  !! ATTENZIONE: il primo conto salvato NON e' quello attivo." "Red"
      Riga "     I referti vecchi etichettavano col primo salvato: erano sbagliati qui." "Red"
    }
  } else {
    Riga "  conti SALVATI: nessuno letto da accounts.ini"
  }

  # --- 3) quanti log ci sono, per capire se il terminale e' vivo -----
  $nMql = 0; $nGio = 0
  if (Test-Path $mql)      { $nMql = @(Get-ChildItem $mql      -Filter "*.log" -EA SilentlyContinue).Count }
  if (Test-Path $giornale) { $nGio = @(Get-ChildItem $giornale -Filter "*.log" -EA SilentlyContinue).Count }
  Riga ("  file di log  : esperti " + $nMql + "  giornale " + $nGio)
  Riga ""
}

$dest = Join-Path $env:USERPROFILE "conto_attivo.txt"
$out | Set-Content -Path $dest -Encoding ASCII

Write-Host "=== REFERTO ===" -ForegroundColor Cyan
Write-Host "  $dest" -ForegroundColor White
