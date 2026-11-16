# MARCATORE_PROVA_FTMO_ORO_v1
# Prova V6 (candele FTMO) nel terminale di prova C:\MT5_Backtest\Mt5_Ftmo_Prova (server FTMO-Demo, dati in AppData): copia l'EA di Wim dal portable BCM (SHA256 verificato), allinea nel suo config\common.ini le righe WebRequest del portable (copia di sicurezza), e lancia 5 passate singole del set C0 (GTP E di Wim, lotto 0,1, tutti gli input) su XAUUSD D1 Modello 1 per anni campione (2013, 2016, 2019, 2022, 2025): serve a vedere SE la licenza funziona su FTMO-Demo e QUANTI anni di storico oro scarica FTMO. Nessun numero di merito viene usato per scegliere.
# Scrive SOLO: nei dati di Mt5_Ftmo_Prova (EA copiato, common.ini con copia di sicurezza, storico scaricato, report, log) e .ini in %TEMP%\abtg_opt_oro. NON tocca BCM, il portable BCM (solo lettura), conti reali, VPS, altri terminali. Il conto FTMO-Demo e una demo di prova.
$ErrorActionPreference='Continue'
if($env:COMPUTERNAME -ne 'DESKTOP-H4D7CAJ'){ Write-Host ('SOLO sul PC di backtest DESKTOP-H4D7CAJ. Qui: ' + $env:COMPUTERNAME) -ForegroundColor Red; return }
$FT='C:\MT5_Backtest\Mt5_Ftmo_Prova'; $T=Join-Path $FT 'terminal64.exe'
$PEA='C:\MT5_BCM_Opt\MQL5\Experts\WIM\Ultimate_Breakout_EA_WSC_V9.5.ex5'; $HEA='AD2A7AC8C56E2756E4FE576F441227D11A2067B78F7BC4D200C76D111FD6EB4A'
$SET='C:\MT5_BCM_Opt\MQL5\Profiles\Tester\OPT2_ORO.set'; $PCI='C:\MT5_BCM_Opt\config\common.ini'
$aperti=@(Get-Process -Name terminal64,metatester64,metaeditor64 -ErrorAction SilentlyContinue)
if($aperti.Count -gt 0){ $aperti | Select-Object Id,ProcessName,Path | Format-Table -AutoSize | Out-String | Write-Host; Write-Host 'MI FERMO: ci sono MT5, MetaEditor o agenti del tester aperti. Chiudili e rilancia. Non ho scritto niente.' -ForegroundColor Red; return }
foreach($pp in @($T,$PEA,$SET,$PCI)){ if(-not (Test-Path -LiteralPath $pp)){ Write-Host ('MI FERMO: non trovo ' + $pp) -ForegroundColor Red; return } }
$h=(Get-FileHash -LiteralPath $PEA -Algorithm SHA256).Hash.ToUpperInvariant(); if($h -ne $HEA){ Write-Host ('MI FERMO: l EA del portable ha SHA256 ' + $h) -ForegroundColor Red; return }
$data=$null; $baseT=Join-Path $env:APPDATA 'MetaQuotes\Terminal'
foreach($o in @(Get-ChildItem -LiteralPath $baseT -Directory -ErrorAction SilentlyContinue)){ $of=Join-Path $o.FullName 'origin.txt'; if(Test-Path -LiteralPath $of){ $c=((Get-Content -LiteralPath $of -Raw -Encoding Unicode) -replace '[\r\n\0]','').Trim(); if($c -eq $FT){ $data=$o.FullName } } }
if(-not $data){ Write-Host ('MI FERMO: non trovo la cartella dati di ' + $FT) -ForegroundColor Red; return }
Write-Host ('Terminale FTMO di prova: ' + $FT + '  dati: ' + $data) -ForegroundColor Cyan
function LeggiIni([string]$p){ $b=[IO.File]::ReadAllBytes($p); $u=($b.Length -ge 2 -and $b[0] -eq 255 -and $b[1] -eq 254); $tt=$(if($u){ [Text.Encoding]::Unicode.GetString($b) } else { [Text.Encoding]::UTF8.GetString($b) }); return @{ testo=$tt; uni=$u } }
$fci=Join-Path $data 'config\common.ini'
if(-not (Test-Path -LiteralPath $fci)){ Write-Host ('MI FERMO: non trovo ' + $fci) -ForegroundColor Red; return }
$fc=LeggiIni $fci; $sv=[regex]::Match($fc.testo,'(?m)^Server=(.*)$'); $lg=[regex]::Match($fc.testo,'(?m)^Login=(\d+)')
Write-Host ('   server in common.ini: ' + $(if($sv.Success){ $sv.Groups[1].Value.Trim() } else { 'n.d.' }) + '; login salvato: ' + $(if($lg.Success){ 'si' } else { 'NO' })) -ForegroundColor Cyan
if(-not $lg.Success){ Write-Host 'MI FERMO: nel terminale FTMO di prova non c e un login salvato: aprilo una volta, accedi al conto demo e chiudilo, poi rilancia. Non ho scritto niente.' -ForegroundColor Red; return }
Write-Host '1/3 Copio l EA di Wim nel terminale di prova FTMO ...' -ForegroundColor Cyan
$dea=Join-Path $data 'MQL5\Experts\WIM'; New-Item -ItemType Directory -Force -Path $dea | Out-Null; Copy-Item -LiteralPath $PEA -Destination (Join-Path $dea 'Ultimate_Breakout_EA_WSC_V9.5.ex5') -Force
$h2=(Get-FileHash -LiteralPath (Join-Path $dea 'Ultimate_Breakout_EA_WSC_V9.5.ex5') -Algorithm SHA256).Hash.ToUpperInvariant(); if($h2 -ne $HEA){ Write-Host 'ERRORE: l EA copiato ha SHA256 diverso.' -ForegroundColor Red; return }
Write-Host '   EA copiato (SHA256 uguale).' -ForegroundColor Green
Write-Host '2/3 Allineo le righe WebRequest di common.ini (copia di sicurezza) ...' -ForegroundColor Cyan
$pc=LeggiIni $PCI; $wr=@(($pc.testo -split "`r?`n") | ForEach-Object { $_.Trim([char]0xFEFF).Trim() } | Where-Object { $_ -match '^(WebRequest|WebRequestUrl)=' })
Write-Host ('   righe WebRequest del portable: ' + $wr.Count) -ForegroundColor Cyan; $wr | ForEach-Object { Write-Host ('      ' + $_) }
if($wr.Count -gt 0){
  Copy-Item -LiteralPath $fci -Destination ($fci + '.prima_' + (Get-Date).ToString('yyyyMMdd_HHmmss')) -Force
  $nl="`r`n"; $righeF=@(($fc.testo -split "`r?`n") | ForEach-Object { $_.TrimEnd() }); $nuove=New-Object System.Collections.ArrayList; $inExp=$false; $messo=$false
  foreach($r in $righeF){ $x=$r.Trim([char]0xFEFF).Trim(); if($x -match '^\[.*\]$'){ if($inExp -and -not $messo){ foreach($w1 in $wr){ [void]$nuove.Add($w1) }; $messo=$true }; $inExp=($x -eq '[Experts]') }; if($inExp -and $x -match '^(WebRequest|WebRequestUrl)='){ continue }; [void]$nuove.Add($r) }
  if($inExp -and -not $messo){ foreach($w1 in $wr){ [void]$nuove.Add($w1) }; $messo=$true }
  if(-not $messo){ [void]$nuove.Add('[Experts]'); foreach($w1 in $wr){ [void]$nuove.Add($w1) } }
  $tf=(($nuove -join $nl) + $nl); $bytes=$(if($fc.uni){ [Text.Encoding]::Unicode.GetBytes($tf) } else { (New-Object Text.UTF8Encoding($false)).GetBytes($tf) }); [IO.File]::WriteAllBytes($fci,$bytes)
  Write-Host '   common.ini aggiornato.' -ForegroundColor Green
}
if(-not ('MasterSveglia.Win' -as [type])){ Add-Type -Namespace MasterSveglia -Name Win -MemberDefinition '[DllImport("kernel32.dll")] public static extern uint SetThreadExecutionState(uint esFlags);' }
[void][MasterSveglia.Win]::SetThreadExecutionState([uint32]2147483651)
$sb=[IO.File]::ReadAllBytes($SET); $st=$(if($sb.Length -ge 2 -and $sb[0] -eq 255 -and $sb[1] -eq 254){ [Text.Encoding]::Unicode.GetString($sb) } else { [Text.Encoding]::UTF8.GetString($sb) })
$base=@(); foreach($r in ($st -split "`r?`n")){ $x=$r.Trim([char]0xFEFF).Trim(); if($x -ne '' -and -not $x.StartsWith(';') -and $x.Contains('=')){ $base += $x } }
$W=Join-Path $env:TEMP 'abtg_opt_oro'; New-Item -ItemType Directory -Force -Path $W | Out-Null
function Num([string]$s){ $c=($s -replace '[^0-9.\-]',''); $v=0.0; if([double]::TryParse($c,[Globalization.NumberStyles]::Float,[Globalization.CultureInfo]::InvariantCulture,[ref]$v)){ return $v } else { return [double]::NaN } }
function Passata([string]$nome,[string]$da,[string]$a){
  $rep='FTO_' + $nome; $ini=Join-Path $W ($rep + '.ini')
  $r=@('[Experts]','AllowLiveTrading=false','AllowDllImport=false','','[Tester]','Expert=WIM\Ultimate_Breakout_EA_WSC_V9.5.ex5','Symbol=XAUUSD','Period=D1','Model=1','Optimization=0',('FromDate=' + $da),('ToDate=' + $a),'ForwardMode=0','Deposit=100000','Currency=EUR','Leverage=100','ExecutionMode=0','Visual=0','ReplaceReport=1','ShutdownTerminal=1',('Report=' + $rep),'','[TesterInputs]'); $r += $base
  Set-Content -LiteralPath $ini -Value (($r -join "`r`n") + "`r`n") -Encoding ASCII -NoNewline
  Remove-Item -LiteralPath (Join-Path $data ($rep + '.htm')) -Force -ErrorAction SilentlyContinue
  $t0=Get-Date; $p=Start-Process -FilePath $T -ArgumentList ('/config:"' + $ini + '"') -PassThru
  $scade=$t0.AddMinutes(45); while(-not $p.HasExited -and (Get-Date) -lt $scade){ Start-Sleep -Seconds 4 }
  if(-not $p.HasExited){ Write-Host ('TIMEOUT: terminale PID ' + $p.Id + ' ancora aperto: chiudilo a mano.') -ForegroundColor Red; return $null }
  $rf=Join-Path $data ($rep + '.htm'); if(-not (Test-Path -LiteralPath $rf)){ return $null }
  $b=[IO.File]::ReadAllBytes($rf); $tx=$(if($b.Length -ge 2 -and (($b[0] -eq 255 -and $b[1] -eq 254) -or ($b[0] -eq 254 -and $b[1] -eq 255))){ [Text.Encoding]::Unicode.GetString($b) } else { [Text.Encoding]::UTF8.GetString($b) })
  $tx=[regex]::Replace($tx,'<[^>]*>','|'); $tx=[regex]::Replace($tx,'\s*\|[\s|]*','|')
  $g1=[regex]::Match($tx,'Profitto Totale Netto:\|([^|]*)\|'); $g2=[regex]::Match($tx,'Numero di Operazioni di Trading Totali:\|([^|]*)\|'); $g3=[regex]::Match($tx,'Fattore di Profitto:\|([^|]*)\|'); $g4=[regex]::Match($tx,'Drawdown Massima:\|([^|]*)\|'); $g6=[regex]::Match($tx,'Qualit. dello Storico:\|([^|]*)\|'); $g7=[regex]::Match($tx,'Barre:\|([^|]*)\|')
  return ('' + $(if($g6.Success){ $g6.Groups[1].Value -replace ' ','' } else { 'NA' }) + ';' + $(if($g7.Success){ $g7.Groups[1].Value -replace ' ','' } else { 'NA' }) + ';' + $(if($g1.Success){ Num $g1.Groups[1].Value } else { 'NA' }) + ';' + $(if($g2.Success){ Num $g2.Groups[1].Value } else { 'NA' }) + ';' + $(if($g3.Success){ Num $g3.Groups[1].Value } else { 'NA' }) + ';' + $(if($g4.Success){ $g4.Groups[1].Value -replace ' ','' } else { 'NA' }))
}
Write-Host ('3/3 Cinque passate di prova (C0, XAUUSD D1, Modello 1, un anno ciascuna). Ora italiana: ' + (Get-Date).ToString('dd/MM/yyyy HH:mm') + '. Durata attesa 10-40 minuti (STIMA: la prima scarica lo storico). Colonne: anno;qualita storico;barre;profitto;operazioni;PF;DD massima equity.') -ForegroundColor Cyan
$out=New-Object System.Collections.ArrayList
foreach($an in @('2013','2016','2019','2022','2025')){
  $res=Passata ('C0_' + $an) ($an + '.01.01') ($an + '.12.31')
  $riga=($an + ';' + $(if($res){ $res } else { 'ERRORE;;;;;' })); [void]$out.Add($riga); Write-Host ('[' + (Get-Date).ToString('HH:mm') + '] ' + $riga) -ForegroundColor Green
}
Write-Host 'Righe di licenza/errore nei giornali di oggi (terminale FTMO di prova):' -ForegroundColor Cyan
$n=0; $logs=@(Get-ChildItem -LiteralPath $data -Recurse -File -Filter ((Get-Date).ToString('yyyyMMdd') + '.log') -ErrorAction SilentlyContinue | Where-Object { $_.FullName -like '*\logs\*' } | Sort-Object LastWriteTime -Descending | Select-Object -First 4)
foreach($lg2 in $logs){ $b=[IO.File]::ReadAllBytes($lg2.FullName); $tl=$(if($b.Length -ge 2 -and $b[0] -eq 255 -and $b[1] -eq 254){ [Text.Encoding]::Unicode.GetString($b) } else { [Text.Encoding]::UTF8.GetString($b) }); foreach($r in ($tl -split "`r?`n")){ if($r -match '(?i)licen|authoriz|invalid account|WebRequest|URL|not found|synchroniz|no connection|Test passed|final balance'){ if($n -lt 30){ $x=$r.Trim(); [void]$out.Add('log: ' + $x); Write-Host ('   ' + $x) -ForegroundColor Yellow; $n=$n+1 } } } }
[void][MasterSveglia.Win]::SetThreadExecutionState([uint32]2147483648)
try { Set-Clipboard -Value ($out -join "`r`n"); Write-Host 'Risultati COPIATI negli appunti: incollali nella chat con Ctrl+V.' -ForegroundColor Green } catch { Write-Host 'Appunti non disponibili: mandami la foto.' -ForegroundColor Yellow }
Write-Host ('Fine alle ' + (Get-Date).ToString('dd/MM/yyyy HH:mm') + ' (ora italiana).') -ForegroundColor Cyan
