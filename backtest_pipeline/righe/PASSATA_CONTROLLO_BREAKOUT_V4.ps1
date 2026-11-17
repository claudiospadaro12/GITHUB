# MARCATORE_PASSATA_CONTROLLO_BREAKOUT_v4
# Passata di CONTROLLO v4 del breakout oro: (1) scarica Template_EA_Wim.mq5 v1.02 (riarmo con ripetizione) dal repository (commit 80e1c5b10a3b2bb944f0d21a7a6b787afcc35357, SHA256 verificato), (2) lo compila nel BCM portable (C:\MT5_BCM_Opt), (3) UNA passata del tester XAUUSD D1, 2019-01-01 -> 2019-03-01, Modello 1, 100000 EUR, lotto 0,1, InpDebug=true, (4) scrive sul Desktop RIEPILOGO_CONTROLLO_BREAKOUT_v4.txt con ordini, operazioni e le righe TPL_WIM del Journal del tester.
# Scopo: capire perche i pendenti vengono rimessi solo di domenica 23:05 e lunedi 00:00 e non da martedi a venerdi. Nessun numero si usa per scegliere set. Il tester NON invia ordini ai conti (AllowLiveTrading=false). Non chiude MT5 con la forza.
$ErrorActionPreference='Continue'
$ci=[Globalization.CultureInfo]::InvariantCulture
if($env:COMPUTERNAME -ne 'DESKTOP-H4D7CAJ'){ Write-Host ('SOLO sul PC di backtest DESKTOP-H4D7CAJ. Qui: ' + $env:COMPUTERNAME) -ForegroundColor Red; return }
$TRM='C:\MT5_BCM_Opt\terminal64.exe'; $DATI='C:\MT5_BCM_Opt'; $MEE=Join-Path $DATI 'metaeditor64.exe'; $MQL5=Join-Path $DATI 'MQL5'
$aperti=@(Get-Process -Name terminal64,metatester64,metaeditor64 -ErrorAction SilentlyContinue)
if($aperti.Count -gt 0){ $aperti | Select-Object Id,ProcessName,Path | Format-Table -AutoSize | Out-String | Write-Host; Write-Host 'MI FERMO: MT5, MetaEditor o agenti aperti. Chiudili e rilancia. Non ho avviato niente.' -ForegroundColor Red; return }
foreach($pp in @($TRM,$MEE)){ if(-not (Test-Path -LiteralPath $pp)){ Write-Host ('MI FERMO: non trovo ' + $pp) -ForegroundColor Red; return } }
# 1) sorgente dal repository, con controllo SHA256
$PIN1='80e1c5b10a3b2bb944f0d21a7a6b787afcc35357'; $SHAT='302243955DDB35FD16FC0F18037264777FBD98A9EEA6CE46142BC1936BDDED84'
$srcTmp=Join-Path $env:TEMP 'Template_EA_Wim_v102.mq5'; Remove-Item -LiteralPath $srcTmp -Force -ErrorAction SilentlyContinue
irm ('https://raw.githubusercontent.com/claudiospadaro12/GITHUB/' + $PIN1 + '/backtest_runner/Template_EA_Wim.mq5?cb=' + [Guid]::NewGuid().ToString('N')) -OutFile $srcTmp
$HT=(Get-FileHash -LiteralPath $srcTmp -Algorithm SHA256).Hash.ToUpperInvariant()
if($HT -ne $SHAT){ Write-Host ('MI FERMO: SHA256 del sorgente diverso: ' + $HT) -ForegroundColor Red; return }
# 2) compilazione
$dstDir=Join-Path $MQL5 'Experts\CLAU12'; New-Item -ItemType Directory -Force -Path $dstDir | Out-Null
$dst=Join-Path $dstDir 'Template_EA_Wim.mq5'; Copy-Item -LiteralPath $srcTmp -Destination $dst -Force
$logc=Join-Path $env:TEMP 'compila_v4.log'; Remove-Item -LiteralPath $logc -Force -ErrorAction SilentlyContinue
$ex5=[IO.Path]::ChangeExtension($dst,'.ex5'); Remove-Item -LiteralPath $ex5 -Force -ErrorAction SilentlyContinue
[void](Start-Process -FilePath $MEE -ArgumentList ('/portable /compile:"' + $dst + '" /include:"' + $MQL5 + '" /log:"' + $logc + '"') -PassThru -Wait)
if(-not (Test-Path -LiteralPath $logc)){ Write-Host 'Nessun log di compilazione.' -ForegroundColor Red; return }
$bc=[IO.File]::ReadAllBytes($logc); $txc=$(if($bc.Length -ge 2 -and $bc[0] -eq 255 -and $bc[1] -eq 254){ [Text.Encoding]::Unicode.GetString($bc) } else { [Text.Encoding]::UTF8.GetString($bc) })
if(-not ((Test-Path -LiteralPath $ex5) -and ($txc -match 'Result:\s*0 errors'))){ Write-Host 'COMPILAZIONE NON RIUSCITA: incollami queste righe.' -ForegroundColor Red; ($txc -split "`r?`n" | Where-Object { $_ -match 'error' }) | ForEach-Object { Write-Host ('   ' + $_) }; return }
Write-Host ('COMPILATO v1.02: ' + $ex5) -ForegroundColor Green
# 3) passata
if(-not ('SvegliaCtl.Win' -as [type])){ Add-Type -Namespace SvegliaCtl -Name Win -MemberDefinition '[DllImport("kernel32.dll")] public static extern uint SetThreadExecutionState(uint esFlags);' }
[void][SvegliaCtl.Win]::SetThreadExecutionState([uint32]2147483651)
$IN=@(
  'InpMagic=880001',
  'InpComment=TPL_WIM',
  'InpDebug=true',
  'InpLevelTF=16408',
  'InpCountback=10',
  'InpUsePivots=false',
  'InpHLStrengthL=3',
  'InpHLStrengthR=2',
  'InpMinDistLevelAtr=0.2',
  'InpOffsetAtr=0.1',
  'InpEntryMode=0',
  'InpExpirationBars=3',
  'InpRetestMaxBars=6',
  'InpRetestTolAtr=0.15',
  'InpSLMode=0',
  'InpSLAtr=1.0',
  'InpSLPts=400',
  'InpTPMode=0',
  'InpTP_RR=1.5',
  'InpTPAtr=3.0',
  'InpTPPts=800',
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
$W=Join-Path $env:TEMP 'ctrl_breakout'; New-Item -ItemType Directory -Force -Path $W | Out-Null
$rep='CTRL_BREAKOUT_V4'
$r=@('[Experts]','AllowLiveTrading=false','AllowDllImport=false','','[Tester]','Expert=CLAU12\Template_EA_Wim.ex5','Symbol=XAUUSD','Period=D1','Model=1','Optimization=0','FromDate=2019.01.01','ToDate=2019.03.01','ForwardMode=0','Deposit=100000','Currency=EUR','Leverage=100','ExecutionMode=0','Visual=0','ReplaceReport=1','ShutdownTerminal=1',('Report=' + $rep),'','[TesterInputs]'); $r += $IN
$ini=Join-Path $W ($rep + '.ini'); Set-Content -LiteralPath $ini -Value (($r -join "`r`n") + "`r`n") -Encoding ASCII -NoNewline
$rf=Join-Path $DATI ($rep + '.htm'); Remove-Item -LiteralPath $rf -Force -ErrorAction SilentlyContinue
Write-Host ('Passata avviata alle ' + (Get-Date).ToString('dd/MM/yyyy HH:mm') + ' (ora italiana). Durata attesa 1-2 minuti (STIMA).') -ForegroundColor Cyan
$t0=Get-Date; $pr=Start-Process -FilePath $TRM -ArgumentList ('/portable /config:"' + $ini + '"') -PassThru
$scade=$t0.AddMinutes(30); while(-not $pr.HasExited -and (Get-Date) -lt $scade){ Start-Sleep -Seconds 4 }
[void][SvegliaCtl.Win]::SetThreadExecutionState([uint32]2147483648)
if(-not $pr.HasExited){ Write-Host 'TIMEOUT: terminale ancora aperto. Non lo chiudo io.' -ForegroundColor Red; return }
$out=New-Object System.Collections.ArrayList
[void]$out.Add('=== CONTROLLO v4 (BCM portable, XAUUSD D1, 2019-01-01 -> 2019-03-01, Modello 1, InpDebug=true) ===')
# 4a) report
if(Test-Path -LiteralPath $rf){
  $b=[IO.File]::ReadAllBytes($rf); $html=$(if($b.Length -ge 2 -and (($b[0] -eq 255 -and $b[1] -eq 254) -or ($b[0] -eq 254 -and $b[1] -eq 255))){ [Text.Encoding]::Unicode.GetString($b) } else { [Text.Encoding]::UTF8.GetString($b) })
  $righe=[regex]::Split($html,'(?i)<tr'); $inDeals=$false
  foreach($rg in $righe){
    $celle=@(); foreach($mc in [regex]::Matches($rg,'(?is)<t[dh][^>]*>(.*?)</t[dh]>')){ $celle += (([regex]::Replace($mc.Groups[1].Value,'<[^>]*>','') -replace '&nbsp;',' ' -replace '\s+',' ').Trim()) }
    if($celle.Count -lt 8){ continue }
    $p=-1; $c=-1; $sw=-1
    for($i=0; $i -lt $celle.Count; $i++){ if($celle[$i] -match '^(Profit|Profitto|Utile)$'){ $p=$i } elseif($celle[$i] -match '^(Commission|Commissione|Commissioni)$'){ $c=$i } elseif($celle[$i] -match '^Swap$'){ $sw=$i } }
    if($p -ge 0 -and $c -ge 0 -and $sw -ge 0){ $inDeals=$true; [void]$out.Add('--- OPERAZIONI ---'); continue }
    if($celle[0] -notmatch '^\d{4}\.\d{2}\.\d{2} \d{2}:\d{2}:\d{2}$'){ continue }
    if(-not $inDeals -and $out.Count -eq 1){ [void]$out.Add('--- ORDINI ---') }
    [void]$out.Add(($celle -join ' | '))
  }
} else { [void]$out.Add('Report non trovato: ' + $rf) }
# 4b) righe TPL_WIM del Journal del tester (log degli agenti, UTF-16): solo dall'ULTIMA inizializzazione dell'EA
[void]$out.Add('--- JOURNAL TESTER (righe TPL_WIM dell ultima esecuzione) ---')
$nlog=0; $nrif=0
foreach($lf in @(Get-ChildItem -LiteralPath (Join-Path $DATI 'Tester') -Recurse -Filter '*.log' -ErrorAction SilentlyContinue | Where-Object { $_.LastWriteTime -ge $t0.AddMinutes(-1) } | Sort-Object LastWriteTime)){
  try{
    $bl=[IO.File]::ReadAllBytes($lf.FullName); $tl=$(if($bl.Length -ge 2 -and $bl[0] -eq 255 -and $bl[1] -eq 254){ [Text.Encoding]::Unicode.GetString($bl) } else { [Text.Encoding]::UTF8.GetString($bl) })
    $linee=@($tl -split "`r?`n" | Where-Object { $_ -match 'TPL_WIM' }); $ini0=0
    for($k=0; $k -lt $linee.Count; $k++){ if($linee[$k] -match 'TPL_WIM v1\.0\d:'){ $ini0=$k } }
    for($k=$ini0; $k -lt $linee.Count; $k++){
      $ln=$linee[$k].Trim()
      if($ln -match 'rifiutato'){ $nrif=$nrif+1 }
      $nlog=$nlog+1; if($nlog -le 260){ [void]$out.Add($ln) }
    }
  } catch { }
}
[void]$out.Add('Righe TPL_WIM (ultima esecuzione): ' + $nlog + ' | di cui rifiuti: ' + $nrif)
$testo=($out -join "`r`n")
$fileTxt=Join-Path ([Environment]::GetFolderPath('Desktop')) 'RIEPILOGO_CONTROLLO_BREAKOUT_v4.txt'; Set-Content -LiteralPath $fileTxt -Value $testo -Encoding UTF8
try { Set-Clipboard -Value $testo } catch { }
Write-Host ('FATTO. File sul Desktop: ' + $fileTxt + ' (righe TPL_WIM trovate: ' + $nlog + '). Allegalo alla chat.') -ForegroundColor Green
