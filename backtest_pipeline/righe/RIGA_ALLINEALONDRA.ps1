# =====================================================================
#  MARCATORE_RIGA_ALLINEALONDRA_v2
#  RIGA_ALLINEALONDRA.ps1  --  PASSO 0 DEL "MONEY MAKER EURUSD 15min"
# ---------------------------------------------------------------------
#  v2 (03/09/2026) -- la v1 era del 28/08, PRIMA delle classi 106-116
#  della CHECKLIST (corollario della classe 111: un driver nato prima di
#  una classe non viene toccato da quella classe se nessuno ci torna
#  sopra). Rilettura completa contro le classi nuove, sei correzioni:
#   94-ter  il campo 'compilazione:' aveva SOLO lo stato OK: sul ramo
#           fallito restava "NON TENTATA". Ora ha tre stati veri
#           (NON TENTATA / FALLITA / OK) timbrati sul ramo che decide.
#   108     il codice di uscita del driver generico era letto a due
#           stati ('$rc -ne 0'): su PS 5.1 un codice NON LETTO sarebbe
#           diventato "fallita". Ora tre stati (0 / N / NON LETTO), e
#           il verdetto lo danno gli ARTEFATTI (CSV freschi in corsa,
#           anteprima .ini fresca nel controllo).
#   115     il terminale era scelto per NOME ("*BCM Markets MT5
#           Terminal*"). Ora si scandisce LARGO (origin.txt + Program
#           Files + portable) e si sceglie per un FATTO (la cartella
#           dati con bases\*BCM*, cioe' il feed); con zero o due
#           candidati ci si ferma STAMPANDO L'ELENCO e la manopola
#           -Terminale. E il terminale scelto viene PASSATO al driver
#           generico (-Terminal/-MetaEditor/-DataFolder): stesso
#           terminale per costruzione, non per copia del selettore.
#   116     l'include veniva SCRITTO in MQL5\Include del terminale
#           senza backup e senza ripristino. Ora: sentinella PRIMA
#           della scrittura, backup in %USERPROFILE%\abtg_allinealondra\
#           backup\, ripristino a fine giro (anche nel giro fermato) e,
#           se un giro precedente e' stato interrotto a meta', il
#           ripristino avviene all'avvio del giro dopo ed e' DICHIARATO.
#           Foto PRIMA/DOPO dei tre file del terminale nel referto.
#   116-bis il Desktop era "%USERPROFILE%\Desktop" secco: con OneDrive
#           lo zip finiva in una cartella che Claudio non vede. Ora si
#           CERCA (GetFolderPath, poi i due ripieghi), e la riga di chat
#           lo cerca nello stesso modo.
#   106/23  AUTOTEST_ALLINEALONDRA.txt e COMPILAZIONE_FALLITA.log di un
#           giro PRECEDENTE restavano in %USERPROFILE%\abtg_allinealondra
#           e finivano nello zip di OGGI: ora si cancellano all'avvio.
#  Nessun criterio di lettura e' cambiato. I file prova sono gli stessi.
#  ABTG_AllineaLondra  su  EURUSD  M15,  QUATTRO CELLE,  DUE BANCHI:
#     00_finestra    baseline, finestra ACCESA      magic 777600/777601
#     01_nofinestra  ABLAZIONE: finestra SPENTA     magic 777610/777611
#     02_long        solo long                      magic 777620/777621
#     03_short       solo short                     magic 777630/777631
# ---------------------------------------------------------------------
#  QUESTO NON E' UN ROUND E NON DA' NESSUN VERDETTO.
#  E' il PASSO 0 del candidato P2 della caccia intraday forex/oro del
#  28/08/2026 (caccia_strategie\CACCIA_INTRADAY_FOREX_ORO_2026-08-28.md,
#  scheda P2, voto 7/10). Si misura QUANTE OPERAZIONI produce il motore
#  PRIMA di qualunque lettura di merito: valvola R59, Emendamento della
#  finestra regola A ("l'unita' di misura e' l'OPERAZIONE, non l'anno").
#  Il PF che esce dal CSV si LEGGE ma NON si giudica: non ci sono
#  criteri di merito firmati e quattro celle non sono un round.
#
#  L'IPOTESI, i tre esiti A/B/C e le avvertenze di banco stanno scritti
#  UNA VOLTA SOLA in testa a
#  prove\PASSO0_ALLINEALONDRA_00_finestra.txt e NON si riscrivono qui:
#  un criterio ricopiato in cinque posti e' un criterio che prima o poi
#  diverge.
#
#  ------------------------------------------------------------------
#  L'ASSE PRINCIPALE E' LA CELLA DI ABLAZIONE, e vale l'intero giro.
#  Il dossier dichiara l'adiacenza concettuale con ABTG_SuperWave,
#  ABTG_CrossEma e ABTG_GoldenCross (sono tutti motori di allineamento
#  di medie) e ne fa il carico della prova: "la differenza e' il
#  CONTENITORE (sessione + flat + tetto), non il segnale". La cella
#  01_nofinestra spegne InpUsaFinestraSessione e cambia SOLO quello.
#  Se il nudo va uguale, la sessione non serve e il candidato e' un
#  doppione; se il nudo crolla, il contenitore E' il motore.
#
#  >>> E LA DIFFERENZA NON E' UN COSTO PURO (CHECKLIST punto 97-bis).
#      Con la finestra spenta il TETTO di 2 ingressi al giorno resta
#      acceso, quindi il motore non opera "distribuito su tutto il
#      giorno": prende i primi due segnali dopo il cambio di giornata
#      del server. Su un allineamento di medie -- che e' uno STATO e
#      resta vero per molte barre -- quei due ingressi cadono
#      tipicamente subito dopo le 00:00 SERVER. L'ablazione misura
#      quindi un PACCHETTO: (finestra rimossa) + (ancoraggio a
#      mezzanotte). Il referto lo scrive ACCANTO al numero, non in
#      fondo.
#  ------------------------------------------------------------------
#
#  DUE BANCHI, dichiarati -- e sono due domande diverse, non due
#  versioni della stessa:
#    S  modello 1 (OHLC M1)    2022.07.01 -> 2026.06.30   il CAMPIONE
#    V  modello 4 (TICK REALI) 2024.07.05 -> 2026.06.30   il RIEMPIMENTO
#
#   - la finestra del banco S (4 anni) e' DERIVATA dal tetto delle
#     ~100.000 barre del tester, non misurata: a M15 sono circa 4 anni
#     (stessa convenzione e stessa data di R108, riga 224). EURUSD ha
#     storico molto piu' lungo (pavimento gennaio 1999, R102), quindi
#     il vincolo qui e' il TESTER, non il broker;
#   - la finestra del banco V parte dal 2024.07.05 perche' i TICK REALI
#     di BCM partono da li' (misurato su GBPUSD, R58/R72; su EURUSD e'
#     INFERITO per analogia, NON misurato). Regola di casa gia' scritta:
#     "o la finestra lunga o il riempimento vero, mai tutti e due";
#   - il banco S da solo NON autorizza nessuna proposta: e' il driver
#     generico stesso a scriverlo ("1 = OHLC M1: SOLO screening, mai
#     verdetti"). Serve al CONTEGGIO, che e' l'oggetto del PASSO 0.
#  Split IS/OOS 40/60 del driver generico -> quattro sotto-finestre per
#  cella.
#
#  ------------------------------------------------------------------
#  PERCHE' ESISTE QUESTO FILE invece di otto righe di
#  walkforward_generico.ps1 incollate a mano. Quattro motivi:
#
#   1. L'INCLUDE. ABTG_AllineaLondra.mq5 fa
#        #include <ABTG_PausaGuardian.mqh>
#      e walkforward_generico.ps1 NON lo installa (verificato: nel
#      driver generico la stringa 'PausaGuardian' non compare). Se quel
#      file non e' gia' in MQL5\Include la compilazione fallisce, e il
#      driver generico muore con "compilazione fallita" senza dire
#      perche'. Qui l'include si scarica al pin e si copia PRIMA di
#      compilare, e la copia si verifica sul CONTENUTO, non sul nome.
#
#   2. LA COMPILAZIONE. ABTG_AllineaLondra.mq5 NON E' MAI STATO
#      COMPILATO DA NESSUNO (scritto il 28/08 in un ambiente senza
#      MetaEditor). Il giro di controllo COMPILA DAVVERO: e' il primo
#      risultato vero di questo PASSO 0, e costa un minuto invece di
#      scoprirlo dopo ore di tester.
#
#   3. I GATE SUL PERIMETRO. Il driver generico controlla il FORMATO,
#      non il PERIMETRO: non sa che le quattro celle devono differire
#      di DUE righe sole, non sa quali magic sono vietati, non sa che
#      @PERIODO deve essere M15, e non sa che una riga con quattro
#      campi (Nome=1||||||N) viene riscritta storta e MT5 la ignora in
#      silenzio. Qui si controlla tutto PRIMA di aprire MT5.
#
#   4. LA RACCOLTA. Regola di casa (CLAUDE.md, righe di lancio punto 2):
#      a fine test i risultati finiscono in una cartella sul Desktop e
#      in uno zip pronto da mandare. Sempre, anche a corsa fermata.
#  ------------------------------------------------------------------
#
#  IL REFERTO E' SEMPRE D'INSIEME, anche con -SoloCella.
#  L'ablazione e' un criterio DI INSIEME (serve il 00 E il 01): un
#  referto che leggesse solo le celle di QUESTO giro non potrebbe mai
#  adjudicarla (CHECKLIST punto 101). Percio' la riga, dopo le corse,
#  RILEGGE i CSV di TUTTE le celle e di TUTTI i banchi che trova gia'
#  sul disco, e li marca come "RILETTA": il confronto 00 contro 01 esce
#  anche se le due celle sono state girate in due serate diverse.
#  ATTENZIONE, ed e' scritto anche nella pagina: se il PIN CAMBIA la
#  cache viene CANCELLATA e le celle gia' girate sono perse.
#
#  QUELLO CHE NON FA, dichiarato:
#   - NON GIUDICA e NON PROMUOVE niente. Conta le operazioni e mette il
#     numero accanto alla soglia dei 150 dell'Emendamento regola A.
#   - NON tocca nessuna sedia viva. Gli otto magic sono VERGINI (blocco
#     7776xx, cercati uno per uno in tutto il repo il 28/08/2026: zero
#     occorrenze fuori dal default del sorgente), e il driver generico
#     scrive AllowLiveTrading=false in ogni .ini.
#   - NON scarica storico e non misura la profondita' del feed. Il
#     2024.07.05 del banco V e' INFERITO da GBPUSD, non misurato su
#     EURUSD; il 2022.07.01 del banco S e' DERIVATO dal tetto delle
#     100.000 barre, non misurato. Se il tester parte piu' tardi della
#     data dichiarata, la finestra REALE e' piu' corta di quella
#     nominale: e' un caveat, non un gate, e sta nel referto.
#   - NON misura lo spread di BCM su EURUSD e non converte punti.
#   - non scrive una riga di MQL5.
#
#  QUANTO CI METTE [STIMA, non una previsione]: 4 celle x 2 banchi x 2
#  finestre x 2 gemelle = 32 passate. Meta' sono OHLC M1 su 4 anni di
#  M15 (veloci), meta' tick reali su 24 mesi. R107 fece 24 passate a
#  tick reali su 21 mesi di M15 in 9 minuti. Stima 30-90 minuti piu' la
#  compilazione. Non e' una promessa: su EURUSD a tick reali il numero
#  di tick non e' agli atti.
#
#  LA RIGA CHE SI INCOLLA sta in righe\RIGA_ALLINEALONDRA_DA_MANDARE.md
#  ed e' l'UNICO posto in cui esiste (CHECKLIST punto 100).
# =====================================================================
[CmdletBinding()]
param(
  # -Pin NON ha default: un default silenzioso ("lavoro") farebbe girare
  #  la punta del branch spacciandola per un commit congelato.
  [string]$Pin           = "",
  [switch]$SoloControllo,          # giro a vuoto: NON apre il tester (ma COMPILA)
  [switch]$Rifai,                  # rifa' anche i CSV gia' presenti
  [string]$SoloCella     = "",     # 00_finestra | 01_nofinestra | 02_long | 03_short
  [string]$SoloBanco     = "",     # S (OHLC screening) | V (tick reali)
  [string]$Simbolo       = "EURUSD",
  [string]$Periodo       = "M15",
  [string]$DaScreening   = "2022.07.01",   # banco S: DERIVATO dal tetto delle 100.000 barre
  [string]$DaTick        = "2024.07.05",   # banco V: INFERITO da GBPUSD, NON misurato su EURUSD
  [string]$Fino          = "2026.06.30",
  [int]$Deposito         = 100000,
  # -Terminale: si usa SOLO se la scelta automatica si ferma perche' non
  #  ha un FATTO per decidere (classe 115). La riga stampa l'elenco delle
  #  installazioni trovate e il percorso da incollare qui (la cartella
  #  che contiene terminal64.exe).
  [string]$Terminale     = ""
)
$ErrorActionPreference = "Stop"
[Threading.Thread]::CurrentThread.CurrentCulture   = [Globalization.CultureInfo]::InvariantCulture
[Threading.Thread]::CurrentThread.CurrentUICulture = [Globalization.CultureInfo]::InvariantCulture
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$INV = [Globalization.CultureInfo]::InvariantCulture

$EA     = "ABTG_AllineaLondra"
$Avvio  = Get-Date
$Stamp  = $Avvio.ToString("yyyyMMdd_HHmm", $INV)
# IL DESKTOP SI CERCA, NON SI ASSUME (classe 116-bis): con OneDrive il
# Desktop vero non e' %USERPROFILE%\Desktop, e una New-Item -Force ne
# creerebbe uno finto in cui Claudio non troverebbe mai lo zip. La riga
# di chat lo cerca con le STESSE tre righe.
function TrovaDesktop(){
  foreach($p in @([Environment]::GetFolderPath("Desktop"),
                  (Join-Path $env:USERPROFILE "Desktop"),
                  (Join-Path $env:USERPROFILE "OneDrive\Desktop"))){
    if($p -and (Test-Path -LiteralPath $p)){ return $p }
  }
  return $env:USERPROFILE
}
$Dsk    = TrovaDesktop
$Work   = Join-Path $env:USERPROFILE "abtg_allinealondra"
$Prove  = Join-Path $Work "prove"
$BackupDir  = Join-Path $Work "backup"
$Sentinella = Join-Path $Work "INCLUDE_IN_CORSO.txt"
$IncNostro  = "ABTG_PausaGuardian.mqh"
$RawPin = "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$Pin"

# GLI ARTEFATTI PER-GIRO DI UN GIRO PRECEDENTE SI TOLGONO ALL'AVVIO
# (classi 23/106): AUTOTEST_ALLINEALONDRA.txt e COMPILAZIONE_FALLITA.log
# si scrivono solo quando c'e' qualcosa da scrivere, quindi una copia
# vecchia rimasta qui finirebbe nello zip di OGGI e racconterebbe un
# fatto di ieri. Lo zip di ieri li ha gia', sul Desktop.
foreach($vecchioF in @("AUTOTEST_ALLINEALONDRA.txt","COMPILAZIONE_FALLITA.log")){
  Remove-Item -LiteralPath (Join-Path $Work $vecchioF) -Force -ErrorAction SilentlyContinue
}

# --- I VALORI DICHIARATI, contro cui i gate confrontano i file prova.
#     NON si confronta col PARAMETRO che serve ad accorciare la
#     finestra: sarebbe il difetto 96-bis (la via d'uscita sbarrata dal
#     guardiano della porta accanto). Se -DaScreening viene mosso, il
#     gate non salta: degrada a RILIEVO.
$DaScreeningDichiarato = "2022.07.01"
$SimboloDichiarato     = "EURUSD"
$PeriodoDichiarato     = "M15"

