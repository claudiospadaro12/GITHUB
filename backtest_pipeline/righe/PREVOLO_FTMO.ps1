# =====================================================================
#  MARCATORE_PREVOLO_FTMO_v1
#  RUNNER_SOLA_LETTURA
#
#  LA SONDA DI PRE-VOLO DEL TERMINALE FTMO.
#  Si lancia SUBITO DOPO IL LOGIN, PRIMA di aprire un grafico, PRIMA di
#  copiare un sorgente, PRIMA di premere F7.
#
#  PERCHE' ESISTE -- sei inferenze mai misurate (20/09/2026)
#  Tutto il pacchetto di schieramento (report/PACCHETTO_SCHIERAMENTO_
#  PROP_2026-09-21.md) poggia su SEI numeri che nessuno ha mai letto sul
#  terminale FTMO, perche' quel terminale non esisteva:
#    1. l'OROLOGIO del server (i 10 preset sono rimappati su "BCM +2",
#       che viene da UNA RIGA di documentazione, non da una misura);
#    2. i NOMI dei simboli (GER40? US30? NAS100? noi scriviamo D30EUR,
#       U30USD, NASUSD): senza i nomi veri nessun grafico si apre;
#    3. il MARGINE per lotto (oggi e' nozionale/leva, dedotto);
#    4. _Digits e _Point (InpBufferPoints e InpMinStopPts sono IN PUNTI:
#       un Digits diverso sposta i livelli di DIECI VOLTE);
#    5. gli SPREAD (la frontiera di casa e' stop >= 40 x spread, e
#       InpMaxSpread=0 su 9 preset su 10, cioe' filtro SPENTO);
#    6. la LEVA vera e il TIPO di conto (Standard 1:100 o Swing 1:15?).
#
#  COSA FA QUESTA SONDA, ED E' MENO DI QUELLO CHE SEMBRA (di proposito)
#    - chiude da sola quello che STA SU DISCO ed e' leggibile;
#    - per tutto il resto NON INVENTA: stampa le istruzioni esatte per
#      leggerlo a mano (quale finestra, quale menu, cosa copiare) e
#      lascia la casella VUOTA nel referto.
#      Una casella dichiarata vuota vale piu' di un numero inventato.
#    - e per ogni numero che Claudio legge a mano, la sonda ha GIA'
#      stampato PRIMA la tabella che lo interpreta (che ora ti aspetti,
#      che cosa cambia se Digits e' 1 invece di 2). Cosi' la lettura a
#      mano e' UN NUMERO DA CONFRONTARE, non un giudizio da dare.
#
#  COSA NON FA, ED E' VERIFICABILE RIGA PER RIGA
#    - NON scrive NIENTE dentro nessuna cartella dati: l'unica scrittura
#      di questo file e' sul DESKTOP (referto + zip). Cercare Copy-Item,
#      New-Item, WriteAll*, Remove-Item: puntano tutti sotto $CARTREF;
#    - NON scarica niente e NON tocca la rete;
#    - NON apre, NON chiude, NON termina processi. Get-Process compare
#      UNA volta, in sola LETTURA, per stampare PID+titolo+cartella
#      (regola dei terminali multipli del 06/09: il riconoscimento della
#      finestra dev'essere un fatto stampato, non un'inferenza);
#    - NON tocca il conto reale 10105439 ne' nessuno degli altri sei
#      terminali di casa: li ELENCA per ESCLUDERLI;
#    - NON legge e NON stampa MAI righe di password: dei file config\*.ini
#      escono solo le chiavi Server= e Login=, per lista bianca.
#
#  LA SCOPERTA E' QUELLA GIA' COLLAUDATA IN SCHIERA_FTMO.ps1 (pin
#  489f98c0, MARCATORE_SCHIERA_FTMO_v2), riusata e non riscritta:
#    1. la cartella NON deve essere una delle SETTE gia' censite (hash);
#    2. il suo origin.txt NON deve nominare BCM/Pepperstone/Tickmill/
#       MT5_Backtest/MT5_MANUALE;
#    3. il GIORNALE (<dati>\logs, NON MQL5\Logs) deve contenere il numero
#       passato con -ContoAtteso;
#    4. il giornale o l'origin.txt devono nominare FTMO.
#  ZERO candidate o PIU' DI UNA -> SI RIFIUTA e si stampa l'elenco.
#  -ContoAtteso viene rifiutato in partenza se e' uno dei conti di casa
#  o se e' ancora il segnaposto della riga di lancio.
#
#  USCITE, e vogliono dire cose DIVERSE (classe 471: l'ordine dei codici
#  non deve assolvere la corsa che non ha misurato niente):
#    0 = ho misurato TUTTO quello che era misurabile da disco e nessuna
#        casella automatica e' rimasta aperta;
#    2 = la sonda ha girato e il bersaglio e' certificato, MA almeno una
#        casella automatica e' rimasta APERTA (di solito i simboli, se il
#        terminale non ha ancora scaricato la lista). NON e' un errore:
#        e' un referto con dei buchi dichiarati;
#    1 = RIFIUTO: non ho certificato niente. Nessuna misura.
#
#  ASCII PURO: niente emoji, niente accentate (PS 5.1 legge i .ps1 come
#  ANSI -- regola di casa del 17/08).
# =====================================================================

param(
  [Parameter(Mandatory=$true)][string]$ContoAtteso,
  [switch]$TuttiISimboli
)

$ErrorActionPreference = 'Stop'
$INV = [Globalization.CultureInfo]::InvariantCulture
$CRONO = [Diagnostics.Stopwatch]::StartNew()

# ---------------------------------------------------------------------
# LE SETTE CARTELLE DATI GIA' CENSITE SUL VPS.
# Compaiono qui SOLO per essere RIFIUTATE: sono la lista nera, non una
# destinazione. Questa sonda non scrive in nessuna cartella dati, ma il
# filtro resta: leggere il terminale sbagliato e' gia' un errore, anche
# senza scrivere (si finirebbe per misurare l'orologio di BCM).
# ---------------------------------------------------------------------
$HASH_NOTI = @{
  '215D85D767A1C39E22D242C8114BF9F5' = '50503392  piccolo demo      (C:\Program Files\BCM Markets MT5 Terminal)'
  'BCA8AD18563BF5B64A433C2662D0A104' = '50504263  100k demo         (C:\Program Files\BCM Markets MT5 Terminal -V3)'
  'E23E1504A8D02A22179395F0652B86B6' = '10105439  *** REALE ***     (C:\BCM_Reale)'
  '04C7A32B575E40027B4FF8724D14D702' = '50504400  banco di backtest (C:\MT5_Backtest)'
  'CF6C240A869369695913FB76DA84BD22' = '50503635  manuale           (C:\MT5_MANUALE)'
  '73B7A2420D6397DFF9014A20F1201F97' = 'broker esterno Pepperstone'
  '857385E4B0F2356AD99AA95CDF40FAE9' = 'broker esterno Tickmill'
}
$NOMI_VIETATI  = @('BCM', 'Pepperstone', 'Tickmill', 'MT5_Backtest', 'MT5_MANUALE')
$CONTI_DI_CASA = @('50503392', '50504263', '10105439', '50504400', '50503635')

