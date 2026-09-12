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
if (-not $Desktop) { $Desktop = Join-Path $env:USERPROFILE 'Desktop' }
$cart    = Join-Path $Desktop ('CENSIMENTO_MT5_' + $t0.ToString('yyyyMMdd_HHmm', $INV))
$refPath = Join-Path $cart 'REFERTO_CENSIMENTO_MT5.txt'
$righe   = New-Object System.Collections.Generic.List[string]

# New-Item resta -Path: in PS 5.1 New-Item NON ha -LiteralPath.
New-Item -ItemType Directory -Force -Path $cart | Out-Null

function Nota([string]$s, [string]$col = 'Gray') {
  Write-Host $s -ForegroundColor $col
  $righe.Add($s) | Out-Null
  # SCRIVE SUBITO (classe 94-bis): se la corsa muore a meta', il referto
  # esiste comunque con tutto cio' che si e' misurato fino a quel punto.
  # Dentro un & { } un errore terminante ammazza anche la raccolta della
  # riga di lancio (classe 153-ter): senza questo, Claudio resta con niente.
  try { Add-Content -LiteralPath $script:refPath -Value $s -Encoding ASCII -ErrorAction SilentlyContinue } catch { }
}

# ---- IL LETTORE DI CASA, preso VERBATIM da CODA_09_giornale_operativo.ps1
#      r.40-53 (classe 163, pagata l'08/09): i giornali del giorno e i .chr
#      sono APERTI dal terminale vivo, e Get-Content/Select-String possono
#      fallire in silenzio. FileShare::ReadWrite + euristica UTF-16.
function Leggi-Condiviso($path){
  $b = $null
  try{
    $fs = [IO.File]::Open($path,[IO.FileMode]::Open,[IO.FileAccess]::Read,[IO.FileShare]::ReadWrite)
    $b  = New-Object byte[] $fs.Length
    [void]$fs.Read($b,0,$b.Length)
    $fs.Close()
  } catch { return "" }
  if($null -eq $b -or $b.Count -lt 2){ return "" }
  if($b[0] -eq 0xFF -and $b[1] -eq 0xFE){ return [Text.Encoding]::Unicode.GetString($b) }
  $zeri = 0; $n = [math]::Min(400,$b.Count)
  for($i=1; $i -lt $n; $i+=2){ if($b[$i] -eq 0){ $zeri++ } }
  if($zeri -gt ($n/4)){ return [Text.Encoding]::Unicode.GetString($b) }
  return [Text.Encoding]::UTF8.GetString($b)
}

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

# Il NOME del VPS non si indovina: e' MISURATO, ed era gia' scritto da
# qualcun altro -- CODA_04_capacita_macchina_20260912_033002.log r.3
# ("nome macchina: VMI3047753   utente: Administrator").
$VPS_NOTO = 'VMI3047753'

$sess = $env:SESSIONNAME
if (-not $sess) { $sess = '[non impostato]' }
$viaRdp = ($sess -like 'RDP*')
if ($viaRdp) {
  Nota ('    sessione        : ' + $sess + '   -> c''e'' un DESKTOP REMOTO di mezzo: tutto quello che segue descrive la macchina che si chiama ' + $env:COMPUTERNAME + ', NON quella che hai fisicamente davanti')
} else {
  Nota ('    sessione        : ' + $sess + '   -> NON e'' una sessione RDP-Tcp, e questo NON dimostra che sei davanti alla macchina: mstsc /admin, VNC, AnyDesk e la console web del fornitore lasciano SESSIONNAME=Console. Tutto quello che segue descrive comunque la macchina che si chiama ' + $env:COMPUTERNAME)
}
if ($env:COMPUTERNAME -ieq $VPS_NOTO) {
  Nota ('    VERDETTO        : QUESTA E'' LA MACCHINA DEL VPS (' + $VPS_NOTO + ', nome misurato il 12/09/2026 da CODA_04).') 'Green'
} else {
  Nota ('    VERDETTO        : QUESTA NON E'' IL VPS. Il VPS si chiama ' + $VPS_NOTO + ', questa si chiama ' + $env:COMPUTERNAME + ' -> e'' un''ALTRA macchina, ed e'' la prima volta che la censiamo.') 'Yellow'
}
Nota '    Il NOME e'' la prova. Sessione, batteria e modello sono indizi, non verdetti.' 'Cyan'

try {
  $cs = Get-CimInstance Win32_ComputerSystem -ErrorAction Stop
  Nota ('    marca/modello   : ' + $cs.Manufacturer + ' / ' + $cs.Model)
  Nota ('    processori      : ' + $cs.NumberOfLogicalProcessors + ' logici')
  Nota ('    RAM             : ' + [math]::Round($cs.TotalPhysicalMemory / 1GB, 1) + ' GB')
  # Il discriminante fisica/virtuale SERIO e' il modello, non la batteria.
  $segni = @('VMware','VirtualBox','QEMU','KVM','Xen','Virtual Machine','Hyper-V','Bochs','Parallels','OpenStack','Amazon EC2','Google Compute','Alibaba')
  $eVm = $false
  foreach ($s in $segni) { if (($cs.Manufacturer + ' ' + $cs.Model) -like ('*' + $s + '*')) { $eVm = $true } }
  Nota ('    tipo            : ' + $(if ($eVm) { 'VIRTUALE (marca/modello di macchina virtuale)' } else { 'FISICA, oppure VM non riconoscibile dal modello' }))
} catch {
  Nota ('    marca/modello   : [non leggibile: ' + $_.Exception.Message + ']') 'Yellow'
}

