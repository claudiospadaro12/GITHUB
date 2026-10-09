# =====================================================================
#  MARCATORE_BULGE_TEL_P0_v1
#  BULGE_TEL_P0.ps1 -- TEST DI ACCETTAZIONE P0 DELLA COPIA DI BANCO
#                      ABTG_Bulge_Telemetria CONTRO ABTG_Bulge v5.20
#
#  CHE COSA FA (09/10/2026):
#   0. guardie: SOLO sul PC di backtest DESKTOP-H4D7CAJ, nessun MT5 o
#      MetaEditor aperto, nessuna installazione MT5 fuori censimento,
#      nessun EA attaccato ai grafici salvati del terminale BCM (demo
#      50503392), un solo giro alla volta (mutex);
#   1. scarica AL PIN la copia, l'include, RIGA_ROUND_VPS.ps1 e i TRE file
#      prova, e ne controlla lo SHA256 (costanti qui sotto, calcolate dal
#      commit); poi COMPILA LA COPIA (prima compilazione vera di questo
#      sorgente): .ex5 vecchio cancellato e dimostrato sparito, si aspetta
#      l'uscita di MetaEditor, log letto in inglese e in italiano (classe
#      1168); se fallisce -> BULGE_TEL_P0_COMPILAZIONE_FALLITA.zip sul
#      Desktop e NESSUN tester (classe 1167);
#   2. tre job IN FILA con il driver dei round GIA' IN USO (RIGA_ROUND_VPS.ps1
#      al pin, SHA 3341756F... = quello di R92BAB, che ha girato il 01/10 su
#      questo PC): ORIG (ABTG_Bulge), TEL1 (copia, InpTelemetria=1), TEL0
#      (copia, InpTelemetria=0). Modello 1, deposito 10000, finestra e input
#      dai file prova. Dopo OGNI job: SHA256 di EA, include, driver e file
#      prova sui byte che hanno girato (classe 166/595: il driver compila
#      dal RAMO lavoro, non dal pin);
#   3. raccoglie: CSV OptResults (IS e OOS) dei tre job; da Common\Files il
#      per-trade e i file di telemetria FRESCHI dei sei magic, UNA CARTELLA
#      PER PASSATA (sim_bulge_viola_uscite.py --controlla vuole un file
#      segnali e un file path per cartella); i log del tester; un estratto
#      delle righe utili (durata di ogni passata 'passed in', righe
#      [BULGE-TEL] dell'agente);
#   4. CONFRONTA A MACCHINA, senza tolleranze: Trades, Profit, Profit
#      Factor, Equity DD % come STRINGHE ESATTE, gamba per gamba e gemella
#      per gemella; per-trade OOS deal per deal; somma di net delle OPENED
#      contro il Profit OOS; SHA256 dei file di telemetria delle due
#      gemelle; dimensione e proiezione alla cella lunga. Stampa la LETTURA
#      MECCANICA con i criteri congelati nel file madre
#      prove/BULGE_TEL_P0_2026-10-09.txt: il verdetto lo scrive la sessione
#      sullo zip, dopo il --controlla offline;
#   5. zip sul Desktop (BULGE_TEL_P0.zip), elenco dei file attesi
#      verificato LEGGENDO LO ZIP.
#
#  COSA NON FA: non tocca conti, ordini, posizioni, preset, sedie, taglie;
#  non chiude nessun processo che TROVA aperto (se trova MT5 o MetaEditor
#  aperti si FERMA). L'UNICA chiusura possibile e' quella del MetaEditor che
#  lo script STESSO ha avviato per la compilazione ($pMe, oggetto del suo
#  Start-Process), e solo se dopo 120 secondi non ha prodotto l'.ex5. Il
#  terminale lo apre e lo chiude il driver dei round (ShutdownTerminal=1).
#  Non svuota la cache del tester; non tocca CODA.txt ne' il runner
#  notturno (VPS).
#  Scrive SOLO: %USERPROFILE%\abtg_bulge_tel_p0, %USERPROFILE%\abtg_round
#  (cartella di lavoro del driver), MQL5\Experts e MQL5\Include del
#  terminale BCM di questa macchina, il Desktop. I file in Common\Files li
#  scrivono gli EA nel tester: qui si COPIANO, non si cancellano.
#
#  UNA SOLA VOLTA CON QUESTI MAGIC: un secondo lancio con gli stessi input
#  pesca le passate dalla cache del tester (tester\cache\*.opt) e NON
#  riscrive per-trade e telemetria; lo script se ne accorge (file NON
#  freschi = NON MISURATO). Per rifarla servono magic nuovi = nuovo pin.
#
#  CODICI D'USCITA: 0 = P0 LEGGIBILE (precondizioni tutte vere; l'esito,
#  qualunque sia, e' nel riepilogo); 3 = NON MISURATO (manca una
#  precondizione: lo zip esce lo stesso); 1 = fermo PRIMA del tester.
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
$SHA_ORIG = 'ED4E88B1CFBA36AD81658935E8920FE31462AE3202DD61C9C50A039ACEF57BBD'   # mql5/Experts/ABTG_Bulge.mq5 v5.20
$SHA_TEL  = '96502AE5FC99EE65E1EF8C8487057E412B081182DCB03F02BBD07B6E15421144'   # mql5/Experts/ABTG_Bulge_Telemetria.mq5 (PASS)
$SHA_INC  = '3EC971152E85E0082488CC4243FF45AE09948C191D52AB96050B48F94641A737'   # mql5/Include/ABTG_PausaGuardian.mqh
$SHA_WF   = '6EFF8E4061EB6E82F88C66673B26B7CF5BFFC1F3AB55F07E3A504EC6E0E027A1'   # backtest_pipeline/walkforward_generico.ps1
$SHA_RRV  = '3341756FB37889DBD6E827A87BAC26893E01C85B6C18343918083B01B4DD3425'   # backtest_pipeline/righe/RIGA_ROUND_VPS.ps1
$SIMB = 'NZDCHF'
$SYMLIST = 'EURGBP,NZDCHF,CADJPY'
$MODELLO = 1
$DEPOSITO = 10000
$GIORNI_OOS = 89          # 2026.04.02 00:00 -> 2026.06.30 00:00
$NCROSS = 3
$JOBS = @(
  [pscustomobject]@{ L='BTP0_ORIG'; EA='ABTG_Bulge';            P='BULGE_TEL_P0_2026-10-09.txt';      HP='09161B67B116CD240E4B800C8DA5379FD4648101E2EC38AF62E5DC7EBC83C57D'; M0='775101'; M1='775151'; Tel='ORIG' },
  [pscustomobject]@{ L='BTP0_TEL1'; EA='ABTG_Bulge_Telemetria'; P='BULGE_TEL_P0_2026-10-09_TEL1.txt'; HP='FD1A37636B550CB6B4FFFE14961737252C133562142DEA94BE91AB7C937EE480'; M0='775111'; M1='775161'; Tel='1' },
  [pscustomobject]@{ L='BTP0_TEL0'; EA='ABTG_Bulge_Telemetria'; P='BULGE_TEL_P0_2026-10-09_TEL0.txt'; HP='2D25A75CD3810D84DB2D00AA83021EFFA36DD7DD448B6B850FDDCCF02191230F'; M0='775121'; M1='775171'; Tel='0' }
)
$SHA_EA = @{}
$SHA_EA['ABTG_Bulge'] = $SHA_ORIG
$SHA_EA['ABTG_Bulge_Telemetria'] = $SHA_TEL
$CAMPI = @('Trades','Profit','Profit Factor','Equity DD %')
$COL_PT = @('close_time','symbol','position_id','deal_type','volume','price','net_profit','signal')

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

