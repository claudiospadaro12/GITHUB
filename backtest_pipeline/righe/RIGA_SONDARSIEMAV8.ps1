# =====================================================================
#  MARCATORE_RIGA_SONDARSIEMAV8_v2
#  RIGA_SONDARSIEMAV8.ps1 -- SONDA DI CONTEGGIO RSI+EMA V8 (PASSO 0
#  del candidato V8, porta di rientro della scheda 31/08 ESERCITATA su
#  richiesta esplicita di Claudio, 01-02/09).
#  ABTG_SondaRsiEmaV8 e' un CONTATORE: NESSUN ordine, nessun lotto,
#  nessun magic, nessuna sedia. SETTE CORSE in sequenza:
#    U30_M5   U30USD M5     prove\RSIEMAV8_FREQUENZA_M5.txt
#    U30_M15  U30USD M15    prove\RSIEMAV8_FREQUENZA_M15.txt
#    NAS_M5   NASUSD M5     (stesso prova M5,  -Simbolo override)
#    NAS_M15  NASUSD M15    (stesso prova M15, -Simbolo override)
#    DAX_M5   D30EUR M5     (stesso prova M5,  -Simbolo override)
#    DAX_M15  D30EUR M15    (stesso prova M15, -Simbolo override)
#    ORO_M15  XAUUSD M15    (stesso prova M15, -Simbolo override,
#                            CORSA AGGIUNTA su richiesta ESPLICITA di
#                            Claudio del 02/09: e' il simbolo dove
#                            opera a mano. E' FUORI DALLO STAMPO M0PB
#                            e si legge DA SOLA -- vedi il blocco ORO
#                            qui sotto.)
#  finestra 2024.09.26 -> 2026.06.30, MODELLO 2 ("Solo prezzi di
#  apertura": il segnale nasce su barra chiusa e non si apre niente --
#  il tick non aggiunge informazione e costa ore). E' IL BANCO
#  IDENTICO alla corsa M0PB del 31/08 (piu' l'oro, dichiarato): il
#  confronto col morto 12/12 di quel giorno dev'essere diretto.
# ---------------------------------------------------------------------
#  LE SCELTE, DICHIARATE (sono nel prova, qui il riassunto):
#  - DUE file prova (M5/M15) gemelli: il generico legge @PERIODO dal
#    prova e un override da fuori sarebbe stato nascosto. Le righe
#    vive differiscono per ESATTAMENTE DUE nomi, tutti e due dichiarati
#    nel prova e gattati qui sotto MECCANICAMENTE:
#      @PERIODO               M5  contro M15
#      InpBarreOrizzonteLungo 96  contro 32   (e' definito in ORE, 8:
#                             96 barre M5 = 32 barre M15 = 8 ore.
#                             Il SIGNIFICATO e' costante, il numero no.)
#    Qualunque TERZA differenza, o una delle due mancante, FERMA tutto.
#  - QUATTRO simboli con UN solo @SIMBOLO (il lead U30USD) + override
#    -Simbolo del generico per NASUSD, D30EUR e XAUUSD: supportato (il
#    parametro vince sulla direttiva) e DICHIARATO qui e nel referto.
#  - UNICO asse Y = InpModoPrezzoIngresso 1||0||1||1||Y -> 2 passate
#    INFORMATIVE (1 = apertura barra dopo, RIGA DEL VERDETTO; 0 =
#    chiusura barra segnale, sensibilita' GRATIS). Il generico rifiuta
#    zero assi e la sonda non ha magic da usare come gemelli. I numeri
#    del MOTORE (RSI 14 / SMA 14 / EMA 5 / EMA 20) sono #define nel
#    sorgente, NON sweepabili: in un PASSO 0 sweepare le lunghezze
#    sarebbe pescare la cella che fa passare il pavimento (V14).
#  - CELLE CONTATE COME LE CONTA IL GENERICO (Floor(|stop-start|/step)
#    +1): 1 asse x 2 valori = 2 passate a corsa, 7 corse = 14 passate
#    open-prices in tutto. Il conteggio viene RIFATTO sui pin ||Y
#    scaricati al pin: se un prova cambia, il gate lo dice.
#  - NESSUNA CELLA VIENE PROMOSSA: il criterio di ottimizzazione della
#    sonda e' il conteggio dei segnali e NON dipende dall'asse (le due
#    passate devono restituirlo IDENTICO: e' il gate di determinismo
#    V13). Si LEGGONO le colonne, riga per riga.
#
#  I CANCELLI (congelati nei prova PRIMA dei numeri; le DISUGUAGLIANZE
#  sono ricopiate da VerdettoF1/F2/H8_Calc del sorgente, che
#  l'autotest della sonda esegue su una cella di OGNI fascia e sui
#  bordi esatti -- blocco 16):
#    F1  DUE condizioni in AND:
#          totale (L+S) < 2,00 segnali/giorno -> MORTO (pavimento
#                                                firmato 01/09)
#          un lato      < 1,00 segnali/giorno -> MORTO (scheda 31/08)
#    F2  MFE mediana a 12 barre, in PUNTI INDICE:
#          <  5,00           -> MORTO
#          >= 5,00 e <= 7,00 -> SOSPESO [SPREAD NON MISURATO, Code
#                               Base 74148 mai usato]
#          >  7,00           -> VIVO
#        (fascia sciolta verso la clausola PIU' SEVERA, classe 31/08)
#    H8  RR da mediane < 0,70 -> MORTO PER ARITMETICA (FIRMA 2 del
#        31/08, E >= 0,075R), niente corsa a tick.
#  Il verdetto esce AUTOMATICO nel referto, PER CORSA E PER LATO,
#  sulla passata con Modo Prezzo Ingresso = 1.
#
#  >>> L'INVARIANTE NUOVA DI QUESTA SONDA, E SI GATTA: le colonne
#      "Stato Ambiguo Long/Short" DEVONO essere ZERO. Il pending del
#      V8 e' un LATCH e non dimentica per decadimento come una media
#      (V5): la sonda ricostruisce lo stato facendo girare la macchina
#      DUE volte con semi opposti, e una barra su cui i due esiti
#      divergono e' AMBIGUA (il segnale NON viene contato: si sbaglia
#      CONTRO il candidato). Se le colonne non sono zero,
#      InpWarmupBarre (400) e' troppo corto e i numeri di quella corsa
#      NON VALGONO: qui e' un PROBLEMA, non un rilievo.
#
#  >>> ORO (ORO_M15), FUORI DALLO STAMPO -- il punto va letto:
#      XAUUSD NON e' un indice. La sonda NON rifiuta un simbolo
#      non-indice (verificato nel sorgente: OnInit fa solo un
#      ATTENZIONE nel log se il punto indice non vale 1,00, righe
#      1190-1192) e la conversione esce in colonna ("Punto Indice
#      Prezzo" = InpPuntiPerIndice * _Point, eco V9).
#      SUL FEED BCM l'oro quota a 2 DECIMALI (Point 0,01: misurato
#      dagli statements del conto demo 50503392 -- prezzi tipo 4700,73
#      -- e coerente con la ricognizione InfoBroker), quindi
#      100 x 0,01 = 1,00: l'eco atteso e' 1,00 ANCHE su XAUUSD, e il
#      gate qui sotto lo pretende PER CORSA, col SUO messaggio.
#      MA L'UNITA' CAMBIA SIGNIFICATO, e va dichiarato: sugli indici
#      "1 punto indice" e' 1 punto di indice; su XAUUSD e' 1,00 USD
#      di prezzo dell'oro. Le soglie F2 (5,0 / 7,0) sono state
#      congelate per gli INDICI: sull'oro si leggono come 5-7 USD e il
#      verdetto ORO_M15 esce marcato [ORO] -- e' una LETTURA A PARTE,
#      NON entra nel confronto diretto col banco M0PB (che resta sui
#      tre indici). L'ATR mediano in colonna e' il metro per capire se
#      quei 5-7 USD sono tanti o pochi sul rumore dell'oro.
#      Se l'eco NON viene 1,00 la scala dei decimali del feed e'
#      un'altra: la corsa oro NON si legge finche' l'unita' non e'
#      rideclarata (PROBLEMA, messaggio dedicato).
#
#  >>> EA MAI COMPILATO: si compila QUI con l'.ex5 cancellato prima.
#      Se la compilazione FALLISCE, QUELLO e' il risultato del passo.
#      (Nessun include da installare: la sonda non ne ha.)
#  >>> CONTATORE PURO, PROVATO A MACCHINA: il gate qui sotto conta le
#      chiamate di trading nel sorgente FUORI dai commenti. Attese ZERO
#      (la riga di grep sta QUI e non nel .mq5, apposta: dentro il file
#      combacerebbe con se' stessa).
#  >>> IL CSV SI DATA PRIMA DI LEGGERLO (classe CSV STANTIO del 31/08,
#      pagata di nuovo l'01/09 su LondonFx): la workdir e' RIUSABILE e
#      non si svuota. "-Rifai" (che c'e', ed e' obbligatorio) copre il
#      generico che SALTA la corsa, NON il generico che MUORE prima di
#      rifarla -- e se muore, il CSV della corsa PRECEDENTE resta
#      dov'era. Ogni CSV viene confrontato con l'ORA DI AVVIO DELLA
#      SUA CORSA: piu' vecchio = 'CSV STANTIO, NON LETTO', e le due
#      date finiscono nel referto.
#  >>> L'EXIT CODE DEL FIGLIO SI LEGGE A TRE STATI (classe 108 del
#      02/09, pagata sul giro a vuoto di RIGA_DIAG_GBPUSD): su
#      Windows PowerShell 5.1 il codice di uscita puo' essere VUOTO, e
#      '$null -ne 0' e' VERO. Qui MAI '$rc -ne 0' secco: si usa
#      $rcLetto a tre stati (letto-e-zero / letto-e-non-zero / NON
#      LETTO), un codice non letto NON e' un fallimento, e il verdetto
#      di ogni corsa sta sugli ARTEFATTI DATATI (CSV fresco e CONTATO),
#      non sul numero.
#  >>> UNA SOLA TRANCHE (FrazioneIS 1.0): la gamba "OOS" del generico
#      e' DEGENERE (0 giorni) e si IGNORA. Il rosso del generico sui
#      CSV *_OOS e' ATTESO: NON rilanciare. Il conteggio dei *_OOS
#      trovati (attesi 0) sta NEL REFERTO, non solo a schermo (debito
#      M0PB, pagato gia' su LondonFx: qui si eredita pagato).
#  >>> SUFFISSO "_ohlc" NEI NOMI CSV: il generico marca cosi' OGNI
#      modello diverso da 4. Qui si legge "non-tick" (Modello 2, open
#      prices), non "OHLC M1". Dichiarato, non un errore.
#  >>> TETTO ~100k BARRE DEL TESTER (regola 25/08): 21 mesi di M5
#      possono eccedere il tetto (~1,3 anni a M5). NON si spezza: la
#      sonda dichiara da sola la finestra effettiva (Giorni Contati,
#      Barre Valutate), la firma del tetto (checklist punto 36) e'
#      Barre Valutate IDENTICHE su simboli diversi e il referto la
#      cerca a macchina, per TF.
#  >>> NESSUN per-trade CSV e NESSUN CSV riga-per-segnale in questo
#      giro: non ci sono ordini, e in ottimizzazione la sonda spegne
#      il CSV dei segnali (si sovrascriverebbero). I numeri stanno
#      nelle 59 colonne OPTFRAME.
#
#  QUANTO CI METTE [STIMA, non una previsione]: 14 passate open-prices
#  su ~21 mesi (M5/M15) + 7 avvii del terminale + 1 compilazione.
#  Una passata open-prices e' questione di secondi-minuti: stima
#  onesta 15-35 minuti per tutto il giro.
#
#  LA RIGA CHE SI INCOLLA sta in righe\RIGA_SONDARSIEMAV8_DA_MANDARE.md
# =====================================================================
[CmdletBinding()]
param(
  # -Pin NON ha default: un default silenzioso ("lavoro") farebbe girare
  #  la punta del branch spacciandola per un commit congelato.
  [string]$Pin          = "",
  [switch]$SoloControllo,
  [string]$SoloCorsa    = "",            # etichetta singola (es. "U30_M5"); default: tutte e sette
  [string]$DaQuando     = "2024.09.26",  # pavimento MISURATO dei dati BCM sugli indici; stessa finestra per l'oro (comparabilita')
  [string]$Fino         = "2026.06.30",  # dichiarata nei prova (@FINOA) e gattata
  [double]$FrazioneIS   = 1.0,           # finestra intera; la gamba OOS del generico e' degenere e si ignora
  [int]$Deposito        = 100000         # INERTE: la sonda non apre ordini. Sta qui perche' il generico lo vuole
)
$ErrorActionPreference = "Stop"
[Threading.Thread]::CurrentThread.CurrentCulture   = [Globalization.CultureInfo]::InvariantCulture
[Threading.Thread]::CurrentThread.CurrentUICulture = [Globalization.CultureInfo]::InvariantCulture
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$INV = [Globalization.CultureInfo]::InvariantCulture

