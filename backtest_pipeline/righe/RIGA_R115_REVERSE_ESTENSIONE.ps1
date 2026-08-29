# =====================================================================
#  MARCATORE_RIGA_R115_v1
#  RIGA_R115_REVERSE_ESTENSIONE.ps1
#    R115 -- due misure, un pacchetto:
#      (a) LEVA REVERSE sul DAX (InpAllowReverse false vs true), A/B a
#          TRE celle (00 vivo / 01 bilat / 02 reverse) per non cambiare
#          due cose insieme -- vedi criteri par. 1.
#      (b) ESTENSIONE del RETEST (GEOMETRIA NATIVA per simbolo, firma
#          Claudio 29/08) su Nasdaq e Dow,
#          due lati ciascuno (REGOLA DEI DUE LATI, 25/08).
#    7 celle, 3 EA, 3 simboli. Ogni cella = coppia gemella su InpMagic.
# ---------------------------------------------------------------------
#  CRITERI:  backtest_pipeline\risultati_archivio\R115_CRITERI.md
#  PROVE:    backtest_pipeline\prove\R115_{DAX_00_vivo,DAX_01_bilat,
#            DAX_02_reverse,NAS_00_long,NAS_01_short,DOW_00_long,
#            DOW_01_short}.txt
#  PAGINA:   backtest_pipeline\righe\RIGA_R115_DA_MANDARE.md
#
#  >>> I CRITERI SONO [DA` + `FIRMARE]. Questo driver LEGGE R115_CRITERI.md
#      AL PIN e, se ci trova ancora la stringa del lucchetto, la CORSA
#      VERA non parte (exit 2). Il GIRO A VUOTO (-SoloControllo) parte lo
#      stesso: non apre MT5, non produce numeri, e serve proprio a far
#      leggere i criteri prima di firmarli.
#
#  DA DOVE NASCE, dichiarato: ossatura da RIGA_PREOPEN_DAX.ps1
#  (MARCATORE_RIGA_PREOPEN_DAX_v1) -- guardie, gate, delega a
#  walkforward_generico.ps1, raccolta -- PIU' i gate di versione/magic di
#  RIGA_R108_BB_M15.ps1. Differenza dichiarata: NON c'e' griglia (e' una
#  CELLA per lavoro), e ci sono TRE EA invece di uno, quindi il gate di
#  versione e la compilazione girano per ciascuno.
#
#  COSA FA, in ordine, e DA SOLA:
#    0.  si rifiuta di partire se MT5 O MetaEditor sono aperti
#    0b. si rifiuta di CORRERE se i criteri non sono firmati (lucchetto)
#    1.  scarica AL PIN: walkforward_generico.ps1 (e lo PINNA), i 7 file
#        prova, i 3 sorgenti EA, l'include ABTG_PausaGuardian.mqh
#        - GATE DI VERSIONE per EA (marcatore preso DAL SORGENTE):
#          InpEntryMode/ABTG_RETEST e InpRangeMode esistono; il DAX HA
#          InpAllowReverse, Nasdaq/Dow NON ce l'hanno (se sparisse o
#          comparisse, un parametro orfano verrebbe ignorato in silenzio)
#    2.  GATE SUI FILE PROVA (prima di aprire MT5):
#        - geometria: @SIMBOLO/@PERIODO/@DAQUANDO
#        - FUSO: InpSessionHour = 8 (DAX) / 14 (US), MAI l'ora italiana
#        - baseline: InpEntryMode=2, InpRangeMode=0, RangeMinutes=35,
#          Buffer=500, RetestOffset=200, Risk=0.65
#        - lati e reverse: i valori ATTESI del lavoro (gate dei VALORI:
#          vede due file scambiati, che un diff non vede)
#        - STELLA: contro la baseline del suo EA cambia SOLO i delta
#          dichiarati (+ InpMagic + sessione/simbolo)
#        - MAGIC: vergini (766xxx), unici, mai un magic vietato; asse Y
#          e' InpMagic (coppia gemella)
#    3.  la corsa di ogni cella e' delegata a walkforward_generico.ps1
#        (che compila l'EA al pin, risolve TUTTI gli input, scrive l'.ini
#        a Modello 4, spezza IS/OOS 40/60 e scrive i CSV). Il driver
#        legge i CSV, controlla i GEMELLI e mette i numeri a referto.
#    4.  raccolta SEMPRE: cartella sul Desktop + zip + REFERTO con la
#        tabella e i tre confronti del reverse gia' impostati.
#
#  QUELLO CHE NON FA, dichiarato:
#    - NON tocca i .mq5. Reverse e retest sono interruttori gia' nel
#      sorgente (InpAllowReverse riga 272 del DAX; InpEntryMode=2 = retest).
#    - NON GIUDICA il merito: PF/aspettativa/DD li mette a referto, il
#      verdetto lo scrive la lettura del round a mano (criteri par. 5).
#    - NON promuove niente e NON tocca il forward (G5). Magic VERGINI
#      766xxx (blocco verificato libero in tutto il repo il 29/08).
#    - NON misura lo spread (Spread=0 dichiarato) ne' il margine prop.
#
#  LA RIGA CHE SI INCOLLA sta in righe\RIGA_R115_DA_MANDARE.md
#  (un comando solo, irm al pin + Select-String del marcatore + run).
# =====================================================================
# >>> [CmdletBinding()] NON E' DECORAZIONE: un .ps1 col solo param() NON
#     rifiuta i parametri che non conosce, li infila in $args e tira
#     dritto in silenzio. Un "-SoloControlo" con una L sola sarebbe LA
#     CORSA VERA. Con [CmdletBinding()] e' un errore di binding e lo
#     script muore PRIMA di aprire MT5.
[CmdletBinding()]
param(
  # -Pin NON ha default: un default silenzioso ("lavoro") farebbe girare
  #  la punta del branch spacciandola per un commit congelato. Meglio morire.
  [string]$Pin          = "",
  [double]$OreMax       = 12.0,          # oltre questo NON si iniziano nuovi lavori
  [switch]$SoloControllo,                # giro a vuoto: NON apre MT5
  [switch]$Rifai,                        # rifa' anche i CSV gia' presenti
  [string]$SoloLavoro   = "",            # una o piu' celle, FRA APICI:
                                         #  'DAX_02_reverse' o 'NAS_00_long DOW_00_long'
  [int]$Deposito        = 100000,
  [int]$Spread          = 0              # 0 = spread CORRENTE, ma SCRITTO nell'ini
)
$ErrorActionPreference = "Stop"
# --- RETE DI SICUREZZA SUL CODICE D'USCITA (lezione PREOPEN, 28/08): un
#     errore fuori dai try faceva morire lo script e pwsh usciva 0 -- una
#     corsa esplosa che si presenta come riuscita. Con questo trap
#     un'uscita anomala e' SEMPRE 1.
trap {
  Write-Host ""
  Write-Host ("!!! ERRORE NON GESTITO: " + $_.Exception.Message) -ForegroundColor Red
  Write-Host ("    " + $_.InvocationInfo.PositionMessage) -ForegroundColor DarkRed
  Write-Host "ESITO: FERMATO (errore non gestito) -- il referto potrebbe essere incompleto." -ForegroundColor Red
  exit 1
}
[Threading.Thread]::CurrentThread.CurrentCulture   = [Globalization.CultureInfo]::InvariantCulture
[Threading.Thread]::CurrentThread.CurrentUICulture = [Globalization.CultureInfo]::InvariantCulture
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$INV = [Globalization.CultureInfo]::InvariantCulture

