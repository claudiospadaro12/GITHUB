# =====================================================================
#  MARCATORE_RIGA_SONDAM0PB_v2
#  RIGA_SONDAM0PB.ps1 -- SONDA DI FREQUENZA M0PB (PASSO 0 della caccia
#  frequenza del 31/08). ABTG_SondaM0PB e' un CONTATORE: NESSUN ordine,
#  nessun lotto, nessun magic, nessuna sedia. SEI CORSE in sequenza:
#    U30_M5   U30USD M5     prove\M0PB_FREQUENZA_M5.txt
#    U30_M15  U30USD M15    prove\M0PB_FREQUENZA_M15.txt
#    NAS_M5   NASUSD M5     (stesso prova M5,  -Simbolo override)
#    NAS_M15  NASUSD M15    (stesso prova M15, -Simbolo override)
#    DAX_M5   D30EUR M5     (stesso prova M5,  -Simbolo override)
#    DAX_M15  D30EUR M15    (stesso prova M15, -Simbolo override)
#  finestra 2024.09.26 -> 2026.06.30, MODELLO 2 ("Solo prezzi di
#  apertura": il segnale nasce su barra chiusa e non si apre niente --
#  il tick non aggiunge informazione e costa ore).
# ---------------------------------------------------------------------
#  LE SCELTE, DICHIARATE (sono nel prova, qui il riassunto):
#  - DUE file prova (M5/M15) identici salvo @PERIODO: il generico legge
#    @PERIODO dal prova e un override da fuori sarebbe stato nascosto.
#    Il gate qui sotto verifica il diff MECCANICAMENTE.
#  - TRE simboli con UN solo @SIMBOLO (il lead U30USD) + override
#    -Simbolo del generico per NASUSD e D30EUR: supportato (il
#    parametro vince sulla direttiva, walkforward_generico.ps1 righe
#    60 e 303) e DICHIARATO qui e nel referto.
#  - UNICO asse Y = InpModoPrezzoIngresso 1||0||1||1||Y -> 2 passate
#    INFORMATIVE (1 = apertura barra dopo, fedele al Pine, RIGA DEL
#    VERDETTO; 0 = chiusura barra segnale, sensibilita' al prezzo
#    d'ingresso GRATIS). Il generico rifiuta zero assi e la sonda non
#    ha magic da usare come gemelli. NON e' uno sweep del motore.
#  - InpStopAtrMult PINNATO a 2.75, NON sweepato: lo sweep e'
#    ARITMETICO (T10: RR(mult) = RR(2,75)*2,75/mult, l'ATR mediano
#    esce in colonna) e sweeparlo qui sarebbe pescare il
#    moltiplicatore che fa passare il cancello H8.
#  - CELLE CONTATE: 1 asse x 2 valori = 2 passate a corsa, 6 corse =
#    12 passate open-prices in tutto.
#
#  I TRE CANCELLI (congelati nel prova PRIMA dei numeri, per LATO):
#    F1  segnali/giorno >= 1,00           -> sotto: MORTO
#    F2  take mediano: VIVO solo > 7,0 punti idx; < 5,0 MORTO; 5,0-7,0
#        SOSPESO [SPREAD NON MISURATO, Code Base 74148 mai usato].
#        31/08: l'ambiguita' ">=6 passa / 5-7 sospeso" del criterio e'
#        sciolta verso la clausola PIU' SEVERA (classe nuova in checklist).
#    H8  RR da mediane  >= 0,70           -> sotto: MORTO PER ARITMETICA
#  Il verdetto di ogni corsa/lato esce AUTOMATICO nel referto, sulla
#  passata con Modo Prezzo Ingresso = 1.
#
#  >>> EA MAI COMPILATO: si compila QUI con l'.ex5 cancellato prima.
#      Se la compilazione FALLISCE, QUELLO e' il risultato del passo.
#      (Nessun include da installare: la sonda non ne ha.)
#  >>> CONTATORE PURO, PROVATO A MACCHINA: il gate qui sotto conta le
#      chiamate di trading nel sorgente FUORI dai commenti. Attese ZERO
#      (la riga di grep sta QUI e non nel .mq5, apposta: dentro il file
#      combacerebbe con se' stessa).
#  >>> UNA SOLA TRANCHE (FrazioneIS 1.0): la gamba "OOS" del generico
#      e' DEGENERE (0 giorni) e si IGNORA. Il rosso del generico sui
#      CSV *_OOS e' ATTESO: NON rilanciare.
#  >>> SUFFISSO "_ohlc" NEI NOMI CSV: il generico marca cosi' OGNI
#      modello diverso da 4. Qui si legge "non-tick" (Modello 2, open
#      prices), non "OHLC M1". Dichiarato, non un errore.
#  >>> TETTO ~100k BARRE DEL TESTER (regola 25/08): 21 mesi di M5
#      possono eccedere ~1,3 anni di tetto. NON si spezza: la sonda
#      dichiara da sola la finestra effettiva (Giorni Contati, Barre
#      Valutate) e la firma del tetto (checklist punto 36) e' Barre
#      Valutate IDENTICHE su simboli diversi: il referto la cerca.
#  >>> NESSUN per-trade CSV e NESSUN CSV riga-per-segnale in questo
#      giro: non ci sono ordini, e in ottimizzazione la sonda spegne
#      il CSV dei segnali (si sovrascriverebbero). I numeri stanno
#      nelle 48 colonne OPTFRAME.
#
#  QUANTO CI METTE [STIMA, non una previsione]: 12 passate open-prices
#  su ~21 mesi (M5/M15) + 6 avvii del terminale + 1 compilazione.
#  Una passata open-prices e' questione di secondi-minuti: stima
#  onesta 10-30 minuti per tutto il giro.
#
#  LA RIGA CHE SI INCOLLA sta in righe\RIGA_SONDAM0PB_DA_MANDARE.md
# =====================================================================
[CmdletBinding()]
param(
  # -Pin NON ha default: un default silenzioso ("lavoro") farebbe girare
  #  la punta del branch spacciandola per un commit congelato.
  [string]$Pin          = "",
  [switch]$SoloControllo,
  [string]$SoloCorsa    = "",            # etichetta singola (es. "U30_M5"); default: tutte e sei
  [string]$DaQuando     = "2024.09.26",  # pavimento MISURATO dei dati BCM sugli indici
  [string]$Fino         = "2026.06.30",  # dichiarata nei prova (@FINOA) e gattata
  [double]$FrazioneIS   = 1.0,           # finestra intera; la gamba OOS del generico e' degenere e si ignora
  [int]$Deposito        = 100000         # INERTE: la sonda non apre ordini. Sta qui perche' il generico lo vuole
)
$ErrorActionPreference = "Stop"
[Threading.Thread]::CurrentThread.CurrentCulture   = [Globalization.CultureInfo]::InvariantCulture
[Threading.Thread]::CurrentThread.CurrentUICulture = [Globalization.CultureInfo]::InvariantCulture
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$INV = [Globalization.CultureInfo]::InvariantCulture

