# ==========================================================================
#  MARCATORE_RIGA_CENSIMENTO_MT5_MACCHINA_v1
#
#  CHE MACCHINA E' QUESTA, E QUANTI MT5 CI SONO DAVVERO -- SOLA LETTURA
#
#  Nato il 12/09/2026 dallo screenshot di Claudio ("Programmi e funzionalita'")
#  e da tre fatti che non tornavano:
#
#  1) La lista del Pannello di controllo mostra UN SOLO "BCM Markets MT5
#     Terminal". Noi ne abbiamo MISURATI QUATTRO, in quattro cartelle
#     diverse (50503392, 50504263 in '... -V3', 10105439 in C:\BCM_Reale,
#     50504400 in C:\MT5_Backtest). Quindi il Pannello di controllo NON E'
#     UN CENSIMENTO degli MT5: le copie e i portable non ci compaiono.
#     Conseguenza diretta: "TICKMILL NON LO VEDO" non vuol dire "non c'e'".
#
#  2) Nella lista c'e' "FTMO Global Markets MT5 Terminal", installato il
#     27/08/2026. In NESSUN nostro censimento di terminali risulta. FTMO nel
#     repo appare 206 volte, ma sempre come PROP FIRM (regole, METRO_PROP),
#     mai come terminale installato.
#
#  3) I referti mettono Pepperstone e Tickmill SUL VPS (sei cartelle dati).
#     Lo screenshot sembra un'altra macchina. Una delle due cose e' sbagliata,
#     e non si indovina: si stampa il nome del computer.
#
#  COSA FA: legge. Nome macchina, tipo di sessione (console o Desktop
#  remoto), presenza di batteria; poi TUTTI i terminal64.exe trovati SUL
#  DISCO, tutte le cartelle dati, e per ognuna il conto e il server letti dai
#  giornali e dai config -- SENZA APRIRE NESSUN TERMINALE.
#
#  COSA NON FA: non apre, non chiude, non installa, non disinstalla, non
#  scrive niente dentro nessuna cartella di MT5, non tocca nessun processo.
#  Scrive SOLO nella cartella di raccolta sul Desktop.
#
#  PERCHE' NON APRE NIENTE: su Tickmill risultano DUE sedie attaccate. Aprire
#  quel terminale potrebbe farle partire. Si legge da disco, e basta.
#
#  NIENTE EMOJI: questo file e' ASCII puro (PS 5.1 legge i .ps1 come ANSI).
# ==========================================================================

param(
  [string]$Pin = '',
  [int]$Profondita = 3
)

$ErrorActionPreference = 'Stop'
$INV = [System.Globalization.CultureInfo]::InvariantCulture
$t0  = Get-Date

# ---- i quattro BCM noti, per NOME: non si toccano mai -------------------
$NOTI = @{
  'C:\Program Files\BCM Markets MT5 Terminal'      = '50503392  demo piccolo'
  'C:\Program Files\BCM Markets MT5 Terminal -V3'  = '50504263  dry-run 100k'
  'C:\BCM_Reale'                                   = '10105439  CONTO REALE'
  'C:\MT5_Backtest'                                = '50504400  banco backtest'
}

$Desktop = [Environment]::GetFolderPath('Desktop')
$cart    = Join-Path $Desktop ('CENSIMENTO_MT5_' + $t0.ToString('yyyyMMdd_HHmm', $INV))
$refPath = Join-Path $cart 'REFERTO_CENSIMENTO_MT5.txt'
$righe   = New-Object System.Collections.Generic.List[string]

function Nota([string]$s, [string]$col = 'Gray') {
  Write-Host $s -ForegroundColor $col
  $righe.Add($s) | Out-Null
}

New-Item -ItemType Directory -Force -Path $cart | Out-Null

Nota '======================================================================'
Nota '  CENSIMENTO MT5 DELLA MACCHINA -- SOLA LETTURA'
Nota ('  data: ' + $t0.ToString('yyyy-MM-dd HH:mm:ss', $INV))
Nota ('  pin:  ' + $(if ($Pin) { $Pin } else { '[non dichiarato]' }))
Nota '======================================================================'

# ======================================================================
#  1. CHE MACCHINA E' QUESTA
# ======================================================================
Nota ''
Nota '=== 1. CHE MACCHINA E'' QUESTA ===' 'Cyan'
Nota ('    nome computer   : ' + $env:COMPUTERNAME)
Nota ('    utente          : ' + $env:USERNAME)

