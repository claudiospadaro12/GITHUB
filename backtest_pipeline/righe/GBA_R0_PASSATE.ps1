# =====================================================================
#  MARCATORE_GBA_R0_PASSATE_v1
#  GBA_R0_PASSATE.ps1 -- PASSO 0 (sonda) E PASSO 1 (replica) DI 'GoldBreakoutATR' (ABTG_GoldBreakoutATR v1.10) SU XAUUSD
#
#  CHE COSA FA, e una cosa sola:
#    per ogni passata di UN LOTTO del file prova backtest_pipeline/prove/GBA_R0_REPLICA_2026-10-09.txt lancia UNA passata SINGOLA del tester
#    (Optimization=0, Modello 1 = OHLC su M1 per la sonda S0, Modello 4 = ticks reali per la replica R1A/R1B, deposito 100000 EUR, un solo
#    input diverso fra una cella e l'altra: InpSpreadMaxATR), poi RACCOGLIE il report .htm del tester, le righe [GBA...] del giornale
#    dell'EA (tutte: una per segnale, una per ingresso, AVVIO, AUTOTEST, [GBA-CONTA]) e le righe del tester (ticks data begins,
#    N ticks M bars generated, finestra girata), le mette in un zip sul Desktop e dice per ogni passata se e' AFFIDABILE (OK) o no (KO).
#    NON giudica niente: la tabella (n, PF, DD, costo stop/spread, ora, lato, concentrazione, cancelli G0/G1/G2) la fa leggi_gba_r0.py.
#
#  PERCHE' NON IL DRIVER DEI ROUND (walkforward_generico*.ps1 / RIGA_ROUND_*): MISURATO sul sorgente. Il driver dei round scrive SEMPRE
#  Optimization=1 (walkforward_generico.ps1 r.1015 e r.2013) e legge il risultato SOLO da OptResults_<EA>_<simbolo>.csv, che l'EA scrive con
#  FrameAdd/OnTesterDeinit. ABTG_GoldBreakoutATR.mq5 v1.10 non ha ne' OnTester* ne' FrameAdd (report/EA_GBA_NOTE_2026-10-09.md par. 2.16):
#  col driver dei round la prova uscirebbe con un CSV da zero byte (classe 134). L'EA NON e' stato toccato (richiesta del 09/10): il report si
#  legge dal tester. Il driver dei round non si tocca (SHA256 pinnati).
#
#  DERIVATO DA NATCLA_F0_PASSATE.ps1 (passata singola per lotto, gia' passata dal cancello e girata il 07-08/10). DEVIAZIONI, tutte dichiarate:
#   1. EA = ABTG_GoldBreakoutATR (versione attesa 1.10, '#property version "1.10"'), simbolo fisso XAUUSD, TF M1, include ABTG_PausaGuardian.mqh
#      (stesso file, SHA256 passato dalla riga). Nessun CSV dell'EA: l'EA non ne scrive.
#   2. Le passate vengono dal blocco '# @GBA-LOTTO' del file prova (la SOLA fonte: nessuna lista doppia qui): ogni voce e' CELLA:TRANCHE[:magic]. Le celle
#      sono blocchi '# @GBA-CELLA nome=.. InpSpreadMaxATR=..': un blocco che dichiari QUALUNQUE altro input fa MORIRE lo script (una variabile per file).
#      Le tranche sono blocchi '# @GBA-TRANCHE nome=.. da=.. a=..'. Il magic e' quello dell'asse tecnico (775800 o 775850) e basta.
#   3. Modello per lotto dal file prova (1 o 4). Con Modello 4 la passata e' KO se il report non dice '100% ticks reali' o se 'ticks data begins from'
#      cade DOPO l'inizio della tranche.
#   4. Il REPORT .htm (Report=GBA_R0_<tag>, ReplaceReport=1) e' raccolto e copiato nello zip, e se ne leggono: operazioni, profitto, fattore di profitto,
#      qualita' dello storico, barre, ticks, Expert, Simbolo, Periodo. Report assente, illeggibile, di un altro EA/simbolo/periodo = KO. (NATCLA_F0 non
#      lo voleva: qui senza report non c'e' misura.)
#   5. Il giornale: si tengono TUTTE le righe '[GBA' (una per segnale: sono migliaia) deduplicate per (ora simulata + inizio riga), con la regola della
#      riga TRONCATA (si tiene la piu' lunga, classe 1173) fatta con un dizionario e non con il doppio ciclo di NATCLA_F0 (con migliaia di righe sarebbe quadratico).
#      Si scrivono per intero in log\GBA_<tag>.txt; il lettore le analizza (segnali per ora, spread/ATR, stop/spread).
#   6. Controlli per passata, tutti contro la CELLA: riga AVVIO v1.10 e le righe SEGNALE/LATI/USCITE/BREAKEVEN/ESECUZIONE/RISCHIO/IDENTITA' con TUTTI i valori
#      dei pin scritti come l'EA li stampa (spread a 3 decimali, il resto a 2); AUTOTEST 'VERDETTO: PASS'; riga [GBA-CONTA] FINE; finestra girata uguale alla
#      tranche; barre generate < 100.000 (a >= 100.000 la finestra e' TRONCATA = KO; fra 95.000 e 100.000 avviso); ingressi del giornale = operazioni del report
#      (+/-1: una posizione aperta a fine test).
#   7. G1 (solo lotto S0): le due passate gemelle (stessa cella, stessa tranche, magic 775800 e 775850) devono avere operazioni, profitto e fattore di profitto
#      IDENTICI nel report; lo script lo dice nel RIEPILOGO. Il lettore lo rifa' da capo sui deal.
#   8. Guardie di NATCLA_F0 INVARIATE: macchina DESKTOP-H4D7CAJ, nessun terminal64/metaeditor64 vivo, installazioni MT5 non censite = stop (C:\MT5_Backtest e
#      C:\FundedNext_Manuale ammesse PER NOME, chiuse, non toccate), cartella dati risolta per origin.txt, nessun EA sui grafici salvati, AllowLiveTrading=false,
#      Mutex Global\ABTG_GBA_R0 (un solo giro alla volta, classe 853), pin di 40 esadecimali, SHA256 di EA/include/prova passati dalla riga (classe 166),
#      compilazione verificata dall'esistenza dell' .ex5 NUOVO (classe 1168), log di MetaEditor letto in inglese e italiano, CloseMainWindow e MAI
#      Stop-Process sul terminale, TLS 1.2 qui dentro (classe 1156), cartella e zip esistenti RINOMINATI con la data e mai cancellati.
#
#  E' UN BACKTEST, NON UN ORDINE. [Experts] AllowLiveTrading=false nel .ini: il terminale del PC di backtest e' loggato sul DEMO 50503392 e il 14/08/2026
#  da questa macchina sono partiti ordini VERI.
#
#  NON TOCCA, per nome: PRIMA SU QUESTO PC le installazioni C:\MT5_Backtest (cartella dati 04C7A32B) e C:\FundedNext_Manuale (cartella dati 2B8180C3);
#  POI il VPS VMI3047753 e TUTTE le sue cartelle dati (FTMO 541452707 in C:\FTMO, trial 1514806751, REALE 10105439 in C:\BCM_Reale, 100k 50504263, piccolo
#  50503392 sul VPS, manuale 50503635 in C:\MT5_MANUALE, banco 50504400 in C:\MT5_Backtest, Pepperstone, Tickmill). Scrive SOLO: la cartella
#  %USERPROFILE%\abtg_passata, MQL5\Experts e MQL5\Include del terminale BCM di questa macchina, i report .htm che il tester scrive nella cartella dati (Report=),
#  il Desktop. NON legge ne' scrive conti, ordini, posizioni, preset di nessuna sedia. NON tocca CODA.txt ne' il runner notturno (che gira sul VPS).
#
#  NIENTE EMOJI QUI DENTRO (regola del 17/08): Windows PowerShell 5.1 legge i .ps1 come ANSI e un'emoji dentro una stringa rompe il parser.
# =====================================================================
[CmdletBinding()]
param(
  [Parameter(Mandatory=$true)][string]$Pin,
  [Parameter(Mandatory=$true)][string]$Lotto,
  [Parameter(Mandatory=$true)][string]$ShaEA,
  [Parameter(Mandatory=$true)][string]$ShaInc,
  [Parameter(Mandatory=$true)][string]$ShaProva,
  [int]$TimeoutRunMin = 30
)

