# =====================================================================
#  MARCATORE_PASSATA_R276B_v1
#  PASSATA_R276B.ps1 -- R276b (T5, ARMO TARDIVO) IN PASSATA SINGOLA, PER LEGGERE IL GIORNALE DELL'EA
#
#  CHE COSA MISURA, e una cosa sola:
#    perche' R276b ha dato ZERO operazioni. UNA passata singola (Optimization=0)
#    dell'EA ABTG_Nasdaq_Apertura_US su NASUSD M5, tick reali, 2026.05.01 ->
#    2026.06.01, deposito 80000, con gli input di R276b (armo 19:00 server, flat
#    21:45, InpVerbose acceso). In ottimizzazione il tester NON esegue le Print
#    dell'EA (misurato in R274 e R276); in passata singola SI': qui si legge il
#    giornale e si CONTANO i messaggi dell'EA. Criteri e previsioni scritti
#    PRIMA dei numeri: report/R276B_PASSATA_SINGOLA_ATTESE_2026-10-21.md.
#
#  DERIVATO DA PASSATA_STOP_SUPREV_NAS.ps1 (guardie, risoluzione della cartella
#  dati, compilazione verificata dal .ex5, fotografia dei log prima del lancio,
#  timeout con CloseMainWindow, zip sul Desktop). DEVIAZIONI, tutte dichiarate:
#   1. EA e include al pin, ma con la verifica SHA256 contro quelli del giro
#      R276 (7F243CAC...AF744 e 3EC97115...A737): stesso motore di R276b.
#   2. Gli input sono 97 righe incluse QUI (bool 1/0 convertiti in true/false
#      secondo il tipo del sorgente) e CONFRONTATE col file prova al pin: ogni
#      primo valore del file prova deve coincidere. Le tre stringhe
#      (InpCorrSymbol, InpNewsFile, InpNewsCurrencies) NON sono nel file prova e
#      restano non imposte, come in R276b.
#   3. NIENTE spread orario e NIENTE G0 a banda: non c'e' una cella di
#      riferimento. Il report .htm e' letto per IDENTITA' (EA, simbolo, periodo,
#      deposito) e per i totali, senza soglie.
#   4. La lettura dei log NON e' il parser degli ingressi di SupRev: tutte le righe
#      "[Nasdaq Apertura US]" del giornale sono SALVATE e CONTATE per categoria e
#      per messaggio distinto. Nessun giudizio qui: la lettura e' di Claude.
#   5. Controllo di metodo M1: riga di avvio dell'EA con 19:00 / 35 min / 21:45
#      e riga CONFIG IN USO presenti. Se no, rc 3 = NON MISURATO.
#  INVARIATE: guardia macchina DESKTOP-H4D7CAJ, MT5 e MetaEditor chiusi, nessuna
#  installazione MT5 non censita, nessuna sedia sui grafici salvati.
#
#  E' UN BACKTEST, NON UN ORDINE. [Experts] AllowLiveTrading=false: il terminale
#  del PC di backtest e' loggato sul DEMO 50503392 e il 14/08/2026 da questa
#  macchina sono partiti ordini veri.
#
#  NON TOCCA, per nome: VPS VMI3047753 e TUTTE le sue cartelle dati (FTMO,
#  REALE, 100k, piccolo, manuale, banco, Pepperstone, Tickmill) e la sedia 770260.
#  Scrive SOLO: %USERPROFILE%\abtg_passata, MQL5\Experts e MQL5\Include del
#  terminale BCM di questa macchina, il Desktop.
#
#  NIENTE EMOJI QUI DENTRO (regola del 17/08): Windows PowerShell 5.1 legge i
#  .ps1 come ANSI e un'emoji dentro una stringa rompe il parser.
# =====================================================================
[CmdletBinding()]
param(
  [Parameter(Mandatory=$true)][string]$Pin,
  [int]$TimeoutMin = 45
)

