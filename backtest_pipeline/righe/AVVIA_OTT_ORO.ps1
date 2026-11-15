# MARCATORE_AVVIA_OTT_ORO_v1
# Avvia l'OTTIMIZZAZIONE del pilota oro nel MT5 PORTABLE C:\MT5_BCM_Opt: EA WIM\Ultimate_Breakout_EA_WSC_V9.5, XAUUSD D1, 2013.01.01 -> 2022.12.31, Modello 1 (1 minuto OHLC), deposito 100000 EUR, leva 1:100, algoritmo lento (completo), criterio Custom max, Forward No, agenti locali (niente cloud), set OPT2_ORO.set (4 parametri liberi, 625 passaggi).
# Scrive SOLO: un .ini in %TEMP%\abtg_opt_oro e quello che MT5 scrive da se dentro C:\MT5_BCM_Opt. NON tocca altri terminali, conti, VPS, FTMO, AppData. NON chiude MT5 (a fine ottimizzazione resta aperto: i risultati si esportano a mano). Chiede a Windows di non andare in sospensione finche la finestra e aperta.
$ErrorActionPreference='Continue'
if($env:COMPUTERNAME -ne 'DESKTOP-H4D7CAJ'){ Write-Host ('SOLO sul PC di backtest DESKTOP-H4D7CAJ. Qui: ' + $env:COMPUTERNAME) -ForegroundColor Red; return }
$T='C:\MT5_BCM_Opt\terminal64.exe'; $EA='C:\MT5_BCM_Opt\MQL5\Experts\WIM\Ultimate_Breakout_EA_WSC_V9.5.ex5'; $HEA='AD2A7AC8C56E2756E4FE576F441227D11A2067B78F7BC4D200C76D111FD6EB4A'
$SET='C:\MT5_BCM_Opt\MQL5\Profiles\Tester\OPT2_ORO.set'; $HIST='C:\MT5_BCM_Opt\bases\BCMMarkets-Server\history\XAUUSD'
$aperti=@(Get-Process -Name terminal64,metatester64,metaeditor64 -ErrorAction SilentlyContinue)
if($aperti.Count -gt 0){ $aperti | Select-Object Id,ProcessName,Path | Format-Table -AutoSize | Out-String | Write-Host; Write-Host 'MI FERMO: ci sono MT5, MetaEditor o agenti del tester aperti. Chiudili e rilancia. Non ho avviato niente.' -ForegroundColor Red; return }
foreach($pp in @($T,$EA,$SET,$HIST)){ if(-not (Test-Path -LiteralPath $pp)){ Write-Host ('MI FERMO: non trovo ' + $pp + '. Non ho avviato niente.') -ForegroundColor Red; return } }
$h=(Get-FileHash -LiteralPath $EA -Algorithm SHA256).Hash.ToUpperInvariant(); if($h -ne $HEA){ Write-Host ('MI FERMO: l EA ha SHA256 ' + $h + ' invece di ' + $HEA + '. Non ho avviato niente.') -ForegroundColor Red; return }
$nh=@(Get-ChildItem -LiteralPath $HIST -File -ErrorAction SilentlyContinue).Count
if($nh -lt 20){ Write-Host ('MI FERMO: nello storico XAUUSD del portable ci sono ' + $nh + ' file (ne attendo 23). Non ho avviato niente.') -ForegroundColor Red; return }
$sb=[IO.File]::ReadAllBytes($SET); $st=$(if($sb.Length -ge 2 -and $sb[0] -eq 255 -and $sb[1] -eq 254){ [Text.Encoding]::Unicode.GetString($sb) } else { [Text.Encoding]::UTF8.GetString($sb) })
$ys=@([regex]::Matches($st,'(?m)^([A-Za-z0-9_]+=[^|\r\n]*\|\|[^|\r\n]*\|\|[^|\r\n]*\|\|[^|\r\n]*\|\|Y)\s*$') | ForEach-Object { $_.Groups[1].Value })
if($ys.Count -ne 4){ Write-Host ('MI FERMO: nel set OPT2_ORO.set i parametri attivi sono ' + $ys.Count + ' invece di 4. Non ho avviato niente.') -ForegroundColor Red; return }
$cm=[regex]::Match($st,'(?m)^Risk=([^|\r\n]*)'); $sl=[regex]::Match($st,'(?m)^StartLots=([^|\r\n]*)')
if((-not $cm.Success) -or $cm.Groups[1].Value -ne '0' -or (-not $sl.Success) -or $sl.Groups[1].Value -ne '0.1'){ Write-Host 'MI FERMO: nel set Risk non e 0 o StartLots non e 0.1. Non ho avviato niente.' -ForegroundColor Red; return }
if(-not ('MasterSveglia.Win' -as [type])){ Add-Type -Namespace MasterSveglia -Name Win -MemberDefinition '[DllImport("kernel32.dll")] public static extern uint SetThreadExecutionState(uint esFlags);' }
[void][MasterSveglia.Win]::SetThreadExecutionState([uint32]2147483651)
$W=Join-Path $env:TEMP 'abtg_opt_oro'; New-Item -ItemType Directory -Force -Path $W | Out-Null; $ini=Join-Path $W 'ott_oro.ini'
$righe=@('[Experts]','AllowLiveTrading=false','AllowDllImport=false','','[Tester]','Expert=WIM\Ultimate_Breakout_EA_WSC_V9.5.ex5','ExpertParameters=OPT2_ORO.set','Symbol=XAUUSD','Period=D1','Model=1','Optimization=1','OptimizationCriterion=6','FromDate=2013.01.01','ToDate=2022.12.31','ForwardMode=0','Deposit=100000','Currency=EUR','Leverage=100','ExecutionMode=0','Visual=0','UseLocal=1','UseRemote=0','UseCloud=0','ReplaceReport=1','ShutdownTerminal=0','','[TesterInputs]')
$righe=$righe + $ys
Set-Content -LiteralPath $ini -Value (($righe -join "`r`n") + "`r`n") -Encoding ASCII -NoNewline
$t0=Get-Date
Write-Host ('=== OTTIMIZZAZIONE ORO: XAUUSD D1, 2013-01-01 -> 2022-12-31 (date del server BCM, GMT+1 fisso), Modello 1, 625 passaggi ===') -ForegroundColor Cyan
Write-Host ('Ora italiana del PC all avvio: ' + $t0.ToString('dd/MM/yyyy HH:mm:ss') + '. Fine attesa fra 7 e 10 ore (STIMA, non misurata). Tetto 14 ore.') -ForegroundColor Cyan
Write-Host 'Parametri liberi:' -ForegroundColor Cyan; $ys | ForEach-Object { Write-Host ('   ' + $_) -ForegroundColor Green }
Write-Host 'NON chiudere questa finestra e NON aprire altri MT5: la finestra tiene sveglio il PC. A fine ottimizzazione MT5 resta aperto.' -ForegroundColor Yellow
$p=Start-Process -FilePath $T -ArgumentList ('/portable /config:"' + $ini + '"') -PassThru
$ultimo=0.0; $giri=0
while(-not $p.HasExited){
  Start-Sleep -Seconds 600; $giri=$giri+1
  $ag=@(Get-Process -Name metatester64 -ErrorAction SilentlyContinue)
  $cpu=0.0; foreach($a in $ag){ try{ $cpu=$cpu+$a.TotalProcessorTime.TotalSeconds }catch{ } }
  $delta=$cpu-$ultimo; $ultimo=$cpu
  $durata=((Get-Date)-$t0)
  Write-Host ('[' + (Get-Date).ToString('HH:mm') + ' ora italiana] trascorse ' + [math]::Floor($durata.TotalHours) + ' h ' + $durata.Minutes + ' min; agenti: ' + $ag.Count + '; CPU degli agenti negli ultimi 10 min: ' + [math]::Round($delta) + ' s') -ForegroundColor Gray
  if($giri -ge 3 -and $ag.Count -gt 0 -and $delta -lt 30){ Write-Host '   Gli agenti sembrano fermi: probabilmente l ottimizzazione e FINITA (o bloccata). Guarda la scheda Ottimizzazione in MT5 e mandami la foto.' -ForegroundColor Yellow }
  if($durata.TotalHours -gt 16){ Write-Host 'Oltre 16 ore: non chiudo niente io. Guarda MT5 e dimmi.' -ForegroundColor Red; break }
}
[void][MasterSveglia.Win]::SetThreadExecutionState([uint32]2147483648)
Write-Host ('Fine controllo alle ' + (Get-Date).ToString('dd/MM/yyyy HH:mm') + ' (ora italiana).') -ForegroundColor Cyan
