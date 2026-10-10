# =====================================================================
#  MARCATORE_ZIP_GEMELLI_DESKTOP_v1
#  ZIP_GEMELLI_DESKTOP.ps1 -- 10/10/2026
#
#  RICHIESTA DI CLAUDIO (testuale, 10/10/2026):
#    "SI, GLI ZIP GEMELLI. LE ALTRE LASCIALE FUORI. STESSA COSA X IL DESKTOP"
#  (valida per il Desktop del VPS VMI3047753 E per quello del PC di backtest
#   DESKTOP-H4D7CAJ: lo stesso script, lanciato su una macchina alla volta.)
#
#  COSA FA, in una frase: SPOSTA in Desktop\ARCHIVIO\<oggi>\ZIP_GEMELLI\ SOLO
#  gli ZIP del Desktop il cui nome (senza .zip) e' IDENTICO al nome di una
#  cartella gia' esistente (la "gemella"), e NON TOCCA NIENT'ALTRO.
#
#  COSA NON FA, MAI:
#    - non CANCELLA niente: non c'e' nessun Remove-Item su roba di Claudio;
#    - non sovrascrive: se la destinazione esiste, lo zip RESTA e lo dichiara;
#    - non tocca altri zip, .png, .txt, pagelle, .lnk, strumenti, cartelle;
#    - non tocca nessun terminale MT5, preset, EA, grafico, conto;
#    - non crea attivita' pianificate e non ne modifica.
#
#  DEFINIZIONE DI GEMELLA (decisa con Claudio, nome ESATTO, mai prefisso):
#    una cartella con lo STESSO nome base dello zip (confronto senza
#    maiuscole/minuscole), che sta SUL Desktop oppure DENTRO
#    Desktop\ARCHIVIO\<giorno>\ (UN solo livello), e che contiene ALMENO UN
#    FILE. Una gemella vuota non vale: lo zip resta.
#
#  LE GUARDIE, copiate dai gemelli (RIGA_ARCHIVIO_DESKTOP.ps1 del 19/09 e
#  PULISCI_DESKTOP_PC.ps1 v2 del 25/09) e non riscritte a memoria (classe 494):
#   G0) MACCHINA: -Macchina e' obbligatorio (default NESSUNA = rifiuto), deve
#       essere una delle DUE macchine previste e deve coincidere con
#       $env:COMPUTERNAME. Il controllo e' la prima istruzione eseguibile.
#   G1) DESKTOP GIUSTO: il percorso si RICAVA (GetFolderPath), non si accetta
#       da fuori; deve stare dentro il profilo dell'utente corrente, finire
#       in \Desktop e non contenere nessuna parola delle piattaforme.
#   G2) ATTIVITA' PIANIFICATE, FAIL-CLOSED: se l'elenco non si legge lo
#       script SI RIFIUTA (classe 458). Uno zip citato da un'attivita'
#       pianificata non si sposta.
#   G3) FRESCHEZZA: uno zip piu' recente di -OreFerme ore (default 48) resta
#       (Claudio deve ancora mandarmelo); resta anche se la gemella e' stata
#       scritta da meno di -OreFerme ore (round che la sta riempiendo).
#   G4) GIUNZIONI / NASCOSTI / DI SISTEMA: zip e cartelle gemelle di questo
#       tipo si saltano.
#   G5) TESTER VIVO: con metatester64 vivo -Esegui si RIFIUTA (un round in
#       corso rilegge le sue cose dal Desktop; il 21/09 il tester sul VPS ha
#       inchiodato la macchina). Anteprima e -Annulla non si fermano, ma
#       avvisano.
#   G6) LISTA DI PROTEZIONE ESPLICITA (qui sotto, $PROT_*): nomi che restano
#       SEMPRE, qualunque sia l'eta' e anche se hanno la gemella.
#   G7) ANNULLA LEGATO A OGGI (classe 1235): -Annulla smonta SOLO il giro
#       piu' recente e SOLO se e' di OGGI; un giro di un altro giorno si
#       ferma e dice quale sarebbe stato smontato.
#   G8) GIRO A VUOTO (classe 1235): un -Esegui che non sposta niente NON
#       scrive nessun log (un log vuoto confonderebbe -Annulla) e NON dice
#       "rilancia con -Annulla".
#
#  USO:
#    powershell -NoProfile -ExecutionPolicy Bypass -File .\ZIP_GEMELLI_DESKTOP.ps1 -Macchina <NOME>
#        -> ANTEPRIMA (default): elenca cosa sposterebbe e cosa salta, non sposta niente
#    ... -Macchina <NOME> -Esegui     -> sposta davvero, scrive il CSV Origine,Destinazione
#    ... -Macchina <NOME> -Annulla    -> rimette a posto gli zip del giro di OGGI
#    -OreFerme N   soglia di freschezza in ore (default 48)
#  Scrive sul Desktop: anteprima_zip_gemelli_<ts>.txt / esito_zip_gemelli_<ts>.txt /
#  annulla_zip_gemelli_<ts>.txt (riga 2 = data: di ADESSO, ora locale del PC).
# =====================================================================
param(
  [switch]$Esegui,
  [switch]$Annulla,
  [int]$OreFerme = 48,
  [string]$Macchina = 'NESSUNA'
)
$ErrorActionPreference = "Continue"
$INV = [System.Globalization.CultureInfo]::InvariantCulture
$ORD = [System.StringComparison]::OrdinalIgnoreCase
$SEP = [string][IO.Path]::DirectorySeparatorChar

