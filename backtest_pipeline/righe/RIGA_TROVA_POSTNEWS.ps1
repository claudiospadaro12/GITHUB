# =====================================================================
#  MARCATORE_RIGA_TROVA_POSTNEWS_v1
#  Dove girano le tre sedie PostNews (771201 ECB / 771202 FOMC /
#  771203 NFP), su TUTTI i terminali. 07/09/2026.
# ---------------------------------------------------------------------
#  PERCHE': il censimento dei contratti (report/CENSIMENTO_CONTRATTI.md)
#  ha trovato che queste tre girano in forward con ZERO DD promesso, e a
#  un rischio fuori scala rispetto al resto della flotta:
#     771201 ECB  EURJPY  3,00%   (preset ABTG_PostNews_ECB_EURJPY.set)
#     771202 FOMC EURUSD  3,00%   (preset ABTG_PostNews_FOMC_EURUSD.set)
#     771203 NFP  USDJPY  1,30%/evento -- e HA GIA' OPERATO (+37,36 il 04/09)
#  Il resto della flotta gira allo 0,65%. Il cap C1 firmato il 18/08 e' il
#  3,25% di rischio APERTO COMPLESSIVO: una sola ECB al 3,00% ne mangia il 92%.
#  Claudio ha deciso il 07/09: FERMIAMO.
#
#  MA NON SI FERMA A OCCHIO. L'ultima foto dei grafici in archivio e' del
#  25/08 e non copre il conto reale: DOVE siano non e' un fatto agli atti.
#  Questa riga lo STAMPA, incrociando due fonti indipendenti:
#    - i .chr salvati (ma valgono solo se il profilo e' stato salvato)
#    - gli ULTIMI 20 LOG di ogni terminale (un EA che ha girato ha scritto)
#
#  >>> LEGGE E BASTA. Non chiude, non stacca, non modifica un byte.
#      Si lancia col terminale APERTO: sul VPS il forward non si chiude.
#
#  >>> UNA CARTELLA SENZA RISCONTRI STAMPA "CONTROLLATA", non il silenzio.
#      Corretto al banco il 07/09: con un contatore globale la cartella
#      pulita non stampava niente, e "controllata e pulita" diventava
#      indistinguibile da "non controllata". Adesso il contatore e' per
#      cartella. Collaudato su albero finto nei due casi (riscontri
#      trovati / nessuna traccia da nessuna parte).
# =====================================================================
& {
  $CONTI = @{ "215D85D767A1C39E22D242C8114BF9F5" = "50503392  PICCOLO demo   (BCM Markets MT5 Terminal)";
              "BCA8AD18563BF5B64A433C2662D0A104" = "50504263  100k demo      (BCM Markets MT5 Terminal -V3)";
              "E23E1504A8D02A22179395F0652B86B6" = "10105439  *** REALE ***  (C:\BCM_Reale)" }
  $MAGIC = @("771201","771202","771203")
  $root = Join-Path $env:APPDATA "MetaQuotes\Terminal"
  if(-not (Test-Path $root)){ Write-Host "NESSUNA cartella dati MT5 sotto $root" -ForegroundColor Red; return }
  $cart = @(Get-ChildItem $root -Directory -ErrorAction SilentlyContinue | Where-Object { Test-Path (Join-Path $_.FullName "MQL5") })
  Write-Host ("cartelle dati trovate: " + $cart.Count) -ForegroundColor Cyan
  $trovate = 0
  foreach($d in $cart){
    $chi = if($CONTI.ContainsKey($d.Name)){ $CONTI[$d.Name] } else { "SCONOSCIUTA -- " + $d.Name }
    Write-Host ""
    Write-Host ("=== " + $chi) -ForegroundColor Cyan
    Write-Host ("    " + $d.FullName) -ForegroundColor DarkGray
    $qui = 0
    foreach($m in $MAGIC){
      $inChr = @(Get-ChildItem (Join-Path $d.FullName "MQL5\Profiles\Charts") -Recurse -Filter *.chr -ErrorAction SilentlyContinue |
                 Where-Object { (Get-Content $_.FullName -ErrorAction SilentlyContinue) -match $m })
      $inLog = @(Get-ChildItem (Join-Path $d.FullName "MQL5\Logs") -Filter *.log -ErrorAction SilentlyContinue |
                 Sort-Object LastWriteTime -Descending | Select-Object -First 20 |
                 Where-Object { Select-String -LiteralPath $_.FullName -SimpleMatch $m -Quiet -ErrorAction SilentlyContinue })
      if($inChr.Count -eq 0 -and $inLog.Count -eq 0){ continue }
      $trovate++; $qui++
      Write-Host ("    MAGIC " + $m + "  ->  grafici salvati: " + $inChr.Count + "   log recenti che lo nominano: " + $inLog.Count) -ForegroundColor Yellow
      foreach($f in $inChr){ Write-Host ("        .chr  " + $f.Name) -ForegroundColor Gray }
      foreach($f in $inLog){
        Write-Host ("        log   " + $f.Name + "   (ultimo: " + $f.LastWriteTime + ")") -ForegroundColor Gray
        Select-String -LiteralPath $f.FullName -SimpleMatch $m -ErrorAction SilentlyContinue | Select-Object -Last 2 |
          ForEach-Object { Write-Host ("              " + $_.Line.Trim()) -ForegroundColor DarkGray }
      }
    }
    if($qui -eq 0){ Write-Host "    CONTROLLATA: nessuno dei tre magic PostNews qui" -ForegroundColor Green }
  }
  Write-Host ""
  if($trovate -eq 0){ Write-Host "ESITO: NESSUNA TRACCIA dei magic 771201/771202/771203 in nessuna cartella dati." -ForegroundColor Green }
  else { Write-Host ("ESITO: " + $trovate + " riscontri. Le sedie da staccare stanno nei terminali segnati in GIALLO qui sopra.") -ForegroundColor Yellow }
  Write-Host "Questa riga LEGGE E BASTA: non ha chiuso, staccato o modificato niente." -ForegroundColor Cyan
}
