# =====================================================================
#  MARCATORE_RIGA_DEPLOY_GUARDIAN_CONTOREALE_v1
#  RIGA_DEPLOY_GUARDIAN_CONTOREALE.ps1 -- INSTALLA E COMPILA IL
#  GUARDIANO DI PORTAFOGLIO sul SOLO terminale del conto REALE, il cui
#  numero lo deve dire CLAUDIO con -LoginAtteso.
#
#  >>> QUESTO EA E' DIVERSO DA TUTTI QUELLI INSTALLATI FINORA SUL REALE,
#      E VA DETTO SUBITO, PRIMA DI OGNI ALTRA COSA:
#      - ABTG_SlippageLogger (05/09) era di SOLA LETTURA: le funzioni
#        per mandare un ordine NON esistevano nel sorgente.
#      - ABTG_DAX_Apertura_EU e ABTG_ORB_Ottimizzato (06/09) APRONO
#        ordini, ma ognuno gestisce SOLO le proprie posizioni (il
#        proprio magic).
#      - QUESTO no. Con InpAction=0 e InpCloseAllMagics=true il Guardian
#        CHIUDE TUTTE LE POSIZIONI E CANCELLA TUTTI I PENDENTI DEL
#        CONTO, di QUALSIASI magic -- quindi ANCHE le posizioni aperte
#        A MANO da Claudio (magic 0). E' un potere che nessun altro EA
#        sul conto reale ha, ed e' esattamente il motivo per cui lo si
#        installa: oggi sul reale non c'e' NESSUNA rete a livello di
#        conto, solo il rischio per-trade dentro i due preset.
#
#  >>> 06/09 -- DA QUESTO GIRO NON E' PIU' UN'INSTALLAZIONE NUOVA: E' UN
#      AGGIORNAMENTO DI SICUREZZA, v1.11 -> v1.12. E cambia due cose
#      pratiche, tutte e due da sapere PRIMA di lanciare.
#      IL PERCHE', in breve: sul conto reale c'e' un CREDITO del broker di
#      2.500 EUR (stabile, non prelevabile) che si somma all'EQUITA' ma non
#      al BILANCIO. La v1.11 catturava il saldo di riferimento e la
#      baseline del giorno dal BILANCIO, e li confrontava con l'EQUITA':
#      il credito faceva da cuscinetto finto e costante: con bilancio 5.000
#      e credito 2.500, la pausa al 4,9% e il blocco al 9,9% non sarebbero
#      scattati fino a una perdita VERA di oltre 2.700/3.000 EUR, cioe'
#      oltre meta' del capitale. La rete c'era ma quasi non mordeva.
#      LE DUE CONSEGUENZE PRATICHE:
#       1. IL GUARDIANO E' GIA' SU UN GRAFICO VIVO di quel terminale.
#          Va STACCATO A MANO PRIMA della CORSA (tasto destro sul suo
#          grafico > Expert Advisors > Rimuovi), se no Windows tiene il
#          suo .ex5 aperto e la CORSA si ferma da sola al momento di
#          sostituirlo. Fermarsi li' e' il comportamento GIUSTO, non un
#          guasto: si rimette tutto com'era e si rilancia dopo aver
#          staccato. C'e' anche una SONDA che lo dice gia' in CONTROLLO.
#       2. IL GATE DI VERSIONE ORA PRETENDE LA 1.12 E RIFIUTA LA 1.11 PER
#          NOME -- perche' la 1.11 e' esattamente il file col bug che
#          stiamo togliendo, e un pin vecchio lo rimetterebbe dentro.
#          E siccome '#property version' e' solo una stringa, si
#          verificano anche le TRACCE VERE del fix nel codice: baseline
#          presa dall'EQUITA' e le cinque GlobalVariable della baseline
#          rinominate _V2 (senza il rinomino il guardiano rileggerebbe il
#          numero vecchio contaminato e il fix non prenderebbe).
#
#  >>> COSA INSTALLA, E DOVE (solo in modo CORSA, e SOLO li'): TRE FILE.
#        <dati>\MQL5\Experts\ABTG_Guardian.mq5           (v1.12)
#        <dati>\MQL5\Experts\ABTG_Guardian.ex5           (compilato qui)
#        <dati>\MQL5\Presets\ABTG_Guardian_REALE.set
#      TRE, NIENT'ALTRO. Nessun .chr, nessun .ini, nessun profilo,
#      nessuna GlobalVariable, e -- differenza voluta dal deploy di
#      stamattina -- NEMMENO l'include.
#
#  >>> L'INCLUDE NON SI RISCRIVE: SI VERIFICA. E' la scelta piu'
#      importante di questa riga, e il motivo e' misurabile.
#      ABTG_PausaGuardian.mqh e' gia' in quel terminale (messo stamattina
#      col deploy delle due sedie), e i DUE .ex5 GIA' IN CAMPO sono stati
#      compilati CONTRO QUEL FILE. Riscriverlo vorrebbe dire cambiare la
#      dipendenza sotto i piedi a due binari vivi. Allora:
#        - se manca            -> FATALE (e vuol dire terminale sbagliato);
#        - se c'e' ma il suo sha256 e' DIVERSO da quello al pin -> FATALE
#          (o il pin e' sbagliato, o qualcuno ha toccato il terminale:
#          in tutti e due i casi, su un conto vero, un "boh" vale un no);
#        - se e' identico      -> NON LO TOCCO, e lo dichiaro nel referto.
#      E' anche la conferma incrociata piu' forte che si potesse mettere:
#      quel file, con quei byte esatti, ce l'ha messo la nostra riga.
#
#  >>> IL FILO, VERIFICATO A TAVOLINO PRIMA DI INSTALLARE. Il guardiano
#      SCRIVE su nomi di GlobalVariable costruiti dentro ABTG_Guardian.mq5;
#      gli EA LEGGONO da nomi costruiti dentro ABTG_PausaGuardian.mqh.
#      Sono DUE POSTI DIVERSI: se divergono, il canale muore in SILENZIO
#      (il guardiano scrive, nessuno legge, nessun errore da nessuna
#      parte). Il sorgente ha una VerificaFilo() che se ne accorge a
#      RUNTIME; qui i cinque nomi si confrontano PRIMA, sui due file
#      scaricati al pin, e se non coincidono NON SI INSTALLA.
#
#  >>> QUELLO CHE QUESTA RIGA NON FA, E NON PUO' FARE:
#      - NON ATTACCA MAI L'EA A UN GRAFICO. Non esiste in questo file
#        nessun percorso che scriva dentro Profiles\Charts o config\:
#        il gesto di trascinare l'EA sul grafico e caricare il preset
#        e' MANUALE, di Claudio, con la legge dello screenshot. Che i
#        grafici non siano stati toccati lo DIMOSTRA una foto
#        (conteggio, byte, ultima scrittura) prima e dopo. E qui pesa
#        il doppio: finche' il Guardian non e' su un grafico, non puo'
#        chiudere niente a nessuno.
#      - NON TOCCA L'AUTOTRADING. Non c'e' nessun modo di accenderlo da
#        qui, e non ci si prova.
#      - NON TOCCA I TRE EA GIA' IN CAMPO su quel conto
#        (ABTG_SlippageLogger, ABTG_DAX_Apertura_EU, ABTG_ORB_Ottimizzato)
#        ne' l'include: i loro file sono FOTOGRAFATI prima e dopo e
#        devono risultare INVARIATI. Il REGISTRO del logger in MQL5\Files
#        invece puo' benissimo crescere durante il giro (scrive ogni 10
#        secondi a MT5 aperto): quello e' ATTESO, non un problema --
#        pretendere che un file vivo non cambi sarebbe un controllo finto.
#      - NON CANCELLA NESSUNA GlobalVariable. Quelle del guardiano
#        (ABTG_GUARD_<login>_*) nascono al primo avvio dell'EA sul
#        grafico, cioe' DOPO, per mano di Claudio.
#
#  >>> LA GUARDIA SUL CONTO E' LA STESSA DELLE DUE RIGHE DI STAMATTINA,
#      PAROLA PER PAROLA:
#      1. -LoginAtteso E' OBBLIGATORIO. Senza, la riga non parte.
#      2. IL PICCOLO 50503392 E IL 100k 50504263 SONO VIETATI PER
#         SEMPRE, e non c'e' nessuna manopola che li sblocchi. Se
#         -LoginAtteso e' uno di quei due, la riga si ferma subito. Se
#         una cartella candidata mostra uno di quei due login nei log,
#         la cartella e' SCARTATA -- anche se ci fosse dentro pure il
#         login atteso, perche' un terminale che ha visto tutti e due
#         non dice a quale conto e' collegato ADESSO.
#         E il motivo, QUI, e' piu' grosso che per le sedie: sul demo
#         100k gira gia' un Guardian (magic 779001) per il dry-run FTMO.
#         Due guardiani sullo stesso conto vorrebbe dire due FlattenAll
#         che si accavallano.
#      3. IL LOGIN ATTESO DEVE COMPARIRE NEI LOG della cartella scelta
#         (finestra di 180 giorni, larga apposta).
#      4. Se il login atteso NON si trova, la riga si FERMA e stampa
#         tutto quello che ha guardato. Si va avanti solo con
#         l'ATTESTAZIONE A MANO -- -CartellaDati "<percorso>" e
#         -ConfermoConto <lo stesso numero> -- cioe' scrivendo il
#         numero DUE VOLTE. E' una firma, non una scorciatoia, e il
#         referto la scrive come "SCELTA ATTESTATA A MANO, NON
#         MISURATA". Il punto 2 resta valido lo stesso.
#      5. CONFERMA INCROCIATA, piu' severa di stamattina: nella cartella
#         scelta devono gia' esserci il LOGGER e LE DUE SEDIE, e nei
#         loro .mq5 devono comparire i magic 770101 e 770611. Se manca
#         qualcosa e' un RILIEVO FORTE (non un blocco: potrebbero stare
#         altrove), e va letto PRIMA di andare avanti.
#
#  >>> I GATE SUL PRESET SONO LA PARTE CHE VALE DI PIU'. Qui il .set non
#      decide "quanti soldi si rischiano a ogni trade": decide QUANDO IL
#      CONTO VIENE SVUOTATO D'AUTORITA'. Viene APERTO E CONTATO:
#      a) ogni riga dev'essere vuota, un commento ';' oppure un
#         'chiave=valore' con chiave che e' un identificatore. Una riga
#         malformata NON e' innocua: MT5 la salta in silenzio;
#      b) OGNI CHIAVE dev'essere un input DAVVERO DICHIARATO nel .mq5
#         allo stesso pin;
#      c) OGNI INPUT del .mq5 dev'essere presente nel .set (copertura
#         TOTALE, 16 su 16). Un input che manca prende il DEFAULT
#         COMPILATO, in silenzio: e' la trappola del 2% chiusa il 02/09.
#         E qui il danno sarebbe peggiore -- InpAutotest mancava proprio
#         nel preset FTMO, e un domani potrebbe mancarci InpAction;
#      d) i VALORI FIRMATI, uno per uno ed ESATTI: 4.9 / 9.9 / statico /
#         reset 23 / pausa 4.0 / cap 3.25 / modo rischio 0;
#      e) InpAction=0 (enforce) e InpCloseAllMagics=true: un guardiano
#         in "solo allarme" su un conto vero non e' una rete;
#      f) InpStartBalance=0 e MAI 100000 (quello era il finto saldo
#         della challenge FTMO simulata sul demo: su 7.500 EUR veri
#         darebbe soglie 50 volte piu' larghe, cioe' NESSUNA rete);
#      g) COERENZA: pausa < emergenza giornaliera < DD totale. Se la
#         pausa morbida non sta sotto l'emergenza, non frena mai prima;
#      h) InpMagic ESATTAMENTE 779002, e DIVERSO da 770101, 770611 e
#         779001 (il Guardian del dry-run FTMO sul demo);
#      i) e i DEFAULT COMPILATI nel .mq5 devono essere gia' sicuri
#         (InpAction 0, CloseAllMagics true, giornaliero <= 5.0, totale
#         <= 10.0), cosi' anche un RIPRISTINA fatto per sbaglio sulla
#         finestra dei parametri non spegne la rete.
#
#  >>> MT5 PUO' RESTARE APERTO (il logger continua a misurare e le due
#      sedie restano al loro posto). METAEDITOR si PRETENDE CHIUSO: e'
#      single-instance e con l'editor aperto la compilazione da riga di
#      comando torna muta (misurato il 22/08).
#
#  >>> TUTTO O NIENTE. Se la compilazione fallisce, TUTTI E TRE i file
#      tornano com'erano. Mezzo deploy di un guardiano e' peggio di
#      nessun guardiano: un .set senza .ex5 e' un invito a caricare
#      parametri su un EA che non c'e'.
#
#  >>> IL VERDETTO STA SULL'ARTEFATTO, NON SUL CODICE DI USCITA (classe
#      108): metaeditor64 sul VPS torna 1 anche quando compila.
#
#  >>> LE TRE CORREZIONI DEL CONTROLLO A MASSIMA SEVERITA' DI STAMATTINA
#      (classi 94-ter e 116-quater) SONO DENTRO FIN DALLA PRIMA RIGA,
#      non aggiunte dopo:
#       - ogni campo del referto che riguarda un tentativo rischioso si
#         TIMBRA PRIMA del tentativo, mai dopo (se l'invocazione di
#         MetaEditor esplode, il referto non deve dire "non ci siamo
#         arrivati" mentre nel terminale ci sono gia' dei file);
#       - il ripristino si comanda dal REGISTRO DELLE SCRITTURE (backup
#         + sentinella, scritti PRIMA della prima copia), MAI da una
#         bandiera alzata DOPO la Copy-Item;
#       - anche il ramo "il ripristino stesso e' esploso" ha la sua
#         frase gia' scritta prima di partire.
#
#  QUANTO CI METTE [STIMA]: 1-3 minuti (2 download + 1 compilazione).
#
#  LA RIGA CHE SI INCOLLA sta in
#  righe\RIGA_DEPLOY_GUARDIAN_CONTOREALE_DA_MANDARE.md
# =====================================================================
[CmdletBinding()]
param(
  # -Pin NON ha default: un default silenzioso ("lavoro") farebbe girare
  #  la punta del branch spacciandola per un commit congelato.
  [string]$Pin = "",
  # -LoginAtteso NON ha default, ed e' OBBLIGATORIO.
  [string]$LoginAtteso = "",
  [ValidateSet("CONTROLLO","CORSA")]
  [string]$Modo = "CONTROLLO",
  [string]$CartellaDati = "",
  # -ConfermoConto: l'attestazione a mano. Lo stesso numero di
  #  -LoginAtteso, e serve SOLO quando il login non si trova nei log.
  #  Non sblocca i conti vietati.
  [string]$ConfermoConto = "",
  [string]$BaseAttesa = "",
  [int]$TimeoutSec = 240
)
$ErrorActionPreference = "Stop"
[Threading.Thread]::CurrentThread.CurrentCulture   = [Globalization.CultureInfo]::InvariantCulture
[Threading.Thread]::CurrentThread.CurrentUICulture = [Globalization.CultureInfo]::InvariantCulture
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$INV = [Globalization.CultureInfo]::InvariantCulture

# --- IL GUARDIANO ----------------------------------------------------
$EA      = "ABTG_Guardian"
# VERSIONE PRETESA: 1.12, e il numero NON e' decorativo.
# La 1.11 e' quella che sta GIA' sul conto reale, ed e' quella COL BUG
# del credito: se il pin puntasse ancora a lei, questa riga rimetterebbe
# nel terminale esattamente il file che stiamo sostituendo. Il gate piu'
# sotto la rifiuta per nome, e insieme a lei si pretendono le due tracce
# VERE del fix (baseline dall'equita' + GlobalVariable rinominate _V2):
# la versione da sola e' una stringa, e una stringa si puo' alzare senza
# aver corretto niente.
$VER     = "1.12"
$VER_KO  = "1.11"        # la versione col bug: si nomina, per poterla RIFIUTARE per nome
$MAGIC   = "779002"
$SET     = "ABTG_Guardian_REALE.set"
# ATTENZIONE AL NOME DI QUESTA VARIABILE -- 06/09, difetto TROVATO SUL BANCO.
# Si chiamava $AVVIO, e PowerShell NON distingue le maiuscole nei nomi delle
# variabili: era quindi LA STESSA VARIABILE di $Avvio = Get-Date, qualche riga
# piu' sotto, che la sovrascriveva con la data. Risultato: nel referto, il
# punto che dice a Claudio QUALE RIGA cercare nella scheda Esperti stampava
# una data al posto della riga. Nessun pericolo per il conto -- ma era
# un'istruzione sbagliata proprio nel passo di verifica. Ora il nome e' unico.
$RIGA_AVVIO = "[GUARDIAN] avviato. Saldo iniziale="

# --- L'INCLUDE: si VERIFICA, non si riscrive -------------------------
$INC     = "ABTG_PausaGuardian.mqh"

# --- CHI C'E' GIA' SU QUEL TERMINALE (conferma incrociata, sola lettura)
$LOGGER  = "ABTG_SlippageLogger"
$SEDIA1  = "ABTG_DAX_Apertura_EU"
$SEDIA1M = "770101"
$SEDIA2  = "ABTG_ORB_Ottimizzato"
$SEDIA2M = "770611"

# --- I NUMERI FIRMATI DA CLAUDIO IL 18/08/2026 -----------------------
# CLAUDE.md, "CRITERIO DI USCITA DELLE SEDIE": cap rischio aperto 3,25%
# (C1) e pacchetto Guardian (pausa 4,0 / emergenza 4,9 e 9,9 / reset 23).
# NON sono numeri scelti oggi: sono la politica di rischio di casa.
$A_DAILYLOSS = 4.9
$A_TOTALDD   = 9.9
$A_DDMODE    = "0"
$A_RESETHOUR = "23"
$A_PAUSA     = 4.0
$A_CAP       = 3.25
$A_RISKMODE  = "0"
$A_ACTION    = "0"        # 0 = CHIUDI+BLOCCA. 1 sarebbe "solo allarme".
$A_STARTBAL  = 0.0        # 0 = cattura il saldo vero. MAI 100000.
# TETTI INVALICABILI: anche un preset "quasi giusto" non deve poter
# allargare la rete oltre il muro classico 5% / 10%.
$T_DAILYLOSS = 5.0
$T_TOTALDD   = 10.0
$T_CAP       = 5.0
# IL MAGIC DEL DRY-RUN FTMO SUL DEMO: qui NON si usa, cosi' la cronologia
# dice sempre QUALE guardiano ha chiuso cosa.
$MAGIC_FTMO  = "779001"

