# =====================================================================
#  pulizia_vps.ps1 -- spegne i morti del demo piccolo (10/08/2026)
#  Checklist: report/PULIZIA_VPS_10-08.md. Lavora sui file .chr del
#  profilo grafici, A MT5 (vecchio) CHIUSO. Il -V3/100k non si tocca
#  e puo' restare aperto.
#
#  COSA FA: sposta i grafici dei morti in una cartella di BACKUP sul
#  Desktop (nulla viene cancellato: si puo' tornare indietro copiando
#  i .chr al loro posto). Alla riapertura del vecchio MT5 i grafici
#  spenti non ci sono piu'.
#
#  PRIMA DI LANCIARE:
#   1. Chiudere A MANO le posizioni aperte dei morti (scheda Trade,
#      si riconoscono dal commento). Incluso il gruppo di controllo
#      oro del 04/08 (STREV/STREV MULTI su XAUUSD).
#   2. CHIUDERE il vecchio MT5 (50503392). Il -V3 puo' restare aperto.
# =====================================================================
$ErrorActionPreference = "Stop"

# --- il vecchio MT5 deve essere chiuso (il -V3 puo' girare) ----------
$vecchioAperto = Get-Process -Name "terminal64" -ErrorAction SilentlyContinue |
  Where-Object { $_.Path -like "*BCM Markets MT5 Terminal\*" -and $_.Path -notlike "*-V3*" }
if ($vecchioAperto) {
  Write-Host "!!! Il VECCHIO MT5 e' aperto. Chiudilo e rilancia (il -V3 puo' restare su)." -ForegroundColor Red
  exit 1
}

# --- cartella dati del vecchio (via origin.txt, come estrai_set) -----
$root = Join-Path $env:APPDATA "MetaQuotes\Terminal"
$folders = Get-ChildItem $root -Directory -ErrorAction SilentlyContinue | Where-Object {
  Test-Path (Join-Path $_.FullName "origin.txt") }
$old = $folders | Where-Object {
  $o = (Get-Content (Join-Path $_.FullName "origin.txt") -Raw).Trim()
  $o -like "*BCM*MT5*" -and $o -notlike "*-V3*" -and $o -notlike "*MT4*" } | Select-Object -First 1
if (-not $old) { Write-Host "Cartella dati del vecchio MT5 non trovata." -ForegroundColor Red; exit 1 }
Write-Host ("Istanza da pulire: " + (Get-Content (Join-Path $old.FullName "origin.txt") -Raw).Trim()) -ForegroundColor Gray

# --- regole -----------------------------------------------------------
# KILL incondizionati (nome .ex5 esatto)
$KillSempre = @(
  "ABTG_ORB", "ABTG_ORB_Fibo", "ABTG_Nightly", "ABTG_Nightly_Ottimizzato",
  "ABTG_GoldenCross", "ABTG_GoldenCross_Ottimizzato",
  "ABTG_PTE", "ABTG_WOL", "ABTG_SupertrendInvert",
  "ABTG_PostNews", "ABTG_SupertrendReversal_Multi", "ABTG_SupertrendReversal_Multi_Ottimizzato",
  "ABTG_HARSI", "ABTG_EMA200",
  "ABTG_DAX_Live5m", "ABTG_DAX_Live5m_v2", "ABTG_Nasdaq_Live5m",
  "DAX_M3_Supertrend", "ABTG_Apertura_Marco",
  "ABTG_SuperWave", "ABTG_SuperWave_EA", "ABTG_SuperWave_DAX_H4_Ottimizzato",
  "BULGE_MASTER", "IchiCross_Gold_722", "IchiTrend_Gold_Base",
  "Gold_Ichimoku_TK_ATR_EA", "Gold_Scalper_TK_BB_BE_EA",
  "ORB_DAX_BASE_EA", "ORB_DAX_PM_EA", "ORB_GOLD_FIBONACCI_EA",
  "ORB_GOLD_FIBONACCI_EA_v3.21", "ORB_OpeningRange", "ABTG_FiboH4_Multi"
)
# KILL con eccezione di simbolo: nome -> simbolo su cui SOPRAVVIVE
$KillTranne = @{
  "ABTG_SupertrendReversal" = "225JPY"   # il Nikkei resta, tutto il resto muore
  "ABTG_MaxMinNotte"        = "XAUUSD"   # il MAXMIN ORO resta, EURUSD muore
}
# WHITELIST (mai toccati, elencati per il report finale)
$Keep = @(
  "ABTG_DAX_Apertura_EU", "ABTG_Dow_Apertura_US",
  "ABTG_MaxMinNotte_DAX_Short_Ottimizzato", "ABTG_ORB_Ottimizzato",
  "ABTG_EMA200_Ottimizzato", "ABTG_SupRev_NAS_H1_Ottimizzato",
  "ABTG_SuperWave_DOW_H1_Ottimizzato", "ABTG_TradeExporter", "ABTG_Guardian"
)
# CAC: il nome esatto del file non e' certo -> match parziale dedicato
$KillPatternCAC = "*CAC*"

