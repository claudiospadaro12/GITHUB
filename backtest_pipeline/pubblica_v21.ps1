# =====================================================================
#  pubblica_v21.ps1 -- carica l'ex5 del NasdaqOpeningBreakout v21 dal
#  VPS al repo (mql5/Experts/esterni/), via API GitHub col token.
#  Cosi' il PC di backtest lo scarica e l'imbuto puo' partire.
#  Da lanciare SUL VPS. MT5 puo' restare aperto.
# =====================================================================
param(
    [string]$Owner    = "claudiospadaro12",
    [string]$Repo     = "github",
    [string]$Branch   = "lavoro",
    [string]$RepoPath = "mql5/Experts/esterni/NasdaqOpeningBreakout_EA_v21_OPTIMIZED.ex5",
    [string]$TokenFile = ""
)
$ErrorActionPreference = "Stop"
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

# --- token (stessi posti di pubblica_trades) ---
$tokenCandidates = @($TokenFile,
                     "C:\Users\Administrator\.gh_report_token.txt",
                     (Join-Path $env:USERPROFILE ".gh_report_token.txt"))
$tok = $null
foreach ($p in $tokenCandidates) {
  if ($p -and (Test-Path $p)) { $tok = (Get-Content $p -Raw).Trim(); break }
}
if (-not $tok) { Write-Host "Token non trovato (.gh_report_token.txt)." -ForegroundColor Red; exit 1 }

# --- trova l'ex5 nel VECCHIO MT5 ---
$root = Join-Path $env:APPDATA "MetaQuotes\Terminal"
$folders = Get-ChildItem $root -Directory -ErrorAction SilentlyContinue | Where-Object {
  Test-Path (Join-Path $_.FullName "origin.txt") }
$old = $folders | Where-Object {
  $o = (Get-Content (Join-Path $_.FullName "origin.txt") -Raw).Trim()
  $o -like "*BCM*MT5*" -and $o -notlike "*-V3*" -and $o -notlike "*MT4*" } |
  Sort-Object LastWriteTime -Descending | Select-Object -First 1
if (-not $old) { Write-Host "Vecchio MT5 non trovato." -ForegroundColor Red; exit 1 }

$exDir = Join-Path $old.FullName "MQL5\Experts"
$ex5 = Get-ChildItem $exDir -Recurse -Filter "NasdaqOpeningBreakout*.ex5" -ErrorAction SilentlyContinue |
  Sort-Object LastWriteTime -Descending | Select-Object -First 1
if (-not $ex5) {
  Write-Host "Nessun NasdaqOpeningBreakout*.ex5 in $exDir : mandami uno screenshot del Navigatore." -ForegroundColor Red
  exit 1
}
Write-Host ("Trovato: {0} ({1} byte, del {2})" -f $ex5.FullName, $ex5.Length, $ex5.LastWriteTime) -ForegroundColor Cyan

# --- upload via API contents ---
$headers = @{ Authorization = "token $tok"; "User-Agent" = "ABTG-Publisher"; Accept = "application/vnd.github+json" }
$apiBase = "https://api.github.com/repos/$Owner/$Repo"
$b64 = [Convert]::ToBase64String([IO.File]::ReadAllBytes($ex5.FullName))

$sha = $null
try {
  $cur = Invoke-RestMethod -Method Get -Uri "$apiBase/contents/$RepoPath`?ref=$Branch" -Headers $headers
  $sha = $cur.sha
  Write-Host "File gia' presente sul repo, aggiorno." -ForegroundColor DarkGray
} catch {
  if ($_.Exception.Response.StatusCode.value__ -eq 404) { Write-Host "Nuovo file sul repo, lo creo." -ForegroundColor DarkGray }
}
$body = @{ message = "EA esterno v21 dell'amico: ex5 pubblicato dal VPS per l'imbuto ($(Get-Date -Format 'yyyy-MM-dd HH:mm'))"
           content = $b64; branch = $Branch }
if ($sha) { $body.sha = $sha }
Invoke-RestMethod -Method Put -Uri "$apiBase/contents/$RepoPath" -Headers $headers `
  -Body ($body | ConvertTo-Json) -ContentType "application/json" | Out-Null
Write-Host ("OK PUBBLICATO: {0} sul branch {1}" -f $RepoPath, $Branch) -ForegroundColor Green
