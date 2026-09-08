# =====================================================================
#  MARCATORE_CODA_05_FOTO_FRESCA_v1
#  RUNNER_SOLA_LETTURA
# ---------------------------------------------------------------------
#  COSA FA: dice se la FOTO delle sedie (i file .chr) e' FRESCA oppure
#  VECCHIA, confrontando la data dei .chr con la data dell'ultimo log
#  scritto dal terminale. E stampa il CALENDARIO delle news che gli EA
#  leggono da Common\Files, riga per riga.
#  Non scrive, non copia, non cancella: STAMPA.
#
#  PERCHE' ESISTE -- una contraddizione misurata l'08/09/2026 alle 03:30
#  CODA_01 legge le sedie dai .chr. CODA_02 legge chi ha scritto nei log.
#  Sul terminale del conto reale le due cose NON dicono la stessa cosa:
#    - CODA_01: profilo attivo = 3 sedie, NESSUN Guardian;
#    - CODA_02: ABTG_Guardian ha scritto 464 righe, ultima alle 23:56.
#  Un EA che scrive nei log STA GIRANDO. Quindi o il Guardian non e' nei
#  .chr, o i .chr sono una FOTO SALVATA e non lo stato vivo.
#
#  >>> E' LA DOMANDA CHE CONTA PIU' DI TUTTE, perche' se i .chr sono
#      vecchi allora OGNI censimento fatto finora ha descritto il
#      terminale com'era l'ultima volta che il profilo e' stato salvato,
#      non com'e' adesso. Sette censimenti si leggerebbero diversamente.
#      MT5 riscrive i .chr quando il profilo viene salvato (cambio di
#      profilo, chiusura del terminale), NON a ogni tick: quindi la
#      vecchiaia della foto e' un fatto misurabile, e questa riga lo
#      misura invece di ragionarci sopra.
#
#  IL SECONDO PEZZO: il calendario del PostNews.
#  L'08/09 i log dicono che su USDJPY il calendario ha 3 righe e degli
#  UTILI, mentre su EURUSD e EURJPY il canarino e' ROSSO (si legge ma
#  per quel simbolo non c'e' niente). Il collaudo del 10/09 e' sulla
#  BCE, che e' un evento in EURO: se le righe utili stanno solo su
#  USDJPY, il collaudo non parte sui simboli giusti. Qui si legge il
#  file invece di dedurlo dai messaggi troncati.
#
#  LIMITE DICHIARATO: si stampa cio' che c'e' su disco adesso. Un .chr
#  fresco non garantisce che l'EA sia ATTIVO (potrebbe essere stato
#  tolto e il profilo non salvato): dice solo quando quella foto e'
#  stata scattata.
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

function Eta($t){
  if($null -eq $t){ return "?" }
  $h = [math]::Round(((Get-Date) - $t).TotalHours, 1)
  return ("" + $t.ToString("yyyy-MM-dd HH:mm") + "  (vecchia di " + $h + " ore)")
}

