# =====================================================================
#  MARCATORE_RIGA_SHORTGATE_CASSA_v1
#  RIGA_SHORTGATE_CASSA.ps1  --  CONFERMA A TICK del BREAKDOWN SHORT GATED
#  sulla cassaforte BCM: gli ingressi dello screening EXT SOPRAVVIVONO ai
#  COSTI TICK reali sulla finestra BCM disponibile?
#  ABTG_Nasdaq_Apertura_US su NASUSD (BCM LIVE) M15, MODELLO 4 (TICK), 1 CELLA:
#     shortgate  SHORTGATE_CASSA_00  magic 768300/768301 (gemelli)
# ---------------------------------------------------------------------
#  QUESTA E' UNA MISURA DI SOPRAVVIVENZA AI COSTI, NON UN VERDETTO SULL'EDGE.
#  Lo SCREENING OHLC su NASUSD_EXT (REFERTO_SHORTGATE_2026-08-30.md) ha dato
#  FORMA VERDE: PF 1.84, DD 2.07%, edge concentrato nell'ORSO confermato per
#  regime (orso 2022 il bulk: +4020 su 49 trade, win 89.8%). QUI si prende lo
#  STESSO motore short e si misura a TICK REALI su BCM se gli ingressi che
#  scattano reggono a SPREAD + SLIPPAGE. NON promuove, NON tocca il forward.
#
#  ------------------------------------------------------------------
#  IL BANCO viene da FASE2_CASSA (BCM tick), la CONFIG MOTORE dallo SHORTGATE.
#  Ogni gate qui sotto PRETENDE il valore giusto e RIFIUTA quello dello
#  screening EXT dove i due divergono:
#
#  >>> FUSO NORMALE BCM (opposto allo screening): InpSessionHour=14,
#      InpSessionMin=30 (15:30 IT -1 = 14:30 server). Il gate PRETENDE 14/30 e
#      RIFIUTA 9. Il 9:30 era l'apertura NY sul feed _EXT a ora di New York;
#      qui il feed e' BCM e vale la regola di casa (IT-1=server). E' DICHIARATO
#      opposto allo screening: la' 9 = STOP qui, qui 14 = STOP la'.
#
#  >>> MODELLO 4 (TICK REALI), NON 1 (OHLC dello screening). E' proprio il
#      punto: si aggiungono i COSTI TICK agli ingressi.
#
#  >>> LA FINESTRA 2024.09.26 -> 2026.06.30 (pavimento TICK BCM, sonda 17/08,
#      166M tick reali gia' misurati). E' UN SOLO REGIME RIALZISTA, DICHIARATO:
#      i tick BCM sugli indici NON raggiungono NESSUN orso. Il gate H4 sparera'
#      POCO (come nel toro 2021 dello screening: ~17/anno) -> CAMPIONE SOTTILE
#      atteso -> MERITO SOSPESO (valvola R59). Il RISCHIO NON e' mai sospeso
#      (regola B): DD e peggior giornata SEMPRE. Questa corsa misura la
#      SOPRAVVIVENZA AI COSTI, NON l'edge dell'orso (irraggiungibile a tick BCM).
#
#  >>> IL MOTORE SHORT E' IDENTICO ALLO SCREENING (si misura il COSTO, non un
#      motore diverso). Il gate PRETENDE: InpEntryMode=0 (BREAKOUT drive-down,
#      RIFIUTA 2 = retest R115), InpAllowLong=false, InpAllowShort=true;
#      gate di regime InpUseEmaFilter=true, InpEmaFast=50, InpEmaSlow=200,
#      InpFilterTF=16388 (H4); pavimento SL InpMinStopPts=500 (R109),
#      InpSkipIfTight=false; rischio 0.65%.
#
#  >>> UNA SOLA TRANCHE, DICHIARATO (come lo screening EXT): FrazioneIS=1.0, la
#      gamba "IS" del driver generico e' la FINESTRA INTERA e la gamba "OOS" e'
#      degenere (0 giorni) e si IGNORA. Su un CAMPIONE SOTTILE (short che spara
#      poco nel toro) spezzare in 40/60 lascerebbe due meta' illeggibili: si
#      legge la finestra intera. La lettura long/short e mese-per-mese si fa
#      A MANO dal per-trade CSV. NOTA: a Model 4 il CSV NON ha il suffisso
#      "_ohlc" (quello era lo screening Model 1).
#
#  >>> NASUSD E' UN SIMBOLO BCM LIVE (non custom): non si importa, e' gia' nel
#      terminale. NIENTE controllo bases\Custom (quello valeva per NASUSD_EXT
#      nello screening).
#
#  >>> PROFONDITA' TICK di NASUSD: RILIEVO, non gate. Si prova a scaricare
#      misura_tick_NASUSD.csv al pin (166M tick dal 2024.09.26 gia' agli atti);
#      se NON c'e' si DICHIARA la RISERVA (a Model 4, se i tick reali non ci
#      sono MT5 NON si ferma, ripiega e produce numeri PLAUSIBILI E FALSI).
#
#  ------------------------------------------------------------------
#  PERCHE' ESISTE QUESTO FILE invece di una riga di walkforward_generico
#  incollata a mano (stessi motivi MISURATI dei gemelli):
#   1. L'INCLUDE. ABTG_Nasdaq_Apertura_US.mq5 fa #include <ABTG_PausaGuardian.mqh>
#      e il driver generico NON lo installa: si scarica al pin e si copia PRIMA
#      di compilare.
#   2. I GATE DELLE INVERSIONI. Fuso 14/30 (rifiuta 9), Model 4, direzione
#      costitutiva (BREAKOUT 0, solo short), gate di regime (EMA 50x200 H4),
#      pavimento SL, rischio 0.65, magic vergini, periodo M15: si controllano
#      PRIMA di aprire MT5. Il driver generico blinda tutto al DEFAULT del
#      sorgente (il DAX) e non li conosce.
#   3. LA RACCOLTA (regola di casa CLAUDE.md): Desktop + zip + referto.
#
#  NIENTE ABLAZIONE A STELLA: 1 cella + gemello. L'unico asse spazzolato e'
#  InpMagic (due passate identiche al centesimo = igiene del banco). Config
#  FISSA: e' una misura, NON un'ottimizzazione.
#
#  LA RIGA CHE SI INCOLLA sta in righe\RIGA_SHORTGATE_CASSA_DA_MANDARE.md
# =====================================================================
[CmdletBinding()]
param(
  # -Pin NON ha default: un default silenzioso ("lavoro") farebbe girare la
  #  punta del branch spacciandola per un commit congelato. Meglio morire.
  [string]$Pin           = "",
  [switch]$SoloControllo,          # giro a vuoto: NON apre MT5
  [switch]$Rifai,                  # rifa' anche il CSV gia' presente
  [string]$Simbolo       = "NASUSD",
  [string]$Periodo       = "M15",
  [string]$DaQuando      = "2024.09.26",
  [string]$Fino          = "2026.06.30",
  [int]$Deposito         = 100000,
  [int]$Spread           = 0,      # 0 = spread CORRENTE, ma SCRITTO nell'ini
  [double]$OreMax        = 12.0
)
$ErrorActionPreference = "Stop"
# --- RETE DI SICUREZZA SUL CODICE D'USCITA: un errore fuori dai try non deve
#     far uscire pwsh con 0. Con questo trap un'uscita anomala e' SEMPRE 1.
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
$Work   = Join-Path $env:USERPROFILE "abtg_shortgate_cassa"
$Prove  = Join-Path $Work "prove"
$RawPin = "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$Pin"

