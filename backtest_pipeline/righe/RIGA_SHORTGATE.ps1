# =====================================================================
#  MARCATORE_RIGA_SHORTGATE_v1
#  RIGA_SHORTGATE.ps1  --  SCREENING SHORT ORSO: il breakdown short GATED
#  da regime H4 ribassista, misurato su storico ESTERNO che CONTIENE l'orso.
#  ABTG_Nasdaq_Apertura_US su NASUSD_EXT M15, OHLC (Modello 1), UNA CELLA:
#     shortgate  SHORTGATE_NAS_BREAKDOWN  magic 767120/767121 (gemelli)
# ---------------------------------------------------------------------
#  QUESTO E' UNO SCREENING DIAGNOSTICO (si'/no). NON PROMUOVE NIENTE E NON
#  DA' UN VERDETTO. Dossier firmato:
#    backtest_pipeline\caccia_strategie\CACCIA_SHORT_INDICI_2026-08-29.md
#    File prova (criteri congelati PRIMA dei numeri):
#    backtest_pipeline\prove\SHORTGATE_NAS_BREAKDOWN.txt
#
#  LA DOMANDA (una sola, diagnostica): il breakdown short GATED da H4
#  ribassista ha un edge nelle finestre ORSO (crollo 2020-02/04 e orso 2022)
#  che i 21 mesi solo-toro di BCM nascondono PER COSTRUZIONE? Se anche qui e'
#  un drag come R98/R115 -> lo short in apertura indici e' chiuso ONESTAMENTE,
#  orso incluso. Se mostra edge SOLO nei sotto-periodi orso -> vale un round
#  vero (griglia stretta su buffer/EMA). E' un motore che ABBIAMO GIA'
#  (porting ZERO) configurato in un modo MAI misurato: BREAKDOWN (drive-down
#  following, InpEntryMode=0) SOLO SHORT, gate EMA 50x200 su H4.
#
#  ------------------------------------------------------------------
#  >>> IL TETTO DEL BANCO, DICHIARATO E LOAD-BEARING (dossier par.4 e par.5):
#      questo gira a MODELLO 1 (OHLC su barre M1 HistData del feed _EXT), NON
#      a tick reali BCM. OHLC INGANNA: qui si legge la FORMA dell'edge
#      (verde/rosso, ordini di grandezza), MAI i numeri fini. E il VERDETTO A
#      TICK NELL'ORSO E' IMPOSSIBILE: i tick BCM sugli indici partono dal
#      26/09/2024 (REFERTO_SONDA_STORICO_17-08.md 3), non raggiungono NESSUN
#      orso. Il CANCELLO ZERO qualita'-feed indici e' ANCORA CHIUSO (diff
#      media H1 0,061-0,101% contro <=0,05%): questo screening OHLC su EXT va
#      letto con quella riserva. Non e' un verdetto e non lo diventa qui.
#
#  >>> LA LETTURA SI SEGMENTA PER REGIME (critico). La finestra 2020->2024
#      mescola crollo 2020, toro 2021, orso 2022, ripartenza 2023: una media
#      che non descrive nessun mercato (CLAUDE.md punto C). Il numero che
#      conta e' il comportamento nei DUE sotto-periodi ORSO (crollo 2020-02/04
#      e orso 2022), NON il totale. Nel toro 2021 ci si ASPETTA che il gate
#      lo tenga per lo piu' FLAT: e' il comportamento voluto. La segmentazione
#      si fa A MANO dal per-trade CSV (Common\Files), colonne close_time e
#      net_profit. PROMOSSO solo se nelle finestre orso l'aspettativa/trade e'
#      positiva (al netto spread >=1.5 punti indice, R55) E il DD orso non
#      peggiora il rischio della flotta. RISCHIO MAI SOSPESO a qualunque n;
#      >=150 trade per giudicare il MERITO. Deve battere i caduti (R98/R115
#      short, R108/R109 fade).
#
#  >>> IL FUSO E' INVERTITO RISPETTO ALLA REGOLA DI CASA (critico). Su
#      NASUSD_EXT il feed HistData e' a ora di NEW YORK: l'anatomia lo ha
#      MISURATO (canarino DST verde, LETTURA_ANATOMIA_APERTURE_2026-08-26.md:
#      "le 09:30 del file sono l'apertura cash TUTTO l'anno"). Percio' il gate
#      PRETENDE InpSessionHour=9, InpSessionMin=30 e RIFIUTA 14. Il 14:30
#      SERVER vale SOLO per la cella tick della cassaforte (NASUSD BCM), NON
#      per questo screening _EXT. E' l'OPPOSTO della regola di casa NASUSD, ed
#      e' giusto cosi' perche' il feed e' un altro (misurato, non assunto).
#      NOTA: la prima stesura del file prova portava 14 (assumeva un mapping
#      server); e' stato CORRETTO a 9 il 30/08, coerente con la misura FASE2
#      sullo STESSO feed. Il gate lo blinda: 14 = STOP.
#
#  >>> IL GATE DI REGIME E' IL MOTORE, NON UN CEROTTO (dossier par.1). Lo
#      short e' ammesso SOLO se EMA fast<slow su H4 (regime ribassista):
#      TrendBias() righe 1570-1571 di ABTG_Nasdaq_Apertura_US.mq5. Il gate
#      PRETENDE InpUseEmaFilter=true, InpEmaFast=50, InpEmaSlow=200,
#      InpFilterTF=16388 (H4). Senza orso il gate tiene l'EA FLAT: e' voluto.
#      La DIREZIONE e' COSTITUTIVA: InpEntryMode=0 (BREAKOUT=drive-down
#      following), InpAllowLong=false, InpAllowShort=true. Il gate RIFIUTA
#      InpEntryMode=2 (RETEST, il meccanismo bocciato da R115).
#
#  >>> IL PAVIMENTO SL (R109): InpMinStopPts=500 (5 punti indice), MAI 0.
#      InpSkipIfTight=false = il pavimento si APPLICA, non fa saltare il trade.
#      Il gate lo pretende e RIFIUTA 0.
#
#  ------------------------------------------------------------------
#  PERCHE' ESISTE QUESTO FILE invece di una riga di walkforward_generico.ps1
#  incollata a mano (stessi motivi MISURATI di FASE2_DRIVE):
#   1. L'INCLUDE. ABTG_Nasdaq_Apertura_US.mq5 fa
#        #include <ABTG_PausaGuardian.mqh>
#      e walkforward_generico.ps1 NON lo installa: si scarica al pin e si
#      copia PRIMA di compilare. (L'altro include, Trade\Trade.mqh, e' di serie.)
#   2. IL GATE DEL FUSO INVERTITO. Il default del sorgente e' il DAX; qui si
#      CONTROLLA che il file prova porti la sessione a ora NY (9/30) e si
#      RIFIUTA 14 (ora server, sul feed _EXT sarebbe l'ora sbagliata).
#   3. I GATE DEL ROUND SHORT. Direzione costitutiva (BREAKOUT 0, solo short),
#      gate di regime (EMA 50x200 su H4), pavimento SL, magic vergini, periodo
#      M15: si controllano PRIMA di aprire MT5. Il driver generico non li conosce.
#   4. LA RACCOLTA (regola di casa CLAUDE.md, righe di lancio punto 2): a fine
#      test i risultati sul Desktop e in uno zip pronto da mandare.
#
#  ------------------------------------------------------------------
#  UNA SOLA TRANCHE, DICHIARATO: finestra 2020.01.01 -> 2024.01.01 (~4 anni,
#  sotto il tetto ~100k barre del tester su M15), multi-regime (crollo 2020,
#  toro 2021, orso 2022, ripartenza 2023). NON c'e' split IS/OOS interno: si
#  passa -FrazioneIS 1.0, cosi' la gamba "IS" del driver generico e' la
#  FINESTRA INTERA e la gamba "OOS" e' degenere (0 giorni, zero passate) e si
#  IGNORA. La tabella legge SOLO la gamba intera; la lettura per REGIME si fa
#  A MANO dal per-trade CSV. NOTA: il file prova NON dichiara @FINOA -> la
#  fine la fissa il driver (-Fino, default 2024.01.01) e la DICHIARA; se il
#  file un domani aggiunge @FINOA, il gate lo confronta.
#
#  ------------------------------------------------------------------
#  NIENTE ABLAZIONE A STELLA QUI: e' un diagnostico si'/no, UNA cella +
#  gemello. L'unico asse spazzolato e' InpMagic (i due magic di controllo):
#  due passate identiche al centesimo = igiene del banco. Config FISSA:
#  ottimizzare uno short su dati orso = curve fitting (CLAUDE.md, Regola della
#  seconda caccia). La griglia viene DOPO, e solo se il diagnostico e' verde
#  nell'orso.
#
#  LA RIGA CHE SI INCOLLA sta in righe\RIGA_SHORTGATE_DA_MANDARE.md
# =====================================================================
[CmdletBinding()]
param(
  # -Pin NON ha default: un default silenzioso ("lavoro") farebbe girare la
  #  punta del branch spacciandola per un commit congelato.
  [string]$Pin           = "",
  [switch]$SoloControllo,          # giro a vuoto: NON apre MT5
  [switch]$Rifai,                  # rifa' anche il CSV gia' presente
  [string]$Simbolo       = "NASUSD_EXT",
  [string]$Periodo       = "M15",
  [string]$DaQuando      = "2020.01.01",
  [string]$Fino          = "2024.01.01",
  [int]$Deposito         = 100000
)
$ErrorActionPreference = "Stop"
[Threading.Thread]::CurrentThread.CurrentCulture   = [Globalization.CultureInfo]::InvariantCulture
[Threading.Thread]::CurrentThread.CurrentUICulture = [Globalization.CultureInfo]::InvariantCulture
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$INV = [Globalization.CultureInfo]::InvariantCulture

