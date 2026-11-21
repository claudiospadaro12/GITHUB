# MARCATORE_PREP_INDICI_UBS_v1
# SOLA LETTURA (non apre MT5, non scrive nei terminali, non tocca conti/VPS/reale). Passo 0 dell'ottimizzazione UBS sugli indici:
# verifica nel terminale principale BCM e nel portable C:\MT5_BCM_Opt: storico dei simboli _EXT per anno, tick dei simboli nativi, presenza dell'EA UBS V9.5,
# dei set di Wim (Indicement) e dei file di ottimizzazione; elenca i terminali MT5 aperti e lo spazio libero.
$ErrorActionPreference='Continue'
$INV=[Globalization.CultureInfo]::InvariantCulture
if($env:COMPUTERNAME -ne 'DESKTOP-H4D7CAJ'){ Write-Host ('SOLO sul PC di backtest DESKTOP-H4D7CAJ. Qui: ' + $env:COMPUTERNAME) -ForegroundColor Red; return }
$out=New-Object System.Collections.ArrayList
function Riga($s){ [void]$script:out.Add($s) }
Riga ('PREPARAZIONE INDICI UBS - ' + (Get-Date).ToString('yyyy-MM-dd HH:mm:ss',$INV) + ' - pc ' + $env:COMPUTERNAME)
Riga ''
Riga '== MT5 aperti (informativo) =='
$vivi=@(Get-Process -Name terminal64 -ErrorAction SilentlyContinue)
if($vivi.Count -eq 0){ Riga 'nessun terminal64 aperto' } else { foreach($v in $vivi){ $pth=''; try{ $pth=$v.Path }catch{}; Riga ('PID ' + $v.Id + ' ' + $pth) } }
Riga ''
$radici=New-Object System.Collections.ArrayList
$baseT=Join-Path $env:APPDATA 'MetaQuotes\Terminal'
foreach($o in @(Get-ChildItem -LiteralPath $baseT -Directory -ErrorAction SilentlyContinue)){
  $orig=''; $of=Join-Path $o.FullName 'origin.txt'
  if(Test-Path -LiteralPath $of){ try{ $orig=((Get-Content -LiteralPath $of -Raw -Encoding Unicode) -replace '[\r\n\0]','').Trim() }catch{} }
  if($orig -ne ''){ [void]$radici.Add(@{ dati=$o.FullName; etichetta=('APPDATA ' + $orig) }) }
}
if(Test-Path -LiteralPath 'C:\MT5_BCM_Opt'){ [void]$radici.Add(@{ dati='C:\MT5_BCM_Opt'; etichetta='PORTABLE C:\MT5_BCM_Opt' }) }
$rxSim='(?i)^(NASUSD|SPXUSD|U30USD)'
foreach($r in $radici){
  Riga ('==== ' + $r.etichetta + '  (dati: ' + $r.dati + ') ====')
  $bases=Join-Path $r.dati 'bases'
  if(Test-Path -LiteralPath $bases){
    foreach($srv in @(Get-ChildItem -LiteralPath $bases -Directory -ErrorAction SilentlyContinue)){
      $h=Join-Path $srv.FullName 'history'
      if(Test-Path -LiteralPath $h){
        foreach($sim in @(Get-ChildItem -LiteralPath $h -Directory -ErrorAction SilentlyContinue | Where-Object { $_.Name -match $rxSim })){
          $an=@(); $mb=0.0
          foreach($f in @(Get-ChildItem -LiteralPath $sim.FullName -File -ErrorAction SilentlyContinue)){ $x=[regex]::Match($f.BaseName,'^(\d{4})$'); if($x.Success){ $an+=$x.Groups[1].Value; $mb+=($f.Length/1MB) } }
          $an=@($an | Sort-Object -Unique)
          Riga ('storico;' + $srv.Name + ';' + $sim.Name + ';anni=' + $an.Count + ';' + ($an -join ',') + ';MB=' + $mb.ToString('0.0',$INV))
        }
      }
      $tk=Join-Path $srv.FullName 'ticks'
      if(Test-Path -LiteralPath $tk){
        foreach($sim in @(Get-ChildItem -LiteralPath $tk -Directory -ErrorAction SilentlyContinue | Where-Object { $_.Name -match $rxSim })){
          $m=@(); foreach($f in @(Get-ChildItem -LiteralPath $sim.FullName -File -ErrorAction SilentlyContinue)){ $x=[regex]::Match($f.BaseName,'^(\d{6})$'); if($x.Success){ $m+=$x.Groups[1].Value } }
          $m=@($m | Sort-Object -Unique)
          Riga ('tick;' + $srv.Name + ';' + $sim.Name + ';mesi=' + $m.Count + ';' + $(if($m.Count){ $m[0] + '..' + $m[$m.Count-1] } else { '' }))
        }
      }
    }
  } else { Riga 'nessuna cartella bases' }
  $ex=Join-Path $r.dati 'MQL5\Experts'
  $ea=@(); if(Test-Path -LiteralPath $ex){ $ea=@(Get-ChildItem -LiteralPath $ex -Recurse -File -Filter 'Ultimate_Breakout*' -ErrorAction SilentlyContinue) }
  if($ea.Count){ foreach($e in $ea){ Riga ('EA;' + $e.FullName.Substring($r.dati.Length) + ';' + $e.Length + ';' + $e.LastWriteTime.ToString('yyyy-MM-dd HH:mm',$INV)) } } else { Riga 'EA;Ultimate_Breakout NON TROVATO in MQL5\Experts' }
  foreach($sub in @('MQL5\Profiles\Tester','MQL5\Presets','MQL5\Files','tester')){
    $d=Join-Path $r.dati $sub
    if(Test-Path -LiteralPath $d){
      $s=@(Get-ChildItem -LiteralPath $d -Recurse -File -Include '*.set' -ErrorAction SilentlyContinue | Where-Object { $_.Name -match '(?i)(optim|US100|US500|US30|USTEC|Indicement)' })
      Riga ('set;' + $sub + ';' + $s.Count + ' file .set con nome optim/US100/US500/US30/USTEC')
      foreach($q in ($s | Select-Object -First 12)){ Riga ('   ' + $q.FullName.Substring($r.dati.Length) + ' ' + $q.Length) }
    }
  }
  Riga ''
}
Riga '== Set di Wim e zip sul PC (Desktop, Download, C:\ABTG*) =='
$cerca=@([Environment]::GetFolderPath('Desktop'),(Join-Path $env:USERPROFILE 'Downloads'))
foreach($c in @(Get-ChildItem 'C:\' -Directory -Filter 'ABTG*' -ErrorAction SilentlyContinue)){ $cerca += $c.FullName }
foreach($d in $cerca){
  if(-not (Test-Path -LiteralPath $d)){ continue }
  foreach($z in @(Get-ChildItem -LiteralPath $d -Recurse -Depth 2 -File -ErrorAction SilentlyContinue | Where-Object { $_.Name -match '(?i)(Ultimate-Breakout.*Set|UBS.*Set|Set-Files)' } | Select-Object -First 10)){ Riga ('zip/set;' + $z.FullName + ';' + $z.Length + ';' + $z.LastWriteTime.ToString('yyyy-MM-dd HH:mm',$INV)) }
}
Riga ''
$drv=Get-PSDrive -Name C -ErrorAction SilentlyContinue
if($drv){ Riga ('spazio libero C: ' + [math]::Round($drv.Free/1GB,1).ToString($INV) + ' GB') }
$desk='C:\ABTG_RISULTATI'; if(-not (Test-Path -LiteralPath $desk)){ New-Item -ItemType Directory -Force -Path $desk | Out-Null }
$fo=Join-Path $desk ('PREP_INDICI_UBS_' + (Get-Date).ToString('yyyyMMdd_HHmm') + '.txt')
Set-Content -LiteralPath $fo -Value ($out -join "`r`n") -Encoding UTF8
$out | ForEach-Object { Write-Host $_ }
Write-Host ''
Write-Host ('File prodotto (uno solo): ' + $fo) -ForegroundColor Green
Write-Host ('>>> ALLEGA QUESTO TXT ALLA CHAT: ' + $fo + ' <<<') -ForegroundColor Black -BackgroundColor Yellow
Start-Process explorer.exe -ArgumentList ('/select,"' + $fo + '"')
