# MARCATORE_CONTROLLO_DISEGNO3_2016_FTMO_v1
# Passata di CONTROLLO del disegno 3 (breakout giornaliero, stop e target in % del prezzo, filtro fake breakout) - criteri CLAU12_ORO_DISEGNO_3_CRITERI sezione 2 (P2), scritti PRIMA dei numeri. Scarica Template_EA_Wim.mq5 v1.04 dal repository (SHA256 verificato), lo compila sul terminale FTMO di prova, fa DUE passate corte (XAUUSD D1, 2019-01-01 -> 2019-03-01, Modello 1, 0,1 lotti, InpDebug=true), una per disegno, e salva sul Desktop RIEPILOGO_CONTROLLO_DISEGNO3.txt con ordini, operazioni e journal.
# Nessun numero di questo giro si usa per scegliere set. Il tester NON invia ordini. Non chiude MT5 con la forza.
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
$PIN1='38f8e1783a4fc4afbb565483a8c626b75592eb7e'; $SHAT='AC320B7AB85258D8CFD72E9509A8995F9E1633379EA9858228B4BF6D7FBB59C5'
$srcTmp=Join-Path $env:TEMP 'Template_EA_Wim_v104_ftmo.mq5'; Remove-Item -LiteralPath $srcTmp -Force -ErrorAction SilentlyContinue
irm ('https://raw.githubusercontent.com/claudiospadaro12/GITHUB/' + $PIN1 + '/backtest_runner/Template_EA_Wim.mq5?cb=' + [Guid]::NewGuid().ToString('N')) -OutFile $srcTmp
$HT=(Get-FileHash -LiteralPath $srcTmp -Algorithm SHA256).Hash.ToUpperInvariant()
if($HT -ne $SHAT){ Write-Host ('MI FERMO: SHA256 del sorgente diverso: ' + $HT) -ForegroundColor Red; return }
# 2) compilazione
$dstDir=Join-Path $MQL5 'Experts\CLAU12'; New-Item -ItemType Directory -Force -Path $dstDir | Out-Null
$dst=Join-Path $dstDir 'Template_EA_Wim.mq5'; Copy-Item -LiteralPath $srcTmp -Destination $dst -Force
$logc=Join-Path $env:TEMP 'compila_d3.log'; Remove-Item -LiteralPath $logc -Force -ErrorAction SilentlyContinue
$ex5=[IO.Path]::ChangeExtension($dst,'.ex5'); Remove-Item -LiteralPath $ex5 -Force -ErrorAction SilentlyContinue
[void](Start-Process -FilePath $MEE -ArgumentList ('/compile:"' + $dst + '" /include:"' + $MQL5 + '" /log:"' + $logc + '"') -PassThru -Wait)
if(-not (Test-Path -LiteralPath $logc)){ Write-Host 'Nessun log di compilazione.' -ForegroundColor Red; return }
$bc=[IO.File]::ReadAllBytes($logc); $txc=$(if($bc.Length -ge 2 -and $bc[0] -eq 255 -and $bc[1] -eq 254){ [Text.Encoding]::Unicode.GetString($bc) } else { [Text.Encoding]::UTF8.GetString($bc) })
if(-not ((Test-Path -LiteralPath $ex5) -and ($txc -match 'Result:\s*0 errors'))){ Write-Host 'COMPILAZIONE NON RIUSCITA: incollami queste righe.' -ForegroundColor Red; ($txc -split "`r?`n" | Where-Object { $_ -match 'error' }) | ForEach-Object { Write-Host ('   ' + $_) }; return }
Write-Host ('COMPILATO v1.04: ' + $ex5) -ForegroundColor Green
# 3) due passate di controllo
if(-not ('SvegliaDis.Win' -as [type])){ Add-Type -Namespace SvegliaDis -Name Win -MemberDefinition '[DllImport("kernel32.dll")] public static extern uint SetThreadExecutionState(uint esFlags);' }
[void][SvegliaDis.Win]::SetThreadExecutionState([uint32]2147483651)
$IN1=@(
  'InpMagic=880001',
  'InpComment=TPL_WIM',
  'InpRearm=false',
  'InpDebug=true',
  'InpLevelTF=16408',
  'InpCountback=10',
  'InpUsePivots=false',
  'InpHLStrengthL=3',
  'InpHLStrengthR=2',
  'InpMinDistLevelAtr=0.2',
  'InpOffsetAtr=0.1',
  'InpEntryMode=0',
  'InpExpirationBars=6',
  'InpRetestMaxBars=6',
  'InpRetestTolAtr=0.15',
  'InpSLMode=3',
  'InpSLAtr=1.5',
  'InpSLPts=400',
  'InpSLPct=0.35',
  'InpTPMode=3',
  'InpTP_RR=2.0',
  'InpTPAtr=3.0',
  'InpTPPts=1200',
  'InpTPPct=2.1',
  'InpFBF=1',
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
$IN2=@(
  'InpMagic=880001',
  'InpComment=TPL_WIM',
  'InpRearm=false',
  'InpDebug=true',
  'InpLevelTF=16408',
  'InpCountback=20',
  'InpUsePivots=false',
  'InpHLStrengthL=3',
  'InpHLStrengthR=2',
  'InpMinDistLevelAtr=0.2',
  'InpOffsetAtr=0.1',
  'InpEntryMode=0',
  'InpExpirationBars=6',
  'InpRetestMaxBars=6',
  'InpRetestTolAtr=0.15',
  'InpSLMode=3',
  'InpSLAtr=1.5',
  'InpSLPts=400',
  'InpSLPct=0.35',
  'InpTPMode=3',
  'InpTP_RR=2.0',
  'InpTPAtr=3.0',
  'InpTPPts=1200',
  'InpTPPct=3.1',
  'InpFBF=2',
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
$W=Join-Path $env:TEMP 'ctrl_disegni'; New-Item -ItemType Directory -Force -Path $W | Out-Null
$tutto=New-Object System.Collections.ArrayList
function Passata([string]$nome,$ingressi,[string]$titolo){
  $rep='CTRL_' + $nome
  $r=@('[Experts]','AllowLiveTrading=false','AllowDllImport=false','','[Tester]','Expert=CLAU12\Template_EA_Wim.ex5','Symbol=XAUUSD','Period=D1','Model=1','Optimization=0','FromDate=2016.10.25','ToDate=2017.03.01','ForwardMode=0','Deposit=100000','Currency=EUR','Leverage=100','ExecutionMode=0','Visual=0','ReplaceReport=1','ShutdownTerminal=1',('Report=' + $rep),'','[TesterInputs]'); $r += $ingressi
  $ini=Join-Path $W ($rep + '.ini'); Set-Content -LiteralPath $ini -Value (($r -join "`r`n") + "`r`n") -Encoding ASCII -NoNewline
  $rf=Join-Path $DATI ($rep + '.htm'); Remove-Item -LiteralPath $rf -Force -ErrorAction SilentlyContinue
  Write-Host ('Passata ' + $nome + ' avviata alle ' + (Get-Date).ToString('HH:mm') + ' (ora italiana).') -ForegroundColor Cyan
  $t0=Get-Date; $pr=Start-Process -FilePath $TRM -ArgumentList ('/config:"' + $ini + '"') -PassThru
  $scade=$t0.AddMinutes(30); while(-not $pr.HasExited -and (Get-Date) -lt $scade){ Start-Sleep -Seconds 4 }
  if(-not $pr.HasExited){ Write-Host 'TIMEOUT: terminale ancora aperto. Non lo chiudo io.' -ForegroundColor Red; return $false }
  [void]$tutto.Add('=== ' + $titolo + ' ===')
  if(Test-Path -LiteralPath $rf){
    $b=[IO.File]::ReadAllBytes($rf); $html=$(if($b.Length -ge 2 -and (($b[0] -eq 255 -and $b[1] -eq 254) -or ($b[0] -eq 254 -and $b[1] -eq 255))){ [Text.Encoding]::Unicode.GetString($b) } else { [Text.Encoding]::UTF8.GetString($b) })
    $inD=$false; $nOrd=0
    foreach($rg in [regex]::Split($html,'(?i)<tr')){
      $celle=@(); foreach($mc in [regex]::Matches($rg,'(?is)<t[dh][^>]*>(.*?)</t[dh]>')){ $celle += (([regex]::Replace($mc.Groups[1].Value,'<[^>]*>','') -replace '&nbsp;',' ' -replace '\s+',' ').Trim()) }
      if($celle.Count -lt 8){ continue }
      $p1=-1; $c1=-1; $s1=-1
      for($i=0; $i -lt $celle.Count; $i++){ if($celle[$i] -match '^(Profit|Profitto|Utile)$'){ $p1=$i } elseif($celle[$i] -match '^(Commission|Commissione|Commissioni)$'){ $c1=$i } elseif($celle[$i] -match '^Swap$'){ $s1=$i } }
      if($p1 -ge 0 -and $c1 -ge 0 -and $s1 -ge 0){ $inD=$true; [void]$tutto.Add('--- OPERAZIONI ---'); continue }
      if($celle[0] -notmatch '^\d{4}\.\d{2}\.\d{2} \d{2}:\d{2}:\d{2}$'){ continue }
      if($inD){ [void]$tutto.Add(($celle -join ' | ')) } else { $nOrd=$nOrd+1; if($nOrd -eq 1){ [void]$tutto.Add('--- ORDINI (primi 90) ---') }; if($nOrd -le 90){ [void]$tutto.Add(($celle -join ' | ')) } }
    }
    [void]$tutto.Add('Righe ordini nel report: ' + $nOrd)
  } else { [void]$tutto.Add('Report non trovato: ' + $rf) }
  [void]$tutto.Add('--- JOURNAL (TPL_WIM, dalla ultima inizializzazione; senza le righe GIORNO) ---')
  $nlog=0
  foreach($lf in @(Get-ChildItem -LiteralPath (Join-Path $DATI 'Tester') -Recurse -Filter '*.log' -ErrorAction SilentlyContinue | Where-Object { $_.LastWriteTime -ge $t0.AddMinutes(-1) } | Sort-Object LastWriteTime)){
    try{
      $bl=[IO.File]::ReadAllBytes($lf.FullName); $tl=$(if($bl.Length -ge 2 -and $bl[0] -eq 255 -and $bl[1] -eq 254){ [Text.Encoding]::Unicode.GetString($bl) } else { [Text.Encoding]::UTF8.GetString($bl) })
      $linee=@($tl -split "`r?`n" | Where-Object { $_ -match 'TPL_WIM' }); $ini0=0; $altre=@($tl -split "`r?`n" | Where-Object { $_ -notmatch 'TPL_WIM' -and $_ -match '(?i)(history|synchron|error|fail|ticks|quality|final balance|passed|cannot|unable|no data|not found|started|disabled|bars)' }); for($k=[Math]::Max(0,$altre.Count-40); $k -lt $altre.Count; $k++){ [void]$tutto.Add('LOG: ' + $altre[$k].Trim()) }
      for($k=0; $k -lt $linee.Count; $k++){ if($linee[$k] -match 'TPL_WIM v1\.\d+:'){ $ini0=$k } }
      for($k=$ini0; $k -lt $linee.Count; $k++){ $ln=$linee[$k].Trim(); if($ln -match 'GIORNO'){ continue }; $nlog=$nlog+1; if($nlog -le 400){ [void]$tutto.Add($ln) } }
    } catch { }
  }
  [void]$tutto.Add('Righe journal (filtrate): ' + $nlog)
  return $true
}
$ok1=Passata 'D3_riga2_FBF_H1' $IN1 'DISEGNO 3 riga 2: stop 0,35% prezzo, target 2,1%, countback 10 giorni, scadenza 6 giorni, pendenti persistenti, FBF H1'
if($ok1){ $ok2=Passata 'D3_riga3_FBF_H4' $IN2 'DISEGNO 3 riga 3: stop 0,35% prezzo, target 3,1%, countback 20 giorni, scadenza 6 giorni, pendenti persistenti, FBF H4' }
[void][SvegliaDis.Win]::SetThreadExecutionState([uint32]2147483648)
$testo=($tutto -join "`r`n")
$fileTxt=Join-Path ([Environment]::GetFolderPath('Desktop')) 'RIEPILOGO_CONTROLLO_DISEGNO3_2016.txt'; Set-Content -LiteralPath $fileTxt -Value $testo -Encoding UTF8
try { Set-Clipboard -Value $testo } catch { }
Write-Host ('FATTO alle ' + (Get-Date).ToString('HH:mm') + ' (ora italiana). File sul Desktop: ' + $fileTxt + '. Allegalo alla chat.') -ForegroundColor Green

Write-Host ''
Write-Host '##########  FILE DA ALLEGARE ALLA CHAT  ##########' -ForegroundColor Black -BackgroundColor Yellow
Write-Host $fileTxt -ForegroundColor Black -BackgroundColor Yellow
Write-Host '(Esplora file si apre con questo file gia selezionato: trascinalo nella chat)' -ForegroundColor Black -BackgroundColor Yellow
try { Start-Process -FilePath 'explorer.exe' -ArgumentList ('/select,"' + $fileTxt + '"') } catch { }
