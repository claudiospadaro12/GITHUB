# MARCATORE_AVVIA_OTT_GEN_v1
# OTTIMIZZAZIONE GENETICA (o completa) di un set UBS nel MT5 PORTABLE C:\MT5_BCM_Opt (demo BCM 50503392, solo tester). Derivata da AVVIA_OTT_ORO2.ps1 (stesso metodo CORRETTO:
# TUTTI gli input nel [TesterInputs], niente ExpertParameters; passata di controllo F prima dell'ottimizzazione). Il set di ottimizzazione si prende dallo zip di Wim sul PC
# (Desktop, Download, Documenti) per percorso, si copia come OPTGEN_<Etichetta>.set in MQL5\Profiles\Tester (l'originale non si modifica).
# SENZA -Esegui: PROVA, non avvia MT5, non scrive nel terminale: elenca i parametri liberi, lo spazio delle combinazioni, i minimi Custom max, e i controlli.
# CON -Esegui: passata di controllo singola (conta i trade, deve aprire operazioni; se date -AttesoProfitto/-AttesoOps deve coincidere) e poi l'ottimizzazione.
# NON tocca altri terminali, conti, VPS, FTMO, reale. NON chiude MT5 (a fine ottimizzazione resta aperto: i risultati si esportano a mano in XML). Tiene sveglio il PC.
# ASCII PURO.
param(
  [Parameter(Mandatory=$true)][ValidatePattern('^[A-Za-z0-9._]{3,14}$')][string]$Simbolo,
  [Parameter(Mandatory=$true)][ValidateSet('M1','M5','M15','M30','H1','H2','H3','H4','H6','H8','H12','D1')][string]$Periodo,
  [Parameter(Mandatory=$true)][ValidatePattern('^20[0-2][0-9]\.[01][0-9]\.[0-3][0-9]$')][string]$Da,
  [Parameter(Mandatory=$true)][ValidatePattern('^20[0-2][0-9]\.[01][0-9]\.[0-3][0-9]$')][string]$A,
  [Parameter(Mandatory=$true)][ValidatePattern('^[A-Za-z0-9 ()_.\\/-]{3,120}$')][string]$SetRel,
  [Parameter(Mandatory=$true)][ValidatePattern('^[A-Za-z0-9_]{3,20}$')][string]$Etichetta,
  [ValidateSet(1,4)][int]$Modello = 1,
  [ValidateSet(1,2)][int]$Algoritmo = 2,
  [int]$Criterio = 6,
  [double]$AttesoProfitto = [double]::NaN,
  [int]$AttesoOps = -1,
  [int]$TettoOre = 12,
  [string]$ZipNome = 'Ultimate-Breakout-System-Set-Files*.zip',
  [switch]$Esegui
)
$ErrorActionPreference='Stop'
$INV=[Globalization.CultureInfo]::InvariantCulture
Add-Type -AssemblyName System.IO.Compression
Add-Type -AssemblyName System.IO.Compression.FileSystem
function Muori($m){ Write-Host ''; Write-Host ('FERMO: ' + $m + ' Non ho avviato MT5.') -ForegroundColor Red; Write-Host 'STATO: FERMO'; exit 1 }
if($env:COMPUTERNAME -ne 'DESKTOP-H4D7CAJ'){ Muori ('SOLO sul PC di backtest DESKTOP-H4D7CAJ. Qui: ' + $env:COMPUTERNAME + '.') }
if([datetime]::ParseExact($Da,'yyyy.MM.dd',$INV) -ge [datetime]::ParseExact($A,'yyyy.MM.dd',$INV)){ Muori '-Da deve essere prima di -A.' }
$T='C:\MT5_BCM_Opt\terminal64.exe'; $EA='C:\MT5_BCM_Opt\MQL5\Experts\WIM\Ultimate_Breakout_EA_WSC_V9.5.ex5'; $HEA='AD2A7AC8C56E2756E4FE576F441227D11A2067B78F7BC4D200C76D111FD6EB4A'
$DIRSET='C:\MT5_BCM_Opt\MQL5\Profiles\Tester'
foreach($pp in @($T,$EA,$DIRSET)){ if(-not (Test-Path -LiteralPath $pp)){ Muori ('non trovo ' + $pp + '.') } }
$h=(Get-FileHash -LiteralPath $EA -Algorithm SHA256).Hash.ToUpperInvariant(); if($h -ne $HEA){ Muori ('l EA ha SHA256 ' + $h + ' invece di ' + $HEA + '.') }
Write-Host ('[1] EA V9.5 verificato (SHA256 ok). Terminale: ' + $T) -ForegroundColor Green
# zip dei set di Wim
$cerca=@([Environment]::GetFolderPath('Desktop'),(Join-Path $env:USERPROFILE 'Downloads'),(Join-Path $env:USERPROFILE 'Documents'))
$zf=$null
foreach($c in $cerca){ if((-not $zf) -and (Test-Path -LiteralPath $c)){ $g=@(Get-ChildItem -LiteralPath $c -Recurse -Depth 3 -File -ErrorAction SilentlyContinue | Where-Object { $_.Name -like $ZipNome } | Sort-Object LastWriteTime -Descending | Select-Object -First 1); if($g.Count -gt 0){ $zf=$g[0] } } }
if(-not $zf){ Muori ('non trovo uno zip "' + $ZipNome + '" in Desktop, Download o Documenti.') }
$coda=('\' + ($SetRel -replace '/','\').TrimStart('\'))
$za=[IO.Compression.ZipFile]::OpenRead($zf.FullName)
try {
  $m=@($za.Entries | Where-Object { $_.Name -ne '' -and (('\' + ($_.FullName -replace '/','\')).EndsWith($coda, [StringComparison]::OrdinalIgnoreCase)) })
  if($m.Count -ne 1){ Muori ('nello zip ' + $zf.FullName + ' il set "' + $SetRel + '" corrisponde a ' + $m.Count + ' file (ne serve 1).') }
  $ms=New-Object IO.MemoryStream; $si=$m[0].Open(); try { $si.CopyTo($ms) } finally { $si.Dispose() }; $sb=$ms.ToArray(); $ms.Dispose()
} finally { $za.Dispose() }
$shaSet=[BitConverter]::ToString([Security.Cryptography.SHA256]::Create().ComputeHash($sb)).Replace('-','')
$st=$(if($sb.Length -ge 2 -and $sb[0] -eq 255 -and $sb[1] -eq 254){ [Text.Encoding]::Unicode.GetString($sb) } else { [Text.Encoding]::UTF8.GetString($sb) })
Write-Host ('[2] set letto da ' + $zf.FullName + ' : ' + $m[0].FullName + ' (SHA256 ' + $shaSet + ')') -ForegroundColor Green
$tutte=@(); foreach($r in ($st -split "`r?`n")){ $x=$r.Trim([char]0xFEFF).Trim(); if($x -ne '' -and -not $x.StartsWith(';') -and $x.Contains('=')){ $tutte += $x } }
# ForceSymbol = simbolo del test
$fs=0; for($i=0; $i -lt $tutte.Count; $i++){ if($tutte[$i] -match '^ForceSymbol='){ $tutte[$i]='ForceSymbol=' + $Simbolo; $fs++ } }
if($fs -ne 1){ Muori ('il set ha ' + $fs + ' righe ForceSymbol (ne attendo 1).') }
$ys=@($tutte | Where-Object { $_ -match '^[A-Za-z0-9_]+=[^|]*\|\|[^|]*\|\|[^|]*\|\|[^|]*\|\|Y$' })
if($ys.Count -lt 2 -or $ys.Count -gt 25){ Muori ('i parametri liberi (||Y) sono ' + $ys.Count + ' (attesi da 2 a 25).') }
if(@($tutte | Where-Object { $_ -match '^Risk=0\|\|' }).Count -ne 1 -or @($tutte | Where-Object { $_ -match '^StartLots=0\.1\|\|' }).Count -ne 1){ Muori 'nel set Risk non e 0 o StartLots non e 0.1 (lotto fisso 0,1 richiesto).' }
function Num([string]$s){ $c=($s -replace '[^0-9.\-]',''); $v=0.0; if([double]::TryParse($c,[Globalization.NumberStyles]::Float,$INV,[ref]$v)){ return $v } else { return [double]::NaN } }
$comb=1.0; $righeY=@()
foreach($y in $ys){ $p=$y.Split('='); $f=$p[1].Split('|') | Where-Object { $_ -ne '' }; $v0=Num $f[0]; $lo=Num $f[1]; $stp=Num $f[2]; $hi=Num $f[3]
  $n=1.0; if($stp -gt 0 -and $hi -gt $lo){ $n=[math]::Floor(($hi-$lo)/$stp + 1e-9)+1 }; $comb=$comb*$n; $righeY += ($p[0] + ': da ' + $lo + ' a ' + $hi + ' passo ' + $stp + ' (valori ' + $n + ', centro ' + $v0 + ')') }
$cm=@{}; foreach($k in @('EP','RF','TR','MTR')){ $q=@($tutte | Where-Object { $_ -match ('^' + $k + '=') }); $cm[$k]=$(if($q.Count){ ($q[0].Split('=')[1].Split('|')[0]) } else { '?' }) }
Write-Host ('[3] parametri liberi: ' + $ys.Count + '; combinazioni possibili: ' + $comb.ToString('0.###E+0',$INV) + '; Custom max minimi: EP=' + $cm['EP'] + ' RF=' + $cm['RF'] + ' TR(operazioni)=' + $cm['TR'] + ' MTR=' + $cm['MTR']) -ForegroundColor Cyan
$righeY | ForEach-Object { Write-Host ('      ' + $_) -ForegroundColor Green }
$hist=Join-Path 'C:\MT5_BCM_Opt\bases\BCMMarkets-Server\history' $Simbolo
$nh=$(if(Test-Path -LiteralPath $hist){ @(Get-ChildItem -LiteralPath $hist -File -ErrorAction SilentlyContinue).Count } else { 0 })
Write-Host ('[4] storico di ' + $Simbolo + ' nel portable: ' + $nh + ' file anno (il tester scarica dal server BCM quello che manca, se esiste).') -ForegroundColor Cyan
if(-not $Esegui){
  Write-Host ''; Write-Host ('PROVA: nessun MT5 avviato, niente scritto. Con -Esegui: copia il set come OPTGEN_' + $Etichetta + '.set, passata di controllo (' + $Simbolo + ' ' + $Periodo + ' ' + $Da + ' -> ' + $A + ', Modello ' + $Modello + '), poi ottimizzazione ' + $(if($Algoritmo -eq 2){ 'GENETICA' } else { 'COMPLETA' }) + ' criterio ' + $Criterio + ', tetto ' + $TettoOre + ' ore.') -ForegroundColor Cyan
  Write-Host 'STATO: PROVA_OK'; exit 0
}
$aperti=@(Get-Process -Name terminal64,metatester64,metaeditor64 -ErrorAction SilentlyContinue)
if($aperti.Count -gt 0){ $aperti | Select-Object Id,ProcessName,Path | Format-Table -AutoSize | Out-String | Write-Host; Muori 'ci sono MT5, MetaEditor o agenti del tester aperti: chiudili e rilancia.' }
$copia=Join-Path $DIRSET ('OPTGEN_' + $Etichetta + '.set'); [IO.File]::WriteAllBytes($copia,$sb)
if(-not ('MasterSveglia.Win' -as [type])){ Add-Type -Namespace MasterSveglia -Name Win -MemberDefinition '[DllImport("kernel32.dll")] public static extern uint SetThreadExecutionState(uint esFlags);' }
[void][MasterSveglia.Win]::SetThreadExecutionState([uint32]2147483651)
$W=Join-Path $env:TEMP 'abtg_opt_gen'; New-Item -ItemType Directory -Force -Path $W | Out-Null
$ESC={ [void][MasterSveglia.Win]::SetThreadExecutionState([uint32]2147483648) }
function Passata([string]$nome){
  $rep='OPTGEN_' + $Etichetta + '_' + $nome; $ini=Join-Path $W ('gen_' + $Etichetta + '_' + $nome + '.ini')
  $r=@('[Experts]','AllowLiveTrading=false','AllowDllImport=false','','[Tester]','Expert=WIM\Ultimate_Breakout_EA_WSC_V9.5.ex5',('Symbol=' + $Simbolo),('Period=' + $Periodo),('Model=' + $Modello),'Optimization=0',('FromDate=' + $Da),('ToDate=' + $A),'ForwardMode=0','Deposit=100000','Currency=EUR','Leverage=100','ExecutionMode=0','Visual=0','ReplaceReport=1','ShutdownTerminal=1',('Report=' + $rep),'','[TesterInputs]'); $r += $tutte
  Set-Content -LiteralPath $ini -Value (($r -join "`r`n") + "`r`n") -Encoding ASCII -NoNewline
  Remove-Item -LiteralPath ('C:\MT5_BCM_Opt\' + $rep + '.htm') -Force -ErrorAction SilentlyContinue
  $t0=Get-Date; Write-Host ('[' + $t0.ToString('HH:mm:ss') + '] passata di controllo ' + $nome + ' ...') -ForegroundColor Cyan
  $p=Start-Process -FilePath $T -ArgumentList ('/portable /config:"' + $ini + '"') -PassThru
  $scade=$t0.AddMinutes(90); while(-not $p.HasExited -and (Get-Date) -lt $scade){ Start-Sleep -Seconds 5 }
  if(-not $p.HasExited){ Write-Host ('TIMEOUT: il terminale PID ' + $p.Id + ' e ancora aperto: chiudilo a mano.') -ForegroundColor Red; return $null }
  $rf=Join-Path 'C:\MT5_BCM_Opt' ($rep + '.htm'); if(-not (Test-Path -LiteralPath $rf)){ Write-Host ('Report ' + $rep + ' NON trovato.') -ForegroundColor Red; return $null }
  $b=[IO.File]::ReadAllBytes($rf); $tx=$(if($b.Length -ge 2 -and (($b[0] -eq 255 -and $b[1] -eq 254) -or ($b[0] -eq 254 -and $b[1] -eq 255))){ [Text.Encoding]::Unicode.GetString($b) } else { [Text.Encoding]::UTF8.GetString($b) })
  $tx=[regex]::Replace($tx,'<[^>]*>','|'); $tx=[regex]::Replace($tx,'\s*\|[\s|]*','|')
  $g1=[regex]::Match($tx,'Profitto Totale Netto:\|([^|]*)\|'); $g2=[regex]::Match($tx,'Numero di Operazioni di Trading Totali:\|([^|]*)\|'); $g3=[regex]::Match($tx,'Fattore di Profitto:\|([^|]*)\|')
  return @{ prof=$(if($g1.Success){ Num $g1.Groups[1].Value } else { [double]::NaN }); ops=$(if($g2.Success){ Num $g2.Groups[1].Value } else { [double]::NaN }); pf=$(if($g3.Success){ Num $g3.Groups[1].Value } else { [double]::NaN }) }
}
$f=Passata 'F'
if(-not $f -or [double]::IsNaN($f.ops)){ & $ESC; Muori 'la passata di controllo non e finita o il report non e leggibile (MT5 in italiano?).' }
Write-Host ('   F (tutti gli input, centro del set): profitto ' + $f.prof + ', operazioni ' + $f.ops + ', PF ' + $f.pf) -ForegroundColor Yellow
if($f.ops -lt 1){ & $ESC; Muori 'la passata di controllo non ha aperto nessuna operazione: il set non gira su questo simbolo/periodo. Non parte l ottimizzazione.' }
if((-not [double]::IsNaN($AttesoProfitto)) -and ([math]::Abs($f.prof - $AttesoProfitto) -gt 0.5)){ & $ESC; Muori ('il profitto di controllo ' + $f.prof + ' non coincide con l atteso ' + $AttesoProfitto + '.') }
if(($AttesoOps -ge 0) -and ($f.ops -ne $AttesoOps)){ & $ESC; Muori ('le operazioni di controllo ' + $f.ops + ' non coincidono con l atteso ' + $AttesoOps + '.') }
Write-Host 'Controllo superato. Parte l ottimizzazione.' -ForegroundColor Green
$ini=Join-Path $W ('gen_' + $Etichetta + '_ott.ini')
$r=@('[Experts]','AllowLiveTrading=false','AllowDllImport=false','','[Tester]','Expert=WIM\Ultimate_Breakout_EA_WSC_V9.5.ex5',('Symbol=' + $Simbolo),('Period=' + $Periodo),('Model=' + $Modello),('Optimization=' + $Algoritmo),('OptimizationCriterion=' + $Criterio),('FromDate=' + $Da),('ToDate=' + $A),'ForwardMode=0','Deposit=100000','Currency=EUR','Leverage=100','ExecutionMode=0','Visual=0','UseLocal=1','UseRemote=0','UseCloud=0','ReplaceReport=1','ShutdownTerminal=0','','[TesterInputs]'); $r += $tutte
Set-Content -LiteralPath $ini -Value (($r -join "`r`n") + "`r`n") -Encoding ASCII -NoNewline
$t0=Get-Date
Write-Host ('=== OTTIMIZZAZIONE ' + $(if($Algoritmo -eq 2){ 'GENETICA' } else { 'COMPLETA' }) + ' ' + $Etichetta + ': ' + $Simbolo + ' ' + $Periodo + ', ' + $Da + ' -> ' + $A + ', Modello ' + $Modello + ', criterio ' + $Criterio + ' ===') -ForegroundColor Cyan
Write-Host ('Avvio ' + $t0.ToString('dd/MM/yyyy HH:mm:ss') + '. Tetto ' + $TettoOre + ' ore (la finestra non chiude MT5). NON chiudere questa finestra e NON aprire altri MT5.') -ForegroundColor Yellow
$p=Start-Process -FilePath $T -ArgumentList ('/portable /config:"' + $ini + '"') -PassThru
$ultimo=0.0; $giri=0
while(-not $p.HasExited){
  Start-Sleep -Seconds 600; $giri=$giri+1
  $ag=@(Get-Process -Name metatester64 -ErrorAction SilentlyContinue)
  $cpu=0.0; foreach($q in $ag){ try{ $cpu=$cpu+$q.TotalProcessorTime.TotalSeconds }catch{ } }
  $delta=$cpu-$ultimo; $ultimo=$cpu; $durata=((Get-Date)-$t0)
  Write-Host ('[' + (Get-Date).ToString('HH:mm') + '] trascorse ' + [math]::Floor($durata.TotalHours) + ' h ' + $durata.Minutes + ' min; agenti: ' + $ag.Count + '; CPU agenti ultimi 10 min: ' + [math]::Round($delta) + ' s') -ForegroundColor Gray
  if($giri -ge 3 -and $ag.Count -gt 0 -and $delta -lt 30){ Write-Host '   Gli agenti sembrano fermi: probabilmente l ottimizzazione e FINITA. Guarda la scheda Ottimizzazione in MT5.' -ForegroundColor Yellow; break }
  if($durata.TotalHours -gt $TettoOre){ Write-Host ('Oltre ' + $TettoOre + ' ore: non chiudo niente io. Guarda MT5.') -ForegroundColor Red; break }
}
& $ESC
$out='C:\ABTG_RISULTATI'; New-Item -ItemType Directory -Force -Path $out | Out-Null
$xml=Join-Path $out ('OTT_' + $Etichetta + '_' + (Get-Date).ToString('yyyyMMdd_HHmm',$INV) + '.xml')
Write-Host ''
Write-Host 'FINE. File prodotti da questa riga: 1) OPTGEN_*_F.htm (report della passata di controllo, nella cartella di MT5 portable) 2) la copia del set in MQL5\Profiles\Tester. I RISULTATI vanno ESPORTATI A MANO:' -ForegroundColor Cyan
Write-Host '  in MT5: scheda Ottimizzazione -> tasto destro sulla tabella -> "Esporta in XML" -> salva con questo nome:' -ForegroundColor Cyan
Write-Host ('>>> SALVA E ALLEGA: ' + $xml + ' <<<') -ForegroundColor Black -BackgroundColor Yellow
Start-Process explorer.exe -ArgumentList ('"' + $out + '"')
