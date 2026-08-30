# =====================================================================
#  MARCATORE_RIGA_INVES_DRIVE_v1
#  RIGA_INVES_DRIVE.ps1  --  INVERSIONE DA ESAURIMENTO: ablazione a stella
#  del filtro d'inversione a un livello (fade selettivo da esaurimento).
#  ABTG_InvEsaurimento  su  NASUSD_EXT  M15, OHLC (Modello 1), 3 celle:
#     00_baseline  inversione nuda al livello (E1 off, E3 off)  magic 769000/769001
#     01_E1        E1 esaurimento >= 1.0x ADR14 (SOLO)          magic 769010/769011
#     02_E3        E3 perdita di spinta 2-3 barre calanti (SOLO) magic 769020/769021
# ---------------------------------------------------------------------
#  QUESTO E' UNO SCREENING. NON PROMUOVE NIENTE E NON DA' UN VERDETTO.
#  Contratto firmato:
#    backtest_pipeline\risultati_archivio\
#      STUDIO_INVERSIONE_ESAURIMENTO_CRITERI_BOZZA.md  ("FIRMO", 30/08/2026).
#
#  LA DOMANDA (contratto sez.1): esiste una condizione di ESAURIMENTO
#  ESTREMO -- misurabile al momento, senza guardare avanti -- che rende
#  l'inversione a un livello un MOTORE (aspettativa/trade positiva, DD
#  sotto il muro) e NON l'ennesimo fade morto? Il 00_baseline e' la MONETA
#  (inversione nuda al livello E2, che e' sempre attivo). La cella 01_E1 e'
#  la CHIAVE: accende E1 (il giorno ha gia' speso >= 1.0x l'ADR a 14
#  giorni). La cella 02_E3 accende E3 (2-3 barre a range strettamente
#  calante al livello). ABLAZIONE A STELLA: ogni cella muove UN SOLO
#  interruttore rispetto al baseline.
#
#  ------------------------------------------------------------------
#  >>> IL TETTO DEL BANCO, DICHIARATO E LOAD-BEARING (contratto sez.4):
#      questo gira a MODELLO 1 (OHLC su barre M1 HistData del feed _EXT),
#      NON a tick reali BCM. OHLC INGANNA: qui si legge la FORMA dell'edge
#      (verde/rosso, ordini di grandezza, coerenza fra le celle), MAI i
#      numeri fini. Il VERDETTO A TICK e' possibile SOLO sulla cassaforte
#      recente 2024.09.26 -> 2026 (BCM), che si apre UNA volta in
#      validazione, DOPO che l'ablazione ha scelto. NON si apre qui.
#      G5 non tocca il forward: e' una MISURA, non una promozione.
#
#  >>> IL FUSO E' INVERTITO RISPETTO AL SOLITO (critico). Su NASUSD_EXT
#      l'anatomia ha MISURATO (canarino DST verde) che le 09:30 del file
#      sono l'apertura cash tutto l'anno: il feed HistData e' a ora di
#      NEW YORK, NON a ora server BCM. Percio' qui il gate PRETENDE
#      InpSessionHour=9, InpSessionMin=30 e RIFIUTA 14. Il 14:30 SERVER
#      vale SOLO per la cella tick della cassaforte (NASUSD BCM), NON per
#      questo screening _EXT. E' l'OPPOSTO della regola di casa NASUSD,
#      ed e' giusto cosi' perche' il feed e' un altro.
#
#  >>> IL PAVIMENTO SL (R109): InpMinStopPts=500 (5 punti indice), MAI 0.
#      Un'inversione entra CONTRO una mossa forte: il "coltello che cade"
#      e' il pericolo n.1, e il pavimento SL e' load-bearing (contratto
#      sez.5, regola B). Il gate lo pretende e RIFIUTA 0.
#
#  >>> L'USCITA E' FISSA in tutte e 3 le celle (contratto sez.2): rientro
#      verso la VWAP di seduta (InpUseVwapTP=1, InpTP_R=1.5 di ripiego) e
#      NIENTE chiusura sul segnale opposto (InpCloseOnOpposite=0). Il gate
#      li pretende identici in ogni cella -- l'inversione punta al RIENTRO,
#      non a inseguire una coda di trend nuovo.
#
#  ------------------------------------------------------------------
#  PERCHE' ESISTE QUESTO FILE invece di tre righe di
#  walkforward_generico.ps1 incollate a mano. Gli stessi quattro motivi
#  MISURATI dei round gemelli (FASE2_DRIVE / OutOfNoise):
#
#   1. L'INCLUDE. ABTG_InvEsaurimento.mq5 fa
#        #include <ABTG_PausaGuardian.mqh>
#      e walkforward_generico.ps1 NON lo installa. Se quel file non e' gia'
#      in MQL5\Include la compilazione fallisce senza dire perche'. Qui
#      l'include si scarica al pin e si copia PRIMA di compilare.
#      (L'altro include, Trade\Trade.mqh, e' di serie: MetaEditor ce l'ha.)
#      NOTA: questo EA e' NUOVO, MAI compilato da nessuno. Il giro a vuoto
#      -SoloControllo lo compila: se fallisce, QUELLO e' il risultato del
#      PASSO (come per ABTG_OutOfNoise), e lo si legge nel referto.
#
#   2. IL GATE DEL FUSO INVERTITO. Il default del sorgente e' gia' NY 9/30;
#      qui si CONTROLLA che i file prova NON scivolino a 14 (ora server,
#      che su _EXT sarebbe l'ora sbagliata) e pretende 9/30.
#
#   3. I GATE SUI FILE PROVA. La stella (una feature sola per cella), il
#      pavimento SL, l'uscita fissa, i magic vergini, il periodo M15: si
#      controllano PRIMA di aprire MT5. Il driver generico non li conosce.
#
#   4. LA RACCOLTA (regola di casa CLAUDE.md, righe di lancio punto 2): a
#      fine test i risultati sul Desktop e in uno zip pronto da mandare.
#
#  ------------------------------------------------------------------
#  UNA SOLA TRANCHE, DICHIARATO: questa e' la finestra di screening
#  2017.01.01 -> 2020.07.01 (multi-regime: toro 2017, orso Q4-2018,
#  laterale 2019, crollo+V covid 2020). Il 2020 e' la PROVA DECISIVA:
#  crollo-giu e ripresa-V sono i due piu' grandi esaurimenti, uno per lato
#  -- se il motore non li prende, non e' lui. NON c'e' split IS/OOS interno:
#  l'OOS vero e' la cassaforte 2021-2026, che si apre DOPO. Il driver
#  generico pretende una FrazioneIS: qui gli si passa -FrazioneIS 1.0, cosi'
#  la sua gamba "IS" e' la FINESTRA INTERA e la gamba "OOS" e' un intervallo
#  degenere (0 giorni) che produce zero passate -- si IGNORA. La tabella
#  legge SOLO la gamba intera. La lettura per REGIME (2017 / Q4-2018 / 2019
#  / 2020) si fa A MANO dal per-trade CSV, esportato in Common\Files.
#
#  ------------------------------------------------------------------
#  CRITERI DI LETTURA CONGELATI (contratto sez.5):
#   - DECIDE l'ASPETTATIVA PER TRADE (non solo il PF), con coerenza fra i
#     sotto-periodi. RISCHIO MAI SOSPESO (regola B): DD e peggior giornata
#     contro il muro prop, SEMPRE, a qualunque n (inversione = coltello che
#     cade, la peggior giornata e' load-bearing).
#   - CAMPIONE: >=150 trade per giudicare il MERITO; sotto, merito sospeso.
#   - Il totale 2017-2020 DILUISCE: la lettura per REGIME batte il totale,
#     e il 2020 e' la prova decisiva.
#   - VINCE solo se una cella (E1 o E3) da aspettativa/trade positiva e
#     STABILE, con DD sotto il muro, E BATTE i fade caduti R108/R109/R95.
#     Un solo periodo o un solo simbolo = non dimostrato. E' una MISURA di
#     selezione su dati OHLC di un altro broker: la stella sceglie, il tick
#     della cassaforte giudica.
#
#  LA RIGA CHE SI INCOLLA sta in righe\RIGA_INVES_DRIVE_DA_MANDARE.md
# =====================================================================
[CmdletBinding()]
param(
  # -Pin NON ha default: un default silenzioso ("lavoro") farebbe girare
  #  la punta del branch spacciandola per un commit congelato.
  [string]$Pin           = "",
  [switch]$SoloControllo,          # giro a vuoto: NON apre MT5
  [switch]$Rifai,                  # rifa' anche i CSV gia' presenti
  [string]$SoloCella     = "",     # "00_baseline" | "01_E1" | "02_E3"
  [string]$Simbolo       = "NASUSD_EXT",
  [string]$Periodo       = "M15",
  [string]$DaQuando      = "2017.01.01",
  [string]$Fino          = "2020.07.01",
  [int]$Deposito         = 100000
)
$ErrorActionPreference = "Stop"
[Threading.Thread]::CurrentThread.CurrentCulture   = [Globalization.CultureInfo]::InvariantCulture
[Threading.Thread]::CurrentThread.CurrentUICulture = [Globalization.CultureInfo]::InvariantCulture
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$INV = [Globalization.CultureInfo]::InvariantCulture

