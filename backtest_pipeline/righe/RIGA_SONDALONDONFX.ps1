# =====================================================================
#  MARCATORE_RIGA_SONDALONDONFX_v4
#  RIGA_SONDALONDONFX.ps1 -- SONDA DI FREQUENZA LONDONFX (PASSO 0 della
#  caccia frequenza forex, SECONDA BATTUTA del 31/08).
#  ABTG_SondaLondonFx e' un CONTATORE: NESSUN ordine, nessun lotto,
#  nessun magic, nessuna sedia. DUE CORSE in sequenza, sullo STESSO
#  simbolo (-Simbolo, default il lead EURUSD):
#    <PFX>_M5   <SIM> M5    prove\LONDONFX_FREQUENZA_M5.txt
#    <PFX>_M15  <SIM> M15   prove\LONDONFX_FREQUENZA_M15.txt
#  dove <PFX> sono le prime 3 lettere del simbolo (EUR_M5/EUR_M15 su
#  EURUSD, GBP_M5/GBP_M15 su GBPUSD): l'etichetta entra nel NOME del
#  CSV, quindi due simboli non si sovrascrivono MAI.
#  finestra 2024.09.26 -> 2026.06.30, MODELLO 2 ("Solo prezzi di
#  apertura": il segnale nasce su barra chiusa e non si apre niente --
#  il tick non aggiunge informazione e costa ore).
# ---------------------------------------------------------------------
#  LE SCELTE, DICHIARATE (sono nel prova, qui il riassunto):
#  - UN SIMBOLO PER GIRO, e il simbolo si DICHIARA (v4, 03/09): il
#    default e' EURUSD, il lead del candidato (il simbolo dell'autore,
#    ed e' la corsa gia' fatta il 03/09 alle 08:56). GBPUSD gira come
#    CORSA GEMELLA passando -Simbolo GBPUSD: e' l'override -Simbolo
#    del generico, PREVISTO DAL PROVA ("GBPUSD e USDJPY girano con
#    -Simbolo del generico ... il parametro -Simbolo vince sulla
#    direttiva", par. DOVE GIRA) e supportato dal generico alle righe
#    303-305 (la direttiva @SIMBOLO si legge SOLO se il parametro e'
#    vuoto). I DUE PROVA RESTANO DICHIARATI SUL LEAD e il gate qui
#    sotto PRETENDE @SIMBOLO = EURUSD anche nella corsa GBPUSD: la
#    dichiarazione sta nel prova, l'override sta nella riga, e il
#    referto stampa TUTTI E DUE in chiaro. Pattern gia' di casa,
#    dichiarato nel referto della sonda V8.
#  - USDJPY NON puo' MAI cavalcare questo prova: la sonda RIFIUTA DI
#    PARTIRE se InpPipSize non combacia col pip del simbolo (0.01 per
#    JPY, qui e' pinnato 0.0001) -- e' VOLUTO: meglio un init fallito
#    che una taglia sbagliata di 100 volte letta come buona. La gamba
#    JPY e' un GIRO SEPARATO con un prova suo. Per non far scoprire
#    quel muro DOPO due avvii del terminale, il driver ha una
#    WHITELIST (EURUSD, GBPUSD) e si ferma PRIMA di toccare qualunque
#    cosa, dicendo perche'.
#  - DUE file prova (M5/M15) gemelli: il generico legge @PERIODO dal
#    prova e un override da fuori sarebbe stato nascosto. Le righe
#    vive differiscono per ESATTAMENTE DUE nomi, tutti e due dichiarati
#    nel prova e gattati qui sotto MECCANICAMENTE:
#      @PERIODO               M5  contro M15
#      InpBarreOrizzonteLungo 96  contro 32   (e' definito in ORE, 8:
#                             96 barre M5 = 32 barre M15 = 8 ore.
#                             Il SIGNIFICATO e' costante, il numero no.)
#    Qualunque TERZA differenza, o una delle due mancante, FERMA tutto.
#  - DUE assi Y, entrambi dal prova e nessuno decorativo:
#      InpUsaRsi          true||false||1||true||Y  -> 2 valori
#        (ablazione F1-bis: l'autore dichiara l'RSI OPZIONALE; e in
#        piu' e' un GATE DI DETERMINISMO, perche' le colonne Nudo /
#        Con Rsi non devono muoversi fra le due passate)
#      InpOraInizioServer 6||4||2||8||Y            -> 3 valori (4/6/8)
#        (F7: il fuso del Pine e' INCERTO -- UTC o New York -- e l'ora
#        NON si converte a tavolino: si sweepa. Attesa dichiarata: la
#        cella 8 e' la lettura New York = sessione di Londra esatta.)
#    CELLE CONTATE COME LE CONTA IL GENERICO (Floor(|stop-start|/step)
#    +1 per asse, prodotto): 2 x 3 = 6 passate a corsa, 12 in tutto.
#    Il conteggio qui sotto viene RIFATTO sui pin ||Y scaricati al pin:
#    se un prova cambia, il numero atteso si muove e il gate lo dice.
#  - NESSUNA CELLA VIENE PROMOSSA: il criterio di ottimizzazione della
#    sonda e' il conteggio dei segnali e vincerebbe SEMPRE la passata
#    con l'RSI SPENTO (il ramo di CONTROLLO dell'ablazione). Si
#    LEGGONO le colonne, riga per riga.
#
#  I CANCELLI (congelati nel prova PRIMA dei numeri, per LATO; le
#  DISUGUAGLIANZE sono ricopiate da VerdettoF1/F2/H8_Calc del sorgente,
#  che l'autotest della sonda esegue su una cella di OGNI fascia):
#    F1  segnali/giorno >= 1,00                  -> sotto: MORTO
#    F2  MFE mediana a 12 barre, in PIP:
#          <  3,00 pip           -> MORTO
#          >= 3,00 e <= 6,00 pip -> SOSPESO [SPREAD NON MISURATO,
#                                   Code Base 74148 mai usato]
#          >  6,00 pip           -> PASSA
#        (fascia coperta da due bullet nella bozza, SCIOLTA verso la
#        clausola PIU' SEVERA -- dichiarato nel prova e CABLATO in
#        VerdettoF2_Calc)
#    H8  RR da mediane >= 0,70                   -> sotto: MORTO PER
#        ARITMETICA (FIRMA 2 del 31/08, E >= 0,075R)
#  Il verdetto esce AUTOMATICO nel referto, PER RIGA (UsaRsi x Ora) e
#  PER LATO: nessuna aggregazione, nessuna promozione.
#
#  >>> EA MAI COMPILATO: si compila QUI con l'.ex5 cancellato prima.
#      Se la compilazione FALLISCE, QUELLO e' il risultato del passo.
#      (Nessun include da installare: la sonda non ne ha.)
#  >>> CONTATORE PURO, PROVATO A MACCHINA: il gate qui sotto conta le
#      chiamate di trading nel sorgente FUORI dai commenti. Attese ZERO
#      (la riga di grep sta QUI e non nel .mq5, apposta: dentro il file
#      combacerebbe con se' stessa).
#  >>> IL CSV SI DATA PRIMA DI LEGGERLO (v2, difetto trovato dal
#      verificatore ESEGUENDO, 31/08): la workdir e' RIUSABILE e non si
#      svuota. "-Rifai" (che c'e', ed e' obbligatorio) copre il generico
#      che SALTA la corsa, NON il generico che MUORE prima di rifarla --
#      e se muore, il CSV della corsa PRECEDENTE resta dov'era. Riprodotto
#      su banco: il referto usciva con tabella completa, 6 righe, autotest
#      0/16, determinismo IDENTICI e "data:" di adesso, tutto da una corsa
#      mai avvenuta. Ora ogni CSV viene confrontato con l'ORA DI AVVIO
#      DELLA SUA CORSA: piu' vecchio = NON LETTO, e le due date finiscono
#      nel referto.
#  >>> UNA SOLA TRANCHE (FrazioneIS 1.0): la gamba "OOS" del generico
#      e' DEGENERE (0 giorni) e si IGNORA. Il rosso del generico sui
#      CSV *_OOS e' ATTESO: NON rilanciare. Il conteggio dei *_OOS
#      trovati (attesi 0) sta NEL REFERTO, non solo a schermo.
#  >>> SUFFISSO "_ohlc" NEI NOMI CSV: il generico marca cosi' OGNI
#      modello diverso da 4. Qui si legge "non-tick" (Modello 2, open
#      prices), non "OHLC M1". Dichiarato, non un errore.
#  >>> TETTO ~100k BARRE DEL TESTER (regola 25/08): 21 mesi di M5
#      forex (~130k barre di calendario) POSSONO eccedere il tetto.
#      NON si spezza: la sonda dichiara da sola la finestra effettiva
#      (Giorni Contati, Barre Valutate) e questo referto confronta i
#      giorni contati M5 contro M15 sullo stesso simbolo.
#  >>> NESSUN per-trade CSV e NESSUN CSV riga-per-segnale in questo
#      giro: non ci sono ordini, e in ottimizzazione la sonda spegne
#      il CSV dei segnali (si sovrascriverebbero). I numeri stanno
#      nelle 58 colonne OPTFRAME.
#
#  QUANTO CI METTE [STIMA, non una previsione]: 12 passate open-prices
#  su ~21 mesi (M5/M15) + 2 avvii del terminale + 1 compilazione.
#  Una passata open-prices e' questione di secondi-minuti: stima
#  onesta 10-25 minuti per tutto il giro.
#
#  LA RIGA CHE SI INCOLLA sta in righe\RIGA_SONDALONDONFX_DA_MANDARE.md
# =====================================================================
[CmdletBinding()]
param(
  # -Pin NON ha default: un default silenzioso ("lavoro") farebbe girare
  #  la punta del branch spacciandola per un commit congelato.
  [string]$Pin          = "",
  [switch]$SoloControllo,
  # -Simbolo: il simbolo di TUTTE E DUE le corse di questo giro. Default
  #  EURUSD (il lead, dichiarato nei prova). GBPUSD = corsa gemella con
  #  override DICHIARATO. Whitelist gattata piu' sotto: USDJPY VIETATO
  #  qui (vuole InpPipSize=0.01, il prova pinna 0.0001).
  [string]$Simbolo      = "EURUSD",
  [string]$SoloCorsa    = "",            # etichetta singola (es. "EUR_M5" / "GBP_M15"); default: tutte e due
  [string]$DaQuando     = "2024.09.26",  # finestra di TUTTE le corse di PASSO 0 (comparabilita': dichiarata nei prova)
  [string]$Fino         = "2026.06.30",  # dichiarata nei prova (@FINOA) e gattata
  [double]$FrazioneIS   = 1.0,           # finestra intera; la gamba OOS del generico e' degenere e si ignora
  [int]$Deposito        = 100000         # INERTE: la sonda non apre ordini. Sta qui perche' il generico lo vuole
)
$ErrorActionPreference = "Stop"
[Threading.Thread]::CurrentThread.CurrentCulture   = [Globalization.CultureInfo]::InvariantCulture
[Threading.Thread]::CurrentThread.CurrentUICulture = [Globalization.CultureInfo]::InvariantCulture
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$INV = [Globalization.CultureInfo]::InvariantCulture

