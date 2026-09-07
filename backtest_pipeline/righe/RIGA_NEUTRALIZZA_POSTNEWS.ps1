# =====================================================================
#  MARCATORE_RIGA_NEUTRALIZZA_POSTNEWS_v1
#  Neutralizza le tre sedie PostNews SENZA toccare MT5, svuotando il
#  loro CALENDARIO. 07/09/2026.
# ---------------------------------------------------------------------
#  PERCHE' FUNZIONA -- verificato nel sorgente, non supposto:
#    ABTG_PostNews.mq5 riga 251:
#      if(InpRestrictToNews && !NewsToday(t0)){ Log("nessuna notizia nel
#          CSV oggi: niente ordini."); return; }
#    e riga 265: NewsToday() torna false quando gNewsCount==0.
#  E tutti e tre i preset del forward hanno InpRestrictToNews=true e
#  InpUseNewsFilter=true (verificato nei .set il 07/09):
#      771201 ECB  EURJPY  3,00%  -> abtg_news.csv
#      771202 FOMC EURUSD  3,00%  -> abtg_news.csv
#      771203 NFP  USDJPY  1,30%  -> abtg_news_live_2026-09-04.csv
#  Senza eventi nel file, NESSUNA delle tre puo' armare.
#
#  >>> QUESTO E' UN TAMPONE, NON LO SPEGNIMENTO DEFINITIVO. Lo dico qui
#      e va detto ogni volta:
#      1. NON stacca gli EA dai grafici (restano attaccati e vivi);
#      2. NON chiude posizioni ne' cancella pendenti gia' aperti --
#         per quelli serve ABTG_ChiudiSedie;
#      3. il calendario si RICARICA al cambio di giorno (riga 230) o a
#         un OnInit. Un evento GIA' caricato in memoria OGGI resta
#         caricato: l'effetto e' certo DAL GIORNO DOPO, o subito se il
#         terminale/EA si reinizializza.
#      Lo spegnimento vero resta: staccare l'EA + ChiudiSedie.
#
#  >>> SCRIVE nei file di MT5, e lo dichiaro (checklist punto 7). Scrive
#      SOLO dentro Files\ (dati), MAI dentro config\ ne' nei .chr. E
#      fa una COPIA DATATA di ogni file prima di toccarlo: si torna
#      indietro copiando il .bak sopra l'originale.
# =====================================================================

param([switch]$EseguiDavvero)   # SICURA: senza questo, guarda e non tocca

$ErrorActionPreference = "Stop"
$CAL = @("abtg_news.csv","abtg_news_live_2026-09-04.csv")
$stamp = Get-Date -Format "yyyy-MM-dd_HHmmss"

Write-Host ""
Write-Host "=== NEUTRALIZZA POSTNEWS (771201 / 771202 / 771203) ===" -ForegroundColor Cyan
Write-Host "    MARCATORE_RIGA_NEUTRALIZZA_POSTNEWS_v1" -ForegroundColor DarkGray
if(-not $EseguiDavvero){
  Write-Host "    MODALITA' GUARDA E BASTA (default). Per agire davvero: -EseguiDavvero" -ForegroundColor Yellow
}

$root = Join-Path $env:APPDATA "MetaQuotes\Terminal"
if(-not (Test-Path $root)){ Write-Host "!!! nessuna cartella MetaQuotes\Terminal" -ForegroundColor Red; exit 1 }

# i posti dove il calendario puo' stare: il Common (condiviso) e la
# sandbox MQL5\Files di OGNI cartella dati. Il file e' installato in
# entrambi, quindi si svuotano entrambi.
$posti = New-Object System.Collections.ArrayList
[void]$posti.Add((Join-Path $root "Common\Files"))
foreach($d in @(Get-ChildItem $root -Directory -ErrorAction SilentlyContinue | Where-Object { Test-Path (Join-Path $_.FullName "MQL5") })){
  [void]$posti.Add((Join-Path $d.FullName "MQL5\Files"))
}

$trovati = 0; $svuotati = 0
foreach($p in $posti){
  if(-not (Test-Path -LiteralPath $p)){ continue }
  foreach($c in $CAL){
    $f = Join-Path $p $c
    if(-not (Test-Path -LiteralPath $f)){ continue }
    $trovati++
    $righe = @(Get-Content -LiteralPath $f -ErrorAction SilentlyContinue)
    Write-Host ""
    Write-Host ("  TROVATO  " + $f) -ForegroundColor Yellow
    Write-Host ("     righe attuali: " + $righe.Count + "   (header incluso)")
    if($righe.Count -gt 0){ Write-Host ("     header: " + $righe[0]) -ForegroundColor DarkGray }
    if($righe.Count -gt 1){ Write-Host ("     prima riga dati: " + $righe[1]) -ForegroundColor DarkGray }
    if(-not $EseguiDavvero){ Write-Host "     -> lo SVUOTEREI (tengo solo l'header). Adesso non tocco niente." -ForegroundColor Cyan; continue }
    $bak = $f + ".PRIMA_DI_NEUTRALIZZARE_" + $stamp + ".bak"
    Copy-Item -LiteralPath $f -Destination $bak -Force
    if(-not (Test-Path -LiteralPath $bak)){ Write-Host "     !!! BACKUP FALLITO: NON svuoto questo file." -ForegroundColor Red; continue }
    $header = if($righe.Count -gt 0){ $righe[0] } else { "" }
    Set-Content -LiteralPath $f -Value $header -Encoding ASCII
    $dopo = @(Get-Content -LiteralPath $f -ErrorAction SilentlyContinue)
    if($dopo.Count -le 1){
      $svuotati++
      Write-Host ("     SVUOTATO. righe adesso: " + $dopo.Count + "   backup: " + (Split-Path $bak -Leaf)) -ForegroundColor Green
    } else {
      Write-Host ("     !!! NON SVUOTATO: righe " + $dopo.Count) -ForegroundColor Red
    }
  }
}

Write-Host ""
if($trovati -eq 0){
  Write-Host "ESITO: NESSUN file di calendario trovato in nessun posto." -ForegroundColor Red
  Write-Host "  -> le tre sedie potrebbero gia' essere cieche, OPPURE il nome del file e' un altro." -ForegroundColor Yellow
  Write-Host "  -> NON dichiarare neutralizzate le sedie su questo esito: verifica il preset." -ForegroundColor Yellow
  exit 2
}
if(-not $EseguiDavvero){
  Write-Host ("ESITO: GUARDATO E BASTA. File di calendario trovati: " + $trovati + ". NIENTE E' STATO TOCCATO.") -ForegroundColor Cyan
  Write-Host "  Per agire: rilancia la stessa riga aggiungendo  -EseguiDavvero" -ForegroundColor Cyan
  exit 0
}
Write-Host ("ESITO: file trovati " + $trovati + "   SVUOTATI " + $svuotati) -ForegroundColor $(if($svuotati -eq $trovati){"Green"}else{"Yellow"})
Write-Host ""
Write-Host "RICORDA, ed e' scritto anche in testa a questo file:" -ForegroundColor Yellow
Write-Host "  - gli EA sono ANCORA ATTACCATI ai grafici;" -ForegroundColor Yellow
Write-Host "  - posizioni e pendenti gia' aperti NON sono stati toccati;" -ForegroundColor Yellow
Write-Host "  - l'effetto e' certo DAL GIORNO DOPO (il calendario si ricarica al cambio giorno)." -ForegroundColor Yellow
Write-Host "  Lo spegnimento definitivo resta: staccare l'EA + ABTG_ChiudiSedie." -ForegroundColor Yellow
if($svuotati -ne $trovati){ exit 3 }
exit 0
