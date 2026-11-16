# BacktestRunner.ps1 - backtest di EA su MetaTrader 5 da riga di comando, con filtro walk-forward (Azioni 2 e 3).
# Windows PowerShell 5.1. NON invia ordini ai conti (AllowLiveTrading=false): usa solo lo Strategy Tester. Non chiude mai MT5 con la forza.
# Modi:  -Modo Prova     : controlla file e cartelle, scrive il .ini del primo test e lo mostra. NON lancia MT5.
#        -Modo Controllo : un solo test (la baseline sul dentro-campione) per verificare che i numeri siano quelli attesi.
#        -Modo Loop      : tutti i set della cartella -> filtro dentro-campione (PF > soglia) -> fuori campione a candele e a tick reali
#                          -> test di perturbazione -> copia in "Validati" solo chi supera TUTTO.
# Uso:   .\BacktestRunner.ps1 -Config .\config_EMA200_BCM.json -Modo Prova
param(
  [Parameter(Mandatory=$true)][string]$Config,
  [ValidateSet('Prova','Controllo','Loop')][string]$Modo = 'Prova'
)
$ErrorActionPreference = 'Continue'
$ci = [Globalization.CultureInfo]::InvariantCulture
$aqui = Split-Path -Parent (Resolve-Path -LiteralPath $Config).Path
$cfg = Get-Content -LiteralPath $Config -Raw -Encoding UTF8 | ConvertFrom-Json
function Percorso([string]$p){ if([IO.Path]::IsPathRooted($p)){ return $p } else { return (Join-Path $aqui $p) } }
if($cfg.computerAmmesso -and $env:COMPUTERNAME -ne $cfg.computerAmmesso){ Write-Host ('Questo script e configurato per il PC ' + $cfg.computerAmmesso + ', qui: ' + $env:COMPUTERNAME) -ForegroundColor Red; return }
$trm = $cfg.terminale; $dati = $cfg.cartellaDati
$dirSet = Percorso $cfg.cartellaSet; $dirVal = Percorso $cfg.cartellaValidati; $dirRis = Percorso $cfg.cartellaRisultati
$fileRuoli = Percorso $cfg.ruoli
$sg = $cfg.soglie
New-Item -ItemType Directory -Force -Path $dirVal, $dirRis | Out-Null
$tmpDir = Join-Path $env:TEMP 'backtest_runner'; New-Item -ItemType Directory -Force -Path $tmpDir | Out-Null
$csvRis = Join-Path $dirRis 'risultati.csv'; $fileConta = Join-Path $dirRis 'tentativi.json'

# ------------------------------------------------------------------ utilita
function Leggi-Set([string]$p){
  $righe = @()
  foreach($rg in (Get-Content -LiteralPath $p -Encoding UTF8)){ $x = $rg.Trim(); if($x -ne '' -and -not $x.StartsWith(';') -and $x.Contains('=')){ $righe += $x } }
  return $righe
}
function Valore-Set($righe,[string]$nome){
  foreach($x in $righe){ if($x.StartsWith($nome + '=')){ return $x.Substring($nome.Length + 1).Split('|')[0] } }
  return $null
}
function Num([string]$s){
  $c = ($s -replace '[^0-9.\-]','')
  $v = 0.0
  if([double]::TryParse($c,[Globalization.NumberStyles]::Float,$ci,[ref]$v)){ return $v } else { return [double]::NaN }
}
function Incrementa-Tentativi(){
  $n = 0
  if(Test-Path -LiteralPath $fileConta){ try { $n = [int]((Get-Content -LiteralPath $fileConta -Raw | ConvertFrom-Json).passate) } catch { $n = 0 } }
  $n = $n + 1
  Set-Content -LiteralPath $fileConta -Value ('{"passate": ' + $n + '}') -Encoding ASCII
  return $n
}
function Mesi([string]$da,[string]$a){
  $d1 = [datetime]::ParseExact($da,'yyyy.MM.dd',$ci); $d2 = [datetime]::ParseExact($a,'yyyy.MM.dd',$ci)
  $m = ($d2 - $d1).TotalDays / 30.4375
  if($m -lt 1){ return 1.0 } else { return $m }
}
function Mediana($valori){
  $o = @($valori | Sort-Object)
  if($o.Count -eq 0){ return [double]::NaN }
  $mid = [math]::Floor($o.Count / 2)
  if($o.Count % 2 -eq 1){ return [double]$o[$mid] } else { return ([double]$o[$mid - 1] + [double]$o[$mid]) / 2 }
}

