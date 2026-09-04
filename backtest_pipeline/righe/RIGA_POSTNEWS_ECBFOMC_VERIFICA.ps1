# =====================================================================
#  MARCATORE_RIGA_POSTNEWS_ECBFOMC_VERIFICA_v1
#  RIGA_POSTNEWS_ECBFOMC_VERIFICA.ps1 -- VERIFICA MECCANICA (non un
#  round, non un giudizio): dopo il fix v1.10 di ABTG_PostNews.mq5
#  (FILE_COMMON sulla lettura del calendario), le DUE sedie PostNews
#  gia' VIVE in forward sul VPS leggono davvero abtg_news.csv?
#      sedia 1: ECB  / EURJPY  magic 771201  Presets\ABTG_PostNews_ECB_EURJPY.set
#      sedia 2: FOMC / EURUSD  magic 771202  Presets\ABTG_PostNews_FOMC_EURUSD.set
#  Calendario: mql5\Files\abtg_news.csv (quello VERO del forward, NON il
#  calendario storico 2010-2025 della riga NFP).
# ---------------------------------------------------------------------
#  >>> COSA RISPONDE, E NIENT'ALTRO (dichiarato PRIMA dei numeri)
#      Una sola domanda, binaria, PER SEDIA:
#        CALENDARIO LETTO  oppure  CALENDARIO CIECO/PROBLEMA.
#      NON e' un passo 0 di backtest: NESSUN numero economico esce da
#      qui (Optimization=0 -> OnTesterDeinit NON gira -> nessun CSV
#      OPTFRAME, per costruzione). Niente profitto, niente PF, niente
#      DD, niente Emendamento A/B/C. Chi legge questo referto NON puo'
#      dire niente sul merito delle due sedie, e il referto lo ripete.
#
#  >>> PERCHE' NON USA walkforward_generico.ps1 (scelta dichiarata e
#      motivata, come chiede la clausola severa):
#       1. il generico MUORE senza almeno un asse ||Y ("nessun parametro
#          da spazzolare: sarebbe un backtest singolo"). Per usarlo qui
#          bisognerebbe INVENTARE uno sweep: o un secondo magic (e i
#          magic nuovi vanno censiti vergini: lavoro vero per una
#          verifica che non ne ha bisogno), o uno sweep su un parametro
#          che cambia il comportamento della cella. Tutte e due
#          allargano la domanda invece di rispondere a quella che c'e'.
#       2. il generico non carica i .set: vuole un prove\*.txt, cioe' una
#          TRASCRIZIONE A MANO del preset. Ma qui l'oggetto della verifica
#          E' il preset della sedia viva: va letto COM'E', non ricopiato
#          (una trascrizione puo' divergere, ed e' proprio la divergenza
#          che non voglio introdurre).
#       3. il generico spezza sempre in IS/OOS: 2 corse per simbolo = 4
#          avvii del tester per una domanda che ne chiede 2.
#      Quindi: .ini scritti QUI, a PASSATA SINGOLA (Optimization=0),
#      struttura copiata campo per campo da walkforward_generico /
#      RIGA_R114 ([Charts] MaxBars, [Experts] AllowLiveTrading=false,
#      ShutdownTerminal=1), con gate sullo STATO FINALE dell'.ini
#      riletto dal disco. Nessun file prove\*.txt viene creato: NON
#      SERVE, ed e' dichiarato qui perche' chi cerca il companion non
#      lo cerchi invano.
#
#  >>> DA DOVE VENGONO I [TesterInputs] (il punto delicato)
#      1. TUTTI gli input dell'EA vengono letti dal SORGENTE al pin e
#         blindati al loro DEFAULT COMPILATO (stessa tecnica del
#         generico: un input non nominato nell'.ini si prende quello che
#         il tester ricorda dall'ultima corsa di quell'EA -- sul PC di
#         backtest, l'ultima corsa e' quella NFP, con un ALTRO
#         calendario. Scrivere tutto toglie lo stato nascosto).
#      2. poi il .set della sedia SOVRASCRIVE, riga per riga.
#      Risultato = esattamente la condizione della sedia in forward:
#      i valori del preset + i default compilati per cio' che il preset
#      non nomina (che e' quello che fa anche un grafico quando carichi
#      un .set che non nomina un parametro).
#      >>> InpNewsCommon NON e' nei due .set (sono precedenti alla
#          v1.10): nell'.ini ci finisce il DEFAULT COMPILATO letto dal
#          sorgente al pin, e c'e' un GATE che pretende che quel default
#          sia 'true'. Se un giorno non lo fosse piu', la riga si ferma
#          invece di verificare una condizione diversa da quella del
#          forward. I .set NON vengono modificati da questa riga: la
#          verifica deve misurare i file COSI' COME SONO oggi sul VPS.
#
#  >>> IL CANARINO, E COSA PROVA DAVVERO (leggere prima di esultare)
#      La riga di log e':
#        [PostNews][NEWS] letto da <Common\Files|MQL5\Files (sandbox)>
#        | righe N | UTILI per questo preset M (...) | dal .. al ..
#      e la stampa LoadNews(), UNA VOLTA IN OnInit E POI UNA VOLTA AL
#      GIORNO (OnTick ricarica il file quando cambia il giorno): su una
#      finestra di due settimane le righe attese sono UNA DECINA, non
#      una. Tutte devono dire la STESSA cosa: valori diversi = qualcosa
#      cambia sotto i piedi, ed e' un PROBLEMA.
#      Tre cose si misurano, e tutte e tre sono gate:
#        (a) 'letto da' DEVE essere Common\Files. E' QUESTA la prova del
#            fix: 'M>=1' da solo NON proverebbe niente sul FILE_COMMON,
#            perche' il file e' installato in ENTRAMBI i posti (Common
#            E sandbox). NON MISURATO se la sandbox DEL TESTER (diversa
#            dalla cartella dati: ogni agente di ottimizzazione ha la
#            SUA, sotto <Tester>\Agent-...\MQL5\Files, che questa riga
#            NON popola) risponda comunque in una passata singola: se
#            capitasse, l'esito atteso e' comunque leggibile, CALENDARIO
#            CIECO (nessuna sandbox popolata), non 'sandbox' silenzioso.
#            Se il canarino dice 'sandbox', il ramo Common ha fallito:
#            PROBLEMA in ogni caso.
#        (b) 'righe N' DEVE combaciare con le righe evento contate QUI
#            dal file al pin (header escluso: StringToTime('Data Ora')
#            torna 0 e l'EA la salta). Se non combacia, l'EA ha letto
#            UN ALTRO abtg_news.csv.
#        (c) 'UTILI per questo preset M' DEVE combaciare con il conto
#            RIFATTO QUI sul file al pin applicando le stesse tre regole
#            del sorgente (impatto>=InpNewsMinImpact, la valuta del
#            preset CONTIENE quella dell'evento, il titolo CONTIENE
#            InpNewsTitleMatch -- confronto CASE SENSITIVE come StringFind).
#      >>> E ATTENZIONE, e' la trappola di lettura di questa riga:
#          'UTILI' conta gli eventi di TUTTO IL FILE, non quelli della
#          finestra testata. Percio' M>=1 NON dimostra che nella finestra
#          ci fosse un evento. Quella e' una verifica SEPARATA e si fa
#          PRIMA di aprire MT5 (fase 4): se la finestra scelta non
#          contiene almeno un evento della sedia, la riga si FERMA.
#
#  >>> IL SECONDO CANARINO, GRATIS: l'autotest dell'EA (InpAutoTest,
#      default compilato true) ha un caso n.5 che e' proprio il
#      calendario (okNews = gNewsUtili>0 || !InpRestrictToNews). Quindi
#      la riga '[PostNews][AUTOTEST] ---- fine: N casi falliti ----'
#      DEVE dire 0: se dice altro, o l'aritmetica dell'EA e' rotta o il
#      calendario e' cieco. Atteso 0, gate.
#
#  >>> COSA E' SOLO UN RILIEVO, MAI UN GATE (dichiarato per non barare):
#      - gli ordini davvero piazzati ('[PostNews] BUY STOP @ ...'):
#        provano che NewsToday() ha agganciato la data DENTRO la
#        finestra. Bello vederli, ma la loro ASSENZA ha cause legittime
#        (prezzo gia' fuori range, stops level, lotto nullo): non e' il
#        fix che si sta verificando.
#      - il preset FOMC in gennaio e' in configurazione ESTIVA (azione
#        19:40 server = 40 minuti dopo la notizia delle 20:00 IT invece
#        di 10; d'inverno vorrebbe 18:40). NON tocca il canarino (il
#        canarino e' il FILE), tocca quali candele legge. Qui NON si
#        legge nessun merito: dichiarato e ininfluente per la domanda.
#      - i due preset rischiano il 3%/evento (il numero del corso), non
#        lo 0,65%/ordine del metro di casa. NON e' oggetto di questa
#        verifica e questa riga NON tocca i .set: va solo agli atti.
#
#  >>> COSA QUESTA RIGA NON PUO' VEDERE, MAI (limite dichiarato):
#      verifica i file AL PIN, sul PC DI BACKTEST. Che il VPS abbia
#      DAVVERO quell'.ex5 e quei .set lo controlla Claudio quando
#      ridistribuisce: il forward non si tocca da qui, per regola.
#
#  COSA FA, IN ORDINE (ogni passo timbra il SUO campo del referto PRIMA
#  di potersi fermare -- stati sempre a TRE: NON TENTATO / FALLITO / OK):
#   0. guardie: -Pin 40-hex obbligatorio, MT5 e MetaEditor CHIUSI,
#      sentinella di un giro precedente interrotto (classe 116);
#   1. scarico AL PIN: EA, include Guardian (censito dal sorgente),
#      calendario abtg_news.csv, i DUE preset .set;
#   2. gate sul sorgente: #property version "1.10" ancorato, casi
#      autotest RICALCOLATI dal file al pin (3 AT_Caso + 2 falliti++
#      = 5), include censiti, hedge-safe, OnTester presente, e la
#      tabella degli input col loro default (serve alla fase 6);
#   3. gate sui due .set: chiavi tutte esistenti nell'EA, nessuna
#      doppia, magic/valuta/titolo/file attesi, InpNewsFile =
#      abtg_news.csv, magic diversi fra loro;
#   4. gate sul calendario al pin: header, righe evento contate, eventi
#      UTILI per sedia RICONTATI, e -- prima di aprire MT5 -- almeno UN
#      evento per sedia DENTRO la finestra [-DaQuando, -Fino);
#   5. terminale BCM di backtest (non -V3) + cartella dati da origin.txt
#      (-Terminale come manopola se le candidate non sono 1);
#   6. FOTO PRIMA, sentinella, include installato con backup, EA
#      compilato con metaeditor64 diretto, log letto qualunque sia la
#      codifica; calendario installato in Common\Files E nella sandbox,
#      CON BACKUP (si chiama come il file del forward: qui si rimette
#      com'era, a differenza della riga NFP che installa un calendario
#      storico dedicato);
#   7. .ini per sedia (passata SINGOLA), riletti dal disco e verificati
#      riga per riga; con -SoloControllo la riga finisce qui (MT5 NON
#      viene mai aperto: nessuna eccezione, a differenza della riga NFP
#      che doveva misurare lo storico);
#   8. Tester\cache svuotata (SOLO quella), poi UNA corsa per sedia con
#      fotografia dei log PRIMA e DOPO (conteggi per pattern: le righe
#      nuove sono quelle oltre il conteggio precedente -- i log del
#      tester si APPENDONO, contare il file intero attribuirebbe alla
#      sedia 2 le righe della sedia 1);
#   9. verdetto per sedia, binario, in cima al referto.
#  RIPRISTINO -- SEMPRE: include e calendario rimessi com'erano (o
#      rimossi se non c'erano), sentinella tolta, FOTO DOPO. L'EA
#      .mq5/.ex5 RESTA in MQL5\Experts (dichiarato con la foto).
#  RACCOLTA -- SEMPRE: cartella + zip sul Desktop VERO (GetFolderPath,
#      poi %USERPROFILE%\Desktop, poi OneDrive\Desktop), referto + i
#      due .ini VERI + i due preset + il calendario + i log del tester
#      cresciuti + l'evidenza per sedia. Exit 0/1, la riga di chat legge
#      il codice a TRE stati.
# ---------------------------------------------------------------------
#  LE SCELTE CHE I MATERIALI NON FISSAVANO (dichiarate, non nascoste):
#   - finestra 2026.01.20 -> 2026.02.06: la piu' corta che contiene UN
#     evento per sedia (28/01 FOMC e 29/01 ECB stanno nello stesso mese)
#     con qualche giorno di margine prima e dopo. Si sposta con
#     -DaQuando/-Fino: il gate di fase 4 ricontrolla che la finestra
#     nuova contenga ancora almeno un evento per sedia.
#   - Modello 1 (1 minuto OHLC): il modello NON entra nella domanda (il
#     canarino sta in OnInit e nel ricarico giornaliero). Si e' scelto
#     il piu' leggero fra quelli che questa casa usa, per non chiedere
#     tick reali su due cross per una verifica di lettura file.
#   - Deposito 100000, leva 100, Currency EUR, Spread 0 (= spread
#     corrente, scritto ESPLICITO invece che lasciato allo stato
#     nascosto): impalcatura, nessun numero economico esce da qui.
#   - -TimeoutMin 30 per corsa: nessuna corsa di casa ha cronometrato
#     QUESTA (due settimane OHLC M1 su un cross: minuti). Stima onesta,
#     e serve a non lasciare la riga appesa se il terminale si pianta
#     su una finestra modale.
#
#  QUANTO CI METTE [STIMA, non una previsione]: compilazione dell'EA +
#  2 passate singole OHLC M1 su ~2,5 settimane + 2 avvii del terminale.
#  Totale onesto: 3-15 minuti, quasi tutti negli avvii del terminale e
#  nell'eventuale scarico dello storico M1 dei due cross (se il PC di
#  backtest non ha gennaio 2026 sul disco, il tempo lo fa quello --
#  e QUESTA riga non misura lo storico: se la corsa non produce
#  canarini, il referto lo dice con due nomi possibili, non con uno).
#
#  LA RIGA CHE SI INCOLLA sta in righe\RIGA_POSTNEWS_ECBFOMC_VERIFICA_DA_MANDARE.md
# =====================================================================
[CmdletBinding()]
param(
  # -Pin NON ha default: un default silenzioso ("lavoro") farebbe girare
  #  la punta del branch spacciandola per un commit congelato.
  [string]$Pin        = "",
  [switch]$SoloControllo,              # NON apre MT5: scarica, gatta, compila, scrive e verifica gli .ini
  [string]$Terminale  = "",            # manopola: cartella dell'installazione MT5 di backtest
  [string]$DaQuando   = "2026.01.20",  # finestra corta e recente (vedi gate di fase 4)
  [string]$Fino       = "2026.02.06",
  [int]$Modello       = 1,             # 1 = OHLC M1 (il modello non entra nella domanda)
  [int]$Deposito      = 100000,
  [int]$Leva          = 100,
  [int]$Spread        = 0,             # 0 = spread CORRENTE, dichiarato nell'.ini
  [int]$TimeoutMin    = 30             # tetto per OGNI corsa del tester
)
$ErrorActionPreference = "Stop"
[Threading.Thread]::CurrentThread.CurrentCulture   = [Globalization.CultureInfo]::InvariantCulture
[Threading.Thread]::CurrentThread.CurrentUICulture = [Globalization.CultureInfo]::InvariantCulture
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$INV = [Globalization.CultureInfo]::InvariantCulture

