# MARCATORE_AVVIA_OTT_ORO_FTMO_v1
# Griglia di ottimizzazione del pilota oro SUI DATI FTMO (terminale Mt5_Ftmo_Prova, server FTMO-Demo, storico dal 2015): EA WIM\Ultimate_Breakout_EA_WSC_V9.5, XAUUSD D1, 2015-01-01 -> 2022-12-31, Modello 1, 100000 EUR, lotto 0,1, TUTTI gli input in [TesterInputs] (dal set OPT2_ORO.set del portable), 4 parametri liberi con 5 valori ciascuno (625 passaggi): ST1_MinDist_to_HL 350-750 passo 100; ST1_Expiration_hours 96-480 passo 96; Exit_stop 450-1050 passo 150; Exit_limit 1300-2900 passo 400. Il centro (550/480/600/1700) e il GTP E di Wim. Regole nella sezione 18 dei criteri.
# Sequenza: 1) controllo del login (avvisa se e il conto della challenge); 2) passata singola di CONTROLLO bloccante (deve dare 3573,72 / 139 operazioni = V6 di C0 su FTMO); 3) griglia, con segnale di fine; MT5 resta aperto (esporti tu l'XML).
# Scrive SOLO nei dati di Mt5_Ftmo_Prova (report, log, cache dell'ottimizzazione) e .ini in %TEMP%\abtg_opt_oro. NON tocca BCM, conti, VPS. Il tester NON invia ordini; AllowLiveTrading=false. Tiene sveglio il PC finche la finestra e aperta.
$ErrorActionPreference='Continue'
if($env:COMPUTERNAME -ne 'DESKTOP-H4D7CAJ'){ Write-Host ('SOLO sul PC di backtest DESKTOP-H4D7CAJ. Qui: ' + $env:COMPUTERNAME) -ForegroundColor Red; return }
$FT='C:\MT5_Backtest\Mt5_Ftmo_Prova'; $FTE=Join-Path $FT 'terminal64.exe'; $SET='C:\MT5_BCM_Opt\MQL5\Profiles\Tester\OPT2_ORO.set'
$aperti=@(Get-Process -Name terminal64,metatester64,metaeditor64 -ErrorAction SilentlyContinue)
if($aperti.Count -gt 0){ $aperti | Select-Object Id,ProcessName,Path | Format-Table -AutoSize | Out-String | Write-Host; Write-Host 'MI FERMO: ci sono MT5, MetaEditor o agenti del tester aperti. Chiudili e rilancia. Non ho avviato niente.' -ForegroundColor Red; return }
foreach($pp in @($FTE,$SET)){ if(-not (Test-Path -LiteralPath $pp)){ Write-Host ('MI FERMO: non trovo ' + $pp) -ForegroundColor Red; return } }
$fdata=$null; $baseT=Join-Path $env:APPDATA 'MetaQuotes\Terminal'
foreach($o in @(Get-ChildItem -LiteralPath $baseT -Directory -ErrorAction SilentlyContinue)){ $of=Join-Path $o.FullName 'origin.txt'; if(Test-Path -LiteralPath $of){ $c=((Get-Content -LiteralPath $of -Raw -Encoding Unicode) -replace '[\r\n\0]','').Trim(); if($c -eq $FT){ $fdata=$o.FullName } } }
if(-not $fdata){ Write-Host 'MI FERMO: non trovo la cartella dati di Mt5_Ftmo_Prova.' -ForegroundColor Red; return }
if(-not (Test-Path -LiteralPath (Join-Path $fdata 'MQL5\Experts\WIM\Ultimate_Breakout_EA_WSC_V9.5.ex5'))){ Write-Host 'MI FERMO: l EA non e nel terminale FTMO (rilancia PROVA_FTMO_ORO).' -ForegroundColor Red; return }
$fci=Join-Path $fdata 'config\common.ini'; $bci=[IO.File]::ReadAllBytes($fci); $tci=$(if($bci.Length -ge 2 -and $bci[0] -eq 255 -and $bci[1] -eq 254){ [Text.Encoding]::Unicode.GetString($bci) } else { [Text.Encoding]::UTF8.GetString($bci) })
$lg=[regex]::Match($tci,'(?m)^Login=(\d+)'); $sv=[regex]::Match($tci,'(?m)^Server=(.*)$')
if(-not $lg.Success){ Write-Host 'MI FERMO: nel terminale FTMO non c e un login salvato.' -ForegroundColor Red; return }
$ln=$lg.Groups[1].Value; Write-Host ('Terminale FTMO di prova: server ' + $sv.Groups[1].Value.Trim() + ', login ' + $ln.Substring(0,3) + '...' + $ln.Substring($ln.Length-2) + ' (' + $ln.Length + ' cifre)') -ForegroundColor Cyan
if($ln -eq '1515150476'){ Write-Host 'ATTENZIONE: questo login e il conto della CHALLENGE reale (lo stesso del Guardian sul VPS). Il tester non invia ordini, ma e meglio usare un conto FTMO Free Trial separato.' -ForegroundColor Yellow; $r0=Read-Host 'Scrivi SI e premi INVIO per continuare comunque, altrimenti chiudi la finestra'; if($r0 -ne 'SI'){ Write-Host 'Fermato su tua richiesta. Non ho avviato niente.' -ForegroundColor Red; return } }
if(-not ('MasterSveglia.Win' -as [type])){ Add-Type -Namespace MasterSveglia -Name Win -MemberDefinition '[DllImport("kernel32.dll")] public static extern uint SetThreadExecutionState(uint esFlags);' }
[void][MasterSveglia.Win]::SetThreadExecutionState([uint32]2147483651)
$sb=[IO.File]::ReadAllBytes($SET); $st=$(if($sb.Length -ge 2 -and $sb[0] -eq 255 -and $sb[1] -eq 254){ [Text.Encoding]::Unicode.GetString($sb) } else { [Text.Encoding]::UTF8.GetString($sb) })
$NUOVI=@{ 'ST1_MinDist_to_HL'=@('550','350','100','750'); 'ST1_Expiration_hours'=@('480','96','96','480'); 'Exit_stop'=@('600','450','150','1050'); 'Exit_limit'=@('1700','1300','400','2900') }
$tutte=@(); $ys=@()
foreach($r in ($st -split "`r?`n")){ $x=$r.Trim([char]0xFEFF).Trim(); if($x -ne '' -and -not $x.StartsWith(';') -and $x.Contains('=')){
  $m=[regex]::Match($x,'^(?<n>[A-Za-z0-9_]+)=(?<v>[^|]*)\|\|(?<a>[^|]*)\|\|(?<s>[^|]*)\|\|(?<z>[^|]*)\|\|(?<f>[YN])$')
  if($m.Success){ $nm=$m.Groups['n'].Value
    if($NUOVI.ContainsKey($nm)){ $vv=$NUOVI[$nm]; if($m.Groups['v'].Value -ne $vv[0]){ Write-Host ('MI FERMO: ' + $nm + ' nel set vale ' + $m.Groups['v'].Value + ' invece di ' + $vv[0]) -ForegroundColor Red; return }; $x=$nm + '=' + $vv[0] + '||' + $vv[1] + '||' + $vv[2] + '||' + $vv[3] + '||Y'; $ys += $x }
    else { $x=$nm + '=' + $m.Groups['v'].Value + '||' + $m.Groups['a'].Value + '||' + $m.Groups['s'].Value + '||' + $m.Groups['z'].Value + '||N' } }
  $tutte += $x } }
