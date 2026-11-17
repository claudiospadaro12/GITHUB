# MARCATORE_FINALISTI_G2G4_FTMO_v1
# Verifiche dei 3 finalisti del disegno 2 (rimbalzo ai livelli, H4) usciti dal batch dei 36 set (G1 superata): D2_H4_R1, D2_H4_R2, D2_H4_R4. Criteri CLAU12_ORO_DISEGNI_2_E_3_CRITERI sezioni 4 e 6, scritti PRIMA dei numeri. Terminale FTMO di prova, XAUUSD, Modello 1, 0,1 lotti, template 1.03.
# Per ogni finalista: G3 (due meta del dentro-campione: 2015-2017 e 2018-2020) e G4 (fuori-campione 2021-2022 e 2023-2024) = 12 passate; G2 (vicini a un passo, un fattore alla volta, sul dentro-campione 2015-2020) = fino a 17 passate. Stampa i numeri: i verdetti li do io con le soglie scritte. Il tester NON invia ordini. Non chiude MT5 con la forza.
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
$srcTmp=Join-Path $env:TEMP 'Template_EA_Wim_v103_fin.mq5'; Remove-Item -LiteralPath $srcTmp -Force -ErrorAction SilentlyContinue
irm ('https://raw.githubusercontent.com/claudiospadaro12/GITHUB/' + $PIN1 + '/backtest_runner/Template_EA_Wim.mq5?cb=' + [Guid]::NewGuid().ToString('N')) -OutFile $srcTmp
$HT=(Get-FileHash -LiteralPath $srcTmp -Algorithm SHA256).Hash.ToUpperInvariant()
if($HT -ne $SHAT){ Write-Host ('MI FERMO: SHA256 del sorgente diverso: ' + $HT) -ForegroundColor Red; return }
# 2) compilazione
$dstDir=Join-Path $MQL5 'Experts\CLAU12'; New-Item -ItemType Directory -Force -Path $dstDir | Out-Null
$dst=Join-Path $dstDir 'Template_EA_Wim.mq5'; Copy-Item -LiteralPath $srcTmp -Destination $dst -Force
$logc=Join-Path $env:TEMP 'compila_fin.log'; Remove-Item -LiteralPath $logc -Force -ErrorAction SilentlyContinue
$ex5=[IO.Path]::ChangeExtension($dst,'.ex5'); Remove-Item -LiteralPath $ex5 -Force -ErrorAction SilentlyContinue
[void](Start-Process -FilePath $MEE -ArgumentList ('/compile:"' + $dst + '" /include:"' + $MQL5 + '" /log:"' + $logc + '"') -PassThru -Wait)
if(-not (Test-Path -LiteralPath $logc)){ Write-Host 'Nessun log di compilazione.' -ForegroundColor Red; return }
$bc=[IO.File]::ReadAllBytes($logc); $txc=$(if($bc.Length -ge 2 -and $bc[0] -eq 255 -and $bc[1] -eq 254){ [Text.Encoding]::Unicode.GetString($bc) } else { [Text.Encoding]::UTF8.GetString($bc) })
if(-not ((Test-Path -LiteralPath $ex5) -and ($txc -match 'Result:\s*0 errors'))){ Write-Host 'COMPILAZIONE NON RIUSCITA: incollami queste righe.' -ForegroundColor Red; ($txc -split "`r?`n" | Where-Object { $_ -match 'error' }) | ForEach-Object { Write-Host ('   ' + $_) }; return }
Write-Host ('COMPILATO v1.03: ' + $ex5) -ForegroundColor Green
# 3) verifiche
if(-not ('SvegliaFin.Win' -as [type])){ Add-Type -Namespace SvegliaFin -Name Win -MemberDefinition '[DllImport("kernel32.dll")] public static extern uint SetThreadExecutionState(uint esFlags);' }
[void][SvegliaFin.Win]::SetThreadExecutionState([uint32]2147483651)
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
$W=Join-Path $env:TEMP 'finalisti_g2g4'; New-Item -ItemType Directory -Force -Path $W | Out-Null
$desk=[Environment]::GetFolderPath('Desktop'); $dirOut=Join-Path $desk 'BREAKOUT_FINALISTI_FTMO'; $dirSerie=Join-Path $dirOut 'serie'; New-Item -ItemType Directory -Force -Path $dirSerie | Out-Null
$COSTO=3.6
$CB=@(30,60,120); $SLA=@(1.0,1.5,2.5); $RR=@(1.0,1.5,2.0); $EX=@(6,18,36)
$FIN=@( @{ n='R1'; ix=@(0,0,0,0) }, @{ n='R2'; ix=@(0,1,1,1) }, @{ n='R4'; ix=@(1,0,1,2) } )
$FIN2=@( @{ n='F1'; da='2015.01.01'; a='2017.12.31' }, @{ n='F2'; da='2018.01.01'; a='2020.12.31' }, @{ n='OOS1'; da='2021.01.01'; a='2022.12.31' }, @{ n='OOS2'; da='2023.01.01'; a='2024.12.31' } )
$runs=New-Object System.Collections.ArrayList
foreach($f in $FIN){ foreach($wf in $FIN2){ [void]$runs.Add(@{ id=($f.n + '_' + $wf.n); tipo='finestra'; fin=$wf.n; da=$wf.da; a=$wf.a; ix=$f.ix }) } }
$visti=@{}
foreach($f in $FIN){ $visti[($f.ix -join ',')]=$true }
foreach($f in $FIN){
  for($fa=0; $fa -lt 4; $fa++){
    foreach($dl in @(-1,1)){
      $nx=@($f.ix); $nx[$fa]=$nx[$fa] + $dl
      if($nx[$fa] -lt 0 -or $nx[$fa] -gt 2){ continue }
      $kk=($nx -join ','); if($visti.ContainsKey($kk)){ continue }; $visti[$kk]=$true
      [void]$runs.Add(@{ id=('N_' + $f.n + '_f' + $fa + $(if($dl -lt 0){ 'm' } else { 'p' })); tipo=('vicino di ' + $f.n); fin='IS'; da='2015.01.01'; a='2020.12.31'; ix=$nx })
    }
  }
}
$righe=New-Object System.Collections.ArrayList
[void]$righe.Add('id;tipo;finestra;cb;stop_atr;target_R;scadenza;operazioni;profitto_tester;profitto_netto;PF_tester;PF_netto;DD_eur;recovery;t_giornaliera')
Write-Host ('=== VERIFICHE DEI 3 FINALISTI: ' + $runs.Count + ' passate (G3, G4 e vicini G2) su FTMO, H4, Modello 1. Avvio ' + (Get-Date).ToString('dd/MM/yyyy HH:mm') + ' (ora italiana). Durata attesa 40-120 minuti (STIMA). ===') -ForegroundColor Cyan
$n=0; $stopTutto=$false
foreach($ru in $runs){
  if($stopTutto){ break }
  $n=$n+1; $ix=$ru.ix
  $ov=@{ 'InpLevelTF'=16388; 'InpATRTF'=16388; 'InpEntryMode'=2; 'InpSLMode'=0; 'InpTPMode'=0; 'InpRearm'='true'; 'InpCountback'=$CB[$ix[0]]; 'InpSLAtr'=$SLA[$ix[1]].ToString('0.0',$ci); 'InpTP_RR'=$RR[$ix[2]].ToString('0.0',$ci); 'InpExpirationBars'=$EX[$ix[3]] }
  $rep='FIN_' + $ru.id
  $r=@('[Experts]','AllowLiveTrading=false','AllowDllImport=false','','[Tester]','Expert=CLAU12\Template_EA_Wim.ex5','Symbol=XAUUSD','Period=D1','Model=1','Optimization=0',('FromDate=' + $ru.da),('ToDate=' + $ru.a),'ForwardMode=0','Deposit=100000','Currency=EUR','Leverage=100','ExecutionMode=0','Visual=0','ReplaceReport=1','ShutdownTerminal=1',('Report=' + $rep),'','[TesterInputs]'); $r += (Valori $ov)
  $ini=Join-Path $W ($rep + '.ini'); Set-Content -LiteralPath $ini -Value (($r -join "`r`n") + "`r`n") -Encoding ASCII -NoNewline
  $rf=Join-Path $DATI ($rep + '.htm'); Remove-Item -LiteralPath $rf -Force -ErrorAction SilentlyContinue
  $t0=Get-Date; $pr=Start-Process -FilePath $TRM -ArgumentList ('/config:"' + $ini + '"') -PassThru
  $scade=$t0.AddMinutes(40); while(-not $pr.HasExited -and (Get-Date) -lt $scade){ Start-Sleep -Seconds 4 }
  if(-not $pr.HasExited){ Write-Host ('TIMEOUT su ' + $ru.id + ': il terminale e ancora aperto. Non lo chiudo io: mi fermo qui.') -ForegroundColor Red; $stopTutto=$true; break }
  $pre=($ru.id + ';' + $ru.tipo + ';' + $ru.fin + ';' + $CB[$ix[0]] + ';' + $SLA[$ix[1]].ToString('0.0',$ci) + ';' + $RR[$ix[2]].ToString('0.0',$ci) + ';' + $EX[$ix[3]])
  if(-not (Test-Path -LiteralPath $rf)){ [void]$righe.Add($pre + ';ERRORE;;;;;;;'); Write-Host ('[' + $n + '/' + $runs.Count + '] ' + $ru.id + ': report non trovato') -ForegroundColor Red; continue }
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
  Set-Content -LiteralPath (Join-Path $dirSerie ($ru.id + '.csv')) -Value $lin -Encoding ASCII
  $riga=($pre + ';' + $nT + ';' + $pT.ToString('0.00',$ci) + ';' + $netTot.ToString('0.00',$ci) + ';' + $pfT.ToString('0.00',$ci) + ';' + $pfN.ToString('0.00',$ci) + ';' + $ddE.ToString('0.0',$ci) + ';' + $rfT.ToString('0.00',$ci) + ';' + $tst.ToString('0.00',$ci))
  [void]$righe.Add($riga)
  Write-Host ('[' + (Get-Date).ToString('HH:mm') + ' ' + $n + '/' + $runs.Count + '] ' + $ru.id + ' ops ' + $nT + ' netto ' + $netTot.ToString('0',$ci) + ' PFnetto ' + $pfN.ToString('0.00',$ci)) -ForegroundColor Gray
}
[void][SvegliaFin.Win]::SetThreadExecutionState([uint32]2147483648)
$fileCsv=Join-Path $dirOut 'RISULTATI_FINALISTI_G2G4_FTMO.csv'; Set-Content -LiteralPath $fileCsv -Value ($righe -join "`r`n") -Encoding UTF8
try { Set-Clipboard -Value ($righe -join "`r`n") } catch { }
Write-Host ('FATTO alle ' + (Get-Date).ToString('dd/MM/yyyy HH:mm') + ' (ora italiana). File: ' + $fileCsv + ' (serie giornaliere in ' + $dirSerie + '). Allega il CSV alla chat.') -ForegroundColor Green
