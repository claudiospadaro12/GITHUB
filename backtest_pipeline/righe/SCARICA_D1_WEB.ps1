# MARCATORE_SCARICA_D1_WEB_v1
# SOLA LETTURA: scarica da Yahoo Finance le barre GIORNALIERE (D1, storico massimo) di circa 35 mercati non forex: indici, energia, metalli, cereali/agricoli, obbligazioni, crypto, indice dollaro. Scrive un CSV per mercato e un elenco in C:\ABTG_RISULTATI\DATI_D1_<data> e li comprime in uno zip piccolo. Non usa MT5, non tocca nessun conto, nessuna installazione.
$ErrorActionPreference='Continue'
[Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12
$stamp=(Get-Date).ToString('yyyyMMdd_HHmm'); $out=Join-Path 'C:\ABTG_RISULTATI' ('DATI_D1_' + $stamp); New-Item -ItemType Directory -Force -Path $out | Out-Null
$LISTA=@(
 @('^GSPC','SP500','indici'),@('^NDX','Nasdaq100','indici'),@('^DJI','Dow30','indici'),@('^RUT','Russell2000','indici'),@('^GDAXI','DAX','indici'),@('^FTSE','FTSE100','indici'),@('^N225','Nikkei225','indici'),@('^FCHI','CAC40','indici'),@('^STOXX50E','EuroStoxx50','indici'),@('^HSI','HangSeng','indici'),@('^AXJO','ASX200','indici'),
 @('CL=F','Petrolio_WTI','energia'),@('BZ=F','Petrolio_Brent','energia'),@('NG=F','Gas_naturale','energia'),@('HO=F','Gasolio_riscaldamento','energia'),@('RB=F','Benzina','energia'),
 @('GC=F','Oro','metalli'),@('SI=F','Argento','metalli'),@('HG=F','Rame','metalli'),@('PL=F','Platino','metalli'),@('PA=F','Palladio','metalli'),
 @('ZC=F','Mais','agricoli'),@('ZW=F','Grano','agricoli'),@('ZS=F','Soia','agricoli'),@('KC=F','Caffe','agricoli'),@('SB=F','Zucchero','agricoli'),@('CC=F','Cacao','agricoli'),@('CT=F','Cotone','agricoli'),
 @('ZN=F','Treasury_10a','obbligazioni'),@('ZB=F','Treasury_30a','obbligazioni'),
 @('BTC-USD','Bitcoin','crypto'),@('ETH-USD','Ethereum','crypto'),
 @('DX-Y.NYB','Indice_dollaro','valute')
)
$UA=@{ 'User-Agent'='Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0 Safari/537.36' }
$p2=[int][double]::Parse(([DateTimeOffset]::UtcNow.ToUnixTimeSeconds()).ToString())
$righe=New-Object System.Collections.ArrayList
[void]$righe.Add('ticker;nome;classe;barre;prima;ultima;stato')
$ok=0
foreach($m in $LISTA){
  $tk=$m[0]; $nome=$m[1]; $cl=$m[2]; $tkU=[uri]::EscapeDataString($tk)
  $url=('https://query1.finance.yahoo.com/v8/finance/chart/' + $tkU + '?period1=0&period2=' + $p2 + '&interval=1d&events=history&includeAdjustedClose=false')
  $res=$null; $err=''
  for($k=1; $k -le 3; $k++){
    try{ $res=Invoke-RestMethod -Uri $url -Headers $UA -TimeoutSec 60; $err=''; break } catch { $err=$_.Exception.Message; Start-Sleep -Seconds (5 * $k) }
  }
  if($null -eq $res -or $null -eq $res.chart -or $null -eq $res.chart.result){ [void]$righe.Add($tk + ';' + $nome + ';' + $cl + ';0;;;errore: ' + ($err -replace ';',',')); Write-Host ('  ' + $tk + ' ' + $nome + ': ERRORE ' + $err) -ForegroundColor Red; continue }
  $r0=$res.chart.result[0]; $ts=$r0.timestamp; $q=$r0.indicators.quote[0]
  if($null -eq $ts -or $null -eq $q){ [void]$righe.Add($tk + ';' + $nome + ';' + $cl + ';0;;;nessun dato'); continue }
  $sb=New-Object System.Text.StringBuilder; [void]$sb.AppendLine('date;open;high;low;close;volume'); $n=0; $primo=''; $ultimo=''
  for($i=0; $i -lt $ts.Count; $i++){
    $o=$q.open[$i]; $h=$q.high[$i]; $l=$q.low[$i]; $c=$q.close[$i]
    if($null -eq $o -or $null -eq $h -or $null -eq $l -or $null -eq $c){ continue }
    $d=[DateTimeOffset]::FromUnixTimeSeconds([int64]$ts[$i]).UtcDateTime.ToString('yyyy-MM-dd')
    if($n -eq 0){ $primo=$d }; $ultimo=$d; $v=$q.volume[$i]; if($null -eq $v){ $v=0 }
    [void]$sb.AppendLine(($d + ';' + ([string]::Format([Globalization.CultureInfo]::InvariantCulture,'{0};{1};{2};{3};{4}',$o,$h,$l,$c,$v)))); $n++
  }
  $nf=($nome -replace '[^A-Za-z0-9_]','_')
  [IO.File]::WriteAllText((Join-Path $out ('D1_' + $nf + '.csv')), $sb.ToString(), [Text.Encoding]::ASCII)
  [void]$righe.Add($tk + ';' + $nome + ';' + $cl + ';' + $n + ';' + $primo + ';' + $ultimo + ';ok'); $ok++
  Write-Host ('  ' + $tk + ' ' + $nome + ': ' + $n + ' barre dal ' + $primo) -ForegroundColor Green
  Start-Sleep -Milliseconds 800
}
Set-Content -LiteralPath (Join-Path $out 'D1_ELENCO.csv') -Value ($righe -join "`r`n") -Encoding ASCII
$zip=Join-Path 'C:\ABTG_RISULTATI' ('DATI_D1_' + $stamp + '.zip')
Compress-Archive -Path (Join-Path $out '*') -DestinationPath $zip -Force
Write-Host ''
Write-Host ('Mercati scaricati: ' + $ok + ' su ' + $LISTA.Count) -ForegroundColor Cyan
Write-Host '##########  FILE DA ALLEGARE ALLA CHAT  ##########' -ForegroundColor Black -BackgroundColor Yellow
Write-Host $zip -ForegroundColor Black -BackgroundColor Yellow
Write-Host '(contiene D1_ELENCO.csv + un CSV per mercato; Esplora file si apre con lo zip selezionato)' -ForegroundColor Black -BackgroundColor Yellow
try{ Start-Process explorer.exe -ArgumentList ('/select,"' + $zip + '"') } catch { }
