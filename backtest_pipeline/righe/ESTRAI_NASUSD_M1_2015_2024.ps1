# MARCATORE_ESTRAI_NASUSD_M1_v1
# SOLA LETTURA del file sorgente. Copia le righe 2015-2024 di NASUSD_M1.csv (storico esterno, ora EST fissa) in un nuovo CSV e lo comprime in uno zip sul Desktop. Non apre MT5, non tocca conti ne VPS, non modifica ne cancella il file sorgente. Il 2025-2026 NON viene incluso (hold-out).
$ErrorActionPreference='Stop'
if($env:COMPUTERNAME -ne 'DESKTOP-H4D7CAJ'){ Write-Host ('SOLO sul PC di backtest DESKTOP-H4D7CAJ. Qui: ' + $env:COMPUTERNAME) -ForegroundColor Red; return }
$src=Join-Path $env:USERPROFILE 'abtg_storico_indici\NASUSD_M1.csv'
if(-not (Test-Path -LiteralPath $src)){ Write-Host ('File sorgente non trovato: ' + $src) -ForegroundColor Red; return }
$desk=[Environment]::GetFolderPath('Desktop'); $dir=Join-Path $desk 'ABTG_RISULTATI'
if(-not (Test-Path -LiteralPath $dir)){ [void](New-Item -ItemType Directory -Path $dir) }
$stamp=(Get-Date).ToString('yyyyMMdd_HHmm')
$csv=Join-Path $dir ('NASUSD_M1_2015_2024_' + $stamp + '.csv'); $zip=Join-Path $dir ('NASUSD_M1_2015_2024_' + $stamp + '.zip')
Write-Host ('Leggo ' + $src + ' (puo richiedere 1-3 minuti)...') -ForegroundColor Gray
$rd=New-Object IO.StreamReader($src); $wr=New-Object IO.StreamWriter($csv,$false,(New-Object Text.UTF8Encoding($false)))
$nr=0; $prima=''; $ultima=''
try{
  $wr.WriteLine($rd.ReadLine())
  while($null -ne ($riga=$rd.ReadLine())){
    if($riga.Length -lt 16){ continue }
    $anno=0; if(-not [int]::TryParse($riga.Substring(0,4),[ref]$anno)){ continue }
    if($anno -lt 2015){ continue }
    if($anno -gt 2024){ break }
    if($nr -eq 0){ $prima=$riga }
    $wr.WriteLine($riga); $nr++; $ultima=$riga
  }
} finally { $wr.Close(); $rd.Close() }
if($nr -lt 1000000){ Write-Host ('ATTENZIONE: solo ' + $nr + ' righe, meno del previsto. Non allego nulla: avvisa Claude.') -ForegroundColor Red; return }
Compress-Archive -LiteralPath $csv -DestinationPath $zip -Force
$mb=[Math]::Round((Get-Item -LiteralPath $zip).Length/1MB,1)
Write-Host ('Righe copiate: ' + $nr + ' | prima: ' + $prima + ' | ultima: ' + $ultima) -ForegroundColor Green
Write-Host ('File prodotti: (1) ' + $csv + ' (non serve allegarlo)  (2) ' + $zip + ' (' + $mb + ' MB)') -ForegroundColor Green
Write-Host ('>>> ALLEGA QUESTO ZIP ALLA CHAT: ' + $zip + ' <<<') -ForegroundColor Black -BackgroundColor Yellow
try{ Set-Clipboard -Value $zip } catch { }
Start-Process explorer.exe -ArgumentList ('/select,"' + $zip + '"')
