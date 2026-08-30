# =====================================================================
#  MARCATORE_RIGA_FASE2_CASSA_v1
#  RIGA_FASE2_CASSA.ps1  --  FASE 2 CASSA: VALIDAZIONE A TICK REALI del
#  MOTORE DELLE APERTURE Nasdaq (drive-following) sulla cassaforte BCM.
#  ABTG_Nasdaq_Apertura_US  su  NASUSD (BCM LIVE)  M15, MODELLO 4 (TICK), 2 celle:
#     00_simm  SIMMETRICO (long+short) = IL CANDIDATO   magic 768100/768101
#     01_long  SOLO LONG (il metro dello short)         magic 768110/768111
# ---------------------------------------------------------------------
#  QUESTA E' LA CASSAFORTE, NON PIU' UNO SCREENING. La FASE 1 (OHLC
#  2017-2020 su NASUSD_EXT, referto REFERTO_FASE2_DRIVE_2026-08-30.md) ha
#  stabilito che il drive-following NUDO ha edge ed e' ROBUSTO PER REGIME
#  (verde in toro/orso/laterale/crollo, PF 1.32 su 832 trade). QUI si
#  conferma a TICK REALI su BCM che l'edge sopravvive a SPREAD e SLIPPAGE.
#  NON promuove niente, NON tocca il forward (G5): e' l'OOS del disegno a
#  due fasi, si apre UNA volta e NON si ottimizza.
#
#  ------------------------------------------------------------------
#  >>> LE INVERSIONI RISPETTO ALLA FASE 1 (adattato da FASE2_NAS_00_baseline,
#      NON riusato; ossatura driver da RIGA_FASE2_DRIVE.ps1 + il banco tick
#      di RIGA_R115). Ogni gate qui sotto PRETENDE il valore tick e RIFIUTA
#      quello della FASE 1:
#    - SIMBOLO NASUSD (BCM live), NON NASUSD_EXT. Model 4 (tick), NON 1.
#    - FUSO NORMALE BCM: InpSessionHour=14, InpSessionMin=30 (15:30 IT -1 =
#      14:30 server). Il gate PRETENDE 14/30 e RIFIUTA 9 -- e' l'OPPOSTO
#      della FASE 1 (li' 9:30 = apertura NY sul feed _EXT; qui il feed e' BCM
#      e vale la regola di casa IT-1=server).
#    - RISCHIO 0.65% (taglia di casa, DD comparabile), il gate RIFIUTA 1.0.
#    - PARZIALE RIMESSA (gestione prop): InpTP1_ClosePct=50 (il gate RIFIUTA
#      0), InpTP1_R=1.0, InpBreakevenAtTP1=true, InpRunnerTP_R=-1 (l'altra
#      meta' corre, no cap). Doma il DD 15.6% della diagnostica all-runner.
#    - SL floor InpMinStopPts=500 (R109, il gate RIFIUTA 0), InpSkipIfTight=
#      false (il pavimento si APPLICA, non fa saltare il trade).
#    - F1 e F3 SPENTI (bocciati in FASE 1): InpMinBreakoutRangeATR=0.0,
#      InpUseEmaFilter=false.
#    - DRIVE-FOLLOWING: InpEntryMode=0 (BREAKOUT), il gate RIFIUTA 2 (retest).
#
#  >>> LA FINESTRA 2024.09.26 -> 2026.06.30 e' la finestra TICK BCM
#      disponibile (pavimento sonda 17/08). E' UN SOLO REGIME RIALZISTA,
#      DICHIARATO: la robustezza-per-regime e' gia' stabilita a OHLC in
#      FASE 1; qui si misura SOLO il costo reale a tick. La FrazioneIS (40/60)
#      serve al driver generico come CONTESTO DI LETTURA (l'edge regge in
#      entrambe le meta'?), NON come selezione: su questa finestra NON si
#      sceglie nulla. Si leggono ENTRAMBE le gambe (IS e OOS) come contesto.
#
#  >>> PROFONDITA' TICK DI NASUSD: RILIEVO, non gate (come PASSO 0 / ABTEST).
#      Si prova a scaricare misura_tick_NASUSD.csv al pin; se NON c'e' si
#      DICHIARA la RISERVA (a Model 4, se i tick reali non ci sono MT5 NON si
#      ferma, ripiega e produce numeri PLAUSIBILI E FALSI).
#
#  >>> NASUSD E' UN SIMBOLO BCM LIVE (non custom): non serve importarlo, e'
#      gia' nel terminale. NIENTE controllo bases\Custom (quello valeva per
#      NASUSD_EXT in FASE 1).
#
#  ------------------------------------------------------------------
#  CRITERI DI LETTURA CONGELATI (in testa, PRIMA dei numeri):
#   - DECIDE l'ASPETTATIVA PER TRADE a tick (non solo il PF), con coerenza
#     fra le due gambe. Il costo reale (spread+slippage) e' proprio la
#     differenza fra questo numero e quello OHLC della FASE 1.
#   - RISCHIO MAI SOSPESO (regola B): DD e peggior giornata contro il muro
#     prop, SEMPRE, a qualunque n. La parziale e' rimessa apposta per il DD.
#   - CAMPIONE: >=150 trade per giudicare il MERITO; sotto, merito sospeso
#     (l'apertura fa ~1 setup/giorno -> 21 mesi danno qualche centinaio; si
#     conta e si dichiara).
#   - IL CONFRONTO SIMMETRICO-vs-LONGONLY: 00_simm meno 01_long = costo dello
#     short su una finestra SENZA crolli (atteso: piccolo drag, R115). NON e'
#     un lato migliore: e' il premio-assicurazione. Il candidato e' il SIMMETRICO.
#
#  ------------------------------------------------------------------
#  PERCHE' ESISTE QUESTO FILE invece di due righe di walkforward_generico
#  incollate a mano (gli stessi motivi del gemello FASE2_DRIVE):
#   1. L'INCLUDE. ABTG_Nasdaq_Apertura_US.mq5 fa #include <ABTG_PausaGuardian.mqh>
#      e il driver generico NON lo installa: qui si scarica al pin e si copia
#      PRIMA di compilare.
#   2. I GATE DELLE INVERSIONI. Il driver generico blinda tutto al DEFAULT del
#      sorgente (che e' il DAX, breakout, risk 0.65, ecc.): senza questi gate
#      un file con l'ora sbagliata, la parziale a 0 o l'SL floor a 0 passerebbe
#      in silenzio. Si controllano PRIMA di aprire MT5.
#   3. LA STELLA (una sola feature per cella), i magic vergini, il periodo M15.
#   4. LA RACCOLTA (regola di casa CLAUDE.md): Desktop + zip + referto.
#
#  LA RIGA CHE SI INCOLLA sta in righe\RIGA_FASE2_CASSA_DA_MANDARE.md
# =====================================================================
[CmdletBinding()]
param(
  # -Pin NON ha default: un default silenzioso ("lavoro") farebbe girare la
  #  punta del branch spacciandola per un commit congelato. Meglio morire.
  [string]$Pin           = "",
  [switch]$SoloControllo,          # giro a vuoto: NON apre MT5
  [switch]$Rifai,                  # rifa' anche i CSV gia' presenti
  [string]$SoloCella     = "",     # "00_simm" | "01_long"
  [string]$Simbolo       = "NASUSD",
  [string]$Periodo       = "M15",
  [string]$DaQuando      = "2024.09.26",
  [string]$Fino          = "2026.06.30",
  [double]$FrazioneIS    = 0.40,   # contesto di lettura (40/60), NON selezione
  [int]$Deposito         = 100000,
  [int]$Spread           = 0,      # 0 = spread CORRENTE, ma SCRITTO nell'ini
  [double]$OreMax        = 12.0
)
$ErrorActionPreference = "Stop"
# --- RETE DI SICUREZZA SUL CODICE D'USCITA (lezione PREOPEN 28/08): un errore
#     fuori dai try faceva morire lo script con pwsh che usciva 0. Con questo
#     trap un'uscita anomala e' SEMPRE 1.
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

