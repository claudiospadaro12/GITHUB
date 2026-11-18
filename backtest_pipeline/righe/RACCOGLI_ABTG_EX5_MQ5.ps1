# MARCATORE_RACCOGLI_ABTG_EX5_MQ5_v1
# SOLA LETTURA dei file originali. Cerca sul PC i file .ex5 (EA compilati) e .mq5/.mqh (sorgenti) con nome ABTG_* (e BULGE*), prende la copia PIU RECENTE per ogni nome, la COPIA in una cartella nuova sul Desktop (sottocartelle ex5 e sorgenti) e la comprime in zip da circa 50 MB. Scrive un elenco con il percorso originale di ogni file. Non apre MT5, non modifica ne cancella niente, non tocca conti ne VPS.
$ErrorActionPreference='SilentlyContinue'
if($env:COMPUTERNAME -ne 'DESKTOP-H4D7CAJ'){ Write-Host ('SOLO sul PC di backtest DESKTOP-H4D7CAJ. Qui: ' + $env:COMPUTERNAME) -ForegroundColor Red; return }
$radici=New-Object System.Collections.ArrayList
foreach($p in @((Join-Path $env:APPDATA 'MetaQuotes'),'C:\MT5_Backtest','C:\MT5_BCM_Opt','C:\MT5_BCM_Tester2','C:\FundedNext_Manuale','C:\Program Files\BCM Markets MT5 Terminal',[Environment]::GetFolderPath('Desktop'),(Join-Path $env:USERPROFILE 'Documents'),(Join-Path $env:USERPROFILE 'Downloads'))){ if($p -and (Test-Path -LiteralPath $p)){ [void]$radici.Add($p) } }
$ext=@('.ex5','.mq5','.mqh'); $best=@{}; $visti=@{}
foreach($r in $radici){
  Write-Host ('Cerco in ' + $r) -ForegroundColor Gray
  foreach($f in @(Get-ChildItem -LiteralPath $r -Recurse -File -Force -ErrorAction SilentlyContinue)){
    if($ext -notcontains $f.Extension.ToLowerInvariant()){ continue }
    if($f.Name -notmatch '(?i)^(ABTG_|BULGE)'){ continue }
    if($f.FullName -match '\\(Tester\\Agent|Windows|WinSxS|\.git|ABTG_RISULTATI)\\'){ continue }
    if($visti.ContainsKey($f.FullName)){ continue }; $visti[$f.FullName]=$true
    $k=$f.Name.ToLowerInvariant()
    if(-not $best.ContainsKey($k) -or $f.LastWriteTime -gt $best[$k].LastWriteTime){ $best[$k]=$f }
  }
}
if($best.Count -eq 0){ Write-Host 'Nessun file ABTG_*.ex5/.mq5 trovato.' -ForegroundColor Red; return }
$dir=Join-Path (Join-Path ([Environment]::GetFolderPath('Desktop')) 'ABTG_RISULTATI') ('ABTG_EX5_E_SORGENTI_' + (Get-Date).ToString('yyyyMMdd_HHmm'))
$sd=Join-Path $dir 'ex5'; $ss=Join-Path $dir 'sorgenti'; [void](New-Item -ItemType Directory -Path $sd -Force); [void](New-Item -ItemType Directory -Path $ss -Force)
$elenco=New-Object System.Collections.ArrayList; $nex=0; $nsr=0; $listaE=New-Object System.Collections.ArrayList; $listaS=New-Object System.Collections.ArrayList
foreach($k in ($best.Keys | Sort-Object)){
  $f=$best[$k]
  if($f.Extension.ToLowerInvariant() -eq '.ex5'){ $dst=Join-Path $sd $f.Name; $nex=$nex+1; [void]$listaE.Add($dst) } else { $dst=Join-Path $ss $f.Name; $nsr=$nsr+1; [void]$listaS.Add($dst) }
  Copy-Item -LiteralPath $f.FullName -Destination $dst -Force
  [void]$elenco.Add($f.Name + ' <- ' + $f.FullName + ' (' + [Math]::Round($f.Length/1KB) + ' KB, ' + $f.LastWriteTime.ToString('yyyy-MM-dd') + ')')
}
Set-Content -LiteralPath (Join-Path $dir 'ELENCO_EX5_E_SORGENTI.txt') -Value ($elenco -join "`r`n") -Encoding UTF8
$zips=New-Object System.Collections.ArrayList
foreach($gr in @(@{ n='EX5'; l=$listaE }, @{ n='SORGENTI'; l=$listaS })){
  $cur=New-Object System.Collections.ArrayList; $sz=0.0; $parte=0
  $files=@($gr.l | ForEach-Object { Get-Item -LiteralPath $_ })
  for($i=0; $i -lt $files.Count; $i++){
    $x=$files[$i]
    if((($sz + $x.Length) -gt 50MB) -and ($cur.Count -gt 0)){ $parte=$parte+1; $z=Join-Path $dir ('ABTG_' + $gr.n + '_parte' + ('{0:00}' -f $parte) + '.zip'); Compress-Archive -LiteralPath $cur.ToArray() -DestinationPath $z -Force; [void]$zips.Add($z); $cur=New-Object System.Collections.ArrayList; $sz=0.0 }
    [void]$cur.Add($x.FullName); $sz += $x.Length
  }
  if($cur.Count -gt 0){ $parte=$parte+1; $z=Join-Path $dir ('ABTG_' + $gr.n + '_parte' + ('{0:00}' -f $parte) + '.zip'); Compress-Archive -LiteralPath $cur.ToArray() -DestinationPath $z -Force; [void]$zips.Add($z) }
}
Write-Host ('Trovati e copiati: ' + $nex + ' file .ex5 e ' + $nsr + ' sorgenti (.mq5/.mqh), ' + $zips.Count + ' zip.') -ForegroundColor Green
Write-Host ('File prodotti in ' + $dir + ': ABTG_EX5_parte01.zip..., ABTG_SORGENTI_parte01.zip..., ELENCO_EX5_E_SORGENTI.txt, sottocartelle ex5 e sorgenti (copie non compresse)') -ForegroundColor Green
Write-Host ('>>> ALLEGA TUTTI GLI ZIP E L ELENCO .txt DELLA CARTELLA (Ctrl+A, poi togli le sottocartelle ex5 e sorgenti): ' + $dir + ' <<<') -ForegroundColor Black -BackgroundColor Yellow
try{ Set-Clipboard -Value $dir } catch { }
$sel=$(if($zips.Count -gt 0){ $zips[0] } else { Join-Path $dir 'ELENCO_EX5_E_SORGENTI.txt' })
Start-Process explorer.exe -ArgumentList ('/select,"' + $sel + '"')
