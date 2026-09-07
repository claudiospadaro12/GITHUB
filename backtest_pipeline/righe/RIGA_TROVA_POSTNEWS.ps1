# =====================================================================
#  MARCATORE_RIGA_TROVA_POSTNEWS_v2
#  Dove girano le tre sedie PostNews (771201 ECB / 771202 FOMC /
#  771203 NFP), su TUTTI i terminali. 07/09/2026.
# ---------------------------------------------------------------------
#  v2 (07/09 sera): la v1 era LENTA e Claudio l'ha aspettata due volte.
#  Motivo, misurato sul suo VPS: la v1 rileggeva ogni .chr e ogni log
#  UNA VOLTA PER MAGIC (3 giri) e per giunta con Get-Content completo.
#  Su cinque cartelle dati con log grossi sono minuti.
#  La v2 legge OGNI FILE UNA VOLTA SOLA e cerca tutti e tre i magic in
#  quel passaggio, salta i file troppo grandi dichiarandolo, e stampa
#  l'avanzamento cartella per cartella cosi' non sembra piantata.
#
#  PERCHE': il censimento dei contratti (report/CENSIMENTO_CONTRATTI.md)
#  ha trovato che queste tre girano in forward con ZERO DD promesso, e a
#  un rischio fuori scala rispetto al resto della flotta:
#     771201 ECB  EURJPY  3,00%
#     771202 FOMC EURUSD  3,00%
#     771203 NFP  USDJPY  1,30%/evento -- e HA GIA' OPERATO (+37,36 il 04/09)
#  Il resto della flotta gira allo 0,65%. Il cap C1 firmato il 18/08 e' il
#  3,25% di rischio APERTO COMPLESSIVO: una sola ECB al 3,00% ne mangia il 92%.
#  Claudio ha deciso il 07/09: FERMIAMO. I calendari sono gia' stati
#  svuotati (report/POSTNEWS_NEUTRALIZZATE_2026-09-07.md), ma quello e' un
#  TAMPONE: gli EA sono ancora attaccati. Questa riga dice DOVE.
#
#  MA NON SI STACCA A OCCHIO. L'ultima foto dei grafici in archivio e' del
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
  $MAXMB = 80    # un log oltre questa taglia si dichiara e si salta

  $root = Join-Path $env:APPDATA "MetaQuotes\Terminal"
  if(-not (Test-Path $root)){ Write-Host "NESSUNA cartella dati MT5 sotto $root" -ForegroundColor Red; return }
  $cart = @(Get-ChildItem $root -Directory -ErrorAction SilentlyContinue | Where-Object { Test-Path (Join-Path $_.FullName "MQL5") })
  Write-Host ("cartelle dati trovate: " + $cart.Count) -ForegroundColor Cyan
  Write-Host "(un giro solo per file: cerca tutti e tre i magic insieme)" -ForegroundColor DarkGray

  $trovate = 0; $saltati = 0
  foreach($d in $cart){
    $chi = if($CONTI.ContainsKey($d.Name)){ $CONTI[$d.Name] } else { "SCONOSCIUTA -- " + $d.Name }
    Write-Host ""
    Write-Host ("=== " + $chi) -ForegroundColor Cyan
    Write-Host ("    " + $d.FullName) -ForegroundColor DarkGray
    $qui = 0
    $esiti = @{}
    foreach($m in $MAGIC){ $esiti[$m] = New-Object System.Collections.ArrayList }

    # --- i .chr: un giro solo, tutti i magic insieme
    $chr = @(Get-ChildItem (Join-Path $d.FullName "MQL5\Profiles\Charts") -Recurse -Filter *.chr -ErrorAction SilentlyContinue)
    Write-Host ("    .chr da leggere: " + $chr.Count) -ForegroundColor DarkGray
    foreach($f in $chr){
      $txt = [string]::Join("`n", @(Get-Content -LiteralPath $f.FullName -ErrorAction SilentlyContinue))
      foreach($m in $MAGIC){ if($txt.Contains($m)){ [void]$esiti[$m].Add("        .chr  " + $f.Name) } }
    }

    # --- i log: un giro solo, tutti i magic insieme
    $log = @(Get-ChildItem (Join-Path $d.FullName "MQL5\Logs") -Filter *.log -ErrorAction SilentlyContinue |
             Sort-Object LastWriteTime -Descending | Select-Object -First 20)
    Write-Host ("    log da leggere : " + $log.Count) -ForegroundColor DarkGray
    foreach($f in $log){
      if($f.Length -gt ($MAXMB * 1MB)){
        $saltati++
        Write-Host ("      SALTATO (troppo grande, " + [int]($f.Length/1MB) + " MB): " + $f.Name) -ForegroundColor Yellow
        continue
      }
      $hit = @(Select-String -LiteralPath $f.FullName -Pattern ($MAGIC -join "|") -ErrorAction SilentlyContinue)
      if($hit.Count -eq 0){ continue }
      foreach($m in $MAGIC){
        $mie = @($hit | Where-Object { $_.Line.Contains($m) })
        if($mie.Count -eq 0){ continue }
        [void]$esiti[$m].Add("        log   " + $f.Name + "   (ultimo: " + $f.LastWriteTime + ")   righe: " + $mie.Count)
        foreach($r in @($mie | Select-Object -Last 2)){ [void]$esiti[$m].Add("              " + $r.Line.Trim()) }
      }
    }

    foreach($m in $MAGIC){
      if($esiti[$m].Count -eq 0){ continue }
      $qui++; $trovate++
      Write-Host ("    MAGIC " + $m + "  ->  TROVATO QUI") -ForegroundColor Yellow
      foreach($r in $esiti[$m]){ Write-Host $r -ForegroundColor Gray }
    }
    if($qui -eq 0){ Write-Host "    CONTROLLATA: nessuno dei tre magic PostNews qui" -ForegroundColor Green }
  }

  Write-Host ""
  if($saltati -gt 0){ Write-Host ("ATTENZIONE: " + $saltati + " log saltati perche' oltre " + $MAXMB + " MB: su quelli NON si e' guardato.") -ForegroundColor Yellow }
  if($trovate -eq 0){ Write-Host "ESITO: NESSUNA TRACCIA dei magic 771201/771202/771203 in nessuna cartella dati." -ForegroundColor Green }
  else { Write-Host ("ESITO: " + $trovate + " riscontri. Le sedie da staccare stanno nei terminali segnati in GIALLO qui sopra.") -ForegroundColor Yellow }
  Write-Host "Questa riga LEGGE E BASTA: non ha chiuso, staccato o modificato niente." -ForegroundColor Cyan
}
