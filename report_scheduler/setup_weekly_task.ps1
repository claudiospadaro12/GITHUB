# setup_weekly_task.ps1
# Registra l'operazione pianificata del REPORT SETTIMANALE: ogni SABATO alle 09:00.
# ESEGUIRE UNA VOLTA come Amministratore, dalla cartella report_scheduler.
#
# NB ORARIO: usa l'ora locale del VPS. Se il VPS non e' sull'ora italiana,
# cambia -At 9:00AM di conseguenza (vedi README).

$ErrorActionPreference = "Stop"

$scriptPath = Join-Path $PSScriptRoot "trigger_weekly.ps1"
if (-not (Test-Path $scriptPath)) {
    Write-Error "Non trovo trigger_weekly.ps1 accanto a questo file."
    exit 1
}

$action = New-ScheduledTaskAction -Execute "powershell.exe" `
    -Argument "-NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File `"$scriptPath`""

# Sabato alle 09:00 (ora locale del VPS).
$trigger = New-ScheduledTaskTrigger -Weekly -DaysOfWeek Saturday -At 9:00AM

$settings = New-ScheduledTaskSettingsSet -StartWhenAvailable `
    -DontStopOnIdleEnd -ExecutionTimeLimit (New-TimeSpan -Minutes 10)

Register-ScheduledTask -TaskName "ReportSettimanaleTrading" `
    -Action $action -Trigger $trigger -Settings $settings `
    -Description "Fa partire il Report Settimanale di trading via GitHub, sabato alle 09:00." `
    -Force

Write-Host ""
Write-Host "[OK] Operazione 'ReportSettimanaleTrading' creata: sabato alle 09:00 (ora VPS)."
Write-Host "Prova subito con:  Start-ScheduledTask -TaskName 'ReportSettimanaleTrading'"
