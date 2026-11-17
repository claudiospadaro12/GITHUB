# MARCATORE_CONTROLLO_POSITIVO_WIM_C0_FTMO_v1
# CONTROLLO POSITIVO: il set OPT2_ORO.set di Wim (C0: MinDist 550, Scadenza 480, Stop 600, Limit 1700) di Ultimate_Breakout_EA_WSC_V9.5 sulle NOSTRE porte G1-G4 - criteri CLAU12_CONTROLLO_POSITIVO_WIM_C0_CRITERI_2026-11-18 (scritti PRIMA dei numeri). Terminale FTMO di prova, XAUUSD D1, Modello 1, 100000 EUR, lotto 0,1. 12 passate: IS 2015-2020, meta 2015-17 e 2018-20, OOS 2021-22 e 2023-24, 7 vicini sul IS.
# Per ogni passata: PF del tester, netto (meno 3,6 EUR a operazione), PF netto, t per giornata con uscite, recovery, DD. Salva le serie giornaliere. Il tester NON invia ordini. Scrive solo nei dati di Mt5_Ftmo_Prova, in %TEMP% e sul Desktop. Non tocca BCM, conti reali, VPS. Non chiude MT5 con la forza.
$ErrorActionPreference='Continue'
$ci=[Globalization.CultureInfo]::InvariantCulture
if($env:COMPUTERNAME -ne 'DESKTOP-H4D7CAJ'){ Write-Host ('SOLO sul PC di backtest DESKTOP-H4D7CAJ. Qui: ' + $env:COMPUTERNAME) -ForegroundColor Red; return }
$FT='C:\MT5_Backtest\Mt5_Ftmo_Prova'; $TRM=Join-Path $FT 'terminal64.exe'
$SET='C:\MT5_BCM_Opt\MQL5\Profiles\Tester\OPT2_ORO.set'
$aperti=@(Get-Process -Name terminal64,metatester64,metaeditor64 -ErrorAction SilentlyContinue)
if($aperti.Count -gt 0){ $aperti | Select-Object Id,ProcessName,Path | Format-Table -AutoSize | Out-String | Write-Host; Write-Host 'MI FERMO: MT5, MetaEditor o agenti aperti. Chiudili e rilancia. Non ho avviato niente.' -ForegroundColor Red; return }
foreach($pp in @($TRM,$SET)){ if(-not (Test-Path -LiteralPath $pp)){ Write-Host ('MI FERMO: non trovo ' + $pp) -ForegroundColor Red; return } }
$DATI=$null; $baseT=Join-Path $env:APPDATA 'MetaQuotes\Terminal'
foreach($o in @(Get-ChildItem -LiteralPath $baseT -Directory -ErrorAction SilentlyContinue)){ $of=Join-Path $o.FullName 'origin.txt'; if(Test-Path -LiteralPath $of){ $cox=((Get-Content -LiteralPath $of -Raw -Encoding Unicode) -replace '[\r\n\0]','').Trim(); if($cox -eq $FT){ $DATI=$o.FullName } } }
if(-not $DATI){ Write-Host 'MI FERMO: non trovo la cartella dati di Mt5_Ftmo_Prova.' -ForegroundColor Red; return }
if(-not (Test-Path -LiteralPath (Join-Path $DATI 'MQL5\Experts\WIM\Ultimate_Breakout_EA_WSC_V9.5.ex5'))){ Write-Host 'MI FERMO: l EA di Wim non e nel terminale FTMO di prova.' -ForegroundColor Red; return }
$fci=Join-Path $DATI 'config\common.ini'
if(Test-Path -LiteralPath $fci){ $bci=[IO.File]::ReadAllBytes($fci); $tci=$(if($bci.Length -ge 2 -and $bci[0] -eq 255 -and $bci[1] -eq 254){ [Text.Encoding]::Unicode.GetString($bci) } else { [Text.Encoding]::UTF8.GetString($bci) }); $lg=[regex]::Match($tci,'(?m)^Login=(\d+)'); $sv=[regex]::Match($tci,'(?m)^Server=(.*)$'); if($lg.Success){ $ln=$lg.Groups[1].Value; Write-Host ('Terminale FTMO di prova: server ' + $sv.Groups[1].Value.Trim() + ', login ' + $ln.Substring(0,3) + '...' + $ln.Substring($ln.Length-2) + ' (Free Trial scaduto il 16/11: il tester non invia ordini)') -ForegroundColor Cyan } }
if(-not ('SvegliaCPW.Win' -as [type])){ Add-Type -Namespace SvegliaCPW -Name Win -MemberDefinition '[DllImport("kernel32.dll")] public static extern uint SetThreadExecutionState(uint esFlags);' }
[void][SvegliaCPW.Win]::SetThreadExecutionState([uint32]2147483651)
$sb=[IO.File]::ReadAllBytes($SET); $st=$(if($sb.Length -ge 2 -and $sb[0] -eq 255 -and $sb[1] -eq 254){ [Text.Encoding]::Unicode.GetString($sb) } else { [Text.Encoding]::UTF8.GetString($sb) })
$base=@(); foreach($r in ($st -split "`r?`n")){ $x=$r.Trim([char]0xFEFF).Trim(); if($x -ne '' -and -not $x.StartsWith(';') -and $x.Contains('=')){ $base += $x } }
if(@($base | Where-Object { $_ -match '^Risk=0\|\|' }).Count -ne 1 -or @($base | Where-Object { $_ -match '^StartLots=0\.1\|\|' }).Count -ne 1){ Write-Host 'MI FERMO: nel set Risk non e 0 o StartLots non e 0.1.' -ForegroundColor Red; return }
function Valori($cd){ $o=@(); foreach($b in $base){ $x=$b; $m=[regex]::Match($b,'^(?<n>[A-Za-z0-9_]+)=(?<v>[^|]*)(?<r>\|\|.*)$'); if($m.Success){ $nm=$m.Groups['n'].Value; $nv=$null; if($nm -eq 'ST1_MinDist_to_HL'){ $nv=$cd.md } elseif($nm -eq 'ST1_Expiration_hours'){ $nv=$cd.ex } elseif($nm -eq 'Exit_stop'){ $nv=$cd.st } elseif($nm -eq 'Exit_limit'){ $nv=$cd.li }; if($nv -ne $null){ $x=$nm + '=' + $nv + $m.Groups['r'].Value } }; $o += $x }; return $o }
function Num([string]$s){ $c=($s -replace '[^0-9.\-]',''); $v=0.0; if([double]::TryParse($c,[Globalization.NumberStyles]::Float,$ci,[ref]$v)){ return $v } else { return [double]::NaN } }
function Cerca([string]$t,[string]$et){ $m=[regex]::Match($t,'(?:' + $et + ')\|([^|]*)\|'); if($m.Success){ return $m.Groups[1].Value } else { return $null } }
$W=Join-Path $env:TEMP 'controllo_positivo_wim'; New-Item -ItemType Directory -Force -Path $W | Out-Null
$desk=[Environment]::GetFolderPath('Desktop'); $dirOut=Join-Path $desk 'CONTROLLO_POSITIVO_WIM_C0'; $dirSerie=Join-Path $dirOut 'serie'; New-Item -ItemType Directory -Force -Path $dirSerie | Out-Null
$COSTO=3.6
$PC0=@{ md='550'; ex='480'; st='600'; li='1700' }
$FIN=@( @{ n='IS'; da='2015.01.01'; a='2020.12.31' }, @{ n='F1'; da='2015.01.01'; a='2017.12.31' }, @{ n='F2'; da='2018.01.01'; a='2020.12.31' }, @{ n='OOS1'; da='2021.01.01'; a='2022.12.31' }, @{ n='OOS2'; da='2023.01.01'; a='2024.12.31' } )
$runs=New-Object System.Collections.ArrayList
foreach($f in $FIN){ [void]$runs.Add(@{ id=('C0_' + $f.n); tipo='centro'; fin=$f.n; da=$f.da; a=$f.a; cd=$PC0 }) }
$VIC=@( @{ id='N_MD450'; md='450'; ex='480'; st='600'; li='1700' }, @{ id='N_MD650'; md='650'; ex='480'; st='600'; li='1700' }, @{ id='N_EX384'; md='550'; ex='384'; st='600'; li='1700' }, @{ id='N_ST450'; md='550'; ex='480'; st='450'; li='1700' }, @{ id='N_ST750'; md='550'; ex='480'; st='750'; li='1700' }, @{ id='N_LI1300'; md='550'; ex='480'; st='600'; li='1300' }, @{ id='N_LI2100'; md='550'; ex='480'; st='600'; li='2100' } )
foreach($vv in $VIC){ [void]$runs.Add(@{ id=$vv.id; tipo='vicino'; fin='IS'; da='2015.01.01'; a='2020.12.31'; cd=@{ md=$vv.md; ex=$vv.ex; st=$vv.st; li=$vv.li } }) }
$righe=New-Object System.Collections.ArrayList
[void]$righe.Add('id;tipo;finestra;MinDist;Scadenza;Stop;Limit;operazioni;profitto_tester;profitto_netto;PF_tester;PF_netto;DD_eur;recovery;t_giornaliera')
Write-Host ('=== CONTROLLO POSITIVO WIM C0 su FTMO: ' + $runs.Count + ' passate, Modello 1. Avvio ' + (Get-Date).ToString('dd/MM/yyyy HH:mm') + ' (ora italiana). Durata attesa 20-60 minuti (STIMA). Non aprire altri MT5; PC alla corrente. ===') -ForegroundColor Cyan
$n=0; $stopTutto=$false
foreach($ru in $runs){
    if($stopTutto){ break }
    $n=$n+1; $id=$ru.id; $rep='CPW_' + $id
    $r=@('[Experts]','AllowLiveTrading=false','AllowDllImport=false','','[Tester]','Expert=WIM\Ultimate_Breakout_EA_WSC_V9.5.ex5','Symbol=XAUUSD','Period=D1','Model=1','Optimization=0',('FromDate=' + $ru.da),('ToDate=' + $ru.a),'ForwardMode=0','Deposit=100000','Currency=EUR','Leverage=100','ExecutionMode=0','Visual=0','ReplaceReport=1','ShutdownTerminal=1',('Report=' + $rep),'','[TesterInputs]'); $r += (Valori $ru.cd)
    $ini=Join-Path $W ($rep + '.ini'); Set-Content -LiteralPath $ini -Value (($r -join "`r`n") + "`r`n") -Encoding ASCII -NoNewline
    $rf=Join-Path $DATI ($rep + '.htm'); Remove-Item -LiteralPath $rf -Force -ErrorAction SilentlyContinue
    $t0=Get-Date; $pr=Start-Process -FilePath $TRM -ArgumentList ('/config:"' + $ini + '"') -PassThru
    $scade=$t0.AddMinutes(40); while(-not $pr.HasExited -and (Get-Date) -lt $scade){ Start-Sleep -Seconds 4 }
    if(-not $pr.HasExited){ Write-Host ('TIMEOUT sulla passata ' + $id + ': il terminale e ancora aperto. Non lo chiudo io: mi fermo qui.') -ForegroundColor Red; $stopTutto=$true; break }
    if(-not (Test-Path -LiteralPath $rf)){ [void]$righe.Add($id + ';' + $ru.tipo + ';' + $ru.fin + ';' + $ru.cd.md + ';' + $ru.cd.ex + ';' + $ru.cd.st + ';' + $ru.cd.li + ';ERRORE;;;;;;;'); Write-Host ('[' + $n + '/' + $runs.Count + '] ' + $id + ': report non trovato') -ForegroundColor Red; continue }
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
    $pre=($id + ';' + $ru.tipo + ';' + $ru.fin + ';' + $ru.cd.md + ';' + $ru.cd.ex + ';' + $ru.cd.st + ';' + $ru.cd.li)
    $riga=($pre + ';' + $nT + ';' + $pT.ToString('0.00',$ci) + ';' + $netTot.ToString('0.00',$ci) + ';' + $pfT.ToString('0.00',$ci) + ';' + $pfN.ToString('0.00',$ci) + ';' + $ddE.ToString('0.0',$ci) + ';' + $rfT.ToString('0.00',$ci) + ';' + $tst.ToString('0.00',$ci))
    [void]$righe.Add($riga)
    Write-Host ('[' + (Get-Date).ToString('HH:mm') + ' ' + $n + '/' + $runs.Count + '] ' + $id + ' ops ' + $nT + ' netto ' + $netTot.ToString('0',$ci) + ' PFnetto ' + $pfN.ToString('0.00',$ci) + ' t ' + $tst.ToString('0.00',$ci)) -ForegroundColor Gray
}
[void][SvegliaCPW.Win]::SetThreadExecutionState([uint32]2147483648)
$fileCsv=Join-Path $dirOut 'RISULTATI_CONTROLLO_POSITIVO_WIM_C0_FTMO.csv'; Set-Content -LiteralPath $fileCsv -Value ($righe -join "`r`n") -Encoding UTF8
try { Set-Clipboard -Value ($righe -join "`r`n") } catch { }
Write-Host ('FATTO alle ' + (Get-Date).ToString('dd/MM/yyyy HH:mm') + ' (ora italiana). File: ' + $fileCsv + ' (serie giornaliere in ' + $dirSerie + '). Allega il CSV alla chat. I verdetti li do io con le soglie scritte.') -ForegroundColor Green