$EA     = "ABTG_Nasdaq_Apertura_US"
$Avvio  = Get-Date
$Stamp  = $Avvio.ToString("yyyyMMdd_HHmm", $INV)
$Dsk    = Join-Path $env:USERPROFILE "Desktop"
$Work   = Join-Path $env:USERPROFILE "abtg_fase2_cassa"
$Prove  = Join-Path $Work "prove"
$RawPin = "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$Pin"

# --- TUTTO CIO' CHE LA RACCOLTA USA NASCE QUI, PRIMA DEL try. In PowerShell
#     una function e' un'ISTRUZIONE: se il flusso non ci passa sopra il nome
#     non esiste, e la raccolta esploderebbe proprio nella corsa fermata da
#     un gate, cioe' l'unica in cui il referto serve davvero.
$Problemi  = New-Object System.Collections.ArrayList
$Rilievi   = New-Object System.Collections.ArrayList
$Fatale    = ""
$Include   = "NON INSTALLATO"
$Terminale = "n/d"
$Compilato = "NON TENTATA"
$RiskEA    = "n/d"
$TickNAS   = "NON VERIFICATA"
$IS_Da="n/d"; $IS_A="n/d"; $OOS_Da="n/d"; $OOS_A="n/d"
$Modo      = "CORSA"
if($SoloControllo){ $Modo = "CONTROLLO" }

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
function NumInv($s){
  $v = 0.0
  $t = ("" + $s).Replace([string][char]160,"").Replace([string][char]8239,"").Replace([string][char]8201,"").Replace(" ","").Trim()
  if($t -eq ""){ return $null }
  if([double]::TryParse($t,[Globalization.NumberStyles]::Float,$INV,[ref]$v)){ return $v }
  return $null
}
# --- SENTINELLA su TUTTE le colonne: un numero non misurato NON esce mai come
#     numero plausibile. "n/d", non "0.000".
function FmtN($v){ if($null -eq $v){ return "n/d" }; if([int]$v -lt 0){ return "n/d" }; return ([int]$v).ToString($INV) }
function Fmt2($v){ if($null -eq $v){ return "n/d" }; if([double]$v -lt 0){ return "n/d" }; return ([double]$v).ToString("0.00",$INV) }
function Fmt3($v){ if($null -eq $v){ return "n/d" }; if([double]$v -lt 0){ return "n/d" }; return ([double]$v).ToString("0.000",$INV) }
function FmtE($v){ if($null -eq $v){ return "n/d" }; if([double]$v -le -999998.0){ return "n/d" }; return ([double]$v).ToString("+0;-0;0",$INV) }
function FmtA($v){ if($null -eq $v){ return "n/d" }; if([double]$v -le -999998.0){ return "n/d" }; return ([double]$v).ToString("+0.0;-0.0;0.0",$INV) }
function FmtPg($v){ if($null -eq $v){ return "n/d" }; if([double]$v -ge 99.0){ return "n/d" }; return ([double]$v).ToString("0.00",$INV) }

# --- GATE SULLE DATE (una finestra sbagliata non risponde alla domanda, e MT5
#     con un ToDate invalido non e' nemmeno un errore rumoroso).
function GateDate([string]$eti,[string]$da,[string]$a){
  if($da -notmatch '^\d{4}\.\d{2}\.\d{2}$'){ throw ($eti + ": FromDate non e' 'aaaa.mm.gg' ma [" + $da + "].") }
  if($a  -notmatch '^\d{4}\.\d{2}\.\d{2}$'){ throw ($eti + ": ToDate non e' 'aaaa.mm.gg' ma [" + $a + "].") }
  $d1=[datetime]::MinValue; $d2=[datetime]::MinValue
  if(-not [datetime]::TryParseExact($da,"yyyy.MM.dd",$INV,[Globalization.DateTimeStyles]::None,[ref]$d1)){ throw ($eti + ": FromDate [" + $da + "] non e' un giorno che esiste.") }
  if(-not [datetime]::TryParseExact($a ,"yyyy.MM.dd",$INV,[Globalization.DateTimeStyles]::None,[ref]$d2)){ throw ($eti + ": ToDate [" + $a + "] non e' un giorno che esiste.") }
  if($d2 -le $d1){ throw ($eti + ": ToDate (" + $a + ") non e' DOPO FromDate (" + $da + ").") }
}

# --- IL PARSER DEL CSV DI OTTIMIZZAZIONE. Colonne PER NOME, mai per posizione.
$script:CsvIntestazioni = @()
function LeggiOpt([string]$path){
  if(-not (Test-Path -LiteralPath $path)){ return $null }
  $righe = @()
  try{ $righe = @(Import-Csv -LiteralPath $path) }catch{ return $null }
  if($righe.Count -eq 0){ return $null }
  $cols = @($righe[0].PSObject.Properties.Name)
  $script:CsvIntestazioni = $cols
  $kProf = $null; $kPf = $null; $kDd = $null; $kN = $null; $kPg = $null; $kMg = $null
  foreach($k in $cols){
    $l = ("" + $k).Trim().ToLower()
    if($l -eq "profit" -or $l -eq "profitto"){ $kProf = $k }
    if($l -eq "profit factor" -or $l -eq "fattore di profitto"){ $kPf = $k }
    if($l -eq "equity dd %" -or $l -eq "drawdown equity %"){ $kDd = $k }
    if($l -eq "trades" -or $l -eq "operazioni"){ $kN = $k }
    if($l -eq "peggior giornata %" -or $l -eq "worst day %"){ $kPg = $k }
    if($l -eq "inpmagic"){ $kMg = $k }
  }
  if($null -eq $kProf -or $null -eq $kPf -or $null -eq $kDd -or $null -eq $kN){ return $null }
  $out = New-Object System.Collections.ArrayList
  foreach($r in $righe){
    $pg = $null
    if($null -ne $kPg){ $pg = (NumInv $r.$kPg) }
    $mg = ""
    if($null -ne $kMg){ $mg = ("" + $r.$kMg).Trim() }
    [void]$out.Add([pscustomobject]@{
      Profit = (NumInv $r.$kProf); Pf = (NumInv $r.$kPf); Dd = (NumInv $r.$kDd)
      N = (NumInv $r.$kN); Pg = $pg; Magic = $mg })
  }
  return @($out)
}

