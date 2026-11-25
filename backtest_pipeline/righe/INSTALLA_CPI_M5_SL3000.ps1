# MARCATORE_INSTALLA_CPI_M5_SL3000_v1
# Copia il preset ABTG_CpiM5_XAUUSD_B100_SL3000.set nel terminale PRINCIPALE BCM: in MQL5\Presets e in MQL5\Profiles\Tester (la cartella che il tasto Carica del Tester apre da solo). Non compila, non apre grafici, non tocca ordini, conti o VPS. SHA256 verificato.
$ErrorActionPreference='Continue'
$INST='C:\Program Files\BCM Markets MT5 Terminal'; $DATI=$null; $baseT=Join-Path $env:APPDATA 'MetaQuotes\Terminal'
foreach($o in @(Get-ChildItem -LiteralPath $baseT -Directory -ErrorAction SilentlyContinue)){ $of=Join-Path $o.FullName 'origin.txt'; if(Test-Path -LiteralPath $of){ $c0=((Get-Content -LiteralPath $of -Raw -Encoding Unicode) -replace '[\r\n\0]','').Trim(); if($c0 -ieq $INST){ $DATI=$o.FullName } } }
if(-not $DATI){ Write-Host 'MI FERMO: non trovo la cartella dati del terminale BCM principale.' -ForegroundColor Red; return }
[Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12
$PIN='dfd7c28bdcef188b5dd84ae3c52868f907b98f38'; $SHA='3E092AC9F223A38939E6ECD5228998F408D08FBB32C54737A8B707D43E78272C'; $N='ABTG_CpiM5_XAUUSD_B100_SL3000.set'
$tmp=Join-Path $env:TEMP $N; Remove-Item -LiteralPath $tmp -Force -ErrorAction SilentlyContinue
irm ('https://raw.githubusercontent.com/claudiospadaro12/GITHUB/' + $PIN + '/mql5/Presets/' + $N + '?cb=' + [Guid]::NewGuid().ToString('N')) -OutFile $tmp
$H=(Get-FileHash -LiteralPath $tmp -Algorithm SHA256).Hash.ToUpperInvariant(); if($H -ne $SHA){ Write-Host ('MI FERMO: SHA256 diverso: ' + $H) -ForegroundColor Red; return }
$ultimo=$null
foreach($sub in @('MQL5\Presets','MQL5\Profiles\Tester')){ $dir=Join-Path $DATI $sub; New-Item -ItemType Directory -Force -Path $dir | Out-Null; $dst=Join-Path $dir $N; Copy-Item -LiteralPath $tmp -Destination $dst -Force; Write-Host ('Copiato: ' + $dst) -ForegroundColor Green; $ultimo=$dst }
Write-Host ''
Write-Host 'COME USARLO: Strategy Tester -> scheda Input -> clic destro -> Carica: si apre gia la cartella giusta, scegli ABTG_CpiM5_XAUUSD_B100_SL3000.set.' -ForegroundColor Yellow
Write-Host '##########  FILE COPIATO (nessun allegato richiesto)  ##########' -ForegroundColor Black -BackgroundColor Yellow
Write-Host $ultimo -ForegroundColor Black -BackgroundColor Yellow
try { Start-Process explorer.exe -ArgumentList ('/select,"' + $ultimo + '"') } catch { }