function Muori($msg){
  Write-Host ""
  Write-Host ("RIFIUTO: " + $msg) -ForegroundColor Red
  Write-Host "Non ho spostato niente." -ForegroundColor Red
  exit 1
}

# ---------------------------------------------------------------------
# G0 -- LA MACCHINA, prima di qualunque lettura o scrittura
# ---------------------------------------------------------------------
$MACCHINE_PREVISTE = @("VMI3047753","DESKTOP-H4D7CAJ")
if($Macchina -eq "NESSUNA" -or [string]::IsNullOrWhiteSpace($Macchina)){
  Muori "manca -Macchina: questo script non parte senza che gli si dica su quale macchina deve girare (VMI3047753 = VPS, DESKTOP-H4D7CAJ = PC di backtest)"
}
if(-not ($MACCHINE_PREVISTE -contains $Macchina)){
  Muori ("-Macchina '" + $Macchina + "' non e' una delle due macchine previste (VMI3047753, DESKTOP-H4D7CAJ)")
}
if($env:COMPUTERNAME -ne $Macchina){
  Muori ("questa riga e' per la macchina " + $Macchina + ", e tu sei su '" + $env:COMPUTERNAME + "': non scrivo niente")
}
if($Esegui -and $Annulla){ Muori "-Esegui e -Annulla insieme non hanno senso: una cosa alla volta" }
if($OreFerme -lt 0){ Muori "-OreFerme negativo: non ha senso" }

# ---------------------------------------------------------------------
# G1 -- IL DESKTOP GIUSTO, e nessun modo di dirgli un altro posto
# ---------------------------------------------------------------------
$Desktop = [Environment]::GetFolderPath("Desktop")
if([string]::IsNullOrWhiteSpace($Desktop)){ Muori "non riesco a ricavare il percorso del Desktop" }
$Desktop = [IO.Path]::GetFullPath($Desktop).TrimEnd($SEP)
if(-not (Test-Path -LiteralPath $Desktop -PathType Container)){ Muori ("il Desktop ricavato non esiste: " + $Desktop) }
if((Split-Path -Leaf $Desktop) -ne "Desktop"){ Muori ("il percorso ricavato non finisce in \Desktop: " + $Desktop) }
$prof = ""
if($env:USERPROFILE){ $prof = [IO.Path]::GetFullPath($env:USERPROFILE).TrimEnd($SEP) }
if(-not $prof){ Muori "USERPROFILE vuoto: non posso dimostrare che quel Desktop e' dell'utente corrente" }
if(-not $Desktop.StartsWith(($prof + $SEP), $ORD)){
  Muori ("il Desktop (" + $Desktop + ") non sta dentro il profilo dell'utente corrente (" + $prof + "): VIETATO")
}
# nessuna di queste parole puo' comparire nel percorso su cui lavoro:
# sono le piattaforme e i terminali, che questa riga non tocca mai.
$PAROLE_VIETATE = @("METAQUOTES","TERMINAL","BCM_REALE","BCM MARKETS","MT5_BACKTEST","PEPPERSTONE","TICKMILL","PROGRAM FILES","\ABTG","REPORT_SCHEDULER")
$dskU = $Desktop.ToUpperInvariant()
foreach($k in $PAROLE_VIETATE){
  if($dskU.Contains($k)){ Muori ("il percorso di lavoro contiene '" + $k + "': e' roba di una piattaforma, VIETATO toccarla") }
}

$adesso = Get-Date
$stamp  = $adesso.ToString("yyyy-MM-dd_HHmmss", $INV)
$oggi   = $adesso.ToString("yyyy-MM-dd", $INV)
$Arch   = Join-Path $Desktop "ARCHIVIO"
$LogDir = Join-Path $Arch "_log"
$DestDir = Join-Path (Join-Path $Arch $oggi) "ZIP_GEMELLI"

if((Test-Path -LiteralPath $Arch) -and -not (Test-Path -LiteralPath $Arch -PathType Container)){
  Muori ("esiste un FILE che si chiama ARCHIVIO sul Desktop: rinominalo a mano, non lo tocco io (" + $Arch + ")")
}
if(Test-Path -LiteralPath $Arch -PathType Container){
  $aItem = Get-Item -LiteralPath $Arch -Force
  if(($aItem.Attributes -band [IO.FileAttributes]::ReparsePoint) -ne 0){
    Muori ("ARCHIVIO e' una giunzione/collegamento: dietro puo' esserci qualsiasi cosa, non ci scrivo (" + $Arch + ")")
  }
}

# nome libero: <base>_<stamp>.<ext>, e se esiste <base>_<stamp>_<k>.<ext>
function NomeLibero($cartella, $base, $ext){
  $cand = Join-Path $cartella ($base + "_" + $stamp + $ext)
  $k = 0
  while(Test-Path -LiteralPath $cand){
    $k++
    $cand = Join-Path $cartella ($base + "_" + $stamp + "_" + $k + $ext)
  }
  return $cand
}
function ContaIcone(){
  # le icone che Claudio VEDE: niente nascosti (desktop.ini); non conta il Desktop pubblico
  return @(Get-ChildItem -LiteralPath $Desktop -ErrorAction SilentlyContinue).Count
}
function Ora(){ return (Get-Date).ToString("yyyy.MM.dd HH:mm:ss", $INV) }