$EA     = "ABTG_InvEsaurimento"
$Avvio  = Get-Date
$Stamp  = $Avvio.ToString("yyyyMMdd_HHmm", $INV)
$Dsk    = Join-Path $env:USERPROFILE "Desktop"
$Work   = Join-Path $env:USERPROFILE "abtg_inves_drive"
$Prove  = Join-Path $Work "prove"
$RawPin = "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$Pin"

# --- TUTTO CIO' CHE LA RACCOLTA USA NASCE QUI, PRIMA DEL try.
#     In PowerShell una `function` e' un'ISTRUZIONE, non una dichiarazione:
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
$Simbolo_ok = "NON VERIFICATO"
# NOTA: le celle stanno in $CELLE (piu' avanti), popolata PRIMA del try.
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

# --- LA CONVENZIONE DI SENTINELLA, e vale per TUTTE le colonne. Un numero
#     non misurato non deve MAI uscire come numero plausibile: esce "n/d",
#     non "0.000" (che si legge "ha perso tutto").
function FmtN($v){ if($null -eq $v){ return "n/d" }; if([int]$v -lt 0){ return "n/d" }; return ([int]$v).ToString($INV) }
function Fmt2($v){ if($null -eq $v){ return "n/d" }; if([double]$v -lt 0){ return "n/d" }; return ([double]$v).ToString("0.00",$INV) }
function FmtE($v){ if($null -eq $v){ return "n/d" }; if([double]$v -le -999998.0){ return "n/d" }; return ([double]$v).ToString("+0;-0;0",$INV) }
function FmtPg($v){ if($null -eq $v){ return "n/d" }; if([double]$v -ge 99.0){ return "n/d" }; return ([double]$v).ToString("0.00",$INV) }