# ------------------------------------------------------------------ Azione 2: .ini dinamico, lancio, lettura del report
function Scrivi-Ini([string]$setFile,$fin,[int]$modello,[string]$rep){
  $righeSet = Leggi-Set $setFile
  $r = @('[Experts]','AllowLiveTrading=false','AllowDllImport=false','','[Tester]',
    ('Expert=' + $cfg.ea),('Symbol=' + $cfg.simbolo),('Period=' + $cfg.periodo),('Model=' + $modello),'Optimization=0',
    ('FromDate=' + $fin.da),('ToDate=' + $fin.a),'ForwardMode=0',('Deposit=' + $cfg.deposito),('Currency=' + $cfg.valuta),('Leverage=' + $cfg.leva),
    'ExecutionMode=0','Visual=0','ReplaceReport=1','ShutdownTerminal=1',('Report=' + $rep),'','[TesterInputs]')
  foreach($x in $righeSet){ $r += $x.Split('|')[0] }
  $ini = Join-Path $tmpDir ($rep + '.ini')
  Set-Content -LiteralPath $ini -Value (($r -join "`r`n") + "`r`n") -Encoding ASCII -NoNewline
  return $ini
}
function Cerca([string]$testo,[string]$etichette){
  $m = [regex]::Match($testo,'(?:' + $etichette + ')\|([^|]*)\|')
  if($m.Success){ return $m.Groups[1].Value } else { return $null }
}
function Leggi-Report([string]$file){
  $b = [IO.File]::ReadAllBytes($file)
  if($b.Length -ge 2 -and (($b[0] -eq 255 -and $b[1] -eq 254) -or ($b[0] -eq 254 -and $b[1] -eq 255))){ $t = [Text.Encoding]::Unicode.GetString($b) } else { $t = [Text.Encoding]::UTF8.GetString($b) }
  $t = [regex]::Replace($t,'<[^>]*>','|'); $t = [regex]::Replace($t,'\s*\|[\s|]*','|')
  $dd = Cerca $t 'Drawdown Massima:|Equity Drawdown Maximal:'
  $ddE = [double]::NaN; $ddP = [double]::NaN
  if($dd){ $mm = [regex]::Match($dd,'([0-9\s.,]+)\s*\(([0-9.,]+)%\)'); if($mm.Success){ $ddE = Num $mm.Groups[1].Value; $ddP = Num $mm.Groups[2].Value } }
  $o = @{}
  $o.profit = Num (Cerca $t 'Profitto Totale Netto:|Total Net Profit:')
  $o.pf = Num (Cerca $t 'Fattore di Profitto:|Profit Factor:')
  $o.trades = Num (Cerca $t 'Numero di Operazioni di Trading Totali:|Total Trades:')
  $o.recovery = Num (Cerca $t 'Fattore di Recupero:|Recovery Factor:')
  $o.ddEur = $ddE; $o.ddPct = $ddP
  $o.qualita = Num (Cerca $t 'Qualit. dello Storico:|History Quality:')
  $o.ticks = Num (Cerca $t 'Ticks:|Tick:')
  $o.barre = Num (Cerca $t 'Barre:|Bars:')
  return $o
}
function Esegui-Test([string]$setFile,$fin,[int]$modello){
  $nomeSet = [IO.Path]::GetFileNameWithoutExtension($setFile)
  $rep = 'BR_' + $nomeSet + '_' + $fin.nome + '_M' + $modello
  $ini = Scrivi-Ini $setFile $fin $modello $rep
  $fileRep = Join-Path $dati ($rep + '.htm')
  Remove-Item -LiteralPath $fileRep -Force -ErrorAction SilentlyContinue
  if($cfg.portable){ $arg = '/portable /config:"' + $ini + '"' } else { $arg = '/config:"' + $ini + '"' }
  $t0 = Get-Date
  $pr = Start-Process -FilePath $trm -ArgumentList $arg -PassThru
  $scade = $t0.AddMinutes([double]$cfg.timeoutMinuti)
  while(-not $pr.HasExited -and (Get-Date) -lt $scade){ Start-Sleep -Seconds 4 }
  if(-not $pr.HasExited){ Write-Host ('TIMEOUT: il terminale (PID ' + $pr.Id + ') e ancora aperto. Non lo chiudo con la forza: chiudilo tu e rilancia.') -ForegroundColor Red; return $null }
  if(-not (Test-Path -LiteralPath $fileRep)){ Write-Host ('Report non trovato: ' + $fileRep) -ForegroundColor Red; return $null }
  $m = Leggi-Report $fileRep
  $n = Incrementa-Tentativi
  $riga = (Get-Date).ToString('s') + ';' + $nomeSet + ';' + $fin.nome + ';M' + $modello + ';' + $m.profit.ToString($ci) + ';' + $m.pf.ToString($ci) + ';' + $m.trades.ToString($ci) + ';' + $m.ddEur.ToString($ci) + ';' + $m.recovery.ToString($ci) + ';' + $m.qualita.ToString($ci) + ';' + $m.ticks.ToString($ci)
  if(-not (Test-Path -LiteralPath $csvRis)){ Add-Content -LiteralPath $csvRis -Value 'ora;set;finestra;modello;profitto;PF;operazioni;DD_eur;recupero;qualita;tick' -Encoding ASCII }
  Add-Content -LiteralPath $csvRis -Value $riga -Encoding ASCII
  Write-Host ('   [' + $n + '] ' + $nomeSet + ' ' + $fin.nome + ' M' + $modello + ': profitto ' + $m.profit.ToString('0.00',$ci) + ', PF ' + $m.pf.ToString('0.00',$ci) + ', operazioni ' + $m.trades + ', DD ' + $m.ddEur.ToString('0.0',$ci) + ', qualita ' + $m.qualita + '%') -ForegroundColor Green
  return $m
}
function Esegui-Tick([string]$setFile,$fin){
  # a tick reali la prima passata puo fallire (tick da scaricare, connessione): fino a 3 tentativi, richiede qualita >= 99%
  for($tent = 1; $tent -le 3; $tent++){
    $m = Esegui-Test $setFile $fin 4
    if($m -and $m.ticks -gt 0 -and $m.qualita -ge 99){ return $m }
    Write-Host ('   tick non validi (tentativo ' + $tent + '): ripeto') -ForegroundColor Yellow
  }
  return $null
}

