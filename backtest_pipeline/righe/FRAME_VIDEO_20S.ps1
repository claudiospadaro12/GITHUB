# MARCATORE_FRAME_VIDEO_20S_v1
# SOLA LETTURA sui video: per ogni video che indichi estrae UN FOTOGRAMMA OGNI 20 SECONDI (960 pixel di larghezza, JPG) in C:\ABTG_RISULTATI\FRAME_<nome>_<data> e crea uno zip per video. Il video originale non viene toccato. Serve ffmpeg: se manca, la riga propone di installarlo con winget.
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
  if(-not $ff){ Write-Host 'Senza ffmpeg non posso estrarre i fotogrammi. Installalo e rilancia la riga.' -ForegroundColor Red; return }
}
Write-Host ('ffmpeg: ' + $ff) -ForegroundColor Green
$zips=@()
foreach($n in 1,2){
  $p=(Read-Host ('Incolla il percorso del video ' + $n + ' (puoi trascinare il file nella finestra; Invio vuoto = salta)')).Trim().Trim('"')
  if($p -eq ''){ continue }
  if(-not (Test-Path -LiteralPath $p)){ Write-Host ('NON TROVO: ' + $p) -ForegroundColor Red; continue }
  $nome=([IO.Path]::GetFileNameWithoutExtension($p) -replace '[^A-Za-z0-9_-]','_'); if($nome.Length -gt 40){ $nome=$nome.Substring(0,40) }
  $dir=Join-Path $base ('FRAME_' + $nome + '_' + $stamp); New-Item -ItemType Directory -Force -Path $dir | Out-Null
  Write-Host ('[' + (Get-Date).ToString('HH:mm') + '] estraggo i fotogrammi di: ' + $p + ' (puo richiedere 10-30 minuti per un video lungo)') -ForegroundColor Cyan
  $t0=Get-Date
  & $ff -hide_banner -loglevel error -i $p -vf 'fps=1/20,scale=960:-2' -q:v 5 (Join-Path $dir 'f_%05d.jpg')
  $nf=@(Get-ChildItem -LiteralPath $dir -Filter 'f_*.jpg' -File).Count
  Write-Host ('   fatto in ' + [math]::Round(((Get-Date)-$t0).TotalMinutes,1) + ' minuti: ' + $nf + ' fotogrammi (il fotogramma N e al secondo (N-1) x 20)') -ForegroundColor Green
  if($nf -eq 0){ Write-Host '   nessun fotogramma prodotto: controlla il file.' -ForegroundColor Red; continue }
  Set-Content -LiteralPath (Join-Path $dir 'LEGGIMI.txt') -Value ('Video: ' + $p + "`r`nUn fotogramma ogni 20 secondi: f_00001 = secondo 0, f_00002 = secondo 20, ecc.") -Encoding ASCII
  $z=Join-Path $base ('FRAME_' + $nome + '_' + $stamp + '.zip')
  Compress-Archive -Path (Join-Path $dir '*') -DestinationPath $z -Force
  $zips += $z
}
Write-Host ''
if($zips.Count -eq 0){ Write-Host 'Nessun video elaborato.' -ForegroundColor Yellow; return }
Write-Host '##########  FILE DA ALLEGARE ALLA CHAT  ##########' -ForegroundColor Black -BackgroundColor Yellow
foreach($z in $zips){ Write-Host ($z + '  (' + [math]::Round((Get-Item -LiteralPath $z).Length / 1MB, 1) + ' MB)') -ForegroundColor Black -BackgroundColor Yellow }
Start-Process explorer.exe -ArgumentList ('/select,"' + $zips[0] + '"')