# --- TUTTO CIO' CHE LA RACCOLTA USA NASCE QUI, PRIMA DEL try. In PowerShell
#     una function e' un'ISTRUZIONE: se il flusso non ci passa sopra il nome
#     non esiste, e la raccolta esploderebbe proprio nella corsa fermata da un
#     gate, cioe' l'unica in cui il referto serve davvero.
$Problemi  = New-Object System.Collections.ArrayList
$Rilievi   = New-Object System.Collections.ArrayList
$Fatale    = ""
$Include   = "NON INSTALLATO"
$Terminale = "n/d"
$Compilato = "NON TENTATA"
$RiskEA    = "n/d"
$TickNAS   = "NON VERIFICATA"
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
#  LA CELLA UNICA. F* = i valori che il gate PRETENDE nel file prova (banco
#  BCM + motore short): se il file venisse scambiato o corrotto, il gate lo
#  prende PRIMA di aprire MT5.
# =====================================================================
$CELLA = [pscustomobject]@{
  Id="shortgate"; Prova="SHORTGATE_CASSA_00.txt";
  Desc="breakdown short GATED da EMA 50x200 H4 (drive-down following, SOLO short) -- TICK BCM";
  M1=768300; M2=768301;
  Esito="NON ESEGUITA"; Gemelli="NON MISURATO";
  N=-1; Pf=-1.0; Dd=-1.0; Prof=-999999.0; Pg=99.9; Asp=-999999.0 }

