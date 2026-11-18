# MARCATORE_CONTROLLO_PUNTELARRY_TICK_BCM_v1
# PUNTELARRY ORO: confronto Modello 1 contro TICK REALI (Modello 4) sulla stessa finestra, EA ABTG PunteLarry (copia *_F1), DEFAULT, XAUUSD, SOLO tester. Criteri: report/PUNTELARRY_ORO_TICK_CRITERI_2026-11-18.md.
$ErrorActionPreference='Continue'
$ci=[Globalization.CultureInfo]::InvariantCulture
if($env:COMPUTERNAME -ne 'DESKTOP-H4D7CAJ'){ Write-Host ('SOLO sul PC di backtest DESKTOP-H4D7CAJ. Qui: ' + $env:COMPUTERNAME) -ForegroundColor Red; return }
$ROOT='C:\MT5_BCM_Opt'; $TRM=Join-Path $ROOT 'terminal64.exe'; $MEE=Join-Path $ROOT 'metaeditor64.exe'; $MQL5=Join-Path $ROOT 'MQL5'
$PINSRC='d39ad355b6fa620661f17d031f41b1722999fa3d'
$aperti=@(Get-Process -Name terminal64,metatester64,metaeditor64 -ErrorAction SilentlyContinue)
if($aperti.Count -gt 0){ $aperti | Select-Object Id,ProcessName,Path | Format-Table -AutoSize | Out-String | Write-Host; Write-Host 'MI FERMO: MT5, MetaEditor o agenti aperti. Chiudili e rilancia. Non ho avviato niente.' -ForegroundColor Red; return }
foreach($pp in @($TRM,$MEE,$MQL5)){ if(-not (Test-Path -LiteralPath $pp)){ Write-Host ('MI FERMO: non trovo ' + $pp) -ForegroundColor Red; return } }
# 0) copertura dei TICK REALI XAUUSD (sola lettura sulle cartelle sorgente) e copia dei mesi mancanti nel terminale di test
$copL=New-Object System.Collections.ArrayList; [void]$copL.Add('cartella;mesi;primo;ultimo;MB')
$optSrv=@(Get-ChildItem -LiteralPath (Join-Path $ROOT 'bases') -Directory -ErrorAction SilentlyContinue | Where-Object { $_.Name -match 'BCM' } | Select-Object -First 1)
if($optSrv.Count -eq 0){ Write-Host ('MI FERMO: in ' + $ROOT + '\bases non c e una cartella server BCM.') -ForegroundColor Red; return }
$tdst=Join-Path $optSrv[0].FullName 'ticks\XAUUSD'; New-Item -ItemType Directory -Force -Path $tdst | Out-Null
$cand=New-Object System.Collections.ArrayList; [void]$cand.Add($tdst)
foreach($o in @(Get-ChildItem -LiteralPath (Join-Path $env:APPDATA 'MetaQuotes\Terminal') -Directory -ErrorAction SilentlyContinue)){ foreach($s in @(Get-ChildItem -LiteralPath (Join-Path $o.FullName 'bases') -Directory -ErrorAction SilentlyContinue | Where-Object { $_.Name -match 'BCM' })){ $p=Join-Path $s.FullName 'ticks\XAUUSD'; if(Test-Path -LiteralPath $p){ [void]$cand.Add($p) } } }
$best=@{}
foreach($p in $cand){
  $fl=@(Get-ChildItem -LiteralPath $p -Filter '*.tkc' -File -ErrorAction SilentlyContinue | Where-Object { $_.BaseName -match '^\d{6}$' } | Sort-Object Name)
  $mb=0.0; foreach($x in $fl){ $mb+=($x.Length/1MB) }
  [void]$copL.Add($p + ';' + $fl.Count + ';' + $(if($fl.Count){ $fl[0].BaseName } else { '' }) + ';' + $(if($fl.Count){ $fl[$fl.Count-1].BaseName } else { '' }) + ';' + $mb.ToString('0.0',$ci))
  if($p -ne $tdst){ foreach($x in $fl){ if((-not $best.ContainsKey($x.BaseName)) -or ($x.Length -gt $best[$x.BaseName].Length)){ $best[$x.BaseName]=$x } } }
}
$nCop=0; foreach($k in ($best.Keys | Sort-Object)){ $d=Join-Path $tdst ($k + '.tkc'); if(-not (Test-Path -LiteralPath $d)){ Copy-Item -LiteralPath $best[$k].FullName -Destination $d -Force; if((Get-Item -LiteralPath $d).Length -ne $best[$k].Length){ Write-Host ('ERRORE copia tick ' + $k) -ForegroundColor Red; return }; $nCop++ } }
$mesi=@(Get-ChildItem -LiteralPath $tdst -Filter '*.tkc' -File -ErrorAction SilentlyContinue | Where-Object { $_.BaseName -match '^\d{6}$' } | ForEach-Object { $_.BaseName } | Sort-Object)
$mm=[datetime]'2024-08-01'; $nCont=0; while($mesi -contains $mm.ToString('yyyyMM',$ci)){ $mm=$mm.AddMonths(1); $nCont++ }
if($mm -gt [datetime]'2026-10-01'){ $mm=[datetime]'2026-10-01' }
[void]$copL.Add('mesi copiati nel terminale di test: ' + $nCop + '; mesi di tick consecutivi da 2024-08: ' + $nCont + '; ToDate scelto: ' + $mm.ToString('yyyy.MM.dd',$ci))
$daT='2024.08.01'; $aT=$mm.ToString('yyyy.MM.dd',$ci)
$deskC=[Environment]::GetFolderPath('Desktop'); $dirC=Join-Path $deskC 'ABTG_RISULTATI'; New-Item -ItemType Directory -Force -Path $dirC | Out-Null; $fC=Join-Path $dirC 'COPERTURA_TICK_XAUUSD.txt'; Set-Content -LiteralPath $fC -Value ($copL -join "`r`n") -Encoding UTF8
$copL | ForEach-Object { Write-Host $_ }
if($nCont -lt 12){ Write-Host ('MI FERMO: meno di 12 mesi consecutivi di tick da 2024-08. Allega ' + $fC) -ForegroundColor Black -BackgroundColor Yellow; Start-Process explorer.exe -ArgumentList ('/select,"' + $fC + '"'); return }
$EAS=@(
  @{ n='ABTG_PunteLarry_F1'; per='H1'; sha='D2C087255BBC6ADA9625090C15EA44B938B8F89BC6DBF41CAA761BB552E3B39E'; inc=@( @{ n='ABTG_PausaGuardian.mqh'; sha='3EC971152E85E0082488CC4243FF45AE09948C191D52AB96050B48F94641A737' } ); inp=@(
      'InpUsaGuardian=false',
      'InpTF=16385',
      'InpPatternMode=0',
      'InpExitMode=0',
      'InpTP_R=1.5',
      'InpSLMode=0',
      'InpSLBufferATR=0.1',
      'InpAtrSlMult=1.5',
      'InpAtrPeriodD1=14',
      'InpSizeMinATR=0.0',
      'InpSizeMaxATR=0.0',
      'InpMaxDaysHold=5',
      'InpAllowLong=true',
      'InpAllowShort=true',
      'InpMaxSpreadPts=0',
      'InpEntryWindowBars=3',
      'InpRiskPercent=1.0',
      'InpMagic=772301',
      'InpComment=LARRY',
      'InpVerbose=false'
  ) }
)
function Num([string]$s){ $c=($s -replace '[^0-9.\-]',''); $v=0.0; if([double]::TryParse($c,[Globalization.NumberStyles]::Float,$ci,[ref]$v)){ return $v } else { return [double]::NaN } }
function Cerca([string]$t,[string]$et){ $m=[regex]::Match($t,'(?:' + $et + ')\|([^|]*)\|'); if($m.Success){ return $m.Groups[1].Value } else { return $null } }
function LeggiTesto([string]$p){ $b=[IO.File]::ReadAllBytes($p); if($b.Length -ge 2 -and (($b[0] -eq 255 -and $b[1] -eq 254) -or ($b[0] -eq 254 -and $b[1] -eq 255))){ return [Text.Encoding]::Unicode.GetString($b) } else { return [Text.Encoding]::UTF8.GetString($b) } }
$W=Join-Path $env:TEMP 'puntelarry_tick'; New-Item -ItemType Directory -Force -Path $W | Out-Null
$dstDir=Join-Path $MQL5 'Experts\TESTF1'; New-Item -ItemType Directory -Force -Path $dstDir | Out-Null
# 1) sorgenti dal repository (SHA256 verificato) e compilazione
foreach($ea in $EAS){
  $src=Join-Path $W ($ea.n + '.mq5'); Remove-Item -LiteralPath $src -Force -ErrorAction SilentlyContinue
  irm ('https://raw.githubusercontent.com/claudiospadaro12/GITHUB/' + $PINSRC + '/mql5/Experts/' + $ea.n + '.mq5?cb=' + [Guid]::NewGuid().ToString('N')) -OutFile $src
  $hh=(Get-FileHash -LiteralPath $src -Algorithm SHA256).Hash.ToUpperInvariant()
  if($hh -ne $ea.sha){ Write-Host ('MI FERMO: SHA256 diverso per ' + $ea.n + ': ' + $hh) -ForegroundColor Red; return }
  $dst=Join-Path $dstDir ($ea.n + '.mq5'); Copy-Item -LiteralPath $src -Destination $dst -Force
  foreach($ic in $ea.inc){ $isrc=Join-Path $W $ic.n; Remove-Item -LiteralPath $isrc -Force -ErrorAction SilentlyContinue; irm ('https://raw.githubusercontent.com/claudiospadaro12/GITHUB/' + $PINSRC + '/mql5/Include/' + $ic.n + '?cb=' + [Guid]::NewGuid().ToString('N')) -OutFile $isrc; $ih=(Get-FileHash -LiteralPath $isrc -Algorithm SHA256).Hash.ToUpperInvariant(); if($ih -ne $ic.sha){ Write-Host ('MI FERMO: SHA256 diverso per ' + $ic.n + ': ' + $ih) -ForegroundColor Red; return }; Copy-Item -LiteralPath $isrc -Destination (Join-Path $dstDir $ic.n) -Force }
  $logc=Join-Path $W ($ea.n + '_compila.log'); Remove-Item -LiteralPath $logc -Force -ErrorAction SilentlyContinue
  $ex5=[IO.Path]::ChangeExtension($dst,'.ex5'); Remove-Item -LiteralPath $ex5 -Force -ErrorAction SilentlyContinue
  [void](Start-Process -FilePath $MEE -ArgumentList ('/portable /compile:"' + $dst + '" /include:"' + $MQL5 + '" /log:"' + $logc + '"') -PassThru -Wait)
  if(-not (Test-Path -LiteralPath $logc)){ Write-Host ('MI FERMO: nessun log di compilazione per ' + $ea.n) -ForegroundColor Red; return }
  $txc=LeggiTesto $logc
  if(-not ((Test-Path -LiteralPath $ex5) -and ($txc -match 'Result:\s*0 errors'))){ Write-Host ('COMPILAZIONE NON RIUSCITA per ' + $ea.n + ': incollami queste righe.') -ForegroundColor Red; ($txc -split "`r?`n" | Where-Object { $_ -match 'error' }) | ForEach-Object { Write-Host ('   ' + $_) }; return }
  Write-Host ('COMPILATO ' + $ea.n) -ForegroundColor Green
}
# 2) test
if(-not ('SvegliaE14.Win' -as [type])){ Add-Type -Namespace SvegliaE14 -Name Win -MemberDefinition '[DllImport("kernel32.dll")] public static extern uint SetThreadExecutionState(uint esFlags);' }
[void][SvegliaE14.Win]::SetThreadExecutionState([uint32]2147483651)
$desk=[Environment]::GetFolderPath('Desktop'); $dirOut=Join-Path $desk 'CONTROLLO_PUNTELARRY_TICK'; $dirSerie=Join-Path $dirOut 'serie'; $dirRep=Join-Path $dirOut 'report'
New-Item -ItemType Directory -Force -Path $dirSerie | Out-Null; New-Item -ItemType Directory -Force -Path $dirRep | Out-Null
$FIN=@( @{ n='W_M1'; da=$daT; a=$aT; mod=1 }, @{ n='W_M4'; da=$daT; a=$aT; mod=4 } )
$righe=New-Object System.Collections.ArrayList
[void]$righe.Add('ea;finestra;operazioni;rend_totale_pct;PF_su_rendimenti;t_giornaliera;DD_equity_pct;anni_con_uscite;anni_positivi;quota_max_anno_pct;netto_tester_EUR;PF_tester;rendimento_per_anno_pct')
Write-Host ('=== TEST PUNTELARRY TICK su BCM portabile: ' + ($EAS.Count * $FIN.Count) + ' passate, Modello 1. Avvio ' + (Get-Date).ToString('dd/MM/yyyy HH:mm') + ' (ora italiana). Durata attesa 1-4 ore (STIMA: la passata a tick e la lunga). Non aprire MT5; PC alla corrente. ===') -ForegroundColor Cyan
$n=0; $stopTutto=$false
foreach($f in $FIN){
 foreach($ea in $EAS){
  if($stopTutto){ break }
  $n=$n+1; $rep='F1_' + $ea.n.Replace('ABTG_','').Replace('_F1','') + '_' + $f.n
  $r=@('[Experts]','AllowLiveTrading=false','AllowDllImport=false','','[Tester]',('Expert=TESTF1\' + $ea.n + '.ex5'),'Symbol=XAUUSD',('Period=' + $ea.per),('Model=' + $f.mod),'Optimization=0',('FromDate=' + $f.da),('ToDate=' + $f.a),'ForwardMode=0','Deposit=100000','Currency=EUR','Leverage=100','ExecutionMode=0','Visual=0','ReplaceReport=1','ShutdownTerminal=1',('Report=' + $rep),'','[TesterInputs]'); $r += $ea.inp
  $ini=Join-Path $W ($rep + '.ini'); Set-Content -LiteralPath $ini -Value (($r -join "`r`n") + "`r`n") -Encoding ASCII -NoNewline
  $rf=Join-Path $ROOT ($rep + '.htm'); Remove-Item -LiteralPath $rf -Force -ErrorAction SilentlyContinue
  $t0=Get-Date; $pr=Start-Process -FilePath $TRM -ArgumentList ('/portable /config:"' + $ini + '"') -PassThru
  $scade=$t0.AddMinutes($(if($f.mod -eq 4){ 300 } else { 60 })); while(-not $pr.HasExited -and (Get-Date) -lt $scade){ Start-Sleep -Seconds 4 }
  if(-not $pr.HasExited){ Write-Host ('TIMEOUT su ' + $rep + ': il terminale e ancora aperto. Non lo chiudo io: mi fermo qui.') -ForegroundColor Red; $stopTutto=$true; break }
  if(-not (Test-Path -LiteralPath $rf)){ [void]$righe.Add($ea.n + ';' + $f.n + ';ERRORE report non trovato;;;;;;;;;;'); Write-Host ('[' + $n + '] ' + $rep + ': report non trovato (mi serve il log del tester)') -ForegroundColor Red; continue }
  Copy-Item -LiteralPath $rf -Destination $dirRep -Force
  $html=LeggiTesto $rf
  $tx=[regex]::Replace($html,'<[^>]*>','|'); $tx=[regex]::Replace($tx,'\s*\|[\s|]*','|')
  $pT=Num (Cerca $tx 'Profitto Totale Netto:|Total Net Profit:'); $pfT=Num (Cerca $tx 'Fattore di Profitto:|Profit Factor:'); $nT=Num (Cerca $tx 'Numero di Operazioni di Trading Totali:|Total Trades:')
  $ddS=Cerca $tx 'Drawdown Massima:|Equity Drawdown Maximal:'; $ddP=[double]::NaN; if($ddS){ $mm=[regex]::Match($ddS,'\(([0-9.,]+)\s*%\)'); if($mm.Success){ $ddP=Num ($mm.Groups[1].Value.Replace(',','.')) } }
  $giorni=@{}; $anni=@{}; $rets=New-Object System.Collections.ArrayList; $inDeals=$false; $iPr=-1; $iDi=-1; $iBa=-1; $dep=0.0; $prevOut=0.0; $salFin=0.0
  foreach($rg in [regex]::Split($html,'(?i)<tr')){
    $celle=@(); foreach($mc in [regex]::Matches($rg,'(?is)<t[dh][^>]*>(.*?)</t[dh]>')){ $celle += (([regex]::Replace($mc.Groups[1].Value,'<[^>]*>','') -replace '&nbsp;',' ' -replace '\s+',' ').Trim()) }
    if($celle.Count -lt 8){ continue }
    $p1=-1; $d1=-1; $b1=-1
    for($i=0; $i -lt $celle.Count; $i++){ if($celle[$i] -match '^(Profit|Profitto|Utile)$'){ $p1=$i } elseif($celle[$i] -match '^(Direction|Direzione)$'){ $d1=$i } elseif($celle[$i] -match '^(Balance|Bilancio|Saldo)$'){ $b1=$i } }
    if($p1 -ge 0 -and $d1 -ge 0 -and $b1 -ge 0){ $inDeals=$true; $iPr=$p1; $iDi=$d1; $iBa=$b1; continue }
    if(-not $inDeals){ continue }
    if($celle[0] -notmatch '^(\d{4})\.(\d{2})\.(\d{2}) \d{2}:\d{2}:\d{2}$'){ continue }
    if($celle.Count -le $iBa){ continue }
    $dir=$celle[$iDi]; $bal=Num $celle[$iBa]
    if($dir -eq ''){ if($dep -eq 0.0){ $dep=$bal; $prevOut=$bal; $salFin=$bal }; continue }
    $salFin=$bal
    if($dir -ne 'out'){ continue }
    if($prevOut -le 0){ continue }
    $ret=($bal-$prevOut)/$prevOut; $prevOut=$bal; [void]$rets.Add($ret)
    $kd=$celle[0].Substring(0,10); $ky=$celle[0].Substring(0,4)
    if($giorni.ContainsKey($kd)){ $giorni[$kd]=$giorni[$kd] + $ret } else { $giorni[$kd]=$ret }
    if($anni.ContainsKey($ky)){ $anni[$ky]=$anni[$ky] + $ret } else { $anni[$ky]=$ret }
  }
  $gp=0.0; $gl=0.0; foreach($x in $rets){ if($x -gt 0){ $gp=$gp+$x } else { $gl=$gl-$x } }
  $pfR=$(if($gl -gt 0){ $gp/$gl } else { [double]::PositiveInfinity })
  $vals=@($giorni.Values); $nd=$vals.Count; $tst=[double]::NaN
  if($nd -ge 2){ $mu=($vals | Measure-Object -Average).Average; $ss=0.0; foreach($x in $vals){ $ss=$ss + ($x-$mu)*($x-$mu) }; $sd=[math]::Sqrt($ss/($nd-1)); if($sd -gt 0){ $tst=$mu/($sd/[math]::Sqrt($nd)) } }
  $rendTot=$(if($dep -gt 0){ ($salFin/$dep-1)*100 } else { [double]::NaN })
  $nA=$anni.Count; $nPos=0; $mx=0.0; $somma=0.0; $txA=@()
  foreach($ky in ($anni.Keys | Sort-Object)){ $v=$anni[$ky]; $somma=$somma+$v; if($v -gt 0){ $nPos=$nPos+1 }; if($v -gt $mx){ $mx=$v }; $txA += ($ky + ':' + ($v*100).ToString('0.00',$ci)) }
  $quota=$(if($somma -gt 0){ $mx/$somma*100 } else { [double]::NaN })
  $lin=@('data;rendimento'); foreach($k in ($giorni.Keys | Sort-Object)){ $lin += ($k + ';' + $giorni[$k].ToString('0.000000',$ci)) }
  Set-Content -LiteralPath (Join-Path $dirSerie ($rep + '.csv')) -Value $lin -Encoding ASCII
  $riga=($ea.n + ';' + $f.n + ';' + $nT + ';' + $rendTot.ToString('0.00',$ci) + ';' + $pfR.ToString('0.00',$ci) + ';' + $tst.ToString('0.00',$ci) + ';' + $ddP.ToString('0.00',$ci) + ';' + $nA + ';' + $nPos + ';' + $quota.ToString('0.0',$ci) + ';' + $pT.ToString('0.00',$ci) + ';' + $pfT.ToString('0.00',$ci) + ';' + ($txA -join '|'))
  [void]$righe.Add($riga)
  Write-Host ('[' + (Get-Date).ToString('HH:mm') + ' ' + $n + '/' + ($EAS.Count * $FIN.Count) + '] ' + $rep + ' ops ' + $nT + ' rend ' + $rendTot.ToString('0.0',$ci) + '% PFr ' + $pfR.ToString('0.00',$ci) + ' t ' + $tst.ToString('0.0',$ci) + ' DD ' + $ddP.ToString('0.0',$ci) + '%') -ForegroundColor Gray
 }
}
[void][SvegliaE14.Win]::SetThreadExecutionState([uint32]2147483648)
$fileCsv=Join-Path $dirOut 'RISULTATI_CONTROLLO_PUNTELARRY_TICK.csv'; Set-Content -LiteralPath $fileCsv -Value ($righe -join "`r`n") -Encoding UTF8
$zip=Join-Path $desk 'CONTROLLO_PUNTELARRY_TICK.zip'; Remove-Item -LiteralPath $zip -Force -ErrorAction SilentlyContinue
try { Compress-Archive -Path (Join-Path $dirOut '*') -DestinationPath $zip -Force } catch { Write-Host 'ZIP non creato: allega la cartella a mano.' -ForegroundColor Red }
Write-Host ('FATTO alle ' + (Get-Date).ToString('dd/MM/yyyy HH:mm') + ' (ora italiana).') -ForegroundColor Green
Write-Host ''
Write-Host '##########  FILE DA ALLEGARE ALLA CHAT  ##########' -ForegroundColor Black -BackgroundColor Yellow
Write-Host $zip -ForegroundColor Black -BackgroundColor Yellow
Write-Host '(contiene: RISULTATI_CONTROLLO_PUNTELARRY_TICK.csv + cartella serie + cartella report; Esplora file si apre con lo zip selezionato)' -ForegroundColor Black -BackgroundColor Yellow
try { Start-Process -FilePath 'explorer.exe' -ArgumentList ('/select,"' + $zip + '"') } catch { }
