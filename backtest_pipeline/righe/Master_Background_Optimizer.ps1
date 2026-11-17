# MARCATORE_MASTER_BACKGROUND_OPTIMIZER_v1
# Motore di conferma in BACKGROUND sul PC di backtest: prova varianti LOGICHE (vicini di 1-2 passi di griglia, vincolo di proporzione stop/target) di un set, in tester MT5 portabile, tre finestre: IS, OOS1, OOS2. Filtro: IS con PF/DD/operazioni, poi i DUE blocchi fuori campione; solo chi li passa va in VINCITORI_PROP. Il tester NON invia ordini (AllowLiveTrading=false). Terminale: portabile C:\MT5_BCM_Opt (nessun conto reale, nessun terminale principale, nessun VPS). Il 2025-2026 NON viene mai usato (hold-out). OGNI prova e registrata in Live_Log.csv con i suoi parametri (il numero di prove serve a correggere la significativita); dei SCARTATI si cancellano solo i file pesanti (report .htm). Per fermarlo: creare il file STOP.txt nella cartella dei risultati.
$ErrorActionPreference='Continue'
$ci=[Globalization.CultureInfo]::InvariantCulture
$CFG=@{
  Root='C:\MT5_BCM_Opt'; Expert='WIM\Ultimate_Breakout_EA_WSC_V9.5.ex5'; Symbol='XAUUSD'; Period='D1'
  BaseSet='C:\MT5_BCM_Opt\MQL5\Profiles\Tester\OPT2_ORO.set'
  Space=[ordered]@{ 'ST1_MinDist_to_HL'=@(350,450,550,650,750); 'ST1_Expiration_hours'=@(96,192,288,384,480); 'Exit_stop'=@(450,600,750,900,1050); 'Exit_limit'=@(1300,1700,2100,2500,2900) }
  Raggio=2; MaxCambi=2; MinRR=1.5            # vicini entro 2 passi, al massimo 2 parametri cambiati, target/stop >= 1,5 (proporzione di Wim)
  IS=@{ n='IS'; da='2015.01.01'; a='2020.12.31' }; OOS1=@{ n='OOS1'; da='2021.01.01'; a='2022.12.31' }; OOS2=@{ n='OOS2'; da='2023.01.01'; a='2024.12.31' }
  PFis=1.8; DDis=4.0; OpsIs=60; RecIs=1.5      # filtro dentro-campione (PF e DD richiesti da Claudio; DD% a lotto fisso 0,1 su 100.000: vedi nota)
  PFoos=1.2; OpsOos=20                          # fuori campione: PF >= 1,2, profitto > 0, >= 20 operazioni, in ENTRAMBI i blocchi
  Pausa=5; TimeoutMin=60; MaxProve=500
}
if($env:COMPUTERNAME -ne 'DESKTOP-H4D7CAJ'){ Write-Host ('SOLO sul PC di backtest DESKTOP-H4D7CAJ. Qui: ' + $env:COMPUTERNAME) -ForegroundColor Red; return }
$TRM=Join-Path $CFG.Root 'terminal64.exe'
foreach($pp in @($TRM,$CFG.BaseSet)){ if(-not (Test-Path -LiteralPath $pp)){ Write-Host ('MI FERMO: non trovo ' + $pp) -ForegroundColor Red; return } }
$desk=[Environment]::GetFolderPath('Desktop'); $dirOut=Join-Path $desk 'OTTIMIZZATORE_BG'; $dirWin=Join-Path $dirOut 'VINCITORI_PROP'; $logf=Join-Path $dirOut 'Live_Log.csv'; $stopf=Join-Path $dirOut 'STOP.txt'
New-Item -ItemType Directory -Force -Path $dirWin | Out-Null; $W=Join-Path $env:TEMP 'opt_bg'; New-Item -ItemType Directory -Force -Path $W | Out-Null
if(-not (Test-Path -LiteralPath $logf)){ Set-Content -LiteralPath $logf -Value 'Timestamp;ID;Fase;Parametri;Operazioni;PF;DD_equity_pct;Netto_EUR;Recovery;Esito' -Encoding UTF8 }
if(-not ('SvegliaBG.Win' -as [type])){ Add-Type -Namespace SvegliaBG -Name Win -MemberDefinition '[DllImport("kernel32.dll")] public static extern uint SetThreadExecutionState(uint esFlags);' }
[void][SvegliaBG.Win]::SetThreadExecutionState([uint32]2147483651)
function LeggiTesto([string]$p){ $b=[IO.File]::ReadAllBytes($p); if($b.Length -ge 2 -and (($b[0] -eq 255 -and $b[1] -eq 254) -or ($b[0] -eq 254 -and $b[1] -eq 255))){ return [Text.Encoding]::Unicode.GetString($b) } else { return [Text.Encoding]::UTF8.GetString($b) } }
function Num([string]$s){ $c=($s -replace '[^0-9.\-]',''); $v=0.0; if([double]::TryParse($c,[Globalization.NumberStyles]::Float,$ci,[ref]$v)){ return $v } else { return [double]::NaN } }
function Cerca([string]$t,[string]$et){ $m=[regex]::Match($t,'(?:' + $et + ')\|([^|]*)\|'); if($m.Success){ return $m.Groups[1].Value } else { return $null } }
# set di base
$base=@(); foreach($r in ((LeggiTesto $CFG.BaseSet) -split "`r?`n")){ $x=$r.Trim([char]0xFEFF).Trim(); if($x -ne '' -and -not $x.StartsWith(';') -and $x.Contains('=')){ $base += $x } }
function Righe($ov){ $o=@(); foreach($b in $base){ $x=$b; $m=[regex]::Match($b,'^(?<n>[A-Za-z0-9_]+)=(?<v>[^|]*)(?<r>\|\|.*)?$'); if($m.Success -and $ov.ContainsKey($m.Groups['n'].Value)){ $x=$m.Groups['n'].Value + '=' + $ov[$m.Groups['n'].Value] + $m.Groups['r'].Value }; $o += $x }; return $o }
function ValBase([string]$nm){ foreach($b in $base){ if($b -match ('^' + [regex]::Escape($nm) + '=([^|]*)')){ return $Matches[1] } }; return $null }
# candidati: combinazioni con al massimo MaxCambi parametri cambiati, ciascuno entro Raggio passi dal valore di base
$nomi=@($CFG.Space.Keys); $cand=New-Object System.Collections.ArrayList
function Genera([int]$i,$sel,[int]$cambi){
  if($i -ge $nomi.Count){ if($cambi -gt 0){ [void]$cand.Add($sel.Clone()) }; return }
  $nm=$nomi[$i]; $vals=@($CFG.Space[$nm]); $bv=Num (ValBase $nm); $ib=[array]::IndexOf($vals,[int]$bv); if($ib -lt 0){ $ib=[array]::IndexOf($vals,$bv) }
  $sel2=$sel.Clone(); Genera ($i+1) $sel2 $cambi
  if($cambi -lt $CFG.MaxCambi -and $ib -ge 0){ for($k=0; $k -lt $vals.Count; $k++){ if($k -eq $ib -or [math]::Abs($k-$ib) -gt $CFG.Raggio){ continue }; $s3=$sel.Clone(); $s3[$nm]=[string]$vals[$k]; Genera ($i+1) $s3 ($cambi+1) } }
}
Genera 0 @{} 0
$ok=@(); foreach($c in $cand){ $st=$(if($c.ContainsKey('Exit_stop')){ Num $c['Exit_stop'] } else { Num (ValBase 'Exit_stop') }); $tg=$(if($c.ContainsKey('Exit_limit')){ Num $c['Exit_limit'] } else { Num (ValBase 'Exit_limit') }); if($st -gt 0 -and ($tg/$st) -ge $CFG.MinRR){ $ok += ,$c } }
$ok=@($ok | Sort-Object { $_.Count })
function Chiave($c){ return (($c.Keys | Sort-Object | ForEach-Object { $_ + '=' + $c[$_] }) -join ',') }
$gia=@{}; foreach($rg in (Get-Content -LiteralPath $logf | Select-Object -Skip 1)){ $f=$rg -split ';'; if($f.Count -ge 4 -and $f[2] -eq 'IS'){ $gia[$f[3]]=$true } }
function Prova([string]$id,$ov,$fin){
  $rep='BGO_' + $id + '_' + $fin.n
  $r=@('[Experts]','AllowLiveTrading=false','AllowDllImport=false','','[Tester]',('Expert=' + $CFG.Expert),('Symbol=' + $CFG.Symbol),('Period=' + $CFG.Period),'Model=1','Optimization=0',('FromDate=' + $fin.da),('ToDate=' + $fin.a),'ForwardMode=0','Deposit=100000','Currency=EUR','Leverage=100','ExecutionMode=0','Visual=0','ReplaceReport=1','ShutdownTerminal=1',('Report=' + $rep),'','[TesterInputs]'); $r += (Righe $ov)
  $ini=Join-Path $W ($rep + '.ini'); Set-Content -LiteralPath $ini -Value (($r -join "`r`n") + "`r`n") -Encoding ASCII -NoNewline
  $rf=Join-Path $CFG.Root ($rep + '.htm'); Remove-Item -LiteralPath $rf -Force -ErrorAction SilentlyContinue
  $t0=Get-Date; $pr=Start-Process -FilePath $TRM -ArgumentList ('/portable /config:"' + $ini + '"') -WindowStyle Hidden -PassThru
  $scade=$t0.AddMinutes($CFG.TimeoutMin); while(-not $pr.HasExited -and (Get-Date) -lt $scade){ Start-Sleep -Seconds 3 }
  Remove-Item -LiteralPath $ini -Force -ErrorAction SilentlyContinue
  if(-not $pr.HasExited){ return @{ stato='TIMEOUT' } }
  if(-not (Test-Path -LiteralPath $rf)){ return @{ stato='NOREPORT' } }
  $tx=[regex]::Replace((LeggiTesto $rf),'<[^>]*>','|'); $tx=[regex]::Replace($tx,'\s*\|[\s|]*','|')
  $ddS=Cerca $tx 'Drawdown Massima:|Equity Drawdown Maximal:'; $dd=[double]::NaN; if($ddS){ $mm=[regex]::Match($ddS,'\(([0-9.,]+)\s*%\)'); if($mm.Success){ $dd=Num ($mm.Groups[1].Value.Replace(',','.')) } }
  return @{ stato='OK'; rf=$rf; ops=(Num (Cerca $tx 'Numero di Operazioni di Trading Totali:|Total Trades:')); pf=(Num (Cerca $tx 'Fattore di Profitto:|Profit Factor:')); dd=$dd; net=(Num (Cerca $tx 'Profitto Totale Netto:|Total Net Profit:')); rec=(Num (Cerca $tx 'Fattore di Recupero:|Recovery Factor:')) }
}
function Log([string]$id,[string]$fase,[string]$par,$x,[string]$esito){ $l=((Get-Date).ToString('yyyy-MM-dd HH:mm:ss') + ';' + $id + ';' + $fase + ';' + $par + ';' + $x.ops + ';' + ([double]$x.pf).ToString('0.00',$ci) + ';' + ([double]$x.dd).ToString('0.00',$ci) + ';' + ([double]$x.net).ToString('0.00',$ci) + ';' + ([double]$x.rec).ToString('0.00',$ci) + ';' + $esito); Add-Content -LiteralPath $logf -Value $l -Encoding UTF8 }
$n=0; $nf=0; $fermo=$false
foreach($c in $ok){
  if($fermo -or $n -ge $CFG.MaxProve){ break }
  if(Test-Path -LiteralPath $stopf){ Add-Content -LiteralPath $logf -Value ((Get-Date).ToString('yyyy-MM-dd HH:mm:ss') + ';-;-;STOP.txt trovato: mi fermo;;;;;;FERMATO') -Encoding UTF8; break }
  $key=Chiave $c; if($gia.ContainsKey($key)){ continue }
  $n=$n+1; $id=(Get-Date).ToString('MMdd') + '_' + ('{0:0000}' -f $n)
  while(@(Get-Process -Name terminal64 -ErrorAction SilentlyContinue | Where-Object { $_.Path -eq $TRM }).Count -gt 0){ Start-Sleep -Seconds 10 }
  $a=Prova $id $c $CFG.IS
  if($a.stato -ne 'OK'){ $nf=$nf+1; if($nf -ge 3){ $fermo=$true }; Add-Content -LiteralPath $logf -Value ((Get-Date).ToString('yyyy-MM-dd HH:mm:ss') + ';' + $id + ';IS;' + $key + ';;;;;;' + $a.stato) -Encoding UTF8; if($a.stato -eq 'TIMEOUT'){ $fermo=$true }; continue }
  $nf=0
  $passIs=($a.pf -ge $CFG.PFis -and $a.dd -le $CFG.DDis -and $a.ops -ge $CFG.OpsIs -and $a.rec -ge $CFG.RecIs)
  if(-not $passIs){ Log $id 'IS' $key $a 'SCARTATO_IS'; Remove-Item -LiteralPath $a.rf -Force -ErrorAction SilentlyContinue; Start-Sleep -Seconds $CFG.Pausa; continue }
  Log $id 'IS' $key $a 'PASSA_IS'
  $b1=Prova $id $c $CFG.OOS1; $b2=Prova $id $c $CFG.OOS2
  $oosOk=($b1.stato -eq 'OK' -and $b2.stato -eq 'OK' -and $b1.pf -ge $CFG.PFoos -and $b2.pf -ge $CFG.PFoos -and $b1.net -gt 0 -and $b2.net -gt 0 -and $b1.ops -ge $CFG.OpsOos -and $b2.ops -ge $CFG.OpsOos)
  if($b1.stato -eq 'OK'){ Log $id 'OOS1' $key $b1 $(if($oosOk){ 'PASSA_OOS' } else { 'SCARTATO_OOS' }) }
  if($b2.stato -eq 'OK'){ Log $id 'OOS2' $key $b2 $(if($oosOk){ 'PASSA_OOS' } else { 'SCARTATO_OOS' }) }
  if($oosOk){
    $dw=Join-Path $dirWin $id; New-Item -ItemType Directory -Force -Path $dw | Out-Null
    Set-Content -LiteralPath (Join-Path $dw ($id + '.set')) -Value ((@('; VINCITORE ' + $id + ' - passato IS e OOS1+OOS2 (2025-2026 NON usato: hold-out). Parametri cambiati: ' + $key) + (Righe $c)) -join "`r`n") -Encoding ASCII
    foreach($x in @($a,$b1,$b2)){ if($x.rf){ Copy-Item -LiteralPath $x.rf -Destination $dw -Force -ErrorAction SilentlyContinue } }
    Add-Content -LiteralPath $logf -Value ((Get-Date).ToString('yyyy-MM-dd HH:mm:ss') + ';' + $id + ';FINALE;' + $key + ';;;;;;SALVATO') -Encoding UTF8
  }
  foreach($x in @($a,$b1,$b2)){ if($x.rf){ Remove-Item -LiteralPath $x.rf -Force -ErrorAction SilentlyContinue } }
  Start-Sleep -Seconds $CFG.Pausa
}
Add-Content -LiteralPath $logf -Value ((Get-Date).ToString('yyyy-MM-dd HH:mm:ss') + ';-;-;fine ciclo (candidati esauriti o limite);;;;;;FINE') -Encoding UTF8
[void][SvegliaBG.Win]::SetThreadExecutionState([uint32]2147483648)
