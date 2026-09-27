# =====================================================================
#  MARCATORE_RICOMPILA_CLAU12_ORO_v1
#  RICOMPILA_CLAU12_ORO.ps1 -- porta il sorgente ABTG_MaxMinNotte.mq5
#  (pin 7d0da9f9, v1.11, 918 righe) sul terminale FTMO 541452707
#  (cartella programma C:\FTMO) col nome NUOVO CLAU12_MaxMinNotte.mq5
#  e lo compila con il SUO MetaEditor. E' la catena (b) della sedia
#  ORO solo LONG (report/SEDIA_ORO_LONG_FTMO_BOZZA_2026-09-27.md par.4).
#
#  STATO: BOZZA. Questa riga NON si lancia finche' Claudio non FIRMA.
#
#  SI LANCIA SOLO QUANDO:
#    1. R268 (tick reali) e R268d (22 anni) sono stati LETTI con esito
#       (PC di backtest DESKTOP-H4D7CAJ) -- niente "per analogia";
#    2. Claudio ha FIRMATO la compilazione (binario NUOVO su un conto
#       vivo della challenge);
#    3. e' SABATO o DOMENICA (ora Windows del VPS);
#    4. sul conto 541452707 NON c'e' nessuna posizione XAUUSD (scheda
#       Commercio guardata a occhio) e NESSUN EA oro attaccato;
#    5. le sedie oro sul piccolo 50503392 (770402 a due lati, 772343,
#       971501, 970901) e sul manuale 50503635 sono in PAUSA: blocco
#       FTMO cross-account (bozza par.8.4). Questo script NON apre
#       le altre cartelle dati: lo dichiara chi lancia.
#  I punti 1, 2, 4 (scheda Commercio) e 5 li dichiara chi lancia con
#  -Conferma PIATTO : lo script non li puo' verificare da solo, e lo
#  DICE. Il punto 4 lo MISURA per quello che il disco permette (chr e
#  giornale), vedi f2) ed f3).
#
#  QUESTA RIGA NON ATTACCA NIENTE: compila e basta. L'attacco della
#  sedia a un grafico XAUUSD e' il passo (d) della bozza, a mano, e
#  viene DOPO le risposte FTMO e la firma della taglia.
#
#  DIFFERENZA DAL MODELLO (RICOMPILA_CLAU12_TRAILFIX.ps1): li' si
#  RICOMPILANO tre file esistenti sotto tre sedie vive; qui il file e'
#  NUOVO. Quindi:
#    - i file ABTG_MaxMinNotte.mq5/.ex5 e CLAU12_MaxMinNotte.mq5/.ex5
#      NON DEVONO ESISTERE in MQL5\Experts di C:\FTMO. Se uno c'e',
#      STOP (niente sovrascritture: non e' una ricompilazione). Unica
#      eccezione: CLAU12_MaxMinNotte.mq5 GIA' col nostro scheletro e
#      .ex5 piu' recente del sorgente = GIA FATTO (uscita 2, niente
#      scritto): serve alla riga, che fa prova a secco + esecuzione;
#    - il "backup" h) non ha niente da copiare, e lo dice. Il RIPRISTINO
#      in caso di fallimento e' TOGLIERE il file appena scritto (messo
#      da parte come .ORO_FALLITO_<ora>, invisibile al Navigatore),
#      cosi' il disco torna com'era: senza CLAU12_MaxMinNotte;
#    - nessun grafico usa questo binario, quindi la compilazione non
#      ricarica nessuna sedia (CODA_01 27/09: 9 sedie su C:\FTMO,
#      nessuna su XAUUSD). Il weekend resta la finestra giusta: il
#      terminale ospita sedie vive e la regola vuole un'azione per volta.
#
#  IL NOME: RINOMINA_CLAU12.ps1 fa SOLO Rename-Item (misurato: nessuna
#  Set-Content/WriteAllText sui .mq5, r.48 del blocco [5/6]). Quindi il
#  contenuto NON cambia: #property, Print e la stringa
#  "ABTG_MaxMinNotte" passata al Guardian restano quelli del pin, e il
#  SHA256 dei byte di CLAU12_MaxMinNotte.mq5 e' lo STESSO del sorgente
#  al pin. Effetto collaterale cosmetico gia' misurato da RINOMINA: i
#  CSV di diario si chiameranno abtg_trades_CLAU12_MaxMinNotte_*.csv
#  (MQL_PROGRAM_NAME, r.835 e r.846 del sorgente).
#
#  COSA FA, in ordine (le lettere sono quelle del modello):
#    a) guardia macchina VMI3047753;
#    b) cartella dati FTMO per HASH 46C9F8E9FF0C747B2B5E09BCC13D5237 E
#       origin.txt = C:\FTMO E conto 541452707 nel giornale; e non deve
#       essere nessuna delle sette cartelle di casa. Altrimenti STOP;
#    c) giorno: se non e' sabato/domenica STOP, salvo -ForzaGiorno
#       (dichiarato a schermo e nell'ESITO; la riga NON lo passa);
#    d) Get-Process terminal64 stampato; metaeditor64 APERTO = STOP
#       (lezione del 22/08: con l'editor aperto /compile torna muto);
#    e) scarico del sorgente al -Pin (raw + cache-buster), SHA256 dei
#       BYTE confrontato con quello scritto qui, in MEMORIA; scheletro
#       918 / 32C692AD...; deve avere #include <ABTG_PausaGuardian.mqh>
#       e la chiamata a 2 argomenti ABTG_GuardiaIngresso(InpUsaGuardian,
#       "ABTG_MaxMinNotte"); e NESSUNA chiamata ABTG_*( fuori dalla
#       lista delle 12 funzioni della v1.20 (commenti tolti prima):
#       se ne chiama una, il sorgente vuole l'include a HEAD = STOP;
#    f) stato del disco: i 4 nomi (ABTG_/CLAU12_ x .mq5/.ex5) devono
#       essere ASSENTI (o GIA FATTO, vedi sopra);
#    f2) EA ORO ATTACCATO: i .chr del profilo attivo (config\*.ini ->
#       ProfileLast, come CODA_01) con symbol=XAUUSD e <expert> = STOP.
#       Grafici XAUUSD senza expert: dichiarati. Altri profili: residui,
#       dichiarati, non contati (se il profilo attivo non e' certo, si
#       contano TUTTI);
#    f3) GIORNALE: nei logs\ degli ultimi 7 giorni, righe XAUUSD che
#       parlano di deal/order/position = operativita' oro su questo
#       conto = STOP, salvo -IgnoraGiornaleOro (la riga NON lo passa:
#       Claudio deve guardare la scheda Commercio e rilanciare a mano).
#       Il disco NON dice se una posizione e' APERTA: questo e' il
#       massimo che si puo' misurare senza il terminale;
#    g) include ABTG_PausaGuardian.mqh: NON si tocca, si MISURA. Deve
#       essere la v1.20 (pin 26a18566, 398 righe, scheletro D179846B)
#       che ha compilato i binari in campo il 20/09. Diverso = STOP.
#       Se il compilatore la vuole diversa (errori su ABTG_/PausaGuardian
#       nel log), lo script si FERMA e lo DICE: aggiornare l'include e'
#       un'altra firma, non la fa questa riga;
#    h) backup: NIENTE da copiare (i file non esistono), dichiarato;
#    i) scrittura di CLAU12_MaxMinNotte.mq5, SHA256 riletto dal disco;
#    j) compilazione: C:\FTMO\metaeditor64.exe /compile /inc /log,
#       log UTF-16 letto, "0 errors" OBBLIGATORIO, .ex5 con data DOPO
#       l'avvio (classe 270). Se fallisce: il .mq5 (e il .ex5 se nato)
#       vengono messi da parte, STOP rosso, uscita 3;
#    k) impronta scheletro del sorgente in campo stampata (918 /
#       32C692AD...; CODA_06 stampera' 919, classe 456);
#    l) Desktop: RICOMPILA_CLAU12_ORO_<ts>\ (log + ESITO.txt + sorgente
#       scaricato) e lo zip accanto;
#    m) istruzione finale: Navigatore di C:\FTMO mostra
#       CLAU12_MaxMinNotte; NESSUN grafico da toccare.
#
#  COSA NON FA, per nome:
#    - NON tocca preset (.set), taglie, magic, input, profili, .chr;
#    - NON tocca ABTG_PausaGuardian.mqh (lo legge e basta);
#    - NON tocca le CLAU12 di C:\FTMO: CLAU12_Guardian (779001),
#      CLAU12_EMA200 (771531), CLAU12_SuperWave_DOW_H1_Ottimizzato
#      (770511), CLAU12_MaxMinNotte_DAX_Short_Ottimizzato (770411),
#      CLAU12_DAX_Apertura_EU (770101/770105), CLAU12_Dow_Apertura_US
#      (770202), CLAU12_Nasdaq_Apertura_US (770260), ne' i loro .ex5;
#    - NON tocca nessun ABTG_*.mq5/.ex5 eventualmente rimasto su C:\FTMO;
#    - NON apre, NON chiude, NON termina nessun processo MT5 (legge
#      soltanto Get-Process; l'unico processo che AVVIA e' metaeditor64
#      di C:\FTMO, una volta);
#    - NON apre le altre SEI cartelle dati del VPS: REALE 10105439
#      (C:\BCM_Reale), 100k 50504263 (-V3), piccolo 50503392 (BCM
#      Markets MT5 Terminal), manuale 50503635 (C:\MT5_MANUALE), banco
#      50504400 (C:\MT5_Backtest), Pepperstone, Tickmill;
#    - NON attacca e NON stacca EA, NON tocca Algo Trading.
#  Scrive SOLO in <cartella dati di C:\FTMO>\MQL5\Experts (1 .mq5, 1
#  .ex5 via MetaEditor) e sul Desktop del VPS.
#
#  PROVA A SECCO (senza -Esegui): fa a-g, stampa quello che farebbe e
#  NON SCRIVE NIENTE, nemmeno sul Desktop (lo scarico sta in memoria).
#
#  [NON VERIFICATO], in un posto solo:
#    - la compilazione di ABTG_MaxMinNotte.mq5 @7d0da9f9 (03/09) contro
#      l'include v1.20 (19/08) non e' MAI stata fatta: la forma c'e'
#      (chiamata a 2 argomenti, firma v1.20 r.282 a 2+1 argomenti con
#      default), il "0 errors" lo dice solo MetaEditor;
#    - la posizione XAUUSD aperta sul conto NON e' leggibile dal disco:
#      f2/f3 misurano chr e giornale, il resto lo dichiara Claudio;
#    - lo script e' collaudato su Linux (pwsh 7) con un MetaEditor
#      finto e un albero simulato, non su Windows PowerShell 5.1 e non
#      con il MetaEditor vero.
#
#  USCITE: 0 fatto (o prova a secco riuscita) . 1 rifiuto, NIENTE
#  scritto nel terminale . 2 gia fatto . 3 fallito DOPO aver scritto
#  (con file messi da parte: leggere l'ESITO).
#
#  ASCII PURO: niente emoji, niente accentate (PS 5.1 legge i .ps1
#  come ANSI -- regola di casa del 17/08).
# =====================================================================

