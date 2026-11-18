# MARCATORE_CERCA_PDF_PPT_ABTG_v1
# SOLA LETTURA dei file originali. Cerca sul PC i PDF e le presentazioni (.pdf .ppt .pptx .pptm .pps .ppsx) con ABTG nel NOME del file o nel PERCORSO della cartella, li COPIA (senza duplicati identici per nome e dimensione) in una cartella nuova sul Desktop e li comprime in piu zip da circa 50 MB ciascuno. Scrive anche un elenco con il percorso originale di ogni file e un secondo elenco degli altri PDF/presentazioni nelle cartelle Desktop, Download e Documenti (senza copiarli). Non apre MT5, non modifica ne cancella niente, non tocca conti ne VPS.
$ErrorActionPreference='SilentlyContinue'
if($env:COMPUTERNAME -ne 'DESKTOP-H4D7CAJ'){ Write-Host ('SOLO sul PC di backtest DESKTOP-H4D7CAJ. Qui: ' + $env:COMPUTERNAME) -ForegroundColor Red; return }
$ext=@('.pdf','.ppt','.pptx','.pptm','.pps','.ppsx')
$radici=New-Object System.Collections.ArrayList
foreach($p in @($env:USERPROFILE,'C:\MT5_Backtest','C:\MT5_BCM_Opt','C:\FundedNext_Manuale')){ if($p -and (Test-Path -LiteralPath $p)){ [void]$radici.Add($p) } }
foreach($d in @(Get-PSDrive -PSProvider FileSystem | Where-Object { $_.Root -match '^[A-Z]:\\$' -and $_.Root -ne 'C:\' })){ [void]$radici.Add($d.Root) }
$escl='\\(Windows|WinSxS|Program Files|Program Files \(x86\)|ProgramData|\$Recycle\.Bin|node_modules|\.git|AppData\\Local\\Temp|AppData\\Local\\Packages|ABTG_RISULTATI|abtg_round)\\'
$trovati=New-Object System.Collections.ArrayList; $altri=New-Object System.Collections.ArrayList; $visti=@{}
foreach($r in $radici){
  Write-Host ('Cerco in ' + $r) -ForegroundColor Gray
  foreach($f in @(Get-ChildItem -LiteralPath $r -Recurse -File -Force -ErrorAction SilentlyContinue)){
    if($ext -notcontains $f.Extension.ToLowerInvariant()){ continue }
    if($f.FullName -match $escl){ continue }
    if($visti.ContainsKey($f.FullName)){ continue }; $visti[$f.FullName]=$true
    if($f.FullName -match '(?i)ABTG'){ [void]$trovati.Add($f) }
    elseif($f.FullName -match '(?i)\\(Desktop|Downloads|Documents|Documenti|Scaricati)\\'){ [void]$altri.Add($f) }
  }
}
if($trovati.Count -eq 0){ Write-Host 'Nessun PDF o presentazione con ABTG nel nome o nel percorso.' -ForegroundColor Red }
$dir=Join-Path (Join-Path ([Environment]::GetFolderPath('Desktop')) 'ABTG_RISULTATI') ('CORSO_ABTG_' + (Get-Date).ToString('yyyyMMdd_HHmm'))
$stag=Join-Path $dir 'file'; [void](New-Item -ItemType Directory -Path $stag -Force)
$chiavi=@{}; $elenco=New-Object System.Collections.ArrayList; $copiati=New-Object System.Collections.ArrayList; $i=0
foreach($f in ($trovati | Sort-Object FullName)){
  $k=$f.Name.ToLowerInvariant() + '|' + $f.Length
  if($chiavi.ContainsKey($k)){ [void]$elenco.Add('(duplicato identico per nome e dimensione, non copiato) ' + $f.FullName); continue }
  $chiavi[$k]=$true; $i=$i+1
  $nuovo=('{0:000}_' -f $i) + $f.Name
  Copy-Item -LiteralPath $f.FullName -Destination (Join-Path $stag $nuovo) -Force
  [void]$copiati.Add((Get-Item -LiteralPath (Join-Path $stag $nuovo)))
  [void]$elenco.Add($nuovo + ' <- ' + $f.FullName + ' (' + [Math]::Round($f.Length/1MB,1) + ' MB, ' + $f.LastWriteTime.ToString('yyyy-MM-dd') + ')')
}
Set-Content -LiteralPath (Join-Path $dir 'ELENCO_FILE_ABTG.txt') -Value ($elenco -join "`r`n") -Encoding UTF8
$al=New-Object System.Collections.ArrayList; foreach($f in ($altri | Sort-Object FullName)){ [void]$al.Add($f.FullName + ' (' + [Math]::Round($f.Length/1MB,1) + ' MB, ' + $f.LastWriteTime.ToString('yyyy-MM-dd') + ')') }
Set-Content -LiteralPath (Join-Path $dir 'ELENCO_ALTRI_PDF_PPT.txt') -Value ($al -join "`r`n") -Encoding UTF8
$lotti=New-Object System.Collections.ArrayList; $cur=New-Object System.Collections.ArrayList; $sz=0.0
foreach($c in $copiati){ if(($sz + $c.Length) -gt 50MB -and $cur.Count -gt 0){ [void]$lotti.Add(,@($cur.ToArray())); $cur=New-Object System.Collections.ArrayList; $sz=0.0 }; [void]$cur.Add($c); $sz += $c.Length }
if($cur.Count -gt 0){ [void]$lotti.Add(,@($cur.ToArray())) }
$zips=New-Object System.Collections.ArrayList; $n=0
foreach($lt in $lotti){ $n=$n+1; $z=Join-Path $dir ('CORSO_ABTG_parte' + ('{0:00}' -f $n) + '.zip'); Compress-Archive -LiteralPath @($lt | ForEach-Object { $_.FullName }) -DestinationPath $z -Force; [void]$zips.Add($z) }
Write-Host ('PDF/presentazioni con ABTG: ' + $trovati.Count + ' trovati, ' + $copiati.Count + ' copiati (senza duplicati), ' + $zips.Count + ' zip. Altri PDF/presentazioni in Desktop/Download/Documenti non copiati: ' + $altri.Count) -ForegroundColor Green
Write-Host ('File prodotti nella cartella ' + $dir + ': CORSO_ABTG_parte01.zip ... (' + $zips.Count + ' zip), ELENCO_FILE_ABTG.txt, ELENCO_ALTRI_PDF_PPT.txt e la sottocartella file con le copie') -ForegroundColor Green
Write-Host ('>>> ALLEGA TUTTI GLI ZIP E I DUE ELENCHI .txt DELLA CARTELLA (Ctrl+A in Esplora file, poi trascina nella chat; NON la sottocartella "file"): ' + $dir + ' <<<') -ForegroundColor Black -BackgroundColor Yellow
try{ Set-Clipboard -Value $dir } catch { }
$sel=$(if($zips.Count -gt 0){ $zips[0] } else { Join-Path $dir 'ELENCO_FILE_ABTG.txt' })
Start-Process explorer.exe -ArgumentList ('/select,"' + $sel + '"')