$Avvio  = Get-Date
$Stamp  = $Avvio.ToString("yyyyMMdd_HHmm", $INV)
$Dsk    = Join-Path $env:USERPROFILE "Desktop"
$Work   = Join-Path $env:USERPROFILE "abtg_r115"
$Prove  = Join-Path $Work "prove"
$RawPin = "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$Pin"

# --- FINESTRA E BANCO (criteri par. 4). Numeri con la loro fonte accanto.
$DaQuando = "2024.09.26"     # pavimento TICK, sonda 17/08 (verdetto COMPLETO)
$Fino     = "2026.06.30"
$Periodo  = "M5"             # TF delle sedie apertura vive
$FrazioneIS = 0.40          # split 40/60, LO STESSO di R101/R103 (metro DAX vivo)

# --- IL LUCCHETTO DEI CRITERI. Fisso (SimpleMatch). Finche' esiste nel
#     file, la corsa vera non parte.
$LucchettoCriteri = "[DA FIRMARE]"
$FileCriteriRel   = "backtest_pipeline/risultati_archivio/R115_CRITERI.md"

# --- I MAGIC VIETATI. Un'identita' non in campo resta comunque occupata.
#     Le sedie APERTURA vive (770101 DAX, 770111 DAX Ottimizzato, 770201
#     Nasdaq, 770202 Dow), le altre vive sul DAX/US, i magic dei round
#     recenti e i default degli altri EA. Riusarli mescolerebbe i deal di
#     due misure nella cache del tester e negli export per-trade (che
#     portano il magic nel nome).
$MagicVietati = @(770101,770111,770201,770202,770411,770402,770511,770601,770611,770901,770532,
                  971501,970901,970912,970913,
                  760270,760271,760280,760281,                 # <<< R103 aperture (gemelli, questa geometria)
                  773200,773201,773230,773231,773300,773301,   # R101 metri
                  773500,773501,773600,773601,773700,773701,   # PREOPEN DOW (28/08)
                  773800,773801,773900,773901,
                  782100,782101,782200,782201,782300,782301,   # PREOPEN NAS (28/08)
                  782400,782401,782500,782501,
                  761000,761001,761010,761011,761100,761101,   # R107
                  761110,761111,761200,761201,761210,761211,
                  762000,762010,762020,762030,762040,762050,   # R108
                  750010,750011,772341,772601,772602,772611,772612,
                  774401,775501,776000,776001,776100,776101,776400,776401)

# =====================================================================
#  I 7 LAVORI. Ogni riga: id, file prova, EA, simbolo, ora server attesa,
#  i tre valori ATTESI (long/short/reverse) e i magic gemelli. Il gate
#  dei VALORI li confronta col file prova: prende due file SCAMBIATI, che
#  il gate della stella (che guarda i DELTA) per costruzione non vede.
#  'Rev' = "" quando l'EA non ha InpAllowReverse (Nasdaq/Dow): allora la
#  riga NON deve esistere nel file prova.
# =====================================================================
function L([string]$id,[string]$file,[string]$ea,[string]$sym,[int]$sh,
          [string]$vl,[string]$vs,[string]$vr,[int]$m1,[int]$m2,[string]$desc){
  return [pscustomobject]@{
    Id=$id; Prova=$file; Ea=$ea; Sym=$sym; ShAtt=$sh;
    VLong=$vl; VShort=$vs; VRev=$vr; M1=$m1; M2=$m2; Desc=$desc;
    # --- riempiti durante la corsa ---
    Esito="NON ESEGUITA"; RigheIS=-1; RigheOOS=-1; DatiIS=$null; DatiOOS=$null;
    Gem="NON MISURATO";
    PfOOS=-1.0; DdOOS=-1.0; NOOS=-1; ProfOOS=-999999.0; AspOOS=-999999.0;
    PfIS=-1.0;  DdIS=-1.0;  NIS=-1;  ProfIS=-999999.0
  }
}
$LAVORI = @(
  (L "DAX_00_vivo"    "R115_DAX_00_vivo.txt"    "ABTG_DAX_Apertura_EU"    "D30EUR" 8  "true"  "false" "false" 766010 766011 "LEVA REVERSE -- A (la 770101 viva: long-only, reverse off). BASELINE."),
  (L "DAX_01_bilat"   "R115_DAX_01_bilat.txt"   "ABTG_DAX_Apertura_EU"    "D30EUR" 8  "true"  "true"  "false" 766020 766021 "LEVA REVERSE -- A' (due lati, reverse off): isola il costo del solo primo ciclo short."),
  (L "DAX_02_reverse" "R115_DAX_02_reverse.txt" "ABTG_DAX_Apertura_EU"    "D30EUR" 8  "true"  "true"  "true"  766030 766031 "LEVA REVERSE -- B (reverse acceso). L'A/B a UNA variabile e' 01 vs 02."),
  (L "NAS_00_long"    "R115_NAS_00_long.txt"    "ABTG_Nasdaq_Apertura_US" "NASUSD" 14 "true"  "false" ""      766110 766111 "ESTENSIONE retest, GEOMETRIA NATIVA Nasdaq (retest INFERITO), lato LONG."),
  (L "NAS_01_short"   "R115_NAS_01_short.txt"   "ABTG_Nasdaq_Apertura_US" "NASUSD" 14 "false" "true"  ""      766120 766121 "ESTENSIONE retest, GEOMETRIA NATIVA Nasdaq (retest INFERITO), lato SHORT."),
  (L "DOW_00_long"    "R115_DOW_00_long.txt"    "ABTG_Dow_Apertura_US"    "U30USD" 14 "true"  "false" ""      766210 766211 "ESTENSIONE retest, GEOMETRIA NATIVA Dow (= 770202 vivo, gia' retest), lato LONG."),
  (L "DOW_01_short"   "R115_DOW_01_short.txt"   "ABTG_Dow_Apertura_US"    "U30USD" 14 "false" "true"  ""      766220 766221 "ESTENSIONE retest, GEOMETRIA NATIVA Dow (= 770202 vivo), lato SHORT.")
)

