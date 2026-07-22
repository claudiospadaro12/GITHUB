# setup_task.ps1
# Registra l'operazione pianificata di Windows che fa partire il report
# ogni giorno FERIALE alle 07:00.
#
# ESEGUIRE UNA VOLTA SOLA, come Amministratore, dalla cartella report_scheduler.
#
# NB ORARIO: il Task Scheduler usa l'ora LOCALE del VPS. Se il VPS non e'
# sull'ora italiana, cambia il valore -At piu' sotto in modo che corrisponda
# alle 07:00 di Roma (vedi README).

$ErrorActionPreference = "Stop"

$scriptPath = Join-Path $PSScriptRoot "trigger_report.ps1"
if (-not (Test-Path $scriptPath)) {
    Write-Error "Non trovo trigger_report.ps1 accanto a questo file."
    exit 1
}

$action = New-ScheduledTaskAction -Execute "powershell.exe" `
    -Argument "-NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File `"$scriptPath`""

# Feriali (lun-ven) alle 07:00 ora locale del VPS.
$trigger = New-ScheduledTaskTrigger -Weekly `
    -DaysOfWeek Monday,Tuesday,Wednesday,Thursday,Friday -At 7:00AM

# Se il VPS era spento/in sospensione, parte appena possibile.
$settings = New-ScheduledTaskSettingsSet -StartWhenAvailable `
    -DontStopOnIdleEnd -ExecutionTimeLimit (New-TimeSpan -Minutes 10)

Register-ScheduledTask -TaskName "ReportMercatoGiornaliero" `
    -Action $action -Trigger $trigger -Settings $settings `
    -Description "Fa partire il Report di Mercato via GitHub, feriali alle 07:00." `
    -Force

Write-Host ""
Write-Host "[OK] Operazione 'ReportMercatoGiornaliero' creata: feriali alle 07:00 (ora VPS)."
Write-Host "Puoi provarla subito con:  Start-ScheduledTask -TaskName 'ReportMercatoGiornaliero'"