# I DUE CONTI VIETATI: i due DEMO della flotta. Su quello da 100k gira
# gia' un Guardian per il dry-run FTMO: due guardiani sullo stesso conto
# vorrebbe dire due FlattenAll che si accavallano.
$VIETATI_CONTI = @("50503392","50504263")

# I CINQUE FILI del canale guardiano -> EA. Il guardiano scrive
# "<radice>_<login>", l'include legge ABTG_GVNome("<radice>") che vale
# StringFormat("%s_%I64d",radice,login). Se un nome diverge, il canale
# muore in silenzio: si confronta PRIMA di installare.
$FILI = @("ABTG_PAUSA_GIORNO","ABTG_PAUSA_FINO","ABTG_CAP_RISCHIO","ABTG_RISCHIO_APERTO","ABTG_GUARDIAN_BATTITO")

$Avvio = Get-Date
$Stamp = $Avvio.ToString("yyyyMMdd_HHmm", $INV)

function TrovaDesktop(){
  foreach($p in @([Environment]::GetFolderPath("Desktop"),
                  (Join-Path $env:USERPROFILE "Desktop"),
                  (Join-Path $env:USERPROFILE "OneDrive\Desktop"))){
    if($p -and (Test-Path -LiteralPath $p)){ return $p }
  }
  return $env:USERPROFILE
}
$Dsk        = TrovaDesktop
$Work       = Join-Path $env:USERPROFILE "abtg_deploy_guardian"
$Scaricati  = Join-Path $Work "scaricati"
$Sentinella = Join-Path $Work "DEPLOY_GUARDIAN_IN_CORSO.txt"
$LogPath    = Join-Path $Work "COMPILAZIONE_GUARDIAN.log"
$RawPin     = ""

# --- ogni campo che la raccolta stampa nasce QUI, PRIMA del try, e
#     parte da uno stato VERO ("non ci siamo arrivati"), mai da uno
#     stato che somigli a un risultato (classe 125).
$Problemi   = New-Object System.Collections.ArrayList
$Rilievi    = New-Object System.Collections.ArrayList
$Cand       = New-Object System.Collections.ArrayList
$righeC     = New-Object System.Collections.ArrayList
[void]$righeC.Add("CARTELLE GUARDATE: nessuna scansione (il giro si e' fermato prima di cercare la cartella dati)")
$Fatale     = ""
$Comp       = "NON TENTATA (non ci siamo arrivati)"
$Result     = "NON LETTA"
$Rc         = "NON LETTO"
$InstallTxt = "NON AVVENUTA (il giro si e' fermato prima di scrivere nel terminale)"
$BackupTxt  = "NON FATTO (non ci siamo arrivati)"
$Ripristino = "niente da ripristinare (il terminale non e' mai stato scritto)"
$Scelta     = "NON SCELTA"
$Criterio   = "n/d"
$Inst       = "n/d"
$Me         = ""
$SorgTxt    = New-Object System.Collections.ArrayList
$SetTxt     = New-Object System.Collections.ArrayList
$GateTxt    = New-Object System.Collections.ArrayList
$FiloTxt    = "NON VERIFICATO (non ci siamo arrivati)"
$DemoTxt    = "NON VERIFICATO (non ci siamo arrivati)"
$ParamTxt   = "NON VERIFICATO (non ci siamo arrivati)"
$PresetsTxt = "NON VERIFICATO (non ci siamo arrivati)"
$VicinieTxt = "NON VERIFICATO (non ci siamo arrivati)"
$IncludeTxt = "NON VERIFICATO (non ci siamo arrivati)"
$GiaLi      = "NON VERIFICATO"
$ContoTxt   = "NON MISURATO"
$BasiTxt    = "bases\ della cartella scelta: NON LETTE (il giro si e' fermato prima di sceglierla)"
$CoinquiTxt = "NON VERIFICATO"
$Ex5Aperto  = "NON MISURATO (il giro si e' fermato prima di guardare l'.ex5 del guardiano)"
$SetCopiato = $false
$BackupDir  = ""
$Reale      = $null
$DemoCand   = @()
$Art        = @()
$FotoP      = @{}
$FotoDemo   = New-Object System.Collections.ArrayList
$FotoDopo   = New-Object System.Collections.ArrayList
$FotoVic    = New-Object System.Collections.ArrayList
$DirParam   = @()
$FotoDirP   = @{}
$InvPreP    = @{}
$InvFileP   = @{}
$LogRighe   = @()
$FotoPrese  = $false
$MqlDir     = ""

function Ora(){ return (Get-Date).ToString("HH:mm:ss", $INV) }
function Dico([string]$t,[string]$c="Gray"){ Write-Host ("[" + (Ora) + "] " + $t) -ForegroundColor $c }
function Titolo([string]$t){ Write-Host ""; Write-Host ("=== " + $t + " ===") -ForegroundColor Cyan }

function Scarica([string]$url,[string]$dest){
  Remove-Item -LiteralPath $dest -Force -ErrorAction SilentlyContinue
  try{
    Invoke-WebRequest -Uri $url -OutFile $dest -UseBasicParsing -ErrorAction Stop
  }
  catch{
    throw ("SCARICO FALLITO da " + $url + " -- " + $_.Exception.Message +
           " | se e' un 404 su un pin appena creato: la cache di raw.githubusercontent dura qualche minuto, si aspetta e si rilancia LA STESSA riga (il pin non si cambia).")
  }
  if(-not (Test-Path -LiteralPath $dest)){ throw ("SCARICO FALLITO (nessun file scritto): " + $url) }
  if((Get-Item -LiteralPath $dest).Length -le 0){ throw ("SCARICO FALLITO (file vuoto): " + $url) }
}

function Hash16([string]$path){
  try{ return (Get-FileHash -LiteralPath $path -Algorithm SHA256).Hash.Substring(0,16) }catch{ return "n/d" }
}
function HashPieno([string]$path){
  try{ return (Get-FileHash -LiteralPath $path -Algorithm SHA256).Hash }catch{ return "" }
}
function Descrivi([string]$path){
  if(-not (Test-Path -LiteralPath $path)){ return "ASSENTE" }
  $i = Get-Item -LiteralPath $path
  return ("" + $i.Length + " byte, sha256 " + (Hash16 $path) + ", " + $i.LastWriteTime.ToString("yyyy-MM-dd HH:mm:ss",$INV))
}
# FOTO di un file: e' la prova. Si prende PRIMA e si RIFA' DOPO.
function Foto([string]$path){
  if([string]::IsNullOrEmpty($path)){ return [pscustomobject]@{ Esiste=$false; Len=-1; Ora="ASSENTE"; Hash="" } }
  if(-not (Test-Path -LiteralPath $path)){ return [pscustomobject]@{ Esiste=$false; Len=-1; Ora="ASSENTE"; Hash="" } }
  $i = Get-Item -LiteralPath $path
  return [pscustomobject]@{ Esiste=$true; Len=$i.Length; Ora=$i.LastWriteTime.ToString("yyyy-MM-dd HH:mm:ss",$INV); Hash=(Hash16 $path) }
}
function FotoTxt($f){
  if($null -eq $f){ return "NON PRESA" }
  if(-not $f.Esiste){ return "ASSENTE" }
  return ("presente, " + $f.Len + " byte, sha256 " + $f.Hash + ", " + $f.Ora)
}
function Confronta($a,$b){
  if($null -eq $a -or $null -eq $b){ return "NON CONFRONTABILE" }
  # DUE ASSENZE NON SONO UNA PROVA (classe 117): un file che non c'era e
  # non c'e' non si timbra INVARIATO, perche' quella parola in un referto
  # vuol dire "l'ho guardato ed era uguale".
  if(-not $a.Esiste -and -not $b.Esiste){ return "ASSENTE prima e dopo (niente da confrontare)" }
  if($a.Esiste -ne $b.Esiste -or $a.Len -ne $b.Len -or $a.Hash -ne $b.Hash){ return "CAMBIATO" }
  if($a.Ora -ne $b.Ora){ return "stessi byte, data diversa" }
  return "INVARIATO"
}
function FotoDir([string]$path){
  if(-not (Test-Path -LiteralPath $path)){ return "ASSENTE" }
  $f = @(Get-ChildItem -LiteralPath $path -Recurse -File -ErrorAction SilentlyContinue)
  $tot = 0
  $ult = "-"
  $max = $null
  foreach($x in $f){ $tot = $tot + $x.Length; if($null -eq $max -or $x.LastWriteTime -gt $max){ $max = $x.LastWriteTime } }
  if($null -ne $max){ $ult = $max.ToString("yyyy-MM-dd HH:mm:ss",$INV) }
  return ("" + $f.Count + " file, " + $tot + " byte, ultima scrittura " + $ult)
}
# INVENTARIO di una cartella FILE PER FILE. Serve dove la cartella DEVE
# cambiare (Presets: ci scriviamo il .set) e bisogna dimostrare che e'
# cambiato SOLO quello che dovevamo cambiare noi.
function Inventario([string]$path,[string]$filtro){
  $h = @{}
  if(-not (Test-Path -LiteralPath $path)){ return $h }
  $f = @()
  try{ $f = @(Get-ChildItem -LiteralPath $path -File -ErrorAction Stop | Where-Object { $_.Name -like $filtro }) }catch{ return $h }
  foreach($x in $f){ $h[$x.Name] = "" + $x.Length + "|" + (Hash16 $x.FullName) }
  return $h
}
function ConfrontaInventario($prima,$dopo,$attesi){
  $agg = New-Object System.Collections.ArrayList
  $cam = New-Object System.Collections.ArrayList
  $tolti = New-Object System.Collections.ArrayList
  foreach($k in $dopo.Keys){
    if(-not $prima.ContainsKey($k)){ [void]$agg.Add($k) }
    elseif($prima[$k] -ne $dopo[$k]){ [void]$cam.Add($k) }
  }
  foreach($k in $prima.Keys){ if(-not $dopo.ContainsKey($k)){ [void]$tolti.Add($k) } }
  $inattesi = New-Object System.Collections.ArrayList
  foreach($k in @($agg)){ $ok=$false; foreach($a in $attesi){ if($k -ieq $a){ $ok=$true } }; if(-not $ok){ [void]$inattesi.Add("AGGIUNTO " + $k) } }
  foreach($k in @($cam)){ $ok=$false; foreach($a in $attesi){ if($k -ieq $a){ $ok=$true } }; if(-not $ok){ [void]$inattesi.Add("CAMBIATO " + $k) } }
  foreach($k in @($tolti)){ [void]$inattesi.Add("SPARITO " + $k) }
  return [pscustomobject]@{ Agg=@($agg); Cam=@($cam); Tolti=@($tolti); Inattesi=@($inattesi) }
}
# Legge un file di testo qualunque sia la codifica (i log di MetaEditor
# sono UTF-16LE col BOM).
function LeggiTesto([string]$path){
  if(-not (Test-Path -LiteralPath $path)){ return @() }
  $b = [System.IO.File]::ReadAllBytes($path)
  if($b.Length -eq 0){ return @() }
  $txt = ""
  if($b.Length -ge 2 -and $b[0] -eq 255 -and $b[1] -eq 254){
    $txt = [System.Text.Encoding]::Unicode.GetString($b,2,$b.Length-2)
  }
  elseif($b.Length -ge 2 -and $b[0] -eq 254 -and $b[1] -eq 255){
    $txt = [System.Text.Encoding]::BigEndianUnicode.GetString($b,2,$b.Length-2)
  }
  elseif($b.Length -ge 3 -and $b[0] -eq 239 -and $b[1] -eq 187 -and $b[2] -eq 191){
    $txt = [System.Text.Encoding]::UTF8.GetString($b,3,$b.Length-3)
  }
  else{
    $zeri = 0
    $fin = [math]::Min($b.Length,400)
    for($i=1; $i -lt $fin; $i=$i+2){ if($b[$i] -eq 0){ $zeri++ } }
    if($zeri -gt ($fin/4)){ $txt = [System.Text.Encoding]::Unicode.GetString($b) }
    else{ $txt = [System.Text.Encoding]::UTF8.GetString($b) }
  }
  return @($txt -split "`r`n|`n|`r")
}

function CensisciInclude([string]$path){
  $trovati = New-Object System.Collections.ArrayList
  foreach($riga in (LeggiTesto $path)){
    $viva = ($riga -replace '//.*$','')
    $m = [regex]::Match($viva, '^\s*#include\s*[<"]([^>"]+)[>"]')
    if($m.Success){ [void]$trovati.Add($m.Groups[1].Value.Trim()) }
  }
  return @($trovati)
}

# GLI INPUT DICHIARATI in un .mq5. Torna la lista dei NOMI, in ordine.
# Le righe 'input group "..."' non matchano (dopo il tipo c'e' una
# virgoletta, non un identificatore): e' voluto, un gruppo non e' un
# parametro.
function InputDichiarati([string]$path){
  $nomi = New-Object System.Collections.ArrayList
  foreach($riga in (LeggiTesto $path)){
    $viva = ($riga -replace '//.*$','')
    $m = [regex]::Match($viva, '^\s*(?:input|sinput)\s+[A-Za-z_][A-Za-z0-9_]*\s+([A-Za-z_][A-Za-z0-9_]*)')
    if($m.Success){ [void]$nomi.Add($m.Groups[1].Value) }
  }
  return @($nomi)
}

# IL DEFAULT COMPILATO di un input. Torna "" se non lo trova: chi chiama
# decide se e' fatale (per gli input di rischio lo e').
function DefaultInput([string]$testo,[string]$nome){
  $m = [regex]::Match($testo, ('(?m)^\s*(?:input|sinput)\s+[A-Za-z_][A-Za-z0-9_]*\s+' + [regex]::Escape($nome) + '\s*=\s*([^;/]+)'))
  if(-not $m.Success){ return "" }
  return $m.Groups[1].Value.Trim()
}

# LEGGE UN .set. Torna chiavi (hashtable), l'ordine, e le righe che NON
# sono ne' vuote ne' commenti ';' ne' 'chiave=valore'.
function LeggiSet([string]$path){
  $kv = @{}
  $ordine = New-Object System.Collections.ArrayList
  $brutte = New-Object System.Collections.ArrayList
  $doppie = New-Object System.Collections.ArrayList
  $n = 0
  foreach($riga in (LeggiTesto $path)){
    $n++
    $s = $riga.Trim()
    if($s -eq ""){ continue }
    if($s.StartsWith(";")){ continue }
    $i = $s.IndexOf("=", [System.StringComparison]::Ordinal)
    if($i -lt 1){ [void]$brutte.Add("riga " + $n + ": " + $s); continue }
    $k = $s.Substring(0,$i)
    if($k -notmatch '^[A-Za-z_][A-Za-z0-9_]*$'){ [void]$brutte.Add("riga " + $n + ": " + $s); continue }
    # MT5 ammette 'nome=valore||start||step||stop||flag': si tiene solo
    # il valore, il resto e' roba da ottimizzatore e qui non serve.
    $v = $s.Substring($i+1)
    $j = $v.IndexOf("||", [System.StringComparison]::Ordinal)
    if($j -ge 0){ $v = $v.Substring(0,$j) }
    if($kv.ContainsKey($k)){ [void]$doppie.Add($k) }
    $kv[$k] = $v
    [void]$ordine.Add($k)
  }
  return [pscustomobject]@{ KV=$kv; Ordine=@($ordine); Brutte=@($brutte); Doppie=@($doppie) }
}

# Un numero dal .set, o si ferma. I confronti sui numeri della rete non
# si fanno sulle stringhe: "4.90" e "4.9" sono lo stesso numero, "4,9"
# no (e su una macchina con la virgola decimale sarebbe una trappola).
function NumeroDelSet($s,[string]$chiave,[string]$nomeSet){
  if(-not $s.KV.ContainsKey($chiave)){ throw ("IL PRESET " + $nomeSet + " NON HA " + $chiave + ": e' uno dei numeri della rete di protezione, e non si prende dal default in silenzio. NON installo.") }
  $x = 0.0
  if(-not [double]::TryParse(("" + $s.KV[$chiave]).Trim(), [Globalization.NumberStyles]::Float, $INV, [ref]$x)){
    throw ($chiave + " del preset " + $nomeSet + " non e' un numero leggibile ('" + $s.KV[$chiave] + "'). NON installo.")
  }
  return $x
}
function TestoDelSet($s,[string]$chiave,[string]$nomeSet){
  if(-not $s.KV.ContainsKey($chiave)){ throw ("IL PRESET " + $nomeSet + " NON HA " + $chiave + ". NON installo.") }
  return ("" + $s.KV[$chiave]).Trim()
}