# --- I GEMELLI: le due righe (i due magic di controllo) IDENTICHE AL CENTESIMO.
#     Se il banco non e' deterministico il numero non si legge: e' il motivo
#     per cui l'unico asse spazzolato e' InpMagic.
$TolGemelli = 0.005
function Gemelli($righe){
  if($null -eq $righe){ return "NON MISURATO (CSV non letto)" }
  if(@($righe).Count -ne 2){ return ("NON VALIDO: " + @($righe).Count + " righe invece di 2") }
  $a = $righe[0]; $b = $righe[1]
  foreach($ch in @(@("profitto",$a.Profit,$b.Profit),@("PF",$a.Pf,$b.Pf),@("DD",$a.Dd,$b.Dd),@("n",$a.N,$b.N))){
    if($null -eq $ch[1] -or $null -eq $ch[2]){ return ("NON MISURATO (" + $ch[0] + " illeggibile)") }
    if([math]::Abs([double]$ch[1] - [double]$ch[2]) -gt $TolGemelli){
      return ("DIVERSI su " + $ch[0] + ": " + $ch[1] + " contro " + $ch[2])
    }
  }
  return "IDENTICI"
}

# =====================================================================
#  LE DUE CELLE. La BASELINE della stella e' il 00_simm (il candidato). Il
#  01_long ne differisce per UN solo interruttore (InpAllowShort), oltre a
#  InpMagic. VLong/VShort = quanto DEVONO valere i lati in quel file: se due
#  file fossero SCAMBIATI il diff resterebbe verde e questo no.
# =====================================================================
function C([string]$id,[string]$file,[string]$desc,[int]$m1,[int]$m2,
          [string]$vl,[string]$vs,$diff){
  return [pscustomobject]@{
    Id=$id; Prova=$file; Desc=$desc; M1=$m1; M2=$m2;
    VLong=$vl; VShort=$vs; Diff=@($diff);
    Esito="NON ESEGUITA";
    GemIS="NON MISURATO"; GemOOS="NON MISURATO";
    NIS=-1;  PfIS=-1.0;  DdIS=-1.0;  ProfIS=-999999.0; PgIS=99.9
    NOOS=-1; PfOOS=-1.0; DdOOS=-1.0; ProfOOS=-999999.0; PgOOS=99.9; AspOOS=-999999.0 }
}
$BASE_ID = "00_simm"
$CELLE = @()
$CELLE += (C "00_simm" "FASE2_CASSA_00_simm.txt" "SIMMETRICO (long+short) = IL CANDIDATO"        768100 768101 "true" "true"  @())
$CELLE += (C "01_long" "FASE2_CASSA_01_long.txt" "SOLO LONG -- misura il costo dello short"      768110 768111 "true" "false" @("InpAllowShort"))

# --- I MAGIC VIETATI: il blocco 7681xx di questa CASSA e' VERGINE (cercato in
#     tutto il repo il 2026-08-30: zero occorrenze). Questa lista e' la seconda
#     rete: sedie vive, blocchi FASE 1 (7672xx), R115 (766xxx), PASSO0/short
#     (767xxx) e default di altri EA. Riusarne uno mescolerebbe i deal di due
#     misure nella cache del tester e negli export per-trade (il magic e' nel nome).
$MagicVietati = @(770101,770111,770201,770202,770411,770402,770511,770601,770611,770901,770532,
                  767200,767201,767210,767211,767220,767221,767230,767231,   # FASE 1 (7672xx)
                  767700,767701,767710,767711,767740,767741,767800,767801,   # PASSO0 / short (767xxx)
                  766000,766010,766011,766020,766021,766030,766031,           # R115 (766xxx)
                  766110,766111,766120,766121,766210,766211,766220,766221,
                  765000,765010,765020,765213,
                  773500,773501)

$Ordinati = @($CELLE)
if($SoloCella -ne ""){
  $Ordinati = @($CELLE | Where-Object { $_.Id -eq $SoloCella })
}

