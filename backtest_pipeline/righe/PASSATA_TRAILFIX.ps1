# =====================================================================
#  MARCATORE_PASSATA_TRAILFIX_v1
#  PASSATA_TRAILFIX.ps1 -- R254, LA PROVA DI NEUTRALITA' DELLA TRAILFIX
#
#  CHE COSA MISURA, e una cosa sola: se la Parte A (guardia davanti alla
#  PositionModify del trailing PREVBAR, pacchetto
#  mql5/Experts/trailfix_9fca63d9/) CAMBIA I DEAL. 4 sedie x {PIN, PINA}
#  = 8 CORSE SINGOLE (Optimization=0, Model=4 tick reali,
#  AllowLiveTrading=false), secondo i file prova
#     backtest_pipeline/prove/R254{a,b,c,d}_trailfix_<sedia>_{PIN,PINA}.txt
#  Il ragionamento e i CANCELLI stanno nel file di testa
#  R254a_trailfix_770101_PIN.txt (par. 0-9 + blocco CANCELLI, versione
#  del cancello al commit 51f34550). Qui sono implementati QUELLI e solo
#  quelli: C0 (a,b,c,d), N1, N0, N2, C1, C2, e N3 (non di esito:
#  StopsLevel/FreezeLevel scritti con la fonte).
#    C0 d) cattura del giornale di trading (classe 827): per-trade con
#          righe dati -> nel log della STESSA corsa almeno una riga
#          "deal #|deal performed", altrimenti PROVA NULLA + coda del log;
#    C2    l'insieme bloccato (classe 825): ogni riga RINVIO della PINA
#          (ticket T, istante simulato t) ha nel log PIN una riga RIFIUTO
#          con lo stesso T (tradotto con la mappa di N1 se rinumerazione)
#          allo stesso secondo.
#  Esito per sedia nell'ordine del file prova, il primo che scatta decide:
#     1 C0 rosso -> PROVA NULLA   2 N1 rosso -> NON NEUTRA
#     3 N0 rosso -> NON MISURATA  4 N2 rosso -> NEUTRA SUI DEAL, RAFFICA
#     NON AZZERATA   5 C1 rosso -> PROVA NULLA   6 C2 rosso -> NON NEUTRA
#     7 C2 NON MISURABILE -> NEUTRA SUI DEAL, BLOCCATO NON VERIFICATO
#     8 -> NEUTRA
#  Pacchetto: CLAU12_DAX coperto solo se 770101 E 770105 NEUTRA; Dow =
#  770202; Nasdaq = 770260. Niente "neutra per analogia".
#
#  TETTO DI TEMPO DICHIARATO: 60 MINUTI per le 8 corse (-TettoMin). Oltre,
#  le corse non ancora partite NON partono (esito PROVA NULLA, detto), e ci
#  si ferma a guardare. Stima del file prova par. 8: 10-20 minuti + lo
#  scarico iniziale dei tick lug-set 2026 (non stimabile). N3 aggiunge al
#  massimo ~5 minuti dopo le corse.
#
#  IL NOME DEL PER-TRADE (verificato nei sorgenti AL PIN, 26/09/2026):
#    fn = "abtg_trades_" + MQLInfoString(MQL_PROGRAM_NAME) + "_" + _Symbol
#         + "_" + InpMagic + ".csv"   in FILE_COMMON
#    pin 9fca63d9: ABTG_DAX r.2302, ABTG_Dow r.2128, ABTG_Nasdaq r.2547
#    pina 1d68dadd: CLAU12_DAX r.2351, CLAU12_Dow r.2177, CLAU12_Nasdaq r.2596
#  Dipende dal NOME DEL PROGRAMMA, non da un nome fisso: compilando i
#  sorgenti col loro nome (ABTG_<EA>.ex5 e CLAU12_<EA>.ex5) i due per-trade
#  di una coppia hanno nomi DIVERSI e NON si sovrascrivono. Quindi si usa
#  lo STESSO magic nella coppia (il primo valore dell'asse del file prova,
#  come dice il file prova par. 1) e N1 resta un confronto di SHA256.
#  Magic diversi FRA le sedie (792901..792904): 770101 e 770105 girano lo
#  stesso sorgente sullo stesso simbolo.
#
#  DOVE SCRIVE (e solo li'):
#    - cartella dati del terminale del PC: MQL5\Experts (6 sorgenti al pin
#      + .ex5; ATTENZIONE: ABTG_<EA>.mq5/.ex5 del PC vengono SOVRASCRITTI
#      dal pin 9fca63d9 -- innocuo, il driver li rifa' da capo a ogni round,
#      file prova par. 6), MQL5\Include, MQL5\Scripts e MQL5\Presets (solo
#      per N3), MQL5\Files (N3: il CSV vecchio si RINOMINA, non si cancella),
#      sottocartella di lavoro <dati>\abtg_passata_trailfix;
#    - Common\Files di MT5: SOLO RINOMINA di un per-trade vecchio con lo
#      STESSO nome (magic vergini 7929xx: succede solo se questo script e'
#      gia' girato), cosi' un file vecchio non passa per nuovo;
#    - Desktop: cartella PASSATA_TRAILFIX + PASSATA_TRAILFIX.zip.
#  MetaEditor scrive i .ex5, il terminale scrive i suoi log e il report.
#
#  E' UN BACKTEST, NON UN ORDINE. [Experts] AllowLiveTrading=false in ogni
#  .ini: il terminale del PC e' loggato sul DEMO 50503392, e il 14/08/2026
#  da questa macchina sono partiti ordini veri. Nessun parametro di taglia:
#  rischio di banco 1% dai file prova, deposito 10000 EUR, leva 100.
#  NESSUNA RIGA DI LANCIO QUI DENTRO: la detta la sessione, col suo cancello.
#
#  [NON VERIFICATO] / [NON MISURATO], in un posto solo:
#    - storico tick BCM sul PC fino al 25/09/2026 (file prova par. 2): lo
#      script scrive le righe "history ticks synchronized from .. to .." e
#      AVVISA se l'ultimo tick e' prima del 2026.09.17;
#    - il FORMATO delle righe di rifiuto in corsa singola (par. 5): la
#      regex e' quella del file prova, case-insensitive;
#    - che in corsa singola la riga d'avvio porti l'etichetta
#      "<programma> (<simbolo>,M5)" come nel log d'agente di R251
#      (misurato SOLO in ottimizzazione). Se non la porta, C0 b) esce
#      ROSSO e lo dice: e' un falso rosso possibile, non un falso verde;
#    - C2: che le righe RIFIUTO portino il ticket come "#<n>" e le righe
#      RINVIO come "(ticket <n>)", tutte e due con l'istante simulato
#      "aaaa.mm.gg hh:mm:ss". Se una riga RINVIO non li porta, o se una
#      RINVIO resta senza gemella mentre nel PIN ci sono righe RIFIUTO
#      illeggibili (la gemella potrebbe essere li'), C2 = NON MISURABILE,
#      mai ROSSO per un difetto del lettore;
#    - che l'agente scarichi i log su disco entro 8 s dalla chiusura del
#      terminale (stessa attesa del modello PASSATA_STOP_SUPREV v2);
#    - N3: lancio di uno SCRIPT con [StartUp] sul terminale del PC (schema
#      di SONDA_BOX_D30EUR.ps1). Lo script ha script_show_inputs: se la
#      finestra dei parametri compare e blocca, N3 esce [NON MISURATO] dopo
#      3 minuti. N3 gira DOPO le 8 corse: non puo' rovinarle.
#
#  NIENTE EMOJI QUI DENTRO (regola del 17/08): Windows PowerShell 5.1
#  legge i .ps1 come ANSI e un'emoji dentro una stringa rompe il parser.
# =====================================================================
[CmdletBinding()]
param(
  [Parameter(Mandatory=$true)][string]$Pin,
  [int]$TettoMin = 60,
  [switch]$SenzaN3
)

