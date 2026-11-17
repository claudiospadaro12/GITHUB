# MARCATORE_COPERTURA_STORICO_14EA_v1
# PASSO 0 del test dei 14 EA su 2015-2023 (criteri CLAU12_14_EA_OTTIMIZZATI_FUORI_CAMPIONE_CRITERI_2026-11-18, sezione 3). SOLA LETTURA: elenca i file di storico (anni) presenti su disco per oro, Dow, DAX, CAC e Nasdaq in ogni cartella dati MT5 del PC. Non avvia MT5, non scrive nei terminali, non tocca conti ne VPS. Scrive solo un file di testo sul Desktop.
$ErrorActionPreference='Continue'
if($env:COMPUTERNAME -ne 'DESKTOP-H4D7CAJ'){ Write-Host ('SOLO sul PC di backtest DESKTOP-H4D7CAJ. Qui: ' + $env:COMPUTERNAME) -ForegroundColor Red; return }
$radici=New-Object System.Collections.ArrayList
$baseT=Join-Path $env:APPDATA 'MetaQuotes\Terminal'
foreach($o in @(Get-ChildItem -LiteralPath $baseT -Directory -ErrorAction SilentlyContinue)){ $nome=$o.FullName; $of=Join-Path $o.FullName 'origin.txt'; $orig=''; if(Test-Path -LiteralPath $of){ $orig=((Get-Content -LiteralPath $of -Raw -Encoding Unicode) -replace '[\r\n\0]','').Trim() }; [void]$radici.Add(@{ dati=$nome; etichetta=('APPDATA ' + $orig) }) }
foreach($pp in @('C:\MT5_BCM_Opt','C:\MT5_Backtest\Mt5_Ftmo_Prova')){ if(Test-Path -LiteralPath (Join-Path $pp 'bases')){ [void]$radici.Add(@{ dati=$pp; etichetta=('CARTELLA ' + $pp) }) } }
$rx='(?i)^(XAU|U30|US30|DJ|D30|GER|DE40|DAX|F40|FRA|CAC|NAS|US100|NDX)'
$out=New-Object System.Collections.ArrayList
[void]$out.Add('terminale;server;simbolo;anni_su_disco;primo;ultimo;anni_mancanti_2015_2023;MB')
foreach($r in $radici){
  $bases=Join-Path $r.dati 'bases'; if(-not (Test-Path -LiteralPath $bases)){ continue }
  foreach($srv in @(Get-ChildItem -LiteralPath $bases -Directory -ErrorAction SilentlyContinue)){
    $hist=Join-Path $srv.FullName 'history'; if(-not (Test-Path -LiteralPath $hist)){ continue }
    foreach($sim in @(Get-ChildItem -LiteralPath $hist -Directory -ErrorAction SilentlyContinue)){
      if($sim.Name -notmatch $rx){ continue }
      $anni=@(); $mb=0.0
      foreach($f in @(Get-ChildItem -LiteralPath $sim.FullName -File -ErrorAction SilentlyContinue)){ $m=[regex]::Match($f.BaseName,'^(\d{4})$'); if($m.Success){ $anni += [int]$m.Groups[1].Value; $mb += ($f.Length/1MB) } }
      $anni=@($anni | Sort-Object -Unique)
      $manc=@(); foreach($y in 2015..2023){ if($anni -notcontains $y){ $manc += $y } }
      $pr=$(if($anni.Count -gt 0){ $anni[0] } else { '' }); $ul=$(if($anni.Count -gt 0){ $anni[$anni.Count-1] } else { '' })
      [void]$out.Add(($r.etichetta + ';' + $srv.Name + ';' + $sim.Name + ';' + $anni.Count + ';' + $pr + ';' + $ul + ';' + ($manc -join ',') + ';' + $mb.ToString('0.0',[Globalization.CultureInfo]::InvariantCulture)))
    }
  }
}
$desk=[Environment]::GetFolderPath('Desktop'); $fo=Join-Path $desk 'COPERTURA_STORICO_14EA.txt'
Set-Content -LiteralPath $fo -Value ($out -join "`r`n") -Encoding UTF8
try { Set-Clipboard -Value ($out -join "`r`n") } catch { }
$out | ForEach-Object { Write-Host $_ }
Write-Host ('FATTO. Righe: ' + ($out.Count-1) + '. File: ' + $fo + ' (allegalo alla chat).') -ForegroundColor Green
