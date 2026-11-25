# MARCATORE_INSTALLA_ORB_SEMI_v1
# Scarica ABTG_ORB_Semi.mq5 dal repository (SHA256 verificato), lo copia in MQL5\Experts del terminale PRINCIPALE BCM e lo COMPILA con MetaEditor. Non apre grafici, non attacca l'EA, non tocca conti, VPS o ordini. Se esiste gia un file con lo stesso nome ne fa una copia .bak.
$ErrorActionPreference='Continue'
if($env:COMPUTERNAME -ne 'DESKTOP-H4D7CAJ'){ Write-Host ('Questa riga e pensata per il PC di backtest DESKTOP-H4D7CAJ. Qui: ' + $env:COMPUTERNAME + '. Continuo solo se il terminale BCM esiste.') -ForegroundColor Yellow }
$INST='C:\Program Files\BCM Markets MT5 Terminal'; $MEE=Join-Path $INST 'metaeditor64.exe'
if(-not (Test-Path -LiteralPath $MEE)){ Write-Host ('MI FERMO: non trovo ' + $MEE) -ForegroundColor Red; return }
$DATI=$null; $baseT=Join-Path $env:APPDATA 'MetaQuotes\Terminal'
foreach($o in @(Get-ChildItem -LiteralPath $baseT -Directory -ErrorAction SilentlyContinue)){ $of=Join-Path $o.FullName 'origin.txt'; if(Test-Path -LiteralPath $of){ $c0=((Get-Content -LiteralPath $of -Raw -Encoding Unicode) -replace '[\r\n\0]','').Trim(); if($c0.TrimEnd('\') -eq $INST){ $DATI=$o.FullName; break } } }
if(-not $DATI){ Write-Host 'MI FERMO: non trovo la cartella dati del terminale BCM principale.' -ForegroundColor Red; return }
$exp=Join-Path $DATI 'MQL5\Experts'; if(-not (Test-Path -LiteralPath $exp)){ Write-Host ('MI FERMO: non esiste ' + $exp) -ForegroundColor Red; return }
[Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12
$PIN='fe69797cd7f4e5a7cf42474cf923d56d022e9e1b'; $SHA='D1FE2532350137DC3A48B18EA9608D0A77E3F9265D606484DE6713381840C806'; $W=Join-Path $env:TEMP 'orb_semi'; New-Item -ItemType Directory -Force -Path $W | Out-Null
$tmp=Join-Path $W 'ABTG_ORB_Semi.mq5'; Remove-Item -LiteralPath $tmp -Force -ErrorAction SilentlyContinue
irm ('https://raw.githubusercontent.com/claudiospadaro12/GITHUB/' + $PIN + '/mql5/Experts/ABTG_ORB_Semi.mq5?cb=' + [Guid]::NewGuid().ToString('N')) -OutFile $tmp
$H=(Get-FileHash -LiteralPath $tmp -Algorithm SHA256).Hash.ToUpperInvariant(); if($H -ne $SHA){ Write-Host ('MI FERMO: SHA256 diverso: ' + $H) -ForegroundColor Red; return }
$dst=Join-Path $exp 'ABTG_ORB_Semi.mq5'
if(Test-Path -LiteralPath $dst){ $bak=$dst + '.bak_' + (Get-Date).ToString('yyyyMMdd_HHmmss'); Copy-Item -LiteralPath $dst -Destination $bak -Force; Write-Host ('Copia di sicurezza del file precedente: ' + $bak) -ForegroundColor Yellow }
Copy-Item -LiteralPath $tmp -Destination $dst -Force
$desk=[Environment]::GetFolderPath('Desktop'); $od=Join-Path $desk 'ABTG_RISULTATI'; New-Item -ItemType Directory -Force -Path $od | Out-Null
$log=Join-Path $od ('ORB_Semi_compilazione_' + (Get-Date).ToString('yyyyMMdd_HHmm') + '.log'); $ex5=[IO.Path]::ChangeExtension($dst,'.ex5'); Remove-Item -LiteralPath $ex5 -Force -ErrorAction SilentlyContinue
[void](Start-Process -FilePath $MEE -ArgumentList ('/compile:"' + $dst + '" /include:"' + (Join-Path $DATI 'MQL5') + '" /log:"' + $log + '"') -PassThru -Wait)
$esito='NESSUN LOG'; if(Test-Path -LiteralPath $log){ $b=[IO.File]::ReadAllBytes($log); $tx=$(if($b.Length -ge 2 -and $b[0] -eq 255 -and $b[1] -eq 254){ [Text.Encoding]::Unicode.GetString($b) } else { [Text.Encoding]::UTF8.GetString($b) }); $m=[regex]::Match($tx,'Result:\s*(\d+) errors?,\s*(\d+) warnings?'); if($m.Success){ $esito=('errori ' + $m.Groups[1].Value + ', avvisi ' + $m.Groups[2].Value) }; ($tx -split "`r?`n" | Where-Object { $_ -match 'error|warning' } | Select-Object -First 25) | ForEach-Object { Write-Host $_ -ForegroundColor Red } }
if((Test-Path -LiteralPath $ex5) -and $esito -match 'errori 0'){ Write-Host ('COMPILATO: ' + $esito + '. File pronto: ' + $ex5) -ForegroundColor Green } else { Write-Host ('COMPILAZIONE NON RIUSCITA (' + $esito + '): allegami il log qui sotto.') -ForegroundColor Red }
Write-Host ''
Write-Host '##########  FILE DA ALLEGARE ALLA CHAT (solo se ci sono errori)  ##########' -ForegroundColor Black -BackgroundColor Yellow
Write-Host $log -ForegroundColor Black -BackgroundColor Yellow
try { if(Test-Path -LiteralPath $log){ Start-Process explorer.exe -ArgumentList ('/select,"' + $log + '"') } } catch { }