param(
  [Parameter(Mandatory=$true)][string]$Pin,
  [switch]$Esegui,
  [string]$Conferma = '',
  [switch]$ForzaGiorno,
  [switch]$IgnoraGiornaleOro
)

$ErrorActionPreference = 'Stop'
$INV = [Globalization.CultureInfo]::InvariantCulture
try { [Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12 } catch { }
$T0 = Get-Date
$STAMPA = $T0.ToString('yyyyMMdd_HHmmss', $INV)

# ---------------------------------------------------------------------
#  COSTANTI. Misurate il 27/09/2026 con git sul repo, branch lavoro:
#    git show 7d0da9f9:mql5/Experts/ABTG_MaxMinNotte.mq5 | sha256sum
#    scheletro = stessa funzione di RINOMINA_CLAU12.ps1 (riprodotta in
#    Python e controllata sui due file gia' in tavola: tornano al byte).
#    HEAD (d27b81b4) == pin 7d0da9f9 su questo file: diff vuoto.
# ---------------------------------------------------------------------
$MACCHINA = 'VMI3047753'
$HD       = '46C9F8E9FF0C747B2B5E09BCC13D5237'
$PROG     = 'C:\FTMO'
$CONTO    = '541452707'
$RAWROOT  = 'https://raw.githubusercontent.com/claudiospadaro12/GITHUB/'
$REL_SRC  = 'mql5/Experts/ABTG_MaxMinNotte.mq5'
$PIN_ATTESO = '7d0da9f94ae7ae5834a1664d46738ebb87ada2e1'

$NOME_VECCHIO = 'ABTG_MaxMinNotte'
$NOME_NUOVO   = 'CLAU12_MaxMinNotte'
$SEDIA        = 'ORO solo LONG  XAUUSD H2  (magic e taglia: firma di Claudio, NON in questa riga)'
$SRC_SHA   = '9346F16A4CAAD4CF18EE9B772CAF06A497B3C6727E0D0B65250E377E75BFAE80'
$SRC_RIGHE = 918
$SRC_SCH   = '32C692ADD267DD4FA9C500281C2427F5306B1F961AFD1315E867D4B6D717146D'
$FIRMA_INC  = '#include <ABTG_PausaGuardian.mqh>'
$FIRMA_CALL = 'ABTG_GuardiaIngresso(InpUsaGuardian,"ABTG_MaxMinNotte")'

# L'include in campo: v1.20 al pin 26a18566, installato da SCHIERA_FTMO.ps1
# il 20/09 (report/SCHIERAMENTO_FTMO_2026-09-20.md par.5.1). Si misura e
# non si tocca. Le 12 funzioni che ESPORTA (git show 26a18566:... | grep):
# ogni chiamata ABTG_*( del sorgente deve stare in questa lista.
$INC_RIGHE = 398
$INC_SCH   = 'D179846B407FDACC963825103F850E8F8BEE39B1DA3521A504EF74F8638AC8BC'
$INC_BYTE  = '83F19640CC21C0C9AB5AB6E7BF108F0190A12995E67FBA0F38D8C5A8A98DD5E2'
$INC_V16X_SCH = 'E9F503F581265A00E4389E8482A18FB9244AA53529A9969CA358137E39EF344C'
$INC_FUNZ = @('ABTG_CanaleEsiste','ABTG_CapAttivo_Calc','ABTG_GuardiaIngresso','ABTG_GuardianVivo_Calc',
              'ABTG_PausaAttiva_Calc','ABTG_PuoAprire','ABTG_GVLeggi','ABTG_AutotestCaso',
              'ABTG_AutotestGuardia','ABTG_MotivoStop_Calc','ABTG_GVNome','ABTG_MotivoTesto')

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

# Lettura condivisa (copiata da RICOMPILA_CLAU12_TRAILFIX.ps1): il file
# puo' essere tenuto aperto dal terminale. Riconosce UTF-16 (log di
# MetaEditor, .chr).
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
# Campo di un .chr (copiata da CODA_01_sedie_attaccate.ps1).
function Campo($txt, $chiave) {
  $m = [regex]::Match($txt, '(?im)^[ \t]*' + [regex]::Escape($chiave) + '[ \t]*=[ \t]*(.*?)[ \t]*$')
  if($m.Success -and $m.Groups[1].Value.Trim().Length -gt 0){ return $m.Groups[1].Value.Trim() }
  return '-'
}

# Desktop con ripiego (stesso di RINOMINA_CLAU12.ps1 / riga del preset).
$DESKTOP = ''
try { $DESKTOP = [Environment]::GetFolderPath('Desktop') } catch { $DESKTOP = '' }
if(-not $DESKTOP -or -not (Test-Path -LiteralPath $DESKTOP)){ $DESKTOP = Join-Path $env:USERPROFILE 'Desktop' }
if(-not (Test-Path -LiteralPath $DESKTOP)){ $DESKTOP = $env:USERPROFILE }
$CARTREF = Join-Path $DESKTOP ('RICOMPILA_CLAU12_ORO_' + $STAMPA)
$ZIP     = $CARTREF + '.zip'

$ESITO   = 'FERMATO PRIMA DI SCRIVERE'
$CODICE  = 1
$SCRITTO = $false
$IN_CORSO = $null
$PMq5 = ''
$PEx5 = ''

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
    Write-Host ('   ATTESI: ESITO.txt sempre; compila_' + $NOME_NUOVO + '.log se si e arrivati alla compilazione; scaricato_' + $NOME_VECCHIO + '.mq5.') -ForegroundColor Cyan
    Write-Host ('MANDA IN CHAT QUESTO FILE: ' + $ZIP) -ForegroundColor Cyan
  } catch { Write-Host ('ESITO/zip NON scritti sul Desktop: ' + $_.Exception.Message + ' -- fai una foto di questa finestra.') -ForegroundColor Red }
}