$EA     = "ABTG_Nasdaq_Apertura_US"
$Avvio  = Get-Date
$Stamp  = $Avvio.ToString("yyyyMMdd_HHmm", $INV)
$Dsk    = Join-Path $env:USERPROFILE "Desktop"
$Work   = Join-Path $env:USERPROFILE "abtg_shortgate"
$Prove  = Join-Path $Work "prove"
$RawPin = "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$Pin"

# --- TUTTO CIO' CHE LA RACCOLTA USA NASCE QUI, PRIMA DEL try. In PowerShell
#     una `function` e' un'ISTRUZIONE, non una dichiarazione: se il flusso non
#     ci passa sopra il nome non esiste, e la raccolta esploderebbe proprio
#     nella corsa fermata da un gate, cioe' l'unica in cui il referto serve.
$Problemi = New-Object System.Collections.ArrayList
$Rilievi  = New-Object System.Collections.ArrayList
$Fatale   = ""
$Include  = "NON INSTALLATO"
$Terminale = "n/d"
$Compilato = "NON TENTATA"
$RiskEA    = "n/d"
$Simbolo_ok = "NON VERIFICATO"
$Modo     = "CORSA"
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
  $t = ("" + $s).Replace([string][char]160,"").Replace(" ","").Trim()
  if($t -eq ""){ return $null }
  if([double]::TryParse($t,[Globalization.NumberStyles]::Float,$INV,[ref]$v)){ return $v }
  return $null
}

