# MARCATORE_COPERTURA_UBS_v1
# SOLA LETTURA (nessun MT5 da chiudere, nessun file toccato). Per OGNI cartella dati MT5 del PC elenca, per i simboli dei set UBS NON oro (forex, argento, petrolio, Tesla, Bitcoin, indici), quanti anni di storico M1 ci sono (dimensione in MB di ogni file annuale) e quanti mesi di tick reali. Serve a decidere quali set di Wim si possono provare su BCM e con che periodi. Produce SINTESI_per_simbolo.csv e DETTAGLIO_per_anno.csv in uno zip sul Desktop.
$ErrorActionPreference='Continue'
$ci=[Globalization.CultureInfo]::InvariantCulture
if($env:COMPUTERNAME -ne 'DESKTOP-H4D7CAJ'){ Write-Host ('SOLO sul PC di backtest DESKTOP-H4D7CAJ. Qui: ' + $env:COMPUTERNAME) -ForegroundColor Red; return }
$radici=New-Object System.Collections.ArrayList
$baseT=Join-Path $env:APPDATA 'MetaQuotes\Terminal'
foreach($o in @(Get-ChildItem -LiteralPath $baseT -Directory -ErrorAction SilentlyContinue)){ $orig=''; $of=Join-Path $o.FullName 'origin.txt'; if(Test-Path -LiteralPath $of){ $orig=((Get-Content -LiteralPath $of -Raw -Encoding Unicode) -replace '[\r\n\0]','').Trim() }; [void]$radici.Add(@{ dati=$o.FullName; et=('APPDATA ' + $orig) }) }
foreach($pp in @('C:\MT5_BCM_Opt','C:\MT5_BCM_Tester2','C:\MT5_Backtest\Mt5_Ftmo_Prova','C:\MT5_Wim','C:\FTMO','C:\FTMO_P4','C:\FundedNext_Manuale')){ if(Test-Path -LiteralPath (Join-Path $pp 'bases')){ [void]$radici.Add(@{ dati=$pp; et=('CARTELLA ' + $pp) }) } }
$rx='(?i)(EURUSD|GBPUSD|USDJPY|AUDUSD|USDCAD|USDCHF|NZDUSD|EURJPY|GBPJPY|EURGBP|EURAUD|EURNZD|AUDJPY|CHFJPY|XAGUSD|XTIUSD|XBRUSD|USOIL|UKOIL|TSLA|BTC|ETH|US30|DJ30|DJI|WS30|U30|US500|SPX|SP500|US100|USTEC|NAS|NDX|DE40|DE30|DAX|D30|F40)'
$righe=New-Object System.Collections.ArrayList; $sint=New-Object System.Collections.ArrayList
[void]$righe.Add('terminale;server;simbolo;anno;MB'); [void]$sint.Add('terminale;server;simbolo;anni_M1;primo_anno;ultimo_anno;MB_totali;MB_mediano_per_anno;anni_sotto_3MB;mesi_tick;primo_mese_tick;ultimo_mese_tick')
foreach($r in $radici){
  $bases=Join-Path $r.dati 'bases'; if(-not (Test-Path -LiteralPath $bases)){ continue }
  foreach($srv in @(Get-ChildItem -LiteralPath $bases -Directory -ErrorAction SilentlyContinue)){
    $hist=Join-Path $srv.FullName 'history'; if(-not (Test-Path -LiteralPath $hist)){ continue }
    foreach($sim in @(Get-ChildItem -LiteralPath $hist -Directory -ErrorAction SilentlyContinue)){
      if($sim.Name -notmatch $rx){ continue }
      $v=@{}
      foreach($f in @(Get-ChildItem -LiteralPath $sim.FullName -File -ErrorAction SilentlyContinue)){ $m=[regex]::Match($f.BaseName,'^(\d{4})$'); if($m.Success){ $y=[int]$m.Groups[1].Value; if($v.ContainsKey($y)){ $v[$y]+=($f.Length/1MB) } else { $v[$y]=($f.Length/1MB) } } }
      if($v.Count -eq 0){ continue }
      $ys=@($v.Keys | Sort-Object); $tot=0.0; $mbs=@(); $bassi=0
      foreach($y in $ys){ $mb=$v[$y]; $tot+=$mb; $mbs += $mb; if($mb -lt 3){ $bassi++ }; [void]$righe.Add($r.et + ';' + $srv.Name + ';' + $sim.Name + ';' + $y + ';' + $mb.ToString('0.00',$ci)) }
      $ord=@($mbs | Sort-Object); $med=$ord[[int][math]::Floor($ord.Count/2)]
      $tk=Join-Path (Join-Path $srv.FullName 'ticks') $sim.Name; $mt=@(); if(Test-Path -LiteralPath $tk){ $mt=@(Get-ChildItem -LiteralPath $tk -File -ErrorAction SilentlyContinue | Where-Object { $_.BaseName -match '^\d{6}$' } | ForEach-Object { $_.BaseName } | Sort-Object) }
      $tkn=$mt.Count; $tk0=''; $tk1=''; if($tkn -gt 0){ $tk0=$mt[0]; $tk1=$mt[$tkn-1] }
      [void]$sint.Add($r.et + ';' + $srv.Name + ';' + $sim.Name + ';' + $ys.Count + ';' + $ys[0] + ';' + $ys[$ys.Count-1] + ';' + $tot.ToString('0.0',$ci) + ';' + $med.ToString('0.00',$ci) + ';' + $bassi + ';' + $tkn + ';' + $tk0 + ';' + $tk1)
    }
  }
}
$desk=[Environment]::GetFolderPath('Desktop'); $dirOut=Join-Path $desk 'ABTG_RISULTATI'; if(-not (Test-Path -LiteralPath $dirOut)){ [void](New-Item -ItemType Directory -Path $dirOut) }
$stamp=(Get-Date).ToString('yyyyMMdd_HHmm'); $w=Join-Path $env:TEMP ('COPERTURA_UBS_' + $stamp); New-Item -ItemType Directory -Force -Path $w | Out-Null
Set-Content -LiteralPath (Join-Path $w 'SINTESI_per_simbolo.csv') -Value ($sint -join "`r`n") -Encoding UTF8
Set-Content -LiteralPath (Join-Path $w 'DETTAGLIO_per_anno.csv') -Value ($righe -join "`r`n") -Encoding UTF8
$zip=Join-Path $dirOut ('COPERTURA_UBS_' + $stamp + '.zip'); Remove-Item -LiteralPath $zip -Force -ErrorAction SilentlyContinue
Compress-Archive -Path (Join-Path $w '*') -DestinationPath $zip -Force
$sint | ForEach-Object { Write-Host $_ }
Write-Host ('Simboli trovati: ' + ($sint.Count-1) + '. File prodotti: SINTESI_per_simbolo.csv e DETTAGLIO_per_anno.csv (dentro lo zip).') -ForegroundColor Green
Write-Host ''
Write-Host '##########  FILE DA ALLEGARE ALLA CHAT  ##########' -ForegroundColor Black -BackgroundColor Yellow
Write-Host $zip -ForegroundColor Black -BackgroundColor Yellow
try { Start-Process explorer.exe -ArgumentList ('/select,"' + $zip + '"') } catch { }
