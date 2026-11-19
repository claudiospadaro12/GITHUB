# MARCATORE_AUDIO_CORSO_v1
# SOLA LETTURA sui video: per TUTTI i video di una cartella (anche nelle sottocartelle) crea un MP3 piccolo (mono, 22 kHz, 48 kbit/s, circa 20 MB per ora di parlato) in C:\ABTG_RISULTATI\AUDIO_CORSO_<data>, pronto da caricare su TurboScribe, e un catalogo CSV (numero, percorso, durata, dimensioni). I video non vengono toccati. I file OneDrive solo online NON vengono letti (leggerli li scaricherebbe): restano nel catalogo come "solo online". Si puo rilanciare: i MP3 gia fatti si saltano.
$ErrorActionPreference='Continue'
$stamp=(Get-Date).ToString('yyyyMMdd_HHmm'); $base='C:\ABTG_RISULTATI'; New-Item -ItemType Directory -Force -Path $base | Out-Null
function TrovaFfmpeg {
  $c=Get-Command ffmpeg -ErrorAction SilentlyContinue; if($c){ return $c.Source }
  foreach($r in @((Join-Path $env:LOCALAPPDATA 'Microsoft\WinGet\Packages'), 'C:\ffmpeg', 'C:\Program Files\ffmpeg')){
    if(Test-Path -LiteralPath $r){ $f=Get-ChildItem -LiteralPath $r -Recurse -Filter ffmpeg.exe -File -ErrorAction SilentlyContinue | Select-Object -First 1; if($f){ return $f.FullName } }
  }
  return $null
}
$ff=TrovaFfmpeg
if(-not $ff){
  Write-Host 'ffmpeg non trovato.' -ForegroundColor Yellow
  $r=Read-Host 'Lo installo con winget (gratuito, circa 100 MB)? (s/n)'
  if($r -eq 's'){ winget install --id Gyan.FFmpeg -e --accept-package-agreements --accept-source-agreements; $ff=TrovaFfmpeg }
  if(-not $ff){ Write-Host 'Senza ffmpeg non posso estrarre l audio. Installalo e rilancia la riga.' -ForegroundColor Red; return }
}
$fp=Join-Path (Split-Path -Parent $ff) 'ffprobe.exe'
$cart=(Read-Host 'Incolla il percorso della CARTELLA del corso (puoi trascinarla nella finestra)').Trim().Trim('"')
if(-not (Test-Path -LiteralPath $cart -PathType Container)){ Write-Host ('NON TROVO la cartella: ' + $cart) -ForegroundColor Red; return }
$ext=@('.mp4','.mkv','.mov','.avi','.m4v','.webm','.wmv','.flv','.mpg','.mpeg','.mp3','.m4a','.wav')
$video=@(Get-ChildItem -LiteralPath $cart -Recurse -File -ErrorAction SilentlyContinue | Where-Object { $ext -contains $_.Extension.ToLowerInvariant() } | Sort-Object FullName)
Write-Host ('Trovati ' + $video.Count + ' file audio/video in ' + $cart) -ForegroundColor Cyan
if($video.Count -eq 0){ return }
$out=Join-Path $base ('AUDIO_CORSO_' + $stamp); New-Item -ItemType Directory -Force -Path $out | Out-Null
$cat=New-Object System.Collections.ArrayList
$i=0; $ok=0; $sol=0; $err=0; $t0=Get-Date
foreach($v in $video){
  $i++; $att=[int]$v.Attributes
  $soloOnline=((($att -band 0x400000) -ne 0) -or (($att -band 0x1000) -ne 0))
  $nome=($v.BaseName -replace '[^A-Za-z0-9_ -]','_'); if($nome.Length -gt 60){ $nome=$nome.Substring(0,60) }
  $mp3=Join-Path $out ('{0:000}_{1}.mp3' -f $i,$nome.Trim())
  $stato=''; $dur=''
  if($soloOnline){ $stato='solo online (non letto)'; $sol++ }
  else {
    if(-not (Test-Path -LiteralPath $mp3)){
      & $ff -hide_banner -loglevel error -n -i $v.FullName -vn -ac 1 -ar 22050 -b:a 48k $mp3
    }
    if((Test-Path -LiteralPath $mp3) -and ((Get-Item -LiteralPath $mp3).Length -gt 10KB)){ $stato='ok'; $ok++ } else { $stato='ERRORE'; $err++ }
    if((Test-Path -LiteralPath $fp) -and (Test-Path -LiteralPath $mp3)){ try{ $o=& $fp -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 $mp3 2>$null; $s=0.0; if([double]::TryParse(($o | Select-Object -First 1), [Globalization.NumberStyles]::Float, [Globalization.CultureInfo]::InvariantCulture, [ref]$s)){ $dur=[TimeSpan]::FromSeconds($s).ToString('hh\:mm\:ss') } } catch { } }
  }
  [void]$cat.Add([pscustomobject]@{ n=('{0:000}' -f $i); percorso=$v.FullName; MB_originale=[math]::Round($v.Length/1MB,1); durata=$dur; mp3=$(if($stato -eq 'ok'){ [IO.Path]::GetFileName($mp3) } else { '' }); stato=$stato })
  if($i % 10 -eq 0 -or $i -eq $video.Count){ Write-Host ('[' + (Get-Date).ToString('HH:mm') + '] ' + $i + '/' + $video.Count + ' (ok ' + $ok + ', solo online ' + $sol + ', errori ' + $err + ')') -ForegroundColor Gray }
}
$csv=Join-Path $base ('CATALOGO_CORSO_' + $stamp + '.csv')
$cat | Export-Csv -LiteralPath $csv -NoTypeInformation -Delimiter ';' -Encoding UTF8
Copy-Item -LiteralPath $csv -Destination (Join-Path $out 'CATALOGO_CORSO.csv') -Force
$mb=[math]::Round((Get-ChildItem -LiteralPath $out -Filter *.mp3 -File | Measure-Object Length -Sum).Sum/1MB,0)
Write-Host ''
Write-Host ('FATTO in ' + [math]::Round(((Get-Date)-$t0).TotalMinutes,1) + ' minuti: MP3 ' + $ok + ' (' + $mb + ' MB), solo online ' + $sol + ', errori ' + $err) -ForegroundColor Green
if($sol -gt 0){ Write-Host ('ATTENZIONE: ' + $sol + ' file sono ancora solo online (non scaricati). Quando i download finiscono, rilancia la riga: i MP3 gia fatti si saltano.') -ForegroundColor Yellow }
Write-Host ('Cartella degli MP3 da caricare su TurboScribe: ' + $out) -ForegroundColor Cyan
Write-Host ''
Write-Host '##########  FILE DA ALLEGARE ALLA CHAT  ##########' -ForegroundColor Black -BackgroundColor Yellow
Write-Host $csv -ForegroundColor Black -BackgroundColor Yellow
Write-Host ('(il catalogo; i MP3 NON vanno allegati: carica la cartella ' + $out + ' su TurboScribe)') -ForegroundColor Black -BackgroundColor Yellow
try{ Start-Process explorer.exe -ArgumentList ('/select,"' + $csv + '"') } catch { }