# --- TUTTO CIO' CHE LA RACCOLTA USA NASCE QUI, PRIMA DEL try.
#     In PowerShell una `function` non e' dichiarativa, e' un'ISTRUZIONE:
#     se il flusso non ci passa sopra il nome non esiste, e la raccolta
#     esploderebbe proprio nella corsa fermata da un gate, cioe' l'unica
#     in cui il referto serve davvero.
$Problemi  = New-Object System.Collections.ArrayList
$Rilievi   = New-Object System.Collections.ArrayList
$Fatale    = ""
$Include   = "NON INSTALLATO"
$TermScelto = "NON SCELTO"
$TermCrit   = "n/d"
$DataFolder = ""
$Compilato = "NON TENTATA"
$Autotest  = @()
# --- lo stato dell'include nel terminale (classe 116): la sentinella
#     si scrive PRIMA di toccare il terminale, il ripristino gira nella
#     RACCOLTA (sempre) e, se il giro muore a meta', all'avvio del giro
#     dopo.
$IncInstallato = $false      # questo giro ha SCRITTO l'include nel terminale
$IncBackup     = ""          # dove sta la copia del file che c'era prima ("" = non c'era)
$IncDest       = ""          # il percorso nel terminale
$IncEsito      = "NON TOCCATO"
$Ripristino    = "NON NECESSARIO"
$FotoPrima     = @{}
$FotoDopo      = @{}
$Fine          = $null

# FOTO di un file del terminale (classe 116, regola 2: la prova sta
# nella foto, non nella frase). Si prende PRIMA e si RIFA' DOPO.
function Foto([string]$percorso){
  if($percorso -eq "" -or $null -eq $percorso){ return "ASSENTE" }
  if(-not (Test-Path -LiteralPath $percorso)){ return "ASSENTE" }
  $i = Get-Item -LiteralPath $percorso
  return ("presente, " + $i.Length + " byte, " + $i.LastWriteTime.ToString("yyyy-MM-dd HH:mm:ss",$INV))
}
function HashFile([string]$percorso){
  if(-not (Test-Path -LiteralPath $percorso)){ return "" }
  try{ return (Get-FileHash -LiteralPath $percorso -Algorithm SHA256).Hash }catch{ return "" }
}
# RIPRISTINO DELL'INCLUDE nel terminale: rimette il backup se c'era un
# file prima, toglie il nostro se non c'era. Torna una frase per il
# referto. NON lancia mai: si chiama anche dalla raccolta di un giro
# fermato, e li' un'eccezione farebbe perdere il referto.
function RipristinaInclude([string]$dest,[string]$backup){
  try{
    if($dest -eq "" -or -not (Test-Path -LiteralPath $dest)){ return "niente da ripristinare (il file nostro non c'e' piu')" }
    if($backup -ne "" -and (Test-Path -LiteralPath $backup)){
      Copy-Item -LiteralPath $backup -Destination $dest -Force
      return ("RIPRISTINATO dal backup " + $backup)
    }
    Remove-Item -LiteralPath $dest -Force
    return "RIMOSSO (prima di questo giro non c'era)"
  }catch{ return ("RIPRISTINO FALLITO: " + $_.Exception.Message + " -- il file nostro e' ancora in " + $dest) }
}

$Modo = "CORSA"
if($SoloControllo){ $Modo = "CONTROLLO" }

function Ora(){ return (Get-Date).ToString("HH:mm:ss", $INV) }
function Dico([string]$testo,[string]$colore="Gray"){ Write-Host ("[" + (Ora) + "] " + $testo) -ForegroundColor $colore }
function Titolo([string]$testo){ Write-Host ""; Write-Host ("=== " + $testo + " ===") -ForegroundColor Cyan }

function Scarica([string]$url,[string]$dest){
  Remove-Item -LiteralPath $dest -Force -ErrorAction SilentlyContinue
  Invoke-WebRequest -Uri $url -OutFile $dest -UseBasicParsing -ErrorAction Stop
  if(-not (Test-Path -LiteralPath $dest)){ throw ("scarico fallito: " + $url) }
}

function RigheVive([string]$percorso){
  return @(Get-Content -LiteralPath $percorso | Where-Object { $_ -notmatch '^\s*#' -and $_ -notmatch '^\s*$' })
}

function NumInv($testo){
  $valore = 0.0
  $ripulito = ("" + $testo).Replace([string][char]160,"").Replace(" ","").Trim()
  if($ripulito -eq ""){ return $null }
  if([double]::TryParse($ripulito,[Globalization.NumberStyles]::Float,$INV,[ref]$valore)){ return $valore }
  return $null
}

# --- LA CONVENZIONE DI SENTINELLA. Un numero non misurato non deve MAI
#     uscire come numero plausibile: in R103 il PF non misurato usciva
#     "0.000", che si legge "ha perso tutto". Qui esce "n/d".
# FmtN: CONTEGGI. Non esiste un conteggio negativo -> il negativo e' la
#   sentinella e deve uscire "n/d", non "-1".
function FmtN($valore){ if($null -eq $valore){ return "n/d" }; if([int]$valore -lt 0){ return "n/d" }; return ([int]$valore).ToString($INV) }
# Fmt2: GRANDEZZE NON NEGATIVE PER COSTRUZIONE (PF, DD%).
function Fmt2($valore){ if($null -eq $valore){ return "n/d" }; if([double]$valore -lt 0){ return "n/d" }; return ([double]$valore).ToString("0.00",$INV) }
# FmtE: PROFITTO. Qui il negativo e' un RISULTATO, non una sentinella:
#   la sentinella e' -999999 e solo quella diventa "n/d".
function FmtE($valore){ if($null -eq $valore){ return "n/d" }; if([double]$valore -le -999998.0){ return "n/d" }; return ([double]$valore).ToString("+0;-0;0",$INV) }
# FmtPg: PEGGIOR GIORNATA %. E' negativa SEMPRE (o zero): il negativo
#   non si tocca, la sentinella e' +99.
function FmtPg($valore){ if($null -eq $valore){ return "n/d" }; if([double]$valore -ge 99.0){ return "n/d" }; return ([double]$valore).ToString("0.00",$INV) }

# =====================================================================
#  IL PARSER DEL CSV DI OTTIMIZZAZIONE.
#  Le colonne si cercano PER NOME, mai per posizione (punto 58). Se non
#  le riconosce torna $null E DICE quali intestazioni ha visto, invece
#  di indovinare: una colonna che questa famiglia NON esporta non deve
#  diventare un sentinella "onesto" che camuffa un criterio impossibile
#  (punto 80). L'intestazione VERA di questo EA, LETTA NEL SORGENTE
#  (OnTesterDeinit, 'string head = ...'), e' a 29 colonne piu' quelle
#  dei parametri spazzolati.
# =====================================================================
$script:CsvIntestazioni = @()
$ColonneObbligatorie = @("Profit","Profit Factor","Equity DD %","Trades",
                         "Peggior Giornata %","Ingressi Totali","Ingressi Long",
                         "Ingressi Short","Uscite Flat","Uscite Stop O Take",
                         "Notti Attraversate","Lotti Al Minimo",
                         "Ingressi Saltati Spread","Giorni Tetto Bloccante",
                         "Parziali Eseguite","Breakeven Eseguiti",
                         "Finestra Sessione","Minuto Inizio Sessione",
                         "Minuto Fine Ingressi","Minuto Fine Sessione",
                         "Flat Anticipo Min","Minuto Flat Calcolato",
                         "Autotest Falliti","Barre Allineate")

function LeggiOpt([string]$percorso){
  # AZZERARE QUI NON E' PULIZIA, E' UN GATE: senza, un CSV MANCANTE
  # lascerebbe in piedi le intestazioni dell'ULTIMO file letto bene, e
  # il referto elencherebbe colonne che in quella cella nessuno ha mai
  # visto -- un valore vecchio che racconta un fatto mai accaduto.
  $script:CsvIntestazioni = @()
  if(-not (Test-Path -LiteralPath $percorso)){ return $null }
  $righeCsv = @()
  try{ $righeCsv = @(Import-Csv -LiteralPath $percorso) }catch{ return $null }
  if($righeCsv.Count -eq 0){ return $null }
  $colonne = @($righeCsv[0].PSObject.Properties.Name)
  $script:CsvIntestazioni = $colonne
  foreach($nomeCol in $ColonneObbligatorie){
    if(-not ($colonne -contains $nomeCol)){ return $null }
  }
  $uscita = New-Object System.Collections.ArrayList
  foreach($rigaCsv in $righeCsv){
    [void]$uscita.Add([pscustomobject]@{
      Profit   = (NumInv $rigaCsv."Profit")
      Pf       = (NumInv $rigaCsv."Profit Factor")
      Dd       = (NumInv $rigaCsv."Equity DD %")
      N        = (NumInv $rigaCsv."Trades")
      Pg       = (NumInv $rigaCsv."Peggior Giornata %")
      IngTot   = (NumInv $rigaCsv."Ingressi Totali")
      IngLong  = (NumInv $rigaCsv."Ingressi Long")
      IngShort = (NumInv $rigaCsv."Ingressi Short")
      UscFlat  = (NumInv $rigaCsv."Uscite Flat")
      UscMerc  = (NumInv $rigaCsv."Uscite Stop O Take")
      Notti    = (NumInv $rigaCsv."Notti Attraversate")
      LotMin   = (NumInv $rigaCsv."Lotti Al Minimo")
      SprSalt  = (NumInv $rigaCsv."Ingressi Saltati Spread")
      Tetto    = (NumInv $rigaCsv."Giorni Tetto Bloccante")
      Parz     = (NumInv $rigaCsv."Parziali Eseguite")
      Beven    = (NumInv $rigaCsv."Breakeven Eseguiti")
      Finestra = (NumInv $rigaCsv."Finestra Sessione")
      MinIni   = (NumInv $rigaCsv."Minuto Inizio Sessione")
      MinIng   = (NumInv $rigaCsv."Minuto Fine Ingressi")
      MinFine  = (NumInv $rigaCsv."Minuto Fine Sessione")
      FlatAnt  = (NumInv $rigaCsv."Flat Anticipo Min")
      MinFlat  = (NumInv $rigaCsv."Minuto Flat Calcolato")
      AutoFail = (NumInv $rigaCsv."Autotest Falliti")
      Allin    = (NumInv $rigaCsv."Barre Allineate")
    })
  }
  return @($uscita)
}

# --- I GEMELLI: le due righe devono essere IDENTICHE AL CENTESIMO.
#     E' l'unico controllo d'igiene del banco, ed e' il motivo per cui
#     l'unico asse spazzolato e' InpMagic.
#     "Una riga sola" NON e' "gemelli ok": e' uno sweep che non ha
#     spazzolato, e va detto come tale.
$TolGemelli = 0.005
function Gemelli($righeLette){
  if($null -eq $righeLette){ return "NON MISURATO (CSV non letto)" }
  if(@($righeLette).Count -ne 2){ return ("NON VALIDO: " + @($righeLette).Count + " righe invece di 2") }
  $primo = $righeLette[0]; $secondo = $righeLette[1]
  # DUE CORSE VUOTE SONO IDENTICHE PER COSTRUZIONE: zero contro zero non
  # e' "banco deterministico", e' "banco che non ha misurato niente"
  # (CHECKLIST punto 93: la sentinella e' onesta quando la si STAMPA e
  # bugiarda quando la si CONFRONTA).
  if($null -eq $primo.N -or $null -eq $secondo.N){ return "NON MISURATO (numero operazioni illeggibile)" }
  if([double]$primo.N -le 0 -and [double]$secondo.N -le 0){
    return "NON MISURATO (ZERO operazioni in tutte e due le passate: due corse vuote escono identiche per costruzione e non dicono niente sul determinismo)"
  }
  foreach($confronto in @(@("profitto",$primo.Profit,$secondo.Profit),
                          @("PF",$primo.Pf,$secondo.Pf),
                          @("DD",$primo.Dd,$secondo.Dd),
                          @("operazioni",$primo.N,$secondo.N),
                          @("ingressi totali",$primo.IngTot,$secondo.IngTot))){
    if($null -eq $confronto[1] -or $null -eq $confronto[2]){ return ("NON MISURATO (" + $confronto[0] + " illeggibile)") }
    if([math]::Abs([double]$confronto[1] - [double]$confronto[2]) -gt $TolGemelli){
      return ("DIVERSI su " + $confronto[0] + ": " + $confronto[1] + " contro " + $confronto[2])
    }
  }
  return "IDENTICI"
}

# =====================================================================
#  I DUE BANCHI
# =====================================================================
function B([string]$idb,[int]$modb,[string]$dab,[string]$descb){
  return [pscustomobject]@{ Id=$idb; Modello=$modb; Da=$dab; Desc=$descb }
}
$BANCHI = @()
$BANCHI += (B "S" 1 $DaScreening "OHLC M1 -- SOLO SCREENING, mai un verdetto. E' il CAMPIONE: 4 anni, due regimi (crollo 2022, risalita 2023-2025)")
$BANCHI += (B "V" 4 $DaTick      "TICK REALI -- il RIEMPIMENTO vero (spread e fill del feed), ma finestra corta e un regime solo")

# =====================================================================
#  LE QUATTRO CELLE.
#  'Diff' = gli input che DEVONO differire dal 00_finestra, e NESSUN
#           ALTRO. Contare "due righe diverse" non basterebbe: DUE righe
#           SBAGLIATE darebbero lo stesso conteggio.
#  'Val'  = quanto DEVONO valere gli interruttori IN QUESTO FILE, in
#           valore ASSOLUTO. Prende i due casi che il diff non puo'
#           vedere: due file SCAMBIATI, e la riga storta UGUALE in tutte
#           le celle (lezione R110: un diff fra A e B non puo'
#           accorgersi di niente che sia uguale in A e in B).
#  'FinestraAttesa' = il valore che la colonna "Finestra Sessione" deve
#           avere nel CSV. E' il gate del punto 52: dimostra che
#           l'interruttore dell'ablazione e' arrivato DAVVERO dentro il
#           tester, invece di essere reso inerte da un default.
# =====================================================================
# ATTENZIONE ai nomi dei parametri di questa funzione: NON si chiamano
# $celle ne' $banchi. In PowerShell le variabili sono CASE-INSENSITIVE
# (punto 79), e $celle sarebbe LA STESSA variabile di $CELLE.
function C([string]$idc,[string]$filec,[string]$descc,[int]$mag1,[int]$mag2,
          [int]$finAttesa,[int]$flatAtteso,$diffc,$valc){
  return [pscustomobject]@{
    Id=$idc; Prova=$filec; Desc=$descc; M1=$mag1; M2=$mag2
    FinestraAttesa=$finAttesa; FlatAtteso=$flatAtteso
    Diff=@($diffc); Val=$valc
    Ris=@{} }
}
$CELLE = @()
$CELLE += (C "00_finestra"   "PASSO0_ALLINEALONDRA_00_finestra.txt" `
              "BASELINE -- finestra ACCESA 03:00-08:45, flat 10:30, due lati insieme" 777600 777601 1 630 @() `
              @{ "InpUsaFinestraSessione"="1"; "InpAllowLong"="1"; "InpAllowShort"="1" })
$CELLE += (C "01_nofinestra" "PASSO0_ALLINEALONDRA_01_nofinestra.txt" `
              "ABLAZIONE -- finestra SPENTA (flat a fine giornata 23:44). E' L'ASSE DEL ROUND" 777610 777611 0 1424 @("InpUsaFinestraSessione") `
              @{ "InpUsaFinestraSessione"="0"; "InpAllowLong"="1"; "InpAllowShort"="1" })
