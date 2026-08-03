# =====================================================================
#  scarica_ottimizzati.ps1  --  scarica e compila gli EA _Ottimizzato
#                               nella cartella MQL5\Experts di BCM
# ---------------------------------------------------------------------
#  Mette gli EA _Ottimizzato accanto agli originali (magic diversi:
#  girano in PARALLELO senza pestarsi). Poi li trovi in MetaTrader tra
#  gli Expert Advisors, pronti da trascinare sul grafico.
#
#  Lancialo con la riga in chat, oppure:
#      powershell -ExecutionPolicy Bypass -File scarica_ottimizzati.ps1
# =====================================================================
param(
    [switch]$UseSpare,
    [string]$Terminal   = "",
    [string]$MetaEditor = "",
    [string]$DataFolder = ""
)
$ErrorActionPreference = "Stop"
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$Branch  = "claude/creating-agents-SgGpD"
$RawBase = "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$Branch/mql5/Experts"

# EA _Ottimizzato VALIDATI pronti per il forward.
# Lista COMPLETA: tutti gli EA in forward (ottimizzati + nativi). Scaricare/compilare
# un EA non attaccato a un grafico e' innocuo. Serve per applicare i COMMENTI nuovi
# (InpComment): essendo un input nuovo, alla ricompilazione MT5 usa il default nuovo.
# NB: i MAGIC cambiati (DAX_M3 770502, Apertura_Marco 770311) NON si applicano da soli
#     (input esistente) -> vanno ricaricati a mano su quei 2 grafici (quando flat).
$EAs = @(
    # --- OTTIMIZZATI (portafoglio forward) ---
    "ABTG_DAX_Apertura_EU_Ottimizzato",
    "ABTG_Nasdaq_Apertura_US_Ottimizzato",
    "ABTG_SupertrendReversal_Multi_Ottimizzato",
    "ABTG_SupertrendReversal_Ottimizzato",
    "ABTG_EMA200_Ottimizzato",
    "ABTG_GoldenCross_Ottimizzato",
    "ABTG_SupRev_DAX_H1_Ottimizzato",
    "ABTG_SupRev_DAX_H4_Ottimizzato",
    "ABTG_SupRev_NAS_H1_Ottimizzato",
    "ABTG_SupRev_DOW_H4_Ottimizzato",
    "ABTG_SupRev_CAC_H4_Ottimizzato",
    "ABTG_SupRev_DOW_H1_Ottimizzato",
    "ABTG_MaxMinNotte_DAX_Short_Ottimizzato",
    "ABTG_SuperWave_DOW_H1_Ottimizzato",
    "ABTG_SuperWave_DAX_H4_Ottimizzato",
    "ABTG_Nightly_Ottimizzato",
    # --- NATIVI ---
    "ABTG_GoldenCross",
    "ABTG_SupertrendReversal",
    "ABTG_SupertrendReversal_Multi",
    "ABTG_EMA200",
    "ABTG_MaxMinNotte",
    "ABTG_Nightly",
    "ABTG_SuperWave",
    "ABTG_SuperWave_EA",
    "ABTG_SupertrendInvert",
    "ABTG_DAX_Apertura_EU",
    "ABTG_DAX_Live5m",
    "ABTG_DAX_Live5m_v2",
    "ABTG_DAX_M3",
    "ABTG_Nasdaq_Apertura_US",
    "ABTG_Nasdaq_Live5m",
    "ABTG_ORB",
    "ABTG_ORB_Fibo",
    "ABTG_Londra_ORB",
    "ABTG_Apertura_Marco",
    "ABTG_PTE",
    "ABTG_PostNews",
    "ABTG_WOL",
    "ABTG_HARSI",
    "ABTG_FiboH4_Multi",
    "IchiTrend_Gold_Base",
    # NON e' un EA che opera: e' quello che esporta i trade per la pagella
    # serale. Mancava dalla lista, percio' il 03/08 il CSV usciva ancora con
    # le colonne vecchie (senza close_reason / session_high / session_low)
    # anche dopo aver ricompilato "tutto".
    "ABTG_TradeExporter"
)

Write-Host "=== AGGIORNO TUTTI GLI EA (ottimizzati + nativi) ===" -ForegroundColor Cyan

