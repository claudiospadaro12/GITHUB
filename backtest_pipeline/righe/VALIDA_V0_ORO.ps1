# MARCATORE_VALIDA_V0_ORO_v1
# V0 del pilota oro (riproduzione): 4 passate singole nel MT5 PORTABLE C:\MT5_BCM_Opt, XAUUSD D1, Modello 1, 100000 EUR, lotto 0,1. A) OPT2_ORO.set 2013-2022 (deve coincidere con il passaggio C0 della griglia: +1323,40, 286 operazioni, PF 1,65); B) GTP E originale 2013-2022; C) GTP E originale 2013-2018 (U5: 153 operazioni, +2242, PF 1,92); D) GTP E originale 2019-2025 (U5: 169 operazioni, +3873, PF 2,64).
# Scrive SOLO dentro C:\MT5_BCM_Opt (copia V0_GTP_E.set in Profiles\Tester, report .htm, log) e un .ini in %TEMP%\abtg_opt_oro. NON tocca altri terminali, conti, VPS, FTMO, AppData.
$ErrorActionPreference='Continue'
if($env:COMPUTERNAME -ne 'DESKTOP-H4D7CAJ'){ Write-Host ('SOLO sul PC di backtest DESKTOP-H4D7CAJ. Qui: ' + $env:COMPUTERNAME) -ForegroundColor Red; return }
$T='C:\MT5_BCM_Opt\terminal64.exe'; $EA='C:\MT5_BCM_Opt\MQL5\Experts\WIM\Ultimate_Breakout_EA_WSC_V9.5.ex5'; $HEA='AD2A7AC8C56E2756E4FE576F441227D11A2067B78F7BC4D200C76D111FD6EB4A'
$STD='C:\MT5_BCM_Opt\MQL5\Profiles\Tester'; $SORG=Join-Path $STD 'UBS_V9_0\Breakout_Support_Resistance\GOLD\Goldtrade Pro\GOLDTRADEPRO_E.set'; $SOPT=Join-Path $STD 'OPT2_ORO.set'
$aperti=@(Get-Process -Name terminal64,metatester64,metaeditor64 -ErrorAction SilentlyContinue)
if($aperti.Count -gt 0){ $aperti | Select-Object Id,ProcessName,Path | Format-Table -AutoSize | Out-String | Write-Host; Write-Host 'MI FERMO: ci sono MT5, MetaEditor o agenti del tester aperti. Chiudili (anche il MT5 portable rimasto aperto a fine ottimizzazione) e rilancia. Non ho avviato niente.' -ForegroundColor Red; return }
foreach($pp in @($T,$EA,$SORG,$SOPT)){ if(-not (Test-Path -LiteralPath $pp)){ Write-Host ('MI FERMO: non trovo ' + $pp + '. Non ho avviato niente.') -ForegroundColor Red; return } }
$h=(Get-FileHash -LiteralPath $EA -Algorithm SHA256).Hash.ToUpperInvariant(); if($h -ne $HEA){ Write-Host ('MI FERMO: l EA ha SHA256 ' + $h + ' invece di ' + $HEA + '. Non ho avviato niente.') -ForegroundColor Red; return }
Copy-Item -LiteralPath $SORG -Destination (Join-Path $STD 'V0_GTP_E.set') -Force
if(-not ('MasterSveglia.Win' -as [type])){ Add-Type -Namespace MasterSveglia -Name Win -MemberDefinition '[DllImport("kernel32.dll")] public static extern uint SetThreadExecutionState(uint esFlags);' }
[void][MasterSveglia.Win]::SetThreadExecutionState([uint32]2147483651)
$W=Join-Path $env:TEMP 'abtg_opt_oro'; New-Item -ItemType Directory -Force -Path $W | Out-Null
$casi=@(
 @{ n='A'; set='OPT2_ORO.set'; da='2013.01.01'; a='2022.12.31'; att='C0 della griglia: profitto 1323,40, 286 operazioni, PF 1,65, DD 0,20%' },
 @{ n='B'; set='V0_GTP_E.set'; da='2013.01.01'; a='2022.12.31'; att='deve coincidere con A se il set e caricato allo stesso modo' },
 @{ n='C'; set='V0_GTP_E.set'; da='2013.01.01'; a='2018.12.31'; att='U5 (pipeline principale): 153 operazioni, +2242, PF 1,92, DD 334 EUR' },
 @{ n='D'; set='V0_GTP_E.set'; da='2019.01.01'; a='2025.12.31'; att='U5 (pipeline principale): 169 operazioni, +3873, PF 2,64, DD 380 EUR' }
)
$esiti=@()
foreach($cs in $casi){
  $rep='V0_ORO_' + $cs.n; $ini=Join-Path $W ('v0_oro_' + $cs.n + '.ini')
  $righe=@('[Experts]','AllowLiveTrading=false','AllowDllImport=false','','[Tester]','Expert=WIM\Ultimate_Breakout_EA_WSC_V9.5.ex5',('ExpertParameters=' + $cs.set),'Symbol=XAUUSD','Period=D1','Model=1','Optimization=0',('FromDate=' + $cs.da),('ToDate=' + $cs.a),'ForwardMode=0','Deposit=100000','Currency=EUR','Leverage=100','ExecutionMode=0','Visual=0','ReplaceReport=1','ShutdownTerminal=1',('Report=' + $rep),'','[TesterInputs]')
  Set-Content -LiteralPath $ini -Value (($righe -join "`r`n") + "`r`n") -Encoding ASCII -NoNewline
  Remove-Item -LiteralPath ('C:\MT5_BCM_Opt\' + $rep + '.htm') -Force -ErrorAction SilentlyContinue
  $t0=Get-Date
  Write-Host ('[' + $t0.ToString('HH:mm:ss') + ' ora italiana] passata ' + $cs.n + ': set ' + $cs.set + ', ' + $cs.da + ' -> ' + $cs.a + ' (date del server BCM, GMT+1 fisso)') -ForegroundColor Cyan
  $p=Start-Process -FilePath $T -ArgumentList ('/portable /config:"' + $ini + '"') -PassThru
  $scade=$t0.AddMinutes(40)
  while(-not $p.HasExited -and (Get-Date) -lt $scade){ Start-Sleep -Seconds 5 }
  if(-not $p.HasExited){ Write-Host ('TIMEOUT dopo 40 minuti: il terminale PID ' + $p.Id + ' e ancora aperto: chiudilo a mano e dimmelo.') -ForegroundColor Red; break }
  $rf=Join-Path 'C:\MT5_BCM_Opt' ($rep + '.htm'); $riga=('passata ' + $cs.n + ': REPORT NON TROVATO')
  if(Test-Path -LiteralPath $rf){
    $b=[IO.File]::ReadAllBytes($rf); $tx=$(if($b.Length -ge 2 -and (($b[0] -eq 255 -and $b[1] -eq 254) -or ($b[0] -eq 254 -and $b[1] -eq 255))){ [Text.Encoding]::Unicode.GetString($b) } else { [Text.Encoding]::UTF8.GetString($b) })
    $tx=[regex]::Replace($tx,'<[^>]*>','|'); $tx=[regex]::Replace($tx,'\s*\|[\s|]*','|')
    $vv=@()
    foreach($k in @('Qualit. dello Storico:','Profitto Totale Netto:','Fattore di Profitto:','Numero di Operazioni di Trading Totali:')){ $m=[regex]::Match($tx,($k -replace '\.','.')+'\|([^|]*)\|'); $vv += ($k + ' ' + $(if($m.Success){$m.Groups[1].Value}else{'(non letto)'})) }
    $dd=@([regex]::Matches($tx,'(Drawdown[^|:]*:)\|([^|]*)\|') | Select-Object -First 4 | ForEach-Object { $_.Groups[1].Value + ' ' + $_.Groups[2].Value })
    $riga=('passata ' + $cs.n + ' (' + $cs.da + '-' + $cs.a + ', ' + $cs.set + '): ' + ($vv -join ' | ') + ' | ' + ($dd -join ' | '))
  }
  Write-Host ('   ' + $riga) -ForegroundColor Green
  Write-Host ('   atteso: ' + $cs.att) -ForegroundColor Yellow
  $esiti += $riga; $esiti += ('   atteso: ' + $cs.att)
}
[void][MasterSveglia.Win]::SetThreadExecutionState([uint32]2147483648)
Write-Host '=== RIEPILOGO V0 ===' -ForegroundColor Cyan
$esiti | ForEach-Object { Write-Host $_ }
try { Set-Clipboard -Value ($esiti -join "`r`n"); Write-Host 'Riepilogo COPIATO negli appunti: incollalo nella chat con Ctrl+V.' -ForegroundColor Green } catch { Write-Host 'Appunti non disponibili: mandami la foto.' -ForegroundColor Yellow }
Write-Host ('Fine alle ' + (Get-Date).ToString('dd/MM/yyyy HH:mm') + ' (ora italiana).') -ForegroundColor Cyan