# --- I MAGIC VIETATI: seconda rete oltre al gate M1/M2. Il blocco 7683xx di
#     questa CASSA e' VERGINE (cercato in tutto il repo il 2026-08-30: zero
#     occorrenze). La lista vieta: screening EXT (767120/767121), FASE 2 CASSA
#     (7681xx), INVES (7690xx-7692xx), FASE 1 (7672xx), PASSO0/short (767xxx),
#     R115 (766xxx) e altri round/sedie. Riusarne uno mescolerebbe i deal di
#     due misure nella cache del tester e negli export per-trade (il magic e'
#     nel nome).
$MagicVietati = @(773500,773501,
                  767120,767121,                                              # screening EXT
                  768100,768101,768110,768111,                                # FASE 2 CASSA (7681xx)
                  769000,769001,769010,769011,769020,769021,769045,           # INVES (7690xx)
                  769192,769446,769486,769728,                                # INVES / prop
                  768195,768516,768529,768540,768541,768562,768785,           # SupertrendReversal / prop / snapshot
                  767200,767201,767210,767211,767220,767221,767230,767231,   # FASE 1 (7672xx)
                  767700,767701,767710,767711,767740,767741,767800,767801,   # PASSO0 / short (767xxx)
                  766000,766010,766011,766020,766021,766030,766031,           # R115 (766xxx)
                  766110,766111,766120,766121,766210,766211,766220,766221,
                  765000,765010,765020,765213,
                  770101,770111,770201,770202,770411,770402,770511,770601,770611,770901,770532)

