# =====================================================================
#  MARCATORE_PASSATA_STOP_SUPREV_v2
#  PASSATA_STOP_SUPREV.ps1 -- LA DISTANZA INGRESSO->SL, MISURATA
#
#  CHE COSA MISURA, e una cosa sola:
#    la distanza fra il prezzo d'ingresso e lo stop loss di OGNI ingresso
#    di ABTG_SupertrendReversal su U30USD H1, con l'ancora del Dow di R243
#    (StMult 3.5, StAtrPeriod 9, NearAtr 1.0, TP_RR 2.5), finestra oraria
#    SPENTA. Due passate singole: il lato CORTO (pin di R243a) e il lato
#    LUNGO (pin di R243b). Regola dei due lati del 25/08.
#
#  PERCHE' SERVE: il cancello di costo "stop >= 40 x spread" sulla famiglia
#  SupRev e' SOSPESO da R240a r.153 ("la distanza ingresso->SL di questa
#  geometria non e' misurata"). R243 lo aveva chiuso con 3,5 x ATR, che il
#  cancello del 24/09 ha dimostrato essere la semi-larghezza della BANDA e
#  non la distanza dello stop (classe 735). Il numero vero l'EA lo stampa
#  gia' a ogni ingresso (riga "mercato ... @ ENTRY SL ... TP ..."), ma solo
#  in una passata SINGOLA: il driver di casa forza Optimization=1
#  (walkforward_generico.ps1 r.2013; r.1015 e' solo l'anteprima di
#  -SoloControllo), e sugli agenti di
#  ottimizzazione le Print non si leggono.
#
#  IL CONTROLLO INCROCIATO, dentro la stessa corsa: l'EA stampa ogni giorno
#  una riga [STREV-IMBUTO] con "ENTRATE n". La SOMMA di quegli n deve essere
#  UGUALE al numero di righe "mercato" lette. Se non lo e', questo script ha
#  letto male i log, e lo DICHIARA invece di stampare numeri.
#
#  IL CONTROLLO DELLA CONFIGURAZIONE (v2, cancello del 24/09): il controllo
#  incrociato prova il LETTORE, non l'INI. Se MT5 ignorasse [TesterInputs],
#  l'EA girerebbe coi default (H4, Supertrend(10,3.5), due lati) e i due
#  conteggi coinciderebbero lo stesso: numeri sbagliati con il bollino OK.
#  Quindi si legge anche la riga d'avvio dell'EA ("avviato su U30USD
#  PERIOD_H1. Supertrend(9,3.5)"), l'intestazione di ogni riga IMBUTO e il
#  lato di ogni ingresso: se uno solo non torna, CONFIGURAZIONE ROTTA.
#
#  E' UN BACKTEST, NON UN ORDINE. [Experts] AllowLiveTrading=false in tutte
#  e due le .ini: il terminale del PC di backtest e' loggato sul DEMO
#  50503392, e il 14/08/2026 da questa macchina sono partiti ordini veri.
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
$SIMBOLO = 'U30USD'
$PERIODO = 'H1'
$DA      = '2024.09.26'
$A       = '2026.06.30'
$RAW     = 'https://raw.githubusercontent.com/claudiospadaro12/GITHUB/' + $Pin + '/'
$LATI    = @(
  @{ Lato='SHORT'; Prova='R243a_ancoradow_SUPREV_U30USD_short.txt'; Long='false'; Short='true'  },
  @{ Lato='LONG';  Prova='R243b_ancoradow_SUPREV_U30USD_long.txt';  Long='true';  Short='false' }
)
# la geometria che la passata DICHIARA di misurare (file prova par. 1):
# l'ini la deve contenere PRIMA di partire, e l'EA la deve ripetere nel log
$ANCORA  = @('InpTF=16385','InpStMult=3.5','InpStAtrPeriod=9','InpNearAtr=1.0','InpTP_RR=2.5','InpSLLookback=5','InpSLBufferPips=3.0','InpVerbose=true','InpLogImbuto=true','InpUsaGuardian=false')
$AVVIO_ATTESO = 'avviato su ' + $SIMBOLO + ' PERIOD_' + $PERIODO + '. Supertrend(9,3.5).'

