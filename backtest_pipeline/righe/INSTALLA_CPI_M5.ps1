# MARCATORE_INSTALLA_CPI_M5_v1
# Installa ABTG_CpiM5.mq5 (Experts), abtg_cpi_dates.csv (Common\Files) e 3 preset (MQL5\Presets) nel terminale PRINCIPALE BCM e COMPILA. Non apre grafici, non attacca l'EA, non apre ordini, non tocca conti/VPS. SHA256 di ogni file verificato; copie di sicurezza se esistono.
$ErrorActionPreference='Continue'
if($env:COMPUTERNAME -ne 'DESKTOP-H4D7CAJ'){ Write-Host ('Questa riga e pensata per il PC di backtest DESKTOP-H4D7CAJ. Qui: ' + $env:COMPUTERNAME + '. Continuo solo se il terminale BCM esiste.') -ForegroundColor Yellow }
$INST='C:\Program Files\BCM Markets MT5 Terminal'; $MEE=Join-Path $INST 'metaeditor64.exe'
if(-not (Test-Path -LiteralPath $MEE)){ Write-Host ('MI FERMO: non trovo ' + $MEE) -ForegroundColor Red; return }
$DATI=$null; $baseT=Join-Path $env:APPDATA 'MetaQuotes\Terminal'
foreach($o in @(Get-ChildItem -LiteralPath $baseT -Directory -ErrorAction SilentlyContinue)){ $of=Join-Path $o.FullName 'origin.txt'; if(Test-Path -LiteralPath $of){ $c0=((Get-Content -LiteralPath $of -Raw -Encoding Unicode) -replace '[\r\n\0]','').Trim(); if($c0 -ieq $INST){ $DATI=$o.FullName } } }
if(-not $DATI){ Write-Host 'MI FERMO: non trovo la cartella dati del terminale BCM principale.' -ForegroundColor Red; return }
$exp=Join-Path $DATI 'MQL5\Experts'; $pre=Join-Path $DATI 'MQL5\Presets'; $com=Join-Path $baseT 'Common\Files'
foreach($d in @($exp,$pre,$com)){ New-Item -ItemType Directory -Force -Path $d | Out-Null }
[Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12
$PIN='b91a2ddea2e6cc3e3aab8a4e3a5f667e58e5b719'
$FILES=@( @{ src='mql5/Experts/ABTG_CpiM5.mq5'; dst=(Join-Path $exp 'ABTG_CpiM5.mq5'); h='E183FADD0F301D7BFCA2198659EE275336B03EF7CD3E4796A4344A092059575C' }, @{ src='mql5/Files/abtg_cpi_dates.csv'; dst=(Join-Path $com 'abtg_cpi_dates.csv'); h='A625B8FE8BBA6EF754A71026A5393C09E22D923415E9CC7458D0823000F6654B' }, @{ src='mql5/Presets/ABTG_CpiM5_XAUUSD_B50.set'; dst=(Join-Path $pre 'ABTG_CpiM5_XAUUSD_B50.set'); h='1280CABE81653C08A06579CDAA431CFD2EF66A2A1B3613766D7B32B31EA6C407' }, @{ src='mql5/Presets/ABTG_CpiM5_XAUUSD_B100.set'; dst=(Join-Path $pre 'ABTG_CpiM5_XAUUSD_B100.set'); h='C00780835749A46B26C8AB2A9DDAA8E1DB471882E86839BBC015AA58633CA2EB' }, @{ src='mql5/Presets/ABTG_CpiM5_XAUUSD_B200.set'; dst=(Join-Path $pre 'ABTG_CpiM5_XAUUSD_B200.set'); h='B7493E33E46630857939E24DC4C22C54606917FD54410F5E37B03523C2C1BE84' } )
$W=Join-Path $env:TEMP 'cpi_m5'; New-Item -ItemType Directory -Force -Path $W | Out-Null
foreach($x in $FILES){
  $tmp=Join-Path $W ([IO.Path]::GetFileName($x.dst)); Remove-Item -LiteralPath $tmp -Force -ErrorAction SilentlyContinue
  irm ('https://raw.githubusercontent.com/claudiospadaro12/GITHUB/' + $PIN + '/' + $x.src + '?cb=' + [Guid]::NewGuid().ToString('N')) -OutFile $tmp
  $H=(Get-FileHash -LiteralPath $tmp -Algorithm SHA256).Hash.ToUpperInvariant(); if($H -ne $x.h){ Write-Host ('MI FERMO: SHA256 diverso per ' + $x.src) -ForegroundColor Red; return }
}
foreach($x in $FILES){ $tmp=Join-Path $W ([IO.Path]::GetFileName($x.dst)); if(Test-Path -LiteralPath $x.dst){ Copy-Item -LiteralPath $x.dst -Destination ($x.dst + '.bak_' + (Get-Date).ToString('yyyyMMdd_HHmmss')) -Force }; Copy-Item -LiteralPath $tmp -Destination $x.dst -Force; Write-Host ('Copiato: ' + $x.dst) -ForegroundColor Green }
$dst=$FILES[0].dst; $ex5=[IO.Path]::ChangeExtension($dst,'.ex5'); Remove-Item -LiteralPath $ex5 -Force -ErrorAction SilentlyContinue
$desk=[Environment]::GetFolderPath('Desktop'); $od=Join-Path $desk 'ABTG_RISULTATI'; New-Item -ItemType Directory -Force -Path $od | Out-Null
$log=Join-Path $od ('CPI_M5_compilazione_' + (Get-Date).ToString('yyyyMMdd_HHmm') + '.log')
[void](Start-Process -FilePath $MEE -ArgumentList ('/compile:"' + $dst + '" /include:"' + (Join-Path $DATI 'MQL5') + '" /log:"' + $log + '"') -PassThru -Wait)
$esito='NESSUN LOG'; if(Test-Path -LiteralPath $log){ $b=[IO.File]::ReadAllBytes($log); $tx=$(if($b.Length -ge 2 -and $b[0] -eq 255 -and $b[1] -eq 254){ [Text.Encoding]::Unicode.GetString($b) } else { [Text.Encoding]::UTF8.GetString($b) }); $m=[regex]::Match($tx,'Result:\s*(\d+) errors?,\s*(\d+) warnings?'); if($m.Success){ $esito=('errori ' + $m.Groups[1].Value + ', avvisi ' + $m.Groups[2].Value) }; ($tx -split "`r?`n" | Where-Object { $_ -match 'error' } | Select-Object -First 25) | ForEach-Object { Write-Host $_ -ForegroundColor Red } }
if((Test-Path -LiteralPath $ex5) -and $esito -match 'errori 0'){ Write-Host ('COMPILATO: ' + $esito + '. File pronto: ' + $ex5) -ForegroundColor Green } else { Write-Host ('COMPILAZIONE NON RIUSCITA (' + $esito + '): allegami il log qui sotto.') -ForegroundColor Red }
Write-Host ''
Write-Host '##########  FILE DA ALLEGARE ALLA CHAT (solo se ci sono errori)  ##########' -ForegroundColor Black -BackgroundColor Yellow
Write-Host $log -ForegroundColor Black -BackgroundColor Yellow
try { if(Test-Path -LiteralPath $log){ Start-Process explorer.exe -ArgumentList ('/select,"' + $log + '"') } } catch { }
