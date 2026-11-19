# MARCATORE_GOLDENZOE_MARKETWATCH_v1
# GoldenZoe_H4 (oro H4: breakout 55 candele, stop 3 ATR + stop mobile 3 ATR, solo acquisti) con i parametri di DEFAULT del file, su TUTTI i simboli selezionati nel Market Watch del terminale portabile C:\MT5_BCM_Opt (modalita del tester Tutti i simboli selezionati in Market Watch, Optimization=3). TF H1 H2 H4 H6 H8 D1 (la stessa regola in ogni TF), Modello 1, 100000 EUR. Due finestre per TF: IS 2013-2020 e OOS 2021-2024; il 2025-2026 NON si tocca (hold-out). Solo tester: nessun conto, VPS o FTMO. Criteri: report/GOLDENZOE_MARKETWATCH_CRITERI_2026-11-19.md
$ErrorActionPreference='Continue'
if($env:COMPUTERNAME -ne 'DESKTOP-H4D7CAJ'){ Write-Host ('SOLO sul PC di backtest DESKTOP-H4D7CAJ. Qui: ' + $env:COMPUTERNAME) -ForegroundColor Red; return }
$ROOT='C:\MT5_BCM_Opt'; $TRM=Join-Path $ROOT 'terminal64.exe'; $MEE=Join-Path $ROOT 'metaeditor64.exe'; $MQL5=Join-Path $ROOT 'MQL5'
$PINSRC='27bd0899e7a8677764a62b7b418705c63b2673c5'; $SHAEA='878CF3D3F40F7CB1FAE92528BAAB8CD3A3A01FFCEAB30A7E8ADA30856DFBF2F8'
$aperti=@(Get-Process -Name terminal64,metatester64,metaeditor64 -ErrorAction SilentlyContinue)
if($aperti.Count -gt 0){ $aperti | Select-Object Id,ProcessName,Path | Format-Table -AutoSize | Out-String | Write-Host; Write-Host 'MI FERMO: MT5, MetaEditor o agenti aperti. Chiudili e rilancia. Non ho avviato niente.' -ForegroundColor Red; return }
foreach($pp in @($TRM,$MEE,$MQL5)){ if(-not (Test-Path -LiteralPath $pp)){ Write-Host ('MI FERMO: non trovo ' + $pp) -ForegroundColor Red; return } }
function LeggiTesto([string]$p){ $b=[IO.File]::ReadAllBytes($p); if($b.Length -ge 2 -and (($b[0] -eq 255 -and $b[1] -eq 254) -or ($b[0] -eq 254 -and $b[1] -eq 255))){ return [Text.Encoding]::Unicode.GetString($b) } else { return [Text.Encoding]::UTF8.GetString($b) } }
$W=Join-Path $env:TEMP 'goldenzoe_mw'; New-Item -ItemType Directory -Force -Path $W | Out-Null
$dstDir=Join-Path $MQL5 'Experts\TESTBB'; New-Item -ItemType Directory -Force -Path $dstDir | Out-Null
# 1) sorgente dal repository (SHA256 verificato) e compilazione
$src=Join-Path $W 'GoldenZoe_H4.mq5'; Remove-Item -LiteralPath $src -Force -ErrorAction SilentlyContinue
irm ('https://raw.githubusercontent.com/claudiospadaro12/GITHUB/' + $PINSRC + '/mql5/Experts/GoldenZoe_H4.mq5?cb=' + [Guid]::NewGuid().ToString('N')) -OutFile $src
$hh=(Get-FileHash -LiteralPath $src -Algorithm SHA256).Hash.ToUpperInvariant()
if($hh -ne $SHAEA){ Write-Host ('MI FERMO: SHA256 diverso per GoldenZoe_H4: ' + $hh) -ForegroundColor Red; return }
$dst=Join-Path $dstDir 'GoldenZoe_H4.mq5'; Copy-Item -LiteralPath $src -Destination $dst -Force
$logc=Join-Path $W 'compila.log'; Remove-Item -LiteralPath $logc -Force -ErrorAction SilentlyContinue
$ex5=[IO.Path]::ChangeExtension($dst,'.ex5'); Remove-Item -LiteralPath $ex5 -Force -ErrorAction SilentlyContinue
[void](Start-Process -FilePath $MEE -ArgumentList ('/portable /compile:"' + $dst + '" /include:"' + $MQL5 + '" /log:"' + $logc + '"') -PassThru -Wait)
if(-not (Test-Path -LiteralPath $logc)){ Write-Host 'MI FERMO: nessun log di compilazione' -ForegroundColor Red; return }
$txc=LeggiTesto $logc
if(-not ((Test-Path -LiteralPath $ex5) -and ($txc -match 'Result:\s*0 errors'))){ Write-Host 'COMPILAZIONE NON RIUSCITA: incollami queste righe.' -ForegroundColor Red; ($txc -split "`r?`n" | Where-Object { $_ -match 'error' }) | ForEach-Object { Write-Host ('   ' + $_) }; return }
Write-Host 'COMPILATO GoldenZoe_H4' -ForegroundColor Green
# 2) simboli con storico nel terminale (informativo: il tester usa quelli selezionati in Market Watch)
$hist=Join-Path $ROOT 'bases\BCMMarkets-Server\history'
if(Test-Path -LiteralPath $hist){ $ns=@(Get-ChildItem -LiteralPath $hist -Directory -ErrorAction SilentlyContinue).Count; Write-Host ('Cartelle di storico nel terminale: ' + $ns + ' (il tester provera i simboli selezionati in Market Watch).') -ForegroundColor Gray }
if(-not ('SvegliaGZMW.Win' -as [type])){ Add-Type -Namespace SvegliaGZMW -Name Win -MemberDefinition '[DllImport("kernel32.dll")] public static extern uint SetThreadExecutionState(uint esFlags);' }
[void][SvegliaGZMW.Win]::SetThreadExecutionState([uint32]2147483651)
$stamp=(Get-Date).ToString('yyyyMMdd_HHmm'); $desk=[Environment]::GetFolderPath('Desktop')
$out=Join-Path (Join-Path $desk 'ABTG_RISULTATI') ('GOLDENZOE_MARKETWATCH_' + $stamp); New-Item -ItemType Directory -Force -Path $out | Out-Null
$INP=@('InpTF=16388','InpDonchianN=55','InpAtrPeriod=14','InpStopAtr=3.0','InpTrailAtr=3.0','InpAllowLong=true','InpAllowShort=false','InpRiskPercent=1.0','InpMagic=972301','InpComment=GOLDENZOE H4','InpVerbose=false')
$FIN=@( @{ n='H1_IS_2013_2020'; tf='H1'; tfv='16385'; da='2013.01.01'; a='2020.12.31' }, @{ n='H1_OOS_2021_2024'; tf='H1'; tfv='16385'; da='2021.01.01'; a='2024.12.31' }, @{ n='H2_IS_2013_2020'; tf='H2'; tfv='16386'; da='2013.01.01'; a='2020.12.31' }, @{ n='H2_OOS_2021_2024'; tf='H2'; tfv='16386'; da='2021.01.01'; a='2024.12.31' }, @{ n='H4_IS_2013_2020'; tf='H4'; tfv='16388'; da='2013.01.01'; a='2020.12.31' }, @{ n='H4_OOS_2021_2024'; tf='H4'; tfv='16388'; da='2021.01.01'; a='2024.12.31' }, @{ n='H6_IS_2013_2020'; tf='H6'; tfv='16390'; da='2013.01.01'; a='2020.12.31' }, @{ n='H6_OOS_2021_2024'; tf='H6'; tfv='16390'; da='2021.01.01'; a='2024.12.31' }, @{ n='H8_IS_2013_2020'; tf='H8'; tfv='16392'; da='2013.01.01'; a='2020.12.31' }, @{ n='H8_OOS_2021_2024'; tf='H8'; tfv='16392'; da='2021.01.01'; a='2024.12.31' }, @{ n='D1_IS_2013_2020'; tf='D1'; tfv='16408'; da='2013.01.01'; a='2020.12.31' }, @{ n='D1_OOS_2021_2024'; tf='D1'; tfv='16408'; da='2021.01.01'; a='2024.12.31' } )
Write-Host ('=== GOLDENZOE su TUTTI i simboli del Market Watch: 6 timeframe (H1, H2, H4, H6, H8, D1) x 2 finestre (IS poi OOS) = 12 passate, Modello 1. Avvio ' + (Get-Date).ToString('dd/MM/yyyy HH:mm') + ' (ora italiana). Durata attesa: 2-5 ore (STIMA, 12 passate). Non aprire MT5; PC alla corrente. ===') -ForegroundColor Cyan
$stopTutto=$false
foreach($f in $FIN){
  if($stopTutto){ break }
  $rep='GZMW_' + $f.n
  $r=@('[Experts]','AllowLiveTrading=false','AllowDllImport=false','','[Tester]','Expert=TESTBB\GoldenZoe_H4.ex5','Symbol=EURUSD',('Period=' + $f.tf),'Model=1','Optimization=3','OptimizationCriterion=0',('FromDate=' + $f.da),('ToDate=' + $f.a),'ForwardMode=0','Deposit=100000','Currency=EUR','Leverage=100','ExecutionMode=0','Visual=0','UseLocal=1','UseRemote=0','UseCloud=0','ReplaceReport=1','ShutdownTerminal=1',('Report=' + $rep),'','[TesterInputs]'); $r += (@($INP | Where-Object { $_ -notlike 'InpTF=*' }) + ('InpTF=' + $f.tfv))
  $ini=Join-Path $W ($rep + '.ini'); Set-Content -LiteralPath $ini -Value (($r -join "`r`n") + "`r`n") -Encoding ASCII -NoNewline
  Get-ChildItem -LiteralPath $ROOT -File -Filter ($rep + '.*') -ErrorAction SilentlyContinue | Remove-Item -Force -ErrorAction SilentlyContinue
  $w3=Get-Date; while(@(Get-Process -Name metatester64 -ErrorAction SilentlyContinue).Count -gt 0 -and ((Get-Date)-$w3).TotalMinutes -lt 5){ Start-Sleep -Seconds 5 }; Start-Sleep -Seconds 20
  $t0=Get-Date; $pr=Start-Process -FilePath $TRM -ArgumentList ('/portable /config:"' + $ini + '"') -PassThru
  $scade=$t0.AddHours(10); $ultimo=Get-Date
  while(-not $pr.HasExited -and (Get-Date) -lt $scade){ Start-Sleep -Seconds 10; if(((Get-Date)-$ultimo).TotalMinutes -ge 15){ $ultimo=Get-Date; Write-Host ('[' + (Get-Date).ToString('HH:mm') + '] ' + $f.n + ': in corso da ' + [math]::Round(((Get-Date)-$t0).TotalMinutes) + ' minuti') -ForegroundColor Gray } }
  if(-not $pr.HasExited){ Write-Host ('TIMEOUT (10 ore) su ' + $f.n + ': il terminale e ancora aperto. Non lo chiudo io: guardalo e dimmi.') -ForegroundColor Red; $stopTutto=$true; break }
  $trovati=@(Get-ChildItem -LiteralPath $ROOT -File -ErrorAction SilentlyContinue | Where-Object { $_.LastWriteTime -ge $t0 -and ($_.Extension -in '.xml','.htm','.html') })
  $cache=Join-Path $ROOT 'Tester\cache'
  if(Test-Path -LiteralPath $cache){ $trovati += @(Get-ChildItem -LiteralPath $cache -File -ErrorAction SilentlyContinue | Where-Object { $_.LastWriteTime -ge $t0 }) }
  foreach($g in $trovati){ Copy-Item -LiteralPath $g.FullName -Destination (Join-Path $out ($f.n + '_' + $g.Name)) -Force }
  Copy-Item -LiteralPath $ini -Destination (Join-Path $out ($f.n + '.ini')) -Force
  foreach($xx in @($trovati | Where-Object { $_.Extension -eq '.xml' })){ $rc=([regex]::Matches((Get-Content -LiteralPath $xx.FullName -Raw),'<Row>')).Count - 1; Write-Host ('   righe XML: ' + $rc + ' (se sono poche, i risultati completi sono nel file .opt)') -ForegroundColor Gray }
  $minuti=[math]::Round(((Get-Date)-$t0).TotalMinutes)
  if($trovati.Count -eq 0){ Write-Host ('[' + $f.n + '] finito in ' + $minuti + ' minuti ma NESSUN report trovato: apri MT5, scheda Ottimizzazione, tasto destro, Esporta in XML, e mandami quel file.') -ForegroundColor Yellow }
  else { Write-Host ('[' + $f.n + '] finito in ' + $minuti + ' minuti; file raccolti: ' + $trovati.Count) -ForegroundColor Green }
}
[void][SvegliaGZMW.Win]::SetThreadExecutionState([uint32]2147483648)
$zip=Join-Path (Join-Path $desk 'ABTG_RISULTATI') ('GOLDENZOE_MARKETWATCH_' + $stamp + '.zip')
Compress-Archive -Path (Join-Path $out '*') -DestinationPath $zip -Force
Write-Host ('Fine alle ' + (Get-Date).ToString('dd/MM/yyyy HH:mm') + ' (ora italiana). Cartella: ' + $out) -ForegroundColor Cyan
Write-Host ('>>> ALLEGA QUESTO FILE: ' + $zip + ' <<<') -ForegroundColor Black -BackgroundColor Yellow
try{ Set-Clipboard -Value $zip } catch { }
Start-Process explorer.exe -ArgumentList ('/select,"' + $zip + '"')
