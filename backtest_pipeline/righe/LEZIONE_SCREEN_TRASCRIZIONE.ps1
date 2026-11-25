# MARCATORE_LEZIONE_SCREEN_v1
# Lezione registrata -> un fotogramma ogni N secondi + trascrizione (Whisper locale, oppure SRT/VTT di TurboScribe) collegati; fogli di contatto per la chat. TUTTO IN LOCALE: nessun upload. Non tocca MT5, conti, VPS. Uso: .\LEZIONE_SCREEN_TRASCRIZIONE.ps1 -Video "C:\percorso\lezione.mp4" [-Srt "C:\percorso\lezione.srt"] [-Ogni 15] [-Modello medium]
param([Parameter(Mandatory=$true)][string]$Video,[string]$Srt='',[double]$Ogni=15,[string]$Modello='medium',[string]$Ritaglio='')
$ErrorActionPreference='Continue'
if(-not (Test-Path -LiteralPath $Video)){ Write-Host ('MI FERMO: video non trovato: ' + $Video) -ForegroundColor Red; return }
if(-not (Get-Command ffmpeg -ErrorAction SilentlyContinue)){ Write-Host 'MI FERMO: ffmpeg non installato. Apri un PowerShell e lancia: winget install Gyan.FFmpeg   poi CHIUDI e riapri PowerShell.' -ForegroundColor Red; return }
$py=$null; foreach($c in @('py','python')){ if(Get-Command $c -ErrorAction SilentlyContinue){ $py=$c; break } }
if(-not $py){ Write-Host 'MI FERMO: Python non installato. Lancia: winget install Python.Python.3.12   poi chiudi e riapri PowerShell.' -ForegroundColor Red; return }
& $py -c "import PIL" 2>$null; if($LASTEXITCODE -ne 0){ Write-Host 'Installo Pillow (pip)...' -ForegroundColor Yellow; & $py -m pip install --quiet pillow }
if($Srt -eq ''){ & $py -c "import faster_whisper" 2>$null; if($LASTEXITCODE -ne 0){ Write-Host 'Installo faster-whisper (pip, circa 200 MB piu il modello al primo avvio)...' -ForegroundColor Yellow; & $py -m pip install --quiet faster-whisper } }
[Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12
$PIN='77576088982f9669bda80f69286a1a6a7da7a360'; $SHA='6FC7640005E3EE07926E16324059A0202C505E4BE55678863B790D8D75A060C2'; $t=Join-Path $env:TEMP 'lezione_pipeline.py'; Remove-Item -LiteralPath $t -Force -ErrorAction SilentlyContinue
irm ('https://raw.githubusercontent.com/claudiospadaro12/GITHUB/' + $PIN + '/ubs_campagna/lezione_pipeline.py?cb=' + [Guid]::NewGuid().ToString('N')) -OutFile $t
$H=(Get-FileHash -LiteralPath $t -Algorithm SHA256).Hash.ToUpperInvariant(); if($H -ne $SHA){ Write-Host ('MI FERMO: SHA256 diverso: ' + $H) -ForegroundColor Red; return }
$desk=[Environment]::GetFolderPath('Desktop'); $nome=[IO.Path]::GetFileNameWithoutExtension($Video); $out=Join-Path (Join-Path $desk 'ABTG_LEZIONI') $nome; New-Item -ItemType Directory -Force -Path $out | Out-Null
$arg=@($t,$Video,$out,'--ogni',$Ogni,'--modello',$Modello); if($Srt -ne ''){ $arg += @('--srt',$Srt) }; if($Ritaglio -ne ''){ $arg += @('--ritaglio',$Ritaglio) }
& $py @arg
if($LASTEXITCODE -ne 0){ Write-Host 'Il programma si e fermato con un errore: mandami lo screenshot.' -ForegroundColor Red; return }
$zip1=Join-Path $out 'PER_CHAT\LEZIONE_PER_CHAT_parte1.zip'
Write-Host ''
Write-Host '##########  FILE DA ALLEGARE ALLA CHAT  ##########' -ForegroundColor Black -BackgroundColor Yellow
Get-ChildItem -LiteralPath (Join-Path $out 'PER_CHAT') -Filter *.zip | ForEach-Object { Write-Host $_.FullName -ForegroundColor Black -BackgroundColor Yellow }
Write-Host ('(Resta sul PC, NON da allegare: ' + $out + '\lezione.html con tutte le immagini a fianco delle parole)') -ForegroundColor Black -BackgroundColor Yellow
try { Start-Process explorer.exe -ArgumentList ('/select,"' + $zip1 + '"') } catch { }