function Dico($t,$c='Gray'){ Write-Host ('   ' + $t) -ForegroundColor $c }
function Titolo($t){ Write-Host ''; Write-Host ('=== ' + $t + ' ===') -ForegroundColor Cyan }
function Num($s){ return [double]::Parse($s, [Globalization.NumberStyles]::Float, $IC) }
function F2($x){ return $x.ToString('0.00', $IC) }
function Scarica($rel, $dest, $firma){
  Remove-Item -LiteralPath $dest -Force -ErrorAction SilentlyContinue
  Invoke-RestMethod -Uri ($RAW + $rel + '?cb=' + [Guid]::NewGuid().ToString('N')) -OutFile $dest
  if(-not (Select-String -LiteralPath $dest -SimpleMatch -Pattern $firma -Quiet)){
    throw ($rel + ' scaricato ma NON contiene "' + $firma + '": copia sbagliata o cache di GitHub. Non si parte.')
  }
}
function Quantile($ord, $q){
  $n = $ord.Count
  if($n -eq 0){ return [double]::NaN }
  $pos = $q * ($n - 1); $lo = [math]::Floor($pos); $hi = [math]::Ceiling($pos)
  if($lo -eq $hi){ return [double]$ord[[int]$lo] }
  return [double]$ord[[int]$lo] + ($pos - $lo) * ([double]$ord[[int]$hi] - [double]$ord[[int]$lo])
}

# ---------------------------------------------------------------------
#  0. LA MACCHINA E IL TERMINALE. Fail-closed, identico alla sonda del box
#     (SONDA_BOX_D30EUR.ps1, passata due volte dal cancello).
# ---------------------------------------------------------------------
Titolo '0 - MACCHINA E TERMINALE'
if($env:COMPUTERNAME -ne 'DESKTOP-H4D7CAJ'){
  throw ('PASSATA_STOP_SUPREV gira SOLO sul PC di backtest DESKTOP-H4D7CAJ. Qui la macchina si chiama: ' + $env:COMPUTERNAME + '. Sul VPS VMI3047753 non si lancia: la challenge FTMO 541452707 sta operando.')
}
Dico ('pc   : ' + $env:COMPUTERNAME) 'Green'
Dico ('pin  : ' + $Pin) 'Green'
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
  foreach($a in $diversi){ Write-Host ('     ' + $a.Inst) -ForegroundColor Red }
  throw 'La passata si ferma: la riga dichiara che il PC di backtest ha UN SOLO MT5, e qui ce ne sono altri (regola dei terminali multipli).'
}
$cands = @($origini | Where-Object { $_.Inst -eq $InstAttesa })
if($cands.Count -ne 1){
  throw ('cartella dati NON risolta in modo univoco: trovate ' + $cands.Count + ' candidate per ' + $InstAttesa + '. La passata si ferma invece di indovinare.')
}
$DataFolder = $cands[0].Dir
$MqlExp = Join-Path $DataFolder 'MQL5\Experts'
$MqlInc = Join-Path $DataFolder 'MQL5\Include'
New-Item -ItemType Directory -Force -Path $MqlExp,$MqlInc | Out-Null
Dico ('terminale: ' + $Terminal) 'Green'
Dico ('dati     : ' + $DataFolder) 'Green'

# ---------------------------------------------------------------------
#  1. EA, INCLUDE E FILE PROVA AL PIN, E COMPILAZIONE VERIFICATA
# ---------------------------------------------------------------------
Titolo '1 - SORGENTI AL PIN E COMPILAZIONE'
$Work = Join-Path $env:USERPROFILE 'abtg_passata'
New-Item -ItemType Directory -Force -Path $Work | Out-Null
$srcEA  = Join-Path $Work ($EXPERT + '.mq5')
$srcInc = Join-Path $Work 'ABTG_PausaGuardian.mqh'
Scarica ('mql5/Experts/' + $EXPERT + '.mq5') $srcEA 'STREV-IMBUTO'
Scarica 'mql5/Include/ABTG_PausaGuardian.mqh' $srcInc 'ABTG_GuardiaIngresso'
foreach($L in $LATI){
  $L.File = Join-Path $Work $L.Prova
  Scarica ('backtest_pipeline/prove/' + $L.Prova) $L.File 'InpUseTimeWindow'
}
Copy-Item -LiteralPath $srcEA  -Destination (Join-Path $MqlExp ($EXPERT + '.mq5')) -Force
Copy-Item -LiteralPath $srcInc -Destination (Join-Path $MqlInc 'ABTG_PausaGuardian.mqh') -Force