$EA          = "ABTG_SondaRsiEmaV8"
$SimboloLead = "U30USD"
$Avvio   = Get-Date
$Stamp   = $Avvio.ToString("yyyyMMdd_HHmm", $INV)
$Dsk     = Join-Path $env:USERPROFILE "Desktop"
$Work    = Join-Path $env:USERPROFILE "abtg_sondarsiemav8"
$Prove   = Join-Path $Work "prove"
$RawPin  = "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$Pin"

# --- I CANCELLI, ricopiati dai #define della sonda (congelati la',
#     V8_SOGLIA_*). Se lassu' cambiano e qui no, il referto direbbe
#     un'altra cosa dal log della sonda: per questo il referto stampa
#     ANCHE le soglie. Le DISUGUAGLIANZE sono quelle di
#     VerdettoF1/F2/H8_Calc, ricopiate segno per segno (un gate che
#     ricopia le soglie senza le disuguaglianze non si accorge di
#     niente: e' in checklist, ed e' successo).
$SOGLIA_F1_TOT  = 2.00   # F1(a): MORTO se totale (L+S) al giorno < 2,00 (pavimento 01/09)
$SOGLIA_F1_LATO = 1.00   # F1(b): MORTO se un lato al giorno < 1,00 (scheda 31/08)
$F2_SCARTO      = 5.00   # F2: MORTO se MFE mediana < 5,00 punti indice
$F2_VIVO        = 7.00   # F2: SOSPESO se 5,00 <= mfe <= 7,00; VIVO solo SOPRA 7,00
$SOGLIA_H8      = 0.70   # H8: MORTO PER ARITMETICA se rr < 0,70
$AUTOTEST_BLOCCHI_ATTESI = 16
$NCelleAttese   = 2      # 1 asse (InpModoPrezzoIngresso) x 2 valori. RICONTATE dai pin ||Y scaricati, piu' sotto.

# --- tutto cio' che la raccolta usa nasce QUI, prima del try: la
#     raccolta gira SEMPRE, anche nella corsa fermata da un gate.
$Problemi  = New-Object System.Collections.ArrayList
$Rilievi   = New-Object System.Collections.ArrayList
$Fatale    = ""
$Terminale = "n/d"
$Compilato = "NON TENTATA"
$CacheTxt  = "NON SVUOTATA"
$Gemelle   = "NON VERIFICATA"
$GrepTxt   = "NON ESEGUITO"
$CelleTxt  = "NON CONTATE"
$Modo      = "CORSA"
if($SoloControllo){ $Modo = "CONTROLLO" }

# =====================================================================
#  LE SETTE CORSE. Il prova e' per-TF; il simbolo va in -Simbolo (il
#  lead U30USD e' anche l'@SIMBOLO dei prova, gli altri tre sono
#  override dichiarati). ORO_M15 e' FUORI STAMPO e porta il flag.
# =====================================================================
function C([string]$et,[string]$sym,[string]$tf,[string]$prova,[int]$lungo,[bool]$oro){
  return [pscustomobject]@{ Etichetta=$et; Simbolo=$sym; Periodo=$tf; Prova=$prova
    LungoAtteso=$lungo; FuoriStampo=$oro
    Righe=$null; RigaV=$null; RigaS=$null; CsvOra="n/d"
    Giorni=$null; BarreVal=$null
    AutoKo=-2; AutoBlocchi=$null; RsiDivMax=$null; EmaDivMax=$null
    AmbL=$null; AmbS=$null; PuntoIdx=$null
    Determinismo="NON VERIFICATO"; Sottoinsieme="NON VERIFICATO"; Sens="n/d"
    VerdettoL="n/d"; VerdettoS="n/d" }
}
$PROVA_M5  = "RSIEMAV8_FREQUENZA_M5.txt"
$PROVA_M15 = "RSIEMAV8_FREQUENZA_M15.txt"
$CORSE = @()
$CORSE += (C "U30_M5"  "U30USD" "M5"  $PROVA_M5  96 $false)
$CORSE += (C "U30_M15" "U30USD" "M15" $PROVA_M15 32 $false)
$CORSE += (C "NAS_M5"  "NASUSD" "M5"  $PROVA_M5  96 $false)
$CORSE += (C "NAS_M15" "NASUSD" "M15" $PROVA_M15 32 $false)
$CORSE += (C "DAX_M5"  "D30EUR" "M5"  $PROVA_M5  96 $false)
$CORSE += (C "DAX_M15" "D30EUR" "M15" $PROVA_M15 32 $false)
$CORSE += (C "ORO_M15" "XAUUSD" "M15" $PROVA_M15 32 $true)

# I FISSI attesi nei prova (primo campo prima di ||): TUTTI gli input
# della sonda, nome per nome, tranne l'asse Y e il fisso PER-TF
# InpBarreOrizzonteLungo (gattato a parte: 96 su M5, 32 su M15).
# Un nome sbagliato qui sarebbe l'errore n.3 della checklist (MT5
# ignora in silenzio). NOTA: i numeri del MOTORE non sono qui perche'
# non sono input: sono #define nel sorgente (V14).
$FissiAttesi = [ordered]@{ "InpBarreOrizzonte"="12"; "InpPuntiPerIndice"="100.0";
                  "InpUsaFinestraOraria"="false"; "InpOraInizioServer"="14";
                  "InpOraFineServer"="21"; "InpWarmupBarre"="400";
                  "InpConfrontaMT5"="true"; "InpScriviCsv"="true";
                  "InpVerbose"="true"; "InpAutoTest"="true"; "InpTag"="RSIEMAV8_SONDA" }
$AsseAtteso  = "InpModoPrezzoIngresso"
$AsseValore  = "1||0||1||1||Y"

function Ora(){ return (Get-Date).ToString("HH:mm:ss", $INV) }
function Dico([string]$t,[string]$c="Gray"){ Write-Host ("[" + (Ora) + "] " + $t) -ForegroundColor $c }
function Titolo([string]$t){ Write-Host ""; Write-Host ("=== " + $t + " ===") -ForegroundColor Cyan }

function Scarica([string]$url,[string]$dest){
  Remove-Item -LiteralPath $dest -Force -ErrorAction SilentlyContinue
  Invoke-WebRequest -Uri $url -OutFile $dest -UseBasicParsing -ErrorAction Stop
  if(-not (Test-Path -LiteralPath $dest)){ throw ("scarico fallito: " + $url) }
}

function RigheVive([string]$p){
  return @(Get-Content -LiteralPath $p | Where-Object { $_ -notmatch '^\s*#' -and $_ -notmatch '^\s*$' })
}

function Num([string]$s){ return [double]::Parse($s.Trim(), $INV) }
function FmtN($v){ if($null -eq $v){ return "n/d" }; return ([long]$v).ToString($INV) }
function Fmt2($v){ if($null -eq $v){ return "n/d" }; return ([double]$v).ToString("0.00",$INV) }
function Fmt3($v){ if($null -eq $v){ return "n/d" }; return ([double]$v).ToString("0.000",$INV) }

# legge un file prova in una mappa @{nome=valore} + lista assi Y.
# Una riga DOPPIA per lo stesso nome e' FATALE: in [TesterInputs] un
# parametro doppio fa fare a MT5 ZERO passate.
function LeggiProva([string]$percorso,[string]$nome){
  $mappa = @{}
  $assi  = New-Object System.Collections.ArrayList
  foreach($r in (RigheVive $percorso)){
    if($r -match '^@'){
      $parti = ($r -split '\s+',2)
      if($parti.Count -lt 2){ throw ($nome + ": la direttiva '" + $r + "' non ha un valore.") }
      if($mappa.ContainsKey($parti[0])){ throw ($nome + ": direttiva doppia '" + $parti[0] + "'.") }
      $mappa[$parti[0]] = $parti[1].Trim()
      continue
    }
    $i = $r.IndexOf("=")
    if($i -lt 0){ continue }
    $n = $r.Substring(0,$i).Trim()
    $v = $r.Substring($i+1).Trim()
    if($mappa.ContainsKey($n)){ throw ($nome + ": DUE righe per '" + $n + "'. In [TesterInputs] un parametro doppio fa fare a MT5 ZERO passate.") }
    $mappa[$n] = $v
    if($v -match '\|\|Y\s*$'){ [void]$assi.Add($n) }
  }
  return @{ Mappa=$mappa; Assi=$assi }
}

# conta le celle di UN asse ESATTAMENTE come le conta il generico
# (walkforward_generico.ps1: Floor(|stop-start|/|step| + 1e-9) + 1,
# con true->1 e false->0 come fa la sua Risolvi). Niente enum qui: la
# sonda non ha input enum sweepati.
function CelleAsse([string]$valore,[string]$nome){
  $campi = $valore -split '\|\|'
  if($campi.Count -lt 5){ throw ($nome + ": pin '" + $valore + "' non ha 5 campi: non e' un asse.") }
  $conv = New-Object System.Collections.ArrayList
  foreach($ix in @(1,2,3)){
    $t = $campi[$ix].Trim()
    if($t -ieq "true"){ $t = "1" }
    if($t -ieq "false"){ $t = "0" }
    if($t -notmatch '^-?\d+(\.\d+)?$'){ throw ($nome + ": campo '" + $campi[$ix] + "' non numerico nell'asse.") }
    [void]$conv.Add([double]::Parse($t,$INV))
  }
  $start = $conv[0]; $step = $conv[1]; $stop = $conv[2]
  if($step -eq 0 -or $start -eq $stop){ throw ($nome + ": asse DEGENERE (start==stop o step==0): il generico lo boccerebbe dopo, questo gate lo boccia prima.") }
  return ([int]([math]::Floor([math]::Abs($stop-$start)/[math]::Abs($step) + 1e-9)) + 1)
}

