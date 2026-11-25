# MARCATORE_TESTER_CPI_T2_v1
# Lancia il test T2 dell'EA ABTG_CpiM5 nel Strategy Tester del terminale PRINCIPALE BCM (XAUUSD, 1 minuto OHLC, 2018-01-01 -> 2024-06-30, preset B100 SL3000) in automatico, raccoglie report e journal in uno zip sul Desktop. Non apre ordini sul conto: gira SOLO nel tester. Si ferma se MT5 e aperto o se nel profilo ci sono EA attaccati ai grafici.
$ErrorActionPreference='Continue'; $INV=[Globalization.CultureInfo]::InvariantCulture
function Fermo($m){ Write-Host ''; Write-Host ('FERMO: ' + $m) -ForegroundColor Red; Write-Host 'NIENTE E STATO AVVIATO.' -ForegroundColor Red; return }
if($env:COMPUTERNAME -ne 'DESKTOP-H4D7CAJ'){ Fermo ('questa riga e per il PC di backtest DESKTOP-H4D7CAJ. Qui: ' + $env:COMPUTERNAME); return }
$INST='C:\Program Files\BCM Markets MT5 Terminal'; $EXE=Join-Path $INST 'terminal64.exe'
if(-not (Test-Path -LiteralPath $EXE)){ Fermo ('manca ' + $EXE); return }
$vivi=@(Get-Process -Name terminal64 -ErrorAction SilentlyContinue | Where-Object { (-not $_.Path) -or $_.Path.StartsWith($INST + '\',[StringComparison]::OrdinalIgnoreCase) })
if($vivi.Count -gt 0){ Fermo 'MT5 BCM principale e APERTO: chiudilo (File > Esci) e rilancia.'; return }
$DATI=$null; $baseT=Join-Path $env:APPDATA 'MetaQuotes\Terminal'
foreach($o in @(Get-ChildItem -LiteralPath $baseT -Directory -ErrorAction SilentlyContinue)){ $of=Join-Path $o.FullName 'origin.txt'; if(Test-Path -LiteralPath $of){ $c0=((Get-Content -LiteralPath $of -Raw -Encoding Unicode) -replace '[\r\n\0]','').Trim(); if($c0 -ieq $INST){ $DATI=$o.FullName } } }
if(-not $DATI){ Fermo 'non trovo la cartella dati del terminale BCM principale.'; return }
$SET='ABTG_CpiM5_XAUUSD_B100_SL3000.set'; $setP=Join-Path $DATI ('MQL5\Profiles\Tester\' + $SET); $ex5=Join-Path $DATI 'MQL5\Experts\ABTG_CpiM5.ex5'; $csv=Join-Path $baseT 'Common\Files\abtg_cpi_dates.csv'
foreach($f in @($setP,$ex5,$csv)){ if(-not (Test-Path -LiteralPath $f)){ Fermo ('manca ' + $f + ' (rilancia prima le righe di installazione CPI)'); return } }
# nessun EA attaccato ai grafici del profilo attivo
$profilo='Default'; $ini0=Join-Path $DATI 'config\common.ini'
if(Test-Path -LiteralPath $ini0){ $tx0=Get-Content -LiteralPath $ini0 -Raw -Encoding Unicode; if(-not $tx0 -or $tx0.Length -lt 5){ $tx0=Get-Content -LiteralPath $ini0 -Raw }; $m=[regex]::Match($tx0,'(?im)^\s*ProfileLast\s*=\s*(.+?)\s*$'); if($m.Success){ $profilo=$m.Groups[1].Value.Trim() } }
$dirChr=Join-Path $DATI ('MQL5\Profiles\Charts\' + $profilo); $sedie=@()
if(Test-Path -LiteralPath $dirChr){ foreach($c in @(Get-ChildItem -LiteralPath $dirChr -Filter *.chr -File -ErrorAction SilentlyContinue)){ $t=''; try { $b=[IO.File]::ReadAllBytes($c.FullName); $t=$(if($b.Length -ge 2 -and $b[0] -eq 255 -and $b[1] -eq 254){ [Text.Encoding]::Unicode.GetString($b) } else { [Text.Encoding]::UTF8.GetString($b) }) } catch { Fermo ('non riesco a leggere ' + $c.FullName); return }; if($t -match '(?im)^\s*<expert>'){ $sedie += $c.Name } } }
if($sedie.Count -gt 0){ Fermo ('nel profilo "' + $profilo + '" ci sono EA attaccati ai grafici (' + ($sedie -join ', ') + '): lanciare il terminale li farebbe ripartire sul demo. Stacca le sedie o cambia profilo.'); return }
Write-Host ('Profilo "' + $profilo + '": nessun EA attaccato. Avvio il tester...') -ForegroundColor Green
$stamp=(Get-Date).ToString('yyyyMMdd_HHmmss',$INV); $rep='CPI_T2_' + $stamp; $W=Join-Path $env:USERPROFILE 'abtg_sonde'; New-Item -ItemType Directory -Force -Path $W | Out-Null
$iniRun=Join-Path $W ('cpi_t2_' + $stamp + '.ini')
$L=@('[Tester]','Expert=ABTG_CpiM5',('ExpertParameters=' + $SET),'Symbol=XAUUSD','Period=M5','Optimization=0','Model=1','FromDate=2018.01.01','ToDate=2024.06.30','ForwardMode=0','Deposit=100000','Currency=EUR','Leverage=100','ExecutionMode=0','Visual=0',('Report=' + $rep),'ReplaceReport=1','ShutdownTerminal=1')
Set-Content -LiteralPath $iniRun -Value ($L -join "`r`n") -Encoding Unicode
$t0=Get-Date; $p=Start-Process -FilePath $EXE -ArgumentList ('/config:"' + $iniRun + '"') -PassThru
$scad=(Get-Date).AddMinutes(120); $ult=Get-Date
while(-not $p.HasExited -and (Get-Date) -lt $scad){ Start-Sleep -Seconds 10; if(((Get-Date) - $ult).TotalSeconds -ge 60){ Write-Host ('  ... in corso da ' + [int]((Get-Date) - $t0).TotalMinutes + ' min') ; $ult=Get-Date } }
if(-not $p.HasExited){ Write-Host 'ATTENZIONE: il test non e finito entro 120 minuti. NON chiudo il terminale: guardalo a mano.' -ForegroundColor Yellow }
$desk=[Environment]::GetFolderPath('Desktop'); $od=Join-Path $desk 'ABTG_RISULTATI'; New-Item -ItemType Directory -Force -Path $od | Out-Null
$raccolta=Join-Path $od ('CPI_M5_T2_' + $stamp); New-Item -ItemType Directory -Force -Path $raccolta | Out-Null
$trov=0
foreach($dir in @($DATI,$INST)){ foreach($f in @(Get-ChildItem -LiteralPath $dir -Filter ($rep + '*') -File -ErrorAction SilentlyContinue)){ Copy-Item -LiteralPath $f.FullName -Destination $raccolta -Force; $trov++ } }
$logs=Join-Path $DATI 'Tester'; foreach($lg in @(Get-ChildItem -LiteralPath $logs -Recurse -Filter '*.log' -File -ErrorAction SilentlyContinue | Where-Object { $_.LastWriteTime -ge $t0 -and $_.Directory.Name -eq 'logs' })){ Copy-Item -LiteralPath $lg.FullName -Destination (Join-Path $raccolta ('journal_' + $lg.Directory.Parent.Name + '_' + $lg.Name)) -Force; $trov++ }
Copy-Item -LiteralPath $iniRun -Destination $raccolta -Force
if($trov -eq 0){ Write-Host 'Nessun report trovato: il tester potrebbe non essere partito. Mandami lo screenshot di questa finestra.' -ForegroundColor Red }
$zip=Join-Path $od ('CPI_M5_T2_' + $stamp + '.zip'); Compress-Archive -Path (Join-Path $raccolta '*') -DestinationPath $zip -Force
Write-Host ''
Write-Host '#########################################################' -ForegroundColor Black -BackgroundColor Yellow
Write-Host '###   >>>   QUESTO E LO ZIP DA MANDARE A CLAUDE   <<<   ###' -ForegroundColor Black -BackgroundColor Yellow
Write-Host $zip -ForegroundColor Black -BackgroundColor Yellow
Write-Host '#########################################################' -ForegroundColor Black -BackgroundColor Yellow
try { Start-Process explorer.exe -ArgumentList ('/select,"' + $zip + '"') } catch { }
