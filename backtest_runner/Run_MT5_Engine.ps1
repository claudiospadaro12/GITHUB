# Run_MT5_Engine.ps1 - MT5 come "motore di calcolo" passivo: un .set -> config.ini al volo -> terminal64 headless -> report -> verdetto.
# Windows PowerShell 5.1. Solo Strategy Tester (AllowLiveTrading=false). Non chiude mai MT5 con la forza.
# Verdetto per profilo (soglie in config_Template_ORO_BCM.json, sezione "profili"):
#   dentro-campione (candele):  PF > pfIS, operazioni >= opIS, profitto > 0, DD% <= tetto del profilo
#   fuori campione (candele):   PF >= pfOOS, operazioni >= opOOS, profitto > 0, DD% <= tetto del profilo
#   tick reali (se configurato): PF tick / PF candele >= rapportoPfTick
# Chi supera TUTTO -> set + report in "Validati_Pronti_Per_Mercato". Chi fallisce -> eliminato (default, come richiesto)
# oppure spostato in "Scartati" con -Scartati Sposta. Il motivo finisce SEMPRE in Risultati\esiti.csv.
# Se il report non si legge (formato diverso dal previsto) NON si elimina niente: errore e stop.
# Modi:  -Modo Prova   : scrive il .ini del primo set e lo mostra, non lancia MT5.
#        -Modo Esegui  : esegue il verdetto su -Set (un file) oppure su tutti i .set di -Cartella.
# Uso:   .\Run_MT5_Engine.ps1 -Config .\config_Template_ORO_BCM.json -Cartella .\Set_profili -Modo Prova
param(
  [Parameter(Mandatory=$true)][string]$Config,
  [string]$Set = '',
  [string]$Cartella = '',
  [ValidateSet('Prova','Esegui')][string]$Modo = 'Prova',
  [ValidateSet('Elimina','Sposta')][string]$Scartati = 'Elimina'
)
$ErrorActionPreference = 'Continue'
$ci = [Globalization.CultureInfo]::InvariantCulture
$aqui = Split-Path -Parent (Resolve-Path -LiteralPath $Config).Path
$cfg = Get-Content -LiteralPath $Config -Raw -Encoding UTF8 | ConvertFrom-Json
function Percorso([string]$p){ if([IO.Path]::IsPathRooted($p)){ return $p } else { return (Join-Path $aqui $p) } }
if($cfg.computerAmmesso -and $env:COMPUTERNAME -ne $cfg.computerAmmesso){ Write-Host ('Questo script e configurato per il PC ' + $cfg.computerAmmesso + ', qui: ' + $env:COMPUTERNAME) -ForegroundColor Red; return }
$trm = $cfg.terminale; $dati = $cfg.cartellaDati
$dirOk = Percorso $cfg.cartellaValidati; $dirNo = Percorso $cfg.cartellaScartati; $dirRis = Percorso $cfg.cartellaRisultati
$sg = $cfg.soglie
New-Item -ItemType Directory -Force -Path $dirRis | Out-Null
$tmpDir = Join-Path $env:TEMP 'mt5_engine'; New-Item -ItemType Directory -Force -Path $tmpDir | Out-Null
$csvRis = Join-Path $dirRis 'risultati.csv'; $csvEsiti = Join-Path $dirRis 'esiti.csv'; $fileConta = Join-Path $dirRis 'tentativi.json'

