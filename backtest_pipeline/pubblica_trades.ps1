# =====================================================================
#  pubblica_trades.ps1  --  pubblica il CSV dei trade sul repo (senza git)
# ---------------------------------------------------------------------
#  Prende il file ABTG_Trades.csv che l'EA ABTG_TradeExporter scrive in
#  Common\Files e lo carica nel repo (data/statements/trades_auto.csv) via
#  API GitHub, usando il tuo token. Il report del sabato lo leggera' da li'.
#
#  Da lanciare sul VPS (dove gira l'EA e c'e' il token).
#
#  USO:
#    # una tantum, per provare:
#    powershell -ExecutionPolicy Bypass -File pubblica_trades.ps1
#    # per metterlo in automatico tutte le sere (una volta sola):
#    powershell -ExecutionPolicy Bypass -File pubblica_trades.ps1 -Installa
#
#  Con -Installa lo script si copia in C:\ABTG e registra un'attivita'
#  pianificata che lo rilancia da solo alle 22:45, lun-ven: cosi' il CSV
#  e' gia' sul repo quando alle 23:00 parte la pagella in chat.
#
#  Il token si legge (in ordine) da: -TokenFile, C:\Users\Administrator\
#  .gh_report_token.txt, %USERPROFILE%\.gh_report_token.txt.
# =====================================================================
param(
    [string]$Owner      = "claudiospadaro12",
    [string]$Repo       = "github",
    [string]$Branch     = "lavoro",
    [string]$RepoPath   = "data/statements/trades_auto.csv",
    [string]$CsvName    = "ABTG_Trades.csv",
    # --- pagella DOPPIA (11/08): anche il CSV del conto 100k (dry-run FTMO).
    #     Lo scrive il TradeExporter del -V3 nella STESSA Common condivisa.
    [string]$RepoPath100k = "data/statements/trades_100k.csv",
    [string]$CsvName100k  = "ABTG_Trades_100k.csv",
    [string]$TokenFile  = "",
    [switch]$TriggerReport,
    [switch]$Installa,                 # registra l'attivita' pianificata e esce
    [string]$Ora        = "22:45",     # ora VPS: PRIMA delle 23:00 della pagella
    [string]$DestDir    = "C:\ABTG"
)

$ErrorActionPreference = "Stop"
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

# =====================================================================
#  -Installa : mette lo script in automatico e finisce qui.
# =====================================================================
if ($Installa) {
    Write-Host "=== INSTALLO LA PUBBLICAZIONE AUTOMATICA DEI TRADE ===" -ForegroundColor Cyan
    New-Item -ItemType Directory -Force -Path $DestDir | Out-Null
    $dest = Join-Path $DestDir "pubblica_trades.ps1"

    # se lo script gira da file lo copio, se gira da 'irm | iex' lo riscarico
    if ($PSCommandPath -and (Test-Path $PSCommandPath)) {
        Copy-Item $PSCommandPath -Destination $dest -Force
        Write-Host "   copiato in $dest" -ForegroundColor Green
    } else {
        $url = "https://raw.githubusercontent.com/$Owner/GITHUB/lavoro/backtest_pipeline/pubblica_trades.ps1"
        Invoke-WebRequest -Uri $url -OutFile $dest -UseBasicParsing
        Write-Host "   scaricato in $dest" -ForegroundColor Green
    }

    # NB: $args e' una variabile automatica di PowerShell, non usarla.
    # NB: niente virgolette dentro /TR (schtasks le maltratta): $DestDir
    #     non deve contenere spazi, per questo il default e' C:\ABTG.
    $task = "ABTG_PubblicaTrades"
    $azione = "powershell.exe -NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File $dest -Branch $Branch"
    if ($dest -match '\s') {
        Write-Host "   ERRORE: il percorso '$dest' contiene spazi. Usa -DestDir C:\ABTG" -ForegroundColor Red; exit 1
    }
    # schtasks scrive su stderr anche quando va tutto bene (es. /Delete di
    # un'attivita' che non esiste ancora: e' NORMALE la prima volta). Con
    # $ErrorActionPreference='Stop' PowerShell lo scambia per errore fatale
    # e si ferma: qui lo sospendo e guardo solo il codice di uscita.
    $eaOld = $ErrorActionPreference; $ErrorActionPreference = "SilentlyContinue"
    cmd /c "schtasks /Delete /TN $task /F"  2>&1 | Out-Null
    $creaOut = cmd /c "schtasks /Create /TN $task /TR ""$azione"" /SC WEEKLY /D MON,TUE,WED,THU,FRI /ST $Ora /F" 2>&1
    $creaRc  = $LASTEXITCODE
    $ErrorActionPreference = $eaOld
    if ($creaRc -ne 0) {
        Write-Host "   ERRORE nella creazione dell'attivita' (codice $creaRc):" -ForegroundColor Red
        $creaOut | ForEach-Object { Write-Host "     $_" -ForegroundColor Red }
        Write-Host "   Se dice 'accesso negato', riapri PowerShell come amministratore." -ForegroundColor Yellow
        exit 1
    }

    Write-Host "   attivita' '$task' creata: lun-ven alle $Ora (ora del VPS)" -ForegroundColor Green
    Write-Host ""
    Write-Host "   --- prova di pubblicazione IMMEDIATA (cosi' vedi subito se il token va) ---" -ForegroundColor Cyan
    # la lancio in linea, non via schtasks: se qualcosa non va voglio vedere il messaggio
    & $dest -Owner $Owner -Repo $Repo -Branch $Branch -RepoPath $RepoPath -CsvName $CsvName -TokenFile $TokenFile
    Write-Host ""
    Write-Host ">> Fatto. Controlla che MetaTrader resti APERTO sul VPS: se e' chiuso" -ForegroundColor Yellow
    Write-Host "   l'EA non aggiorna il CSV e la pagella trova dati vecchi." -ForegroundColor Yellow
    exit 0
}

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

