# MARCATORE_INSTALLA_ORB_SEMI_VPS_v1
# Per un terminale MT5 del VPS (o di un altro PC): ELENCA i terminali trovati con conto e server, chiede QUALE usare, poi copia ABTG_ORB_Semi.mq5 v1.01 in MQL5\Experts, i 3 preset in MQL5\Presets e COMPILA con MetaEditor. NON attacca l'Expert a nessun grafico e non apre ordini. RIFIUTA i conti protetti (challenge FTMO 541452707 e reale 10105439). SHA256 di ogni file verificato.
$ErrorActionPreference='Continue'
$PROTETTI=@('541452707','10105439')
$baseT=Join-Path $env:APPDATA 'MetaQuotes\Terminal'; $lista=New-Object System.Collections.ArrayList
foreach($o in @(Get-ChildItem -LiteralPath $baseT -Directory -ErrorAction SilentlyContinue)){
  $of=Join-Path $o.FullName 'origin.txt'; if(-not (Test-Path -LiteralPath $of)){ continue }
  $inst=((Get-Content -LiteralPath $of -Raw -Encoding Unicode) -replace '[\r\n\0]','').Trim()
  $login='?'; $srv='?'; $ini=Join-Path $o.FullName 'config\common.ini'
  if(Test-Path -LiteralPath $ini){ try { $tx=Get-Content -LiteralPath $ini -Raw -Encoding Unicode; if(-not $tx -or $tx.Length -lt 5){ $tx=Get-Content -LiteralPath $ini -Raw }; $m=[regex]::Match($tx,'(?im)^\s*Login\s*=\s*(\d+)'); if($m.Success){ $login=$m.Groups[1].Value }; $m2=[regex]::Match($tx,'(?im)^\s*Server\s*=\s*(\S+)'); if($m2.Success){ $srv=$m2.Groups[1].Value } } catch { } }
  [void]$lista.Add([pscustomobject]@{ N=($lista.Count+1); Dati=$o.FullName; Inst=$inst; Conto=$login; Server=$srv })
}
if($lista.Count -eq 0){ Write-Host 'Nessun terminale MT5 trovato in AppData. Se il terminale e portatile dammi la cartella a mano.' -ForegroundColor Red; $p=Read-Host 'Cartella dati del terminale (quella che contiene MQL5), o INVIO per uscire'; if(-not $p){ return }; [void]$lista.Add([pscustomobject]@{ N=1; Dati=$p; Inst=$p; Conto='?'; Server='?' }) }
Write-Host ''; Write-Host 'TERMINALI TROVATI SU QUESTO COMPUTER:' -ForegroundColor Cyan
$lista | ForEach-Object { $flag=$(if($PROTETTI -contains $_.Conto){ '   <-- PROTETTO, non lo tocco' } else { '' }); Write-Host ('  [' + $_.N + ']  conto ' + $_.Conto + '   server ' + $_.Server + '   programma ' + $_.Inst + $flag) }
Write-Host ''
$sc=Read-Host 'Numero del terminale dove installare (INVIO per annullare)'; if(-not $sc){ Write-Host 'Annullato, non ho toccato niente.'; return }
$t=@($lista | Where-Object { $_.N -eq [int]$sc }); if($t.Count -ne 1){ Write-Host 'Numero non valido.' -ForegroundColor Red; return }; $T=$t[0]
if($PROTETTI -contains $T.Conto){ Write-Host ('MI FERMO: il conto ' + $T.Conto + ' e PROTETTO (challenge FTMO o reale). Non installo niente.') -ForegroundColor Red; return }
$conf=Read-Host ('Installo ABTG_ORB_Semi nel terminale del conto ' + $T.Conto + ' (' + $T.Server + ')? Scrivi SI per confermare'); if($conf -ne 'SI'){ Write-Host 'Annullato, non ho toccato niente.'; return }
$exp=Join-Path $T.Dati 'MQL5\Experts'; $pre=Join-Path $T.Dati 'MQL5\Presets'; $MEE=Join-Path $T.Inst 'metaeditor64.exe'
if(-not (Test-Path -LiteralPath $exp)){ Write-Host ('MI FERMO: non esiste ' + $exp) -ForegroundColor Red; return }
if(-not (Test-Path -LiteralPath $MEE)){ Write-Host ('MI FERMO: non trovo MetaEditor: ' + $MEE) -ForegroundColor Red; return }
New-Item -ItemType Directory -Force -Path $pre | Out-Null
[Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12
$PIN='594551594a4efda45b32455c4f3fefc32233a13f'
$F=@( @{ src='mql5/Experts/ABTG_ORB_Semi.mq5'; dst=(Join-Path $exp 'ABTG_ORB_Semi.mq5'); h='D1FE2532350137DC3A48B18EA9608D0A77E3F9265D606484DE6713381840C806' }, @{ src='mql5/Presets/ABTG_ORB_Semi_XAUUSD.set'; dst=(Join-Path $pre 'ABTG_ORB_Semi_XAUUSD.set'); h='7A32DDF681C17AC9E2C194D050183AEF5365AD20BFFCDBA6D926C38747C49057' }, @{ src='mql5/Presets/ABTG_ORB_Semi_NASUSD.set'; dst=(Join-Path $pre 'ABTG_ORB_Semi_NASUSD.set'); h='187633850C6D6C831E03CED09F2CE7ECD1A7B0133A33CCCE0C11CEAEC48A2CF0' }, @{ src='mql5/Presets/ABTG_ORB_Semi_U30USD.set'; dst=(Join-Path $pre 'ABTG_ORB_Semi_U30USD.set'); h='7DF1700D4248347E15F0F64E38C91083B8F8AB058EADE51B94A4AFBF8FD8EEA7' } )
$W=Join-Path $env:TEMP 'orb_semi_vps'; New-Item -ItemType Directory -Force -Path $W | Out-Null
foreach($f in $F){
  $tmp=Join-Path $W ([IO.Path]::GetFileName($f.dst)); Remove-Item -LiteralPath $tmp -Force -ErrorAction SilentlyContinue
  irm ('https://raw.githubusercontent.com/claudiospadaro12/GITHUB/' + $PIN + '/' + $f.src + '?cb=' + [Guid]::NewGuid().ToString('N')) -OutFile $tmp
  $H=(Get-FileHash -LiteralPath $tmp -Algorithm SHA256).Hash.ToUpperInvariant(); if($H -ne $f.h){ Write-Host ('MI FERMO: SHA256 diverso per ' + $f.src) -ForegroundColor Red; return }
}
foreach($f in $F){ $tmp=Join-Path $W ([IO.Path]::GetFileName($f.dst)); if(Test-Path -LiteralPath $f.dst){ Copy-Item -LiteralPath $f.dst -Destination ($f.dst + '.bak_' + (Get-Date).ToString('yyyyMMdd_HHmmss')) -Force }; Copy-Item -LiteralPath $tmp -Destination $f.dst -Force; Write-Host ('Copiato: ' + $f.dst) -ForegroundColor Green }
$dst=$F[0].dst; $ex5=[IO.Path]::ChangeExtension($dst,'.ex5'); Remove-Item -LiteralPath $ex5 -Force -ErrorAction SilentlyContinue
$desk=[Environment]::GetFolderPath('Desktop'); $od=Join-Path $desk 'ABTG_RISULTATI'; New-Item -ItemType Directory -Force -Path $od | Out-Null
$log=Join-Path $od ('ORB_Semi_VPS_compilazione_' + (Get-Date).ToString('yyyyMMdd_HHmm') + '.log')
[void](Start-Process -FilePath $MEE -ArgumentList ('/compile:"' + $dst + '" /include:"' + (Join-Path $T.Dati 'MQL5') + '" /log:"' + $log + '"') -PassThru -Wait)
$esito='NESSUN LOG'; if(Test-Path -LiteralPath $log){ $b=[IO.File]::ReadAllBytes($log); $tx=$(if($b.Length -ge 2 -and $b[0] -eq 255 -and $b[1] -eq 254){ [Text.Encoding]::Unicode.GetString($b) } else { [Text.Encoding]::UTF8.GetString($b) }); $m=[regex]::Match($tx,'Result:\s*(\d+) errors?,\s*(\d+) warnings?'); if($m.Success){ $esito=('errori ' + $m.Groups[1].Value + ', avvisi ' + $m.Groups[2].Value) }; ($tx -split "`r?`n" | Where-Object { $_ -match 'error' } | Select-Object -First 25) | ForEach-Object { Write-Host $_ -ForegroundColor Red } }
if((Test-Path -LiteralPath $ex5) -and $esito -match 'errori 0'){ Write-Host ('COMPILATO: ' + $esito + '. File pronto: ' + $ex5) -ForegroundColor Green } else { Write-Host ('COMPILAZIONE NON RIUSCITA (' + $esito + '): allegami il log qui sotto.') -ForegroundColor Red }
Write-Host ''
Write-Host 'COSA FARE ORA SUL VPS: nel terminale scelto, Navigatore -> Expert Advisor -> Aggiorna; trascina ABTG_ORB_Semi su un grafico M5 per simbolo; scheda Input -> Carica il preset del simbolo; Algo Trading attivo.' -ForegroundColor Yellow
Write-Host '##########  FILE DA ALLEGARE ALLA CHAT (solo se ci sono errori)  ##########' -ForegroundColor Black -BackgroundColor Yellow
Write-Host $log -ForegroundColor Black -BackgroundColor Yellow
try { if(Test-Path -LiteralPath $log){ Start-Process explorer.exe -ArgumentList ('/select,"' + $log + '"') } } catch { }
