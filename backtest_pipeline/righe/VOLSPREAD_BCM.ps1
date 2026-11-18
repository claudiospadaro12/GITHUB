# MARCATORE_VOLSPREAD_BCM_v1
# ATR medio e spread medio dei 22 cross del paniere Bulge su BCM, 2022-2025, dalle barre H1 della cronologia. SOLA LETTURA: nessun ordine, nessun EA. Compila e lancia lo script ABTG_VolSpread nel terminale portabile C:\MT5_BCM_Opt (deve essere CHIUSO). Criteri: report/BULGE_S_CRITERI_2026-11-18.md (aggiunta H-vol).
$ErrorActionPreference='Continue'
if($env:COMPUTERNAME -ne 'DESKTOP-H4D7CAJ'){ Write-Host ('SOLO sul PC di backtest DESKTOP-H4D7CAJ. Qui: ' + $env:COMPUTERNAME) -ForegroundColor Red; return }
$ROOT='C:\MT5_BCM_Opt'; $TRM=Join-Path $ROOT 'terminal64.exe'; $MEE=Join-Path $ROOT 'metaeditor64.exe'; $MQL5=Join-Path $ROOT 'MQL5'
$PINSRC='00aaeedd19ea8539f28c94cfb2f59d2e02131f2d'; $SHAMQ5='64DDEE55850048F4E7BC4C8BEF2CDDED9109D02AF3488E3C4B1F5AA1112CD20E'
$aperti=@(Get-Process -Name terminal64,metatester64,metaeditor64 -ErrorAction SilentlyContinue)
if($aperti.Count -gt 0){ $aperti | Select-Object Id,ProcessName,Path | Format-Table -AutoSize | Out-String | Write-Host; Write-Host 'MI FERMO: MT5, MetaEditor o agenti del tester aperti (forse il test Bulge_S e ancora in corso). Chiudi/aspetta e rilancia. Non ho avviato niente.' -ForegroundColor Red; return }
foreach($pp in @($TRM,$MEE,$MQL5)){ if(-not (Test-Path -LiteralPath $pp)){ Write-Host ('MI FERMO: non trovo ' + $pp) -ForegroundColor Red; return } }
$W=Join-Path $env:TEMP 'volspread'; New-Item -ItemType Directory -Force -Path $W | Out-Null
[Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12
$src=Join-Path $W 'ABTG_VolSpread.mq5'; Remove-Item -LiteralPath $src -Force -ErrorAction SilentlyContinue
irm ('https://raw.githubusercontent.com/claudiospadaro12/GITHUB/' + $PINSRC + '/mql5/Scripts/ABTG_VolSpread.mq5?cb=' + [Guid]::NewGuid().ToString('N')) -OutFile $src
$hh=(Get-FileHash -LiteralPath $src -Algorithm SHA256).Hash.ToUpperInvariant()
if($hh -ne $SHAMQ5){ Write-Host ('MI FERMO: SHA256 diverso per lo script: ' + $hh) -ForegroundColor Red; return }
$dstDir=Join-Path $MQL5 'Scripts'; New-Item -ItemType Directory -Force -Path $dstDir | Out-Null
$dst=Join-Path $dstDir 'ABTG_VolSpread.mq5'; Copy-Item -LiteralPath $src -Destination $dst -Force
$logc=Join-Path $W 'compila.log'; Remove-Item -LiteralPath $logc -Force -ErrorAction SilentlyContinue
$ex5=[IO.Path]::ChangeExtension($dst,'.ex5'); Remove-Item -LiteralPath $ex5 -Force -ErrorAction SilentlyContinue
[void](Start-Process -FilePath $MEE -ArgumentList ('/portable /compile:"' + $dst + '" /include:"' + $MQL5 + '" /log:"' + $logc + '"') -PassThru -Wait)
if(-not (Test-Path -LiteralPath $logc)){ Write-Host 'MI FERMO: nessun log di compilazione.' -ForegroundColor Red; return }
$b=[IO.File]::ReadAllBytes($logc); $txc=$(if($b.Length -ge 2 -and $b[0] -eq 255 -and $b[1] -eq 254){ [Text.Encoding]::Unicode.GetString($b) } else { [Text.Encoding]::UTF8.GetString($b) })
if(-not ((Test-Path -LiteralPath $ex5) -and ($txc -match 'Result:\s*0 errors'))){ Write-Host 'COMPILAZIONE NON RIUSCITA: incollami queste righe.' -ForegroundColor Red; ($txc -split "`r?`n" | Where-Object { $_ -match 'error' }) | ForEach-Object { Write-Host ('   ' + $_) }; return }
Write-Host 'COMPILATO ABTG_VolSpread' -ForegroundColor Green
$cf=Join-Path $env:APPDATA 'MetaQuotes\Terminal\Common\Files'; $lf=Join-Path $MQL5 'Files'
foreach($d in @($cf,$lf)){ New-Item -ItemType Directory -Force -Path $d | Out-Null; foreach($n in @('ABTG_VOLSPREAD.csv','ABTG_VOLSPREAD_FINE.txt')){ Remove-Item -LiteralPath (Join-Path $d $n) -Force -ErrorAction SilentlyContinue } }
$ini=Join-Path $W 'volspread.ini'
Set-Content -LiteralPath $ini -Value ("[Charts]`r`nMaxBars=2000000000`r`n`r`n[StartUp]`r`nScript=ABTG_VolSpread`r`nSymbol=EURUSD`r`nPeriod=H1`r`n") -Encoding Unicode
Write-Host ('Avvio ' + (Get-Date).ToString('HH:mm') + ': il terminale parte, lo script lavora (circa 2-10 minuti) e lo chiude da solo. NON toccare MT5.') -ForegroundColor Cyan
$t0=Get-Date; $pr=Start-Process -FilePath $TRM -ArgumentList ('/portable /config:"' + $ini + '"') -PassThru
$scade=$t0.AddMinutes(40); $fine=$null
while((Get-Date) -lt $scade){ Start-Sleep -Seconds 5
  foreach($d in @($lf,$cf)){ $f=Join-Path $d 'ABTG_VOLSPREAD_FINE.txt'; if(Test-Path -LiteralPath $f){ $fine=$f } }
  if($fine){ break }
  if($pr.HasExited){ break } }
if(-not $fine){ Write-Host 'Lo script non ha scritto il file di fine entro il tempo (o il terminale si e chiuso prima). Allego quello che c e.' -ForegroundColor Red }
Start-Sleep -Seconds 5
$csv=$null; foreach($d in @($lf,$cf)){ $f=Join-Path $d 'ABTG_VOLSPREAD.csv'; if(Test-Path -LiteralPath $f){ if(-not $csv -or (Get-Item -LiteralPath $f).LastWriteTime -gt (Get-Item -LiteralPath $csv).LastWriteTime){ $csv=$f } } }
$desk=[Environment]::GetFolderPath('Desktop'); $dirOut=Join-Path $desk 'VOLSPREAD_BCM'; New-Item -ItemType Directory -Force -Path $dirOut | Out-Null
if($csv){ Copy-Item -LiteralPath $csv -Destination (Join-Path $dirOut 'ABTG_VOLSPREAD.csv') -Force; $rows=@(Get-Content -LiteralPath $csv).Count - 1; Write-Host ('Righe di risultato: ' + $rows + ' (attese 88)') -ForegroundColor Green } else { Write-Host 'NESSUN CSV trovato.' -ForegroundColor Red }
$zip=Join-Path $desk 'VOLSPREAD_BCM.zip'; Remove-Item -LiteralPath $zip -Force -ErrorAction SilentlyContinue
try { Compress-Archive -Path (Join-Path $dirOut '*') -DestinationPath $zip -Force } catch { Write-Host 'ZIP non creato: allega la cartella a mano.' -ForegroundColor Red }
Write-Host ''
Write-Host '##########  FILE DA ALLEGARE ALLA CHAT  ##########' -ForegroundColor Black -BackgroundColor Yellow
Write-Host $zip -ForegroundColor Black -BackgroundColor Yellow
Write-Host '(contiene: ABTG_VOLSPREAD.csv; Esplora file si apre con lo zip selezionato)' -ForegroundColor Black -BackgroundColor Yellow
try { Start-Process -FilePath 'explorer.exe' -ArgumentList ('/select,"' + $zip + '"') } catch { }
