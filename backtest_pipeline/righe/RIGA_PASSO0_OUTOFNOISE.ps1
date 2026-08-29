# =====================================================================
#  MARCATORE_RIGA_PASSO0_OUTOFNOISE_v1
#  RIGA_PASSO0_OUTOFNOISE.ps1  --  PASSO 0 DEL MOTORE OUT OF THE NOISE
#  ABTG_OutOfNoise  su  NASUSD  M15, TICK REALI, tre celle:
#     00_nudo   long + short insieme   magic 767700/767701
#     01_long   solo long              magic 767710/767711
#     02_short  solo short             magic 767740/767741
# ---------------------------------------------------------------------
#  QUESTO NON E' UN ROUND E NON DA' NESSUN VERDETTO.
#  E' il PASSO 0 del candidato P3 "Out of the Noise Intraday con VWAP"
#  (porting del Pine di Yuri Lopukhov, MIT, TradingView gJeM3LZ5), scheda
#  in caccia_strategie\CACCIA_M5M15_INDICI_2026-08-25.md. Stessa macchina
#  dei PASSO 0 gemelli FVGRET e VWAPREV: e' un CONTA-OPERAZIONI, misura
#  QUANTE operazioni produce il cono di rumore orario e il COSTO (cancello
#  S0). Il PF che esce dal CSV si LEGGE ma NON si giudica: non ci sono
#  criteri firmati, non c'e' ablazione, e tre celle non sono un round.
#
#  L'IPOTESI, i tre esiti A/B/C e il cancello S0 stanno scritti in testa
#  a prove\ABTG_OutOfNoise.txt e NON si riscrivono qui: un criterio
#  ricopiato in tre posti e' un criterio che prima o poi diverge.
#
#  ------------------------------------------------------------------
#  PERCHE' ESISTE QUESTO FILE invece di tre righe di
#  walkforward_generico.ps1 incollate a mano. Quattro motivi MISURATI:
#
#   1. L'INCLUDE. ABTG_OutOfNoise.mq5 fa
#        #include <ABTG_PausaGuardian.mqh>
#      e walkforward_generico.ps1 NON lo installa (verificato: nel driver
#      generico la stringa 'PausaGuardian' non compare). Se quel file non
#      e' gia' in MQL5\Include la compilazione fallisce, e il driver
#      generico muore con "compilazione fallita" senza dire perche'.
#      Qui l'include si scarica al pin e si copia PRIMA di compilare.
#
#   2. IL GATE DEL FUSO. NASUSD apre 15:30 IT = 14:30 SERVER. Il DEFAULT
#      del sorgente e' il DAX (08:00-16:30): il driver generico blinda
#      tutto al default, quindi senza le righe di sessione l'EA girerebbe
#      NASUSD con gli orari del DAX. Qui si CONTROLLA che i file prova
#      portino la sessione in ORA SERVER (14/30/21/0) e si RIFIUTA un
#      file con InpSessionStartHour=15 (ora italiana). Il driver generico
#      non sa niente di questo.
#
#   3. I GATE SUI FILE PROVA. Il driver generico controlla il formato,
#      non il PERIMETRO: non sa che le tre celle devono differire di due
#      righe sole, non sa quali magic sono vietati, e non sa che
#      @PERIODO deve essere M15. Qui si controllano prima di aprire MT5.
#
#   4. LA RACCOLTA. Regola di casa (CLAUDE.md, regola delle righe di
#      lancio, punto 2): a fine test i risultati finiscono in una
#      cartella sul Desktop e in uno zip pronto da mandare. Sempre,
#      anche quando la corsa si ferma a meta'.
#  ------------------------------------------------------------------
#
#  QUELLO CHE NON FA, dichiarato:
#   - NON GIUDICA e non promuove niente. Conta le operazioni e mette il
#     numero accanto alla soglia dei 150 dell'Emendamento regola A.
#   - NON tocca nessuna sedia viva. I sei magic sono VERGINI (blocco
#     7677xx, cercati uno per uno in tutto il repo il 2026-08-29: zero
#     occorrenze). Il magic del SORGENTE (773500) e' VIETATO qui dentro.
#   - NON scarica storico e non svuota bases\<server>\ticks. I tick di
#     NASUSD dal 2024.09.26 sono agli atti.
#   - non scrive una riga di MQL5.
#
#  IL CANCELLO S0 (il COSTO): su NASUSD la conversione E' AGLI ATTI --
#  1 punto indice = 100 punti MT5 (R97), gia' il default
#  InpMT5PerPuntoIndice=100. L'export per-trade scrive take_idx_pts GIA'
#  in punti indice: la mediana si legge diretta, senza conversione a
#  mano. E' la differenza col DAX, dove il rapporto NON era agli atti.
#
#  RISCHIO DICHIARATO: l'EA non e' MAI STATO COMPILATO da nessuno. Se
#  MetaEditor si lamenta, il risultato del PASSO 0 e' quello, e va
#  riportato cosi' com'e'.
#
#  QUANTO CI METTE [STIMA, non una previsione]: 6 passate a tick reali
#  (3 celle x 2 finestre) x 2 gemelle = 12 passate su 21 mesi di M15.
#  Stima 10-30 minuti piu' la compilazione.
#
#  LA RIGA CHE SI INCOLLA sta in righe\RIGA_PASSO0_OUTOFNOISE_DA_MANDARE.md
# =====================================================================
[CmdletBinding()]
param(
  # -Pin NON ha default: un default silenzioso ("lavoro") farebbe girare
  #  la punta del branch spacciandola per un commit congelato.
  [string]$Pin           = "",
  [switch]$SoloControllo,          # giro a vuoto: NON apre MT5
  [switch]$Rifai,                  # rifa' anche i CSV gia' presenti
  [string]$SoloCella     = "",     # "00_nudo" | "01_long" | "02_short"
  [string]$Simbolo       = "NASUSD",
  [string]$Periodo       = "M15",
  [string]$DaQuando      = "2024.09.26",
  [string]$Fino          = "2026.06.30",
  [int]$Deposito         = 100000
)
$ErrorActionPreference = "Stop"
[Threading.Thread]::CurrentThread.CurrentCulture   = [Globalization.CultureInfo]::InvariantCulture
[Threading.Thread]::CurrentThread.CurrentUICulture = [Globalization.CultureInfo]::InvariantCulture
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$INV = [Globalization.CultureInfo]::InvariantCulture