$EA          = "ABTG_SondaM0PB"
$SimboloLead = "U30USD"
$Avvio   = Get-Date
$Stamp   = $Avvio.ToString("yyyyMMdd_HHmm", $INV)
$Dsk     = Join-Path $env:USERPROFILE "Desktop"
$Work    = Join-Path $env:USERPROFILE "abtg_sondam0pb"
$Prove   = Join-Path $Work "prove"
$RawPin  = "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$Pin"

# --- I CANCELLI, ricopiati dai #define della sonda (congelati la').
#     Se lassu' cambiano e qui no, il referto direbbe un'altra cosa dal
#     log della sonda: per questo il referto stampa ANCHE le soglie.
$SOGLIA_F1 = 1.00     # segnali/giorno per lato
$F2_BASSO  = 5.00     # take mediano, punti indice. Sotto 5,0: scarto secco.
$F2_ALTO   = 7.00     # 5,0-7,0: SOSPESO (spread non misurato); VIVO solo SOPRA 7,0.
                      # 31/08: l'ambiguita' del criterio (>=6 passa vs 5-7 sospeso)
                      # e' sciolta verso la clausola PIU' SEVERA, dichiarato.
$SOGLIA_H8 = 0.70     # RR da mediane
$AUTOTEST_BLOCCHI_ATTESI = 12
$NCelleCorsa = 2      # 1 asse (InpModoPrezzoIngresso) x 2 valori. CONTATE.

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
$Modo      = "CORSA"
if($SoloControllo){ $Modo = "CONTROLLO" }

# =====================================================================
#  LE SEI CORSE. Il prova e' per-TF; il simbolo va in -Simbolo (il
#  lead U30USD e' anche l'@SIMBOLO dei prova, gli altri due sono
#  override dichiarati).
# =====================================================================
function C([string]$et,[string]$sym,[string]$tf,[string]$prova){
  return [pscustomobject]@{ Etichetta=$et; Simbolo=$sym; Periodo=$tf; Prova=$prova
    Righe=$null; AutoKo=-2; AutoBlocchi=$null
    Giorni=$null; BarreVal=$null; RsiDiv=$null; AtrDiv=$null; PuntoIdx=$null; AtrMed=$null; StopMultEco=$null
    SigGgL=$null; SigGgS=$null; TakeL=$null; TakeS=$null; StopL=$null; StopS=$null
    RrL=$null; RrS=$null; WrL=$null; WrS=$null; MaxGgL=$null; MaxGgS=$null
    G1L=$null; G1S=$null; TakeNegL=$null; TakeNegS=$null; SegL=$null; SegS=$null
    Sens="n/d"; ContaOk="NON VERIFICATO"; VerdettoL="n/d"; VerdettoS="n/d" }
}
$PROVA_M5  = "M0PB_FREQUENZA_M5.txt"
$PROVA_M15 = "M0PB_FREQUENZA_M15.txt"
$CORSE = @()
$CORSE += (C "U30_M5"  "U30USD" "M5"  $PROVA_M5)
$CORSE += (C "U30_M15" "U30USD" "M15" $PROVA_M15)
$CORSE += (C "NAS_M5"  "NASUSD" "M5"  $PROVA_M5)
$CORSE += (C "NAS_M15" "NASUSD" "M15" $PROVA_M15)
$CORSE += (C "DAX_M5"  "D30EUR" "M5"  $PROVA_M5)
$CORSE += (C "DAX_M15" "D30EUR" "M15" $PROVA_M15)

# I FISSI attesi nei prova (primo campo prima di ||): TUTTI gli input
# della sonda, nome per nome, tranne l'asse Y. Un nome sbagliato qui
# sarebbe l'errore n.3 della checklist (MT5 ignora in silenzio).
$FissiAttesi = [ordered]@{ "InpRsiPeriod"="6"; "InpRsiHigh"="90.0"; "InpRsiLow"="10.0";
                  "InpEmaPeriod"="5"; "InpFinestraBarre"="6"; "InpBarreTarget"="12";
                  "InpAtrPeriod"="10"; "InpStopAtrMult"="2.75"; "InpAtrModoPine"="true";
                  "InpPuntiPerIndice"="100.0"; "InpUsaFinestraOraria"="false";
                  "InpOraInizioServer"="14"; "InpOraFineServer"="21";
                  "InpWarmupBarre"="300"; "InpConfrontaMT5"="true"; "InpScriviCsv"="true";
                  "InpVerbose"="true"; "InpAutoTest"="true"; "InpTag"="M0PB_SONDA" }
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
function FmtN($v){ if($null -eq $v){ return "n/d" }; return ([int]$v).ToString($INV) }
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