# il verdetto di un lato, coi tre cancelli congelati -- disuguaglianze
# ricopiate segno per segno da VerdettoF1_Calc (due condizioni in AND,
# bordi 1,00 e 2,00 INCLUSI = passano), VerdettoF2_Calc (tre fasce
# senza sovrapposizioni, bordi 5,00 e 7,00 nella fascia SOSPESA) e
# VerdettoH8_Calc (bordo 0,70 INCLUSO = passa).
function Verdetto([double]$sigGgLato,[double]$sigGgTot,[double]$mfe,[double]$rr){
  $morto = $false
  $sospeso = $false
  if($sigGgTot  -lt $SOGLIA_F1_TOT){  $morto = $true }
  if($sigGgLato -lt $SOGLIA_F1_LATO){ $morto = $true }
  if($mfe -lt $F2_SCARTO){ $morto = $true }
  elseif($mfe -le $F2_VIVO){ $sospeso = $true }
  if($rr -lt $SOGLIA_H8){ $morto = $true }
  if($morto){ return "MORTO" }
  if($sospeso){ return "SOSPESO (F2 in fascia 5,0-7,0: SPREAD NON MISURATO, Code Base 74148)" }
  return "VIVO"
}

# IL GATE DI UN PROVA, in una funzione: direttive nude, 1 asse esatto,
# celle ricontate dai pin ||Y, fissi nome per nome, fisso per-TF,
# nessuna riga estranea. E' una funzione (e non codice inline) APPOSTA:
# cosi' l'autotest della riga la esercita su file finti (mutation test)
# PRIMA che tocchi un prova vero. Torna @{ Lettura; Celle }.
function GateProva([string]$percorso,[string]$pf,[string]$tfAtteso,[string]$lungoAtteso){
  $lettura = LeggiProva $percorso $pf
  $h    = $lettura.Mappa
  $assi = $lettura.Assi

  # LE QUATTRO DIRETTIVE, NUDE E GATTATE (commentate = gate vuoto = ci si ferma).
  if($h["@SIMBOLO"]  -ne $SimboloLead){ throw ($pf + ": @SIMBOLO e' '" + $h["@SIMBOLO"] + "', atteso il lead " + $SimboloLead + " (NASUSD, D30EUR e XAUUSD girano con -Simbolo, override dichiarato)") }
  if($h["@PERIODO"]  -ne $tfAtteso){    throw ($pf + ": @PERIODO e' '" + $h["@PERIODO"] + "', atteso " + $tfAtteso) }
  if($h["@DAQUANDO"] -ne $DaQuando){    throw ($pf + ": @DAQUANDO e' '" + $h["@DAQUANDO"] + "', atteso " + $DaQuando + " (pavimento MISURATO dei dati BCM sugli indici, stessa finestra del banco M0PB)") }
  if($h["@FINOA"]    -ne $Fino){        throw ($pf + ": @FINOA e' '" + $h["@FINOA"] + "', atteso " + $Fino + " (la finestra si dichiara nel prova, non si eredita dal default del generico)") }

  # UNICO ASSE Y = InpModoPrezzoIngresso, coi valori esatti 1||0||1||1||Y.
  if(@($assi).Count -ne 1){ throw ($pf + ": deve avere ESATTAMENTE un asse Y (" + $AsseAtteso + "). Trovati: " + @($assi).Count + " {" + (@($assi) -join ", ") + "}.") }
  if($assi[0] -ne $AsseAtteso){ throw ($pf + ": l'unico asse Y deve essere " + $AsseAtteso + ", invece e' " + $assi[0] + ".") }
  if($h[$AsseAtteso] -ne $AsseValore){ throw ($pf + ": " + $AsseAtteso + " e' '" + $h[$AsseAtteso] + "', atteso '" + $AsseValore + "' (2 passate: 1 = fedele al Pine / verdetto, 0 = sensibilita').") }

  # LE CELLE, CONTATE DAI PIN ||Y APPENA SCARICATI, come le conta il
  # generico. Il numero atteso di righe CSV e' GATTATO qui.
  $nc = CelleAsse $h[$AsseAtteso] $AsseAtteso
  if($nc -ne $NCelleAttese){ throw ($pf + ": il pin ||Y da' " + $nc + " celle, attese " + $NCelleAttese + " (asse 0->1 passo 1). L'asse e' cambiato.") }

  # I FISSI, nome per nome (l'errore n.3 della checklist: MT5 ignora
  # in silenzio un pin che non trova).
  foreach($k in @($FissiAttesi.Keys)){
    if(-not $h.ContainsKey($k)){ throw ($pf + ": manca la riga '" + $k + "' (fisso dichiarato: va verificabile nell'.ini).") }
    $v = ($h[$k] -split '\|\|')[0]
    if($v -ne $FissiAttesi[$k]){ throw ($pf + ": " + $k + " e' '" + $v + "', atteso '" + $FissiAttesi[$k] + "'.") }
  }
  # il fisso PER-TF, gattato col SUO valore: 96 barre M5 = 32 barre
  # M15 = 8 ore (l'orizzonte lungo e' definito in ORE, non in barre).
  if(-not $h.ContainsKey("InpBarreOrizzonteLungo")){ throw ($pf + ": manca la riga 'InpBarreOrizzonteLungo'.") }
  $vLungo = ($h["InpBarreOrizzonteLungo"] -split '\|\|')[0]
  if($vLungo -ne $lungoAtteso){ throw ($pf + ": InpBarreOrizzonteLungo e' '" + $vLungo + "', atteso '" + $lungoAtteso + "' su " + $tfAtteso + " (8 ore).") }
  if($h["InpBarreOrizzonteLungo"] -match '\|\|Y\s*$'){ throw ($pf + ": InpBarreOrizzonteLungo NON va sweepato: e' un orizzonte informativo, non una manopola.") }
  # niente righe estranee: 4 direttive + 11 fissi + 1 per-TF + 1 asse = 17.
  $attese = 4 + @($FissiAttesi.Keys).Count + 1 + 1
  if(@($h.Keys).Count -ne $attese){
    throw ($pf + ": " + @($h.Keys).Count + " righe vive invece di " + $attese + ": c'e' una riga estranea o ne manca una.")
  }
  return @{ Lettura=$lettura; Celle=$nc }
}

# IL GEMELLAGGIO M5/M15, in una funzione (stessa ragione: si esercita
# su file finti). Le righe vive dei due prova devono differire per
# ESATTAMENTE DUE nomi, tutti e due dichiarati nel prova e gattati coi
# VALORI attesi: @PERIODO (M5/M15) e InpBarreOrizzonteLungo (96/32,
# perche' e' definito in ORE). Una TERZA differenza, o una delle due
# mancante, ferma tutto. Torna la stringa per il referto.
function GateGemellaggio($hA,$hB,[string]$pfA,[string]$pfB){
  foreach($k in @($hA.Keys)){
    if(-not $hB.ContainsKey($k)){ throw ("GEMELLAGGIO NON VALIDO: " + $pfA + " ha la riga '" + $k + "' che la gemella non ha.") }
  }
  foreach($k in @($hB.Keys)){
    if(-not $hA.ContainsKey($k)){ throw ("GEMELLAGGIO NON VALIDO: " + $pfB + " ha la riga '" + $k + "' che la gemella non ha.") }
  }
  $DiffAttese = @{ "@PERIODO" = @("M5","M15"); "InpBarreOrizzonteLungo" = @("96","32") }
  foreach($k in @($hA.Keys)){
    if($DiffAttese.ContainsKey($k)){ continue }
    if($hA[$k] -ne $hB[$k]){ throw ("GEMELLAGGIO NON VALIDO: '" + $k + "' differisce fra i due prova ('" + $hA[$k] + "' contro '" + $hB[$k] + "') e NON e' una delle 2 differenze dichiarate (@PERIODO, InpBarreOrizzonteLungo). Cosi' M5 e M15 misurerebbero due cose diverse.") }
  }
  foreach($k in @($DiffAttese.Keys)){
    $attesoA = $DiffAttese[$k][0]; $attesoB = $DiffAttese[$k][1]
    if($hA[$k] -eq $hB[$k]){ throw ("GEMELLAGGIO NON VALIDO: '" + $k + "' DOVEVA differire fra i due prova (" + $attesoA + " contro " + $attesoB + ") e invece e' identico ('" + $hA[$k] + "').") }
    if($hA[$k] -ne $attesoA){ throw ("GEMELLAGGIO NON VALIDO: '" + $k + "' nel prova M5 e' '" + $hA[$k] + "', atteso '" + $attesoA + "'.") }
    if($hB[$k] -ne $attesoB){ throw ("GEMELLAGGIO NON VALIDO: '" + $k + "' nel prova M15 e' '" + $hB[$k] + "', atteso '" + $attesoB + "'.") }
  }
  return "VALIDO: le righe vive differiscono SOLO per le 2 differenze dichiarate -- @PERIODO (M5/M15) e InpBarreOrizzonteLungo (96/32, orizzonte in ORE)"
}

