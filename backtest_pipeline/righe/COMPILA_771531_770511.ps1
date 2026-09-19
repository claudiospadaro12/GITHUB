# =====================================================================
#  MARCATORE_COMPILA_771531_770511_v1
#
#  PACCHETTO DI COMPILAZIONE DELLE DUE SEDIE 771531 e 770511.
#  PORTA I SORGENTI GIUSTI NELLA CARTELLA DATI DEL TERMINALE 50503392.
#  NON COMPILA: l'F7 e' a mano, ed e' di Claudio.
#
#  Firma di Claudio (19/09/2026): "SI FIRMO ENTRAMBE, COMPILA PURE".
#  Referto: report/COMPILAZIONE_771531_770511_2026-09-19.md
#  Censimento di partenza: report/I_BINARI_DELLA_ROSA_2026-09-19.md
#  Modello: backtest_pipeline/righe/TOPPA_TICKET_50503392.ps1 (19/09)
#
#  I DUE BERSAGLI, e perche' NON sono HEAD:
#    - ABTG_EMA200.mq5                        -> pin 26a18566 (19/08)
#    - ABTG_SuperWave_DOW_H1_Ottimizzato.mq5  -> pin 872dba82 (08/09)
#  HEAD di tutti e due e' b45dd009, il commit che dice ESPLICITAMENTE
#  "IN CORSO D'OPERA -- NON COMPILARE", mai superato da un PASS.
#
#  ATTENZIONE, IL NOME DEL FILE DI SUPERWAVE: la sedia 770511 NON gira
#  ABTG_SuperWave.mq5 (quella e' la 770531, altra sedia). Gira la
#  variante _Ottimizzato. E' la classe 462 della checklist, e la si
#  ripaga ogni volta che si guarda il nome della famiglia invece del
#  file attaccato al grafico (CODA_01, chart37).
#
#  COSA FA, PER INTERO E SENZA SORPRESE:
#    1. trova la cartella DATI del terminale 50503392 (hash COSTANTE,
#       non cercato) e la CERTIFICA leggendo origin.txt;
#    2. localizza i due .mq5 dentro MQL5\Experts (uno ciascuno);
#    3. MISURA le impronte PRIMA di qualunque scrittura. Se sono gia'
#       tutte e due quelle nuove, si ferma subito: NESSUN backup a
#       vuoto, nessun download, uscita 0;
#    4. COPIA DI SICUREZZA sul Desktop (cartella datata + zip);
#    5. pretende che ogni file da aggiornare abbia ESATTAMENTE
#       l'impronta del vintage in campo (344a11b9). Una sola che non
#       combacia e NON SI SOSTITUISCE NIENTE;
#    6. CENSISCE l'include ABTG_PausaGuardian.mqh (che nessun
#       censimento di casa ha mai guardato: CODA_06 legge solo
#       MQL5\Experts). Se MANCA lo installa alla v1.20, che e' quella
#       gia' compilata e viva sul 100k. Se C'E' NON LO TOCCA: e' un
#       file condiviso da una ventina di EA su quel terminale, e
#       riscriverlo cambierebbe il prossimo F7 di chiunque;
#    7. scarica i .mq5 dai pin (URL per COMMIT: immutabile, la cache
#       ~5 min di raw.githubusercontent non c'entra) e ne verifica
#       l'impronta PRIMA di scrivere;
#    8. copia, rilegge dal disco e stampa la tabella con i DUE
#       RIGHELLI: wc -l e il conteggio di CODA_06 (= wc -l + 1,
#       classe 456).
#
#  COSA NON FA, ED E' UNA PROMESSA VERIFICABILE:
#    - NON compila (F7 a mano, di Claudio);
#    - NON apre, NON chiude, NON tocca nessun processo. In questo file
#      non esiste nessuna chiamata capace di terminare un processo:
#      niente Stop-Process, niente Get-Process, niente Start-Process;
#    - NON tocca nessun preset, nessun .set, nessun .chr, nessun input;
#    - NON scrive in NESSUNA cartella dati che non sia quella del
#      50503392. Il percorso di destinazione e' una COSTANTE, non il
#      risultato di una ricerca.
#
#  BERSAGLIO UNICO: terminale 50503392,
#  C:\Program Files\BCM Markets MT5 Terminal,
#  cartella dati 215D85D767A1C39E22D242C8114BF9F5.
#  Sul VPS ci sono SETTE cartelle dati: le altre SEI non vengono
#  nemmeno guardate.
#
#  ASCII PURO: niente emoji, niente accentate (PS 5.1 legge i .ps1
#  come ANSI -- regola di casa del 17/08).
# =====================================================================

