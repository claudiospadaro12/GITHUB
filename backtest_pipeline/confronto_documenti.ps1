# =====================================================================
#  confronto_documenti.ps1  --  UN COMANDO: testa le aperture ESATTAMENTE
#  come le prescrivono i DOCUMENTI ABTG (PDF "La Magia delle Aperture" +
#  slide "Piano di Trading Europeo" / "Strategia Nasdaq").
#
#  Perche': i 3 motori bocciati (stop / retest / fade) sono stati testati
#  con TUTTI I FILTRI SPENTI. I documenti invece li danno come CONDIZIONI
#  d'ingresso, non come opzioni:
#    "Entra solo se la rottura e' supportata da aumento di volumi o da una
#     volatilita' coerente (ATR > media)."
#    "Entra subito dopo la chiusura della candela di breakout, NON durante."
#
#  Cosa accende -Doc:
#   US  : livelli = candela H1 precedente (slide Nasdaq) · volumi +50% ·
#         ATR >= media · trend H4 · correlazione SPXUSD · filtro news · risk 2%
#   DAX : livelli = GIORNO PRECEDENTE (il Piano Europeo non prescrive un ORB) ·
#         volumi +50% · ATR >= media · TRE Supertrend 2.5/3.0/3.5 concordi ·
#         correlazione SPXUSD · filtro news · risk 2%
#
#  Gira DUE varianti d'ingresso, perche' le fonti divergono:
#    A) EntryMode 0 = ordini STOP  -> come le slide "Strategia Nasdaq"
#    B) EntryMode 4 = ingresso confermato dopo la chiusura -> come il PDF
#
#  ⚠️ SUL PC DI BACKTEST (non il VPS). MetaTrader CHIUSO. E' lungo (ore).
#
#  Lancia con UNA riga:
#    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/claude/chat-ea-market-openings-zoba2j/backtest_pipeline/confronto_documenti.ps1" | iex
# =====================================================================
$ErrorActionPreference="Stop"
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force
[Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12

$b="https://raw.githubusercontent.com/claudiospadaro12/GITHUB/claude/chat-ea-market-openings-zoba2j/backtest_pipeline"
$Work=Join-Path $env:USERPROFILE "Desktop"
if(-not (Test-Path $Work)){ $Work=(Get-Location).Path }
Set-Location $Work

Write-Host "=== Scarico gli script aggiornati in $Work ===" -ForegroundColor Cyan
$us =Join-Path $Work "conferma_apertura_us.ps1"
$dax=Join-Path $Work "conferma_apertura_dax.ps1"
irm "$b/conferma_apertura_us.ps1"  -OutFile $us
irm "$b/conferma_apertura_dax.ps1" -OutFile $dax
Write-Host "   OK" -ForegroundColor Green

if(Get-Process -Name "terminal64" -ErrorAction SilentlyContinue){
  Write-Host "!!! MetaTrader e' APERTO: chiudilo e rilancia." -ForegroundColor Red; return
}

$Model=4   # tick reali = la verita'

Write-Host "`n===== 1/4  US  (slide Nasdaq: ordini STOP su H1) =====" -ForegroundColor Yellow
& $us  -Model $Model -EntryMode 0 -Doc
Write-Host "`n===== 2/4  US  (PDF: ingresso CONFERMATO dopo la chiusura) =====" -ForegroundColor Yellow
& $us  -Model $Model -EntryMode 4 -Doc
Write-Host "`n===== 3/4  DAX (livelli giorno prec., STOP) =====" -ForegroundColor Yellow
& $dax -Model $Model -EntryMode 0 -Doc
Write-Host "`n===== 4/4  DAX (livelli giorno prec., ingresso CONFERMATO) =====" -ForegroundColor Yellow
& $dax -Model $Model -EntryMode 4 -Doc

Write-Host "`n===== FINITO =====" -ForegroundColor Green
Write-Host "Cartelle sul Desktop: risultati_APERT_*_doc_brk_realtick + risultati_APERT_*_doc_delay_realtick" -ForegroundColor White
Write-Host "Zippale e caricamele. ATTENZIONE al NUMERO DI TRADE: con tutti i filtri del piano" -ForegroundColor White
Write-Host "accesi potrebbe crollare. Se scende sotto ~80 il campione non basta e va tolto" -ForegroundColor White
Write-Host "un filtro alla volta (l'ordine giusto e' nel documento di audit)." -ForegroundColor White
