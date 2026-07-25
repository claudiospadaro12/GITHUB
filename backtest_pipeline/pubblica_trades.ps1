# =====================================================================
#  pubblica_trades.ps1  --  pubblica il CSV dei trade sul repo (senza git)
# ---------------------------------------------------------------------
#  Prende il file ABTG_Trades.csv che l'EA ABTG_TradeExporter scrive in
#  Common\Files e lo carica nel repo (data/statements/trades_auto.csv) via
#  API GitHub, usando il tuo token. Il report del sabato lo leggera' da li'.
#
#  Da lanciare sul VPS (dove gira l'EA e c'e' il token). Puoi metterlo in
#  Task Scheduler il sabato ~08:50, PRIMA del trigger del report.
#
#  USO:
#    powershell -ExecutionPolicy Bypass -File pubblica_trades.ps1
#    powershell -ExecutionPolicy Bypass -File pubblica_trades.ps1 -TriggerReport
#
#  Il token si legge (in ordine) da: -TokenFile, C:\Users\Administrator\
#  .gh_report_token.txt, %USERPROFILE%\.gh_report_token.txt.
# =====================================================================
param(
    [string]$Owner      = "claudiospadaro12",
    [string]$Repo       = "github",
    [string]$Branch     = "claude/creating-agents-SgGpD",
    [string]$RepoPath   = "data/statements/trades_auto.csv",
    [string]$CsvName    = "ABTG_Trades.csv",
    [string]$TokenFile  = "",
    [switch]$TriggerReport
)

$ErrorActionPreference = "Stop"
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

Write-Host "=== PUBBLICA TRADE CSV -> $Owner/$Repo ($Branch) ===" -ForegroundColor Cyan

# --- token ---
$tokenCandidates = @($TokenFile,
                     "C:\Users\Administrator\.gh_report_token.txt",
                     (Join-Path $env:USERPROFILE ".gh_report_token.txt"))
$tok = $null
foreach ($p in $tokenCandidates) {
    if ($p -and (Test-Path $p)) { $tok = (Get-Content $p -Raw).Trim(); break }
}
if (-not $tok) { Write-Host "Token non trovato. Passa -TokenFile col percorso del .gh_report_token.txt" -ForegroundColor Red; exit 1 }

# --- CSV sorgente (Common\Files) ---
$common = Join-Path $env:APPDATA "MetaQuotes\Terminal\Common\Files"
$csv = Join-Path $common $CsvName
if (-not (Test-Path $csv)) {
    Write-Host "CSV non trovato: $csv" -ForegroundColor Red
    Write-Host "Assicurati che l'EA ABTG_TradeExporter sia attaccato a un grafico sul VPS." -ForegroundColor Yellow
    exit 1
}
$bytes = [IO.File]::ReadAllBytes($csv)
$b64   = [Convert]::ToBase64String($bytes)
$righe = (Get-Content $csv | Measure-Object -Line).Lines
Write-Host ("CSV: {0}  ({1} righe, {2} byte)" -f $csv, $righe, $bytes.Length)

$headers = @{ Authorization = "token $tok"; "User-Agent" = "ABTG-Publisher"; Accept = "application/vnd.github+json" }
$apiBase = "https://api.github.com/repos/$Owner/$Repo"

# --- SHA attuale del file (se esiste gia') ---
$sha = $null
try {
    $cur = Invoke-RestMethod -Method Get -Uri "$apiBase/contents/$RepoPath`?ref=$Branch" -Headers $headers
    $sha = $cur.sha
    Write-Host "File gia' presente, aggiorno (sha $($sha.Substring(0,7)))." -ForegroundColor DarkGray
} catch {
    if ($_.Exception.Response.StatusCode.value__ -eq 404) { Write-Host "Nuovo file, lo creo." -ForegroundColor DarkGray }
    else { Write-Host "Attenzione controllo SHA: $($_.Exception.Message)" -ForegroundColor Yellow }
}

# --- PUT (crea/aggiorna) ---
$body = @{ message = "Aggiornamento automatico trades ($(Get-Date -Format 'yyyy-MM-dd HH:mm'))"
           content = $b64; branch = $Branch }
if ($sha) { $body.sha = $sha }
try {
    Invoke-RestMethod -Method Put -Uri "$apiBase/contents/$RepoPath" -Headers $headers `
        -Body ($body | ConvertTo-Json) -ContentType "application/json" | Out-Null
    Write-Host "OK pubblicato: $RepoPath" -ForegroundColor Green
} catch {
    $code = $null
    try { $code = $_.Exception.Response.StatusCode.value__ } catch {}
    Write-Host "PUBBLICAZIONE FALLITA: $($_.Exception.Message)" -ForegroundColor Red
    if ($code -eq 403 -or $code -eq 404) {
        Write-Host ""
        Write-Host ">> Il token NON ha il permesso di SCRIVERE file nel repo." -ForegroundColor Yellow
        Write-Host "   Serve un Personal Access Token (classic) con scope 'repo'," -ForegroundColor Yellow
        Write-Host "   oppure fine-grained con 'Contents: Read and write' su $Owner/$Repo." -ForegroundColor Yellow
        Write-Host "   Rigeneralo su GitHub, salvalo nel file .gh_report_token.txt e rilancia." -ForegroundColor Yellow
    }
    exit 1
}

# --- opzionale: lancia subito il report settimanale ---
if ($TriggerReport) {
    try {
        $b = @{ ref = $Branch } | ConvertTo-Json
        Invoke-RestMethod -Method Post -Uri "$apiBase/actions/workflows/weekly-report.yml/dispatches" `
            -Headers $headers -Body $b -ContentType "application/json" | Out-Null
        Write-Host "Report settimanale avviato (workflow_dispatch su $Branch)." -ForegroundColor Green
    } catch {
        Write-Host "Trigger report fallito: $($_.Exception.Message)" -ForegroundColor Yellow
    }
}
Write-Host "=== FINITO ===" -ForegroundColor Cyan