# ------------------------------------------------------------------ vicini (perturbazione, regola R2: un passo a sinistra e uno a destra)
function Crea-Vicini([string]$setFile){
  $ruoli = Get-Content -LiteralPath $fileRuoli -Raw -Encoding UTF8 | ConvertFrom-Json
  $righeSet = Leggi-Set $setFile
  $nomeSet = [IO.Path]::GetFileNameWithoutExtension($setFile)
  $elenco = @()
  foreach($p in $ruoli.parametri){
    $v0 = [double]::Parse((Valore-Set $righeSet $p.nome),$ci)
    foreach($k in @(-1,1)){
      $v = $v0 + $k * [double]$p.passo
      $lo = $null; if($p.min -ne $null){ $lo = [double]$p.min }
      if($p.tipo -eq 'sl' -or $p.tipo -eq 'tp'){ $pav = 0.5 * $v0; if($lo -eq $null -or $pav -gt $lo){ $lo = $pav } }
      if($lo -ne $null -and $v -lt $lo){ $v = $lo }
      if($p.max -ne $null -and $v -gt [double]$p.max){ $v = [double]$p.max }
      if([math]::Abs($v - $v0) -lt 1e-9){ continue }
      $nuove = @()
      foreach($x in $righeSet){ if($x.StartsWith($p.nome + '=')){ $nuove += ($p.nome + '=' + $v.ToString('0.####',$ci)) } else { $nuove += $x } }
      $f = Join-Path $tmpDir ($nomeSet + '_V_' + $p.nome + '_' + $k + '.set')
      Set-Content -LiteralPath $f -Value ($nuove -join "`r`n") -Encoding ASCII
      $elenco += $f
    }
  }
  return $elenco
}

