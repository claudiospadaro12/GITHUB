# =====================================================================
#  MARCATORE_RIGA_SOTTILE_ROUND_v1
#  RIGA_SOTTILE_ROUND.ps1 -- la riga piu' corta che fa passare UN round
#  dal cancello del runner (corsia ROUND, firma di Claudio dell'11/09/2026,
#  report\FIRME_2026-09-11.md).
#
#  IL MARCATORE DI CORSIA -- ed e' UNO SOLO, perche' averli tutti e due
#  vuol dire RIFIUTO (cancello G1 del runner):
#
#        RUNNER_ROUND_BACKTEST
#
# =====================================================================
#  >>> QUELLO CHE QUESTO FILE FA DI PERICOLOSO, DETTO PER PRIMO <<<
#
#  Questo script FA PASSARE, PER PROCURA, DEL CODICE CHE IL CANCELLO NON
#  HA LETTO.
#  Il runner vaglia il sorgente DI QUESTO FILE, riga per riga. Ma questo
#  file scarica altri due .ps1 e li esegue: RIGA_ROUND_VPS.ps1 (che
#  chiude processi, scrive, cancella) e walkforward_generico.ps1 (che
#  compila un EA e avvia il tester). Di quei due il cancello del runner
#  non legge NEMMENO UNA RIGA. Se domani qualcuno cambiasse quei file,
#  il cancello non se ne accorgerebbe: vedrebbe sempre e solo questo.
#
#  E' il buco n.1 dichiarato in report\RUNNER_V3_COLLAUDATO_2026-09-11.md.
#  Non si chiude: si RESTRINGE, e qui e' ristretto in tre modi, tutti e
#  tre verificabili leggendo le righe qui sotto.
#
#   1. IL PIN E' FISSO E SCRITTO QUI DENTRO, non e' un argomento.
#      Chi mette la riga in coda NON sceglie quale codice gira: lo
#      sceglie il contenuto di questo file, che il cancello ha letto.
#      Cambiare il codice eseguito richiede di cambiare QUESTO file, e
#      quindi di ripassare dal cancello.
#
#   2. I DUE FILE SCARICATI SONO INCHIODATI AL BYTE (SHA-256).
#      Il pin gia' da solo e' immutabile (un commit git non si riscrive
#      in silenzio), ma il pin dice "quel commit", non "quei byte": se
#      avessi appuntato il pin sbagliato, o se un giorno la URL cambiasse
#      significato, il pin da solo non lo direbbe. L'impronta si': i due
#      valori qui sotto sono le impronte dei DUE FILE CHE HO LETTO IO,
#      riga per riga, l'11/09/2026. Se i byte scaricati non coincidono,
#      lo script MUORE e non esegue niente.
#      >>> Tradotto: il codice che gira non e' "codice non vagliato", e'
#          "codice vagliato a mano e non dal cancello". Sono due cose
#          diverse, e la seconda e' quella che si puo' dimostrare.
#
#   3. NESSUN ARGOMENTO PUO' NOMINARE UN PERCORSO.
#      Il bersaglio (C:\MT5_Backtest) e' scritto qui, letterale. I soli
#      argomenti accettati sono nomi di EA, nomi di file prova,
#      etichette e due numeri, e passano tutti da una LISTA BIANCA di
#      caratteri (lettere, cifre, punto, trattino basso, trattino).
#      Non esiste nessun parametro con cui dire a questo script
#      "punta altrove".
#
#  >>> E QUELLO CHE RESTA SCOPERTO, che va letto insieme al resto:
#      il driver scarica l'EA .mq5 e gli include NON dal pin, ma dalla
#      TESTA del branch 'lavoro' (in walkforward_generico.ps1 la riga
#      $EABranch="lavoro" e' cablata). Cioe' il codice MQL5 che viene
#      compilato e' quello di 'lavoro' al momento della corsa, non quello
#      del pin. Questo script non puo' ripararlo: lo DICHIARA, e lo
#      stampa a schermo prima di partire, cosi' finisce nel referto.
# =====================================================================
#  COSA FA, IN ORDINE
#    1. controlla gli argomenti con una lista bianca (muore su tutto il
#       resto);
#    2. controlla che il banco esista su questa macchina (muore se no);
#    3. scarica i due .ps1 dal pin fisso, ne verifica IMPRONTA e
#       MARCATORE (muore se uno dei quattro controlli non torna);
#    4. lancia RIGA_ROUND_VPS.ps1 con powershell.exe, col bersaglio
#       letterale C:\MT5_Backtest;
#    5. ristampa TUTTO l'output del figlio, cosi' il censimento dei PID
#       prima/dopo finisce nel log che il runner pubblica sul repo: e'
#       quella la prova, la mattina, che i terminali in forward non sono
#       stati toccati;
#    6. esce con lo STESSO codice del figlio, senza addolcirlo.
#
#  COSA NON FA, E NON E' UNA DIMENTICANZA
#    - NON espone nessuna opzione per chiudere processi. RIGA_ROUND_VPS
#      ha un interruttore -ChiudiBacktest che chiude il terminale del
#      banco: qui NON e' raggiungibile, da nessun argomento. La prima
#      notte e' un collaudo, e un collaudo che uccide processi non e' un
#      collaudo. Conseguenza, dichiarata: se il terminale del banco
#      fosse rimasto aperto, il round esce 1 e non produce niente. E'
#      il fallimento giusto: rumoroso e innocuo.
#    - NON scrive niente fuori dalla sua cartella di lavoro sotto il
#      profilo utente e da quello che scrive il driver.
#    - NON tocca nessun EA, preset, parametro o sedia in forward.
#
#  CODICI D'USCITA -- sono quelli di RIGA_ROUND_VPS.ps1, non miei:
#     0 = ROUND GIRATO        2 = NON MISURATO (CSV assenti o Trades=0)
#     3 = GIRATO CON RILIEVI  1 = non e' nemmeno partito
#  >>> Il runner segna "fallito" tutto cio' che non e' 0: un 3 NON e' un
#      fallimento, e' un round girato con qualcosa da guardare. Il log
#      pubblicato lo dice a chiare lettere.
#
#  NIENTE EMOJI, NIENTE ACCENTI: sul VPS gira Windows PowerShell 5.1 che
#  legge i .ps1 come ANSI. Questo file e' ASCII puro.
# =====================================================================