$EA              = "ABTG_PostNews"
$INC             = "ABTG_PausaGuardian.mqh"
$PERIODO         = "M5"
$NEWSFILE        = "abtg_news.csv"
$VERSIONE_ATTESA = "1.10"
# --- casi dell'autotest: NON un #define nel sorgente. Si RICALCOLANO dal
#     file appena scaricato al pin; questi sono gli attesi di OGGI (v1.10).
$AT_CASO_ATTESI   = 3
$FALLITIPP_ATTESI = 2

$Avvio = Get-Date
$Stamp = $Avvio.ToString("yyyyMMdd_HHmm", $INV)
$Modo  = "CORSA"
if($SoloControllo){ $Modo = "CONTROLLO" }

function TrovaDesktop(){
  foreach($p in @([Environment]::GetFolderPath("Desktop"),
                  (Join-Path $env:USERPROFILE "Desktop"),
                  (Join-Path $env:USERPROFILE "OneDrive\Desktop"))){
    if($p -and (Test-Path -LiteralPath $p)){ return $p }
  }
  return $env:USERPROFILE
}
$Dsk        = TrovaDesktop
$Work       = Join-Path $env:USERPROFILE "abtg_postnews_ecbfomc"
$Sentinella = Join-Path $Work "POSTNEWS_VER_IN_CORSO.txt"
$RawPin     = "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$Pin"
$ZipNome    = "POSTNEWS_ECBFOMC_VERIFICA_" + $Modo + "_" + $Stamp

# =====================================================================
#  TUTTO CIO' CHE LA RACCOLTA USA NASCE QUI, PRIMA DEL try.
#  NB: la lista del referto si chiama $REF e NON $R: in PowerShell i nomi
#  non distinguono maiuscole/minuscole e un $r di comodo dentro un
#  foreach distruggerebbe il referto (difetto gia' pagato in casa).
# =====================================================================
$Problemi   = New-Object System.Collections.ArrayList
$Rilievi    = New-Object System.Collections.ArrayList
$Fatale     = ""
$TermTxt    = "NON SCELTO"
$DataFolder = ""
$InstDir    = ""
$Terminal64 = ""
$MetaEditor = ""
$Compilato  = "NON TENTATA"
$ResultTxt  = "NON LETTA"
$VersTxt    = "NON LETTA"
$AutotestTxt= "NON LETTO"
$IncTxt     = "NON CENSITO"
$IncGuardia = "NON VERIFICATA"
$HedgeTxt   = "NON ESEGUITO"
$OnTesterTxt= "NON VERIFICATO"
$InputTxt   = "NON LETTI"
$NewsCommonTxt = "NON VERIFICATO"
$CalCsvTxt  = "NON VERIFICATO"
$FinestraTxt= "NON VERIFICATA"
$CacheTxt   = "NON SVUOTATA"
$Ripristino = "NON NECESSARIO (il terminale non e' mai stato scritto)"
$FotoPrese  = $false
$IncInstallato = $false
$CalInstallato = $false
$TExpMq5 = ""; $TExpEx5 = ""; $TIncMqh = ""
$CalCommon = ""; $CalLocale = ""
$F1Prima = $null; $F2Prima = $null; $F3Prima = $null
$FCalCommonPrima = $null; $FCalLocalePrima = $null
$RigheFotoDopo = New-Object System.Collections.ArrayList
$Backup = @{}                 # percorso di destinazione -> percorso del backup ("" = non c'era)
$logC   = Join-Path $Work "COMPILAZIONE.log"
$InputsSorgente = [ordered]@{}
$Eventi = @()                 # eventi del calendario al pin
$NRigheEventoPin = -1

# --- LE DUE SEDIE. Nascono qui: la raccolta le scorre SEMPRE.
$SEDIE = @(
  [pscustomobject]@{ Id="ECB_EURJPY";  Preset="ABTG_PostNews_ECB_EURJPY.set";  Sym="EURJPY"; Magic=771201; Ccy="EUR"; Titolo="ECB";  UtiliOggi=4 },
  [pscustomobject]@{ Id="FOMC_EURUSD"; Preset="ABTG_PostNews_FOMC_EURUSD.set"; Sym="EURUSD"; Magic=771202; Ccy="USD"; Titolo="FOMC"; UtiliOggi=7 }
)
$Stato = @{}
foreach($s in $SEDIE){
  $Stato[$s.Id] = [pscustomobject]@{
    Preset      = "NON VERIFICATO"
    UtiliAttesi = -1
    InFinestra  = -1
    DateFinestra= ""
    Ini         = "NON SCRITTO"
    IniPath     = ""
    Corsa       = "NON TENTATA"
    RigheNews   = @()
    Dove        = @()
    RigheFile   = @()
    Utili       = @()
    Cieco       = -1
    Rosso       = -1
    Autotest    = @()
    AutoFalliti = @()
    Ordini      = -1
    NienteNews  = -1
    LogVisti    = -1
    LogNuovi    = -1
    Verdetto    = "NON VERIFICATO (la riga non e' arrivata a misurarlo)"
  }
}

# non misurato -> 'n/d', mai -1 (regola di casa sulle sentinelle).
function FmtN($v){ if($null -eq $v -or [int]$v -lt 0){ return "n/d" }; return ([int]$v).ToString($INV) }
function Ora(){ return (Get-Date).ToString("HH:mm:ss", $INV) }
function Dico([string]$t,[string]$c="Gray"){ Write-Host ("[" + (Ora) + "] " + $t) -ForegroundColor $c }
function Titolo([string]$t){ Write-Host ""; Write-Host ("=== " + $t + " ===") -ForegroundColor Cyan }

function Scarica([string]$url,[string]$dest){
  Remove-Item -LiteralPath $dest -Force -ErrorAction SilentlyContinue
  try{ Invoke-WebRequest -Uri $url -OutFile $dest -UseBasicParsing -ErrorAction Stop }
  catch{
    throw ("SCARICO FALLITO da " + $url + " -- " + $_.Exception.Message +
           " | se e' un 404 su un pin appena creato: la cache di raw.githubusercontent dura qualche minuto, si aspetta e si rilancia LA STESSA riga (il pin non si cambia).")
  }
  if(-not (Test-Path -LiteralPath $dest)){ throw ("SCARICO FALLITO (nessun file scritto): " + $url) }
  if((Get-Item -LiteralPath $dest).Length -le 0){ throw ("SCARICO FALLITO (file vuoto): " + $url) }
}

# Legge un file di testo qualunque sia la codifica (i log di MetaEditor
# e del tester escono in UTF-16LE col BOM).
function LeggiTesto([string]$path){
  if(-not (Test-Path -LiteralPath $path)){ return @() }
  $b = $null
  try{
    $fs = New-Object System.IO.FileStream($path,[System.IO.FileMode]::Open,[System.IO.FileAccess]::Read,[System.IO.FileShare]::ReadWrite)
    $ms = New-Object System.IO.MemoryStream
    $fs.CopyTo($ms); $fs.Close()
    $b = $ms.ToArray(); $ms.Close()
  }catch{ return @() }
  if($null -eq $b -or $b.Length -eq 0){ return @() }
  $txt = ""
  if($b.Length -ge 2 -and $b[0] -eq 255 -and $b[1] -eq 254){ $txt = [System.Text.Encoding]::Unicode.GetString($b,2,$b.Length-2) }
  elseif($b.Length -ge 2 -and $b[0] -eq 254 -and $b[1] -eq 255){ $txt = [System.Text.Encoding]::BigEndianUnicode.GetString($b,2,$b.Length-2) }
  elseif($b.Length -ge 3 -and $b[0] -eq 239 -and $b[1] -eq 187 -and $b[2] -eq 191){ $txt = [System.Text.Encoding]::UTF8.GetString($b,3,$b.Length-3) }
  else{
    $zeri = 0; $fin = [math]::Min($b.Length,400)
    for($i=1; $i -lt $fin; $i=$i+2){ if($b[$i] -eq 0){ $zeri++ } }
    if($zeri -gt ($fin/4)){ $txt = [System.Text.Encoding]::Unicode.GetString($b) } else { $txt = [System.Text.Encoding]::UTF8.GetString($b) }
  }
  return @($txt -split "`r`n|`n|`r")
}

function Foto([string]$path){
  if($path -eq "" -or $null -eq $path -or -not (Test-Path -LiteralPath $path)){ return [pscustomobject]@{ Esiste=$false; Len=-1; Ora="ASSENTE" } }
  $i = Get-Item -LiteralPath $path
  return [pscustomobject]@{ Esiste=$true; Len=$i.Length; Ora=$i.LastWriteTime.ToString("yyyy-MM-dd HH:mm:ss",$INV) }
}
function FotoTxt($f){ if(-not $f.Esiste){ return "ASSENTE" }; return ("presente, " + $f.Len + " byte, " + $f.Ora) }

# ---------------------------------------------------------------------
#  INSTALLA UN FILE NEL TERMINALE TENENDO IL BACKUP. Il ripristino di
#  fine giro rimette com'era: qui si tocca abtg_news.csv, che sul PC di
#  backtest e' lo STESSO nome del file del forward.
# ---------------------------------------------------------------------
function InstallaConBackup([string]$sorgente,[string]$destinazione){
  $back = ""
  if(Test-Path -LiteralPath $destinazione){
    $back = $destinazione + ".prima_verifica_" + $Stamp
    Copy-Item -LiteralPath $destinazione -Destination $back -Force
  }
  $script:Backup[$destinazione] = $back
  Set-Content -LiteralPath $Sentinella -Value (@($script:Backup.Keys | ForEach-Object { $_ + "|" + $script:Backup[$_] })) -Encoding ASCII
  Copy-Item -LiteralPath $sorgente -Destination $destinazione -Force
  if($back -eq ""){ return "installato (NON c'era prima: a fine giro verra' RIMOSSO)" }
  return ("installato (backup " + (Split-Path -Leaf $back) + ": a fine giro verra' RIMESSO com'era)")
}

