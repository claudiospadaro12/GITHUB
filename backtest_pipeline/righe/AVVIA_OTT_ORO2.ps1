# MARCATORE_AVVIA_OTT_ORO2_v1
# Rifa l'OTTIMIZZAZIONE del pilota oro (625 passaggi) nel MT5 PORTABLE C:\MT5_BCM_Opt dopo aver trovato che la prima griglia NON misurava il GTP E (il suo C0 dava +1323, la passata singola dello stesso set +4563). Ipotesi (NON verificata): con poche righe in [TesterInputs] gli altri input tornano ai valori di default dell'EA. Qui [TesterInputs] contiene TUTTI gli input del set OPT2_ORO.set (quattro con ||Y).
# Sequenza: E) diagnosi: passata singola con il vecchio ini (ExpertParameters + 4 righe) -> se riproduce +1323 l'ipotesi e confermata; F) controllo BLOCCANTE: passata singola con TUTTI gli input in [TesterInputs], senza ExpertParameters -> deve dare 4563,35 / 253 operazioni (come la passata A del V0); solo se F coincide parte la griglia.
# Scrive SOLO dentro C:\MT5_BCM_Opt (report, log, cache) e .ini in %TEMP%\abtg_opt_oro. NON tocca altri terminali, conti, VPS, FTMO, AppData. A fine griglia MT5 resta aperto.
$ErrorActionPreference='Continue'
if($env:COMPUTERNAME -ne 'DESKTOP-H4D7CAJ'){ Write-Host ('SOLO sul PC di backtest DESKTOP-H4D7CAJ. Qui: ' + $env:COMPUTERNAME) -ForegroundColor Red; return }
$T='C:\MT5_BCM_Opt\terminal64.exe'; $EA='C:\MT5_BCM_Opt\MQL5\Experts\WIM\Ultimate_Breakout_EA_WSC_V9.5.ex5'; $HEA='AD2A7AC8C56E2756E4FE576F441227D11A2067B78F7BC4D200C76D111FD6EB4A'
$SET='C:\MT5_BCM_Opt\MQL5\Profiles\Tester\OPT2_ORO.set'
$aperti=@(Get-Process -Name terminal64,metatester64,metaeditor64 -ErrorAction SilentlyContinue)
if($aperti.Count -gt 0){ $aperti | Select-Object Id,ProcessName,Path | Format-Table -AutoSize | Out-String | Write-Host; Write-Host 'MI FERMO: ci sono MT5, MetaEditor o agenti del tester aperti (anche il MT5 portable rimasto aperto). Chiudili e rilancia. Non ho avviato niente.' -ForegroundColor Red; return }
foreach($pp in @($T,$EA,$SET)){ if(-not (Test-Path -LiteralPath $pp)){ Write-Host ('MI FERMO: non trovo ' + $pp + '. Non ho avviato niente.') -ForegroundColor Red; return } }
$h=(Get-FileHash -LiteralPath $EA -Algorithm SHA256).Hash.ToUpperInvariant(); if($h -ne $HEA){ Write-Host ('MI FERMO: l EA ha SHA256 ' + $h + ' invece di ' + $HEA + '. Non ho avviato niente.') -ForegroundColor Red; return }
$sb=[IO.File]::ReadAllBytes($SET); $st=$(if($sb.Length -ge 2 -and $sb[0] -eq 255 -and $sb[1] -eq 254){ [Text.Encoding]::Unicode.GetString($sb) } else { [Text.Encoding]::UTF8.GetString($sb) })
$tutte=@(); foreach($r in ($st -split "`r?`n")){ $x=$r.Trim([char]0xFEFF).Trim(); if($x -ne '' -and -not $x.StartsWith(';') -and $x.Contains('=')){ $tutte += $x } }
$ys=@($tutte | Where-Object { $_ -match '^[A-Za-z0-9_]+=[^|]*\|\|[^|]*\|\|[^|]*\|\|[^|]*\|\|Y$' })
if($ys.Count -ne 4){ Write-Host ('MI FERMO: nel set i parametri attivi sono ' + $ys.Count + ' invece di 4. Non ho avviato niente.') -ForegroundColor Red; return }
if(@($tutte | Where-Object { $_ -match '^Risk=0\|\|' }).Count -ne 1 -or @($tutte | Where-Object { $_ -match '^StartLots=0\.1\|\|' }).Count -ne 1){ Write-Host 'MI FERMO: nel set Risk non e 0 o StartLots non e 0.1. Non ho avviato niente.' -ForegroundColor Red; return }
Write-Host ('Input letti dal set: ' + $tutte.Count + ' (di cui 4 con ||Y).') -ForegroundColor Cyan
if(-not ('MasterSveglia.Win' -as [type])){ Add-Type -Namespace MasterSveglia -Name Win -MemberDefinition '[DllImport("kernel32.dll")] public static extern uint SetThreadExecutionState(uint esFlags);' }
[void][MasterSveglia.Win]::SetThreadExecutionState([uint32]2147483651)
$W=Join-Path $env:TEMP 'abtg_opt_oro'; New-Item -ItemType Directory -Force -Path $W | Out-Null
function Num([string]$s){ $c=($s -replace '[^0-9.\-]',''); $v=0.0; if([double]::TryParse($c,[Globalization.NumberStyles]::Float,[Globalization.CultureInfo]::InvariantCulture,[ref]$v)){ return $v } else { return [double]::NaN } }
function Passata([string]$nome,[string]$ep,[string[]]$inputs){
  $rep='OPT2_ORO_' + $nome; $ini=Join-Path $W ('ott2_' + $nome + '.ini')
  $r=@('[Experts]','AllowLiveTrading=false','AllowDllImport=false','','[Tester]','Expert=WIM\Ultimate_Breakout_EA_WSC_V9.5.ex5'); if($ep -ne ''){ $r += ('ExpertParameters=' + $ep) }
  $r += @('Symbol=XAUUSD','Period=D1','Model=1','Optimization=0','FromDate=2013.01.01','ToDate=2022.12.31','ForwardMode=0','Deposit=100000','Currency=EUR','Leverage=100','ExecutionMode=0','Visual=0','ReplaceReport=1','ShutdownTerminal=1',('Report=' + $rep),'','[TesterInputs]'); $r += $inputs
  Set-Content -LiteralPath $ini -Value (($r -join "`r`n") + "`r`n") -Encoding ASCII -NoNewline
  Remove-Item -LiteralPath ('C:\MT5_BCM_Opt\' + $rep + '.htm') -Force -ErrorAction SilentlyContinue
  $t0=Get-Date; Write-Host ('[' + $t0.ToString('HH:mm:ss') + ' ora italiana] passata ' + $nome + ' ...') -ForegroundColor Cyan
  $p=Start-Process -FilePath $T -ArgumentList ('/portable /config:"' + $ini + '"') -PassThru
  $scade=$t0.AddMinutes(40); while(-not $p.HasExited -and (Get-Date) -lt $scade){ Start-Sleep -Seconds 5 }
  if(-not $p.HasExited){ Write-Host ('TIMEOUT: il terminale PID ' + $p.Id + ' e ancora aperto: chiudilo a mano.') -ForegroundColor Red; return $null }
  $rf=Join-Path 'C:\MT5_BCM_Opt' ($rep + '.htm'); if(-not (Test-Path -LiteralPath $rf)){ Write-Host ('Report ' + $rep + ' NON trovato.') -ForegroundColor Red; return $null }
  $b=[IO.File]::ReadAllBytes($rf); $tx=$(if($b.Length -ge 2 -and (($b[0] -eq 255 -and $b[1] -eq 254) -or ($b[0] -eq 254 -and $b[1] -eq 255))){ [Text.Encoding]::Unicode.GetString($b) } else { [Text.Encoding]::UTF8.GetString($b) })
  $tx=[regex]::Replace($tx,'<[^>]*>','|'); $tx=[regex]::Replace($tx,'\s*\|[\s|]*','|')
  $g1=[regex]::Match($tx,'Profitto Totale Netto:\|([^|]*)\|'); $g2=[regex]::Match($tx,'Numero di Operazioni di Trading Totali:\|([^|]*)\|'); $g3=[regex]::Match($tx,'Fattore di Profitto:\|([^|]*)\|')
  return @{ prof=$(if($g1.Success){ Num $g1.Groups[1].Value } else { [double]::NaN }); ops=$(if($g2.Success){ Num $g2.Groups[1].Value } else { [double]::NaN }); pf=$(if($g3.Success){ Num $g3.Groups[1].Value } else { [double]::NaN }) }
}
$e=Passata 'E' 'OPT2_ORO.set' $ys
if($e){ Write-Host ('   E (ExpertParameters + 4 righe, come la prima griglia): profitto ' + $e.prof + ', operazioni ' + $e.ops + ', PF ' + $e.pf + '   [la griglia dava 1323,40 / 286 / 1,65; la passata A dava 4563,35 / 253 / 2,19]') -ForegroundColor Yellow }
$f=Passata 'F' '' $tutte
if(-not $f){ Write-Host 'MI FERMO: la passata F non e finita. Non parte la griglia.' -ForegroundColor Red; [void][MasterSveglia.Win]::SetThreadExecutionState([uint32]2147483648); return }
Write-Host ('   F (TUTTI gli input in [TesterInputs], senza ExpertParameters): profitto ' + $f.prof + ', operazioni ' + $f.ops + ', PF ' + $f.pf + '   [atteso 4563,35 / 253 / 2,19]') -ForegroundColor Yellow
if([double]::IsNaN($f.prof) -or [math]::Abs($f.prof - 4563.35) -gt 0.5 -or $f.ops -ne 253){ Write-Host 'MI FERMO: F NON riproduce la passata A (4563,35 / 253). Non parte la griglia: mandami questa schermata.' -ForegroundColor Red; try{ Set-Clipboard -Value ('E: ' + $(if($e){ '' + $e.prof + ' / ' + $e.ops + ' / ' + $e.pf } else { 'n.d.' }) + ' | F: ' + $f.prof + ' / ' + $f.ops + ' / ' + $f.pf) }catch{ }; [void][MasterSveglia.Win]::SetThreadExecutionState([uint32]2147483648); return }
Write-Host 'F riproduce A: il metodo con TUTTI gli input e corretto. Parte la griglia.' -ForegroundColor Green
$ini=Join-Path $W 'ott2_griglia.ini'
$r=@('[Experts]','AllowLiveTrading=false','AllowDllImport=false','','[Tester]','Expert=WIM\Ultimate_Breakout_EA_WSC_V9.5.ex5','Symbol=XAUUSD','Period=D1','Model=1','Optimization=1','OptimizationCriterion=6','FromDate=2013.01.01','ToDate=2022.12.31','ForwardMode=0','Deposit=100000','Currency=EUR','Leverage=100','ExecutionMode=0','Visual=0','UseLocal=1','UseRemote=0','UseCloud=0','ReplaceReport=1','ShutdownTerminal=0','','[TesterInputs]'); $r += $tutte
Set-Content -LiteralPath $ini -Value (($r -join "`r`n") + "`r`n") -Encoding ASCII -NoNewline
$t0=Get-Date
Write-Host ('=== GRIGLIA ORO (2a): XAUUSD D1, 2013-01-01 -> 2022-12-31 (date del server BCM, GMT+1 fisso), Modello 1, 625 passaggi ===') -ForegroundColor Cyan
Write-Host ('Ora italiana del PC all avvio: ' + $t0.ToString('dd/MM/yyyy HH:mm:ss') + '. Fine attesa fra 7 e 8 ore (la prima griglia: circa 7 h 30). Il passaggio CENTRALE (550/480/600/1700) deve dare 4563,35 / 253.') -ForegroundColor Cyan
$ys | ForEach-Object { Write-Host ('   ' + $_) -ForegroundColor Green }
Write-Host 'NON chiudere questa finestra e NON aprire altri MT5: la finestra tiene sveglio il PC. A fine griglia MT5 resta aperto.' -ForegroundColor Yellow
$p=Start-Process -FilePath $T -ArgumentList ('/portable /config:"' + $ini + '"') -PassThru
$ultimo=0.0; $giri=0
while(-not $p.HasExited){
  Start-Sleep -Seconds 600; $giri=$giri+1
  $ag=@(Get-Process -Name metatester64 -ErrorAction SilentlyContinue)
  $cpu=0.0; foreach($a in $ag){ try{ $cpu=$cpu+$a.TotalProcessorTime.TotalSeconds }catch{ } }
  $delta=$cpu-$ultimo; $ultimo=$cpu; $durata=((Get-Date)-$t0)
  Write-Host ('[' + (Get-Date).ToString('HH:mm') + ' ora italiana] trascorse ' + [math]::Floor($durata.TotalHours) + ' h ' + $durata.Minutes + ' min; agenti: ' + $ag.Count + '; CPU agenti negli ultimi 10 min: ' + [math]::Round($delta) + ' s') -ForegroundColor Gray
  if($giri -ge 3 -and $ag.Count -gt 0 -and $delta -lt 30){ Write-Host '   Gli agenti sembrano fermi: probabilmente la griglia e FINITA (o bloccata). Guarda la scheda Ottimizzazione in MT5 e mandami la foto.' -ForegroundColor Yellow }
  if($durata.TotalHours -gt 16){ Write-Host 'Oltre 16 ore: non chiudo niente io. Guarda MT5 e dimmi.' -ForegroundColor Red; break }
}
[void][MasterSveglia.Win]::SetThreadExecutionState([uint32]2147483648)
Write-Host ('Fine controllo alle ' + (Get-Date).ToString('dd/MM/yyyy HH:mm') + ' (ora italiana).') -ForegroundColor Cyan