param(
  [Parameter(Mandatory=$true)][string]$Expert,
  [Parameter(Mandatory=$true)][string]$Prova,
  [Parameter(Mandatory=$true)][string]$Etichetta,
  [int]$Modello   = 4,
  [int]$Deposito  = 10000,
  [switch]$SoloControllo
)

$ErrorActionPreference = "Stop"
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$MARC_MIO = "MARCATORE_RIGA_SOTTILE_ROUND_v1"

# Sta QUI IN CIMA e non piu' in basso: in PowerShell una funzione esiste
# solo dopo la riga che la definisce, e il pre-volo sul banco (poche
# righe sotto) la chiama. Definita dopo, il pre-volo sarebbe morto con
# "termine non riconosciuto" invece che col suo messaggio.
function Muori($m){
  Write-Host ""
  Write-Host ("ERRORE: " + $m) -ForegroundColor Red
  Write-Host "Non eseguo niente." -ForegroundColor Red
  exit 1
}

# ---------------------------------------------------------------------
#  IL BANCO, SCRITTO IN CODICE E NON IN UN COMMENTO.
#  Il cancello positivo G3 del runner pretende questa riga: un round che
#  nomina il bersaglio solo in un commento non ha dimostrato niente,
#  perche' un commento non esegue. E' il caso "INSIDIOSO 1" del collaudo.
#  Conto del banco: 50504400, il demo solo-tester, zero EA attaccati.
# ---------------------------------------------------------------------
$BancoBT = 'C:\MT5_Backtest'

