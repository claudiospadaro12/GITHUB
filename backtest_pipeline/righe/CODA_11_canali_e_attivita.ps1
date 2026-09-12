# =====================================================================
#  MARCATORE_CODA_11_CANALI_E_ATTIVITA_v1
#  RUNNER_SOLA_LETTURA
# ---------------------------------------------------------------------
#  COSA FA: stampa, ogni notte, le due cose che nessun cancello guardava.
#    1. le ATTIVITA' PIANIFICATE che entrano in questa macchina: nome,
#       stato, ultimo esito, prossima corsa e IL COMANDO che eseguono;
#    2. l'IMPRONTA SHA-256 del runner INSTALLATO, piu' la sua data e il
#       suo marcatore di versione.
#  Non scrive, non copia, non cancella, non chiude niente: STAMPA.
#
#  PERCHE' ESISTE (classe 251, 12/09/2026)
#  Il censimento del 12/09 ha trovato che i canali per cui il codice
#  entra in questa macchina sono QUATTRO, e i cancelli ne guardano DUE:
#    - la coda del runner            -> vagliata (G1-G4)
#    - le righe incollate a mano     -> vagliate (controlla_riga.py)
#    - le ATTIVITA' PIANIFICATE      -> NESSUNO
#    - il branch da cui si compila   -> nessuno (dichiarato)
#  E dentro il canale che crediamo protetto c'era un buco: il runner
#  vaglia la coda, ma NESSUNO VAGLIA IL RUNNER INSTALLATO. La sua
#  impronta veniva confrontata col pin UNA VOLTA SOLA, all'installazione.
#  Dopo, quel file gira alle 03:30 come un file qualunque.
#  L'arma che ha aperto la classe: un'attivita' delle 07:20 che
#  sovrascriveva il calendario letto da 55 EA, con il download scritto
#  DIRETTAMENTE sul bersaglio. Nessun log, nessuno davanti.
#
#  COME SI LEGGE
#  Questa riga non giudica: FOTOGRAFA. Il giudizio si fa confrontando la
#  foto di stanotte con quella di ieri -- e siccome il runner pubblica i
#  referti nel repo, il confronto e' un diff.
#  >>> Se l'impronta del runner installato cambia senza un pacchetto
#      firmato, quella riga e' la prova che qualcuno l'ha cambiata. <<<
#
#  NOTA: qui NON si usa 'schtasks', ed e' voluto: quel comando e' fra i
#  divieti del runner (registra e cancella attivita'), e un divieto non
#  si aggira. Get-ScheduledTask / Get-ScheduledTaskInfo LEGGONO e basta.
# =====================================================================
$ErrorActionPreference = "Continue"
$INV = [System.Globalization.CultureInfo]::InvariantCulture

function Titolo([string]$t){
  Write-Host ""
  Write-Host ("=== " + $t + " ===") -ForegroundColor Cyan
}

Titolo "CODA 11 - I CANALI CHE ENTRANO IN QUESTA MACCHINA"
Write-Host ("  ora locale : " + (Get-Date).ToString("yyyy-MM-dd HH:mm:ss", $INV))

# ---------------------------------------------------------------------
#  1. LE ATTIVITA' PIANIFICATE
#     Si elencano per NOME quelle di casa (classe 180: un insieme si
#     elenca, non si definisce per differenza), e poi si stampa comunque
#     TUTTO quello che porta ABTG nel nome -- cosi' una attivita' NUOVA
#     si vede, invece di restare fuori dall'elenco.
# ---------------------------------------------------------------------
Titolo "1. ATTIVITA' PIANIFICATE"
$attese = @("ABTG_Runner","ABTG_AggiornaNews","ABTG_Pagella",
            "ReportMercatoGiornaliero","ReportSettimanaleTrading")
