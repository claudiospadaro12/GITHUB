# =====================================================================
#  MARCATORE_RICOMPILA_CLAU12_TRAILFIX_v1
#  RICOMPILA_CLAU12_TRAILFIX.ps1 -- porta la TRAILFIX (Parte A) nelle
#  TRE CLAU12 delle sedie d'apertura sul terminale FTMO 541452707
#  (cartella programma C:\FTMO) e le ricompila con il SUO MetaEditor.
#
#  SI LANCIA SOLO QUANDO:
#    1. la prova di neutralita' R254 (PASSATA_TRAILFIX.ps1, PC di
#       backtest) e' uscita NEUTRA su TUTTE E QUATTRO le sedie
#       770101, 770105, 770202, 770260 -- niente "neutra per analogia";
#    2. Claudio ha FIRMATO la ricompilazione (tocca il binario di sedie
#       vive sul conto della challenge);
#    3. e' SABATO o DOMENICA (le sedie non hanno posizioni ne' pendenti).
#  Il punto 1 lo dichiara Claudio con  -Conferma NEUTRA : lo script non
#  lo puo' verificare da solo, e lo DICE.
#
#  I TRE FILE (sorgenti al pin 1d68dadd, cartella
#  mql5/Experts/trailfix_9fca63d9/ del repo):
#    CLAU12_DAX_Apertura_EU.mq5    -> 770101 (BUY) + 770105 (SELL)
#    CLAU12_Dow_Apertura_US.mq5    -> 770202
#    CLAU12_Nasdaq_Apertura_US.mq5 -> 770260
#  Il DAX e' UN binario per DUE grafici: ricompilarlo ricarica tutti e due.
#
#  COSA FA, in ordine (le lettere sono quelle del pacchetto):
#    a) guardia macchina VMI3047753;
#    b) cartella dati FTMO per HASH 46C9F8E9FF0C747B2B5E09BCC13D5237 E
#       origin.txt = C:\FTMO E conto 541452707 nel giornale; e non deve
#       essere nessuna delle sette cartelle di casa. Altrimenti STOP;
#    c) giorno: se non e' sabato/domenica STOP, salvo -ForzaGiorno
#       (dichiarato a schermo e nell'ESITO);
#    d) Get-Process terminal64 stampato; metaeditor64 APERTO = STOP
#       (lezione del 22/08: con l'editor aperto /compile torna muto);
#    e) scarico dei 3 sorgenti al -Pin (raw + cache-buster), SHA256
#       dei BYTE confrontato con quello scritto qui, in MEMORIA;
#    f) stato dei file sul disco del terminale: il CLAU12_<EA>.mq5 in
#       campo deve avere l'impronta SCHELETRO del pin 9fca63d9 (quella
#       di RINOMINA_CLAU12.ps1). Impronta ignota = STOP prima di
#       scrivere. Gia' TrailFix con .ex5 fresco = GIA FATTO;
#    g) include ABTG_PausaGuardian.mqh: NON si tocca, si MISURA. Deve
#       essere la v1.20 (pin 26a18566, 398 righe, scheletro D179846B)
#       che ha compilato i binari in campo il 20/09. Diverso = STOP;
#    h) BACKUP per COPIA (mai cancellazione, mai rinomina: vedi sotto)
#       CLAU12_<EA>.mq5/.ex5 -> CLAU12_<EA>.mq5.PRIMA_TRAILFIX_<ts> e
#       CLAU12_<EA>.ex5.PRIMA_TRAILFIX_<ts>, verificati per SHA256;
#    i) copia del sorgente nuovo, SHA256 riletto dal disco;
#    j) compilazione: C:\FTMO\metaeditor64.exe /compile /inc /log,
#       log UTF-16 letto, "0 errors" OBBLIGATORIO, .ex5 con data DOPO
#       l'avvio della compilazione (classe 270). Se fallisce: RIPRISTINO
#       dal backup di QUEL file (mq5 e, se toccato, ex5), STOP rosso;
#    k) impronta scheletro dei sorgenti nuovi stampata;
#    l) Desktop: RICOMPILA_CLAU12_TRAILFIX_<ts>\ (3 log + ESITO.txt +
#       i 3 sorgenti scaricati) e lo zip accanto;
#    m) istruzione finale: scheda Esperti di C:\FTMO, 4 righe "avviato
#       su" + 4 "CONFIG IN USO" nuove, faccina, Algo Trading.
#
#  PERCHE' IL BACKUP E' UNA COPIA E NON UNA RINOMINA
#  Il pacchetto chiedeva di RINOMINARE il .ex5 vecchio. Contro-esempio:
#  con il terminale acceso e l'EA attaccato, rinominare il .ex5 lo fa
#  SPARIRE dal disco per tutta la durata della compilazione (fino a
#  qualche decina di secondi). Che cosa faccia MT5 con un EA attaccato
#  il cui .ex5 sparisce NON e' misurato in casa: se lo stacca dal
#  grafico, dopo la compilazione le sedie restano MUTE senza che niente
#  lo dica. Con la COPIA il .ex5 vecchio resta al suo posto finche'
#  MetaEditor non lo SOVRASCRIVE, e la sovrascrittura e' proprio
#  l'evento che deve far ricaricare l'EA. Il nome del backup e' quello
#  chiesto, ed e' invisibile al Navigatore (non finisce in .mq5/.ex5).
#
#  COSA NON FA, per nome:
#    - NON tocca preset (.set), taglie, magic, input, profili, .chr;
#    - NON tocca ABTG_PausaGuardian.mqh (lo legge e basta);
#    - NON tocca le altre CLAU12 di C:\FTMO: CLAU12_Guardian (779001),
#      CLAU12_EMA200 (771531), CLAU12_SuperWave_DOW_H1_Ottimizzato
#      (770511), CLAU12_MaxMinNotte_DAX_Short_Ottimizzato (770411);
#    - NON tocca nessun ABTG_*.mq5/.ex5 eventualmente rimasto su C:\FTMO;
#    - NON apre, NON chiude, NON termina nessun processo MT5 (legge
#      soltanto Get-Process; l'unico processo che AVVIA e' metaeditor64
#      di C:\FTMO, uno per file, in sequenza);
#    - NON tocca gli altri SEI terminali del VPS: REALE 10105439
#      (C:\BCM_Reale), 100k 50504263 (-V3), piccolo 50503392 (BCM
#      Markets MT5 Terminal), manuale 50503635 (C:\MT5_MANUALE), banco
#      50504400 (C:\MT5_Backtest), Pepperstone, Tickmill;
#    - NON attacca e NON stacca EA, NON tocca Algo Trading.
#  Scrive SOLO in <cartella dati di C:\FTMO>\MQL5\Experts (i 3 .mq5, i 3
#  .ex5 via MetaEditor, i 6 backup) e sul Desktop del VPS.
#
#  PROVA A SECCO (senza -Esegui): fa a-g, stampa quello che farebbe e
#  NON SCRIVE NIENTE, nemmeno sul Desktop (lo scarico sta in memoria).
#
#  [NON VERIFICATO], in un posto solo:
#    - che MT5 RICARICHI gli EA attaccati quando il .ex5 cambia: e'
#      comportamento noto del programma, MAI misurato in casa
#      (report/EXPORTER_SUL_REALE_2026-09-11.md r.208). Un precedente
#      di casa dice anche che il terminale "tiene il file aperto" e la
#      scrittura di MetaEditor "puo' fallire a meta'"
#      (report/PACCHETTO_SCHIERAMENTO_EMA200_2026-09-13.md r.333): se
#      succede, il .ex5 non e' fresco e questo script RIPRISTINA;
#    - che il binario nuovo erediti gli input salvati sul grafico: e'
#      la regola scritta in report/RIMETTERE_IL_CAMPO_IN_PARI_2026-09-12.md
#      r.271 (la TrailFix non aggiunge input: nessun default nuovo);
#    - la combinazione CLAU12@1d68dadd + include v1.20 non e' MAI stata
#      compilata: la differenza col pin in campo usa solo funzioni
#      dell'EA (ABTGLog, NormalizePrice, SymbolInfoInteger, iTime),
#      quindi deve compilare come ha compilato il pin il 20/09 [INFERITO].
#
#  USCITE: 0 fatto (o prova a secco riuscita) . 1 rifiuto, NIENTE
#  scritto nel terminale . 2 gia fatto . 3 fallito DOPO aver scritto
#  (con ripristino: leggere l'ESITO).
#
#  ASCII PURO: niente emoji, niente accentate (PS 5.1 legge i .ps1
#  come ANSI -- regola di casa del 17/08).
# =====================================================================