# ---------------------------------------------------------------------
#  IL PIN DEL CODICE ESEGUITO. FISSO. NON E' UN ARGOMENTO, E NON DEVE
#  DIVENTARLO: e' l'unica cosa che lega il codice che gira al codice che
#  e' stato letto.
#
#  >>> 11/09/2026 (TERZO GIRO) -- IL PIN E' DI NUOVO UN SEGNAPOSTO. <<<
#  Primo giro: ri-pin su e2d5dc3 (guardia POSITIVA in RIGA_ROUND_VPS.ps1).
#  Secondo giro: la stessa guardia positiva portata dentro il driver.
#  TERZO GIRO (questo): nel driver e' stato CHIUSO IL RIPIEGO. La guardia
#  positiva c'era gia' ma stava DENTRO "if($TerminaleBacktest)": chi
#  lanciava walkforward_generico.ps1 A MANO senza quel parametro -- come
#  fanno le righe di report\PASSI_OPERATIVI.md -- non la sfiorava, e il
#  ripiego automatico sceglieva IL PICCOLO 50503392, quello con le sedie
#  vive sopra. Adesso il ripiego prende IL BANCO C:\MT5_Backtest (demo
#  50504400) entrando nello STESSO ramo guardato, e se il banco non c'e'
#  MUORE invece di spazzolare Program Files.
#  Quindi l'impronta del driver e' cambiata -- vedi $SHA_WALK qui sotto --
#  e il pin vecchio non porta piu' i byte giusti: lo scarico morirebbe
#  sull'impronta, che e' il fallimento giusto, ma per la ragione sbagliata.
#  Il pin nuovo NON PUO' ESISTERE ADESSO: e' l'hash del commit che contiene
#  QUESTA riga, e quel commit lo fa Claudio.
#  Il comando esatto sta in fondo al referto di consegna. Finche' il
#  segnaposto e' qui, lo script MUORE al controllo qui sotto: e' il
#  fallimento giusto -- rumoroso, e prima di scaricare qualunque cosa.
# ---------------------------------------------------------------------
#  QUARTO GIRO (12/09/2026) -- IL PIN E' STATO SPOSTATO IN AVANTI, E NON
#  PERCHE' IL CODICE SIA CAMBIATO.
#  Al pin precedente 7991c562 i due file inchiodati qui sotto ci sono gia'
#  e sono IDENTICI AL BYTE a quelli di adesso (verificato: git diff fra i
#  due commit su RIGA_ROUND_VPS.ps1 e walkforward_generico.ps1 e' VUOTO,
#  e le due impronte qui sotto NON sono state ricalcolate perche' non
#  cambiano). Quello che manca a 7991c562 sono I FILE PROVA:
#      prove\R133a_livelliTF_NASUSD.txt     -- NON ESISTE a 7991c562
#      prove\R133b_filtrovolumi_U30USD.txt  -- NON ESISTE a 7991c562
#      prove\R133c_ampiezzabox_D30EUR.txt   -- NON ESISTE a 7991c562
#  e i tre R132 a quel pin sono la versione con il "-Modello 1 = TICK
#  REALI" scritto al CONTRARIO (corretto poi in 1764a0e).
#  Il driver prende il file prova DALLO STESSO $PIN (-Pin qui sotto):
#  quindi con il pin vecchio i tre round R133 morirebbero sullo scarico
#  del file prova, e i tre R132 porterebbero in cartella un file che
#  dice la cosa sbagliata. Il pin nuovo e' 4083d7e2, dove ci sono tutti
#  e sei.
#  (SESTO GIRO, 12/09/2026: il pin e' stato mosso ancora -- vedi
#   $SHA_WALK qui sotto. Il numero che vale e' SEMPRE quello scritto
#   nella riga $PIN, non quello citato in un commento: un commento che
#   nomina un pin invecchia, il codice no. Segnalato dal cancello.)
# ---------------------------------------------------------------------
#  OTTAVO GIRO (12/09/2026) -- PIN SPOSTATO IN AVANTI, E DI NUOVO NON
#  PERCHE' IL CODICE SIA CAMBIATO. Al pin precedente 9cba7a10 i due file
#  inchiodati qui sotto ci sono gia' e sono IDENTICI AL BYTE: VERIFICATO,
#  non creduto -- le due impronte $SHA_ROUND e $SHA_WALK sono state
#  RICALCOLATE sui blob del pin nuovo e coincidono con quelle scritte
#  qui, quindi non sono state toccate.
#  Quello che manca a 9cba7a10 sono I QUATTRO FILE PROVA DI r136:
#      prove\R136a_slatr_U30USD.txt          -- NON ESISTE a 9cba7a10
#      prove\R136b_primobersaglio_U30USD.txt -- NON ESISTE a 9cba7a10
#      prove\R136c_parziale_U30USD.txt       -- NON ESISTE a 9cba7a10
#      prove\R136d_trailing_U30USD.txt       -- NON ESISTE a 9cba7a10
#  Il driver prende il file prova DALLO STESSO $PIN (-Pin qui sotto):
#  col pin vecchio i quattro round r136 morirebbero sullo scarico del
#  file prova, con un 404 che manda a cercare il guasto nella rete.
#  Il pin nuovo e' 63e10ba9, dove ci sono tutti e quattro (verificato
#  anche via HTTP: 200 su tutti e quattro).
#  >>> E I SEI FILE PROVA R132/R133 CI SONO ANCORA: 63e10ba9 e'
#      DISCENDENTE di 9cba7a10, non un ramo diverso. Le quattro righe di
#      stanotte NON sono toccate comunque, perche' la coda le pinna a
#      8027068f, cioe' a una COPIA CONGELATA di questo file che porta
#      dentro il pin vecchio.
$PIN = '63e10ba94e89ba63821fd1071b842faf39b506c4'

