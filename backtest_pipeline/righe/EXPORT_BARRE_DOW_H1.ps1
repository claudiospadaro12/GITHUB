# =====================================================================
#  MARCATORE_EXPORT_BARRE_DOW_H1_v1
#  EXPORT_BARRE_DOW_H1.ps1 -- esporta le barre H1 di U30USD (Dow, feed BCM) dallo Strategy Tester in un CSV sul Desktop.
#
#  CHE COSA FA, e una cosa sola:
#    UNA passata singola del tester (Optimization=0, Model=1 = 1 minuto OHLC, Visual=0, AllowLiveTrading=false) con
#    l'EA CLAU12_EXPORT_BARRE_H1, che NON contiene nessuna funzione d'ordine e scrive le barre H1 CHIUSE in
#    Common\Files\CLAU12_EXPORT_BARRE_H1_U30USD_<run>.csv. Poi COPIA quel CSV (senza cancellarlo) sul Desktop, con le
#    righe del giornale, il .ini usato e il log di compilazione, e fa lo zip. NON giudica la serie: il collaudo e'
#    backtest_pipeline/collaudo_export_barre_h1.py, e si gira quando lo zip torna.
#
#  PERCHE' IL TESTER E NON UNO SCRIPT SU UN GRAFICO: il terminale di questo PC e' loggato sul demo 50503392 (lo stesso
#  numero del piccolo del VPS) e il 14/08/2026 da questa macchina sono partiti ordini VERI. Nel tester il conto e'
#  virtuale, l'EA rifiuta l'avvio fuori dal tester, in ottimizzazione e in visuale, e nessun grafico si apre.
#  PERCHE' NON I FILE .hcc/.hc: formato proprietario non documentato, e il 17/08 il disco ha gia' mentito sulla
#  profondita' (il "2010" era il tetto delle 100.000 barre, non il broker: REFERTO_SONDA_STORICO_17-08.md par. 3-bis).
#
#  DERIVATO da NATCLA_F1_M30_PASSATE.ps1 (passato dal cancello): stesse guardie di macchina, mutex, terminale BCM
#  risolto per origin.txt, installazioni censite il 05/10 ammesse PER NOME, nessun EA sui grafici salvati, SHA256 dei
#  file al pin passati dalla riga e ricontrollati, compilazione = .ex5 NUOVO + log letto in inglese e italiano,
#  CloseMainWindow e MAI Stop-Process, cartella e zip esistenti RINOMINATI con la data, numeri con InvariantCulture.
#  DEVIAZIONI CONTATE dalla madre:
#   D1. una sola passata, nessun file prova (non c'e' un merito da misurare): il .ini e' un file del repo al pin
#       (EXPORT_BARRE_DOW_H1.ini) con DUE soli segnaposto, @@DATA_A@@ e @@RUN@@; le righe ';' si tolgono.
#   D2. MAI sovrascrittura in MQL5\Experts: un CLAU12_EXPORT_BARRE_H1.mq5/.ex5 gia' presente e DIVERSO si SPOSTA nella
#       cartella di lavoro con la data (la madre faceva Copy -Force e Remove-Item del vecchio .ex5).
#   D3. controllo STATICO del sorgente al pin: se contiene una funzione d'ordine, un magic o una lettura del conto,
#       non si compila (OrderSend, CTrade, Trade.mqh, PositionOpen, OrderSendAsync, InpMagic, AccountInfo, ACCOUNT_LOGIN,
#       TradeExporter).
#   D4. mutex proprio Global\CLAU12_EXPORT_BARRE; ci si ferma se e' vivo uno dei blocchi elencati per nome:
#       Global\ABTG_NATCLA_F0, Global\ABTG_NATCLA_F1, Global\ABTG_GBA_R0, Global\ABTG_BULGE_TEL_P0, Global\ABTG_AZZURRA_FREQ.
#   D5. nessun report .htm (non serve: non c'e' un PF da leggere).
#
#  NON TOCCA, per nome: PRIMA SU QUESTO PC le installazioni C:\MT5_Backtest (cartella dati 04C7A32B) e
#  C:\FundedNext_Manuale (cartella dati 2B8180C3); POI il VPS VMI3047753 e TUTTE le sue cartelle dati (FTMO in C:\FTMO,
#  trial 1514806751, REALE 10105439 in C:\BCM_Reale, 100k 50504263, piccolo 50503392 sul VPS, manuale 50503635 in
#  C:\MT5_MANUALE, banco 50504400 in C:\MT5_Backtest, Pepperstone, Tickmill). Scrive SOLO: %USERPROFILE%\abtg_export_barre
#  (file al pin, .ini, log, vecchi file spostati), MQL5\Experts del terminale BCM di questa macchina (il .mq5 e il .ex5
#  dell'EA), il CSV che l'EA scrive in Common\Files (nome nuovo a ogni corsa, mai sovrascritto), il Desktop (cartella e
#  zip EXPORT_BARRE_DOW_H1). NON legge ne' scrive conti, ordini, posizioni, preset. NON tocca CODA.txt ne' il runner.
#
#  NIENTE EMOJI QUI DENTRO (regola del 17/08): Windows PowerShell 5.1 legge i .ps1 come ANSI.
# =====================================================================
[CmdletBinding()]
param(
  [Parameter(Mandatory=$true)][string]$Pin,
  [Parameter(Mandatory=$true)][string]$ShaEA,
  [Parameter(Mandatory=$true)][string]$ShaIni,
  [int]$TimeoutRunMin = 20
)