# --- trova terminale + cartella dati --------------------------------
if (-not $Terminal) {
    $allTerm = Get-ChildItem "C:\Program Files","C:\Program Files (x86)" -Recurse -Filter "terminal64.exe" -ErrorAction SilentlyContinue
    if ($UseSpare) { $cand = $allTerm | Where-Object { $_.DirectoryName -like "*BCM Markets*" -and $_.DirectoryName -like "*-V3*" } | Select-Object -First 1 }
    else           { $cand = $allTerm | Where-Object { $_.DirectoryName -like "*BCM Markets MT5 Terminal*" -and $_.DirectoryName -notlike "*-V3*" } | Select-Object -First 1 }
    if (-not $cand) { $cand = $allTerm | Where-Object { $_.DirectoryName -like "*BCM Markets*" } | Select-Object -First 1 }
    if ($cand) { $Terminal = $cand.FullName; $MetaEditor = Join-Path $cand.DirectoryName "metaeditor64.exe" }
}
if ($Terminal -and -not $DataFolder) {
    $instDir = Split-Path -Parent $Terminal
    $termRoot = Join-Path $env:APPDATA "MetaQuotes\Terminal"
    if (Test-Path $termRoot) {
        $DataFolder = Get-ChildItem $termRoot -Directory -ErrorAction SilentlyContinue | Where-Object {
            $o = Join-Path $_.FullName "origin.txt"; (Test-Path $o) -and ((Get-Content $o -Raw).Trim() -ieq $instDir)
        } | Select-Object -First 1 -ExpandProperty FullName
    }
}
if (-not $DataFolder -or -not (Test-Path $DataFolder)) { Write-Host "Cartella dati BCM non trovata. Passa -DataFolder <percorso>." -ForegroundColor Red; exit 1 }
$MqlExperts = Join-Path $DataFolder "MQL5\Experts"
New-Item -ItemType Directory -Force -Path $MqlExperts | Out-Null
Write-Host ("Experts: {0}" -f $MqlExperts)

foreach ($ea in $EAs) {
    $dst = Join-Path $MqlExperts "$ea.mq5"
    try { Invoke-WebRequest -Uri "$RawBase/$ea.mq5" -OutFile $dst -UseBasicParsing; Write-Host ("   scaricato {0}.mq5" -f $ea) -ForegroundColor Green }
    catch { Write-Host ("   ERRORE download {0}: {1}" -f $ea,$_.Exception.Message) -ForegroundColor Red; continue }
    if ($MetaEditor -and (Test-Path $MetaEditor)) {
        & $MetaEditor "/compile:$dst" "/log" | Out-Null
        if (Test-Path ([System.IO.Path]::ChangeExtension($dst, ".ex5"))) { Write-Host ("   compilato  {0}.ex5" -f $ea) -ForegroundColor Green }
        else { Write-Host ("   (compila a mano con F7: {0})" -f $ea) -ForegroundColor Yellow }
    }
}

# --- aggiorna il file news (date FOMC/ECB) in MQL5\Files -------------
# Il PostNews legge questo CSV a runtime: va tenuto allineato al repo.
$MqlFiles = Join-Path $DataFolder "MQL5\Files"
New-Item -ItemType Directory -Force -Path $MqlFiles | Out-Null
$newsDst = Join-Path $MqlFiles "abtg_news.csv"
$NewsUrl = "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$Branch/mql5/Files/abtg_news.csv"
try { Invoke-WebRequest -Uri $NewsUrl -OutFile $newsDst -UseBasicParsing; Write-Host "   aggiornato abtg_news.csv (date FOMC/ECB)" -ForegroundColor Green }
catch { Write-Host ("   ERRORE download abtg_news.csv: {0}" -f $_.Exception.Message) -ForegroundColor Red }

Write-Host "`n=== FATTO ===" -ForegroundColor Cyan
Write-Host "In MetaTrader: se non li vedi subito, tasto destro su 'Expert Advisors' > Aggiorna." -ForegroundColor White
Write-Host "Trascina ogni _Ottimizzato sul grafico giusto (D30EUR / NASUSD, M5), AutoTrading ON." -ForegroundColor White
