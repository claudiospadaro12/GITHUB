# MARCATORE_BREAKOUT_CORSO_BCM_v1
# ABTG_BreakoutCorso (strategia Breakout del corso, default) su 7 cross JPY + XAUUSD, M15, 2013-01-01 -> 2024-12-31, Modello 1, BCM portabile, SOLO tester: 16 passate (modo rettangolo 1 e 0). Criteri: report/BREAKOUT_CORSO_CRITERI_2026-11-19.md
$ErrorActionPreference='Continue'
$ci=[Globalization.CultureInfo]::InvariantCulture
if($env:COMPUTERNAME -ne 'DESKTOP-H4D7CAJ'){ Write-Host ('SOLO sul PC di backtest DESKTOP-H4D7CAJ. Qui: ' + $env:COMPUTERNAME) -ForegroundColor Red; return }
$ROOT='C:\MT5_BCM_Opt'; $TRM=Join-Path $ROOT 'terminal64.exe'; $MEE=Join-Path $ROOT 'metaeditor64.exe'; $MQL5=Join-Path $ROOT 'MQL5'
$PINSRC='143fd8f3b300d41bf4b77a9bf0d8267be373988f'
$aperti=@(Get-Process -Name terminal64,metatester64,metaeditor64 -ErrorAction SilentlyContinue)
if($aperti.Count -gt 0){ $aperti | Select-Object Id,ProcessName,Path | Format-Table -AutoSize | Out-String | Write-Host; Write-Host 'MI FERMO: MT5, MetaEditor o agenti aperti. Chiudili e rilancia. Non ho avviato niente.' -ForegroundColor Red; return }
foreach($pp in @($TRM,$MEE,$MQL5)){ if(-not (Test-Path -LiteralPath $pp)){ Write-Host ('MI FERMO: non trovo ' + $pp) -ForegroundColor Red; return } }
$EAS=@(
  @{ n='ABTG_BreakoutCorso'; per='H1'; sha='28FCE86F92BCBBE5CC18EB6E59E193FFCA2A292C82F4FBB6561254198CC6C3D2'; inp=@(
      'InpTF=15',
      'InpWprPeriod=140',
      'InpOB=-20.0',
      'InpOS=-80.0',
      'InpMidLevel=-50.0',
      'InpStAtrPeriod=10',
      'InpStMult=3.0',
      'InpRectBars=20',
      'InpRectMode=1',
      'InpMaxAge=100',
      'InpSlPips=1.0',
      'InpTpMult=3.0',
      'InpMinRR=2.0',
      'InpBeAtR=1.0',
      'InpRiskPct=1.0',
      'InpAllowLong=true',
      'InpAllowShort=true',
      'InpMagic=20261120'
  ) }
)
function Num([string]$s){ $c=($s -replace '[^0-9.\-]',''); $v=0.0; if([double]::TryParse($c,[Globalization.NumberStyles]::Float,$ci,[ref]$v)){ return $v } else { return [double]::NaN } }
function Cerca([string]$t,[string]$et){ $m=[regex]::Match($t,'(?:' + $et + ')\|([^|]*)\|'); if($m.Success){ return $m.Groups[1].Value } else { return $null } }
function LeggiTesto([string]$p){ $b=[IO.File]::ReadAllBytes($p); if($b.Length -ge 2 -and (($b[0] -eq 255 -and $b[1] -eq 254) -or ($b[0] -eq 254 -and $b[1] -eq 255))){ return [Text.Encoding]::Unicode.GetString($b) } else { return [Text.Encoding]::UTF8.GetString($b) } }
$W=Join-Path $env:TEMP 'breakout_corso'; New-Item -ItemType Directory -Force -Path $W | Out-Null
$dstDir=Join-Path $MQL5 'Experts\TEST14'; New-Item -ItemType Directory -Force -Path $dstDir | Out-Null
# 1) sorgenti dal repository (SHA256 verificato) e compilazione
foreach($ea in $EAS){
  $src=Join-Path $W ($ea.n + '.mq5'); Remove-Item -LiteralPath $src -Force -ErrorAction SilentlyContinue
  irm ('https://raw.githubusercontent.com/claudiospadaro12/GITHUB/' + $PINSRC + '/mql5/Experts/' + $ea.n + '.mq5?cb=' + [Guid]::NewGuid().ToString('N')) -OutFile $src
  $hh=(Get-FileHash -LiteralPath $src -Algorithm SHA256).Hash.ToUpperInvariant()
  if($hh -ne $ea.sha){ Write-Host ('MI FERMO: SHA256 diverso per ' + $ea.n + ': ' + $hh) -ForegroundColor Red; return }
  $dst=Join-Path $dstDir ($ea.n + '.mq5'); Copy-Item -LiteralPath $src -Destination $dst -Force
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
$desk='C:\ABTG_RISULTATI'; New-Item -ItemType Directory -Force -Path $desk | Out-Null; $dirOut=Join-Path $desk 'BREAKOUT_CORSO'; $dirSerie=Join-Path $dirOut 'serie'; $dirRep=Join-Path $dirOut 'report'
New-Item -ItemType Directory -Force -Path $dirSerie | Out-Null; New-Item -ItemType Directory -Force -Path $dirRep | Out-Null
$FIN=@( @{ n='W2013_2024'; da='2013.01.01'; a='2024.12.31' } )
$VARS=@( @{ v='USDJPY_M1'; sym='USDJPY'; per='M15'; ea='ABTG_BreakoutCorso'; ov=@() }, @{ v='USDJPY_M0'; sym='USDJPY'; per='M15'; ea='ABTG_BreakoutCorso'; ov=@('InpRectMode=0') }, @{ v='EURJPY_M1'; sym='EURJPY'; per='M15'; ea='ABTG_BreakoutCorso'; ov=@() }, @{ v='EURJPY_M0'; sym='EURJPY'; per='M15'; ea='ABTG_BreakoutCorso'; ov=@('InpRectMode=0') }, @{ v='GBPJPY_M1'; sym='GBPJPY'; per='M15'; ea='ABTG_BreakoutCorso'; ov=@() }, @{ v='GBPJPY_M0'; sym='GBPJPY'; per='M15'; ea='ABTG_BreakoutCorso'; ov=@('InpRectMode=0') }, @{ v='CHFJPY_M1'; sym='CHFJPY'; per='M15'; ea='ABTG_BreakoutCorso'; ov=@() }, @{ v='CHFJPY_M0'; sym='CHFJPY'; per='M15'; ea='ABTG_BreakoutCorso'; ov=@('InpRectMode=0') }, @{ v='NZDJPY_M1'; sym='NZDJPY'; per='M15'; ea='ABTG_BreakoutCorso'; ov=@() }, @{ v='NZDJPY_M0'; sym='NZDJPY'; per='M15'; ea='ABTG_BreakoutCorso'; ov=@('InpRectMode=0') }, @{ v='AUDJPY_M1'; sym='AUDJPY'; per='M15'; ea='ABTG_BreakoutCorso'; ov=@() }, @{ v='AUDJPY_M0'; sym='AUDJPY'; per='M15'; ea='ABTG_BreakoutCorso'; ov=@('InpRectMode=0') }, @{ v='CADJPY_M1'; sym='CADJPY'; per='M15'; ea='ABTG_BreakoutCorso'; ov=@() }, @{ v='CADJPY_M0'; sym='CADJPY'; per='M15'; ea='ABTG_BreakoutCorso'; ov=@('InpRectMode=0') }, @{ v='XAUUSD_M1'; sym='XAUUSD'; per='M15'; ea='ABTG_BreakoutCorso'; ov=@() }, @{ v='XAUUSD_M0'; sym='XAUUSD'; per='M15'; ea='ABTG_BreakoutCorso'; ov=@('InpRectMode=0') } )
$RUNS=@(); foreach($v in $VARS){ $e=$null; foreach($x in $EAS){ if($x.n -eq $v.ea){ $e=$x } }; $ovn=@($v.ov | ForEach-Object { ($_ -split '=')[0] }); $iv=@($e.inp | Where-Object { $ovn -notcontains (($_ -split '=')[0]) }) + @($v.ov); $RUNS += @{ n=$e.n; per=$v.per; var=$v.v; sym=$v.sym; inpv=$iv } }
$righe=New-Object System.Collections.ArrayList
[void]$righe.Add('variante;finestra;operazioni;rend_totale_pct;PF_su_rendimenti;t_giornaliera;DD_equity_pct;anni_con_uscite;anni_positivi;quota_max_anno_pct;netto_tester_EUR;PF_tester;rendimento_per_anno_pct')
Write-Host ('=== TEST BREAKOUT CORSO (BCM portabile): ' + ($RUNS.Count * $FIN.Count) + ' passate, Modello 1. Avvio ' + (Get-Date).ToString('dd/MM/yyyy HH:mm') + ' (ora italiana). Durata attesa 1-3 ore (STIMA, 16 passate M15). Non aprire MT5; PC alla corrente. ===') -ForegroundColor Cyan
$n=0; $stopTutto=$false
foreach($f in $FIN){
 foreach($ea in $RUNS){
  if($stopTutto){ break }
  $n=$n+1; $rep='BC_' + $ea.var + '_' + $f.n
  $r=@('[Experts]','AllowLiveTrading=false','AllowDllImport=false','','[Tester]',('Expert=TEST14\' + $ea.n + '.ex5'),('Symbol=' + $ea.sym),('Period=' + $ea.per),'Model=1','Optimization=0',('FromDate=' + $f.da),('ToDate=' + $f.a),'ForwardMode=0','Deposit=100000','Currency=EUR','Leverage=100','ExecutionMode=0','Visual=0','ReplaceReport=1','ShutdownTerminal=1',('Report=' + $rep),'','[TesterInputs]'); $r += $ea.inpv
  $ini=Join-Path $W ($rep + '.ini'); Set-Content -LiteralPath $ini -Value (($r -join "`r`n") + "`r`n") -Encoding ASCII -NoNewline
  $rf=Join-Path $ROOT ($rep + '.htm'); Remove-Item -LiteralPath $rf -Force -ErrorAction SilentlyContinue
  $t0=Get-Date; $pr=Start-Process -FilePath $TRM -ArgumentList ('/portable /config:"' + $ini + '"') -PassThru
  $scade=$t0.AddMinutes(60); while(-not $pr.HasExited -and (Get-Date) -lt $scade){ Start-Sleep -Seconds 4 }
  if(-not $pr.HasExited){ Write-Host ('TIMEOUT su ' + $rep + ': il terminale e ancora aperto. Non lo chiudo io: mi fermo qui.') -ForegroundColor Red; $stopTutto=$true; break }
  if(-not (Test-Path -LiteralPath $rf)){ [void]$righe.Add($ea.var + ';' + $f.n + ';ERRORE report non trovato;;;;;;;;;;'); Write-Host ('[' + $n + '] ' + $rep + ': report non trovato (mi serve il log del tester)') -ForegroundColor Red; continue }
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
  $riga=($ea.var + ';' + $f.n + ';' + $nT + ';' + $rendTot.ToString('0.00',$ci) + ';' + $pfR.ToString('0.00',$ci) + ';' + $tst.ToString('0.00',$ci) + ';' + $ddP.ToString('0.00',$ci) + ';' + $nA + ';' + $nPos + ';' + $quota.ToString('0.0',$ci) + ';' + $pT.ToString('0.00',$ci) + ';' + $pfT.ToString('0.00',$ci) + ';' + ($txA -join '|'))
  [void]$righe.Add($riga)
  Write-Host ('[' + (Get-Date).ToString('HH:mm') + ' ' + $n + '/' + ($RUNS.Count * $FIN.Count) + '] ' + $rep + ' ops ' + $nT + ' rend ' + $rendTot.ToString('0.0',$ci) + '% PFr ' + $pfR.ToString('0.00',$ci) + ' t ' + $tst.ToString('0.0',$ci) + ' DD ' + $ddP.ToString('0.0',$ci) + '%') -ForegroundColor Gray
 }
}
[void][SvegliaE14.Win]::SetThreadExecutionState([uint32]2147483648)
$fileCsv=Join-Path $dirOut 'RISULTATI_BREAKOUT_CORSO.csv'; Set-Content -LiteralPath $fileCsv -Value ($righe -join "`r`n") -Encoding UTF8
$zip=Join-Path $desk 'BREAKOUT_CORSO.zip'; Remove-Item -LiteralPath $zip -Force -ErrorAction SilentlyContinue
try { Compress-Archive -Path (Join-Path $dirOut '*') -DestinationPath $zip -Force } catch { Write-Host 'ZIP non creato: allega la cartella a mano.' -ForegroundColor Red }
Write-Host ('FATTO alle ' + (Get-Date).ToString('dd/MM/yyyy HH:mm') + ' (ora italiana).') -ForegroundColor Green
Write-Host ''
Write-Host '##########  FILE DA ALLEGARE ALLA CHAT  ##########' -ForegroundColor Black -BackgroundColor Yellow
Write-Host $zip -ForegroundColor Black -BackgroundColor Yellow
Write-Host '(contiene: RISULTATI_BREAKOUT_CORSO.csv + cartella serie + cartella report; Esplora file si apre con lo zip selezionato)' -ForegroundColor Black -BackgroundColor Yellow
try { Start-Process -FilePath 'explorer.exe' -ArgumentList ('/select,"' + $zip + '"') } catch { }