$ErrorActionPreference = 'Stop'
$IC = [Globalization.CultureInfo]::InvariantCulture
[Threading.Thread]::CurrentThread.CurrentCulture   = $IC
[Threading.Thread]::CurrentThread.CurrentUICulture = $IC
[Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12

$EXPERT = 'ABTG_GoldBreakoutATR'
$PROVA  = 'GBA_R0_REPLICA_2026-10-09.txt'
$VERSIONE_ATTESA = '1.10'
$SIMBOLO = 'XAUUSD'
$PERIODO = 'M1'
$ASSE_ATTESO = 'InpMagic=775800||775800||50||775850||Y'
$MAGIC_AMMESSI = @('775800', '775850')
$N_PIN_ATTESI = 30
$TETTO_BARRE = 100000
$AVVISO_BARRE = 95000
if($Pin -notmatch '^[0-9a-fA-F]{40}$'){ throw '-Pin obbligatorio e di 40 caratteri esadecimali: senza, girerebbe la punta del branch spacciandola per un commit congelato.' }
$Pin = $Pin.ToLower()
if($Lotto -notmatch '^(S0|R1A|R1B)$'){ throw ('-Lotto deve essere S0, R1A o R1B (e ' + $Lotto + ').') }
foreach($hx in @($ShaEA, $ShaInc, $ShaProva)){ if($hx -notmatch '^[0-9a-fA-F]{64}$'){ throw '-ShaEA, -ShaInc e -ShaProva devono essere di 64 caratteri esadecimali (SHA256 calcolato dal commit, mai dal disco).' } }
$ShaEA = $ShaEA.ToUpper(); $ShaInc = $ShaInc.ToUpper(); $ShaProva = $ShaProva.ToUpper()
if($TimeoutRunMin -lt 1 -or $TimeoutRunMin -gt 90){ throw '-TimeoutRunMin fuori da 1-90 minuti.' }
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
# i blocchi leggibili a macchina del file prova: '#  @GBA-TIPO k=v k=v ...'
function BloccoGba($riga){
  $h = @{}
  foreach($kv in ($riga -split '\s+')){
    if($kv -eq ''){ continue }
    $p = $kv -split '=', 2
    if($p.Count -ne 2){ throw ('blocco @GBA malformato: ' + $riga) }
    if($h.ContainsKey($p[0])){ throw ('blocco @GBA con chiave doppia ' + $p[0] + ': ' + $riga) }
    $h[$p[0]] = $p[1]
  }
  return $h
}
# il report .htm di MT5: tabella di celle label / valore. Si tolgono i tag, si cerca "|ETICHETTA:|valore|". Etichette italiane e inglesi.
function CercaCella([string]$t, [string[]]$etichette){
  foreach($e in $etichette){
    $m = [regex]::Match($t, '\|' + $e + ':\|([^|]*)\|')
    if($m.Success){ return (([regex]::Replace($m.Groups[1].Value, '\s', ''))) }
  }
  return $null
}
function LeggiReport($path){
  $r = @{ Ok = $false; Trades = $null; Profitto = $null; PF = ''; Qualita = ''; Barre = $null; Ticks = $null; Motivo = ''; Expert = $null; Simbolo = $null; Periodo = $null }
  $testo = Leggi-Condiviso $path
  if([string]::IsNullOrEmpty($testo)){ $r.Motivo = 'report vuoto o illeggibile'; return $r }
  $t = [regex]::Replace($testo, '<[^>]+>', '|')
  $t = [regex]::Replace($t, '\s*\|[\s|]*', '|')
  $vt = CercaCella $t @('Numero di Operazioni di Trading Totali', 'Total Trades')
  $vp = CercaCella $t @('Profitto Totale Netto', 'Total Net Profit')
  $vf = CercaCella $t @('Fattore di Profitto', 'Profit Factor')
  $vq = CercaCella $t @('Qualit. dello Storico', 'History Quality')
  $vb = CercaCella $t @('Barre', 'Bars')
  $vk = CercaCella $t @('Ticks')
  if($null -ne $vf){ $r.PF = $vf }
  if($null -ne $vq){ $r.Qualita = $vq }
  if($null -ne $vb -and $vb -match '^[0-9]+$'){ $r.Barre = [long]$vb }
  if($null -ne $vk -and $vk -match '^[0-9]+$'){ $r.Ticks = [long]$vk }
  $r.Expert  = CercaCella $t @('Expert')
  $r.Simbolo = CercaCella $t @('Simbolo', 'Symbol')
  $r.Periodo = CercaCella $t @('Periodo', 'Period')
  if($null -eq $vt){ $r.Motivo = 'etichetta del totale operazioni (Numero di Operazioni di Trading Totali / Total Trades) NON trovata'; return $r }
  if($null -eq $vp){ $r.Motivo = 'etichetta del profitto netto (Profitto Totale Netto / Total Net Profit) NON trovata'; return $r }
  if($vt -notmatch '^[0-9]+$'){ $r.Motivo = 'totale operazioni non numerico: "' + $vt + '"'; return $r }
  if($vp -notmatch '^-?[0-9]+(\.[0-9]+)?$'){ $r.Motivo = 'profitto netto non numerico: "' + $vp + '"'; return $r }
  $r.Trades = [int]$vt
  $r.Profitto = Num $vp
  $r.Ok = $true
  return $r
}

# ---------------------------------------------------------------------
#  0. LA MACCHINA E IL TERMINALE. Fail-closed, come NATCLA_F0_PASSATE.
# ---------------------------------------------------------------------
Titolo '0 - MACCHINA E TERMINALE'
if($env:COMPUTERNAME -ne 'DESKTOP-H4D7CAJ'){
  throw ('GBA_R0_PASSATE gira SOLO sul PC di backtest DESKTOP-H4D7CAJ. Qui la macchina si chiama: ' + $env:COMPUTERNAME + '. Sul VPS VMI3047753 non si lancia: la challenge FTMO sta operando (firma del 21/09/2026: i round girano sul PC di backtest).')
}
Dico ('pc   : ' + $env:COMPUTERNAME) 'Green'
Dico ('pin  : ' + $Pin) 'Green'
Dico ('lotto: ' + $Lotto) 'Green'
$Mutex = New-Object System.Threading.Mutex($false, 'Global\ABTG_GBA_R0')
$preso = $false
# un giro precedente interrotto (finestra chiusa, Ctrl+C, crash) lascia il blocco ABBANDONATO: .NET lo segnala con un'eccezione e il blocco e comunque nostro
try{ $preso = $Mutex.WaitOne(0) } catch [System.Threading.AbandonedMutexException] { $preso = $true; Dico 'il blocco Global\ABTG_GBA_R0 era stato lasciato da un giro INTERROTTO: lo riprendo (nessun altro giro sta girando)' 'Yellow' }
if(-not $preso){
  throw 'Un ALTRO giro di GBA_R0 sta gia girando su questo PC (mutex Global\ABTG_GBA_R0 occupato). Un solo giro alla volta: aspetta che finisca, NON chiudere il suo terminale.'
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
# le ALTRE installazioni MT5 di questo PC: il censimento P0 del 05/10/2026 (risultati_archivio/DUKA_P0_20261005_171046/REFERTO_DUKA_P0.txt, sez. 5)
# ne ha trovate DUE oltre al BCM: C:\MT5_Backtest e C:\FundedNext_Manuale. Sono AMMESSE PER NOME (chiuse, non toccate); una NON in elenco ferma tutto (classe 1157).
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
Scarica ('mql5/Experts/' + $EXPERT + '.mq5') $srcEA 'GbaDecidi'
Scarica 'mql5/Include/ABTG_PausaGuardian.mqh' $srcInc 'ABTG_GuardiaIngresso'
Scarica ('backtest_pipeline/prove/' + $PROVA) $fileProva '@GBA-LOTTO'
foreach($ck in @(@($srcEA, $ShaEA, ($EXPERT + '.mq5')), @($srcInc, $ShaInc, 'ABTG_PausaGuardian.mqh'), @($fileProva, $ShaProva, $PROVA))){
  $hh = (Get-FileHash -LiteralPath $ck[0] -Algorithm SHA256).Hash
  if($hh -ne $ck[1]){ throw ($ck[2] + ' scaricato al pin ha SHA256 ' + $hh + ' invece di ' + $ck[1] + ' (quello calcolato dal commit): copia sbagliata o cache di GitHub. Non si parte.') }
  Dico ($ck[2] + ': SHA256 ' + $hh.Substring(0,12) + ' = quello della riga') 'Green'
}
if(-not (Select-String -LiteralPath $srcEA -Pattern ('#property\s+version\s+"' + [regex]::Escape($VERSIONE_ATTESA) + '"') -Quiet)){ throw ('il sorgente dell EA non dichiara #property version "' + $VERSIONE_ATTESA + '". Non si parte.') }

# --- il file prova: pin, asse tecnico, blocchi GBA
$pinProva = New-Object System.Collections.ArrayList
$assi = New-Object System.Collections.ArrayList
$blocchi = @{ TRANCHE = @(); CELLA = @(); LOTTO = @() }
foreach($r in (Get-Content -LiteralPath $fileProva)){
  $t = $r.Trim()
  if($t -match '^#\s*@GBA-(TRANCHE|CELLA|LOTTO)\s+(.*)$'){ $tipoB = $Matches[1]; $corpoB = $Matches[2]; $blocchi[$tipoB] = @($blocchi[$tipoB]) + @((BloccoGba $corpoB)); continue }
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
foreach($kk in @('InpSymbol','InpSignalTF','InpChannelBars','InpEmaPeriod','InpAtrPeriod','InpSpreadMaxATR','InpSL_ATR','InpTrail_ATR','InpTimeExitBars','InpUseBreakeven','InpBE_TriggerATR','InpBE_OffsetATR','InpLotMode','InpLots','InpUsaGuardian','InpVerbose','InpAutoTest','InpHourStart','InpHourEnd','InpMaxTradesPerDay','InpMaxDailyLoss','InpAllowLong','InpAllowShort','InpSlippagePoints','InpCheckFreeMargin','InpTrailAtrMode','InpTrendTF','InpAtrTF','InpRiskPct','InpComment')){
  if(-not $pinH.ContainsKey($kk)){ throw ('il file prova non ha il pin ' + $kk + ': non e il file che lo script si aspetta. Non si parte.') }
}
if($pinH['InpSymbol'] -ne $SIMBOLO){ throw ('InpSymbol del file prova e ' + $pinH['InpSymbol'] + ' invece di ' + $SIMBOLO + '. Non si parte.') }
if($pinH['InpSignalTF'] -ne '1'){ throw 'InpSignalTF del file prova non e 1 (PERIOD_M1). Non si parte.' }
if($pinH['InpVerbose'] -ne 'true'){ throw 'InpVerbose del file prova non e true: senza, il giornale non ha le righe dei segnali. Non si parte.' }
if($pinH['InpLotMode'] -ne '0' -or (Num $pinH['InpLots']) -ne 1.0){ throw 'il file prova non ha lotto fisso 1,00 (InpLotMode=0, InpLots=1.0): decisione di Claudio del 09/10. Non si parte.' }
if($blocchi.TRANCHE.Count -ne 3 -or $blocchi.CELLA.Count -ne 4 -or $blocchi.LOTTO.Count -ne 3){ throw ('blocchi @GBA letti: tranche ' + @($blocchi.TRANCHE).Count + ' (attese 3), celle ' + @($blocchi.CELLA).Count + ' (attese 4), lotti ' + @($blocchi.LOTTO).Count + ' (attesi 3: S0, R1A, R1B). Non si parte.') }
$trDef = @{}
foreach($b in $blocchi.TRANCHE){
  if(@($b.Keys).Count -ne 3 -or -not $b.ContainsKey('nome') -or -not $b.ContainsKey('da') -or -not $b.ContainsKey('a')){ throw 'un blocco @GBA-TRANCHE non ha esattamente nome, da, a.' }
  if($b['da'] -notmatch '^\d{4}\.\d\d\.\d\d$' -or $b['a'] -notmatch '^\d{4}\.\d\d\.\d\d$'){ throw ('tranche ' + $b['nome'] + ': date non aaaa.mm.gg.') }
  $trDef[$b['nome']] = $b
}
$ceDef = @{}
foreach($b in $blocchi.CELLA){
  # UNA variabile per file prova: la cella puo' dichiarare SOLO nome e InpSpreadMaxATR
  if(@($b.Keys).Count -ne 2 -or -not $b.ContainsKey('nome') -or -not $b.ContainsKey('InpSpreadMaxATR')){ throw ('la cella ' + $b['nome'] + ' dichiara qualcosa di diverso da InpSpreadMaxATR: una variabile per file prova, lo script si ferma.') }
  if($b['InpSpreadMaxATR'] -notmatch '^[0-9]+\.[0-9]+$'){ throw ('cella ' + $b['nome'] + ': InpSpreadMaxATR non e un decimale col punto.') }
  $ceDef[$b['nome']] = $b
}
if((Num $ceDef['REPL']['InpSpreadMaxATR']) -ne (Num $pinH['InpSpreadMaxATR'])){ throw 'la cella REPL non coincide col pin InpSpreadMaxATR del file prova: la replica non e la replica. Non si parte.' }
$lottoDef = @($blocchi.LOTTO | Where-Object { $_['nome'] -eq $Lotto })
if($lottoDef.Count -ne 1){ throw ('lotto ' + $Lotto + ' non trovato (o doppio) nel file prova.') }
$lottoDef = $lottoDef[0]
$tettoMin = [int]$lottoDef['tetto_min']
$modello = [int]$lottoDef['modello']
if($modello -ne 1 -and $modello -ne 4){ throw ('modello del lotto ' + $Lotto + ' = ' + $modello + ': ammessi 1 (OHLC su M1) e 4 (ticks reali).') }
$runs = New-Object System.Collections.ArrayList
foreach($voce in ($lottoDef['passate'] -split ',')){
  $pz = $voce -split ':'
  if($pz.Count -lt 2 -or $pz.Count -gt 3){ throw ('voce di passata malformata: ' + $voce) }
  if(-not $ceDef.ContainsKey($pz[0])){ throw ('cella ' + $pz[0] + ' del lotto ' + $Lotto + ' inesistente.') }
  if(-not $trDef.ContainsKey($pz[1])){ throw ('tranche ' + $pz[1] + ' del lotto ' + $Lotto + ' inesistente.') }
  $mg = '775800'; if($pz.Count -eq 3){ $mg = $pz[2] }
  if($MAGIC_AMMESSI -notcontains $mg){ throw ('magic ' + $mg + ' non ammesso (solo i due dell asse tecnico: ' + ($MAGIC_AMMESSI -join ', ') + ').') }
  [void]$runs.Add([pscustomobject]@{ Cella = $ceDef[$pz[0]]; Tranche = $trDef[$pz[1]]; Magic = $mg })
}
Dico ('file prova letto: ' + $pinProva.Count + ' pin + asse tecnico; lotto ' + $Lotto + ': ' + $runs.Count + ' passate, Modello ' + $modello + ', tetto ' + $tettoMin + ' minuti') 'Green'

Copy-Item -LiteralPath $srcEA  -Destination (Join-Path $MqlExp ($EXPERT + '.mq5')) -Force
Copy-Item -LiteralPath $srcInc -Destination (Join-Path $MqlInc 'ABTG_PausaGuardian.mqh') -Force

$ex5 = Join-Path $MqlExp ($EXPERT + '.ex5')
$logC = Join-Path $Work 'compile_gba.log'
# il verdetto NON e' il codice d'uscita di MetaEditor (a volte si stacca): e' l'esistenza dell'.ex5 appena prodotto. Ogni argomento fra parentesi (classe 1152).
# COMPILAZIONE FALLITA: e' la PRIMA compilazione vera di ABTG_GoldBreakoutATR (mai compilato: report/EA_GBA_NOTE_2026-10-09.md par. 3). Il log di MetaEditor
# va in uno zip sul Desktop (GBA_R0_<lotto>_COMPILAZIONE_FALLITA.zip), non solo nella finestra; nessuna passata parte.
function FermaCompilazione($perche){
  $dskC  = [Environment]::GetFolderPath('Desktop')
  $CartC = Join-Path $dskC ('GBA_R0_' + $Lotto + '_COMPILAZIONE_FALLITA')
  $zipC  = $CartC + '.zip'
  $stC   = (Get-Date).ToString('yyyyMMdd_HHmmss')
  try{
    if(Test-Path -LiteralPath $CartC){ Move-Item -LiteralPath $CartC -Destination ($CartC + '_VECCHIA_' + $stC) -Force }
    if(Test-Path -LiteralPath $zipC){ Move-Item -LiteralPath $zipC -Destination ($CartC + '_VECCHIO_' + $stC + '.zip') -Force }
    New-Item -ItemType Directory -Force -Path $CartC | Out-Null
    $haLog = Test-Path -LiteralPath $logC
    $righeLog = @()
    if($haLog){
      Copy-Item -LiteralPath $logC -Destination (Join-Path $CartC 'compile_gba.log') -Force
      $righeLog = @(((Leggi-Condiviso $logC) -split "`r?`n") | Where-Object { $_ -match '(?i)error|errori|warning|avvis|result|risultato' } | Select-Object -First 60)
    }
    $testaC = @(('GBA R0 lotto ' + $Lotto + ': COMPILAZIONE DI ' + $EXPERT + ' FALLITA. Nessuna passata lanciata, nessun ordine.'), ('motivo: ' + $perche), ('pin: ' + $Pin + '   pc: ' + $env:COMPUTERNAME + '   data: ' + $stC), ('log di MetaEditor presente: ' + $haLog), '', 'righe di errore/avviso del log (il log intero e compile_gba.log):')
    (($testaC + $righeLog) -join "`r`n") | Set-Content -LiteralPath (Join-Path $CartC 'COMPILAZIONE_FALLITA.txt') -Encoding ASCII
    Compress-Archive -Path (Join-Path $CartC '*') -DestinationPath $zipC -Force
    Write-Host ('   ZIP DA MANDARE (compilazione fallita): ' + $zipC) -ForegroundColor Red
  } catch { Write-Host ('   zip della compilazione NON creato (' + $_.Exception.Message + '): il log e in ' + $logC) -ForegroundColor Red }
  throw ('COMPILAZIONE FALLITA: ' + $perche + ' Nessuna passata e partita. Manda lo zip GBA_R0_' + $Lotto + '_COMPILAZIONE_FALLITA.zip dal Desktop.')
}
Remove-Item -LiteralPath $logC -Force -ErrorAction SilentlyContinue
Remove-Item -LiteralPath $ex5 -Force -ErrorAction SilentlyContinue
# classe 1168 (i): un .ex5 VECCHIO che resta sul disco passerebbe per il compilato nuovo
if(Test-Path -LiteralPath $ex5){ FermaCompilazione 'il vecchio .ex5 non si cancella: un compilato vecchio passerebbe per nuovo.' }
$pMe = Start-Process -FilePath $MetaEditor -ArgumentList @(('/compile:' + (Join-Path $MqlExp ($EXPERT + '.mq5'))), ('/log:' + $logC)) -PassThru
$attC = 0
while(-not (Test-Path -LiteralPath $ex5) -and $attC -lt 60){ Start-Sleep -Seconds 2; $attC = $attC + 1 }
if(-not (Test-Path -LiteralPath $ex5)){
  try{ if(-not $pMe.HasExited){ $pMe.Kill() } }catch{ }
  if(Test-Path -LiteralPath $logC){ (Leggi-Condiviso $logC) -split "`r?`n" | Select-Object -Last 20 | ForEach-Object { Write-Host ('     ' + $_) -ForegroundColor DarkYellow } }
  FermaCompilazione ($EXPERT + '.ex5 NON prodotto dopo 120 secondi. Senza il compilato il giro non parte: il log di MetaEditor e qui sopra.')
}
# classe 1168 (ii): si aspetta che MetaEditor ESCA prima di leggere il log (al massimo 60 secondi)
$attE = 0
while(-not $pMe.HasExited -and $attE -lt 30){ Start-Sleep -Seconds 2; $attE = $attE + 1 }
Start-Sleep -Seconds 3
$testoLogC = ''
if(Test-Path -LiteralPath $logC){ $testoLogC = Leggi-Condiviso $logC }
$compErr = -1; $compWarn = -1
# classe 1168 (iii): la riga del risultato in inglese e in italiano, anche al singolare
$mRes = [regex]::Match($testoLogC, '(\d+)\s+(?:errors?|errori|errore),\s*(\d+)\s+(?:warnings?|avvisi|avviso)')
if($mRes.Success){ $compErr = [int]$mRes.Groups[1].Value; $compWarn = [int]$mRes.Groups[2].Value }
if($compErr -gt 0){
  ($testoLogC -split "`r?`n") | Where-Object { $_ -match '(?i)error|errori' } | Select-Object -First 20 | ForEach-Object { Write-Host ('     ' + $_) -ForegroundColor DarkYellow }
  FermaCompilazione ('MetaEditor ha prodotto l.ex5 ma il log dice ' + $compErr + ' errori: non si usa un compilato dubbio.')
}
Dico ('compilato: ' + $ex5 + '   SHA256 .ex5 ' + (Get-FileHash -LiteralPath $ex5 -Algorithm SHA256).Hash.Substring(0,12)) 'Green'
if($compErr -eq 0){ Dico ('log di compilazione: 0 errori, ' + $compWarn + ' avvisi') $(if($compWarn -eq 0){'Green'}else{'Yellow'}) }
else { Dico 'log di compilazione: riga del risultato NON letta (formato diverso?): il verdetto e l esistenza dell .ex5 appena prodotto (quello vecchio e stato cancellato prima)' 'Yellow' }
foreach($lw in @(($testoLogC -split "`r?`n") | Where-Object { $_ -match '(?i)warning|avviso|avvisi' -and $_ -notmatch '\d+\s+(?:errors?|errori|errore),' } | Select-Object -First 12)){ Dico ('   ' + $lw) 'Yellow' }

# ---------------------------------------------------------------------
#  2. LE PASSATE SINGOLE (Optimization=0)
# ---------------------------------------------------------------------
$dsk  = [Environment]::GetFolderPath('Desktop')
$Cart = Join-Path $dsk ('GBA_R0_' + $Lotto)
$zip  = Join-Path $dsk ('GBA_R0_' + $Lotto + '.zip')
$stampa = (Get-Date).ToString('yyyyMMdd_HHmmss')
if(Test-Path -LiteralPath $Cart){ Move-Item -LiteralPath $Cart -Destination ($Cart + '_VECCHIA_' + $stampa) -Force; Dico ('cartella di un giro PRECEDENTE rinominata: ' + $Cart + '_VECCHIA_' + $stampa) 'Yellow' }
if(Test-Path -LiteralPath $zip){ Move-Item -LiteralPath $zip -Destination (Join-Path $dsk ('GBA_R0_' + $Lotto + '_VECCHIO_' + $stampa + '.zip')) -Force; Dico ('zip di un giro PRECEDENTE rinominato con la data') 'Yellow' }
New-Item -ItemType Directory -Force -Path $Cart | Out-Null
New-Item -ItemType Directory -Force -Path (Join-Path $Cart 'report'), (Join-Path $Cart 'log'), (Join-Path $Cart 'ini') | Out-Null
Copy-Item -LiteralPath $fileProva -Destination $Cart -Force
if(Test-Path -LiteralPath $logC){ Copy-Item -LiteralPath $logC -Destination (Join-Path $Cart 'compile_gba.log') -Force }

$LogRoot = Join-Path $env:APPDATA 'MetaQuotes'
$RadiciLog = @($LogRoot, (Join-Path $InstAttesa 'Tester'))
$reFin = New-Object Text.RegularExpressions.Regex(('Tester\s+(?<sim>[A-Za-z0-9_.#-]+),(?<tf>[A-Za-z0-9]+)(?:\s+\([^)]*\))?:\s+testing of Experts\\' + [regex]::Escape($EXPERT) + '\.ex5 from (?<da>\d{4}\.\d\d\.\d\d) (?<ha>\d\d:\d\d) to (?<a>\d{4}\.\d\d\.\d\d) (?<hb>\d\d:\d\d)'), [Text.RegularExpressions.RegexOptions]::IgnoreCase)
$reGba = New-Object Text.RegularExpressions.Regex('(?<st>\d{4}\.\d\d\.\d\d \d\d:\d\d:\d\d)\s+(?<msg>\[GBA.*)$')
$reBarre = New-Object Text.RegularExpressions.Regex('(?<sim>[A-Za-z0-9_.#-]+),(?<tf>[A-Za-z0-9]+): (?<tick>\d+) ticks, (?<barre>\d+) bars generated')
$reTickIni = New-Object Text.RegularExpressions.Regex('(?<sim>[A-Za-z0-9_.#-]+): ticks data begins from (?<d>\d{4}\.\d\d\.\d\d)')
$reIngresso = New-Object Text.RegularExpressions.Regex('^\[GBA\] (BUY|SELL) [0-9.]+ lotti @')

# la scoperta ricorsiva dei .log si fa UNA VOLTA a inizio lotto e ricorda le CARTELLE (NATCLA_F0, deviazione 11)
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
  # i log di MT5 sono UTF-16 LE con BOM: la codifica si legge dal BOM all'inizio del FILE, poi si salta all'offset registrato prima della passata
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
# la riga AVVIO e le righe dei parametri, scritte come l'EA le stampa (PrintFormat: spread a 3 decimali, gli altri decimali a 2)
function Dec2($s){ return ('{0:0.00}' -f (Num $s)) }
function NeedlesAvvio($cella, $magic){
  $n = New-Object System.Collections.ArrayList
  [void]$n.Add('AVVIO v' + $VERSIONE_ATTESA)
  [void]$n.Add('InpSymbol="' + $pinH['InpSymbol'] + '" -> simbolo ' + $pinH['InpSymbol'])
  [void]$n.Add('InpSignalTF=PERIOD_M1 -> PERIOD_M1')
  [void]$n.Add('InpTrendTF=PERIOD_CURRENT -> PERIOD_M1')
  [void]$n.Add('InpAtrTF=PERIOD_CURRENT -> PERIOD_M1')
  [void]$n.Add('InpChannelBars=' + $pinH['InpChannelBars'] + ' (')
  [void]$n.Add('InpEmaPeriod=' + $pinH['InpEmaPeriod'] + ' |')
  [void]$n.Add('InpAtrPeriod=' + $pinH['InpAtrPeriod'] + ' |')
  [void]$n.Add('InpSpreadMaxATR=' + ('{0:0.000}' -f (Num $cella['InpSpreadMaxATR'])))
  [void]$n.Add('InpAllowLong=' + $pinH['InpAllowLong'] + ' | InpAllowShort=' + $pinH['InpAllowShort'])
  [void]$n.Add('InpSL_ATR=' + (Dec2 $pinH['InpSL_ATR']) + ' |')
  [void]$n.Add('InpTrail_ATR=' + (Dec2 $pinH['InpTrail_ATR']) + ' |')
  [void]$n.Add('InpTrailAtrMode=' + $pinH['InpTrailAtrMode'] + ' (')
  [void]$n.Add('InpTimeExitBars=' + $pinH['InpTimeExitBars'])
  [void]$n.Add('InpUseBreakeven=' + $pinH['InpUseBreakeven'] + ' |')
  [void]$n.Add('InpBE_TriggerATR=' + (Dec2 $pinH['InpBE_TriggerATR']) + ' |')
  [void]$n.Add('InpBE_OffsetATR=' + (Dec2 $pinH['InpBE_OffsetATR']))
  [void]$n.Add('InpSlippagePoints=' + $pinH['InpSlippagePoints'] + ' |')
  [void]$n.Add('InpMaxDailyLoss=' + (Dec2 $pinH['InpMaxDailyLoss']))
  [void]$n.Add('InpMaxTradesPerDay=' + $pinH['InpMaxTradesPerDay'])
  [void]$n.Add('InpCheckFreeMargin=' + $pinH['InpCheckFreeMargin'] + ' |')
  [void]$n.Add('InpHourStart=' + $pinH['InpHourStart'] + ' |')
  [void]$n.Add('InpHourEnd=' + $pinH['InpHourEnd'])
  [void]$n.Add('InpLotMode=' + $pinH['InpLotMode'] + ' (')
  [void]$n.Add('InpLots=' + (Dec2 $pinH['InpLots']) + ' |')
  [void]$n.Add('InpMagic=' + $magic + ' |')
  [void]$n.Add('InpComment="' + $pinH['InpComment'] + '"')
  [void]$n.Add('InpUsaGuardian=' + $pinH['InpUsaGuardian'])
  [void]$n.Add('InpVerbose=' + $pinH['InpVerbose'])
  [void]$n.Add('InpAutoTest=' + $pinH['InpAutoTest'])
  return $n
}

Titolo ('2 - LOTTO ' + $Lotto + ': ' + $runs.Count + ' PASSATE SINGOLE (Modello ' + $modello + ', deposito 100000 EUR, lotto fisso 1,00)')
$TLotto = Get-Date
$manifest = New-Object System.Collections.ArrayList
[void]$manifest.Add('lotto;passata;cella;spread_max_atr;tranche;da;a;modello;magic;t_avvio;durata_s;stato;trades_report;profitto_report;pf_report;qualita;barre_report;ticks_report;barre_gen;ticks_gen;ticks_inizio;righe_gba;ingressi_log;avvio_ok;autotest;finestra;motivi')
$nOk = 0; $nKo = 0; $nNon = 0; $sommaDur = 0.0; $nDur = 0
$abort = $false
$k = 0
$riassunti = @{}
foreach($ru in $runs){
  $k = $k + 1
  $cella = $ru.Cella; $tr = $ru.Tranche; $mg = $ru.Magic
  $tag = $Lotto + '_' + $k.ToString('00') + '_' + $cella['nome'] + '_' + $tr['nome'] + '_m' + $mg
  $etich = '[' + $k + '/' + $runs.Count + '] ' + $cella['nome'] + ' ' + $tr['nome'] + ' magic ' + $mg
  $minDa = ((Get-Date) - $TLotto).TotalMinutes
  if($abort -or $minDa -ge $tettoMin){
    $nNon = $nNon + 1
    $why = 'tetto di ' + $tettoMin + ' minuti'; if($abort){ $why = 'lotto fermato' }
    [void]$manifest.Add($Lotto + ';' + $tag + ';' + $cella['nome'] + ';' + $cella['InpSpreadMaxATR'] + ';' + $tr['nome'] + ';' + $tr['da'] + ';' + $tr['a'] + ';' + $modello + ';' + $mg + ';;0;NON_LANCIATA;;;;;;;;;;0;0;no;no;;' + $why)
    Write-Host ('   ' + $etich + '  NON LANCIATA (' + $why + ', minuto ' + [int]$minDa + ')') -ForegroundColor Red
    continue
  }
  if((@(Get-Process -Name terminal64 -ErrorAction SilentlyContinue)).Count -gt 0){
    Write-Host ('   ' + $etich + '  un terminal64 e ancora VIVO prima della passata: il lotto si ferma, non apro un secondo terminale.') -ForegroundColor Red
    $abort = $true; $nNon = $nNon + 1
    [void]$manifest.Add($Lotto + ';' + $tag + ';' + $cella['nome'] + ';' + $cella['InpSpreadMaxATR'] + ';' + $tr['nome'] + ';' + $tr['da'] + ';' + $tr['a'] + ';' + $modello + ';' + $mg + ';;0;NON_LANCIATA;;;;;;;;;;0;0;no;no;;terminale ancora vivo')
    continue
  }
  # --- l'ini: i 30 pin del file prova, con SOLO InpSpreadMaxATR della cella e il magic della passata (asse tecnico)
  $righeIn = New-Object System.Collections.ArrayList
  foreach($pp in $pinProva){
    $val = $pp[1]
    if($pp[0] -eq 'InpSpreadMaxATR'){ $val = $cella['InpSpreadMaxATR'] }
    [void]$righeIn.Add($pp[0] + '=' + $val)
  }
  [void]$righeIn.Add('InpMagic=' + $mg)
  $nomeRep = 'GBA_R0_' + $tag
  $iniF = Join-Path $Work ('gba_' + $tag + '.ini')
  $testoIni = "[Experts]`r`nAllowLiveTrading=false`r`nAllowDllImport=false`r`n`r`n" +
              "[Tester]`r`nExpert=" + $EXPERT + ".ex5`r`nSymbol=" + $SIMBOLO + "`r`nPeriod=" + $PERIODO + "`r`nModel=" + $modello + "`r`n" +
              "Optimization=0`r`nFromDate=" + $tr['da'] + "`r`nToDate=" + $tr['a'] + "`r`nForwardMode=0`r`nDeposit=100000`r`nCurrency=EUR`r`nLeverage=100`r`n" +
              "ExecutionMode=0`r`nReplaceReport=1`r`nShutdownTerminal=1`r`nReport=" + $nomeRep + "`r`n`r`n" +
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
  $gbaMsg = @{}; $gbaSt = @{}; $gbaOrd = New-Object System.Collections.ArrayList; $nGrezze = 0
  $fin = @{}; $evTester = @{}; $barreGen = $null; $tickGen = $null; $tickIni = @{}; $illeggibili = 0
  foreach($f in @(ElencoLog)){
    $off = 0; if($foto.ContainsKey($f.FullName)){ $off = [long]$foto[$f.FullName] }
    if($f.Length -le $off){ continue }
    try{ $testo = LeggiCoda $f.FullName $off }catch{ $illeggibili = $illeggibili + 1; continue }
    foreach($riga in ($testo -split "`r?`n")){
      if($riga.Length -lt 12){ continue }
      $mg2 = $reGba.Match($riga)
      if($mg2.Success){
        $nGrezze = $nGrezze + 1
        $msg = $mg2.Groups['msg'].Value.TrimEnd()
        $st = $mg2.Groups['st'].Value
        $kk2 = $st + '|' + $msg.Substring(0, [math]::Min(70, $msg.Length))
        if(-not $gbaMsg.ContainsKey($kk2)){ $gbaMsg[$kk2] = $msg; $gbaSt[$kk2] = $st; [void]$gbaOrd.Add($kk2) }
        elseif($msg.Length -gt $gbaMsg[$kk2].Length){ $gbaMsg[$kk2] = $msg }
        continue
      }
      $mf = $reFin.Match($riga)
      if($mf.Success){ $fin[($mf.Groups['sim'].Value + '|' + $mf.Groups['tf'].Value + '|' + $mf.Groups['da'].Value + '|' + $mf.Groups['ha'].Value + '|' + $mf.Groups['a'].Value + '|' + $mf.Groups['hb'].Value)] = $mf; continue }
      $mb = $reBarre.Match($riga)
      if($mb.Success -and $mb.Groups['sim'].Value -eq $SIMBOLO){ $barreGen = [long]$mb.Groups['barre'].Value; $tickGen = [long]$mb.Groups['tick'].Value; $evTester[$riga.Trim()] = $true; continue }
      $mt = $reTickIni.Match($riga)
      if($mt.Success){ $tickIni[$mt.Groups['sim'].Value + ' ' + $mt.Groups['d'].Value] = $true; $evTester[$riga.Trim()] = $true; continue }
      # le righe del TESTER che raccontano un guasto (storia mancante, errore, memoria, terminale non collegato): servono a capire una passata morta
      if($evTester.Count -lt 60 -and $riga -match "`tTester`t" -and $riga -match '(?i)history|no data|cannot|failed|error|stopped|not found|disconnect|authoriz|synchron|download|no memory|final balance|Test passed'){ $evTester[$riga.Trim()] = $true }
    }
  }
  $motivi = New-Object System.Collections.ArrayList
  if($timeout){ [void]$motivi.Add('timeout di ' + $TimeoutRunMin + ' minuti') }
  # --- il giornale dell'EA: AVVIO, AUTOTEST, CONTA FINE, ingressi
  $testoAvvio = ''; $nIngr = 0; $autoPass = 0; $autoFail = 0; $contaFine = 0; $avvioRighe = 0
  foreach($kk2 in $gbaOrd){
    $m3 = $gbaMsg[$kk2]
    if($m3.StartsWith('[GBA] AVVIO v')){ $avvioRighe = $avvioRighe + 1 }
    if($m3 -match '^\[GBA\] (AVVIO|SEGNALE|SPREAD|LATI|USCITE|BREAKEVEN|ESECUZIONE|RISCHIO|IDENTITA)'){ $testoAvvio = $testoAvvio + $m3 + "`n" }
    if($reIngresso.IsMatch($m3)){ $nIngr = $nIngr + 1 }
    if($m3 -like '*[[]GBA][[]AUTOTEST] VERDETTO: PASS*'){ $autoPass = $autoPass + 1 }
    if($m3 -like '*[[]GBA][[]AUTOTEST]*FAIL*'){ $autoFail = $autoFail + 1 }
    if($m3.StartsWith('[GBA-CONTA] FINE')){ $contaFine = $contaFine + 1 }
  }
  $avvioOk = 'no'
  if($avvioRighe -eq 0){ [void]$motivi.Add('riga AVVIO dell EA NON trovata nei log (l EA non e partito? compilazione? ini ignorata?)') }
  elseif($avvioRighe -gt 1){ [void]$motivi.Add('PIU righe AVVIO distinte (' + $avvioRighe + '): log di due passate mescolati') }
  else {
    $mancano = @()
    foreach($nd in (NeedlesAvvio $cella $mg)){ if($testoAvvio.IndexOf($nd, [StringComparison]::Ordinal) -lt 0){ $mancano = $mancano + @($nd) } }
    if($mancano.Count -eq 0){ $avvioOk = 'si' } else { [void]$motivi.Add('AVVIO: nella configurazione stampata dall EA mancano ' + $mancano.Count + ' valori attesi: ' + (($mancano | Select-Object -First 6) -join ' ## ')) }
  }
  $autoOk = 'no'
  if($autoFail -gt 0){ [void]$motivi.Add('AUTOTEST dell EA: FAIL (' + $autoFail + ' righe): il compilato non fa quello che dice') }
  elseif($autoPass -ne 1){ [void]$motivi.Add('AUTOTEST: righe VERDETTO PASS = ' + $autoPass + ' (attesa 1)') }
  else { $autoOk = 'si' }
  if($contaFine -lt 1){ [void]$motivi.Add('riga [GBA-CONTA] FINE assente (OnDeinit non girato? passata interrotta?)') }
  # finestra girata, dal giornale del tester
  $finest = 'non letta'
  if($fin.Count -eq 1){
    $mf = $fin.Values | Select-Object -First 1
    $daG = $tr['da']; $aG = $tr['a']
    if($mf.Groups['sim'].Value -eq $SIMBOLO -and $mf.Groups['tf'].Value -eq $PERIODO -and $mf.Groups['da'].Value -eq $daG -and $mf.Groups['a'].Value -eq $aG -and $mf.Groups['ha'].Value -eq '00:00' -and $mf.Groups['hb'].Value -eq '00:00'){ $finest = $daG + '-' + $aG }
    else { $finest = 'DIVERSA: ' + $mf.Groups['sim'].Value + ',' + $mf.Groups['tf'].Value + ' ' + $mf.Groups['da'].Value + '-' + $mf.Groups['a'].Value; [void]$motivi.Add('finestra girata ' + $finest + ' invece di ' + $SIMBOLO + ',' + $PERIODO + ' ' + $daG + '-' + $aG) }
  } elseif($fin.Count -gt 1){ $finest = 'AMBIGUA'; [void]$motivi.Add('PIU intestazioni di passata nel giornale del tester: finestra non attribuibile') }
  # barre generate e profondita' dei tick
  if($null -eq $barreGen){ [void]$motivi.Add('riga "N ticks, M bars generated" NON trovata nel giornale del tester: il conto delle barre contro il tetto non e verificabile') }
  elseif($barreGen -ge $TETTO_BARRE){ [void]$motivi.Add('barre generate ' + $barreGen + ' >= ' + $TETTO_BARRE + ': la finestra e stata TRONCATA dal tetto del tester, la tranche va accorciata') }
  elseif($barreGen -ge $AVVISO_BARRE){ Dico ('   ATTENZIONE: barre generate ' + $barreGen + ' fra ' + $AVVISO_BARRE + ' e ' + $TETTO_BARRE + ': vicino al tetto') 'Yellow' }
  $tickIniTxt = (($tickIni.Keys | Sort-Object) -join ' / ')
  if($modello -eq 4){
    $okTick = $false
    foreach($tk in @($tickIni.Keys)){ $pz2 = $tk -split ' '; if($pz2[0] -eq $SIMBOLO -and $pz2[1].CompareTo($tr['da']) -le 0){ $okTick = $true } }
    if($tickIni.Count -eq 0){ Dico '   (la riga "ticks data begins from" non e nel giornale di questa passata: succede se i tick erano gia in cache; si riconferma dal report)' 'Yellow' }
    elseif(-not $okTick){ [void]$motivi.Add('ticks data begins from ' + $tickIniTxt + ': DOPO l inizio della tranche ' + $tr['da'] + ' (prima di quella data MT5 genera i tick: non sono reali)') }
  }
  # il report .htm
  $rep = $null
  foreach($rad in @($DataFolder, $InstAttesa, $Work, $MqlFiles, (Join-Path $env:USERPROFILE 'Desktop'))){
    if(-not (Test-Path -LiteralPath $rad)){ continue }
    $cr = @(Get-ChildItem -LiteralPath $rad -Filter ($nomeRep + '*.htm*') -File -ErrorAction SilentlyContinue | Where-Object { $_.LastWriteTime -ge $tRun } | Sort-Object LastWriteTime -Descending)
    if($cr.Count -gt 0){ $rep = $cr[0]; break }
  }
  $lr = $null; $nTrades = ''; $profitto = ''; $pfRep = ''; $qual = ''; $barRep = ''; $tickRep = ''
  if($null -eq $rep){ [void]$motivi.Add('report .htm della passata NON trovato (Report=' + $nomeRep + '): senza report non c e misura') }
  else {
    Copy-Item -LiteralPath $rep.FullName -Destination (Join-Path (Join-Path $Cart 'report') $rep.Name) -Force
    $lr = LeggiReport $rep.FullName
    if(-not $lr.Ok){ [void]$motivi.Add('report illeggibile: ' + $lr.Motivo) }
    else {
      $nTrades = [string]$lr.Trades; $profitto = [string]$lr.Profitto; $pfRep = $lr.PF; $qual = $lr.Qualita
      if($null -ne $lr.Barre){ $barRep = [string]$lr.Barre }
      if($null -ne $lr.Ticks){ $tickRep = [string]$lr.Ticks }
      if($null -ne $lr.Expert -and $lr.Expert -ne $EXPERT){ [void]$motivi.Add('il report e di un altro EA (' + $lr.Expert + ')') }
      if($null -ne $lr.Simbolo -and $lr.Simbolo -ne $SIMBOLO){ [void]$motivi.Add('il report e di un altro simbolo (' + $lr.Simbolo + ')') }
      if($null -ne $lr.Periodo){
        $mpd = [regex]::Match($lr.Periodo, '^' + $PERIODO + '\((\d{4}\.\d\d\.\d\d)-(\d{4}\.\d\d\.\d\d)\)')
        if(-not $mpd.Success){ [void]$motivi.Add('il periodo del report e "' + $lr.Periodo + '" invece di ' + $PERIODO + ' (' + $tr['da'] + ' - ' + $tr['a'] + ')') }
        else {
          $dA = [datetime]::ParseExact($mpd.Groups[2].Value, 'yyyy.MM.dd', $IC); $dB = [datetime]::ParseExact($tr['a'], 'yyyy.MM.dd', $IC)
          if($mpd.Groups[1].Value -ne $tr['da'] -or [math]::Abs(($dA - $dB).TotalDays) -gt 1){ [void]$motivi.Add('il periodo del report e "' + $lr.Periodo + '" invece di ' + $PERIODO + ' (' + $tr['da'] + ' - ' + $tr['a'] + ')') }
        }
      }
      if($modello -eq 4 -and $lr.Qualita -notmatch '^100%'){ [void]$motivi.Add('qualita dello storico "' + $lr.Qualita + '" invece di 100% ticks reali: il verdetto a ticks reali NON vale') }
      if($lr.Trades -eq 0){ [void]$motivi.Add('ZERO operazioni nel report') }
      if([math]::Abs($lr.Trades - $nIngr) -gt 1){ [void]$motivi.Add('operazioni del report ' + $lr.Trades + ' contro ingressi del giornale ' + $nIngr + ' (attesi uguali, +/-1): righe del giornale perse o report di un altra passata') }
    }
  }
  # il log dell'EA di questa passata, per intero
  $lg = New-Object System.Collections.ArrayList
  [void]$lg.Add('# passata ' + $etich + '   ini gba_' + $tag + '.ini   durata ' + [int]$dur + ' s   righe [GBA] uniche ' + $gbaOrd.Count + ' (grezze ' + $nGrezze + ')')
  foreach($e in $evTester.Keys){ [void]$lg.Add('# TESTER ' + $e) }
  foreach($e in $fin.Keys){ [void]$lg.Add('# FINESTRA ' + $e) }
  foreach($kk2 in $gbaOrd){ [void]$lg.Add($gbaSt[$kk2] + '   ' + $gbaMsg[$kk2]) }
  ($lg -join "`r`n") | Set-Content -LiteralPath (Join-Path (Join-Path $Cart 'log') ('GBA_' + $tag + '.txt')) -Encoding ASCII

  $stato = 'OK'
  if($motivi.Count -gt 0){ $stato = 'KO' }
  if($finest -eq 'non letta' -and $motivi.Count -eq 0){ $stato = 'OK_FINESTRA_NON_LETTA' }
  if($stato -like 'OK*'){ $nOk = $nOk + 1; $sommaDur = $sommaDur + $dur; $nDur = $nDur + 1 } else { $nKo = $nKo + 1 }
  $bgTxt = ''; if($null -ne $barreGen){ $bgTxt = [string]$barreGen }
  $tgTxt = ''; if($null -ne $tickGen){ $tgTxt = [string]$tickGen }
  [void]$manifest.Add($Lotto + ';' + $tag + ';' + $cella['nome'] + ';' + $cella['InpSpreadMaxATR'] + ';' + $tr['nome'] + ';' + $tr['da'] + ';' + $tr['a'] + ';' + $modello + ';' + $mg + ';' + $tRun.ToString('yyyy-MM-dd HH:mm:ss') + ';' + [int]$dur + ';' + $stato + ';' + $nTrades + ';' + $profitto + ';' + $pfRep + ';' + $qual + ';' + $barRep + ';' + $tickRep + ';' + $bgTxt + ';' + $tgTxt + ';' + $tickIniTxt + ';' + $gbaOrd.Count + ';' + $nIngr + ';' + $avvioOk + ';' + $autoOk + ';' + $finest + ';' + (($motivi -join ' | ') -replace ';', ','))
  if($lr -and $lr.Ok){ $riassunti[$cella['nome'] + '|' + $tr['nome'] + '|' + $mg] = $lr }
  $col = 'Green'; if($stato -ne 'OK'){ $col = 'Red' }
  Write-Host ('   ' + $etich + '  ' + $stato + '   ' + [int]$dur + ' s   operazioni ' + $nTrades + '   profitto ' + $profitto + '   PF ' + $pfRep + '   righe GBA ' + $gbaOrd.Count + '   barre ' + $bgTxt + '   AVVIO ' + $avvioOk + '   AUTOTEST ' + $autoOk + '   finestra ' + $finest) -ForegroundColor $col
  foreach($x in $motivi){ Write-Host ('        - ' + $x) -ForegroundColor Red }
  if($stato -like 'KO*'){ foreach($x in @($evTester.Keys | Select-Object -First 5)){ Write-Host ('        tester: ' + $x) -ForegroundColor DarkYellow } }
}
$durTot = ((Get-Date) - $TLotto).TotalMinutes

# G1 (solo S0): le due gemelle sul magic devono dare lo stesso report
$g1 = ''
if($Lotto -eq 'S0'){
  $a1 = $riassunti['REPL|T1|775800']; $b1 = $riassunti['REPL|T1|775850']
  if($null -eq $a1 -or $null -eq $b1){ $g1 = 'G1 NON VERIFICABILE: manca il report di una delle due gemelle (REPL su T1, magic 775800 e 775850).' }
  elseif($a1.Trades -eq $b1.Trades -and $a1.Profitto -eq $b1.Profitto -and $a1.PF -eq $b1.PF){ $g1 = 'G1 VERDE: le due gemelle hanno operazioni ' + $a1.Trades + ', profitto ' + $a1.Profitto + ', PF ' + $a1.PF + ' IDENTICI.' }
  else { $g1 = 'G1 ROSSO: gemella 775800 operazioni ' + $a1.Trades + ' profitto ' + $a1.Profitto + ' PF ' + $a1.PF + ' contro gemella 775850 operazioni ' + $b1.Trades + ' profitto ' + $b1.Profitto + ' PF ' + $b1.PF + ': il Modello 1 non e riproducibile, NESSUN conteggio di questo lotto si usa.' }
  $colg = 'Green'; if($g1 -notlike 'G1 VERDE*'){ $colg = 'Red' }
  Write-Host ('   ' + $g1) -ForegroundColor $colg
}

# ---------------------------------------------------------------------
#  3. RACCOLTA
# ---------------------------------------------------------------------
Titolo '3 - RACCOLTA'
$mediaS = 0.0; if($nDur -gt 0){ $mediaS = $sommaDur / $nDur }
$testa = @(
  ('GBA R0 -- lotto ' + $Lotto + ': ' + $EXPERT + ' v' + $VERSIONE_ATTESA + ' su ' + $SIMBOLO + ' M1, Modello ' + $modello + ', lotto fisso 1,00, deposito 100000 EUR, UNA variabile (InpSpreadMaxATR)'),
  ('data: ' + (Get-Date).ToString('yyyy-MM-dd HH:mm:ss') + '   pc: ' + $env:COMPUTERNAME + '   pin: ' + $Pin),
  ($EXPERT + '.mq5 SHA256 ' + $ShaEA + '   compilazione: ' + $compErr + ' errori, ' + $compWarn + ' avvisi (-1 = non letto)'),
  ('passate del lotto ' + $runs.Count + ': OK ' + $nOk + ', KO ' + $nKo + ', NON LANCIATE ' + $nNon + '   durata totale ' + [int]$durTot + ' minuti   media per passata OK ' + [int]$mediaS + ' secondi'),
  ('STIMA DEL PIANO INTERO (17 passate: S0 5 + R1A 3 + R1B 9) con la media di questo lotto: ' + [int](17 * $mediaS / 60.0) + ' minuti (valida solo se il Modello e lo stesso: S0 e OHLC, R1 e a ticks reali)'),
  'Guardian nel tester: FAIL-OPEN (irrilevante: nel tester non c e nessun altro EA).'
)
if($g1 -ne ''){ $testa = $testa + @($g1) }
$testa = $testa + @('')
(($testa + $manifest + @('',
  'COME SI LEGGE: python3 backtest_pipeline/leggi_gba_r0.py <questo zip o la cartella>. Prima lo STATO di ogni passata (OK / KO / NON_LANCIATA) e i motivi; poi i cancelli G0/G1/G2,',
  'n, frequenza, COSTO (stop/spread) PRIMA del PF, PF e DD, lato, concentrazione, ora (6 fasce), contro le attese e le soglie SCRITTE nel file prova prima dei numeri.',
  'Questo script RACCOGLIE e dice se ogni passata e affidabile: NON giudica, NON promuove, NON sceglie nessuna cella.')) -join "`r`n") | Set-Content -LiteralPath (Join-Path $Cart 'RIEPILOGO_R0.txt') -Encoding ASCII
(($manifest) -join "`r`n") | Set-Content -LiteralPath (Join-Path $Cart 'MANIFEST_R0.csv') -Encoding ASCII
Compress-Archive -Path (Join-Path $Cart '*') -DestinationPath $zip -Force
Write-Host ''
Write-Host ('passate OK ' + $nOk + ', KO ' + $nKo + ', NON LANCIATE ' + $nNon + ' su ' + $runs.Count + '   durata ' + [int]$durTot + ' minuti   media per passata OK ' + [int]$mediaS + ' s') -ForegroundColor Cyan
Write-Host ('ZIP PRONTO DA MANDARE: ' + $zip) -ForegroundColor Green
Write-Host 'FILE ATTESI NELLO ZIP: RIEPILOGO_R0.txt + MANIFEST_R0.csv + il file prova + compile_gba.log + report\GBA_R0_<passata>.htm + log\GBA_<passata>.txt + ini\gba_<passata>.ini (un report, un log e un ini per passata)' -ForegroundColor Gray
try{ $Mutex.ReleaseMutex() }catch{ }
$tutteOk = ($nKo -eq 0 -and $nNon -eq 0 -and $nOk -eq $runs.Count)
if($Lotto -eq 'S0' -and $g1 -ne '' -and $g1 -notlike 'G1 VERDE*'){ $tutteOk = $false }
if($tutteOk){ Write-Host 'ESITO GBA_R0: TUTTE LE PASSATE OK (rc 0)' -ForegroundColor Green; exit 0 }
Write-Host 'ESITO GBA_R0: ALMENO UNA PASSATA KO O NON LANCIATA, O G1 NON VERDE (rc 3): lo zip esce lo stesso, il MANIFEST dice quali e perche.' -ForegroundColor Red
exit 3
