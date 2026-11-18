# MARCATORE_ELENCO_EA_WIM_v1
# SOLA LETTURA. Elenca sul PC di backtest i file .ex5 (EA compilati) e .set (preset) trovati nelle cartelle MT5 e nelle cartelle utente, piu gli archivi con nome Wim/UBS/Ultimate/Breakout. Per ogni .ex5 calcola SHA256 per riconoscere le copie; per ogni .set riporta alcune righe di parametri. Non apre MT5, non modifica ne cancella niente, non tocca conti ne VPS. Scrive un solo txt sul Desktop.
$ErrorActionPreference='SilentlyContinue'
if($env:COMPUTERNAME -ne 'DESKTOP-H4D7CAJ'){ Write-Host ('SOLO sul PC di backtest DESKTOP-H4D7CAJ. Qui: ' + $env:COMPUTERNAME) -ForegroundColor Red; return }
$ci=[Globalization.CultureInfo]::InvariantCulture
$radici=New-Object System.Collections.ArrayList
foreach($p in @('C:\MT5_BCM_Opt','C:\MT5_Backtest','C:\FundedNext_Manuale','C:\Program Files\BCM Markets MT5 Terminal',(Join-Path $env:APPDATA 'MetaQuotes'),[Environment]::GetFolderPath('Desktop'),(Join-Path $env:USERPROFILE 'Downloads'),(Join-Path $env:USERPROFILE 'Documents'))){ if($p -and (Test-Path -LiteralPath $p)){ [void]$radici.Add($p) } }
$out=New-Object System.Collections.ArrayList; $hash=@{}
[void]$out.Add('=== EA COMPILATI (.ex5): cartella;nome;KB;modificato;SHA256(prime 12) ===')
$visti=@{}; $sets=New-Object System.Collections.ArrayList; $arc=New-Object System.Collections.ArrayList
foreach($r in $radici){
  Write-Host ('Cerco in ' + $r) -ForegroundColor Gray
  foreach($f in @(Get-ChildItem -LiteralPath $r -Recurse -File -Force -ErrorAction SilentlyContinue)){
    if($visti.ContainsKey($f.FullName)){ continue }; $visti[$f.FullName]=$true
    if($f.FullName -match '\\(Tester\\Agent|Windows|WinSxS|node_modules|\.git|bases|logs)\\'){ continue }
    $e=$f.Extension.ToLowerInvariant()
    if($e -eq '.ex5' -and $f.FullName -match '(?i)\\Experts\\'){
      $h=(Get-FileHash -LiteralPath $f.FullName -Algorithm SHA256).Hash.Substring(0,12)
      [void]$out.Add($f.DirectoryName + ';' + $f.Name + ';' + [Math]::Round($f.Length/1KB) + ';' + $f.LastWriteTime.ToString('yyyy-MM-dd') + ';' + $h)
    }
    elseif($e -eq '.set'){ [void]$sets.Add($f) }
    elseif(@('.zip','.rar','.7z') -contains $e -and $f.Name -match '(?i)(wim|ubs|ultimate|breakout|forexea)'){ [void]$arc.Add($f.FullName + ' (' + [Math]::Round($f.Length/1MB,1) + ' MB, ' + $f.LastWriteTime.ToString('yyyy-MM-dd') + ')') }
  }
}
[void]$out.Add(''); [void]$out.Add('=== PRESET (.set): percorso;modificato;righe con Symbol/Risk/Lots/Exit/MinDist/Magic/Timeframe ===')
$rx='(?i)^(.*(symbol|risk|lots|exit_|mindist|magic|timeframe|expiration|countback|tp|sl)[^=]*)=([^|;]*)'
foreach($f in $sets){
  $righe=@(Get-Content -LiteralPath $f.FullName -ErrorAction SilentlyContinue | Where-Object { $_ -match $rx } | Select-Object -First 8 | ForEach-Object { ($_ -split '\|')[0].Trim() })
  [void]$out.Add($f.FullName + ';' + $f.LastWriteTime.ToString('yyyy-MM-dd') + ';' + ($righe -join ' / '))
}
[void]$out.Add(''); [void]$out.Add('=== ARCHIVI con nome Wim/UBS/Ultimate/Breakout ===')
foreach($a in $arc){ [void]$out.Add($a) }
$dir=Join-Path ([Environment]::GetFolderPath('Desktop')) 'ABTG_RISULTATI'; if(-not (Test-Path -LiteralPath $dir)){ [void](New-Item -ItemType Directory -Path $dir) }
$fo=Join-Path $dir ('ELENCO_EA_WIM_' + (Get-Date).ToString('yyyyMMdd_HHmm') + '.txt')
Set-Content -LiteralPath $fo -Value ($out -join "`r`n") -Encoding UTF8
Write-Host ('Fatto: ' + ($out.Count) + ' righe. File prodotto: ' + $fo) -ForegroundColor Green
Write-Host ('>>> ALLEGA QUESTO TXT ALLA CHAT: ' + $fo + ' <<<') -ForegroundColor Black -BackgroundColor Yellow
try{ Set-Clipboard -Value $fo } catch { }
Start-Process explorer.exe -ArgumentList ('/select,"' + $fo + '"')