function Stato-Finale {
  Titolo 'k) STATO DEL DISCO ORA (per il referto e per CODA_06)'
  if(-not $script:PMq5){ Dillo '   (cartella Experts non ancora certificata: niente da leggere)' 'Yellow'; return }
  if(Test-Path -LiteralPath $script:PMq5 -PathType Leaf){
    $imp = Impronta-Di $script:PMq5
    $st = 'NON E IL SORGENTE DEL PIN'
    if($imp.Sha -eq $SRC_SCH -and $imp.Righe -eq $SRC_RIGHE){ $st = 'sorgente del pin 7d0da9f9' }
    $dx = 'ASSENTE'
    if(Test-Path -LiteralPath $script:PEx5 -PathType Leaf){ $dx = (Get-Item -LiteralPath $script:PEx5).LastWriteTime.ToString('yyyy-MM-dd HH:mm:ss', $INV) }
    Dillo ('   ' + ($NOME_NUOVO + '.mq5').PadRight(31) + ' righe ' + $imp.Righe + '  scheletro ' + $imp.Sha + '  -> ' + $st + '   .ex5 ' + $dx) $(if($st -eq 'sorgente del pin 7d0da9f9'){ 'Green' } else { 'Red' })
    Dillo '   (CODA_06 stampera 919 righe: conta UNA riga in piu dello scheletro 918, split senza TrimEnd, classe 456)' $null
  } else {
    Dillo ('   ' + ($NOME_NUOVO + '.mq5').PadRight(31) + ' ASSENTE') 'Yellow'
    if(Test-Path -LiteralPath $script:PEx5 -PathType Leaf){ Dillo ('   ' + ($NOME_NUOVO + '.ex5').PadRight(31) + ' PRESENTE SENZA SORGENTE -- controllare a mano') 'Red' }
    else { Dillo ('   ' + ($NOME_NUOVO + '.ex5').PadRight(31) + ' ASSENTE') 'Yellow' }
  }
  $residui = @(Get-ChildItem -LiteralPath (Split-Path -Parent $script:PMq5) -File -ErrorAction SilentlyContinue | Where-Object { $_.Name -like ($NOME_NUOVO + '.*.ORO_FALLITO_*') })
  foreach($r in $residui){ Dillo ('   messo da parte: ' + $r.Name + '  (' + $r.Length.ToString($INV) + ' byte) -- invisibile al Navigatore, si puo cancellare a mano') 'Yellow' }
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
    Fine 3 ('FERMATO DOPO AVER SCRITTO -- vedi la tavola k) qui sopra: il file scritto e stato messo da parte (.ORO_FALLITO_<ora>), il Navigatore NON mostra ' + $NOME_NUOVO + '. Nessuna sedia toccata. ' + $msg) 'Red'
  }
  Fine 1 ('RIFIUTO, nel terminale NON e stato scritto niente -- ' + $msg) 'Red'
}

