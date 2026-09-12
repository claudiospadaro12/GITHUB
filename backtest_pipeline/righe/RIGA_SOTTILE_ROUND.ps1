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
#  NONO GIRO (12/09/2026) -- E QUESTA VOLTA IL MOTIVO E' UN MIO ERRORE,
#  non un file nuovo. I quattro file prova di r136 al pin 63e10ba9
#  contengono un NUMERO SBAGLIATO: dicevano "60 file letti" su un
#  censimento di colonna che in realta' era tagliato a 'head -60' (i file
#  veri sono 257, e i valori in archivio non sono solo {'1'}). La
#  conclusione non cambia -- la manopola non e' mai stata un ASSE in 0
#  file su 257 -- ma un numero sbagliato dentro un file prova e' un
#  numero sbagliato, e il driver scarica il file prova DA QUESTO PIN.
#  Col pin vecchio girerebbe la versione con l'errata dentro.
#  Il pin nuovo e' fb9b4731, dove i quattro file portano i numeri veri
#  (verificato scaricandolo: la riga corretta c'e').
#  Le due impronte qui sotto sono state RICALCOLATE anche a questo pin e
#  sono identiche: non sono state toccate.
#  DECIMO GIRO (12/09/2026) -- E QUESTA VOLTA IL PIN SI MUOVE PERCHE' IL
#  CODICE DEL DRIVER E' CAMBIATO DAVVERO. Non e' un file prova nuovo: e'
#  la TOPPA DELLA CLASSE 270, commit 124db40 (12/09 09:47, "CLASSE 270,
#  TOPPATA NEL DRIVER: l'ex5 stantio che passava per compilato").
#
#  IL DIFETTO CHE LA TOPPA CHIUDE, detto per intero perche' e' il motivo
#  di tutto questo giro: walkforward_generico.ps1 compilava l'EA e poi
#  faceva Test-Path sull'.ex5 SENZA CANCELLARLO PRIMA. Con una
#  compilazione FALLITA e un .ex5 preesistente, Test-Path era VERO: il
#  driver stampava "compilato" IN VERDE e girava IL BINARIO VECCHIO.
#  Numeri di un commit attribuiti a un altro, IN SILENZIO -- il modo
#  peggiore di sbagliare. E l'.ex5 preesistente NON e' l'eccezione: sui
#  quattro EA di questi round l'archivio ha 48 / 14 / 6 / 4 CSV, cioe'
#  e' LA NORMA.
#  Con la toppa (r.1570 del driver:
#      Remove-Item -LiteralPath $ex5Atteso -Force -ErrorAction SilentlyContinue
#  PRIMA di compilare) ogni round e' il proprio collaudo di compilazione:
#  se la compilazione fallisce, Test-Path fallisce e il driver MUORE
#  leggendo il log del compilatore. Rumoroso e senza numeri, invece di
#  silenzioso e falso.
#
#  IL PIN NUOVO E' e6c0d70e, E LA COSA DA VERIFICARE E' UNA SOLA:
#      git merge-base --is-ancestor 124db40 e6c0d70e   ->  esce 0
#  cioe' la toppa E' dentro il pin. Verificato il 12/09/2026, e verificato
#  anche AL CONTRARIO (il contro-esempio, altrimenti quello "0" non vale
#  niente): sul pin PRECEDENTE fb9b4731 lo stesso comando esce 1, e nel
#  driver a quel pin la riga Remove-Item compare ZERO volte. Il controllo
#  distingue i due casi, quindi il suo "0" dice qualcosa.
#
#  >>> E QUESTA VOLTA L'IMPRONTA DEL DRIVER CAMBIA, ed e' giusto cosi':
#      $SHA_WALK passa da 02E2FE8F...9ECF3FEA a 62A53763...F7CBB7BC.
#      Se leggete ancora la vecchia, il pin punta a un driver SENZA la
#      toppa e lo scarico muore sull'impronta: il fallimento giusto.
#      $SHA_ROUND invece NON e' stata toccata -- ed e' stata RICALCOLATA
#      sul blob del pin nuovo per dirlo, non assunta: 348ED533... a
#      e6c0d70e e' identica a 348ED533... a fb9b4731.
#
#  E IL PIN PORTA ANCHE DUE FILE PROVA CORRETTI, che al pin precedente
#  erano SBAGLIATI in modo bloccante:
#      prove\R127c_orologio_EURJPY.txt   -- dicevano "-Modello 4" con
#      prove\R127b_sllookback_XAUUSD.txt    accanto "= OHLC M1"
#  cioe' il numero invertito rispetto alla r.172 del driver ("4 = tick
#  reali (verita'). 1 = OHLC M1"). E' lo stesso difetto che l'11/09 sera
#  il commit 1764a0e ha corretto sui tre file R132, specchiato. Su r127c
#  pesava il doppio, perche' r127c e' IL CANARINO della notte: a tick
#  reali non avrebbe potuto ricomporre l'ancora OHLC di R103 (394 +/- 2%,
#  PF 1,41 +/- 0,03) PER COSTRUZIONE, e avrebbe fermato gli altri undici
#  round dando la colpa al binario.
#  Il driver prende il file prova DA QUESTO $PIN: col pin vecchio
#  girerebbe la versione col numero invertito.
#
#  >>> LE RIGHE GIA' IN CODA NON SONO TOCCATE: r132c / r133b / r133c
#      pinnano a 8027068f e i quattro r136 a 0c7d98af, cioe' a COPIE
#      CONGELATE di questo file. E VA DETTO, perche' e' una misura e non
#      un dettaglio: su NESSUNO di quei due pin la toppa 270 e' presente
#      (merge-base esce 1 su entrambi, e la riga Remove-Item compare 0
#      volte nel loro driver). Quelle sette righe restano al loro pin per
#      mandato -- ma chi legge i loro CSV la mattina sappia che per loro
#      il falso positivo silenzioso e' ancora possibile, e che il
#      rilevatore di riserva sono le loro ancore (r132c deve riprodurre 5
#      celle di R123D, r136a la cella viva 237 / 1,20110 / 5,7325%).
# ---------------------------------------------------------------------
#  UNDICESIMO GIRO (12/09/2026) -- IL PIN SI MUOVE PERCHE' IL DRIVER HA
#  UNA DIRETTIVA NUOVA: '@FRAZIONEIS'. Non e' un file prova nuovo.
#
#  IL BUCO CHE CHIUDE. Su QUESTA corsia il driver NON riceve
#  -Simbolo, -Periodo, -DaQuando, -Fino, -FrazioneIS: guarda la riga $arg
#  piu' sotto, e la stessa cosa vale per RIGA_ROUND_VPS.ps1 r.646-650.
#  Cioe': le direttive del file prova sono l'UNICO canale esistente per
#  l'identita' della finestra, e fino a ieri erano QUATTRO su cinque --
#  @SIMBOLO, @PERIODO, @DAQUANDO, @FINOA. Il taglio IS/OOS era il buco.
#  Costo misurato del buco: ~20 file prova (R128b/c/d/e, R129a/b/c,
#  R130a..e, R131a..h) dichiarano nei propri criteri -- congelati PRIMA
#  dei numeri, in prove\R128_USCITA_CRITERI.md r.236-271 -- un taglio a
#  0.50, e su questa corsia sarebbero girati a 0.40 (il default di
#  fabbrica) con l'etichetta dei criteri a 0.50: IS che finisce il
#  2025.06.09 invece del 2025.08.13, cioe' 65 giorni di calendario, 47
#  feriali, ~33 operazioni di differenza, IN SILENZIO.
#  Adesso il driver legge '@FRAZIONEIS' dal file prova, e se la riga di
#  lancio ne passa un altro MUORE invece di scegliere.
#
#  >>> L'IMPRONTA DEL DRIVER CAMBIA, ed e' giusto cosi':
#      $SHA_WALK passa da 62A53763...F7CBB7BC a BF53EC27...FAF59875.
#      Se leggete ancora la vecchia, il pin punta a un driver SENZA la
#      direttiva e lo scarico muore sull'impronta: il fallimento giusto.
#      $SHA_ROUND invece NON e' stata toccata -- ed e' stata RICALCOLATA
#      sul blob del pin nuovo per dirlo, non assunta: 348ED533... a
#      115254dc e' identica a 348ED533... a e6c0d70e.
#
#  IL PIN NUOVO E' 115254dc, E LE VERIFICHE SONO STATE FATTE VIA raw,
#  non solo su git (il runner scarica da raw, non da git):
#      driver @115254dc            -> HTTP 200, 102.955 byte
#      sha256 di cio' che ARRIVA   -> BF53EC27...FAF59875  == $SHA_WALK
#      sha256 del blob git al pin  -> BF53EC27...FAF59875  (combaciano)
#      MARCATORE_..._v5_INCLUDE nel file SCARICATO -> presente (x2)
#      i file prova @115254dc      -> HTTP 200
#  E IL CONTRO-ESEMPIO, altrimenti quei "combacia" non valgono niente:
#  al pin PRECEDENTE e6c0d70e la stringa 'FRAZIONEIS' compare ZERO volte
#  nel driver e il suo sha e' 62A53763..., diverso. Il controllo
#  distingue i due casi, quindi il suo "uguale" dice qualcosa.
#
#  >>> IL MARCATORE CHE QUESTA CORSIA CONTROLLA NON E' CAMBIATO. <<<
#  $MARC_WALK resta MARCATORE_WALKFORWARD_GENERICO_v5_INCLUDE: nel driver
#  e' stato AGGIUNTO un v6_FRAZIONEIS ACCANTO, non al posto del v5. I
#  marcatori sono additivi (dottrina scritta nel driver r.153-171): il v5
#  promette gli #include, e quella promessa e' ancora vera.
#
#  >>> E LE 19 RIGHE IN CODA NON SONO TOCCATE, ED E' VOLUTO. <<<
#  CODA.txt pinna questa riga sottile a 1445abf8, cioe' a una COPIA
#  CONGELATA che porta $PIN = e6c0d70e: i 19 round di stanotte scaricano
#  il driver SENZA '@FRAZIONEIS' e girano identici a come sono stati
#  collaudati. Non e' una dimenticanza: NESSUNO dei 19 file prova
#  dichiara '@FRAZIONEIS' (verificato col grep: zero su 675 file prova
#  dell'intero repo), quindi portarceli dentro non porterebbe NIENTE e
#  rischierebbe 19 round che girano bene cosi'.
#  Chi un giorno vorra' portare '@FRAZIONEIS' in coda faccia l'ordine
#  giusto, e si sbaglia una volta sola:
#      1. PRIMA questa riga sottile ($PIN + $SHA_WALK), commit, push
#      2. POI la colonna dei pin in CODA.txt, sul commit che contiene
#         la riga nuova
#  Mai il contrario: al contrario le righe muoiono su $SHA_WALK -- che e'
#  il modo GIUSTO di rompersi, ma resta un round perso e una notte buttata.
#  Referto: report\FRAZIONEIS_APPLICATA_2026-09-12.md
# ---------------------------------------------------------------------
#  DODICESIMO GIRO (12/09/2026) -- IL CANARINO DI @FRAZIONEIS ENTRA IN CODA
#
#  PERCHE': la toppa '@FRAZIONEIS' ha un PASS da tutti e due gli strati
#  del cancello, ma il cancello aveva dichiarato un NON COPERTO che era
#  l'unico che contava: la CATENA VERA (scarico da raw -> controllo
#  d'impronta -> driver) non era MAI stata girata con la direttiva dentro.
#  Questo giro serve a UN round di collaudo che gira con -SoloControllo e
#  quindi NON fa girare il tester: zero passate, zero CSV, zero secondi
#  sottratti ai round veri, nessun terminale MT5 toccato.
#      file prova: backtest_pipeline\prove\CANARINO_FRAZIONEIS_D30EUR.txt
#      attesa DICHIARATA PRIMA, e sono DUE uscite DIVERSE:
#        direttiva ONORATA  -> IS 2024.09.26 - 2025.08.13
#        direttiva IGNORATA -> IS 2024.09.26 - 2025.06.09
#      65 giorni di differenza: le due uscite NON sono confondibili, ed e'
#      questo che rende il canarino una MISURA e non una conferma. Le due
#      date non sono inventate qui: le dichiara da giorni la sezione dei
#      criteri di backtest_pipeline\prove\R128b_bersaglio_D30EUR.txt.
#
#  >>> E IL MOTIVO PER CUI QUESTO GIRO DI PIN E' OBBLIGATORIO, misurato
#      il 12/09/2026 con un 404 in faccia. <<<
#  UN $PIN SERVE DUE COSE, NON UNA. Oltre al driver, da qui viene anche
#  IL FILE PROVA: RIGA_ROUND_VPS.ps1 costruisce il suo $RawBase sul -Pin
#  che gli passiamo qui sotto, e da LI' scarica sia
#  walkforward_generico.ps1 sia backtest_pipeline/prove/<Prova>.
#  Quindi un file prova NUOVO non e' raggiungibile da un pin VECCHIO:
#      canarino @115254dc (il pin dell'11o giro) -> HTTP 404
#      R128b    @115254dc                        -> HTTP 200
#  Il secondo e' il CONTRO-ESEMPIO, e senza di lui il 404 non direbbe
#  niente: stessa URL, stesso pin, stesso percorso, uno c'e' e uno no.
#  Quindi a mancare e' IL PIN, non la rete e non il nome del file.
#  >>> CHI AGGIUNGE UN FILE PROVA NUOVO DEVE FARE QUESTO GIRO. SEMPRE. <<<
#
#  I VALORI CAMBIATI SONO DUE, E SERVONO TUTTI E DUE:
#   - $PIN -> b7979d8, il primo commit che contiene INSIEME il canarino e
#     il driver di HEAD.
#   - $SHA_WALK -> 15DE7D5F...6828F1C6. E' CAMBIATA, e la ragione e'
#     innocua ma va detta: IL DRIVER A HEAD NON E' QUELLO DELL'11o GIRO.
#     Il commit f14831b ("classe 271 pagata") cambia CINQUE righe su
#     cinque e sono TUTTE COMMENTI -- citazioni di numero di riga
#     corrette. Misurato, non creduto: git diff 115254dc..HEAD sul driver,
#     righe non-commento cambiate = ZERO.
#     >>> CHI CAMBIA SOLO $PIN PERDE IL ROUND SULL'IMPRONTA. <<<
#   - $SHA_ROUND NON E' TOCCATA, e non e' un'assunzione: RIGA_ROUND_VPS.ps1
#     ha impronta 348ED533...9D0A315B identica al pin vecchio e al nuovo,
#     misurata sul file SCARICATO DA raw, con Get-FileHash.
#   - $MARC_WALK resta v5_INCLUDE. E la LISTA BIANCA sugli argomenti e la
#     function Pulito NON sono toccate di una virgola: la corsia ROUND
#     firmata l'11/09 accetta SOLO i sei argomenti (-Expert -Prova
#     -Etichetta -Modello -Deposito -SoloControllo), e questo giro non ne
#     aggiunge NESSUNO. Nessun perimetro allargato, nessuna firma nuova.
#
#  VERIFICHE VIA raw AL PIN NUOVO -- il runner scarica da raw, non da git,
#  e con Get-FileHash, che e' il comando di QUESTA corsia e non sha256sum:
#      driver     @b7979d8 -> HTTP 200  102.955 byte  15DE7D5F...6828F1C6
#      RIGA_ROUND @b7979d8 -> HTTP 200   44.054 byte  348ED533...9D0A315B
#      canarino   @b7979d8 -> HTTP 200    8.496 byte  D6D323F9...2580F75
#      marcatori v5 e v6 nel driver scaricato -> presenti entrambi
#      124db40 (classe 270) e 115254dc (11o giro) -> ANTENATI di b7979d8
#      Remove-Item dell'.ex5 nel driver scaricato -> presente (toppa 270)
#
#  >>> E LE 19 RIGHE ROUND IN CODA NON SONO TOCCATE. <<<
#  Restano pinnate a 1445abf8, cioe' a una COPIA CONGELATA di questo file
#  che porta il SUO $PIN e il SUO $SHA_WALK: quello che scrivo qui NON le
#  raggiunge. La riga del canarino e' una riga IN PIU', pinnata al commit
#  di questo giro, e sta PRIMA delle altre perche' il runner NON si ferma
#  su una riga che muore: ogni via di fallimento e' un 'continue', nel
#  ciclo della coda non c'e' nessun break e nessun exit, e non esiste
#  nessun tetto di righe ne' di tempo. Misurato su runner_abtg.ps1 il
#  12/09/2026, non intuito.
#
#  CLASSE 271, PAGATA IN ANTICIPO: in questo blocco NON cito nessun numero
#  di riga di QUESTO file. Inserire un commento sposta tutto cio' che sta
#  sotto, quindi una citazione 'r.N' scritta qui sarebbe falsa un minuto
#  dopo averla salvata. Si citano i FILE e i NOMI, che non si spostano.
#  Referto: report\CANARINO_FRAZIONEIS_2026-09-12.md
# ---------------------------------------------------------------------
# ---------------------------------------------------------------------
#  TREDICESIMO GIRO (12/09/2026) -- IL CANALE PER-TRADE PER L'n IN POSIZIONI
#
#  PERCHE': la corsia ROUND non aveva NESSUN canale per il per-trade --
#  'abtg_trades' ha ZERO occorrenze in runner_abtg.ps1, in questa riga
#  sottile e in RIGA_ROUND_VPS.ps1, mentre 36 script su 98 in righe\RIGA_*
#  lo raccolgono. Senza quel canale il requisito 2 del CERTIFICATO DI
#  MORTE (l'n dell'IS in POSIZIONI, non in deal -- classe 226) non si
#  chiude su ABTG_EMA200, che e' l'unica delle 41 sedie vive che passa i
#  cancelli di oggi alla lettera.
#
#  >>> UN SOLO VALORE CAMBIA: $PIN. <<<
#  $SHA_WALK, $SHA_ROUND, $MARC_WALK, il param() e la function Pulito NON
#  si toccano -- ed e' MISURATO, non assunto: al pin nuovo 69e252b il
#  driver fa sha256 15DE7D5F...6828F1C6 (= $SHA_WALK) e RIGA_ROUND_VPS
#  fa 348ED533...9D0A315B (= $SHA_ROUND). Se una delle due non
#  combaciasse, 'function Prendi' chiamerebbe Muori e OGNI round morirebbe
#  sull'impronta.
#
#  IL DIFETTO CHE QUESTO GIRO HA PAGATO, e vale piu' del giro (classe 278):
#  il file prova COLLAUDO_EMADOW_02, com'era, girava col DEFAULT 0.40 e
#  con un '@FINOA' messo sul primo giorno dell'OOS. Misurato col driver
#  vero scaricato da raw: OOS 2025.01.07 - 2025.06.10, cioe' 111 feriali
#  contro i 183 dell'IS = 60,66%. Il conteggio avrebbe dato 62/72/91/100
#  per un vero di 102/118/150/165: ZERO casi su quattro sopra 150,
#  COMPRESI I DUE IN CUI LA SEDIA PASSA. Una misura che non puo' dare una
#  risposta positiva non e' una misura: e' una condanna travestita da
#  test, e sarebbe arrivata con un referto verde.
#
#  E le due righe nuove vanno IN FONDO a CODA.txt, in quest'ordine:
#      1. il round 'cemad02' (produce i per-trade)
#      2. CODA_12_pertrade_posizioni.ps1 (li conta)
#  L'ordine NON e' estetico: la seconda legge cio' che la prima produce.
#  Il beneficio dell'ordine PER LA LETTURA e' invece ZERO (classe 274:
#  W() accumula in memoria, il referto nasce dopo la fine del ciclo).
#  Referto: report\EMA200_IS_IN_CODA_2026-09-12.md
#
#  >>> QUATTORDICESIMO GIRO (12/09/2026) -- SETTE FILE PROVA NUOVI. <<<
#  Prima era 69e252b3c4605ba316d28a572296e0c54841b25f (tredicesimo giro).
#  Cambia per la ragione di SEMPRE, quella scoperta da un 404 il 12/09:
#  il file prova lo scarica IL DRIVER, da QUESTO $PIN
#  (RIGA_ROUND_VPS.ps1 r.600). Un file prova che a questo pin non esiste
#  fa morire il round su un 404, e la notte e' persa. I sette che entrano
#  in coda con questo giro:
#      R137a_floorstop_allarga_770101_D30EUR.txt   (7 celle)
#      R137b_floorstop_salta_770101_D30EUR.txt     (7 celle)
#      R137c_parziale_770101_D30EUR.txt            (2 celle)  <<< il cancello
#      R138a_gemello_F40EUR_770101.txt             (2 celle)
#      R139a_EMA200_AUDJPY_H4_LS.txt               (4 celle)
#      R139b_EMA200_GBPUSD_H4_LS.txt               (4 celle)
#      R139c_FIBOH4_GBPUSD_unsimbolo.txt           (3 celle)
#  29 celle, 58 passate. Tutti e sette VERIFICATI a 200 su raw a questo
#  pin, e byte-identici alla copia locale; piu' due controlli NEGATIVI a
#  404 (nome inesistente allo stesso pin, e nome buono a un pin di zeri),
#  perche' senza quelli i 200 non dicono niente.
#
#  >>> UN SOLO VALORE CAMBIA, ANCHE QUESTA VOLTA: $PIN. <<<
#  $SHA_WALK e $SHA_ROUND NON si toccano, ed e' MISURATO PRIMA di
#  spostare il pin, non assunto. Al pin nuovo 23314d61:
#      walkforward_generico.ps1 -> 15DE7D5F...6828F1C6  (= $SHA_WALK)
#      RIGA_ROUND_VPS.ps1       -> 348ED533...9D0A315B  (= $SHA_ROUND)
#  misurate DUE volte e in DUE modi: sul blob git (git show | sha256sum)
#  e sul file SCARICATO DA raw a questo pin. Le quattro impronte
#  coincidono. Se una non combaciasse, 'function Prendi' chiamerebbe
#  Muori e OGNI round morirebbe sull'impronta -- compresi i 19 vecchi.
#  NIENTE ALTRO E' CAMBIATO: $MARC_WALK, $MARC_ROUND, il param(), la
#  function Pulito e il $BancoBT restano quelli letti a mano.
#
#  E LE SETTE RIGHE NUOVE VANNO **PRIMA** DI CODA_12, NON IN FONDO.
#  Non e' una preferenza, e' una misura: CODA_12 conta i per-trade che
#  trova in Common\Files, e li conta di TUTTI i round girati PRIMA di
#  lei. Messe prima, i sette si portano a casa GRATIS il conteggio in
#  POSIZIONI (classe 226: la colonna Trades conta i DEAL di uscita) e il
#  confronto dei GEMELLI di R138a. Messe dopo, CODA_12 non li vede.
#  Il beneficio dell'ordine PER LA LETTURA resta ZERO (classe 274).
#  Referto: report\SETTE_IN_CODA_2026-09-12.md
# ---------------------------------------------------------------------
# ---------------------------------------------------------------------
#  QUINDICESIMO GIRO (12/09/2026 sera) -- I QUATTRO EA MAI GIRATI
#
#  PERCHE': quattro motori scritti fra il 22/08 e l'08/09 non sono mai
#  stati interrogati nemmeno una volta, e nessuno aveva una riga in
#  REGISTRO_TEST.md: ne' vivi ne' morti, INVISIBILI.
#
#  IL PREREQUISITO CHE VIENE PRIMA DI TUTTO, trovato dal cancello prima
#  che da me: il driver scarica il FILE PROVA da $PIN, non dal branch.
#  I file R141 sono nati OGGI, dopo e6c0d70e, dopo 69e252b3 e dopo
#  23314d61 -- verificato con git cat-file: NON ESISTONO a nessuno dei
#  tre. Righe formalmente perfette avrebbero dato HTTP 404 = quattro
#  round morti e quattro buchi nel referto. E' lo stesso guasto pagato
#  due volte (i commenti sopra lo scrivono per R133a e R136a). Quindi
#  l'ordine e' questo, e si sbaglia una volta sola:
#      1. questa riga sottile ($PIN), commit, push
#      2. POI la colonna dei pin in CODA.txt, su QUEL commit
#
#  >>> UN SOLO VALORE CAMBIA: $PIN. <<<
#  MISURATO prima di spostarlo, non assunto: al pin nuovo 55f0eb1b il
#  driver fa sha256 15DE7D5F...6828F1C6 (= $SHA_WALK, INVARIATO),
#  RIGA_ROUND_VPS fa 348ED533...9D0A315B (= $SHA_ROUND, INVARIATO), e
#  tutti e quattro i file prova ci sono. Se una delle due impronte non
#  combaciasse, 'function Prendi' chiamerebbe Muori e OGNI round
#  morirebbe sull'impronta.
#  I SETTE round del quattordicesimo giro NON si muovono: la loro riga
#  di coda pinna 0c38419f, che porta $PIN=23314d61, congelato.
#
#  QUATTRO RIGHE, NON CINQUE. R141e (daxva) e' FUORI, e il motivo e' un
#  numero: il suo falsificatore non falsifica. A edge ZERO il PF SALE
#  monotono del 18% per sola geometria e pedaggio (il costo vale il
#  21,3% dello stop sulla cella 800 e il 2,5% sulla 6800), quindi "il PF
#  sale col buffer" NON distingue la legge dell'ancora unica dal costo:
#  i due spingono in versi opposti e si sottraggono. Rientra domani con
#  la toppa del gradiente nullo, gia' scritta nel file.
# ---------------------------------------------------------------------
#
#  SEDICESIMO GIRO (13/09/2026, notte). $PIN 55f0eb1b -> 41c635f8.
#  Il commit nuovo aggiunge SOLO tre file prova (R142a/b/c, gli assi
#  d'USCITA sulla pre-apertura del Nasdaq). Nessun'altra riga cambia.
#  MISURATO prima di spostarlo, non assunto, al pin nuovo 41c635f8:
#      driver         sha256 15DE7D5F...6828F1C6  (= $SHA_WALK, INVARIATA)
#      RIGA_ROUND_VPS sha256 348ED533...9D0A315B  (= $SHA_ROUND, INVARIATA)
#      marcatori v5_INCLUDE e RIGA_ROUND_VPS_v1   presenti
#      i tre file prova nuovi                     presenti (git cat-file -e)
#      55f0eb1b e' ANTENATO di 41c635f8           (git merge-base, exit 0)
#  Le impronte restano le stesse perche' il commit NON tocca ne' il
#  driver ne' RIGA_ROUND_VPS: se una delle due si muovesse, 'function
#  Prendi' chiamerebbe Muori e OGNI round morirebbe sull'impronta.
#  E le 45 RIGHE GIA' IN CODA NON SI MUOVONO: ognuna pinna il PROPRIO
#  commit di questa riga sottile (1445abf8 per i 19, 84999392 per la
#  canarina, 8d9d4fb9, 0c38419f, ab1a206f), che porta il PROPRIO $PIN
#  congelato. Solo le TRE righe nuove pinnano il commit di questo giro.
# ---------------------------------------------------------------------
#
#  DICIASSETTESIMO GIRO (13/09/2026, notte). $PIN 41c635f8 -> c5a7d225.
#  Obbligato: il driver prende il file prova DA $PIN, quindi coi file
#  vecchi al pin vecchio girerebbe la VERSIONE SBAGLIATA. I tre R142
#  sono stati riscritti dopo un FAIL del cancello (classi 299 e 300:
#  un asse con due celle identiche per costruzione, e un falsificatore
#  che scattava sull'ipotesi VERA). Il commit nuovo tocca SOLO quei tre
#  file prova.
#  MISURATO al pin nuovo c5a7d225, non assunto:
#      driver         sha256 15DE7D5F...6828F1C6  (= $SHA_WALK, INVARIATA)
#      RIGA_ROUND_VPS sha256 348ED533...9D0A315B  (= $SHA_ROUND, INVARIATA)
#      i tre file prova                           presenti (git cat-file -e)
#      41c635f8 e' ANTENATO di c5a7d225           (git merge-base, exit 0)
#  Le righe gia' in coda non si muovono: ognuna pinna il PROPRIO commit
#  di questa riga sottile, che porta il PROPRIO $PIN congelato.
# ---------------------------------------------------------------------
$PIN = 'c5a7d225513415445125254b377b5bc1bbe6a543'

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
#    UNDICESIMO GIRO (12/09/2026): RICALCOLATA. Prima era
#    62A53763...F7CBB7BC (decimo giro: la toppa classe 270, l'.ex5
#    stantio cancellato prima di compilare), e prima ancora
#    02E2FE8F...9ECF3FEA. E' cambiata perche' il driver ha una direttiva
#    NUOVA, '@FRAZIONEIS', che porta il taglio IS/OOS dentro l'identita'
#    della cella: era l'ultimo pezzo di quell'identita' che su questa
#    corsia non aveva un canale, perche' -FrazioneIS qui non si passa.
#    La toppa 270 resta dentro: il pin nuovo 115254dc e' DISCENDENTE del
#    decimo giro, non un ramo diverso (verificato:
#    git merge-base --is-ancestor 124db40 115254dc -> 0, e nel driver
#    scaricato da raw la riga Remove-Item dell'.ex5 compare 1 volta).
#    Per le 19 righe in coda non cambia NIENTE: sono pinnate a 1445abf8,
#    che porta il $PIN vecchio -- vedi il blocco dell'undicesimo giro.
#    DODICESIMO GIRO (12/09/2026): RICALCOLATA. Prima era
#    BF53EC27...FAF59875 (undicesimo giro). E' cambiata SOLO perche' il
#    commit f14831b ha corretto CINQUE CITAZIONI DI NUMERO DI RIGA nei
#    commenti del driver (classe 271: una citazione 'r.N' vale solo prima
#    di se stessa). Righe NON-commento cambiate: ZERO, misurato con
#    git diff. Il comportamento del driver e' identico al byte di codice.
#    Ricalcolata sul file SCARICATO DA raw al pin nuovo con Get-FileHash
#    -- non sulla copia locale, e non con sha256sum, che e' un altro
#    comando e un altro formato.
$SHA_WALK  = '15DE7D5F5A342BB3D2DFEFCE8C970AA93C440B25DE136AFC050ED5B66828F1C6'

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
