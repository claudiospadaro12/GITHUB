# =====================================================================
#  MARCATORE_SCHIERA_AZZURRA_PICCOLO_v2
#  (v2, 09/10: aggiunta la trial FTMO 1514806751, il conto VIVO di
#  C:\FTMO secondo CODA_09 del 09/10, alla lista dei rifiuti e ai banner;
#  il referto stampa le liste di rifiuto usate -- classe 150-ter)
#
#  PORTA ABTG_BulgeAzzurra (magic 774500, commento BULGE_AZZURRA) e il
#  suo preset nel terminale del conto DEMO PICCOLO 50503392, sul VPS
#  VMI3047753. SOLO COPIA DI DUE FILE.
#  Decisione di Claudio del 09/10/2026: "proviamolo nel conto DEMO
#  PICCOLO 50503392, NON nel conto della trial". Rischio 0,5%.
#
#  COSA SCRIVE (e nient'altro):
#    <cartella dati del piccolo>\MQL5\Experts\ABTG_BulgeAzzurra.mq5
#    <cartella dati del piccolo>\MQL5\Presets\ABTG_BulgeAzzurra_piccolo_demo.set
#    + la cartella del referto e il suo zip sul Desktop di chi lancia.
#  COSA NON FA, verificabile riga per riga:
#    NON compila (F7 a mano), NON attacca EA, NON apre grafici, NON
#    accende ne spegne Algo Trading, NON chiude ne avvia processi (li
#    LEGGE soltanto: titolo, percorso, proprietario), NON scrive .chr,
#    profili, config, .ini; NON porta il Guardian ne il suo include
#    (sul piccolo NON gira nessun Guardian: l'EA con InpUsaGuardian=true
#    e fail-open, CLAUDE.md 12/09); NON sovrascrive MAI un file gia
#    presente e diverso: in quel caso si FERMA prima di scaricare.
#
#  IL BERSAGLIO SI CERTIFICA CON FATTI, non con un nome. Serrature, in
#  ordine (la prima che non torna FERMA tutto, niente scritto):
#    0. la macchina e VMI3047753; -Pin e uno SHA completo di 40 hex;
#    1. fra i terminal64 vivi ce n e UNO SOLO col titolo della finestra
#       che comincia col numero 50503392 (il titolo lo scrive MT5 col
#       login collegato); il suo PROPRIETARIO (CIM GetOwner) e l utente
#       di questa sessione -- cosi la cartella dati sotto %APPDATA% e
#       quella VIVA (il 03/09 sotto Master c era una copia MORTA dello
#       stesso terminale: da Master questa serratura scatta);
#       il percorso dell eseguibile non nomina -V3, BCM_Reale,
#       MT5_Backtest, MT5_MANUALE, FTMO, Pepperstone, Tickmill;
#    2. fra le cartelle dati sotto %APPDATA%\MetaQuotes\Terminal, le
#       candidate sono quelle il cui origin.txt e ESATTAMENTE la cartella
#       di quell eseguibile;
#    3. una candidata e CONFERMATA solo se: si chiama
#       215D85D767A1C39E22D242C8114BF9F5 (censimento: e la cartella dati
#       del piccolo); ha bases\BCMMarkets-Server; il suo GIORNALE (logs,
#       10 file piu recenti) nomina 50503392 e NON nomina nessuno di:
#       FTMO, 541452707, 1514806751, 10105439, 50504263, 50503635, 50504400,
#       Pepperstone, Tickmill;
#    4. le confermate devono essere UNA. Zero o piu di una: FERMO.
#
#  I DUE FILE hanno impronta CONGELATA qui dentro (SHA256 dei byte cosi
#  come stanno nel repo, nessuna normalizzazione):
#    - l EA dal suo pin 31a11096 (il commit che lo ha scritto, SHA
#      b6b06347..., lo stesso del collaudo e del cancello dell 08/10);
#    - il preset dal -Pin della riga.
#  Se un byte non torna, FERMO prima di scrivere.
#
#  USCITA: 0 = i due file sono al loro posto e gli include per F7 ci
#  sono; 2 = i due file sono al loro posto MA l include del Guardian o
#  Trade.mqh non tornano (F7 dara errori: non attaccare); 1 = FERMO
#  (nessuna scrittura, salvo quanto dichiarato nel referto).
#
#  ASCII PURO: niente emoji, niente accentate (PS 5.1 legge i .ps1 come
#  ANSI -- regola di casa del 17/08). Solo parametri [string]: tutti
#  sopravvivono a powershell -File.
# =====================================================================