$EA          = "ABTG_SondaLondonFx"
$SimboloLead = "EURUSD"
# --- IL SIMBOLO DI QUESTO GIRO (v4). Si normalizza SUBITO, perche' da
#     qui nascono le ETICHETTE (che entrano nei NOMI dei CSV) e il nome
#     dello zip. La WHITELIST viene gattata dentro il try, insieme alle
#     altre guardie, cosi' la raccolta gira lo stesso e il referto dice
#     perche' ci si e' fermati.
if($null -eq $Simbolo){ $Simbolo = "" }
$Simbolo  = $Simbolo.Trim().ToUpperInvariant()
$SIMBOLI_AMMESSI = @("EURUSD","GBPUSD")
$Prefisso = $Simbolo
if($Simbolo.Length -ge 3){ $Prefisso = $Simbolo.Substring(0,3) }
$OverrideSimbolo = ($Simbolo -ne $SimboloLead)
$Avvio   = Get-Date
$Stamp   = $Avvio.ToString("yyyyMMdd_HHmm", $INV)
$Dsk     = Join-Path $env:USERPROFILE "Desktop"
$Work    = Join-Path $env:USERPROFILE "abtg_sondalondonfx"
$Prove   = Join-Path $Work "prove"
$RawPin  = "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$Pin"

# --- I CANCELLI, ricopiati dai #define della sonda (congelati la',
#     LONDONFX_SOGLIA_*). Se lassu' cambiano e qui no, il referto
#     direbbe un'altra cosa dal log della sonda: per questo il referto
#     stampa ANCHE le soglie. Le DISUGUAGLIANZE sono quelle di
#     VerdettoF1/F2/H8_Calc, ricopiate segno per segno (un gate che
#     ricopia le soglie senza le disuguaglianze non si accorge di
#     niente: e' in checklist, ed e' successo).
$SOGLIA_F1  = 1.00     # segnali/giorno per lato:      MORTO se sigGg <  1,00
$F2_SCARTO  = 3.00     # MFE mediana 12 barre, pip:    MORTO se mfe   <  3,00
$F2_PASSA   = 6.00     #                               SOSPESO se 3,00 <= mfe <= 6,00; PASSA solo SOPRA 6,00
$SOGLIA_H8  = 0.70     # RR da mediane:                MORTO PER ARITMETICA se rr < 0,70
$AUTOTEST_BLOCCHI_ATTESI = 16
$PIP_ATTESO   = 0.0001 # eco L5 su EURUSD/GBPUSD a 5 decimali (i due soli simboli ammessi qui)
$PIPPTI_ATTESO= 10.0   # eco L5: 1 pip = 10 punti MT5 su un feed a 5 decimali
$NCelleAttese = 6      # 2 (InpUsaRsi) x 3 (InpOraInizioServer). RICONTATE dai pin ||Y scaricati, piu' sotto.

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
#  LE DUE CORSE. Un prova per TF. Il SIMBOLO viene da -Simbolo (default
#  il lead EURUSD) e finisce nell'argv del generico come -Simbolo: e'
#  l'override PREVISTO dal prova e supportato dal generico (righe
#  303-305: @SIMBOLO si legge SOLO se il parametro e' vuoto).
#  L'ETICHETTA si deriva dal simbolo (EUR_M5 / GBP_M5 ...) perche'
#  entra nel NOME del CSV: cosi' la corsa GBPUSD non puo' sovrascrivere
#  i CSV della corsa EURUSD gia' fatta (e viceversa). Il NOME del CSV
#  del generico porta gia' anche il simbolo -- l'etichetta e' la
#  seconda cintura, non la sola.
# =====================================================================
function C([string]$et,[string]$sym,[string]$tf,[string]$prova,[int]$lungo){
  return [pscustomobject]@{ Etichetta=$et; Simbolo=$sym; Periodo=$tf; Prova=$prova; LungoAtteso=$lungo
    Righe=$null; RigheDati=$null; Giorni=$null; BarreVal=$null
    Determinismo="NON VERIFICATO"; Cablaggio="NON VERIFICATO"; Sottoinsieme="NON VERIFICATO"; CsvOra="n/d"
    AutoKo=-2; AutoBlocchi=$null; RsiDivMax=$null; PipEco=$null; PipPtiEco=$null
    CanaleInv=$null; BarreSaltate=$null; MaxGiornoTot=$null }
}
$PROVA_M5  = "LONDONFX_FREQUENZA_M5.txt"
$PROVA_M15 = "LONDONFX_FREQUENZA_M15.txt"
$CORSE = @()
$CORSE += (C ($Prefisso + "_M5")  $Simbolo "M5"  $PROVA_M5  96)
$CORSE += (C ($Prefisso + "_M15") $Simbolo "M15" $PROVA_M15 32)