$CELLE += (C "02_long"       "PASSO0_ALLINEALONDRA_02_long.txt" `
              "SOLO LONG -- la frequenza PROPRIA del lato long (slot e tetto liberi)" 777620 777621 1 630 @("InpAllowShort") `
              @{ "InpUsaFinestraSessione"="1"; "InpAllowLong"="1"; "InpAllowShort"="0" })
$CELLE += (C "03_short"      "PASSO0_ALLINEALONDRA_03_short.txt" `
              "SOLO SHORT -- la frequenza PROPRIA del lato short" 777630 777631 1 630 @("InpAllowLong") `
              @{ "InpUsaFinestraSessione"="1"; "InpAllowLong"="0"; "InpAllowShort"="1" })

# --- LA BASELINE ASSOLUTA: i valori che TUTTI E QUATTRO i file prova
#     devono pinnare, identici. Si confronta con QUESTI, dichiarati nel
#     driver, e non con un file gemello: una corruzione SIMMETRICA (la
#     stessa riga storta in tutti e quattro) passerebbe un diff a mani
#     basse (lezione R108/R110).
$Baseline = [ordered]@{
  "InpSmma1"           = "3"
  "InpSmma2"           = "6"
  "InpSmma3"           = "9"
  "InpSmma4"           = "50"
  "InpEmaLenta"        = "200"
  "InpSessStartHour"   = "3"
  "InpSessStartMin"    = "0"
  "InpEntryEndHour"    = "8"
  "InpEntryEndMin"     = "45"
  "InpSessEndHour"     = "10"
  "InpSessEndMin"      = "45"
  "InpFlatAnticipoMin" = "15"
  "InpMaxTradesDay"    = "2"
  "InpMaxPositions"    = "1"
  "InpAtrPeriod"       = "14"
  "InpAtrSLmult"       = "1.5"
  "InpTP1_R"           = "1.0"
  "InpTP1Pct"          = "50.0"
  "InpBreakeven"       = "1"
  "InpTPfinal_R"       = "2.0"
  "InpUseTrailing"     = "0"
  "InpTrailAtrMult"    = "2.0"
  "InpRiskPercent"     = "0.65"
  "InpMaxSpread"       = "0"
  "InpMaxSpreadPctSL"  = "0.0"
  "InpUsaGuardian"     = "0"
  "InpVerbose"         = "1"
  "InpAutoTest"        = "1"
}

# --- L'ELENCO CHIUSO DEI PARAMETRI AMMESSI in un file prova di questo
#     PASSO 0. Serve a una cosa sola, ed e' LA cosa: impedire che entri
#     una GRIGLIA. Un nome fuori da questa lista ferma tutto, anche se
#     l'EA quel parametro ce l'ha. In particolare NON ci sono qui le
#     cinque lunghezze delle medie come assi: sono CONGELATE (baseline).
$ParametriAmmessi = @("InpSmma1","InpSmma2","InpSmma3","InpSmma4","InpEmaLenta",
                      "InpAllowLong","InpAllowShort","InpUsaFinestraSessione",
                      "InpSessStartHour","InpSessStartMin","InpEntryEndHour",
                      "InpEntryEndMin","InpSessEndHour","InpSessEndMin",
                      "InpFlatAnticipoMin","InpMaxTradesDay","InpMaxPositions",
                      "InpAtrPeriod","InpAtrSLmult","InpTP1_R","InpTP1Pct",
                      "InpBreakeven","InpTPfinal_R","InpUseTrailing","InpTrailAtrMult",
                      "InpRiskPercent","InpMaxSpread","InpMaxSpreadPctSL",
                      "InpUsaGuardian","InpVerbose","InpAutoTest","InpMagic")

# --- I MAGIC VIETATI: il magic del SORGENTE non e' fra questi (777600
#     E' il default del sorgente ed e' quello della cella baseline: e'
#     voluto, il blocco 7776xx e' vergine per intero). Qui ci sono le
#     sedie vive e i blocchi dei PASSO 0 e dei round recenti: un'identita'
#     non in campo resta comunque occupata.
$MagicVietati = @(
  775501, 776000,776001, 776100,776101, 776200,776201, 776400,776401,
  773400,773401, 773410,773411, 773420,773421, 773430,773431,
  777201,777202,777203,777204,777205,777206, 777290,777291,
  778000,778001, 778100,778101, 778300,778301, 778400,778401, 778500,778501,
  763000,763010,763020,763100,763110,763120,
  763200,763210,763220,763300,763310,763320,
  773200,773201,773230,773231,773300,773301,
  770101,770202,770411,770511,770611,770801,770901,
  770921,770922,770923,770924,770925,
  771001,771501,771511,771531,
  970901,970911,970912,970913,970914,970915,970916,971001)

$Ordinate = @($CELLE)
if($SoloCella -ne ""){ $Ordinate = @($CELLE | Where-Object { $_.Id -eq $SoloCella }) }
$BanchiDaFare = @($BANCHI)
if($SoloBanco -ne ""){ $BanchiDaFare = @($BANCHI | Where-Object { $_.Id -eq $SoloBanco }) }