$testerVivi = @(Get-Process -Name "metatester64" -ErrorAction SilentlyContinue)

# ---------------------------------------------------------------------
# -Annulla: SOLO il giro piu' recente, SOLO se e' di OGGI (G7)
# ---------------------------------------------------------------------
if($Annulla){
  $icoPrima = ContaIcone
  $fileA = NomeLibero $Desktop "annulla_zip_gemelli" ".txt"
  $cand = New-Object System.Collections.ArrayList
  if(Test-Path -LiteralPath $LogDir -PathType Container){
    foreach($c in @(Get-ChildItem -LiteralPath $LogDir -File -ErrorAction SilentlyContinue)){
      if($c.Name -match '^zipgemelli_(\d{4}-\d{2}-\d{2})_\d{6}(_\d+)?\.csv$'){ [void]$cand.Add($c) }
    }
  }
  $ultimo = $null
  foreach($c in $cand){
    if($ultimo -eq $null -or [string]::CompareOrdinal($c.Name, $ultimo.Name) -gt 0){ $ultimo = $c }
  }
  $righeA = New-Object System.Collections.ArrayList
  [void]$righeA.Add("ESITO ANNULLAMENTO zip_gemelli")
  [void]$righeA.Add("data: " + (Ora) + "   (ora locale del PC, non ora server MT5)")
  [void]$righeA.Add("macchina: " + $env:COMPUTERNAME + "   Desktop: " + $Desktop)
  if($testerVivi.Count -gt 0){
    $avv = "ATTENZIONE: metatester64 e' vivo (un round e' in corso). Rimettere gli zip al loro posto non disturba il round, ma lo dico."
    Write-Host $avv -ForegroundColor Yellow
    [void]$righeA.Add($avv)
  }
  if(-not $ultimo){
    Write-Host "Nessun giro ZIP_GEMELLI da annullare (nessun log zipgemelli_*.csv in ARCHIVIO\_log)." -ForegroundColor Yellow
    [void]$righeA.Add("Nessun log zipgemelli_*.csv da annullare: niente toccato.")
    Set-Content -LiteralPath $fileA -Value $righeA -Encoding UTF8
    Write-Host ("Referto: " + $fileA) -ForegroundColor Gray
    exit 0
  }
  $dataLog = $ultimo.Name.Substring(11, 10)
  if($dataLog -ne $oggi){
    $m = "ANNULLA FERMO: il giro piu' recente e' " + $ultimo.Name + " (giorno " + $dataLog + "), NON di oggi (" + $oggi + "). Non smonto giri vecchi: se e' proprio quello che vuoi, rimettili a mano oppure chiedi una riga apposta."
    Write-Host ""
    Write-Host ("RIFIUTO: " + $m) -ForegroundColor Red
    Write-Host "Non ho spostato niente." -ForegroundColor Red
    [void]$righeA.Add($m)
    [void]$righeA.Add("Non ho spostato niente.")
    Set-Content -LiteralPath $fileA -Value $righeA -Encoding UTF8
    Write-Host ("Referto: " + $fileA) -ForegroundColor Gray
    exit 1
  }
  Write-Host ""
  Write-Host ("ANNULLO usando " + $ultimo.Name + "   (giro di OGGI)") -ForegroundColor Cyan
  $vociLog = @(Import-Csv -LiteralPath $ultimo.FullName -ErrorAction SilentlyContinue)
  $n = 0; $ko = 0; $gia = 0
  $rilievi = New-Object System.Collections.ArrayList
  $archPref = $Arch.ToUpperInvariant() + $SEP
  foreach($r in $vociLog){
    try{
      $og = [string]$r.Origine
      $de = [string]$r.Destinazione
      if([string]::IsNullOrWhiteSpace($og) -or [string]::IsNullOrWhiteSpace($de)){ throw "riga del log incompleta" }
      # il log e' un file di testo: prima di fidarsi dei percorsi si controlla che siano quelli che lo script scrive
      if((Split-Path -Parent $og) -ne $Desktop){ throw "l'origine nel log non e' direttamente sul Desktop: rifiuto" }
      if(-not $og.EndsWith(".zip", $ORD)){ throw "l'origine nel log non e' uno zip: rifiuto" }
      if(-not $de.ToUpperInvariant().StartsWith($archPref, $ORD)){ throw "la destinazione nel log non e' dentro ARCHIVIO: rifiuto" }
      if((Split-Path -Leaf (Split-Path -Parent $de)) -ne "ZIP_GEMELLI"){ throw "la destinazione nel log non e' in una cartella ZIP_GEMELLI: rifiuto" }
      if(-not (Test-Path -LiteralPath $de)){
        if(Test-Path -LiteralPath $og){ $gia++; continue }
        throw "non e' piu' dove l'avevo messo (spostato a mano dopo il giro?)"
      }
      if(Test-Path -LiteralPath $og){ throw "al posto di origine c'e' di nuovo qualcosa: NON annido e non sovrascrivo, va risolto a mano" }
      Move-Item -LiteralPath $de -Destination $Desktop -ErrorAction Stop
      if((Test-Path -LiteralPath $og) -and -not (Test-Path -LiteralPath $de)){ $n++ } else { throw "lo spostamento non risulta riuscito alla verifica" }
    } catch {
      $m = "  NON rimesso: " + [string]$r.Destinazione + "  --  " + $_.Exception.Message
      Write-Host $m -ForegroundColor Yellow
      [void]$rilievi.Add($m)
      $ko++
    }
  }
  if($ko -eq 0){
    $usato = Join-Path $ultimo.DirectoryName ("usato_" + $ultimo.Name)
    $k2 = 0
    while(Test-Path -LiteralPath $usato){ $k2++; $usato = Join-Path $ultimo.DirectoryName ("usato_" + $k2 + "_" + $ultimo.Name) }
    Move-Item -LiteralPath $ultimo.FullName -Destination $usato -ErrorAction SilentlyContinue
  }
  $icoDopo = ContaIcone
  [void]$righeA.Add("log usato: " + $ultimo.Name + "   (giorno " + $dataLog + ")")
  [void]$righeA.Add("rimessi a posto: " + $n + "   NON rimessi: " + $ko + "   gia' al loro posto: " + $gia)
  [void]$righeA.Add("icone sul Desktop PRIMA: " + $icoPrima + "   DOPO (questo referto escluso): " + $icoDopo)
  foreach($m in $rilievi){ [void]$righeA.Add($m) }
  if($ko -gt 0){ [void]$righeA.Add("il log NON e' stato marcato come usato: dopo aver risolto a mano si puo' rilanciare -Annulla") }
  Set-Content -LiteralPath $fileA -Value $righeA -Encoding UTF8
  Write-Host ("Rimessi a posto: " + $n + "   NON rimessi: " + $ko + "   gia' al loro posto: " + $gia) -ForegroundColor White
  Write-Host ("Icone sul Desktop: prima " + $icoPrima + "   dopo " + $icoDopo + "   (questo referto escluso)") -ForegroundColor White
  Write-Host ("Referto: " + $fileA) -ForegroundColor Gray
  if($ko -gt 0){ Write-Host "ESITO: PARZIALE -- leggi le righe gialle e il referto." -ForegroundColor Red; exit 1 }
  Write-Host "ESITO: OK" -ForegroundColor Green
  exit 0
}

