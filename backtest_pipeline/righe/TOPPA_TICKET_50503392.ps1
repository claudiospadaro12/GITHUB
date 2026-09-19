# =====================================================================
#  MARCATORE_TOPPA_TICKET_50503392_v1
#
#  TOPPA "CHIUSURA PER TICKET" -- SOSTITUZIONE DI TRE SORGENTI .mq5
#  NELLA CARTELLA DATI DEL TERMINALE 50503392.
#
#  Firma: report/FIRMA_2026-09-19_CHIUSURA_PER_TICKET.md
#  Referti: report/DUE_SEDIE_NASDAQ_IL_BLOCCO_2026-09-19.md
#           report/TOPPA_CHIUSURA_PER_TICKET_2026-09-19.md
#
#  COSA FA, PER INTERO E SENZA SORPRESE:
#    1. trova la cartella DATI del terminale 50503392 (hash COSTANTE, non
#       cercato) e la CERTIFICA leggendo origin.txt;
#    2. localizza i tre .mq5 dentro MQL5\Experts (esattamente uno ciascuno);
#    3. ne fa una COPIA DI SICUREZZA sul Desktop (cartella datata + zip);
#    4. verifica l'IMPRONTA dei tre file presenti (righe + sha256 dello
#       scheletro ASCII). Se anche UNA sola non combacia NON SOSTITUISCE
#       NIENTE e muore dicendo quale e perche';
#    5. scarica i tre .mq5 patchati dal PIN e ne verifica l'impronta PRIMA
#       di scrivere (cache di GitHub raw aggirata due volte: URL per
#       commit + impronta del contenuto);
#    6. copia, rilegge e stampa nome / righe prima / righe dopo.
#
#  COSA NON FA, ED E' UNA PROMESSA VERIFICABILE:
#    - NON compila (F7 e' a mano, ed e' di Claudio -- passo 5 della firma);
#    - NON apre, NON chiude, NON tocca nessun processo. In questo file non
#      esiste nessuna chiamata capace di terminare un processo;
#    - NON scrive in NESSUNA cartella dati che non sia quella del 50503392.
#      Il percorso di destinazione e' una COSTANTE, non il risultato di una
#      ricerca: non c'e' nessun ciclo sulle cartelle da cui possa uscire
#      quella sbagliata.
#
#  BERSAGLIO UNICO: terminale 50503392, C:\Program Files\BCM Markets
#  MT5 Terminal, cartella dati 215D85D767A1C39E22D242C8114BF9F5.
#  Sul VPS ci sono SETTE cartelle dati: le altre SEI non vengono nemmeno
#  guardate.
#
#  ASCII PURO: niente emoji, niente accentate (PS 5.1 legge i .ps1 come
#  ANSI -- regola di casa del 17/08).
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
# La GUARDIA DEL BERSAGLIO: il percorso qui sotto e' l'UNICO ammesso, e
# subito sotto c'e' il rifiuto di tutto il resto.
$PROG_ATTESO  = 'C:\Program Files\BCM Markets MT5 Terminal'
$PROG_VIETATI = @('-V3', 'BCM_Reale', 'MT5_Backtest', 'MT5_MANUALE', 'Pepperstone', 'Tickmill')

$REPO_RAW = 'https://raw.githubusercontent.com/claudiospadaro12/GITHUB'
$SOTTOCAR = 'backtest_pipeline/toppe_da_applicare/2026-09-19'

