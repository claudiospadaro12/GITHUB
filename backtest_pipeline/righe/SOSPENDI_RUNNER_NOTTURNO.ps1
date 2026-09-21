# =====================================================================
#  MARCATORE_SOSPENDI_RUNNER_NOTTURNO_v1
#  SOSPENDI_RUNNER_NOTTURNO.ps1 -- sospende (o riaccende) l'attivita'
#  pianificata che ogni notte alle 03:30 fa girare la coda sul VPS.
# ---------------------------------------------------------------------
#  PERCHE' ESISTE, e la data conta
#  Il 21/09/2026 alle ~09:29 il VPS si e' INCHIODATO: niente PowerShell,
#  niente tasto destro, niente Gestione attivita'. Sul terminale banco
#  girava lo Strategy Tester a "Ogni tick basato su tick reali", e sulla
#  STESSA macchina stavano operando le sei sedie della challenge FTMO,
#  al loro primo giorno. Claudio ha firmato la regola: finche' una
#  challenge e' viva, i round girano sul PC DI BACKTEST.
#  Ma la regola non si applica da sola: runner_abtg.ps1 r.91 registra
#  un'attivita' pianificata DAILY alle 03:30 (schtasks /Create /TN
#  ABTG_Runner). Finche' quella non viene sospesa, stanotte il VPS rifa'
#  da solo quello che stamattina lo ha bloccato.
#
#  COSA FA, in ordine
#    1. FOTOGRAFA l'attivita' PRIMA (stato, ora, azione, prossima corsa);
#    2. la DISABILITA con Disable-ScheduledTask -- reversibile. NON usa
#       Unregister-ScheduledTask ne' schtasks /Delete: quelli cancellano
#       la registrazione e per rimetterla serve reinstallare il runner;
#    3. RILEGGE l'attivita' e pretende di ritrovarla DISABILITATA. Il
#       verdetto sta sull'ARTEFATTO, non sul codice di uscita (classe
#       154): se lo stato dopo non e' quello atteso, esce 1 e lo dice;
#    4. stampa che cosa RESTA ACCESO stanotte su questa macchina;
#    5. raccoglie un referto sul Desktop e lo zippa (regola 11/08).
#
#  -Riaccendi fa la strada inversa (Enable-ScheduledTask) con la stessa
#  verifica sull'artefatto: si usa a challenge finita.
#
#  COSA NON TOCCA -- dichiarato, perche' su questa macchina convivono
#  SETTE cartelle dati e una challenge viva:
#    * NESSUN terminale MT5 viene chiuso, avviato o modificato: in questo
#      file non c'e' una sola riga che termini o avvii un processo -- e il
#      cancello deterministico lo verifica da solo. Lo script CONTA i
#      processi dei terminali prima e dopo e stampa i due numeri, cosi'
#      il "non ho toccato niente" e' un fatto misurato, non una promessa.
#    * NESSUNA cartella dati, nessun preset, nessun .set, nessun .ex5.
#    * Il conto FTMO che sta operando la challenge non viene sfiorato:
#      questo script parla solo con l'Utilita' di pianificazione.
#    * I conti e le cartelle intoccabili sono elencati per nome nel
#      documento di accompagnamento (RIGA_SOSPENDI_RUNNER_DA_MANDARE.md):
#      qui non compaiono nemmeno come stringa, per non dare a nessuno
#      script l'occasione di nominarli.
#
#  NIENTE EMOJI, NIENTE ACCENTI: sul VPS gira Windows PowerShell 5.1 che
#  legge i .ps1 come ANSI. Questo file e' ASCII puro.
# =====================================================================

param(
  [string]$Task      = "ABTG_Runner",
  [switch]$Riaccendi,
  [string]$DestDir   = ""
)

$ErrorActionPreference = "Continue"
$INV = [System.Globalization.CultureInfo]::InvariantCulture
$LOG = New-Object System.Collections.ArrayList

function Dire([string]$t, [string]$col){
  if($col -eq ""){ $col = "Gray" }
  Write-Host $t -ForegroundColor $col
  [void]$LOG.Add($t)
}
function Titolo([string]$t){
  Dire "" ""
  Dire ("=== " + $t + " ===") "Cyan"
}