# ---------------------------------------------------------------------
# I CINQUE MERCATI DELLA ROSA, con il nome che hanno DA NOI e i nomi che
# potrebbero avere DA LORO. La sonda non sceglie: propone e conta.
# Il suffisso finale ([._#+-]XX) copre le varianti tipo .cash, .raw, +.
# ---------------------------------------------------------------------
$MERCATI = @(
  [pscustomobject]@{ Mercato='DAX    '; Nostro='D30EUR'; Regex='^(DAX(30|40)?|GER(30|40)(CASH|EUR)?|DE(30|40)(EUR|CASH)?|D(30|40)EUR|GERMAN(Y)?(30|40)(CASH)?|FDAX|GERMANY(30|40))([._#+\-][A-Z0-9]{1,6})?$' },
  [pscustomobject]@{ Mercato='DOW    '; Nostro='U30USD'; Regex='^(US30(CASH)?|USA30(CASH)?|DJ(30|I|IA)?(USD)?|WS30|DOW(30|JONES)?|U30USD|YM|US30USD)([._#+\-][A-Z0-9]{1,6})?$' },
  [pscustomobject]@{ Mercato='NASDAQ '; Nostro='NASUSD'; Regex='^(NAS(100|DAQ|USD)?|US(100|TEC)(CASH)?|USATEC|NDX(100)?|TECH100|US100USD|NAS100(CASH)?)([._#+\-][A-Z0-9]{1,6})?$' },
  [pscustomobject]@{ Mercato='ORO    '; Nostro='XAUUSD'; Regex='^(XAUUSD|GOLD(USD)?|XAU)([._#+\-][A-Z0-9]{1,6})?$' },
  [pscustomobject]@{ Mercato='USDJPY '; Nostro='USDJPY'; Regex='^(USDJPY)([._#+\-][A-Z0-9]{1,6})?$' }
)

# =====================================================================
# FUNZIONI
# =====================================================================

# Lettura CONDIVISA: i giornali sono aperti dal terminale in questo
# istante (Claudio ha appena fatto il login). Senza FileShare::ReadWrite
# questa sonda fallirebbe proprio nel momento in cui serve.
function Leggi-Testo($path) {
  $b = $null
  try {
    $fs = [IO.File]::Open($path, [IO.FileMode]::Open, [IO.FileAccess]::Read, [IO.FileShare]::ReadWrite)
  } catch { return '' }
  try {
    $b = New-Object byte[] $fs.Length
    $letti = 0
    while($letti -lt $b.Length){
      $q = $fs.Read($b, $letti, $b.Length - $letti)
      if($q -le 0){ break }
      $letti += $q
    }
  } finally { $fs.Close() }
  if($null -eq $b -or $b.Count -lt 2){ return '' }
  if($b[0] -eq 0xFF -and $b[1] -eq 0xFE){ return [Text.Encoding]::Unicode.GetString($b) }
  $zeri = 0
  $n = [math]::Min(400, $b.Count)
  for($i = 1; $i -lt $n; $i += 2){ if($b[$i] -eq 0){ $zeri++ } }
  if($zeri -gt ($n / 4)){ return [Text.Encoding]::Unicode.GetString($b) }
  return [Text.Encoding]::UTF8.GetString($b)
}

# Come sopra, ma torna i BYTE: serve per i file binari (bases\...), da
# cui si estraggono le PAROLE in ASCII e in UTF-16.
function Leggi-Byte($path, $maxLen) {
  try {
    $fs = [IO.File]::Open($path, [IO.FileMode]::Open, [IO.FileAccess]::Read, [IO.FileShare]::ReadWrite)
  } catch { return $null }
  try {
    $len = [int][math]::Min([double]$fs.Length, [double]$maxLen)
    if($len -le 0){ return $null }
    $b = New-Object byte[] $len
    $letti = 0
    while($letti -lt $len){
      $q = $fs.Read($b, $letti, $len - $letti)
      if($q -le 0){ break }
      $letti += $q
    }
  } finally { $fs.Close() }
  return $b
}

# Le PAROLE maiuscole dentro un blocco di byte, lette in ASCII e in
# UTF-16LE (MT5 scrive in tutti e due i modi a seconda del file).
# Il filtro "solo maiuscole, 3-16 caratteri" tiene fuori quasi tutto il
# rumore binario; quello che passa viene comunque confrontato con il
# DIZIONARIO dei cinque mercati, mai stampato come verita'.
function Parole-Da-Bytes($bytes) {
  $out = New-Object Collections.ArrayList
  if($null -eq $bytes){ return $out }
  $testi = @()
  try { $testi += [Text.Encoding]::ASCII.GetString($bytes) }   catch { }
  try { $testi += [Text.Encoding]::Unicode.GetString($bytes) } catch { }
  foreach($t in $testi){
    if(-not $t){ continue }
    $mm = [regex]::Matches($t, '[A-Z][A-Z0-9._#+\-]{2,15}')
    $q = 0
    foreach($m in $mm){
      [void]$out.Add($m.Value)
      $q++
      if($q -ge 20000){ break }
    }
  }
  return $out
}

# Il fuso si STAMPA da qui e da nessun altro posto: concatenare '+' con un
# numero gia' negativo stampava "UTC+-2" (trovato provando la sonda su una
# macchina in UTC, 20/09/2026).
function Fuso($h) {
  $n = [int]$h
  if($n -ge 0){ return ('UTC+' + $n.ToString($INV)) }
  return ('UTC' + $n.ToString($INV))
}

$RIGHE_REFERTO = New-Object Collections.ArrayList
function Dillo($testo, $colore) {
  if($colore){ Write-Host $testo -ForegroundColor $colore } else { Write-Host $testo }
  [void]$RIGHE_REFERTO.Add($testo)
}

$DESKTOP = Join-Path $env:USERPROFILE 'Desktop'
if(-not (Test-Path -LiteralPath $DESKTOP)){ $DESKTOP = $env:USERPROFILE }
$STAMPA  = (Get-Date).ToString('yyyy-MM-dd_HHmmss', $INV)
$CARTREF = Join-Path $DESKTOP ('PREVOLO_FTMO_' + $STAMPA)

# Il referto porta in PRIMA RIGA la sua data, e la riga si legge PRIMA
# di crederci: il 17/08 un referto stantio e' stato mandato due volte in
# buona fede.
function Posa-Referto {
  try {
    if(-not (Test-Path -LiteralPath $CARTREF)){ [void](New-Item -ItemType Directory -Path $CARTREF -Force) }
    $f = Join-Path $CARTREF ('PREVOLO_FTMO_' + $STAMPA + '_referto.txt')
    $testa = @(
      ('data: ' + (Get-Date).ToString('yyyy-MM-dd HH:mm:ss', $INV) + '   (ora locale di questa macchina)'),
      'sonda: PREVOLO_FTMO.ps1  MARCATORE_PREVOLO_FTMO_v1',
      'SE QUESTA DATA NON E DI ADESSO, STAI LEGGENDO UN REFERTO VECCHIO.',
      ''
    )
    [IO.File]::WriteAllText($f, (($testa + $RIGHE_REFERTO) -join "`r`n"), [Text.Encoding]::UTF8)
    return $f
  } catch { return '' }
}

