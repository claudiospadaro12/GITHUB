# MARCATORE_VALIDA_CAND_ORO_v1
# Convalida dei candidati del pilota oro (V1 fuori campione 2023-2024; V2 le due meta del dentro campione 2013-2017 e 2018-2022) nel MT5 PORTABLE C:\MT5_BCM_Opt: C0 (GTP E di Wim) e 10 candidati della seconda griglia valida (regola: i 10 migliori per rendimento/DD fra le combinazioni distinte senza scadenza). 33 passate singole, XAUUSD D1, Modello 1, 100000 EUR, lotto 0,1, TUTTI gli input in [TesterInputs] (dal set OPT2_ORO.set con i 4 valori del candidato).
# Scrive SOLO dentro C:\MT5_BCM_Opt (report .htm, log del tester) e .ini in %TEMP%\abtg_opt_oro. NON tocca altri terminali, conti, VPS, FTMO, AppData.
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
$W=Join-Path $env:TEMP 'abtg_opt_oro'; New-Item -ItemType Directory -Force -Path $W | Out-Null
$cands=@(
 @{ n='C0'; md='550'; ex='480'; st='600'; li='1700' },
 @{ n='C1'; md='750'; ex='384'; st='750'; li='2500' },
 @{ n='C2'; md='550'; ex='384'; st='750'; li='2500' },
 @{ n='C3'; md='650'; ex='384'; st='750'; li='2500' },
 @{ n='C4'; md='450'; ex='384'; st='750'; li='2500' },
 @{ n='C5'; md='550'; ex='384'; st='750'; li='2100' },
 @{ n='C6'; md='750'; ex='384'; st='900'; li='2500' },
 @{ n='C7'; md='650'; ex='384'; st='750'; li='2100' },
 @{ n='C8'; md='750'; ex='384'; st='750'; li='2100' },
 @{ n='C9'; md='450'; ex='384'; st='750'; li='2100' },
 @{ n='C10'; md='550'; ex='384'; st='900'; li='2500' }
)
$finestre=@( @{ n='OOS'; da='2023.01.01'; a='2024.12.31' }, @{ n='H1'; da='2013.01.01'; a='2017.12.31' }, @{ n='H2'; da='2018.01.01'; a='2022.12.31' } )
function Num([string]$s){ $c=($s -replace '[^0-9.\-]',''); $v=0.0; if([double]::TryParse($c,[Globalization.NumberStyles]::Float,[Globalization.CultureInfo]::InvariantCulture,[ref]$v)){ return $v } else { return [double]::NaN } }
function Valori($cd){ $o=@(); foreach($b in $base){ $x=$b; $m=[regex]::Match($b,'^(?<n>[A-Za-z0-9_]+)=(?<v>[^|]*)(?<r>\|\|.*)$'); if($m.Success){ $nm=$m.Groups['n'].Value; $nv=$null; if($nm -eq 'ST1_MinDist_to_HL'){ $nv=$cd.md } elseif($nm -eq 'ST1_Expiration_hours'){ $nv=$cd.ex } elseif($nm -eq 'Exit_stop'){ $nv=$cd.st } elseif($nm -eq 'Exit_limit'){ $nv=$cd.li }; if($nv -ne $null){ $x=$nm + '=' + $nv + $m.Groups['r'].Value } }; $o += $x }; return $o }
function Passata([string]$nome,$cd,$fi){
  $rep='VCO_' + $nome; $ini=Join-Path $W ($rep + '.ini')
  $r=@('[Experts]','AllowLiveTrading=false','AllowDllImport=false','','[Tester]','Expert=WIM\Ultimate_Breakout_EA_WSC_V9.5.ex5','Symbol=XAUUSD','Period=D1','Model=1','Optimization=0',('FromDate=' + $fi.da),('ToDate=' + $fi.a),'ForwardMode=0','Deposit=100000','Currency=EUR','Leverage=100','ExecutionMode=0','Visual=0','ReplaceReport=1','ShutdownTerminal=1',('Report=' + $rep),'','[TesterInputs]'); $r += (Valori $cd)
  Set-Content -LiteralPath $ini -Value (($r -join "`r`n") + "`r`n") -Encoding ASCII -NoNewline
  Remove-Item -LiteralPath ('C:\MT5_BCM_Opt\' + $rep + '.htm') -Force -ErrorAction SilentlyContinue
  $t0=Get-Date; $p=Start-Process -FilePath $T -ArgumentList ('/portable /config:"' + $ini + '"') -PassThru
  $scade=$t0.AddMinutes(40); while(-not $p.HasExited -and (Get-Date) -lt $scade){ Start-Sleep -Seconds 4 }
  if(-not $p.HasExited){ Write-Host ('TIMEOUT: terminale PID ' + $p.Id + ' ancora aperto: chiudilo a mano.') -ForegroundColor Red; return $null }
  $rf=Join-Path 'C:\MT5_BCM_Opt' ($rep + '.htm'); if(-not (Test-Path -LiteralPath $rf)){ return $null }
  $b=[IO.File]::ReadAllBytes($rf); $tx=$(if($b.Length -ge 2 -and (($b[0] -eq 255 -and $b[1] -eq 254) -or ($b[0] -eq 254 -and $b[1] -eq 255))){ [Text.Encoding]::Unicode.GetString($b) } else { [Text.Encoding]::UTF8.GetString($b) })
  $tx=[regex]::Replace($tx,'<[^>]*>','|'); $tx=[regex]::Replace($tx,'\s*\|[\s|]*','|')
  $g1=[regex]::Match($tx,'Profitto Totale Netto:\|([^|]*)\|'); $g2=[regex]::Match($tx,'Numero di Operazioni di Trading Totali:\|([^|]*)\|'); $g3=[regex]::Match($tx,'Fattore di Profitto:\|([^|]*)\|'); $g4=[regex]::Match($tx,'Drawdown Massima:\|([^|]*)\|'); $g5=[regex]::Match($tx,'Fattore di Recupero:\|([^|]*)\|')
  return ('' + $(if($g1.Success){ Num $g1.Groups[1].Value } else { 'NA' }) + ';' + $(if($g2.Success){ Num $g2.Groups[1].Value } else { 'NA' }) + ';' + $(if($g3.Success){ Num $g3.Groups[1].Value } else { 'NA' }) + ';' + $(if($g4.Success){ $g4.Groups[1].Value -replace ' ','' } else { 'NA' }) + ';' + $(if($g5.Success){ Num $g5.Groups[1].Value } else { 'NA' }))
}
$t00=Get-Date
Write-Host ('=== CONVALIDA ORO: ' + $cands.Count + ' candidati x 3 finestre = ' + ($cands.Count*3) + ' passate. Ora italiana all avvio: ' + $t00.ToString('dd/MM/yyyy HH:mm') + '. Durata attesa 45-90 minuti (STIMA). Date del server BCM (GMT+1 fisso). ===') -ForegroundColor Cyan
Write-Host 'Colonne: candidato;finestra;MinDist;Scadenza;Stop;Limit;profitto;operazioni;PF;DD massima equity;fattore di recupero' -ForegroundColor Gray
$out=New-Object System.Collections.ArrayList; $n=0
foreach($cd in $cands){ foreach($fi in $finestre){
  $n=$n+1; $res=Passata ($cd.n + '_' + $fi.n) $cd $fi
  $riga=($cd.n + ';' + $fi.n + ';' + $cd.md + ';' + $cd.ex + ';' + $cd.st + ';' + $cd.li + ';' + $(if($res){ $res } else { 'ERRORE;;;;' }))
  [void]$out.Add($riga); Write-Host ('[' + (Get-Date).ToString('HH:mm') + ' ' + $n + '/' + ($cands.Count*3) + '] ' + $riga) -ForegroundColor Green
} }
[void][MasterSveglia.Win]::SetThreadExecutionState([uint32]2147483648)
Write-Host '=== FINE ===' -ForegroundColor Cyan
try { Set-Clipboard -Value ($out -join "`r`n"); Write-Host 'Tabella COPIATA negli appunti: incollala nella chat con Ctrl+V.' -ForegroundColor Green } catch { Write-Host 'Appunti non disponibili: mandami la foto.' -ForegroundColor Yellow }
Write-Host ('Fine alle ' + (Get-Date).ToString('dd/MM/yyyy HH:mm') + ' (ora italiana).') -ForegroundColor Cyan