# =====================================================================
#  0. MACCHINA, TERMINALE, GRAFICI
# =====================================================================
Titolo '0 - MACCHINA E TERMINALE'
if($env:COMPUTERNAME -ne 'DESKTOP-H4D7CAJ'){
  throw ('BULGE_TEL_P0 gira SOLO sul PC di backtest DESKTOP-H4D7CAJ. Qui la macchina si chiama: ' + $env:COMPUTERNAME + '. Sul VPS VMI3047753 non si lancia (firma del 21/09/2026: i round girano sul PC di backtest).')
}
Dico ('pc  : ' + $env:COMPUTERNAME) 'Green'
Dico ('pin : ' + $Pin) 'Green'
Dico ('data: ' + $T0.ToString('yyyy-MM-dd HH:mm:ss')) 'Green'
$Mutex = New-Object System.Threading.Mutex($false, 'Global\ABTG_BULGE_TEL_P0')
$preso = $false
try{ $preso = $Mutex.WaitOne(0) } catch [System.Threading.AbandonedMutexException] { $preso = $true; Dico 'il blocco Global\ABTG_BULGE_TEL_P0 era stato lasciato da un giro INTERROTTO: lo riprendo' 'Yellow' }
if(-not $preso){ throw 'Un ALTRO giro di BULGE_TEL_P0 sta gia girando su questo PC (mutex occupato). Aspetta che finisca, NON chiudere il suo terminale.' }
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
#  1. SORGENTI AL PIN, FILE PROVA, COMPILAZIONE DELLA COPIA
# =====================================================================
Titolo '1 - SORGENTI AL PIN E COMPILAZIONE DELLA COPIA'
$W = Join-Path $env:USERPROFILE 'abtg_bulge_tel_p0'
New-Item -ItemType Directory -Force -Path $W | Out-Null
$AR = Join-Path $env:USERPROFILE 'abtg_round'
$rrv = Join-Path $W 'RIGA_ROUND_VPS.ps1'
$srcTel = Join-Path $W 'ABTG_Bulge_Telemetria.mq5'
$srcInc = Join-Path $W 'ABTG_PausaGuardian.mqh'
Scarica 'backtest_pipeline/righe/RIGA_ROUND_VPS.ps1' $rrv
Scarica 'mql5/Experts/ABTG_Bulge_Telemetria.mq5' $srcTel
Scarica 'mql5/Include/ABTG_PausaGuardian.mqh' $srcInc
$controlli = @(@($rrv, $SHA_RRV, 'RIGA_ROUND_VPS.ps1'), @($srcTel, $SHA_TEL, 'ABTG_Bulge_Telemetria.mq5'), @($srcInc, $SHA_INC, 'ABTG_PausaGuardian.mqh'))
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
  $tx = Get-Content -LiteralPath $pp
  $mgRiga = @($tx | Where-Object { $_ -like 'InpMagic=*' })
  $slRiga = @($tx | Where-Object { $_ -like 'Symbols_List=*' })
  $teRiga = @($tx | Where-Object { $_ -like 'InpTelemetria=*' })
  if($mgRiga.Count -ne 1 -or $mgRiga[0] -ne ('InpMagic=' + $j.M0 + '||' + $j.M0 + '||50||' + $j.M1 + '||Y')){ throw ($j.P + ': asse InpMagic diverso da ' + $j.M0 + '/' + $j.M1 + '. Non si parte.') }
  if($slRiga.Count -ne 1 -or $slRiga[0] -ne ('Symbols_List=' + $SYMLIST)){ throw ($j.P + ': Symbols_List diversa da ' + $SYMLIST + '. Non si parte.') }
  if($j.Tel -eq 'ORIG'){ if($teRiga.Count -ne 0){ throw ($j.P + ': InpTelemetria nel file dell ORIGINALE (input sconosciuto all EA). Non si parte.') } }
  elseif($teRiga.Count -ne 1 -or $teRiga[0] -ne ('InpTelemetria=' + $j.Tel)){ throw ($j.P + ': InpTelemetria diverso da ' + $j.Tel + '. Non si parte.') }
}
Dico 'file prova: magic, Symbols_List e InpTelemetria come dichiarati nei tre file' 'Green'