# --- LA BASELINE PER EA (per il gate della stella): il file 00/long del
#     suo EA. I DELTA ammessi rispetto alla baseline, oltre a InpMagic:
#       DAX_01 : InpAllowShort
#       DAX_02 : InpAllowShort, InpAllowReverse
#       *_short: InpAllowLong, InpAllowShort
$BaselineDi = @{}
$BaselineDi["ABTG_DAX_Apertura_EU"]    = "R115_DAX_00_vivo.txt"
$BaselineDi["ABTG_Nasdaq_Apertura_US"] = "R115_NAS_00_long.txt"
$BaselineDi["ABTG_Dow_Apertura_US"]    = "R115_DOW_00_long.txt"
$DeltaDi = @{}
$DeltaDi["DAX_00_vivo"]    = @()
$DeltaDi["DAX_01_bilat"]   = @("InpAllowShort")
$DeltaDi["DAX_02_reverse"] = @("InpAllowShort","InpAllowReverse")
$DeltaDi["NAS_00_long"]    = @()
$DeltaDi["NAS_01_short"]   = @("InpAllowLong","InpAllowShort")
$DeltaDi["DOW_00_long"]    = @()
$DeltaDi["DOW_01_short"]   = @("InpAllowLong","InpAllowShort")

# --- LA GEOMETRIA ATTESA, PER EA (firma Claudio 29/08: NATIVA per simbolo,
#     non geometria-DAX sugli US). E' il metro contro cui si legge ogni
#     file prova, e prende il baseline nativo CORROTTO (che la stella, che
#     guarda solo i delta fra celle dello stesso EA, per costruzione non
#     vede). Valori LETTI: DAX = 770101 vivo; Dow = 770202 vivo (retest,
#     R103); Nasdaq = preset live ABTG_Nasdaq_Apertura_US.set + overlay H4
#     (retest INFERITO -- la sedia viva Nasdaq e' breakout).
$GeoEA = @{}
$GeoEA["ABTG_DAX_Apertura_EU"]    = @{ RangeMode="0"; RangeMin="35"; Buffer="500.0";  Offset="200.0"; Ema="false"; CloseH="17" }
$GeoEA["ABTG_Nasdaq_Apertura_US"] = @{ RangeMode="2"; RangeMin="15"; Buffer="300.0";  Offset="0.0";   Ema="true";  CloseH="20" }
$GeoEA["ABTG_Dow_Apertura_US"]    = @{ RangeMode="0"; RangeMin="35"; Buffer="1000.0"; Offset="400.0"; Ema="true";  CloseH="17" }

# =====================================================================
#  TUTTO CIO' CHE LA RACCOLTA USA NASCE QUI, PRIMA DEL try (in PowerShell
#  una function e' un'ISTRUZIONE: se il flusso non ci passa sopra il nome
#  non esiste, e la raccolta esploderebbe proprio nella corsa fermata da
#  un gate -- l'unica in cui il referto serve).
# =====================================================================
$Problemi  = New-Object System.Collections.ArrayList
$Rilievi   = New-Object System.Collections.ArrayList
$RefTxt    = New-Object System.Collections.ArrayList
$Fatale    = ""
$Include   = "NON INSTALLATO"
$Terminale = "n/d"
$LucchettoStato = "NON LETTO"
$RiskEA    = "n/d"
$IS_Da="n/d"; $IS_A="n/d"; $OOS_Da="n/d"; $OOS_A="n/d"
$Modo      = "CORSA"; if($SoloControllo){ $Modo = "CONTROLLO" }
$drv       = ""
$Selezione = @()

function Ora(){ return (Get-Date).ToString("HH:mm:ss", $INV) }
function Dico([string]$t,[string]$c="Gray"){ Write-Host ("[" + (Ora) + "] " + $t) -ForegroundColor $c }
function Titolo([string]$t){ Write-Host ""; Write-Host ("=== " + $t + " ===") -ForegroundColor Cyan }
function ScriviRef([string]$t){ [void]$RefTxt.Add($t) }

function Scarica([string]$url,[string]$dest){
  Remove-Item -LiteralPath $dest -Force -ErrorAction SilentlyContinue
  Invoke-WebRequest -Uri $url -OutFile $dest -UseBasicParsing -ErrorAction Stop
  if(-not (Test-Path -LiteralPath $dest)){ throw ("scarico fallito: " + $url) }
}
function RigheVive([string]$p){
  return @(Get-Content -LiteralPath $p | Where-Object { $_ -notmatch '^\s*#' -and $_ -notmatch '^\s*$' })
}
function NumInv($s){
  $v = 0.0
  $t = ("" + $s).Replace([string][char]160,"").Replace([string][char]8239,"").Replace([string][char]8201,"").Replace(" ","").Trim()
  if($t -eq ""){ return $null }
  if([double]::TryParse($t,[Globalization.NumberStyles]::Float,$INV,[ref]$v)){ return $v }
  return $null
}
# --- SENTINELLA su TUTTE le colonne: un numero non misurato non deve MAI
#     uscire come numero plausibile. "n/d", non "0.000".
function FmtN($v){ if($null -eq $v){ return "n/d" }; if([int]$v -lt 0){ return "n/d" }; return ([int]$v).ToString($INV) }
function Fmt2($v){ if($null -eq $v){ return "n/d" }; if([double]$v -lt 0){ return "n/d" }; return ([double]$v).ToString("0.00",$INV) }
function Fmt3($v){ if($null -eq $v){ return "n/d" }; if([double]$v -lt 0){ return "n/d" }; return ([double]$v).ToString("0.000",$INV) }
function FmtE($v){ if($null -eq $v){ return "n/d" }; if([double]$v -le -999998.0){ return "n/d" }; return ([double]$v).ToString("+0.00;-0.00;0.00",$INV) }