# Le impronte dei due file A QUEL PIN, misurate sul blob git.
#  - SHA_ROUND: RICALCOLATA l'11/09/2026 sul file con la guardia POSITIVA
#    (prima era A063B0E2...B784D8BA, cioe' il file con la guardia vecchia
#    che lasciava passare il piccolo 50503392, la radice di un disco e i
#    nomi 8.3). Se un giorno tornasse a valere quella vecchia, vorrebbe
#    dire che il pin punta indietro: e' proprio quello che l'impronta
#    deve far scoprire.
#  - SHA_WALK: RICALCOLATA l'11/09/2026 (TERZO giro). Prima era
#    BAE1A08C...DF6AD251 (secondo giro: guardia positiva nel driver, ma
#    solo DENTRO il ramo di -TerminaleBacktest), e prima ancora
#    36370C65...041EE998 (guardia NEGATIVA, quattro buchi).
#    Questo terzo giro inchioda il driver che NON SI SCEGLIE PIU' UN
#    TERMINALE DA SOLO. Per il round lanciato da QUESTA riga non cambia
#    niente -- il banco glielo passiamo noi, con -TerminaleBacktest, qui
#    sotto -- ma l'impronta e' l'unica cosa che impedisce a una copia
#    VECCHIA del driver, quella col ripiego aperto, di girare al posto
#    di questa.
$SHA_ROUND = '348ED5330C18DCD41D736B0709B880A8EC9BF8A4B700B044999BC7099D0A315B'
#    QUINTO GIRO (12/09/2026): RICALCOLATA. Prima era
#    6DB57DF1...981DA495. E' cambiata perche' nel driver e' stata chiusa
#    l'ultima porta su '@FINOA': il tag della data di FINE finestra
#    finiva nelle direttive e poi non veniva MAI usato. I 32 script
#    dedicati quella porta ce l'avevano gia' chiusa dal 31/08 (passano
#    -Fino e gattano @FINOA contro quel valore); QUESTA riga sottile e'
#    l'unico percorso che -Fino non lo passa, quindi era l'unico da cui
#    un '@FINOA' poteva essere ignorato in silenzio.
#    Per i sei file prova R132/R133 non cambia NIENTE: dichiarano tutti
#    @FINOA 2026.06.30, identica al default del driver.
$SHA_WALK  = '02E2FE8F90CCBD079E92A7A6C74B54D96C536982927BEC06AE68ECFB9ECF3FEA'