$sess = $env:SESSIONNAME
if (-not $sess) { $sess = '[non impostato]' }
$viaRdp = ($sess -like 'RDP*')
Nota ('    sessione        : ' + $sess + $(if ($viaRdp) { '   -> sei collegato via DESKTOP REMOTO: questa finestra gira sulla macchina REMOTA (il VPS)' } else { '   -> sessione CONSOLE: questa finestra gira sulla macchina che hai davanti' }))

try {
  $cs = Get-CimInstance Win32_ComputerSystem -ErrorAction Stop
  Nota ('    marca/modello   : ' + $cs.Manufacturer + ' / ' + $cs.Model)
  Nota ('    processori      : ' + $cs.NumberOfLogicalProcessors + ' logici')
  Nota ('    RAM             : ' + [math]::Round($cs.TotalPhysicalMemory / 1GB, 1) + ' GB')
} catch {
  Nota ('    marca/modello   : [non leggibile: ' + $_.Exception.Message + ']') 'Yellow'
}

try {
  $bat = @(Get-CimInstance Win32_Battery -ErrorAction SilentlyContinue)
  if ($bat.Count -gt 0) {
    Nota ('    batteria        : SI (' + $bat.Count + ') -> e'' un PORTATILE, non un VPS') 'Yellow'
  } else {
    Nota '    batteria        : NESSUNA -> coerente con un VPS o un desktop fisso'
  }
} catch {
  Nota '    batteria        : [non leggibile]' 'Yellow'
}

try {
  $os = Get-CimInstance Win32_OperatingSystem -ErrorAction Stop
  Nota ('    Windows         : ' + $os.Caption + '  (build ' + $os.BuildNumber + ')')
  Nota ('    accesa da       : ' + $os.LastBootUpTime.ToString('yyyy-MM-dd HH:mm', $INV))
} catch { }

Nota ''
Nota '    LO DICO CHIARO: se "sessione" dice RDP sei DENTRO il VPS e stai' 'Yellow'
Nota '    censendo il VPS. Se dice Console stai censendo la macchina che hai' 'Yellow'
Nota '    davanti. Per sapere tutto servono DUE corse, una per macchina.' 'Yellow'

# ======================================================================
#  2. TUTTI I terminal64.exe SUL DISCO (non dal Pannello di controllo)
# ======================================================================
Nota ''
Nota '=== 2. TUTTI I terminal64.exe TROVATI SUL DISCO ===' 'Cyan'
Nota '    (il Pannello di controllo non vede le copie e i portable:'
Nota '     mostra UN BCM, e noi ne abbiamo misurati QUATTRO)'

$radici = @(
  'C:\',
  $env:ProgramFiles,
  ${env:ProgramFiles(x86)},
  $env:LOCALAPPDATA,
  $env:USERPROFILE
) | Where-Object { $_ -and (Test-Path -LiteralPath $_) } | Select-Object -Unique

$exe = New-Object System.Collections.Generic.List[string]
foreach ($r in $radici) {
  Nota ('    cerco sotto: ' + $r + '  (profondita'' ' + $Profondita + ')') 'DarkGray'
  $trovati = @(Get-ChildItem -LiteralPath $r -Filter 'terminal64.exe' -File -Recurse -Depth $Profondita -ErrorAction SilentlyContinue)
  foreach ($f in $trovati) {
    if (-not $exe.Contains($f.FullName)) { $exe.Add($f.FullName) | Out-Null }
  }
}

$vivi = @{}
foreach ($pr in @(Get-Process terminal64 -ErrorAction SilentlyContinue)) {
  try { if ($pr.Path) { $vivi[$pr.Path] = $pr.Id } } catch { }
}