# ---------------------------------------------------------------------
#  Stampa di una attivita': stato, ora, azione, prossima corsa.
#  IL PERCORSO DELL'AZIONE E' LA COSA CHE CONTA: sul Desktop del VPS c'e'
#  una copia del repo che arriva da uno zip di un branch VECCHIO
#  (classe del 12/09: l'attivita' delle 07:20 girava da li', e le
#  riparazioni fatte su 'lavoro' non arrivavano a quello che gira).
#  Quindi non basta sapere CHE cosa parte: serve sapere DA DOVE.
# ---------------------------------------------------------------------
function MostraAttivita($att, [string]$indent){
  if($att -eq $null){ return }
  Dire ($indent + "--- " + $att.TaskName) "White"
  Dire ($indent + "    cartella     : " + $att.TaskPath) ""
  Dire ($indent + "    stato        : " + [string]$att.State) ""
  foreach($tr in @($att.Triggers)){
    $sb = ""
    try { $sb = [string]$tr.StartBoundary } catch { }
    $en = ""
    try { $en = [string]$tr.Enabled } catch { }
    Dire ($indent + "    trigger      : inizio=" + $sb + "  attivo=" + $en) ""
  }
  foreach($az in @($att.Actions)){
    $ex = ""; $ar = ""; $wd = ""
    try { $ex = [string]$az.Execute } catch { }
    try { $ar = [string]$az.Arguments } catch { }
    try { $wd = [string]$az.WorkingDirectory } catch { }
    if($ex -ne ""){ Dire ($indent + "    esegue       : " + $ex) "Yellow" }
    if($ar -ne ""){ Dire ($indent + "    argomenti    : " + $ar) "Yellow" }
    if($wd -ne ""){ Dire ($indent + "    cartella lav.: " + $wd) "Yellow" }
  }
  $info = Get-ScheduledTaskInfo -TaskName $att.TaskName -TaskPath $att.TaskPath -ErrorAction SilentlyContinue
  if($info -ne $null){
    Dire ($indent + "    ultima corsa : " + [string]$info.LastRunTime) ""
    Dire ($indent + "    ultimo esito : " + [string]$info.LastTaskResult + "   (0 = bene)") ""
    Dire ($indent + "    PROSSIMA     : " + [string]$info.NextRunTime) "Magenta"
  }
}

function ContaTerminali(){
  $p = @(Get-Process -Name "terminal64" -ErrorAction SilentlyContinue)
  return $p.Count
}

$stamp  = (Get-Date).ToString("yyyyMMdd_HHmmss", $INV)
$azione = "SOSPENSIONE"
if($Riaccendi){ $azione = "RIACCENSIONE" }

Titolo ("RUNNER NOTTURNO -- " + $azione)
Dire ("  ora locale di questa macchina : " + (Get-Date).ToString("yyyy-MM-dd HH:mm:ss", $INV)) ""
Dire ("  attivita' bersaglio           : " + $Task) ""
Dire  "  NON viene toccato nessun terminale MT5, nessuna cartella dati," ""
Dire  "  nessun preset e nessun processo. Si agisce SOLO sull'Utilita' di" ""
Dire  "  pianificazione di Windows." ""

# ---------------------------------------------------------------------
#  0. il modulo deve esserci. Se non c'e', si dice e si esce: meglio
#     nessuna misura che una misura inventata.
# ---------------------------------------------------------------------
if(-not (Get-Command -Name "Get-ScheduledTask" -ErrorAction SilentlyContinue)){
  Dire "" ""
  Dire "  RIFIUTO: su questa macchina non esiste il comando Get-ScheduledTask." "Red"
  Dire "  Non posso ne' leggere ne' verificare: non tocco niente." "Red"
  exit 3
}

$termPrima = ContaTerminali