# ---------------------------------------------------------------------
# G5 -- tester vivo: -Esegui si rifiuta
# ---------------------------------------------------------------------
if($Esegui -and $testerVivi.Count -gt 0){
  $pidl = ($testerVivi | ForEach-Object { $_.Id }) -join ", "
  Muori ("il tester di MT5 e' al lavoro (metatester64 PID " + $pidl + "): un round sta girando e rilegge le sue cose dal Desktop. Rilancia a round finito.")
}

# ---------------------------------------------------------------------
# G2 -- le cartelle e i nomi usati dalle ATTIVITA' PIANIFICATE, fail-closed
# ---------------------------------------------------------------------
$testoAttivita = ""
$attivitaLette = $false
try{
  $tasks = @(Get-ScheduledTask -ErrorAction Stop)
  foreach($t in $tasks){
    # -Width 8000 NON e' cosmetico: senza, Out-String manda a capo a 80
    # colonne e un percorso spezzato non combacia piu' con nessuna ricerca.
    foreach($a in @($t.Actions)){ $testoAttivita = $testoAttivita + ($a | Out-String -Width 8000) + "`n" }
  }
  if($tasks.Count -gt 0){ $attivitaLette = $true }
} catch {
  $attivitaLette = $false
}
if(-not $attivitaLette){
  # classe 165: niente Stop sulla chiamata nativa (schtasks scrive su stderr)
  try{
    $q = (& { $ErrorActionPreference = 'Continue'; & schtasks.exe /query /fo LIST /v 2>$null | Out-String -Width 8000 })
    if($q -and $q.Length -gt 200){ $testoAttivita = $q; $attivitaLette = $true }
  } catch {
    $attivitaLette = $false
  }
}
if(-not $attivitaLette){
  Muori "non riesco a leggere le attivita' pianificate, quindi non so quale zip e' l'input di un'attivita'. Il 16/09 un riordino ha spostato la cartella di ABTG_AggiornaNews e l'attivita' delle 07:20 e' morta. Rilancia da una console con i diritti giusti."
}
$testoAttivitaU = $testoAttivita.ToUpperInvariant()