if($ys.Count -ne 4){ Write-Host ('MI FERMO: i parametri attivi sono ' + $ys.Count + ' invece di 4.') -ForegroundColor Red; return }
if(@($tutte | Where-Object { $_ -match '^Risk=0\|\|' }).Count -ne 1 -or @($tutte | Where-Object { $_ -match '^StartLots=0\.1\|\|' }).Count -ne 1){ Write-Host 'MI FERMO: nel set Risk non e 0 o StartLots non e 0.1.' -ForegroundColor Red; return }
$W=Join-Path $env:TEMP 'abtg_opt_oro'; New-Item -ItemType Directory -Force -Path $W | Out-Null
function Num([string]$s){ $c=($s -replace '[^0-9.\-]',''); $v=0.0; if([double]::TryParse($c,[Globalization.NumberStyles]::Float,[Globalization.CultureInfo]::InvariantCulture,[ref]$v)){ return $v } else { return [double]::NaN } }
function Ini([string]$nome,[int]$ott,[string]$shut){
  $ini=Join-Path $W ($nome + '.ini')
  $r=@('[Experts]','AllowLiveTrading=false','AllowDllImport=false','','[Tester]','Expert=WIM\Ultimate_Breakout_EA_WSC_V9.5.ex5','Symbol=XAUUSD','Period=D1','Model=1',('Optimization=' + $ott)); if($ott -eq 1){ $r += 'OptimizationCriterion=6' }
  $r += @('FromDate=2015.01.01','ToDate=2022.12.31','ForwardMode=0','Deposit=100000','Currency=EUR','Leverage=100','ExecutionMode=0','Visual=0','UseLocal=1','UseRemote=0','UseCloud=0','ReplaceReport=1',('ShutdownTerminal=' + $shut)); if($ott -eq 0){ $r += ('Report=' + $nome) }; $r += @('','[TesterInputs]'); $r += $tutte
  Set-Content -LiteralPath $ini -Value (($r -join "`r`n") + "`r`n") -Encoding ASCII -NoNewline; return $ini }
