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
#  COSA FA: legge. Il NOME della macchina (che e' il VERDETTO: confrontato
#  con VMI3047753, il nome del VPS misurato il 12/09 da CODA_04), il tipo di
#  sessione e la batteria come INDIZI dichiarati tali; poi i terminal64.exe
#  trovati NEI RAMI CHE STAMPA (tutte le unita' fisse, meno Windows e simili, a
#  profondita' dichiarata -- NON "tutto il disco"), le cartelle DATI vere
#  (quelle con MQL5 dentro, come CODA_03 r.63), e per ognuna il CONTO, il
#  SERVER e l'AZIENDA letti dai giornali IN CONDIVISIONE (classe 163)
#  -- SENZA APRIRE NESSUN TERMINALE.
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
  # Dentro il guscio di una riga di lancio un errore terminante ammazza
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
# try/catch OBBLIGATORIO: -ErrorAction SilentlyContinue NON copre il caso in
# cui il comando stesso non si risolve, ne' un CIM/WMI rotto, e con
# $ErrorActionPreference='Stop' quello ammazza tutta la corsa. Misurato al
# banco il 12/09/2026: senza questo try la corsa moriva QUI, a sezione 2.
$unita = @()
try { $unita = @(Get-CimInstance Win32_LogicalDisk -Filter 'DriveType=3' -ErrorAction Stop) } catch { $unita = @() }
if ($unita.Count -eq 0) {
  Nota '    unita'' fisse NON elencabili (CIM non ha risposto): ripiego su C: sola.' 'Yellow'
  Nota '    ATTENZIONE: se un MT5 stesse su un''altra unita'', questa corsa NON lo vedrebbe.' 'Yellow'
  $unita = $null
  # Test-Path prima: su una radice che non si risolve, -Directory non e'
  # nemmeno un parametro valido (errore di BINDING, che -ErrorAction non zittisce).
  if (Test-Path -LiteralPath 'C:\') {
    $piatte.Add('C:\') | Out-Null
    foreach ($c in @(Get-ChildItem -LiteralPath 'C:\' -Directory -ErrorAction SilentlyContinue)) {
      if ($ESCLUDI -notcontains $c.Name) { $radici.Add($c.FullName) | Out-Null }
    }
  }
} else {
  foreach ($dl in $unita) {
    $rd = $dl.DeviceID + '\'
    $piatte.Add($rd) | Out-Null
    foreach ($c in @(Get-ChildItem -LiteralPath $rd -Directory -ErrorAction SilentlyContinue)) {
      if ($ESCLUDI -notcontains $c.Name) { $radici.Add($c.FullName) | Out-Null }
    }
  }
}
foreach ($p in @($env:ProgramFiles, ${env:ProgramFiles(x86)}, $env:LOCALAPPDATA, $env:USERPROFILE)) {
  if ($p) { $radici.Add($p) | Out-Null }
}
$radici = @($radici | Where-Object { $_ -and (Test-Path -LiteralPath $_) } | Select-Object -Unique)
Nota ('    unita'' FISSE viste: ' + ($piatte -join '  '))
Nota ('    rami ESCLUSI per nome: ' + ($ESCLUDI -join ', ')) 'DarkGray'

$exe = New-Object System.Collections.Generic.List[string]
# la radice di ogni unita', piatta: un terminal64.exe messo in C:\ diretto
foreach ($r in $piatte) {
  if (-not (Test-Path -LiteralPath $r)) { continue }
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

# Se APPDATA non c'e', Join-Path con $null TIRA e ammazza la corsa qui
# (misurato al banco il 12/09/2026: morte a sezione 3, referto troncato).
$appd = $env:APPDATA
if (-not $appd) { $appd = Join-Path $env:USERPROFILE 'AppData\Roaming' }
$root = Join-Path $appd 'MetaQuotes\Terminal'
if (-not (Test-Path -LiteralPath $root)) {
  Nota ('    NON ESISTE ' + $root + ' -- nessuna cartella dati in APPDATA') 'Yellow'
} else {
  # Una cartella DATI e' una cartella che ha MQL5 dentro. Stesso filtro di
  # CODA_03_conti_dei_terminali.ps1 r.63, che il 12/09 sul VPS ha contato 6:
  # quel 6 e' giusto e completo. Le altre (Common, Community, Help e due
  # residui con nome a hash) NON sono terminali e non vanno contate: senza
  # questo filtro il referto stamperebbe 11 righe, 5 delle quali marcate
  # "ESTERNO / NON IN MAPPA" in un documento che serve a decidere se si puo'
  # disinstallare qualcosa.
  $tutte = @(Get-ChildItem -LiteralPath $root -Directory -ErrorAction SilentlyContinue)
  $dirs  = @($tutte | Where-Object { Test-Path -LiteralPath (Join-Path $_.FullName 'MQL5') })
  $altre = @($tutte | Where-Object { -not (Test-Path -LiteralPath (Join-Path $_.FullName 'MQL5')) })
  Nota ('    cartelle DATI vere (hanno MQL5 dentro): ' + $dirs.Count + '   -- il 12/09 sul VPS erano 6 (CODA_03)')
  if ($altre.Count -gt 0) {
    Nota ('    altre ' + $altre.Count + ' cartelle SENZA MQL5, che NON sono terminali (cartelle condivise di MetaQuotes e residui): ' + (($altre | ForEach-Object { $_.Name }) -join ', ')) 'DarkGray'
    Nota '    Non si contano, non si censiscono, non si disinstallano.' 'DarkGray'
  }

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
    Nota ('       in mappa?  : ' + $etichetta)

    # --- il conto, il server e l'AZIENDA, dai GIORNALI (non si apre niente)
    #
    #  Ogni campo si cerca nell'ultima riga che LO CONTIENE, non nell'ultima
    #  riga che combacia con un ALTRO campo. Nei giornali veri del VPS
    #  (CODA_03_conti_dei_terminali_20260912_033002.log) la riga del conto e':
    #      '50503392': previous successful authorization performed from ...
    #  che NON contiene nessun server: cercandolo li' dentro si resta a mani
    #  vuote su tutte e sei le cartelle.
    #
    #  E la riga che dice DI CHI e' il terminale e' un'altra ancora (company/
    #  broker): su Pepperstone e Tickmill, dove il conto NON si trova nei
    #  giornali, quella e' l'UNICA misura disponibile -- ed e' la ragione per
    #  cui questo censimento esiste. Regex presa da CODA_03 r.96.
    $conto   = '[NON TROVATO nei giornali]'
    $server  = ''
    $azienda = ''
    $ultimo  = '[nessun giornale]'
    $nlog    = 0
    $logMuti = 0
    foreach ($sotto in @('logs', 'MQL5\Logs')) {
      $lp = Join-Path $d.FullName $sotto
      if (-not (Test-Path -LiteralPath $lp)) { continue }
      $lg = @(Get-ChildItem -LiteralPath $lp -File -Filter '*.log' -ErrorAction SilentlyContinue | Sort-Object LastWriteTime -Descending)
      $nlog += $lg.Count
      if ($lg.Count -gt 0 -and $ultimo -eq '[nessun giornale]') {
        $ultimo = $lg[0].LastWriteTime.ToString('yyyy-MM-dd HH:mm', $INV) + '   (' + $lg[0].Name + ')'
      }
      foreach ($f in ($lg | Select-Object -First 5)) {
        $txt = Leggi-Condiviso $f.FullName
        if (-not $txt) { $logMuti++; continue }
        $mc = [regex]::Matches($txt, "'([0-9]{6,12})'\s*:\s*(?:login|authoriz|connesso|previous)")
        if ($mc.Count -gt 0 -and $conto -like '*NON TROVATO*') { $conto = $mc[$mc.Count - 1].Groups[1].Value }
        if (-not $server) {
          $sv = [regex]::Matches($txt, 'authorized on\s+([A-Za-z0-9_\-\.]+)')
          if ($sv.Count -gt 0) { $server = $sv[$sv.Count - 1].Groups[1].Value }
        }
        if (-not $azienda) {
          $ma = [regex]::Match($txt, '(?im)^.*\b(company|azienda|broker)\b\s*:?\s*(.+?)\s*$')
          if ($ma.Success) { $azienda = $ma.Groups[2].Value.Trim() }
        }
      }
      if ($conto -notlike '*NON TROVATO*') { break }
    }
    Nota ('       giornali   : ' + $nlog + ' file, il piu'' recente del ' + $ultimo + $(if ($logMuti -gt 0) { '   [' + $logMuti + ' NON LEGGIBILI]' } else { '' })) $(if ($logMuti -gt 0) { 'Yellow' } else { 'Gray' })
    if ($logMuti -gt 0) { Nota '       ATTENZIONE: giornali NON letti -> un "NON TROVATO" qui sotto puo'' essere un buco di lettura, non un''assenza.' 'Yellow' }
    Nota ('       CONTO      : ' + $conto + $(if ($server) { '   su server ' + $server } else { '   [nessun "authorized on" nei giornali letti]' })) $(if ($conto -like '*NON TROVATO*') { 'Yellow' } else { 'Green' })
    if ($azienda) { Nota ('       AZIENDA    : ' + $azienda + '   <- e'' questa la riga che dice DI CHI e'' il terminale') 'Green' }
    else { Nota '       AZIENDA    : [nessuna riga company/broker nei giornali letti]' 'Yellow' }

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
      $chrMuti = 0
      foreach ($x in $ch) {
        $t = Leggi-Condiviso $x.FullName
        if (-not $t) { $chrMuti++; continue }
        # symbol= sta nel blocco CHART, non dentro <expert>: cercato li'
        # dentro non si trova MAI e la colonna stamperebbe '-' sempre.
        $msy = [regex]::Match($t, '(?m)^\s*symbol=([^\r\n]+)')
        $syChart = if ($msy.Success) { $msy.Groups[1].Value.Trim() } else { '[simbolo non letto]' }
        $m = [regex]::Match($t, '(?s)<expert>(.*?)</expert>')
        while ($m.Success) {
          $b = $m.Groups[1].Value
          $mn = [regex]::Match($b, '(?m)^\s*name=([^\r\n]+)')
          $ms2 = [regex]::Match($b, '(?m)^\s*symbol=([^\r\n]+)')
          if ($mn.Success) {
            $sy = if ($ms2.Success) { $ms2.Groups[1].Value.Trim() } else { $syChart }
            $sedie.Add($mn.Groups[1].Value.Trim() + '  ' + $sy + '   (' + $x.Name + ', salvato il ' + $x.LastWriteTime.ToString('yyyy-MM-dd HH:mm', $INV) + ')') | Out-Null
          }
          $m = $m.NextMatch()
        }
      }
      Nota ('       grafici    : ' + $ch.Count + ' file .chr (TUTTI i profili salvati, non solo quello attivo),  SEDIE agganciate: ' + $sedie.Count + $(if ($chrMuti -gt 0) { '   [' + $chrMuti + ' .chr NON LEGGIBILI]' } else { '' })) $(if ($sedie.Count -gt 0 -or $chrMuti -gt 0) { 'Yellow' } else { 'Gray' })
      foreach ($s in $sedie) { Nota ('          ' + $s) 'White' }
      Nota '       LIMITE: un .chr e'' una FOTO SALVATA, non lo stato vivo (CODA_05). "0 sedie"' 'Yellow'
      Nota '       qui NON autorizza a disinstallare niente: vuol dire "nessuna sedia' 'Yellow'
      Nota '       nell''ultimo profilo salvato", e il profilo si salva alla chiusura.' 'Yellow'
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
Nota 'FILE: il referto e'' scritto in ASCII, come i .ps1 di casa. Gli accenti dei'
Nota 'messaggi di Windows diventano "?": e'' estetica, nessun numero cambia.'
Nota 'CENSIMENTO COMPLETO: la corsa e'' arrivata in fondo. Se questa riga MANCA, il referto e'' TRONCATO.'

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