try{
  Titolo ("PASSO 0 -- ALLINEA LONDRA (" + $EA + ") -- modo " + $Modo)

  # -------------------------------------------------------------------
  #  0. LE GUARDIE, PRIMA DI TOCCARE QUALUNQUE COSA
  # -------------------------------------------------------------------
  if($Pin -eq ""){ throw "-Pin obbligatorio: senza, girerebbe la punta del branch spacciandola per un commit congelato." }
  if($Pin -notmatch '^[0-9a-f]{40}$'){ throw ("-Pin deve essere un commit di 40 caratteri esadecimali, ricevuto: " + $Pin) }
  if($Pin -eq ("0"*40)){ throw "-Pin e' il SEGNAPOSTO di 40 zeri: la pagina non e' ancora stata pinnata col commit vero. Non parte niente." }
  if(Get-Process terminal64,metaeditor64 -ErrorAction SilentlyContinue){
    throw "MT5 O METAEDITOR APERTO: col terminale aperto il tester non gira (zero CSV), con MetaEditor aperto la compilazione torna subito senza compilare."
  }
  if($SoloCella -ne "" -and @($Ordinate).Count -eq 0){
    throw ("-SoloCella '" + $SoloCella + "' non esiste. Valide: " + ((@($CELLE | ForEach-Object { $_.Id })) -join ", "))
  }
  if($SoloBanco -ne "" -and @($BanchiDaFare).Count -eq 0){
    throw ("-SoloBanco '" + $SoloBanco + "' non esiste. Validi: S (OHLC screening), V (tick reali).")
  }
  if($Periodo -ne $PeriodoDichiarato){
    throw ("-Periodo e' " + $Periodo + ": i quattro file prova dichiarano @PERIODO " + $PeriodoDichiarato + " e il gate li confronta. Questo EA usa PERIOD_CURRENT e non ha un input InpTF: il timeframe del tester E' la strategia (il motore nasce a M15).")
  }
  if($Simbolo -ne $SimboloDichiarato){
    [void]$Rilievi.Add("SIMBOLO diverso da " + $SimboloDichiarato + " (" + $Simbolo + "): i file prova dichiarano @SIMBOLO " + $SimboloDichiarato + ". Il motore nasce su EURUSD e la finestra oraria e' tarata su Londra: su un altro simbolo la misura risponde a un'altra domanda.")
  }
  if($DaScreening -ne $DaScreeningDichiarato){
    [void]$Rilievi.Add("banco S girato dal " + $DaScreening + " invece del " + $DaScreeningDichiarato + " dichiarato nei file prova: finestra cambiata a mano. Va scritto accanto ai numeri.")
  }
  if($DaTick -ne "2024.07.05"){
    [void]$Rilievi.Add("banco V girato dal " + $DaTick + " invece del 2024.07.05 dichiarato: finestra cambiata a mano. Va scritto accanto ai numeri.")
  }
  if($Fino -ne "2026.06.30"){
    [void]$Rilievi.Add("fine finestra " + $Fino + " invece del 2026.06.30 dichiarato: finestra cambiata a mano. Va scritto accanto ai numeri.")
  }
  if($Terminale -ne "" -and -not (Test-Path -LiteralPath (Join-Path $Terminale "terminal64.exe"))){
    throw ("-Terminale '" + $Terminale + "' non contiene terminal64.exe: va passata la cartella di INSTALLAZIONE del terminale.")
  }

  # LA SENTINELLA DI UN GIRO PRECEDENTE INTERROTTO (classe 116, regola 1).
  # Il ripristino dell'include gira nella raccolta; se un giro e' stato
  # ucciso a meta' (Ctrl+C, finestra chiusa, riavvio) fra la copia e la
  # raccolta, nel terminale e' rimasto un include NOSTRO che nessuno ha
  # piu' tolto. Qui si rimedia PRIMA di ogni altra cosa e lo si dichiara.
  if(Test-Path -LiteralPath $Sentinella){
    $righeS = @(Get-Content -LiteralPath $Sentinella -ErrorAction SilentlyContinue)
    $sDest = ""; $sBack = ""
    if(@($righeS).Count -ge 1){ $sDest = ("" + $righeS[0]).Trim() }
    if(@($righeS).Count -ge 2){ $sBack = ("" + $righeS[1]).Trim() }
    if($sBack -eq "NESSUNO"){ $sBack = "" }
    $esitoS = RipristinaInclude $sDest $sBack
    Remove-Item -LiteralPath $Sentinella -Force -ErrorAction SilentlyContinue
    [void]$Rilievi.Add("UN GIRO PRECEDENTE ERA STATO INTERROTTO fra l'installazione dell'include e la raccolta: " + $IncNostro + " in " + $sDest + " -> " + $esitoS + " (fatto adesso, all'avvio di questo giro).")
    Dico ("sentinella di un giro interrotto: include " + $esitoS) "Yellow"
  }

  $passate = @($Ordinate).Count * @($BanchiDaFare).Count * 2 * 2
  Dico ("pin ......... " + $Pin)
  Dico ("celle ....... " + @($Ordinate).Count + " su 4   [" + ((@($Ordinate | ForEach-Object { $_.Id })) -join ", ") + "]")
  Dico ("banchi ...... " + @($BanchiDaFare).Count + " su 2")
  foreach($banco in $BanchiDaFare){
    Dico ("  banco " + $banco.Id + "  modello " + $banco.Modello + "  " + $banco.Da + " -> " + $Fino + "   " + $banco.Desc)
  }
  Dico ("banco ....... deposito " + $Deposito + ", periodo " + $Periodo + ", split IS/OOS 40/60 (default del driver generico)")
  Dico ("rischio ..... " + $Baseline["InpRiskPercent"] + "% -- letto dalla BASELINE DICHIARATA e pinnato nei file prova, dove morde davvero (non da un parametro di questa riga)")
  Dico ("passate ..... " + $passate + " (celle x banchi x 2 finestre x 2 gemelle)") "Yellow"
  Dico ("ATTENZIONE: il 2022.07.01 del banco S e' DERIVATO dal tetto delle 100.000 barre; il 2024.07.05 del banco V e' INFERITO da GBPUSD. Nessuno dei due e' misurato su EURUSD.") "Yellow"

  # -------------------------------------------------------------------
  #  1. SCARICO AL PIN
  # -------------------------------------------------------------------
  Titolo "1. SCARICO AL PIN"
  New-Item -ItemType Directory -Force -Path $Work,$Prove | Out-Null

  # --- se il pin cambia, la cache va via: senza, il gate di idempotenza
  #     del driver generico riproporrebbe i CSV di ieri come se fossero
  #     di oggi (e i file prova vecchi passerebbero i gate nuovi).
  $pinFile = Join-Path $Work "pin_corrente.txt"
  $pinVecchio = ""
  if(Test-Path -LiteralPath $pinFile){ $pinVecchio = (Get-Content -LiteralPath $pinFile -Raw).Trim() }
  if($pinVecchio -ne $Pin){
    Remove-Item -LiteralPath $Prove -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item -LiteralPath (Join-Path $Work "risultati_prove") -Recurse -Force -ErrorAction SilentlyContinue
    New-Item -ItemType Directory -Force -Path $Prove | Out-Null
    if($pinVecchio -ne ""){
      Dico ("pin cambiato (" + $pinVecchio + " -> " + $Pin + "): cache dei file prova e dei CSV CANCELLATA. Le celle gia' girate col pin vecchio SONO PERSE.") "Yellow"
      [void]$Rilievi.Add("il pin e' cambiato rispetto al giro precedente (" + $pinVecchio + " -> " + $Pin + "): risultati_prove\ e' stato CANCELLATO. Ogni cella gia' girata va rifatta, e il referto d'insieme di questo giro contiene solo cio' che gira adesso.")
    }
    Set-Content -LiteralPath $pinFile -Value $Pin -Encoding ASCII
  }

  $drv = Join-Path $Work "walkforward_generico.ps1"
  Scarica ($RawPin + "/backtest_pipeline/walkforward_generico.ps1") $drv
  # il driver generico pinna il branch da cui riscarica il .mq5: senza
  # questo, il pin varrebbe per il driver e NON per l'EA misurato.
  $testoDrv = Get-Content -LiteralPath $drv -Raw
  if($testoDrv -notmatch '\$EABranch\s*=\s*"lavoro"'){ throw 'walkforward_generico.ps1 non ha la riga $EABranch = "lavoro" attesa: non lo posso pinnare (il pin varrebbe per il driver e NON per l''EA misurato).' }
  $testoDrv = $testoDrv -replace '\$EABranch\s*=\s*"lavoro"', ('$EABranch="' + $Pin + '"')
  Set-Content -LiteralPath $drv -Value $testoDrv -Encoding ASCII
  Dico "driver generico scaricato e PINNATO (riscarica l'EA al pin, non dalla punta del branch)" "Green"

  # GLI ARTEFATTI INTERMEDI SI RIPULISCONO PRIMA (difetto n.14): un file
  # prova di una versione precedente rimasto nella cartella verrebbe
  # letto dai gate e confrontato coi criteri di adesso, in buona fede.
  Remove-Item -Path (Join-Path $Prove "*.txt") -Force -ErrorAction SilentlyContinue

  # TUTTI E QUATTRO i file prova si scaricano SEMPRE, anche quando gira
  # una cella sola: i gate del perimetro (stella contro il 00_finestra,
  # magic unici) sono gate DI INSIEME e su un file solo non direbbero
  # niente.
  foreach($cel in $CELLE){
    Scarica ($RawPin + "/backtest_pipeline/prove/" + $cel.Prova) (Join-Path $Prove $cel.Prova)
  }
  Dico ("file prova scaricati: " + @(Get-ChildItem $Prove -Filter PASSO0_ALLINEALONDRA_*.txt).Count + " su 4") "Green"

  $incSrc = Join-Path $Work "ABTG_PausaGuardian.mqh"
  Scarica ($RawPin + "/mql5/Include/ABTG_PausaGuardian.mqh") $incSrc
  Dico ("include scaricato: ABTG_PausaGuardian.mqh (" + (Get-Item -LiteralPath $incSrc).Length + " byte)") "Green"

  # -------------------------------------------------------------------
  #  2. I GATE SUI FILE PROVA -- girano PRIMA di aprire MT5
  # -------------------------------------------------------------------
  Titolo "2. GATE SUI FILE PROVA"
  $mappe = @{}
  foreach($cel in $CELLE){
    $fileProva = Join-Path $Prove $cel.Prova
    $righeFile = RigheVive $fileProva
    $mappa = @{}
    $assiY = New-Object System.Collections.ArrayList
    foreach($rigaFile in $righeFile){
      if($rigaFile -match '^@'){
        $pezzi = ($rigaFile -split '\s+',2)
        if($pezzi.Count -lt 2){ throw ($cel.Prova + ": la direttiva '" + $rigaFile + "' non ha un valore.") }
        if($mappa.ContainsKey($pezzi[0])){ throw ($cel.Prova + ": DUE direttive '" + $pezzi[0] + "'.") }
        $mappa[$pezzi[0]] = $pezzi[1].Trim()
        continue
      }
      $pos = $rigaFile.IndexOf("=")
      if($pos -lt 0){ throw ($cel.Prova + ": riga senza '=' e senza '#': '" + $rigaFile + "'.") }
      $nomeInput = $rigaFile.Substring(0,$pos).Trim()
      $valInput  = $rigaFile.Substring($pos+1).Trim()
      if($mappa.ContainsKey($nomeInput)){ throw ($cel.Prova + ": DUE righe per '" + $nomeInput + "'. In [TesterInputs] un parametro doppio fa fare a MT5 ZERO passate.") }

      # GATE DELLA SINTASSI DEI CINQUE CAMPI. Una riga con quattro campi
      # (Nome=1||||||N) viene trattata dal driver generico come "pin
      # secco" e riscritta storta: MT5 la ignora IN SILENZIO.
      $campi = $valInput -split '\|\|'
      if($campi.Count -ne 5){
        throw ($cel.Prova + ": '" + $nomeInput + "' ha " + $campi.Count + " campi invece di 5. La forma di casa e' 'Nome=valore||valore||0||valore||N'.")
      }
      if($campi[4].Trim() -ne "N" -and $campi[4].Trim() -ne "Y"){
        throw ($cel.Prova + ": '" + $nomeInput + "' ha flag '" + $campi[4] + "' invece di N o Y.")
      }

      # GATE DELL'ELENCO CHIUSO: nessuna griglia puo' entrare.
      if(-not ($ParametriAmmessi -contains $nomeInput)){
        throw ($cel.Prova + ": '" + $nomeInput + "' NON e' nell'elenco chiuso dei parametri di questo PASSO 0. Un PASSO 0 CONTA le operazioni: se entra un parametro che non e' in elenco, smette di contare e comincia a scegliere -- che e' un altro round, e va firmato prima.")
      }

      $mappa[$nomeInput] = $valInput
      if($campi[4].Trim() -eq "Y"){ [void]$assiY.Add($nomeInput) }
    }

    # GATE DELL'ASSE UNICO: uno solo, e dev'essere InpMagic.
    if(@($assiY).Count -ne 1){ throw ($cel.Prova + ": deve avere ESATTAMENTE un asse con flag Y, trovati " + @($assiY).Count + " [" + ($assiY -join ",") + "].") }
    if($assiY[0] -ne "InpMagic"){ throw ($cel.Prova + ": l'unico asse Y deve essere InpMagic, invece e' " + $assiY[0] + ". Le cinque medie sono CONGELATE e la sessione NON si spazzola in questo giro.") }

    # GATE GEOMETRIA: contro i valori DICHIARATI, non contro i parametri.
    if($mappa["@SIMBOLO"]  -ne $SimboloDichiarato){     throw ($cel.Prova + ": @SIMBOLO e' " + $mappa["@SIMBOLO"] + ", atteso " + $SimboloDichiarato) }
    if($mappa["@PERIODO"]  -ne $PeriodoDichiarato){     throw ($cel.Prova + ": @PERIODO e' " + $mappa["@PERIODO"] + ", atteso " + $PeriodoDichiarato + " (trappola R102: il TF del tester E' la strategia, questo EA usa PERIOD_CURRENT)") }
    if($mappa["@DAQUANDO"] -ne $DaScreeningDichiarato){ throw ($cel.Prova + ": @DAQUANDO e' " + $mappa["@DAQUANDO"] + ", atteso " + $DaScreeningDichiarato + " (la finestra DICHIARATA del banco S; le date vere le passa il driver con -DaQuando esplicito, banco per banco)") }

    # GATE DEI VALORI ASSOLUTI degli interruttori. Prende il caso che
    # nessun diff vede: due file SCAMBIATI fra loro.
    foreach($chiave in @($cel.Val.Keys)){
      if(-not $mappa.ContainsKey($chiave)){ throw ($cel.Prova + ": manca la riga '" + $chiave + "', che e' un interruttore dichiarato e va verificabile nell'.ini.") }
      $primoCampo = ($mappa[$chiave] -split '\|\|')[0]
      if($primoCampo -ne $cel.Val[$chiave]){
        throw ($cel.Prova + ": '" + $chiave + "' vale " + $primoCampo + ", la cella " + $cel.Id + " lo vuole " + $cel.Val[$chiave])
      }
    }

    # GATE DELLA BASELINE ASSOLUTA: contro valori DICHIARATI QUI, non
    # contro un file gemello. Una corruzione simmetrica passerebbe un
    # diff e non passa questo.
    foreach($chiave in $Baseline.Keys){
      if(-not $mappa.ContainsKey($chiave)){ throw ($cel.Prova + ": manca il pin di '" + $chiave + "': la baseline dev'essere verificabile nell'.ini, non dedotta dal default compilato.") }
      $primoCampo = ($mappa[$chiave] -split '\|\|')[0]
      if($primoCampo -ne $Baseline[$chiave]){
        throw ($cel.Prova + ": '" + $chiave + "' vale " + $primoCampo + ", la baseline dichiarata di questo PASSO 0 lo vuole " + $Baseline[$chiave])
      }
    }

    $mappe[$cel.Id] = $mappa
  }

  # GATE DELLA STELLA: ogni cella differisce dal 00_finestra SOLO per
  # cio' che e' dichiarato in Diff, piu' InpMagic. Confronto PER NOME,
  # mai per posizione: un file con una riga in piu' sfaserebbe tutto.
  $mappaBase = $mappe["00_finestra"]
  if($null -eq $mappaBase){ throw "manca la mappa del 00_finestra: senza, il gate della stella non e' eseguibile." }
  foreach($cel in $CELLE){
    if($cel.Id -eq "00_finestra"){ continue }
    $mappa = $mappe[$cel.Id]
    $ammessi = @("InpMagic") + @($cel.Diff)
    # PRIMA la presenza (messaggio chiaro), POI la differenza: una riga
    # in piu' o in meno e' un errore diverso da una riga mossa.
    foreach($chiave in @($mappa.Keys)){
      if($chiave -match '^@'){ continue }
      if(-not $mappaBase.ContainsKey($chiave)){ throw ($cel.Prova + ": ha la riga '" + $chiave + "' che il 00_finestra non ha. La stella confronta due file con le STESSE righe.") }
    }
    foreach($chiave in @($mappaBase.Keys)){
      if($chiave -match '^@'){ continue }
      if(-not $mappa.ContainsKey($chiave)){ throw ($cel.Prova + ": NON ha la riga '" + $chiave + "' che il 00_finestra ha.") }
    }
    foreach($chiave in @($mappa.Keys)){
      if($chiave -match '^@'){ continue }
      if($ammessi -contains $chiave){ continue }
      if($mappaBase[$chiave] -ne $mappa[$chiave]){ throw ($cel.Prova + ": '" + $chiave + "' differisce dal 00_finestra e NON e' un delta dichiarato.") }
    }
    foreach($chiave in @($cel.Diff)){
      if($mappaBase[$chiave] -eq $mappa[$chiave]){ throw ($cel.Prova + ": '" + $chiave + "' DOVEVA differire dal 00_finestra e non differisce.") }
    }
  }

  # GATE DEI MAGIC: unici in tutto l'insieme, mai uno vietato.
  # L'ORDINE DEI TRE CONTROLLI E' PARTE DEL GATE: con l'identita' PER
  # PRIMA, "VIETATO" e "DUPLICATO" non potrebbero scattare mai. Prima si
  # nomina il PERICOLO (toccare una sedia viva, incrociare due celle),
  # poi lo scostamento innocuo.
  $magicVisti = @{}
  foreach($cel in $CELLE){
    $campiMagic = $mappe[$cel.Id]["InpMagic"] -split '\|\|'
    $attesi = @($cel.M1, $cel.M2)
    $letti  = @([int]$campiMagic[1], [int]$campiMagic[3])
    if([int]$campiMagic[2] -ne 1){ throw ($cel.Prova + ": InpMagic ha passo " + $campiMagic[2] + " invece di 1: i gemelli non sarebbero due.") }
    for($i = 0; $i -lt 2; $i++){
      $numMagic = [int]$letti[$i]
      if($MagicVietati -contains $numMagic){ throw ($cel.Prova + ": magic " + $numMagic + " e' VIETATO (sedia viva o round recente). Un'identita' non in campo resta comunque occupata.") }
      if($magicVisti.ContainsKey($numMagic)){ throw ("magic " + $numMagic + " usato in due celle: " + $magicVisti[$numMagic] + " e " + $cel.Prova) }
      if($numMagic -ne [int]$attesi[$i]){ throw ($cel.Prova + ": magic " + $numMagic + ", la cella " + $cel.Id + " vuole " + $attesi[$i] + ".") }
      $magicVisti[$numMagic] = $cel.Prova
    }
  }
  Dico ("sintassi a 5 campi, elenco chiuso, asse unico, geometria, interruttori, baseline assoluta, stella e magic: TUTTI PASSATI su 4 file su 4 (" + $magicVisti.Count + " magic unici su 8)") "Green"

  # -------------------------------------------------------------------
  #  3. L'INCLUDE E LA COMPILAZIONE -- i due pezzi che il driver
  #     generico non fa (l'include) o fa troppo tardi (la compilazione).
  # -------------------------------------------------------------------
  Titolo "3. IL TERMINALE (per FATTI), L'INCLUDE (con sentinella) E LA COMPILAZIONE"
  # IL TERMINALE SI SCEGLIE PER UN FATTO, NON PER NOME (classe 115). La
  # v1 copiava il selettore per nome di walkforward_generico.ps1
  # ("*BCM Markets MT5 Terminal*"): combacia sul banco e puo' non
  # combaciare sulla macchina vera (portable, altro profilo, altro
  # nome). Qui si scandisce LARGO -- le cartelle dati (origin.txt), le
  # installazioni in Program Files, il caso portable (MQL5 dentro
  # l'installazione) -- e si sceglie STRETTO col fatto piu' forte: la
  # cartella dati che ha bases\*BCM*, cioe' il feed. Il percorso che
  # contiene "BCM" e' un fatto piu' debole e viene dichiarato tale.
  # Con ZERO o DUE candidati non si indovina: ci si ferma stampando
  # l'elenco intero e la manopola -Terminale.
  # E IL TERMINALE SCELTO VIENE PASSATO al driver generico
  # (-Terminal/-MetaEditor/-DataFolder): cosi' i due script usano lo
  # stesso terminale PER COSTRUZIONE, non perche' copiano lo stesso
  # selettore (punti 27/37).
  $termRoot = ""
  if($env:APPDATA){ $termRoot = Join-Path $env:APPDATA "MetaQuotes\Terminal" }
  $mappaInst = @{}
  if($termRoot -ne "" -and (Test-Path -LiteralPath $termRoot)){
    foreach($dCart in @(Get-ChildItem -LiteralPath $termRoot -Directory -ErrorAction SilentlyContinue)){
      if($dCart.Name -ieq "Common"){ continue }
      $oTxt = Join-Path $dCart.FullName "origin.txt"
      if(-not (Test-Path -LiteralPath $oTxt)){ continue }
      $instOrigin = (Get-Content -LiteralPath $oTxt -Raw -ErrorAction SilentlyContinue)
      if($null -eq $instOrigin){ continue }
      $instOrigin = $instOrigin.Trim().TrimEnd("\")
      if($instOrigin -ne "" -and -not $mappaInst.ContainsKey($instOrigin)){ $mappaInst[$instOrigin] = $dCart.FullName }
    }
  }
  foreach($radiceP in @("C:\Program Files","C:\Program Files (x86)")){
    if(-not (Test-Path -LiteralPath $radiceP)){ continue }
    foreach($tExe in @(Get-ChildItem -LiteralPath $radiceP -Recurse -Filter "terminal64.exe" -ErrorAction SilentlyContinue)){
      $kInst = $tExe.DirectoryName.TrimEnd("\")
      if(-not $mappaInst.ContainsKey($kInst)){
        # PORTABLE: la cartella dati sta DENTRO l'installazione
        $dfPort = ""
        if(Test-Path -LiteralPath (Join-Path $kInst "MQL5\Experts")){ $dfPort = $kInst }
        $mappaInst[$kInst] = $dfPort
      }
    }
  }
  $candidati = New-Object System.Collections.ArrayList
  foreach($kInst in @($mappaInst.Keys)){
    if(-not (Test-Path -LiteralPath (Join-Path $kInst "terminal64.exe"))){ continue }
    if(-not (Test-Path -LiteralPath (Join-Path $kInst "metaeditor64.exe"))){ continue }
    $dfCand = $mappaInst[$kInst]
    $fatto = ""
    if($dfCand -ne ""){
      $basi = @(Get-ChildItem -LiteralPath (Join-Path $dfCand "bases") -Directory -ErrorAction SilentlyContinue | Where-Object { $_.Name -like "*BCM*" })
      if($basi.Count -gt 0){ $fatto = "cartella dati con bases\" + $basi[0].Name + " (il feed)" }
    }
    if($fatto -eq "" -and $kInst -like "*BCM*"){ $fatto = "solo il percorso di installazione contiene BCM (fatto DEBOLE)" }
    [void]$candidati.Add([pscustomobject]@{ Inst=$kInst; Data=$dfCand; Fatto=$fatto })
  }
  Write-Host "  installazioni MT5 trovate (terminal64.exe + metaeditor64.exe):" -ForegroundColor Gray
  foreach($cCand in $candidati){
    $fTxt = $cCand.Fatto; if($fTxt -eq ""){ $fTxt = "nessun fatto BCM" }
    $dTxt = $cCand.Data;  if($dTxt -eq ""){ $dTxt = "cartella dati NON trovata" }
    Write-Host ("    " + $cCand.Inst + "   [" + $fTxt + "]   dati: " + $dTxt) -ForegroundColor Gray
  }
  $scelto = $null
  if($Terminale -ne ""){
    $tNorm = $Terminale.TrimEnd("\")
    $scelto = @($candidati | Where-Object { $_.Inst -ieq $tNorm }) | Select-Object -First 1
    if($null -eq $scelto){
      $dfMan = ""
      if($mappaInst.ContainsKey($tNorm)){ $dfMan = $mappaInst[$tNorm] }
      if($dfMan -eq "" -and (Test-Path -LiteralPath (Join-Path $tNorm "MQL5\Experts"))){ $dfMan = $tNorm }
      $scelto = [pscustomobject]@{ Inst=$tNorm; Data=$dfMan; Fatto="SCELTO A MANO con -Terminale" }
    }
    $TermCrit = "SCELTO A MANO con -Terminale (i gate sul terminale girano lo stesso)"
  }
  else{
    $conFeed  = @($candidati | Where-Object { $_.Fatto -like "cartella dati con bases*" })
    $conFatto = @($candidati | Where-Object { $_.Fatto -ne "" })
    $feedNoV3 = @($conFeed | Where-Object { $_.Inst -notlike "*-V3*" })
    if($feedNoV3.Count -eq 1){
      $scelto = $feedNoV3[0]; $TermCrit = "FATTO: " + $scelto.Fatto + "; scartate le installazioni -V3 (il 100k non e' il banco di backtest)"
    }
    elseif($feedNoV3.Count -gt 1){
      $elenco = (@($feedNoV3 | ForEach-Object { $_.Inst }) -join " | ")
      throw ("NON SO QUALE TERMINALE USARE (classe 115: l'ambiente non si indovina): " + $feedNoV3.Count + " installazioni con feed BCM e senza -V3: " + $elenco + ". Rilancia lo stesso blocco aggiungendo al driver: -Terminale ""<cartella di installazione>"".")
    }
    elseif($conFeed.Count -ge 1){
      $scelto = $conFeed[0]; $TermCrit = "FATTO: " + $scelto.Fatto + " -- ma e' un'installazione -V3 (l'unica col feed BCM): DICHIARATO"
      [void]$Rilievi.Add("l'unica installazione col feed BCM e' una -V3 (" + $scelto.Inst + "): il banco gira li'. Se non e' quello voluto, rilancia con -Terminale.")
    }
    elseif($conFatto.Count -eq 1){
      $scelto = $conFatto[0]; $TermCrit = "FATTO DEBOLE: " + $scelto.Fatto + " (nessuna cartella dati con bases\*BCM* trovata)"
      [void]$Rilievi.Add("il terminale e' stato scelto per il solo PERCORSO che contiene BCM (" + $scelto.Inst + "): nessuna cartella dati con bases\*BCM* trovata. Dichiarato, non indovinato.")
    }
    else{
      $elenco = "nessuna"
      if($candidati.Count -gt 0){ $elenco = (@($candidati | ForEach-Object { $_.Inst + " [" + $(if($_.Fatto -ne ""){$_.Fatto}else{"nessun fatto BCM"}) + "]" }) -join " | ") }
      throw ("NON SO QUALE TERMINALE USARE (classe 115: l'ambiente non si indovina dal nome). Installazioni viste: " + $elenco + ". Rilancia lo stesso blocco aggiungendo al driver: -Terminale ""<cartella che contiene terminal64.exe>"".")
    }
  }
  $instDir    = $scelto.Inst
  $TermExe    = Join-Path $instDir "terminal64.exe"
  $MetaEditor = Join-Path $instDir "metaeditor64.exe"
  $dataFolder = $scelto.Data
  if($dataFolder -eq "" -or $null -eq $dataFolder){ throw ("cartella dati non trovata per " + $instDir + ": nessun origin.txt in " + $termRoot + " la nomina e non e' portable (manca MQL5\Experts dentro l'installazione). Il terminale va aperto almeno una volta.") }
  $TermScelto = $instDir
  $DataFolder = $dataFolder
  Dico ("terminale scelto: " + $instDir) "Yellow"
  Dico ("criterio ........ " + $TermCrit) "Yellow"
  Dico ("cartella dati ... " + $dataFolder) "Yellow"

  # LA FOTO PRIMA dei tre file del terminale che questo giro tocca
  # (classe 116, regola 2). Il .mq5 e l'.ex5 in Experts sono SCRITTI
  # apposta (e' il banco: li scrive anche il driver generico); l'include
  # viene messo e poi RIMESSO COM'ERA.
  $incDir  = Join-Path $dataFolder "MQL5\Include"
  $dstExp  = Join-Path $dataFolder "MQL5\Experts"
  $IncDest = Join-Path $incDir $IncNostro
  $dstMq5  = Join-Path $dstExp ($EA + ".mq5")
  $ex5     = Join-Path $dstExp ($EA + ".ex5")
  $FotoPrima["include"] = Foto $IncDest
  $FotoPrima["mq5"]     = Foto $dstMq5
  $FotoPrima["ex5"]     = Foto $ex5
  Dico ("foto PRIMA -- Include\" + $IncNostro + ": " + $FotoPrima["include"])
  Dico ("foto PRIMA -- Experts\" + $EA + ".mq5: " + $FotoPrima["mq5"])
  Dico ("foto PRIMA -- Experts\" + $EA + ".ex5: " + $FotoPrima["ex5"])
  $residui = @(Get-ChildItem -LiteralPath $BackupDir -Filter ($IncNostro + ".prima_*") -ErrorAction SilentlyContinue)
  if($residui.Count -gt 0){
    [void]$Rilievi.Add("in " + $BackupDir + " ci sono " + $residui.Count + " backup " + $IncNostro + ".prima_* di giri precedenti (il primo: " + $residui[0].Name + "). Non li tocco: sono copie di cio' che il terminale aveva PRIMA, si cancellano a mano.")
  }

  # L'INCLUDE: sentinella PRIMA della scrittura, backup se c'era gia'
  # un file DIVERSO, niente da fare se c'e' gia' ed e' IDENTICO.
  New-Item -ItemType Directory -Force -Path $incDir,$BackupDir | Out-Null
  $hashPin = HashFile $incSrc
  $hashTerm = HashFile $IncDest
  if($hashTerm -ne "" -and $hashTerm -eq $hashPin -and -not (Get-Item -LiteralPath $IncDest).PSIsContainer){
    $IncEsito = "GIA' PRESENTE E IDENTICO al pin: non toccato"
    $Include  = $IncNostro + " " + $IncEsito + " (" + $IncDest + ")"
  }
  else{
    $IncBackup = ""
    if(Test-Path -LiteralPath $IncDest){
      $IncBackup = Join-Path $BackupDir ($IncNostro + ".prima_" + $Stamp)
      Copy-Item -LiteralPath $IncDest -Destination $IncBackup -Force
      if(-not (Test-Path -LiteralPath $IncBackup)){ throw ("backup dell'include NON riuscito in " + $IncBackup + ": non tocco il terminale.") }
    }
    $sBackTxt = $IncBackup; if($sBackTxt -eq ""){ $sBackTxt = "NESSUNO" }
    Set-Content -LiteralPath $Sentinella -Value @($IncDest, $sBackTxt, ("pin " + $Pin), ("avvio " + $Avvio.ToString("yyyy-MM-dd HH:mm:ss",$INV))) -Encoding ASCII
    # LA COPIA SI VERIFICA SUL CONTENUTO, NON SUL NOME (punto 27-ter): se
    # in Include esistesse una CARTELLA con quel nome, Copy-Item ci
    # metterebbe il file DENTRO e Test-Path direbbe verde lo stesso.
    $lenInc = (Get-Item -LiteralPath $incSrc).Length
    Copy-Item -LiteralPath $incSrc -Destination $incDir -Force
    $IncInstallato = $true
    $vInc = Get-Item -LiteralPath $IncDest -ErrorAction Stop
    if($vInc.PSIsContainer -or $vInc.Length -ne $lenInc){ throw ($IncNostro + " copiato ma NON verificato in " + $incDir + " (lunghezza diversa o e' una cartella).") }
    $IncEsito = "INSTALLATO e VERIFICATO (" + $lenInc + " byte)"
    if($IncBackup -ne ""){ $IncEsito += ", il file DIVERSO che c'era prima e' in " + $IncBackup }
    else{ $IncEsito += ", prima non c'era" }
    $IncEsito += " -- viene RIMESSO COM'ERA a fine giro"
    $Include = $IncNostro + " " + $IncEsito
  }
  Dico $Include "Green"

  # --- LA COMPILAZIONE, IN ENTRAMBI I RAMI (controllo E corsa vera).
  #     QUESTO EA NON E' MAI STATO COMPILATO DA NESSUNO: un giro di
  #     controllo che non compila non controlla la cosa PIU' PROBABILE
  #     che vada storta, e l'errore uscirebbe dentro il driver generico,
  #     che muore con "compilazione fallita" senza dire perche'.
  #     L'.ex5 si CANCELLA prima: senza, un binario vecchio farebbe
  #     passare per riuscita una compilazione fallita (punto 23/54).
  #     IL CAMPO 'compilazione:' HA TRE STATI e si timbra sul ramo che lo
  #     DECIDE (classe 94-ter): NON TENTATA / FALLITA / OK.
  $mq5 = Join-Path $Work ($EA + ".mq5")
  Scarica ($RawPin + "/mql5/Experts/" + $EA + ".mq5") $mq5
  New-Item -ItemType Directory -Force -Path $dstExp | Out-Null
  Copy-Item -LiteralPath $mq5 -Destination $dstMq5 -Force
  Remove-Item -LiteralPath $ex5 -Force -ErrorAction SilentlyContinue
  $logC = Join-Path $dstExp ($EA + ".log")
  Remove-Item -LiteralPath $logC -Force -ErrorAction SilentlyContinue
  $t0 = Get-Date
  $Compilato = "FALLITA (MetaEditor lanciato, nessun .ex5 entro 180 s)"
  & $MetaEditor ("/compile:" + $dstMq5) "/log" | Out-Null
  $battito = 0
  while((-not (Test-Path -LiteralPath $ex5)) -and ((New-TimeSpan -Start $t0 -End (Get-Date)).TotalSeconds -lt 180)){
    $sec = [int](New-TimeSpan -Start $t0 -End (Get-Date)).TotalSeconds
    if($sec -ge ($battito + 10)){ $battito = $sec; Dico ("   ... aspetto l'.ex5 da " + $sec + "s (tetto 180 s): NON interrompere, la riga si ferma da sola") }
    Start-Sleep -Seconds 2
  }
  if(-not (Test-Path -LiteralPath $ex5)){
    if(Test-Path -LiteralPath $logC){
      Copy-Item -LiteralPath $logC -Destination (Join-Path $Work "COMPILAZIONE_FALLITA.log") -Force
      Get-Content -LiteralPath $logC -Tail 40 | ForEach-Object { Write-Host $_ -ForegroundColor Red }
      $Compilato = "FALLITA (MetaEditor lanciato, nessun .ex5; il log e' in COMPILAZIONE_FALLITA.log dentro lo zip)"
    }
    else{
      $Compilato = "FALLITA -- METAEDITOR MUTO (nessun .ex5 e NESSUN log entro 180 s: editor aperto, percorso o permessi; NON e' un verdetto sul codice)"
    }
    throw ("COMPILAZIONE " + $Compilato + ". " + $EA + " non era MAI stato compilato da nessuno. SE LA COMPILAZIONE FALLISCE, IL RISULTATO DEL PASSO 0 E' QUESTO: si riporta cosi' com'e'.")
  }
  $Compilato = "OK (" + [int]((Get-Item -LiteralPath $ex5).Length/1024) + " KB, " + (Get-Item -LiteralPath $ex5).LastWriteTime.ToString("HH:mm:ss",$INV) + ")"
  Dico ("compilato " + $EA + ": " + $Compilato) "Green"

  # -------------------------------------------------------------------
  #  4. LE CORSE -- cella per cella, banco per banco
  # -------------------------------------------------------------------
  Titolo "4. LE CORSE"
  $cartRis = Join-Path $Work ("risultati_prove\" + $EA)
  foreach($cel in $Ordinate){
    foreach($banco in $BanchiDaFare){
      $etichetta = $cel.Id + "_" + $banco.Id
      Dico ("cella " + $cel.Id + " | banco " + $banco.Id + " (modello " + $banco.Modello + ", dal " + $banco.Da + ") -- " + $cel.Desc) "Cyan"
      # NON si chiama $args: e' una VARIABILE AUTOMATICA di PowerShell
      # (punto 71). Questo script non usa $args da nessuna parte.
      $argv = @("-ExecutionPolicy","Bypass","-File",$drv,
                "-Expert",$EA,
                "-Prova",(Join-Path $Prove $cel.Prova),
                "-Etichetta",$etichetta,
                "-Simbolo",$Simbolo,
                "-Periodo",$Periodo,
                "-DaQuando",$banco.Da,
                "-Fino",$Fino,
                "-Modello",("" + $banco.Modello),
                "-Deposito",("" + $Deposito),
                # LO STESSO TERMINALE PER COSTRUZIONE (classi 37/115): il
                # generico non sceglie, riceve.
                "-Terminal",$TermExe,
                "-MetaEditor",$MetaEditor,
                "-DataFolder",$dataFolder)
      if($SoloControllo){ $argv += "-SoloControllo" }
      if($Rifai){ $argv += "-Rifai" }
      $tLancio = Get-Date
      $global:LASTEXITCODE = $null
      & powershell $argv
      # IL CODICE DI USCITA SI LEGGE A TRE STATI (classe 108): 0 / N / NON
      # LETTO. Su PS 5.1 un codice VUOTO letto con '-ne 0' diventerebbe
      # "fallita" su una corsa sana. Quando non c'e', decide l'ARTEFATTO:
      # in corsa i CSV freschi (sotto), nel controllo l'anteprima .ini
      # fresca che il generico scrive nella cartella di lavoro.
      $rcGrezzo = $LASTEXITCODE
      $rcLetto  = ($null -ne $rcGrezzo -and (("" + $rcGrezzo).Trim()) -match '^-?\d+$')
      $rcTxt    = "NON LETTO"
      if($rcLetto){ $rcTxt = ("" + [int]$rcGrezzo) }
      if($rcLetto -and [int]$rcGrezzo -ne 0){
        $cel.Ris[$banco.Id] = [pscustomobject]@{ Esito=("FERMATA (codice " + $rcTxt + ")"); Fresca="NO"; GemIS="NON MISURATO"; GemOOS="NON MISURATO"; DatiIS=$null; DatiOOS=$null }
        [void]$Problemi.Add("cella " + $cel.Id + " banco " + $banco.Id + ": il driver generico e' uscito con codice " + $rcTxt + " (il suo messaggio rosso e' qui sopra in console)")
        continue
      }
      if(-not $rcLetto){
        [void]$Rilievi.Add("cella " + $cel.Id + " banco " + $banco.Id + ": codice di uscita del driver generico NON LETTO (capita su PS 5.1). NON e' un fallimento: decide l'artefatto (CSV freschi in corsa, anteprima .ini fresca nel controllo).")
      }
      if($SoloControllo){
        $anteprima = Join-Path $Work ("anteprima_" + $EA + "_" + $Simbolo + ".ini")
        $antFresca = (Test-Path -LiteralPath $anteprima) -and ((Get-Item -LiteralPath $anteprima).LastWriteTime -ge $tLancio)
        if($antFresca){
          $cel.Ris[$banco.Id] = [pscustomobject]@{ Esito=("CONTROLLO OK (anteprima .ini fresca; codice " + $rcTxt + ")"); Fresca="NON PERTINENTE (giro di controllo: il tester non e' stato aperto)"; GemIS="NON PERTINENTE"; GemOOS="NON PERTINENTE"; DatiIS=$null; DatiOOS=$null }
        }
        else{
          $cel.Ris[$banco.Id] = [pscustomobject]@{ Esito=("CONTROLLO SENZA ARTEFATTO (nessuna anteprima .ini fresca; codice " + $rcTxt + ")"); Fresca="NO"; GemIS="NON MISURATO"; GemOOS="NON MISURATO"; DatiIS=$null; DatiOOS=$null }
          [void]$Problemi.Add("cella " + $cel.Id + " banco " + $banco.Id + ": il giro di controllo NON ha lasciato l'anteprima .ini fresca (" + $anteprima + "): il driver generico si e' fermato prima. Il suo messaggio e' in console.")
        }
        continue
      }
      # IL NOME DEL CSV: il driver generico mette "_ohlc" davanti
      # all'etichetta quando il modello NON e' 4 (riga 607), perche' un
      # OHLC non deve MAI sovrascrivere un tick reale.
      $suffModello = ""
      if($banco.Modello -ne 4){ $suffModello = "_ohlc" }
      $csvIS  = Join-Path $cartRis ($EA + "_" + $Simbolo + "_IS"  + $suffModello + "_" + $etichetta + ".csv")
      $csvOOS = Join-Path $cartRis ($EA + "_" + $Simbolo + "_OOS" + $suffModello + "_" + $etichetta + ".csv")
      $letteIS  = LeggiOpt $csvIS
      $letteOOS = LeggiOpt $csvOOS
      if($null -eq $letteIS -or $null -eq $letteOOS){
        # DUE CAUSE DIVERSE, DUE MESSAGGI DIVERSI: "il file non c'e'" e
        # "il file c'e' ma non ha le colonne di questo EA" si riparano in
        # due posti opposti, e confonderli fa perdere il giro dopo.
        $mancanti = @()
        foreach($f in @($csvIS,$csvOOS)){ if(-not (Test-Path -LiteralPath $f)){ $mancanti += (Split-Path $f -Leaf) } }
        if(@($mancanti).Count -gt 0){
          $cel.Ris[$banco.Id] = [pscustomobject]@{ Esito="CSV MANCANTE"; Fresca="NO"; GemIS="NON MISURATO"; GemOOS="NON MISURATO"; DatiIS=$null; DatiOOS=$null }
          [void]$Problemi.Add("cella " + $cel.Id + " banco " + $banco.Id + ": CSV NON PRODOTTO dal tester: " + ($mancanti -join ", ") + ". Storico mancante sul simbolo per quella finestra, MT5 gia' aperto, oppure la cella non e' girata.")
        }else{
          $cel.Ris[$banco.Id] = [pscustomobject]@{ Esito="CSV SENZA LE COLONNE DI QUESTO EA"; Fresca="NO"; GemIS="NON MISURATO"; GemOOS="NON MISURATO"; DatiIS=$null; DatiOOS=$null }
          [void]$Problemi.Add("cella " + $cel.Id + " banco " + $banco.Id + ": il CSV c'e' ma NON ha le 29 colonne di questo EA (l'.ex5 che ha girato non e' questo?). Intestazioni viste: " + ($script:CsvIntestazioni -join " | "))
        }
        continue
      }
      # HA GIRATO IL TESTER, O I CSV ERANO GIA' LI'? Il driver generico
      # salta le finestre gia' fatte ("gia' fatto, salto"): in quel caso
      # questa cella e' stata RILETTA, non MISURATA (punti 50, 92, 101-bis).
      $freschi = $true
      foreach($f in @($csvIS,$csvOOS)){ if((Get-Item -LiteralPath $f).LastWriteTime -lt $tLancio){ $freschi = $false } }
      $esitoLancio = "MISURATA"
      $frase = "SI (il tester ha girato in questo giro)"
      if(-not $freschi){
        $esitoLancio = "RILETTA DA CSV GIA' PRESENTI (il tester NON ha girato in questo giro)"
        $frase = "NO (CSV gia' presenti: RILETTI, non rimisurati. Serve -Rifai per rifarli)"
      }
      $cel.Ris[$banco.Id] = [pscustomobject]@{
        Esito=$esitoLancio; Fresca=$frase
        GemIS=(Gemelli $letteIS); GemOOS=(Gemelli $letteOOS)
        DatiIS=$letteIS; DatiOOS=$letteOOS }
    }
  }

  # -------------------------------------------------------------------
  #  4-bis. LA RICOMPOSIZIONE, SEMPRE.
  #  L'ablazione e' un criterio DI INSIEME (serve il 00 E il 01): un
  #  referto che leggesse solo le celle di QUESTO giro non potrebbe mai
  #  adjudicarla (CHECKLIST punto 101). Qui si rileggono i CSV di TUTTE
  #  le celle e di TUTTI i banchi che esistono gia' sul disco, marcati
  #  come RILETTI -- cosi' il confronto esce anche se le celle sono
  #  state girate in serate diverse, e non serve un lancio in piu'.
  # -------------------------------------------------------------------
  if(-not $SoloControllo){
    foreach($cel in $CELLE){
      foreach($banco in $BANCHI){
        if($cel.Ris.ContainsKey($banco.Id)){ continue }
        $etichetta = $cel.Id + "_" + $banco.Id
        $suffModello = ""
        if($banco.Modello -ne 4){ $suffModello = "_ohlc" }
        $csvIS  = Join-Path $cartRis ($EA + "_" + $Simbolo + "_IS"  + $suffModello + "_" + $etichetta + ".csv")
        $csvOOS = Join-Path $cartRis ($EA + "_" + $Simbolo + "_OOS" + $suffModello + "_" + $etichetta + ".csv")
        $letteIS  = LeggiOpt $csvIS
        $letteOOS = LeggiOpt $csvOOS
        if($null -eq $letteIS -or $null -eq $letteOOS){ continue }
        $cel.Ris[$banco.Id] = [pscustomobject]@{
          Esito="RILETTA DA UN GIRO PRECEDENTE (il tester NON ha girato in questo giro)"
          Fresca="NO (CSV di un giro precedente, stesso pin)"
          GemIS=(Gemelli $letteIS); GemOOS=(Gemelli $letteOOS)
          DatiIS=$letteIS; DatiOOS=$letteOOS }
        Dico ("ricomposizione: cella " + $cel.Id + " banco " + $banco.Id + " RILETTA da un giro precedente") "DarkYellow"
      }
    }
  }

  # -------------------------------------------------------------------
  #  5. I GATE DI COLLAUDO, letti DALLE COLONNE.
  #  In ottimizzazione le Print girano sugli agent e non le legge
  #  nessuno (punti 34 e 99): tutto cio' che serve a giudicare deve
  #  essere una COLONNA, e qui diventa un gate.
  # -------------------------------------------------------------------
  Titolo "5. GATE DI COLLAUDO SULLE COLONNE"
  foreach($cel in $CELLE){
    foreach($banco in $BANCHI){
      if(-not $cel.Ris.ContainsKey($banco.Id)){ continue }
      $ris = $cel.Ris[$banco.Id]
      if($null -eq $ris.DatiIS -or $null -eq $ris.DatiOOS){ continue }
      $eti = "cella " + $cel.Id + " banco " + $banco.Id
      if($ris.GemIS -ne "IDENTICI" -or $ris.GemOOS -ne "IDENTICI"){
        [void]$Problemi.Add($eti + ": gemelli IS=" + $ris.GemIS + " OOS=" + $ris.GemOOS + " -- il banco NON e' deterministico, i numeri di questa cella non si leggono.")
      }
      foreach($tag in @("IS","OOS")){
        $dati = $ris.DatiIS
        if($tag -eq "OOS"){ $dati = $ris.DatiOOS }
        $eti2 = $eti + " (" + $tag + ")"
        if(@($dati).Count -ne 2){
          [void]$Problemi.Add($eti2 + ": " + @($dati).Count + " righe nel CSV invece di 2. E' la CACHE del tester, oppure lo sweep dei gemelli non ha spazzolato.")
        }
        # I GATE SI CONTANO SULLE RIGHE GEMELLE E SI SCRIVONO UNA VOLTA
        # SOLA. Prima erano dentro un foreach sulle righe: due gemelle
        # sporche producevano DUE messaggi identici, cioe' 192 PROBLEMI
        # per 12 difetti veri. Un elenco di problemi che nessuno legge
        # fino in fondo e' un elenco che non protegge niente.
        # Il conteggio ("su 2 righe gemelle") resta, perche' un difetto
        # su UNA sola gemella e' un fatto diverso da uno su tutte e due.
        $prima = @($dati)[0]
        $quanti = @($dati | Where-Object { $null -eq $_.AutoFail -or [double]$_.AutoFail -ne 0 }).Count
        if($quanti -gt 0){
          [void]$Problemi.Add($eti2 + ": 'Autotest Falliti' = " + (FmtN $prima.AutoFail) + " invece di 0 su " + $quanti + " righe gemelle (un -1 vuol dire autotest NON ESEGUITO, che NON e' 'passato'). Gli 8 blocchi del nucleo NON sono passati: i numeri di questa cella NON si leggono, si guarda il codice.")
        }
        $quanti = @($dati | Where-Object { $null -ne $_.Notti -and [double]$_.Notti -gt 0 }).Count
        if($quanti -gt 0){
          [void]$Problemi.Add($eti2 + ": 'Notti Attraversate' = " + (FmtN $prima.Notti) + " invece di 0 su " + $quanti + " righe gemelle. La chiusura forzata di fine sessione NON e' stata ermetica: il mandato FTMO 'mai overnight' non e' rispettato su questo simbolo. Si dichiara, non si interpreta.")
        }
        $quanti = @($dati | Where-Object { $null -ne $_.SprSalt -and [double]$_.SprSalt -gt 0 }).Count
        if($quanti -gt 0){
          [void]$Problemi.Add($eti2 + ": 'Ingressi Saltati Spread' = " + (FmtN $prima.SprSalt) + " su " + $quanti + " righe gemelle, ma il filtro di spread e' pinnato a 0 in tutti e quattro i file prova. IL FILE PROVA CHE HA GIRATO NON E' QUELLO CHE CREDIAMO.")
        }
        $quanti = @($dati | Where-Object { $null -eq $_.Finestra -or [int]$_.Finestra -ne $cel.FinestraAttesa }).Count
        if($quanti -gt 0){
          [void]$Problemi.Add($eti2 + ": 'Finestra Sessione' = " + (FmtN $prima.Finestra) + " su " + $quanti + " righe gemelle, la cella " + $cel.Id + " la vuole " + $cel.FinestraAttesa + ". E' IL GATE DELL'ABLAZIONE: se questo numero non e' quello atteso, l'interruttore NON e' arrivato dentro il tester e il confronto 00 contro 01 non vuol dire niente.")
        }
        $quanti = @($dati | Where-Object { $null -eq $_.MinFlat -or [int]$_.MinFlat -ne $cel.FlatAtteso }).Count
        if($quanti -gt 0){
          [void]$Problemi.Add($eti2 + ": 'Minuto Flat Calcolato' = " + (FmtN $prima.MinFlat) + " su " + $quanti + " righe gemelle, atteso " + $cel.FlatAtteso + " (630 = 10:30 con la finestra accesa, 1424 = 23:44 con la finestra spenta). Il flat NON e' caduto dove doveva.")
        }
        $quanti = @($dati | Where-Object { $null -eq $_.MinIni -or [int]$_.MinIni -ne 180 -or
                                           $null -eq $_.MinIng -or [int]$_.MinIng -ne 525 -or
                                           $null -eq $_.MinFine -or [int]$_.MinFine -ne 645 }).Count
        if($quanti -gt 0){
          [void]$Problemi.Add($eti2 + ": la finestra DAVVERO usata e' " + (FmtN $prima.MinIni) + "/" + (FmtN $prima.MinIng) + "/" + (FmtN $prima.MinFine) + " minuti su " + $quanti + " righe gemelle, attesi 180/525/645 (03:00 / 08:45 / 10:45 ORA SERVER). L'.ini non ha consegnato gli orari dichiarati.")
        }
        $quanti = @($dati | Where-Object { $null -eq $_.FlatAnt -or [int]$_.FlatAnt -ne 15 }).Count
        if($quanti -gt 0){
          [void]$Problemi.Add($eti2 + ": 'Flat Anticipo Min' = " + (FmtN $prima.FlatAnt) + " invece di 15 su " + $quanti + " righe gemelle.")
        }
        $quanti = @($dati | Where-Object { $null -ne $_.LotMin -and [double]$_.LotMin -gt 0 }).Count
        if($quanti -gt 0){
          [void]$Rilievi.Add($eti2 + ": 'Lotti Al Minimo' = " + (FmtN $prima.LotMin) + ". Su quegli ingressi il lotto e' stato alzato al minimo del broker, quindi il RISCHIO REALE e' piu' alto dello 0,65% dichiarato. Il numero si legge, ma con questa etichetta attaccata.")
        }
        $quanti = @($dati | Where-Object { $null -ne $_.IngTot -and [double]$_.IngTot -le 0 }).Count
        if($quanti -gt 0){
          [void]$Rilievi.Add($eti2 + ": ZERO ingressi su " + $quanti + " righe gemelle. Cella muta: o lo storico non copre la finestra, o il motore non si allinea mai. Guardare 'Barre Allineate' per distinguere le due cose.")
        }
        $quanti = @($dati | Where-Object { $null -ne $_.N -and [double]$_.N -lt 150 -and [double]$_.N -gt 0 }).Count
        if($quanti -gt 0){
          [void]$Rilievi.Add($eti2 + ": n = " + (FmtN $prima.N) + " operazioni, sotto la soglia dei 150. Emendamento della finestra regola A + valvola R59: su questa finestra il MERITO resta SOSPESO; il RISCHIO (peggior giornata, DD) si giudica lo stesso.")
        }
      }
    }
  }
  Dico "gate di collaudo eseguiti sulle colonne del CSV" "Green"

  # --- L'AUTOTEST DEL NUCLEO (8 blocchi) esce gia' in COLONNA, ed e'
  #     quello il gate. Le righe [AUTOTEST] dicono in piu' QUALE blocco
  #     ha ceduto, e vivono solo nelle Print degli agent: raccoglitore
  #     BEST-EFFORT, MAI un gate (punto 99). Il percorso dei log degli
  #     agent cambia fra le build di MT5.
  if(-not $SoloControllo){
    # LE RADICI SI COSTRUISCONO UNA PER UNA E SOLO SE LA BASE ESISTE: un
    # Join-Path su una variabile d'ambiente vuota non torna $null, LANCIA
    # -- e farebbe morire la corsa dentro un raccoglitore che e'
    # dichiarato BEST-EFFORT, cioe' l'esatto contrario del suo mestiere.
    $radici = @()
    if($dataFolder){  $radici += (Join-Path $dataFolder "Tester") }
    if($env:APPDATA){ $radici += (Join-Path $env:APPDATA "MetaQuotes\Tester") }
    $righeAT = @()
    foreach($radice in $radici){
      if(-not (Test-Path -LiteralPath $radice)){ continue }
      $logs = @(Get-ChildItem -LiteralPath $radice -Recurse -Filter *.log -ErrorAction SilentlyContinue | Where-Object { $_.LastWriteTime -ge $Avvio })
      foreach($lg in $logs){
        $righeAT += @(Select-String -LiteralPath $lg.FullName -SimpleMatch -Pattern "[AUTOTEST]" -ErrorAction SilentlyContinue | ForEach-Object { $_.Line })
      }
    }
    $Autotest = @($righeAT | Where-Object { $_ -match 'AllineaLondra' } | ForEach-Object { $_.Trim() } | Select-Object -Unique)
    if($Autotest.Count -gt 0){
      Set-Content -LiteralPath (Join-Path $Work "AUTOTEST_ALLINEALONDRA.txt") -Value ($Autotest -join "`r`n") -Encoding ASCII
      Dico ("righe [AUTOTEST] lette dai log degli agent: " + $Autotest.Count) "Green"
    }else{
      [void]$Rilievi.Add("righe [AUTOTEST] NON LETTE dai log degli agent (il percorso cambia fra le build di MT5). NON e' un guasto della corsa e NON e' un gate: il gate vero e' la colonna 'Autotest Falliti', che sta nella tabella del collaudo. Queste righe avrebbero detto in piu' QUALE degli 8 blocchi ha ceduto.")
    }
  }
}
catch{
  $Fatale = ("" + $_.Exception.Message)
  Write-Host ""
  Write-Host ("!!! FERMATO: " + $Fatale) -ForegroundColor Red
}

# =====================================================================
#  RACCOLTA -- SEMPRE, anche quando la corsa si e' fermata a meta'.
#  Regola di casa: i risultati finiscono sul Desktop e in uno zip.
# =====================================================================
Titolo "RACCOLTA"
# IL RIPRISTINO DELL'INCLUDE, SEMPRE (classe 116): vive QUI e non nel
# ramo felice, cosi' gira anche nel giro fermato da un gate o da una
# compilazione fallita. Il Ctrl+C lo copre la sentinella, al giro dopo.
if($IncInstallato){
  $Ripristino = RipristinaInclude $IncDest $IncBackup
  if($Ripristino -like "RIPRISTINATO*" -or $Ripristino -like "RIMOSSO*"){
    Remove-Item -LiteralPath $Sentinella -Force -ErrorAction SilentlyContinue
  }
  else{
    [void]$Problemi.Add("include NON rimesso a posto nel terminale: " + $Ripristino + ". La sentinella " + $Sentinella + " resta: il prossimo giro riprova all'avvio.")
  }
  Dico ("include nel terminale: " + $Ripristino) "Yellow"
}
if($IncDest -ne ""){
  $FotoDopo["include"] = Foto $IncDest
  $FotoDopo["mq5"]     = Foto (Join-Path $DataFolder ("MQL5\Experts\" + $EA + ".mq5"))
  $FotoDopo["ex5"]     = Foto (Join-Path $DataFolder ("MQL5\Experts\" + $EA + ".ex5"))
}
$Fine = Get-Date
$Cart = Join-Path $Dsk ("PASSO0_ALLINEALONDRA_" + $Modo + "_" + $Stamp)
New-Item -ItemType Directory -Force -Path $Cart | Out-Null

function Val2($ris,[string]$tag,[string]$campo){
  # legge un campo dalla PRIMA riga gemella della finestra chiesta.
  if($null -eq $ris){ return $null }
  $dati = $ris.DatiIS
  if($tag -eq "OOS"){ $dati = $ris.DatiOOS }
  if($null -eq $dati){ return $null }
  if(@($dati).Count -lt 1){ return $null }
  return $dati[0].$campo
}

$RefTxt = New-Object System.Collections.ArrayList
[void]$RefTxt.Add("=====================================================================")
[void]$RefTxt.Add(" PASSO 0 -- ALLINEA LONDRA (" + $EA + ") su " + $Simbolo + " " + $Periodo)
[void]$RefTxt.Add(" 4 celle x 2 banchi -- l'ASSE PRINCIPALE e' l'ABLAZIONE DELLA FINESTRA")
[void]$RefTxt.Add("=====================================================================")
[void]$RefTxt.Add("modo: " + $Modo + "   <- CONTROLLO = giro a vuoto (NON e' il risultato)")
[void]$RefTxt.Add("                      CORSA     = la misura")
[void]$RefTxt.Add("data: " + $Avvio.ToString("yyyy-MM-dd HH:mm:ss",$INV) + "   <- e' l'ORA DI AVVIO del giro, NON l'ora attuale (classe 110)")
[void]$RefTxt.Add("fine: " + $Fine.ToString("yyyy-MM-dd HH:mm:ss",$INV) + "   <- ora della raccolta: 'adesso' si confronta con QUESTA")
[void]$RefTxt.Add("pin:  " + $Pin)
[void]$RefTxt.Add("banco S: modello 1 (OHLC M1)    " + $DaScreening + " -> " + $Fino + "   split 40/60")
[void]$RefTxt.Add("         SOLO SCREENING, mai un verdetto. La finestra e' DERIVATA dal")
[void]$RefTxt.Add("         tetto delle 100.000 barre (M15 ~ 4 anni), NON misurata.")
[void]$RefTxt.Add("banco V: modello 4 (TICK REALI) " + $DaTick + " -> " + $Fino + "   split 40/60")
[void]$RefTxt.Add("         Il 2024.07.05 e' il pavimento dei tick BCM MISURATO SU GBPUSD,")
[void]$RefTxt.Add("         qui INFERITO per analogia: su EURUSD NON e' misurato.")
[void]$RefTxt.Add("deposito: " + $Deposito + "    rischio: " + $Baseline["InpRiskPercent"] + "% (letto dalla baseline dichiarata e pinnato nei file prova, non da un parametro della riga)")
[void]$RefTxt.Add("terminale: " + $TermScelto)
[void]$RefTxt.Add("criterio di scelta: " + $TermCrit + "   <- scelto per un FATTO e PASSATO al driver generico (classe 115)")
[void]$RefTxt.Add("cartella dati: " + $(if($DataFolder -ne ""){$DataFolder}else{"n/d"}))
[void]$RefTxt.Add("include: " + $Include)
[void]$RefTxt.Add("include a fine giro: " + $Ripristino)
[void]$RefTxt.Add("compilazione: " + $Compilato + "   <- tre stati: NON TENTATA / FALLITA / OK (classe 94-ter)")
[void]$RefTxt.Add("")
[void]$RefTxt.Add("FOTO DEL TERMINALE, PRIMA e DOPO (classe 116: la prova sta nella foto):")
foreach($kF in @("include","mq5","ex5")){
  $etF = @{ "include"=("Include\" + $IncNostro); "mq5"=("Experts\" + $EA + ".mq5"); "ex5"=("Experts\" + $EA + ".ex5") }[$kF]
  $pF = "NON FOTOGRAFATO (il giro si e' fermato prima di scegliere il terminale)"; if($FotoPrima.ContainsKey($kF)){ $pF = $FotoPrima[$kF] }
  $dF = "NON FOTOGRAFATO"; if($FotoDopo.ContainsKey($kF)){ $dF = $FotoDopo[$kF] }
  $notaF = ""
  if($kF -eq "include" -and $FotoPrima.ContainsKey($kF) -and $FotoDopo.ContainsKey($kF)){
    if($pF -eq $dF){ $notaF = "   -> INVARIATO (com'era prima)" } else { $notaF = "   -> DIVERSO: vedi 'include a fine giro' e i PROBLEMI" }
  }
  if($kF -ne "include"){ $notaF = "   -> scritto apposta da questo giro (e' il banco: lo scrive anche il driver generico)" }
  [void]$RefTxt.Add("  " + $etF)
  [void]$RefTxt.Add("     prima: " + $pF)
  [void]$RefTxt.Add("     dopo:  " + $dF + $notaF)
}
[void]$RefTxt.Add("")
[void]$RefTxt.Add("QUESTO NON E' UN ROUND E NON DA' NESSUN VERDETTO.")
[void]$RefTxt.Add("E' un CONTA-OPERAZIONI: misura la FREQUENZA del motore prima di")
[void]$RefTxt.Add("qualunque lettura di merito (valvola R59, Emendamento regola A). Il PF")
[void]$RefTxt.Add("qui sotto si LEGGE ma NON si giudica: non ci sono criteri di merito")
[void]$RefTxt.Add("firmati e quattro celle non sono un round. Nessuna sedia viva e' stata")
[void]$RefTxt.Add("toccata: magic vergini 7776xx, AllowLiveTrading=false in ogni .ini.")
[void]$RefTxt.Add("")
[void]$RefTxt.Add("I TRE ESITI, congelati PRIMA dei numeri (testa di")
[void]$RefTxt.Add("prove/PASSO0_ALLINEALONDRA_00_finestra.txt):")
[void]$RefTxt.Add("  A. n >= 150 per finestra -> campione presente, il round si puo' disegnare")
[void]$RefTxt.Add("  B. n <  150              -> MERITO SOSPESO, il RISCHIO si giudica lo stesso")
[void]$RefTxt.Add("  C. n enorme              -> la manopola e' la FINESTRA, non il rischio")
[void]$RefTxt.Add("                              e non un filtro nuovo appiccicato sopra")
[void]$RefTxt.Add("")

# --- TABELLA 1: IL CONTEGGIO. E' IL PASSO 0.
[void]$RefTxt.Add("---------------------------------------------------------------------")
[void]$RefTxt.Add(" TABELLA 1 -- IL CONTEGGIO (e' questo il PASSO 0)")
[void]$RefTxt.Add("---------------------------------------------------------------------")
[void]$RefTxt.Add("cella          bk fin |      n | IngTot  Long Short | BarreAllin GgTetto")
foreach($cel in $CELLE){
  foreach($banco in $BANCHI){
    $ris = $null
    if($cel.Ris.ContainsKey($banco.Id)){ $ris = $cel.Ris[$banco.Id] }
    foreach($tag in @("IS","OOS")){
      # una riga per FINESTRA: 'n' e' il numero di operazioni DI QUELLA
      # finestra, e tutte le colonne accanto sono della stessa finestra.
      # (Prima qui c'erano due colonne 'n IS' e 'n OOS' ripetute uguali su
      #  tutte e due le righe: due numeri giusti messi dove non si
      #  possono leggere.)
      $riga = ("{0,-14} {1,-2} {2,-3} |{3,7} |{4,7}{5,6}{6,6} |{7,11}{8,8}" -f `
               $cel.Id, $banco.Id, $tag,
               (FmtN (Val2 $ris $tag "N")),
               (FmtN (Val2 $ris $tag "IngTot")), (FmtN (Val2 $ris $tag "IngLong")), (FmtN (Val2 $ris $tag "IngShort")),
               (FmtN (Val2 $ris $tag "Allin")), (FmtN (Val2 $ris $tag "Tetto")))
      [void]$RefTxt.Add($riga)
    }
    # LO STATO DI PARTENZA SI SCRIVE PER RIGA, NON PER TABELLA (punto 94):
    # "non eseguita e nessun CSV" e "eseguita e riletta" sono due frasi
    # diverse, e una sola delle due e' vera per ogni cella. Un "NO" secco
    # qui direbbe "il tester non ha girato" anche dove non e' mai stato
    # nemmeno chiesto di girare.
    $esito = "NON ESEGUITA in questo giro e NESSUN CSV trovato sul disco"
    $fresca = "NON PERTINENTE (cella mai lanciata in questo giro, e nessun CSV di un giro precedente)"
    if($null -ne $ris){ $esito = $ris.Esito; $fresca = $ris.Fresca }
    [void]$RefTxt.Add("               esito: " + $esito)
    [void]$RefTxt.Add("               il tester ha girato in questo giro: " + $fresca)
  }
}
[void]$RefTxt.Add("")
[void]$RefTxt.Add("COME SI LEGGE LA TABELLA 1 -- tre avvertenze, non tre note:")
[void]$RefTxt.Add(" 1. 'BarreAllin' NON e' contato prima di TUTTI i cancelli, ed e' la cosa")
[void]$RefTxt.Add("    da sapere prima di guardarlo. LETTO NEL SORGENTE: gBarreAllineate++")
[void]$RefTxt.Add("    (riga 867) sta dentro ValutaBarraChiusa, ma OnTick esce PRIMA con")
[void]$RefTxt.Add("    'if(DevoFlat_Calc(...)){ ChiudiTutto(); return; }' (righe 622-623).")
[void]$RefTxt.Add("    Il FLAT e' un cancello del contenitore, ed e' proprio quello che")
[void]$RefTxt.Add("    l'ablazione sposta. Quindi la FINESTRA DI CONTEGGIO cambia da cella")
[void]$RefTxt.Add("    a cella:")
[void]$RefTxt.Add("       00_finestra   -> conta le barre di 03:00-10:29  (~30 barre M15/gg)")
[void]$RefTxt.Add("       01_nofinestra -> conta le barre di 00:00-23:43  (~95 barre M15/gg)")
[void]$RefTxt.Add("    >>> IL RAPPORTO 01/00 VALE ~3,2 PER COSTRUZIONE e NON dice niente")
[void]$RefTxt.Add("        sul motore: quanto spesso il motore si allinea e' una proprieta'")
[void]$RefTxt.Add("        del mercato, IDENTICA nelle due celle. NON si confronta.")
[void]$RefTxt.Add("    DENTRO UNA CELLA il rapporto IngTot/BarreAllin si legge, e dice")
[void]$RefTxt.Add("    quanto mordono slot, tetto e finestra d'ingresso. Ma una barra")
[void]$RefTxt.Add("    allineata NON e' un'occasione persa: l'allineamento e' uno STATO e")
[void]$RefTxt.Add("    resta vero per molte barre, quindi la stessa spinta e' contata")
[void]$RefTxt.Add("    decine di volte.")
[void]$RefTxt.Add(" 2. n(02_long) + n(03_short) NON FA n(00_finestra), e NON e' un guasto.")
[void]$RefTxt.Add("    Misurato nel sorgente: SegnaleAllineamento() (riga 866) filtra gia' il")
[void]$RefTxt.Add("    lato; SUBITO DOPO arrivano lo slot ('if(ContaPosizioni() >=")
[void]$RefTxt.Add("    InpMaxPositions) return', riga 871) e il tetto, che sono UNO SOLO per")
[void]$RefTxt.Add("    i due lati (gTradesToday). Nel 00 una posizione long occupa lo slot e")
[void]$RefTxt.Add("    blocca uno short che sarebbe entrato. Con un lato spento")
[void]$RefTxt.Add("    slot e tetto restano liberi: la somma sara' MAGGIORE del congiunto.")
[void]$RefTxt.Add(" 3. Le colonne Long/Short del 00_finestra e le celle 02/03 rispondono a DUE")
[void]$RefTxt.Add("    domande diverse: le prime dicono quanto trada ogni lato NELLA")
[void]$RefTxt.Add("    configurazione CHE ANDREBBE IN CAMPO, le seconde quanto tradano da soli.")
[void]$RefTxt.Add("    Non si confrontano fra loro.")
[void]$RefTxt.Add("")

# --- TABELLA 2: i numeri che si leggono e non si giudicano.
[void]$RefTxt.Add("---------------------------------------------------------------------")
[void]$RefTxt.Add(" TABELLA 2 -- I NUMERI CHE SI LEGGONO MA NON SI GIUDICANO")
[void]$RefTxt.Add("---------------------------------------------------------------------")
[void]$RefTxt.Add("cella          bk |  PF IS  PF OOS  DD OOS%   Prof OOS  PeggGG%  UscFlat/UscMerc")
foreach($cel in $CELLE){
  foreach($banco in $BANCHI){
    $ris = $null
    if($cel.Ris.ContainsKey($banco.Id)){ $ris = $cel.Ris[$banco.Id] }
    [void]$RefTxt.Add(("{0,-14} {1,-2} |{2,7}{3,8}{4,9}{5,11}{6,9}  {7}/{8}" -f `
      $cel.Id, $banco.Id,
      (Fmt2 (Val2 $ris "IS" "Pf")), (Fmt2 (Val2 $ris "OOS" "Pf")),
      (Fmt2 (Val2 $ris "OOS" "Dd")), (FmtE (Val2 $ris "OOS" "Profit")),
      (FmtPg (Val2 $ris "OOS" "Pg")),
      (FmtN (Val2 $ris "OOS" "UscFlat")), (FmtN (Val2 $ris "OOS" "UscMerc"))))
  }
}
[void]$RefTxt.Add("")
[void]$RefTxt.Add("'PeggGG%' e' la PEGGIOR GIORNATA in % di equity: e' IL numero della riga")
[void]$RefTxt.Add("prop (muro FTMO giornaliero -5.000 su 100k = -5%), e si riporta SEMPRE,")
[void]$RefTxt.Add("anche quando il merito e' sospeso (Emendamento regola B: il campione")
[void]$RefTxt.Add("sottile sospende il MERITO, mai il RISCHIO).")
[void]$RefTxt.Add("'UscFlat/UscMerc' dice CHI ha chiuso: la chiusura forzata di fine")
[void]$RefTxt.Add("sessione, oppure stop/take. Un rapporto sbilanciato sul flat vuol dire")
[void]$RefTxt.Add("che il motore vive quasi solo dentro la sessione e che i target quasi")
[void]$RefTxt.Add("non si toccano: e' una descrizione del motore, non un giudizio.")
[void]$RefTxt.Add("")

# --- TABELLA 3: il collaudo, in colonne.
[void]$RefTxt.Add("---------------------------------------------------------------------")
[void]$RefTxt.Add(" TABELLA 3 -- IL COLLAUDO, IN COLONNE (non nella scheda Esperti)")
[void]$RefTxt.Add("---------------------------------------------------------------------")
[void]$RefTxt.Add("cella          bk | AutoFail Notti SprSalt LotMin | Fin MinIni MinIng MinFin FlatAnt MinFlat")
foreach($cel in $CELLE){
  foreach($banco in $BANCHI){
    $ris = $null
    if($cel.Ris.ContainsKey($banco.Id)){ $ris = $cel.Ris[$banco.Id] }
    [void]$RefTxt.Add(("{0,-14} {1,-2} |{2,9}{3,6}{4,8}{5,7} |{6,4}{7,7}{8,7}{9,7}{10,8}{11,8}" -f `
      $cel.Id, $banco.Id,
      (FmtN (Val2 $ris "OOS" "AutoFail")), (FmtN (Val2 $ris "OOS" "Notti")),
      (FmtN (Val2 $ris "OOS" "SprSalt")), (FmtN (Val2 $ris "OOS" "LotMin")),
      (FmtN (Val2 $ris "OOS" "Finestra")), (FmtN (Val2 $ris "OOS" "MinIni")),
      (FmtN (Val2 $ris "OOS" "MinIng")), (FmtN (Val2 $ris "OOS" "MinFine")),
      (FmtN (Val2 $ris "OOS" "FlatAnt")), (FmtN (Val2 $ris "OOS" "MinFlat"))))
    [void]$RefTxt.Add("               gemelli: IS=" + $(if($null -ne $ris){$ris.GemIS}else{"NON ESEGUITA"}) + "  OOS=" + $(if($null -ne $ris){$ris.GemOOS}else{"NON ESEGUITA"}))
  }
}
[void]$RefTxt.Add("")
[void]$RefTxt.Add("(la tabella 3 mostra la finestra OOS; i gate girano su TUTTE E DUE le")
[void]$RefTxt.Add(" finestre e su TUTTE E DUE le righe gemelle, e cio' che non torna finisce")
[void]$RefTxt.Add(" nei PROBLEMI qui sotto.)")
[void]$RefTxt.Add("")
[void]$RefTxt.Add("COME SI LEGGE OGNI COLONNA:")
[void]$RefTxt.Add("  AutoFail = 0  -> gli 8 blocchi dell'autotest del nucleo sono passati:")
[void]$RefTxt.Add("                   i numeri delle tabelle 1 e 2 SI LEGGONO.")
[void]$RefTxt.Add("           > 0  -> DIVERGE: i numeri NON si leggono, si guarda il codice.")
[void]$RefTxt.Add("           = -1 -> autotest NON ESEGUITO, che NON e' 'passato'.")
[void]$RefTxt.Add("  Notti    = 0  -> la chiusura forzata e' stata ERMETICA. Un valore > 0")
[void]$RefTxt.Add("                   e' una posizione viva a cavallo della notte: il mandato")
[void]$RefTxt.Add("                   FTMO 'mai overnight' NON e' rispettato. Va detto.")
[void]$RefTxt.Add("  SprSalt  = 0  -> canarino: il filtro di spread e' pinnato a 0 in tutti")
[void]$RefTxt.Add("                   e quattro i file prova. Se e' > 0, il file prova che ha")
[void]$RefTxt.Add("                   girato NON e' quello che crediamo.")
[void]$RefTxt.Add("  LotMin   > 0  -> su quegli ingressi il lotto e' salito al minimo del")
[void]$RefTxt.Add("                   broker: il rischio REALE e' piu' alto dello 0,65%.")
[void]$RefTxt.Add("  Fin           -> LA CELLA DI ABLAZIONE, in colonna: 1 = finestra accesa,")
[void]$RefTxt.Add("                   0 = spenta. E' la prova che l'interruttore e' arrivato")
[void]$RefTxt.Add("                   dentro il tester e non e' stato reso inerte.")
[void]$RefTxt.Add("  MinIni/MinIng/MinFin -> la finestra DAVVERO usata, in minuti del giorno")
[void]$RefTxt.Add("                   (attesi 180/525/645 = 03:00/08:45/10:45 ORA SERVER).")
[void]$RefTxt.Add("  MinFlat       -> il minuto in cui il flat e' caduto davvero: 630 (10:30)")
[void]$RefTxt.Add("                   con la finestra accesa, 1424 (23:44) con la finestra")
[void]$RefTxt.Add("                   spenta. Il flat NON e' disattivabile da nessun input.")
[void]$RefTxt.Add("")
[void]$RefTxt.Add("--- RIGHE [AUTOTEST] DAGLI AGENT (best-effort, MAI un gate) ---")
if($Autotest.Count -gt 0){ foreach($linea in $Autotest){ [void]$RefTxt.Add("  " + $linea) } }
else { [void]$RefTxt.Add("  NON LETTE (vedi RILIEVI). Non e' un verdetto: e' un'assenza. Il gate vero e' la colonna AutoFail della tabella 3.") }
[void]$RefTxt.Add("")

# --- L'ABLAZIONE: il confronto per cui il round esiste.
[void]$RefTxt.Add("=====================================================================")
[void]$RefTxt.Add(" L'ABLAZIONE -- 00_finestra CONTRO 01_nofinestra")
[void]$RefTxt.Add(" (accostata dal driver, NON adjudicata: e' un giudizio, non un conto)")
[void]$RefTxt.Add("=====================================================================")
[void]$RefTxt.Add("LA DOMANDA (dossier P2): il CONTENITORE (sessione + flat + tetto) E' il")
[void]$RefTxt.Add("motore, oppure questo e' un doppione di ABTG_SuperWave / ABTG_CrossEma /")
[void]$RefTxt.Add("ABTG_GoldenCross con un orologio addosso?")
[void]$RefTxt.Add("  se il nudo va UGUALE -> la sessione non serve, il candidato e' un doppione")
[void]$RefTxt.Add("  se il nudo CROLLA    -> il contenitore E' il motore")
[void]$RefTxt.Add("")
$celA = @($CELLE | Where-Object { $_.Id -eq "00_finestra" })[0]
$celB = @($CELLE | Where-Object { $_.Id -eq "01_nofinestra" })[0]
foreach($banco in $BANCHI){
  $risA = $null; $risB = $null
  if($celA.Ris.ContainsKey($banco.Id)){ $risA = $celA.Ris[$banco.Id] }
  if($celB.Ris.ContainsKey($banco.Id)){ $risB = $celB.Ris[$banco.Id] }
  [void]$RefTxt.Add("  banco " + $banco.Id + "  (" + $banco.Desc + ")")
  [void]$RefTxt.Add("                    n OOS   PF OOS   DD OOS%    Prof OOS   PeggGG%  BarreAllin")
  [void]$RefTxt.Add(("    00_finestra  {0,7}{1,9}{2,10}{3,12}{4,10}{5,12}" -f `
    (FmtN (Val2 $risA "OOS" "N")), (Fmt2 (Val2 $risA "OOS" "Pf")), (Fmt2 (Val2 $risA "OOS" "Dd")),
    (FmtE (Val2 $risA "OOS" "Profit")), (FmtPg (Val2 $risA "OOS" "Pg")), (FmtN (Val2 $risA "OOS" "Allin"))))
  [void]$RefTxt.Add(("    01_nofinestra{0,7}{1,9}{2,10}{3,12}{4,10}{5,12}" -f `
    (FmtN (Val2 $risB "OOS" "N")), (Fmt2 (Val2 $risB "OOS" "Pf")), (Fmt2 (Val2 $risB "OOS" "Dd")),
    (FmtE (Val2 $risB "OOS" "Profit")), (FmtPg (Val2 $risB "OOS" "Pg")), (FmtN (Val2 $risB "OOS" "Allin"))))
  if($null -eq $risA -or $null -eq $risB -or $null -eq $risA.DatiOOS -or $null -eq $risB.DatiOOS){
    [void]$RefTxt.Add("    >>> CONFRONTO NON MISURABILE su questo banco: manca almeno una delle due")
    [void]$RefTxt.Add("        celle. 'Non ho misurato' e 'ho misurato e non c'e' differenza' sono")
    [void]$RefTxt.Add("        due cose diverse, e solo la seconda chiude una pista.")
  }
  [void]$RefTxt.Add("")
}
[void]$RefTxt.Add("    ^^^ la colonna BarreAllin di queste due righe NON si confronta: ha due")
[void]$RefTxt.Add("        finestre di conteggio diverse (vedi avvertenza 1 della tabella 1).")
[void]$RefTxt.Add("!!! E LA DIFFERENZA NON E' UN COSTO PURO. Va letta come un PACCHETTO:")
[void]$RefTxt.Add("      (finestra d'ingresso rimossa) + (ancoraggio a MEZZANOTTE SERVER)")
[void]$RefTxt.Add("    Con la finestra spenta il TETTO di 2 ingressi al giorno resta acceso,")
[void]$RefTxt.Add("    quindi il motore NON opera distribuito su tutto il giorno: prende i")
[void]$RefTxt.Add("    PRIMI DUE segnali dopo il cambio di giornata del server. Su un")
[void]$RefTxt.Add("    allineamento di medie -- che e' uno STATO e resta vero per molte barre")
[void]$RefTxt.Add("    -- quei due ingressi cadono tipicamente subito dopo le 00:00 SERVER.")
[void]$RefTxt.Add("    Chi volesse il motore davvero libero deve alzare ANCHE InpMaxTradesDay:")
[void]$RefTxt.Add("    sarebbe una cella a DUE righe mosse, cioe' un'altra misura, e QUESTO")
[void]$RefTxt.Add("    GIRO NON CE L'HA. La colonna 'GgTetto' (tabella 1) dice quante giornate")
[void]$RefTxt.Add("    il tetto ha davvero morso.")
[void]$RefTxt.Add("")
[void]$RefTxt.Add("!!! E IL CONFRONTO SI LEGGE SU TUTTI E DUE I BANCHI, non su uno.")
[void]$RefTxt.Add("    Il banco S (OHLC M1) e' SOLO SCREENING e non autorizza nessuna")
[void]$RefTxt.Add("    proposta; il banco V ha il riempimento vero ma un solo regime e un")
[void]$RefTxt.Add("    campione piu' sottile. Se i due banchi si contraddicono, NON e' un")
[void]$RefTxt.Add("    errore: e' la tensione gia' nota del progetto (o la finestra lunga o il")
[void]$RefTxt.Add("    riempimento vero, mai tutti e due), e si dichiara.")
[void]$RefTxt.Add("")
[void]$RefTxt.Add("!!! QUELLO CHE QUESTO GIRO NON MISURA, dichiarato:")
[void]$RefTxt.Add("    - la SCORRELAZIONE dalle sedie long della flotta. Il dossier avvisa che")
[void]$RefTxt.Add("      questo e' un motore a favore del trend, quindi nelle mattine di trend")
[void]$RefTxt.Add("      forte e' CORRELATO alle sedie long gia' in campo. Si misura sulle")
[void]$RefTxt.Add("      serie per-trade, e non si fa qui;")
[void]$RefTxt.Add("    - il COSTO (spread). Il filtro di spread e' SPENTO apposta, per misurare")
[void]$RefTxt.Add("      il motore nudo. NESSUNA CELLA SI PROMUOVE COSI' (lezione R55);")
[void]$RefTxt.Add("    - l'ORA GIUSTA. Gli orari sono i numeri letterali del Pine letti come ora")
[void]$RefTxt.Add("      server: un PUNTO DI PARTENZA dichiarato, non una conversione di fuso.")
[void]$RefTxt.Add("      La sessione e' l'asse del PRIMO ROUND VERO, e quello e' un altro giro.")
[void]$RefTxt.Add("      MISURATO con la regola di casa (server = ora italiana - 1, ancora:")
[void]$RefTxt.Add("      DAX 09:00 IT = 08:00 server): l'orologio del server BCM segna la")
[void]$RefTxt.Add("      STESSA ora di Londra tutto l'anno. Quindi 03:00-08:45 SERVER sono")
[void]$RefTxt.Add("      03:00-08:45 DI LONDRA, e Londra apre alle 08:00: la finestra")
[void]$RefTxt.Add("      d'ingresso contiene 45 MINUTI DI LONDRA SU 5h45. Questo giro conta")
[void]$RefTxt.Add("      quindi operazioni prese quasi tutte PRIMA dell'apertura di Londra,")
[void]$RefTxt.Add("      mentre la tesi del candidato parla delle 'prime ore di Londra'.")
[void]$RefTxt.Add("      Il conteggio vale; l'etichetta no. Il flat delle 10:30 server e'")
[void]$RefTxt.Add("      invece meta' mattina di Londra, come vuole la tesi.")
[void]$RefTxt.Add("")
if($Fatale -ne ""){
  [void]$RefTxt.Add("!!! FERMATO: " + $Fatale)
  [void]$RefTxt.Add("")
}
[void]$RefTxt.Add("PROBLEMI: " + $Problemi.Count)
foreach($problema in $Problemi){ [void]$RefTxt.Add("  - " + $problema) }
[void]$RefTxt.Add("RILIEVI: " + $Rilievi.Count)
foreach($rilievo in $Rilievi){ [void]$RefTxt.Add("  - " + $rilievo) }
[void]$RefTxt.Add("")
[void]$RefTxt.Add('COME SI RIPRENDE: si riparte dalla pagina')
[void]$RefTxt.Add('righe/RIGA_ALLINEALONDRA_DA_MANDARE.md, che e'' l''UNICO posto in cui la')
[void]$RefTxt.Add('riga di lancio esiste (CHECKLIST punto 100). NON da questa riga: $p e')
[void]$RefTxt.Add('$pin nascono dentro il blocco e non sopravvivono.')
[void]$RefTxt.Add('Il referto e'' SEMPRE D''INSIEME: anche con -SoloCella la riga rilegge i')
[void]$RefTxt.Add('CSV gia'' presenti di tutte le celle, quindi il confronto 00 contro 01')
[void]$RefTxt.Add('esce anche se le due celle sono girate in serate diverse.')
[void]$RefTxt.Add('ATTENZIONE: con un PIN DIVERSO la riga CANCELLA risultati_prove\ e le')
[void]$RefTxt.Add('celle gia'' girate SONO PERSE. Un ri-pin a meta'' round = si ricomincia.')

$refPath = Join-Path $Cart "REFERTO_PASSO0_ALLINEALONDRA.txt"
Set-Content -LiteralPath $refPath -Value ($RefTxt -join "`r`n") -Encoding ASCII
Write-Host ($RefTxt -join "`r`n")

# --- gli artefatti: copiati PER NOME, e su TUTTE le celle (il referto e'
#     d'insieme, quindi lo zip deve contenere i CSV che lo sostengono).
foreach($nomeF in @("AUTOTEST_ALLINEALONDRA.txt","COMPILAZIONE_FALLITA.log")){
  $src = Join-Path $Work $nomeF
  if(Test-Path -LiteralPath $src){ Copy-Item -LiteralPath $src -Destination $Cart -Force }
}
foreach($cel in $CELLE){
  $src = Join-Path $Prove $cel.Prova
  if(Test-Path -LiteralPath $src){ Copy-Item -LiteralPath $src -Destination $Cart -Force }
  foreach($banco in $BANCHI){
    $suffModello = ""
    if($banco.Modello -ne 4){ $suffModello = "_ohlc" }
    foreach($tag in @("IS","OOS")){
      $f = Join-Path $Work ("risultati_prove\" + $EA + "\" + $EA + "_" + $Simbolo + "_" + $tag + $suffModello + "_" + $cel.Id + "_" + $banco.Id + ".csv")
      if(Test-Path -LiteralPath $f){ Copy-Item -LiteralPath $f -Destination $Cart -Force }
    }
  }
}
$zip = $Cart + ".zip"
Remove-Item -LiteralPath $zip -Force -ErrorAction SilentlyContinue
Compress-Archive -Path (Join-Path $Cart "*") -DestinationPath $zip -Force
Write-Host ""
Write-Host ("CARTELLA: " + $Cart) -ForegroundColor Green
Write-Host ("ZIP DA MANDARE: " + $zip) -ForegroundColor Green
Write-Host "FILE ATTESI NELLO ZIP: REFERTO_PASSO0_ALLINEALONDRA.txt + i 4 file prova + i CSV IS/OOS delle celle girate" -ForegroundColor Gray

if($Fatale -ne ""){ Write-Host "ESITO: FERMATO" -ForegroundColor Red; exit 1 }
if($Problemi.Count -gt 0){ Write-Host "ESITO: COMPLETATO CON PROBLEMI" -ForegroundColor Yellow; exit 1 }
Write-Host ("ESITO: " + $Modo + " COMPLETATO") -ForegroundColor Green
exit 0