Write-Host ('1/2 Passata di CONTROLLO (singola, dati FTMO 2015-2022): atteso 3573,72 / 139 operazioni (V6 di C0). Ora italiana: ' + (Get-Date).ToString('dd/MM/yyyy HH:mm')) -ForegroundColor Cyan
$iniC=Ini 'OTF_controllo' 0 '1'; Remove-Item -LiteralPath (Join-Path $fdata 'OTF_controllo.htm') -Force -ErrorAction SilentlyContinue
$t0=Get-Date; $p0=Start-Process -FilePath $FTE -ArgumentList ('/config:"' + $iniC + '"') -PassThru; $scade=$t0.AddMinutes(40); while(-not $p0.HasExited -and (Get-Date) -lt $scade){ Start-Sleep -Seconds 4 }
if(-not $p0.HasExited){ Write-Host 'TIMEOUT sulla passata di controllo: chiudi MT5 a mano. Non parte la griglia.' -ForegroundColor Red; return }
$rf=Join-Path $fdata 'OTF_controllo.htm'; if(-not (Test-Path -LiteralPath $rf)){ Write-Host 'MI FERMO: report di controllo non trovato. Non parte la griglia.' -ForegroundColor Red; return }
$b=[IO.File]::ReadAllBytes($rf); $tx=$(if($b.Length -ge 2 -and (($b[0] -eq 255 -and $b[1] -eq 254) -or ($b[0] -eq 254 -and $b[1] -eq 255))){ [Text.Encoding]::Unicode.GetString($b) } else { [Text.Encoding]::UTF8.GetString($b) }); $tx=[regex]::Replace($tx,'<[^>]*>','|'); $tx=[regex]::Replace($tx,'\s*\|[\s|]*','|')
$g1=[regex]::Match($tx,'Profitto Totale Netto:\|([^|]*)\|'); $g2=[regex]::Match($tx,'Numero di Operazioni di Trading Totali:\|([^|]*)\|'); $pf=$(if($g1.Success){ Num $g1.Groups[1].Value } else { [double]::NaN }); $po=$(if($g2.Success){ Num $g2.Groups[1].Value } else { [double]::NaN })
Write-Host ('   controllo: profitto ' + $pf + ', operazioni ' + $po + '   [atteso 3573,72 / 139]') -ForegroundColor Yellow
if([double]::IsNaN($pf) -or [math]::Abs($pf - 3573.72) -gt 0.5 -or $po -ne 139){ Write-Host 'MI FERMO: il controllo NON riproduce V6 (3573,72 / 139). Non parte la griglia: mandami questa schermata.' -ForegroundColor Red; [void][MasterSveglia.Win]::SetThreadExecutionState([uint32]2147483648); return }
Write-Host 'Il controllo riproduce V6: gli input sono corretti. Parte la griglia da 625 passaggi.' -ForegroundColor Green
$iniG=Ini 'OTF_griglia' 1 '0'; $ts=Get-Date
Write-Host ('=== GRIGLIA ORO SU DATI FTMO: XAUUSD D1, 2015-01-01 -> 2022-12-31, Modello 1, 625 passaggi. Avvio ' + $ts.ToString('dd/MM/yyyy HH:mm') + ' ora italiana. Durata attesa 4-8 ore (STIMA). Il passaggio CENTRALE (550/480/600/1700) deve valere 3573,72 / 139. ===') -ForegroundColor Cyan
$ys | ForEach-Object { Write-Host ('   ' + $_) -ForegroundColor Green }
Write-Host 'NON chiudere questa finestra e NON aprire altri MT5. A fine griglia il terminale FTMO resta aperto: esporti l XML (tasto destro sulla tabella > esporta).' -ForegroundColor Yellow
$pg=Start-Process -FilePath $FTE -ArgumentList ('/config:"' + $iniG + '"') -PassThru
$ultimo=0.0; $visto=$false; $zeri=0
while(-not $pg.HasExited){
  Start-Sleep -Seconds 600
  $ag=@(Get-Process -Name metatester64 -ErrorAction SilentlyContinue); $cpu=0.0; foreach($a in $ag){ try{ $cpu=$cpu+$a.TotalProcessorTime.TotalSeconds }catch{ } }
  $delta=$cpu-$ultimo; $ultimo=$cpu; $dur=((Get-Date)-$ts)
  Write-Host ('[' + (Get-Date).ToString('HH:mm') + ' ora italiana] trascorse ' + [math]::Floor($dur.TotalHours) + ' h ' + $dur.Minutes + ' min; agenti: ' + $ag.Count + $(if($delta -ge 0){ '; CPU agenti negli ultimi 10 min: ' + [math]::Round($delta) + ' s' } else { '' })) -ForegroundColor Gray
  if($ag.Count -gt 0){ $visto=$true; $zeri=0 } else { if($visto){ $zeri=$zeri+1 } }
  if($visto -and $zeri -ge 2){ Write-Host ('FINITA: gli agenti sono fermi dalle ultime due letture. Alle ' + (Get-Date).ToString('HH:mm') + ' esporta i risultati in XML dal terminale FTMO e mandameli. Poi chiudi MT5.') -ForegroundColor Green; break }
  if($dur.TotalHours -gt 12){ Write-Host 'Oltre 12 ore: non chiudo niente io. Guarda MT5 e dimmi.' -ForegroundColor Red; break }
}
[void][MasterSveglia.Win]::SetThreadExecutionState([uint32]2147483648)
Write-Host ('Fine controllo alle ' + (Get-Date).ToString('dd/MM/yyyy HH:mm') + ' (ora italiana).') -ForegroundColor Cyan