try {
  $bat = @(Get-CimInstance Win32_Battery -ErrorAction SilentlyContinue)
  if ($bat.Count -gt 0) {
    Nota ('    batteria        : SI (' + $bat.Count + ') -> compatibile con un PORTATILE (ma anche un fisso con UPS espone una batteria). NON e'' il verdetto.') 'Yellow'
  } else {
    Nota '    batteria        : NESSUNA -> compatibile con un VPS o un desktop fisso. Nemmeno questo e'' un verdetto.'
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
Nota '    LO DICO CHIARO: questo referto descrive UNA macchina sola, quella il cui' 'Yellow'
Nota ('    nome e'' stampato qui sopra (' + $env:COMPUTERNAME + '). Per sapere com''e'' fatta') 'Yellow'
Nota '    l''ALTRA, la riga va lanciata SULL''ALTRA: servono DUE corse, e i due nomi' 'Yellow'
Nota '    si CONFRONTANO. Quale delle due sia "il VPS" lo dice il NOME, non la sessione.' 'Yellow'

# ======================================================================
#  2. TUTTI I terminal64.exe SUL DISCO (non dal Pannello di controllo)
# ======================================================================
Nota ''
Nota '=== 2. I terminal64.exe TROVATI NEI RAMI ELENCATI QUI SOTTO ===' 'Cyan'
Nota '    (il Pannello di controllo non vede le copie e i portable:'
Nota '     mostra UN BCM, e noi ne abbiamo misurati QUATTRO)'
Nota '    NON e'' "tutto il disco": i rami cercati e la profondita'' sono stampati,' 'Yellow'
Nota '    e cio'' che sta FUORI da questo elenco NON e'' stato guardato.' 'Yellow'

# Tutte le unita' FISSE, non solo C: (sul VPS c'e' solo C:, ma la seconda
# corsa e' su un'altra macchina, che puo' avere un D:). E si salta Windows:
# nessun MT5 ci sta, e -Depth 3 da C:\ entra nel contenuto di ogni pacchetto
# di WinSxS -- minuti buttati.
$ESCLUDI = @('Windows', '$Recycle.Bin', 'System Volume Information', '$WinREAgent', 'Recovery', 'PerfLogs', 'Config.Msi', 'OneDriveTemp')
$radici  = New-Object System.Collections.Generic.List[string]
$piatte  = New-Object System.Collections.Generic.List[string]
foreach ($dl in @(Get-CimInstance Win32_LogicalDisk -Filter 'DriveType=3' -ErrorAction SilentlyContinue)) {
  $rd = $dl.DeviceID + '\'
  $piatte.Add($rd) | Out-Null
  foreach ($c in @(Get-ChildItem -LiteralPath $rd -Directory -ErrorAction SilentlyContinue)) {
    if ($ESCLUDI -notcontains $c.Name) { $radici.Add($c.FullName) | Out-Null }
  }
}
if ($piatte.Count -eq 0) { $piatte.Add('C:\') | Out-Null; $radici.Add('C:\') | Out-Null }
foreach ($p in @($env:ProgramFiles, ${env:ProgramFiles(x86)}, $env:LOCALAPPDATA, $env:USERPROFILE)) {
  if ($p) { $radici.Add($p) | Out-Null }
}
$radici = @($radici | Where-Object { $_ -and (Test-Path -LiteralPath $_) } | Select-Object -Unique)
Nota ('    unita'' FISSE viste: ' + ($piatte -join '  '))
Nota ('    rami ESCLUSI per nome: ' + ($ESCLUDI -join ', ')) 'DarkGray'

$exe = New-Object System.Collections.Generic.List[string]
# la radice di ogni unita', piatta: un terminal64.exe messo in C:\ diretto
foreach ($r in $piatte) {
  foreach ($f in @(Get-ChildItem -LiteralPath $r -Filter 'terminal64.exe' -File -ErrorAction SilentlyContinue)) {
    if (-not $exe.Contains($f.FullName)) { $exe.Add($f.FullName) | Out-Null }
  }
}
foreach ($r in $radici) {
  Nota ('    cerco sotto: ' + $r + '  (profondita'' ' + $Profondita + ')') 'DarkGray'
  $trovati = @(Get-ChildItem -LiteralPath $r -Filter 'terminal64.exe' -File -Recurse -Depth $Profondita -ErrorAction SilentlyContinue)
  foreach ($f in $trovati) {
    if (-not $exe.Contains($f.FullName)) { $exe.Add($f.FullName) | Out-Null }
  }
}

# Get-Process serve SOLO a leggere Id e Path: non si tocca nessun processo.
# E se .Path tira (processo di un ALTRO utente) il terminale finirebbe
# stampato "spento" pur essendo ACCESO: quei casi si CONTANO e si dicono.
$proc = @(Get-Process terminal64 -ErrorAction SilentlyContinue)
$vivi = @{}
$procMuti = 0
foreach ($pr in $proc) {
  $pp = $null
  try { $pp = $pr.Path } catch { $pp = $null }
  if ($pp) { $vivi[$pp] = $pr.Id } else { $procMuti++ }
}
Nota ''
Nota ('    processi terminal64 VIVI ADESSO: ' + $proc.Count + '   (percorso leggibile ' + $vivi.Count + ', NON leggibile ' + $procMuti + ')') $(if ($procMuti -gt 0) { 'Yellow' } else { 'Gray' })
if ($procMuti -gt 0) { Nota '    ATTENZIONE: un processo col percorso NON leggibile gira sotto un ALTRO utente:' 'Yellow' }
if ($procMuti -gt 0) { Nota '    qui sotto puo'' comparire come "spento" pur essendo ACCESO.' 'Yellow' }

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
