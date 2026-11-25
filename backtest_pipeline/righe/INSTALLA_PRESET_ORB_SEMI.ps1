# MARCATORE_INSTALLA_PRESET_ORB_SEMI_v1
# Copia i 3 file di impostazioni (XAUUSD, NASUSD, U30USD) di ABTG_ORB_Semi in MQL5\Presets del terminale PRINCIPALE BCM (SHA256 verificato). Non attacca l'Expert, non apre ordini, non tocca conti ne VPS.
$ErrorActionPreference='Continue'
$INST='C:\Program Files\BCM Markets MT5 Terminal'
$DATI=$null; $baseT=Join-Path $env:APPDATA 'MetaQuotes\Terminal'
foreach($o in @(Get-ChildItem -LiteralPath $baseT -Directory -ErrorAction SilentlyContinue)){ $of=Join-Path $o.FullName 'origin.txt'; if(Test-Path -LiteralPath $of){ $c0=((Get-Content -LiteralPath $of -Raw -Encoding Unicode) -replace '[\r\n\0]','').Trim(); if($c0.TrimEnd('\') -eq $INST){ $DATI=$o.FullName; break } } }
if(-not $DATI){ Write-Host 'MI FERMO: non trovo la cartella dati del terminale BCM principale.' -ForegroundColor Red; return }
$pre=Join-Path $DATI 'MQL5\Presets'; New-Item -ItemType Directory -Force -Path $pre | Out-Null
[Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12
$PIN='22452af658e582c25745b9060991d3f504d83b85'
$F=@( @{ n='ABTG_ORB_Semi_XAUUSD.set'; h='7A32DDF681C17AC9E2C194D050183AEF5365AD20BFFCDBA6D926C38747C49057' }, @{ n='ABTG_ORB_Semi_NASUSD.set'; h='187633850C6D6C831E03CED09F2CE7ECD1A7B0133A33CCCE0C11CEAEC48A2CF0' }, @{ n='ABTG_ORB_Semi_U30USD.set'; h='7DF1700D4248347E15F0F64E38C91083B8F8AB058EADE51B94A4AFBF8FD8EEA7' } )
$ok=0; $last=$null
foreach($f in $F){
  $tmp=Join-Path $env:TEMP $f.n; Remove-Item -LiteralPath $tmp -Force -ErrorAction SilentlyContinue
  irm ('https://raw.githubusercontent.com/claudiospadaro12/GITHUB/' + $PIN + '/mql5/Presets/' + $f.n + '?cb=' + [Guid]::NewGuid().ToString('N')) -OutFile $tmp
  $H=(Get-FileHash -LiteralPath $tmp -Algorithm SHA256).Hash.ToUpperInvariant()
  if($H -ne $f.h){ Write-Host ('SHA256 diverso per ' + $f.n + ': non copio.') -ForegroundColor Red; continue }
  $dst=Join-Path $pre $f.n; if(Test-Path -LiteralPath $dst){ Copy-Item -LiteralPath $dst -Destination ($dst + '.bak_' + (Get-Date).ToString('yyyyMMdd_HHmmss')) -Force }
  Copy-Item -LiteralPath $tmp -Destination $dst -Force; $ok++; $last=$dst; Write-Host ('Copiato: ' + $dst) -ForegroundColor Green
}
Write-Host ''
Write-Host ('Impostazioni copiate: ' + $ok + ' su 3.') -ForegroundColor Green
Write-Host 'COME USARLE: trascina ABTG_ORB_Semi sul grafico M5 del simbolo -> scheda Input -> pulsante CARICA -> scegli il file con il nome del simbolo -> OK.' -ForegroundColor Yellow
Write-Host '##########  CARTELLA DELLE IMPOSTAZIONI (non serve allegarla)  ##########' -ForegroundColor Black -BackgroundColor Yellow
Write-Host $pre -ForegroundColor Black -BackgroundColor Yellow
try { if($last){ Start-Process explorer.exe -ArgumentList ('/select,"' + $last + '"') } } catch { }
