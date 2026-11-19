# MARCATORE_CERCA_VIDEO_v1
# v2 (19/11, notte): NON legge la durata dei file OneDrive 'solo online' (ffprobe li faceva scaricare).
# SOLA LETTURA: cerca sui dischi fissi i file video grandi (mp4, mkv, mov, avi, m4v, webm, piu di 300 MB), escludendo Windows, Program Files, ProgramData e AppData, e scrive l'elenco (percorso, dimensione, data, durata se ffprobe e disponibile, parole chiave nel nome) in C:\ABTG_RISULTATI\ELENCO_VIDEO_<data>.csv. Non sposta, non cancella e non apre niente.
$ErrorActionPreference='Continue'
$stamp=(Get-Date).ToString('yyyyMMdd_HHmm'); $dest='C:\ABTG_RISULTATI'; New-Item -ItemType Directory -Force -Path $dest | Out-Null
$csv=Join-Path $dest ('ELENCO_VIDEO_' + $stamp + '.csv')
$ext=@('.mp4','.mkv','.mov','.avi','.m4v','.webm')
$esc='\\Windows\\|\\Program Files|\\ProgramData\\|\\AppData\\|\\\$Recycle\.Bin\\|\\System Volume Information\\'
$ffp=$null; $c=Get-Command ffprobe -ErrorAction SilentlyContinue; if($c){ $ffp=$c.Source }
Write-Host ('Cerco i video grandi sui dischi fissi (puo richiedere alcuni minuti)... ffprobe: ' + $(if($ffp){ $ffp } else { 'non installato (le durate non saranno lette)' })) -ForegroundColor Cyan
$trovati=New-Object System.Collections.ArrayList
foreach($dr in @(Get-PSDrive -PSProvider FileSystem | Where-Object { $_.Root -match '^[A-Z]:\\$' -and (Test-Path -LiteralPath $_.Root) })){
  Write-Host ('  disco ' + $dr.Root) -ForegroundColor Gray
  foreach($f in @(Get-ChildItem -LiteralPath $dr.Root -Recurse -File -Force -ErrorAction SilentlyContinue | Where-Object { $ext -contains $_.Extension.ToLowerInvariant() -and $_.Length -gt 300MB -and $_.FullName -notmatch $esc })){
    $dur=''
    $soloOnline=(([int]$f.Attributes -band 0x400000) -ne 0) -or (([int]$f.Attributes -band 0x1000) -ne 0)   # OneDrive solo online: NON si legge (la lettura lo scaricherebbe)
    if($ffp -and -not $soloOnline){ try{ $o=& $ffp -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 $f.FullName 2>$null; $s=0.0; if([double]::TryParse(($o | Select-Object -First 1), [Globalization.NumberStyles]::Float, [Globalization.CultureInfo]::InvariantCulture, [ref]$s)){ $dur=[TimeSpan]::FromSeconds($s).ToString('hh\:mm\:ss') } } catch { } }
    if($soloOnline){ $dur='solo online (non letto)' }
    $kw=''; if($f.Name -match '(?i)leonardo|bollinger|bande|breaking|bulge|fasciano'){ $kw='SI' }
    [void]$trovati.Add([pscustomobject]@{ percorso=$f.FullName; GB=[math]::Round($f.Length/1GB,2); modificato=$f.LastWriteTime.ToString('yyyy-MM-dd HH:mm'); durata=$dur; parola_chiave=$kw })
  }
}
$ord=@($trovati | Sort-Object @{Expression={ $_.parola_chiave }; Descending=$true}, @{Expression={ $_.GB }; Descending=$true})
$ord | Export-Csv -LiteralPath $csv -NoTypeInformation -Delimiter ';' -Encoding UTF8
Write-Host ''
Write-Host ('Trovati ' + $ord.Count + ' video sopra 300 MB. Primi 25:') -ForegroundColor Green
$ord | Select-Object -First 25 | ForEach-Object { Write-Host ('  ' + $_.GB + ' GB | ' + $_.durata + ' | ' + $_.modificato + ' | ' + $_.parola_chiave + ' | ' + $_.percorso) }
Write-Host ''
Write-Host '##########  FILE DA ALLEGARE ALLA CHAT  ##########' -ForegroundColor Black -BackgroundColor Yellow
Write-Host $csv -ForegroundColor Black -BackgroundColor Yellow
try{ Start-Process explorer.exe -ArgumentList ('/select,"' + $csv + '"') } catch { }