# ---------------------------------------------------------------------
# G6 -- LISTA DI PROTEZIONE ESPLICITA (nomi che RESTANO sempre)
# Fonte: grep 'Desktop' / Compress-Archive in backtest_pipeline/righe/*.ps1 e *.txt
# (10/10/2026) + le liste dei gemelli (PULISCI_DESKTOP_PC.ps1 v2).
# ---------------------------------------------------------------------
# (a) zip che le righe di prova ricreano sul Desktop e che Claudio deve ancora
#     mandare: AZZURRA_FREQ.ps1, BULGE_TEL_P0.ps1, GBA_R0_PASSATE.ps1,
#     NATCLA_F0_PASSATE.ps1, NATCLA_F1_PASSATE.ps1, NATCLA_DIAG_U30.ps1
$PROT_ATTESA = @("AZZURRA_FREQ","BULGE_TEL_P0","GBA_R0_","NATCLA_F0_","NATCLA_F1_","NATCLA_DIAG")
# (b) zip che sono INGRESSO di altri script (storico M1): oro_m1_histdata.ps1,
#     importa_storico_esterno.ps1, RIGA_STORICO_INDICI.ps1, histdata_m1, sonde
$PROT_INGRESSO = @("DAT_ASCII_","HISTDATA","DUKASCOPY","STORICO","ORO_M1_HISTDATA","PEPPERSTONE_STORICO","IMPORT_ESTERNO","BROKER_ESTERNO","SONDA_")
# (c) tematiche di Claudio, copie di repo, archivi e pagelle: le stesse
#     esclusioni dei gemelli (decisione del 14/08: non si toccano)
$PROT_GEMELLI = @("ARCHIVIO","ABTG_RISULTATI","ABTG_ZIP","ABTG_DOCUMENTI","ABTG_VARIE","ABTG_ORDINE_LOG",
  "EASYTREND","INDICATORI","BREAKOUT","NOTTE","PROCE","ALTA VELOCIT","NASDAQ APERTU","DAX E NASD","PIANO DI TRADI",
  "FILE WORD","FILE CHE SCARICO","GITHUB","PAGELLA")
# (d) DINAMICA: lo zip e' citato (per nome o per percorso) da un'attivita' pianificata
# (e) DINAMICA: i ROUND_*.zip e ogni altro zip appena scritto sono coperti dalla
#     freschezza (-OreFerme, sullo zip E sulla gemella) e dal rifiuto con tester vivo

function MotivoProtezione($nome, $percorso){
  foreach($p in $PROT_ATTESA){ if($nome.StartsWith($p, $ORD)){ return "PROTETTO: famiglia di una riga di prova ('" + $p + "*'): e' lo zip che Claudio deve ancora mandare" } }
  foreach($p in $PROT_INGRESSO){ if($nome.StartsWith($p, $ORD)){ return "PROTETTO: zip di INGRESSO di uno script di storico ('" + $p + "*')" } }
  foreach($p in $PROT_GEMELLI){ if($nome.StartsWith($p, $ORD)){ return "PROTETTO: nome tematico/archivio/copia di repo/pagella ('" + $p + "*'), come nei gemelli" } }
  if($testoAttivitaU.Contains($percorso.ToUpperInvariant()) -or $testoAttivitaU.Contains(($SEP + $nome.ToUpperInvariant()))){
    return "PROTETTO: lo cita un'ATTIVITA' PIANIFICATA (classe 458)"
  }
  return ""
}

# ---------------------------------------------------------------------
# LE GEMELLE: cartelle sul Desktop e in ARCHIVIO\<giorno>\ (un livello)
# ---------------------------------------------------------------------
$MaiGemella = @("ARCHIVIO","ABTG_RISULTATI","ABTG_ZIP","ABTG_DOCUMENTI","ABTG_VARIE","ABTG_ORDINE_LOG","ARCHIVIO_DESKTOP","ARCHIVIO_TEST","ZIP_GEMELLI","_log")
$mappa = New-Object 'System.Collections.Generic.Dictionary[string,System.Collections.ArrayList]' ([StringComparer]::OrdinalIgnoreCase)

function CartellaAmmessa($d){
  if(($d.Attributes -band [IO.FileAttributes]::ReparsePoint) -ne 0){ return $false }
  if(($d.Attributes -band [IO.FileAttributes]::System) -ne 0 -or ($d.Attributes -band [IO.FileAttributes]::Hidden) -ne 0){ return $false }
  foreach($m in $MaiGemella){ if([string]::Equals($d.Name, $m, $ORD)){ return $false } }
  return $true
}
function RegistraGemella($d, $dove){
  $lst = $null
  if(-not $mappa.TryGetValue($d.Name, [ref]$lst)){
    $lst = New-Object System.Collections.ArrayList
    $mappa.Add($d.Name, $lst)
  }
  [void]$lst.Add([pscustomobject]@{ Percorso = $d.FullName; Dove = $dove; Info = $null })
}