$EA     = "ABTG_OutOfNoise"
$Avvio  = Get-Date
$Stamp  = $Avvio.ToString("yyyyMMdd_HHmm", $INV)
$Dsk    = Join-Path $env:USERPROFILE "Desktop"
$Work   = Join-Path $env:USERPROFILE "abtg_passo0_noise"
$Prove  = Join-Path $Work "prove"
$RawPin = "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$Pin"

# --- TUTTO CIO' CHE LA RACCOLTA USA NASCE QUI, PRIMA DEL try.
#     In PowerShell una `function` non e' dichiarativa, e' un'ISTRUZIONE:
#     se il flusso non ci passa sopra il nome non esiste, e la raccolta
#     esploderebbe proprio nella corsa fermata da un gate, cioe' l'unica
#     in cui il referto serve davvero.
$Problemi = New-Object System.Collections.ArrayList
$Rilievi  = New-Object System.Collections.ArrayList
$Fatale   = ""
$Include  = "NON INSTALLATO"
$Terminale = "n/d"
$Compilato = "NON TENTATA"
$RiskEA    = "n/d"
$Autotest  = @()
# NOTA: le celle stanno in $CELLE (piu' avanti), popolata PRIMA del try.
# Qui non si dichiara nessun "$Celle": in PowerShell sarebbe LA STESSA
# variabile (case-insensitive).
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

# --- LA CONVENZIONE DI SENTINELLA, e vale per TUTTE le colonne.
#     Un numero non misurato non deve MAI uscire come numero plausibile:
#     esce "n/d", non "0.000" (che si legge "ha perso tutto").
function FmtN($v){ if($null -eq $v){ return "n/d" }; if([int]$v -lt 0){ return "n/d" }; return ([int]$v).ToString($INV) }
function Fmt2($v){ if($null -eq $v){ return "n/d" }; if([double]$v -lt 0){ return "n/d" }; return ([double]$v).ToString("0.00",$INV) }
function FmtE($v){ if($null -eq $v){ return "n/d" }; if([double]$v -le -999998.0){ return "n/d" }; return ([double]$v).ToString("+0;-0;0",$INV) }
function FmtPg($v){ if($null -eq $v){ return "n/d" }; if([double]$v -ge 99.0){ return "n/d" }; return ([double]$v).ToString("0.00",$INV) }

# --- IL PARSER DEL CSV DI OTTIMIZZAZIONE.
#     Le colonne si cercano PER NOME, mai per posizione. Se non le
#     riconosce torna $null E DICE quali intestazioni ha visto, invece di
#     indovinare. L'intestazione di ABTG_OutOfNoise (OnTesterDeinit,
#     'double stats[13]') e' a QUATTORDICI colonne e CONTIENE
#     'Peggior Giornata %'.
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