function Muori($msg) {
  Dillo '' $null
  Dillo '=====================================================================' 'Red'
  Dillo ('FERMO: ' + $msg) 'Red'
  Dillo 'NON HO MISURATO NIENTE. Nessuna casella e stata chiusa.' 'Red'
  Dillo '=====================================================================' 'Red'
  $f = Posa-Referto
  if($f){ Write-Host ('referto di questo rifiuto: ' + $f) -ForegroundColor Yellow }
  exit 1
}

Dillo '=====================================================================' $null
Dillo ' PREVOLO FTMO -- SONDA DI SOLA LETTURA. NON SCRIVE SUL TERMINALE.' $null
Dillo (' conto atteso : ' + $ContoAtteso) $null
Dillo (' ora          : ' + (Get-Date).ToString('yyyy-MM-dd HH:mm:ss', $INV) + '  (ora locale di questa macchina)') $null
Dillo (' utente       : ' + $env:USERNAME + '   macchina: ' + $env:COMPUTERNAME) $null
Dillo '=====================================================================' $null
Dillo '' $null

# =====================================================================
# PASSO 0 -- IL CONTO ATTESO, CONTROLLATO PRIMA DI GUARDARE IL DISCO
# =====================================================================
if($ContoAtteso -match '(?i)tuo|conto_ftmo|xxx|numero'){
  Muori ('-ContoAtteso vale "' + $ContoAtteso + '": e ancora il SEGNAPOSTO della riga di lancio. Sostituiscilo col numero di conto vero che ti e arrivato per mail da FTMO.')
}
if($ContoAtteso -notmatch '^[0-9]{6,12}$'){
  Muori ('-ContoAtteso vale "' + $ContoAtteso + '", che non e un numero di conto (servono 6-12 cifre). Non si cerca niente con una chiave sbagliata.')
}
foreach($c in $CONTI_DI_CASA){
  if($ContoAtteso -eq $c){
    Muori ('-ContoAtteso vale ' + $ContoAtteso + ', che e UN CONTO DI CASA (BCM), non FTMO. Se avessi accettato, avrei misurato l orologio del terminale sbagliato e detto che il fuso era giusto.')
  }
}
Dillo ('[0/6] -ContoAtteso ' + $ContoAtteso + ' accettato: e un numero, non e un segnaposto, e NON e nessuno dei cinque conti di casa.') 'Green'

# =====================================================================
# PASSO 1 -- LA SCOPERTA. Qui non si indovina: si elenca e si esclude.
# =====================================================================
$radice = Join-Path $env:APPDATA 'MetaQuotes\Terminal'
if(-not (Test-Path -LiteralPath $radice)){
  Muori ('non esiste ' + $radice + '. Su questa macchina non c e nessun MT5, oppure -- piu probabile -- questa riga sta girando sull utente sbagliato (sto girando come ' + $env:USERNAME + ').')
}

$cartelle = @(Get-ChildItem -LiteralPath $radice -Directory -ErrorAction SilentlyContinue |
              Where-Object { Test-Path -LiteralPath (Join-Path $_.FullName 'MQL5') })
Dillo ('[1/6] cartelle dati sotto ' + $radice + ': ' + $cartelle.Count.ToString($INV)) $null

$candidate = @()
foreach($d in $cartelle){
  $nome = $d.Name
  $noto = ''
  foreach($k in $HASH_NOTI.Keys){ if($nome -eq $k){ $noto = $HASH_NOTI[$k] } }
  if($noto){
    Dillo ('      ESCLUSA  ' + $nome + '  = ' + $noto) $null
    continue
  }
  $fOrig = Join-Path $d.FullName 'origin.txt'
  if(-not (Test-Path -LiteralPath $fOrig)){
    Dillo ('      ESCLUSA  ' + $nome + '  = manca origin.txt: non posso CERTIFICARE di chi e questa cartella.') 'Yellow'
    continue
  }
  $prog = ((Leggi-Testo $fOrig) -replace '[^\u0020-\u007E]', '').Trim()
  $vietato = ''
  foreach($v in $NOMI_VIETATI){ if($prog -like ('*' + $v + '*')){ $vietato = $v } }
  if($vietato){
    Dillo ('      ESCLUSA  ' + $nome + '  = "' + $prog + '" contiene "' + $vietato + '": e una cartella di casa, non si guarda.') $null
    continue
  }
  $candidate += [pscustomobject]@{ Hash = $nome; Path = $d.FullName; Prog = $prog }
  Dillo ('      candidata ' + $nome + '  = "' + $prog + '"') 'Cyan'
}

if($candidate.Count -eq 0){
  Dillo '' $null
  Dillo '      NESSUNA CANDIDATA. Le cause possibili, in ordine di probabilita:' 'Yellow'
  Dillo '      1. il terminale FTMO non e ancora stato INSTALLATO e AVVIATO almeno una volta' 'Yellow'
  Dillo '      2. e stato avviato ma non ha ancora scritto origin.txt: chiudilo e riaprilo una volta' 'Yellow'
  Dillo ('      3. e installato per un ALTRO utente Windows: questa riga gira come ' + $env:USERNAME) 'Yellow'
  Dillo '      4. e portable (dati dentro la cartella del programma, non in APPDATA)' 'Yellow'
  Muori 'zero candidate: non c e nessuna cartella dati che non sia gia di casa.'
}

# =====================================================================
# PASSO 2 -- LA CERTIFICAZIONE DAL GIORNALE.
#            <dati>\logs e' il GIORNALE. MQL5\Logs e' la scheda Esperti.
# =====================================================================
Dillo ('[2/6] certificazione dal giornale (<dati>\logs), candidate: ' + $candidate.Count.ToString($INV)) $null
$confermate = @()
foreach($c in $candidate){
  $dirLog = Join-Path $c.Path 'logs'
  $testo = ''
  $nlog = 0
  if(Test-Path -LiteralPath $dirLog){
    $files = @(Get-ChildItem -LiteralPath $dirLog -Filter *.log -ErrorAction SilentlyContinue |
               Sort-Object LastWriteTime -Descending | Select-Object -First 10)
    $nlog = $files.Count
    foreach($f in $files){ $testo = $testo + (Leggi-Testo $f.FullName) }
  }
  $haConto = ($testo -match ('(?<![0-9])' + [regex]::Escape($ContoAtteso) + '(?![0-9])'))
  $haFtmo  = (($testo -match '(?i)ftmo') -or ($c.Prog -match '(?i)ftmo'))
  $c | Add-Member -NotePropertyName Log -NotePropertyValue $testo -Force
  $riga = '      ' + $c.Hash + '  giornali ' + $nlog.ToString($INV)
  if($haConto){ $riga = $riga + '  conto ' + $ContoAtteso + ': TROVATO' } else { $riga = $riga + '  conto ' + $ContoAtteso + ': non trovato' }
  if($haFtmo){  $riga = $riga + '  |  FTMO: nominato' }             else { $riga = $riga + '  |  FTMO: non nominato' }
  if($haConto -and $haFtmo){
    Dillo ($riga + '  -> CONFERMATA') 'Green'
    $confermate += $c
  } else {
    Dillo ($riga + '  -> scartata') 'Yellow'
  }
}

