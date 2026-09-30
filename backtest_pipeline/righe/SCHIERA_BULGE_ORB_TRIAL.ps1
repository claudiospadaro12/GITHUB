# =====================================================================
#  MARCATORE_SCHIERA_BULGE_ORB_TRIAL_v1
#
#  PORTA DUE EA (ABTG_Bulge v5.20 SOLO VIOLA e ABTG_ORB_Ottimizzato
#  v1.04 "ORB DOW") NEL TERMINALE DELLA FREE TRIAL FTMO. SOLO COPIA.
#  NON compila (F7 a mano), NON attacca EA, NON apre grafici, NON
#  accende Algo Trading, NON scrive .chr/profili/config.
#
#  Pacchetto: report/PACCHETTO_BULGE_ORB_TRIAL_2026-10-01.md
#  Modello  : backtest_pipeline/righe/SCHIERA_FTMO.ps1 (NON modificato:
#             questo e' un file NUOVO e separato, con i suoi pin)
#
#  LA CARTELLA DATI SI SCOPRE, non e' cablata. Serrature, in ordine:
#    1. non e' una delle SETTE cartelle di casa (per HASH);
#    2. origin.txt non contiene BCM / Pepperstone / Tickmill /
#       MT5_Backtest / MT5_MANUALE;
#    3. il GIORNALE (<dati>\logs) contiene -ContoAtteso;
#    4. il giornale o origin.txt nominano FTMO;
#    5. (NUOVA, 30/09 sera) la trial e' stata aperta DENTRO C:\FTMO, il cui
#       giornale contiene ANCHE il login della challenge 541452707: quindi
#       "il giornale nomina la trial" non basta. Serve che l'ULTIMA
#       comparsa del login trial venga DOPO l'ultima del login
#       challenge (ordine cronologico dei giornali). Se il vecchio login
#       e' piu' recente, la riga RIFIUTA: il terminale sta ancora sul
#       conto sbagliato, o si e' riloggato sulla challenge;
#    6. UNA sola candidata confermata, altrimenti si rifiuta.
#  -ContoAtteso viene rifiutato in partenza se e' un conto di casa o
#  il login della challenge. La cartella dati C:\FTMO (hash 46C9F8E9...,
#  CODA_01 del 30/09) NON e' piu' in lista nera: e' il bersaglio previsto
#  (strada A); se la trial fosse in una cartella dedicata nuova (strada
#  B) la scoperta la trova comunque, con le stesse serrature.
#  Il sorgente .mqh gia' presente e DIVERSO e' uno STOP, non una
#  sovrascrittura: sette sedie sono compilate contro di lui.
#
#  QUELLO CHE COPIA: 3 sorgenti (2 EA + l'include di guardia) e 2 preset.
#  Ogni sorgente ha il SUO pin e la sua impronta CONGELATA qui dentro
#  (SHA256 del testo normalizzato: CRLF/BOM/non-ASCII tolti, stessa
#  funzione Scheletro di SCHIERA_FTMO.ps1, verificata sui suoi numeri).
#  Ogni preset ha la sua impronta congelata E il controllo di merito
#  (deve contenere InpMagic / Magic attesi). Se qualcosa non torna si
#  FERMA PRIMA DI SCRIVERE.
#
#  COSA NON FA, ed e' verificabile riga per riga: nessuna chiamata
#  capace di toccare un processo; nessuna scrittura fuori da
#  MQL5\Experts, MQL5\Include, MQL5\Presets del terminale certificato;
#  nessuna modifica di un preset; un preset gia' presente e DIVERSO
#  non si sovrascrive mai (il repo gli viene messo accanto, _DAL_REPO).
#  NON contiene il Guardian 779001: e' un PREREQUISITO, non e' qui
#  (vedi il pacchetto: senza il Guardian le due sedie sono fail-open).
#
#  ASCII PURO: niente emoji, niente accentate (PS 5.1 legge i .ps1
#  come ANSI -- regola di casa del 17/08).
# =====================================================================

param(
  [Parameter(Mandatory=$true)][string]$ContoAtteso,
  [Parameter(Mandatory=$true)][string]$Pin,
  [switch]$SoloDiagnosi
)