$ex5 = Join-Path $MqlExp ($EXPERT + '.ex5')
Remove-Item -LiteralPath $ex5 -Force -ErrorAction SilentlyContinue
$logC = Join-Path $Work 'compile.log'
Remove-Item -LiteralPath $logC -Force -ErrorAction SilentlyContinue
# il verdetto NON e' il codice d'uscita di MetaEditor (a volte si stacca):
# e' l'esistenza del .ex5 appena prodotto. Si aspetta quello.
$pMe = Start-Process -FilePath $MetaEditor -ArgumentList @('/compile:' + (Join-Path $MqlExp ($EXPERT + '.mq5')), '/log:' + $logC) -PassThru
$attC = 0
while(-not (Test-Path -LiteralPath $ex5) -and $attC -lt 60){ Start-Sleep -Seconds 2; $attC = $attC + 1 }
if(-not (Test-Path -LiteralPath $ex5)){
  try{ if(-not $pMe.HasExited){ $pMe.Kill() } }catch{ }
  if(Test-Path -LiteralPath $logC){ Get-Content -LiteralPath $logC | Select-Object -Last 15 | ForEach-Object { Write-Host ('     ' + $_) -ForegroundColor DarkYellow } }
  throw ($EXPERT + '.ex5 NON prodotto dopo 120 secondi. Senza il compilato la passata non gira.')
}
Dico ('compilato: ' + $ex5) 'Green'

# ---------------------------------------------------------------------
#  2. LE DUE PASSATE SINGOLE
# ---------------------------------------------------------------------
$dsk  = [Environment]::GetFolderPath('Desktop')
$Cart = Join-Path $dsk 'PASSATA_STOP_SUPREV'
if(Test-Path -LiteralPath $Cart){ Remove-Item -LiteralPath $Cart -Recurse -Force -ErrorAction SilentlyContinue }
New-Item -ItemType Directory -Force -Path $Cart | Out-Null
$LogRoot = Join-Path $env:APPDATA 'MetaQuotes'
# le radici dei log: %APPDATA%\MetaQuotes contiene la cartella dati e gli
# agenti locali (Tester\<id>\Agent-127.0.0.1-30xx\logs: MISURATO su questa
# macchina, zip di R242); <installazione>\Tester e' la terza radice nota in
# casa (RIGA_R99_ORO_RISCHIO.ps1 r.966-971, checklist 34-ter e 518): costa
# niente guardarci, e una passata che non trova le Print costa 20 minuti.
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

