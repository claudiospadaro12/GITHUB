# =====================================================================
#  deploy_pte_gbpusd_b25.ps1 -- STRADA A di R78, scelta da Claudio.
#
#  COSA FA: scrive DUE preset nel MT5 del conto piccolo.
#    1. VIVAIO_PTE_GBPUSD.set      -> la sedia VIVA 771322, rischio 1,0 -> 0,5
#    2. VIVAIO_PTE_GBPUSD_B25.set  -> la CANDIDATA 771332, buffer 25 / TP2 3,0
#
#  PERCHE': R78 (OHLC, IS 2000-2013 / OOS 2013-2026, n OOS 447-477) ha
#  misurato che su tredici anni la sedia viva fa **-2.125 PF 0,972 DD
#  17,68%** e la cella scelta col metodo fa **+4.323 PF 1,095 DD 9,87%**.
#  Ma R73 (tick reali, 2024-2026) dice l'opposto. **Le due misure non si
#  possono conciliare coi dati che abbiamo**, quindi invece di scommettere
#  su quale banco ha ragione si mettono in campo TUTTE E DUE e si guarda.
#
#  🔴 ATTENZIONE, DA LEGGERE PRIMA DI LANCIARE:
#  questo e' il PRIMO tocco a una sedia in forward dopo dodici round.
#  Non si cambia la strategia della sedia viva: si cambia SOLO il suo
#  rischio da 1,0% a 0,5%, per due motivi:
#    a) le due sedie devono avere la STESSA taglia, altrimenti il
#       confronto in forward non vale niente;
#    b) 0,5 + 0,5 = 1,0: l'esposizione totale su GBPUSD resta quella di
#       oggi. Con 1,0 + 1,0 la raddoppieremmo.
#  ⚠️ Conseguenza da sapere: i profitti in euro della 771322 prima e dopo
#     oggi NON sono confrontabili fra loro (la taglia cambia). Il
#     contatore dei TRADE invece continua normalmente.
#
#  ALTERNATIVA se non vuoi toccare la viva: lasciarla a 1,0 e mettere la
#  candidata a 1,0 -> confronto valido uguale, ma esposizione doppia.
#  In quel caso si cambia una riga sola qui sotto e si rilancia.
# =====================================================================
$ErrorActionPreference = "Stop"

# --- cartella dati del MT5 del conto piccolo (via origin.txt) --------
$root = Join-Path $env:APPDATA "MetaQuotes\Terminal"
$folders = Get-ChildItem $root -Directory -ErrorAction SilentlyContinue | Where-Object {
  Test-Path (Join-Path $_.FullName "origin.txt") }
$old = $folders | Where-Object {
  $o = (Get-Content (Join-Path $_.FullName "origin.txt") -Raw).Trim()
  $o -like "*BCM*MT5*" -and $o -notlike "*-V3*" -and $o -notlike "*MT4*" } | Select-Object -First 1
if (-not $old) { $old = $folders | Select-Object -First 1 }
if (-not $old) { Write-Host "Cartella dati MT5 non trovata." -ForegroundColor Red; exit 1 }
Write-Host ("Istanza: " + (Get-Content (Join-Path $old.FullName "origin.txt") -Raw).Trim()) -ForegroundColor Gray

$Presets = Join-Path $old.FullName "MQL5\Presets"
New-Item -ItemType Directory -Force -Path $Presets | Out-Null

# --- RISCHIO: 0.5 su entrambe (vedi nota in testa) -------------------
$Rischio = "0.5"

# --- i due preset: SOLO gli input che cambiano dai default -----------
#     InpTF numerico: 16385 = H1 (enum MT5)
$Set = @{
  # la sedia VIVA: identica a prima TRANNE il rischio
  "VIVAIO_PTE_GBPUSD.set" = @(
    "InpTF=16385",
    "InpTP1_ATRmult=0.5",
    "InpSLbufferPips=5.0",
    "InpTP2_ATRmult=2.0",
    "InpRiskPercent=$Rischio",
    "InpMagic=771322",
    "InpComment=PTE GBPUSD"
  )
  # la CANDIDATA di R78: cambiano SOLO buffer e target
  "VIVAIO_PTE_GBPUSD_B25.set" = @(
    "InpTF=16385",
    "InpTP1_ATRmult=0.5",
    "InpSLbufferPips=25.0",
    "InpTP2_ATRmult=3.0",
    "InpRiskPercent=$Rischio",
    "InpMagic=771332",
    "InpComment=PTE GBPUSD B25"
  )
}
foreach ($nome in $Set.Keys) {
  $Set[$nome] -join "`r`n" | Set-Content -Path (Join-Path $Presets $nome) -Encoding ASCII
  Write-Host ("  scritto: " + $nome) -ForegroundColor Green
}

Write-Host ""
Write-Host "=== COSA FARE ADESSO IN MT5 (conto piccolo) ===" -ForegroundColor White
Write-Host "  1. Sul grafico GBPUSD H1 che ha gia' ABTG_PTE (magic 771322):"
Write-Host "     tasto destro -> Lista degli Expert -> Proprieta' -> Carica"
Write-Host "     -> VIVAIO_PTE_GBPUSD.set   (cambia SOLO il rischio: 1,0 -> 0,5)"
Write-Host "  2. APRI UN SECONDO grafico GBPUSD H1, trascina ABTG_PTE,"
Write-Host "     Carica -> VIVAIO_PTE_GBPUSD_B25.set   (magic 771332)"
Write-Host "  3. Screenshot degli input di TUTTI E DUE prima di dare OK."
Write-Host "  4. File -> Profili -> Salva  (senza salvare i .chr non si aggiornano)"
Write-Host ""
Write-Host "CONTROLLI CHE FARO' IO SUGLI SCREENSHOT:" -ForegroundColor Yellow
Write-Host "  771322 -> SLbufferPips 5   TP2 2.0   TP1 0.5   Risk 0.5"
Write-Host "  771332 -> SLbufferPips 25  TP2 3.0   TP1 0.5   Risk 0.5"
Write-Host "  I DUE MAGIC DEVONO ESSERE DIVERSI. Se sono uguali si fermano a vicenda."
Write-Host ""
Write-Host "REGOLA DEL CONFRONTO (congelata adesso, prima dei numeri):" -ForegroundColor Cyan
Write-Host "  si confrontano a PARI NUMERO DI TRADE, non a pari data:"
Write-Host "  la candidata fa piu' operazioni (in R78: 477 contro 447)."
Write-Host "  Collaudo a 10 trade per sedia, verdetto a 30. A ~34 trade/anno"
Write-Host "  fanno circa 3,5 mesi e 10 mesi."
