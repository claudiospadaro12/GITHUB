# MARCATORE_ZIP_SET_INDICI_WIM_v1
# SOLA LETTURA dei file originali. Cerca sul PC di backtest i preset (.set) di Wim per Nasdaq (USTEC) e S&P 500 (US500) di ORB Master e Indicement, ne prende la copia PIU RECENTE per ogni nome, li COPIA in una cartella nuova sul Desktop e li comprime in un solo zip. Non apre MT5, non modifica ne cancella niente, non tocca conti ne VPS.
$ErrorActionPreference='SilentlyContinue'
if($env:COMPUTERNAME -ne 'DESKTOP-H4D7CAJ'){ Write-Host ('SOLO sul PC di backtest DESKTOP-H4D7CAJ. Qui: ' + $env:COMPUTERNAME) -ForegroundColor Red; return }
$radici=@('C:\MT5_BCM_Opt','C:\MT5_Backtest','C:\FundedNext_Manuale',(Join-Path $env:APPDATA 'MetaQuotes'),[Environment]::GetFolderPath('Desktop'),(Join-Path $env:USERPROFILE 'Downloads'),(Join-Path $env:USERPROFILE 'Documents'))
$best=@{}
foreach($r in $radici){
  if(-not (Test-Path -LiteralPath $r)){ continue }
  foreach($f in @(Get-ChildItem -LiteralPath $r -Recurse -File -Filter '*.set' -Force -ErrorAction SilentlyContinue)){
    if($f.FullName -match '\\(Tester\\Agent|ini|Windows|WinSxS|\.git)\\'){ continue }
    $fam=''
    if($f.FullName -match '(?i)ORB Master' -and $f.Name -match '(?i)^(USTEC|US500)_M15_'){ $fam='ORB' }
    elseif($f.FullName -match '(?i)Indicement' -and $f.FullName -match '(?i)(USTEC|US500)' -and $f.Name -match '(?i)^(US100_\d|US500[a-f]|optimization)'){ $fam='IND' }
    if($fam -eq ''){ continue }
    $sub=''; if($f.FullName -match '(?i)USTEC'){ $sub='USTEC' } elseif($f.FullName -match '(?i)US500'){ $sub='US500' }
    $k=$fam + '_' + $sub + '_' + $f.Name
    if(-not $best.ContainsKey($k) -or $f.LastWriteTime -gt $best[$k].LastWriteTime){ $best[$k]=$f }
  }
}
if($best.Count -eq 0){ Write-Host 'Nessun set trovato.' -ForegroundColor Red; return }
$dir=Join-Path (Join-Path ([Environment]::GetFolderPath('Desktop')) 'ABTG_RISULTATI') ('SET_INDICI_WIM_' + (Get-Date).ToString('yyyyMMdd_HHmm'))
[void](New-Item -ItemType Directory -Path $dir -Force)
$elenco=New-Object System.Collections.ArrayList
foreach($k in ($best.Keys | Sort-Object)){ Copy-Item -LiteralPath $best[$k].FullName -Destination (Join-Path $dir $k) -Force; [void]$elenco.Add($k + ' <- ' + $best[$k].FullName + ' (' + $best[$k].LastWriteTime.ToString('yyyy-MM-dd') + ')') }
Set-Content -LiteralPath (Join-Path $dir 'ORIGINI.txt') -Value ($elenco -join "`r`n") -Encoding UTF8
$zip=$dir + '.zip'; Compress-Archive -Path (Join-Path $dir '*') -DestinationPath $zip -Force
Write-Host ('Set copiati: ' + $best.Count + '. File prodotti: (1) ' + $zip + '  (2) cartella ' + $dir) -ForegroundColor Green
Write-Host ('>>> ALLEGA QUESTO ZIP ALLA CHAT: ' + $zip + ' <<<') -ForegroundColor Black -BackgroundColor Yellow
Start-Process explorer.exe -ArgumentList ('/select,"' + $zip + '"')
