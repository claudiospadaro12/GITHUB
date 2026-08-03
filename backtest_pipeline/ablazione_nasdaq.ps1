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
#  IL METRO DEL CAMPIONE (osservazione di Claudio, ed e' quella giusta):
#   2,5 anni = ~625 giorni di borsa. Un'apertura M5 si imposta QUASI OGNI GIORNO.
#   Il motore nudo faceva 328 trade (~52% dei giorni: normale, con gli ordini
#   STOP c'e' il giorno in cui non scatta nulla). 72 trade = 11% dei giorni:
#   NON e' un filtro, e' una mattanza. Sotto ~150 trade il risultato va guardato
#   con sospetto, sotto ~80 il PF non e' un dato.
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
#    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/lavoro/backtest_pipeline/ablazione_nasdaq.ps1" | iex
# =====================================================================
$ErrorActionPreference="Stop"
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force
[Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12

$b="https://raw.githubusercontent.com/claudiospadaro12/GITHUB/lavoro/backtest_pipeline"
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

# Si parte dai SOLI livelli del piano (candela H1 precedente), poi si accendono
# i filtri. NB: volumi e ATR sono in OR (come dice il PDF), quindi il gradino 4
# e' piu' PERMISSIVO dei gradini 2 e 3 presi da soli: e' voluto, serve a vedere
# quanto campione recupera la conferma "una delle due" rispetto a "solo volumi".
$scala = @(
  @{ n="1/7  soli LIVELLI H1 (nessun filtro)";      f="" },
  @{ n="2/7  solo VOLUMI (>= +50%)";                f="vol" },
  @{ n="3/7  solo ATR (>= media)";                  f="atr" },
  @{ n="4/7  VOLUMI *OPPURE* ATR (conferma PDF)";   f="vol,atr" },
  @{ n="5/7  + TREND H4";                           f="vol,atr,h4" },
  @{ n="6/7  + CORRELAZIONE SPXUSD";                f="vol,atr,h4,corr" },
  @{ n="7/7  + FILTRO NEWS (piano completo)";       f="vol,atr,h4,corr,news" }
)

foreach($s in $scala){
  Write-Host "`n===== $($s.n) =====" -ForegroundColor Yellow
  & $us -Model 4 -EntryMode 0 -Doc -Filters $s.f -Symbols NASUSD
}

Write-Host "`n===== ABLAZIONE FINITA =====" -ForegroundColor Green
Write-Host "Sul Desktop trovi 7 cartelle risultati_APERT_US_M5_doc_brk_*_realtick" -ForegroundColor White
Write-Host "(nofilt, vol, atr, volatr, volatrh4, volatrh4corr, volatrh4corrnews)." -ForegroundColor White
Write-Host "Zippale TUTTE e caricamele: ti dico quale filtro porta l'edge e quale" -ForegroundColor White
Write-Host "sta solo tagliando il campione." -ForegroundColor White
