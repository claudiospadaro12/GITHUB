# =====================================================================
#  setup_news_task.ps1  --  schedula l'aggiornamento news sul VPS
# ---------------------------------------------------------------------
#  Registra un'attivita' di Windows che ogni mattina (07:20) scarica
#  abtg_news.csv dentro MT5, cosi' il PostNews ha sempre le news fresche.
#  Lancialo UNA volta sul VPS (dove gira il PostNews live).
# =====================================================================
$here   = Split-Path -Parent $MyInvocation.MyCommand.Path
$script = Join-Path $here "aggiorna_news.ps1"
if (-not (Test-Path $script)) { Write-Host "Non trovo aggiorna_news.ps1 accanto a questo file." -ForegroundColor Red; exit 1 }

$action  = New-ScheduledTaskAction -Execute "powershell.exe" `
             -Argument "-NoProfile -ExecutionPolicy Bypass -File `"$script`""
# ogni giorno alle 07:20 (dopo che il report ha generato il file alle 07:00)
$trigger = New-ScheduledTaskTrigger -Daily -At 7:20am
$set     = New-ScheduledTaskSettingsSet -StartWhenAvailable -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries

Register-ScheduledTask -TaskName "ABTG_AggiornaNews" -Action $action -Trigger $trigger `
    -Settings $set -Description "Scarica abtg_news.csv in MT5 ogni mattina (filtro news EA)" -Force

Write-Host "OK: attivita' 'ABTG_AggiornaNews' registrata (ogni giorno 07:20)." -ForegroundColor Green
Write-Host "Verifica in Utilita' di pianificazione. Per lanciarla ora a mano:" -ForegroundColor White
Write-Host "   Start-ScheduledTask -TaskName ABTG_AggiornaNews" -ForegroundColor White