# =====================================================================
#  L'ANALISI DEL CSV DI UNA CORSA, in una funzione: datazione (classe
#  CSV STANTIO), righe CONTATE, colonne per NOME, collaudi PRIMA dei
#  numeri, gate di determinismo fra le 2 passate, verdetti per lato.
#  E' una funzione APPOSTA: l'autotest della riga la esercita su CSV
#  SINTETICI costruiti dall'header vero, prima di ogni corsa vera.
#  Muta $Problemi/$Rilievi (ArrayList di script) e i campi di $c.
# =====================================================================
function AnalizzaCsvCorsa($c,[string]$csvIS,[datetime]$tCorsa){
  if(-not (Test-Path -LiteralPath $csvIS)){
    [void]$Problemi.Add("corsa " + $c.Etichetta + ": CSV OPTFRAME NON prodotto: " + $csvIS)
    return
  }
  # IL CSV SI DATA PRIMA DI LEGGERLO. Un CSV scritto PRIMA dell'avvio
  # di questa corsa e' il reperto di una corsa PRECEDENTE rimasto nella
  # workdir riusabile: leggerlo vorrebbe dire stampare una tabella
  # completa, verde e PLAUSIBILE di numeri mai misurati oggi. Qui NON
  # si legge, e il perche' finisce nel referto con le due date.
  $csvItem  = Get-Item -LiteralPath $csvIS
  $c.CsvOra = $csvItem.LastWriteTime.ToString("yyyy-MM-dd HH:mm:ss",$INV)
  if($csvItem.LastWriteTime -lt $tCorsa){
    [void]$Problemi.Add("corsa " + $c.Etichetta + ": CSV STANTIO, NON LETTO. E' scritto alle " + $c.CsvOra +
      ", cioe' PRIMA dell'avvio di questa corsa (" + $tCorsa.ToString("yyyy-MM-dd HH:mm:ss",$INV) +
      "): e' il CSV di una corsa PRECEDENTE rimasto nella workdir. Il generico e' MORTO prima di rifarlo (-Rifai copre il generico che SALTA, non quello che MUORE). Questa corsa NON ha numeri.")
    return
  }
  $lin = @(Get-Content -LiteralPath $csvIS | Where-Object { $_.Trim() -ne "" })
  $nRighe = $lin.Count - 1
  if($nRighe -lt 0){ $nRighe = 0 }
  $c.Righe = $nRighe
  if($nRighe -ne $NCelleAttese){
    [void]$Problemi.Add("corsa " + $c.Etichetta + ": " + $nRighe + " righe nel CSV, " + $NCelleAttese + " passate chieste (cache? storico?).")
  }
  if($nRighe -le 0){ return }

  $head = $lin[0] -split ','
  $ix = @{}
  for($i2=0;$i2 -lt $head.Count;$i2++){ $ix[$head[$i2].Trim()] = $i2 }
  # le colonne che questa lettura usa, per NOME (l'header OPTFRAME
  # della sonda ha 59 colonne + gli input accodati dal tester: gli
  # indici non si assumono mai).
  $servono = @("Segnali Long","Segnali Short",
               "Segnali Nudo Long","Segnali Nudo Short",
               "Pending Attivo Long","Pending Attivo Short",
               "Armamenti Rsi Long","Armamenti Rsi Short",
               "Giorni Contati","Segnali Long Al Giorno","Segnali Short Al Giorno",
               "Segnali Totali Al Giorno",
               "Mfe Mediano Long Punti Indice","Mfe Mediano Short Punti Indice",
               "Mae Mediano Long Punti Indice","Mae Mediano Short Punti Indice",
               "RR Da Mediane Long","RR Da Mediane Short",
               "Win Rate Necessario Long Pct","Win Rate Necessario Short Pct",
               "Max Segnali Giorno Long","Max Segnali Giorno Short","Max Segnali Giorno Totale",
               "Giorni Almeno 1 Long","Giorni Almeno 1 Short",
               "Giorni Almeno 1 Totale","Giorni Zero Segnali",
               "Mfe Lungo Mediano Long Punti Indice","Mfe Lungo Mediano Short Punti Indice",
               "Mae Lungo Mediano Long Punti Indice","Mae Lungo Mediano Short Punti Indice",
               "Mfe Non Positive Long","Mfe Non Positive Short",
               "Mae Non Positive Long","Mae Non Positive Short",
               "Atr Mediano Punti Indice","Barre Valutate","Barre Saltate Dati",
               "Segnali Scartati Orario","Rsi Divergenza Max","Ema Divergenza Max",
               "Stato Ambiguo Long","Stato Ambiguo Short",
               "Punto Indice Prezzo","Modo Prezzo Ingresso",
               "Barre Orizzonte","Barre Orizzonte Lungo",
               "Autotest Falliti","Autotest Blocchi")
  $manca = New-Object System.Collections.ArrayList
  foreach($cName in $servono){ if(-not $ix.ContainsKey($cName)){ [void]$manca.Add($cName) } }
  if($manca.Count -gt 0){
    [void]$Problemi.Add("corsa " + $c.Etichetta + ": nel CSV mancano le colonne: " + ($manca -join ", ") + " (header OPTFRAME cambiato nella sonda?).")
    return
  }
  $maxIx = 0
  foreach($cName in $servono){ if($ix[$cName] -gt $maxIx){ $maxIx = $ix[$cName] } }

  $righe = New-Object System.Collections.ArrayList
  for($i2=1;$i2 -lt $lin.Count;$i2++){
    $cols = $lin[$i2] -split ','
    if($cols.Count -le $maxIx){
      [void]$Problemi.Add("corsa " + $c.Etichetta + ": riga " + $i2 + " del CSV ha meno colonne dell'header: non la leggo.")
      continue
    }
    $r = [pscustomobject]@{
      ModoIng  = [int](Num $cols[$ix["Modo Prezzo Ingresso"]])
      SegL     = Num $cols[$ix["Segnali Long"]]
      SegS     = Num $cols[$ix["Segnali Short"]]
      NudoL    = Num $cols[$ix["Segnali Nudo Long"]]
      NudoS    = Num $cols[$ix["Segnali Nudo Short"]]
      PendL    = Num $cols[$ix["Pending Attivo Long"]]
      PendS    = Num $cols[$ix["Pending Attivo Short"]]
      ArmL     = Num $cols[$ix["Armamenti Rsi Long"]]
      ArmS     = Num $cols[$ix["Armamenti Rsi Short"]]
      Giorni   = Num $cols[$ix["Giorni Contati"]]
      SigGgL   = Num $cols[$ix["Segnali Long Al Giorno"]]
      SigGgS   = Num $cols[$ix["Segnali Short Al Giorno"]]
      SigGgT   = Num $cols[$ix["Segnali Totali Al Giorno"]]
      MfeL     = Num $cols[$ix["Mfe Mediano Long Punti Indice"]]
      MfeS     = Num $cols[$ix["Mfe Mediano Short Punti Indice"]]
      MaeL     = Num $cols[$ix["Mae Mediano Long Punti Indice"]]
      MaeS     = Num $cols[$ix["Mae Mediano Short Punti Indice"]]
      RrL      = Num $cols[$ix["RR Da Mediane Long"]]
      RrS      = Num $cols[$ix["RR Da Mediane Short"]]
      WrL      = Num $cols[$ix["Win Rate Necessario Long Pct"]]
      WrS      = Num $cols[$ix["Win Rate Necessario Short Pct"]]
      MaxGgL   = Num $cols[$ix["Max Segnali Giorno Long"]]
      MaxGgS   = Num $cols[$ix["Max Segnali Giorno Short"]]
      MaxGgT   = Num $cols[$ix["Max Segnali Giorno Totale"]]
      G1L      = Num $cols[$ix["Giorni Almeno 1 Long"]]
      G1S      = Num $cols[$ix["Giorni Almeno 1 Short"]]
      G1T      = Num $cols[$ix["Giorni Almeno 1 Totale"]]
      GgZero   = Num $cols[$ix["Giorni Zero Segnali"]]
      MfeLunL  = Num $cols[$ix["Mfe Lungo Mediano Long Punti Indice"]]
      MfeLunS  = Num $cols[$ix["Mfe Lungo Mediano Short Punti Indice"]]
      MaeLunL  = Num $cols[$ix["Mae Lungo Mediano Long Punti Indice"]]
      MaeLunS  = Num $cols[$ix["Mae Lungo Mediano Short Punti Indice"]]
      MfeNegL  = Num $cols[$ix["Mfe Non Positive Long"]]
      MfeNegS  = Num $cols[$ix["Mfe Non Positive Short"]]
      MaeNegL  = Num $cols[$ix["Mae Non Positive Long"]]
      MaeNegS  = Num $cols[$ix["Mae Non Positive Short"]]
      AtrMed   = Num $cols[$ix["Atr Mediano Punti Indice"]]
      BarreVal = Num $cols[$ix["Barre Valutate"]]
      BarreSal = Num $cols[$ix["Barre Saltate Dati"]]
      FuoriOra = Num $cols[$ix["Segnali Scartati Orario"]]
      RsiDiv   = Num $cols[$ix["Rsi Divergenza Max"]]
      EmaDiv   = Num $cols[$ix["Ema Divergenza Max"]]
      AmbL     = Num $cols[$ix["Stato Ambiguo Long"]]
      AmbS     = Num $cols[$ix["Stato Ambiguo Short"]]
      PuntoIdx = Num $cols[$ix["Punto Indice Prezzo"]]
      BOriz    = [int](Num $cols[$ix["Barre Orizzonte"]])
      BOrizL   = [int](Num $cols[$ix["Barre Orizzonte Lungo"]])
      AutoKo   = [int](Num $cols[$ix["Autotest Falliti"]])
      AutoBl   = [int](Num $cols[$ix["Autotest Blocchi"]]) }
    [void]$righe.Add($r)
  }
  if($righe.Count -eq 0){ return }

  $rigaV = $null; $rigaS = $null
  foreach($r in $righe){
    if($r.ModoIng -eq 1){ $rigaV = $r } else { $rigaS = $r }
  }
  if($null -eq $rigaV){
    [void]$Problemi.Add("corsa " + $c.Etichetta + ": nessuna passata con Modo Prezzo Ingresso = 1 (la riga del verdetto): CSV non leggibile.")
    return
  }
  $c.RigaV = $rigaV; $c.RigaS = $rigaS

  # COLLAUDI: si verificano PRIMA di leggere qualunque numero, su OGNI
  # riga (i collaudi non dipendono dall'asse e devono reggere in tutte
  # e due le passate).
  foreach($r in $righe){
    $etR = $c.Etichetta + " (modo=" + $r.ModoIng + ")"
    if($r.AutoKo -eq -1){ [void]$Problemi.Add("riga " + $etR + ": Autotest Falliti = -1 (autotest NON girato): file invalido per i criteri del prova.") }
    elseif($r.AutoKo -gt 0){ [void]$Problemi.Add("riga " + $etR + ": Autotest Falliti = " + $r.AutoKo + ": la sonda DIVERGE dalla spec, i numeri NON si leggono.") }
    if($r.AutoBl -ne $AUTOTEST_BLOCCHI_ATTESI -and $r.AutoKo -ge 0){
      [void]$Rilievi.Add("riga " + $etR + ": Autotest Blocchi = " + $r.AutoBl + " invece di " + $AUTOTEST_BLOCCHI_ATTESI + " (sonda diversa da quella attesa?).")
    }
    if($r.RsiDiv -gt 0.001){ [void]$Problemi.Add("riga " + $etR + ": Rsi Divergenza Max = " + (Fmt3 $r.RsiDiv) + " (atteso ~0, V1): la traduzione dell'RSI diverge da iRSI, i numeri non valgono.") }
    if($r.EmaDiv -gt 0.00001){ [void]$Problemi.Add("riga " + $etR + ": Ema Divergenza Max = " + $r.EmaDiv.ToString("0.00000000",$INV) + " in prezzo (atteso < 0,00001, V3): il seeding delle EMA non e' quello dichiarato o il warmup e' corto; gli incroci non sono affidabili.") }
    # L'INVARIANTE V5, LA PIU' IMPORTANTE DI QUESTA SONDA: il latch
    # ricostruito con semi opposti non deve MAI divergere. Se diverge,
    # InpWarmupBarre e' troppo corto e NIENTE di questa corsa vale.
    if($r.AmbL -gt 0 -or $r.AmbS -gt 0){
      [void]$Problemi.Add("riga " + $etR + ": STATO AMBIGUO L " + (FmtN $r.AmbL) + " / S " + (FmtN $r.AmbS) + " (INVARIANTE V5, attesa 0/0): la coda di " + $FissiAttesi["InpWarmupBarre"] + " barre non basta a ricostruire il latch. I numeri di QUESTA CORSA NON VALGONO: alzare InpWarmupBarre e rifare.")
    }
    if($r.FuoriOra -gt 0){ [void]$Problemi.Add("riga " + $etR + ": Segnali Scartati Orario = " + (FmtN $r.FuoriOra) + " con InpUsaFinestraOraria=false: il pin non e' passato o la sonda filtra dove non deve.") }
    if($r.BOriz -ne 12){ [void]$Problemi.Add("riga " + $etR + ": eco Barre Orizzonte = " + $r.BOriz + " invece di 12: il pin non e' passato.") }
    if($r.BOrizL -ne $c.LungoAtteso){ [void]$Problemi.Add("riga " + $etR + ": eco Barre Orizzonte Lungo = " + $r.BOrizL + " invece di " + $c.LungoAtteso + " (8 ore su " + $c.Periodo + "): il pin non e' passato.") }
    if($r.BarreSal -gt 10){ [void]$Rilievi.Add("riga " + $etR + ": Barre Saltate Dati = " + (FmtN $r.BarreSal) + " (atteso ~0): buchi nello storico, da guardare.") }
    # GATE DI SOTTOINSIEME (V13b, gratuito): Segnali <= Nudo per lato.
    if($r.SegL -gt $r.NudoL -or $r.SegS -gt $r.NudoS){
      [void]$Problemi.Add("riga " + $etR + ": Segnali > Segnali Nudo (L " + (FmtN $r.SegL) + "/" + (FmtN $r.NudoL) + ", S " + (FmtN $r.SegS) + "/" + (FmtN $r.NudoS) + "): il segnale NON e' un sottoinsieme degli incroci EMA, il codice e' rotto.")
    }
    # IL PUNTO INDICE, PER CORSA (e' qui che l'oro si distingue).
    if([math]::Abs($r.PuntoIdx - 1.0) -gt 0.001){
      if($c.FuoriStampo){
        [void]$Problemi.Add("riga " + $etR + ": Punto Indice Prezzo = " + (Fmt3 $r.PuntoIdx) + " invece di 1,000 SU XAUUSD. L'atteso 1,00 viene da Point 0,01 misurato sul feed BCM (statements del conto demo, prezzi a 2 decimali) x conversione 100: se non torna, la scala dei decimali del feed e' un'altra e L'UNITA' della corsa oro va riletta dall'eco PRIMA di leggere F2. NON leggere i numeri cosi' come sono.")
      } else {
        [void]$Problemi.Add("riga " + $etR + ": Punto Indice Prezzo = " + (Fmt3 $r.PuntoIdx) + " invece di 1,000 (V9, come T8 dello stampo M0PB): la TAGLIA e' sbagliata di un fattore, F2 non si legge.")
      }
    }
  }
  # MFE/MAE NON POSITIVE: attese ZERO nella riga del verdetto (modo 1,
  # per costruzione V8); nella riga modo 0 POSSONO esserci e non si
  # gattano (l'ingresso e' fuori dalla finestra: e' un fatto, non un
  # difetto).
  if($rigaV.MfeNegL -gt 0 -or $rigaV.MfeNegS -gt 0 -or $rigaV.MaeNegL -gt 0 -or $rigaV.MaeNegS -gt 0){
    [void]$Problemi.Add("corsa " + $c.Etichetta + ": MFE/MAE non positive nella passata modo 1 (MFE L " + (FmtN $rigaV.MfeNegL) + " S " + (FmtN $rigaV.MfeNegS) + ", MAE L " + (FmtN $rigaV.MaeNegL) + " S " + (FmtN $rigaV.MaeNegS) + "): con l'ingresso all'apertura della prima barra della finestra devono essere ZERO per costruzione (V8). La finestra di misura non parte dove dovrebbe.")
  }

  $c.AutoKo = $rigaV.AutoKo; $c.AutoBlocchi = $rigaV.AutoBl
  $c.RsiDivMax = $rigaV.RsiDiv; $c.EmaDivMax = $rigaV.EmaDiv
  $c.AmbL = $rigaV.AmbL; $c.AmbS = $rigaV.AmbS
  $c.PuntoIdx = $rigaV.PuntoIdx
  $c.Giorni = $rigaV.Giorni; $c.BarreVal = $rigaV.BarreVal

  # GATE DI DETERMINISMO (V13a): l'asse tocca SOLO il prezzo
  # d'ingresso, quindi TUTTI i conteggi e gli invarianti devono venire
  # IDENTICI fra le due passate. Se uno si muove, le globali si
  # trascinano fra le passate e TUTTE le mediane sono sporche.
  if($null -ne $rigaS){
    $diffs = New-Object System.Collections.ArrayList
    if($rigaV.SegL  -ne $rigaS.SegL ){ [void]$diffs.Add("Segnali Long") }
    if($rigaV.SegS  -ne $rigaS.SegS ){ [void]$diffs.Add("Segnali Short") }
    if($rigaV.NudoL -ne $rigaS.NudoL){ [void]$diffs.Add("Segnali Nudo Long") }
    if($rigaV.NudoS -ne $rigaS.NudoS){ [void]$diffs.Add("Segnali Nudo Short") }
    if($rigaV.PendL -ne $rigaS.PendL){ [void]$diffs.Add("Pending Attivo Long") }
    if($rigaV.PendS -ne $rigaS.PendS){ [void]$diffs.Add("Pending Attivo Short") }
    if($rigaV.ArmL  -ne $rigaS.ArmL ){ [void]$diffs.Add("Armamenti Rsi Long") }
    if($rigaV.ArmS  -ne $rigaS.ArmS ){ [void]$diffs.Add("Armamenti Rsi Short") }
    if($rigaV.Giorni -ne $rigaS.Giorni){ [void]$diffs.Add("Giorni Contati") }
    if($rigaV.BarreVal -ne $rigaS.BarreVal){ [void]$diffs.Add("Barre Valutate") }
    if($rigaV.AmbL -ne $rigaS.AmbL -or $rigaV.AmbS -ne $rigaS.AmbS){ [void]$diffs.Add("Stato Ambiguo") }
    if([math]::Abs($rigaV.AtrMed - $rigaS.AtrMed) -gt 0.000001){ [void]$diffs.Add("Atr Mediano Punti Indice") }
    if([math]::Abs($rigaV.RsiDiv - $rigaS.RsiDiv) -gt 0.000001){ [void]$diffs.Add("Rsi Divergenza Max") }
    if($diffs.Count -gt 0){
      $c.Determinismo = "ROTTO (vedi PROBLEMI)"
      [void]$Problemi.Add("corsa " + $c.Etichetta + ": DETERMINISMO ROTTO, differiscono fra le 2 passate: " + ($diffs -join ", ") + ". Le globali si trascinano e TUTTE le mediane sono sporche.")
    } else {
      $c.Determinismo = "IDENTICI (conteggi, invarianti e ATR uguali nelle 2 passate)"
    }
    $c.Sens = "MFE mediana modo0 (chiusura): L " + (Fmt2 $rigaS.MfeL) + " / S " + (Fmt2 $rigaS.MfeS) + " contro modo1 (apertura): L " + (Fmt2 $rigaV.MfeL) + " / S " + (Fmt2 $rigaV.MfeS)
  } else {
    $c.Determinismo = "NON VERIFICABILE (manca la passata modo 0)"
    [void]$Problemi.Add("corsa " + $c.Etichetta + ": manca la passata con Modo Prezzo Ingresso = 0: sensibilita' non misurata e determinismo non incrociato.")
  }
  $sottoKo = @($Problemi | Where-Object { $_ -like ("*" + $c.Etichetta + "*sottoinsieme*") })
  if($sottoKo.Count -eq 0){ $c.Sottoinsieme = "OK (Segnali <= Nudo per lato, in ogni riga)" } else { $c.Sottoinsieme = "ROTTO (vedi PROBLEMI)" }

  # IL VERDETTO AUTOMATICO, PER LATO, coi tre cancelli congelati,
  # sulla riga modo 1. Sull'oro il verdetto esce MARCATO: le soglie F2
  # sono state congelate per gli INDICI e l'unita' qui e' l'USD.
  $c.VerdettoL = Verdetto $rigaV.SigGgL $rigaV.SigGgT $rigaV.MfeL $rigaV.RrL
  $c.VerdettoS = Verdetto $rigaV.SigGgS $rigaV.SigGgT $rigaV.MfeS $rigaV.RrS
  if($c.FuoriStampo){
    $c.VerdettoL = $c.VerdettoL + " [ORO: fuori stampo, lettura a parte]"
    $c.VerdettoS = $c.VerdettoS + " [ORO: fuori stampo, lettura a parte]"
  }
}