# Il RIPRISTINO: qui non c'era niente prima, quindi ripristinare = TOGLIERE.
# Si mette da parte, non si cancella (schema del ramo "prima non c'era" di
# RICOMPILA_CLAU12_TRAILFIX.ps1 r.572-575 e r.587-590).
function Ripristina {
  Dillo ('   RIPRISTINO di ' + $NOME_NUOVO + ' (il disco torna SENZA questo file):') 'Yellow'
  foreach($p in @($script:PMq5, $script:PEx5)){
    if(-not $p){ continue }
    if(Test-Path -LiteralPath $p -PathType Leaf){
      $scarto = $p + '.ORO_FALLITO_' + $STAMPA
      Rename-Item -LiteralPath $p -NewName ([IO.Path]::GetFileName($scarto))
      if(Test-Path -LiteralPath $p -PathType Leaf){ Dillo ('     ' + [IO.Path]::GetFileName($p) + ' ANCORA PRESENTE dopo la rinomina -- controllare a mano') 'Red' }
      else { Dillo ('     ' + [IO.Path]::GetFileName($p) + ' messo da parte come ' + [IO.Path]::GetFileName($scarto)) 'Green' }
    } else {
      Dillo ('     ' + [IO.Path]::GetFileName($p) + ' non c e: niente da togliere') $null
    }
  }
}

