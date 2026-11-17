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
  Logica='Breakout su massimi/minimi giornalieri (livelli D1 con forza L/R): ordini STOP oltre il massimo (buy) e oltre il minimo (sell); a esecuzione si cancella l altro; Exit_stop e Exit_limit sono stop e target in punti (proporzione target/stop >= 1,5 come nei set di Wim); ST1_MinDist_to_HL = distanza minima dal livello; ST1_Expiration_hours = durata degli ordini pendenti. Oro, D1, lotto fisso 0,1 su 100.000 EUR.'
}
if($env:COMPUTERNAME -ne 'DESKTOP-H4D7CAJ'){ Write-Host ('SOLO sul PC di backtest DESKTOP-H4D7CAJ. Qui: ' + $env:COMPUTERNAME) -ForegroundColor Red; return }
$TRM=Join-Path $CFG.Root 'terminal64.exe'
foreach($pp in @($TRM,$CFG.BaseSet)){ if(-not (Test-Path -LiteralPath $pp)){ Write-Host ('MI FERMO: non trovo ' + $pp) -ForegroundColor Red; return } }
$desk=[Environment]::GetFolderPath('Desktop'); $dirOut=Join-Path $desk 'OTTIMIZZATORE_BG'; $dirWin=Join-Path $dirOut 'VINCITORI_PROP'; $dirDos=Join-Path $dirOut 'Dossier_Gemini'; $logf=Join-Path $dirOut 'Live_Log.csv'; $stopf=Join-Path $dirOut 'STOP.txt'
New-Item -ItemType Directory -Force -Path $dirWin | Out-Null; New-Item -ItemType Directory -Force -Path $dirDos | Out-Null; $W=Join-Path $env:TEMP 'opt_bg'; New-Item -ItemType Directory -Force -Path $W | Out-Null
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
  return @{ stato='OK'; rf=$rf; ops=(Num (Cerca $tx 'Numero di Operazioni di Trading Totali:|Total Trades:')); wr=$(if((Cerca $tx 'Operazioni Redditizie \(% del totale\):|Profit Trades \(% of total\):') -match '\(([0-9.,]+)\s*%\)'){ Num ($Matches[1].Replace(',','.')) } else { [double]::NaN }); pf=(Num (Cerca $tx 'Fattore di Profitto:|Profit Factor:')); dd=$dd; net=(Num (Cerca $tx 'Profitto Totale Netto:|Total Net Profit:')); rec=(Num (Cerca $tx 'Fattore di Recupero:|Recovery Factor:')) }
}
function Equity([string]$rf){
  $html=LeggiTesto $rf; $pts=New-Object System.Collections.ArrayList; $inD=$false; $iDi=-1; $iBa=-1
  foreach($rg in [regex]::Split($html,'(?i)<tr')){
    $celle=@(); foreach($mc in [regex]::Matches($rg,'(?is)<t[dh][^>]*>(.*?)</t[dh]>')){ $celle += (([regex]::Replace($mc.Groups[1].Value,'<[^>]*>','') -replace '&nbsp;',' ' -replace '\s+',' ').Trim()) }
    if($celle.Count -lt 8){ continue }
    $d1=-1; $b1=-1; for($i=0; $i -lt $celle.Count; $i++){ if($celle[$i] -match '^(Direction|Direzione)$'){ $d1=$i } elseif($celle[$i] -match '^(Balance|Bilancio|Saldo)$'){ $b1=$i } }
    if($d1 -ge 0 -and $b1 -ge 0){ $inD=$true; $iDi=$d1; $iBa=$b1; continue }
    if(-not $inD){ continue }
    if($celle[0] -notmatch '^\d{4}\.\d{2}\.\d{2} \d{2}:\d{2}:\d{2}$'){ continue }
    if($celle.Count -le $iBa){ continue }
    if($celle[$iDi] -eq 'out'){ [void]$pts.Add($celle[0].Substring(0,10) + '|' + ((Num $celle[$iBa]).ToString('0.00',$ci))) }
  }
  return ,@($pts)
}
function Campiona($pts,[int]$k){ $v=@(); foreach($p in $pts){ $v += [double]($p.Split('|')[1]) }; $o=@(); if($v.Count -le $k){ foreach($x in $v){ $o += [math]::Round($x,0) }; return ($o -join ' ') }; for($i=0; $i -lt $k; $i++){ $o += [math]::Round($v[[int][math]::Floor($i*($v.Count-1)/($k-1))],0) }; return ($o -join ' ') }
function Stagnazione($pts){
  if($pts.Count -lt 2){ return @(0,'n.d.') }
  $picco=-1.0; $dp=$null; $mx=0; $per='n.d.'
  foreach($p in $pts){ $d=[datetime]::ParseExact($p.Split('|')[0],'yyyy.MM.dd',$ci); $b=[double]$p.Split('|')[1]
    if($b -gt $picco){ if($dp -ne $null){ $g=($d-$dp).Days; if($g -gt $mx){ $mx=$g; $per=($dp.ToString('yyyy-MM-dd') + ' -> ' + $d.ToString('yyyy-MM-dd')) } }; $picco=$b; $dp=$d } }
  $ult=[datetime]::ParseExact($pts[$pts.Count-1].Split('|')[0],'yyyy.MM.dd',$ci); if($dp -ne $null){ $g=($ult-$dp).Days; if($g -gt $mx){ $mx=$g; $per=($dp.ToString('yyyy-MM-dd') + ' -> ' + $ult.ToString('yyyy-MM-dd') + ' (in corso a fine finestra)') } }
  return @($mx,$per)
}
function ScriviAudit([string]$id,$c,[string]$key,$a,$b1,$b2,[string]$dd0){
  $nomeEa=[IO.Path]::GetFileNameWithoutExtension((Split-Path -Leaf $CFG.Expert))
  $st=$(if($c.ContainsKey('Exit_stop')){ Num $c['Exit_stop'] } else { Num (ValBase 'Exit_stop') }); $tg=$(if($c.ContainsKey('Exit_limit')){ Num $c['Exit_limit'] } else { Num (ValBase 'Exit_limit') })
  $prove=@(Get-Content -LiteralPath $logf | Select-Object -Skip 1 | Where-Object { $_ -match ';IS;' }).Count; $nPassati=@(Get-Content -LiteralPath $logf | Select-Object -Skip 1 | Where-Object { $_ -match ';PASSA_IS' }).Count
  $fin=@(@('IS 2015-2020',$a),@('OOS1 2021-2022',$b1),@('OOS2 2023-2024',$b2)); $stag=@{}; $eq=@{}
  foreach($z in $fin){ $eq[$z[0]]=(Equity $z[1].rf); $stag[$z[0]]=(Stagnazione $eq[$z[0]]) }
  $rr=[math]::Round($tg/$st,2)
  $L=@()
  $L += ('# Audit_Gemini_' + $nomeEa + '_' + $id + ' - dossier per la revisione esterna (Risk Manager / Avvocato del Diavolo)')
  $L += ''
  $L += ('Generato il ' + (Get-Date).ToString('yyyy-MM-dd HH:mm') + ' dal motore in background. COPIA TUTTO il file in Gemini. La sezione 8 e una valutazione AUTOMATICA a regole, non il giudizio finale.')
  $L += ''
  $L += '## 1. Setup'
  $L += ('EA: ' + $nomeEa + ' | simbolo ' + $CFG.Symbol + ' ' + $CFG.Period + ' | tester MT5 Modello 1 (candele da 1 minuto; i tick reali non coprono questi anni), deposito 100000 EUR, lotto fisso 0,1.')
  $L += ('Parametri cambiati rispetto al set base ' + (Split-Path -Leaf $CFG.BaseSet) + ': ' + $key)
  $L += ''
  $L += '## 2. Logica di ingresso e uscita'
  $L += $CFG.Logica
  $L += ''
  $L += '## 3. Rapporto rischio/rendimento'
  $L += ('Exit_stop ' + $st + ' punti, Exit_limit ' + $tg + ' punti: rapporto target/stop = ' + $rr.ToString('0.00',$ci) + '. Con rapporto > 1 l aspettativa puo essere positiva anche con win rate sotto il 50%: breakeven del win rate = 1/(1+rapporto) = ' + ((1/(1+$rr))*100).ToString('0.0',$ci) + '%.')
  $L += ''
  $L += '## 4. Metriche complete (tester, costi aggiuntivi della campagna di 3,6 EUR a operazione NON inclusi)'
  $L += '| Finestra | Operazioni | Win rate % | PF | DD equity % | Netto EUR | Recovery | Stagnazione max (giorni) |'
  $L += '|---|---|---|---|---|---|---|---|'
  foreach($z in $fin){ $x=$z[1]; $L += ('| ' + $z[0] + ' | ' + $x.ops + ' | ' + ([double]$x.wr).ToString('0.0',$ci) + ' | ' + ([double]$x.pf).ToString('0.00',$ci) + ' | ' + ([double]$x.dd).ToString('0.00',$ci) + ' | ' + ([double]$x.net).ToString('0.00',$ci) + ' | ' + ([double]$x.rec).ToString('0.00',$ci) + ' | ' + $stag[$z[0]][0] + ' |') }
  $L += 'Nota: il DD% dipende dal lotto (0,1 su 100000 EUR e molto piccolo per qualunque set); il 2025-2026 NON e stato usato (hold-out).'
  $L += ''
  $L += '## 5. Periodi di massima stagnazione (da un massimo del saldo al successivo)'
  foreach($z in $fin){ $L += ('- ' + $z[0] + ': ' + $stag[$z[0]][0] + ' giorni, ' + $stag[$z[0]][1]) }
  $L += ''
  $L += '## 6. Quante prove sono state fatte (contesto di overfitting)'
  $L += ('Prove dentro-campione registrate: ' + $prove + '; passate il filtro IS: ' + $nPassati + '. Piu prove, piu e probabile che un buon risultato sia fortuna.')
  $L += ''
  $L += '## 7. Equity line vettoriale (saldo dopo ogni operazione chiusa, max 60 punti)'
  foreach($z in $fin){ $L += ('- ' + $z[0] + ': ' + (Campiona $eq[$z[0]] 60)) }
  $L += ''
  $L += '## 8. Valutazione critica AUTOMATICA (regole fisse, da confermare)'
  if($a.ops -lt 100){ $L += ('- Campione IS piccolo: ' + $a.ops + ' operazioni (< 100): la statistica t e poco affidabile.') }
  if($b1.pf -lt 0.7*$a.pf -or $b2.pf -lt 0.7*$a.pf){ $L += '- Degrado fuori campione: il PF di un blocco OOS e < 70% del PF IS.' }
  if($prove -gt 30){ $L += ('- Molte prove (' + $prove + '): serve una soglia di significativita piu alta; un vincitore scelto tra tante e probabilmente il migliore per fortuna.') }
  if($stag['IS 2015-2020'][0] -gt 180 -or $stag['OOS1 2021-2022'][0] -gt 180 -or $stag['OOS2 2023-2024'][0] -gt 180){ $L += '- Stagnazione lunga (> 180 giorni senza nuovo massimo del saldo): difficile da sostenere in una sfida con tempo limitato.' }
  if($rr -lt 1.5){ $L += '- Rapporto target/stop sotto 1,5: fuori dalla proporzione di Wim.' }
  $L += '- Il set e un VICINO del set di Wim (stesso motore): correlazione attesa vicina a 1 con quel set e con altri breakout giornalieri su oro.'
  $L += '- Il tester usa candele da 1 minuto: la differenza con i tick reali non e misurata per questo EA in questi anni.'
  $L += ''
  $L += '## 9. Prompt da incollare in Gemini'
  $L += 'Agisci come Risk Manager istituzionale su questo Expert Advisor. Analizza le serie e le metriche: (1) anomalie nelle serie storiche e nella equity line; (2) debolezza nei periodi di stagnazione; (3) se il rapporto stop/target e il win rate danno una aspettativa matematica positiva reale o se il risultato dipende da overfitting (considera il numero di prove della sezione 6); (4) fragilita se spread, slippage e swap aumentano; (5) rischio di coda per una prop firm; (6) correlazione probabile con altri EA su oro. Rispondi con: verdetto (promuovere / scartare / ritestare), le 3 obiezioni piu gravi con un test concreto per ciascuna, e le correzioni operative esatte per il prossimo giro di backtest.'
  Set-Content -LiteralPath (Join-Path $dd0 ('Audit_Gemini_' + $nomeEa + '_' + $id + '.md')) -Value ($L -join "`r`n") -Encoding ASCII
}
function Log([string]$id,[string]$fase,[string]$par,$x,[string]$esito){ $riga=((Get-Date).ToString('yyyy-MM-dd HH:mm:ss') + ';' + $id + ';' + $fase + ';' + $par + ';' + $x.ops + ';' + ([double]$x.pf).ToString('0.00',$ci) + ';' + ([double]$x.dd).ToString('0.00',$ci) + ';' + ([double]$x.net).ToString('0.00',$ci) + ';' + ([double]$x.rec).ToString('0.00',$ci) + ';' + $esito); Add-Content -LiteralPath $logf -Value $riga -Encoding UTF8 }
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
    try { ScriviAudit $id $c $key $a $b1 $b2 $dirDos } catch { Add-Content -LiteralPath $logf -Value ((Get-Date).ToString('yyyy-MM-dd HH:mm:ss') + ';' + $id + ';AUDIT;errore nel rapporto Gemini;;;;;;AVVISO') -Encoding UTF8 }
    Add-Content -LiteralPath $logf -Value ((Get-Date).ToString('yyyy-MM-dd HH:mm:ss') + ';' + $id + ';FINALE;' + $key + ';;;;;;SALVATO') -Encoding UTF8
  }
  foreach($x in @($a,$b1,$b2)){ if($x.rf){ Remove-Item -LiteralPath $x.rf -Force -ErrorAction SilentlyContinue } }
  Start-Sleep -Seconds $CFG.Pausa
}
Add-Content -LiteralPath $logf -Value ((Get-Date).ToString('yyyy-MM-dd HH:mm:ss') + ';-;-;fine ciclo (candidati esauriti o limite);;;;;;FINE') -Encoding UTF8
[void][SvegliaBG.Win]::SetThreadExecutionState([uint32]2147483648)
