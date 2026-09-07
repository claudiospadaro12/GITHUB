# =====================================================================
#  MARCATORE_CODA_03_CONTI_DEI_TERMINALI_v1
#  RUNNER_SOLA_LETTURA
# ---------------------------------------------------------------------
#  COSA FA: per OGNI cartella dati stampa QUALE CONTO ci sta dentro --
#  numero, server, azienda, e il MODO DI MARGINE (hedging o netting) --
#  leggendolo dal GIORNALE del terminale, non indovinandolo.
#  Non scrive, non copia, non cancella: STAMPA.
#
#  PERCHE' ESISTE
#  Il 07/09 il progetto ha passato mezza serata a capire "quale cartella
#  e' quale conto": la tabella dei conti era scritta a mano nelle righe
#  di lancio, e quando sono comparse CINQUE cartelle dati due sono
#  finite come "SCONOSCIUTA". Questa riga toglie la tabella a mano: il
#  numero di conto lo dice il terminale stesso.
#  E' anche l'unico modo per far rispettare davvero la REGOLA DEI
#  TERMINALI MULTIPLI di CLAUDE.md senza chiedere a nessuno di
#  riconoscere una finestra a occhio.
#
#  >>> IL MODO DI MARGINE E' IL MOTIVO PER CUI E' NATA ADESSO.
#      Il 07/09 Claudio ha aperto il conto 50504400 per il terminale da
#      backtest. Tutte le misure di casa vengono da un conto HEDGING
#      (CLAUDE.md r.174). Su un conto NETTING le posizioni si FONDONO
#      invece di convivere, e ogni EA a due gambe (PostNews con l'OCO,
#      il DAX con InpMaxPosSimbolo) si comporterebbe in modo diverso.
#      Un backtest su un conto netting NON riprodurrebbe le nostre
#      ancore -- e non sapremmo se la colpa e' della macchina nuova o
#      del tipo di conto.
#
#  DOVE GUARDA: <cartella dati>\logs\*.log -- che e' il GIORNALE del
#  terminale, NON MQL5\Logs (quello e' la scheda Esperti). E' una
#  distinzione che in casa si e' gia' pagata.
#
#  ATTENZIONE, IL LIMITE, DICHIARATO: si legge quello che il terminale
#  ha SCRITTO. Se una cartella non ha giornali recenti (terminale mai
#  avviato, o log ruotati) la riga lo dice e non inventa. E "modo di
#  margine NON TROVATO" vuol dire non trovato nel testo: NON vuol dire
#  netting.
# =====================================================================

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
Write-Host "=== QUALE CONTO STA IN QUALE CARTELLA DATI ==="
Write-Host ("data lettura: " + (Get-Date -Format "yyyy-MM-dd HH:mm:ss") + "  (ora locale)")
Write-Host "letto dal GIORNALE del terminale (<dati>\logs), non da una tabella scritta a mano."
if(-not (Test-Path $root)){ Write-Host "NESSUNA cartella MetaQuotes\Terminal"; exit 1 }

$cart = @(Get-ChildItem $root -Directory -ErrorAction SilentlyContinue | Where-Object { Test-Path (Join-Path $_.FullName "MQL5") })
Write-Host ("cartelle dati: " + $cart.Count)

foreach($d in $cart){
  Write-Host ""
  Write-Host ("=== CARTELLA " + $d.Name)
  $orig = Join-Path $d.FullName "origin.txt"
  if(Test-Path -LiteralPath $orig){
    $o = Leggi-Condiviso $orig
    if($o){ Write-Host ("    programma : " + ($o -replace "[^\x20-\x7E]","").Trim()) }
  }

  $dirLog = Join-Path $d.FullName "logs"
  if(-not (Test-Path -LiteralPath $dirLog)){ Write-Host "    NESSUN giornale (<dati>\logs non esiste): terminale mai avviato?"; continue }
  $files = @(Get-ChildItem -LiteralPath $dirLog -Filter *.log -ErrorAction SilentlyContinue |
             Sort-Object LastWriteTime -Descending | Select-Object -First 5)
  Write-Host ("    giornali letti: " + $files.Count)
  if($files.Count -eq 0){ Write-Host "    NESSUN giornale recente: non si conclude niente su questa cartella."; continue }

  $conti = @{}; $margine = ""; $azienda = ""
  foreach($f in $files){
    $t = Leggi-Condiviso $f.FullName
    if(-not $t){ continue }
    # riga tipica di MT5: "... '50503392': login on BCMMarkets-Server ..."
    foreach($m in [regex]::Matches($t, "'(\d{6,12})'\s*:\s*(?:login|authorized|connesso|previous)[^\r\n]*")){
      $k = $m.Groups[1].Value
      $conti[$k] = $m.Value.Trim()
    }
    if(-not $margine){
      $mm = [regex]::Match($t, "(?i)\b(hedg\w*|nett\w*)\b")
      if($mm.Success){ $margine = $mm.Groups[1].Value }
    }
    if(-not $azienda){
      $ma = [regex]::Match($t, "(?im)^.*\b(company|azienda|broker)\b\s*:?\s*(.+?)\s*$")
      if($ma.Success){ $azienda = $ma.Groups[2].Value.Trim() }
    }
  }

  if($conti.Count -eq 0){ Write-Host "    CONTO: NON TROVATO nei giornali recenti (non vuol dire che non ci sia)." }
  else{
    foreach($k in ($conti.Keys | Sort-Object)){
      Write-Host ("    CONTO " + $k)
      Write-Host ("        " + $conti[$k])
    }
    if($conti.Count -gt 1){ Write-Host "    ATTENZIONE: piu' di un conto in questa cartella -- il terminale ha cambiato login." }
  }
  if($margine){ Write-Host ("    modo di margine: " + $margine.ToUpper()) }
  else { Write-Host "    modo di margine: NON TROVATO nel testo (NON vuol dire netting)" }
  if($azienda){ Write-Host ("    azienda: " + $azienda) }
}

Write-Host ""
Write-Host "PROMEMORIA: tutte le misure di casa vengono da un conto HEDGING (CLAUDE.md r.174)."
Write-Host "Un terminale da backtest su conto NETTING non riprodurrebbe le ancore."
Write-Host "Questa riga LEGGE E STAMPA: non ha scritto, copiato o modificato niente."
exit 0
