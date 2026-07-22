# trigger_report.ps1
# Fa partire il Report di Mercato su GitHub (workflow_dispatch), che parte
# SUBITO senza il ritardo dello scheduler di GitHub. Da eseguire dal Task
# Scheduler del VPS alle 07:00.
#
# Il token GitHub NON e' scritto qui: viene letto da un file locale
#   %USERPROFILE%\.gh_report_token.txt
# (cosi' non finisce mai su GitHub).

$ErrorActionPreference = "Stop"

# --- token ---
$tokenFile = Join-Path $env:USERPROFILE ".gh_report_token.txt"
if (-not (Test-Path $tokenFile)) {
    Write-Error "Token non trovato in $tokenFile . Crea il file e incolla dentro il tuo PAT GitHub."
    exit 1
}
$token = (Get-Content $tokenFile -Raw).Trim()

# --- parametri del repo ---
$owner    = "claudiospadaro12"
$repo     = "GITHUB"
$workflow = "daily-report.yml"
$ref      = "claude/creating-agents-SgGpD"

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
    Write-Host "[OK] Report avviato su GitHub (ref: $ref)."
} catch {
    Write-Error "[ERRORE] Chiamata a GitHub fallita: $($_.Exception.Message)"
    exit 1
}
