# =====================================================================
#  MARCATORE_PASSATA_STOP_SUPREV_NAS_v1
#  PASSATA_STOP_SUPREV_NAS.ps1 -- LA DISTANZA INGRESSO->SL DELLA SEDIA 970913, MISURATA
#
#  CHE COSA MISURA, e una cosa sola:
#    la distanza fra il prezzo d'ingresso e lo stop loss di OGNI ingresso a
#    mercato di ABTG_SupertrendReversal su NASUSD H1, con la geometria della
#    sedia SupRev NAS 970913 (EA ABTG_SupRev_NAS_H1_Ottimizzato) a buffer
#    2253 (cella in comune di r127a e r163a), DUE LATI INSIEME come gira la
#    sedia. UNA passata singola a tick reali, 2024.09.26 -> 2026.06.30,
#    deposito 100000. Prova: backtest_pipeline/prove/R290a_stop_SUPREV_NASUSD_
#    LS_ancora970913.txt. Piano: report/PIANO_MISURE_CANDIDATI_2026-10-06.md
#    sez. 4.1 e 7.1. Le soglie e le attese sono QUELLE del piano, scritte
#    PRIMA dei numeri: questo script non le sceglie.
#
#  DERIVATO DA PASSATA_STOP_SUPREV.ps1 (U30USD, v2, PASS 24/09). Le
#  DEVIAZIONI, tutte dichiarate (elenco completo, nessun'altra):
#   1. UNA passata L+S invece di due passate a un lato. Il controllo
#      "ingressi del lato opposto = CONFIGURAZIONE ROTTA" (v2) e' TOLTO: con
#      due lati insieme ROMPEREBBE OGNI CORSA. Al suo posto: il TAGLIO PER
#      LATO (n e distanze di LONG e SHORT riportati separati, regola dei due
#      lati del 25/08). Il controllo "SL dal lato sbagliato del prezzo" resta,
#      per lato di ogni ingresso.
#   2. $ANCORA estesa a TUTTA la geometria della sedia (non solo lo stop) e
#      con InpVerbose=true (senza, Log() del sorgente NON stampa le righe
#      "mercato": la passata uscirebbe vuota), InpLogImbuto=true,
#      InpUsaGuardian=true (la sedia lo ha), InpUseTimeWindow ridotto a 0.
#   3. G0 BLOCCANTE (nuovo): il report .htm della passata e' LETTO e il
#      totale delle operazioni e il profitto netto devono stare nella banda
#      di r163a cella 2253 (172 +/- 3 operazioni; 4699 +/- 4% di profitto).
#      Report assente, illeggibile o fuori banda = NON MISURATO e nessun
#      numero di stop si usa; il codice d'uscita e' 3. (Nella v2 il .htm
#      era "seconda misura, non blocca".)
#   4. IL VERDETTO DI COSTO C3 e' calcolato qui (nuovo): mediana di
#      stop_i / spread_h(i) con lo spread = mediana dell'ORA SERVER
#      dell'ingresso da spread_orario_NASUSD.csv scaricato al pin; soglie del
#      piano (PASSA >= 44, FRAGILE 36-44, NON PASSA < 36); a buffer 2253
#      (misura) e a 3003 / 3378 / 4503 (DERIVATO: stop + (b-2253)/100).
#      Lo script NON promuove niente: SOPRA/SOTTO e la scelta del buffer al
#      CENTRO dell'altopiano restano al cancello e a Claudio.
#   5. Guardie prese dalla riga figlia DUKA (gia' collaudata): -Pin di 40
#      esadecimali, MetaEditor chiuso oltre al terminale, NESSUN EA sui
#      grafici salvati del terminale BCM (14/08/2026: da questa macchina
#      sono partiti ordini veri). Piu' il controllo del CSV dello spread
#      PRIMA di lanciare il tester (24 ore + riga TUTTO, somma dei tick).
#   6. Codice d'uscita: 0 solo se la misura e' AFFIDABILE (incrocio IMBUTO,
#      configurazione e G0 verdi), 3 se NON MISURATO (lo zip esce lo stesso),
#      1 per ogni guardia o errore prima del tester.
#   7. Zip e cartella con un nome DIVERSO (PASSATA_STOP_SUPREV_NAS) per non
#      sovrascrivere i file della passata U30USD.
#   8. Chiamata di MetaEditor: ogni argomento fra parentesi. In PowerShell la
#      virgola lega PIU' del + : @('/compile:' + X, '/log:' + Y) e' UN solo
#      elemento ("/compile:X /log:Y"), non due (misurato in pwsh 7 il 06/10).
#      La v2 U30USD ha quella forma e funziona solo perche' i percorsi non
#      hanno spazi; qui la forma e' quella di PASSATA_TRAILFIX.ps1.
#   9. G0 legge dal report anche l'IDENTITA' (EA, simbolo, periodo: devono essere
#      quelli della passata, altrimenti NON RAGGIUNTO) e rilegge dal report
#      i parametri che il tester ha DAVVERO usato, confrontati con l'ancora
#      (informativo: stampa quanti coincidono, non blocca). Il numero di
#      operazioni di G0 e' "Numero di Operazioni di Trading Totali" / "Total
#      Trades" (la colonna Trades del CSV di ottimizzazione di r163a: 76 + 96),
#      NON "Affari Totali" / "Total Deals" (stampato accanto, non confrontato).
#  10. origin.txt letto con Leggi-Condiviso (BOM UTF-16 gestito a mano, file
#      condiviso) invece di Get-Content -Raw; nomi di variabile senza
#      omonimi a meno delle maiuscole ($DataDa/$DataA al posto di $DA/$A,
#      $dv al posto di $a nel foreach: classe 757).
#  INVARIATI: guardia macchina DESKTOP-H4D7CAJ, MT5 chiuso, un solo MT5 su
#  questo PC, cartella dati risolta per origin.txt, sorgenti scaricati al
#  pin con firma, compilazione verificata dal .ex5, AllowLiveTrading=false,
#  fotografia dei log prima del lancio e lettura della sola coda,
#  controllo incrociato IMBUTO, controllo della configurazione dall'avvio
#  dell'EA, timeout 60 min con CloseMainWindow (MAI Stop-Process sul
#  terminale), raccolta in zip sul Desktop.
#
#  E' UN BACKTEST, NON UN ORDINE. [Experts] AllowLiveTrading=false nella
#  .ini: il terminale del PC di backtest e' loggato sul DEMO 50503392, e il
#  14/08/2026 da questa macchina sono partiti ordini veri.
#
#  NON TOCCA, per nome: il VPS VMI3047753 e TUTTE le sue cartelle dati (FTMO
#  541452707 in C:\FTMO, REALE 10105439 in C:\BCM_Reale, 100k 50504263,
#  piccolo 50503392, manuale 50503635 in C:\MT5_MANUALE, banco 50504400 in
#  C:\MT5_Backtest, Pepperstone, Tickmill). Scrive SOLO: la cartella
#  %USERPROFILE%\abtg_passata, MQL5\Experts e MQL5\Include del terminale
#  BCM Markets MT5 Terminal di questa macchina, il Desktop. Non legge ne'
#  scrive conti, ordini, posizioni, preset di nessuna sedia.
#
#  NIENTE EMOJI QUI DENTRO (regola del 17/08): Windows PowerShell 5.1
#  legge i .ps1 come ANSI e un'emoji dentro una stringa rompe il parser.
# =====================================================================
[CmdletBinding()]
param(
  [Parameter(Mandatory=$true)][string]$Pin,
  [int]$TimeoutMin = 60
)