$viste = @()
try {
  $tutte = @(Get-ScheduledTask -ErrorAction SilentlyContinue)
} catch {
  $tutte = @()
  Write-Host ("  Get-ScheduledTask non disponibile: " + $_.Exception.Message) -ForegroundColor Yellow
}
$nostre = @($tutte | Where-Object {
  $n = $_.TaskName
  ($attese -contains $n) -or ($n -like "*ABTG*") -or ($n -like "*Report*Trading*") -or ($n -like "*ReportMercato*")
})
if($nostre.Count -eq 0){
  Write-Host "  NESSUNA attivita' di casa trovata. Se il runner sta girando, questo e' strano:" -ForegroundColor Yellow
  Write-Host "  vuol dire che questa riga non riesce a leggere il registro delle attivita'." -ForegroundColor Yellow
}
foreach($t in $nostre){
  $nome = $t.TaskName
  $viste += $nome
  Write-Host ("  --- " + $nome) -ForegroundColor White
  Write-Host ("      stato        : " + $t.State)
  try {
    $i = Get-ScheduledTaskInfo -TaskName $nome -ErrorAction SilentlyContinue
    if($i){
      Write-Host ("      ultima corsa : " + $i.LastRunTime)
      Write-Host ("      ultimo esito : " + $i.LastTaskResult + "   (0 = bene)")
      Write-Host ("      prossima     : " + $i.NextRunTime)
    }
  } catch { }
  # IL COMANDO: e' la cosa che conta, perche' dice COSA entra
  foreach($a in @($t.Actions)){
    $ex = $null; $ar = $null
    try { $ex = $a.Execute } catch { }
    try { $ar = $a.Arguments } catch { }
    if($ex){ Write-Host ("      esegue       : " + $ex) -ForegroundColor Yellow }
    if($ar){ Write-Host ("      argomenti    : " + $ar) -ForegroundColor Yellow }
  }
}
Write-Host ""
foreach($a in $attese){
  if($viste -notcontains $a){
    Write-Host ("  ATTESA MA NON TROVATA: " + $a) -ForegroundColor Yellow
  }
}
$extra = @($viste | Where-Object { $attese -notcontains $_ })
foreach($e in $extra){
  Write-Host ("  ATTIVITA' NUOVA, non nell'elenco di casa: " + $e) -ForegroundColor Magenta
}

# ---------------------------------------------------------------------
#  2. L'IMPRONTA DEL RUNNER INSTALLATO
#     Questo e' il buco vero: il runner vaglia la coda, e nessuno vaglia
#     LUI. L'impronta si confronta col pin una volta sola, all'install.
# ---------------------------------------------------------------------
Titolo "2. IL RUNNER INSTALLATO - impronta, data, marcatore"
$inst = "C:\ABTG\runner_abtg.ps1"
if(Test-Path -LiteralPath $inst -PathType Leaf){
  $it = Get-Item -LiteralPath $inst
  Write-Host ("  file      : " + $inst)
  Write-Host ("  byte      : " + $it.Length)
  Write-Host ("  modificato: " + $it.LastWriteTime.ToString("yyyy-MM-dd HH:mm:ss", $INV))
  try {
    $h = (Get-FileHash -LiteralPath $inst -Algorithm SHA256).Hash
    Write-Host ("  SHA-256   : " + $h) -ForegroundColor Green
  } catch {
    Write-Host ("  SHA-256   : NON CALCOLABILE (" + $_.Exception.Message + ")") -ForegroundColor Red
  }
  $marc = @(Select-String -LiteralPath $inst -SimpleMatch -Pattern "MARCATORE_RUNNER_ABTG_v3")
  Write-Host ("  marcatore v3 presente: " + ($marc.Count -gt 0))
  Write-Host ""
  Write-Host "  >>> QUESTA IMPRONTA VA CONFRONTATA CON QUELLA DI IERI." -ForegroundColor Cyan
  Write-Host "      Se cambia senza un pacchetto firmato, qualcuno ha cambiato il" -ForegroundColor Cyan
  Write-Host "      codice che gira da solo alle 03:30. Questa riga e' la prova." -ForegroundColor Cyan
} else {
  Write-Host ("  NON INSTALLATO: non trovo " + $inst) -ForegroundColor Yellow
  Write-Host "  (se l'attivita' ABTG_Runner esiste ma il file no, quella attivita' gira a vuoto)" -ForegroundColor Yellow
}

Titolo "FINE CODA 11"