$CorseDaFare = @($CORSE)
if($SoloCorsa -ne ""){ $CorseDaFare = @($CORSE | Where-Object { $_.Etichetta -eq $SoloCorsa }) }

try{
  Titolo ("SONDA RSI+EMA V8 -- PASSO 0, CONTATORE (" + $EA + ") -- modo " + $Modo)

  # -------------------------------------------------------------------
  #  0. LE GUARDIE, PRIMA DI TOCCARE QUALUNQUE COSA
  # -------------------------------------------------------------------
  if($Pin -eq ""){ throw "-Pin obbligatorio: senza, girerebbe la punta del branch spacciandola per un commit congelato." }
  if($Pin -notmatch '^[0-9a-f]{40}$'){ throw ("-Pin deve essere un commit di 40 caratteri esadecimali, ricevuto: " + $Pin) }
  if(Get-Process terminal64,metaeditor64 -ErrorAction SilentlyContinue){
    throw "MT5 O METAEDITOR APERTO: col terminale aperto il tester non gira (zero CSV), con MetaEditor aperto la compilazione torna subito senza compilare."
  }
  if($SoloCorsa -ne "" -and @($CorseDaFare).Count -eq 0){
    $valide = ($CORSE | ForEach-Object { $_.Etichetta }) -join ", "
    throw ("-SoloCorsa '" + $SoloCorsa + "' non esiste. Valide: " + $valide)
  }
  if($SoloCorsa -ne ""){
    [void]$Rilievi.Add("girata UNA CORSA SOLA (" + $SoloCorsa + "): il gradiente M5/M15 (F6) e il confronto fra simboli si leggono solo col giro completo.")
  }

  Dico ("pin ......... " + $Pin)
  Dico ("corse ....... " + @($CorseDaFare).Count + " su 7 (3 indici x M5/M15 = stampo M0PB, + ORO_M15 XAUUSD fuori stampo su richiesta di Claudio 02/09), " + $NCelleAttese + " passate a corsa (asse InpModoPrezzoIngresso 1|0)")
  Dico ("finestra .... " + $DaQuando + " -> " + $Fino + " (UNA TRANCHE, FrazioneIS " + $FrazioneIS + ")")
  Dico ("banco ....... MODELLO 2 (SOLO PREZZI DI APERTURA): contatore su barra chiusa, il tick non aggiunge niente. Deposito " + $Deposito + " (inerte: zero ordini)")
  Dico ("cancelli .... F1 tot >= " + (Fmt2 $SOGLIA_F1_TOT) + " E lato >= " + (Fmt2 $SOGLIA_F1_LATO) + " segnali/gg | F2 MFE mediana VIVA solo > " + (Fmt2 $F2_VIVO) + " punti idx (" + (Fmt2 $F2_SCARTO) + "-" + (Fmt2 $F2_VIVO) + " sospeso, < " + (Fmt2 $F2_SCARTO) + " morto) | H8 RR >= " + (Fmt2 $SOGLIA_H8)) "Yellow"
  Dico ("invariante .. Stato Ambiguo Long/Short ATTESO 0/0 in OGNI passata (V5): se non e' zero, la corsa NON vale." ) "Yellow"
  Dico ("oro ......... ORO_M15: 1 'punto indice' = 1,00 USD di prezzo oro (Point 0,01 x 100). Lettura A PARTE, non nel confronto M0PB." ) "Yellow"
  Dico ("tetto barre . M5 su 21 mesi puo' eccedere ~100k barre: la finestra EFFETTIVA la dichiara la sonda (Giorni Contati / Barre Valutate)." ) "Yellow"

  # -------------------------------------------------------------------
  #  1. SCARICO AL PIN
  # -------------------------------------------------------------------
  Titolo "1. SCARICO AL PIN"
  New-Item -ItemType Directory -Force -Path $Work,$Prove | Out-Null

  $drv = Join-Path $Work "walkforward_generico.ps1"
  Scarica ($RawPin + "/backtest_pipeline/walkforward_generico.ps1") $drv
  # il driver generico riscarica il .mq5 dal SUO $EABranch: senza questo
  # replace il pin varrebbe per il driver e NON per la sonda misurata.
  $t = Get-Content -LiteralPath $drv -Raw
  if($t -notmatch '\$EABranch\s*=\s*"lavoro"'){ throw 'walkforward_generico.ps1 non ha la riga $EABranch = "lavoro" attesa: non lo posso pinnare (il pin varrebbe per il driver e NON per la sonda misurata).' }
  $t = $t -replace '\$EABranch\s*=\s*"lavoro"', ('$EABranch="' + $Pin + '"')
  Set-Content -LiteralPath $drv -Value $t -Encoding ASCII
  Dico "driver generico scaricato e PINNATO (riscarica la sonda al pin, non dalla punta del branch)" "Green"

  # artefatti intermedi ripuliti PRIMA (difetto n.14 della checklist): un
  # prova di una versione precedente verrebbe gattato in buona fede.
  Remove-Item -Path (Join-Path $Prove "RSIEMAV8_*.txt") -Force -ErrorAction SilentlyContinue

  foreach($f in @($PROVA_M5,$PROVA_M15)){
    Scarica ($RawPin + "/backtest_pipeline/prove/" + $f) (Join-Path $Prove $f)
  }
  Dico ("file prova scaricati: " + @(Get-ChildItem $Prove -Filter "RSIEMAV8_*.txt").Count + " su 2") "Green"

  # -------------------------------------------------------------------
  #  2. I GATE SUI DUE PROVA -- girano PRIMA di aprire MT5
  # -------------------------------------------------------------------
  Titolo "2. GATE SUI DUE PROVA (direttive nude + fissi + asse unico + celle contate + gemellaggio M5/M15)"
  $letture = @{}
  foreach($pf in @($PROVA_M5,$PROVA_M15)){
    $tfAtteso = "M5";  $lungoAtteso = "96"
    if($pf -eq $PROVA_M15){ $tfAtteso = "M15"; $lungoAtteso = "32" }
    $esito = GateProva (Join-Path $Prove $pf) $pf $tfAtteso $lungoAtteso
    $letture[$pf] = $esito.Lettura
    $CelleTxt = "" + $esito.Celle + " a corsa (asse InpModoPrezzoIngresso 1|0), ricontate dai pin ||Y al pin"
  }
  Dico ("gate per prova: direttive nude 4/4, 1 asse Y esatto, celle " + $CelleTxt + ", 12 input pinnati nome per nome, nessuna riga estranea: PASSATI") "Green"

  $Gemelle = GateGemellaggio $letture[$PROVA_M5].Mappa $letture[$PROVA_M15].Mappa $PROVA_M5 $PROVA_M15
  Dico ("gemellaggio M5/M15: " + $Gemelle) "Green"

  # -------------------------------------------------------------------
  #  3. IL SORGENTE: GREP DEL CONTATORE PURO + TERMINALE + COMPILAZIONE
  # -------------------------------------------------------------------
  Titolo "3. SORGENTE (grep contatore puro), TERMINALE E COMPILAZIONE (EA MAI compilato)"
  $mq5 = Join-Path $Work ($EA + ".mq5")
  Scarica ($RawPin + "/mql5/Experts/" + $EA + ".mq5") $mq5

  # IL GREP CHE LA SONDA PROMETTE NEL PROPRIO HEADER: zero chiamate di
  # trading FUORI dai commenti. Il modello sta QUI e non nel .mq5,
  # apposta (combacerebbe con se' stesso).
  $chiamate = 0
  foreach($riga in @(Get-Content -LiteralPath $mq5)){
    $viva = ($riga -replace '//.*$','')
    if($viva -match 'OrderSend|CTrade|PositionClose|PositionOpen|OrderClose|Trade\.mqh|\.Buy\(|\.Sell\('){ $chiamate++ }
  }
  $GrepTxt = "" + $chiamate + " chiamate di trading fuori dai commenti (attese 0)"
  if($chiamate -gt 0){ throw ("IL CONTATORE NON E' PURO: " + $GrepTxt + ". Questo file NON deve poter aprire ordini: ci si ferma qui.") }
  Dico ("grep contatore puro: " + $GrepTxt) "Green"

  $allTerm = @(Get-ChildItem "C:\Program Files","C:\Program Files (x86)" -Recurse -Filter "terminal64.exe" -ErrorAction SilentlyContinue)
  $cand = $allTerm | Where-Object { $_.DirectoryName -like "*BCM Markets MT5 Terminal*" -and $_.DirectoryName -notlike "*-V3*" } | Select-Object -First 1
  if(-not $cand){ $cand = $allTerm | Where-Object { $_.DirectoryName -like "*BCM Markets*" } | Select-Object -First 1 }
  if(-not $cand){ throw "terminale BCM non trovato." }
  $instDir    = $cand.DirectoryName
  $MetaEditor = Join-Path $instDir "metaeditor64.exe"
  $termRoot   = Join-Path $env:APPDATA "MetaQuotes\Terminal"
  $dataFolder = (Get-ChildItem $termRoot -Directory -ErrorAction SilentlyContinue | Where-Object { $o = Join-Path $_.FullName "origin.txt"; (Test-Path $o) -and ((Get-Content $o -Raw).Trim() -ieq $instDir) } | Select-Object -First 1 -ExpandProperty FullName)
  if(-not $dataFolder){ throw ("cartella dati non trovata per " + $instDir) }
  $Terminale = $instDir
  Dico ("terminale scelto: " + $instDir) "Yellow"

  # COMPILAZIONE QUI, con l'.ex5 vecchio CANCELLATO prima: se fallisce,
  # QUELLO e' il risultato del passo (EA nuovo, mai compilato). La
  # sonda non ha include da installare: e' autosufficiente per scelta.
  $dstExp = Join-Path $dataFolder "MQL5\Experts"
  New-Item -ItemType Directory -Force -Path $dstExp | Out-Null
  $dstMq5 = Join-Path $dstExp ($EA + ".mq5")
  Copy-Item $mq5 -Destination $dstMq5 -Force
  $ex5 = Join-Path $dstExp ($EA + ".ex5")
  Remove-Item -LiteralPath $ex5 -Force -ErrorAction SilentlyContinue
  $t0 = Get-Date
  & $MetaEditor ("/compile:" + $dstMq5) "/log" | Out-Null
  while((-not (Test-Path -LiteralPath $ex5)) -and ((New-TimeSpan -Start $t0 -End (Get-Date)).TotalSeconds -lt 180)){ Start-Sleep -Seconds 2 }
  if(-not (Test-Path -LiteralPath $ex5)){
    # IL CAMPO SI TIMBRA QUI, PRIMA DEL throw: se lo aggiornasse solo il ramo
    # di successo, il referto del giro FALLITO direbbe ancora "NON TENTATA" --
    # cioe' negherebbe agli atti PROPRIO il fatto che questo passo misura
    # (EA mai compilato). Tre stati e tutti e tre veri: NON TENTATA (non ci
    # siamo arrivati) / FALLITA (tentata, niente .ex5) / OK.
    $Compilato = "FALLITA (tentata, nessun .ex5 prodotto): QUESTO E' IL RISULTATO DEL PASSO -- gli errori sono in COMPILAZIONE_FALLITA.log dentro lo zip"
    $logC = Join-Path $dstExp ($EA + ".log")
    if(Test-Path -LiteralPath $logC){
      Copy-Item $logC -Destination (Join-Path $Work "COMPILAZIONE_FALLITA.log") -Force
      Get-Content -LiteralPath $logC -Tail 40 | ForEach-Object { Write-Host $_ -ForegroundColor Red }
    }
    throw ("COMPILAZIONE FALLITA: " + $EA + " non ha prodotto l'.ex5. E' un EA NUOVO, MAI compilato: questo E' il risultato del passo. Gli errori sono qui sopra e in COMPILAZIONE_FALLITA.log dentro lo zip.")
  }
  $Compilato = "OK (" + [int]((Get-Item -LiteralPath $ex5).Length/1024) + " KB, " + (Get-Item -LiteralPath $ex5).LastWriteTime.ToString("HH:mm:ss",$INV) + ")"
  Dico ("compilato " + $EA + ": " + $Compilato) "Green"

  # LA CACHE DEL TESTER (checklist punto 38), coi conteggi. Qui e'
  # PROBABILMENTE non load-bearing (EA mai girato: nessun pass in cache
  # puo' combaciare), ma costa secondi e toglie una classe di sorprese.
  # Si svuota SOLO Tester\cache (MAI bases\<server>\ticks, lo storico).
  $cacheT = Join-Path $dataFolder "Tester\cache"
  if(Test-Path -LiteralPath $cacheT){
    $ncPrima = @(Get-ChildItem -LiteralPath $cacheT -Recurse -File -ErrorAction SilentlyContinue).Count
    Remove-Item (Join-Path $cacheT "*") -Recurse -Force -ErrorAction SilentlyContinue
    $ncDopo  = @(Get-ChildItem -LiteralPath $cacheT -Recurse -File -ErrorAction SilentlyContinue).Count
    $CacheTxt = "prima " + $ncPrima + " file, dopo " + $ncDopo
    if($ncDopo -gt 0){
      [void]$Problemi.Add("Tester\cache NON si e' svuotata (prima " + $ncPrima + ", dopo " + $ncDopo + "): probabilmente innocuo (EA nuovo), ma un pass ripescato non chiama OnTester e lascia il CSV monco.")
      Dico ("Tester\cache NON SVUOTATA: " + $CacheTxt) "Red"
    }
    else{ Dico ("Tester\cache svuotata: " + $CacheTxt) "Green" }
  }
  else{
    $CacheTxt = "cartella assente (" + $cacheT + "): niente da svuotare"
    Dico ("Tester\cache: " + $CacheTxt) "Yellow"
  }

  # -------------------------------------------------------------------
  #  4. LE SETTE CORSE -- il generico una volta per corsa
  # -------------------------------------------------------------------
  Titolo ("4. LE CORSE (generico per corsa, Modello 2 OPEN PRICES, FrazioneIS " + $FrazioneIS + ")")
  foreach($c in $CorseDaFare){
    $override = ""
    if($c.Simbolo -ne $SimboloLead){ $override = " [OVERRIDE -Simbolo: il prova dichiara il lead " + $SimboloLead + "]" }
    if($c.FuoriStampo){ $override = $override + " [ORO: FUORI STAMPO M0PB, lettura a parte]" }
    Dico ("CORSA " + $c.Etichetta + " | " + $c.Simbolo + " " + $c.Periodo + " | " + $c.Prova + $override) "Cyan"
    # L'ORA DI AVVIO DELLA CORSA: e' il METRO DI FRESCHEZZA del CSV che
    # si leggera' dopo (classe CSV STANTIO). La workdir e' RIUSABILE e
    # NON si svuota: se il generico MUORE PRIMA di rifare la corsa, il
    # CSV della corsa PRECEDENTE resta esattamente dov'era.
    $tCorsa = Get-Date
    # "-Rifai" sta SEMPRE nell'argv: la classe skip-senza-Rifai ha
    # prodotto 4 corse zombie su 6 nella saga CRT (31/08).
    $argv = @("-ExecutionPolicy","Bypass","-File",$drv,
              "-Expert",$EA,
              "-Prova",(Join-Path $Prove $c.Prova),
              "-Etichetta",$c.Etichetta,
              "-Simbolo",$c.Simbolo,
              "-Periodo",$c.Periodo,
              "-DaQuando",$DaQuando,
              "-Fino",$Fino,
              ("-FrazioneIS"),("" + $FrazioneIS),
              "-Modello","2",
              "-Rifai",
              "-Deposito",("" + $Deposito))
    if($SoloControllo){ $argv += "-SoloControllo" }
    # l'argv finisce a schermo PER INTERO: "-Rifai c'e' o no" e' un gate
    # del verificatore (checklist 31/08) e deve poter essere riletto nel
    # log della console, non solo nel sorgente.
    Dico ("argv generico: " + ($argv -join " "))
    # L'EXIT CODE SI LEGGE A TRE STATI (classe 108 del 02/09): su PS 5.1
    # il codice puo' essere VUOTO e '$null -ne 0' e' VERO. Un codice non
    # letto NON e' un fallimento: si scrive nei RILIEVI e il verdetto
    # della corsa lo danno gli ARTEFATTI DATATI (il CSV fresco e
    # contato, qui sotto in AnalizzaCsvCorsa).
    $global:LASTEXITCODE = $null
    & powershell $argv
    $grezzo = $LASTEXITCODE
    $rc = -1; $rcLetto = $false
    if($null -ne $grezzo -and (("" + $grezzo).Trim()) -match '^-?\d+$'){
      $rc = [int](("" + $grezzo).Trim()); $rcLetto = $true
    }
    if($rcLetto -and $rc -ne 0){
      [void]$Problemi.Add("corsa " + $c.Etichetta + ": il generico e' uscito con codice " + $rc + " (storico mancante? CSV non prodotto? Il rosso sul *_OOS invece e' ATTESO con FrazioneIS 1.0).")
    }
    elseif(-not $rcLetto){
      [void]$Rilievi.Add("corsa " + $c.Etichetta + ": codice di uscita del generico NON LETTO (vuoto su PS 5.1, classe 108). Non e' un fallimento e non e' un successo: e' un dato che non c'e'. Il verdetto della corsa sta sugli ARTEFATTI DATATI (CSV fresco e contato), come prescrive la regola.")
    }
    if($SoloControllo){ continue }

    # IL CSV DELLA CORSA SI DATA, SI CONTA E SI LEGGE PER NOME, dentro
    # la funzione collaudata dal mutation test.
    # Modello != 4 -> suffisso "_ohlc" + etichetta (marca "non-tick").
    $csvIS = Join-Path $Work ("risultati_prove\" + $EA + "\" + $EA + "_" + $c.Simbolo + "_IS_ohlc_" + $c.Etichetta + ".csv")
    AnalizzaCsvCorsa $c $csvIS $tCorsa
  }

  # FIRMA DEL TETTO (checklist punto 36): Barre Valutate IDENTICHE su
  # simboli DIVERSI dello stesso TF = tetto, non dato. Si cerca a
  # macchina, non a occhio.
  if(-not $SoloControllo){
    foreach($tf in @("M5","M15")){
      $conBarre = @($CORSE | Where-Object { $_.Periodo -eq $tf -and $null -ne $_.BarreVal })
      if($conBarre.Count -ge 2){
        $barre = @($conBarre | ForEach-Object { [long]$_.BarreVal } | Sort-Object -Unique)
        if($barre.Count -eq 1){
          [void]$Rilievi.Add("FIRMA DEL TETTO su " + $tf + ": Barre Valutate IDENTICHE (" + $barre[0] + ") su " + $conBarre.Count + " simboli diversi. Il broker non da' mai lo stesso numero a simboli diversi; il tetto si'. La finestra EFFETTIVA e' piu' corta di quella chiesta: leggere i Giorni Contati per corsa.")
        }
      }
    }
    # M5 contro M15 sullo stesso simbolo (solo i tre indici: l'oro gira
    # solo a M15): se M5 conta molti meno giorni, la finestra M5 e'
    # troncata (tetto) e va dichiarata.
    foreach($sym in @("U30USD","NASUSD","D30EUR")){
      $c5  = $CORSE | Where-Object { $_.Simbolo -eq $sym -and $_.Periodo -eq "M5"  } | Select-Object -First 1
      $c15 = $CORSE | Where-Object { $_.Simbolo -eq $sym -and $_.Periodo -eq "M15" } | Select-Object -First 1
      if($null -ne $c5 -and $null -ne $c15 -and $null -ne $c5.Giorni -and $null -ne $c15.Giorni -and $c15.Giorni -gt 0){
        if($c5.Giorni -lt 0.9*$c15.Giorni){
          [void]$Rilievi.Add("TETTO su " + $sym + " M5: " + (FmtN $c5.Giorni) + " giorni contati contro " + (FmtN $c15.Giorni) + " a M15. La corsa M5 copre una finestra EFFETTIVA piu' corta: F1 resta per-giorno (leggibile), il campione e il regime coperto vanno dichiarati nel referto di lettura -- e il confronto F6 fra M5 e M15 confronta anche due finestre diverse, va detto.")
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
#  RACCOLTA -- SEMPRE, anche quando la corsa si e' fermata a meta'.
# =====================================================================
if($Modo -ne "CORSA" -and $Modo -ne "CONTROLLO"){
  [void]$Problemi.Add("BUG INTERNO (punto 79 della checklist): la variabile del modo era stata sovrascritta e valeva " + $Modo + ". Nome del referto e dello zip ricostruiti.")
  $Modo = "CORSA"; if($SoloControllo){ $Modo = "CONTROLLO" }
}
Titolo "RACCOLTA"
$Cart = Join-Path $Dsk ("SONDARSIEMAV8_" + $Modo + "_" + $Stamp)
New-Item -ItemType Directory -Force -Path $Cart | Out-Null

# IL CONTEGGIO DEI CSV *_OOS SI FA QUI, PRIMA DEL REFERTO, cosi' il
# numero finisce NEL REFERTO e non solo a schermo (debito M0PB pagato
# gia' su LondonFx, ereditato pagato).
$Results = Join-Path $Work ("risultati_prove\" + $EA)
$nOosTrovati = 0
foreach($c in $CORSE){
  $fOos = Join-Path $Results ($EA + "_" + $c.Simbolo + "_OOS_ohlc_" + $c.Etichetta + ".csv")
  if(Test-Path -LiteralPath $fOos){ $nOosTrovati++ }
}
if($nOosTrovati -gt 0){
  [void]$Rilievi.Add("" + $nOosTrovati + " CSV *_OOS esistono NONOSTANTE la gamba degenere (FrazioneIS " + $FrazioneIS + "): numeri su finestra NON dichiarata, NON leggerli. Sono nello zip solo come reperto.")
}

$RefTxt = New-Object System.Collections.ArrayList
[void]$RefTxt.Add("=====================================================================")
[void]$RefTxt.Add(" SONDA RSI+EMA V8 -- PASSO 0, CONTATORE DI FREQUENZA E TAGLIA (" + $EA + ")")
[void]$RefTxt.Add(" 3 indici (U30USD, NASUSD, D30EUR) x M5/M15 + ORO_M15 (XAUUSD, fuori")
[void]$RefTxt.Add(" stampo) -- NESSUN ORDINE -- 2 passate a corsa")
[void]$RefTxt.Add("=====================================================================")
[void]$RefTxt.Add("modo: " + $Modo + "   <- CONTROLLO = giro a vuoto, NON e' il risultato")
[void]$RefTxt.Add("data: " + $Avvio.ToString("yyyy-MM-dd HH:mm:ss",$INV))
[void]$RefTxt.Add("pin:  " + $Pin)
[void]$RefTxt.Add("finestra: " + $DaQuando + " -> " + $Fino + "  (UNA TRANCHE, FrazioneIS " + $FrazioneIS + ")")
[void]$RefTxt.Add("banco: MODELLO 2 (SOLO PREZZI DI APERTURA). Il segnale nasce su barra chiusa e non si apre niente: il tick non aggiunge informazione. I CSV portano il suffisso _ohlc (marca del generico per ogni modello non-tick). E' IL BANCO IDENTICO alla corsa M0PB del 31/08 (morta 12/12), piu' l'oro dichiarato.")
[void]$RefTxt.Add("terminale: " + $Terminale)
[void]$RefTxt.Add("compilazione: " + $Compilato + "   <- EA NUOVO: se e' FALLITA, QUESTO e' il risultato del passo")
[void]$RefTxt.Add("cache tester: " + $CacheTxt)
[void]$RefTxt.Add("grep contatore puro: " + $GrepTxt)
[void]$RefTxt.Add("celle per corsa: " + $CelleTxt)
[void]$RefTxt.Add("gemellaggio prova M5/M15: " + $Gemelle)
[void]$RefTxt.Add("override simboli: @SIMBOLO dei prova = " + $SimboloLead + " (lead); NASUSD, D30EUR e XAUUSD girano con -Simbolo del generico (il parametro vince sulla direttiva). DICHIARATO, non nascosto.")
[void]$RefTxt.Add("ORO_M15 (XAUUSD): corsa AGGIUNTA su richiesta esplicita di Claudio (02/09), FUORI dallo stampo M0PB. 1 'punto indice' = 1,00 USD di prezzo oro (Point 0,01 x conversione 100: eco atteso 1,000 anche qui). Le soglie F2 (5,0/7,0) sono congelate per gli INDICI: sull'oro si leggono come 5-7 USD, il verdetto esce marcato [ORO] ed e' una LETTURA A PARTE. Il confronto diretto col banco M0PB resta sui tre indici; l'ATR mediano in colonna dice se 5-7 USD sono sopra o sotto il rumore dell'oro.")
[void]$RefTxt.Add("csv *_OOS trovati: " + $nOosTrovati + " (attesi 0: FrazioneIS " + $FrazioneIS + " = gamba OOS degenere; il rosso del generico su quei file e' ATTESO e NON si rilancia)")
[void]$RefTxt.Add("")
[void]$RefTxt.Add("--- I TRE CANCELLI (congelati PRIMA dei numeri; disuguaglianze da VerdettoF1/F2/H8_Calc, autotest blocco 16 sui bordi esatti) ---")
[void]$RefTxt.Add("  F1 (AND): totale L+S >= " + (Fmt2 $SOGLIA_F1_TOT) + " segnali/giorno (pavimento 01/09) E ogni lato >= " + (Fmt2 $SOGLIA_F1_LATO) + " (scheda 31/08)")
[void]$RefTxt.Add("  F2 MFE mediana a 12 barre VIVA solo > " + (Fmt2 $F2_VIVO) + " punti indice (< " + (Fmt2 $F2_SCARTO) + " morto; " + (Fmt2 $F2_SCARTO) + "-" + (Fmt2 $F2_VIVO) + " INCLUSI sospeso [SPREAD NON MISURATO, Code Base 74148 mai usato]; clausola severa 31/08)")
[void]$RefTxt.Add("  H8 RR da mediane >= " + (Fmt2 $SOGLIA_H8) + " (FIRMA 2 del 31/08: sotto = MORTO PER ARITMETICA, niente corsa a tick)")
[void]$RefTxt.Add("  VERDETTO PER CORSA E PER LATO sulla passata Modo Prezzo Ingresso = 1: nessuna cella promossa, nessun aggregato di merito.")
[void]$RefTxt.Add("")
[void]$RefTxt.Add("--- LA TABELLA DEI CANCELLI, PER CORSA E PER LATO (mai aggregati) ---")
[void]$RefTxt.Add(("{0,-8} {1,-6} {2,8} {3,8} {4,9} {5,9} {6,7} {7,8} {8,7}  {9}" -f "corsa","lato","sig/gg","tot/gg","MFE med","MAE med","RR","WRnec %","max/gg","VERDETTO"))
foreach($c in $CORSE){
  if($null -eq $c.RigaV){
    [void]$RefTxt.Add(("{0,-8} {1,-6} " -f $c.Etichetta,"-") + "SENZA NUMERI (corsa non girata o CSV non letto)")
    continue
  }
  $rv = $c.RigaV
  [void]$RefTxt.Add(("{0,-8} {1,-6} {2,8} {3,8} {4,9} {5,9} {6,7} {7,8} {8,7}  {9}" -f $c.Etichetta,"LONG", (Fmt3 $rv.SigGgL), (Fmt3 $rv.SigGgT), (Fmt2 $rv.MfeL), (Fmt2 $rv.MaeL), (Fmt3 $rv.RrL), (Fmt2 $rv.WrL), (FmtN $rv.MaxGgL), $c.VerdettoL))
  [void]$RefTxt.Add(("{0,-8} {1,-6} {2,8} {3,8} {4,9} {5,9} {6,7} {7,8} {8,7}  {9}" -f "","SHORT", (Fmt3 $rv.SigGgS), (Fmt3 $rv.SigGgT), (Fmt2 $rv.MfeS), (Fmt2 $rv.MaeS), (Fmt3 $rv.RrS), (Fmt2 $rv.WrS), (FmtN $rv.MaxGgS), $c.VerdettoS))
  [void]$RefTxt.Add("         segnali L/S " + (FmtN $rv.SegL) + "/" + (FmtN $rv.SegS) + " su " + (FmtN $rv.Giorni) + " giorni contati | giorni con >=1: L " + (FmtN $rv.G1L) + " S " + (FmtN $rv.G1S) + " tot " + (FmtN $rv.G1T) + " | giorni a ZERO " + (FmtN $rv.GgZero) + " | ATR mediano " + (Fmt2 $rv.AtrMed) + " punti idx")
  [void]$RefTxt.Add("         ABLAZIONE (la domanda della scheda 31/08, in numeri): NUDO (soli incroci EMA) L " + (FmtN $rv.NudoL) + " / S " + (FmtN $rv.NudoS) + " contro SEGNALI VERI L " + (FmtN $rv.SegL) + " / S " + (FmtN $rv.SegS) + " | pending ARMATO su L " + (FmtN $rv.PendL) + " / S " + (FmtN $rv.PendS) + " di " + (FmtN $rv.BarreVal) + " barre valutate | armamenti RSI L " + (FmtN $rv.ArmL) + " / S " + (FmtN $rv.ArmS))
  [void]$RefTxt.Add("         (se SEGNALI ~ NUDO e il pending e' quasi sempre armato, il filtro non filtra: e' un incrocio di EMA, famiglia SuperWave/ChaosLyapunov, gia' morta due volte -- e il verdetto di carta risulterebbe CONFERMATO DA UNA MISURA)")
  [void]$RefTxt.Add("         orizzonte LUNGO (" + $c.LungoAtteso + " barre = 8 ore, INFORMATIVO): MFE L " + (Fmt2 $rv.MfeLunL) + " / S " + (Fmt2 $rv.MfeLunS) + " | MAE L " + (Fmt2 $rv.MaeLunL) + " / S " + (Fmt2 $rv.MaeLunS) + " punti idx")
  [void]$RefTxt.Add("         muro giornaliero F4 (dalla passata del verdetto): " + (FmtN $rv.MaxGgT) + " segnali x 0,65% = " + (Fmt2 (0.65*$rv.MaxGgT)) + "% di rischio aperto contro il cap C1 di 3,25% (18/08)")
  [void]$RefTxt.Add("         CSV letto: scritto alle " + $c.CsvOra + " -- FRESCO (piu' recente dell'avvio di QUESTA corsa: un CSV piu' vecchio sarebbe di una corsa precedente e NON verrebbe letto)")
  [void]$RefTxt.Add("         sensibilita' ingresso: " + $c.Sens)
  [void]$RefTxt.Add("         determinismo 2 passate: " + $c.Determinismo + " | sottoinsieme: " + $c.Sottoinsieme)
  if($c.FuoriStampo){
    [void]$RefTxt.Add("         [ORO] unita' = 1,00 USD di prezzo oro, NON un punto indice. Soglie F2/H8 congelate per gli INDICI: qui il verdetto e' una lettura A PARTE, mai nel confronto M0PB.")
  }
}
[void]$RefTxt.Add("")
[void]$RefTxt.Add("--- I COLLAUDI, PER CORSA (si leggono PRIMA dei numeri) ---")
[void]$RefTxt.Add(("{0,-8} {1,6} {2,14} {3,12} {4,12} {5,6} {6,6} {7,10} {8,12}" -f "corsa","righe","autotest","RsiDivMax","EmaDivMax","AmbL","AmbS","PuntoIdx","BarreVal"))
foreach($c in $CORSE){
  $at = "n/d"
  if($c.AutoKo -eq 0){ $at = "0/" + (FmtN $c.AutoBlocchi) + " PASSATI" }
  elseif($c.AutoKo -gt 0){ $at = "" + $c.AutoKo + " FALLITI" }
  elseif($c.AutoKo -eq -1){ $at = "-1 NON GIRATO" }
  $emaTxt = "n/d"
  if($null -ne $c.EmaDivMax){ $emaTxt = ([double]$c.EmaDivMax).ToString("0.00000000",$INV) }
  [void]$RefTxt.Add(("{0,-8} {1,6} {2,14} {3,12} {4,12} {5,6} {6,6} {7,10} {8,12}" -f $c.Etichetta, (FmtN $c.Righe), $at, (Fmt3 $c.RsiDivMax), $emaTxt, (FmtN $c.AmbL), (FmtN $c.AmbS), (Fmt3 $c.PuntoIdx), (FmtN $c.BarreVal)))
}
[void]$RefTxt.Add("  attesi: righe 2 | autotest 0/" + $AUTOTEST_BLOCCHI_ATTESI + " | RsiDivMax ~0 (V1) | EmaDivMax < 0,00001 in prezzo (V3) | AmbL/AmbS = 0 (INVARIANTE V5: se non e' zero, la corsa NON vale) | PuntoIdx 1,000 (V9; sull'oro = 1,00 USD, vedi sopra)")
[void]$RefTxt.Add("")
[void]$RefTxt.Add("--- LE NOTE CHE VANNO LETTE INSIEME AI NUMERI ---")
[void]$RefTxt.Add("  - LE ESCURSIONI SONO LIMITI SUPERIORI: la fonte non ha uscite (e' un indicatore), la sonda")
[void]$RefTxt.Add("    misura 12 barre piene. Su F2 la distorsione e' conservativa NEL VERSO GIUSTO; su H8 NO")
[void]$RefTxt.Add("    (anche la MAE e' un limite superiore): l'RR e' un'INDICAZIONE, dichiarato prima dei numeri.")
[void]$RefTxt.Add("  - LA SONDA NON SIMULA ESITI: non sa se la MFE arriva PRIMA della MAE. Quello lo vede solo")
[void]$RefTxt.Add("    il tick, dopo, e SOLO se i tre cancelli reggono (R57).")
[void]$RefTxt.Add("  - F6, GRADIENTE DI TIMEFRAME: il muro d'attrito e' 12 BARRE su entrambi i TF, quindi su M15")
[void]$RefTxt.Add("    copre il triplo del tempo (180 contro 60 minuti). Se la MFE passa F2 solo su M15, il")
[void]$RefTxt.Add("    candidato non e' 'vivo su M15': e' vivo su un orizzonte tre volte piu' lungo, e va detto cosi'.")
[void]$RefTxt.Add("  - CODA NON VALUTATA (V7): le ultime 96 barre M5 / 32 barre M15 (8 ore) non producono segnali,")
[void]$RefTxt.Add("    in cambio NESSUNA mediana e' sporcata da un orizzonte troncato. Su 21 mesi e' trascurabile.")
[void]$RefTxt.Add("  - TETTO BARRE: se i RILIEVI segnalano la firma del tetto su M5, la finestra effettiva M5 e'")
[void]$RefTxt.Add("    piu' corta di quella chiesta. F1 resta per-giorno (leggibile); campione e regime si dichiarano.")
[void]$RefTxt.Add("  - UN SOLO REGIME (toro): questo passo conta OCCASIONI e misura GEOMETRIE, non merito.")
[void]$RefTxt.Add("  - Nessun per-trade CSV e nessun CSV riga-per-segnale: corsa in ottimizzazione, zero ordini.")
[void]$RefTxt.Add("    I numeri stanno SOLO nelle colonne OPTFRAME (59) dei CSV *_IS_ohlc_*.")
[void]$RefTxt.Add("  - Questa corsa NON promuove niente e NON dice se il motore guadagna: e' un conteggio.")
[void]$RefTxt.Add("    Il merito si misura a tick, dopo, e SOLO se i tre cancelli reggono (R57).")
[void]$RefTxt.Add("")
if($FrazioneIS -ge 1.0){
  [void]$RefTxt.Add("AVVISO: FrazioneIS 1.0 -> la gamba 'OOS' del generico e' DEGENERE (0 giorni).")
  [void]$RefTxt.Add("Il rosso del generico sui CSV *_OOS e' ATTESO e si IGNORA: NON rilanciare.")
  [void]$RefTxt.Add("")
}
if($Fatale -ne ""){ [void]$RefTxt.Add("!!! FERMATO: " + $Fatale); [void]$RefTxt.Add("") }
[void]$RefTxt.Add("PROBLEMI: " + $Problemi.Count)
foreach($p in $Problemi){ [void]$RefTxt.Add("  - " + $p) }
[void]$RefTxt.Add("RILIEVI: " + $Rilievi.Count)
foreach($p in $Rilievi){ [void]$RefTxt.Add("  - " + $p) }
[void]$RefTxt.Add("")
[void]$RefTxt.Add('COME SI RIPRENDE: dalla pagina righe/RIGA_SONDARSIEMAV8_DA_MANDARE.md, NON da')
[void]$RefTxt.Add('questa riga: $Pin nasce dentro il blocco e non sopravvive.')

$refPath = Join-Path $Cart "REFERTO_SONDARSIEMAV8.txt"
Set-Content -LiteralPath $refPath -Value ($RefTxt -join "`r`n") -Encoding ASCII
Write-Host ($RefTxt -join "`r`n")

foreach($f in @("COMPILAZIONE_FALLITA.log")){
  $src = Join-Path $Work $f
  if(Test-Path -LiteralPath $src){ Copy-Item $src -Destination $Cart -Force }
}
foreach($pf in @($PROVA_M5,$PROVA_M15)){
  $srcProva = Join-Path $Prove $pf
  if(Test-Path -LiteralPath $srcProva){ Copy-Item $srcProva -Destination $Cart -Force }
}
foreach($c in $CORSE){
  foreach($leg in @("IS","OOS")){
    $f = Join-Path $Results ($EA + "_" + $c.Simbolo + "_" + $leg + "_ohlc_" + $c.Etichetta + ".csv")
    if(Test-Path -LiteralPath $f){ Copy-Item $f -Destination $Cart -Force }
  }
}
$zip = $Cart + ".zip"
Remove-Item -LiteralPath $zip -Force -ErrorAction SilentlyContinue
Compress-Archive -Path (Join-Path $Cart "*") -DestinationPath $zip -Force
Write-Host ""
Write-Host ("CARTELLA: " + $Cart) -ForegroundColor Green
Write-Host ("ZIP DA MANDARE: " + $zip) -ForegroundColor Green
Write-Host "FILE ATTESI NELLO ZIP: REFERTO_SONDARSIEMAV8.txt + i 2 prova + 7 CSV OPTFRAME (ABTG_SondaRsiEmaV8_<SIMBOLO>_IS_ohlc_<ETICHETTA>.csv, 2 righe l'uno = le 2 passate)" -ForegroundColor Gray
Write-Host ("CSV *_OOS trovati: " + $nOosTrovati + " (attesi 0: FrazioneIS 1.0 = gamba OOS degenere; il numero sta ANCHE nel referto).") -ForegroundColor Gray
Write-Host "      Il rosso del generico su quei file e' ATTESO: NON rilanciare." -ForegroundColor Gray
Write-Host "NOTA: nessun per-trade (zero ordini) e nessun CSV riga-per-segnale (ottimizzazione)." -ForegroundColor Gray

if($Fatale -ne ""){ Write-Host "ESITO: FERMATO" -ForegroundColor Red; exit 1 }
if($Problemi.Count -gt 0){ Write-Host "ESITO: COMPLETATO CON PROBLEMI" -ForegroundColor Yellow; exit 1 }
Write-Host ("ESITO: " + $Modo + " COMPLETATO") -ForegroundColor Green
exit 0
