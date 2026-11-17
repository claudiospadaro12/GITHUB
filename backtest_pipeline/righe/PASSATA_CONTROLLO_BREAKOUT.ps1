# MARCATORE_PASSATA_CONTROLLO_BREAKOUT_v1
# Passata di CONTROLLO del breakout oro (criteri CLAU12_BREAKOUT_ORO sezione 1, P2): UNA passata del tester, XAUUSD D1, 2019-01-01 -> 2019-12-31, Modello 1 (candele da 1 minuto), 100000 EUR, lotto fisso 0,1, EA CLAU12\Template_EA_Wim.ex5 (riga 1 della griglia L9 D1: countback 10, stop 1,0 ATR, target 1,5 R, scadenza 3 barre), tutti gli input in [TesterInputs].
# Serve a VERIFICARE A MANO che l'EA faccia quello che deve (pendenti al livello +/- offset, scadenza, stop/target, una posizione). NON valuta il PF: nessun numero di questo giro si usa per scegliere set.
# Terminale: portable BCM (C:\MT5_BCM_Opt). Scrive solo il report e il .ini in %TEMP%. Il tester NON invia ordini ai conti (AllowLiveTrading=false). Non chiude MT5 con la forza.
$ErrorActionPreference='Continue'
$ci=[Globalization.CultureInfo]::InvariantCulture
if($env:COMPUTERNAME -ne 'DESKTOP-H4D7CAJ'){ Write-Host ('SOLO sul PC di backtest DESKTOP-H4D7CAJ. Qui: ' + $env:COMPUTERNAME) -ForegroundColor Red; return }
$TRM='C:\MT5_BCM_Opt\terminal64.exe'; $DATI='C:\MT5_BCM_Opt'; $EX5=Join-Path $DATI 'MQL5\Experts\CLAU12\Template_EA_Wim.ex5'
$aperti=@(Get-Process -Name terminal64,metatester64,metaeditor64 -ErrorAction SilentlyContinue)
if($aperti.Count -gt 0){ $aperti | Select-Object Id,ProcessName,Path | Format-Table -AutoSize | Out-String | Write-Host; Write-Host 'MI FERMO: MT5, MetaEditor o agenti aperti. Chiudili e rilancia. Non ho avviato niente.' -ForegroundColor Red; return }
if(-not (Test-Path -LiteralPath $TRM)){ Write-Host ('MI FERMO: non trovo ' + $TRM) -ForegroundColor Red; return }
if(-not (Test-Path -LiteralPath $EX5)){ Write-Host 'MI FERMO: Template_EA_Wim.ex5 non c e in MQL5\Experts\CLAU12 del BCM portable. Prima compila: .\Compila_EA.ps1 -Dati C:\MT5_BCM_Opt -Portable (deve dire COMPILATO).' -ForegroundColor Red; return }
if(-not ('SvegliaCtl.Win' -as [type])){ Add-Type -Namespace SvegliaCtl -Name Win -MemberDefinition '[DllImport("kernel32.dll")] public static extern uint SetThreadExecutionState(uint esFlags);' }
[void][SvegliaCtl.Win]::SetThreadExecutionState([uint32]2147483651)
$IN=@(
  'InpMagic=880001',
  'InpComment=TPL_WIM',
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
$rep='CTRL_BREAKOUT_2019'
$r=@('[Experts]','AllowLiveTrading=false','AllowDllImport=false','','[Tester]','Expert=CLAU12\Template_EA_Wim.ex5','Symbol=XAUUSD','Period=D1','Model=1','Optimization=0','FromDate=2019.01.01','ToDate=2019.12.31','ForwardMode=0','Deposit=100000','Currency=EUR','Leverage=100','ExecutionMode=0','Visual=0','ReplaceReport=1','ShutdownTerminal=1',('Report=' + $rep),'','[TesterInputs]'); $r += $IN
$ini=Join-Path $W ($rep + '.ini'); Set-Content -LiteralPath $ini -Value (($r -join "`r`n") + "`r`n") -Encoding ASCII -NoNewline
$rf=Join-Path $DATI ($rep + '.htm'); Remove-Item -LiteralPath $rf -Force -ErrorAction SilentlyContinue
Write-Host ('Passata di controllo avviata alle ' + (Get-Date).ToString('dd/MM/yyyy HH:mm') + ' (ora italiana). Durata attesa 1-3 minuti (STIMA).') -ForegroundColor Cyan
$t0=Get-Date; $pr=Start-Process -FilePath $TRM -ArgumentList ('/portable /config:"' + $ini + '"') -PassThru
$scade=$t0.AddMinutes(30); while(-not $pr.HasExited -and (Get-Date) -lt $scade){ Start-Sleep -Seconds 4 }
if(-not $pr.HasExited){ Write-Host 'TIMEOUT: il terminale e ancora aperto. Non lo chiudo io: guardalo e dimmi.' -ForegroundColor Red; [void][SvegliaCtl.Win]::SetThreadExecutionState([uint32]2147483648); return }
[void][SvegliaCtl.Win]::SetThreadExecutionState([uint32]2147483648)
if(-not (Test-Path -LiteralPath $rf)){ Write-Host ('Report non trovato: ' + $rf + ' (l EA potrebbe non essersi caricato: controlla il Journal del tester).') -ForegroundColor Red; return }
$b=[IO.File]::ReadAllBytes($rf); $html=$(if($b.Length -ge 2 -and (($b[0] -eq 255 -and $b[1] -eq 254) -or ($b[0] -eq 254 -and $b[1] -eq 255))){ [Text.Encoding]::Unicode.GetString($b) } else { [Text.Encoding]::UTF8.GetString($b) })
$tx=[regex]::Replace($html,'<[^>]*>','|'); $tx=[regex]::Replace($tx,'\s*\|[\s|]*','|')
function Cerca([string]$t,[string]$et){ $m=[regex]::Match($t,'(?:' + $et + ')\|([^|]*)\|'); if($m.Success){ return $m.Groups[1].Value } else { return 'NA' } }
$out=New-Object System.Collections.ArrayList
[void]$out.Add('=== PASSATA DI CONTROLLO BREAKOUT (BCM portable, XAUUSD D1, 2019, Modello 1) ===')
[void]$out.Add('Profitto netto: ' + (Cerca $tx 'Profitto Totale Netto:|Total Net Profit:') + ' | PF: ' + (Cerca $tx 'Fattore di Profitto:|Profit Factor:') + ' | Operazioni: ' + (Cerca $tx 'Numero di Operazioni di Trading Totali:|Total Trades:') + ' | DD: ' + (Cerca $tx 'Drawdown Massima:|Equity Drawdown Maximal:') + ' | Qualita: ' + (Cerca $tx 'Qualit. dello Storico:|History Quality:'))
$righe=[regex]::Split($html,'(?i)<tr'); $inDeals=$false; $nOrd=0; $nDeal=0
foreach($rg in $righe){
  $celle=@(); foreach($mc in [regex]::Matches($rg,'(?is)<t[dh][^>]*>(.*?)</t[dh]>')){ $celle += (([regex]::Replace($mc.Groups[1].Value,'<[^>]*>','') -replace '&nbsp;',' ' -replace '\s+',' ').Trim()) }
  if($celle.Count -lt 8){ continue }
  $p=-1; $c=-1; $sw=-1
  for($i=0; $i -lt $celle.Count; $i++){ if($celle[$i] -match '^(Profit|Profitto|Utile)$'){ $p=$i } elseif($celle[$i] -match '^(Commission|Commissione|Commissioni)$'){ $c=$i } elseif($celle[$i] -match '^Swap$'){ $sw=$i } }
  if($p -ge 0 -and $c -ge 0 -and $sw -ge 0){ $inDeals=$true; [void]$out.Add('--- OPERAZIONI (deal) ---'); [void]$out.Add(($celle -join ' | ')); continue }
  if($celle[0] -notmatch '^\d{4}\.\d{2}\.\d{2} \d{2}:\d{2}:\d{2}$'){ continue }
  if($inDeals){ $nDeal=$nDeal+1; if($nDeal -le 80){ [void]$out.Add(($celle -join ' | ')) } }
  else { $nOrd=$nOrd+1; if($nOrd -le 40){ if($nOrd -eq 1){ [void]$out.Add('--- ORDINI (primi 40) ---') }; [void]$out.Add(($celle -join ' | ')) } }
}
[void]$out.Add('Righe ordini nel report: ' + $nOrd + ' | righe deal: ' + $nDeal)
$testo=($out -join "`r`n")
try { Set-Clipboard -Value $testo; Write-Host 'Risultato COPIATO negli appunti: incollalo nella chat con Ctrl+V.' -ForegroundColor Green } catch { Write-Host 'Appunti non disponibili: mandami la foto di queste righe.' -ForegroundColor Yellow }
$out | Select-Object -First 14 | ForEach-Object { Write-Host $_ }
Write-Host ('Report completo: ' + $rf + ' | fine alle ' + (Get-Date).ToString('dd/MM/yyyy HH:mm') + ' (ora italiana).') -ForegroundColor Cyan
