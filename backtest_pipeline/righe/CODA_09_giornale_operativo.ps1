# =====================================================================
#  MARCATORE_CODA_09_GIORNALE_OPERATIVO_v1
#  RUNNER_SOLA_LETTURA
# ---------------------------------------------------------------------
#  COSA FA: per OGNI conto, e quindi anche per quello che non ha il
#  TradeExporter, estrae dal giornale le righe di ORDINE e di DEAL degli
#  ULTIMI DUE GIORNI, le conta e le stampa, con l'ultima riga del
#  Guardian (equita', perdita del giorno, drawdown totale).
#  Non scrive, non copia, non cancella: STAMPA.
#
#  PERCHE' ESISTE -- Claudio, 08/09/2026 sera:
#     "VOGLIO CHE MONITORI AUTOMATICAMENTE IL CONTO REALE COME FAI CON
#      GLI ALTRI."
#  Due conti su tre hanno il TradeExporter e producono un CSV che la
#  pagella legge da sola. Il TERZO no: e' l'unico con soldi veri, ed e'
#  l'unico su cui non arriva un dato automatico. Stasera, per quel
#  buco, ho dedotto invece di leggere -- e ho dedotto male.
#
#  >>> PERCHE' DUE GIORNI E NON UNO
#      Il runner gira alle 03:30: il log del giorno corrente e' appena
#      nato (spesso 0 KB) e il giorno COMPLETO e' quello PRECEDENTE.
#      Leggerne uno solo, e chiamarlo "oggi", e' il difetto di CLASSE
#      162, pagato l'08/09. Qui si leggono gli ultimi DUE e si stampa la
#      DATA di ciascuno, cosi' chi legge sa sempre di che giorno parla.
#
#  >>> E SI LEGGE IN CONDIVISIONE (classe 163, pagata la stessa sera)
#      Il log del giorno corrente e' APERTO dal terminale vivo:
#      ReadAllBytes e Get-Content falliscono. Leggi-Condiviso apre in
#      FileShare::ReadWrite, ed e' l'unico modo.
#
#  LIMITE DICHIARATO: il giornale NON e' un estratto conto. Da qui si
#  legge QUANTE operazioni e QUALI righe, non il P&L al centesimo. Il
#  P&L vero lo da' un TradeExporter (che su un conto manca) o l'estratto
#  conto del broker. Questa riga toglie la CECITA', non sostituisce la
#  contabilita'.
# =====================================================================

$MAX_RIGHE = 40      # righe di ordine stampate al massimo, per file

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
Write-Host "=== IL GIORNALE OPERATIVO DI OGNI CONTO -- ultimi due giorni ==="
Write-Host ("data lettura: " + (Get-Date -Format "yyyy-MM-dd HH:mm:ss") + "  (ora locale)")
Write-Host "NB: alle 03:30 il giorno COMPLETO e' quello PRECEDENTE. La data di ogni"
Write-Host "    blocco e' stampata: si legge quella, non si dice 'oggi'."
if(-not (Test-Path $root)){ Write-Host "NESSUNA cartella MetaQuotes\Terminal"; exit 1 }

$cart = @(Get-ChildItem $root -Directory -ErrorAction SilentlyContinue | Where-Object { Test-Path (Join-Path $_.FullName "MQL5") })
Write-Host ("cartelle dati: " + $cart.Count)