# ---------------------------------------------------------------------
#  IL .set: Nome=Valore, commenti ';'. Una riga in forma sweep
#  (v||start||step||stop||Y) viene ridotta al primo campo, con rilievo.
# ---------------------------------------------------------------------
function LeggiSet([string]$percorso,[string]$nome){
  $mappa = [ordered]@{}
  foreach($riga in (Get-Content -LiteralPath $percorso)){
    $t = ("" + $riga).Trim()
    if($t -eq "" -or $t.StartsWith(";")){ continue }
    $i = $t.IndexOf("=")
    if($i -lt 0){ continue }
    $n = $t.Substring(0,$i).Trim()
    $v = $t.Substring($i+1).Trim()
    if($v -match '\|\|'){
      [void]$Rilievi.Add("preset " + $nome + ": la riga '" + $n + "' e' in forma sweep ('" + $v + "'): uso il primo campo, come fa MT5 quando carica un .set.")
      $v = (@($v -split '\|\|')[0]).Trim()
    }
    if($mappa.Contains($n)){ throw ("preset " + $nome + ": DUE righe per '" + $n + "'. In [TesterInputs] un parametro doppio fa fare a MT5 ZERO passate.") }
    $mappa[$n] = $v
  }
  if(@($mappa.Keys).Count -eq 0){ throw ("preset " + $nome + ": nessuna riga Nome=Valore. Non e' un preset.") }
  return $mappa
}

# ---------------------------------------------------------------------
#  GLI INPUT DELL'EA COL LORO DEFAULT COMPILATO. Se un default non e'
#  risolvibile ci si FERMA: un input lasciato fuori dall'.ini prende il
#  valore che il tester ricorda dall'ultima corsa di questo EA (sul PC
#  di backtest e' la corsa NFP, con un ALTRO calendario). Niente stato
#  nascosto: o li scrivo tutti, o non scrivo niente.
# ---------------------------------------------------------------------
function LeggiInputsSorgente($righeSorgente){
  $mappa = [ordered]@{}
  $apice = [char]34
  foreach($riga in @($righeSorgente)){
    $m = [regex]::Match($riga,'^\s*s?input\s+([A-Za-z_]\w*)\s+([A-Za-z_]\w*)\s*=\s*(.+)$')
    if(-not $m.Success){ continue }
    $tipo = $m.Groups[1].Value
    $nome = $m.Groups[2].Value
    $val  = $m.Groups[3].Value
    $val  = [regex]::Replace($val,'//.*$','')
    $val  = $val.Trim().TrimEnd(';').Trim()
    $kind = ""
    if($val.StartsWith($apice)){ $kind = "stringa"; $val = $val.Trim($apice) }
    elseif($val -ieq "true"){  $kind = "num"; $val = "true" }
    elseif($val -ieq "false"){ $kind = "num"; $val = "false" }
    elseif($val -match '^-?\d+(\.\d+)?$'){ $kind = "num" }
    else{ throw ("input '" + $nome + "' ha un default che non so risolvere ('" + $val + "'): questa riga scrive TUTTI gli input nell'.ini apposta, e non ne indovina nessuno.") }
    if($mappa.Contains($nome)){ throw ("il sorgente dichiara DUE volte l'input '" + $nome + "'.") }
    $mappa[$nome] = [pscustomobject]@{ Tipo=$tipo; Val=$val; Kind=$kind }
  }
  if(@($mappa.Keys).Count -eq 0){ throw "nessun 'input' trovato nel sorgente: il formato non e' quello atteso." }
  return $mappa
}

# ---------------------------------------------------------------------
#  IL CALENDARIO AL PIN, letto con le STESSE regole del sorgente:
#  la riga di intestazione salta da sola (StringToTime torna 0).
# ---------------------------------------------------------------------
function LeggiCalendario([string]$percorso){
  $fuori = New-Object System.Collections.ArrayList
  $formati = @("yyyy.MM.dd HH:mm:ss","yyyy.MM.dd HH:mm","yyyy.MM.dd")
  foreach($riga in (Get-Content -LiteralPath $percorso)){
    $t = ("" + $riga).Trim()
    if($t -eq ""){ continue }
    $campi = $t -split ';'
    if(@($campi).Count -lt 4){ continue }
    $quando = [datetime]::MinValue
    $ok = $false
    foreach($f in $formati){
      if([datetime]::TryParseExact($campi[0].Trim(),$f,$INV,[Globalization.DateTimeStyles]::None,[ref]$quando)){ $ok = $true; break }
    }
    if(-not $ok){ continue }     # e' l'intestazione, o una riga senza data: l'EA la salta uguale
    $imp = 0
    $u = $campi[1].Trim().ToUpper()
    if($u.Contains("HIGH") -or $u -eq "3"){ $imp = 3 }
    elseif($u.Contains("MED") -or $u -eq "2"){ $imp = 2 }
    elseif($u.Contains("LOW") -or $u -eq "1"){ $imp = 1 }
    [void]$fuori.Add([pscustomobject]@{ T=$quando; Imp=$imp; Ccy=$campi[2].Trim(); Titolo=$campi[3].Trim() })
  }
  return @($fuori)
}

# I filtri del preset, COPIATI dal sorgente riga per riga:
#   impatto >= InpNewsMinImpact
#   StringFind(InpNewsCurrencies, ccyEvento) >= 0   (la valuta del preset CONTIENE quella dell'evento)
#   StringFind(titoloEvento, InpNewsTitleMatch) >= 0 (CASE SENSITIVE, come StringFind)
function PassaFiltri($ev,[string]$valute,[string]$titolo,[int]$minImp){
  if([int]$ev.Imp -lt $minImp){ return $false }
  if($valute.Length -gt 0 -and (-not $valute.Contains([string]$ev.Ccy))){ return $false }
  if($titolo.Length -gt 0 -and (-not ([string]$ev.Titolo).Contains($titolo))){ return $false }
  return $true
}

# ---------------------------------------------------------------------
#  UNA COMPILAZIONE con metaeditor64 diretto. MUTO = niente log e
#  niente .ex5 dopo 20s.
# ---------------------------------------------------------------------
function Compila([string]$exe,[string]$mq5,[string]$ex5,[string]$log,[int]$tetto){
  Remove-Item -LiteralPath $ex5 -Force -ErrorAction SilentlyContinue
  Remove-Item -LiteralPath $log -Force -ErrorAction SilentlyContinue
  $t0 = Get-Date
  Dico ("metaeditor64: /compile:" + $mq5 + " /log:" + $log) "Yellow"
  & $exe ("/compile:" + $mq5) ("/log:" + $log) | Out-Null
  $muto = $false; $battito = 0
  while($true){
    if((Test-Path -LiteralPath $ex5) -and ((Get-Item -LiteralPath $ex5).LastWriteTime -ge $t0)){ break }
    $righe = LeggiTesto $log
    if(@($righe).Count -gt 0 -and (@($righe) -match 'Result:').Count -gt 0){ break }
    $sec = (New-TimeSpan -Start $t0 -End (Get-Date)).TotalSeconds
    if(@($righe).Count -eq 0 -and $sec -ge 20){ $muto = $true; break }
    if($sec -ge $tetto){ break }
    if($sec -ge ($battito + 10)){ $battito = [int]$sec; Dico ("   ... aspetto l'.ex5 da " + $battito + "s (tetto " + $tetto + "s): NON interrompere") }
    Start-Sleep -Seconds 2
  }
  $fresco = ((Test-Path -LiteralPath $ex5) -and ((Get-Item -LiteralPath $ex5).LastWriteTime -ge $t0))
  return @{ Ex5=$fresco; Log=(LeggiTesto $log); Muto=$muto }
}

# ---------------------------------------------------------------------
#  I LOG DEL TESTER: TRE radici, e SOLO quelle del TESTER (gli agent non
#  stanno sotto la cartella dati). Si fotografano LUNGHEZZA e CONTEGGIO
#  PER PATTERN, e dopo la corsa si prendono SOLO le occorrenze oltre il
#  conteggio precedente: i log si APPENDONO, e leggere il file intero
#  attribuirebbe alla sedia 2 le righe della sedia 1.
#
#  >>> PERCHE' NON SI GUARDANO <CartellaDati>\Logs e MQL5\Logs (che
#      altre righe di casa guardano): lanciare il tester con /config
#      AVVIA IL TERMINALE, che carica l'ultimo profilo coi suoi grafici
#      e gli EA attaccati sopra. Se su quel PC c'e' un ABTG_PostNews su
#      grafico, in MQL5\Logs stampa IL SUO canarino, con il SUO preset:
#      finirebbe mescolato a quello della sedia in prova e il verdetto
#      direbbe "il campo cambia fra le righe" su una corsa sana. Il
#      canarino si legge SOLO dove scrive il TESTER.
# ---------------------------------------------------------------------
$PATTERN = [ordered]@{
  NEWS    = '\[PostNews\]\[NEWS\] letto da'
  CIECO   = 'CALENDARIO CIECO'
  ROSSO   = 'CANARINO ROSSO'
  AUTOFIN = '\[PostNews\]\[AUTOTEST\] ---- fine:'
  ORDINE  = '\[PostNews\] (BUY|SELL) STOP @'
  NIENTE  = 'nessuna notizia nel CSV oggi'
  GUAI    = '(no history|not enough|cannot open|no memory|not exist|failed|error)'
}
function RadiciLog(){
  $rad = New-Object System.Collections.ArrayList
  if($env:APPDATA){ [void]$rad.Add((Join-Path $env:APPDATA "MetaQuotes\Tester")) }
  if($DataFolder){ [void]$rad.Add((Join-Path $DataFolder "Tester")) }
  if($InstDir){    [void]$rad.Add((Join-Path $InstDir "Tester")) }
  return @($rad)
}
function ElencoLog(){
  $fuori = New-Object System.Collections.ArrayList
  foreach($rad in (RadiciLog)){
    if(-not (Test-Path -LiteralPath $rad)){ continue }
    foreach($f in @(Get-ChildItem -LiteralPath $rad -Recurse -File -Filter "*.log" -ErrorAction SilentlyContinue)){ [void]$fuori.Add($f) }
  }
  return @($fuori)
}
# CACHE (percorso+lunghezza): un log gia' letto e NON cresciuto non si
# rilegge. Senza, ogni fotografia rileggerebbe tutte le radici del tester
# (su un PC di backtest sono decine di file di agent) per ogni pattern.
$script:CacheLog = @{}
function RigheLog([string]$percorso,[long]$lunghezza){
  $c = $script:CacheLog[$percorso]
  if($null -ne $c -and [long]$c.Len -eq $lunghezza){ return $c.Righe }
  $righe = LeggiTesto $percorso
  $script:CacheLog[$percorso] = @{ Len=$lunghezza; Righe=$righe }
  return $righe
}
function FotoLog(){
  $foto = @{}
  foreach($f in (ElencoLog)){
    $righe = RigheLog $f.FullName $f.Length
    $conte = @{}
    foreach($k in @($PATTERN.Keys)){ $conte[$k] = @($righe | Where-Object { $_ -match $PATTERN[$k] }).Count }
    $foto[$f.FullName] = @{ Len=[long]$f.Length; Conte=$conte }
  }
  return $foto
}
# LE RIGHE NUOVE DI QUESTA CORSA, tutte in un giro solo: per ogni pattern
# si prendono le occorrenze OLTRE il conteggio della fotografia (i log del
# tester si APPENDONO: leggere il file intero attribuirebbe alla sedia 2
# le righe della sedia 1). Torna anche quanti file sono CRESCIUTI, e li
# copia agli atti.
function RaccogliNuove($fotoPrima,[string]$tag){
  $fuori = @{}
  foreach($k in @($PATTERN.Keys)){ $fuori[$k] = (New-Object System.Collections.ArrayList) }
  $cresciuti = 0
  foreach($f in (ElencoLog)){
    $lenPrima = -1
    $contePrima = @{}
    if($null -ne $fotoPrima -and $fotoPrima.ContainsKey($f.FullName)){
      $lenPrima   = [long]$fotoPrima[$f.FullName].Len
      $contePrima = $fotoPrima[$f.FullName].Conte
    }
    if($f.Length -gt $lenPrima){
      $cresciuti++
      try{ Copy-Item -LiteralPath $f.FullName -Destination (Join-Path $Work ("log_" + $tag + "_" + $f.Name)) -Force -ErrorAction SilentlyContinue }catch{}
    }
    $righe = RigheLog $f.FullName $f.Length
    foreach($k in @($PATTERN.Keys)){
      $prima = 0
      if($null -ne $contePrima -and $contePrima.ContainsKey($k)){ $prima = [int]$contePrima[$k] }
      $viste = 0
      foreach($riga in @($righe)){
        if($riga -match $PATTERN[$k]){
          $viste++
          if($viste -gt $prima){ [void]$fuori[$k].Add($riga.Trim()) }
        }
      }
    }
  }
  $fuori["CRESCIUTI"] = $cresciuti
  return $fuori
}

