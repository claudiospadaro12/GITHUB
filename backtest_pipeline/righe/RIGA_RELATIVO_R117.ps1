# =====================================================================
#  MARCATORE_RIGA_RELATIVO_R117_v3
#  RIGA_RELATIVO_R117.ps1 -- IL ROUND R117: PRIMA MISURA DI MERITO DEL
#  CANDIDATO "RELATIVO", A TICK REALI.
#
#  ATTENZIONE, ED E' LA PRIMA COSA DA SAPERE: QUI L'EA APRE ORDINI.
#  Le due righe che l'hanno preceduto (RIGA_SONDARELATIVO _v5 e
#  RIGA_SONDARELATIVO_ESTESA _v1) facevano girare un CONTATORE PURO che
#  non apriva niente, e i loro gate lo PRETENDEVANO ("0 chiamate di
#  trading", "0 #include"). Qui quei due gate sarebbero SBAGLIATI e
#  sono stati SOSTITUITI, non tolti:
#     - #include atteso = 1 (Trade/Trade.mqh), non 0;
#     - al posto di "contatore puro" c'e' il GATE HEDGE-SAFE: zero
#       occorrenze dei pattern che su conto hedging leggono o scrivono
#       LA POSIZIONE DEL VICINO (PositionSelect(_Symbol),
#       PositionClose(_Symbol), PositionModify(_Symbol),
#       PositionClosePartial(_Symbol)). Fonte:
#       report\AUDIT_POSITIONSELECT_HEDGING_2026-09-03.md, 126 file
#       censiti, e la frase che conta: il MEZZO fix (lettura corretta +
#       scrittura per simbolo) e' PIU' PERICOLOSO del bug originale.
#
#  SEI CORSE, e ognuna ha un compito diverso -- non sono sei tentativi:
#    -Prova D30        D30EUR magic 774601   LA MISURA
#    -Prova NAS        NASUSD magic 774602   LA MISURA
#    -Prova D30_GEM    identico a D30, magic 774611   GEMELLO
#    -Prova NAS_GEM    identico a NAS, magic 774612   GEMELLO
#         >>> i gemelli servono a UNA cosa: due passate con gli stessi
#         input e magic diverso devono venire IDENTICHE AL CENTESIMO.
#         Se divergono il banco e' sporco e il round NON SI LEGGE,
#         prima ancora di guardare un profitto.
#    -Prova D30_PORTO  InpModoSonda=true, NESSUN ORDINE
#    -Prova NAS_PORTO  InpModoSonda=true, NESSUN ORDINE
#         >>> il COLLAUDO DEL PORTO, ed e' il gate piu' importante del
#         round: i "Segnali Grezzi Long/Short" devono venire IDENTICI,
#         ALLA CIFRA, agli "Attraversamenti Grezzi" del passo 0 sulla
#         stessa cella e sulla stessa finestra. Lo z-score si calcola su
#         BARRE CHIUSE, ma a Modello 4 le barre sono COSTRUITE dai tick e
#         il passo 0 girava a Modello 2: la differenza non e' mai stata
#         misurata (classe 123). Se non combaciano (fuori tolleranza), e'
#         un RILIEVO a tre cause (nucleo trasportato male / modello del
#         tester diverso / finestra effettiva diversa) da sciogliere
#         PRIMA di leggere il conto economico, non una bocciatura secca
#         del nucleo. Gli attesi
#         vanno nella tabella $PORTO qui sotto, e finche' valgono -1 le
#         due corse PORTO NON PARTONO (gate esplicito): un collaudo che
#         non confronta niente uscirebbe verde senza aver misurato
#         niente. I due numeri stanno nel CSV OPTFRAME del passo 0
#         (griglia ESTESA), riga N=40/sigma=1.35 -- NON nei referti
#         archiviati, che per le 90 celle stampano gli eseguibili.
# ---------------------------------------------------------------------
#  IL BANCO
#    MODELLO 4 = OGNI TICK BASATO SU TICK REALI. E' il punto del round:
#    sul tick reale lo spread NON si assume, SI PAGA.
#    FINESTRA 2024.09.26 -> 2026.06.30 = pavimento MISURATO dei tick
#    reali degli indici BCM, e la STESSA finestra del passo 0 (per
#    questo il collaudo del porto e' possibile).
#    SPLIT 40/60. IS e OOS NON selezionano niente (la cella e'
#    congelata, non c'e' nessuna griglia): sono DUE CAMPIONI
#    INDIPENDENTI DELLA STESSA CONFIGURAZIONE.
#    RAM: a tick reali il vincolo vero non e' il tetto delle barre, e'
#    la memoria. MASSIMO 4 AGENTI (lezione del 01/09, "no memory for
#    ticks generating"). La riga NON puo' imporlo: lo dice la pagina.
# ---------------------------------------------------------------------
#  I CANCELLI DI MERITO, CONGELATI PRIMA DEI NUMERI, E RICALCOLATI QUI
#  DAI NUMERI GREZZI (non ci si fida di una colonna di comodo):
#    A1  aspettativa OOS >= 0,075 R (H8, FIRMA 2 del 31/08)
#    A2  profit factor OOS >= 1,15
#    A3  segno del profitto COERENTE fra IS e OOS, e PF IS > 1,00
#    A4  drawdown di equity OOS <= 8,0%   (muro prop 10% meno il 20%)
#    A5  peggior giornata non peggiore di -4,0% (pausa Guardian)
#    A6  n >= 150 in IS E in OOS          (Emendamento, regola A)
#    A7  quota sotto 60 secondi < 25%     (vincolo prop P5)
#    BOCCIATURA SECCA: E < 0,050R | PF < 1,10 | IS negativo |
#      DD > 10,0% | peggior giornata < -5,0%. Le ultime due bocciano
#      PER RISCHIO qualunque sia il PF e qualunque sia n.
#    n < 30 NON e' una bocciatura: e' NON MISURABILE.
#    Fra "passa" e "bocciata secca" c'e' SEMPRE una terza fascia
#    esplicita (ZONA MORTA): nessuna proposta, nessuna bocciatura.
# ---------------------------------------------------------------------
#  COSA QUESTO ROUND NON PUO' DIRE, e va scritto nel referto:
#    - UN SOLO REGIME (toro). Emendamento regola C: NON soddisfatta.
#      DA QUESTO ROUND NON ESCE UNA SEDIA, al massimo una CANDIDATA.
#    - L'OOS NON e' un vero out-of-sample: la cella e' stata scelta
#      guardando una misura che copre l'intera finestra, OOS compreso.
#    - lo stop reale CAMBIA la popolazione misurata dal passo 0: questo
#      round NON valida quei numeri, ne produce di nuovi.
# ---------------------------------------------------------------------
#  >>> SENTINELLA + FOTO (classe 116), EXIT CODE A TRE STATI (classe
#      108), CSV DATATO PRIMA DI LEGGERLO, TIMBRO data: = ORA DI AVVIO
#      (classe 110), RACCOLTA CHE GIRA SEMPRE: tutto identico alle due
#      righe della sonda, da cui questa e' derivata.
#
#  LA RIGA CHE SI INCOLLA sta in righe\RIGA_RELATIVO_R117_DA_MANDARE.md
# =====================================================================
[CmdletBinding()]
param(
  # -Pin NON ha default: un default silenzioso ("lavoro") farebbe girare
  #  la punta del branch spacciandola per un commit congelato.
  [string]$Pin              = "",
  # -Prova: UNO dei SEI nomi ammessi. Obbligatorio.
  [ValidateSet("D30","NAS","D30_GEM","NAS_GEM","D30_PORTO","NAS_PORTO")]
  [string]$Prova            = "",
  [switch]$SoloControllo,
  # -AccettoTettoBarre: l'interruttore ESPLICITO per i prova che chiedono
  #  piu' anni di quanti il tester ne dia su quel TF (i due M5). Senza,
  #  la riga si ferma e lo dice. Con, la scelta finisce nel referto.
  [switch]$AccettoTettoBarre,
  # -Terminale: si usa SOLO se la scelta automatica si ferma perche' non
  #  sa quale installazione MT5 e' quella di backtest (classe 115).
  [string]$Terminale        = "",
  [string]$DaQuando         = "2024.09.26",  # pavimento MISURATO dei dati BCM sugli indici (REFERTO_SONDA_STORICO_17-08)
  [string]$Fino             = "2026.06.30",  # dichiarata nei prova (@FINOA) e gattata
  [double]$FrazioneIS       = 0.40,          # split 40/60 di casa. NON seleziona niente: la cella e' congelata
  [int]$Deposito            = 100000         # INERTE: la sonda non apre ordini. Sta qui perche' il generico lo vuole
)
$ErrorActionPreference = "Stop"
[Threading.Thread]::CurrentThread.CurrentCulture   = [Globalization.CultureInfo]::InvariantCulture
[Threading.Thread]::CurrentThread.CurrentUICulture = [Globalization.CultureInfo]::InvariantCulture
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$INV = [Globalization.CultureInfo]::InvariantCulture

$EA      = "ABTG_Relativo"
$METRO   = "U30USD"
$Avvio   = Get-Date
$Stamp   = $Avvio.ToString("yyyyMMdd_HHmm", $INV)
# IL DESKTOP SI CERCA, NON SI ASSUME (classe 116-bis): con OneDrive il
# Desktop vero non e' %USERPROFILE%\Desktop. La riga di chat usa le
# STESSE tre righe, nello stesso ordine.
function TrovaDesktop(){
  foreach($p in @([Environment]::GetFolderPath("Desktop"),
                  (Join-Path $env:USERPROFILE "Desktop"),
                  (Join-Path $env:USERPROFILE "OneDrive\Desktop"))){
    if($p -and (Test-Path -LiteralPath $p)){ return $p }
  }
  return $env:USERPROFILE
}
$Dsk     = TrovaDesktop
$Work    = Join-Path $env:USERPROFILE "abtg_relativo_r117"
$Prove   = Join-Path $Work "prove"
$RawPin  = "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$Pin"
$Sentinella = Join-Path $Work "RELATIVO_R117_IN_CORSO.txt"

# --- IDENTITA' ATTESA DEL SORGENTE (gate, non decorazione)
$VERSIONE_ATTESA         = "1.02"   # 1.02 = pavimento gPosBarre<=0->1 in RegistraChiusura (percorso OnTester/fine corsa) + ripristino gPosBarre su ChiudiPosizione rifiutata nel flat di recupero (04/09)
$AUTOTEST_BLOCCHI_ATTESI = 20
$NSTATS_ATTESI           = 73      # 73 valori + Pass, Simbolo, Periodo = 76 colonne
$INPUT_ATTESI            = 28
$INCLUDE_ATTESI          = 1       # Trade/Trade.mqh: qui l'EA APRE ORDINI, e 0 sarebbe l'errore
#--- QUI NON C'E' NESSUNA GRIGLIA: la cella e' CONGELATA, quindi ogni
#    corsa fa UNA passata sola e il CSV deve avere UNA riga. Un numero
#    diverso vuol dire cache del tester o un asse rimasto acceso.
$RigheAttese             = 1

# --- I CANCELLI DI MERITO, SCRITTI QUI PRIMA DEI NUMERI. La riga li
#     RICALCOLA dai numeri grezzi del CSV invece di fidarsi di una
#     colonna gia' cucinata.
$A1_E_R            = 0.075   # aspettativa OOS in R (H8, FIRMA 2 del 31/08)
$A2_PF             = 1.15    # profit factor OOS
$A4_DD             = 8.0     # drawdown di equity OOS, in %
$A5_PEGGIOR        = -4.0    # peggior giornata, in % (pausa Guardian a 4,0)
$A6_N              = 150     # operazioni in IS E in OOS (Emendamento, regola A)
$A7_SOTTO60        = 25.0    # quota sotto 60 s, in % (vincolo prop P5)
$B_E_R             = 0.050   # sotto = BOCCIATURA SECCA
$B_PF              = 1.10
$B_DD              = 10.0    # muro prop
$B_PEGGIOR         = -5.0    # muro prop giornaliero
$N_NON_MISURABILE  = 30      # sotto = NON MISURABILE, che NON e' una bocciatura

# --- gli attesi ECO dei pin: se un pin non passa, MT5 lo ignora IN
#     SILENZIO e la corsa misura un'altra cella.
$ECO_N       = 40
$ECO_SIGMA   = 1.35
$ECO_USCITA  = 0.05
$ECO_ATRSL   = 2.75
$ECO_TETTO   = 5
$ECO_RISCHIO = 0.65

# --- IL COLLAUDO DEL PORTO. Attesi dai referti della griglia ESTESA
#     (cella N=40 sigma=1,35, colonne "Attraversamenti Grezzi
#     Long/Short"). Lo z-score si calcola su barre CHIUSE: il modello di
#     tick NON lo tocca, quindi devono tornare ALLA CIFRA.
#     >>> A -1 LA CORSA VERA NON PARTE (gate piu' sotto, subito dopo la
#     scelta del prova): un PORTO che non confronta niente uscirebbe
#     VERDE senza aver misurato niente, ed e' peggio di un rosso.
#     >>> DA DOVE SI PRENDONO. I due numeri stanno nel CSV OPTFRAME del
#     passo 0 (griglia ESTESA), riga N=40 / sigma=1.35, colonne
#     "Attraversamenti Grezzi Long" e "Attraversamenti Grezzi Short":
#       ABTG_SondaRelativo_D30EUR_IS_ohlc_D30_M5_EST.csv
#       ABTG_SondaRelativo_NASUSD_IS_ohlc_NAS_M5_EST.csv
#     CERCATI NEI REFERTI ARCHIVIATI, E NON CI SONO (verificato il
#     04/09 su REFERTO_D30_M5_ESTESA_2026-09-04_1630_v103_VIVO.txt e
#     REFERTO_NAS_M5_ESTESA_2026-09-04_1632_v103_VIVO.txt): la tabella
#     delle 90 celle stampa ese/ggL e ese/ggS, cioe' gli ESEGUIBILI per
#     giorno (DOPO i filtri di occupazione e tetto), e i GREZZI li
#     stampa SOLO per la cella di riferimento N=20/sigma=1.05
#     (D30 2246/2374 su 441 giorni, NAS 2419/2418 su 450 giorni).
#     Grezzi ed eseguibili NON sono la stessa grandezza e non si
#     ricavano gli uni dagli altri.
#     ARMATI il 04/09/2026 leggendo DIRETTAMENTE i due CSV OPTFRAME
#     (colonna "Attraversamenti Grezzi Long/Short", riga InpFinestraN=40
#     / InpSogliaIngressoSigma=1.35), archiviati in
#     backtest_pipeline/risultati_archivio/sondarelativo/:
#       ABTG_SondaRelativo_D30EUR_IS_ohlc_D30_M5_EST.csv  -> L=1303 S=1419
#       ABTG_SondaRelativo_NASUSD_IS_ohlc_NAS_M5_EST.csv  -> L=1506 S=1431
$PORTO = @{
  "D30EUR" = @{ GrezziL = 1303; GrezziS = 1419 }
  "NASUSD" = @{ GrezziL = 1506; GrezziS = 1431 }
}

# --- IL TETTO DEL TESTER, in giorni di calendario per TF (CLAUDE.md
#     25/08: M5 ~1,3 anni, M15 ~4 anni). 1,3 x 365 = 475; 4 x 365 = 1461.
$TETTO_GIORNI = @{ "M5" = 475; "M15" = 1461 }

# --- LE SEI CORSE AMMESSE. Il campo Gemello serve al confronto di
#     determinismo; Sonda dice, senza indovinare, se quella corsa deve
#     produrre ordini oppure no.
#     >>> IL CAMPO Periodo C'E' E SERVE (difetto trovato in review il
#     04/09): senza, $Periodo restava $null, $TETTO_GIORNI[$null] non
#     tornava niente e il gate del tetto barre diceva "OLTRE IL TETTO"
#     SEMPRE, con un doppio spazio nel referto. Il TF si DICHIARA qui,
#     una volta, e da qui lo leggono sia il gate del tetto sia il gate
#     sui prova: nessuna stringa "M5" cablata due volte.
$CORSE = [ordered]@{
  "D30"       = @{ Simbolo="D30EUR"; Periodo="M5"; File="RELATIVO_R117_D30.txt";         Magic="774601"; Sonda="false"; Gemello="D30_GEM"; Ruolo="MISURA" }
  "NAS"       = @{ Simbolo="NASUSD"; Periodo="M5"; File="RELATIVO_R117_NAS.txt";         Magic="774602"; Sonda="false"; Gemello="NAS_GEM"; Ruolo="MISURA" }
  "D30_GEM"   = @{ Simbolo="D30EUR"; Periodo="M5"; File="RELATIVO_R117_D30_GEMELLO.txt"; Magic="774611"; Sonda="false"; Gemello="D30";     Ruolo="GEMELLO" }
  "NAS_GEM"   = @{ Simbolo="NASUSD"; Periodo="M5"; File="RELATIVO_R117_NAS_GEMELLO.txt"; Magic="774612"; Sonda="false"; Gemello="NAS";     Ruolo="GEMELLO" }
  "D30_PORTO" = @{ Simbolo="D30EUR"; Periodo="M5"; File="RELATIVO_R117_D30_PORTO.txt";   Magic="774603"; Sonda="true";  Gemello="";        Ruolo="PORTO" }
  "NAS_PORTO" = @{ Simbolo="NASUSD"; Periodo="M5"; File="RELATIVO_R117_NAS_PORTO.txt";   Magic="774604"; Sonda="true";  Gemello="";        Ruolo="PORTO" }
}
#--- i campi che OGNI record di $CORSE deve dichiarare. Un record monco
#    non da' errore in PowerShell: da' $null, e $null si propaga in
#    silenzio fino a un verdetto sbagliato (classe 121).
$CAMPI_CORSA = @("Simbolo","Periodo","File","Magic","Sonda","Gemello","Ruolo")
#--- le righe che possono legittimamente differire fra i sei prova.
#    Qualunque ALTRA differenza FERMA TUTTO.
$DifferenzeAmmesse = @("InpMagic","InpModoSonda")

