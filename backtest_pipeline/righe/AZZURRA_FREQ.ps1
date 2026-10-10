# =====================================================================
#  MARCATORE_AZZURRA_FREQ_v1
#  AZZURRA_FREQ.ps1 -- FREQUENZA E SCREENING DELLA BULGE AZZURRA
#                      (ABTG_BulgeAzzurra, 22 cross, H1, Modello 1)
#
#  CHE COSA FA (10/10/2026):
#   0. guardie: SOLO sul PC di backtest DESKTOP-H4D7CAJ, nessun MT5 o
#      MetaEditor aperto, nessuna installazione MT5 fuori censimento,
#      nessun EA attaccato ai grafici salvati del terminale BCM (demo
#      50503392 di QUESTO PC), un solo giro alla volta (mutex);
#   1. scarica AL PIN l'EA, l'include, RIGA_ROUND_VPS.ps1 e i QUATTRO file
#      prova, e ne controlla lo SHA256 (costanti qui sotto); poi COMPILA
#      L'EA (prima compilazione su questo PC): .ex5 vecchio cancellato e
#      dimostrato sparito, si aspetta l'uscita di MetaEditor, log letto in
#      inglese e in italiano (classe 1168); se fallisce ->
#      AZZURRA_FREQ_COMPILAZIONE_FALLITA.zip sul Desktop e NESSUN tester
#      (classe 1167);
#   2. quattro job IN FILA con il driver dei round GIA' IN USO
#      (RIGA_ROUND_VPS.ps1 al pin, SHA 3341756F... = quello di R92BAB, girato
#      il 01/10 su questo PC): AZF_A (base dei controlli, 22 cross, gemelle
#      774511/774561), AZF_B (asse Azure_FirstTouchOnly, magic 774521),
#      AZF_C (ritracciamento spento, gemelle 774531/774581), AZF_D (LA CELLA
#      DEL CAMPO: i 33 simboli su cui gira l'Azzurra 774500, gemelle
#      774541/774591; classe 1222). Modello 1, deposito 10000, finestra e input
#      dai file prova. Dopo OGNI job: SHA256 di EA, include, driver e file
#      prova sui byte che hanno girato (classe 166/595: il driver compila
#      dal RAMO lavoro, non dal pin);
#   3. raccoglie: CSV OptResults (IS e OOS) dei quattro job; da Common\Files il
#      per-trade FRESCO di ogni cella (abtg_trades_*_azzurraOGNI/PRIMO.csv),
#      UNA CARTELLA PER CELLA; i log del tester e un estratto;
#   4. CONTA, a macchina: aperture per giorno feriale (lambda) in IS (dal
#      CSV) e in OOS (dal per-trade) -- la lambda del campo e' quella di D, distribuzione per GIORNO DI CHIUSURA,
#      giorni a zero osservati contro Poisson, serie piu' lunga a zero,
#      venerdi' 09/10, simboli, segnali, G1 delle gemelle, replica fra job,
#      rapporti dei due controlli. Stampa la LETTURA MECCANICA con le
#      categorie congelate nel file madre
#      prove/AZZURRA_FREQ_2026-10-10_A_base.txt: il verdetto lo scrive la
#      sessione sullo zip;
#   5. zip sul Desktop (AZZURRA_FREQ.zip), elenco dei file attesi
#      verificato LEGGENDO LO ZIP.
#
#  COSA NON FA: non tocca conti, ordini, posizioni, preset, sedie, taglie;
#  non chiude nessun processo che TROVA aperto (se trova MT5 o MetaEditor
#  aperti si FERMA). L'UNICA chiusura possibile e' quella del MetaEditor che
#  lo script STESSO ha avviato per la compilazione ($pMe, oggetto del suo
#  Start-Process), e solo se dopo 120 secondi non ha prodotto l'.ex5. Il
#  terminale lo apre e lo chiude il driver dei round (ShutdownTerminal=1).
#  Non svuota la cache del tester; non tocca CODA.txt ne' il runner
#  notturno (VPS). Non giudica il merito: Modello 1 e' solo screening.
#  Scrive SOLO: %USERPROFILE%\abtg_azzurra_freq, %USERPROFILE%\abtg_round
#  (cartella di lavoro del driver), MQL5\Experts e MQL5\Include del
#  terminale BCM di questa macchina, il Desktop. Scrive DA SE' MT5 (non
#  questo script): report e cache del tester nella cartella dati del
#  terminale BCM, i per-trade dell'EA in Common\Files. Qui si COPIANO, non
#  si cancellano.
#
#  UNA SOLA VOLTA CON QUESTI MAGIC: un secondo lancio con gli stessi input
#  pesca le passate dalla cache del tester (tester\cache\*.opt) e NON
#  riscrive i per-trade; lo script se ne accorge (file NON freschi = NON
#  MISURATO). Per rifarla servono magic nuovi = nuovo pin.
#
#  CODICI D'USCITA: 0 = FREQUENZA LEGGIBILE (cella base con precondizioni
#  vere; la categoria e' nel riepilogo); 3 = NON MISURATO (lo zip esce lo
#  stesso); 1 = fermo PRIMA del tester.
#
#  NIENTE EMOJI QUI DENTRO (regola del 17/08): Windows PowerShell 5.1 legge
#  i .ps1 come ANSI. ASCII puro.
# =====================================================================
[CmdletBinding()]
param(
  [Parameter(Mandatory=$true)][string]$Pin,
  [int]$TettoMin = 20
)