# ------------------------------------------------------------------ controlli preliminari
if(-not (Test-Path -LiteralPath $trm)){ Write-Host ('Non trovo il terminale: ' + $trm) -ForegroundColor Red; return }
if(-not (Test-Path -LiteralPath $dirSet)){ Write-Host ('Non trovo la cartella dei set: ' + $dirSet) -ForegroundColor Red; return }
$fileSet = @(Get-ChildItem -LiteralPath $dirSet -Filter 'S*.set' | Sort-Object Name)
if($fileSet.Count -eq 0){ Write-Host ('Nessun file S*.set in ' + $dirSet) -ForegroundColor Red; return }
$fileBase = Join-Path $dirSet $cfg.baseline
if(-not (Test-Path -LiteralPath $fileBase)){ Write-Host ('Non trovo la baseline: ' + $fileBase) -ForegroundColor Red; return }
Write-Host ('Terminale: ' + $trm + '  | portable: ' + $cfg.portable + '  | set trovati: ' + $fileSet.Count + '  | modo: ' + $Modo) -ForegroundColor Cyan
Write-Host ('Finestra dentro-campione: ' + $cfg.IS.da + ' -> ' + $cfg.IS.a + '  | simbolo ' + $cfg.simbolo + ' ' + $cfg.periodo) -ForegroundColor Cyan
$finIS = @{ nome = 'IS'; da = $cfg.IS.da; a = $cfg.IS.a }
if($Modo -eq 'Prova'){
  $ini = Scrivi-Ini $fileBase $finIS 1 'BR_prova'
  Write-Host ('MODO PROVA: nessun test lanciato. Scritto ' + $ini + ' (prime righe):') -ForegroundColor Yellow
  Get-Content -LiteralPath $ini -TotalCount 28 | ForEach-Object { Write-Host ('   ' + $_) }
  Write-Host 'Se le righe sono giuste, lancia -Modo Controllo (un solo test).' -ForegroundColor Yellow
  return
}
if(@(Get-Process -Name terminal64,metatester64,metaeditor64 -ErrorAction SilentlyContinue).Count -gt 0){ Write-Host 'Ci sono MT5, MetaEditor o agenti del tester aperti: chiudili e rilancia.' -ForegroundColor Red; return }
if(-not ('SvegliaBR.Win' -as [type])){ Add-Type -Namespace SvegliaBR -Name Win -MemberDefinition '[DllImport("kernel32.dll")] public static extern uint SetThreadExecutionState(uint esFlags);' }
[void][SvegliaBR.Win]::SetThreadExecutionState([uint32]2147483651)

# ------------------------------------------------------------------ baseline (controllo)
Write-Host '1) Baseline sul dentro-campione:' -ForegroundColor Cyan
$mBase = Esegui-Test $fileBase $finIS 1
if(-not $mBase){ Write-Host 'La baseline non e stata eseguita: mi fermo.' -ForegroundColor Red; [void][SvegliaBR.Win]::SetThreadExecutionState([uint32]2147483648); return }
if($Modo -eq 'Controllo'){ Write-Host 'Modo Controllo finito: confronta questi numeri con quelli che ti aspetti.' -ForegroundColor Yellow; [void][SvegliaBR.Win]::SetThreadExecutionState([uint32]2147483648); return }

