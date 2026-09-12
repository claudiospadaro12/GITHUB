# ==========================================================================
#  MARCATORE_RIGA_SALVA_BROKER_ESTERNI_v1
#
#  SALVATAGGIO PRIMA DELLA DISINSTALLAZIONE -- Pepperstone + Tickmill
#  Richiesta di Claudio (12/09/2026): "ORA PROVO A DISINSTALLARE PEPPERSTON
#  E TICKMILL SE ESISTONO REALMENTE COSI NON ABBIAMO + PROBLEMI. OK?"
#
#  PERCHE' SERVE: sul terminale Tickmill esiste BREAKOUT_EA_JPY_v3.mq5
#  (v3.00, 1016 righe) che NEL REPO NON C'E' (il repo ha solo la v2.30 e la
#  Multi v2.40). Disinstallare senza salvare = perdere quel sorgente per
#  sempre. Misurato il 12/09 dai log di CODA_01 / CODA_06.
#
#  COSA FA: SOLO LETTURA sui due terminali esterni. Copia FUORI, sul Desktop,
#  i sorgenti .mq5, gli .ex5 rimasti orfani (senza sorgente), i preset .set e
#  i grafici .chr; stampa le sedie agganciate lette dai .chr; scrive un
#  referto e fa lo zip.
#
#  COSA NON FA: non scrive NIENTE dentro i due terminali, non li apre, non li
#  chiude, non tocca nessun processo. E RIFIUTA per nome le cartelle dati dei
#  quattro terminali BCM (50503392 / 50504263 / 10105439 / 50504400).
#
#  NIENTE EMOJI: questo file e' ASCII puro (PS 5.1 legge i .ps1 come ANSI).
# ==========================================================================

param(
  [string]$Pin = '',
  [switch]$SoloControllo
)

$ErrorActionPreference = 'Stop'
$INV = [System.Globalization.CultureInfo]::InvariantCulture
$t0  = Get-Date

# ---- i due bersagli, per NOME (mai "tutto cio' che non e' BCM") -----------
$BERSAGLI = @(
  'C:\Program Files\Pepperstone MetaTrader 5',
  'C:\Program Files\Tickmill Europe MT5 Terminal'
)

# ---- cio' che NON si tocca mai, per NOME ---------------------------------
$VIETATI = @('BCM Markets MT5 Terminal', 'BCM_Reale', 'MT5_Backtest', '-V3')

$Desktop = [Environment]::GetFolderPath('Desktop')
$stamp   = $t0.ToString('yyyyMMdd_HHmm', $INV)
$cart    = Join-Path $Desktop ('SALVA_BROKER_ESTERNI_' + $stamp)
$refPath = Join-Path $cart 'RIGA_REFERTO_SALVA_BROKER.txt'
$righe   = New-Object System.Collections.Generic.List[string]

function Nota([string]$s, [string]$col = 'Gray') {
  Write-Host $s -ForegroundColor $col
  $righe.Add($s) | Out-Null
}

function Referto() {
  if (-not (Test-Path -LiteralPath $cart)) { return }
  Set-Content -LiteralPath $refPath -Value $righe -Encoding ASCII
}

New-Item -ItemType Directory -Force -Path $cart | Out-Null

Nota '======================================================================'
Nota '  SALVATAGGIO BROKER ESTERNI -- SOLA LETTURA sui terminali'
Nota ('  data:   ' + $t0.ToString('yyyy-MM-dd HH:mm:ss', $INV))
Nota ('  pin:    ' + $(if ($Pin) { $Pin } else { '[non dichiarato]' }))
Nota ('  modo:   ' + $(if ($SoloControllo) { 'SOLO CONTROLLO (non copio niente)' } else { 'SALVATAGGIO' }))
Nota '======================================================================'