foreach($L in $LATI){
  $lato = $L.Lato
  Titolo ('2 - PASSATA SINGOLA, lato ' + $lato + '  (pin di ' + $L.Prova + ')')

  # --- gli input: TUTTE le righe Inp del file prova, ridotte al PRIMO
  #     valore. Con Optimization=0 MT5 usa comunque il primo valore; qui lo
  #     si scrive esplicito, cosi' non c'e' niente da interpretare. L'asse
  #     InpUseTimeWindow=0||0||1||1||Y diventa InpUseTimeWindow=0: finestra
  #     SPENTA, la cella con piu' ingressi (la geometria dello stop non
  #     dipende dalla finestra).
  $inputs = New-Object System.Collections.ArrayList
  foreach($r in (Get-Content -LiteralPath $L.File)){
    if($r -match '^(Inp[A-Za-z0-9_]+)=(.*)$'){
      $nome = $Matches[1]; $val = $Matches[2]
      $i = $val.IndexOf('||'); if($i -ge 0){ $val = $val.Substring(0,$i) }
      [void]$inputs.Add($nome + '=' + $val)
    }
  }
  $asse = @($inputs | Where-Object { $_ -like 'InpUseTimeWindow=*' })
  $side = @($inputs | Where-Object { $_ -like 'InpAllowLong=*' -or $_ -like 'InpAllowShort=*' })
  Dico ('input scritti: ' + $inputs.Count + '   ' + ($asse -join ' ') + '   ' + ($side -join ' '))
  if($inputs.Count -lt 40){ throw ('solo ' + $inputs.Count + ' righe Inp lette da ' + $L.Prova + ': file prova tronco. Non si parte.') }
  if($asse.Count -ne 1 -or $asse[0] -ne 'InpUseTimeWindow=0'){ throw ('la finestra oraria NON risulta spenta (' + ($asse -join ',') + '). Non si parte.') }
  $pinAttesi = @($ANCORA) + @(('InpAllowLong=' + $L.Long), ('InpAllowShort=' + $L.Short))
  foreach($pa in $pinAttesi){
    if(@($inputs | Where-Object { $_ -eq $pa }).Count -ne 1){ throw ('il file prova ' + $L.Prova + ' NON contiene esattamente una volta ' + $pa + ': non e la geometria che la passata dichiara di misurare. Non si parte.') }
  }
  $doppi = @($inputs | ForEach-Object { ($_ -split '=')[0] } | Group-Object | Where-Object { $_.Count -gt 1 })
  if($doppi.Count -gt 0){ throw ('parametri DOPPI nel file prova: ' + (($doppi | ForEach-Object { $_.Name }) -join ', ') + '. Non si parte.') }

  $ini = Join-Path $Work ('passata_' + $lato + '.ini')
  $testoIni = "[Experts]`r`nAllowLiveTrading=false`r`nAllowDllImport=false`r`n`r`n" +
              "[Tester]`r`nExpert=" + $EXPERT + ".ex5`r`nSymbol=" + $SIMBOLO + "`r`nPeriod=" + $PERIODO + "`r`nModel=4`r`n" +
              "Optimization=0`r`nFromDate=" + $DA + "`r`nToDate=" + $A + "`r`nForwardMode=0`r`nDeposit=100000`r`nCurrency=EUR`r`nLeverage=100`r`n" +
              "ExecutionMode=0`r`nReplaceReport=1`r`nShutdownTerminal=1`r`nReport=PASSATA_STOP_" + $lato + "`r`n`r`n" +
              "[TesterInputs]`r`n" + ($inputs -join "`r`n") + "`r`n"
  Set-Content -LiteralPath $ini -Value $testoIni -Encoding ASCII
  Copy-Item -LiteralPath $ini -Destination $Cart -Force

  $foto = Fotografia
  $t0 = Get-Date
  Dico ('avvio: ' + $t0.ToString('HH:mm:ss') + '   (tick reali, ' + $DA + ' -> ' + $A + ', deposito 100000)') 'Cyan'
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
        $ent = Num $m.Groups[3].Value; $sl = Num $m.Groups[4].Value
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

  $csvLato = Join-Path $Cart ('STOP_' + $lato + '.csv')
  $righe = New-Object System.Collections.ArrayList
  [void]$righe.Add('quando;lato;lotti;ingresso;sl;tp;distanza_idx')
  foreach($e in $entr){ [void]$righe.Add($e.Quando + ';' + $e.Lato + ';' + $e.Lotti + ';' + $e.Ingresso + ';' + $e.SL + ';' + $e.TP + ';' + (F2 $e.Dist)) }
  ($righe -join "`r`n") | Set-Content -LiteralPath $csvLato -Encoding ASCII

  $n = $entr.Count
  $inizioRiep = $riepilogo.Count
  $altroLato = @($entr | Where-Object { $_.Lato -ne $lato }).Count
  $senzaData = @($entr | Where-Object { $_.Quando -eq '' }).Count
  [void]$riepilogo.Add('--- lato ' + $lato + ' (' + $L.Prova + ') --- durata ' + $min + ' min, log letti ' + $fileLetti)
  [void]$riepilogo.Add('   ingressi letti (righe "mercato")       : ' + $n)
  [void]$riepilogo.Add('   somma ENTRATE delle righe IMBUTO        : ' + $sommaEntrate + '   (giornate IMBUTO: ' + $imbVisti.Count + ', quadratura OK ' + $quadOK + ' / ROTTA ' + $quadKO + ')')
  $croceOK = ($n -gt 0 -and $n -eq $sommaEntrate)
  if($croceOK){ [void]$riepilogo.Add('   CONTROLLO INCROCIATO: OK -- i due conteggi coincidono.') }
  else { [void]$riepilogo.Add('   CONTROLLO INCROCIATO: ROTTO -- i due conteggi NON coincidono. I NUMERI QUI SOTTO NON SI USANO: lo script ha letto male i log.') }
  # --- CONTROLLO DELLA CONFIGURAZIONE: l'EA ha girato con l'ini che gli
  #     abbiamo dato? (il controllo incrociato qui sopra NON lo sa dire)
  $slStorto = @($entr | Where-Object { ($_.Lato -eq 'SHORT' -and (Num $_.SL) -le (Num $_.Ingresso)) -or ($_.Lato -eq 'LONG' -and (Num $_.SL) -ge (Num $_.Ingresso)) }).Count
  $avviiVisti = @($avvii.Keys)
  $cfgMotivi = New-Object System.Collections.ArrayList
  if($avviiVisti.Count -eq 0){ [void]$cfgMotivi.Add('riga di avvio dell EA NON trovata nei log') }
  foreach($av in $avviiVisti){ if($av -ne $AVVIO_ATTESO){ [void]$cfgMotivi.Add('avvio letto "' + $av + '" invece di "' + $AVVIO_ATTESO + '"') } }
  if($imbFuori -gt 0){ [void]$cfgMotivi.Add(([string]$imbFuori) + ' righe IMBUTO non intestate ' + $SIMBOLO + ' PERIOD_' + $PERIODO) }
  if($altroLato -gt 0){ [void]$cfgMotivi.Add(([string]$altroLato) + ' ingressi del lato opposto in una passata a un lato solo') }
  if($slStorto -gt 0){ [void]$cfgMotivi.Add(([string]$slStorto) + ' ingressi con lo SL dal lato sbagliato del prezzo') }
  $cfgOK = ($cfgMotivi.Count -eq 0)
  if($cfgOK){ [void]$riepilogo.Add('   CONTROLLO CONFIGURAZIONE: OK -- l EA ha stampato "' + $AVVIO_ATTESO + '", righe IMBUTO e lati coerenti.') }
  else { [void]$riepilogo.Add('   CONTROLLO CONFIGURAZIONE: ROTTO -- ' + ($cfgMotivi -join ' ; ') + '. I NUMERI QUI SOTTO NON SI USANO: la passata non ha misurato la geometria dichiarata.') }
  [void]$riepilogo.Add('   righe grezze nei log: "mercato" ' + $merGrezze.Count + ' (lette ' + $n + '), IMBUTO ' + $imbGrezze.Count + ' (lette ' + $imbVisti.Count + ')   <- se diverse, il parser e cieco su una forma della riga')
  if($illeggibili.Count -gt 0){ [void]$riepilogo.Add('   ATTENZIONE: ' + $illeggibili.Count + ' file .log cresciuti ma NON leggibili (bloccati): ' + ($illeggibili -join ' | ')) }
  if($senzaData -gt 0){ [void]$riepilogo.Add('   ATTENZIONE: ' + $senzaData + ' ingressi senza data simulata: il conto per ora dello spread non si potra fare su quelli.') }
  if(-not ($croceOK -and $cfgOK)){ [void]$riepilogo.Add('   >>> ESITO LATO ' + $lato + ': NON AFFIDABILE. La distanza qui sotto e SOLO diagnostica.') }
  else { [void]$riepilogo.Add('   >>> ESITO LATO ' + $lato + ': AFFIDABILE (lettore e configurazione verificati).') }
  if($n -gt 0){
    $ord = @($entr | ForEach-Object { $_.Dist } | Sort-Object)
    [void]$riepilogo.Add('   distanza ingresso->SL, punti indice: min ' + (F2 $ord[0]) + ' | p5 ' + (F2 (Quantile $ord 0.05)) + ' | p25 ' + (F2 (Quantile $ord 0.25)) + ' | MEDIANA ' + (F2 (Quantile $ord 0.5)) + ' | p75 ' + (F2 (Quantile $ord 0.75)) + ' | p95 ' + (F2 (Quantile $ord 0.95)) + ' | max ' + (F2 $ord[$ord.Count-1]))
  }
  for($k = $inizioRiep; $k -lt $riepilogo.Count; $k++){ Write-Host ('   ' + $riepilogo[$k]) }

  # il per-trade dell'EA (ExportTrades, solo tester): controllo in piu'
  $mag = (@($inputs | Where-Object { $_ -like 'InpMagic=*' })[0] -split '=')[1]
  $pt = Join-Path $env:APPDATA ('MetaQuotes\Terminal\Common\Files\abtg_trades_' + $EXPERT + '_' + $SIMBOLO + '_' + $mag + '.csv')
  if((Test-Path -LiteralPath $pt) -and ((Get-Item -LiteralPath $pt).LastWriteTime -ge $t0)){ Copy-Item -LiteralPath $pt -Destination $Cart -Force; Dico ('per-trade raccolto: ' + (Split-Path -Leaf $pt)) 'Green' }
  else { Dico ('per-trade dell EA non trovato fresco per il magic ' + $mag + ' (non blocca: e un controllo in piu)') 'DarkYellow' }

  # il REPORT della passata singola (Report=PASSATA_STOP_<lato>): la tabella
  # degli ORDINI ha le colonne S/L e prezzo, cioe' una SECONDA misura della
  # distanza che non passa dalle Print. Si cerca dove MT5 lo puo' scrivere
  # (RIGA_R99_ORO_RISCHIO.ps1 r.1166: installazione, cartella dati, lavoro).
  $rep = $null
  foreach($rad in @($InstAttesa, $DataFolder, $Work)){
    if(-not (Test-Path -LiteralPath $rad)){ continue }
    $c = @(Get-ChildItem -LiteralPath $rad -Filter ('PASSATA_STOP_' + $lato + '*.htm*') -File -ErrorAction SilentlyContinue | Where-Object { $_.LastWriteTime -ge $t0 } | Sort-Object LastWriteTime -Descending)
    if($c.Count -gt 0){ $rep = $c[0]; break }
  }
  if($rep){ Copy-Item -LiteralPath $rep.FullName -Destination $Cart -Force -ErrorAction SilentlyContinue; Dico ('report della passata raccolto: ' + $rep.FullName) 'Green' }
  else { Dico ('report .htm della passata NON trovato (non blocca: e la seconda misura, si dichiara mancante)') 'DarkYellow' }
}

