# MARCATORE_NEWS_EXPORT_BCM_v1
# SOLA LETTURA: esporta dal calendario economico del terminale BCM portabile (C:\MT5_BCM_Opt) le notizie storiche USD ed EUR (impatto >= medio, dal 2013) in Common\Files\abtg_news_hist.csv e ne copia una copia sul Desktop. Nessun ordine, nessun conto toccato. Il terminale parte da solo con lo script e si chiude da solo (fino a ~6 minuti).
$ErrorActionPreference='Continue'
if($env:COMPUTERNAME -ne 'DESKTOP-H4D7CAJ'){ Write-Host ('SOLO sul PC di backtest DESKTOP-H4D7CAJ. Qui: ' + $env:COMPUTERNAME) -ForegroundColor Red; return }
$ROOT='C:\MT5_BCM_Opt'; $TRM=Join-Path $ROOT 'terminal64.exe'; $MEE=Join-Path $ROOT 'metaeditor64.exe'; $MQL5=Join-Path $ROOT 'MQL5'
$PINSRC='d31f09cb5c87322be1fe861c2a1e7e3baca1fac2'; $SHAMQ5='EB1A2D8D114111D9C69D966BE4B738E91049D901D9B9EC7B55AAB4CDD5481A00'
$aperti=@(Get-Process -Name terminal64,metatester64,metaeditor64 -ErrorAction SilentlyContinue)
if($aperti.Count -gt 0){ $aperti | Select-Object Id,ProcessName,Path | Format-Table -AutoSize | Out-String | Write-Host; Write-Host 'MI FERMO: MT5, MetaEditor o agenti aperti. Chiudili e rilancia. Non ho avviato niente.' -ForegroundColor Red; return }
foreach($pp in @($TRM,$MEE,$MQL5)){ if(-not (Test-Path -LiteralPath $pp)){ Write-Host ('MI FERMO: non trovo ' + $pp) -ForegroundColor Red; return } }
function LeggiTesto([string]$p){ $b=[IO.File]::ReadAllBytes($p); if($b.Length -ge 2 -and (($b[0] -eq 255 -and $b[1] -eq 254) -or ($b[0] -eq 254 -and $b[1] -eq 255))){ return [Text.Encoding]::Unicode.GetString($b) } else { return [Text.Encoding]::UTF8.GetString($b) } }
[Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12
$W=Join-Path $env:TEMP 'newsexport'; New-Item -ItemType Directory -Force -Path $W | Out-Null
$src=Join-Path $W 'ABTG_NewsExport.mq5'; Remove-Item -LiteralPath $src -Force -ErrorAction SilentlyContinue
irm ('https://raw.githubusercontent.com/claudiospadaro12/GITHUB/' + $PINSRC + '/mql5/Scripts/ABTG_NewsExport.mq5?cb=' + [Guid]::NewGuid().ToString('N')) -OutFile $src
$hh=(Get-FileHash -LiteralPath $src -Algorithm SHA256).Hash.ToUpperInvariant()
if($hh -ne $SHAMQ5){ Write-Host ('MI FERMO: SHA256 diverso per lo script: ' + $hh) -ForegroundColor Red; return }
$dstDir=Join-Path $MQL5 'Scripts'; New-Item -ItemType Directory -Force -Path $dstDir | Out-Null
$dst=Join-Path $dstDir 'ABTG_NewsExport.mq5'; Copy-Item -LiteralPath $src -Destination $dst -Force
$logc=Join-Path $W 'compila.log'; Remove-Item -LiteralPath $logc -Force -ErrorAction SilentlyContinue
$ex5=[IO.Path]::ChangeExtension($dst,'.ex5'); Remove-Item -LiteralPath $ex5 -Force -ErrorAction SilentlyContinue
[void](Start-Process -FilePath $MEE -ArgumentList ('/portable /compile:"' + $dst + '" /include:"' + $MQL5 + '" /log:"' + $logc + '"') -PassThru -Wait)
if(-not (Test-Path -LiteralPath $logc)){ Write-Host 'MI FERMO: nessun log di compilazione.' -ForegroundColor Red; return }
$txc=LeggiTesto $logc
if(-not ((Test-Path -LiteralPath $ex5) -and ($txc -match 'Result:\s*0 errors'))){ Write-Host 'COMPILAZIONE NON RIUSCITA: incollami queste righe.' -ForegroundColor Red; ($txc -split "`r?`n" | Where-Object { $_ -match 'error' }) | ForEach-Object { Write-Host ('   ' + $_) }; return }
Write-Host 'COMPILATO ABTG_NewsExport' -ForegroundColor Green
$cf=Join-Path $env:APPDATA 'MetaQuotes\Terminal\Common\Files'; New-Item -ItemType Directory -Force -Path $cf | Out-Null
foreach($n in @('abtg_news_hist.csv','abtg_news_hist_FINE.txt')){ Remove-Item -LiteralPath (Join-Path $cf $n) -Force -ErrorAction SilentlyContinue }
$ini=Join-Path $W 'newsexport.ini'
Set-Content -LiteralPath $ini -Value ("[Charts]`r`nMaxBars=2000000000`r`n`r`n[StartUp]`r`nScript=ABTG_NewsExport`r`nSymbol=XAUUSD`r`nPeriod=H1`r`n") -Encoding Unicode
Write-Host ('Avvio ' + (Get-Date).ToString('HH:mm') + ': il terminale parte, lo script lavora (1-6 minuti) e lo chiude da solo. NON toccare MT5.') -ForegroundColor Cyan
$t0=Get-Date; $pr=Start-Process -FilePath $TRM -ArgumentList ('/portable /config:"' + $ini + '"') -PassThru
$scade=$t0.AddMinutes(12); $fine=$false
while((Get-Date) -lt $scade){ Start-Sleep -Seconds 4; if(Test-Path -LiteralPath (Join-Path $cf 'abtg_news_hist_FINE.txt')){ $fine=$true; break }; if($pr.HasExited){ break } }
Start-Sleep -Seconds 4
$w2=Get-Date; while(-not $pr.HasExited -and ((Get-Date)-$w2).TotalSeconds -lt 60){ Start-Sleep -Seconds 3 }
if(-not $pr.HasExited){ Write-Host 'Il terminale e ancora aperto: chiudilo tu a mano (File > Esci).' -ForegroundColor Yellow }
$stamp=(Get-Date).ToString('yyyyMMdd_HHmm'); $desk=[Environment]::GetFolderPath('Desktop')
$out=Join-Path (Join-Path $desk 'ABTG_RISULTATI') ('NEWSEXPORT_' + $stamp); New-Item -ItemType Directory -Force -Path $out | Out-Null
$csv=Join-Path $cf 'abtg_news_hist.csv'; $fn=Join-Path $cf 'abtg_news_hist_FINE.txt'
if(-not ((Test-Path -LiteralPath $csv) -and (Test-Path -LiteralPath $fn))){ Write-Host 'NESSUN FILE PRODOTTO: il terminale potrebbe non essere collegato al server o il calendario non e disponibile. Dimmi cosa vedi.' -ForegroundColor Red; return }
Copy-Item -LiteralPath $csv -Destination (Join-Path $out 'abtg_news_hist.csv') -Force; Copy-Item -LiteralPath $fn -Destination (Join-Path $out 'abtg_news_hist_FINE.txt') -Force
$righe=@(Get-Content -LiteralPath $csv).Count - 1
Write-Host ('Notizie esportate: ' + $righe) -ForegroundColor Green
Get-Content -LiteralPath $fn | ForEach-Object { Write-Host ('  ' + $_) }
$zip=Join-Path (Join-Path $desk 'ABTG_RISULTATI') ('NEWSEXPORT_' + $stamp + '.zip')
Compress-Archive -Path (Join-Path $out '*') -DestinationPath $zip -Force
Write-Host ''
Write-Host ('>>> ALLEGA QUESTO FILE: ' + $zip + ' <<<') -ForegroundColor Black -BackgroundColor Yellow
Write-Host ('(contiene abtg_news_hist.csv + abtg_news_hist_FINE.txt; il file per i test e anche in ' + $cf + ')') -ForegroundColor Black -BackgroundColor Yellow
Start-Process explorer.exe -ArgumentList ('/select,"' + $zip + '"')
