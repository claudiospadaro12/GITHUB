# =====================================================================
#  MARCATORE_RIGA_G1PAOLO_v1
#  RIGA_G1PAOLO.ps1  --  I TRE VALORI DELLA LIVE DI PAOLO DEL 27/08,
#                        MESSI SUL BANCO. ABLAZIONE A STELLA.
# ---------------------------------------------------------------------
#  CINQUE CELLE, DUE MOTORI, DUE BANCHI.
#
#   STELLA A -- ABTG_SupertrendReversal su XAUUSD H4
#     00_suprev_base       baseline (InpEma2 = 89)       778000/778001
#     01_suprev_ema50      InpEma2 89 -> 50              778100/778101
#
#   STELLA B -- ABTG_SupertrendInvert su XAUUSD H1
#     10_invert_base       baseline (ADX 20, Stoch ON)   778300/778301
#     11_invert_adx25      InpAdxMin 20 -> 25            778400/778401
#     12_invert_stochoff   InpUseStoch true -> false     778500/778501
#
#  PERCHE' DUE MOTORI E NON UNO SOLO -- verificato per grep nel
#  sorgente il 28/08/2026, non a memoria:
#    InpEma2      esiste SOLO nella famiglia SupRev
#    InpAdxMin    esiste SOLO in ABTG_SupertrendInvert
#    InpUseStoch  esiste SOLO in ABTG_SupertrendInvert
#  La famiglia SupRev NON HA un filtro ADX e NON HA un filtro
#  stocastico: non sono spenti, non esistono. Quindi le "quattro celle
#  su un EA solo" NON SI POSSONO FARE, e NON e' stato aggiunto nessun
#  input a nessun EA per farle tornare (quattro di quegli EA hanno una
#  sedia viva: non si modificano in silenzio).
#
#  DUE BANCHI, dichiarati:
#    S  modello 1 (OHLC M1)   2020.01.01 -> 2026.06.30   il CAMPIONE
#    V  modello 4 (TICK)      2024.07.05 -> 2026.06.30   il RIEMPIMENTO
#  Split IS/OOS 40/60 del driver generico -> quattro sotto-finestre per
#  cella. Il banco S da solo NON autorizza nessuna proposta: e' il
#  driver generico stesso a scriverlo alla sua riga 65 ("1 = OHLC M1:
#  SOLO screening, mai verdetti").
#
#  L'IPOTESI, i criteri di lettura (esiti A/B/C/D), la regola di
#  concordanza sulle 4 sotto-finestre e i caveat stanno scritti UNA
#  VOLTA SOLA in prove\REFERTO_PREPARAZIONE_G1PAOLO.md e in testa ai
#  file prova. NON si riscrivono qui: un criterio ricopiato in sette
#  posti e' un criterio che prima o poi diverge.
#
#  ------------------------------------------------------------------
#  PERCHE' ESISTE QUESTO FILE invece di dieci righe di
#  walkforward_generico.ps1 incollate a mano. Tre motivi:
#
#   1. L'INCLUDE. Tutti e due gli EA fanno
#        #include <ABTG_PausaGuardian.mqh>
#      e walkforward_generico.ps1 NON lo installa (verificato: nel
#      driver generico la stringa 'PausaGuardian' non compare). Senza,
#      la compilazione fallisce e il driver generico muore con
#      "compilazione fallita" senza dire perche'.
#
#   2. I GATE SUI FILE PROVA. Il driver generico controlla il formato,
#      non il PERIMETRO: non sa che ogni cella deve differire dalla SUA
#      baseline di due righe sole, non sa quali magic sono vietati, non
#      sa che le celle Invert vogliono @PERIODO H1 e quelle SupRev H4.
#      Qui si controlla tutto PRIMA di aprire MT5.
#
#   3. LA RACCOLTA. Regola di casa (CLAUDE.md, regola delle righe di
#      lancio, punto 2): a fine test i risultati finiscono in una
#      cartella sul Desktop e in uno zip pronto da mandare. Sempre,
#      anche quando la corsa si ferma a meta'.
#  ------------------------------------------------------------------
#
#  QUELLO CHE NON FA, dichiarato:
#   - NON tocca nessuna sedia viva. I dieci magic sono VERGINI (blocco
#     778xxx, cercati uno per uno in tutto il repo il 28/08/2026: zero
#     occorrenze). I magic dei SORGENTI (770901, 770801) e delle sedie
#     vive (770921-770925, 970901, 970911-970916, 771001, 971001) sono
#     nella lista dei VIETATI.
#   - NON promuove e non boccia niente. Cinque celle non sono un round
#     di merito, e nessuna cella e' la configurazione viva.
#   - NON scarica storico e NON misura la profondita' dei tick. La
#     profondita' TICK di XAUUSD NON E' MAI STATA MISURATA in tutto il
#     repo (R86_CRITERI par. 2.0, R87_CRITERI par. 2.0): il 2024.07.05
#     e' la data misurata su GBPUSD, estesa per analogia -> INFERITO.
#     Il PASSO 0 che la misura sta nella pagina della riga, ed e' una
#     riga separata.
#   - non scrive una riga di MQL5 e non modifica nessun .mq5.
#
#  QUANTO CI METTE [STIMA, non una previsione]: 20 lanci fisici
#  (5 celle x 2 banchi x 2 finestre) x 2 gemelle = 40 passate. Meta'
#  sono OHLC M1 su 6,5 anni (veloci), meta' tick reali su 24 mesi di
#  oro (i piu' lenti). R107 fece 24 passate a tick reali in 9 minuti su
#  M15 indici; l'oro ha molti piu' tick. Stima 40-120 minuti piu' le
#  due compilazioni. Il -TimeoutMin non esiste qui: e' il driver
#  generico a governare le corse.
#
#  LA RIGA CHE SI INCOLLA sta in righe\RIGA_G1PAOLO_DA_MANDARE.md
# =====================================================================
[CmdletBinding()]
param(
  # -Pin NON ha default: un default silenzioso ("lavoro") farebbe
  #  girare la punta del branch spacciandola per un commit congelato.
  [string]$Pin           = "",
  [switch]$SoloControllo,          # giro a vuoto: NON apre MT5
  [switch]$Rifai,                  # rifa' anche i CSV gia' presenti
  [string]$SoloCella     = "",     # 00_suprev_base | 01_suprev_ema50 | 10_invert_base | 11_invert_adx25 | 12_invert_stochoff
  [string]$SoloBanco     = "",     # "S" (OHLC screening) | "V" (tick reali)
  [string]$Simbolo       = "XAUUSD",
  [string]$DaScreening   = "2020.01.01",   # banco S: finestra dell'antenato R103/R114
  [string]$DaTick        = "2024.07.05",   # banco V: INFERITO da GBPUSD, NON misurato su oro
  [string]$Fino          = "2026.06.30",
  [int]$Deposito         = 100000
)
$ErrorActionPreference = "Stop"
[Threading.Thread]::CurrentThread.CurrentCulture   = [Globalization.CultureInfo]::InvariantCulture
[Threading.Thread]::CurrentThread.CurrentUICulture = [Globalization.CultureInfo]::InvariantCulture
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$INV = [Globalization.CultureInfo]::InvariantCulture