$ErrorActionPreference = 'Stop'
$IC = [Globalization.CultureInfo]::InvariantCulture
[Threading.Thread]::CurrentThread.CurrentCulture   = $IC
[Threading.Thread]::CurrentThread.CurrentUICulture = $IC
[Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12

$EXPERT  = 'CLAU12_EXPORT_BARRE_H1'
$INI     = 'EXPORT_BARRE_DOW_H1.ini'
$SIMBOLO = 'U30USD'
$VER_EA  = '1.00'
$NOME_D  = 'EXPORT_BARRE_DOW_H1'
if($Pin -notmatch '^[0-9a-fA-F]{40}$'){ throw '-Pin obbligatorio e di 40 caratteri esadecimali: senza, girerebbe la punta del branch spacciandola per un commit congelato.' }
$Pin = $Pin.ToLower()
foreach($hx in @($ShaEA, $ShaIni)){ if($hx -notmatch '^[0-9a-fA-F]{64}$'){ throw '-ShaEA e -ShaIni devono essere di 64 caratteri esadecimali (SHA256 calcolato dal commit, mai dal disco).' } }
$ShaEA = $ShaEA.ToUpper(); $ShaIni = $ShaIni.ToUpper()
if($TimeoutRunMin -lt 1 -or $TimeoutRunMin -gt 60){ throw '-TimeoutRunMin fuori da 1-60 minuti.' }
$RAW = 'https://raw.githubusercontent.com/claudiospadaro12/GITHUB/' + $Pin + '/'

function Dico($t,$c='Gray'){ Write-Host ('   ' + $t) -ForegroundColor $c }
function Titolo($t){ Write-Host ''; Write-Host ('=== ' + $t + ' ===') -ForegroundColor Cyan }
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

# ---------------------------------------------------------------------
#  0. LA MACCHINA E IL TERMINALE. Fail-closed, come NATCLA_F1.
# ---------------------------------------------------------------------
Titolo '0 - MACCHINA E TERMINALE'
if($env:COMPUTERNAME -ne 'DESKTOP-H4D7CAJ'){
  throw ('EXPORT_BARRE_DOW_H1 gira SOLO sul PC di backtest DESKTOP-H4D7CAJ. Qui la macchina si chiama: ' + $env:COMPUTERNAME + '. Sul VPS VMI3047753 non si lancia: firma del 21/09/2026 (i giri del tester stanno sul PC di backtest).')
}
Dico ('pc   : ' + $env:COMPUTERNAME) 'Green'
Dico ('pin  : ' + $Pin) 'Green'
foreach($altro in @('Global\ABTG_NATCLA_F0', 'Global\ABTG_NATCLA_F1', 'Global\ABTG_GBA_R0', 'Global\ABTG_BULGE_TEL_P0', 'Global\ABTG_AZZURRA_FREQ')){
  $mx = $null
  if([System.Threading.Mutex]::TryOpenExisting($altro, [ref]$mx)){
    try{ $mx.Dispose() }catch{ }
    throw ('Un giro che tiene il blocco ' + $altro + ' e VIVO su questo PC: un solo giro di tester alla volta (classe 853). Aspetta la sua riga finale con rc, NON chiudere il suo terminale.')
  }
}
$Mutex = New-Object System.Threading.Mutex($false, 'Global\CLAU12_EXPORT_BARRE')
$preso = $false
try{ $preso = $Mutex.WaitOne(0) } catch [System.Threading.AbandonedMutexException] { $preso = $true; Dico 'il blocco Global\CLAU12_EXPORT_BARRE era stato lasciato da un giro INTERROTTO: lo riprendo' 'Yellow' }
if(-not $preso){ throw 'Un ALTRO export delle barre sta gia girando su questo PC (mutex Global\CLAU12_EXPORT_BARRE occupato). Aspetta la sua riga finale con rc.' }
$aperti = @(Get-Process -Name terminal64, metaeditor64, metatester64 -ErrorAction SilentlyContinue)
if($aperti.Count -gt 0){
  $aperti | Select-Object Id, MainWindowTitle, Path | Format-Table -AutoSize | Out-String -Width 300 | Write-Host
  throw 'MT5, METAEDITOR o un AGENTE DEL TESTER risulta APERTO su questo PC (elenco qui sopra). Se sta lavorando NON chiuderlo: aspetta la sua riga finale con rc. Se e un MT5 aperto a vuoto, chiudilo A MANO e rilancia.'
}

$InstAttesa = 'C:\Program Files\BCM Markets MT5 Terminal'
$Terminal   = Join-Path $InstAttesa 'terminal64.exe'
$MetaEditor = Join-Path $InstAttesa 'metaeditor64.exe'
if(-not (Test-Path -LiteralPath $Terminal)){ throw ('terminale non trovato dove lo aspetto: ' + $Terminal + '. Non si cerca altrove apposta.') }
if(-not (Test-Path -LiteralPath $MetaEditor)){ throw ('MetaEditor non trovato: ' + $MetaEditor) }
$DataRoot = Join-Path $env:APPDATA 'MetaQuotes\Terminal'
$origini = @()
foreach($d in @(Get-ChildItem -Path $DataRoot -Directory -ErrorAction SilentlyContinue)){
  $o = Join-Path $d.FullName 'origin.txt'
  if(Test-Path -LiteralPath $o){
    $v = (Leggi-Condiviso $o).Trim()
    if($v -ne ''){ $origini = $origini + @([pscustomobject]@{ Dir = $d.FullName; Inst = $v }) }
  }
}
# le ALTRE installazioni di questo PC, censite il 05/10/2026 (risultati_archivio/DUKA_P0_20261005_171046/REFERTO_DUKA_P0.txt, sez. 5): AMMESSE PER NOME, chiuse, non toccate
$Censite = @('C:\MT5_Backtest', 'C:\FundedNext_Manuale')
$diversi = @($origini | Where-Object { $_.Inst -ne $InstAttesa })
$ignote = @($diversi | Where-Object { $Censite -notcontains $_.Inst.TrimEnd('\') })
foreach($dv in @($diversi | Where-Object { $Censite -contains $_.Inst.TrimEnd('\') })){ Dico ('altra installazione di questo PC, censita il 05/10, CHIUSA e NON TOCCATA: ' + $dv.Inst + '  (cartella dati ' + (Split-Path -Leaf $dv.Dir) + ')') 'Yellow' }
if($ignote.Count -gt 0){
  foreach($dv in $ignote){ Write-Host ('     installazione NON censita: ' + $dv.Inst) -ForegroundColor Red }
  throw 'Mi fermo: oltre al BCM e alle due censite il 05/10 (C:\MT5_Backtest, C:\FundedNext_Manuale) qui ci sono ALTRE installazioni MT5 (regola dei terminali multipli).'
}
$cands = @($origini | Where-Object { $_.Inst -eq $InstAttesa })
if($cands.Count -ne 1){ throw ('cartella dati NON risolta in modo univoco: trovate ' + $cands.Count + ' candidate per ' + $InstAttesa + '. Mi fermo invece di indovinare.') }
$DataFolder = $cands[0].Dir
$chrRoot = Join-Path (Join-Path (Join-Path $DataFolder 'MQL5') 'Profiles') 'Charts'
$nChr = 0; $conEA = @()
if(Test-Path -LiteralPath $chrRoot){
  foreach($fc in @(Get-ChildItem -LiteralPath $chrRoot -Recurse -File -Filter '*.chr' -ErrorAction SilentlyContinue)){
    $nChr = $nChr + 1
    $tx = Leggi-Condiviso $fc.FullName
    if(-not $tx){ $conEA = $conEA + @($fc.Directory.Name + '\' + $fc.Name + '  ILLEGGIBILE: conta come EA attaccato'); continue }
    if($tx -match '<expert>'){ $conEA = $conEA + @($fc.Directory.Name + '\' + $fc.Name + '  EA ATTACCATO') }
  }
}
if($nChr -le 0){ throw ('ho letto ZERO grafici salvati sotto ' + $chrRoot + ': una guardia che non legge niente non ha verificato niente. Non si parte.') }
if($conEA.Count -gt 0){ throw ('SEDIE ATTACCATE ai grafici salvati del terminale BCM (' + ($conEA -join '; ') + '). Staccale prima: aprire il terminale col profilo le rimetterebbe in marcia (demo 50503392, 14/08/2026).') }
$MqlExp = Join-Path (Join-Path $DataFolder 'MQL5') 'Experts'
$CommonFiles = Join-Path $env:APPDATA 'MetaQuotes\Terminal\Common\Files'
New-Item -ItemType Directory -Force -Path $MqlExp | Out-Null
Dico ('terminale: ' + $Terminal) 'Green'
Dico ('dati     : ' + $DataFolder) 'Green'
Dico ('grafici salvati letti: ' + $nChr + ', nessun EA attaccato') 'Green'

# ---------------------------------------------------------------------
#  1. EA E .INI AL PIN (SHA256 dalla riga), CONTROLLO STATICO, COMPILAZIONE VERIFICATA
# ---------------------------------------------------------------------
Titolo '1 - SORGENTI AL PIN E COMPILAZIONE'
$Stamp = (Get-Date).ToString('yyyyMMdd_HHmmss', $IC)
$Work = Join-Path $env:USERPROFILE 'abtg_export_barre'
$Vecchi = Join-Path $Work ('vecchi_' + $Stamp)
New-Item -ItemType Directory -Force -Path $Work | Out-Null
$srcEA  = Join-Path $Work ($EXPERT + '.mq5')
$srcIni = Join-Path $Work $INI
Scarica ('mql5/Experts/' + $EXPERT + '.mq5') $srcEA 'CLAU12_EXPORT_BARRE_H1'
Scarica ('backtest_pipeline/righe/' + $INI) $srcIni 'MARCATORE_INI_CLAU12_EXPORT_BARRE_DOW_H1_v1'
foreach($ck in @(@($srcEA, $ShaEA, ($EXPERT + '.mq5')), @($srcIni, $ShaIni, $INI))){
  $hh = (Get-FileHash -LiteralPath $ck[0] -Algorithm SHA256).Hash
  if($hh -ne $ck[1]){ throw ($ck[2] + ' scaricato al pin ha SHA256 ' + $hh + ' invece di ' + $ck[1] + ' (quello calcolato dal commit): copia sbagliata o cache di GitHub. Non si parte.') }
  Dico ($ck[2] + ': SHA256 ' + $hh.Substring(0,12) + ' = quello della riga') 'Green'
}
$testoEA = Leggi-Condiviso $srcEA
if($testoEA.IndexOf('#define EXP_VER   "' + $VER_EA + '"', [StringComparison]::Ordinal) -lt 0){ throw ('il sorgente non dichiara EXP_VER ' + $VER_EA + '. Non si parte.') }
foreach($vietato in @('OrderSend', 'CTrade', 'Trade.mqh', 'PositionOpen', 'OrderSendAsync', 'InpMagic', 'AccountInfo', 'ACCOUNT_LOGIN', 'TradeExporter')){
  if($testoEA.IndexOf($vietato, [StringComparison]::Ordinal) -ge 0){ throw ('il sorgente al pin contiene "' + $vietato + '": un export di barre non deve avere ordini, magic o letture del conto. Non si compila.') }
}
foreach($dovuto in @('MQL_TESTER', 'MQL_OPTIMIZATION', 'MQL_VISUAL_MODE', 'FILE_COMMON', 'FileIsExist')){
  if($testoEA.IndexOf($dovuto, [StringComparison]::Ordinal) -lt 0){ throw ('il sorgente al pin NON contiene la guardia "' + $dovuto + '". Non si compila.') }
}
Dico 'controllo statico del sorgente: nessuna funzione d ordine, nessun magic, nessuna lettura del conto; guardie tester/ottimizzazione/visuale presenti' 'Green'

# D2: mai sovrascrivere in MQL5\Experts. Stesso .mq5 = si riusa; diverso = si sposta nei vecchi con la data. Il .ex5 vecchio si sposta sempre (serve un compilato NUOVO).
$dstMq5 = Join-Path $MqlExp ($EXPERT + '.mq5')
$ex5 = Join-Path $MqlExp ($EXPERT + '.ex5')
if(Test-Path -LiteralPath $dstMq5){
  if((Get-FileHash -LiteralPath $dstMq5 -Algorithm SHA256).Hash -ne $ShaEA){
    New-Item -ItemType Directory -Force -Path $Vecchi | Out-Null
    Move-Item -LiteralPath $dstMq5 -Destination (Join-Path $Vecchi ($EXPERT + '.mq5')) -Force
    Dico ('un ' + $EXPERT + '.mq5 DIVERSO era in MQL5\Experts: spostato in ' + $Vecchi) 'Yellow'
  }
}
if(-not (Test-Path -LiteralPath $dstMq5)){ Copy-Item -LiteralPath $srcEA -Destination $dstMq5 }
if((Get-FileHash -LiteralPath $dstMq5 -Algorithm SHA256).Hash -ne $ShaEA){ throw 'il .mq5 in MQL5\Experts non ha lo SHA256 della riga dopo la copia. Non si compila.' }
if(Test-Path -LiteralPath $ex5){
  New-Item -ItemType Directory -Force -Path $Vecchi | Out-Null
  Move-Item -LiteralPath $ex5 -Destination (Join-Path $Vecchi ($EXPERT + '.ex5')) -Force
  Dico ('il .ex5 di una compilazione PRECEDENTE spostato in ' + $Vecchi + ' (serve un compilato nuovo)') 'Yellow'
}
if(Test-Path -LiteralPath $ex5){ throw 'il vecchio .ex5 non si sposta: un compilato vecchio passerebbe per nuovo.' }

$dsk  = [Environment]::GetFolderPath('Desktop')
$Cart = Join-Path $dsk $NOME_D
$zip  = Join-Path $dsk ($NOME_D + '.zip')
function Rinomina-Vecchi($c, $z, $st){
  if(Test-Path -LiteralPath $c){ Move-Item -LiteralPath $c -Destination ($c + '_VECCHIA_' + $st); Dico ('cartella di un giro PRECEDENTE rinominata: ' + $c + '_VECCHIA_' + $st) 'Yellow' }
  if(Test-Path -LiteralPath $z){ $zz = $z.Substring(0, $z.Length - 4) + '_VECCHIO_' + $st + '.zip'; Move-Item -LiteralPath $z -Destination $zz; Dico ('zip di un giro PRECEDENTE rinominato: ' + $zz) 'Yellow' }
}
$logC = Join-Path $Work ('compile_' + $Stamp + '.log')
function FermaCompilazione($perche){
  $CartC = Join-Path $dsk ($NOME_D + '_COMPILAZIONE_FALLITA')
  $zipC  = $CartC + '.zip'
  try{
    Rinomina-Vecchi $CartC $zipC $Stamp
    New-Item -ItemType Directory -Force -Path $CartC | Out-Null
    if(Test-Path -LiteralPath $logC){ Copy-Item -LiteralPath $logC -Destination (Join-Path $CartC 'compile.log') }
    @(($NOME_D + ': COMPILAZIONE DI ' + $EXPERT + ' v' + $VER_EA + ' FALLITA. Nessuna passata lanciata, nessun ordine.'), ('motivo: ' + $perche), ('pin: ' + $Pin + '   pc: ' + $env:COMPUTERNAME + '   data: ' + $Stamp)) -join "`r`n" | Set-Content -LiteralPath (Join-Path $CartC 'COMPILAZIONE_FALLITA.txt') -Encoding ASCII
    Compress-Archive -Path (Join-Path $CartC '*') -DestinationPath $zipC
    Write-Host ('   ZIP DA MANDARE (compilazione fallita): ' + $zipC) -ForegroundColor Red
  } catch { Write-Host ('   zip della compilazione NON creato (' + $_.Exception.Message + '): il log e in ' + $logC) -ForegroundColor Red }
  try{ $Mutex.ReleaseMutex() }catch{ }
  Write-Host ('COMPILAZIONE FALLITA: ' + $perche) -ForegroundColor Red
  exit 1
}
$pMe = Start-Process -FilePath $MetaEditor -ArgumentList @(('/compile:' + $dstMq5), ('/log:' + $logC)) -PassThru
$attC = 0
while(-not (Test-Path -LiteralPath $ex5) -and $attC -lt 60){ Start-Sleep -Seconds 2; $attC = $attC + 1 }
if(-not (Test-Path -LiteralPath $ex5)){
  try{ if(-not $pMe.HasExited){ [void]$pMe.CloseMainWindow() } }catch{ }
  FermaCompilazione ($EXPERT + '.ex5 NON prodotto dopo 120 secondi.')
}
$attE = 0
while(-not $pMe.HasExited -and $attE -lt 30){ Start-Sleep -Seconds 2; $attE = $attE + 1 }
Start-Sleep -Seconds 3
$testoLogC = ''
if(Test-Path -LiteralPath $logC){ $testoLogC = Leggi-Condiviso $logC }
$compErr = -1; $compWarn = -1
$mRes = [regex]::Match($testoLogC, '(\d+)\s+(?:errors?|errori|errore),\s*(\d+)\s+(?:warnings?|avvisi|avviso)')
if($mRes.Success){ $compErr = [int]$mRes.Groups[1].Value; $compWarn = [int]$mRes.Groups[2].Value }
if($compErr -gt 0){ FermaCompilazione ('MetaEditor ha prodotto l .ex5 ma il log dice ' + $compErr + ' errori: non si usa un compilato dubbio.') }
Dico ('compilato: ' + $ex5 + '   SHA256 .ex5 ' + (Get-FileHash -LiteralPath $ex5 -Algorithm SHA256).Hash.Substring(0,12)) 'Green'
if($compErr -eq 0){ Dico ('log di compilazione: 0 errori, ' + $compWarn + ' avvisi') $(if($compWarn -eq 0){'Green'}else{'Yellow'}) }
else { Dico 'log di compilazione: riga del risultato NON letta: il verdetto e l esistenza dell .ex5 appena prodotto (il vecchio era stato spostato prima)' 'Yellow' }

# ---------------------------------------------------------------------
#  2. IL .INI DELLA CORSA: due segnaposto, righe ';' tolte, chiavi ricontrollate
# ---------------------------------------------------------------------
Titolo '2 - LA PASSATA (Model=1, Visual=0, nessun ordine)'
$Run = ([Guid]::NewGuid().ToString('N')).Substring(0, 12)
$DataA = (Get-Date).ToString('yyyy.MM.dd', $IC)
$righeIni = New-Object System.Collections.ArrayList
foreach($r in (Get-Content -LiteralPath $srcIni)){
  if($r.TrimStart().StartsWith(';')){ continue }
  [void]$righeIni.Add($r.Replace('@@DATA_A@@', $DataA).Replace('@@RUN@@', $Run))
}
$testoIni = ($righeIni -join "`r`n") + "`r`n"
if($testoIni.IndexOf('@@', [StringComparison]::Ordinal) -ge 0){ throw 'nel .ini restano segnaposto @@ non sostituiti. Non si parte.' }
$attese = @('AllowLiveTrading=false', ('Expert=' + $EXPERT + '.ex5'), ('Symbol=' + $SIMBOLO), 'Period=H1', 'Model=1', 'Optimization=0', 'Visual=0', 'FromDate=2024.09.26', ('ToDate=' + $DataA), 'ShutdownTerminal=1', ('InpRunId=' + $Run))
foreach($a in $attese){ if(@($righeIni | Where-Object { $_.Trim() -ceq $a }).Count -ne 1){ throw ('il .ini della corsa non ha ESATTAMENTE una riga "' + $a + '". Non si parte.') } }
$iniF = Join-Path $Work ('export_barre_' + $Run + '.ini')
Set-Content -LiteralPath $iniF -Value $testoIni -Encoding ASCII -NoNewline
$nomeCsv = $EXPERT + '_' + $SIMBOLO + '_' + $Run + '.csv'
if(Test-Path -LiteralPath (Join-Path $CommonFiles $nomeCsv)){ throw ('in Common\Files esiste gia ' + $nomeCsv + ': non si sovrascrive. Rilancia (il run cambia a ogni lancio).') }
Dico ('run ' + $Run + '   finestra 2024.09.26 -> ' + $DataA + '   ini ' + $iniF) 'Green'

$LogRoot = Join-Path $env:APPDATA 'MetaQuotes'
$PatLog = @((Join-Path $LogRoot 'Tester\*\Agent-*\logs'), (Join-Path $InstAttesa 'Tester\Agent-*\logs'), (Join-Path $InstAttesa 'Tester\logs'), (Join-Path $DataFolder 'Tester\logs'), (Join-Path $DataFolder 'logs'), (Join-Path (Join-Path $DataFolder 'MQL5') 'Logs'))
function ElencoLog(){
  $v = @()
  foreach($pt in $PatLog){ foreach($it in @(Get-Item -Path $pt -ErrorAction SilentlyContinue)){ if($it.PSIsContainer){ $v = $v + @(Get-ChildItem -LiteralPath $it.FullName -Filter '*.log' -File -ErrorAction SilentlyContinue) } } }
  return $v
}
function LeggiCoda($path, $offset){
  $fs = [IO.File]::Open($path,[IO.FileMode]::Open,[IO.FileAccess]::Read,[IO.FileShare]::ReadWrite)
  try{
    $b = New-Object byte[] 2
    [void]$fs.Read($b,0,2)
    $enc = [Text.Encoding]::UTF8
    if($b[0] -eq 0xFF -and $b[1] -eq 0xFE){ $enc = [Text.Encoding]::Unicode }
    $da = [long]$offset
    if($da -lt 2 -and $enc -ne [Text.Encoding]::UTF8){ $da = 2 }
    [void]$fs.Seek($da,[IO.SeekOrigin]::Begin)
    $sr = New-Object IO.StreamReader($fs, $enc, $false)
    return $sr.ReadToEnd()
  } finally { $fs.Close() }
}
$foto = @{}
foreach($f in @(ElencoLog)){ $foto[$f.FullName] = $f.Length }
$tRun = Get-Date
$p = Start-Process -FilePath $Terminal -ArgumentList ('/config:"' + $iniF + '"') -PassThru
$scade = $tRun.AddMinutes($TimeoutRunMin)
while(-not $p.HasExited -and (Get-Date) -lt $scade){ Start-Sleep -Seconds 5 }
$timeout = $false
if(-not $p.HasExited){
  $timeout = $true
  Write-Host ('   TIMEOUT: dopo ' + $TimeoutRunMin + ' minuti il tester e ancora aperto. Lo chiudo con CloseMainWindow (MAI Stop-Process sul terminale).') -ForegroundColor Red
  try{ [void]$p.CloseMainWindow() }catch{ }
  $att = 0; while(-not $p.HasExited -and $att -lt 18){ Start-Sleep -Seconds 5; $att = $att + 1 }
  if(-not $p.HasExited){ Write-Host '   il terminale NON si e chiuso: la riga NON lo chiude con la forza (chiudilo A MANO dopo aver letto questa finestra).' -ForegroundColor Red }
}
Start-Sleep -Seconds 8
$dur = [int]((Get-Date) - $tRun).TotalSeconds

# ---------------------------------------------------------------------
#  3. RACCOLTA: CSV (copiato, MAI cancellato), giornale, ini, log di compilazione, zip
# ---------------------------------------------------------------------
Titolo '3 - RACCOLTA'
$motivi = New-Object System.Collections.ArrayList
if($timeout){ [void]$motivi.Add('timeout di ' + $TimeoutRunMin + ' minuti') }
$righeLog = New-Object System.Collections.ArrayList
foreach($f in @(ElencoLog)){
  $off = 0; if($foto.ContainsKey($f.FullName)){ $off = [long]$foto[$f.FullName] }
  if($f.Length -le $off){ continue }
  try{ $testo = LeggiCoda $f.FullName $off }catch{ continue }
  foreach($riga in ($testo -split "`r?`n")){
    if($riga -match '\[CLAU12_EXPORT\]' -or $riga -match '(?i)bars generated|ticks data begins|history|no data|cannot|failed|error|not found|disconnect|synchron|testing of Experts|Test passed|final balance'){ [void]$righeLog.Add($riga.Trim()) }
  }
}
$righeLog = @($righeLog | Select-Object -Unique | Select-Object -First 2000)
$avvio = @($righeLog | Where-Object { $_ -match ('\[CLAU12_EXPORT\] AVVIO v' + [regex]::Escape($VER_EA) + ' \| ' + $SIMBOLO + ' H1 \| run ' + $Run) })
$rifiuti = @($righeLog | Where-Object { $_ -match '\[CLAU12_EXPORT\] (RIFIUTATO|ERRORE)' })
if($avvio.Count -lt 1){ [void]$motivi.Add('riga AVVIO v' + $VER_EA + ' con run ' + $Run + ' NON trovata nei log (l EA non e partito? ini ignorata?)') }
foreach($x in @($rifiuti | Select-Object -First 3)){ [void]$motivi.Add('EA: ' + $x) }

$csvIt = $null
foreach($pz in @((Join-Path $CommonFiles $nomeCsv), (Join-Path (Join-Path $LogRoot 'Tester') ('*\Agent-*\MQL5\Files\' + $nomeCsv)))){
  foreach($it in @(Get-Item -Path $pz -ErrorAction SilentlyContinue | Where-Object { $_.LastWriteTime -ge $tRun })){ if($null -eq $csvIt){ $csvIt = $it } }
}
Rinomina-Vecchi $Cart $zip $Stamp
New-Item -ItemType Directory -Force -Path $Cart | Out-Null
Copy-Item -LiteralPath $iniF -Destination (Join-Path $Cart ('export_barre_' + $Run + '.ini'))
if(Test-Path -LiteralPath $logC){ Copy-Item -LiteralPath $logC -Destination (Join-Path $Cart 'compile.log') }
($righeLog -join "`r`n") | Set-Content -LiteralPath (Join-Path $Cart 'giornale_tester.txt') -Encoding ASCII
$nRighe = 0; $fineCsv = ''; $primaB = ''; $ultimaB = ''; $shaCsv = ''; $runCsv = ''
if($null -eq $csvIt){ [void]$motivi.Add('CSV ' + $nomeCsv + ' NON trovato fresco (scritto dopo l avvio della passata) in Common\Files ne negli agenti') }
else {
  $dstCsv = Join-Path $Cart ($SIMBOLO + '_H1_' + $Run + '.csv')
  Copy-Item -LiteralPath $csvIt.FullName -Destination $dstCsv
  $shaCsv = (Get-FileHash -LiteralPath $dstCsv -Algorithm SHA256).Hash
  foreach($ln in [IO.File]::ReadLines($dstCsv)){
    if($ln.StartsWith('#FINE;', [StringComparison]::Ordinal)){ $fineCsv = $ln; continue }
    if($ln.StartsWith('#run;', [StringComparison]::Ordinal)){ $runCsv = $ln.Substring(5); continue }
    if($ln -match '^\d{4}\.\d\d\.\d\d \d\d:\d\d;'){ $nRighe = $nRighe + 1; if($primaB -eq ''){ $primaB = $ln.Substring(0,16) }; $ultimaB = $ln.Substring(0,16) }
  }
  if($runCsv -ne $Run){ [void]$motivi.Add('il CSV dichiara run "' + $runCsv + '" invece di ' + $Run) }
  if($fineCsv -eq ''){ [void]$motivi.Add('il CSV NON ha la riga #FINE: file troncato (tester interrotto?)') }
  else {
    $mF = [regex]::Match($fineCsv, '^#FINE;n=(\d+);.*;errori_copia=(\d+);')
    if(-not $mF.Success){ [void]$motivi.Add('riga #FINE in un formato non riconosciuto: ' + $fineCsv) }
    else {
      if([long]$mF.Groups[1].Value -ne $nRighe){ [void]$motivi.Add('#FINE dice n=' + $mF.Groups[1].Value + ' ma le righe di barra sono ' + $nRighe) }
      if([long]$mF.Groups[2].Value -ne 0){ [void]$motivi.Add('#FINE dice errori_copia=' + $mF.Groups[2].Value + ' (il collaudo la boccia)') }
    }
  }
  if($nRighe -le 0){ [void]$motivi.Add('CSV senza nessuna barra') }
}
$stato = 'OK'; if($motivi.Count -gt 0){ $stato = 'KO' }
$riep = @(
  ($NOME_D + ' -- export delle barre H1 di ' + $SIMBOLO + ' dal tester (Model=1, Visual=0), EA ' + $EXPERT + ' v' + $VER_EA),
  ('data: ' + (Get-Date).ToString('yyyy-MM-dd HH:mm:ss', $IC) + '   pc: ' + $env:COMPUTERNAME + '   pin: ' + $Pin + '   run: ' + $Run),
  ('EA SHA256 ' + $ShaEA + '   ini SHA256 ' + $ShaIni + '   compilazione: ' + $compErr + ' errori, ' + $compWarn + ' avvisi (-1 = non letto)'),
  ('finestra chiesta: 2024.09.26 -> ' + $DataA + '   durata passata ' + $dur + ' s'),
  ('CSV: ' + $SIMBOLO + '_H1_' + $Run + '.csv   SHA256 ' + $shaCsv + '   barre ' + $nRighe + '   prima ' + $primaB + '   ultima ' + $ultimaB),
  ('riga #FINE: ' + $fineCsv),
  ('STATO: ' + $stato),
  ('motivi: ' + ($motivi -join ' | ')),
  '',
  'OROLOGIO: la colonna time_server e l ora del server BCM come registrata dal terminale, NON convertita. Il referto dice UTC+1 fisso sugli indici dal 2024.09.26 (report/OROLOGIO_BCM_2026-09-24.md par. 3.2): lo VERIFICA il collaudo.',
  'COME SI LEGGE: python3 backtest_pipeline/collaudo_export_barre_h1.py <csv> --run <run>. Questo script RACCOGLIE e basta: non giudica la serie.'
)
($riep -join "`r`n") | Set-Content -LiteralPath (Join-Path $Cart 'RIEPILOGO.txt') -Encoding ASCII
Compress-Archive -Path (Join-Path $Cart '*') -DestinationPath $zip
Write-Host ''
foreach($x in $riep){ Write-Host ('   ' + $x) }
foreach($x in $motivi){ Write-Host ('        - ' + $x) -ForegroundColor Red }
Write-Host ''
Write-Host ('ZIP PRONTO DA MANDARE: ' + $zip) -ForegroundColor Green
Write-Host 'FILE ATTESI NELLO ZIP: RIEPILOGO.txt + U30USD_H1_<run>.csv + giornale_tester.txt + export_barre_<run>.ini + compile.log' -ForegroundColor Gray
try{ $Mutex.ReleaseMutex() }catch{ }
if($stato -eq 'OK'){ Write-Host 'ESITO EXPORT: CSV FRESCO, CON #FINE, n coerente, errori_copia 0 (rc 0)' -ForegroundColor Green; exit 0 }
Write-Host 'ESITO EXPORT: QUALCOSA NON TORNA (rc 3): lo zip esce lo stesso, i motivi sono qui sopra e nel RIEPILOGO.' -ForegroundColor Red
exit 3