if($confermate.Count -eq 0){
  Dillo '' $null
  Dillo '      NESSUNA CANDIDATA CONFERMATA. Serve che il GIORNALE contenga tutte e due le cose:' 'Yellow'
  Dillo ('      (a) il numero ' + $ContoAtteso + '   (b) la parola FTMO') 'Yellow'
  Dillo '      Se hai appena fatto il login il giornale puo essere ancora vuoto: aspetta che il' 'Yellow'
  Dillo '      terminale si colleghi (in basso a destra deve dire connesso) e rilancia.' 'Yellow'
  Dillo '      Se il numero e diverso da quello della mail FTMO, e -ContoAtteso a essere sbagliato.' 'Yellow'
  Muori ('nessuna delle ' + $candidate.Count.ToString($INV) + ' candidate porta nel giornale il conto ' + $ContoAtteso + ' insieme al nome FTMO.')
}
if($confermate.Count -gt 1){
  Dillo '' $null
  foreach($c in $confermate){ Dillo ('      ' + $c.Hash + '  ' + $c.Prog) 'Red' }
  Muori ('CONFERMATE ' + $confermate.Count.ToString($INV) + ' cartelle diverse con lo stesso conto: non so quale terminale stai guardando. Manda questo elenco e si decide a mano.')
}

$dati    = $confermate[0].Path
$prog    = $confermate[0].Prog
$giornale = $confermate[0].Log
Dillo '' $null
Dillo ('[2/6] BERSAGLIO CERTIFICATO -- conto ' + $ContoAtteso) 'Green'
Dillo ('      programma     : ' + $prog) 'Green'
Dillo ('      cartella dati : ' + $dati) 'Green'
Dillo ('      le altre ' + ($cartelle.Count - 1).ToString($INV) + ' cartelle dati di questa macchina non verranno nemmeno riaperte.') 'Green'

foreach($v in $NOMI_VIETATI){
  if($dati -like ('*' + $v + '*')){ Muori ('il percorso certificato "' + $dati + '" contiene "' + $v + '". Non e il terminale FTMO.') }
}
foreach($k in $HASH_NOTI.Keys){
  if($dati -like ('*' + $k + '*')){ Muori ('il percorso certificato "' + $dati + '" e la cartella nota ' + $HASH_NOTI[$k] + '. Non e il terminale FTMO.') }
}

# ---------------------------------------------------------------------
# LA FOTO DELLE FINESTRE -- sola LETTURA (regola dei terminali multipli).
# Get-Process qui ENUMERA e basta: non avvia, non chiude, non termina.
# ---------------------------------------------------------------------
Dillo '' $null
Dillo '      FINESTRE MT5 APERTE ADESSO (solo elenco: PID, titolo, cartella del programma)' $null
try {
  $pr = @(Get-Process terminal64 -ErrorAction SilentlyContinue)
  if($pr.Count -eq 0){
    Dillo '        nessun terminal64 in esecuzione (strano: hai appena fatto il login?)' 'Yellow'
  } else {
    foreach($p in $pr){
      $tit = ''
      $pth = ''
      try { $tit = $p.MainWindowTitle } catch { $tit = '(titolo non leggibile)' }
      try { $pth = $p.Path }            catch { $pth = '(percorso non leggibile)' }
      Dillo ('        PID ' + ($p.Id.ToString($INV)).PadLeft(6) + '  ' + ($tit + '                                        ').Substring(0,40) + '  ' + $pth) $null
    }
  }
} catch {
  Dillo ('        elenco processi non disponibile: ' + $_.Exception.Message) 'Yellow'
}

$CASELLE = New-Object Collections.ArrayList
function Casella($n, $nome, $esito, $dettaglio) {
  [void]$CASELLE.Add([pscustomobject]@{ N=$n; Nome=$nome; Esito=$esito; Dettaglio=$dettaglio })
}

# =====================================================================
# CASELLA 1 -- L'OROLOGIO
# =====================================================================
Dillo '' $null
Dillo '=====================================================================' $null
Dillo ' CASELLA 1 -- L OROLOGIO DEL SERVER FTMO' $null
Dillo '=====================================================================' $null

$oraLoc = Get-Date
$tzLoc  = [TimeZoneInfo]::Local
$offLoc = $tzLoc.GetUtcOffset($oraLoc)
$utcOra = $oraLoc.ToUniversalTime()
$offOre = [int][math]::Round($offLoc.TotalHours)

Dillo ('  ora di Windows      : ' + $oraLoc.ToString('yyyy-MM-dd HH:mm:ss', $INV)) $null
Dillo ('  fuso di Windows     : ' + $tzLoc.Id + '   offset UTC ' + $offLoc.ToString()) $null
Dillo ('  ora UTC adesso      : ' + $utcOra.ToString('yyyy-MM-dd HH:mm:ss', $INV)) $null

