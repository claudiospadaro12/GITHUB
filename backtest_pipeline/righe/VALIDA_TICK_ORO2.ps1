# MARCATORE_VALIDA_TICK_ORO2_v1
# V3 del pilota oro, 2a versione (la 1a: tick a qualita 95% e 3 passate M4 su 4 con 0 tick/0 operazioni: i tick locali iniziano a meta luglio 2024 e il tester prova a scaricare i giorni mancanti). Questa cerca la prima data di inizio con qualita >= 99% (prove SOLO su C0 e SOLO tick, poi nessun numero di merito usato per scegliere) e ripete le passate a 0 tick fino a 3 volte; stampa le righe dei giornali sui tick. (V3 del pilota oro: tick reali contro candele) nel MT5 PORTABLE C:\MT5_BCM_Opt: 4 finalisti (C0 = GTP E di Wim, C1, C5, C6), XAUUSD D1, finestra 2024-07-01 -> 2024-12-31 (UNICA: 2025 e 2026 sono hold-out e NON si toccano), Modello 1 (candele) e Modello 4 (tick reali), 100000 EUR, lotto 0,1, TUTTI gli input in [TesterInputs]. 8 passate. Prima copia dal terminale principale (SOLO LETTURA) i 6 file mensili dei tick 202407-202412 in C:\MT5_BCM_Opt.
# Scrive SOLO dentro C:\MT5_BCM_Opt (tick copiati, report .htm, log del tester) e .ini in %TEMP%\abtg_opt_oro. NON tocca altri terminali, conti, VPS, FTMO, AppData.
$ErrorActionPreference='Continue'
if($env:COMPUTERNAME -ne 'DESKTOP-H4D7CAJ'){ Write-Host ('SOLO sul PC di backtest DESKTOP-H4D7CAJ. Qui: ' + $env:COMPUTERNAME) -ForegroundColor Red; return }
$T='C:\MT5_BCM_Opt\terminal64.exe'; $EA='C:\MT5_BCM_Opt\MQL5\Experts\WIM\Ultimate_Breakout_EA_WSC_V9.5.ex5'; $HEA='AD2A7AC8C56E2756E4FE576F441227D11A2067B78F7BC4D200C76D111FD6EB4A'
$SET='C:\MT5_BCM_Opt\MQL5\Profiles\Tester\OPT2_ORO.set'
$aperti=@(Get-Process -Name terminal64,metatester64,metaeditor64 -ErrorAction SilentlyContinue)
if($aperti.Count -gt 0){ $aperti | Select-Object Id,ProcessName,Path | Format-Table -AutoSize | Out-String | Write-Host; Write-Host 'MI FERMO: ci sono MT5, MetaEditor o agenti del tester aperti (anche il MT5 portable rimasto aperto). Chiudili e rilancia. Non ho avviato niente.' -ForegroundColor Red; return }
foreach($pp in @($T,$EA,$SET)){ if(-not (Test-Path -LiteralPath $pp)){ Write-Host ('MI FERMO: non trovo ' + $pp) -ForegroundColor Red; return } }
$h=(Get-FileHash -LiteralPath $EA -Algorithm SHA256).Hash.ToUpperInvariant(); if($h -ne $HEA){ Write-Host ('MI FERMO: l EA ha SHA256 ' + $h) -ForegroundColor Red; return }
$sb=[IO.File]::ReadAllBytes($SET); $st=$(if($sb.Length -ge 2 -and $sb[0] -eq 255 -and $sb[1] -eq 254){ [Text.Encoding]::Unicode.GetString($sb) } else { [Text.Encoding]::UTF8.GetString($sb) })
$base=@(); foreach($r in ($st -split "`r?`n")){ $x=$r.Trim([char]0xFEFF).Trim(); if($x -ne '' -and -not $x.StartsWith(';') -and $x.Contains('=')){ $base += $x } }
if(@($base | Where-Object { $_ -match '^Risk=0\|\|' }).Count -ne 1 -or @($base | Where-Object { $_ -match '^StartLots=0\.1\|\|' }).Count -ne 1){ Write-Host 'MI FERMO: nel set Risk non e 0 o StartLots non e 0.1.' -ForegroundColor Red; return }
if(-not ('MasterSveglia.Win' -as [type])){ Add-Type -Namespace MasterSveglia -Name Win -MemberDefinition '[DllImport("kernel32.dll")] public static extern uint SetThreadExecutionState(uint esFlags);' }
[void][MasterSveglia.Win]::SetThreadExecutionState([uint32]2147483651)
$MAIN='C:\Users\Master\AppData\Roaming\MetaQuotes\Terminal\215D85D767A1C39E22D242C8114BF9F5'
$tsrc=Join-Path $MAIN 'bases\BCMMarkets-Server\ticks\XAUUSD'; $tdst='C:\MT5_BCM_Opt\bases\BCMMarkets-Server\ticks\XAUUSD'
if(-not (Test-Path -LiteralPath $tsrc)){ Write-Host ('MI FERMO: non trovo i tick sorgente ' + $tsrc) -ForegroundColor Red; return }
New-Item -ItemType Directory -Force -Path $tdst | Out-Null
foreach($mm in @('202407','202408','202409','202410','202411','202412')){ $f1=Join-Path $tsrc ($mm + '.tkc'); if(-not (Test-Path -LiteralPath $f1)){ Write-Host ('MI FERMO: manca il file tick ' + $f1) -ForegroundColor Red; return }; Copy-Item -LiteralPath $f1 -Destination $tdst -Force; $f2=Join-Path $tdst ($mm + '.tkc'); if((Get-Item -LiteralPath $f2).Length -ne (Get-Item -LiteralPath $f1).Length){ Write-Host ('ERRORE: dimensione diversa per ' + $mm) -ForegroundColor Red; return } }
Write-Host 'Tick 202407-202412 copiati nel portable (stessa dimensione dei file sorgente).' -ForegroundColor Green
$W=Join-Path $env:TEMP 'abtg_opt_oro'; New-Item -ItemType Directory -Force -Path $W | Out-Null
$cands=@(
 @{ n='C0'; md='550'; ex='480'; st='600'; li='1700' },
 @{ n='C1'; md='750'; ex='384'; st='750'; li='2500' },
 @{ n='C5'; md='550'; ex='384'; st='750'; li='2100' },
 @{ n='C6'; md='750'; ex='384'; st='900'; li='2500' }
)
function Num([string]$s){ $c=($s -replace '[^0-9.\-]',''); $v=0.0; if([double]::TryParse($c,[Globalization.NumberStyles]::Float,[Globalization.CultureInfo]::InvariantCulture,[ref]$v)){ return $v } else { return [double]::NaN } }
function Valori($cd){ $o=@(); foreach($b in $base){ $x=$b; $m=[regex]::Match($b,'^(?<n>[A-Za-z0-9_]+)=(?<v>[^|]*)(?<r>\|\|.*)$'); if($m.Success){ $nm=$m.Groups['n'].Value; $nv=$null; if($nm -eq 'ST1_MinDist_to_HL'){ $nv=$cd.md } elseif($nm -eq 'ST1_Expiration_hours'){ $nv=$cd.ex } elseif($nm -eq 'Exit_stop'){ $nv=$cd.st } elseif($nm -eq 'Exit_limit'){ $nv=$cd.li }; if($nv -ne $null){ $x=$nm + '=' + $nv + $m.Groups['r'].Value } }; $o += $x }; return $o }
function Passata([string]$nome,$cd,$fi){
  $rep='VTO_' + $nome; $ini=Join-Path $W ($rep + '.ini')
  $r=@('[Experts]','AllowLiveTrading=false','AllowDllImport=false','','[Tester]','Expert=WIM\Ultimate_Breakout_EA_WSC_V9.5.ex5','Symbol=XAUUSD','Period=D1',('Model=' + $fi.mo),'Optimization=0',('FromDate=' + $fi.da),('ToDate=' + $fi.a),'ForwardMode=0','Deposit=100000','Currency=EUR','Leverage=100','ExecutionMode=0','Visual=0','ReplaceReport=1','ShutdownTerminal=1',('Report=' + $rep),'','[TesterInputs]'); $r += (Valori $cd)
  Set-Content -LiteralPath $ini -Value (($r -join "`r`n") + "`r`n") -Encoding ASCII -NoNewline
  Remove-Item -LiteralPath ('C:\MT5_BCM_Opt\' + $rep + '.htm') -Force -ErrorAction SilentlyContinue
  $t0=Get-Date; $p=Start-Process -FilePath $T -ArgumentList ('/portable /config:"' + $ini + '"') -PassThru
  $scade=$t0.AddMinutes(40); while(-not $p.HasExited -and (Get-Date) -lt $scade){ Start-Sleep -Seconds 4 }
  if(-not $p.HasExited){ Write-Host ('TIMEOUT: terminale PID ' + $p.Id + ' ancora aperto: chiudilo a mano.') -ForegroundColor Red; return $null }
  $rf=Join-Path 'C:\MT5_BCM_Opt' ($rep + '.htm'); if(-not (Test-Path -LiteralPath $rf)){ return $null }
  $b=[IO.File]::ReadAllBytes($rf); $tx=$(if($b.Length -ge 2 -and (($b[0] -eq 255 -and $b[1] -eq 254) -or ($b[0] -eq 254 -and $b[1] -eq 255))){ [Text.Encoding]::Unicode.GetString($b) } else { [Text.Encoding]::UTF8.GetString($b) })
  $tx=[regex]::Replace($tx,'<[^>]*>','|'); $tx=[regex]::Replace($tx,'\s*\|[\s|]*','|')
  $g1=[regex]::Match($tx,'Profitto Totale Netto:\|([^|]*)\|'); $g2=[regex]::Match($tx,'Numero di Operazioni di Trading Totali:\|([^|]*)\|'); $g3=[regex]::Match($tx,'Fattore di Profitto:\|([^|]*)\|'); $g4=[regex]::Match($tx,'Drawdown Massima:\|([^|]*)\|'); $g5=[regex]::Match($tx,'Fattore di Recupero:\|([^|]*)\|'); $g6=[regex]::Match($tx,'Qualit. dello Storico:\|([^|]*)\|'); $g7=[regex]::Match($tx,'Ticks:\|([^|]*)\|')
  return ('' + $(if($g6.Success){ $g6.Groups[1].Value -replace ' ','' } else { 'NA' }) + ';' + $(if($g7.Success){ $g7.Groups[1].Value -replace ' ','' } else { 'NA' }) + ';' + $(if($g1.Success){ Num $g1.Groups[1].Value } else { 'NA' }) + ';' + $(if($g2.Success){ Num $g2.Groups[1].Value } else { 'NA' }) + ';' + $(if($g3.Success){ Num $g3.Groups[1].Value } else { 'NA' }) + ';' + $(if($g4.Success){ $g4.Groups[1].Value -replace ' ','' } else { 'NA' }) + ';' + $(if($g5.Success){ Num $g5.Groups[1].Value } else { 'NA' }))
}
function Qn($res){ if(-not $res){ return @(0,0) }; $p=$res.Split(';'); $q=0.0; $k=0.0; $mq=[regex]::Match($p[0],'^([0-9.]+)'); if($mq.Success){ [void][double]::TryParse($mq.Groups[1].Value,[Globalization.NumberStyles]::Float,[Globalization.CultureInfo]::InvariantCulture,[ref]$q) }; $kk=($p[1] -replace '[^0-9]',''); if($kk -ne ''){ [void][double]::TryParse($kk,[Globalization.NumberStyles]::Float,[Globalization.CultureInfo]::InvariantCulture,[ref]$k) }; return @($q,$k) }
function LogTick($da){
  $n=0; $logs=@(Get-ChildItem -LiteralPath 'C:\MT5_BCM_Opt\Tester' -Recurse -File -Filter '*.log' -ErrorAction SilentlyContinue | Where-Object { $_.LastWriteTime -ge $da })
  foreach($lg in $logs){ $b=[IO.File]::ReadAllBytes($lg.FullName); $tl=$(if($b.Length -ge 2 -and $b[0] -eq 255 -and $b[1] -eq 254){ [Text.Encoding]::Unicode.GetString($b) } else { [Text.Encoding]::UTF8.GetString($b) }); foreach($r in ($tl -split "`r?`n")){ if($r -match '(?i)tick|connection|synchroniz|download|history quality|no data|not found'){ if($n -lt 14){ Write-Host ('      log: ' + $r.Trim()) -ForegroundColor DarkYellow; $n=$n+1 } } } }
}
$t00=Get-Date
Write-Host ('=== V3 ORO (2a versione): ' + $t00.ToString('dd/MM/yyyy HH:mm') + ' ora italiana. Durata attesa 40-100 minuti (STIMA). Date del server BCM (GMT+1 fisso). ===') -ForegroundColor Cyan
Write-Host 'Fase 1: cerco la prima data di inizio con qualita dei tick >= 99% (solo C0, solo tick).' -ForegroundColor Cyan
$DA=$null; $c0=$cands[0]
foreach($st0 in @('2024.07.10','2024.07.15','2024.07.22','2024.08.01')){
  $fi=@{ n='M4'; mo='4'; da=$st0; a='2024.12.31' }
  for($tent=1; $tent -le 2; $tent++){
    $t1=Get-Date; $res=Passata ('S_' + $st0.Replace('.','') + '_' + $tent) $c0 $fi; $qk=Qn $res
    Write-Host ('   inizio ' + $st0 + ' tentativo ' + $tent + ': qualita ' + $qk[0] + '%, tick ' + $qk[1]) -ForegroundColor Yellow
    if($qk[1] -gt 0){ break } else { LogTick $t1 }
  }
  if($qk[1] -gt 0 -and $qk[0] -ge 99){ $DA=$st0; break }
}
if(-not $DA){ Write-Host 'MI FERMO: nessuna data di inizio ha dato tick con qualita >= 99%. Mandami questa schermata (con le righe log): non uso i dati a qualita bassa senza dirtelo.' -ForegroundColor Red; [void][MasterSveglia.Win]::SetThreadExecutionState([uint32]2147483648); return }
Write-Host ('Finestra V3 definitiva: ' + $DA + ' -> 2024.12.31 (qualita tick >= 99%).') -ForegroundColor Green
Write-Host 'Colonne: candidato;modello(M1=candele,M4=tick reali);MinDist;Scadenza;Stop;Limit;qualita storico;tick;profitto;operazioni;PF;DD massima equity;fattore di recupero' -ForegroundColor Gray
$out=New-Object System.Collections.ArrayList; $out.Add('finestra;' + $DA + ';2024.12.31') | Out-Null; $n=0
foreach($cd in $cands){
  foreach($mo in @('1','4')){
    $fi=@{ n=('M' + $mo); mo=$mo; da=$DA; a='2024.12.31' }; $n=$n+1; $res=$null
    for($tent=1; $tent -le 3; $tent++){ $t1=Get-Date; $res=Passata ($cd.n + '_M' + $mo + '_' + $tent) $cd $fi; $qk=Qn $res; if($mo -eq '1' -or $qk[1] -gt 0){ break } else { Write-Host ('   ' + $cd.n + ' tick tentativo ' + $tent + ' senza tick: ripeto') -ForegroundColor Yellow; LogTick $t1 } }
    $riga=($cd.n + ';' + $fi.n + ';' + $cd.md + ';' + $cd.ex + ';' + $cd.st + ';' + $cd.li + ';' + $(if($res){ $res } else { 'ERRORE;;;;;;' }))
    [void]$out.Add($riga); Write-Host ('[' + (Get-Date).ToString('HH:mm') + ' ' + $n + '/' + ($cands.Count*2) + '] ' + $riga) -ForegroundColor Green
  }
}
[void][MasterSveglia.Win]::SetThreadExecutionState([uint32]2147483648)
Write-Host '=== FINE ===' -ForegroundColor Cyan
try { Set-Clipboard -Value ($out -join "`r`n"); Write-Host 'Tabella COPIATA negli appunti: incollala nella chat con Ctrl+V.' -ForegroundColor Green } catch { Write-Host 'Appunti non disponibili: mandami la foto.' -ForegroundColor Yellow }
Write-Host ('Fine alle ' + (Get-Date).ToString('dd/MM/yyyy HH:mm') + ' (ora italiana).') -ForegroundColor Cyan
