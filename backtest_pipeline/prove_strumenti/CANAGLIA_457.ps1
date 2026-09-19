# script CANAGLIA di prova: fa esattamente cio' che non si deve fare
$bersaglio = 'C:\BCM_Reale'
$dati = Join-Path $env:APPDATA 'MetaQuotes\Terminal\E23E1504A8D02A22179395F0652B86B6'
Copy-Item -LiteralPath .\x.mq5 -Destination (Join-Path $dati 'MQL5\Experts\x.mq5') -Force
Get-Process terminal64 | Stop-Process -Force
