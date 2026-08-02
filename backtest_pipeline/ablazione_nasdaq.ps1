# =====================================================================
#  ablazione_nasdaq.ps1  --  QUALE filtro crea l'edge, e QUALE taglia solo
#  il campione? Sul NASDAQ, a tick reali, un filtro alla volta.
#
#  PERCHE':
#  il 02/08 la configurazione dei documenti ha ribaltato il Nasdaq
#  (0,88 -> 1,11-1,52) ma con SOLI 72 TRADE: sotto la soglia di ~80 che ci
#  eravamo dati. Non sappiamo se l'edge viene dai livelli H1, dai volumi,
#  dall'ATR o dal trend H4 -- ne' quale filtro stia bruciando il campione.
#  Questa scala lo dice: si aggiunge UN filtro alla volta e si guarda
#  come si muovono INSIEME il PF e il numero di trade.
#
#  COME SI LEGGE (la parte che conta):
#   - PF sale e i trade calano poco   -> filtro BUONO, tienilo
#   - PF fermo e i trade crollano     -> filtro INUTILE, toglilo
#   - PF sale ma i trade crollano     -> sospetto: e' selezione, non edge.
#                                        Con pochi trade il PF non e' un dato.
#
#  ⚠️ SUL PC DI BACKTEST (non il VPS). MetaTrader CHIUSO. E' lungo (ore).
#
#  Lancia con UNA riga:
#    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/claude/chat-ea-market-openings-zoba2j/backtest_pipeline/ablazione_nasdaq.ps1" | iex
# =====================================================================
$ErrorActionPreference="Stop"
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force
[Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12

$b="https://raw.githubusercontent.com/claudiospadaro12/GITHUB/claude/chat-ea-market-openings-zoba2j/backtest_pipeline"
$Work=Join-Path $env:USERPROFILE "Desktop"
if(-not (Test-Path $Work)){ $Work=(Get-Location).Path }
Set-Location $Work

Write-Host "=== Scarico lo script aggiornato in $Work ===" -ForegroundColor Cyan
$us=Join-Path $Work "conferma_apertura_us.ps1"
irm "$b/conferma_apertura_us.ps1" -OutFile $us
Write-Host "   OK" -ForegroundColor Green

if(Get-Process -Name "terminal64" -ErrorAction SilentlyContinue){
  Write-Host "!!! MetaTrader e' APERTO: chiudilo e rilancia." -ForegroundColor Red; return
}

# scala cumulativa: si parte dai SOLI livelli del piano (candela H1 precedente),
# poi si accende un filtro alla volta nell'ordine in cui i documenti li presentano
$scala = @(
  @{ n="1/6  soli LIVELLI H1 (nessun filtro)"; f="" },
  @{ n="2/6  + VOLUMI (>= +50%)";              f="vol" },
  @{ n="3/6  + ATR (>= media)";                f="vol,atr" },
  @{ n="4/6  + TREND H4";                      f="vol,atr,h4" },
  @{ n="5/6  + CORRELAZIONE SPXUSD";           f="vol,atr,h4,corr" },
  @{ n="6/6  + FILTRO NEWS (piano completo)";  f="vol,atr,h4,corr,news" }
)

foreach($s in $scala){
  Write-Host "`n===== $($s.n) =====" -ForegroundColor Yellow
  & $us -Model 4 -EntryMode 0 -Doc -Filters $s.f -Symbols NASUSD
}

Write-Host "`n===== ABLAZIONE FINITA =====" -ForegroundColor Green
Write-Host "Sul Desktop trovi 6 cartelle risultati_APERT_US_M5_doc_brk_*_realtick" -ForegroundColor White
Write-Host "(nofilt, vol, volatr, volatrh4, volatrh4corr, volatrh4corrnews)." -ForegroundColor White
Write-Host "Zippale TUTTE e caricamele: ti dico quale filtro porta l'edge e quale" -ForegroundColor White
Write-Host "sta solo tagliando il campione." -ForegroundColor White
