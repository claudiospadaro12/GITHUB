# MARCATORE_VALIDA_FTMO_ORO_v1
# V1/V2 del pilota oro SUI DATI FTMO (criteri sezione 18, scritti prima dei numeri): i candidati C0 + C1..C10 della griglia FTMO, XAUUSD D1, Modello 1, 100000 EUR, lotto 0,1, TUTTI gli input in [TesterInputs] (da OPT2_ORO.set con i 4 valori del candidato), su cinque finestre: IS15-18, IS19-22 (V2), OOS23-24 (V1), 2025 e 2026 (SOLO informative, gia viste). 55 passate, solo terminale Mt5_Ftmo_Prova.
# Scrive SOLO nei dati di Mt5_Ftmo_Prova (report, log) e .ini in %TEMP%\abtg_opt_oro. NON tocca BCM, altri terminali, conti, VPS. Il tester NON invia ordini; AllowLiveTrading=false. Tiene sveglio il PC.
$ErrorActionPreference='Continue'
if($env:COMPUTERNAME -ne 'DESKTOP-H4D7CAJ'){ Write-Host ('SOLO sul PC di backtest DESKTOP-H4D7CAJ. Qui: ' + $env:COMPUTERNAME) -ForegroundColor Red; return }
$FT='C:\MT5_Backtest\Mt5_Ftmo_Prova'; $FTE=Join-Path $FT 'terminal64.exe'
$SET='C:\MT5_BCM_Opt\MQL5\Profiles\Tester\OPT2_ORO.set'
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
$base=@(); foreach($r in ($st -split "`r?`n")){ $x=$r.Trim([char]0xFEFF).Trim(); if($x -ne '' -and -not $x.StartsWith(';') -and $x.Contains('=')){ $base += $x } }
if(@($base | Where-Object { $_ -match '^Risk=0\|\|' }).Count -ne 1 -or @($base | Where-Object { $_ -match '^StartLots=0\.1\|\|' }).Count -ne 1){ Write-Host 'MI FERMO: nel set Risk non e 0 o StartLots non e 0.1.' -ForegroundColor Red; return }
$W=Join-Path $env:TEMP 'abtg_opt_oro'; New-Item -ItemType Directory -Force -Path $W | Out-Null
$cands=@(
 @{ n='C0'; md='550'; ex='480'; st='600'; li='1700' },
 @{ n='C1'; md='650'; ex='480'; st='1050'; li='1700' },
 @{ n='C2'; md='550'; ex='480'; st='1050'; li='1700' },
 @{ n='C3'; md='450'; ex='480'; st='1050'; li='1700' },
 @{ n='C4'; md='650'; ex='480'; st='450'; li='1300' },
 @{ n='C5'; md='650'; ex='480'; st='600'; li='1700' },
 @{ n='C6'; md='650'; ex='480'; st='750'; li='1700' },
 @{ n='C7'; md='550'; ex='480'; st='600'; li='1700' },
 @{ n='C8'; md='450'; ex='480'; st='600'; li='1700' },
 @{ n='C9'; md='650'; ex='480'; st='450'; li='1700' },
 @{ n='C10'; md='350'; ex='480'; st='1050'; li='1700' }
)
$wins=@( @{ n='IS15-18'; da='2015.01.01'; a='2018.12.31' }, @{ n='IS19-22'; da='2019.01.01'; a='2022.12.31' }, @{ n='OOS23-24'; da='2023.01.01'; a='2024.12.31' }, @{ n='H25'; da='2025.01.01'; a='2025.12.31' }, @{ n='H26'; da='2026.01.01'; a='2026.10.31' } )
function Num([string]$s){ $c=($s -replace '[^0-9.\-]',''); $v=0.0; if([double]::TryParse($c,[Globalization.NumberStyles]::Float,[Globalization.CultureInfo]::InvariantCulture,[ref]$v)){ return $v } else { return [double]::NaN } }
function Valori($cd){ $o=@(); foreach($b in $base){ $x=$b; $m=[regex]::Match($b,'^(?<n>[A-Za-z0-9_]+)=(?<v>[^|]*)(?<r>\|\|.*)$'); if($m.Success){ $nm=$m.Groups['n'].Value; $nv=$null; if($nm -eq 'ST1_MinDist_to_HL'){ $nv=$cd.md } elseif($nm -eq 'ST1_Expiration_hours'){ $nv=$cd.ex } elseif($nm -eq 'Exit_stop'){ $nv=$cd.st } elseif($nm -eq 'Exit_limit'){ $nv=$cd.li }; if($nv -ne $null){ $x=$nm + '=' + $nv + $m.Groups['r'].Value } }; $o += $x }; return $o }
function Passata([string]$nome,[string]$trm,[bool]$portab,[string]$radice,$cd,$wn){
  $rep='VF_' + $nome; $ini=Join-Path $W ($rep + '.ini')
  $r=@('[Experts]','AllowLiveTrading=false','AllowDllImport=false','','[Tester]','Expert=WIM\Ultimate_Breakout_EA_WSC_V9.5.ex5','Symbol=XAUUSD','Period=D1','Model=1','Optimization=0',('FromDate=' + $wn.da),('ToDate=' + $wn.a),'ForwardMode=0','Deposit=100000','Currency=EUR','Leverage=100','ExecutionMode=0','Visual=0','ReplaceReport=1','ShutdownTerminal=1',('Report=' + $rep),'','[TesterInputs]'); $r += (Valori $cd)
  Set-Content -LiteralPath $ini -Value (($r -join "`r`n") + "`r`n") -Encoding ASCII -NoNewline
  Remove-Item -LiteralPath (Join-Path $radice ($rep + '.htm')) -Force -ErrorAction SilentlyContinue
  $ar=$(if($portab){ '/portable /config:"' + $ini + '"' } else { '/config:"' + $ini + '"' })
  $t0=Get-Date; $p=Start-Process -FilePath $trm -ArgumentList $ar -PassThru
  $scade=$t0.AddMinutes(40); while(-not $p.HasExited -and (Get-Date) -lt $scade){ Start-Sleep -Seconds 4 }
  if(-not $p.HasExited){ Write-Host ('TIMEOUT: terminale PID ' + $p.Id + ' ancora aperto: chiudilo a mano.') -ForegroundColor Red; return $null }
  $rf=Join-Path $radice ($rep + '.htm'); if(-not (Test-Path -LiteralPath $rf)){ return $null }
  $b=[IO.File]::ReadAllBytes($rf); $tx=$(if($b.Length -ge 2 -and (($b[0] -eq 255 -and $b[1] -eq 254) -or ($b[0] -eq 254 -and $b[1] -eq 255))){ [Text.Encoding]::Unicode.GetString($b) } else { [Text.Encoding]::UTF8.GetString($b) })
  $tx=[regex]::Replace($tx,'<[^>]*>','|'); $tx=[regex]::Replace($tx,'\s*\|[\s|]*','|')
  $g1=[regex]::Match($tx,'Profitto Totale Netto:\|([^|]*)\|'); $g2=[regex]::Match($tx,'Numero di Operazioni di Trading Totali:\|([^|]*)\|'); $g3=[regex]::Match($tx,'Fattore di Profitto:\|([^|]*)\|'); $g4=[regex]::Match($tx,'Drawdown Massima:\|([^|]*)\|'); $g6=[regex]::Match($tx,'Qualit. dello Storico:\|([^|]*)\|'); $g7=[regex]::Match($tx,'Barre:\|([^|]*)\|')
  return ('' + $(if($g6.Success){ $g6.Groups[1].Value -replace ' ','' } else { 'NA' }) + ';' + $(if($g7.Success){ $g7.Groups[1].Value -replace ' ','' } else { 'NA' }) + ';' + $(if($g1.Success){ Num $g1.Groups[1].Value } else { 'NA' }) + ';' + $(if($g2.Success){ Num $g2.Groups[1].Value } else { 'NA' }) + ';' + $(if($g3.Success){ Num $g3.Groups[1].Value } else { 'NA' }) + ';' + $(if($g4.Success){ $g4.Groups[1].Value -replace ' ','' } else { 'NA' }))
}
$t00=Get-Date
Write-Host ('=== VALIDAZIONE ORO SU DATI FTMO: 55 passate (11 candidati x 5 finestre). Ora italiana: ' + $t00.ToString('dd/MM/yyyy HH:mm') + '. Durata attesa 1-2 ore (STIMA). ===') -ForegroundColor Cyan
Write-Host 'Colonne: broker;candidato;finestra;qualita storico;barre;profitto;operazioni;PF;DD massima equity' -ForegroundColor Gray
$out=New-Object System.Collections.ArrayList; $n=0
foreach($wn in $wins){ foreach($cd in $cands){
  $n=$n+1
  $res=Passata ($cd.n + '_' + $wn.n) $FTE $false $fdata $cd $wn
  $riga=('FTMO;' + $cd.n + ';' + $wn.n + ';' + $(if($res){ $res } else { 'ERRORE;;;;;' }))
  [void]$out.Add($riga); Write-Host ('[' + (Get-Date).ToString('HH:mm') + ' ' + $n + '/55] ' + $riga) -ForegroundColor Green
} }
[void][MasterSveglia.Win]::SetThreadExecutionState([uint32]2147483648)
Write-Host '=== FINE ===' -ForegroundColor Cyan
try { Set-Clipboard -Value ($out -join "`r`n"); Write-Host 'Tabella COPIATA negli appunti: incollala nella chat con Ctrl+V.' -ForegroundColor Green } catch { Write-Host 'Appunti non disponibili: mandami la foto.' -ForegroundColor Yellow }
$dirR='C:\ABTG_RISULTATI'; if(-not (Test-Path -LiteralPath $dirR)){ New-Item -ItemType Directory -Force -Path $dirR | Out-Null }
$fo=Join-Path $dirR ('VALIDA_FTMO_ORO_' + (Get-Date).ToString('yyyyMMdd_HHmm') + '.csv')
Set-Content -LiteralPath $fo -Value (@('broker;candidato;finestra;qualita storico;barre;profitto;operazioni;PF;DD massima equity') + $out) -Encoding UTF8
Write-Host ('>>> ALLEGA QUESTO FILE: ' + $fo + ' <<<') -ForegroundColor Black -BackgroundColor Yellow
Start-Process explorer.exe -ArgumentList ('/select,"' + $fo + '"')
Write-Host ('Fine alle ' + (Get-Date).ToString('dd/MM/yyyy HH:mm') + ' (ora italiana).') -ForegroundColor Cyan