# ------------------------------------------------------------------ Azione 3: walk-forward e gating
$validati = @(); $esiti = @()
$ddMaxIS = [double]$sg.ddIS_vs_base * $mBase.ddEur
Write-Host ('2) Dentro-campione (soglie: PF > ' + $sg.pfIS + ', operazioni >= ' + $sg.opIS + ', DD <= ' + $ddMaxIS.ToString('0',$ci) + ' EUR, profitto > 0):') -ForegroundColor Cyan
foreach($fs in $fileSet){
  $mIS = $null
  if($fs.FullName -eq (Resolve-Path -LiteralPath $fileBase).Path){ $mIS = $mBase } else { $mIS = Esegui-Test $fs.FullName $finIS 1 }
  if(-not $mIS){ $esiti += ($fs.BaseName + ';ERRORE_IS'); continue }
  $okIS = ($mIS.pf -gt [double]$sg.pfIS) -and ($mIS.trades -ge [double]$sg.opIS) -and ($mIS.profit -gt 0) -and ($mIS.ddEur -le $ddMaxIS)
  if(-not $okIS){ $esiti += ($fs.BaseName + ';scartato_IS'); continue }
  Write-Host ('   -> ' + $fs.BaseName + ' PROMOSSO al fuori campione') -ForegroundColor Yellow
  $ok = $true; $motivi = @()
  # fuori campione a candele
  foreach($w in $cfg.OOS){
    $fw = @{ nome = $w.nome; da = $w.da; a = $w.a }
    $mO = Esegui-Test $fs.FullName $fw 1
    if(-not $mO){ $ok = $false; $motivi += ('OOS ' + $w.nome + ' non eseguito'); break }
    if($mO.trades -lt [double]$sg.opOOS){ $ok = $false; $motivi += ('OOS ' + $w.nome + ': campione insufficiente (' + $mO.trades + ' operazioni)') }
    if($mO.pf -lt [double]$sg.pfOOS -or $mO.profit -le 0){ $ok = $false; $motivi += ('OOS ' + $w.nome + ': PF ' + $mO.pf.ToString('0.00',$ci) + ' / profitto ' + $mO.profit.ToString('0',$ci)) }
    $wfe = ($mO.profit / (Mesi $w.da $w.a)) / ($mIS.profit / (Mesi $cfg.IS.da $cfg.IS.a))
    if($wfe -lt [double]$sg.wfe){ $ok = $false; $motivi += ('OOS ' + $w.nome + ': efficienza walk-forward ' + $wfe.ToString('0.00',$ci) + ' < ' + $sg.wfe) }
  }
  # fuori campione a tick reali contro candele sulla stessa finestra
  if($ok -and $cfg.TICK){
    $ft = @{ nome = 'TICK'; da = $cfg.TICK.da; a = $cfg.TICK.a }
    $mC = Esegui-Test $fs.FullName $ft 1
    $mT = Esegui-Tick $fs.FullName $ft
    if(-not $mC -or -not $mT){ $ok = $false; $motivi += 'test a tick non eseguibile' }
    else {
      if($mC.pf -gt 0 -and ($mT.pf / $mC.pf) -lt [double]$sg.rapportoPfTick){ $ok = $false; $motivi += ('rapporto PF tick/candele ' + ($mT.pf / $mC.pf).ToString('0.00',$ci)) }
      if($mC.ddEur -gt 0 -and ($mT.ddEur / $mC.ddEur) -gt [double]$sg.ddTickMax){ $ok = $false; $motivi += ('DD tick ' + ($mT.ddEur / $mC.ddEur).ToString('0.00',$ci) + ' x candele') }
      if($mC.trades -gt 0 -and [math]::Abs($mT.trades / $mC.trades - 1) -gt [double]$sg.opTickTol){ $ok = $false; $motivi += ('operazioni tick ' + $mT.trades + ' contro ' + $mC.trades) }
    }
  }
  # perturbazione: almeno la quota richiesta dei vicini in profitto e PF mediano >= 0.8 x quello base
  if($ok){
    $vic = @(Crea-Vicini $fs.FullName); $pfv = @(); $inProfitto = 0
    foreach($fv in $vic){ $mV = Esegui-Test $fv $finIS 1; if($mV){ $pfv += $mV.pf; if($mV.profit -gt 0){ $inProfitto++ } } }
    if($vic.Count -gt 0){
      $quota = $inProfitto / $vic.Count; $mediano = Mediana $pfv
      if($quota -lt [double]$sg.vicini_in_profitto -or $mediano -lt 0.8 * $mIS.pf){ $ok = $false; $motivi += ('perturbazione: ' + $inProfitto + '/' + $vic.Count + ' vicini in profitto, PF mediano ' + $mediano.ToString('0.00',$ci)) }
    }
  }
  if($ok){
    Copy-Item -LiteralPath $fs.FullName -Destination (Join-Path $dirVal $fs.Name) -Force
    Set-Content -LiteralPath (Join-Path $dirVal ($fs.BaseName + '.metriche.txt')) -Value ('IS: profitto ' + $mIS.profit + ' PF ' + $mIS.pf + ' operazioni ' + $mIS.trades + ' DD ' + $mIS.ddEur) -Encoding ASCII
    $validati += $fs.BaseName; $esiti += ($fs.BaseName + ';VALIDATO')
    Write-Host ('   *** ' + $fs.BaseName + ' VALIDATO: copiato in ' + $dirVal) -ForegroundColor Green
  } else {
    $esiti += ($fs.BaseName + ';bocciato;' + ($motivi -join ' | '))
    Write-Host ('   x ' + $fs.BaseName + ' bocciato: ' + ($motivi -join ' | ')) -ForegroundColor Red
  }
}
Set-Content -LiteralPath (Join-Path $dirRis 'esiti.csv') -Value $esiti -Encoding ASCII
[void][SvegliaBR.Win]::SetThreadExecutionState([uint32]2147483648)
$nt = 0; if(Test-Path -LiteralPath $fileConta){ $nt = (Get-Content -LiteralPath $fileConta -Raw | ConvertFrom-Json).passate }
Write-Host ('FINE: set provati ' + $fileSet.Count + ', validati ' + $validati.Count + '. Passate totali nel contatore di campagna: ' + $nt + ' (piu si prova, piu alto il rischio di falsi positivi: tienine conto).') -ForegroundColor Cyan
Write-Host ('Risultati: ' + $csvRis + '  | esiti: ' + (Join-Path $dirRis 'esiti.csv')) -ForegroundColor Cyan