# --- LA CONVENZIONE DI SENTINELLA (vale per TUTTE le colonne). Un numero non
#     misurato non deve MAI uscire come numero plausibile: esce "n/d", non
#     "0.000" (che si legge "ha perso tutto").
function FmtN($v){ if($null -eq $v){ return "n/d" }; if([int]$v -lt 0){ return "n/d" }; return ([int]$v).ToString($INV) }
function Fmt2($v){ if($null -eq $v){ return "n/d" }; if([double]$v -lt 0){ return "n/d" }; return ([double]$v).ToString("0.00",$INV) }
function FmtE($v){ if($null -eq $v){ return "n/d" }; if([double]$v -le -999998.0){ return "n/d" }; return ([double]$v).ToString("+0;-0;0",$INV) }
function FmtPg($v){ if($null -eq $v){ return "n/d" }; if([double]$v -ge 99.0){ return "n/d" }; return ([double]$v).ToString("0.00",$INV) }

# --- IL PARSER DEL CSV DI OTTIMIZZAZIONE. Le colonne si cercano PER NOME, mai
#     per posizione. L'intestazione di ABTG_Nasdaq_Apertura_US (OnTesterDeinit):
#       Pass,Profit,Expected Payoff,Profit Factor,Recovery Factor,Sharpe Ratio,
#       Equity DD %,Trades,Peggior Giornata %,Perdite Consecutive Max,
#       Serie Perdente Peggiore
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

# --- I GEMELLI: le due righe (i due magic di controllo) devono essere
#     IDENTICHE AL CENTESIMO. E' l'igiene minima: se il banco non e'
#     deterministico il numero non si legge. E' il motivo per cui l'unico
#     asse spazzolato e' InpMagic.
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
#  LA CELLA UNICA. F1..F5 = i valori che il gate PRETENDE nel file prova
#  (direzione costitutiva + gate di regime): se un domani il file venisse
#  scambiato o corrotto, il gate lo prende PRIMA di aprire MT5.
# =====================================================================
$CELLA = [pscustomobject]@{
  Id="shortgate"; Prova="SHORTGATE_NAS_BREAKDOWN.txt";
  Desc="breakdown short GATED da EMA 50x200 H4 (drive-down following, SOLO short)";
  M1=767120; M2=767121;
  Esito="NON ESEGUITA"; Gemelli="NON MISURATO";
  N=-1; Pf=-1.0; Dd=-1.0; Prof=-999999.0; Pg=99.9 }

# --- I MAGIC VIETATI: i blocchi vivi / round recenti gia' occupati, piu' una
#     lista larga di sicurezza. Il blocco 767120/767121 di questo round e'
#     VERGINE (cercato in tutto il repo il 2026-08-30: solo il file prova). Il
#     gate M1/M2 fissa gia' i valori esatti; questa lista e' la seconda rete.
#     Aggiunti i magic FASE2 (7672xx, ora occupati) rispetto alla lista base.
$MagicVietati = @(773500,
                  767200,767201,767210,767211,767220,767221,767230,767231,
                  767700,767701,767710,767711,767740,767741,
                  767800,767801,
                  760101,760201,760202,760301,760401,760402,760411,760511,760531,760532,760611,
                  761301,761321,761322,761323,761332,761501,761531,
                  762162,762163,762231,762232,762233,762234,762235,762341,762342,762343,762344,762345,762346,762361,762362,762363,762421,762422,762423,
                  763400,763401,763410,763411,763420,763421,763430,763431,
                  765000,765010,765020,765213,
                  766000)

