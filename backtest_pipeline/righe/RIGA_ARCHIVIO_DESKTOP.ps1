# =====================================================================
#  MARCATORE_RIGA_ARCHIVIO_DESKTOP_v1
#  RIGA_ARCHIVIO_DESKTOP.ps1 -- 19/09/2026
#
#  RICHIESTA DI CLAUDIO (testuale, 19/09/2026):
#    "MANDAMI LA STRINGA X SISTEMARE IL DESKTOP VPS. E' STRAPIENO ED OGNI
#     CARTELLA CHE SI CREA DEVE ENTRARE DIRETTAMENTE NELLA CARTELLA
#     ARCHIVIO. LASCIA FUORI DA QUESTA CARTELLA LE ALTRE ICONE."
#
#  COSA FA, in una frase: SPOSTA le CARTELLE del Desktop dentro
#  Desktop\ARCHIVIO\<data-della-cartella>\, e NON TOCCA NIENT'ALTRO.
#
#  COSA NON FA, MAI (ed e' la meta' che conta):
#    - non CANCELLA niente: non esiste un Remove-Item su roba di Claudio
#      in questo file. Lo spazio sul Desktop si libera perche' la roba si
#      sposta, non perche' sparisce;
#    - non tocca NESSUN FILE: .lnk, .url, .png, .zip, .txt, .xlsx restano
#      dove sono. Le icone del Desktop restano icone del Desktop;
#    - non apre, non chiude e non tocca nessun terminale MT5, nessun
#      preset, nessun EA, nessun grafico. Non guarda nemmeno se sono
#      aperti, perche' non ha niente a che farci;
#    - non crea nessuna attivita' pianificata: si rilancia a mano.
#
#  LE SEI GUARDIE, e ognuna ha un perche' misurato:
#   1) RICORSIONE: la cartella ARCHIVIO non si sposta dentro se stessa, e
#      niente che stia gia' dentro ARCHIVIO viene riguardato. Doppio
#      controllo: nell'elenco (solo il PRIMO livello del Desktop) e sulla
#      singola mossa (la destinazione non puo' stare dentro l'origine).
#   2) ROUND A META': una cartella scritta da meno di -OreFerme ore
#      (default 6) NON si tocca. Il runner crea Desktop\ROUND_xxx\, la
#      riempie per ore e poi la zippa: spostarla a meta' rompe la
#      raccolta e Claudio non trova piu' lo zip. Per questo "direttamente"
#      diventa "dopo sei ore".
#   3) DESKTOP GIUSTO: il percorso si RICAVA (GetFolderPath), non si
#      accetta da fuori -- non esiste nessun parametro per dirgli su che
#      cartella lavorare. Poi si verifica che sia dentro il profilo
#      dell'utente corrente, che si chiami Desktop, e che non contenga
#      nessuna delle parole delle piattaforme (MetaQuotes, Terminal,
#      BCM..., MT5_Backtest, Pepperstone, Tickmill, Program Files).
#   4) ATTIVITA' PIANIFICATE: una cartella da cui parte un'attivita'
#      pianificata NON si archivia. NON E' IPOTETICO: il riordino del
#      16/09/2026 ha spostato in archivio la cartella del Desktop da cui
#      parte ABTG_AggiornaNews delle 07:20, e da quel giorno l'attivita'
#      esce 4294770688 invece di 0 (letto in
#      coda/referti/CODA_11_canali_e_attivita_2026091[6789]*.log). Se
#      l'elenco delle attivita' non si riesce a leggere, lo script SI
#      RIFIUTA di spostare: una guardia che non sa non diventa neutra.
#   5) GIUNZIONI: una cartella che e' un collegamento/giunzione
#      (ReparsePoint) si salta: dietro ci puo' essere qualsiasi cosa.
#   6) GEMELLI: le cartelle-strumento degli altri script di riordino
#      (ABTG_ORDINE_LOG, ARCHIVIO_TEST, ...) non si spostano, altrimenti
#      il loro -Annulla non trova piu' il proprio log.
#
#  SICUREZZE ereditate dai gemelli (riordina_desktop.ps1 del 14/08 e
#  archivia_test_desktop.ps1 del 23/08) -- ci sono TUTTE:
#    - ANTEPRIMA di default: senza -Esegui non muove niente;
#    - LOG CSV Origine,Destinazione di ogni spostamento riuscito;
#    - -Annulla: rilegge l'ultimo log non vuoto e rimette tutto com'era;
#    - try/catch per cartella: una bloccata non ammazza il giro;
#    - il referto si scrive SEMPRE, anche a giro vuoto, con la riga data:;
#    - niente -Force sulla destinazione: se il nome esiste gia' si
#      rinomina, non si sovrascrive.
#
#  USO:
#    powershell -ExecutionPolicy Bypass -File .\RIGA_ARCHIVIO_DESKTOP.ps1
#        -> ANTEPRIMA: dice cosa farebbe, non muove niente
#    ... -File .\RIGA_ARCHIVIO_DESKTOP.ps1 -Esegui
#        -> sposta davvero e scrive il log
#    ... -File .\RIGA_ARCHIVIO_DESKTOP.ps1 -Annulla
#        -> rimette tutto com'era
#    -OreFerme N        cambia la soglia di freschezza (default 6)
#    -AncheTematiche    include anche le cartelle tematiche di Claudio
#                       (EASYTREND, PIANO DI TRADING, ...) che per
#                       decisione del 14/08 non si toccano mai: da usare
#                       SOLO se lo chiede lui, esplicitamente.
# =====================================================================
param(
  [switch]$Esegui,
  [switch]$Annulla,
  [int]$OreFerme = 6,
  [switch]$AncheTematiche,
  [switch]$IgnoraAttivita
)
$ErrorActionPreference = "Continue"
$INV = [System.Globalization.CultureInfo]::InvariantCulture
$ORD = [System.StringComparison]::OrdinalIgnoreCase