# --- I GEMELLI: le due righe devono essere IDENTICHE AL CENTESIMO.
#     E' l'unico controllo d'igiene di questo PASSO 0, ed e' il motivo
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
#  LE TRE CELLE. 'Diff' = gli input che DEVONO differire dal 00_nudo, e
#  NESSUN ALTRO. 'Val' dice quanto devono VALERE i due lati in quel file:
#  se due file fossero SCAMBIATI il diff resterebbe verde e questo no.
# =====================================================================
function C([string]$id,[string]$file,[string]$desc,[int]$m1,[int]$m2,
          [string]$vLong,[string]$vShort,$diff){
  return [pscustomobject]@{
    Id=$id; Prova=$file; Desc=$desc; M1=$m1; M2=$m2;
    VLong=$vLong; VShort=$vShort; Diff=@($diff);
    Esito="NON ESEGUITA"; Gemelli="NON MISURATO";
    NIS=-1; NOOS=-1; PfIS=-1.0; PfOOS=-1.0; DdIS=-1.0; DdOOS=-1.0;
    ProfIS=-999999.0; ProfOOS=-999999.0; PgOOS=99.9 }
}
$CELLE = @()
$CELLE += (C "00_nudo"  "ABTG_OutOfNoise.txt"           "IL MOTORE NUDO, due lati insieme -- porta i gemelli" 767700 767701 "1" "1" @())
$CELLE += (C "01_long"  "PASSO0_OUTOFNOISE_01_long.txt" "SOLO LONG -- la frequenza del lato long"             767710 767711 "1" "0" @("InpAllowShort"))
$CELLE += (C "02_short" "PASSO0_OUTOFNOISE_02_short.txt" "SOLO SHORT -- la frequenza del lato short"           767740 767741 "0" "1" @("InpAllowLong"))

# --- I MAGIC VIETATI: il magic del SORGENTE dell'EA (773500) e i magic
#     vivi/round dei blocchi vicini. Un'identita' non in campo resta
#     comunque occupata. Il gate M1/M2 fissa gia' i sei valori esatti;
#     questa lista e' la seconda rete.
$MagicVietati = @(773500,
                  767800, 767801,
                  760101,760201,760202,760301,760401,760402,760411,760511,760531,760532,760611,
                  761301,761321,761322,761323,761332,761501,761531,
                  762162,762163,762231,762232,762233,762234,762235,762341,762342,762343,762344,762345,762346,762361,762362,762363,762421,762422,762423,
                  763400,763401,763410,763411,763420,763421,763430,763431,
                  765000,765010,765020,765213,
                  766000)

$Ordinati = @($CELLE)
if($SoloCella -ne ""){
  $Ordinati = @($CELLE | Where-Object { $_.Id -eq $SoloCella })
}

