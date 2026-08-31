# =====================================================================
#  MARCATORE_RIGA_BREAKIN_v1
#  RIGA_BREAKIN.ps1  --  BREAKIN BOX: ABLAZIONE A/B (la prova che decide,
#  dichiarata PRIMA). ABTG_BreakinBox su D30EUR M15, TICK REALI
#  (Modello 4), 2024.09.26->2026.06.30, DUE GAMBE in sequenza:
#    GAMBA A  prove\ABTG_BreakinBox.txt          InpTP_RR=0.0
#             TP al LATO OPPOSTO DEL BOX (LA TESI)     magic 769701/769702
#    GAMBA B  prove\ABTG_BreakinBox_RRFISSO.txt  InpTP_RR=2.0
#             TP a RR FISSO (IL CONTROLLO = R95)       magic 769711/769712
#  Ogni gamba: UNICO asse Y = InpMagic gemelli -> 2 passate identiche
#  (determinismo) + 2 per-trade CSV distinti. 4 passate a tick in tutto.
# ---------------------------------------------------------------------
#  L'ABLAZIONE E' IL ROUND: senza le due gambe INSIEME il round non e'
#  giudicabile (criteri congelati in testa ai due file prova; il gemello
#  B rimanda ad A apposta per non farli divergere). Le regole di lettura,
#  scritte PRIMA dei numeri:
#    - vince A  -> la tesi regge (il take grande e la durata contano);
#    - vince B  -> il motore e' R95 con un livello nuovo: CAPITOLO CHIUSO,
#                  niente caccia a "un RR migliore" (Seconda Caccia 19/08);
#    - indistinguibili -> il TP non e' la variabile che conta: il
#                  candidato torna in coda, non passa.
#  QUESTA RIGA MISURA E APPARECCHIA IL CONFRONTO: il verdetto formale
#  spetta alla lettura, coi criteri del prova.
#
#  >>> GATE DELL'ABLAZIONE (meccanico, qui dentro): le righe VIVE dei due
#      prova devono essere IDENTICHE tranne InpTP_RR e InpMagic, che
#      devono DIFFERIRE. Se differiscono altrove, l'ablazione misurerebbe
#      due cose insieme e la riga si FERMA prima di aprire MT5.
#  >>> IL FUSO E' QUELLO DI CASA (NON invertito): D30EUR BCM = ora SERVER
#      = ora italiana MENO UN'ORA. Box notturno 23:00-04:59 SERVER
#      (= 00:00-05:59 IT, IDENTICO alla sedia viva 770411); finestra
#      operativa 08:00-17:30 SERVER. Il gate PRETENDE InpBoxStartHour=23
#      e RIFIUTA il 22 (la vecchia deduzione sbagliata dal PDF, PAG 26/28)
#      e PRETENDE InpOpStartHour=8 RIFIUTANDO il 9 (l'ora italiana).
#  >>> EA NUOVO, MAI COMPILATO: si compila QUI (con l'include
#      ABTG_PausaGuardian.mqh installato prima, classe 33-bis della
#      checklist: il driver generico NON lo installa). Se la compilazione
#      FALLISCE, QUELLO e' il risultato del passo.
#  >>> UNA SOLA TRANCHE (FrazioneIS 1.0): la gamba "OOS" del generico e'
#      DEGENERE (0 giorni) e si IGNORA. Il rosso del generico sul CSV
#      *_OOS e' ATTESO: NON rilanciare.
#  >>> CONVERSIONE D30EUR [NON MISURATA]: il 100 di InpMT5PerPuntoIndice
#      e' il fattore R97 di NASUSD/U30USD, MAI misurato su D30EUR. Tocca
#      SOLO la colonna take_idx_pts (mai i trade). Questa riga misura dal
#      per-trade digits dei prezzi + mediana dei movimenti (pattern R97)
#      e li scrive nel referto: il cancello C2 si legge DOPO quella
#      verifica, riscalando se serve.
#
#  QUANTO CI METTE [STIMA, non una previsione]: 4 passate a tick reali
#  (2 gemelle per gamba, celle CONTATE nei prova: InpMagic step 1 su due
#  valori = 2 celle a gamba) su ~21 mesi di D30EUR M15. La griglia 48 di
#  NYRETEST (stesso banco tick M15 su indice) fece 48 celle in ~1-4 ore,
#  cioe' ~2-5 minuti a passata: stima onesta 10-40 minuti piu' le
#  compilazioni. Il giro a vuoto resta questione di minuti.
#
#  LA RIGA CHE SI INCOLLA sta in righe\RIGA_BREAKIN_DA_MANDARE.md
# =====================================================================
[CmdletBinding()]
param(
  # -Pin NON ha default: un default silenzioso ("lavoro") farebbe girare
  #  la punta del branch spacciandola per un commit congelato.
  [string]$Pin          = "",
  [switch]$SoloControllo,
  [string]$SoloGamba    = "",            # "A" | "B" (default: tutte e due, in sequenza)
  [string]$Simbolo      = "D30EUR",
  [string]$Periodo      = "M15",
  [string]$DaQuando     = "2024.09.26",  # pavimento MISURATO dei tick BCM sugli indici
  [string]$Fino         = "2026.06.30",  # dichiarata nei prova (@FINOA) e gattata: MAI ereditata dal default del generico
  [double]$FrazioneIS   = 1.0,           # finestra intera; la gamba OOS del generico e' degenere e si ignora
  [int]$Deposito        = 100000
)
$ErrorActionPreference = "Stop"
[Threading.Thread]::CurrentThread.CurrentCulture   = [Globalization.CultureInfo]::InvariantCulture
[Threading.Thread]::CurrentThread.CurrentUICulture = [Globalization.CultureInfo]::InvariantCulture
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$INV = [Globalization.CultureInfo]::InvariantCulture

$EA      = "ABTG_BreakinBox"
$Avvio   = Get-Date
$Stamp   = $Avvio.ToString("yyyyMMdd_HHmm", $INV)
$Dsk     = Join-Path $env:USERPROFILE "Desktop"
$Work    = Join-Path $env:USERPROFILE "abtg_breakin"
$Prove   = Join-Path $Work "prove"
$RawPin  = "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$Pin"