# --- backup -----------------------------------------------------------
$stamp = Get-Date -Format "yyyyMMdd_HHmm"
$Backup = Join-Path $env:USERPROFILE ("Desktop\backup_pulizia_" + $stamp)
New-Item -ItemType Directory -Force -Path $Backup | Out-Null
$ChartsRoot = Join-Path $old.FullName "MQL5\Profiles\Charts"
Copy-Item $ChartsRoot -Destination (Join-Path $Backup "Charts_COMPLETO") -Recurse -Force
Write-Host ("Backup completo dei grafici in: " + $Backup) -ForegroundColor Green

# --- scansione e spegnimento -----------------------------------------
$spenti=@(); $tenuti=@(); $ignoti=@()
$chrs = Get-ChildItem $ChartsRoot -Recurse -Filter "*.chr" -ErrorAction SilentlyContinue
foreach ($chr in $chrs) {
  $txt = Get-Content $chr.FullName -Raw
  $em = [regex]::Match($txt, "(?s)<expert>.*?path=Experts\\([^\r\n]+)\.ex5")
  if (-not $em.Success) { continue }                      # grafico senza EA: non si tocca
  $ea = $em.Groups[1].Value.Trim()
  $sm = [regex]::Match($txt, "symbol=([A-Za-z0-9#\.]+)")
  $sym = if ($sm.Success) { $sm.Groups[1].Value } else { "?" }

  $daSpegnere = $false
  if ($KillSempre -contains $ea) { $daSpegnere = $true }
  elseif ($KillTranne.ContainsKey($ea)) { if ($sym -ne $KillTranne[$ea]) { $daSpegnere = $true } }
  elseif ($ea -like $KillPatternCAC) { $daSpegnere = $true }

  if ($daSpegnere) {
    $dest = Join-Path $Backup "spenti"
    New-Item -ItemType Directory -Force -Path $dest | Out-Null
    Move-Item $chr.FullName (Join-Path $dest ($ea + "_" + $sym + "_" + $chr.Name)) -Force
    $spenti += ("{0}  @ {1}" -f $ea, $sym)
  }
  elseif ($Keep -contains $ea -or ($KillTranne.ContainsKey($ea) -and $sym -eq $KillTranne[$ea])) {
    $tenuti += ("{0}  @ {1}" -f $ea, $sym)
  }
  else { $ignoti += ("{0}  @ {1}  ({2})" -f $ea, $sym, $chr.Name) }
}

Write-Host ""; Write-Host ("SPENTI ({0}):" -f $spenti.Count) -ForegroundColor Yellow
$spenti | Sort-Object | ForEach-Object { Write-Host ("  - " + $_) -ForegroundColor Yellow }
Write-Host ""; Write-Host ("RESTANO ({0}):" -f $tenuti.Count) -ForegroundColor Green
$tenuti | Sort-Object | ForEach-Object { Write-Host ("  + " + $_) -ForegroundColor Green }
if ($ignoti.Count -gt 0) {
  Write-Host ""; Write-Host ("NON TOCCATI ma FUORI LISTA ({0}) - manda screenshot:" -f $ignoti.Count) -ForegroundColor Cyan
  $ignoti | Sort-Object | ForEach-Object { Write-Host ("  ? " + $_) -ForegroundColor Cyan }
}
Write-Host ""
Write-Host "Ora RIAPRI il vecchio MT5: i grafici spenti non ci saranno piu'." -ForegroundColor White
Write-Host "Controlla le faccine dei superstiti e manda lo screenshot della finestra Experts." -ForegroundColor White
Write-Host ("Per TORNARE INDIETRO: ricopiare i .chr da " + $Backup + "\spenti dentro") -ForegroundColor Gray
Write-Host ("  " + $ChartsRoot + "\<profilo> (a MT5 chiuso).") -ForegroundColor Gray
