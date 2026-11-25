# MARCATORE_COPERTURA_DENSITA_v1
# SOLA LETTURA. Per OGNI cartella dati MT5 del PC (anche Pepperstone, Tickmill, FTMO, portatili) elenca, per gli INDICI (Dow, S&P, Nasdaq, DAX, ecc.), la dimensione in MB di ogni file annuale di storico (M1). Serve a vedere quanti anni ci sono davvero e se sono densi o bucati (es. NASUSD_EXT e SPXUSD_EXT 2010-2026) e se il Dow esiste da qualche parte prima del 2024. Non avvia MT5, non scrive nei terminali, non tocca conti ne VPS. Scrive solo un CSV e uno ZIP sul Desktop (ABTG_RISULTATI).
$ErrorActionPreference='Continue'
$ci=[Globalization.CultureInfo]::InvariantCulture
if($env:COMPUTERNAME -ne 'DESKTOP-H4D7CAJ'){ Write-Host ('SOLO sul PC di backtest DESKTOP-H4D7CAJ. Qui: ' + $env:COMPUTERNAME) -ForegroundColor Red; return }
$radici=New-Object System.Collections.ArrayList
$baseT=Join-Path $env:APPDATA 'MetaQuotes\Terminal'
foreach($o in @(Get-ChildItem -LiteralPath $baseT -Directory -ErrorAction SilentlyContinue)){ $orig=''; $of=Join-Path $o.FullName 'origin.txt'; if(Test-Path -LiteralPath $of){ $orig=((Get-Content -LiteralPath $of -Raw -Encoding Unicode) -replace '[\r\n\0]','').Trim() }; [void]$radici.Add(@{ dati=$o.FullName; et=('APPDATA ' + $orig) }) }
foreach($pp in @('C:\MT5_BCM_Opt','C:\MT5_BCM_Tester2','C:\MT5_Backtest\Mt5_Ftmo_Prova','C:\MT5_Wim','C:\FTMO','C:\FTMO_P4','C:\FundedNext_Manuale')){ if(Test-Path -LiteralPath (Join-Path $pp 'bases')){ [void]$radici.Add(@{ dati=$pp; et=('CARTELLA ' + $pp) }) } }
$rx='(?i)(US30|DJ30|DJI|DOW|WS30|U30|US500|SPX|SP500|US100|USTEC|NAS|NDX|DE40|DE30|GER|DAX|D30|F40|FRA|UK100|JP225|225JPY|HK50|AUS200|US2000|EU50)'
$righe=New-Object System.Collections.ArrayList; $sint=New-Object System.Collections.ArrayList
[void]$righe.Add('terminale;server;simbolo;anno;MB'); [void]$sint.Add('terminale;server;simbolo;anni;primo;ultimo;MB_totali;MB_mediano_per_anno;anni_sotto_3MB')
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
      [void]$sint.Add($r.et + ';' + $srv.Name + ';' + $sim.Name + ';' + $ys.Count + ';' + $ys[0] + ';' + $ys[$ys.Count-1] + ';' + $tot.ToString('0.0',$ci) + ';' + $med.ToString('0.00',$ci) + ';' + $bassi)
    }
  }
}
$desk=[Environment]::GetFolderPath('Desktop'); $dirOut=Join-Path $desk 'ABTG_RISULTATI'; if(-not (Test-Path -LiteralPath $dirOut)){ [void](New-Item -ItemType Directory -Path $dirOut) }
$stamp=(Get-Date).ToString('yyyyMMdd_HHmm'); $w=Join-Path $env:TEMP ('COPERTURA_DENSITA_' + $stamp); New-Item -ItemType Directory -Force -Path $w | Out-Null
Set-Content -LiteralPath (Join-Path $w 'SINTESI_per_simbolo.csv') -Value ($sint -join "`r`n") -Encoding UTF8
Set-Content -LiteralPath (Join-Path $w 'DETTAGLIO_per_anno.csv') -Value ($righe -join "`r`n") -Encoding UTF8
$zip=Join-Path $dirOut ('COPERTURA_INDICI_DENSITA_' + $stamp + '.zip'); Remove-Item -LiteralPath $zip -Force -ErrorAction SilentlyContinue
Compress-Archive -Path (Join-Path $w '*') -DestinationPath $zip -Force
$sint | ForEach-Object { Write-Host $_ }
Write-Host ('Simboli indice trovati: ' + ($sint.Count-1) + '. File prodotti: SINTESI_per_simbolo.csv e DETTAGLIO_per_anno.csv (dentro lo zip).') -ForegroundColor Green
Write-Host ''
Write-Host '##########  FILE DA ALLEGARE ALLA CHAT  ##########' -ForegroundColor Black -BackgroundColor Yellow
Write-Host $zip -ForegroundColor Black -BackgroundColor Yellow
try { Start-Process explorer.exe -ArgumentList ('/select,"' + $zip + '"') } catch { }