# --- I FISSI attesi nei prova (nome per nome): TUTTI gli input tranne
#     quelli in $DifferenzeAmmesse. Un nome sbagliato qui sarebbe
#     l'errore n.3 della checklist (MT5 ignora in silenzio).
$FissiAttesi = [ordered]@{
  "InpSimboloMetro"="U30USD"; "InpModoSpread"="0"; "InpModoZScore"="0";
  "InpFinestraN"="40"; "InpSogliaIngressoSigma"="1.35"; "InpSogliaUscitaSigma"="0.05";
  "InpOraInizioServer"="14"; "InpMinInizioServer"="30"; "InpOraFineServer"="22"; "InpMinFineServer"="0";
  "InpAtrSL"="2.75"; "InpBarreMaxTenuta"="120"; "InpRiskPercent"="0.65"; "InpMaxTradesPerDay"="5";
  "InpLato"="0"; "InpAtrPeriod"="14"; "InpAtrModoRma"="false";
  "InpSlippagePts"="10"; "InpMaxSpreadPts"="0"; "InpSaltaGiorniSpaiati"="false";
  "InpWarmupBarre"="300"; "InpPuntiPerIndice"="100.0";
  "InpScriviCsv"="true"; "InpVerbose"="true"; "InpAutoTest"="true"; "InpTag"="RELATIVO" }
#--- NESSUN ASSE: la cella e' CONGELATA. Un asse Y in un prova di questo
#    round vorrebbe dire che qualcuno ha rimesso una griglia dove il
#    documento dice che non ce n'e' nessuna.
$AssiAttesi = [ordered]@{}