# ---------------------------------------------------------------------
#  1. LA FOTO PRIMA
# ---------------------------------------------------------------------
Titolo "1. COM'E' ADESSO (prima di toccare)"
$prima = Get-ScheduledTask -TaskName $Task -ErrorAction SilentlyContinue
if($prima -eq $null){
  Dire ("  L'attivita' '" + $Task + "' NON esiste su questa macchina.") "Yellow"
  Dire  "  Puo' voler dire due cose diverse, e non sono la stessa:" "Yellow"
  Dire  "    a) il runner non e' mai stato installato qui;" ""
  Dire  "    b) e' stato installato con un altro nome." ""
  Dire  "  Ecco TUTTE le attivita' di casa che riesco a vedere:" ""
  $tutte = @(Get-ScheduledTask -ErrorAction SilentlyContinue | Where-Object { $_.TaskName -like "*ABTG*" })
  if($tutte.Count -eq 0){
    Dire "    (nessuna attivita' col marchio di casa nel nome)" "Yellow"
  } else {
    foreach($a in $tutte){ MostraAttivita $a "  " }
  }
  Dire "" ""
  Dire  "  NON HO CAMBIATO NIENTE. Manda questo output." "Red"
  exit 1
}
MostraAttivita $prima "  "
$statoPrima = [string]$prima.State
if($statoPrima -eq "Running"){
  Dire "" ""
  Dire  "  ATTENZIONE: l'attivita' sta GIRANDO PROPRIO ADESSO." "Red"
  Dire  "  Disabilitarla impedisce le corse FUTURE, NON ferma questa." "Red"
  Dire  "  Questo script non ammazza processi: se serve fermarla ora, si" "Red"
  Dire  "  decide a mano e con gli occhi aperti." "Red"
}

# ---------------------------------------------------------------------
#  2. L'AZIONE, reversibile
# ---------------------------------------------------------------------
Titolo ("2. " + $azione)
$erroreAzione = ""
try {
  if($Riaccendi){
    Enable-ScheduledTask  -TaskName $prima.TaskName -TaskPath $prima.TaskPath -ErrorAction Stop | Out-Null
  } else {
    Disable-ScheduledTask -TaskName $prima.TaskName -TaskPath $prima.TaskPath -ErrorAction Stop | Out-Null
  }
  Dire "  comando eseguito." ""
} catch {
  $erroreAzione = [string]$_.Exception.Message
  Dire ("  IL COMANDO HA DATO ERRORE: " + $erroreAzione) "Red"
  Dire  "  Se dice 'Accesso negato': chiudi questa finestra e riapri" "Yellow"
  Dire  "  PowerShell con il tasto destro -> Esegui come amministratore." "Yellow"
}

# ---------------------------------------------------------------------
#  3. LA FOTO DOPO, riletta da zero. IL VERDETTO STA SULL'ARTEFATTO.
# ---------------------------------------------------------------------
Titolo "3. COM'E' ADESSO (riletta da zero)"
$dopo = Get-ScheduledTask -TaskName $Task -ErrorAction SilentlyContinue
if($dopo -eq $null){
  Dire ("  L'attivita' '" + $Task + "' NON SI TROVA PIU'.") "Red"
  Dire  "  Non doveva succedere: Disable non cancella niente. Manda l'output." "Red"
  exit 1
}
MostraAttivita $dopo "  "
$statoDopo = [string]$dopo.State
$atteso    = "Disabled"
if($Riaccendi){ $atteso = "Ready" }

$infoDopo = Get-ScheduledTaskInfo -TaskName $dopo.TaskName -TaskPath $dopo.TaskPath -ErrorAction SilentlyContinue
$prossima = ""
if($infoDopo -ne $null){ $prossima = [string]$infoDopo.NextRunTime }

# ---------------------------------------------------------------------
#  4. CHE COSA RESTA ACCESO STANOTTE
#     Non basta spegnere la nostra: serve vedere se ne e' rimasta
#     un'altra che fa partire qualcosa di pesante.
# ---------------------------------------------------------------------
Titolo "4. CHE COSA RESTA ACCESO SU QUESTA MACCHINA (attivita' di casa)"
$casa = @(Get-ScheduledTask -ErrorAction SilentlyContinue | Where-Object {
  ($_.TaskName -like "*ABTG*") -or ($_.TaskName -like "*ReportMercato*") -or ($_.TaskName -like "*Report*Trading*")
})
if($casa.Count -eq 0){
  Dire "  (nessuna attivita' di casa trovata)" "Yellow"
} else {
  foreach($a in $casa){
    $s = [string]$a.State
    $i = Get-ScheduledTaskInfo -TaskName $a.TaskName -TaskPath $a.TaskPath -ErrorAction SilentlyContinue
    $n = ""
    if($i -ne $null){ $n = [string]$i.NextRunTime }
    $col = "Gray"
    if($s -eq "Disabled"){ $col = "Green" }
    Dire ("  " + $a.TaskName.PadRight(28) + " stato=" + $s.PadRight(10) + " prossima=" + $n) $col
  }
}