# nome | righe attese PRIMA | sha256 scheletro PRIMA | righe attese DOPO | sha256 scheletro DOPO
$TAVOLA = @(
  [pscustomobject]@{
    Nome      = 'ABTG_Nasdaq_Apertura_US.mq5'
    RighePre  = 2032
    ShaPre    = '6CC6ED540B02575ACD5C2AC334711D53A88DABD697D1E4E5B6CA63F9CB6E7A98'
    RighePost = 2090
    ShaPost   = '07941FDDDB787C6CFEE79E390AF0633A1659F479136A55B9BF67B84541DDA6E9'
  },
  [pscustomobject]@{
    Nome      = 'ABTG_DAX_Apertura_EU.mq5'
    RighePre  = 2132
    ShaPre    = '0B0862963D49424E2EE1CE6222C3C10172FCEBF9A1B841A14F6A77428B2E178C'
    RighePost = 2190
    ShaPost   = '5564A149E717F4EAE5774936A20B1D549071186A0AAAF6A3EACD015A4ADC3B92'
  },
  [pscustomobject]@{
    Nome      = 'ABTG_Dow_Apertura_US.mq5'
    RighePre  = 2064
    ShaPre    = '255058CF8DD5427A6BE5ED510866546C1C932E2E775AFEFB36768BD1C7339350'
    RighePost = 2122
    ShaPost   = '24ABB614492744EA5176DA891C7DF517BFED67FB1D4CEE84D4A76323D1D68052'
  }
)

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
    # NB: FileStream.Read non garantisce di riempire il buffer in una volta.
    # Un byte mancante qui diventerebbe una "impronta diversa" inventata, cioe'
    # un giro a vuoto. Quindi si cicla finche' il buffer e' pieno.
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
#
# Il conteggio delle righe da solo non basta (due vintage possono avere
# le stesse righe), ma l'impronta dei BYTE nudi e' troppo fragile: fra
# MetaEditor e il repo cambiano fine riga (CRLF/LF), presenza del BOM e
# codifica delle lettere accentate nei COMMENTI. Tutte e tre le cose non
# cambiano una virgola di codice.
# Quindi si normalizza: CRLF -> LF, si buttano i caratteri fuori
# dall'ASCII stampabile (le accentate dei commenti), si toglie l'a-capo
# finale, e si fa lo sha256 di quello che resta. Il CODICE di un .mq5 e'
# ASCII per costruzione: se lo scheletro combacia, il codice e' identico.
# Righe = a-capo + 1, cioe' le righe di CONTENUTO.
#
# NB (misurato il 19/09): CODA_06 conta le righe con
#     @($t -split "`r?`n").Count
# su un file che finisce con un a-capo, e quindi stampa UNO IN PIU':
# 2033/2133/2065 nel referto = 2032/2132/2064 di contenuto. Qui si conta
# il CONTENUTO, ed e' il numero della firma.
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

function Muori($msg) {
  Write-Host ''
  Write-Host '=====================================================================' -ForegroundColor Red
  Write-Host ('FERMO: ' + $msg) -ForegroundColor Red
  Write-Host 'NESSUN FILE E STATO SOSTITUITO.' -ForegroundColor Red
  Write-Host '=====================================================================' -ForegroundColor Red
  exit 1
}

Write-Host '====================================================================='
Write-Host ' TOPPA CHIUSURA PER TICKET -- SOLO COPIA DI FILE, NESSUNA COMPILAZIONE'
Write-Host (' bersaglio: terminale ' + $CONTO + ', cartella dati ' + $HASH_DATI)
Write-Host (' pin      : ' + $Pin)
Write-Host (' ora      : ' + (Get-Date).ToString('yyyy-MM-dd HH:mm:ss', $INV) + '  (ora locale)')
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
Write-Host ('[1/6] cartella dati CERTIFICATA: ' + $prog) -ForegroundColor Green
Write-Host ('      ' + $dati)

$esperti = Join-Path $dati 'MQL5\Experts'
if(-not (Test-Path -LiteralPath $esperti)){ Muori ('manca ' + $esperti) }

# =====================================================================
# PASSO 2 -- I TRE FILE, UNO CIASCUNO
# =====================================================================
$tutti = @(Get-ChildItem -LiteralPath $esperti -Filter *.mq5 -Recurse -File -ErrorAction SilentlyContinue)
$trovati = @()
foreach($r in $TAVOLA){
  $c = @($tutti | Where-Object { $_.Name -eq $r.Nome })
  if($c.Count -eq 0){ Muori ('non trovo ' + $r.Nome + ' sotto ' + $esperti) }
  if($c.Count -gt 1){ Muori ($r.Nome + ' esiste in ' + $c.Count.ToString($INV) + ' copie sotto ' + $esperti + ': non so quale gira. Censire a mano prima di sostituire.') }
  $trovati += [pscustomobject]@{ Riga = $r; Path = $c[0].FullName }
}
Write-Host '[2/6] i tre sorgenti trovati, una copia ciascuno:' -ForegroundColor Green
foreach($t in $trovati){ Write-Host ('      ' + $t.Path) }

