# =====================================================================
#  censimento_ordini.ps1  --  TUTTI GLI ORDINI PIAZZATI DA QUESTA MACCHINA
# ---------------------------------------------------------------------
#  PERCHE' ESISTE (15/08/2026, subito dopo la caccia ai tre ticket)
#    caccia_ticket.ps1 ha risposto su TRE numeri: due erano del PC, uno
#    del VPS (report/CACCIA_TICKET_770101.md). Ma sul PC ci sono 52
#    file di giornale e, nei soli tre giorni guardati, 12 righe
#    "order #". La domanda giusta non e' piu' "quei tre trade di chi
#    erano", e':
#
#         QUANTI TRADE DEL CONTO VIVO NON SONO DEL PORTAFOGLIO?
#
#    Questo script non cerca numeri noti: ELENCA TUTTO. Ogni ordine che
#    QUESTA macchina ha piazzato, su qualunque conto, in tutto il
#    giornale disponibile.
#
#  COME FUNZIONA
#    Nel Giornale (logs\, non MQL5\Logs\) ci sono due righe diverse:
#      "order #N buy stop 2 / 2 D30EUR at 26479.00 done in 70.989 ms"
#          -> QUESTA macchina HA PIAZZATO l'ordine  (PIAZZATO)
#      "deal #M buy 2 D30EUR at 26479.00 done (based on order #N)"
#          -> qui si vede solo l'ESECUZIONE, fatta da chiunque (ESEGUITO)
#    Il terminale collegato al conto vede i deal di TUTTI; solo chi
#    piazza scrive "order ... done in N ms". E' la firma che decide, ed
#    e' quella che questo script separa in due colonne.
#
#  USO: si lancia su ENTRAMBE le macchine (PC e VPS), stessa riga.
#    Non tocca niente, MT5 puo' restare aperto, sicuro sul VPS.
#      powershell -ExecutionPolicy Bypass -File .\censimento_ordini.ps1
#    Esce un CSV col nome del computer dentro, quindi i due referti non
#    si sovrascrivono e si leggono affiancati.
# =====================================================================
param(
  [int]    $Giorni = 60,      # quanto indietro guardare nei giornali
  [string] $Conti  = "",      # vuoto = tutti; oppure "50503392,50504263"
  [string] $Simbolo = ""      # vuoto = tutti i simboli
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
# --- UTF-16: col BOM FF FE il byte[1] vale 0xFE, non 0 ---------------
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

$filtroConti = @($Conti -split "," | ForEach-Object { $_.Trim() } | Where-Object { $_ })

Write-Host "=== CENSIMENTO ORDINI - " $env:COMPUTERNAME " ===" -ForegroundColor Cyan
Write-Host ("utente: " + $env:USERNAME + "   letto il " + (Get-Date -Format "yyyy-MM-dd HH:mm:ss")) -ForegroundColor Cyan
Write-Host ("finestra: ultimi " + $Giorni + " giorni di giornale") -ForegroundColor DarkGray
Write-Host ""
Write-Host "ATTENZIONE alle ore: i log MT5 stanno in ORA LOCALE DI QUESTA" -ForegroundColor Yellow
Write-Host "MACCHINA, non in ora server. Su BCM il server e' un'ora indietro." -ForegroundColor Yellow
Write-Host ""

$righe   = New-Object System.Collections.ArrayList
$limite  = (Get-Date).AddDays(-$Giorni)
$nFile   = 0
$nPiazza = 0
$nDeal   = 0
$nAltro  = 0

# le tre forme che ci interessano, con i gruppi che servono
$reOrder  = "'(\d+)':\s*order\s*#(\d+)\s+(buy|sell)((?:\s+(?:stop|limit))*)\s+([\d.]+)\s*/\s*[\d.]+\s+(\S+)\s+at\s+([\d.]+)\s+done"
$reDeal   = "'(\d+)':\s*deal\s*#(\d+)\s+(buy|sell)\s+([\d.]+)\s+(\S+)\s+at\s+([\d.]+)\s+done\s*\(based on order\s*#(\d+)\)"
$reCancel = "'(\d+)':\s*cancel\s*#(\d+)\s+(buy|sell)((?:\s+(?:stop|limit))*)\s+([\d.]+)\s+(\S+)"
$reFail   = "'(\d+)':\s*failed\s+(.+)$"
$reOra    = "^\s*\S+\s+\d+\s+(\d{2}:\d{2}:\d{2})"

foreach ($dir in (Get-ChildItem $termRoot -Directory -ErrorAction SilentlyContinue)) {
  $giornale = Join-Path $dir.FullName "logs"
  if (-not (Test-Path $giornale)) { continue }
  $term = $dir.Name.Substring(0, [math]::Min(8, $dir.Name.Length))

  $files = @(Get-ChildItem $giornale -Filter "*.log" -ErrorAction SilentlyContinue |
             Where-Object { $_.LastWriteTime -ge $limite } | Sort-Object Name)
  foreach ($f in $files) {
    $txt = Leggi-Testo $f.FullName
    if (-not $txt) { continue }
    $nFile++
    $giorno = $f.BaseName    # AAAAMMGG
    foreach ($r in ($txt -split "`r?`n")) {
      if ($r -notmatch "'\d+':") { continue }

      $ora = ""
      if ($r -match $reOra) { $ora = $matches[1] }

      $rec = $null

      if ($r -match $reOrder) {
        $rec = [pscustomobject]@{
          macchina=$env:COMPUTERNAME; terminale=$term; giorno=$giorno; ora_locale=$ora
          conto=$matches[1]; ticket=$matches[2]; evento="PIAZZATO"
          tipo=($matches[3] + ($matches[4] -replace "\s+"," ")).Trim()
          volume=$matches[5]; simbolo=$matches[6]; prezzo=$matches[7]; ordine_rif=$matches[2] }
        $nPiazza++
      }
      elseif ($r -match $reDeal) {
        $rec = [pscustomobject]@{
          macchina=$env:COMPUTERNAME; terminale=$term; giorno=$giorno; ora_locale=$ora
          conto=$matches[1]; ticket=$matches[2]; evento="ESEGUITO"
          tipo=$matches[3]; volume=$matches[4]; simbolo=$matches[5]
          prezzo=$matches[6]; ordine_rif=$matches[7] }
        $nDeal++
      }
      elseif ($r -match $reCancel) {
        $rec = [pscustomobject]@{
          macchina=$env:COMPUTERNAME; terminale=$term; giorno=$giorno; ora_locale=$ora
          conto=$matches[1]; ticket=$matches[2]; evento="ANNULLATO"
          tipo=($matches[3] + ($matches[4] -replace "\s+"," ")).Trim()
          volume=$matches[5]; simbolo=$matches[6]; prezzo=""; ordine_rif=$matches[2] }
        $nAltro++
      }
      elseif ($r -match $reFail) {
        $rec = [pscustomobject]@{
          macchina=$env:COMPUTERNAME; terminale=$term; giorno=$giorno; ora_locale=$ora
          conto=$matches[1]; ticket=""; evento="FALLITO"
          tipo=($matches[2].Trim()); volume=""; simbolo=""; prezzo=""; ordine_rif="" }
        $nAltro++
      }

      if ($null -eq $rec) { continue }
      if ($filtroConti.Count -gt 0 -and -not $filtroConti.Contains($rec.conto)) { continue }
      if ($Simbolo -and $rec.simbolo -ne $Simbolo) { continue }
      [void]$righe.Add($rec)
    }
  }
}

Write-Host ("letti " + $nFile + " giornali:  PIAZZATI " + $nPiazza + "   eseguiti " + $nDeal + "   annullati/falliti " + $nAltro) -ForegroundColor White
Write-Host ""

# =====================================================================
#  RIEPILOGO A SCHERMO: solo i PIAZZATI, che sono la domanda
# =====================================================================
$piazzati = @($righe | Where-Object { $_.evento -eq "PIAZZATO" })

Write-Host "=== ORDINI PIAZZATI DA QUESTA MACCHINA, per conto ===" -ForegroundColor Cyan
if ($piazzati.Count -eq 0) {
  Write-Host "  NESSUNO. Questa macchina non ha piazzato ordini nella finestra guardata." -ForegroundColor Green
} else {
  foreach ($g in ($piazzati | Group-Object conto | Sort-Object Name)) {
    Write-Host ("  conto " + $g.Name + " : " + $g.Count + " ordini piazzati") -ForegroundColor Yellow
    foreach ($gg in ($g.Group | Group-Object giorno | Sort-Object Name)) {
      $simb = (($gg.Group | Select-Object -ExpandProperty simbolo -Unique) -join ",")
      Write-Host ("      " + $gg.Name + "  " + $gg.Count.ToString().PadLeft(3) + " ordini   [" + $simb + "]")
    }
  }
}
Write-Host ""

# =====================================================================
#  IL CSV: e' questo che va incrociato col CSV dei trade
# =====================================================================
$desk = Trova-Desktop
$dest = Join-Path $desk "censimento_ordini"
if (Test-Path $dest) { Remove-Item $dest -Recurse -Force -ErrorAction SilentlyContinue }
New-Item -ItemType Directory -Force -Path $dest | Out-Null

$nomeCsv = "ordini_" + $env:COMPUTERNAME + ".csv"
$fileCsv = Join-Path $dest $nomeCsv
$righe | Sort-Object giorno, ora_locale |
  Select-Object macchina,terminale,giorno,ora_locale,conto,ticket,evento,tipo,volume,simbolo,prezzo,ordine_rif |
  Export-Csv -Path $fileCsv -NoTypeInformation -Encoding ASCII -Delimiter ";"

$nomeTxt = "riepilogo_" + $env:COMPUTERNAME + ".txt"
$fileTxt = Join-Path $dest $nomeTxt
$rip = New-Object System.Collections.ArrayList
[void]$rip.Add("CENSIMENTO ORDINI - " + $env:COMPUTERNAME + " (utente " + $env:USERNAME + ")")
[void]$rip.Add("letto il " + (Get-Date -Format "yyyy-MM-dd HH:mm:ss") + "  -  ultimi " + $Giorni + " giorni")
[void]$rip.Add("giornali letti: " + $nFile)
[void]$rip.Add("PIAZZATI: " + $nPiazza + "   eseguiti: " + $nDeal + "   annullati/falliti: " + $nAltro)
[void]$rip.Add("")
[void]$rip.Add("NB: le ore sono ORA LOCALE di questa macchina, non ora server.")
[void]$rip.Add("")
foreach ($g in ($piazzati | Group-Object conto | Sort-Object Name)) {
  [void]$rip.Add("conto " + $g.Name + " : " + $g.Count + " ordini PIAZZATI da questa macchina")
  foreach ($gg in ($g.Group | Group-Object giorno | Sort-Object Name)) {
    $simb = (($gg.Group | Select-Object -ExpandProperty simbolo -Unique) -join ",")
    [void]$rip.Add("    " + $gg.Name + "  " + $gg.Count.ToString().PadLeft(3) + " ordini   [" + $simb + "]")
    foreach ($o in ($gg.Group | Sort-Object ora_locale)) {
      [void]$rip.Add("        #" + $o.ticket + "  " + $o.ora_locale + "  " + $o.tipo + " " + $o.volume + " " + $o.simbolo + " @ " + $o.prezzo)
    }
  }
  [void]$rip.Add("")
}
$rip | Set-Content -Path $fileTxt -Encoding ASCII

Write-Host "    FILE ATTESI (controllali uno per uno):" -ForegroundColor White
foreach ($n in @($nomeCsv, $nomeTxt)) {
  if (Test-Path (Join-Path $dest $n)) { Write-Host ("      OK      " + $n) -ForegroundColor Green }
  else { Write-Host ("      MANCA  " + $n) -ForegroundColor Red }
}

$zip = Join-Path $desk "censimento_ordini.zip"
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
Write-Host "    ORA RILANCIA LA STESSA RIGA SULL'ALTRA MACCHINA." -ForegroundColor Yellow
Write-Host "    Servono TUTTI E DUE i CSV: il confronto e' fra le due liste" -ForegroundColor Gray
Write-Host "    di PIAZZATI, e una sola meta' non decide niente." -ForegroundColor Gray