# ---------------------------------------------------------------------
#  5. LA PROVA CHE NON HO TOCCATO NESSUN TERMINALE
# ---------------------------------------------------------------------
$termDopo = ContaTerminali
Titolo "5. I TERMINALI MT5: contati prima e dopo, mai toccati"
Dire ("  processi dei terminali PRIMA : " + $termPrima) ""
Dire ("  processi dei terminali DOPO  : " + $termDopo) ""
if($termPrima -eq $termDopo){
  Dire  "  Stesso numero: nessun terminale e' stato chiuso o avviato." "Green"
} else {
  Dire  "  NUMERO DIVERSO. Questo script non chiude e non avvia terminali:" "Red"
  Dire  "  se il numero e' cambiato, e' cambiato per qualcos'altro. Guardare." "Red"
}

# ---------------------------------------------------------------------
#  6. IL VERDETTO
# ---------------------------------------------------------------------
Titolo "6. VERDETTO"
$ok = ($statoDopo -eq $atteso)
Dire ("  stato PRIMA  : " + $statoPrima) ""
Dire ("  stato DOPO   : " + $statoDopo) ""
Dire ("  stato ATTESO : " + $atteso) ""
Dire ("  prossima corsa prevista: " + $(if($prossima -eq ""){ "nessuna" } else { $prossima })) ""
if($ok -and (-not $Riaccendi)){
  Dire "" ""
  Dire  "  FATTO: l'attivita' e' DISABILITATA e non ha piu' una prossima corsa." "Green"
  Dire  "  Stanotte alle 03:30 il VPS non fa partire nessun backtest." "Green"
  Dire  "  E' REVERSIBILE: la riga per riaccenderla sta nel documento." "Green"
} elseif($ok) {
  Dire "" ""
  Dire  "  FATTO: l'attivita' e' di nuovo ATTIVA." "Green"
} else {
  Dire "" ""
  Dire  "  NON RIUSCITO: lo stato dopo non e' quello atteso." "Red"
  if($erroreAzione -ne ""){ Dire ("  errore: " + $erroreAzione) "Red" }
  Dire  "  NON dare per sospesa l'attivita'. Manda questo output." "Red"
}

# ---------------------------------------------------------------------
#  7. LA RACCOLTA (regola 11/08: il risultato arriva anche sul Desktop)
# ---------------------------------------------------------------------
Titolo "7. RACCOLTA"
if($DestDir -eq ""){ $DestDir = Join-Path $env:USERPROFILE "Desktop" }
$nome = "SOSPENDI_RUNNER_" + $stamp
$cart = Join-Path $DestDir $nome
try {
  New-Item -ItemType Directory -Force -Path $cart -ErrorAction Stop | Out-Null
  $ref = Join-Path $cart ($nome + "_referto.txt")
  Set-Content -LiteralPath $ref -Value $LOG -Encoding ASCII -ErrorAction Stop
  $zip = Join-Path $DestDir ($nome + ".zip")
  Compress-Archive -Path $cart -DestinationPath $zip -Force -ErrorAction Stop
  Write-Host ("  cartella: " + $cart) -ForegroundColor Green
  Write-Host ("  zip     : " + $zip) -ForegroundColor Green
  Write-Host  "  File attesi da verificare: 1 referto .txt dentro la cartella, 1 .zip accanto." -ForegroundColor Green
} catch {
  Write-Host ("  NON sono riuscito a scrivere la raccolta: " + [string]$_.Exception.Message) -ForegroundColor Yellow
  Write-Host  "  Il verdetto qui sopra resta valido: copia l'output a mano." -ForegroundColor Yellow
}

if($ok){ exit 0 }
exit 1