# --- tutto cio' che la raccolta usa nasce QUI, prima del try: la
#     raccolta gira SEMPRE, anche nella corsa fermata da un gate.
$Problemi   = New-Object System.Collections.ArrayList
$Rilievi    = New-Object System.Collections.ArrayList
$PortoFuoriTolleranza = $false   # classe 124: il declassamento a Rilievo toglie il segnale (exit resta 0); questo flag lo restituisce a console, non solo nel referto
$Fatale     = ""
$Modo       = "CORSA"
if($SoloControllo){ $Modo = "CONTROLLO" }
$TermScelto = "n/d"
$TermCrit   = "NON RAGGIUNTA"
$DataFolder = ""
$Compilato  = "NON TENTATA"
$ResultTxt  = "NON RAGGIUNTA"
$RcMeTxt    = "NON RAGGIUNTO"
$CacheTxt   = "NON RAGGIUNTA"
$VersioneTxt= "NON LETTA"
$AutoSrcTxt = "NON CONTATI"
$NStatsTxt  = "NON LETTO"
$InputTxt   = "NON CONTATI"
$GrepTxt    = "NON ESEGUITO"
$IncludeTxt = "NON CONTATI"
$CelleTxt   = "NON CONTATE"
$GemelliTxt = "NON VERIFICATA"
$TettoTxt   = "NON VALUTATO"
$DefineTxt  = "NON LETTI"
$RcGenTxt   = "NON RAGGIUNTO"
$AnteprimaTxt = "n/a (solo in CONTROLLO)"
$CsvOraTxt  = "n/d"
$CsvRighe   = $null
$SoglieSrc  = $null      # i #define letti dal sorgente
#--- tutto cio' che la raccolta usa nasce QUI, prima del try: la
#    raccolta gira SEMPRE, anche nella corsa fermata da un gate, e una
#    variabile che nasce dentro il try non esisterebbe li'.
$GambaIS    = $null      # la riga del CSV IS
$GambaOOS   = $null      # la riga del CSV OOS
$CollaudiKo = 0
$RigheCancelli = @("  (non calcolati: la corsa non e' arrivata ai numeri)")
$VerdettoGamba = "n/d"
$GemelloTxt = ""
$RuoloTxt   = "n/d"
$MagicTxt   = "n/d"
$SondaTxt   = "n/d"
$FotoPrima  = @()
$FotoDopo   = @()
$SentTrovata = ""
$SentScritta = $false   # true SOLO se QUESTO giro ha davvero scritto la sentinella (cioe' ha toccato il terminale)
$EtaGemello  = ""
$tCorsa     = $Avvio
$Simbolo    = "n/d"
$Periodo    = "n/d"
$FileProva  = "n/d"
$SpreadAtteso = 0.0
$Results    = Join-Path $Work ("risultati_prove\" + $EA)

function Ora(){ return (Get-Date).ToString("HH:mm:ss", $INV) }
function Dico([string]$t,[string]$c="Gray"){ Write-Host ("[" + (Ora) + "] " + $t) -ForegroundColor $c }
function Titolo([string]$t){ Write-Host ""; Write-Host ("=== " + $t + " ===") -ForegroundColor Cyan }

function Scarica([string]$url,[string]$dest){
  Remove-Item -LiteralPath $dest -Force -ErrorAction SilentlyContinue
  try{ Invoke-WebRequest -Uri $url -OutFile $dest -UseBasicParsing -ErrorAction Stop }
  catch{ throw ("scarico fallito (" + $_.Exception.Message + "): " + $url + " -- se e' un 404 su un pin appena creato, la cache di GitHub raw tiene ~5 minuti: aspetta e rilancia LA STESSA riga.") }
  if(-not (Test-Path -LiteralPath $dest)){ throw ("scarico fallito: " + $url) }
}
function RigheVive([string]$p){
  return @(Get-Content -LiteralPath $p | Where-Object { $_ -notmatch '^\s*#' -and $_ -notmatch '^\s*$' })
}
function Num([string]$s){ return [double]::Parse($s.Trim(), $INV) }
function FmtN($v){ if($null -eq $v){ return "n/d" }; return ([long]$v).ToString($INV) }
function Fmt2($v){ if($null -eq $v){ return "n/d" }; return ([double]$v).ToString("0.00",$INV) }
function Fmt3($v){ if($null -eq $v){ return "n/d" }; return ([double]$v).ToString("0.000",$INV) }
function Fmt4($v){ if($null -eq $v){ return "n/d" }; return ([double]$v).ToString("0.0000",$INV) }
function Foto([string]$p){
  if(Test-Path -LiteralPath $p){
    $i = Get-Item -LiteralPath $p
    return ("presente, " + $i.Length + " byte, " + $i.LastWriteTime.ToString("yyyy-MM-dd HH:mm:ss",$INV))
  }
  return "assente"
}
# legge un file di testo QUALUNQUE sia la codifica (MetaEditor scrive il
# log in UTF-16): BOM FF FE -> Unicode; molti byte 0 -> Unicode; altrimenti ANSI.
function LeggiTesto([string]$p){
  if(-not (Test-Path -LiteralPath $p)){ return @() }
  $b = [IO.File]::ReadAllBytes($p)
  if($b.Length -eq 0){ return @() }
  $unicode = $false
  if($b.Length -ge 2 -and $b[0] -eq 0xFF -and $b[1] -eq 0xFE){ $unicode = $true }
  else{
    $zeri = 0; $n = [math]::Min($b.Length, 400)
    for($i=0; $i -lt $n; $i++){ if($b[$i] -eq 0){ $zeri++ } }
    if($zeri -gt ($n/4)){ $unicode = $true }
  }
  $txt = ""
  if($unicode){ $txt = [Text.Encoding]::Unicode.GetString($b) } else { $txt = [Text.Encoding]::Default.GetString($b) }
  return @($txt -split "`r?`n")
}

# legge un file prova in una mappa @{nome=valore} + lista assi Y (una
# riga DOPPIA e' FATALE: in [TesterInputs] un parametro doppio fa fare a
# MT5 ZERO passate).
function LeggiProva([string]$percorso,[string]$nome){
  $mappa = [ordered]@{}
  $assi  = New-Object System.Collections.ArrayList
  foreach($r in (RigheVive $percorso)){
    if($r -match '^@'){
      $parti = ($r -split '\s+',2)
      if($parti.Count -lt 2){ throw ($nome + ": la direttiva '" + $r + "' non ha un valore.") }
      if($mappa.Contains($parti[0])){ throw ($nome + ": direttiva doppia '" + $parti[0] + "'.") }
      $mappa[$parti[0]] = $parti[1].Trim()
      continue
    }
    $i = $r.IndexOf("=")
    if($i -lt 0){ continue }
    $n = $r.Substring(0,$i).Trim()
    $v = $r.Substring($i+1).Trim()
    if($mappa.Contains($n)){ throw ($nome + ": DUE righe per '" + $n + "'. In [TesterInputs] un parametro doppio fa fare a MT5 ZERO passate.") }
    $mappa[$n] = $v
    if($v -match '\|\|Y\s*$'){ [void]$assi.Add($n) }
  }
  return @{ Mappa=$mappa; Assi=$assi }
}
# conta le celle di UN asse ESATTAMENTE come le conta il generico
# (Floor(|stop-start|/|step| + 1e-9) + 1). Niente enum: la sonda non
# ha input enum sweepati.
function CelleAsse([string]$valore,[string]$nome){
  $campi = $valore -split '\|\|'
  if($campi.Count -lt 5){ throw ($nome + ": pin '" + $valore + "' non ha 5 campi: non e' un asse.") }
  $conv = New-Object System.Collections.ArrayList
  foreach($ix in @(1,2,3)){
    $t = $campi[$ix].Trim()
    if($t -notmatch '^-?\d+(\.\d+)?$'){ throw ($nome + ": campo '" + $campi[$ix] + "' non numerico nell'asse.") }
    [void]$conv.Add([double]::Parse($t,$INV))
  }
  $start = $conv[0]; $step = $conv[1]; $stop = $conv[2]
  if($step -eq 0 -or $start -eq $stop){ throw ($nome + ": asse DEGENERE (start==stop o step==0).") }
  return ([int]([math]::Floor([math]::Abs($stop-$start)/[math]::Abs($step) + 1e-9)) + 1)
}
# gli input dell'EA, letti dal sorgente (le righe "input group" non
# hanno l'uguale e non entrano).
function LeggiInputEA([string]$src){
  $nomi = New-Object System.Collections.ArrayList
  foreach($m in [regex]::Matches($src,'(?m)^\s*input\s+[A-Za-z_]\w*\s+([A-Za-z_]\w*)\s*=')){ [void]$nomi.Add($m.Groups[1].Value) }
  return $nomi
}
# i #define numerici del sorgente: vince la PRIMA definizione.
function LeggiDefine([string]$src){
  $d = @{}
  foreach($m in [regex]::Matches($src,'(?m)^\s*#define\s+(\w+)\s+([^\r\n/]+)')){
    $n = $m.Groups[1].Value; $v = $m.Groups[2].Value.Trim()
    if(-not $d.ContainsKey($n)){ $d[$n] = $v }
  }
  return $d
}
function DefNum($d,[string]$nome){
  if(-not $d.ContainsKey($nome)){ throw ("il sorgente non ha il #define " + $nome + ": la sonda al pin non e' quella attesa.") }
  $v = ("" + $d[$nome]).Trim()
  if($v -notmatch '^-?\d+(\.\d+)?$'){ throw ("#define " + $nome + " = '" + $v + "' non e' un numero.") }
  return [double]::Parse($v,$INV)
}

# IL GATE DI UN PROVA, in una funzione: direttive nude, parametri che
# ESISTONO nell'EA (nei due versi), 2 assi esatti, celle contate, fissi
# nome per nome, nessuna riga estranea. Torna @{ Lettura; Celle }.
function GateProva([string]$percorso,[string]$pf,[string]$simAtteso,[string]$tfAtteso,$inputEA,[string]$magicAtteso,[string]$sondaAttesa){
  $lettura = LeggiProva $percorso $pf
  $h    = $lettura.Mappa
  $assi = $lettura.Assi
  if($h["@SIMBOLO"]  -ne $simAtteso){ throw ($pf + ": @SIMBOLO e' '" + $h["@SIMBOLO"] + "', atteso " + $simAtteso) }
  if($h["@PERIODO"]  -ne $tfAtteso){  throw ($pf + ": @PERIODO e' '" + $h["@PERIODO"] + "', atteso " + $tfAtteso) }
  if($h["@DAQUANDO"] -ne $DaQuando){  throw ($pf + ": @DAQUANDO e' '" + $h["@DAQUANDO"] + "', atteso " + $DaQuando + " (pavimento MISURATO dei dati BCM sugli indici)") }
  if($h["@FINOA"]    -ne $Fino){      throw ($pf + ": @FINOA e' '" + $h["@FINOA"] + "', atteso " + $Fino + " (la finestra si dichiara nel prova, non si eredita dal default del generico)") }
  # OGNI parametro del prova DEVE esistere nell'EA (errore n.3: MT5 ignora
  # in silenzio) e OGNI input dell'EA DEVE essere pinnato nel prova.
  $paramProva = @($h.Keys | Where-Object { $_ -notmatch '^@' })
  foreach($k in $paramProva){ if(-not ($inputEA -contains $k)){ throw ($pf + ": il parametro '" + $k + "' NON e' un input di " + $EA + " (classe 112 / errore n.3: MT5 lo ignorerebbe in silenzio).") } }
  foreach($k in @($inputEA)){ if(-not $h.Contains($k)){ throw ($pf + ": l'input '" + $k + "' dell'EA NON e' pinnato nel prova: MT5 userebbe lo stato che si ricorda dall'ultima griglia.") } }
  # NESSUN ASSE Y: la cella e' congelata (vedi $AssiAttesi vuoto). Un
  # asse acceso qui vorrebbe dire che qualcuno ha rimesso una griglia
  # dove il documento dice che non ce n'e' nessuna.
  if(@($assi).Count -ne 0){ throw ($pf + ": ha " + @($assi).Count + " assi Y {" + (@($assi) -join ", ") + "} ma questo round NON HA UNA GRIGLIA.") }
  if($RigheAttese -ne 1){ throw ("configurazione interna incoerente: RigheAttese = " + $RigheAttese + ", atteso 1 (una passata per corsa).") }
  # I FISSI, nome per nome, col valore.
  foreach($k in @($FissiAttesi.Keys)){
    if(-not $h.Contains($k)){ throw ($pf + ": manca la riga '" + $k + "'.") }
    $v = ($h[$k] -split '\|\|')[0]
    if($v -ne $FissiAttesi[$k]){ throw ($pf + ": " + $k + " e' '" + $v + "', atteso '" + $FissiAttesi[$k] + "'.") }
    if($h[$k] -match '\|\|Y\s*$'){ throw ($pf + ": " + $k + " NON va sweepato.") }
  }
  # LE RIGHE CHE POSSONO DIFFERIRE si gattano lo stesso, contro
  # l'atteso DI QUELLA CORSA: "puo' differire fra i sei" non vuol dire
  # "puo' valere qualunque cosa".
  foreach($k in @($DifferenzeAmmesse)){
    if(-not $h.Contains($k)){ throw ($pf + ": manca la riga '" + $k + "'.") }
    if($h[$k] -match '\|\|Y\s*$'){ throw ($pf + ": " + $k + " NON va sweepato.") }
  }
  if($magicAtteso -ne "" -and $h["InpMagic"] -ne $magicAtteso){ throw ($pf + ": InpMagic e' '" + $h["InpMagic"] + "', atteso '" + $magicAtteso + "'.") }
  if($sondaAttesa -ne "" -and $h["InpModoSonda"] -ne $sondaAttesa){ throw ($pf + ": InpModoSonda e' '" + $h["InpModoSonda"] + "', atteso '" + $sondaAttesa + "'.") }
  # niente righe estranee: 4 direttive + 26 fissi + 2 variabili = 32.
  $attese = 4 + @($FissiAttesi.Keys).Count + @($DifferenzeAmmesse).Count
  if(@($h.Keys).Count -ne $attese){ throw ($pf + ": " + @($h.Keys).Count + " righe vive invece di " + $attese + ": c'e' una riga estranea o ne manca una.") }
  return @{ Lettura=$lettura; Celle=$RigheAttese }
}
# IL GEMELLAGGIO A QUATTRO: le righe vive dei parametri (tutto tranne le
# direttive) devono essere IDENTICHE nei quattro prova; le direttive
# @SIMBOLO/@PERIODO devono valere quello che l'etichetta dichiara.
# IL GEMELLAGGIO A SEI. Le righe dei parametri devono essere IDENTICHE
# nei sei prova, TRANNE quelle dichiarate in $DifferenzeAmmesse
# (InpMagic e InpModoSonda) -- e quelle sono gia' state gattate una per
# una contro l'atteso della loro corsa dentro GateProva. Qui si
# verifica che NON ce ne siano ALTRE: una terza differenza non
# dichiarata vorrebbe dire che due corse misurano due motori diversi.
function GateGemelli($letture, $ammesse){
  $chiavi = @($letture.Keys)
  $base = $chiavi[0]
  $hA = $letture[$base]
  $diverse = New-Object System.Collections.ArrayList
  foreach($altro in $chiavi){
    if($altro -eq $base){ continue }
    $hB = $letture[$altro]
    foreach($k in @($hA.Keys)){
      if($k -match '^@'){ continue }
      if(-not $hB.Contains($k)){ throw ("GEMELLAGGIO NON VALIDO: " + $base + " ha la riga '" + $k + "' che " + $altro + " non ha.") }
      if($hA[$k] -ne $hB[$k]){
        if($ammesse -contains $k){ if(-not ($diverse -contains $k)){ [void]$diverse.Add($k) }; continue }
        throw ("GEMELLAGGIO NON VALIDO: '" + $k + "' vale '" + $hA[$k] + "' in " + $base + " e '" + $hB[$k] + "' in " + $altro + ". I sei prova possono differire SOLO per @SIMBOLO e per " + ($ammesse -join ", ") + ".")
      }
    }
    foreach($k in @($hB.Keys)){
      if($k -match '^@'){ continue }
      if(-not $hA.Contains($k)){ throw ("GEMELLAGGIO NON VALIDO: " + $altro + " ha la riga '" + $k + "' che " + $base + " non ha.") }
    }
    if($hA["@DAQUANDO"] -ne $hB["@DAQUANDO"] -or $hA["@FINOA"] -ne $hB["@FINOA"] -or $hA["@PERIODO"] -ne $hB["@PERIODO"]){ throw ("GEMELLAGGIO NON VALIDO: finestra o TF diversi fra " + $base + " e " + $altro + ".") }
  }
  $d = "nessuna"
  if($diverse.Count -gt 0){ $d = ($diverse -join ", ") }
  return ("VALIDO: i " + @($chiavi).Count + " prova hanno il blocco dei parametri IDENTICO riga per riga; differenze DICHIARATE trovate: " + $d + " (piu' @SIMBOLO)")
}

# LEGGE UNA GAMBA (IS oppure OOS) DAL CSV OPTFRAME. Una riga sola, per
# costruzione: la cella e' congelata e non c'e' nessuna griglia. Torna
# $null se il file non c'e' o e' STANTIO (piu' vecchio dell'avvio della
# corsa): un CSV vecchio letto come fresco e' il modo piu' rapido di
# pubblicare i numeri di un'altra corsa.
function LeggiGamba([string]$csv,[datetime]$tC,[string]$eti){
  if(-not (Test-Path -LiteralPath $csv)){
    [void]$Problemi.Add("CSV " + $eti + " NON prodotto: " + $csv + " (storico mancante sulla gamba o sul metro " + $METRO + "? MT5 gia' aperto? compilazione? RAM esaurita a tick reali?)")
    return($null)
  }
  $itm = Get-Item -LiteralPath $csv
  if($itm.LastWriteTime -lt $tC){
    [void]$Problemi.Add("CSV " + $eti + " STANTIO, NON LETTO: scritto alle " + $itm.LastWriteTime.ToString("yyyy-MM-dd HH:mm:ss",$INV) + ", cioe' PRIMA dell'avvio di questa corsa. E' il CSV di una corsa PRECEDENTE rimasto in workdir: questa corsa NON ha numeri.")
    return($null)
  }
  $lin = @(Get-Content -LiteralPath $csv | Where-Object { $_.Trim() -ne "" })
  $nR = $lin.Count - 1
  if($nR -ne $RigheAttese){
    [void]$Problemi.Add("" + $nR + " righe nel CSV " + $eti + ", " + $RigheAttese + " attesa (cache del tester? un asse rimasto acceso? passata morta a OnInit?).")
    if($nR -le 0){ return($null) }
  }
  $head = $lin[0] -split ','
  $ix = @{}
  for($i=0; $i -lt $head.Count; $i++){ $ix[$head[$i].Trim()] = $i }
  $servono = @("Segnali Grezzi Long","Segnali Grezzi Short",
    "Segnali Soppressi Posizione Aperta","Segnali Soppressi Tetto Giorno",
    "Segnali Soppressi Ingresso Fuori Finestra","Segnali Soppressi Filtro Spread",
    "Segnali Soppressi Giorno Spaiato",
    "Operazioni Long","Operazioni Short","Operazioni Totali",
    "Uscite Convergenza","Uscite Stop","Uscite Flat Sessione","Uscite Tetto Barre","Uscite Fine Corsa","Uscite Ignote",
    "Ordini Rifiutati","Ultimo Retcode",
    "Giorni Contati","Giorni Col Tetto Colpito","Giorni Col Tetto Colpito Pct",
    "Giorni Spaiati","Giorni Spaiati Pct",
    "Operazioni In Giorni Spaiati","Profitto In Giorni Spaiati","Profitto Fuori Giorni Spaiati",
    "Guadagno Mediano Vincente Punti Indice","Mfe Mediana Punti Indice","Mae Mediana Punti Indice",
    "Rapporto Realizzato Su Mfe",
    "Spread Ingresso Mediano Punti Indice","Spread Ingresso P95 Punti Indice",
    "Scarto Ingresso Vs Apertura Mediano","Scarto Ingresso Vs Apertura P95",
    "Tenuta Mediana Barre","Tenuta Mediana Minuti","Sotto 60 Secondi Pct",
    "Operazioni A Lotto Minimo","Operazioni A Lotto Minimo Pct","Sl Allargato Da Stops Level",
    "Rischio Medio Realizzato Pct","Aspettativa In R",
    "Profitto Netto","Profit Factor","Operazioni Chiuse Tester","Vinte Pct",
    "Equity Dd Pct","Peggior Giornata Pct",
    "Barre Valutate","Barre Fuori Finestra","Barre Saltate Dati",
    "Valutazioni Metro Mancante Segnale","Valutazioni Perse Buco Finestra",
    "Valutazioni Con Solo Metro","Z Non Calcolabile",
    "Atr Mediano Punti Indice","Punto Indice Prezzo",
    "Metro Prima Barra Epoch","Gamba Prima Barra Epoch",
    "Autotest Falliti","Autotest Blocchi",
    "Finestra N","Soglia Ingresso Sigma","Soglia Uscita Sigma","Atr Sl Multiplo",
    "Max Trades Day","Risk Percent","Lato Attivo",
    "Modo Sonda","Salta Giorni Spaiati","Slippage Punti","Magic")
  $manca = New-Object System.Collections.ArrayList
  foreach($cn in $servono){ if(-not $ix.ContainsKey($cn)){ [void]$manca.Add($cn) } }
  if($manca.Count -gt 0){
    [void]$Problemi.Add("nel CSV " + $eti + " mancano le colonne: " + ($manca -join ", ") + " (header OPTFRAME dell'EA diverso da quello atteso?).")
    return($null)
  }
  if($head.Count -lt ($NSTATS_ATTESI + 3)){ [void]$Problemi.Add("CSV " + $eti + ": header con " + $head.Count + " colonne, attese almeno " + ($NSTATS_ATTESI + 3) + ".") }
  $c = $lin[1] -split ','
  $g = @{}
  foreach($cn in $servono){
    if($ix[$cn] -ge $c.Count){ [void]$Problemi.Add("CSV " + $eti + ": la riga dei dati ha meno colonne dell'header."); return($null) }
    $g[$cn] = Num $c[$ix[$cn]]
  }
  $g["_etichetta"] = $eti
  return($g)
}

# I COLLAUDI DI SANITA', su UNA gamba. Se cade uno solo, il round non
# si legge: e' la clausola severa di casa, e vale PRIMA di qualunque
# numero economico.
function CollaudiGamba($g,[string]$eti,[string]$ruolo){
  $ko = 0
  if($null -eq $g){ return(1) }
  if($g["Autotest Falliti"] -eq -1){ [void]$Problemi.Add($eti + ": Autotest Falliti = -1 (autotest NON girato): non e' 'passato', e' 'non eseguito'."); $ko++ }
  elseif($g["Autotest Falliti"] -gt 0){ [void]$Problemi.Add($eti + ": Autotest Falliti = " + (FmtN $g["Autotest Falliti"]) + ": il nucleo DIVERGE dalla spec, i numeri NON si leggono."); $ko++ }
  if($g["Autotest Blocchi"] -ne $AUTOTEST_BLOCCHI_ATTESI){ [void]$Problemi.Add($eti + ": Autotest Blocchi = " + (FmtN $g["Autotest Blocchi"]) + " invece di " + $AUTOTEST_BLOCCHI_ATTESI + " (EA diverso da quello atteso?)."); $ko++ }
  if([math]::Abs($g["Punto Indice Prezzo"] - 1.0) -gt 0.001){ [void]$Problemi.Add($eti + ": Punto Indice Prezzo = " + (Fmt3 $g["Punto Indice Prezzo"]) + " invece di 1,000: MFE, MAE e la SCALA DELLO STOP escono sbagliati di un fattore."); $ko++ }
  #--- ECO DEI PIN: un pin che MT5 ignora in silenzio fa misurare
  #    un'altra cella, e senza queste righe nessuno se ne accorge.
  if([math]::Abs($g["Finestra N"] - $ECO_N) -gt 0.001 -or
     [math]::Abs($g["Soglia Ingresso Sigma"] - $ECO_SIGMA) -gt 0.001 -or
     [math]::Abs($g["Soglia Uscita Sigma"] - $ECO_USCITA) -gt 0.0001 -or
     [math]::Abs($g["Atr Sl Multiplo"] - $ECO_ATRSL) -gt 0.001 -or
     [math]::Abs($g["Max Trades Day"] - $ECO_TETTO) -gt 0.001 -or
     [math]::Abs($g["Risk Percent"] - $ECO_RISCHIO) -gt 0.001){
    [void]$Problemi.Add($eti + ": ECO DEI PIN DIVERSO dall'atteso (N " + (FmtN $g["Finestra N"]) + " vs " + $ECO_N + ", sigma " + (Fmt2 $g["Soglia Ingresso Sigma"]) + " vs " + (Fmt2 $ECO_SIGMA) + ", uscita " + (Fmt2 $g["Soglia Uscita Sigma"]) + ", SL " + (Fmt2 $g["Atr Sl Multiplo"]) + " ATR, tetto " + (FmtN $g["Max Trades Day"]) + ", rischio " + (Fmt2 $g["Risk Percent"]) + "%): IL PIN NON E' PASSATO e la corsa ha misurato un'altra configurazione.")
    $ko++
  }
  #--- il ruolo dichiarato deve combaciare con quello che l'EA ha fatto
  $sondaAttesa = 0.0
  if($ruolo -eq "PORTO"){ $sondaAttesa = 1.0 }
  if([math]::Abs($g["Modo Sonda"] - $sondaAttesa) -gt 0.001){
    [void]$Problemi.Add($eti + ": Modo Sonda = " + (FmtN $g["Modo Sonda"]) + " ma il ruolo di questa corsa e' " + $ruolo + ": o l'EA ha aperto ordini in una corsa di collaudo, o non li ha aperti nella corsa di misura.")
    $ko++
  }
  #--- vincolo prop P5: a M5 la tenuta minima e' UNA barra = 300 s.
  #    Questa quota DEVE venire 0,00: e' un COLLAUDO, non una scoperta.
  if($g["Sotto 60 Secondi Pct"] -gt 0.0001){
    [void]$Problemi.Add($eti + ": Sotto 60 Secondi Pct = " + (Fmt2 $g["Sotto 60 Secondi Pct"]) + " (atteso 0,00 a M5, dove la tenuta minima e' una barra = 300 s): la contabilita' delle barre e' rotta.")
    $ko++
  }
  if($g["Uscite Ignote"] -gt 0){ [void]$Problemi.Add($eti + ": Uscite Ignote = " + (FmtN $g["Uscite Ignote"]) + " (atteso 0): ci sono chiusure che l'EA non sa spiegare, e i conteggi per motivo non tornano."); $ko++ }
  if($g["Ordini Rifiutati"] -gt 0){ [void]$Rilievi.Add($eti + ": Ordini Rifiutati = " + (FmtN $g["Ordini Rifiutati"]) + " (ultimo retcode " + (FmtN $g["Ultimo Retcode"]) + "): NON sono segnali mancati, sono FILL mancati. Se sono molti rispetto alle operazioni, la tolleranza di riempimento (InpSlippagePts) e' troppo stretta e va detto PRIMA di leggere il conto economico.") }
  if($g["Barre Saltate Dati"] -gt 10){ [void]$Rilievi.Add($eti + ": Barre Saltate Dati = " + (FmtN $g["Barre Saltate Dati"]) + " (atteso ~0): buchi nello storico.") }
  if($g["Operazioni A Lotto Minimo Pct"] -gt 20.0){ [void]$Rilievi.Add($eti + ": il " + (Fmt2 $g["Operazioni A Lotto Minimo Pct"]) + "% delle operazioni e' andato a LOTTO MINIMO: su quelle il rischio REALE non e' 0,65% ma quello che il minimo impone (lezione del 31/08: 'le riduzioni sotto ~0,5% erano FINZIONE'). Il rischio medio realizzato e' " + (Fmt2 $g["Rischio Medio Realizzato Pct"]) + "%: leggere il DRAWDOWN con quel numero in mano, non col dichiarato.") }
  if($g["Giorni Col Tetto Colpito Pct"] -gt 20.0){ [void]$Rilievi.Add($eti + ": il tetto giornaliero ha morso nel " + (Fmt2 $g["Giorni Col Tetto Colpito Pct"]) + "% dei giorni (oltre il 20%): questa corsa sta misurando IL TETTO almeno quanto il motore, e va scritto in quei termini.") }
  if($g["Metro Prima Barra Epoch"] -le 0 -or $g["Gamba Prima Barra Epoch"] -le 0){ [void]$Problemi.Add($eti + ": Metro/Gamba Prima Barra Epoch = " + (FmtN $g["Metro Prima Barra Epoch"]) + "/" + (FmtN $g["Gamba Prima Barra Epoch"]) + ": una delle due serie non e' sincronizzata."); $ko++ }
  elseif($g["Metro Prima Barra Epoch"] -gt ($g["Gamba Prima Barra Epoch"] + 7*86400)){ [void]$Problemi.Add($eti + ": il METRO " + $METRO + " parte DOPO la gamba: la finestra effettiva e' piu' corta e va dichiarata."); $ko++ }
  return($ko)
}

# I CANCELLI DI MERITO SU UNA GAMBA. Restituisce il verdetto e riempie
# la lista dei motivi. Le fasce sono DISGIUNTE per costruzione: fra
# "passa" e "bocciata secca" c'e' SEMPRE la ZONA MORTA (non passa, ma
# non e' una bocciatura del meccanismo).
function Fascia($val,$soglia,$muro,[bool]$piuEmeglio){
  if($piuEmeglio){
    if($val -ge $soglia){ return("PASSA") }
    if($val -lt $muro){ return("BOCCIATA") }
    return("ZONA MORTA")
  }
  if($val -le $soglia){ return("PASSA") }
  if($val -gt $muro){ return("BOCCIATA") }
  return("ZONA MORTA")
}

function CancelliMerito($gIS,$gOOS,[ref]$righe){
  $out = New-Object System.Collections.ArrayList
  if($null -eq $gIS -or $null -eq $gOOS){
    [void]$out.Add("NON MISURABILE: manca una delle due gambe (IS o OOS).")
    $righe.Value = $out
    return("NON MISURABILE")
  }
  $nIS  = $gIS["Operazioni Totali"]
  $nOosG = $gOOS["Operazioni Totali"]
  $eR   = $gOOS["Aspettativa In R"]
  $pf   = $gOOS["Profit Factor"]
  $pfIS = $gIS["Profit Factor"]
  $dd   = $gOOS["Equity Dd Pct"]
  $pg   = $gOOS["Peggior Giornata Pct"]
  $s60  = $gOOS["Sotto 60 Secondi Pct"]

  $fE  = Fascia $eR $A1_E_R $B_E_R $true
  $fPF = Fascia $pf $A2_PF  $B_PF  $true
  $fDD = Fascia $dd $A4_DD  $B_DD  $false
  #--- la peggior giornata e' NEGATIVA: "meglio" vuol dire piu' vicino a
  #    zero. La fascia si scrive a mano per non far dire a Fascia una
  #    cosa che non intende.
  $fPG = "PASSA"
  if($pg -lt $A5_PEGGIOR){ $fPG = "ZONA MORTA" }
  if($pg -lt $B_PEGGIOR){ $fPG = "BOCCIATA" }
  $fN  = "PASSA"
  if($nOosG -lt $A6_N -or $nIS -lt $A6_N){ $fN = "MERITO SOSPESO" }
  if($nOosG -lt $N_NON_MISURABILE -or $nIS -lt $N_NON_MISURABILE){ $fN = "NON MISURABILE" }
  $fA3 = "PASSA"
  if($gIS["Profitto Netto"] -le 0.0 -or $pfIS -le 1.0){ $fA3 = "BOCCIATA" }
  elseif(($gIS["Profitto Netto"] -gt 0.0) -ne ($gOOS["Profitto Netto"] -gt 0.0)){ $fA3 = "BOCCIATA" }
  $fA7 = "PASSA"
  if($s60 -ge $A7_SOTTO60){ $fA7 = "BOCCIATA" }

  [void]$out.Add("  A1 aspettativa OOS " + (Fmt3 $eR) + " R   (>= " + (Fmt3 $A1_E_R) + " passa, < " + (Fmt3 $B_E_R) + " bocciata secca)   -> " + $fE)
  [void]$out.Add("  A2 profit factor OOS " + (Fmt3 $pf) + "   (>= " + (Fmt2 $A2_PF) + " passa, < " + (Fmt2 $B_PF) + " bocciata secca)   -> " + $fPF)
  [void]$out.Add("  A3 IS coerente: profitto IS " + (Fmt2 $gIS["Profitto Netto"]) + ", PF IS " + (Fmt3 $pfIS) + ", profitto OOS " + (Fmt2 $gOOS["Profitto Netto"]) + "   -> " + $fA3)
  [void]$out.Add("  A4 drawdown equity OOS " + (Fmt2 $dd) + "%   (<= " + (Fmt2 $A4_DD) + " passa, > " + (Fmt2 $B_DD) + " bocciata PER RISCHIO)   -> " + $fDD)
  [void]$out.Add("  A5 peggior giornata OOS " + (Fmt2 $pg) + "%   (>= " + (Fmt2 $A5_PEGGIOR) + " passa, < " + (Fmt2 $B_PEGGIOR) + " bocciata PER RISCHIO)   -> " + $fPG)
  [void]$out.Add("  A6 operazioni IS " + (FmtN $nIS) + " / OOS " + (FmtN $nOosG) + "   (>= " + $A6_N + " per giudicare il MERITO)   -> " + $fN)
  [void]$out.Add("  A7 sotto 60 secondi OOS " + (Fmt2 $s60) + "%   (< " + (Fmt2 $A7_SOTTO60) + " passa; a M5 deve essere 0,00)   -> " + $fA7)

  #--- IL VERDETTO. Il RISCHIO non si sospende MAI, nemmeno con n
  #    piccolo (Emendamento, regola B): A4 e A5 bocciano da soli.
  if($fDD -eq "BOCCIATA" -or $fPG -eq "BOCCIATA"){ $righe.Value = $out; return("BOCCIATA PER RISCHIO") }
  if($fN -eq "NON MISURABILE"){ $righe.Value = $out; return("NON MISURABILE") }
  if($fN -eq "MERITO SOSPESO"){ $righe.Value = $out; return("MERITO SOSPESO (si legge SOLO il rischio, e il rischio non e' rosso)") }
  if($fE -eq "BOCCIATA" -or $fPF -eq "BOCCIATA" -or $fA3 -eq "BOCCIATA" -or $fA7 -eq "BOCCIATA"){ $righe.Value = $out; return("BOCCIATA") }
  if($fE -eq "PASSA" -and $fPF -eq "PASSA" -and $fA3 -eq "PASSA" -and $fDD -eq "PASSA" -and $fPG -eq "PASSA" -and $fA7 -eq "PASSA"){ $righe.Value = $out; return("PASSA TUTTI I CANCELLI A") }
  $righe.Value = $out
  return("NON PASSA (zona morta: nessuna proposta, nessuna bocciatura del meccanismo)")
}

# =====================================================================
#  INIZIO ESECUZIONE
# =====================================================================
try{
  #--- LA PRIMA RIGA CHE SI LEGGE A SCHERMO DEVE DIRE COS'E' QUESTO
  #    ROUND. Diceva ancora "PASSO 0, CONTATORE": era il titolo della
  #    riga della sonda, ed era FALSO qui (difetto trovato in review il
  #    04/09). Qui l'EA APRE POSIZIONI in backtest.
  Titolo ("RELATIVO -- R117, PASSO 1: MERITO A TICK REALI -- QUESTO EA APRE ORDINI VERI IN BACKTEST (" + $EA + ") -- modo " + $Modo)
  if($Pin -eq ""){ throw "-Pin obbligatorio: senza, girerebbe la punta del branch spacciandola per un commit congelato." }
  if($Pin -notmatch '^[0-9a-f]{40}$'){ throw ("-Pin deve essere un commit di 40 caratteri esadecimali, ricevuto: " + $Pin) }
  if($Prova -eq ""){ throw ("-Prova obbligatorio: uno fra " + (@($CORSE.Keys) -join ", ") + ".") }
  if(Get-Process terminal64,metaeditor64 -ErrorAction SilentlyContinue){
    throw "MT5 O METAEDITOR APERTO: col terminale aperto il tester non gira (zero CSV), con MetaEditor aperto la compilazione torna subito senza compilare."
  }
  #--- GUARDIA CLASSE 121: la tabella $CORSE si controlla PRIMA di
  #    usarla, e su TUTTE E SEI le righe (non solo su quella scelta):
  #    il gate sui prova al passo 3 legge il Periodo di tutte e sei.
  #    Un campo mancante in PowerShell non e' un errore, e' un $null che
  #    viaggia zitto fino al verdetto.
  foreach($kc in @($CORSE.Keys)){
    foreach($campo in $CAMPI_CORSA){
      if(-not $CORSE[$kc].ContainsKey($campo)){ throw ("BUG INTERNO (classe 121): la tabella CORSE non dichiara il campo '" + $campo + "' per la corsa " + $kc + ".") }
      if(("" + $CORSE[$kc][$campo]) -eq "" -and $campo -ne "Gemello"){ throw ("BUG INTERNO (classe 121): il campo '" + $campo + "' della corsa " + $kc + " e' vuoto.") }
    }
    if(-not $TETTO_GIORNI.ContainsKey($CORSE[$kc].Periodo)){ throw ("BUG INTERNO (classe 121): il TF '" + $CORSE[$kc].Periodo + "' della corsa " + $kc + " non e' nella tabella TETTO_GIORNI: il gate del tetto barre non saprebbe contro cosa misurare.") }
  }
  $corsa    = $CORSE[$Prova]
  $Simbolo  = $corsa.Simbolo
  $Periodo  = $corsa.Periodo
  $FileProva= $corsa.File
  $RuoloTxt = $corsa.Ruolo
  $MagicTxt = $corsa.Magic
  $SondaTxt = $corsa.Sonda
  Dico ("pin ......... " + $Pin)
  Dico ("prova ....... " + $Prova + " = " + $FileProva + " | gamba " + $Simbolo + " " + $Periodo + " | metro " + $METRO + " (si legge, non si scambia)")
  Dico ("finestra .... " + $DaQuando + " -> " + $Fino + " (UNA TRANCHE, FrazioneIS " + $FrazioneIS + ")")
  Dico ("banco ....... MODELLO 4 (OGNI TICK, TICK REALI), UNA passata (cella CONGELATA N=" + $ECO_N + " sigma=" + (Fmt2 $ECO_SIGMA) + "), split IS/OOS " + $FrazioneIS + ". Deposito " + $Deposito + ". RUOLO DI QUESTA CORSA: " + $corsa.Ruolo)
  Dico ("regola ...... NESSUNA GRIGLIA, NESSUNA SELEZIONE: la cella e' congelata. IS e OOS sono DUE CAMPIONI della STESSA configurazione, non una scelta e una validazione. UN SOLO REGIME: da questo round NON esce una sedia.") "Yellow"

  #--- IL GATE CHE MANCAVA (difetto trovato in review il 04/09). Una
  #    corsa di ruolo PORTO esiste PER misurare una cosa sola: che i
  #    "Segnali Grezzi" dell'EA combacino con gli "Attraversamenti
  #    Grezzi" del passo 0. Con la tabella $PORTO a -1 quel confronto
  #    NON SI FA, e la corsa usciva VERDE senza aver misurato niente --
  #    mentre la pagina prometteva "se il porto fallisce il round non
  #    parte", un esito che cosi' non poteva MAI verificarsi.
  #    Adesso ci si ferma PRIMA della corsa (che a tick reali costa ore).
  if($corsa.Ruolo -eq "PORTO" -and (-not $SoloControllo) -and
     ((-not $PORTO.ContainsKey($Simbolo)) -or $PORTO[$Simbolo].GrezziL -lt 0 -or $PORTO[$Simbolo].GrezziS -lt 0)){
    throw ("COLLAUDO DEL PORTO NON ARMATO: nella tabella `$PORTO di questa riga " + $Simbolo + " vale ancora -1/-1. Questa corsa a TICK REALI non misurerebbe niente. Prendi 'Attraversamenti Grezzi Long' e 'Attraversamenti Grezzi Short' dal CSV OPTFRAME del passo 0 (riga N=" + $ECO_N + "/sigma=" + (Fmt2 $ECO_SIGMA) + "), scrivili nella tabella `$PORTO, committa e ripinna. NOTA: i referti archiviati del passo 0 NON bastano -- stampano i grezzi solo per la cella di riferimento N=20/sigma=1.05, mentre per le altre 89 celle danno gli ESEGUIBILI/giorno, che sono un'ALTRA grandezza (dopo i filtri). Serve il CSV.")
  }
  if($corsa.Ruolo -eq "PORTO" -and $SoloControllo -and
     ((-not $PORTO.ContainsKey($Simbolo)) -or $PORTO[$Simbolo].GrezziL -lt 0 -or $PORTO[$Simbolo].GrezziS -lt 0)){
    [void]$Rilievi.Add("giro a vuoto su una corsa PORTO con la tabella `$PORTO ancora a -1/-1: il CONTROLLO passa lo stesso (non misura niente per definizione), ma la CORSA VERA si fermera' qui finche' i due attesi del passo 0 non sono scritti nella riga.")
    Dico ("ATTENZIONE: tabella PORTO a -1/-1 per " + $Simbolo + ": in CONTROLLO si prosegue, in CORSA ci si ferma.") "Yellow"
  }

  # -------------------------------------------------------------------
  #  1. SCARICO AL PIN + SENTINELLA DI UN GIRO PRECEDENTE
  # -------------------------------------------------------------------
  Titolo "1. SCARICO AL PIN"
  New-Item -ItemType Directory -Force -Path $Work,$Prove | Out-Null
  if(Test-Path -LiteralPath $Sentinella){
    $SentTrovata = (@(Get-Content -LiteralPath $Sentinella -ErrorAction SilentlyContinue) -join " | ")
    [void]$Rilievi.Add("SENTINELLA di un giro PRECEDENTE INTERROTTO trovata (classe 116): " + $SentTrovata + ". I file elencati sono rimasti nel terminale; questo giro li riscrive e la sentinella viene rimossa a fine raccolta.")
    Dico ("sentinella di un giro interrotto: " + $SentTrovata) "Yellow"
  }
  $drv = Join-Path $Work "walkforward_generico.ps1"
  Scarica ($RawPin + "/backtest_pipeline/walkforward_generico.ps1") $drv
  $t = Get-Content -LiteralPath $drv -Raw
  if($t -notmatch '\$EABranch\s*=\s*"lavoro"'){ throw 'walkforward_generico.ps1 non ha la riga $EABranch = "lavoro" attesa: non lo posso pinnare (il pin varrebbe per il driver e NON per la sonda misurata).' }
  $t = $t -replace '\$EABranch\s*=\s*"lavoro"', ('$EABranch="' + $Pin + '"')
  Set-Content -LiteralPath $drv -Value $t -Encoding ASCII
  Dico "driver generico scaricato e PINNATO (riscarica la sonda al pin, non dalla punta del branch)" "Green"
  Remove-Item -Path (Join-Path $Prove "RELATIVO_*.txt") -Force -ErrorAction SilentlyContinue
  foreach($k in @($CORSE.Keys)){ Scarica ($RawPin + "/backtest_pipeline/prove/" + $CORSE[$k].File) (Join-Path $Prove $CORSE[$k].File) }
  Dico ("file prova scaricati: " + @(Get-ChildItem $Prove -Filter "RELATIVO_R117_*.txt").Count + " su " + @($CORSE.Keys).Count + " (ne gira UNO, gli altri servono al gemellaggio a SEI)") "Green"
  $mq5 = Join-Path $Work ($EA + ".mq5")
  Scarica ($RawPin + "/mql5/Experts/" + $EA + ".mq5") $mq5

  # -------------------------------------------------------------------
  #  2. IDENTITA' DEL SORGENTE (versione, autotest, colonne, input,
  #     contatore puro, include, #define delle soglie)
  # -------------------------------------------------------------------
  Titolo "2. IDENTITA' DEL SORGENTE AL PIN"
  $src = Get-Content -LiteralPath $mq5 -Raw
  $srcRighe = @(Get-Content -LiteralPath $mq5)
  $mv = [regex]::Match($src, '(?m)^\s*#property\s+version\s+"([^"]+)"')
  if(-not $mv.Success){ throw "il sorgente non ha #property version." }
  $VersioneTxt = $mv.Groups[1].Value
  if($VersioneTxt -ne $VERSIONE_ATTESA){ throw ("#property version e' '" + $VersioneTxt + "', attesa '" + $VERSIONE_ATTESA + "': non e' l'EA che la pagina descrive.") }
  $nBlocchi = 0
  foreach($rg in $srcRighe){ $viva = ($rg -replace '//.*$',''); if($viva -match '^\s*blocchi\+\+\s*;'){ $nBlocchi++ } }
  $AutoSrcTxt = "" + $nBlocchi + " blocchi (righe 'blocchi++;' fuori dai commenti)"
  if($nBlocchi -ne $AUTOTEST_BLOCCHI_ATTESI){ throw ("autotest: " + $AutoSrcTxt + ", attesi " + $AUTOTEST_BLOCCHI_ATTESI + ".") }
  if($src -notmatch '\[AUTOTEST\]\s+12\s'){ throw "autotest: manca il blocco 12 nel sorgente (etichetta [AUTOTEST] 12): e' quello che collauda LottoDaRischio_Calc, cioe' il calcolo che protegge il conto." }
  $defs = LeggiDefine $src
  #--- IL NOME DEL #define E' ABR_NSTATS, NON REL_NSTATS: REL_ era della
  #    SONDA del passo 0 (ABTG_SondaRelativo), e con quel nome questa riga
  #    moriva SEMPRE, giro a vuoto compreso. Difetto trovato in review il
  #    04/09: il gate DOPPIO (qui e al blocco 2-bis) lo nascondeva.
  $nst = [int](DefNum $defs "ABR_NSTATS")
  $NStatsTxt = "ABR_NSTATS = " + $nst + " -> " + ($nst + 3) + " colonne"
  if($nst -ne $NSTATS_ATTESI){ throw ("ABR_NSTATS = " + $nst + ", atteso " + $NSTATS_ATTESI + " (" + ($NSTATS_ATTESI + 3) + " colonne).") }
  $inputEA = LeggiInputEA $src
  $InputTxt = "" + @($inputEA).Count + " input letti dal sorgente"
  if(@($inputEA).Count -ne $INPUT_ATTESI){ throw ("input: " + $InputTxt + ", attesi " + $INPUT_ATTESI + ".") }
  #--- IL GATE E' CAMBIATO, E IL CAMBIO E' IL PUNTO: le due righe della
  #    sonda pretendevano ZERO chiamate di trading (era un contatore).
  #    Qui l'EA APRE ORDINI, quindi quel gate sarebbe sbagliato. Al suo
  #    posto c'e' il GATE HEDGE-SAFE, che e' il difetto vero di questa
  #    casa: su conto HEDGING PositionSelect(_Symbol) seleziona la
  #    posizione PIU' VECCHIA del simbolo, qualunque sia il magic, e
  #    PositionClose(_Symbol) CHIUDE QUELLA DEL VICINO.
  #    Fonte: report\AUDIT_POSITIONSELECT_HEDGING_2026-09-03.md.
  $pericolosi = 0
  $trovati = New-Object System.Collections.ArrayList
  foreach($rg in $srcRighe){
    $viva = ($rg -replace '//.*$','')
    foreach($p in @('PositionSelect(_Symbol','PositionClose(_Symbol','PositionModify(_Symbol','PositionClosePartial(_Symbol')){
      if($viva.Contains($p)){ $pericolosi++; [void]$trovati.Add($p) }
    }
  }
  $GrepTxt = "" + $pericolosi + " pattern per SIMBOLO fuori dai commenti (attesi 0: su conto HEDGING leggerebbero o chiuderebbero la posizione del VICINO)"
  if($pericolosi -gt 0){ throw ("EA NON HEDGE-SAFE: " + $GrepTxt + " -> " + ((@($trovati) | Sort-Object -Unique) -join ", ") + ". L'audit del 03/09 lo dice testualmente: il MEZZO fix (lettura corretta + scrittura per simbolo) e' PIU' PERICOLOSO del bug originale.") }
  #--- e la controprova positiva: l'EA DEVE avere il ciclo hedge-safe e
  #    la chiusura PER TICKET. Un gate che cerca solo assenze passa
  #    anche su un file che non fa niente.
  if($src -notmatch 'PositionGetTicket\s*\(' -or $src -notmatch 'PositionSelectByTicket\s*\('){ throw "l'EA non usa PositionGetTicket/PositionSelectByTicket: senza il ciclo hedge-safe la lettura della PROPRIA posizione non e' garantita." }
  if($src -notmatch 'PositionClose\s*\(\s*gTicket'){ throw "l'EA non chiude PER TICKET (PositionClose(gTicket)): su conto hedging la chiusura per simbolo colpisce la posizione piu' vecchia, che puo' essere di un altro EA." }
  $GrepTxt = $GrepTxt + "; ciclo hedge-safe e chiusura per TICKET presenti"

  $nInc = 0
  foreach($rg in $srcRighe){ $viva = ($rg -replace '//.*$',''); if($viva -match '^\s*#include\b'){ $nInc++ } }
  $IncludeTxt = "" + $nInc + " righe #include (atteso " + $INCLUDE_ATTESI + ": Trade/Trade.mqh -- qui l'EA APRE ORDINI, e 0 sarebbe l'errore)"
  if($nInc -ne $INCLUDE_ATTESI){ throw ("il sorgente ha " + $nInc + " #include invece di " + $INCLUDE_ATTESI + ".") }
  if($src -notmatch '#include\s*<Trade/Trade\.mqh>'){ throw "il sorgente non include <Trade/Trade.mqh>: l'unico include ammesso e' quello, ed e' quello che serve." }
  # GLI ATTESI DEL SORGENTE. Nell'EA NON ci sono i cancelli di merito
  # (quelli stanno in questa riga e nella pagina, apposta: un cancello
  # scritto dentro il codice misurato e' un cancello che si sposta con
  # lui). Ci sono pero' tre numeri che DEVONO combaciare, o la corsa
  # misura qualcosa di diverso da quello che la pagina promette.
  #--- ABR_NSTATS E' GIA' STATO LETTO E GATTATO QUI SOPRA: si RIUSA il
  #    valore, non si rigrepa. Il secondo grep (con un NOME DIVERSO)
  #    faceva da rete a un gate che era gia' morto, e cosi' il difetto
  #    del nome sbagliato e' rimasto invisibile. UN nome, UN gate.
  $ns = [double]$nst
  $pi = (DefNum $defs "ABR_PUNTI_PER_INDICE_ATTESO")
  $sd = (DefNum $defs "ABR_SPREAD_D30EUR")
  $sn = (DefNum $defs "ABR_SPREAD_NASUSD")
  $SpreadAtteso = $sd
  if($Simbolo -eq "NASUSD"){ $SpreadAtteso = $sn }
  $diverg = New-Object System.Collections.ArrayList
  # (ABR_NSTATS non si ricontrolla qui: e' gia' un gate DURO piu' sopra.)
  if([math]::Abs($pi - 100.0) -gt 0.001){ [void]$diverg.Add("ABR_PUNTI_PER_INDICE_ATTESO " + (Fmt2 $pi) + " vs 100,00 (conversione MISURATA sui tre indici)") }
  if([math]::Abs($sd - 2.80) -gt 0.001 -or [math]::Abs($sn - 1.80) -gt 0.001){ [void]$diverg.Add("spread attesi " + (Fmt2 $sd) + "/" + (Fmt2 $sn) + " vs 2,80/1,80 (SPREAD_FLOTTA del 03/09, mediana oraria PEGGIORE)") }
  $DefineTxt = "cancelli di MERITO (in questa riga, NON nell'EA): E >= " + (Fmt3 $A1_E_R) + " R | PF >= " + (Fmt2 $A2_PF) + " | DD <= " + (Fmt2 $A4_DD) + "% | peggior giornata >= " + (Fmt2 $A5_PEGGIOR) + "% | n >= " + $A6_N + " | sotto 60 s < " + (Fmt2 $A7_SOTTO60) + "%. Bocciatura secca: E < " + (Fmt3 $B_E_R) + " | PF < " + (Fmt2 $B_PF) + " | DD > " + (Fmt2 $B_DD) + "% | peggior giornata < " + (Fmt2 $B_PEGGIOR) + "%. Attesi dal sorgente: ABR_NSTATS " + (FmtN $ns) + ", punto indice " + (Fmt2 $pi) + ", spread " + (Fmt2 $SpreadAtteso) + " punti indice"
  if($diverg.Count -gt 0){ throw ("IL SORGENTE NON DICE QUELLO CHE DICE LA PAGINA: " + ($diverg -join "; ") + ". Ci si ferma PRIMA della corsa.") }
  Dico ("versione " + $VersioneTxt + " | autotest " + $AutoSrcTxt + " | " + $NStatsTxt + " | " + $InputTxt + " | " + $GrepTxt + " | " + $IncludeTxt) "Green"
  Dico ("cancelli e attesi: " + $DefineTxt) "Green"

  # -------------------------------------------------------------------
  #  3. I GATE SUI PROVA -- girano PRIMA di aprire MT5
  # -------------------------------------------------------------------
  Titolo "3. GATE SUI SEI PROVA (direttive nude + input nei due versi + ZERO assi + fissi + magic e modo sonda + gemellaggio a SEI)"
  $letture = [ordered]@{}
  foreach($k in @($CORSE.Keys)){
    #--- il TF atteso si legge dalla TABELLA (campo Periodo), non da una
    #    stringa cablata qui: due posti da cui leggere lo stesso fatto
    #    sono due posti che possono divergere.
    $esito = GateProva (Join-Path $Prove $CORSE[$k].File) $CORSE[$k].File $CORSE[$k].Simbolo $CORSE[$k].Periodo $inputEA $CORSE[$k].Magic $CORSE[$k].Sonda
    $letture[$k] = $esito.Lettura.Mappa
    if($k -eq $Prova){ $CelleTxt = "" + $esito.Celle + " passata (NESSUNA GRIGLIA: cella CONGELATA N=" + $ECO_N + " sigma=" + (Fmt2 $ECO_SIGMA) + ", zero assi Y nei prova)" }
  }
  Dico ("gate per prova: 4 direttive nude, " + $INPUT_ATTESI + " input pinnati nome per nome nei DUE versi, ZERO assi, magic e modo sonda gattati uno per uno, " + $CelleTxt + ", nessuna riga estranea: PASSATI su " + @($CORSE.Keys).Count + "/" + @($CORSE.Keys).Count) "Green"
  $GemelliTxt = GateGemelli $letture $DifferenzeAmmesse
  Dico ("gemellaggio: " + $GemelliTxt) "Green"

  # -------------------------------------------------------------------
  #  4. IL TETTO DELLE BARRE: si ferma, non corregge in silenzio
  # -------------------------------------------------------------------
  Titolo "4. IL TETTO DELLE ~100.000 BARRE DEL TESTER"
  $dA = [DateTime]::ParseExact($DaQuando,"yyyy.MM.dd",$INV)
  $dB = [DateTime]::ParseExact($Fino,"yyyy.MM.dd",$INV)
  $giorniChiesti = [int]($dB - $dA).TotalDays
  $tetto = $TETTO_GIORNI[$Periodo]
  $anni = ([double]$giorniChiesti/365.0).ToString("0.00",$INV)
  if($giorniChiesti -gt $tetto){
    $TettoTxt = "OLTRE IL TETTO: " + $Periodo + " chiede " + $giorniChiesti + " giorni (" + $anni + " anni) contro ~" + $tetto + " giorni (" + ([double]$tetto/365.0).ToString("0.0",$INV) + " anni) di tetto"
    if(-not $AccettoTettoBarre){
      throw ("FINESTRA OLTRE IL TETTO DEL TESTER su " + $Periodo + ": " + $giorniChiesti + " giorni chiesti (" + $anni + " anni) contro ~" + $tetto + " (CLAUDE.md 25/08). Il prova lo DICHIARA e sceglie di non spezzare; questa riga NON lo corregge in silenzio e NON parte in silenzio. Due strade, entrambe dichiarate nella pagina: (a) rilanciare CON -AccettoTettoBarre (la sonda dichiara la finestra effettiva con Giorni Contati / Gamba Prima Barra Epoch e il referto la stampa); (b) un @DAQUANDO piu' vicino nel prova (~2025.03.10 per 1,3 anni), che e' una modifica del prova e si committa.")
    }
    $TettoTxt = $TettoTxt + " -- ACCETTATO con -AccettoTettoBarre (scelta DICHIARATA): la finestra EFFETTIVA la dice la sonda, e sta qui sotto"
    [void]$Rilievi.Add("TETTO BARRE accettato esplicitamente (-AccettoTettoBarre): " + $Periodo + " su " + $giorniChiesti + " giorni chiesti contro ~" + $tetto + " di tetto. La finestra EFFETTIVA (Gamba Prima Barra Epoch, Giorni Contati, Barre Valutate) e' nel referto e va letta PRIMA di C1: il denominatore e' quello contato, non quello chiesto.")
    Dico $TettoTxt "Yellow"
  }
  else{
    $TettoTxt = "DENTRO IL TETTO: " + $Periodo + " chiede " + $giorniChiesti + " giorni (" + $anni + " anni) contro ~" + $tetto + " di tetto"
    if($AccettoTettoBarre){ [void]$Rilievi.Add("-AccettoTettoBarre passato su una corsa che sta DENTRO il tetto (" + $Periodo + "): inerte, dichiarato.") }
    Dico $TettoTxt "Green"
  }

  # -------------------------------------------------------------------
  #  5. IL TERMINALE (classe 115: da un FATTO, non dal nome) + FOTO PRIMA
  # -------------------------------------------------------------------
  Titolo "5. TERMINALE DI BACKTEST (terminal64 + metaeditor64 + cartella dati)"
  $termRoot = Join-Path $env:APPDATA "MetaQuotes\Terminal"
  $mappaT = @{}
  foreach($d in @(Get-ChildItem -LiteralPath $termRoot -Directory -ErrorAction SilentlyContinue)){
    $o = Join-Path $d.FullName "origin.txt"
    if(Test-Path -LiteralPath $o){
      $io = (Get-Content -LiteralPath $o -Raw -ErrorAction SilentlyContinue)
      if($null -ne $io){ $io = $io.Trim(); if($io -ne "" -and -not $mappaT.ContainsKey($io)){ $mappaT[$io] = $d.FullName } }
    }
  }
  $cand = New-Object System.Collections.ArrayList
  foreach($k in @($mappaT.Keys)){
    if(-not (Test-Path -LiteralPath (Join-Path $k "terminal64.exe"))){ continue }
    if(-not (Test-Path -LiteralPath (Join-Path $k "metaeditor64.exe"))){ continue }
    $df = $mappaT[$k]
    $fatto = ""
    $basi = @(Get-ChildItem -LiteralPath (Join-Path $df "bases") -Directory -ErrorAction SilentlyContinue | Where-Object { $_.Name -like "*BCM*" })
    if($basi.Count -gt 0){ $fatto = "cartella dati con bases\" + $basi[0].Name }
    elseif($k -like "*BCM*"){ $fatto = "percorso di installazione" }
    [void]$cand.Add([pscustomobject]@{ Inst=$k; Data=$df; Fatto=$fatto })
  }
  Write-Host "  installazioni MT5 con cartella dati, terminal64 e metaeditor64:" -ForegroundColor Gray
  foreach($c in $cand){ $f = $c.Fatto; if($f -eq ""){ $f = "nessun fatto BCM" }; Write-Host ("    " + $c.Inst + "   [" + $f + "]   dati: " + $c.Data) -ForegroundColor Gray }
  $scelto = $null
  if($Terminale -ne ""){
    $scelto = @($cand | Where-Object { $_.Inst -ieq $Terminale.TrimEnd("\") }) | Select-Object -First 1
    if($null -eq $scelto){ throw ("-Terminale '" + $Terminale + "' non e' fra le installazioni con cartella dati elencate qui sopra (il tester ha bisogno della cartella dati, non basta l'exe).") }
    $TermCrit = "SCELTO A MANO con -Terminale"
  }
  else{
    $conFatto = @($cand | Where-Object { $_.Fatto -ne "" })
    $senzaV3  = @($conFatto | Where-Object { $_.Inst -notlike "*-V3*" })
    if($senzaV3.Count -ge 1){
      $scelto = $senzaV3[0]; $TermCrit = "FATTO: " + $scelto.Fatto + " (scartate le installazioni -V3)"
      if($senzaV3.Count -gt 1){ [void]$Rilievi.Add("piu' di una installazione BCM non -V3 (" + $senzaV3.Count + "): scelta la prima (" + $scelto.Inst + "). Se non e' quella del banco di backtest, rilancia con -Terminale.") }
    }
    elseif($conFatto.Count -ge 1){ $scelto = $conFatto[0]; $TermCrit = "FATTO: " + $scelto.Fatto + " (solo -V3 disponibili: DICHIARATO)"; [void]$Rilievi.Add("l'unica installazione BCM con cartella dati e' una -V3: usata, dichiarato.") }
    elseif($cand.Count -eq 1){ $scelto = $cand[0]; $TermCrit = "NESSUN FATTO BCM: unica installazione presente (dichiarato)"; [void]$Rilievi.Add("nessun fatto ha identificato un terminale BCM: usata l'unica installazione MT5 con cartella dati. Dichiarato, non indovinato.") }
    else{
      $elenco = (@($cand | ForEach-Object { $_.Inst }) -join " | ")
      throw ("NON SO QUALE TERMINALE USARE (classe 115: l'ambiente non si indovina dal nome). Candidati: " + $elenco + ". Rilancia aggiungendo -Terminale ""<percorso di installazione>"".")
    }
  }
  $TermScelto = $scelto.Inst
  $DataFolder = $scelto.Data
  $TermExe = Join-Path $TermScelto "terminal64.exe"
  $MeExe   = Join-Path $TermScelto "metaeditor64.exe"
  Dico ("terminale scelto: " + $TermScelto + "  [" + $TermCrit + "]  dati: " + $DataFolder) "Yellow"

  $dstExp  = Join-Path $DataFolder "MQL5\Experts"
  $dstMq5  = Join-Path $dstExp ($EA + ".mq5")
  $dstEx5  = Join-Path $dstExp ($EA + ".ex5")
  $dstCsv  = Join-Path $DataFolder ("MQL5\Files\OptResults_" + $EA + "_" + $Simbolo + ".csv")
  $FotoPrima = @(("Experts\" + $EA + ".mq5: " + (Foto $dstMq5)), ("Experts\" + $EA + ".ex5: " + (Foto $dstEx5)), ("Files\OptResults_" + $EA + "_" + $Simbolo + ".csv: " + (Foto $dstCsv)))
  foreach($f in $FotoPrima){ Dico ("foto PRIMA  " + $f) }

  # -------------------------------------------------------------------
  #  6. COMPILAZIONE (EA MAI compilato): sentinella PRIMA di scrivere
  # -------------------------------------------------------------------
  Titolo "6. COMPILAZIONE (metaeditor64, invocazione diretta, .ex5 vecchio cancellato prima)"
  New-Item -ItemType Directory -Force -Path $dstExp | Out-Null
  Set-Content -LiteralPath $Sentinella -Value @(("scritto il " + (Get-Date).ToString("yyyy-MM-dd HH:mm:ss",$INV) + " da RIGA_RELATIVO_R117.ps1 (" + $Prova + ")"), $dstMq5, $dstEx5, $dstCsv) -Encoding ASCII
  $SentScritta = $true   # da qui in poi QUESTO giro ha toccato il terminale: la sentinella e' SUA e la cancella lui
  Copy-Item -LiteralPath $mq5 -Destination $dstMq5 -Force
  Remove-Item -LiteralPath $dstEx5 -Force -ErrorAction SilentlyContinue
  $logC = Join-Path $Work "COMPILAZIONE.log"
  Remove-Item -LiteralPath $logC -Force -ErrorAction SilentlyContinue
  $tComp = Get-Date
  $global:LASTEXITCODE = $null
  & $MeExe ("/compile:" + $dstMq5) ("/log:" + $logC) | Out-Null
  $grezzoMe = $LASTEXITCODE
  $RcMeTxt = "NON LETTO"
  if($null -ne $grezzoMe -and (("" + $grezzoMe).Trim()) -match '^-?\d+$'){ $RcMeTxt = "" + $grezzoMe }
  $battito = 0; $muto = $false
  while($true){
    if((Test-Path -LiteralPath $dstEx5) -and ((Get-Item -LiteralPath $dstEx5).LastWriteTime -ge $tComp)){ break }
    $lr = LeggiTesto $logC
    if(@($lr).Count -gt 0 -and (@($lr) -match 'Result:').Count -gt 0){ break }
    $sec = (New-TimeSpan -Start $tComp -End (Get-Date)).TotalSeconds
    if(@($lr).Count -eq 0 -and $sec -ge 30){ $muto = $true; break }
    if($sec -ge 240){ break }
    if($sec -ge ($battito + 10)){ $battito = [int]$sec; Dico ("   ... aspetto l'.ex5 da " + $battito + "s (tetto 240s): NON interrompere") }
    Start-Sleep -Seconds 2
  }
  $LogRighe = @(LeggiTesto $logC)
  $nErr = -1; $nWar = -1
  foreach($r in $LogRighe){
    $m = [regex]::Match($r, '(?i)(\d+)\s+error[s]?\s*,\s*(\d+)\s+warning')
    if($m.Success){ $nErr = [int]::Parse($m.Groups[1].Value,$INV); $nWar = [int]::Parse($m.Groups[2].Value,$INV); $ResultTxt = $r.Trim() }
  }
  if($nErr -lt 0){ $ResultTxt = "NON TROVATA nel log (fa fede l'.ex5)" }
  $ex5Fresco = ((Test-Path -LiteralPath $dstEx5) -and ((Get-Item -LiteralPath $dstEx5).LastWriteTime -ge $tComp))
  if($ex5Fresco -and $nErr -le 0){
    $itm = Get-Item -LiteralPath $dstEx5
    $wtxt = "warning NON LETTI"; if($nWar -ge 0){ $wtxt = "" + $nWar + " warning" }
    $Compilato = "OK (" + [int]($itm.Length/1024) + " KB, " + $itm.LastWriteTime.ToString("HH:mm:ss",$INV) + "), 0 errors, " + $wtxt
    Dico ("compilato " + $EA + ": " + $Compilato) "Green"
    if($nWar -gt 0){ [void]$Rilievi.Add("la compilazione ha prodotto " + $nWar + " warning: non bloccano, ma vanno letti nel log dentro lo zip."); foreach($r in $LogRighe){ if($r -match '(?i):\s*warning'){ [void]$Rilievi.Add("  warning: " + $r.Trim()) } } }
  }
  else{
    $quanti = "NON LETTI"; if($nErr -ge 0){ $quanti = "" + $nErr }
    $Compilato = "FALLITA (MetaEditor lanciato, nessun .ex5 fresco; errori dal log: " + $quanti + ") -- QUESTO E' IL RISULTATO DEL PASSO: EA nuovo, mai compilato"
    if($muto -or @($LogRighe).Count -eq 0){ $Compilato = "FALLITA -- METAEDITOR MUTO: lanciato e tornato SENZA scrivere ne' log ne' .ex5 (editor aperto, percorso, permessi). NON e' un verdetto sul codice: ricontrollare metaeditor64 chiuso e rifare." }
    Dico ("COMPILAZIONE FALLITA. Prime 30 righe del log:") "Red"
    $k = 0; foreach($r in $LogRighe){ if($r.Trim() -eq ""){ continue }; Write-Host ("      " + $r) -ForegroundColor Red; $k++; if($k -ge 30){ break } }
    throw ("COMPILAZIONE FALLITA: " + $Compilato)
  }

  # LA CACHE DEL TESTER (checklist punto 38): un pass ripescato non
  # chiama OnTester e lascia il CSV monco. Si svuota SOLO Tester\cache.
  $cacheT = Join-Path $DataFolder "Tester\cache"
  if(Test-Path -LiteralPath $cacheT){
    $ncPrima = @(Get-ChildItem -LiteralPath $cacheT -Recurse -File -ErrorAction SilentlyContinue).Count
    Remove-Item (Join-Path $cacheT "*") -Recurse -Force -ErrorAction SilentlyContinue
    $ncDopo  = @(Get-ChildItem -LiteralPath $cacheT -Recurse -File -ErrorAction SilentlyContinue).Count
    $CacheTxt = "prima " + $ncPrima + " file, dopo " + $ncDopo
    if($ncDopo -gt 0){ [void]$Problemi.Add("Tester\cache NON si e' svuotata (" + $CacheTxt + "): un pass ripescato non chiama OnTester e lascia il CSV monco."); Dico ("Tester\cache NON SVUOTATA: " + $CacheTxt) "Red" }
    else{ Dico ("Tester\cache svuotata: " + $CacheTxt) "Green" }
  }
  else{ $CacheTxt = "cartella assente: niente da svuotare"; Dico ("Tester\cache: " + $CacheTxt) "Yellow" }

  # -------------------------------------------------------------------
  #  7. LA CORSA -- il generico, UNA volta, con lo STESSO terminale
  # -------------------------------------------------------------------
  Titolo ("7. LA CORSA " + $Prova + " (generico, Modello 4 TICK REALI, FrazioneIS " + $FrazioneIS + ", -Rifai)")
  $tCorsa = Get-Date
  $argv = @("-ExecutionPolicy","Bypass","-File",$drv,
            "-Expert",$EA,
            "-Prova",(Join-Path $Prove $FileProva),
            "-Etichetta",$Prova,
            "-DaQuando",$DaQuando,
            "-Fino",$Fino,
            "-FrazioneIS",("" + $FrazioneIS),
            "-Modello","4",
            "-Rifai",
            "-Deposito",("" + $Deposito),
            "-Terminal",$TermExe,
            "-MetaEditor",$MeExe,
            "-DataFolder",$DataFolder)
  if($SoloControllo){ $argv += "-SoloControllo" }
  Dico ("argv generico: " + ($argv -join " "))
  $global:LASTEXITCODE = $null
  & powershell $argv
  $grezzo = $LASTEXITCODE
  $rc = -1; $rcLetto = $false
  if($null -ne $grezzo -and (("" + $grezzo).Trim()) -match '^-?\d+$'){ $rc = [int](("" + $grezzo).Trim()); $rcLetto = $true }
  if($rcLetto){ $RcGenTxt = "" + $rc } else { $RcGenTxt = "NON LETTO" }
  if($rcLetto -and $rc -ne 0){ [void]$Problemi.Add("il generico e' uscito con codice " + $rc + " (controlli non passati? storico mancante? CSV non prodotto? Il rosso sul *_OOS invece e' ATTESO con FrazioneIS 1.0).") }
  elseif(-not $rcLetto){ [void]$Rilievi.Add("codice di uscita del generico NON LETTO (vuoto su PS 5.1, classe 108): non e' un fallimento e non e' un successo. Il verdetto sta sugli ARTEFATTI DATATI.") }

  if($SoloControllo){
    # l'artefatto datato del giro a vuoto: l'anteprima .ini del generico
    # (SOLO esistenza e data: sul Model mente, punto 96 della checklist).
    $ante = Join-Path $Work ("anteprima_" + $EA + "_" + $Simbolo + ".ini")
    if((Test-Path -LiteralPath $ante) -and ((Get-Item -LiteralPath $ante).LastWriteTime -ge $tCorsa)){
      $AnteprimaTxt = "FRESCA (" + (Get-Item -LiteralPath $ante).LastWriteTime.ToString("HH:mm:ss",$INV) + "): il generico ha passato i suoi controlli. ATTENZIONE: l'anteprima scrive Model=4 HARDCODED, quindi NON PUO' fare da prova che la corsa gira a tick reali -- quella prova sta nel REPORT DEL TESTER, e va letta li'."
      $nIni = @(Get-Content -LiteralPath $ante | Where-Object { $_ -match '^Inp\w+=' }).Count
      $AnteprimaTxt = $AnteprimaTxt + " Righe Inp* in [TesterInputs]: " + $nIni + " (attese " + $INPUT_ATTESI + ")"
      if($nIni -ne $INPUT_ATTESI){ [void]$Problemi.Add("anteprima .ini con " + $nIni + " righe Inp* invece di " + $INPUT_ATTESI + ".") }
    }
    else{ $AnteprimaTxt = "ASSENTE o VECCHIA: il generico NON e' arrivato a scriverla (controlli non passati: leggere l'output qui sopra)"; [void]$Problemi.Add("giro a vuoto: anteprima .ini del generico assente o piu' vecchia dell'avvio: i controlli del generico non sono passati.") }
    Dico ("anteprima: " + $AnteprimaTxt)
  }
  else{
    #--- a Modello 4 il generico NON mette il suffisso "_ohlc": quel
    #    suffisso e' proprio la marca dei modelli non-tick. Cercarlo qui
    #    vorrebbe dire non trovare mai il CSV giusto.
    $csvIS  = Join-Path $Results ($EA + "_" + $Simbolo + "_IS_"  + $Prova + ".csv")
    $csvOOS = Join-Path $Results ($EA + "_" + $Simbolo + "_OOS_" + $Prova + ".csv")
    $GambaIS  = LeggiGamba $csvIS  $tCorsa "IS"
    $GambaOOS = LeggiGamba $csvOOS $tCorsa "OOS"
    $CollaudiKo = 0
    $CollaudiKo += CollaudiGamba $GambaIS  "IS"  $corsa.Ruolo
    $CollaudiKo += CollaudiGamba $GambaOOS "OOS" $corsa.Ruolo

    #--- I CANCELLI DI MERITO. Si calcolano SOLO se i collaudi di sanita'
    #    sono verdi: un cancello letto su numeri che non stanno in piedi
    #    e' un verdetto su niente (clausola severa).
    if($corsa.Ruolo -eq "PORTO"){
      $RigheCancelli = @("  (ruolo PORTO: questa corsa non apre ordini, i cancelli di merito non si applicano)")
      $VerdettoGamba = "n/d (corsa di collaudo del nucleo)"
    }
    elseif($CollaudiKo -gt 0){
      $RigheCancelli = @("  (NON CALCOLATI: " + $CollaudiKo + " collaudi di sanita' falliti -- vedi PROBLEMI. Clausola severa: i numeri NON si leggono.)")
      $VerdettoGamba = "NON LEGGIBILE (" + $CollaudiKo + " collaudi falliti)"
    }
    else{
      $rr = $null
      $VerdettoGamba = CancelliMerito $GambaIS $GambaOOS ([ref]$rr)
      if($null -ne $rr){ $RigheCancelli = @($rr) }
    }

    #--- IL GEMELLO DI DETERMINISMO: se il CSV della corsa gemella e'
    #    gia' in workdir, si confronta ADESSO. Due passate con gli
    #    stessi input e magic diverso devono venire IDENTICHE AL
    #    CENTESIMO: se divergono, il banco e' sporco e nessun numero di
    #    questo round vale, per bello che sia.
    if($corsa.Gemello -ne "" -and $null -ne $GambaOOS){
      $csvG = Join-Path $Results ($EA + "_" + $Simbolo + "_OOS_" + $corsa.Gemello + ".csv")
      if(-not (Test-Path -LiteralPath $csvG)){
        $GemelloTxt = "NON CONFRONTABILE ORA: il CSV della corsa gemella (" + $corsa.Gemello + ") non e' ancora in workdir. Si confronta A MANO fra i due referti: profitto netto, PF, operazioni e drawdown devono coincidere AL CENTESIMO."
        [void]$Rilievi.Add("gemello di determinismo NON verificato a macchina in questa corsa (manca il CSV di " + $corsa.Gemello + "): il confronto va fatto a mano fra i due referti, ed e' un gate, non una formalita'.")
      }
      else{
        # CLASSE 122 (difetto trovato in review il 04/09): il CSV del
        # gemello e' della corsa PRECEDENTE per costruzione, quindi DEVE
        # essere piu' vecchio dell'avvio di QUESTA corsa. Passargli
        # $tCorsa lo faceva scartare SEMPRE come "STANTIO", e i confronti
        # gemelli davano "PROBLEMI" falsi al 100%. Qui la guardia di
        # freschezza NON si applica: la data si DICHIARA nel referto.
        $itmG = Get-Item -LiteralPath $csvG
        $gg = LeggiGamba $csvG ([DateTime]::MinValue) ("OOS gemello " + $corsa.Gemello)
        $EtaGemello = " (CSV del gemello scritto il " + $itmG.LastWriteTime.ToString("yyyy-MM-dd HH:mm:ss",$INV) + ": DEVE essere della corsa precedente)"
        if($null -eq $gg){ $GemelloTxt = "NON CONFRONTABILE: il CSV del gemello esiste ma non e' leggibile (vedi PROBLEMI)." + $EtaGemello }
        else{
          $sc = New-Object System.Collections.ArrayList
          foreach($k in @("Operazioni Totali","Segnali Grezzi Long","Segnali Grezzi Short","Uscite Convergenza","Uscite Stop")){
            if([math]::Abs($GambaOOS[$k] - $gg[$k]) -gt 0.5){ [void]$sc.Add($k + " " + (FmtN $GambaOOS[$k]) + " vs " + (FmtN $gg[$k])) }
          }
          foreach($k in @("Profitto Netto","Profit Factor","Equity Dd Pct","Aspettativa In R")){
            if([math]::Abs($GambaOOS[$k] - $gg[$k]) -gt 0.011){ [void]$sc.Add($k + " " + (Fmt3 $GambaOOS[$k]) + " vs " + (Fmt3 $gg[$k])) }
          }
          if($sc.Count -eq 0){
            $GemelloTxt = "IDENTICI: " + $Prova + " e " + $corsa.Gemello + " coincidono su 9 grandezze su 9 (5 conteggi esatti + 4 numeri economici a 0,01). Il banco e' deterministico." + $EtaGemello
          }
          else{
            $GemelloTxt = "DIVERGONO: " + ($sc -join "; ") + "." + $EtaGemello
            [void]$Problemi.Add("GEMELLI DIVERGENTI fra " + $Prova + " e " + $corsa.Gemello + ": " + ($sc -join "; ") + ". Due passate con gli stessi input e magic diverso DEVONO venire identiche al centesimo. Il banco e' sporco: NESSUN numero di questo round si legge, per bello che sia.")
          }
        }
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
#  RACCOLTA + PULIZIA -- SEMPRE, anche quando la corsa si e' fermata.
#  (classe 116: il ripristino NON vive solo nel ramo felice)
# =====================================================================
if($Modo -ne "CORSA" -and $Modo -ne "CONTROLLO"){ [void]$Problemi.Add("BUG INTERNO (punto 79): variabile del modo sovrascritta (" + $Modo + ")."); $Modo = "CORSA"; if($SoloControllo){ $Modo = "CONTROLLO" } }
Titolo "RACCOLTA"
$Pulizia = "niente da pulire (il terminale non e' stato toccato)"
if($DataFolder -ne ""){
  $dstExp = Join-Path $DataFolder "MQL5\Experts"
  $dstMq5 = Join-Path $dstExp ($EA + ".mq5"); $dstEx5 = Join-Path $dstExp ($EA + ".ex5")
  $dstCsv = Join-Path $DataFolder ("MQL5\Files\OptResults_" + $EA + "_" + $Simbolo + ".csv")
  # l'unico residuo che si toglie e' il CSV grezzo NOSTRO rimasto in
  # MQL5\Files (il generico lo sposta; se e' morto prima, resta li' e il
  # prossimo giro lo leggerebbe come fresco). I .mq5/.ex5 RESTANO e si
  # DICHIARANO -- e QUI la dichiarazione e' cambiata (difetto trovato in
  # review il 04/09): diceva "contatore senza ordini", che era vero per
  # la SONDA del passo 0 e NON lo e' per questo EA.
  $tolto = "nessun CSV grezzo residuo"
  if(Test-Path -LiteralPath $dstCsv){ Remove-Item -LiteralPath $dstCsv -Force -ErrorAction SilentlyContinue; $tolto = "rimosso il CSV grezzo residuo " + $dstCsv }
  $FotoDopo = @(("Experts\" + $EA + ".mq5: " + (Foto $dstMq5)), ("Experts\" + $EA + ".ex5: " + (Foto $dstEx5)), ("Files\OptResults_" + $EA + "_" + $Simbolo + ".csv: " + (Foto $dstCsv)))
  $Pulizia = $tolto + "; nel terminale RESTANO (dichiarati, non cancellati, riscritti a ogni corsa): " + $dstMq5 + " e " + $dstEx5 + " -- ATTENZIONE: questo .ex5 SA APRIRE POSIZIONI (non e' il contatore puro del passo 0). Se qualcuno lo attacca a un grafico vivo, manda ordini: sul banco di backtest resta li' apposta, sul VPS non ci deve arrivare."
}
#--- LA SENTINELLA SI CANCELLA SOLO SE E' DI QUESTO GIRO (rilievo del
#    04/09). Prima si cancellava incondizionatamente: un giro fermato da
#    un gate PRIMA di toccare il terminale cancellava cosi' la sentinella
#    di un giro PRECEDENTE davvero interrotto, e i suoi residui restavano
#    nel terminale senza piu' nessuno che li dichiarasse.
if($SentScritta){
  Remove-Item -LiteralPath $Sentinella -Force -ErrorAction SilentlyContinue
  $SentNota = "rimossa (era di QUESTO giro: il terminale e' stato toccato e i file sono nella foto DOPO)"
}
elseif(Test-Path -LiteralPath $Sentinella){
  $SentNota = "LASCIATA DOV'ERA: questo giro si e' fermato PRIMA di toccare il terminale, quindi la sentinella NON e' sua. Contenuto: " + $SentTrovata
  [void]$Rilievi.Add("sentinella NON rimossa perche' NON di questo giro: si e' fermato prima di scrivere nel terminale. Resta a dichiarare i residui del giro precedente, ed e' giusto cosi'.")
}
else{ $SentNota = "nessuna sentinella da rimuovere (questo giro non ha toccato il terminale)" }

$suff = ""
if($Modo -eq "CONTROLLO"){ $suff = "CONTROLLO_" }
$Cart = Join-Path $Dsk ("RELATIVO_R117_" + $Prova + "_" + $suff + $Stamp)
if($Prova -eq ""){ $Cart = Join-Path $Dsk ("RELATIVO_R117_SENZAPROVA_" + $suff + $Stamp) }
New-Item -ItemType Directory -Force -Path $Cart | Out-Null

#--- QUI L'OOS SERVE, e la sua ASSENZA e' un problema (nelle righe
#    della sonda era il contrario: li' la gamba OOS era degenere).
$nOos = 0
if($Prova -ne "" -and (Test-Path -LiteralPath (Join-Path $Results ($EA + "_" + $Simbolo + "_OOS_" + $Prova + ".csv")))){ $nOos = 1 }
if($nOos -eq 0 -and $Modo -eq "CORSA"){ [void]$Problemi.Add("CSV *_OOS ASSENTE: con split " + $FrazioneIS + " la gamba OOS deve esistere, ed e' quella su cui si leggono TUTTI i cancelli di merito. Senza, il round non si giudica.") }

$R = New-Object System.Collections.ArrayList
[void]$R.Add("=====================================================================")
[void]$R.Add(" RELATIVO -- R117, PASSO 1: MERITO A TICK REALI (" + $EA + ")")
[void]$R.Add(" gamba " + $Simbolo + " (si scambia) x metro " + $METRO + " (si legge), " + $Periodo + " -- QUESTO EA APRE ORDINI -- ruolo: " + $RuoloTxt)
[void]$R.Add("=====================================================================")
[void]$R.Add("modo: " + $Modo + "   <- CONTROLLO = giro a vuoto, NON e' il risultato")
[void]$R.Add("data: " + $Avvio.ToString("yyyy-MM-dd HH:mm:ss",$INV) + "   <- ORA DI AVVIO, non di fine. A TICK REALI la corsa e' lunga: non e' un blocco.")
[void]$R.Add("pin:  " + $Pin)
[void]$R.Add("prova: " + $Prova + " = " + $FileProva + " | magic atteso " + $MagicTxt + " | modo sonda atteso " + $SondaTxt)
[void]$R.Add("finestra: " + $DaQuando + " -> " + $Fino + "  (split IS/OOS " + $FrazioneIS + ")")
[void]$R.Add("banco: MODELLO 4 (OGNI TICK, TICK REALI). E' il punto del round: sul tick reale lo spread NON si assume, SI PAGA. Il Model si verifica sul REPORT DEL TESTER, non sull'anteprima .ini (che scrive 4 hardcoded). Deposito " + $Deposito + ".")
[void]$R.Add("terminale: " + $TermScelto + "   [" + $TermCrit + "]   dati: " + $DataFolder)
[void]$R.Add("compilazione: " + $Compilato + "   <- EA NUOVO, MAI COMPILATO PRIMA: se e' FALLITA, QUESTO e' il risultato del passo")
[void]$R.Add("riga Result del log: " + $ResultTxt)
[void]$R.Add("codice di uscita di metaeditor64: " + $RcMeTxt + "   (NON LETTO non e' un fallimento: fa fede l'.ex5 e il log)")
[void]$R.Add("versione letta dal #property: " + $VersioneTxt + " (attesa " + $VERSIONE_ATTESA + ")")
[void]$R.Add("autotest nel sorgente: " + $AutoSrcTxt + " (attesi " + $AUTOTEST_BLOCCHI_ATTESI + ")")
[void]$R.Add("colonne: " + $NStatsTxt + " (attese " + ($NSTATS_ATTESI + 3) + ")")
[void]$R.Add("input: " + $InputTxt + " (attesi " + $INPUT_ATTESI + ", tutti pinnati nei prova)")
[void]$R.Add("gate HEDGE-SAFE: " + $GrepTxt)
[void]$R.Add("include: " + $IncludeTxt)
[void]$R.Add("passate: " + $CelleTxt)
[void]$R.Add("gemellaggio 6 prova: " + $GemelliTxt)
[void]$R.Add("tetto barre: " + $TettoTxt)
[void]$R.Add("cache tester: " + $CacheTxt)
[void]$R.Add("codice di uscita del generico: " + $RcGenTxt)
[void]$R.Add("anteprima .ini (solo CONTROLLO): " + $AnteprimaTxt)
[void]$R.Add("foto PRIMA dei file del terminale:")
foreach($f in $FotoPrima){ [void]$R.Add("   " + $f) }
[void]$R.Add("foto DOPO:")
foreach($f in $FotoDopo){ [void]$R.Add("   " + $f) }
[void]$R.Add("pulizia: " + $Pulizia)
[void]$R.Add("sentinella: " + $SentNota)
[void]$R.Add("")
[void]$R.Add("--- I CANCELLI, SCRITTI PRIMA DEI NUMERI (stanno nella riga e nella pagina, NON nell'EA) ---")
[void]$R.Add("  " + $DefineTxt)
[void]$R.Add("  LE FASCE SONO DISGIUNTE: fra PASSA e BOCCIATA SECCA c'e' SEMPRE una ZONA MORTA (non passa, ma non e' una")
[void]$R.Add("  bocciatura del meccanismo). Qualunque valore ambiguo si scioglie verso la clausola PIU' SEVERA, e si dichiara.")
[void]$R.Add("  IL RISCHIO NON SI SOSPENDE MAI: A4 (drawdown) e A5 (peggior giornata) bocciano DA SOLI, qualunque sia il PF")
[void]$R.Add("  e qualunque sia n (Emendamento della Finestra, regola B).")
[void]$R.Add("  n < " + $N_NON_MISURABILE + " NON e' una bocciatura: e' NON MISURABILE, e la conclusione NON e' sull'edge.")
[void]$R.Add("")
[void]$R.Add("--- I COLLAUDI DI SANITA' (si leggono PRIMA di qualunque numero economico) ---")
if($null -ne $GambaIS -or $null -ne $GambaOOS){
  foreach($g in @($GambaIS, $GambaOOS)){
    if($null -eq $g){ continue }
    $e = $g["_etichetta"]
    [void]$R.Add("  [" + $e + "] autotest " + (FmtN $g["Autotest Falliti"]) + " falliti su " + (FmtN $g["Autotest Blocchi"]) + " (attesi 0/" + $AUTOTEST_BLOCCHI_ATTESI + ") | punto indice " + (Fmt3 $g["Punto Indice Prezzo"]) + " (atteso 1,000) | sotto 60 s " + (Fmt2 $g["Sotto 60 Secondi Pct"]) + "% (atteso 0,00 a M5)")
    [void]$R.Add("  [" + $e + "] ECO DEI PIN: N " + (FmtN $g["Finestra N"]) + " | sigma " + (Fmt2 $g["Soglia Ingresso Sigma"]) + " | uscita " + (Fmt2 $g["Soglia Uscita Sigma"]) + " | SL " + (Fmt2 $g["Atr Sl Multiplo"]) + " ATR | tetto " + (FmtN $g["Max Trades Day"]) + "/gg | rischio " + (Fmt2 $g["Risk Percent"]) + "% | lato " + (FmtN $g["Lato Attivo"]) + " | modo sonda " + (FmtN $g["Modo Sonda"]) + " | magic " + (FmtN $g["Magic"]))
    [void]$R.Add("  [" + $e + "] ordini rifiutati " + (FmtN $g["Ordini Rifiutati"]) + " (ultimo retcode " + (FmtN $g["Ultimo Retcode"]) + ") | SL allargato da stops level " + (FmtN $g["Sl Allargato Da Stops Level"]) + " | uscite ignote " + (FmtN $g["Uscite Ignote"]) + " (atteso 0)")
    [void]$R.Add("  [" + $e + "] storico: prima barra GAMBA " + ([DateTime]'1970-01-01').AddSeconds($g["Gamba Prima Barra Epoch"]).ToString("yyyy-MM-dd HH:mm",$INV) + " | METRO " + ([DateTime]'1970-01-01').AddSeconds($g["Metro Prima Barra Epoch"]).ToString("yyyy-MM-dd HH:mm",$INV))
    [void]$R.Add("  [" + $e + "] barre valutate " + (FmtN $g["Barre Valutate"]) + " | fuori finestra " + (FmtN $g["Barre Fuori Finestra"]) + " | saltate per dati " + (FmtN $g["Barre Saltate Dati"]) + " | giorni contati " + (FmtN $g["Giorni Contati"]))
    [void]$R.Add("  [" + $e + "] DUE FEED: metro mancante sul segnale " + (FmtN $g["Valutazioni Metro Mancante Segnale"]) + " | perse per buco " + (FmtN $g["Valutazioni Perse Buco Finestra"]) + " | solo metro " + (FmtN $g["Valutazioni Con Solo Metro"]) + " | z non calcolabile " + (FmtN $g["Z Non Calcolabile"]))
  }
  [void]$R.Add("  collaudi falliti in totale: " + $CollaudiKo + " (uno solo = NON LEGGIBILE, clausola severa)")
}
else{ [void]$R.Add("  SENZA NUMERI: nessuna delle due gambe e' stata prodotta o letta (vedi PROBLEMI / FERMATO).") }
[void]$R.Add("")
[void]$R.Add("--- IL COLLAUDO DEL PORTO (vale solo per le corse di ruolo PORTO) ---")
if($RuoloTxt -ne "PORTO"){
  [void]$R.Add("  non pertinente: questa corsa ha ruolo " + $RuoloTxt + ". Il porto si legge nelle corse D30_PORTO / NAS_PORTO.")
}
elseif($null -eq $GambaIS -and $null -eq $GambaOOS){
  [void]$R.Add("  NON ESEGUITO: nessuna gamba letta.")
}
elseif(-not $PORTO.ContainsKey($Simbolo) -or $PORTO[$Simbolo].GrezziL -lt 0 -or $PORTO[$Simbolo].GrezziS -lt 0){
  [void]$R.Add("  NON ESEGUITO, E NON E' UN VERDE: gli attesi del passo 0 non sono stati messi nella tabella `$PORTO di questa riga")
  [void]$R.Add("  (valgono -1). Vanno presi dal CSV OPTFRAME del passo 0, riga N=" + $ECO_N + " sigma=" + (Fmt2 $ECO_SIGMA) + ", colonne")
  [void]$R.Add("  'Attraversamenti Grezzi Long' e 'Attraversamenti Grezzi Short', e scritti nella riga PRIMA del lancio.")
  [void]$R.Add("  (i referti archiviati del passo 0 NON bastano: per le 90 celle stampano gli ESEGUIBILI/giorno, i GREZZI solo per")
  [void]$R.Add("   la cella di riferimento N=20/sigma=1.05. Sono due grandezze diverse e una non si ricava dall'altra.)")
  if($Modo -eq "CORSA"){
    [void]$Problemi.Add("COLLAUDO DEL PORTO NON ESEGUITO IN UNA CORSA VERA: gli attesi del passo 0 nella tabella PORTO valgono -1. Il gate a monte avrebbe dovuto fermare questa corsa PRIMA di aprire MT5: se sei arrivato qui, il gate e' stato aggirato o rotto. La corsa produce i suoi 'Segnali Grezzi' ma nessuno li confronta: il porto del nucleo statistico resta NON VERIFICATO, e questo round NON PARTE.")
  }
  else{
    [void]$Rilievi.Add("COLLAUDO DEL PORTO NON ESEGUITO (giro a vuoto): gli attesi del passo 0 nella tabella PORTO valgono -1. In CONTROLLO e' atteso e non blocca; nella CORSA VERA il gate a monte si ferma.")
  }
}
else{
  #--- I DUE LATI SI CONFRONTANO SEPARATI (rilievo del 04/09): sulla
  #    SOLA somma L+S uno scambio compensativo (long in piu', short in
  #    meno) passerebbe inosservato, ed e' esattamente il difetto di
  #    trasporto che questo collaudo dovrebbe pescare.
  $totL = 0.0; $totS = 0.0
  foreach($g in @($GambaIS, $GambaOOS)){ if($null -ne $g){ $totL += $g["Segnali Grezzi Long"]; $totS += $g["Segnali Grezzi Short"] } }
  $tot  = $totL + $totS
  $attL = [double]$PORTO[$Simbolo].GrezziL
  $attS = [double]$PORTO[$Simbolo].GrezziS
  $sommaAttesa = $attL + $attS
  [void]$R.Add("  grezzi misurati (IS + OOS): LONG " + (FmtN $totL) + " | SHORT " + (FmtN $totS) + " | somma " + (FmtN $tot))
  [void]$R.Add("  grezzi attesi dal passo 0 (cella N=" + $ECO_N + " sigma=" + (Fmt2 $ECO_SIGMA) + "): LONG " + (FmtN $attL) + " | SHORT " + (FmtN $attS) + " | somma " + (FmtN $sommaAttesa))
  #--- LA TOLLERANZA NON E' ZERO, E IL PERCHE' VA SCRITTO PRIMA DI
  #    LEGGERE IL NUMERO. Il passo 0 girava la finestra INTERA in una
  #    passata sola; qui il generico la spezza in IS e OOS, e la passata
  #    OOS riparte con un warmup suo. Intorno alla giuntura qualche
  #    attraversamento puo' quindi mancare o comparire: e' un effetto
  #    del BANCO, non del nucleo. Tolleranza: 0,5% della somma attesa,
  #    e comunque non piu' di 20 attraversamenti.
  #    La tolleranza si applica A CIASCUN LATO, calcolata sull'atteso di
  #    quel lato: cosi' un long in piu' e uno short in meno NON si
  #    cancellano a vicenda dentro una somma.
  $tolL = [math]::Max(20.0, 0.005*$attL)
  $tolS = [math]::Max(20.0, 0.005*$attS)
  $scaL = [math]::Abs($totL - $attL)
  $scaS = [math]::Abs($totS - $attS)
  $tolleranza = [math]::Max(20.0, 0.005*$sommaAttesa)
  $scarto = [math]::Abs($tot - $sommaAttesa)
  [void]$R.Add("  scarto LONG  " + (FmtN $scaL) + " su una tolleranza di " + (FmtN $tolL))
  [void]$R.Add("  scarto SHORT " + (FmtN $scaS) + " su una tolleranza di " + (FmtN $tolS))
  [void]$R.Add("  scarto sulla somma " + (FmtN $scarto) + " su " + (FmtN $tolleranza) + " (0,5% dell'atteso, minimo 20: SONO DUE le cause dichiarate, e la seconda NON e' quantificata)")
  [void]$R.Add("  CAUSA 1 (quantificata): la giuntura IS/OOS. Il passo 0 girava la finestra intera in UNA passata, qui il generico")
  [void]$R.Add("      la spezza e la passata OOS riparte col suo warmup di " + $FissiAttesi["InpWarmupBarre"] + " barre: ~5-10 attraversamenti per lato.")
  [void]$R.Add("  CAUSA 2 (NON QUANTIFICATA): il passo 0 girava a MODELLO 2 (open prices, barre dallo storico M1), questa corsa")
  [void]$R.Add("      gira a MODELLO 4 (tick reali, barre COSTRUITE dai tick). Le chiusure M5 possono differire, quindi lo z-score")
  [void]$R.Add("      puo' differire, quindi un attraversamento di confine puo' ribaltarsi. NESSUNO ha misurato quanto: percio'")
  [void]$R.Add("      questo collaudo, se cade, e' un RILIEVO da indagare, NON la prova che il nucleo sia stato trasportato male.")
  [void]$R.Add("  >>> IL VERDETTO SI LEGGE SUI DUE LATI SEPARATI, non sulla somma: uno scambio compensativo (long in piu', short in")
  [void]$R.Add("      meno) lascerebbe la somma perfetta ed e' proprio il difetto di trasporto che questo collaudo deve pescare.")
  if($scaL -le $tolL -and $scaS -le $tolS){
    [void]$R.Add("  ESITO: PASSATO SU ENTRAMBI I LATI. Il nucleo statistico e' stato trasportato bene: lo z-score si calcola su barre")
    [void]$R.Add("  CHIUSE, e i due lati combaciano dentro la tolleranza dichiarata: il trasporto del nucleo NON ha lasciato traccia qui.")
    [void]$R.Add("  Resta detto che la CAUSA 2 (Modello 2 vs Modello 4) non e' mai stata misurata: questo esito la LIMITA, non la esclude.")
    if($scaL -gt 0.5 -or $scaS -gt 0.5){ [void]$Rilievi.Add("collaudo del porto passato ma NON esatto: scarto L " + (FmtN $scaL) + " / S " + (FmtN $scaS) + " attraversamenti sulla giuntura IS/OOS, dentro la tolleranza dichiarata. Se lo scarto crescesse su altre corse, la spiegazione della giuntura andrebbe verificata invece che ripetuta.") }
  }
  else{
    $quali = New-Object System.Collections.ArrayList
    if($scaL -gt $tolL){ [void]$quali.Add("LONG " + (FmtN $totL) + " vs " + (FmtN $attL) + " (scarto " + (FmtN $scaL) + ", tolleranza " + (FmtN $tolL) + ")") }
    if($scaS -gt $tolS){ [void]$quali.Add("SHORT " + (FmtN $totS) + " vs " + (FmtN $attS) + " (scarto " + (FmtN $scaS) + ", tolleranza " + (FmtN $tolS) + ")") }
    [void]$R.Add("  ESITO: FUORI TOLLERANZA su " + ($quali -join " e ") + " -- vedi RILIEVI: le cause possibili sono tre, due non quantificate.")
    $PortoFuoriTolleranza = $true
    [void]$Rilievi.Add("COLLAUDO DEL PORTO FUORI TOLLERANZA: " + ($quali -join "; ") + " -- stessa cella e stessa finestra del passo 0. LE CAUSE POSSIBILI SONO TRE, e due non sono quantificate: (a) il nucleo statistico trasportato male; (b) il MODELLO DEL TESTER diverso (passo 0 = Modello 2 open prices, qui = Modello 4 tick reali: le barre M5 sono COSTRUITE in modo diverso, le chiusure possono differire e un attraversamento di confine si ribalta); (c) la finestra effettiva diversa (leggere Giorni Contati, Barre Valutate, Gamba Prima Barra Epoch). PRIMA di rifare l'EA: confrontare Giorni Contati e Barre Valutate con 441 (D30) / 450 (NAS) del passo 0. Se combaciano, la causa e' (a) o (b), e per separarle serve una passata di controllo a Modello 2.")
  }
}
[void]$R.Add("")
[void]$R.Add("--- I NUMERI, GAMBA PER GAMBA ---")
foreach($g in @($GambaIS, $GambaOOS)){
  if($null -eq $g){ continue }
  $e = $g["_etichetta"]
  [void]$R.Add("  [" + $e + "] segnali grezzi L/S " + (FmtN $g["Segnali Grezzi Long"]) + "/" + (FmtN $g["Segnali Grezzi Short"]) + " -> operazioni L/S/tot " + (FmtN $g["Operazioni Long"]) + "/" + (FmtN $g["Operazioni Short"]) + "/" + (FmtN $g["Operazioni Totali"]))
  [void]$R.Add("  [" + $e + "] soppressi: posizione aperta " + (FmtN $g["Segnali Soppressi Posizione Aperta"]) + " | tetto giorno " + (FmtN $g["Segnali Soppressi Tetto Giorno"]) + " | ingresso fuori finestra " + (FmtN $g["Segnali Soppressi Ingresso Fuori Finestra"]) + " | filtro spread " + (FmtN $g["Segnali Soppressi Filtro Spread"]) + " | giorno spaiato " + (FmtN $g["Segnali Soppressi Giorno Spaiato"]))
  [void]$R.Add("  [" + $e + "] USCITE: convergenza " + (FmtN $g["Uscite Convergenza"]) + " | stop " + (FmtN $g["Uscite Stop"]) + " | flat sessione " + (FmtN $g["Uscite Flat Sessione"]) + " | tetto barre " + (FmtN $g["Uscite Tetto Barre"]) + " | fine corsa " + (FmtN $g["Uscite Fine Corsa"]))
  [void]$R.Add("  [" + $e + "]   >>> lo STOP cambia la popolazione misurata dal passo 0: la quota di convergenze QUI non e' confrontabile col C6 del referto della sonda.")
  [void]$R.Add("  [" + $e + "] IL NUMERO DELLA PREVISIONE: guadagno mediano per vincente " + (Fmt3 $g["Guadagno Mediano Vincente Punti Indice"]) + " pti / MFE mediana " + (Fmt3 $g["Mfe Mediana Punti Indice"]) + " pti = " + (Fmt3 $g["Rapporto Realizzato Su Mfe"]))
  [void]$R.Add("  [" + $e + "]   (sotto ~0,70 la geometria non regge il costo, ed e' scritto PRIMA nella proposta) | MAE mediana in-trade " + (Fmt3 $g["Mae Mediana Punti Indice"]) + " pti")
  [void]$R.Add("  [" + $e + "] COSTI MISURATI: spread all'ingresso mediana " + (Fmt4 $g["Spread Ingresso Mediano Punti Indice"]) + " / P95 " + (Fmt4 $g["Spread Ingresso P95 Punti Indice"]) + " punti indice (atteso dal 03/09: " + (Fmt2 $SpreadAtteso) + ")")
  [void]$R.Add("  [" + $e + "] FEDELTA' DELL'INGRESSO: scarto fill vs apertura di barra mediana " + (Fmt4 $g["Scarto Ingresso Vs Apertura Mediano"]) + " / P95 " + (Fmt4 $g["Scarto Ingresso Vs Apertura P95"]) + " punti indice")
  [void]$R.Add("  [" + $e + "]   (la sonda entrava all'apertura ESATTA, l'EA entra al primo tick dopo: sopra ~0,30 il confronto col passo 0 va riletto con questo numero in mano)")
  [void]$R.Add("  [" + $e + "] TENUTA: mediana " + (Fmt2 $g["Tenuta Mediana Barre"]) + " barre = " + (Fmt2 $g["Tenuta Mediana Minuti"]) + " minuti | sotto 60 s " + (Fmt2 $g["Sotto 60 Secondi Pct"]) + "%")
  [void]$R.Add("  [" + $e + "] TAGLIA VERA: operazioni a lotto minimo " + (FmtN $g["Operazioni A Lotto Minimo"]) + " = " + (Fmt2 $g["Operazioni A Lotto Minimo Pct"]) + "% | rischio MEDIO REALIZZATO " + (Fmt2 $g["Rischio Medio Realizzato Pct"]) + "% (dichiarato " + (Fmt2 $g["Risk Percent"]) + "%)")
  [void]$R.Add("  [" + $e + "] CONTENITORE: giorni contati " + (FmtN $g["Giorni Contati"]) + " | col tetto colpito " + (FmtN $g["Giorni Col Tetto Colpito"]) + " = " + (Fmt2 $g["Giorni Col Tetto Colpito Pct"]) + "% (oltre il 20% il round misura IL TETTO)")
  [void]$R.Add("  [" + $e + "] GIORNI SPAIATI (misurati, non filtrati): giorni " + (FmtN $g["Giorni Spaiati"]) + " = " + (Fmt2 $g["Giorni Spaiati Pct"]) + "% | operazioni nate li' " + (FmtN $g["Operazioni In Giorni Spaiati"]) + " | profitto li' " + (Fmt2 $g["Profitto In Giorni Spaiati"]) + " | profitto altrove " + (Fmt2 $g["Profitto Fuori Giorni Spaiati"]))
  [void]$R.Add("  [" + $e + "] CONTO: profitto netto " + (Fmt2 $g["Profitto Netto"]) + " | PF " + (Fmt3 $g["Profit Factor"]) + " | operazioni chiuse (tester) " + (FmtN $g["Operazioni Chiuse Tester"]) + " | vinte " + (Fmt2 $g["Vinte Pct"]) + "% | E " + (Fmt3 $g["Aspettativa In R"]) + " R")
  [void]$R.Add("  [" + $e + "] RISCHIO: drawdown equity " + (Fmt2 $g["Equity Dd Pct"]) + "% | peggior giornata " + (Fmt2 $g["Peggior Giornata Pct"]) + "%")
  [void]$R.Add("")
}
[void]$R.Add("--- I CANCELLI DI MERITO, RICALCOLATI DAI NUMERI GREZZI ---")
if($RuoloTxt -eq "PORTO"){
  [void]$R.Add("  NON SI LEGGONO: questa corsa non apre ordini (ruolo PORTO). Serve a verificare il nucleo, non il conto.")
}
else{
  #--- CLASSE 79: la variabile di ciclo NON puo' chiamarsi $r, perche'
  #    PowerShell e' case-insensitive e $r E' $R, cioe' il referto.
  #    E' il difetto che il verificatore di stringhe ha trovato il 03/09
  #    sulla riga della sonda: qui non si ripete.
  foreach($rc in $RigheCancelli){ [void]$R.Add($rc) }
  [void]$R.Add("")
  [void]$R.Add("  VERDETTO DELLA GAMBA " + $Simbolo + ": " + $VerdettoGamba)
}
[void]$R.Add("")
[void]$R.Add("--- IL GEMELLO DI DETERMINISMO ---")
if($GemelloTxt -eq ""){ [void]$R.Add("  non pertinente per questa corsa (ruolo " + $RuoloTxt + ").") }
else{ [void]$R.Add("  " + $GemelloTxt) }
[void]$R.Add("")
[void]$R.Add("--- COSA QUESTO ROUND NON PUO' DIRE, coi dati che ha ---")
[void]$R.Add("  - UN SOLO REGIME (toro). I tick reali degli indici BCM partono dal 2024.09.26: nessuna finestra orso, laterale o")
[void]$R.Add("    crollo. Emendamento della Finestra: regola A soddisfatta (le operazioni bastano), regola C NON soddisfatta.")
[void]$R.Add("    >>> DA QUESTO ROUND NON ESCE UNA SEDIA. Esce, al massimo, una CANDIDATA, e solo dopo una prova di rischio su un")
[void]$R.Add("    regime ostile e dopo il forward demo.")
[void]$R.Add("  - L'OOS NON E' UN VERO OUT-OF-SAMPLE: la cella e' stata scelta guardando una misura che copre l'INTERA finestra,")
[void]$R.Add("    OOS compreso. Attenuanti reali ma non assolutorie: si e' preso un punto INTERNO e non un picco, e i criteri del")
[void]$R.Add("    passo 0 non contengono NESSUN P/L (non si puo' aver fittato un profitto che nessuno aveva ancora visto).")
[void]$R.Add("    L'unico vero out-of-sample sara' il FORWARD DEMO.")
[void]$R.Add("  - QUESTO ROUND NON VALIDA I NUMERI DEL PASSO 0: lo stop reale tronca i trade che sarebbero convergiuti dopo")
[void]$R.Add("    un'escursione profonda, quindi CAMBIA la popolazione misurata. E' una misura NUOVA.")
[void]$R.Add("  - IL DAX DALLE 17 SERVER IN POI E' FUORI DAL SUO CASH e il suo spread quasi raddoppia dentro la nostra finestra")
[void]$R.Add("    (1,7 -> 2,8 punti indice, MISURATO): su D30EUR lo spread da solo mangia il 79% del cancello H8, su NASUSD il 32%.")
[void]$R.Add("  - D30EUR porta un debito dichiarato: al passo 0 aveva C2 = 12,93% di giorni spaiati (sopra la soglia di casa del")
[void]$R.Add("    10%) e 1.057 buchi del metro contro 1 di NASUSD. Qui NON si filtra: si MISURA, con le tre colonne dedicate.")
[void]$R.Add("  - UN SOLO BROKER. FORMA UNILATERALE: si scambia una gamba sola e il metro si legge. A due gambe si pagherebbero")
[void]$R.Add("    DUE spread per UNA convergenza, e quella forma non e' mai stata misurata.")
[void]$R.Add("  - IL GUARDIAN NON INTERVIENE NEL TESTER: la colonna 'peggior giornata' serve proprio a vedere quante volte sul")
[void]$R.Add("    campo avrebbe messo in pausa la giornata (soglia 4,0%).")
[void]$R.Add("")
if($FrazioneIS -ge 1.0){ [void]$R.Add("AVVISO: FrazioneIS " + $FrazioneIS + " -> non c'e' nessuna gamba OOS, e questo round SENZA OOS non si legge: lo split e' parte dei criteri."); [void]$R.Add("") }
if($Fatale -ne ""){ [void]$R.Add("!!! FERMATO: " + $Fatale); [void]$R.Add("") }
[void]$R.Add("PROBLEMI: " + $Problemi.Count)
foreach($p in $Problemi){ [void]$R.Add("  - " + $p) }
[void]$R.Add("RILIEVI: " + $Rilievi.Count)
foreach($p in $Rilievi){ [void]$R.Add("  - " + $p) }
[void]$R.Add("")
[void]$R.Add('COME SI RIPRENDE: dalla pagina righe/RIGA_RELATIVO_R117_DA_MANDARE.md, NON da questa riga: $Pin nasce dentro il blocco e non sopravvive.')

$refPath = Join-Path $Cart ("REFERTO_RELATIVO_R117_" + $Prova + ".txt")
if($Prova -eq ""){ $refPath = Join-Path $Cart "REFERTO_RELATIVO_R117.txt" }
Set-Content -LiteralPath $refPath -Value ($R -join "`r`n") -Encoding ASCII
Write-Host ($R -join "`r`n")

foreach($f in @("COMPILAZIONE.log")){ $s = Join-Path $Work $f; if(Test-Path -LiteralPath $s){ Copy-Item -LiteralPath $s -Destination $Cart -Force } }
if($Prova -ne ""){
  $sp = Join-Path $Prove $FileProva
  if(Test-Path -LiteralPath $sp){ Copy-Item -LiteralPath $sp -Destination $Cart -Force }
  foreach($leg in @("IS","OOS")){
    $f = Join-Path $Results ($EA + "_" + $Simbolo + "_" + $leg + "_" + $Prova + ".csv")
    if(Test-Path -LiteralPath $f){ Copy-Item -LiteralPath $f -Destination $Cart -Force }
  }
}
$zip = $Cart + ".zip"
Remove-Item -LiteralPath $zip -Force -ErrorAction SilentlyContinue
Compress-Archive -Path (Join-Path $Cart "*") -DestinationPath $zip -Force
Write-Host ""
Write-Host ("CARTELLA: " + $Cart) -ForegroundColor Green
Write-Host ("ZIP DA MANDARE: " + $zip) -ForegroundColor Green
if($Prova -ne ""){ Write-Host ("FILE ATTESI NELLO ZIP: REFERTO_RELATIVO_R117_" + $Prova + ".txt + COMPILAZIONE.log + il prova + DUE CSV OPTFRAME (" + $EA + "_" + $Simbolo + "_IS_" + $Prova + ".csv e _OOS_, " + $RigheAttese + " riga ciascuno, " + ($NSTATS_ATTESI + 3) + " colonne + gli input accodati dal tester). In CONTROLLO: solo referto + COMPILAZIONE.log + prova.") -ForegroundColor Gray }
else{ Write-Host "FILE ATTESI NELLO ZIP: il solo REFERTO_RELATIVO_R117.txt (fermato prima di scegliere il prova)" -ForegroundColor Gray }
Write-Host ("CSV *_OOS trovati: " + $nOos + " (atteso 1: e' la gamba su cui si leggono i cancelli di merito).") -ForegroundColor Gray

if($PortoFuoriTolleranza){ Write-Host ""; Write-Host "ATTENZIONE: COLLAUDO DEL PORTO FUORI TOLLERANZA (rilievo, NON bocciatura): non lanciare le corse 4-7 prima di aver mandato questo zip." -ForegroundColor Yellow }

if($Fatale -ne ""){ Write-Host "ESITO: FERMATO" -ForegroundColor Red; exit 1 }
if($Problemi.Count -gt 0){ Write-Host "ESITO: COMPLETATO CON PROBLEMI" -ForegroundColor Yellow; exit 1 }
Write-Host ("ESITO: " + $Modo + " COMPLETATO") -ForegroundColor Green
exit 0