# --- la PRIMA compilazione vera della copia (classi 1167, 1168, 1152)
$CompNome = 'ABTG_Bulge_Telemetria'
$mq5Dst = Join-Path $MqlExp ($CompNome + '.mq5')
$ex5 = Join-Path $MqlExp ($CompNome + '.ex5')
$logC = Join-Path $W ('compile_' + $CompNome + '.log')
if(($mq5Dst + $logC) -match '\s'){ throw ('percorso di compilazione con uno SPAZIO (' + $mq5Dst + ' / ' + $logC + '): Start-Process non lo quota (classe 1152). Non si parte.') }
function FermaCompilazione($perche){
  $dskC  = [Environment]::GetFolderPath('Desktop')
  $CartC = Join-Path $dskC 'BULGE_TEL_P0_COMPILAZIONE_FALLITA'
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
    $testaC = @(('BULGE_TEL_P0: COMPILAZIONE DI ' + $CompNome + ' FALLITA. Nessun job lanciato, nessun tester.'), ('motivo: ' + $perche), ('pin: ' + $Pin + '   pc: ' + $env:COMPUTERNAME + '   data: ' + $stC), ('log di MetaEditor presente: ' + $haLog), '', 'righe di errore/avviso del log (il log intero e accanto):')
    (($testaC + $righeLog) -join "`r`n") | Set-Content -LiteralPath (Join-Path $CartC 'COMPILAZIONE_FALLITA.txt') -Encoding ASCII
    Compress-Archive -Path (Join-Path $CartC '*') -DestinationPath $zipC -Force
    Write-Host ('   ZIP DA MANDARE (compilazione fallita): ' + $zipC) -ForegroundColor Red
  } catch { Write-Host ('   zip della compilazione NON creato (' + $_.Exception.Message + '): il log e in ' + $logC) -ForegroundColor Red }
  throw ('COMPILAZIONE FALLITA: ' + $perche + ' Nessun job e partito. Manda lo zip BULGE_TEL_P0_COMPILAZIONE_FALLITA.zip dal Desktop.')
}
Copy-Item -LiteralPath $srcTel -Destination $mq5Dst -Force
Copy-Item -LiteralPath $srcInc -Destination (Join-Path $MqlInc 'ABTG_PausaGuardian.mqh') -Force
if((Sha $mq5Dst) -ne $SHA_TEL){ throw ('la copia messa in ' + $mq5Dst + ' non ha lo SHA256 del commit. Non si parte.') }
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
$OUT = Join-Path $dsk 'BULGE_TEL_P0'
$ZIP = Join-Path $dsk 'BULGE_TEL_P0.zip'
$stampa = $T0.ToString('yyyyMMdd_HHmmss')
if(Test-Path -LiteralPath $OUT){ Move-Item -LiteralPath $OUT -Destination ($OUT + '_VECCHIA_' + $stampa) -Force; Dico ('cartella di un giro PRECEDENTE rinominata: BULGE_TEL_P0_VECCHIA_' + $stampa) 'Yellow' }
if(Test-Path -LiteralPath $ZIP){ Move-Item -LiteralPath $ZIP -Destination (Join-Path $dsk ('BULGE_TEL_P0_VECCHIO_' + $stampa + '.zip')) -Force; Dico 'zip di un giro PRECEDENTE rinominato con la data' 'Yellow' }
New-Item -ItemType Directory -Force -Path $OUT, (Join-Path $OUT 'CSV'), (Join-Path $OUT 'PASSATE'), (Join-Path $OUT 'LOG_TESTER'), (Join-Path $OUT 'prove') | Out-Null
foreach($j in $JOBS){ Copy-Item -LiteralPath (Join-Path $W $j.P) -Destination (Join-Path $OUT 'prove') -Force }
if(Test-Path -LiteralPath $logC){ Copy-Item -LiteralPath $logC -Destination $OUT -Force }
foreach($j in $JOBS){
  foreach($vv in @((Join-Path $dsk ('ROUND_' + $j.L)), (Join-Path $dsk ('ROUND_' + $j.L + '.zip')))){
    if(Test-Path -LiteralPath $vv){ Remove-Item -LiteralPath $vv -Recurse -Force -ErrorAction SilentlyContinue; Dico ('tolta una raccolta PRECEDENTE del driver: ' + (Split-Path -Leaf $vv)) 'DarkYellow' }
  }
}