# I marcatori attesi dentro i due file: l'impronta dice "sono i byte
# giusti", il marcatore dice "e' la versione giusta". Si controllano tutti
# e due perche' rispondono a due domande diverse.
$MARC_ROUND = "MARCATORE_RIGA_ROUND_VPS_v1"
$MARC_WALK  = "MARCATORE_WALKFORWARD_GENERICO_v5_INCLUDE"

$RawBase = "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/" + $PIN
$Avvio   = Get-Date

# ---------------------------------------------------------------------
#  1. LA LISTA BIANCA SUGLI ARGOMENTI.
#  Non una lista nera: una lista nera dimentica sempre qualcosa. Qui
#  passano SOLO lettere, cifre, punto, trattino basso e trattino, e in
#  piu' si rifiuta '..' che nel mezzo di una URL vuol dire "risali".
#  Senza separatori di percorso e senza due punti, nessuno di questi
#  valori puo' diventare un percorso.
# ---------------------------------------------------------------------
function Pulito([string]$v){
  if([string]::IsNullOrWhiteSpace($v)){ return $false }
  if($v.Contains("..")){ return $false }
  return ($v -match '^[A-Za-z0-9_.-]+$')
}
if(-not (Pulito $Expert)){    Muori ("-Expert non passa la lista bianca: '" + $Expert + "'. Ammessi lettere, cifre, punto, trattino basso e trattino. Va il NOME dell'EA senza estensione e senza percorso.") }
if(-not (Pulito $Prova)){     Muori ("-Prova non passa la lista bianca: '" + $Prova + "'. Va il NOME NUDO del file prova, senza cartelle.") }
if(-not (Pulito $Etichetta)){ Muori ("-Etichetta non passa la lista bianca: '" + $Etichetta + "'. E' il suffisso dei CSV: senza, un round nuovo sovrascrive il precedente.") }
if($Modello -lt 0 -or $Modello -gt 4){ Muori ("-Modello ammette 0..4. Ricevuto: " + $Modello + ". 4 = tick reali, la verita'; 1 = OHLC M1, solo screening.") }
if($Deposito -le 0){ Muori ("-Deposito deve essere positivo. Ricevuto: " + $Deposito) }

# ---------------------------------------------------------------------
#  2-bis. IL PIN DEVE ESSERE UN COMMIT: 40 cifre esadecimali minuscole.
#  Senza questo controllo un segnaposto -- o un pin tagliato a meta' --
#  diventa solo una URL sbagliata, e il messaggio che si legge due passi
#  dopo e' "scarico fallito: 404": manda a cercare il guasto dalla parte
#  sbagliata (la rete) invece che dove sta davvero (il pin).
#  STA QUI, dopo la lista bianca e prima di qualunque scaricamento, per
#  la stessa ragione scritta piu' sotto per il pre-volo sul banco: i
#  controlli si mettono in ordine di costo e di chiarezza, e un argomento
#  sbagliato deve morire col SUO messaggio, non con quello del pin.
# ---------------------------------------------------------------------
if($PIN -notmatch '^[0-9a-f]{40}$'){
  Muori ("IL PIN NON E' UN COMMIT: '" + $PIN + "'.`n" +
         "    Qui ci va l'hash a 40 cifre del commit che contiene questa riga.`n" +
         "    Se leggi ancora il segnaposto, il ri-pin dopo il commit NON e' stato fatto:`n" +
         "    si sostituisce il segnaposto con l'uscita di 'git rev-parse HEAD' e si`n" +
         "    ricontrolla che l'impronta di RIGA_ROUND_VPS.ps1 a quel pin sia quella`n" +
         "    scritta in cima. Non si esegue niente finche' non torna.")
}

