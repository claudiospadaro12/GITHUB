# =====================================================================
#  MARCATORE_CODA_02_CHI_HA_OPERATO_v1
#  RUNNER_SOLA_LETTURA
# ---------------------------------------------------------------------
#  COSA FA: legge gli ultimi log di ogni cartella dati e STAMPA, per
#  ogni EA che ha scritto qualcosa, quante righe ha prodotto e qual e'
#  l'ultima. Serve a vedere in una schermata CHI LAVORA E CHI E' MUTO.
#  Non scrive un file, non copia, non cancella: STAMPA e basta.
#
#  PERCHE' E' LA SECONDA DELLA CODA
#  Il criterio di uscita firmato il 18/08 ha una corsia TAGLIANDO
#  ("frequenza molto sotto il promesso -> revisione"), e per applicarla
#  serve sapere chi non spara piu'. Oggi quella cosa si scopre a mano,
#  una sedia alla volta. Girando ogni notte, si scopre da sola.
#
#  ATTENZIONE, IL LIMITE, DICHIARATO: un EA che non stampa niente non compare, e
#  "non stampa" non vuol dire "non opera". Molti nostri EA scrivono col
#  loro prefisso ma NON col numero di magic: qui si conta per PREFISSO,
#  non per magic. E' un indizio di attivita', non un conteggio di
#  operazioni -- quello sta nei CSV del TradeExporter.
# =====================================================================

$GIORNI = 3          # quanti file di log recenti guardare per cartella
$root = Join-Path $env:APPDATA "MetaQuotes\Terminal"

Write-Host "=== CHI HA SCRITTO NEI LOG -- ultimi $GIORNI file per cartella ==="
Write-Host ("data lettura: " + (Get-Date -Format "yyyy-MM-dd HH:mm:ss") + "  (ora locale)")
Write-Host "NB: la scheda Esperti e' in ORA LOCALE; il grafico in ORA SERVER (locale meno 1)."
if(-not (Test-Path $root)){ Write-Host "NESSUNA cartella MetaQuotes\Terminal"; exit 1 }

$cart = @(Get-ChildItem $root -Directory -ErrorAction SilentlyContinue | Where-Object { Test-Path (Join-Path $_.FullName "MQL5") })
Write-Host ("cartelle dati: " + $cart.Count)

foreach($d in $cart){
  Write-Host ""
  Write-Host ("=== CARTELLA " + $d.Name)
  $log = @(Get-ChildItem (Join-Path $d.FullName "MQL5\Logs") -Filter *.log -ErrorAction SilentlyContinue |
           Sort-Object LastWriteTime -Descending | Select-Object -First $GIORNI)
  Write-Host ("    log letti: " + $log.Count)
  if($log.Count -eq 0){ Write-Host "    CONTROLLATA: nessun log"; continue }

  $conta = @{}
  $ultima = @{}
  foreach($f in $log){
    Write-Host ("      " + $f.Name + "   (" + [int]($f.Length/1KB) + " KB, ultimo " + $f.LastWriteTime + ")")
    foreach($riga in @(Get-Content -LiteralPath $f.FullName -ErrorAction SilentlyContinue)){
      # le righe degli EA di casa hanno la forma  ...  NomeEA (SIMBOLO,TF)  ...
      $m = [regex]::Match($riga, '\s(ABTG_[A-Za-z0-9_]+)\s*\(([^,]+),([^)]+)\)')
      if(-not $m.Success){ continue }
      $k = $m.Groups[1].Value + "  " + $m.Groups[2].Value + " " + $m.Groups[3].Value
      if($conta.ContainsKey($k)){ $conta[$k] = $conta[$k] + 1 } else { $conta[$k] = 1 }
      $ultima[$k] = $riga.Trim()
    }
  }
  if($conta.Count -eq 0){ Write-Host "    nessuna riga di EA riconosciuta in questi log"; continue }
  Write-Host ""
  Write-Host ("    {0,-42} {1,7}   ultima riga" -f "EA (SIMBOLO TF)", "righe")
  foreach($k in ($conta.Keys | Sort-Object { -$conta[$_] })){
    $u = $ultima[$k]
    if($u.Length -gt 110){ $u = $u.Substring(0,110) + "..." }
    Write-Host ("    {0,-42} {1,7}   {2}" -f $k, $conta[$k], $u)
  }
}

Write-Host ""
Write-Host "Questa riga LEGGE E STAMPA: non ha scritto, copiato o modificato niente."
exit 0