function Muori($msg){
  Write-Host ""
  Write-Host ("RIFIUTO: " + $msg) -ForegroundColor Red
  Write-Host "Non ho spostato niente." -ForegroundColor Red
  exit 1
}

# ---------------------------------------------------------------------
# GUARDIA 3 -- IL DESKTOP GIUSTO, e nessun modo di dirgli un altro posto
# ---------------------------------------------------------------------
$Desktop = [Environment]::GetFolderPath("Desktop")
if([string]::IsNullOrWhiteSpace($Desktop)){ Muori "non riesco a ricavare il percorso del Desktop" }
$Desktop = [IO.Path]::GetFullPath($Desktop).TrimEnd("\")
if(-not (Test-Path -LiteralPath $Desktop -PathType Container)){ Muori ("il Desktop ricavato non esiste: " + $Desktop) }
if((Split-Path -Leaf $Desktop) -ne "Desktop"){ Muori ("il percorso ricavato non finisce in \Desktop: " + $Desktop) }
$prof = ""
if($env:USERPROFILE){ $prof = [IO.Path]::GetFullPath($env:USERPROFILE).TrimEnd("\") }
if(-not $prof){ Muori "USERPROFILE vuoto: non posso dimostrare che quel Desktop e' dell'utente corrente" }
if(-not $Desktop.StartsWith(($prof + "\"), $ORD)){
  Muori ("il Desktop (" + $Desktop + ") non sta dentro il profilo dell'utente corrente (" + $prof + "): VIETATO")
}
# nessuna di queste parole puo' comparire nel percorso su cui lavoro:
# sono le piattaforme e i terminali, che questa riga non tocca mai.
$PAROLE_VIETATE = @("METAQUOTES","TERMINAL","BCM_REALE","BCM MARKETS","MT5_BACKTEST","PEPPERSTONE","TICKMILL","PROGRAM FILES","\ABTG","REPORT_SCHEDULER")
$dskU = $Desktop.ToUpperInvariant()
foreach($k in $PAROLE_VIETATE){
  if($dskU.Contains($k)){ Muori ("il percorso di lavoro contiene '" + $k + "': e' roba di una piattaforma, VIETATO toccarla") }
}

$Arch   = Join-Path $Desktop "ARCHIVIO"
$LogDir = Join-Path $Arch "_log"
$stamp  = (Get-Date).ToString("yyyy-MM-dd_HHmmss", $INV)
$archU  = $Arch.ToUpperInvariant()

if((Test-Path -LiteralPath $Arch) -and -not (Test-Path -LiteralPath $Arch -PathType Container)){
  Muori ("esiste un FILE che si chiama ARCHIVIO sul Desktop: rinominalo a mano, non lo tocco io (" + $Arch + ")")
}

function NomeSenzaCollisione($cartella, $base, $coda){
  $cand = Join-Path $cartella ($base + $coda)
  $k = 0
  while(Test-Path -LiteralPath $cand){
    $k++
    $cand = Join-Path $cartella ($base + "_" + $k + $coda)
  }
  return $cand
}

# ---------------------------------------------------------------------
# -Annulla: rilegge l'ultimo log NON VUOTO e rimette tutto com'era
# ---------------------------------------------------------------------
if($Annulla){
  $ultimo = Get-ChildItem -LiteralPath $LogDir -Filter "archivio_desktop_*.csv" -ErrorAction SilentlyContinue |
            Sort-Object LastWriteTime -Descending |
            Where-Object { @(Import-Csv -LiteralPath $_.FullName -ErrorAction SilentlyContinue).Count -gt 0 } |
            Select-Object -First 1
  $fileA = NomeSenzaCollisione $Desktop "annulla_archivio_desktop" ("_" + $stamp + ".txt")
  if(-not $ultimo){
    Write-Host "Nessun log di archiviazione da annullare (o sono tutti vuoti / gia' usati)." -ForegroundColor Yellow
    Set-Content -LiteralPath $fileA -Value @(
      "ESITO ANNULLAMENTO archivio_desktop",
      ("data: " + (Get-Date).ToString("yyyy.MM.dd HH:mm:ss", $INV)),
      "Nessun log da annullare.") -Encoding UTF8
    Write-Host ("Referto: " + $fileA) -ForegroundColor Gray
    exit 0
  }
  Write-Host ("ANNULLO usando " + $ultimo.Name) -ForegroundColor Cyan
  $n = 0; $ko = 0
  $rilievi = New-Object System.Collections.ArrayList
  foreach($r in (Import-Csv -LiteralPath $ultimo.FullName)){
    try{
      if(-not (Test-Path -LiteralPath $r.Destinazione)){ throw "non e' piu' dove l'avevo messa (spostata a mano dopo il giro?)" }
      if(Test-Path -LiteralPath $r.Origine){ throw "al posto di origine c'e' di nuovo qualcosa: NON annido dentro, va risolto a mano" }
      $padre = Split-Path -Parent $r.Origine
      if(-not (Test-Path -LiteralPath $padre)){ New-Item -ItemType Directory -Force -Path $padre | Out-Null }
      Move-Item -LiteralPath $r.Destinazione -Destination $r.Origine -ErrorAction Stop
      $n++
    } catch {
      $m = "  NON rimessa: " + $r.Destinazione + "  --  " + $_.Exception.Message
      Write-Host $m -ForegroundColor Yellow
      [void]$rilievi.Add($m)
      $ko++
    }
  }
  $usato = NomeSenzaCollisione $ultimo.DirectoryName ("usato_" + [IO.Path]::GetFileNameWithoutExtension($ultimo.Name)) ".csv"
  Move-Item -LiteralPath $ultimo.FullName -Destination $usato -ErrorAction SilentlyContinue
  $righeA = New-Object System.Collections.ArrayList
  [void]$righeA.Add("ESITO ANNULLAMENTO archivio_desktop")
  [void]$righeA.Add("data: " + (Get-Date).ToString("yyyy.MM.dd HH:mm:ss", $INV))
  [void]$righeA.Add("log usato: " + $ultimo.Name)
  [void]$righeA.Add("rimesse a posto: " + $n + "   NON rimesse: " + $ko)
  foreach($m in $rilievi){ [void]$righeA.Add($m) }
  Set-Content -LiteralPath $fileA -Value $righeA -Encoding UTF8
  Write-Host ("Rimesse a posto: " + $n + "   NON rimesse: " + $ko) -ForegroundColor White
  Write-Host ("Referto: " + $fileA) -ForegroundColor Gray
  if($ko -gt 0){ Write-Host "ESITO: PARZIALE -- leggi le righe gialle e il referto." -ForegroundColor Red; exit 1 }
  Write-Host "ESITO: OK" -ForegroundColor Green
  exit 0
}

# ---------------------------------------------------------------------
# GUARDIA 4 -- le cartelle usate dalle ATTIVITA' PIANIFICATE
# ---------------------------------------------------------------------
$testoAttivita = ""
$attivitaLette = $false
try{
  $tasks = @(Get-ScheduledTask -ErrorAction Stop)
  foreach($t in $tasks){
    foreach($a in @($t.Actions)){ $testoAttivita = $testoAttivita + ($a | Out-String) + "`n" }
  }
  if($tasks.Count -gt 0){ $attivitaLette = $true }
} catch {
  $attivitaLette = $false
}
if(-not $attivitaLette){
  try{
    $q = (& schtasks.exe /query /fo LIST /v 2>$null | Out-String)
    if($q -and $q.Length -gt 200){ $testoAttivita = $q; $attivitaLette = $true }
  } catch {
    $attivitaLette = $false
  }
}
if(-not $attivitaLette){
  if($IgnoraAttivita){
    Write-Host "ATTENZIONE: non ho potuto leggere le attivita' pianificate, e mi hai detto -IgnoraAttivita: vado avanti SENZA quella guardia." -ForegroundColor Yellow
  } else {
    Muori "non riesco a leggere le attivita' pianificate, quindi non so quale cartella e' l'input di un'attivita'. Il 16/09 un riordino ha spostato la cartella di ABTG_AggiornaNews e l'attivita' delle 07:20 e' morta. Rilancia da una console con i diritti giusti, oppure aggiungi -IgnoraAttivita se sai quello che fai."
  }
}
$testoAttivitaU = $testoAttivita.ToUpperInvariant()

# ---------------------------------------------------------------------
# le liste di esclusione
# ---------------------------------------------------------------------
# cartelle-strumento: nostre e dei gemelli. Spostare il log di un gemello
# gli ammazza il -Annulla (lui lo cerca sul Desktop, non in archivio).
$MaiPerNome = @(
  "ARCHIVIO","ABTG_RISULTATI","ABTG_ZIP","ABTG_DOCUMENTI","ABTG_VARIE","ABTG_ORDINE_LOG",
  "ARCHIVIO_DESKTOP","ARCHIVIO_TEST"
)
# le tematiche di Claudio: decisione dichiarata il 14/08 in
# riordina_desktop.ps1 (righe 15-20), "sono gia' ordine, non si spostano
# MAI". Uno script nuovo non ribalta in silenzio una decisione vecchia.
$MaiPerPrefisso = @(
  "EASYTREND","INDICATORI","BREAKOUT","NOTTE","PROCE","ALTA VELOCIT",
  "NASDAQ APERTU","DAX E NASD","PIANO DI TRADI","FILE WORD","FILE CHE SCARICO",
  "GITHUB"
)

function UltimaScritturaEPeso($cartella){
  # la data della cartella NON basta: scrivere dentro una sottocartella
  # non aggiorna il LastWriteTime della radice. Si guarda tutto, una volta
  # sola, e si riporta anche il peso (cosi' non si scandisce due volte).
  $t  = $cartella.LastWriteTime
  $kb = 0.0
  $n  = 0
  foreach($f in @(Get-ChildItem -LiteralPath $cartella.FullName -Recurse -Force -ErrorAction SilentlyContinue)){
    if($f.LastWriteTime -gt $t){ $t = $f.LastWriteTime }
    if(-not $f.PSIsContainer){ $kb = $kb + ($f.Length / 1024.0); $n++ }
  }
  return [pscustomobject]@{ Ultima = $t; KB = $kb; File = $n }
}

# ---------------------------------------------------------------------
# IL PIANO -- si guarda SOLO il primo livello del Desktop (guardia 1)
# ---------------------------------------------------------------------
$piano    = New-Object System.Collections.ArrayList
$saltate  = New-Object System.Collections.ArrayList
$voci     = @(Get-ChildItem -LiteralPath $Desktop -Directory -Force -ErrorAction SilentlyContinue)
$adesso   = Get-Date

foreach($v in $voci){
  $nomeU = $v.Name.ToUpperInvariant()
  $pienoU = $v.FullName.ToUpperInvariant()

  # GUARDIA 1: ARCHIVIO e tutto cio' che ci sta dentro
  if($pienoU -eq $archU -or $pienoU.StartsWith(($archU + "\"), $ORD)){
    [void]$saltate.Add([pscustomobject]@{ Nome=$v.Name; Perche="e' la cartella ARCHIVIO (o ci sta gia' dentro)" })
    continue
  }
  # GUARDIA 5: giunzioni e collegamenti di cartella
  if(($v.Attributes -band [IO.FileAttributes]::ReparsePoint) -ne 0){
    [void]$saltate.Add([pscustomobject]@{ Nome=$v.Name; Perche="e' una giunzione/collegamento, non una cartella vera" })
    continue
  }
  if(($v.Attributes -band [IO.FileAttributes]::System) -ne 0){
    [void]$saltate.Add([pscustomobject]@{ Nome=$v.Name; Perche="e' una cartella di SISTEMA" })
    continue
  }
  # GUARDIA 6: strumenti nostri e dei gemelli
  $ferma = $false
  foreach($m in $MaiPerNome){ if([string]::Equals($v.Name, $m, $ORD)){ $ferma = $true; break } }
  if($ferma){
    [void]$saltate.Add([pscustomobject]@{ Nome=$v.Name; Perche="cartella-strumento (nostra o di un gemello): il suo log/annulla la cerca sul Desktop" })
    continue
  }
  if(-not $AncheTematiche){
    foreach($p in $MaiPerPrefisso){
      if($nomeU.StartsWith($p, $ORD)){ $ferma = $true; break }
    }
    if($ferma){
      [void]$saltate.Add([pscustomobject]@{ Nome=$v.Name; Perche="cartella tematica tua: decisione del 14/08, non si sposta (serve -AncheTematiche)" })
      continue
    }
  }
  # GUARDIA 4: e' l'input di un'attivita' pianificata?
  if($attivitaLette -and $testoAttivitaU.Contains($pienoU)){
    [void]$saltate.Add([pscustomobject]@{ Nome=$v.Name; Perche="DA QUI PARTE UN'ATTIVITA' PIANIFICATA: spostarla la rompe (come il 16/09 con ABTG_AggiornaNews)" })
    continue
  }

  $m = UltimaScritturaEPeso $v
  # GUARDIA 2: il round a meta'
  $ore = (New-TimeSpan -Start $m.Ultima -End $adesso).TotalHours
  if($ore -lt $OreFerme){
    [void]$saltate.Add([pscustomobject]@{ Nome=$v.Name; Perche=("FRESCA: scritta " + $m.Ultima.ToString("yyyy-MM-dd HH:mm:ss", $INV) + ", meno di " + $OreFerme + " ore fa -- potrebbe essere un round in corso") })
    continue
  }
  [void]$piano.Add([pscustomobject]@{
    Nome    = $v.Name
    Origine = $v.FullName
    Giorno  = $m.Ultima.ToString("yyyy-MM-dd", $INV)
    Ultima  = $m.Ultima
    KB      = $m.KB
    File    = $m.File
  })
}

$mbTot = 0.0
foreach($p in $piano){ $mbTot = $mbTot + ($p.KB / 1024.0) }

Write-Host ""
Write-Host "=== ARCHIVIO DEL DESKTOP ===" -ForegroundColor Cyan
Write-Host ("data: " + (Get-Date).ToString("yyyy.MM.dd HH:mm:ss", $INV)) -ForegroundColor Gray
Write-Host ("Desktop   : " + $Desktop)
Write-Host ("Archivio  : " + $Arch)
Write-Host ("Cartelle al primo livello: " + $voci.Count + "   da archiviare: " + $piano.Count + "   saltate: " + $saltate.Count)
Write-Host ("Attivita' pianificate lette: " + $(if($attivitaLette){"si'"}else{"NO (guardia ignorata su tua richiesta)"}))
Write-Host "FILE SCIOLTI, COLLEGAMENTI E ICONE: NON LI TOCCO. Questa riga sposta solo CARTELLE." -ForegroundColor Gray

if($saltate.Count -gt 0){
  Write-Host ""
  Write-Host ("--- SALTATE (" + $saltate.Count + "), con il motivo ---") -ForegroundColor Yellow
  foreach($s in ($saltate | Sort-Object Nome)){ Write-Host ("    " + $s.Nome + "   <-- " + $s.Perche) }
}
if($piano.Count -gt 0){
  Write-Host ""
  Write-Host ("--- DA ARCHIVIARE (" + $piano.Count + "), raggruppate per giorno ---") -ForegroundColor White
  foreach($g in ($piano | Group-Object Giorno | Sort-Object Name)){
    Write-Host ("  ARCHIVIO\" + $g.Name + "   (" + $g.Count + " cartelle)")
    foreach($x in ($g.Group | Sort-Object Nome | Select-Object -First 8)){ Write-Host ("       " + $x.Nome) -ForegroundColor DarkGray }
    if($g.Count -gt 8){ Write-Host ("       ... e altre " + ($g.Count - 8)) -ForegroundColor DarkGray }
  }
  Write-Host ("TOTALE: " + $piano.Count + " cartelle, " + $mbTot.ToString("0.0", $INV) + " MB tolti dalla vista del Desktop (SPOSTATI, non cancellati).") -ForegroundColor Yellow
} else {
  Write-Host ""
  Write-Host "Niente da archiviare: o e' gia' tutto dentro ARCHIVIO, o e' tutto fresco/protetto." -ForegroundColor Green
}

# --- il referto si scrive SEMPRE, anche a giro vuoto ------------------
$righe = New-Object System.Collections.ArrayList
if($Esegui){ [void]$righe.Add("ESITO archivio_desktop -- elenco PIANIFICATO; esito REALE in fondo") }
else       { [void]$righe.Add("ANTEPRIMA archivio_desktop -- NESSUNA cartella spostata") }
[void]$righe.Add("data: " + (Get-Date).ToString("yyyy.MM.dd HH:mm:ss", $INV))
[void]$righe.Add("Desktop: " + $Desktop)
[void]$righe.Add("Archivio: " + $Arch)
[void]$righe.Add("ore ferme richieste: " + $OreFerme + "   attivita' pianificate lette: " + $attivitaLette)
[void]$righe.Add("cartelle al primo livello: " + $voci.Count + "   da archiviare: " + $piano.Count + "   saltate: " + $saltate.Count)
[void]$righe.Add("MB spostati (NON cancellati): " + $mbTot.ToString("0.0", $INV))
[void]$righe.Add("")
[void]$righe.Add("--- SALTATE E PERCHE' ---")
foreach($s in ($saltate | Sort-Object Nome)){ [void]$righe.Add("    " + $s.Nome + "   <-- " + $s.Perche) }
[void]$righe.Add("")
[void]$righe.Add("--- PIANIFICATE ---")
foreach($p in ($piano | Sort-Object Giorno, Nome)){ [void]$righe.Add("    ARCHIVIO\" + $p.Giorno + "\" + $p.Nome + "   (" + $p.File + " file, " + ($p.KB/1024.0).ToString("0.00", $INV) + " MB)") }

$fileOut = NomeSenzaCollisione $Desktop $(if($Esegui){"esito_archivio_desktop"}else{"anteprima_archivio_desktop"}) ("_" + $stamp + ".txt")

if(-not $Esegui){
  Set-Content -LiteralPath $fileOut -Value $righe -Encoding UTF8
  Write-Host ""
  Write-Host "Questa era solo l'ANTEPRIMA: non ho spostato niente." -ForegroundColor Yellow
  Write-Host "Per farlo davvero rilancia la stessa riga aggiungendo  -Esegui" -ForegroundColor Yellow
  Write-Host ("File atteso sul Desktop: " + (Split-Path -Leaf $fileOut) + "   (dentro c'e' la riga data:, deve essere di ADESSO)") -ForegroundColor Magenta
  exit 0
}

# ---------------------------------------------------------------------
# L'ESECUZIONE
# ---------------------------------------------------------------------
New-Item -ItemType Directory -Force -Path $LogDir | Out-Null
$log      = New-Object System.Collections.ArrayList
$falliti  = New-Object System.Collections.ArrayList
$rinomin  = New-Object System.Collections.ArrayList
foreach($p in $piano){
  try{
    $destDir = Join-Path $Arch $p.Giorno
    New-Item -ItemType Directory -Force -Path $destDir | Out-Null
    # niente estensioni: una cartella "oro_v1.2" non e' un file .2
    $dest = Join-Path $destDir $p.Nome
    $i = 0
    while(Test-Path -LiteralPath $dest){
      $i++
      $dest = Join-Path $destDir ($p.Nome + "_" + $stamp + "_" + $i)
    }
    # GUARDIA 1, seconda passata: la destinazione NON puo' stare dentro
    # l'origine. Con ARCHIVIO escluso sopra non puo' succedere: e' la
    # cintura oltre alle bretelle, e costa una riga.
    $oU = $p.Origine.ToUpperInvariant()
    $dU = $dest.ToUpperInvariant()
    if($dU -eq $oU -or $dU.StartsWith(($oU + "\"), $ORD)){ throw "RICORSIONE: la destinazione starebbe dentro l'origine" }
    Move-Item -LiteralPath $p.Origine -Destination $dest -ErrorAction Stop
    [void]$log.Add([pscustomobject]@{ Origine=$p.Origine; Destinazione=$dest })
    if($i -gt 0){ [void]$rinomin.Add("  rinominata per collisione: " + $p.Nome + "  ->  " + (Split-Path -Leaf $dest)) }
  } catch {
    $m = "  NON spostata: " + $p.Nome + "  --  " + $_.Exception.Message
    Write-Host $m -ForegroundColor Yellow
    [void]$falliti.Add($m)
  }
}

$mbMossi = 0.0
foreach($p in $piano){
  foreach($r in $log){ if($r.Origine -eq $p.Origine){ $mbMossi = $mbMossi + ($p.KB / 1024.0) } }
}

if($log.Count -gt 0){
  $logFile = NomeSenzaCollisione $LogDir "archivio_desktop" ("_" + $stamp + ".csv")
  $log | Export-Csv -LiteralPath $logFile -NoTypeInformation -Encoding UTF8
} else {
  $logFile = "(niente spostato in questo giro: nessun log nuovo)"
}

[void]$righe.Add("")
[void]$righe.Add("--- ESITO REALE ---")
[void]$righe.Add("spostate: " + $log.Count + "   NON spostate: " + $falliti.Count + "   saltate: " + $saltate.Count)
[void]$righe.Add("MB spostati davvero (NON cancellati): " + $mbMossi.ToString("0.0", $INV))
foreach($m in $falliti){ [void]$righe.Add($m) }
foreach($m in $rinomin){ [void]$righe.Add($m) }
[void]$righe.Add("log per annullare: " + $logFile)
Set-Content -LiteralPath $fileOut -Value $righe -Encoding UTF8
try{ Copy-Item -LiteralPath $fileOut -Destination (Join-Path $LogDir (Split-Path -Leaf $fileOut)) -ErrorAction SilentlyContinue } catch { }

Write-Host ""
Write-Host ("FATTO: " + $log.Count + " cartelle archiviate.   NON spostate: " + $falliti.Count + "   saltate: " + $saltate.Count) -ForegroundColor Green
Write-Host ("Spazio tolto dalla vista del Desktop: " + $mbMossi.ToString("0.0", $INV) + " MB -- SPOSTATI in ARCHIVIO, non cancellati.") -ForegroundColor Green
Write-Host ("Log per annullare: " + $logFile) -ForegroundColor Gray
Write-Host ("File atteso sul Desktop: " + (Split-Path -Leaf $fileOut) + "   (la riga data: dentro deve essere di ADESSO)") -ForegroundColor Magenta
Write-Host "Se qualcosa non ti piace: rilancia la stessa riga con -Annulla e torna tutto com'era." -ForegroundColor Gray
if($falliti.Count -gt 0){ exit 1 }
exit 0