# I FISSI attesi nei prova (primo campo prima di ||): TUTTI gli input
# della sonda, nome per nome, tranne i due assi Y e il fisso PER-TF
# InpBarreOrizzonteLungo (gattato a parte: 96 su M5, 32 su M15).
# Un nome sbagliato qui sarebbe l'errore n.3 della checklist (MT5
# ignora in silenzio).
$FissiAttesi = [ordered]@{ "InpSmaPeriodo"="5"; "InpRsiPeriodo"="5"; "InpRsiSoglia"="80.0";
                  "InpOreSessione"="8"; "InpBarreOrizzonte"="12"; "InpPipSize"="0.0001";
                  "InpWarmupBarre"="300"; "InpConfrontaMT5"="true"; "InpScriviCsv"="true";
                  "InpVerbose"="true"; "InpAutoTest"="true"; "InpTag"="LONDONFX_SONDA" }
$AssiAttesi = [ordered]@{ "InpUsaRsi"="true||false||1||true||Y"; "InpOraInizioServer"="6||4||2||8||Y" }

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
# ricopiate da VerdettoF1_Calc / VerdettoF2_Calc / VerdettoH8_Calc.
function Verdetto([double]$sigGg,[double]$mfe,[double]$rr){
  $morto = $false
  $sospeso = $false
  if($sigGg -lt $SOGLIA_F1){ $morto = $true }
  if($mfe -lt $F2_SCARTO){ $morto = $true }
  elseif($mfe -le $F2_PASSA){ $sospeso = $true }
  if($rr -lt $SOGLIA_H8){ $morto = $true }
  if($morto){ return "MORTO" }
  if($sospeso){ return "SOSPESO (F2 in fascia 3,0-6,0: SPREAD NON MISURATO, Code Base 74148)" }
  return "VIVO"
}