try{
  Titolo "SCREENING SHORT ORSO -- breakdown short GATED (ABTG_Nasdaq_Apertura_US) -- modo $Modo"

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

  Dico ("pin ......... " + $Pin)
  Dico ("cella ....... 1 (shortgate, + gemello) -- diagnostico si'/no, NIENTE ablazione a stella")
  Dico ("simbolo ..... " + $Simbolo + " " + $Periodo + " (feed _EXT a ora NY: apertura cash 09:30, NON 14:30 server)")
  Dico ("finestra .... " + $DaQuando + " -> " + $Fino + " (UNA SOLA TRANCHE, FrazioneIS=1.0: la gamba OOS del driver generico e' degenere e si ignora)")
  Dico ("banco ....... MODELLO 1 (OHLC) -- SCREENING nell'ORSO, non un verdetto. Deposito " + $Deposito)

  # -------------------------------------------------------------------
  #  1. SCARICO AL PIN
  # -------------------------------------------------------------------
  Titolo "1. SCARICO AL PIN"
  New-Item -ItemType Directory -Force -Path $Work,$Prove | Out-Null

  $drv = Join-Path $Work "walkforward_generico.ps1"
  Scarica ($RawPin + "/backtest_pipeline/walkforward_generico.ps1") $drv
  # il driver generico pinna il branch da cui riscarica il .mq5: senza questo,
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
    if($val -match '\|\|Y\s*$'){ $nY++; $nomeY = $nome }
  }
  if($nY -ne 1){ throw ($CELLA.Prova + ": deve avere ESATTAMENTE un asse con flag Y, trovati " + $nY + ".") }
  if($nomeY -ne "InpMagic"){ throw ($CELLA.Prova + ": l'unico asse Y deve essere InpMagic (config FISSA, diagnostico), invece e' " + $nomeY + ".") }

  # GATE GEOMETRIA: simbolo, periodo, inizio finestra
  if($h["@SIMBOLO"]  -ne $Simbolo){  throw ($CELLA.Prova + ": @SIMBOLO e' " + $h["@SIMBOLO"] + ", atteso " + $Simbolo) }
  if($h["@PERIODO"]  -ne $Periodo){  throw ($CELLA.Prova + ": @PERIODO e' " + $h["@PERIODO"] + ", atteso " + $Periodo) }
  if($h["@DAQUANDO"] -ne $DaQuando){ throw ($CELLA.Prova + ": @DAQUANDO e' " + $h["@DAQUANDO"] + ", atteso " + $DaQuando) }
  # @FINOA: il file prova NON lo dichiara (la fine la fissa il driver). Se un
  # domani lo aggiunge, DEVE combaciare con -Fino; se manca, e' un rilievo.
  if($h.ContainsKey("@FINOA")){
    if($h["@FINOA"] -ne $Fino){ throw ($CELLA.Prova + ": @FINOA e' " + $h["@FINOA"] + ", atteso " + $Fino) }
  } else {
    [void]$Rilievi.Add("il file prova non dichiara @FINOA: la fine finestra la fissa il driver (-Fino " + $Fino + "). Dichiarato, non inventato.")
  }

  # GATE DEL FUSO INVERTITO (critico, opposto alla regola di casa NASUSD): su
  # NASUSD_EXT il fuso e' NY cash 9:30 (canarino DST verde), NON 14:30 server.
  # Il 14 vale SOLO per la cella tick della cassaforte BCM. Qui si PRETENDE
  # 9/30 e si RIFIUTA 14.
  $ssh = ($h["InpSessionHour"] -split '\|\|')[0]
  $ssm = ($h["InpSessionMin"]  -split '\|\|')[0]
  if($ssh -eq "14"){ throw ($CELLA.Prova + ": InpSessionHour=14 e' l'ORA SERVER BCM. Su NASUSD_EXT il fuso e' NY cash 9:30 (misurato, canarino DST verde), non 14:30 server: qui va 9. Il 14 vale SOLO per la cella tick della cassaforte.") }
  if($ssh -ne "9"){  throw ($CELLA.Prova + ": InpSessionHour deve essere 9 (apertura cash NY sul feed _EXT), trovato '" + $ssh + "'.") }
  if($ssm -ne "30"){ throw ($CELLA.Prova + ": InpSessionMin deve essere 30 (apertura 09:30 NY), trovato '" + $ssm + "'.") }

  # GATE DELLA DIREZIONE COSTITUTIVA: BREAKOUT (drive-down following), SOLO
  # short. Il RETEST (InpEntryMode=2) e' il meccanismo bocciato da R115: qui e'
  # VIETATO. Il breakout e' l'ipotesi (drive-down, payoff ~6:1 in anatomia).
  $vEntry = ($h["InpEntryMode"] -split '\|\|')[0]
  $vLong  = ($h["InpAllowLong"]  -split '\|\|')[0]
  $vShort = ($h["InpAllowShort"] -split '\|\|')[0]
  if($vEntry -eq "2"){ throw ($CELLA.Prova + ": InpEntryMode=2 (RETEST) VIETATO: e' il meccanismo bocciato da R115 (NAS 0.517). L'ipotesi e' il BREAKDOWN (InpEntryMode=0, drive-down following).") }
  if($vEntry -ne "0"){ throw ($CELLA.Prova + ": InpEntryMode deve essere 0 (BREAKOUT=drive-down following), trovato '" + $vEntry + "'.") }
  if($vLong -ne "false"){  throw ($CELLA.Prova + ": InpAllowLong deve essere false (SOLO SHORT), trovato '" + $vLong + "'.") }
  if($vShort -ne "true"){ throw ($CELLA.Prova + ": InpAllowShort deve essere true (SOLO SHORT), trovato '" + $vShort + "'.") }

  # GATE DEL REGIME (il gate E' il motore): EMA 50x200 su H4 ribassista.
  $vEma  = ($h["InpUseEmaFilter"] -split '\|\|')[0]
  $vFast = ($h["InpEmaFast"]      -split '\|\|')[0]
  $vSlow = ($h["InpEmaSlow"]      -split '\|\|')[0]
  $vFtf  = ($h["InpFilterTF"]     -split '\|\|')[0]
  if($vEma -ne "true"){  throw ($CELLA.Prova + ": InpUseEmaFilter deve essere true (il gate di regime E' il motore, dossier par.1), trovato '" + $vEma + "'.") }
  if($vFast -ne "50"){   throw ($CELLA.Prova + ": InpEmaFast deve essere 50 (gate regime, cross 50x200), trovato '" + $vFast + "'.") }
  if($vSlow -ne "200"){  throw ($CELLA.Prova + ": InpEmaSlow deve essere 200 (gate regime, cross 50x200), trovato '" + $vSlow + "'.") }
  if($vFtf -ne "16388"){ throw ($CELLA.Prova + ": InpFilterTF deve essere 16388 (H4: il gate di regime e' su H4), trovato '" + $vFtf + "'.") }

  # GATE PAVIMENTO SL (R109): mai 0, il pavimento si APPLICA non salta. NOTA:
  # in questo file InpSkipIfTight e' 'false' (booleano), non '0'.
  $mfloor = ($h["InpMinStopPts"]  -split '\|\|')[0]
  $mskip  = ($h["InpSkipIfTight"] -split '\|\|')[0]
  if($mfloor -eq "0"){ throw ($CELLA.Prova + ": InpMinStopPts=0 VIETATO (R109): il pavimento SL e' 500 (5 punti indice), mai 0.") }
  if($mfloor -ne "500"){ throw ($CELLA.Prova + ": InpMinStopPts deve essere 500 (R109, 5 punti indice), trovato '" + $mfloor + "'.") }
  if($mskip -ne "false"){ throw ($CELLA.Prova + ": InpSkipIfTight deve essere false (il pavimento si APPLICA, non fa saltare il trade), trovato '" + $mskip + "'.") }

  # GATE DEL RISCHIO: 0.65% (conservativo, come dossier). Lo leggo e lo dichiaro.
  $vRisk = ($h["InpRiskPercent"] -split '\|\|')[0]
  if($vRisk -ne "0.65"){ throw ($CELLA.Prova + ": InpRiskPercent deve essere 0.65 (conservativo, dossier), trovato '" + $vRisk + "'.") }
  $RiskEA = $vRisk

  # GATE DEI MAGIC: vergini, mai uno vietato, e i due gemelli esatti.
  $mg = $h["InpMagic"] -split '\|\|'
  $magicVisti = @{}
  foreach($v in @($mg[1],$mg[3])){
    $n = [int]$v
    if($MagicVietati -contains $n){ throw ($CELLA.Prova + ": magic " + $n + " e' VIETATO (sorgente, sedia viva o round recente).") }
    if($magicVisti.ContainsKey($n)){ throw ("magic " + $n + " ripetuto nei due gemelli: un solo magic per gemello.") }
    $magicVisti[$n] = 1
  }
  if([int]$mg[1] -ne $CELLA.M1 -or [int]$mg[3] -ne $CELLA.M2){
    throw ($CELLA.Prova + ": i magic gemelli sono " + $mg[1] + "/" + $mg[3] + ", la cella li vuole " + $CELLA.M1 + "/" + $CELLA.M2)
  }
  Dico "geometria, FUSO NY (9/30), direzione costitutiva (BREAKOUT 0, solo short), gate regime (EMA 50x200 H4), pavimento SL (R109), rischio 0.65 e magic vergini: TUTTI PASSATI" "Green"

  # -------------------------------------------------------------------
  #  3. IL TERMINALE, IL SIMBOLO CUSTOM, L'INCLUDE E LA COMPILAZIONE
  # -------------------------------------------------------------------
  Titolo "3. TERMINALE, SIMBOLO CUSTOM, INCLUDE, COMPILAZIONE"
  # IL SELETTORE E' LO STESSO, RIGA PER RIGA, DI walkforward_generico.ps1: su
  # una macchina con due istanze i due script devono scegliere LO STESSO
  # terminale, altrimenti include installato in uno e compilazione fatta
  # nell'altro sarebbe un guasto muto. Si toccano insieme.
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

  # IL SIMBOLO E' CUSTOM (storico ESTERNO): il tester accetta
  # Symbol=NASUSD_EXT solo se le barre sono state importate. Si CONTROLLA prima
  # (bases\Custom\history\NASUSD_EXT) e se manca ci si ferma con l'errore
  # ONESTO (come R113): NON lo si costruisce qui.
  $cartellaSimbolo = Join-Path $dataFolder ("bases\Custom\history\" + $Simbolo)
  if(-not (Test-Path -LiteralPath $cartellaSimbolo)){
    throw ($Simbolo + " non trovato: e' storico ESTERNO e va importato con la Riga dello storico (importa_storico_esterno.ps1, referto STORICO_INDICI) PRIMA di girare. Cercato in: " + $cartellaSimbolo)
  }
  $pesoSimbolo = ((Get-ChildItem -LiteralPath $cartellaSimbolo -Recurse -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum).Sum) / 1MB
  $Simbolo_ok = "TROVATO (" + $pesoSimbolo.ToString("0.0",$INV) + " MB in bases\Custom\history)"
  Dico ("simbolo custom: " + $Simbolo + " " + $Simbolo_ok + ". ATTENZIONE: le barre non bastano da sole -- se il tester dicesse 'symbol not exist' la REGISTRAZIONE del simbolo e' persa: si riapre MT5 una volta a mano o si rifa' l'import.") "Green"

  # LA COPIA DELL'INCLUDE SI VERIFICA SUL CONTENUTO, NON SUL NOME: se in
  # Include esistesse una CARTELLA con quel nome, Copy-Item ci metterebbe il
  # file DENTRO e Test-Path direbbe verde lo stesso.
  $incDir = Join-Path $dataFolder "MQL5\Include"
  New-Item -ItemType Directory -Force -Path $incDir | Out-Null
  $lenInc = (Get-Item -LiteralPath $incSrc).Length
  Copy-Item $incSrc -Destination $incDir -Force
  $vInc = Get-Item -LiteralPath (Join-Path $incDir "ABTG_PausaGuardian.mqh") -ErrorAction Stop
  if($vInc.PSIsContainer -or $vInc.Length -ne $lenInc){ throw "include copiato ma NON verificato (lunghezza diversa)." }
  $Include = "INSTALLATO e VERIFICATO in " + $incDir
  Dico $Include "Green"

  # LA COMPILAZIONE. QUESTO EA E' GIA' COMPILATO E VIVO IN FORWARD: la
  # compilazione qui e' attesa RIUSCIRE, e serve solo a garantire un .ex5 al
  # pin (il forward gira su un'altra copia, questa corsa NON lo tocca). L'.ex5
  # si CANCELLA prima: senza, un binario vecchio farebbe passare per riuscita
  # una compilazione fallita.
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
  #  4. LA CORSA -- una tranche sola (FrazioneIS 1.0), MODELLO 1 (OHLC)
  # -------------------------------------------------------------------
  Titolo "4. LA CORSA"
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
            "-Modello","1",
            "-Deposito",("" + $Deposito))
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
    # UNA SOLA TRANCHE: si legge la gamba "IS" del driver generico (con
    # FrazioneIS=1.0 e' la FINESTRA INTERA 2020-2024). Il Modello 1 mette
    # "_ohlc" nel nome. La gamba "OOS" e' degenere e NON si legge.
    $csvWin = Join-Path $Risultati ($EA + "_" + $Simbolo + "_IS_ohlc_" + $CELLA.Id + ".csv")
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
#  Regola di casa: i risultati finiscono sul Desktop e in uno zip.
# =====================================================================
Titolo "RACCOLTA"
$Cart = Join-Path $Dsk ("SHORTGATE_" + $Modo + "_" + $Stamp)
New-Item -ItemType Directory -Force -Path $Cart | Out-Null

