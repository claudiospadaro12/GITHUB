# Compila_EA.ps1 - compila Template_EA_Wim.mq5 da riga di comando con MetaEditor (nessun compilatore a parte: e dentro MT5).
# Windows PowerShell 5.1. Copia il sorgente in MQL5\Experts\CLAU12\ del terminale e lancia metaeditor64.exe /compile.
# Lezione del 15/11: MetaEditor da solo non trova <Trade/Trade.mqh> -> si passa /include con la cartella MQL5 del terminale.
# Uso (portable BCM): .\Compila_EA.ps1 -Dati C:\MT5_BCM_Opt -Portable
param(
  [string]$Dati = 'C:\MT5_BCM_Opt',
  [switch]$Portable,
  [string]$Sorgente = ''
)
$aqui = Split-Path -Parent $MyInvocation.MyCommand.Path
if($Sorgente -eq ''){ $Sorgente = Join-Path $aqui 'Template_EA_Wim.mq5' }
if(-not (Test-Path -LiteralPath $Sorgente)){ Write-Host ('Non trovo il sorgente: ' + $Sorgente) -ForegroundColor Red; return }
if(@(Get-Process -Name terminal64,metaeditor64 -ErrorAction SilentlyContinue).Count -gt 0){ Write-Host 'MT5 o MetaEditor aperti: chiudili e rilancia.' -ForegroundColor Red; return }
$me = Join-Path $Dati 'metaeditor64.exe'
if(-not (Test-Path -LiteralPath $me)){ Write-Host ('Non trovo metaeditor64.exe in ' + $Dati + ' (per un terminale non portable indica la cartella di installazione in -Dati e la cartella dati e gia quella di AppData: vedi LEGGIMI).') -ForegroundColor Red; return }
$mql5 = Join-Path $Dati 'MQL5'
$dstDir = Join-Path $mql5 'Experts\CLAU12'
New-Item -ItemType Directory -Force -Path $dstDir | Out-Null
$dst = Join-Path $dstDir ([IO.Path]::GetFileName($Sorgente))
Copy-Item -LiteralPath $Sorgente -Destination $dst -Force
$log = Join-Path $env:TEMP 'compila_ea.log'
Remove-Item -LiteralPath $log -Force -ErrorAction SilentlyContinue
$arg = '/compile:"' + $dst + '" /include:"' + $mql5 + '" /log:"' + $log + '"'
if($Portable){ $arg = '/portable ' + $arg }
$pr = Start-Process -FilePath $me -ArgumentList $arg -PassThru -Wait
if(-not (Test-Path -LiteralPath $log)){ Write-Host 'Nessun log di compilazione: MetaEditor non ha scritto niente.' -ForegroundColor Red; return }
$b = [IO.File]::ReadAllBytes($log)
if($b.Length -ge 2 -and $b[0] -eq 255 -and $b[1] -eq 254){ $txt = [Text.Encoding]::Unicode.GetString($b) } else { $txt = [Text.Encoding]::UTF8.GetString($b) }
$txt -split "`r?`n" | Where-Object { $_.Trim() -ne '' } | ForEach-Object { Write-Host ('   ' + $_) }
$ex5 = [IO.Path]::ChangeExtension($dst,'.ex5')
if((Test-Path -LiteralPath $ex5) -and ($txt -match 'Result:\s*0 errors')){ Write-Host ('COMPILATO: ' + $ex5) -ForegroundColor Green }
else { Write-Host 'COMPILAZIONE NON RIUSCITA: copia qui in chat le righe con "error" (testo esatto).' -ForegroundColor Red; $txt | Set-Clipboard }
