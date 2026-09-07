# =====================================================================
#  MARCATORE_CODA_01_SEDIE_ATTACCATE_v1
#  RUNNER_SOLA_LETTURA
# ---------------------------------------------------------------------
#  COSA FA: legge i .chr di TUTTE le cartelle dati e STAMPA che cosa e'
#  attaccato dove -- EA, simbolo, timeframe, magic, rischio %.
#  Non scrive un file, non copia, non cancella, non avvia niente:
#  STAMPA e basta. Il runner cattura lo standard output e lo pubblica.
#
#  PERCHE' E' LA PRIMA DELLA CODA
#  Il 07/09/2026 abbiamo passato la serata a scoprire a mano dove
#  fossero tre EA, e il censimento dei contratti ha dovuto dichiarare
#  che "l'ultima foto .chr e' del 25/08". Questa riga, girando ogni
#  notte, rende quella frase impossibile: la foto e' sempre di stanotte.
#
#  ENUMERA TUTTE LE CARTELLE DATI, senza puntarne nessuna in
#  particolare. E' una LETTURA generica: serve proprio a vedere se
#  qualcosa compare dove non dovrebbe.
#
#  ATTENZIONE, IL LIMITE, DICHIARATO: i .chr si aggiornano solo quando MT5 salva
#  il profilo. Un grafico aperto e mai salvato NON compare, e un .chr
#  vecchio puo' descrivere un grafico che non c'e' piu'. Questa riga
#  dice "cosa risulta salvato", non "cosa gira adesso".
# =====================================================================

$root = Join-Path $env:APPDATA "MetaQuotes\Terminal"
Write-Host "=== SEDIE ATTACCATE, DA .chr -- foto di stanotte ==="
Write-Host ("data lettura: " + (Get-Date -Format "yyyy-MM-dd HH:mm:ss") + "  (ora locale)")
if(-not (Test-Path $root)){ Write-Host "NESSUNA cartella MetaQuotes\Terminal"; exit 1 }

$cart = @(Get-ChildItem $root -Directory -ErrorAction SilentlyContinue | Where-Object { Test-Path (Join-Path $_.FullName "MQL5") })
Write-Host ("cartelle dati: " + $cart.Count)

$tot = 0
foreach($d in $cart){
  Write-Host ""
  Write-Host ("=== CARTELLA " + $d.Name)
  $orig = Join-Path $d.FullName "origin.txt"
  if(Test-Path -LiteralPath $orig){
    $o = (Get-Content -LiteralPath $orig -Raw -ErrorAction SilentlyContinue)
    if($o){ Write-Host ("    programma: " + ($o -replace "[^\x20-\x7E]","").Trim()) }
  }
  $chr = @(Get-ChildItem (Join-Path $d.FullName "MQL5\Profiles\Charts") -Recurse -Filter *.chr -ErrorAction SilentlyContinue)
  Write-Host ("    .chr trovati: " + $chr.Count)
  $qui = 0
  foreach($x in $chr){
    $t = @(Get-Content -LiteralPath $x.FullName -ErrorAction SilentlyContinue)
    $ea = ($t | Where-Object { $_ -match '^name=' } | Select-Object -First 1) -replace '^name=',''
    if([string]::IsNullOrWhiteSpace($ea)){ continue }          # grafico senza EA
    $sym = ($t | Where-Object { $_ -match '^symbol=' } | Select-Object -First 1) -replace '^symbol=',''
    $per = ($t | Where-Object { $_ -match '^period_size=' } | Select-Object -First 1) -replace '^period_size=',''
    $mag = ($t | Where-Object { $_ -match '^InpMagic=' } | Select-Object -First 1) -replace '^InpMagic=',''
    $ris = ($t | Where-Object { $_ -match '^InpRiskPercent=' } | Select-Object -First 1) -replace '^InpRiskPercent=',''
    $tf  = switch([int]$per){ 1{"M1"} 5{"M5"} 15{"M15"} 30{"M30"} 60{"H1"} 240{"H4"} 1440{"D1"} default{"p"+$per} }
    $qui++; $tot++
    Write-Host ("    {0,-30} {1,-8} {2,-4} magic {3,-8} rischio {4,-6} [{5}]" -f $ea, $sym, $tf, $mag, $ris, $x.Name)
  }
  if($qui -eq 0){ Write-Host "    CONTROLLATA: nessun EA su grafico salvato qui" }
}

Write-Host ""
Write-Host ("TOTALE SEDIE SU GRAFICO SALVATO: " + $tot)
Write-Host "Questa riga LEGGE E STAMPA: non ha scritto, copiato o modificato niente."
exit 0