param(
  [Parameter(Mandatory=$true)][string]$Pin
)

$ErrorActionPreference = 'Stop'
$INV = [Globalization.CultureInfo]::InvariantCulture
try { [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12 } catch { }

# ---------------------------------------------------------------------
# COSTANTI DEL BERSAGLIO. Sono COSTANTI e non parametri di proposito:
# un bersaglio che si puo' passare da fuori e' un bersaglio che si puo'
# sbagliare da fuori.
# ---------------------------------------------------------------------
$HASH_DATI    = '215D85D767A1C39E22D242C8114BF9F5'
$CONTO        = '50503392'
$PROG_ATTESO  = 'C:\Program Files\BCM Markets MT5 Terminal'
$PROG_VIETATI = @('-V3', 'BCM_Reale', 'MT5_Backtest', 'MT5_MANUALE', 'Pepperstone', 'Tickmill')

$REPO_RAW = 'https://raw.githubusercontent.com/claudiospadaro12/GITHUB'

# I PIN dei sorgenti sono COMMIT GIT: immutabili per costruzione.
$PIN_EMA200 = '26a185661c120de6fa0a33b79279595740e264e8'
$PIN_SUPERW = '872dba82d7b3b345c8ae15cb1033b66df6066ae5'
$PIN_CAMPO  = '344a11b95d0dca488f84e8dc1d8c018742810e4a'   # solo per il referto

# nome | sottocartella del repo | pin | righe/sha PRIMA (vintage in campo) | righe/sha DOPO
$TAVOLA = @(
  [pscustomobject]@{
    Nome      = 'ABTG_EMA200.mq5'
    Sedia     = '771531 EMA200 Dow U30USD H1'
    RepoDir   = 'mql5/Experts'
    Pin       = $PIN_EMA200
    RighePre  = 486
    ShaPre    = 'C60EC2B47DEF781E4FC679545D0A072E17472B5F93E906D8C3A5E762EDCDAE7A'
    RighePost = 552
    ShaPost   = '5CA99D90A5F34E9630083C91E16A5E7F2DA48FC77EF63B138C5C2C3485BE85F4'
  },
  [pscustomobject]@{
    Nome      = 'ABTG_SuperWave_DOW_H1_Ottimizzato.mq5'
    Sedia     = '770511 SuperWave DOW H1 Ott'
    RepoDir   = 'mql5/Experts'
    Pin       = $PIN_SUPERW
    RighePre  = 563
    ShaPre    = 'D1BEBB233564EB6C55B4B97B2A1C366E6DBD11BCE1EFC742B24BBAB6D0D4DEED'
    RighePost = 645
    ShaPost   = '3C487F289023CEDC87375A6E589C7C8C43423A38151F19A8436A218F3EE7C18B'
  }
)

# L'INCLUDE: non e' nella tavola perche' NON si sostituisce mai.
# Si censisce, e si installa SOLO se manca del tutto.
$INC_NOME     = 'ABTG_PausaGuardian.mqh'
$INC_PIN      = $PIN_EMA200                # v1.20, blob cc90fb73
$INC_REPODIR  = 'mql5/Include'
$INC_RIGHE    = 398
$INC_SHA      = 'D179846B407FDACC963825103F850E8F8BEE39B1DA3521A504EF74F8638AC8BC'
# L'altra impronta conosciuta: l'include a HEAD (v1.51 + tetto cluster C2
# spento). Se sul terminale c'e' quella, va bene lo stesso: i due EA usano
# UNA SOLA funzione dell'include, ABTG_GuardiaIngresso(bool,string), e la
# firma e' identica nelle due versioni.
$INC_SHA_HEAD = 'E9F503F581265A00E4389E8482A18FB9244AA53529A9969CA358137E39EF344C'
$INC_RIGHE_HEAD = 2461

# ---------------------------------------------------------------------
# LETTURA CONDIVISA (stesso schema di CODA_06): il file puo' essere
# aperto da MetaEditor, quindi si apre in FileShare ReadWrite.
# Riconosce UTF-16 (BOM o euristica degli zeri) e ripiega su UTF-8.
# ---------------------------------------------------------------------
function Leggi-Testo($path) {
  $b = $null
  $fs = [IO.File]::Open($path, [IO.FileMode]::Open, [IO.FileAccess]::Read, [IO.FileShare]::ReadWrite)
  try {
    $b = New-Object byte[] $fs.Length
    # FileStream.Read non garantisce di riempire il buffer in una volta.
    # Un byte mancante qui diventerebbe una "impronta diversa" inventata,
    # cioe' un giro a vuoto. Quindi si cicla finche' il buffer e' pieno.
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

# ---------------------------------------------------------------------
# LO SCHELETRO ASCII, e perche' si misura COSI'.
# Il conteggio delle righe da solo non basta (due vintage possono avere
# le stesse righe), ma l'impronta dei BYTE nudi e' troppo fragile: fra
# MetaEditor e il repo cambiano fine riga (CRLF/LF), presenza del BOM e
# codifica delle accentate nei COMMENTI. Nessuna delle tre cambia una
# virgola di codice. Quindi si normalizza e si fa lo sha256 di quello
# che resta. Il CODICE di un .mq5 e' ASCII per costruzione.
# Righe = a-capo + 1, cioe' le righe di CONTENUTO = wc -l = il numero
# che MetaEditor mostra in fondo alla finestra.
# CODA_06 stampa SEMPRE UNO IN PIU' (classe 456): qui si stampano
# tutti e due i righelli, cosi' nessuno confronta mele con pere.
# ---------------------------------------------------------------------
function Scheletro($testo) {
  $t = $testo -replace "`r`n", "`n"
  $t = $t -replace "`r", "`n"
  $t = $t -replace '[^\u0009\u000A\u0020-\u007E]', ''
  $t = $t.TrimEnd("`n")
  $righe = ($t -split "`n").Count
  $sha = [Security.Cryptography.SHA256]::Create()
  try {
    $hb = $sha.ComputeHash([Text.Encoding]::ASCII.GetBytes($t))
  } finally { $sha.Dispose() }
  $sb = New-Object Text.StringBuilder
  foreach($x in $hb){ [void]$sb.Append($x.ToString('X2', $INV)) }
  return [pscustomobject]@{ Righe = $righe; Sha = $sb.ToString() }
}

function DueRighelli($n) {
  return ($n.ToString($INV) + ' (CODA_06: ' + ($n + 1).ToString($INV) + ')')
}

function Muori($msg) {
  Write-Host ''
  Write-Host '=====================================================================' -ForegroundColor Red
  Write-Host ('FERMO: ' + $msg) -ForegroundColor Red
  Write-Host 'NESSUN FILE E STATO SOSTITUITO.' -ForegroundColor Red
  Write-Host '=====================================================================' -ForegroundColor Red
  exit 1
}

Write-Host '====================================================================='
Write-Host ' PACCHETTO COMPILAZIONE 771531 + 770511 -- SOLO COPIA, NESSUN F7'
Write-Host (' bersaglio: terminale ' + $CONTO + ' (' + $PROG_ATTESO + ')')
Write-Host ('            cartella dati ' + $HASH_DATI)
Write-Host (' pin script: ' + $Pin)
Write-Host (' pin EMA200: ' + $PIN_EMA200.Substring(0,8) + '   pin SuperWave: ' + $PIN_SUPERW.Substring(0,8))
Write-Host (' ora       : ' + (Get-Date).ToString('yyyy-MM-dd HH:mm:ss', $INV) + '  (ora locale del VPS)')
Write-Host '====================================================================='
Write-Host ''

# =====================================================================
# PASSO 1 -- LA CARTELLA DATI, E LA SUA CERTIFICAZIONE
# =====================================================================
$radice = Join-Path $env:APPDATA 'MetaQuotes\Terminal'
$dati   = Join-Path $radice $HASH_DATI
if(-not (Test-Path -LiteralPath $dati)){
  Muori ('la cartella dati ' + $HASH_DATI + ' non esiste sotto ' + $radice + '. Il terminale ' + $CONTO + ' non e su questa macchina, oppure ha cambiato hash: rifare il censimento (CODA_06) prima di toccare qualunque cosa.')
}

$origine = Join-Path $dati 'origin.txt'
if(-not (Test-Path -LiteralPath $origine)){
  Muori ('manca origin.txt in ' + $dati + ': non posso CERTIFICARE di quale terminale e questa cartella, e senza certificato non si scrive niente.')
}
$prog = (Leggi-Testo $origine) -replace '[^\u0020-\u007E]', ''
$prog = $prog.Trim()

# LA GUARDIA. Prima il rifiuto esplicito dei sei percorsi VIETATI, poi
# l'uguaglianza ESATTA con l'unico ammesso: chi non e' il bersaglio muore.
foreach($v in $PROG_VIETATI){
  if($prog -like ('*' + $v + '*')){
    Muori ('VIETATO: la cartella ' + $HASH_DATI + ' appartiene a "' + $prog + '", che contiene "' + $v + '". Non e il terminale ' + $CONTO + '. Non si tocca.')
  }
}
if($prog -ne $PROG_ATTESO){
  Muori ('VIETATO: origin.txt dice "' + $prog + '", atteso "' + $PROG_ATTESO + '". Bersaglio non certificato: non si scrive niente.')
}
Write-Host ('[1/8] cartella dati CERTIFICATA: ' + $prog) -ForegroundColor Green
Write-Host ('      ' + $dati)

$esperti = Join-Path $dati 'MQL5\Experts'
if(-not (Test-Path -LiteralPath $esperti)){ Muori ('manca ' + $esperti) }

# =====================================================================
# PASSO 2 -- I DUE FILE, UNO CIASCUNO
# =====================================================================
$tutti = @(Get-ChildItem -LiteralPath $esperti -Filter *.mq5 -Recurse -File -ErrorAction SilentlyContinue)
$trovati = @()
foreach($r in $TAVOLA){
  $c = @($tutti | Where-Object { $_.Name -eq $r.Nome })
  if($c.Count -eq 0){ Muori ('non trovo ' + $r.Nome + ' sotto ' + $esperti + ' (sedia ' + $r.Sedia + '). Senza il file al vintage in campo non c e una base su cui applicare la sostituzione: censire a mano.') }
  if($c.Count -gt 1){ Muori ($r.Nome + ' esiste in ' + $c.Count.ToString($INV) + ' copie sotto ' + $esperti + ': non so quale viene compilata. Censire a mano prima di sostituire.') }
  $trovati += [pscustomobject]@{ Riga = $r; Path = $c[0].FullName }
}
Write-Host '[2/8] i due sorgenti trovati, una copia ciascuno:' -ForegroundColor Green
foreach($t in $trovati){ Write-Host ('      ' + $t.Riga.Sedia + '  ->  ' + $t.Path) }

# =====================================================================
# PASSO 3 -- MISURA PRIMA DI TOCCARE. E' qui che si decide se c e'
#            qualcosa da fare: un secondo lancio non deve rifare il
#            backup a vuoto ne scaricare niente.
# =====================================================================
Write-Host '[3/8] misura delle impronte attuali (nessuna scrittura ancora):'
$daFare = @()
$guasti = @()
foreach($t in $trovati){
  $s = Scheletro (Leggi-Testo $t.Path)
  $t | Add-Member -NotePropertyName Pre -NotePropertyValue $s -Force
  $stato = 'SCONOSCIUTO'
  if($s.Righe -eq $t.Riga.RighePost -and $s.Sha -eq $t.Riga.ShaPost){ $stato = 'GIA AGGIORNATO' }
  elseif($s.Righe -eq $t.Riga.RighePre -and $s.Sha -eq $t.Riga.ShaPre){ $stato = 'DA AGGIORNARE' }
  $t | Add-Member -NotePropertyName Stato -NotePropertyValue $stato -Force
  Write-Host ('      ' + $t.Riga.Nome.PadRight(38) + ' righe ' + (DueRighelli $s.Righe).PadRight(20) + ' sha ' + $s.Sha.Substring(0,16) + '  -> ' + $stato)
  if($stato -eq 'DA AGGIORNARE'){ $daFare += $t }
  if($stato -eq 'SCONOSCIUTO'){
    $guasti += ($t.Riga.Nome + ': impronta non riconosciuta (righe ' + $s.Righe.ToString($INV) + ', attese ' + $t.Riga.RighePre.ToString($INV) + ' per il vintage in campo o ' + $t.Riga.RighePost.ToString($INV) + ' per quello nuovo; sha ' + $s.Sha.Substring(0,16) + ')')
  }
}

function FaiBackup($elenco, $etichetta) {
  $stampL = (Get-Date).ToString('yyyy-MM-dd_HHmmss', $INV)
  $deskL  = Join-Path $env:USERPROFILE 'Desktop'
  if(-not (Test-Path -LiteralPath $deskL)){ $deskL = $env:USERPROFILE }
  $cartL = Join-Path $deskL ('COMPILA_771531_770511_' + $stampL)
  $dirL  = Join-Path $cartL 'ORIGINALI'
  [void](New-Item -ItemType Directory -Path $dirL -Force)
  foreach($x in $elenco){
    Copy-Item -LiteralPath $x.Path -Destination (Join-Path $dirL $x.Riga.Nome) -Force
  }
  $zipL = Join-Path $deskL ('COMPILA_771531_770511_' + $stampL + '_ORIGINALI.zip')
  Compress-Archive -Path (Join-Path $dirL '*') -DestinationPath $zipL -Force
  Write-Host ($etichetta + ' (' + @($elenco).Count.ToString($INV) + ' file):') -ForegroundColor Green
  Write-Host ('      cartella: ' + $dirL)
  Write-Host ('      zip     : ' + $zipL)
  return [pscustomobject]@{ Cart = $cartL; Zip = $zipL }
}

if($guasti.Count -gt 0){
  Write-Host ''
  foreach($g in $guasti){ Write-Host ('      GUASTO: ' + $g) -ForegroundColor Red }
  Write-Host ''
  # IL BACKUP SI FA LO STESSO, ED E' IL MOTIVO PER CUI STA QUI E NON DOPO:
  # se l impronta non torna, i file VERI del terminale servono a me per
  # rifare il pacchetto su QUESTA base. Averli gia sul Desktop risparmia
  # un secondo giro sul VPS -- che e' esattamente il costo che vogliamo
  # far morire. Nessuno di questi file viene MODIFICATO: solo copiato.
  $bk = FaiBackup $trovati '      COPIA DI SICUREZZA fatta lo stesso'
  Write-Host ''
  Write-Host '      Questo terminale ha un vintage DIVERSO da quello censito il 19/09.' -ForegroundColor Yellow
  Write-Host '      Non si sostituisce niente.' -ForegroundColor Yellow
  Write-Host ('      MANDAMI LO ZIP: ' + $bk.Zip) -ForegroundColor Yellow
  Write-Host '      Il pacchetto si rifa su QUESTA base (classe 449), senza altri giri.' -ForegroundColor Yellow
  Muori 'almeno un file non ha nessuna delle due impronte attese.'
}

if($daFare.Count -eq 0){
  Write-Host ''
  Write-Host '      TUTTI E DUE I SORGENTI SONO GIA QUELLI NUOVI.' -ForegroundColor Green
  Write-Host '      Nessun backup, nessun download, nessuna scrittura: non c era niente da fare.' -ForegroundColor Green
  Write-Host '      (Se non hai ancora premuto F7, il passo che manca e solo quello.)' -ForegroundColor Yellow
  Write-Host ''
  exit 0
}

# =====================================================================
# PASSO 4 -- COPIA DI SICUREZZA. Si fa SEMPRE prima di scrivere, e solo
#            se c e' davvero qualcosa da scrivere.
# =====================================================================
$bk     = FaiBackup $daFare '[4/8] COPIA DI SICUREZZA fatta, prima di toccare qualunque cosa'
$cartBk = $bk.Cart
$zipBk  = $bk.Zip

# =====================================================================
# PASSO 5 -- L'INCLUDE. Si CENSISCE, non si riscrive.
#            Nessun censimento di casa ha mai guardato MQL5\Include:
#            CODA_06 legge solo MQL5\Experts. Senza questo file l F7
#            dei due EA fallisce con "cannot open include file", ed e'
#            esattamente la classe 27 della checklist.
# =====================================================================
$dirInc = Join-Path $dati 'MQL5\Include'
$pathInc = Join-Path $dirInc $INC_NOME
$incEsito = ''
if(Test-Path -LiteralPath $pathInc){
  $si = Scheletro (Leggi-Testo $pathInc)
  if($si.Righe -eq $INC_RIGHE -and $si.Sha -eq $INC_SHA){
    $incEsito = 'PRESENTE alla v1.20 (righe ' + (DueRighelli $si.Righe) + '), la stessa gia compilata e viva sul 100k. NON TOCCATO.'
    Write-Host ('[5/8] include: ' + $incEsito) -ForegroundColor Green
  } elseif($si.Righe -eq $INC_RIGHE_HEAD -and $si.Sha -eq $INC_SHA_HEAD){
    $incEsito = 'PRESENTE alla versione di HEAD (righe ' + (DueRighelli $si.Righe) + '). Va bene lo stesso: i due EA usano solo ABTG_GuardiaIngresso(bool,string), firma identica. NON TOCCATO.'
    Write-Host ('[5/8] include: ' + $incEsito) -ForegroundColor Green
  } else {
    $incEsito = 'PRESENTE ma di versione SCONOSCIUTA: righe ' + (DueRighelli $si.Righe) + ', sha ' + $si.Sha.Substring(0,16) + '. NON TOCCATO.'
    Write-Host ('[5/8] include: ' + $incEsito) -ForegroundColor Yellow
    Write-Host '      ATTENZIONE: questo include e condiviso da una ventina di EA su questo' -ForegroundColor Yellow
    Write-Host '      terminale. NON lo sovrascrivo di mia iniziativa. Se l F7 dei due EA' -ForegroundColor Yellow
    Write-Host '      dara un errore sull include, mandami questa riga e lo sistemiamo.' -ForegroundColor Yellow
  }
} else {
  Write-Host '[5/8] include: ASSENTE. Lo installo alla v1.20 (senza di lui l F7 non parte).' -ForegroundColor Yellow
  [void](New-Item -ItemType Directory -Path $dirInc -Force)
  $urlInc = $REPO_RAW + '/' + $INC_PIN + '/' + $INC_REPODIR + '/' + $INC_NOME
  $wcI = New-Object Net.WebClient
  $byteI = $null
  try {
    $byteI = $wcI.DownloadData($urlInc)
  } catch {
    $wcI.Dispose()
    Muori ('scaricamento dell include FALLITO da ' + $urlInc + ' -- ' + $_.Exception.Message + '. Un 404 qui vuol dire pin sbagliato o file non presente a quel commit. Niente e stato sostituito.')
  }
  $wcI.Dispose()
  $sI = Scheletro ([Text.Encoding]::UTF8.GetString($byteI))
  if($sI.Righe -ne $INC_RIGHE -or $sI.Sha -ne $INC_SHA){
    Muori ('l include scaricato NON e quello atteso (righe ' + $sI.Righe.ToString($INV) + ' contro ' + $INC_RIGHE.ToString($INV) + ', sha ' + $sI.Sha.Substring(0,16) + ' contro ' + $INC_SHA.Substring(0,16) + '). Niente e stato sostituito: gli originali dei due .mq5 sono nello zip ' + $zipBk)
  }
  [IO.File]::WriteAllBytes($pathInc, $byteI)
  $incEsito = 'ERA ASSENTE, INSTALLATO alla v1.20 (righe ' + (DueRighelli $INC_RIGHE) + ').'
  Write-Host ('      ' + $incEsito) -ForegroundColor Green
  Write-Host ('      ' + $pathInc)
}

# =====================================================================
# PASSO 6 -- SCARICO E VERIFICO PRIMA DI SCRIVERE
#            URL per COMMIT: un commit git e' immutabile, quindi la
#            cache ~5 min di raw.githubusercontent non puo' servire un
#            contenuto diverso. E comunque l impronta lo ricontrolla.
# =====================================================================
Write-Host '[6/8] scarico i sorgenti dai pin e ne verifico l impronta...'
$dirTmp = Join-Path $cartBk 'NUOVI'
[void](New-Item -ItemType Directory -Path $dirTmp -Force)
$wc = New-Object Net.WebClient
try {
  foreach($t in $daFare){
    $url = $REPO_RAW + '/' + $t.Riga.Pin + '/' + $t.Riga.RepoDir + '/' + $t.Riga.Nome
    $dst = Join-Path $dirTmp $t.Riga.Nome
    $byte = $null
    try {
      $byte = $wc.DownloadData($url)
    } catch {
      $wc.Dispose()
      Muori ('scaricamento FALLITO di ' + $t.Riga.Nome + ' da ' + $url + ' -- ' + $_.Exception.Message + '. Un 404 qui vuol dire PIN SBAGLIATO o file non presente a quel commit. Niente e stato sostituito: gli originali sono nello zip ' + $zipBk)
    }
    [IO.File]::WriteAllBytes($dst, $byte)
    $s = Scheletro ([Text.Encoding]::UTF8.GetString($byte))
    if($s.Righe -ne $t.Riga.RighePost -or $s.Sha -ne $t.Riga.ShaPost){
      Muori ('il file scaricato ' + $t.Riga.Nome + ' NON e quello atteso (righe ' + $s.Righe.ToString($INV) + ' contro ' + $t.Riga.RighePost.ToString($INV) + ', sha ' + $s.Sha.Substring(0,16) + ' contro ' + $t.Riga.ShaPost.Substring(0,16) + '). Pin sbagliato o file mancante al pin: niente e stato sostituito.')
    }
    $t | Add-Member -NotePropertyName Scaricato -NotePropertyValue $dst -Force
    Write-Host ('      ' + $t.Riga.Nome.PadRight(38) + ' pin ' + $t.Riga.Pin.Substring(0,8) + ' -> righe ' + (DueRighelli $s.Righe) + ' VERIFICATO') -ForegroundColor Green
  }
} finally { $wc.Dispose() }

# =====================================================================
# PASSO 7 -- LA SOSTITUZIONE
# =====================================================================
Write-Host '[7/8] sostituzione...'
# Se una copia fallisce (per esempio il file e aperto in scrittura da
# MetaEditor) NON si muore qui: si segna e si va lo stesso alla tabella
# finale, che e' riletta dal disco e dice file per file com e finita.
# Morire a meta' lascerebbe uno stato misto senza referto.
foreach($t in $daFare){
  try {
    Copy-Item -LiteralPath $t.Scaricato -Destination $t.Path -Force
  } catch {
    Write-Host ('      COPIA FALLITA su ' + $t.Riga.Nome + ': ' + $_.Exception.Message) -ForegroundColor Red
  }
}

# =====================================================================
# PASSO 8 -- LA RILETTURA CHE LO DIMOSTRA
# =====================================================================
Write-Host ''
Write-Host '====================================================================='
Write-Host ' RISULTATO -- riletto dal disco del terminale, non dedotto'
Write-Host ' righe = wc -l (quello di MetaEditor). Fra parentesi il numero che'
Write-Host ' stampera CODA_06, che conta sempre UNO IN PIU (classe 456).'
Write-Host '====================================================================='
$tuttoBene = $true
foreach($t in $trovati){
  $s = Scheletro (Leggi-Testo $t.Path)
  $ok = ($s.Righe -eq $t.Riga.RighePost -and $s.Sha -eq $t.Riga.ShaPost)
  if(-not $ok){ $tuttoBene = $false }
  $e = 'ENTRATA'
  $col = 'Green'
  if(-not $ok){ $e = 'NON ENTRATA -- controllare a mano'; $col = 'Red' }
  Write-Host ('  ' + $t.Riga.Nome) -ForegroundColor $col
  Write-Host ('      sedia ' + $t.Riga.Sedia)
  Write-Host ('      prima ' + (DueRighelli $t.Pre.Righe) + '   dopo ' + (DueRighelli $s.Righe) + '   -> ' + $e) -ForegroundColor $col
}
Write-Host ''
Write-Host ('  include ABTG_PausaGuardian.mqh: ' + $incEsito)
Write-Host ('  copia di sicurezza            : ' + $zipBk)
Write-Host ''
if($tuttoBene){
  Write-Host '  ADESSO TOCCA A TE, E SOLO A MANO:' -ForegroundColor Yellow
  Write-Host ('   1. apri MetaEditor del terminale ' + $CONTO + ' (' + $PROG_ATTESO + ')') -ForegroundColor Yellow
  Write-Host '   2. se hai uno dei due file gia aperto in una scheda, CHIUDI la scheda' -ForegroundColor Yellow
  Write-Host '      senza salvare e riaprilo: altrimenti salvi sopra il sorgente appena messo' -ForegroundColor Yellow
  Write-Host '   3. F7 su ABTG_EMA200.mq5 e su ABTG_SuperWave_DOW_H1_Ottimizzato.mq5' -ForegroundColor Yellow
  Write-Host '   4. in MT5, rimuovi e riattacca i due EA perche prendano il nuovo .ex5' -ForegroundColor Yellow
  Write-Host '   5. ricarica i preset: i sorgenti nuovi hanno input che i .set non hanno' -ForegroundColor Yellow
  Write-Host '      (InpUsaGuardian, e per SuperWave InpPendingAtr / InpSLBufferAtr):' -ForegroundColor Yellow
  Write-Host '      restano ai valori di default, e vanno GUARDATI prima di dare OK.' -ForegroundColor Yellow
  Write-Host ''
  Write-Host '  COME SI VEDE CHE L F7 E ANDATO:' -ForegroundColor Yellow
  Write-Host '   - SuperWave_DOW_H1_Ottimizzato passa da versione 1.00 a 1.01;' -ForegroundColor Yellow
  Write-Host '   - EMA200 NON cambia versione (resta 1.00): la si riconosce solo dalle righe.' -ForegroundColor Yellow
  Write-Host '   - il prossimo CODA_06 (runner 03:30) deve stampare 553 e 646' -ForegroundColor Yellow
  Write-Host '     al posto di 487 e 564.' -ForegroundColor Yellow
  Write-Host ''
  Write-Host '  QUESTA RIGA NON HA COMPILATO NIENTE E NON HA TOCCATO NESSUN PROCESSO.' -ForegroundColor Yellow
  exit 0
} else {
  Write-Host '  ALMENO UN FILE NON E ENTRATO. Gli originali sono nello zip qui sopra.' -ForegroundColor Red
  exit 2
}
