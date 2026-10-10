# =====================================================================
#  MARCATORE_CARTELLE_GEMELLE_DESKTOP_v1
#  CARTELLE_GEMELLE_DESKTOP.ps1 -- 10/10/2026
#
#  DERIVATO da ZIP_GEMELLI_DESKTOP_V2.ps1 (pin 334806a4, SHA 87C5C4F7, passato dal
#  cancello il 10/10) con i RUOLI INVERTITI: li' si spostavano gli ZIP che avevano
#  la cartella gemella; qui si spostano le CARTELLE che hanno lo ZIP gemello GIA'
#  ARCHIVIATO. Stessi parametri, stesse guardie di macchina / Desktop / attivita'
#  pianificate / processi / giunzioni / log / annulla.
#
#  RICHIESTA DI CLAUDIO (10/10/2026): "SI, GLI ZIP GEMELLI. LE ALTRE LASCIALE FUORI."
#  Dopo l'ESEGUI di ZIP_GEMELLI sul PC di backtest DESKTOP-H4D7CAJ (73 zip in
#  Desktop\ARCHIVIO\2026-10-10\ZIP_GEMELLI) il Desktop aveva ancora ~175 icone:
#  molte sono le CARTELLE GEMELLE di quegli zip. Il dato e' preservato nello zip
#  archiviato, quindi la cartella si puo' spostare in sicurezza (e' reversibile).
#
#  COSA FA, in una frase: SPOSTA in Desktop\ARCHIVIO\<oggi>\CARTELLE_GEMELLE\ SOLO
#  le CARTELLE del Desktop (un livello) il cui nome e' IDENTICO (senza maiuscole/
#  minuscole) al nome base di uno ZIP gia' archiviato in
#  Desktop\ARCHIVIO\<giorno>\ZIP_GEMELLI\ e che sono ferme da almeno -OreFerme
#  ore (ultima scrittura RICORSIVA, giunzioni escluse), e NON TOCCA NIENT'ALTRO.
#
#  COSA NON FA, MAI:
#    - non muove file sciolti, collegamenti, zip, png, txt, pagelle;
#    - non muove cartelle SENZA lo zip gemello archiviato;
#    - non muove NATCLA_F1_P (le righe NATCLA_F1_O/FA/FB/I leggono
#      Desktop\NATCLA_F1_P\MANIFEST_F1.csv e RIEPILOGO_F1.txt: protetta per nome e
#      per prefisso NATCLA_F1_, e per contenuto), ne' cartelle tematiche/strumenti
#      (ABTG_*, GITHUB*, ARCHIVIO*, EASYTREND, INDICATORI, ... le liste dei gemelli);
#    - non muove cartelle che contengono terminal64.exe, metaeditor64.exe,
#      metatester64.exe, origin.txt o una cartella MQL5 (classe 607);
#    - non muove cartelle nascoste/di sistema, giunzioni, ne' cartelle che
#      CONTENGONO una giunzione o che non si riescono a leggere per intero;
#    - non CANCELLA niente: non c'e' nessun Remove-Item su roba di Claudio;
#    - non sovrascrive: se la destinazione esiste, la cartella RESTA e lo dichiara;
#    - non annida mai niente dentro ARCHIVIO (ARCHIVIO stesso non si muove);
#    - non tocca nessun terminale MT5, preset, EA, grafico, conto;
#    - non crea attivita' pianificate e non ne modifica.
#
#  DEFINIZIONE DI ZIP GEMELLO ARCHIVIATO (nome ESATTO, mai prefisso): un file
#  .zip dentro Desktop\ARCHIVIO\<AAAA-MM-GG>\ZIP_GEMELLI\ (un solo livello sotto
#  ARCHIVIO, ne' giunzioni ne' nascosti), con lo stesso nome base della cartella
#  (confronto senza maiuscole/minuscole), di dimensione > 22 byte e che inizia con
#  la firma PK. Se sul Desktop c'e' ancora uno zip con lo stesso nome (appena
#  riscritto), la cartella RESTA. Il contenuto dello zip NON si confronta con la
#  cartella: l'azione e' reversibile (la cartella si sposta intera).
#
#  LE GUARDIE, copiate da ZIP_GEMELLI_DESKTOP_V2.ps1 e non riscritte a memoria
#  (classe 494):
#   G0) MACCHINA: -Macchina e' obbligatorio (default NESSUNA = rifiuto), deve
#       essere una delle DUE macchine previste e deve coincidere con
#       $env:COMPUTERNAME. Il controllo e' la prima istruzione eseguibile.
#   G1) DESKTOP GIUSTO: il percorso si RICAVA (GetFolderPath), non si accetta
#       da fuori; deve stare dentro il profilo dell'utente corrente, finire
#       in \Desktop e non contenere nessuna parola delle piattaforme.
#   G2) ATTIVITA' PIANIFICATE, FAIL-CLOSED: se l'elenco non si legge lo
#       script SI RIFIUTA (classe 458). Una cartella citata da un'attivita'
#       pianificata non si sposta.
#   G3) FRESCHEZZA: una cartella con ultima scrittura (ricorsiva) piu' recente di
#       -OreFerme ore (default 48; per le famiglie ROUND_ NATCLA_ GBA_ AZZURRA_
#       BULGE_ PASSATA_ vale -OreFamiglie, default 336 = 14 giorni) resta: un
#       round potrebbe starla riempiendo.
#   G4) GIUNZIONI / NASCOSTI / DI SISTEMA: si saltano. La ricorsione per l'ultima
#       scrittura NON scende nelle giunzioni; una cartella che ne contiene resta.
#   G5) ROUND VIVI: con metatester64 o metaeditor64 vivi (e, SOLO sul PC di
#       backtest, anche terminal64) -Esegui si RIFIUTA stampando PID e Path:
#       un round o la compilazione dei driver rileggono le loro cose dal
#       Desktop. Sul VPS terminal64 e' SEMPRE vivo (challenge FTMO): contarlo
#       renderebbe lo script inutilizzabile. Anteprima e -Annulla avvisano.
#   G6) LISTA DI PROTEZIONE ESPLICITA (qui sotto, $PROT_*): nomi che restano
#       SEMPRE, qualunque sia l'eta' e anche se hanno lo zip gemello.
#   G7) ANNULLA LEGATO A OGGI (classe 1235): -Annulla smonta SOLO il giro
#       piu' recente e SOLO se e' di OGGI; un giro di un altro giorno si
#       ferma e dice quale sarebbe stato smontato. Se il giro piu' recente e'
#       gia' stato annullato (usato_*), un secondo -Annulla NON smonta quello
#       prima. Se qualche cartella non torna a posto (classe 143) il log NON
#       diventa usato_ e conserva SOLO le cartelle non rimesse. Non annida: se al
#       posto di origine c'e' di nuovo qualcosa, la cartella resta in ARCHIVIO.
#   G8) GIRO A VUOTO (classe 1235): un -Esegui che non sposta niente NON
#       scrive nessun log (un log vuoto confonderebbe -Annulla) e NON dice
#       "rilancia con -Annulla".
#
#  USO:
#    powershell -NoProfile -ExecutionPolicy Bypass -File .\CARTELLE_GEMELLE_DESKTOP.ps1 -Macchina <NOME>
#        -> ANTEPRIMA (default): elenca cosa sposterebbe e cosa salta, non sposta niente
#    ... -Macchina <NOME> -Esegui     -> sposta davvero, scrive il CSV Origine,Destinazione
#    ... -Macchina <NOME> -Annulla    -> rimette a posto le cartelle del giro di OGGI
#    -OreFerme N   soglia di freschezza in ore (default 48)
#    -OreFamiglie N   soglia minima delle famiglie dei round in ore (default 336 = 14 giorni)
#  Sul PC di backtest: -OreFerme 168 -OreFamiglie 168 (7 giorni per tutti).
#  Scrive sul Desktop: anteprima_cartelle_gemelle_<ts>.txt / esito_cartelle_gemelle_<ts>.txt /
#  annulla_cartelle_gemelle_<ts>.txt (riga 2 = data: di ADESSO, ora locale del PC).
# =====================================================================
param(
  [switch]$Esegui,
  [switch]$Annulla,
  [int]$OreFerme = 48,
  [int]$OreFamiglie = 336,
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
if($OreFamiglie -lt 0){ Muori "-OreFamiglie negativo: non ha senso" }

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
$DestDir = Join-Path (Join-Path $Arch $oggi) "CARTELLE_GEMELLE"

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

# processi che dicono "qui si sta lavorando coi round": tester (round in corso), metaeditor64
# (compilazione dei driver). terminal64 conta SOLO sul PC di backtest: sul VPS i terminali
# vivi ci sono SEMPRE (challenge FTMO) e contarli renderebbe lo script inutilizzabile.
$nomiProc = @("metatester64","metaeditor64")
if($env:COMPUTERNAME -eq "DESKTOP-H4D7CAJ"){ $nomiProc = @("metatester64","metaeditor64","terminal64") }
$testerVivi = @(Get-Process -Name $nomiProc -ErrorAction SilentlyContinue)
function ElencoVivi(){
  $o = @()
  foreach($pr in $testerVivi){
    $pp = ""
    try{ $pp = [string]$pr.Path }catch{ $pp = "" }
    if([string]::IsNullOrWhiteSpace($pp)){ $pp = "(percorso non leggibile)" }
    $o += ($pr.ProcessName + " PID " + $pr.Id + " " + $pp)
  }
  return ($o -join " ; ")
}

# ---------------------------------------------------------------------
# -Annulla: SOLO il giro piu' recente, SOLO se e' di OGGI (G7)
# ---------------------------------------------------------------------
if($Annulla){
  $icoPrima = ContaIcone
  $fileA = NomeLibero $Desktop "annulla_cartelle_gemelle" ".txt"
  # il "giro piu' recente" si sceglie fra TUTTI i log, anche quelli gia' usati (usato_*):
  # se il piu' recente e' gia' stato annullato, un secondo -Annulla NON smonta il giro prima
  $cand = New-Object System.Collections.ArrayList
  if(Test-Path -LiteralPath $LogDir -PathType Container){
    foreach($c in @(Get-ChildItem -LiteralPath $LogDir -File -ErrorAction SilentlyContinue)){
      if($c.Name -match '^(usato_(\d+_)?)?cartellegemelle_(\d{4}-\d{2}-\d{2})_(\d{6})(_(\d+))?\.csv$'){
        $suf = 0
        if($Matches[6]){ $suf = [int]$Matches[6] }
        $chiave = $Matches[3] + "_" + $Matches[4] + "_" + $suf.ToString("000000", $INV)
        [void]$cand.Add([pscustomobject]@{ File = $c; Chiave = $chiave; Usato = [bool]$Matches[1]; Giorno = $Matches[3] })
      }
    }
  }
  $ultimo = $null
  foreach($c in $cand){
    if($ultimo -eq $null -or [string]::CompareOrdinal($c.Chiave, $ultimo.Chiave) -gt 0){ $ultimo = $c }
  }
  $righeA = New-Object System.Collections.ArrayList
  [void]$righeA.Add("ESITO ANNULLAMENTO cartelle_gemelle")
  [void]$righeA.Add("data: " + (Ora) + "   (ora locale del PC, non ora server MT5)")
  [void]$righeA.Add("macchina: " + $env:COMPUTERNAME + "   Desktop: " + $Desktop)
  if($testerVivi.Count -gt 0){
    $avv = "ATTENZIONE: processi dei round vivi (" + (ElencoVivi) + "). Rimettere le cartelle al loro posto non disturba il round, ma lo dico."
    Write-Host $avv -ForegroundColor Yellow
    [void]$righeA.Add($avv)
  }
  if(-not $ultimo){
    Write-Host "Nessun giro CARTELLE_GEMELLE da annullare (nessun log cartellegemelle_*.csv in ARCHIVIO\_log)." -ForegroundColor Yellow
    [void]$righeA.Add("Nessun log cartellegemelle_*.csv da annullare: niente toccato.")
    Set-Content -LiteralPath $fileA -Value $righeA -Encoding UTF8
    Write-Host ("Referto: " + $fileA) -ForegroundColor Gray
    exit 0
  }
  $dataLog = $ultimo.Giorno
  if($ultimo.Usato){
    $m = "Il giro piu' recente (" + $ultimo.File.Name + ") e' GIA' stato annullato: non smonto il giro prima. Niente toccato."
    Write-Host $m -ForegroundColor Yellow
    [void]$righeA.Add($m)
    Set-Content -LiteralPath $fileA -Value $righeA -Encoding UTF8
    Write-Host ("Referto: " + $fileA) -ForegroundColor Gray
    exit 0
  }
  $ultimo = $ultimo.File
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
  $rimasti = New-Object System.Collections.ArrayList
  $archPref = $Arch.ToUpperInvariant() + $SEP
  foreach($r in $vociLog){
    try{
      $og = [string]$r.Origine
      $de = [string]$r.Destinazione
      if([string]::IsNullOrWhiteSpace($og) -or [string]::IsNullOrWhiteSpace($de)){ throw "riga del log incompleta" }
      # il log e' un file di testo: prima di fidarsi dei percorsi si controlla che siano quelli che lo script scrive
      if((Split-Path -Parent $og) -ne $Desktop){ throw "l'origine nel log non e' direttamente sul Desktop: rifiuto" }
      if($og.ToUpperInvariant().StartsWith($archPref, $ORD)){ throw "l'origine nel log sta dentro ARCHIVIO: rifiuto" }
      if(-not [string]::Equals((Split-Path -Leaf $og), (Split-Path -Leaf $de), $ORD)){ throw "il nome della cartella nel log non coincide fra origine e destinazione: rifiuto" }
      if(-not $de.ToUpperInvariant().StartsWith($archPref, $ORD)){ throw "la destinazione nel log non e' dentro ARCHIVIO: rifiuto" }
      if((Split-Path -Leaf (Split-Path -Parent $de)) -ne "CARTELLE_GEMELLE"){ throw "la destinazione nel log non e' in una cartella CARTELLE_GEMELLE: rifiuto" }
      if(-not (Test-Path -LiteralPath $de -PathType Container)){
        if(Test-Path -LiteralPath $og){ $gia++; continue }
        throw "non e' piu' dove l'avevo messo (spostato a mano dopo il giro?)"
      }
      if((((Get-Item -LiteralPath $de -Force).Attributes) -band [IO.FileAttributes]::ReparsePoint) -ne 0){ throw "la destinazione nel log e' diventata una giunzione/collegamento: rifiuto" }
      if(Test-Path -LiteralPath $og){ throw "al posto di origine c'e' di nuovo qualcosa: NON annido e non sovrascrivo, va risolto a mano" }
      Move-Item -LiteralPath $de -Destination $Desktop -ErrorAction Stop
      if((Test-Path -LiteralPath $og) -and -not (Test-Path -LiteralPath $de)){ $n++ } else { throw "lo spostamento non risulta riuscito alla verifica" }
    } catch {
      $m = "  NON rimesso: " + [string]$r.Destinazione + "  --  " + $_.Exception.Message
      Write-Host $m -ForegroundColor Yellow
      [void]$rilievi.Add($m)
      [void]$rimasti.Add([pscustomobject]@{ Origine = [string]$r.Origine; Destinazione = [string]$r.Destinazione })
      $ko++
    }
  }
  if($ko -gt 0){
    # classe 143: il log NON diventa usato_; ci restano SOLO le cartelle non rimesse, cosi' un secondo -Annulla (di oggi) riprova solo quelli
    $rimasti | Export-Csv -LiteralPath $ultimo.FullName -NoTypeInformation -Encoding UTF8
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
  if($ko -gt 0){ [void]$righeA.Add("il log NON e' stato marcato come usato e ora contiene SOLO i " + $ko + " cartelle non rimesse: dopo aver risolto a mano si puo' rilanciare -Annulla (oggi)") }
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
  Muori ("c'e' lavoro dei round in corso su questa macchina: " + (ElencoVivi) + ". Un tester (metatester64) o una compilazione (metaeditor64) o, sul PC di backtest, un terminal64 vivo vogliono dire round o driver in corso, che rileggono le loro cose dal Desktop. Rilancia a lavoro finito.")
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
# G6 -- LISTA DI PROTEZIONE ESPLICITA (nomi di CARTELLE che RESTANO sempre)
# Fonte: le liste di ZIP_GEMELLI_DESKTOP_V2.ps1 (pin 334806a4) e di
# PULISCI_DESKTOP_PC.ps1 v2, riusate tali e quali per le cartelle, piu' le
# cartelle lette da altre righe (NATCLA_F1_P) e i contenuti da terminale (classe 607).
# ---------------------------------------------------------------------
# (a) famiglie dei round: -OreFamiglie ore (default 336 = 14 giorni), non -OreFerme (48).
#     Prefissi: ROUND_ NATCLA_ GBA_ AZZURRA_ BULGE_ PASSATA_  (come nella v2 degli zip)
$PROT_ATTESA = @("ROUND_","NATCLA_","GBA_","AZZURRA_","BULGE_","PASSATA_")
if($OreFerme -gt $OreFamiglie){ $OreFamiglie = $OreFerme }
function OreMinime($nome){
  foreach($pf in $PROT_ATTESA){ if($nome.StartsWith($pf, $ORD)){ return $OreFamiglie } }
  return $OreFerme
}
# (b) cartelle che altre righe RILEGGONO dal Desktop: le righe NATCLA_F1_O/FA/FB/I
#     leggono Desktop\NATCLA_F1_P\MANIFEST_F1.csv e RIEPILOGO_F1.txt. Protetta per
#     NOME ESATTO, per PREFISSO NATCLA_F1_ e per CONTENUTO (vedi $PROT_CONTENUTO_FILE).
$PROT_CARTELLE_PREFISSI = @("NATCLA_F1_")
$PROT_NOMI_ESATTI = @("NATCLA_F1_P","ARCHIVIO","ARCHIVIO_DESKTOP","ARCHIVIO_TEST","ABTG_RISULTATI","ABTG_ZIP","ABTG_DOCUMENTI","ABTG_VARIE","ABTG_ORDINE_LOG","ZIP_GEMELLI","CARTELLE_GEMELLE","_log")
# (c) storico M1 e sonde: ingressi di altri script (le stesse della v2 degli zip)
$PROT_INGRESSO = @("DAT_ASCII_","HISTDATA","DUKASCOPY","STORICO","ORO_M1_HISTDATA","PEPPERSTONE_STORICO","IMPORT_ESTERNO","BROKER_ESTERNO","SONDA_")
# (d) tematiche di Claudio, copie di repo, archivi e pagelle: le stesse esclusioni dei gemelli
$PROT_GEMELLI = @("ARCHIVIO","ABTG_",
  "EASYTREND","INDICATORI","BREAKOUT","NOTTE","PROCE","ALTA VELOCIT","NASDAQ APERTU","DAX E NASD","PIANO DI TRADI",
  "FILE WORD","FILE CHE SCARICO","GITHUB","PAGELLA")
# (e) PER CONTENUTO (classe 607): una cartella che dentro (a qualunque profondita') ha
#     un terminale MT5, il suo editor, il tester, origin.txt, una cartella MQL5, o i
#     file che le righe NATCLA_F1_* rileggono, RESTA.
$PROT_CONTENUTO_FILE = @("terminal64.exe","metaeditor64.exe","metatester64.exe","origin.txt","MANIFEST_F1.csv","RIEPILOGO_F1.txt")
$PROT_CONTENUTO_DIR  = @("MQL5")
# (f) DINAMICA: la cartella e' citata (per nome o per percorso) da un'attivita' pianificata
# (g) DINAMICA: le cartelle appena scritte sono coperte dalla freschezza (-OreFerme /
#     -OreFamiglie, sull'ultima scrittura RICORSIVA) e dal rifiuto con tester vivo

function MotivoProtezione($nome, $percorso){
  foreach($p in $PROT_NOMI_ESATTI){ if([string]::Equals($nome, $p, $ORD)){ return "PROTETTO: cartella-strumento / letta da altre righe ('" + $p + "')" } }
  foreach($p in $PROT_CARTELLE_PREFISSI){ if($nome.StartsWith($p, $ORD)){ return "PROTETTO: cartella letta dalle righe " + $p + "* (MANIFEST_F1.csv, RIEPILOGO_F1.txt)" } }
  foreach($p in $PROT_INGRESSO){ if($nome.StartsWith($p, $ORD)){ return "PROTETTO: ingresso di uno script di storico ('" + $p + "*')" } }
  foreach($p in $PROT_GEMELLI){ if($nome.StartsWith($p, $ORD)){ return "PROTETTO: nome tematico/archivio/copia di repo/pagella ('" + $p + "*'), come nei gemelli" } }
  if($testoAttivitaU.Contains($percorso.ToUpperInvariant()) -or $testoAttivitaU.Contains(($SEP + $nome.ToUpperInvariant()))){
    return "PROTETTO: la cita un'ATTIVITA' PIANIFICATA (classe 458)"
  }
  return ""
}

# ---------------------------------------------------------------------
# GLI ZIP GEMELLI GIA' ARCHIVIATI: Desktop\ARCHIVIO\<AAAA-MM-GG>\ZIP_GEMELLI\*.zip (un livello)
# ---------------------------------------------------------------------
$zipArch = New-Object 'System.Collections.Generic.Dictionary[string,System.Collections.ArrayList]' ([StringComparer]::OrdinalIgnoreCase)
$zipArchTot = 0

function ZipLeggibile($f){
  # il dato e' "preservato nello zip" solo se lo zip e' un vero zip: piu' di 22 byte (un
  # archivio vuoto ne ha 22) e firma PK. Non si apre il contenuto: la lettura e' rapida.
  if($f.Length -le 22){ return $false }
  try{
    $fs = [IO.File]::OpenRead($f.FullName)
    try{
      $b = New-Object byte[] 2
      $n = $fs.Read($b, 0, 2)
      return ($n -eq 2 -and $b[0] -eq 0x50 -and $b[1] -eq 0x4B)
    } finally { $fs.Dispose() }
  } catch { return $false }
}

if(Test-Path -LiteralPath $Arch -PathType Container){
  foreach($g in @(Get-ChildItem -LiteralPath $Arch -Directory -Force -ErrorAction SilentlyContinue)){
    if($g.Name -notmatch '^\d{4}-\d{2}-\d{2}$'){ continue }
    if(($g.Attributes -band [IO.FileAttributes]::ReparsePoint) -ne 0){ continue }
    $zd = Join-Path $g.FullName "ZIP_GEMELLI"
    if(-not (Test-Path -LiteralPath $zd -PathType Container)){ continue }
    if(((Get-Item -LiteralPath $zd -Force).Attributes -band [IO.FileAttributes]::ReparsePoint) -ne 0){ continue }
    foreach($f in @(Get-ChildItem -LiteralPath $zd -File -Force -ErrorAction SilentlyContinue)){
      if($f.Extension -ine ".zip"){ continue }
      if(($f.Attributes -band [IO.FileAttributes]::ReparsePoint) -ne 0){ continue }
      if(-not (ZipLeggibile $f)){ continue }
      $bz = $f.Name.Substring(0, $f.Name.Length - 4)
      $lst = $null
      if(-not $zipArch.TryGetValue($bz, [ref]$lst)){
        $lst = New-Object System.Collections.ArrayList
        $zipArch.Add($bz, $lst)
      }
      [void]$lst.Add([pscustomobject]@{ Percorso = $f.FullName; Giorno = $g.Name; Ultima = $f.LastWriteTime })
      $zipArchTot++
    }
  }
}
# i nomi base degli zip ANCORA sul Desktop (se uno zip omonimo e' tornato sul Desktop, la cartella RESTA)
$zipSulDesktop = New-Object 'System.Collections.Generic.HashSet[string]' ([StringComparer]::OrdinalIgnoreCase)
foreach($z in @(Get-ChildItem -LiteralPath $Desktop -File -Force -ErrorAction SilentlyContinue | Where-Object { $_.Extension -ieq ".zip" })){
  [void]$zipSulDesktop.Add($z.Name.Substring(0, $z.Name.Length - 4))
}

# ---------------------------------------------------------------------
# UNA SOLA SCANSIONE per cartella: ultima scrittura, file, MB, e cosa ci sta dentro.
# Visita a mano (pila), SENZA scendere nelle giunzioni; una sottocartella che non si legge
# e' un ILLEGGIBILE e fa restare la cartella (fail-closed).
# ---------------------------------------------------------------------
function InfoCartella($percorso){
  $item = Get-Item -LiteralPath $percorso -Force
  $t = $item.LastWriteTime
  $nf = 0; $bytes = 0.0; $giunz = 0; $illeg = 0
  $protetti = New-Object System.Collections.ArrayList
  $pila = New-Object System.Collections.Stack
  $pila.Push($percorso)
  while($pila.Count -gt 0){
    $cur = [string]$pila.Pop()
    $figli = $null
    try{ $figli = @(Get-ChildItem -LiteralPath $cur -Force -ErrorAction Stop) } catch { $illeg++; continue }
    foreach($f in $figli){
      if($f.LastWriteTime -gt $t){ $t = $f.LastWriteTime }
      if(($f.Attributes -band [IO.FileAttributes]::ReparsePoint) -ne 0){ $giunz++; continue }
      if($f.PSIsContainer){
        if($PROT_CONTENUTO_DIR -contains $f.Name){ [void]$protetti.Add($f.Name + "\") }
        $pila.Push($f.FullName)
      } else {
        $nf++
        $bytes = $bytes + [double]$f.Length
        if($PROT_CONTENUTO_FILE -contains $f.Name){ [void]$protetti.Add($f.Name) }
      }
    }
  }
  return [pscustomobject]@{ File = $nf; Bytes = $bytes; Ultima = $t; Giunzioni = $giunz; Illeggibili = $illeg; Protetti = $protetti }
}

# ---------------------------------------------------------------------
# IL PIANO
# ---------------------------------------------------------------------
$icoPrima = ContaIcone
$cartelleTutte = @(Get-ChildItem -LiteralPath $Desktop -Directory -Force -ErrorAction SilentlyContinue)
$piano   = New-Object System.Collections.ArrayList
$restano = New-Object System.Collections.ArrayList
$archPrefU = $Arch.ToUpperInvariant() + $SEP

foreach($d in $cartelleTutte){
  $nome = $d.Name
  if(($d.Attributes -band [IO.FileAttributes]::ReparsePoint) -ne 0){
    [void]$restano.Add([pscustomobject]@{ Nome=$nome; Cat="collegamento"; Perche="e' una giunzione/collegamento, non una cartella vera" }); continue
  }
  if(($d.Attributes -band [IO.FileAttributes]::System) -ne 0 -or ($d.Attributes -band [IO.FileAttributes]::Hidden) -ne 0){
    [void]$restano.Add([pscustomobject]@{ Nome=$nome; Cat="nascosta"; Perche="e' NASCOSTA o di SISTEMA: non ingombra il Desktop, non la tocco" }); continue
  }
  $mp = MotivoProtezione $nome $d.FullName
  if($mp -ne ""){
    [void]$restano.Add([pscustomobject]@{ Nome=$nome; Cat="protetta"; Perche=$mp }); continue
  }
  $lstZ = $null
  if(-not $zipArch.TryGetValue($nome, [ref]$lstZ)){
    [void]$restano.Add([pscustomobject]@{ Nome=$nome; Cat="senza_zip_archiviato"; Perche="nessuno zip VALIDO (piu' di 22 byte, firma PK) con questo nome ESATTO in ARCHIVIO\<giorno>\ZIP_GEMELLI (il dato non e' in uno zip archiviato)" }); continue
  }
  if($zipSulDesktop.Contains($nome)){
    [void]$restano.Add([pscustomobject]@{ Nome=$nome; Cat="zip_sul_desktop"; Perche="sul Desktop c'e' (di nuovo) uno zip con lo stesso nome: lo sta riscrivendo qualcuno, la cartella resta" }); continue
  }
  $oreMin = OreMinime $nome
  $inf = InfoCartella $d.FullName
  if($inf.Illeggibili -gt 0){
    [void]$restano.Add([pscustomobject]@{ Nome=$nome; Cat="illeggibile"; Perche=("dentro ci sono " + $inf.Illeggibili + " sottocartelle che non riesco a leggere: non posso dire quando e' stata scritta per ultima") }); continue
  }
  if($inf.Giunzioni -gt 0){
    [void]$restano.Add([pscustomobject]@{ Nome=$nome; Cat="contiene_giunzione"; Perche=("dentro ci sono " + $inf.Giunzioni + " giunzioni/collegamenti: non scendo e non muovo") }); continue
  }
  if($inf.Protetti.Count -gt 0){
    [void]$restano.Add([pscustomobject]@{ Nome=$nome; Cat="contenuto_protetto"; Perche=("PROTETTA PER CONTENUTO (classe 607): dentro c'e' " + (($inf.Protetti | Select-Object -First 3) -join ", ")) }); continue
  }
  $oreCart = (New-TimeSpan -Start $inf.Ultima -End $adesso).TotalHours
  if($oreCart -lt $oreMin){
    [void]$restano.Add([pscustomobject]@{ Nome=$nome; Cat="fresca"; Perche=("FRESCA: ultima scrittura " + $inf.Ultima.ToString("yyyy-MM-dd HH:mm", $INV) + ", meno di " + $oreMin + " ore fa (round in corso?)") }); continue
  }
  $dest = Join-Path $DestDir $nome
  if(Test-Path -LiteralPath $dest){
    [void]$restano.Add([pscustomobject]@{ Nome=$nome; Cat="destinazione_occupata"; Perche=("in " + $DestDir + " c'e' gia' qualcosa con questo nome: non sovrascrivo") }); continue
  }
  # fra piu' zip omonimi (giorni diversi) si cita il piu' recente
  $zbest = $null
  foreach($zz in $lstZ){ if($zbest -eq $null -or $zz.Ultima -gt $zbest.Ultima){ $zbest = $zz } }
  $piuNuova = ($inf.Ultima -gt $zbest.Ultima.AddMinutes(2))
  [void]$piano.Add([pscustomobject]@{
    Nome = $nome; Origine = $d.FullName; Dest = $dest; Ultima = $inf.Ultima; Bytes = $inf.Bytes; File = $inf.File
    Gemello = ("ARCHIVIO\" + $zbest.Giorno + "\ZIP_GEMELLI\" + $nome + ".zip"); PiuNuova = $piuNuova
  })
}

$mbTot = 0.0
foreach($p in $piano){ $mbTot = $mbTot + ($p.Bytes / 1048576.0) }
$icoAttese = $icoPrima - $piano.Count
$nPiuNuove = @($piano | Where-Object { $_.PiuNuova }).Count

# ---------------------------------------------------------------------
# IL REFERTO (sempre, anche a giro vuoto)
# ---------------------------------------------------------------------
$righe = New-Object System.Collections.ArrayList
if($Esegui){ [void]$righe.Add("ESITO cartelle_gemelle -- elenco PIANIFICATO; esito REALE in fondo") }
else       { [void]$righe.Add("ANTEPRIMA cartelle_gemelle -- NESSUNA cartella spostata") }
[void]$righe.Add("data: " + (Ora) + "   (ora locale del PC, non ora server MT5)")
[void]$righe.Add("macchina: " + $env:COMPUTERNAME + "   (richiesta: " + $Macchina + ")")
[void]$righe.Add("Desktop: " + $Desktop)
[void]$righe.Add("Destinazione: " + $DestDir)
[void]$righe.Add("ore ferme richieste: " + $OreFerme + "   famiglie: " + $OreFamiglie + "   attivita' pianificate lette: " + $attivitaLette + "   processi dei round vivi: " + $(if($testerVivi.Count -gt 0){"SI: " + (ElencoVivi)}else{"no"}))
[void]$righe.Add("cartelle sul Desktop: " + $cartelleTutte.Count + "   zip gemelli archiviati validi: " + $zipArchTot + "   da spostare: " + $piano.Count + " (" + $mbTot.ToString("0.0", $INV) + " MB)   restano: " + $restano.Count)
[void]$righe.Add("icone sul Desktop PRIMA: " + $icoPrima + "   attese DOPO se tutto va a buon fine: " + $icoAttese + "   (+1 per ogni referto .txt scritto qui)")
[void]$righe.Add("")
[void]$righe.Add("--- LISTA DI PROTEZIONE (restano SEMPRE, anche con lo zip gemello archiviato) ---")
[void]$righe.Add("  famiglie dei round, protette " + $OreFamiglie + " ore (" + ($OreFamiglie / 24.0).ToString("0.##", $INV) + " giorni): " + ($PROT_ATTESA -join " | "))
[void]$righe.Add("  cartelle-strumento / lette da altre righe: " + ($PROT_NOMI_ESATTI -join " | ") + "  e prefisso " + ($PROT_CARTELLE_PREFISSI -join " | ") + " (NATCLA_F1_P: MANIFEST_F1.csv e RIEPILOGO_F1.txt)")
[void]$righe.Add("  ingresso degli script di storico:     " + ($PROT_INGRESSO -join " | "))
[void]$righe.Add("  nomi dei gemelli (tematiche, archivi, GitHub, pagelle): " + ($PROT_GEMELLI -join " | "))
[void]$righe.Add("  per contenuto (classe 607): " + ($PROT_CONTENUTO_FILE -join " | ") + " | cartella " + ($PROT_CONTENUTO_DIR -join " | "))
[void]$righe.Add("  dinamica: citata da un'attivita' pianificata; scritta da meno di " + $OreFerme + " ore (" + $OreFamiglie + " per le famiglie dei round); zip omonimo di nuovo sul Desktop; nascosta/di sistema/collegamento; contiene giunzioni o parti illeggibili")
[void]$righe.Add("  NON si muovono mai: file sciolti, collegamenti, zip, cartelle senza zip gemello archiviato")
[void]$righe.Add("")
[void]$righe.Add("--- RESTANO SUL DESKTOP E PERCHE' (" + $restano.Count + ") ---")
foreach($r in ($restano | Sort-Object Cat, Nome)){ [void]$righe.Add("    " + $r.Nome + "   <-- " + $r.Perche) }
[void]$righe.Add("")
[void]$righe.Add("--- DA SPOSTARE (" + $piano.Count + ") in ARCHIVIO\" + $oggi + "\CARTELLE_GEMELLE ---")
foreach($p in ($piano | Sort-Object Nome)){ [void]$righe.Add("    " + $p.Nome + "   (" + ($p.Bytes / 1048576.0).ToString("0.00", $INV) + " MB, " + $p.File + " file, ultima scrittura " + $p.Ultima.ToString("yyyy-MM-dd", $INV) + ")   zip gemello: " + $p.Gemello + $(if($p.PiuNuova){"   [NB: la cartella ha file piu' recenti dello zip: si sposta intera, il dato non si perde]"}else{""})) }

# ---------------------------------------------------------------------
# la stampa a console
# ---------------------------------------------------------------------
Write-Host ""
Write-Host "=== CARTELLE GEMELLE DEL DESKTOP ===" -ForegroundColor Cyan
Write-Host ("data: " + (Ora) + "   (ora locale del PC, non ora server MT5)") -ForegroundColor Gray
Write-Host ("macchina : " + $env:COMPUTERNAME)
Write-Host ("Desktop  : " + $Desktop)
Write-Host ("Dest.    : " + $DestDir)
Write-Host ("Attivita' pianificate lette: si', guardia ATTIVA   -   processi dei round vivi: " + $(if($testerVivi.Count -gt 0){"SI"}else{"no"}))
Write-Host ("Icone sul Desktop PRIMA: " + $icoPrima + "   -   cartelle: " + $cartelleTutte.Count + "   zip gemelli archiviati: " + $zipArchTot + "   da spostare: " + $piano.Count + "   restano: " + $restano.Count) -ForegroundColor White
Write-Host "SOLO le CARTELLE con lo zip gemello gia' archiviato (il dato resta nello zip). Tutto il resto (file sciolti, collegamenti, altre cartelle, NATCLA_F1_P, cartelle tematiche e strumenti) NON SI TOCCA." -ForegroundColor Gray
if($testerVivi.Count -gt 0){
  Write-Host ("ATTENZIONE: processi dei round vivi: " + (ElencoVivi) + ". L'anteprima la faccio, ma -Esegui si RIFIUTEREBBE.") -ForegroundColor Yellow
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
  Write-Host ("--- DA SPOSTARE (" + $piano.Count + ") in ARCHIVIO\" + $oggi + "\CARTELLE_GEMELLE ---") -ForegroundColor White
  foreach($p in ($piano | Sort-Object Nome | Select-Object -First 12)){ Write-Host ("      " + $p.Nome) -ForegroundColor DarkGray }
  if($piano.Count -gt 12){ Write-Host ("      ... e altre " + ($piano.Count - 12) + " (elenco completo nel referto)") -ForegroundColor DarkGray }
  if($nPiuNuove -gt 0){ Write-Host ("NB: " + $nPiuNuove + " cartelle hanno file piu' recenti del loro zip: si spostano intere, il dato non si perde.") -ForegroundColor DarkGray }
  Write-Host ("TOTALE: " + $piano.Count + " cartelle, " + $mbTot.ToString("0.0", $INV) + " MB (SPOSTATE, non cancellate). Icone attese: " + $icoPrima + " -> " + $icoAttese) -ForegroundColor Yellow
} else {
  Write-Host ""
  Write-Host "Niente da spostare." -ForegroundColor Green
}

# ---------------------------------------------------------------------
# ANTEPRIMA: finisce qui
# ---------------------------------------------------------------------
if(-not $Esegui){
  $fileOut = NomeLibero $Desktop "anteprima_cartelle_gemelle" ".txt"
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
      if(-not (Test-Path -LiteralPath $p.Origine -PathType Container)){ throw "non c'e' piu' sul Desktop" }
      $attuale = Get-Item -LiteralPath $p.Origine -Force
      if(($attuale.Attributes -band [IO.FileAttributes]::ReparsePoint) -ne 0){ throw "ora e' una giunzione/collegamento: la lascio" }
      if((Split-Path -Parent $p.Origine) -ne $Desktop){ throw "non sta direttamente sul Desktop: la lascio" }
      if($p.Origine.ToUpperInvariant().StartsWith($archPrefU, $ORD)){ throw "sta dentro ARCHIVIO: non annido" }
      # riscansione subito prima di muovere: se nel frattempo qualcuno ci ha scritto, o c'e' qualcosa di nuovo, resta
      $nuova = InfoCartella $p.Origine
      if($nuova.Illeggibili -gt 0 -or $nuova.Giunzioni -gt 0 -or $nuova.Protetti.Count -gt 0){ throw "dentro e' cambiato qualcosa (giunzioni, parti illeggibili o contenuto protetto): la lascio" }
      if($nuova.Ultima -ne $p.Ultima){ throw "e' cambiata dopo che ho fatto il piano (qualcuno la sta scrivendo?): la lascio" }
      if(Test-Path -LiteralPath $p.Dest){ throw "la destinazione esiste gia': non sovrascrivo" }
      if(-not $p.Dest.ToUpperInvariant().StartsWith($destU, $ORD)){ throw "la destinazione non sta dentro CARTELLE_GEMELLE" }
      # destinazione = la CARTELLA che contiene (non il nome della cartella spostata): un nome con [ ] non passa dal motore dei wildcard
      Move-Item -LiteralPath $p.Origine -Destination $DestDir -ErrorAction Stop
      if((Test-Path -LiteralPath $p.Dest -PathType Container) -and -not (Test-Path -LiteralPath $p.Origine)){
        [void]$log.Add([pscustomobject]@{ Origine = $p.Origine; Destinazione = $p.Dest })
        $mbMossi = $mbMossi + ($p.Bytes / 1048576.0)
      } else {
        throw "lo spostamento non risulta riuscito alla verifica"
      }
    } catch {
      $m = "  NON spostata: " + $p.Nome + "  --  " + $_.Exception.Message
      Write-Host $m -ForegroundColor Yellow
      [void]$falliti.Add($m)
    }
  }
}

# G8: il CSV si scrive SOLO se qualcosa e' stato spostato
$logFile = ""
if($log.Count -gt 0){
  New-Item -ItemType Directory -Force -Path $LogDir | Out-Null
  $logFile = Join-Path $LogDir ("cartellegemelle_" + $stamp + ".csv")
  $kk = 0
  while(Test-Path -LiteralPath $logFile){ $kk++; $logFile = Join-Path $LogDir ("cartellegemelle_" + $stamp + "_" + $kk + ".csv") }
  $log | Export-Csv -LiteralPath $logFile -NoTypeInformation -Encoding UTF8
}
$icoDopo = ContaIcone

[void]$righe.Add("")
[void]$righe.Add("--- ESITO REALE ---")
[void]$righe.Add("spostate: " + $log.Count + "   NON spostate: " + $falliti.Count + "   restano (da piano): " + $restano.Count)
[void]$righe.Add("MB spostati davvero (NON cancellati): " + $mbMossi.ToString("0.0", $INV))
[void]$righe.Add("icone sul Desktop PRIMA: " + $icoPrima + "   DOPO (questo referto escluso): " + $icoDopo)
foreach($m in $falliti){ [void]$righe.Add($m) }
if($log.Count -gt 0){
  [void]$righe.Add("log per annullare: " + $logFile)
} else {
  [void]$righe.Add("nessuna cartella spostata in questo giro: NESSUN log scritto, niente da annullare")
}
$fileOut = NomeLibero $Desktop "esito_cartelle_gemelle" ".txt"
Set-Content -LiteralPath $fileOut -Value $righe -Encoding UTF8

Write-Host ""
Write-Host ("FATTO: " + $log.Count + " cartelle spostate in " + $DestDir + ".   NON spostate: " + $falliti.Count + "   restano: " + $restano.Count) -ForegroundColor Green
Write-Host ("Icone sul Desktop: prima " + $icoPrima + "   dopo " + $icoDopo + "   (questo referto escluso)") -ForegroundColor Green
if($log.Count -gt 0){
  Write-Host ("Spazio tolto dalla vista: " + $mbMossi.ToString("0.0", $INV) + " MB -- SPOSTATI, non cancellati (stesso disco: lo spazio libero non cambia). Il dato resta anche nello zip archiviato.") -ForegroundColor Green
  Write-Host ("Log per annullare: " + $logFile) -ForegroundColor Gray
  Write-Host "Per rimettere queste cartelle al loro posto: stessa riga con -Annulla, ma SOLO oggi (il giro di un altro giorno non si smonta)." -ForegroundColor Gray
} else {
  Write-Host "Nessuna cartella spostata: nessun log scritto, niente da annullare." -ForegroundColor Yellow
}
Write-Host ("File sul Desktop: " + (Split-Path -Leaf $fileOut) + "   (la riga data: dentro deve essere di ADESSO)") -ForegroundColor Magenta
if($falliti.Count -gt 0){ exit 1 }
exit 0