Write-Host "=== RIGA SOTTILE -- UN ROUND SUL SOLO TERMINALE DA BACKTEST ==="
Write-Host ("    " + $MARC_MIO) -ForegroundColor DarkGray
Write-Host ("data     : " + $Avvio.ToString("yyyy-MM-dd HH:mm:ss") + "   (ora locale del VPS)")
Write-Host ("banco    : " + $BancoBT + "   (conto 50504400, demo solo-tester)")
Write-Host ("pin fisso: " + $PIN)
Write-Host ("round    : EA " + $Expert + " . prova " + $Prova + " . etichetta " + $Etichetta)
Write-Host ("          modello " + $Modello + " . deposito " + $Deposito + $(if($SoloControllo){" . GIRO A VUOTO"}else{""}))
Write-Host ""
Write-Host "AVVERTENZA DICHIARATA: il driver prende l'EA .mq5 e gli include dalla" -ForegroundColor Yellow
Write-Host "TESTA del branch 'lavoro', NON da questo pin. Il pin inchioda i due .ps1," -ForegroundColor Yellow
Write-Host "non il codice MQL5 compilato. Se stanotte qualcuno ha toccato l'EA sul" -ForegroundColor Yellow
Write-Host "branch, il round gira su QUELLA versione." -ForegroundColor Yellow

# ---------------------------------------------------------------------
#  2. IL PRE-VOLO SUL BANCO. QUESTE RIGHE NON SI TOLGONO, E NON SONO
#     SOLO UN PRE-VOLO: fanno DUE cose, e la seconda e' quella che conta.
#
#  a) Ovvia e utile: se su questa macchina il terminale del banco non
#     c'e', si muore ADESSO con un messaggio chiaro, invece di scaricare
#     mezzo mondo e morire fra due minuti dentro il driver.
#
#  b) NON OVVIA, ED E' IL MOTIVO VERO. Il cancello positivo G3 del runner
#     segue una variabile SOLO sulle righe che nominano un terminale
#     (terminal64 / metatester). Senza una riga cosi', questo script
#     consegna il bersaglio a powershell.exe come semplice DATO, e G3
#     non ci guarda dentro: MISURATO l'11/09/2026 con un contro-esempio,
#     una riassegnazione
#         $BancoBT = 'C:\MT5_Backtest'
#         $BancoBT = 'D:\MT5_Altro'
#     PASSAVA il cancello indisturbata. Con questa riga la variabile
#     entra sotto la regola della SQUALIFICA: riassegnata una volta, non
#     e' piu' buona, e il cancello RIFIUTA lo script.
#     >>> Tolte queste righe, il cancello smette di sorvegliare il
#         bersaglio di questo file. Chi le cancella lo faccia sapendolo.
#
#  E sta DOPO la lista bianca, non prima: i controlli si mettono in
#  ordine di costo e di chiarezza. Messo prima, un argomento sbagliato
#  moriva col messaggio del banco, cioe' col messaggio di un'altra cosa
#  (visto girando, l'11/09).
#  Il try/catch non e' decorazione: Join-Path passa dal provider, e su un
#  drive che non esiste LANCIA invece di tornare una stringa. Senza, al
#  posto del mio messaggio uscirebbe un errore grezzo di PowerShell.
# ---------------------------------------------------------------------
$exeBanco = ""
try  { $exeBanco = Join-Path $BancoBT "terminal64.exe" }
catch{ Muori ("il percorso del banco non e' utilizzabile su questa macchina: '" + $BancoBT + "' -- " + $_.Exception.Message) }
if(-not (Test-Path -LiteralPath $exeBanco -PathType Leaf)){
  Muori ("il terminale del banco non c'e': non trovo '" + $exeBanco + "'.`n" +
         "    Il banco e' la cartella programma del demo solo-tester 50504400.`n" +
         "    Finche' non c'e', non si scarica e non si esegue niente.")
}
Write-Host ""
Write-Host ("    banco trovato: " + $exeBanco) -ForegroundColor Green