# ------------------------------------------------------------------ utilita
function Leggi-Set([string]$p){
  $righe = @()
  foreach($rg in (Get-Content -LiteralPath $p -Encoding UTF8)){ $x = $rg.Trim(); if($x -ne '' -and -not $x.StartsWith(';') -and $x.Contains('=')){ $righe += $x } }
  return $righe
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

# ------------------------------------------------------------------ config.ini al volo
function Scrivi-Ini([string]$setFile,$fin,[int]$modello,[string]$rep){
  $righeSet = Leggi-Set $setFile
  $r = @('[Experts]','AllowLiveTrading=false','AllowDllImport=false','','[Tester]',
    ('Expert=' + $cfg.ea),('Symbol=' + $cfg.simbolo),('Period=' + $cfg.periodo),('Model=' + $modello),'Optimization=0',
    ('FromDate=' + $fin.da),('ToDate=' + $fin.a),'ForwardMode=0',('Deposit=' + $cfg.deposito),('Currency=' + $cfg.valuta),('Leverage=' + $cfg.leva),
    'ExecutionMode=0','Visual=0','ReplaceReport=1','ShutdownTerminal=1',('Report=' + $rep),'','[TesterInputs]')
  foreach($x in $righeSet){ $r += $x.Split('|')[0] }          # TUTTI gli input (lezione del 15/11: una lista parziale azzera gli altri)
  $ini = Join-Path $tmpDir ($rep + '.ini')
  Set-Content -LiteralPath $ini -Value (($r -join "`r`n") + "`r`n") -Encoding ASCII -NoNewline
  return $ini
}

# ------------------------------------------------------------------ analisi del report (HTML; XML provato con lo stesso metodo, NON verificato)
function Cerca([string]$testo,[string]$etichette){
  $m = [regex]::Match($testo,'(?:' + $etichette + ')\|([^|]*)\|')
  if($m.Success){ return $m.Groups[1].Value } else { return $null }
}
function Leggi-Report([string]$file){
  $b = [IO.File]::ReadAllBytes($file)
  if($b.Length -ge 2 -and (($b[0] -eq 255 -and $b[1] -eq 254) -or ($b[0] -eq 254 -and $b[1] -eq 255))){ $t = [Text.Encoding]::Unicode.GetString($b) } else { $t = [Text.Encoding]::UTF8.GetString($b) }
  $t = [regex]::Replace($t,'<[^>]*>','|'); $t = [regex]::Replace($t,'\s*\|[\s|]*','|')
  $ddMax = Cerca $t 'Drawdown Massima:|Equity Drawdown Maximal:'
  $ddRel = Cerca $t 'Drawdown Relativa:|Drawdown Relativo:|Equity Drawdown Relative:'
  $ddE = [double]::NaN; $ddP1 = [double]::NaN; $ddP2 = [double]::NaN
  if($ddMax){ $mm = [regex]::Match($ddMax,'([0-9\s.,]+)\s*\(([0-9.,]+)%\)'); if($mm.Success){ $ddE = Num $mm.Groups[1].Value; $ddP1 = Num $mm.Groups[2].Value } }
  if($ddRel){ $mr = [regex]::Match($ddRel,'([0-9.,]+)%'); if($mr.Success){ $ddP2 = Num $mr.Groups[1].Value } }
  $o = @{}
  $o.profit = Num (Cerca $t 'Profitto Totale Netto:|Total Net Profit:')
  $o.pf = Num (Cerca $t 'Fattore di Profitto:|Profit Factor:')
  $o.trades = Num (Cerca $t 'Numero di Operazioni di Trading Totali:|Total Trades:')
  $o.ddEur = $ddE
  # DD% prudente: il piu alto tra il % della riga massima, il % relativo e (DD in denaro / deposito)
  $cand = @(); if(-not [double]::IsNaN($ddP1)){ $cand += $ddP1 }; if(-not [double]::IsNaN($ddP2)){ $cand += $ddP2 }; if(-not [double]::IsNaN($ddE)){ $cand += ($ddE / [double]$cfg.deposito * 100.0) }
  if($cand.Count -gt 0){ $o.ddPct = ($cand | Measure-Object -Maximum).Maximum } else { $o.ddPct = [double]::NaN }
  $o.qualita = Num (Cerca $t 'Qualit. dello Storico:|History Quality:')
  $o.ticks = Num (Cerca $t 'Ticks:|Tick:')
  return $o
}
function Report-Valido($m){
  return (-not [double]::IsNaN($m.profit)) -and (-not [double]::IsNaN($m.pf)) -and (-not [double]::IsNaN($m.trades)) -and (-not [double]::IsNaN($m.ddPct))
}

# ------------------------------------------------------------------ lancio e attesa
function Esegui-Test([string]$setFile,$fin,[int]$modello){
  $nomeSet = [IO.Path]::GetFileNameWithoutExtension($setFile)
  $rep = 'ENG_' + $nomeSet + '_' + $fin.nome + '_M' + $modello
  $ini = Scrivi-Ini $setFile $fin $modello $rep
  $fileHtm = Join-Path $dati ($rep + '.htm'); $fileXml = Join-Path $dati ($rep + '.xml')
  Remove-Item -LiteralPath $fileHtm, $fileXml -Force -ErrorAction SilentlyContinue
  if($cfg.portable){ $arg = '/portable /config:"' + $ini + '"' } else { $arg = '/config:"' + $ini + '"' }
  $t0 = Get-Date
  $pr = Start-Process -FilePath $trm -ArgumentList $arg -PassThru
  $scade = $t0.AddMinutes([double]$cfg.timeoutMinuti)
  while(-not $pr.HasExited -and (Get-Date) -lt $scade){ Start-Sleep -Seconds 4 }
  if(-not $pr.HasExited){ Write-Host ('TIMEOUT: terminale ancora aperto (PID ' + $pr.Id + '). Non lo chiudo con la forza.') -ForegroundColor Red; return $null }
  $fileRep = $null
  if(Test-Path -LiteralPath $fileHtm){ $fileRep = $fileHtm } elseif(Test-Path -LiteralPath $fileXml){ $fileRep = $fileXml }
  if(-not $fileRep){ Write-Host ('Report non trovato: ' + $fileHtm) -ForegroundColor Red; return $null }
  $m = Leggi-Report $fileRep
  $m.file = $fileRep
  $n = Incrementa-Tentativi
  if(-not (Report-Valido $m)){ Write-Host ('   [' + $n + '] REPORT NON LEGGIBILE: ' + $fileRep + ' (profitto/PF/operazioni/DD non trovati). Non elimino niente.') -ForegroundColor Red; $m.illeggibile = $true; return $m }
  $riga = (Get-Date).ToString('s') + ';' + $nomeSet + ';' + $fin.nome + ';M' + $modello + ';' + $m.profit.ToString($ci) + ';' + $m.pf.ToString($ci) + ';' + $m.trades.ToString($ci) + ';' + $m.ddEur.ToString($ci) + ';' + $m.ddPct.ToString('0.00',$ci)
  if(-not (Test-Path -LiteralPath $csvRis)){ Add-Content -LiteralPath $csvRis -Value 'ora;set;finestra;modello;profitto;PF;operazioni;DD_eur;DD_pct' -Encoding ASCII }
  Add-Content -LiteralPath $csvRis -Value $riga -Encoding ASCII
  Write-Host ('   [' + $n + '] ' + $nomeSet + ' ' + $fin.nome + ' M' + $modello + ': profitto ' + $m.profit.ToString('0.00',$ci) + ', PF ' + $m.pf.ToString('0.00',$ci) + ', operazioni ' + $m.trades + ', DD ' + $m.ddPct.ToString('0.0',$ci) + '%') -ForegroundColor Green
  return $m
}

# ------------------------------------------------------------------ verdetto di un set (Azione 4)
function Verdetto([string]$setFile){
  $nome = [IO.Path]::GetFileNameWithoutExtension($setFile)
  $profilo = $null
  foreach($pn in $cfg.profili.PSObject.Properties.Name){ if($nome.StartsWith($pn)){ $profilo = $cfg.profili.$pn } }
  if(-not $profilo){ return @{ esito = 'ERRORE'; motivi = @('nessun profilo in config per ' + $nome) } }
  $ddMax = [double]$profilo.ddMaxPct
  $motivi = @()
  $finIS = @{ nome = 'IS'; da = $cfg.IS.da; a = $cfg.IS.a }
  $mI = Esegui-Test $setFile $finIS 1
  if(-not $mI -or $mI.illeggibile){ return @{ esito = 'ERRORE'; motivi = @('test dentro-campione non eseguito/illeggibile') } }
  if($mI.pf -le [double]$sg.pfIS){ $motivi += ('IS PF ' + $mI.pf.ToString('0.00',$ci) + ' <= ' + $sg.pfIS) }
  if($mI.trades -lt [double]$sg.opIS){ $motivi += ('IS operazioni ' + $mI.trades + ' < ' + $sg.opIS) }
  if($mI.profit -le 0){ $motivi += 'IS profitto <= 0' }
  if($mI.ddPct -gt $ddMax){ $motivi += ('IS DD ' + $mI.ddPct.ToString('0.0',$ci) + '% > ' + $ddMax + '% del profilo') }
  if($motivi.Count -gt 0){ return @{ esito = 'BOCCIATO'; motivi = $motivi; IS = $mI } }
  Write-Host ('   -> ' + $nome + ': dentro-campione passato, vado al fuori campione') -ForegroundColor Yellow
  $rep = @($mI.file)
  foreach($w in $cfg.OOS){
    $fw = @{ nome = $w.nome; da = $w.da; a = $w.a }
    $mO = Esegui-Test $setFile $fw 1
    if(-not $mO -or $mO.illeggibile){ return @{ esito = 'ERRORE'; motivi = @('OOS ' + $w.nome + ' non eseguito/illeggibile') } }
    $rep += $mO.file
    if($mO.trades -lt [double]$sg.opOOS){ $motivi += ('OOS ' + $w.nome + ': solo ' + $mO.trades + ' operazioni (campione insufficiente)') }
    if($mO.pf -lt [double]$sg.pfOOS -or $mO.profit -le 0){ $motivi += ('OOS ' + $w.nome + ': PF ' + $mO.pf.ToString('0.00',$ci) + ' profitto ' + $mO.profit.ToString('0',$ci)) }
    if($mO.ddPct -gt $ddMax){ $motivi += ('OOS ' + $w.nome + ': DD ' + $mO.ddPct.ToString('0.0',$ci) + '% > ' + $ddMax + '%') }
  }
  if($motivi.Count -eq 0 -and $cfg.TICK){
    $ft = @{ nome = 'TICK'; da = $cfg.TICK.da; a = $cfg.TICK.a }
    $mC = Esegui-Test $setFile $ft 1
    $mT = $null
    for($tent = 1; $tent -le 3 -and -not $mT; $tent++){
      $x = Esegui-Test $setFile $ft 4
      if($x -and -not $x.illeggibile -and $x.ticks -gt 0 -and $x.qualita -ge 99){ $mT = $x } else { Write-Host ('   tick non validi (tentativo ' + $tent + ')') -ForegroundColor Yellow }
    }
    if(-not $mC -or $mC.illeggibile -or -not $mT){ return @{ esito = 'ERRORE'; motivi = @('test a tick non eseguibile') } }
    $rep += $mC.file; $rep += $mT.file
    if($mC.pf -gt 0 -and ($mT.pf / $mC.pf) -lt [double]$sg.rapportoPfTick){ $motivi += ('PF tick/candele ' + ($mT.pf / $mC.pf).ToString('0.00',$ci) + ' < ' + $sg.rapportoPfTick) }
    if($mT.ddPct -gt $ddMax){ $motivi += ('DD a tick ' + $mT.ddPct.ToString('0.0',$ci) + '% > ' + $ddMax + '%') }
  }
  if($motivi.Count -gt 0){ return @{ esito = 'BOCCIATO'; motivi = $motivi; IS = $mI; report = $rep } }
  return @{ esito = 'VALIDATO'; motivi = @(); IS = $mI; report = $rep }
}

# ------------------------------------------------------------------ controlli preliminari
if(-not (Test-Path -LiteralPath $trm)){ Write-Host ('Non trovo il terminale: ' + $trm) -ForegroundColor Red; return }
$elenco = @()
if($Set -ne ''){ $elenco = @(Get-Item -LiteralPath (Percorso $Set)) }
elseif($Cartella -ne ''){ $elenco = @(Get-ChildItem -LiteralPath (Percorso $Cartella) -Filter 'Wim_*.set' | Sort-Object Name) }
else { Write-Host 'Indica -Set <file> oppure -Cartella <cartella con i .set>.' -ForegroundColor Red; return }
if($elenco.Count -eq 0){ Write-Host 'Nessun .set da provare.' -ForegroundColor Red; return }
Write-Host ('Terminale: ' + $trm + ' | portable: ' + $cfg.portable + ' | EA: ' + $cfg.ea + ' | ' + $cfg.simbolo + ' ' + $cfg.periodo + ' | set: ' + $elenco.Count + ' | modo: ' + $Modo) -ForegroundColor Cyan
if($Modo -eq 'Prova'){
  $fProva = @{ nome = 'IS'; da = $cfg.IS.da; a = $cfg.IS.a }
  $ini = Scrivi-Ini $elenco[0].FullName $fProva 1 'ENG_prova'
  Write-Host ('MODO PROVA: nessun test lanciato. Scritto ' + $ini + ' (prime 30 righe):') -ForegroundColor Yellow
  Get-Content -LiteralPath $ini -TotalCount 30 | ForEach-Object { Write-Host ('   ' + $_) }
  Write-Host 'Se le righe sono giuste, e se Template_EA_Wim e compilato nel terminale, lancia -Modo Esegui.' -ForegroundColor Yellow
  return
}
if(@(Get-Process -Name terminal64,metatester64,metaeditor64 -ErrorAction SilentlyContinue).Count -gt 0){ Write-Host 'Ci sono MT5, MetaEditor o agenti del tester aperti: chiudili e rilancia.' -ForegroundColor Red; return }
if(-not ('SvegliaEng.Win' -as [type])){ Add-Type -Namespace SvegliaEng -Name Win -MemberDefinition '[DllImport("kernel32.dll")] public static extern uint SetThreadExecutionState(uint esFlags);' }
[void][SvegliaEng.Win]::SetThreadExecutionState([uint32]2147483651)
New-Item -ItemType Directory -Force -Path $dirOk | Out-Null
if($Scartati -eq 'Sposta'){ New-Item -ItemType Directory -Force -Path $dirNo | Out-Null }
if(-not (Test-Path -LiteralPath $csvEsiti)){ Add-Content -LiteralPath $csvEsiti -Value 'ora;set;esito;motivi' -Encoding ASCII }

foreach($f in $elenco){
  Write-Host ('=== ' + $f.BaseName) -ForegroundColor Cyan
  $v = Verdetto $f.FullName
  Add-Content -LiteralPath $csvEsiti -Value ((Get-Date).ToString('s') + ';' + $f.BaseName + ';' + $v.esito + ';' + ($v.motivi -join ' | ')) -Encoding ASCII
  if($v.esito -eq 'VALIDATO'){
    Copy-Item -LiteralPath $f.FullName -Destination (Join-Path $dirOk $f.Name) -Force
    foreach($rp in $v.report){ if($rp -and (Test-Path -LiteralPath $rp)){ Copy-Item -LiteralPath $rp -Destination $dirOk -Force } }
    Write-Host ('   *** ' + $f.BaseName + ' VALIDATO -> ' + $dirOk + '  (validato su storico: NON vuol dire pronto per un conto: serve il forward in demo)') -ForegroundColor Green
  }
  elseif($v.esito -eq 'BOCCIATO'){
    Write-Host ('   x ' + $f.BaseName + ' BOCCIATO: ' + ($v.motivi -join ' | ')) -ForegroundColor Red
    if($Scartati -eq 'Sposta'){ Move-Item -LiteralPath $f.FullName -Destination (Join-Path $dirNo $f.Name) -Force; Write-Host '      spostato in Scartati' -ForegroundColor Red }
    else { Remove-Item -LiteralPath $f.FullName -Force; Write-Host '      eliminato (il motivo resta in esiti.csv; il set si rigenera con SetGenerator.py)' -ForegroundColor Red }
    $repX = @(); if($v.IS){ $repX += $v.IS.file }; if($v.report){ $repX += $v.report }
    foreach($rp in $repX){ if($rp -and (Test-Path -LiteralPath $rp)){ if($Scartati -eq 'Elimina'){ Remove-Item -LiteralPath $rp -Force -ErrorAction SilentlyContinue } } }
  }
  else {
    Write-Host ('   ! ' + $f.BaseName + ' ' + $v.esito + ': ' + ($v.motivi -join ' | ') + ' - NON toccato') -ForegroundColor Yellow
  }
}
[void][SvegliaEng.Win]::SetThreadExecutionState([uint32]2147483648)
Write-Host ('Finito. Esiti in ' + $csvEsiti + ' | validati in ' + $dirOk) -ForegroundColor Cyan
$ris = Get-Content -LiteralPath $csvEsiti | Select-Object -Last ($elenco.Count)
$ris | Set-Clipboard
Write-Host 'Gli esiti sono copiati negli appunti: incollali (Ctrl+V) nella chat.' -ForegroundColor Yellow
