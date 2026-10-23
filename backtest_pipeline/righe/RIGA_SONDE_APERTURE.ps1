# =====================================================================
#  MARCATORE_SONDE_APERTURE_v1
#
#  SONDE DI SOLA LETTURA S1-S3 SUL PC DI BACKTEST (DESKTOP-H4D7CAJ).
#  Criteri congeliati PRIMA dei numeri:
#    report/SONDE_SENZA_MACCHINA_CRITERI_2026-10-23.md
#  Lettore: backtest_pipeline/sonde_giudizio.py
#
#  COSA FA:
#   1. certifica il terminale 'C:\Program Files\BCM Markets MT5 Terminal'
#      (cartella dati trovata da origin.txt) e si ferma se MT5 e' APERTO;
#   2. LEGGE il profilo attivo (config\common.ini -> ProfileLast) e CONTA le
#      sedie (EA) attaccate ai grafici: se ce n'e' anche UNA, si ferma;
#   3. scarica ABTG_SondeAperture.mq5 dal commit fissato e ne verifica SHA256;
#   4. SENZA -Esegui e' una PROVA: non scrive nulla nel terminale;
#   5. CON -Esegui: copia lo script in MQL5\Scripts (copia dell'eventuale
#      file omonimo), scrive MQL5\Presets\ABTG_SondeAperture_AUTO.set, lo
#      compila con MetaEditor (/compile), avvia il terminale con uno
#      [StartUp] che esegue SOLO lo script su un grafico U30USD M1, attende
#      il file ABTG_SONDA_FINE.txt (lo script chiude da solo il terminale
#      con TerminalClose), e raccoglie i CSV + i log sul Desktop in uno zip.
#
#  COSA NON FA:
#   - nessun ordine: lo script NON ha funzioni di trading;
#   - NON chiude, NON uccide nessun processo (se il terminale non si
#     chiude da solo lo dice e lo chiudi tu);
#   - NON tocca altri terminali, .set o .chr esistenti, input, sedie.
#   - EFFETTO COLLATERALE DICHIARATO: il terminale, uscendo, salva nel
#     profilo attivo il grafico U30USD M1 aperto per lo [StartUp].
#
#  ASCII PURO (PS 5.1 legge i .ps1 come ANSI).
# =====================================================================
param(
  [Parameter(Mandatory=$true)][ValidatePattern('^[0-9a-f]{40}$')][string]$Pin,
  [Parameter(Mandatory=$true)][ValidatePattern('^[0-9A-Fa-f]{64}$')][string]$ShaMq5,
  [switch]$Esegui
)

