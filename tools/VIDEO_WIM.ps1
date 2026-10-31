# MARCATORE_VIDEO_WIM_V1
# Scarica video da un link (yt-dlp), ne ricava un frame ogni N secondi (ffmpeg) e i sottotitoli,
# e li impacchetta in UNO ZIP PICCOLO per video, da caricare in chat. Scrive SOLO sul Desktop (cartella VIDEO_WIM).
# NON tocca MetaTrader, conti, EA, preset. Uso:
#   & "$([Environment]::GetFolderPath('Desktop'))\VIDEO_WIM_TOOL\VIDEO_WIM.ps1" -Url 'https://...','https://...'
# Facoltativi: -Cada 20 (un frame ogni 20 s), -Browser chrome (usa i cookie del browser per video riservati).
param(
  [Parameter(Mandatory=$true)][string[]]$Url,
  [int]$Cada = 20,
  [string]$Browser = ''
)
$ErrorActionPreference = 'Stop'
foreach($t in 'yt-dlp','ffmpeg'){
  if(-not (Get-Command $t -ErrorAction SilentlyContinue)){
    throw ($t + ' NON installato: vedi la guida, parte 1 (winget). Poi chiudi e riapri PowerShell.')
  }
}
if($Cada -lt 5){ throw 'Cada deve essere almeno 5 secondi' }
$B = Join-Path ([Environment]::GetFolderPath('Desktop')) 'VIDEO_WIM'
New-Item -ItemType Directory -Force -Path $B | Out-Null
$n = 0
foreach($u in $Url){
  $n++
  $d = Join-Path $B ('video{0:00}' -f $n)
  New-Item -ItemType Directory -Force -Path $d | Out-Null
  $ck = @()
  if($Browser -ne ''){ $ck = @('--cookies-from-browser', $Browser) }
  Write-Host ('[' + $n + '/' + $Url.Count + '] scarico ' + $u) -ForegroundColor Cyan
  & yt-dlp @ck --no-playlist -f 'bv*[height<=720]+ba/b[height<=720]' --merge-output-format mp4 --write-subs --write-auto-subs --sub-langs 'en,en-orig,it' --convert-subs srt --write-info-json -o ($d + '\video.%(ext)s') $u
  $v = Join-Path $d 'video.mp4'
  if(-not (Test-Path $v)){ Write-Host ('VIDEO ' + $n + ' NON SCARICATO: ' + $u) -ForegroundColor Red; continue }
  $f = Join-Path $d 'frames'
  New-Item -ItemType Directory -Force -Path $f | Out-Null
  & ffmpeg -hide_banner -loglevel error -i $v -vf ('fps=1/' + $Cada + ',scale=1100:-2') -q:v 5 (Join-Path $f 'f_%05d.jpg')
  @(Get-ChildItem $f -Filter 'f_*.jpg') | ForEach-Object {
    $i = [int]($_.BaseName.Substring(2))
    $s = ($i - 1) * $Cada
    $h = [int][math]::Floor($s / 3600); $m = [int][math]::Floor(($s % 3600) / 60); $q = $s % 60
    Rename-Item -LiteralPath $_.FullName -NewName ('t{0:00}h{1:00}m{2:00}s.jpg' -f $h, $m, $q)
  }
  $z = Join-Path $B ('video{0:00}.zip' -f $n)
  $it = @($f) + @(Get-ChildItem $d -File | Where-Object { $_.Extension -in '.srt','.json' } | ForEach-Object { $_.FullName })
  Compress-Archive -Path $it -DestinationPath $z -Force
  Write-Host ('PRONTO: ' + $z + ' (' + [math]::Round((Get-Item $z).Length / 1MB, 1) + ' MB) - il video .mp4 resta in ' + $d + ' e NON va caricato') -ForegroundColor Green
}
explorer.exe $B