Nota ''
Nota ('    TROVATI ' + $exe.Count + ' terminal64.exe') 'Green'
foreach ($x in ($exe | Sort-Object)) {
  $dir = Split-Path $x -Parent
  $ver = ''
  $dta = ''
  try {
    $fi = Get-Item -LiteralPath $x
    $dta = $fi.LastWriteTime.ToString('yyyy-MM-dd', $INV)
    $ver = $fi.VersionInfo.FileVersion
  } catch { }
  $etichetta = '[ESTERNO / NON IN MAPPA]'
  foreach ($k in $NOTI.Keys) { if ($dir -ieq $k) { $etichetta = '[NOTO: ' + $NOTI[$k] + ']' } }
  $acceso = if ($vivi.ContainsKey($x)) { '   ACCESO ADESSO, PID ' + $vivi[$x] } else { '   spento' }
  $portable = if (Test-Path -LiteralPath (Join-Path $dir 'MQL5')) { '   PORTABLE (dati dentro la cartella programma)' } else { '' }
  Nota ''
  Nota ('    ' + $dir) 'White'
  Nota ('       ' + $etichetta + $acceso + $portable)
  Nota ('       versione ' + $ver + '   file del ' + $dta)
  if (Test-Path -LiteralPath (Join-Path $dir 'MQL5\Profiles\Charts')) {
    $nch = @(Get-ChildItem -LiteralPath (Join-Path $dir 'MQL5\Profiles\Charts') -Recurse -File -Filter '*.chr' -ErrorAction SilentlyContinue).Count
    Nota ('       grafici .chr qui dentro: ' + $nch)
  }
}

# ======================================================================
#  3. LE CARTELLE DATI, E CHE CONTO C'E' DENTRO
# ======================================================================
Nota ''
Nota '=== 3. LE CARTELLE DATI IN APPDATA, E CHE CONTO HANNO DENTRO ===' 'Cyan'

$root = Join-Path $env:APPDATA 'MetaQuotes\Terminal'
if (-not (Test-Path -LiteralPath $root)) {
  Nota ('    NON ESISTE ' + $root + ' -- nessuna cartella dati in APPDATA') 'Yellow'
} else {
  $dirs = @(Get-ChildItem -LiteralPath $root -Directory -ErrorAction SilentlyContinue)
  Nota ('    cartelle dati trovate: ' + $dirs.Count)

  foreach ($d in $dirs) {
    $o = Join-Path $d.FullName 'origin.txt'
    $orig = '[nessun origin.txt]'
    if (Test-Path -LiteralPath $o) {
      try { $orig = (Get-Content -LiteralPath $o -Raw -ErrorAction SilentlyContinue).Trim() } catch { }
    }
    $etichetta = '[ESTERNO / NON IN MAPPA]'
    foreach ($k in $NOTI.Keys) { if ($orig -ieq $k) { $etichetta = '[NOTO: ' + $NOTI[$k] + ']' } }

    Nota ''
    Nota ('    ' + $d.Name) 'White'
    Nota ('       origin.txt : ' + $orig)
    Nota ('       verdetto   : ' + $etichetta)

    # --- il conto e il server, dai GIORNALI (non si apre niente) --------
    $conto  = '[NON TROVATO nei giornali]'
    $server = ''
    $ultimo = '[nessun giornale]'
    $nlog   = 0
    foreach ($sotto in @('logs', 'MQL5\Logs')) {
      $lp = Join-Path $d.FullName $sotto
      if (-not (Test-Path -LiteralPath $lp)) { continue }
      $lg = @(Get-ChildItem -LiteralPath $lp -File -Filter '*.log' -ErrorAction SilentlyContinue | Sort-Object LastWriteTime -Descending)
      $nlog += $lg.Count
      if ($lg.Count -gt 0 -and $ultimo -eq '[nessun giornale]') {
        $ultimo = $lg[0].LastWriteTime.ToString('yyyy-MM-dd HH:mm', $INV) + '   (' + $lg[0].Name + ')'
      }
      foreach ($f in ($lg | Select-Object -First 5)) {
        $m = @(Select-String -LiteralPath $f.FullName -Pattern "'([0-9]{4,12})'\s*:\s*(?:authorized|previous successful|login)" -AllMatches -ErrorAction SilentlyContinue)
        if ($m.Count -gt 0) {
          $ult = $m[$m.Count - 1]
          $conto = $ult.Matches[$ult.Matches.Count - 1].Groups[1].Value
          $ms = [regex]::Match($ult.Line, '(?:authorized on|to)\s+([A-Za-z0-9_\-\. ]+)')
          if ($ms.Success) { $server = $ms.Groups[1].Value.Trim() }
          break
        }
      }
      if ($conto -notlike '*NON TROVATO*') { break }
    }
    Nota ('       giornali   : ' + $nlog + ' file, il piu'' recente del ' + $ultimo)
    Nota ('       CONTO      : ' + $conto + $(if ($server) { '   su server ' + $server } else { '' })) $(if ($conto -like '*NON TROVATO*') { 'Yellow' } else { 'Green' })

    # --- e se i giornali non lo dicono, i config ------------------------
    if ($conto -like '*NON TROVATO*') {
      $cfg = Join-Path $d.FullName 'config'
      if (Test-Path -LiteralPath $cfg) {
        $vis = @(Get-ChildItem -LiteralPath $cfg -File -Filter '*.ini' -ErrorAction SilentlyContinue)
        $dette = 0
        foreach ($f in $vis) {
          foreach ($l in @(Select-String -LiteralPath $f.FullName -Pattern '^(Login|Server|Company|Name)\s*=' -ErrorAction SilentlyContinue)) {
            Nota ('       config     : ' + $f.Name + ' -> ' + $l.Line.Trim())
            $dette++
          }
        }
        if ($dette -eq 0) {
          Nota ('       config     : ' + $vis.Count + ' file .ini, nessuna riga Login/Server dentro') 'Yellow'
          Nota '       ATTENZIONE: "non trovato" qui vuol dire NON LEGGIBILE DA DISCO,' 'Yellow'
          Nota '       non "conto inesistente". Sono due cose diverse.' 'Yellow'
        }
      }
    }

    # --- le sedie, lette dai .chr (sola lettura) -----------------------
    $pr = Join-Path $d.FullName 'MQL5\Profiles\Charts'
    if (Test-Path -LiteralPath $pr) {
      $ch = @(Get-ChildItem -LiteralPath $pr -Recurse -File -Filter '*.chr' -ErrorAction SilentlyContinue)
      $sedie = New-Object System.Collections.Generic.List[string]
      foreach ($x in $ch) {
        $t = Get-Content -LiteralPath $x.FullName -Raw -ErrorAction SilentlyContinue
        if (-not $t) { continue }
        $m = [regex]::Match($t, '(?s)<expert>(.*?)</expert>')
        while ($m.Success) {
          $b = $m.Groups[1].Value
          $mn = [regex]::Match($b, '(?m)^\s*name=([^\r\n]+)')
          $ms2 = [regex]::Match($b, '(?m)^\s*symbol=([^\r\n]+)')
          if ($mn.Success) {
            $sy = if ($ms2.Success) { $ms2.Groups[1].Value.Trim() } else { '-' }
            $sedie.Add($mn.Groups[1].Value.Trim() + '  ' + $sy) | Out-Null
          }
          $m = $m.NextMatch()
        }
      }
      Nota ('       grafici    : ' + $ch.Count + ' file .chr,  SEDIE agganciate: ' + $sedie.Count) $(if ($sedie.Count -gt 0) { 'Yellow' } else { 'Gray' })
      foreach ($s in $sedie) { Nota ('          ' + $s) 'White' }
    }
  }
}

