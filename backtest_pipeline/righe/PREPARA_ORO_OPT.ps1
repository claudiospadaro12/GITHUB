# MARCATORE_PREPARA_ORO_OPT_v1
# Prepara il MT5 PORTABLE C:\MT5_BCM_Opt per il pilota di ottimizzazione sull'ORO: (1) controlla MaxBars=100000000 nel suo config\common.ini (sola lettura); (2) copia lo storico XAUUSD dal terminale principale (solo lettura) nel portable; (3) cancella le cache XAUUSD degli agenti del tester del portable; (4) crea OPT2_ORO.set da GOLDTRADEPRO_E.set con 4 parametri liberi (griglia 5 x 5 x 5 x 5 = 625 passaggi).
# Scrive SOLO dentro C:\MT5_BCM_Opt. NON apre ne chiude MT5, NON modifica il terminale principale, ne conti, VPS, FTMO, AppData.
$ErrorActionPreference='Continue'
if($env:COMPUTERNAME -ne 'DESKTOP-H4D7CAJ'){ Write-Host ('SOLO sul PC di backtest DESKTOP-H4D7CAJ. Qui: ' + $env:COMPUTERNAME) -ForegroundColor Red; return }
$MAIN='C:\Users\Master\AppData\Roaming\MetaQuotes\Terminal\215D85D767A1C39E22D242C8114BF9F5'; $PT='C:\MT5_BCM_Opt'
$aperti=@(Get-Process -Name terminal64,metatester64,metaeditor64 -ErrorAction SilentlyContinue)
if($aperti.Count -gt 0){ $aperti | Select-Object Id,ProcessName,Path | Format-Table -AutoSize | Out-String | Write-Host; Write-Host 'MI FERMO: ci sono MT5, MetaEditor o agenti del tester aperti. Chiudili e rilancia. Non ho cambiato niente.' -ForegroundColor Red; return }
$src=Join-Path $MAIN 'bases\BCMMarkets-Server\history\XAUUSD'; $dst=Join-Path $PT 'bases\BCMMarkets-Server\history\XAUUSD'; $ci=Join-Path $PT 'config\common.ini'
$sset=Join-Path $PT 'MQL5\Profiles\Tester\UBS_V9_0\Breakout_Support_Resistance\GOLD\Goldtrade Pro\GOLDTRADEPRO_E.set'; $dset=Join-Path $PT 'MQL5\Profiles\Tester\OPT2_ORO.set'
foreach($pp in @($src,$ci,$sset)){ if(-not (Test-Path -LiteralPath $pp)){ Write-Host ('MI FERMO: non trovo ' + $pp + '. Non ho cambiato niente.') -ForegroundColor Red; return } }
$nsrc=@(Get-ChildItem -LiteralPath $src -File -ErrorAction SilentlyContinue)
if($nsrc.Count -lt 20){ Write-Host ('MI FERMO: nello storico sorgente ci sono solo ' + $nsrc.Count + ' file (ne attendo 23). Non ho cambiato niente.') -ForegroundColor Red; return }
Write-Host '1/4 MaxBars nel config del portable (sola lettura) ...' -ForegroundColor Cyan
$cb=[IO.File]::ReadAllBytes($ci); $cuni=($cb.Length -ge 2 -and $cb[0] -eq 255 -and $cb[1] -eq 254)
$ct=$(if($cuni){ [Text.Encoding]::Unicode.GetString($cb) } else { [Text.Encoding]::UTF8.GetString($cb) })
$mm=[regex]::Matches($ct,'(?m)^MaxBars=(\d+)')
if($mm.Count -ne 1 -or $mm[0].Groups[1].Value -ne '100000000'){ Write-Host ('MI FERMO: MaxBars non e 100000000 (righe trovate: ' + $mm.Count + '). Non ho cambiato niente.') -ForegroundColor Red; return }
Write-Host '   MaxBars=100000000: ok' -ForegroundColor Green
Write-Host ('2/4 Copio lo storico XAUUSD (' + $nsrc.Count + ' file, anni ' + (($nsrc | ForEach-Object { $_.BaseName }) -join ' ') + ') in ' + $dst + ' ...') -ForegroundColor Cyan
New-Item -ItemType Directory -Force -Path $dst | Out-Null
Copy-Item -Path (Join-Path $src '*') -Destination $dst -Force -ErrorAction Stop
$ndst=@(Get-ChildItem -LiteralPath $dst -File -ErrorAction SilentlyContinue)
Write-Host ('   nel portable ora: ' + $ndst.Count + ' file, ' + [math]::Round((($ndst | Measure-Object Length -Sum).Sum)/1MB,1) + ' MB') -ForegroundColor Green
if($ndst.Count -lt $nsrc.Count){ Write-Host ('ERRORE: nel portable ci sono ' + $ndst.Count + ' file invece di ' + $nsrc.Count + '.') -ForegroundColor Red; return }
Write-Host '3/4 Cache XAUUSD degli agenti del tester del portable ...' -ForegroundColor Cyan
$nc=0
Get-ChildItem -Path (Join-Path $PT 'Tester') -Directory -Filter 'XAUUSD*' -Recurse -Depth 6 -ErrorAction SilentlyContinue | Where-Object { $_.FullName -like 'C:\MT5_BCM_Opt\Tester\*' -and ($_.FullName -like '*\history\XAUUSD*' -or $_.FullName -like '*\ticks\XAUUSD*') } | ForEach-Object { Write-Host ('   cancello ' + $_.FullName) -ForegroundColor Yellow; Remove-Item -LiteralPath $_.FullName -Recurse -Force -ErrorAction SilentlyContinue; $nc=$nc+1 }
Write-Host ('   cartelle di cache cancellate: ' + $nc) -ForegroundColor Green
Write-Host '4/4 Creo OPT2_ORO.set da GOLDTRADEPRO_E.set ...' -ForegroundColor Cyan
$NUOVI=@{ 'Exit_stop'=@('600','300','150','900'); 'Exit_limit'=@('1700','900','400','2500'); 'ST1_MinDist_to_HL'=@('550','350','100','750'); 'ST1_Expiration_hours'=@('480','96','96','480') }
$sb=[IO.File]::ReadAllBytes($sset); $suni=($sb.Length -ge 2 -and $sb[0] -eq 255 -and $sb[1] -eq 254)
$st=$(if($suni){ [Text.Encoding]::Unicode.GetString($sb) } else { [Text.Encoding]::UTF8.GetString($sb) })
$nl=$(if($st.Contains("`r`n")){ "`r`n" } else { "`n" })
$righe=@($st -split "`r?`n"); $out=New-Object System.Collections.ArrayList; $yes=@(); $visti=@{}; $cambi=@()
foreach($r in $righe){
  $x=$r
  $m=[regex]::Match($r,'^(?<n>[A-Za-z0-9_]+)=(?<v>[^|]*)\|\|(?<a>[^|]*)\|\|(?<s>[^|]*)\|\|(?<z>[^|]*)\|\|(?<f>[YN])\s*$')
  if($m.Success){
    $nm=$m.Groups['n'].Value
    if($NUOVI.ContainsKey($nm)){
      $vv=$NUOVI[$nm]
      if($m.Groups['v'].Value -ne $vv[0]){ Write-Host ('MI FERMO: ' + $nm + ' nel set vale ' + $m.Groups['v'].Value + ' invece di ' + $vv[0] + ' (non e il GTP E atteso). Non ho scritto OPT2_ORO.set.') -ForegroundColor Red; return }
      $x=$nm + '=' + $vv[0] + '||' + $vv[1] + '||' + $vv[2] + '||' + $vv[3] + '||Y'; $visti[$nm]=1; $yes += $x
    } else {
      $x=$nm + '=' + $m.Groups['v'].Value + '||' + $m.Groups['a'].Value + '||' + $m.Groups['s'].Value + '||' + $m.Groups['z'].Value + '||N'
    }
    if($x -ne $r.TrimEnd()){ $cambi += ('   ' + $r.Trim() + '   ->   ' + $x) }
  }
  [void]$out.Add($x)
}
Write-Host ('Parametri attivi per la griglia (||Y): ' + $yes.Count) -ForegroundColor Cyan
$yes | ForEach-Object { Write-Host ('   ' + $_) -ForegroundColor Green }
Write-Host 'Righe cambiate:' -ForegroundColor Cyan
$cambi | ForEach-Object { Write-Host $_ -ForegroundColor Yellow }
if($yes.Count -ne 4 -or $visti.Count -ne 4){ Write-Host ('MI FERMO: i parametri attivi sono ' + $yes.Count + ' invece di 4. Non ho scritto OPT2_ORO.set.') -ForegroundColor Red; return }
if(Test-Path -LiteralPath $dset){ Copy-Item -LiteralPath $dset -Destination ($dset + '.prima_' + (Get-Date).ToString('yyyyMMdd_HHmmss')) -Force }
$new=($out -join $nl)
$nb=$(if($suni){ [Text.Encoding]::Unicode.GetBytes($new) } else { (New-Object Text.UTF8Encoding($false)).GetBytes($new) })
[IO.File]::WriteAllBytes($dset,$nb)
Write-Host ('Fatto: ' + $dset + '  (' + $nb.Length + ' byte). Nessun MT5 aperto da me. In MT5 portable: Strategy Tester > Inputs > tasto destro > Load > OPT2_ORO.set.') -ForegroundColor Yellow
