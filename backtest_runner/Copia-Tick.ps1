# Copia-Tick.ps1 - copia i file mensili dei tick reali di un simbolo da un terminale MT5 a un altro (solo lettura dalla sorgente).
# Serve al test a tick reali nel MT5 portable: i tick scaricati dal terminale principale non ci sono automaticamente.
# Uso: .\Copia-Tick.ps1 -Simbolo EURUSD -Da 202407 -A 202412 -Sorgente "C:\Users\Master\AppData\Roaming\MetaQuotes\Terminal\215D85D767A1C39E22D242C8114BF9F5" -Destinazione C:\MT5_BCM_Opt -Server BCMMarkets-Server
param([Parameter(Mandatory=$true)][string]$Simbolo,[Parameter(Mandatory=$true)][string]$Da,[Parameter(Mandatory=$true)][string]$A,[Parameter(Mandatory=$true)][string]$Sorgente,[Parameter(Mandatory=$true)][string]$Destinazione,[string]$Server='BCMMarkets-Server')
$ErrorActionPreference='Continue'
if(@(Get-Process -Name terminal64,metatester64,metaeditor64 -ErrorAction SilentlyContinue).Count -gt 0){ Write-Host 'Ci sono MT5 aperti: chiudili e rilancia.' -ForegroundColor Red; return }
$src = Join-Path $Sorgente ('bases\' + $Server + '\ticks\' + $Simbolo); $dst = Join-Path $Destinazione ('bases\' + $Server + '\ticks\' + $Simbolo)
if(-not (Test-Path -LiteralPath $src)){ Write-Host ('Non trovo i tick sorgente: ' + $src) -ForegroundColor Red; return }
New-Item -ItemType Directory -Force -Path $dst | Out-Null
$n = 0
foreach($f in (Get-ChildItem -LiteralPath $src -File -Filter '*.tkc' | Sort-Object Name)){
  if($f.BaseName -ge $Da -and $f.BaseName -le $A){ Copy-Item -LiteralPath $f.FullName -Destination $dst -Force; $n = $n + 1; Write-Host ('   copiato ' + $f.Name) -ForegroundColor Green }
}
Write-Host ('File copiati: ' + $n + ' in ' + $dst) -ForegroundColor Cyan