$ErrorActionPreference = 'Stop'
$INV = [Globalization.CultureInfo]::InvariantCulture
try { [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12 } catch { }

$REPO_RAW = 'https://raw.githubusercontent.com/claudiospadaro12/GITHUB'
$LOGIN_CHALLENGE = '541452707'

# Lista nera: compare QUI solo per essere RIFIUTATA. Nessuna scrittura punta qui.
$HASH_NOTI = @{
  '215D85D767A1C39E22D242C8114BF9F5' = '50503392  piccolo demo      (C:\Program Files\BCM Markets MT5 Terminal)'
  'BCA8AD18563BF5B64A433C2662D0A104' = '50504263  100k demo         (C:\Program Files\BCM Markets MT5 Terminal -V3)'
  'E23E1504A8D02A22179395F0652B86B6' = '10105439  *** REALE ***     (C:\BCM_Reale)'
  '04C7A32B575E40027B4FF8724D14D702' = '50504400  banco di backtest (C:\MT5_Backtest)'
  'CF6C240A869369695913FB76DA84BD22' = '50503635  manuale           (C:\MT5_MANUALE)'
  '73B7A2420D6397DFF9014A20F1201F97' = 'broker esterno Pepperstone'
  '857385E4B0F2356AD99AA95CDF40FAE9' = 'broker esterno Tickmill'
}
$HASH_FTMO_CENSITO = '46C9F8E9FF0C747B2B5E09BCC13D5237'   # C:\FTMO, CODA_01 del 30/09: solo per STAMPARE una nota
$NOMI_VIETATI  = @('BCM', 'Pepperstone', 'Tickmill', 'MT5_Backtest', 'MT5_MANUALE')
$CONTI_DI_CASA = @('50503392', '50504263', '10105439', '50504400', '50503635', $LOGIN_CHALLENGE)

# I SORGENTI: pin e impronta congelati (misurati con Scheletro su git show <pin>:<percorso>).
$SORGENTI = @(
  [pscustomobject]@{ Nome='ABTG_Bulge.mq5';           Cartella='Experts'; RepoDir='mql5/Experts'; Pin='c4426c53a3977ba99ab997ad3d3ceb426a1a4fce'; Righe=2234; Sha='6540A22CB327D8EFD65DCD29C1716AA7A55021D41B8140F98BEEA8C34D95F70A'; Sedia='Bulge v5.20 (magic 772720)' },
  [pscustomobject]@{ Nome='ABTG_ORB_Ottimizzato.mq5'; Cartella='Experts'; RepoDir='mql5/Experts'; Pin='19312c8bb745e954c5456f9dba382416502d5bc6'; Righe=1463; Sha='19B596E3032DD0A0A7B7C44AE9ED53853D6BAF0DCF8E7AECA0E8D85DE9AEBE3C'; Sedia='ORB Ottimizzato v1.04 hedge-safe (magic 770621)' },
  [pscustomobject]@{ Nome='ABTG_PausaGuardian.mqh';   Cartella='Include'; RepoDir='mql5/Include'; Pin='26a185661c120de6fa0a33b79279595740e264e8'; Righe=398;  Sha='D179846B407FDACC963825103F850E8F8BEE39B1DA3521A504EF74F8638AC8BC'; Sedia='include v1.20 -- senza di lui nessun F7 parte' }
)

# I PRESET: dal -Pin, impronta congelata + controllo di merito.
$PRESET = @(
  [pscustomobject]@{ Nome='ABTG_Bulge_v520_SOLO_VIOLA_FTMO_TRIAL.set';  RepoDir='mql5/Presets/FTMO'; Firma='InpMagic=772720'; Righe=84; Sha='39EA8CAF6CCF660C8E43A07F3501D7B51087EE3F0902FCE2244475B517830D67'; Sedia='Bulge SOLO VIOLA' },
  [pscustomobject]@{ Nome='ABTG_ORB_Ottimizzato_DOW_FTMO_TRIAL.set';    RepoDir='mql5/Presets/FTMO'; Firma='InpMagic=770621'; Righe=109; Sha='A778B1AB57BF48C5318B06E71B5F546301E48FA5CF40173D2DF57FC3E3569FBD'; Sedia='ORB Dow' }
)

$RIGHE_REFERTO = New-Object Collections.ArrayList
function Dillo($testo, $colore) {
  if($colore){ Write-Host $testo -ForegroundColor $colore } else { Write-Host $testo }
  [void]$RIGHE_REFERTO.Add($testo)
}

# Lettura condivisa (stessa di SCHIERA_FTMO.ps1).
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

# Impronta normalizzata (stessa funzione di SCHIERA_FTMO.ps1).
function Scheletro($testo) {
  $t = $testo -replace "`r`n", "`n"
  $t = $t -replace "`r", "`n"
  $t = $t -replace '[^\u0009\u000A\u0020-\u007E]', ''
  $t = $t.TrimEnd("`n")
  $righe = ($t -split "`n").Count
  $sha = [Security.Cryptography.SHA256]::Create()
  try { $hb = $sha.ComputeHash([Text.Encoding]::ASCII.GetBytes($t)) } finally { $sha.Dispose() }
  $sb = New-Object Text.StringBuilder
  foreach($x in $hb){ [void]$sb.Append($x.ToString('X2', $INV)) }
  return [pscustomobject]@{ Righe = $righe; Sha = $sb.ToString(); Testo = $t }
}

$DESKTOP = Join-Path $env:USERPROFILE 'Desktop'
if(-not (Test-Path -LiteralPath $DESKTOP)){ $DESKTOP = $env:USERPROFILE }
$STAMPA  = (Get-Date).ToString('yyyy-MM-dd_HHmmss', $INV)
$CARTREF = Join-Path $DESKTOP ('SCHIERA_TRIAL_' + $STAMPA)

function Posa-Referto {
  try {
    if(-not (Test-Path -LiteralPath $CARTREF)){ [void](New-Item -ItemType Directory -Path $CARTREF -Force) }
    $f = Join-Path $CARTREF ('SCHIERA_TRIAL_' + $STAMPA + '_referto.txt')
    [IO.File]::WriteAllText($f, ($RIGHE_REFERTO -join "`r`n"), [Text.Encoding]::UTF8)
    return $f
  } catch { return '' }
}

function Muori($msg) {
  Dillo '' $null
  Dillo '=====================================================================' 'Red'
  Dillo ('FERMO: ' + $msg) 'Red'
  Dillo 'NESSUN FILE E STATO SCRITTO SU NESSUNA CARTELLA DATI.' 'Red'
  Dillo '=====================================================================' 'Red'
  $f = Posa-Referto
  if($f){ Write-Host ('referto di questo rifiuto: ' + $f) -ForegroundColor Yellow }
  exit 1
}

Dillo '=====================================================================' $null
Dillo ' SCHIERAMENTO TRIAL FTMO (Bulge + ORB Dow) -- SOLO COPIA. NESSUN F7.' $null
Dillo (' conto atteso : ' + $ContoAtteso) $null
Dillo (' pin preset   : ' + $Pin) $null
Dillo (' ora          : ' + (Get-Date).ToString('yyyy-MM-dd HH:mm:ss', $INV) + '  (ora locale del VPS)') $null
if($SoloDiagnosi){ Dillo ' MODO         : SOLA DIAGNOSI -- non scrivera NIENTE.' 'Yellow' }
Dillo '=====================================================================' $null

# PASSO 0 -- il conto atteso, controllato prima di guardare il disco.
if($ContoAtteso -notmatch '^[0-9]{6,12}$'){
  Muori ('-ContoAtteso vale "' + $ContoAtteso + '", che non e un numero di conto (servono 6-12 cifre).')
}
foreach($c in $CONTI_DI_CASA){
  if($ContoAtteso -eq $c){ Muori ('-ContoAtteso vale ' + $ContoAtteso + ', che e UN CONTO DI CASA o il login della challenge, non la trial. Questa serratura e scattata: si fosse accettato, avrei cercato la cartella di un terminale che NON va toccato.') }
}
if($Pin -notmatch '^[0-9a-fA-F]{40}$'){
  Muori ('-Pin vale "' + $Pin + '": serve lo SHA completo di 40 caratteri di un commit, non un ramo e non uno SHA corto.')
}
Dillo ('[0/7] -ContoAtteso ' + $ContoAtteso + ' accettato: non e nessuno dei sei conti noti (cinque di casa + challenge).') 'Green'

# PASSO 1 -- la scoperta: si elenca e si esclude, non si indovina.
$radice = Join-Path $env:APPDATA 'MetaQuotes\Terminal'
if(-not (Test-Path -LiteralPath $radice)){
  Muori ('non esiste ' + $radice + '. Su questa macchina non c e nessun MT5, oppure questa riga gira sull utente Windows sbagliato.')
}
$cartelle = @(Get-ChildItem -LiteralPath $radice -Directory -ErrorAction SilentlyContinue |
              Where-Object { Test-Path -LiteralPath (Join-Path $_.FullName 'MQL5') })
Dillo ('[1/7] cartelle dati sotto ' + $radice + ': ' + $cartelle.Count.ToString($INV)) $null

$candidate = @()
foreach($d in $cartelle){
  $nome = $d.Name
  $noto = ''
  foreach($k in $HASH_NOTI.Keys){ if($nome -eq $k){ $noto = $HASH_NOTI[$k] } }
  if($noto){ Dillo ('      ESCLUSA  ' + $nome + '  = ' + $noto) $null; continue }
  $fOrig = Join-Path $d.FullName 'origin.txt'
  if(-not (Test-Path -LiteralPath $fOrig)){
    Dillo ('      ESCLUSA  ' + $nome + '  = manca origin.txt: senza certificato non si scrive.') 'Yellow'
    continue
  }
  $prog = ((Leggi-Testo $fOrig) -replace '[^\u0020-\u007E]', '').Trim()
  $vietato = ''
  foreach($v in $NOMI_VIETATI){ if($prog -like ('*' + $v + '*')){ $vietato = $v } }
  if($vietato){ Dillo ('      ESCLUSA  ' + $nome + '  = "' + $prog + '" contiene "' + $vietato + '": cartella di casa.') $null; continue }
  $candidate += [pscustomobject]@{ Hash = $nome; Path = $d.FullName; Prog = $prog }
  Dillo ('      candidata ' + $nome + '  = "' + $prog + '"') 'Cyan'
}
if($candidate.Count -eq 0){
  Dillo '      NESSUNA CANDIDATA: il terminale della trial non e installato/avviato, oppure e per un altro utente Windows, oppure e portable.' 'Yellow'
  Muori 'zero candidate: non c e nessuna cartella dati che non sia gia nota.'
}

# PASSO 2 -- certificazione dal GIORNALE: il conto e la parola FTMO ci sono,
# il login della challenge NO.
Dillo ('[2/7] certificazione dal giornale (<dati>\logs), candidate: ' + $candidate.Count.ToString($INV)) $null
$confermate = @()
foreach($c in $candidate){
  $dirLog = Join-Path $c.Path 'logs'
  $testo = ''
  $nlog = 0
  if(Test-Path -LiteralPath $dirLog){
    # i 10 giornali PIU' RECENTI, ma letti dal piu' vecchio al piu' nuovo:
    # serve l'ordine cronologico per la serratura 5.
    $files = @(Get-ChildItem -LiteralPath $dirLog -Filter *.log -ErrorAction SilentlyContinue |
               Sort-Object LastWriteTime -Descending | Select-Object -First 10 |
               Sort-Object LastWriteTime)
    $nlog = $files.Count
    foreach($f in $files){ $testo = $testo + "`n" + (Leggi-Testo $f.FullName) }
  }
  $haConto = ($testo -match ('(?<![0-9])' + [regex]::Escape($ContoAtteso) + '(?![0-9])'))
  $haFtmo  = (($testo -match '(?i)ftmo') -or ($c.Prog -match '(?i)ftmo'))
  $posTrial = -1
  foreach($m in [regex]::Matches($testo, ('(?<![0-9])' + [regex]::Escape($ContoAtteso) + '(?![0-9])'))){ $posTrial = $m.Index }
  $posVecchio = -1
  foreach($m in [regex]::Matches($testo, ('(?<![0-9])' + [regex]::Escape($LOGIN_CHALLENGE) + '(?![0-9])'))){ $posVecchio = $m.Index }
  # serratura 5: il login vecchio o non c'e' mai, o e' PRIMA dell'ultimo login trial.
  $ordineOk = ($posVecchio -lt 0 -or $posTrial -gt $posVecchio)
  $riga = '      ' + $c.Hash + '  giornali ' + $nlog.ToString($INV)
  if($haConto){ $riga = $riga + '  conto ' + $ContoAtteso + ': TROVATO' } else { $riga = $riga + '  conto ' + $ContoAtteso + ': non trovato' }
  if($haFtmo){ $riga = $riga + '  |  FTMO: nominato' } else { $riga = $riga + '  |  FTMO: non nominato' }
  if($posVecchio -lt 0){ $riga = $riga + '  |  login challenge: assente' }
  elseif($ordineOk){ $riga = $riga + '  |  login challenge ' + $LOGIN_CHALLENGE + ': presente ma PRIMA dell ultimo login trial (ok)' }
  else { $riga = $riga + '  |  login challenge ' + $LOGIN_CHALLENGE + ': PIU RECENTE del login trial (RIFIUTO)' }
  if($haConto -and $haFtmo -and $ordineOk){
    Dillo ($riga + '  -> CONFERMATA') 'Green'
    $confermate += $c
  } else {
    Dillo ($riga + '  -> scartata') 'Yellow'
  }
}
if($confermate.Count -eq 0){
  Dillo '      Se hai appena fatto il login il giornale puo essere ancora vuoto: aspetta che il terminale si colleghi e rilancia.' 'Yellow'
  Dillo '      Se il login della challenge e PIU RECENTE di quello trial, il terminale e ancora (o di nuovo) sul conto sbagliato: fai il login sulla trial e rilancia.' 'Yellow'
  Muori ('nessuna delle ' + $candidate.Count.ToString($INV) + ' candidate porta il conto ' + $ContoAtteso + ' con FTMO e con il login trial PIU RECENTE di quello della challenge.')
}
if($confermate.Count -gt 1){
  foreach($c in $confermate){ Dillo ('      ' + $c.Hash + '  ' + $c.Prog) 'Red' }
  Muori ('CONFERMATE ' + $confermate.Count.ToString($INV) + ' cartelle con lo stesso conto: non so in quale terminale stai per premere F7. Non si indovina.')
}
$dati = $confermate[0].Path
Dillo ('[2/7] BERSAGLIO CERTIFICATO -- conto ' + $ContoAtteso) 'Green'
Dillo ('      programma     : ' + $confermate[0].Prog) 'Green'
Dillo ('      cartella dati : ' + $dati) 'Green'
if($confermate[0].Hash -eq $HASH_FTMO_CENSITO){ Dillo '      NOTA: e la cartella dati di C:\FTMO censita il 30/09 (strada A: trial aperta dentro il terminale della challenge).' 'Cyan' }
else { Dillo '      NOTA: NON e la cartella C:\FTMO censita il 30/09 (hash diverso): strada B, terminale dedicato. Controlla che sia quello che credi.' 'Yellow' }
foreach($v in $NOMI_VIETATI){
  if($dati -like ('*' + $v + '*')){ Muori ('il percorso di destinazione "' + $dati + '" contiene "' + $v + '". Non si scrive.') }
}
foreach($k in $HASH_NOTI.Keys){
  if($dati -like ('*' + $k + '*')){ Muori ('il percorso di destinazione "' + $dati + '" e una cartella nota. Non si scrive.') }
}

# PASSO 3 -- le cartelle di destinazione.
$dirExp = Join-Path $dati 'MQL5\Experts'
$dirInc = Join-Path $dati 'MQL5\Include'
$dirPre = Join-Path $dati 'MQL5\Presets'
Dillo '[3/7] cartelle di destinazione:' $null
foreach($p in @($dirExp, $dirInc, $dirPre)){
  if(Test-Path -LiteralPath $p){ Dillo ('      c era gia : ' + $p) $null }
  elseif($SoloDiagnosi){ Dillo ('      DA CREARE : ' + $p + '   (sola diagnosi: non la creo)') 'Yellow' }
  else { [void](New-Item -ItemType Directory -Path $p -Force); Dillo ('      CREATA    : ' + $p) 'Yellow' }
}

# PASSO 4 -- misura di quello che c e gia, prima di toccare.
Dillo '[4/7] misura di quello che c e gia (nessuna scrittura ancora):' $null
$daFare = @()
$daSalvare = @()
foreach($s in $SORGENTI){
  $dst = Join-Path $dati ('MQL5\' + $s.Cartella + '\' + $s.Nome)
  $stato = 'ASSENTE'
  if(Test-Path -LiteralPath $dst){
    $pre = Scheletro (Leggi-Testo $dst)
    if($pre.Righe -eq $s.Righe -and $pre.Sha -eq $s.Sha){ $stato = 'GIA GIUSTO' } else { $stato = 'PRESENTE DIVERSO' }
  }
  $s | Add-Member -NotePropertyName Dst   -NotePropertyValue $dst   -Force
  $s | Add-Member -NotePropertyName Stato -NotePropertyValue $stato -Force
  $col = 'Yellow'
  if($stato -eq 'GIA GIUSTO'){ $col = 'Green' }
  Dillo ('      ' + $s.Nome.PadRight(30) + $stato) $col
  if($stato -ne 'GIA GIUSTO'){ $daFare += $s }
  if($stato -eq 'PRESENTE DIVERSO'){ $daSalvare += $s }
}
foreach($s in $SORGENTI){
  if($s.Cartella -eq 'Include' -and $s.Stato -eq 'PRESENTE DIVERSO'){
    Muori ('l include ' + $s.Nome + ' e GIA presente ed e DIVERSO da quello atteso (v1.20, pin 26a18566). Sette sedie sono compilate contro di lui: NON lo sovrascrivo. Serve una decisione, non una copia.')
  }
}
if($SoloDiagnosi){
  Dillo '      SOLA DIAGNOSI: mi fermo qui. Niente download, niente scrittura.' 'Yellow'
  $f = Posa-Referto
  if($f){ Write-Host ('referto: ' + $f) -ForegroundColor Green }
  exit 0
}

# PASSO 5 -- copia di sicurezza di cio che sta per essere sovrascritto.
[void](New-Item -ItemType Directory -Path $CARTREF -Force)
if($daSalvare.Count -gt 0){
  $dirBk = Join-Path $CARTREF 'ORIGINALI_SOVRASCRITTI'
  [void](New-Item -ItemType Directory -Path $dirBk -Force)
  foreach($x in $daSalvare){ Copy-Item -LiteralPath $x.Dst -Destination (Join-Path $dirBk $x.Nome) -Force }
  Dillo ('[5/7] COPIA DI SICUREZZA di ' + $daSalvare.Count.ToString($INV) + ' file preesistenti e DIVERSI: ' + $dirBk) 'Yellow'
} else {
  Dillo '[5/7] niente da salvare: nessun file preesistente verra sovrascritto.' 'Green'
}

# PASSO 6 -- scarico dai commit (immutabili) e verifico l impronta PRIMA di scrivere.
$dirTmp = Join-Path $CARTREF 'SCARICATI'
[void](New-Item -ItemType Directory -Path $dirTmp -Force)
$wc = New-Object Net.WebClient
Dillo '[6/7] scarico e verifico PRIMA di scrivere:' $null
$presetOk = @()
try {
  foreach($s in $daFare){
    $url = $REPO_RAW + '/' + $s.Pin + '/' + $s.RepoDir + '/' + $s.Nome
    try { $byte = $wc.DownloadData($url) }
    catch { Muori ('scaricamento FALLITO di ' + $s.Nome + ' da ' + $url + ' -- ' + $_.Exception.Message + '. Un 404 vuol dire pin sbagliato. Nulla scritto.') }
    $sc = Scheletro ([Text.Encoding]::UTF8.GetString($byte))
    if($sc.Righe -ne $s.Righe -or $sc.Sha -ne $s.Sha){
      Muori ('il file scaricato ' + $s.Nome + ' NON e quello atteso (righe ' + $sc.Righe.ToString($INV) + ' contro ' + $s.Righe.ToString($INV) + ', sha ' + $sc.Sha.Substring(0,16) + ' contro ' + $s.Sha.Substring(0,16) + '). Nulla scritto.')
    }
    $tmp = Join-Path $dirTmp $s.Nome
    [IO.File]::WriteAllBytes($tmp, $byte)
    $s | Add-Member -NotePropertyName Tmp -NotePropertyValue $tmp -Force
    Dillo ('      ' + $s.Nome.PadRight(30) + ' pin ' + $s.Pin.Substring(0,8) + '  righe ' + $sc.Righe.ToString($INV) + '  sha ' + $sc.Sha.Substring(0,16) + '  VERIFICATO') 'Green'
  }
  foreach($p in $PRESET){
    $url = $REPO_RAW + '/' + $Pin + '/' + $p.RepoDir + '/' + $p.Nome
    try { $byte = $wc.DownloadData($url) }
    catch { Muori ('preset MANCANTE al pin: ' + $p.Nome + ' da ' + $url + ' -- ' + $_.Exception.Message + '. Nulla scritto.') }
    $sc = Scheletro ([Text.Encoding]::UTF8.GetString($byte))
    if($sc.Righe -ne $p.Righe -or $sc.Sha -ne $p.Sha){
      Muori ('il preset scaricato ' + $p.Nome + ' NON e quello atteso (righe ' + $sc.Righe.ToString($INV) + ' contro ' + $p.Righe.ToString($INV) + ', sha ' + $sc.Sha.Substring(0,16) + ' contro ' + $p.Sha.Substring(0,16) + '). Il pin e sbagliato o il file e stato riscritto dopo che la riga e stata costruita. Nulla scritto.')
    }
    $pz = $p.Firma -split '=', 2
    $patt = '(?m)^\s*' + [regex]::Escape($pz[0]) + '\s*=\s*' + [regex]::Escape($pz[1]) + '\s*$'
    if($sc.Testo -notmatch $patt){ Muori ('il preset ' + $p.Nome + ' NON contiene "' + $p.Firma + '". Nulla scritto.') }
    $tmp = Join-Path $dirTmp $p.Nome
    [IO.File]::WriteAllBytes($tmp, $byte)
    $dstP = Join-Path $dirPre $p.Nome
    $statoP = 'ASSENTE'
    if(Test-Path -LiteralPath $dstP){
      $pv = Scheletro (Leggi-Testo $dstP)
      if($pv.Sha -eq $sc.Sha){ $statoP = 'GIA IDENTICO' } else { $statoP = 'PRESENTE DIVERSO' }
    }
    $p | Add-Member -NotePropertyName Tmp    -NotePropertyValue $tmp   -Force
    $p | Add-Member -NotePropertyName Dst    -NotePropertyValue $dstP  -Force
    $p | Add-Member -NotePropertyName StatoP -NotePropertyValue $statoP -Force
    $p | Add-Member -NotePropertyName Testo  -NotePropertyValue $sc.Testo -Force
    $presetOk += $p
    Dillo ('      ' + $p.Nome.PadRight(46) + ' righe ' + $sc.Righe.ToString($INV) + '  sha ' + $sc.Sha.Substring(0,16) + '  VERIFICATO  (' + $statoP + ')') 'Green'
  }
} finally { $wc.Dispose() }

# PASSO 7 -- la scrittura. Unica destinazione: $dati, gia certificata.
Dillo '[7/7] copia...' $null
foreach($s in $daFare){
  try { Copy-Item -LiteralPath $s.Tmp -Destination $s.Dst -Force }
  catch { Dillo ('      COPIA FALLITA su ' + $s.Nome + ': ' + $_.Exception.Message) 'Red' }
}
foreach($p in $presetOk){
  if($p.StatoP -eq 'GIA IDENTICO'){ continue }
  if($p.StatoP -eq 'PRESENTE DIVERSO'){
    $accanto = Join-Path $dirPre ([IO.Path]::GetFileNameWithoutExtension($p.Nome) + '_DAL_REPO.set')
    try { Copy-Item -LiteralPath $p.Tmp -Destination $accanto -Force } catch { }
    Dillo ('      NON SOVRASCRITTO: ' + $p.Nome + ' era gia li ed e DIVERSO: quello a mano vince, il repo e accanto come ' + [IO.Path]::GetFileName($accanto)) 'Yellow'
    continue
  }
  try { Copy-Item -LiteralPath $p.Tmp -Destination $p.Dst -Force }
  catch { Dillo ('      COPIA FALLITA su ' + $p.Nome + ': ' + $_.Exception.Message) 'Red' }
}

# RILETTURA DAL DISCO: e questo che lo dimostra, non la copia.
Dillo '' $null
Dillo '=====================================================================' $null
Dillo ' RISULTATO -- riletto dal disco del terminale trial, non dedotto' $null
Dillo '=====================================================================' $null
$tuttoBene = $true
foreach($s in $SORGENTI){
  $ok = $false
  $righe = 0
  if(Test-Path -LiteralPath $s.Dst){
    $sc = Scheletro (Leggi-Testo $s.Dst)
    $righe = $sc.Righe
    $ok = ($sc.Righe -eq $s.Righe -and $sc.Sha -eq $s.Sha)
  }
  if(-not $ok){ $tuttoBene = $false }
  $e = 'C E, ED E QUELLO GIUSTO'
  $col = 'Green'
  if(-not $ok){ $e = 'NON C E o E SBAGLIATO -- controllare a mano'; $col = 'Red' }
  Dillo ('  ' + $s.Nome.PadRight(30) + 'righe ' + $righe.ToString($INV).PadRight(6) + $e) $col
}
foreach($p in $presetOk){
  $c = 'MANCA -- controllare a mano'
  $col = 'Red'
  if(Test-Path -LiteralPath $p.Dst){
    if($p.StatoP -eq 'PRESENTE DIVERSO'){ $c = 'c era gia e DIVERSO: LASCIATO COM ERA (repo accanto, _DAL_REPO.set)'; $col = 'Yellow' }
    elseif($p.StatoP -eq 'GIA IDENTICO'){ $c = 'era gia identico: non toccato'; $col = 'Green' }
    else { $c = 'copiato adesso'; $col = 'Green' }
  } else { $tuttoBene = $false }
  Dillo ('  preset ' + $p.Nome.PadRight(46) + $c) $col
}

# Orari e taglie dentro i preset: si STAMPANO, non si cambiano.
Dillo '' $null
Dillo ' ORARI, MAGIC E TAGLIE nei preset (solo lettura, nessuna modifica):' $null
foreach($p in $presetOk){
  Dillo ('  ' + $p.Nome) $null
  foreach($r in ($p.Testo -split "`n")){
    if($r -match '^\s*(InpRangeStartHour|InpRangeStartMin|InpRangeEndHour|InpRangeEndMin|InpEndHour|InpEndMin|InpPendingExpiryMin|InpMagic|InpComment|InpRiskPercent|InpUsaGuardian|Risk_Percent|Max_Trades|Total_Risk_Percent|Symbols_List|Use_Blue|Use_Purple|Use_Orange)\s*=') {
      Dillo ('      ' + $r.Trim()) $null
    }
  }
}

Dillo '' $null
$nDiversi = @($presetOk | Where-Object { $_.StatoP -eq 'PRESENTE DIVERSO' }).Count
if($tuttoBene -and $nDiversi -gt 0){ Dillo ' ESITO: sorgenti OK, ma un preset gia presente era DIVERSO e non e stato toccato: guarda la riga gialla e il file _DAL_REPO.set prima di caricarlo.' 'Yellow' }
elseif($tuttoBene){ Dillo ' ESITO: TUTTO COPIATO E VERIFICATO. Ora F7 a mano (MetaEditor): Bulge e ORB devono dare 0 errori.' 'Green' }
else { Dillo ' ESITO: QUALCOSA NON TORNA (righe rosse sopra). NON premere F7 finche non e chiaro.' 'Red' }
Dillo ' Questa riga NON ha compilato, NON ha attaccato EA, NON ha acceso Algo Trading.' $null
Dillo ' Prerequisito NON coperto qui: il Guardian 779001 con InpStartBalance=160000.' 'Yellow'

$f = Posa-Referto
if($f){ Write-Host ('referto: ' + $f) -ForegroundColor Green }
try {
  $zip = $CARTREF + '.zip'
  Compress-Archive -Path (Join-Path $CARTREF '*') -DestinationPath $zip -Force
  Write-Host ('zip pronto da mandare: ' + $zip) -ForegroundColor Green
} catch { Write-Host ('zip NON creato: ' + $_.Exception.Message) -ForegroundColor Yellow }
if($tuttoBene){ exit 0 } else { exit 1 }