param(
  [Parameter(Mandatory=$true)][string]$Pin,
  [switch]$Esegui,
  [string]$Conferma = '',
  [switch]$ForzaGiorno
)

$ErrorActionPreference = 'Stop'
$INV = [Globalization.CultureInfo]::InvariantCulture
try { [Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12 } catch { }
$T0 = Get-Date
$STAMPA = $T0.ToString('yyyyMMdd_HHmmss', $INV)

# ---------------------------------------------------------------------
#  COSTANTI. Misurate il 26/09/2026 con git sul repo, branch lavoro:
#    git show 1d68dadd:mql5/Experts/trailfix_9fca63d9/CLAU12_<EA>.mq5 | sha256sum
#    scheletro = stessa funzione di RINOMINA_CLAU12.ps1 (riprodotta e
#    controllata: sul pin 9fca63d9 da' i tre numeri della sua tavola).
# ---------------------------------------------------------------------
$MACCHINA = 'VMI3047753'
$HD       = '46C9F8E9FF0C747B2B5E09BCC13D5237'
$PROG     = 'C:\FTMO'
$CONTO    = '541452707'
$RAWROOT  = 'https://raw.githubusercontent.com/claudiospadaro12/GITHUB/'
$REL_DIR  = 'mql5/Experts/trailfix_9fca63d9/'
$FIRMA_A  = 'trailing rinviato: stop'

$FILE = @(
  [pscustomobject]@{ Nome='CLAU12_DAX_Apertura_EU';    Sedie='770101 (BUY) + 770105 (SELL)  GER40.cash M5';
    ShaNuovo='7219A044DAAA1B58AE7C6A2885E7F3D5E7E31187178AE68735FE510876CBCB41'; RigheNuovo=2474; SchNuovo='9E9D2634578DACCDFFB09E22A4C8505CA3D92F4B0DFFBF7C905742230BC5094D';
    RigheCampo=2425; SchCampo='59B67F5F912476E270C62079C80799B3E86F696AEE2F17BD158E2B4828BAD692'; ShaCampo='D9F4636471A1B2632936E398BAC3CBCCEF6FDA89C1B432626B21D8DD7E719DD3' },
  [pscustomobject]@{ Nome='CLAU12_Dow_Apertura_US';    Sedie='770202  US30.cash M5';
    ShaNuovo='B07502C461485ABB77F13259AD24755ACA859F56CC59665C7845C0A8643857A5'; RigheNuovo=2254; SchNuovo='507D6E0BA7BE6259D4F566F23315AF61A2E5955FDF9BF7149ADB96A330AD1010';
    RigheCampo=2205; SchCampo='0BF7A1B3466DA1A0807421B3CFAF59A0455276B2DD98CA8FBF610FEB391019B1'; ShaCampo='C2676B14DC222FB111C009D8A88729FA98D24B6B3FE0EF629054D58D424BDC1E' },
  [pscustomobject]@{ Nome='CLAU12_Nasdaq_Apertura_US'; Sedie='770260  US100.cash M5';
    ShaNuovo='5B4BB6F2DA9F959E53C30EFB63DA69CD95A6F0B4DB203CD826A15EBB8AF4898D'; RigheNuovo=2673; SchNuovo='81187E79C585F844C0CE033F7CF53C5740F4B736A9345CF9FF8123C5E47A2F73';
    RigheCampo=2624; SchCampo='87BD4B187CCE6195D5F328FD833E61EF3B741FAED7FB2C7CD18AA3AE60CCB8A8'; ShaCampo='349B4B7F2A813E228B8FC0556E977EB304F4B01DDD01ABF0264FC3044955CF09' }
)

# L'include in campo: v1.20 al pin 26a18566, installato da SCHIERA_FTMO.ps1
# il 20/09 (report/SCHIERAMENTO_FTMO_2026-09-20.md par.5.1). NON e' quello
# del pin dei sorgenti (3ec97115..., v1.6x, 2461 righe): R254 ha compilato
# con quello, il campo con questo. Si misura e non si tocca.
$INC_RIGHE = 398
$INC_SCH   = 'D179846B407FDACC963825103F850E8F8BEE39B1DA3521A504EF74F8638AC8BC'
$INC_BYTE  = '83F19640CC21C0C9AB5AB6E7BF108F0190A12995E67FBA0F38D8C5A8A98DD5E2'
$INC_V16X_SCH = 'E9F503F581265A00E4389E8482A18FB9244AA53529A9969CA358137E39EF344C'

# Le sette cartelle di casa: SOLO lista nera (copiata da RINOMINA_CLAU12.ps1).
$HASH_NOTI = @{
  '215D85D767A1C39E22D242C8114BF9F5' = '50503392  piccolo demo      (C:\Program Files\BCM Markets MT5 Terminal)'
  'BCA8AD18563BF5B64A433C2662D0A104' = '50504263  100k demo         (C:\Program Files\BCM Markets MT5 Terminal -V3)'
  'E23E1504A8D02A22179395F0652B86B6' = '10105439  *** REALE ***     (C:\BCM_Reale)'
  '04C7A32B575E40027B4FF8724D14D702' = '50504400  banco di backtest (C:\MT5_Backtest)'
  'CF6C240A869369695913FB76DA84BD22' = '50503635  manuale           (C:\MT5_MANUALE)'
  '73B7A2420D6397DFF9014A20F1201F97' = 'broker esterno Pepperstone'
  '857385E4B0F2356AD99AA95CDF40FAE9' = 'broker esterno Tickmill'
}

$RIGHE = New-Object System.Collections.ArrayList
function Dillo($testo, $colore) {
  if($colore){ Write-Host $testo -ForegroundColor $colore } else { Write-Host $testo }
  [void]$RIGHE.Add($testo)
}
function Titolo($t){ Dillo '' $null; Dillo ('=== ' + $t + ' ===') 'Cyan' }

# Lettura condivisa (copiata da RINOMINA_CLAU12.ps1): il file puo' essere
# tenuto aperto dal terminale. Riconosce UTF-16 (log di MetaEditor).
function Leggi-Byte($path) {
  $fs = [IO.File]::Open($path, [IO.FileMode]::Open, [IO.FileAccess]::Read, [IO.FileShare]::ReadWrite)
  try {
    $b = New-Object byte[] $fs.Length
    $letti = 0
    while($letti -lt $b.Length){
      $q = $fs.Read($b, $letti, $b.Length - $letti)
      if($q -le 0){ break }
      $letti += $q
    }
    if($letti -ne $b.Length){ throw ('lettura incompleta di ' + $path) }
  } finally { $fs.Close() }
  return ,$b
}
function Testo-Da-Byte($b) {
  if($null -eq $b -or $b.Length -lt 2){ return '' }
  if($b[0] -eq 0xFF -and $b[1] -eq 0xFE){ return [Text.Encoding]::Unicode.GetString($b, 2, $b.Length - 2) }
  $zeri = 0
  $n = [math]::Min(400, $b.Length)
  for($i = 1; $i -lt $n; $i += 2){ if($b[$i] -eq 0){ $zeri++ } }
  if($zeri -gt ($n / 4)){ return [Text.Encoding]::Unicode.GetString($b) }
  return [Text.Encoding]::UTF8.GetString($b)
}
function Leggi-Testo($path) {
  try { return (Testo-Da-Byte (Leggi-Byte $path)) } catch { return '' }
}
function Sha-Byte($b) {
  $sha = [Security.Cryptography.SHA256]::Create()
  try { $hb = $sha.ComputeHash($b) } finally { $sha.Dispose() }
  $sb = New-Object Text.StringBuilder
  foreach($x in $hb){ [void]$sb.Append($x.ToString('X2', $INV)) }
  return $sb.ToString()
}
# Lettura condivisa anche per l impronta: un .ex5 caricato dal terminale puo'
# essere aperto, e Get-FileHash non chiede FileShare.ReadWrite.
function Sha-File($path) { return (Sha-Byte (Leggi-Byte $path)) }

# Scheletro: COPIATA ALLA LETTERA da RINOMINA_CLAU12.ps1 (che la copia da
# SCHIERA_FTMO.ps1): CRLF->LF, via il non-ASCII, via le righe vuote in coda.
function Scheletro($testo) {
  $t = $testo -replace "`r`n", "`n"
  $t = $t -replace "`r", "`n"
  $t = $t -replace '[^\u0009\u000A\u0020-\u007E]', ''
  $t = $t.TrimEnd("`n")
  $nRighe = ($t -split "`n").Count
  $sha = [Security.Cryptography.SHA256]::Create()
  try { $hb = $sha.ComputeHash([Text.Encoding]::ASCII.GetBytes($t)) } finally { $sha.Dispose() }
  $sb = New-Object Text.StringBuilder
  foreach($x in $hb){ [void]$sb.Append($x.ToString('X2', $INV)) }
  return [pscustomobject]@{ Righe = $nRighe; Sha = $sb.ToString() }
}
function Impronta-Di($path) {
  $t = Leggi-Testo $path
  if($t -eq ''){ return [pscustomobject]@{ Righe = 0; Sha = '' } }
  return (Scheletro $t)
}

# Desktop con ripiego (stesso di RINOMINA_CLAU12.ps1 / riga del preset).
$DESKTOP = ''
try { $DESKTOP = [Environment]::GetFolderPath('Desktop') } catch { $DESKTOP = '' }
if(-not $DESKTOP -or -not (Test-Path -LiteralPath $DESKTOP)){ $DESKTOP = Join-Path $env:USERPROFILE 'Desktop' }
if(-not (Test-Path -LiteralPath $DESKTOP)){ $DESKTOP = $env:USERPROFILE }
$CARTREF = Join-Path $DESKTOP ('RICOMPILA_CLAU12_TRAILFIX_' + $STAMPA)
$ZIP     = $CARTREF + '.zip'

$ESITO   = 'FERMATO PRIMA DI SCRIVERE'
$CODICE  = 1
$SCRITTO = $false
$IN_CORSO = $null

function Posa-Esito {
  if(-not $Esegui){ return }
  try {
    if(-not (Test-Path -LiteralPath $CARTREF)){ [void](New-Item -ItemType Directory -Path $CARTREF -Force) }
    $f = Join-Path $CARTREF 'ESITO.txt'
    $testo = ($RIGHE -join "`r`n") -replace '[^\u0009\u000A\u000D\u0020-\u007E]', '?'
    [IO.File]::WriteAllText($f, $testo, [Text.Encoding]::ASCII)
    if(Test-Path -LiteralPath $ZIP){ Remove-Item -LiteralPath $ZIP -Force }
    Compress-Archive -Path (Join-Path $CARTREF '*') -DestinationPath $ZIP -Force
    Write-Host ''
    Write-Host ('File nella cartella ' + $CARTREF + ':') -ForegroundColor Cyan
    foreach($x in @(Get-ChildItem -LiteralPath $CARTREF | Sort-Object Name)){ Write-Host ('   ' + $x.Name + '   ' + $x.Length.ToString($INV) + ' byte') -ForegroundColor Cyan }
    Write-Host '   ATTESI: ESITO.txt sempre; compila_CLAU12_<EA>.log per ogni file che e arrivato alla compilazione (3 se tutto e andato); scaricato_CLAU12_<EA>.mq5 (3).' -ForegroundColor Cyan
    Write-Host ('MANDA IN CHAT QUESTO FILE: ' + $ZIP) -ForegroundColor Cyan
  } catch { Write-Host ('ESITO/zip NON scritti sul Desktop: ' + $_.Exception.Message + ' -- fai una foto di questa finestra.') -ForegroundColor Red }
}

function Stato-Finale {
  Titolo 'k) IMPRONTA SCHELETRO DEI SORGENTI ORA IN CAMPO (per il referto e per CODA_06)'
  foreach($f in $FILE){
    if(-not $f.PSObject.Properties['PMq5']){ continue }
    $imp = Impronta-Di $f.PMq5
    $st = 'NON E LA TRAILFIX'
    if($imp.Sha -eq $f.SchNuovo -and $imp.Righe -eq $f.RigheNuovo){ $st = 'TrailFix' }
    $dx = ''
    if(Test-Path -LiteralPath $f.PEx5){ $dx = (Get-Item -LiteralPath $f.PEx5).LastWriteTime.ToString('yyyy-MM-dd HH:mm:ss', $INV) }
    Dillo ('   ' + ($f.Nome + '.mq5').PadRight(31) + ' righe ' + $imp.Righe + '  scheletro ' + $imp.Sha + '  -> ' + $st + '   .ex5 ' + $dx) $(if($st -eq 'TrailFix'){ 'Green' } else { 'Red' })
  }
}

function Fine($codice, $esito, $colore) {
  $script:CODICE = $codice
  $script:ESITO = $esito
  Dillo '' $null
  Dillo '=====================================================================' $colore
  Dillo ('ESITO: ' + $esito) $colore
  Dillo ('USCITA: ' + $codice.ToString($INV)) $colore
  Dillo '=====================================================================' $colore
  Posa-Esito
  exit $codice
}
function Muori($msg) {
  Dillo '' $null
  Dillo ('FERMO: ' + $msg) 'Red'
  if($script:SCRITTO){
    try { Stato-Finale } catch { Dillo ('tavola dello stato finale NON letta: ' + $_.Exception.Message) 'Red' }
    Fine 3 ('FERMATO DOPO AVER SCRITTO -- STATO MISTO possibile, vedi la tavola k) qui sopra: i file compilati PRIMA restano TrailFix, quello fallito e stato rimesso dalla sua copia, quelli DOPO non sono stati toccati. ' + $msg) 'Red'
  }
  Fine 1 ('RIFIUTO, nel terminale NON e stato scritto niente -- ' + $msg) 'Red'
}

# =====================================================================
try {
Dillo '=====================================================================' 'Cyan'
Dillo ' RICOMPILA CLAU12 TRAILFIX -- terminale FTMO 541452707 (C:\FTMO)' 'Cyan'
Dillo '=====================================================================' 'Cyan'
Dillo (' ora Windows del VPS : ' + $T0.ToString('yyyy-MM-dd HH:mm:ss dddd', $INV)) $null
Dillo (' pin dei sorgenti    : ' + $Pin) $null
if($Esegui){ Dillo ' MODO                : ESEGUI (scrive, compila, ricarica gli EA)' 'Yellow' }
else       { Dillo ' MODO                : PROVA A SECCO -- non scrive NIENTE, nemmeno sul Desktop' 'Green' }
Dillo ' BERSAGLIO: SOLO la cartella dati del terminale FTMO 541452707 (C:\FTMO), MQL5\Experts, piu il Desktop di questo VPS.' 'Yellow'
Dillo ' NON TOCCATI: REALE 10105439 (C:\BCM_Reale), 100k 50504263 (-V3), piccolo 50503392 (BCM Markets MT5 Terminal), manuale 50503635 (C:\MT5_MANUALE), banco 50504400 (C:\MT5_Backtest), Pepperstone, Tickmill; su C:\FTMO: preset, taglie, Guardian, CLAU12_EMA200, CLAU12_SuperWave, CLAU12_MaxMinNotte, include.' 'Yellow'

if($Pin -notmatch '^[0-9a-f]{40}$'){ Muori ('-Pin deve essere un commit di 40 caratteri esadecimali minuscoli. Ricevuto: ' + $Pin) }

# --- conferma della prova R254: SOLO per -Esegui ----------------------
if($Esegui){
  if($Conferma -cne 'NEUTRA'){
    Muori ('-Esegui richiede -Conferma NEUTRA (maiuscolo, esatto): e la dichiarazione di Claudio che R254 e uscita NEUTRA su 770101, 770105, 770202 e 770260. Ricevuto: [' + $Conferma + ']. Questo script NON puo verificarlo da solo.')
  }
  Dillo ' CONFERMA R254       : NEUTRA (dichiarata da chi lancia, non verificata dallo script)' 'Yellow'
}

# =====================================================================
Titolo 'a) MACCHINA'
if($env:COMPUTERNAME -ne $MACCHINA){ Muori ('questa riga gira SOLO sul VPS ' + $MACCHINA + '. Macchina attuale: ' + $env:COMPUTERNAME + '.') }
Dillo ('   macchina ' + $env:COMPUTERNAME + ' : OK') 'Green'

# =====================================================================
Titolo 'b) CARTELLA DATI DEL TERMINALE FTMO'
$radice = Join-Path $env:APPDATA 'MetaQuotes\Terminal'
$dati = Join-Path $radice $HD
if(-not (Test-Path -LiteralPath $dati -PathType Container)){ Muori ('non esiste ' + $dati + ' -- questa riga gira come utente ' + $env:USERNAME + ': deve essere lo stesso utente che fa girare i terminali.') }
foreach($k in $HASH_NOTI.Keys){ if($HD -eq $k){ Muori ('l hash bersaglio e una cartella di casa: ' + $HASH_NOTI[$k]) } }
$og = Join-Path $dati 'origin.txt'
if(-not (Test-Path -LiteralPath $og)){ Muori 'manca origin.txt nella cartella dati: senza certificato non si scrive.' }
$oi = ((Leggi-Testo $og) -replace '[^\u0020-\u007E]', '').Trim().TrimEnd('\')
if($oi -ne $PROG){ Muori ('origin.txt dice [' + $oi + '] e non ' + $PROG + ': non e la cartella del terminale FTMO.') }
Dillo ('   ' + $HD + '  origin.txt = ' + $oi + ' : OK') 'Green'
$lg = Join-Path $dati 'logs'
$txt = ''
$nl = 0
if(Test-Path -LiteralPath $lg){
  foreach($x in @(Get-ChildItem -LiteralPath $lg -Filter *.log -ErrorAction SilentlyContinue | Sort-Object LastWriteTime -Descending | Select-Object -First 10)){ $txt += (Leggi-Testo $x.FullName); $nl++ }
}
if($txt -notmatch ('(?<![0-9])' + $CONTO + '(?![0-9])')){ Muori ('nei ' + $nl + ' giornali piu recenti (logs) non trovo il conto ' + $CONTO + ': non la certifico come FTMO.') }
Dillo ('   giornale: conto ' + $CONTO + ' trovato in ' + $nl + ' file di logs : OK') 'Green'
$dirE = Join-Path $dati 'MQL5\Experts'
$dirM = Join-Path $dati 'MQL5'
$incP = Join-Path $dati 'MQL5\Include\ABTG_PausaGuardian.mqh'
$ME   = Join-Path $PROG 'metaeditor64.exe'
if(-not (Test-Path -LiteralPath $dirE -PathType Container)){ Muori ('non esiste ' + $dirE) }
if(-not (Test-Path -LiteralPath $ME -PathType Leaf)){ Muori ('non esiste ' + $ME + ': senza il MetaEditor di C:\FTMO non si compila (e non se ne usa un altro apposta).') }
Dillo ('   si scrive SOLO in: ' + $dirE) 'Green'
Dillo ('   compilatore      : ' + $ME) 'Green'

# =====================================================================
Titolo 'c) GIORNO'
$dow = $T0.DayOfWeek
if($dow -eq [DayOfWeek]::Saturday -or $dow -eq [DayOfWeek]::Sunday){
  Dillo ('   oggi e ' + $dow + ' (ora Windows del VPS): mercati indici chiusi, le sedie d apertura non hanno posizioni ne pendenti.') 'Green'
} else {
  Dillo ('   OGGI E ' + $dow + ': LE SEDIE 770101 / 770105 / 770202 / 770260 POSSONO AVERE POSIZIONI APERTE O PENDENTI.') 'Red'
  Dillo '   La ricompilazione ricarica l EA (OnDeinit/OnInit) su un trade vivo: si fa nel weekend.' 'Red'
  if(-not $ForzaGiorno){ Muori ('giorno feriale (' + $dow + '). Rilancia sabato o domenica, oppure con -ForzaGiorno dopo aver VERIFICATO a occhio che le quattro sedie non hanno posizioni ne ordini.') }
  Dillo '   -ForzaGiorno PASSATO: chi lancia dichiara di aver verificato che le quattro sedie sono piatte e senza pendenti.' 'Yellow'
}

# =====================================================================
Titolo 'd) PROCESSI MT5 SU QUESTO VPS (sola lettura)'
$pr = @(Get-Process terminal64 -ErrorAction SilentlyContinue)
$tab = ($pr | Select-Object Id, MainWindowTitle, Path | Format-List | Out-String).Trim()
if($tab -eq ''){ $tab = '(nessun terminal64 in esecuzione)' }
foreach($r in ($tab -split "`r?`n")){ Dillo ('   ' + $r) $null }
$vivo = $false
foreach($p in $pr){
  $pp = ''
  try { $pp = $p.Path } catch { $pp = '' }
  if(-not $pp){ continue }
  $dirEseg = ''
  try { $dirEseg = ([IO.Path]::GetDirectoryName($pp)).TrimEnd('\') } catch { $dirEseg = '' }
  if($dirEseg -ieq $PROG){ $vivo = $true }
}
if($vivo){
  Dillo '   Il terminale FTMO (C:\FTMO) e ACCESO. E voluto: quando MetaEditor sovrascrive il .ex5, MT5 ricarica' 'Yellow'
  Dillo '   l EA sui grafici che lo usano (OnDeinit + OnInit, input del grafico conservati). [NON VERIFICATO in casa]' 'Yellow'
} else {
  Dillo '   Il terminale FTMO (C:\FTMO) risulta CHIUSO: i grafici caricheranno il .ex5 nuovo alla prossima apertura.' 'Yellow'
  Dillo '   Finche resta chiuso le sedie NON girano: la verifica di Esperti si fa dopo averlo aperto.' 'Yellow'
}
$edAperti = @(Get-Process metaeditor64 -ErrorAction SilentlyContinue)
if($edAperti.Count -gt 0){
  foreach($p in $edAperti){ $pp = ''; try { $pp = $p.Path } catch { }; Dillo ('   metaeditor64 APERTO: PID ' + $p.Id + '  ' + $pp) 'Red' }
  Muori 'MetaEditor e aperto. Con l editor aperto la compilazione da riga di comando puo tornare senza compilare niente (lezione del 22/08). Chiudi MetaEditor (SOLO MetaEditor, non i terminali) e rilancia.'
}
Dillo '   metaeditor64: nessuno aperto : OK' 'Green'

# =====================================================================
Titolo 'e) SORGENTI AL PIN (scarico in memoria, SHA256 dei byte)'
$wc = New-Object Net.WebClient
foreach($f in $FILE){
  $url = $RAWROOT + $Pin + '/' + $REL_DIR + $f.Nome + '.mq5?cb=' + [Guid]::NewGuid().ToString('N')
  $b = $null
  try { $b = $wc.DownloadData($url) } catch { Muori ('scarico fallito: ' + $f.Nome + '.mq5 al pin ' + $Pin + ' -- ' + $_.Exception.Message + '. Un 404 vuol dire pin sbagliato.') }
  if($null -eq $b -or $b.Length -eq 0){ Muori ('scaricato VUOTO: ' + $f.Nome + '.mq5') }
  $h = Sha-Byte $b
  if($h -ne $f.ShaNuovo){ Muori ('IMPRONTA DIVERSA su ' + $f.Nome + '.mq5 al pin ' + $Pin + ': attesa ' + $f.ShaNuovo + ', trovata ' + $h + '.') }
  $t = Testo-Da-Byte $b
  if($t.IndexOf($FIRMA_A, [StringComparison]::Ordinal) -lt 0){ Muori ($f.Nome + '.mq5 NON contiene "' + $FIRMA_A + '": non e la Parte A.') }
  $sc = Scheletro $t
  if($sc.Sha -ne $f.SchNuovo -or $sc.Righe -ne $f.RigheNuovo){ Muori ($f.Nome + '.mq5: SHA256 giusto ma scheletro diverso (' + $sc.Righe + ' righe, ' + $sc.Sha + '): la funzione di impronta e cambiata.') }
  $f | Add-Member -NotePropertyName Byte -NotePropertyValue $b -Force
  Dillo ('   ' + $f.Nome.PadRight(27) + ' SHA256 ' + $h + '  righe ' + $sc.Righe + '  scheletro ' + $sc.Sha.Substring(0,16) + '...  Parte A: presente') 'Green'
}

# =====================================================================
Titolo 'f) STATO DEI FILE IN CAMPO (impronta scheletro, come RINOMINA_CLAU12)'
$daFare = @()
$giaFatti = 0
foreach($f in $FILE){
  $pM = Join-Path $dirE ($f.Nome + '.mq5')
  $pX = Join-Path $dirE ($f.Nome + '.ex5')
  $f | Add-Member -NotePropertyName PMq5 -NotePropertyValue $pM -Force
  $f | Add-Member -NotePropertyName PEx5 -NotePropertyValue $pX -Force
  $haM = Test-Path -LiteralPath $pM -PathType Leaf
  $haX = Test-Path -LiteralPath $pX -PathType Leaf
  $dX = ''
  if($haX){ $dX = (Get-Item -LiteralPath $pX).LastWriteTime.ToString('yyyy-MM-dd HH:mm:ss', $INV) }
  $stato = ''
  if($haM){
    $imp = Impronta-Di $pM
    $shaB = Sha-File $pM
    if($imp.Sha -eq $f.SchCampo -and $imp.Righe -eq $f.RigheCampo){ $stato = 'CAMPO' }
    elseif($imp.Sha -eq $f.SchNuovo -and $imp.Righe -eq $f.RigheNuovo){ $stato = 'NUOVO' }
    else { $stato = 'IGNOTO' }
    Dillo ('   ' + ($f.Nome + '.mq5').PadRight(31) + ' righe ' + $imp.Righe + '  scheletro ' + $imp.Sha.Substring(0, [math]::Min(16, $imp.Sha.Length)) + '...  SHA256 byte ' + $shaB.Substring(0,16) + '...  -> ' + $stato) $null
  } else {
    $stato = 'ASSENTE'
    Dillo ('   ' + ($f.Nome + '.mq5').PadRight(31) + ' ASSENTE: nessun sorgente da mettere da parte (lo dichiaro e proseguo)') 'Yellow'
  }
  if($haX){ Dillo ('   ' + ($f.Nome + '.ex5').PadRight(31) + ' ' + (Get-Item -LiteralPath $pX).Length.ToString($INV) + ' byte  data ' + $dX + '  SHA256 ' + (Sha-File $pX).Substring(0,16) + '...') $null }
  else     { Dillo ('   ' + ($f.Nome + '.ex5').PadRight(31) + ' ASSENTE: nessun binario, quindi nessun grafico lo sta usando (lo dichiaro e proseguo)') 'Yellow' }

  if($stato -eq 'IGNOTO'){ Muori ($f.Nome + '.mq5 in campo NON e ne il pin 9fca63d9 (quello compilato il 20/09) ne la TrailFix: qualcuno lo ha cambiato. Non lo sovrascrivo a indovinare.') }
  if($stato -eq 'NUOVO' -and $haX -and ((Get-Item -LiteralPath $pX).LastWriteTime -ge (Get-Item -LiteralPath $pM).LastWriteTime)){
    Dillo ('   -> GIA FATTO: sorgente TrailFix e binario piu recente del sorgente. Non lo tocco.') 'Green'
    $giaFatti++
    continue
  }
  $f | Add-Member -NotePropertyName Stato -NotePropertyValue $stato -Force
  $f | Add-Member -NotePropertyName HaMq5 -NotePropertyValue $haM -Force
  $f | Add-Member -NotePropertyName HaEx5 -NotePropertyValue $haX -Force
  $daFare += $f
}
$abtg = @(Get-ChildItem -LiteralPath $dirE -File -ErrorAction SilentlyContinue | Where-Object { $_.Name -match '^ABTG_(DAX_Apertura_EU|Dow_Apertura_US|Nasdaq_Apertura_US)\.(mq5|ex5)$' })
foreach($a in $abtg){ Dillo ('   NOTA: su C:\FTMO c e anche ' + $a.Name + ' -- NON lo tocco: ricompilarlo non cambia il binario attaccato (CLAU12_).') 'Yellow' }

if($daFare.Count -eq 0){
  if($Esegui){ Fine 2 ('GIA FATTO: tutti e ' + $giaFatti + ' i file sono gia TrailFix e compilati. Nessuna scrittura.') 'Green' }
  Fine 2 ('GIA FATTO (prova a secco): tutti e ' + $giaFatti + ' i file sono gia TrailFix e compilati.') 'Green'
}

# =====================================================================
Titolo 'g) INCLUDE ABTG_PausaGuardian.mqh (si misura, NON si tocca)'
if(-not (Test-Path -LiteralPath $incP -PathType Leaf)){ Muori ('manca ' + $incP + ': senza include nessuna compilazione parte.') }
$ii = Impronta-Di $incP
$ib = Sha-File $incP
Dillo ('   righe ' + $ii.Righe + '  scheletro ' + $ii.Sha + '  SHA256 byte ' + $ib) $null
if($ii.Sha -eq $INC_SCH -and $ii.Righe -eq $INC_RIGHE){
  $nota = 'byte identici al pin 26a18566'
  if($ib -ne $INC_BYTE){ $nota = 'stesso testo del pin 26a18566, byte diversi (fine riga): innocuo per il compilatore' }
  Dillo ('   v1.20 (pin 26a18566), la stessa che ha compilato i binari in campo il 20/09 -- ' + $nota + ' : OK, non lo tocco') 'Green'
} elseif($ii.Sha -eq $INC_V16X_SCH) {
  Muori 'l include sul terminale e la v1.6x (2461 righe), NON la v1.20 che ha compilato i binari in campo il 20/09. Ricompilare adesso cambierebbe DUE cose insieme (TrailFix + include). Decide Claudio.'
} else {
  Muori 'l include sul terminale non e la v1.20 del 20/09 ne una versione nota. Ricompilare adesso cambierebbe DUE cose insieme. Decide Claudio.'
}

# =====================================================================
if(-not $Esegui){
  Titolo 'PROVA A SECCO: ecco cosa farei, e mi fermo qui'
  foreach($f in $daFare){
    if($f.HaMq5){ Dillo ('   copia di sicurezza ' + $f.Nome + '.mq5 -> ' + $f.Nome + '.mq5.PRIMA_TRAILFIX_<ora>') $null }
    if($f.HaEx5){ Dillo ('   copia di sicurezza ' + $f.Nome + '.ex5 -> ' + $f.Nome + '.ex5.PRIMA_TRAILFIX_<ora>') $null }
    Dillo ('   scrivo ' + $f.Nome + '.mq5 TrailFix (SHA256 ' + $f.ShaNuovo.Substring(0,16) + '...) e compilo con ' + $ME + '   sedie: ' + $f.Sedie) $null
  }
  Dillo '' $null
  Dillo '   NIENTE E STATO SCRITTO: ne nel terminale, ne sul Desktop.' 'Green'
  Dillo '   Per farlo davvero: -Esegui -Conferma NEUTRA (solo con R254 NEUTRA su 4/4 e la firma di Claudio).' 'Green'
  Fine 0 'PROVA A SECCO RIUSCITA: tutti i controlli passati, niente scritto.' 'Green'
}

# =====================================================================
#  DA QUI SI SCRIVE
# =====================================================================
[void](New-Item -ItemType Directory -Path $CARTREF -Force)
foreach($f in $FILE){
  if($f.PSObject.Properties['Byte']){ [IO.File]::WriteAllBytes((Join-Path $CARTREF ('scaricato_' + $f.Nome + '.mq5')), $f.Byte) }
}

Titolo 'h) COPIE DI SICUREZZA (copia verificata per SHA256, l originale resta al suo posto)'
$SUFF = '.PRIMA_TRAILFIX_' + $STAMPA
foreach($f in $daFare){
  $f | Add-Member -NotePropertyName BkMq5 -NotePropertyValue '' -Force
  $f | Add-Member -NotePropertyName BkEx5 -NotePropertyValue '' -Force
  $f | Add-Member -NotePropertyName ShaEx5Prima -NotePropertyValue '' -Force
  if($f.HaMq5){
    $bk = $f.PMq5 + $SUFF
    $b = Leggi-Byte $f.PMq5
    [IO.File]::WriteAllBytes($bk, $b)
    if((Sha-File $bk) -ne (Sha-Byte $b)){ Muori ('la copia di sicurezza ' + $bk + ' non ha lo SHA256 dell originale. Nessun originale toccato.') }
    $f.BkMq5 = $bk
    Dillo ('   ' + [IO.Path]::GetFileName($bk) + '   ' + $b.Length.ToString($INV) + ' byte  SHA256 ' + (Sha-Byte $b)) 'Green'
  } else { Dillo ('   ' + $f.Nome + '.mq5: ASSENTE, nessuna copia (dichiarato)') 'Yellow' }
  if($f.HaEx5){
    $bk = $f.PEx5 + $SUFF
    $b = Leggi-Byte $f.PEx5
    [IO.File]::WriteAllBytes($bk, $b)
    $hb = Sha-Byte $b
    if((Sha-File $bk) -ne $hb){ Muori ('la copia di sicurezza ' + $bk + ' non ha lo SHA256 dell originale. Nessun originale toccato.') }
    $f.BkEx5 = $bk
    $f.ShaEx5Prima = $hb
    Dillo ('   ' + [IO.Path]::GetFileName($bk) + '   ' + $b.Length.ToString($INV) + ' byte  SHA256 ' + $hb) 'Green'
  } else { Dillo ('   ' + $f.Nome + '.ex5: ASSENTE, nessuna copia (dichiarato)') 'Yellow' }
}
Dillo '   Le copie finiscono in .PRIMA_TRAILFIX_<ora>: il Navigatore di MT5 non le mostra (non sono .mq5/.ex5).' $null

# ---------------------------------------------------------------------
#  LA COMPILAZIONE -- schema di RIGA_DEPLOY_CONTOREALE.ps1 (provato su
#  questo VPS il 03/09): & exe ... | Out-Null fa ASPETTARE PowerShell
#  l uscita di MetaEditor; il verdetto NON e il codice d uscita ma il
#  .ex5 FRESCO piu la riga "Result:" del log (UTF-16) con 0 errori.
# ---------------------------------------------------------------------
function Compila([string]$mq5, [string]$ex5, [string]$log) {
  Remove-Item -LiteralPath $log -Force -ErrorAction SilentlyContinue
  $tC = Get-Date
  $argomenti = @(('/compile:' + $mq5), ('/inc:' + $dirM), ('/log:' + $log))
  Dillo ('   ' + $ME + ' ' + ($argomenti -join ' ')) $null
  Dillo '   (Se questa finestra resta FERMA qui per piu di 5 minuti, MetaEditor non e uscito: NON chiudere questa finestra.' 'Yellow'
  Dillo '    Gestione attivita -> chiudi SOLO metaeditor64.exe, MAI terminal64.exe. Lo script riprende da solo e decide: .ex5 non fresco = RIPRISTINO.)' 'Yellow'
  $global:LASTEXITCODE = $null
  & $ME @argomenti | Out-Null
  $rc = $LASTEXITCODE
  $muto = $false
  while($true){
    if((Test-Path -LiteralPath $ex5) -and ((Get-Item -LiteralPath $ex5).LastWriteTime -ge $tC)){ break }
    $r = @((Leggi-Testo $log) -split "`r`n|`n|`r")
    if((@($r | Where-Object { $_ -match 'Result:' })).Count -gt 0){ break }
    $sec = (New-TimeSpan -Start $tC -End (Get-Date)).TotalSeconds
    if(-not (Test-Path -LiteralPath $log) -and $sec -ge 20){ $muto = $true; break }
    if($sec -ge 180){ break }
    Start-Sleep -Seconds 2
  }
  Start-Sleep -Seconds 1
  $fresco = ((Test-Path -LiteralPath $ex5) -and ((Get-Item -LiteralPath $ex5).LastWriteTime -ge $tC))
  $logRighe = @((Leggi-Testo $log) -split "`r`n|`n|`r")
  $res = ''
  foreach($l in $logRighe){ if($l -match 'Result:'){ $res = $l.Trim() } }
  $err = -1; $war = -1
  $m1 = [regex]::Match($res, '(\d+)\s+error');   if($m1.Success){ $err = [int]::Parse($m1.Groups[1].Value, $INV) }
  $m2 = [regex]::Match($res, '(\d+)\s+warning'); if($m2.Success){ $war = [int]::Parse($m2.Groups[1].Value, $INV) }
  return [pscustomobject]@{ Avvio = $tC; Rc = $rc; Fresco = $fresco; Muto = $muto; Result = $res; Err = $err; War = $war; Righe = $logRighe }
}

function Ripristina($f) {
  Dillo ('   RIPRISTINO di ' + $f.Nome + ':') 'Yellow'
  if($f.BkMq5){
    $b = Leggi-Byte $f.BkMq5
    [IO.File]::WriteAllBytes($f.PMq5, $b)
    if((Sha-File $f.PMq5) -eq (Sha-Byte $b)){ Dillo ('     .mq5 rimesso dalla copia ' + [IO.Path]::GetFileName($f.BkMq5) + ' (SHA256 identico)') 'Green' }
    else { Dillo ('     .mq5 RIMESSO MA SHA256 DIVERSO dalla copia -- controllare a mano: ' + $f.BkMq5) 'Red' }
  } elseif(Test-Path -LiteralPath $f.PMq5) {
    $scarto = $f.PMq5 + '.TRAILFIX_FALLITO_' + $STAMPA
    Rename-Item -LiteralPath $f.PMq5 -NewName ([IO.Path]::GetFileName($scarto))
    Dillo ('     .mq5 prima non c era: quello nuovo e stato messo da parte come ' + [IO.Path]::GetFileName($scarto)) 'Yellow'
  }
  if($f.BkEx5){
    $ora = ''
    if(Test-Path -LiteralPath $f.PEx5){ $ora = Sha-File $f.PEx5 }
    if($ora -eq $f.ShaEx5Prima){ Dillo '     .ex5 INVARIATO (SHA256 uguale a prima): il binario in campo non e stato toccato.' 'Green' }
    else {
      $b = Leggi-Byte $f.BkEx5
      [IO.File]::WriteAllBytes($f.PEx5, $b)
      if((Sha-File $f.PEx5) -eq $f.ShaEx5Prima){ Dillo ('     .ex5 rimesso dalla copia ' + [IO.Path]::GetFileName($f.BkEx5) + ' (SHA256 identico). MT5 ricarichera il binario VECCHIO.') 'Green' }
      else { Dillo ('     .ex5 RIMESSO MA SHA256 DIVERSO -- controllare a mano: ' + $f.BkEx5) 'Red' }
    }
  } elseif(Test-Path -LiteralPath $f.PEx5) {
    $scarto = $f.PEx5 + '.TRAILFIX_FALLITO_' + $STAMPA
    Rename-Item -LiteralPath $f.PEx5 -NewName ([IO.Path]::GetFileName($scarto))
    Dillo ('     .ex5 prima non c era: quello prodotto e stato messo da parte come ' + [IO.Path]::GetFileName($scarto)) 'Yellow'
  }
}

Titolo 'i-j) SORGENTE NUOVO E COMPILAZIONE, un file per volta'
$fatti = @()
foreach($f in $daFare){
  Dillo '' $null
  Dillo ('-- ' + $f.Nome + '   sedie: ' + $f.Sedie) 'Cyan'
  $script:SCRITTO = $true
  $script:IN_CORSO = $f
  [IO.File]::WriteAllBytes($f.PMq5, $f.Byte)
  $hs = Sha-File $f.PMq5
  if($hs -ne $f.ShaNuovo){
    Ripristina $f
    Muori ($f.Nome + '.mq5 scritto con SHA256 ' + $hs + ' invece di ' + $f.ShaNuovo + '. Ripristinato. File gia fatti prima di questo: ' + $(if($fatti.Count){ $fatti -join ', ' } else { 'nessuno' }) + '.')
  }
  Dillo ('   sorgente scritto e riletto dal disco: SHA256 ' + $hs + ' : OK') 'Green'
  $log = Join-Path $CARTREF ('compila_' + $f.Nome + '.log')
  $c = Compila $f.PMq5 $f.PEx5 $log
  Dillo ('   avvio compilazione ' + $c.Avvio.ToString('yyyy-MM-dd HH:mm:ss', $INV) + '   rc ' + $c.Rc + '   ' + $(if($c.Result){ $c.Result } else { '(nessuna riga Result nel log)' })) $null
  $ok = ($c.Fresco -and $c.Err -eq 0)
  if(-not $ok){
    $perche = ''
    if($c.Muto){ $perche = 'MetaEditor MUTO: nessun log e nessun .ex5 in 20 s' }
    elseif($c.Err -gt 0){ $perche = ('' + $c.Err + ' errori (' + $c.Result + ')') }
    elseif(-not $c.Fresco){ $perche = '.ex5 NON prodotto dopo l avvio della compilazione (classe 270: un .ex5 vecchio non prova niente)' }
    elseif($c.Err -lt 0){ $perche = '.ex5 fresco ma riga Result non letta: non so quanti errori ci sono, e un boh vale come un no' }
    else { $perche = ('' + $c.Err + ' errori') }
    foreach($l in @($c.Righe | Where-Object { $_ -match 'error' } | Select-Object -First 15)){ Dillo ('     | ' + $l.Trim()) 'DarkYellow' }
    Ripristina $f
    Muori ('compilazione FALLITA di ' + $f.Nome + ': ' + $perche + '. Quel file e stato ripristinato. File gia fatti PRIMA di questo (restano TrailFix): ' + $(if($fatti.Count){ $fatti -join ', ' } else { 'nessuno' }) + '.')
  }
  $ex = Get-Item -LiteralPath $f.PEx5
  $f | Add-Member -NotePropertyName Ex5Data -NotePropertyValue ($ex.LastWriteTime.ToString('yyyy-MM-dd HH:mm:ss', $INV)) -Force
  Dillo ('   COMPILATO: ' + $f.Nome + '.ex5  ' + $ex.Length.ToString($INV) + ' byte  data ' + $f.Ex5Data + ' (dopo l avvio delle ' + $c.Avvio.ToString('HH:mm:ss', $INV) + ')  SHA256 ' + (Sha-File $f.PEx5)) 'Green'
  if($c.War -gt 0){ Dillo ('   ATTENZIONE: ' + $c.War + ' warning. Il binario e installato; manda lo zip col log prima di considerarlo chiuso.') 'Yellow' }
  $fatti += $f.Nome
  $script:IN_CORSO = $null
}

# =====================================================================
Stato-Finale

# =====================================================================
Titolo 'COSA RESTA DA FARE A MANO (e non lo fa questa riga)'
Dillo '   BERSAGLIO: azione a mano dentro MT5, terminale FTMO 541452707 (cartella programma C:\FTMO).' 'Yellow'
Dillo '   NON TOCCARE: REALE 10105439 (C:\BCM_Reale), 100k 50504263 (-V3), piccolo 50503392, manuale 50503635, banco 50504400, Pepperstone, Tickmill.' 'Yellow'
Dillo '   La finestra giusta e quella con Path = C:\FTMO\terminal64.exe nella tabella d) qui sopra.' 'Yellow'
Dillo '   1. Scheda Esperti: devono esserci QUATTRO righe "avviato su" NUOVE, con ora DOPO quella della compilazione' 'Yellow'
Dillo '      stampata sopra (tutte e due in ora Windows): due da CLAU12_DAX_Apertura_EU (770101 e 770105), una da' 'Yellow'
Dillo '      CLAU12_Dow_Apertura_US (770202), una da CLAU12_Nasdaq_Apertura_US (770260). E accanto QUATTRO "CONFIG IN USO".' 'Yellow'
Dillo '   2. Sui quattro grafici la faccina sorridente in alto a destra, e Algo Trading VERDE.' 'Yellow'
Dillo '   3. Se una riga "avviato su" manca: tasto destro su QUEL grafico -> Expert Advisors -> Proprieta -> OK' 'Yellow'
Dillo '      (rifa OnInit tenendo gli input). MAI "Ripristina", MAI rimuovere e riattaccare: perde la taratura.' 'Yellow'
Dillo '   4. Stanotte alle 03:30 la sonda CODA_06 rilegge le impronte: attese righe 2475 / 2255 / 2674 e .ex5 di oggi' 'Yellow'
Dillo '      (CODA_06 conta UNA riga in piu dello scheletro 2474 / 2254 / 2673: split senza TrimEnd, classe 456).' 'Yellow'
Dillo '   FINITO SENZA ERRORI DI SCRIPT NON VUOL DIRE IN CAMPO VERIFICATO: lo diventa col punto 1 e con CODA_06.' 'Yellow'

Fine 0 ('FATTO: ' + $fatti.Count + ' file ricompilati con la TrailFix (' + ($fatti -join ', ') + '), ' + $giaFatti + ' gia fatti prima. In campo: DA VERIFICARE in Esperti.') 'Green'

} catch {
  $msg = $_.Exception.Message
  try { Dillo '' $null; Dillo ('ERRORE IMPREVISTO: ' + $msg) 'Red' } catch { }
  if($script:SCRITTO){
    if($script:IN_CORSO){
      $fc = $script:IN_CORSO
      $script:IN_CORSO = $null
      try { Ripristina $fc } catch { try { Dillo ('RIPRISTINO NON RIUSCITO di ' + $fc.Nome + ': ' + $_.Exception.Message + ' -- NON toccare niente e manda lo zip: le copie .PRIMA_TRAILFIX_ sono in MQL5\Experts.') 'Red' } catch { } }
    }
    try { Stato-Finale } catch { }
    $script:CODICE = 3
    $script:ESITO = 'ERRORE IMPREVISTO DOPO AVER SCRITTO: ' + $msg + ' -- STATO MISTO possibile, vedi la tavola k) sopra: i file compilati PRIMA restano TrailFix, quello in corso e stato rimesso dalla sua copia (se sopra c e RIPRISTINO NON RIUSCITO, no), le copie .PRIMA_TRAILFIX_ sono in MQL5\Experts.'
  } else {
    $script:CODICE = 1
    $script:ESITO = 'ERRORE IMPREVISTO PRIMA DI TOCCARE GLI ORIGINALI: ' + $msg
  }
  try { Dillo ('ESITO: ' + $script:ESITO) 'Red'; Dillo ('USCITA: ' + $script:CODICE) 'Red' } catch { }
  Posa-Esito
  exit $script:CODICE
}