# ---- la macchina, in sola lettura: chi e' acceso adesso -------------------
Nota ''
Nota '--- TERMINALI ACCESI ADESSO (sola lettura, non ne tocco nessuno) ---' 'Cyan'
$proc = @(Get-Process terminal64 -ErrorAction SilentlyContinue)
if ($proc.Count -eq 0) {
  Nota '    nessun terminale MT5 acceso'
} else {
  foreach ($pr in $proc) {
    $pth = ''
    try { $pth = $pr.Path } catch { $pth = '[percorso non leggibile]' }
    Nota ('    PID ' + $pr.Id + '   ' + $pth)
  }
  Nota '    (restano tutti accesi: questa riga non chiude niente)' 'Green'
}

$root   = Join-Path $env:APPDATA 'MetaQuotes\Terminal'
$trovati = 0
$salvati = 0
$totMq5  = 0

foreach ($p in $BERSAGLI) {

  Nota ''
  Nota ('=== ' + $p) 'Cyan'

  if (-not (Test-Path -LiteralPath $p -PathType Container)) {
    Nota '    NON INSTALLATO su questa macchina: niente da salvare.' 'Yellow'
    continue
  }
  $trovati++

  # --- cancello 1: il bersaglio non deve essere un terminale BCM ----------
  $brutto = $false
  foreach ($v in $VIETATI) { if ($p -like ('*' + $v + '*')) { $brutto = $true } }
  if ($brutto) {
    Nota '    RIFIUTO: questo percorso somiglia a un terminale BCM. NON TOCCO.' 'Red'
    continue
  }

  # --- la cartella dati si RISOLVE da origin.txt, non si indovina ---------
  $dati = @(Get-ChildItem -LiteralPath $root -Directory -ErrorAction SilentlyContinue | Where-Object {
    $o = Join-Path $_.FullName 'origin.txt'
    (Test-Path -LiteralPath $o) -and ((Get-Content -LiteralPath $o -Raw -ErrorAction SilentlyContinue).Trim() -ieq $p)
  })

  if ($dati.Count -ne 1) {
    Nota ('    cartella dati: trovate ' + $dati.Count + ' corrispondenze in origin.txt -- AMBIGUO, NON SALVO DA QUI.') 'Red'
    Nota '    (dimmelo: si risolve a mano, non a indovinare)' 'Red'
    continue
  }
  $d = $dati[0].FullName

  # --- cancello 2: la cartella dati risolta non deve essere di un BCM -----
  $orig = (Get-Content -LiteralPath (Join-Path $d 'origin.txt') -Raw).Trim()
  $brutto2 = $false
  foreach ($v in $VIETATI) { if ($orig -like ('*' + $v + '*')) { $brutto2 = $true } }
  if ($brutto2) {
    Nota ('    RIFIUTO: origin.txt della cartella dati dice ' + $orig + ' -- e'' un BCM. NON TOCCO.') 'Red'
    continue
  }

  Nota ('    cartella dati: ' + $d)
  Nota ('    origin.txt:    ' + $orig)

  if ($SoloControllo) {
    Nota '    SOLO CONTROLLO: mi fermo qui, non copio niente.' 'Yellow'
    continue
  }

  $nome = (Split-Path $p -Leaf) -replace '[^A-Za-z0-9]', '_'
  $dst  = Join-Path $cart $nome
  New-Item -ItemType Directory -Force -Path $dst | Out-Null

  # --- i sorgenti, con la struttura di cartelle conservata ---------------
  $mq5Nomi = New-Object System.Collections.Generic.HashSet[string]
  foreach ($sub in @('Experts', 'Indicators', 'Include', 'Scripts', 'Libraries')) {
    $src = Join-Path $d ('MQL5\' + $sub)
    if (-not (Test-Path -LiteralPath $src)) { continue }
    $f = @(Get-ChildItem -LiteralPath $src -Recurse -File -ErrorAction SilentlyContinue | Where-Object { $_.Extension -in @('.mq5', '.mqh') })
    foreach ($x in $f) {
      $rel = $x.FullName.Substring($src.Length).TrimStart('\')
      $out = Join-Path (Join-Path $dst $sub) $rel
      New-Item -ItemType Directory -Force -Path (Split-Path $out -Parent) | Out-Null
      Copy-Item -LiteralPath $x.FullName -Destination $out -Force
      $mq5Nomi.Add($x.BaseName.ToLowerInvariant()) | Out-Null
    }
    if ($f.Count -gt 0) { Nota ('    ' + $sub + ': ' + $f.Count + ' sorgenti salvati') 'Green' }
    $totMq5 += $f.Count
  }

  # --- gli .ex5 ORFANI: un EA senza sorgente, se lo perdi, e' perso ------
  $orfani = 0
  foreach ($sub in @('Experts', 'Indicators')) {
    $src = Join-Path $d ('MQL5\' + $sub)
    if (-not (Test-Path -LiteralPath $src)) { continue }
    $e = @(Get-ChildItem -LiteralPath $src -Recurse -File -Filter '*.ex5' -ErrorAction SilentlyContinue)
    foreach ($x in $e) {
      if ($mq5Nomi.Contains($x.BaseName.ToLowerInvariant())) { continue }
      $out = Join-Path (Join-Path $dst 'EX5_SENZA_SORGENTE') ($sub + '_' + $x.Name)
      New-Item -ItemType Directory -Force -Path (Split-Path $out -Parent) | Out-Null
      Copy-Item -LiteralPath $x.FullName -Destination $out -Force
      $orfani++
    }
  }
  if ($orfani -gt 0) { Nota ('    EX5 SENZA SORGENTE: ' + $orfani + ' compilati salvati (sorgente non presente)') 'Yellow' }

  # --- i preset: sono i PARAMETRI, valgono quanto il codice --------------
  $ps = Join-Path $d 'MQL5\Presets'
  if (Test-Path -LiteralPath $ps) {
    $s = @(Get-ChildItem -LiteralPath $ps -Recurse -File -Filter '*.set' -ErrorAction SilentlyContinue)
    foreach ($x in $s) {
      $out = Join-Path (Join-Path $dst 'Presets') $x.Name
      New-Item -ItemType Directory -Force -Path (Split-Path $out -Parent) | Out-Null
      Copy-Item -LiteralPath $x.FullName -Destination $out -Force
    }
    if ($s.Count -gt 0) { Nota ('    Presets: ' + $s.Count + ' file .set salvati') 'Green' }
  }

  # --- i grafici, e le SEDIE che ci stanno sopra -------------------------
  $pr = Join-Path $d 'MQL5\Profiles\Charts'
  if (Test-Path -LiteralPath $pr) {
    $ch = @(Get-ChildItem -LiteralPath $pr -Recurse -File -Filter '*.chr' -ErrorAction SilentlyContinue)
    foreach ($x in $ch) {
      $out = Join-Path (Join-Path $dst 'Profili') ($x.Directory.Name + '__' + $x.Name)
      New-Item -ItemType Directory -Force -Path (Split-Path $out -Parent) | Out-Null
      Copy-Item -LiteralPath $x.FullName -Destination $out -Force
    }
    Nota ('    grafici: ' + $ch.Count + ' file .chr salvati') 'Green'

    Nota '    --- SEDIE ATTACCATE (lette dai .chr, sola lettura) ---' 'Cyan'
    $sedie = 0
    foreach ($x in $ch) {
      $t = Get-Content -LiteralPath $x.FullName -Raw -ErrorAction SilentlyContinue
      if (-not $t) { continue }
      $m = [regex]::Match($t, '(?s)<expert>(.*?)</expert>')
      while ($m.Success) {
        $blocco = $m.Groups[1].Value
        $mn = [regex]::Match($blocco, '(?m)^\s*name=([^\r\n]+)')
        $ms = [regex]::Match($blocco, '(?m)^\s*symbol=([^\r\n]+)')
        $mp = [regex]::Match($blocco, '(?m)^\s*period=([^\r\n]+)')
        $mg = [regex]::Match($blocco, '(?mi)^\s*[A-Za-z_]*Magic[A-Za-z_]*\s*=\s*([0-9]+)')
        if ($mn.Success) {
          $nm = $mn.Groups[1].Value.Trim()
          $sy = if ($ms.Success) { $ms.Groups[1].Value.Trim() } else { '-' }
          $pe = if ($mp.Success) { $mp.Groups[1].Value.Trim() } else { '-' }
          $ma = if ($mg.Success) { $mg.Groups[1].Value } else { '-' }
          Nota ('      ' + $nm + '   ' + $sy + '   periodo ' + $pe + '   magic ' + $ma + '   [' + $x.Directory.Name + '/' + $x.Name + ']') 'White'
          $sedie++
        }
        $m = $m.NextMatch()
      }
    }
    if ($sedie -eq 0) { Nota '      nessuna sedia agganciata su questo terminale' 'Yellow' }
  }

  $salvati++
}

# ---- la raccolta: elenco file, referto, zip ------------------------------
Nota ''
Nota '--- QUELLO CHE C''E'' NELLA CARTELLA ---' 'Cyan'
$tuttiFile = @(Get-ChildItem -LiteralPath $cart -Recurse -File -ErrorAction SilentlyContinue)
foreach ($g in ($tuttiFile | Group-Object DirectoryName | Sort-Object Name)) {
  Nota ('    ' + $g.Count.ToString().PadLeft(4) + ' file  in  ' + $g.Name)
}
Nota ('    TOTALE: ' + $tuttiFile.Count + ' file, di cui ' + $totMq5 + ' sorgenti')

$esito = 'COMPLETO'
if ($SoloControllo)            { $esito = 'SOLO CONTROLLO' }
elseif ($trovati -eq 0)        { $esito = 'NIENTE DA SALVARE: nessuno dei due terminali e'' installato' }
elseif ($salvati -lt $trovati) { $esito = 'PARZIALE: ' + $salvati + ' salvati su ' + $trovati + ' installati' }

Nota ''
Nota ('terminali installati trovati: ' + $trovati + ' su ' + $BERSAGLI.Count)
Nota ('terminali salvati:            ' + $salvati)
Nota ('esito: ' + $esito)
Nota ('fine:  ' + (Get-Date).ToString('yyyy-MM-dd HH:mm:ss', $INV))
Nota ''
Nota 'NON e'' stato modificato niente nei due terminali: solo letti e copiati fuori.' 'Green'
Nota 'NESSUN terminale BCM (50503392 / 50504263 / 10105439 / 50504400) e'' stato aperto, letto o toccato.' 'Green'

Referto

$zip = $cart + '.zip'
Remove-Item -LiteralPath $zip -Force -ErrorAction SilentlyContinue
$statoZip = 'NON FATTO'
try {
  Compress-Archive -Path (Join-Path $cart '*') -DestinationPath $zip -Force -ErrorAction Stop
  $statoZip = 'FATTO'
} catch {
  $statoZip = 'FALLITO: ' + $_.Exception.Message
}
Add-Content -LiteralPath $refPath -Value ('zip: ' + $statoZip) -Encoding ASCII

Write-Host ''
if ($statoZip -eq 'FATTO') {
  Write-Host ('MANDA IN CHAT QUESTO FILE: ' + $zip) -ForegroundColor Cyan
} else {
  Write-Host ('ZIP ' + $statoZip) -ForegroundColor Yellow
  Write-Host ('MANDAMI QUESTA CARTELLA: ' + $cart) -ForegroundColor Yellow
}
Write-Host ('REFERTO: ' + $refPath) -ForegroundColor Gray

if ($SoloControllo)            { exit 0 }
if ($trovati -eq 0)            { exit 1 }
if ($salvati -lt $trovati)     { exit 2 }
exit 0