try{
  Titolo "PASSO 0 -- OUT OF THE NOISE (ABTG_OutOfNoise) -- modo $Modo"

  # -------------------------------------------------------------------
  #  0. LE GUARDIE, PRIMA DI TOCCARE QUALUNQUE COSA
  # -------------------------------------------------------------------
  if($Pin -eq ""){ throw "-Pin obbligatorio: senza, girerebbe la punta del branch spacciandola per un commit congelato." }
  if($Pin -notmatch '^[0-9a-f]{40}$'){ throw ("-Pin deve essere un commit di 40 caratteri esadecimali, ricevuto: " + $Pin) }
  if(Get-Process terminal64,metaeditor64 -ErrorAction SilentlyContinue){
    throw "MT5 O METAEDITOR APERTO: col terminale aperto il tester non gira (zero CSV), con MetaEditor aperto la compilazione torna subito senza compilare."
  }
  if($SoloCella -ne "" -and @($Ordinati).Count -eq 0){
    throw ("-SoloCella '" + $SoloCella + "' non esiste. Validi: 00_nudo, 01_long, 02_short.")
  }
  if($Periodo -ne "M15"){
    [void]$Rilievi.Add("PERIODO diverso da M15 (" + $Periodo + "): i file prova dichiarano @PERIODO M15 e il gate lo confronta.")
  }

  Dico ("pin ......... " + $Pin)
  Dico ("celle ....... " + @($Ordinati).Count + " su 3")
  Dico ("simbolo ..... " + $Simbolo + " " + $Periodo + " (NASUSD apre 14:30 SERVER = 15:30 IT)")
  Dico ("finestra .... " + $DaQuando + " -> " + $Fino + " (split 40/60 del driver generico)")
  Dico ("banco ....... Modello 4 (TICK REALI), deposito " + $Deposito)

  # -------------------------------------------------------------------
  #  1. SCARICO AL PIN
  # -------------------------------------------------------------------
  Titolo "1. SCARICO AL PIN"
  New-Item -ItemType Directory -Force -Path $Work,$Prove | Out-Null

  $drv = Join-Path $Work "walkforward_generico.ps1"
  Scarica ($RawPin + "/backtest_pipeline/walkforward_generico.ps1") $drv
  # il driver generico pinna il branch da cui riscarica il .mq5: senza
  # questo, il pin varrebbe per il driver e NON per l'EA misurato.
  $t = Get-Content -LiteralPath $drv -Raw
  if($t -notmatch '\$EABranch\s*=\s*"lavoro"'){ throw "walkforward_generico.ps1 non ha la riga \$EABranch attesa: non lo posso pinnare." }
  $t = $t -replace '\$EABranch\s*=\s*"lavoro"', ('$EABranch="' + $Pin + '"')
  Set-Content -LiteralPath $drv -Value $t -Encoding ASCII
  Dico "driver generico scaricato e PINNATO (riscarica l'EA al pin, non dalla punta del branch)" "Green"

  foreach($c in $Ordinati){
    Scarica ($RawPin + "/backtest_pipeline/prove/" + $c.Prova) (Join-Path $Prove $c.Prova)
  }
  # il 00_nudo serve SEMPRE: e' il termine di paragone del gate della
  # stella, anche quando gira una cella sola.
  $fNudo = Join-Path $Prove "ABTG_OutOfNoise.txt"
  if(-not (Test-Path -LiteralPath $fNudo)){
    Scarica ($RawPin + "/backtest_pipeline/prove/ABTG_OutOfNoise.txt") $fNudo
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
      if($val -match '\|\|Y\s*$'){ $nY++; $nomeY = $nome }
    }
    if($nY -ne 1){ throw ($f.Name + ": deve avere ESATTAMENTE un asse con flag Y, trovati " + $nY + ".") }
    if($nomeY -ne "InpMagic"){ throw ($f.Name + ": l'unico asse Y deve essere InpMagic, invece e' " + $nomeY + ".") }
    $mappe[$f.Name] = $h
  }

  $hNudo = $mappe["ABTG_OutOfNoise.txt"]
  if($null -eq $hNudo){ throw "manca la mappa del 00_nudo: senza, il gate della stella non e' eseguibile." }

  foreach($c in $Ordinati){
    $h = $mappe[$c.Prova]
    if($null -eq $h){ throw ("mappa mancante per " + $c.Prova) }

    # GATE GEOMETRIA: simbolo, periodo, storico
    if($h["@SIMBOLO"]  -ne $Simbolo){  throw ($c.Prova + ": @SIMBOLO e' " + $h["@SIMBOLO"] + ", atteso " + $Simbolo) }
    if($h["@PERIODO"]  -ne $Periodo){  throw ($c.Prova + ": @PERIODO e' " + $h["@PERIODO"] + ", atteso " + $Periodo) }
    if($h["@DAQUANDO"] -ne $DaQuando){ throw ($c.Prova + ": @DAQUANDO e' " + $h["@DAQUANDO"] + ", atteso " + $DaQuando) }

    # GATE DEI VALORI: quanto valgono i due lati IN QUESTO FILE.
    # Prende il caso che il diff non puo' vedere: due file SCAMBIATI.
    $vl = ($h["InpAllowLong"]  -split '\|\|')[0]
    $vs = ($h["InpAllowShort"] -split '\|\|')[0]
    if($vl -ne $c.VLong){  throw ($c.Prova + ": InpAllowLong vale "  + $vl + ", la cella " + $c.Id + " lo vuole " + $c.VLong) }
    if($vs -ne $c.VShort){ throw ($c.Prova + ": InpAllowShort vale " + $vs + ", la cella " + $c.Id + " lo vuole " + $c.VShort) }

    # GATE DEL FUSO / BASELINE (regola fissa di casa, difetto pagato):
    # NASUSD apre 14:30 SERVER = 15:30 IT. La sessione dell'EA va in ORA
    # SERVER: 14/30 - 21/0. Il default del sorgente e' il DAX, quindi
    # queste righe DEVONO esserci nel file prova, altrimenti l'EA
    # girerebbe NASUSD con gli orari del DAX. E si RIFIUTA l'ora italiana.
    $ssh = ($h["InpSessionStartHour"] -split '\|\|')[0]
    $ssm = ($h["InpSessionStartMin"]  -split '\|\|')[0]
    $seh = ($h["InpSessionEndHour"]   -split '\|\|')[0]
    $sem = ($h["InpSessionEndMin"]    -split '\|\|')[0]
    if($ssh -eq "15"){ throw ($c.Prova + ": InpSessionStartHour=15 e' l'ORA ITALIANA. NASUSD apre 15:30 IT = 14:30 SERVER: in ORA SERVER va 14, non 15.") }
    if($ssh -ne "14"){ throw ($c.Prova + ": InpSessionStartHour deve essere 14 (ORA SERVER, apertura NASUSD 14:30 server = 15:30 IT), trovato '" + $ssh + "'.") }
    if($ssm -ne "30"){ throw ($c.Prova + ": InpSessionStartMin deve essere 30 (apertura 14:30 server), trovato '" + $ssm + "'.") }
    if($seh -ne "21"){ throw ($c.Prova + ": InpSessionEndHour deve essere 21 (flat di fine seduta, ORA SERVER), trovato '" + $seh + "'.") }
    if($sem -ne "0"){  throw ($c.Prova + ": InpSessionEndMin deve essere 0 (flat 21:00 server), trovato '" + $sem + "'.") }

    # GATE BASELINE S0: la conversione punti indice e' load-bearing per
    # il cancello S0. Su NASUSD e' 100 (R97, agli atti).
    $conv = ($h["InpMT5PerPuntoIndice"] -split '\|\|')[0]
    if($conv -ne "100"){ throw ($c.Prova + ": InpMT5PerPuntoIndice deve essere 100 (NASUSD, R97): e' load-bearing per il cancello S0, trovato '" + $conv + "'.") }

    # GATE DELLA STELLA: contro il 00_nudo cambia SOLO cio' che e'
    # dichiarato in Diff, piu' InpMagic. Confronto PER NOME, mai per
    # posizione: un file con una riga in piu' sfaserebbe tutto il resto.
    $ammessi = @("InpMagic") + @($c.Diff)
    foreach($k in @($h.Keys)){
      if($k -match '^@'){ continue }
      if($ammessi -contains $k){ continue }
      if($hNudo[$k] -ne $h[$k]){ throw ($c.Prova + ": '" + $k + "' differisce dal 00_nudo e NON e' un delta dichiarato.") }
    }
    foreach($k in @($c.Diff)){
      if($hNudo[$k] -eq $h[$k]){ throw ($c.Prova + ": '" + $k + "' DOVEVA differire dal 00_nudo e non differisce.") }
    }

    # GATE DEI MAGIC: vergini, unici, mai uno vietato.
    $mg = $h["InpMagic"] -split '\|\|'
    foreach($v in @($mg[1],$mg[3])){
      $n = [int]$v
      if($MagicVietati -contains $n){ throw ($c.Prova + ": magic " + $n + " e' VIETATO (sorgente, sedia viva o round recente).") }
      if($magicVisti.ContainsKey($n)){ throw ("magic " + $n + " usato in due celle: " + $magicVisti[$n] + " e " + $c.Prova) }
      $magicVisti[$n] = $c.Prova
    }
    if([int]$mg[1] -ne $c.M1 -or [int]$mg[3] -ne $c.M2){
      throw ($c.Prova + ": i magic gemelli sono " + $mg[1] + "/" + $mg[3] + ", la cella " + $c.Id + " li vuole " + $c.M1 + "/" + $c.M2)
    }
  }
  Dico "geometria, valori dei lati, FUSO (ora server), baseline S0, stella e magic: TUTTI PASSATI" "Green"

  # -------------------------------------------------------------------
  #  3. L'INCLUDE E LA COMPILAZIONE -- i due pezzi che il driver
  #     generico non fa (l'include) o fa troppo tardi (la compilazione).
  # -------------------------------------------------------------------
  Titolo "3. INSTALLO L'INCLUDE E COMPILO"
  # IL SELETTORE E' LO STESSO, RIGA PER RIGA, DI walkforward_generico.ps1.
  # Su una macchina con DUE istanze (la -V3 del 100k) i due script
  # devono scegliere LO STESSO terminale: include installato in uno,
  # compilazione fatta nell'altro sarebbe un guasto muto. Se il selettore
  # del driver generico cambia, cambia anche questo: si toccano insieme.
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

  # LA COPIA SI VERIFICA SUL CONTENUTO, NON SUL NOME: se in Include
  # esistesse una CARTELLA con quel nome, Copy-Item ci metterebbe il file
  # DENTRO e Test-Path direbbe verde lo stesso.
  $incDir = Join-Path $dataFolder "MQL5\Include"
  New-Item -ItemType Directory -Force -Path $incDir | Out-Null
  $lenInc = (Get-Item -LiteralPath $incSrc).Length
  Copy-Item $incSrc -Destination $incDir -Force
  $vInc = Get-Item -LiteralPath (Join-Path $incDir "ABTG_PausaGuardian.mqh") -ErrorAction Stop
  if($vInc.PSIsContainer -or $vInc.Length -ne $lenInc){ throw "include copiato ma NON verificato (lunghezza diversa)." }
  $Include = "INSTALLATO e VERIFICATO in " + $incDir
  Dico $Include "Green"

  # --- LA COMPILAZIONE, IN ENTRAMBI I RAMI (controllo E corsa vera).
  #     QUESTO EA NON E' MAI STATO COMPILATO DA NESSUNO: un giro di
  #     controllo che non compila non controlla la cosa PIU' PROBABILE che
  #     vada storta, e l'errore uscirebbe dentro il driver generico, che
  #     muore con "compilazione fallita" senza dire perche'.
  #     L'.ex5 si CANCELLA prima: senza, un binario vecchio farebbe
  #     passare per riuscita una compilazione fallita.
  $mq5 = Join-Path $Work ($EA + ".mq5")
  Scarica ($RawPin + "/mql5/Experts/" + $EA + ".mq5") $mq5
  $mRisk = [regex]::Match((Get-Content -LiteralPath $mq5 -Raw), 'input\s+double\s+InpRiskPercent\s*=\s*([0-9.]+)')
  if($mRisk.Success){ $RiskEA = $mRisk.Groups[1].Value }
  Dico ("rischio ..... " + $RiskEA + "% (default di InpRiskPercent letto NEL .mq5 al pin: i file prova NON lo pinnano)")
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
    throw ("COMPILAZIONE FALLITA: " + $EA + " non era MAI stato compilato da nessuno. Gli errori sono qui sopra e in COMPILAZIONE_FALLITA.log dentro lo zip.")
  }
  $Compilato = "OK (" + [int]((Get-Item -LiteralPath $ex5).Length/1024) + " KB, " + (Get-Item -LiteralPath $ex5).LastWriteTime.ToString("HH:mm:ss",$INV) + ")"
  Dico ("compilato " + $EA + ": " + $Compilato) "Green"

  # -------------------------------------------------------------------
  #  4. LE CORSE
  # -------------------------------------------------------------------
  Titolo "4. LE CORSE"
  $Risultati = Join-Path $Work ("risultati_prove\" + $EA)
  foreach($c in $Ordinati){
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
              "-Modello","4",
              "-Deposito",("" + $Deposito))
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

    $csvIS  = Join-Path $Risultati ($EA + "_" + $Simbolo + "_IS_"  + $c.Id + ".csv")
    $csvOOS = Join-Path $Risultati ($EA + "_" + $Simbolo + "_OOS_" + $c.Id + ".csv")
    $rIS  = LeggiOpt $csvIS
    $rOOS = LeggiOpt $csvOOS
    if($null -eq $rIS -or $null -eq $rOOS){
      $c.Esito = "CSV NON LEGGIBILE"
      [void]$Problemi.Add("cella " + $c.Id + ": CSV mancante o intestazioni non riconosciute. Viste: " + ($script:CsvIntestazioni -join " | "))
      continue
    }
    $c.Gemelli = Gemelli $rOOS
    $c.NIS   = $rIS[0].N;   $c.NOOS   = $rOOS[0].N
    $c.PfIS  = $rIS[0].Pf;  $c.PfOOS  = $rOOS[0].Pf
    $c.DdIS  = $rIS[0].Dd;  $c.DdOOS  = $rOOS[0].Dd
    $c.ProfIS= $rIS[0].Profit; $c.ProfOOS = $rOOS[0].Profit
    if($null -ne $rOOS[0].Pg){ $c.PgOOS = $rOOS[0].Pg }
    $c.Esito = "MISURATA"
    if($c.Gemelli -ne "IDENTICI"){
      [void]$Problemi.Add("cella " + $c.Id + ": gemelli " + $c.Gemelli + " -- il banco non e' deterministico, il numero non si legge.")
    }
  }

  # --- L'AUTOTEST DEL NUCLEO (nove blocchi, v1.01) scrive solo su Print/Log:
  #     in ottimizzazione nessuno la legge, il percorso dei log cambia
  #     fra le build MT5 -- e' un raccoglitore BEST-EFFORT, MAI un gate.
  if(-not $SoloControllo){
    $radici = @((Join-Path $dataFolder "Tester"), (Join-Path $env:APPDATA "MetaQuotes\Tester"))
    $righeAT = @()
    foreach($rr in $radici){
      if(-not (Test-Path -LiteralPath $rr)){ continue }
      $logs = @(Get-ChildItem -LiteralPath $rr -Recurse -Filter *.log -ErrorAction SilentlyContinue | Where-Object { $_.LastWriteTime -ge $Avvio })
      foreach($lg in $logs){
        $righeAT += @(Select-String -LiteralPath $lg.FullName -SimpleMatch -Pattern "[NOISE][AUTOTEST]" -ErrorAction SilentlyContinue | ForEach-Object { $_.Line })
      }
    }
    $Autotest = @($righeAT | ForEach-Object { ($_ -replace '^.*\[NOISE\]\[AUTOTEST\]','[AUTOTEST]').Trim() } | Select-Object -Unique)
    if($Autotest.Count -gt 0){
      Set-Content -LiteralPath (Join-Path $Work "AUTOTEST_NOISE.txt") -Value ($Autotest -join "`r`n") -Encoding ASCII
      Dico ("autotest del nucleo letto dai log degli agent: " + $Autotest.Count + " righe") "Green"
    }else{
      [void]$Rilievi.Add("AUTOTEST del nucleo NON LETTO: nessuna riga [NOISE][AUTOTEST] nei log degli agent (il percorso cambia fra le build). Il collaudo degli otto blocchi NON e' agli atti di questa corsa. Non e' un guasto della corsa.")
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
$Cart = Join-Path $Dsk ("PASSO0_OUTOFNOISE_" + $Modo + "_" + $Stamp)
New-Item -ItemType Directory -Force -Path $Cart | Out-Null

$RefTxt = New-Object System.Collections.ArrayList
[void]$RefTxt.Add("=====================================================================")
[void]$RefTxt.Add(" PASSO 0 -- OUT OF THE NOISE (ABTG_OutOfNoise) su " + $Simbolo + " " + $Periodo)
[void]$RefTxt.Add("=====================================================================")
[void]$RefTxt.Add("modo: " + $Modo + "   <- CONTROLLO = giro a vuoto, NON e' il risultato")
[void]$RefTxt.Add("data: " + $Avvio.ToString("yyyy-MM-dd HH:mm:ss",$INV))
[void]$RefTxt.Add("pin:  " + $Pin)
[void]$RefTxt.Add("finestra: " + $DaQuando + " -> " + $Fino + "  (split 40/60)")
[void]$RefTxt.Add("sessione: 14:30-21:00 SERVER (= 15:30-22:00 IT). Fuso: IT -1 = server.")
[void]$RefTxt.Add("banco: Modello 4 TICK REALI, deposito " + $Deposito + ", rischio " + $RiskEA + "% (default di InpRiskPercent letto nel .mq5 al pin -- i file prova NON lo pinnano)")
[void]$RefTxt.Add("terminale: " + $Terminale)
[void]$RefTxt.Add("include: " + $Include)
[void]$RefTxt.Add("compilazione: " + $Compilato)
[void]$RefTxt.Add("")
[void]$RefTxt.Add("--- AUTOTEST DEL NUCLEO (nove blocchi v1.01, letti dai log degli agent) ---")
if($Autotest.Count -gt 0){ foreach($a in $Autotest){ [void]$RefTxt.Add("  " + $a) } }
else { [void]$RefTxt.Add("  NON LETTO (vedi RILIEVI). Non e' un verdetto: e' un'assenza.") }
[void]$RefTxt.Add("")
[void]$RefTxt.Add("QUESTO NON E' UN ROUND E NON DA' NESSUN VERDETTO.")
[void]$RefTxt.Add("E' un CONTA-OPERAZIONI: misura la FREQUENZA del cono di rumore nudo.")
[void]$RefTxt.Add("Il PF qui sotto si LEGGE ma NON si giudica: non ci sono criteri")
[void]$RefTxt.Add("firmati, non c'e' ablazione, e tre celle non sono un round.")
[void]$RefTxt.Add("G5 non tocca il forward: e' una MISURA, non una promozione.")
[void]$RefTxt.Add("")
[void]$RefTxt.Add("LA DOMANDA DEL PASSO 0: quante operazioni per lato?")
[void]$RefTxt.Add("  A. n per lato >= 150  -> campione c'e', il round si puo' disegnare")
[void]$RefTxt.Add("  B. n per lato <  150  -> MERITO SOSPESO (valvola R59 / regola B),")
[void]$RefTxt.Add("                           il RISCHIO si giudica lo stesso")
[void]$RefTxt.Add("  C. n enorme           -> il cono e' troppo stretto: si muove")
[void]$RefTxt.Add("                           InpConeDays / la geometria, NON il rischio")
[void]$RefTxt.Add("")
[void]$RefTxt.Add("--- LA TABELLA ---")
[void]$RefTxt.Add("cella      n IS   n OOS   PF IS   PF OOS  DD OOS%  Prof OOS  PeggGio%  gemelli")
foreach($c in $CELLE){
  $riga = ("{0,-9} {1,6} {2,7} {3,7} {4,8} {5,8} {6,9} {7,9}  {8}" -f `
           $c.Id, (FmtN $c.NIS), (FmtN $c.NOOS), (Fmt2 $c.PfIS), (Fmt2 $c.PfOOS),
           (Fmt2 $c.DdOOS), (FmtE $c.ProfOOS), (FmtPg $c.PgOOS), $c.Gemelli)
  [void]$RefTxt.Add($riga)
  [void]$RefTxt.Add("           esito: " + $c.Esito + "  |  " + $c.Desc)
}
[void]$RefTxt.Add("")
[void]$RefTxt.Add("--- COME SI LEGGE, e sono tre avvertenze, non tre note ---")
[void]$RefTxt.Add("1. n(01_long) + n(02_short) NON FA n(00_nudo), e NON e' un guasto.")
[void]$RefTxt.Add("   L'EA tiene UNA posizione alla volta (CountPositions()>0 blocca")
[void]$RefTxt.Add("   l'ingresso, OnNewBar decide una cosa per barra). Con un lato spento")
[void]$RefTxt.Add("   lo slot resta libero: entrano segnali che nel 00_nudo erano stati")
[void]$RefTxt.Add("   buttati. E' un fatto del motore.")
[void]$RefTxt.Add("2. LA FINESTRA E' UN SOLO REGIME RIALZISTA (21 mesi di feed BCM sugli")
[void]$RefTxt.Add("   indici). Il lato SHORT parte svantaggiato PER REGIME, non per merito")
[void]$RefTxt.Add("   del motore. Un 'niente edge short' letto qui chiude la domanda per")
[void]$RefTxt.Add("   QUESTA EPOCA, non in assoluto.")
[void]$RefTxt.Add("3. IL CANCELLO S0 (il costo) NON E' IN QUESTA TABELLA. Si legge nella")
[void]$RefTxt.Add("   mediana del take LORDO in PUNTI INDICE, nell'export per-trade in")
[void]$RefTxt.Add("   Common\Files:")
[void]$RefTxt.Add("     abtg_trades_ABTG_OutOfNoise_" + $Simbolo + "_<magic>.csv")
[void]$RefTxt.Add("   colonna take_idx_pts (GIA' in punti indice: su NASUSD 1 pto indice")
[void]$RefTxt.Add("   = 100 punti MT5, R97, agli atti -- NESSUNA conversione a mano).")
[void]$RefTxt.Add("   Soglia S0: mediana >= ~3-4x lo spread tipico. Spread NASUSD 1-2")
[void]$RefTxt.Add("   punti indice [INCERTO, DICHIARATO NON MISURATO] -> ordine ~6 pti idx.")
[void]$RefTxt.Add("   Sotto soglia = il motore muore di costo come R98.")
[void]$RefTxt.Add("   ATTENZIONE: quel file porta il MAGIC nel nome, non la finestra: la")
[void]$RefTxt.Add("   gamba OOS SOVRASCRIVE la gamba IS dello stesso magic. Quello che")
[void]$RefTxt.Add("   resta a disco e' l'ULTIMA finestra girata.")
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
[void]$RefTxt.Add('COME SI RIPRENDE: si riparte dalla pagina righe/RIGA_PASSO0_OUTOFNOISE_DA_MANDARE.md,')
[void]$RefTxt.Add('NON da questa riga: $p e $pin nascono dentro il blocco e non sopravvivono.')

$refPath = Join-Path $Cart "REFERTO_PASSO0_OUTOFNOISE.txt"
Set-Content -LiteralPath $refPath -Value ($RefTxt -join "`r`n") -Encoding ASCII
Write-Host ($RefTxt -join "`r`n")

# --- gli artefatti: solo cio' che ha girato, copiato PER NOME.
foreach($f in @("AUTOTEST_NOISE.txt","COMPILAZIONE_FALLITA.log")){
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
Write-Host "FILE ATTESI NELLO ZIP: REFERTO_PASSO0_OUTOFNOISE.txt + i file prova girati + i CSV IS/OOS" -ForegroundColor Gray

if($Fatale -ne ""){ Write-Host "ESITO: FERMATO" -ForegroundColor Red; exit 1 }
if($Problemi.Count -gt 0){ Write-Host "ESITO: COMPLETATO CON PROBLEMI" -ForegroundColor Yellow; exit 1 }
Write-Host ("ESITO: " + $Modo + " COMPLETATO") -ForegroundColor Green
exit 0