param(
  [Parameter(Mandatory=$true)][string]$Pin
)

$ErrorActionPreference = 'Stop'
$INV = [Globalization.CultureInfo]::InvariantCulture
try { [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12 } catch { }

$MACCHINA     = 'VMI3047753'
$CONTO        = '50503392'
$HASH_PICCOLO = '215D85D767A1C39E22D242C8114BF9F5'
$BASE_BCM     = 'BCMMarkets-Server'
$REPO_RAW     = 'https://raw.githubusercontent.com/claudiospadaro12/GITHUB'

# Compaiono QUI solo per RIFIUTARE: nessuna scrittura punta a loro.
$GIORNALE_NUMERI_VIETATI = @('541452707', '1514806751', '10105439', '50504263', '50503635', '50504400')
$GIORNALE_PAROLE_VIETATE = @('FTMO', 'Pepperstone', 'Tickmill')
$PERCORSO_VIETATO        = @('-V3', 'BCM_Reale', 'MT5_Backtest', 'MT5_MANUALE', 'FTMO', 'Pepperstone', 'Tickmill')

$EA = [pscustomobject]@{
  Nome    = 'ABTG_BulgeAzzurra.mq5'
  RepoDir = 'mql5/Experts'
  Sotto   = 'Experts'
  Pin     = '31a11096d1e7194646ac63e48a43b8a153f95f28'
  Byte    = 126091
  Sha     = 'B6B06347F6F73B4E0F8DE508087E48D089B911EE4CCAC250F8BEB8BE032A926B'
  Firme   = @('input long   InpMagic      = 774500;', 'input string InpComment    = "BULGE_AZZURRA";', 'ABTG_GuardiaIngresso(InpUsaGuardian, "ABTG_BulgeAzzurra")')
}
$SET = [pscustomobject]@{
  Nome    = 'ABTG_BulgeAzzurra_piccolo_demo.set'
  RepoDir = 'mql5/Presets/sedie_piccolo'
  Sotto   = 'Presets'
  Pin     = $Pin
  Byte    = 1215
  Sha     = '9F6492B92746CA464ADC58A32A252D81A480DE759237AAC3531C037179E38A4D'
  Firme   = @('InpMagic=774500', 'InpComment=BULGE_AZZURRA', 'Risk_Mode=0', 'Risk_Percent=0.5', 'Max_Trades=4', 'Use_Azure=true', 'Use_Orange=false', 'Use_Blue=false', 'Use_Purple=false', 'ADX_Apply_On_Azure=false', 'InpUsaGuardian=true', 'InpAutoTest=true')
}
$DA_COPIARE = @($EA, $SET)

# ---------------------------------------------------------------------
#  REFERTO: tutto cio che si stampa finisce anche nel file sul Desktop.
# ---------------------------------------------------------------------
$RIGHE_REFERTO = New-Object Collections.ArrayList
function Dillo($testo, $colore) {
  if($colore){ Write-Host $testo -ForegroundColor $colore } else { Write-Host $testo }
  [void]$RIGHE_REFERTO.Add('' + $testo)
}

function TrovaDesktop {
  foreach($p in @([Environment]::GetFolderPath('Desktop'), (Join-Path $env:USERPROFILE 'Desktop'), (Join-Path (Join-Path $env:USERPROFILE 'OneDrive') 'Desktop'))){
    if($p -and (Test-Path -LiteralPath $p)){ return $p }
  }
  return $env:USERPROFILE
}
$DESKTOP = TrovaDesktop
$STAMPA  = (Get-Date).ToString('yyyy-MM-dd_HHmmss', $INV)
$CARTREF = Join-Path $DESKTOP ('SCHIERA_AZZURRA_PICCOLO_' + $STAMPA)
$ZIP     = $CARTREF + '.zip'

function Chiudi([int]$codice) {
  try {
    if(-not (Test-Path -LiteralPath $CARTREF)){ [void](New-Item -ItemType Directory -Path $CARTREF -Force) }
    $f = Join-Path $CARTREF ('SCHIERA_AZZURRA_PICCOLO_' + $STAMPA + '_referto.txt')
    [IO.File]::WriteAllText($f, ($RIGHE_REFERTO -join "`r`n"), [Text.Encoding]::UTF8)
    Write-Host ('referto: ' + $f) -ForegroundColor Green
    try {
      Compress-Archive -Path (Join-Path $CARTREF '*') -DestinationPath $ZIP -Force
      Write-Host ('zip pronto da mandare: ' + $ZIP) -ForegroundColor Green
    } catch { Write-Host ('zip NON creato: ' + $_.Exception.Message + ' -- manda la cartella ' + $CARTREF) -ForegroundColor Yellow }
  } catch { Write-Host ('referto NON scritto: ' + $_.Exception.Message) -ForegroundColor Yellow }
  exit $codice
}

$SCRITTO = New-Object Collections.ArrayList
function Muori($msg) {
  Dillo '' $null
  Dillo '=====================================================================' 'Red'
  Dillo ('FERMO: ' + $msg) 'Red'
  if($SCRITTO.Count -eq 0){
    Dillo 'NESSUN FILE E STATO SCRITTO NELLA CARTELLA DATI DI NESSUN TERMINALE.' 'Red'
  } else {
    Dillo ('ATTENZIONE: prima del fermo erano gia stati copiati: ' + ($SCRITTO -join ' | ')) 'Red'
  }
  Dillo 'NON premere F7, NON attaccare niente. Manda lo zip / il referto.' 'Red'
  Dillo '=====================================================================' 'Red'
  Chiudi 1
}

# Lettura della CODA di un file anche se il terminale lo tiene aperto
# (giornale MT5: UTF-16LE). Restituisce $null se illeggibile.
function Leggi-Coda($path, [long]$max) {
  $fs = $null
  try {
    $fs = [IO.File]::Open($path, [IO.FileMode]::Open, [IO.FileAccess]::Read, [IO.FileShare]::ReadWrite)
  } catch { return $null }
  $letti = 0
  $b = $null
  $h = New-Object byte[] 2
  $nh = 0
  try {
    $len = $fs.Length
    $nh = $fs.Read($h, 0, 2)
    $off = [math]::Max([long]0, $len - $max)
    if(($off % 2) -eq 1){ $off = $off + 1 }
    [void]$fs.Seek($off, [IO.SeekOrigin]::Begin)
    $n = [int]($len - $off)
    $b = New-Object byte[] $n
    while($letti -lt $n){
      $q = $fs.Read($b, $letti, $n - $letti)
      if($q -le 0){ break }
      $letti = $letti + $q
    }
  } catch { return $null } finally { $fs.Close() }
  if($letti -lt 2){ return '' }
  $uni = ($nh -eq 2 -and $h[0] -eq 0xFF -and $h[1] -eq 0xFE)
  if(-not $uni){
    $zeri = 0
    $m = [math]::Min(400, $letti)
    for($i = 1; $i -lt $m; $i += 2){ if($b[$i] -eq 0){ $zeri++ } }
    $uni = ($zeri -gt ($m / 4))
  }
  if($uni){ return [Text.Encoding]::Unicode.GetString($b, 0, $letti) }
  return [Text.Encoding]::UTF8.GetString($b, 0, $letti)
}

function Sha-Byte([byte[]]$byte) {
  $sha = [Security.Cryptography.SHA256]::Create()
  try { $hb = $sha.ComputeHash($byte) } finally { $sha.Dispose() }
  $sb = New-Object Text.StringBuilder
  foreach($x in $hb){ [void]$sb.Append($x.ToString('X2', $INV)) }
  return $sb.ToString()
}
function Sha-File($path) {
  try { return (Get-FileHash -LiteralPath $path -Algorithm SHA256).Hash.ToUpperInvariant() } catch { return '' }
}
function Corto($s) {
  $s = '' + $s
  if($s.Length -ge 16){ return $s.Substring(0,16) }
  if($s -eq ''){ return 'NON LETTO' }
  return $s
}
function Numero-Nel-Testo($testo, $numero) {
  return [regex]::IsMatch($testo, ('(?<![0-9])' + [regex]::Escape($numero) + '(?![0-9])'))
}

try {
  Dillo '=====================================================================' $null
  Dillo ' SCHIERA AZZURRA SUL PICCOLO -- SOLO COPIA DI 2 FILE. NESSUN F7.' $null
  Dillo (' BERSAGLIO : terminale del conto DEMO piccolo ' + $CONTO + ' (cartella dati ' + $HASH_PICCOLO + '), MQL5\Experts e MQL5\Presets') $null
  Dillo ' NON TOCCATI: FTMO challenge 541452707 e trial 1514806751 (C:\FTMO), 100k 50504263 (cartella -V3), REALE 10105439 (C:\BCM_Reale),' $null
  Dillo '             manuale 50503635 (C:\MT5_MANUALE), banco 50504400 (C:\MT5_Backtest), Pepperstone, Tickmill.' $null
  Dillo (' pin preset: ' + $Pin) $null
  Dillo (' pin EA    : ' + $EA.Pin) $null
  Dillo (' macchina  : ' + $env:COMPUTERNAME + '   utente: ' + $env:USERNAME) $null
  Dillo (' ora       : ' + (Get-Date).ToString('yyyy-MM-dd HH:mm:ss', $INV) + '  (ora locale del VPS)') $null
  Dillo '=====================================================================' $null

  # PASSO 0 -- macchina e pin, prima di guardare il disco.
  if($env:COMPUTERNAME -ne $MACCHINA){ Muori ('questa macchina e ' + $env:COMPUTERNAME + ', non il VPS ' + $MACCHINA + '.') }
  if($Pin -notmatch '^[0-9a-f]{40}$'){ Muori ('-Pin vale "' + $Pin + '": serve lo SHA completo di 40 caratteri esadecimali minuscoli di un commit.') }
  Dillo ('[0/7] macchina ' + $MACCHINA + ' e pin accettati.') 'Green'

  # PASSO 1 -- il processo VIVO del piccolo: titolo, percorso, proprietario.
  Dillo '[1/7] terminali MT5 vivi su questa macchina (Id, titolo, percorso) -- sola lettura:' $null
  $tutti = @(Get-Process -Name terminal64 -ErrorAction SilentlyContinue)
  $tab = ($tutti | Select-Object Id, MainWindowTitle, Path | Format-Table -AutoSize | Out-String -Width 400)
  foreach($r in ($tab -split "`r?`n")){ if($r.Trim() -ne ''){ Dillo ('      ' + $r.TrimEnd()) $null } }
  $suoi = @($tutti | Where-Object { ('' + $_.MainWindowTitle) -match ('^' + $CONTO + '(?![0-9])') })
  if($suoi.Count -ne 1){
    Muori ('terminali col titolo che comincia per ' + $CONTO + ': ' + $suoi.Count.ToString($INV) + ' (ne serve UNO). Se sono 0: il terminale del piccolo e chiuso, oppure gira in un altra sessione Windows (il piccolo vivo gira sotto Administrator: lancia la riga da li).')
  }
  $proc = $suoi[0]
  $exe = ('' + $proc.Path).Trim()
  if($exe -eq ''){ Muori ('il processo ' + $proc.Id + ' non lascia leggere il percorso dell eseguibile: senza, non so quale cartella dati usa.') }
  $cim = @(Get-CimInstance -ClassName Win32_Process -Filter ('ProcessId=' + $proc.Id) -ErrorAction Stop)
  if($cim.Count -ne 1){ Muori ('CIM non restituisce UN processo per il PID ' + $proc.Id + '.') }
  if(('' + $cim[0].ExecutablePath).Trim() -ine $exe){ Muori ('percorso del processo discordante fra Get-Process (' + $exe + ') e CIM (' + $cim[0].ExecutablePath + ').') }
  $own = Invoke-CimMethod -InputObject $cim[0] -MethodName GetOwner -ErrorAction Stop
  if($own.ReturnValue -ne 0 -or ('' + $own.User) -eq ''){ Muori ('proprietario del processo ' + $proc.Id + ' NON leggibile (GetOwner ' + $own.ReturnValue + ').') }
  if(('' + $own.User) -ine $env:USERNAME){
    Muori ('il terminale del piccolo (PID ' + $proc.Id + ') gira sotto l utente ' + $own.User + ', questa PowerShell sotto ' + $env:USERNAME + '. La cartella dati VIVA sta sotto il profilo di ' + $own.User + ': lancia la riga dalla sessione ' + $own.User + '. Qui sotto %APPDATA% ci puo essere solo una copia MORTA (03/09).')
  }
  foreach($v in $PERCORSO_VIETATO){
    if($exe -like ('*' + $v + '*')){ Muori ('l eseguibile del terminale col titolo ' + $CONTO + ' e ' + $exe + ', che contiene "' + $v + '": NON e il piccolo. Non si scrive.') }
  }
  $instDir = (Split-Path -Parent $exe).TrimEnd('\')
  Dillo ('      PID ' + $proc.Id + '  titolo "' + $proc.MainWindowTitle + '"') 'Green'
  Dillo ('      eseguibile ' + $exe + '  proprietario ' + $own.Domain + '\' + $own.User + ' (= questa sessione)') 'Green'

  # PASSO 2 -- le cartelle dati di QUESTO profilo il cui origin.txt e quella installazione.
  $radice = Join-Path (Join-Path $env:APPDATA 'MetaQuotes') 'Terminal'
  if(-not (Test-Path -LiteralPath $radice)){ Muori ('non esiste ' + $radice + ': nessuna cartella dati MT5 sotto questo profilo.') }
  $cartelle = @(Get-ChildItem -LiteralPath $radice -Directory -ErrorAction SilentlyContinue |
                Where-Object { $_.Name -ine 'Common' -and (Test-Path -LiteralPath (Join-Path $_.FullName 'MQL5')) })
  Dillo ('[2/7] cartelle dati sotto ' + $radice + ': ' + $cartelle.Count.ToString($INV)) $null
  $candidate = @()
  foreach($d in $cartelle){
    $fo = Join-Path $d.FullName 'origin.txt'
    $orig = ''
    if(Test-Path -LiteralPath $fo){ $t = Leggi-Coda $fo 65536; if($null -ne $t){ $orig = (($t -replace '[^\u0020-\u007E]', '').Trim()).TrimEnd('\') } }
    if($orig -ne '' -and $orig -ieq $instDir){
      Dillo ('      candidata ' + $d.Name + '  origin = "' + $orig + '"') 'Cyan'
      $candidate += [pscustomobject]@{ Hash = $d.Name; Path = $d.FullName; Orig = $orig }
    } else {
      Dillo ('      esclusa   ' + $d.Name + '  origin = "' + $orig + '" (non e l installazione del processo ' + $CONTO + ')') $null
    }
  }
  if($candidate.Count -eq 0){ Muori ('nessuna cartella dati sotto ' + $radice + ' ha origin.txt = ' + $instDir + '.') }

  # PASSO 3 -- certificazione: censimento, bases, giornale.
  Dillo ('[3/7] certificazione delle candidate (' + $candidate.Count.ToString($INV) + '): nome censito, bases\' + $BASE_BCM + ', giornale') $null
  Dillo ('      liste di rifiuto usate: numeri ' + ($GIORNALE_NUMERI_VIETATI -join ', ') + ' ; parole ' + ($GIORNALE_PAROLE_VIETATE -join ', ') + ' ; percorsi ' + ($PERCORSO_VIETATO -join ', ')) $null
  $MAXB = [long]33554432
  $confermate = @()
  foreach($c in $candidate){
    $motivi = New-Object Collections.ArrayList
    if($c.Hash -ine $HASH_PICCOLO){ [void]$motivi.Add('nome ' + $c.Hash + ' diverso dal censito ' + $HASH_PICCOLO) }
    if(-not (Test-Path -LiteralPath (Join-Path (Join-Path $c.Path 'bases') $BASE_BCM))){ [void]$motivi.Add('manca bases\' + $BASE_BCM) }
    $dirLog = Join-Path $c.Path 'logs'
    $giornali = @()
    if(Test-Path -LiteralPath $dirLog){
      $giornali = @(Get-ChildItem -LiteralPath $dirLog -Filter *.log -File -ErrorAction SilentlyContinue | Sort-Object LastWriteTime -Descending | Select-Object -First 10)
    }
    $haConto = $false
    $vietatiVisti = @{}
    $login = @{}
    $troncati = 0
    $illeggibili = 0
    foreach($f in $giornali){
      if($f.Length -gt $MAXB){ $troncati++ }
      $t = Leggi-Coda $f.FullName $MAXB
      if($null -eq $t){ $illeggibili++; continue }
      if(Numero-Nel-Testo $t $CONTO){ $haConto = $true }
      foreach($n in $GIORNALE_NUMERI_VIETATI){ if(Numero-Nel-Testo $t $n){ $vietatiVisti[$n] = $f.Name } }
      foreach($w in $GIORNALE_PAROLE_VIETATE){ if([regex]::IsMatch($t, [regex]::Escape($w), [Text.RegularExpressions.RegexOptions]::IgnoreCase)){ $vietatiVisti[$w] = $f.Name } }
      foreach($m in [regex]::Matches($t, "'(\d{5,})': (?:login|authorized) on")){ $login[$m.Groups[1].Value] = 1 }
      $t = $null
    }
    $piuRecente = 'nessuno'
    if($giornali.Count -gt 0){ $piuRecente = $giornali[0].Name + ' (' + $giornali[0].LastWriteTime.ToString('yyyy-MM-dd HH:mm', $INV) + ')' }
    Dillo ('      ' + $c.Hash + '  giornali letti ' + $giornali.Count.ToString($INV) + ', piu recente ' + $piuRecente + ', illeggibili ' + $illeggibili.ToString($INV) + ', letti solo in coda (oltre 32 MB) ' + $troncati.ToString($INV)) $null
    $lg = 'nessuno'
    if($login.Keys.Count -gt 0){ $lg = (@($login.Keys | Sort-Object) -join ', ') }
    Dillo ('      login visti nel giornale: ' + $lg) $null
    if($giornali.Count -eq 0){ [void]$motivi.Add('nessun giornale in logs') }
    if($illeggibili -gt 0){ [void]$motivi.Add('' + $illeggibili + ' giornali illeggibili: non certifico su una lettura parziale') }
    if(-not $haConto){ [void]$motivi.Add('il giornale NON nomina ' + $CONTO) }
    foreach($k in @($vietatiVisti.Keys | Sort-Object)){ [void]$motivi.Add('il giornale nomina ' + $k + ' (file ' + $vietatiVisti[$k] + ')') }
    if($motivi.Count -eq 0){
      Dillo ('      -> CONFERMATA: censita, feed BCM, giornale con ' + $CONTO + ' e senza nomi vietati') 'Green'
      $confermate += $c
    } else {
      Dillo ('      -> RIFIUTATA: ' + ($motivi -join ' ; ')) 'Yellow'
    }
  }
  if($confermate.Count -ne 1){
    Muori ('cartelle confermate: ' + $confermate.Count.ToString($INV) + ' (ne serve UNA). Le righe gialle qui sopra dicono perche.')
  }
  $dati = $confermate[0].Path
  foreach($v in $PERCORSO_VIETATO){ if($dati -like ('*' + $v + '*')){ Muori ('la cartella confermata ' + $dati + ' contiene "' + $v + '". Non si scrive.') } }
  Dillo ('[3/7] BERSAGLIO CERTIFICATO -- conto ' + $CONTO) 'Green'
  Dillo ('      cartella dati : ' + $dati) 'Green'
  Dillo ('      installazione : ' + $instDir) 'Green'

  # PASSO 4 -- le destinazioni (devono ESISTERE: non si creano) e l include (sola lettura).
  $mql = Join-Path $dati 'MQL5'
  foreach($x in $DA_COPIARE){
    $dir = Join-Path $mql $x.Sotto
    if(-not (Test-Path -LiteralPath $dir)){ Muori ('manca ' + $dir + ': una cartella dati vera ce l ha. Non la creo.') }
    $x | Add-Member -NotePropertyName Dst -NotePropertyValue (Join-Path $dir $x.Nome) -Force
  }
  Dillo '[4/7] prerequisiti di F7 nel terminale (SOLA LETTURA, la riga non li tocca):' $null
  $inc = Join-Path (Join-Path $mql 'Include') 'ABTG_PausaGuardian.mqh'
  $incOk = $false
  if(Test-Path -LiteralPath $inc){
    $ti = Leggi-Coda $inc 8388608
    $gi = ($null -ne $ti) -and [regex]::IsMatch($ti, 'bool\s+ABTG_GuardiaIngresso\s*\(')
    $ga = ($null -ne $ti) -and [regex]::IsMatch($ti, 'int\s+ABTG_AutotestGuardia\s*\(')
    $ii = Get-Item -LiteralPath $inc
    Dillo ('      include ABTG_PausaGuardian.mqh: presente, ' + $ii.Length + ' byte, ' + $ii.LastWriteTime.ToString('yyyy-MM-dd HH:mm', $INV) + ', sha256 ' + (Corto (Sha-File $inc))) $null
    Dillo ('      definisce ABTG_GuardiaIngresso(...): ' + $gi + '   ABTG_AutotestGuardia(...): ' + $ga) $null
    $incOk = ($gi -and $ga)
  } else {
    Dillo '      include ABTG_PausaGuardian.mqh: ASSENTE' 'Yellow'
  }
  $tm = Join-Path (Join-Path (Join-Path $mql 'Include') 'Trade') 'Trade.mqh'
  $tmOk = (Test-Path -LiteralPath $tm)
  Dillo ('      include di libreria Trade\Trade.mqh: ' + $tmOk) $null
  if(-not ($incOk -and $tmOk)){ Dillo '      ATTENZIONE: con questi include F7 dara errori. La copia si fa lo stesso (due file nuovi, innocui), ma NON si attacca niente: riporta gli errori.' 'Yellow' }
  $ex5 = Join-Path (Join-Path $mql 'Experts') 'ABTG_BulgeAzzurra.ex5'
  if(Test-Path -LiteralPath $ex5){ Dillo ('      NOTA: esiste gia un ABTG_BulgeAzzurra.ex5 (' + (Get-Item -LiteralPath $ex5).LastWriteTime.ToString('yyyy-MM-dd HH:mm', $INV) + '): non lo tocco; F7 lo riscrivera.') 'Yellow' }

  # PASSO 5 -- cosa c e gia alle destinazioni. DIVERSO = FERMO, non si sovrascrive.
  Dillo '[5/7] destinazioni (nessuna scrittura ancora):' $null
  foreach($x in $DA_COPIARE){
    $stato = 'ASSENTE'
    if(Test-Path -LiteralPath $x.Dst){
      if((Sha-File $x.Dst) -eq $x.Sha){ $stato = 'GIA IDENTICO' } else { $stato = 'PRESENTE DIVERSO' }
    }
    $x | Add-Member -NotePropertyName Stato -NotePropertyValue $stato -Force
    $col = 'Green'
    if($stato -eq 'PRESENTE DIVERSO'){ $col = 'Red' }
    Dillo ('      ' + $x.Nome.PadRight(38) + $stato + '   (' + $x.Dst + ')') $col
  }
  $diversi = @($DA_COPIARE | Where-Object { $_.Stato -eq 'PRESENTE DIVERSO' })
  if($diversi.Count -gt 0){
    Muori ('alle destinazioni c e gia un file DIVERSO (' + (@($diversi | ForEach-Object { $_.Nome }) -join ', ') + '). Non sovrascrivo: qualcuno lo ha messo li o modificato. Serve una decisione, non una copia.')
  }

  # PASSO 6 -- scarico dai commit (immutabili) e verifico i byte PRIMA di scrivere.
  [void](New-Item -ItemType Directory -Path $CARTREF -Force)
  $dirTmp = Join-Path $CARTREF 'SCARICATI'
  [void](New-Item -ItemType Directory -Path $dirTmp -Force)
  Dillo '[6/7] scarico e verifico PRIMA di scrivere:' $null
  $wc = New-Object Net.WebClient
  try {
    foreach($x in $DA_COPIARE){
      $url = $REPO_RAW + '/' + $x.Pin + '/' + $x.RepoDir + '/' + $x.Nome
      $byte = $null
      try { $byte = $wc.DownloadData($url) }
      catch { Muori ('scaricamento FALLITO di ' + $x.Nome + ' da ' + $url + ' -- ' + $_.Exception.Message + '. Un 404 su un pin appena creato: aspetta 5 minuti e rilancia LA STESSA riga.') }
      $sha = Sha-Byte $byte
      if($byte.Length -ne $x.Byte -or $sha -ne $x.Sha){
        Muori ('il file scaricato ' + $x.Nome + ' NON e quello atteso (byte ' + $byte.Length + ' contro ' + $x.Byte + ', sha ' + $sha.Substring(0,16) + ' contro ' + $x.Sha.Substring(0,16) + '). Nulla scritto.')
      }
      $testo = [Text.Encoding]::ASCII.GetString($byte)
      foreach($fm in $x.Firme){
        if($testo.IndexOf($fm, [StringComparison]::Ordinal) -lt 0){ Muori ('il file ' + $x.Nome + ' non contiene "' + $fm + '". Nulla scritto.') }
      }
      $tmp = Join-Path $dirTmp $x.Nome
      [IO.File]::WriteAllBytes($tmp, $byte)
      $x | Add-Member -NotePropertyName Tmp -NotePropertyValue $tmp -Force
      $x | Add-Member -NotePropertyName Testo -NotePropertyValue $testo -Force
      Dillo ('      ' + $x.Nome.PadRight(38) + 'pin ' + $x.Pin.Substring(0,8) + '  byte ' + $byte.Length + '  sha ' + $sha.Substring(0,16) + '  VERIFICATO') 'Green'
    }
  } finally { $wc.Dispose() }

  # PASSO 7 -- la copia. Unica destinazione: la cartella certificata.
  # [IO.File]::Copy(...,$false) NON sovrascrive: se nel frattempo un file
  # e comparso, la copia fallisce invece di schiacciarlo.
  Dillo '[7/7] copia:' $null
  foreach($x in $DA_COPIARE){
    if($x.Stato -eq 'GIA IDENTICO'){ Dillo ('      ' + $x.Nome + ': era gia identico, non toccato') 'Green'; continue }
    try {
      [IO.File]::Copy($x.Tmp, $x.Dst, $false)
      [void]$SCRITTO.Add($x.Dst)
      Dillo ('      ' + $x.Nome + ': copiato') 'Green'
    } catch { Muori ('COPIA FALLITA su ' + $x.Nome + ': ' + $_.Exception.Message) }
  }

  # RILETTURA DAL DISCO: e questa la prova, non la copia.
  Dillo '' $null
  Dillo '=====================================================================' $null
  Dillo (' RISULTATO -- riletto dal disco del terminale ' + $CONTO + ', non dedotto') $null
  Dillo '=====================================================================' $null
  $tuttoBene = $true
  foreach($x in $DA_COPIARE){
    $ok = ((Test-Path -LiteralPath $x.Dst) -and ((Sha-File $x.Dst) -eq $x.Sha))
    if(-not $ok){ $tuttoBene = $false; Dillo ('  ' + $x.Nome.PadRight(38) + 'NON C E o E SBAGLIATO -- controllare a mano') 'Red' }
    else { Dillo ('  ' + $x.Nome.PadRight(38) + 'C E, ED E QUELLO GIUSTO (sha ' + $x.Sha.Substring(0,16) + ')') 'Green' }
  }
  Dillo '' $null
  Dillo ' TAGLIA E IDENTITA nel preset (solo lettura):' $null
  foreach($r in ($SET.Testo -split "`n")){
    if($r -match '^\s*(InpMagic|InpComment|Risk_Mode|Risk_Percent|Max_Trades|Use_Azure|Use_Orange|Use_Blue|Use_Purple|Use_Kill_Switch|Max_SL_PerDay|Max_Consecutive_SL|Max_Daily_Loss_Pct|InpUsaGuardian|InpAutoTest|Symbols_List)\s*='){ Dillo ('      ' + $r.Trim()) $null }
  }
  Dillo '' $null
  $nCop = $SCRITTO.Count
  $nGia = @($DA_COPIARE | Where-Object { $_.Stato -eq 'GIA IDENTICO' }).Count
  if($tuttoBene){
    Dillo (' ESITO: I DUE FILE SONO AL LORO POSTO E VERIFICATI (copiati adesso: ' + $nCop + ', gia identici e non toccati: ' + $nGia + ').') 'Green'
    if($incOk -and $tmOk){
      Dillo ('        Ora i passi A MANO di report/AZZURRA_PICCOLO_PASSI_2026-10-09.md: F7 nel MetaEditor del terminale ' + $CONTO + ' -> 0 errori -> UN grafico -> preset. Algo Trading globale NON si tocca.') 'Green'
    } else {
      Dillo ' MA: gli include del passo 4 NON tornano: F7 dara errori. NON attaccare niente, manda lo zip (uscita 2).' 'Yellow'
    }
  } else {
    Dillo ' ESITO: QUALCOSA NON TORNA (righe rosse sopra). NON premere F7 finche non e chiaro.' 'Red'
  }
  Dillo ' Questa riga NON ha compilato, NON ha attaccato EA, NON ha toccato Algo Trading ne processi.' $null
  Dillo ' Sul piccolo NON gira nessun Guardian: InpUsaGuardian=true e fail-open (nessuna pausa B1, nessun cap C1).' 'Yellow'
  if(-not $tuttoBene){ Chiudi 1 }
  if(-not ($incOk -and $tmOk)){ Chiudi 2 }
  Chiudi 0
} catch {
  Muori ('ECCEZIONE NON PREVISTA: ' + $_.Exception.Message + ' (riga ' + $_.InvocationInfo.ScriptLineNumber + ')')
}