# =====================================================================
try {
Dillo '=====================================================================' 'Cyan'
Dillo (' RICOMPILA CLAU12 ORO -- terminale FTMO 541452707 (C:\FTMO): ' + $NOME_VECCHIO + '.mq5 -> ' + $NOME_NUOVO + '.mq5 + .ex5') 'Cyan'
Dillo '=====================================================================' 'Cyan'
Dillo (' ora Windows del VPS : ' + $T0.ToString('yyyy-MM-dd HH:mm:ss dddd', $INV)) $null
Dillo (' pin del sorgente    : ' + $Pin) $null
Dillo (' sedia               : ' + $SEDIA) $null
if($Esegui){ Dillo ' MODO                : ESEGUI (scrive il sorgente nuovo e compila; NON attacca niente)' 'Yellow' }
else       { Dillo ' MODO                : PROVA A SECCO -- non scrive NIENTE, nemmeno sul Desktop' 'Green' }
Dillo ' BERSAGLIO: SOLO la cartella dati del terminale FTMO 541452707 (C:\FTMO), MQL5\Experts, piu il Desktop di questo VPS.' 'Yellow'
Dillo ' NON TOCCATI: REALE 10105439 (C:\BCM_Reale), 100k 50504263 (-V3), piccolo 50503392 (BCM Markets MT5 Terminal), manuale 50503635 (C:\MT5_MANUALE), banco 50504400 (C:\MT5_Backtest), Pepperstone, Tickmill; su C:\FTMO: preset, taglie, Guardian, le sette CLAU12 gia in campo e i loro .ex5, include.' 'Yellow'

if($Pin -notmatch '^[0-9a-f]{40}$'){ Muori ('-Pin deve essere un commit di 40 caratteri esadecimali minuscoli. Ricevuto: ' + $Pin) }
if($Pin -ne $PIN_ATTESO){ Muori ('-Pin ' + $Pin + ' NON e il pin del sorgente misurato (' + $PIN_ATTESO + '). Lo SHA256 scritto qui vale per quello: un altro pin e un altro lavoro.') }

# --- conferma di Claudio: SOLO per -Esegui ---------------------------
if($Esegui){
  if($Conferma -cne 'PIATTO'){
    Muori ('-Esegui richiede -Conferma PIATTO (maiuscolo, esatto): e la dichiarazione di chi lancia che (1) R268 e R268d sono stati letti, (2) Claudio ha firmato, (3) nella scheda Commercio del terminale FTMO 541452707 NON c e nessuna posizione XAUUSD, (4) le sedie oro del piccolo 50503392 e del manuale 50503635 sono in pausa. Ricevuto: [' + $Conferma + ']. Questo script NON puo verificarlo da solo.')
  }
  Dillo ' CONFERMA            : PIATTO (dichiarata da chi lancia, non verificata dallo script: R268 letti, firma, nessuna posizione XAUUSD, sedie oro di casa in pausa)' 'Yellow'
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
$logRecenti = @()
if(Test-Path -LiteralPath $lg){
  foreach($x in @(Get-ChildItem -LiteralPath $lg -Filter *.log -ErrorAction SilentlyContinue | Sort-Object LastWriteTime -Descending | Select-Object -First 10)){ $txt += (Leggi-Testo $x.FullName); $nl++; $logRecenti += $x }
}
if($txt -notmatch ('(?<![0-9])' + $CONTO + '(?![0-9])')){ Muori ('nei ' + $nl + ' giornali piu recenti (logs) non trovo il conto ' + $CONTO + ': non la certifico come FTMO.') }
Dillo ('   giornale: conto ' + $CONTO + ' trovato in ' + $nl + ' file di logs : OK') 'Green'
$dirE = Join-Path $dati 'MQL5\Experts'
$dirM = Join-Path $dati 'MQL5'
$incP = Join-Path $dati 'MQL5\Include\ABTG_PausaGuardian.mqh'
$ME   = Join-Path $PROG 'metaeditor64.exe'
if(-not (Test-Path -LiteralPath $dirE -PathType Container)){ Muori ('non esiste ' + $dirE) }
if(-not (Test-Path -LiteralPath $ME -PathType Leaf)){ Muori ('non esiste ' + $ME + ': senza il MetaEditor di C:\FTMO non si compila (e non se ne usa un altro apposta).') }
$script:PMq5 = Join-Path $dirE ($NOME_NUOVO + '.mq5')
$script:PEx5 = Join-Path $dirE ($NOME_NUOVO + '.ex5')
Dillo ('   si scrive SOLO in: ' + $dirE) 'Green'
Dillo ('   compilatore      : ' + $ME) 'Green'

# =====================================================================
Titolo 'c) GIORNO'
$dow = $T0.DayOfWeek
if($dow -eq [DayOfWeek]::Saturday -or $dow -eq [DayOfWeek]::Sunday){
  Dillo ('   oggi e ' + $dow + ' (ora Windows del VPS): mercati chiusi. Il binario e NUOVO e nessun grafico lo usa, ma la regola vuole un azione per volta su un terminale con sedie vive.') 'Green'
} else {
  Dillo ('   OGGI E ' + $dow + ': le sedie di C:\FTMO possono essere operative e l oro e aperto.') 'Red'
  if(-not $ForzaGiorno){ Muori ('giorno feriale (' + $dow + '). Rilancia sabato o domenica, oppure con -ForzaGiorno dopo aver VERIFICATO a occhio la scheda Commercio (la riga NON lo passa).') }
  Dillo '   -ForzaGiorno PASSATO: chi lancia dichiara di aver verificato la scheda Commercio.' 'Yellow'
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
  Dillo '   Il terminale FTMO (C:\FTMO) e ACCESO. Va bene: il binario e NUOVO, nessun grafico lo usa, niente viene ricaricato.' 'Yellow'
  Dillo ('   A fine compilazione il Navigatore mostrera ' + $NOME_NUOVO + ' (se non compare: tasto destro sul Navigatore -> Aggiorna).') 'Yellow'
} else {
  Dillo '   Il terminale FTMO (C:\FTMO) risulta CHIUSO: il Navigatore vedra il binario nuovo alla prossima apertura.' 'Yellow'
}
$edAperti = @(Get-Process metaeditor64 -ErrorAction SilentlyContinue)
if($edAperti.Count -gt 0){
  foreach($p in $edAperti){ $pp = ''; try { $pp = $p.Path } catch { }; Dillo ('   metaeditor64 APERTO: PID ' + $p.Id + '  ' + $pp) 'Red' }
  Muori 'MetaEditor e aperto. Con l editor aperto la compilazione da riga di comando puo tornare senza compilare niente (lezione del 22/08). Chiudi MetaEditor (SOLO MetaEditor, non i terminali) e rilancia.'
}
Dillo '   metaeditor64: nessuno aperto : OK' 'Green'

# =====================================================================
Titolo 'e) SORGENTE AL PIN (scarico in memoria, SHA256 dei byte, forma della chiamata al Guardian)'
$wc = New-Object Net.WebClient
$url = $RAWROOT + $Pin + '/' + $REL_SRC + '?cb=' + [Guid]::NewGuid().ToString('N')
$SRC_BYTE = $null
try { $SRC_BYTE = $wc.DownloadData($url) } catch { Muori ('scarico fallito: ' + $REL_SRC + ' al pin ' + $Pin + ' -- ' + $_.Exception.Message + '. Un 404 vuol dire pin sbagliato.') }
if($null -eq $SRC_BYTE -or $SRC_BYTE.Length -eq 0){ Muori ('scaricato VUOTO: ' + $REL_SRC) }
$h = Sha-Byte $SRC_BYTE
if($h -ne $SRC_SHA){ Muori ('IMPRONTA DIVERSA su ' + $REL_SRC + ' al pin ' + $Pin + ': attesa ' + $SRC_SHA + ', trovata ' + $h + '.') }
$SRC_TXT = Testo-Da-Byte $SRC_BYTE
$sc = Scheletro $SRC_TXT
if($sc.Sha -ne $SRC_SCH -or $sc.Righe -ne $SRC_RIGHE){ Muori ($REL_SRC + ': SHA256 giusto ma scheletro diverso (' + $sc.Righe + ' righe, ' + $sc.Sha + '): la funzione di impronta e cambiata.') }
if($SRC_TXT.IndexOf($FIRMA_INC, [StringComparison]::Ordinal) -lt 0){ Muori ('il sorgente NON contiene [' + $FIRMA_INC + ']: non e il file che conosco.') }
if($SRC_TXT.IndexOf($FIRMA_CALL, [StringComparison]::Ordinal) -lt 0){ Muori ('il sorgente NON contiene la chiamata a 2 argomenti [' + $FIRMA_CALL + ']: la forma che la v1.20 accetta (r.282) non c e.') }
# Le chiamate ABTG_*( con i commenti TOLTI (i commenti citano
# ABTG_ORB_Ottimizzato (ramo ... e sarebbero falsi positivi).
$senzaCommenti = [regex]::Replace($SRC_TXT, '(?s)/\*.*?\*/', ' ')
$senzaCommenti = [regex]::Replace($senzaCommenti, '(?m)//.*$', '')
$chiamate = @()
foreach($m in [regex]::Matches($senzaCommenti, 'ABTG_[A-Za-z0-9_]+(?=\s*\()')){ if($chiamate -notcontains $m.Value){ $chiamate += $m.Value } }
$fuori = @()
foreach($c in $chiamate){ if($INC_FUNZ -notcontains $c){ $fuori += $c } }
if($fuori.Count -gt 0){ Muori ('il sorgente chiama funzioni che l include v1.20 in campo NON ha: ' + ($fuori -join ', ') + '. Vorrebbe l include a HEAD: NON si aggiorna l include con questa riga (e un altra firma). Fermo prima di scrivere.') }
Dillo ('   ' + $REL_SRC + '  SHA256 ' + $h) 'Green'
Dillo ('   righe ' + $sc.Righe + '  scheletro ' + $sc.Sha + '  (atteso 918 / 32C692AD...)') 'Green'
Dillo ('   include: ' + $FIRMA_INC + ' : presente') 'Green'
Dillo ('   chiamate ABTG_*( fuori dai commenti: ' + ($chiamate -join ', ') + '  -> tutte nella v1.20 : OK') 'Green'

# =====================================================================
Titolo 'f) STATO DEI FILE IN CAMPO (devono essere ASSENTI: e un binario NUOVO)'
$nomi = @(($NOME_VECCHIO + '.mq5'), ($NOME_VECCHIO + '.ex5'), ($NOME_NUOVO + '.mq5'), ($NOME_NUOVO + '.ex5'))
$presenti = @()
foreach($n in $nomi){
  $p = Join-Path $dirE $n
  if(Test-Path -LiteralPath $p -PathType Leaf){
    $it = Get-Item -LiteralPath $p
    $presenti += $n
    Dillo ('   ' + $n.PadRight(31) + ' PRESENTE  ' + $it.Length.ToString($INV) + ' byte  data ' + $it.LastWriteTime.ToString('yyyy-MM-dd HH:mm:ss', $INV) + '  SHA256 ' + (Sha-File $p).Substring(0,16) + '...') 'Yellow'
  } else {
    Dillo ('   ' + $n.PadRight(31) + ' assente : OK') 'Green'
  }
}
if($presenti.Count -gt 0){
  # L'unica forma ammessa: GIA FATTO da una corsa precedente di questa stessa riga.
  $giaFatto = $false
  if(($presenti.Count -eq 2) -and ($presenti -contains ($NOME_NUOVO + '.mq5')) -and ($presenti -contains ($NOME_NUOVO + '.ex5'))){
    $imp = Impronta-Di $script:PMq5
    if($imp.Sha -eq $SRC_SCH -and $imp.Righe -eq $SRC_RIGHE -and ((Get-Item -LiteralPath $script:PEx5).LastWriteTime -ge (Get-Item -LiteralPath $script:PMq5).LastWriteTime)){ $giaFatto = $true }
  }
  if($giaFatto){
    Dillo ('   ' + $NOME_NUOVO + '.mq5 ha lo scheletro del pin 7d0da9f9 e il .ex5 e piu recente del sorgente.') 'Green'
    Fine 2 ('GIA FATTO: ' + $NOME_NUOVO + ' e gia sul terminale, compilato dal sorgente del pin. Nessuna scrittura.') 'Green'
  }
  Muori ('in ' + $dirE + ' esistono gia: ' + ($presenti -join ', ') + '. Questa riga crea un file NUOVO e non sovrascrive niente: prima si chiarisce con Claudio cosa sono (CODA_06 del 27/09 non li vedeva).')
}

# =====================================================================
Titolo 'f2) EA ORO ATTACCATO? (i .chr del profilo attivo, come CODA_01; sola lettura)'
$chartsRoot = Join-Path $dati 'MQL5\Profiles\Charts'
$profili = @()
if(Test-Path -LiteralPath $chartsRoot){ $profili = @(Get-ChildItem -LiteralPath $chartsRoot -Directory -ErrorAction SilentlyContinue) }
$profAttivo = ''
$cfgDir = Join-Path $dati 'config'
if(Test-Path -LiteralPath $cfgDir){
  foreach($f in @(Get-ChildItem -LiteralPath $cfgDir -Filter '*.ini' -ErrorAction SilentlyContinue | Sort-Object Name)){
    if($profAttivo){ break }
    $t = Leggi-Testo $f.FullName
    if(-not $t){ continue }
    $m = [regex]::Match($t, '(?im)^[ \t]*(ProfileLast|LastProfile|CurrentProfile|ProfileName|Profile)[ \t]*=[ \t]*(.+?)[ \t]*$')
    if($m.Success){
      $val = $m.Groups[2].Value.Trim()
      foreach($p in $profili){ if($p.Name -ieq $val){ $profAttivo = $p.Name; Dillo ('   profilo attivo: ' + $profAttivo + '   [CONFIG] config\' + $f.Name + ' -> ' + $m.Groups[1].Value + '=' + $val) $null } }
    }
  }
}
if(-not $profAttivo){ Dillo ('   profilo attivo NON certo dai config: per prudenza conto TUTTI i ' + $profili.Count + ' profili come attivi.') 'Yellow' }
$oroVivi = @()
$oroSenzaEa = @()
$oroResidui = @()
foreach($p in $profili){
  $attivo = ((-not $profAttivo) -or ($p.Name -ieq $profAttivo))
  foreach($x in @(Get-ChildItem -LiteralPath $p.FullName -Filter 'chart*.chr' -ErrorAction SilentlyContinue)){
    $t = Leggi-Testo $x.FullName
    if(-not $t){ continue }
    $sym = Campo $t 'symbol'
    if($sym -notmatch '(?i)^XAU'){ continue }
    $iE = $t.IndexOf('<expert>', [StringComparison]::OrdinalIgnoreCase)
    $ea = '-'
    if($iE -ge 0){ $ea = Campo ($t.Substring($iE)) 'name' }
    $riga = ($sym + '  ' + $p.Name + '\' + $x.Name + '  expert: ' + $ea)
    if($iE -lt 0 -or $ea -eq '-' -or $ea -ieq 'Main'){ if($attivo){ $oroSenzaEa += $riga }; continue }
    if($attivo){ $oroVivi += $riga } else { $oroResidui += $riga }
  }
}
foreach($r in $oroVivi){ Dillo ('   EA SU GRAFICO ORO (profilo attivo): ' + $r) 'Red' }
foreach($r in $oroSenzaEa){ Dillo ('   grafico oro senza EA (profilo attivo): ' + $r + '  -- dichiarato, non blocca') 'Yellow' }
foreach($r in $oroResidui){ Dillo ('   residuo in altro profilo (non contato): ' + $r) 'Yellow' }
if($oroVivi.Count -gt 0){ Muori ('sul terminale FTMO c e gia ' + $oroVivi.Count + ' EA attaccato a un grafico oro. La bozza dice: nessun EA oro su 541452707 prima di questa compilazione (CODA_01 27/09: nessuno). Prima si chiarisce con Claudio.') }
Dillo ('   nessun EA su grafici oro nel profilo attivo (letti ' + $profili.Count + ' profili) : OK') 'Green'

# =====================================================================
Titolo 'f3) GIORNALE: operativita XAUUSD negli ultimi 7 giorni? (sola lettura di logs\)'
$soglia = $T0.AddDays(-7)
$righeOro = @()
foreach($x in $logRecenti){
  $dFile = $x.LastWriteTime
  $mm = [regex]::Match($x.Name, '^(\d{4})(\d{2})(\d{2})\.log$')
  if($mm.Success){ try { $dFile = New-Object DateTime ([int]$mm.Groups[1].Value), ([int]$mm.Groups[2].Value), ([int]$mm.Groups[3].Value) } catch { } }
  if($dFile -lt $soglia){ continue }
  foreach($l in @((Leggi-Testo $x.FullName) -split "`r`n|`n|`r")){
    if($l -notmatch 'XAUUSD'){ continue }
    if($l -match '(?i)(deal #|order #|position #|market buy|market sell|buy stop|sell stop|buy limit|sell limit|\bbuy [0-9]|\bsell [0-9])'){ $righeOro += ($x.Name + ': ' + $l.Trim()) }
  }
}
if($righeOro.Count -gt 0){
  foreach($l in @($righeOro | Select-Object -Last 12)){ Dillo ('   | ' + $l) 'DarkYellow' }
  Dillo ('   ' + $righeOro.Count + ' righe XAUUSD di deal/ordine/posizione negli ultimi 7 giorni: su questo conto qualcuno ha operato oro.') 'Red'
  Dillo '   Il disco NON dice se una posizione e ancora APERTA: lo dice solo la scheda Commercio del terminale.' 'Red'
  if(-not $IgnoraGiornaleOro){ Muori 'operativita XAUUSD recente sul conto 541452707. Guarda la scheda Commercio del terminale FTMO (C:\FTMO): se NON c e nessuna posizione XAUUSD, rilancia a mano con -IgnoraGiornaleOro (la riga NON lo passa).' }
  Dillo '   -IgnoraGiornaleOro PASSATO: chi lancia dichiara di aver guardato la scheda Commercio e che non c e nessuna posizione XAUUSD.' 'Yellow'
} else {
  Dillo ('   nessuna riga XAUUSD di deal/ordine/posizione nei giornali degli ultimi 7 giorni : OK (una posizione APERTA da piu di 7 giorni resterebbe invisibile qui: la dichiara -Conferma PIATTO)') 'Green'
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
  Muori 'l include sul terminale e la v1.6x (2461 righe), NON la v1.20 che ha compilato i binari in campo il 20/09. Compilare adesso legherebbe la sedia nuova a un include diverso da quello delle altre sette. Decide Claudio.'
} else {
  Muori 'l include sul terminale non e la v1.20 del 20/09 ne una versione nota. Non compilo contro un include che non conosco. Decide Claudio.'
}

# =====================================================================
if(-not $Esegui){
  Titolo 'PROVA A SECCO: ecco cosa farei, e mi fermo qui'
  Dillo ('   h) copie di sicurezza: NIENTE da copiare (i quattro nomi sono assenti, misurato in f)') $null
  Dillo ('   i) scrivo ' + $script:PMq5 + ' con i byte del pin (SHA256 ' + $SRC_SHA.Substring(0,16) + '..., identico a ' + $NOME_VECCHIO + '.mq5: RINOMINA_CLAU12 non cambia il contenuto)') $null
  Dillo ('   j) compilo con ' + $ME + ' contro l include v1.20 misurato in g)   sedia: ' + $SEDIA) $null
  Dillo '' $null
  Dillo '   NIENTE E STATO SCRITTO: ne nel terminale, ne sul Desktop.' 'Green'
  Dillo '   Per farlo davvero: -Esegui -Conferma PIATTO (solo con R268/R268d letti e la firma di Claudio).' 'Green'
  Fine 0 'PROVA A SECCO RIUSCITA: tutti i controlli passati, niente scritto.' 'Green'
}

# =====================================================================
#  DA QUI SI SCRIVE
# =====================================================================
[void](New-Item -ItemType Directory -Path $CARTREF -Force)
[IO.File]::WriteAllBytes((Join-Path $CARTREF ('scaricato_' + $NOME_VECCHIO + '.mq5')), $SRC_BYTE)

Titolo 'h) COPIE DI SICUREZZA'
Dillo ('   NIENTE da copiare: ' + ($nomi -join ', ') + ' sono assenti (misurato in f). Il ripristino, se serve, e TOGLIERE il file scritto.') 'Green'

# ---------------------------------------------------------------------
#  LA COMPILAZIONE -- copiata da RICOMPILA_CLAU12_TRAILFIX.ps1 (schema di
#  RIGA_DEPLOY_CONTOREALE.ps1, provato sul VPS il 03/09): & exe ... |
#  Out-Null fa ASPETTARE PowerShell l uscita di MetaEditor; il verdetto
#  NON e il codice d uscita ma il .ex5 FRESCO piu la riga "Result:" del
#  log (UTF-16) con 0 errori.
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

Titolo 'i-j) SORGENTE NUOVO E COMPILAZIONE'
Dillo ('-- ' + $NOME_NUOVO + '   sedia: ' + $SEDIA) 'Cyan'
$script:SCRITTO = $true
$script:IN_CORSO = $NOME_NUOVO
[IO.File]::WriteAllBytes($script:PMq5, $SRC_BYTE)
$hs = Sha-File $script:PMq5
if($hs -ne $SRC_SHA){
  Ripristina
  Muori ($NOME_NUOVO + '.mq5 scritto con SHA256 ' + $hs + ' invece di ' + $SRC_SHA + '. Tolto.')
}
Dillo ('   sorgente scritto e riletto dal disco: SHA256 ' + $hs + ' (= ' + $NOME_VECCHIO + '.mq5 al pin, contenuto NON cambiato) : OK') 'Green'
$log = Join-Path $CARTREF ('compila_' + $NOME_NUOVO + '.log')
$c = Compila $script:PMq5 $script:PEx5 $log
Dillo ('   avvio compilazione ' + $c.Avvio.ToString('yyyy-MM-dd HH:mm:ss', $INV) + '   rc ' + $c.Rc + '   ' + $(if($c.Result){ $c.Result } else { '(nessuna riga Result nel log)' })) $null
$ok = ($c.Fresco -and $c.Err -eq 0)
if(-not $ok){
  $perche = ''
  if($c.Muto){ $perche = 'MetaEditor MUTO: nessun log e nessun .ex5 in 20 s' }
  elseif($c.Err -gt 0){ $perche = ('' + $c.Err + ' errori (' + $c.Result + ')') }
  elseif(-not $c.Fresco){ $perche = '.ex5 NON prodotto dopo l avvio della compilazione (classe 270: un .ex5 vecchio non prova niente)' }
  elseif($c.Err -lt 0){ $perche = '.ex5 fresco ma riga Result non letta: non so quanti errori ci sono, e un boh vale come un no' }
  else { $perche = ('' + $c.Err + ' errori') }
  $righeErr = @($c.Righe | Where-Object { $_ -match 'error' } | Select-Object -First 15)
  foreach($l in $righeErr){ Dillo ('     | ' + $l.Trim()) 'DarkYellow' }
  $vuoleInclude = $false
  foreach($l in $righeErr){ if($l -match '(?i)(ABTG_|PausaGuardian)'){ $vuoleInclude = $true } }
  if($vuoleInclude){
    Dillo '   GLI ERRORI NOMINANO L INCLUDE (ABTG_/PausaGuardian): il sorgente al pin vuole un include DIVERSO dalla v1.20 in campo.' 'Red'
    Dillo '   NON si aggiorna l include con questa riga: legherebbe le altre sette CLAU12 a un binario mai compilato. E un altra firma di Claudio.' 'Red'
    $perche = $perche + ' -- ERRORI SULL INCLUDE: il sorgente vuole l include a HEAD, non la v1.20 in campo. Altra firma.'
  }
  Ripristina
  Muori ('compilazione FALLITA di ' + $NOME_NUOVO + ': ' + $perche + '. Il file scritto e stato tolto: il disco e come prima.')
}
$ex = Get-Item -LiteralPath $script:PEx5
$ex5Data = $ex.LastWriteTime.ToString('yyyy-MM-dd HH:mm:ss', $INV)
Dillo ('   COMPILATO: ' + $NOME_NUOVO + '.ex5  ' + $ex.Length.ToString($INV) + ' byte  data ' + $ex5Data + ' (dopo l avvio delle ' + $c.Avvio.ToString('HH:mm:ss', $INV) + ')  SHA256 ' + (Sha-File $script:PEx5)) 'Green'
if($c.War -gt 0){ Dillo ('   ATTENZIONE: ' + $c.War + ' warning. Il binario c e; manda lo zip col log prima di considerarlo chiuso.') 'Yellow' }
$script:IN_CORSO = $null

# =====================================================================
Stato-Finale

# =====================================================================
Titolo 'COSA RESTA DA FARE (e NON lo fa questa riga)'
Dillo '   QUESTA RIGA HA SOLO COMPILATO. Nessun grafico e stato toccato, nessuna sedia attaccata.' 'Yellow'
Dillo ('   1. Nel terminale FTMO 541452707 (C:\FTMO), Navigatore -> Expert Advisors: deve comparire ' + $NOME_NUOVO + '.') 'Yellow'
Dillo '      Se non compare: tasto destro sul Navigatore -> Aggiorna. NON attaccarlo a nessun grafico: e il passo (d) della bozza,' 'Yellow'
Dillo '      viene DOPO le risposte FTMO (par.8.4, cross-account col piccolo) e la firma di magic e taglia.' 'Yellow'
Dillo '   2. Stanotte alle 03:30 CODA_06 rilegge le impronte: attesa una riga CLAU12_MaxMinNotte.mq5 con 919 righe e .ex5 di oggi.' 'Yellow'
Dillo '   3. Il preset in bozza (mql5/Presets/FTMO/BOZZA_CLAU12_MaxMinNotte_ORO_LONG_FTMO.set) arriva con la SUA riga, passo (c).' 'Yellow'
Dillo '   NON TOCCARE: REALE 10105439 (C:\BCM_Reale), 100k 50504263 (-V3), piccolo 50503392, manuale 50503635, banco 50504400, Pepperstone, Tickmill.' 'Yellow'
Dillo '   FINITO SENZA ERRORI DI SCRIPT NON VUOL DIRE IN CAMPO VERIFICATO: lo diventa col punto 1 e con CODA_06.' 'Yellow'

Fine 0 ('FATTO: ' + $NOME_NUOVO + '.mq5 scritto (byte del pin ' + $Pin.Substring(0,8) + ') e compilato contro l include v1.20, .ex5 del ' + $ex5Data + '. Nessuna sedia attaccata. In campo: DA VERIFICARE nel Navigatore.') 'Green'

} catch {
  $msg = $_.Exception.Message
  try { Dillo '' $null; Dillo ('ERRORE IMPREVISTO: ' + $msg) 'Red' } catch { }
  if($script:SCRITTO){
    if($script:IN_CORSO){
      $script:IN_CORSO = $null
      try { Ripristina } catch { try { Dillo ('RIPRISTINO NON RIUSCITO di ' + $NOME_NUOVO + ': ' + $_.Exception.Message + ' -- NON toccare niente e manda lo zip: il file e in MQL5\Experts di C:\FTMO.') 'Red' } catch { } }
    }
    try { Stato-Finale } catch { }
    $script:CODICE = 3
    $script:ESITO = 'ERRORE IMPREVISTO DOPO AVER SCRITTO: ' + $msg + ' -- vedi la tavola k) sopra: il file in corso e stato messo da parte (.ORO_FALLITO_<ora>) (se sopra c e RIPRISTINO NON RIUSCITO, no). Nessuna sedia toccata.'
  } else {
    $script:CODICE = 1
    $script:ESITO = 'ERRORE IMPREVISTO PRIMA DI TOCCARE IL TERMINALE: ' + $msg
  }
  try { Dillo ('ESITO: ' + $script:ESITO) 'Red'; Dillo ('USCITA: ' + $script:CODICE) 'Red' } catch { }
  Posa-Esito
  exit $script:CODICE
}