# --- tutto cio' che la raccolta usa nasce QUI, prima del try: la
#     raccolta gira SEMPRE, anche nella corsa fermata da un gate.
$Problemi  = New-Object System.Collections.ArrayList
$Rilievi   = New-Object System.Collections.ArrayList
$Fatale    = ""
$Terminale = "n/d"
$Include   = "NON INSTALLATO"
$Compilato = "NON TENTATA"
$CacheTxt  = "NON SVUOTATA"
$Ablazione = "NON VERIFICATA"
$Modo      = "CORSA"
if($SoloControllo){ $Modo = "CONTROLLO" }

# =====================================================================
#  LE DUE GAMBE. TpAtteso e magic sono i valori DICHIARATI nei prova;
#  il gate dell'ablazione (diff meccanico) prende tutto il resto.
# =====================================================================
function G([string]$id,[string]$file,[string]$etichetta,[string]$tp,[int]$m1,[int]$m2,[string]$descrizione){
  return [pscustomobject]@{ Id=$id; Prova=$file; Etichetta=$etichetta; Tp=$tp; M1=$m1; M2=$m2; Desc=$descrizione
    NIS=$null; PfIS=$null; DdIS=$null; PeggIS=$null; ProfIS=$null; AutoKo=-1
    Gemelli="NON MISURATO"; OpsMagic="NON MISURATE"; Overnight="NON VERIFICATO"
    ConvDigits="n/d"; ConvMediana="n/d"; TakeMedianoPos="n/d"; LatiTxt="n/d" }
}
$GAMBE = @()
$GAMBE += (G "A" ($EA + ".txt")          "gambaA" "0.0" 769701 769702 "TP al LATO OPPOSTO DEL BOX (LA TESI)")
$GAMBE += (G "B" ($EA + "_RRFISSO.txt")  "gambaB" "2.0" 769711 769712 "TP a RR FISSO 2.0 (IL CONTROLLO = geometria R95, 0/30)")

# I FISSI condivisi dalle due gambe (primo campo prima di ||). Gli 8 orari
# e il pavimento R109 hanno gate DEDICATI con i rifiuti per nome.
$FissiAttesi = @{ "InpMinBarreBox"="120";
                  "InpMinBoxATR"="0.0"; "InpAtrPeriod"="14";
                  "InpCloseAtEnd"="true";
                  "InpMinBarreRientro"="1"; "InpConfirmMaxBars"="8";
                  "InpAllowLong"="true"; "InpAllowShort"="true";
                  "InpSlBufferPts"="300";
                  "InpRiskPercent"="1.0"; "InpMaxTradesPerDay"="2";
                  "InpMT5PerPuntoIndice"="100"; "InpAutoTest"="true" }

# I MAGIC VIETATI: sorgenti, sedie vive e blocchi dei round recenti.
# Il 769700 e' il default dell'EA e resta riservato a un eventuale forward.
$MagicVietati = @(769700, 769500, 769501, 769502, 769503,
                  770411, 772600,
                  770901, 770801, 771001, 971001,
                  770921, 770922, 770923, 770924, 770925,
                  970901, 970911, 970912, 970913, 970914, 970915, 970916,
                  770101, 770202, 770511, 770611, 771501, 771511, 775501,
                  778000, 778001, 778100, 778101, 778300, 778301,
                  778400, 778401, 778500, 778501)

$NCelleGamba = 2   # InpMagic start||step 1||stop su DUE valori = 2 passate gemelle. CONTATE.

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

function CommonFilesDir(){ return (Join-Path $env:APPDATA "MetaQuotes\Terminal\Common\Files") }
function PerTradeNome([int]$magic){ return ("abtg_trades_" + $EA + "_" + $Simbolo + "_" + $magic + ".csv") }
function Num([string]$s){ return [double]::Parse($s.Trim(), $INV) }
function FmtN($v){ if($null -eq $v){ return "n/d" }; return ([int]$v).ToString($INV) }
function Fmt2($v){ if($null -eq $v){ return "n/d" }; return ([double]$v).ToString("0.00",$INV) }
function Fmt3($v){ if($null -eq $v){ return "n/d" }; return ([double]$v).ToString("0.000",$INV) }

# mediana su un array di double (PS 5.1-safe, senza Measure -Median)
function Mediana($valori){
  $v = @($valori | Sort-Object)
  if($v.Count -eq 0){ return $null }
  $m = [int][math]::Floor($v.Count/2)
  if($v.Count % 2 -eq 1){ return [double]$v[$m] }
  return ([double]$v[$m-1] + [double]$v[$m]) / 2.0
}

# legge un file prova in una mappa @{nome=valore} + lista assi Y.
# Una riga DOPPIA per lo stesso nome e' FATALE: in [TesterInputs] un
# parametro doppio fa fare a MT5 ZERO passate (classe pagata; e la bozza
# di QUESTO round ne aveva una, trovata proprio da questo controllo).
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

$GambeDaFare = @($GAMBE)
if($SoloGamba -ne ""){ $GambeDaFare = @($GAMBE | Where-Object { $_.Id -eq $SoloGamba }) }

