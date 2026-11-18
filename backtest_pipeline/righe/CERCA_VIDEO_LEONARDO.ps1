# MARCATORE_CERCA_VIDEO_LEONARDO_v1
# SOLA LETTURA: cerca su tutti i dischi di QUESTO PC video/audio e file con nomi che richiamano Leonardo Fasciano, il Bulge o il Breaking Band, e scrive un elenco (CSV) sul Desktop. Non apre, non sposta, non scarica, non cancella niente.
$ErrorActionPreference='Continue'
$ci=[Globalization.CultureInfo]::InvariantCulture
Write-Host ('PC: ' + $env:COMPUTERNAME + ' - ricerca in corso (puo durare alcuni minuti)') -ForegroundColor Cyan
$drives=@(Get-PSDrive -PSProvider FileSystem | Where-Object { $_.Root -match '^[A-Za-z]:\\$' } | ForEach-Object { $_.Root })
$extV=@('mp4','mkv','avi','mov','wmv','webm','m4v','flv','mpg','mpeg','m4a','mp3','wav','aac','ogg','opus','wma')
$nomiK=@('*fasciano*','*leonardo*','*bulge*','*breaking*','*bollinger*','*uccellin*')
$rxEsc='(?i)\\(Windows|Program Files|Program Files \(x86\)|ProgramData|\$Recycle\.Bin|node_modules)\\'
$rxNome='(?i)fasciano|leonardo|bulge|breaking|bollinger|uccellin|abtg|master|corso|lezione|zoom|registraz|recording|webinar|live'
$out=New-Object System.Collections.ArrayList; [void]$out.Add('tipo;percorso;MB;ultima_modifica;nome_interessante')
$visti=@{}
foreach($r in $drives){
  Write-Host ('  disco ' + $r + ' ...') -ForegroundColor Gray
  $pv=@($extV | ForEach-Object { '"' + $r + '*.' + $_ + '"' }) -join ' '
  $lst=@(cmd /c ('dir ' + $pv + ' /s /b /a-d 2>nul'))
  foreach($p in $lst){
    if($p -match $rxEsc){ continue }
    try { $fi=Get-Item -LiteralPath $p -ErrorAction Stop } catch { continue }
    $mb=$fi.Length/1MB; $nm=($fi.Name -match $rxNome) -or ($fi.DirectoryName -match $rxNome)
    if($mb -lt 5 -and -not $nm){ continue }
    if($visti.ContainsKey($p)){ continue }; $visti[$p]=1
    [void]$out.Add('video_audio;' + $p + ';' + $mb.ToString('0.0',$ci) + ';' + $fi.LastWriteTime.ToString('yyyy-MM-dd HH:mm') + ';' + $(if($nm){ 'SI' } else { '' }))
  }
  $pk=@($nomiK | ForEach-Object { '"' + $r + $_ + '"' }) -join ' '
  $lk=@(cmd /c ('dir ' + $pk + ' /s /b /a-d 2>nul'))
  foreach($p in $lk){
    if($p -match $rxEsc){ continue }
    if($visti.ContainsKey($p)){ continue }
    try { $fi=Get-Item -LiteralPath $p -ErrorAction Stop } catch { continue }
    $visti[$p]=1
    [void]$out.Add('nome_richiama;' + $p + ';' + ($fi.Length/1MB).ToString('0.0',$ci) + ';' + $fi.LastWriteTime.ToString('yyyy-MM-dd HH:mm') + ';SI')
  }
}
# contenuto: trascrizioni/testi che parlano dell'uccellino o di Fasciano (solo cartelle utente, file piccoli)
Write-Host '  cerco nei testi (txt, srt, vtt, md) ...' -ForegroundColor Gray
$ut=@(Join-Path $env:USERPROFILE 'Desktop'),(Join-Path $env:USERPROFILE 'Documents'),(Join-Path $env:USERPROFILE 'Downloads')
foreach($u in $ut){ if(-not (Test-Path -LiteralPath $u)){ continue }
  foreach($fi in @(Get-ChildItem -LiteralPath $u -Recurse -File -Include '*.txt','*.srt','*.vtt','*.md' -ErrorAction SilentlyContinue | Where-Object { $_.Length -lt 3MB })){
    try { if(Select-String -LiteralPath $fi.FullName -Pattern 'uccellin|fasciano' -Quiet -ErrorAction Stop){ if(-not $visti.ContainsKey($fi.FullName)){ $visti[$fi.FullName]=1; [void]$out.Add('testo_cita;' + $fi.FullName + ';' + ($fi.Length/1MB).ToString('0.0',$ci) + ';' + $fi.LastWriteTime.ToString('yyyy-MM-dd HH:mm') + ';SI') } } } catch { }
  } }
$desk=[Environment]::GetFolderPath('Desktop'); $dirOut=Join-Path $desk 'CERCA_VIDEO_LEONARDO'; New-Item -ItemType Directory -Force -Path $dirOut | Out-Null
$f=Join-Path $dirOut 'ELENCO_VIDEO_LEONARDO.csv'; Set-Content -LiteralPath $f -Value ($out -join "`r`n") -Encoding UTF8
try { Set-Clipboard -Value ($out -join "`r`n") } catch { }
$nSi=@($out | Where-Object { $_ -match ';SI$' }).Count
Write-Host ''
Write-Host ('Righe: ' + ($out.Count-1) + ' (con nome interessante: ' + $nSi + '). Le prime con nome interessante:') -ForegroundColor Green
$out | Where-Object { $_ -match ';SI$' } | Select-Object -First 25 | ForEach-Object { Write-Host $_ }
Write-Host ''
Write-Host '##########  FILE DA ALLEGARE ALLA CHAT  ##########' -ForegroundColor Black -BackgroundColor Yellow
Write-Host $f -ForegroundColor Black -BackgroundColor Yellow
Write-Host '(un solo CSV: elenco dei file trovati; Esplora file si apre con il file selezionato; l elenco e anche negli appunti)' -ForegroundColor Black -BackgroundColor Yellow
try { Start-Process -FilePath 'explorer.exe' -ArgumentList ('/select,"' + $f + '"') } catch { }