# ---------------------------------------------------------------------
#  LA FABBRICA DELL'.ini (struttura di walkforward_generico + R114).
#  PASSATA SINGOLA: Optimization=0, nessun OptimizationCriterion e
#  soprattutto NESSUNA riga in forma sweep (uno sweep rimasto sarebbe
#  un'ottimizzazione travestita, lezione R103/R114).
# ---------------------------------------------------------------------
function ControllaData([string]$dataArg,[string]$contesto){
  if($dataArg -notmatch '^\d{4}\.\d{2}\.\d{2}$'){ throw ($contesto + ": la data '" + $dataArg + "' non e' yyyy.MM.dd") }
  $d = [datetime]::MinValue
  if(-not [datetime]::TryParseExact($dataArg,"yyyy.MM.dd",$INV,[Globalization.DateTimeStyles]::None,[ref]$d)){ throw ($contesto + ": la data '" + $dataArg + "' non e' un giorno che esiste") }
}
function TestoIni([string]$simbolo,[string]$report,$righeInput){
  ControllaData $DaQuando ("fabbrica .ini " + $report)
  ControllaData $Fino     ("fabbrica .ini " + $report)
  $testoInput = (@($righeInput) -join "`r`n")
  return @"
[Charts]
MaxBars=2000000000

[Experts]
AllowLiveTrading=false
AllowDllImport=false

[Tester]
Expert=$EA.ex5
Symbol=$simbolo
Period=$PERIODO
Model=$Modello
Spread=$Spread
Optimization=0
FromDate=$DaQuando
ToDate=$Fino
ForwardMode=0
Deposit=$Deposito
Currency=EUR
Leverage=$Leva
ExecutionMode=0
ReplaceReport=1
ShutdownTerminal=1
Report=$report

[TesterInputs]
$testoInput
"@
}
# IL GATE SULLO STATO FINALE (si passa il testo RILETTO dal disco).
function VerificaIniTesto([string]$testo,[string]$simbolo,[int]$magic,[string]$valute,[string]$titolo){
  $guasti = New-Object System.Collections.ArrayList
  foreach($attesa in @(("Expert=" + $EA + ".ex5"),("Symbol=" + $simbolo),("Period=" + $PERIODO),
                       ("Model=" + $Modello),("Spread=" + $Spread),"Optimization=0",
                       ("FromDate=" + $DaQuando),("ToDate=" + $Fino),("Deposit=" + $Deposito),
                       "Currency=EUR",("Leverage=" + $Leva),"ShutdownTerminal=1","MaxBars=2000000000",
                       ("InpMagic=" + $magic),("InpNewsFile=" + $NEWSFILE),"InpNewsCommon=true",
                       ("InpNewsCurrencies=" + $valute),("InpNewsTitleMatch=" + $titolo),
                       "InpRestrictToNews=true","InpUseNewsFilter=true","InpAutoTest=true")){
    if($testo -notmatch ('(?m)^' + [regex]::Escape($attesa) + '\r?$')){ [void]$guasti.Add("manca la riga '" + $attesa + "'") }
  }
  $nLive = @([regex]::Matches($testo,'(?m)^AllowLiveTrading=false\r?$')).Count
  if($nLive -ne 1){ [void]$guasti.Add("AllowLiveTrading=false compare " + $nLive + " volte invece di 1") }
  $sweep = @([regex]::Matches($testo,'(?m)^\w+=[^\r\n]*\|\|[^\r\n]*\r?$')).Count
  if($sweep -ne 0){ [void]$guasti.Add("ci sono " + $sweep + " righe in forma sweep in un .ini a passata SINGOLA") }
  if($testo -match '(?m)^OptimizationCriterion='){ [void]$guasti.Add("c'e' un OptimizationCriterion in un .ini a passata singola") }
  return @($guasti)
}