$ErrorActionPreference = 'Stop'
$INV = [Globalization.CultureInfo]::InvariantCulture
try { [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12 } catch { }

$PC_ATTESO  = 'DESKTOP-H4D7CAJ'
$PROG       = 'C:\Program Files\BCM Markets MT5 Terminal'
$CONTO      = '50503392'
$REPO_RAW   = 'https://raw.githubusercontent.com/claudiospadaro12/GITHUB'
$NOME       = 'ABTG_SondeAperture'
$SET_AUTO   = 'ABTG_SondeAperture_AUTO.set'
$TIMEOUT_MIN = 15

function Leggi-Testo($path) {
  $fs = [IO.File]::Open($path, [IO.FileMode]::Open, [IO.FileAccess]::Read, [IO.FileShare]::ReadWrite)
  try {
    $b = New-Object byte[] $fs.Length
    $letti = 0
    while($letti -lt $b.Length){
      $q = $fs.Read($b, $letti, $b.Length - $letti)
      if($q -le 0){ break }
      $letti += $q
    }
  } finally { $fs.Close() }
  if($b.Count -lt 2){ return '' }
  if($b[0] -eq 0xFF -and $b[1] -eq 0xFE){ return [Text.Encoding]::Unicode.GetString($b) }
  $zeri = 0
  $n = [math]::Min(400, $b.Count)
  for($i = 1; $i -lt $n; $i += 2){ if($b[$i] -eq 0){ $zeri++ } }
  if($zeri -gt ($n / 4)){ return [Text.Encoding]::Unicode.GetString($b) }
  return [Text.Encoding]::UTF8.GetString($b)
}

function Muori($msg) {
  Write-Host ''
  Write-Host '=====================================================================' -ForegroundColor Red
  Write-Host ('FERMO: ' + $msg) -ForegroundColor Red
  Write-Host 'NIENTE E STATO AVVIATO. Nessun ordine, nessun processo toccato.' -ForegroundColor Red
  Write-Host 'STATO: FERMO'
  Write-Host '=====================================================================' -ForegroundColor Red
  exit 1
}

Write-Host '====================================================================='
Write-Host ' SONDE DI SOLA LETTURA S1-S3 -- PC DI BACKTEST'
Write-Host (' pc   : ' + $env:COMPUTERNAME)
Write-Host (' pin  : ' + $Pin)
Write-Host (' ora  : ' + (Get-Date).ToString('yyyy-MM-dd HH:mm:ss', $INV) + '  (ora locale)')
Write-Host '====================================================================='

# PASSO 1 -- macchina, processi, cartella dati
if($env:COMPUTERNAME -ne $PC_ATTESO){ Muori ('questa macchina si chiama ' + $env:COMPUTERNAME + ', non ' + $PC_ATTESO + '.') }
$vivi = @(Get-Process -Name terminal64 -ErrorAction SilentlyContinue)
if($vivi.Count -gt 0){ Muori 'MT5 risulta APERTO su questo PC. Guarda i grafici, chiudilo a mano e rilancia.' }
$exe = Join-Path $PROG 'terminal64.exe'
$med = Join-Path $PROG 'metaeditor64.exe'
if(-not (Test-Path -LiteralPath $exe)){ Muori ('manca ' + $exe) }
if(-not (Test-Path -LiteralPath $med)){ Muori ('manca ' + $med) }
$radice = Join-Path $env:APPDATA 'MetaQuotes\Terminal'
$dati = ''
foreach($d in @(Get-ChildItem -LiteralPath $radice -Directory -ErrorAction SilentlyContinue)){
  if($d.Name -ieq 'Common'){ continue }
  $o = Join-Path $d.FullName 'origin.txt'
  if(-not (Test-Path -LiteralPath $o)){ continue }
  $inst = ((Leggi-Testo $o) -replace '[^\u0020-\u007E]', '').Trim()
  if($inst -ieq $PROG){ if($dati -ne ''){ Muori 'due cartelle dati puntano allo stesso terminale.' }; $dati = $d.FullName }
}
if($dati -eq ''){ Muori ('non trovo la cartella dati di ' + $PROG + ' sotto ' + $radice) }
Write-Host ('[1/6] terminale certificato: ' + $PROG) -ForegroundColor Green
Write-Host ('      cartella dati: ' + $dati)

# PASSO 2 -- il profilo attivo non deve avere SEDIE
$ini0 = Join-Path $dati 'config\common.ini'
$profilo = 'Default'
if(Test-Path -LiteralPath $ini0){
  $m = [regex]::Match((Leggi-Testo $ini0), '(?im)^\s*ProfileLast\s*=\s*(.+?)\s*$')
  if($m.Success){ $profilo = $m.Groups[1].Value.Trim() }
}
$dirChr = Join-Path $dati ('MQL5\Profiles\Charts\' + $profilo)
$sedie = @()
if(Test-Path -LiteralPath $dirChr){
  foreach($c in @(Get-ChildItem -LiteralPath $dirChr -Filter *.chr -File -ErrorAction SilentlyContinue)){
    $t = ''
    try { $t = Leggi-Testo $c.FullName } catch { Muori ('non riesco a leggere ' + $c.FullName + ': non posso escludere sedie attaccate.') }
    if($t -match '(?im)^\s*<expert>'){
      $nm = [regex]::Match($t, '(?is)<expert>.*?^\s*name\s*=\s*([^\r\n]+)', 'IgnoreCase,Singleline,Multiline')
      $nome = '?'
      if($nm.Success){ $nome = $nm.Groups[1].Value.Trim() }
      $sedie += ($c.Name + ' -> ' + $nome)
    }
  }
}
Write-Host ('[2/6] profilo attivo: "' + $profilo + '"; grafici con un EA attaccato: ' + $sedie.Count.ToString($INV)) -ForegroundColor Green
if($sedie.Count -gt 0){
  foreach($s in $sedie){ Write-Host ('      SEDIA: ' + $s) -ForegroundColor Yellow }
  Muori 'nel profilo attivo ci sono EA attaccati ai grafici: lanciare il terminale li farebbe ripartire su un conto demo. Stacca le sedie a mano (o cambia profilo), chiudi MT5 e rilancia.'
}

# PASSO 3 -- scarico lo script al commit fissato e ne verifico l'impronta
$W = Join-Path $env:USERPROFILE 'abtg_sonde'
[void](New-Item -ItemType Directory -Force -Path $W)
$loc = Join-Path $W ($NOME + '.mq5')
Remove-Item -LiteralPath $loc -Force -ErrorAction SilentlyContinue
$url = $REPO_RAW + '/' + $Pin + '/mql5/Scripts/' + $NOME + '.mq5'
$wc = New-Object Net.WebClient
try { $wc.DownloadFile($url, $loc) } catch { Muori ('scaricamento FALLITO da ' + $url + ' -- ' + $_.Exception.Message) } finally { $wc.Dispose() }
$sha = (Get-FileHash -LiteralPath $loc -Algorithm SHA256).Hash
Write-Host ('[3/6] script scaricato, SHA256 ' + $sha)
if($sha -ne $ShaMq5.ToUpper()){ Muori ('SHA256 DIVERSO dall atteso (' + $ShaMq5.ToUpper() + '): non si parte.') }
$txt = Leggi-Testo $loc
if($txt -match '(?i)\b(OrderSend|CTrade|PositionOpen|PositionClose|PositionModify|OrderDelete|TradeRequest)\b'){ Muori 'lo script scaricato contiene funzioni di trading: NON e quello atteso.' }
Write-Host '      nessuna funzione di trading nel testo dello script (controllo testuale).' -ForegroundColor Green

$destScr = Join-Path $dati ('MQL5\Scripts\' + $NOME + '.mq5')
$destSet = Join-Path $dati ('MQL5\Presets\' + $SET_AUTO)
if(-not $Esegui){
  Write-Host ''
  Write-Host '=====================================================================' -ForegroundColor Cyan
  Write-Host ' PROVA: nel terminale NON e stato scritto niente. Con -Esegui:' -ForegroundColor Cyan
  Write-Host ('   - copia lo script in   ' + $destScr) -ForegroundColor Cyan
  Write-Host ('   - scrive il preset     ' + $destSet + '   (InpChiudiTerminale=true)') -ForegroundColor Cyan
  Write-Host '   - compila con MetaEditor, avvia il terminale con lo [StartUp] e raccoglie i CSV' -ForegroundColor Cyan
  Write-Host '=====================================================================' -ForegroundColor Cyan
  Write-Host 'STATO: PROVA_OK'
  exit 0
}

# PASSO 4 -- installazione e compilazione
$dirScr = Split-Path -Parent $destScr
$dirSet = Split-Path -Parent $destSet
[void](New-Item -ItemType Directory -Force -Path $dirScr)
[void](New-Item -ItemType Directory -Force -Path $dirSet)
$stamp = (Get-Date).ToString('yyyyMMdd_HHmmss', $INV)
if(Test-Path -LiteralPath $destScr){ Copy-Item -LiteralPath $destScr -Destination ($destScr + '.prima_' + $stamp) -Force }
Copy-Item -LiteralPath $loc -Destination $destScr -Force
Set-Content -LiteralPath $destSet -Value ("InpChiudiTerminale=true`r`n") -Encoding ASCII
Write-Host '[4/6] script e preset installati; compilo con MetaEditor...'
$logc = Join-Path $W ('compila_sonda_' + $stamp + '.log')
$tc = Get-Date
$pc = Start-Process -FilePath $med -ArgumentList @(('/compile:"' + $destScr + '"'), ('/log:"' + $logc + '"')) -PassThru -Wait
$ex5 = Join-Path $dirScr ($NOME + '.ex5')
$compOk = $false
if(Test-Path -LiteralPath $logc){
  $lt = Leggi-Testo $logc
  if($lt -match 'Result:\s*0 errors'){ $compOk = $true }
  Write-Host ('      ' + (($lt -split "`n" | Where-Object { $_ -match 'Result:' } | Select-Object -Last 1)))
}
if(-not $compOk -or -not (Test-Path -LiteralPath $ex5) -or ((Get-Item -LiteralPath $ex5).LastWriteTime -lt $tc)){
  Write-Host ('      log di compilazione: ' + $logc) -ForegroundColor Yellow
  Muori 'la COMPILAZIONE non e riuscita (0 errori attesi e un .ex5 fresco). Mandami il log: lo script non e stato eseguito.'
}
Write-Host '      compilato: 0 errori.' -ForegroundColor Green

# PASSO 5 -- esecuzione
$cf = Join-Path $env:APPDATA 'MetaQuotes\Terminal\Common\Files'
[void](New-Item -ItemType Directory -Force -Path $cf)
foreach($f in @('ABTG_SONDA_SPX.csv','ABTG_SONDA_ORB.csv','ABTG_SONDA_BOX.csv','ABTG_SONDA_FINE.txt')){
  Remove-Item -LiteralPath (Join-Path $cf $f) -Force -ErrorAction SilentlyContinue
}
$iniRun = Join-Path $W ('sonde_' + $stamp + '.ini')
$iniTxt = "[Charts]`r`nMaxBars=2000000000`r`n`r`n[StartUp]`r`nScript=" + $NOME + "`r`nScriptParameters=" + $SET_AUTO + "`r`nSymbol=U30USD`r`nPeriod=M1`r`n"
Set-Content -LiteralPath $iniRun -Value $iniTxt -Encoding Unicode
Write-Host '[5/6] avvio il terminale con lo [StartUp] (SOLO lo script, nessun EA nel profilo)...'
$t0 = Get-Date
$p = Start-Process -FilePath $exe -ArgumentList ('/config:"' + $iniRun + '"') -PassThru
$fine = Join-Path $cf 'ABTG_SONDA_FINE.txt'
$scad = (Get-Date).AddMinutes($TIMEOUT_MIN)
$fatto = $false
while((Get-Date) -lt $scad){
  Start-Sleep -Seconds 10
  if((Test-Path -LiteralPath $fine) -and ((Get-Item -LiteralPath $fine).LastWriteTime -ge $t0)){ $fatto = $true; break }
}
if($fatto){ Write-Host '      lo script ha scritto il file di fine.' -ForegroundColor Green }
else { Write-Host ('      TIMEOUT: nessun file di fine dopo ' + $TIMEOUT_MIN + ' minuti.') -ForegroundColor Red }
$chiuso = $p.WaitForExit(120000)
if(-not $chiuso){
  Write-Host '      Il terminale e ANCORA APERTO. Non lo chiudo io: chiudilo tu a mano (File > Esci).' -ForegroundColor Yellow
}

# PASSO 6 -- raccolta
$desk = [Environment]::GetFolderPath('Desktop')
$out = Join-Path $desk ('SONDE_APERTURE_' + $stamp)
[void](New-Item -ItemType Directory -Force -Path $out)
$n = 0
foreach($f in @('ABTG_SONDA_SPX.csv','ABTG_SONDA_ORB.csv','ABTG_SONDA_BOX.csv','ABTG_SONDA_FINE.txt')){
  $fp = Join-Path $cf $f
  if((Test-Path -LiteralPath $fp) -and ((Get-Item -LiteralPath $fp).LastWriteTime -ge $t0)){ Copy-Item -LiteralPath $fp -Destination $out -Force; $n++ }
  else { Write-Host ('      MANCA (o non fresco): ' + $f) -ForegroundColor Red }
}
Copy-Item -LiteralPath $logc -Destination $out -Force -ErrorAction SilentlyContinue
$gl = Join-Path $dati ('MQL5\Logs\' + (Get-Date).ToString('yyyyMMdd', $INV) + '.log')
if(Test-Path -LiteralPath $gl){ Copy-Item -LiteralPath $gl -Destination (Join-Path $out ('MQL5_Logs_' + (Get-Date).ToString('yyyyMMdd', $INV) + '.log')) -Force -ErrorAction SilentlyContinue }
$zip = Join-Path $desk ('SONDE_APERTURE_' + $stamp + '.zip')
Compress-Archive -Path (Join-Path $out '*') -DestinationPath $zip -Force
Write-Host ''
Write-Host ('RACCOLTA: ' + $zip) -ForegroundColor Green
Write-Host ('   file prodotti freschi: ' + $n.ToString($INV) + ' su 4')
if($n -eq 4 -and $fatto){ Write-Host 'STATO: ESEGUITO_OK' ; exit 0 }
Write-Host 'STATO: ESEGUITO_CON_RILIEVI'
exit 2
