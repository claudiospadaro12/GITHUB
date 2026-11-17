# MARCATORE_BATCH36_DISEGNI_FTMO_v1
# BATCH dei 36 set dei disegni 1 (breakout a stop stretti, pendenti persistenti) e 2 (rimbalzo ai livelli) - criteri CLAU12_ORO_DISEGNI_2_E_3_CRITERI (sezioni 2-4, scritti PRIMA dei numeri), P2 superata il 17/11 sera. Terminale FTMO di prova, XAUUSD, dentro-campione 2015-01-01 -> 2020-12-31, Modello 1, 0,1 lotti, template 1.03 compilato qui. 2 disegni x 2 timeframe (D1, H4) x 9 righe L9.
# Per ogni set: PF del tester, risultato NETTO (meno 3,6 EUR a operazione), PF netto, statistica t per giornata con uscite, recovery, DD; verdetto G1: netto > 0, PF netto >= 1,30, operazioni >= 100, recovery >= 1,5, t >= 3,3 (soglia alzata per il numero di set guardati). Salva le serie giornaliere. Il tester NON invia ordini. Non chiude MT5 con la forza.
$ErrorActionPreference='Continue'
$ci=[Globalization.CultureInfo]::InvariantCulture
if($env:COMPUTERNAME -ne 'DESKTOP-H4D7CAJ'){ Write-Host ('SOLO sul PC di backtest DESKTOP-H4D7CAJ. Qui: ' + $env:COMPUTERNAME) -ForegroundColor Red; return }
$FT='C:\MT5_Backtest\Mt5_Ftmo_Prova'; $TRM=Join-Path $FT 'terminal64.exe'; $MEE=Join-Path $FT 'metaeditor64.exe'
$DATI=$null; $baseT=Join-Path $env:APPDATA 'MetaQuotes\Terminal'
foreach($o in @(Get-ChildItem -LiteralPath $baseT -Directory -ErrorAction SilentlyContinue)){ $of=Join-Path $o.FullName 'origin.txt'; if(Test-Path -LiteralPath $of){ $c0=((Get-Content -LiteralPath $of -Raw -Encoding Unicode) -replace '[\r\n\0]','').Trim(); if($c0 -eq $FT){ $DATI=$o.FullName } } }
if(-not $DATI){ Write-Host 'MI FERMO: non trovo la cartella dati di Mt5_Ftmo_Prova.' -ForegroundColor Red; return }
$MQL5=Join-Path $DATI 'MQL5'
$fci=Join-Path $DATI 'config\common.ini'
if(Test-Path -LiteralPath $fci){ $bci=[IO.File]::ReadAllBytes($fci); $tci=$(if($bci.Length -ge 2 -and $bci[0] -eq 255 -and $bci[1] -eq 254){ [Text.Encoding]::Unicode.GetString($bci) } else { [Text.Encoding]::UTF8.GetString($bci) }); $lg=[regex]::Match($tci,'(?m)^Login=(\d+)'); $sv=[regex]::Match($tci,'(?m)^Server=(.*)$'); if($lg.Success){ $ln=$lg.Groups[1].Value; Write-Host ('Terminale FTMO di prova: server ' + $sv.Groups[1].Value.Trim() + ', login ' + $ln.Substring(0,3) + '...' + $ln.Substring($ln.Length-2) + ' (conto Free Trial scaduto il 16/11: il tester non invia ordini)') -ForegroundColor Cyan } }
$aperti=@(Get-Process -Name terminal64,metatester64,metaeditor64 -ErrorAction SilentlyContinue)
if($aperti.Count -gt 0){ $aperti | Select-Object Id,ProcessName,Path | Format-Table -AutoSize | Out-String | Write-Host; Write-Host 'MI FERMO: MT5, MetaEditor o agenti aperti. Chiudili e rilancia. Non ho avviato niente.' -ForegroundColor Red; return }
foreach($pp in @($TRM,$MEE)){ if(-not (Test-Path -LiteralPath $pp)){ Write-Host ('MI FERMO: non trovo ' + $pp) -ForegroundColor Red; return } }
# 1) sorgente dal repository, con controllo SHA256
$PIN1='20871d76f68564f6905c86a21bfdce1fb4b0176a'; $SHAT='3EBCE7A6915031A7EF65077D7CCDBF4C15F0B170B7DFA030AC5851ADCA024A6C'
$srcTmp=Join-Path $env:TEMP 'Template_EA_Wim_v103_batch.mq5'; Remove-Item -LiteralPath $srcTmp -Force -ErrorAction SilentlyContinue
irm ('https://raw.githubusercontent.com/claudiospadaro12/GITHUB/' + $PIN1 + '/backtest_runner/Template_EA_Wim.mq5?cb=' + [Guid]::NewGuid().ToString('N')) -OutFile $srcTmp
$HT=(Get-FileHash -LiteralPath $srcTmp -Algorithm SHA256).Hash.ToUpperInvariant()
if($HT -ne $SHAT){ Write-Host ('MI FERMO: SHA256 del sorgente diverso: ' + $HT) -ForegroundColor Red; return }
# 2) compilazione
$dstDir=Join-Path $MQL5 'Experts\CLAU12'; New-Item -ItemType Directory -Force -Path $dstDir | Out-Null
$dst=Join-Path $dstDir 'Template_EA_Wim.mq5'; Copy-Item -LiteralPath $srcTmp -Destination $dst -Force
$logc=Join-Path $env:TEMP 'compila_b36.log'; Remove-Item -LiteralPath $logc -Force -ErrorAction SilentlyContinue
$ex5=[IO.Path]::ChangeExtension($dst,'.ex5'); Remove-Item -LiteralPath $ex5 -Force -ErrorAction SilentlyContinue
[void](Start-Process -FilePath $MEE -ArgumentList ('/compile:"' + $dst + '" /include:"' + $MQL5 + '" /log:"' + $logc + '"') -PassThru -Wait)
if(-not (Test-Path -LiteralPath $logc)){ Write-Host 'Nessun log di compilazione.' -ForegroundColor Red; return }
$bc=[IO.File]::ReadAllBytes($logc); $txc=$(if($bc.Length -ge 2 -and $bc[0] -eq 255 -and $bc[1] -eq 254){ [Text.Encoding]::Unicode.GetString($bc) } else { [Text.Encoding]::UTF8.GetString($bc) })
if(-not ((Test-Path -LiteralPath $ex5) -and ($txc -match 'Result:\s*0 errors'))){ Write-Host 'COMPILAZIONE NON RIUSCITA: incollami queste righe.' -ForegroundColor Red; ($txc -split "`r?`n" | Where-Object { $_ -match 'error' }) | ForEach-Object { Write-Host ('   ' + $_) }; return }
Write-Host ('COMPILATO v1.03: ' + $ex5) -ForegroundColor Green
# 3) batch
if(-not ('SvegliaB36.Win' -as [type])){ Add-Type -Namespace SvegliaB36 -Name Win -MemberDefinition '[DllImport("kernel32.dll")] public static extern uint SetThreadExecutionState(uint esFlags);' }
[void][SvegliaB36.Win]::SetThreadExecutionState([uint32]2147483651)
$BASE=@(
  'InpMagic=880001',
  'InpComment=TPL_WIM',
  'InpRearm=false',
  'InpDebug=false',
  'InpLevelTF=16408',
  'InpCountback=10',
  'InpUsePivots=false',
  'InpHLStrengthL=3',
  'InpHLStrengthR=2',
  'InpMinDistLevelAtr=0.2',
  'InpOffsetAtr=0.1',
  'InpEntryMode=0',
  'InpExpirationBars=5',
  'InpRetestMaxBars=6',
  'InpRetestTolAtr=0.15',
  'InpSLMode=1',
  'InpSLAtr=1.0',
  'InpSLPts=400',
  'InpTPMode=2',
  'InpTP_RR=1.0',
  'InpTPAtr=3.0',
  'InpTPPts=1200',
  'InpUseBE=false',
  'InpBEStartR=1.0',
  'InpBEExtraPts=20',
  'InpUseTrail=false',
  'InpTrailStartR=1.5',
  'InpTrailAtr=1.0',
  'InpFixedLot=true',
  'InpLot=0.1',
  'InpRiskPct=1.0',
  'InpMaxDailyLossPct=0.0',
  'InpMaxTotalDDPct=0.0',
  'InpCloseOnBreach=false',
  'InpMaxTradesPerDay=1',
  'InpMaxOpenPos=1',
  'InpATRPeriod=14',
  'InpATRTF=16408',
  'InpMaxSpreadPts=0',
  'InpUseSession=false',
  'InpSessionStartHour=7',
  'InpSessionEndHour=21',
  'InpUseEmaFilter=false',
  'InpEmaPeriod=200',
  'InpEmaTF=16385'
)
function Valori($ov){
  $o=@()
  foreach($b in $BASE){
    $nm=$b.Split('=')[0]
    if($ov.ContainsKey($nm)){ $o += ($nm + '=' + $ov[$nm]) } else { $o += $b }
  }
  return $o
}
function Num([string]$s){ $c=($s -replace '[^0-9.\-]',''); $v=0.0; if([double]::TryParse($c,[Globalization.NumberStyles]::Float,$ci,[ref]$v)){ return $v } else { return [double]::NaN } }
function Cerca([string]$t,[string]$et){ $m=[regex]::Match($t,'(?:' + $et + ')\|([^|]*)\|'); if($m.Success){ return $m.Groups[1].Value } else { return $null } }
$W=Join-Path $env:TEMP 'batch36_disegni'; New-Item -ItemType Directory -Force -Path $W | Out-Null
$desk=[Environment]::GetFolderPath('Desktop'); $dirOut=Join-Path $desk 'BREAKOUT_BATCH36_FTMO'; $dirSerie=Join-Path $dirOut 'serie'; New-Item -ItemType Directory -Force -Path $dirSerie | Out-Null
$L9=@( @(0,0,0,0), @(0,1,1,1), @(0,2,2,2), @(1,0,1,2), @(1,1,2,0), @(1,2,0,1), @(2,0,2,1), @(2,1,0,2), @(2,2,1,0) )
$TFS=@( @{ n='D1'; id=16408; cb=@(10,20,40); ex1=@(5,10,20); ex2=@(1,3,6) }, @{ n='H4'; id=16388; cb=@(30,60,120); ex1=@(30,60,120); ex2=@(6,18,36) } )
$STP1=@(400,600,800); $TGT1=@(1200,1700,2400); $STA2=@(1.0,1.5,2.5); $RR2=@(1.0,1.5,2.0)
$COSTO=3.6
$righe=New-Object System.Collections.ArrayList
[void]$righe.Add('id;disegno;tf;fattoriL9;operazioni;profitto_tester;profitto_netto;PF_tester;PF_netto;DD_eur;recovery;t_giornaliera;G1;motivi')
Write-Host ('=== BATCH 36 SET su FTMO, IS 2015-2020, Modello 1. Avvio ' + (Get-Date).ToString('dd/MM/yyyy HH:mm') + ' (ora italiana). Durata attesa 60-180 minuti (STIMA). Non aprire altri MT5; PC alla corrente. ===') -ForegroundColor Cyan
$n=0; $stopTutto=$false
foreach($dis in @(1,2)){
 foreach($tfo in $TFS){
  if($stopTutto){ break }
  for($ri=0; $ri -lt 9; $ri++){
    if($stopTutto){ break }
    $n=$n+1; $rw=$L9[$ri]
    $ov=@{ 'InpLevelTF'=$tfo.id; 'InpATRTF'=$tfo.id }
    if($dis -eq 1){
      $ov['InpEntryMode']=0; $ov['InpSLMode']=1; $ov['InpTPMode']=2; $ov['InpRearm']='false'
      $ov['InpSLPts']=$STP1[$rw[0]]; $ov['InpTPPts']=$TGT1[$rw[1]]; $ov['InpCountback']=$tfo.cb[$rw[2]]; $ov['InpExpirationBars']=$tfo.ex1[$rw[3]]
      $fat=('stop ' + $STP1[$rw[0]] + 'pt target ' + $TGT1[$rw[1]] + 'pt cb ' + $tfo.cb[$rw[2]] + ' scad ' + $tfo.ex1[$rw[3]])
    } else {
      $ov['InpEntryMode']=2; $ov['InpSLMode']=0; $ov['InpTPMode']=0; $ov['InpRearm']='true'
      $ov['InpCountback']=$tfo.cb[$rw[0]]; $ov['InpSLAtr']=$STA2[$rw[1]].ToString('0.0',$ci); $ov['InpTP_RR']=$RR2[$rw[2]].ToString('0.0',$ci); $ov['InpExpirationBars']=$tfo.ex2[$rw[3]]
      $fat=('cb ' + $tfo.cb[$rw[0]] + ' stop ' + $STA2[$rw[1]].ToString('0.0',$ci) + 'ATR target ' + $RR2[$rw[2]].ToString('0.0',$ci) + 'R scad ' + $tfo.ex2[$rw[3]])
    }
    $id='D' + $dis + '_' + $tfo.n + '_R' + ($ri+1)
    $rep='BATCH36_' + $id
    $r=@('[Experts]','AllowLiveTrading=false','AllowDllImport=false','','[Tester]','Expert=CLAU12\Template_EA_Wim.ex5','Symbol=XAUUSD','Period=D1','Model=1','Optimization=0','FromDate=2015.01.01','ToDate=2020.12.31','ForwardMode=0','Deposit=100000','Currency=EUR','Leverage=100','ExecutionMode=0','Visual=0','ReplaceReport=1','ShutdownTerminal=1',('Report=' + $rep),'','[TesterInputs]'); $r += (Valori $ov)
    $ini=Join-Path $W ($rep + '.ini'); Set-Content -LiteralPath $ini -Value (($r -join "`r`n") + "`r`n") -Encoding ASCII -NoNewline
    $rf=Join-Path $DATI ($rep + '.htm'); Remove-Item -LiteralPath $rf -Force -ErrorAction SilentlyContinue
    $t0=Get-Date; $pr=Start-Process -FilePath $TRM -ArgumentList ('/config:"' + $ini + '"') -PassThru
    $scade=$t0.AddMinutes(40); while(-not $pr.HasExited -and (Get-Date) -lt $scade){ Start-Sleep -Seconds 4 }
    if(-not $pr.HasExited){ Write-Host ('TIMEOUT sul set ' + $id + ': il terminale e ancora aperto. Non lo chiudo io: mi fermo qui.') -ForegroundColor Red; $stopTutto=$true; break }
    if(-not (Test-Path -LiteralPath $rf)){ [void]$righe.Add($id + ';' + $dis + ';' + $tfo.n + ';' + $fat + ';ERRORE;;;;;;;;;NO;report non trovato'); Write-Host ('[' + $n + '/36] ' + $id + ': report non trovato') -ForegroundColor Red; continue }
    $b=[IO.File]::ReadAllBytes($rf); $html=$(if($b.Length -ge 2 -and (($b[0] -eq 255 -and $b[1] -eq 254) -or ($b[0] -eq 254 -and $b[1] -eq 255))){ [Text.Encoding]::Unicode.GetString($b) } else { [Text.Encoding]::UTF8.GetString($b) })
    $tx=[regex]::Replace($html,'<[^>]*>','|'); $tx=[regex]::Replace($tx,'\s*\|[\s|]*','|')
    $pT=Num (Cerca $tx 'Profitto Totale Netto:|Total Net Profit:'); $pfT=Num (Cerca $tx 'Fattore di Profitto:|Profit Factor:'); $nT=Num (Cerca $tx 'Numero di Operazioni di Trading Totali:|Total Trades:'); $rfT=Num (Cerca $tx 'Fattore di Recupero:|Recovery Factor:')
    $ddS=Cerca $tx 'Drawdown Massima:|Equity Drawdown Maximal:'; $ddE=[double]::NaN; if($ddS){ $mm=[regex]::Match($ddS,'([0-9\s.,]+)\s*\('); if($mm.Success){ $ddE=Num $mm.Groups[1].Value } }
    $giorni=@{}; $nets=@(); $inDeals=$false; $iPr=-1; $iCo=-1; $iSw=-1; $iDi=-1
    foreach($rg in [regex]::Split($html,'(?i)<tr')){
      $celle=@(); foreach($mc in [regex]::Matches($rg,'(?is)<t[dh][^>]*>(.*?)</t[dh]>')){ $celle += (([regex]::Replace($mc.Groups[1].Value,'<[^>]*>','') -replace '&nbsp;',' ' -replace '\s+',' ').Trim()) }
      if($celle.Count -lt 8){ continue }
      $p1=-1; $c1=-1; $s1=-1; $d1=-1
      for($i=0; $i -lt $celle.Count; $i++){ if($celle[$i] -match '^(Profit|Profitto|Utile)$'){ $p1=$i } elseif($celle[$i] -match '^(Commission|Commissione|Commissioni)$'){ $c1=$i } elseif($celle[$i] -match '^Swap$'){ $s1=$i } elseif($celle[$i] -match '^(Direction|Direzione)$'){ $d1=$i } }
      if($p1 -ge 0 -and $c1 -ge 0 -and $s1 -ge 0){ $inDeals=$true; $iPr=$p1; $iCo=$c1; $iSw=$s1; $iDi=$d1; continue }
      if(-not $inDeals -or $iDi -lt 0){ continue }
      if($celle[0] -notmatch '^(\d{4})\.(\d{2})\.(\d{2}) \d{2}:\d{2}:\d{2}$'){ continue }
      if($celle.Count -le $iPr){ continue }
      if($celle[$iDi] -ne 'out'){ continue }
      $netd=(Num $celle[$iPr]) + (Num $celle[$iCo]) + (Num $celle[$iSw]) - $COSTO
      $nets += $netd; $kd=$celle[0].Substring(0,10)
      if($giorni.ContainsKey($kd)){ $giorni[$kd]=$giorni[$kd] + $netd } else { $giorni[$kd]=$netd }
    }
    $gp=0.0; $gl=0.0; foreach($x in $nets){ if($x -gt 0){ $gp=$gp+$x } else { $gl=$gl-$x } }
    $netTot=$gp-$gl; $pfN=$(if($gl -gt 0){ $gp/$gl } else { [double]::PositiveInfinity })
    $vals=@($giorni.Values); $nd=$vals.Count; $tst=[double]::NaN
    if($nd -ge 2){ $mu=($vals | Measure-Object -Average).Average; $ss=0.0; foreach($x in $vals){ $ss=$ss + ($x-$mu)*($x-$mu) }; $sd=[math]::Sqrt($ss/($nd-1)); if($sd -gt 0){ $tst=$mu/($sd/[math]::Sqrt($nd)) } }
    $lin=@('data;profitto_netto'); foreach($k in ($giorni.Keys | Sort-Object)){ $lin += ($k + ';' + $giorni[$k].ToString('0.00',$ci)) }
    Set-Content -LiteralPath (Join-Path $dirSerie ($id + '.csv')) -Value $lin -Encoding ASCII
    $mot=@()
    if(-not ($netTot -gt 0)){ $mot += 'netto<=0' }
    if(-not ($pfN -ge 1.30)){ $mot += 'PF netto<1,30' }
    if(-not ($nT -ge 100)){ $mot += 'operazioni<100' }
    if(-not ($rfT -ge 1.5)){ $mot += 'recovery<1,5' }
    if(-not ($tst -ge 3.3)){ $mot += 't<3,3' }
    $g1=$(if($mot.Count -eq 0){ 'OK' } else { 'NO' })
    $riga=($id + ';' + $dis + ';' + $tfo.n + ';' + $fat + ';' + $nT + ';' + $pT.ToString('0.00',$ci) + ';' + $netTot.ToString('0.00',$ci) + ';' + $pfT.ToString('0.00',$ci) + ';' + $pfN.ToString('0.00',$ci) + ';' + $ddE.ToString('0.0',$ci) + ';' + $rfT.ToString('0.00',$ci) + ';' + $tst.ToString('0.00',$ci) + ';' + $g1 + ';' + ($mot -join ' | '))
    [void]$righe.Add($riga)
    Write-Host ('[' + (Get-Date).ToString('HH:mm') + ' ' + $n + '/36] ' + $id + ' ops ' + $nT + ' netto ' + $netTot.ToString('0',$ci) + ' PFnetto ' + $pfN.ToString('0.00',$ci) + ' t ' + $tst.ToString('0.0',$ci) + ' G1 ' + $g1) -ForegroundColor $(if($g1 -eq 'OK'){ 'Green' } else { 'Gray' })
  }
 }
}
[void][SvegliaB36.Win]::SetThreadExecutionState([uint32]2147483648)
$fileCsv=Join-Path $dirOut 'RISULTATI_BATCH36_DISEGNI_FTMO.csv'; Set-Content -LiteralPath $fileCsv -Value ($righe -join "`r`n") -Encoding UTF8
try { Set-Clipboard -Value ($righe -join "`r`n") } catch { }
Write-Host ('FATTO alle ' + (Get-Date).ToString('dd/MM/yyyy HH:mm') + ' (ora italiana). File: ' + $fileCsv + ' (e le serie giornaliere in ' + $dirSerie + '). Allega il CSV alla chat.') -ForegroundColor Green