$Avvio  = Get-Date
$Stamp  = $Avvio.ToString("yyyyMMdd_HHmm", $INV)
$Dsk    = Join-Path $env:USERPROFILE "Desktop"
$Work   = Join-Path $env:USERPROFILE "abtg_g1paolo"
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
$Modo     = "CORSA"
if($SoloControllo){ $Modo = "CONTROLLO" }

function Ora(){ return (Get-Date).ToString("HH:mm:ss", $INV) }
function Dico([string]$testo,[string]$colore="Gray"){ Write-Host ("[" + (Ora) + "] " + $testo) -ForegroundColor $colore }
function Titolo([string]$testo){ Write-Host ""; Write-Host ("=== " + $testo + " ===") -ForegroundColor Cyan }

function Scarica([string]$url,[string]$dest){
  Remove-Item -LiteralPath $dest -Force -ErrorAction SilentlyContinue
  Invoke-WebRequest -Uri $url -OutFile $dest -UseBasicParsing -ErrorAction Stop
  if(-not (Test-Path -LiteralPath $dest)){ throw ("scarico fallito: " + $url) }
}

function RigheVive([string]$percorso){
  return @(Get-Content -LiteralPath $percorso | Where-Object { $_ -notmatch '^\s*#' -and $_ -notmatch '^\s*$' })
}

function NumInv($testo){
  $valore = 0.0
  $ripulito = ("" + $testo).Replace([string][char]160,"").Replace(" ","").Trim()
  if($ripulito -eq ""){ return $null }
  if([double]::TryParse($ripulito,[Globalization.NumberStyles]::Float,$INV,[ref]$valore)){ return $valore }
  return $null
}

# --- LA CONVENZIONE DI SENTINELLA, e vale per TUTTE le colonne.
#     Un numero non misurato non deve MAI uscire come numero
#     plausibile: in R103 il PF non misurato usciva "0.000", che si
#     legge "ha perso tutto". Qui esce "n/d".
function FmtN($valore){ if($null -eq $valore){ return "n/d" }; if([int]$valore -lt 0){ return "n/d" }; return ([int]$valore).ToString($INV) }
function Fmt2($valore){ if($null -eq $valore){ return "n/d" }; if([double]$valore -lt 0){ return "n/d" }; return ([double]$valore).ToString("0.00",$INV) }
function FmtE($valore){ if($null -eq $valore){ return "n/d" }; if([double]$valore -le -999998.0){ return "n/d" }; return ([double]$valore).ToString("+0;-0;0",$INV) }

# --- IL PARSER DEL CSV DI OTTIMIZZAZIONE.
#     Le colonne si cercano PER NOME, mai per posizione. Se non le
#     riconosce torna $null E DICE quali intestazioni ha visto, invece
#     di indovinare. L'intestazione VERA dei due EA, LETTA NEL SORGENTE
#     (OnTesterDeinit, 'string head = ...'), e' a OTTO colonne piu' gli
#     input, e NON contiene 'Peggior Giornata %': quella colonna esiste
#     in altri EA di casa e qui NON va cercata.
$script:CsvIntestazioni = @()
function LeggiOpt([string]$percorso){
  if(-not (Test-Path -LiteralPath $percorso)){ return $null }
  $righeCsv = @()
  try{ $righeCsv = @(Import-Csv -LiteralPath $percorso) }catch{ return $null }
  if($righeCsv.Count -eq 0){ return $null }
  $colonne = @($righeCsv[0].PSObject.Properties.Name)
  $script:CsvIntestazioni = $colonne
  $kProf = $null; $kPf = $null; $kDd = $null; $kN = $null; $kMg = $null
  foreach($nomeCol in $colonne){
    $minus = ("" + $nomeCol).Trim().ToLower()
    if($minus -eq "profit" -or $minus -eq "profitto"){ $kProf = $nomeCol }
    if($minus -eq "profit factor" -or $minus -eq "fattore di profitto"){ $kPf = $nomeCol }
    if($minus -eq "equity dd %" -or $minus -eq "drawdown equity %"){ $kDd = $nomeCol }
    if($minus -eq "trades" -or $minus -eq "operazioni"){ $kN = $nomeCol }
    if($minus -eq "inpmagic"){ $kMg = $nomeCol }
  }
  if($null -eq $kProf -or $null -eq $kPf -or $null -eq $kDd -or $null -eq $kN){ return $null }
  $uscita = New-Object System.Collections.ArrayList
  foreach($rigaCsv in $righeCsv){
    $magicLetto = ""
    if($null -ne $kMg){ $magicLetto = ("" + $rigaCsv.$kMg).Trim() }
    [void]$uscita.Add([pscustomobject]@{
      Profit = (NumInv $rigaCsv.$kProf); Pf = (NumInv $rigaCsv.$kPf)
      Dd = (NumInv $rigaCsv.$kDd); N = (NumInv $rigaCsv.$kN); Magic = $magicLetto })
  }
  return @($uscita)
}