# ======================================================================
#  4. IL RIASSUNTO CHE SERVE PER DECIDERE
# ======================================================================
Nota ''
Nota '=== 4. RIASSUNTO ===' 'Cyan'
$ester = @()
foreach ($x in $exe) {
  $dir = Split-Path $x -Parent
  $noto = $false
  foreach ($k in $NOTI.Keys) { if ($dir -ieq $k) { $noto = $true } }
  if (-not $noto) { $ester += $dir }
}
Nota ('    terminal64.exe in tutto        : ' + $exe.Count)
Nota ('    di cui NOTI (i quattro BCM)    : ' + ($exe.Count - $ester.Count))
Nota ('    di cui ESTERNI / non in mappa   : ' + $ester.Count) $(if ($ester.Count -gt 0) { 'Yellow' } else { 'Green' })
foreach ($e in $ester) { Nota ('       ' + $e) 'Yellow' }
Nota ''
Nota ('fine: ' + (Get-Date).ToString('yyyy-MM-dd HH:mm:ss', $INV))
Nota 'NON e'' stato aperto, chiuso, installato o disinstallato NIENTE.' 'Green'
Nota 'NESSUN terminale e'' stato avviato: le sedie sono lette dai file .chr sul disco.' 'Green'

Set-Content -LiteralPath $refPath -Value $righe -Encoding ASCII

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
  Write-Host ('ZIP ' + $statoZip + ' -- MANDAMI QUESTA CARTELLA: ' + $cart) -ForegroundColor Yellow
}
Write-Host ('REFERTO: ' + $refPath) -ForegroundColor Gray
exit 0
