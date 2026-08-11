# =====================================================================
#  scarica_pagella.ps1 -- porta la pagella del giorno sul DESKTOP del VPS
#  Regola di Claudio (11/08): "il risultato deve sempre arrivare sul
#  Desktop del VPS".
#
#  Scarica dal repo (branch lavoro) il report della giornata e lo salva
#  in Desktop\pagella_AAAA-MM-GG.txt (testo semplice: doppio click e si
#  legge). Se il report di oggi non c'e' ancora, prende ieri.
#
#  USO:
#    una tantum:  powershell -ExecutionPolicy Bypass -File .\scarica_pagella.ps1
#    PER SEMPRE:  powershell -ExecutionPolicy Bypass -File .\scarica_pagella.ps1 -Installa
#  Con -Installa si copia in C:\ABTG e registra l'attivita' pianificata
#  ABTG_ScaricaPagella: tutte le sere alle 23:15 (dopo il trigger delle
#  23:00 che genera e pusha il report).
# =====================================================================
param(
    [switch]$Installa,
    [string]$Ora = "23:15",
    [string]$DestDir = "C:\ABTG",
    [string]$Branch = "lavoro"
)
$ErrorActionPreference = "Stop"
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

if ($Installa) {
    New-Item -ItemType Directory -Force -Path $DestDir | Out-Null
    $dest = Join-Path $DestDir "scarica_pagella.ps1"
    if ($PSCommandPath -and (Test-Path $PSCommandPath)) { Copy-Item $PSCommandPath -Destination $dest -Force }
    else {
        Invoke-WebRequest -Uri "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/lavoro/backtest_pipeline/scarica_pagella.ps1" -OutFile $dest -UseBasicParsing
    }
    $task = "ABTG_ScaricaPagella"
    $azione = "powershell.exe -NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File $dest -Branch $Branch"
    $eaOld = $ErrorActionPreference; $ErrorActionPreference = "SilentlyContinue"
    cmd /c "schtasks /Delete /TN $task /F" 2>&1 | Out-Null
    $out = cmd /c "schtasks /Create /TN $task /TR ""$azione"" /SC DAILY /ST $Ora /F" 2>&1
    $rc = $LASTEXITCODE
    $ErrorActionPreference = $eaOld
    if ($rc -ne 0) { Write-Host "ERRORE schtasks:"; $out | ForEach-Object { Write-Host "  $_" }; exit 1 }
    Write-Host "Attivita' '$task' creata: tutti i giorni alle $Ora." -ForegroundColor Green
    Write-Host "--- prova immediata ---" -ForegroundColor Cyan
    & $dest -Branch $Branch
    exit 0
}

$RawBase = "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$Branch"
$giorni = @((Get-Date), (Get-Date).AddDays(-1))
$fatto = $false
foreach ($g in $giorni) {
    $data = $g.ToString("yyyy-MM-dd")
    $url  = "$RawBase/report/giornata_$data.md"
    $out  = Join-Path $env:USERPROFILE ("Desktop\pagella_" + $data + ".txt")
    try {
        Invoke-WebRequest -Uri $url -OutFile $out -UseBasicParsing
        Write-Host ("Pagella sul Desktop: " + $out) -ForegroundColor Green
        $fatto = $true; break
    } catch { }
}
if (-not $fatto) { Write-Host "Nessuna pagella trovata sul repo (ne' oggi ne' ieri)." -ForegroundColor Yellow }
