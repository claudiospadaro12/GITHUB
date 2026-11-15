# MARCATORE_PROVA_EURUSD_OPT_v1
# Prima passata del pilota di ottimizzazione sul MT5 PORTABLE C:\MT5_BCM_Opt: set base daytrade 2(DAILY)\optimization.set (copiato come OPT1_BASE.set), EURUSD D1, 2013.01.01 -> 2022.12.31, Modello 1, deposito 100000 EUR, input del set (lotto 0,01). Serve a scaricare i dati, misurare il tempo e contare le operazioni.
# Scrive SOLO: un file .ini in %TEMP%\abtg_opt_prova, la copia OPT1_BASE.set in C:\MT5_BCM_Opt\MQL5\Profiles\Tester e quello che MT5 scrive da se dentro C:\MT5_BCM_Opt (report, log, cache). NON tocca gli altri terminali, i conti, il VPS, ne le cartelle dati in AppData. NON chiude MAI un terminale con la forza.
$ErrorActionPreference='Continue'
if($env:COMPUTERNAME -ne 'DESKTOP-H4D7CAJ'){ Write-Host ('SOLO sul PC di backtest DESKTOP-H4D7CAJ. Qui: ' + $env:COMPUTERNAME) -ForegroundColor Red; return }
$T='C:\MT5_BCM_Opt\terminal64.exe'; $EA='C:\MT5_BCM_Opt\MQL5\Experts\WIM\Ultimate_Breakout_EA_WSC_V9.5.ex5'; $HEA='AD2A7AC8C56E2756E4FE576F441227D11A2067B78F7BC4D200C76D111FD6EB4A'
$aperti=@(Get-Process -Name terminal64,metatester64,metaeditor64 -ErrorAction SilentlyContinue)
if($aperti.Count -gt 0){ $aperti | Select-Object Id,ProcessName,Path | Format-Table -AutoSize | Out-String | Write-Host; Write-Host 'MI FERMO: ci sono MT5, MetaEditor o agenti del tester aperti (elenco sopra). Chiudili e rilancia. Non ho avviato niente.' -ForegroundColor Red; return }
if(-not (Test-Path -LiteralPath $T)){ Write-Host ('MI FERMO: non trovo ' + $T + '. Non ho avviato niente.') -ForegroundColor Red; return }
if(-not (Test-Path -LiteralPath $EA)){ Write-Host ('MI FERMO: non trovo l EA ' + $EA + '. Non ho avviato niente.') -ForegroundColor Red; return }
$h=(Get-FileHash -LiteralPath $EA -Algorithm SHA256).Hash.ToUpperInvariant(); if($h -ne $HEA){ Write-Host ('MI FERMO: l EA ha SHA256 ' + $h + ' invece di ' + $HEA + '. Non ho avviato niente.') -ForegroundColor Red; return }
$SB='C:\MT5_BCM_Opt\MQL5\Profiles\Tester\UBS_V9_0\Breakout_Support_Resistance\Other sets\daytrade 2(DAILY)\optimization.set'; if(-not (Test-Path -LiteralPath $SB)){ Write-Host ('MI FERMO: non trovo il set base ' + $SB + '. Non ho avviato niente.') -ForegroundColor Red; return }; Copy-Item -LiteralPath $SB -Destination 'C:\MT5_BCM_Opt\MQL5\Profiles\Tester\OPT1_BASE.set' -Force
$W=Join-Path $env:TEMP 'abtg_opt_prova'; New-Item -ItemType Directory -Force -Path $W | Out-Null
$ini=Join-Path $W 'prova_eurusd_opt.ini'; $rep='PROVA_EURUSD_OPT'
$righe=@('[Experts]','AllowLiveTrading=false','AllowDllImport=false','','[Tester]','Expert=WIM\Ultimate_Breakout_EA_WSC_V9.5.ex5','ExpertParameters=OPT1_BASE.set','Symbol=EURUSD','Period=D1','Model=1','Optimization=0','FromDate=2013.01.01','ToDate=2022.12.31','ForwardMode=0','Deposit=100000','Currency=EUR','Leverage=100','ExecutionMode=0','Visual=0','ReplaceReport=1','ShutdownTerminal=1',('Report=' + $rep),'','[TesterInputs]')
Set-Content -LiteralPath $ini -Value (($righe -join "`r`n") + "`r`n") -Encoding ASCII -NoNewline
Remove-Item -LiteralPath ('C:\MT5_BCM_Opt\' + $rep + '.htm') -Force -ErrorAction SilentlyContinue
$t0=Get-Date
Write-Host ('Avvio il MT5 portable con la prova (EURUSD D1 2013-2022, Modello 1, set base OPT1_BASE). Non toccarlo: si chiude da solo. Avvio ' + $t0.ToString('HH:mm:ss')) -ForegroundColor Cyan
$p=Start-Process -FilePath $T -ArgumentList ('/portable /config:"' + $ini + '"') -PassThru
$scade=$t0.AddMinutes(150)
while(-not $p.HasExited -and (Get-Date) -lt $scade){ Start-Sleep -Seconds 5 }
if(-not $p.HasExited){ Write-Host ('TIMEOUT dopo 150 minuti: il terminale (PID ' + $p.Id + ') e ancora aperto. Provo CloseMainWindow, mai la forza.') -ForegroundColor Red; try{ [void]$p.CloseMainWindow() }catch{ }; $a=0; while(-not $p.HasExited -and $a -lt 18){ Start-Sleep -Seconds 5; $a=$a+1 }; if(-not $p.HasExited){ Write-Host ('Il terminale PID ' + $p.Id + ' NON si e chiuso: chiudilo A MANO riconoscendolo dalla cartella C:\MT5_BCM_Opt.') -ForegroundColor Red; return } }
Write-Host ('Terminale chiuso dopo ' + [math]::Round(((Get-Date)-$t0).TotalSeconds) + ' secondi.') -ForegroundColor Cyan
$rf=Join-Path 'C:\MT5_BCM_Opt' ($rep + '.htm')
if(Test-Path -LiteralPath $rf){
  $b=[IO.File]::ReadAllBytes($rf); $tx=$(if($b.Length -ge 2 -and (($b[0] -eq 255 -and $b[1] -eq 254) -or ($b[0] -eq 254 -and $b[1] -eq 255))){ [Text.Encoding]::Unicode.GetString($b) } else { [Text.Encoding]::UTF8.GetString($b) })
  $tx=[regex]::Replace($tx,'<[^>]*>','|'); $tx=[regex]::Replace($tx,'\s*\|[\s|]*','|')
  foreach($k in @('Qualit. dello Storico:','Barre:','Ticks:','Profitto Totale Netto:','Fattore di Profitto:','Numero di Operazioni di Trading Totali:')){ $m=[regex]::Match($tx,[regex]::Escape($k).Replace('\.','.')+'\|([^|]*)\|'); if(-not $m.Success){ $m=[regex]::Match($tx,($k -replace '\.','.')+'\|([^|]*)\|') }; Write-Host ('   ' + $k + ' ' + $(if($m.Success){$m.Groups[1].Value}else{'(non letto)'})) -ForegroundColor Green }
$pa=@{}; foreach($m2 in [regex]::Matches($tx,'(\d{4})\.\d\d\.\d\d \d\d:\d\d:\d\d\|\d+\|EURUSD\|(buy|sell)\|out')){ $y=$m2.Groups[1].Value; $pa[$y]=1+[int]$pa[$y] }; Write-Host ('   operazioni di chiusura per anno: ' + (($pa.Keys | Sort-Object | ForEach-Object { $_ + '=' + $pa[$_] }) -join '  ')) -ForegroundColor Green
} else { Write-Host ('ATTENZIONE: il report ' + $rf + ' NON c e: il test non e finito o e fallito. Guarda le righe del giornale qui sotto.') -ForegroundColor Red }
Write-Host '--- righe di licenza/errore nei giornali di oggi (portable):' -ForegroundColor Cyan
$logs=@(Get-ChildItem -LiteralPath 'C:\MT5_BCM_Opt' -Recurse -File -Filter ((Get-Date).ToString('yyyyMMdd') + '.log') -ErrorAction SilentlyContinue | Where-Object { $_.FullName -like '*\logs\*' } | Sort-Object LastWriteTime -Descending | Select-Object -First 4)
$n=0
foreach($lg in $logs){ $b=[IO.File]::ReadAllBytes($lg.FullName); $tl=$(if($b.Length -ge 2 -and $b[0] -eq 255 -and $b[1] -eq 254){ [Text.Encoding]::Unicode.GetString($b) } else { [Text.Encoding]::UTF8.GetString($b) }); foreach($r in ($tl -split "`r?`n")){ if($r -match '(?i)licen|final balance|Test passed|authoriz|invalid account|not found|WebRequest|URL|no connection|error'){ if($n -lt 40){ Write-Host ('   ' + $r.Trim()) -ForegroundColor Yellow; $n=$n+1 } } } }
if($n -eq 0){ Write-Host '   (nessuna riga trovata)' -ForegroundColor Yellow }
Write-Host 'Fine prova. Mandami la foto di questo output.' -ForegroundColor Green