$RefTxt = New-Object System.Collections.ArrayList
[void]$RefTxt.Add("=====================================================================")
[void]$RefTxt.Add(" SCREENING SHORT ORSO -- breakdown short GATED (ABTG_Nasdaq_Apertura_US) su " + $Simbolo + " " + $Periodo)
[void]$RefTxt.Add("=====================================================================")
[void]$RefTxt.Add("modo: " + $Modo + "   <- CONTROLLO = giro a vuoto, NON e' il risultato")
[void]$RefTxt.Add("data: " + $Avvio.ToString("yyyy-MM-dd HH:mm:ss",$INV))
[void]$RefTxt.Add("pin:  " + $Pin)
[void]$RefTxt.Add("finestra: " + $DaQuando + " -> " + $Fino + "  (UNA SOLA TRANCHE, FrazioneIS=1.0)")
[void]$RefTxt.Add("sessione: 09:30 NY cash (feed _EXT a ora di New York, misurato). FUSO INVERTITO:")
[void]$RefTxt.Add("          qui NON vale IT-1=server; il 14:30 server e' la cella tick BCM.")
[void]$RefTxt.Add("direzione: BREAKDOWN short (InpEntryMode=0, drive-down following), SOLO short.")
[void]$RefTxt.Add("gate regime: EMA 50x200 su H4 ribassista (il gate E' il motore, dossier par.1).")
[void]$RefTxt.Add("banco: MODELLO 1 (OHLC su barre M1 HistData) -- SCREENING nell'ORSO, non un verdetto.")
[void]$RefTxt.Add("       Deposito " + $Deposito + ", rischio " + $RiskEA + "% (InpRiskPercent pinnato nel file prova).")
[void]$RefTxt.Add("terminale: " + $Terminale)
[void]$RefTxt.Add("simbolo custom: " + $Simbolo_ok)
[void]$RefTxt.Add("include: " + $Include)
[void]$RefTxt.Add("compilazione: " + $Compilato)
[void]$RefTxt.Add("")
[void]$RefTxt.Add("QUESTO E' UNO SCREENING DIAGNOSTICO (si'/no). NON PROMUOVE NIENTE.")
[void]$RefTxt.Add("Il TETTO OHLC INGANNA: qui si legge la FORMA dell'edge (verde/rosso,")
[void]$RefTxt.Add("ordini di grandezza), MAI i numeri fini. E il VERDETTO A TICK NELL'ORSO")
[void]$RefTxt.Add("E' IMPOSSIBILE: i tick BCM sugli indici partono dal 26/09/2024, non")
[void]$RefTxt.Add("raggiungono NESSUN orso. Il cancello ZERO qualita'-feed indici e'")
[void]$RefTxt.Add("ancora CHIUSO: questo screening OHLC su EXT va letto con quella riserva.")
[void]$RefTxt.Add("")
[void]$RefTxt.Add("LA DOMANDA (dossier): il breakdown short GATED da H4 ribassista ha un")
[void]$RefTxt.Add("edge nelle finestre ORSO (crollo 2020-02/04 e orso 2022) che i 21 mesi")
[void]$RefTxt.Add("solo-toro di BCM nascondono per costruzione? Se e' un drag come")
[void]$RefTxt.Add("R98/R115 -> lo short in apertura indici e' chiuso ONESTAMENTE, orso")
[void]$RefTxt.Add("incluso. Se ha edge SOLO nell'orso -> vale un round vero.")
[void]$RefTxt.Add("")
[void]$RefTxt.Add("CRITERI DI LETTURA CONGELATI (dossier par.5):")
[void]$RefTxt.Add("  - La LETTURA si SEGMENTA per REGIME. Il numero che conta e' il")
[void]$RefTxt.Add("    comportamento nei DUE sotto-periodi ORSO, NON il totale (che per")
[void]$RefTxt.Add("    meta' e' toro e DILUISCE). Nel toro 2021 ci si aspetta FLAT.")
[void]$RefTxt.Add("  - PROMOSSO solo se nelle finestre orso l'aspettativa/trade e' positiva")
[void]$RefTxt.Add("    (al netto spread >=1.5 punti indice, R55) E il DD orso non peggiora")
[void]$RefTxt.Add("    il rischio della flotta. Deve battere i caduti (R98/R115, R108/R109).")
[void]$RefTxt.Add("  - RISCHIO MAI SOSPESO (regola B): DD e peggior giornata SEMPRE, a")
[void]$RefTxt.Add("    qualunque n. CAMPIONE: >=150 trade per il MERITO; sotto, sospeso.")
[void]$RefTxt.Add("")
[void]$RefTxt.Add("--- LA TABELLA (finestra intera 2020-2024, una tranche) ---")
[void]$RefTxt.Add("cella        n      PF      DD%   Profit   PeggGio%  gemelli")
$riga = ("{0,-11} {1,5} {2,7} {3,8} {4,8} {5,9}  {6}" -f `
         $CELLA.Id, (FmtN $CELLA.N), (Fmt2 $CELLA.Pf), (Fmt2 $CELLA.Dd),
         (FmtE $CELLA.Prof), (FmtPg $CELLA.Pg), $CELLA.Gemelli)
[void]$RefTxt.Add($riga)
[void]$RefTxt.Add("            esito: " + $CELLA.Esito + "  |  " + $CELLA.Desc)
[void]$RefTxt.Add("")
[void]$RefTxt.Add("--- COME SI LEGGE, e sono avvertenze, non note ---")
[void]$RefTxt.Add("1. OHLC INGANNA. Un breakdown su barra OHLC entra a prezzi che a tick")
[void]$RefTxt.Add("   sarebbero diversi (slippage, ordine dei tick dentro la barra). I")
[void]$RefTxt.Add("   numeri fini NON si leggono: si legge la FORMA (l'edge esiste")
[void]$RefTxt.Add("   nell'orso? di che ordine di grandezza? il gate tiene FLAT nel toro?).")
[void]$RefTxt.Add("2. LA LETTURA PER REGIME batte il totale. Il totale 2020-2024 mescola")
[void]$RefTxt.Add("   crollo 2020, toro 2021, orso 2022, ripartenza 2023: una media che")
[void]$RefTxt.Add("   non descrive nessun mercato. Si segmenta A MANO dal per-trade CSV,")
[void]$RefTxt.Add("   in Common\Files:")
[void]$RefTxt.Add("     abtg_trades_" + $EA + "_" + $Simbolo + "_<magic>.csv")
[void]$RefTxt.Add("   colonne close_time (per l'anno/regime) e net_profit (l'esito). Si")
[void]$RefTxt.Add("   somma net_profit per finestra di regime e si guarda l'aspettativa/")
[void]$RefTxt.Add("   trade E il DD di ciascun regime. IL NUMERO CHE CONTA E' L'ORSO.")
[void]$RefTxt.Add("3. IL GATE E' IL MOTORE. Se nel toro 2021 la cella e' quasi-flat (pochi")
[void]$RefTxt.Add("   trade, poco P&L) e' il comportamento VOLUTO: il gate H4 non arma lo")
[void]$RefTxt.Add("   short quando il regime e' rialzista. Non e' un difetto, e' la tesi.")
[void]$RefTxt.Add("4. IL VERDETTO A TICK NELL'ORSO NON ESISTE e non arrivera' da qui: i")
[void]$RefTxt.Add("   tick BCM sugli indici non raggiungono l'orso. Se lo screening e'")
[void]$RefTxt.Add("   verde nell'orso, il passo dopo e' i DATI (sonda BCM / Dukascopy), non")
[void]$RefTxt.Add("   una promozione.")
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
[void]$RefTxt.Add('COME SI RIPRENDE: si riparte dalla pagina righe/RIGA_SHORTGATE_DA_MANDARE.md,')
[void]$RefTxt.Add('NON da questa riga: $p e $pin nascono dentro il blocco e non sopravvivono.')

$refPath = Join-Path $Cart "REFERTO_SHORTGATE.txt"
Set-Content -LiteralPath $refPath -Value ($RefTxt -join "`r`n") -Encoding ASCII
Write-Host ($RefTxt -join "`r`n")

# --- gli artefatti: solo cio' che ha girato, copiato PER NOME.
foreach($f in @("COMPILAZIONE_FALLITA.log")){
  $src = Join-Path $Work $f
  if(Test-Path -LiteralPath $src){ Copy-Item $src -Destination $Cart -Force }
}
$srcProva = Join-Path $Prove $CELLA.Prova
if(Test-Path -LiteralPath $srcProva){ Copy-Item $srcProva -Destination $Cart -Force }
$fCsv = Join-Path $Work ("risultati_prove\" + $EA + "\" + $EA + "_" + $Simbolo + "_IS_ohlc_" + $CELLA.Id + ".csv")
if(Test-Path -LiteralPath $fCsv){ Copy-Item $fCsv -Destination $Cart -Force }

$zip = $Cart + ".zip"
Remove-Item -LiteralPath $zip -Force -ErrorAction SilentlyContinue
Compress-Archive -Path (Join-Path $Cart "*") -DestinationPath $zip -Force
Write-Host ""
Write-Host ("CARTELLA: " + $Cart) -ForegroundColor Green
Write-Host ("ZIP DA MANDARE: " + $zip) -ForegroundColor Green
Write-Host "FILE ATTESI NELLO ZIP: REFERTO_SHORTGATE.txt + il file prova + il CSV della finestra intera" -ForegroundColor Gray

if($Fatale -ne ""){ Write-Host "ESITO: FERMATO" -ForegroundColor Red; exit 1 }
if($Problemi.Count -gt 0){ Write-Host "ESITO: COMPLETATO CON PROBLEMI" -ForegroundColor Yellow; exit 1 }
Write-Host ("ESITO: " + $Modo + " COMPLETATO") -ForegroundColor Green
exit 0