# ---------------------------------------------------------------------
#  3. I DUE FILE, DAL PIN, CON IMPRONTA E MARCATORE.
#  Il controllo e' a quattro gambe e basta che ne manchi una per morire:
#  scaricato / impronta uguale / marcatore presente / file non vuoto.
# ---------------------------------------------------------------------
$Lavoro = Join-Path $env:USERPROFILE "abtg_sottile"
New-Item -ItemType Directory -Force -Path $Lavoro | Out-Null

function Prendi([string]$rel,[string]$dst,[string]$sha,[string]$marcatore){
  $url = $RawBase + "/" + $rel + "?cb=" + [Guid]::NewGuid().ToString("N")
  try  { Invoke-WebRequest -Uri $url -OutFile $dst -UseBasicParsing -TimeoutSec 120 }
  catch{ Muori ("scarico fallito: " + $rel + " -- " + $_.Exception.Message) }
  if(-not (Test-Path -LiteralPath $dst -PathType Leaf)){ Muori ("file non scaricato: " + $rel) }
  if((Get-Item -LiteralPath $dst).Length -eq 0){ Muori ("file scaricato VUOTO: " + $rel) }
  $h = (Get-FileHash -LiteralPath $dst -Algorithm SHA256).Hash
  if($h -ne $sha){
    Muori ("IMPRONTA DIVERSA su " + $rel + ".`n" +
           "    attesa  : " + $sha + "`n" +
           "    trovata : " + $h + "`n" +
           "    I byte scaricati NON sono quelli letti a mano l'11/09/2026.`n" +
           "    Questo e' esattamente il caso in cui NON si esegue: il codice`n" +
           "    che girerebbe non e' quello che qualcuno ha vagliato.")
  }
  if(-not (Select-String -LiteralPath $dst -SimpleMatch -Pattern $marcatore -Quiet)){
    Muori ("nel file " + $rel + " manca il marcatore " + $marcatore + ": e' una copia sbagliata.")
  }
  Write-Host ("    " + $rel) -ForegroundColor Green
  Write-Host ("        impronta SHA-256 verificata . marcatore " + $marcatore + " presente") -ForegroundColor Green
}

Write-Host ""
Write-Host "--- IL CODICE CHE STA PER GIRARE, INCHIODATO AL BYTE -----------------" -ForegroundColor Cyan
$fileRound = Join-Path $Lavoro "RIGA_ROUND_VPS.ps1"
$fileWalk  = Join-Path $Lavoro "walkforward_generico.ps1"
Prendi "backtest_pipeline/righe/RIGA_ROUND_VPS.ps1"   $fileRound $SHA_ROUND $MARC_ROUND
Prendi "backtest_pipeline/walkforward_generico.ps1"   $fileWalk  $SHA_WALK  $MARC_WALK
Write-Host "  (il secondo file lo riscarichera' il driver dallo STESSO pin: qui e'" -ForegroundColor DarkGray
Write-Host "   scaricato solo per provare, PRIMA di partire, che a quel pin ci sono" -ForegroundColor DarkGray
Write-Host "   i byte giusti. Un commit git non cambia: se l'impronta torna adesso," -ForegroundColor DarkGray
Write-Host "   tornera' anche fra due minuti.)" -ForegroundColor DarkGray
Write-Host "---------------------------------------------------------------------" -ForegroundColor Cyan

# ---------------------------------------------------------------------
#  4. LA CORSA.
#  Il bersaglio e' $BancoBT, che porta il percorso letterale del banco e
#  non e' mai riassegnato. Nessun argomento di questo script puo'
#  cambiarlo.
#  -Pin: il driver usa QUESTO stesso pin per prendere il file prova.
#  NON si passa niente che chiuda processi.
# ---------------------------------------------------------------------
$argv = @("-NoProfile","-ExecutionPolicy","Bypass","-File",$fileRound,
          "-Expert",$Expert,
          "-Prova",$Prova,
          "-Etichetta",$Etichetta,
          "-Pin",$PIN,
          "-Modello",("" + $Modello),
          "-Deposito",("" + $Deposito),
          "-TerminaleBacktest",$BancoBT)
