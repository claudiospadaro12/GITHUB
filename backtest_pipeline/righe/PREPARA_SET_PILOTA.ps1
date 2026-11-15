# MARCATORE_PREPARA_SET_PILOTA_v1
# Crea il set del pilota di ottimizzazione EURUSD D1 partendo da UBS_V9_0\...\daytrade 2(DAILY)\optimization.set (gia copiato nel MT5 portable): lascia attivi per l'ottimizzazione (||Y) SOLO i 6 parametri scelti nei criteri e mette i valori decisi: Risk=0, StartLots=0.1, EP=3, RF=1.5, TR=150. Tutto il resto resta com'e.
# Scrive SOLO: C:\MT5_BCM_Opt\MQL5\Profiles\Tester\OPT1_PILOTA.set (se esiste gia, ne fa prima una copia con data). NON apre ne chiude MT5, NON tocca altri terminali, conti, VPS, AppData.
$ErrorActionPreference='Continue'
if($env:COMPUTERNAME -ne 'DESKTOP-H4D7CAJ'){ Write-Host ('SOLO sul PC di backtest DESKTOP-H4D7CAJ. Qui: ' + $env:COMPUTERNAME) -ForegroundColor Red; return }
$aperti=@(Get-Process -Name terminal64,metatester64,metaeditor64 -ErrorAction SilentlyContinue)
if($aperti.Count -gt 0){ $aperti | Select-Object Id,ProcessName,Path | Format-Table -AutoSize | Out-String | Write-Host; Write-Host 'MI FERMO: ci sono MT5, MetaEditor o agenti del tester aperti. Chiudili e rilancia. Non ho scritto niente.' -ForegroundColor Red; return }
$SRC='C:\MT5_BCM_Opt\MQL5\Profiles\Tester\UBS_V9_0\Breakout_Support_Resistance\Other sets\daytrade 2(DAILY)\optimization.set'
$DST='C:\MT5_BCM_Opt\MQL5\Profiles\Tester\OPT1_PILOTA.set'
if(-not (Test-Path -LiteralPath $SRC)){ Write-Host ('MI FERMO: non trovo il set sorgente ' + $SRC + '. Non ho scritto niente.') -ForegroundColor Red; return }
$LIBERI=@('Exit_stop','Exit_limit','ST1_MinDist_to_HL','Exit_TrailSL_size','Exit_TrailSL_Start','ST1_Expiration_hours')
$VALORI=@{ 'Risk'='0'; 'StartLots'='0.1'; 'EP'='3'; 'RF'='1.5'; 'TR'='150' }
$b=[IO.File]::ReadAllBytes($SRC)
$uni=($b.Length -ge 2 -and $b[0] -eq 255 -and $b[1] -eq 254)
$t=$(if($uni){ [Text.Encoding]::Unicode.GetString($b) } else { [Text.Encoding]::UTF8.GetString($b) })
$nl=$(if($t.Contains("`r`n")){ "`r`n" } else { "`n" })
$righe=@($t -split "`r?`n")
$out=New-Object System.Collections.ArrayList
$cambi=@(); $yes=@(); $trovati=@{}
foreach($r in $righe){
  $x=$r
  $m=[regex]::Match($r,'^(?<n>[A-Za-z0-9_]+)=(?<v>[^|]*)\|\|(?<a>[^|]*)\|\|(?<s>[^|]*)\|\|(?<z>[^|]*)\|\|(?<f>[YN])\s*$')
  if($m.Success){
    $n=$m.Groups['n'].Value; $v=$m.Groups['v'].Value; $f=$m.Groups['f'].Value
    if($VALORI.ContainsKey($n)){ $v=$VALORI[$n]; $trovati[$n]=1 }
    $nf=$(if($LIBERI -contains $n){ 'Y' } else { 'N' })
    if($LIBERI -contains $n){ $trovati[$n]=1 }
    $x=$n + '=' + $v + '||' + $m.Groups['a'].Value + '||' + $m.Groups['s'].Value + '||' + $m.Groups['z'].Value + '||' + $nf
    if($x -ne $r.TrimEnd()){ $cambi += ('   ' + $r.Trim() + '   ->   ' + $x) }
    if($nf -eq 'Y'){ $yes += $x }
  } else {
    $m2=[regex]::Match($r,'^(?<n>Risk|StartLots|EP|RF|TR)=(?<v>[^|]*)$')
    if($m2.Success){ $n=$m2.Groups['n'].Value; $x=$n + '=' + $VALORI[$n]; $trovati[$n]=1; if($x -ne $r.TrimEnd()){ $cambi += ('   ' + $r.Trim() + '   ->   ' + $x) } }
  }
  [void]$out.Add($x)
}
Write-Host ('Righe lette: ' + $righe.Count + '. Parametri attivi per l ottimizzazione (||Y) dopo la modifica: ' + $yes.Count) -ForegroundColor Cyan
$yes | ForEach-Object { Write-Host ('   ' + $_) -ForegroundColor Green }
Write-Host 'Righe cambiate:' -ForegroundColor Cyan
$cambi | ForEach-Object { Write-Host $_ -ForegroundColor Yellow }
$mancano=@(@($VALORI.Keys) + $LIBERI | Where-Object { -not $trovati.ContainsKey($_) })
if($yes.Count -ne 6){ Write-Host ('MI FERMO: i parametri attivi sono ' + $yes.Count + ' invece di 6. Non ho scritto niente.') -ForegroundColor Red; return }
if($mancano.Count -gt 0){ Write-Host ('MI FERMO: nel set non ho trovato queste righe: ' + ($mancano -join ', ') + '. Non ho scritto niente.') -ForegroundColor Red; return }
if(Test-Path -LiteralPath $DST){ Copy-Item -LiteralPath $DST -Destination ($DST + '.prima_' + (Get-Date).ToString('yyyyMMdd_HHmmss')) -Force }
$new=($out -join $nl)
$nb=$(if($uni){ [Text.Encoding]::Unicode.GetBytes($new) } else { (New-Object Text.UTF8Encoding($false)).GetBytes($new) })
[IO.File]::WriteAllBytes($DST,$nb)
Write-Host ('Fatto: ' + $DST + '  (' + $nb.Length + ' byte). In MT5: Strategy Tester > Inputs > tasto destro > Load > OPT1_PILOTA.set.') -ForegroundColor Green
