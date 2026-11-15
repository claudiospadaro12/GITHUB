# MARCATORE_COPIA_SET_OPT_v1
# Copia i set di Wim (pacchetto UPDATED_SETS_UBS_V9_0, gia decompresso dal tester in %USERPROFILE%\abtg_wim_sets) nel MT5 PORTABLE: C:\MT5_BCM_Opt\MQL5\Profiles\Tester\UBS_V9_0.
# Scrive SOLO quella cartella (nuova, deve NON esistere). NON apre ne chiude MT5, NON usa la cartella Common, NON tocca altri terminali, conti, VPS ne AppData.
$ErrorActionPreference='Continue'
if($env:COMPUTERNAME -ne 'DESKTOP-H4D7CAJ'){ Write-Host ('SOLO sul PC di backtest DESKTOP-H4D7CAJ. Qui: ' + $env:COMPUTERNAME) -ForegroundColor Red; return }
$SRC=Join-Path $env:USERPROFILE 'abtg_wim_sets\UPDATED_SETS_UBS_V9_0'; $DST='C:\MT5_BCM_Opt\MQL5\Profiles\Tester\UBS_V9_0'
$aperti=@(Get-Process -Name terminal64,metatester64,metaeditor64 -ErrorAction SilentlyContinue)
if($aperti.Count -gt 0){ $aperti | Select-Object Id,ProcessName,Path | Format-Table -AutoSize | Out-String | Write-Host; Write-Host 'MI FERMO: ci sono MT5, MetaEditor o agenti del tester aperti. Chiudili e rilancia. Non ho copiato niente.' -ForegroundColor Red; return }
if(-not (Test-Path -LiteralPath $SRC)){ Write-Host ('MI FERMO: non trovo ' + $SRC + ' (il pacchetto UPDATED_SETS_UBS_V9_0 non e ancora decompresso). Non ho copiato niente.') -ForegroundColor Red; return }
if(-not (Test-Path -LiteralPath 'C:\MT5_BCM_Opt\terminal64.exe')){ Write-Host 'MI FERMO: non trovo C:\MT5_BCM_Opt\terminal64.exe. Non ho copiato niente.' -ForegroundColor Red; return }
if(Test-Path -LiteralPath $DST){ Write-Host ('MI FERMO: ' + $DST + ' ESISTE gia. Non la tocco. Non ho copiato niente.') -ForegroundColor Red; return }
$nsrc=@(Get-ChildItem -LiteralPath $SRC -Recurse -File -Filter '*.set' -ErrorAction SilentlyContinue).Count
if($nsrc -lt 100){ Write-Host ('MI FERMO: nel pacchetto ho trovato solo ' + $nsrc + ' file .set (ne attendo circa 382). Non ho copiato niente.') -ForegroundColor Red; return }
Write-Host ('Copio ' + $nsrc + ' set da ' + $SRC + ' in ' + $DST + ' ...') -ForegroundColor Cyan
New-Item -ItemType Directory -Force -Path (Split-Path -Parent $DST) | Out-Null
Copy-Item -LiteralPath $SRC -Destination $DST -Recurse -Force -ErrorAction Stop
$ndst=@(Get-ChildItem -LiteralPath $DST -Recurse -File -Filter '*.set' -ErrorAction SilentlyContinue).Count
if($ndst -ne $nsrc){ Write-Host ('ERRORE: copiati ' + $ndst + ' set invece di ' + $nsrc + '.') -ForegroundColor Red; return }
Write-Host ('Fatto: ' + $ndst + ' set copiati in ' + $DST) -ForegroundColor Green
$opt=@(Get-ChildItem -LiteralPath $DST -Recurse -File -Filter '*.set' -ErrorAction SilentlyContinue | Where-Object { $_.Name -match '(?i)optimi[sz]ation' })
Write-Host ('Set di ottimizzazione trovati: ' + $opt.Count) -ForegroundColor Green
$opt | ForEach-Object { Write-Host ('   ' + $_.FullName.Replace($DST,'<UBS_V9_0>')) }
Write-Host 'Non ho aperto nessun MT5. In MT5 i set si caricano da Strategy Tester > Inputs > tasto destro > Load, cartella MQL5\Profiles\Tester\UBS_V9_0.' -ForegroundColor Yellow