# IL GATE DI UN PROVA, in una funzione: direttive nude, 2 assi esatti,
# celle ricontate dai pin ||Y, fissi nome per nome, fisso per-TF,
# nessuna riga estranea. E' una funzione (e non codice inline) APPOSTA:
# cosi' l'autotest della riga la esercita su file finti (mutation test)
# PRIMA che tocchi un prova vero. Torna @{ Lettura; Celle }.
function GateProva([string]$percorso,[string]$pf,[string]$tfAtteso,[string]$lungoAtteso){
  $lettura = LeggiProva $percorso $pf
  $h    = $lettura.Mappa
  $assi = $lettura.Assi

  # LE QUATTRO DIRETTIVE, NUDE E GATTATE (commentate = gate vuoto = ci si ferma).
  # @SIMBOLO deve restare il LEAD ANCHE quando -Simbolo e' un altro
  # (v4): il prova DICHIARA il lead, la riga di comando DICHIARA
  # l'override, e il generico fa vincere il parametro (righe 303-305).
  # Allineare il prova al simbolo di turno vorrebbe dire modificare un
  # file congelato a ogni gamba: NON si fa, e questo gate lo impedisce.
  if($h["@SIMBOLO"]  -ne $SimboloLead){ throw ($pf + ": @SIMBOLO e' '" + $h["@SIMBOLO"] + "', atteso il lead " + $SimboloLead + " (il prova si dichiara SEMPRE sul lead; il simbolo di questa corsa e' " + $Simbolo + " e passa dall'override -Simbolo, che nel generico vince sulla direttiva)") }
  if($h["@PERIODO"]  -ne $tfAtteso){    throw ($pf + ": @PERIODO e' '" + $h["@PERIODO"] + "', atteso " + $tfAtteso) }
  if($h["@DAQUANDO"] -ne $DaQuando){    throw ($pf + ": @DAQUANDO e' '" + $h["@DAQUANDO"] + "', atteso " + $DaQuando + " (la finestra di TUTTE le corse di PASSO 0, per comparabilita')") }
  if($h["@FINOA"]    -ne $Fino){        throw ($pf + ": @FINOA e' '" + $h["@FINOA"] + "', atteso " + $Fino + " (la finestra si dichiara nel prova, non si eredita dal default del generico)") }

  # DUE ASSI Y ESATTI: InpUsaRsi (ablazione + determinismo) e
  # InpOraInizioServer (F7). Valori campo per campo.
  if(@($assi).Count -ne 2){ throw ($pf + ": deve avere ESATTAMENTE 2 assi Y (" + (@($AssiAttesi.Keys) -join ", ") + "). Trovati: " + @($assi).Count + " {" + (@($assi) -join ", ") + "}.") }
  foreach($k in @($AssiAttesi.Keys)){
    if(@($assi) -notcontains $k){ throw ($pf + ": manca l'asse Y '" + $k + "'.") }
    if($h[$k] -ne $AssiAttesi[$k]){ throw ($pf + ": " + $k + " e' '" + $h[$k] + "', atteso '" + $AssiAttesi[$k] + "'.") }
  }

  # LE CELLE, CONTATE DAI PIN ||Y APPENA SCARICATI, come le conta il
  # generico. Il numero atteso di righe CSV e' GATTATO qui.
  $nc = 1
  foreach($k in @($AssiAttesi.Keys)){ $nc = $nc * (CelleAsse $h[$k] $k) }
  if($nc -ne $NCelleAttese){ throw ($pf + ": i pin ||Y danno " + $nc + " celle, attese " + $NCelleAttese + " (2 x 3). Un asse e' cambiato.") }

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
  # niente righe estranee: 4 direttive + 12 fissi + 1 per-TF + 2 assi = 19.
  $attese = 4 + @($FissiAttesi.Keys).Count + 1 + @($AssiAttesi.Keys).Count
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

$CorseDaFare = @($CORSE)
if($SoloCorsa -ne ""){ $CorseDaFare = @($CORSE | Where-Object { $_.Etichetta -eq $SoloCorsa }) }

try{
  Titolo ("SONDA LONDONFX -- PASSO 0, CONTATORE (" + $EA + ") -- modo " + $Modo)

  # -------------------------------------------------------------------
  #  0. LE GUARDIE, PRIMA DI TOCCARE QUALUNQUE COSA
  # -------------------------------------------------------------------
  if($Pin -eq ""){ throw "-Pin obbligatorio: senza, girerebbe la punta del branch spacciandola per un commit congelato." }
  if($Pin -notmatch '^[0-9a-f]{40}$'){ throw ("-Pin deve essere un commit di 40 caratteri esadecimali, ricevuto: " + $Pin) }
  # LA WHITELIST DEI SIMBOLI (v4). Sta QUI, prima di scaricare e prima
  # di aprire MT5, perche' il muro vero e' DENTRO la sonda (init
  # fallito su InpPipSize) e si scoprirebbe dopo una compilazione e due
  # avvii del terminale, con un referto pieno di righe vuote.
  if($SIMBOLI_AMMESSI -notcontains $Simbolo){
    throw ("-Simbolo '" + $Simbolo + "' NON e' ammesso su QUESTO prova. Ammessi: " + ($SIMBOLI_AMMESSI -join ", ") +
           " (" + $SimboloLead + " e' il lead). USDJPY e' VIETATO QUI ed e' VOLUTO: vuole InpPipSize=0.01 mentre i due prova lo pinnano a 0.0001, e la sonda RIFIUTEREBBE DI PARTIRE (init fallito) -- meglio cosi' che una taglia sbagliata di 100 volte letta come buona. La gamba JPY e' un GIRO SEPARATO con un prova suo.")
  }
  if(Get-Process terminal64,metaeditor64 -ErrorAction SilentlyContinue){
    throw "MT5 O METAEDITOR APERTO: col terminale aperto il tester non gira (zero CSV), con MetaEditor aperto la compilazione torna subito senza compilare."
  }
  if($SoloCorsa -ne "" -and @($CorseDaFare).Count -eq 0){
    $valide = ($CORSE | ForEach-Object { $_.Etichetta }) -join ", "
    throw ("-SoloCorsa '" + $SoloCorsa + "' non esiste. Valide: " + $valide)
  }
  if($SoloCorsa -ne ""){
    [void]$Rilievi.Add("girata UNA CORSA SOLA (" + $SoloCorsa + "): il gradiente M5/M15 (F6) si legge solo col giro completo.")
  }

  Dico ("pin ......... " + $Pin)
  if($OverrideSimbolo){
    Dico ("simbolo ..... " + $Simbolo + "  <- OVERRIDE DICHIARATO (-Simbolo). I due prova restano dichiarati sul LEAD " + $SimboloLead + " (@SIMBOLO " + $SimboloLead + ", e il gate lo PRETENDE): il parametro -Simbolo del generico VINCE sulla direttiva (walkforward_generico.ps1 righe 303-305). Etichette " + $Prefisso + "_M5 / " + $Prefisso + "_M15: i CSV NON si sovrascrivono fra simboli.") "Yellow"
  }
  else{
    Dico ("simbolo ..... " + $Simbolo + "  <- il LEAD, nessun override (e' il simbolo dichiarato in @SIMBOLO dai due prova). Etichette " + $Prefisso + "_M5 / " + $Prefisso + "_M15.")
  }
  Dico ("corse ....... " + @($CorseDaFare).Count + " su 2 (un simbolo per giro: l'altro major gira in un giro suo, USDJPY con un prova suo -- vedi header). " + $NCelleAttese + " passate a corsa (assi InpUsaRsi x InpOraInizioServer)")
  Dico ("finestra .... " + $DaQuando + " -> " + $Fino + " (UNA TRANCHE, FrazioneIS " + $FrazioneIS + ")")
  Dico ("banco ....... MODELLO 2 (SOLO PREZZI DI APERTURA): contatore su barra chiusa, il tick non aggiunge niente. Deposito " + $Deposito + " (inerte: zero ordini)")
  Dico ("cancelli .... F1 >= " + (Fmt2 $SOGLIA_F1) + " segnali/gg per lato | F2 MFE mediana VIVA solo > " + (Fmt2 $F2_PASSA) + " pip (" + (Fmt2 $F2_SCARTO) + "-" + (Fmt2 $F2_PASSA) + " sospeso, < " + (Fmt2 $F2_SCARTO) + " morto) | H8 RR >= " + (Fmt2 $SOGLIA_H8)) "Yellow"
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
  Remove-Item -Path (Join-Path $Prove "LONDONFX_*.txt") -Force -ErrorAction SilentlyContinue

  foreach($f in @($PROVA_M5,$PROVA_M15)){
    Scarica ($RawPin + "/backtest_pipeline/prove/" + $f) (Join-Path $Prove $f)
  }
  Dico ("file prova scaricati: " + @(Get-ChildItem $Prove -Filter "LONDONFX_*.txt").Count + " su 2") "Green"

  # -------------------------------------------------------------------
  #  2. I GATE SUI DUE PROVA -- girano PRIMA di aprire MT5
  # -------------------------------------------------------------------
  Titolo "2. GATE SUI DUE PROVA (direttive nude + fissi + 2 assi + celle contate + gemellaggio M5/M15)"
  $letture = @{}
  foreach($pf in @($PROVA_M5,$PROVA_M15)){
    $tfAtteso = "M5";  $lungoAtteso = "96"
    if($pf -eq $PROVA_M15){ $tfAtteso = "M15"; $lungoAtteso = "32" }
    $esito = GateProva (Join-Path $Prove $pf) $pf $tfAtteso $lungoAtteso
    $letture[$pf] = $esito.Lettura
    $CelleTxt = "" + $esito.Celle + " a corsa (2 InpUsaRsi x 3 InpOraInizioServer), ricontate dai pin ||Y al pin"
  }
  Dico ("gate per prova: direttive nude 4/4, 2 assi Y esatti, celle " + $CelleTxt + ", 13 input pinnati nome per nome, nessuna riga estranea: PASSATI") "Green"

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
    # IL CAMPO SI TIMBRA QUI, PRIMA DEL throw (classe 94-ter della checklist,
    # 02/09, pagata sulla sonda gemella RSI+EMA V8 e rimasta viva qui perche'
    # questo driver e' del 31/08): se lo aggiornasse solo il ramo di successo,
    # il referto del giro FALLITO direbbe ancora "NON TENTATA" -- cioe'
    # negherebbe agli atti PROPRIO il fatto che questo passo misura (EA mai
    # compilato), e la pagina dice a Claudio di cercare li' la parola FALLITA.
    # Tre stati e tutti e tre veri: NON TENTATA (non ci siamo arrivati) /
    # FALLITA (tentata, niente .ex5) / OK.
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
  #  4. LE DUE CORSE -- il generico una volta per corsa
  # -------------------------------------------------------------------
  Titolo ("4. LE CORSE (generico per corsa, Modello 2 OPEN PRICES, FrazioneIS " + $FrazioneIS + ")")
  foreach($c in $CorseDaFare){
    Dico ("CORSA " + $c.Etichetta + " | " + $c.Simbolo + " " + $c.Periodo + " | " + $c.Prova) "Cyan"
    # L'ORA DI AVVIO DELLA CORSA: e' il METRO DI FRESCHEZZA del CSV che
    # si leggera' dopo. La workdir e' RIUSABILE e NON si svuota: se il
    # generico MUORE PRIMA di rifare la corsa (MT5 aperto nel frattempo,
    # cartella dati non trovata, ...), il CSV della corsa PRECEDENTE
    # resta esattamente dov'era. "-Rifai" copre il generico che SALTA,
    # NON il generico che MUORE.
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
    $global:LASTEXITCODE = 0
    & powershell $argv
    $rc = $LASTEXITCODE
    if($rc -ne 0){
      [void]$Problemi.Add("corsa " + $c.Etichetta + ": il generico e' uscito con codice " + $rc + " (storico mancante? CSV non prodotto? Il rosso sul *_OOS invece e' ATTESO con FrazioneIS 1.0).")
    }
    if($SoloControllo){ continue }

    # IL CSV DELLA CORSA SI CONTA, NON SI Test-Path: 6 righe (le 6
    # passate dei due assi), colonne per NOME.
    # Modello != 4 -> suffisso "_ohlc" + etichetta (marca "non-tick").
    $csvIS = Join-Path $Work ("risultati_prove\" + $EA + "\" + $EA + "_" + $c.Simbolo + "_IS_ohlc_" + $c.Etichetta + ".csv")
    if(-not (Test-Path -LiteralPath $csvIS)){
      [void]$Problemi.Add("corsa " + $c.Etichetta + ": CSV OPTFRAME NON prodotto: " + $csvIS)
      continue
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
      continue
    }
    $lin = @(Get-Content -LiteralPath $csvIS | Where-Object { $_.Trim() -ne "" })
    $nRighe = $lin.Count - 1
    if($nRighe -lt 0){ $nRighe = 0 }
    $c.Righe = $nRighe
    if($nRighe -ne $NCelleAttese){
      [void]$Problemi.Add("corsa " + $c.Etichetta + ": " + $nRighe + " righe nel CSV, " + $NCelleAttese + " passate chieste (cache? storico?).")
    }
    if($nRighe -le 0){ continue }

    $head = $lin[0] -split ','
    $ix = @{}
    for($i2=0;$i2 -lt $head.Count;$i2++){ $ix[$head[$i2].Trim()] = $i2 }
    $servono = @("Segnali Long","Segnali Short",
                 "Segnali Nudo Long","Segnali Nudo Short",
                 "Segnali Con Rsi Long","Segnali Con Rsi Short",
                 "Giorni Contati","Segnali Long Al Giorno","Segnali Short Al Giorno",
                 "Mfe Mediano Long Pip","Mfe Mediano Short Pip",
                 "Mae Mediano Long Pip","Mae Mediano Short Pip",
                 "RR Da Mediane Long","RR Da Mediane Short",
                 "Win Rate Necessario Long Pct","Win Rate Necessario Short Pct",
                 "Max Segnali Giorno Long","Max Segnali Giorno Short","Max Segnali Giorno Totale",
                 "Giorni Almeno 1 Long","Giorni Almeno 1 Short",
                 "Mfe Lungo Mediano Long Pip","Mfe Lungo Mediano Short Pip",
                 "Mae Lungo Mediano Long Pip","Mae Lungo Mediano Short Pip",
                 "Atr Mediano Pip","Barre Valutate","Barre Saltate Dati",
                 "Segnali Fuori Sessione","Rsi Divergenza Max",
                 "Pip Size Prezzo","Pip In Punti Mt5","Canale Invertito",
                 "Usa Rsi","Ora Inizio Server","Ore Sessione",
                 "Barre Orizzonte","Barre Orizzonte Lungo",
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

    # OGNI RIGA DEL CSV DIVENTA UN OGGETTO: 6 passate = 6 oggetti.
    # Nessuna riga "del verdetto": qui il verdetto e' PER RIGA e PER
    # LATO (2 assi informativi, nessuna cella promossa).
    $righe = New-Object System.Collections.ArrayList
    for($i2=1;$i2 -lt $lin.Count;$i2++){
      $cols = $lin[$i2] -split ','
      if($cols.Count -le $maxIx){
        [void]$Problemi.Add("corsa " + $c.Etichetta + ": riga " + $i2 + " del CSV ha meno colonne dell'header: non la leggo.")
        continue
      }
      $r = [pscustomobject]@{
        UsaRsi   = [int](LeggiCella $cols "Usa Rsi")
        OraIni   = [int](LeggiCella $cols "Ora Inizio Server")
        SegL     = LeggiCella $cols "Segnali Long"
        SegS     = LeggiCella $cols "Segnali Short"
        NudoL    = LeggiCella $cols "Segnali Nudo Long"
        NudoS    = LeggiCella $cols "Segnali Nudo Short"
        ConRsiL  = LeggiCella $cols "Segnali Con Rsi Long"
        ConRsiS  = LeggiCella $cols "Segnali Con Rsi Short"
        Giorni   = LeggiCella $cols "Giorni Contati"
        SigGgL   = LeggiCella $cols "Segnali Long Al Giorno"
        SigGgS   = LeggiCella $cols "Segnali Short Al Giorno"
        MfeL     = LeggiCella $cols "Mfe Mediano Long Pip"
        MfeS     = LeggiCella $cols "Mfe Mediano Short Pip"
        MaeL     = LeggiCella $cols "Mae Mediano Long Pip"
        MaeS     = LeggiCella $cols "Mae Mediano Short Pip"
        RrL      = LeggiCella $cols "RR Da Mediane Long"
        RrS      = LeggiCella $cols "RR Da Mediane Short"
        WrL      = LeggiCella $cols "Win Rate Necessario Long Pct"
        WrS      = LeggiCella $cols "Win Rate Necessario Short Pct"
        MaxGgL   = LeggiCella $cols "Max Segnali Giorno Long"
        MaxGgS   = LeggiCella $cols "Max Segnali Giorno Short"
        MaxGgT   = LeggiCella $cols "Max Segnali Giorno Totale"
        G1L      = LeggiCella $cols "Giorni Almeno 1 Long"
        G1S      = LeggiCella $cols "Giorni Almeno 1 Short"
        MfeLunL  = LeggiCella $cols "Mfe Lungo Mediano Long Pip"
        MfeLunS  = LeggiCella $cols "Mfe Lungo Mediano Short Pip"
        MaeLunL  = LeggiCella $cols "Mae Lungo Mediano Long Pip"
        MaeLunS  = LeggiCella $cols "Mae Lungo Mediano Short Pip"
        AtrMed   = LeggiCella $cols "Atr Mediano Pip"
        BarreVal = LeggiCella $cols "Barre Valutate"
        BarreSal = LeggiCella $cols "Barre Saltate Dati"
        FuoriSes = LeggiCella $cols "Segnali Fuori Sessione"
        RsiDiv   = LeggiCella $cols "Rsi Divergenza Max"
        PipEco   = LeggiCella $cols "Pip Size Prezzo"
        PipPti   = LeggiCella $cols "Pip In Punti Mt5"
        CanInv   = LeggiCella $cols "Canale Invertito"
        OreSes   = [int](LeggiCella $cols "Ore Sessione")
        BOriz    = [int](LeggiCella $cols "Barre Orizzonte")
        BOrizL   = [int](LeggiCella $cols "Barre Orizzonte Lungo")
        AutoKo   = [int](LeggiCella $cols "Autotest Falliti")
        AutoBl   = [int](LeggiCella $cols "Autotest Blocchi")
        VerdL    = "n/d"; VerdS = "n/d" }
      $r.VerdL = Verdetto $r.SigGgL $r.MfeL $r.RrL
      $r.VerdS = Verdetto $r.SigGgS $r.MfeS $r.RrS
      [void]$righe.Add($r)
    }
    $c.RigheDati = $righe
    if($righe.Count -eq 0){ continue }

    # COLLAUDI PER RIGA: si verificano PRIMA di leggere qualunque numero.
    $rsiDivMax = 0.0; $canInvTot = 0; $barreSalMax = 0.0
    foreach($r in $righe){
      $etR = $c.Etichetta + " (UsaRsi=" + $r.UsaRsi + ", ora=" + $r.OraIni + ")"
      if($r.AutoKo -eq -1){ [void]$Problemi.Add("riga " + $etR + ": Autotest Falliti = -1 (autotest NON girato): file invalido per i criteri del prova.") }
      elseif($r.AutoKo -gt 0){ [void]$Problemi.Add("riga " + $etR + ": Autotest Falliti = " + $r.AutoKo + ": la sonda DIVERGE dalla spec, i numeri NON si leggono.") }
      if($r.AutoBl -ne $AUTOTEST_BLOCCHI_ATTESI -and $r.AutoKo -ge 0){
        [void]$Rilievi.Add("riga " + $etR + ": Autotest Blocchi = " + $r.AutoBl + " invece di " + $AUTOTEST_BLOCCHI_ATTESI + " (sonda diversa da quella attesa?).")
      }
      if($r.RsiDiv -gt 0.001){ [void]$Problemi.Add("riga " + $etR + ": Rsi Divergenza Max = " + (Fmt3 $r.RsiDiv) + " (atteso ~0, L1): la traduzione dell'RSI diverge da iRSI, i numeri non valgono.") }
      if([math]::Abs($r.PipEco - $PIP_ATTESO) -gt 0.0000001){ [void]$Problemi.Add("riga " + $etR + ": eco Pip Size Prezzo = " + $r.PipEco.ToString("0.00000",$INV) + " invece di 0,00010: il pin non e' passato e la TAGLIA non si legge.") }
      if([math]::Abs($r.PipPti - $PIPPTI_ATTESO) -gt 0.01){ [void]$Problemi.Add("riga " + $etR + ": Pip In Punti Mt5 = " + (Fmt2 $r.PipPti) + " invece di 10,00 (L5): la taglia e' sbagliata di un fattore, F2 direbbe una bugia.") }
      if($r.CanInv -gt 0){ [void]$Problemi.Add("riga " + $etR + ": Canale Invertito = " + (FmtN $r.CanInv) + " (atteso 0): SMA(high) < SMA(low) e' impossibile, il canale e' calcolato male e NIENTE vale.") }
      if($r.OreSes -ne 8){ [void]$Problemi.Add("riga " + $etR + ": eco Ore Sessione = " + $r.OreSes + " invece di 8: il pin non e' passato.") }
      if($r.BOriz -ne 12){ [void]$Problemi.Add("riga " + $etR + ": eco Barre Orizzonte = " + $r.BOriz + " invece di 12: il pin non e' passato.") }
      if($r.BOrizL -ne $c.LungoAtteso){ [void]$Problemi.Add("riga " + $etR + ": eco Barre Orizzonte Lungo = " + $r.BOrizL + " invece di " + $c.LungoAtteso + " (8 ore su " + $c.Periodo + "): il pin non e' passato.") }
      if($r.BarreSal -gt $barreSalMax){ $barreSalMax = $r.BarreSal }
      if($r.RsiDiv -gt $rsiDivMax){ $rsiDivMax = $r.RsiDiv }
      $canInvTot = $canInvTot + [int]$r.CanInv
      # GATE DI SOTTOINSIEME (per riga): Con Rsi <= Nudo per lato.
      if($r.ConRsiL -gt $r.NudoL -or $r.ConRsiS -gt $r.NudoS){
        [void]$Problemi.Add("riga " + $etR + ": Segnali Con Rsi > Segnali Nudo (L " + (FmtN $r.ConRsiL) + "/" + (FmtN $r.NudoL) + ", S " + (FmtN $r.ConRsiS) + "/" + (FmtN $r.NudoS) + "): il filtro NON e' un sottoinsieme, il codice e' rotto.")
      }
      # GATE DI CABLAGGIO (per riga): l'interruttore e' collegato.
      if($r.UsaRsi -eq 0){
        if($r.SegL -ne $r.NudoL -or $r.SegS -ne $r.NudoS){ [void]$Problemi.Add("riga " + $etR + ": con RSI SPENTO, Segnali != Segnali Nudo (L " + (FmtN $r.SegL) + "/" + (FmtN $r.NudoL) + ", S " + (FmtN $r.SegS) + "/" + (FmtN $r.NudoS) + "): l'interruttore NON e' cablato.") }
      } else {
        if($r.SegL -ne $r.ConRsiL -or $r.SegS -ne $r.ConRsiS){ [void]$Problemi.Add("riga " + $etR + ": con RSI ACCESO, Segnali != Segnali Con Rsi (L " + (FmtN $r.SegL) + "/" + (FmtN $r.ConRsiL) + ", S " + (FmtN $r.SegS) + "/" + (FmtN $r.ConRsiS) + "): l'interruttore NON e' cablato.") }
      }
    }
    if($barreSalMax -gt 10){ [void]$Rilievi.Add("corsa " + $c.Etichetta + ": Barre Saltate Dati fino a " + (FmtN $barreSalMax) + " (atteso ~0): buchi nello storico, da guardare.") }
    $primo = $righe[0]
    $c.AutoKo = $primo.AutoKo; $c.AutoBlocchi = $primo.AutoBl
    $c.RsiDivMax = $rsiDivMax; $c.PipEco = $primo.PipEco; $c.PipPtiEco = $primo.PipPti
    $c.CanaleInv = $canInvTot; $c.BarreSaltate = $barreSalMax
    $c.Giorni = $primo.Giorni; $c.BarreVal = $primo.BarreVal
    $maxT = 0.0
    foreach($r in $righe){ if($r.MaxGgT -gt $maxT){ $maxT = $r.MaxGgT } }
    $c.MaxGiornoTot = $maxT

    # GATE DI DETERMINISMO (prova, par. collaudi): a PARITA' di ora, le
    # due passate dell'asse InpUsaRsi devono avere IDENTICI i conteggi
    # invarianti. Se uno si muove, le globali si trascinano fra le
    # passate e TUTTE le mediane sono sporche.
    $detOk = $true; $coppie = 0
    foreach($oraV in @(4,6,8)){
      $rr0 = @($righe | Where-Object { $_.OraIni -eq $oraV -and $_.UsaRsi -eq 0 })
      $rr1 = @($righe | Where-Object { $_.OraIni -eq $oraV -and $_.UsaRsi -eq 1 })
      if($rr0.Count -ne 1 -or $rr1.Count -ne 1){
        [void]$Problemi.Add("corsa " + $c.Etichetta + ": ora " + $oraV + " non ha ESATTAMENTE una passata per valore di InpUsaRsi (" + $rr0.Count + "/" + $rr1.Count + "): griglia incompleta, determinismo non verificabile.")
        $detOk = $false
        continue
      }
      $a = $rr0[0]; $b = $rr1[0]; $coppie++
      $diffs = New-Object System.Collections.ArrayList
      if($a.NudoL   -ne $b.NudoL  ){ [void]$diffs.Add("Segnali Nudo Long") }
      if($a.NudoS   -ne $b.NudoS  ){ [void]$diffs.Add("Segnali Nudo Short") }
      if($a.ConRsiL -ne $b.ConRsiL){ [void]$diffs.Add("Segnali Con Rsi Long") }
      if($a.ConRsiS -ne $b.ConRsiS){ [void]$diffs.Add("Segnali Con Rsi Short") }
      if($a.Giorni  -ne $b.Giorni ){ [void]$diffs.Add("Giorni Contati") }
      if($a.BarreVal -ne $b.BarreVal){ [void]$diffs.Add("Barre Valutate") }
      if($a.FuoriSes -ne $b.FuoriSes){ [void]$diffs.Add("Segnali Fuori Sessione") }
      if([math]::Abs($a.AtrMed - $b.AtrMed) -gt 0.000001){ [void]$diffs.Add("Atr Mediano Pip") }
      if([math]::Abs($a.RsiDiv - $b.RsiDiv) -gt 0.000001){ [void]$diffs.Add("Rsi Divergenza Max") }
      if($diffs.Count -gt 0){
        $detOk = $false
        [void]$Problemi.Add("corsa " + $c.Etichetta + ", ora " + $oraV + ": DETERMINISMO ROTTO, differiscono fra le 2 passate: " + ($diffs -join ", ") + ". Le globali si trascinano e TUTTE le mediane sono sporche.")
      }
    }
    if($detOk -and $coppie -gt 0){ $c.Determinismo = "IDENTICI su " + $coppie + " coppie di passate (stessa ora, RSI on/off)" } else { $c.Determinismo = "ROTTO O NON VERIFICABILE (vedi PROBLEMI)" }
    $cablaggioKo = @($Problemi | Where-Object { $_ -like ("*" + $c.Etichetta + "*interruttore NON e' cablato*") })
    if($cablaggioKo.Count -eq 0){ $c.Cablaggio = "OK (Segnali = Nudo con RSI spento, = Con Rsi con RSI acceso, in ogni riga)" } else { $c.Cablaggio = "ROTTO (vedi PROBLEMI)" }
    $sottoKo = @($Problemi | Where-Object { $_ -like ("*" + $c.Etichetta + "*sottoinsieme*") })
    if($sottoKo.Count -eq 0){ $c.Sottoinsieme = "OK (Con Rsi <= Nudo per lato, in ogni riga)" } else { $c.Sottoinsieme = "ROTTO (vedi PROBLEMI)" }
  }

  # TETTO BARRE, M5 contro M15 sullo stesso simbolo: se M5 conta molti
  # meno giorni, la finestra M5 e' troncata (tetto ~100k) e va
  # dichiarata. F1 resta per-giorno (leggibile).
  if(-not $SoloControllo){
    $c5  = $CORSE | Where-Object { $_.Periodo -eq "M5"  } | Select-Object -First 1
    $c15 = $CORSE | Where-Object { $_.Periodo -eq "M15" } | Select-Object -First 1
    if($null -ne $c5 -and $null -ne $c15 -and $null -ne $c5.Giorni -and $null -ne $c15.Giorni -and $c15.Giorni -gt 0){
      if($c5.Giorni -lt 0.9*$c15.Giorni){
        [void]$Rilievi.Add("TETTO su " + $Simbolo + " M5: " + (FmtN $c5.Giorni) + " giorni contati contro " + (FmtN $c15.Giorni) + " a M15. La corsa M5 copre una finestra EFFETTIVA piu' corta (tetto ~100k barre): F1 resta per-giorno (leggibile), il campione e il regime coperto vanno dichiarati nel referto di lettura -- e il confronto F6 fra M5 e M15 confronta anche due finestre diverse, va detto.")
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
# IL NOME DELLA CARTELLA/ZIP PORTA IL SIMBOLO (v4): due giri sullo
# stesso Desktop (EURUSD gia' fatto, GBPUSD gemella) non devono nemmeno
# poter essere confusi a occhio, e il filtro della riga di lancio puo'
# cercare SONDALONDONFX_CORSA_GBPUSD_*.zip senza pescare l'altro.
$Cart = Join-Path $Dsk ("SONDALONDONFX_" + $Modo + "_" + $Simbolo + "_" + $Stamp)
New-Item -ItemType Directory -Force -Path $Cart | Out-Null

# IL CONTEGGIO DEI CSV *_OOS SI FA QUI, PRIMA DEL REFERTO, cosi' il
# numero finisce NEL REFERTO e non solo a schermo (debito dichiarato
# dal verificatore sul file M0PB: qui e' pagato).
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
[void]$RefTxt.Add(" SONDA LONDONFX -- PASSO 0, CONTATORE DI FREQUENZA E TAGLIA (" + $EA + ")")
[void]$RefTxt.Add(" " + $Simbolo + " x 2 TF (M5, M15) -- NESSUN ORDINE -- 6 passate a corsa")
[void]$RefTxt.Add("=====================================================================")
[void]$RefTxt.Add("modo: " + $Modo + "   <- CONTROLLO = giro a vuoto, NON e' il risultato")
[void]$RefTxt.Add("data: " + $Avvio.ToString("yyyy-MM-dd HH:mm:ss",$INV))
[void]$RefTxt.Add("pin:  " + $Pin)
# IL SIMBOLO E L'OVERRIDE, IN CHIARO E SEPARATI: cosa e' stato girato
# (riga di comando) e cosa e' dichiarato nei prova (il lead). Chi legge
# il referto senza la riga di lancio deve poterlo sapere da qui.
if($OverrideSimbolo){
  [void]$RefTxt.Add("simbolo di questa corsa: " + $Simbolo + ", OVERRIDE DICHIARATO da riga di comando (-Simbolo " + $Simbolo + "); prova dichiarati sul lead " + $SimboloLead)
  [void]$RefTxt.Add("  come funziona, dichiarato: i due file prova portano '@SIMBOLO " + $SimboloLead + "' e il gate di questa riga lo PRETENDE (il prova non si tocca a ogni gamba). Il generico legge la direttiva SOLO se il parametro -Simbolo e' vuoto (walkforward_generico.ps1 righe 303-305): qui NON e' vuoto, quindi VINCE " + $Simbolo + ". Pattern gia' di casa, dichiarato nel referto della sonda V8.")
  [void]$RefTxt.Add("  etichette: " + $Prefisso + "_M5 / " + $Prefisso + "_M15 (derivate dal simbolo, entrano nel NOME dei CSV: nessuna sovrascrittura fra simboli).")
}
else{
  [void]$RefTxt.Add("simbolo di questa corsa: " + $Simbolo + ", il LEAD -- nessun override (e' il simbolo dichiarato in @SIMBOLO dai due prova). Etichette " + $Prefisso + "_M5 / " + $Prefisso + "_M15.")
}
[void]$RefTxt.Add("finestra: " + $DaQuando + " -> " + $Fino + "  (UNA TRANCHE, FrazioneIS " + $FrazioneIS + ")")
[void]$RefTxt.Add("banco: MODELLO 2 (SOLO PREZZI DI APERTURA). Il segnale nasce su barra chiusa e non si apre niente: il tick non aggiunge informazione. I CSV portano il suffisso _ohlc (marca del generico per ogni modello non-tick).")
[void]$RefTxt.Add("terminale: " + $Terminale)
[void]$RefTxt.Add("compilazione: " + $Compilato + "   <- EA NUOVO: se e' FALLITA, QUESTO e' il risultato del passo")
[void]$RefTxt.Add("cache tester: " + $CacheTxt)
[void]$RefTxt.Add("grep contatore puro: " + $GrepTxt)
[void]$RefTxt.Add("celle per corsa: " + $CelleTxt)
[void]$RefTxt.Add("gemellaggio prova M5/M15: " + $Gemelle)
[void]$RefTxt.Add("simboli: UN SIMBOLO PER GIRO (qui " + $Simbolo + "). Ammessi su questo prova: " + ($SIMBOLI_AMMESSI -join ", ") + " -- USDJPY MAI (vuole InpPipSize=0.01: la sonda con 0.0001 RIFIUTA di partire, apposta; la whitelist di questa riga lo ferma prima ancora di aprire MT5).")
[void]$RefTxt.Add("csv *_OOS trovati: " + $nOosTrovati + " (attesi 0: FrazioneIS " + $FrazioneIS + " = gamba OOS degenere; il rosso del generico su quei file e' ATTESO e NON si rilancia)")
[void]$RefTxt.Add("")
[void]$RefTxt.Add("--- I TRE CANCELLI (congelati PRIMA dei numeri; disuguaglianze da VerdettoF1/F2/H8_Calc) ---")
[void]$RefTxt.Add("  F1 segnali/giorno per lato >= " + (Fmt2 $SOGLIA_F1) + "   | F2 MFE mediana a 12 barre VIVA solo > " + (Fmt2 $F2_PASSA) + " pip")
[void]$RefTxt.Add("  (F2: < " + (Fmt2 $F2_SCARTO) + " morto; " + (Fmt2 $F2_SCARTO) + "-" + (Fmt2 $F2_PASSA) + " sospeso [SPREAD NON MISURATO, Code Base 74148 mai usato]; fascia contesa della bozza sciolta verso la clausola piu' severa, 31/08)")
[void]$RefTxt.Add("  H8 RR da mediane >= " + (Fmt2 $SOGLIA_H8) + " (FIRMA 2 del 31/08: sotto = MORTO PER ARITMETICA, niente corsa a tick)")
[void]$RefTxt.Add("  VERDETTO PER RIGA (UsaRsi x Ora) E PER LATO: nessuna cella promossa, nessun aggregato.")
[void]$RefTxt.Add("")
[void]$RefTxt.Add("--- LA TABELLA DEI CANCELLI, PER CORSA / PASSATA / LATO (mai aggregati) ---")
[void]$RefTxt.Add(("{0,-8} {1,4} {2,4} {3,-6} {4,8} {5,8} {6,8} {7,7} {8,8} {9,7}  {10}" -f "corsa","rsi","ora","lato","sig/gg","MFE med","MAE med","RR","WRnec %","max/gg","VERDETTO"))
foreach($c in $CORSE){
  if($null -eq $c.RigheDati -or @($c.RigheDati).Count -eq 0){
    [void]$RefTxt.Add(("{0,-8} " -f $c.Etichetta) + "SENZA NUMERI (corsa non girata o CSV non letto)")
    continue
  }
  $ordinate = @($c.RigheDati | Sort-Object OraIni, UsaRsi)
  foreach($r in $ordinate){
    [void]$RefTxt.Add(("{0,-8} {1,4} {2,4} {3,-6} {4,8} {5,8} {6,8} {7,7} {8,8} {9,7}  {10}" -f $c.Etichetta, $r.UsaRsi, $r.OraIni, "LONG", (Fmt3 $r.SigGgL), (Fmt2 $r.MfeL), (Fmt2 $r.MaeL), (Fmt3 $r.RrL), (Fmt2 $r.WrL), (FmtN $r.MaxGgL), $r.VerdL))
    [void]$RefTxt.Add(("{0,-8} {1,4} {2,4} {3,-6} {4,8} {5,8} {6,8} {7,7} {8,8} {9,7}  {10}" -f "", "", "", "SHORT", (Fmt3 $r.SigGgS), (Fmt2 $r.MfeS), (Fmt2 $r.MaeS), (Fmt3 $r.RrS), (Fmt2 $r.WrS), (FmtN $r.MaxGgS), $r.VerdS))
  }
  $r8 = @($ordinate | Where-Object { $_.OraIni -eq 8 -and $_.UsaRsi -eq 1 }) | Select-Object -First 1
  if($null -ne $r8){
    [void]$RefTxt.Add("         ablazione F1-bis (invariante, dalla riga ora=8): NUDO L " + (FmtN $r8.NudoL) + " / S " + (FmtN $r8.NudoS) + "  contro  CON RSI L " + (FmtN $r8.ConRsiL) + " / S " + (FmtN $r8.ConRsiS) + " su " + (FmtN $r8.Giorni) + " giorni contati")
    [void]$RefTxt.Add("         orizzonte LUNGO (" + $c.LungoAtteso + " barre = 8 ore, INFORMATIVO, riga rsi=1 ora=8): MFE L " + (Fmt2 $r8.MfeLunL) + " / S " + (Fmt2 $r8.MfeLunS) + " pip | MAE L " + (Fmt2 $r8.MaeLunL) + " / S " + (Fmt2 $r8.MaeLunS) + " pip | ATR mediano sessione " + (Fmt2 $r8.AtrMed) + " pip")
  }
  [void]$RefTxt.Add("         CSV letto: scritto alle " + $c.CsvOra + " -- FRESCO (piu' recente dell'avvio di QUESTA corsa: un CSV piu' vecchio sarebbe di una corsa precedente e NON verrebbe letto)")
  [void]$RefTxt.Add("         determinismo: " + $c.Determinismo + " | cablaggio: " + $c.Cablaggio + " | sottoinsieme: " + $c.Sottoinsieme)
  if($null -ne $c.MaxGiornoTot){
    [void]$RefTxt.Add("         muro giornaliero F4 (peggiore fra le passate): " + (FmtN $c.MaxGiornoTot) + " segnali x 0,65% = " + (Fmt2 (0.65*$c.MaxGiornoTot)) + "% di rischio aperto contro il cap C1 di 3,25% (18/08)")
  }
}
[void]$RefTxt.Add("")
[void]$RefTxt.Add("--- I COLLAUDI, PER CORSA (si leggono PRIMA dei numeri) ---")
[void]$RefTxt.Add(("{0,-8} {1,6} {2,14} {3,12} {4,10} {5,8} {6,8} {7,10} {8,12}" -f "corsa","righe","autotest","RsiDivMax","PipEco","PipPti","CanInv","BarreSalt","BarreVal"))
foreach($c in $CORSE){
  $at = "n/d"
  if($c.AutoKo -eq 0){ $at = "0/" + (FmtN $c.AutoBlocchi) + " PASSATI" }
  elseif($c.AutoKo -gt 0){ $at = "" + $c.AutoKo + " FALLITI" }
  elseif($c.AutoKo -eq -1){ $at = "-1 NON GIRATO" }
  $pipTxt = "n/d"
  if($null -ne $c.PipEco){ $pipTxt = ([double]$c.PipEco).ToString("0.00000",$INV) }
  [void]$RefTxt.Add(("{0,-8} {1,6} {2,14} {3,12} {4,10} {5,8} {6,8} {7,10} {8,12}" -f $c.Etichetta, (FmtN $c.Righe), $at, (Fmt3 $c.RsiDivMax), $pipTxt, (Fmt2 $c.PipPtiEco), (FmtN $c.CanaleInv), (FmtN $c.BarreSaltate), (FmtN $c.BarreVal)))
}
[void]$RefTxt.Add("  attesi: righe 6 | autotest 0/" + $AUTOTEST_BLOCCHI_ATTESI + " | RsiDivMax ~0 (L1) | PipEco 0,00010 e PipPti 10,00 (L5) | CanInv 0 | BarreSalt ~0")
[void]$RefTxt.Add("")
[void]$RefTxt.Add("--- LE NOTE CHE VANNO LETTE INSIEME AI NUMERI ---")
[void]$RefTxt.Add("  - F5, LATO SHORT PIU' PERMISSIVO (dichiarato PRIMA dei numeri): la soglia RSI qui e'")
[void]$RefTxt.Add("    SIMMETRICA (short = 100-80 = 20) mentre l'autore usa 10. Il nostro short conta PIU'")
[void]$RefTxt.Add("    segnali del sorgente: se lo short passa F1 SOLO grazie a questo, va detto nella lettura.")
[void]$RefTxt.Add("  - F6, IL GRADIENTE M5/M15 NON E' A PARITA' DI TEMPO: 12 barre M5 = 1 ora, 12 barre M15 =")
[void]$RefTxt.Add("    3 ore. Il criterio F2 e' congelato in BARRE e resta in barre; il confronto fra le due")
[void]$RefTxt.Add("    corse e' fra due orizzonti temporali diversi, ed e' proprio il gradiente che F6 vuole.")
[void]$RefTxt.Add("  - F7, L'ORA: 4 = lettura UTC del Pine, 8 = lettura New York (= sessione di Londra esatta,")
[void]$RefTxt.Add("    ATTESA dichiarata ma non decisa), 6 = la via di mezzo. Ora server = ora di Londra.")
[void]$RefTxt.Add("  - LE ESCURSIONI SONO LIMITI SUPERIORI (la sonda attraversa la fine sessione, il Pine")
[void]$RefTxt.Add("    chiude tutto a fine finestra): su F2 la distorsione e' conservativa NEL VERSO GIUSTO;")
[void]$RefTxt.Add("    su H8 NO (anche la MAE e' un limite superiore): l'RR e' un'INDICAZIONE, dichiarato.")
[void]$RefTxt.Add("  - Nessun per-trade CSV e nessun CSV riga-per-segnale: corsa in ottimizzazione, zero ordini.")
[void]$RefTxt.Add("    I numeri stanno SOLO nelle colonne OPTFRAME (58) dei CSV *_IS_ohlc_*.")
[void]$RefTxt.Add("  - Questa corsa NON promuove niente e NON dice se il motore guadagna: e' un conteggio.")
[void]$RefTxt.Add("    Il merito si misura a tick, dopo, e SOLO se i tre cancelli reggono (R57) -- e la")
[void]$RefTxt.Add("    profondita' TICK del forex BCM non e' MAI stata sondata (buco dichiarato nel prova).")
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
[void]$RefTxt.Add('COME SI RIPRENDE: dalla pagina righe/RIGA_SONDALONDONFX_DA_MANDARE.md, NON da')
[void]$RefTxt.Add('questa riga: $Pin nasce dentro il blocco e non sopravvive.')

# IL NOME DEL REFERTO PORTA IL SIMBOLO (v4): due zip diversi estratti
# nella stessa cartella non devono sovrascriversi il referto a vicenda.
$refPath = Join-Path $Cart ("REFERTO_SONDALONDONFX_" + $Simbolo + ".txt")
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
Write-Host ("FILE ATTESI NELLO ZIP: REFERTO_SONDALONDONFX_" + $Simbolo + ".txt + i 2 prova + 2 CSV OPTFRAME (" + $EA + "_" + $Simbolo + "_IS_ohlc_" + $Prefisso + "_M5.csv e " + $EA + "_" + $Simbolo + "_IS_ohlc_" + $Prefisso + "_M15.csv, 6 righe l'uno = le 6 passate)") -ForegroundColor Gray
Write-Host ("CSV *_OOS trovati: " + $nOosTrovati + " (attesi 0: FrazioneIS 1.0 = gamba OOS degenere; il numero sta ANCHE nel referto).") -ForegroundColor Gray
Write-Host "      Il rosso del generico su quei file e' ATTESO: NON rilanciare." -ForegroundColor Gray
Write-Host "NOTA: nessun per-trade (zero ordini) e nessun CSV riga-per-segnale (ottimizzazione)." -ForegroundColor Gray

if($Fatale -ne ""){ Write-Host "ESITO: FERMATO" -ForegroundColor Red; exit 1 }
if($Problemi.Count -gt 0){ Write-Host "ESITO: COMPLETATO CON PROBLEMI" -ForegroundColor Yellow; exit 1 }
Write-Host ("ESITO: " + $Modo + " COMPLETATO") -ForegroundColor Green
exit 0
