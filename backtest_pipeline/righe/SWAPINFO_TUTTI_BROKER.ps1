# MARCATORE_SWAPINFO_TUTTI_BROKER_v1
# SOLA LETTURA: legge lo swap (long/short, modo, giorno del triplo swap, % annua del nozionale) di TUTTI i simboli del server di OGNI terminale MT5 installato sul PC di backtest che si e gia collegato a un server (demo di broker diversi e FTMO investitore) e del terminale portabile BCM; NON avvia il terminale BCM principale ne quelli FundedNext o con server Live/Real. Nessun ordine, nessun conto toccato (solo conti demo/investitore). Un CSV per terminale in C:\ABTG_RISULTATI e uno zip.
$ErrorActionPreference='Continue'
if($env:COMPUTERNAME -ne 'DESKTOP-H4D7CAJ'){ Write-Host ('SOLO sul PC di backtest DESKTOP-H4D7CAJ. Qui: ' + $env:COMPUTERNAME) -ForegroundColor Red; return }
$PINSRC='2cdb297b75b01ac0b074b204e726956e485d69ef'; $SHAMQ5='5148710530C60B4AA5C4339123E4C46EAB95BE9B800E5265E7E2ACFA68E60306'
$aperti=@(Get-Process -Name terminal64,metatester64,metaeditor64 -ErrorAction SilentlyContinue)
if($aperti.Count -gt 0){ $aperti | Select-Object Id,ProcessName,Path | Format-Table -AutoSize | Out-String | Write-Host; Write-Host 'MI FERMO: MT5, MetaEditor o agenti aperti. Chiudili e rilancia. Non ho avviato niente.' -ForegroundColor Red; return }
function LeggiTesto([string]$p){ $b=[IO.File]::ReadAllBytes($p); if($b.Length -ge 2 -and (($b[0] -eq 255 -and $b[1] -eq 254) -or ($b[0] -eq 254 -and $b[1] -eq 255))){ return [Text.Encoding]::Unicode.GetString($b) } else { return [Text.Encoding]::UTF8.GetString($b) } }
[Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12
$W=Join-Path $env:TEMP 'swapinfo_tutti'; New-Item -ItemType Directory -Force -Path $W | Out-Null
$src=Join-Path $W 'ABTG_SwapInfo.mq5'; Remove-Item -LiteralPath $src -Force -ErrorAction SilentlyContinue
irm ('https://raw.githubusercontent.com/claudiospadaro12/GITHUB/' + $PINSRC + '/mql5/Scripts/ABTG_SwapInfo.mq5?cb=' + [Guid]::NewGuid().ToString('N')) -OutFile $src
$hh=(Get-FileHash -LiteralPath $src -Algorithm SHA256).Hash.ToUpperInvariant()
if($hh -ne $SHAMQ5){ Write-Host ('MI FERMO: SHA256 diverso per lo script: ' + $hh) -ForegroundColor Red; return }
$stamp=(Get-Date).ToString('yyyyMMdd_HHmm')
$out=Join-Path 'C:\ABTG_RISULTATI' ('SWAPINFO_TUTTI_' + $stamp); New-Item -ItemType Directory -Force -Path $out | Out-Null
$TERMS=@(); $radice=Join-Path $env:APPDATA 'MetaQuotes\Terminal'; $saltati=@()
foreach($d in @(Get-ChildItem -LiteralPath $radice -Directory -ErrorAction SilentlyContinue)){
  if($d.Name -ieq 'Common'){ continue }
  $o=Join-Path $d.FullName 'origin.txt'; if(-not (Test-Path -LiteralPath $o)){ continue }
  $inst=((LeggiTesto $o) -replace '[^\u0020-\u007E]','').Trim()
  if(-not (Test-Path -LiteralPath (Join-Path $inst 'terminal64.exe'))){ continue }
  $sv=@(Get-ChildItem -LiteralPath (Join-Path $d.FullName 'bases') -Directory -ErrorAction SilentlyContinue | ForEach-Object { $_.Name })
  if($sv.Count -eq 0){ $saltati += $inst; continue }
  if((($sv -join ' ') -match 'BCM|Funded|Live|Real') -and ($inst -ne 'C:\MT5_BCM_Opt')){ $saltati += ($inst + ' [BCM principale / FundedNext / conto reale: gia misurato o non lo avvio]'); continue }
  $nm=(($sv -join '+') -replace '[^A-Za-z0-9+_-]','_') + '_' + ($TERMS.Count + 1)
  $TERMS += @{ n=$nm; prog=$inst; portable=$false }
}
if(Test-Path -LiteralPath 'C:\MT5_BCM_Opt\terminal64.exe'){ $TERMS += @{ n='BCM_PORTABILE'; prog='C:\MT5_BCM_Opt'; portable=$true } }
Write-Host ('Terminali con un server collegato: ' + $TERMS.Count + ' (' + (($TERMS | ForEach-Object { $_.n }) -join ', ') + ')') -ForegroundColor Cyan
foreach($sk in $saltati){ Write-Host ('   salto (mai collegato a un server): ' + $sk) -ForegroundColor Yellow }
$fatti=0
foreach($T in $TERMS){
  $exe=Join-Path $T.prog 'terminal64.exe'; $med=Join-Path $T.prog 'metaeditor64.exe'
  Write-Host ('=== ' + $T.n + ' ===') -ForegroundColor Cyan
  if(-not ((Test-Path -LiteralPath $exe) -and (Test-Path -LiteralPath $med))){ Write-Host ('   salto: non trovo ' + $T.prog) -ForegroundColor Yellow; continue }
  $dati=''
  if($T.portable){ $dati=$T.prog } else {
    $radice=Join-Path $env:APPDATA 'MetaQuotes\Terminal'
    foreach($d in @(Get-ChildItem -LiteralPath $radice -Directory -ErrorAction SilentlyContinue)){
      if($d.Name -ieq 'Common'){ continue }
      $o=Join-Path $d.FullName 'origin.txt'; if(-not (Test-Path -LiteralPath $o)){ continue }
      $inst=((LeggiTesto $o) -replace '[^\u0020-\u007E]','').Trim()
      if($inst -ieq $T.prog){ $dati=$d.FullName }
    }
  }
  if($dati -eq ''){ Write-Host '   salto: cartella dati non trovata' -ForegroundColor Yellow; continue }
  $mql5=Join-Path $dati 'MQL5'; $dstDir=Join-Path $mql5 'Scripts'; New-Item -ItemType Directory -Force -Path $dstDir | Out-Null
  $dst=Join-Path $dstDir 'ABTG_SwapInfo.mq5'; Copy-Item -LiteralPath $src -Destination $dst -Force
  $logc=Join-Path $W ($T.n + '_compila.log'); Remove-Item -LiteralPath $logc -Force -ErrorAction SilentlyContinue
  $ex5=[IO.Path]::ChangeExtension($dst,'.ex5'); Remove-Item -LiteralPath $ex5 -Force -ErrorAction SilentlyContinue
  $pf=$(if($T.portable){ '/portable ' } else { '' })
  [void](Start-Process -FilePath $med -ArgumentList ($pf + '/compile:"' + $dst + '" /include:"' + $mql5 + '" /log:"' + $logc + '"') -PassThru -Wait)
  if(-not (Test-Path -LiteralPath $logc)){ Write-Host '   salto: nessun log di compilazione' -ForegroundColor Red; continue }
  $txc=LeggiTesto $logc
  if(-not ((Test-Path -LiteralPath $ex5) -and ($txc -match 'Result:\s*0 errors'))){ Write-Host '   COMPILAZIONE NON RIUSCITA: incollami queste righe.' -ForegroundColor Red; ($txc -split "`r?`n" | Where-Object { $_ -match 'error' }) | ForEach-Object { Write-Host ('      ' + $_) }; continue }
  $lf=Join-Path $mql5 'Files'; New-Item -ItemType Directory -Force -Path $lf | Out-Null
  foreach($n in @('ABTG_SWAPINFO.csv','ABTG_SWAPINFO_FINE.txt')){ Remove-Item -LiteralPath (Join-Path $lf $n) -Force -ErrorAction SilentlyContinue }
  $ini=Join-Path $W ($T.n + '_swap.ini')
  Set-Content -LiteralPath $ini -Value ("[Charts]`r`nMaxBars=2000000000`r`n`r`n[StartUp]`r`nScript=ABTG_SwapInfo`r`nSymbol=XAUUSD`r`nPeriod=H1`r`n") -Encoding Unicode
  Write-Host ('   avvio ' + (Get-Date).ToString('HH:mm') + ': il terminale parte, lo script lavora (1-3 minuti) e lo chiude da solo. NON toccare MT5.') -ForegroundColor Gray
  $t0=Get-Date; $pr=Start-Process -FilePath $exe -ArgumentList ($pf + '/config:"' + $ini + '"') -PassThru
  $scade=$t0.AddMinutes(10); $fine=$false
  while((Get-Date) -lt $scade){ Start-Sleep -Seconds 4; if(Test-Path -LiteralPath (Join-Path $lf 'ABTG_SWAPINFO_FINE.txt')){ $fine=$true; break }; if($pr.HasExited){ break } }
  Start-Sleep -Seconds 4
  $csv=Join-Path $lf 'ABTG_SWAPINFO.csv'
  if(Test-Path -LiteralPath $csv){ Copy-Item -LiteralPath $csv -Destination (Join-Path $out ($T.n + '_ABTG_SWAPINFO.csv')) -Force; $fatti++; Write-Host ('   OK: ' + (@(Get-Content -LiteralPath $csv).Count - 1) + ' simboli') -ForegroundColor Green } else { Write-Host '   NESSUN CSV prodotto (il terminale potrebbe aver chiesto un login o essersi chiuso prima)' -ForegroundColor Red }
  $w2=Get-Date; while(-not $pr.HasExited -and ((Get-Date)-$w2).TotalSeconds -lt 60){ Start-Sleep -Seconds 3 }
  if(-not $pr.HasExited){ Write-Host '   il terminale e ancora aperto: chiudilo tu a mano (File > Esci) prima di continuare' -ForegroundColor Yellow; break }
}
$zip=Join-Path 'C:\ABTG_RISULTATI' ('SWAPINFO_TUTTI_' + $stamp + '.zip')
if($fatti -gt 0){ Compress-Archive -Path (Join-Path $out '*') -DestinationPath $zip -Force } else { Write-Host 'Nessun file prodotto: avvisa Claude.' -ForegroundColor Red; return }
$xau=@(); foreach($f in @(Get-ChildItem -LiteralPath $out -Filter *.csv)){ foreach($r in @(Get-Content -LiteralPath $f.FullName)){ if($r -match '^(XAUUSD|GOLD|XAU)[^;]*;'){ $xau += ($f.Name + ' -> ' + $r) } } }
Write-Host ''
Write-Host 'XAUUSD (simbolo;modo;testo;swap_long;swap_short;giorno_triplo;...;stima_long_per_lotto_notte;stima_short):' -ForegroundColor Cyan
$xau | ForEach-Object { Write-Host ('  ' + $_) }
Write-Host ''
Write-Host ('>>> ALLEGA QUESTO FILE: ' + $zip + ' <<<') -ForegroundColor Black -BackgroundColor Yellow
try{ Set-Clipboard -Value ($xau -join "`r`n") } catch { }
Start-Process explorer.exe -ArgumentList ('/select,"' + $zip + '"')
