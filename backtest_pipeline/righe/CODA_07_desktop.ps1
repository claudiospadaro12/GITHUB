# =====================================================================
#  MARCATORE_CODA_07_DESKTOP_v1
#  RUNNER_SOLA_LETTURA
# ---------------------------------------------------------------------
#  COSA FA: guarda il DESKTOP del VPS e porta a Claude quello che ci
#  trova -- l'elenco completo (nome, dimensione, data) e il CONTENUTO
#  dei soli file dei NOSTRI referti, riconosciuti per nome.
#  Non scrive, non copia, non cancella, non apre niente che non sia
#  nostro: STAMPA.
#
#  PERCHE' ESISTE
#  Claudio, 08/09/2026, mentre guida: "anche i file che ci sono sul
#  desktop analizzali tu, io non ho tempo". Ma Claude NON vede il
#  Desktop del VPS: l'unico canale e' questa coda, che gira alle 03:30
#  e pubblica i referti sul repo. Quindi il Desktop glielo porta il
#  VPS, da solo, senza che Claudio mandi niente.
#
#  >>> IL LIMITE DI RISPETTO, ED E' UNA SCELTA, NON UNA DIMENTICANZA.
#      Di TUTTI i file si stampano solo nome, dimensione e data.
#      Il CONTENUTO si stampa SOLO se il nome corrisponde a uno dei
#      nostri modelli (pagella_, storico_, ABTG_, referto, ritardo,
#      CODA_, walkforward, *_console). Il Desktop di una persona non
#      e' una cartella di lavoro: quello che non e' nostro si conta e
#      non si legge.
#
#  LIMITE TECNICO DICHIARATO: un file grosso non viene stampato tutto
#  (tetto di righe per file e tetto complessivo), e lo si dice invece
#  di troncare in silenzio. I .zip non si aprono: si elencano.
# =====================================================================

$MAX_RIGHE_FILE  = 120     # righe stampate al massimo per file
$MAX_FILE_LETTI  = 25      # file di cui si stampa il contenuto
$MAX_KB_FILE     = 512     # oltre questa taglia si stampa solo la testa

$MODELLI = @(
  "pagella", "storico", "abtg_", "referto", "ritardo", "coda_",
  "walkforward", "console", "sonda", "censimento", "risultat"
)

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

function E-Nostro($nome){
  $n = $nome.ToLowerInvariant()
  foreach($m in $MODELLI){ if($n.Contains($m)){ return $true } }
  return $false
}

$dsk = [Environment]::GetFolderPath("Desktop")
Write-Host "=== IL DESKTOP DEL VPS, PORTATO A CLAUDE ==="
Write-Host ("data lettura: " + (Get-Date -Format "yyyy-MM-dd HH:mm:ss") + "  (ora locale)")
Write-Host ("cartella: " + $dsk)
if(-not (Test-Path -LiteralPath $dsk)){ Write-Host "Desktop non trovato."; exit 1 }

# ---------- 1. L'INVENTARIO COMPLETO (nomi, taglie, date) ----------
$tutti = @(Get-ChildItem -LiteralPath $dsk -Recurse -File -ErrorAction SilentlyContinue)
$cart  = @(Get-ChildItem -LiteralPath $dsk -Directory -ErrorAction SilentlyContinue)
Write-Host ""
Write-Host ("--- INVENTARIO: " + $tutti.Count + " file in " + ($cart.Count) + " cartelle ---")
Write-Host ("    " + "NOME".PadRight(52) + "KB".PadLeft(10) + "   MODIFICATO")
foreach($f in ($tutti | Sort-Object LastWriteTime -Descending)){
  $rel = $f.FullName.Substring($dsk.Length).TrimStart("\")
  $kb  = [math]::Round($f.Length/1KB,1)
  $tag = ""
  if(E-Nostro $f.Name){ $tag = "  <== nostro" }
  Write-Host ("    " + $rel.PadRight(52) + ("" + $kb).PadLeft(10) + "   " + $f.LastWriteTime.ToString("yyyy-MM-dd HH:mm") + $tag)
}

# ---------- 2. IL CONTENUTO, SOLO DEI NOSTRI ----------
$nostri = @($tutti | Where-Object { (E-Nostro $_.Name) -and $_.Extension -ne ".zip" } |
           Sort-Object LastWriteTime -Descending)
Write-Host ""
Write-Host ("--- CONTENUTO dei file NOSTRI (non-zip): " + $nostri.Count + " ---")
if($nostri.Count -eq 0){
  Write-Host "    nessun file col nome dei nostri referti. Niente da leggere."
}
$letti = 0
foreach($f in $nostri){
  if($letti -ge $MAX_FILE_LETTI){
    Write-Host ("    ... altri " + ($nostri.Count - $letti) + " file NON stampati (tetto di " + $MAX_FILE_LETTI + ").")
    break
  }
  $letti++
  $kb = [math]::Round($f.Length/1KB,1)
  Write-Host ""
  Write-Host (">>> " + $f.FullName.Substring($dsk.Length).TrimStart("\") + "   (" + $kb + " KB, " + $f.LastWriteTime.ToString("yyyy-MM-dd HH:mm") + ")")
  if($kb -gt $MAX_KB_FILE){
    Write-Host ("    (file grosso: stampo solo le prime " + $MAX_RIGHE_FILE + " righe)")
  }
  $t = Leggi-Condiviso $f.FullName
  if(-not $t){ Write-Host "    (illeggibile o vuoto)"; continue }
  $righe = @($t -split "`r?`n")
  $n = 0
  foreach($r in $righe){
    $n++
    if($n -gt $MAX_RIGHE_FILE){
      Write-Host ("    ... " + ($righe.Count - $MAX_RIGHE_FILE) + " righe NON stampate (tetto per file).")
      break
    }
    Write-Host ("    | " + ($r -replace "[^\x20-\x7E]","").TrimEnd())
  }
}

# ---------- 3. GLI ZIP: si elencano, non si aprono ----------
$zip = @($tutti | Where-Object { $_.Extension -eq ".zip" } | Sort-Object LastWriteTime -Descending)
Write-Host ""
Write-Host ("--- ZIP sul Desktop: " + $zip.Count + " (elencati, NON aperti) ---")
foreach($z in $zip){
  Write-Host ("    " + $z.Name.PadRight(52) + ("" + [math]::Round($z.Length/1KB,1)).PadLeft(10) + " KB   " + $z.LastWriteTime.ToString("yyyy-MM-dd HH:mm"))
}

Write-Host ""
Write-Host "NOTA: di tutti i file si stampano nome, taglia e data; il CONTENUTO solo dei nostri."
Write-Host "Questa riga LEGGE E STAMPA: non ha scritto, copiato o modificato niente."
exit 0