$ErrorActionPreference = 'Stop'
$IC = [Globalization.CultureInfo]::InvariantCulture
[Threading.Thread]::CurrentThread.CurrentCulture   = $IC
[Threading.Thread]::CurrentThread.CurrentUICulture = $IC
[Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12

$EXPERT  = 'ABTG_Nasdaq_Apertura_US'
$SIMBOLO = 'NASUSD'
$PERIODO = 'M5'
$DataDa  = '2026.05.01'
$DataA   = '2026.06.01'
$DEPOSITO = 80000
$PROVA   = 'R276b_T5_armo_tardivo_NASDAQ_NASUSD.txt'
$MAGIC   = '798631'
$MARCA   = '[Nasdaq Apertura US]'
$SHA_EA  = '7F243CAC18EC5C955C1DF5B8F0CE0CB2AF564ADAF2B88E3A8F79F798C59AF744'
$SHA_INC = '3EC971152E85E0082488CC4243FF45AE09948C191D52AB96050B48F94641A737'
if($Pin -notmatch '^[0-9a-fA-F]{40}$'){ throw '-Pin obbligatorio e di 40 caratteri esadecimali: senza, girerebbe la punta del branch spacciandola per un commit congelato.' }
$Pin = $Pin.ToLower()
$RAW     = 'https://raw.githubusercontent.com/claudiospadaro12/GITHUB/' + $Pin + '/'
# gli input di R276b (primo valore di ogni riga Inp del file prova; bool 1/0 -> true/false)
$INPUT_INI = @(
  'InpTP1_ClosePct=50',
  'InpUsaGuardian=true',
  'InpSessionHour=19',
  'InpSessionMin=0',
  'InpRangeMinutes=35',
  'InpCloseHour=21',
  'InpCloseMin=45',
  'InpCloseAtEnd=true',
  'InpOneTradePerDay=true',
  'InpMaxPosSimbolo=0',
  'InpEntryMode=2',
  'InpRangeMode=0',
  'InpLevelTF=16385',
  'InpPrevWindowMin=60',
  'InpBufferPoints=200',
  'InpOCTimeframe=0',
  'InpPendingExpiryMin=120',
  'InpAllowLong=true',
  'InpAllowShort=true',
  'InpMinRangePts=0',
  'InpMaxRangePts=0',
  'InpRetestOffsetPts=0',
  'InpFadeOffsetPts=0',
  'InpDelayMinutes=30',
  'InpDelayDirMode=0',
  'InpUseGapFill=true',
  'InpGapMinPoints=150',
  'InpGapMinRR=1.5',
  'InpUseEmaFilter=false',
  'InpEmaFast=1',
  'InpEmaSlow=50',
  'InpFilterTF=16388',
  'InpUseSupertrend=false',
  'InpStAtrPeriod=10',
  'InpStMultiplier=2.5',
  'InpStTF=16385',
  'InpUseSupertrend3=false',
  'InpUseCorrelation=false',
  'InpCorrSymbol=SPXUSD',
  'InpCorrTF=16385',
  'InpCorrEmaFast=14',
  'InpCorrEmaSlow=100',
  'InpUseVwapFilter=false',
  'InpVwapTF=15',
  'InpRiskPercent=2',
  'InpSLMode=0',
  'InpAtrSlMult=1.5',
  'InpAtrPeriodMgmt=14',
  'InpTP1_R=0.5',
  'InpBreakevenAtTP1=true',
  'InpBEatR=0',
  'InpUseTrailing=true',
  'InpTrailStartR=0',
  'InpTrailMode=1',
  'InpTrailTF=5',
  'InpTrailAtrMult=2',
  'InpTrailFixedPts=410',
  'InpRunnerTP_R=0',
  'InpUseRoundLevels=false',
  'InpRoundStep=100',
  'InpRoundMinDistPts=50',
  'InpUseNewsFilter=false',
  'InpNewsFile=abtg_news.csv',
  'InpNewsMinImpact=3',
  'InpNewsBeforeMin=30',
  'InpNewsAfterMin=30',
  'InpNewsShiftMinutes=0',
  'InpNewsFlatten=true',
  'InpSlippagePts=0',
  'InpMinStopPts=500',
  'InpSkipIfTight=false',
  'InpMinBreakoutRangeATR=0',
  'InpUseVolumeFilter=true',
  'InpVolMult=1.5',
  'InpVolAvgBars=20',
  'InpUseAtrFilter=false',
  'InpAtrFilterBars=20',
  'InpAtrFilterMult=1',
  'InpConfirmMode=1',
  'InpUseVolRegime=false',
  'InpVolAtrPeriod=14',
  'InpVolLookback=100',
  'InpVolLowPct=20',
  'InpVolHighPct=80',
  'InpVolLowOffMult=0.7',
  'InpVolHighOffMult=1.5',
  'InpVolLowSlMult=0.75',
  'InpVolHighSlMult=1.5',
  'InpVolHighSizeMult=0.5',
  'InpUseSRFilter=false',
  'InpSRProximityPts=1500',
  'InpSRUsePrevDay=true',
  'InpSRUseRoundNumbers=true',
  'InpSRRoundInterval=10000',
  'InpMaxSpread=0',
  'InpVerbose=true',
  'InpMagic=798631'
)

function Dico($t,$c='Gray'){ Write-Host ('   ' + $t) -ForegroundColor $c }
function Titolo($t){ Write-Host ''; Write-Host ('=== ' + $t + ' ===') -ForegroundColor Cyan }
function Num($s){ return [double]::Parse($s, [Globalization.NumberStyles]::Float, $IC) }
function Dec($s){ return [decimal]::Parse($s, [Globalization.NumberStyles]::Float, $IC) }
function F2($x){ return ([decimal]$x).ToString('0.00', $IC) }
function F4($x){ return ([decimal]$x).ToString('0.0000', $IC) }
function Scarica($rel, $dest, $firma){
  Remove-Item -LiteralPath $dest -Force -ErrorAction SilentlyContinue
  Invoke-RestMethod -Uri ($RAW + $rel + '?cb=' + [Guid]::NewGuid().ToString('N')) -OutFile $dest
  if(-not (Select-String -LiteralPath $dest -SimpleMatch -Pattern $firma -Quiet)){
    throw ($rel + ' scaricato ma NON contiene "' + $firma + '": copia sbagliata o cache di GitHub. Non si parte.')
  }
}
function QuantD($ord, [decimal]$q){
  $n = $ord.Count
  if($n -eq 0){ return $null }
  $pos = $q * ($n - 1); $lo = [int][math]::Floor($pos); $hi = [int][math]::Ceiling($pos)
  if($lo -eq $hi){ return [decimal]$ord[$lo] }
  return [decimal]$ord[$lo] + ($pos - $lo) * ([decimal]$ord[$hi] - [decimal]$ord[$lo])
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
# il report .htm di MT5: tabella di celle label / valore. Si tolgono i tag,
# si cerca "|ETICHETTA:|valore|". Etichette italiane e inglesi.
function CercaCella([string]$t, [string[]]$etichette){
  foreach($e in $etichette){
    $m = [regex]::Match($t, '\|' + [regex]::Escape($e) + ':\|([^|]*)\|')
    if($m.Success){ return (([regex]::Replace($m.Groups[1].Value, '\s', ''))) }
  }
  return $null
}
function LeggiReport($path){
  $r = @{ Ok = $false; Trades = $null; Deals = $null; Profitto = $null; PF = ''; Motivo = ''; Expert = $null; Simbolo = $null; Periodo = $null; Deposito = $null; Inputs = @{} }
  $testo = Leggi-Condiviso $path
  if([string]::IsNullOrEmpty($testo)){ $r.Motivo = 'report vuoto o illeggibile'; return $r }
  $t = [regex]::Replace($testo, '<[^>]+>', '|')
  $t = [regex]::Replace($t, '\s*\|[\s|]*', '|')
  $vt = CercaCella $t @('Numero di Operazioni di Trading Totali', 'Total Trades')
  $vp = CercaCella $t @('Profitto Totale Netto', 'Total Net Profit')
  $vd = CercaCella $t @('Affari Totali', 'Total Deals')
  $vf = CercaCella $t @('Fattore di Profitto', 'Profit Factor')
  if($null -ne $vf){ $r.PF = $vf }
  $r.Expert  = CercaCella $t @('Expert')
  $r.Simbolo = CercaCella $t @('Simbolo', 'Symbol')
  $r.Periodo = CercaCella $t @('Periodo', 'Period')
  $r.Deposito = CercaCella $t @('Deposito Iniziale', 'Initial Deposit')
  foreach($mi2 in [regex]::Matches($t, '\|(Inp[A-Za-z0-9_]+)=([^|]*)(?=\|)')){ $r.Inputs[$mi2.Groups[1].Value] = $mi2.Groups[2].Value.Trim() }
  if($null -eq $vt){ $r.Motivo = 'etichetta del totale operazioni (Numero di Operazioni di Trading Totali / Total Trades) NON trovata'; return $r }
  if($null -eq $vp){ $r.Motivo = 'etichetta del profitto netto (Profitto Totale Netto / Total Net Profit) NON trovata'; return $r }
  if($vt -notmatch '^[0-9]+$'){ $r.Motivo = 'totale operazioni non numerico: "' + $vt + '"'; return $r }
  if($vp -notmatch '^-?[0-9]+(\.[0-9]+)?$'){ $r.Motivo = 'profitto netto non numerico: "' + $vp + '"'; return $r }
  $r.Trades = [int]$vt
  $r.Profitto = Dec $vp
  if($null -ne $vd -and $vd -match '^[0-9]+$'){ $r.Deals = [int]$vd }
  $r.Ok = $true
  return $r
}

Titolo '0 - MACCHINA E TERMINALE'
if($env:COMPUTERNAME -ne 'DESKTOP-H4D7CAJ'){
  throw ('PASSATA_R276B gira SOLO sul PC di backtest DESKTOP-H4D7CAJ. Qui la macchina si chiama: ' + $env:COMPUTERNAME + '. Sul VPS VMI3047753 non si lancia: la challenge FTMO 541452707 sta operando.')
}
Dico ('pc   : ' + $env:COMPUTERNAME) 'Green'
Dico ('pin  : ' + $Pin) 'Green'
if((@(Get-Process -Name terminal64, metaeditor64 -ErrorAction SilentlyContinue)).Count -gt 0){
  throw 'MT5 O METAEDITOR risulta APERTO su questo PC. La passata ne apre una copia sua con /config: col terminale gia aperto il tester non parte. GUARDA I GRAFICI (sedie attaccate?), chiudilo A MANO e rilancia.'
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
# (risultati_archivio/DUKA_P0_20261005_171046/REFERTO_DUKA_P0.txt, sez. 5)
# ne ha trovate DUE oltre al BCM: C:\MT5_Backtest e C:\FundedNext_Manuale.
# Sono AMMESSE PER NOME: la guardia qui sopra le ha gia' trovate CHIUSE, e
# la passata non le apre, non ci scrive e non le chiude. Una installazione
# NON in elenco ferma la passata (regola dei terminali multipli).
$Censite = @('C:\MT5_Backtest', 'C:\FundedNext_Manuale')
$diversi = @($origini | Where-Object { $_.Inst -ne $InstAttesa })
$ignote = @($diversi | Where-Object { $Censite -notcontains $_.Inst.TrimEnd('\') })
foreach($dv in @($diversi | Where-Object { $Censite -contains $_.Inst.TrimEnd('\') })){ Dico ('altra installazione di questo PC, censita il 05/10, CHIUSA e NON TOCCATA: ' + $dv.Inst + '  (cartella dati ' + (Split-Path -Leaf $dv.Dir) + ')') 'Yellow' }
if($ignote.Count -gt 0){
  Write-Host '   ATTENZIONE: su questa macchina hanno girato installazioni MT5 NON censite:' -ForegroundColor Red
  foreach($dv in $ignote){ Write-Host ('     ' + $dv.Inst) -ForegroundColor Red }
  throw 'La passata si ferma: oltre al BCM e alle due censite il 05/10 (C:\MT5_Backtest, C:\FundedNext_Manuale) qui ce ne sono ALTRE installazioni MT5 (regola dei terminali multipli).'
}
$cands = @($origini | Where-Object { $_.Inst -eq $InstAttesa })
if($cands.Count -ne 1){
  throw ('cartella dati NON risolta in modo univoco: trovate ' + $cands.Count + ' candidate per ' + $InstAttesa + '. La passata si ferma invece di indovinare.')
}
$DataFolder = $cands[0].Dir
# nessun EA sui grafici salvati: la passata apre il terminale col suo profilo
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
#  1. EA, INCLUDE E FILE PROVA AL PIN, IMPRONTE E COMPILAZIONE VERIFICATA
# ---------------------------------------------------------------------
Titolo '1 - SORGENTI AL PIN E COMPILAZIONE'
$Work = Join-Path $env:USERPROFILE 'abtg_passata'
New-Item -ItemType Directory -Force -Path $Work | Out-Null
$srcEA  = Join-Path $Work ($EXPERT + '.mq5')
$srcInc = Join-Path $Work 'ABTG_PausaGuardian.mqh'
$fileProva = Join-Path $Work $PROVA
Scarica ('mql5/Experts/' + $EXPERT + '.mq5') $srcEA 'ABTG_DEF_NAME'
Scarica 'mql5/Include/ABTG_PausaGuardian.mqh' $srcInc 'ABTG_GuardiaIngresso'
Scarica ('backtest_pipeline/prove/' + $PROVA) $fileProva 'InpSessionHour'
if((Get-FileHash -LiteralPath $srcEA -Algorithm SHA256).Hash -ne $SHA_EA){ throw ($EXPERT + '.mq5 al pin ha un SHA256 DIVERSO da quello del giro R276: non e lo stesso motore di R276b. Non si parte.') }
if((Get-FileHash -LiteralPath $srcInc -Algorithm SHA256).Hash -ne $SHA_INC){ throw 'ABTG_PausaGuardian.mqh al pin ha un SHA256 DIVERSO da quello del giro R276. Non si parte.' }
Dico 'impronte SHA256 di EA e include = quelle del giro R276' 'Green'

Copy-Item -LiteralPath $srcEA  -Destination (Join-Path $MqlExp ($EXPERT + '.mq5')) -Force
Copy-Item -LiteralPath $srcInc -Destination (Join-Path $MqlInc 'ABTG_PausaGuardian.mqh') -Force

$ex5 = Join-Path $MqlExp ($EXPERT + '.ex5')
Remove-Item -LiteralPath $ex5 -Force -ErrorAction SilentlyContinue
$logC = Join-Path $Work 'compile.log'
Remove-Item -LiteralPath $logC -Force -ErrorAction SilentlyContinue
# il verdetto NON e' il codice d'uscita di MetaEditor (a volte si stacca):
# e' l'esistenza del .ex5 appena prodotto. Si aspetta quello.
$pMe = Start-Process -FilePath $MetaEditor -ArgumentList @(('/compile:' + (Join-Path $MqlExp ($EXPERT + '.mq5'))), ('/log:' + $logC)) -PassThru
$attC = 0
while(-not (Test-Path -LiteralPath $ex5) -and $attC -lt 60){ Start-Sleep -Seconds 2; $attC = $attC + 1 }
if(-not (Test-Path -LiteralPath $ex5)){
  try{ if(-not $pMe.HasExited){ $pMe.Kill() } }catch{ }
  if(Test-Path -LiteralPath $logC){ Get-Content -LiteralPath $logC | Select-Object -Last 15 | ForEach-Object { Write-Host ('     ' + $_) -ForegroundColor DarkYellow } }
  throw ($EXPERT + '.ex5 NON prodotto dopo 120 secondi. Senza il compilato la passata non gira.')
}
Dico ('compilato: ' + $ex5) 'Green'

# ---------------------------------------------------------------------
#  2. LA PASSATA SINGOLA
# ---------------------------------------------------------------------
$dsk  = [Environment]::GetFolderPath('Desktop')
$Cart = Join-Path $dsk 'PASSATA_R276B'
if(Test-Path -LiteralPath $Cart){ Remove-Item -LiteralPath $Cart -Recurse -Force -ErrorAction SilentlyContinue }
New-Item -ItemType Directory -Force -Path $Cart | Out-Null
$LogRoot = Join-Path $env:APPDATA 'MetaQuotes'
$RadiciLog = @($LogRoot, (Join-Path $InstAttesa 'Tester'))
$reData = New-Object Text.RegularExpressions.Regex('(\d{4}\.\d{2}\.\d{2} \d{2}:\d{2}(?::\d{2})?)')
$riepilogo = New-Object System.Collections.ArrayList

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
  # all'inizio del FILE, poi si salta all'offset registrato prima della
  # passata, cosi' si legge SOLO quello che questa passata ha scritto.
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


Titolo ('2 - PASSATA SINGOLA  (pin di ' + $PROVA + ')')

# --- gli input: i 97 incorporati devono coincidere col file prova al pin
$provaVal = @{}
foreach($r in (Get-Content -LiteralPath $fileProva)){
  if($r -match '^(Inp[A-Za-z0-9_]+)=(.*)$'){
    $nome = $Matches[1]; $val = $Matches[2]
    $i = $val.IndexOf('||'); if($i -ge 0){ $val = $val.Substring(0,$i) }
    $provaVal[$nome] = $val
  }
}
$inputs = New-Object System.Collections.ArrayList
$diffProva = @()
foreach($riga in $INPUT_INI){
  $kv = $riga -split '=', 2
  [void]$inputs.Add($riga)
  if(-not $provaVal.ContainsKey($kv[0])){ $diffProva = $diffProva + @($kv[0] + ' assente nel file prova'); continue }
  $pv = $provaVal[$kv[0]]
  $atteso = $kv[1]
  if($atteso -eq 'true'){ $atteso = '1' } elseif($atteso -eq 'false'){ $atteso = '0' }
  if($pv -ne $atteso){ $diffProva = $diffProva + @($kv[0] + ' file=' + $pv + ' incorporato=' + $kv[1]) }
}
Dico ('input scritti: ' + $inputs.Count + '   nel file prova: ' + $provaVal.Count)
if($inputs.Count -ne $provaVal.Count){ throw ('input incorporati ' + $inputs.Count + ' ma il file prova ne ha ' + $provaVal.Count + '. Non si parte.') }
if($diffProva.Count -gt 0){ throw ('input diversi dal file prova: ' + ($diffProva -join ' ; ') + '. Non si parte.') }
foreach($pa in @('InpSessionHour=19','InpSessionMin=0','InpCloseHour=21','InpCloseMin=45',('InpMagic=' + $MAGIC),'InpVerbose=true','InpRangeMinutes=35','InpUsaGuardian=true')){
  if(@($inputs | Where-Object { $_ -eq $pa }).Count -ne 1){ throw ('gli input NON contengono esattamente una volta ' + $pa + ': non e R276b. Non si parte.') }
}

$ini = Join-Path $Work 'passata_R276B.ini'
$testoIni = "[Experts]`r`nAllowLiveTrading=false`r`nAllowDllImport=false`r`n`r`n" +
            "[Tester]`r`nExpert=" + $EXPERT + ".ex5`r`nSymbol=" + $SIMBOLO + "`r`nPeriod=" + $PERIODO + "`r`nModel=4`r`n" +
            "Optimization=0`r`nFromDate=" + $DataDa + "`r`nToDate=" + $DataA + "`r`nForwardMode=0`r`nDeposit=" + $DEPOSITO + "`r`nCurrency=EUR`r`nLeverage=100`r`n" +
            "ExecutionMode=0`r`nVisual=0`r`nReplaceReport=1`r`nShutdownTerminal=1`r`nReport=PASSATA_R276B`r`n`r`n" +
            "[TesterInputs]`r`n" + ($inputs -join "`r`n") + "`r`n"
Set-Content -LiteralPath $ini -Value $testoIni -Encoding ASCII
Copy-Item -LiteralPath $ini -Destination $Cart -Force

$foto = Fotografia
$t0 = Get-Date
Dico ('avvio: ' + $t0.ToString('HH:mm:ss') + '   (tick reali, ' + $DataDa + ' -> ' + $DataA + ', deposito ' + $DEPOSITO + ')') 'Cyan'
$p = Start-Process -FilePath $Terminal -ArgumentList ('/config:"' + $ini + '"') -PassThru
$scade = $t0.AddMinutes($TimeoutMin)
while(-not $p.HasExited -and (Get-Date) -lt $scade){ Start-Sleep -Seconds 10 }
if(-not $p.HasExited){
  Write-Host ('   TIMEOUT: dopo ' + $TimeoutMin + ' minuti il tester e ancora aperto. Lo chiudo con CloseMainWindow (MAI Stop-Process sul terminale).') -ForegroundColor Red
  try{ [void]$p.CloseMainWindow() }catch{ }
  $att = 0; while(-not $p.HasExited -and $att -lt 18){ Start-Sleep -Seconds 5; $att = $att + 1 }
}
Start-Sleep -Seconds 8   # l'agente del tester scarica i log su disco dopo la chiusura
$min = [int]((Get-Date) - $t0).TotalMinutes
Dico ('fine: ' + (Get-Date).ToString('HH:mm:ss') + '   durata ' + $min + ' minuti') 'Cyan'

# --- lettura: solo quello che e' stato scritto DOPO la fotografia. Per ogni
#     file di log si raccolgono le righe dell'EA (marcatore) e le righe
#     "interessanti" di altri messaggi (errori, avvisi, Guardian, news). Lo
#     stesso messaggio puo' stare in due log (agente e giornale): si conta
#     PER FILE e si prende il file con piu righe dell'EA.
$perFile = @{}; $altre = New-Object System.Collections.ArrayList; $illeggibili = New-Object System.Collections.ArrayList; $fileLetti = 0
$reAltre = New-Object Text.RegularExpressions.Regex('(?i)(ERRORE|ATTENZIONE|errore|failed|Guardian|abtg_news|news caricate|OptFrame|tester stopped|cannot|invalid)')
foreach($f in @(ElencoLog)){
  $off = 0; if($foto.ContainsKey($f.FullName)){ $off = [long]$foto[$f.FullName] }
  if($f.Length -le $off){ continue }
  try{ $testo = LeggiCoda $f.FullName $off }catch{ [void]$illeggibili.Add($f.FullName); continue }
  $fileLetti = $fileLetti + 1
  $mine = New-Object System.Collections.ArrayList
  foreach($riga in ($testo -split "`r?`n")){
    $pI = $riga.IndexOf($MARCA)
    if($pI -ge 0){ [void]$mine.Add($riga.TrimEnd()); continue }
    if($riga -match 'NASUSD|ABTG|Nasdaq' -and $reAltre.IsMatch($riga) -and $altre.Count -lt 400){ [void]$altre.Add($riga.TrimEnd()) }
  }
  if($mine.Count -gt 0){ $perFile[$f.FullName] = $mine }
}
$primario = $null; $maxN = 0
foreach($k in @($perFile.Keys)){ if($perFile[$k].Count -gt $maxN){ $maxN = $perFile[$k].Count; $primario = $k } }
$eaRighe = @(); if($null -ne $primario){ $eaRighe = @($perFile[$primario]) }
Dico ('log letti: ' + $fileLetti + '   file con righe dell EA: ' + $perFile.Count + '   righe dell EA nel file primario: ' + $eaRighe.Count) 'Cyan'

$jrn = Join-Path $Cart 'GIORNALE_EA.txt'
(($eaRighe) -join "`r`n") | Set-Content -LiteralPath $jrn -Encoding ASCII
(($altre) -join "`r`n") | Set-Content -LiteralPath (Join-Path $Cart 'GIORNALE_ALTRE_RIGHE.txt') -Encoding ASCII

# --- conteggi per categoria e messaggi distinti (meccanici, nessun giudizio)
$cat = [ordered]@{
  'avvio EA (avviato su ...)'                 = 'avviato su '
  'CONFIG IN USO'                             = 'CONFIG IN USO'
  'nuovo giorno'                              = 'nuovo giorno'
  'ordini piazzati (BUY/SELL STOP|LIMIT, mercato)' = '(BUY STOP @|SELL STOP @|BUY LIMIT|SELL LIMIT|a mercato|entrato a mercato)'
  'rottura non confermata (volumi/ATR)'       = 'non confermata|conferma .* assente|volumi insufficienti'
  'spread troppo alto'                        = 'spread troppo alto'
  'candela/range fuori limiti, whipsaw'       = 'candela .* (min|max)|range .* (min|max)'
  'saltato (stop sotto floor, stop sbagliato, lotto nullo)' = 'saltato|stop dalla parte sbagliata|lotto (calcolato a 0|nullo)|distanza di stop nulla'
  'oggi ho GIA operato'                       = 'GIA. operato'
  'tetto posizioni sul simbolo'               = 'fra posizioni e pendenti'
  'storico deal non pronto'                   = 'storico deal non ancora pronto'
  'ordine fallito'                            = 'fallito'
  'livelli non calcolabili / dati non pronti' = 'non ancora calcolabili|dati non pronti|prezzi non disponibili'
  'nessuna rottura entro la finestra'         = 'nessuna rottura'
}
$cont = [ordered]@{}
foreach($k in $cat.Keys){ $cont[$k] = @($eaRighe | Where-Object { $_ -match $cat[$k] }).Count }
$distinti = @{}
foreach($rg in $eaRighe){
  $pI = $rg.IndexOf($MARCA)
  $m = $rg.Substring($pI + $MARCA.Length).Trim()
  $m = [regex]::Replace($m, '[0-9]+(\.[0-9]+)?', '#')
  if($distinti.ContainsKey($m)){ $distinti[$m] = $distinti[$m] + 1 } else { $distinti[$m] = 1 }
}
$datePrima = ''; $dateUltima = ''
foreach($rg in $eaRighe){ $md = $reData.Match($rg); if($md.Success){ if($datePrima -eq ''){ $datePrima = $md.Groups[1].Value }; $dateUltima = $md.Groups[1].Value } }

# --- M1: metodo valido
$avvioOK = @($eaRighe | Where-Object { $_ -match 'avviato su NASUSD\. Apertura server 19:00, range 35 min, flat 21:45\.' }).Count
$configOK = @($eaRighe | Where-Object { $_ -match 'CONFIG IN USO' }).Count
$m1Motivi = New-Object System.Collections.ArrayList
if($eaRighe.Count -eq 0){ [void]$m1Motivi.Add('NESSUNA riga dell EA nel giornale, nemmeno in passata singola') }
if($avvioOK -lt 1){ [void]$m1Motivi.Add('riga di avvio con 19:00 / 35 min / 21:45 NON trovata') }
if($configOK -lt 1){ [void]$m1Motivi.Add('riga CONFIG IN USO NON trovata') }
$m1OK = ($m1Motivi.Count -eq 0)

# --- report .htm: identita' e totali (nessuna soglia)
$rep = $null
foreach($rad in @($InstAttesa, $DataFolder, $Work, $MqlFiles)){
  if(-not (Test-Path -LiteralPath $rad)){ continue }
  $cr = @(Get-ChildItem -LiteralPath $rad -Filter 'PASSATA_R276B*.htm*' -File -ErrorAction SilentlyContinue | Where-Object { $_.LastWriteTime -ge $t0 } | Sort-Object LastWriteTime -Descending)
  if($cr.Count -gt 0){ $rep = $cr[0]; break }
}
$m2Motivi = New-Object System.Collections.ArrayList
$lr = $null
if($rep){
  Copy-Item -LiteralPath $rep.FullName -Destination $Cart -Force -ErrorAction SilentlyContinue
  Dico ('report della passata raccolto: ' + $rep.FullName) 'Green'
  $lr = LeggiReport $rep.FullName
  if(-not $lr.Ok){ [void]$m2Motivi.Add('report illeggibile: ' + $lr.Motivo) }
  else {
    if($null -ne $lr.Expert -and -not $lr.Expert.StartsWith($EXPERT)){ [void]$m2Motivi.Add('il report e di un altro EA (' + $lr.Expert + ')') }
    if($null -ne $lr.Simbolo -and $lr.Simbolo -ne $SIMBOLO){ [void]$m2Motivi.Add('il report e di un altro simbolo (' + $lr.Simbolo + ')') }
    if($null -ne $lr.Periodo -and -not $lr.Periodo.StartsWith($PERIODO + '(' + $DataDa + '-' + $DataA + ')')){ [void]$m2Motivi.Add('il periodo del report e "' + $lr.Periodo + '" invece di ' + $PERIODO + ' (' + $DataDa + ' - ' + $DataA + ')') }
    if($null -ne $lr.Deposito -and $lr.Deposito -match '^[0-9]+(\.[0-9]+)?$' -and [math]::Abs((Dec $lr.Deposito) - $DEPOSITO) -gt 0.5){ [void]$m2Motivi.Add('il deposito del report e ' + $lr.Deposito + ' invece di ' + $DEPOSITO) }
  }
} else {
  [void]$m2Motivi.Add('report .htm della passata NON trovato')
}
$m2OK = ($m2Motivi.Count -eq 0)

# --- per-trade dell'EA (ExportTrades, scritto in OnTester)
$pt = Join-Path $env:APPDATA ('MetaQuotes\Terminal\Common\Files\abtg_trades_' + $EXPERT + '_' + $SIMBOLO + '_' + $MAGIC + '.csv')
$ptRighe = @(); $ptFresco = $false
if((Test-Path -LiteralPath $pt) -and ((Get-Item -LiteralPath $pt).LastWriteTime -ge $t0)){
  Copy-Item -LiteralPath $pt -Destination $Cart -Force; $ptFresco = $true
  Dico ('per-trade raccolto: ' + (Split-Path -Leaf $pt)) 'Green'
  $ptRighe = @(Get-Content -LiteralPath $pt | Select-Object -Skip 1 | Where-Object { $_ -match '^[0-9]{4}\.' })
} else { Dico ('per-trade dell EA non trovato fresco per il magic ' + $MAGIC + ' (con zero operazioni e normale: ExportTrades scrive comunque l intestazione)') 'DarkYellow' }
$uscPrima = 0; $uscDentro = 0; $uscDopo = 0; $uscDopoElenco = @()
foreach($pr in $ptRighe){
  $c = $pr -split ';'
  $hm = $c[0].Substring(11, 8)
  if($hm -lt '19:05:00'){ $uscPrima = $uscPrima + 1 }
  elseif($hm -ge '19:35:00' -and $hm -le '21:45:00'){ $uscDentro = $uscDentro + 1 }
  elseif($hm -gt '21:45:00'){ $uscDopo = $uscDopo + 1; $uscDopoElenco = $uscDopoElenco + @($c[0]) }
}

[void]$riepilogo.Add('--- R276b in PASSATA SINGOLA --- durata ' + $min + ' min, log letti ' + $fileLetti + ', file con righe EA ' + $perFile.Count)
[void]$riepilogo.Add('   M1 METODO (il giornale ha le righe dell EA con 19:00 / 35 min / 21:45 e CONFIG IN USO): ' + $(if($m1OK){'OK'}else{'ROTTO -- ' + ($m1Motivi -join ' ; ') + '. NESSUNA conclusione sul T5.'}))
[void]$riepilogo.Add('   M2 IDENTITA DEL REPORT (EA, simbolo, periodo, deposito): ' + $(if($m2OK){'OK'}else{'ROTTA -- ' + ($m2Motivi -join ' ; ')}))
if($lr -and $lr.Ok){ [void]$riepilogo.Add('   report MT5: operazioni totali ' + $lr.Trades + ' | affari totali ' + $(if($null -ne $lr.Deals){ $lr.Deals }else{ 'n.d.' }) + ' | profitto netto ' + (F2 $lr.Profitto) + ' | fattore di profitto ' + $(if($lr.PF -ne ''){ $lr.PF }else{ 'n.d.' })) }
[void]$riepilogo.Add('   righe EA: ' + $eaRighe.Count + '   prima data ' + $datePrima + '   ultima data ' + $dateUltima)
foreach($f in @($perFile.Keys)){ [void]$riepilogo.Add('      file ' + $f + ' : ' + $perFile[$f].Count + ' righe EA') }
[void]$riepilogo.Add('   CONTEGGIO PER CATEGORIA (le categorie possono sovrapporsi):')
foreach($k in $cont.Keys){ [void]$riepilogo.Add('      ' + $k + ' : ' + $cont[$k]) }
[void]$riepilogo.Add('   PER-TRADE (' + $(if($ptFresco){'file fresco'}else{'file assente o non fresco'}) + '): posizioni chiuse ' + $ptRighe.Count + ' | uscite prima delle 19:05: ' + $uscPrima + ' | fra le 19:35 e le 21:45: ' + $uscDentro + ' | dopo le 21:45: ' + $uscDopo + $(if($uscDopo -gt 0){' (' + ($uscDopoElenco -join ', ') + ')'}else{''}))
[void]$riepilogo.Add('   MESSAGGI DISTINTI dell EA (numeri sostituiti da #), dal piu frequente:')
$ordDist = @($distinti.Keys | Sort-Object { - $distinti[$_] }, { $_ })
$nMostra = 0
foreach($k in $ordDist){ if($nMostra -ge 60){ break }; [void]$riepilogo.Add('      ' + ([string]$distinti[$k]).PadLeft(5) + ' x  ' + $k); $nMostra = $nMostra + 1 }
if($ordDist.Count -gt 60){ [void]$riepilogo.Add('      ... altri ' + ($ordDist.Count - 60) + ' messaggi distinti in GIORNALE_EA.txt') }
if($illeggibili.Count -gt 0){ [void]$riepilogo.Add('   ATTENZIONE: ' + $illeggibili.Count + ' file .log cresciuti ma NON leggibili (bloccati): ' + ($illeggibili -join ' | ')) }
[void]$riepilogo.Add('   Questo script NON giudica: A/B/C/D/E/F del file delle attese si assegnano leggendo GIORNALE_EA.txt con Claude.')
for($k = 0; $k -lt $riepilogo.Count; $k++){ Write-Host ('   ' + $riepilogo[$k]) }

# ---------------------------------------------------------------------
#  3. RACCOLTA
# ---------------------------------------------------------------------
Titolo '3 - RACCOLTA'
$testa = @(
  'R276b IN PASSATA SINGOLA -- perche zero operazioni con armo 19:00 (NASUSD M5, ABTG_Nasdaq_Apertura_US)',
  ('data: ' + (Get-Date).ToString('yyyy-MM-dd HH:mm:ss') + '   pc: ' + $env:COMPUTERNAME + '   pin: ' + $Pin),
  ('backtest a tick reali, ' + $DataDa + ' -> ' + $DataA + ', deposito ' + $DEPOSITO + ', AllowLiveTrading=false: nessun ordine, nessun conto toccato'),
  ''
)
(($testa + $riepilogo + @('',
  'COME SI LEGGE: prima M1 (metodo) e M2 (identita). Se uno e ROTTO nessuna conclusione sul T5.',
  'Se OK: il file delle attese (report/R276B_PASSATA_SINGOLA_ATTESE_2026-10-21.md) assegna A-F in base a GIORNALE_EA.txt e ai messaggi distinti.',
  'Questo script conta e salva: NON giudica, NON promuove.')) -join "`r`n") | Set-Content -LiteralPath (Join-Path $Cart 'RIEPILOGO_R276B.txt') -Encoding ASCII
$zip = Join-Path $dsk 'PASSATA_R276B.zip'
if(Test-Path -LiteralPath $zip){ Remove-Item -LiteralPath $zip -Force -ErrorAction SilentlyContinue }
Compress-Archive -Path (Join-Path $Cart '*') -DestinationPath $zip -Force
Write-Host ''
Write-Host ('ZIP PRONTO DA MANDARE: ' + $zip) -ForegroundColor Green
Write-Host 'FILE ATTESI NELLO ZIP: RIEPILOGO_R276B.txt + GIORNALE_EA.txt + GIORNALE_ALTRE_RIGHE.txt + passata_R276B.ini (+ il per-trade e il report .htm, se trovati)' -ForegroundColor Gray
if($m1OK -and $m2OK){ Write-Host 'ESITO: METODO VALIDO (rc 0): il giornale ha le righe dell EA. Manda lo zip.' -ForegroundColor Green; exit 0 }
Write-Host 'ESITO: NON MISURATO (rc 3): metodo o identita del report non verificati. Manda comunque lo zip.' -ForegroundColor Red
exit 3
