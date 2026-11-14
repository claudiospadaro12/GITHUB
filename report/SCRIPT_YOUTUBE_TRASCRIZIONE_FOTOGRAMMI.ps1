# Trascrizione + fotogrammi ogni 20 s per i video YouTube indicati (14/11/2026).
# NON TESTATO da Claude (da qui YouTube e bloccato). Sola lettura su YouTube: nessun login, nessun cookie.
# Lavora SOLO in C:\WIM_YOUTUBE. Non lanciarlo sul VPS ne nelle cartelle dei terminali MT5.
# Requisiti: yt-dlp e ffmpeg nel PATH (pip install -U yt-dlp ; winget install Gyan.FFmpeg).
# Uso: PowerShell (non amministratore):  powershell -ExecutionPolicy Bypass -File .\SCRIPT_YOUTUBE_TRASCRIZIONE_FOTOGRAMMI.ps1

$urls = @(
  'https://youtu.be/uOt1O8b6F1U'   # UBS APP VIDEO GUIDE V1.0 (27:08)  <- il piu importante
  # 'https://youtu.be/uPNzvBfIckQ' # Video Guide principale (35:01), gia in sintesi
  # 'https://youtu.be/PLn70LlTRsw' # V5.0 Tutorial (12:15)
  # 'https://youtu.be/RZpzy5F_C9I' # Risk settings and portfolio creation (13:33)
  # 'https://youtu.be/OD3KpEL6IPg' # Creating balanced portfolio's (15:30)
)

$root = 'C:\WIM_YOUTUBE'
New-Item -ItemType Directory -Force $root | Out-Null
foreach ($tool in 'yt-dlp','ffmpeg') {
  if (-not (Get-Command $tool -ErrorAction SilentlyContinue)) { Write-Host "MANCA $tool: installalo e rilancia."; exit 1 }
}

foreach ($u in $urls) {
  $id = ($u -split '[/=?&]')[-1]
  $d = Join-Path $root $id
  New-Item -ItemType Directory -Force $d | Out-Null
  Write-Host "== $id : sottotitoli e metadati"
  yt-dlp --skip-download --write-subs --write-auto-subs --sub-langs "en.*,it" --sub-format vtt --write-info-json --write-description -o "$d\%(id)s" $u

  Write-Host "== $id : video a bassa qualita (temporaneo) e fotogrammi ogni 20 s"
  yt-dlp -f "bv*[height<=480][ext=mp4]/bv*[height<=480]/b[height<=480]" -o "$d\tmp.%(ext)s" $u
  $tmp = Get-ChildItem $d -Filter 'tmp.*' -ErrorAction SilentlyContinue | Select-Object -First 1
  if ($tmp) {
    ffmpeg -loglevel error -i $tmp.FullName -vf "fps=1/20,scale=960:-2" -q:v 5 "$d\f_%04d.jpg"
    Remove-Item $tmp.FullName -Force
    "Il fotogramma f_NNNN e al secondo (NNNN-1)*20 del video." | Set-Content "$d\fotogrammi.txt" -Encoding UTF8
  } else { "NESSUN VIDEO SCARICATO: fotogrammi non creati." | Set-Content "$d\fotogrammi.txt" -Encoding UTF8 }

  Write-Host "== $id : trascrizione con i minuti"
  foreach ($vtt in Get-ChildItem $d -Filter '*.vtt') {
    $out = @(); $t = ''; $last = ''
    foreach ($l in Get-Content $vtt.FullName -Encoding UTF8) {
      if ($l -match '^(\d\d):(\d\d):(\d\d)\.\d+ -->') { $t = '[{0}:{1}:{2}]' -f $matches[1],$matches[2],$matches[3] }
      elseif ($l -match '^(WEBVTT|Kind:|Language:|NOTE)' -or $l.Trim() -eq '') { }
      else { $x = ($l -replace '<[^>]+>','').Trim(); if ($x -and $x -ne $last) { $out += "$t $x"; $last = $x } }
    }
    $out | Set-Content (Join-Path $d ("trascrizione_" + $vtt.BaseName + ".txt")) -Encoding UTF8
  }
  if (-not (Get-ChildItem $d -Filter 'trascrizione_*.txt')) { "SENZA SOTTOTITOLI." | Set-Content "$d\trascrizione_NON_TROVATA.txt" -Encoding UTF8 }

  $zip = Join-Path $root "$id.zip"
  Compress-Archive -Path "$d\*" -DestinationPath $zip -Force
  $mb = [math]::Round((Get-Item $zip).Length / 1MB, 1)
  Write-Host "== $id : zip $zip = $mb MB"
  if ($mb -gt 9.5) { Write-Host "ATTENZIONE: zip sopra 9,5 MB: cancella una parte dei fotogrammi f_*.jpg (uno si, uno no) e rifai lo zip." }
}
Write-Host "FINE. Mandami gli zip in $root."
