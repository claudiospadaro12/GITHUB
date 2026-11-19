# MARCATORE_EXPORT_H4_METAQUOTES_v1
# SOLA LETTURA: trova sul PC di backtest il terminale MT5 collegato al server MetaQuotes-Demo (installazione standard), compila ed esegue lo script ABTG_ExportH4 (barre H4 dal 2010 dei mercati non forex e non azionari), copia i file in C:\ABTG_RISULTATI e li comprime in uno o piu zip. Nessun ordine, nessun conto reale toccato (il terminale usa il conto DEMO MetaQuotes).
$ErrorActionPreference='Continue'
if($env:COMPUTERNAME -ne 'DESKTOP-H4D7CAJ'){ Write-Host ('SOLO sul PC di backtest DESKTOP-H4D7CAJ. Qui: ' + $env:COMPUTERNAME) -ForegroundColor Red; return }
$PINSRC='@@PIN@@'; $SHAMQ5='@@SHA@@'
$aperti=@(Get-Process -Name terminal64,metatester64,metaeditor64 -ErrorAction SilentlyContinue)
if($aperti.Count -gt 0){ $aperti | Select-Object Id,ProcessName,Path | Format-Table -AutoSize | Out-String | Write-Host; Write-Host 'MI FERMO: MT5, MetaEditor o agenti aperti. Chiudili e rilancia. Non ho avviato niente.' -ForegroundColor Red; return }
function LeggiTesto([string]$p){ $b=[IO.File]::ReadAllBytes($p); if($b.Length -ge 2 -and (($b[0] -eq 255 -and $b[1] -eq 254) -or ($b[0] -eq 254 -and $b[1] -eq 255))){ return [Text.Encoding]::Unicode.GetString($b) } else { return [Text.Encoding]::UTF8.GetString($b) } }
# 1) terminale MetaQuotes-Demo: cartella dati con bases\MetaQuotes-Demo
$radice=Join-Path $env:APPDATA 'MetaQuotes\Terminal'; $DATI=$null; $INST=$null
foreach($d in @(Get-ChildItem -LiteralPath $radice -Directory -ErrorAction SilentlyContinue)){
  if($d.Name -ieq 'Common'){ continue }
  if(-not (Test-Path -LiteralPath (Join-Path $d.FullName 'bases\MetaQuotes-Demo'))){ continue }
  $o=Join-Path $d.FullName 'origin.txt'; if(-not (Test-Path -LiteralPath $o)){ continue }
  $inst=((LeggiTesto $o) -replace '[^\u0020-\u007E]','').Trim()
  if(Test-Path -LiteralPath (Join-Path $inst 'terminal64.exe')){ $DATI=$d.FullName; $INST=$inst; break }
}
if(-not $DATI){
  Write-Host 'NON TROVO un terminale MT5 collegato a MetaQuotes-Demo su questo PC.' -ForegroundColor Yellow
  Write-Host 'Cosa fare (5 minuti): scarica MetaTrader 5 da metatrader5.com (installazione standard: apre da solo un conto DEMO MetaQuotes-Demo), lascialo aprirsi, aspetta che in basso compaiano le quotazioni, CHIUDILO (File > Esci) e rilancia questa riga.' -ForegroundColor Yellow
  return
}
Write-Host ('Terminale trovato: ' + $INST) -ForegroundColor Green
$TRM=Join-Path $INST 'terminal64.exe'; $MEE=Join-Path $INST 'metaeditor64.exe'; $MQL5=Join-Path $DATI 'MQL5'
if(-not (Test-Path -LiteralPath $MEE)){ Write-Host ('MI FERMO: non trovo ' + $MEE) -ForegroundColor Red; return }
[Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12
$W=Join-Path $env:TEMP 'exporth4'; New-Item -ItemType Directory -Force -Path $W | Out-Null
$src=Join-Path $W 'ABTG_ExportH4.mq5'; Remove-Item -LiteralPath $src -Force -ErrorAction SilentlyContinue
irm ('https://raw.githubusercontent.com/claudiospadaro12/GITHUB/' + $PINSRC + '/mql5/Scripts/ABTG_ExportH4.mq5?cb=' + [Guid]::NewGuid().ToString('N')) -OutFile $src
$hh=(Get-FileHash -LiteralPath $src -Algorithm SHA256).Hash.ToUpperInvariant()
if($hh -ne $SHAMQ5){ Write-Host ('MI FERMO: SHA256 diverso per lo script: ' + $hh) -ForegroundColor Red; return }
$dstDir=Join-Path $MQL5 'Scripts'; New-Item -ItemType Directory -Force -Path $dstDir | Out-Null
$dst=Join-Path $dstDir 'ABTG_ExportH4.mq5'; Copy-Item -LiteralPath $src -Destination $dst -Force
$logc=Join-Path $W 'compila.log'; Remove-Item -LiteralPath $logc -Force -ErrorAction SilentlyContinue
$ex5=[IO.Path]::ChangeExtension($dst,'.ex5'); Remove-Item -LiteralPath $ex5 -Force -ErrorAction SilentlyContinue
[void](Start-Process -FilePath $MEE -ArgumentList ('/compile:"' + $dst + '" /include:"' + $MQL5 + '" /log:"' + $logc + '"') -PassThru -Wait)
if(-not (Test-Path -LiteralPath $logc)){ Write-Host 'MI FERMO: nessun log di compilazione.' -ForegroundColor Red; return }
$txc=LeggiTesto $logc
if(-not ((Test-Path -LiteralPath $ex5) -and ($txc -match 'Result:\s*0 errors'))){ Write-Host 'COMPILAZIONE NON RIUSCITA: incollami queste righe.' -ForegroundColor Red; ($txc -split "`r?`n" | Where-Object { $_ -match 'error' }) | ForEach-Object { Write-Host ('   ' + $_) }; return }
Write-Host 'COMPILATO ABTG_ExportH4' -ForegroundColor Green
$lf=Join-Path $MQL5 'Files'; New-Item -ItemType Directory -Force -Path $lf | Out-Null
foreach($f in @(Get-ChildItem -LiteralPath $lf -Filter 'ABTG_H4_*' -File -ErrorAction SilentlyContinue)){ Remove-Item -LiteralPath $f.FullName -Force -ErrorAction SilentlyContinue }
$ini=Join-Path $W 'exporth4.ini'
Set-Content -LiteralPath $ini -Value ("[Charts]`r`nMaxBars=2000000000`r`n`r`n[StartUp]`r`nScript=ABTG_ExportH4`r`nSymbol=EURUSD`r`nPeriod=H1`r`n") -Encoding Unicode
Write-Host ('Avvio ' + (Get-Date).ToString('HH:mm') + ': il terminale parte, scarica e scrive le barre (da 5 a 40 minuti) e si chiude da solo. NON toccare MT5. PC alla corrente.') -ForegroundColor Cyan
$t0=Get-Date; $pr=Start-Process -FilePath $TRM -ArgumentList ('/config:"' + $ini + '"') -PassThru
$fineF=Join-Path $lf 'ABTG_H4_FINE.txt'; $scade=$t0.AddMinutes(90); $ult=Get-Date
while((Get-Date) -lt $scade){ Start-Sleep -Seconds 5; if(Test-Path -LiteralPath $fineF){ break }; if($pr.HasExited){ break }; if(((Get-Date)-$ult).TotalMinutes -ge 5){ $ult=Get-Date; $nf=@(Get-ChildItem -LiteralPath $lf -Filter 'ABTG_H4_*.csv' -File -ErrorAction SilentlyContinue).Count; Write-Host ('[' + (Get-Date).ToString('HH:mm') + '] file esportati finora: ' + $nf) -ForegroundColor Gray } }
Start-Sleep -Seconds 4
$w2=Get-Date; while(-not $pr.HasExited -and ((Get-Date)-$w2).TotalSeconds -lt 60){ Start-Sleep -Seconds 3 }
if(-not $pr.HasExited){ Write-Host 'Il terminale e ancora aperto: chiudilo tu a mano (File > Esci).' -ForegroundColor Yellow }
$stamp=(Get-Date).ToString('yyyyMMdd_HHmm'); $outDir=Join-Path 'C:\ABTG_RISULTATI' ('EXPORT_H4_' + $stamp); New-Item -ItemType Directory -Force -Path $outDir | Out-Null
$el=Join-Path $lf 'ABTG_H4_ELENCO.csv'
if(-not (Test-Path -LiteralPath $el)){ Write-Host 'NESSUN ELENCO PRODOTTO: il terminale potrebbe non essere collegato a MetaQuotes-Demo. Aprilo a mano, controlla che le quotazioni arrivino, chiudilo e rilancia.' -ForegroundColor Red; return }
$files=@(Get-ChildItem -LiteralPath $lf -Filter 'ABTG_H4_*' -File | Where-Object { $_.Name -ne 'ABTG_H4_FINE.txt' })
foreach($f in $files){ Copy-Item -LiteralPath $f.FullName -Destination (Join-Path $outDir $f.Name) -Force }
if(Test-Path -LiteralPath $fineF){ Copy-Item -LiteralPath $fineF -Destination (Join-Path $outDir 'ABTG_H4_FINE.txt') -Force; Get-Content -LiteralPath $fineF | ForEach-Object { Write-Host ('  ' + $_) -ForegroundColor Green } }
$nCsv=@($files | Where-Object { $_.Name -ne 'ABTG_H4_ELENCO.csv' }).Count
Write-Host ('Simboli con barre esportate: ' + $nCsv) -ForegroundColor Green
# zip a pezzi (circa 60 MB di CSV ciascuno) per poterli allegare
$zips=@(); $cur=@(); $curMB=0.0; $parte=1
foreach($f in @($files | Sort-Object @{ Expression={ if($_.Name -eq 'ABTG_H4_ELENCO.csv'){ 0 } else { 1 } } }, Name)){
  $cur += $f.FullName; $curMB += ($f.Length / 1MB)
  if($curMB -ge 60){ $z=Join-Path 'C:\ABTG_RISULTATI' ('EXPORT_H4_' + $stamp + '_parte' + $parte + '.zip'); Compress-Archive -LiteralPath $cur -DestinationPath $z -Force; $zips += $z; $parte++; $cur=@(); $curMB=0.0 }
}
if($cur.Count -gt 0){ $z=Join-Path 'C:\ABTG_RISULTATI' ('EXPORT_H4_' + $stamp + '_parte' + $parte + '.zip'); Compress-Archive -LiteralPath $cur -DestinationPath $z -Force; $zips += $z }
Write-Host ''
Write-Host '##########  FILE DA ALLEGARE ALLA CHAT  ##########' -ForegroundColor Black -BackgroundColor Yellow
foreach($z in $zips){ Write-Host ($z + '  (' + [math]::Round((Get-Item -LiteralPath $z).Length / 1MB, 1) + ' MB)') -ForegroundColor Black -BackgroundColor Yellow }
Write-Host '(il primo zip contiene ABTG_H4_ELENCO.csv: allega TUTTI gli zip)' -ForegroundColor Black -BackgroundColor Yellow
if($zips.Count -gt 0){ Start-Process explorer.exe -ArgumentList ('/select,"' + $zips[0] + '"') }
