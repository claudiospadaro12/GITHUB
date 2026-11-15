# MARCATORE_VALIDA_CANDIDATI_OPT_v1
# Convalida dei candidati del pilota di ottimizzazione EURUSD D1 (criteri, sezioni 4, 5 e 14) sul MT5 PORTABLE C:\MT5_BCM_Opt. 6 candidati (C0 base, C1 = passaggio 1, C2 = 52, C3 = 45, C4 = 126, C5 = 2 del genetico G1) x 3 passate: IS = 2013-2022 Modello 1 (riproduzione), OOS1_M1 = 2023-2024 Modello 1, OOS1_M4 = 2023-2024 TICK REALI. Il 2025 (hold-out) NON si tocca. Lotto 0,1, deposito 100000 EUR.
# Scrive SOLO: file VAL_*.set in C:\MT5_BCM_Opt\MQL5\Profiles\Tester, un .ini in %TEMP%\abtg_opt_val, i report e i log che MT5 scrive da se dentro C:\MT5_BCM_Opt, e un CSV in Desktop\ABTG_RISULTATI\VALIDA_OPT_<data>. NON tocca gli altri terminali, i conti, il VPS, AppData. NON chiude MAI un terminale con la forza.
$ErrorActionPreference='Continue'
if($env:COMPUTERNAME -ne 'DESKTOP-H4D7CAJ'){ Write-Host ('SOLO sul PC di backtest DESKTOP-H4D7CAJ. Qui: ' + $env:COMPUTERNAME) -ForegroundColor Red; return }
$T='C:\MT5_BCM_Opt\terminal64.exe'; $EA='C:\MT5_BCM_Opt\MQL5\Experts\WIM\Ultimate_Breakout_EA_WSC_V9.5.ex5'; $HEA='AD2A7AC8C56E2756E4FE576F441227D11A2067B78F7BC4D200C76D111FD6EB4A'
$STD='C:\MT5_BCM_Opt\MQL5\Profiles\Tester'; $SRC=Join-Path $STD 'OPT1_PILOTA.set'
$aperti=@(Get-Process -Name terminal64,metatester64,metaeditor64 -ErrorAction SilentlyContinue)
if($aperti.Count -gt 0){ $aperti | Select-Object Id,ProcessName,Path | Format-Table -AutoSize | Out-String | Write-Host; Write-Host 'MI FERMO: ci sono MT5, MetaEditor o agenti del tester aperti. Chiudili (anche l ottimizzazione: premi Interrompi) e rilancia. Non ho avviato niente.' -ForegroundColor Red; return }
foreach($f in @($T,$EA,$SRC)){ if(-not (Test-Path -LiteralPath $f)){ Write-Host ('MI FERMO: non trovo ' + $f + '. Non ho avviato niente.') -ForegroundColor Red; return } }
$h=(Get-FileHash -LiteralPath $EA -Algorithm SHA256).Hash.ToUpperInvariant(); if($h -ne $HEA){ Write-Host ('MI FERMO: l EA ha SHA256 ' + $h + ' invece di ' + $HEA + '. Non ho avviato niente.') -ForegroundColor Red; return }
$NOMI=@('ST1_MinDist_to_HL','ST1_Expiration_hours','Exit_stop','Exit_limit','Exit_TrailSL_size','Exit_TrailSL_Start')
$CAND=@( @('C0_BASE',13,155,175,120,100,160), @('C1_P1',72,190,60,75,5,5), @('C2_P52',70,240,180,235,195,110), @('C3_P45',13,80,235,265,140,120), @('C4_P126',89,160,210,75,55,25), @('C5_P2',87,240,85,75,155,195) )
$SC=@( @('OOS1_M1','1','2023.01.01','2024.12.31'), @('IS','1','2013.01.01','2022.12.31'), @('OOS1_M4','4','2023.01.01','2024.12.31') )
$bs=[IO.File]::ReadAllBytes($SRC); $uni=($bs.Length -ge 2 -and $bs[0] -eq 255 -and $bs[1] -eq 254)
$ts=$(if($uni){ [Text.Encoding]::Unicode.GetString($bs) } else { [Text.Encoding]::UTF8.GetString($bs) })
$nl=$(if($ts.Contains("`r`n")){ "`r`n" } else { "`n" })
function NuovoSet($cx){
  $out=New-Object System.Collections.ArrayList
  foreach($r in ($ts -split "`r?`n")){
    $x=$r
    $m=[regex]::Match($r,'^(?<n>[A-Za-z0-9_]+)=(?<v>[^|]*)\|\|(?<a>[^|]*)\|\|(?<s>[^|]*)\|\|(?<z>[^|]*)\|\|(?<f>[YN])\s*$')
    if($m.Success){
      $n=$m.Groups['n'].Value; $v=$m.Groups['v'].Value; $i=[array]::IndexOf($NOMI,$n)
      if($i -ge 0){ $v=[string]$cx[$i+1] }
      $x=$n + '=' + $v + '||' + $m.Groups['a'].Value + '||' + $m.Groups['s'].Value + '||' + $m.Groups['z'].Value + '||N'
    }
    [void]$out.Add($x)
  }
  $new=($out -join $nl)
  $nb=$(if($uni){ [Text.Encoding]::Unicode.GetBytes($new) } else { (New-Object Text.UTF8Encoding($false)).GetBytes($new) })
  [IO.File]::WriteAllBytes((Join-Path $STD ('VAL_' + $cx[0] + '.set')),$nb)
}
function Leggi($rf){
  $r=@{ q='n/d'; n='n/d'; net='n/d'; pf='n/d'; dd='n/d' }
  if(-not (Test-Path -LiteralPath $rf)){ return $r }
  $b=[IO.File]::ReadAllBytes($rf); $tx=$(if($b.Length -ge 2 -and (($b[0] -eq 255 -and $b[1] -eq 254) -or ($b[0] -eq 254 -and $b[1] -eq 255))){ [Text.Encoding]::Unicode.GetString($b) } else { [Text.Encoding]::UTF8.GetString($b) })
  $tx=[regex]::Replace($tx,'<[^>]*>','|'); $tx=[regex]::Replace($tx,'\s*\|[\s|]*','|')
  $mm=[regex]::Match($tx,'Qualit. dello Storico:\|([^|]*)\|'); if($mm.Success){ $r.q=$mm.Groups[1].Value }
  $mm=[regex]::Match($tx,'Numero di Operazioni di Trading Totali:\|([^|]*)\|'); if($mm.Success){ $r.n=$mm.Groups[1].Value }
  $mm=[regex]::Match($tx,'Profitto Totale Netto:\|([^|]*)\|'); if($mm.Success){ $r.net=$mm.Groups[1].Value }
  $mm=[regex]::Match($tx,'Fattore di Profitto:\|([^|]*)\|'); if($mm.Success){ $r.pf=$mm.Groups[1].Value }
  $mm=[regex]::Match($tx,'Equit. Drawdown Massima:\|([^|]*)\|'); if($mm.Success){ $r.dd=$mm.Groups[1].Value }
  return $r
}
$W=Join-Path $env:TEMP 'abtg_opt_val'; New-Item -ItemType Directory -Force -Path $W | Out-Null
$stamp=(Get-Date).ToString('yyyyMMdd_HHmmss'); $res=New-Object System.Collections.ArrayList
$tot=$CAND.Count * $SC.Count; $k=0; $t00=Get-Date; $stop=$false
foreach($s in $SC){
  if($stop){ break }
  foreach($cx in $CAND){
    if($stop){ break }
    $k++; NuovoSet $cx
    $rep='VAL_' + $cx[0] + '_' + $s[0]; $rf=Join-Path 'C:\MT5_BCM_Opt' ($rep + '.htm'); Remove-Item -LiteralPath $rf -Force -ErrorAction SilentlyContinue
    $ini=Join-Path $W ($rep + '.ini')
    $righe=@('[Experts]','AllowLiveTrading=false','AllowDllImport=false','','[Tester]','Expert=WIM\Ultimate_Breakout_EA_WSC_V9.5.ex5',('ExpertParameters=VAL_' + $cx[0] + '.set'),'Symbol=EURUSD','Period=D1',('Model=' + $s[1]),'Optimization=0',('FromDate=' + $s[2]),('ToDate=' + $s[3]),'ForwardMode=0','Deposit=100000','Currency=EUR','Leverage=100','ExecutionMode=0','Visual=0','ReplaceReport=1','ShutdownTerminal=1',('Report=' + $rep),'','[TesterInputs]')
    Set-Content -LiteralPath $ini -Value (($righe -join "`r`n") + "`r`n") -Encoding ASCII -NoNewline
    $t0=Get-Date
    Write-Host ('[' + $k + '/' + $tot + '] ' + $rep + '  (' + $s[2] + ' -> ' + $s[3] + ', Modello ' + $s[1] + ')  avvio ' + $t0.ToString('HH:mm:ss')) -ForegroundColor Cyan
    $p=Start-Process -FilePath $T -ArgumentList ('/portable /config:"' + $ini + '"') -PassThru
    $scade=$t0.AddMinutes(120)
    while(-not $p.HasExited -and (Get-Date) -lt $scade){ Start-Sleep -Seconds 5 }
    if(-not $p.HasExited){ Write-Host ('   TIMEOUT dopo 120 minuti: provo CloseMainWindow (mai la forza).') -ForegroundColor Red; try{ [void]$p.CloseMainWindow() }catch{ }; $a=0; while(-not $p.HasExited -and $a -lt 18){ Start-Sleep -Seconds 5; $a=$a+1 }; if(-not $p.HasExited){ Write-Host ('   Il terminale PID ' + $p.Id + ' NON si e chiuso: chiudilo A MANO (cartella C:\MT5_BCM_Opt). MI FERMO.') -ForegroundColor Red; $stop=$true; break } }
    $x=Leggi $rf; $sec=[math]::Round(((Get-Date)-$t0).TotalSeconds)
    $o=[pscustomobject]@{ cand=$cx[0]; passata=$s[0]; modello=$s[1]; qualita=$x.q; operazioni=$x.n; netto=$x.net; PF=$x.pf; DD=$x.dd; secondi=$sec }
    [void]$res.Add($o)
    Write-Host ('   qualita ' + $x.q + ' | operazioni ' + $x.n + ' | netto ' + $x.net + ' | PF ' + $x.pf + ' | DD ' + $x.dd + ' | ' + $sec + ' s') -ForegroundColor Green
  }
}
Write-Host ''; Write-Host '=== RIEPILOGO ===' -ForegroundColor Cyan
$res | Format-Table -AutoSize | Out-String -Width 250 | Write-Host
try{ $cd=Join-Path ([Environment]::GetFolderPath('Desktop')) ('ABTG_RISULTATI\VALIDA_OPT_' + $stamp); New-Item -ItemType Directory -Force -Path $cd | Out-Null; $res | Export-Csv -LiteralPath (Join-Path $cd 'risultati.csv') -NoTypeInformation -Delimiter ';' -Encoding ASCII; Write-Host ('CSV: ' + $cd + '\risultati.csv') -ForegroundColor Green }catch{ Write-Host 'CSV non scritto.' -ForegroundColor Yellow }
Write-Host ('Fine. Durata totale ' + [math]::Round(((Get-Date)-$t00).TotalMinutes) + ' minuti. Mandami la foto del RIEPILOGO.') -ForegroundColor Green
