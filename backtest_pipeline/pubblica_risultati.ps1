# =====================================================================
#  MARCATORE_PUBBLICA_RISULTATI_v1
#  pubblica_risultati.ps1 -- porta i CSV di un round SUL REPO, via API
#  GitHub, senza git e senza che Claudio debba mandare uno zip.
# ---------------------------------------------------------------------
#  PERCHE' ESISTE (09/09/2026, Claudio sta uscendo)
#  I risultati di un round finiscono sul Desktop del VPS. Claude NON puo'
#  vederli: il perimetro firmato il 07/09 gli da' SOLA LETTURA sul repo,
#  non l'accesso al VPS. Quindi finora ogni round finiva con "mandami lo
#  zip" -- e se Claudio e' al lavoro, il lavoro si ferma per otto ore.
#  Questo script chiude quel buco riusando il canale GIA' FIRMATO e GIA'
#  IN USO: la pubblicazione via API GitHub col token del VPS, identica a
#  pubblica_trades.ps1 (che pubblica i CSV dei trade dal 11/08).
#
#  COSA FA, e cosa NO
#   - LEGGE i .csv e i .txt piu' recenti di una cartella di risultati e li
#     mette nel repo sotto un percorso dichiarato. Nient'altro.
#   - NON apre MetaTrader, NON tocca posizioni, EA, preset o parametri,
#     NON legge il conto reale, NON cancella niente sul VPS.
#     E' una FOTOCOPIATRICE, e va letto come tale.
#
#  USO (dopo un round):
#    powershell -ExecutionPolicy Bypass -File pubblica_risultati.ps1 `
#      -Cartella "$env:USERPROFILE\abtg_gestione\risultati_gestione" `
#      -RepoDir  "backtest_pipeline/risultati_prove/gestione_20260909"
#
#  Il token si legge (in ordine) da: -TokenFile,
#  C:\Users\Administrator\.gh_report_token.txt, %USERPROFILE%\.gh_report_token.txt
#  -- gli stessi tre posti di pubblica_trades.ps1, nessun percorso nuovo.
#
#  NIENTE EMOJI: Windows PowerShell 5.1 legge i .ps1 come ANSI.
# =====================================================================
param(
    [Parameter(Mandatory=$true)][string]$Cartella,
    [Parameter(Mandatory=$true)][string]$RepoDir,
    [string]$Owner     = "claudiospadaro12",
    [string]$Repo      = "github",
    [string]$Branch    = "lavoro",
    [string]$TokenFile = "",
    [int]$MaxFile      = 40,
    [string]$Filtri    = "*.csv,*.txt"
)
$ErrorActionPreference = "Stop"
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

Write-Host ("=== PUBBLICA RISULTATI -> " + $Owner + "/" + $Repo + " (" + $Branch + ") ===") -ForegroundColor Cyan

if(-not (Test-Path -LiteralPath $Cartella -PathType Container)){
  Write-Host ("Cartella non trovata: " + $Cartella) -ForegroundColor Red
  Write-Host "Non e' un errore da nascondere: vuol dire che il round NON ha prodotto risultati." -ForegroundColor Yellow
  exit 2
}

# --- token: gli stessi tre posti di pubblica_trades.ps1 -------------
$cand = @($TokenFile, "C:\Users\Administrator\.gh_report_token.txt", (Join-Path $env:USERPROFILE ".gh_report_token.txt"))
$tok = $null
foreach($p in $cand){ if($p -and (Test-Path $p)){ $tok = (Get-Content $p -Raw).Trim(); break } }
if(-not $tok){ Write-Host "Token non trovato: passa -TokenFile col percorso del .gh_report_token.txt" -ForegroundColor Red; exit 1 }

$headers = @{ Authorization = "token $tok"; "User-Agent" = "ABTG-Publisher"; Accept = "application/vnd.github+json" }
$apiBase = "https://api.github.com/repos/$Owner/$Repo"

$pattern = $Filtri.Split(",") | ForEach-Object { $_.Trim() }
$file = @(Get-ChildItem -LiteralPath $Cartella -File -Recurse -ErrorAction SilentlyContinue |
          Where-Object { $n=$_.Name; ($pattern | Where-Object { $n -like $_ }).Count -gt 0 } |
          Sort-Object LastWriteTime -Descending | Select-Object -First $MaxFile)

if($file.Count -eq 0){
  Write-Host ("Nessun file da pubblicare in " + $Cartella) -ForegroundColor Yellow
  Write-Host "ZERO file NON vuol dire 'nessun edge': vuol dire NON E' GIRATA. Guardare il log." -ForegroundColor Yellow
  exit 2
}
Write-Host ("  file da pubblicare: " + $file.Count) -ForegroundColor Gray

$ok = 0; $ko = 0
foreach($f in $file){
  $b64  = [Convert]::ToBase64String([IO.File]::ReadAllBytes($f.FullName))
  $dest = ($RepoDir.TrimEnd('/')) + "/" + $f.Name
  $sha  = $null
  try{
    $cur = Invoke-RestMethod -Method Get -Uri ($apiBase + "/contents/" + $dest + "?ref=" + $Branch) -Headers $headers
    $sha = $cur.sha
  } catch { }
  $body = @{ message = ("risultati dal VPS: " + $f.Name + " (" + (Get-Date -Format 'yyyy-MM-dd HH:mm') + ")")
             content = $b64; branch = $Branch }
  if($sha){ $body.sha = $sha }
  try{
    Invoke-RestMethod -Method Put -Uri ($apiBase + "/contents/" + $dest) -Headers $headers `
      -Body ($body | ConvertTo-Json) -ContentType "application/json" | Out-Null
    Write-Host ("  OK  " + $dest + "   (" + $f.Length + " byte)") -ForegroundColor Green
    $ok++
  } catch {
    $code = $null; try{ $code = $_.Exception.Response.StatusCode.value__ }catch{}
    Write-Host ("  KO  " + $dest + "   " + $_.Exception.Message) -ForegroundColor Red
    if($code -eq 403 -or $code -eq 404){
      Write-Host "     >> il token non ha il permesso di SCRIVERE nel repo (serve scope 'repo' o Contents: Read and write)." -ForegroundColor Yellow
    }
    $ko++
  }
}
Write-Host ""
Write-Host ("PUBBLICATI: " + $ok + "   FALLITI: " + $ko) -ForegroundColor Cyan
Write-Host ("Percorso nel repo: " + $RepoDir) -ForegroundColor Gray
if($ko -gt 0){ exit 3 } else { exit 0 }