if($SoloControllo){ $argv += "-SoloControllo" }

$stampa = Join-Path $Lavoro ($Etichetta + "_" + $Avvio.ToString("yyyyMMdd_HHmmss") + ".out")
$errori = Join-Path $Lavoro ($Etichetta + "_" + $Avvio.ToString("yyyyMMdd_HHmmss") + ".err")

Write-Host ""
Write-Host "--- CORSA ------------------------------------------------------------" -ForegroundColor Cyan
$t0 = Get-Date
$p  = Start-Process -FilePath "powershell.exe" -ArgumentList $argv -NoNewWindow -PassThru -Wait `
        -RedirectStandardOutput $stampa -RedirectStandardError $errori
$sec = [int]((Get-Date) - $t0).TotalSeconds
$rc  = $p.ExitCode

# ---------------------------------------------------------------------
#  5. TUTTO L'OUTPUT DEL FIGLIO, RISTAMPATO.
#  Non e' cosmetica: il runner cattura lo standard output DI QUESTO
#  script e lo pubblica sul repo. Se non lo ristampo, il censimento dei
#  PID prima/dopo -- cioe' la prova che i terminali in forward sono
#  ancora quelli -- resterebbe in un file sul VPS che nessuno legge.
# ---------------------------------------------------------------------
if(Test-Path -LiteralPath $stampa){
  foreach($r in @(Get-Content -LiteralPath $stampa -ErrorAction SilentlyContinue)){ Write-Host $r }
}
$righeErr = @()
if(Test-Path -LiteralPath $errori){ $righeErr = @(Get-Content -LiteralPath $errori -ErrorAction SilentlyContinue) }
if($righeErr.Count -gt 0){
  Write-Host ""
  Write-Host "--- FLUSSO DEGLI ERRORI DEL FIGLIO -----------------------------------" -ForegroundColor Red
  foreach($r in $righeErr){ Write-Host $r -ForegroundColor Red }
}
Write-Host "---------------------------------------------------------------------" -ForegroundColor Cyan

Write-Host ""
Write-Host ("DURATA: " + $sec + "s   CODICE D'USCITA DEL ROUND: " + $rc)
if($rc -eq 0){     Write-Host "  0 = ROUND GIRATO: i CSV ci sono, freschi, con operazioni." -ForegroundColor Green }
elseif($rc -eq 3){ Write-Host "  3 = GIRATO CON RILIEVI: i numeri ci sono, ma c'e' qualcosa da leggere nel referto. NON e' un fallimento." -ForegroundColor Yellow }
elseif($rc -eq 2){ Write-Host "  2 = NON MISURATO: CSV assenti, vuoti, oppure zero operazioni. Zero operazioni non vuol dire nessun edge: vuol dire che NON E' GIRATA." -ForegroundColor Red }
else{              Write-Host ("  " + $rc + " = non e' nemmeno partito: il pre-volo ha fermato la corsa. Il motivo e' stampato qui sopra.") -ForegroundColor Red }

Write-Host ""
Write-Host "COSA GUARDARE LA MATTINA, in quest'ordine:" -ForegroundColor Cyan
Write-Host "  1. la riga 'PID vivi PRIMA' e 'PID vivi DOPO' qui sopra: devono essere" -ForegroundColor Cyan
Write-Host "     GLI STESSI. Se manca un numero, il referto lo grida e va controllato" -ForegroundColor Cyan
Write-Host "     subito il terminale in forward corrispondente." -ForegroundColor Cyan
Write-Host "  2. il codice d'uscita qui sopra." -ForegroundColor Cyan
Write-Host "  3. i CSV: Desktop\ROUND_<etichetta>\ e la cartella risultati_prove." -ForegroundColor Cyan
Write-Host ""
Write-Host ("ESITO RIGA SOTTILE: uscita " + $rc)
exit $rc