# --- I GEMELLI: le due righe devono essere IDENTICHE AL CENTESIMO.
#     E' l'unico controllo d'igiene del banco, ed e' il motivo per cui
#     l'unico asse spazzolato e' InpMagic. "Una riga sola" NON e'
#     "gemelli ok": e' uno sweep che non ha spazzolato.
$TolGemelli = 0.005
function Gemelli($righeLette){
  if($null -eq $righeLette){ return "NON MISURATO (CSV non letto)" }
  if(@($righeLette).Count -ne 2){ return ("NON VALIDO: " + @($righeLette).Count + " righe invece di 2") }
  $primo = $righeLette[0]; $secondo = $righeLette[1]
  foreach($confronto in @(@("profitto",$primo.Profit,$secondo.Profit),@("PF",$primo.Pf,$secondo.Pf),@("DD",$primo.Dd,$secondo.Dd),@("n",$primo.N,$secondo.N))){
    if($null -eq $confronto[1] -or $null -eq $confronto[2]){ return ("NON MISURATO (" + $confronto[0] + " illeggibile)") }
    if([math]::Abs([double]$confronto[1] - [double]$confronto[2]) -gt $TolGemelli){
      return ("DIVERSI su " + $confronto[0] + ": " + $confronto[1] + " contro " + $confronto[2])
    }
  }
  return "IDENTICI"
}

# =====================================================================
#  I DUE BANCHI
# =====================================================================
function B([string]$id,[int]$modello,[string]$da,[string]$descrizione){
  return [pscustomobject]@{ Id=$id; Modello=$modello; Da=$da; Desc=$descrizione }
}
$BANCHI = @()
$BANCHI += (B "S" 1 $DaScreening "OHLC M1 -- SOLO SCREENING, mai un verdetto (il CAMPIONE e i quattro regimi)")
$BANCHI += (B "V" 4 $DaTick      "TICK REALI -- il riempimento vero, ma un solo regime e campione sottile")

# =====================================================================
#  LE CINQUE CELLE.
#  'Diff'  = gli input che DEVONO differire dalla PROPRIA baseline, e
#            NESSUN ALTRO. Contare "due righe diverse" non basterebbe:
#            DUE righe SBAGLIATE darebbero lo stesso conteggio.
#  'Val'   = quanto DEVONO valere gli input chiave IN QUESTO FILE, in
#            valore ASSOLUTO. Prende il caso che il diff non puo'
#            vedere: due file SCAMBIATI, e la riga storta UGUALE in
#            tutte le celle (lezione R110 -- un diff fra A e B non puo'
#            accorgersi di niente che sia uguale in A e in B).
# =====================================================================
function C([string]$id,[string]$file,[string]$ea,[string]$periodo,[string]$baseId,
          [string]$descrizione,[int]$m1,[int]$m2,$diff,$val){
  return [pscustomobject]@{
    Id=$id; Prova=$file; Ea=$ea; Periodo=$periodo; BaseId=$baseId; Desc=$descrizione
    M1=$m1; M2=$m2; Diff=@($diff); Val=$val
    Ris=@{} }
}
$CELLE = @()
$CELLE += (C "00_suprev_base"    "G1PAOLO_00_suprev_base.txt"    "ABTG_SupertrendReversal" "H4" "" `
              "STELLA A -- BASELINE SupRev, InpEma2 = 89 (il set del documento del corso)" 778000 778001 @() `
              @{ "InpUseConfluence"="1"; "InpEma1"="14"; "InpEma2"="89"; "InpEma3"="100"; "InpEma4"="200" })
$CELLE += (C "01_suprev_ema50"   "G1PAOLO_01_suprev_ema50.txt"   "ABTG_SupertrendReversal" "H4" "00_suprev_base" `
              "InpEma2 89 -> 50 (il set che il docente dichiara di usare oggi)" 778100 778101 @("InpEma2") `
              @{ "InpUseConfluence"="1"; "InpEma1"="14"; "InpEma2"="50"; "InpEma3"="100"; "InpEma4"="200" })
$CELLE += (C "10_invert_base"    "G1PAOLO_10_invert_base.txt"    "ABTG_SupertrendInvert"   "H1" "" `
              "STELLA B -- BASELINE Invert, ADX 20 e stocastico ACCESO" 778300 778301 @() `
              @{ "InpRequireStrong"="1"; "InpUseADX"="1"; "InpAdxMin"="20.0"; "InpUseStoch"="1"; "InpUseStochH4"="0"; "InpUseExtensionFilter"="1" })
$CELLE += (C "11_invert_adx25"   "G1PAOLO_11_invert_adx25.txt"   "ABTG_SupertrendInvert"   "H1" "10_invert_base" `
              "InpAdxMin 20 -> 25 (atteso MENO operazioni: il cancello si stringe)" 778400 778401 @("InpAdxMin") `
              @{ "InpRequireStrong"="1"; "InpUseADX"="1"; "InpAdxMin"="25.0"; "InpUseStoch"="1"; "InpUseStochH4"="0"; "InpUseExtensionFilter"="1" })
$CELLE += (C "12_invert_stochoff" "G1PAOLO_12_invert_stochoff.txt" "ABTG_SupertrendInvert" "H1" "10_invert_base" `
              "InpUseStoch ON -> OFF (atteso PIU' operazioni: si toglie un anello della catena)" 778500 778501 @("InpUseStoch") `
              @{ "InpRequireStrong"="1"; "InpUseADX"="1"; "InpAdxMin"="20.0"; "InpUseStoch"="0"; "InpUseStochH4"="0"; "InpUseExtensionFilter"="1" })

# --- I MAGIC VIETATI: i magic dei SORGENTI, quelli delle sedie vive e
#     i blocchi dei round recenti. Un'identita' non in campo resta
#     comunque occupata.
$MagicVietati = @(770901, 770801, 771001, 971001,
                  770921, 770922, 770923, 770924, 770925,
                  970901, 970911, 970912, 970913, 970914, 970915, 970916,
                  776000, 776001, 776100, 776101, 776200, 776201, 776400, 776401,
                  775501, 770101, 770202, 770411, 770511, 771501, 771511, 770611)

$Ordinati = @($CELLE)
if($SoloCella -ne ""){ $Ordinati = @($CELLE | Where-Object { $_.Id -eq $SoloCella }) }
$BanchiDaFare = @($BANCHI)
if($SoloBanco -ne ""){ $BanchiDaFare = @($BANCHI | Where-Object { $_.Id -eq $SoloBanco }) }