# il verdetto di un lato, coi tre cancelli congelati. Torna una stringa.
function Verdetto([double]$sigGg,[double]$take,[double]$rr){
  $morto = $false
  $sospeso = $false
  if($sigGg -lt $SOGLIA_F1){ $morto = $true }
  if($take -lt $F2_BASSO){ $morto = $true }
  elseif($take -le $F2_ALTO){ $sospeso = $true }
  if($rr -lt $SOGLIA_H8){ $morto = $true }
  if($morto){ return "MORTO" }
  if($sospeso){ return "SOSPESO (F2 nella fascia 5,0-7,0: SPREAD NON MISURATO, Code Base 74148)" }
  return "VIVO"
}

$CorseDaFare = @($CORSE)
if($SoloCorsa -ne ""){ $CorseDaFare = @($CORSE | Where-Object { $_.Etichetta -eq $SoloCorsa }) }

try{
  Titolo ("SONDA M0PB -- PASSO 0, CONTATORE (" + $EA + ") -- modo " + $Modo)

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
  Dico ("corse ....... " + @($CorseDaFare).Count + " su 6 (3 simboli x M5/M15), " + $NCelleCorsa + " passate a corsa (asse InpModoPrezzoIngresso 1|0)")
  Dico ("finestra .... " + $DaQuando + " -> " + $Fino + " (UNA TRANCHE, FrazioneIS " + $FrazioneIS + ")")
  Dico ("banco ....... MODELLO 2 (SOLO PREZZI DI APERTURA): contatore su barra chiusa, il tick non aggiunge niente. Deposito " + $Deposito + " (inerte: zero ordini)")
  Dico ("cancelli .... F1 >= " + (Fmt2 $SOGLIA_F1) + " segnali/gg per lato | F2 take mediano VIVO solo > " + (Fmt2 $F2_ALTO) + " punti idx (" + (Fmt2 $F2_BASSO) + "-" + (Fmt2 $F2_ALTO) + " sospeso) | H8 RR >= " + (Fmt2 $SOGLIA_H8)) "Yellow"
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
  Remove-Item -Path (Join-Path $Prove "M0PB_*.txt") -Force -ErrorAction SilentlyContinue

  foreach($f in @($PROVA_M5,$PROVA_M15)){
    Scarica ($RawPin + "/backtest_pipeline/prove/" + $f) (Join-Path $Prove $f)
  }
  Dico ("file prova scaricati: " + @(Get-ChildItem $Prove -Filter "M0PB_*.txt").Count + " su 2") "Green"

  # -------------------------------------------------------------------
  #  2. I GATE SUI DUE PROVA -- girano PRIMA di aprire MT5
  # -------------------------------------------------------------------
  Titolo "2. GATE SUI DUE PROVA (direttive nude + fissi + asse unico + gemellaggio M5/M15)"
  $letture = @{}
  foreach($pf in @($PROVA_M5,$PROVA_M15)){
    $lettura = LeggiProva (Join-Path $Prove $pf) $pf
    $letture[$pf] = $lettura
    $h    = $lettura.Mappa
    $assi = $lettura.Assi
    $tfAtteso = "M5"
    if($pf -eq $PROVA_M15){ $tfAtteso = "M15" }

    # LE QUATTRO DIRETTIVE, NUDE E GATTATE (commentate = gate vuoto = ci si ferma).
    if($h["@SIMBOLO"]  -ne $SimboloLead){ throw ($pf + ": @SIMBOLO e' '" + $h["@SIMBOLO"] + "', atteso il lead " + $SimboloLead + " (NASUSD e D30EUR girano con -Simbolo, override dichiarato)") }
    if($h["@PERIODO"]  -ne $tfAtteso){    throw ($pf + ": @PERIODO e' '" + $h["@PERIODO"] + "', atteso " + $tfAtteso) }
    if($h["@DAQUANDO"] -ne $DaQuando){    throw ($pf + ": @DAQUANDO e' '" + $h["@DAQUANDO"] + "', atteso " + $DaQuando + " (pavimento MISURATO dei dati BCM sugli indici)") }
    if($h["@FINOA"]    -ne $Fino){        throw ($pf + ": @FINOA e' '" + $h["@FINOA"] + "', atteso " + $Fino + " (la finestra si dichiara nel prova, non si eredita dal default del generico)") }

    # UNICO ASSE Y = InpModoPrezzoIngresso, coi valori esatti 1||0||1||1||Y.
    if(@($assi).Count -ne 1){ throw ($pf + ": deve avere ESATTAMENTE un asse Y (" + $AsseAtteso + "). Trovati: " + @($assi).Count + " {" + (@($assi) -join ", ") + "}.") }
    if($assi[0] -ne $AsseAtteso){ throw ($pf + ": l'unico asse Y deve essere " + $AsseAtteso + ", invece e' " + $assi[0] + ".") }
    if($h[$AsseAtteso] -ne $AsseValore){ throw ($pf + ": " + $AsseAtteso + " e' '" + $h[$AsseAtteso] + "', atteso '" + $AsseValore + "' (2 passate: 1 = fedele al Pine / verdetto, 0 = sensibilita').") }

    # I FISSI, nome per nome (l'errore n.3 della checklist: MT5 ignora
    # in silenzio un pin che non trova, e la sonda ha ESATTAMENTE
    # questi 20 input).
    foreach($k in @($FissiAttesi.Keys)){
      if(-not $h.ContainsKey($k)){ throw ($pf + ": manca la riga '" + $k + "' (fisso dichiarato: va verificabile nell'.ini).") }
      $v = ($h[$k] -split '\|\|')[0]
      if($v -ne $FissiAttesi[$k]){ throw ($pf + ": " + $k + " e' '" + $v + "', atteso '" + $FissiAttesi[$k] + "'.") }
    }
    # niente righe estranee: 4 direttive + 19 fissi + 1 asse = 24.
    $attese = 4 + @($FissiAttesi.Keys).Count + 1
    if(@($h.Keys).Count -ne $attese){
      throw ($pf + ": " + @($h.Keys).Count + " righe vive invece di " + $attese + ": c'e' una riga estranea o ne manca una.")
    }
    # lo stop NON deve essere un asse (T10: lo sweep e' aritmetico).
    if($h["InpStopAtrMult"] -match '\|\|Y\s*$'){ throw ($pf + ": InpStopAtrMult NON va sweepato (T10: aritmetico). Va pinnato a 2.75.") }
  }
  Dico "gate per prova: direttive nude 4/4, 1 asse Y con valori esatti, 20 input pinnati nome per nome, nessuna riga estranea: PASSATI" "Green"

  # GEMELLAGGIO M5/M15: le righe vive dei due prova devono differire
  # SOLO per @PERIODO. Confronto PER NOME sulle mappe complete.
  $hA = $letture[$PROVA_M5].Mappa
  $hB = $letture[$PROVA_M15].Mappa
  foreach($k in @($hA.Keys)){
    if(-not $hB.ContainsKey($k)){ throw ("GEMELLAGGIO NON VALIDO: " + $PROVA_M5 + " ha la riga '" + $k + "' che la gemella non ha.") }
  }
  foreach($k in @($hB.Keys)){
    if(-not $hA.ContainsKey($k)){ throw ("GEMELLAGGIO NON VALIDO: " + $PROVA_M15 + " ha la riga '" + $k + "' che la gemella non ha.") }
  }
  foreach($k in @($hA.Keys)){
    if($k -eq "@PERIODO"){ continue }
    if($hA[$k] -ne $hB[$k]){ throw ("GEMELLAGGIO NON VALIDO: '" + $k + "' differisce fra i due prova ('" + $hA[$k] + "' contro '" + $hB[$k] + "') e NON e' @PERIODO. Cosi' M5 e M15 misurerebbero due cose diverse.") }
  }
  if($hA["@PERIODO"] -eq $hB["@PERIODO"]){ throw "GEMELLAGGIO NON VALIDO: @PERIODO DOVEVA differire fra i due prova e invece e' identico." }
  $Gemelle = "VALIDO: le righe vive differiscono SOLO per @PERIODO (" + $hA["@PERIODO"] + " contro " + $hB["@PERIODO"] + ")"
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
  #  4. LE SEI CORSE -- il generico una volta per corsa
  # -------------------------------------------------------------------
  Titolo ("4. LE CORSE (generico per corsa, Modello 2 OPEN PRICES, FrazioneIS " + $FrazioneIS + ")")
  foreach($c in $CorseDaFare){
    $override = ""
    if($c.Simbolo -ne $SimboloLead){ $override = " [OVERRIDE -Simbolo: il prova dichiara il lead " + $SimboloLead + "]" }
    Dico ("CORSA " + $c.Etichetta + " | " + $c.Simbolo + " " + $c.Periodo + " | " + $c.Prova + $override) "Cyan"
    # "-Rifai" sta SEMPRE nell'argv: la classe skip-senza-Rifai ha
    # prodotto 4 corse zombie su 6 nella saga CRT.
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
    $global:LASTEXITCODE = 0
    & powershell $argv
    $rc = $LASTEXITCODE
    if($rc -ne 0){
      [void]$Problemi.Add("corsa " + $c.Etichetta + ": il generico e' uscito con codice " + $rc + " (storico mancante? CSV non prodotto? Il rosso sul *_OOS invece e' ATTESO con FrazioneIS 1.0).")
    }
    if($SoloControllo){ continue }

    # IL CSV DELLA CORSA SI CONTA, NON SI Test-Path: 2 righe (le due
    # passate dell'asse), colonne per NOME, autotest a 0.
    # Modello != 4 -> suffisso "_ohlc" + etichetta (marca "non-tick").
    $csvIS = Join-Path $Work ("risultati_prove\" + $EA + "\" + $EA + "_" + $c.Simbolo + "_IS_ohlc_" + $c.Etichetta + ".csv")
    if(-not (Test-Path -LiteralPath $csvIS)){
      [void]$Problemi.Add("corsa " + $c.Etichetta + ": CSV OPTFRAME NON prodotto: " + $csvIS)
      continue
    }
    $lin = @(Get-Content -LiteralPath $csvIS | Where-Object { $_.Trim() -ne "" })
    $nRighe = $lin.Count - 1
    if($nRighe -lt 0){ $nRighe = 0 }
    $c.Righe = $nRighe
    if($nRighe -ne $NCelleCorsa){
      [void]$Problemi.Add("corsa " + $c.Etichetta + ": " + $nRighe + " righe nel CSV, " + $NCelleCorsa + " passate chieste (cache? storico?).")
    }
    if($nRighe -le 0){ continue }

    $head = $lin[0] -split ','
    $ix = @{}
    for($i2=0;$i2 -lt $head.Count;$i2++){ $ix[$head[$i2].Trim()] = $i2 }
    $servono = @("Segnali Long","Segnali Short","Giorni Contati",
                 "Segnali Long Al Giorno","Segnali Short Al Giorno",
                 "Take Mediano Long Punti Indice","Take Mediano Short Punti Indice",
                 "Stop Mediano Long Punti Indice","Stop Mediano Short Punti Indice",
                 "RR Da Mediane Long","RR Da Mediane Short",
                 "Win Rate Necessario Long Pct","Win Rate Necessario Short Pct",
                 "Max Segnali Giorno Long","Max Segnali Giorno Short",
                 "Giorni Almeno 1 Long","Giorni Almeno 1 Short",
                 "Take Non Positivi Long","Take Non Positivi Short",
                 "Atr Mediano Punti Indice","Barre Valutate",
                 "Rsi Divergenza Max","Atr Divergenza Rel Media Pct",
                 "Punto Indice Prezzo","Stop Atr Mult","Modo Prezzo Ingresso",
                 "Autotest Falliti","Autotest Blocchi")
    $manca = New-Object System.Collections.ArrayList
    foreach($cName in $servono){ if(-not $ix.ContainsKey($cName)){ [void]$manca.Add($cName) } }
    if($manca.Count -gt 0){
      [void]$Problemi.Add("corsa " + $c.Etichetta + ": nel CSV mancano le colonne: " + ($manca -join ", ") + " (header OPTFRAME cambiato nella sonda?).")
      continue
    }
    $maxIx = 0
    foreach($cName in $servono){ if($ix[$cName] -gt $maxIx){ $maxIx = $ix[$cName] } }
    function LeggiCella($cols,[string]$nome){ return (Num $cols[$ix[$nome]]) }
    $righeDati = New-Object System.Collections.ArrayList
    for($i2=1;$i2 -lt $lin.Count;$i2++){
      $cols = $lin[$i2] -split ','
      if($cols.Count -le $maxIx){ continue }
      [void]$righeDati.Add($cols)
    }
    $rigaVerdetto = $null
    $rigaSens     = $null
    foreach($cols in $righeDati){
      $modoRiga = LeggiCella $cols "Modo Prezzo Ingresso"
      if([math]::Abs($modoRiga - 1.0) -lt 0.001){ $rigaVerdetto = $cols } else { $rigaSens = $cols }
    }
    if($null -eq $rigaVerdetto){
      [void]$Problemi.Add("corsa " + $c.Etichetta + ": nessuna passata con Modo Prezzo Ingresso = 1 (la riga del verdetto): CSV non leggibile.")
      continue
    }

    # la riga del verdetto (modo 1, fedele al Pine)
    $c.SegL     = LeggiCella $rigaVerdetto "Segnali Long"
    $c.SegS     = LeggiCella $rigaVerdetto "Segnali Short"
    $c.Giorni   = LeggiCella $rigaVerdetto "Giorni Contati"
    $c.SigGgL   = LeggiCella $rigaVerdetto "Segnali Long Al Giorno"
    $c.SigGgS   = LeggiCella $rigaVerdetto "Segnali Short Al Giorno"
    $c.TakeL    = LeggiCella $rigaVerdetto "Take Mediano Long Punti Indice"
    $c.TakeS    = LeggiCella $rigaVerdetto "Take Mediano Short Punti Indice"
    $c.StopL    = LeggiCella $rigaVerdetto "Stop Mediano Long Punti Indice"
    $c.StopS    = LeggiCella $rigaVerdetto "Stop Mediano Short Punti Indice"
    $c.RrL      = LeggiCella $rigaVerdetto "RR Da Mediane Long"
    $c.RrS      = LeggiCella $rigaVerdetto "RR Da Mediane Short"
    $c.WrL      = LeggiCella $rigaVerdetto "Win Rate Necessario Long Pct"
    $c.WrS      = LeggiCella $rigaVerdetto "Win Rate Necessario Short Pct"
    $c.MaxGgL   = LeggiCella $rigaVerdetto "Max Segnali Giorno Long"
    $c.MaxGgS   = LeggiCella $rigaVerdetto "Max Segnali Giorno Short"
    $c.G1L      = LeggiCella $rigaVerdetto "Giorni Almeno 1 Long"
    $c.G1S      = LeggiCella $rigaVerdetto "Giorni Almeno 1 Short"
    $c.TakeNegL = LeggiCella $rigaVerdetto "Take Non Positivi Long"
    $c.TakeNegS = LeggiCella $rigaVerdetto "Take Non Positivi Short"
    $c.AtrMed   = LeggiCella $rigaVerdetto "Atr Mediano Punti Indice"
    $c.BarreVal = LeggiCella $rigaVerdetto "Barre Valutate"
    $c.RsiDiv   = LeggiCella $rigaVerdetto "Rsi Divergenza Max"
    $c.AtrDiv   = LeggiCella $rigaVerdetto "Atr Divergenza Rel Media Pct"
    $c.PuntoIdx = LeggiCella $rigaVerdetto "Punto Indice Prezzo"
    $c.StopMultEco = LeggiCella $rigaVerdetto "Stop Atr Mult"
    $c.AutoKo      = [int](LeggiCella $rigaVerdetto "Autotest Falliti")
    $c.AutoBlocchi = [int](LeggiCella $rigaVerdetto "Autotest Blocchi")

    # COLLAUDI: si verificano PRIMA di leggere qualunque numero.
    if($c.AutoKo -eq -1){ [void]$Problemi.Add("corsa " + $c.Etichetta + ": Autotest Falliti = -1 (autotest NON girato): file invalido per i criteri del prova.") }
    elseif($c.AutoKo -gt 0){ [void]$Problemi.Add("corsa " + $c.Etichetta + ": Autotest Falliti = " + $c.AutoKo + ": la sonda DIVERGE dalla spec, i numeri NON si leggono.") }
    if($c.AutoBlocchi -ne $AUTOTEST_BLOCCHI_ATTESI -and $c.AutoKo -ge 0){
      [void]$Rilievi.Add("corsa " + $c.Etichetta + ": Autotest Blocchi = " + $c.AutoBlocchi + " invece di " + $AUTOTEST_BLOCCHI_ATTESI + " (sonda diversa da quella attesa?).")
    }
    if($c.RsiDiv -gt 0.001){ [void]$Problemi.Add("corsa " + $c.Etichetta + ": Rsi Divergenza Max = " + (Fmt3 $c.RsiDiv) + " (atteso ~0, T1): la traduzione dell'RSI diverge da iRSI, i numeri non valgono.") }
    if($c.AtrDiv -lt 0.0001){ [void]$Rilievi.Add("corsa " + $c.Etichetta + ": Atr Divergenza Rel Media Pct ~ 0 con ATR alla Pine: ATTESA NON ZERO (T3). O il collaudo non ha misurato, o T3 e' sospetta.") }
    if([math]::Abs($c.PuntoIdx - 1.0) -gt 0.001){ [void]$Problemi.Add("corsa " + $c.Etichetta + ": Punto Indice Prezzo = " + (Fmt3 $c.PuntoIdx) + " invece di 1,00 (T8): la TAGLIA e' sbagliata di un fattore, F2 non si legge.") }
    if([math]::Abs($c.StopMultEco - 2.75) -gt 0.001){ [void]$Problemi.Add("corsa " + $c.Etichetta + ": eco Stop Atr Mult = " + (Fmt3 $c.StopMultEco) + " invece di 2,75: il pin non e' passato.") }

    # LE DUE PASSATE DEVONO CONTARE GLI STESSI SEGNALI E GIORNI: il
    # modo del prezzo d'ingresso non tocca il conteggio. Se differisce,
    # il banco non e' deterministico o la logica e' sporca.
    if($null -ne $rigaSens){
      $sL0 = LeggiCella $rigaSens "Segnali Long"
      $sS0 = LeggiCella $rigaSens "Segnali Short"
      $gg0 = LeggiCella $rigaSens "Giorni Contati"
      if($sL0 -ne $c.SegL -or $sS0 -ne $c.SegS -or $gg0 -ne $c.Giorni){
        $c.ContaOk = "DIVERGENTI"
        [void]$Problemi.Add("corsa " + $c.Etichetta + ": le due passate contano segnali/giorni DIVERSI (L " + (FmtN $c.SegL) + "/" + (FmtN $sL0) + ", S " + (FmtN $c.SegS) + "/" + (FmtN $sS0) + ", gg " + (FmtN $c.Giorni) + "/" + (FmtN $gg0) + "): il conteggio non e' deterministico.")
      } else { $c.ContaOk = "IDENTICI" }
      $tL0 = LeggiCella $rigaSens "Take Mediano Long Punti Indice"
      $tS0 = LeggiCella $rigaSens "Take Mediano Short Punti Indice"
      $c.Sens = "take mediano modo0 (chiusura): L " + (Fmt2 $tL0) + " / S " + (Fmt2 $tS0) + " contro modo1 (apertura): L " + (Fmt2 $c.TakeL) + " / S " + (Fmt2 $c.TakeS)
    } else {
      $c.ContaOk = "NON VERIFICABILE (manca la passata modo 0)"
      [void]$Problemi.Add("corsa " + $c.Etichetta + ": manca la passata con Modo Prezzo Ingresso = 0: sensibilita' non misurata e conteggio non incrociato.")
    }

    # IL VERDETTO AUTOMATICO, PER LATO, coi tre cancelli congelati.
    $c.VerdettoL = Verdetto $c.SigGgL $c.TakeL $c.RrL
    $c.VerdettoS = Verdetto $c.SigGgS $c.TakeS $c.RrS
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
    # M5 contro M15 sullo stesso simbolo: se M5 conta molti meno giorni,
    # la finestra M5 e' troncata (tetto) e va dichiarata.
    foreach($sym in @("U30USD","NASUSD","D30EUR")){
      $c5  = $CORSE | Where-Object { $_.Simbolo -eq $sym -and $_.Periodo -eq "M5"  } | Select-Object -First 1
      $c15 = $CORSE | Where-Object { $_.Simbolo -eq $sym -and $_.Periodo -eq "M15" } | Select-Object -First 1
      if($null -ne $c5 -and $null -ne $c15 -and $null -ne $c5.Giorni -and $null -ne $c15.Giorni -and $c15.Giorni -gt 0){
        if($c5.Giorni -lt 0.9*$c15.Giorni){
          [void]$Rilievi.Add("TETTO su " + $sym + " M5: " + (FmtN $c5.Giorni) + " giorni contati contro " + (FmtN $c15.Giorni) + " a M15. La corsa M5 copre una finestra EFFETTIVA piu' corta: F1 resta per-giorno (leggibile), il campione e il regime coperto vanno dichiarati nel referto di lettura.")
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
$Cart = Join-Path $Dsk ("SONDAM0PB_" + $Modo + "_" + $Stamp)
New-Item -ItemType Directory -Force -Path $Cart | Out-Null

$RefTxt = New-Object System.Collections.ArrayList
[void]$RefTxt.Add("=====================================================================")
[void]$RefTxt.Add(" SONDA M0PB -- PASSO 0, CONTATORE DI FREQUENZA E TAGLIA (" + $EA + ")")
[void]$RefTxt.Add(" 3 simboli (U30USD, NASUSD, D30EUR) x 2 TF (M5, M15) -- NESSUN ORDINE")
[void]$RefTxt.Add("=====================================================================")
[void]$RefTxt.Add("modo: " + $Modo + "   <- CONTROLLO = giro a vuoto, NON e' il risultato")
[void]$RefTxt.Add("data: " + $Avvio.ToString("yyyy-MM-dd HH:mm:ss",$INV))
[void]$RefTxt.Add("pin:  " + $Pin)
[void]$RefTxt.Add("finestra: " + $DaQuando + " -> " + $Fino + "  (UNA TRANCHE, FrazioneIS " + $FrazioneIS + ")")
[void]$RefTxt.Add("banco: MODELLO 2 (SOLO PREZZI DI APERTURA). Il segnale nasce su barra chiusa e non si apre niente: il tick non aggiunge informazione. I CSV portano il suffisso _ohlc (marca del generico per ogni modello non-tick).")
[void]$RefTxt.Add("terminale: " + $Terminale)
[void]$RefTxt.Add("compilazione: " + $Compilato + "   <- EA NUOVO: se e' FALLITA, QUESTO e' il risultato del passo")
[void]$RefTxt.Add("cache tester: " + $CacheTxt)
[void]$RefTxt.Add("grep contatore puro: " + $GrepTxt)
[void]$RefTxt.Add("gemellaggio prova M5/M15: " + $Gemelle)
[void]$RefTxt.Add("override simboli: @SIMBOLO dei prova = " + $SimboloLead + " (lead); NASUSD e D30EUR girano con -Simbolo del generico (il parametro vince sulla direttiva). DICHIARATO, non nascosto.")
[void]$RefTxt.Add("")
[void]$RefTxt.Add("--- I TRE CANCELLI (congelati PRIMA dei numeri; verdetto sulla passata Modo Prezzo Ingresso = 1) ---")
[void]$RefTxt.Add("  F1 segnali/giorno per lato >= " + (Fmt2 $SOGLIA_F1) + "   | F2 take mediano VIVO solo > " + (Fmt2 $F2_ALTO) + " punti indice")
[void]$RefTxt.Add("  (F2: < " + (Fmt2 $F2_BASSO) + " scarto; " + (Fmt2 $F2_BASSO) + "-" + (Fmt2 $F2_ALTO) + " sospeso [SPREAD NON MISURATO, Code Base 74148 mai usato]; ambiguita' sciolta verso la clausola piu' severa, 31/08)")
[void]$RefTxt.Add("  H8 RR da mediane >= " + (Fmt2 $SOGLIA_H8) + " (FIRMA 2 del 31/08: sotto = MORTO PER ARITMETICA, niente corsa a tick)")
[void]$RefTxt.Add("")
[void]$RefTxt.Add("--- LA TABELLA DEI CANCELLI, PER CORSA E PER LATO (mai aggregati) ---")
[void]$RefTxt.Add(("{0,-8} {1,-6} {2,8} {3,9} {4,9} {5,7} {6,8} {7,7} {8,8}  {9}" -f "corsa","lato","sig/gg","take med","stop med","RR","WRnec %","max/gg","take<=0","VERDETTO"))
foreach($c in $CORSE){
  if($null -eq $c.SigGgL){
    [void]$RefTxt.Add(("{0,-8} {1,-6} " -f $c.Etichetta,"-") + "SENZA NUMERI (corsa non girata o CSV non letto)")
    continue
  }
  [void]$RefTxt.Add(("{0,-8} {1,-6} {2,8} {3,9} {4,9} {5,7} {6,8} {7,7} {8,8}  {9}" -f $c.Etichetta,"LONG", (Fmt3 $c.SigGgL), (Fmt2 $c.TakeL), (Fmt2 $c.StopL), (Fmt3 $c.RrL), (Fmt2 $c.WrL), (FmtN $c.MaxGgL), (FmtN $c.TakeNegL), $c.VerdettoL))
  [void]$RefTxt.Add(("{0,-8} {1,-6} {2,8} {3,9} {4,9} {5,7} {6,8} {7,7} {8,8}  {9}" -f "","SHORT", (Fmt3 $c.SigGgS), (Fmt2 $c.TakeS), (Fmt2 $c.StopS), (Fmt3 $c.RrS), (Fmt2 $c.WrS), (FmtN $c.MaxGgS), (FmtN $c.TakeNegS), $c.VerdettoS))
  [void]$RefTxt.Add("         segnali L/S " + (FmtN $c.SegL) + "/" + (FmtN $c.SegS) + " su " + (FmtN $c.Giorni) + " giorni contati | giorni con >=1: L " + (FmtN $c.G1L) + " S " + (FmtN $c.G1S) + " | ATR mediano " + (Fmt2 $c.AtrMed) + " punti idx")
  [void]$RefTxt.Add("         sensibilita' ingresso: " + $c.Sens + " | conteggi fra le 2 passate: " + $c.ContaOk)
}
[void]$RefTxt.Add("")
[void]$RefTxt.Add("--- I COLLAUDI, PER CORSA (si leggono PRIMA dei numeri) ---")
[void]$RefTxt.Add(("{0,-8} {1,6} {2,14} {3,12} {4,12} {5,10} {6,12} {7,10}" -f "corsa","righe","autotest","RsiDivMax","AtrDiv %","PuntoIdx","BarreVal","eco mult"))
foreach($c in $CORSE){
  $at = "n/d"
  if($c.AutoKo -eq 0){ $at = "0/" + (FmtN $c.AutoBlocchi) + " PASSATI" }
  elseif($c.AutoKo -gt 0){ $at = "" + $c.AutoKo + " FALLITI" }
  elseif($c.AutoKo -eq -1){ $at = "-1 NON GIRATO" }
  [void]$RefTxt.Add(("{0,-8} {1,6} {2,14} {3,12} {4,12} {5,10} {6,12} {7,10}" -f $c.Etichetta, (FmtN $c.Righe), $at, (Fmt3 $c.RsiDiv), (Fmt3 $c.AtrDiv), (Fmt3 $c.PuntoIdx), (FmtN $c.BarreVal), (Fmt2 $c.StopMultEco)))
}
[void]$RefTxt.Add("  attesi: righe 2 | autotest 0/" + $AUTOTEST_BLOCCHI_ATTESI + " | RsiDivMax ~0 (T1) | AtrDiv NON zero (T3, ATR alla Pine) | PuntoIdx 1,000 (T8)")
[void]$RefTxt.Add("")
[void]$RefTxt.Add("--- LE NOTE CHE VANNO LETTE INSIEME AI NUMERI ---")
[void]$RefTxt.Add("  - T10, SWEEP ARITMETICO: lo stop e' mult x ATR, quindi RR(mult) = RR(2,75) * 2,75 / mult.")
[void]$RefTxt.Add("    Con l'ATR mediano in tabella l'RR di QUALUNQUE moltiplicatore si ricalcola a mano:")
[void]$RefTxt.Add("    nessuno sweep di InpStopAtrMult va lanciato, e SOPRATTUTTO non per pescare il mult che")
[void]$RefTxt.Add("    fa passare il cancello (stringere lo stop = piu' stop presi, costo che la sonda non vede).")
[void]$RefTxt.Add("  - T2: il take misurato al segnale e' un LIMITE SUPERIORE (il target vero puo' solo scendere).")
[void]$RefTxt.Add("    F2 e' quindi conservativo NEL VERSO GIUSTO: boccia solo cio' che merita.")
[void]$RefTxt.Add("  - TETTO BARRE: se i RILIEVI segnalano la firma del tetto su M5, la finestra effettiva M5 e'")
[void]$RefTxt.Add("    piu' corta di quella chiesta. F1 resta per-giorno (leggibile); campione e regime si dichiarano.")
[void]$RefTxt.Add("  - Nessun per-trade CSV e nessun CSV riga-per-segnale: corsa in ottimizzazione, zero ordini.")
[void]$RefTxt.Add("    I numeri stanno SOLO nelle colonne OPTFRAME (48) dei CSV *_IS_ohlc_*.")
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
[void]$RefTxt.Add('COME SI RIPRENDE: dalla pagina righe/RIGA_SONDAM0PB_DA_MANDARE.md, NON da')
[void]$RefTxt.Add('questa riga: $Pin nasce dentro il blocco e non sopravvive.')

$refPath = Join-Path $Cart "REFERTO_SONDAM0PB.txt"
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
$Results = Join-Path $Work ("risultati_prove\" + $EA)
$nOosTrovati = 0
foreach($c in $CORSE){
  foreach($leg in @("IS","OOS")){
    $f = Join-Path $Results ($EA + "_" + $c.Simbolo + "_" + $leg + "_ohlc_" + $c.Etichetta + ".csv")
    if(Test-Path -LiteralPath $f){
      Copy-Item $f -Destination $Cart -Force
      if($leg -eq "OOS"){ $nOosTrovati++ }
    }
  }
}
$zip = $Cart + ".zip"
Remove-Item -LiteralPath $zip -Force -ErrorAction SilentlyContinue
Compress-Archive -Path (Join-Path $Cart "*") -DestinationPath $zip -Force
Write-Host ""
Write-Host ("CARTELLA: " + $Cart) -ForegroundColor Green
Write-Host ("ZIP DA MANDARE: " + $zip) -ForegroundColor Green
Write-Host "FILE ATTESI NELLO ZIP: REFERTO_SONDAM0PB.txt + i 2 prova + 6 CSV OPTFRAME (ABTG_SondaM0PB_<SIMBOLO>_IS_ohlc_<ETICHETTA>.csv, 2 righe l'uno = le 2 passate)" -ForegroundColor Gray
Write-Host ("CSV *_OOS trovati: " + $nOosTrovati + " (attesi 0: FrazioneIS 1.0 = gamba OOS degenere).") -ForegroundColor Gray
Write-Host "      Il rosso del generico su quei file e' ATTESO: NON rilanciare." -ForegroundColor Gray
if($nOosTrovati -gt 0){
  Write-Host ("RILIEVO: " + $nOosTrovati + " CSV *_OOS esistono NONOSTANTE la gamba degenere: numeri su finestra NON dichiarata, NON leggerli. Sono nello zip solo come reperto.") -ForegroundColor Yellow
}
Write-Host "NOTA: nessun per-trade (zero ordini) e nessun CSV riga-per-segnale (ottimizzazione)." -ForegroundColor Gray

if($Fatale -ne ""){ Write-Host "ESITO: FERMATO" -ForegroundColor Red; exit 1 }
if($Problemi.Count -gt 0){ Write-Host "ESITO: COMPLETATO CON PROBLEMI" -ForegroundColor Yellow; exit 1 }
Write-Host ("ESITO: " + $Modo + " COMPLETATO") -ForegroundColor Green
exit 0
