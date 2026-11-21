# MARCATORE_CERCA_UBS_APP_v1
# SOLA LETTURA: cerca sul PC l'app "UBS Optimizer" di Wim (nome, cartella, versione, data, SHA256) e cosa c'e' nella sua cartella; NON la avvia, NON apre MT5, NON tocca conti, VPS o reale.
$ErrorActionPreference='Continue'
if($env:COMPUTERNAME -ne 'DESKTOP-H4D7CAJ'){ Write-Host ('SOLO sul PC di backtest DESKTOP-H4D7CAJ. Qui: ' + $env:COMPUTERNAME) -ForegroundColor Red; return }
$roots=@([Environment]::GetFolderPath('Desktop'),(Join-Path $env:USERPROFILE 'Downloads'),[Environment]::GetFolderPath('MyDocuments'),(Join-Path $env:LOCALAPPDATA 'Programs'),$env:LOCALAPPDATA,$env:APPDATA,'C:\Program Files','C:\Program Files (x86)','C:\MT5_BCM_Opt','C:\ABTG_RISULTATI','C:\') | Where-Object { $_ -and (Test-Path -LiteralPath $_) } | Select-Object -Unique
$rx='(?i)(ubs|optimi[sz]er|ultimate)'; $ext='(?i)\.(exe|msi|zip|7z|rar|lnk|bat|cmd|ps1|py|jar|json|ini|txt|md|pdf)$'
$out=New-Object System.Collections.ArrayList; [void]$out.Add('tipo;percorso;MB;ultima_modifica;versione;SHA256')
$visti=@{}
foreach($r in $roots){
  $prof=$(if($r -eq 'C:\'){ 2 } elseif($r -eq $env:LOCALAPPDATA -or $r -eq $env:APPDATA){ 4 } else { 5 })
  foreach($f in @(Get-ChildItem -LiteralPath $r -Recurse -Depth $prof -File -ErrorAction SilentlyContinue | Where-Object { $_.Name -match $rx -and $_.Name -match $ext -and $_.FullName -notmatch '(?i)\\(Windows|WinSxS|\$Recycle\.Bin|bases|logs|Tester)\\' })){
    if($visti.ContainsKey($f.FullName)){ continue }; $visti[$f.FullName]=1
    $h=''; $v=''
    if($f.Extension -match '(?i)^\.(exe|msi|zip|7z|rar|jar)$' -and $f.Length -lt 800MB){ try { $h=(Get-FileHash -LiteralPath $f.FullName -Algorithm SHA256).Hash } catch { } }
    if($f.Extension -ieq '.exe'){ try { $v=[Diagnostics.FileVersionInfo]::GetVersionInfo($f.FullName).FileVersion } catch { } }
    [void]$out.Add(('file;' + $f.FullName + ';' + [math]::Round($f.Length/1MB,2).ToString([Globalization.CultureInfo]::InvariantCulture) + ';' + $f.LastWriteTime.ToString('yyyy-MM-dd HH:mm') + ';' + $v + ';' + $h))
  }
  foreach($d in @(Get-ChildItem -LiteralPath $r -Recurse -Depth $prof -Directory -ErrorAction SilentlyContinue | Where-Object { $_.Name -match $rx -and $_.FullName -notmatch '(?i)\\(Windows|WinSxS|\$Recycle\.Bin)\\' })){
    if($visti.ContainsKey($d.FullName)){ continue }; $visti[$d.FullName]=1
    $c=@(Get-ChildItem -LiteralPath $d.FullName -Force -ErrorAction SilentlyContinue | Select-Object -First 25 | ForEach-Object { $_.Name }) -join ' | '
    [void]$out.Add(('cartella;' + $d.FullName + ';;' + $d.LastWriteTime.ToString('yyyy-MM-dd HH:mm') + ';;' + $c))
  }
}
$ap=@(Get-StartApps -ErrorAction SilentlyContinue | Where-Object { $_.Name -match $rx }); foreach($a in $ap){ [void]$out.Add(('menu_start;' + $a.Name + ';;;;' + $a.AppID)) }
$ps=@(Get-Process -ErrorAction SilentlyContinue | Where-Object { $_.ProcessName -match $rx }); foreach($p in $ps){ [void]$out.Add(('processo_attivo;' + $p.ProcessName + ';;;;' + $p.Id)) }
$desk='C:\ABTG_RISULTATI'; if(-not (Test-Path -LiteralPath $desk)){ New-Item -ItemType Directory -Force -Path $desk | Out-Null }
$fo=Join-Path $desk ('CERCA_UBS_APP_' + (Get-Date).ToString('yyyyMMdd_HHmm') + '.txt'); Set-Content -LiteralPath $fo -Value ($out -join "`r`n") -Encoding UTF8
try { Set-Clipboard -Value ($out -join "`r`n") } catch { }
$out | Select-Object -First 60 | ForEach-Object { Write-Host $_ }
Write-Host ('Righe: ' + ($out.Count-1) + '. File prodotto: ' + $fo) -ForegroundColor Green
Write-Host ('>>> ALLEGA QUESTO TXT ALLA CHAT: ' + $fo + ' <<<') -ForegroundColor Black -BackgroundColor Yellow
Start-Process explorer.exe -ArgumentList ('/select,"' + $fo + '"')