# --- GATE SULLE DATE (una finestra sbagliata non risponde alla domanda,
#     e MT5 con un ToDate invalido non e' nemmeno un errore rumoroso).
function GateDate([string]$eti,[string]$da,[string]$a){
  if($da -notmatch '^\d{4}\.\d{2}\.\d{2}$'){ throw ($eti + ": FromDate non e' 'aaaa.mm.gg' ma [" + $da + "].") }
  if($a  -notmatch '^\d{4}\.\d{2}\.\d{2}$'){ throw ($eti + ": ToDate non e' 'aaaa.mm.gg' ma [" + $a + "].") }
  $d1=[datetime]::MinValue; $d2=[datetime]::MinValue
  if(-not [datetime]::TryParseExact($da,"yyyy.MM.dd",$INV,[Globalization.DateTimeStyles]::None,[ref]$d1)){ throw ($eti + ": FromDate [" + $da + "] non e' un giorno che esiste.") }
  if(-not [datetime]::TryParseExact($a ,"yyyy.MM.dd",$INV,[Globalization.DateTimeStyles]::None,[ref]$d2)){ throw ($eti + ": ToDate [" + $a + "] non e' un giorno che esiste.") }
  if($d2 -le $d1){ throw ($eti + ": ToDate (" + $a + ") non e' DOPO FromDate (" + $da + ").") }
}

# --- IL PARSER DEL CSV DI OTTIMIZZAZIONE. Colonne PER NOME, mai per
#     posizione. Se non le riconosce torna $null e DICE quali ha visto.
$script:CsvIntestazioni = @()
function LeggiOpt([string]$path){
  if(-not (Test-Path -LiteralPath $path)){ return $null }
  $righe=@(); try{ $righe = @(Import-Csv -LiteralPath $path) }catch{ return $null }
  if($righe.Count -eq 0){ return $null }
  $cols=@($righe[0].PSObject.Properties.Name); $script:CsvIntestazioni=$cols
  $kProf=$null;$kPf=$null;$kDd=$null;$kN=$null;$kPg=$null;$kMg=$null
  foreach($k in $cols){
    $l=("" + $k).Trim().ToLower()
    if($l -eq "profit" -or $l -eq "profitto"){ $kProf=$k }
    if($l -eq "profit factor" -or $l -eq "fattore di profitto"){ $kPf=$k }
    if($l -eq "equity dd %" -or $l -eq "drawdown equity %"){ $kDd=$k }
    if($l -eq "trades" -or $l -eq "operazioni"){ $kN=$k }
    if($l -eq "peggior giornata %" -or $l -eq "worst day %"){ $kPg=$k }
    if($l -eq "inpmagic"){ $kMg=$k }
  }
  if($null -eq $kProf -or $null -eq $kPf -or $null -eq $kDd -or $null -eq $kN){ return $null }
  $out=New-Object System.Collections.ArrayList
  foreach($r in $righe){
    $pg=$null; if($null -ne $kPg){ $pg=(NumInv $r.$kPg) }
    $mg="";    if($null -ne $kMg){ $mg=("" + $r.$kMg).Trim() }
    [void]$out.Add([pscustomobject]@{
      Profit=(NumInv $r.$kProf); Pf=(NumInv $r.$kPf); Dd=(NumInv $r.$kDd)
      N=(NumInv $r.$kN); Pg=$pg; Magic=$mg })
  }
  return @($out)
}
# --- I GEMELLI: le due righe devono uscire IDENTICHE AL CENTESIMO. E' il
#     controllo d'igiene del banco: se non lo sono, il tester non e'
#     deterministico e nessun numero di quella cella si legge.
function Gemelli($righe){
  if($null -eq $righe){ return "NON MISURATO (CSV non letto)" }
  if(@($righe).Count -ne 2){ return ("NON VALIDO: " + @($righe).Count + " righe invece di 2") }
  $a=$righe[0]; $b=$righe[1]
  foreach($ch in @(@("profitto",$a.Profit,$b.Profit),@("PF",$a.Pf,$b.Pf),@("DD",$a.Dd,$b.Dd),@("n",$a.N,$b.N))){
    if($null -eq $ch[1] -or $null -eq $ch[2]){ return ("NON MISURATO (" + $ch[0] + " illeggibile)") }
    if([math]::Abs([double]$ch[1]-[double]$ch[2]) -gt 0.005){ return ("DIVERSI su " + $ch[0] + ": " + $ch[1] + " contro " + $ch[2]) }
  }
  return "IDENTICI"
}