# Il primo controllo e' sul RIGHELLO, non sul misurato: tutta l aritmetica
# di casa ("BCM = ora italiana -1") vale solo se l orologio di Windows E'
# in ora italiana. Se non lo e, la casella resta aperta e si dice.
$riferimentoOk = $false
if($offOre -eq 1 -or $offOre -eq 2){
  $riferimentoOk = $true
  Dillo '  righello            : offset +1/+2 = compatibile con l ora italiana. L aritmetica di casa vale.' 'Green'
} else {
  Dillo ('  righello            : ATTENZIONE, offset ' + $offOre.ToString($INV) + ' ORE: questa macchina NON e in ora italiana.') 'Red'
  Dillo '                        La regola di casa "BCM = ora italiana -1" non si puo applicare da qui.' 'Red'
  Dillo '                        Tutti i delta qui sotto sono CONDIZIONATI a questo, e la casella resta APERTA.' 'Red'
}
$bcmOff = $offOre - 1
Dillo ('  BCM (regola di casa): ora italiana -1  ->  ' + (Fuso $bcmOff)) $null
Dillo ('  FTMO atteso         : ' + (Fuso ($bcmOff + 2)) + '  (cioe BCM +2) -- e QUESTO il numero su cui sono rimappati i 10 preset') $null
Dillo '' $null
Dillo '  LA TABELLA DA CONFRONTARE -- leggi l ora del SERVER e cerca la riga:' $null
Dillo '' $null
Dillo '     se il server dice   allora il server e   e rispetto a BCM e   verdetto' $null
Dillo '     -----------------   ------------------   ------------------   -----------------------------' $null
for($h = $bcmOff - 1; $h -le $bcmOff + 4; $h++){
  $att = $utcOra.AddHours($h).ToString('HH:mm', $INV)
  $dl  = $h - $bcmOff
  $seg = '+' + $dl.ToString($INV)
  if($dl -lt 0){ $seg = $dl.ToString($INV) }
  $ver = 'orari dei preset DA RIFARE'
  $col = 'Yellow'
  if($dl -eq 2){ $ver = '+2 COME PREVISTO: i preset vanno bene'; $col = 'Green' }
  if($dl -eq 3){ $ver = 'ATTENZIONE +3: i preset vanno RIGENERATI (-1 ora su tutti)' }
  if($dl -eq 0){ $ver = 'FTMO = BCM: buttare tutta la colonna FTMO' }
  Dillo ('     ' + $att.PadRight(19) + (Fuso $h).PadRight(21) + ('BCM ' + $seg).PadRight(21) + $ver) $col
}
Dillo '' $null
Dillo '  DOVE SI LEGGE L ORA DEL SERVER (a mano, 10 secondi):' 'Cyan'
Dillo '    a) Market Watch (Ctrl+M) -> tasto destro sulla lista -> Colonne/Columns -> spunta "Ora"/"Time".' 'Cyan'
Dillo '       La colonna Ora e l ora SERVER dell ULTIMO TICK.' 'Cyan'
Dillo '    b) controprova: apri un grafico M1 e guarda l ora dell ULTIMA candela.' 'Cyan'
Dillo '' $null
Dillo '  TRAPPOLA, E STASERA E QUELLA VERA -- oggi e DOMENICA:' 'Red'
Dillo '    a mercato CHIUSO la colonna Ora NON dice che ore sono: dice quando e arrivato' 'Red'
Dillo '    l ULTIMO TICK, che puo essere di VENERDI. Prima di usare quel numero GUARDA LA DATA:' 'Red'
Dillo '    se la data non e quella di OGGI, la lettura non vale e la casella resta APERTA.' 'Red'
Dillo '    Gli indici riaprono la domenica sera: si rilegge allora, PRIMA di accendere AutoTrading.' 'Red'

# Tentativo AUTOMATICO, e vale come INDIZIO, mai come verdetto.
# Nel giornale certe righe portano DENTRO una data-ora che arriva dal
# SERVER, mentre il prefisso della riga e in ora LOCALE del PC.
$indizi = @()
foreach($r in ($giornale -split "`n")){
  $m = [regex]::Match($r, '^\s*[A-Za-z]*\s*[0-9]*\s*([0-9]{2}):([0-9]{2}):([0-9]{2})\.[0-9]{3}\s+.*?([0-9]{4})\.([0-9]{2})\.([0-9]{2})\s+([0-9]{2}):([0-9]{2}):([0-9]{2})')
  if(-not $m.Success){ continue }
  $hLoc = [int]::Parse($m.Groups[1].Value, $INV)
  $mLoc = [int]::Parse($m.Groups[2].Value, $INV)
  $hSrv = [int]::Parse($m.Groups[7].Value, $INV)
  $mSrv = [int]::Parse($m.Groups[8].Value, $INV)
  $dmin = ($hSrv * 60 + $mSrv) - ($hLoc * 60 + $mLoc)
  while($dmin -gt 720){  $dmin = $dmin - 1440 }
  while($dmin -lt -720){ $dmin = $dmin + 1440 }
  $vecchia = ''
  if($r -match '(?i)previous'){ $vecchia = '  <<< ACCESSO PRECEDENTE: questo scarto NON e il fuso, e la distanza fra due LOGIN' }
  $indizi += [pscustomobject]@{ Delta = $dmin; Riga = (($r -replace '[^\u0020-\u007E]', '').Trim() + $vecchia) }
}
Dillo '' $null
if($indizi.Count -eq 0){
  Dillo '  indizio automatico dal giornale: NESSUNA riga porta dentro una data-ora del server.' $null
  Dillo '  (E normale su un terminale appena installato.) La casella la chiude la lettura a mano.' $null
} else {
  Dillo ('  INDIZIO AUTOMATICO dal giornale (' + $indizi.Count.ToString($INV) + ' righe con dentro una data-ora):') 'Cyan'
  $q = 0
  foreach($i in $indizi){
    $oreD = [math]::Round($i.Delta / 60.0, 2)
    Dillo ('    scarto ' + $oreD.ToString('F2', $INV).PadLeft(7) + ' ore   ' + $i.Riga) $null
    $q++
    if($q -ge 5){ break }
  }
  Dillo '    QUESTO NON CHIUDE LA CASELLA: molte di queste date sono di ACCESSI PRECEDENTI,' 'Yellow'
  Dillo '    quindi lo scarto non e il fuso. E un indizio da confrontare con la lettura a mano.' 'Yellow'
}
Casella 1 'orologio del server' 'A MANO (guidata)' 'la sonda ha stampato la tabella e il verdetto per ogni ora possibile: serve UN numero letto in Market Watch, valido solo a mercato APERTO'

# =====================================================================
# CASELLA 2 -- I NOMI DEI SIMBOLI
# =====================================================================
Dillo '' $null
Dillo '=====================================================================' $null
Dillo ' CASELLA 2 -- I NOMI VERI DEI SIMBOLI' $null
Dillo '=====================================================================' $null

$universo = New-Object 'System.Collections.Generic.HashSet[string]'
$fonte    = @{}
$nFile    = 0
$nDir     = 0

function Aggiungi-Parola($w, $dove) {
  if([string]::IsNullOrEmpty($w)){ return }
  if($universo.Add($w)){ $fonte[$w] = $dove }
}