foreach($d in @(Get-ChildItem -LiteralPath $Desktop -Directory -Force -ErrorAction SilentlyContinue)){
  if(CartellaAmmessa $d){ RegistraGemella $d "Desktop" }
}
if(Test-Path -LiteralPath $Arch -PathType Container){
  foreach($g in @(Get-ChildItem -LiteralPath $Arch -Directory -Force -ErrorAction SilentlyContinue)){
    if(-not (CartellaAmmessa $g)){ continue }
    foreach($d in @(Get-ChildItem -LiteralPath $g.FullName -Directory -Force -ErrorAction SilentlyContinue)){
      if(CartellaAmmessa $d){ RegistraGemella $d ("ARCHIVIO\" + $g.Name) }
    }
  }
}

# una sola scansione per gemella: quanti file, e la scrittura piu' recente
function InfoGemella($voce){
  if($voce.Info -ne $null){ return $voce.Info }
  $cartella = Get-Item -LiteralPath $voce.Percorso -Force
  $t = $cartella.LastWriteTime
  $nf = 0
  foreach($f in @(Get-ChildItem -LiteralPath $voce.Percorso -Recurse -Force -ErrorAction SilentlyContinue)){
    if($f.LastWriteTime -gt $t){ $t = $f.LastWriteTime }
    if(-not $f.PSIsContainer){ $nf++ }
  }
  $voce.Info = [pscustomobject]@{ File = $nf; Ultima = $t }
  return $voce.Info
}

# ---------------------------------------------------------------------
# IL PIANO
# ---------------------------------------------------------------------
$icoPrima = ContaIcone
$zipTutti = @(Get-ChildItem -LiteralPath $Desktop -File -Force -ErrorAction SilentlyContinue | Where-Object { $_.Extension -ieq ".zip" })
$piano   = New-Object System.Collections.ArrayList
$restano = New-Object System.Collections.ArrayList

foreach($z in $zipTutti){
  $base = $z.Name.Substring(0, $z.Name.Length - 4)
  if(($z.Attributes -band [IO.FileAttributes]::ReparsePoint) -ne 0){
    [void]$restano.Add([pscustomobject]@{ Nome=$z.Name; Cat="collegamento"; Perche="e' una giunzione/collegamento, non un file vero" }); continue
  }
  if(($z.Attributes -band [IO.FileAttributes]::System) -ne 0 -or ($z.Attributes -band [IO.FileAttributes]::Hidden) -ne 0){
    [void]$restano.Add([pscustomobject]@{ Nome=$z.Name; Cat="nascosto"; Perche="e' NASCOSTO o di SISTEMA: non ingombra il Desktop, non lo tocco" }); continue
  }
  $mp = MotivoProtezione $z.Name $z.FullName
  if($mp -ne ""){
    [void]$restano.Add([pscustomobject]@{ Nome=$z.Name; Cat="protetto"; Perche=$mp }); continue
  }
  $oreZip = (New-TimeSpan -Start $z.LastWriteTime -End $adesso).TotalHours
  if($oreZip -lt $OreFerme){
    [void]$restano.Add([pscustomobject]@{ Nome=$z.Name; Cat="fresco"; Perche=("FRESCO: scritto " + $z.LastWriteTime.ToString("yyyy-MM-dd HH:mm", $INV) + ", meno di " + $OreFerme + " ore fa (Claudio deve ancora mandarlo?)") }); continue
  }
  $lst = $null
  if(-not $mappa.TryGetValue($base, [ref]$lst)){
    [void]$restano.Add([pscustomobject]@{ Nome=$z.Name; Cat="senza_gemella"; Perche="nessuna cartella gemella con questo nome ESATTO (Desktop o ARCHIVIO\<giorno>\)" }); continue
  }
  $buona = $null
  $vuote = 0
  $fresche = 0
  foreach($v in $lst){
    $inf = InfoGemella $v
    if($inf.File -lt 1){ $vuote++; continue }
    if((New-TimeSpan -Start $inf.Ultima -End $adesso).TotalHours -lt $OreFerme){ $fresche++; continue }
    if($buona -eq $null){ $buona = $v }
  }
  if($buona -eq $null){
    if($fresche -gt 0){
      [void]$restano.Add([pscustomobject]@{ Nome=$z.Name; Cat="gemella_fresca"; Perche=("la gemella e' stata scritta da meno di " + $OreFerme + " ore (round in corso?)") })
    } else {
      [void]$restano.Add([pscustomobject]@{ Nome=$z.Name; Cat="gemella_vuota"; Perche="la gemella esiste ma e' VUOTA (0 file): non vale come gemella" })
    }
    continue
  }
  $dest = Join-Path $DestDir $z.Name
  if(Test-Path -LiteralPath $dest){
    [void]$restano.Add([pscustomobject]@{ Nome=$z.Name; Cat="destinazione_occupata"; Perche=("in " + $DestDir + " c'e' gia' un file con questo nome: non sovrascrivo") }); continue
  }
  [void]$piano.Add([pscustomobject]@{
    Nome = $z.Name; Origine = $z.FullName; Dest = $dest; Ultima = $z.LastWriteTime; Bytes = $z.Length
    Gemella = $buona.Dove + "\" + (Split-Path -Leaf $buona.Percorso)
  })
}

$mbTot = 0.0
foreach($p in $piano){ $mbTot = $mbTot + ($p.Bytes / 1048576.0) }
$icoAttese = $icoPrima - $piano.Count

# ---------------------------------------------------------------------
# IL REFERTO (sempre, anche a giro vuoto)
# ---------------------------------------------------------------------
$righe = New-Object System.Collections.ArrayList
if($Esegui){ [void]$righe.Add("ESITO zip_gemelli -- elenco PIANIFICATO; esito REALE in fondo") }
else       { [void]$righe.Add("ANTEPRIMA zip_gemelli -- NESSUNO zip spostato") }
[void]$righe.Add("data: " + (Ora) + "   (ora locale del PC, non ora server MT5)")
[void]$righe.Add("macchina: " + $env:COMPUTERNAME + "   (richiesta: " + $Macchina + ")")
[void]$righe.Add("Desktop: " + $Desktop)
[void]$righe.Add("Destinazione: " + $DestDir)
[void]$righe.Add("ore ferme richieste: " + $OreFerme + "   attivita' pianificate lette: " + $attivitaLette + "   metatester64 vivo: " + $(if($testerVivi.Count -gt 0){"SI"}else{"no"}))
[void]$righe.Add("zip sul Desktop: " + $zipTutti.Count + "   da spostare: " + $piano.Count + " (" + $mbTot.ToString("0.0", $INV) + " MB)   restano: " + $restano.Count)
[void]$righe.Add("icone sul Desktop PRIMA: " + $icoPrima + "   attese DOPO se tutto va a buon fine: " + $icoAttese + "   (+1 per ogni referto .txt scritto qui)")
[void]$righe.Add("")
[void]$righe.Add("--- LISTA DI PROTEZIONE (restano SEMPRE, anche con la gemella) ---")
[void]$righe.Add("  famiglie di righe di prova (zip da mandare): " + ($PROT_ATTESA -join " | "))
[void]$righe.Add("  zip di ingresso degli script di storico:     " + ($PROT_INGRESSO -join " | "))
[void]$righe.Add("  nomi dei gemelli (tematiche, archivi, GitHub, pagelle): " + ($PROT_GEMELLI -join " | "))
[void]$righe.Add("  dinamica: citato da un'attivita' pianificata; scritto da meno di " + $OreFerme + " ore (zip o gemella); nascosto/di sistema/collegamento")
[void]$righe.Add("")
[void]$righe.Add("--- RESTANO SUL DESKTOP E PERCHE' (" + $restano.Count + ") ---")
foreach($r in ($restano | Sort-Object Cat, Nome)){ [void]$righe.Add("    " + $r.Nome + "   <-- " + $r.Perche) }
[void]$righe.Add("")
[void]$righe.Add("--- DA SPOSTARE (" + $piano.Count + ") in ARCHIVIO\" + $oggi + "\ZIP_GEMELLI ---")
foreach($p in ($piano | Sort-Object Nome)){ [void]$righe.Add("    " + $p.Nome + "   (" + ($p.Bytes / 1048576.0).ToString("0.00", $INV) + " MB, " + $p.Ultima.ToString("yyyy-MM-dd", $INV) + ")   gemella: " + $p.Gemella) }

# ---------------------------------------------------------------------
# la stampa a console
# ---------------------------------------------------------------------
Write-Host ""
Write-Host "=== ZIP GEMELLI DEL DESKTOP ===" -ForegroundColor Cyan
Write-Host ("data: " + (Ora) + "   (ora locale del PC, non ora server MT5)") -ForegroundColor Gray
Write-Host ("macchina : " + $env:COMPUTERNAME)
Write-Host ("Desktop  : " + $Desktop)
Write-Host ("Dest.    : " + $DestDir)
Write-Host ("Attivita' pianificate lette: si', guardia ATTIVA   -   metatester64 vivo: " + $(if($testerVivi.Count -gt 0){"SI"}else{"no"}))
Write-Host ("Icone sul Desktop PRIMA: " + $icoPrima + "   -   zip: " + $zipTutti.Count + "   da spostare: " + $piano.Count + "   restano: " + $restano.Count) -ForegroundColor White
Write-Host "SOLO gli zip con la cartella gemella. Tutto il resto (altri zip, png, txt, pagelle, collegamenti, cartelle) NON SI TOCCA." -ForegroundColor Gray
if($testerVivi.Count -gt 0){
  Write-Host "ATTENZIONE: metatester64 e' vivo (round in corso). L'anteprima la faccio, ma -Esegui si RIFIUTEREBBE." -ForegroundColor Yellow
}
if($restano.Count -gt 0){
  Write-Host ""
  Write-Host ("--- RESTANO (" + $restano.Count + "), con il motivo ---") -ForegroundColor Yellow
  foreach($gr in ($restano | Group-Object Cat | Sort-Object Name)){
    Write-Host ("  [" + $gr.Name + "]  " + $gr.Count) -ForegroundColor DarkYellow
    foreach($r in ($gr.Group | Sort-Object Nome)){ Write-Host ("      " + $r.Nome + "   <-- " + $r.Perche) -ForegroundColor DarkGray }
  }
}
if($piano.Count -gt 0){
  Write-Host ""
  Write-Host ("--- DA SPOSTARE (" + $piano.Count + ") in ARCHIVIO\" + $oggi + "\ZIP_GEMELLI ---") -ForegroundColor White
  foreach($p in ($piano | Sort-Object Nome | Select-Object -First 12)){ Write-Host ("      " + $p.Nome) -ForegroundColor DarkGray }
  if($piano.Count -gt 12){ Write-Host ("      ... e altri " + ($piano.Count - 12) + " (elenco completo nel referto)") -ForegroundColor DarkGray }
  Write-Host ("TOTALE: " + $piano.Count + " zip, " + $mbTot.ToString("0.0", $INV) + " MB (SPOSTATI, non cancellati). Icone attese: " + $icoPrima + " -> " + $icoAttese) -ForegroundColor Yellow
} else {
  Write-Host ""
  Write-Host "Niente da spostare." -ForegroundColor Green
}

# ---------------------------------------------------------------------
# ANTEPRIMA: finisce qui
# ---------------------------------------------------------------------
if(-not $Esegui){
  $fileOut = NomeLibero $Desktop "anteprima_zip_gemelli" ".txt"
  Set-Content -LiteralPath $fileOut -Value $righe -Encoding UTF8
  Write-Host ""
  Write-Host "Questa era solo l'ANTEPRIMA: non ho spostato niente." -ForegroundColor Yellow
  Write-Host ("File sul Desktop: " + (Split-Path -Leaf $fileOut) + "   (la riga data: dentro deve essere di ADESSO)") -ForegroundColor Magenta
  exit 0
}

# ---------------------------------------------------------------------
# L'ESECUZIONE
# ---------------------------------------------------------------------
$log     = New-Object System.Collections.ArrayList
$falliti = New-Object System.Collections.ArrayList
$mbMossi = 0.0
if($piano.Count -gt 0){
  New-Item -ItemType Directory -Force -Path $DestDir | Out-Null
  $destU = $DestDir.ToUpperInvariant() + $SEP
  foreach($p in $piano){
    try{
      if(-not (Test-Path -LiteralPath $p.Origine)){ throw "non c'e' piu' sul Desktop" }
      $attuale = Get-Item -LiteralPath $p.Origine -Force
      if($attuale.LastWriteTime -ne $p.Ultima){ throw "e' cambiato dopo che ho fatto il piano (qualcuno lo sta scrivendo?): lo lascio" }
      if(Test-Path -LiteralPath $p.Dest){ throw "la destinazione esiste gia': non sovrascrivo" }
      if(-not $p.Dest.ToUpperInvariant().StartsWith($destU, $ORD)){ throw "la destinazione non sta dentro ZIP_GEMELLI" }
      # destinazione = la CARTELLA (non il nome del file): un nome con [ ] non passa dal motore dei wildcard
      Move-Item -LiteralPath $p.Origine -Destination $DestDir -ErrorAction Stop
      if((Test-Path -LiteralPath $p.Dest) -and -not (Test-Path -LiteralPath $p.Origine)){
        [void]$log.Add([pscustomobject]@{ Origine = $p.Origine; Destinazione = $p.Dest })
        $mbMossi = $mbMossi + ($p.Bytes / 1048576.0)
      } else {
        throw "lo spostamento non risulta riuscito alla verifica"
      }
    } catch {
      $m = "  NON spostato: " + $p.Nome + "  --  " + $_.Exception.Message
      Write-Host $m -ForegroundColor Yellow
      [void]$falliti.Add($m)
    }
  }
}

# G8: il CSV si scrive SOLO se qualcosa e' stato spostato
$logFile = ""
if($log.Count -gt 0){
  New-Item -ItemType Directory -Force -Path $LogDir | Out-Null
  $logFile = Join-Path $LogDir ("zipgemelli_" + $stamp + ".csv")
  $kk = 0
  while(Test-Path -LiteralPath $logFile){ $kk++; $logFile = Join-Path $LogDir ("zipgemelli_" + $stamp + "_" + $kk + ".csv") }
  $log | Export-Csv -LiteralPath $logFile -NoTypeInformation -Encoding UTF8
}
$icoDopo = ContaIcone

[void]$righe.Add("")
[void]$righe.Add("--- ESITO REALE ---")
[void]$righe.Add("spostati: " + $log.Count + "   NON spostati: " + $falliti.Count + "   restano (da piano): " + $restano.Count)
[void]$righe.Add("MB spostati davvero (NON cancellati): " + $mbMossi.ToString("0.0", $INV))
[void]$righe.Add("icone sul Desktop PRIMA: " + $icoPrima + "   DOPO (questo referto escluso): " + $icoDopo)
foreach($m in $falliti){ [void]$righe.Add($m) }
if($log.Count -gt 0){
  [void]$righe.Add("log per annullare: " + $logFile)
} else {
  [void]$righe.Add("nessuno zip spostato in questo giro: NESSUN log scritto, niente da annullare")
}
$fileOut = NomeLibero $Desktop "esito_zip_gemelli" ".txt"
Set-Content -LiteralPath $fileOut -Value $righe -Encoding UTF8

Write-Host ""
Write-Host ("FATTO: " + $log.Count + " zip spostati in " + $DestDir + ".   NON spostati: " + $falliti.Count + "   restano: " + $restano.Count) -ForegroundColor Green
Write-Host ("Icone sul Desktop: prima " + $icoPrima + "   dopo " + $icoDopo + "   (questo referto escluso)") -ForegroundColor Green
if($log.Count -gt 0){
  Write-Host ("Spazio tolto dalla vista: " + $mbMossi.ToString("0.0", $INV) + " MB -- SPOSTATI, non cancellati (stesso disco: lo spazio libero non cambia).") -ForegroundColor Green
  Write-Host ("Log per annullare: " + $logFile) -ForegroundColor Gray
  Write-Host "Per rimettere questi zip al loro posto: stessa riga con -Annulla, ma SOLO oggi (il giro di un altro giorno non si smonta)." -ForegroundColor Gray
} else {
  Write-Host "Nessuno zip spostato: nessun log scritto, niente da annullare." -ForegroundColor Yellow
}
Write-Host ("File sul Desktop: " + (Split-Path -Leaf $fileOut) + "   (la riga data: dentro deve essere di ADESSO)") -ForegroundColor Magenta
if($falliti.Count -gt 0){ exit 1 }
exit 0