$ErrorActionPreference = 'Stop'
$IC = [Globalization.CultureInfo]::InvariantCulture
[Threading.Thread]::CurrentThread.CurrentCulture   = $IC
[Threading.Thread]::CurrentThread.CurrentUICulture = $IC
[Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12
$T_INIZIO = Get-Date

function Dico($t,$c='Gray'){ Write-Host ('   ' + $t) -ForegroundColor $c }
function Titolo($t){ Write-Host ''; Write-Host ('=== ' + $t + ' ===') -ForegroundColor Cyan }

if($Pin -notmatch '^[0-9a-f]{7,40}$'){ throw ('-Pin deve essere un commit git (7-40 cifre esadecimali minuscole). Ricevuto: ' + $Pin) }
if($TettoMin -lt 5 -or $TettoMin -gt 60){ throw ('-TettoMin fuori dal tetto dichiarato (5..60): ' + $TettoMin) }

# ---------------------------------------------------------------------
#  LE COSTANTI DELLA PROVA -- copiate dai file prova R254 (intestazioni,
#  righe "percorso / commit / SHA256") e verificate con git il 26/09/2026.
#  Lo script NON si fida di se stesso: al par. 1 le confronta con le
#  intestazioni dei file prova scaricati al -Pin, e se non coincidono NON
#  parte.
# ---------------------------------------------------------------------
$RAWROOT  = 'https://raw.githubusercontent.com/claudiospadaro12/GITHUB/'
$PIN_SRC  = '9fca63d98046e60b29f9300fc09dad7738cc887d'
$PINA_SRC = '1d68dadd54f0f3f278ef62aa4ba6ecd463921134'
$INC_REL  = 'mql5/Include/ABTG_PausaGuardian.mqh'
$INC_SHA  = '3ec971152e85e0082488cc4243ff45ae09948c191d52ab96050b48f94641a737'
$N3_REL   = 'mql5/Scripts/ABTG_PrevoloFTMO_Specifiche.mq5'
$N3_NOME  = 'ABTG_PrevoloFTMO_Specifiche'
$N3_SHA   = 'aec8dae6c7de9ff7c083c04ad130e156b0360f7859368cdd7237f83c27fd9712'
$PERIODO  = 'M5'
$DA       = '2026.05.31'
$A        = '2026.09.25'
$DEPOSITO = '10000'
$RE_RIFIUTO = 'invalid stops|failed modify'
$RE_RINVIO  = 'trailing rinviato: stop'
$RE_DEAL    = 'deal #|deal performed'

$SORGENTI = @{
  'PIN_DAX'  = @{ Tipo='PIN';  Nome='ABTG_DAX_Apertura_EU';        Rel='mql5/Experts/ABTG_DAX_Apertura_EU.mq5';                           Commit=$PIN_SRC;  Sha='d9f4636471a1b2632936e398bac3cbccef6fda89c1b432626b21d8dd7e719dd3'; Righe=2425 }
  'PINA_DAX' = @{ Tipo='PINA'; Nome='CLAU12_DAX_Apertura_EU';      Rel='mql5/Experts/trailfix_9fca63d9/CLAU12_DAX_Apertura_EU.mq5';      Commit=$PINA_SRC; Sha='7219a044daaa1b58ae7c6a2885e7f3d5e7e31187178ae68735fe510876cbcb41'; Righe=2474 }
  'PIN_DOW'  = @{ Tipo='PIN';  Nome='ABTG_Dow_Apertura_US';        Rel='mql5/Experts/ABTG_Dow_Apertura_US.mq5';                           Commit=$PIN_SRC;  Sha='c2676b14dc222fb111c009d8a88729fa98d24b6b3fe0ef629054d58d424bdc1e'; Righe=2205 }
  'PINA_DOW' = @{ Tipo='PINA'; Nome='CLAU12_Dow_Apertura_US';      Rel='mql5/Experts/trailfix_9fca63d9/CLAU12_Dow_Apertura_US.mq5';      Commit=$PINA_SRC; Sha='b07502c461485abb77f13259ad24755aca859f56cc59665c7845c0a8643857a5'; Righe=2254 }
  'PIN_NAS'  = @{ Tipo='PIN';  Nome='ABTG_Nasdaq_Apertura_US';     Rel='mql5/Experts/ABTG_Nasdaq_Apertura_US.mq5';                        Commit=$PIN_SRC;  Sha='349b4b7f2a813e228b8fc0556e977eb304f4b01ddd01abf0264fc3044955cf09'; Righe=2624 }
  'PINA_NAS' = @{ Tipo='PINA'; Nome='CLAU12_Nasdaq_Apertura_US';   Rel='mql5/Experts/trailfix_9fca63d9/CLAU12_Nasdaq_Apertura_US.mq5';   Commit=$PINA_SRC; Sha='5b4bb6f2da9f959e53c30efb63da69cd95a6f0b4db203cd826a15ebb8af4898d'; Righe=2673 }
}
$ORDINE_SRC = @('PIN_DAX','PINA_DAX','PIN_DOW','PINA_DOW','PIN_NAS','PINA_NAS')

$SEDIE = @(
  @{ Id='a'; Sedia='770101'; Simbolo='D30EUR'; Tag='DAX Apertura EU';    Lati='SOLO LONG';  Long='true';  Short='false'; Magic='792901'; SrcPin='PIN_DAX'; SrcPina='PINA_DAX'; Pacchetto='CLAU12_DAX_Apertura_EU';    FilePin='R254a_trailfix_770101_PIN.txt'; FilePina='R254a_trailfix_770101_PINA.txt'; Avvio='avviato su D30EUR. Apertura server 08:00, range 35 min, flat 17:30.' },
  @{ Id='b'; Sedia='770105'; Simbolo='D30EUR'; Tag='DAX Apertura EU';    Lati='SOLO SHORT'; Long='false'; Short='true';  Magic='792902'; SrcPin='PIN_DAX'; SrcPina='PINA_DAX'; Pacchetto='CLAU12_DAX_Apertura_EU';    FilePin='R254b_trailfix_770105_PIN.txt'; FilePina='R254b_trailfix_770105_PINA.txt'; Avvio='avviato su D30EUR. Apertura server 08:00, range 35 min, flat 17:30.' },
  @{ Id='c'; Sedia='770202'; Simbolo='U30USD'; Tag='Dow Apertura US';    Lati='SOLO LONG';  Long='true';  Short='false'; Magic='792903'; SrcPin='PIN_DOW'; SrcPina='PINA_DOW'; Pacchetto='CLAU12_Dow_Apertura_US';    FilePin='R254c_trailfix_770202_PIN.txt'; FilePina='R254c_trailfix_770202_PINA.txt'; Avvio='avviato su U30USD. Apertura server 14:30, range 35 min, flat 17:30.' },
  @{ Id='d'; Sedia='770260'; Simbolo='NASUSD'; Tag='Nasdaq Apertura US'; Lati='long+short'; Long='true';  Short='true';  Magic='792904'; SrcPin='PIN_NAS'; SrcPina='PINA_NAS'; Pacchetto='CLAU12_Nasdaq_Apertura_US'; FilePin='R254d_trailfix_770260_PIN.txt'; FilePina='R254d_trailfix_770260_PINA.txt'; Avvio='avviato su NASUSD. Apertura server 14:30, range 35 min, flat 17:30.' }
)

# ---------------------------------------------------------------------
#  0. LA MACCHINA E IL TERMINALE. Fail-closed, identico al modello
#     PASSATA_STOP_SUPREV.ps1 v2.
# ---------------------------------------------------------------------
Titolo '0 - MACCHINA E TERMINALE'
if($env:COMPUTERNAME -ne 'DESKTOP-H4D7CAJ'){
  throw ('PASSATA_TRAILFIX gira SOLO sul PC di backtest DESKTOP-H4D7CAJ. Qui la macchina si chiama: ' + $env:COMPUTERNAME + '. Sul VPS VMI3047753 non si lancia: la challenge FTMO 541452707 sta operando.')
}
Dico ('pc              : ' + $env:COMPUTERNAME) 'Green'
Dico ('pin file prova  : ' + $Pin) 'Green'
Dico ('pin sorgenti    : PIN ' + $PIN_SRC + '   PINA ' + $PINA_SRC) 'Green'
Dico ('tetto dichiarato: ' + $TettoMin + ' minuti per le 8 corse') 'Green'
if((@(Get-Process -Name terminal64 -ErrorAction SilentlyContinue)).Count -gt 0){
  throw 'MT5 risulta APERTO su questo PC. La passata ne apre una copia sua con /config: col terminale gia aperto il tester non parte. Chiudilo A MANO e rilancia.'
}

$InstAttesa = 'C:\Program Files\BCM Markets MT5 Terminal'
$Terminal   = Join-Path $InstAttesa 'terminal64.exe'
$MetaEditor = Join-Path $InstAttesa 'metaeditor64.exe'
if(-not (Test-Path -LiteralPath $Terminal)){
  throw ('terminale non trovato dove la passata lo aspetta: ' + $Terminal + '. Non si cerca altrove apposta.')
}
$DataRoot = Join-Path $env:APPDATA 'MetaQuotes\Terminal'
$origini = @()
foreach($d in @(Get-ChildItem -Path $DataRoot -Directory -ErrorAction SilentlyContinue)){
  $o = Join-Path $d.FullName 'origin.txt'
  if(Test-Path -LiteralPath $o){
    $v = (Get-Content -LiteralPath $o -Raw).Trim()
    if($v -ne ''){ $origini = $origini + @([pscustomobject]@{ Dir = $d.FullName; Inst = $v }) }
  }
}
$diversi = @($origini | Where-Object { $_.Inst -ne $InstAttesa })
if($diversi.Count -gt 0){
  Write-Host '   ATTENZIONE: su questa macchina hanno girato ALTRE installazioni MT5:' -ForegroundColor Red
  foreach($x in $diversi){ Write-Host ('     ' + $x.Inst) -ForegroundColor Red }
  throw 'La passata si ferma: la riga dichiara che il PC di backtest ha UN SOLO MT5, e qui ce ne sono altri (regola dei terminali multipli).'
}
$cands = @($origini | Where-Object { $_.Inst -eq $InstAttesa })
if($cands.Count -ne 1){
  throw ('cartella dati NON risolta in modo univoco: trovate ' + $cands.Count + ' candidate per ' + $InstAttesa + '. La passata si ferma invece di indovinare.')
}
$DataFolder  = $cands[0].Dir
$MqlExp      = Join-Path $DataFolder 'MQL5\Experts'
$MqlInc      = Join-Path $DataFolder 'MQL5\Include'
$MqlScr      = Join-Path $DataFolder 'MQL5\Scripts'
$MqlPre      = Join-Path $DataFolder 'MQL5\Presets'
$MqlFil      = Join-Path $DataFolder 'MQL5\Files'
$CommonFiles = Join-Path $env:APPDATA 'MetaQuotes\Terminal\Common\Files'
New-Item -ItemType Directory -Force -Path $MqlExp,$MqlInc | Out-Null
Dico ('terminale: ' + $Terminal) 'Green'
Dico ('dati     : ' + $DataFolder) 'Green'

# ---------------------------------------------------------------------
#  1. SORGENTI, INCLUDE E FILE PROVA AL PIN. C0 a) si chiude QUI: uno SHA
#     diverso ferma tutto prima di consumare tempo macchina.
# ---------------------------------------------------------------------
Titolo '1 - SORGENTI AL PIN, IMPRONTE, FILE PROVA'
$Work = Join-Path $DataFolder 'abtg_passata_trailfix'
if(Test-Path -LiteralPath $Work){ Remove-Item -LiteralPath $Work -Recurse -Force -ErrorAction SilentlyContinue }
New-Item -ItemType Directory -Force -Path $Work | Out-Null

function Impronta($p){ return ((Get-FileHash -LiteralPath $p -Algorithm SHA256).Hash).ToLowerInvariant() }
function Prendi($rel, $commit, $dest, $sha, $firma){
  Remove-Item -LiteralPath $dest -Force -ErrorAction SilentlyContinue
  $url = $RAWROOT + $commit + '/' + $rel + '?cb=' + [Guid]::NewGuid().ToString('N')
  try{ Invoke-WebRequest -Uri $url -OutFile $dest -UseBasicParsing -TimeoutSec 120 }
  catch{ throw ('scarico fallito: ' + $rel + ' @ ' + $commit + ' -- ' + $_.Exception.Message) }
  if(-not (Test-Path -LiteralPath $dest -PathType Leaf)){ throw ('file non scaricato: ' + $rel + ' @ ' + $commit) }
  if((Get-Item -LiteralPath $dest).Length -eq 0){ throw ('file scaricato VUOTO: ' + $rel + ' @ ' + $commit) }
  $h = Impronta $dest
  if($sha -ne '' -and $h -ne $sha){
    throw ('IMPRONTA DIVERSA su ' + $rel + ' @ ' + $commit + ': attesa ' + $sha + ', trovata ' + $h + '. C0 a) ROSSO: la prova sarebbe NULLA. Non si parte.')
  }
  if($firma -ne '' -and -not (Select-String -LiteralPath $dest -SimpleMatch -Pattern $firma -Quiet)){
    throw ($rel + ' scaricato ma NON contiene "' + $firma + '": copia sbagliata. Non si parte.')
  }
  return $h
}

foreach($k in $ORDINE_SRC){
  $so = $SORGENTI[$k]
  $so.Locale = Join-Path $Work ($so.Nome + '.mq5')
  $so.ShaScaricato = Prendi $so.Rel $so.Commit $so.Locale $so.Sha 'abtg_trades_'
  # contro-esempio del binario sbagliato: la PINA DEVE avere la guardia che
  # scrive la riga RINVIO, il PIN NON la deve avere.
  $haRinvio = Select-String -LiteralPath $so.Locale -SimpleMatch -Pattern 'trailing rinviato: stop' -Quiet
  if($so.Tipo -eq 'PINA' -and -not $haRinvio){ throw ($so.Nome + ': sorgente PINA SENZA la riga "trailing rinviato: stop". Non e la Parte A. Non si parte.') }
  if($so.Tipo -eq 'PIN' -and $haRinvio){ throw ($so.Nome + ': sorgente PIN CON la riga "trailing rinviato: stop". Non e il pin in campo. Non si parte.') }
  $so.RigheLette = (@(Get-Content -LiteralPath $so.Locale)).Count
  Dico ($so.Tipo.PadRight(4) + ' ' + $so.Nome.PadRight(27) + ' SHA256 ' + $so.ShaScaricato + '  righe ' + $so.RigheLette + ' (dichiarate ' + $so.Righe + ')') 'Green'
}
$incLocale = Join-Path $Work 'ABTG_PausaGuardian.mqh'
$incSha = Prendi $INC_REL $PIN_SRC $incLocale $INC_SHA 'ABTG_GuardiaIngresso'
Dico ('include ABTG_PausaGuardian.mqh SHA256 ' + $incSha) 'Green'

function Pretendi($cond, $msg){ if(-not $cond){ throw ('FILE PROVA E SCRIPT NON CONCORDANO: ' + $msg + '. Non si parte.') } }
function LeggiProva($path){
  $r = @{ Ea=''; Percorso=''; Commit=''; Sha=''; IncSha=$false; Avvio=''; Lati=''; Dir=@{}; Inputs=(New-Object System.Collections.ArrayList) }
  foreach($riga in (Get-Content -LiteralPath $path)){
    if($r.Ea -eq '' -and $riga -match '^#\s+EA:\s+(\S+)'){ $r.Ea = $Matches[1]; continue }
    if($r.Percorso -eq '' -and $riga -match '^#\s+percorso\s*:\s*(\S+)'){ $r.Percorso = $Matches[1]; continue }
    if($r.Commit -eq '' -and $riga -match '^#\s+commit\s*:\s*([0-9a-f]{40})'){ $r.Commit = $Matches[1]; continue }
    if($r.Sha -eq '' -and $riga -match '^#\s+SHA256\s*:\s*([0-9a-f]{64})'){ $r.Sha = $Matches[1]; continue }
    if($riga.Contains($INC_SHA)){ $r.IncSha = $true }
    if($r.Avvio -eq '' -and $riga -match '^#\s+(avviato su .*\.)\s*$'){ $r.Avvio = $Matches[1]; continue }
    if($r.Lati -eq '' -and $riga -match 'CONFIG IN USO ->.*\|\s*lati=([^|]+?)\s*\|'){ $r.Lati = $Matches[1]; continue }
    if($riga -match '^@([A-Z]+)\s+(\S+)\s*$'){ $r.Dir[$Matches[1]] = $Matches[2]; continue }
    if($riga -match '^(Inp[A-Za-z0-9_]+)=(.*)$'){
      $nome = $Matches[1]; $val = $Matches[2].TrimEnd()
      $i = $val.IndexOf('||'); if($i -ge 0){ $val = $val.Substring(0,$i) }
      [void]$r.Inputs.Add($nome + '=' + $val)
    }
  }
  return $r
}

$provaSha = @{}
foreach($S in $SEDIE){
  foreach($tipo in @('PIN','PINA')){
    if($tipo -eq 'PIN'){ $fn = $S.FilePin; $src = $SORGENTI[$S.SrcPin] } else { $fn = $S.FilePina; $src = $SORGENTI[$S.SrcPina] }
    $loc = Join-Path $Work $fn
    $provaSha[$fn] = Prendi ('backtest_pipeline/prove/' + $fn) $Pin $loc '' '@DAQUANDO'
    $pr = LeggiProva $loc
    Pretendi ($pr.Ea -eq $src.Nome) ($fn + ': riga EA "' + $pr.Ea + '" invece di "' + $src.Nome + '"')
    Pretendi ($pr.Percorso -eq $src.Rel) ($fn + ': percorso "' + $pr.Percorso + '" invece di "' + $src.Rel + '"')
    Pretendi ($pr.Commit -eq $src.Commit) ($fn + ': commit "' + $pr.Commit + '" invece di "' + $src.Commit + '"')
    Pretendi ($pr.Sha -eq $src.Sha) ($fn + ': SHA256 "' + $pr.Sha + '" invece di "' + $src.Sha + '"')
    Pretendi $pr.IncSha ($fn + ': lo SHA256 dell include ' + $INC_SHA + ' non compare')
    Pretendi ($pr.Avvio -eq $S.Avvio) ($fn + ': avvio atteso "' + $pr.Avvio + '" invece di "' + $S.Avvio + '"')
    Pretendi ($pr.Lati -eq $S.Lati) ($fn + ': lati attesi "' + $pr.Lati + '" invece di "' + $S.Lati + '"')
    Pretendi ($pr.Dir['SIMBOLO'] -eq $S.Simbolo) ($fn + ': @SIMBOLO ' + $pr.Dir['SIMBOLO'])
    Pretendi ($pr.Dir['PERIODO'] -eq $PERIODO) ($fn + ': @PERIODO ' + $pr.Dir['PERIODO'])
    Pretendi ($pr.Dir['DAQUANDO'] -eq $DA) ($fn + ': @DAQUANDO ' + $pr.Dir['DAQUANDO'])
    Pretendi ($pr.Dir['FINOA'] -eq $A) ($fn + ': @FINOA ' + $pr.Dir['FINOA'])
    Pretendi ($pr.Inputs.Count -ge 70) ($fn + ': solo ' + $pr.Inputs.Count + ' righe Inp (file tronco)')
    $doppi = @($pr.Inputs | ForEach-Object { ($_ -split '=')[0] } | Group-Object | Where-Object { $_.Count -gt 1 })
    Pretendi ($doppi.Count -eq 0) ($fn + ': parametri DOPPI ' + (($doppi | ForEach-Object { $_.Name }) -join ','))
    $attesi = @(('InpMagic=' + $S.Magic), 'InpVerbose=true', 'InpRiskPercent=1.0', 'InpEntryMode=2', 'InpUseTrailing=true', 'InpTrailMode=1', 'InpTrailTF=5', 'InpTrailStartR=0.0', ('InpAllowLong=' + $S.Long), ('InpAllowShort=' + $S.Short))
    foreach($pa in $attesi){ Pretendi (@($pr.Inputs | Where-Object { $_ -eq $pa }).Count -eq 1) ($fn + ': non contiene esattamente una volta ' + $pa) }
    if($tipo -eq 'PIN'){ $S.InputsPin = $pr.Inputs } else { $S.InputsPina = $pr.Inputs }
    Dico ($fn.PadRight(32) + ' SHA256 ' + $provaSha[$fn] + '  input ' + $pr.Inputs.Count + '  magic ' + $S.Magic) 'Green'
  }
  Pretendi ((($S.InputsPin) -join "`n") -eq (($S.InputsPina) -join "`n")) ('sedia ' + $S.Sedia + ': gli input di PIN e PINA NON sono identici riga per riga')
}

# ---------------------------------------------------------------------
#  2. INSTALLAZIONE E COMPILAZIONE. Lo SHA si rilegge sul file COPIATO in
#     MQL5\Experts, cioe' su quello che MetaEditor compila (C0 a).
# ---------------------------------------------------------------------
Titolo '2 - INSTALLAZIONE E COMPILAZIONE'
$incDest = Join-Path $MqlInc 'ABTG_PausaGuardian.mqh'
Copy-Item -LiteralPath $incLocale -Destination $incDest -Force
if((Impronta $incDest) -ne $INC_SHA){ throw 'include copiato in MQL5\Include con SHA256 diverso. C0 a) ROSSO. Non si parte.' }
Dico ('include in MQL5\Include: SHA256 ok') 'Green'

function Compila($mq5, $ex5, $logC){
  Remove-Item -LiteralPath $ex5 -Force -ErrorAction SilentlyContinue
  if(Test-Path -LiteralPath $ex5){ throw ((Split-Path -Leaf $ex5) + ' VECCHIO NON CANCELLABILE: la sua comparsa non proverebbe la compilazione di adesso (classe 270). Non si parte.') }
  Remove-Item -LiteralPath $logC -Force -ErrorAction SilentlyContinue
  $tC = Get-Date
  # il verdetto NON e' il codice d'uscita di MetaEditor (a volte si
  # stacca): e' l'esistenza del .ex5 appena prodotto (modello v2).
  $pMe = Start-Process -FilePath $MetaEditor -ArgumentList @(('/compile:' + $mq5), ('/log:' + $logC)) -PassThru
  $att = 0
  while(-not (Test-Path -LiteralPath $ex5) -and $att -lt 60){ Start-Sleep -Seconds 2; $att = $att + 1 }
  if(-not (Test-Path -LiteralPath $ex5)){
    try{ if(-not $pMe.HasExited){ $pMe.Kill() } }catch{ }
    if(Test-Path -LiteralPath $logC){ Get-Content -LiteralPath $logC | Select-Object -Last 15 | ForEach-Object { Write-Host ('     ' + $_) -ForegroundColor DarkYellow } }
    throw ((Split-Path -Leaf $ex5) + ' NON prodotto dopo 120 secondi. Senza il compilato la passata non gira.')
  }
  # una compilazione alla volta: si aspetta che MetaEditor esca
  $att = 0
  while(-not $pMe.HasExited -and $att -lt 30){ Start-Sleep -Seconds 2; $att = $att + 1 }
  $dEx5 = (Get-Item -LiteralPath $ex5).LastWriteTime
  if($dEx5 -lt $tC.AddSeconds(-2)){ throw ((Split-Path -Leaf $ex5) + ' ha data ' + $dEx5.ToString('yyyy-MM-dd HH:mm:ss') + ', PRIMA della compilazione delle ' + $tC.ToString('HH:mm:ss') + ': non e il compilato di adesso (classe 270). Non si parte.') }
}

foreach($k in $ORDINE_SRC){
  $so = $SORGENTI[$k]
  $mq5 = Join-Path $MqlExp ($so.Nome + '.mq5')
  Copy-Item -LiteralPath $so.Locale -Destination $mq5 -Force
  $so.ShaCompilato = Impronta $mq5
  if($so.ShaCompilato -ne $so.Sha){ throw ($so.Nome + '.mq5 in MQL5\Experts ha SHA256 ' + $so.ShaCompilato + ' invece di ' + $so.Sha + '. C0 a) ROSSO. Non si parte.') }
  $ex5 = Join-Path $MqlExp ($so.Nome + '.ex5')
  $logC = Join-Path $Work ('compile_' + $so.Nome + '.log')
  Compila $mq5 $ex5 $logC
  $so.Ex5 = (Get-Item -LiteralPath $ex5)
  Dico ('compilato ' + $so.Nome + '.ex5   ' + $so.Ex5.Length + ' byte   ' + $so.Ex5.LastWriteTime.ToString('HH:mm:ss')) 'Green'
}

# ---------------------------------------------------------------------
#  3. LE 8 CORSE SINGOLE
# ---------------------------------------------------------------------
$dsk  = [Environment]::GetFolderPath('Desktop')
$Cart = Join-Path $dsk 'PASSATA_TRAILFIX'
if(Test-Path -LiteralPath $Cart){ Remove-Item -LiteralPath $Cart -Recurse -Force -ErrorAction SilentlyContinue }
New-Item -ItemType Directory -Force -Path $Cart | Out-Null
foreach($k in $ORDINE_SRC){
  $lc = Join-Path $Work ('compile_' + $SORGENTI[$k].Nome + '.log')
  if(Test-Path -LiteralPath $lc){ Copy-Item -LiteralPath $lc -Destination $Cart -Force }
}

# le radici dei log sono quelle del modello v2: %APPDATA%\MetaQuotes
# (cartella dati + agenti del tester) e <installazione>\Tester.
$RadiciLog = @((Join-Path $env:APPDATA 'MetaQuotes'), (Join-Path $InstAttesa 'Tester'))
$OPZ   = [Text.RegularExpressions.RegexOptions]::IgnoreCase
$reRif  = New-Object Text.RegularExpressions.Regex($RE_RIFIUTO, $OPZ)
$reRinv = New-Object Text.RegularExpressions.Regex($RE_RINVIO, $OPZ)
$reDeal = New-Object Text.RegularExpressions.Regex($RE_DEAL, $OPZ)
# C2: il ticket di una riga RIFIUTO e' il primo "#<n>" ("failed modify #5 ...",
# "modify position #5 ..."); quello di una riga RINVIO e' "(ticket <n>)"
# (TrailRinvioLog dei tre sorgenti PINA).
$reTkRif  = New-Object Text.RegularExpressions.Regex('#(\d+)')
$reTkRinv = New-Object Text.RegularExpressions.Regex('\(ticket (\d+)\)')
$reData = New-Object Text.RegularExpressions.Regex('\d{4}\.\d{2}\.\d{2} \d{2}:\d{2}:\d{2}')
$reStoria = New-Object Text.RegularExpressions.Regex('([A-Za-z0-9._#]+): history ticks synchronized from (\d{4}\.\d{2}\.\d{2}) to (\d{4}\.\d{2}\.\d{2})')

function ElencoLog(){
  $v = @()
  foreach($rad in $RadiciLog){
    if(-not (Test-Path -LiteralPath $rad)){ continue }
    $v = $v + @(Get-ChildItem -Path $rad -Recurse -Filter '*.log' -File -ErrorAction SilentlyContinue)
  }
  return $v
}
function Fotografia(){
  $h = @{}
  foreach($f in @(ElencoLog)){ $h[$f.FullName] = $f.Length }
  return $h
}
function LeggiCoda($path, $offset){
  # i log di MT5 sono UTF-16 LE con BOM: la codifica si legge dal BOM
  # all'inizio del FILE, poi si salta all'offset fotografato prima della
  # corsa, cosi' si legge SOLO quello che questa corsa ha scritto.
  $fs = [IO.File]::Open($path,[IO.FileMode]::Open,[IO.FileAccess]::Read,[IO.FileShare]::ReadWrite)
  try{
    $b = New-Object byte[] 2
    [void]$fs.Read($b,0,2)
    $enc = [Text.Encoding]::UTF8
    if($b[0] -eq 0xFF -and $b[1] -eq 0xFE){ $enc = [Text.Encoding]::Unicode }
    elseif($b[0] -eq 0xFE -and $b[1] -eq 0xFF){ $enc = [Text.Encoding]::BigEndianUnicode }
    $da = [long]$offset
    if($da -lt 2 -and $enc -ne [Text.Encoding]::UTF8){ $da = 2 }
    [void]$fs.Seek($da,[IO.SeekOrigin]::Begin)
    $sr = New-Object IO.StreamReader($fs, $enc, $false)
    return $sr.ReadToEnd()
  } finally { $fs.Close() }
}
function Chiave($riga){
  # chiave di conteggio DISTINTO (solo informativa): la stessa riga puo'
  # comparire nel log dell'agente e nel giornale del tester. Dalla data
  # simulata in poi, se c'e'; altrimenti tolti i tre campi di testa.
  $m = $reData.Match($riga)
  if($m.Success){ return $riga.Substring($m.Index).Trim() }
  $parti = $riga.Split("`t")
  if($parti.Count -ge 4){ return (($parti[3..($parti.Count-1)]) -join ' ').Trim() }
  return $riga.Trim()
}

$CORSE = New-Object System.Collections.ArrayList
foreach($S in $SEDIE){
  foreach($tipo in @('PIN','PINA')){
    if($tipo -eq 'PIN'){ $src = $SORGENTI[$S.SrcPin]; $inp = $S.InputsPin; $fp = $S.FilePin } else { $src = $SORGENTI[$S.SrcPina]; $inp = $S.InputsPina; $fp = $S.FilePina }
    [void]$CORSE.Add(@{ Sedia=$S; Tipo=$tipo; Id=('R254' + $S.Id + '_' + $tipo); Nome=$src.Nome; Inputs=$inp; Prova=$fp; Magic=$S.Magic;
                        PerTrade=('abtg_trades_' + $src.Nome + '_' + $S.Simbolo + '_' + $S.Magic + '.csv');
                        Girata=$false; Interrotta=$false; Motivo=''; C0=$false; C0Motivi=(New-Object System.Collections.ArrayList);
                        Rif=0; RifDist=0; Rinv=0; RinvDist=0; Rif0911=0; Rif0917=0; EsempiRif=(New-Object System.Collections.ArrayList);
                        Storia=@{}; FileLetti=0; Illeggibili=0; Avvii=''; Cfg=''; PtCopia=''; PtSha=''; PtRighe=-1; Sec=0; Ora0=''; Ora1='';
                        Deal=0; C0dRosso=$false; Coda=(New-Object System.Collections.ArrayList);
                        RinvList=(New-Object System.Collections.ArrayList); RifSet=@{}; RifIlleggibili=0; FileIlleggibili=(New-Object System.Collections.ArrayList) })
  }
}

$scadeTutto = (Get-Date).AddMinutes($TettoMin)
$fermo = $false; $motivoFermo = ''
Titolo ('3 - LE 8 CORSE SINGOLE   (tetto: fine entro le ' + $scadeTutto.ToString('HH:mm:ss') + ')')

foreach($C in $CORSE){
  $S = $C.Sedia
  Titolo ('3 - CORSA ' + $C.Id + '   sedia ' + $S.Sedia + '   ' + $C.Nome + '.ex5 su ' + $S.Simbolo + ' ' + $PERIODO + '   magic ' + $C.Magic)
  if(-not $fermo -and (Get-Date) -ge $scadeTutto){ $fermo = $true; $motivoFermo = ('tetto di ' + $TettoMin + ' minuti superato') }
  if(-not $fermo -and (@(Get-Process -Name terminal64 -ErrorAction SilentlyContinue)).Count -gt 0){ $fermo = $true; $motivoFermo = 'un terminal64 e ancora vivo dalla corsa prima (MAI chiuso a forza da qui): chiudilo a mano' }
  if($fermo){
    $C.Motivo = ('NON LANCIATA: ' + $motivoFermo)
    [void]$C.C0Motivi.Add($C.Motivo)
    Dico $C.Motivo 'Red'
    continue
  }

  # --- l'ini: [Tester] + [TesterInputs] con TUTTE le righe Inp del file
  #     prova ridotte al PRIMO valore (magic = primo valore dell'asse).
  $ini = Join-Path $Cart ($C.Id + '.ini')
  $testoIni = "[Experts]`r`nAllowLiveTrading=false`r`nAllowDllImport=false`r`n`r`n" +
              "[Tester]`r`nExpert=" + $C.Nome + ".ex5`r`nSymbol=" + $S.Simbolo + "`r`nPeriod=" + $PERIODO + "`r`nModel=4`r`n" +
              "Optimization=0`r`nFromDate=" + $DA + "`r`nToDate=" + $A + "`r`nForwardMode=0`r`nDeposit=" + $DEPOSITO + "`r`nCurrency=EUR`r`nLeverage=100`r`n" +
              "ExecutionMode=0`r`nReplaceReport=1`r`nShutdownTerminal=1`r`nReport=" + $C.Id + "`r`n`r`n" +
              "[TesterInputs]`r`n" + ($C.Inputs -join "`r`n") + "`r`n"
  Set-Content -LiteralPath $ini -Value $testoIni -Encoding ASCII

  # --- il per-trade vecchio con lo STESSO nome si RINOMINA (non si
  #     cancella): un file vecchio non deve passare per quello della corsa.
  $ptVivo = Join-Path $CommonFiles $C.PerTrade
  if(Test-Path -LiteralPath $ptVivo){
    $nuovoNome = $C.PerTrade + '.pre_R254_' + (Get-Date).ToString('yyyyMMdd_HHmmss')
    Rename-Item -LiteralPath $ptVivo -NewName $nuovoNome
    Dico ('per-trade vecchio con lo stesso nome RINOMINATO in ' + $nuovoNome) 'DarkYellow'
  }

  $foto = Fotografia
  $t0 = Get-Date
  $C.Ora0 = $t0.ToString('HH:mm:ss')
  Dico ('avvio: ' + $C.Ora0 + '   (tick reali, ' + $DA + ' -> ' + $A + ', deposito ' + $DEPOSITO + ' EUR, leva 100)') 'Cyan'
  $p = Start-Process -FilePath $Terminal -ArgumentList ('/config:"' + $ini + '"') -PassThru
  while(-not $p.HasExited -and (Get-Date) -lt $scadeTutto){ Start-Sleep -Seconds 10 }
  if(-not $p.HasExited){
    $C.Interrotta = $true
    Write-Host ('   TETTO: alle ' + (Get-Date).ToString('HH:mm:ss') + ' il tester e ancora aperto. Lo chiudo con CloseMainWindow (MAI Stop-Process sul terminale).') -ForegroundColor Red
    try{ [void]$p.CloseMainWindow() }catch{ }
    $att = 0; while(-not $p.HasExited -and $att -lt 18){ Start-Sleep -Seconds 5; $att = $att + 1 }
  }
  Start-Sleep -Seconds 8   # l'agente del tester scarica i log su disco dopo la chiusura
  $C.Girata = $true
  $C.Sec = [int]((Get-Date) - $t0).TotalSeconds
  $C.Ora1 = (Get-Date).ToString('HH:mm:ss')
  Dico ('fine : ' + $C.Ora1 + '   durata ' + $C.Sec + ' s') 'Cyan'
  if($C.Interrotta){ $fermo = $true; $motivoFermo = ('tetto di ' + $TettoMin + ' minuti superato durante ' + $C.Id); [void]$C.C0Motivi.Add('corsa INTERROTTA dal tetto di tempo') }

  # --- lettura: solo quello che e' stato scritto DOPO la fotografia
  $reAvvio = New-Object Text.RegularExpressions.Regex('\[' + [Text.RegularExpressions.Regex]::Escape($S.Tag) + '\]\s+(avviato su .*?)\s*$')
  $reCfg   = New-Object Text.RegularExpressions.Regex('\[' + [Text.RegularExpressions.Regex]::Escape($S.Tag) + '\]\s+CONFIG IN USO -> (.*?)\s*$')
  $reLab   = New-Object Text.RegularExpressions.Regex('([A-Za-z0-9_]+) \(' + [Text.RegularExpressions.Regex]::Escape($S.Simbolo) + ',' + $PERIODO + '\)')
  $sb = New-Object Text.StringBuilder
  $rifK = @{}; $rinvK = @{}; $avvii = @{}; $labOk = 0; $labKo = @{}; $cfgs = @{}
  $coda = New-Object 'System.Collections.Generic.Queue[string]'
  foreach($f in @(ElencoLog)){
    $off = 0; if($foto.ContainsKey($f.FullName)){ $off = [long]$foto[$f.FullName] }
    if($f.Length -le $off){ continue }
    try{ $testo = LeggiCoda $f.FullName $off }catch{ $C.Illeggibili = $C.Illeggibili + 1; [void]$C.FileIlleggibili.Add($f.FullName); continue }
    $C.FileLetti = $C.FileLetti + 1
    [void]$sb.AppendLine('===== ' + $f.FullName + '   (letto dal byte ' + $off + ')')
    [void]$sb.AppendLine($testo)
    foreach($riga in ($testo -split "`r?`n")){
      if($riga.Length -eq 0){ continue }
      $coda.Enqueue($riga); if($coda.Count -gt 25){ [void]$coda.Dequeue() }
      if($reDeal.IsMatch($riga)){ $C.Deal = $C.Deal + 1 }
      if($reRif.IsMatch($riga)){
        $C.Rif = $C.Rif + 1
        $kk = Chiave $riga
        if(-not $rifK.ContainsKey($kk)){
          $rifK[$kk] = $true
          if($kk.Contains('2026.09.11')){ $C.Rif0911 = $C.Rif0911 + 1 }
          if($kk.Contains('2026.09.17')){ $C.Rif0917 = $C.Rif0917 + 1 }
          if($C.EsempiRif.Count -lt 5){ [void]$C.EsempiRif.Add($kk) }
          # C2: ticket e istante simulato al secondo di OGNI riga RIFIUTO
          $mt = $reTkRif.Match($riga); $md = $reData.Match($riga)
          if($mt.Success -and $md.Success){ $C.RifSet[($mt.Groups[1].Value + '|' + $md.Value)] = $true }
          else { $C.RifIlleggibili = $C.RifIlleggibili + 1 }
        }
      }
      if($reRinv.IsMatch($riga)){
        $C.Rinv = $C.Rinv + 1
        $kk = Chiave $riga
        if(-not $rinvK.ContainsKey($kk)){
          $rinvK[$kk] = $true
          $mt = $reTkRinv.Match($riga); $md = $reData.Match($riga)
          $tk = ''; $ts = ''
          if($mt.Success){ $tk = $mt.Groups[1].Value }
          if($md.Success){ $ts = $md.Value }
          [void]$C.RinvList.Add(@{ Riga=$kk; T=$tk; Ts=$ts })
        }
      }
      $ma = $reAvvio.Match($riga)
      if($ma.Success){
        $avvii[$ma.Groups[1].Value.Trim()] = $true
        $ml = $reLab.Match($riga)
        if($ml.Success){ if($ml.Groups[1].Value -eq $C.Nome){ $labOk = $labOk + 1 } else { $labKo[$ml.Groups[1].Value] = $true } }
      }
      $mc = $reCfg.Match($riga)
      if($mc.Success){ $cfgs[$mc.Groups[1].Value.Trim()] = $true }
      $mh = $reStoria.Match($riga)
      if($mh.Success){ $C.Storia[$mh.Groups[1].Value] = ($mh.Groups[2].Value + ' -> ' + $mh.Groups[3].Value) }
    }
  }
  $C.RifDist = $rifK.Count; $C.RinvDist = $rinvK.Count
  foreach($q in $coda){ [void]$C.Coda.Add($q) }
  $logOut = Join-Path $Cart ('LOG_' + $C.Id + '.txt')
  [IO.File]::WriteAllText($logOut, $sb.ToString(), (New-Object Text.UTF8Encoding($false)))

  # --- C0 b): avvio, etichetta del programma, CONFIG IN USO
  if($avvii.Count -eq 0){ [void]$C.C0Motivi.Add('riga d avvio [' + $S.Tag + '] NON trovata nei log') }
  foreach($av in @($avvii.Keys)){ if($av -ne $S.Avvio){ [void]$C.C0Motivi.Add('avvio letto "' + $av + '" invece di "' + $S.Avvio + '"') } }
  if($labOk -eq 0){ [void]$C.C0Motivi.Add('etichetta "' + $C.Nome + ' (' + $S.Simbolo + ',' + $PERIODO + ')" NON trovata sulla riga d avvio') }
  if($labKo.Count -gt 0){ [void]$C.C0Motivi.Add('etichetta DIVERSA sulla riga d avvio: ' + ((@($labKo.Keys)) -join ',') + ' (binario sbagliato)') }
  if($cfgs.Count -eq 0){ [void]$C.C0Motivi.Add('riga CONFIG IN USO NON trovata nei log') }
  $pezzi = @('motore=ABTG_RETEST |', ('| lati=' + $S.Lati + ' |'), '| rischio=1.00% |', '| trail=ABTG_TRAIL_PREVBAR PERIOD_M5 |', '| trail da=0.00R')
  foreach($cf in @($cfgs.Keys)){
    foreach($pz in $pezzi){ if(-not $cf.Contains($pz)){ [void]$C.C0Motivi.Add('CONFIG IN USO senza "' + $pz + '"') } }
    if(-not $cf.EndsWith('trail da=0.00R')){ [void]$C.C0Motivi.Add('CONFIG IN USO non finisce con "trail da=0.00R"') }
  }
  $C.Avvii = ((@($avvii.Keys)) -join ' || ')
  $C.Cfg = ((@($cfgs.Keys)) -join ' || ')

  # --- C0 c): il per-trade esiste ed e' scritto DOPO l'avvio della corsa
  if(-not (Test-Path -LiteralPath $ptVivo)){ [void]$C.C0Motivi.Add('per-trade ' + $C.PerTrade + ' NON trovato in Common\Files') }
  elseif((Get-Item -LiteralPath $ptVivo).LastWriteTime -lt $t0){ [void]$C.C0Motivi.Add('per-trade ' + $C.PerTrade + ' scritto PRIMA dell avvio della corsa') }
  else {
    $C.PtCopia = Join-Path $Cart $C.PerTrade
    Copy-Item -LiteralPath $ptVivo -Destination $C.PtCopia -Force
    $C.PtSha = Impronta $C.PtCopia
    $C.PtRighe = (@([IO.File]::ReadAllLines($C.PtCopia) | Where-Object { $_ -ne '' })).Count - 1
  }
  # --- C0 d): CATTURA DEL GIORNALE DI TRADING (classe 827). La riga d'avvio
  #     viene da OnInit e NON prova che le righe di trading siano nel log:
  #     con operazioni nel per-trade, il log della corsa deve avere almeno
  #     una riga di esecuzione del tester. Senza, uno zero di N0/N2 sarebbe
  #     il log che manca, non la raffica.
  if($C.PtRighe -gt 0 -and $C.Deal -eq 0){
    $C.C0dRosso = $true
    [void]$C.C0Motivi.Add('C0 d) per-trade con ' + $C.PtRighe + ' righe dati ma ZERO righe "' + $RE_DEAL + '" nel log della corsa: giornale di trading NON catturato')
    Dico ('C0 d) ROSSO: ultime ' + $C.Coda.Count + ' righe del log letto (per correggere la regex, se e lei):') 'Red'
    foreach($q in $C.Coda){ Write-Host ('     ' + $q) -ForegroundColor DarkYellow }
  }
  $C.C0 = ($C.C0Motivi.Count -eq 0)

  # --- il report della corsa, se MT5 l'ha scritto (non e' un cancello)
  foreach($rad in @($InstAttesa, $DataFolder)){
    if(-not (Test-Path -LiteralPath $rad)){ continue }
    $rep = @(Get-ChildItem -LiteralPath $rad -Filter ($C.Id + '*.htm*') -File -ErrorAction SilentlyContinue | Where-Object { $_.LastWriteTime -ge $t0 })
    if($rep.Count -gt 0){ Copy-Item -LiteralPath $rep[0].FullName -Destination $Cart -Force -ErrorAction SilentlyContinue; break }
  }

  $col = 'Green'; if(-not $C.C0){ $col = 'Red' }
  Dico ('log letti ' + $C.FileLetti + ' (illeggibili ' + $C.Illeggibili + ')   DEAL ' + $C.Deal + '   RIFIUTO ' + $C.Rif + ' (distinti ' + $C.RifDist + ')   RINVIO ' + $C.Rinv + ' (distinti ' + $C.RinvDist + ')   per-trade righe ' + $C.PtRighe)
  if($C.C0){ Dico ('C0 corsa: VERDE') $col } else { Dico ('C0 corsa: ROSSO -- ' + ($C.C0Motivi -join ' ; ')) $col }
}

# ---------------------------------------------------------------------
#  4. N3 -- StopsLevel / FreezeLevel dei tre simboli sul terminale del PC.
#     Lo script di SOLA LETTURA ABTG_PrevoloFTMO_Specifiche (file prova
#     par. 6), InpSelezionaSimboli=false: non aggiunge simboli a Market
#     Watch. Fail-soft: se non torna, N3 = [NON MISURATO qui], lo si dice.
# ---------------------------------------------------------------------
Titolo '4 - N3: StopsLevel e FreezeLevel sul terminale del PC'
$N3 = @{}; $N3Motivo = ''; $N3Conto = ''; $N3Fonte = ''
if($SenzaN3){ $N3Motivo = 'saltata su richiesta (-SenzaN3)' }
elseif((@(Get-Process -Name terminal64 -ErrorAction SilentlyContinue)).Count -gt 0){ $N3Motivo = 'un terminal64 e ancora vivo: N3 non si lancia' }
else {
  try{
    New-Item -ItemType Directory -Force -Path $MqlScr,$MqlPre,$MqlFil | Out-Null
    $n3Loc = Join-Path $Work ($N3_NOME + '.mq5')
    [void](Prendi $N3_REL $PINA_SRC $n3Loc $N3_SHA 'StopsLevelPts')
    $n3Mq5 = Join-Path $MqlScr ($N3_NOME + '.mq5')
    Copy-Item -LiteralPath $n3Loc -Destination $n3Mq5 -Force
    Compila $n3Mq5 (Join-Path $MqlScr ($N3_NOME + '.ex5')) (Join-Path $Work 'compile_N3.log')
    $setN3 = 'abtg_r254_n3.set'
    Set-Content -LiteralPath (Join-Path $MqlPre $setN3) -Value (@('InpTuttiISimboli=false','InpSelezionaSimboli=false','InpBcmOffsetUTC=1','InpDeltaAtteso=2') -join "`r`n") -Encoding Unicode
    $csvN3 = Join-Path $MqlFil 'PREVOLO_FTMO_specifiche.csv'
    if(Test-Path -LiteralPath $csvN3){ Rename-Item -LiteralPath $csvN3 -NewName ('PREVOLO_FTMO_specifiche.csv.pre_R254_' + (Get-Date).ToString('yyyyMMdd_HHmmss')) }
    $iniN3 = Join-Path $Work 'n3_startup.ini'
    $testoN3 = "[Experts]`r`nAllowLiveTrading=false`r`nAllowDllImport=false`r`nEnabled=true`r`n`r`n" +
               "[StartUp]`r`nScript=" + $N3_NOME + "`r`nScriptParameters=" + $setN3 + "`r`nSymbol=D30EUR`r`nPeriod=M5`r`n"
    Set-Content -LiteralPath $iniN3 -Value $testoN3 -Encoding Unicode
    $t0n = Get-Date
    Dico ('avvio N3: ' + $t0n.ToString('HH:mm:ss') + '. Se compare la finestra dei parametri dello script, premi OK SENZA toccare niente (InpSelezionaSimboli resta false).') 'Cyan'
    $pN = Start-Process -FilePath $Terminal -ArgumentList ('/config:"' + $iniN3 + '"') -PassThru
    $scadeN = $t0n.AddMinutes(3); $okN = $false
    while((Get-Date) -lt $scadeN){
      Start-Sleep -Seconds 5
      if((Test-Path -LiteralPath $csvN3) -and ((Get-Item -LiteralPath $csvN3).LastWriteTime -ge $t0n)){ Start-Sleep -Seconds 2; $okN = $true; break }
    }
    try{ [void]$pN.CloseMainWindow() }catch{ }
    $att = 0; while(-not $pN.HasExited -and $att -lt 18){ Start-Sleep -Seconds 5; $att = $att + 1 }
    if(-not $pN.HasExited){ Dico 'IL TERMINALE APERTO PER N3 NON SI E CHIUSO: chiudilo A MANO (File > Esci). MAI Stop-Process sul terminale.' 'Red' }
    if(-not $okN){ $N3Motivo = 'nessun PREVOLO_FTMO_specifiche.csv fresco entro 3 minuti' }
    else {
      Copy-Item -LiteralPath $csvN3 -Destination (Join-Path $Cart 'N3_PREVOLO_specifiche_PC.csv') -Force
      $N3Fonte = ('MQL5\Files\PREVOLO_FTMO_specifiche.csv scritto alle ' + (Get-Item -LiteralPath $csvN3).LastWriteTime.ToString('yyyy-MM-dd HH:mm:ss') + ' da ' + $N3_NOME + ' (SHA256 ' + $N3_SHA.Substring(0,16) + '...)')
      $righeN3 = @(Get-Content -LiteralPath $csvN3)
      $iSim = -1; $iStop = -1; $iFrz = -1; $inSim = $false
      foreach($rn3 in $righeN3){
        if($rn3 -match '^Conto,(\d+),'){ $N3Conto = $Matches[1] }
        if($rn3.StartsWith('Mercato,Simbolo,')){
          $h = $rn3.Split(','); $inSim = $true
          for($j = 0; $j -lt $h.Count; $j++){ if($h[$j] -eq 'Simbolo'){ $iSim = $j }; if($h[$j] -eq 'StopsLevelPts'){ $iStop = $j }; if($h[$j] -eq 'FreezeLevelPts'){ $iFrz = $j } }
          continue
        }
        if($inSim -and $rn3.Trim() -eq ''){ $inSim = $false; continue }
        if($inSim -and $iSim -ge 0 -and $iStop -ge 0 -and $iFrz -ge 0){
          $cc = $rn3.Split(',')
          if($cc.Count -gt [math]::Max($iStop,$iFrz)){
            foreach($sy in @('D30EUR','U30USD','NASUSD')){ if($cc[$iSim] -eq $sy){ $N3[$sy] = @{ Stops=$cc[$iStop]; Freeze=$cc[$iFrz] } } }
          }
        }
      }
      if($N3.Count -eq 0){ $N3Motivo = 'CSV letto ma nessuna riga D30EUR/U30USD/NASUSD nella sezione [SIMBOLI]' }
    }
  }catch{ $N3Motivo = ('errore: ' + $_.Exception.Message) }
}
foreach($sy in @('D30EUR','U30USD','NASUSD')){
  if($N3.ContainsKey($sy)){ Dico ($sy + '  StopsLevel ' + $N3[$sy].Stops + ' pt   FreezeLevel ' + $N3[$sy].Freeze + ' pt') 'Green' }
  else { Dico ($sy + '  [NON MISURATO qui] ' + $N3Motivo) 'DarkYellow' }
}
if($N3Conto -ne ''){ Dico ('conto letto dallo script N3: ' + $N3Conto + '   (atteso il demo 50503392)') }

# ---------------------------------------------------------------------
#  5. N1 E L'ESITO PER SEDIA, nell'ordine del file prova
# ---------------------------------------------------------------------
function ConfrontaPerTrade($pPin, $pPina, $magPin, $magPina){
  $r = @{ Esito='NON CALCOLABILE'; Nota=''; RighePin=-1; RighePina=-1; Diff=(New-Object System.Collections.ArrayList); MappaPinaPin=@{} }
  if($pPin -eq '' -or $pPina -eq '' -or -not (Test-Path -LiteralPath $pPin) -or -not (Test-Path -LiteralPath $pPina)){ $r.Nota = 'manca almeno uno dei due per-trade'; return $r }
  $a = @([IO.File]::ReadAllLines($pPin)  | Where-Object { $_ -ne '' })
  $b = @([IO.File]::ReadAllLines($pPina) | Where-Object { $_ -ne '' })
  $r.RighePin = $a.Count - 1; $r.RighePina = $b.Count - 1
  if((Impronta $pPin) -eq (Impronta $pPina)){ $r.Esito = 'VERDE'; $r.Nota = 'IDENTICI BYTE PER BYTE (SHA256 uguale)'; return $r }
  if($a.Count -ne $b.Count){
    $r.Esito = 'ROSSO'; $r.Nota = 'numero di righe diverso'
    $m = [math]::Min($a.Count, $b.Count)
    for($i = 0; $i -lt $m -and $r.Diff.Count -lt 3; $i++){ if($a[$i] -cne $b[$i]){ [void]$r.Diff.Add('riga ' + $i + ': PIN [' + $a[$i] + ']  PINA [' + $b[$i] + ']') } }
    if($r.Diff.Count -lt 3){
      if($a.Count -gt $m){ [void]$r.Diff.Add('riga ' + $m + ': PIN [' + $a[$m] + ']  PINA [assente]') }
      else { [void]$r.Diff.Add('riga ' + $m + ': PIN [assente]  PINA [' + $b[$m] + ']') }
    }
    return $r
  }
  $pidDiversi = $false; $altro = $false; $biett = $true; $m1 = @{}; $m2 = @{}
  if($a[0] -cne $b[0]){ $altro = $true; [void]$r.Diff.Add('intestazione: PIN [' + $a[0] + ']  PINA [' + $b[0] + ']') }
  for($i = 1; $i -lt $a.Count; $i++){
    $ca = $a[$i].Split(';'); $cb = $b[$i].Split(';'); $rigaDiversa = $false
    if($ca.Count -ne 8 -or $cb.Count -ne 8){ $altro = $true; $rigaDiversa = $true }
    else {
      for($k = 0; $k -lt 8; $k++){
        if($k -eq 3){ continue }
        if($k -eq 2 -and $magPin -ne $magPina){
          if($ca[2] -cne $magPin -or $cb[2] -cne $magPina){ $altro = $true; $rigaDiversa = $true }
          continue
        }
        if($ca[$k] -cne $cb[$k]){ $altro = $true; $rigaDiversa = $true }
      }
      $pa = $ca[3]; $pb = $cb[3]
      if($pa -cne $pb){ $pidDiversi = $true; $rigaDiversa = $true }
      if($m1.ContainsKey($pa)){ if($m1[$pa] -cne $pb){ $biett = $false } } else { $m1[$pa] = $pb }
      if($m2.ContainsKey($pb)){ if($m2[$pb] -cne $pa){ $biett = $false } } else { $m2[$pb] = $pa }
    }
    if($rigaDiversa -and $r.Diff.Count -lt 3){ [void]$r.Diff.Add('riga ' + $i + ': PIN [' + $a[$i] + ']  PINA [' + $b[$i] + ']') }
  }
  if($altro){ $r.Esito = 'ROSSO'; $r.Nota = 'differenze fuori da position_id'; return $r }
  if(-not $biett){ $r.Esito = 'ROSSO'; $r.Nota = 'solo position_id diverso, ma la corrispondenza PIN -> PINA NON e biunivoca e costante'; return $r }
  if($pidDiversi){ $r.Esito = 'VERDE PER RINUMERAZIONE'; $r.Nota = 'righe tante quante, stesso ordine, diverso SOLO position_id con corrispondenza biunivoca e costante'; $r.MappaPinaPin = $m2; return $r }
  $r.Esito = 'ROSSO'; $r.Nota = 'SHA256 diverso ma le 8 colonne coincidono riga per riga: differenza di byte non spiegata'
  return $r
}

function ValutaC2($cp, $ca, $n1){
  # C2 L'INSIEME BLOCCATO: ogni riga RINVIO della PINA (T, t) deve avere
  # nel PIN una riga RIFIUTO con lo stesso ticket (tradotto con la mappa di
  # N1 se VERDE PER RINUMERAZIONE) allo stesso istante simulato al secondo.
  # Un fatto batte un difetto del lettore: una RINVIO leggibile senza
  # gemella, con TUTTE le RIFIUTO del PIN leggibili, e ROSSO anche se altre
  # righe sono illeggibili. Altrimenti un buco di lettura da NON MISURABILE.
  $r = @{ Stato='NON MISURABILE'; Tot=$ca.RinvList.Count; Con=0; Senza=0; Illeggibili=0; NonTradotti=0; PrimaSenza=''; Nota='' }
  if($r.Tot -eq 0){ $r.Nota = 'nessuna riga RINVIO nella PINA'; return $r }
  $rinum = ($n1.Esito -eq 'VERDE PER RINUMERAZIONE')
  foreach($x in $ca.RinvList){
    if($x.T -eq '' -or $x.Ts -eq ''){ $r.Illeggibili = $r.Illeggibili + 1; continue }
    $tp = $x.T
    if($rinum){
      if($n1.MappaPinaPin.ContainsKey($x.T)){ $tp = $n1.MappaPinaPin[$x.T] } else { $r.NonTradotti = $r.NonTradotti + 1; continue }
    }
    if($cp.RifSet.ContainsKey($tp + '|' + $x.Ts)){ $r.Con = $r.Con + 1 }
    else { $r.Senza = $r.Senza + 1; if($r.PrimaSenza -eq ''){ $r.PrimaSenza = $x.Riga + '   (ticket PIN cercato ' + $tp + ')' } }
  }
  if($r.Senza -gt 0 -and $cp.RifIlleggibili -eq 0 -and $cp.Illeggibili -eq 0){ $r.Stato = 'ROSSO'; $r.Nota = 'almeno una RINVIO senza RIFIUTO gemella nel PIN: la guardia ha trattenuto una modify che il tester accettava'; return $r }
  if($r.Senza -gt 0 -or $r.Illeggibili -gt 0 -or $r.NonTradotti -gt 0){
    $r.Nota = 'RINVIO illeggibili ' + $r.Illeggibili + ', ticket non traducibili con la mappa di N1 ' + $r.NonTradotti + ', senza gemella ' + $r.Senza + ' con ' + $cp.RifIlleggibili + ' RIFIUTO del PIN senza ticket/istante leggibili, ' + $cp.Illeggibili + ' file di log del PIN illeggibili'
    return $r
  }
  if($ca.Illeggibili -gt 0 -or $cp.Illeggibili -gt 0){
    $r.Nota = 'file di log illeggibili: PIN ' + $cp.Illeggibili + ', PINA ' + $ca.Illeggibili + ' -- righe RIFIUTO/RINVIO forse non lette: N2 e C2 non si certificano verdi su una lettura incompleta (classe 829)'
    return $r
  }
  $r.Stato = 'VERDE'; $r.Nota = 'ogni RINVIO ha la sua RIFIUTO gemella nel PIN'
  return $r
}

Titolo '5 - ESITO PER SEDIA (ordine del file prova: C0, N1, N0, N2, C1, C2)'
$esitoSedia = @{}
foreach($S in $SEDIE){
  $cp = @($CORSE | Where-Object { $_.Sedia.Id -eq $S.Id -and $_.Tipo -eq 'PIN' })[0]
  $ca = @($CORSE | Where-Object { $_.Sedia.Id -eq $S.Id -and $_.Tipo -eq 'PINA' })[0]
  $n1 = ConfrontaPerTrade $cp.PtCopia $ca.PtCopia $cp.Magic $ca.Magic
  $c0 = ($cp.C0 -and $ca.C0)
  $n0 = ($cp.Rif -gt 0)
  $n2 = ($ca.Rif -eq 0)
  $c1 = ($ca.Rinv -gt 0)
  $c2 = ValutaC2 $cp $ca $n1
  if(-not $c0){ $es = 'PROVA NULLA (C0 rosso: si rifa la corsa)' }
  elseif($n1.Esito -eq 'ROSSO' -or $n1.Esito -eq 'NON CALCOLABILE'){ $es = 'NON NEUTRA (N1 rosso: la guardia cambia i deal. NON SI SCHIERA)' }
  elseif(-not $n0){ $es = 'NON MISURATA (N0 rosso: nessun RIFIUTO nel PIN, deal uguali non provano niente)' }
  elseif(-not $n2){ $es = 'NEUTRA SUI DEAL, RAFFICA NON AZZERATA (N2 rosso: righe RIFIUTO residue da classificare)' }
  elseif(-not $c1){ $es = 'PROVA NULLA (C1 rosso: zero righe RINVIO nella PINA)' }
  elseif($c2.Stato -eq 'ROSSO'){ $es = 'NON NEUTRA (C2 rosso: la guardia ha trattenuto una modify che il tester accettava. NON SI SCHIERA)' }
  elseif($c2.Stato -eq 'NON MISURABILE'){ $es = 'NEUTRA SUI DEAL, BLOCCATO NON VERIFICATO (C2 non misurabile: NON e NEUTRA, non copre il file)' }
  else { $es = 'NEUTRA' }
  $S.N1 = $n1; $S.C2 = $c2; $S.Esito = $es
  $esitoSedia[$S.Sedia] = $es
  $col = 'Yellow'; if($es -eq 'NEUTRA'){ $col = 'Green' } elseif($es.StartsWith('PROVA NULLA') -or $es.StartsWith('NON NEUTRA')){ $col = 'Red' }
  Dico ('sedia ' + $S.Sedia + ' (' + $S.Simbolo + ', ' + $S.Lati + '):  ' + $es) $col
  Dico ('      N1: ' + $n1.Esito + ' -- ' + $n1.Nota + '   righe dati PIN ' + $n1.RighePin + '  PINA ' + $n1.RighePina)
  foreach($d in $n1.Diff){ Dico ('          ' + $d) }
  Dico ('      N0: RIFIUTO PIN ' + $cp.Rif + '   N2: RIFIUTO PINA ' + $ca.Rif + '   C1: RINVIO PINA ' + $ca.Rinv)
  Dico ('      C2: RINVIO ' + $c2.Tot + ', con gemella ' + $c2.Con + ', senza ' + $c2.Senza + ' -> ' + $c2.Stato + '   ' + $c2.Nota)
  if($c2.PrimaSenza -ne ''){ Dico ('      prima RINVIO senza gemella: ' + $c2.PrimaSenza) }
}

$pacchetti = @(
  @{ Nome='CLAU12_DAX_Apertura_EU';    Sedie=@('770101','770105') },
  @{ Nome='CLAU12_Dow_Apertura_US';    Sedie=@('770202') },
  @{ Nome='CLAU12_Nasdaq_Apertura_US'; Sedie=@('770260') }
)
$righePac = New-Object System.Collections.ArrayList
foreach($P in $pacchetti){
  $tutte = $true; $det = @()
  foreach($sd in $P.Sedie){ $det = $det + @($sd + '=' + $esitoSedia[$sd]); if($esitoSedia[$sd] -ne 'NEUTRA'){ $tutte = $false } }
  if($tutte){ $t = $P.Nome + ': COPERTO (tutte le sue sedie NEUTRA)' }
  else { $t = $P.Nome + ': NON COPERTO -- ' + ($det -join ' ; ') + '. La decisione passa a Claudio.' }
  [void]$righePac.Add($t)
  $col = 'Yellow'; if($tutte){ $col = 'Green' }
  Dico $t $col
}

# ---------------------------------------------------------------------
#  6. RIEPILOGO_R254.txt, ZIP, ELENCO DEI FILE ATTESI
# ---------------------------------------------------------------------
Titolo '6 - RIEPILOGO E RACCOLTA'
$T_FINE = Get-Date
$R = New-Object System.Collections.ArrayList
[void]$R.Add('R254 -- PROVA DI NEUTRALITA DELLA TRAILFIX -- PASSATA_TRAILFIX.ps1 (MARCATORE_PASSATA_TRAILFIX_v1)')
[void]$R.Add('data: ' + $T_FINE.ToString('yyyy-MM-dd HH:mm:ss') + '   pc: ' + $env:COMPUTERNAME + '   terminale: ' + $Terminal)
[void]$R.Add('inizio ' + $T_INIZIO.ToString('HH:mm:ss') + '   fine ' + $T_FINE.ToString('HH:mm:ss') + '   durata totale ' + [int]($T_FINE - $T_INIZIO).TotalMinutes + ' min   tetto corse ' + $TettoMin + ' min')
[void]$R.Add('pin file prova: ' + $Pin + '   pin PIN: ' + $PIN_SRC + '   pin PINA: ' + $PINA_SRC)
[void]$R.Add('corsa singola, Model=4 tick reali, Optimization=0, ' + $DA + ' -> ' + $A + ', deposito ' + $DEPOSITO + ' EUR, leva 100, AllowLiveTrading=false: nessun ordine, nessun conto toccato')
[void]$R.Add('regex RIFIUTO (case-insensitive): ' + $RE_RIFIUTO + '   regex RINVIO: ' + $RE_RINVIO + '   regex DEAL (C0 d): ' + $RE_DEAL)
[void]$R.Add('')
[void]$R.Add('--- C0 a) SORGENTI (SHA256 dichiarato / scaricato / copiato in MQL5\Experts e compilato)')
foreach($k in $ORDINE_SRC){
  $so = $SORGENTI[$k]
  [void]$R.Add('   ' + $so.Tipo.PadRight(4) + ' ' + $so.Nome.PadRight(27) + ' ' + $so.Rel + ' @ ' + $so.Commit.Substring(0,8))
  [void]$R.Add('        dichiarato ' + $so.Sha + '   scaricato ' + $so.ShaScaricato + '   compilato ' + $so.ShaCompilato + '   righe ' + $so.RigheLette + '/' + $so.Righe + '   ex5 ' + $so.Ex5.Length + ' byte')
}
[void]$R.Add('   include ABTG_PausaGuardian.mqh  dichiarato ' + $INC_SHA + '   scaricato ' + $incSha)
[void]$R.Add('   file prova (SHA256 al pin ' + $Pin + '):')
foreach($fn in @($provaSha.Keys | Sort-Object)){ [void]$R.Add('      ' + $fn.PadRight(32) + ' ' + $provaSha[$fn]) }
[void]$R.Add('')
foreach($C in $CORSE){
  [void]$R.Add('--- CORSA ' + $C.Id + '  sedia ' + $C.Sedia.Sedia + '  ' + $C.Nome + '.ex5  ' + $C.Sedia.Simbolo + ' ' + $PERIODO + '  magic ' + $C.Magic + '  (' + $C.Prova + ')')
  if(-not $C.Girata){ [void]$R.Add('   ' + $C.Motivo); [void]$R.Add(''); continue }
  [void]$R.Add('   avvio ' + $C.Ora0 + '  fine ' + $C.Ora1 + '  durata ' + $C.Sec + ' s  interrotta dal tetto: ' + $C.Interrotta + '   log letti ' + $C.FileLetti + '  illeggibili ' + $C.Illeggibili)
  foreach($fi in $C.FileIlleggibili){ [void]$R.Add('   log ILLEGGIBILE: ' + $fi) }
  [void]$R.Add('   DEAL righe ' + $C.Deal + '   RIFIUTO righe ' + $C.Rif + ' (distinte ' + $C.RifDist + ', senza ticket/istante leggibili ' + $C.RifIlleggibili + ')   RINVIO righe ' + $C.Rinv + ' (distinte ' + $C.RinvDist + ')')
  if($C.C0dRosso){
    [void]$R.Add('   C0 d) ROSSO -- ultime righe del log letto:')
    foreach($q in $C.Coda){ [void]$R.Add('      | ' + $q) }
  }
  [void]$R.Add('   aggancio INFORMATIVO (non e un cancello): RIFIUTO distinte datate 2026.09.11: ' + $C.Rif0911 + '   2026.09.17: ' + $C.Rif0917)
  foreach($e in $C.EsempiRif){ [void]$R.Add('      es. RIFIUTO: ' + $e) }
  if($C.Tipo -eq 'PIN' -and $C.Rinv -gt 0){ [void]$R.Add('   ATTENZIONE (informativo): righe RINVIO in una corsa PIN, che la guardia non ce l ha') }
  if($C.Storia.Count -eq 0){ [void]$R.Add('   storico tick: riga "history ticks synchronized" NON letta') }
  foreach($sy in @($C.Storia.Keys)){
    $t = '   storico tick ' + $sy + ': ' + $C.Storia[$sy]
    if($sy -eq $C.Sedia.Simbolo){
      $fin = ($C.Storia[$sy] -split ' -> ')[1]
      if($fin -lt '2026.09.17'){ $t = $t + '   <- ultimo tick PRIMA del 2026.09.17: la finestra NON contiene le raffiche di campo' }
    }
    [void]$R.Add($t)
  }
  [void]$R.Add('   avvio letto : ' + $C.Avvii)
  [void]$R.Add('   CONFIG letto: ' + $C.Cfg)
  [void]$R.Add('   per-trade   : ' + $C.PerTrade + '   righe dati ' + $C.PtRighe + '   SHA256 ' + $C.PtSha)
  if($C.C0){ [void]$R.Add('   C0 corsa: VERDE') } else { [void]$R.Add('   C0 corsa: ROSSO -- ' + ($C.C0Motivi -join ' ; ')) }
  [void]$R.Add('')
}
[void]$R.Add('--- N3 (non e un cancello di esito) -- fonte: ' + $N3Fonte)
foreach($sy in @('D30EUR','U30USD','NASUSD')){
  if($N3.ContainsKey($sy)){
    $ramo = '[NON LEGGIBILE]'
    if($N3[$sy].Stops -eq '0'){ $ramo = 'ramo k=0 (quello di FTMO)' } elseif($N3[$sy].Stops -match '^[1-9][0-9]*$'){ $ramo = 'ramo k>0 (tolleranza di mezzo punto)' }
    [void]$R.Add('   ' + $sy + '  StopsLevel ' + $N3[$sy].Stops + ' pt  FreezeLevel ' + $N3[$sy].Freeze + ' pt  -> ' + $ramo)
  } else { [void]$R.Add('   ' + $sy + '  [NON MISURATO qui] ' + $N3Motivo + ' -> quale ramo della guardia e stato provato: [NON MISURATO]') }
}
if($N3Conto -ne ''){ [void]$R.Add('   conto letto dallo script N3: ' + $N3Conto) }
[void]$R.Add('')
[void]$R.Add('--- ESITO PER SEDIA (C0 -> N1 -> N0 -> N2 -> C1 -> C2 rosso -> C2 non misurabile -> NEUTRA, il primo che scatta decide)')
foreach($S in $SEDIE){
  $cp = @($CORSE | Where-Object { $_.Sedia.Id -eq $S.Id -and $_.Tipo -eq 'PIN' })[0]
  $ca = @($CORSE | Where-Object { $_.Sedia.Id -eq $S.Id -and $_.Tipo -eq 'PINA' })[0]
  [void]$R.Add('   sedia ' + $S.Sedia + ' (' + $S.Simbolo + ', ' + $S.Lati + ')')
  [void]$R.Add('      C0  PIN ' + $cp.C0 + '  PINA ' + $ca.C0)
  [void]$R.Add('      N1  ' + $S.N1.Esito + ' -- ' + $S.N1.Nota + '   righe dati PIN ' + $S.N1.RighePin + '  PINA ' + $S.N1.RighePina)
  foreach($d in $S.N1.Diff){ [void]$R.Add('          ' + $d) }
  [void]$R.Add('      N0  RIFIUTO nel PIN  = ' + $cp.Rif + '  -> ' + $(if($cp.Rif -gt 0){ 'VERDE' } else { 'ROSSO' }))
  [void]$R.Add('      N2  RIFIUTO nella PINA = ' + $ca.Rif + '  -> ' + $(if($ca.Rif -eq 0){ 'VERDE' } else { 'ROSSO' }))
  [void]$R.Add('      C1  RINVIO nella PINA  = ' + $ca.Rinv + '  -> ' + $(if($ca.Rinv -gt 0){ 'VERDE' } else { 'ROSSO' }) + '  (conta solo se N0, N1, N2 verdi)')
  [void]$R.Add('      C2  RINVIO distinte ' + $S.C2.Tot + ', con RIFIUTO gemella ' + $S.C2.Con + ', senza ' + $S.C2.Senza + ', illeggibili ' + $S.C2.Illeggibili + ', non traducibili ' + $S.C2.NonTradotti + '  -> ' + $S.C2.Stato + '  (conta solo se N0, N1, N2, C1 verdi) -- ' + $S.C2.Nota)
  if($S.C2.PrimaSenza -ne ''){ [void]$R.Add('          prima RINVIO senza gemella: ' + $S.C2.PrimaSenza) }
  [void]$R.Add('      >>> ESITO: ' + $S.Esito)
}
[void]$R.Add('')
[void]$R.Add('--- IL PACCHETTO (ogni file CLAU12 coperto SOLO dalle sue sedie NEUTRA, niente analogia fra file)')
foreach($t in $righePac){ [void]$R.Add('   ' + $t) }
[void]$R.Add('')
[void]$R.Add('Questo round NON promuove niente, NON tocca taglie ne preset, NON tocca nessuna sedia in campo.')
[void]$R.Add('[NON VERIFICATO]: storico tick fino al 25/09; formato delle righe di rifiuto in corsa singola; etichetta')
[void]$R.Add('"<programma> (<simbolo>,M5)" sulla riga d avvio in corsa singola; forma del ticket nelle righe RIFIUTO/RINVIO (C2);')
[void]$R.Add('scarico dei log entro 8 s; N3 via [StartUp].')
($R -join "`r`n") | Set-Content -LiteralPath (Join-Path $Cart 'RIEPILOGO_R254.txt') -Encoding ASCII

$zip = Join-Path $dsk 'PASSATA_TRAILFIX.zip'
if(Test-Path -LiteralPath $zip){ Remove-Item -LiteralPath $zip -Force -ErrorAction SilentlyContinue }
Compress-Archive -Path (Join-Path $Cart '*') -DestinationPath $zip -Force

Write-Host ''
Write-Host 'FILE ATTESI NELLA CARTELLA (e nello zip):' -ForegroundColor Cyan
$attesi = New-Object System.Collections.ArrayList
foreach($C in $CORSE){ [void]$attesi.Add('LOG_' + $C.Id + '.txt') }
foreach($C in $CORSE){ [void]$attesi.Add($C.PerTrade) }
foreach($C in $CORSE){ [void]$attesi.Add($C.Id + '.ini') }
[void]$attesi.Add('RIEPILOGO_R254.txt')
$mancano = 0
foreach($fa in $attesi){
  if(Test-Path -LiteralPath (Join-Path $Cart $fa)){ Write-Host ('   OK     ' + $fa) -ForegroundColor Green }
  else { Write-Host ('   MANCA  ' + $fa) -ForegroundColor Red; $mancano = $mancano + 1 }
}
Write-Host ('   (in piu, se presenti: compile_*.log, N3_PREVOLO_specifiche_PC.csv, report R254*.htm)') -ForegroundColor Gray
Write-Host ('   attesi ' + $attesi.Count + ', mancanti ' + $mancano) -ForegroundColor Gray
Write-Host ''
Write-Host ('ZIP PRONTO DA MANDARE: ' + $zip) -ForegroundColor Green
Write-Host ('durata totale: ' + [int]($T_FINE - $T_INIZIO).TotalMinutes + ' minuti') -ForegroundColor Gray