# (a) i NOMI DI CARTELLA sotto bases\<server>\: MT5 crea una cartella per
#     simbolo quando scarica storico o tick. Quando ci sono, sono nomi
#     VERI, non parole pescate dal rumore.
$dirBases = Join-Path $dati 'bases'
$serverDaBases = @()
if(Test-Path -LiteralPath $dirBases){
  foreach($srv in @(Get-ChildItem -LiteralPath $dirBases -Directory -ErrorAction SilentlyContinue)){
    if($srv.Name -eq 'Custom'){ continue }
    $serverDaBases += $srv.Name
    foreach($l1 in @(Get-ChildItem -LiteralPath $srv.FullName -Directory -ErrorAction SilentlyContinue)){
      foreach($l2 in @(Get-ChildItem -LiteralPath $l1.FullName -Directory -ErrorAction SilentlyContinue)){
        Aggiungi-Parola ($l2.Name.ToUpperInvariant()) ('cartella bases\' + $srv.Name + '\' + $l1.Name)
        $nDir++
      }
    }
  }
}

# (b) le PAROLE dentro i file di servizio di bases\ (la lista simboli che
#     il server ha mandato). Solo file piccoli, mai i tick (.tkc/.hcc).
$estOk = @('.sel', '.raw', '.dat', '.ini', '.txt', '')
if(Test-Path -LiteralPath $dirBases){
  $tutti = @(Get-ChildItem -LiteralPath $dirBases -File -Recurse -ErrorAction SilentlyContinue |
             Where-Object { $_.Length -le 4194304 -and ($estOk -contains $_.Extension.ToLowerInvariant()) } |
             Sort-Object Length -Descending | Select-Object -First 60)
  foreach($f in $tutti){
    if($CRONO.Elapsed.TotalSeconds -gt 60){ break }
    $b = Leggi-Byte $f.FullName 4194304
    foreach($w in (Parole-Da-Bytes $b)){ Aggiungi-Parola $w ('file ' + $f.Name) }
    $nFile++
  }
}

# (c) i simboli dei grafici gia' aperti (.chr e' TESTO in MT5). Su un
#     terminale appena installato c e il profilo Default coi suoi grafici:
#     quei nomi sono nomi VERI del broker.
$dirChr = Join-Path $dati 'MQL5\Profiles\Charts'
$nChr = 0
if(Test-Path -LiteralPath $dirChr){
  foreach($f in @(Get-ChildItem -LiteralPath $dirChr -Filter *.chr -Recurse -ErrorAction SilentlyContinue | Select-Object -First 60)){
    $t = Leggi-Testo $f.FullName
    foreach($m in [regex]::Matches($t, '(?m)^\s*symbol=([^\r\n]+)')){
      Aggiungi-Parola ($m.Groups[1].Value.Trim().ToUpperInvariant()) ('grafico ' + $f.Name)
      $nChr++
    }
  }
}

Dillo ('  fonti lette: ' + $nDir.ToString($INV) + ' nomi di cartella sotto bases, ' + $nFile.ToString($INV) + ' file di servizio, ' + $nChr.ToString($INV) + ' righe symbol= nei grafici.') $null
if($serverDaBases.Count -gt 0){
  Dillo ('  nome del SERVER dal disco: ' + ($serverDaBases -join ', ')) 'Green'
}
Dillo ('  parole candidate in tutto : ' + $universo.Count.ToString($INV)) $null
Dillo '' $null

$mercatiChiusi = 0
foreach($mk in $MERCATI){
  $trovati = @()
  foreach($w in $universo){ if($w -match $mk.Regex){ $trovati += $w } }
  $trovati = @($trovati | Sort-Object)
  if($trovati.Count -eq 1){
    Dillo ('  ' + $mk.Mercato + ' (noi ' + $mk.Nostro + ')  ->  CANDIDATO UNICO: ' + $trovati[0] + '   [' + $fonte[$trovati[0]] + ']') 'Green'
    $mercatiChiusi++
  } elseif($trovati.Count -eq 0){
    Dillo ('  ' + $mk.Mercato + ' (noi ' + $mk.Nostro + ')  ->  NESSUN CANDIDATO. Non scelgo io: leggilo a mano (Ctrl+U).') 'Yellow'
  } else {
    Dillo ('  ' + $mk.Mercato + ' (noi ' + $mk.Nostro + ')  ->  ' + $trovati.Count.ToString($INV) + ' CANDIDATI, SCEGLI TU:') 'Yellow'
    foreach($t in $trovati){ Dillo ('        ' + $t.PadRight(18) + ' [' + $fonte[$t] + ']') 'Yellow' }
  }
}
Dillo '' $null
Dillo '  COME SI CHIUDE A MANO, ed e la fonte che vince su tutto:' 'Cyan'
Dillo '    Visualizza/View -> Simboli/Symbols (Ctrl+U): li c e l albero COMPLETO del broker.' 'Cyan'
Dillo '    Copia il nome ESATTO dei cinque (DAX, Dow, Nasdaq, Oro, USDJPY), maiuscole comprese.' 'Cyan'
if($TuttiISimboli -and $universo.Count -gt 0){
  Dillo '' $null
  Dillo '  ELENCO GREZZO (le prime 400 parole trovate: c e dentro anche rumore binario)' $null
  $q = 0
  foreach($w in ($universo | Sort-Object)){
    Dillo ('    ' + $w) $null
    $q++
    if($q -ge 400){ break }
  }
}
if($mercatiChiusi -eq $MERCATI.Count){
  Casella 2 'nomi dei simboli' 'CHIUSA DALLA SONDA' 'un candidato unico per tutti e cinque i mercati -- da confermare in Ctrl+U prima di aprire i grafici'
} elseif($mercatiChiusi -gt 0){
  Casella 2 'nomi dei simboli' 'MEZZA' (($mercatiChiusi).ToString($INV) + ' mercati su ' + $MERCATI.Count.ToString($INV) + ' hanno un candidato unico. Gli altri si leggono in Ctrl+U')
} else {
  Casella 2 'nomi dei simboli' 'A MANO' 'il disco non ha ancora la lista simboli: si legge in Ctrl+U (Visualizza -> Simboli)'
}

# =====================================================================
# CASELLE 3-4-5 -- MARGINE, DIGITS/POINT, SPREAD
# =====================================================================
Dillo '' $null
Dillo '=====================================================================' $null
Dillo ' CASELLE 3-4-5 -- MARGINE, DIGITS/POINT, SPREAD' $null
Dillo '=====================================================================' $null

# La porta di servizio: se qualcuno ha gia' fatto girare lo script MQL5
# che scarica le specifiche in MQL5\Files, questa sonda le legge e la
# casella si chiude DA SOLA. Se non c e, si va a mano e si dice.
$fSpec = Join-Path $dati 'MQL5\Files\PREVOLO_FTMO_specifiche.csv'
$specLette = $false
if(Test-Path -LiteralPath $fSpec){
  $t = Leggi-Testo $fSpec
  $rr = @($t -split "`n" | Where-Object { $_.Trim().Length -gt 0 })
  if($rr.Count -gt 1){
    Dillo ('  TROVATO ' + $fSpec + ' -- le specifiche sono gia state misurate dal terminale:') 'Green'
    foreach($r in $rr){ Dillo ('    ' + ($r -replace '[^\u0020-\u007E]', '').Trim()) 'Green' }
    $specLette = $true
  }
}
if(-not $specLette){
  Dillo '  NON SONO LEGGIBILI DA POWERSHELL, e lo dico invece di inventarle.' 'Yellow'
  Dillo '  MT5 tiene le specifiche di contratto nei file binari di bases\ e in memoria:' 'Yellow'
  Dillo '  non esiste nessun file di testo da cui ricavarle senza indovinare il formato.' 'Yellow'
  Dillo '' $null
  Dillo '  COME SI LEGGONO A MANO (2 minuti, e chiudono TRE caselle):' 'Cyan'
  Dillo '    Market Watch -> tasto destro sul simbolo -> Specifica/Specification' 'Cyan'
  Dillo '    (oppure Ctrl+U -> scegli il simbolo -> scheda Specifica)' 'Cyan'
  Dillo '' $null
  Dillo '  COPIA QUESTO MODULO E RIEMPILO, UNO PER SIMBOLO (o mandane lo screenshot):' 'Cyan'
  Dillo '    ---------------------------------------------------------------' $null
  Dillo '    SIMBOLO ....................... ______________' $null
  Dillo '    Digits (decimali) ............. ______   <- CASELLA 4' $null
  Dillo '    Contract size ................. ______   <- CASELLA 3' $null
  Dillo '    Tick size / Tick value ........ ______ / ______' $null
  Dillo '    Initial margin (1 lotto) ...... ______   <- CASELLA 3 e 6 insieme' $null
  Dillo '    Stops level ................... ______' $null
  Dillo '    Spread corrente (Market Watch)  ______   <- CASELLA 5' $null
  Dillo '    ---------------------------------------------------------------' $null
}

# QUELLO CHE LA SONDA PUO' FARE COMUNQUE: dire che cosa CAMBIA a seconda
# del numero che Claudio legge. Cosi la lettura a mano e un confronto,
# non un giudizio. I valori arrivano dai preset gia presenti sul disco.
$dirPre = Join-Path $dati 'MQL5\Presets'
# InpMaxSpread NON sta in questa tabella di proposito: non e un LIVELLO da
# riscalare coi Digits, e un TETTO di spread. Metterlo qui sarebbe leggere
# un input per il nome invece che per quello che fa (classe 478). Va nel
# paragrafo dello spread, qui sotto.
$chiavi = @('InpBufferPoints', 'InpMinStopPts', 'InpRetestOffsetPts')
$trovatePreset = 0
if(Test-Path -LiteralPath $dirPre){
  Dillo '' $null
  Dillo '  PERCHE DIGITS CONTA -- i valori IN PUNTI che stanno nei preset gia sul disco:' $null
  Dillo '' $null
  Dillo '     preset / input                                        punti    Digits=1   Digits=2   Digits=3' $null
  Dillo '     ----------------------------------------------------  -------  ---------  ---------  ---------' $null
  foreach($f in @(Get-ChildItem -LiteralPath $dirPre -Filter *.set -ErrorAction SilentlyContinue | Select-Object -First 40)){
    $t = Leggi-Testo $f.FullName
    foreach($k in $chiavi){
      $m = [regex]::Match($t, '(?m)^\s*' + $k + '\s*=\s*([0-9]+(?:\.[0-9]+)?)\s*$')
      if(-not $m.Success){ continue }
      $v = 0.0
      if(-not [double]::TryParse($m.Groups[1].Value, [Globalization.NumberStyles]::Float, $INV, [ref]$v)){ continue }
      $nm = $f.BaseName
      if($nm.Length -gt 26){ $nm = $nm.Substring(0, 12) + '~' + $nm.Substring($nm.Length - 13) }
      $et = ($nm + ' / ' + $k)
      $c1 = ($v / 10.0).ToString('F2', $INV)
      $c2 = ($v / 100.0).ToString('F2', $INV)
      $c3 = ($v / 1000.0).ToString('F3', $INV)
      Dillo ('     ' + $et.PadRight(52) + '  ' + $v.ToString('F1', $INV).PadLeft(7) + '  ' + $c1.PadLeft(9) + '  ' + $c2.PadLeft(9) + '  ' + $c3.PadLeft(9)) $null
      $trovatePreset++
    }
  }
  if($trovatePreset -eq 0){
    Dillo '     (nessun preset di casa ancora in MQL5\Presets: questa tabella si riempie dopo SCHIERA_FTMO)' 'Yellow'
  } else {
    Dillo '' $null
    Dillo '     Le tre colonne sono lo STESSO input letto con Digits diverso, in punti indice.' $null
    Dillo '     Esempio misurato in casa: U30USD ha Digits=2, e InpBufferPoints=1000 vale 10,00' $null
    Dillo '     punti di indice. Se il simbolo FTMO avesse Digits=1, gli stessi 1000 diventano' $null
    Dillo '     100,0 punti: il livello di rottura si sposta di DIECI VOLTE. Non e un dettaglio.' 'Yellow'
  }
}
# IL TETTO DI SPREAD, letto per quello che FA: 0 vuol dire filtro SPENTO.
if(Test-Path -LiteralPath $dirPre){
  $spenti = @()
  $accesi = @()
  foreach($f in @(Get-ChildItem -LiteralPath $dirPre -Filter *.set -ErrorAction SilentlyContinue | Select-Object -First 40)){
    $m = [regex]::Match((Leggi-Testo $f.FullName), '(?m)^\s*InpMaxSpread\s*=\s*([0-9]+(?:\.[0-9]+)?)\s*$')
    if(-not $m.Success){ continue }
    $v = 0.0
    if(-not [double]::TryParse($m.Groups[1].Value, [Globalization.NumberStyles]::Float, $INV, [ref]$v)){ continue }
    if($v -le 0){ $spenti += $f.BaseName } else { $accesi += ($f.BaseName + ' = ' + $v.ToString('F1', $INV)) }
  }
  if($spenti.Count -gt 0 -or $accesi.Count -gt 0){
    Dillo '' $null
    Dillo '  IL TETTO DI SPREAD NEI PRESET GIA SUL DISCO (InpMaxSpread):' $null
    foreach($x in $spenti){ Dillo ('    FILTRO SPENTO (=0)   ' + $x) 'Yellow' }
    foreach($x in $accesi){ Dillo ('    tetto acceso         ' + $x) $null }
  }
}
Dillo '' $null
Dillo '  E PERCHE CONTA LO SPREAD: la frontiera di casa e stop >= 40 x spread.' $null
Dillo '  Con InpMaxSpread=0 il filtro e SPENTO: la sedia entra anche col libro largo.' 'Yellow'
Dillo '  Lo spread si legge in Market Watch (colonna Spread) NEGLI ISTANTI IN CUI LA SEDIA' 'Yellow'
Dillo '  ENTRA (apertura di mercato), non a mercato fermo: e il momento peggiore della giornata.' 'Yellow'

if($specLette){
  Casella 3 'margine per lotto'   'CHIUSA DALLA SONDA' 'letta da MQL5\Files\PREVOLO_FTMO_specifiche.csv'
  Casella 4 'Digits e Point'      'CHIUSA DALLA SONDA' 'letta da MQL5\Files\PREVOLO_FTMO_specifiche.csv'
  Casella 5 'spread'              'CHIUSA DALLA SONDA' 'letta da MQL5\Files\PREVOLO_FTMO_specifiche.csv'
} else {
  Casella 3 'margine per lotto'   'A MANO' 'Specifica del simbolo -> Initial margin. Nessun file di testo la contiene.'
  Casella 4 'Digits e Point'      'A MANO' 'Specifica del simbolo -> Digits. La sonda ha stampato la tabella di che cosa cambia.'
  Casella 5 'spread'              'A MANO' 'Market Watch colonna Spread, letta all ora di ingresso della sedia.'
}

# =====================================================================
# CASELLA 6 -- CONTO, SERVER, LEVA
# =====================================================================
Dillo '' $null
Dillo '=====================================================================' $null
Dillo ' CASELLA 6 -- CONTO, SERVER, TIPO DI CONTO E LEVA' $null
Dillo '=====================================================================' $null
Dillo ('  numero di conto  : ' + $ContoAtteso + '  (CERTIFICATO: e scritto nel giornale di questa cartella dati)') 'Green'
if($serverDaBases.Count -gt 0){
  Dillo ('  server dal disco : ' + ($serverDaBases -join ', ') + '  (nome della cartella sotto bases\)') 'Green'
} else {
  Dillo '  server dal disco : non ancora scritto (bases\ vuota: il terminale non si e ancora collegato del tutto)' 'Yellow'
}

# config\*.ini per LISTA BIANCA: solo Server= e Login=. Nessuna riga di
# password viene letta, confrontata o stampata.
$dirCfg = Join-Path $dati 'config'
if(Test-Path -LiteralPath $dirCfg){
  $q = 0
  foreach($f in @(Get-ChildItem -LiteralPath $dirCfg -Filter *.ini -ErrorAction SilentlyContinue | Select-Object -First 10)){
    foreach($r in ((Leggi-Testo $f.FullName) -split "`n")){
      $rr = ($r -replace '[^\u0020-\u007E]', '').Trim()
      if($rr -match '^(Server|Login)\s*='){
        Dillo ('  config\' + $f.Name + ' : ' + $rr) $null
        $q++
        if($q -ge 12){ break }
      }
    }
    if($q -ge 12){ break }
  }
}

$rigLog = @()
foreach($r in ($giornale -split "`n")){
  if($r -match '(?i)(authoriz|login|connect|account|server)'){
    $rr = ($r -replace '[^\u0020-\u007E]', '').Trim()
    if($rr.Length -gt 0){ $rigLog += $rr }
  }
}
if($rigLog.Count -gt 0){
  Dillo '' $null
  Dillo '  LE RIGHE DEL GIORNALE CHE PARLANO DI CONTO E SERVER (le ultime 8):' $null
  $da = [math]::Max(0, $rigLog.Count - 8)
  for($i = $da; $i -lt $rigLog.Count; $i++){ Dillo ('    ' + $rigLog[$i]) $null }
}
Dillo '' $null
Dillo '  LEVA, VALUTA E SALDO: NON stanno in nessun file di testo. Si leggono a mano:' 'Cyan'
Dillo '    - Cassetta degli attrezzi (Ctrl+T) -> scheda Trading: Saldo, Equity, Margine libero;' 'Cyan'
Dillo '    - la LEVA sta nell area clienti FTMO (dettagli del conto).' 'Cyan'
Dillo '  CONTROPROVA CHE NON COSTA NIENTE, e vale piu della schermata:' 'Cyan'
Dillo '    Initial margin del Dow per 1 lotto diviso il prezzo x contract size = 1/leva.' 'Cyan'
Dillo '    Con Dow a 46000 e 1 lotto = 1 indice: 1:100 -> circa 460 $; 1:15 -> circa 3.067 $.' 'Cyan'
Dillo '    Sono due numeri che non si somigliano: la Specifica risponde da sola.' 'Cyan'
Casella 6 'tipo di conto e leva' 'MEZZA' 'conto e server CHIUSI dal disco; leva, valuta e saldo si leggono in Ctrl+T e nell area clienti (la Specifica del Dow fa da controprova)'

# =====================================================================
# IL QUADRO DELLE SEI CASELLE
# =====================================================================
Dillo '' $null
Dillo '=====================================================================' $null
Dillo ' LE SEI CASELLE -- QUELLO CHE HO CHIUSO IO E QUELLO CHE RESTA A TE' $null
Dillo '=====================================================================' $null
$aperte = 0
$chiuse = 0
$mezze  = 0
foreach($c in $CASELLE){
  $col = 'Yellow'
  if($c.Esito -eq 'CHIUSA DALLA SONDA'){ $col = 'Green'; $chiuse++ }
  else {
    $aperte++
    if($c.Esito -eq 'MEZZA'){ $mezze++ }
  }
  Dillo ('  ' + $c.N.ToString($INV) + '. ' + $c.Nome.PadRight(22) + $c.Esito.PadRight(20) + $c.Dettaglio) $col
}
Dillo '' $null
Dillo ('  CONTO: ' + $chiuse.ToString($INV) + ' chiuse dalla sonda, ' + $mezze.ToString($INV) + ' mezze, ' + ($aperte - $mezze).ToString($INV) + ' tutte da leggere a mano.') $null
Dillo '' $null
Dillo '  NIENTE DI QUESTO SCRIPT HA SCRITTO DENTRO IL TERMINALE. Ha letto, e basta.' $null

# ---------------------------------------------------------------------
# LA RACCOLTA: referto sul Desktop del VPS + zip, con l elenco atteso.
# ---------------------------------------------------------------------
$CRONO.Stop()
Dillo '' $null
Dillo ('  durata: ' + $CRONO.Elapsed.TotalSeconds.ToString('F1', $INV) + ' s  (tetto dichiarato: 120 s. Oltre, e il disco.)') $null

$fRef = Posa-Referto
$zip = Join-Path $DESKTOP ('PREVOLO_FTMO_' + $STAMPA + '.zip')
try {
  Compress-Archive -Path (Join-Path $CARTREF '*') -DestinationPath $zip -Force
} catch {
  Write-Host ('zip non riuscito: ' + $_.Exception.Message) -ForegroundColor Yellow
  $zip = '(non creato)'
}
Write-Host ''
Write-Host 'LA RACCOLTA (sul Desktop di questa macchina):' -ForegroundColor Green
Write-Host ('  cartella: ' + $CARTREF) -ForegroundColor Green
Write-Host ('  referto : ' + $fRef) -ForegroundColor Green
Write-Host ('  zip     : ' + $zip) -ForegroundColor Green
Write-Host '  dentro lo zip devi trovare UN file:' -ForegroundColor Green
Write-Host ('    - PREVOLO_FTMO_' + $STAMPA + '_referto.txt') -ForegroundColor Green
Write-Host ('  LA PRIMA RIGA del referto dice   data: ' + (Get-Date).ToString('yyyy-MM-dd HH:mm:ss', $INV)) -ForegroundColor Green
Write-Host '  Se il referto che mandi porta una data diversa, e un referto VECCHIO.' -ForegroundColor Green
Write-Host ''

if($aperte -eq 0){ exit 0 }
Write-Host ('  ' + $aperte.ToString($INV) + ' caselle su ' + $CASELLE.Count.ToString($INV) + ' NON sono chiuse dal disco (' + $mezze.ToString($INV) + ' a meta): sono dichiarate qui sopra, una per una.') -ForegroundColor Yellow
Write-Host '  USCITA 2 = la sonda ha girato e il bersaglio e certificato, ma il referto ha dei buchi DICHIARATI.' -ForegroundColor Yellow
exit 2