# =====================================================================
#  CORPO
# =====================================================================
try{
  Titolo "R115 -- LEVA REVERSE (DAX) + ESTENSIONE RETEST (Nasdaq, Dow)"
  if($Pin -notmatch '^[0-9a-f]{40}$'){ throw ("-Pin deve essere un commit di 40 caratteri esadecimali, ricevuto: [" + $Pin + "]") }

  # 0. GUARDIA MT5/MetaEditor
  if(Get-Process terminal64,metaeditor64 -ErrorAction SilentlyContinue){
    throw "MT5 O METAEDITOR APERTO: col terminale aperto il tester non gira (zero CSV), con MetaEditor aperto la compilazione torna subito senza compilare."
  }
  GateDate "argomenti della riga" $DaQuando $Fino
  $dtIn=[datetime]::ParseExact($DaQuando,"yyyy.MM.dd",$INV)
  $dtFi=[datetime]::ParseExact($Fino,"yyyy.MM.dd",$INV)
  $dtMet=$dtIn.AddDays([math]::Floor(($dtFi-$dtIn).TotalDays*$FrazioneIS))
  $IS_Da=$dtIn.ToString("yyyy.MM.dd",$INV); $IS_A=$dtMet.ToString("yyyy.MM.dd",$INV)
  $OOS_Da=$dtMet.AddDays(1).ToString("yyyy.MM.dd",$INV); $OOS_A=$dtFi.ToString("yyyy.MM.dd",$INV)

  # quali lavori girano in questo lancio
  $Selezione = @($LAVORI)
  if($SoloLavoro.Trim() -ne ""){
    $chiesti = @($SoloLavoro -split '[,\s]+' | Where-Object { $_ -ne "" })
    $Selezione = @($LAVORI | Where-Object { $chiesti -contains $_.Id })
    foreach($c in $chiesti){ if(-not (@($LAVORI.Id) -contains $c)){ throw ("-SoloLavoro '" + $c + "' non esiste. Validi: " + ($LAVORI.Id -join ", ")) } }
  }

  Dico ("pin ......... " + $Pin)
  Dico ("modo ........ " + $Modo + $(if($SoloControllo){ "  (NON apre MT5, non misura numeri)" } else { "" }))
  Dico ("finestra .... " + $DaQuando + " -> " + $Fino + "   (M5, tick reali, deposito " + $Deposito + ", Spread=" + $Spread + ")")
  Dico ("   IS ....... " + $IS_Da + " - " + $IS_A + "   (split 40/60, come R101/R103)")
  Dico ("   OOS ...... " + $OOS_Da + " - " + $OOS_A)
  Dico ("lavori ...... " + (@($Selezione.Id) -join ", "))

  New-Item -ItemType Directory -Force -Path $Work,$Prove | Out-Null

  # -------------------------------------------------------------------
  #  0b. IL LUCCHETTO DEI CRITERI
  # -------------------------------------------------------------------
  Titolo "0b. CRITERI (lucchetto)"
  $critFile = Join-Path $Work "R115_CRITERI.md"
  Scarica ($RawPin + "/" + $FileCriteriRel) $critFile
  $locked = (Select-String -LiteralPath $critFile -SimpleMatch -Pattern $LucchettoCriteri -Quiet)
  if($locked){
    $LucchettoStato = "CHIUSO (i criteri contengono ancora '" + $LucchettoCriteri + "')"
    Dico ("criteri: " + $LucchettoStato) "Yellow"
    if(-not $SoloControllo){
      [void]$Rilievi.Add("CORSA VERA NON PARTITA: i criteri R115 non sono ancora firmati (lucchetto presente nel file dei criteri). Tolto il lucchetto (firma di Claudio), si rilancia.")
      Titolo "FERMO: criteri non firmati -- corsa vera bloccata (exit 2)"
      Write-Host "Il GIRO A VUOTO invece prosegue con -SoloControllo: verifica gate e .ini senza aprire MT5." -ForegroundColor Yellow
      # la raccolta gira lo stesso, sotto: qui si esce PULITO con 2
      throw "___LUCCHETTO___"
    }
  } else {
    $LucchettoStato = "APERTO (firmati)"
    Dico ("criteri: " + $LucchettoStato) "Green"
  }

  # -------------------------------------------------------------------
  #  1. SCARICO AL PIN
  # -------------------------------------------------------------------
  Titolo "1. SCARICO AL PIN"
  $drv = Join-Path $Work "walkforward_generico.ps1"
  Scarica ($RawPin + "/backtest_pipeline/walkforward_generico.ps1") $drv
  $txtDrv = Get-Content -LiteralPath $drv -Raw
  if($txtDrv -notmatch '\$EABranch\s*=\s*"lavoro"'){ throw "walkforward_generico.ps1 non ha la riga \$EABranch attesa: non lo posso pinnare." }
  $txtDrv = $txtDrv -replace '\$EABranch\s*=\s*"lavoro"', ('$EABranch="' + $Pin + '"')
  Set-Content -LiteralPath $drv -Value $txtDrv -Encoding ASCII
  Dico "driver generico scaricato e PINNATO (riscarica gli EA al pin, non dalla punta del branch)" "Green"

  # i 7 file prova
  foreach($lv in $LAVORI){ Scarica ($RawPin + "/backtest_pipeline/prove/" + $lv.Prova) (Join-Path $Prove $lv.Prova) }
  Dico ("file prova scaricati: " + @(Get-ChildItem -LiteralPath $Prove -Filter 'R115_*.txt').Count + " (tutti e sette servono ai gate della stella, anche se gira un lavoro solo)") "Green"

  $incSrc = Join-Path $Work "ABTG_PausaGuardian.mqh"
  Scarica ($RawPin + "/mql5/Include/ABTG_PausaGuardian.mqh") $incSrc
  Dico ("include scaricato: ABTG_PausaGuardian.mqh (" + (Get-Item -LiteralPath $incSrc).Length + " byte)") "Green"

  # -------------------------------------------------------------------
  #  1b. GATE DI VERSIONE, PER EA (marcatore preso DAL SORGENTE)
  # -------------------------------------------------------------------
  Titolo "1b. GATE DI VERSIONE (3 EA)"
  $EaUsati = @($Selezione.Ea | Select-Object -Unique)
  foreach($ea in $EaUsati){
    $mq5 = Join-Path $Work ($ea + ".mq5")
    Scarica ($RawPin + "/mql5/Experts/" + $ea + ".mq5") $mq5
    $src = Get-Content -LiteralPath $mq5 -Raw
    if($src -notmatch 'InpEntryMode'){ throw ($ea + ": nel sorgente al pin non c'e' InpEntryMode.") }
    if($src -notmatch 'ABTG_RETEST'){  throw ($ea + ": nel sorgente al pin non c'e' l'enum ABTG_RETEST: il motore che il round misura non esiste in questa versione.") }
    if($src -notmatch 'InpRangeMode'){ throw ($ea + ": nel sorgente al pin non c'e' InpRangeMode.") }
    if($ea -eq "ABTG_DAX_Apertura_EU"){
      if($src -notmatch 'InpAllowReverse'){ throw "ABTG_DAX_Apertura_EU: nel sorgente al pin non c'e' InpAllowReverse -- il file prova DAX_02 lo pinna, un parametro orfano verrebbe ignorato IN SILENZIO da MT5 e l'A/B sarebbe nullo." }
    } else {
      if($src -match 'InpAllowReverse'){ throw ($ea + ": il sorgente al pin HA InpAllowReverse, ma i file prova " + $ea + " NON lo pinnano (l'EA US non doveva averlo). Se e' comparso, il perimetro del round va rivisto.") }
    }
    Dico ($ea + ": InpEntryMode/ABTG_RETEST/InpRangeMode presenti; InpAllowReverse " + $(if($ea -eq "ABTG_DAX_Apertura_EU"){"PRESENTE (giusto)"}else{"ASSENTE (giusto)"})) "Green"
  }

  # -------------------------------------------------------------------
  #  2. GATE SUI FILE PROVA -- prima di aprire MT5
  # -------------------------------------------------------------------
  Titolo "2. GATE SUI FILE PROVA"
  $mappe = @{}
  $magicVisti = @{}
  foreach($lv in $LAVORI){
    $righeF = RigheVive (Join-Path $Prove $lv.Prova)
    $h = @{}; $nY = 0; $nomiY = New-Object System.Collections.ArrayList
    foreach($rr in $righeF){
      if($rr -match '^@'){ $parti=($rr -split '\s+',2); $h[$parti[0]]=$parti[1].Trim(); continue }
      $ie = $rr.IndexOf("="); if($ie -lt 0){ continue }
      $nome=$rr.Substring(0,$ie).Trim(); $val=$rr.Substring($ie+1).Trim()
      if($h.ContainsKey($nome)){ throw ($lv.Prova + ": DUE righe per '" + $nome + "'. In [TesterInputs] un parametro doppio fa fare a MT5 ZERO passate.") }
      $h[$nome]=$val
      if($val -match '\|\|\s*[Yy]\s*$'){ $nY++; [void]$nomiY.Add($nome) }
    }
    if($nY -lt 1){ throw ($lv.Prova + ": nessun asse con flag Y.") }
    if(-not (@($nomiY) -contains "InpMagic")){ throw ($lv.Prova + ": InpMagic non e' spazzolato. Lo sweep gemello sui due magic e' l'igiene del banco.") }
    if(@($nomiY).Count -ne 1){ throw ($lv.Prova + ": l'unico asse Y deve essere InpMagic, invece sono " + @($nomiY).Count + " (" + (@($nomiY) -join ", ") + "). E' una CELLA, non una griglia.") }
    $mappe[$lv.Prova]=$h
  }

  foreach($lv in $LAVORI){
    $h = $mappe[$lv.Prova]
    # GEOMETRIA
    if($h["@SIMBOLO"]  -ne $lv.Sym){     throw ($lv.Prova + ": @SIMBOLO e' " + $h["@SIMBOLO"] + ", atteso " + $lv.Sym) }
    if($h["@PERIODO"]  -ne $Periodo){    throw ($lv.Prova + ": @PERIODO e' " + $h["@PERIODO"] + ", atteso " + $Periodo) }
    if($h["@DAQUANDO"] -ne $DaQuando){   throw ($lv.Prova + ": @DAQUANDO e' " + $h["@DAQUANDO"] + ", atteso " + $DaQuando) }
    # FUSO -- ORA SERVER, MAI l'italiana
    $sh = ($h["InpSessionHour"] -split '\|\|')[0]
    if([int]$sh -ne $lv.ShAtt){
      $italiana = $lv.ShAtt + 1
      throw ($lv.Prova + ": InpSessionHour e' " + $sh + ", atteso " + $lv.ShAtt + " (ORA SERVER BCM). " + $italiana + " sarebbe l'ora italiana: cestinare (CLAUDE.md, FUSO ORARIO BCM).")
    }
    # BASELINE COMUNE (tutte e 7): il retest e' la tesi, la taglia e'
    # uniforme (DD comparabile), mai overnight.
    if(($h["InpEntryMode"]   -split '\|\|')[0] -ne "2"){     throw ($lv.Prova + ": InpEntryMode deve essere 2 (RETEST): e' la tesi del round.") }
    if(($h["InpRiskPercent"] -split '\|\|')[0] -ne "0.65"){  throw ($lv.Prova + ": InpRiskPercent deve essere 0.65 (taglia uniforme, DD comparabile).") }
    if(($h["InpCloseAtEnd"]  -split '\|\|')[0] -ne "true"){  throw ($lv.Prova + ": InpCloseAtEnd deve essere true (intraday, mai overnight).") }
    # GEOMETRIA NATIVA PER EA (firma 29/08). Il metro e' $GeoEA, LETTO dai
    # config vivi (DAX 770101 / Dow 770202 / Nasdaq preset+H4). Prende il
    # baseline nativo corrotto, che la stella non vede.
    $geo = $GeoEA[$lv.Ea]
    if($null -eq $geo){ throw ($lv.Prova + ": nessuna geometria attesa per l'EA " + $lv.Ea) }
    if(($h["InpRangeMode"]      -split '\|\|')[0] -ne $geo.RangeMode){ throw ($lv.Prova + ": InpRangeMode e' " + (($h["InpRangeMode"] -split '\|\|')[0]) + ", la geometria nativa di " + $lv.Ea + " lo vuole " + $geo.RangeMode + ".") }
    if(($h["InpRangeMinutes"]   -split '\|\|')[0] -ne $geo.RangeMin){  throw ($lv.Prova + ": InpRangeMinutes e' " + (($h["InpRangeMinutes"] -split '\|\|')[0]) + ", nativa " + $lv.Ea + " = " + $geo.RangeMin + ".") }
    if(($h["InpBufferPoints"]   -split '\|\|')[0] -ne $geo.Buffer){    throw ($lv.Prova + ": InpBufferPoints e' " + (($h["InpBufferPoints"] -split '\|\|')[0]) + ", nativa " + $lv.Ea + " = " + $geo.Buffer + ".") }
    if(($h["InpRetestOffsetPts"]-split '\|\|')[0] -ne $geo.Offset){    throw ($lv.Prova + ": InpRetestOffsetPts e' " + (($h["InpRetestOffsetPts"] -split '\|\|')[0]) + ", nativa " + $lv.Ea + " = " + $geo.Offset + ".") }
    if(($h["InpUseEmaFilter"]   -split '\|\|')[0] -ne $geo.Ema){       throw ($lv.Prova + ": InpUseEmaFilter e' " + (($h["InpUseEmaFilter"] -split '\|\|')[0]) + ", nativa " + $lv.Ea + " = " + $geo.Ema + " (DAX EMA off; Dow/Nasdaq filtro H4 on).") }
    if(($h["InpCloseHour"]      -split '\|\|')[0] -ne $geo.CloseH){    throw ($lv.Prova + ": InpCloseHour e' " + (($h["InpCloseHour"] -split '\|\|')[0]) + ", nativa " + $lv.Ea + " = " + $geo.CloseH + " (Nasdaq chiude 20:45 server, DAX/Dow 17:30).") }
    # GATE DEI VALORI: lati e reverse (vede due file scambiati)
    $vl = ($h["InpAllowLong"]  -split '\|\|')[0]
    $vs = ($h["InpAllowShort"] -split '\|\|')[0]
    if($vl -ne $lv.VLong){  throw ($lv.Prova + ": InpAllowLong vale "  + $vl + ", il lavoro " + $lv.Id + " lo vuole " + $lv.VLong) }
    if($vs -ne $lv.VShort){ throw ($lv.Prova + ": InpAllowShort vale " + $vs + ", il lavoro " + $lv.Id + " lo vuole " + $lv.VShort) }
    if($lv.VRev -ne ""){
      if(-not $h.ContainsKey("InpAllowReverse")){ throw ($lv.Prova + ": manca InpAllowReverse (il DAX deve pinnarlo).") }
      $vr = ($h["InpAllowReverse"] -split '\|\|')[0]
      if($vr -ne $lv.VRev){ throw ($lv.Prova + ": InpAllowReverse vale " + $vr + ", il lavoro " + $lv.Id + " lo vuole " + $lv.VRev + ".") }
    } else {
      if($h.ContainsKey("InpAllowReverse")){ throw ($lv.Prova + ": ha InpAllowReverse, ma l'EA " + $lv.Ea + " NON ce l'ha: sarebbe un parametro orfano ignorato in silenzio da MT5.") }
    }
    # STELLA: contro la baseline del suo EA cambiano SOLO i delta dichiarati
    $hBase = $mappe[$BaselineDi[$lv.Ea]]
    $ammessi = @("InpMagic","InpAllowLong","InpAllowShort") + @($DeltaDi[$lv.Id])
    foreach($k in @($h.Keys)){
      if($k -match '^@'){ continue }
      if($ammessi -contains $k){ continue }
      if($hBase[$k] -ne $h[$k]){ throw ($lv.Prova + ": '" + $k + "' differisce dalla baseline " + $BaselineDi[$lv.Ea] + " e NON e' un delta dichiarato (" + (@($DeltaDi[$lv.Id]) -join ", ") + ").") }
    }
    if(@($h.Keys).Count -ne @($hBase.Keys).Count){ throw ($lv.Prova + ": ha " + @($h.Keys).Count + " righe, la baseline ne ha " + @($hBase.Keys).Count + ".") }
    # MAGIC: vergini, unici, mai vietati
    $mg = $h["InpMagic"] -split '\|\|'
    if([int]$mg[1] -ne $lv.M1 -or [int]$mg[3] -ne $lv.M2){ throw ($lv.Prova + ": magic gemelli " + $mg[1] + "/" + $mg[3] + ", il lavoro li vuole " + $lv.M1 + "/" + $lv.M2) }
    foreach($v in @($mg[1],$mg[3])){
      $nMg=[int]$v
      if($MagicVietati -contains $nMg){ throw ($lv.Prova + ": magic " + $nMg + " e' VIETATO (sedia viva, round recente o default di un altro EA).") }
      if($magicVisti.ContainsKey($nMg)){ throw ("magic " + $nMg + " usato in due file: " + $magicVisti[$nMg] + " e " + $lv.Prova) }
      $magicVisti[$nMg]=$lv.Prova
    }
  }
  Dico "geometria, fuso, baseline, lati/reverse, stella, magic: TUTTI PASSATI (7 file)" "Green"

  # -------------------------------------------------------------------
  #  3. LE CORSE, via walkforward_generico.ps1 (una CELLA per lavoro)
  # -------------------------------------------------------------------
  Titolo "3. LE CORSE (delega al driver generico)"
  $Risultati = Join-Path $Work "risultati_prove"
  foreach($lv in $Selezione){
    Titolo ("3. " + $lv.Id + " -- " + $lv.Desc)
    $argv = @("-ExecutionPolicy","Bypass","-File",$drv,
              "-Expert",$lv.Ea,
              "-Prova",(Join-Path $Prove $lv.Prova),
              "-Etichetta",$lv.Id,
              "-Simbolo",$lv.Sym,"-Periodo",$Periodo,
              "-DaQuando",$DaQuando,"-Fino",$Fino,
              "-FrazioneIS",("" + $FrazioneIS),
              "-Modello","4","-Deposito",("" + $Deposito),"-Spread",("" + $Spread))
    if($SoloControllo){ $argv += "-SoloControllo" }
    if($Rifai){ $argv += "-Rifai" }
    $global:LASTEXITCODE = 0
    & powershell $argv
    $rc = $LASTEXITCODE
    if($rc -ne 0){ $lv.Esito="FERMATA (codice " + $rc + ")"; [void]$Problemi.Add($lv.Id + ": il driver generico e' uscito con codice " + $rc); continue }
    if($SoloControllo){ $lv.Esito="CONTROLLO OK"; continue }

    $csvIS  = Join-Path $Risultati ($lv.Ea + "\" + $lv.Ea + "_" + $lv.Sym + "_IS_"  + $lv.Id + ".csv")
    $csvOOS = Join-Path $Risultati ($lv.Ea + "\" + $lv.Ea + "_" + $lv.Sym + "_OOS_" + $lv.Id + ".csv")
    $rIS=LeggiOpt $csvIS; $rOOS=LeggiOpt $csvOOS
    if($null -eq $rIS -or $null -eq $rOOS){
      $lv.Esito="CSV NON LEGGIBILE"; [void]$Problemi.Add($lv.Id + ": CSV mancante o intestazioni non riconosciute. Viste: " + ($script:CsvIntestazioni -join " | ")); continue
    }
    $lv.DatiIS=$rIS; $lv.DatiOOS=$rOOS; $lv.RigheIS=@($rIS).Count; $lv.RigheOOS=@($rOOS).Count
    $lv.Gem = (Gemelli $rOOS)
    if(@($rOOS).Count -ge 1){
      $r=$rOOS[0]; $lv.PfOOS=[double](if($null -ne $r.Pf){$r.Pf}else{-1.0}); $lv.DdOOS=[double](if($null -ne $r.Dd){$r.Dd}else{-1.0})
      $lv.NOOS=[int](if($null -ne $r.N){$r.N}else{-1}); $lv.ProfOOS=[double](if($null -ne $r.Profit){$r.Profit}else{-999999.0})
      if($null -ne $r.Profit -and $null -ne $r.N -and [double]$r.N -gt 0){ $lv.AspOOS=[double]$r.Profit/[double]$r.N }
    }
    if(@($rIS).Count -ge 1){
      $r=$rIS[0]; $lv.PfIS=[double](if($null -ne $r.Pf){$r.Pf}else{-1.0}); $lv.DdIS=[double](if($null -ne $r.Dd){$r.Dd}else{-1.0})
      $lv.NIS=[int](if($null -ne $r.N){$r.N}else{-1}); $lv.ProfIS=[double](if($null -ne $r.Profit){$r.Profit}else{-999999.0})
    }
    $lv.Esito="MISURATA"
    if(@($rOOS).Count -ne 2){ [void]$Problemi.Add($lv.Id + ": il CSV OOS ha " + @($rOOS).Count + " righe invece di 2 (gemelli). Cache del tester o celle mute: guardare prima di leggere.") }
  }
  Dico "corse concluse" "Green"
}
catch{
  if(("" + $_.Exception.Message) -eq "___LUCCHETTO___"){
    # uscita pulita del lucchetto: la raccolta gira, poi exit 2
  } else {
    $Fatale = ("" + $_.Exception.Message)
    Write-Host ""
    Write-Host ("!!! FERMATO: " + $Fatale) -ForegroundColor Red
  }
}

# =====================================================================
#  RACCOLTA -- SEMPRE, anche a round fermato. Cartella Desktop + zip +
#  referto. Regola di casa: ogni risultato per Claudio arriva sul Desktop
#  ed e' pronto in uno zip.
# =====================================================================
$NomeCart = "R115_" + $Modo + "_" + $Stamp
$Cart = Join-Path $Dsk $NomeCart
New-Item -ItemType Directory -Force -Path $Cart | Out-Null

ScriviRef "==============================================================="
ScriviRef ("R115 -- LEVA REVERSE (DAX) + ESTENSIONE RETEST (Nasdaq, Dow)")
ScriviRef ("REFERTO DEL DRIVER -- " + $Avvio.ToString("yyyy-MM-dd HH:mm:ss",$INV) + "  (modo " + $Modo + ")")
ScriviRef ("pin: " + $Pin)
ScriviRef "==============================================================="
ScriviRef ("criteri (lucchetto): " + $LucchettoStato)
ScriviRef ("banco: Modello 4 TICK REALI, deposito " + $Deposito + ", Spread=" + $Spread + " scritto nell'ini, rischio 0.65% (taglia viva)")
ScriviRef ("finestra: " + $DaQuando + " -> " + $Fino + "  (M5)")
ScriviRef ("   IS  " + $IS_Da + " - " + $IS_A)
ScriviRef ("   OOS " + $OOS_Da + " - " + $OOS_A + "   <- il pezzo che decide")
ScriviRef ("ORA SERVER usata (fuso BCM = IT - 1h): DAX 08:00 (InpSessionHour=8) | Nasdaq/Dow 14:30 (InpSessionHour=14, min 30)")
ScriviRef ""
if($Fatale -ne ""){ ScriviRef ("!!! ROUND FERMATO: " + $Fatale); ScriviRef "" }
ScriviRef "TABELLA (OOS = il verdetto; IS accanto come contesto). n/d = non misurato, MAI stimato."
ScriviRef "id               EA/simbolo/lato            gemelli   n(OOS)  PF(OOS)  DD%(OOS)  profitto(OOS)  asp/trade  | n(IS)  PF(IS)"
foreach($lv in $LAVORI){
  $sel = if(@($Selezione.Id) -contains $lv.Id){ "" } else { "  [non in questo lancio]" }
  ScriviRef (
    ("{0,-16} {1,-26} {2,-9} {3,6}  {4,7}  {5,8}  {6,13}  {7,9}  | {8,5}  {9,6}" -f `
      $lv.Id, ($lv.Sym + " " + $lv.VLong.Substring(0,1).ToUpper() + "/" + $lv.VShort.Substring(0,1).ToUpper()),
      $lv.Gem, (FmtN $lv.NOOS), (Fmt3 $lv.PfOOS), (Fmt2 $lv.DdOOS), (FmtE $lv.ProfOOS), (FmtE $lv.AspOOS),
      (FmtN $lv.NIS), (Fmt3 $lv.PfIS)) + $sel)
}
ScriviRef ""
ScriviRef "I TRE CONFRONTI DEL REVERSE (li scrive la lettura del round, a mano -- qui solo i numeri accostati):"
ScriviRef "  A  = DAX_00_vivo   (long-only, reverse off) = il forward di oggi"
ScriviRef "  A' = DAX_01_bilat  (due lati, reverse off)  -> A->A' = costo del solo primo ciclo SHORT"
ScriviRef "  B  = DAX_02_reverse(due lati + reverse)     -> A'->B = REVERSE PURO (A/B a una variabile)"
ScriviRef "  Regola (criteri par.5): la cattura extra di B NON deve peggiorare DD ne' peggior giornata di A'."
ScriviRef ""
ScriviRef "ESTENSIONE (b): Nasdaq/Dow reggono il retest solo con PF(OOS) >= 1.10 e DD sotto il muro."
ScriviRef "  Prior MISURATO (CACCIA_MOTORE_APERTURE, 02/08, altra geometria): Dow 0.94 / Nasdaq 0.73 (DD 27%) / DAX 0.79 -- bocciato."
ScriviRef ""
if($Rilievi.Count -gt 0){ ScriviRef "RILIEVI:"; foreach($r in $Rilievi){ ScriviRef ("  - " + $r) }; ScriviRef "" }
if($Problemi.Count -gt 0){ ScriviRef "PROBLEMI:"; foreach($p in $Problemi){ ScriviRef ("  - " + $p) }; ScriviRef "" }
ScriviRef "NOTA: questa e' una MISURA. Non promuove, non tocca il forward (G5). Il verdetto lo scrive la lettura di R115."

$RefPath = Join-Path $Cart ("R115_REFERTO_DRIVER_" + $Stamp + ".txt")
Set-Content -LiteralPath $RefPath -Value ($RefTxt -join "`r`n") -Encoding UTF8
Write-Host ""
$RefTxt | ForEach-Object { Write-Host $_ }

# copia i CSV misurati (se ci sono) e i file prova nello zip
$RisDir = Join-Path $Work "risultati_prove"
if(Test-Path -LiteralPath $RisDir){
  $dstCsv = Join-Path $Cart "csv"; New-Item -ItemType Directory -Force -Path $dstCsv | Out-Null
  Get-ChildItem -LiteralPath $RisDir -Recurse -Filter "*R115*.csv" -ErrorAction SilentlyContinue | ForEach-Object { Copy-Item -LiteralPath $_.FullName -Destination $dstCsv -Force }
}
$dstProve = Join-Path $Cart "prove"; New-Item -ItemType Directory -Force -Path $dstProve | Out-Null
Get-ChildItem -LiteralPath $Prove -Filter "R115_*.txt" -ErrorAction SilentlyContinue | ForEach-Object { Copy-Item -LiteralPath $_.FullName -Destination $dstProve -Force }

$zip = Join-Path $Dsk ($NomeCart + ".zip")
Remove-Item -LiteralPath $zip -Force -ErrorAction SilentlyContinue
Compress-Archive -Path (Join-Path $Cart "*") -DestinationPath $zip -Force
Write-Host ""
Write-Host ("Referto e artefatti sul Desktop: " + $Cart) -ForegroundColor Green
Write-Host ("Zip pronto da mandare: " + $zip) -ForegroundColor Green
Write-Host "File attesi nello zip: R115_REFERTO_DRIVER_*.txt + prove\R115_*.txt" -ForegroundColor Yellow
if(-not $SoloControllo){ Write-Host "  (+ csv\ con i CSV IS/OOS delle celle misurate)" -ForegroundColor Yellow }

# --- CODICE D'USCITA ESPLICITO SU OGNI RAMO
if($LucchettoStato -like "CHIUSO*" -and -not $SoloControllo){ exit 2 }
if($Fatale -ne ""){ exit 1 }
if($Problemi.Count -gt 0){ exit 3 }
exit 0