$ErrorActionPreference = 'Stop'
$IC = [Globalization.CultureInfo]::InvariantCulture
[Threading.Thread]::CurrentThread.CurrentCulture   = $IC
[Threading.Thread]::CurrentThread.CurrentUICulture = $IC

$EXPERT  = 'ABTG_SupertrendReversal'
$SIMBOLO = 'NASUSD'
$PERIODO = 'H1'
$DataDa  = '2024.09.26'
$DataA   = '2026.06.30'
$PROVA   = 'R290a_stop_SUPREV_NASUSD_LS_ancora970913.txt'
$SPREADCSV = 'backtest_pipeline/risultati_archivio/spread_flotta/spread_orario_NASUSD.csv'
if($Pin -notmatch '^[0-9a-fA-F]{40}$'){ throw '-Pin obbligatorio e di 40 caratteri esadecimali: senza, girerebbe la punta del branch spacciandola per un commit congelato.' }
$Pin = $Pin.ToLower()
$RAW     = 'https://raw.githubusercontent.com/claudiospadaro12/GITHUB/' + $Pin + '/'
# la geometria che la passata DICHIARA di misurare (file prova, cella r163a
# a buffer 2253): l'ini la deve contenere PRIMA di partire, una volta
# sola ciascuna, e l'EA la deve ripetere nel log d'avvio
$ANCORA  = @('InpTF=16385','InpStMult=3.0','InpStAtrPeriod=10','InpNearAtr=1.0','InpTP_RR=3.0','InpSLLookback=5','InpSLBufferPips=2253',
             'InpRequireConfirmBody=true','InpUseConfluence=true','InpEma1=14','InpEma2=89','InpEma3=100','InpEma4=200','InpConflAtr=1.5',
             'InpTP1_R=1.0','InpTP1Pct=50.0','InpBreakeven=true','InpTrailOnST=true','InpExitOnFlip=true',
             'InpFirstFraction=0.3333','InpUsePending=true','InpPendingPips=20.0','InpPendingExpiryBars=3',
             'InpRiskPercent=1.0','InpMaxTradesPerDay=0','InpStartHour=0','InpEndHour=24','InpUseNewsFilter=false',
             'InpAllowLong=true','InpAllowShort=true','InpUsaGuardian=true','InpVerbose=true','InpLogImbuto=true')