# --- IL PARSER DEL CSV DI OTTIMIZZAZIONE. Le colonne si cercano PER NOME,
#     mai per posizione. L'intestazione di ABTG_InvEsaurimento
#     (OnTesterDeinit) e':
#       Pass,Profit,Expected Payoff,Profit Factor,Recovery Factor,
#       Sharpe Ratio,Equity DD %,Trades,Peggior Giornata %,
#       Perdite Consecutive Max,Serie Perdente Peggiore
#     Non c'e' colonna InpMagic (l'ottimizzazione su InpMagic non la scrive):
#     Magic resta vuoto, e va bene -- i gemelli si controllano su
#     profitto/PF/DD/n, non sul magic.
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
#  LE TRE CELLE. Ablazione A STELLA: 'Diff' = gli input che DEVONO
#  differire dal 00_baseline, e NESSUN ALTRO oltre InpMagic. E1exp/E3exp =
#  quanto DEVONO valere i due interruttori-feature in quel file: se due
#  file fossero SCAMBIATI il diff resterebbe verde e questo no.
#    E1 = InpUseE1 (baseline 0; 01_E1 = 1)
#    E3 = InpUseE3 (baseline 0; 02_E3 = 1)
#  Il baseline le ha ENTRAMBE spente; ogni altra cella ne accende UNA sola.
# =====================================================================
function C([string]$id,[string]$file,[string]$desc,[int]$m1,[int]$m2,
          [string]$e1,[string]$e3,$diff){
  return [pscustomobject]@{
    Id=$id; Prova=$file; Desc=$desc; M1=$m1; M2=$m2;
    E1exp=$e1; E3exp=$e3; Diff=@($diff);
    Esito="NON ESEGUITA"; Gemelli="NON MISURATO";
    N=-1; Pf=-1.0; Dd=-1.0; Prof=-999999.0; Pg=99.9 }
}
$CELLE = @()
$CELLE += (C "00_baseline" "INVES_NAS_00_baseline.txt" "L'INVERSIONE NUDA -- E1 ed E3 spenti, porta i gemelli"       769000 769001 "0" "0" @())
$CELLE += (C "01_E1"       "INVES_NAS_01_E1.txt"       "E1 esaurimento >= 1.0x ADR14 -- LA CHIAVE, unico interr."    769010 769011 "1" "0" @("InpUseE1"))
$CELLE += (C "02_E3"       "INVES_NAS_02_E3.txt"       "E3 perdita di spinta 2-3 barre calanti -- unico interr."     769020 769021 "0" "1" @("InpUseE3"))