$ErrorActionPreference = 'Continue'
$STATO = @{}
foreach($j in $JOBS){
  $st = [pscustomobject]@{ Lanciato=$false; Rc=-99; Dur=0.0; TIni=$null; Motore=@(); CsvIS=$null; CsvOOS=$null; Righe=@{}; File=@{}; Note=@() }
  $STATO[$j.L] = $st
  $minAvv = ((Get-Date) - $T0).TotalMinutes
  if($minAvv -ge $TettoMin){
    $st.Note += ('NON LANCIATO: tetto di avvio di ' + $TettoMin + ' minuti superato (minuto ' + [int]$minAvv + ')')
    Write-Host ('=== ' + $j.L + ': NON LANCIATO (tetto ' + $TettoMin + ' min) ===') -ForegroundColor Red
    continue
  }
  $nAtt = 0
  while((@(Get-Process -Name terminal64 -ErrorAction SilentlyContinue)).Count -gt 0 -and $nAtt -lt 36){ Start-Sleep -Seconds 5; $nAtt = $nAtt + 1 }
  Titolo ('2 - JOB ' + $j.L + '   ' + $j.EA + '   ' + $j.P + '   magic ' + $j.M0 + '/' + $j.M1 + '   (minuti dall avvio ' + [int]$minAvv + ', tetto di avvio ' + $TettoMin + ')')
  $st.Lanciato = $true
  $tIniJob = Get-Date
  $st.TIni = $tIniJob
  & powershell.exe -NoProfile -ExecutionPolicy Bypass -File $rrv -Expert $j.EA -Prova $j.P -Etichetta $j.L -Pin $Pin -Modello $MODELLO -Deposito $DEPOSITO
  $st.Rc = $LASTEXITCODE
  $st.Dur = ((Get-Date) - $tIniJob).TotalSeconds
  Dico ('durata del job ' + $j.L + ': ' + [int]$st.Dur + ' s (driver compreso)   rc ' + $st.Rc) 'Gray'
  # --- classe 166/595: i byte che hanno GIRATO (non il pin)
  $mot = @()
  $chk = @(@((Join-Path $AR ('src_prove\' + $j.EA + '.mq5')), $SHA_EA[$j.EA], ($j.EA + '.mq5')), @((Join-Path $AR 'src_include\ABTG_PausaGuardian.mqh'), $SHA_INC, 'ABTG_PausaGuardian.mqh'), @((Join-Path $AR 'walkforward_generico.ps1'), $SHA_WF, 'walkforward_generico.ps1'), @((Join-Path $AR ('prove\' + $j.P)), $j.HP, $j.P))
  foreach($c in $chk){
    $h = Sha $c[0]
    if($h -ne $c[1]){ $mot += ($c[2] + ' ' + $(if($h -eq 'ASSENTE'){'ASSENTE'}else{'SHA256 DIVERSO DAL COMMIT (' + $h.Substring(0,12) + ')'})) }
  }
  $st.Motore = $mot
  if($mot.Count -eq 0){ Dico 'motore = commit (SHA256 di EA, include, driver e file prova sui byte che hanno girato)' 'Green' } else { Dico ('MOTORE DIVERSO DAL COMMIT: ' + ($mot -join ', ')) 'Red' }
  # --- i due CSV OptResults
  foreach($g in @('IS','OOS')){
    $cp = Join-Path $AR ('risultati_prove\' + $j.EA + '\' + $j.EA + '_' + $SIMB + '_' + $g + '_ohlc_' + $j.L + '.csv')
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
  # --- per-trade e telemetria dei due magic, una cartella per passata
  foreach($mg in @($j.M0, $j.M1)){
    $dPass = Join-Path $OUT ('PASSATE\' + $j.L + '_' + $mg)
    New-Item -ItemType Directory -Force -Path $dPass | Out-Null
    $fi = @{}
    $nomi = @{ PT = ('abtg_trades_' + $j.EA + '_' + $SIMB + '_' + $mg + '_violaEA.csv'); SEG = ('abtg_tel_segnali_' + $j.EA + '_' + $SIMB + '_' + $mg + '.csv'); PATH = ('abtg_tel_path_' + $j.EA + '_' + $SIMB + '_' + $mg + '.csv') }
    foreach($k in @('PT','SEG','PATH')){
      $src = Join-Path $CF $nomi[$k]
      $e = [pscustomobject]@{ Nome=$nomi[$k]; Stato='ASSENTE'; Byte=0; Copia='' }
      if(Test-Path -LiteralPath $src){
        $it = Get-Item -LiteralPath $src
        if($it.LastWriteTime -lt $tIniJob){ $e.Stato = 'VECCHIO' }
        else {
          $e.Stato = 'FRESCO'; $e.Byte = $it.Length
          $e.Copia = Join-Path $dPass $nomi[$k]
          Copy-Item -LiteralPath $src -Destination $e.Copia -Force
        }
      }
      $fi[$k] = $e
    }
    $st.File[$mg] = $fi
    Dico ('magic ' + $mg + ': per-trade ' + $fi['PT'].Stato + ', telemetria segnali ' + $fi['SEG'].Stato + ' (' + $fi['SEG'].Byte + ' byte), path ' + $fi['PATH'].Stato + ' (' + $fi['PATH'].Byte + ' byte)') 'Gray'
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
    if($ln -match 'passed in|BULGE-TEL|BULGE-CONTA|\[BULGE\] Init|optimize Experts|Experts\\ABTG_Bulge|OnTesterInit|cannot be initialized|new records saved|passes processed|shortest pass|testing of'){
      [void]$estr.Add($nomeL + ' | ' + $ln.Trim())
    }
  }
}
($estr -join "`r`n") | Set-Content -LiteralPath (Join-Path $OUT 'ESTRATTO_LOG.txt') -Encoding ASCII
Dico ('log copiati: ' + $nl + '   righe nell estratto (passed in, BULGE-TEL, ...): ' + $estr.Count) 'Gray'

# =====================================================================
#  4. IL CONFRONTO, A MACCHINA (criteri congelati nel file madre)
# =====================================================================
Titolo '4 - CONFRONTO P0'
$R = New-Object System.Collections.ArrayList
function W($t){ [void]$R.Add($t); Write-Host ('   ' + $t) }
$pre = New-Object System.Collections.ArrayList
# indice: $X[L][g][magic] = riga
$X = @{}
foreach($j in $JOBS){
  $st = $STATO[$j.L]
  $X[$j.L] = @{ IS=@{}; OOS=@{} }
  if(-not $st.Lanciato){ [void]$pre.Add('p1 ' + $j.L + ' non lanciato'); continue }
  if($st.Motore.Count -gt 0){ [void]$pre.Add('p2 ' + $j.L + ' motore diverso dal commit: ' + ($st.Motore -join ', ')) }
  foreach($g in @('IS','OOS')){
    $info = $(if($g -eq 'IS'){ $st.CsvIS } else { $st.CsvOOS })
    if(-not $info.Fresco){ [void]$pre.Add('p1 ' + $j.L + ' CSV ' + $g + ' ' + $info.Txt); continue }
    if($info.Righe.Count -ne 2){ [void]$pre.Add('p1 ' + $j.L + ' CSV ' + $g + ' ha ' + $info.Righe.Count + ' righe (attese 2)') }
    foreach($rw in $info.Righe){
      $mg = ('' + $rw.InpMagic).Trim()
      if($mg -ne $j.M0 -and $mg -ne $j.M1){ [void]$pre.Add('p3 ' + $j.L + ' ' + $g + ' riga con InpMagic ' + $mg + ' (attesi ' + $j.M0 + '/' + $j.M1 + ')'); continue }
      $X[$j.L][$g][$mg] = $rw
      $tr = ('' + $rw.Trades).Trim()
      if($tr -notmatch '^[1-9][0-9]*$'){ [void]$pre.Add('p1 ' + $j.L + ' ' + $g + ' magic ' + $mg + ' Trades=' + $tr + ' (Trades=0 non vuol dire identico: vuol dire NON GIRATA)') }
      $sl = ('' + $rw.Symbols_List).Trim()
      if($sl -ne $SYMLIST){ [void]$pre.Add('p3 ' + $j.L + ' ' + $g + ' Symbols_List nel CSV = ' + $sl + ' (attesa ' + $SYMLIST + ')') }
      if($j.Tel -ne 'ORIG'){
        $tv = ('' + $rw.InpTelemetria).Trim().ToLower()
        $atteso = $(if($j.Tel -eq '1'){ @('1','true') } else { @('0','false') })
        if($atteso -notcontains $tv){ [void]$pre.Add('p3 ' + $j.L + ' ' + $g + ' InpTelemetria nel CSV = "' + $tv + '" (atteso ' + $j.Tel + '): il pin NON e arrivato') }
      }
    }
    foreach($mg in @($j.M0, $j.M1)){ if(-not $X[$j.L][$g].ContainsKey($mg)){ [void]$pre.Add('p1 ' + $j.L + ' ' + $g + ' manca la riga del magic ' + $mg) } }
  }
  foreach($mg in @($j.M0, $j.M1)){
    $fi = $st.File[$mg]
    if($null -eq $fi){ continue }
    if($fi['PT'].Stato -ne 'FRESCO'){ [void]$pre.Add('p5 ' + $j.L + ' per-trade del magic ' + $mg + ' ' + $fi['PT'].Stato) }
    if($j.Tel -eq '1'){
      foreach($k in @('SEG','PATH')){ if($fi[$k].Stato -ne 'FRESCO'){ [void]$pre.Add('p4 ' + $j.L + ' telemetria ' + $k + ' del magic ' + $mg + ' ' + $fi[$k].Stato + ': la telemetria NON risulta accesa, il P0 non proverebbe niente') } }
    }
    if($j.Tel -eq '0'){
      foreach($k in @('SEG','PATH')){ if($fi[$k].Stato -eq 'FRESCO'){ [void]$pre.Add('p4 ' + $j.L + ' telemetria ' + $k + ' FRESCA per il magic ' + $mg + ' con InpTelemetria=0: lo spento SCRIVE (pin non arrivato o cancello rotto)') } }
    }
  }
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
function Diff4($a, $b){
  if($null -eq $a -or $null -eq $b){ return 'riga mancante' }
  $d = @()
  foreach($c in $CAMPI){ $va = ('' + $a.$c).Trim(); $vb = ('' + $b.$c).Trim(); if($va -ne $vb){ $d += ($c + ' ' + $va + ' -> ' + $vb) } }
  if($d.Count -eq 0){ return 'IDENTICHE' }
  return ($d -join '; ')
}
$JO = $JOBS[0]; $JT1 = $JOBS[1]; $JT0 = $JOBS[2]
W ('BULGE_TEL_P0 -- pin ' + $Pin + ' -- data ' + $T0.ToString('yyyy-MM-dd HH:mm:ss') + ' -- pc ' + $env:COMPUTERNAME)
W ('job: ' + (($JOBS | ForEach-Object { $_.L + ' ' + [int]$STATO[$_.L].Dur + ' s rc ' + $STATO[$_.L].Rc }) -join ' | '))
W ('compilazione della copia: ' + $compErr + ' errori, ' + $compWarn + ' avvisi (-1 = riga non letta)')
W ''
W 'RIGHE OptResults (k=0 = primo magic, k=1 = secondo):'
foreach($g in @('IS','OOS')){
  foreach($kk in @(0,1)){
    foreach($j in $JOBS){
      $mg = $(if($kk -eq 0){ $j.M0 } else { $j.M1 })
      W ('  ' + $g.PadRight(3) + ' k=' + $kk + ' ' + $j.L.PadRight(10) + ' magic ' + $mg + ' : ' + (Riga4 $X[$j.L][$g][$mg]))
    }
  }
}
W ''
W 'CONFRONTO CON L ORIGINALE (stringhe esatte, nessuna tolleranza):'
$esD = @{}
foreach($tj in @($JT1, $JT0)){
  foreach($g in @('IS','OOS')){
    $o0 = $X[$JO.L][$g][$JO.M0]; $o1 = $X[$JO.L][$g][$JO.M1]
    $c0 = $X[$tj.L][$g][$tj.M0]; $c1 = $X[$tj.L][$g][$tj.M1]
    $dir = ((Uguali $c0 $o0) -and (Uguali $c1 $o1))
    $scb = ((-not $dir) -and (Uguali $c0 $o1) -and (Uguali $c1 $o0))
    $esD[$tj.L + '_' + $g] = $(if($dir){'DIRETTO'}elseif($scb){'SCAMBIO'}else{'DIVERSO'})
    W ('  ' + $tj.L + ' ' + $g + ': k=0 ' + (Diff4 $o0 $c0) + '   ||   k=1 ' + (Diff4 $o1 $c1) + '   => ' + $esD[$tj.L + '_' + $g])
  }
}
W ''
W 'GEMELLE DELLO STESSO EA (R92BAB: in IS differivano di 0,02-0,06 in Profit; NON e un difetto della copia, si scrive):'
foreach($j in $JOBS){ foreach($g in @('IS','OOS')){ W ('  ' + $j.L + ' ' + $g + ': ' + (Diff4 $X[$j.L][$g][$j.M0] $X[$j.L][$g][$j.M1])) } }
W ''
# --- per-trade OOS deal per deal (la gamba OOS e l ultima a scrivere il file del magic)
function LeggiPT($p){ if([string]::IsNullOrEmpty($p) -or -not (Test-Path -LiteralPath $p)){ return $null }; try{ return @(Import-Csv -LiteralPath $p -Delimiter ';') } catch { return $null } }
function ConfrontaPT($pa, $pb){
  $a = LeggiPT $pa; $b = LeggiPT $pb
  if($null -eq $a -or $null -eq $b){ return [pscustomobject]@{ Ok=$false; Txt='file mancante o illeggibile' } }
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
W 'PER-TRADE (abtg_trades_*, ultima gamba scritta = OOS) CONTRO L ORIGINALE:'
$ptOk = @{}
foreach($tj in @($JT1, $JT0)){
  foreach($kk in @(0,1)){
    $mo = $(if($kk -eq 0){ $JO.M0 } else { $JO.M1 }); $mc = $(if($kk -eq 0){ $tj.M0 } else { $tj.M1 })
    $fo = $STATO[$JO.L].File[$mo]; $fc = $STATO[$tj.L].File[$mc]
    $po = $(if($null -ne $fo){ $fo['PT'].Copia } else { '' }); $pc = $(if($null -ne $fc){ $fc['PT'].Copia } else { '' })
    $cr = ConfrontaPT $po $pc
    $ptOk[$tj.L + '_' + $kk] = $cr.Ok
    W ('  ' + $tj.L + ' k=' + $kk + ' (' + $mo + ' / ' + $mc + '): ' + $cr.Txt)
  }
}
W ''
# --- telemetria di TEL1: dimensione, invariante 2, gemelle, proiezione
W 'TELEMETRIA DI TEL1 (gamba OOS, una cartella per passata in PASSATE\):'
$telSha = @{}
foreach($mg in @($JT1.M0, $JT1.M1)){
  $fi = $STATO[$JT1.L].File[$mg]
  if($null -eq $fi -or $fi['SEG'].Stato -ne 'FRESCO' -or $fi['PATH'].Stato -ne 'FRESCO'){ W ('  magic ' + $mg + ': file di telemetria non freschi o assenti'); continue }
  $seg = @()
  try{ $seg = @(Import-Csv -LiteralPath $fi['SEG'].Copia -Delimiter ';') } catch { $seg = @() }
  $nOp = 0; $sNet = 0.0; $nNetKo = 0; $esiti = @{}
  foreach($s in $seg){
    $oc = ('' + $s.outcome).Trim()
    if($esiti.ContainsKey($oc)){ $esiti[$oc] = $esiti[$oc] + 1 } else { $esiti[$oc] = 1 }
    if($oc -eq 'OPENED'){ $nOp = $nOp + 1; if(NumOk $s.net){ $sNet = $sNet + (Num $s.net) } else { $nNetKo = $nNetKo + 1 } }
  }
  $nPath = 0; $sid = @{}
  $fs = $null
  try{
    $fs = [IO.File]::Open($fi['PATH'].Copia, [IO.FileMode]::Open, [IO.FileAccess]::Read, [IO.FileShare]::ReadWrite)
    $sr = New-Object IO.StreamReader($fs, [Text.Encoding]::ASCII)
    [void]$sr.ReadLine()
    while($true){ $ln = $sr.ReadLine(); if($null -eq $ln){ break }; if($ln.Trim() -eq ''){ continue }; $nPath = $nPath + 1; $sid[$ln.Split(';')[0]] = $true }
  } catch { $nPath = -1 } finally { if($null -ne $fs){ $fs.Close() } }
  $pOOS = $X[$JT1.L]['OOS'][$mg]
  $txP = 'n/d'
  if($null -ne $pOOS -and (NumOk $pOOS.Profit)){ $txP = ('Profit OOS ' + ('' + $pOOS.Profit).Trim() + ', scarto ' + (F2 ($sNet - (Num $pOOS.Profit)))) }
  $bPath = $fi['PATH'].Byte
  $perSeg = $(if($seg.Count -gt 0){ [Math]::Round($nPath / [double]$seg.Count, 1) } else { 0 })
  $bRiga = $(if($nPath -gt 0){ [Math]::Round($bPath / [double]$nPath, 1) } else { 0 })
  $prOOS = $bPath / ($NCROSS * [double]$GIORNI_OOS) * 15 * 1641 / 1MB
  $prIS  = $bPath / ($NCROSS * [double]$GIORNI_OOS) * 15 * 4382 / 1MB
  W ('  magic ' + $mg + ': segnali ' + $seg.Count + ' (' + ((@($esiti.Keys | Sort-Object | ForEach-Object { $_ + ' ' + $esiti[$_] })) -join ', ') + ')')
  W ('     OPENED ' + $nOp + ', somma net ' + (F2 $sNet) + ' (net illeggibili ' + $nNetKo + ') contro ' + $txP + '   [invariante 2, atteso scarto < 0.01]')
  W ('     file segnali ' + $fi['SEG'].Byte + ' byte; file path ' + $bPath + ' byte, ' + $nPath + ' righe, sig_id distinti ' + $sid.Count + ', ' + $perSeg + ' righe per segnale (attese ~297), ' + $bRiga + ' byte per riga')
  W ('     proiezione [DERIVATA, lineare in cross e giorni] alla cella lunga (15 cross): file path gamba OOS 1641 g ~' + [int]$prOOS + ' MB, gamba IS 4382 g ~' + [int]$prIS + ' MB')
  $telSha[$mg] = ((Sha $fi['SEG'].Copia) + '/' + (Sha $fi['PATH'].Copia))
}
if($telSha.Count -eq 2){ W ('  gemelle TEL1 ' + $JT1.M0 + ' / ' + $JT1.M1 + ': file di telemetria ' + $(if($telSha[$JT1.M0] -eq $telSha[$JT1.M1]){'IDENTICI (SHA256)'}else{'DIVERSI (SHA256): la telemetria NON e deterministica fra due passate uguali, si scrive'})) }
W ('  TEL0: file di telemetria freschi per ' + $JT0.M0 + '/' + $JT0.M1 + ': ' + (@($JT0.M0, $JT0.M1 | ForEach-Object { $f = $STATO[$JT0.L].File[$_]; if($null -eq $f){ 'n/d' } else { $f['SEG'].Stato + '/' + $f['PATH'].Stato } }) -join ' , ') + '   (atteso ASSENTE o VECCHIO: spento = nessuna scrittura)')
W ''
# --- la LETTURA MECCANICA
$minTr = 999999
foreach($j in $JOBS){ foreach($g in @('IS','OOS')){ foreach($mg in @($j.M0, $j.M1)){ $rw = $X[$j.L][$g][$mg]; if($null -ne $rw -and (NumOk $rw.Trades)){ $v = [int](Num $rw.Trades); if($v -lt $minTr){ $minTr = $v } } } } }
$esito = ''
if($pre.Count -gt 0){
  $esito = 'NON MISURATO'
  W 'PRECONDIZIONI MANCANTI (il P0 NON si legge, ne identico ne rotto):'
  foreach($p in $pre){ W ('  - ' + $p) }
} else {
  W 'PRECONDIZIONI p1-p5: tutte vere (3 job, 12 passate, motore = commit, input arrivati, telemetria accesa in TEL1 e spenta in TEL0, per-trade freschi)'
  $ok0 = ($esD[$JT0.L + '_OOS'] -eq 'DIRETTO') -and ($esD[$JT0.L + '_IS'] -ne 'DIVERSO') -and $ptOk[$JT0.L + '_0'] -and $ptOk[$JT0.L + '_1']
  $ok1 = ($esD[$JT1.L + '_OOS'] -eq 'DIRETTO') -and ($esD[$JT1.L + '_IS'] -ne 'DIVERSO') -and $ptOk[$JT1.L + '_0'] -and $ptOk[$JT1.L + '_1']
  if(-not $ok0){ $esito = 'COPIA ROTTA ANCHE SPENTA' }
  elseif(-not $ok1){ $esito = 'COPIA ROTTA ACCESA' }
  else {
    $esito = 'P0 PASSA'
    if($esD[$JT1.L + '_IS'] -eq 'SCAMBIO' -or $esD[$JT0.L + '_IS'] -eq 'SCAMBIO'){ $esito = $esito + ' (IS IDENTICA A MENO DELLO SCAMBIO DI GEMELLA)' }
    if($minTr -lt 10){ $esito = $esito + ' -- DEBOLE (una gamba con Trades ' + $minTr + ' < 10)' }
  }
}
W ''
W ('LETTURA MECCANICA (criteri congelati in prove/BULGE_TEL_P0_2026-10-09.txt): ' + $esito)
W 'Il verdetto lo scrive la sessione sullo zip, dopo sim_bulge_viola_uscite.py --controlla su PASSATE\BTP0_TEL1_775111 e PASSATE\BTP0_TEL1_775161.'
($R -join "`r`n") | Set-Content -LiteralPath (Join-Path $OUT 'RIEPILOGO_BULGE_TEL_P0.txt') -Encoding ASCII

# =====================================================================
#  5. ZIP E FILE ATTESI (letti DALLO ZIP)
# =====================================================================
Titolo '5 - ZIP'
$attesi = @('RIEPILOGO_BULGE_TEL_P0.txt', 'ESTRATTO_LOG.txt', ('compile_' + $CompNome + '.log'))
foreach($j in $JOBS){
  $attesi += ('prove/' + $j.P)
  foreach($g in @('IS','OOS')){ $attesi += ('CSV/' + $j.EA + '_' + $SIMB + '_' + $g + '_ohlc_' + $j.L + '.csv') }
  foreach($mg in @($j.M0, $j.M1)){
    $attesi += ('PASSATE/' + $j.L + '_' + $mg + '/abtg_trades_' + $j.EA + '_' + $SIMB + '_' + $mg + '_violaEA.csv')
    if($j.Tel -eq '1'){
      $attesi += ('PASSATE/' + $j.L + '_' + $mg + '/abtg_tel_segnali_' + $j.EA + '_' + $SIMB + '_' + $mg + '.csv')
      $attesi += ('PASSATE/' + $j.L + '_' + $mg + '/abtg_tel_path_' + $j.EA + '_' + $SIMB + '_' + $mg + '.csv')
    }
  }
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
Write-Host ('LETTURA MECCANICA: ' + $esito) -ForegroundColor $(if($esito -like 'P0 PASSA*'){'Green'}elseif($esito -eq 'NON MISURATO'){'Yellow'}else{'Red'})
Write-Host ('durata totale minuti: ' + [int](((Get-Date) - $T0).TotalMinutes)) -ForegroundColor Cyan
try{ $Mutex.ReleaseMutex() } catch { }
if($pre.Count -gt 0){ exit 3 }
exit 0