foreach($d in $cart){
  Write-Host ""
  Write-Host "====================================================================="
  $orig = Join-Path $d.FullName "origin.txt"
  $prog = "(programma sconosciuto)"
  if(Test-Path -LiteralPath $orig){
    $o = Leggi-Condiviso $orig
    if($o){ $prog = ($o -replace "[^\x20-\x7E]","").Trim() }
  }
  Write-Host ("=== " + $prog)

  # --- il conto, dal giornale del terminale
  $conti = @{}
  $dirLog = Join-Path $d.FullName "logs"
  if(Test-Path -LiteralPath $dirLog){
    foreach($f in @(Get-ChildItem -LiteralPath $dirLog -Filter *.log -ErrorAction SilentlyContinue |
                    Sort-Object LastWriteTime -Descending | Select-Object -First 3)){
      $t = Leggi-Condiviso $f.FullName
      if(-not $t){ continue }
      foreach($m in [regex]::Matches($t, "'(\d{6,12})'\s*:\s*(?:login|authorized|connesso|previous)")){
        $conti[$m.Groups[1].Value] = 1
      }
    }
  }
  if($conti.Count -gt 0){ Write-Host ("=== conto: " + (($conti.Keys | Sort-Object) -join ", ")) }
  else { Write-Host "=== conto: NON TROVATO nei giornali recenti" }
  Write-Host "====================================================================="

  # --- gli ultimi DUE giorni della scheda Esperti
  $dirE = Join-Path $d.FullName "MQL5\Logs"
  if(-not (Test-Path -LiteralPath $dirE)){ Write-Host "    nessuna cartella MQL5\Logs."; continue }
  $files = @(Get-ChildItem -LiteralPath $dirE -Filter *.log -ErrorAction SilentlyContinue |
             Sort-Object Name -Descending | Select-Object -First 2)
  if($files.Count -eq 0){ Write-Host "    nessun log."; continue }

  foreach($f in ($files | Sort-Object Name)){
    $giorno = [IO.Path]::GetFileNameWithoutExtension($f.Name)
    $kb = [math]::Round($f.Length/1KB,1)
    Write-Host ""
    Write-Host ("--- GIORNO " + $giorno + "   (" + $kb + " KB, ultima scrittura " + $f.LastWriteTime.ToString("yyyy-MM-dd HH:mm") + ") ---")
    if($kb -lt 1){
      Write-Host "    file quasi vuoto: questo giorno e' APPENA COMINCIATO, non e' un giorno senza operazioni."
    }
    $t = Leggi-Condiviso $f.FullName
    if(-not $t){ Write-Host "    ILLEGGIBILE"; continue }
    $ln = @($t -split "`r?`n" | Where-Object { $_.Trim() -ne "" })
    Write-Host ("    righe totali: " + $ln.Count)

    $ord = @($ln | Where-Object {
      ($_ -match "(?i)(buy|sell|deal #|order #|position|market|instant|filled|done|pendente|ingresso)") -and
      ($_ -notmatch "(?i)avviato|started|GUARDIAN|SPREADLOG|SLIPLOG|CONFIG IN USO")
    })
    Write-Host ("    RIGHE DI ORDINE / DEAL: " + $ord.Count)
    $n = 0
    foreach($r in $ord){
      $n++
      if($n -gt $MAX_RIGHE){ Write-Host ("      ... altre " + ($ord.Count - $MAX_RIGHE) + " righe non stampate (tetto)."); break }
      Write-Host ("      " + ($r -replace "[^\x20-\x7E]","").Trim())
    }
    if($ord.Count -eq 0 -and $kb -ge 1){
      Write-Host "      nessuna riga di ordine in un log NON vuoto: questo giorno il conto NON ha operato."
    }

    $gu = @($ln | Where-Object { $_ -match "GUARDIAN" })
    if($gu.Count -gt 0){
      Write-Host ("    GUARDIAN, ultima riga del giorno:")
      Write-Host ("      " + (($gu[-1]) -replace "[^\x20-\x7E]","").Trim())
    } else {
      Write-Host "    GUARDIAN: nessuna riga in questo giorno."
    }
  }
}

Write-Host ""
Write-Host "COME SI LEGGE: 'RIGHE DI ORDINE/DEAL = 0' su un log NON vuoto vuol dire"
Write-Host "che quel giorno il conto non ha operato. Su un log quasi vuoto NON vuol"
Write-Host "dire niente: il giorno e' appena cominciato (classe 162)."
Write-Host "Il giornale dice QUANTE operazioni, non il P&L: quello lo da' il"
Write-Host "TradeExporter o l'estratto conto del broker."
Write-Host "Questa riga LEGGE E STAMPA: non ha scritto, copiato o modificato niente."
exit 0
