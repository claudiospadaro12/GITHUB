# MARCATORE_COPERTURA_TICK_v1
# SOLA LETTURA: elenca, per ogni terminale MT5 del PC di backtest (BCM principale, portable C:\MT5_BCM_Opt, FTMO Mt5_Ftmo_Prova), i mesi di TICK REALI presenti su disco
# (bases\<server>\ticks\<simbolo>\AAAAMM.tkc) per EURUSD, GBPUSD, USDJPY, XAUUSD e le loro varianti (suffissi). Non apre MT5, non tocca conti, VPS o reale.
$ErrorActionPreference='Continue'
if($env:COMPUTERNAME -ne 'DESKTOP-H4D7CAJ'){ Write-Host ('SOLO sul PC di backtest DESKTOP-H4D7CAJ. Qui: ' + $env:COMPUTERNAME) -ForegroundColor Red; return }
$radici=New-Object System.Collections.ArrayList
$baseT=Join-Path $env:APPDATA 'MetaQuotes\Terminal'
foreach($o in @(Get-ChildItem -LiteralPath $baseT -Directory -ErrorAction SilentlyContinue)){ $orig=''; $of=Join-Path $o.FullName 'origin.txt'; if(Test-Path -LiteralPath $of){ $orig=((Get-Content -LiteralPath $of -Raw -Encoding Unicode) -replace '[\r\n\0]','').Trim() }; [void]$radici.Add(@{ dati=$o.FullName; etichetta=('APPDATA ' + $orig) }) }
foreach($pp in @('C:\MT5_BCM_Opt','C:\MT5_Backtest\Mt5_Ftmo_Prova')){ if(Test-Path -LiteralPath (Join-Path $pp 'bases')){ [void]$radici.Add(@{ dati=$pp; etichetta=('CARTELLA ' + $pp) }) } }
$rx='(?i)^(EURUSD|GBPUSD|USDJPY|XAUUSD)'
$out=New-Object System.Collections.ArrayList
[void]$out.Add('terminale;server;simbolo;mesi_tick_su_disco;primo_mese;ultimo_mese;MB')
foreach($r in $radici){
  $bases=Join-Path $r.dati 'bases'; if(-not (Test-Path -LiteralPath $bases)){ continue }
  foreach($srv in @(Get-ChildItem -LiteralPath $bases -Directory -ErrorAction SilentlyContinue)){
    $tk=Join-Path $srv.FullName 'ticks'; if(-not (Test-Path -LiteralPath $tk)){ continue }
    foreach($sim in @(Get-ChildItem -LiteralPath $tk -Directory -ErrorAction SilentlyContinue)){
      if($sim.Name -notmatch $rx){ continue }
      $m=@(); $mb=0.0
      foreach($f in @(Get-ChildItem -LiteralPath $sim.FullName -File -ErrorAction SilentlyContinue)){ $x=[regex]::Match($f.BaseName,'^(\d{6})$'); if($x.Success){ $m += $x.Groups[1].Value; $mb += ($f.Length/1MB) } }
      $m=@($m | Sort-Object -Unique)
      [void]$out.Add(($r.etichetta + ';' + $srv.Name + ';' + $sim.Name + ';' + $m.Count + ';' + $(if($m.Count){ $m[0] } else { '' }) + ';' + $(if($m.Count){ $m[$m.Count-1] } else { '' }) + ';' + $mb.ToString('0.0',[Globalization.CultureInfo]::InvariantCulture)))
    }
  }
}
$desk='C:\ABTG_RISULTATI'; if(-not (Test-Path -LiteralPath $desk)){ New-Item -ItemType Directory -Force -Path $desk | Out-Null }
$fo=Join-Path $desk ('COPERTURA_TICK_' + (Get-Date).ToString('yyyyMMdd_HHmm') + '.txt')
Set-Content -LiteralPath $fo -Value ($out -join "`r`n") -Encoding UTF8
try { Set-Clipboard -Value ($out -join "`r`n") } catch { }
$out | ForEach-Object { Write-Host $_ }
Write-Host ('Righe: ' + ($out.Count-1) + '. File prodotto: ' + $fo) -ForegroundColor Green
Write-Host ('>>> ALLEGA QUESTO TXT ALLA CHAT: ' + $fo + ' <<<') -ForegroundColor Black -BackgroundColor Yellow
Start-Process explorer.exe -ArgumentList ('/select,"' + $fo + '"')
