# MARCATORE_PREPARA_STORICO_OPT_v1
# Rende utilizzabile lo storico di EURUSD nel MT5 PORTABLE C:\MT5_BCM_Opt: (1) alza MaxBars nel suo config\common.ini da 1000 a 100000000 (come nel terminale principale), con copia di sicurezza; (2) copia la cartella dello storico EURUSD dal terminale principale (SOLO LETTURA) al portable; (3) cancella la cache di EURUSD degli agenti del tester DEL PORTABLE (C:\MT5_BCM_Opt\Tester).
# Scrive SOLO dentro C:\MT5_BCM_Opt. NON apre ne chiude MT5, NON modifica il terminale principale (si legge soltanto), ne conti, VPS, AppData.
$ErrorActionPreference='Continue'
if($env:COMPUTERNAME -ne 'DESKTOP-H4D7CAJ'){ Write-Host ('SOLO sul PC di backtest DESKTOP-H4D7CAJ. Qui: ' + $env:COMPUTERNAME) -ForegroundColor Red; return }
$M='C:\Users\Master\AppData\Roaming\MetaQuotes\Terminal\215D85D767A1C39E22D242C8114BF9F5'; $P='C:\MT5_BCM_Opt'
$aperti=@(Get-Process -Name terminal64,metatester64,metaeditor64 -ErrorAction SilentlyContinue)
if($aperti.Count -gt 0){ $aperti | Select-Object Id,ProcessName,Path | Format-Table -AutoSize | Out-String | Write-Host; Write-Host 'MI FERMO: ci sono MT5, MetaEditor o agenti del tester aperti. Chiudili e rilancia. Non ho cambiato niente.' -ForegroundColor Red; return }
$src=Join-Path $M 'bases\BCMMarkets-Server\history\EURUSD'; $dst=Join-Path $P 'bases\BCMMarkets-Server\history\EURUSD'; $ci=Join-Path $P 'config\common.ini'
if(-not (Test-Path -LiteralPath $src)){ Write-Host ('MI FERMO: non trovo lo storico sorgente ' + $src + '. Non ho cambiato niente.') -ForegroundColor Red; return }
if(-not (Test-Path -LiteralPath $ci)){ Write-Host ('MI FERMO: non trovo ' + $ci + '. Non ho cambiato niente.') -ForegroundColor Red; return }
$nsrc=@(Get-ChildItem -LiteralPath $src -File -ErrorAction SilentlyContinue)
if($nsrc.Count -lt 20){ Write-Host ('MI FERMO: nello storico sorgente ci sono solo ' + $nsrc.Count + ' file (ne attendo circa 56). Non ho cambiato niente.') -ForegroundColor Red; return }
Write-Host '1/3 MaxBars nel config del portable ...' -ForegroundColor Cyan
$b=[IO.File]::ReadAllBytes($ci); $uni=($b.Length -ge 2 -and $b[0] -eq 255 -and $b[1] -eq 254)
$t=$(if($uni){ [Text.Encoding]::Unicode.GetString($b) } else { [Text.Encoding]::UTF8.GetString($b) })
$m=[regex]::Matches($t,'(?m)^MaxBars=\d+')
if($m.Count -ne 1){ Write-Host ('MI FERMO: in ' + $ci + ' ho trovato ' + $m.Count + ' righe MaxBars (ne attendo 1). Non ho cambiato niente.') -ForegroundColor Red; return }
Copy-Item -LiteralPath $ci -Destination ($ci + '.prima_MaxBars_' + (Get-Date).ToString('yyyyMMdd_HHmmss')) -Force
$new=[regex]::Replace($t,'(?m)^MaxBars=\d+','MaxBars=100000000')
$nb=$(if($uni){ [Text.Encoding]::Unicode.GetBytes($new) } else { (New-Object Text.UTF8Encoding($false)).GetBytes($new) })
[IO.File]::WriteAllBytes($ci,$nb)
Write-Host ('   fatto: ' + $m[0].Value + '  ->  MaxBars=100000000') -ForegroundColor Green
Write-Host ('2/3 Copio lo storico EURUSD (' + $nsrc.Count + ' file) in ' + $dst + ' ...') -ForegroundColor Cyan
New-Item -ItemType Directory -Force -Path $dst | Out-Null
Copy-Item -Path (Join-Path $src '*') -Destination $dst -Force -ErrorAction Stop
$ndst=@(Get-ChildItem -LiteralPath $dst -File -ErrorAction SilentlyContinue)
Write-Host ('   copiati: ' + $ndst.Count + ' file, ' + [math]::Round((($ndst | Measure-Object Length -Sum).Sum)/1MB,1) + ' MB') -ForegroundColor Green
if($ndst.Count -lt $nsrc.Count){ Write-Host ('ERRORE: nel portable ci sono ' + $ndst.Count + ' file invece di ' + $nsrc.Count + '.') -ForegroundColor Red; return }
Write-Host '3/3 Cache EURUSD degli agenti del tester del portable ...' -ForegroundColor Cyan
$n=0
Get-ChildItem -Path (Join-Path $P 'Tester') -Directory -Filter 'EURUSD' -Recurse -Depth 6 -ErrorAction SilentlyContinue | Where-Object { $_.FullName -like 'C:\MT5_BCM_Opt\Tester\*' -and ($_.FullName -like '*\history\EURUSD' -or $_.FullName -like '*\ticks\EURUSD') } | ForEach-Object { Write-Host ('   cancello ' + $_.FullName) -ForegroundColor Yellow; Remove-Item -LiteralPath $_.FullName -Recurse -Force -ErrorAction SilentlyContinue; $n=$n+1 }
Write-Host ('   cartelle di cache cancellate: ' + $n) -ForegroundColor Green
Write-Host 'Fatto. Non ho aperto nessun MT5. Ora puoi rilanciare la prima passata EURUSD (la stessa riga di prima).' -ForegroundColor Yellow
