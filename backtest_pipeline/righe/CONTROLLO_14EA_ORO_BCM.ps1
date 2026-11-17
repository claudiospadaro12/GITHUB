# MARCATORE_CONTROLLO_14EA_ORO_BCM_v1
# TEST FUORI CAMPIONE dei 4 EA su ORO tra i 14 "Ottimizzati" (SupertrendReversal_Multi, SupertrendReversal, EMA200, GoldenCross): parametri = default dei sorgenti nel repository (nessuna ottimizzazione), XAUUSD, Modello 1, deposito 100000 EUR, rischio % degli EA (composto). Criteri: report/CLAU12_14_EA_OTTIMIZZATI_FUORI_CAMPIONE_CRITERI_2026-11-18.md (scritti PRIMA dei numeri). Finestre: 2015-2023 (porte P1-P5) e 2005-2014 (informativa). Terminale BCM PORTABILE C:\MT5_BCM_Opt (storico oro dal 2004). Il tester NON invia ordini. I 4 EA vengono copiati in MQL5\Experts\TEST14 (nessun file esistente viene sovrascritto). Scrive in quella cartella, in %TEMP% e sul Desktop. Non tocca conti, VPS, altri terminali. Non chiude MT5 con la forza.
$ErrorActionPreference='Continue'
$ci=[Globalization.CultureInfo]::InvariantCulture
if($env:COMPUTERNAME -ne 'DESKTOP-H4D7CAJ'){ Write-Host ('SOLO sul PC di backtest DESKTOP-H4D7CAJ. Qui: ' + $env:COMPUTERNAME) -ForegroundColor Red; return }
$ROOT='C:\MT5_BCM_Opt'; $TRM=Join-Path $ROOT 'terminal64.exe'; $MEE=Join-Path $ROOT 'metaeditor64.exe'; $MQL5=Join-Path $ROOT 'MQL5'
$PINSRC='54c0df49449f12d0b93995e0835d88f8d65eae26'
$aperti=@(Get-Process -Name terminal64,metatester64,metaeditor64 -ErrorAction SilentlyContinue)
if($aperti.Count -gt 0){ $aperti | Select-Object Id,ProcessName,Path | Format-Table -AutoSize | Out-String | Write-Host; Write-Host 'MI FERMO: MT5, MetaEditor o agenti aperti. Chiudili e rilancia. Non ho avviato niente.' -ForegroundColor Red; return }
foreach($pp in @($TRM,$MEE,$MQL5)){ if(-not (Test-Path -LiteralPath $pp)){ Write-Host ('MI FERMO: non trovo ' + $pp) -ForegroundColor Red; return } }
$EAS=@(
  @{ n='ABTG_SupertrendReversal_Multi_Ottimizzato'; per='H4'; sha='1057D5E142B2F7C3325E3F040EA45C6E74FA5484F36E09CD6468DB2AD3358E19'; inp=@(
      'InpTF=16388',
      'InpStMult=2.5',
      'InpStAtrPeriod=12',
      'InpNearAtr=1.0',
      'InpRequireConfirmBody=true',
      'InpAllowLong=true',
      'InpAllowShort=true',
      'InpUseConfluence=true',
      'InpEma1=14',
      'InpEma2=89',
      'InpEma3=100',
      'InpEma4=200',
      'InpConflAtr=1.5',
      'InpFirstFraction=0.3333',
      'InpUsePending=true',
      'InpPendingAtr=0.5',
      'InpPendingExpiryBars=3',
      'InpSLLookback=5',
      'InpSLBufferAtr=0.2',
      'InpTP1_R=1.0',
      'InpTP1Pct=50',
      'InpBreakeven=true',
      'InpTP_RR=3.0',
      'InpTrailOnST=true',
      'InpExitOnFlip=true',
      'InpRiskPercent=2.0',
      'InpMaxTradesPerDay=0',
      'InpUseTimeWindow=false',
      'InpStartHour=0',
      'InpEndHour=24',
      'InpUseNewsFilter=false',
      'InpNewsFile=abtg_news.csv',
      'InpNewsMinImpact=3',
      'InpNewsBeforeMin=30',
      'InpNewsAfterMin=30',
      'InpNewsShiftMinutes=0',
      'InpNewsCurrencies=',
      'InpComment=STREV MULTI OTT',
      'InpMagic=971001',
      'InpMaxSpread=0',
      'InpVerbose=true'
  ) },
  @{ n='ABTG_SupertrendReversal_Ottimizzato'; per='H4'; sha='B2EDED79FDFD501266175B557D4BCBAE3EA88E91E825E53B5CACD551CCE21119'; inp=@(
      'InpTF=16388',
      'InpStMult=2.5',
      'InpStAtrPeriod=7',
      'InpNearAtr=1.0',
      'InpRequireConfirmBody=true',
      'InpAllowLong=true',
      'InpAllowShort=true',
      'InpUseConfluence=true',
      'InpEma1=14',
      'InpEma2=89',
      'InpEma3=100',
      'InpEma4=200',
      'InpConflAtr=1.5',
      'InpFirstFraction=0.3333',
      'InpUsePending=true',
      'InpPendingPips=20',
      'InpPendingExpiryBars=3',
      'InpSLLookback=5',
      'InpSLBufferPips=3',
      'InpTP1_R=1.0',
      'InpTP1Pct=50',
      'InpBreakeven=true',
      'InpTP_RR=2.5',
      'InpTrailOnST=true',
      'InpExitOnFlip=true',
      'InpRiskPercent=2.0',
      'InpMaxTradesPerDay=0',
      'InpUseTimeWindow=false',
      'InpStartHour=0',
      'InpEndHour=24',
      'InpUseNewsFilter=false',
      'InpNewsFile=abtg_news.csv',
      'InpNewsMinImpact=3',
      'InpNewsBeforeMin=30',
      'InpNewsAfterMin=30',
      'InpNewsShiftMinutes=0',
      'InpNewsCurrencies=',
      'InpComment=STREV OTT',
      'InpMagic=970901',
      'InpMaxSpread=0',
      'InpVerbose=true'
  ) },
  @{ n='ABTG_EMA200_Ottimizzato'; per='H4'; sha='F6D613A47CF957C2BB3700199BA283561852D25C0E00A0247706B88C56AB07EE'; inp=@(
      'InpTF=16388',
      'InpEmaPeriod=200',
      'InpEma14Period=14',
      'InpAtrPeriod=14',
      'InpMinDistAtr=0.3',
      'InpMaxDistAtr=1.5',
      'InpUseEma14Bias=true',
      'InpAllowLong=true',
      'InpAllowShort=true',
      'InpUseAdrFilter=false',
      'InpAdrDays=50',
      'InpAdrDistMin=0.0',
      'InpAdrDistMax=0.8',
      'InpOrder1Atr=0.05',
      'InpOrder2Atr=0.60',
      'InpUseOrder2=true',
      'InpPendingExpiryBars=6',
      'InpSLatr=1.0',
      'InpMinRR=1.0',
      'InpTP_RR=2.0',
      'InpTP1_ATRmult=0.0',
      'InpTP1Pct=50',
      'InpBreakeven=true',
      'InpUseTrailing=true',
      'InpUseCutoff=false',
      'InpCutoffHour=19',
      'InpCutoffMin=0',
      'InpRiskPercent=1.0',
      'InpMaxTradesPerDay=0',
      'InpUseNewsFilter=false',
      'InpNewsFile=abtg_news.csv',
      'InpNewsMinImpact=3',
      'InpNewsBeforeMin=60',
      'InpNewsAfterMin=30',
      'InpNewsShiftMinutes=0',
      'InpNewsCurrencies=',
      'InpComment=EMA200 OTT',
      'InpFridayClose=false',
      'InpFridayCloseHour=20',
      'InpMagic=971501',
      'InpMaxSpread=0',
      'InpVerbose=true'
  ) },
  @{ n='ABTG_GoldenCross_Ottimizzato'; per='H1'; sha='800B865D2FA4A8F9447D3427442F884AAFB633BB91C537FF8AA0572A8A602110'; inp=@(
      'InpTimeframe=16385',
      'InpEmaFast=9',
      'InpEmaMid=21',
      'InpEmaSlow=50',
      'InpEmaSlopeBars=3',
      'InpRequireAlignment=true',
      'InpCrossLookback=8',
      'InpHACount=3',
      'InpHAWickRatio=0.30',
      'InpHABodyFactor=0.60',
      'InpAdxPeriod=14',
      'InpAdxMin=15.0',
      'InpAdxRising=true',
      'InpRequireDI=true',
      'InpMaxDistATR=1.5',
      'InpMinRR=1.0',
      'InpEntryMode=0',
      'InpPullbackRef=0',
      'InpPendingExpiryBars=3',
      'InpAllowLong=true',
      'InpAllowShort=true',
      'InpSLMode=0',
      'InpSwingLookback=10',
      'InpAtrPeriod=14',
      'InpAtrSLmult=1.0',
      'InpSLBufferPts=0',
      'InpTP_R=3.0',
      'InpPartialR=1.0',
      'InpPartialPct=50',
      'InpBreakeven=true',
      'InpTrailMode=0',
      'InpTrailAtrMult=2.0',
      'InpExitOnCross=true',
      'InpExitOnHAflip=false',
      'InpRiskPercent=1.0',
      'InpMaxTradesPerDay=2',
      'InpStopAfterLosses=2',
      'InpUseNewsFilter=false',
      'InpNewsFile=abtg_news.csv',
      'InpNewsMinImpact=3',
      'InpNewsBeforeMin=30',
      'InpNewsAfterMin=30',
      'InpNewsShiftMinutes=0',
      'InpNewsCurrencies=USD',
      'InpComment=GOLDENCROSS OTT',
      'InpFridayClose=false',
      'InpFridayCloseHour=20',
      'InpMagic=970301',
      'InpMaxSpread=0',
      'InpVerbose=true'
  ) }
)
function Num([string]$s){ $c=($s -replace '[^0-9.\-]',''); $v=0.0; if([double]::TryParse($c,[Globalization.NumberStyles]::Float,$ci,[ref]$v)){ return $v } else { return [double]::NaN } }
function Cerca([string]$t,[string]$et){ $m=[regex]::Match($t,'(?:' + $et + ')\|([^|]*)\|'); if($m.Success){ return $m.Groups[1].Value } else { return $null } }
function LeggiTesto([string]$p){ $b=[IO.File]::ReadAllBytes($p); if($b.Length -ge 2 -and (($b[0] -eq 255 -and $b[1] -eq 254) -or ($b[0] -eq 254 -and $b[1] -eq 255))){ return [Text.Encoding]::Unicode.GetString($b) } else { return [Text.Encoding]::UTF8.GetString($b) } }
$W=Join-Path $env:TEMP 'controllo_14ea_oro'; New-Item -ItemType Directory -Force -Path $W | Out-Null
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
$desk=[Environment]::GetFolderPath('Desktop'); $dirOut=Join-Path $desk 'CONTROLLO_14EA_ORO'; $dirSerie=Join-Path $dirOut 'serie'; $dirRep=Join-Path $dirOut 'report'
New-Item -ItemType Directory -Force -Path $dirSerie | Out-Null; New-Item -ItemType Directory -Force -Path $dirRep | Out-Null
$FIN=@( @{ n='W2015_2023'; da='2015.01.01'; a='2023.12.31' }, @{ n='W2005_2014'; da='2005.01.01'; a='2014.12.31' } )
$righe=New-Object System.Collections.ArrayList
[void]$righe.Add('ea;finestra;operazioni;rend_totale_pct;PF_su_rendimenti;t_giornaliera;DD_equity_pct;anni_con_uscite;anni_positivi;quota_max_anno_pct;netto_tester_EUR;PF_tester;rendimento_per_anno_pct')
Write-Host ('=== TEST 4 EA ORO su BCM portabile: ' + ($EAS.Count * $FIN.Count) + ' passate, Modello 1. Avvio ' + (Get-Date).ToString('dd/MM/yyyy HH:mm') + ' (ora italiana). Durata attesa 15-60 minuti (STIMA). Non aprire MT5; PC alla corrente. ===') -ForegroundColor Cyan
$n=0; $stopTutto=$false
foreach($f in $FIN){
 foreach($ea in $EAS){
  if($stopTutto){ break }
  $n=$n+1; $rep='T14_' + $ea.n.Replace('ABTG_','').Replace('_Ottimizzato','') + '_' + $f.n
  $r=@('[Experts]','AllowLiveTrading=false','AllowDllImport=false','','[Tester]',('Expert=TEST14\' + $ea.n + '.ex5'),'Symbol=XAUUSD',('Period=' + $ea.per),'Model=1','Optimization=0',('FromDate=' + $f.da),('ToDate=' + $f.a),'ForwardMode=0','Deposit=100000','Currency=EUR','Leverage=100','ExecutionMode=0','Visual=0','ReplaceReport=1','ShutdownTerminal=1',('Report=' + $rep),'','[TesterInputs]'); $r += $ea.inp
  $ini=Join-Path $W ($rep + '.ini'); Set-Content -LiteralPath $ini -Value (($r -join "`r`n") + "`r`n") -Encoding ASCII -NoNewline
  $rf=Join-Path $ROOT ($rep + '.htm'); Remove-Item -LiteralPath $rf -Force -ErrorAction SilentlyContinue
  $t0=Get-Date; $pr=Start-Process -FilePath $TRM -ArgumentList ('/portable /config:"' + $ini + '"') -PassThru
  $scade=$t0.AddMinutes(60); while(-not $pr.HasExited -and (Get-Date) -lt $scade){ Start-Sleep -Seconds 4 }
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
$fileCsv=Join-Path $dirOut 'RISULTATI_CONTROLLO_14EA_ORO.csv'; Set-Content -LiteralPath $fileCsv -Value ($righe -join "`r`n") -Encoding UTF8
$zip=Join-Path $desk 'CONTROLLO_14EA_ORO.zip'; Remove-Item -LiteralPath $zip -Force -ErrorAction SilentlyContinue
try { Compress-Archive -Path (Join-Path $dirOut '*') -DestinationPath $zip -Force } catch { Write-Host 'ZIP non creato: allega la cartella a mano.' -ForegroundColor Red }
Write-Host ('FATTO alle ' + (Get-Date).ToString('dd/MM/yyyy HH:mm') + ' (ora italiana).') -ForegroundColor Green
Write-Host ''
Write-Host '##########  FILE DA ALLEGARE ALLA CHAT  ##########' -ForegroundColor Black -BackgroundColor Yellow
Write-Host $zip -ForegroundColor Black -BackgroundColor Yellow
Write-Host '(contiene: RISULTATI_CONTROLLO_14EA_ORO.csv + cartella serie + cartella report; Esplora file si apre con lo zip selezionato)' -ForegroundColor Black -BackgroundColor Yellow
try { Start-Process -FilePath 'explorer.exe' -ArgumentList ('/select,"' + $zip + '"') } catch { }
