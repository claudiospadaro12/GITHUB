# =====================================================================
#  pubblica_larry.ps1 -- cerca l'indicatore del corso "A Cena Con
#  Larry" nel VECCHIO MT5 del VPS (MQL5\Indicators) e pubblica sul
#  repo (mql5/Indicators/esterni/) TUTTI i file trovati: se c'e' il
#  .mq5 (sorgente) e' un jackpot, l'.ex5 va bene comunque per gli
#  input. Da lanciare SUL VPS. MT5 puo' restare aperto.
# =====================================================================
param(
    [string]$Owner    = "claudiospadaro12",
    [string]$Repo     = "github",
    [string]$Branch   = "lavoro",
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

# --- vecchio MT5 ---
$root = Join-Path $env:APPDATA "MetaQuotes\Terminal"
$folders = Get-ChildItem $root -Directory -ErrorAction SilentlyContinue | Where-Object {
  Test-Path (Join-Path $_.FullName "origin.txt") }
$old = $folders | Where-Object {
  $o = (Get-Content (Join-Path $_.FullName "origin.txt") -Raw).Trim()
  $o -like "*BCM*MT5*" -and $o -notlike "*-V3*" -and $o -notlike "*MT4*" } |
  Sort-Object LastWriteTime -Descending | Select-Object -First 1
if (-not $old) { Write-Host "Vecchio MT5 non trovato." -ForegroundColor Red; exit 1 }

# --- cerca tutti i file "Larry" fra gli indicatori (mq5 + ex5) ---
$indDir = Join-Path $old.FullName "MQL5\Indicators"
$files = Get-ChildItem $indDir -Recurse -Include "*Larry*.mq5","*Larry*.ex5","*Cena*.mq5","*Cena*.ex5" -ErrorAction SilentlyContinue |
  Sort-Object FullName -Unique
if (-not $files -or $files.Count -eq 0) {
  Write-Host "Nessun file *Larry*/*Cena* in $indDir" -ForegroundColor Red
  Write-Host "Contenuto della cartella (primi 40):" -ForegroundColor Yellow
  Get-ChildItem $indDir -Recurse -Include "*.mq5","*.ex5" -ErrorAction SilentlyContinue |
    Select-Object -First 40 | ForEach-Object { Write-Host ("  " + $_.FullName.Substring($indDir.Length+1)) }
  exit 1
}

$headers = @{ Authorization = "token $tok"; "User-Agent" = "ABTG-Publisher"; Accept = "application/vnd.github+json" }
$apiBase = "https://api.github.com/repos/$Owner/$Repo"
foreach ($f in $files) {
  Write-Host ("Trovato: {0} ({1} byte, del {2})" -f $f.FullName, $f.Length, $f.LastWriteTime) -ForegroundColor Cyan
  $RepoPath = "mql5/Indicators/esterni/" + $f.Name
  $b64 = [Convert]::ToBase64String([IO.File]::ReadAllBytes($f.FullName))
  $sha = $null
  try {
    $cur = Invoke-RestMethod -Method Get -Uri "$apiBase/contents/$RepoPath`?ref=$Branch" -Headers $headers
    $sha = $cur.sha
  } catch { }
  $body = @{ message = "Indicatore del corso 'A Cena Con Larry' pubblicato dal VPS ($(Get-Date -Format 'yyyy-MM-dd HH:mm'))"
             content = $b64; branch = $Branch }
  if ($sha) { $body.sha = $sha }
  $null = Invoke-RestMethod -Method Put -Uri "$apiBase/contents/$RepoPath" -Headers $headers -Body ($body | ConvertTo-Json)
  Write-Host ("OK PUBBLICATO: {0}" -f $RepoPath) -ForegroundColor Green
}
Write-Host ""
Write-Host ("FINITO: {0} file pubblicati. Avvisa Claude in chat." -f $files.Count) -ForegroundColor White