try{
  Titolo "G1-PAOLO -- ABLAZIONE A STELLA SUI TRE VALORI DELLA LIVE -- modo $Modo"

  # -------------------------------------------------------------------
  #  0. LE GUARDIE, PRIMA DI TOCCARE QUALUNQUE COSA
  # -------------------------------------------------------------------
  if($Pin -eq ""){ throw "-Pin obbligatorio: senza, girerebbe la punta del branch spacciandola per un commit congelato." }
  if($Pin -notmatch '^[0-9a-f]{40}$'){ throw ("-Pin deve essere un commit di 40 caratteri esadecimali, ricevuto: " + $Pin) }
  if(Get-Process terminal64,metaeditor64 -ErrorAction SilentlyContinue){
    throw "MT5 O METAEDITOR APERTO: col terminale aperto il tester non gira (zero CSV), con MetaEditor aperto la compilazione torna subito senza compilare."
  }
  if($SoloCella -ne "" -and @($Ordinati).Count -eq 0){
    throw ("-SoloCella '" + $SoloCella + "' non esiste. Valide: 00_suprev_base, 01_suprev_ema50, 10_invert_base, 11_invert_adx25, 12_invert_stochoff.")
  }
  if($SoloBanco -ne "" -and @($BanchiDaFare).Count -eq 0){
    throw ("-SoloBanco '" + $SoloBanco + "' non esiste. Validi: S (OHLC screening), V (tick reali).")
  }
  if($Simbolo -ne "XAUUSD"){
    [void]$Rilievi.Add("SIMBOLO diverso da XAUUSD (" + $Simbolo + "): i file prova dichiarano @SIMBOLO XAUUSD e il gate lo confronta. Se hai cambiato simbolo di proposito, i confronti con CLASSIFICHE.md non valgono piu'.")
  }

  Dico ("pin ......... " + $Pin)
  Dico ("celle ....... " + @($Ordinati).Count + " su 5")
  Dico ("banchi ...... " + @($BanchiDaFare).Count + " su 2")
  foreach($banco in $BanchiDaFare){
    Dico ("  banco " + $banco.Id + "  modello " + $banco.Modello + "  " + $banco.Da + " -> " + $Fino + "   " + $banco.Desc)
  }
  Dico ("deposito .... " + $Deposito + "   split IS/OOS 40/60 (default del driver generico)")
  Dico ("ATTENZIONE: la profondita' TICK di XAUUSD NON E' MAI STATA MISURATA. Il " + $DaTick + " del banco V e' INFERITO da GBPUSD, non misurato sull'oro.") "Yellow"

  # -------------------------------------------------------------------
  #  1. SCARICO AL PIN
  # -------------------------------------------------------------------
  Titolo "1. SCARICO AL PIN"
  New-Item -ItemType Directory -Force -Path $Work,$Prove | Out-Null

  $drv = Join-Path $Work "walkforward_generico.ps1"
  Scarica ($RawPin + "/backtest_pipeline/walkforward_generico.ps1") $drv
  # il driver generico pinna il branch da cui riscarica il .mq5: senza
  # questo, il pin varrebbe per il driver e NON per gli EA misurati.
  $testoDrv = Get-Content -LiteralPath $drv -Raw
  if($testoDrv -notmatch '\$EABranch\s*=\s*"lavoro"'){ throw "walkforward_generico.ps1 non ha la riga \$EABranch attesa: non lo posso pinnare." }
  $testoDrv = $testoDrv -replace '\$EABranch\s*=\s*"lavoro"', ('$EABranch="' + $Pin + '"')
  Set-Content -LiteralPath $drv -Value $testoDrv -Encoding ASCII
  Dico "driver generico scaricato e PINNATO (riscarica gli EA al pin, non dalla punta del branch)" "Green"

  # GLI ARTEFATTI INTERMEDI SI RIPULISCONO PRIMA, come gli script
  # (difetto n.14 della checklist): un file prova di una versione
  # precedente rimasto nella cartella verrebbe letto dai gate e
  # confrontato coi criteri di adesso, in buona fede.
  Remove-Item -Path (Join-Path $Prove "*.txt") -Force -ErrorAction SilentlyContinue

  # si scaricano SEMPRE tutti e cinque: le due baseline servono anche
  # quando gira una cella sola, perche' sono il termine di paragone del
  # gate della stella.
  foreach($cel in $CELLE){
    Scarica ($RawPin + "/backtest_pipeline/prove/" + $cel.Prova) (Join-Path $Prove $cel.Prova)
  }
  Dico ("file prova scaricati: " + @(Get-ChildItem $Prove -Filter *.txt).Count + " su 5") "Green"

  $incSrc = Join-Path $Work "ABTG_PausaGuardian.mqh"
  Scarica ($RawPin + "/mql5/Include/ABTG_PausaGuardian.mqh") $incSrc
  Dico ("include scaricato: ABTG_PausaGuardian.mqh (" + (Get-Item $incSrc).Length + " byte)") "Green"

  # -------------------------------------------------------------------
  #  2. I GATE SUI FILE PROVA -- girano PRIMA di aprire MT5
  # -------------------------------------------------------------------
  Titolo "2. GATE SUI FILE PROVA"
  $mappe = @{}
  $magicVisti = @{}
  foreach($fileProva in @(Get-ChildItem $Prove -Filter *.txt)){
    $righeFile = RigheVive $fileProva.FullName
    $mappa = @{}
    $quantiY = 0
    $nomeY = ""
    foreach($rigaFile in $righeFile){
      if($rigaFile -match '^@'){
        $pezzi = ($rigaFile -split '\s+',2)
        if($pezzi.Count -lt 2){ throw ($fileProva.Name + ": la direttiva '" + $rigaFile + "' non ha un valore.") }
        $mappa[$pezzi[0]] = $pezzi[1].Trim()
        continue
      }
      $pos = $rigaFile.IndexOf("=")
      if($pos -lt 0){ continue }
      $nomeInput = $rigaFile.Substring(0,$pos).Trim()
      $valInput  = $rigaFile.Substring($pos+1).Trim()
      if($mappa.ContainsKey($nomeInput)){ throw ($fileProva.Name + ": DUE righe per '" + $nomeInput + "'. In [TesterInputs] un parametro doppio fa fare a MT5 ZERO passate.") }
      $mappa[$nomeInput] = $valInput
      if($valInput -match '\|\|Y\s*$'){ $quantiY++; $nomeY = $nomeInput }
    }
    if($quantiY -ne 1){ throw ($fileProva.Name + ": deve avere ESATTAMENTE un asse con flag Y, trovati " + $quantiY + ".") }
    if($nomeY -ne "InpMagic"){ throw ($fileProva.Name + ": l'unico asse Y deve essere InpMagic, invece e' " + $nomeY + ".") }
    $mappe[$fileProva.Name] = $mappa
  }

  foreach($cel in $CELLE){
    $mappa = $mappe[$cel.Prova]
    if($null -eq $mappa){ throw ("mappa mancante per " + $cel.Prova) }

    # GATE GEOMETRIA: simbolo, periodo del GRAFICO, storico dichiarato.
    # Il @PERIODO NON si deriva da InpTF: e' la trappola di R102, e qui
    # cambia per motore (SupRev H4, Invert H1).
    if($mappa["@SIMBOLO"]  -ne $Simbolo){       throw ($cel.Prova + ": @SIMBOLO e' " + $mappa["@SIMBOLO"] + ", atteso " + $Simbolo) }
    if($mappa["@PERIODO"]  -ne $cel.Periodo){   throw ($cel.Prova + ": @PERIODO e' " + $mappa["@PERIODO"] + ", la cella " + $cel.Id + " lo vuole " + $cel.Periodo) }
    if($mappa["@DAQUANDO"] -ne $DaScreening){   throw ($cel.Prova + ": @DAQUANDO e' " + $mappa["@DAQUANDO"] + ", atteso " + $DaScreening + " (la finestra del banco S; il banco V la riceve da -DaQuando esplicito)") }

    # GATE DEI VALORI ASSOLUTI: quanto valgono gli input chiave IN
    # QUESTO FILE. Prende i due casi che il diff non puo' vedere: due
    # file SCAMBIATI, e la riga storta UGUALE in tutte le celle.
    foreach($chiaveVal in @($cel.Val.Keys)){
      if(-not $mappa.ContainsKey($chiaveVal)){ throw ($cel.Prova + ": manca la riga '" + $chiaveVal + "', che e' baseline dichiarata e va verificabile nell'.ini.") }
      $primoCampo = ($mappa[$chiaveVal] -split '\|\|')[0]
      if($primoCampo -ne $cel.Val[$chiaveVal]){
        throw ($cel.Prova + ": '" + $chiaveVal + "' vale " + $primoCampo + ", la cella " + $cel.Id + " lo vuole " + $cel.Val[$chiaveVal])
      }
    }

    # GATE DELLA STELLA: contro la PROPRIA baseline cambia SOLO cio' che
    # e' dichiarato in Diff, piu' InpMagic. Confronto PER NOME, mai per
    # posizione: un file con una riga in piu' sfaserebbe tutto il resto.
    if($cel.BaseId -ne ""){
      $celBase = @($CELLE | Where-Object { $_.Id -eq $cel.BaseId })[0]
      if($null -eq $celBase){ throw ($cel.Prova + ": baseline '" + $cel.BaseId + "' non trovata nella tabella delle celle.") }
      $mappaBase = $mappe[$celBase.Prova]
      if($null -eq $mappaBase){ throw ("manca la mappa della baseline " + $celBase.Prova + ": senza, il gate della stella non e' eseguibile.") }
      $ammessi = @("InpMagic") + @($cel.Diff)
      # PRIMA la presenza (messaggio chiaro), POI la differenza: una
      # riga in piu' o in meno e' un errore diverso da una riga mossa.
      foreach($chiave in @($mappa.Keys)){
        if($chiave -match '^@'){ continue }
        if(-not $mappaBase.ContainsKey($chiave)){ throw ($cel.Prova + ": ha la riga '" + $chiave + "' che la baseline " + $celBase.Prova + " non ha. La stella confronta due file con le STESSE righe.") }
      }
      foreach($chiave in @($mappaBase.Keys)){
        if($chiave -match '^@'){ continue }
        if(-not $mappa.ContainsKey($chiave)){ throw ($cel.Prova + ": NON ha la riga '" + $chiave + "' che la baseline " + $celBase.Prova + " ha.") }
      }
      foreach($chiave in @($mappa.Keys)){
        if($chiave -match '^@'){ continue }
        if($ammessi -contains $chiave){ continue }
        if($mappaBase[$chiave] -ne $mappa[$chiave]){ throw ($cel.Prova + ": '" + $chiave + "' differisce da " + $celBase.Prova + " e NON e' un delta dichiarato.") }
      }
      foreach($chiave in @($cel.Diff)){
        if($mappaBase[$chiave] -eq $mappa[$chiave]){ throw ($cel.Prova + ": '" + $chiave + "' DOVEVA differire da " + $celBase.Prova + " e non differisce.") }
      }
    }

    # GATE DEI MAGIC: vergini, unici, mai uno vietato.
    $campiMagic = $mappa["InpMagic"] -split '\|\|'
    foreach($mg in @($campiMagic[1],$campiMagic[3])){
      $numMagic = [int]$mg
      if($MagicVietati -contains $numMagic){ throw ($cel.Prova + ": magic " + $numMagic + " e' VIETATO (sorgente, sedia viva o round recente).") }
      if($magicVisti.ContainsKey($numMagic)){ throw ("magic " + $numMagic + " usato in due celle: " + $magicVisti[$numMagic] + " e " + $cel.Prova) }
      $magicVisti[$numMagic] = $cel.Prova
    }
    if([int]$campiMagic[1] -ne $cel.M1 -or [int]$campiMagic[3] -ne $cel.M2){
      throw ($cel.Prova + ": i magic gemelli sono " + $campiMagic[1] + "/" + $campiMagic[3] + ", la cella " + $cel.Id + " li vuole " + $cel.M1 + "/" + $cel.M2)
    }
  }
  Dico ("geometria, valori assoluti, stella e magic: TUTTI PASSATI (" + $magicVisti.Count + " magic unici su 10)") "Green"

  # -------------------------------------------------------------------
  #  3. L'INCLUDE -- il pezzo che il driver generico non fa
  # -------------------------------------------------------------------
  Titolo "3. INSTALLO L'INCLUDE"
  # SI PARTE DA origin.txt, non da una spazzolata di Program Files: ogni
  # cartella dati dice da quale installazione arriva, ed e' l'unico modo
  # affidabile (un broker si installa dove vuole).
  $termRoot = Join-Path $env:APPDATA "MetaQuotes\Terminal"
  $dataFolder = ""
  foreach($cartella in (Get-ChildItem $termRoot -Directory -ErrorAction SilentlyContinue)){
    if($cartella.Name -ieq "Common"){ continue }
    $originFile = Join-Path $cartella.FullName "origin.txt"
    if(-not (Test-Path $originFile)){ continue }
    $installDir = ""
    try{ $installDir = (Get-Content $originFile -Raw -ErrorAction Stop).Trim() }catch{ continue }
    if($installDir -notlike "*BCM*"){ continue }
    if(-not (Test-Path (Join-Path $installDir "terminal64.exe"))){ continue }
    $dataFolder = $cartella.FullName
    break
  }
  if($dataFolder -and (Test-Path $dataFolder)){
    $incDir = Join-Path $dataFolder "MQL5\Include"
    New-Item -ItemType Directory -Force -Path $incDir | Out-Null
    Copy-Item $incSrc -Destination $incDir -Force
    $Include = "INSTALLATO in " + $incDir
    Dico $Include "Green"
  }else{
    $Include = "NON INSTALLATO: cartella dati BCM non trovata"
    [void]$Rilievi.Add("ABTG_PausaGuardian.mqh NON installato (cartella dati BCM non trovata). Se era gia' li' la compilazione passa lo stesso; se non c'era, il driver generico muore con 'compilazione fallita'.")
    Dico $Include "Yellow"
  }

  # -------------------------------------------------------------------
  #  4. LE CORSE -- cella per cella, banco per banco
  # -------------------------------------------------------------------
  Titolo "4. LE CORSE"
  foreach($cel in $Ordinati){
    foreach($banco in $BanchiDaFare){
      $etichetta = $cel.Id + "_" + $banco.Id
      Dico ("cella " + $cel.Id + " | banco " + $banco.Id + " (modello " + $banco.Modello + ", dal " + $banco.Da + ") -- " + $cel.Desc) "Cyan"
      # NON si chiama $args: e' una VARIABILE AUTOMATICA di PowerShell,
      # e riusarla come nome proprio e' una classe di difetto che la
      # checklist di casa vieta.
      $argv = @("-ExecutionPolicy","Bypass","-File",$drv,
                "-Expert",$cel.Ea,
                "-Prova",(Join-Path $Prove $cel.Prova),
                "-Etichetta",$etichetta,
                "-Simbolo",$Simbolo,
                "-Periodo",$cel.Periodo,
                "-DaQuando",$banco.Da,
                "-Fino",$Fino,
                "-Modello",("" + $banco.Modello),
                "-Deposito",("" + $Deposito))
      if($SoloControllo){ $argv += "-SoloControllo" }
      if($Rifai){ $argv += "-Rifai" }
      $global:LASTEXITCODE = 0
      & powershell $argv
      $rc = $LASTEXITCODE

      $esitoLancio = "MISURATA"
      $gemelliIS = "NON MISURATO"; $gemelliOOS = "NON MISURATO"
      $nIS = -1; $nOOS = -1; $pfIS = -1.0; $pfOOS = -1.0
      $ddIS = -1.0; $ddOOS = -1.0; $profIS = -999999.0; $profOOS = -999999.0

      if($rc -ne 0){
        $esitoLancio = "FERMATA (codice " + $rc + ")"
        [void]$Problemi.Add("cella " + $cel.Id + " banco " + $banco.Id + ": il driver generico e' uscito con codice " + $rc)
      }
      elseif($SoloControllo){
        $esitoLancio = "CONTROLLO OK"
      }
      else{
        # IL NOME DEL CSV: il driver generico mette "_ohlc" davanti
        # all'etichetta quando il modello NON e' 4 (riga 607), perche'
        # un OHLC non deve MAI sovrascrivere un tick reale.
        $suffModello = ""
        if($banco.Modello -ne 4){ $suffModello = "_ohlc" }
        $cartRis = Join-Path $Work ("risultati_prove\" + $cel.Ea)
        $csvIS  = Join-Path $cartRis ($cel.Ea + "_" + $Simbolo + "_IS"  + $suffModello + "_" + $etichetta + ".csv")
        $csvOOS = Join-Path $cartRis ($cel.Ea + "_" + $Simbolo + "_OOS" + $suffModello + "_" + $etichetta + ".csv")
        $letteIS  = LeggiOpt $csvIS
        $letteOOS = LeggiOpt $csvOOS
        if($null -eq $letteIS -or $null -eq $letteOOS){
          $esitoLancio = "CSV NON LEGGIBILE"
          [void]$Problemi.Add("cella " + $cel.Id + " banco " + $banco.Id + ": CSV mancante o intestazioni non riconosciute. Viste: " + ($script:CsvIntestazioni -join " | "))
        }else{
          $gemelliIS  = Gemelli $letteIS
          $gemelliOOS = Gemelli $letteOOS
          $nIS = $letteIS[0].N;   $nOOS = $letteOOS[0].N
          $pfIS = $letteIS[0].Pf; $pfOOS = $letteOOS[0].Pf
          $ddIS = $letteIS[0].Dd; $ddOOS = $letteOOS[0].Dd
          $profIS = $letteIS[0].Profit; $profOOS = $letteOOS[0].Profit
          if($gemelliOOS -ne "IDENTICI" -or $gemelliIS -ne "IDENTICI"){
            [void]$Problemi.Add("cella " + $cel.Id + " banco " + $banco.Id + ": gemelli IS=" + $gemelliIS + " OOS=" + $gemelliOOS + " -- il banco non e' deterministico, il numero non si legge.")
          }
        }
      }

      $cel.Ris[$banco.Id] = [pscustomobject]@{
        Esito=$esitoLancio; GemIS=$gemelliIS; GemOOS=$gemelliOOS
        NIS=$nIS; NOOS=$nOOS; PfIS=$pfIS; PfOOS=$pfOOS
        DdIS=$ddIS; DdOOS=$ddOOS; ProfIS=$profIS; ProfOOS=$profOOS }
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
$Cart = Join-Path $Dsk ("G1PAOLO_" + $Modo + "_" + $Stamp)
New-Item -ItemType Directory -Force -Path $Cart | Out-Null

function Segno($valore){
  if($null -eq $valore){ return 0 }
  if([double]$valore -gt 0.0){ return 1 }
  if([double]$valore -lt 0.0){ return -1 }
  return 0
}

$RefTxt = New-Object System.Collections.ArrayList
[void]$RefTxt.Add("=====================================================================")
[void]$RefTxt.Add(" G1-PAOLO -- I TRE VALORI DELLA LIVE DEL 27/08 SUL BANCO")
[void]$RefTxt.Add(" ablazione A STELLA, 5 celle, 2 motori, 2 banchi -- " + $Simbolo)
[void]$RefTxt.Add("=====================================================================")
[void]$RefTxt.Add("modo: " + $Modo + "   <- CONTROLLO = giro a vuoto, NON e' il risultato")
[void]$RefTxt.Add("data: " + $Avvio.ToString("yyyy-MM-dd HH:mm:ss",$INV))
[void]$RefTxt.Add("pin:  " + $Pin)
[void]$RefTxt.Add("banco S: modello 1 (OHLC M1)   " + $DaScreening + " -> " + $Fino + "   split 40/60")
[void]$RefTxt.Add("banco V: modello 4 (TICK REALI) " + $DaTick + " -> " + $Fino + "   split 40/60")
[void]$RefTxt.Add("deposito: " + $Deposito + "    include: " + $Include)
[void]$RefTxt.Add("")
[void]$RefTxt.Add("QUESTO ROUND NON PROMUOVE E NON BOCCIA NESSUNA SEDIA.")
[void]$RefTxt.Add("Misura TRE NUMERI usciti da una live, non un metodo. I criteri di")
[void]$RefTxt.Add("lettura sono congelati in prove\REFERTO_PREPARAZIONE_G1PAOLO.md par. 5,")
[void]$RefTxt.Add("scritti PRIMA di vedere questi numeri.")
[void]$RefTxt.Add("")
[void]$RefTxt.Add("IL NUMERO CHE SI GUARDA PER PRIMO E' n, NON IL PROFIT FACTOR --")
[void]$RefTxt.Add("soprattutto per la STELLA B: lo stato misurato dell'Invert e'")
[void]$RefTxt.Add("'NON OPERA' (REFERTO_CODA_FASCIA_B.md riga 31: 0 trade su 10 TF su 11).")
[void]$RefTxt.Add("Se la baseline B esce con n=0, il PF non esiste e le celle 11/12 sono")
[void]$RefTxt.Add("un CONTA-OPERAZIONI. n=0 contro n=0 NON e' un'ablazione: e' muta.")
[void]$RefTxt.Add("")
[void]$RefTxt.Add("--- LA TABELLA (una riga per cella e banco) ---")
[void]$RefTxt.Add("cella               bk  n IS   n OOS   PF IS   PF OOS  DD IS%  DD OOS%  Prof IS   Prof OOS  gemelli")
foreach($cel in $CELLE){
  foreach($banco in $BANCHI){
    $ris = $cel.Ris[$banco.Id]
    if($null -eq $ris){
      [void]$RefTxt.Add(("{0,-19} {1,-3} NON ESEGUITA" -f $cel.Id, $banco.Id))
      continue
    }
    $gem = "IS:" + $ris.GemIS + " OOS:" + $ris.GemOOS
    [void]$RefTxt.Add(("{0,-19} {1,-3} {2,5} {3,7} {4,7} {5,8} {6,7} {7,8} {8,9} {9,10}  {10}" -f `
      $cel.Id, $banco.Id, (FmtN $ris.NIS), (FmtN $ris.NOOS), (Fmt2 $ris.PfIS), (Fmt2 $ris.PfOOS),
      (Fmt2 $ris.DdIS), (Fmt2 $ris.DdOOS), (FmtE $ris.ProfIS), (FmtE $ris.ProfOOS), $gem))
    [void]$RefTxt.Add("                        esito: " + $ris.Esito)
  }
  [void]$RefTxt.Add("                        " + $cel.Desc)
}
[void]$RefTxt.Add("")
[void]$RefTxt.Add("--- I DELTA CONTRO LA PROPRIA BASELINE (profitto), e la CONCORDANZA ---")
[void]$RefTxt.Add("La regola e' congelata (REFERTO_PREPARAZIONE_G1PAOLO par. 5.1):")
[void]$RefTxt.Add("  4/4 stesso segno -> A  effetto MISURATO, si puo' scrivere una proposta")
[void]$RefTxt.Add("  3/4              -> B  indizio, NON proposta")
[void]$RefTxt.Add("  2/4 o meno       -> C  nessun effetto leggibile: NON si adotta")
[void]$RefTxt.Add("  segno opposto fra banco S e banco V sull'OOS -> D  CONFLITTO, non si risolve")
[void]$RefTxt.Add("")
[void]$RefTxt.Add("cella               dS-IS      dS-OOS     dV-IS      dV-OOS     concordanza  esito")
foreach($cel in $CELLE){
  if($cel.BaseId -eq ""){ continue }
  $celBase = @($CELLE | Where-Object { $_.Id -eq $cel.BaseId })[0]
  $delta = @()
  $segni = @()
  $mancante = $false
  foreach($chiaveBanco in @("S","V")){
    foreach($gamba in @("IS","OOS")){
      $rA = $cel.Ris[$chiaveBanco]
      $rB = $celBase.Ris[$chiaveBanco]
      if($null -eq $rA -or $null -eq $rB){ $delta += "n/d"; $segni += 0; $mancante = $true; continue }
      $vA = $null; $vB = $null
      if($gamba -eq "IS"){ $vA = $rA.ProfIS; $vB = $rB.ProfIS } else { $vA = $rA.ProfOOS; $vB = $rB.ProfOOS }
      if($null -eq $vA -or $null -eq $vB -or [double]$vA -le -999998.0 -or [double]$vB -le -999998.0){
        $delta += "n/d"; $segni += 0; $mancante = $true; continue
      }
      $diffProf = [double]$vA - [double]$vB
      $delta += $diffProf.ToString("+0;-0;0",$INV)
      $segni += (Segno $diffProf)
    }
  }
  $positivi = @($segni | Where-Object { $_ -eq 1 }).Count
  $negativi = @($segni | Where-Object { $_ -eq -1 }).Count
  $concordi = [math]::Max($positivi,$negativi)
  $esitoLett = ""
  if($mancante){
    $esitoLett = "NON MISURABILE (manca una finestra)"
  }elseif($concordi -eq 4){
    $esitoLett = "A -- effetto MISURATO"
  }elseif($concordi -eq 3){
    $esitoLett = "B -- indizio, NON proposta"
  }else{
    $esitoLett = "C -- nessun effetto leggibile"
  }
  if((-not $mancante) -and ($segni[1] * $segni[3]) -lt 0){
    $esitoLett = $esitoLett + " + D CONFLITTO S/V sull'OOS"
  }
  [void]$RefTxt.Add(("{0,-19} {1,-10} {2,-10} {3,-10} {4,-10} {5,-12} {6}" -f `
    $cel.Id, $delta[0], $delta[1], $delta[2], $delta[3], ("" + $concordi + "/4"), $esitoLett))
  [void]$RefTxt.Add("                    baseline: " + $celBase.Id)
}
[void]$RefTxt.Add("")
[void]$RefTxt.Add("--- COME SI LEGGE, e sono quattro avvertenze, non quattro note ---")
[void]$RefTxt.Add("1. IL BANCO S E' OHLC M1. Il driver generico lo scrive alla sua riga 65:")
[void]$RefTxt.Add("   '1 = OHLC M1: SOLO screening, mai verdetti'. Da solo NON autorizza")
[void]$RefTxt.Add("   nessuna proposta. L'illusione OHLC ha gia' revocato una promozione in")
[void]$RefTxt.Add("   questa casa (SupRev DOW H4).")
[void]$RefTxt.Add("2. IL BANCO V HA I TICK VERI MA UN CAMPIONE SOTTILE. Su oro H4 la misura")
[void]$RefTxt.Add("   agli atti e' n=44 contro i 150 dell'Emendamento regola A: il MERITO")
[void]$RefTxt.Add("   resta SOSPESO. Il RISCHIO no -- la colonna DD si legge SEMPRE, anche")
[void]$RefTxt.Add("   con n sotto soglia (regola B: un drawdown e' un fatto accaduto).")
[void]$RefTxt.Add("3. LA PROFONDITA' TICK DI XAUUSD NON E' MAI STATA MISURATA. Il 2024.07.05")
[void]$RefTxt.Add("   e' la data misurata su GBPUSD, estesa per analogia: INFERITO. Se le")
[void]$RefTxt.Add("   righe del banco V escono con n=0 o con una finestra accorciata, la")
[void]$RefTxt.Add("   causa piu' probabile e' quella, e la misura va rifatta con la data")
[void]$RefTxt.Add("   vera (PASSO 0 nella pagina della riga).")
[void]$RefTxt.Add("4. UN DELTA MISURATO SU ORO NON SI ESTENDE alle altre quattro sedie")
[void]$RefTxt.Add("   SupRev (Argento, DAX, Nikkei, Nasdaq). Quello e' un round nuovo, non")
[void]$RefTxt.Add("   un corollario.")
[void]$RefTxt.Add("")
if($Fatale -ne ""){
  [void]$RefTxt.Add("!!! FERMATO: " + $Fatale)
  [void]$RefTxt.Add("")
}
[void]$RefTxt.Add("PROBLEMI: " + $Problemi.Count)
foreach($voce in $Problemi){ [void]$RefTxt.Add("  - " + $voce) }
[void]$RefTxt.Add("RILIEVI: " + $Rilievi.Count)
foreach($voce in $Rilievi){ [void]$RefTxt.Add("  - " + $voce) }
[void]$RefTxt.Add("")
[void]$RefTxt.Add('COME SI RIPRENDE: si riparte dalla pagina righe/RIGA_G1PAOLO_DA_MANDARE.md,')
[void]$RefTxt.Add('NON da questa riga: $p e $pin nascono dentro il blocco e non sopravvivono.')

$refPath = Join-Path $Cart "REFERTO_G1PAOLO.txt"
Set-Content -LiteralPath $refPath -Value ($RefTxt -join "`r`n") -Encoding ASCII
Write-Host ($RefTxt -join "`r`n")

# --- gli artefatti: solo cio' che ha girato, copiato PER NOME.
foreach($cel in $Ordinati){
  $srcProva = Join-Path $Prove $cel.Prova
  if(Test-Path -LiteralPath $srcProva){ Copy-Item $srcProva -Destination $Cart -Force }
  foreach($banco in $BanchiDaFare){
    $suffModello = ""
    if($banco.Modello -ne 4){ $suffModello = "_ohlc" }
    foreach($gamba in @("IS","OOS")){
      $fileCsv = Join-Path $Work ("risultati_prove\" + $cel.Ea + "\" + $cel.Ea + "_" + $Simbolo + "_" + $gamba + $suffModello + "_" + $cel.Id + "_" + $banco.Id + ".csv")
      if(Test-Path -LiteralPath $fileCsv){ Copy-Item $fileCsv -Destination $Cart -Force }
    }
  }
}
$zip = $Cart + ".zip"
Remove-Item -LiteralPath $zip -Force -ErrorAction SilentlyContinue
Compress-Archive -Path (Join-Path $Cart "*") -DestinationPath $zip -Force
Write-Host ""
Write-Host ("CARTELLA: " + $Cart) -ForegroundColor Green
Write-Host ("ZIP DA MANDARE: " + $zip) -ForegroundColor Green
Write-Host "FILE ATTESI NELLO ZIP: REFERTO_G1PAOLO.txt + i file prova girati + i CSV IS/OOS di ogni cella e banco" -ForegroundColor Gray

if($Fatale -ne ""){ Write-Host "ESITO: FERMATO" -ForegroundColor Red; exit 1 }
if($Problemi.Count -gt 0){ Write-Host "ESITO: COMPLETATO CON PROBLEMI" -ForegroundColor Yellow; exit 1 }
Write-Host ("ESITO: " + $Modo + " COMPLETATO") -ForegroundColor Green
exit 0