# UNA CANDIDATA = una cartella che potrebbe essere una cartella dati MT5.
function AggiungiCandidata([string]$percorso,[string]$origine){
  if([string]::IsNullOrEmpty($percorso)){ return }
  $full = $percorso
  try{
    if(-not (Test-Path -LiteralPath $percorso)){ return }
    $full = (Get-Item -LiteralPath $percorso -ErrorAction Stop).FullName
  }catch{ return }
  $full = $full.TrimEnd("\")
  foreach($c in $Cand){ if($c.Percorso -ieq $full){ $c.Origine = $c.Origine + " + " + $origine; return } }
  $lg  = (Test-Path -LiteralPath (Join-Path $full "logs"))
  $mq  = (Test-Path -LiteralPath (Join-Path $full "MQL5"))
  $exe = (Test-Path -LiteralPath (Join-Path $full "terminal64.exe"))
  $me  = (Test-Path -LiteralPath (Join-Path $full "metaeditor64.exe"))
  if(-not $lg -and -not $mq -and -not $exe -and -not $me){ return }
  [void]$Cand.Add([pscustomobject]@{
    Percorso=$full; Origine=$origine; HaExe=$exe; HaMe=$me; HaLogs=$lg; HaMql=$mq
    Origin=""; Basi=""; Logins=""; FileLog=0; VistoAtteso=$false; VistiVietati=""
    Eleggibile=$false; Profilo=$false; Scarto=""; Leggibile=$true
  })
}

# LA COMPILAZIONE. Torna @{ Ex5=bool; Rc=<oggetto>; Log=<righe>; Muto=bool }
function Compila([string]$exe,[string[]]$argomenti,[string]$ex5,[string]$log,[int]$tetto,[string]$chi){
  Remove-Item -LiteralPath $log -Force -ErrorAction SilentlyContinue
  $t0 = Get-Date
  Dico ("metaeditor64 (" + $chi + "): " + $exe + " " + ($argomenti -join " ")) "Yellow"
  $global:LASTEXITCODE = $null
  & $exe @argomenti | Out-Null
  $grezzo = $LASTEXITCODE
  $fresco = $false
  $muto   = $false
  $battito = 0
  while($true){
    if((Test-Path -LiteralPath $ex5) -and ((Get-Item -LiteralPath $ex5).LastWriteTime -ge $t0)){ $fresco = $true; break }
    $r = LeggiTesto $log
    $cLog = @($r).Count
    if($cLog -gt 0 -and (@($r) -match 'Result:').Count -gt 0){ break }
    $sec = (New-TimeSpan -Start $t0 -End (Get-Date)).TotalSeconds
    if($cLog -eq 0 -and $sec -ge 20){ $muto = $true; break }
    if($sec -ge $tetto){ break }
    if($sec -ge ($battito + 10)){ $battito = [int]$sec; Dico ("   ... aspetto l'.ex5 di " + $chi + " da " + $battito + "s (tetto " + $tetto + "s): NON interrompere, la riga si ferma da sola") }
    Start-Sleep -Seconds 2
  }
  if((Test-Path -LiteralPath $ex5) -and ((Get-Item -LiteralPath $ex5).LastWriteTime -ge $t0)){ $fresco = $true }
  return @{ Ex5=$fresco; Rc=$grezzo; Log=(LeggiTesto $log); Avvio=$t0; Muto=$muto }
}

function RipristinaDaBackup([string]$dir,[string[]]$dest){
  $esiti = New-Object System.Collections.ArrayList
  foreach($d in $dest){
    if([string]::IsNullOrEmpty($d)){ continue }
    $nome = Split-Path -Leaf $d
    $b = Join-Path $dir $nome
    if(Test-Path -LiteralPath $b){
      Copy-Item -LiteralPath $b -Destination $d -Force
      if((HashPieno $b) -eq (HashPieno $d)){ [void]$esiti.Add($nome + ": rimesso dal backup (sha256 identico)") }
      else{ [void]$esiti.Add($nome + ": COPIATO MA SHA256 DIVERSO -- controllare a mano") }
    }
    else{
      Remove-Item -LiteralPath $d -Force -ErrorAction SilentlyContinue
      [void]$esiti.Add($nome + ": rimosso (prima del giro non c'era)")
    }
  }
  return @($esiti)
}

try{
  Titolo ("DEPLOY DEL GUARDIANO DI PORTAFOGLIO SUL SOLO CONTO REALE -- modo " + $Modo)
  Write-Host "ATTENZIONE: questo EA, quando gira, PUO' CHIUDERE POSIZIONI APERTE." -ForegroundColor Red
  Write-Host "Con InpAction=0 e InpCloseAllMagics=true chiude TUTTO IL CONTO, di QUALSIASI magic," -ForegroundColor Red
  Write-Host "comprese le posizioni aperte A MANO. E' un potere che nessun altro EA sul reale ha." -ForegroundColor Red
  if($Modo -eq "CONTROLLO"){ Write-Host "MODO CONTROLLO: questo giro NON scrive niente nel terminale. Mostra cosa farebbe la CORSA." -ForegroundColor Yellow }
  else{ Write-Host "MODO CORSA: scrive TRE file nella sola cartella dati scelta, con backup e ripristino TOTALE su qualunque fallimento." -ForegroundColor Yellow }
  Write-Host "QUESTA RIGA NON ATTACCA L'EA A NESSUN GRAFICO E NON TOCCA L'AUTOTRADING: quelli sono gesti MANUALI di Claudio." -ForegroundColor Yellow
  Write-Host ("E NON TOCCA " + $LOGGER + ", " + $SEDIA1 + ", " + $SEDIA2 + " ne' l'include " + $INC + ".") -ForegroundColor Yellow

  # -------------------------------------------------------------------
  #  0. LE GUARDIE
  # -------------------------------------------------------------------
  if($Pin -eq ""){ throw "-Pin obbligatorio: senza, girerebbe la punta del branch spacciandola per un commit congelato." }
  if($Pin -notmatch '^[0-9a-f]{40}$'){ throw ("-Pin deve essere un commit di 40 caratteri esadecimali, ricevuto: " + $Pin) }
  $RawPin = "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/" + $Pin

  if($LoginAtteso -eq ""){
    throw "-LoginAtteso OBBLIGATORIO: devi dirmi il numero del conto REALE. Non lo indovino dal nome di una cartella, e qui si installa un EA che puo' CHIUDERE posizioni vere."
  }
  if($LoginAtteso -notmatch '^\d{5,12}$'){ throw ("-LoginAtteso deve essere un numero di conto (5-12 cifre), ricevuto: " + $LoginAtteso) }
  foreach($v in $VIETATI_CONTI){
    if($LoginAtteso -eq $v){
      throw ("IL CONTO " + $v + " E' VIETATO PER QUESTA RIGA: e' uno dei due conti DEMO della flotta. Sul 100k gira gia' un Guardian (magic " + $MAGIC_FTMO + ") per il dry-run FTMO, e due guardiani sullo stesso conto vorrebbe dire due FlattenAll che si accavallano. Se volevi il reale, ricontrolla il numero.")
    }
  }
  if($ConfermoConto -ne "" -and $ConfermoConto -ne $LoginAtteso){
    throw ("-ConfermoConto (" + $ConfermoConto + ") e -LoginAtteso (" + $LoginAtteso + ") non coincidono. L'attestazione a mano serve proprio a farti scrivere il numero DUE VOLTE: se i due numeri non sono uguali, mi fermo.")
  }
  foreach($m in @($SEDIA1M,$SEDIA2M,$MAGIC_FTMO)){
    if($MAGIC -eq $m){ throw ("IL MAGIC DEL GUARDIANO (" + $MAGIC + ") COINCIDE CON UN MAGIC GIA' IN USO (" + $m + "). Non installo: la cronologia non direbbe piu' chi ha fatto cosa.") }
  }

  $edit = @(Get-Process -Name metaeditor64 -ErrorAction SilentlyContinue)
  if($edit.Count -gt 0){
    $el = @($edit | ForEach-Object { $_.ProcessName + " pid " + $_.Id }) -join ", "
    if($Modo -eq "CORSA"){
      throw ("METAEDITOR APERTO (" + $el + "): con l'editor aperto la compilazione da riga di comando torna MUTA (misurato il 22/08). Chiudi MetaEditor e rilancia. MT5 puo' restare aperto: non ho toccato niente.")
    }
    [void]$Rilievi.Add("MetaEditor aperto durante il CONTROLLO (" + $el + "): tollerato qui, perche' questo giro non compila. La CORSA lo pretende chiuso e si ferma da sola.")
  }
  $term = @(Get-Process -Name terminal64 -ErrorAction SilentlyContinue)
  if($term.Count -gt 0){
    # ATTENZIONE -- QUESTA FRASE E' CAMBIATA IL 06/09, ED E' UNA CORREZIONE
    # DI SOSTANZA. Fino al primo deploy diceva: "ABTG_Guardian e' un file
    # NUOVO per questo terminale, non sta su nessun grafico". Da quel giro
    # NON E' PIU' VERO: il guardiano e' stato installato E attaccato a un
    # grafico vivo. Lasciare in piedi la vecchia frase vorrebbe dire
    # scrivere nel referto una cosa falsa proprio nel punto in cui il
    # referto serve -- e un referto che rassicura su un fatto che non ha
    # guardato e' peggio di un referto che tace.
    [void]$Rilievi.Add("MT5 APERTO (" + (@($term | ForEach-Object { "pid " + $_.Id }) -join ", ") + "): e' ATTESO e va bene per le due sedie e il logger, che continuano a lavorare. MA QUESTO GIRO NON E' PIU' UN'INSTALLAZIONE NUOVA: dal 06/09 " + $EA + " sta gia' su un grafico di questo terminale, quindi Windows puo' tenere il suo .ex5 APERTO. Se e' cosi', questa riga NON COMPILA e rimette tutto com'era (non e' un guasto: e' il comportamento voluto). Va STACCATO DAL GRAFICO PRIMA: tasto destro sul grafico del guardiano > Expert Advisors > Rimuovi. Questa riga non scrive dentro config\\ ne' nei .chr, che sono i file che MT5 riscrive all'uscita (checklist punto 7).")
    Dico "MT5 aperto: atteso. RICORDA: il guardiano va STACCATO dal suo grafico prima della CORSA" "Yellow"
  }
  else{
    [void]$Rilievi.Add("MT5 CHIUSO in questo giro: l'installazione riesce lo stesso, ma il guardiano comincera' a sorvegliare solo quando riaprirai il terminale, lo attaccherai a un grafico e l'AutoTrading sara' acceso.")
  }
  Dico ("pin ............ " + $Pin)
  Dico ("conto atteso ... " + $LoginAtteso + "   (vietati per sempre: " + ($VIETATI_CONTI -join ", ") + ")") "Yellow"
  Dico ("magic guardiano  " + $MAGIC + "   (diverso da " + $SEDIA1M + " / " + $SEDIA2M + " / " + $MAGIC_FTMO + ")") "Yellow"
  Dico ("soglie pretese . giorno " + $A_DAILYLOSS.ToString("0.0#",$INV) + "%  totale " + $A_TOTALDD.ToString("0.0#",$INV) + "%  pausa " + $A_PAUSA.ToString("0.0#",$INV) + "%  cap " + $A_CAP.ToString("0.0#",$INV) + "%  reset " + $A_RESETHOUR + ":00 server") "Yellow"
  Dico ("cartella di lavoro: " + $Work)

  # -------------------------------------------------------------------
  #  1. CARTELLA DI LAVORO + SENTINELLA di un giro interrotto
  # -------------------------------------------------------------------
  Titolo "1. CARTELLA DI LAVORO e SENTINELLA"
  New-Item -ItemType Directory -Force -Path $Work | Out-Null
  if(Test-Path -LiteralPath $Scaricati){ Remove-Item -LiteralPath $Scaricati -Recurse -Force }
  New-Item -ItemType Directory -Force -Path $Scaricati | Out-Null
  Remove-Item -LiteralPath $LogPath -Force -ErrorAction SilentlyContinue
  if(Test-Path -LiteralPath $Sentinella){
    $rs = @(Get-Content -LiteralPath $Sentinella -ErrorAction SilentlyContinue)
    $sDest = @()
    $sBack = ""
    if(@($rs).Count -ge 2){
      $sBack = ("" + $rs[@($rs).Count - 1]).Trim()
      for($i=0; $i -lt (@($rs).Count - 1); $i++){ $sDest = $sDest + @(("" + $rs[$i]).Trim()) }
    }
    if($Modo -eq "CORSA" -and @($sDest).Count -ge 1 -and $sBack -ne "" -and (Test-Path -LiteralPath $sBack)){
      $es = RipristinaDaBackup $sBack $sDest
      Remove-Item -LiteralPath $Sentinella -Force -ErrorAction SilentlyContinue
      [void]$Rilievi.Add("UN GIRO PRECEDENTE ERA STATO INTERROTTO fra backup e fine: i file sono stati RIMESSI dal backup " + $sBack + " adesso, all'avvio (" + ($es -join "; ") + ").")
      Dico "sentinella di un giro interrotto: file rimessi dal backup" "Yellow"
    }
    else{
      [void]$Problemi.Add("SENTINELLA DI UN GIRO INTERROTTO trovata (" + $Sentinella + "): un giro precedente e' stato fermato a mano fra il backup e la fine. Questo giro in " + $Modo + " NON scrive nel terminale: rilancia in CORSA (rimette a posto da solo dal backup " + $sBack + ") oppure guarda a mano.")
      if($Modo -eq "CORSA"){ throw ("SENTINELLA ILLEGGIBILE o backup mancante (" + $sBack + "): non tocco il terminale finche' non e' chiaro cosa c'e' dentro.") }
    }
  }

  # -------------------------------------------------------------------
  #  2. SCARICO AL PIN + GATE DI IDENTITA'
  # -------------------------------------------------------------------
  Titolo "2. SCARICO AL PIN E GATE (versione, magic, default compilati, IL FILO, e il preset)"
  $Mq5   = Join-Path $Scaricati ($EA + ".mq5")
  $Mqh   = Join-Path $Scaricati $INC
  $SetF  = Join-Path $Scaricati $SET
  Scarica ($RawPin + "/mql5/Experts/" + $EA + ".mq5")      $Mq5
  Scarica ($RawPin + "/mql5/Include/" + $INC)              $Mqh
  Scarica ($RawPin + "/mql5/Presets/conto_reale/" + $SET)  $SetF
  [void]$SorgTxt.Add($EA + ".mq5 : " + (Descrivi $Mq5))
  [void]$SorgTxt.Add($INC + " (SOLO PER CONFRONTO, non viene installato) : " + (Descrivi $Mqh))
  [void]$SorgTxt.Add($SET + " : " + (Descrivi $SetF))
  foreach($x in $SorgTxt){ Dico ("scaricato " + $x) "Green" }

  $righe = LeggiTesto $Mq5
  $testo = ($righe -join "`n")
  $testoMqh = ((LeggiTesto $Mqh) -join "`n")

  # --- versione
  $mv = [regex]::Match($testo, '#property\s+version\s+"([^"]+)"')
  if(-not $mv.Success){ throw ("in " + $EA + ".mq5 non c'e' nessun #property version: non e' il file che credo.") }
  $v = $mv.Groups[1].Value
  if($v -eq $VER_KO){
    throw ("AL PIN C'E' ANCORA LA v" + $VER_KO + " DEL GUARDIANO, cioe' PROPRIO LA VERSIONE COL BUG che questo giro deve sostituire. La v" + $VER_KO + " cattura il saldo di riferimento dal BILANCIO ma lo confronta con l'EQUITA': su un conto con un CREDITO del broker (questo ne ha 2.500 EUR, stabile e non prelevabile) il credito si comporta come un guadagno permanente e le soglie del 4,9% e del 9,9% non mordono piu' dove dicono. Installarla vorrebbe dire rimettere nel terminale esattamente il file che stiamo togliendo. Serve la v" + $VER + ": ricontrolla il pin. NON installo.")
  }
  if($v -ne $VER){ throw ("VERSIONE SBAGLIATA per " + $EA + ": al pin c'e' la v" + $v + ", attesa la v" + $VER + ". NON installo.") }
  [void]$GateTxt.Add("versione: " + $EA + " v" + $v + " (attesa " + $VER + "; la v" + $VER_KO + ", quella col bug del credito, e' rifiutata PER NOME)")

  # --- che sia DAVVERO il guardiano, non un omonimo: le tre funzioni
  #     che fanno il mestiere. Ancorate sulla parentesi (classe 116-ter):
  #     un nome rinominato non passa.
  foreach($f in @("FlattenAll","OpenRiskPct","VerificaFilo","SetPausa")){
    if($testo -notmatch ($f + '\s*\(')){
      throw ("in " + $EA + ".mq5 non trovo la funzione " + $f + "(...): non e' il guardiano che credo (o non e' la v" + $VER + "). NON installo.")
    }
  }
  if($testo -notmatch 'EventSetTimer\s*\(\s*1\s*\)'){
    throw ("in " + $EA + ".mq5 non trovo EventSetTimer(1): il guardiano sorveglia via OnTimer, senza timer non sorveglia niente. NON installo.")
  }
  [void]$GateTxt.Add("nucleo del guardiano: FlattenAll / OpenRiskPct / VerificaFilo / SetPausa presenti, EventSetTimer(1) presente")

  # --- v1.12: LE TRACCE VERE DEL FIX DEL CREDITO, non la sua targhetta.
  #     '#property version' e' una STRINGA: si alza scrivendo tre caratteri,
  #     anche senza aver corretto una riga di codice. Un gate che si fida
  #     solo di quella verifica l'ETICHETTA, non il contenuto. Qui si
  #     pretendono i DUE FATTI che il fix ha lasciato nel sorgente, e si
  #     leggono sul testo VIVO (commenti tolti): un commento che PARLA del
  #     fix non e' il fix.
  $vivo = (($righe | ForEach-Object { $_ -replace '//.*$','' }) -join "`n")

  #  FATTO 1 -- la baseline si cattura dall'EQUITA', non dal BILANCIO.
  #  E' tutto il bug: la v1.11 prendeva 'bal' e lo confrontava piu' sotto
  #  con 'eq'. Su questo conto c'e' un credito del broker di 2.500 EUR che
  #  sta nell'equita' e non nel bilancio, quindi il confronto partiva con
  #  2.500 EUR di cuscinetto finto e le soglie non mordevano piu' dove
  #  dicono di mordere.
  if($vivo -notmatch 'gStart\s*=\s*\(\s*GlobalVariableCheck\s*\(\s*GV_START\s*\)\s*\?\s*GlobalVariableGet\s*\(\s*GV_START\s*\)\s*:\s*eq\s*\)'){
    throw ("IL FIX DEL CREDITO NON C'E' NEL SORGENTE AL PIN: il saldo di riferimento (gStart) non risulta catturato dall'EQUITA'. E' il cuore della v" + $VER + " -- senza, il guardiano tornerebbe a misurare il cuscinetto dal BILANCIO e a confrontarlo con l'EQUITA', cioe' a regalare al conto tutto il credito del broker prima di frenare. Il numero di versione da solo non basta a dire che il fix c'e'. NON installo.")
  }
  if($vivo -match 'GlobalVariableSet\s*\(\s*GV_DAYSTART\s*,\s*bal\s*\)'){
    throw ("NEL SORGENTE AL PIN LA BASELINE GIORNALIERA E' ANCORA PRESA DAL BILANCIO (GlobalVariableSet(GV_DAYSTART,bal)): e' meta' del bug del credito, quella che decide la soglia del 4,9% (chiusura di tutto e blocco fino alle 23). NON installo.")
  }
  $nDayEq = @([regex]::Matches($vivo,'GlobalVariableSet\s*\(\s*GV_DAYSTART\s*,\s*eq\s*\)')).Count
  if($nDayEq -lt 2){
    throw ("LA BASELINE GIORNALIERA E' PRESA DALL'EQUITA' SOLO IN " + $nDayEq + " PUNTI SU 2 nel sorgente al pin. I punti sono due e servono tutti e due: uno in OnInit (primo avvio) e uno in OnTimer (il cambio di giorno prop delle 23). Se ne corregge uno solo, il guardiano parte giusto e poi si guasta da solo al primo scoccare della mezzanotte. NON installo.")
  }

  #  FATTO 2 -- le CINQUE GlobalVariable della baseline sono rinominate _V2.
  #  Senza il nome nuovo il fix di codice non servirebbe a NIENTE su questo
  #  conto: quelle variabili "sopravvivono a riavvii e ricompilazioni" per
  #  scelta, quindi il guardiano rileggerebbe il numero VECCHIO (catturato
  #  col criterio sbagliato) invece di ricatturarlo pulito.
  $gvKo = New-Object System.Collections.ArrayList
  foreach($g in @("START","PEAK","DAYKEY","DAYSTART","BLOCKDAY")){
    $atteso = '"ABTG_GUARD_%I64d_' + $g + '_V2"'
    if($vivo.IndexOf($atteso, [System.StringComparison]::Ordinal) -lt 0){ [void]$gvKo.Add($g) }
  }
  if(@($gvKo).Count -gt 0){
    throw ("NEL SORGENTE AL PIN MANCA IL RINOMINO _V2 su " + @($gvKo).Count + " GlobalVariable della baseline (" + (@($gvKo) -join ", ") + "). Quelle variabili PERSISTONO nel terminale per scelta: sul conto reale ci sono GIA', scritte dalla v" + $VER_KO + " col criterio sbagliato. Senza il nome nuovo il guardiano le RILEGGE alla prima ricompilazione e il fix non prende -- si aggiornerebbe il codice lasciando in campo il numero contaminato. NON installo.")
  }
  #  ...e GV_FAILED NON si rinomina: quella non era contaminata dal bug, e
  #  rinominarla azzererebbe un eventuale blocco definitivo gia' in essere.
  #  Sarebbe la faccia peggiore di questo aggiornamento: un conto fermato
  #  per DD sfondato che si ritrova operativo senza che nessuno l'abbia deciso.
  if($vivo.IndexOf('"ABTG_GUARD_%I64d_FAILED"', [System.StringComparison]::Ordinal) -lt 0){
    throw ("NEL SORGENTE AL PIN LA GlobalVariable DEL BLOCCO DEFINITIVO NON E' PIU' 'ABTG_GUARD_<login>_FAILED'. Quella NON andava toccata: non era contaminata dal bug del credito, e cambiarle nome vorrebbe dire che un conto gia' FERMATO per DD totale sfondato si ritroverebbe di colpo operativo, senza che nessuno l'abbia deciso. NON installo.")
  }
  [void]$GateTxt.Add("IL FIX DEL CREDITO, verificato NEL CODICE e non sulla targhetta di versione: baseline catturata dall'EQUITA' (gStart + 2 punti su 2 per il giorno prop), le 5 GlobalVariable della baseline rinominate _V2 (cattura fresca forzata), e GV_FAILED lasciata col nome di prima (un blocco definitivo in essere non si azzera per sbaglio)")

  # le due righe che il referto dice a Claudio di cercare nella scheda
  # Esperti. Se non ci sono, le istruzioni sarebbero sbagliate: non e' un
  # pericolo, quindi e' un rilievo e non un blocco.
  foreach($sp in @($RIGA_AVVIO, "[GUARDIAN] baseline presa dall")){
    if($testo.IndexOf($sp, [System.StringComparison]::Ordinal) -lt 0){
      [void]$Rilievi.Add("nel sorgente al pin non trovo la riga di log '" + $sp + "...', che il referto dice di cercare nella scheda Esperti. Non e' un pericolo (il guardiano funziona lo stesso), ma quel passo di verifica non si potra' fare come scritto.")
    }
  }

  # --- IL FILO. Il guardiano SCRIVE su nomi costruiti nel .mq5, gli EA
  #     LEGGONO da nomi costruiti nell'include. Due posti diversi: se
  #     divergono il canale muore IN SILENZIO. Si confrontano QUI, prima.
  $filiOk = New-Object System.Collections.ArrayList
  $filiKo = New-Object System.Collections.ArrayList
  if($testoMqh.IndexOf('"%s_%I64d"', [System.StringComparison]::Ordinal) -lt 0){
    throw ("l'include al pin non costruisce piu' i nomi con StringFormat(""%s_%I64d"",...): la regola di composizione e' cambiata e il confronto dei fili qui sotto non varrebbe piu' niente. NON installo.")
  }
  foreach($r in $FILI){
    $scritto = ('"' + $r + '_%I64d"')      # come lo scrive il guardiano
    $letto   = ('"' + $r + '"')            # la radice come la legge l'include
    $a = ($testo.IndexOf($scritto, [System.StringComparison]::Ordinal) -ge 0)
    $b = ($testoMqh.IndexOf($letto, [System.StringComparison]::Ordinal) -ge 0)
    if($a -and $b){ [void]$filiOk.Add($r) }
    else{ [void]$filiKo.Add($r + " (nel guardiano: " + $a + ", nell'include: " + $b + ")") }
  }
  if(@($filiKo).Count -gt 0){
    throw ("IL FILO E' ROTTO su " + @($filiKo).Count + " GlobalVariable su " + @($FILI).Count + " (" + (@($filiKo) -join " | ") + "). Il guardiano scriverebbe su nomi che gli EA non leggono: il canale morirebbe IN SILENZIO -- il guardiano scrive, nessuno legge, nessun errore da nessuna parte. NON installo.")
  }
  $FiloTxt = "VERIFICATO A TAVOLINO: " + @($filiOk).Count + " GlobalVariable su " + @($FILI).Count + " con lo stesso nome fra " + $EA + ".mq5 (che scrive) e " + $INC + " (che legge) -- " + (@($filiOk) -join ", ") + ". La composizione dei nomi nell'include e' StringFormat(""%s_%I64d"",radice,login), verificata anche quella."
  [void]$GateTxt.Add("IL FILO guardiano->EA: " + @($filiOk).Count + "/" + @($FILI).Count + " nomi coincidenti (" + (@($filiOk) -join ", ") + ")")

  # --- I DEFAULT COMPILATI. Sono quelli che tornerebbero premendo
  #     RIPRISTINA sulla finestra dei parametri: devono essere gia'
  #     sicuri, se no un dito storto spegnerebbe la rete.
  $dAct = DefaultInput $testo "InpAction"
  $dCam = DefaultInput $testo "InpCloseAllMagics"
  $dDay = DefaultInput $testo "InpDailyLossPct"
  $dTot = DefaultInput $testo "InpTotalDDPct"
  foreach($p in @(@{N="InpAction";V=$dAct},@{N="InpCloseAllMagics";V=$dCam},@{N="InpDailyLossPct";V=$dDay},@{N="InpTotalDDPct";V=$dTot})){
    if($p.V -eq ""){ throw ("in " + $EA + ".mq5 non trovo il default compilato di " + $p.N + ": non posso verificare cosa tornerebbe con un RIPRISTINA, e su un conto reale questo non si salta. NON installo.") }
  }
  if($dAct -ne "0"){ throw ("IL DEFAULT COMPILATO DI InpAction e' '" + $dAct + "', atteso 0 (CHIUDI+BLOCCA). Con 1 il guardiano sarebbe in SOLO ALLARME: un RIPRISTINA sulla finestra dei parametri spegnerebbe la rete senza dire niente. NON installo.") }
  if($dCam -notmatch '^(?i)true$'){ throw ("IL DEFAULT COMPILATO DI InpCloseAllMagics e' '" + $dCam + "', atteso true. Con false il guardiano chiuderebbe solo le proprie posizioni -- cioe' nessuna, perche' non ne apre. NON installo.") }
  $nDay = 0.0; $nTot = 0.0
  if(-not [double]::TryParse($dDay,[Globalization.NumberStyles]::Float,$INV,[ref]$nDay)){ throw ("il default compilato di InpDailyLossPct ('" + $dDay + "') non e' un numero. NON installo.") }
  if(-not [double]::TryParse($dTot,[Globalization.NumberStyles]::Float,$INV,[ref]$nTot)){ throw ("il default compilato di InpTotalDDPct ('" + $dTot + "') non e' un numero. NON installo.") }
  if($nDay -le 0 -or $nDay -gt $T_DAILYLOSS){ throw ("IL DEFAULT COMPILATO di InpDailyLossPct e' " + $nDay.ToString("0.0#",$INV) + "%, fuori da (0, " + $T_DAILYLOSS.ToString("0.0#",$INV) + "]. NON installo.") }
  if($nTot -le 0 -or $nTot -gt $T_TOTALDD){ throw ("IL DEFAULT COMPILATO di InpTotalDDPct e' " + $nTot.ToString("0.0#",$INV) + "%, fuori da (0, " + $T_TOTALDD.ToString("0.0#",$INV) + "]. NON installo.") }
  [void]$GateTxt.Add("default COMPILATI (quelli che tornerebbero con un RIPRISTINA sulla finestra dei parametri): InpAction=" + $dAct + " (enforce) | InpCloseAllMagics=" + $dCam + " | InpDailyLossPct=" + $nDay.ToString("0.0#",$INV) + "% | InpTotalDDPct=" + $nTot.ToString("0.0#",$INV) + "%  -- tutti gia' sicuri")

  # --- include: solo Trade/Trade.mqh (di libreria) e il nostro
  $altriInc = New-Object System.Collections.ArrayList
  foreach($n in (CensisciInclude $Mq5)){
    $nudo = ($n -split '[\\/]')[-1]
    if($nudo -match '^ABTG_'){
      if($nudo -ne $INC){ throw ("INCLUDE NOSTRO NON PREVISTO: " + $EA + ".mq5 chiede '" + $n + "', che questa riga NON conosce. Aggiungerlo alla riga e ri-pinnare.") }
    }
    else{
      $gia = $false
      foreach($x in $altriInc){ if($x -ieq $n){ $gia = $true } }
      if(-not $gia){ [void]$altriInc.Add($n) }
    }
  }
  foreach($n in (CensisciInclude $Mqh)){
    $nudo = ($n -split '[\\/]')[-1]
    if($nudo -match '^ABTG_' -and $nudo -ne $INC){ throw ("L'INCLUDE " + $INC + " ne chiede un altro NOSTRO ('" + $n + "'): mi fermo prima di installare.") }
  }
  if($testoMqh -notmatch 'int\s+ABTG_AutotestGuardia\s*\('){
    throw ("l'include al pin non definisce ABTG_AutotestGuardia(...): il guardiano la chiama quando InpAutotest=true, non compilerebbe.")
  }
  [void]$GateTxt.Add("include: nostro = " + $INC + " (presente al pin, definisce ABTG_AutotestGuardia); di libreria = " + (@($altriInc) -join ", "))

  # --- ASCII dei sorgenti (non blocca: e' un rilievo)
  foreach($f in @($Mq5,$Mqh)){
    $na = 0
    foreach($b in [System.IO.File]::ReadAllBytes($f)){ if($b -gt 126){ $na++ } }
    if($na -gt 0){ [void]$Rilievi.Add((Split-Path -Leaf $f) + " ha " + $na + " byte non-ASCII: non blocca la compilazione, ma va saputo.") }
  }

  # -------------------------------------------------------------------
  #  2-bis. IL PRESET, APERTO E CONTATO
  # -------------------------------------------------------------------
  # ASCII puro: un .set con caratteri strani e' un .set che non si sa
  # come venga letto, e qui non si tira a indovinare.
  $bset = [System.IO.File]::ReadAllBytes($SetF)
  $nonAscii = 0
  foreach($b in $bset){ if($b -gt 126){ $nonAscii++ } }
  if($nonAscii -gt 0){ throw ("IL PRESET " + $SET + " HA " + $nonAscii + " BYTE NON-ASCII: non installo un file di parametri di cui non so come verra' letto.") }

  $s = LeggiSet $SetF
  if(@($s.Brutte).Count -gt 0){
    throw ("IL PRESET " + $SET + " HA " + @($s.Brutte).Count + " RIGHE MALFORMATE (ne' vuote, ne' commenti ';', ne' chiave=valore): " + (@($s.Brutte) -join " | ") + ". MT5 le salterebbe IN SILENZIO e il preset si caricherebbe a meta'. NON installo.")
  }
  if(@($s.Doppie).Count -gt 0){
    throw ("IL PRESET " + $SET + " HA CHIAVI DOPPIE (" + (@($s.Doppie) -join ", ") + "): vincerebbe l'ultima, e quale sia non lo decide nessuno. NON installo.")
  }
  $ins = InputDichiarati $Mq5
  if(@($ins).Count -eq 0){ throw ("non ho trovato NESSUN input dichiarato in " + $EA + ".mq5: il confronto col preset non sarebbe una verifica. NON installo.") }
  # (b) ogni chiave del .set e' un input vero
  $estranee = New-Object System.Collections.ArrayList
  foreach($k in $s.Ordine){
    $ok = $false
    foreach($i in $ins){ if($i -ceq $k){ $ok = $true } }
    if(-not $ok){ [void]$estranee.Add($k) }
  }
  if($estranee.Count -gt 0){
    throw ("IL PRESET " + $SET + " HA " + $estranee.Count + " CHIAVI CHE NON SONO INPUT DI " + $EA + " (" + (@($estranee) -join ", ") + "): MT5 le ignora senza dire niente, e chi legge il file crede di aver impostato qualcosa. NON installo.")
  }
  # (c) ogni input dell'EA c'e' nel .set -- COPERTURA TOTALE
  $mancanti = New-Object System.Collections.ArrayList
  foreach($i in $ins){
    if(-not $s.KV.ContainsKey($i)){
      $gia = $false
      foreach($x in $mancanti){ if($x -ceq $i){ $gia = $true } }
      if(-not $gia){ [void]$mancanti.Add($i) }
    }
  }
  if($mancanti.Count -gt 0){
    throw ("IL PRESET " + $SET + " NON COPRE " + $mancanti.Count + " INPUT DI " + $EA + " (" + (@($mancanti) -join ", ") + "). Un input che il preset non nomina prende il DEFAULT COMPILATO in silenzio: e' la trappola del 2% chiusa il 02/09, e su questo EA sarebbe peggio (un InpAction non nominato deciderebbe da solo se il conto ha una rete). NON installo.")
  }

  # (d) IL MAGIC
  $vMagic = TestoDelSet $s "InpMagic" $SET
  if($vMagic -ne $MAGIC){ throw ("MAGIC SBAGLIATO nel preset " + $SET + ": c'e' '" + $vMagic + "', atteso '" + $MAGIC + "'. NON installo.") }
  foreach($m in @($SEDIA1M,$SEDIA2M,$MAGIC_FTMO)){
    if($vMagic -eq $m){ throw ("IL MAGIC DEL PRESET (" + $vMagic + ") COINCIDE CON UN MAGIC GIA' IN USO (" + $m + "). NON installo.") }
  }

  # (e) L'AZIONE: enforce, e su tutto il conto. Un guardiano in "solo
  #     allarme" su un conto vero non e' una rete, e' un post-it.
  $vAct = TestoDelSet $s "InpAction" $SET
  if($vAct -ne $A_ACTION){ throw ("InpAction nel preset " + $SET + " e' '" + $vAct + "', atteso '" + $A_ACTION + "' (0 = CHIUDI+BLOCCA). Con 1 il guardiano vedrebbe lo sfondamento e NON farebbe niente: su un conto reale quella non e' una rete di protezione, e' un post-it. NON installo.") }
  $vCam = TestoDelSet $s "InpCloseAllMagics" $SET
  if($vCam -notmatch '^(?i)true$'){ throw ("InpCloseAllMagics nel preset " + $SET + " e' '" + $vCam + "', atteso true. Con false il guardiano chiuderebbe solo le posizioni col PROPRIO magic -- cioe' nessuna, perche' non ne apre mai. NON installo.") }

  # (f) IL SALDO DI RIFERIMENTO: 0, e MAI 100000.
  $vStart = NumeroDelSet $s "InpStartBalance" $SET
  if([math]::Abs($vStart - 100000.0) -lt 0.5){
    throw ("InpStartBalance nel preset " + $SET + " e' 100000: quello era il FINTO saldo della challenge FTMO simulata sul DEMO. Su un conto vero da ~7.500 EUR renderebbe ogni soglia circa 13 volte piu' larga del capitale -- cioe' NESSUNA rete, mai. Ci vuole 0 (cattura automatica del saldo vero). NON installo.")
  }
  if([math]::Abs($vStart - $A_STARTBAL) -gt 0.0000001){
    throw ("InpStartBalance nel preset " + $SET + " e' " + $vStart.ToString("0.##",$INV) + ", atteso " + $A_STARTBAL.ToString("0.##",$INV) + " (0 = cattura in automatico il saldo reale al primo avvio e lo persiste). NON installo.")
  }

  # (g) I NUMERI FIRMATI IL 18/08, uno per uno ed ESATTI
  $vDay   = NumeroDelSet $s "InpDailyLossPct"   $SET
  $vTot   = NumeroDelSet $s "InpTotalDDPct"     $SET
  $vPau   = NumeroDelSet $s "InpDailyPausePct"  $SET
  $vCap   = NumeroDelSet $s "InpMaxOpenRiskPct" $SET
  $attesi = @(@{N="InpDailyLossPct";V=$vDay;A=$A_DAILYLOSS},
              @{N="InpTotalDDPct";V=$vTot;A=$A_TOTALDD},
              @{N="InpDailyPausePct";V=$vPau;A=$A_PAUSA},
              @{N="InpMaxOpenRiskPct";V=$vCap;A=$A_CAP})
  foreach($p in $attesi){
    if([math]::Abs($p.V - $p.A) -gt 0.0000001){
      throw ($p.N + " nel preset " + $SET + " e' " + ([double]$p.V).ToString("0.0##",$INV) + ", atteso ESATTAMENTE " + ([double]$p.A).ToString("0.0##",$INV) + " (pacchetto Guardian firmato da Claudio il 18/08/2026, CLAUDE.md). Questi numeri non si tarano su un backtest: si cambiano con una firma. NON installo.")
    }
  }
  foreach($p in @(@{N="InpDDMode";A=$A_DDMODE},@{N="InpRiskMode";A=$A_RISKMODE},@{N="InpDailyResetHour";A=$A_RESETHOUR})){
    $vv = TestoDelSet $s $p.N $SET
    if($vv -ne $p.A){ throw ($p.N + " nel preset " + $SET + " e' '" + $vv + "', atteso '" + $p.A + "' (firma del 18/08). NON installo.") }
  }

  # (h) I TETTI: anche un preset "quasi giusto" non deve poter allargare
  #     la rete oltre il muro classico 5% / 10%.
  if($vDay -gt $T_DAILYLOSS){ throw ("InpDailyLossPct = " + $vDay.ToString("0.0#",$INV) + "% sfonda il tetto " + $T_DAILYLOSS.ToString("0.0#",$INV) + "%. NON installo.") }
  if($vTot -gt $T_TOTALDD){   throw ("InpTotalDDPct = "   + $vTot.ToString("0.0#",$INV) + "% sfonda il tetto " + $T_TOTALDD.ToString("0.0#",$INV) + "%. NON installo.") }
  if($vCap -gt $T_CAP){       throw ("InpMaxOpenRiskPct = " + $vCap.ToString("0.0#",$INV) + "% sfonda il tetto " + $T_CAP.ToString("0.0#",$INV) + "%. NON installo.") }

  # (i) LA COERENZA FRA LE SOGLIE. Non basta che ogni numero sia giusto:
  #     devono stare NELL'ORDINE giusto, se no il freno morbido non frena
  #     mai prima dell'emergenza e l'emergenza giornaliera non scatta mai
  #     prima di quella totale.
  if($vPau -le 0){ throw ("InpDailyPausePct = " + $vPau.ToString("0.0#",$INV) + ": la pausa morbida sarebbe SPENTA. Su questo deploy la si vuole accesa (firma B1). NON installo.") }
  if($vPau -ge $vDay){
    throw ("INCOERENZA FRA LE SOGLIE: la pausa morbida (" + $vPau.ToString("0.0#",$INV) + "%) NON sta sotto l'emergenza giornaliera (" + $vDay.ToString("0.0#",$INV) + "%). Cosi' il freno morbido non frenerebbe MAI prima che scatti la chiusura d'autorita': il gradino B1 sarebbe decorativo. NON installo.")
  }
  if($vDay -ge $vTot){
    throw ("INCOERENZA FRA LE SOGLIE: l'emergenza giornaliera (" + $vDay.ToString("0.0#",$INV) + "%) NON sta sotto il DD totale (" + $vTot.ToString("0.0#",$INV) + "%). Il blocco giornaliero, che dura un giorno, non scatterebbe mai prima del blocco DEFINITIVO. NON installo.")
  }
  if($vCap -le 0){ [void]$Rilievi.Add("InpMaxOpenRiskPct = 0: il cap C1 sarebbe spento. Non blocca il deploy, ma non e' la firma del 18/08.") }

  # (j) le tre spie accese: pannello, giornale, avviso sulle posizioni
  #     senza SL. Non sono estetica: sono l'unico modo che ha Claudio di
  #     verificare con gli occhi che la rete e' quella giusta.
  foreach($p in @("InpShowPanel","InpVerbose","InpWarnNoSL","InpAutotest")){
    $vv = TestoDelSet $s $p $SET
    if($vv -notmatch '^(?i)true$'){
      throw ($p + " nel preset " + $SET + " e' '" + $vv + "', atteso true. Sono le spie con cui si verifica che il guardiano stia facendo quello che deve (pannello, giornale, posizioni senza SL, autotest): su un conto reale non si spengono. NON installo.")
    }
  }

  $SetTxt2 = $SET + "  ->  " + @($s.Ordine).Count + " chiavi = " + @($ins).Count + " input dell'EA (copertura TOTALE)"
  [void]$SetTxt.Add($SetTxt2)
  [void]$SetTxt.Add("  saldo di riferimento : InpStartBalance=" + $vStart.ToString("0.##",$INV) + "  (0 = cattura il saldo VERO al primo avvio; NON e' il 100000 del dry-run FTMO)")
  [void]$SetTxt.Add("  EMERGENZA (chiude)   : giorno " + $vDay.ToString("0.0#",$INV) + "%  |  DD totale " + $vTot.ToString("0.0#",$INV) + "% (modo " + (TestoDelSet $s "InpDDMode" $SET) + " = statico dal saldo iniziale)  |  reset giorno alle " + (TestoDelSet $s "InpDailyResetHour" $SET) + ":00 SERVER")
  [void]$SetTxt.Add("  FRENI (non chiudono) : pausa morbida " + $vPau.ToString("0.0#",$INV) + "%  |  cap rischio aperto " + $vCap.ToString("0.0#",$INV) + "% (modo " + (TestoDelSet $s "InpRiskMode" $SET) + " = dall'ingresso)")
  [void]$SetTxt.Add("  AZIONE               : InpAction=" + $vAct + " (CHIUDI+BLOCCA)  |  InpCloseAllMagics=" + $vCam + " (TUTTO IL CONTO, qualsiasi magic, comprese le posizioni aperte A MANO)")
  [void]$SetTxt.Add("  identita' e spie     : InpMagic=" + $vMagic + " | pannello, giornale, avviso senza-SL e autotest tutti accesi")
  [void]$SetTxt.Add("  coerenza delle soglie: pausa " + $vPau.ToString("0.0#",$INV) + "% < giorno " + $vDay.ToString("0.0#",$INV) + "% < totale " + $vTot.ToString("0.0#",$INV) + "%  (verificata, non assunta)")
  Dico ("preset OK: " + $SET + "  (magic " + $vMagic + ", " + @($s.Ordine).Count + " chiavi, copertura totale, soglie firmate e coerenti)") "Green"
  [void]$GateTxt.Add("preset: passa i DIECI cancelli (ASCII, righe ben formate, nessuna doppia, nessuna estranea, copertura TOTALE, magic esatto e non collidente, azione enforce su tutto il conto, saldo 0 e non 100000, i quattro numeri firmati esatti, coerenza pausa<giorno<totale)")

  # -------------------------------------------------------------------
  #  3. LA CARTELLA DATI DEL CONTO REALE -- scelta per FATTI, e severa
  # -------------------------------------------------------------------
  Titolo ("3. CARTELLA DATI DEL CONTO REALE " + $LoginAtteso + " (scansione LARGA, scelta STRETTISSIMA)")
  foreach($pr in @(Get-Process -Name terminal64,metaeditor64 -ErrorAction SilentlyContinue)){
    $exe = ""
    try{ $exe = $pr.Path }catch{ $exe = "" }
    if($exe){ AggiungiCandidata (Split-Path -Parent $exe) ("processo " + $pr.ProcessName + " pid " + $pr.Id) }
  }
  $radici = New-Object System.Collections.ArrayList
  if($env:APPDATA){ [void]$radici.Add((Join-Path $env:APPDATA "MetaQuotes\Terminal")) }
  $drive = $env:SystemDrive
  if(-not $drive){ $drive = "C:" }
  # IL DISCO SI VERIFICA PRIMA DI USARLO: Join-Path su un disco che non
  # esiste NON torna un percorso brutto, LANCIA.
  $driveOk = $false
  try{ $driveOk = (Test-Path -LiteralPath ($drive + "\")) }catch{ $driveOk = $false }
  if(-not $driveOk){ [void]$Rilievi.Add("il disco di sistema '" + $drive + "' non e' leggibile da questa sessione: la scansione ha guardato solo %APPDATA% e i processi vivi. Dichiarato.") }
  if($driveOk){
    try{
      foreach($u in @(Get-ChildItem -LiteralPath (Join-Path $drive "Users") -Directory -ErrorAction SilentlyContinue)){
        [void]$radici.Add((Join-Path $u.FullName "AppData\Roaming\MetaQuotes\Terminal"))
      }
    }catch{}
  }
  foreach($rt in $radici){
    if(-not (Test-Path -LiteralPath $rt)){ continue }
    foreach($d in @(Get-ChildItem -LiteralPath $rt -Directory -ErrorAction SilentlyContinue)){
      if($d.Name -ieq "Common"){ continue }
      AggiungiCandidata $d.FullName ("cartella dati sotto " + $rt)
    }
  }
  $paroleChiave = @("MT5","BCM","MetaTrader","MetaQuotes","Terminal")
  $radiciInst = New-Object System.Collections.ArrayList
  $radiciPF = @($env:ProgramFiles, ${env:ProgramFiles(x86)})
  if($driveOk){ $radiciPF = $radiciPF + @((Join-Path $drive "Program Files"), (Join-Path $drive "Program Files (x86)")) }
  foreach($ri in $radiciPF){
    if(-not $ri){ continue }
    if(-not (Test-Path -LiteralPath $ri)){ continue }
    $giaVisto = $false
    foreach($x in $radiciInst){ if($x -ieq $ri){ $giaVisto = $true } }
    if(-not $giaVisto){ [void]$radiciInst.Add($ri) }
  }
  foreach($ri in $radiciInst){
    foreach($d1 in @(Get-ChildItem -LiteralPath $ri -Directory -ErrorAction SilentlyContinue)){
      $nome1 = $false
      foreach($k in $paroleChiave){ if($d1.Name -like ("*" + $k + "*")){ $nome1 = $true } }
      if($nome1 -or (Test-Path -LiteralPath (Join-Path $d1.FullName "terminal64.exe"))){ AggiungiCandidata $d1.FullName ("installazione in " + $ri) }
      foreach($d2 in @(Get-ChildItem -LiteralPath $d1.FullName -Directory -ErrorAction SilentlyContinue)){
        $int2 = (Test-Path -LiteralPath (Join-Path $d2.FullName "terminal64.exe"))
        if(-not $int2){ foreach($k in $paroleChiave){ if($d2.Name -like ("*" + $k + "*")){ $int2 = $true } } }
        if($int2){ AggiungiCandidata $d2.FullName ("installazione in " + $d1.FullName) }
      }
    }
  }
  if($CartellaDati -ne ""){ AggiungiCandidata $CartellaDati "IMPOSTA A MANO con -CartellaDati" }

  # la finestra dei log e' LARGA (180 giorni) apposta: un conto reale
  # aperto tempo fa e mai usato puo' avere una sola riga di login vecchia,
  # e quella riga e' l'unico fatto che distingue il terminale giusto.
  $limite = (Get-Date).AddDays(-180)
  foreach($c in $Cand){
    $o = Join-Path $c.Percorso "origin.txt"
    if(Test-Path -LiteralPath $o){
      try{ $c.Origin = ([string](Get-Content -LiteralPath $o -Raw -ErrorAction Stop)).Trim() }catch{ $c.Origin = ""; $c.Leggibile = $false }
    }
    $basi = @()
    $bd = Join-Path $c.Percorso "bases"
    if(Test-Path -LiteralPath $bd){
      try{ $basi = @(Get-ChildItem -LiteralPath $bd -Directory -ErrorAction Stop | ForEach-Object { $_.Name }) }catch{ $c.Leggibile = $false }
    }
    $c.Basi = (@($basi) -join ", ")
    $loginSet = @{}
    $vietatiVisti = @{}
    foreach($sub in @("logs","MQL5\Logs")){
      $dir = Join-Path $c.Percorso $sub
      if(-not (Test-Path -LiteralPath $dir)){ continue }
      $files = @()
      try{
        $files = @(Get-ChildItem -LiteralPath $dir -Filter "*.log" -File -ErrorAction Stop |
                   Where-Object { $_.LastWriteTime -ge $limite -and $_.Length -lt 60000000 } |
                   Sort-Object LastWriteTime -Descending | Select-Object -First 40)
      }catch{ $c.Leggibile = $false }
      $c.FileLog = $c.FileLog + $files.Count
      foreach($f in $files){
        $righeL = @()
        try{ $righeL = LeggiTesto $f.FullName }catch{ $c.Leggibile = $false; continue }
        $txt = ($righeL -join "`n")
        if($txt.IndexOf("'" + $LoginAtteso + "'") -ge 0){ $c.VistoAtteso = $true }
        foreach($vv in $VIETATI_CONTI){ if($txt.IndexOf("'" + $vv + "'") -ge 0){ $vietatiVisti[$vv] = 1 } }
        foreach($m in [regex]::Matches($txt, "'(\d{5,})': (?:login|authorized) on")){ $loginSet[$m.Groups[1].Value] = 1 }
      }
    }
    if($loginSet.Keys.Count -gt 0){ $c.Logins = (@($loginSet.Keys | Sort-Object) -join ",") }
    if($vietatiVisti.Keys.Count -gt 0){ $c.VistiVietati = (@($vietatiVisti.Keys | Sort-Object) -join ",") }
    if($env:APPDATA){ $c.Profilo = $c.Percorso.StartsWith(($env:APPDATA.TrimEnd("\")), [System.StringComparison]::OrdinalIgnoreCase) }

    if(-not $c.HaMql){ $c.Scarto = "nessuna cartella MQL5\ (installazione non portable: i dati stanno altrove)"; continue }
    # IL CANCELLO CHE NON SI APRE MAI: un terminale che ha visto uno dei
    # due conti DEMO e' fuori, punto. Anche se avesse visto pure quello
    # atteso -- anzi, SOPRATTUTTO allora.
    if($c.VistiVietati -ne ""){
      $c.Scarto = "HA VISTO UN CONTO VIETATO nei log (" + $c.VistiVietati + "): fuori dal perimetro, e non c'e' manopola che lo sblocchi"
      continue
    }
    if($BaseAttesa -ne ""){
      $trovataBase = $false
      foreach($b in $basi){ if($b -ieq $BaseAttesa){ $trovataBase = $true } }
      if(-not $trovataBase){ $c.Scarto = "nessuna bases\" + $BaseAttesa + " (chiesta con -BaseAttesa); qui c'e': " + $c.Basi; continue }
    }
    $c.Eleggibile = $true
    if(-not $c.VistoAtteso){ $c.Scarto = "il login " + $LoginAtteso + " NON compare nei log degli ultimi 180 giorni: non e' scartata, ma NON si sceglie da sola" }
    elseif(-not $c.Profilo){ $c.Scarto = "il login c'e', ma la cartella sta sotto un ALTRO profilo utente (questa sessione e' " + $env:USERNAME + "): non scelta da sola. Se e' davvero lei, imponila con -CartellaDati" }
  }

  $righeC.Clear()
  [void]$righeC.Add("CARTELLE GUARDATE (conto cercato " + $LoginAtteso + ", vietati " + ($VIETATI_CONTI -join "/") + ", candidate " + $Cand.Count + "):")
  foreach($c in $Cand){
    $tag = "scartata"
    if($c.Eleggibile -and $c.VistoAtteso -and $c.Profilo){ $tag = "SCEGLIBILE: login confermato nei log e sotto il profilo di questa sessione" }
    elseif($c.Eleggibile -and $c.VistoAtteso){ $tag = "login confermato, ma sotto un ALTRO profilo" }
    elseif($c.Eleggibile){ $tag = "passa i gate ma SENZA il login nei log" }
    [void]$righeC.Add("  --- " + $c.Percorso + "   [" + $tag + "]")
    [void]$righeC.Add("      trovata come: " + $c.Origine)
    [void]$righeC.Add("      terminal64.exe=" + $c.HaExe + " metaeditor64.exe=" + $c.HaMe + " logs\=" + $c.HaLogs + " MQL5\=" + $c.HaMql + " file di log letti=" + $c.FileLog + " leggibile=" + $c.Leggibile)
    if($c.Origin -ne ""){ [void]$righeC.Add("      origin.txt: " + $c.Origin) }
    $bb = "nessuna"
    if($c.Basi -ne ""){ $bb = $c.Basi }
    [void]$righeC.Add("      bases\ (i server visti da questo terminale): " + $bb)
    $lg = "nessuno"
    if($c.Logins -ne ""){ $lg = $c.Logins }
    [void]$righeC.Add("      login visti nei log: " + $lg + "   atteso " + $LoginAtteso + "=" + $c.VistoAtteso)
    if($c.VistiVietati -ne ""){ [void]$righeC.Add("      CONTI VIETATI VISTI QUI: " + $c.VistiVietati) }
    $q = New-Object System.Collections.ArrayList
    foreach($n in @($LOGGER,$SEDIA1,$SEDIA2)){
      if(Test-Path -LiteralPath (Join-Path $c.Percorso ("MQL5\Experts\" + $n + ".mq5"))){ [void]$q.Add($n) }
    }
    $qq = "nessuno"
    if($q.Count -gt 0){ $qq = (@($q) -join ", ") }
    [void]$righeC.Add("      artefatti di casa gia' qui: " + $qq)
    if($c.Scarto -ne ""){ [void]$righeC.Add("      nota: " + $c.Scarto) }
  }
  foreach($r in $righeC){ Write-Host ("  " + $r) -ForegroundColor Gray }

  $DemoCand = @($Cand | Where-Object { $_.VistiVietati -ne "" })
  $conLogin = @($Cand | Where-Object { $_.Eleggibile -and $_.VistoAtteso })
  $auto     = @($conLogin | Where-Object { $_.Profilo })

  if($CartellaDati -ne ""){
    $imp = @($Cand | Where-Object { $_.Origine -like "*IMPOSTA A MANO*" })
    if($imp.Count -eq 0){ throw ("-CartellaDati '" + $CartellaDati + "' non esiste o non ha nessuna traccia di un terminale: non la uso.") }
    if($imp[0].VistiVietati -ne ""){
      throw ("-CartellaDati '" + $CartellaDati + "' HA VISTO UN CONTO VIETATO (" + $imp[0].VistiVietati + "). Questo cancello NON si apre nemmeno a mano: mi fermo.")
    }
    if(-not $imp[0].Eleggibile){ throw ("-CartellaDati '" + $CartellaDati + "' NON passa i gate: " + $imp[0].Scarto + ". La manopola non salta i controlli: mi fermo.") }
    if($imp[0].VistoAtteso){
      $Reale = $imp[0]
      $Criterio = "IMPOSTA A MANO con -CartellaDati, E col login " + $LoginAtteso + " CONFERMATO nei suoi log; nessun conto vietato visto qui"
    }
    elseif($ConfermoConto -ne ""){
      $Reale = $imp[0]
      $Criterio = "SCELTA ATTESTATA A MANO, NON MISURATA: il login " + $LoginAtteso + " NON compare nei log di questa cartella. La cartella e' stata imposta con -CartellaDati e il numero e' stato riscritto con -ConfermoConto. Nessun conto vietato e' stato visto qui, e questo resta MISURATO."
      [void]$Rilievi.Add("SCELTA ATTESTATA A MANO: il login " + $LoginAtteso + " non e' stato trovato nei log della cartella scelta. La riga si e' fidata della tua firma (-ConfermoConto), non di una misura. QUI SI INSTALLA UN EA CHE PUO' CHIUDERE POSIZIONI: prima di attaccarlo, guarda con gli occhi il numero di conto in MT5.")
    }
    else{
      throw ("-CartellaDati '" + $CartellaDati + "' NON mostra il login " + $LoginAtteso + " nei log degli ultimi 180 giorni. Qui si installa un EA che puo' chiudere posizioni vere e non installo su una cartella che non so riconoscere. Se sei SICURO che sia quella (aprila in MT5 e guarda il numero di conto), rilancia LO STESSO blocco aggiungendo anche: -ConfermoConto " + $LoginAtteso)
    }
  }
  elseif($auto.Count -eq 1){
    $Reale = $auto[0]
    $Criterio = "FATTO: unica cartella dati con il login " + $LoginAtteso + " nei log, sotto il profilo di questa sessione (" + $env:USERNAME + "), e senza nessuna traccia dei conti vietati"
    if($conLogin.Count -gt 1){
      $altre = @($conLogin | Where-Object { -not $_.Profilo } | ForEach-Object { $_.Percorso }) -join " | "
      [void]$Rilievi.Add("altre " + ($conLogin.Count - 1) + " cartelle mostrano lo stesso login ma stanno sotto un ALTRO profilo utente, e NON sono state toccate: " + $altre)
    }
  }
  elseif($conLogin.Count -eq 0){
    throw ("NON HO TROVATO NESSUNA CARTELLA CON IL LOGIN " + $LoginAtteso + " nei log degli ultimi 180 giorni. L'elenco completo di quello che ho guardato e' qui sopra e nel referto (CANDIDATE.txt), con i login visti in ognuna. Due strade: (1) se il terminale del reale sta sotto un'altra sessione Windows, cambia sessione e rilancia LO STESSO blocco; (2) se lo riconosci nell'elenco, rilancia con -CartellaDati ""<percorso>"" -ConfermoConto " + $LoginAtteso + ". NON ho toccato niente.")
  }
  else{
    throw ("NON SO QUALE CARTELLA E' IL REALE: " + $conLogin.Count + " cartelle mostrano il login " + $LoginAtteso + ", ma " + $auto.Count + " sotto il profilo di questa sessione (ne serve esattamente 1). L'elenco e' qui sopra e nel referto. Rilancia LO STESSO blocco aggiungendo: -CartellaDati ""<percorso>"".")
  }

  $Scelta = $Reale.Percorso
  $vistoTxt = "NON TROVATO (scelta attestata a mano)"
  if($Reale.VistoAtteso){ $vistoTxt = "TROVATO" }
  $loginTxt = "nessuno"
  if($Reale.Logins -ne ""){ $loginTxt = $Reale.Logins }
  $basiScelta = "nessuna"
  if($Reale.Basi -ne ""){ $basiScelta = $Reale.Basi }
  $ContoTxt = "atteso " + $LoginAtteso + "; nei log della cartella scelta: " + $vistoTxt +
              "; login visti qui: " + $loginTxt +
              "; conti vietati visti qui: NESSUNO (verificato su " + $Reale.FileLog + " file di log)"
  $BasiTxt = "bases\ della cartella scelta: " + $basiScelta

  $MqlDir = Join-Path $Scelta "MQL5"

  # -------------------------------------------------------------------
  #  3-bis. CONFERMA INCROCIATA: I TRE COINQUILINI E L'INCLUDE
  # -------------------------------------------------------------------
  # I tre EA gia' installati su questo conto devono essere QUI. Se non
  # ci sono, non e' un blocco (potrebbero stare altrove) ma e' un
  # RILIEVO FORTE: vuol dire che stiamo per mettere il guardiano su un
  # terminale diverso da quello che sorveglia le sedie -- cioe' un
  # guardiano che non guarda niente.
  $Vicini = @(
    @{ N=$LOGGER; Magic="";        Mq5=(Join-Path $MqlDir ("Experts\" + $LOGGER + ".mq5")); Ex5=(Join-Path $MqlDir ("Experts\" + $LOGGER + ".ex5")) },
    @{ N=$SEDIA1; Magic=$SEDIA1M;  Mq5=(Join-Path $MqlDir ("Experts\" + $SEDIA1 + ".mq5")); Ex5=(Join-Path $MqlDir ("Experts\" + $SEDIA1 + ".ex5")) },
    @{ N=$SEDIA2; Magic=$SEDIA2M;  Mq5=(Join-Path $MqlDir ("Experts\" + $SEDIA2 + ".mq5")); Ex5=(Join-Path $MqlDir ("Experts\" + $SEDIA2 + ".ex5")) }
  )
  $vicOk = New-Object System.Collections.ArrayList
  $vicKo = New-Object System.Collections.ArrayList
  foreach($x in $Vicini){
    $hm = (Test-Path -LiteralPath $x.Mq5)
    $he = (Test-Path -LiteralPath $x.Ex5)
    $mg = "n/d"
    if($hm -and $x.Magic -ne ""){
      $t = ((LeggiTesto $x.Mq5) -join "`n")
      if($t.IndexOf($x.Magic, [System.StringComparison]::Ordinal) -ge 0){ $mg = "magic " + $x.Magic + " TROVATO nel .mq5" }
      else{ $mg = "MAGIC " + $x.Magic + " NON TROVATO nel .mq5" }
    }
    if($hm -and $he -and ($x.Magic -eq "" -or $mg -like "magic*TROVATO*")){
      [void]$vicOk.Add($x.N + " (.mq5+.ex5" + $(if($x.Magic -ne ""){ ", " + $mg }else{ "" }) + ")")
    }
    else{
      [void]$vicKo.Add($x.N + ": .mq5=" + $hm + " .ex5=" + $he + " " + $mg)
    }
    # fotografati: NON si toccano, e si deve poterlo dimostrare
    foreach($p in @($x.Mq5,$x.Ex5)){
      [void]$FotoVic.Add([pscustomobject]@{ Chi=$x.N; Percorso=$p; Prima=$null; Dopo=$null })
    }
  }
  if(@($vicKo).Count -gt 0){
    $VicinieTxt = "RILIEVO FORTE -- " + @($vicKo).Count + " artefatti su 3 NON tornano in questa cartella: " + (@($vicKo) -join " | ") + ". Quelli a posto: " + (@($vicOk) -join ", ") + ". Non blocca (potrebbero stare altrove), ma un guardiano su un terminale che non ospita le sedie sorveglia un conto che non trada."
    [void]$Rilievi.Add($VicinieTxt)
  }
  else{
    $VicinieTxt = "SI, tutti e tre gli artefatti di casa sono gia' in questa cartella con i magic attesi: " + (@($vicOk) -join " | ") + ". Conferma incrociata piena che e' il terminale del reale su cui abbiamo gia' lavorato."
  }
  $CoinquiTxt = $VicinieTxt

  # L'INCLUDE: si VERIFICA, non si riscrive. E' anche la conferma
  # incrociata piu' forte: quei byte esatti ce li ha messi la nostra riga
  # di stamattina.
  $DestMqh = Join-Path $MqlDir ("Include\" + $INC)
  if(-not (Test-Path -LiteralPath $DestMqh)){
    throw ("L'INCLUDE " + $INC + " NON C'E' in questa cartella (" + $DestMqh + "). " + $EA + " lo include: senza, la compilazione fallisce. E la sua assenza vuol dire che il deploy delle due sedie NON e' andato in QUESTA cartella dati: prima di installare un guardiano, si capisce su quale terminale siamo. NON installo.")
  }
  $hIncPin  = HashPieno $Mqh
  $hIncTerm = HashPieno $DestMqh
  if($hIncPin -eq "" -or $hIncTerm -eq ""){ throw ("non riesco a calcolare lo sha256 dell'include (al pin: '" + $hIncPin + "', nel terminale: '" + $hIncTerm + "'). Senza quel confronto non installo.") }
  if($hIncPin -ne $hIncTerm){
    throw ("L'INCLUDE NEL TERMINALE E' DIVERSO DA QUELLO AL PIN. Nel terminale: " + (Descrivi $DestMqh) + " | al pin: " + (Descrivi $Mqh) + ". Non lo sovrascrivo e non compilo: i DUE .ex5 GIA' IN CAMPO (" + $SEDIA1 + " e " + $SEDIA2 + ") sono stati compilati contro il file che sta nel terminale, e cambiarglielo sotto i piedi -- o compilare il guardiano contro un file diverso dal loro -- vuol dire due meta' di un canale che potrebbero non parlarsi. O il pin e' sbagliato, o qualcuno ha toccato il terminale: in tutti e due i casi si guarda prima. NON installo.")
  }
  $IncludeTxt = "IDENTICO al pin e NON TOCCATO: " + (Descrivi $DestMqh) + " -- stesso sha256 del file al pin. Il guardiano verra' compilato contro ESATTAMENTE lo stesso include con cui sono stati compilati i due .ex5 gia' in campo."
  [void]$GateTxt.Add("include nel terminale: presente e con lo STESSO sha256 del pin -> non viene riscritto (i due .ex5 gia' in campo dipendono da quel file)")
  Dico ("include verificato e NON toccato: " + $IncludeTxt) "Green"

  $MeOrigin = ""
  if($Reale.Origin -ne ""){ try{ $MeOrigin = (Join-Path $Reale.Origin "metaeditor64.exe") }catch{ $MeOrigin = ""; [void]$Rilievi.Add("l'origin.txt della cartella scelta ('" + $Reale.Origin + "') non e' un percorso usabile da questa sessione: cerco metaeditor64.exe nella cartella dati.") } }
  if($MeOrigin -ne "" -and (Test-Path -LiteralPath $MeOrigin)){ $Inst = $Reale.Origin }
  elseif($Reale.HaMe){ $Inst = $Reale.Percorso }
  else{ throw ("metaeditor64.exe dell'installazione del conto reale NON trovato (origin.txt: '" + $Reale.Origin + "'): senza il SUO compilatore non installo niente.") }
  $Me = Join-Path $Inst "metaeditor64.exe"

  # gli include DI LIBRERIA devono gia' esistere nel terminale, se no la
  # compilazione fallisce per un motivo di AMBIENTE e non di codice.
  foreach($a in $altriInc){
    $p = Join-Path (Join-Path $MqlDir "Include") ($a -replace '/','\')
    if(-not (Test-Path -LiteralPath $p)){
      throw ("INCLUDE DI LIBRERIA NON TROVATO nel terminale del reale: '" + $a + "' (cercato in " + $p + "). La compilazione fallirebbe per AMBIENTE: non installo.")
    }
  }

  # I TRE ARTEFATTI. L'include NON e' fra questi: si verifica e basta.
  $DestMq5 = Join-Path $MqlDir ("Experts\" + $EA + ".mq5")
  $DestEx5 = Join-Path $MqlDir ("Experts\" + $EA + ".ex5")
  $DestSet = Join-Path $MqlDir ("Presets\" + $SET)
  $Art = @(
    @{ N="Experts\" + $EA + ".mq5"; P=$DestMq5; S=$Mq5  },
    @{ N="Experts\" + $EA + ".ex5"; P=$DestEx5; S=""    },
    @{ N="Presets\" + $SET;         P=$DestSet; S=$SetF }
  )
  $TuttiDest = @()
  foreach($a in $Art){ $TuttiDest = $TuttiDest + @($a.P) }

  Dico ("cartella dati scelta: " + $Scelta) "Yellow"
  Dico ("criterio ............ " + $Criterio) "Yellow"
  Dico ("installazione ....... " + $Inst) "Yellow"
  Dico ("coinquilini ......... " + $CoinquiTxt) "Yellow"

  # -------------------------------------------------------------------
  #  4. LE FOTO PRIMA
  # -------------------------------------------------------------------
  Titolo "4. FOTO PRIMA (i tre artefatti, i tre coinquilini + include, Presets file per file, grafici e config)"
  foreach($a in $Art){ $FotoP[$a.N] = Foto $a.P; Dico ("REALE prima -- " + $a.N + ": " + (FotoTxt $FotoP[$a.N])) }
  $gia = New-Object System.Collections.ArrayList
  foreach($a in $Art){ if($FotoP[$a.N].Esiste){ [void]$gia.Add($a.N) } }
  if($gia.Count -gt 0){ $GiaLi = "SI, " + $gia.Count + " dei 3 file erano gia' in questo terminale (" + (@($gia) -join ", ") + "). Verranno sostituiti, col backup.  --> QUESTO E' UN AGGIORNAMENTO (v" + $VER_KO + " -> v" + $VER + "), NON un'installazione nuova." }
  else{ $GiaLi = "NO: nessuno dei 3 file era in questo terminale (installazione NUOVA del guardiano)" }

  # --- SONDA: QUALCUNO TIENE APERTO L'.EX5 DEL GUARDIANO?
  #  Dal 06/09 questo EA non e' piu' un file nuovo: sta gia' su un grafico
  #  VIVO di questo terminale. Se e' attaccato, Windows tiene il suo .ex5
  #  aperto e la CORSA si ferma da sola quando prova a cancellarlo (il gate
  #  "EX5 VECCHIO NON CANCELLABILE" piu' sotto). Meglio dirlo ADESSO, gia'
  #  in CONTROLLO -- che e' il giro che non scrive niente -- piuttosto che
  #  farglielo scoprire a meta' di una CORSA sul conto reale.
  #
  #  ONESTA' SULLA MISURA, perche' qui e' facilissimo spacciare una sonda
  #  per una prova. Questa chiede il file in lettura ESCLUSIVA, che NON e'
  #  la stessa domanda di "riesco a cancellarlo?". Puo' sbagliare in TUTTE
  #  E DUE le direzioni, e sul banco si sono viste tutte e due:
  #    - puo' ALLARMARE SENZA MOTIVO: chi tiene aperto il file puo' aver
  #      concesso la condivisione in cancellazione, e allora la CORSA
  #      passerebbe lo stesso;
  #    - puo' TACERE A TORTO: un file puo' essere non cancellabile pur
  #      restando apribile in lettura (misurato sul banco del 06/09 con un
  #      file marcato immutabile: la sonda diceva "libero", la
  #      cancellazione falliva lo stesso).
  #  Quindi nessuno dei due esiti e' una prova, e la prova vera la da' solo
  #  la CORSA quando prova a cancellarlo davvero. Per questo e' un RILIEVO
  #  e non un blocco: serve a dare a Claudio un preavviso quando c'e', non
  #  a promettergli che andra' bene quando tace.
  if($FotoP[("Experts\" + $EA + ".ex5")].Esiste){
    try{
      $fs = [System.IO.File]::Open($DestEx5,[System.IO.FileMode]::Open,[System.IO.FileAccess]::Read,[System.IO.FileShare]::None)
      $fs.Close()
      $fs.Dispose()
      $Ex5Aperto = "l'.ex5 del guardiano c'e' gia' e NON risulta tenuto aperto da nessun processo (sonda in lettura esclusiva riuscita). ATTENZIONE: questo NON e' un via libera. La sonda chiede 'posso aprirlo in esclusiva?', che non e' la stessa domanda di 'posso cancellarlo?', e sul banco si e' visto un file NON cancellabile che la sonda dichiarava libero. Se il guardiano e' su un grafico, STACCALO LO STESSO prima della CORSA."
    }
    catch{
      $Ex5Aperto = "ATTENZIONE -- l'.ex5 del guardiano c'e' gia' ed e' TENUTO APERTO DA UN PROCESSO (" + $_.Exception.GetType().Name + "). Su questo terminale il guardiano sta su un grafico vivo dal 06/09: STACCALO PRIMA di lanciare la CORSA (tasto destro sul SUO grafico > Expert Advisors > Rimuovi). Se non lo fai, la CORSA non compila e rimette tutto com'era: e' il comportamento VOLUTO, non un guasto."
      [void]$Rilievi.Add($Ex5Aperto)
    }
  }
  else{ $Ex5Aperto = "l'.ex5 del guardiano NON e' in questo terminale: niente da staccare e niente da sbloccare." }
  Dico ("sonda sull'.ex5 del guardiano: " + $Ex5Aperto) "Yellow"

  # I COINQUILINI + L'INCLUDE: non si toccano e devono restare identici.
  foreach($f in $FotoVic){ $f.Prima = Foto $f.Percorso }
  [void]$FotoVic.Add([pscustomobject]@{ Chi=$INC; Percorso=$DestMqh; Prima=(Foto $DestMqh); Dopo=$null })

  # il REGISTRO del logger e' VIVO: si fotografa per dire cosa c'e', ma
  # se cresce e' NORMALE (scrive ogni 10 s a MT5 aperto).
  $InvFileP = Inventario (Join-Path $MqlDir "Files") ($LOGGER + "*")

  # PRESETS: qui ci scriviamo, quindi non basta "invariato". Si fa
  # l'inventario FILE PER FILE e si pretende che cambi SOLO il nostro.
  $InvPreP = Inventario (Join-Path $MqlDir "Presets") "*"
  Dico ("Presets prima: " + $InvPreP.Keys.Count + " file")

  # cartelle che NON devono cambiare: i grafici e la configurazione.
  # (E' la prova che questa riga non attacca il guardiano a nessun
  # grafico -- e finche' non e' su un grafico, non puo' chiudere niente.)
  $DirParam = @(@{N="MQL5\Profiles\Charts"; P=(Join-Path $MqlDir "Profiles\Charts")},
                @{N="Profiles\Charts (radice)"; P=(Join-Path $Scelta "Profiles\Charts")},
                @{N="config"; P=(Join-Path $Scelta "config")})
  foreach($d in $DirParam){ $FotoDirP[$d.N] = FotoDir $d.P; Dico ("parametri prima -- " + $d.N + ": " + $FotoDirP[$d.N]) }

  foreach($c in $DemoCand){
    foreach($a in $Art){
      $p = Join-Path $c.Percorso ("MQL5\" + $a.N)
      [void]$FotoDemo.Add([pscustomobject]@{ Percorso=$p; Prima=(Foto $p); Dopo=$null })
    }
  }
  $FotoPrese = $true

  if($Modo -eq "CONTROLLO"){
    $Comp = "NON TENTATA (modo CONTROLLO: non si scrive e non si compila)"
    $InstallTxt = "NON AVVENUTA (modo CONTROLLO). In CORSA scriverebbe questi 3: " + (@($TuttiDest) -join " | ")
    $BackupTxt  = "NON FATTO (modo CONTROLLO)"
  }
  else{
    # -----------------------------------------------------------------
    #  5. BACKUP + SENTINELLA, POI LA SCRITTURA
    # -----------------------------------------------------------------
    Titolo "5. BACKUP DEI TRE, SENTINELLA E COPIA NEL TERMINALE"
    $BackupDir = Join-Path (Join-Path $Dsk ("backup_guardian_" + $Avvio.ToString("yyyyMMdd",$INV))) $Avvio.ToString("HHmmss",$INV)
    New-Item -ItemType Directory -Force -Path $BackupDir | Out-Null
    $bk = New-Object System.Collections.ArrayList
    foreach($a in $Art){
      if(Test-Path -LiteralPath $a.P){
        Copy-Item -LiteralPath $a.P -Destination (Join-Path $BackupDir (Split-Path -Leaf $a.P)) -Force
        [void]$bk.Add((Split-Path -Leaf $a.P) + ": " + (Descrivi $a.P))
      }
      else{ [void]$bk.Add((Split-Path -Leaf $a.P) + ": non c'era (il ripristino lo togliera')") }
    }
    Set-Content -LiteralPath (Join-Path $BackupDir "BACKUP_ORIGINE.txt") -Value (@("backup del " + $Avvio.ToString("yyyy-MM-dd HH:mm:ss",$INV), "cartella dati: " + $Scelta, "conto atteso: " + $LoginAtteso, "artefatto: " + $EA + " v" + $VER + " magic " + $MAGIC) + @($bk)) -Encoding ASCII
    $BackupTxt = "FATTO in " + $BackupDir + " -- " + (@($bk) -join " | ")
    # SENTINELLA scritta PRIMA della prima scrittura nel terminale.
    # Ultima riga = la cartella di backup. E' QUESTO il registro delle
    # scritture da cui si comanda il ripristino (116-quater): mai una
    # bandiera alzata dopo la Copy-Item.
    Set-Content -LiteralPath $Sentinella -Value (@($TuttiDest) + @($BackupDir)) -Encoding ASCII

    New-Item -ItemType Directory -Force -Path (Join-Path $MqlDir "Experts"),(Join-Path $MqlDir "Presets") | Out-Null
    # PRIMA il sorgente. Il .set entra SOLO IN FONDO, e solo se la
    # compilazione e' andata: un preset da caricare senza l'EA compilato
    # e' un invito a sbagliare.
    foreach($a in $Art){
      if($a.S -eq ""){ continue }
      if($a.N -like "Presets\*"){ continue }
      Copy-Item -LiteralPath $a.S -Destination $a.P -Force
      if((HashPieno $a.S) -ne (HashPieno $a.P)){ throw ("COPIA NON VERIFICATA: " + $a.N + " nel terminale non ha lo stesso sha256 di quello scaricato al pin.") }
      Dico ("copiato " + $a.P) "Green"
    }

    # l'.ex5 vecchio si CANCELLA prima: un binario vecchio sopravvissuto
    # si spaccia per nuovo (checklist 54).
    if(Test-Path -LiteralPath $DestEx5){
      Remove-Item -LiteralPath $DestEx5 -Force -ErrorAction SilentlyContinue
      if(Test-Path -LiteralPath $DestEx5){
        # DAL 06/09 QUESTO NON E' PIU' UN CASO DI SCUOLA: il guardiano e'
        # gia' su un grafico vivo di questo terminale, quindi e' LA causa
        # attesa numero uno. Il messaggio deve dire cosa fare, non solo
        # che qualcosa e' andato storto -- e deve dire chiaro che fermarsi
        # QUI e' il comportamento giusto, se no si prova a forzare.
        throw ("EX5 VECCHIO NON CANCELLABILE (" + $DestEx5 + "): qualcuno tiene quel file APERTO." +
               "  ||  CAUSA ATTESA NUMERO UNO, e non e' un guasto: " + $EA + " E' GIA' ATTACCATO A UN GRAFICO di questo terminale (ce l'hai messo il 06/09). Finche' e' su un grafico, MT5 tiene il binario aperto e non si puo' sostituire." +
               "  ||  COSA FARE, in quest'ordine: (1) in MT5 vai sul grafico dove gira il guardiano -- riconoscibile dal pannello '=== ABTG GUARDIAN ==='; (2) tasto destro sul grafico > Expert Advisors > Rimuovi (in alternativa chiudi proprio quel grafico); (3) controlla che la faccina in alto a destra di quel grafico sia sparita; (4) rilancia LA STESSA riga di CORSA, senza cambiare niente." +
               "  ||  MT5 puo' restare aperto: le due sedie e il logger non c'entrano e continuano a lavorare." +
               "  ||  NON COMPILO, e nel terminale non resta niente a meta': i file toccati fin qui tornano com'erano dal backup " + $BackupDir + ". Un .ex5 vecchio che sopravvive a una ricompilazione si spaccia per nuovo, e su un conto reale un guardiano che si spaccia per aggiornato mentre ha ancora il bug del credito e' il peggiore dei due mondi.")
      }
    }

    # -----------------------------------------------------------------
    #  6. LA COMPILAZIONE -- TUTTO O NIENTE
    # -----------------------------------------------------------------
    Titolo "6. COMPILAZIONE"
    $err = -1; $war = -1; $ok = $false

    # 94-ter: il campo si timbra PRIMA del lancio. Se l'invocazione stessa
    # esplode, il referto non deve dire "non ci siamo arrivati" mentre nel
    # terminale il .mq5 nuovo c'e' gia'.
    $Comp = "FALLITA -- METAEDITOR NON PARTITO (eccezione al lancio di " + $Me + ": vedi la riga FERMATO)"
    $InstallTxt = "TENTATA -- COMPILAZIONE IN CORSO. Se questa riga e' rimasta cosi', il giro e' morto durante la compilazione: guarda le tre righe REALE e il backup " + $BackupDir + "."
    $e = Compila $Me @(("/compile:" + $DestMq5), ("/inc:" + $MqlDir), ("/log:" + $LogPath)) $DestEx5 $LogPath $TimeoutSec $EA
    $LogRighe = @($e.Log)
    if($null -ne $e.Rc){ $Rc = "" + $e.Rc + "   (1 e' NORMALE su questo VPS: e' il numero di file compilati, misurato il 03/09)" }
    $res = @($LogRighe | Where-Object { $_ -match 'Result:' })
    if(@($res).Count -gt 0){ $Result = ($res[0]).Trim() }
    $mx = [regex]::Match($Result, '(\d+)\s+error');   if($mx.Success){ $err = [int]::Parse($mx.Groups[1].Value,$INV) }
    $mw = [regex]::Match($Result, '(\d+)\s+warning'); if($mw.Success){ $war = [int]::Parse($mw.Groups[1].Value,$INV) }
    if($e.Ex5 -and $err -eq 0){
      $ok = $true
      $Comp = "OK (" + [math]::Round((Get-Item -LiteralPath $DestEx5).Length/1024,1) + " KB, " + (Get-Item -LiteralPath $DestEx5).Length + " byte, " + (Get-Item -LiteralPath $DestEx5).LastWriteTime.ToString("HH:mm:ss",$INV) + "), " + $Result
    }
    elseif($e.Muto){ $Comp = "FALLITA -- METAEDITOR MUTO (lanciato, tornato senza log ne' .ex5). Tipico: editor aperto, percorso, permessi." }
    elseif($e.Ex5 -and $err -lt 0){ $Comp = "FALLITA -- .ex5 FRESCO MA RIGA 'Result:' NON LETTA nel log: non posso dire quanti errori ci sono, e su un conto reale un 'boh' vale come un no. Ripristino." }
    else{ $Comp = "FALLITA (" + $Result + ")" }
    Dico ($EA + ": " + $Comp) "Yellow"

    if($ok){
      # IL PRESET ENTRA SOLO ADESSO
      foreach($a in $Art){
        if($a.N -notlike "Presets\*"){ continue }
        Copy-Item -LiteralPath $a.S -Destination $a.P -Force
        if((HashPieno $a.S) -ne (HashPieno $a.P)){ throw ("COPIA NON VERIFICATA: " + $a.N + " nel terminale non ha lo stesso sha256 di quello scaricato al pin.") }
        Dico ("copiato " + $a.P) "Green"
      }
      $SetCopiato = $true
      $InstallTxt = "AVVENUTA: 3 file su 3 (" + (@($TuttiDest) -join " | ") + ").  L'include NON e' stato toccato, ed e' giusto cosi'."
      Remove-Item -LiteralPath $Sentinella -Force -ErrorAction SilentlyContinue
      if($war -gt 0){
        [void]$Problemi.Add("COMPILAZIONE CON " + $war + " WARNING. La regola di casa pretende 0 errors E 0 warnings: i file sono installati, ma NON ATTACCARE NIENTE prima di avermi mandato lo zip col log.")
      }
    }
    else{
      # 116-quater: i due campi si timbrano PRIMA del ripristino. Se il
      # ripristino STESSO esplode, il referto non deve dire "mai scritto".
      $InstallTxt = "TENTATA -- RIPRISTINO IN CORSO. Se questa riga e' rimasta cosi', il ripristino STESSO e' esploso: nel terminale potrebbero essere rimasti file nuovi. Guarda le tre righe REALE e il backup " + $BackupDir + "."
      $Ripristino = "IN CORSO dal backup " + $BackupDir + " -- se questa riga e' rimasta cosi', rimetti a mano dal backup."
      $Ripristino = (RipristinaDaBackup $BackupDir $TuttiDest) -join "; "
      $InstallTxt = "TENTATA E RIPRISTINATA (tutto o niente: la compilazione non e' andata, quindi TUTTI E TRE i file sono tornati com'erano)"
      [void]$Problemi.Add("compilazione non riuscita -- " + $EA + ": " + $Comp)
      Remove-Item -LiteralPath $Sentinella -Force -ErrorAction SilentlyContinue
    }
  }
}
catch{
  $Fatale = $_.Exception.Message
  Write-Host ("!!! FERMATO: " + $Fatale) -ForegroundColor Red
  # 116-quater: il ripristino si comanda dal REGISTRO DELLE SCRITTURE (backup +
  # sentinella, scritti PRIMA della prima copia), MAI da una bandiera alzata
  # DOPO la Copy-Item. Ripristinare quando non si era scritto e' un no-op.
  if($BackupDir -ne "" -and (Test-Path -LiteralPath $BackupDir)){
    try{
      $dest = @()
      foreach($a in $Art){ $dest = $dest + @($a.P) }
      $InstallTxt = "TENTATA -- RIPRISTINO IN CORSO dopo un'eccezione. Se questa riga e' rimasta cosi', il ripristino STESSO e' esploso."
      $Ripristino = "IN CORSO dal backup " + $BackupDir + " (dopo un'eccezione) -- se questa riga e' rimasta cosi', rimetti a mano dal backup."
      $Ripristino = ((RipristinaDaBackup $BackupDir $dest) -join "; ") + "  (dopo un'eccezione)"
      $InstallTxt = "TENTATA E RIPRISTINATA (eccezione)"
      Remove-Item -LiteralPath $Sentinella -Force -ErrorAction SilentlyContinue
      Write-Host ("ripristino: " + $Ripristino) -ForegroundColor Yellow
    }catch{ [void]$Problemi.Add("RIPRISTINO FALLITO dopo l'eccezione: guarda a mano " + $BackupDir) }
  }
}

# =====================================================================
#  RACCOLTA -- gira SEMPRE, anche quando il giro si e' fermato.
# =====================================================================
try{
  Titolo "RACCOLTA"
  if($FotoPrese -and @($Art).Count -eq 3){
    foreach($a in $Art){
      $dopo = Foto $a.P
      [void]$FotoDopo.Add("REALE " + $a.N + "   prima [" + (FotoTxt $FotoP[$a.N]) + "]   dopo [" + (FotoTxt $dopo) + "]   -> " + (Confronta $FotoP[$a.N] $dopo))
    }
    # GRAFICI E CONFIGURAZIONE. Devono essere INVARIATI, ed e' LA prova
    # che il guardiano non e' stato attaccato a nessun grafico -- cioe'
    # che non e' ancora in condizione di chiudere niente a nessuno.
    $cambi = New-Object System.Collections.ArrayList
    foreach($d in $DirParam){
      $ora = FotoDir $d.P
      if($ora -ne $FotoDirP[$d.N]){ [void]$cambi.Add($d.N + ": prima [" + $FotoDirP[$d.N] + "] dopo [" + $ora + "]") }
    }
    if($cambi.Count -eq 0){ $ParamTxt = "INVARIATI su " + @($DirParam).Count + " cartelle guardate (Profiles\Charts e config: stesso numero di file, stessi byte, stessa ultima scrittura). E' la prova che il guardiano NON e' stato attaccato a nessun grafico da questa riga -- e finche' non sta su un grafico non puo' chiudere niente a nessuno." }
    else{
      $ParamTxt = "ATTENZIONE: " + $cambi.Count + " cartelle di grafici/configurazione risultano cambiate -- " + (@($cambi) -join " || ") + ". Se MT5 e' aperto puo' averle riscritte DA SOLO (e' il suo mestiere): questa riga non ha nessun percorso di scrittura verso quelle cartelle. Va comunque letto."
      [void]$Rilievi.Add($ParamTxt)
    }
    # PRESETS: qui ci abbiamo scritto, e si dimostra CHE COSA.
    $invPreD = Inventario (Join-Path $MqlDir "Presets") "*"
    $att = @()
    if($SetCopiato){ $att = @($SET) }
    $cmp = ConfrontaInventario $InvPreP $invPreD $att
    if(@($cmp.Inattesi).Count -gt 0){
      $PresetsTxt = "ATTENZIONE: nella cartella Presets sono cambiati file che questa riga NON doveva toccare -- " + (@($cmp.Inattesi) -join " | ")
      [void]$Problemi.Add($PresetsTxt)
    }
    elseif($SetCopiato){
      $PresetsTxt = "cambiato SOLO il .set nostro (aggiunti: " + (@($cmp.Agg) -join ", ") + " | sovrascritti: " + (@($cmp.Cam) -join ", ") + "); gli altri " + $InvPreP.Keys.Count + " file gia' presenti sono INVARIATI uno per uno -- compresi i due preset delle sedie messi stamattina"
    }
    else{
      $PresetsTxt = "NESSUN .set scritto in questo giro; i " + $InvPreP.Keys.Count + " file gia' presenti in Presets sono INVARIATI uno per uno"
    }
  }
  else{
    $ParamTxt = "NON MISURATI (il giro si e' fermato prima di scattare le foto: un confronto sul vuoto direbbe INVARIATI senza aver guardato niente)"
    $PresetsTxt = "NON MISURATO (il giro si e' fermato prima delle foto)"
    if($FotoDopo.Count -eq 0){ [void]$FotoDopo.Add("REALE: nessuna foto scattata (il giro si e' fermato prima del punto 4)") }
  }

  # I TRE COINQUILINI E L'INCLUDE: devono essere INVARIATI.
  $vereV = 0; $cambiateV = 0
  foreach($f in $FotoVic){
    if($null -eq $f.Prima){ continue }
    $f.Dopo = Foto $f.Percorso
    if($f.Prima.Esiste -or $f.Dopo.Esiste){ $vereV++ }
    if((Confronta $f.Prima $f.Dopo) -eq "CAMBIATO"){ $cambiateV++ }
  }
  $regTxt = ""
  if($MqlDir -ne "" -and $FotoPrese){
    $invFileD = Inventario (Join-Path $MqlDir "Files") ($LOGGER + "*")
    $cambiReg = 0
    foreach($k in $invFileD.Keys){ if((-not $InvFileP.ContainsKey($k)) -or $InvFileP[$k] -ne $invFileD[$k]){ $cambiReg++ } }
    $regTxt = "  ||  il REGISTRO del logger in MQL5\Files: " + $InvFileP.Keys.Count + " file prima, " + $invFileD.Keys.Count + " dopo, " + $cambiReg + " nuovi o cresciuti -- e SE E' CRESCIUTO E' NORMALE E GIUSTO: scrive ogni 10 secondi finche' MT5 e' aperto. Questa riga non ci ha scritto niente."
  }
  elseif($MqlDir -ne ""){
    $regTxt = "  ||  il REGISTRO del logger in MQL5\Files: NON MISURATO (il giro si e' fermato prima della foto PRIMA: un confronto contro il vuoto non e' una misura)."
  }
  if($cambiateV -gt 0){
    $DemoTxt2 = "ATTENZIONE: " + $cambiateV + " file fra i tre EA gia' in campo e l'include RISULTANO CAMBIATI. Questa riga non doveva toccarli." + $regTxt
    [void]$Problemi.Add($DemoTxt2)
    $CoinquiTxt = $DemoTxt2
  }
  elseif($vereV -gt 0){ $CoinquiTxt = "INVARIATI su " + $vereV + " foto di file REALMENTE PRESENTI (i .mq5/.ex5 di " + $LOGGER + ", " + $SEDIA1 + ", " + $SEDIA2 + " e l'include " + $INC + " intatti)" + $regTxt + "  ||  esito della conferma incrociata: " + $VicinieTxt }
  else{ $CoinquiTxt = "NON MISURATO: non c'era niente da fotografare (classe 117: non si regala un verde)." + $regTxt }

  # I TERMINALI DEI CONTI DEMO: tre stati, e la foto di un file che non
  # c'e' NON e' una prova (classe 117)
  $vere = 0; $cambiate = 0
  foreach($f in $FotoDemo){
    $f.Dopo = Foto $f.Percorso
    if($f.Prima.Esiste -or $f.Dopo.Esiste){ $vere++ }
    if((Confronta $f.Prima $f.Dopo) -eq "CAMBIATO"){ $cambiate++ }
  }
  if($cambiate -gt 0){
    $DemoTxt = "ATTENZIONE: " + $cambiate + " file sotto una cartella di un conto DEMO RISULTANO CAMBIATI"
    [void]$Problemi.Add($DemoTxt)
  }
  elseif($vere -gt 0){ $DemoTxt = "INVARIATO su " + $vere + " foto di file REALMENTE PRESENTI nelle cartelle dei conti demo" }
  else{ $DemoTxt = "NON MISURATO (nessun file vero da fotografare sotto le cartelle dei conti demo). Il perimetro qui regge PER COSTRUZIONE -- questa riga scrive solo sotto la cartella scelta -- ma non e' misurato, e non si regala un verde (classe 117)." }

  # IL MODO STA NEL NOME DEL REFERTO, non solo in quello dello zip
  # (classe 132).
  $ReferTxt = Join-Path $Work ("REFERTO_DEPLOY_GUARDIAN_" + $Modo + ".txt")
  $r = New-Object System.Collections.ArrayList
  [void]$r.Add("=====================================================================")
  [void]$r.Add("  DEPLOY DEL GUARDIANO SUL CONTO REALE -- " + $EA + " v" + $VER + " (magic " + $MAGIC + ")")
  [void]$r.Add("  QUESTO EA, QUANDO GIRA, PUO' CHIUDERE POSIZIONI APERTE: con")
  [void]$r.Add("  InpAction=0 e InpCloseAllMagics=true chiude TUTTO IL CONTO, di")
  [void]$r.Add("  QUALSIASI magic, comprese le posizioni aperte A MANO.")
  [void]$r.Add("  Questa riga lo INSTALLA e lo COMPILA: NON lo attacca a nessun")
  [void]$r.Add("  grafico e NON tocca l'AutoTrading. Finche' non lo fa Claudio,")
  [void]$r.Add("  il guardiano non puo' ne' sorvegliare ne' chiudere niente.")
  [void]$r.Add("=====================================================================")
  $esitoGiro = "COMPLETATO (nessun gate ha fermato il giro)"
  if($Fatale -ne ""){ $esitoGiro = "FERMATO da un gate: " + $Fatale }
  if($Fatale -eq "" -and $Problemi.Count -gt 0){ $esitoGiro = "ARRIVATO IN FONDO MA CON " + $Problemi.Count + " PROBLEMI: leggi la riga INSTALLAZIONE e l'elenco PROBLEMI PRIMA di attaccare qualunque cosa" }
  [void]$r.Add("ESITO DEL GIRO: " + $esitoGiro)
  [void]$r.Add("data: " + $Avvio.ToString("yyyy-MM-dd HH:mm:ss",$INV) + "   (E' L'ORA DI AVVIO DI QUESTO GIRO, non l'ora attuale)")
  [void]$r.Add("modo: " + $Modo + "     macchina: " + $env:COMPUTERNAME + "     sessione: " + $env:USERNAME)
  [void]$r.Add("pin : " + $Pin)
  [void]$r.Add("")
  [void]$r.Add("CONTO ATTESO (-LoginAtteso): " + $LoginAtteso)
  [void]$r.Add("CONTI VIETATI PER SEMPRE ..: " + ($VIETATI_CONTI -join ", ") + "   (i due DEMO; sul 100k gira gia' un Guardian magic " + $MAGIC_FTMO + ")")
  [void]$r.Add("guardia sul conto .........: " + $ContoTxt)
  [void]$r.Add($BasiTxt)
  [void]$r.Add("cartella dati scelta ......: " + $Scelta)
  [void]$r.Add("criterio di scelta ........: " + $Criterio)
  [void]$r.Add("installazione (compilatore): " + $Inst)
  [void]$r.Add("conferma incrociata (i tre EA gia' in campo): " + $VicinieTxt)
  [void]$r.Add("L'INCLUDE (si verifica, NON si riscrive) ...: " + $IncludeTxt)
  [void]$r.Add("IL FILO guardiano -> EA ...................: " + $FiloTxt)
  [void]$r.Add("")
  [void]$r.Add("SORGENTI AL PIN:")
  foreach($x in $SorgTxt){ [void]$r.Add("   " + $x) }
  [void]$r.Add("GATE SUPERATI:")
  foreach($x in $GateTxt){ [void]$r.Add("   " + $x) }
  [void]$r.Add("IL PRESET, APERTO E CONTATO:")
  if($SetTxt.Count -eq 0){ [void]$r.Add("   NON LETTO (il giro si e' fermato prima)") }
  foreach($x in $SetTxt){ [void]$r.Add("   " + $x) }
  [void]$r.Add("valori pretesi (firma Claudio 18/08/2026, CLAUDE.md): giorno " + $A_DAILYLOSS.ToString("0.0#",$INV) + "% . totale " + $A_TOTALDD.ToString("0.0#",$INV) + "% . pausa " + $A_PAUSA.ToString("0.0#",$INV) + "% . cap " + $A_CAP.ToString("0.0#",$INV) + "% . reset " + $A_RESETHOUR + ":00 server . azione " + $A_ACTION + " (enforce) . saldo 0 (cattura automatica)")
  [void]$r.Add("erano gia' installati ....: " + $GiaLi)
  [void]$r.Add("l'.ex5 e' tenuto aperto? .: " + $Ex5Aperto)
  [void]$r.Add("")
  [void]$r.Add("backup ...................: " + $BackupTxt)
  [void]$r.Add("compilazione " + $EA + ": " + $Comp)
  [void]$r.Add("   riga Result del log ...: " + $Result)
  [void]$r.Add("   codice di uscita ......: " + $Rc)
  [void]$r.Add("INSTALLAZIONE ............: " + $InstallTxt)
  [void]$r.Add("ripristino ...............: " + $Ripristino)
  [void]$r.Add("")
  [void]$r.Add("I TRE EA GIA' IN CAMPO E L'INCLUDE (che NON si toccano): " + $CoinquiTxt)
  foreach($f in $FotoVic){ [void]$r.Add("   VICINO [" + $f.Chi + "] " + $f.Percorso + "   prima [" + (FotoTxt $f.Prima) + "]   dopo [" + (FotoTxt $f.Dopo) + "]   -> " + (Confronta $f.Prima $f.Dopo)) }
  [void]$r.Add("I TERMINALI DEI CONTI DEMO: " + $DemoTxt)
  foreach($f in $FotoDemo){ [void]$r.Add("   DEMO " + $f.Percorso + "   prima [" + (FotoTxt $f.Prima) + "]   dopo [" + (FotoTxt $f.Dopo) + "]   -> " + (Confronta $f.Prima $f.Dopo)) }
  [void]$r.Add("GRAFICI E CONFIGURAZIONE .: " + $ParamTxt)
  [void]$r.Add("CARTELLA Presets .........: " + $PresetsTxt)
  [void]$r.Add("")
  foreach($x in $FotoDopo){ [void]$r.Add($x) }
  [void]$r.Add("")
  [void]$r.Add("COSA SUCCEDE DOPO -- LO FA CLAUDIO A MANO, NON QUESTA RIGA:")
  [void]$r.Add("  QUESTA RIGA NON HA ATTACCATO IL GUARDIANO A NESSUN GRAFICO E NON HA")
  [void]$r.Add("  TOCCATO L'AUTOTRADING. Finche' non lo fai tu, il guardiano non")
  [void]$r.Add("  sorveglia niente e non puo' chiudere niente.")
  [void]$r.Add("  0. QUESTO E' UN AGGIORNAMENTO (v" + $VER_KO + " -> v" + $VER + "), NON un'installazione")
  [void]$r.Add("     nuova: il guardiano stava GIA' su un grafico. Prima della CORSA")
  [void]$r.Add("     andava STACCATO (tasto destro sul suo grafico > Expert Advisors >")
  [void]$r.Add("     Rimuovi); adesso va RIATTACCATO. Se la CORSA si e' fermata su")
  [void]$r.Add("     'EX5 VECCHIO NON CANCELLABILE', vuol dire che era ancora")
  [void]$r.Add("     attaccato: staccalo e rilancia la stessa riga. Non e' un guasto.")
  [void]$r.Add("  1. Navigatore > Expert Advisors > tasto destro > Aggiorna: deve")
  [void]$r.Add("     comparire " + $EA + ".")
  [void]$r.Add("  2. IL GRAFICO. Va bene lo STESSO grafico su cui girava prima (quello")
  [void]$r.Add("     da cui l'hai staccato): ormai e' un grafico SENZA EA, ed e' l'unica")
  [void]$r.Add("     cosa che conta. Se preferisci uno nuovo, File > Nuovo grafico.")
  [void]$r.Add("     Il simbolo e il timeframe NON contano (il guardiano guarda il")
  [void]$r.Add("     CONTO, non il grafico), ma DEVE essere un grafico SENZA EA: un")
  [void]$r.Add("     grafico MT5 tiene UN SOLO Expert Advisor, e trascinarlo su quello")
  [void]$r.Add("     del DAX o dell'ORB SOSTITUIREBBE la sedia, spegnendola in silenzio.")
  [void]$r.Add("  3. Trascina " + $EA + ", scheda Dati in Ingresso > Carica... >")
  [void]$r.Add("     " + $SET)
  [void]$r.Add("     e PRIMA DI PREMERE OK guarda a schermo e fotografa:")
  [void]$r.Add("       InpAction = 0 (CHIUDI+BLOCCA)     InpCloseAllMagics = true")
  [void]$r.Add("       InpStartBalance = 0               InpMagic = " + $MAGIC)
  [void]$r.Add("       InpDailyLossPct = " + $A_DAILYLOSS.ToString("0.0#",$INV) + "   InpTotalDDPct = " + $A_TOTALDD.ToString("0.0#",$INV))
  [void]$r.Add("       InpDailyPausePct = " + $A_PAUSA.ToString("0.0#",$INV) + "   InpMaxOpenRiskPct = " + $A_CAP.ToString("0.0#",$INV))
  [void]$r.Add("       InpDailyResetHour = " + $A_RESETHOUR + "         InpAutotest = true")
  [void]$r.Add("  4. AutoTrading ACCESO e faccina SORRIDENTE anche su questo grafico.")
  [void]$r.Add("     SENZA AutoTrading il guardiano scrive lo stesso le sue")
  [void]$r.Add("     GlobalVariable (pausa, cap, battito), ma NON PUO' CHIUDERE:")
  [void]$r.Add("     il braccio armato della rete resta spento.")
  [void]$r.Add("  5. IL PANNELLO SUL GRAFICO -- e' QUI che si verifica tutto:")
  [void]$r.Add("       'Saldo iniziale:' e' LA PROVA CHE IL FIX HA PRESO.")
  [void]$r.Add("          deve dire ~7500.00, cioe' l'EQUITA' (bilancio + credito).")
  [void]$r.Add("          Se dice ~5000.00 hai davanti il solo BILANCIO: il fix NON")
  [void]$r.Add("          ha preso, STACCA L'EA e mandami lo screenshot.")
  [void]$r.Add("          Se dice 100000 e' il preset del demo FTMO: STACCA L'EA.")
  [void]$r.Add("          NON serve cancellare niente da F3: la v" + $VER + " usa nomi nuovi")
  [void]$r.Add("          (ABTG_GUARD_<login>_START_V2 e compagni) proprio per")
  [void]$r.Add("          ricatturare il saldo da sola, senza toccare niente a mano.")
  [void]$r.Add("       'Perdita oggi: ... / limite " + $A_DAILYLOSS.ToString("0.0#",$INV) + "%'")
  [void]$r.Add("       'Drawdown: ... / limite " + $A_TOTALDD.ToString("0.0#",$INV) + "%'  con '(statico)'")
  [void]$r.Add("       'Azione: CHIUDI+BLOCCA'")
  [void]$r.Add("       'Pausa morbida (" + $A_PAUSA.ToString("0.0#",$INV) + "%): libera'")
  [void]$r.Add("       'Rischio aperto: X% / cap " + $A_CAP.ToString("0.0#",$INV) + "% -> ok'")
  [void]$r.Add("     Screenshot del pannello: e' la prova fotografica del deploy.")
  [void]$r.Add("  6. Scheda ESPERTI (non Giornale):")
  [void]$r.Add("       '[AUTOTEST] ABTG_PausaGuardian v1.51 ...'")
  [void]$r.Add("       '[AUTOTEST] ABTG_PausaGuardian: TUTTI I CASI PASSATI.'")
  [void]$r.Add("       '[GUARDIAN] filo verificato: 5 GlobalVariable su 5 ...'")
  [void]$r.Add("       '" + $RIGA_AVVIO + "<saldo vero>  DailyLoss=" + $A_DAILYLOSS.ToString("0.0#",$INV) + "%  DD=" + $A_TOTALDD.ToString("0.0#",$INV) + "% (statico)  Azione=CHIUDI+BLOCCA'")
  [void]$r.Add("          <-- QUI il saldo dev'essere ~7500.00, NON ~5000.00")
  [void]$r.Add("       '[GUARDIAN] baseline presa dall'EQUITA' (v" + $VER + "): equity=...")
  [void]$r.Add("        bilancio=...  differenza=...'  <-- riga NUOVA della v" + $VER + ":")
  [void]$r.Add("          la 'differenza' e' il CREDITO del broker (atteso ~2500).")
  [void]$r.Add("          E' il numero che era invisibile e che ha nascosto il bug.")
  [void]$r.Add("       '[GUARDIAN] pausa morbida=" + $A_PAUSA.ToString("0.00",$INV) + "%  cap rischio aperto=" + $A_CAP.ToString("0.00",$INV) + "% ...'")
  [void]$r.Add("     Se compare 'FILO ROTTO' o 'CASI FALLITI': STACCA L'EA e mandami")
  [void]$r.Add("     lo screenshot. Sono le due righe che dicono che la rete non e'")
  [void]$r.Add("     collegata a niente.")
  [void]$r.Add("  7. I NUMERI DEI SOLDI, su ~7.500 EUR:")
  [void]$r.Add("       pausa 4,0%  = ~300 EUR persi oggi  -> nessun EA apre piu' niente")
  [void]$r.Add("       giorno 4,9% = ~367 EUR persi oggi  -> CHIUDE TUTTO e blocca per oggi")
  [void]$r.Add("       totale 9,9% = ~742 EUR (equity ~6.757) -> CHIUDE TUTTO e blocca")
  [void]$r.Add("                     PER SEMPRE (GlobalVariable ABTG_GUARD_<login>_FAILED)")
  [void]$r.Add("       Quel blocco NON si azzera da solo: si toglie SOLO cancellando")
  [void]$r.Add("       quella GlobalVariable a mano da F3. Va saputo PRIMA.")
  [void]$r.Add("")
  [void]$r.Add("PROBLEMI: " + $Problemi.Count)
  foreach($p in $Problemi){ [void]$r.Add("  - " + $p) }
  [void]$r.Add("RILIEVI: " + $Rilievi.Count)
  foreach($p in $Rilievi){ [void]$r.Add("  - " + $p) }
  if($Fatale -ne ""){ [void]$r.Add(""); [void]$r.Add("!!! FERMATO: " + $Fatale) }
  [void]$r.Add("")
  foreach($x in $righeC){ [void]$r.Add($x) }
  Set-Content -LiteralPath $ReferTxt -Value @($r) -Encoding ASCII

  $CandTxt = Join-Path $Work "CANDIDATE.txt"
  Set-Content -LiteralPath $CandTxt -Value @($righeC) -Encoding ASCII

  $daZip = New-Object System.Collections.ArrayList
  [void]$daZip.Add($ReferTxt)
  [void]$daZip.Add($CandTxt)
  if(Test-Path -LiteralPath $LogPath){
    [void]$daZip.Add($LogPath)
    $l1 = Join-Path $Work "COMPILAZIONE_GUARDIAN_leggibile.txt"
    Set-Content -LiteralPath $l1 -Value @($LogRighe) -Encoding ASCII
    [void]$daZip.Add($l1)
  }
  $zip = Join-Path $Dsk ("DEPLOY_GUARDIAN_" + $Modo + "_" + $Stamp + ".zip")
  Remove-Item -LiteralPath $zip -Force -ErrorAction SilentlyContinue
  Compress-Archive -LiteralPath @($daZip) -DestinationPath $zip -Force
  Write-Host ""
  Write-Host ("REFERTO: " + $ReferTxt) -ForegroundColor Cyan
  Write-Host ("ZIP DA MANDARE IN CHAT: " + $zip) -ForegroundColor Cyan
  Write-Host ("PROBLEMI: " + $Problemi.Count + "   RILIEVI: " + $Rilievi.Count)
  Write-Host "RICORDA: il guardiano NON e' su nessun grafico. Finche' non ce lo metti TU, non sorveglia e non chiude niente." -ForegroundColor Yellow
}
catch{
  Write-Host ("RACCOLTA IN DIFFICOLTA': " + $_.Exception.Message) -ForegroundColor Red
  Write-Host "Manda in chat quello che vedi qui sopra: va bene uguale." -ForegroundColor Yellow
}

if($Fatale -ne "" -or $Problemi.Count -gt 0){ exit 1 }
exit 0
