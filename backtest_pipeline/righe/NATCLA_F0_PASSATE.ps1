# =====================================================================
#  MARCATORE_NATCLA_F0_PASSATE_v1
#  NATCLA_F0_PASSATE.ps1 -- PASSO 0 (F0) DI 'Ea Nat&Cla': IL CONTEGGIO DEI SETUP, PASSATA PER PASSATA
#
#  CHE COSA FA, e una cosa sola:
#    per ogni (simbolo, configurazione) di UN LOTTO del file prova
#    backtest_pipeline/prove/NATCLA_F0_conteggio_2026-10-07.txt lancia UNA
#    passata SINGOLA del tester (Optimization=0, Model=1 = OHLC su M1,
#    InpSoloConta=true: l'EA valuta tutto, scrive una riga CONTA per ogni
#    barra che tocca la linea in MQL5\Files\natcla_setup_<simbolo>_<magic>.csv
#    e NON manda nessun ordine), poi RACCOGLIE il CSV, le righe dell'EA dal
#    log (AVVIO, VERIFICA ADX, avvisi) e le mette in un zip sul Desktop.
#    NON giudica niente: la tabella (setup/anno, ADX, costo, inclinazione,
#    confronto con le attese scritte PRIMA) la fa leggi_natcla_f0.py.
#
#  PERCHE' NON IL DRIVER DEI ROUND (RIGA_ROUND_VPS_RETRY.ps1 +
#  walkforward_generico_RETRY.ps1, quello di R280): MISURATO sul sorgente.
#   (a) il driver dei round scrive SEMPRE Optimization=1 (r.1258 e r.2315 del
#       RETRY: 'Con Optimization=1 e ZERO parametri ottimizzabili MT5 non
#       esegue NESSUNA passata');
#   (b) EA_NatCla.mq5 scrive il CSV dei setup SOLO fuori dall'ottimizzazione
#       (r.1216: 'if(!MQLInfoInteger(MQL_OPTIMIZATION))');
#   (c) in ottimizzazione l'unico output dell'EA e' OptFrame, con Trades=0
#       in SoloConta: il passo 0 uscirebbe VUOTO, e un 'Trades=0' letto come
#       'nessun setup' sarebbe l'errore del verdetto PostNews del 07/08.
#   Il driver dei round non si tocca (SHA256 pinnati da R92BAB/R280): questo
#   e' uno script NUOVO, derivato da PASSATA_STOP_SUPREV_NAS.ps1 (passata
#   singola, passata dal cancello, stessa famiglia di guardie).
#
#  DEVIAZIONI da PASSATA_STOP_SUPREV_NAS.ps1, tutte dichiarate:
#   1. UN LOTTO di passate (simboli x configurazioni del file prova) invece di
#      una sola: i lotti sono nei blocchi '# @F0-LOTTO' del file prova (la SOLA
#      fonte: nessuna lista doppia nello script). Simboli esterni, finestre
#      per classe, magic e TF per configurazione sono nei blocchi
#      '# @F0-SIMBOLO' e '# @F0-CONFIG'.
#   2. Model=1 (OHLC su M1), non tick reali: il passo 0 CONTA, le barre possono
#      solo bocciare (specifica 5.1).
#   3. EA, include e file prova scaricati al pin e controllati per SHA256 PASSATO
#      DALLA RIGA (-ShaEA -ShaInc -ShaProva, calcolati dal commit): non basta
#      una firma di testo (classe 166). Piu': NC_VER = 1.04 nel sorgente.
#   4. Un solo giro alla volta: Mutex 'Global\ABTG_NATCLA_F0' (classe 853: la
#      guardia sui processi MT5 e una FOTO, non un lucchetto).
#   5. Nessuna misura di spread/G0: qui non c'e' G0 (nessun numero atteso da
#      riprodurre). Al suo posto i controlli PER PASSATA: riga AVVIO dell'EA
#      (versione 1.04, modalita', simbolo, TF, magic, unita' per classe, linee,
#      ADX, 'solo conta SI'), riga VERIFICA ADX ('il terminale coincide con:
#      formula MetaQuotes'), finestra girata letta dal giornale del tester
#      ('from .. to ..'), CSV fresco con intestazione e righe CONTA.
#   6. MetaEditor: l'esito e' l'esistenza dell'.ex5; il log di compilazione e'
#      LETTO ('Result: N errors, M warnings') e stampato, e finisce nello zip:
#      e' la PRIMA COMPILAZIONE VERA di EA_NatCla (mai provata prima).
#   7. Il CSV si cerca in Common\Files e, se manca, negli agenti locali del
#      tester; e deve essere SCRITTO DOPO l'avvio della passata (un file di una
#      corsa precedente non vale: classe 1019/1032). Niente viene cancellato.
#   8. Zip e cartella per lotto (NATCLA_F0_<lotto>): se esistono gia' si
#      RINOMINANO con la data, mai si cancellano (sono ore di macchina).
#   9. Tetto di minuti per lotto (dal file prova): oltre il tetto NON si lancia
#      la passata dopo (il tetto ferma l'avvio, non la fine). Una passata
#      che supera TimeoutRunMin si chiude con CloseMainWindow (MAI Stop-Process
#      sul terminale); se il terminale non muore, il lotto si ferma.
#  10. TLS 1.2 impostato QUI DENTRO (classe 1156: la riga lo imposta nel suo
#      processo, questo script gira in un powershell.exe FIGLIO).
#  11. La scoperta ricorsiva dei .log si fa UNA VOLTA a inizio lotto (come la passata NAS) e a ogni passata si rileggono solo le cartelle trovate piu' i
#      percorsi noti degli agenti (Tester\*\Agent-*\logs): ricorsione su tutto %APPDATA%\MetaQuotes, con le cartelle dei tick, due volte per passata x 216 = ore.
#  12. Nessun report .htm (niente Report= nel .ini): senza ordini non c'e' niente da leggere, e 216 report con i grafici sporcherebbero il terminale.
#  INVARIATI: guardia macchina DESKTOP-H4D7CAJ, tutti gli MT5 e MetaEditor
#  chiusi (le due installazioni censite il 05/10 sono ammesse PER NOME,
#  classe 1157), nessuna installazione non censita, cartella dati risolta per
#  origin.txt, nessun EA sui grafici salvati del terminale BCM, AllowLiveTrading=false,
#  fotografia dei log prima di ogni passata e lettura della sola coda.
#
#  E' UN BACKTEST, NON UN ORDINE. [Experts] AllowLiveTrading=false nel .ini e
#  InpSoloConta=true nell'EA: il terminale del PC di backtest e' loggato sul
#  DEMO 50503392 e il 14/08/2026 da questa macchina sono partiti ordini VERI.
#
#  NON TOCCA, per nome: PRIMA SU QUESTO PC le installazioni C:\MT5_Backtest
#  (cartella dati 04C7A32B) e C:\FundedNext_Manuale (cartella dati 2B8180C3);
#  POI il VPS VMI3047753 e TUTTE le sue cartelle dati (FTMO 541452707 in
#  C:\FTMO, trial 1514806751, REALE 10105439 in C:\BCM_Reale, 100k 50504263,
#  piccolo 50503392 sul VPS, manuale 50503635 in C:\MT5_MANUALE, banco
#  50504400 in C:\MT5_Backtest, Pepperstone, Tickmill). Scrive SOLO: la cartella
#  %USERPROFILE%\abtg_passata, MQL5\Experts e MQL5\Include del terminale BCM di
#  questa macchina, il Desktop. I file natcla_setup_* in Common\Files li scrive
#  l'EA nel tester, e questo script li COPIA (non li cancella ne' li sposta).
#  NON legge ne' scrive conti, ordini, posizioni, preset di nessuna sedia.
#  NON tocca CODA.txt ne' il runner notturno (che gira sul VPS).
#
#  NIENTE EMOJI QUI DENTRO (regola del 17/08): Windows PowerShell 5.1 legge i
#  .ps1 come ANSI e un'emoji dentro una stringa rompe il parser.
# =====================================================================
[CmdletBinding()]
param(
  [Parameter(Mandatory=$true)][string]$Pin,
  [Parameter(Mandatory=$true)][string]$Lotto,
  [Parameter(Mandatory=$true)][string]$ShaEA,
  [Parameter(Mandatory=$true)][string]$ShaInc,
  [Parameter(Mandatory=$true)][string]$ShaProva,
  [int]$TimeoutRunMin = 20
)