try{
  Titolo "CONFERMA A TICK -- breakdown short GATED (ABTG_Nasdaq_Apertura_US, NASUSD BCM) -- modo $Modo"

  # -------------------------------------------------------------------
  #  0. LE GUARDIE, PRIMA DI TOCCARE QUALUNQUE COSA
  # -------------------------------------------------------------------
  if($Pin -eq ""){ throw "-Pin obbligatorio: senza, girerebbe la punta del branch spacciandola per un commit congelato." }
  if($Pin -notmatch '^[0-9a-f]{40}$'){ throw ("-Pin deve essere un commit di 40 caratteri esadecimali, ricevuto: " + $Pin) }
  if(Get-Process terminal64,metaeditor64 -ErrorAction SilentlyContinue){
    throw "MT5 O METAEDITOR APERTO: col terminale aperto il tester non gira (zero CSV), con MetaEditor aperto la compilazione torna subito senza compilare."
  }
  if($Periodo -ne "M15"){
    [void]$Rilievi.Add("PERIODO diverso da M15 (" + $Periodo + "): il file prova dichiara @PERIODO M15 e il gate lo confronta.")
  }
  GateDate "argomenti della riga" $DaQuando $Fino

  Dico ("pin ......... " + $Pin)
  Dico ("cella ....... 1 (shortgate, + gemello) -- CONFERMA A TICK, NIENTE ablazione a stella")
  Dico ("simbolo ..... " + $Simbolo + " " + $Periodo + " (BCM live; fuso IT-1: apertura 15:30 IT = 14:30 server)")
  Dico ("finestra .... " + $DaQuando + " -> " + $Fino + "   (UN SOLO REGIME rialzista; tranche unica, FrazioneIS=1.0)")
  Dico ("banco ....... MODELLO 4 (TICK REALI). Deposito " + $Deposito + ", Spread=" + $Spread + " scritto nell'ini, rischio 0.65%")
  Dico ("nota ........ merito SOSPESO (campione sottile atteso, valvola R59); il RISCHIO no (regola B). Si misura la SOPRAVVIVENZA AI COSTI.")

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

  Scarica ($RawPin + "/backtest_pipeline/prove/" + $CELLA.Prova) (Join-Path $Prove $CELLA.Prova)
  Dico ("file prova scaricato: " + $CELLA.Prova) "Green"

  $incSrc = Join-Path $Work "ABTG_PausaGuardian.mqh"
  Scarica ($RawPin + "/mql5/Include/ABTG_PausaGuardian.mqh") $incSrc
  Dico ("include scaricato: ABTG_PausaGuardian.mqh (" + (Get-Item $incSrc).Length + " byte)") "Green"

  # -------------------------------------------------------------------
  #  2. I GATE SUL FILE PROVA -- girano PRIMA di aprire MT5
  # -------------------------------------------------------------------
  Titolo "2. GATE SUL FILE PROVA"
  $fProva = Join-Path $Prove $CELLA.Prova
  $righe = RigheVive $fProva
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
    if($h.ContainsKey($nome)){ throw ($CELLA.Prova + ": DUE righe per '" + $nome + "'. In [TesterInputs] un parametro doppio fa fare a MT5 ZERO passate.") }
    $h[$nome] = $val
    if($val -match '\|\|\s*[Yy]\s*$'){ $nY++; $nomeY = $nome }
  }
  if($nY -ne 1){ throw ($CELLA.Prova + ": deve avere ESATTAMENTE un asse con flag Y, trovati " + $nY + ".") }
  if($nomeY -ne "InpMagic"){ throw ($CELLA.Prova + ": l'unico asse Y deve essere InpMagic (config FISSA, misura), invece e' " + $nomeY + ".") }

  # GATE GEOMETRIA: simbolo, periodo, finestra
  if($h["@SIMBOLO"]  -ne $Simbolo){  throw ($CELLA.Prova + ": @SIMBOLO e' " + $h["@SIMBOLO"] + ", atteso " + $Simbolo + " (BCM live, NON NASUSD_EXT).") }
  if($h["@PERIODO"]  -ne $Periodo){  throw ($CELLA.Prova + ": @PERIODO e' " + $h["@PERIODO"] + ", atteso " + $Periodo) }
  if($h["@DAQUANDO"] -ne $DaQuando){ throw ($CELLA.Prova + ": @DAQUANDO e' " + $h["@DAQUANDO"] + ", atteso " + $DaQuando) }
  if($h["@FINOA"]    -ne $Fino){     throw ($CELLA.Prova + ": @FINOA e' " + $h["@FINOA"] + ", atteso " + $Fino) }

  # GATE DEL FUSO NORMALE BCM (opposto allo screening EXT): qui il feed e' BCM e
  # vale la regola di casa IT-1=server. Nasdaq 15:30 IT = 14:30 server. Il gate
  # PRETENDE 14/30 e RIFIUTA 9 (il 9:30 era l'apertura NY del feed _EXT).
  $ssh = ($h["InpSessionHour"] -split '\|\|')[0]
  $ssm = ($h["InpSessionMin"]  -split '\|\|')[0]
  if($ssh -eq "9"){  throw ($CELLA.Prova + ": InpSessionHour=9 e' l'ora NY del feed _EXT (screening). Sulla cassaforte NASUSD (BCM) il fuso e' IT-1: apertura 15:30 IT = 14:30 server. Qui va 14.") }
  if($ssh -ne "14"){ throw ($CELLA.Prova + ": InpSessionHour deve essere 14 (14:30 server BCM = 15:30 IT), trovato '" + $ssh + "'.") }
  if($ssm -ne "30"){ throw ($CELLA.Prova + ": InpSessionMin deve essere 30 (apertura 14:30 server), trovato '" + $ssm + "'.") }

  # GATE DELLA DIREZIONE COSTITUTIVA: BREAKOUT (drive-down following), SOLO
  # short. Il RETEST (InpEntryMode=2) e' il meccanismo bocciato da R115: VIETATO.
  $vEntry = ($h["InpEntryMode"] -split '\|\|')[0]
  $vLong  = ($h["InpAllowLong"]  -split '\|\|')[0]
  $vShort = ($h["InpAllowShort"] -split '\|\|')[0]
  if($vEntry -eq "2"){ throw ($CELLA.Prova + ": InpEntryMode=2 (RETEST) VIETATO: e' il meccanismo bocciato da R115. L'ipotesi e' il BREAKDOWN (InpEntryMode=0, drive-down following).") }
  if($vEntry -ne "0"){ throw ($CELLA.Prova + ": InpEntryMode deve essere 0 (BREAKOUT=drive-down following), trovato '" + $vEntry + "'.") }
  if($vLong -ne "false"){ throw ($CELLA.Prova + ": InpAllowLong deve essere false (SOLO SHORT), trovato '" + $vLong + "'.") }
  if($vShort -ne "true"){ throw ($CELLA.Prova + ": InpAllowShort deve essere true (SOLO SHORT), trovato '" + $vShort + "'.") }

  # GATE DEL REGIME (il gate E' il motore): EMA 50x200 su H4 ribassista. E' lo
  # STESSO gate dello screening EXT: qui NON si cambia il motore, solo i costi.
  $vEma  = ($h["InpUseEmaFilter"] -split '\|\|')[0]
  $vFast = ($h["InpEmaFast"]      -split '\|\|')[0]
  $vSlow = ($h["InpEmaSlow"]      -split '\|\|')[0]
  $vFtf  = ($h["InpFilterTF"]     -split '\|\|')[0]
  if($vEma -ne "true"){  throw ($CELLA.Prova + ": InpUseEmaFilter deve essere true (il gate di regime E' il motore, come lo screening), trovato '" + $vEma + "'.") }
  if($vFast -ne "50"){   throw ($CELLA.Prova + ": InpEmaFast deve essere 50 (gate regime, cross 50x200), trovato '" + $vFast + "'.") }
  if($vSlow -ne "200"){  throw ($CELLA.Prova + ": InpEmaSlow deve essere 200 (gate regime, cross 50x200), trovato '" + $vSlow + "'.") }
  if($vFtf -ne "16388"){ throw ($CELLA.Prova + ": InpFilterTF deve essere 16388 (H4: il gate di regime e' su H4), trovato '" + $vFtf + "'.") }

  # GATE PAVIMENTO SL (R109): mai 0, il pavimento si APPLICA non salta.
  $mfloor = ($h["InpMinStopPts"]  -split '\|\|')[0]
  $mskip  = ($h["InpSkipIfTight"] -split '\|\|')[0]
  if($mfloor -eq "0" -or $mfloor -eq "0.0"){ throw ($CELLA.Prova + ": InpMinStopPts=0 VIETATO (R109): il pavimento SL e' 500, mai 0.") }
  if($mfloor -ne "500" -and $mfloor -ne "500.0"){ throw ($CELLA.Prova + ": InpMinStopPts deve essere 500 (R109), trovato '" + $mfloor + "'.") }
  if($mskip -eq "true" -or $mskip -eq "1"){ throw ($CELLA.Prova + ": InpSkipIfTight=true fa SALTARE il trade stretto. Il pavimento si APPLICA: false.") }
  if($mskip -ne "false" -and $mskip -ne "0"){ throw ($CELLA.Prova + ": InpSkipIfTight deve essere false (il pavimento si applica), trovato '" + $mskip + "'.") }

  # GATE DEL RISCHIO: 0.65% (conservativo). Lo leggo e lo dichiaro.
  $vRisk = ($h["InpRiskPercent"] -split '\|\|')[0]
  if($vRisk -ne "0.65"){ throw ($CELLA.Prova + ": InpRiskPercent deve essere 0.65 (conservativo), trovato '" + $vRisk + "'.") }
  $RiskEA = $vRisk

  # GATE DEI MAGIC: vergini, mai uno vietato, e i due gemelli esatti.
  $mg = $h["InpMagic"] -split '\|\|'
  $magicVisti = @{}
  foreach($v in @($mg[1],$mg[3])){
    $n = [int]$v
    if($MagicVietati -contains $n){ throw ($CELLA.Prova + ": magic " + $n + " e' VIETATO (screening EXT, sedia viva o round recente).") }
    if($magicVisti.ContainsKey($n)){ throw ("magic " + $n + " ripetuto nei due gemelli: un solo magic per gemello.") }
    $magicVisti[$n] = 1
  }
  if([int]$mg[1] -ne $CELLA.M1 -or [int]$mg[3] -ne $CELLA.M2){
    throw ($CELLA.Prova + ": i magic gemelli sono " + $mg[1] + "/" + $mg[3] + ", la cella li vuole " + $CELLA.M1 + "/" + $CELLA.M2)
  }
  Dico "geometria, FUSO 14/30 (rifiuta 9), direzione costitutiva (BREAKOUT 0, solo short), gate regime (EMA 50x200 H4), pavimento SL (R109), rischio 0.65 e magic vergini: TUTTI PASSATI" "Green"

  # -------------------------------------------------------------------
  #  3. IL TERMINALE, L'INCLUDE E LA COMPILAZIONE
  # -------------------------------------------------------------------
  Titolo "3. TERMINALE, INCLUDE, COMPILAZIONE"
  # LO STESSO SELETTORE, RIGA PER RIGA, DI walkforward_generico.ps1.
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
  #  3b. PROFONDITA' TICK di NASUSD -- RILIEVO, non gate
  # -------------------------------------------------------------------
  $tk = Join-Path $Work "misura_tick_NASUSD.csv"
  try{
    Scarica ($RawPin + "/backtest_pipeline/risultati_archivio/misura_tick/misura_tick_NASUSD.csv") $tk
    $riga = @(Get-Content -LiteralPath $tk | Where-Object { $_ -match '(?i)TICK' } | Select-Object -First 1)
    if($riga.Count -gt 0){ $TickNAS = ("" + $riga[0]).Trim() } else { $TickNAS = "file presente ma senza riga TICK" }
  }catch{
    $TickNAS = "NON MISURATA (nessun misura_tick_NASUSD.csv al pin)"
    [void]$Rilievi.Add("PROFONDITA' TICK NON MISURATA su NASUSD: a Model 4, se i tick reali non ci sono MT5 NON si ferma, ripiega e produce numeri PLAUSIBILI E FALSI. Ogni numero va letto con questa RISERVA finche' non si gira misura_tick su NASUSD.")
  }
  Dico ("profondita' tick NASUSD: " + $TickNAS) "Gray"

  # -------------------------------------------------------------------
  #  4. LA CORSA -- Model 4 (tick reali), tranche unica (FrazioneIS 1.0)
  # -------------------------------------------------------------------
  Titolo "4. LA CORSA"
  if($OreMax -le 0){ $OreMax = 12.0 }
  $Risultati = Join-Path $Work ("risultati_prove\" + $EA)
  Dico ("cella " + $CELLA.Id + " -- " + $CELLA.Desc) "Cyan"
  # NON si chiama $args: e' una VARIABILE AUTOMATICA di PowerShell.
  $argv = @("-ExecutionPolicy","Bypass","-File",$drv,
            "-Expert",$EA,
            "-Prova",$fProva,
            "-Etichetta",$CELLA.Id,
            "-Simbolo",$Simbolo,
            "-Periodo",$Periodo,
            "-DaQuando",$DaQuando,
            "-Fino",$Fino,
            "-FrazioneIS","1.0",
            "-Modello","4",
            "-Deposito",("" + $Deposito),
            "-Spread",("" + $Spread))
  if($SoloControllo){ $argv += "-SoloControllo" }
  if($Rifai){ $argv += "-Rifai" }
  $global:LASTEXITCODE = 0
  & powershell $argv
  $rc = $LASTEXITCODE
  if($rc -ne 0){
    $CELLA.Esito = "FERMATA (codice " + $rc + ")"
    [void]$Problemi.Add("cella " + $CELLA.Id + ": il driver generico e' uscito con codice " + $rc)
  }
  elseif($SoloControllo){ $CELLA.Esito = "CONTROLLO OK" }
  else{
    # TRANCHE UNICA: si legge la gamba "IS" del driver generico (con
    # FrazioneIS=1.0 e' la FINESTRA INTERA). Model 4 -> NESSUN suffisso "_ohlc".
    # La gamba "OOS" e' degenere e NON si legge.
    $csvWin = Join-Path $Risultati ($EA + "_" + $Simbolo + "_IS_" + $CELLA.Id + ".csv")
    $rWin = LeggiOpt $csvWin
    if($null -eq $rWin){
      $CELLA.Esito = "CSV NON LEGGIBILE"
      [void]$Problemi.Add("cella " + $CELLA.Id + ": CSV mancante o intestazioni non riconosciute. Viste: " + ($script:CsvIntestazioni -join " | "))
    }
    else{
      $CELLA.Gemelli = Gemelli $rWin
      $CELLA.N    = $rWin[0].N
      $CELLA.Pf   = $rWin[0].Pf
      $CELLA.Dd   = $rWin[0].Dd
      $CELLA.Prof = $rWin[0].Profit
      if($null -ne $rWin[0].Pg){ $CELLA.Pg = $rWin[0].Pg }
      $okProf = ($null -ne $rWin[0].Profit)
      $okN    = ($null -ne $rWin[0].N)
      if($okProf -and $okN -and [double]$rWin[0].N -gt 0){ $CELLA.Asp = [double]$rWin[0].Profit / [double]$rWin[0].N }
      $CELLA.Esito = "MISURATA"
      if($CELLA.Gemelli -ne "IDENTICI"){
        [void]$Problemi.Add("cella " + $CELLA.Id + ": gemelli " + $CELLA.Gemelli + " -- il banco non e' deterministico, il numero non si legge.")
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
Titolo "RACCOLTA"
$Cart = Join-Path $Dsk ("SHORTGATE_CASSA_" + $Modo + "_" + $Stamp)
New-Item -ItemType Directory -Force -Path $Cart | Out-Null

$RefTxt = New-Object System.Collections.ArrayList
[void]$RefTxt.Add("=====================================================================")
[void]$RefTxt.Add(" CONFERMA A TICK -- breakdown short GATED (ABTG_Nasdaq_Apertura_US) su " + $Simbolo + " " + $Periodo)
[void]$RefTxt.Add("=====================================================================")
[void]$RefTxt.Add("modo: " + $Modo + "   <- CONTROLLO = giro a vuoto, NON e' il risultato")
[void]$RefTxt.Add("data: " + $Avvio.ToString("yyyy-MM-dd HH:mm:ss",$INV))
[void]$RefTxt.Add("pin:  " + $Pin)
[void]$RefTxt.Add("banco: MODELLO 4 TICK REALI, deposito " + $Deposito + ", Spread=" + $Spread + " scritto nell'ini, rischio " + $RiskEA + "% (0.65 conservativo).")
[void]$RefTxt.Add("finestra: " + $DaQuando + " -> " + $Fino + "  (M15, UN SOLO REGIME rialzista; tranche unica, FrazioneIS=1.0)")
[void]$RefTxt.Add("sessione: 14:30 SERVER BCM (15:30 IT - 1h). FUSO NORMALE di casa: e' l'OPPOSTO")
[void]$RefTxt.Add("          dello screening EXT (li' 9:30 NY sul feed _EXT). Qui il feed e' BCM.")
[void]$RefTxt.Add("direzione: BREAKDOWN short (InpEntryMode=0, drive-down following), SOLO short.")
[void]$RefTxt.Add("gate regime: EMA 50x200 su H4 ribassista (il gate E' il motore, come lo screening).")
[void]$RefTxt.Add("profondita' tick NASUSD: " + $TickNAS)
[void]$RefTxt.Add("terminale: " + $Terminale)
[void]$RefTxt.Add("include: " + $Include)
[void]$RefTxt.Add("compilazione: " + $Compilato)
[void]$RefTxt.Add("")
[void]$RefTxt.Add("QUESTA E' UNA MISURA DI SOPRAVVIVENZA AI COSTI, NON UN VERDETTO SULL'EDGE.")
[void]$RefTxt.Add("Lo SCREENING OHLC su EXT (REFERTO_SHORTGATE_2026-08-30.md) ha dato FORMA")
[void]$RefTxt.Add("VERDE (PF 1.84, edge nell'orso confermato per regime). QUI si prende lo")
[void]$RefTxt.Add("STESSO motore short e si misura a TICK REALI su BCM se gli ingressi che")
[void]$RefTxt.Add("scattano reggono a SPREAD + SLIPPAGE. NON promuove, NON tocca il forward.")
[void]$RefTxt.Add("")
[void]$RefTxt.Add("IL LIMITE STRUTTURALE, DICHIARATO: i tick BCM sugli indici partono dal")
[void]$RefTxt.Add("26/09/2024 -> NON raggiungono NESSUN orso. Questa finestra e' UN SOLO")
[void]$RefTxt.Add("REGIME RIALZISTA: il gate H4 sparera' POCO (come nel toro 2021 dello")
[void]$RefTxt.Add("screening: ~17 trade/anno). CAMPIONE SOTTILE atteso -> MERITO SOSPESO")
[void]$RefTxt.Add("(valvola R59). Il RISCHIO NON e' mai sospeso (regola B): DD e peggior")
[void]$RefTxt.Add("giornata SEMPRE, a qualunque n.")
[void]$RefTxt.Add("")
[void]$RefTxt.Add("CRITERI DI LETTURA CONGELATI (PRIMA dei numeri):")
[void]$RefTxt.Add("  - DECIDE la SOPRAVVIVENZA AI COSTI: l'aspettativa/trade a tick resta")
[void]$RefTxt.Add("    positiva? di quanto scende rispetto alla FORMA OHLC dello screening?")
[void]$RefTxt.Add("  - RISCHIO MAI SOSPESO (regola B): DD e peggior giornata contro il muro,")
[void]$RefTxt.Add("    SEMPRE, a qualunque n.")
[void]$RefTxt.Add("  - MERITO: >=150 trade per giudicarlo; sotto (atteso qui), sospeso. Non")
[void]$RefTxt.Add("    e' una bocciatura ne' una promozione: e' una misura sotto-campionata.")
[void]$RefTxt.Add("")
[void]$RefTxt.Add("--- LA TABELLA (finestra intera 2024.09-2026.06, tranche unica, TICK) ---")
[void]$RefTxt.Add("n/d = non misurato, MAI stimato.")
[void]$RefTxt.Add("cella        n      PF      DD%   Profit    asp/tr  PeggGio%  gemelli")
$riga = ("{0,-11} {1,5} {2,7} {3,8} {4,8} {5,8} {6,9}  {7}" -f `
         $CELLA.Id, (FmtN $CELLA.N), (Fmt3 $CELLA.Pf), (Fmt2 $CELLA.Dd),
         (FmtE $CELLA.Prof), (FmtA $CELLA.Asp), (FmtPg $CELLA.Pg), $CELLA.Gemelli)
[void]$RefTxt.Add($riga)
[void]$RefTxt.Add("            esito: " + $CELLA.Esito + "  |  " + $CELLA.Desc)
[void]$RefTxt.Add("")
[void]$RefTxt.Add("--- COME SI LEGGE, e sono avvertenze ---")
[void]$RefTxt.Add("1. IL TICK E' IL VERDETTO SUL COSTO, non sul regime. La forma dell'edge e'")
[void]$RefTxt.Add("   gia' letta a OHLC nello screening (verde nell'orso). Qui la domanda e':")
[void]$RefTxt.Add("   gli ingressi che scattano nel toro reggono a spread+slippage? Si guarda")
[void]$RefTxt.Add("   l'aspettativa/trade e QUANTO scende rispetto all'OHLC.")
[void]$RefTxt.Add("2. NIENTE ORSO NEI DATI: questa finestra e' solo-toro. Lo short qui e' quasi")
[void]$RefTxt.Add("   solo COSTO (l'edge vive nei crolli, che a tick su BCM non ci sono). Un")
[void]$RefTxt.Add("   risultato magro o negativo NON boccia il motore: e' regime sbagliato per")
[void]$RefTxt.Add("   uno short, dichiarato PRIMA. Il verdetto sull'edge resta OHLC/Dukascopy.")
[void]$RefTxt.Add("3. IL GATE E' IL MOTORE. Pochi trade nel toro (~17/anno) e' il comportamento")
[void]$RefTxt.Add("   VOLUTO: il gate H4 non arma lo short quando il regime e' rialzista.")
[void]$RefTxt.Add("4. IL PER-TRADE CSV per la lettura fine (in Common\Files, NON nello zip):")
[void]$RefTxt.Add("     abtg_trades_" + $EA + "_" + $Simbolo + "_<magic>.csv")
[void]$RefTxt.Add("   colonne close_time e net_profit: mese per mese, per vedere QUANDO spara.")
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
[void]$RefTxt.Add("NOTA: questa e' una MISURA. Non promuove, non tocca il forward. Il verdetto")
[void]$RefTxt.Add("lo scrive la lettura a mano, coi criteri congelati sopra.")
[void]$RefTxt.Add('COME SI RIPRENDE: dalla pagina righe/RIGA_SHORTGATE_CASSA_DA_MANDARE.md, NON da')
[void]$RefTxt.Add('questa riga: $p e $pin nascono dentro il blocco e non sopravvivono.')

$refPath = Join-Path $Cart "REFERTO_SHORTGATE_CASSA.txt"
Set-Content -LiteralPath $refPath -Value ($RefTxt -join "`r`n") -Encoding ASCII
Write-Host ($RefTxt -join "`r`n")

# --- gli artefatti: solo cio' che ha girato, copiato PER NOME.
foreach($f in @("COMPILAZIONE_FALLITA.log")){
  $src = Join-Path $Work $f
  if(Test-Path -LiteralPath $src){ Copy-Item $src -Destination $Cart -Force }
}
$srcProva = Join-Path $Prove $CELLA.Prova
if(Test-Path -LiteralPath $srcProva){ Copy-Item $srcProva -Destination $Cart -Force }
$fCsv = Join-Path $Work ("risultati_prove\" + $EA + "\" + $EA + "_" + $Simbolo + "_IS_" + $CELLA.Id + ".csv")
if(Test-Path -LiteralPath $fCsv){ Copy-Item $fCsv -Destination $Cart -Force }

$zip = $Cart + ".zip"
Remove-Item -LiteralPath $zip -Force -ErrorAction SilentlyContinue
Compress-Archive -Path (Join-Path $Cart "*") -DestinationPath $zip -Force
Write-Host ""
Write-Host ("CARTELLA: " + $Cart) -ForegroundColor Green
Write-Host ("ZIP DA MANDARE: " + $zip) -ForegroundColor Green
Write-Host "FILE ATTESI NELLO ZIP: REFERTO_SHORTGATE_CASSA.txt + il file prova + il CSV della finestra intera" -ForegroundColor Gray

# --- CODICE D'USCITA ESPLICITO SU OGNI RAMO
if($Fatale -ne ""){ Write-Host "ESITO: FERMATO" -ForegroundColor Red; exit 1 }
if($Problemi.Count -gt 0){ Write-Host "ESITO: COMPLETATO CON PROBLEMI" -ForegroundColor Yellow; exit 3 }
Write-Host ("ESITO: " + $Modo + " COMPLETATO") -ForegroundColor Green
exit 0