# --- I MAGIC VIETATI: i blocchi vivi / round recenti gia' occupati, piu'
#     una lista larga di sicurezza. Il blocco 7690xx di questo round e'
#     VERGINE (cercato in tutto il repo il 2026-08-30: zero occorrenze; il
#     solo "769045" e' un valore di correlazione in un JSON). Il gate M1/M2
#     fissa gia' i valori esatti; questa lista e' la seconda rete. Vi sono
#     aggiunti (rispetto a FASE2): il blocco 7672xx (FASE2 ormai speso),
#     il blocco 7681xx e i blocchi 767xxx/766xxx gia' visti nel repo.
$MagicVietati = @(773500,
                  767200,767201,767210,767211,767220,767221,767230,767231,
                  767700,767701,767710,767711,767740,767741,
                  767800,767801,
                  768100,768101,768110,768111,
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
  Titolo "INVES DRIVE -- ablazione a stella (ABTG_InvEsaurimento) -- modo $Modo"

  # -------------------------------------------------------------------
  #  0. LE GUARDIE, PRIMA DI TOCCARE QUALUNQUE COSA
  # -------------------------------------------------------------------
  if($Pin -eq ""){ throw "-Pin obbligatorio: senza, girerebbe la punta del branch spacciandola per un commit congelato." }
  if($Pin -notmatch '^[0-9a-f]{40}$'){ throw ("-Pin deve essere un commit di 40 caratteri esadecimali, ricevuto: " + $Pin) }
  if(Get-Process terminal64,metaeditor64 -ErrorAction SilentlyContinue){
    throw "MT5 O METAEDITOR APERTO: col terminale aperto il tester non gira (zero CSV), con MetaEditor aperto la compilazione torna subito senza compilare."
  }
  if($SoloCella -ne "" -and @($Ordinati).Count -eq 0){
    throw ("-SoloCella '" + $SoloCella + "' non esiste. Validi: 00_baseline, 01_E1, 02_E3.")
  }
  if($Periodo -ne "M15"){
    [void]$Rilievi.Add("PERIODO diverso da M15 (" + $Periodo + "): i file prova dichiarano @PERIODO M15 e il gate lo confronta.")
  }

  Dico ("pin ......... " + $Pin)
  Dico ("celle ....... " + @($Ordinati).Count + " su 3")
  Dico ("simbolo ..... " + $Simbolo + " " + $Periodo + " (feed _EXT a ora NY: apertura cash 09:30, NON 14:30 server)")
  Dico ("finestra .... " + $DaQuando + " -> " + $Fino + " (UNA SOLA TRANCHE, FrazioneIS=1.0: la gamba OOS del driver generico e' degenere e si ignora)")
  Dico ("banco ....... MODELLO 1 (OHLC) -- SCREENING, non un verdetto. Deposito " + $Deposito)

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
  # il 00_baseline serve SEMPRE: e' il termine di paragone del gate della
  # stella, anche quando gira una cella sola.
  $fBase = Join-Path $Prove "INVES_NAS_00_baseline.txt"
  if(-not (Test-Path -LiteralPath $fBase)){
    Scarica ($RawPin + "/backtest_pipeline/prove/INVES_NAS_00_baseline.txt") $fBase
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

  $hBase = $mappe["INVES_NAS_00_baseline.txt"]
  if($null -eq $hBase){ throw "manca la mappa del 00_baseline: senza, il gate della stella non e' eseguibile." }

  foreach($c in $Ordinati){
    $h = $mappe[$c.Prova]
    if($null -eq $h){ throw ("mappa mancante per " + $c.Prova) }

    # GATE GEOMETRIA: simbolo, periodo, finestra
    if($h["@SIMBOLO"]  -ne $Simbolo){  throw ($c.Prova + ": @SIMBOLO e' " + $h["@SIMBOLO"] + ", atteso " + $Simbolo) }
    if($h["@PERIODO"]  -ne $Periodo){  throw ($c.Prova + ": @PERIODO e' " + $h["@PERIODO"] + ", atteso " + $Periodo) }
    if($h["@DAQUANDO"] -ne $DaQuando){ throw ($c.Prova + ": @DAQUANDO e' " + $h["@DAQUANDO"] + ", atteso " + $DaQuando) }
    if($h["@FINOA"]    -ne $Fino){     throw ($c.Prova + ": @FINOA e' " + $h["@FINOA"] + ", atteso " + $Fino) }

    # GATE DEL FUSO INVERTITO (critico, opposto alla regola di casa NASUSD):
    # su NASUSD_EXT il fuso e' NY cash 9:30, NON 14:30 server. Il 14 vale
    # SOLO per la cella tick della cassaforte BCM. Qui si PRETENDE 9/30 e
    # si RIFIUTA 14.
    $ssh = ($h["InpSessionHour"] -split '\|\|')[0]
    $ssm = ($h["InpSessionMin"]  -split '\|\|')[0]
    if($ssh -eq "14"){ throw ($c.Prova + ": InpSessionHour=14 e' l'ORA SERVER BCM. Su NASUSD_EXT il fuso e' NY cash 9:30, non 14:30 server: qui va 9. Il 14 vale SOLO per la cella tick della cassaforte.") }
    if($ssh -ne "9"){  throw ($c.Prova + ": InpSessionHour deve essere 9 (apertura cash NY sul feed _EXT, canarino DST verde), trovato '" + $ssh + "'.") }
    if($ssm -ne "30"){ throw ($c.Prova + ": InpSessionMin deve essere 30 (apertura 09:30 NY), trovato '" + $ssm + "'.") }

    # GATE PAVIMENTO SL (R109): mai 0. Inversione = coltello che cade, il
    # pavimento e' load-bearing (contratto sez.5, regola B).
    $mfloor = ($h["InpMinStopPts"]  -split '\|\|')[0]
    if($mfloor -eq "0"){ throw ($c.Prova + ": InpMinStopPts=0 VIETATO (R109): il pavimento SL e' 500 (5 punti indice), mai 0. L'inversione entra contro una mossa forte.") }
    if($mfloor -ne "500"){ throw ($c.Prova + ": InpMinStopPts deve essere 500 (R109, 5 punti indice), trovato '" + $mfloor + "'.") }

    # GATE USCITA FISSA (fisso in tutte e 3, contratto sez.2): rientro verso
    # la VWAP, TP_R di ripiego 1.5, niente chiusura sul segnale opposto.
    $uvwap = ($h["InpUseVwapTP"]       -split '\|\|')[0]
    $utpr  = ($h["InpTP_R"]            -split '\|\|')[0]
    $ucopp = ($h["InpCloseOnOpposite"] -split '\|\|')[0]
    if($uvwap -ne "1"){   throw ($c.Prova + ": InpUseVwapTP deve essere 1 (uscita = rientro verso VWAP, fissa in tutte le celle), trovato '" + $uvwap + "'.") }
    if($utpr  -ne "1.5"){ throw ($c.Prova + ": InpTP_R deve essere 1.5 (TP di ripiego, fisso), trovato '" + $utpr + "'.") }
    if($ucopp -ne "0"){   throw ($c.Prova + ": InpCloseOnOpposite deve essere 0 (non si chiude sul segnale opposto, fisso), trovato '" + $ucopp + "'.") }

    # GATE DEI VALORI FEATURE: quanto valgono i due interruttori E1/E3 IN
    # QUESTO FILE. Prende il caso che il diff non puo' vedere: file SCAMBIATI.
    $ve1 = ($h["InpUseE1"] -split '\|\|')[0]
    $ve3 = ($h["InpUseE3"] -split '\|\|')[0]
    if($ve1 -ne $c.E1exp){ throw ($c.Prova + ": InpUseE1 vale " + $ve1 + ", la cella " + $c.Id + " lo vuole " + $c.E1exp) }
    if($ve3 -ne $c.E3exp){ throw ($c.Prova + ": InpUseE3 vale " + $ve3 + ", la cella " + $c.Id + " lo vuole " + $c.E3exp) }

    # GATE "MAI DUE FEATURE INSIEME": E1 attivo = InpUseE1=1; E3 attivo =
    # InpUseE3=1. Al massimo UNO acceso; il baseline nessuno.
    $e1on = ($ve1 -eq "1")
    $e3on = ($ve3 -eq "1")
    $nOn = 0; if($e1on){ $nOn++ }; if($e3on){ $nOn++ }
    if($nOn -gt 1){ throw ($c.Prova + ": accende DUE feature insieme (E1=" + $ve1 + ", E3=" + $ve3 + "). L'ablazione a stella ne vuole UNA sola per cella.") }
    if($c.Id -eq "00_baseline" -and $nOn -ne 0){ throw ($c.Prova + ": il baseline deve avere ENTRAMBE le feature spente, invece E1=" + $ve1 + " E3=" + $ve3 + ".") }

    # GATE DELLA STELLA: contro il 00_baseline cambia SOLO cio' che e'
    # dichiarato in Diff, piu' InpMagic. Confronto PER NOME, mai per
    # posizione: un file con una riga in piu' sfaserebbe tutto il resto.
    $ammessi = @("InpMagic") + @($c.Diff)
    foreach($k in @($h.Keys)){
      if($k -match '^@'){ continue }
      if($ammessi -contains $k){ continue }
      if($hBase[$k] -ne $h[$k]){ throw ($c.Prova + ": '" + $k + "' differisce dal 00_baseline e NON e' un delta dichiarato.") }
    }
    foreach($k in @($c.Diff)){
      if($hBase[$k] -eq $h[$k]){ throw ($c.Prova + ": '" + $k + "' DOVEVA differire dal 00_baseline e non differisce.") }
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

    # il default di rischio: lo leggo dal baseline (i file lo pinnano a 0.65)
    if($c.Id -eq "00_baseline"){
      $RiskEA = ($h["InpRiskPercent"] -split '\|\|')[0]
    }
  }
  Dico "geometria, FUSO NY (9/30), pavimento SL (R109), uscita fissa, valori feature, stella (una feature sola) e magic: TUTTI PASSATI" "Green"

  # -------------------------------------------------------------------
  #  3. IL TERMINALE, IL SIMBOLO CUSTOM, L'INCLUDE E LA COMPILAZIONE
  # -------------------------------------------------------------------
  Titolo "3. TERMINALE, SIMBOLO CUSTOM, INCLUDE, COMPILAZIONE"
  # IL SELETTORE E' LO STESSO, RIGA PER RIGA, DI walkforward_generico.ps1:
  # su una macchina con due istanze i due script devono scegliere LO STESSO
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
  # Symbol=NASUSD_EXT solo se le barre sono state importate. Si CONTROLLA
  # prima (bases\Custom\history\NASUSD_EXT) e se manca ci si ferma con
  # l'errore ONESTO (come R113): NON lo si costruisce qui.
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

  # LA COMPILAZIONE, IN ENTRAMBI I RAMI. QUESTO EA E' NUOVO, MAI COMPILATO
  # DA NESSUNO: la compilazione qui e' IL PASSO -- se fallisce, quello e' il
  # risultato (come ABTG_OutOfNoise). L'.ex5 si CANCELLA prima: senza, un
  # binario vecchio farebbe passare per riuscita una compilazione fallita.
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
    throw ("COMPILAZIONE FALLITA: " + $EA + " non ha prodotto l'.ex5. E' un EA NUOVO: questo E' il risultato del passo. Gli errori sono qui sopra e in COMPILAZIONE_FALLITA.log dentro lo zip.")
  }
  $Compilato = "OK (" + [int]((Get-Item -LiteralPath $ex5).Length/1024) + " KB, " + (Get-Item -LiteralPath $ex5).LastWriteTime.ToString("HH:mm:ss",$INV) + ")"
  Dico ("compilato " + $EA + ": " + $Compilato) "Green"

  # -------------------------------------------------------------------
  #  4. LE CORSE -- una tranche sola (FrazioneIS 1.0), MODELLO 1 (OHLC)
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
              "-FrazioneIS","1.0",
              "-Modello","1",
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

    # UNA SOLA TRANCHE: si legge la gamba "IS" del driver generico (con
    # FrazioneIS=1.0 e' la FINESTRA INTERA 2017-2020). Il Modello 1 mette
    # "_ohlc" nel nome (il generico non fa mai sovrascrivere un tick con un
    # OHLC). La gamba "OOS" e' degenere e NON si legge.
    $csvWin = Join-Path $Risultati ($EA + "_" + $Simbolo + "_IS_ohlc_" + $c.Id + ".csv")
    $rWin = LeggiOpt $csvWin
    if($null -eq $rWin){
      $c.Esito = "CSV NON LEGGIBILE"
      [void]$Problemi.Add("cella " + $c.Id + ": CSV mancante o intestazioni non riconosciute. Viste: " + ($script:CsvIntestazioni -join " | "))
      continue
    }
    $c.Gemelli = Gemelli $rWin
    $c.N    = $rWin[0].N
    $c.Pf   = $rWin[0].Pf
    $c.Dd   = $rWin[0].Dd
    $c.Prof = $rWin[0].Profit
    if($null -ne $rWin[0].Pg){ $c.Pg = $rWin[0].Pg }
    $c.Esito = "MISURATA"
    if($c.Gemelli -ne "IDENTICI"){
      [void]$Problemi.Add("cella " + $c.Id + ": gemelli " + $c.Gemelli + " -- il banco non e' deterministico, il numero non si legge.")
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
$Cart = Join-Path $Dsk ("INVES_DRIVE_" + $Modo + "_" + $Stamp)
New-Item -ItemType Directory -Force -Path $Cart | Out-Null

$RefTxt = New-Object System.Collections.ArrayList
[void]$RefTxt.Add("=====================================================================")
[void]$RefTxt.Add(" INVES DRIVE -- ablazione a stella (ABTG_InvEsaurimento) su " + $Simbolo + " " + $Periodo)
[void]$RefTxt.Add("=====================================================================")
[void]$RefTxt.Add("modo: " + $Modo + "   <- CONTROLLO = giro a vuoto, NON e' il risultato")
[void]$RefTxt.Add("data: " + $Avvio.ToString("yyyy-MM-dd HH:mm:ss",$INV))
[void]$RefTxt.Add("pin:  " + $Pin)
[void]$RefTxt.Add("finestra: " + $DaQuando + " -> " + $Fino + "  (UNA SOLA TRANCHE, FrazioneIS=1.0)")
[void]$RefTxt.Add("sessione: 09:30 NY cash (feed _EXT a ora di New York). FUSO INVERTITO:")
[void]$RefTxt.Add("          qui NON vale IT-1=server; il 14:30 server e' la cella tick BCM.")
[void]$RefTxt.Add("banco: MODELLO 1 (OHLC su barre M1 HistData) -- SCREENING, non un verdetto.")
[void]$RefTxt.Add("       Deposito " + $Deposito + ", rischio " + $RiskEA + "% (InpRiskPercent pinnato nei file prova).")
[void]$RefTxt.Add("terminale: " + $Terminale)
[void]$RefTxt.Add("simbolo custom: " + $Simbolo_ok)
[void]$RefTxt.Add("include: " + $Include)
[void]$RefTxt.Add("compilazione: " + $Compilato + "   <- EA NUOVO: se FALLITA, quello e' il risultato del passo")
[void]$RefTxt.Add("")
[void]$RefTxt.Add("QUESTO E' UNO SCREENING. NON PROMUOVE NIENTE E NON DA' UN VERDETTO.")
[void]$RefTxt.Add("Il TETTO OHLC INGANNA: qui si legge la FORMA dell'edge (verde/rosso,")
[void]$RefTxt.Add("ordini di grandezza, coerenza fra le celle), MAI i numeri fini. Il")
[void]$RefTxt.Add("VERDETTO A TICK e' possibile SOLO sulla cassaforte 2024.09->2026 (BCM),")
[void]$RefTxt.Add("che si apre DOPO. G5 non tocca il forward: e' una MISURA, non una")
[void]$RefTxt.Add("promozione.")
[void]$RefTxt.Add("")
[void]$RefTxt.Add("LA DOMANDA (contratto sez.1): esiste una condizione di ESAURIMENTO")
[void]$RefTxt.Add("ESTREMO -- misurabile al momento -- che rende l'inversione a un livello")
[void]$RefTxt.Add("un MOTORE e NON l'ennesimo fade morto? Il baseline e' la moneta")
[void]$RefTxt.Add("(inversione nuda al livello E2); E1 (esaurimento >=1.0x ADR14, la")
[void]$RefTxt.Add("CHIAVE) e E3 (perdita di spinta) sono i due candidati, uno per cella.")
[void]$RefTxt.Add("")
[void]$RefTxt.Add("CRITERI DI LETTURA CONGELATI (contratto sez.5):")
[void]$RefTxt.Add("  - DECIDE l'ASPETTATIVA PER TRADE, non solo il PF, con coerenza fra i")
[void]$RefTxt.Add("    sotto-periodi. RISCHIO MAI SOSPESO (regola B): DD e peggior giornata")
[void]$RefTxt.Add("    contro il muro prop, SEMPRE, a qualunque n (coltello che cade).")
[void]$RefTxt.Add("  - CAMPIONE: >=150 trade per il MERITO; sotto, merito sospeso.")
[void]$RefTxt.Add("  - Il totale 2017-2020 DILUISCE: la lettura per REGIME batte il totale;")
[void]$RefTxt.Add("    il 2020 (crollo-giu + V) e' la PROVA DECISIVA.")
[void]$RefTxt.Add("  - VINCE solo se una cella da aspettativa/trade positiva e STABILE, con")
[void]$RefTxt.Add("    DD sotto il muro, E BATTE i fade caduti R108/R109/R95. Un solo")
[void]$RefTxt.Add("    periodo = non dimostrato.")
[void]$RefTxt.Add("")
[void]$RefTxt.Add("--- LA TABELLA (finestra intera 2017-2020, una tranche) ---")
[void]$RefTxt.Add("cella        n      PF      DD%   Profit   PeggGio%  gemelli")
foreach($c in $CELLE){
  $riga = ("{0,-11} {1,5} {2,7} {3,8} {4,8} {5,9}  {6}" -f `
           $c.Id, (FmtN $c.N), (Fmt2 $c.Pf), (Fmt2 $c.Dd),
           (FmtE $c.Prof), (FmtPg $c.Pg), $c.Gemelli)
  [void]$RefTxt.Add($riga)
  [void]$RefTxt.Add("            esito: " + $c.Esito + "  |  " + $c.Desc)
}
[void]$RefTxt.Add("")
[void]$RefTxt.Add("--- COME SI LEGGE, e sono avvertenze, non note ---")
[void]$RefTxt.Add("1. OHLC INGANNA. Un'inversione su barra OHLC entra a prezzi che a tick")
[void]$RefTxt.Add("   sarebbero diversi (slippage, ordine dei tick dentro la barra). I")
[void]$RefTxt.Add("   numeri fini NON si leggono: si legge la FORMA (una feature migliora")
[void]$RefTxt.Add("   la miscela? di quanto, in ordine di grandezza? e' coerente?).")
[void]$RefTxt.Add("2. LA LETTURA PER REGIME batte il totale. Il totale 2017-2020 mescola")
[void]$RefTxt.Add("   toro 2017, orso Q4-2018, laterale 2019 e crollo+V covid 2020: una")
[void]$RefTxt.Add("   media che non descrive nessun mercato. Si segmenta A MANO dal")
[void]$RefTxt.Add("   per-trade CSV, in Common\Files:")
[void]$RefTxt.Add("     abtg_trades_" + $EA + "_" + $Simbolo + "_<magic>.csv")
[void]$RefTxt.Add("   colonne close_time (per l'anno/regime) e net_profit (l'esito). Si")
[void]$RefTxt.Add("   somma net_profit per finestra di regime e si guarda l'aspettativa/")
[void]$RefTxt.Add("   trade E il DD di ciascun regime, feature per feature.")
[void]$RefTxt.Add("3. IL 2020 E' LA PROVA DECISIVA. E1 acceso (cella 01) DEVE prendere il")
[void]$RefTxt.Add("   crollo-giu e la ripresa-V: sono i due piu' grandi esaurimenti, uno")
[void]$RefTxt.Add("   per lato. Se il motore non li prende, non e' lui (contratto).")
[void]$RefTxt.Add("4. IL CANCELLO DEI FADE CADUTI. Se il baseline (E2 nudo) e' gia'")
[void]$RefTxt.Add("   identico ai fade morti R108/R109/R95, e' lo stesso motore: il salto,")
[void]$RefTxt.Add("   se c'e', deve arrivare da E1 nella cella 01. La cella 01 DEVE")
[void]$RefTxt.Add("   BATTERE quei fade, non solo il baseline.")
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
[void]$RefTxt.Add('COME SI RIPRENDE: si riparte dalla pagina righe/RIGA_INVES_DRIVE_DA_MANDARE.md,')
[void]$RefTxt.Add('NON da questa riga: $p e $pin nascono dentro il blocco e non sopravvivono.')

$refPath = Join-Path $Cart "REFERTO_INVES_DRIVE.txt"
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
  $f = Join-Path $Work ("risultati_prove\" + $EA + "\" + $EA + "_" + $Simbolo + "_IS_ohlc_" + $c.Id + ".csv")
  if(Test-Path -LiteralPath $f){ Copy-Item $f -Destination $Cart -Force }
}
$zip = $Cart + ".zip"
Remove-Item -LiteralPath $zip -Force -ErrorAction SilentlyContinue
Compress-Archive -Path (Join-Path $Cart "*") -DestinationPath $zip -Force
Write-Host ""
Write-Host ("CARTELLA: " + $Cart) -ForegroundColor Green
Write-Host ("ZIP DA MANDARE: " + $zip) -ForegroundColor Green
Write-Host "FILE ATTESI NELLO ZIP: REFERTO_INVES_DRIVE.txt + i file prova girati + i CSV della finestra intera" -ForegroundColor Gray

if($Fatale -ne ""){ Write-Host "ESITO: FERMATO" -ForegroundColor Red; exit 1 }
if($Problemi.Count -gt 0){ Write-Host "ESITO: COMPLETATO CON PROBLEMI" -ForegroundColor Yellow; exit 1 }
Write-Host ("ESITO: " + $Modo + " COMPLETATO") -ForegroundColor Green
exit 0
