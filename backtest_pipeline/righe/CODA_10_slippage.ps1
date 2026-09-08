# =====================================================================
#  MARCATORE_CODA_10_SLIPPAGE_v1
#  RUNNER_SOLA_LETTURA
# ---------------------------------------------------------------------
#  COSA FA: cerca in OGNI cartella dati i file che il SlippageLogger
#  scrive in MQL5\Files -- il LEDGER dei deal e la SINTESI -- e li
#  stampa. Non scrive, non copia, non cancella: STAMPA.
#
#  PERCHE' ESISTE -- Claudio, 08/09/2026 sera:
#     "COSI' PUOI INIZIARE A VALUTARE LO SLIPPAGE."
#  Il conto vero esiste anche per misurare quanto costa DAVVERO entrare
#  a mercato. Quella misura la produce ABTG_SlippageLogger, che scrive
#  <prefisso>_deal.csv e <prefisso>_sintesi.csv (righe 961-962 del
#  sorgente). Ma quei file restano sul terminale: finche' nessuno li
#  porta fuori, la misura c'e' e non la legge nessuno.
#
#  >>> PERCHE' LO SLIPPAGE E' LA MISURA CHE PESA DI PIU'
#      Le due sedie sul conto vero entrano in due modi OPPOSTI:
#      una con un ordine LIMIT (si riempie al livello O MEGLIO: zero
#      slippage d'ingresso per costruzione), l'altra con un ordine STOP
#      (che e' un ordine a mercato differito: lo slippage se lo prende
#      tutto). R119 l'ha misurato in backtest; QUESTI file lo misurano
#      sul campo, con soldi veri. E' l'unico posto dove il numero e'
#      vero e non simulato.
#
#  >>> COME SI LEGGE, E IL TRANELLO DA NON PRENDERE
#      "deal registrati 0" NON vuol dire "slippage zero": vuol dire che
#      in quella finestra non c'era nessun deal da misurare. Un ledger
#      VUOTO e un ledger PIENO DI ZERI sono due cose diverse, e qui si
#      stampa quale delle due e'.
#      E la DATA dell'ultima riga va guardata sempre: un ledger fermo a
#      tre giorni fa parla di tre giorni fa (classe 162).
#
#  LIMITE DICHIARATO: sul DEMO lo slippage e' zero per costruzione
#  (l'EA stesso ha l'input InpSoloContoReale che lo dice, riga 189).
#  Quindi da un terminale demo questi file, se ci sono, NON misurano
#  niente di utile: la misura che conta e' quella del conto vero.
# =====================================================================

$MAX_RIGHE = 60      # righe stampate al massimo per file

function Leggi-Condiviso($path){
  $b = $null
  try{
    $fs = [IO.File]::Open($path,[IO.FileMode]::Open,[IO.FileAccess]::Read,[IO.FileShare]::ReadWrite)
    $b  = New-Object byte[] $fs.Length
    [void]$fs.Read($b,0,$b.Length)
    $fs.Close()
  } catch { return "" }
  if($null -eq $b -or $b.Count -lt 2){ return "" }
  if($b[0] -eq 0xFF -and $b[1] -eq 0xFE){ return [Text.Encoding]::Unicode.GetString($b) }
  $zeri = 0; $n = [math]::Min(400,$b.Count)
  for($i=1; $i -lt $n; $i+=2){ if($b[$i] -eq 0){ $zeri++ } }
  if($zeri -gt ($n/4)){ return [Text.Encoding]::Unicode.GetString($b) }
  return [Text.Encoding]::UTF8.GetString($b)
}

$root = Join-Path $env:APPDATA "MetaQuotes\Terminal"
Write-Host "=== LO SLIPPAGE MISURATO SUL CAMPO ==="
Write-Host ("data lettura: " + (Get-Date -Format "yyyy-MM-dd HH:mm:ss") + "  (ora locale)")
Write-Host "file cercati: MQL5\Files\ABTG_Slippage*  (ledger dei deal e sintesi)"
if(-not (Test-Path $root)){ Write-Host "NESSUNA cartella MetaQuotes\Terminal"; exit 1 }

$cart = @(Get-ChildItem $root -Directory -ErrorAction SilentlyContinue | Where-Object { Test-Path (Join-Path $_.FullName "MQL5") })
$trovati = 0

foreach($d in $cart){
  $dirF = Join-Path $d.FullName "MQL5\Files"
  if(-not (Test-Path -LiteralPath $dirF)){ continue }
  $ff = @(Get-ChildItem -LiteralPath $dirF -Filter "ABTG_Slippage*" -Recurse -ErrorAction SilentlyContinue)
  if($ff.Count -eq 0){ continue }

  $orig = Join-Path $d.FullName "origin.txt"
  $prog = "(programma sconosciuto)"
  if(Test-Path -LiteralPath $orig){
    $o = Leggi-Condiviso $orig
    if($o){ $prog = ($o -replace "[^\x20-\x7E]","").Trim() }
  }

  Write-Host ""
  Write-Host "====================================================================="
  Write-Host ("=== " + $prog)
  Write-Host ("=== file dello SlippageLogger trovati: " + $ff.Count)
  Write-Host "====================================================================="

  foreach($f in ($ff | Sort-Object Name)){
    $trovati++
    $kb = [math]::Round($f.Length/1KB,2)
    Write-Host ""
    Write-Host (">>> " + $f.Name + "   (" + $kb + " KB, ultima scrittura " + $f.LastWriteTime.ToString("yyyy-MM-dd HH:mm") + ")") -ForegroundColor Yellow
    $t = Leggi-Condiviso $f.FullName
    if(-not $t){ Write-Host "    ILLEGGIBILE"; continue }
    $ln = @($t -split "`r?`n" | Where-Object { $_.Trim() -ne "" })
    Write-Host ("    righe non vuote: " + $ln.Count)
    if($ln.Count -le 1){
      Write-Host "    >>> FILE CON LA SOLA INTESTAZIONE (o vuoto): NESSUN DEAL REGISTRATO."
      Write-Host "        Attenzione: non vuol dire 'slippage zero'. Vuol dire che non"
      Write-Host "        c'e' stato niente da misurare, oppure che il logger non ha"
      Write-Host "        visto i deal. Sono due cose diverse: si guarda il log."
    }
    $n = 0
    foreach($r in $ln){
      $n++
      if($n -gt $MAX_RIGHE){ Write-Host ("    ... altre " + ($ln.Count - $MAX_RIGHE) + " righe non stampate (tetto)."); break }
      Write-Host ("    | " + ($r -replace "[^\x20-\x7E]","").TrimEnd())
    }
  }
}

Write-Host ""
if($trovati -eq 0){
  Write-Host "NESSUN file dello SlippageLogger su NESSUN terminale."
  Write-Host "Vuol dire una di queste, e vanno distinte guardando i log:"
  Write-Host "  - l'EA non ha mai registrato un deal (e quindi non ha mai scritto);"
  Write-Host "  - l'EA gira con un PREFISSO di file diverso da quello di default;"
  Write-Host "  - l'EA non e' attaccato da nessuna parte."
} else {
  Write-Host ("file stampati: " + $trovati)
}
Write-Host "PROMEMORIA: sul DEMO lo slippage e' zero per costruzione. La misura che"
Write-Host "conta e' quella del conto vero."
Write-Host "Questa riga LEGGE E STAMPA: non ha scritto, copiato o modificato niente."
exit 0
