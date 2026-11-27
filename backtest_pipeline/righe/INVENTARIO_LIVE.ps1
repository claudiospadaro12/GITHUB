# MARCATORE_INVENTARIO_LIVE_v1  - SOLA LETTURA: elenca i file delle cartelle delle live (F:\LIVE EMILIANO, F:\LIVE PAOLO), scrive TXT e CSV in ABTG_RISULTATI. ASCII puro.
param([string[]]$Cartelle=@('F:\LIVE EMILIANO','F:\LIVE PAOLO'))
$ErrorActionPreference='Stop'
foreach($cc in $Cartelle){ if(-not (Test-Path -LiteralPath $cc)){ throw ('Cartella non trovata: ' + $cc) } }
$fl=@(); foreach($cc in $Cartelle){ $fl += @(Get-ChildItem -LiteralPath $cc -Recurse -File -ErrorAction SilentlyContinue) }
$rad=Join-Path ([Environment]::GetFolderPath('Desktop')) 'ABTG_RISULTATI'; New-Item -ItemType Directory -Force -Path $rad | Out-Null
$ts=(Get-Date).ToString('yyyyMMdd_HHmm'); $csv=Join-Path $rad ('INVENTARIO_LIVE_' + $ts + '.csv'); $txt=Join-Path $rad ('INVENTARIO_LIVE_' + $ts + '.txt')
$fl | Select-Object @{n='percorso';e={$_.FullName}},@{n='MB';e={[math]::Round($_.Length/1MB,1)}},@{n='data';e={$_.LastWriteTime.ToString('yyyy-MM-dd')}},@{n='estensione';e={$_.Extension.ToLower()}} | Export-Csv -LiteralPath $csv -NoTypeInformation -Encoding UTF8 -Delimiter ';'
$righe=@()
foreach($cc in $Cartelle){ $q=@($fl | Where-Object { $_.FullName.StartsWith($cc + '\') }); $righe += ($cc + ': ' + $q.Count + ' file, ' + [math]::Round((($q | Measure-Object Length -Sum).Sum)/1GB,2) + ' GB') }
$righe += ''; $righe += 'PER TIPO DI FILE:'
$righe += @($fl | Group-Object { $_.Extension.ToLower() } | Sort-Object Count -Descending | ForEach-Object { ('  ' + $_.Name + '   ' + $_.Count + ' file   ' + [math]::Round((($_.Group | Measure-Object Length -Sum).Sum)/1GB,2) + ' GB') })
$righe += ''; $righe += 'STRUMENTI SUL PC:'
foreach($c in @('ffmpeg','ffprobe','python','py','whisper','winget')){ $g=Get-Command $c -ErrorAction SilentlyContinue; $righe += ('  ' + $c + ': ' + $(if($g){ $g.Source } else { 'NON TROVATO' })) }
$righe += ''; $righe += 'SPAZIO LIBERO:'
foreach($u in @(Get-PSDrive -PSProvider FileSystem | Where-Object { $_.Free -ne $null })){ $righe += ('  ' + $u.Name + ': ' + [math]::Round($u.Free/1GB,1) + ' GB liberi') }
$righe += ''; $righe += 'TUTTI I FILE (MB, data, percorso):'
$righe += @($fl | Sort-Object FullName | ForEach-Object { ('  ' + [math]::Round($_.Length/1MB) + ' MB   ' + $_.LastWriteTime.ToString('yyyy-MM-dd') + '   ' + $_.FullName) })
$righe | Set-Content -LiteralPath $txt -Encoding UTF8
$righe | Select-Object -First 40 | ForEach-Object { Write-Host $_ -ForegroundColor Cyan }
Write-Host '#########################################################' -ForegroundColor Black -BackgroundColor Yellow
Write-Host ('ALLEGA QUESTI DUE: ' + $txt) -ForegroundColor Black -BackgroundColor Yellow
Write-Host ('                   ' + $csv) -ForegroundColor Black -BackgroundColor Yellow
Write-Host '#########################################################' -ForegroundColor Black -BackgroundColor Yellow
explorer.exe /select,"$txt"