# =====================================================================
# PASSO 3 -- COPIA DI SICUREZZA (si fa SEMPRE, anche se poi si muore:
#            se l'impronta non combacia, questi file sono la base su cui
#            rifare la toppa, e devono essere gia sul Desktop)
# =====================================================================
$stamp = (Get-Date).ToString('yyyy-MM-dd_HHmmss', $INV)
$desk  = Join-Path $env:USERPROFILE 'Desktop'
if(-not (Test-Path -LiteralPath $desk)){ $desk = $env:USERPROFILE }
$cartBk = Join-Path $desk ('TOPPA_TICKET_' + $CONTO + '_' + $stamp)
$dirBk  = Join-Path $cartBk 'ORIGINALI'
[void](New-Item -ItemType Directory -Path $dirBk -Force)
foreach($t in $trovati){
  Copy-Item -LiteralPath $t.Path -Destination (Join-Path $dirBk $t.Riga.Nome) -Force
}
$zipBk = Join-Path $desk ('TOPPA_TICKET_' + $CONTO + '_' + $stamp + '_ORIGINALI.zip')
Compress-Archive -Path (Join-Path $dirBk '*') -DestinationPath $zipBk -Force
Write-Host '[3/6] COPIA DI SICUREZZA fatta (i tre originali, prima di toccarli):' -ForegroundColor Green
Write-Host ('      cartella: ' + $dirBk)
Write-Host ('      zip     : ' + $zipBk)

# =====================================================================
# PASSO 4 -- IL CONTROLLO DELLE IMPRONTE. Tutte e tre o nessuna.
# =====================================================================
Write-Host '[4/6] controllo delle IMPRONTE dei file presenti...'
$guasti = @()
foreach($t in $trovati){
  $s = Scheletro (Leggi-Testo $t.Path)
  $t | Add-Member -NotePropertyName Pre -NotePropertyValue $s -Force
  $okR = ($s.Righe -eq $t.Riga.RighePre)
  $okS = ($s.Sha   -eq $t.Riga.ShaPre)
  $esito = 'OK'
  if(-not $okR){ $esito = 'RIGHE DIVERSE' }
  elseif(-not $okS){ $esito = 'RIGHE OK MA CODICE DIVERSO' }
  Write-Host ('      ' + $t.Riga.Nome.PadRight(30) + ' righe=' + $s.Righe.ToString($INV).PadLeft(5) + ' (attese ' + $t.Riga.RighePre.ToString($INV) + ')  sha=' + $s.Sha.Substring(0,16) + '  -> ' + $esito)
  if(-not ($okR -and $okS)){
    $guasti += ($t.Riga.Nome + ': ' + $esito + ' (righe ' + $s.Righe.ToString($INV) + ' contro ' + $t.Riga.RighePre.ToString($INV) + ', sha ' + $s.Sha.Substring(0,16) + ' contro ' + $t.Riga.ShaPre.Substring(0,16) + ')')
  }
}
if($guasti.Count -gt 0){
  Write-Host ''
  foreach($g in $guasti){ Write-Host ('      GUASTO: ' + $g) -ForegroundColor Red }
  Write-Host ''
  Write-Host '      Questo terminale ha un vintage DIVERSO da quello censito il 18/09.' -ForegroundColor Yellow
  Write-Host '      La toppa va rifatta su QUESTA base (classe 449).' -ForegroundColor Yellow
  Write-Host ('      I file veri sono gia sul Desktop: manda lo zip ' + $zipBk) -ForegroundColor Yellow
  Muori 'almeno un file non ha l impronta attesa.'
}
Write-Host '      tutte e tre le impronte combaciano.' -ForegroundColor Green