# --- pubblicazione di UN file (usata due volte: piccolo + 100k) ---
$common  = Join-Path $env:APPDATA "MetaQuotes\Terminal\Common\Files"
$headers = @{ Authorization = "token $tok"; "User-Agent" = "ABTG-Publisher"; Accept = "application/vnd.github+json" }
$apiBase = "https://api.github.com/repos/$Owner/$Repo"

function Pubblica-Csv([string]$nomeCsv, [string]$repoPath, [bool]$obbligatorio) {
    $csv = Join-Path $common $nomeCsv
    if (-not (Test-Path $csv)) {
        if ($obbligatorio) {
            Write-Host "CSV non trovato: $csv" -ForegroundColor Red
            Write-Host "Assicurati che l'EA ABTG_TradeExporter sia attaccato a un grafico sul VPS." -ForegroundColor Yellow
            exit 1
        }
        Write-Host "CSV facoltativo non trovato (salto): $csv" -ForegroundColor Yellow
        Write-Host "  (e' quello del 100k: compare col primo export del TradeExporter sul -V3)" -ForegroundColor DarkGray
        return
    }
    $bytes = [IO.File]::ReadAllBytes($csv)
    $b64   = [Convert]::ToBase64String($bytes)
    $righe = (Get-Content $csv | Measure-Object -Line).Lines
    Write-Host ("CSV: {0}  ({1} righe, {2} byte)" -f $csv, $righe, $bytes.Length)

    $sha = $null
    try {
        $cur = Invoke-RestMethod -Method Get -Uri "$apiBase/contents/$repoPath`?ref=$Branch" -Headers $headers
        $sha = $cur.sha
        Write-Host "File gia' presente, aggiorno (sha $($sha.Substring(0,7)))." -ForegroundColor DarkGray
    } catch {
        if ($_.Exception.Response.StatusCode.value__ -eq 404) { Write-Host "Nuovo file, lo creo." -ForegroundColor DarkGray }
        else { Write-Host "Attenzione controllo SHA: $($_.Exception.Message)" -ForegroundColor Yellow }
    }

    $body = @{ message = "Aggiornamento automatico trades ($(Get-Date -Format 'yyyy-MM-dd HH:mm'))"
               content = $b64; branch = $Branch }
    if ($sha) { $body.sha = $sha }
    try {
        Invoke-RestMethod -Method Put -Uri "$apiBase/contents/$repoPath" -Headers $headers `
            -Body ($body | ConvertTo-Json) -ContentType "application/json" | Out-Null
        Write-Host "OK pubblicato: $repoPath" -ForegroundColor Green
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
        if ($obbligatorio) { exit 1 }
    }
}

Pubblica-Csv $CsvName     $RepoPath     $true    # conto piccolo (come sempre)
Pubblica-Csv $CsvName100k $RepoPath100k $false   # conto 100k (pagella doppia)

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
