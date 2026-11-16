# MARCATORE_PROVA_ORARI_v1
# Collaudo della libreria CLAU12_ORARI.mqh nel MT5 PORTABLE C:\MT5_BCM_Opt: scarica dal commit inchiodato CLAU12_ORARI.mqh e CLAU12_TESTORARI.mq5 (con SHA256), li copia nel portable, li compila con MetaEditor da riga di comando, lancia una passata minima nel tester (nessun ordine) e legge le righe CLAU12_TIME_* dal giornale dell'agente.
# Scrive SOLO dentro C:\MT5_BCM_Opt (Include\CLAU12, Experts, report/log del tester) e file temporanei in %TEMP%. NON tocca il terminale principale, altri MT5, conti, VPS, FTMO, AppData.
$ErrorActionPreference='Continue'
if($env:COMPUTERNAME -ne 'DESKTOP-H4D7CAJ'){ Write-Host ('SOLO sul PC di backtest DESKTOP-H4D7CAJ. Qui: ' + $env:COMPUTERNAME) -ForegroundColor Red; return }
[Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12
$PIN='a89dd181237fb771255b7436c09e1bdf4336ec35'; $S1='837B29C8B8F68E650853F98A0F7EEDF84A586E5605DD3D5B6421EC6B0E4C7D49'; $S2='D89B3CA01FD4C66971CA346CA677DB1132F83D81D7104CA7D998C898FE9E6B6E'
$PT='C:\MT5_BCM_Opt'; $T=Join-Path $PT 'terminal64.exe'
$aperti=@(Get-Process -Name terminal64,metatester64,metaeditor64 -ErrorAction SilentlyContinue)
if($aperti.Count -gt 0){ $aperti | Select-Object Id,ProcessName,Path | Format-Table -AutoSize | Out-String | Write-Host; Write-Host 'MI FERMO: ci sono MT5, MetaEditor o agenti del tester aperti. Chiudili e rilancia. Non ho scritto niente.' -ForegroundColor Red; return }
if(-not (Test-Path -LiteralPath $T)){ Write-Host ('MI FERMO: non trovo ' + $T) -ForegroundColor Red; return }
$ME=Join-Path $PT 'metaeditor64.exe'; if(-not (Test-Path -LiteralPath $ME)){ $ME='C:\Program Files\BCM Markets MT5 Terminal\metaeditor64.exe' }
if(-not (Test-Path -LiteralPath $ME)){ Write-Host 'MI FERMO: non trovo metaeditor64.exe.' -ForegroundColor Red; return }
$W=Join-Path $env:TEMP 'abtg_prova_orari'; New-Item -ItemType Directory -Force -Path $W | Out-Null
function Scarica([string]$rel,[string]$sha,[string]$dst){
  $tmp=Join-Path $W ([IO.Path]::GetFileName($rel)); Remove-Item -LiteralPath $tmp -Force -ErrorAction SilentlyContinue
  irm ('https://raw.githubusercontent.com/claudiospadaro12/GITHUB/' + $PIN + '/' + $rel + '?cb=' + [Guid]::NewGuid().ToString('N')) -OutFile $tmp
  $h=(Get-FileHash -LiteralPath $tmp -Algorithm SHA256).Hash.ToUpperInvariant()
  if($h -ne $sha){ throw ('SHA256 diverso per ' + $rel + ': ' + $h) }
  New-Item -ItemType Directory -Force -Path (Split-Path -Parent $dst) | Out-Null; Copy-Item -LiteralPath $tmp -Destination $dst -Force
  Write-Host ('   copiato ' + $dst + ' (SHA256 ' + $h.Substring(0,16) + ')') -ForegroundColor Green
}
Write-Host '1/4 Scarico e copio i due file (SHA256 verificato) ...' -ForegroundColor Cyan
Scarica 'mql5/Include/CLAU12/CLAU12_ORARI.mqh' $S1 (Join-Path $PT 'MQL5\Include\CLAU12\CLAU12_ORARI.mqh')
Scarica 'mql5/Experts/CLAU12_TESTORARI.mq5' $S2 (Join-Path $PT 'MQL5\Experts\CLAU12_TESTORARI.mq5')
Write-Host '2/4 Compilo CLAU12_TESTORARI.mq5 ...' -ForegroundColor Cyan
$LOG=Join-Path $W 'compila.log'; Remove-Item -LiteralPath $LOG -Force -ErrorAction SilentlyContinue
$src=Join-Path $PT 'MQL5\Experts\CLAU12_TESTORARI.mq5'; $ex5=Join-Path $PT 'MQL5\Experts\CLAU12_TESTORARI.ex5'; Remove-Item -LiteralPath $ex5 -Force -ErrorAction SilentlyContinue
$p=Start-Process -FilePath $ME -ArgumentList ('/compile:"' + $src + '" /include:"' + (Join-Path $PT 'MQL5') + '" /log:"' + $LOG + '"') -Wait -PassThru
$cl=''; if(Test-Path -LiteralPath $LOG){ $b=[IO.File]::ReadAllBytes($LOG); $cl=$(if($b.Length -ge 2 -and $b[0] -eq 255 -and $b[1] -eq 254){ [Text.Encoding]::Unicode.GetString($b) } else { [Text.Encoding]::UTF8.GetString($b) }); ($cl -split "`r?`n") | Where-Object { $_ -match 'error|warning|Result' } | Select-Object -First 25 | ForEach-Object { Write-Host ('   ' + $_.Trim()) } }
if(-not (Test-Path -LiteralPath $ex5)){ Write-Host 'MI FERMO: compilazione NON riuscita (nessun .ex5). Mandami questa schermata.' -ForegroundColor Red; try{ Set-Clipboard -Value $cl }catch{ }; return }
Write-Host ('   ex5 creato: ' + (Get-Item -LiteralPath $ex5).LastWriteTime) -ForegroundColor Green
Write-Host '3/4 Passata minima nel tester (nessun ordine) ...' -ForegroundColor Cyan
$ini=Join-Path $W 'prova_orari.ini'
$righe=@('[Experts]','AllowLiveTrading=false','AllowDllImport=false','','[Tester]','Expert=CLAU12_TESTORARI.ex5','Symbol=XAUUSD','Period=D1','Model=1','Optimization=0','FromDate=2026.11.02','ToDate=2026.11.06','ForwardMode=0','Deposit=100000','Currency=EUR','Leverage=100','ExecutionMode=0','Visual=0','ReplaceReport=1','ShutdownTerminal=1','Report=PROVA_ORARI','','[TesterInputs]')
Set-Content -LiteralPath $ini -Value (($righe -join "`r`n") + "`r`n") -Encoding ASCII -NoNewline
$t0=Get-Date; $pr=Start-Process -FilePath $T -ArgumentList ('/portable /config:"' + $ini + '"') -PassThru
$scade=$t0.AddMinutes(15); while(-not $pr.HasExited -and (Get-Date) -lt $scade){ Start-Sleep -Seconds 3 }
if(-not $pr.HasExited){ Write-Host ('TIMEOUT: il terminale PID ' + $pr.Id + ' e ancora aperto: chiudilo a mano.') -ForegroundColor Red; return }
Write-Host '4/4 Righe CLAU12_TIME_* nei giornali del tester ...' -ForegroundColor Cyan
$out=New-Object System.Collections.ArrayList
$logs=@(Get-ChildItem -LiteralPath (Join-Path $PT 'Tester') -Recurse -File -Filter '*.log' -ErrorAction SilentlyContinue | Where-Object { $_.LastWriteTime -ge $t0.AddMinutes(-1) })
foreach($lg in $logs){ $b=[IO.File]::ReadAllBytes($lg.FullName); $tl=$(if($b.Length -ge 2 -and $b[0] -eq 255 -and $b[1] -eq 254){ [Text.Encoding]::Unicode.GetString($b) } else { [Text.Encoding]::UTF8.GetString($b) }); foreach($r in ($tl -split "`r?`n")){ if($r -match 'CLAU12_TIME_'){ [void]$out.Add($r.Trim()) } } }
if($out.Count -eq 0){ Write-Host 'Nessuna riga CLAU12_TIME_ trovata nei giornali (l EA non e partito?). Mandami questa schermata.' -ForegroundColor Red } else { $out | ForEach-Object { Write-Host ('   ' + $_) -ForegroundColor Yellow } }
try { Set-Clipboard -Value (($out -join "`r`n")); Write-Host 'Righe COPIATE negli appunti: incollale nella chat con Ctrl+V.' -ForegroundColor Green } catch { }
Write-Host ('Fine alle ' + (Get-Date).ToString('dd/MM/yyyy HH:mm') + ' (ora italiana).') -ForegroundColor Cyan