# =====================================================================
# PASSO 5 -- SCARICO E VERIFICO PRIMA DI SCRIVERE
#            (URL per COMMIT: la cache ~5 min di raw.githubusercontent
#             non puo' servire un contenuto vecchio a un URL per sha;
#             e comunque l'impronta del contenuto lo ricontrolla.)
# =====================================================================
Write-Host '[5/6] scarico i tre patchati dal pin e ne verifico l impronta...'
$dirTmp = Join-Path $cartBk 'PATCHATI'
[void](New-Item -ItemType Directory -Path $dirTmp -Force)
$wc = New-Object Net.WebClient
try {
  foreach($t in $trovati){
    $url = $REPO_RAW + '/' + $Pin + '/' + $SOTTOCAR + '/' + $t.Riga.Nome
    $dst = Join-Path $dirTmp $t.Riga.Nome
    $byte = $wc.DownloadData($url)
    [IO.File]::WriteAllBytes($dst, $byte)
    $s = Scheletro ([Text.Encoding]::UTF8.GetString($byte))
    if($s.Righe -ne $t.Riga.RighePost -or $s.Sha -ne $t.Riga.ShaPost){
      Muori ('il file scaricato ' + $t.Riga.Nome + ' NON e quello atteso (righe ' + $s.Righe.ToString($INV) + ' contro ' + $t.Riga.RighePost.ToString($INV) + ', sha ' + $s.Sha.Substring(0,16) + ' contro ' + $t.Riga.ShaPost.Substring(0,16) + '). Pin sbagliato o cache: niente e stato sostituito.')
    }
    $t | Add-Member -NotePropertyName Scaricato -NotePropertyValue $dst -Force
    Write-Host ('      ' + $t.Riga.Nome.PadRight(30) + ' scaricato e verificato (righe ' + $s.Righe.ToString($INV) + ')') -ForegroundColor Green
  }
} finally { $wc.Dispose() }

# =====================================================================
# PASSO 6 -- LA SOSTITUZIONE, e la rilettura che la dimostra
# =====================================================================
Write-Host '[6/6] sostituzione...'
# Se una copia fallisce (per esempio il file e aperto in scrittura da
# MetaEditor) NON si muore qui: si segna e si va lo stesso alla tabella
# finale, che e' riletta dal disco e dice file per file com e finita.
# Morire a meta' lascerebbe uno stato misto senza referto.
foreach($t in $trovati){
  try {
    Copy-Item -LiteralPath $t.Scaricato -Destination $t.Path -Force
  } catch {
    Write-Host ('      COPIA FALLITA su ' + $t.Riga.Nome + ': ' + $_.Exception.Message) -ForegroundColor Red
  }
}
Write-Host ''
Write-Host '====================================================================='
Write-Host ' RISULTATO -- riletto dal disco del terminale, non dedotto'
Write-Host '====================================================================='
Write-Host ('  ' + 'FILE'.PadRight(30) + 'PRIMA'.PadLeft(7) + 'DOPO'.PadLeft(8) + '   ESITO')
$tuttoBene = $true
foreach($t in $trovati){
  $s = Scheletro (Leggi-Testo $t.Path)
  $ok = ($s.Righe -eq $t.Riga.RighePost -and $s.Sha -eq $t.Riga.ShaPost)
  if(-not $ok){ $tuttoBene = $false }
  $e = 'ENTRATA'
  if(-not $ok){ $e = 'NON ENTRATA -- controllare a mano' }
  $col = 'Green'
  if(-not $ok){ $col = 'Red' }
  Write-Host ('  ' + $t.Riga.Nome.PadRight(30) + $t.Pre.Righe.ToString($INV).PadLeft(7) + $s.Righe.ToString($INV).PadLeft(8) + '   ' + $e) -ForegroundColor $col
}
Write-Host ''
Write-Host ('  copia di sicurezza: ' + $zipBk)
Write-Host ''
if($tuttoBene){
  Write-Host '  ADESSO TOCCA A TE, E SOLO A MANO:' -ForegroundColor Yellow
  Write-Host ('   1. apri MetaEditor del terminale ' + $CONTO + ' (' + $PROG_ATTESO + ')') -ForegroundColor Yellow
  Write-Host '   2. se hai uno dei tre file gia aperto in una scheda, CHIUDI la scheda' -ForegroundColor Yellow
  Write-Host '      senza salvare e riaprilo: altrimenti salvi sopra la toppa appena messa' -ForegroundColor Yellow
  Write-Host '   3. apri i tre .mq5 e premi F7 su ciascuno (0 errori attesi)' -ForegroundColor Yellow
  Write-Host '   4. in MT5, rimuovi e riattacca i tre EA perche prendano il nuovo .ex5' -ForegroundColor Yellow
  Write-Host ''
  Write-Host '  QUESTA RIGA NON HA COMPILATO NIENTE E NON HA TOCCATO NESSUN PROCESSO.' -ForegroundColor Yellow
  exit 0
} else {
  Write-Host '  ALMENO UN FILE NON E ENTRATO. Gli originali sono nello zip qui sopra.' -ForegroundColor Red
  exit 2
}