# ---------------------------------------------------------------------
#  3. RACCOLTA
# ---------------------------------------------------------------------
Titolo '3 - RACCOLTA'
$testa = @(
  'PASSATA STOP SUPREV -- la distanza ingresso->SL, misurata (U30USD H1, ancora R243, finestra SPENTA)',
  ('data: ' + (Get-Date).ToString('yyyy-MM-dd HH:mm:ss') + '   pc: ' + $env:COMPUTERNAME + '   pin: ' + $Pin),
  'backtest a tick reali, deposito 100000, AllowLiveTrading=false: nessun ordine, nessun conto toccato',
  ''
)
(($testa + $riepilogo + @('',
  'COME SI LEGGE: la distanza si confronta con 40 x lo spread dell ORA d ingresso',
  '(spread_orario_U30USD.csv). Quel conto lo fa Claude sul CSV quando torna lo zip:',
  'questo script NON giudica, misura e dice se la misura e affidabile.')) -join "`r`n") | Set-Content -LiteralPath (Join-Path $Cart 'RIEPILOGO_PASSATA.txt') -Encoding ASCII
$zip = Join-Path $dsk 'PASSATA_STOP_SUPREV.zip'
if(Test-Path -LiteralPath $zip){ Remove-Item -LiteralPath $zip -Force -ErrorAction SilentlyContinue }
Compress-Archive -Path (Join-Path $Cart '*') -DestinationPath $zip -Force
Write-Host ''
Write-Host ('ZIP PRONTO DA MANDARE: ' + $zip) -ForegroundColor Green
Write-Host 'FILE ATTESI NELLO ZIP: RIEPILOGO_PASSATA.txt + STOP_SHORT.csv + STOP_LONG.csv + le due .ini (+ i per-trade e i due report .htm, se trovati)' -ForegroundColor Gray