try{
  Titolo "FASE 2 CASSA -- validazione a TICK (ABTG_Nasdaq_Apertura_US, NASUSD) -- modo $Modo"

  # -------------------------------------------------------------------
  #  0. LE GUARDIE, PRIMA DI TOCCARE QUALUNQUE COSA
  # -------------------------------------------------------------------
  if($Pin -eq ""){ throw "-Pin obbligatorio: senza, girerebbe la punta del branch spacciandola per un commit congelato." }
  if($Pin -notmatch '^[0-9a-f]{40}$'){ throw ("-Pin deve essere un commit di 40 caratteri esadecimali, ricevuto: " + $Pin) }
  if(Get-Process terminal64,metaeditor64 -ErrorAction SilentlyContinue){
    throw "MT5 O METAEDITOR APERTO: col terminale aperto il tester non gira (zero CSV), con MetaEditor aperto la compilazione torna subito senza compilare."
  }
  if($SoloCella -ne "" -and @($Ordinati).Count -eq 0){
    throw ("-SoloCella '" + $SoloCella + "' non esiste. Validi: 00_simm, 01_long.")
  }
  if($Periodo -ne "M15"){
    [void]$Rilievi.Add("PERIODO diverso da M15 (" + $Periodo + "): i file prova dichiarano @PERIODO M15 e il gate lo confronta.")
  }
  GateDate "argomenti della riga" $DaQuando $Fino
  $dtIn=[datetime]::ParseExact($DaQuando,"yyyy.MM.dd",$INV)
  $dtFi=[datetime]::ParseExact($Fino,"yyyy.MM.dd",$INV)
  $dtMet=$dtIn.AddDays([math]::Floor(($dtFi-$dtIn).TotalDays*$FrazioneIS))
  $IS_Da=$dtIn.ToString("yyyy.MM.dd",$INV); $IS_A=$dtMet.ToString("yyyy.MM.dd",$INV)
  $OOS_Da=$dtMet.AddDays(1).ToString("yyyy.MM.dd",$INV); $OOS_A=$dtFi.ToString("yyyy.MM.dd",$INV)

  Dico ("pin ......... " + $Pin)
  Dico ("celle ....... " + @($Ordinati).Count + " su 2")
  Dico ("simbolo ..... " + $Simbolo + " " + $Periodo + " (BCM live; fuso IT-1: apertura 15:30 IT = 14:30 server)")
  Dico ("finestra .... " + $DaQuando + " -> " + $Fino + "   (UN SOLO REGIME rialzista, dichiarato)")
  Dico ("   IS ....... " + $IS_Da + " - " + $IS_A + "   (contesto di lettura, NON selezione)")
  Dico ("   OOS ...... " + $OOS_Da + " - " + $OOS_A)
  Dico ("banco ....... MODELLO 4 (TICK REALI). Deposito " + $Deposito + ", Spread=" + $Spread + " scritto nell'ini, rischio 0.65%")

  # -------------------------------------------------------------------
  #  1. SCARICO AL PIN
  # -------------------------------------------------------------------
  Titolo "1. SCARICO AL PIN"
  New-Item -ItemType Directory -Force -Path $Work,$Prove | Out-Null

  $drv = Join-Path $Work "walkforward_generico.ps1"
  Scarica ($RawPin + "/backtest_pipeline/walkforward_generico.ps1") $drv
  # il driver generico pinna il branch da cui riscarica il .mq5: senza questo
  # il pin varrebbe per il driver e NON per l'EA misurato.
  $t = Get-Content -LiteralPath $drv -Raw
  if($t -notmatch '\$EABranch\s*=\s*"lavoro"'){ throw "walkforward_generico.ps1 non ha la riga \$EABranch attesa: non lo posso pinnare." }
  $t = $t -replace '\$EABranch\s*=\s*"lavoro"', ('$EABranch="' + $Pin + '"')
  Set-Content -LiteralPath $drv -Value $t -Encoding ASCII
  Dico "driver generico scaricato e PINNATO (riscarica l'EA al pin, non dalla punta del branch)" "Green"

  foreach($c in $Ordinati){
    Scarica ($RawPin + "/backtest_pipeline/prove/" + $c.Prova) (Join-Path $Prove $c.Prova)
  }
  # il 00_simm serve SEMPRE: e' il termine di paragone del gate della stella,
  # anche quando gira una cella sola.
  $fBase = Join-Path $Prove "FASE2_CASSA_00_simm.txt"
  if(-not (Test-Path -LiteralPath $fBase)){
    Scarica ($RawPin + "/backtest_pipeline/prove/FASE2_CASSA_00_simm.txt") $fBase
  }
  Dico ("file prova scaricati: " + @(Get-ChildItem $Prove -Filter *.txt).Count) "Green"

  $incSrc = Join-Path $Work "ABTG_PausaGuardian.mqh"
  Scarica ($RawPin + "/mql5/Include/ABTG_PausaGuardian.mqh") $incSrc
  Dico ("include scaricato: ABTG_PausaGuardian.mqh (" + (Get-Item $incSrc).Length + " byte)") "Green"

  # -------------------------------------------------------------------
  #  2. I GATE SUI FILE PROVA -- girano PRIMA di aprire MT5
  # -------------------------------------------------------------------
  Titolo "2. GATE SUI FILE PROVA"
  $mappe = @{}
  $magicVisti = @{}
  foreach($f in @(Get-ChildItem $Prove -Filter *.txt)){
    $righe = RigheVive $f.FullName
    $h = @{}
    $nY = 0
    $nomeY = ""
    foreach($r in $righe){
      if($r -match '^@'){
        $parti = ($r -split '\s+',2)
        $h[$parti[0]] = $parti[1].Trim()
        continue
      }
      $i = $r.IndexOf("=")
      if($i -lt 0){ continue }
      $nome = $r.Substring(0,$i).Trim()
      $val  = $r.Substring($i+1).Trim()
      if($h.ContainsKey($nome)){ throw ($f.Name + ": DUE righe per '" + $nome + "'. In [TesterInputs] un parametro doppio fa fare a MT5 ZERO passate.") }
      $h[$nome] = $val
      if($val -match '\|\|\s*[Yy]\s*$'){ $nY++; $nomeY = $nome }
    }
    if($nY -ne 1){ throw ($f.Name + ": deve avere ESATTAMENTE un asse con flag Y, trovati " + $nY + ".") }
    if($nomeY -ne "InpMagic"){ throw ($f.Name + ": l'unico asse Y deve essere InpMagic, invece e' " + $nomeY + ".") }
    $mappe[$f.Name] = $h
  }

  $hBase = $mappe["FASE2_CASSA_00_simm.txt"]
  if($null -eq $hBase){ throw "manca la mappa del 00_simm: senza, il gate della stella non e' eseguibile." }

  foreach($c in $Ordinati){
    $h = $mappe[$c.Prova]
    if($null -eq $h){ throw ("mappa mancante per " + $c.Prova) }

    # GATE GEOMETRIA: simbolo, periodo, finestra
    if($h["@SIMBOLO"]  -ne $Simbolo){  throw ($c.Prova + ": @SIMBOLO e' " + $h["@SIMBOLO"] + ", atteso " + $Simbolo + " (BCM live, NON NASUSD_EXT).") }
    if($h["@PERIODO"]  -ne $Periodo){  throw ($c.Prova + ": @PERIODO e' " + $h["@PERIODO"] + ", atteso " + $Periodo) }
    if($h["@DAQUANDO"] -ne $DaQuando){ throw ($c.Prova + ": @DAQUANDO e' " + $h["@DAQUANDO"] + ", atteso " + $DaQuando) }
    if($h["@FINOA"]    -ne $Fino){     throw ($c.Prova + ": @FINOA e' " + $h["@FINOA"] + ", atteso " + $Fino) }

    # GATE DEL FUSO NORMALE BCM (opposto alla FASE 1): qui il feed e' BCM e
    # vale la regola di casa IT-1=server. Nasdaq 15:30 IT = 14:30 server. Il
    # gate PRETENDE 14/30 e RIFIUTA 9 (il 9:30 era il caso _EXT/NY).
    $ssh = ($h["InpSessionHour"] -split '\|\|')[0]
    $ssm = ($h["InpSessionMin"]  -split '\|\|')[0]
    if($ssh -eq "9"){  throw ($c.Prova + ": InpSessionHour=9 e' l'ora NY del feed _EXT (FASE 1). Sulla cassaforte NASUSD (BCM) il fuso e' IT-1: apertura 15:30 IT = 14:30 server. Qui va 14.") }
    if($ssh -ne "14"){ throw ($c.Prova + ": InpSessionHour deve essere 14 (14:30 server BCM = 15:30 IT), trovato '" + $ssh + "'.") }
    if($ssm -ne "30"){ throw ($c.Prova + ": InpSessionMin deve essere 30 (apertura 14:30 server), trovato '" + $ssm + "'.") }

    # GATE DRIVE-FOLLOWING: InpEntryMode=0 (BREAKOUT), RIFIUTA 2 (retest R115).
    $entry = ($h["InpEntryMode"] -split '\|\|')[0]
    if($entry -eq "2"){ throw ($c.Prova + ": InpEntryMode=2 e' il RETEST (R115). Il motore della FASE 2 e' drive-following: InpEntryMode=0 (BREAKOUT).") }
    if($entry -ne "0"){ throw ($c.Prova + ": InpEntryMode deve essere 0 (BREAKOUT drive-following), trovato '" + $entry + "'.") }

    # GATE RISCHIO: 0.65 (taglia di casa, DD comparabile). RIFIUTA 1.0 (FASE 1).
    $risk = ($h["InpRiskPercent"] -split '\|\|')[0]
    if($risk -eq "1.0" -or $risk -eq "1" -or $risk -eq "1.00"){ throw ($c.Prova + ": InpRiskPercent=1.0 era la FASE 1 (screening). Sulla cassaforte la taglia di casa e' 0.65 (DD comparabile).") }
    if($risk -ne "0.65"){ throw ($c.Prova + ": InpRiskPercent deve essere 0.65, trovato '" + $risk + "'.") }

    # GATE PARZIALE RIMESSA (gestione prop): 50% a 1R + breakeven, l'altra
    # meta' corre senza cap. RIFIUTA il ClosePct=0 della diagnostica all-runner.
    $tp1cl = ($h["InpTP1_ClosePct"] -split '\|\|')[0]
    $tp1r  = ($h["InpTP1_R"]        -split '\|\|')[0]
    $beat  = ($h["InpBreakevenAtTP1"] -split '\|\|')[0]
    $runtp = ($h["InpRunnerTP_R"]   -split '\|\|')[0]
    if($tp1cl -eq "0" -or $tp1cl -eq "0.0"){ throw ($c.Prova + ": InpTP1_ClosePct=0 era la diagnostica all-runner (FASE 1). Sulla cassaforte la parziale e' RIMESSA: 50%.") }
    if($tp1cl -ne "50.0" -and $tp1cl -ne "50"){ throw ($c.Prova + ": InpTP1_ClosePct deve essere 50 (meta' chiude a 1R), trovato '" + $tp1cl + "'.") }
    if($tp1r -ne "1.0" -and $tp1r -ne "1"){ throw ($c.Prova + ": InpTP1_R deve essere 1.0 (primo obiettivo a 1R), trovato '" + $tp1r + "'.") }
    if($beat -ne "true" -and $beat -ne "1"){ throw ($c.Prova + ": InpBreakevenAtTP1 deve essere true (breakeven dopo la parziale), trovato '" + $beat + "'.") }
    if($runtp -ne "-1"){ throw ($c.Prova + ": InpRunnerTP_R deve essere -1 (il runner corre senza cap), trovato '" + $runtp + "'.") }

    # GATE PAVIMENTO SL (R109): 500, mai 0, e si APPLICA (non salta il trade).
    $mfloor = ($h["InpMinStopPts"]  -split '\|\|')[0]
    $mskip  = ($h["InpSkipIfTight"] -split '\|\|')[0]
    if($mfloor -eq "0" -or $mfloor -eq "0.0"){ throw ($c.Prova + ": InpMinStopPts=0 VIETATO (R109): il pavimento SL e' 500, mai 0.") }
    if($mfloor -ne "500.0" -and $mfloor -ne "500"){ throw ($c.Prova + ": InpMinStopPts deve essere 500 (R109), trovato '" + $mfloor + "'.") }
    if($mskip -eq "true" -or $mskip -eq "1"){ throw ($c.Prova + ": InpSkipIfTight=true fa SALTARE il trade stretto. Sulla cassaforte il pavimento si APPLICA: false.") }
    if($mskip -ne "false" -and $mskip -ne "0"){ throw ($c.Prova + ": InpSkipIfTight deve essere false (il pavimento si applica), trovato '" + $mskip + "'.") }

    # GATE F1 e F3 SPENTI (bocciati in FASE 1)
    $vf1 = ($h["InpMinBreakoutRangeATR"] -split '\|\|')[0]
    $vf3 = ($h["InpUseEmaFilter"]        -split '\|\|')[0]
    if($vf1 -ne "0.0" -and $vf1 -ne "0"){ throw ($c.Prova + ": InpMinBreakoutRangeATR (F1) deve essere 0 (spento, bocciato FASE 1), trovato '" + $vf1 + "'.") }
    if($vf3 -eq "true" -or $vf3 -eq "1"){ throw ($c.Prova + ": InpUseEmaFilter (F3) e' acceso, ma F3 e' bocciato in FASE 1: deve essere false.") }

    # GATE DEI VALORI LATO: quanto valgono i due lati IN QUESTO FILE. Prende
    # il caso che il diff non puo' vedere: due file SCAMBIATI.
    $vl = ($h["InpAllowLong"]  -split '\|\|')[0]
    $vs = ($h["InpAllowShort"] -split '\|\|')[0]
    if($vl -ne $c.VLong){  throw ($c.Prova + ": InpAllowLong vale "  + $vl + ", la cella " + $c.Id + " lo vuole " + $c.VLong) }
    if($vs -ne $c.VShort){ throw ($c.Prova + ": InpAllowShort vale " + $vs + ", la cella " + $c.Id + " lo vuole " + $c.VShort) }

    # GATE DELLA STELLA: contro il 00_simm cambia SOLO cio' che e' dichiarato
    # in Diff, piu' InpMagic. Confronto PER NOME, mai per posizione.
    $ammessi = @("InpMagic") + @($c.Diff)
    foreach($k in @($h.Keys)){
      if($k -match '^@'){ continue }
      if($ammessi -contains $k){ continue }
      if($hBase[$k] -ne $h[$k]){ throw ($c.Prova + ": '" + $k + "' differisce dal 00_simm e NON e' un delta dichiarato (" + (@($c.Diff) -join ", ") + ").") }
    }
    foreach($k in @($c.Diff)){
      if($hBase[$k] -eq $h[$k]){ throw ($c.Prova + ": '" + $k + "' DOVEVA differire dal 00_simm e non differisce.") }
    }
    if(@($h.Keys).Count -ne @($hBase.Keys).Count){ throw ($c.Prova + ": ha " + @($h.Keys).Count + " chiavi, il 00_simm ne ha " + @($hBase.Keys).Count + " (elenco parametri diverso).") }

    # GATE DEI MAGIC: vergini, unici, mai uno vietato.
    $mg = $h["InpMagic"] -split '\|\|'
    foreach($v in @($mg[1],$mg[3])){
      $n = [int]$v
      if($MagicVietati -contains $n){ throw ($c.Prova + ": magic " + $n + " e' VIETATO (sedia viva, FASE 1, R115, PASSO0 o round recente).") }
      if($magicVisti.ContainsKey($n)){ throw ("magic " + $n + " usato in due celle: " + $magicVisti[$n] + " e " + $c.Prova) }
      $magicVisti[$n] = $c.Prova
    }
    if([int]$mg[1] -ne $c.M1 -or [int]$mg[3] -ne $c.M2){
      throw ($c.Prova + ": i magic gemelli sono " + $mg[1] + "/" + $mg[3] + ", la cella " + $c.Id + " li vuole " + $c.M1 + "/" + $c.M2)
    }

    if($c.Id -eq $BASE_ID){ $RiskEA = $risk }
  }
  Dico "geometria, FUSO 14/30 (rifiuta 9), drive-following (rifiuta 2), rischio 0.65, parziale 50, SL floor 500, F1/F3 off, lati, stella, magic: TUTTI PASSATI" "Green"

  # -------------------------------------------------------------------
  #  3. IL TERMINALE, L'INCLUDE E LA COMPILAZIONE
  # -------------------------------------------------------------------
  Titolo "3. TERMINALE, INCLUDE, COMPILAZIONE"
  # LO STESSO SELETTORE, RIGA PER RIGA, DI walkforward_generico.ps1: i due
  # script devono scegliere LO STESSO terminale, altrimenti include installato
  # in uno e compilazione fatta nell'altro sarebbe un guasto muto.
  $allTerm = @(Get-ChildItem "C:\Program Files","C:\Program Files (x86)" -Recurse -Filter "terminal64.exe" -ErrorAction SilentlyContinue)
  $cand = $allTerm | Where-Object { $_.DirectoryName -like "*BCM Markets MT5 Terminal*" -and $_.DirectoryName -notlike "*-V3*" } | Select-Object -First 1
  if(-not $cand){ $cand = $allTerm | Where-Object { $_.DirectoryName -like "*BCM Markets*" } | Select-Object -First 1 }
  if(-not $cand){ throw "terminale BCM non trovato: e' lo stesso selettore di walkforward_generico.ps1." }
  $instDir    = $cand.DirectoryName
  $MetaEditor = Join-Path $instDir "metaeditor64.exe"
  $termRoot   = Join-Path $env:APPDATA "MetaQuotes\Terminal"
  $dataFolder = (Get-ChildItem $termRoot -Directory -ErrorAction SilentlyContinue | Where-Object { $o = Join-Path $_.FullName "origin.txt"; (Test-Path $o) -and ((Get-Content $o -Raw).Trim() -ieq $instDir) } | Select-Object -First 1 -ExpandProperty FullName)
  if(-not $dataFolder){ throw ("cartella dati non trovata per " + $instDir) }
  $Terminale = $instDir
  Dico ("terminale scelto: " + $instDir + "  (DEVE essere lo stesso che stampa il driver generico)") "Yellow"

  # NASUSD E' UN SIMBOLO BCM LIVE (non custom): e' gia' nel terminale, NON si
  # importa. Nessun controllo bases\Custom (quello valeva per NASUSD_EXT).
  Dico "simbolo NASUSD: BCM live (nessun import: se il tester dicesse 'symbol not exist' aprire MT5 una volta a mano e trascinarlo nel Market Watch)." "Gray"

  # LA COPIA DELL'INCLUDE SI VERIFICA SUL CONTENUTO, NON SUL NOME.
  $incDir = Join-Path $dataFolder "MQL5\Include"
  New-Item -ItemType Directory -Force -Path $incDir | Out-Null
  $lenInc = (Get-Item -LiteralPath $incSrc).Length
  Copy-Item $incSrc -Destination $incDir -Force
  $vInc = Get-Item -LiteralPath (Join-Path $incDir "ABTG_PausaGuardian.mqh") -ErrorAction Stop
  if($vInc.PSIsContainer -or $vInc.Length -ne $lenInc){ throw "include copiato ma NON verificato (lunghezza diversa)." }
  $Include = "INSTALLATO e VERIFICATO in " + $incDir
  Dico $Include "Green"

  # LA COMPILAZIONE: questo EA e' GIA' vivo in forward, la compilazione qui e'
  # attesa RIUSCIRE e serve solo a garantire un .ex5 AL PIN (il forward gira su
  # un'altra copia, questa corsa NON lo tocca). L'.ex5 si cancella prima: senza,
  # un binario vecchio farebbe passare per riuscita una compilazione fallita.
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
    throw ("COMPILAZIONE FALLITA: " + $EA + " non ha prodotto l'.ex5. Gli errori sono qui sopra e in COMPILAZIONE_FALLITA.log dentro lo zip.")
  }
  $Compilato = "OK (" + [int]((Get-Item -LiteralPath $ex5).Length/1024) + " KB, " + (Get-Item -LiteralPath $ex5).LastWriteTime.ToString("HH:mm:ss",$INV) + ")"
  Dico ("compilato " + $EA + ": " + $Compilato) "Green"

  # -------------------------------------------------------------------
  #  3b. PROFONDITA' TICK di NASUSD -- RILIEVO, non gate (come PASSO0 / ABTEST)
  # -------------------------------------------------------------------
  $tk = Join-Path $Work "misura_tick_NASUSD.csv"
  try{
    Scarica ($RawPin + "/backtest_pipeline/risultati_archivio/misura_tick/misura_tick_NASUSD.csv") $tk
    $riga = @(Get-Content -LiteralPath $tk | Where-Object { $_ -match '(?i)TICK' } | Select-Object -First 1)
    if($riga.Count -gt 0){ $TickNAS = ("" + $riga[0]).Trim() } else { $TickNAS = "file presente ma senza riga TICK" }
  }catch{
    $TickNAS = "NON MISURATA (nessun misura_tick_NASUSD.csv al pin)"
    [void]$Rilievi.Add("PROFONDITA' TICK NON MISURATA su NASUSD: a Model 4, se i tick reali non ci sono MT5 NON si ferma, ripiega e produce numeri PLAUSIBILI E FALSI. Ogni numero su NASUSD va letto con questa RISERVA finche' non si gira misura_tick su NASUSD.")
  }
  Dico ("profondita' tick NASUSD: " + $TickNAS) "Gray"

  # -------------------------------------------------------------------
  #  4. LE CORSE -- Model 4 (tick reali), split 40/60 (CONTESTO, non selezione)
  # -------------------------------------------------------------------
  Titolo "4. LE CORSE"
  if($OreMax -le 0){ $OreMax = 12.0 }
  $Risultati = Join-Path $Work ("risultati_prove\" + $EA)
  foreach($c in $Ordinati){
    if(((Get-Date) - $Avvio).TotalHours -ge $OreMax){
      $c.Esito = "NON INIZIATA (-OreMax " + $OreMax + "h)"
      [void]$Problemi.Add("cella " + $c.Id + ": -OreMax raggiunto, non iniziata.")
      continue
    }
    Dico ("cella " + $c.Id + " -- " + $c.Desc) "Cyan"
    # NON si chiama $args: e' una VARIABILE AUTOMATICA di PowerShell.
    $argv = @("-ExecutionPolicy","Bypass","-File",$drv,
              "-Expert",$EA,
              "-Prova",(Join-Path $Prove $c.Prova),
              "-Etichetta",$c.Id,
              "-Simbolo",$Simbolo,
              "-Periodo",$Periodo,
              "-DaQuando",$DaQuando,
              "-Fino",$Fino,
              "-FrazioneIS",("" + $FrazioneIS),
              "-Modello","4",
              "-Deposito",("" + $Deposito),
              "-Spread",("" + $Spread))
    if($SoloControllo){ $argv += "-SoloControllo" }
    if($Rifai){ $argv += "-Rifai" }
    $global:LASTEXITCODE = 0
    & powershell $argv
    $rc = $LASTEXITCODE
    if($rc -ne 0){
      $c.Esito = "FERMATA (codice " + $rc + ")"
      [void]$Problemi.Add("cella " + $c.Id + ": il driver generico e' uscito con codice " + $rc)
      continue
    }
    if($SoloControllo){ $c.Esito = "CONTROLLO OK"; continue }

    # Model 4 -> nessun suffisso "_ohlc". Si leggono ENTRAMBE le gambe.
    $csvIS  = Join-Path $Risultati ($EA + "_" + $Simbolo + "_IS_"  + $c.Id + ".csv")
    $csvOOS = Join-Path $Risultati ($EA + "_" + $Simbolo + "_OOS_" + $c.Id + ".csv")
    $rIS  = LeggiOpt $csvIS
    $rOOS = LeggiOpt $csvOOS
    if($null -eq $rIS -or $null -eq $rOOS){
      $c.Esito = "CSV NON LEGGIBILE"
      [void]$Problemi.Add("cella " + $c.Id + ": CSV IS o OOS mancante o intestazioni non riconosciute. Viste: " + ($script:CsvIntestazioni -join " | "))
      continue
    }
    $c.GemIS  = Gemelli $rIS
    $c.GemOOS = Gemelli $rOOS
    if(@($rIS).Count -ge 1){
      $r=$rIS[0]
      if($null -ne $r.N){ $c.NIS=[int]$r.N }
      if($null -ne $r.Pf){ $c.PfIS=[double]$r.Pf }
      if($null -ne $r.Dd){ $c.DdIS=[double]$r.Dd }
      if($null -ne $r.Profit){ $c.ProfIS=[double]$r.Profit }
      if($null -ne $r.Pg){ $c.PgIS=[double]$r.Pg }
    }
    if(@($rOOS).Count -ge 1){
      $r=$rOOS[0]
      if($null -ne $r.N){ $c.NOOS=[int]$r.N }
      if($null -ne $r.Pf){ $c.PfOOS=[double]$r.Pf }
      if($null -ne $r.Dd){ $c.DdOOS=[double]$r.Dd }
      if($null -ne $r.Profit){ $c.ProfOOS=[double]$r.Profit }
      if($null -ne $r.Pg){ $c.PgOOS=[double]$r.Pg }
      $okProf = ($null -ne $r.Profit)
      $okN    = ($null -ne $r.N)
      if($okProf -and $okN -and [double]$r.N -gt 0){ $c.AspOOS = [double]$r.Profit / [double]$r.N }
    }
    $c.Esito = "MISURATA"
    if($c.GemOOS -ne "IDENTICI"){
      [void]$Problemi.Add("cella " + $c.Id + ": gemelli OOS " + $c.GemOOS + " -- il banco non e' deterministico, il numero non si legge.")
    }
    if($c.GemIS -ne "IDENTICI"){
      [void]$Problemi.Add("cella " + $c.Id + ": gemelli IS " + $c.GemIS + ".")
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
$Cart = Join-Path $Dsk ("FASE2_CASSA_" + $Modo + "_" + $Stamp)
New-Item -ItemType Directory -Force -Path $Cart | Out-Null

$RefTxt = New-Object System.Collections.ArrayList
[void]$RefTxt.Add("=====================================================================")
[void]$RefTxt.Add(" FASE 2 CASSA -- validazione a TICK (ABTG_Nasdaq_Apertura_US) su " + $Simbolo + " " + $Periodo)
[void]$RefTxt.Add("=====================================================================")
[void]$RefTxt.Add("modo: " + $Modo + "   <- CONTROLLO = giro a vuoto, NON e' il risultato")
[void]$RefTxt.Add("data: " + $Avvio.ToString("yyyy-MM-dd HH:mm:ss",$INV))
[void]$RefTxt.Add("pin:  " + $Pin)
[void]$RefTxt.Add("banco: MODELLO 4 TICK REALI, deposito " + $Deposito + ", Spread=" + $Spread + " scritto nell'ini, rischio " + $RiskEA + "% (0.65 taglia di casa).")
[void]$RefTxt.Add("finestra: " + $DaQuando + " -> " + $Fino + "  (M15, UN SOLO REGIME rialzista, dichiarato)")
[void]$RefTxt.Add("   IS  " + $IS_Da + " - " + $IS_A + "   (contesto di lettura, NON selezione)")
[void]$RefTxt.Add("   OOS " + $OOS_Da + " - " + $OOS_A + "   (l'altra meta', sempre contesto)")
[void]$RefTxt.Add("sessione: 14:30 SERVER BCM (15:30 IT - 1h). FUSO NORMALE di casa: e' l'OPPOSTO")
[void]$RefTxt.Add("          della FASE 1 (li' 9:30 NY sul feed _EXT). Qui il feed e' BCM.")
[void]$RefTxt.Add("profondita' tick NASUSD: " + $TickNAS)
[void]$RefTxt.Add("terminale: " + $Terminale)
[void]$RefTxt.Add("include: " + $Include)
[void]$RefTxt.Add("compilazione: " + $Compilato)
[void]$RefTxt.Add("")
[void]$RefTxt.Add("QUESTA E' LA CASSAFORTE, NON UNO SCREENING. NON promuove niente e NON")
[void]$RefTxt.Add("tocca il forward (G5): e' l'OOS del disegno a due fasi, si apre UNA volta")
[void]$RefTxt.Add("e NON si ottimizza. La FASE 1 (OHLC 2017-2020) ha stabilito che il drive-")
[void]$RefTxt.Add("following NUDO ha edge ed e' ROBUSTO PER REGIME. QUI si misura SOLO il")
[void]$RefTxt.Add("COSTO REALE a tick (spread + slippage): la differenza fra questi numeri e")
[void]$RefTxt.Add("quelli OHLC della FASE 1 (PF 1.32, asp/trade +170).")
[void]$RefTxt.Add("")
[void]$RefTxt.Add("CRITERI DI LETTURA CONGELATI (PRIMA dei numeri):")
[void]$RefTxt.Add("  - DECIDE l'ASPETTATIVA PER TRADE a tick, con coerenza fra le due gambe.")
[void]$RefTxt.Add("  - RISCHIO MAI SOSPESO (regola B): DD e peggior giornata contro il muro")
[void]$RefTxt.Add("    prop, SEMPRE, a qualunque n. La parziale e' rimessa apposta per il DD.")
[void]$RefTxt.Add("  - CAMPIONE: >=150 trade per il MERITO; sotto, merito sospeso.")
[void]$RefTxt.Add("  - CONFRONTO SIMMETRICO-vs-LONGONLY: 00_simm meno 01_long = costo dello")
[void]$RefTxt.Add("    short su una finestra SENZA crolli (atteso: piccolo drag). Premio-")
[void]$RefTxt.Add("    assicurazione, NON un lato migliore. Il candidato e' il SIMMETRICO.")
[void]$RefTxt.Add("")
[void]$RefTxt.Add("--- LA TABELLA (OOS = l'altra meta'; IS accanto come contesto) ---")
[void]$RefTxt.Add("n/d = non misurato, MAI stimato.")
[void]$RefTxt.Add("cella      lati    n(OOS) PF(OOS) DD%(OOS) prof(OOS) asp/tr PeggG% gemOOS      | n(IS) PF(IS)")
foreach($c in $CELLE){
  $lati = $c.VLong.Substring(0,1).ToUpper() + "/" + $c.VShort.Substring(0,1).ToUpper()
  $riga = ("{0,-9} {1,-6} {2,6} {3,7} {4,8} {5,9} {6,6} {7,6}  {8,-10} | {9,5} {10,6}" -f `
           $c.Id, $lati, (FmtN $c.NOOS), (Fmt3 $c.PfOOS), (Fmt2 $c.DdOOS),
           (FmtE $c.ProfOOS), (FmtA $c.AspOOS), (FmtPg $c.PgOOS), $c.GemOOS,
           (FmtN $c.NIS), (Fmt3 $c.PfIS))
  [void]$RefTxt.Add($riga)
  [void]$RefTxt.Add("           esito: " + $c.Esito + "  |  " + $c.Desc)
}
[void]$RefTxt.Add("")
[void]$RefTxt.Add("--- COME SI LEGGE, e sono avvertenze ---")
[void]$RefTxt.Add("1. IL TICK E' IL VERDETTO SUL COSTO, non sul regime. La robustezza-per-")
[void]$RefTxt.Add("   regime e' gia' stabilita a OHLC (FASE 1). Qui la domanda e': l'edge")
[void]$RefTxt.Add("   sopravvive a spread+slippage su un feed vero? Si guarda l'aspettativa/")
[void]$RefTxt.Add("   trade e il PF, e QUANTO scendono rispetto all'OHLC.")
[void]$RefTxt.Add("2. UN SOLO REGIME (rialzista 2024.09->2026): questa finestra NON contiene")
[void]$RefTxt.Add("   crolli, quindi lo SHORT qui e' quasi solo COSTO (FASE 1: lo short rende")
[void]$RefTxt.Add("   solo nei crolli rapidi). Il delta 00_simm - 01_long e' il premio-")
[void]$RefTxt.Add("   assicurazione, e va letto cosi': un piccolo drag e' NORMALE e ATTESO.")
[void]$RefTxt.Add("3. RISCHIO SEMPRE: DD e peggior giornata contro il muro prop. La parziale")
[void]$RefTxt.Add("   rimessa (50% a 1R + breakeven) e' li' apposta per il DD 15.6% che la")
[void]$RefTxt.Add("   diagnostica all-runner mostrava a 1.0%.")
[void]$RefTxt.Add("4. IL PER-TRADE CSV per la lettura fine (in Common\Files, NON nello zip):")
[void]$RefTxt.Add("     abtg_trades_" + $EA + "_" + $Simbolo + "_<magic>.csv")
[void]$RefTxt.Add("   colonne close_time e net_profit: separa long/short e mese per mese.")
[void]$RefTxt.Add("")
if($Fatale -ne ""){
  [void]$RefTxt.Add("!!! FERMATO: " + $Fatale)
  [void]$RefTxt.Add("")
}
[void]$RefTxt.Add("PROBLEMI: " + $Problemi.Count)
foreach($p in $Problemi){ [void]$RefTxt.Add("  - " + $p) }
[void]$RefTxt.Add("RILIEVI: " + $Rilievi.Count)
foreach($p in $Rilievi){ [void]$RefTxt.Add("  - " + $p) }
[void]$RefTxt.Add("")
[void]$RefTxt.Add("NOTA: questa e' una MISURA. Non promuove, non tocca il forward (G5). Il")
[void]$RefTxt.Add("verdetto lo scrive la lettura della FASE 2 CASSA, a mano, coi criteri sopra.")
[void]$RefTxt.Add("COME SI RIPRENDE: dalla pagina righe/RIGA_FASE2_CASSA_DA_MANDARE.md, NON da")
[void]$RefTxt.Add('questa riga: $p e $pin nascono dentro il blocco e non sopravvivono.')

$refPath = Join-Path $Cart "REFERTO_FASE2_CASSA.txt"
Set-Content -LiteralPath $refPath -Value ($RefTxt -join "`r`n") -Encoding ASCII
Write-Host ($RefTxt -join "`r`n")

# --- gli artefatti: solo cio' che ha girato, copiato PER NOME.
foreach($f in @("COMPILAZIONE_FALLITA.log")){
  $src = Join-Path $Work $f
  if(Test-Path -LiteralPath $src){ Copy-Item $src -Destination $Cart -Force }
}
foreach($c in $Ordinati){
  $src = Join-Path $Prove $c.Prova
  if(Test-Path -LiteralPath $src){ Copy-Item $src -Destination $Cart -Force }
  foreach($tag in @("IS","OOS")){
    $f = Join-Path $Work ("risultati_prove\" + $EA + "\" + $EA + "_" + $Simbolo + "_" + $tag + "_" + $c.Id + ".csv")
    if(Test-Path -LiteralPath $f){ Copy-Item $f -Destination $Cart -Force }
  }
}
$zip = $Cart + ".zip"
Remove-Item -LiteralPath $zip -Force -ErrorAction SilentlyContinue
Compress-Archive -Path (Join-Path $Cart "*") -DestinationPath $zip -Force
Write-Host ""
Write-Host ("CARTELLA: " + $Cart) -ForegroundColor Green
Write-Host ("ZIP DA MANDARE: " + $zip) -ForegroundColor Green
Write-Host "FILE ATTESI NELLO ZIP: REFERTO_FASE2_CASSA.txt + i file prova girati + i CSV IS/OOS delle celle misurate" -ForegroundColor Gray

# --- CODICE D'USCITA ESPLICITO SU OGNI RAMO
if($Fatale -ne ""){ Write-Host "ESITO: FERMATO" -ForegroundColor Red; exit 1 }
if($Problemi.Count -gt 0){ Write-Host "ESITO: COMPLETATO CON PROBLEMI" -ForegroundColor Yellow; exit 3 }
Write-Host ("ESITO: " + $Modo + " COMPLETATO") -ForegroundColor Green
exit 0
