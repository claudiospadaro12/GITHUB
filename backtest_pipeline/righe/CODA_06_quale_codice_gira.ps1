# =====================================================================
#  MARCATORE_CODA_06_QUALE_CODICE_GIRA_v1
#  RUNNER_SOLA_LETTURA
# ---------------------------------------------------------------------
#  COSA FA: apre la cartella MQL5\Experts di OGNI terminale e, per ogni
#  sorgente .mq5 che ci trova, stampa tre cose che lo identificano:
#    - la VERSIONE dichiarata (#property version)
#    - quante RIGHE ha
#    - se contiene il GUARDIAN (GuardiaIngresso / InpUsaGuardian)
#  Piu' la data dell'.ex5 compilato accanto, che dice quando e' stato
#  compilato l'ultima volta.
#  Non scrive, non copia, non cancella: STAMPA.
#
#  PERCHE' ESISTE
#  Nel repo lo stesso EA esiste in DUE alberi:
#    mql5\Experts\ABTG_PostNews.mq5             -> 666 righe, versione 1.10
#    mql5\Experts\standalone\ABTG_PostNews.mq5  -> 307 righe, versione 1.00
#  Non sono copie: sono programmi diversi. Quello dentro standalone non
#  ha il Guardian, non legge il calendario da Common e non fa l'autotest.
#  MT5 compila quello che sta in <dati>\MQL5\Experts: se non sappiamo
#  QUALE dei due e' stato copiato li', non sappiamo quale codice gira --
#  e ogni riga che leggiamo nel repo per spiegare un comportamento
#  potrebbe essere la riga sbagliata.
#
#  >>> LA VERSIONE E' UN DISCRIMINANTE SOLO A META'.
#      Su 8 EA i due alberi dichiarano versioni diverse (PostNews 1.10
#      contro 1.00, GoldenCross 2.00 contro 1.00, MaxMinNotte 1.11
#      contro 1.00...) e li' basta leggerla. Su 14 dicono entrambi
#      "1.00": li' il discriminante e' il GUARDIAN, che l'albero
#      standalone non ha per costruzione. Per questo se ne stampano
#      TRE, di indizi, e non uno.
#
#  LIMITE DICHIARATO: si legge il sorgente presente sul disco del
#  terminale. Se qualcuno ha compilato un .ex5 e poi ha sostituito il
#  .mq5, i due non corrispondono: per questo si stampa anche la data
#  dell'.ex5, cosi' lo scarto si vede.
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
Write-Host "=== QUALE CODICE GIRA DAVVERO -- sorgenti dentro MQL5\Experts ==="
Write-Host ("data lettura: " + (Get-Date -Format "yyyy-MM-dd HH:mm:ss") + "  (ora locale)")
if(-not (Test-Path $root)){ Write-Host "NESSUNA cartella MetaQuotes\Terminal"; exit 1 }

$cart = @(Get-ChildItem $root -Directory -ErrorAction SilentlyContinue | Where-Object { Test-Path (Join-Path $_.FullName "MQL5") })
Write-Host ("cartelle dati: " + $cart.Count)

foreach($d in $cart){
  Write-Host ""
  Write-Host ("=== CARTELLA " + $d.Name)
  $orig = Join-Path $d.FullName "origin.txt"
  if(Test-Path -LiteralPath $orig){
    $o = Leggi-Condiviso $orig
    if($o){ Write-Host ("    programma: " + ($o -replace "[^\x20-\x7E]","").Trim()) }
  }

  $dirE = Join-Path $d.FullName "MQL5\Experts"
  if(-not (Test-Path -LiteralPath $dirE)){ Write-Host "    nessuna cartella MQL5\Experts."; continue }
  $src = @(Get-ChildItem -LiteralPath $dirE -Filter *.mq5 -Recurse -ErrorAction SilentlyContinue)
  Write-Host ("    sorgenti .mq5 trovati: " + $src.Count)
  if($src.Count -eq 0){ continue }

  Write-Host ("    " + "NOME".PadRight(44) + "VER".PadRight(8) + "RIGHE".PadLeft(7) + "  GUARD  " + "COMPILATO IL")
  foreach($f in ($src | Sort-Object Name)){
    $t = Leggi-Condiviso $f.FullName
    $ver = "?"
    if($t){
      $m = [regex]::Match($t, '(?i)#property\s+version\s+"([^"]+)"')
      if($m.Success){ $ver = $m.Groups[1].Value }
    }
    $righe = 0
    if($t){ $righe = @($t -split "`r?`n").Count }
    $guard = "no"
    if($t -and ($t -match "GuardiaIngresso" -or $t -match "InpUsaGuardian")){ $guard = "SI" }
    $ex5 = [IO.Path]::ChangeExtension($f.FullName, ".ex5")
    $quando = "(nessun .ex5)"
    if(Test-Path -LiteralPath $ex5){
      $quando = (Get-Item -LiteralPath $ex5).LastWriteTime.ToString("yyyy-MM-dd HH:mm")
    }
    Write-Host ("    " + $f.Name.PadRight(44) + $ver.PadRight(8) + ("" + $righe).PadLeft(7) + "  " + $guard.PadRight(6) + " " + $quando)
  }

  # --- .ex5 senza sorgente accanto: girano, ma non sappiamo da quale codice
  $bin = @(Get-ChildItem -LiteralPath $dirE -Filter *.ex5 -Recurse -ErrorAction SilentlyContinue)
  $orfani = @()
  foreach($b in $bin){
    $mq = [IO.Path]::ChangeExtension($b.FullName, ".mq5")
    if(-not (Test-Path -LiteralPath $mq)){ $orfani += $b }
  }
  if($orfani.Count -gt 0){
    Write-Host ("    ATTENZIONE: " + $orfani.Count + " .ex5 SENZA il .mq5 accanto -- girano, ma il sorgente non e' qui:")
    foreach($b in ($orfani | Sort-Object Name)){
      Write-Host ("      " + $b.Name.PadRight(44) + $b.LastWriteTime.ToString("yyyy-MM-dd HH:mm"))
    }
  }
}

Write-Host ""
Write-Host "COME SI LEGGE: 'GUARD = no' su un EA che nel repo ce l'ha vuol dire albero standalone."
Write-Host "Un .ex5 piu' VECCHIO del .mq5 accanto vuol dire che il sorgente e' cambiato e nessuno ha ricompilato."
Write-Host "Questa riga LEGGE E STAMPA: non ha scritto, copiato o modificato niente."
exit 0