$ErrorActionPreference = 'Stop'
$IC = [Globalization.CultureInfo]::InvariantCulture
[Threading.Thread]::CurrentThread.CurrentCulture   = $IC
[Threading.Thread]::CurrentThread.CurrentUICulture = $IC
# classe 1156: il TLS va impostato QUI, nel processo che scarica
[Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12

if($Pin -notmatch '^[0-9a-fA-F]{40}$'){ throw '-Pin obbligatorio e di 40 caratteri esadecimali: senza, girerebbe la punta del ramo spacciandola per un commit congelato.' }
$Pin = $Pin.ToLower()
if($TettoMin -lt 5 -or $TettoMin -gt 60){ throw '-TettoMin fuori da 5-60 minuti.' }
$RAW = 'https://raw.githubusercontent.com/claudiospadaro12/GITHUB/' + $Pin + '/'
$T0 = Get-Date

# --- COSTANTI (SHA256 calcolati dal commit; i file prova sono nello STESSO commit di questo script)
$EA       = 'ABTG_BulgeAzzurra'
$SHA_AZ   = 'B6B06347F6F73B4E0F8DE508087E48D089B911EE4CCAC250F8BEB8BE032A926B'   # mql5/Experts/ABTG_BulgeAzzurra.mq5 (31a11096, = campo 774500)
$SHA_INC  = '3EC971152E85E0082488CC4243FF45AE09948C191D52AB96050B48F94641A737'   # mql5/Include/ABTG_PausaGuardian.mqh
$SHA_WF   = '6EFF8E4061EB6E82F88C66673B26B7CF5BFFC1F3AB55F07E3A504EC6E0E027A1'   # backtest_pipeline/walkforward_generico.ps1
$SHA_RRV  = '3341756FB37889DBD6E827A87BAC26893E01C85B6C18343918083B01B4DD3425'   # backtest_pipeline/righe/RIGA_ROUND_VPS.ps1
$SIMB = 'EURGBP'
# classe 1222: il CAMPO gira su 33 simboli. A, B, C (controlli) su 22 cross; D = la cella del campo. La lista e' PER JOB, non globale.
$SL22 = 'EURUSD,GBPUSD,AUDUSD,NZDUSD,USDCAD,USDCHF,USDJPY,EURGBP,EURNZD,GBPJPY,GBPAUD,GBPCAD,GBPNZD,AUDJPY,AUDCAD,AUDNZD,NZDJPY,NZDCAD,NZDCHF,CADJPY,CADCHF,CHFJPY'
$SL33 = $SL22 + ',XAUUSD,100GBP,200AUD,225JPY,D30EUR,E35EUR,E50EUR,F40EUR,NASUSD,SPXUSD,U30USD'
$MODELLO = 1
$DEPOSITO = 10000
# finestra del file prova: IS 2026.01.01 -> 2026.06.30 (esclusa), OOS 2026.07.01 -> 2026.10.10 (esclusa) (driver r.934, @FRAZIONEIS 0.6383)
$IS_DA  = New-Object DateTime 2026, 1, 1
$IS_A   = New-Object DateTime 2026, 6, 30
$OOS_DA = New-Object DateTime 2026, 7, 1
$OOS_A  = New-Object DateTime 2026, 10, 10
$GIORNO_CAMPO = '2026-10-09'      # il venerdi' del campo
# classe 1223: Init 16:39 ora locale CEST = 15:39 server (BCM UTC+1 fisso). Barre chiuse valutate 14:00-20:00 (la 14:00 al primo tick
# dopo l Init); il forex BCM chiude alle 22:00 server il venerdi: 7 barre su 24.
$INIZIO_CAMPO = New-Object DateTime 2026, 10, 9, 15, 39, 0
$ESPOSIZIONE_CAMPO = 7.0 / 24.0
function Feriali($da, $a){
  $l = New-Object System.Collections.ArrayList
  $xd = $da
  while($xd -lt $a){ if($xd.DayOfWeek -ne [DayOfWeek]::Saturday -and $xd.DayOfWeek -ne [DayOfWeek]::Sunday){ [void]$l.Add($xd.ToString('yyyy-MM-dd', $IC)) }; $xd = $xd.AddDays(1) }
  return ,@($l)
}
$GIORNI_IS  = Feriali $IS_DA $IS_A
$GIORNI_OOS = Feriali $OOS_DA $OOS_A
$JOBS = @(
  [pscustomobject]@{ L='AZF_A'; P='AZZURRA_FREQ_2026-10-10_A_base.txt';               SL=$SL22; Lo=0.4; Hi=7.0; HP='9194C4136E8B8D7B88DC750712E4E4A404E31F873B3EC7B6832C9F0E41E3DF29';
    Righe=@('InpMagic=774511||774511||50||774561||Y', 'Azure_FirstTouchOnly=0', 'Azure_MaxRetraceRangeATR=1.5');
    Celle=@([pscustomobject]@{ K='A0'; M='774511'; V='OGNI'; Primo='0'; Rng=1.5 }, [pscustomobject]@{ K='A1'; M='774561'; V='OGNI'; Primo='0'; Rng=1.5 }) },
  [pscustomobject]@{ L='AZF_B'; P='AZZURRA_FREQ_2026-10-10_B_primo_tocco.txt';        SL=$SL22; Lo=0.4; Hi=7.0; HP='A09620264E40E55EB87B3D0D3C48C1147345D7796D93DAD5B17DC2A683747A72';
    Righe=@('InpMagic=774521', 'Azure_FirstTouchOnly=0||0||1||1||Y', 'Azure_MaxRetraceRangeATR=1.5');
    Celle=@([pscustomobject]@{ K='B0'; M='774521'; V='OGNI'; Primo='0'; Rng=1.5 }, [pscustomobject]@{ K='B1'; M='774521'; V='PRIMO'; Primo='1'; Rng=1.5 }) },
  [pscustomobject]@{ L='AZF_C'; P='AZZURRA_FREQ_2026-10-10_C_ritracciamento_off.txt'; SL=$SL22; Lo=0.4; Hi=7.0; HP='89B71C5C408F80240F96BC0AEB490C868C7272DA00ACE119FD13793BF687A7AA';
    Righe=@('InpMagic=774531||774531||50||774581||Y', 'Azure_FirstTouchOnly=0', 'Azure_MaxRetraceRangeATR=0');
    Celle=@([pscustomobject]@{ K='C0'; M='774531'; V='OGNI'; Primo='0'; Rng=0.0 }, [pscustomobject]@{ K='C1'; M='774581'; V='OGNI'; Primo='0'; Rng=0.0 }) },
  [pscustomobject]@{ L='AZF_D'; P='AZZURRA_FREQ_2026-10-10_D_campo33.txt';            SL=$SL33; Lo=0.6; Hi=10.0; HP='BEAE55C44F83D31E998918F245DD86DBE811AD851B69467C0FC7604972492473';
    Righe=@('InpMagic=774541||774541||50||774591||Y', 'Azure_FirstTouchOnly=0', 'Azure_MaxRetraceRangeATR=1.5');
    Celle=@([pscustomobject]@{ K='D0'; M='774541'; V='OGNI'; Primo='0'; Rng=1.5 }, [pscustomobject]@{ K='D1'; M='774591'; V='OGNI'; Primo='0'; Rng=1.5 }) }
)
$RIGHE_COMUNI = @('Use_Azure=1', 'Use_Purple=0', 'Use_Blue=0', 'Use_Orange=0', 'Risk_Percent=0.8', 'Max_Trades=4', 'Enable_Partial_Close=0', 'Enable_BE_1R=0', 'Enable_Trailing_R=0')
$CAMPI = @('Trades','Profit','Profit Factor','Equity DD %')
# per-trade: colonne confrontate deal per deal. SENZA magic (diverso per costruzione) e SENZA position_id (numerazione del tester: non e' l'operazione)
$COL_PT = @('close_time','symbol','deal_type','volume','price','net_profit','signal')

function Dico($t,$c='Gray'){ Write-Host ('   ' + $t) -ForegroundColor $c }
function Titolo($t){ Write-Host ''; Write-Host ('=== ' + $t + ' ===') -ForegroundColor Cyan }
function Scarica($rel, $dest){
  Remove-Item -LiteralPath $dest -Force -ErrorAction SilentlyContinue
  Invoke-RestMethod -Uri ($RAW + $rel + '?cb=' + [Guid]::NewGuid().ToString('N')) -OutFile $dest
  if(-not (Test-Path -LiteralPath $dest)){ throw ($rel + ': download fallito al pin ' + $Pin + '. Non si parte.') }
}
function Sha($p){
  if(-not (Test-Path -LiteralPath $p)){ return 'ASSENTE' }
  return (Get-FileHash -LiteralPath $p -Algorithm SHA256).Hash.ToUpper()
}
# legge un file anche se MT5 lo tiene aperto; decodifica UTF-16 (log di MT5) o UTF-8/ASCII
function LeggiCondiviso($path){
  $b = $null
  try{
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
function NumOk($s){
  $v = 0.0
  return [double]::TryParse(('' + $s).Trim(), [Globalization.NumberStyles]::Float, $IC, [ref]$v)
}
function Num($s){
  $v = 0.0
  if([double]::TryParse(('' + $s).Trim(), [Globalization.NumberStyles]::Float, $IC, [ref]$v)){ return $v }
  return [double]::NaN
}
function F2($v){ return ([Math]::Round([double]$v, 2)).ToString('0.00', $IC) }
function F3($v){ return ([Math]::Round([double]$v, 3)).ToString('0.000', $IC) }
function Pc($v){ return ([Math]::Round(100.0 * [double]$v, 1)).ToString('0.0', $IC) + '%' }
function Bool01($s){ $t = ('' + $s).Trim().ToLower(); if($t -eq 'true' -or $t -eq '1'){ return '1' }; if($t -eq 'false' -or $t -eq '0'){ return '0' }; return ('?' + $t) }

# =====================================================================
#  0. MACCHINA, TERMINALE, GRAFICI
# =====================================================================
Titolo '0 - MACCHINA E TERMINALE'
if($env:COMPUTERNAME -ne 'DESKTOP-H4D7CAJ'){
  throw ('AZZURRA_FREQ gira SOLO sul PC di backtest DESKTOP-H4D7CAJ. Qui la macchina si chiama: ' + $env:COMPUTERNAME + '. Sul VPS VMI3047753 non si lancia (firma del 21/09/2026: i round girano sul PC di backtest).')
}
Dico ('pc  : ' + $env:COMPUTERNAME) 'Green'
Dico ('pin : ' + $Pin) 'Green'
Dico ('data: ' + $T0.ToString('yyyy-MM-dd HH:mm:ss')) 'Green'
$Mutex = New-Object System.Threading.Mutex($false, 'Global\ABTG_AZZURRA_FREQ')
$preso = $false
try{ $preso = $Mutex.WaitOne(0) } catch [System.Threading.AbandonedMutexException] { $preso = $true; Dico 'il blocco Global\ABTG_AZZURRA_FREQ era stato lasciato da un giro INTERROTTO: lo riprendo' 'Yellow' }
if(-not $preso){ throw 'Un ALTRO giro di AZZURRA_FREQ sta gia girando su questo PC (mutex occupato). Aspetta che finisca, NON chiudere il suo terminale.' }
$mp = @(Get-Process -Name terminal64, metaeditor64 -ErrorAction SilentlyContinue)
if($mp.Count -gt 0){
  Write-Host '   MT5 / MetaEditor APERTI ORA su questo PC (PID, titolo, cartella):' -ForegroundColor Red
  $mp | Select-Object Id, MainWindowTitle, Path | Format-Table -AutoSize | Out-String -Width 300 | Write-Host
  throw 'MT5 o MetaEditor risulta APERTO su questo PC. Ogni job ne apre una copia sua con /config: col terminale gia aperto il tester non parte. GUARDA I GRAFICI (sedie attaccate?), chiudilo A MANO e rilancia. Se e aperto perche UN ALTRO ROUND sta girando, NON chiuderlo: aspetta (classe 853).'
}
$InstAttesa = 'C:\Program Files\BCM Markets MT5 Terminal'
$MetaEditor = Join-Path $InstAttesa 'metaeditor64.exe'
if(-not (Test-Path -LiteralPath (Join-Path $InstAttesa 'terminal64.exe'))){ throw ('terminale non trovato: ' + $InstAttesa + '. Non si cerca altrove apposta.') }
if(-not (Test-Path -LiteralPath $MetaEditor)){ throw ('MetaEditor non trovato: ' + $MetaEditor) }
$DataRoot = Join-Path $env:APPDATA 'MetaQuotes\Terminal'
$origini = @()
foreach($d in @(Get-ChildItem -Path $DataRoot -Directory -ErrorAction SilentlyContinue)){
  $o = Join-Path $d.FullName 'origin.txt'
  if(Test-Path -LiteralPath $o){
    $v = (LeggiCondiviso $o).Trim()
    if($v -ne ''){ $origini = $origini + @([pscustomobject]@{ Dir = $d.FullName; Inst = $v }) }
  }
}
# censimento P0 del 05/10/2026 (risultati_archivio/DUKA_P0_20261005_171046/REFERTO_DUKA_P0.txt sez. 5): oltre al BCM
# ci sono C:\MT5_Backtest e C:\FundedNext_Manuale. AMMESSE PER NOME (chiuse, NON toccate); una non censita ferma tutto (classe 1157).
$Censite = @('C:\MT5_Backtest', 'C:\FundedNext_Manuale')
$diversi = @($origini | Where-Object { $_.Inst -ne $InstAttesa })
$ignote  = @($diversi | Where-Object { $Censite -notcontains $_.Inst.TrimEnd('\') })
foreach($dv in @($diversi | Where-Object { $Censite -contains $_.Inst.TrimEnd('\') })){ Dico ('altra installazione di questo PC, censita il 05/10, CHIUSA e NON TOCCATA: ' + $dv.Inst) 'Yellow' }
if($ignote.Count -gt 0){
  foreach($dv in $ignote){ Write-Host ('     installazione NON censita: ' + $dv.Inst) -ForegroundColor Red }
  throw 'Fermo: su questa macchina ci sono installazioni MT5 NON censite (regola dei terminali multipli).'
}
$cands = @($origini | Where-Object { $_.Inst -eq $InstAttesa })
if($cands.Count -ne 1){ throw ('cartella dati NON univoca per ' + $InstAttesa + ': trovate ' + $cands.Count + '. Non si indovina.') }
$DataFolder = $cands[0].Dir
$chrRoot = Join-Path $DataFolder 'MQL5\Profiles\Charts'
$nChr = 0; $conEA = @()
if(Test-Path -LiteralPath $chrRoot){
  foreach($fc in @(Get-ChildItem -LiteralPath $chrRoot -Recurse -File -Filter '*.chr' -ErrorAction SilentlyContinue)){
    $nChr = $nChr + 1
    $tx = LeggiCondiviso $fc.FullName
    if(-not $tx){ $conEA = $conEA + @($fc.Directory.Name + '\' + $fc.Name + '  ILLEGGIBILE: conta come EA attaccato'); continue }
    if($tx -match '<expert>'){ $conEA = $conEA + @($fc.Directory.Name + '\' + $fc.Name + '  EA ATTACCATO') }
  }
}
if($nChr -le 0){ throw ('ZERO grafici salvati letti sotto ' + $chrRoot + ': una guardia che non legge niente non ha verificato niente. Non si parte.') }
if($conEA.Count -gt 0){ throw ('SEDIE ATTACCATE ai grafici salvati del terminale BCM demo 50503392 (' + ($conEA -join '; ') + '). Staccale prima: aprire il terminale col profilo le rimetterebbe in marcia (14/08/2026, ordini veri da questa macchina).') }
$MqlExp = Join-Path $DataFolder 'MQL5\Experts'
$MqlInc = Join-Path $DataFolder 'MQL5\Include'
$CF = Join-Path $env:APPDATA 'MetaQuotes\Terminal\Common\Files'
New-Item -ItemType Directory -Force -Path $MqlExp, $MqlInc | Out-Null
Dico ('terminale: ' + $InstAttesa + '   (demo 50503392, lo apre e lo chiude il driver)') 'Green'
Dico ('dati     : ' + $DataFolder) 'Green'
Dico ('grafici salvati letti: ' + $nChr + ', nessun EA attaccato') 'Green'

# =====================================================================
#  1. SORGENTI AL PIN, FILE PROVA, COMPILAZIONE DELL'EA
# =====================================================================
Titolo '1 - SORGENTI AL PIN E COMPILAZIONE'
$W = Join-Path $env:USERPROFILE 'abtg_azzurra_freq'
New-Item -ItemType Directory -Force -Path $W | Out-Null
$AR = Join-Path $env:USERPROFILE 'abtg_round'
$rrv = Join-Path $W 'RIGA_ROUND_VPS.ps1'
$srcAz = Join-Path $W ($EA + '.mq5')
$srcInc = Join-Path $W 'ABTG_PausaGuardian.mqh'
Scarica 'backtest_pipeline/righe/RIGA_ROUND_VPS.ps1' $rrv
Scarica ('mql5/Experts/' + $EA + '.mq5') $srcAz
Scarica 'mql5/Include/ABTG_PausaGuardian.mqh' $srcInc
$controlli = @(@($rrv, $SHA_RRV, 'RIGA_ROUND_VPS.ps1'), @($srcAz, $SHA_AZ, ($EA + '.mq5')), @($srcInc, $SHA_INC, 'ABTG_PausaGuardian.mqh'))
foreach($j in $JOBS){
  $pp = Join-Path $W $j.P
  Scarica ('backtest_pipeline/prove/' + $j.P) $pp
  $controlli = $controlli + @(,@($pp, $j.HP, $j.P))
}
foreach($ck in $controlli){
  $hh = Sha $ck[0]
  if($hh -ne $ck[1]){ throw ($ck[2] + ' scaricato al pin ha SHA256 ' + $hh + ' invece di ' + $ck[1] + ': copia sbagliata o cache di GitHub. Non si parte.') }
  Dico ($ck[2] + ': SHA256 ' + $hh.Substring(0,12) + ' = quello del commit') 'Green'
}
if(-not (Select-String -LiteralPath $rrv -SimpleMatch -Pattern 'MARCATORE_RIGA_ROUND_VPS_v2' -Quiet)){ throw 'RIGA_ROUND_VPS.ps1 senza il marcatore v2. Non si parte.' }
foreach($j in $JOBS){
  $pp = Join-Path $W $j.P
  $tx = @(Get-Content -LiteralPath $pp)
  foreach($rg in @($j.Righe + $RIGHE_COMUNI + @('Symbols_List=' + $j.SL))){
    $nome = $rg.Split('=')[0]
    $trov = @($tx | Where-Object { $_ -like ($nome + '=*') })
    if($trov.Count -ne 1 -or $trov[0] -ne $rg){ throw ($j.P + ': la riga ' + $nome + ' non e quella dichiarata (' + $rg + '). Non si parte.') }
  }
}
Dico 'file prova: magic, assi, Symbols_List e pin dell Azzurra come dichiarati nei quattro file' 'Green'

# --- la PRIMA compilazione dell'EA su questo PC (classi 1167, 1168, 1152)
$CompNome = $EA
$mq5Dst = Join-Path $MqlExp ($CompNome + '.mq5')
$ex5 = Join-Path $MqlExp ($CompNome + '.ex5')
$logC = Join-Path $W ('compile_' + $CompNome + '.log')
if(($mq5Dst + $logC) -match '\s'){ throw ('percorso di compilazione con uno SPAZIO (' + $mq5Dst + ' / ' + $logC + '): Start-Process non lo quota (classe 1152). Non si parte.') }
function FermaCompilazione($perche){
  $dskC  = [Environment]::GetFolderPath('Desktop')
  $CartC = Join-Path $dskC 'AZZURRA_FREQ_COMPILAZIONE_FALLITA'
  $zipC  = $CartC + '.zip'
  $stC   = (Get-Date).ToString('yyyyMMdd_HHmmss')
  try{
    if(Test-Path -LiteralPath $CartC){ Move-Item -LiteralPath $CartC -Destination ($CartC + '_VECCHIA_' + $stC) -Force }
    if(Test-Path -LiteralPath $zipC){ Move-Item -LiteralPath $zipC -Destination ($CartC + '_VECCHIO_' + $stC + '.zip') -Force }
    New-Item -ItemType Directory -Force -Path $CartC | Out-Null
    $haLog = Test-Path -LiteralPath $logC
    $righeLog = @()
    if($haLog){
      Copy-Item -LiteralPath $logC -Destination (Join-Path $CartC ('compile_' + $CompNome + '.log')) -Force
      $righeLog = @(((LeggiCondiviso $logC) -split "`r?`n") | Where-Object { $_ -match '(?i)error|errori|errore|warning|avvis|result|risultato' } | Select-Object -First 80)
    }
    $testaC = @(('AZZURRA_FREQ: COMPILAZIONE DI ' + $CompNome + ' FALLITA. Nessun job lanciato, nessun tester.'), ('motivo: ' + $perche), ('pin: ' + $Pin + '   pc: ' + $env:COMPUTERNAME + '   data: ' + $stC), ('log di MetaEditor presente: ' + $haLog), '', 'righe di errore/avviso del log (il log intero e accanto):')
    (($testaC + $righeLog) -join "`r`n") | Set-Content -LiteralPath (Join-Path $CartC 'COMPILAZIONE_FALLITA.txt') -Encoding ASCII
    Compress-Archive -Path (Join-Path $CartC '*') -DestinationPath $zipC -Force
    Write-Host ('   ZIP DA MANDARE (compilazione fallita): ' + $zipC) -ForegroundColor Red
  } catch { Write-Host ('   zip della compilazione NON creato (' + $_.Exception.Message + '): il log e in ' + $logC) -ForegroundColor Red }
  throw ('COMPILAZIONE FALLITA: ' + $perche + ' Nessun job e partito. Manda lo zip AZZURRA_FREQ_COMPILAZIONE_FALLITA.zip dal Desktop.')
}
Copy-Item -LiteralPath $srcAz -Destination $mq5Dst -Force
Copy-Item -LiteralPath $srcInc -Destination (Join-Path $MqlInc 'ABTG_PausaGuardian.mqh') -Force
if((Sha $mq5Dst) -ne $SHA_AZ){ throw ('la copia messa in ' + $mq5Dst + ' non ha lo SHA256 del commit. Non si parte.') }
Remove-Item -LiteralPath $logC -Force -ErrorAction SilentlyContinue
Remove-Item -LiteralPath $ex5 -Force -ErrorAction SilentlyContinue
if(Test-Path -LiteralPath $ex5){ FermaCompilazione 'il vecchio .ex5 non si cancella: un compilato vecchio passerebbe per nuovo (classe 1168).' }
$tComp = Get-Date
$pMe = Start-Process -FilePath $MetaEditor -ArgumentList @(('/compile:' + $mq5Dst), ('/log:' + $logC)) -PassThru
$attC = 0
while(-not (Test-Path -LiteralPath $ex5) -and $attC -lt 60){ Start-Sleep -Seconds 2; $attC = $attC + 1 }
$attE = 0
while(-not $pMe.HasExited -and $attE -lt 30){ Start-Sleep -Seconds 2; $attE = $attE + 1 }
Start-Sleep -Seconds 3
$testoLogC = ''
if(Test-Path -LiteralPath $logC){ $testoLogC = LeggiCondiviso $logC }
if(-not (Test-Path -LiteralPath $ex5)){
  try{ if(-not $pMe.HasExited){ $pMe.Kill() } }catch{ }
  ($testoLogC -split "`r?`n") | Select-Object -Last 25 | ForEach-Object { Write-Host ('     ' + $_) -ForegroundColor DarkYellow }
  FermaCompilazione ($CompNome + '.ex5 NON prodotto dopo 120 secondi.')
}
if((Get-Item -LiteralPath $ex5).LastWriteTime -lt $tComp.AddSeconds(-2)){ FermaCompilazione ('l .ex5 trovato e piu vecchio dell avvio della compilazione: non e quello di adesso.') }
$compErr = -1; $compWarn = -1
$mRes = [regex]::Match($testoLogC, '(\d+)\s+(?:errors?|errori|errore),\s*(\d+)\s+(?:warnings?|avvisi|avviso)')
if($mRes.Success){ $compErr = [int]$mRes.Groups[1].Value; $compWarn = [int]$mRes.Groups[2].Value }
if($compErr -gt 0){
  ($testoLogC -split "`r?`n") | Where-Object { $_ -match '(?i)error|errori|errore' } | Select-Object -First 20 | ForEach-Object { Write-Host ('     ' + $_) -ForegroundColor DarkYellow }
  FermaCompilazione ('MetaEditor ha prodotto l .ex5 ma il log dice ' + $compErr + ' errori: non si usa un compilato dubbio.')
}
Dico ('compilato: ' + $ex5 + '   SHA256 .ex5 ' + (Sha $ex5).Substring(0,12)) 'Green'
if($compErr -eq 0){ Dico ('log di compilazione: 0 errori, ' + $compWarn + ' avvisi') $(if($compWarn -eq 0){'Green'}else{'Yellow'}) }
else { Dico 'log di compilazione: riga del risultato NON letta (formato diverso?): il verdetto e l .ex5 appena prodotto (il vecchio era stato cancellato)' 'Yellow' }
foreach($lw in @(($testoLogC -split "`r?`n") | Where-Object { $_ -match '(?i)warning|avviso|avvisi' -and $_ -notmatch '\d+\s+(?:errors?|errori|errore),' } | Select-Object -First 15)){ Dico ('   ' + $lw) 'Yellow' }
Dico 'NB: il driver dei round la RICOMPILA dal ramo lavoro a ogni job; lo SHA256 dei byte compilati si ricontrolla DOPO ogni job (classe 166/595).' 'Gray'

# =====================================================================
#  2. CARTELLA DEI RISULTATI E I TRE JOB
# =====================================================================
$dsk = [Environment]::GetFolderPath('Desktop')
if([string]::IsNullOrWhiteSpace($dsk)){ $dsk = Join-Path $env:USERPROFILE 'Desktop' }
$OUT = Join-Path $dsk 'AZZURRA_FREQ'
$ZIP = Join-Path $dsk 'AZZURRA_FREQ.zip'
$stampa = $T0.ToString('yyyyMMdd_HHmmss')
if(Test-Path -LiteralPath $OUT){ Move-Item -LiteralPath $OUT -Destination ($OUT + '_VECCHIA_' + $stampa) -Force; Dico ('cartella di un giro PRECEDENTE rinominata: AZZURRA_FREQ_VECCHIA_' + $stampa) 'Yellow' }
if(Test-Path -LiteralPath $ZIP){ Move-Item -LiteralPath $ZIP -Destination (Join-Path $dsk ('AZZURRA_FREQ_VECCHIO_' + $stampa + '.zip')) -Force; Dico 'zip di un giro PRECEDENTE rinominato con la data' 'Yellow' }
New-Item -ItemType Directory -Force -Path $OUT, (Join-Path $OUT 'CSV'), (Join-Path $OUT 'PASSATE'), (Join-Path $OUT 'LOG_TESTER'), (Join-Path $OUT 'prove') | Out-Null
foreach($j in $JOBS){ Copy-Item -LiteralPath (Join-Path $W $j.P) -Destination (Join-Path $OUT 'prove') -Force }
if(Test-Path -LiteralPath $logC){ Copy-Item -LiteralPath $logC -Destination $OUT -Force }
foreach($j in $JOBS){
  foreach($vv in @((Join-Path $dsk ('ROUND_' + $j.L)), (Join-Path $dsk ('ROUND_' + $j.L + '.zip')))){
    if(Test-Path -LiteralPath $vv){ Remove-Item -LiteralPath $vv -Recurse -Force -ErrorAction SilentlyContinue; Dico ('tolta una raccolta PRECEDENTE del driver: ' + (Split-Path -Leaf $vv)) 'DarkYellow' }
  }
}
function NomePT($c){ return ('abtg_trades_' + $EA + '_' + $SIMB + '_' + $c.M + '_violaEA_azzurra' + $c.V + '.csv') }
function CartPT($j, $c){ return ('PASSATE\' + $j.L + '_' + $c.K + '_' + $c.M + '_' + $c.V) }

$ErrorActionPreference = 'Continue'
$STATO = @{}
foreach($j in $JOBS){
  $st = [pscustomobject]@{ Lanciato=$false; Rc=-99; Dur=0.0; Motore=@(); CsvIS=$null; CsvOOS=$null; PT=@{} }
  $STATO[$j.L] = $st
  $minAvv = ((Get-Date) - $T0).TotalMinutes
  if($minAvv -ge $TettoMin){
    Write-Host ('=== ' + $j.L + ': NON LANCIATO (tetto ' + $TettoMin + ' min, minuto ' + [int]$minAvv + ') ===') -ForegroundColor Red
    continue
  }
  $nAtt = 0
  while((@(Get-Process -Name terminal64 -ErrorAction SilentlyContinue)).Count -gt 0 -and $nAtt -lt 36){ Start-Sleep -Seconds 5; $nAtt = $nAtt + 1 }
  Titolo ('2 - JOB ' + $j.L + '   ' + $EA + '   ' + $j.P + '   (minuti dall avvio ' + [int]$minAvv + ', tetto di avvio ' + $TettoMin + ')')
  $st.Lanciato = $true
  $tIniJob = Get-Date
  # argomenti in variabili SEMPLICI (come R92BAB e BULGE_TEL_P0): niente accesso a proprieta' dentro la riga di comando di un eseguibile
  $argEA = '' + $EA; $argPr = '' + $j.P; $argEt = '' + $j.L
  & powershell.exe -NoProfile -ExecutionPolicy Bypass -File $rrv -Expert $argEA -Prova $argPr -Etichetta $argEt -Pin $Pin -Modello $MODELLO -Deposito $DEPOSITO
  $st.Rc = $LASTEXITCODE
  $st.Dur = ((Get-Date) - $tIniJob).TotalSeconds
  Dico ('durata del job ' + $j.L + ': ' + [int]$st.Dur + ' s (driver compreso)   rc ' + $st.Rc) 'Gray'
  # --- classe 166/595: i byte che hanno GIRATO (non il pin)
  $mot = @()
  $chk = @(@((Join-Path $AR ('src_prove\' + $EA + '.mq5')), $SHA_AZ, ($EA + '.mq5')), @((Join-Path $AR 'src_include\ABTG_PausaGuardian.mqh'), $SHA_INC, 'ABTG_PausaGuardian.mqh'), @((Join-Path $AR 'walkforward_generico.ps1'), $SHA_WF, 'walkforward_generico.ps1'), @((Join-Path $AR ('prove\' + $j.P)), $j.HP, $j.P))
  foreach($c in $chk){
    $h = Sha $c[0]
    if($h -ne $c[1]){ $mot += ($c[2] + ' ' + $(if($h -eq 'ASSENTE'){'ASSENTE'}else{'SHA256 DIVERSO DAL COMMIT (' + $h.Substring(0,12) + ')'})) }
  }
  $st.Motore = $mot
  if($mot.Count -eq 0){ Dico 'motore = commit (SHA256 di EA, include, driver e file prova sui byte che hanno girato)' 'Green' } else { Dico ('MOTORE DIVERSO DAL COMMIT: ' + ($mot -join ', ')) 'Red' }
  # --- i due CSV OptResults
  foreach($g in @('IS','OOS')){
    $cp = Join-Path $AR ('risultati_prove\' + $EA + '\' + $EA + '_' + $SIMB + '_' + $g + '_ohlc_' + $j.L + '.csv')
    $info = [pscustomobject]@{ Path=$cp; Fresco=$false; Righe=@(); Txt='' }
    if(-not (Test-Path -LiteralPath $cp)){ $info.Txt = 'ASSENTE' }
    elseif((Get-Item -LiteralPath $cp).LastWriteTime -lt $tIniJob){ $info.Txt = 'VECCHIO (scritto prima del job)' }
    else {
      $info.Fresco = $true
      try{ $info.Righe = @(Import-Csv -LiteralPath $cp) } catch { $info.Righe = @() }
      $info.Txt = ('fresco, ' + $info.Righe.Count + ' righe')
      Copy-Item -LiteralPath $cp -Destination (Join-Path $OUT 'CSV') -Force
    }
    if($g -eq 'IS'){ $st.CsvIS = $info } else { $st.CsvOOS = $info }
    Dico ('CSV ' + $g + ': ' + $info.Txt) $(if($info.Fresco){'Gray'}else{'Red'})
  }
  # --- per-trade di ogni cella, una cartella per cella
  foreach($c in $j.Celle){
    $dPass = Join-Path $OUT (CartPT $j $c)
    New-Item -ItemType Directory -Force -Path $dPass | Out-Null
    $nomeF = NomePT $c
    $src = Join-Path $CF $nomeF
    $e = [pscustomobject]@{ Nome=$nomeF; Stato='ASSENTE'; Byte=0; Copia='' }
    if(Test-Path -LiteralPath $src){
      $it = Get-Item -LiteralPath $src
      if($it.LastWriteTime -lt $tIniJob){ $e.Stato = 'VECCHIO' }
      else {
        $e.Stato = 'FRESCO'; $e.Byte = $it.Length
        $e.Copia = Join-Path $dPass $nomeF
        Copy-Item -LiteralPath $src -Destination $e.Copia -Force
      }
    }
    $st.PT[$c.K] = $e
    Dico ('cella ' + $c.K + ' magic ' + $c.M + ' ' + $c.V + ': per-trade ' + $e.Stato + ' (' + $e.Byte + ' byte)') 'Gray'
  }
  $srcR = Join-Path $dsk ('ROUND_' + $j.L)
  if(Test-Path -LiteralPath $srcR){ Copy-Item -LiteralPath $srcR -Destination $OUT -Recurse -Force -ErrorAction SilentlyContinue }
}

# =====================================================================
#  3. LOG DEL TESTER ED ESTRATTO
# =====================================================================
Titolo '3 - LOG DEL TESTER'
$nl = 0
$estr = New-Object System.Collections.ArrayList
foreach($fl in @(Get-ChildItem -Path (Join-Path $env:APPDATA 'MetaQuotes') -Recurse -Filter '*.log' -File -ErrorAction SilentlyContinue | Where-Object { $_.LastWriteTime -ge $T0 } | Sort-Object LastWriteTime | Select-Object -First 300)){
  $par = 'ignota'; if($fl.Directory.Parent){ $par = $fl.Directory.Parent.Name }
  $nomeL = ([string]$nl).PadLeft(4,'0') + '_' + $par + '_' + $fl.Directory.Name + '_' + $fl.Name
  Copy-Item -LiteralPath $fl.FullName -Destination (Join-Path (Join-Path $OUT 'LOG_TESTER') $nomeL) -Force -ErrorAction SilentlyContinue
  $nl = $nl + 1
  if($fl.FullName -match '(?i)EBWebView|leveldb|Session Storage|shared_proto'){ continue }
  foreach($ln in @((LeggiCondiviso $fl.FullName) -split "`r?`n")){
    if($ln -match 'passed in|BULGE-CONTA|\[BULGE\]|optimize Experts|Experts\\ABTG_BulgeAzzurra|OnTesterInit|cannot be initialized|new records saved|passes processed|shortest pass|testing of|OptFrame'){
      [void]$estr.Add($nomeL + ' | ' + $ln.Trim())
    }
  }
}
($estr -join "`r`n") | Set-Content -LiteralPath (Join-Path $OUT 'ESTRATTO_LOG.txt') -Encoding ASCII
Dico ('log copiati: ' + $nl + '   righe nell estratto: ' + $estr.Count) 'Gray'

# =====================================================================
#  4. LA FREQUENZA, A MACCHINA (categorie congelate nel file madre A)
# =====================================================================
Titolo '4 - FREQUENZA'
$R = New-Object System.Collections.ArrayList
function W($t){ [void]$R.Add($t); Write-Host ('   ' + $t) }
# --- le righe OptResults, per cella e gamba
$X = @{}
$PRE = @{}
foreach($j in $JOBS){
  $st = $STATO[$j.L]
  foreach($c in $j.Celle){ $X[$c.K] = @{ IS=$null; OOS=$null }; $PRE[$c.K] = New-Object System.Collections.ArrayList }
  if(-not $st.Lanciato){ foreach($c in $j.Celle){ [void]$PRE[$c.K].Add('p1 job ' + $j.L + ' non lanciato') }; continue }
  if($st.Motore.Count -gt 0){ foreach($c in $j.Celle){ [void]$PRE[$c.K].Add('p2 motore diverso dal commit: ' + ($st.Motore -join ', ')) } }
  foreach($g in @('IS','OOS')){
    $info = $(if($g -eq 'IS'){ $st.CsvIS } else { $st.CsvOOS })
    if(-not $info.Fresco){ foreach($c in $j.Celle){ [void]$PRE[$c.K].Add('p1 CSV ' + $g + ' ' + $info.Txt) }; continue }
    foreach($rw in $info.Righe){
      $mg = ('' + $rw.InpMagic).Trim(); $pr = Bool01 $rw.Azure_FirstTouchOnly
      $cel = @($j.Celle | Where-Object { $_.M -eq $mg -and $_.Primo -eq $pr })
      if($cel.Count -ne 1){ foreach($c in $j.Celle){ [void]$PRE[$c.K].Add('p3 ' + $g + ' riga del CSV con InpMagic ' + $mg + ' e Azure_FirstTouchOnly ' + $pr + ' che non e nessuna cella dichiarata') }; continue }
      $c = $cel[0]
      if($null -ne $X[$c.K][$g]){ [void]$PRE[$c.K].Add('p3 ' + $g + ' DUE righe per la stessa cella'); continue }
      $X[$c.K][$g] = $rw
      $tr = ('' + $rw.Trades).Trim()
      if($tr -notmatch '^[0-9]+$'){ [void]$PRE[$c.K].Add('p1 ' + $g + ' Trades illeggibile: ' + $tr) }
      $sl = ('' + $rw.Symbols_List).Trim()
      if($sl -ne $j.SL){ [void]$PRE[$c.K].Add('p3 ' + $g + ' Symbols_List nel CSV di ' + $sl.Length + ' caratteri (attesa la lista del job, ' + $j.SL.Length + ' caratteri)') }
      foreach($cp in @(@('Use_Azure','1'), @('Use_Purple','0'), @('Use_Blue','0'), @('Use_Orange','0'))){
        if((Bool01 $rw.($cp[0])) -ne $cp[1]){ [void]$PRE[$c.K].Add('p3 ' + $g + ' ' + $cp[0] + ' nel CSV = ' + $rw.($cp[0]) + ' (atteso ' + $cp[1] + '): il pin NON e arrivato') }
      }
      if((Num $rw.Risk_Percent) -ne 0.8 -or (Num $rw.Max_Trades) -ne 4){ [void]$PRE[$c.K].Add('p3 ' + $g + ' Risk_Percent/Max_Trades nel CSV = ' + $rw.Risk_Percent + '/' + $rw.Max_Trades + ' (attesi 0.8/4)') }
      if((Num $rw.Azure_MaxRetraceRangeATR) -ne $c.Rng){ [void]$PRE[$c.K].Add('p3 ' + $g + ' Azure_MaxRetraceRangeATR nel CSV = ' + $rw.Azure_MaxRetraceRangeATR + ' (atteso ' + $c.Rng + ')') }
    }
    foreach($c in $j.Celle){ if($null -eq $X[$c.K][$g]){ [void]$PRE[$c.K].Add('p1 ' + $g + ' manca la riga della cella') } }
  }
  foreach($c in $j.Celle){ if($st.PT[$c.K].Stato -ne 'FRESCO'){ [void]$PRE[$c.K].Add('p4 per-trade ' + $st.PT[$c.K].Stato + ' (' + $st.PT[$c.K].Nome + ')') } }
}
function Riga4($rw){
  if($null -eq $rw){ return 'n/d' }
  return ('Trades ' + ('' + $rw.Trades).Trim() + ' | Profit ' + ('' + $rw.Profit).Trim() + ' | PF ' + ('' + $rw.'Profit Factor').Trim() + ' | DD% ' + ('' + $rw.'Equity DD %').Trim())
}
function Uguali($a, $b){
  if($null -eq $a -or $null -eq $b){ return $false }
  foreach($c in $CAMPI){ if(('' + $a.$c).Trim() -ne ('' + $b.$c).Trim()){ return $false } }
  return $true
}
function TradesDi($rw){ if($null -eq $rw){ return -1 }; $t = ('' + $rw.Trades).Trim(); if($t -match '^[0-9]+$'){ return [int]$t }; return -1 }
# la VIRGOLA tiene l'array intero (cancello del 09/10 su BULGE_TEL_P0): senza, con UNA riga arriva un PSCustomObject senza .Count in PS 5.1
function LeggiPT($p){ if([string]::IsNullOrEmpty($p) -or -not (Test-Path -LiteralPath $p)){ return $null }; try{ return ,@(Import-Csv -LiteralPath $p -Delimiter ';') } catch { return $null } }
function ConfrontaPT($pa, $pb){
  $a = LeggiPT $pa; $b = LeggiPT $pb
  if($null -eq $a -or $null -eq $b){ return [pscustomobject]@{ Ok=$false; Txt='file mancante o illeggibile' } }
  if($a.Count -eq 0 -or $b.Count -eq 0){ return [pscustomobject]@{ Ok=$false; Txt=('per-trade SENZA deal (' + $a.Count + ' / ' + $b.Count + '): niente da confrontare, non e identita') } }
  if($a.Count -ne $b.Count){ return [pscustomobject]@{ Ok=$false; Txt=('righe ' + $a.Count + ' contro ' + $b.Count) } }
  for($i = 0; $i -lt $a.Count; $i++){
    foreach($c in $COL_PT){
      if(('' + $a[$i].$c).Trim() -ne ('' + $b[$i].$c).Trim()){
        return [pscustomobject]@{ Ok=$false; Txt=('primo deal diverso: riga ' + ($i+1) + ' colonna ' + $c + ' (' + ('' + $a[$i].$c).Trim() + ' -> ' + ('' + $b[$i].$c).Trim() + ') simbolo ' + ('' + $a[$i].symbol) + ' chiusura ' + ('' + $a[$i].close_time)) }
      }
    }
  }
  return [pscustomobject]@{ Ok=$true; Txt=('IDENTICI, ' + $a.Count + ' deal di uscita (colonne ' + ($COL_PT -join ',') + ')') }
}
# --- l'analisi di UN per-trade (gamba OOS): aperture, giorni, simboli, venerdi' del campo
function AnalizzaPT($p, $magicAtteso, $listaSimboli){
  $syms = @(('' + $listaSimboli).Split(','))
  $o = [pscustomobject]@{ Ok=$false; Txt=''; Deal=0; Pos=0; Az=0; Altri=0; Lng=0; Sht=0; Vinte=0; SommaNet=0.0; NetKo=0; Prima=''; Ultima='';
        FineGamba=0; MagicKo=0; OraKo=0; FuoriOOS=0; Spostati=0; Ven=0; VenSera=0; GiorniZero=0; SerieZero=0; SerieZeroDa=''; MaxGiorno=0;
        Isto=''; PerSimb=''; SimbZero=''; NSimb=0; NSimbZero=0; GiorniKS=0 }
  $a = LeggiPT $p
  if($null -eq $a){ $o.Txt = 'file mancante o illeggibile'; return $o }
  $o.Deal = $a.Count
  $posIds = @{}; $perG = @{}; $perdG = @{}; $perS = @{}
  foreach($gg in $GIORNI_OOS){ $perG[$gg] = 0; $perdG[$gg] = 0 }
  foreach($s in $syms){ $perS[$s] = 0 }
  $tMin = $null; $tMax = $null
  foreach($rr in $a){
    $posIds[('' + $rr.position_id).Trim()] = $true
    # classe 1224: i deal "end of test" (magic 0, ultimo secondo della gamba) NON sono chiusure vere ne' magic sbagliati
    $eot = (('' + $rr.exit_comment) -match '(?i)end of test')
    if(-not $eot -and ('' + $rr.magic).Trim() -ne $magicAtteso){ $o.MagicKo++ }
    $sg = ('' + $rr.signal).Trim()
    if($sg -eq 'AZZURRA'){ $o.Az++ } else { $o.Altri++ }
    $ec = ('' + $rr.entry_comment).Trim()
    if($ec.EndsWith('_L')){ $o.Lng++ } elseif($ec.EndsWith('_S')){ $o.Sht++ }
    if($eot){ $o.FineGamba++ }
    $sy = ('' + $rr.symbol).Trim()
    if($perS.ContainsKey($sy)){ $perS[$sy] = $perS[$sy] + 1 } else { $perS[$sy] = 1 }
    $nt = 0.0
    if(NumOk $rr.net_profit){ $nt = Num $rr.net_profit; $o.SommaNet = $o.SommaNet + $nt; if($nt -gt 0){ $o.Vinte++ } } else { $o.NetKo++ }
    $dt = [datetime]::MinValue
    if(-not [datetime]::TryParseExact(('' + $rr.close_time).Trim(), 'yyyy.MM.dd HH:mm:ss', $IC, [Globalization.DateTimeStyles]::None, [ref]$dt)){ $o.OraKo++; continue }
    if($null -eq $tMin -or $dt -lt $tMin){ $tMin = $dt }
    if($null -eq $tMax -or $dt -gt $tMax){ $tMax = $dt }
    $dd = $dt.Date
    if($dd.DayOfWeek -eq [DayOfWeek]::Saturday){ $dd = $dd.AddDays(-1); $o.Spostati++ }
    elseif($dd.DayOfWeek -eq [DayOfWeek]::Sunday){ $dd = $dd.AddDays(1); $o.Spostati++ }   # la domenica sera e' gia' il lunedi
    $k = $dd.ToString('yyyy-MM-dd', $IC)
    if(-not $perG.ContainsKey($k)){ $o.FuoriOOS++; continue }
    $perG[$k] = $perG[$k] + 1
    if($nt -lt 0){ $perdG[$k] = $perdG[$k] + 1 }
    if($k -eq $GIORNO_CAMPO){ $o.Ven++; if($dt.Date -eq $dd -and $dt -ge $INIZIO_CAMPO -and -not $eot){ $o.VenSera++ } }
  }
  $o.Pos = $posIds.Count
  if($null -ne $tMin){ $o.Prima = $tMin.ToString('yyyy.MM.dd HH:mm:ss', $IC); $o.Ultima = $tMax.ToString('yyyy.MM.dd HH:mm:ss', $IC) }
  $isto = @(0,0,0,0,0,0); $cur = 0; $curDa = ''
  foreach($gg in $GIORNI_OOS){
    $n = $perG[$gg]
    if($n -gt $o.MaxGiorno){ $o.MaxGiorno = $n }
    $isto[[Math]::Min(5, $n)] = $isto[[Math]::Min(5, $n)] + 1
    if($n -eq 0){ $o.GiorniZero++; if($cur -eq 0){ $curDa = $gg }; $cur++; if($cur -gt $o.SerieZero){ $o.SerieZero = $cur; $o.SerieZeroDa = $curDa } } else { $cur = 0 }
    if($perdG[$gg] -ge 3){ $o.GiorniKS++ }
  }
  $o.Isto = ('giorni con 0/1/2/3/4/5+ chiusure: ' + ($isto -join '/'))
  $o.PerSimb = ((@($syms | ForEach-Object { $_ + ' ' + $perS[$_] })) -join ', ')
  $extra = @($perS.Keys | Where-Object { $syms -notcontains $_ })
  if($extra.Count -gt 0){ $o.PerSimb = $o.PerSimb + ' | FUORI LISTA: ' + ((@($extra | ForEach-Object { $_ + ' ' + $perS[$_] })) -join ', ') }
  $zs = @($syms | Where-Object { $perS[$_] -eq 0 })
  $o.SimbZero = ($zs -join ',')
  $o.NSimb = $syms.Count; $o.NSimbZero = $zs.Count
  $o.Ok = $true
  return $o
}

$NIS = $GIORNI_IS.Count; $NOOS = $GIORNI_OOS.Count
W ('AZZURRA_FREQ -- pin ' + $Pin + ' -- data ' + $T0.ToString('yyyy-MM-dd HH:mm:ss') + ' -- pc ' + $env:COMPUTERNAME)
W ('EA ' + $EA + ' (SHA256 ' + $SHA_AZ.Substring(0,16) + '...), grafico ' + $SIMB + ' H1, A/B/C 22 cross, D 33 simboli (il campo), Modello ' + $MODELLO + ', deposito ' + $DEPOSITO + ', rischio 0,80 x Max_Trades 4 (quello vero del campo)')
W ('finestra: IS ' + $IS_DA.ToString('yyyy.MM.dd', $IC) + ' -> ' + $IS_A.ToString('yyyy.MM.dd', $IC) + ' (esclusa) = ' + $NIS + ' giorni feriali | OOS ' + $OOS_DA.ToString('yyyy.MM.dd', $IC) + ' -> ' + $OOS_A.ToString('yyyy.MM.dd', $IC) + ' (esclusa) = ' + $NOOS + ' giorni feriali')
W ('job: ' + (($JOBS | ForEach-Object { $_.L + ' ' + [int]$STATO[$_.L].Dur + ' s rc ' + $STATO[$_.L].Rc }) -join ' | '))
W ('compilazione: ' + $compErr + ' errori, ' + $compWarn + ' avvisi (-1 = riga non letta)')
W ''
W 'RIGHE OptResults (Trades = deal di uscita = POSIZIONI, gestione nuda; Modello 1: PF e DD sono SCREENING, nessun verdetto):'
foreach($j in $JOBS){ foreach($c in $j.Celle){ foreach($g in @('IS','OOS')){ W ('  ' + $c.K + ' ' + $g.PadRight(3) + ' magic ' + $c.M + ' tocco ' + $c.V.PadRight(5) + ' range ' + $c.Rng + ' : ' + (Riga4 $X[$c.K][$g])) } } }
W ''
W 'PRECONDIZIONI PER CELLA (p1 girata, p2 motore = pin, p3 input arrivati, p4 per-trade fresco):'
foreach($j in $JOBS){ foreach($c in $j.Celle){ if($PRE[$c.K].Count -eq 0){ W ('  ' + $c.K + ': tutte vere') } else { W ('  ' + $c.K + ': MANCANO -> ' + (@($PRE[$c.K]) -join ' ; ')) } } }
W ''
# --- analisi per-trade OOS di ogni cella
$AN = @{}
foreach($j in $JOBS){
  foreach($c in $j.Celle){
    $e = $STATO[$j.L].PT[$c.K]
    $cp = ''; if($null -ne $e -and $e.Stato -eq 'FRESCO'){ $cp = $e.Copia }
    $lsJ = '' + $j.SL
    $ana = AnalizzaPT $cp $c.M $lsJ
    $AN[$c.K] = $ana
    if(-not $ana.Ok){ W ('  ' + $c.K + ' per-trade OOS: ' + $ana.Txt); continue }
    $lam = $ana.Pos / [double]$NOOS
    W ('  ' + $c.K + ' per-trade OOS: ' + $ana.Deal + ' deal di uscita, ' + $ana.Pos + ' posizioni (AZZURRA ' + $ana.Az + ', altri segnali ' + $ana.Altri + '; long ' + $ana.Lng + ', short ' + $ana.Sht + '), chiusure dal ' + $ana.Prima + ' al ' + $ana.Ultima)
    W ('     lambda OOS = ' + $ana.Pos + ' / ' + $NOOS + ' = ' + (F3 $lam) + ' aperture al giorno feriale | ' + $ana.Isto + ' | max in un giorno ' + $ana.MaxGiorno)
    W ('     giorni a zero OSSERVATI ' + $ana.GiorniZero + ' su ' + $NOOS + ' = ' + (Pc ($ana.GiorniZero / [double]$NOOS)) + '  contro Poisson exp(-lambda) = ' + (Pc ([Math]::Exp(-$lam))) + ' | serie piu lunga a zero: ' + $ana.SerieZero + ' giorni feriali (dal ' + $ana.SerieZeroDa + ')')
    W ('     venerdi ' + $GIORNO_CAMPO + ': ' + $ana.Ven + ' chiusure (end of test comprese), di cui VERE dalle 15:39 server (partenza dell EA in campo) ' + $ana.VenSera + '; posizioni chiuse a fine gamba (end of test) ' + $ana.FineGamba)
    if($ana.Pos -ne $ana.Deal){ W ('     ATTENZIONE: ' + $ana.Deal + ' deal ma ' + $ana.Pos + ' position_id distinti: con gestione nuda devono coincidere (parziale acceso o file sporco): la cella NON si legge') }
    W ('     controlli: magic diverso ' + $ana.MagicKo + ', ora illeggibile ' + $ana.OraKo + ', chiusure fuori dalla gamba OOS ' + $ana.FuoriOOS + ' (se > 0 il file NON e la gamba OOS), del weekend portate al venerdi ' + $ana.Spostati + ', net illeggibili ' + $ana.NetKo)
    W ('     screening (NON verdetto): vinte ' + $ana.Vinte + ' su ' + $ana.Deal + ', somma net ' + (F2 $ana.SommaNet) + ' (deal di USCITA: manca la commissione d ingresso, il Profit del CSV e quello che vale) | giorni con >= 3 chiusure in perdita (proxy kill switch a 0,8): ' + $ana.GiorniKS)
    W ('     per simbolo: ' + $ana.PerSimb)
    W ('     simboli a ZERO nella gamba OOS: ' + $ana.NSimbZero + ' su ' + $ana.NSimb + $(if($ana.SimbZero -ne ''){ ' (' + $ana.SimbZero + ')' }else{ '' }))
  }
}
W ''
# --- G1, replica fra job, coerenza per-trade / CSV
W 'DETERMINISMO E REPLICA:'
$g1 = @{}
foreach($cp in @(@('A0','A1'), @('C0','C1'), @('D0','D1'), @('A0','B0'))){
  $k0 = $cp[0]; $k1 = $cp[1]
  $r0i = $X[$k0]['IS']; $r1i = $X[$k1]['IS']; $r0o = $X[$k0]['OOS']; $r1o = $X[$k1]['OOS']
  $trOk = ((TradesDi $r0i) -ge 0) -and ((TradesDi $r0i) -eq (TradesDi $r1i)) -and ((TradesDi $r0o) -ge 0) -and ((TradesDi $r0o) -eq (TradesDi $r1o))
  $oosOk = Uguali $r0o $r1o
  $dIS = 'n/d'
  $isOk = $false
  if($null -ne $r0i -and $null -ne $r1i -and (NumOk $r0i.Profit) -and (NumOk $r1i.Profit)){ $dv = [Math]::Abs((Num $r0i.Profit) - (Num $r1i.Profit)); $dIS = F2 $dv; $isOk = ($dv -le 0.10) }
  $ptc = $null; $pa = ''; $pb = ''
  foreach($j in $JOBS){ foreach($c in $j.Celle){ $e = $STATO[$j.L].PT[$c.K]; if($null -ne $e -and $e.Stato -eq 'FRESCO'){ if($c.K -eq $k0){ $pa = $e.Copia }; if($c.K -eq $k1){ $pb = $e.Copia } } } }
  $ptc = ConfrontaPT $pa $pb
  $ok = $trOk -and $oosOk -and $isOk -and $ptc.Ok
  $g1[$k0 + '_' + $k1] = $ok
  W ('  ' + $k0 + ' / ' + $k1 + ': Trades IS e OOS uguali ' + $trOk + ' | OOS identica (Trades, Profit, PF, DD) ' + $oosOk + ' | |dProfit IS| ' + $dIS + ' (tolleranza 0,10) | per-trade OOS: ' + $ptc.Txt + '  => ' + $(if($ok){'OK'}else{'NON OK'}))
}
foreach($j in $JOBS){ foreach($c in $j.Celle){
  $ana = $AN[$c.K]; $to = TradesDi $X[$c.K]['OOS']
  if($ana.Ok -and $to -ge 0){ W ('  coerenza ' + $c.K + ': deal del per-trade ' + $ana.Deal + ' contro Trades OOS del CSV ' + $to + ' -> ' + $(if($ana.Deal -eq $to){'uguali'}else{'DIVERSI: il per-trade non e la gamba OOS di questa cella, o la cella non e nuda'})) }
} }
W ''
# --- le basi: A (22 cross) per i controlli B e C; D (33 simboli) per la lambda DEL CAMPO (classe 1222)
# leggibile = precondizioni vere, solo AZZURRA, tutto dentro la gamba OOS, un deal per posizione (gestione nuda), deal = Trades OOS del CSV
function Leggibile($k){ return ($PRE[$k].Count -eq 0 -and $AN[$k].Ok -and $AN[$k].Altri -eq 0 -and $AN[$k].FuoriOOS -eq 0 -and $AN[$k].Pos -eq $AN[$k].Deal -and $AN[$k].Deal -eq (TradesDi $X[$k]['OOS'])) }
# regola del file madre (G1): Trades DIVERSI fra le gemelle = ROTTO (determinismo del banco: la frequenza NON si legge);
# Trades uguali ma Profit/PF/DD o per-trade diversi = G1RESTO (la frequenza si legge, PF e DD no); altrimenti OK o NONLEGGIBILE.
function Gemelle($k0, $k1){
  $a0 = TradesDi $X[$k0]['IS']; $a1 = TradesDi $X[$k1]['IS']; $b0 = TradesDi $X[$k0]['OOS']; $b1 = TradesDi $X[$k1]['OOS']
  if($a0 -ge 0 -and $a1 -ge 0 -and $b0 -ge 0 -and $b1 -ge 0 -and ($a0 -ne $a1 -or $b0 -ne $b1)){ return 'ROTTO' }
  if((Leggibile $k0) -and (Leggibile $k1)){ if($g1[$k0 + '_' + $k1]){ return 'OK' }; return 'G1RESTO' }
  return 'NONLEGGIBILE'
}
function Lambda($k){ return [pscustomobject]@{ IS=((TradesDi $X[$k]['IS']) / [double]$NIS); OOS=($AN[$k].Pos / [double]$NOOS) } }
# base dei CONTROLLI: A0; ripiego DICHIARATO su B0 (replica di A) solo se A non e leggibile e le gemelle A non sono rotte
$statoA = Gemelle 'A0' 'A1'
$baseA = ''
if($statoA -eq 'OK' -or $statoA -eq 'G1RESTO'){ $baseA = 'A0' }
elseif($statoA -ne 'ROTTO' -and (Leggibile 'B0')){ $baseA = 'B0' }
W ('BASE DEI CONTROLLI (22 cross): gemelle A0/A1 ' + $statoA + ' -> ' + $(if($baseA -eq ''){'NESSUNA: i controlli B e C non si leggono'}elseif($baseA -eq 'B0'){'B0 (replica di A a magic 774521, ripiego DICHIARATO)'}else{'A0'}))
if($baseA -ne ''){ $la = Lambda $baseA; W ('  lambda ' + $baseA + ' (22 cross): IS ' + (F3 $la.IS) + ' | OOS ' + (F3 $la.OOS) + ' al giorno feriale -- banda attesa [DERIVATA, debole] 0,4 - 7 -- NON e la cella del campo') }
W ''
# la cella del CAMPO: D0 (gemella D1). Nessun ripiego: senza D la lambda del campo e NON MISURATA (A ha 11 simboli in meno)
$statoD = Gemelle 'D0' 'D1'
$esito = ''
$codice = 3
if($statoD -eq 'ROTTO'){
  $esito = 'NON MISURATO: le gemelle D0/D1 (cella del campo) hanno Trades DIVERSI = determinismo del banco rotto (file madre, G1): la lambda del campo non si legge'
} elseif($statoD -eq 'NONLEGGIBILE'){
  $esito = 'NON MISURATO: la cella del campo D non e leggibile (vedi precondizioni, G1 e coerenza qui sopra); la lambda di A (22 cross) NON la sostituisce'
} else {
  $tIS = TradesDi $X['D0']['IS']; $tOOS = TradesDi $X['D0']['OOS']
  if($tIS -eq 0 -and $tOOS -eq 0){
    $esito = 'NON MISURATO: cella del campo D con Trades = 0 in IS e in OOS. EA cieco nel tester e regola che non scatta danno lo STESSO zero: prossimo passo il controllo positivo Use_Purple=1 (file madre, attesa Z)'
  } else {
    $codice = 0
    $ld = Lambda 'D0'
    $lamIS = $ld.IS; $lamO = $ld.OOS
    $cat = ''
    if($lamO -lt 0.1){ $cat = 'CELLA QUASI VUOTA (lambda < 0,1): una settimana a zero e la norma; serve solo PER FAMIGLIA; NON e un verdetto di morte' }
    elseif($lamO -lt 0.5){ $cat = 'RARA (0,1 <= lambda < 0,5): un giorno pieno a zero e la norma' }
    elseif($lamO -lt 2.0){ $cat = 'REGOLARE (0,5 <= lambda < 2): una SETTIMANA piena a zero in campo sarebbe un anomalia da controllare' }
    else { $cat = 'FREQUENTE (lambda >= 2): DUE giorni pieni consecutivi a zero in campo sarebbero un anomalia da controllare' }
    W ('CELLA DEL CAMPO D0 (33 simboli, gemella D1 ' + $statoD + $(if($statoD -eq 'G1RESTO'){': la frequenza si legge, PF e DD NO'}else{''}) + ')')
    W ('  lambda IS (dal CSV) = ' + $tIS + ' / ' + $NIS + ' = ' + (F3 $lamIS) + ' | lambda OOS (dal per-trade) = ' + $AN['D0'].Pos + ' / ' + $NOOS + ' = ' + (F3 $lamO) + ' aperture al giorno feriale, sui 33 simboli')
    $rap = $(if($lamIS -gt 0){ $lamO / $lamIS } else { [double]::NaN })
    W ('  rapporto OOS/IS = ' + $(if([double]::IsNaN($rap)){'n/d'}else{F2 $rap}) + '   (oltre 2 o sotto 0,5: la frequenza dipende dal tratto di mercato, un giorno in campo pesa ancora meno)')
    W ('  banda attesa [DERIVATA, debole] 0,6 - 10 al giorno: ' + $(if($lamO -lt 0.6){'SOTTO la banda (piu rara del previsto)'}elseif($lamO -gt 10){'SOPRA la banda'}else{'DENTRO la banda'}))
    W ('  simboli a ZERO nella gamba OOS: ' + $AN['D0'].NSimbZero + ' su ' + $AN['D0'].NSimb + $(if($AN['D0'].SimbZero -ne ''){ ' (' + $AN['D0'].SimbZero + ')' }else{''}) + '   (un simbolo che il tester non vede ABBASSA la lambda)')
    if($baseA -ne ''){ $la = Lambda $baseA; if($la.OOS -gt 0){ W ('  rapporto D/A in OOS = ' + (F2 ($lamO / $la.OOS)) + '   (attesa 1,0 - 1,8; ~1,0 con simboli a zero fra gli 11 nuovi = il tester non li vede)') } }
    W ('  P(0) con la lambda OOS misurata: giorno intero ' + (Pc ([Math]::Exp(-$lamO))) + ' | 7/24 di giorno (il venerdi 09/10 del campo) ' + (Pc ([Math]::Exp(-$lamO * $ESPOSIZIONE_CAMPO))) + ' | 2 giorni pieni ' + (Pc ([Math]::Exp(-2 * $lamO))) + ' | 5 giorni pieni ' + (Pc ([Math]::Exp(-5 * $lamO))))
    $zOss = $AN['D0'].GiorniZero / [double]$NOOS
    W ('  giorni a zero osservati ' + (Pc $zOss) + ' contro Poisson ' + (Pc ([Math]::Exp(-$lamO))) + ': ' + $(if($zOss -gt [Math]::Exp(-$lamO) + 0.10){'gli zeri SI RAGGRUPPANO (oltre +10 punti): per il campo vale la frazione OSSERVATA e la serie piu lunga, non la formula'}else{'entro +10 punti dalla Poisson'}))
    W ('  CATEGORIA: ' + $cat)
    W ('  venerdi 09/10 nel tester (indizio, non prova: stato diverso dal campo): ' + $AN['D0'].VenSera + ' chiusure VERE dalle 15:39 server (end of test escluse), ' + $AN['D0'].FineGamba + ' posizioni portate a fine gamba (end of test, magic diverso ignorato: MagicKo ' + $AN['D0'].MagicKo + ')')
    $esito = ('FREQUENZA DEL CAMPO LEGGIBILE (cella D, 33 simboli) -- lambda OOS ' + (F3 $lamO) + '/giorno, simboli a zero nella gamba OOS ' + $AN['D0'].NSimbZero + '/' + $AN['D0'].NSimb + ', P(0) del venerdi 7/24 ' + (Pc ([Math]::Exp(-$lamO * $ESPOSIZIONE_CAMPO))) + ', ' + $cat)
  }
}
W ''
# --- i due controlli: rapporto di frequenza contro la base
W 'CONTROLLI (rapporto Trades cella / Trades base A, per gamba; si leggono SOLO se la replica A0/B0 e OK, classe 1206; attese e alternative nei file B e C):'
foreach($cc in @(@('B1', 'solo il primo tocco', 0.3, 0.8, 0.9, 0.2), @('C0', 'ritracciamento spento', 1.05, 1.6, -1, 2.0))){
  $k = $cc[0]
  if($baseA -eq '' -or -not (Leggibile $k) -or -not $g1['A0_B0']){ W ('  ' + $k + ' (' + $cc[1] + '): NON LEGGIBILE (base A assente, cella non leggibile o replica A0/B0 NON OK)'); continue }
  $txt = @()
  foreach($g in @('IS','OOS')){
    $tb = TradesDi $X[$baseA][$g]; $tc = TradesDi $X[$k][$g]
    if($tb -le 0 -or $tc -lt 0){ $txt += ($g + ' n/d'); continue }
    $q = $tc / [double]$tb
    $cl = ''
    if($k -eq 'B1'){ if($q -ge 0.9){ $cl = 'ALTERNATIVA A (il primo tocco non sposta la frequenza)' } elseif($q -le 0.2){ $cl = 'ALTERNATIVA B (l Azzurra vive di ritocchi)' } elseif($q -ge 0.3 -and $q -le 0.8){ $cl = 'dentro l attesa' } else { $cl = 'fra le bande' } }
    else { if($q -le 1.05){ $cl = 'ALTERNATIVA A (il filtro ordinato non toglie quasi niente)' } elseif($q -ge 2.0){ $cl = 'ALTERNATIVA B (il filtro decide la frequenza)' } elseif($q -le 1.6){ $cl = 'dentro l attesa' } else { $cl = 'fra le bande' } }
    $txt += ($g + ' ' + $tc + '/' + $tb + ' = ' + (F2 $q) + ' ' + $cl)
  }
  W ('  ' + $k + ' (' + $cc[1] + '): ' + ($txt -join ' | '))
}
W ''
W ('LETTURA MECCANICA (categorie congelate in prove/AZZURRA_FREQ_2026-10-10_A_base.txt): ' + $esito)
W 'NON E UN VERDETTO DI MERITO: Modello 1, 9 mesi, un regime. Vietato "morto" (certificato del 09/09: mancano uscita ad asse, gemelli, TF).'
W 'LETTURA OBBLIGATORIA (file madre, P-VEN): VenSera esclude gia gli end of test; chi conta a mano tutte le chiusure del 09/10 dalle 15:39 toglie FineGamba. MagicKo deve essere 0.'
W 'Il verdetto lo scrive la sessione sullo zip.'
($R -join "`r`n") | Set-Content -LiteralPath (Join-Path $OUT 'RIEPILOGO_AZZURRA_FREQ.txt') -Encoding ASCII

# =====================================================================
#  5. ZIP E FILE ATTESI (letti DALLO ZIP)
# =====================================================================
Titolo '5 - ZIP'
$attesi = @('RIEPILOGO_AZZURRA_FREQ.txt', 'ESTRATTO_LOG.txt', ('compile_' + $CompNome + '.log'))
foreach($j in $JOBS){
  $attesi += ('prove/' + $j.P)
  foreach($g in @('IS','OOS')){ $attesi += ('CSV/' + $EA + '_' + $SIMB + '_' + $g + '_ohlc_' + $j.L + '.csv') }
  foreach($c in $j.Celle){ $attesi += ((CartPT $j $c).Replace('\','/') + '/' + (NomePT $c)) }
  $attesi += ('ROUND_' + $j.L + '/REFERTO_ROUND_' + $j.L + '.txt')
}
Compress-Archive -Path (Join-Path $OUT '*') -DestinationPath $ZIP -Force
$nelZip = @()
try{
  Add-Type -AssemblyName System.IO.Compression.FileSystem
  $za = [IO.Compression.ZipFile]::OpenRead($ZIP)
  $nelZip = @($za.Entries | ForEach-Object { $_.FullName.Replace('\','/') })
  $za.Dispose()
} catch { Dico ('zip NON leggibile: ' + $_.Exception.Message) 'Red' }
$manca = @($attesi | Where-Object { $nelZip -notcontains $_ })
Dico ('ZIP PRONTO DA MANDARE: ' + $ZIP + '   (' + $nelZip.Count + ' voci)') 'Green'
Dico ('FILE ATTESI NELLO ZIP: ' + $attesi.Count + ', presenti ' + ($attesi.Count - $manca.Count) + ', MANCANTI ' + $manca.Count) $(if($manca.Count -eq 0){'Green'}else{'Red'})
foreach($m in $manca){ Dico ('   manca: ' + $m) 'Red' }
Dico ('piu LOG_TESTER\ (log del tester e degli agenti scritti dopo l avvio: ' + $nl + ')') 'Gray'
Write-Host ''
Write-Host ('LETTURA MECCANICA: ' + $esito) -ForegroundColor $(if($codice -eq 0){'Green'}else{'Yellow'})
Write-Host ('durata totale minuti: ' + [int](((Get-Date) - $T0).TotalMinutes)) -ForegroundColor Cyan
try{ $Mutex.ReleaseMutex() } catch { }
exit $codice