$ErrorActionPreference = 'Stop'
$IC = [Globalization.CultureInfo]::InvariantCulture
[Threading.Thread]::CurrentThread.CurrentCulture   = $IC
[Threading.Thread]::CurrentThread.CurrentUICulture = $IC
[Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12

$EXPERT = 'EA_NatCla'
$PROVA  = 'NATCLA_F0_conteggio_2026-10-07.txt'
$VERSIONE_ATTESA = '1.04'
$DATA_A = '2026.06.30'
$ASSE_ATTESO = 'InpMagic=0||0||1||1||Y'
$N_PIN_ATTESI = 71
if($Pin -notmatch '^[0-9a-fA-F]{40}$'){ throw '-Pin obbligatorio e di 40 caratteri esadecimali: senza, girerebbe la punta del branch spacciandola per un commit congelato.' }
$Pin = $Pin.ToLower()
if($Lotto -notmatch '^(PILOTA|A|B|C|D)$'){ throw ('-Lotto deve essere PILOTA, A, B, C o D (e ' + $Lotto + ').') }
foreach($hx in @($ShaEA, $ShaInc, $ShaProva)){ if($hx -notmatch '^[0-9a-fA-F]{64}$'){ throw '-ShaEA, -ShaInc e -ShaProva devono essere di 64 caratteri esadecimali (SHA256 calcolato dal commit, mai dal disco).' } }
$ShaEA = $ShaEA.ToUpper(); $ShaInc = $ShaInc.ToUpper(); $ShaProva = $ShaProva.ToUpper()
if($TimeoutRunMin -lt 5 -or $TimeoutRunMin -gt 60){ throw '-TimeoutRunMin fuori da 5-60 minuti.' }
$RAW = 'https://raw.githubusercontent.com/claudiospadaro12/GITHUB/' + $Pin + '/'

function Dico($t,$c='Gray'){ Write-Host ('   ' + $t) -ForegroundColor $c }
function Titolo($t){ Write-Host ''; Write-Host ('=== ' + $t + ' ===') -ForegroundColor Cyan }
function Num($s){ return [double]::Parse($s, [Globalization.NumberStyles]::Float, $IC) }
function Scarica($rel, $dest, $firma){
  Remove-Item -LiteralPath $dest -Force -ErrorAction SilentlyContinue
  Invoke-RestMethod -Uri ($RAW + $rel + '?cb=' + [Guid]::NewGuid().ToString('N')) -OutFile $dest
  if(-not (Select-String -LiteralPath $dest -SimpleMatch -Pattern $firma -Quiet)){
    throw ($rel + ' scaricato ma NON contiene "' + $firma + '": copia sbagliata o cache di GitHub. Non si parte.')
  }
}
function Leggi-Condiviso($path){
  $b = $null
  try{
    $path = (Convert-Path -LiteralPath $path)
    $fs = [IO.File]::Open($path, [IO.FileMode]::Open, [IO.FileAccess]::Read, [IO.FileShare]::ReadWrite)
    $b  = New-Object byte[] $fs.Length
    [void]$fs.Read($b, 0, $b.Length)
    $fs.Close()
  } catch { return '' }
  if($null -eq $b -or $b.Count -lt 2){ return '' }
  if($b[0] -eq 0xFF -and $b[1] -eq 0xFE){ return ([Text.Encoding]::Unicode.GetString($b)).TrimStart([char]0xFEFF) }
  $zeri = 0; $nb = [math]::Min(400, $b.Count)
  for($i = 1; $i -lt $nb; $i += 2){ if($b[$i] -eq 0){ $zeri++ } }
  if($zeri -gt ($nb / 4)){ return ([Text.Encoding]::Unicode.GetString($b)).TrimStart([char]0xFEFF) }
  return ([Text.Encoding]::UTF8.GetString($b)).TrimStart([char]0xFEFF)
}
# conta le righe di un CSV (file condiviso, anche grande) senza caricarlo tutto in memoria
function ContaCsv($path){
  $r = @{ Righe = 0; Header = $false; Avvio = $false; Cfg = 0; Primo = '' }
  $fs = $null
  try{
    $fs = [IO.File]::Open($path, [IO.FileMode]::Open, [IO.FileAccess]::Read, [IO.FileShare]::ReadWrite)
    $sr = New-Object IO.StreamReader($fs, [Text.Encoding]::ASCII)
    while($true){
      $ln = $sr.ReadLine()
      if($null -eq $ln){ break }
      if($ln.StartsWith('CONTA;', [StringComparison]::Ordinal)){ $r.Righe = $r.Righe + 1 }
      elseif($ln.StartsWith('tipo;barra;linea;lato;', [StringComparison]::Ordinal)){ $r.Header = $true }
      elseif($ln.StartsWith('#AVVIO', [StringComparison]::Ordinal)){ $r.Avvio = $true; if($r.Primo -eq ''){ $r.Primo = $ln } }
      elseif($ln.StartsWith('#cfg;', [StringComparison]::Ordinal)){ $r.Cfg = $r.Cfg + 1 }
    }
  } catch { $r.Righe = -1 } finally { if($null -ne $fs){ $fs.Close() } }
  return $r
}
# i blocchi leggibili a macchina del file prova: '#  @F0-TIPO k=v k=v ...'
function BloccoF0($riga){
  $h = @{}
  foreach($kv in ($riga -split '\s+')){
    if($kv -eq ''){ continue }
    $p = $kv -split '=', 2
    if($p.Count -ne 2){ throw ('blocco @F0 malformato: ' + $riga) }
    if($h.ContainsKey($p[0])){ throw ('blocco @F0 con chiave doppia ' + $p[0] + ': ' + $riga) }
    $h[$p[0]] = $p[1]
  }
  return $h
}

# ---------------------------------------------------------------------
#  0. LA MACCHINA E IL TERMINALE. Fail-closed, come la passata NAS.
# ---------------------------------------------------------------------
Titolo '0 - MACCHINA E TERMINALE'
if($env:COMPUTERNAME -ne 'DESKTOP-H4D7CAJ'){
  throw ('NATCLA_F0_PASSATE gira SOLO sul PC di backtest DESKTOP-H4D7CAJ. Qui la macchina si chiama: ' + $env:COMPUTERNAME + '. Sul VPS VMI3047753 non si lancia: la challenge FTMO sta operando (firma del 21/09/2026: i round girano sul PC di backtest).')
}
Dico ('pc   : ' + $env:COMPUTERNAME) 'Green'
Dico ('pin  : ' + $Pin) 'Green'
Dico ('lotto: ' + $Lotto) 'Green'
$Mutex = New-Object System.Threading.Mutex($false, 'Global\ABTG_NATCLA_F0')
if(-not $Mutex.WaitOne(0)){
  throw 'Un ALTRO giro di NATCLA_F0 sta gia girando su questo PC (mutex Global\ABTG_NATCLA_F0 occupato). Un solo giro alla volta: aspetta che finisca, NON chiudere il suo terminale.'
}
if((@(Get-Process -Name terminal64, metaeditor64 -ErrorAction SilentlyContinue)).Count -gt 0){
  throw 'MT5 O METAEDITOR risulta APERTO su questo PC. Ogni passata ne apre una copia sua con /config: col terminale gia aperto il tester non parte. GUARDA I GRAFICI (sedie attaccate?), chiudilo A MANO e rilancia.'
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
    $v = (Leggi-Condiviso $o).Trim()
    if($v -ne ''){ $origini = $origini + @([pscustomobject]@{ Dir = $d.FullName; Inst = $v }) }
  }
}
# le ALTRE installazioni MT5 di questo PC: il censimento P0 del 05/10/2026
# (risultati_archivio/DUKA_P0_20261005_171046/REFERTO_DUKA_P0.txt, sez. 5) ne ha
# trovate DUE oltre al BCM: C:\MT5_Backtest e C:\FundedNext_Manuale. Sono AMMESSE
# PER NOME (chiuse, non toccate); una NON in elenco ferma tutto (classe 1157).
$Censite = @('C:\MT5_Backtest', 'C:\FundedNext_Manuale')
$diversi = @($origini | Where-Object { $_.Inst -ne $InstAttesa })
$ignote = @($diversi | Where-Object { $Censite -notcontains $_.Inst.TrimEnd('\') })
foreach($dv in @($diversi | Where-Object { $Censite -contains $_.Inst.TrimEnd('\') })){ Dico ('altra installazione di questo PC, censita il 05/10, CHIUSA e NON TOCCATA: ' + $dv.Inst + '  (cartella dati ' + (Split-Path -Leaf $dv.Dir) + ')') 'Yellow' }
if($ignote.Count -gt 0){
  Write-Host '   ATTENZIONE: su questa macchina hanno girato installazioni MT5 NON censite:' -ForegroundColor Red
  foreach($dv in $ignote){ Write-Host ('     ' + $dv.Inst) -ForegroundColor Red }
  throw 'Il giro si ferma: oltre al BCM e alle due censite il 05/10 (C:\MT5_Backtest, C:\FundedNext_Manuale) qui ci sono ALTRE installazioni MT5 (regola dei terminali multipli).'
}
$cands = @($origini | Where-Object { $_.Inst -eq $InstAttesa })
if($cands.Count -ne 1){
  throw ('cartella dati NON risolta in modo univoco: trovate ' + $cands.Count + ' candidate per ' + $InstAttesa + '. Il giro si ferma invece di indovinare.')
}
$DataFolder = $cands[0].Dir
# nessun EA sui grafici salvati: ogni passata apre il terminale col suo profilo
$chrRoot = Join-Path (Join-Path (Join-Path $DataFolder 'MQL5') 'Profiles') 'Charts'
$nChr = 0; $conEA = @()
if(Test-Path -LiteralPath $chrRoot){
  foreach($fc in @(Get-ChildItem -LiteralPath $chrRoot -Recurse -File -Filter '*.chr' -ErrorAction SilentlyContinue)){
    $nChr = $nChr + 1
    $tx = Leggi-Condiviso $fc.FullName
    if(-not $tx){ $conEA = $conEA + @($fc.Directory.Name + '\' + $fc.Name + '  ILLEGGIBILE: non verificabile, conta come EA attaccato'); continue }
    if($tx -match '<expert>'){ $conEA = $conEA + @($fc.Directory.Name + '\' + $fc.Name + '  EA ATTACCATO') }
  }
}
if($nChr -le 0){ throw ('ho letto ZERO grafici salvati sotto ' + $chrRoot + ': una guardia che non legge niente non ha verificato niente. Non si parte.') }
if($conEA.Count -gt 0){ throw ('SEDIE ATTACCATE ai grafici salvati del terminale BCM (' + ($conEA -join '; ') + '). Staccale prima: aprire il terminale col profilo le rimetterebbe in marcia (demo 50503392, 14/08/2026).') }
$MqlExp = Join-Path (Join-Path $DataFolder 'MQL5') 'Experts'
$MqlInc = Join-Path (Join-Path $DataFolder 'MQL5') 'Include'
$MqlFiles = Join-Path (Join-Path $DataFolder 'MQL5') 'Files'
$CommonFiles = Join-Path $env:APPDATA 'MetaQuotes\Terminal\Common\Files'
New-Item -ItemType Directory -Force -Path $MqlExp,$MqlInc | Out-Null
Dico ('terminale: ' + $Terminal) 'Green'
Dico ('dati     : ' + $DataFolder) 'Green'
Dico ('grafici salvati letti: ' + $nChr + ', nessun EA attaccato') 'Green'

# ---------------------------------------------------------------------
#  1. EA, INCLUDE E FILE PROVA AL PIN (SHA256 dalla riga), E COMPILAZIONE VERIFICATA
# ---------------------------------------------------------------------
Titolo '1 - SORGENTI AL PIN E COMPILAZIONE'
$Work = Join-Path $env:USERPROFILE 'abtg_passata'
New-Item -ItemType Directory -Force -Path $Work | Out-Null
$srcEA  = Join-Path $Work ($EXPERT + '.mq5')
$srcInc = Join-Path $Work 'ABTG_PausaGuardian.mqh'
$fileProva = Join-Path $Work $PROVA
Scarica ('mql5/Experts/' + $EXPERT + '.mq5') $srcEA 'NC_VER'
Scarica 'mql5/Include/ABTG_PausaGuardian.mqh' $srcInc 'ABTG_GuardiaIngresso'
Scarica ('backtest_pipeline/prove/' + $PROVA) $fileProva 'InpSoloConta'
foreach($ck in @(@($srcEA, $ShaEA, 'EA_NatCla.mq5'), @($srcInc, $ShaInc, 'ABTG_PausaGuardian.mqh'), @($fileProva, $ShaProva, $PROVA))){
  $hh = (Get-FileHash -LiteralPath $ck[0] -Algorithm SHA256).Hash
  if($hh -ne $ck[1]){ throw ($ck[2] + ' scaricato al pin ha SHA256 ' + $hh + ' invece di ' + $ck[1] + ' (quello calcolato dal commit): copia sbagliata o cache di GitHub. Non si parte.') }
  Dico ($ck[2] + ': SHA256 ' + $hh.Substring(0,12) + ' = quello della riga') 'Green'
}
if(-not (Select-String -LiteralPath $srcEA -SimpleMatch -Pattern ('#define NC_VER "' + $VERSIONE_ATTESA + '"') -Quiet)){ throw ('il sorgente dell EA non dichiara NC_VER ' + $VERSIONE_ATTESA + '. Non si parte.') }

# --- il file prova: pin, asse tecnico, blocchi F0
$pinProva = New-Object System.Collections.ArrayList
$assi = New-Object System.Collections.ArrayList
$blocchi = @{ CONFIG = @(); SIMBOLO = @(); LOTTO = @() }
foreach($r in (Get-Content -LiteralPath $fileProva)){
  $t = $r.Trim()
  if($t -match '^#\s*@F0-(CONFIG|SIMBOLO|LOTTO)\s+(.*)$'){ $tipoB = $Matches[1]; $corpoB = $Matches[2]; $blocchi[$tipoB] = @($blocchi[$tipoB]) + @((BloccoF0 $corpoB)); continue }
  if($t -eq '' -or $t.StartsWith('#')){ continue }
  if($t -match '^(Inp[A-Za-z0-9_]+)=(.*)$'){
    if($t.EndsWith('||Y')){ [void]$assi.Add($t) } else { [void]$pinProva.Add(@($Matches[1], $Matches[2])) }
  }
}
if($assi.Count -ne 1 -or $assi[0] -ne $ASSE_ATTESO){ throw ('asse del file prova diverso da ' + $ASSE_ATTESO + ': ' + ($assi -join ' ; ')) }
if($pinProva.Count -ne $N_PIN_ATTESI){ throw ('pin letti dal file prova: ' + $pinProva.Count + ' invece di ' + $N_PIN_ATTESI + ': file prova tronco o cambiato. Non si parte.') }
$doppi = @($pinProva | ForEach-Object { $_[0] } | Group-Object | Where-Object { $_.Count -gt 1 })
if($doppi.Count -gt 0){ throw ('parametri DOPPI nel file prova: ' + (($doppi | ForEach-Object { $_.Name }) -join ', ') + '. Non si parte.') }
$pinH = @{}; foreach($pp in $pinProva){ $pinH[$pp[0]] = $pp[1] }
if($pinH['InpSoloConta'] -ne 'true'){ throw 'il file prova NON ha InpSoloConta=true: il giro manderebbe ORDINI. Non si parte.' }
if(@($blocchi.CONFIG).Count -ne 6 -or @($blocchi.SIMBOLO).Count -ne 36 -or @($blocchi.LOTTO).Count -ne 5){ throw ('blocchi @F0 letti: configurazioni ' + @($blocchi.CONFIG).Count + ' (attese 6), simboli ' + @($blocchi.SIMBOLO).Count + ' (attesi 36), lotti ' + @($blocchi.LOTTO).Count + ' (attesi 5). Non si parte.') }
$lottoDef = @($blocchi.LOTTO | Where-Object { $_.nome -eq $Lotto })
if($lottoDef.Count -ne 1){ throw ('lotto ' + $Lotto + ' non trovato (o doppio) nel file prova.') }
$lottoDef = $lottoDef[0]
$tettoMin = [int]$lottoDef.tetto_min
$cfgDef = @{}; foreach($c in $blocchi.CONFIG){ $cfgDef[$c.nome] = $c }
$simDef = @{}; foreach($s in $blocchi.SIMBOLO){ $simDef[$s.nome] = $s }
$runs = New-Object System.Collections.ArrayList
foreach($sn in ($lottoDef.simboli -split ',')){
  if(-not $simDef.ContainsKey($sn)){ throw ('simbolo ' + $sn + ' del lotto ' + $Lotto + ' non ha il blocco @F0-SIMBOLO.') }
  foreach($cn in ($lottoDef.configs -split ',')){
    if(-not $cfgDef.ContainsKey($cn)){ throw ('configurazione ' + $cn + ' del lotto ' + $Lotto + ' inesistente.') }
    [void]$runs.Add([pscustomobject]@{ Sim = $simDef[$sn]; Cfg = $cfgDef[$cn] })
  }
}
Dico ('file prova letto: ' + $pinProva.Count + ' pin + asse tecnico, InpSoloConta=true; lotto ' + $Lotto + ': ' + $runs.Count + ' passate (' + (($lottoDef.simboli -split ',').Count) + ' simboli x ' + (($lottoDef.configs -split ',').Count) + ' configurazioni), tetto ' + $tettoMin + ' minuti') 'Green'

Copy-Item -LiteralPath $srcEA  -Destination (Join-Path $MqlExp ($EXPERT + '.mq5')) -Force
Copy-Item -LiteralPath $srcInc -Destination (Join-Path $MqlInc 'ABTG_PausaGuardian.mqh') -Force

$ex5 = Join-Path $MqlExp ($EXPERT + '.ex5')
Remove-Item -LiteralPath $ex5 -Force -ErrorAction SilentlyContinue
$logC = Join-Path $Work 'compile_natcla.log'
Remove-Item -LiteralPath $logC -Force -ErrorAction SilentlyContinue
# il verdetto NON e' il codice d'uscita di MetaEditor (a volte si stacca): e' l'esistenza del .ex5
# appena prodotto. Ogni argomento fra parentesi (classe 1152: la virgola lega piu' del +).
$pMe = Start-Process -FilePath $MetaEditor -ArgumentList @(('/compile:' + (Join-Path $MqlExp ($EXPERT + '.mq5'))), ('/log:' + $logC)) -PassThru
$attC = 0
while(-not (Test-Path -LiteralPath $ex5) -and $attC -lt 60){ Start-Sleep -Seconds 2; $attC = $attC + 1 }
if(-not (Test-Path -LiteralPath $ex5)){
  try{ if(-not $pMe.HasExited){ $pMe.Kill() } }catch{ }
  if(Test-Path -LiteralPath $logC){ (Leggi-Condiviso $logC) -split "`r?`n" | Select-Object -Last 20 | ForEach-Object { Write-Host ('     ' + $_) -ForegroundColor DarkYellow } }
  throw ($EXPERT + '.ex5 NON prodotto dopo 120 secondi. Senza il compilato il giro non parte: il log di MetaEditor e qui sopra.')
}
Start-Sleep -Seconds 3
$testoLogC = ''
if(Test-Path -LiteralPath $logC){ $testoLogC = Leggi-Condiviso $logC }
$compErr = -1; $compWarn = -1
$mRes = [regex]::Match($testoLogC, '(\d+)\s+errors?,\s*(\d+)\s+warnings?')
if($mRes.Success){ $compErr = [int]$mRes.Groups[1].Value; $compWarn = [int]$mRes.Groups[2].Value }
if($compErr -gt 0){ throw ('MetaEditor ha prodotto l.ex5 ma il log dice ' + $compErr + ' errori: non si usa un compilato dubbio. Guarda ' + $logC) }
Dico ('compilato: ' + $ex5 + '   SHA256 .ex5 ' + (Get-FileHash -LiteralPath $ex5 -Algorithm SHA256).Hash.Substring(0,12)) 'Green'
if($compErr -eq 0){ Dico ('log di compilazione: 0 errori, ' + $compWarn + ' avvisi') $(if($compWarn -eq 0){'Green'}else{'Yellow'}) }
else { Dico 'log di compilazione: riga "Result: N errors, M warnings" NON letta (formato diverso?): il verdetto e l esistenza dell .ex5' 'Yellow' }
foreach($lw in @(($testoLogC -split "`r?`n") | Where-Object { $_ -match 'warning' -and $_ -notmatch 'Result' } | Select-Object -First 12)){ Dico ('   ' + $lw) 'Yellow' }

# ---------------------------------------------------------------------
#  2. LE PASSATE SINGOLE (Optimization=0, Model=1, InpSoloConta=true)
# ---------------------------------------------------------------------
$dsk  = [Environment]::GetFolderPath('Desktop')
$Cart = Join-Path $dsk ('NATCLA_F0_' + $Lotto)
$zip  = Join-Path $dsk ('NATCLA_F0_' + $Lotto + '.zip')
$stampa = (Get-Date).ToString('yyyyMMdd_HHmmss')
if(Test-Path -LiteralPath $Cart){ Move-Item -LiteralPath $Cart -Destination ($Cart + '_VECCHIA_' + $stampa) -Force; Dico ('cartella di un giro PRECEDENTE rinominata: ' + $Cart + '_VECCHIA_' + $stampa) 'Yellow' }
if(Test-Path -LiteralPath $zip){ Move-Item -LiteralPath $zip -Destination (Join-Path $dsk ('NATCLA_F0_' + $Lotto + '_VECCHIO_' + $stampa + '.zip')) -Force; Dico ('zip di un giro PRECEDENTE rinominato con la data') 'Yellow' }
New-Item -ItemType Directory -Force -Path $Cart | Out-Null
New-Item -ItemType Directory -Force -Path (Join-Path $Cart 'csv'), (Join-Path $Cart 'log'), (Join-Path $Cart 'ini') | Out-Null
Copy-Item -LiteralPath $fileProva -Destination $Cart -Force
if(Test-Path -LiteralPath $logC){ Copy-Item -LiteralPath $logC -Destination (Join-Path $Cart 'compile_natcla.log') -Force }

$LogRoot = Join-Path $env:APPDATA 'MetaQuotes'
# le radici dei log: %APPDATA%\MetaQuotes contiene la cartella dati e gli agenti locali
# (Tester\<id>\Agent-127.0.0.1-30xx\logs); <installazione>\Tester e' la terza radice nota in casa.
$RadiciLog = @($LogRoot, (Join-Path $InstAttesa 'Tester'))
$reAvvio = New-Object Text.RegularExpressions.Regex("\[NatCla\]\s+(AVVIO v(?<v>[0-9.]+) \| modalita' (?<mod>\w+) \| (?<sym>\S+) PERIOD_(?<tf>\w+) \| 1 u = (?<u>[0-9.]+) \((?<descr>.*?)\) \| 1 pip = (?<pip>[0-9.]+) \| magic (?<mg>[0-9]+) \| linee (?<linee>.*?)\s*\| ADX (?<adx>ACCESO|spento), (?<tipo>iADX MetaQuotes|iADXWilder), max (?<max>[0-9.]+), periodo (?<per>[0-9]+) \| ingresso (?<ing>\w+) \| rischio setup (?<risk>[0-9.]+)% .*?\| guardian .*?\| solo conta (?<sc>\w+) \| placebo (?<pl>[0-9.]+) ATR .*)")
$reVerifica = New-Object Text.RegularExpressions.Regex('\[NatCla\]\s+(VERIFICA ADX barra (?<barra>\d{4}\.\d\d\.\d\d \d\d:\d\d) .*il terminale coincide con: (?<chi>.*))')
$reNatCla = New-Object Text.RegularExpressions.Regex('\[NatCla\]\s+(.*)')
$reImbuto = New-Object Text.RegularExpressions.Regex('\[NATCLA-IMBUTO\]')
$reFin = New-Object Text.RegularExpressions.Regex(('Tester\s+Experts\\' + [regex]::Escape($EXPERT) + '\.ex5 on (?<sim>[A-Za-z0-9_.#-]+),(?<tf>[A-Za-z0-9]+) from (?<da>\d{4}\.\d\d\.\d\d) (?<ha>\d\d:\d\d) to (?<a>\d{4}\.\d\d\.\d\d) (?<hb>\d\d:\d\d)'), [Text.RegularExpressions.RegexOptions]::IgnoreCase)

# DEVIAZIONE 11: la scoperta ricorsiva dei .log (come nella passata NAS) si fa UNA VOLTA a inizio lotto e ricorda le CARTELLE; poi a ogni passata si
# rileggono solo quelle (piu' i percorsi noti degli agenti): una ricorsione su tutto %APPDATA%\MetaQuotes, con le cartelle 'bases' dei tick, costerebbe
# decine di secondi due volte per passata, per 216 passate.
$DirLog = @{}
foreach($rad in $RadiciLog){
  if(-not (Test-Path -LiteralPath $rad)){ continue }
  foreach($lf in @(Get-ChildItem -Path $rad -Recurse -Filter '*.log' -File -ErrorAction SilentlyContinue)){ $DirLog[$lf.DirectoryName] = $true }
}
$PatLog = @((Join-Path $LogRoot 'Tester\*\Agent-*\logs'), (Join-Path $InstAttesa 'Tester\Agent-*\logs'), (Join-Path $InstAttesa 'Tester\logs'), (Join-Path $DataFolder 'Tester\logs'), (Join-Path $DataFolder 'logs'), (Join-Path (Join-Path $DataFolder 'MQL5') 'Logs'))
function ElencoLog(){
  $dirs = @{}
  foreach($dk in @($DirLog.Keys)){ $dirs[$dk] = $true }
  foreach($pt in $PatLog){ foreach($it in @(Get-Item -Path $pt -ErrorAction SilentlyContinue)){ if($it.PSIsContainer){ $dirs[$it.FullName] = $true } } }
  $v = @()
  foreach($dk in @($dirs.Keys)){ $v = $v + @(Get-ChildItem -LiteralPath $dk -Filter '*.log' -File -ErrorAction SilentlyContinue) }
  return $v
}
function Fotografia(){
  $h = @{}
  foreach($f in @(ElencoLog)){ $h[$f.FullName] = $f.Length }
  return $h
}
function LeggiCoda($path, $offset){
  # i log di MT5 sono UTF-16 LE con BOM: la codifica si legge dal BOM all'inizio del FILE, poi si
  # salta all'offset registrato prima della passata, cosi' si legge SOLO quello che ha scritto lei.
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
# i controlli dell'AVVIO, uno per uno, contro la configurazione e il simbolo della passata
function ControllaAvvio($ma, $cfg, $sim){
  $mot = New-Object System.Collections.ArrayList
  $G = $ma.Groups
  if($G['v'].Value -ne $VERSIONE_ATTESA){ [void]$mot.Add('versione EA ' + $G['v'].Value + ' invece di ' + $VERSIONE_ATTESA) }
  $modAtt = 'AUDIO'; if($cfg.modalita -eq '2'){ $modAtt = 'EMA200' }
  if($G['mod'].Value -ne $modAtt){ [void]$mot.Add('modalita ' + $G['mod'].Value + ' invece di ' + $modAtt) }
  if($G['sym'].Value -ne $sim.nome){ [void]$mot.Add('simbolo ' + $G['sym'].Value + ' invece di ' + $sim.nome) }
  if($G['tf'].Value -ne $cfg.periodo){ [void]$mot.Add('TF PERIOD_' + $G['tf'].Value + ' invece di PERIOD_' + $cfg.periodo) }
  if($G['mg'].Value -ne $cfg.magic){ [void]$mot.Add('magic ' + $G['mg'].Value + ' invece di ' + $cfg.magic) }
  $lnL = (@($G['linee'].Value -split '\s+' | Where-Object { $_ -ne '' }) -join ',')
  if($lnL -ne $cfg.linee){ [void]$mot.Add('linee ' + $lnL + ' invece di ' + $cfg.linee) }
  if($G['adx'].Value -ne $cfg.adx){ [void]$mot.Add('ADX ' + $G['adx'].Value + ' invece di ' + $cfg.adx) }
  if($G['tipo'].Value -ne 'iADX MetaQuotes'){ [void]$mot.Add('tipo ADX ' + $G['tipo'].Value + ' invece di iADX MetaQuotes') }
  if((Num $G['max'].Value) -ne 20.0 -or [int]$G['per'].Value -ne 14){ [void]$mot.Add('ADX max/periodo ' + $G['max'].Value + '/' + $G['per'].Value + ' invece di 20/14') }
  if($G['ing'].Value -ne 'SCALA3_PENDENTI'){ [void]$mot.Add('ingresso ' + $G['ing'].Value + ' invece di SCALA3_PENDENTI') }
  if($G['sc'].Value -ne 'SI'){ [void]$mot.Add('solo conta ' + $G['sc'].Value + ' invece di SI: MANDEREBBE ORDINI') }
  if((Num $G['pl'].Value) -ne 0.0){ [void]$mot.Add('placebo ' + $G['pl'].Value + ' invece di 0') }
  $uAtt = Num $sim.u
  if([math]::Abs((Num $G['u'].Value) - $uAtt) -gt 1e-9){ [void]$mot.Add('1 u = ' + $G['u'].Value + ' invece di ' + $sim.u + ' (classe ' + $sim.classe + ')') }
  $dsc = $G['descr'].Value
  $dAtt = 'AUTO_CLASSE forex'
  if($sim.classe -eq 'ORO' -or $sim.classe -eq 'ARG'){ $dAtt = 'AUTO_CLASSE metallo' }
  if($sim.classe -eq 'IDX'){ $dAtt = 'AUTO_CLASSE indice/CFD' }
  if(-not $dsc.StartsWith($dAtt)){ [void]$mot.Add('descrizione unita "' + $dsc + '" non comincia per ' + $dAtt) }
  return $mot
}
function TrovaCsv($nomeCsv, $tDa){
  $dove = @($CommonFiles, $MqlFiles)
  foreach($d0 in $dove){
    $p = Join-Path $d0 $nomeCsv
    if(Test-Path -LiteralPath $p){ $it = Get-Item -LiteralPath $p; if($it.LastWriteTime -ge $tDa){ return $it } }
  }
  $ag = Join-Path $LogRoot 'Tester'
  if(Test-Path -LiteralPath $ag){
    foreach($it in @(Get-ChildItem -Path $ag -Recurse -Filter $nomeCsv -File -ErrorAction SilentlyContinue | Where-Object { $_.LastWriteTime -ge $tDa } | Sort-Object LastWriteTime -Descending)){ return $it }
  }
  return $null
}

Titolo ('2 - LOTTO ' + $Lotto + ': ' + $runs.Count + ' PASSATE SINGOLE (Modello 1, OHLC su M1, InpSoloConta=true, nessun ordine)')
$TLotto = Get-Date
$manifest = New-Object System.Collections.ArrayList
[void]$manifest.Add('lotto;simbolo;config;magic;t_avvio;durata_s;stato;csv;righe_conta;avvio_ok;adx_verifica;finestra;motivi')
$nOk = 0; $nKo = 0; $nNon = 0; $sommaDur = 0.0; $nDur = 0
$abort = $false
$k = 0
foreach($ru in $runs){
  $k = $k + 1
  $sim = $ru.Sim; $cfg = $ru.Cfg
  $tag = $sim.nome + '_' + $cfg.nome
  $etich = '[' + $k + '/' + $runs.Count + '] ' + $sim.nome + ' ' + $cfg.nome
  $minDa = ((Get-Date) - $TLotto).TotalMinutes
  if($abort -or $minDa -ge $tettoMin){
    $nNon = $nNon + 1
    $why = 'tetto di ' + $tettoMin + ' minuti'; if($abort){ $why = 'lotto fermato' }
    [void]$manifest.Add($Lotto + ';' + $sim.nome + ';' + $cfg.nome + ';' + $cfg.magic + ';;0;NON_LANCIATA;;0;no;;;' + $why)
    Write-Host ('   ' + $etich + '  NON LANCIATA (' + $why + ', minuto ' + [int]$minDa + ')') -ForegroundColor Red
    continue
  }
  if((@(Get-Process -Name terminal64 -ErrorAction SilentlyContinue)).Count -gt 0){
    Write-Host ('   ' + $etich + '  un terminal64 e ancora VIVO prima della passata: il lotto si ferma, non apro un secondo terminale.') -ForegroundColor Red
    $abort = $true; $nNon = $nNon + 1
    [void]$manifest.Add($Lotto + ';' + $sim.nome + ';' + $cfg.nome + ';' + $cfg.magic + ';;0;NON_LANCIATA;;0;no;;;terminale ancora vivo')
    continue
  }
  # --- l'ini: i 71 pin del file prova, con SOLO modalita' e TF della configurazione, e il magic automatico (primo valore dell'asse tecnico)
  $righeIn = New-Object System.Collections.ArrayList
  foreach($pp in $pinProva){
    $val = $pp[1]
    if($pp[0] -eq 'InpModalita'){ $val = $cfg.modalita }
    if($pp[0] -eq 'InpTF'){ $val = $cfg.tf }
    [void]$righeIn.Add($pp[0] + '=' + $val)
  }
  [void]$righeIn.Add('InpMagic=0')
  $iniF = Join-Path $Work ('f0_' + $tag + '.ini')
  $testoIni = "[Experts]`r`nAllowLiveTrading=false`r`nAllowDllImport=false`r`n`r`n" +
              "[Tester]`r`nExpert=" + $EXPERT + ".ex5`r`nSymbol=" + $sim.nome + "`r`nPeriod=" + $cfg.periodo + "`r`nModel=1`r`n" +
              "Optimization=0`r`nFromDate=" + $sim.da + "`r`nToDate=" + $DATA_A + "`r`nForwardMode=0`r`nDeposit=10000`r`nCurrency=EUR`r`nLeverage=100`r`n" +
              "ExecutionMode=0`r`nShutdownTerminal=1`r`n`r`n" +
              "[TesterInputs]`r`n" + ($righeIn -join "`r`n") + "`r`n"
  Set-Content -LiteralPath $iniF -Value $testoIni -Encoding ASCII
  Copy-Item -LiteralPath $iniF -Destination (Join-Path $Cart 'ini') -Force

  $foto = Fotografia
  $tRun = Get-Date
  $p = Start-Process -FilePath $Terminal -ArgumentList ('/config:"' + $iniF + '"') -PassThru
  $scade = $tRun.AddMinutes($TimeoutRunMin)
  while(-not $p.HasExited -and (Get-Date) -lt $scade){ Start-Sleep -Seconds 5 }
  $timeout = $false
  if(-not $p.HasExited){
    $timeout = $true
    Write-Host ('   ' + $etich + '  TIMEOUT: dopo ' + $TimeoutRunMin + ' minuti il tester e ancora aperto. Lo chiudo con CloseMainWindow (MAI Stop-Process sul terminale).') -ForegroundColor Red
    try{ [void]$p.CloseMainWindow() }catch{ }
    $att = 0; while(-not $p.HasExited -and $att -lt 18){ Start-Sleep -Seconds 5; $att = $att + 1 }
    if(-not $p.HasExited){ $abort = $true; Write-Host '   il terminale NON si e chiuso: il lotto si ferma qui, la riga NON lo chiude con la forza (guarda i grafici e chiudilo A MANO).' -ForegroundColor Red }
  }
  Start-Sleep -Seconds 8   # l'agente del tester scarica i log su disco dopo la chiusura
  $dur = ((Get-Date) - $tRun).TotalSeconds

  # --- lettura delle sole righe scritte DOPO la fotografia
  $avvi = @{}; $righeEA = @{}; $ver = @{}; $fin = @{}; $nImb = 0; $nImbRotte = 0; $illeggibili = 0
  foreach($f in @(ElencoLog)){
    $off = 0; if($foto.ContainsKey($f.FullName)){ $off = [long]$foto[$f.FullName] }
    if($f.Length -le $off){ continue }
    try{ $testo = LeggiCoda $f.FullName $off }catch{ $illeggibili = $illeggibili + 1; continue }
    foreach($riga in ($testo -split "`r?`n")){
      $mf = $reFin.Match($riga)
      if($mf.Success){ $fin[$mf.Value] = $mf; continue }
      if($reImbuto.IsMatch($riga)){ if($riga.IndexOf('quadratura ROTTA') -ge 0){ $nImbRotte = $nImbRotte + 1 }; $nImb = $nImb + 1; continue }
      $mn = $reNatCla.Match($riga)
      if(-not $mn.Success){ continue }
      $chiave = $mn.Groups[1].Value.TrimEnd()
      $ma = $reAvvio.Match($riga)
      if($ma.Success){ $avvi[$chiave] = $ma; continue }
      $mv = $reVerifica.Match($riga)
      if($mv.Success){ $ver[$chiave] = $mv; continue }
      $righeEA[$chiave] = $true
    }
  }
  $motivi = New-Object System.Collections.ArrayList
  if($timeout){ [void]$motivi.Add('timeout di ' + $TimeoutRunMin + ' minuti') }
  # AVVIO: una sola riga distinta e giusta
  $avvioOk = 'no'
  if($avvi.Count -eq 0){ [void]$motivi.Add('riga AVVIO dell EA NON trovata nei log (l EA non e partito? compilazione? ini ignorata?)') }
  elseif($avvi.Count -gt 1){ [void]$motivi.Add('PIU righe AVVIO distinte (' + $avvi.Count + '): log di due passate mescolati') }
  else {
    $mm = ControllaAvvio ($avvi.Values | Select-Object -First 1) $cfg $sim
    if($mm.Count -eq 0){ $avvioOk = 'si' } else { foreach($x in $mm){ [void]$motivi.Add('AVVIO: ' + $x) } }
  }
  foreach($rr in @($righeEA.Keys)){ if($rr -match 'AVVIO RIFIUTATO|ERRORE|INIT_FAILED|FALLITA'){ [void]$motivi.Add('EA: ' + $rr) } }
  # VERIFICA ADX
  $adxV = 'assente'
  if($ver.Count -eq 1){
    $chi = ($ver.Values | Select-Object -First 1).Groups['chi'].Value
    if($chi -like 'formula MetaQuotes*'){ $adxV = 'MetaQuotes' } elseif($chi -like 'formula di Wilder*'){ $adxV = 'Wilder' } else { $adxV = 'NESSUNA' }
    if($adxV -ne 'MetaQuotes'){ [void]$motivi.Add('VERIFICA ADX: il terminale coincide con ' + $adxV + ': FERMARSI, nessun numero di ADX si legge') }
  } elseif($ver.Count -eq 0){ [void]$motivi.Add('riga VERIFICA ADX NON trovata (l EA non ha mai avuto dati sufficienti: 300 barre del TF)') }
  else { [void]$motivi.Add('PIU righe VERIFICA ADX distinte') }
  # finestra girata, dal giornale del tester
  $finest = 'non letta'
  if($fin.Count -eq 1){
    $mf = $fin.Values | Select-Object -First 1
    $tfOk = ($mf.Groups['tf'].Value -eq $cfg.periodo) -or ($cfg.periodo -eq 'D1' -and $mf.Groups['tf'].Value -eq 'Daily')
    if($mf.Groups['sim'].Value -eq $sim.nome -and $tfOk -and $mf.Groups['da'].Value -eq $sim.da -and $mf.Groups['a'].Value -eq $DATA_A -and $mf.Groups['ha'].Value -eq '00:00' -and $mf.Groups['hb'].Value -eq '00:00'){ $finest = $sim.da + '-' + $DATA_A }
    else { $finest = 'DIVERSA: ' + $mf.Groups['sim'].Value + ',' + $mf.Groups['tf'].Value + ' ' + $mf.Groups['da'].Value + '-' + $mf.Groups['a'].Value; [void]$motivi.Add('finestra girata ' + $finest + ' invece di ' + $sim.nome + ',' + $cfg.periodo + ' ' + $sim.da + '-' + $DATA_A) }
  } elseif($fin.Count -gt 1){ $finest = 'AMBIGUA'; [void]$motivi.Add('PIU intestazioni di passata nel giornale del tester: finestra non attribuibile') }
  # il CSV
  $nomeCsv = 'natcla_setup_' + $sim.nome + '_' + $cfg.magic + '.csv'
  $csvIt = TrovaCsv $nomeCsv $tRun
  $righeConta = 0; $csvTxt = ''
  if($null -eq $csvIt){ [void]$motivi.Add('CSV ' + $nomeCsv + ' NON trovato fresco (scritto dopo l avvio della passata)') }
  else {
    $cc = ContaCsv $csvIt.FullName
    if($cc.Righe -lt 0){ [void]$motivi.Add('CSV illeggibile') }
    else {
      $righeConta = $cc.Righe; $csvTxt = $nomeCsv
      if(-not $cc.Header){ [void]$motivi.Add('CSV senza intestazione tipo;barra;linea;lato') }
      if(-not $cc.Avvio){ [void]$motivi.Add('CSV senza la riga #AVVIO in testa') }
      if($cc.Cfg -lt 20){ [void]$motivi.Add('CSV con solo ' + $cc.Cfg + ' righe #cfg (attese >= 20)') }
      Copy-Item -LiteralPath $csvIt.FullName -Destination (Join-Path (Join-Path $Cart 'csv') $nomeCsv) -Force
    }
  }
  # il log dell'EA di questa passata
  $lg = New-Object System.Collections.ArrayList
  [void]$lg.Add('passata ' + $etich + '   ini f0_' + $tag + '.ini   durata ' + [int]$dur + ' s   IMBUTO: ' + $nImb + ' righe, quadratura ROTTA ' + $nImbRotte)
  foreach($a in $avvi.Keys){ [void]$lg.Add('[NatCla] ' + $a) }
  foreach($a in $ver.Keys){ [void]$lg.Add('[NatCla] ' + $a) }
  foreach($a in ($righeEA.Keys | Sort-Object)){ [void]$lg.Add('[NatCla] ' + $a) }
  foreach($a in $fin.Keys){ [void]$lg.Add('TESTER ' + $a) }
  ($lg -join "`r`n") | Set-Content -LiteralPath (Join-Path (Join-Path $Cart 'log') ('EA_' + $tag + '.txt')) -Encoding ASCII

  $stato = 'OK'
  if($motivi.Count -gt 0){ $stato = 'KO' }
  if($finest -eq 'non letta' -and $motivi.Count -eq 0){ $stato = 'OK_FINESTRA_NON_LETTA' }
  if($stato -like 'OK*'){ $nOk = $nOk + 1; $sommaDur = $sommaDur + $dur; $nDur = $nDur + 1 } else { $nKo = $nKo + 1 }
  [void]$manifest.Add($Lotto + ';' + $sim.nome + ';' + $cfg.nome + ';' + $cfg.magic + ';' + $tRun.ToString('yyyy-MM-dd HH:mm:ss') + ';' + [int]$dur + ';' + $stato + ';' + $csvTxt + ';' + $righeConta + ';' + $avvioOk + ';' + $adxV + ';' + $finest + ';' + (($motivi -join ' | ') -replace ';', ','))
  $col = 'Green'; if($stato -ne 'OK'){ $col = 'Red' }
  Write-Host ('   ' + $etich + '  ' + $stato + '   ' + [int]$dur + ' s   righe CONTA ' + $righeConta + '   AVVIO ' + $avvioOk + '   ADX ' + $adxV + '   finestra ' + $finest) -ForegroundColor $col
  foreach($x in $motivi){ Write-Host ('        - ' + $x) -ForegroundColor Red }
}
$durTot = ((Get-Date) - $TLotto).TotalMinutes

# ---------------------------------------------------------------------
#  3. RACCOLTA
# ---------------------------------------------------------------------
Titolo '3 - RACCOLTA'
$mediaS = 0.0; if($nDur -gt 0){ $mediaS = $sommaDur / $nDur }
$testa = @(
  ('NATCLA F0 -- lotto ' + $Lotto + ': conteggio dei setup di Ea Nat&Cla (Modello 1 OHLC su M1, InpSoloConta=true, NESSUN ordine)'),
  ('data: ' + (Get-Date).ToString('yyyy-MM-dd HH:mm:ss') + '   pc: ' + $env:COMPUTERNAME + '   pin: ' + $Pin),
  ('EA_NatCla.mq5 SHA256 ' + $ShaEA + '  (NC_VER ' + $VERSIONE_ATTESA + ')   compilazione: ' + $compErr + ' errori, ' + $compWarn + ' avvisi (-1 = non letto)'),
  ('passate del lotto ' + $runs.Count + ': OK ' + $nOk + ', KO ' + $nKo + ', NON LANCIATE ' + $nNon + '   durata totale ' + [int]$durTot + ' minuti   media per passata OK ' + [int]$mediaS + ' secondi'),
  ('STIMA F0 INTERA con la media misurata: 216 passate x ' + [int]$mediaS + ' s = ' + [int](216 * $mediaS / 60.0) + ' minuti (solo se il lotto e rappresentativo: indici e forex hanno barre M1 diverse)'),
  'Guardian nel tester: FAIL-OPEN (specifica 2.5): irrilevante in SoloConta (nessun ordine).',
  ''
)
(($testa + $manifest + @('',
  'COME SI LEGGE: python3 backtest_pipeline/leggi_natcla_f0.py <questo zip o la cartella>. Prima lo STATO di ogni passata (OK / KO / NON_LANCIATA) e la colonna adx_verifica',
  '(deve dire MetaQuotes su tutte: se dice NESSUNA o Wilder nessun numero di ADX si usa); poi la tabella dei setup per linea e simbolo contro le attese scritte nel file prova.',
  'Questo script CONTA e dice se ogni passata e affidabile: NON giudica, NON promuove, NON sceglie nessuna cella.')) -join "`r`n") | Set-Content -LiteralPath (Join-Path $Cart 'RIEPILOGO_F0.txt') -Encoding ASCII
(($manifest) -join "`r`n") | Set-Content -LiteralPath (Join-Path $Cart 'MANIFEST_F0.csv') -Encoding ASCII
Compress-Archive -Path (Join-Path $Cart '*') -DestinationPath $zip -Force
Write-Host ''
Write-Host ('passate OK ' + $nOk + ', KO ' + $nKo + ', NON LANCIATE ' + $nNon + ' su ' + $runs.Count + '   durata ' + [int]$durTot + ' minuti   media per passata OK ' + [int]$mediaS + ' s') -ForegroundColor Cyan
Write-Host ('ZIP PRONTO DA MANDARE: ' + $zip) -ForegroundColor Green
Write-Host 'FILE ATTESI NELLO ZIP: RIEPILOGO_F0.txt + MANIFEST_F0.csv + il file prova + compile_natcla.log + csv\natcla_setup_<simbolo>_<magic>.csv + log\EA_<simbolo>_<config>.txt + ini\f0_<simbolo>_<config>.ini' -ForegroundColor Gray
try{ $Mutex.ReleaseMutex() }catch{ }
if($nKo -eq 0 -and $nNon -eq 0 -and $nOk -eq $runs.Count){ Write-Host 'ESITO F0: TUTTE LE PASSATE OK (rc 0)' -ForegroundColor Green; exit 0 }
Write-Host 'ESITO F0: ALMENO UNA PASSATA KO O NON LANCIATA (rc 3): lo zip esce lo stesso, il MANIFEST dice quali e perche.' -ForegroundColor Red
exit 3