$adesso = Get-Date
$root = Join-Path $env:APPDATA "MetaQuotes\Terminal"
Write-Host "=== LA FOTO DELLE SEDIE E' FRESCA O VECCHIA? ==="
Write-Host ("data lettura: " + $adesso.ToString("yyyy-MM-dd HH:mm:ss") + "  (ora locale)")
Write-Host "confronto: data dei .chr  contro  data dell'ultimo log del terminale."
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

  # --- profilo attivo, come lo trova CODA_01
  $attivo = ""
  $cini = Join-Path $d.FullName "config\common.ini"
  if(Test-Path -LiteralPath $cini){
    $t = Leggi-Condiviso $cini
    $m = [regex]::Match($t, "(?im)^\s*ProfileLast\s*=\s*(.+?)\s*$")
    if($m.Success){ $attivo = $m.Groups[1].Value }
  }
  if(-not $attivo){ Write-Host "    PROFILO ATTIVO: non determinato -- salto il confronto."; continue }
  Write-Host ("    profilo attivo: '" + $attivo + "'")

  $dirP = Join-Path $d.FullName ("profiles\charts\" + $attivo)
  if(-not (Test-Path -LiteralPath $dirP)){ Write-Host "    la cartella del profilo attivo non esiste."; continue }
  $chr = @(Get-ChildItem -LiteralPath $dirP -Filter *.chr -ErrorAction SilentlyContinue)
  if($chr.Count -eq 0){ Write-Host "    nessun .chr nel profilo attivo."; continue }
  $piuNuovo = ($chr | Sort-Object LastWriteTime -Descending | Select-Object -First 1)
  $piuVecchio = ($chr | Sort-Object LastWriteTime | Select-Object -First 1)
  Write-Host ("    .chr: " + $chr.Count)
  Write-Host ("      il piu' RECENTE : " + (Eta $piuNuovo.LastWriteTime) + "   [" + $piuNuovo.Name + "]")
  Write-Host ("      il piu' VECCHIO : " + (Eta $piuVecchio.LastWriteTime) + "   [" + $piuVecchio.Name + "]")

  # --- ultimo log della scheda Esperti: dice se il terminale e' VIVO
  $ultimoLog = $null
  $dirL = Join-Path $d.FullName "MQL5\Logs"
  if(Test-Path -LiteralPath $dirL){
    $lf = @(Get-ChildItem -LiteralPath $dirL -Filter *.log -ErrorAction SilentlyContinue |
            Sort-Object LastWriteTime -Descending | Select-Object -First 1)
    if($lf.Count -gt 0){ $ultimoLog = $lf[0].LastWriteTime }
  }
  if($null -eq $ultimoLog){
    Write-Host "      ultimo log Esperti: NESSUNO -- non si conclude niente."
    continue
  }
  Write-Host ("      ultimo log Esperti: " + (Eta $ultimoLog))

  $divario = [math]::Round(($ultimoLog - $piuNuovo.LastWriteTime).TotalHours, 1)
  if($divario -lt 2){
    Write-Host ("      VERDETTO: FOTO FRESCA. Il profilo e' stato salvato quasi insieme all'ultimo log (divario " + $divario + " ore).")
  } elseif($divario -lt 48){
    Write-Host ("      VERDETTO: FOTO TIEPIDA. Il terminale ha scritto " + $divario + " ore DOPO l'ultimo salvataggio del profilo.")
    Write-Host "                Una sedia aggiunta o tolta in quelle ore NON si vede nei .chr."
  } else {
    Write-Host ("      VERDETTO: FOTO VECCHIA. Divario di " + $divario + " ore fra l'ultimo log e l'ultimo .chr salvato.")
    Write-Host "                I censimenti fatti sui .chr descrivono questo terminale com'era ALLORA."
  }
}

# =====================================================================
#  IL CALENDARIO DELLE NEWS, letto invece che dedotto
# =====================================================================
Write-Host ""
Write-Host "=== COMMON\FILES -- cosa leggono davvero gli EA ==="
$common = Join-Path $env:APPDATA "MetaQuotes\Terminal\Common\Files"
if(-not (Test-Path -LiteralPath $common)){
  Write-Host "    Common\Files non esiste."
} else {
  $ff = @(Get-ChildItem -LiteralPath $common -File -ErrorAction SilentlyContinue | Sort-Object Name)
  Write-Host ("    file: " + $ff.Count)
  foreach($f in $ff){
    $kb = [math]::Round($f.Length/1KB, 1)
    Write-Host ("      " + $f.Name.PadRight(40) + " " + ("" + $kb + " KB").PadLeft(12) + "   " + $f.LastWriteTime.ToString("yyyy-MM-dd HH:mm"))
  }
  Write-Host ""
  Write-Host "    --- CONTENUTO dei file che sembrano calendari (news/calend/event) ---"
  $cal = @($ff | Where-Object { $_.Name -match "(?i)news|calend|event" })
  if($cal.Count -eq 0){
    Write-Host "      NESSUN file col nome da calendario. Il PostNews legge un file che non c'e'."
  }
  foreach($f in $cal){
    Write-Host ""
    Write-Host ("      >>> " + $f.Name + "   (" + $f.LastWriteTime.ToString("yyyy-MM-dd HH:mm") + ")")
    $t = Leggi-Condiviso $f.FullName
    if(-not $t){ Write-Host "          (illeggibile o vuoto)"; continue }
    $righe = @($t -split "`r?`n" | Where-Object { $_.Trim() -ne "" })
    Write-Host ("          righe non vuote: " + $righe.Count)
    $n = 0
    foreach($r in $righe){
      $n++
      if($n -gt 30){ Write-Host "          ... (altre righe non stampate)"; break }
      Write-Host ("          | " + ($r -replace "[^\x20-\x7E]","").Trim())
    }
  }
}

Write-Host ""
Write-Host "PROMEMORIA: un .chr fresco dice quando la foto e' stata scattata, non che l'EA sia attivo."
Write-Host "Questa riga LEGGE E STAMPA: non ha scritto, copiato o modificato niente."
exit 0