try{
  Titolo ("POSTNEWS ECB+FOMC -- VERIFICA DEL CALENDARIO (" + $EA + " v" + $VERSIONE_ATTESA + ") -- modo " + $Modo)

  # -------------------------------------------------------------------
  #  0. LE GUARDIE, PRIMA DI TOCCARE QUALUNQUE COSA
  # -------------------------------------------------------------------
  if($Pin -eq ""){ throw "-Pin obbligatorio: senza, girerebbe la punta del branch spacciandola per un commit congelato." }
  if($Pin -notmatch '^[0-9a-f]{40}$'){ throw ("-Pin deve essere un commit di 40 caratteri esadecimali, ricevuto: " + $Pin) }
  if($Modello -lt 0 -or $Modello -gt 4){ throw ("-Modello " + $Modello + " non e' un modello del tester (0..4).") }
  if(Get-Process terminal64,metaeditor64 -ErrorAction SilentlyContinue){
    throw "MT5 O METAEDITOR APERTO: col terminale aperto il tester non parte pulito, con MetaEditor aperto la compilazione torna subito senza compilare. Chiudili e rilancia."
  }
  New-Item -ItemType Directory -Force -Path $Work | Out-Null

  # LA SENTINELLA DI UN GIRO PRECEDENTE (classe 116): se un giro e' stato
  # interrotto fra l'installazione dei file e il ripristino, qui si
  # rimette a posto PRIMA di tutto. Ogni riga: destinazione|backup.
  if(Test-Path -LiteralPath $Sentinella){
    $fatti = New-Object System.Collections.ArrayList
    foreach($riga in @(Get-Content -LiteralPath $Sentinella -ErrorAction SilentlyContinue)){
      $t = ("" + $riga).Trim()
      if($t -eq ""){ continue }
      $pezzi = $t -split '\|',2
      $dest = $pezzi[0]
      $back = ""
      if(@($pezzi).Count -ge 2){ $back = $pezzi[1] }
      if($dest -eq "" -or -not (Test-Path -LiteralPath $dest)){ [void]$fatti.Add((Split-Path -Leaf $dest) + ": niente da fare"); continue }
      if($back -ne "" -and (Test-Path -LiteralPath $back)){
        Copy-Item -LiteralPath $back -Destination $dest -Force
        Remove-Item -LiteralPath $back -Force -ErrorAction SilentlyContinue
        [void]$fatti.Add((Split-Path -Leaf $dest) + ": RIPRISTINATO dal backup")
      } else {
        Remove-Item -LiteralPath $dest -Force -ErrorAction SilentlyContinue
        [void]$fatti.Add((Split-Path -Leaf $dest) + ": RIMOSSO (non c'era prima di quel giro)")
      }
    }
    Remove-Item -LiteralPath $Sentinella -Force -ErrorAction SilentlyContinue
    [void]$Rilievi.Add("UN GIRO PRECEDENTE ERA STATO INTERROTTO prima del ripristino: rimesso a posto adesso, all'avvio di questo giro -- " + ($fatti -join " ; "))
    Dico ("sentinella di un giro interrotto: " + ($fatti -join " ; ")) "Yellow"
  }
  Dico ("pin ......... " + $Pin)
  Dico ("domanda ..... UNA, binaria, per sedia: il calendario " + $NEWSFILE + " viene LETTO (da Common\Files) oppure no. Nessun numero economico esce da qui.") "Yellow"
  Dico ("sedie ....... ECB/EURJPY magic 771201 | FOMC/EURUSD magic 771202 (le due gia' VIVE in forward: qui si tocca SOLO il PC di backtest)") "Yellow"
  Dico ("finestra .... " + $DaQuando + " -> " + $Fino + " | Modello " + $Modello + " | @PERIODO " + $PERIODO)

  # -------------------------------------------------------------------
  #  1. SCARICO AL PIN
  # -------------------------------------------------------------------
  Titolo "1. SCARICO AL PIN (EA, include, calendario, i due preset)"
  $mq5 = Join-Path $Work ($EA + ".mq5")
  $mqh = Join-Path $Work $INC
  Scarica ($RawPin + "/mql5/Experts/" + $EA + ".mq5") $mq5
  $calPin = Join-Path $Work $NEWSFILE
  Scarica ($RawPin + "/mql5/Files/" + $NEWSFILE) $calPin
  foreach($s in $SEDIE){
    Scarica ($RawPin + "/mql5/Presets/" + $s.Preset) (Join-Path $Work $s.Preset)
  }
  Dico ("scaricati: " + $EA + ".mq5, " + $NEWSFILE + ", " + (@($SEDIE | ForEach-Object { $_.Preset }) -join ", ")) "Green"

  # -------------------------------------------------------------------
  #  2. GATE SUL SORGENTE
  # -------------------------------------------------------------------
  Titolo "2. GATE SUL SORGENTE: versione, autotest ricalcolato, include censiti, hedge-safe, OnTester, input col default"
  $srcRighe = @(LeggiTesto $mq5)
  $vers = @($srcRighe | Where-Object { $_ -match '^\s*#property\s+version\s+"([^"]+)"' } | ForEach-Object { [regex]::Match($_,'"([^"]+)"').Groups[1].Value })
  if(@($vers).Count -ne 1){ $VersTxt = "NON TROVATA (o doppia): " + @($vers).Count + " righe #property version"; throw ("#property version non trovata (o doppia) in " + $EA + ".mq5: " + @($vers).Count + " righe.") }
  $VersTxt = $vers[0]
  if($VersTxt -ne $VERSIONE_ATTESA){ throw ("versione letta '" + $VersTxt + "', attesa '" + $VERSIONE_ATTESA + "': il file al pin NON e' l'EA col fix FILE_COMMON verificato a mano il 04/09/2026. Se l'EA e' stato aggiornato, va aggiornata QUESTA riga (a mano, dopo aver riletto il fix), non il gate.") }

  $srcRaw = ($srcRighe -join "`n")
  $nAT = @([regex]::Matches($srcRaw,'falliti\s*\+=\s*AT_Caso\(')).Count
  $nPP = @([regex]::Matches($srcRaw,'if\s*\(\s*!\w+\s*\)\s*falliti\+\+;')).Count
  # NB: "" davanti, sempre: $nAT e' un [int] e '$nAT + " testo"' proverebbe a
  # convertire la STRINGA in numero (fermata vera, vista al primo giro a vuoto).
  $AutotestTxt = "" + $nAT + " AT_Caso() + " + $nPP + " controlli 'if(!X) falliti++;' = " + ($nAT+$nPP) + " casi totali (nessun #define nel sorgente: RICALCOLATO ora dal file al pin)"
  if($nAT -ne $AT_CASO_ATTESI -or $nPP -ne $FALLITIPP_ATTESI){ throw ("autotest: " + $AutotestTxt + " -- atteso " + $AT_CASO_ATTESI + " AT_Caso() + " + $FALLITIPP_ATTESI + " controlli. Il sorgente e' cambiato: il gate NON si aggiorna da solo.") }

  if($srcRaw -notmatch 'double\s+OnTester\s*\('){ throw ("" + $EA + ".mq5 non ha OnTester: non e' l'EA atteso.") }
  $OnTesterTxt = "presente (in questa riga NON produce niente: Optimization=0, OnTesterDeinit non gira)"

  $hedge = 0
  foreach($riga in $srcRighe){ $viva = ($riga -replace '//.*$',''); if($viva -match 'Position(Select|Close|Modify|ClosePartial)\s*\(\s*_Symbol\s*[\),]'){ $hedge++ } }
  $HedgeTxt = "" + $hedge + " chiamate Position*(_Symbol) fuori dai commenti (attese 0: hedge-safe)"
  if($hedge -gt 0){ throw ("L'EA NON e' hedge-safe: " + $HedgeTxt + ".") }

  $incl = New-Object System.Collections.ArrayList
  foreach($riga in $srcRighe){ $viva = ($riga -replace '//.*$',''); $m = [regex]::Match($viva,'^\s*#include\s*[<"]([^>"]+)[>"]'); if($m.Success){ [void]$incl.Add($m.Groups[1].Value.Trim()) } }
  $IncTxt = "" + $incl.Count + " (" + ($incl -join ", ") + ")"
  $inattesi = @($incl | Where-Object { $_ -ne "Trade/Trade.mqh" -and $_ -ne $INC })
  if(@($inattesi).Count -gt 0){ throw ("include NON previsti nel sorgente: " + ($inattesi -join ", ") + ". La riga installa SOLO " + $INC + ".") }

  $InputsSorgente = LeggiInputsSorgente $srcRighe
  $InputTxt = "" + @($InputsSorgente.Keys).Count + " input letti dal sorgente al pin, tutti col default risolto (finiranno TUTTI nell'.ini: niente stato ereditato dall'ultima corsa del tester)"
  if(-not $InputsSorgente.Contains("InpNewsCommon")){ throw "il sorgente al pin non ha l'input InpNewsCommon: non e' l'EA col fix v1.10." }
  $NewsCommonTxt = "default compilato = '" + $InputsSorgente["InpNewsCommon"].Val + "' (i due .set NON lo nominano: e' questo il valore che va nell'.ini, ed e' la stessa condizione della sedia in forward)"
  if($InputsSorgente["InpNewsCommon"].Val -ne "true"){ throw ("InpNewsCommon ha default '" + $InputsSorgente["InpNewsCommon"].Val + "' invece di 'true': i due preset non lo nominano, quindi la corsa NON proverebbe il ramo Common\Files. Prima di misurare, o si cambia il default o si aggiunge la riga ai .set.") }
  # InpAutoTest e' il SECONDO canarino (il caso n.5 dell'autotest E' il
  # calendario) ed e' un gate del verdetto: se non fosse acceso, il gate
  # cadrebbe piu' avanti con un messaggio oscuro ("manca la riga
  # InpAutoTest=true"). Meglio fermarsi qui, dicendo perche'.
  if(-not $InputsSorgente.Contains("InpAutoTest")){ throw "il sorgente al pin non ha l'input InpAutoTest: il secondo canarino (autotest) non esisterebbe e il verdetto perderebbe un gate." }
  if($InputsSorgente["InpAutoTest"].Val -ne "true"){ throw ("InpAutoTest ha default '" + $InputsSorgente["InpAutoTest"].Val + "' invece di 'true' e i due .set non lo nominano: la riga '[PostNews][AUTOTEST] ---- fine: N casi falliti ----' non comparirebbe, e con lei il secondo canarino sul calendario.") }
  Dico ("versione " + $VersTxt + " | autotest " + $AutotestTxt + " | " + $HedgeTxt + " | include " + $IncTxt) "Green"
  Dico ("input: " + $InputTxt) "Green"
  Dico ("InpNewsCommon: " + $NewsCommonTxt) "Green"

  if($incl -contains $INC){
    Scarica ($RawPin + "/mql5/Include/" + $INC) $mqh
    $ng = @((LeggiTesto $mqh) | Where-Object { $_ -match '^\s*bool\s+ABTG_GuardiaIngresso\s*\(' }).Count
    $IncGuardia = "bool ABTG_GuardiaIngresso( trovata " + $ng + " volta; " + (Get-Item -LiteralPath $mqh).Length + " byte"
    if($ng -ne 1){ throw ("l'include al pin non definisce ESATTAMENTE una 'bool ABTG_GuardiaIngresso(' (" + $ng + ").") }
    Dico ("include scaricato al pin: " + $IncGuardia) "Green"
  } else {
    $IncGuardia = "il sorgente NON include " + $INC + ": niente da installare"
    [void]$Rilievi.Add($IncGuardia)
  }

  # -------------------------------------------------------------------
  #  3. GATE SUI DUE PRESET
  # -------------------------------------------------------------------
  Titolo "3. GATE SUI DUE PRESET .set (chiavi esistenti nell'EA, magic/valuta/titolo/file attesi)"
  $magicVisti = @{}
  foreach($s in $SEDIE){
    $mappa = LeggiSet (Join-Path $Work $s.Preset) $s.Preset
    $ignoti = @(@($mappa.Keys) | Where-Object { -not $InputsSorgente.Contains($_) })
    if(@($ignoti).Count -gt 0){ throw ("preset " + $s.Preset + ": nomina parametri che l'EA NON ha (" + ($ignoti -join ", ") + "). MT5 li ignorerebbe IN SILENZIO e la sedia in forward starebbe girando con altri valori: e' un guasto vero, non un dettaglio.") }
    foreach($k in @(@{N="InpNewsFile"; V=$NEWSFILE}, @{N="InpNewsCurrencies"; V=$s.Ccy}, @{N="InpNewsTitleMatch"; V=$s.Titolo},
                    @{N="InpMagic"; V=("" + $s.Magic)}, @{N="InpRestrictToNews"; V="true"}, @{N="InpUseNewsFilter"; V="true"})){
      if(-not $mappa.Contains($k.N)){ throw ("preset " + $s.Preset + ": manca la riga '" + $k.N + "'.") }
      if(("" + $mappa[$k.N]) -ne $k.V){ throw ("preset " + $s.Preset + ": " + $k.N + " e' '" + $mappa[$k.N] + "', atteso '" + $k.V + "' (e' la sedia dichiarata in FLOTTA_ATTIVA: se e' cambiata, va cambiata anche questa riga, a mano).") }
    }
    if($magicVisti.ContainsKey("" + $s.Magic)){ throw ("due sedie con lo stesso magic " + $s.Magic + ": impossibile distinguerle.") }
    $magicVisti["" + $s.Magic] = $true
    if(-not $mappa.Contains("InpNewsCommon")){
      [void]$Rilievi.Add("preset " + $s.Preset + ": NON nomina InpNewsCommon (e' precedente alla v1.10). Nell'.ini ci va il DEFAULT COMPILATO 'true', che e' la stessa condizione della sedia in forward. Aggiungere la riga esplicita al .set e' una modifica CANDIDATA, da decidere DOPO questa verifica: la riga non la fa da sola.")
    } elseif(("" + $mappa["InpNewsCommon"]) -ne "true"){
      throw ("preset " + $s.Preset + ": InpNewsCommon e' '" + $mappa["InpNewsCommon"] + "', non 'true': cosi' il ramo Common\Files non verrebbe nemmeno provato.")
    }
    if(("" + $mappa["InpVerbose"]) -ne "true"){ [void]$Rilievi.Add("preset " + $s.Preset + ": InpVerbose non e' true: le righe '[PostNews] BUY/SELL STOP @' (rilievo, non gate) non compariranno.") }
    if($mappa.Contains("InpRiskPercent")){ [void]$Rilievi.Add("preset " + $s.Preset + ": InpRiskPercent=" + $mappa["InpRiskPercent"] + " (il numero del corso). Fuori dal metro di casa, ma NON e' oggetto di questa verifica e questa riga non tocca i .set: agli atti.") }
    $Stato[$s.Id].Preset = "VALIDO: " + @($mappa.Keys).Count + " righe, tutte esistenti nell'EA; magic " + $s.Magic + ", valuta '" + $s.Ccy + "', titolo contiene '" + $s.Titolo + "', file '" + $NEWSFILE + "'"
    $s | Add-Member -NotePropertyName Mappa -NotePropertyValue $mappa -Force
    Dico ($s.Id + ": " + $Stato[$s.Id].Preset) "Green"
  }

  # -------------------------------------------------------------------
  #  4. GATE SUL CALENDARIO AL PIN (+ almeno un evento NELLA finestra)
  # -------------------------------------------------------------------
  Titolo "4. GATE SUL CALENDARIO al pin: righe evento, UTILI per sedia, e almeno UN evento DENTRO la finestra"
  $calRighe = @(Get-Content -LiteralPath $calPin)
  if(@($calRighe).Count -lt 2){ throw ("calendario " + $NEWSFILE + ": " + @($calRighe).Count + " righe. Un calendario vuoto non prova niente (NB: data\abtg_news.csv nella cartella data\ del repo E' vuoto: quello giusto e' mql5\Files\)." ) }
  if($calRighe[0].Trim() -ne "Data Ora;Impatto;Valuta;Titolo"){ throw ("calendario " + $NEWSFILE + ": header '" + $calRighe[0] + "', atteso 'Data Ora;Impatto;Valuta;Titolo'.") }
  $Eventi = LeggiCalendario $calPin
  $NRigheEventoPin = @($Eventi).Count
  if($NRigheEventoPin -le 0){ throw ("calendario " + $NEWSFILE + ": ZERO righe evento leggibili. La verifica non avrebbe niente da trovare.") }
  $CalCsvTxt = "" + @($calRighe).Count + " righe nel file (1 header + " + $NRigheEventoPin + " eventi), header verificato. L'EA deve stampare 'righe " + $NRigheEventoPin + "': un numero diverso vuol dire che ha letto UN ALTRO " + $NEWSFILE + "."
  Dico ("calendario: " + $CalCsvTxt) "Green"

  $dtDa = [datetime]::ParseExact($DaQuando,"yyyy.MM.dd",$INV)
  $dtA  = [datetime]::ParseExact($Fino,"yyyy.MM.dd",$INV)
  if($dtA -le $dtDa){ throw ("-Fino " + $Fino + " non e' dopo -DaQuando " + $DaQuando + ".") }
  $righeFinestra = New-Object System.Collections.ArrayList
  foreach($s in $SEDIE){
    $minImp = 3
    if($s.Mappa.Contains("InpNewsMinImpact")){ $minImp = [int]$s.Mappa["InpNewsMinImpact"] }
    $utili = @($Eventi | Where-Object { PassaFiltri $_ $s.Ccy $s.Titolo $minImp })
    $Stato[$s.Id].UtiliAttesi = @($utili).Count
    if($Stato[$s.Id].UtiliAttesi -le 0){ throw ("sedia " + $s.Id + ": il calendario AL PIN non contiene NEMMENO UN evento con impatto>=" + $minImp + ", valuta '" + $s.Ccy + "' e titolo che contiene '" + $s.Titolo + "'. Con questo file la verifica non puo' dire niente: prima si aggiorna " + $NEWSFILE + " nel repo.") }
    if($Stato[$s.Id].UtiliAttesi -ne $s.UtiliOggi){
      [void]$Rilievi.Add("sedia " + $s.Id + ": eventi utili nel calendario al pin = " + $Stato[$s.Id].UtiliAttesi + ", mentre quando questa riga e' stata scritta (04/09/2026) erano " + $s.UtiliOggi + ". NON e' un errore: il calendario si aggiorna. Il gate vero e' il confronto col numero RICONTATO adesso, non con quello scritto qui.")
    }
    # >>> il pezzo che 'UTILI' NON dimostra: eventi DENTRO la finestra.
    #     ToDate del tester si ferma all'inizio del giorno -Fino: qui la
    #     finestra si conta [da, a) apposta.
    $dentro = @($utili | Where-Object { $_.T -ge $dtDa -and $_.T -lt $dtA })
    $Stato[$s.Id].InFinestra = @($dentro).Count
    $Stato[$s.Id].DateFinestra = (@($dentro | ForEach-Object { $_.T.ToString("yyyy.MM.dd HH:mm",$INV) + " " + $_.Titolo }) -join " ; ")
    if($Stato[$s.Id].InFinestra -le 0){
      throw ("sedia " + $s.Id + ": nella finestra " + $DaQuando + " -> " + $Fino + " NON c'e' nemmeno un evento di questa sedia. La corsa girerebbe a vuoto sul lato operativo e non risponderebbe alla domanda: scegli un'altra finestra con -DaQuando/-Fino (il calendario al pin ha eventi utili per questa sedia in: " + ((@($utili | ForEach-Object { $_.T.ToString("yyyy.MM.dd",$INV) })) -join ", ") + ").")
    }
    [void]$righeFinestra.Add("  " + $s.Id + ": UTILI attesi nel file " + $Stato[$s.Id].UtiliAttesi + " | DENTRO la finestra " + $Stato[$s.Id].InFinestra + " -> " + $Stato[$s.Id].DateFinestra)
    Dico ($s.Id + ": utili nel file " + $Stato[$s.Id].UtiliAttesi + ", nella finestra " + $Stato[$s.Id].InFinestra + " (" + $Stato[$s.Id].DateFinestra + ")") "Green"
  }
  $FinestraTxt = "VERIFICATA PRIMA DI APRIRE MT5: ogni sedia ha almeno un evento dentro " + $DaQuando + " -> " + $Fino
  foreach($l in $righeFinestra){ [void]$Rilievi.Add(("eventi in finestra -- " + $l.Trim())) }

  # -------------------------------------------------------------------
  #  5. IL TERMINALE DI BACKTEST
  # -------------------------------------------------------------------
  Titolo "5. TERMINALE BCM DI BACKTEST (non -V3) e cartella dati"
  $allTerm = @(Get-ChildItem "C:\Program Files","C:\Program Files (x86)" -Recurse -Filter "terminal64.exe" -ErrorAction SilentlyContinue)
  if($Terminale -ne ""){
    if(-not (Test-Path -LiteralPath (Join-Path $Terminale "terminal64.exe"))){ throw ("-Terminale '" + $Terminale + "' non contiene terminal64.exe.") }
    $InstDir = $Terminale
    $TermTxt = $InstDir + " (imposto con -Terminale)"
  } else {
    $cand = @($allTerm | Where-Object { $_.DirectoryName -like "*BCM Markets MT5 Terminal*" -and $_.DirectoryName -notlike "*-V3*" })
    if(@($cand).Count -eq 0){ $cand = @($allTerm | Where-Object { $_.DirectoryName -like "*BCM Markets*" -and $_.DirectoryName -notlike "*-V3*" }) }
    if(@($cand).Count -ne 1){
      Write-Host "  installazioni MT5 con terminal64.exe trovate:" -ForegroundColor Gray
      foreach($tt in $allTerm){ Write-Host ("    " + $tt.DirectoryName) -ForegroundColor Gray }
      if(@($allTerm).Count -eq 0){ Write-Host "    (nessuna)" -ForegroundColor Gray }
      throw ("NON SO QUALE TERMINALE USARE: candidate BCM non -V3 = " + @($cand).Count + ". Rilancia lo stesso blocco aggiungendo al driver: -Terminale '<cartella dell'installazione di backtest, copiata dall'elenco qui sopra>'.")
    }
    $InstDir = $cand[0].DirectoryName
    $TermTxt = $InstDir + " (selettore: BCM Markets, non -V3)"
  }
  $Terminal64 = Join-Path $InstDir "terminal64.exe"
  $MetaEditor = Join-Path $InstDir "metaeditor64.exe"
  if(-not (Test-Path -LiteralPath $MetaEditor)){ throw ("metaeditor64.exe non trovato in " + $InstDir) }
  $termRoot = Join-Path $env:APPDATA "MetaQuotes\Terminal"
  $DataFolder = (Get-ChildItem $termRoot -Directory -ErrorAction SilentlyContinue | Where-Object { $o = Join-Path $_.FullName "origin.txt"; (Test-Path $o) -and ((Get-Content $o -Raw).Trim() -ieq $InstDir) } | Select-Object -First 1 -ExpandProperty FullName)
  if(-not $DataFolder){
    $portable = Join-Path $InstDir "MQL5"
    if(Test-Path -LiteralPath $portable){ $DataFolder = $InstDir; [void]$Rilievi.Add("cartella dati PORTABLE (dentro l'installazione): nessun origin.txt la puntava.") }
    else{ throw ("cartella dati non trovata per " + $InstDir + " (nessun origin.txt in " + $termRoot + " la punta, e non e' portable).") }
  }
  Dico ("terminale: " + $TermTxt) "Yellow"
  Dico ("cartella dati: " + $DataFolder)

  # -------------------------------------------------------------------
  #  6. FOTO PRIMA -> include -> compilazione -> calendario (con backup)
  # -------------------------------------------------------------------
  Titolo "6. FOTO PRIMA -> include installato -> EA compilato -> calendario installato in ENTRAMBI i posti (con backup)"
  $dstExp = Join-Path $DataFolder "MQL5\Experts"
  $dstInc = Join-Path $DataFolder "MQL5\Include"
  $dstFil = Join-Path $DataFolder "MQL5\Files"
  $commonFiles = Join-Path $env:APPDATA "MetaQuotes\Terminal\Common\Files"
  New-Item -ItemType Directory -Force -Path $dstExp,$dstInc,$dstFil,$commonFiles | Out-Null
  $TExpMq5   = Join-Path $dstExp ($EA + ".mq5")
  $TExpEx5   = Join-Path $dstExp ($EA + ".ex5")
  $TIncMqh   = Join-Path $dstInc $INC
  $CalCommon = Join-Path $commonFiles $NEWSFILE
  $CalLocale = Join-Path $dstFil $NEWSFILE
  $F1Prima = Foto $TExpMq5; $F2Prima = Foto $TExpEx5; $F3Prima = Foto $TIncMqh
  $FCalCommonPrima = Foto $CalCommon; $FCalLocalePrima = Foto $CalLocale
  $FotoPrese = $true
  Dico ("foto PRIMA -- Experts\" + $EA + ".mq5: " + (FotoTxt $F1Prima))
  Dico ("foto PRIMA -- Experts\" + $EA + ".ex5: " + (FotoTxt $F2Prima))
  Dico ("foto PRIMA -- Include\" + $INC + ": " + (FotoTxt $F3Prima))
  Dico ("foto PRIMA -- Common\Files\" + $NEWSFILE + ": " + (FotoTxt $FCalCommonPrima))
  Dico ("foto PRIMA -- MQL5\Files\" + $NEWSFILE + ": " + (FotoTxt $FCalLocalePrima))

  if($incl -contains $INC){
    $esitoInc = InstallaConBackup $mqh $TIncMqh
    $IncInstallato = $true
    Dico ("include " + $INC + ": " + $esitoInc) "Yellow"
  }
  Copy-Item -LiteralPath $mq5 -Destination $TExpMq5 -Force
  $esito = Compila $MetaEditor $TExpMq5 $TExpEx5 $logC 240
  $nErr = -1; $nWar = -1
  foreach($riga in @($esito.Log)){
    $m = [regex]::Match($riga, '(?i)(\d+)\s+error[s]?\s*,\s*(\d+)\s+warning')
    if($m.Success){ $nErr = [int]::Parse($m.Groups[1].Value,$INV); $nWar = [int]::Parse($m.Groups[2].Value,$INV); $ResultTxt = $riga.Trim() }
  }
  if($nErr -lt 0){ $ResultTxt = "NON TROVATA nel log (fa fede l'.ex5 fresco)" }
  if($esito.Ex5 -and $nErr -le 0){
    $itm = Get-Item -LiteralPath $TExpEx5
    $Compilato = "OK (" + [int]($itm.Length/1024) + " KB, " + $itm.Length + " byte, " + $itm.LastWriteTime.ToString("HH:mm:ss",$INV) + "), errori 0, warning " + $(if($nWar -ge 0){ "" + $nWar } else { "NON LETTI" })
    Dico ("COMPILATO: " + $Compilato) "Green"
    if($nWar -gt 0){ foreach($riga in @($esito.Log)){ if($riga -match '(?i):\s*warning'){ [void]$Rilievi.Add("warning di compilazione: " + $riga.Trim()) } } }
  }
  else{
    if($esito.Muto -or @($esito.Log).Count -eq 0){
      $Compilato = "FALLITA -- METAEDITOR MUTO: lanciato ed e' tornato SENZA scrivere ne' log ne' .ex5. NON e' un verdetto sul codice."
    } else {
      $Compilato = "FALLITA (MetaEditor lanciato, nessun .ex5 fresco; errori dal log: " + $(if($nErr -ge 0){ "" + $nErr } else { "NON LETTI" }) + ")"
    }
    $k = 0
    foreach($riga in @($esito.Log)){ if($riga.Trim() -eq ""){ continue }; Write-Host ("      " + $riga) -ForegroundColor Red; $k++; if($k -ge 30){ break } }
    throw ("COMPILAZIONE FALLITA: " + $Compilato)
  }

  # IL CALENDARIO, IN ENTRAMBI I POSTI, CON BACKUP. Common\Files e' quella
  # che il fix v1.10 prova per prima (ed e' l'unica che gli agenti
  # dell'ottimizzazione condividono); la sandbox serve al ripiego.
  $esitoCC = InstallaConBackup $calPin $CalCommon
  $esitoCL = InstallaConBackup $calPin $CalLocale
  $CalInstallato = $true
  $lenPin = (Get-Item -LiteralPath $calPin).Length
  if((Foto $CalCommon).Len -ne $lenPin){ throw "installazione del calendario in Common\Files FALLITA (dimensione diversa dal file al pin)." }
  if((Foto $CalLocale).Len -ne $lenPin){ throw "installazione del calendario in MQL5\Files FALLITA (dimensione diversa dal file al pin)." }
  Dico ("calendario Common\Files: " + $esitoCC) "Yellow"
  Dico ("calendario MQL5\Files:  " + $esitoCL) "Yellow"

  # -------------------------------------------------------------------
  #  7. GLI .ini (uno per sedia), riletti dal disco e verificati
  # -------------------------------------------------------------------
  Titolo "7. GLI .ini PER SEDIA (passata SINGOLA, tutti gli input scritti, gate sullo stato finale riletto dal disco)"
  foreach($s in $SEDIE){
    # 1) tutti gli input al DEFAULT COMPILATO; 2) il preset sovrascrive.
    $valori = [ordered]@{}
    foreach($k in @($InputsSorgente.Keys)){ $valori[$k] = $InputsSorgente[$k].Val }
    foreach($k in @($s.Mappa.Keys)){ $valori[$k] = $s.Mappa[$k] }
    $righeInput = New-Object System.Collections.ArrayList
    foreach($k in @($valori.Keys)){
      $v = "" + $valori[$k]
      if($v -match '\|\|'){ throw ("input " + $k + ": valore in forma sweep in una passata singola ('" + $v + "').") }
      if($InputsSorgente[$k].Kind -eq "stringa" -and $v -eq ""){ [void]$Rilievi.Add("input " + $k + ": stringa vuota, lasciata al default compilato (MT5 non accetta una riga vuota)."); continue }
      [void]$righeInput.Add($k + "=" + $v)
    }
    $nomi = @(@($righeInput) | ForEach-Object { ($_ -split '=')[0] })
    $doppi = @($nomi | Group-Object | Where-Object { $_.Count -gt 1 })
    if(@($doppi).Count -gt 0){ throw ("sedia " + $s.Id + ": parametri doppi in [TesterInputs] (" + (@($doppi | ForEach-Object { $_.Name }) -join ", ") + "): MT5 farebbe ZERO passate.") }

    $report = "OptReport_POSTNEWSVER_" + $s.Id
    $testo = TestoIni $s.Sym $report $righeInput
    $iniPath = Join-Path $Work ("gen_POSTNEWSVER_" + $s.Id + ".ini")
    Set-Content -LiteralPath $iniPath -Value $testo -Encoding ASCII
    $guasti = VerificaIniTesto (Get-Content -LiteralPath $iniPath -Raw) $s.Sym $s.Magic $s.Ccy $s.Titolo
    if(@($guasti).Count -gt 0){ throw ("sedia " + $s.Id + ": .ini NON conforme (riletto dal disco): " + ($guasti -join " ; ")) }
    $Stato[$s.Id].Ini = "SCRITTO e VERIFICATO dal disco: " + @($righeInput).Count + " righe in [TesterInputs] (tutti gli input dell'EA), Optimization=0, nessuna riga sweep"
    $Stato[$s.Id].IniPath = $iniPath
    Dico ($s.Id + ": " + $Stato[$s.Id].Ini) "Green"
  }

  if($SoloControllo){
    foreach($s in $SEDIE){ $Stato[$s.Id].Corsa = "NON TENTATA (-SoloControllo: MT5 non viene aperto, mai)"; $Stato[$s.Id].Verdetto = "NON MISURATO (giro di controllo: il canarino si legge SOLO dopo una corsa vera)" }
    Dico "GIRO DI CONTROLLO: MT5 NON e' stato aperto. Se il referto e' pulito, lancia il blocco 2." "Green"
  }
  else{
    # -----------------------------------------------------------------
    #  8. LE DUE CORSE
    # -----------------------------------------------------------------
    Titolo "8. Tester\cache svuotata (SOLO quella) e UNA corsa per sedia"
    $cacheT = Join-Path $DataFolder "Tester\cache"
    if(Test-Path -LiteralPath $cacheT){
      $ncPrima = @(Get-ChildItem -LiteralPath $cacheT -Recurse -File -ErrorAction SilentlyContinue).Count
      Remove-Item (Join-Path $cacheT "*") -Recurse -Force -ErrorAction SilentlyContinue
      $ncDopo = @(Get-ChildItem -LiteralPath $cacheT -Recurse -File -ErrorAction SilentlyContinue).Count
      $CacheTxt = "prima " + $ncPrima + " file, dopo " + $ncDopo
      if($ncDopo -gt 0){ [void]$Rilievi.Add("Tester\cache non si e' svuotata del tutto (" + $CacheTxt + "): a passata singola conta meno che in ottimizzazione, ma va detto.") }
    } else { $CacheTxt = "cartella assente (" + $cacheT + "): niente da svuotare" }
    Dico ("Tester\cache: " + $CacheTxt) "Green"

    foreach($s in $SEDIE){
      Titolo ("8." + $s.Id + " -- corsa singola su " + $s.Sym + " " + $PERIODO + " (magic " + $s.Magic + ")")
      # RI-GUARDIA: fra una corsa e l'altra MT5 potrebbe essere stato
      # riaperto a mano. Non si presume: si ricontrolla.
      if(Get-Process terminal64,metaeditor64 -ErrorAction SilentlyContinue){
        throw ("MT5 O METAEDITOR APERTO (ricontrollato subito prima della corsa " + $s.Id + "): chiudili e rilancia LA STESSA riga.")
      }
      $fotoPrima = FotoLog
      $Stato[$s.Id].LogVisti = @($fotoPrima.Keys).Count
      Dico ("radici del tester guardate: " + ((RadiciLog) -join " ; ") + " -- file .log gia' presenti: " + $Stato[$s.Id].LogVisti) "DarkGray"
      $t0 = Get-Date
      Dico ("avvio il tester (tetto " + $TimeoutMin + " min)...") "Cyan"
      $proc = Start-Process -FilePath $Terminal64 -ArgumentList ("/config:`"" + $Stato[$s.Id].IniPath + "`"") -PassThru
      $uscito = $proc.WaitForExit($TimeoutMin * 60 * 1000)
      if(-not $uscito){
        try{ Get-Process -Name "terminal64" -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue }catch{}
        Start-Sleep -Seconds 3
        [void]$Problemi.Add("sedia " + $s.Id + ": il tester NON e' uscito entro " + $TimeoutMin + " minuti ed e' stato chiuso a forza. Due nomi possibili (non uno): (1) storico M1 di " + $s.Sym + " mancante e scarico in corso; (2) una finestra modale del terminale. Le righe di log qui sotto valgono lo stesso, ma la corsa NON e' completa.")
        $Stato[$s.Id].Corsa = "INTERROTTA dal tetto di " + $TimeoutMin + " minuti"
      } else {
        $Stato[$s.Id].Corsa = "COMPLETATA in " + [int]((New-TimeSpan -Start $t0 -End (Get-Date)).TotalSeconds) + " s"
      }
      Start-Sleep -Seconds 2
      $nuove = RaccogliNuove $fotoPrima $s.Id
      $Stato[$s.Id].LogNuovi   = [int]$nuove["CRESCIUTI"]
      $Stato[$s.Id].RigheNews  = @($nuove["NEWS"])
      $Stato[$s.Id].Autotest   = @($nuove["AUTOFIN"])
      $Stato[$s.Id].Cieco      = @($nuove["CIECO"]).Count
      $Stato[$s.Id].Rosso      = @($nuove["ROSSO"]).Count
      $Stato[$s.Id].Ordini     = @($nuove["ORDINE"]).Count
      $Stato[$s.Id].NienteNews = @($nuove["NIENTE"]).Count
      $guai = @($nuove["GUAI"])
      # dal canarino: 'letto da X', 'righe N', 'UTILI ... M'
      $dove = New-Object System.Collections.ArrayList
      $rig  = New-Object System.Collections.ArrayList
      $uti  = New-Object System.Collections.ArrayList
      foreach($riga in @($Stato[$s.Id].RigheNews)){
        $m1 = [regex]::Match($riga,'letto da\s+(.+?)\s*\|')
        if($m1.Success){ [void]$dove.Add($m1.Groups[1].Value.Trim()) }
        $m2 = [regex]::Match($riga,'righe\s+(-?\d+)')
        if($m2.Success){ [void]$rig.Add([int]$m2.Groups[1].Value) }
        $m3 = [regex]::Match($riga,'UTILI per questo preset\s+(-?\d+)')
        if($m3.Success){ [void]$uti.Add([int]$m3.Groups[1].Value) }
      }
      $Stato[$s.Id].Dove = @($dove); $Stato[$s.Id].RigheFile = @($rig); $Stato[$s.Id].Utili = @($uti)
      $af = New-Object System.Collections.ArrayList
      foreach($riga in @($Stato[$s.Id].Autotest)){
        $m4 = [regex]::Match($riga,'---- fine:\s+(-?\d+)\s+casi falliti')
        if($m4.Success){ [void]$af.Add([int]$m4.Groups[1].Value) }
      }
      $Stato[$s.Id].AutoFalliti = @($af)
      Set-Content -LiteralPath (Join-Path $Work ("evidenza_" + $s.Id + ".txt")) -Encoding ASCII -Value (@(
        ("=== EVIDENZA GREZZA DAI LOG DEL TESTER -- sedia " + $s.Id + " (" + $s.Sym + ", magic " + $s.Magic + ") ==="),
        ("corsa: " + $Stato[$s.Id].Corsa + " | file di log cresciuti: " + $Stato[$s.Id].LogNuovi),
        "",
        "--- righe canarino [PostNews][NEWS] letto da ... ---") +
        @($Stato[$s.Id].RigheNews) + @("", "--- righe autotest ---") + @($Stato[$s.Id].Autotest) +
        @("", "--- righe con parole di guasto (history/error/...): solo le NUOVE di questa corsa ---") + @($guai | Select-Object -First 60))
      Dico ("canarini NEWS: " + @($Stato[$s.Id].RigheNews).Count + " righe | autotest: " + @($Stato[$s.Id].Autotest).Count + " righe | ordini piazzati: " + $Stato[$s.Id].Ordini + " | log cresciuti: " + $Stato[$s.Id].LogNuovi) "Yellow"
      foreach($riga in @($Stato[$s.Id].RigheNews | Select-Object -First 3)){ Write-Host ("      " + $riga) -ForegroundColor Gray }
    }

    # -----------------------------------------------------------------
    #  9. IL VERDETTO, PER SEDIA, BINARIO
    # -----------------------------------------------------------------
    Titolo "9. VERDETTO PER SEDIA (binario: CALENDARIO LETTO / CALENDARIO CIECO-PROBLEMA)"
    foreach($s in $SEDIE){
      $st = $Stato[$s.Id]
      $motivi = New-Object System.Collections.ArrayList
      if(@($st.RigheNews).Count -eq 0){
        [void]$motivi.Add("NESSUNA riga '[PostNews][NEWS] letto da ...' nei log del tester cresciuti (file .log visti nelle radici del tester: " + $st.LogVisti + ", cresciuti in questa corsa: " + $st.LogNuovi + "). Due nomi possibili, non uno: (1) la passata NON e' girata (storico M1/M5 di " + $s.Sym + " assente nella finestra, terminale fermo su una finestra modale, .ex5 non caricato); (2) i log del tester non stanno in nessuna delle tre radici che questa riga guarda. QUESTA RIGA NON MISURA LO STORICO, per scelta dichiarata: se il sospetto e' quello, si misura con scarica_storico.ps1 -Simboli " + $s.Sym + " -SoloReferto. Guarda evidenza_" + $s.Id + ".txt e i log_" + $s.Id + "_*.log nello zip.")
      }
      if($st.Cieco -gt 0){ [void]$motivi.Add("CALENDARIO CIECO trovato " + $st.Cieco + " volte: l'EA non ha trovato " + $NEWSFILE + " ne' in Common\Files ne' nella sandbox.") }
      if($st.Rosso -gt 0){ [void]$motivi.Add("CANARINO ROSSO trovato " + $st.Rosso + " volte: il file si legge ma per questo preset NON contiene nemmeno un evento.") }
      $doveDist = @(@($st.Dove) | Select-Object -Unique)
      if(@($doveDist).Count -gt 1){ [void]$motivi.Add("il campo 'letto da' cambia fra le righe (" + ($doveDist -join " / ") + "): sotto i piedi e' cambiato qualcosa durante la corsa.") }
      elseif(@($doveDist).Count -eq 1 -and $doveDist[0] -notlike "Common*"){
        [void]$motivi.Add("'letto da' e' '" + $doveDist[0] + "' invece di 'Common\Files': il ramo FILE_COMMON del fix v1.10 NON ha risposto (ha risposto il RIPIEGO sulla sandbox). A passata singola la sandbox basta a far girare l'EA, ma sugli agenti dell'ottimizzazione no: il fix va guardato.")
      }
      $rigDist = @(@($st.RigheFile) | Select-Object -Unique)
      if(@($rigDist).Count -gt 1){ [void]$motivi.Add("'righe' cambia fra le righe di log (" + ($rigDist -join ", ") + ").") }
      elseif(@($rigDist).Count -eq 1 -and [int]$rigDist[0] -ne $NRigheEventoPin){
        [void]$motivi.Add("l'EA dice 'righe " + $rigDist[0] + "' ma il file " + $NEWSFILE + " AL PIN ha " + $NRigheEventoPin + " righe evento: ha letto UN ALTRO calendario.")
      }
      $utiDist = @(@($st.Utili) | Select-Object -Unique)
      if(@($utiDist).Count -gt 1){ [void]$motivi.Add("'UTILI per questo preset' cambia fra le righe di log (" + ($utiDist -join ", ") + ").") }
      elseif(@($utiDist).Count -eq 1){
        if([int]$utiDist[0] -le 0){ [void]$motivi.Add("UTILI per questo preset = 0: calendario cieco PER QUESTA SEDIA.") }
        elseif([int]$utiDist[0] -ne $st.UtiliAttesi){ [void]$motivi.Add("UTILI letti = " + $utiDist[0] + ", ma ricontando il file AL PIN con i filtri di questo preset ne escono " + $st.UtiliAttesi + ": i filtri del preset e il file non stanno dicendo la stessa cosa.") }
      }
      # >>> la riga c'e' ma un campo non si estrae = il FORMATO e' cambiato.
      #     Senza questo ramo il verdetto uscirebbe verde con i campi vuoti.
      if(@($st.RigheNews).Count -gt 0){
        foreach($c in @(@{N="letto da"; V=$doveDist}, @{N="righe"; V=$rigDist}, @{N="UTILI per questo preset"; V=$utiDist})){
          if(@($c.V).Count -eq 0){ [void]$motivi.Add("la riga del canarino c'e' ma NON sono riuscito a leggerne il campo '" + $c.N + "': il formato della riga stampata dall'EA e' cambiato e questa riga va aggiornata a mano (non si legge un verdetto da un campo vuoto).") }
        }
      }
      if(@($st.AutoFalliti).Count -eq 0){ [void]$motivi.Add("nessuna riga '[PostNews][AUTOTEST] ---- fine: N casi falliti ----' trovata: il secondo canarino non si e' potuto leggere.") }
      elseif(@(@($st.AutoFalliti) | Where-Object { $_ -ne 0 }).Count -gt 0){ [void]$motivi.Add("l'autotest dell'EA riporta casi falliti diversi da 0 (" + ((@($st.AutoFalliti)) -join ", ") + "): il caso n.5 dell'autotest E' il calendario.") }

      if(@($motivi).Count -eq 0){
        $st.Verdetto = "CALENDARIO LETTO -- letto da " + $doveDist[0] + ", righe " + $rigDist[0] + " (= il file al pin), UTILI " + $utiDist[0] + " (= il conto rifatto qui), autotest 0 casi falliti, su " + @($st.RigheNews).Count + " righe di canarino tutte concordi."
        Dico ($s.Id + ": " + $st.Verdetto) "Green"
      } else {
        $st.Verdetto = "CALENDARIO CIECO / PROBLEMA -- " + ($motivi -join " | ")
        [void]$Problemi.Add("sedia " + $s.Id + ": " + $st.Verdetto)
        Dico ($s.Id + ": " + $st.Verdetto) "Red"
      }
      if($st.Ordini -le 0){
        [void]$Rilievi.Add("sedia " + $s.Id + ": ZERO righe '[PostNews] BUY/SELL STOP @' nei log (righe 'nessuna notizia nel CSV oggi': " + $st.NienteNews + "). NON e' un gate: l'EA puo' non piazzare per prezzo fuori range, stops level o lotto nullo. E' un RILIEVO, e va guardato solo dopo che il verdetto sul calendario e' verde.")
      } else {
        [void]$Rilievi.Add("sedia " + $s.Id + ": " + $st.Ordini + " ordini pendenti piazzati nella finestra (prova VIVA che NewsToday() ha agganciato la data dell'evento). Rilievo in piu', non il verdetto.")
      }
    }
  }
}
catch{
  $Fatale = ("" + $_.Exception.Message)
  Write-Host ""
  Write-Host ("!!! FERMATO: " + $Fatale) -ForegroundColor Red
}

# =====================================================================
#  RIPRISTINO -- SEMPRE, anche se il giro e' morto a meta' (classe 116).
#  Qui si tocca abtg_news.csv, che si chiama come il file del FORWARD:
#  si rimette com'era, o si rimuove se non c'era.
# =====================================================================
if(@($Backup.Keys).Count -gt 0){
  $fatti = New-Object System.Collections.ArrayList
  foreach($dest in @($Backup.Keys)){
    try{
      $back = $Backup[$dest]
      if($back -ne "" -and (Test-Path -LiteralPath $back)){
        Copy-Item -LiteralPath $back -Destination $dest -Force
        Remove-Item -LiteralPath $back -Force -ErrorAction SilentlyContinue
        [void]$fatti.Add((Split-Path -Leaf $dest) + " RIPRISTINATO dal backup")
      } else {
        Remove-Item -LiteralPath $dest -Force -ErrorAction SilentlyContinue
        [void]$fatti.Add((Split-Path -Leaf $dest) + " RIMOSSO (non c'era prima di questo giro)")
      }
    }
    catch{
      [void]$fatti.Add((Split-Path -Leaf $dest) + " RIPRISTINO FALLITO: " + $_.Exception.Message)
      [void]$Problemi.Add("RIPRISTINO FALLITO di " + $dest + ": controllalo a mano. La sentinella resta e il prossimo giro ci riprova.")
    }
  }
  $Ripristino = ($fatti -join " ; ")
  if(@($Problemi | Where-Object { $_ -like "RIPRISTINO FALLITO*" }).Count -eq 0){ Remove-Item -LiteralPath $Sentinella -Force -ErrorAction SilentlyContinue }
}
if($FotoPrese){
  try{
    foreach($t in @(@{N=("Experts\" + $EA + ".mq5"); A=$F1Prima; B=(Foto $TExpMq5); Atteso="SCRITTO (l'EA al pin: resta, come ogni EA della pipeline)"},
                    @{N=("Experts\" + $EA + ".ex5"); A=$F2Prima; B=(Foto $TExpEx5); Atteso="SCRITTO (compilato qui: resta, il tester lo richiede)"},
                    @{N=("Include\" + $INC);          A=$F3Prima; B=(Foto $TIncMqh); Atteso="INVARIATO (installato al pin e RIMESSO com'era)"},
                    @{N=("Common\Files\" + $NEWSFILE); A=$FCalCommonPrima; B=(Foto $CalCommon); Atteso="INVARIATO (installato al pin e RIMESSO com'era: si chiama come il file del forward)"},
                    @{N=("MQL5\Files\" + $NEWSFILE);   A=$FCalLocalePrima; B=(Foto $CalLocale); Atteso="INVARIATO (idem)"})){
      $stato = "INVARIATO"
      if($t.A.Esiste -ne $t.B.Esiste -or $t.A.Len -ne $t.B.Len){ $stato = "CAMBIATO" } elseif($t.A.Ora -ne $t.B.Ora){ $stato = "stessa dimensione, data diversa" }
      [void]$RigheFotoDopo.Add("  " + $t.N + ": prima [" + (FotoTxt $t.A) + "] dopo [" + (FotoTxt $t.B) + "] -> " + $stato + "   atteso: " + $t.Atteso)
      if(($t.N -like "Include*" -or $t.N -like "*" + $NEWSFILE) -and $stato -eq "CAMBIATO"){
        [void]$Problemi.Add("il file " + $t.N + " del terminale RISULTA CAMBIATO dopo il ripristino: controlla la foto prima/dopo e rimettilo a mano.")
      }
    }
  } catch { [void]$Problemi.Add("non ho potuto rifare la foto dei file del terminale: il ripristino resta DICHIARATO e non MISURATO.") }
  # DICHIARATO, non fotografato: ogni corsa vera del tester scrive
  # OptReport_POSTNEWSVER_<sedia>.htm nel terminale. Non e' un file che
  # questa riga tocchi in scrittura ne' che serva rileggere (il verdetto
  # sta nei log, non nel report ottimizzazione), ma resta LI' dopo il
  # giro: non viene ripulito. Dichiarato qui invece di lasciarlo un buco
  # silenzioso nella lista "cosa resta nel terminale".
  foreach($s in $SEDIE){ [void]$Rilievi.Add("il terminale conserva 'OptReport_POSTNEWSVER_" + $s.Id + ".htm' (report nativo del tester): non fotografato ne' ripulito da questa riga, dichiarato per completezza.") }
}

# =====================================================================
#  RACCOLTA -- SEMPRE, anche quando il giro si e' fermato a meta'.
# =====================================================================
Titolo "RACCOLTA"
$Cart = Join-Path $Dsk $ZipNome
if(Test-Path -LiteralPath $Cart){ Remove-Item -LiteralPath $Cart -Recurse -Force -ErrorAction SilentlyContinue }
New-Item -ItemType Directory -Force -Path $Cart | Out-Null

$REF = New-Object System.Collections.ArrayList
[void]$REF.Add("=====================================================================")
[void]$REF.Add(" POSTNEWS ECB+FOMC -- VERIFICA DEL CALENDARIO (" + $EA + " v" + $VERSIONE_ATTESA + ")")
[void]$REF.Add(" UNA domanda, binaria, per sedia: " + $NEWSFILE + " viene LETTO da Common\Files, si'")
[void]$REF.Add(" o no. NESSUN numero economico esce da qui (Optimization=0: niente CSV,")
[void]$REF.Add(" niente profitto, niente PF, niente DD, nessun giudizio di merito).")
[void]$REF.Add("=====================================================================")
[void]$REF.Add("modo: " + $Modo + "   <- CONTROLLO = giro a vuoto (MT5 NON viene aperto). Il verdetto vero esce SOLO da CORSA")
[void]$REF.Add("data: " + $Avvio.ToString("yyyy-MM-dd HH:mm:ss",$INV) + "   <- ORA DI AVVIO del giro (non l'ora in cui leggi)")
[void]$REF.Add("pin:  " + $Pin)
[void]$REF.Add("finestra: " + $DaQuando + " -> " + $Fino + " | Modello " + $Modello + " | @PERIODO " + $PERIODO + " | Deposit " + $Deposito + " | Leverage " + $Leva + " | Spread " + $Spread)
[void]$REF.Add("")
[void]$REF.Add("--- IL VERDETTO, UNO PER SEDIA (si legge questo, prima di tutto il resto) ---")
foreach($s in $SEDIE){
  [void]$REF.Add("  [" + $s.Id + "]  " + $s.Sym + " " + $PERIODO + "  magic " + $s.Magic + "  preset " + $s.Preset)
  [void]$REF.Add("      -> " + $Stato[$s.Id].Verdetto)
}
[void]$REF.Add("")
[void]$REF.Add("--- IL BANCO ---")
[void]$REF.Add("terminale: " + $TermTxt)
[void]$REF.Add("cartella dati: " + $(if($DataFolder -ne ""){ $DataFolder } else { "NON RISOLTA (il giro si e' fermato prima)" }))
[void]$REF.Add("compilazione: " + $Compilato)
[void]$REF.Add("riga Result del log: " + $ResultTxt)
[void]$REF.Add("versione letta dal #property: " + $VersTxt + "   (attesa " + $VERSIONE_ATTESA + ", quella del fix FILE_COMMON)")
[void]$REF.Add("autotest (ricalcolato dal sorgente): " + $AutotestTxt)
[void]$REF.Add("OnTester: " + $OnTesterTxt)
[void]$REF.Add("hedge-safe: " + $HedgeTxt)
[void]$REF.Add("include censiti nel sorgente: " + $IncTxt)
[void]$REF.Add("include al pin: " + $IncGuardia)
[void]$REF.Add("input dell'EA: " + $InputTxt)
[void]$REF.Add("InpNewsCommon: " + $NewsCommonTxt)
[void]$REF.Add("calendario al pin: " + $CalCsvTxt)
[void]$REF.Add("finestra: " + $FinestraTxt)
[void]$REF.Add("cache tester: " + $CacheTxt)
[void]$REF.Add("ripristino del terminale: " + $Ripristino)
[void]$REF.Add("foto PRIMA/DOPO dei file del terminale (la prova sta nella foto, non nella frase):")
if(@($RigheFotoDopo).Count -eq 0){ [void]$REF.Add("  NON PRESE: il giro si e' fermato prima di guardare il terminale, niente e' stato scritto") }
foreach($l in $RigheFotoDopo){ [void]$REF.Add($l) }
[void]$REF.Add("")
[void]$REF.Add("--- SEDIA PER SEDIA, I NUMERI GREZZI ---")
foreach($s in $SEDIE){
  $st = $Stato[$s.Id]
  [void]$REF.Add("  [" + $s.Id + "] " + $s.Sym + " magic " + $s.Magic)
  [void]$REF.Add("    preset: " + $st.Preset)
  [void]$REF.Add("    eventi utili nel calendario al pin (ricontati QUI con i filtri del preset): " + (FmtN $st.UtiliAttesi))
  [void]$REF.Add("    di cui DENTRO la finestra: " + (FmtN $st.InFinestra) + "   " + $st.DateFinestra)
  [void]$REF.Add("    ini: " + $st.Ini)
  [void]$REF.Add("    corsa: " + $st.Corsa + " | file .log nelle radici del TESTER prima: " + (FmtN $st.LogVisti) + " | cresciuti in questa corsa: " + (FmtN $st.LogNuovi))
  [void]$REF.Add("    canarino NEWS: " + $(if($st.Corsa -like "NON TENTATA*"){ "n/d (nessuna corsa)" } else { "" + @($st.RigheNews).Count + " righe" }) + " (una in OnInit + una per ogni giorno di test: l'EA ricarica il file quando cambia il giorno)")
  foreach($riga in @($st.RigheNews | Select-Object -First 4)){ [void]$REF.Add("      " + $riga) }
  if(@($st.RigheNews).Count -gt 4){ [void]$REF.Add("      ... (le altre in evidenza_" + $s.Id + ".txt)") }
  [void]$REF.Add("    letto da (valori distinti): " + $(if(@($st.Dove).Count -gt 0){ (@(@($st.Dove) | Select-Object -Unique) -join " / ") } else { "n/d" }) + "   <- atteso Common\Files: e' QUESTA la prova del fix")
  [void]$REF.Add("    righe del file (distinti): " + $(if(@($st.RigheFile).Count -gt 0){ (@(@($st.RigheFile) | Select-Object -Unique) -join " / ") } else { "n/d" }) + "   <- atteso " + (FmtN $NRigheEventoPin) + " (le righe evento del file al pin)")
  [void]$REF.Add("    UTILI per questo preset (distinti): " + $(if(@($st.Utili).Count -gt 0){ (@(@($st.Utili) | Select-Object -Unique) -join " / ") } else { "n/d" }) + "   <- atteso " + (FmtN $st.UtiliAttesi) + " (conto rifatto qui sul file al pin; NB: conta TUTTO il file, non la finestra)")
  [void]$REF.Add("    CALENDARIO CIECO: " + (FmtN $st.Cieco) + " | CANARINO ROSSO: " + (FmtN $st.Rosso) + "   (attesi 0 e 0)")
  [void]$REF.Add("    autotest 'casi falliti' (atteso 0 su ogni riga): " + $(if(@($st.AutoFalliti).Count -gt 0){ (@($st.AutoFalliti) -join ", ") } else { "nessuna riga trovata" }))
  [void]$REF.Add("    ordini pendenti piazzati [RILIEVO, mai un gate]: " + (FmtN $st.Ordini) + " | righe 'nessuna notizia nel CSV oggi': " + (FmtN $st.NienteNews))
}
[void]$REF.Add("")
[void]$REF.Add("--- COSA NON SI PUO' DIRE con questo referto ---")
[void]$REF.Add("  1. niente sul MERITO delle due sedie: qui non c'e' un solo numero economico (per costruzione).")
[void]$REF.Add("  2. 'il forward e' a posto': questa riga verifica i file AL PIN sul PC di BACKTEST. Che il VPS abbia")
[void]$REF.Add("     davvero quell'.ex5 e quei .set lo controlla Claudio quando ridistribuisce -- il forward non si tocca da qui.")
[void]$REF.Add("  3. 'UTILI>=1 quindi la finestra conteneva un evento': FALSO. 'UTILI' conta TUTTO il file. Gli eventi")
[void]$REF.Add("     dentro la finestra sono il numero 'di cui DENTRO la finestra', ed e' un gate SEPARATO, fatto prima di aprire MT5.")
[void]$REF.Add("  4. niente sugli orari: il preset FOMC in gennaio e' in configurazione ESTIVA (azione 19:40 server = 40 min")
[void]$REF.Add("     dopo la notizia invece di 10). Non tocca il canarino; toccherebbe un giudizio di merito, che qui non si da'.")
[void]$REF.Add("")
if($Fatale -ne ""){ [void]$REF.Add("!!! FERMATO: " + $Fatale); [void]$REF.Add("") }
[void]$REF.Add("PROBLEMI: " + $Problemi.Count)
foreach($p in $Problemi){ [void]$REF.Add("  - " + $p) }
[void]$REF.Add("RILIEVI: " + $Rilievi.Count)
foreach($p in $Rilievi){ [void]$REF.Add("  - " + $p) }
[void]$REF.Add("")
[void]$REF.Add("COME SI RIPRENDE: dalla pagina righe/RIGA_POSTNEWS_ECBFOMC_VERIFICA_DA_MANDARE.md,")
[void]$REF.Add("NON da questa riga: il pin nasce dentro il blocco e non sopravvive. Un giro morto a")
[void]$REF.Add("meta' si rilancia INTERO (non c'e' niente da riprendere a mano: il terminale e' gia' stato rimesso com'era).")

$refPath = Join-Path $Cart "REFERTO_POSTNEWS_ECBFOMC_VERIFICA.txt"
Set-Content -LiteralPath $refPath -Value ($REF -join "`r`n") -Encoding ASCII
Write-Host ($REF -join "`r`n")

if(Test-Path -LiteralPath $logC){
  Copy-Item -LiteralPath $logC -Destination $Cart -Force
  Set-Content -LiteralPath (Join-Path $Cart "COMPILAZIONE_leggibile.txt") -Value ((LeggiTesto $logC) -join "`r`n") -Encoding ASCII
}
foreach($s in $SEDIE){
  foreach($f in @((Join-Path $Work $s.Preset), (Join-Path $Work ("gen_POSTNEWSVER_" + $s.Id + ".ini")), (Join-Path $Work ("evidenza_" + $s.Id + ".txt")))){
    if(Test-Path -LiteralPath $f){ Copy-Item -LiteralPath $f -Destination $Cart -Force }
  }
}
if(Test-Path -LiteralPath (Join-Path $Work $NEWSFILE)){ Copy-Item -LiteralPath (Join-Path $Work $NEWSFILE) -Destination $Cart -Force }
foreach($f in @(Get-ChildItem -LiteralPath $Work -Filter "log_*.log" -ErrorAction SilentlyContinue | Where-Object { $_.LastWriteTime -ge $Avvio })){ Copy-Item -LiteralPath $f.FullName -Destination $Cart -Force }
$zip = $Cart + ".zip"
Remove-Item -LiteralPath $zip -Force -ErrorAction SilentlyContinue
Compress-Archive -Path (Join-Path $Cart "*") -DestinationPath $zip -Force
Write-Host ""
Write-Host ("CARTELLA: " + $Cart) -ForegroundColor Green
Write-Host ("ZIP DA MANDARE: " + $zip) -ForegroundColor Green
Write-Host ("FILE ATTESI NELLO ZIP: REFERTO_POSTNEWS_ECBFOMC_VERIFICA.txt + COMPILAZIONE.log (+ _leggibile.txt) + i due .set + i due gen_POSTNEWSVER_*.ini + " + $NEWSFILE + " + evidenza_*.txt + i log del tester cresciuti") -ForegroundColor Gray
Write-Host "IL VERDETTO E' IN CIMA AL REFERTO, UNO PER SEDIA: CALENDARIO LETTO oppure CALENDARIO CIECO/PROBLEMA." -ForegroundColor Gray

if($Fatale -ne ""){ Write-Host "ESITO: FERMATO" -ForegroundColor Red; exit 1 }
if($Problemi.Count -gt 0){ Write-Host "ESITO: COMPLETATO CON PROBLEMI" -ForegroundColor Yellow; exit 1 }
Write-Host ("ESITO: " + $Modo + " COMPLETATO") -ForegroundColor Green
exit 0
