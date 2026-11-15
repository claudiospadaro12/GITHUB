# MARCATORE_COMPILA_SCALPER_103_v1
# Compila ABTG_ScalperClaudio.mq5 (versione 1.03, SHA256 1CAFF456...) con MetaEditor da riga di comando, usando la cartella dati del terminale BCM (include corretti).
# Scrive SOLO: ABTG_ScalperClaudio.ex5 (con copia .bak datata dell'ex5 precedente) e un log nella cartella TEMP. NON apre MT5, NON tocca conti, VPS, FTMO, altri terminali.
$ErrorActionPreference='Continue'
if($env:COMPUTERNAME -ne 'DESKTOP-H4D7CAJ'){ Write-Host ('SOLO sul PC di backtest DESKTOP-H4D7CAJ. Qui: ' + $env:COMPUTERNAME) -ForegroundColor Red; return }
$aperti=@(Get-Process -Name terminal64,metatester64,metaeditor64 -ErrorAction SilentlyContinue)
if($aperti.Count -gt 0){ $aperti | Select-Object Id,ProcessName,Path | Format-Table -AutoSize | Out-String | Write-Host; Write-Host 'MI FERMO: ci sono MT5, MetaEditor o agenti del tester aperti. Chiudili (Gestione attivita) e rilancia. Non ho scritto niente.' -ForegroundColor Red; return }
$INST='C:\Program Files\BCM Markets MT5 Terminal'
$ME=Join-Path $INST 'metaeditor64.exe'
if(-not (Test-Path -LiteralPath $ME)){ Write-Host ('MI FERMO: non trovo ' + $ME) -ForegroundColor Red; return }
$base=Join-Path $env:APPDATA 'MetaQuotes\Terminal'; $dati=$null
foreach($o in @(Get-ChildItem -LiteralPath $base -Directory -ErrorAction SilentlyContinue)){ $of=Join-Path $o.FullName 'origin.txt'; if(Test-Path -LiteralPath $of){ $c=((Get-Content -LiteralPath $of -Raw -Encoding Unicode) -replace '[\r\n\0]','').Trim(); if($c -eq $INST){ $dati=$o.FullName } } }
if(-not $dati){ Write-Host 'MI FERMO: cartella dati del terminale BCM non trovata.' -ForegroundColor Red; return }
$MQL5=Join-Path $dati 'MQL5'
$SRC=Join-Path $MQL5 'Experts\ABTG_ScalperClaudio.mq5'
$EX5=Join-Path $MQL5 'Experts\ABTG_ScalperClaudio.ex5'
$TRADE=Join-Path $MQL5 'Include\Trade\Trade.mqh'
if(-not (Test-Path -LiteralPath $SRC)){ Write-Host ('MI FERMO: non trovo ' + $SRC) -ForegroundColor Red; return }
$H=(Get-FileHash -LiteralPath $SRC -Algorithm SHA256).Hash.ToUpperInvariant()
$ver=(Select-String -LiteralPath $SRC -Pattern '#property version' | Select-Object -First 1).Line
Write-Host ('Sorgente: ' + $SRC) -ForegroundColor Cyan
Write-Host ('   SHA256 ' + $H + '   ' + $ver)
if($H -ne '1CAFF4564E64100154617C0511A04B4474AC4910E210673635957063E083191A'){ Write-Host 'MI FERMO: il sorgente NON e la versione 1.03 attesa (SHA256 diverso). Rilancia prima la riga di download.' -ForegroundColor Red; return }
Write-Host ('Include Trade.mqh presente: ' + (Test-Path -LiteralPath $TRADE)) -ForegroundColor Cyan
if(-not (Test-Path -LiteralPath $TRADE)){ Write-Host 'MI FERMO: nella cartella dati manca Include\Trade\Trade.mqh (la libreria standard). Non compilo.' -ForegroundColor Red; return }
if(Test-Path -LiteralPath $EX5){ $vec=Get-Item -LiteralPath $EX5; Write-Host ('ex5 precedente: ' + $vec.LastWriteTime + ', ' + $vec.Length + ' byte (copia di sicurezza .bak)'); Copy-Item -LiteralPath $EX5 -Destination ($EX5 + '.bak_' + (Get-Date).ToString('yyyyMMdd_HHmmss')) -Force }
$LOG=Join-Path $env:TEMP 'compila_scalper_103.log'
Remove-Item -LiteralPath $LOG -Force -ErrorAction SilentlyContinue
$arg=('/compile:"' + $SRC + '" /include:"' + $MQL5 + '" /log:"' + $LOG + '"')
$t0=Get-Date
$p=Start-Process -FilePath $ME -ArgumentList $arg -Wait -PassThru
Write-Host ('MetaEditor terminato, codice ' + $p.ExitCode + ' (in genere 1 = compilato senza errori; il log decide).')
if(Test-Path -LiteralPath $LOG){ Write-Host 'LOG DELLA COMPILAZIONE:' -ForegroundColor Cyan; $b=[IO.File]::ReadAllBytes($LOG); $tx=$(if($b.Length -ge 2 -and $b[0] -eq 255 -and $b[1] -eq 254){ [Text.Encoding]::Unicode.GetString($b) } else { [Text.Encoding]::UTF8.GetString($b) }); $tx -split "`r?`n" | Where-Object { $_.Trim() -ne '' } | ForEach-Object { Write-Host ('   ' + $_) } } else { Write-Host 'Nessun log scritto.' -ForegroundColor Yellow }
if(Test-Path -LiteralPath $EX5){ $n=Get-Item -LiteralPath $EX5; $nuovo=($n.LastWriteTime -ge $t0.AddSeconds(-5)); Write-Host ('ex5 ora: ' + $n.LastWriteTime + ', ' + $n.Length + ' byte, SHA256 ' + (Get-FileHash -LiteralPath $EX5 -Algorithm SHA256).Hash) -ForegroundColor $(if($nuovo){'Green'}else{'Red'}); if($nuovo){ Write-Host 'ESITO: COMPILATO ORA (data di oggi). Puoi lanciare la riga di avvio.' -ForegroundColor Green } else { Write-Host 'ESITO: il file ex5 NON e stato rigenerato. NON lanciare la riga di avvio: mandami questa schermata.' -ForegroundColor Red } } else { Write-Host 'ESITO: nessun ex5. Mandami questa schermata.' -ForegroundColor Red }
