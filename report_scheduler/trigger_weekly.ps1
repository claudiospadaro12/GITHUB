# trigger_weekly.ps1
# Fa partire il REPORT SETTIMANALE su GitHub (workflow_dispatch).
# Da eseguire dal Task Scheduler del VPS il sabato alle 09:00.
# Usa lo STESSO token del report giornaliero (%USERPROFILE%\.gh_report_token.txt).

$ErrorActionPreference = "Stop"

$tokenFile = Join-Path $env:USERPROFILE ".gh_report_token.txt"
if (-not (Test-Path $tokenFile)) {
    Write-Error "Token non trovato in $tokenFile ."
    exit 1
}
$token = (Get-Content $tokenFile -Raw).Trim()

$owner    = "claudiospadaro12"
$repo     = "GITHUB"
$workflow = "weekly-report.yml"
# ⚠️ IL BRANCH (corretto il 15/08/2026, dopo una pagella vuota)
#  Qui c'era "claude/creating-agents-SgGpD", il vecchio branch di default:
#  fermo al 31/07, con trades_auto.csv che si ferma al 24/07. La pagella
#  settimanale del 15/08 e' uscita con "Nessuno statement con trade nel
#  periodo" per QUESTO - non per un problema di export, di parser o di
#  MT5. Il lavoro sta tutto su `lavoro`.
$ref      = "lavoro"

$uri = "https://api.github.com/repos/$owner/$repo/actions/workflows/$workflow/dispatches"
$headers = @{
    "Authorization"        = "Bearer $token"
    "Accept"               = "application/vnd.github+json"
    "X-GitHub-Api-Version" = "2022-11-28"
    "User-Agent"           = "report-scheduler"
}
$body = @{ ref = $ref } | ConvertTo-Json

try {
    Invoke-RestMethod -Method Post -Uri $uri -Headers $headers -Body $body
    Write-Host "[OK] Report settimanale avviato su GitHub (ref: $ref)."
} catch {
    Write-Error "[ERRORE] Chiamata a GitHub fallita: $($_.Exception.Message)"
    exit 1
}
