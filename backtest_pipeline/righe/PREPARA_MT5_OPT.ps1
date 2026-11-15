# MARCATORE_PREPARA_MT5_OPT_v1
# Prepara un MT5 PORTABLE per l'UBS Optimizer: copia C:\MT5_BCM_Tester2 in C:\MT5_BCM_Opt, copia l'EA Ultimate_Breakout_EA_WSC_V9.5.ex5 (con controllo SHA256) in C:\MT5_BCM_Opt\MQL5\Experts\WIM e crea l'icona sul Desktop con /portable.
# Scrive SOLO: C:\MT5_BCM_Opt (nuova, deve NON esistere) e un collegamento sul Desktop. NON apre ne chiude MT5, NON tocca terminali, conti, VPS, ne le cartelle dati in AppData (l'EA si LEGGE soltanto).
$ErrorActionPreference='Continue'
if($env:COMPUTERNAME -ne 'DESKTOP-H4D7CAJ'){ Write-Host ('SOLO sul PC di backtest DESKTOP-H4D7CAJ. Qui: ' + $env:COMPUTERNAME) -ForegroundColor Red; return }
$ORIG='C:\MT5_BCM_Tester2'; $DEST='C:\MT5_BCM_Opt'
$EAORIG=Join-Path $env:APPDATA 'MetaQuotes\Terminal\215D85D767A1C39E22D242C8114BF9F5\MQL5\Experts\WIM\Ultimate_Breakout_EA_WSC_V9.5.ex5'
$HEA='AD2A7AC8C56E2756E4FE576F441227D11A2067B78F7BC4D200C76D111FD6EB4A'
$aperti=@(Get-Process -Name terminal64,metatester64,metaeditor64 -ErrorAction SilentlyContinue)
if($aperti.Count -gt 0){ $aperti | Select-Object Id,ProcessName,Path | Format-Table -AutoSize | Out-String | Write-Host; Write-Host 'MI FERMO: ci sono MT5, MetaEditor o agenti del tester aperti (elenco sopra). Chiudili e rilancia. Non ho copiato niente.' -ForegroundColor Red; return }
if(-not (Test-Path -LiteralPath (Join-Path $ORIG 'terminal64.exe'))){ Write-Host ('MI FERMO: non trovo ' + $ORIG + '\terminal64.exe. Non ho copiato niente.') -ForegroundColor Red; return }
if(Test-Path -LiteralPath $DEST){ Write-Host ('MI FERMO: ' + $DEST + ' ESISTE gia. Non la tocco: rinominala o dimmi cosa contiene. Non ho copiato niente.') -ForegroundColor Red; return }
if(-not (Test-Path -LiteralPath $EAORIG)){ Write-Host ('MI FERMO: non trovo l EA sorgente ' + $EAORIG + '. Non ho copiato niente.') -ForegroundColor Red; return }
$h0=(Get-FileHash -LiteralPath $EAORIG -Algorithm SHA256).Hash.ToUpperInvariant()
if($h0 -ne $HEA){ Write-Host ('MI FERMO: l EA sorgente ha SHA256 ' + $h0 + ' invece di ' + $HEA + '. Non ho copiato niente.') -ForegroundColor Red; return }
Write-Host ('1/4 Copio ' + $ORIG + ' in ' + $DEST + ' ...') -ForegroundColor Cyan
Copy-Item -LiteralPath $ORIG -Destination $DEST -Recurse -Force -ErrorAction Stop
if(-not (Test-Path -LiteralPath (Join-Path $DEST 'terminal64.exe'))){ Write-Host 'ERRORE: la copia non contiene terminal64.exe.' -ForegroundColor Red; return }
Write-Host '2/4 Copio l EA nella cartella portable ...' -ForegroundColor Cyan
$dw=Join-Path $DEST 'MQL5\Experts\WIM'; New-Item -ItemType Directory -Force -Path $dw | Out-Null
Copy-Item -LiteralPath $EAORIG -Destination (Join-Path $dw 'Ultimate_Breakout_EA_WSC_V9.5.ex5') -Force -ErrorAction Stop
$h1=(Get-FileHash -LiteralPath (Join-Path $dw 'Ultimate_Breakout_EA_WSC_V9.5.ex5') -Algorithm SHA256).Hash.ToUpperInvariant()
if($h1 -ne $HEA){ Write-Host ('ERRORE: la copia dell EA ha SHA256 ' + $h1 + ' invece di ' + $HEA + '.') -ForegroundColor Red; return }
Write-Host '3/4 Creo l icona sul Desktop ...' -ForegroundColor Cyan
$l=Join-Path ([Environment]::GetFolderPath('Desktop')) 'MT5 Optimizer PORTABLE.lnk'
$s=(New-Object -ComObject WScript.Shell).CreateShortcut($l); $s.TargetPath=(Join-Path $DEST 'terminal64.exe'); $s.Arguments='/portable'; $s.WorkingDirectory=$DEST; $s.Description='MT5 portable solo per UBS Optimizer (demo 50503392)'; $s.Save()
Write-Host '4/4 Fatto. Riepilogo:' -ForegroundColor Green
Write-Host ('   cartella portable : ' + $DEST) -ForegroundColor Green
Write-Host ('   EA copiato        : ' + $dw + '\Ultimate_Breakout_EA_WSC_V9.5.ex5  (' + (Get-Item -LiteralPath (Join-Path $dw 'Ultimate_Breakout_EA_WSC_V9.5.ex5')).Length + ' byte, SHA256 UGUALE)') -ForegroundColor Green
Write-Host ('   icona             : ' + $l) -ForegroundColor Green
Write-Host 'Non ho aperto nessun MT5. Apri l icona UNA volta, accedi al demo 50503392, chiudi i grafici, spegni il trading automatico e controlla che il titolo mostri C:\MT5_BCM_Opt.' -ForegroundColor Yellow