try{
  Titolo ("BREAKIN BOX -- ABLAZIONE A/B (" + $EA + ") -- modo " + $Modo)

  # -------------------------------------------------------------------
  #  0. LE GUARDIE, PRIMA DI TOCCARE QUALUNQUE COSA
  # -------------------------------------------------------------------
  if($Pin -eq ""){ throw "-Pin obbligatorio: senza, girerebbe la punta del branch spacciandola per un commit congelato." }
  if($Pin -notmatch '^[0-9a-f]{40}$'){ throw ("-Pin deve essere un commit di 40 caratteri esadecimali, ricevuto: " + $Pin) }
  if(Get-Process terminal64,metaeditor64 -ErrorAction SilentlyContinue){
    throw "MT5 O METAEDITOR APERTO: col terminale aperto il tester non gira (zero CSV), con MetaEditor aperto la compilazione torna subito senza compilare."
  }
  if($SoloGamba -ne "" -and @($GambeDaFare).Count -eq 0){
    throw ("-SoloGamba '" + $SoloGamba + "' non esiste. Valide: A (lato opposto del box), B (RR fisso).")
  }
  if($SoloGamba -ne ""){
    [void]$Rilievi.Add("girata UNA GAMBA SOLA (" + $SoloGamba + "): l'ablazione si LEGGE solo con tutte e due. Una gamba da sola non decide niente.")
  }

  Dico ("pin ......... " + $Pin)
  Dico ("simbolo ..... " + $Simbolo + " " + $Periodo + " (NATIVO BCM, ora SERVER = IT-1: box 23:00-04:59, operativa 08:00-17:30)")
  Dico ("gambe ....... " + @($GambeDaFare).Count + " su 2 (A=TP lato opposto/tesi, B=RR fisso/controllo R95), " + $NCelleGamba + " passate gemelle a gamba")
  Dico ("finestra .... " + $DaQuando + " -> " + $Fino + " (tick BCM, UNA TRANCHE, FrazioneIS " + $FrazioneIS + ")")
  Dico ("banco ....... MODELLO 4 (TICK REALI) -- MISURA + ablazione, niente griglia. Deposito " + $Deposito)
  Dico ("conversione . InpMT5PerPuntoIndice=100 [NON MISURATO su D30EUR]: digits+mediana si misurano QUI dal per-trade (pattern R97)." ) "Yellow"

  # -------------------------------------------------------------------
  #  1. SCARICO AL PIN
  # -------------------------------------------------------------------
  Titolo "1. SCARICO AL PIN"
  New-Item -ItemType Directory -Force -Path $Work,$Prove | Out-Null

  $drv = Join-Path $Work "walkforward_generico.ps1"
  Scarica ($RawPin + "/backtest_pipeline/walkforward_generico.ps1") $drv
  # il driver generico riscarica il .mq5 dal SUO $EABranch: senza questo
  # replace il pin varrebbe per il driver e NON per l'EA misurato.
  $t = Get-Content -LiteralPath $drv -Raw
  if($t -notmatch '\$EABranch\s*=\s*"lavoro"'){ throw 'walkforward_generico.ps1 non ha la riga $EABranch = "lavoro" attesa: non lo posso pinnare (il pin varrebbe per il driver e NON per l''EA misurato).' }
  $t = $t -replace '\$EABranch\s*=\s*"lavoro"', ('$EABranch="' + $Pin + '"')
  Set-Content -LiteralPath $drv -Value $t -Encoding ASCII
  Dico "driver generico scaricato e PINNATO (riscarica l'EA al pin, non dalla punta del branch)" "Green"

  # artefatti intermedi ripuliti PRIMA (difetto n.14 della checklist): un
  # prova di una versione precedente verrebbe gattato in buona fede.
  Remove-Item -Path (Join-Path $Prove "*.txt") -Force -ErrorAction SilentlyContinue

  # si scaricano SEMPRE tutti e due: il gate dell'ablazione confronta i
  # due file anche quando gira una gamba sola.
  foreach($g in $GAMBE){
    Scarica ($RawPin + "/backtest_pipeline/prove/" + $g.Prova) (Join-Path $Prove $g.Prova)
  }
  Dico ("file prova scaricati: " + @(Get-ChildItem $Prove -Filter *.txt).Count + " su 2") "Green"

  $incSrc = Join-Path $Work "ABTG_PausaGuardian.mqh"
  Scarica ($RawPin + "/mql5/Include/ABTG_PausaGuardian.mqh") $incSrc
  Dico ("include scaricato: ABTG_PausaGuardian.mqh (" + (Get-Item -LiteralPath $incSrc).Length + " byte)") "Green"

  # -------------------------------------------------------------------
  #  2. I GATE SUI DUE PROVA -- girano PRIMA di aprire MT5
  # -------------------------------------------------------------------
  Titolo "2. GATE SUI DUE PROVA (direttive nude + fissi + fuso + R109 + magic + ABLAZIONE)"
  $letture = @{}
  $magicVisti = @{}
  foreach($g in $GAMBE){
    $lettura = LeggiProva (Join-Path $Prove $g.Prova) $g.Prova
    $letture[$g.Id] = $lettura
    $h    = $lettura.Mappa
    $assi = $lettura.Assi

    # LE QUATTRO DIRETTIVE, NUDE E GATTATE (commentate = gate vuoto = ci si ferma).
    if($h["@SIMBOLO"]  -ne $Simbolo){  throw ($g.Prova + ": @SIMBOLO e' '" + $h["@SIMBOLO"] + "', atteso " + $Simbolo) }
    if($h["@PERIODO"]  -ne $Periodo){  throw ($g.Prova + ": @PERIODO e' '" + $h["@PERIODO"] + "', atteso " + $Periodo) }
    if($h["@DAQUANDO"] -ne $DaQuando){ throw ($g.Prova + ": @DAQUANDO e' '" + $h["@DAQUANDO"] + "', atteso " + $DaQuando + " (pavimento MISURATO dei tick BCM sugli indici)") }
    if($h["@FINOA"]    -ne $Fino){     throw ($g.Prova + ": @FINOA e' '" + $h["@FINOA"] + "', atteso " + $Fino + " (la finestra si dichiara nel prova, non si eredita dal default del generico; e le due gambe devono averla IDENTICA)") }

    # UNICO ASSE Y = InpMagic (gemelli).
    if(@($assi).Count -ne 1){ throw ($g.Prova + ": deve avere ESATTAMENTE un asse Y (InpMagic). Trovati: " + @($assi).Count + " {" + (@($assi) -join ", ") + "}.") }
    if($assi[0] -ne "InpMagic"){ throw ($g.Prova + ": l'unico asse Y deve essere InpMagic, invece e' " + $assi[0] + ".") }

    # I FISSI condivisi (primo campo prima di ||).
    foreach($k in @($FissiAttesi.Keys)){
      if(-not $h.ContainsKey($k)){ throw ($g.Prova + ": manca la riga '" + $k + "' (fisso dichiarato: va verificabile nell'.ini).") }
      $v = ($h[$k] -split '\|\|')[0]
      if($v -ne $FissiAttesi[$k]){ throw ($g.Prova + ": " + $k + " e' '" + $v + "', atteso '" + $FissiAttesi[$k] + "' (le due gambe muovono SOLO il TP).") }
    }

    # GATE DEL FUSO -- QUELLO DI CASA (NON invertito): D30EUR BCM = ora
    # SERVER = ora italiana meno un'ora. Il 22 (vecchia deduzione dal PDF,
    # PAG 26/28) e il 9 (ora italiana dell'apertura) si RIFIUTANO PER NOME.
    $bs = ($h["InpBoxStartHour"] -split '\|\|')[0]
    if($bs -eq "22"){ throw ($g.Prova + ": InpBoxStartHour=22 e' la VECCHIA DEDUZIONE dal PDF (PAG 26/28), superata il 31/08: il box e' quello della sedia viva 770411, cioe' 23:00 SERVER (= 00:00 IT). Qui va 23, non 22.") }
    if($bs -ne "23"){ throw ($g.Prova + ": InpBoxStartHour deve essere 23 (23:00 SERVER = 00:00 IT, il box della sedia 770411), trovato '" + $bs + "'.") }
    if((($h["InpBoxStartMin"] -split '\|\|')[0]) -ne "0"){  throw ($g.Prova + ": InpBoxStartMin deve essere 0, trovato '" + (($h["InpBoxStartMin"] -split '\|\|')[0]) + "'.") }
    if((($h["InpBoxEndHour"] -split '\|\|')[0])  -ne "4"){  throw ($g.Prova + ": InpBoxEndHour deve essere 4 (fine box 04:59 SERVER = 05:59 IT), trovato '" + (($h["InpBoxEndHour"] -split '\|\|')[0]) + "'.") }
    if((($h["InpBoxEndMin"] -split '\|\|')[0])   -ne "59"){ throw ($g.Prova + ": InpBoxEndMin deve essere 59, trovato '" + (($h["InpBoxEndMin"] -split '\|\|')[0]) + "'.") }
    $os = ($h["InpOpStartHour"] -split '\|\|')[0]
    if($os -eq "9"){ throw ($g.Prova + ": InpOpStartHour=9 e' l'ORA ITALIANA dell'apertura del DAX. Su BCM (ora server, IT-1) l'apertura e' 08:00. Qui va 8, non 9.") }
    if($os -ne "8"){ throw ($g.Prova + ": InpOpStartHour deve essere 8 (apertura DAX 09:00 IT = 08:00 SERVER), trovato '" + $os + "'.") }
    if((($h["InpOpStartMin"] -split '\|\|')[0]) -ne "0"){  throw ($g.Prova + ": InpOpStartMin deve essere 0, trovato '" + (($h["InpOpStartMin"] -split '\|\|')[0]) + "'.") }
    if((($h["InpCloseHour"] -split '\|\|')[0])  -ne "17"){ throw ($g.Prova + ": InpCloseHour deve essere 17 (flat 17:30 SERVER, l'ora della sedia viva 770411), trovato '" + (($h["InpCloseHour"] -split '\|\|')[0]) + "'.") }
    if((($h["InpCloseMin"] -split '\|\|')[0])   -ne "30"){ throw ($g.Prova + ": InpCloseMin deve essere 30, trovato '" + (($h["InpCloseMin"] -split '\|\|')[0]) + "'.") }

    # PAVIMENTO R109: mai zero.
    $mfloor = ($h["InpMinStopPts"] -split '\|\|')[0]
    if($mfloor -eq "0"){ throw ($g.Prova + ": InpMinStopPts=0 VIETATO (R109): il pavimento SL e' 500 (5 punti indice), mai 0.") }
    if($mfloor -ne "500"){ throw ($g.Prova + ": InpMinStopPts deve essere 500 (R109), trovato '" + $mfloor + "'.") }

    # IL TP DELLA GAMBA: e' l'ablazione, e si controlla in valore ASSOLUTO
    # (il diff fra i due file non vedrebbe DUE file sbagliati uguali).
    $tp = ($h["InpTP_RR"] -split '\|\|')[0]
    if($tp -ne $g.Tp){ throw ($g.Prova + ": InpTP_RR e' '" + $tp + "', la gamba " + $g.Id + " lo vuole '" + $g.Tp + "' (A=0.0 lato opposto/tesi, B=2.0 RR fisso/controllo).") }

    # I MAGIC: formato gemelli, valori dichiarati, vergini, unici.
    $mg = $h["InpMagic"] -split '\|\|'
    if($mg.Count -lt 5 -or $mg[4].Trim() -ne "Y"){ throw ($g.Prova + ": InpMagic non ha il formato default||start||step||stop||Y.") }
    if($mg[2] -ne "1"){ throw ($g.Prova + ": InpMagic deve avere step 1 (due passate gemelle), trovato step '" + $mg[2] + "'.") }
    if([int]$mg[1] -ne $g.M1 -or [int]$mg[3] -ne $g.M2){
      throw ($g.Prova + ": i magic gemelli sono " + $mg[1] + "/" + $mg[3] + ", la gamba " + $g.Id + " li vuole " + $g.M1 + "/" + $g.M2)
    }
    foreach($m in @([int]$mg[1],[int]$mg[3])){
      if($MagicVietati -contains $m){ throw ($g.Prova + ": magic " + $m + " e' VIETATO (default EA, sorgente, sedia viva o round recente).") }
      if($magicVisti.ContainsKey($m)){ throw ("magic " + $m + " usato in due gambe: " + $magicVisti[$m] + " e " + $g.Prova) }
      $magicVisti[$m] = $g.Prova
    }
  }
  Dico ("gate per gamba: direttive nude 4/4, 1 asse Y=InpMagic, fissi, FUSO SERVER (23:00-04:59 box / 08:00-17:30 operativa; 22 e 9 RIFIUTATI), R109, TP e magic dichiarati: PASSATI (" + $magicVisti.Count + " magic unici su 4)") "Green"

  # GATE DELL'ABLAZIONE (il cuore): le righe vive dei due prova devono
  # differire SOLO per InpTP_RR e InpMagic. Confronto PER NOME sulle
  # mappe complete, direttive @ comprese.
  $hA = $letture["A"].Mappa
  $hB = $letture["B"].Mappa
  foreach($k in @($hA.Keys)){
    if(-not $hB.ContainsKey($k)){ throw ("ABLAZIONE NON VALIDA: la gamba A ha la riga '" + $k + "' che la gamba B non ha. Le due gambe devono avere le STESSE righe.") }
  }
  foreach($k in @($hB.Keys)){
    if(-not $hA.ContainsKey($k)){ throw ("ABLAZIONE NON VALIDA: la gamba B ha la riga '" + $k + "' che la gamba A non ha. Le due gambe devono avere le STESSE righe.") }
  }
  $ammessiDiff = @("InpTP_RR","InpMagic")
  foreach($k in @($hA.Keys)){
    if($ammessiDiff -contains $k){ continue }
    if($hA[$k] -ne $hB[$k]){ throw ("ABLAZIONE NON VALIDA: '" + $k + "' differisce fra le due gambe ('" + $hA[$k] + "' contro '" + $hB[$k] + "') e NON e' InpTP_RR ne' InpMagic. Cosi' si misurerebbero due cose insieme.") }
  }
  foreach($k in $ammessiDiff){
    if($hA[$k] -eq $hB[$k]){ throw ("ABLAZIONE NON VALIDA: '" + $k + "' DOVEVA differire fra le due gambe e invece e' identico ('" + $hA[$k] + "').") }
  }
  $Ablazione = "VALIDA: le righe vive differiscono SOLO per InpTP_RR (" + (($hA["InpTP_RR"] -split '\|\|')[0]) + " contro " + (($hB["InpTP_RR"] -split '\|\|')[0]) + ") e InpMagic"
  Dico ("gate dell'ablazione: " + $Ablazione) "Green"

  # -------------------------------------------------------------------
  #  3. TERMINALE, INCLUDE E COMPILAZIONE (EA NUOVO, MAI compilato)
  # -------------------------------------------------------------------
  Titolo "3. TERMINALE, INCLUDE E COMPILAZIONE (D30EUR nativo BCM, EA NUOVO)"
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

  # L'INCLUDE (classe 33-bis): l'EA fa #include <ABTG_PausaGuardian.mqh>
  # e il driver generico NON lo installa. La copia si verifica sul
  # CONTENUTO (lunghezza), non sull'esistenza del nome.
  $incDir = Join-Path $dataFolder "MQL5\Include"
  New-Item -ItemType Directory -Force -Path $incDir | Out-Null
  $lenAtteso = (Get-Item -LiteralPath $incSrc).Length
  Copy-Item -LiteralPath $incSrc -Destination $incDir -Force
  $vIn = Get-Item -LiteralPath (Join-Path $incDir "ABTG_PausaGuardian.mqh") -ErrorAction Stop
  if($vIn.PSIsContainer -or $vIn.Length -ne $lenAtteso){ throw ("ABTG_PausaGuardian.mqh copiato ma NON verificato in " + $incDir) }
  $Include = "INSTALLATO in " + $incDir
  Dico $Include "Green"

  # COMPILAZIONE QUI, con l'.ex5 vecchio CANCELLATO prima: se fallisce,
  # QUELLO e' il risultato del passo (EA nuovo, mai compilato).
  $mq5 = Join-Path $Work ($EA + ".mq5")
  Scarica ($RawPin + "/mql5/Experts/" + $EA + ".mq5") $mq5
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

  # I PER-TRADE dei 4 magic del round si cancellano PRIMA: un residuo di
  # un giro precedente non deve spacciarsi per fresco. MAI toccare i
  # per-trade di ALTRI magic. I magic si leggono dai PROVA, non da una
  # lista ricopiata (che prima o poi diverge).
  $commonFiles = CommonFilesDir
  $MagicTutti = @()
  foreach($g in $GAMBE){
    $mg = $letture[$g.Id].Mappa["InpMagic"] -split '\|\|'
    $MagicTutti += @([int]$mg[1],[int]$mg[3])
  }
  foreach($m in $MagicTutti){
    Remove-Item -LiteralPath (Join-Path $commonFiles (PerTradeNome $m)) -Force -ErrorAction SilentlyContinue
  }
  Dico ("per-trade CSV vecchi cancellati se c'erano (" + ($MagicTutti -join "/") + "); gli altri magic NON si toccano") "Gray"

  # LA CACHE DEL TESTER (checklist punto 38), coi conteggi. Qui e'
  # PROBABILMENTE non load-bearing: l'EA e' NUOVO e mai girato, nessun
  # pass in cache puo' combaciare. Il blocco si mette lo stesso, per la
  # regola: costa secondi e toglie una classe intera di sorprese.
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
  #  4. LE CORSE -- il generico DUE volte, una per gamba
  # -------------------------------------------------------------------
  Titolo ("4. LE CORSE (generico per gamba, Modello 4 TICK, FrazioneIS " + $FrazioneIS + ")")
  foreach($g in $GambeDaFare){
    Dico ("GAMBA " + $g.Id + " | " + $g.Prova + " | etichetta " + $g.Etichetta + " | magic " + $g.M1 + "/" + $g.M2 + " -- " + $g.Desc) "Cyan"
    # "-Rifai" sta SEMPRE nell'argv: la classe skip-senza-Rifai ha
    # prodotto 4 corse zombie su 6 nella saga CRT.
    $argv = @("-ExecutionPolicy","Bypass","-File",$drv,
              "-Expert",$EA,
              "-Prova",(Join-Path $Prove $g.Prova),
              "-Etichetta",$g.Etichetta,
              "-Simbolo",$Simbolo,
              "-Periodo",$Periodo,
              "-DaQuando",$DaQuando,
              "-Fino",$Fino,
              ("-FrazioneIS"),("" + $FrazioneIS),
              "-Modello","4",
              "-Rifai",
              "-Deposito",("" + $Deposito))
    if($SoloControllo){ $argv += "-SoloControllo" }
    $global:LASTEXITCODE = 0
    & powershell $argv
    $rc = $LASTEXITCODE
    if($rc -ne 0){
      [void]$Problemi.Add("gamba " + $g.Id + ": il generico e' uscito con codice " + $rc + " (storico mancante? CSV non prodotto? Il rosso sul *_OOS invece e' ATTESO con FrazioneIS 1.0).")
    }
    if($SoloControllo){ continue }

    # IL CSV DELLA GAMBA SI CONTA, NON SI Test-Path: 2 righe gemelle,
    # colonne per NOME, autotest a 0. Modello 4 -> suffisso "" + etichetta.
    $csvIS = Join-Path $Work ("risultati_prove\" + $EA + "\" + $EA + "_" + $Simbolo + "_IS_" + $g.Etichetta + ".csv")
    if(-not (Test-Path -LiteralPath $csvIS)){
      [void]$Problemi.Add("gamba " + $g.Id + ": CSV della griglia gemelli NON prodotto: " + $csvIS)
    }
    else{
      $lin = @(Get-Content -LiteralPath $csvIS | Where-Object { $_.Trim() -ne "" })
      $nRighe = $lin.Count - 1
      if($nRighe -lt 0){ $nRighe = 0 }
      if($nRighe -ne $NCelleGamba){
        [void]$Problemi.Add("gamba " + $g.Id + ": " + $nRighe + " righe nel CSV, " + $NCelleGamba + " passate gemelle chieste.")
      }
      if($nRighe -gt 0){
        $head = $lin[0] -split ','
        $ix = @{}
        for($i2=0;$i2 -lt $head.Count;$i2++){ $ix[$head[$i2].Trim()] = $i2 }
        $servono = @("Profit","Profit Factor","Trades","Equity DD %","Peggior Giornata %","Autotest Falliti")
        $manca = New-Object System.Collections.ArrayList
        foreach($cName in $servono){ if(-not $ix.ContainsKey($cName)){ [void]$manca.Add($cName) } }
        if($manca.Count -gt 0){
          [void]$Problemi.Add("gamba " + $g.Id + ": nel CSV mancano le colonne: " + ($manca -join ", ") + " (header cambiato nell'EA?).")
        }
        else{
          $maxIx = 0
          foreach($cName in $servono){ if($ix[$cName] -gt $maxIx){ $maxIx = $ix[$cName] } }
          $righeDati = New-Object System.Collections.ArrayList
          for($i2=1;$i2 -lt $lin.Count;$i2++){
            $c = $lin[$i2] -split ','
            if($c.Count -le $maxIx){ continue }
            [void]$righeDati.Add(@{ prof=(Num $c[$ix["Profit"]]); pf=(Num $c[$ix["Profit Factor"]]);
                                    tr=(Num $c[$ix["Trades"]]); dd=(Num $c[$ix["Equity DD %"]]);
                                    pegg=(Num $c[$ix["Peggior Giornata %"]]); at=(Num $c[$ix["Autotest Falliti"]]) })
          }
          if($righeDati.Count -ge 1){
            $g.NIS = $righeDati[0].tr; $g.PfIS = $righeDati[0].pf
            $g.DdIS = $righeDati[0].dd; $g.PeggIS = $righeDati[0].pegg
            $g.ProfIS = $righeDati[0].prof; $g.AutoKo = [int]$righeDati[0].at
          }
          foreach($o in $righeDati){
            if($o.at -eq -1){ [void]$Problemi.Add("gamba " + $g.Id + ": Autotest Falliti = -1 (autotest NON girato, InpAutoTest spento?): file invalido per i criteri del prova.") ; break }
            if($o.at -gt 0){ [void]$Problemi.Add("gamba " + $g.Id + ": Autotest Falliti = " + $o.at + ": il motore DIVERGE dalla spec, i numeri NON si leggono.") ; break }
          }
          # I GEMELLI: le due righe IDENTICHE al centesimo, o il banco
          # non e' deterministico e il numero non si legge.
          if($righeDati.Count -eq 2){
            $d1 = $righeDati[0]; $d2 = $righeDati[1]
            $diversi = New-Object System.Collections.ArrayList
            if([math]::Abs($d1.prof-$d2.prof) -gt 0.005){ [void]$diversi.Add("profitto") }
            if([math]::Abs($d1.pf-$d2.pf)     -gt 0.005){ [void]$diversi.Add("PF") }
            if([math]::Abs($d1.dd-$d2.dd)     -gt 0.005){ [void]$diversi.Add("DD") }
            if([math]::Abs($d1.tr-$d2.tr)     -gt 0.005){ [void]$diversi.Add("n") }
            if($diversi.Count -eq 0){ $g.Gemelli = "IDENTICI" }
            else{
              $g.Gemelli = "DIVERSI su " + ($diversi -join ", ")
              [void]$Problemi.Add("gamba " + $g.Id + ": GEMELLI DIVERGENTI nella griglia (" + ($diversi -join ", ") + "): banco non deterministico, la gamba non si legge.")
            }
          }
          else{ $g.Gemelli = "NON VALIDO: " + $righeDati.Count + " righe invece di 2" }
        }
      }
    }

    # PER-TRADE: conteggio operazioni per OGNI magic della gamba + gate
    # gemelli-divergenti sul conteggio.
    $conte = New-Object System.Collections.ArrayList
    $magGamba = @($g.M1,$g.M2)
    foreach($m in $magGamba){
      $pt = Join-Path $commonFiles (PerTradeNome $m)
      if(Test-Path -LiteralPath $pt){
        $ops = @(Get-Content -LiteralPath $pt).Count - 1
        if($ops -lt 0){ $ops = 0 }
        [void]$conte.Add("" + $m + "=" + $ops)
        if($ops -eq 0){ [void]$Problemi.Add("gamba " + $g.Id + ": per-trade del magic " + $m + " SOLO intestazione, ZERO operazioni (zero trade veri o passata a vuoto): non e' una misura.") }
      }
      else{ [void]$Problemi.Add("gamba " + $g.Id + ": per-trade del magic " + $m + " NON prodotto in Common\Files (zero trade? FILE_COMMON? cache?).") }
    }
    if($conte.Count -eq 2){
      $c1 = [int](($conte[0] -split "=")[1]); $c2 = [int](($conte[1] -split "=")[1])
      if($c1 -ne $c2){ [void]$Problemi.Add("gamba " + $g.Id + ": GEMELLI DIVERGENTI sul per-trade: " + $c1 + " contro " + $c2 + " operazioni. Due passate identiche devono dare lo STESSO numero.") }
    }
    if($conte.Count -gt 0){ $g.OpsMagic = "OPERAZIONI per magic -> " + ($conte -join " | ") }
    else{ $g.OpsMagic = "NESSUN FILE in Common\Files" }

    # OVERNIGHT VERI (open_time contro close_time, colonne 1 e 2 del
    # per-trade). NB: il BOX e' notturno ma l'OPERATIVITA' e' diurna
    # (08:00-17:30 server): una chiusura DOPO il flat serale ma nello
    # STESSO GIORNO e' regolare (flat di recupero al primo tick); una
    # chiusura a GIORNO SUCCESSIVO e' un overnight VERO e sopra il 5%
    # il file e' INVALIDO (criterio del prova).
    # E gia' che si scorre il file: si misurano la CONVERSIONE D30EUR
    # (digits dei prezzi + mediana dei |movimenti|, pattern R97), la
    # mediana del take POSITIVO (il candidato C2, da leggere DOPO la
    # verifica del fattore) e i LATI (colonna dir).
    $nTot = 0; $nOver = 0; $esempi = New-Object System.Collections.ArrayList
    $digitsMax = -1
    $mosse = New-Object System.Collections.ArrayList
    $takePos = New-Object System.Collections.ArrayList
    $nLong = 0; $nShort = 0
    foreach($m in $magGamba){
      $pt = Join-Path $commonFiles (PerTradeNome $m)
      if(-not (Test-Path -LiteralPath $pt)){ continue }
      $nr = 0
      foreach($riga in @(Get-Content -LiteralPath $pt)){
        $nr++
        if($nr -eq 1){ continue }
        if($riga.Trim() -eq ""){ continue }
        $col = $riga -split ';'
        if($col.Count -lt 10){ continue }
        $tChiu = $col[0].Replace('"','').Trim()
        $tApri = $col[1].Replace('"','').Trim()
        if($tApri -eq "?" -or $tApri -eq ""){ continue }
        $nTot++
        $gChiu = ($tChiu -split ' ')[0]
        $gApri = ($tApri -split ' ')[0]
        if($gChiu -ne $gApri){
          $nOver++
          if($esempi.Count -lt 5){ [void]$esempi.Add($tApri + " -> " + $tChiu) }
        }
        $dir = $col[5].Replace('"','').Trim()
        if($dir -eq "LONG"){ $nLong++ } elseif($dir -eq "SHORT"){ $nShort++ }
        $pxIn = $col[7].Replace('"','').Trim()
        $pv = $pxIn.IndexOf(".")
        $dg = 0
        if($pv -ge 0){ $dg = $pxIn.Length - $pv - 1 }
        if($dg -gt $digitsMax){ $digitsMax = $dg }
        $tk = $null
        try{ $tk = [double]::Parse($col[9].Replace('"','').Trim(), $INV) }catch{ $tk = $null }
        if($null -ne $tk){
          [void]$mosse.Add([math]::Abs($tk))
          if($tk -gt 0){ [void]$takePos.Add($tk) }
        }
      }
      break   # i gemelli sono identici: basta il primo file buono
    }
    if($nTot -eq 0){ $g.Overnight = "NON MISURABILE (nessuna riga con open_time)" }
    else{
      $pct = [math]::Round(100.0*$nOver/$nTot,2)
      $g.Overnight = "" + $nOver + " su " + $nTot + " (" + $pct + "%) chiuse in un GIORNO SUCCESSIVO all'apertura"
      if($esempi.Count -gt 0){ $g.Overnight += "   es: " + ($esempi -join " ; ") }
      if($pct -gt 5.0){
        [void]$Problemi.Add("gamba " + $g.Id + ": OVERNIGHT VERI oltre la soglia del prova (5%): " + $pct + "% (" + $nOver + "/" + $nTot + "). Il file NON e' una misura valida.")
      }
      elseif($nOver -gt 0){
        [void]$Rilievi.Add("gamba " + $g.Id + ": overnight per ASSENZA DI TICK: " + $nOver + "/" + $nTot + " (" + $pct + "%), sotto la soglia del 5%. Gap-risk residuo DICHIARATO, non azzerato.")
      }
      $g.LatiTxt = "LONG=" + $nLong + " SHORT=" + $nShort
      if($digitsMax -ge 0){ $g.ConvDigits = "" + $digitsMax }
      $md = Mediana $mosse
      if($null -ne $md){ $g.ConvMediana = $md.ToString("0.0",$INV) }
      $mp = Mediana $takePos
      if($null -ne $mp){ $g.TakeMedianoPos = $mp.ToString("0.0",$INV) }
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
Titolo "RACCOLTA"
$Cart = Join-Path $Dsk ("BREAKIN_" + $Modo + "_" + $Stamp)
New-Item -ItemType Directory -Force -Path $Cart | Out-Null

$RefTxt = New-Object System.Collections.ArrayList
[void]$RefTxt.Add("=====================================================================")
[void]$RefTxt.Add(" BREAKIN BOX -- ABLAZIONE A/B su " + $Simbolo + " " + $Periodo + " (" + $EA + ")")
[void]$RefTxt.Add(" GAMBA A: TP al lato opposto del box (TESI) | GAMBA B: RR fisso (CONTROLLO R95)")
[void]$RefTxt.Add("=====================================================================")
[void]$RefTxt.Add("modo: " + $Modo + "   <- CONTROLLO = giro a vuoto, NON e' il risultato")
[void]$RefTxt.Add("data: " + $Avvio.ToString("yyyy-MM-dd HH:mm:ss",$INV))
[void]$RefTxt.Add("pin:  " + $Pin)
[void]$RefTxt.Add("finestra: " + $DaQuando + " -> " + $Fino + "  (tick BCM, UNA TRANCHE, FrazioneIS " + $FrazioneIS + ")")
[void]$RefTxt.Add("banco: MODELLO 4 (TICK REALI). Deposito " + $Deposito + ". Niente griglia: 2 passate gemelle a gamba.")
[void]$RefTxt.Add("fuso: D30EUR BCM = ora SERVER (IT-1) -> box 23:00-04:59, operativa 08:00-17:30, flat 17:30 (come la sedia 770411).")
[void]$RefTxt.Add("terminale: " + $Terminale)
[void]$RefTxt.Add("include: " + $Include)
[void]$RefTxt.Add("compilazione: " + $Compilato + "   <- EA NUOVO: se e' FALLITA, QUESTO e' il risultato del passo")
[void]$RefTxt.Add("cache tester: " + $CacheTxt + "   <- qui probabilmente non load-bearing (EA mai girato), svuotata per regola")
[void]$RefTxt.Add("ablazione (gate meccanico sui due prova): " + $Ablazione)
[void]$RefTxt.Add("")
[void]$RefTxt.Add("--- LE DUE GAMBE, FIANCO A FIANCO (finestra intera; la colonna OOS del generico e' DEGENERE e non esiste) ---")
[void]$RefTxt.Add(("{0,-8} {1,6} {2,8} {3,8} {4,10} {5,10} {6,-12} {7}" -f "gamba","n","PF","DD %","pegg.gio %","profit","gemelli","autotest"))
foreach($g in $GAMBE){
  $at = "n/d"
  if($g.AutoKo -eq 0){ $at = "0 (PASSATI)" } elseif($g.AutoKo -gt 0){ $at = "" + $g.AutoKo + " (DIVERGE)" } elseif($g.AutoKo -eq -1 -and $null -ne $g.NIS){ $at = "-1 (NON GIRATO)" }
  [void]$RefTxt.Add(("{0,-8} {1,6} {2,8} {3,8} {4,10} {5,10} {6,-12} {7}" -f $g.Id, (FmtN $g.NIS), (Fmt3 $g.PfIS), (Fmt2 $g.DdIS), (Fmt2 $g.PeggIS), (Fmt2 $g.ProfIS), $g.Gemelli, $at))
  [void]$RefTxt.Add("         " + $g.Desc)
  [void]$RefTxt.Add("         " + $g.OpsMagic)
  [void]$RefTxt.Add("         overnight veri: " + $g.Overnight)
  [void]$RefTxt.Add("         lati (dal per-trade, colonna dir): " + $g.LatiTxt)
}
[void]$RefTxt.Add("")
[void]$RefTxt.Add("--- LA LETTURA DELL'ABLAZIONE (criteri CONGELATI nei prova PRIMA dei numeri) ---")
[void]$RefTxt.Add("  - vince la GAMBA A (lato opposto del box) -> la tesi regge: l'edge sta")
[void]$RefTxt.Add("    nella TAGLIA DEL TAKE e nella DURATA (arXiv 2605.04004 par.6.2).")
[void]$RefTxt.Add("  - VINCE LA GAMBA B (RR fisso) -> il motore e' R95 CON UN LIVELLO NUOVO")
[void]$RefTxt.Add("    e IL CAPITOLO SI CHIUDE LI'. Niente caccia a 'un RR migliore':")
[void]$RefTxt.Add("    vietata dalla Regola della Seconda Caccia (19/08).")
[void]$RefTxt.Add("  - INDISTINGUIBILI -> il TP non e' la variabile che conta: la tesi del")
[void]$RefTxt.Add("    dossier e' falsificata lo stesso, il candidato torna in coda.")
[void]$RefTxt.Add("  Il confronto e' PER-TRADE/RISK-ADJUSTED (PF, DD, peggior giornata),")
[void]$RefTxt.Add("  MAI profitto totale. Il verdetto formale spetta alla LETTURA, non a")
[void]$RefTxt.Add("  questa riga; gli altri cancelli (frequenza >=150/lato sui contatori")
[void]$RefTxt.Add("  OPTFRAME, C2 take mediano, DD<=15%, pegg.giornata > -5%, lati letti")
[void]$RefTxt.Add("  SEPARATI) stanno in testa a prove\" + $GAMBE[0].Prova + ".")
[void]$RefTxt.Add("")
[void]$RefTxt.Add("--- NOTA CONVERSIONE D30EUR (pattern R97: SI MISURA PRIMA DI LEGGERE C2) ---")
[void]$RefTxt.Add("Il fattore InpMT5PerPuntoIndice=100 e' MISURATO su NASUSD/U30USD, MAI su")
[void]$RefTxt.Add("D30EUR: tocca SOLO la colonna take_idx_pts (mai i trade). Due misure dal")
[void]$RefTxt.Add("per-trade di QUESTO round, che devono CONCORDARE con un DAX a 5 cifre:")
foreach($g in $GAMBE){
  [void]$RefTxt.Add("  gamba " + $g.Id + ": digits max dei prezzi = " + $g.ConvDigits + " | mediana |movimento| (in 'punti indice' a fattore 100) = " + $g.ConvMediana + " | mediana take POSITIVO = " + $g.TakeMedianoPos)
}
[void]$RefTxt.Add("Se il DAX BCM quota con un altro numero di decimali o la mediana dei")
[void]$RefTxt.Add("movimenti esce di un ordine di grandezza fuori scala (un DAX muove decine")
[void]$RefTxt.Add("di punti, non migliaia), il fattore NON e' 100: take_idx_pts si riscala")
[void]$RefTxt.Add("del fattore noto SENZA rifare la corsa, e solo DOPO si legge il cancello")
[void]$RefTxt.Add("C2 (take mediano >= 6,0 punti indice = 3 x spread di riferimento 2,0).")
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
[void]$RefTxt.Add('COME SI RIPRENDE: dalla pagina righe/RIGA_BREAKIN_DA_MANDARE.md, NON da')
[void]$RefTxt.Add('questa riga: $Pin nasce dentro il blocco e non sopravvive.')

$refPath = Join-Path $Cart "REFERTO_BREAKIN.txt"
Set-Content -LiteralPath $refPath -Value ($RefTxt -join "`r`n") -Encoding ASCII
Write-Host ($RefTxt -join "`r`n")

foreach($f in @("COMPILAZIONE_FALLITA.log")){
  $src = Join-Path $Work $f
  if(Test-Path -LiteralPath $src){ Copy-Item $src -Destination $Cart -Force }
}
foreach($g in $GAMBE){
  $srcProva = Join-Path $Prove $g.Prova
  if(Test-Path -LiteralPath $srcProva){ Copy-Item $srcProva -Destination $Cart -Force }
  # griglia gemelli: Modello 4 -> suffisso "" + etichetta.
  $Results = Join-Path $Work ("risultati_prove\" + $EA)
  foreach($leg in @("IS","OOS")){
    $f = Join-Path $Results ($EA + "_" + $Simbolo + "_" + $leg + "_" + $g.Etichetta + ".csv")
    if(Test-Path -LiteralPath $f){ Copy-Item $f -Destination $Cart -Force }
  }
  # i per-trade dei magic della gamba (4 file in tutto).
  foreach($m in @($g.M1,$g.M2)){
    $pt = Join-Path (CommonFilesDir) (PerTradeNome $m)
    if(Test-Path -LiteralPath $pt){ Copy-Item $pt -Destination $Cart -Force }
  }
}
$zip = $Cart + ".zip"
Remove-Item -LiteralPath $zip -Force -ErrorAction SilentlyContinue
Compress-Archive -Path (Join-Path $Cart "*") -DestinationPath $zip -Force
Write-Host ""
Write-Host ("CARTELLA: " + $Cart) -ForegroundColor Green
Write-Host ("ZIP DA MANDARE: " + $zip) -ForegroundColor Green
Write-Host "FILE ATTESI NELLO ZIP: REFERTO_BREAKIN.txt + i 2 prova + 2 griglie gemelli (ABTG_BreakinBox_D30EUR_IS_gambaA.csv e _gambaB.csv, 2 righe l'una) + 4 per-trade (abtg_trades_..._769701/769702/769711/769712.csv)" -ForegroundColor Gray
Write-Host "NOTA: i CSV *_OOS NON esistono MAI qui (FrazioneIS 1.0 = gamba OOS degenere)." -ForegroundColor Gray
Write-Host "      Il rosso del generico su quei file e' ATTESO: NON rilanciare." -ForegroundColor Gray

if($Fatale -ne ""){ Write-Host "ESITO: FERMATO" -ForegroundColor Red; exit 1 }
if($Problemi.Count -gt 0){ Write-Host "ESITO: COMPLETATO CON PROBLEMI" -ForegroundColor Yellow; exit 1 }
Write-Host ("ESITO: " + $Modo + " COMPLETATO") -ForegroundColor Green
exit 0
