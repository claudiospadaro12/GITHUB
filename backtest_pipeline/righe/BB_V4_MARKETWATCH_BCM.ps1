# MARCATORE_BB_V4_MARKETWATCH_v1
# BreakingBand_MT5_v4 (Massimo) con i parametri di DEFAULT del file, su TUTTI i simboli selezionati nel Market Watch del terminale portabile C:\MT5_BCM_Opt (modalita del tester "Tutti i simboli selezionati in Market Watch", Optimization=3). H1, Modello 1 (barre da 1 minuto), deposito 10000 EUR. Due finestre: IS 2013-2020 e OOS 2021-2024; il 2025-2026 NON si tocca (hold-out). Solo tester: nessun conto, VPS o FTMO. Criteri: report/BREAKINGBAND_V4_MARKETWATCH_CRITERI_2026-11-19.md
$ErrorActionPreference='Continue'
if($env:COMPUTERNAME -ne 'DESKTOP-H4D7CAJ'){ Write-Host ('SOLO sul PC di backtest DESKTOP-H4D7CAJ. Qui: ' + $env:COMPUTERNAME) -ForegroundColor Red; return }
$ROOT='C:\MT5_BCM_Opt'; $TRM=Join-Path $ROOT 'terminal64.exe'; $MEE=Join-Path $ROOT 'metaeditor64.exe'; $MQL5=Join-Path $ROOT 'MQL5'
$PINSRC='f827ee22b2f311e9114b0c70bb5777e99e9c2a09'; $SHAEA='4003A62BB5461169ECCBEFD447870301DD3BDC63572ED102400F6A1616D615EE'
$aperti=@(Get-Process -Name terminal64,metatester64,metaeditor64 -ErrorAction SilentlyContinue)
if($aperti.Count -gt 0){ $aperti | Select-Object Id,ProcessName,Path | Format-Table -AutoSize | Out-String | Write-Host; Write-Host 'MI FERMO: MT5, MetaEditor o agenti aperti. Chiudili e rilancia. Non ho avviato niente.' -ForegroundColor Red; return }
foreach($pp in @($TRM,$MEE,$MQL5)){ if(-not (Test-Path -LiteralPath $pp)){ Write-Host ('MI FERMO: non trovo ' + $pp) -ForegroundColor Red; return } }
function LeggiTesto([string]$p){ $b=[IO.File]::ReadAllBytes($p); if($b.Length -ge 2 -and (($b[0] -eq 255 -and $b[1] -eq 254) -or ($b[0] -eq 254 -and $b[1] -eq 255))){ return [Text.Encoding]::Unicode.GetString($b) } else { return [Text.Encoding]::UTF8.GetString($b) } }
$W=Join-Path $env:TEMP 'bb_v4_mw'; New-Item -ItemType Directory -Force -Path $W | Out-Null
$dstDir=Join-Path $MQL5 'Experts\TESTBB'; New-Item -ItemType Directory -Force -Path $dstDir | Out-Null
# 1) sorgente dal repository (SHA256 verificato) e compilazione
$src=Join-Path $W 'BreakingBand_MT5_v4.mq5'; Remove-Item -LiteralPath $src -Force -ErrorAction SilentlyContinue
irm ('https://raw.githubusercontent.com/claudiospadaro12/GITHUB/' + $PINSRC + '/mql5/Experts/BreakingBand_MT5_v4.mq5?cb=' + [Guid]::NewGuid().ToString('N')) -OutFile $src
$hh=(Get-FileHash -LiteralPath $src -Algorithm SHA256).Hash.ToUpperInvariant()
if($hh -ne $SHAEA){ Write-Host ('MI FERMO: SHA256 diverso per BreakingBand_MT5_v4: ' + $hh) -ForegroundColor Red; return }
$dst=Join-Path $dstDir 'BreakingBand_MT5_v4.mq5'; Copy-Item -LiteralPath $src -Destination $dst -Force
$logc=Join-Path $W 'compila.log'; Remove-Item -LiteralPath $logc -Force -ErrorAction SilentlyContinue
$ex5=[IO.Path]::ChangeExtension($dst,'.ex5'); Remove-Item -LiteralPath $ex5 -Force -ErrorAction SilentlyContinue
[void](Start-Process -FilePath $MEE -ArgumentList ('/portable /compile:"' + $dst + '" /include:"' + $MQL5 + '" /log:"' + $logc + '"') -PassThru -Wait)
if(-not (Test-Path -LiteralPath $logc)){ Write-Host 'MI FERMO: nessun log di compilazione' -ForegroundColor Red; return }
$txc=LeggiTesto $logc
if(-not ((Test-Path -LiteralPath $ex5) -and ($txc -match 'Result:\s*0 errors'))){ Write-Host 'COMPILAZIONE NON RIUSCITA: incollami queste righe.' -ForegroundColor Red; ($txc -split "`r?`n" | Where-Object { $_ -match 'error' }) | ForEach-Object { Write-Host ('   ' + $_) }; return }
Write-Host 'COMPILATO BreakingBand_MT5_v4' -ForegroundColor Green
# 2) simboli con storico nel terminale (informativo: il tester usa quelli selezionati in Market Watch)
$hist=Join-Path $ROOT 'bases\BCMMarkets-Server\history'
if(Test-Path -LiteralPath $hist){ $ns=@(Get-ChildItem -LiteralPath $hist -Directory -ErrorAction SilentlyContinue).Count; Write-Host ('Cartelle di storico nel terminale: ' + $ns + ' (il tester provera i simboli selezionati in Market Watch).') -ForegroundColor Gray }
if(-not ('SvegliaBBMW.Win' -as [type])){ Add-Type -Namespace SvegliaBBMW -Name Win -MemberDefinition '[DllImport("kernel32.dll")] public static extern uint SetThreadExecutionState(uint esFlags);' }
[void][SvegliaBBMW.Win]::SetThreadExecutionState([uint32]2147483651)
$stamp=(Get-Date).ToString('yyyyMMdd_HHmm'); $desk=[Environment]::GetFolderPath('Desktop')
$out=Join-Path (Join-Path $desk 'ABTG_RISULTATI') ('BB_V4_MARKETWATCH_' + $stamp); New-Item -ItemType Directory -Force -Path $out | Out-Null
$INP=@('BB_Period=20','BB_Dev=2.0','Bulge_BWexp=1.12','Bulge_ImpATR=1.5','Bulge_MaxBars=20','Bulge_DistMid=0.40','Retr_MaxCandleATR=1.5','Retr_ShadowBody=1.5','Retr_MaxBars=40','UseStdDevCut=true','StdDevSMA=50','EnableContinuation=true','EnableReversal=true','Reversal_MinBulges=2','SL_ATRmult=3.0','TP_Mode=1','TP_ATRmult=2.0','RiskPercent=0.5','ATR_Period=14','MagicNumber=20261119')
$FIN=@( @{ n='IS_2013_2020'; da='2013.01.01'; a='2020.12.31' }, @{ n='OOS_2021_2024'; da='2021.01.01'; a='2024.12.31' } )
Write-Host ('=== BREAKINGBAND v4 su TUTTI i simboli del Market Watch: 2 finestre (IS poi OOS), Modello 1, H1. Avvio ' + (Get-Date).ToString('dd/MM/yyyy HH:mm') + ' (ora italiana). Durata attesa: alcune ore (STIMA). Non aprire MT5; PC alla corrente. ===') -ForegroundColor Cyan
$stopTutto=$false
foreach($f in $FIN){
  if($stopTutto){ break }
  $rep='BBMW_' + $f.n
  $r=@('[Experts]','AllowLiveTrading=false','AllowDllImport=false','','[Tester]','Expert=TESTBB\BreakingBand_MT5_v4.ex5','Symbol=EURUSD','Period=H1','Model=1','Optimization=3','OptimizationCriterion=0',('FromDate=' + $f.da),('ToDate=' + $f.a),'ForwardMode=0','Deposit=10000','Currency=EUR','Leverage=100','ExecutionMode=0','Visual=0','UseLocal=1','UseRemote=0','UseCloud=0','ReplaceReport=1','ShutdownTerminal=1',('Report=' + $rep),'','[TesterInputs]'); $r += $INP
  $ini=Join-Path $W ($rep + '.ini'); Set-Content -LiteralPath $ini -Value (($r -join "`r`n") + "`r`n") -Encoding ASCII -NoNewline
  Get-ChildItem -LiteralPath $ROOT -File -Filter ($rep + '.*') -ErrorAction SilentlyContinue | Remove-Item -Force -ErrorAction SilentlyContinue
  $t0=Get-Date; $pr=Start-Process -FilePath $TRM -ArgumentList ('/portable /config:"' + $ini + '"') -PassThru
  $scade=$t0.AddHours(10); $ultimo=Get-Date
  while(-not $pr.HasExited -and (Get-Date) -lt $scade){ Start-Sleep -Seconds 10; if(((Get-Date)-$ultimo).TotalMinutes -ge 15){ $ultimo=Get-Date; Write-Host ('[' + (Get-Date).ToString('HH:mm') + '] ' + $f.n + ': in corso da ' + [math]::Round(((Get-Date)-$t0).TotalMinutes) + ' minuti') -ForegroundColor Gray } }
  if(-not $pr.HasExited){ Write-Host ('TIMEOUT (10 ore) su ' + $f.n + ': il terminale e ancora aperto. Non lo chiudo io: guardalo e dimmi.') -ForegroundColor Red; $stopTutto=$true; break }
  $trovati=@(Get-ChildItem -LiteralPath $ROOT -File -ErrorAction SilentlyContinue | Where-Object { $_.LastWriteTime -ge $t0 -and ($_.Extension -in '.xml','.htm','.html') })
  $cache=Join-Path $ROOT 'Tester\cache'
  if(Test-Path -LiteralPath $cache){ $trovati += @(Get-ChildItem -LiteralPath $cache -File -ErrorAction SilentlyContinue | Where-Object { $_.LastWriteTime -ge $t0 }) }
  foreach($g in $trovati){ Copy-Item -LiteralPath $g.FullName -Destination (Join-Path $out ($f.n + '_' + $g.Name)) -Force }
  Copy-Item -LiteralPath $ini -Destination (Join-Path $out ($f.n + '.ini')) -Force
  $minuti=[math]::Round(((Get-Date)-$t0).TotalMinutes)
  if($trovati.Count -eq 0){ Write-Host ('[' + $f.n + '] finito in ' + $minuti + ' minuti ma NESSUN report trovato: apri MT5, scheda Ottimizzazione, tasto destro, Esporta in XML, e mandami quel file.') -ForegroundColor Yellow }
  else { Write-Host ('[' + $f.n + '] finito in ' + $minuti + ' minuti; file raccolti: ' + $trovati.Count) -ForegroundColor Green }
}
[void][SvegliaBBMW.Win]::SetThreadExecutionState([uint32]2147483648)
$zip=Join-Path (Join-Path $desk 'ABTG_RISULTATI') ('BB_V4_MARKETWATCH_' + $stamp + '.zip')
Compress-Archive -Path (Join-Path $out '*') -DestinationPath $zip -Force
Write-Host ('Fine alle ' + (Get-Date).ToString('dd/MM/yyyy HH:mm') + ' (ora italiana). Cartella: ' + $out) -ForegroundColor Cyan
Write-Host ('>>> ALLEGA QUESTO FILE: ' + $zip + ' <<<') -ForegroundColor Black -BackgroundColor Yellow
try{ Set-Clipboard -Value $zip } catch { }
Start-Process explorer.exe -ArgumentList ('/select,"' + $zip + '"')
