# =====================================================================
#  funnel_bb.ps1 -- interroga il FUNNEL DI MORTALITA' della Breaking
#  Band: 1 test singolo (EURUSD H1, OHLC, default v1.01) e poi pesca
#  le righe [BB-FUNNEL] dal log del tester. PC di backtest, MT5 CHIUSO.
#  Uso: powershell -File funnel_bb.ps1 [-Simbolo EURUSD]
# =====================================================================
param([string]$Simbolo="EURUSD")
$ErrorActionPreference = "Stop"

if (Get-Process -Name "terminal64" -ErrorAction SilentlyContinue) {
  Write-Host "!!! Chiudi MetaTrader e rilancia." -ForegroundColor Red; exit 1
}
$allTerm = Get-ChildItem "C:\Program Files","C:\Program Files (x86)" -Recurse -Filter "terminal64.exe" -ErrorAction SilentlyContinue
$c = $allTerm | Where-Object { $_.DirectoryName -like "*BCM Markets MT5 Terminal*" -and $_.DirectoryName -notlike "*-V3*" } | Select-Object -First 1
if (-not $c) { $c = $allTerm | Where-Object { $_.DirectoryName -like "*BCM Markets*" } | Select-Object -First 1 }
if (-not $c) { Write-Host "terminal64.exe non trovato." -ForegroundColor Red; exit 1 }
$Terminal = $c.FullName; $instDir = $c.DirectoryName
$termRoot = Join-Path $env:APPDATA "MetaQuotes\Terminal"
$DataFolder = Get-ChildItem $termRoot -Directory -ErrorAction SilentlyContinue | Where-Object {
  $o = Join-Path $_.FullName "origin.txt"
  (Test-Path $o) -and ((Get-Content $o -Raw).Trim() -ieq $instDir) } | Select-Object -First 1 -ExpandProperty FullName
if (-not $DataFolder) { Write-Host "Cartella dati non trovata." -ForegroundColor Red; exit 1 }

$ex5 = Join-Path $DataFolder "MQL5\Experts\ABTG_BreakingBand.ex5"
if (-not (Test-Path $ex5)) { Write-Host "ABTG_BreakingBand.ex5 non trovato: lancia prima lo scan (compila lui)." -ForegroundColor Red; exit 1 }

$ini = Join-Path $env:TEMP "gen_funnel_bb.ini"
@"
[Experts]
AllowLiveTrading=false
AllowDllImport=false

[Tester]
Expert=ABTG_BreakingBand.ex5
Symbol=$Simbolo
Period=H1
Model=1
Optimization=0
FromDate=2024.09.26
ToDate=2026.06.30
ForwardMode=0
Deposit=10000
Currency=EUR
Leverage=100
ExecutionMode=0
Visual=0
ReplaceReport=1
ShutdownTerminal=1
Report=FUNNEL_BB_$Simbolo
"@ | Set-Content -Path $ini -Encoding ASCII

$prima = Get-Date
Write-Host ("--- test singolo {0} H1 (OHLC, default v1.01) per leggere il funnel ---" -f $Simbolo) -ForegroundColor Cyan
(Start-Process -FilePath $Terminal -ArgumentList "/config:`"$ini`"" -PassThru).WaitForExit()

# --- pesca le righe [BB-FUNNEL] dai log del tester ---
$righe = @()
$logs = Get-ChildItem (Join-Path $DataFolder "Tester") -Recurse -Filter "*.log" -ErrorAction SilentlyContinue |
  Where-Object { $_.LastWriteTime -ge $prima }
foreach ($lg in $logs) {
  $righe += Select-String -Path $lg.FullName -Pattern "BB-FUNNEL" -SimpleMatch -ErrorAction SilentlyContinue |
    ForEach-Object { $_.Line }
}
$out = Join-Path $env:USERPROFILE ("Desktop\funnel_bb_" + $Simbolo + ".txt")
if ($righe.Count -eq 0) {
  Write-Host "Nessuna riga [BB-FUNNEL] trovata nei log del tester: manda screenshot del Journal." -ForegroundColor Red
  "NESSUNA RIGA BB-FUNNEL TROVATA" | Set-Content $out -Encoding ASCII
} else {
  Write-Host ""
  Write-Host "=== FUNNEL DI MORTALITA' ($Simbolo H1, 2024.09-2026.06) ===" -ForegroundColor White
  $righe | ForEach-Object { Write-Host $_ }
  $righe | Set-Content -Path $out -Encoding ASCII
}
Write-Host ("Salvato in: " + $out) -ForegroundColor Green