$AVVIO_ATTESO = 'avviato su ' + $SIMBOLO + ' PERIOD_' + $PERIODO + '. Supertrend(10,3.0).'
# G0 (piano 4.1): r163a cella 2253, IS 76 + OOS 96 operazioni, profitto 1964.39 + 2734.64
$G0_N      = 172
$G0_N_TOL  = 3
$G0_PROF   = [decimal]4699
$G0_PCT    = [decimal]4
# C3 (piano 4.1, soglie congelate prima dei numeri)
$C3_PASSA   = [decimal]44
$C3_FRAGILE = [decimal]36
$BUF_MISURA = 2253
$BUF_DERIV  = @(3003, 3378, 4503)
$PAVIMENTO  = [decimal]34.6
$ST_EQUI    = [decimal]2.40
$ST_P95     = [decimal]2.70

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
function BandaC3([decimal]$r){
  if($r -ge $C3_PASSA){ return 'PASSA' }
  if($r -ge $C3_FRAGILE){ return 'FRAGILE' }
  return 'NON PASSA'
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
  $r = @{ Ok = $false; Trades = $null; Deals = $null; Profitto = $null; PF = ''; Motivo = ''; Expert = $null; Simbolo = $null; Periodo = $null; Inputs = @{} }
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

# ---------------------------------------------------------------------
#  0. LA MACCHINA E IL TERMINALE. Fail-closed, identico alla sonda del box
#     (SONDA_BOX_D30EUR.ps1) e alla passata U30USD.
# ---------------------------------------------------------------------
Titolo '0 - MACCHINA E TERMINALE'
if($env:COMPUTERNAME -ne 'DESKTOP-H4D7CAJ'){
  throw ('PASSATA_STOP_SUPREV_NAS gira SOLO sul PC di backtest DESKTOP-H4D7CAJ. Qui la macchina si chiama: ' + $env:COMPUTERNAME + '. Sul VPS VMI3047753 non si lancia: la challenge FTMO 541452707 sta operando.')
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
$diversi = @($origini | Where-Object { $_.Inst -ne $InstAttesa })
if($diversi.Count -gt 0){
  Write-Host '   ATTENZIONE: su questa macchina hanno girato ALTRE installazioni MT5:' -ForegroundColor Red
  foreach($dv in $diversi){ Write-Host ('     ' + $dv.Inst) -ForegroundColor Red }
  throw 'La passata si ferma: la riga dichiara che il PC di backtest ha UN SOLO MT5, e qui ce ne sono altri (regola dei terminali multipli).'
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
#  1. EA, INCLUDE, FILE PROVA E SPREAD AL PIN, E COMPILAZIONE VERIFICATA
# ---------------------------------------------------------------------
Titolo '1 - SORGENTI AL PIN E COMPILAZIONE'
$Work = Join-Path $env:USERPROFILE 'abtg_passata'
New-Item -ItemType Directory -Force -Path $Work | Out-Null
$srcEA  = Join-Path $Work ($EXPERT + '.mq5')
$srcInc = Join-Path $Work 'ABTG_PausaGuardian.mqh'
$fileProva = Join-Path $Work $PROVA
$fileSpread = Join-Path $Work 'spread_orario_NASUSD.csv'
Scarica ('mql5/Experts/' + $EXPERT + '.mq5') $srcEA 'STREV-IMBUTO'
Scarica 'mql5/Include/ABTG_PausaGuardian.mqh' $srcInc 'ABTG_GuardiaIngresso'
Scarica ('backtest_pipeline/prove/' + $PROVA) $fileProva 'InpUseTimeWindow'
Scarica $SPREADCSV $fileSpread 'ora_server,tick_totali'

# --- lo spread orario: letto e controllato PRIMA del tester (un CSV rotto
#     scoperto dopo 15 minuti e' tempo perso)
$SpreadOra = @{}
$tuttoTick = $null; $sommaTick = [decimal]0
foreach($rs in (Get-Content -LiteralPath $fileSpread)){
  $c = $rs -split ','
  if($c.Count -lt 9 -or $c[0] -eq 'ora_server'){ continue }
  if($c[0] -eq 'TUTTO'){ $tuttoTick = Dec $c[1]; continue }
  if($c[0] -notmatch '^[0-9]+$'){ throw ('spread_orario_NASUSD.csv: riga con ora_server non numerica: ' + $rs) }
  $hh = [int]$c[0]
  if($hh -lt 0 -or $hh -gt 23 -or $SpreadOra.ContainsKey($hh)){ throw ('spread_orario_NASUSD.csv: ora ' + $hh + ' fuori da 0-23 o ripetuta.') }
  $SpreadOra[$hh] = Dec $c[5]
  $sommaTick = $sommaTick + (Dec $c[1])
}
if($SpreadOra.Count -ne 24){ throw ('spread_orario_NASUSD.csv: ore lette ' + $SpreadOra.Count + ' invece di 24. Non si parte.') }
if($null -eq $tuttoTick -or $tuttoTick -ne $sommaTick){ throw ('spread_orario_NASUSD.csv: la riga TUTTO (' + $tuttoTick + ') non e la somma dei tick delle 24 ore (' + $sommaTick + '). Non si parte.') }
foreach($hh in 0..23){ if($SpreadOra[$hh] -le 0){ throw ('spread_orario_NASUSD.csv: spread mediano <= 0 all ora ' + $hh) } }
Dico ('spread orario: 24 ore, TUTTO = somma dei tick (' + $tuttoTick + ')') 'Green'

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
#  2. LA PASSATA SINGOLA, DUE LATI INSIEME
# ---------------------------------------------------------------------
$dsk  = [Environment]::GetFolderPath('Desktop')
$Cart = Join-Path $dsk 'PASSATA_STOP_SUPREV_NAS'
if(Test-Path -LiteralPath $Cart){ Remove-Item -LiteralPath $Cart -Recurse -Force -ErrorAction SilentlyContinue }
New-Item -ItemType Directory -Force -Path $Cart | Out-Null
Copy-Item -LiteralPath $fileSpread -Destination $Cart -Force
$LogRoot = Join-Path $env:APPDATA 'MetaQuotes'
# le radici dei log: %APPDATA%\MetaQuotes contiene la cartella dati e gli
# agenti locali (Tester\<id>\Agent-127.0.0.1-30xx\logs: MISURATO su questa
# macchina, zip di R242); <installazione>\Tester e' la terza radice nota in
# casa (RIGA_R99_ORO_RISCHIO.ps1 r.966-971, checklist 34-ter e 518).
$RadiciLog = @($LogRoot, (Join-Path $InstAttesa 'Tester'))
$reMerGrezza = New-Object Text.RegularExpressions.Regex('\[STReversal\]\s+(LONG|SHORT)\s+mercato\s')
$reAvvio = New-Object Text.RegularExpressions.Regex('\[STReversal\]\s+(avviato su \S+ \S+\. Supertrend\([0-9]+,[0-9.]+\)\.)')
$reEntr = New-Object Text.RegularExpressions.Regex('\[STReversal\]\s+(LONG|SHORT)\s+mercato\s+([0-9]+(?:\.[0-9]+)?)\s+lot\s+@\s+([0-9]+(?:\.[0-9]+)?)\s+SL\s+([0-9]+(?:\.[0-9]+)?)\s+TP\s+([0-9]+(?:\.[0-9]+)?)')
$reImb  = New-Object Text.RegularExpressions.Regex('\[STREV-IMBUTO\](.*)\|\s*ENTRATE\s+([0-9]+)\s*\|\s*quadratura\s+(\S+)')
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

Titolo ('2 - PASSATA SINGOLA, DUE LATI INSIEME  (pin di ' + $PROVA + ')')

# --- gli input: TUTTE le righe Inp del file prova, ridotte al PRIMO valore.
#     Con Optimization=0 MT5 usa comunque il primo valore; qui lo si scrive
#     esplicito, cosi' non c'e' niente da interpretare. L'asse
#     InpUseTimeWindow=0||0||1||1||Y diventa InpUseTimeWindow=0: finestra
#     SPENTA (la sedia com'e'); la cella 1 e' il meccanismo di R238 e non e'
#     questa domanda.
$inputs = New-Object System.Collections.ArrayList
foreach($r in (Get-Content -LiteralPath $fileProva)){
  if($r -match '^(Inp[A-Za-z0-9_]+)=(.*)$'){
    $nome = $Matches[1]; $val = $Matches[2]
    $i = $val.IndexOf('||'); if($i -ge 0){ $val = $val.Substring(0,$i) }
    [void]$inputs.Add($nome + '=' + $val)
  }
}
$asse = @($inputs | Where-Object { $_ -like 'InpUseTimeWindow=*' })
Dico ('input scritti: ' + $inputs.Count + '   ' + ($asse -join ' '))
if($inputs.Count -lt 40){ throw ('solo ' + $inputs.Count + ' righe Inp lette da ' + $PROVA + ': file prova tronco. Non si parte.') }
if($asse.Count -ne 1 -or $asse[0] -ne 'InpUseTimeWindow=0'){ throw ('la finestra oraria NON risulta spenta (' + ($asse -join ',') + '). Non si parte.') }
foreach($pa in $ANCORA){
  if(@($inputs | Where-Object { $_ -eq $pa }).Count -ne 1){ throw ('il file prova ' + $PROVA + ' NON contiene esattamente una volta ' + $pa + ': non e la geometria che la passata dichiara di misurare. Non si parte.') }
}
$doppi = @($inputs | ForEach-Object { ($_ -split '=')[0] } | Group-Object | Where-Object { $_.Count -gt 1 })
if($doppi.Count -gt 0){ throw ('parametri DOPPI nel file prova: ' + (($doppi | ForEach-Object { $_.Name }) -join ', ') + '. Non si parte.') }

$ini = Join-Path $Work 'passata_NAS.ini'
$testoIni = "[Experts]`r`nAllowLiveTrading=false`r`nAllowDllImport=false`r`n`r`n" +
            "[Tester]`r`nExpert=" + $EXPERT + ".ex5`r`nSymbol=" + $SIMBOLO + "`r`nPeriod=" + $PERIODO + "`r`nModel=4`r`n" +
            "Optimization=0`r`nFromDate=" + $DataDa + "`r`nToDate=" + $DataA + "`r`nForwardMode=0`r`nDeposit=100000`r`nCurrency=EUR`r`nLeverage=100`r`n" +
            "ExecutionMode=0`r`nReplaceReport=1`r`nShutdownTerminal=1`r`nReport=PASSATA_STOP_NAS`r`n`r`n" +
            "[TesterInputs]`r`n" + ($inputs -join "`r`n") + "`r`n"
Set-Content -LiteralPath $ini -Value $testoIni -Encoding ASCII
Copy-Item -LiteralPath $ini -Destination $Cart -Force

$foto = Fotografia
$t0 = Get-Date
Dico ('avvio: ' + $t0.ToString('HH:mm:ss') + '   (tick reali, ' + $DataDa + ' -> ' + $DataA + ', deposito 100000)') 'Cyan'
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

# --- lettura: solo quello che e' stato scritto DOPO la fotografia
$visti = @{}; $entr = New-Object System.Collections.ArrayList
$imbVisti = @{}; $sommaEntrate = 0; $quadOK = 0; $quadKO = 0; $fileLetti = 0
$imbFuori = 0; $avvii = @{}; $imbGrezze = @{}; $merGrezze = @{}; $illeggibili = New-Object System.Collections.ArrayList
foreach($f in @(ElencoLog)){
  $off = 0; if($foto.ContainsKey($f.FullName)){ $off = [long]$foto[$f.FullName] }
  if($f.Length -le $off){ continue }
  # un file bloccato (per esempio un log del browser integrato ancora
  # aperto) NON deve far morire la passata senza zip: si conta e si dice.
  try{ $testo = LeggiCoda $f.FullName $off }catch{ [void]$illeggibili.Add($f.FullName); continue }
  $fileLetti = $fileLetti + 1
  foreach($riga in ($testo -split "`r?`n")){
    # conteggi GREZZI (testo della riga dopo il marcatore, senza prefisso
    # di log): se superano quelli letti dalle regex, il parser e' cieco su
    # una forma della riga, e lo si vede nel riepilogo.
    $pI = $riga.IndexOf('[STREV-IMBUTO]'); if($pI -ge 0){ $imbGrezze[$riga.Substring($pI)] = $true }
    $mg = $reMerGrezza.Match($riga);       if($mg.Success){ $merGrezze[$riga.Substring($mg.Index).TrimEnd()] = $true }
    $ma = $reAvvio.Match($riga)
    if($ma.Success){ $avvii[$ma.Groups[1].Value] = $true; continue }
    $m = $reEntr.Match($riga)
    if($m.Success){
      $md = $reData.Match($riga); $quando = ''; if($md.Success){ $quando = $md.Groups[1].Value }
      # la chiave e' il TESTO della riga (lato, lotti, ingresso, SL, TP), NON
      # data+testo: la stessa riga puo' comparire nel log dell'agente e nel
      # giornale del tester, e in uno dei due senza data simulata. Con la
      # data nella chiave sarebbe contata DUE volte. Due ingressi veri con
      # lotti, ingresso, SL e TP identici al centesimo non esistono.
      $chiave = $m.Value
      if($visti.ContainsKey($chiave)){
        if($visti[$chiave].Quando -eq '' -and $quando -ne ''){ $visti[$chiave].Quando = $quando }
        continue
      }
      $ent = Dec $m.Groups[3].Value; $sl = Dec $m.Groups[4].Value
      $rec = [pscustomobject]@{ Quando=$quando; Lato=$m.Groups[1].Value; Lotti=$m.Groups[2].Value; Ingresso=$m.Groups[3].Value; SL=$m.Groups[4].Value; TP=$m.Groups[5].Value; Dist=[math]::Abs($ent - $sl) }
      $visti[$chiave] = $rec
      [void]$entr.Add($rec)
      continue
    }
    $mi = $reImb.Match($riga)
    if($mi.Success){
      $ck = $mi.Groups[1].Value.Trim()
      if($imbVisti.ContainsKey($ck)){ continue }
      $imbVisti[$ck] = $true
      if(-not $ck.StartsWith($SIMBOLO + ' PERIOD_' + $PERIODO + ' ')){ $imbFuori = $imbFuori + 1 }
      $sommaEntrate = $sommaEntrate + [int]$mi.Groups[2].Value
      if($mi.Groups[3].Value -eq 'OK'){ $quadOK = $quadOK + 1 } else { $quadKO = $quadKO + 1 }
    }
  }
}

$csvPass = Join-Path $Cart 'STOP_NAS.csv'
$righe = New-Object System.Collections.ArrayList
[void]$righe.Add('quando;lato;lotti;ingresso;sl;tp;distanza_idx')
foreach($e in $entr){ [void]$righe.Add($e.Quando + ';' + $e.Lato + ';' + $e.Lotti + ';' + $e.Ingresso + ';' + $e.SL + ';' + $e.TP + ';' + (F2 $e.Dist)) }
($righe -join "`r`n") | Set-Content -LiteralPath $csvPass -Encoding ASCII

$n = $entr.Count
$senzaData = @($entr | Where-Object { $_.Quando -eq '' }).Count
$nLong  = @($entr | Where-Object { $_.Lato -eq 'LONG' }).Count
$nShort = @($entr | Where-Object { $_.Lato -eq 'SHORT' }).Count
[void]$riepilogo.Add('--- passata singola L+S (' + $PROVA + ') --- durata ' + $min + ' min, log letti ' + $fileLetti)
[void]$riepilogo.Add('   ingressi letti (righe "mercato")       : ' + $n + '   (LONG ' + $nLong + ' / SHORT ' + $nShort + ')')
[void]$riepilogo.Add('   somma ENTRATE delle righe IMBUTO        : ' + $sommaEntrate + '   (giornate IMBUTO: ' + $imbVisti.Count + ', quadratura OK ' + $quadOK + ' / ROTTA ' + $quadKO + ')')
$croceOK = ($n -gt 0 -and $n -eq $sommaEntrate)
if($croceOK){ [void]$riepilogo.Add('   CONTROLLO INCROCIATO: OK -- i due conteggi coincidono.') }
else { [void]$riepilogo.Add('   CONTROLLO INCROCIATO: ROTTO -- i due conteggi NON coincidono. I NUMERI QUI SOTTO NON SI USANO: lo script ha letto male i log.') }
# --- CONTROLLO DELLA CONFIGURAZIONE: l'EA ha girato con l'ini che gli
#     abbiamo dato? (il controllo incrociato qui sopra NON lo sa dire).
#     NIENTE controllo "ingressi del lato opposto": con due lati insieme
#     ROMPEREBBE OGNI CORSA (deviazione 1). Resta lo SL dal lato giusto.
$slStorto = @($entr | Where-Object { ($_.Lato -eq 'SHORT' -and (Dec $_.SL) -le (Dec $_.Ingresso)) -or ($_.Lato -eq 'LONG' -and (Dec $_.SL) -ge (Dec $_.Ingresso)) }).Count
$avviiVisti = @($avvii.Keys)
$cfgMotivi = New-Object System.Collections.ArrayList
if($avviiVisti.Count -eq 0){ [void]$cfgMotivi.Add('riga di avvio dell EA NON trovata nei log') }
foreach($av in $avviiVisti){ if($av -ne $AVVIO_ATTESO){ [void]$cfgMotivi.Add('avvio letto "' + $av + '" invece di "' + $AVVIO_ATTESO + '"') } }
if($imbFuori -gt 0){ [void]$cfgMotivi.Add(([string]$imbFuori) + ' righe IMBUTO non intestate ' + $SIMBOLO + ' PERIOD_' + $PERIODO) }
if($slStorto -gt 0){ [void]$cfgMotivi.Add(([string]$slStorto) + ' ingressi con lo SL dal lato sbagliato del prezzo') }
$cfgOK = ($cfgMotivi.Count -eq 0)
if($cfgOK){ [void]$riepilogo.Add('   CONTROLLO CONFIGURAZIONE: OK -- l EA ha stampato "' + $AVVIO_ATTESO + '", righe IMBUTO e SL coerenti.') }
else { [void]$riepilogo.Add('   CONTROLLO CONFIGURAZIONE: ROTTO -- ' + ($cfgMotivi -join ' ; ') + '. I NUMERI QUI SOTTO NON SI USANO: la passata non ha misurato la geometria dichiarata.') }
[void]$riepilogo.Add('   righe grezze nei log: "mercato" ' + $merGrezze.Count + ' (lette ' + $n + '), IMBUTO ' + $imbGrezze.Count + ' (lette ' + $imbVisti.Count + ')   <- se diverse, il parser e cieco su una forma della riga')
if($illeggibili.Count -gt 0){ [void]$riepilogo.Add('   ATTENZIONE: ' + $illeggibili.Count + ' file .log cresciuti ma NON leggibili (bloccati): ' + ($illeggibili -join ' | ')) }
if($senzaData -gt 0){ [void]$riepilogo.Add('   ATTENZIONE: ' + $senzaData + ' ingressi senza data simulata: il conto per ora dello spread NON si puo fare, C3 NON MISURATO.') }
if($nLong -eq 0 -or $nShort -eq 0){ [void]$riepilogo.Add('   ATTENZIONE: un lato ha ZERO ingressi (LONG ' + $nLong + ' / SHORT ' + $nShort + '): la sedia gira a due lati, controllare che il lato mancante non sia un ini ignorato.') }

# --- G0: il REPORT .htm della passata (Report=PASSATA_STOP_NAS). BLOCCANTE.
#     Si cerca dove MT5 lo puo' scrivere (RIGA_R99_ORO_RISCHIO.ps1 r.1166:
#     installazione, cartella dati, lavoro, MQL5\Files).
$rep = $null
foreach($rad in @($InstAttesa, $DataFolder, $Work, $MqlFiles)){
  if(-not (Test-Path -LiteralPath $rad)){ continue }
  $cr = @(Get-ChildItem -LiteralPath $rad -Filter 'PASSATA_STOP_NAS*.htm*' -File -ErrorAction SilentlyContinue | Where-Object { $_.LastWriteTime -ge $t0 } | Sort-Object LastWriteTime -Descending)
  if($cr.Count -gt 0){ $rep = $cr[0]; break }
}
$g0Motivi = New-Object System.Collections.ArrayList
$lr = $null
if($rep){
  Copy-Item -LiteralPath $rep.FullName -Destination $Cart -Force -ErrorAction SilentlyContinue
  Dico ('report della passata raccolto: ' + $rep.FullName) 'Green'
  $lr = LeggiReport $rep.FullName
  if(-not $lr.Ok){ [void]$g0Motivi.Add('report illeggibile: ' + $lr.Motivo) }
  else {
    if($null -ne $lr.Expert -and $lr.Expert -ne $EXPERT){ [void]$g0Motivi.Add('il report e di un altro EA (' + $lr.Expert + ')') }
    if($null -ne $lr.Simbolo -and $lr.Simbolo -ne $SIMBOLO){ [void]$g0Motivi.Add('il report e di un altro simbolo (' + $lr.Simbolo + ')') }
    if($null -ne $lr.Periodo -and -not $lr.Periodo.StartsWith($PERIODO + '(' + $DataDa + '-' + $DataA + ')')){ [void]$g0Motivi.Add('il periodo del report e "' + $lr.Periodo + '" invece di ' + $PERIODO + ' (' + $DataDa + ' - ' + $DataA + ')') }
    if([math]::Abs($lr.Trades - $G0_N) -gt $G0_N_TOL){ [void]$g0Motivi.Add('operazioni totali ' + $lr.Trades + ' fuori da ' + $G0_N + ' +/- ' + $G0_N_TOL) }
    if([math]::Abs($lr.Profitto - $G0_PROF) * 100 -gt $G0_PCT * $G0_PROF){ [void]$g0Motivi.Add('profitto netto ' + (F2 $lr.Profitto) + ' fuori da ' + $G0_PROF + ' +/- ' + $G0_PCT + '%') }
  }
} else {
  [void]$g0Motivi.Add('report .htm della passata NON trovato (G0 non si puo leggere)')
}
$g0OK = ($g0Motivi.Count -eq 0)
if($lr -and $lr.Ok){ [void]$riepilogo.Add('   report MT5: operazioni totali ' + $lr.Trades + ' | affari totali ' + $(if($null -ne $lr.Deals){ $lr.Deals }else{ 'n.d.' }) + ' | profitto netto ' + (F2 $lr.Profitto) + ' | fattore di profitto ' + $(if($lr.PF -ne ''){ $lr.PF }else{ 'n.d.' })) }
if($lr -and $lr.Ok){
  # i parametri che il tester ha DAVVERO usato, riletti dal report: seconda conferma della configurazione (informativa, non blocca)
  $inOk = 0; $inDiv = @(); $inAss = @()
  foreach($pa in $ANCORA){
    $kv = $pa -split '=', 2
    if(-not $lr.Inputs.ContainsKey($kv[0])){ $inAss = $inAss + @($kv[0]); continue }
    if($lr.Inputs[$kv[0]] -ieq $kv[1]){ $inOk = $inOk + 1 } else { $inDiv = $inDiv + @($kv[0] + ' report=' + $lr.Inputs[$kv[0]] + ' ini=' + $kv[1]) }
  }
  [void]$riepilogo.Add('   input riletti dal report: ' + $inOk + ' su ' + $ANCORA.Count + ' coincidono con l ancora; assenti nel report ' + $inAss.Count + '; DIVERSI ' + $inDiv.Count + $(if($inDiv.Count -gt 0){ ' -> ATTENZIONE: ' + ($inDiv -join ' ; ') }else{ '' }))
}
if($g0OK){ [void]$riepilogo.Add('   G0 (riproduzione di r163a cella 2253: ' + $G0_N + ' +/- ' + $G0_N_TOL + ' operazioni, profitto ' + $G0_PROF + ' +/- ' + $G0_PCT + '%): VERDE.') }
else { [void]$riepilogo.Add('   G0 (riproduzione di r163a cella 2253: ' + $G0_N + ' +/- ' + $G0_N_TOL + ' operazioni, profitto ' + $G0_PROF + ' +/- ' + $G0_PCT + '%): NON RAGGIUNTO -- ' + ($g0Motivi -join ' ; ') + '. L EA base NON riproduce l Ottimizzato (o il report manca): NESSUN NUMERO DI STOP SI USA.') }

$affidabile = ($croceOK -and $cfgOK -and $g0OK)
if($affidabile){ [void]$riepilogo.Add('   >>> ESITO PASSATA: AFFIDABILE (lettore, configurazione e G0 verificati).') }
else { [void]$riepilogo.Add('   >>> ESITO PASSATA: NON MISURATO. Le distanze qui sotto sono SOLO diagnostica, nessun rapporto e nessuna banda C3 viene calcolato.') }

# --- distribuzione dello stop, per lato (regola dei due lati)
$gruppi = @(@('TUTTI', @($entr)), @('LONG', @($entr | Where-Object { $_.Lato -eq 'LONG' })), @('SHORT', @($entr | Where-Object { $_.Lato -eq 'SHORT' })))
foreach($g in $gruppi){
  $gn = @($g[1]).Count
  if($gn -le 0){ [void]$riepilogo.Add('   distanza ingresso->SL ' + $g[0] + ': n 0'); continue }
  $ord = @($g[1] | ForEach-Object { [decimal]$_.Dist } | Sort-Object)
  [void]$riepilogo.Add('   distanza ingresso->SL ' + $g[0] + ' (n ' + $gn + '), punti indice: min ' + (F2 $ord[0]) + ' | p5 ' + (F2 (QuantD $ord 0.05)) + ' | p25 ' + (F2 (QuantD $ord 0.25)) + ' | MEDIANA ' + (F2 (QuantD $ord 0.5)) + ' | p75 ' + (F2 (QuantD $ord 0.75)) + ' | p95 ' + (F2 (QuantD $ord 0.95)) + ' | max ' + (F2 $ord[$ord.Count-1]))
}

# --- C3: SOLO se la passata e' AFFIDABILE e ogni ingresso ha la sua ora
$c3Fatto = $false
if($affidabile -and $senzaData -eq 0){
  $c3Fatto = $true
  [void]$riepilogo.Add('')
  [void]$riepilogo.Add('   C3 -- mediana di (stop_i / spread_h(i)); spread = mediana dell ORA SERVER dell ingresso (spread_orario_NASUSD.csv).')
  [void]$riepilogo.Add('         Soglie del piano: PASSA >= 44 | FRAGILE 36-44 | NON PASSA < 36. A 2253 e una MISURA; agli altri buffer e DERIVATO: stop + (b-2253)/100, per ALGEBRA sulle stesse entrate (n e invariante lungo l asse in r163a: non provato che le entrate siano le stesse).')
  $buffers = @($BUF_MISURA) + @($BUF_DERIV)
  foreach($b in $buffers){
    $delta = [decimal]($b - $BUF_MISURA) / 100
    $stopB = New-Object System.Collections.ArrayList
    $rapB = New-Object System.Collections.ArrayList
    $sottoPav = 0
    foreach($e in $entr){
      $hh = [int]$e.Quando.Substring(11, 2)
      $s = [decimal]$e.Dist + $delta
      [void]$stopB.Add($s)
      [void]$rapB.Add($s / $SpreadOra[$hh])
      if($s -lt $PAVIMENTO){ $sottoPav = $sottoPav + 1 }
    }
    $ordS = @($stopB | Sort-Object); $ordR = @($rapB | Sort-Object)
    $medS = QuantD $ordS 0.5; $medR = QuantD $ordR 0.5
    $tipo = 'DERIVATO'; if($b -eq $BUF_MISURA){ $tipo = 'MISURA' }
    $nota = ''; if($b -eq 3378){ $nota = ' (centro dell altopiano di r163a)' }; if($b -eq 4503){ $nota = ' (bordo dell asse)' }
    $pavTxt = 'NO'; if($medS -ge $PAVIMENTO){ $pavTxt = 'SI' }
    [void]$riepilogo.Add('   buffer ' + $b + ' (' + $tipo + ')' + $nota + ': stop mediano ' + (F2 $medS) + ' idx | rapporto mediano ' + (F4 $medR) + ' -> ' + (BandaC3 $medR) + ' | pavimento duro (mediana stop >= 34,6): ' + $pavTxt + ' | ingressi con stop < 34,6: ' + $sottoPav + ' su ' + $n + ' | stress (NON cancello): mediana stop/2,40 = ' + (F2 ($medS / $ST_EQUI)) + ', /2,70 = ' + (F2 ($medS / $ST_P95)))
    foreach($lat in @('LONG','SHORT')){
      $rl = New-Object System.Collections.ArrayList
      foreach($e in $entr){ if($e.Lato -eq $lat){ $hh = [int]$e.Quando.Substring(11, 2); [void]$rl.Add(([decimal]$e.Dist + $delta) / $SpreadOra[$hh]) } }
      if($rl.Count -gt 0){ $mrl = QuantD @($rl | Sort-Object) 0.5; [void]$riepilogo.Add('         lato ' + $lat + ' (n ' + $rl.Count + '): rapporto mediano ' + (F4 $mrl) + ' -> ' + (BandaC3 $mrl)) }
      else { [void]$riepilogo.Add('         lato ' + $lat + ': n 0, NON MISURATO') }
    }
    if($b -eq $BUF_MISURA){
      $ordBase = @($entr | ForEach-Object { [decimal]$_.Dist } | Sort-Object)
      $m0 = QuantD $ordBase 0.5
      $lett = 'DENTRO l attesa 93-188'
      if($m0 -lt 65){ $lett = 'SOTTO 65: l IPOTESI "stop da ATR" e SMENTITA' }
      elseif($m0 -lt 93){ $lett = 'sotto l attesa 93-188 ma >= 65: ipotesi non smentita, fuori attesa' }
      elseif($m0 -gt 188){ $lett = 'SOPRA l attesa 93-188' }
      [void]$riepilogo.Add('         LETTURA CONTRO L ATTESA (scritta prima): stop(2253) mediano ' + (F2 $m0) + ' -> ' + $lett + '; ingressi ' + $n + ' contro attesa 75-172.')
    }
  }
  [void]$riepilogo.Add('   Questo script NON promuove: SOPRA / FRAGILE / SOTTO, la regola del CENTRO dell altopiano (mai il bordo 4503) e la riaccensione di 970913 sono del cancello e di Claudio.')
} elseif($affidabile){
  [void]$riepilogo.Add('   C3 NON MISURATO: ingressi senza data simulata.')
}
for($k = 0; $k -lt $riepilogo.Count; $k++){ Write-Host ('   ' + $riepilogo[$k]) }

# il per-trade dell'EA (ExportTrades, solo tester): controllo in piu'
$mag = (@($inputs | Where-Object { $_ -like 'InpMagic=*' })[0] -split '=')[1]
$pt = Join-Path $env:APPDATA ('MetaQuotes\Terminal\Common\Files\abtg_trades_' + $EXPERT + '_' + $SIMBOLO + '_' + $mag + '.csv')
if((Test-Path -LiteralPath $pt) -and ((Get-Item -LiteralPath $pt).LastWriteTime -ge $t0)){ Copy-Item -LiteralPath $pt -Destination $Cart -Force; Dico ('per-trade raccolto: ' + (Split-Path -Leaf $pt)) 'Green' }
else { Dico ('per-trade dell EA non trovato fresco per il magic ' + $mag + ' (non blocca: e un controllo in piu)') 'DarkYellow' }

# ---------------------------------------------------------------------
#  3. RACCOLTA
# ---------------------------------------------------------------------
Titolo '3 - RACCOLTA'
$testa = @(
  'PASSATA STOP SUPREV NAS -- la distanza ingresso->SL della sedia 970913 (NASUSD H1, due lati insieme, buffer 2253)',
  ('data: ' + (Get-Date).ToString('yyyy-MM-dd HH:mm:ss') + '   pc: ' + $env:COMPUTERNAME + '   pin: ' + $Pin),
  'backtest a tick reali, deposito 100000, AllowLiveTrading=false: nessun ordine, nessun conto toccato',
  ''
)
(($testa + $riepilogo + @('',
  'COME SI LEGGE: prima ESITO PASSATA (AFFIDABILE o NON MISURATO) e G0. Se NON MISURATO nessun numero di stop si usa.',
  'Se AFFIDABILE: la banda C3 a 2253 e la MISURA; 3003 / 3378 / 4503 sono DERIVATI per algebra.',
  'Questo script misura e dice se la misura e affidabile: NON promuove, NON sceglie il buffer.')) -join "`r`n") | Set-Content -LiteralPath (Join-Path $Cart 'RIEPILOGO_PASSATA_NAS.txt') -Encoding ASCII
$zip = Join-Path $dsk 'PASSATA_STOP_SUPREV_NAS.zip'
if(Test-Path -LiteralPath $zip){ Remove-Item -LiteralPath $zip -Force -ErrorAction SilentlyContinue }
Compress-Archive -Path (Join-Path $Cart '*') -DestinationPath $zip -Force
Write-Host ''
Write-Host ('ZIP PRONTO DA MANDARE: ' + $zip) -ForegroundColor Green
Write-Host 'FILE ATTESI NELLO ZIP: RIEPILOGO_PASSATA_NAS.txt + STOP_NAS.csv + passata_NAS.ini + spread_orario_NASUSD.csv (+ il per-trade e il report .htm, se trovati)' -ForegroundColor Gray
if($affidabile -and $c3Fatto){ Write-Host 'ESITO PASSATA: AFFIDABILE e C3 CALCOLATO (rc 0)' -ForegroundColor Green; exit 0 }
Write-Host 'ESITO PASSATA: NON MISURATO (rc 3): nessun numero di stop si usa. Manda comunque lo zip.' -ForegroundColor Red
exit 3
