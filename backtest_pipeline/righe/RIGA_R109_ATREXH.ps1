# =====================================================================
#  MARCATORE_RIGA_R109_v1
#  RIGA_R109_ATREXH.ps1  --  R109: ATR EXHAUSTION & VOLUME SPIKE
#     ABTG_AtrExhaustVol su D30EUR, U30USD, NASUSD -- M15 -- TICK REALI
#     SEI celle: tre simboli x DUE LATI, misurati SEPARATI
#        00_long   InpAllowLong=true  InpAllowShort=false
#        01_short  InpAllowLong=false InpAllowShort=true
# ---------------------------------------------------------------------
#  CRITERI:   backtest_pipeline\risultati_archivio\R109_CRITERI.md
#  TESI:      ATREXHAUST_TESI.md
#  DOSSIER:   backtest_pipeline\caccia_strategie\CACCIA_M5M15_INDICI_2026-08-25.md (P2, 9/10)
#
#  >>> I CRITERI SONO [DA FIRMARE] (OTTO decisioni, par. 10). Questo driver
#      LEGGE il file dei criteri AL PIN e, se ci trova ancora la stringa del
#      lucchetto, la CORSA VERA non parte (exit 2). Il GIRO A VUOTO parte lo
#      stesso: non apre MT5, non produce nessun numero, MA COMPILA.
#      -CriteriFirmati e' la firma IN RIGA di Claudio, e finisce scritta nel
#      referto.
#
#  ------------------------------------------------------------------
#  LE TRE COSE CHE RENDONO QUESTO ROUND DIVERSO DA R108
#
#  1. L'EA NON E' MAI STATO COMPILATO. Lo dice il .mq5 stesso: "NON
#     compilato ne' testato da chi ha scritto il file". La FASE COMPILA
#     di questo driver e' LA PRIMA F7 DELLA SUA VITA: percio' stampa le
#     ultime 40 righe del log del compilatore, rimette il .mq5 com'era e
#     si ferma. Un errore di compilazione qui E' UN ESITO PREVISTO, non
#     un guasto della riga.
#
#  2. NON ESISTE UN METRO. R108 chiedeva alla cella metro di RIPRODURRE
#     R103. Qui non c'e' niente da riprodurre. Al posto del GATE
#     DELL'ANTENATO (checklist 72) c'e' il GATE DEL PORTING: i default
#     vengono ESTRATTI DAL SORGENTE al pin e confrontati riga per riga
#     con ogni file prova. E' l'unico modo di vedere la corruzione
#     SIMMETRICA (la stessa riga storta in TUTTE E DUE le celle di un
#     simbolo), che il gate della stella per costruzione non vede.
#
#  3. C'E' UN AUTOTEST DA LEGGERE, E SI LEGGE ESEGUENDO (checklist 20).
#     L'EA stampa sette blocchi in OnInit e chiude con
#     "SETTE BLOCCHI SU SETTE" oppure "DIVERGE". F7 NON lo produce.
#     Percio' esiste la PASSATA DI COLLAUDO: una cella, un mese, modello
#     1, magic 774400, ZERO numeri di round -- serve solo a leggere quelle
#     righe e a fallire PRESTO invece che dopo ore di tick reali.
#     DIVERGE = si ferma TUTTO. Righe non trovate = si prosegue, ma ogni
#     numero esce marcato NON CONVALIDATO (NON e' un verde per assenza,
#     checklist 28-bis).
#  ------------------------------------------------------------------
#
#  DA DOVE NASCE, dichiarato: e' RIGA_R108_BB_M15.ps1
#  (MARCATORE_RIGA_R108_v1) per l'ossatura. Il punto 9 della checklist dice
#  che una riscrittura non puo' perdere le funzioni di sicurezza del
#  gemello: sono state riportate TUTTE, una per una --
#    [CmdletBinding()] (checklist 71), -Pin senza default, gate della firma
#    dei criteri, guardia MT5 E MetaEditor chiusi, [Charts] MaxBars,
#    [Experts] AllowLiveTrading=false, install di ABTG_PausaGuardian.mqh,
#    gate delle righe vive, gate della STELLA, gate dei VALORI, gate
#    dell'ASSE UNICO, gate dei MAGIC, compilazione DIRETTA con verdetto sul
#    LastWriteTime del .ex5 + backup datato + ripristino del .mq5 se
#    fallisce, SOSTA SVUOTATA A OGNI GIRO, funzioni e variabili della
#    raccolta SOPRA il try, MODO nel nome della cartella e nel referto,
#    pulizia PER NOME e MAI a wildcard, cultura INVARIANTE, \r? davanti a
#    ogni $ multilinea, raccolta SEMPRE, exit ESPLICITO su ogni ramo,
#    convenzione di sentinella su TUTTE le colonne, ordine promesso =
#    ordine reale di Sort-Object (checklist 70).
#  E NON ESISTE NESSUN -Riprendi: era la guardia decorativa V3 di R108.
#  La ripresa VERA e' -SoloSimbolo / -SoloCella.
#
#  COSA FA, in ordine, e DA SOLA:
#    0.     si rifiuta di partire se MT5 O MetaEditor sono aperti
#    0-bis. si rifiuta di CORRERE se i criteri non sono firmati
#    1.     scarica AL PIN: i 6 file prova, il sorgente .mq5, l'include
#           ABTG_PausaGuardian.mqh e (dove c'e') la misura dei TICK
#           - GATE DELLE RIGHE VIVE (41 input per file, MISURATE)
#           - GATE DELLA STELLA: la cella short differisce dalla long
#             ESATTAMENTE su InpAllowLong, InpAllowShort, InpMagic,
#             InpComment
#           - GATE DEL PORTING: ogni valore = il DEFAULT DEL SORGENTE
#           - GATE SUL SORGENTE: i cinque punti del revisore (tesi par.8)
#           - GATE DEI VALORI: il lato giusto + la geometria AUTORE
#           - GATE DELL'ASSE UNICO: un solo flag Y, ed e' InpMagic
#           - GATE DEI MAGIC: unici, vergini, mai un magic vivo, MAI 774401
#    2.     FASE COMPILA: invocazione DIRETTA di metaeditor64.exe,
#           verdetto sul LastWriteTime del .ex5 (checklist 69)
#    3.     COLLAUDO AUTOTEST -> gate A0
#    4.     per ogni cella: passata SINGOLA (PASSO 0 + S0a + log) e
#           passata GEMELLA (profitto/PF/DD/n/peggior giornata + igiene)
#    5.     raccolta SEMPRE: cartella sul Desktop + zip + REFERTO
#
#  QUELLO CHE NON FA, dichiarato:
#    - NON TOCCA ABTG_AtrExhaustVol.mq5: lo copia e lo compila. Se non
#      compila, RIMETTE il .mq5 com'era.
#    - NON OTTIMIZZA NIENTE. Un solo asse Y, ed e' InpMagic. Le quattro
#      ablazioni della tesi NON girano (criteri D1).
#    - NON FA IS/OOS (criteri D3): questo round CONTA, il taglio si
#      dimensiona dopo, sui conteggi veri.
#    - NON GIUDICA IL MERITO. Un solo regime, motore controtendenza: il
#      merito e' sospeso per costruzione (criteri par. 7). Il RISCHIO si
#      legge tutto.
#    - NON promuove niente e NON tocca il forward (G5).
#    - NON MISURA LO SPREAD. Usa il valore DICHIARATO nei criteri (D4) e
#      stampa [SPREAD NON MISURATO] accanto a ogni verdetto S0a.
#    - NON MISURA LA PROFONDITA' DEI TICK. La cerca al pin; c'e' solo per
#      U30USD, e per gli altri due scrive un RILIEVO OBBLIGATORIO.
#    - NON scarica storico e NON svuota bases\<server>\ticks.
#    - NON gira su dati Dukascopy _EXT: sugli indici NON ESISTONO ancora.
#      Questo round gira SOLO su BCM, e lo dichiara.
#    - non ammazza un lavoro in corso allo scadere di -OreMax: smette solo
#      di iniziarne di nuovi (checklist 19).
#
#  QUANTO CI METTE: [STIMA], non una previsione. 13 passate, di cui 12 a
#  TICK REALI su ~23 mesi di M15 su INDICI. Il solo U30USD ha 67,6 milioni
#  di tick nella finestra. Ordine di grandezza atteso: 3-12 ore. -OreMax e'
#  14 (tetto sull'INIZIO di nuovi lavori), con margine largo apposta.
#
#  LA RIGA CHE SI INCOLLA (blocco INTERO, un comando solo - checklist 21).
#  <PIN> = il commit che contiene QUESTO file: e' l'hash dato in chat.
#
#  & { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
#      if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
#      $pin='<PIN>'; $p="$env:USERPROFILE\RIGA_R109.ps1"; Remove-Item $p -EA SilentlyContinue;
#      irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_R109_ATREXH.ps1" -OutFile $p;
#      if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_RIGA_R109_v1' -Quiet)){ throw 'SCRIPT VECCHIO' };
#      $global:LASTEXITCODE=0; & $p -Pin $pin -SoloControllo; if($LASTEXITCODE -ne 0){ Write-Host 'ESITO: PARZIALE O FERMO - leggi il REFERTO' } }
#
#  GIRO A VUOTO: e' quello qui sopra (-SoloControllo). Scrive e verifica GLI
#  STESSI .ini che girano nella corsa vera, e COMPILA. Non c'e' un secondo
#  artefatto (checklist 33).
#  >>> E NON MISURA NESSUN NUMERO: senza tester non esiste nessun n, nessun
#      PF, nessun DD, NESSUN S0 e NESSUN AUTOTEST (che richiede
#      un'ESECUZIONE, non una compilazione). Sta scritto anche nel suo
#      referto, perche' non lo si scambi per il round.
# =====================================================================
# >>> [CmdletBinding()] NON E' DECORAZIONE, ED E' MISURATO (25/08, verifica
#     di R108). Un .ps1 con il solo `param()` NON RIFIUTA i parametri che non
#     conosce: li infila in $args e TIRA DRITTO, in silenzio. Su questa riga
#     vuol dire che un `-SoloControlo` con una L sola non e' un giro a vuoto,
#     e' LA CORSA VERA -- 12 passate a tick reali su indici, avviate credendo
#     di fare il controllo da un minuto.
[CmdletBinding()]
param(
  # -Pin NON ha default: un default silenzioso ("lavoro") farebbe girare la
  #  punta del branch spacciandola per un commit congelato. Meglio morire.
  [string]$Pin        = "",
  [double]$OreMax     = 14.0,      # oltre questo NON si iniziano nuovi lavori
  [switch]$SoloControllo,          # giro a vuoto: NON apre MT5 (ma COMPILA)
  [switch]$CriteriFirmati,         # >>> lo preme CLAUDIO, non l'agente. Senza,
                                   #     la corsa vera non parte (exit 2).
  [switch]$ScreenOhlcM15,          # screen VELOCE: le celle girano a MODELLO 1
                                   #  (OHLC M1) invece che a tick reali. In
                                   #  questo modo il round NON produce nessun
                                   #  giudizio: ogni riga esce marcata NON
                                   #  GIUDICABILE e la cartella si chiama
                                   #  SCREENOHLC. Su M15 l'OHLC inganna, ed e'
                                   #  MISURATO in casa; e qui morde piu' del
                                   #  solito, perche' l'ingresso nasce da un
                                   #  ESTREMO DI BARRA e lo stop sta a un tick
                                   #  dal minimo.
                                   #  >>> checklist 67: e' un if, non una frase.
  [string]$SoloSimbolo = "",       # "D30EUR" | "U30USD" | "NASUSD", anche in
                                   #  elenco: 'D30EUR,U30USD'. FRA APICI
                                   #  (checklist 65).
  [string]$SoloCella   = ""        # es. "R109_U30USD_01_short.txt": una cella
                                   #  sola. Il COLLAUDO dell'autotest gira lo
                                   #  stesso: senza, i numeri non si convalidano.
)
$ErrorActionPreference = "Stop"
[Threading.Thread]::CurrentThread.CurrentCulture   = [Globalization.CultureInfo]::InvariantCulture
[Threading.Thread]::CurrentThread.CurrentUICulture = [Globalization.CultureInfo]::InvariantCulture
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$INV = [Globalization.CultureInfo]::InvariantCulture

$Avvio  = Get-Date
$Stamp  = $Avvio.ToString("yyyyMMdd_HHmm", $INV)
$Dsk    = Join-Path $env:USERPROFILE "Desktop"
$Work   = Join-Path $env:USERPROFILE "abtg_r109"
$Prove  = Join-Path $Work "prove"
$SrcDir = Join-Path $Work "src_motori"
$RawPin = "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$Pin"

$Ea        = "ABTG_AtrExhaustVol"
$EaVer     = "1.00"              # LETTA nel sorgente al pin il 25/08
$RigheAtte = 41                  # MISURATE sui sei file: 42 input del sorgente
                                 #  meno InpNewsCurrencies, che si toglie di
                                 #  proposito (pin di stringa vuoto = MT5 lo
                                 #  ignora). NON scritta a memoria.
$Deposito  = 100000              # e' anche la taglia prop
$SpreadIni = 0                   # 0 = spread CORRENTE, ma SCRITTO nell'ini
                                 #  invece che lasciato allo stato nascosto del
                                 #  terminale. NON e' uno stress e NON e' una
                                 #  misura dello spread (criteri par. 3.2).
$CelleAttese = 2                 # le due passate GEMELLE, per CSV

#--- LO SPREAD DI RIFERIMENTO DI S0a. E' [NON MISURATO]: criteri D4.
#    2,0 PUNTI INDICE = il lato ALTO della forchetta 1-2 di R98_CRITERI.md,
#    cioe' una scelta PRUDENZIALE DICHIARATA, non una misura del feed BCM.
#    Ogni verdetto S0a esce con l'etichetta [SPREAD NON MISURATO] accanto.
$SpreadPuntiDich = 2.0
$S0aMult         = 3.0           # take LORDO mediano >= 3 x spread
$S0aBanda        = 0.5           # se il rapporto cade in 3.0 +- 0.5 il
                                 #  verdetto NON si da': si misura lo spread e
                                 #  si rilegge (criteri D4).
$RMinPunti       = 5.0           # sotto questa perdita mediana (~ R) scatta
                                 #  l'allarme "stop stretto -> lotto grande ->
                                 #  lo slippage si mangia l'operazione" (R55).

#--- LE FINESTRE. Criteri par. 4.
$DataDa        = "2024.09.26"        # MISURATO: REFERTO_SONDA_STORICO_17-08.md,
                                 #  stato COMPLETO = il broker non ha altro.
$DataA         = "2026.08.21"        # ultimo venerdi' prima del round
$MesiPrimaOp = 2                 # prima operazione entro N mesi = FINESTRA
                                 #  PIENA. 2 e non 6 (R103/R108): su 23 mesi,
                                 #  sei mesi sarebbero un quarto della finestra
                                 #  buttato senza accorgersene.
#--- IL COLLAUDO DELL'AUTOTEST (criteri par. 3.1): un mese, modello 1,
#    ZERO numeri di round. Serve solo a far stampare OnInit.
$CollaudoDa = "2026.06.01"
$CollaudoA  = "2026.06.30"
$CollaudoMagic = 774400

#--- I MAGIC VIETATI: le sedie vive, i round recenti, e IL DEFAULT DELL'EA.
#    774401 e' il default compilato di ABTG_AtrExhaustVol: se una cella
#    girasse col default -- pin saltato, o MT5 che si ricorda l'ultimo valore
#    (checklist 25) -- il magic lo direbbe, e questo gate lo ferma.
$MagicVietati = @(774401,                                    # <<< DEFAULT DELL'EA
                  760020,760021,760030,760031,760040,760041, # R103 BB
                  772161,772162,772163,
                  770202,770101,770201,                      # aperture
                  770611,770601,770411,770901,770511,970913, # sedie confinanti
                  971501,770402,970901,770532,772341,
                  772601,772602,772611,772612,               # R54
                  772800,772890,772891,                      # R98
                  773200,773201,773300,773301,               # R101
                  750010,750011,                             # R104
                  761000,761001,761010,761011,761100,761101, # R107
                  761110,761111,761200,761201,761210,761211,
                  762000,762001,762010,762011,762020,762021, # R108
                  762030,762031,762040,762041,762050,762051)

# =====================================================================
#  LE SEI CELLE. Due per simbolo, e fra loro cambia SOLO IL LATO.
#
#  >>> DA DOVE VIENE OGNI COLONNA (criteri par. 1 e 2):
#      - Lato    : LONG / SHORT. E' l'unico asse del round.
#      - Base    : magic. Blocco 7744xx VERGINE (verificato il 25/08: le
#                  uniche 4 occorrenze nel repo sono il valore 774401, che
#                  e' il default dell'EA ed e' VIETATO).
#      - Punto   : quanto vale 1 PUNTO INDICE in prezzo. Su BCM D30EUR,
#                  U30USD e NASUSD hanno 2 DECIMALI -> 1 punto indice = 1,00
#                  di prezzo = 100 punti MT5 (misura R97/R98). Su un indice
#                  il "pip" NON ESISTE.
#      - TickMis : la misura della profondita' dei TICK, se esiste al pin.
#
#  >>> CHECKLIST 64: OGNI parametro e' TIPIZZATO e ogni confronto con un
#      sentinella e' CASTATO SUL POSTO.
# =====================================================================
function S([string]$sym,[double]$punto){
  return [pscustomobject]@{
    Sym=$sym; Punto=$punto; TickMisurati="NON MISURATA"; TickData="n/d"
  }
}
$SIMBOLI = @(
  (S "D30EUR" 1.0),
  (S "U30USD" 1.0),
  (S "NASUSD" 1.0)
)

# ---------------------------------------------------------------------
#  LE CELLE. 'Val' = i valori che questo file DEVE avere: il gate della
#  stella dice CHE COSA cambia, questo dice CHE COSA VALE. Se i due file
#  di un simbolo fossero SCAMBIATI, la stella resterebbe verde e questo
#  no (checklist 34-bis).
#  >>> V2 e' una FUNZIONE apposta per non scrivere hashtable letterali
#      multilinea: e' la classe di difetto 63, che non e' un errore di
#      runtime ma di PARSE, e nessuna guardia interna la intercetta.
# ---------------------------------------------------------------------
function V2([string]$vlong,[string]$vshort){
  $h = @{}
  $h["InpAllowLong"]  = $vlong
  $h["InpAllowShort"] = $vshort
  return $h
}
function C([string]$sym,[string]$id,[string]$lato,[string]$file,[string]$desc,$val){
  return [pscustomobject]@{
    Sym=$sym; Id=$id; Lato=$lato; Prova=$file; Desc=$desc;
    Val=$val; Base=0; Modello=4; Esito="NON ESEGUITA"; Min=0.0;
    # --- gemelle: finestra INTERA (l'unica finestra di R109, criteri D3)
    PfInt=-1.0; DdInt=-1.0; NInt=-1; ProfInt=-999999.0; PgInt=99.9; GemInt="NON MISURATO";
    # --- PASSO 0, dalla passata SINGOLA (report .htm)
    P0Stato="NON MISURATO"; P0Prima="NON MISURATA"; P0Ultima="NON MISURATA";
    P0N=-1; P0Finestra="NON MISURATA"; P0Sedute=-1; P0OpSeduta=-1.0;
    P0GiorniOp=-1; P0MaxGiorno=-1; P0GiorniAlCap=-1;
    P0TakeNetMed=-1.0; P0TakeNetMedia=-1.0; P0TakeLordoMed=-1.0; P0Rapporto=-1.0;
    P0PerdMed=-1.0; P0DurMed=-1.0; P0DurMedia=-1.0; P0Pegg=99.9; P0PeggData="n/d";
    S0a="NON MISURATO"; Autotest="NON LETTO"
  }
}
$CELLE = @()
foreach($s in $SIMBOLI){
  $cl = (C $s.Sym "00_long" "LONG" ("R109_" + $s.Sym + "_00_long.txt") `
           "SOLO LONG -- il fade al pivot BASSO. In un toro e' il lato che compra i minimi." `
           (V2 "true" "false"))
  $cs = (C $s.Sym "01_short" "SHORT" ("R109_" + $s.Sym + "_01_short.txt") `
           "SOLO SHORT -- il fade al pivot ALTO, ed e' il lato SIMMETRIZZATO (tesi par. 4.3)." `
           (V2 "false" "true"))
  $CELLE += $cl
  $CELLE += $cs
}
$i = 0
foreach($c in $CELLE){ $c.Base = 774410 + ($i * 10); $i++ }
foreach($c in $CELLE){ if($ScreenOhlcM15){ $c.Modello = 1 } }

# =====================================================================
#  TUTTO CIO' CHE LA RACCOLTA USA NASCE QUI, PRIMA DEL try
#  (checklist 41-bis), FUNZIONI COMPRESE (checklist 48: in PowerShell una
#  `function` non e' dichiarativa, e' un'ISTRUZIONE: se il flusso non ci
#  passa sopra il nome non esiste, e la raccolta esplode proprio nella
#  corsa fermata da un gate -- cioe' l'unica in cui il referto serve).
# =====================================================================
$Risultati = Join-Path $Work "risultati_prove"
$Sosta     = Join-Path $Work "sosta"
$Logs      = Join-Path $Work "log_r109"
$Problemi  = New-Object System.Collections.ArrayList
$Rilievi   = New-Object System.Collections.ArrayList
$Fatale    = ""
$Firma     = "NON LETTA"
$Terminal  = ""; $MetaEditor = ""; $DataFolder = ""; $InstDir = ""
$MqlFiles  = ""; $CommonFiles = ""; $TermRoot = ""
$Ordinati  = @()      # checklist 41-bis: la raccolta lo scorre SEMPRE
$Vive      = @{}
$SelettoreAVuoto = $false
$nAnt      = -1
$Compilato = $false
$AutotestStato = "NON ESEGUITO"
$AutotestRighe = @()
$AutotestFile  = "n/d"
$Warning       = -1

function Ora(){ return (Get-Date).ToString("HH:mm:ss", $INV) }
function Dico([string]$t,[string]$c="Gray"){ Write-Host ("[" + (Ora) + "] " + $t) -ForegroundColor $c }
function Titolo([string]$t){ Write-Host ""; Write-Host ("=== " + $t + " ===") -ForegroundColor Cyan }

function Scarica([string]$url,[string]$dest,[string]$marcatore){
  Remove-Item -LiteralPath $dest -Force -ErrorAction SilentlyContinue
  Invoke-WebRequest -Uri $url -OutFile $dest -UseBasicParsing -ErrorAction Stop
  if(-not (Test-Path -LiteralPath $dest)){ throw ("scarico fallito: " + $url) }
  if($marcatore -ne "" -and -not (Select-String -LiteralPath $dest -SimpleMatch -Pattern $marcatore -Quiet)){
    throw ("file scaricato SENZA il marcatore '" + $marcatore + "': " + $url)
  }
}

function RigheVive([string]$p){
  return @(Get-Content -LiteralPath $p | Where-Object { $_ -notmatch '^\s*#' -and $_ -notmatch '^\s*$' })
}
function NomeDi([string]$riga){
  if($riga -match '^@'){ return ($riga -split '\s+')[0] }
  return (($riga -split '=')[0]).Trim()
}
function ValoreDi([string]$riga){
  $i = $riga.IndexOf("=")
  if($i -lt 0){ return "" }
  $resto = $riga.Substring($i+1)
  return (($resto -split '\|\|')[0]).Trim()
}
function NumInv($s){
  $v = 0.0
  #  MISURATO sui report veri: MT5 scrive le migliaia con lo SPAZIO
  #  ("45 005.54"). Si tolgono tutti gli spazi, compresi i tipografici
  #  (nbsp 160, narrow-nbsp 8239, thin space 8201).
  $t = ("" + $s).Replace([string][char]160,"").Replace([string][char]8239,"").Replace([string][char]8201,"").Replace(" ","").Replace("&nbsp;","").Trim()
  if($t -eq ""){ return $null }
  if([double]::TryParse($t,[Globalization.NumberStyles]::Float,$INV,[ref]$v)){ return $v }
  return $null
}

# ---------------------------------------------------------------------
#  LA CONVENZIONE DI SENTINELLA, E VALE PER TUTTE LE COLONNE.
#  checklist 66: in R103 era applicata a META' delle colonne, e il PF non
#  misurato usciva "0.000", cioe' un numero PLAUSIBILE che si legge "ha
#  perso tutto". Qui:
#    - i decimali NON MISURATI valgono -1.0   -> Fmt2/Fmt3 -> "n/d"
#    - gli interi NON MISURATI valgono -1     -> FmtN      -> "n/d"
#    - il PROFITTO non misurato vale -999999  -> FmtE      -> "n/d"
#    - la PEGGIOR GIORNATA non misurata vale 99.9 -> FmtPg -> "n/d"
#  Le due colonne che NON possono usare -1 sono il PROFITTO (negativo ogni
#  volta che la cella perde) e la PEGGIOR GIORNATA (negativa SEMPRE).
# ---------------------------------------------------------------------
function Fmt2($v){
  if($null -eq $v){ return "n/d" }
  if([double]$v -lt 0){ return "n/d" }
  return ([double]$v).ToString("0.00",$INV)
}
function Fmt3($v){
  if($null -eq $v){ return "n/d" }
  if([double]$v -lt 0){ return "n/d" }
  return ([double]$v).ToString("0.000",$INV)
}
function FmtN($v){
  if($null -eq $v){ return "n/d" }
  if([int]$v -lt 0){ return "n/d" }
  return ([int]$v).ToString($INV)
}
function FmtE($v){
  if($null -eq $v){ return "n/d" }
  if([double]$v -le -999998.0){ return "n/d" }
  #  NIENTE separatore delle migliaia, ed e' voluto: sotto cultura
  #  invariante "+2,812" si scrive con la VIRGOLA, e un lettore italiano
  #  lo legge "due virgola otto".
  return ([double]$v).ToString("+0;-0;0",$INV)
}
function FmtPg($v){
  if($null -eq $v){ return "n/d" }
  if([double]$v -ge 99.0){ return "n/d" }
  return ([double]$v).ToString("0.00",$INV)
}
function Mediana($lista){
  $a = @($lista | Sort-Object)
  if($a.Count -eq 0){ return -1.0 }
  if($a.Count % 2 -eq 1){ return [double]$a[[int](($a.Count-1)/2)] }
  return ([double]$a[$a.Count/2 - 1] + [double]$a[$a.Count/2]) / 2.0
}

# =====================================================================
#  IL GATE DEL PORTING -- l'analogo dell'ANTENATO di R108 (checklist 72),
#  su un motore che di antenati non ne ha.
#
#  ValDefault: traduce il valore scritto NEL SORGENTE in quello che sta
#  nel file prova. Le enum in MQL5 si scrivono col NOME nel .mq5 e col
#  NUMERO nell'.ini: se non le traducessimo, il gate accuserebbe due file
#  sani (e' la classe 60, il pattern confrontato col metro sbagliato).
# =====================================================================
function ValDefault([string]$raw){
  $v = ("" + $raw).Trim()
  #  gli apici doppi si scrivono come [char]34 e non come letterale: cosi'
  #  la riga non contiene nessun apice doppio, e lint_ps1.py non la legge
  #  come una stringa espansa (falso positivo suo, ma un lint rumoroso e'
  #  un lint che si smette di guardare).
  $q = [string][char]34
  if($v.Length -ge 2 -and $v.StartsWith($q) -and $v.EndsWith($q)){ $v = $v.Substring(1,$v.Length-2) }
  if($v -eq "EX_PROX_PERC"){ return "0" }
  if($v -eq "EX_PROX_ATR"){ return "1" }
  if($v -eq "EX_TRIG_AUTORE"){ return "0" }
  if($v -eq "EX_TRIG_CLOSE"){ return "1" }
  return $v
}
#  Il confronto e' NUMERICO quando entrambi sono numeri: nel sorgente
#  InpTP1Pct e' "0" e in un file prova potrebbe essere "0.0" -- sono lo
#  stesso valore, e un confronto di stringhe direbbe di no. Sui bool e
#  sulle stringhe il confronto e' esatto e CASE SENSITIVE ("True" non e'
#  "true": MT5 li accetta entrambi, ma noi vogliamo file uniformi).
function UgualeVal([string]$a,[string]$b){
  if($a -ceq $b){ return $true }
  $x = 0.0; $y = 0.0
  if([double]::TryParse($a,[Globalization.NumberStyles]::Float,$INV,[ref]$x) -and
     [double]::TryParse($b,[Globalization.NumberStyles]::Float,$INV,[ref]$y)){
    return ([math]::Abs($x - $y) -le 0.000000001)
  }
  return $false
}
#  >>> I LIMITI DI QUESTA REGEX, PROVATI E DICHIARATI (25/08). Quasi tutti
#      sono FAIL-CLOSED, cioe' fanno FERMARE il gate invece di farlo passare:
#      un input che la regex NON estrae ma che il file prova pinna esce come
#      "non e' un input del sorgente" -> throw. Provati uno per uno:
#        - due input sulla stessa riga  -> valore storto     -> FERMA
#        - commento /* */ prima del valore -> valore storto   -> FERMA
#        - input INDENTATO (spazi prima) -> non estratto      -> FERMA
#      L'unico caso FAIL-OPEN e' un input NUOVO nel sorgente scritto in una
#      forma che la regex non vede E non pinnato nel file prova: girerebbe al
#      suo default compilato senza che nessuno lo sappia (checklist 25).
#      Percio' 'sinput' e 'static' sono coperti qui sotto -- sono le due
#      forme legali di MQL5 che il gate avrebbe mancato. L'INDENTAZIONE
#      resta fuori DI PROPOSITO: un '^\s*input' prenderebbe anche le righe
#      dentro un commento a blocco e inventerebbe input che non esistono,
#      cioe' un falso FERMATO su un sorgente sano (checklist 55).
function DefaultDalSorgente([string]$testo){
  $h = @{}
  foreach($m in [regex]::Matches($testo,'(?m)^s?input\s+(?:static\s+)?(?:bool|int|double|long|string|ENUM_\w+)\s+(\w+)\s*=\s*([^;]+);')){
    $h[$m.Groups[1].Value] = (ValDefault $m.Groups[2].Value)
  }
  return $h
}

# =====================================================================
#  IL PARSER DEL CSV DI OTTIMIZZAZIONE -- con il CONTROLLO POSITIVO.
#
#  Il bug di R99 (una parola mancante nell'elenco dei sinonimi faceva
#  tornare una lista vuota, e il chiamante scriveva "NON MISURATA" su una
#  tabella perfettamente leggibile) qui e' impedito da tre cose:
#   1. le colonne si cercano PER NOME nell'intestazione, mai per posizione;
#   2. i sinonimi sono COMPLETI, italiano e inglese;
#   3. se NON riconosce le colonne torna $null E DICE QUALI INTESTAZIONI
#      HA VISTO -- perche' il 23/08, per scoprire la parola mancante, e'
#      servito aprire lo zip a mano.
#  L'intestazione VERA e' MISURATA nel sorgente di questo EA (OPTFRAME
#  inlined, riga 1127):
#    Pass,Profit,Expected Payoff,Profit Factor,Recovery Factor,
#    Sharpe Ratio,Equity DD %,Trades,Peggior Giornata %,...
# =====================================================================
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
    $h = ("" + $k).Trim().ToLower()
    if($null -eq $kProf -and ($h -eq "profit" -or $h -eq "profitto" -or $h -eq "utile")){ $kProf = $k }
    if($null -eq $kPf   -and ($h -eq "profit factor" -or $h -eq "fattore di profitto")){ $kPf = $k }
    if($null -eq $kDd   -and ($h -eq "equity dd %" -or $h -eq "drawdown equity %" -or $h -eq "equity drawdown %" -or $h -eq "drawdown %")){ $kDd = $k }
    if($null -eq $kN    -and ($h -eq "trades" -or $h -eq "operazioni" -or $h -eq "trade")){ $kN = $k }
    if($null -eq $kPg   -and ($h -eq "peggior giornata %" -or $h -eq "worst day %")){ $kPg = $k }
    if($null -eq $kMg   -and ($h -eq "inpmagic")){ $kMg = $k }
  }
  #  CONTROLLO POSITIVO: senza le quattro colonne che contano non si tira
  #  a indovinare. Torna $null, e chi chiama scrive "NON MISURATA".
  if($null -eq $kProf -or $null -eq $kPf -or $null -eq $kDd -or $null -eq $kN){ return $null }
  $out = New-Object System.Collections.ArrayList
  foreach($r in $righe){
    $pg = $null
    if($null -ne $kPg){ $pg = (NumInv $r.$kPg) }
    $mg = ""
    if($null -ne $kMg){ $mg = ("" + $r.$kMg).Trim() }
    [void]$out.Add([pscustomobject]@{
      Profit = (NumInv $r.$kProf); Pf = (NumInv $r.$kPf); Dd = (NumInv $r.$kDd)
      N = (NumInv $r.$kN); Pg = $pg; Magic = $mg
    })
  }
  return @($out)
}

#  I GEMELLI: le due righe devono essere IDENTICHE AL CENTESIMO su
#  profitto, PF, DD e n. E' l'igiene di casa, ed e' il motivo per cui
#  l'unico asse spazzolato e' InpMagic.
#  >>> E SI PRETENDE CHE SIANO DUE. "Una riga sola" non e' "gemelli ok":
#      e' uno sweep che non ha spazzolato (checklist 55).
function Gemelli($righe){
  if($null -eq $righe){ return "NON MISURATO (CSV non letto)" }
  if(@($righe).Count -ne 2){ return ("NON VALIDO: " + @($righe).Count + " righe invece di 2") }
  $a = $righe[0]; $b = $righe[1]
  foreach($ch in @(@("profitto",$a.Profit,$b.Profit),@("PF",$a.Pf,$b.Pf),
                   @("DD",$a.Dd,$b.Dd),@("n",$a.N,$b.N))){
    if($null -eq $ch[1] -or $null -eq $ch[2]){ return ("NON MISURATO (" + $ch[0] + " illeggibile)") }
    if([math]::Abs([double]$ch[1] - [double]$ch[2]) -gt 0.005){
      return ("DIVERSI su " + $ch[0] + ": " + $ch[1] + " contro " + $ch[2])
    }
  }
  return "IDENTICI"
}

# =====================================================================
#  LETTURA DI UN FILE DI TESTO DI MT5 (report .htm e log del tester).
#  L'ORDINE NON SI CAMBIA: MISURATO che il report di R99 e' UTF-16, e il
#  tentativo UTF8 su byte UTF-16 produce "<\0t\0r\0", quindi il match
#  fallisce correttamente e si passa a Unicode.
# =====================================================================
function TestoDi([string]$path,[string]$sonda){
  try{
    $by = [IO.File]::ReadAllBytes($path)
    $t = [Text.Encoding]::UTF8.GetString($by)
    if($t -notmatch $sonda){ $t = [Text.Encoding]::Unicode.GetString($by) }
    if($t -notmatch $sonda){ $t = [Text.Encoding]::GetEncoding(1252).GetString($by) }
    return $t
  }catch{ return "" }
}

# =====================================================================
#  IL PARSER DEI DEAL DEL REPORT .htm
#  E' quello di R100/R102/R103/R108, che nasce dal bug di R99 (il parser
#  cercava 'balance'/'saldo' e MT5 in italiano scrive BILANCIO, quindi
#  tornava una lista vuota su una tabella perfettamente leggibile).
#  >>> Legge anche Tipo, Volume e PREZZO: senza il PREZZO non esiste
#      nessun take in punti indice, cioe' non esiste il PASSO 0.
#  Intestazione MISURATA (MT5 italiano):
#    Ora | Affare | Simbolo | Tipo | Direzione | Volume | Prezzo |
#    Ordine | Commissioni | Swap | Profitto | Bilancio | Commento
#  Il CONTROLLO POSITIVO e' dentro: una riga vale solo se ha una data vera
#  nella colonna Ora E 'in'/'out' nella colonna Direzione. Se non ne
#  riconosce nessuna torna VUOTO, chi chiama scrive "NON MISURATA" -- e
#  dice anche QUALI intestazioni ha visto.
# =====================================================================
$script:DealIntestazioni = @()
$script:DealColonne = ""
function LeggiDeal([string]$path){
  $txt = TestoDi $path '<t[dr]'
  if($txt -eq ""){ return @() }
  $righe = New-Object System.Collections.ArrayList
  foreach($tr in [regex]::Matches($txt,'(?s)<tr[^>]*>(.*?)</tr>')){
    $celle = New-Object System.Collections.ArrayList
    foreach($td in [regex]::Matches($tr.Groups[1].Value,'(?s)<t[dh][^>]*>(.*?)</t[dh]>')){
      $c = $td.Groups[1].Value
      $c = [regex]::Replace($c,'<[^>]+>','')
      $c = $c.Replace("&nbsp;"," ").Replace([string][char]160," ").Trim()
      [void]$celle.Add($c)
    }
    [void]$righe.Add(@($celle))
  }
  $iOra=-1; $iDir=-1; $iProf=-1; $iSald=-1; $iComm=-1; $iSwap=-1; $iPrez=-1; $iVol=-1; $iTipo=-1
  $viste = New-Object System.Collections.ArrayList
  foreach($celle in $righe){
    if($celle.Count -lt 8){ continue }
    $o=-1; $dz=-1; $p=-1; $s=-1; $c=-1; $w=-1; $pz=-1; $vl=-1; $tp=-1
    for($i=0; $i -lt $celle.Count; $i++){
      $h = ("" + $celle[$i]).ToLower().Trim()
      if($h -eq "time" -or $h -eq "ora" -or $h -eq "orario"){ $o = $i }
      if($h -eq "direction" -or $h -eq "direzione"){ $dz = $i }
      if($h -eq "profit" -or $h -eq "profitto" -or $h -eq "utile"){ $p = $i }
      if($h -eq "balance" -or $h -eq "saldo" -or $h -eq "bilancio"){ $s = $i }
      if($h -eq "commission" -or $h -eq "commissione" -or $h -eq "commissioni"){ $c = $i }
      if($h -eq "swap"){ $w = $i }
      if($h -eq "price" -or $h -eq "prezzo"){ $pz = $i }
      if($h -eq "volume" -or $h -eq "volumi"){ $vl = $i }
      if($h -eq "type" -or $h -eq "tipo"){ $tp = $i }
    }
    #  >>> LE INTESTAZIONI SI RACCOLGONO SEMPRE, non solo quando qualcosa
    #      e' stato riconosciuto: se NESSUNA colonna viene riconosciuta il
    #      messaggio d'errore uscirebbe VUOTO, ed e' il caso in cui serve di
    #      piu' (il 23/08, per trovare la parola mancante, e' servito aprire
    #      lo zip a mano).
    if($viste.Count -lt 6){ [void]$viste.Add(($celle -join " | ")) }
    if($p -ge 0 -and $s -ge 0){ $iOra=$o; $iDir=$dz; $iProf=$p; $iSald=$s; $iComm=$c; $iSwap=$w; $iPrez=$pz; $iVol=$vl; $iTipo=$tp; break }
  }
  $script:DealIntestazioni = @($viste | Select-Object -First 6)
  if($iProf -lt 0 -or $iSald -lt 0){ return @() }
  if($iOra -lt 0){ $iOra = 0 }        # MISURATO: 'Ora' e' la prima colonna
  #  >>> IL PREZZO E' OBBLIGATORIO PER IL PASSO 0. Senza, non si tira a
  #      indovinare una colonna: si torna vuoto e chi chiama lo dichiara.
  if($iPrez -lt 0){
    $script:DealColonne = "PREZZO NON TROVATO nell'intestazione: senza il prezzo il take in punti indice NON esiste."
    return @()
  }
  $script:DealColonne = ("Ora=" + $iOra + " Direzione=" + $iDir + " Tipo=" + $iTipo +
                         " Volume=" + $iVol + " Prezzo=" + $iPrez + " Profitto=" + $iProf +
                         " Bilancio=" + $iSald + " Commissioni=" + $iComm + " Swap=" + $iSwap)
  $tutti = @($iOra,$iDir,$iProf,$iSald,$iComm,$iSwap,$iPrez,$iVol,$iTipo)
  $maxi = @($tutti | Measure-Object -Maximum).Maximum
  $out = New-Object System.Collections.ArrayList
  foreach($celle in $righe){
    if($celle.Count -le $maxi){ continue }
    if($celle[$iOra] -notmatch '^\d{4}\.\d{2}\.\d{2} \d{2}:\d{2}:\d{2}$'){ continue }
    #  la direzione si legge NELLA SUA COLONNA, non scandendo tutte le
    #  celle: un 'in' dentro la colonna COMMENTO farebbe passare per deal
    #  una riga qualunque (checklist 58). MISURATO: i valori sono 'in'/'out'
    #  MINUSCOLI e NON localizzati, anche col terminale in italiano.
    $dir = ""
    if($iDir -ge 0){ $dir = ("" + $celle[$iDir]).ToLower().Trim() }
    if($dir -ne "in" -and $dir -ne "out" -and $dir -ne "in/out"){ continue }
    $d = [datetime]::MinValue
    if(-not [datetime]::TryParseExact($celle[$iOra],"yyyy.MM.dd HH:mm:ss",$INV,[Globalization.DateTimeStyles]::None,[ref]$d)){ continue }
    $pr = (NumInv $celle[$iProf])
    $cm = $null; if($iComm -ge 0){ $cm = (NumInv $celle[$iComm]) }
    $sw = $null; if($iSwap -ge 0){ $sw = (NumInv $celle[$iSwap]) }
    $netto = 0.0
    if($null -ne $pr){ $netto += [double]$pr }
    if($null -ne $cm){ $netto += [double]$cm }
    if($null -ne $sw){ $netto += [double]$sw }
    $tipo = ""; if($iTipo -ge 0){ $tipo = ("" + $celle[$iTipo]).ToLower().Trim() }
    $vol = $null; if($iVol -ge 0){ $vol = (NumInv $celle[$iVol]) }
    $prz = (NumInv $celle[$iPrez])
    #  >>> IL CONTROLLO POSITIVO SUL *VALORE*, non solo sulla COLONNA.
    #      Le colonne hanno gia' il loro controllo positivo (sopra). Questo
    #      copre il caso in cui la colonna e' giusta e il NUMERO non si
    #      converte -- per esempio perche' il report scrive i decimali in un
    #      formato diverso da quello MISURATO ("45 005.54").
    #      Senza, $netto resterebbe 0.0 su TUTTI i deal e la PEGGIOR
    #      GIORNATA uscirebbe "0.00": un numero PLAUSIBILE E FALSO proprio
    #      sulla colonna che i criteri (G4) chiamano quella da guardare per
    #      prima, e in violazione della convenzione di sentinella
    #      (checklist 66: "n/d", MAI 0). RIPRODOTTO il 25/08 su un report
    #      finto con i decimali a virgola.
    #      >>> Una cella VUOTA vale ZERO ed e' normale (MT5 lascia vuoto il
    #          profitto della riga 'in'): si segnala solo la cella PIENA che
    #          non si converte (checklist 55: riparare il falso positivo
    #          senza perdere il vero positivo).
    $illeg = $false
    if($iProf -ge 0 -and $null -eq $pr  -and ("" + $celle[$iProf]).Trim() -ne ""){ $illeg = $true }
    if($iComm -ge 0 -and $null -eq $cm  -and ("" + $celle[$iComm]).Trim() -ne ""){ $illeg = $true }
    if($iSwap -ge 0 -and $null -eq $sw  -and ("" + $celle[$iSwap]).Trim() -ne ""){ $illeg = $true }
    if($null -eq $prz -and ("" + $celle[$iPrez]).Trim() -ne ""){ $illeg = $true }
    [void]$out.Add([pscustomobject]@{
      Ora=$d; Dir=$dir; Tipo=$tipo; Volume=$vol; Prezzo=$prz; Netto=$netto; Illeggibile=$illeg
    })
  }
  return @($out)
}

# =====================================================================
#  IL PASSO 0 -- accoppia i deal in -> out e ne tira fuori le misure che
#  i criteri par. 3.3 chiedono. Con UNA POSIZIONE ALLA VOLTA per magic e
#  InpTP1Pct=0 (nessuna parziale) la sequenza DEVE essere alternata e i
#  volumi di 'in' e 'out' DEVONO coincidere.
#  >>> SE NON LO SONO, LA MISURA SI DICHIARA NON MISURATA E NON SI STIMA.
#      E' scritto nei criteri prima di girare, e qui e' l'if che lo impone
#      (checklist 67).
#
#  >>> LE UNITA': il take e la perdita sono in PUNTI INDICE. Su BCM i tre
#      indici hanno 2 decimali -> 1 punto indice = 1,00 di prezzo (R97/R98).
#      Su un indice il "pip" NON ESISTE: chiamarlo pip e' la classe di
#      difetto "QB 45".
# =====================================================================
function Passo0($deal,[double]$punto,[int]$barSec,[double]$deposito,[int]$cap){
  $r = [pscustomobject]@{
    Stato="NON MISURATO"; N=-1; Prima="NON MISURATA"; Ultima="NON MISURATA"; Anomalie=0
    TakeNetMed=-1.0; TakeNetMedia=-1.0; PerdMed=-1.0
    DurMed=-1.0; DurMedia=-1.0; Pegg=99.9; PeggData="n/d"
    GiorniOp=-1; MaxGiorno=-1; GiorniAlCap=-1; Sedute=-1; OpSeduta=-1.0
  }
  if($null -eq $deal -or @($deal).Count -eq 0){ $r.Stato = "NON MISURATO (nessun deal letto dal report)"; return $r }
  $ordinati = @($deal | Sort-Object Ora)
  $apertoOra = $null; $apertoPrezzo = $null; $apertoNetto = 0.0; $apertoVol = $null
  $take = New-Object System.Collections.ArrayList
  $perd = New-Object System.Collections.ArrayList
  $dur  = New-Object System.Collections.ArrayList
  $perGiorno = @{}
  $opGiorno  = @{}
  $n = 0; $anom = 0; $illegN = 0; $prima = $null; $ultima = $null
  foreach($d in $ordinati){
    if($d.Illeggibile){ $illegN++ }
    if($d.Dir -eq "in"){
      if($null -ne $apertoOra){ $anom++ }      # due 'in' di fila: una posizione alla volta violata
      $apertoOra = $d.Ora; $apertoPrezzo = $d.Prezzo; $apertoNetto = [double]$d.Netto; $apertoVol = $d.Volume
      if($null -eq $prima){ $prima = $d.Ora }
      $gi = $d.Ora.ToString("yyyy.MM.dd",$INV)
      if($opGiorno.ContainsKey($gi)){ $opGiorno[$gi] = [int]$opGiorno[$gi] + 1 } else { $opGiorno[$gi] = 1 }
      continue
    }
    if($d.Dir -eq "out"){
      if($null -eq $apertoOra){ $anom++; continue }   # 'out' senza 'in'
      #  volume diverso = PARZIALE, e con InpTP1Pct=0 non deve esistere.
      if($null -ne $apertoVol -and $null -ne $d.Volume -and
         [math]::Abs([double]$apertoVol - [double]$d.Volume) -gt 0.0001){ $anom++ }
      $n++
      $ultima = $d.Ora
      $netto = $apertoNetto + [double]$d.Netto
      if($null -ne $apertoPrezzo -and $null -ne $d.Prezzo -and $punto -gt 0){
        $pti = [math]::Abs([double]$d.Prezzo - [double]$apertoPrezzo) / $punto
        if($netto -gt 0){ [void]$take.Add($pti) } else { [void]$perd.Add($pti) }
      }
      if($barSec -gt 0){
        [void]$dur.Add( ((New-TimeSpan -Start $apertoOra -End $d.Ora).TotalSeconds) / $barSec )
      }
      $g = $d.Ora.ToString("yyyy.MM.dd",$INV)
      if($perGiorno.ContainsKey($g)){ $perGiorno[$g] = [double]$perGiorno[$g] + $netto }
      else { $perGiorno[$g] = $netto }
      $apertoOra = $null; $apertoPrezzo = $null; $apertoNetto = 0.0; $apertoVol = $null
    }
  }
  $r.N = $n
  $r.Anomalie = $anom + $illegN
  if($null -ne $prima){ $r.Prima = $prima.ToString("yyyy.MM.dd",$INV) }
  if($null -ne $ultima){ $r.Ultima = $ultima.ToString("yyyy.MM.dd",$INV) }
  #  I NUMERI ILLEGGIBILI VENGONO PRIMA di tutto il resto: se il formato dei
  #  numeri non e' quello che crediamo, NIENTE di questo report si legge --
  #  e in particolare la peggior giornata NON esce "0.00" (vedi LeggiDeal).
  if($illegN -gt 0){
    $r.Stato = "NON AFFIDABILE: " + $illegN + " deal hanno numeri PRESENTI ma NON CONVERTIBILI (profitto/commissione/swap/prezzo). Il formato dei numeri del report NON e' quello atteso (MISURATO: migliaia con lo spazio, decimali col punto). Nessuna misura del PASSO 0 si da', e la PEGGIOR GIORNATA resta n/d invece di 0.00."
    return $r
  }
  if($anom -gt 0){
    $r.Stato = "NON AFFIDABILE: " + $anom + " deal non accoppiati o con volume diverso (una posizione alla volta / niente parziali: non dovrebbe succedere)"
    return $r
  }
  if($n -eq 0){ $r.Stato = "ZERO OPERAZIONI nella finestra"; return $r }
  if(@($take).Count -gt 0){
    $r.TakeNetMed   = (Mediana $take)
    $r.TakeNetMedia = (@($take) | Measure-Object -Average).Average
  }
  if(@($perd).Count -gt 0){ $r.PerdMed = (Mediana $perd) }
  if(@($dur).Count -gt 0){
    $r.DurMed   = (Mediana $dur)
    $r.DurMedia = (@($dur) | Measure-Object -Average).Average
  }
  #  LA FREQUENZA, E IL CAP CHE LA CENSURA (criteri S0b).
  if($opGiorno.Count -gt 0){
    $r.GiorniOp = $opGiorno.Count
    $mx = 0; $alCap = 0
    foreach($k in $opGiorno.Keys){
      $v = [int]$opGiorno[$k]
      if($v -gt $mx){ $mx = $v }
      if($cap -gt 0 -and $v -ge $cap){ $alCap++ }
    }
    $r.MaxGiorno = $mx
    $r.GiorniAlCap = $alCap
  }
  #  SEDUTE: giorni feriali fra la prima e l'ultima operazione.
  #  >>> E' un DERIVATO, non una misura: NON toglie le feste di borsa, e
  #      quindi SOTTOSTIMA le operazioni per seduta. Va scritto cosi' nel
  #      referto, mai spacciato per il numero vero.
  if($null -ne $prima -and $null -ne $ultima){
    $gg = 0
    $cur = $prima.Date
    while($cur -le $ultima.Date){
      if($cur.DayOfWeek -ne [DayOfWeek]::Saturday -and $cur.DayOfWeek -ne [DayOfWeek]::Sunday){ $gg++ }
      $cur = $cur.AddDays(1)
    }
    $r.Sedute = $gg
    if($gg -gt 0){ $r.OpSeduta = [double]$n / [double]$gg }
  }
  if($perGiorno.Count -gt 0 -and $deposito -gt 0){
    $peggio = 0.0; $quando = "n/d"
    foreach($k in $perGiorno.Keys){
      if([double]$perGiorno[$k] -lt $peggio){ $peggio = [double]$perGiorno[$k]; $quando = $k }
    }
    $r.Pegg = ($peggio / $deposito) * 100.0
    $r.PeggData = $quando
  }
  $r.Stato = "MISURATO"
  return $r
}

# =====================================================================
#  IL VERDETTO DEL CANCELLO ZERO S0a. E' una FUNZIONE e non tre righe in
#  mezzo al ciclo, per due motivi: (1) la regola dei criteri par. 3.3 sta
#  in UN posto solo, (2) e' PROVABILE senza aprire MT5 -- e un cancello
#  che non e' mai stato fatto scattare non e' dimostrato.
#  Torna un oggetto, mai una stringa sola: chi chiama ha bisogno anche del
#  lordo e del rapporto per la tabella.
# =====================================================================
function VerdettoS0a([double]$takeNetMed){
  $etich = "  [SPREAD NON MISURATO: " + $SpreadPuntiDich.ToString("0.0",$INV) + " punti indice DICHIARATI, criteri D4]"
  if($takeNetMed -lt 0){
    return [pscustomobject]@{ Lordo=-1.0; Rapporto=-1.0; Verdetto="NON MISURATO (nessun vincente, o prezzi illeggibili)" }
  }
  $lordo = $takeNetMed + $SpreadPuntiDich
  $rap   = $lordo / $SpreadPuntiDich
  $coda  = "take lordo mediano " + $lordo.ToString("0.0",$INV) + " punti indice = " + $rap.ToString("0.00",$INV) + "x lo spread"
  #  LA BANDA DI SOSPENSIONE VIENE PRIMA DEL CONFRONTO, ed e' voluto: un
  #  rapporto 3,01x non e' "superato", e' "non lo sappiamo" -- perche' la
  #  soglia poggia su uno spread NON MISURATO (criteri D4). Dare un
  #  verdetto secco su un numero dentro l'incertezza del suo metro e' il
  #  modo piu' elegante di sbagliare.
  if([math]::Abs($rap - $S0aMult) -le $S0aBanda){
    return [pscustomobject]@{ Lordo=$lordo; Rapporto=$rap; Verdetto=("SOSPESO -- " + $coda + ", cioe' DENTRO la banda " +
      ($S0aMult-$S0aBanda).ToString("0.0",$INV) + "-" + ($S0aMult+$S0aBanda).ToString("0.0",$INV) +
      "x: il verdetto NON si da', si misura lo spread e si rilegge (criteri D4)." + $etich) }
  }
  if($rap -ge $S0aMult){
    return [pscustomobject]@{ Lordo=$lordo; Rapporto=$rap; Verdetto=("SUPERATO -- " + $coda + " (soglia " + $S0aMult.ToString("0.0",$INV) + "x)." + $etich) }
  }
  return [pscustomobject]@{ Lordo=$lordo; Rapporto=$rap; Verdetto=("FALLITO -- " + $coda + ", sotto la soglia " + $S0aMult.ToString("0.0",$INV) + "x." + $etich) }
}

# =====================================================================
#  IL LETTORE DELL'AUTOTEST -- gate A0 (criteri par. 3.1)
#
#  L'EA stampa in OnInit sette blocchi [ATREXH][AUTOTEST] e chiude con
#  "SETTE BLOCCHI SU SETTE" oppure "DIVERGE". Quelle righe finiscono nel
#  log dell'AGENTE del tester, e MT5 lo mette in posti diversi a seconda
#  della versione e dell'installazione: si cercano TUTTI, e si guarda solo
#  quello che e' stato scritto DOPO l'avvio della passata (checklist 23).
#
#  >>> TRE STATI, e il terzo NON e' un verde:
#      SUPERATO   -> "SETTE BLOCCHI SU SETTE"
#      DIVERGE    -> si ferma TUTTO il round
#      NON LETTO  -> si prosegue, ma i numeri escono NON CONVALIDATI.
#      Non aver trovato il log NON e' aver letto un autotest riuscito
#      (checklist 28-bis: il verde per assenza).
#
#  >>> E legge anche la riga che l'EA stampa da solo quando una variante
#      e' accesa: se c'e', quella cella NON e' la cella AUTORE.
# =====================================================================
function LeggiAutotest([datetime]$dopo){
  $r = [pscustomobject]@{ Stato="NON LETTO"; Righe=@(); File="n/d"; Variante=$false }
  $radici = New-Object System.Collections.ArrayList
  foreach($rad in @((Join-Path $DataFolder "Tester"),
                    (Join-Path $DataFolder "MQL5\Logs"),
                    (Join-Path $DataFolder "logs"),
                    (Join-Path $TermRoot "Tester"),
                    (Join-Path $InstDir "Tester"))){
    if([string]::IsNullOrEmpty($rad)){ continue }
    if(Test-Path -LiteralPath $rad){ [void]$radici.Add($rad) }
  }
  $trovate = New-Object System.Collections.ArrayList
  foreach($rad in $radici){
    $files = @(Get-ChildItem -LiteralPath $rad -Recurse -File -Filter "*.log" -ErrorAction SilentlyContinue |
               Where-Object { $_.LastWriteTime -ge $dopo } | Sort-Object LastWriteTime -Descending | Select-Object -First 40)
    foreach($f in $files){
      $t = TestoDi $f.FullName '\[ATREXH\]'
      if($t -eq ""){ continue }
      if($t -notmatch '\[ATREXH\]\[AUTOTEST\]'){
        if($t -match 'ATTENZIONE: almeno una variante'){ $r.Variante = $true }
        continue
      }
      foreach($riga in @($t -split "\r?\n")){
        if($riga -match '\[ATREXH\]\[AUTOTEST\]'){ [void]$trovate.Add($riga.Trim()) }
        if($riga -match 'ATTENZIONE: almeno una variante'){ $r.Variante = $true }
      }
      if($r.File -eq "n/d"){ $r.File = $f.FullName }
    }
    if($trovate.Count -gt 0){ break }
  }
  $r.Righe = @($trovate | Select-Object -Unique)
  if($r.Righe.Count -eq 0){
    $r.Stato = "NON LETTO (nessuna riga [ATREXH][AUTOTEST] nei log scritti dopo l'avvio; cercato in: " + (($radici) -join " ; ") + ")"
    return $r
  }
  $tutto = ($r.Righe -join " ")
  if($tutto -match 'DIVERGE'){ $r.Stato = "DIVERGE"; return $r }
  if($tutto -match 'SETTE BLOCCHI SU SETTE'){ $r.Stato = "SUPERATO"; return $r }
  $r.Stato = "NON LETTO (righe trovate, ma nessun esito riconoscibile)"
  return $r
}

# =====================================================================
#  LA LISTA DEI LAVORI, dopo i filtri -SoloSimbolo / -SoloCella
#
#  >>> CHECKLIST 65: -SoloSimbolo si splitta su '[,\s]+', mai su ','. In
#      argument mode 'D30EUR,U30USD' senza apici diventa un ARRAY, e il
#      binder [string] lo unisce con uno SPAZIO: chi splitta su ',' trova
#      un token solo e il filtro non corrisponde a niente.
#  >>> CHECKLIST 68: se dopo i filtri non resta NESSUNA cella, non e'
#      "zero problemi": e' IL SELETTORE CHE NON HA CORRISPOSTO A NULLA,
#      cioe' il refuso piu' comune che esista. Ha un esito suo (exit 1).
# =====================================================================
$Lavori = @($CELLE)
if($SoloSimbolo -ne ""){
  $ss = @(($SoloSimbolo.ToUpper() -split '[,\s]+') | Where-Object { $_ -ne "" })
  $idValidi = @($SIMBOLI | ForEach-Object { $_.Sym })
  $ignoti   = @($ss | Where-Object { $idValidi -notcontains $_ })
  if($ignoti.Count -gt 0){
    Write-Host ("!!! -SoloSimbolo contiene simboli che non esistono in R109: " + ($ignoti -join ", ")) -ForegroundColor Red
    Write-Host ("    Validi: " + ($idValidi -join ", ") + ". Elenchi FRA APICI: -SoloSimbolo 'D30EUR,U30USD'") -ForegroundColor Yellow
    exit 1
  }
  $Lavori = @($Lavori | Where-Object { $ss -contains $_.Sym })
}
if($SoloCella -ne ""){
  $sc = @($Lavori | Where-Object { $_.Prova -eq $SoloCella })
  if($sc.Count -eq 0){
    Write-Host ("!!! -SoloCella " + $SoloCella + " non e' nella lista (dopo -SoloSimbolo). Nomi validi:") -ForegroundColor Red
    foreach($c in $CELLE){ Write-Host ("      " + $c.Prova + "   [" + $c.Sym + " " + $c.Lato + "]") -ForegroundColor Yellow }
    exit 1
  }
  $Lavori = @($Lavori | Where-Object { $_.Prova -eq $SoloCella })
}
$SymAttivi = @($Lavori | ForEach-Object { $_.Sym } | Sort-Object -Unique)
$SymLavoro = @($SIMBOLI | Where-Object { $SymAttivi -contains $_.Sym })
if($Lavori.Count -eq 0){ $SelettoreAVuoto = $true }

#--- il conto delle passate, calcolato DALLA LISTA e non scritto a memoria
#    (checklist 40-bis): 1 collaudo + 2 per cella (singola + gemelle).
$PassateAttese = 0
if($Lavori.Count -gt 0){ $PassateAttese = 1 + ($Lavori.Count * 2) }

Write-Host ""
Write-Host "#####################################################################" -ForegroundColor Cyan
Write-Host "#  R109 - ATR EXHAUSTION & VOLUME SPIKE: la PRIMA misura in assoluto #" -ForegroundColor Cyan
Write-Host "#  D30EUR + U30USD + NASUSD, M15, LONG e SHORT SEPARATI.             #" -ForegroundColor Cyan
Write-Host "#  L'EA NON E' MAI STATO COMPILATO: questa e' la sua prima F7.       #" -ForegroundColor Cyan
Write-Host "#####################################################################" -ForegroundColor Cyan
Dico ("pin      : " + $Pin)
Dico ("cartella : " + $Work)

if($SelettoreAVuoto){
  Write-Host ""
  Write-Host "#####################################################################" -ForegroundColor Red
  Write-Host "#  IL SELETTORE NON HA CORRISPOSTO A NESSUNA CELLA.                 #" -ForegroundColor Red
  Write-Host "#####################################################################" -ForegroundColor Red
  Write-Host ("  -SoloSimbolo = '" + $SoloSimbolo + "'") -ForegroundColor Yellow
  Write-Host ("  -SoloCella   = '" + $SoloCella + "'") -ForegroundColor Yellow
  Write-Host  "  Non ho niente da fare, e questo NON e' 'tutto a posto': e' il refuso" -ForegroundColor Yellow
  Write-Host  "  piu' comune che esista (un nome storto nel selettore). Le sei celle:" -ForegroundColor Yellow
  foreach($c in $CELLE){ Write-Host ("      " + $c.Sym.PadRight(7) + " " + $c.Lato.PadRight(6) + " " + $c.Prova) -ForegroundColor Yellow }
  Write-Host ""
  Write-Host "ESITO: SELETTORE A VUOTO -- nessuna cella selezionata, nessun artefatto prodotto." -ForegroundColor Red
  exit 1
}

Titolo "NUMERI ATTESI (dichiarati PRIMA della corsa)"
#  >>> L'ELENCO CHE SI STAMPA E' QUELLO CHE GIRA, non un altro (checklist 70).
#      $SymAttivi nasce da Sort-Object -Unique, che ORDINA: usarlo qui
#      stampava (D30EUR, NASUSD, U30USD) mentre la catena, il gate della
#      stella, la tabella dei tick e TUTTE le tabelle del referto escono
#      nell'ordine di $SymLavoro (D30EUR, U30USD, NASUSD, l'ordine del
#      dossier). Due ordini diversi nella STESSA corsa sono un falso allarme
#      che costa un giro: si stampa l'ordine REALE, e lo si dichiara.
$SymStampa = @($SymLavoro | ForEach-Object { $_.Sym })
Write-Host ("    simboli ......................  " + $SymLavoro.Count + "   (" + ($SymStampa -join ", ") + ")") -ForegroundColor White
Write-Host  "        >>> e' l'ORDINE IN CUI GIRANO (quello del dossier), ed e' lo stesso" -ForegroundColor DarkGray
Write-Host  "            ordine di TUTTE le tabelle del referto. NON e' l'ordine alfabetico." -ForegroundColor DarkGray
Write-Host ("    celle ........................  " + $Lavori.Count + "   (long: " + @($Lavori | Where-Object { $_.Lato -eq "LONG" }).Count + " | short: " + @($Lavori | Where-Object { $_.Lato -eq "SHORT" }).Count + ")") -ForegroundColor White
Write-Host ("    passate ......................  " + $PassateAttese + "   (1 collaudo autotest + 2 per cella: singola + gemelle)") -ForegroundColor White
Write-Host ("    righe vive per file prova ....  " + $RigheAtte + "   (42 input del sorgente meno InpNewsCurrencies)") -ForegroundColor White
Write-Host ("    righe per CSV di ottimizz. ...  " + $CelleAttese + "   (le due gemelle di controllo)") -ForegroundColor White
Write-Host ""
if($ScreenOhlcM15){
  Write-Host ("    FINESTRA : " + $DataDa + " -> " + $DataA + "   modello 1 (OHLC M1)   <<< -ScreenOhlcM15 ACCESO") -ForegroundColor Yellow
  Write-Host  "               >>> E' UNO SCREEN. OGNI RIGA DI QUESTO GIRO ESCE MARCATA" -ForegroundColor Yellow
  Write-Host  "                   'NON GIUDICABILE'. Su M15 l'OHLC inganna, ed e' MISURATO" -ForegroundColor Yellow
  Write-Host  "                   in casa (REGISTRO_TEST.md par.2). E qui morde PIU' del" -ForegroundColor Yellow
  Write-Host  "                   solito: l'ingresso nasce da un ESTREMO DI BARRA e lo stop" -ForegroundColor Yellow
  Write-Host  "                   sta a un tick dal minimo. Nessun cancello si applica." -ForegroundColor Yellow
} else {
  Write-Host ("    FINESTRA : " + $DataDa + " -> " + $DataA + "   modello 4 (TICK REALI)") -ForegroundColor White
}
Write-Host  "    NIENTE IS/OOS, ed e' la decisione D3: l'Emendamento A dimensiona l'IS" -ForegroundColor White
Write-Host  "    SULLE OPERAZIONI, e le operazioni non le conosciamo ancora. Questo round" -ForegroundColor White
Write-Host  "    CONTA; il taglio si fa dopo, sui conteggi veri." -ForegroundColor White
Write-Host ""
Write-Host  "    IL GATE A0 (AUTOTEST): l'EA stampa sette blocchi in OnInit. Si legge" -ForegroundColor Yellow
Write-Host  "    ESEGUENDO, non compilando. DIVERGE -> si ferma TUTTO. Righe non trovate" -ForegroundColor Yellow
Write-Host  "    -> si prosegue, ma ogni numero esce marcato NON CONVALIDATO." -ForegroundColor Yellow
Write-Host ""
Write-Host  "    IL CANCELLO ZERO S0a (criteri par. 3): take LORDO MEDIANO dei vincenti" -ForegroundColor Yellow
Write-Host ("      >= " + $S0aMult.ToString("0.0",$INV) + " x " + $SpreadPuntiDich.ToString("0.0",$INV) +
            " punti indice = " + ($S0aMult*$SpreadPuntiDich).ToString("0.0",$INV) + " punti indice.   [SPREAD NON MISURATO]") -ForegroundColor Yellow
Write-Host  "      Lo spread di BCM sugli indici NON e' misurato in repo: 2,0 punti indice" -ForegroundColor Yellow
Write-Host  "      e' il lato ALTO della forchetta 1-2 di R98_CRITERI.md, cioe' una scelta" -ForegroundColor Yellow
Write-Host  "      PRUDENZIALE DICHIARATA (criteri D4), non una misura." -ForegroundColor Yellow
Write-Host ""
Write-Host  "    IL MERITO E' SOSPESO PER COSTRUZIONE (criteri par. 7): 23 mesi, UN SOLO" -ForegroundColor Yellow
Write-Host  "    REGIME (rialzista) e un motore CONTROTENDENZA. Il RISCHIO invece si legge" -ForegroundColor Yellow
Write-Host  "    tutto: DD, peggior giornata, perdita mediana, concentrazione giornaliera." -ForegroundColor Yellow
Write-Host ""
Write-Host  "    >>> QUESTO ROUND NON PROMUOVE NIENTE E NON TOCCA IL FORWARD (G5)." -ForegroundColor Yellow
Write-Host  "        E NON OTTIMIZZA NIENTE: un solo asse Y, ed e' InpMagic." -ForegroundColor Yellow

if($Pin -eq ""){
  Write-Host ""
  Write-Host "!!! MANCA -Pin. Questa riga gira SOLO su un commit congelato." -ForegroundColor Red
  Write-Host "    Rilancia col blocco intero, che passa -Pin <hash>." -ForegroundColor Yellow
  exit 1
}

try{

# =====================================================================
#  0. MT5 E METAEDITOR CHIUSI. Prima di qualunque altra cosa.
#     MT5 aperto = il tester non parte e escono ZERO CSV (checklist 7).
#     MetaEditor e' SINGLE-INSTANCE: se ne gira gia' una copia, il nostro
#     metaeditor64.exe /compile torna SUBITO senza aver compilato, e la
#     fase 2 dichiarerebbe "COMPILAZIONE FALLITA" su un sorgente sano
#     (checklist 39). Su QUESTO round sarebbe il danno peggiore: e' la
#     prima compilazione dell'EA, e un falso "non compila" manderebbe a
#     cercare errori che non esistono.
# =====================================================================
$vivi = @(Get-Process -Name "terminal64","metaeditor64" -ErrorAction SilentlyContinue)
if($vivi.Count -gt 0){
  Write-Host ""
  Write-Host ("!!! APERTO: " + (($vivi | ForEach-Object { $_.ProcessName } | Sort-Object -Unique) -join ", ")) -ForegroundColor Red
  Write-Host "    Non parto: col terminale aperto il tester non gira (zero CSV), e con" -ForegroundColor Red
  Write-Host "    MetaEditor aperto la compilazione torna subito senza compilare -- e" -ForegroundColor Red
  Write-Host "    questa e' LA PRIMA COMPILAZIONE di questo EA: un falso negativo qui" -ForegroundColor Red
  Write-Host "    manderebbe a cercare errori che non esistono." -ForegroundColor Red
  Write-Host "    Chiudi MetaTrader E MetaEditor (tutte le istanze) e rilancia." -ForegroundColor Yellow
  #  DICHIARATO: questo exit sta DENTRO il try e SALTA la raccolta. Qui e'
  #  accettabile ed e' una scelta: siamo a due secondi dal lancio, non e'
  #  stato prodotto NIENTE, e il messaggio a schermo E' il referto.
  exit 1
}

New-Item -ItemType Directory -Force -Path $Work,$Prove,$Logs,$SrcDir,$Risultati,$Sosta | Out-Null

# =====================================================================
#  0-BIS. LA FIRMA DEI CRITERI. Si LEGGE nell'artefatto, non si ricorda.
# =====================================================================
Titolo "0-BIS. LA FIRMA DEI CRITERI"
$critFile = Join-Path $Work "R109_CRITERI.md"
$daFirmare = $true
$critScaricati = $true
try{
  Scarica ("$RawPin/backtest_pipeline/risultati_archivio/R109_CRITERI.md") $critFile 'R109'
  #  >>> LA FIRMA SI LEGGE SU UNA RIGA DI STATO DEDICATA, NON CERCANDO UNA
  #      PAROLA CHE COMPARE ANCHE NELLA PROSA CHE LA SPIEGA (25/08, stessa
  #      classe del punto 77 della checklist). Il file dei criteri contiene
  #      DUE righe che PARLANO del lucchetto -- il paragrafo che spiega cos'e'
  #      il "[DA FIRMARE]" e il titolo del par. 10 -- e un Select-String secco
  #      le trova anche quando Claudio HA firmato in testa: la corsa vera
  #      uscirebbe 'exit 2' su criteri firmati, e sarebbe un giro sprecato.
  #      Ordine: (1) la riga di STATO se c'e'; (2) la FIRMA in testa;
  #      (3) il vecchio [DA FIRMARE], e in quel caso lo si DICHIARA ambiguo.
  $critTesto = (Get-Content -LiteralPath $critFile -Raw)
  $mSt = [regex]::Match($critTesto,'(?im)^\s*(?:<!--\s*)?STATO[_ ]CRITERI[_ ]R109\s*:\s*(FIRMATI|DA FIRMARE)')
  $mFi = [regex]::Match($critTesto,'(?im)^>?\s*.{0,8}\*\*FIRMA:\s*"?FIRMO')
  $haLucchetto = (Select-String -LiteralPath $critFile -SimpleMatch -Pattern '[DA FIRMARE]' -Quiet)
  if($mSt.Success){
    $daFirmare = ($mSt.Groups[1].Value.ToUpper() -ne "FIRMATI")
    if($daFirmare){ $Firma = "NON FIRMATI (riga di STATO: DA FIRMARE)" }
    else          { $Firma = "FIRMATI (riga di STATO: FIRMATI)" }
  } elseif($mFi.Success){
    $daFirmare = $false
    $Firma = "FIRMATI (trovata la FIRMA in testa al file)"
    if($haLucchetto){
      [void]$Rilievi.Add("I CRITERI SONO FIRMATI (la firma e' in testa al file) MA il testo contiene ancora la stringa '[DA FIRMARE]' nella prosa che la spiega. Il gate ha usato la FIRMA, che e' il dato piu' forte. Per togliere l'ambiguita' basta una riga in testa al file: 'STATO_CRITERI_R109: FIRMATI'.")
    }
  } else {
    $daFirmare = $haLucchetto
    if($daFirmare){ $Firma = "NON FIRMATI (il file porta ancora [DA FIRMARE], e non c'e' ne' riga di STATO ne' firma in testa)" }
    else          { $Firma = "FIRMATI (nessun [DA FIRMARE] nel file)" }
  }
}catch{
  $critScaricati = $false
  $Firma = "NON LETTI (" + $_.Exception.Message + ")"
  $daFirmare = $true
}
if($Firma -like "FIRMATI*"){ Dico ("criteri: " + $Firma) "Green" } else { Dico ("criteri: " + $Firma) "Yellow" }
#  >>> "NON LETTI" NON E' "NON FIRMATI", ED E' UNA DIAGNOSI DIVERSA.
#      Senza questo if, un pin sbagliato (o un file non ancora pushato, o la
#      cache di raw) usciva dal riquadro rosso "I CRITERI NON SONO FIRMATI",
#      che manda Claudio a firmare otto decisioni mentre il problema e' il
#      PIN. Un messaggio che dichiara una causa non misurata e' della stessa
#      famiglia del referto stantio: si ferma qui, con la causa vera, e
#      passa dal catch generale -> Fatale -> RACCOLTA (che scrive il referto).
if(-not $critScaricati){
  throw ("R109_CRITERI.md NON SI E' SCARICATO al pin '" + $Pin + "' -- " + $Firma +
         " >>> NON e' 'i criteri non sono firmati': e' il FILE che non e' arrivato. Sospetti in ordine: (1) il pin non esiste, o e' un commit che quel file non contiene ancora (ricetta a DUE COMMIT: il primo porta driver+criteri+prove, ed e' QUELLO da pinnare); (2) la cache di raw.githubusercontent (~5 minuti dopo il push); (3) la rete. Controlla il PIN prima di firmare qualunque cosa.")
}
if($daFirmare -and -not $SoloControllo -and -not $CriteriFirmati){
  Write-Host ""
  Write-Host "#####################################################################" -ForegroundColor Red
  Write-Host "#  NON PARTO: I CRITERI DI R109 NON SONO FIRMATI.                   #" -ForegroundColor Red
  Write-Host "#####################################################################" -ForegroundColor Red
  Write-Host "  R109_CRITERI.md porta ancora [DA FIRMARE]. Sono OTTO decisioni (par. 10):" -ForegroundColor Yellow
  Write-Host "   D1  solo la cella AUTORE, nessuna griglia e nessuna ablazione?" -ForegroundColor Yellow
  Write-Host "   D2  la profondita' dei TICK di D30EUR e NASUSD si MISURA PRIMA?" -ForegroundColor Yellow
  Write-Host "   D3  niente IS/OOS: R109 conta, il taglio si fa dopo?" -ForegroundColor Yellow
  Write-Host "   D4  lo spread di S0a e' 2,0 punti indice DICHIARATI?" -ForegroundColor Yellow
  Write-Host "   D5  autotest illeggibile = si prosegue MARCATI NON CONVALIDATI?" -ForegroundColor Yellow
  Write-Host "   D6  se S0a fallisce su una cella, le altre proseguono?" -ForegroundColor Yellow
  Write-Host "   D7  cap giornaliero 3 PER CELLA, e la somma dei lati non e' 'entrambi'?" -ForegroundColor Yellow
  Write-Host "   D8  modello 4 (tick reali), e lo screen OHLC non produce verdetti?" -ForegroundColor Yellow
  Write-Host "" -ForegroundColor Yellow
  Write-Host "  COSA PUOI FARE ADESSO, in ordine:" -ForegroundColor Yellow
  Write-Host "   1. il GIRO A VUOTO gira lo stesso: rilancia con -SoloControllo." -ForegroundColor Yellow
  Write-Host "      Non apre MT5, non produce nessun numero, e COMPILA l'EA -- che su" -ForegroundColor Yellow
  Write-Host "      questo round e' la cosa piu' utile che possa fare." -ForegroundColor Yellow
  Write-Host "   2. leggi R109_CRITERI.md par. 10 e rispondi alle otto decisioni." -ForegroundColor Yellow
  Write-Host "   3. quando hai firmato: si toglie il [DA FIRMARE] dal file, oppure" -ForegroundColor Yellow
  Write-Host "      si rilancia questa riga aggiungendo  -CriteriFirmati" -ForegroundColor Yellow
  Write-Host ""
  exit 2
}
if($daFirmare -and $CriteriFirmati){
  [void]$Rilievi.Add("I criteri portano ancora [DA FIRMARE] nel file, ma la corsa e' partita con -CriteriFirmati: la firma e' quella data in riga da Claudio. VA SCRITTO NEL REFERTO DEL ROUND.")
  Dico "corsa autorizzata da -CriteriFirmati (il file porta ancora [DA FIRMARE])" "Yellow"
}

# =====================================================================
#  1. SCARICO AL PIN E GATE SUGLI ARTEFATTI
# =====================================================================
Titolo "1. SCARICO AL PIN"
foreach($c in $Lavori){
  Scarica ("$RawPin/backtest_pipeline/prove/" + $c.Prova) (Join-Path $Prove $c.Prova) '@SIMBOLO'
}
foreach($c in $Lavori){
  $rv = RigheVive (Join-Path $Prove $c.Prova)
  #  le tre righe @ non sono input: il conto delle righe di INPUT e' quello
  #  che il gate confronta, e il numero e' MISURATO sull'artefatto il
  #  25/08, non scritto a memoria (checklist 40-bis).
  $soloInput = @($rv | Where-Object { $_ -notmatch '^@' })
  if($soloInput.Count -ne $RigheAtte){
    throw ($c.Prova + " ha " + $soloInput.Count + " righe di input invece di " + $RigheAtte + ": artefatto cambiato, mi fermo.")
  }
  $Vive[$c.Prova] = $soloInput
}
Dico ($Lavori.Count.ToString() + " file prova scaricati al pin, " + $RigheAtte + " righe di input ciascuno") "Green"

# --- 1a. IL SORGENTE, IL GATE DI VERSIONE E I CINQUE PUNTI DEL REVISORE.
#     Vengono PRIMA del gate del porting, perche' e' il sorgente a dettare
#     i default. E i cinque controlli sul testo non sono decorazione: sono
#     ATREXHAUST_TESI.md par. 8 ("dove guarda per primo un revisore")
#     trasformato in if. Su un motore mai compilato, sono l'unica cosa che
#     possiamo dire del codice PRIMA di vederlo girare.
$srcMq5 = Join-Path $SrcDir ($Ea + ".mq5")
Scarica ("$RawPin/mql5/Experts/" + $Ea + ".mq5") $srcMq5 'OPTFRAME'
$txtSrc = Get-Content -LiteralPath $srcMq5 -Raw
$mv = [regex]::Match($txtSrc,'#property\s+version\s+"([^"]+)"')
if(-not $mv.Success){ throw ($Ea + ".mq5 scaricato senza #property version: non e' il sorgente che credo.") }
if($mv.Groups[1].Value -ne $EaVer){
  throw ($Ea + ".mq5 dichiara version '" + $mv.Groups[1].Value + "' invece di '" + $EaVer +
         "'. O la cache di raw.githubusercontent serve una copia vecchia, o il pin e' sbagliato, o il motore E' CAMBIATO -- e in quel caso i default dei file prova non sono piu' quelli, e va rifatto il ragionamento, non il gate.")
}
#  1. il pivot NON deve ridipingere: la barra candidata e' la [1+InpPivotRight]
if($txtSrc -notmatch 'int\s+c\s*=\s*1\s*\+\s*InpPivotRight\s*;'){
  throw ($Ea + ".mq5: in AggiornaPivot() non trovo 'int c = 1 + InpPivotRight;'. Se qualcuno lo ha abbassato a InpPivotRight, il pivot RIDIPINGE e da li' in poi ogni backtest e' finto (tesi par. 8.1). Mi fermo.")
}
#  2. il volume si legge dallo SHIFT 1: la barra in formazione non entra
if($txtSrc -notmatch 'CopyTickVolume\(\s*_Symbol\s*,\s*gTF\s*,\s*1\s*,'){
  throw ($Ea + ".mq5: LeggiVolume() non parte da CopyTickVolume(...,1,...). Se partisse da 0, la barra in FORMAZIONE entrerebbe nella media del volume (tesi par. 8.4). Mi fermo.")
}
#  3. niente return(true) di cortesia sul dato mancante: e' il MOTORE
if($txtSrc -notmatch 'VolumeSpike_Calc[\s\S]{0,400}?if\(media<=0\s*\|\|\s*mult<=0\)\s*return\(false\);'){
  throw ($Ea + ".mq5: VolumeSpike_Calc non blocca a dato mancante. Un filtro senza dati non deve inventare un veto, ma un MOTORE senza dati NON ESISTE (tesi par. 8.2). Mi fermo.")
}
#  4. il volume NON deve essere spegnibile da un input
$spegni = @([regex]::Matches($txtSrc,'(?m)^s?input\s+(?:static\s+)?\w+\s+(Inp\w*(?:UseVolume|VolumeOn|VolFiltro|UseVolFilter)\w*)\s*='))
if($spegni.Count -gt 0){
  throw ($Ea + ".mq5 ha un input che spegne il volume (" + (($spegni | ForEach-Object { $_.Groups[1].Value }) -join ", ") + "). Il picco di volume E' la tesi di questo candidato: un EA che potesse girare senza sarebbe UN ALTRO MOTORE, e la misura sarebbe irripetibile. Mi fermo.")
}
#  5. le tre condizioni devono stare in AND dentro SegnaleLato_Calc
if($txtSrc -notmatch 'SegnaleLato_Calc[\s\S]{0,900}?VolumeSpike_Calc\(vol,volMedia,volMult\)\)\s*return\(false\);'){
  throw ($Ea + ".mq5: SegnaleLato_Calc non chiama VolumeSpike_Calc in AND con le altre due condizioni (tesi par. 8.2). Mi fermo.")
}
foreach($inp in @("InpAllowLong","InpAllowShort","InpVolSpikeMult","InpVolSmaBars","InpMaxTradesPerDay","InpAutoTest","InpVerbose")){
  if($txtSrc -notmatch $inp){ throw ($Ea + ".mq5 non ha " + $inp + ": un pin su un input inesistente e' un pin INERTE, e MT5 non se ne lamenta (checklist 52).") }
}
Dico ($Ea + ".mq5 al pin, version " + $mv.Groups[1].Value + " -- i CINQUE PUNTI DEL REVISORE passano (pivot non ridipinge, volume da shift 1, volume costitutivo e non spegnibile, tre condizioni in AND)") "Green"

# --- 1b. IL GATE DEL PORTING. E' l'analogo dell'ANTENATO di R108
#     (checklist 72) su un motore che di antenati non ne ha: il gate della
#     stella confronta le due celle di un simbolo FRA LORO, e per
#     costruzione NON PUO' VEDERE una corruzione applicata a ENTRAMBE.
#     Qui l'antenato E' IL SORGENTE.
$DefSrc = DefaultDalSorgente $txtSrc
if($DefSrc.Count -lt 40){
  throw ("dal sorgente ho estratto solo " + $DefSrc.Count + " input: il gate del porting non puo' funzionare su una lettura monca. Mi fermo.")
}
#  I SOLI delta ammessi fra un file prova e i default del sorgente:
#   - InpAllowLong / InpAllowShort : E' L'ASSE DEL ROUND (i due lati separati)
#   - InpMagic                     : identita' del lancio (il default 774401 e' VIETATO)
#   - InpComment                   : usato SOLO per comporre il commento dell'ordine
#   - InpNewsCurrencies            : riga TOLTA (pin di stringa vuoto = MT5 lo ignora)
$DeltaAmmessi = @("InpAllowLong","InpAllowShort","InpMagic","InpComment")
foreach($c in $Lavori){
  $vis = @{}
  $div = New-Object System.Collections.ArrayList
  foreach($r in $Vive[$c.Prova]){
    $nome = NomeDi $r
    $val  = ValoreDi $r
    $vis[$nome] = $true
    if($DeltaAmmessi -contains $nome){ continue }
    if(-not $DefSrc.ContainsKey($nome)){ [void]$div.Add($nome + " (non e' un input del sorgente)"); continue }
    if(-not (UgualeVal $val ([string]$DefSrc[$nome]))){
      [void]$div.Add($nome + " = " + $val + " invece del default " + $DefSrc[$nome])
    }
  }
  $manca = @($DefSrc.Keys | Where-Object { -not $vis.ContainsKey($_) -and $_ -ne "InpNewsCurrencies" })
  if($div.Count -gt 0 -or $manca.Count -gt 0){
    throw ($c.Prova + " NON e' la cella AUTORE. Scostamenti dai default del sorgente: [" +
           ($div -join " ; ") + "]. Input del sorgente non pinnati: [" + ($manca -join ", ") +
           "]. R109 misura il PORTING NUDO ai default dell'autore (criteri D1): un valore diverso qui vorrebbe dire misurare un'ALTRA cella e chiamarla AUTORE.")
  }
}
Dico ("gate del PORTING: tutti i valori dei " + $Lavori.Count + " file prova coincidono coi DEFAULT DEL SORGENTE (delta ammessi: " + ($DeltaAmmessi -join ", ") + " + InpNewsCurrencies tolta)") "Green"

# --- 1c. IL GATE DELLA STELLA. La cella short si confronta con la cella
#     long dello stesso simbolo. Non basta contare le righe diverse: si
#     pretende QUALI righe, e SOLO quelle. Due righe SBAGLIATE darebbero lo
#     stesso conteggio e il round misurerebbe due cose insieme.
#     >>> Gira solo sui simboli di cui sono presenti ENTRAMBE le celle: con
#         -SoloCella ne gira una sola, e il gate del porting resta comunque
#         a coprire tutti i 41 input.
foreach($s in $SymLavoro){
  $la = @($Lavori | Where-Object { $_.Sym -eq $s.Sym -and $_.Lato -eq "LONG" })
  $sh = @($Lavori | Where-Object { $_.Sym -eq $s.Sym -and $_.Lato -eq "SHORT" })
  if($la.Count -ne 1 -or $sh.Count -ne 1){
    [void]$Rilievi.Add("gate della STELLA saltato su " + $s.Sym + ": in questo giro c'e' una cella sola (long=" + $la.Count + ", short=" + $sh.Count + "). Il gate del PORTING copre comunque tutti i " + $RigheAtte + " input.")
    continue
  }
  $a = $Vive[$la[0].Prova]
  $b = $Vive[$sh[0].Prova]
  if($a.Count -ne $b.Count){ throw ($sh[0].Prova + ": " + $b.Count + " righe contro " + $a.Count + " della cella long. Non sono confrontabili.") }
  $d = New-Object System.Collections.ArrayList
  for($i=0;$i -lt $a.Count;$i++){ if($a[$i] -ne $b[$i]){ [void]$d.Add((NomeDi $a[$i])) } }
  $attese = @("InpAllowLong","InpAllowShort","InpMagic","InpComment")
  $manca  = @($attese | Where-Object { $d -notcontains $_ })
  $extra  = @($d      | Where-Object { $attese -notcontains $_ })
  if($manca.Count -gt 0 -or $extra.Count -gt 0){
    throw ($sh[0].Prova + " contro " + $la[0].Prova + ": differiscono su [" + ($d -join ", ") +
           "] invece che su [" + ($attese -join ", ") + "]. R109 pretende CHE CAMBI SOLO IL LATO: cosi' il numero e' attribuibile al lato e a nient'altro (REGOLA DEI DUE LATI).")
  }
  Dico ("gate della STELLA " + $s.Sym + ": la cella short differisce dalla long SOLO sul lato (+ magic/commento)") "Green"
}

# --- 1d. I VALORI, letti NELL'ARTEFATTO CHE GIRA (checklist 34-bis).
#     Il diff dice CHE cambiano; questo dice CHE COSA valgono: se i file
#     long e short fossero SCAMBIATI, il diff resterebbe verde.
#     >>> OGNI $ DI UNA REGEX MULTILINEA SI SCRIVE \r?$ (checklist 40): i
#         file arrivano da GitHub con CRLF, e senza \r? il match non
#         avviene MAI e il gate accuserebbe un file sano.
$magicVisti = @($CollaudoMagic)
foreach($c in $Lavori){
  $tx = Get-Content -LiteralPath (Join-Path $Prove $c.Prova) -Raw
  foreach($k in $c.Val.Keys){
    $rx = '(?m)^' + $k + '=' + [regex]::Escape($c.Val[$k]) + '\|\|'
    if($tx -notmatch $rx){
      throw ($c.Prova + ": " + $k + " non vale " + $c.Val[$k] +
             ". La cella non e' il lato che credo -- e con i lati SCAMBIATI la tabella uscirebbe perfetta e non risponderebbe alla domanda.")
    }
  }
  #  e mai tutti e due spenti: l'EA rifiuterebbe in OnInit, ma il round
  #  se ne accorgerebbe solo dopo aver lanciato il tester.
  if($tx -match '(?m)^InpAllowLong=false\|\|' -and $tx -match '(?m)^InpAllowShort=false\|\|'){
    throw ($c.Prova + ": InpAllowLong e InpAllowShort sono ENTRAMBI false. L'EA rifiuta di partire (OnInit), e la passata brucerebbe per niente.")
  }
  #  la GEOMETRIA DELLA CELLA AUTORE (criteri par. 6). E' ridondante col
  #  gate del porting, ed e' voluto: queste sono le righe che, se qualcuno
  #  un giorno cambiasse i default del sorgente, cambierebbero il
  #  SIGNIFICATO del round senza che nessun gate differenziale se ne
  #  accorga -- perche' sorgente e file prova si muoverebbero INSIEME.
  foreach($sp in @(@("InpProxMode","0"),@("InpTrigMode","0"),
                   @("InpTP1Pct","0"),@("InpUseTrailAtr","false"),
                   @("InpOneTradePerLevel","false"),@("InpSLBufferPts","0"),
                   @("InpMinSLPts","0"),@("InpUseHourFilter","false"),
                   @("InpUseNewsFilter","false"),@("InpFridayClose","false"),
                   @("InpMaxTradesPerDay","3"),@("InpVolSpikeMult","1.5"),
                   @("InpVolSmaBars","20"),@("InpAtrExhaustMult","2.0"),
                   @("InpTP_RR","2.0"),@("InpRiskPercent","1.0"),
                   @("InpVerbose","true"),@("InpAutoTest","true"))){
    $rx = '(?m)^' + $sp[0] + '=' + [regex]::Escape($sp[1]) + '\|\|'
    if($tx -notmatch $rx){ throw ($c.Prova + ": " + $sp[0] + " non vale " + $sp[1] + " (criteri par. 6). InpVerbose/InpAutoTest in particolare NON sono cosmetica: senza, il gate A0 non ha niente da leggere.") }
  }
  # --- @SIMBOLO / @PERIODO / @DAQUANDO, confrontati e non creduti.
  $m = [regex]::Match($tx,'(?m)^@DAQUANDO\s+([0-9]{4}\.[0-9]{2}\.[0-9]{2})')
  if(-not $m.Success -or $m.Groups[1].Value -ne $DataDa){ throw ($c.Prova + ": @DAQUANDO non e' " + $DataDa) }
  $sm = [regex]::Match($tx,'(?m)^@SIMBOLO\s+(\S+)')
  if(-not $sm.Success -or $sm.Groups[1].Value -ne $c.Sym){ throw ($c.Prova + ": @SIMBOLO non e' " + $c.Sym) }
  $pm = [regex]::Match($tx,'(?m)^@PERIODO\s+(\S+)')
  if(-not $pm.Success -or $pm.Groups[1].Value -ne "M15"){ throw ($c.Prova + ": @PERIODO non e' M15.") }
  #  >>> QUI @PERIODO NON E' UN COMMENTO: l'EA legge gTF = PERIOD_CURRENT,
  #      cioe' il timeframe lo FISSA questa riga. Non c'e' nessun InpTF da
  #      tenere allineato, e proprio per questo la riga e' un gate.
  # --- L'ASSE UNICO.
  $assiY = @([regex]::Matches($tx,'(?m)^(\w+)=[^\r\n]*\|\|\s*[Yy]\s*\r?$') | ForEach-Object { $_.Groups[1].Value })
  if($assiY.Count -ne 1 -or $assiY[0] -ne "InpMagic"){
    throw ($c.Prova + ": gli assi spazzolati sono [" + ($assiY -join ", ") + "] invece del solo InpMagic. R109 NON ottimizza niente: piu' di un asse sarebbe una griglia, cioe' un altro round -- e su un motore mai misurato una griglia e' una PESCA (criteri D1).")
  }
  # --- i magic: il file pinna la coppia gemella (base/base+1); il driver
  #     ricava la singola (base+2).
  $mg = [regex]::Match($tx,'(?m)^InpMagic=(\d+)\|\|(\d+)\|\|1\|\|(\d+)\|\|Y')
  if(-not $mg.Success){ throw ($c.Prova + ": InpMagic non e' nella forma sweep 'v||v||1||v+1||Y'. Senza almeno un asse Y MT5 rispazzola la griglia vecchia (checklist punto 5).") }
  $m0 = [int]$mg.Groups[1].Value; $m1 = [int]$mg.Groups[3].Value
  if($m0 -ne [int]$c.Base){ throw ($c.Prova + ": InpMagic e' " + $m0 + " ma questa cella deve girare su " + $c.Base) }
  if($m1 -ne ($m0+1)){ throw ($c.Prova + ": il gemello e' " + $m1 + " invece di " + ($m0+1)) }
  #  >>> LE PARENTESI NON SONO COSMETICA (trovato ESEGUENDO, 25/08 su R108):
  #      in PowerShell l'operatore VIRGOLA ha precedenza PIU' ALTA del '+',
  #      quindi @($a,$b,$a+2) NON e' una lista di tre numeri: e'
  #      ($a,$b,$a) + (2), cioe' una CONCATENAZIONE che DUPLICA $a. Ogni
  #      espressione dentro un @( ) va fra parentesi.
  foreach($mm in @($m0,$m1,($m0+2))){
    if($magicVisti -contains $mm){ throw ($c.Prova + ": magic " + $mm + " gia' usato da un'altra cella (o dal collaudo). Due lanci con lo stesso magic non sono distinguibili nei file per-trade.") }
    if($MagicVietati -contains $mm){ throw ($c.Prova + ": il magic " + $mm + " e' VIETATO -- e' di una SEDIA VIVA, di un round precedente, oppure e' 774401, il DEFAULT COMPILATO di questo EA. Un magic 774401 vorrebbe dire che il pin non ha morso (checklist 25). Mi fermo.") }
    $magicVisti += $mm
  }
}
Dico ("valori, lato, geometria AUTORE, @PERIODO, asse unico e " + $magicVisti.Count + " magic vergini verificati NEI FILE (774401 e' vietato: e' il default dell'EA)") "Green"

# --- 1e. LA PROFONDITA' DEI TICK. NON e' un gate: e' un RILIEVO
#     OBBLIGATORIO (criteri par. 4.2, decisione D2). Se il file non c'e',
#     lo si DICE -- non lo si nasconde e non si tira a indovinare.
#     >>> E se c'e', se ne guarda anche L'ETA' (checklist 23): chi consuma
#         un artefatto non guarda solo che esista.
foreach($s in $SymLavoro){
  $tk = Join-Path $Work ("misura_tick_" + $s.Sym + ".csv")
  try{
    Scarica ("$RawPin/backtest_pipeline/risultati_archivio/misura_tick/misura_tick_" + $s.Sym + ".csv") $tk ""
    $riga = @(Get-Content -LiteralPath $tk | Where-Object { $_ -match '(?i)TICK' } | Select-Object -First 1)
    if($riga.Count -gt 0){ $s.TickMisurati = ("" + $riga[0]).Trim() }
    else { $s.TickMisurati = "file presente ma senza riga TICK" }
    Copy-Item -LiteralPath $tk -Destination (Join-Path $Sosta ("misura_tick_" + $s.Sym + ".csv")) -Force -ErrorAction SilentlyContinue
    #  L'ETA' DELLA MISURA, non l'eta' del file (checklist 23), ed e' quello
    #  che i criteri par. 4.2 PROMETTONO: "sopra i 30 giorni esce un rilievo
    #  anche se il file c'e'".
    #  >>> DUE TRAPPOLE, misurate sull'artefatto vero il 25/08:
    #      1. il LastWriteTime e' quello del file SCARICATO ADESSO: dice
    #         sempre "oggi" e non misura niente;
    #      2. le date DENTRO il CSV sono l'INIZIO DELLO STORICO (2024.09.26),
    #         NON il giorno in cui la sonda ha girato. Stamparle sotto
    #         l'etichetta "file:" farebbe leggere "questa misura e' del 2024"
    #         su una misura del 2026 -- un falso allarme che costa un giro
    #         (checklist 44).
    #      La data VERA sta SOLO nel referto gemello, riga 'data:'.
    $s.TickData = "DATA DELLA MISURA NON NOTA (il CSV non la contiene)"
    $rf = Join-Path $Work ("REFERTO_MISURA_TICK_" + $s.Sym + ".txt")
    try{
      Scarica ("$RawPin/backtest_pipeline/risultati_archivio/misura_tick/REFERTO_MISURA_TICK_" + $s.Sym + ".txt") $rf ""
      Copy-Item -LiteralPath $rf -Destination (Join-Path $Sosta ("REFERTO_MISURA_TICK_" + $s.Sym + ".txt")) -Force -ErrorAction SilentlyContinue
      $dm = [regex]::Match((Get-Content -LiteralPath $rf -Raw),'(?m)^data:\s*(\d{4}-\d{2}-\d{2})')
      if($dm.Success){
        $dMis = [datetime]::MinValue
        if([datetime]::TryParseExact($dm.Groups[1].Value,"yyyy-MM-dd",$INV,[Globalization.DateTimeStyles]::None,[ref]$dMis)){
          $ggMis = [int]((New-TimeSpan -Start $dMis -End (Get-Date)).TotalDays)
          $s.TickData = "misurata il " + $dm.Groups[1].Value + " (" + $ggMis + " giorni fa)"
          if($ggMis -gt 30){
            [void]$Rilievi.Add("MISURA DEI TICK VECCHIA su " + $s.Sym + ": ha " + $ggMis + " giorni, sopra la soglia di 30 dei criteri par. 4.2. Il file c'e' e si legge, ma dice cosa aveva il broker ALLORA: il verdetto della sonda su questi indici e' 'TICK REALI PARZIALI', e una profondita' parziale puo' muoversi in tutti e due i sensi. E' un RILIEVO, non un gate.")
          }
        } else {
          $s.TickData = "data della misura ILLEGGIBILE nel referto gemello"
        }
      }
    }catch{
      [void]$Rilievi.Add("ETA' DELLA MISURA DEI TICK NON VERIFICATA su " + $s.Sym + ": il CSV c'e', ma il referto gemello REFERTO_MISURA_TICK_" + $s.Sym + ".txt NON e' al pin, e la data della misura sta SOLO li'. Il controllo dei 30 giorni promesso dai criteri par. 4.2 NON e' stato fatto: il numero dei tick va letto senza sapere di quando e'.")
    }
    Dico ("profondita' TICK " + $s.Sym + ": " + $s.TickMisurati) "Green"
  }catch{
    $s.TickMisurati = "NON MISURATA (nessun misura_tick_" + $s.Sym + ".csv al pin)"
    if(-not $ScreenOhlcM15){
      [void]$Rilievi.Add("PROFONDITA' TICK NON MISURATA su " + $s.Sym + ": in tutto il repo esiste una sola misura dei tick sugli indici, ed e' U30USD (67.618.571 tick dal 2024.09.26). Le celle girano a MODELLO 4 e MT5, se i tick reali non ci sono, NON SI FERMA: ripiega e produce numeri PLAUSIBILI E FALSI. Nessuna guardia di questo driver puo' accorgersene. E' la decisione D2 dei criteri: ogni numero a modello 4 su " + $s.Sym + " va letto con questa riserva.")
    }
    Dico ("profondita' TICK " + $s.Sym + ": " + $s.TickMisurati) "Yellow"
  }
}

# =====================================================================
#  2. TERMINALE, CARTELLA DATI, INCLUDE E PULIZIA
# =====================================================================
Titolo "2. TERMINALE E CARTELLA DATI"
$tutti = @(Get-ChildItem "C:\Program Files","C:\Program Files (x86)" -Recurse -Filter "terminal64.exe" -ErrorAction SilentlyContinue)
$cand  = @($tutti | Where-Object { $_.DirectoryName -like "*BCM Markets MT5 Terminal*" -and $_.DirectoryName -notlike "*-V3*" })
if($cand.Count -eq 0){ throw "non trovo il terminale 'BCM Markets MT5 Terminal' (quello NON -V3). Non tiro a indovinare." }
if($cand.Count -gt 1){ throw ("trovati " + $cand.Count + " terminali che corrispondono: ambiguo, mi fermo.") }
$InstDir    = $cand[0].DirectoryName
$Terminal   = Join-Path $InstDir "terminal64.exe"
$MetaEditor = Join-Path $InstDir "metaeditor64.exe"
if(-not (Test-Path -LiteralPath $MetaEditor)){ throw ("manca metaeditor64.exe in " + $InstDir) }
$TermRoot = Join-Path $env:APPDATA "MetaQuotes\Terminal"
$DataFolder = Get-ChildItem $TermRoot -Directory -ErrorAction SilentlyContinue | Where-Object {
    $o = Join-Path $_.FullName "origin.txt"
    (Test-Path $o) -and ((Get-Content $o -Raw).Trim() -ieq $InstDir)
  } | Select-Object -First 1 -ExpandProperty FullName
if(-not $DataFolder){ throw "cartella dati MT5 non trovata (origin.txt non punta a nessuna cartella)." }
$MqlExperts = Join-Path $DataFolder "MQL5\Experts"
$MqlInclude = Join-Path $DataFolder "MQL5\Include"
$MqlFiles   = Join-Path $DataFolder "MQL5\Files"
$CommonFiles = Join-Path $TermRoot "Common\Files"
New-Item -ItemType Directory -Force -Path $MqlExperts,$MqlInclude | Out-Null
#  OGNI PASSO STAMPA IL BERSAGLIO CHE HA SCELTO (checklist 37).
Dico ("terminale : " + $Terminal)
Dico ("dati      : " + $DataFolder + "   (DEVE restare lo stesso in tutti i passi)")

# --- 2a. LA SOSTA SI SVUOTA A OGNI GIRO (checklist 56), e SI CONTA PRIMA
#     E DOPO (checklist 69): una Remove-Item che fallisce in silenzio
#     degraderebbe questo passo in un "boh", e nello zip finirebbero
#     artefatti di un giro precedente indistinguibili da quelli veri.
$nSosta = @(Get-ChildItem -LiteralPath $Sosta -File -ErrorAction SilentlyContinue).Count
if($nSosta -gt 0){
  Get-ChildItem -LiteralPath $Sosta -File -ErrorAction SilentlyContinue | Remove-Item -Force -ErrorAction SilentlyContinue
  $nDopo = @(Get-ChildItem -LiteralPath $Sosta -File -ErrorAction SilentlyContinue).Count
  if($nDopo -gt 0){
    [void]$Problemi.Add("sosta: " + $nDopo + " file su " + $nSosta + " di un giro PRECEDENTE non sono stati cancellati. Possono finire nello zip di questo round spacciandosi per artefatti di adesso: controllare le date dentro lo zip prima di leggerlo.")
  }
  Dico ("sosta svuotata: " + $nSosta + " file di un giro precedente rimossi (rimasti: " + $nDopo + ")") "Green"
}

# --- 2b. L'INCLUDE CHE NESSUN DRIVER INSTALLA (checklist 33-bis).
#     L'EA fa #include <ABTG_PausaGuardian.mqh>. Senza questa riga la
#     compilazione fallisce -- e su QUESTO round sarebbe il falso negativo
#     peggiore: e' la prima compilazione dell'EA, e cercheremmo un errore
#     di porting che non esiste. Pagato due volte (21/08 e 22/08).
#     >>> NEL TESTER LA GUARDIA E' FAIL-OPEN TOTALE (le GlobalVariable del
#         Guardian non esistono): non cambia il comportamento.
$mqh = Join-Path $MqlInclude "ABTG_PausaGuardian.mqh"
Scarica ("$RawPin/mql5/Include/ABTG_PausaGuardian.mqh") $mqh 'ABTG_GuardiaIngresso'
$vfy = Get-Item -LiteralPath $mqh
if($vfy.PSIsContainer){ throw "ABTG_PausaGuardian.mqh: in Include c'e' una CARTELLA con quel nome (checklist 27-ter)." }
if($vfy.Length -lt 4000){ throw ("ABTG_PausaGuardian.mqh e' lungo " + $vfy.Length + " byte: troppo poco, scarico monco.") }
Dico ("include installato: ABTG_PausaGuardian.mqh (" + $vfy.Length + " byte)") "Green"

# --- 2c. PULIZIA DEGLI ARTEFATTI VECCHI, PRIMA (checklist 14, 53 e 69).
#     >>> SOLO se si corre davvero: un giro a vuoto che cancella gli
#         artefatti di una corsa vera fatta ieri e' un danno.
#     >>> E SI CANCELLA PER NOME: un filtro a wildcard prenderebbe anche i
#         CSV delle sedie vive e degli altri round.
#     >>> E SE UN FILE SOPRAVVIVE, LO SI DICE RUMOROSAMENTE (checklist 69).
if($SoloControllo){
  Dico "SoloControllo: NON cancello niente." "Yellow"
} else {
  foreach($s in $SymLavoro){
    $optCsv = Join-Path $MqlFiles ("OptResults_" + $Ea + "_" + $s.Sym + ".csv")
    if(Test-Path -LiteralPath $optCsv){
      Remove-Item -LiteralPath $optCsv -Force -ErrorAction SilentlyContinue
      if(Test-Path -LiteralPath $optCsv){
        [void]$Problemi.Add("NON sono riuscito a cancellare " + $optCsv + " (qualcuno lo tiene aperto). Il file di appoggio dell'OPTFRAME e' di un giro PRECEDENTE: i CSV di questo round vanno confrontati con la loro data prima di leggerli.")
        Dico ("OptResults NON cancellato: " + $optCsv) "Red"
      }
    }
  }
  #  i file per-trade dei NOSTRI magic, e SOLO quelli: si cancellano per
  #  NOME COMPLETO, mai a wildcard (checklist 46).
  if(Test-Path -LiteralPath $CommonFiles){
    $nPt = 0
    foreach($c in $Lavori){
      foreach($mm in @($c.Base,($c.Base+1),($c.Base+2))){
        $pt = Join-Path $CommonFiles ("abtg_trades_" + $Ea + "_" + $c.Sym + "_" + $mm + ".csv")
        if(Test-Path -LiteralPath $pt){
          Remove-Item -LiteralPath $pt -Force -ErrorAction SilentlyContinue
          if(Test-Path -LiteralPath $pt){
            [void]$Problemi.Add("per-trade NON cancellato: " + $pt + ". Se ricompare 'fresco' non e' detto che sia di adesso.")
          } else { $nPt++ }
        }
      }
    }
    if($nPt -gt 0){ Dico ($nPt.ToString() + " file per-trade di un giro precedente rimossi da Common\Files") "Green" }
  }
  #  la CACHE del tester, e SOLO quella. MAI bases\<server>\ticks: li'
  #  dentro c'e' lo storico, e ributtarlo giu' e' una nottata -- e su
  #  questi indici lo storico e' TUTTO quello che il broker ha.
  #  >>> CON -LiteralPath IL * NON E' UN WILDCARD (checklist 46).
  $cache = Join-Path $DataFolder "Tester\cache"
  if(Test-Path -LiteralPath $cache){
    $nc = @(Get-ChildItem -LiteralPath $cache -Force -Recurse -File -ErrorAction SilentlyContinue).Count
    Get-ChildItem -LiteralPath $cache -Force -ErrorAction SilentlyContinue | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue
    $nr = @(Get-ChildItem -LiteralPath $cache -Force -Recurse -File -ErrorAction SilentlyContinue).Count
    if($nr -gt 0){
      [void]$Problemi.Add("Tester\cache NON svuotata: " + $nr + " file su " + $nc + " sono rimasti. MT5 puo' ripescare passate gia' calcolate (punto 38).")
      Dico ("Tester\cache: " + $nc + " file prima, " + $nr + " RIMASTI.") "Red"
    } else {
      Dico ("Tester\cache svuotata: " + $nc + " file prima, 0 dopo. bases\<server>\ticks NON toccata.") "Green"
    }
  } else { Dico "Tester\cache non esiste: niente da svuotare." "Gray" }
}

# =====================================================================
#  3. FASE COMPILA. .ex5 SCRITTO ADESSO.
#     >>> QUESTA E' LA PRIMA COMPILAZIONE DELLA VITA DI QUESTO EA.
#     Si fa ANCHE in -SoloControllo: altrimenti un giro a vuoto non
#     direbbe niente sulla compilabilita' (checklist 39) -- ed e' la cosa
#     piu' utile che il giro a vuoto possa fare su questo round.
#     >>> INVOCAZIONE DIRETTA di metaeditor64.exe (checklist 54 e bug del
#         22/08): con Start-Process -ArgumentList a stringhe pre-quotate,
#         sui path con spazi ("Program Files") torna rc=0 SENZA compilare.
#     >>> E IL VERDETTO E' IL LastWriteTime DEL .ex5 PRIMA/DOPO, non
#         "esiste" e non "e' recente".
# =====================================================================
Titolo "3. FASE COMPILA  <<< LA PRIMA F7 DI QUESTO EA"
$mq5 = Join-Path $MqlExperts ($Ea + ".mq5")
$ex5 = Join-Path $MqlExperts ($Ea + ".ex5")
$logC= Join-Path $MqlExperts ($Ea + ".log")
#  backup DATATO e MAI sovrascritto (checklist 12): se un .ex5 vecchio
#  esistesse, sarebbe l'unica prova di cosa girava prima su questa
#  macchina. (Su questo EA non dovrebbe esistere: e' nuovo.)
$bakMq5 = $mq5 + ".prima_r109_" + $Stamp
$bakEx5 = $ex5 + ".prima_r109_" + $Stamp
$esistevaEx5 = (Test-Path -LiteralPath $ex5)
if((Test-Path -LiteralPath $mq5) -and -not (Test-Path -LiteralPath $bakMq5)){ Copy-Item -LiteralPath $mq5 -Destination $bakMq5 -Force }
if($esistevaEx5 -and -not (Test-Path -LiteralPath $bakEx5)){ Copy-Item -LiteralPath $ex5 -Destination $bakEx5 -Force }
if($esistevaEx5){
  [void]$Rilievi.Add("in MQL5\Experts esisteva GIA' un " + $Ea + ".ex5 prima di questo round. Il .mq5 dichiara di non essere mai stato compilato: o qualcuno lo ha compilato a mano (e allora va detto), o e' di un altro giro di R109. Backup datato messo da parte.")
}
Copy-Item -LiteralPath $srcMq5 -Destination $mq5 -Force
#  verifica della copia sul CONTENUTO, non sul nome (checklist 27-ter)
$lenSrc = (Get-Item -LiteralPath $srcMq5).Length
$vc = Get-Item -LiteralPath $mq5 -ErrorAction SilentlyContinue
if(-not $vc -or $vc.PSIsContainer -or $vc.Length -ne $lenSrc){ throw ("copia di " + $Ea + ".mq5 in MQL5\Experts NON verificata (lunghezza diversa o e' una cartella).") }
$ex5Prima = (Get-Date).AddYears(-100)
if(Test-Path -LiteralPath $ex5){ $ex5Prima = (Get-Item -LiteralPath $ex5).LastWriteTime }
Remove-Item -LiteralPath $logC -Force -ErrorAction SilentlyContinue
& $MetaEditor "/compile:$mq5" "/log:$logC" | Out-Null
$rcMe = $LASTEXITCODE
$ex5Dopo = $null
if(Test-Path -LiteralPath $ex5){ $ex5Dopo = (Get-Item -LiteralPath $ex5).LastWriteTime }
$compileOk = ($null -ne $ex5Dopo) -and ($ex5Dopo -gt $ex5Prima)
$testoLog = ""
if(Test-Path -LiteralPath $logC){
  try{ $testoLog = (Get-Content -LiteralPath $logC -Raw -Encoding Unicode) }catch{ $testoLog = "" }
  if($testoLog -notmatch '(?i)error'){ try{ $testoLog = (Get-Content -LiteralPath $logC -Raw) }catch{} }
  Copy-Item -LiteralPath $logC -Destination (Join-Path $Sosta ("compile_" + $Ea + ".log")) -Force -ErrorAction SilentlyContinue
}
if(-not $compileOk){
  Write-Host ""
  Write-Host "#####################################################################" -ForegroundColor Red
  Write-Host "#  LA PRIMA COMPILAZIONE DI QUESTO EA NON E' RIUSCITA.              #" -ForegroundColor Red
  Write-Host "#  NON e' un guasto della riga: e' UN ESITO PREVISTO. Il .mq5 non   #" -ForegroundColor Red
  Write-Host "#  era MAI stato compilato da nessuno, e lo dice da solo in testa.  #" -ForegroundColor Red
  Write-Host "#####################################################################" -ForegroundColor Red
  if($testoLog -ne ""){
    Write-Host "--- log del compilatore (ultime 40 righe) ---" -ForegroundColor DarkYellow
    foreach($r in @($testoLog -split "\r?\n" | Select-Object -Last 40)){ Write-Host ("   " + $r) -ForegroundColor DarkYellow }
    $errs = @($testoLog -split "\r?\n" | Where-Object { $_ -match '(?i)\berror\b' } | Select-Object -First 15)
    if($errs.Count -gt 0){
      Write-Host "--- le righe con ERROR, che sono quelle da mandare in chat ---" -ForegroundColor Red
      foreach($r in $errs){ Write-Host ("   " + $r) -ForegroundColor Red }
    }
  } else { Write-Host "   (nessun log prodotto da MetaEditor)" -ForegroundColor DarkYellow }
  #  sorgente e binario devono restare la STESSA versione (checklist 54)
  if(Test-Path -LiteralPath $bakMq5){ Copy-Item -LiteralPath $bakMq5 -Destination $mq5 -Force }
  throw ("COMPILAZIONE FALLITA per " + $Ea + " (metaeditor rc=" + $rcMe + ", .ex5 NON riscritto). Il .mq5 e' stato rimesso com'era e IL LOG E' NELLO ZIP: e' quello che serve per correggere il porting. Sospetti in ordine: (1) un errore vero del sorgente -- probabile, non e' mai stato compilato; (2) include mancante; (3) MetaEditor gia' aperto.")
}
$mw = [regex]::Match($testoLog,'(?i)(\d+)\s+warning')
if($mw.Success){
  $Warning = [int]$mw.Groups[1].Value
  if($Warning -gt 0){
    [void]$Rilievi.Add("compilazione " + $Ea + ": " + $Warning + " warning (0 errori). Su un sorgente compilato per la PRIMA VOLTA i warning vanno letti tutti, uno per uno, nel log dello zip: non fermano il round, ma sono l'unica cosa che il compilatore ha da dire su un porting mai provato.")
  }
}
$Compilato = $true
Dico ("COMPILATO " + $Ea + " v" + $EaVer + " (.ex5 riscritto adesso, rc=" + $rcMe + ", warning: " + $(if($Warning -ge 0){ $Warning } else { "n/d" }) + ")") "Green"

# =====================================================================
#  LE DUE FABBRICHE DI .ini. Un solo artefatto: le righe le detta il FILE
#  PROVA, non questa riga (checklist 33). Ogni fabbrica ha i suoi gate
#  SULLO STATO FINALE del testo, non sul replace.
#  >>> IL MODELLO E' UN PARAMETRO ESPLICITO e non si legge dalla cella:
#      il COLLAUDO gira a modello 1 anche quando le celle girano a 4, e
#      un modello dedotto sarebbe la classe di difetto 49 (la spia
#      costruita sulla cella che non sa dire lo stato "a meta'").
# =====================================================================
#  >>> LA FINESTRA E' UN PARAMETRO COME GLI ALTRI, E VA CONTROLLATA COME
#      GLI ALTRI (pagato il 25/08 sul PC di Claudio, giro a vuoto delle
#      21:48, pin cf6126d). Le fabbriche controllavano i 41 parametri, il
#      Period, il Model, l'asse Y, il magic, AllowLiveTrading... e NON le
#      DATE. Una $DataA corrotta e' passata da tutti i gate, e' finita
#      nell'.ini come
#         ToDate=InpUsaGuardian=true||true||0||true||N InpPivotLeft=5||...
#      ed e' uscita ESITO 0. La finestra e' la meta' di quello che un
#      backtest MISURA: se non e' quella dichiarata, il numero non risponde
#      alla domanda -- e MT5 con un ToDate invalido non si sa cosa faccia
#      (forse corre fino a oggi), quindi non e' nemmeno un errore rumoroso.
function GateDate([string]$eti,[string]$da,[string]$a){
  #  1. la FORMA, su tutte e due
  if($da -notmatch '^\d{4}\.\d{2}\.\d{2}$'){ throw ($eti + ": FromDate non e' una data 'aaaa.mm.gg' ma [" + $da + "]. La finestra non e' quella dichiarata: mi fermo PRIMA di scrivere l'ini.") }
  if($a  -notmatch '^\d{4}\.\d{2}\.\d{2}$'){ throw ($eti + ": ToDate non e' una data 'aaaa.mm.gg' ma [" + $a + "]. La finestra non e' quella dichiarata: mi fermo PRIMA di scrivere l'ini.") }
  #  2. che siano date VERE (2026.02.31 ha la forma giusta e non esiste)
  $d1 = [datetime]::MinValue; $d2 = [datetime]::MinValue
  if(-not [datetime]::TryParseExact($da,"yyyy.MM.dd",$INV,[Globalization.DateTimeStyles]::None,[ref]$d1)){ throw ($eti + ": FromDate [" + $da + "] ha la forma di una data ma non e' un giorno che esiste.") }
  if(-not [datetime]::TryParseExact($a ,"yyyy.MM.dd",$INV,[Globalization.DateTimeStyles]::None,[ref]$d2)){ throw ($eti + ": ToDate [" + $a + "] ha la forma di una data ma non e' un giorno che esiste.") }
  #  3. e che vadano nel verso giusto
  if($d2 -le $d1){ throw ($eti + ": ToDate (" + $a + ") non e' DOPO FromDate (" + $da + "): la finestra e' vuota o rovesciata.") }
}
#  >>> E il controllo si ripete SULLO STATO FINALE DEL TESTO, come tutti
#      gli altri gate di queste fabbriche: quello sopra guarda gli
#      ARGOMENTI, questo guarda l'ARTEFATTO CHE GIRA (checklist 34-bis).
function GateDateIni([string]$eti,[string]$testo,[string]$da,[string]$a){
  if($testo -notmatch ('(?m)^FromDate=' + [regex]::Escape($da) + '\r?$')){ throw ($eti + ": nell'ini la riga FromDate non e' 'FromDate=" + $da + "'.") }
  if($testo -notmatch ('(?m)^ToDate='   + [regex]::Escape($a)  + '\r?$')){ throw ($eti + ": nell'ini la riga ToDate non e' 'ToDate=" + $a + "'.") }
  $nf = @([regex]::Matches($testo,'(?m)^FromDate=')).Count
  $nt = @([regex]::Matches($testo,'(?m)^ToDate=')).Count
  if($nf -ne 1 -or $nt -ne 1){ throw ($eti + ": nell'ini ci sono " + $nf + " righe FromDate e " + $nt + " righe ToDate invece di una ciascuna.") }
}
function IniOtt($cella,[string]$da,[string]$a,[int]$magic,[int]$modello,[string]$dest,[string]$report){
  GateDate ("ini OTT " + $cella.Prova) $da $a
  $out = New-Object System.Collections.ArrayList
  foreach($r in $Vive[$cella.Prova]){
    if((NomeDi $r) -eq "InpMagic"){ [void]$out.Add("InpMagic=" + $magic + "||" + $magic + "||1||" + ($magic+1) + "||Y") }
    else { [void]$out.Add($r) }
  }
  $inputs = ($out -join "`r`n")
  if(@($out).Count -ne $RigheAtte){ throw ("ini OTT " + $cella.Prova + ": " + @($out).Count + " parametri invece di " + $RigheAtte) }
  $yy = @([regex]::Matches($inputs,'(?m)^(\w+)=[^\r\n]*\|\|\s*[Yy]\s*\r?$') | ForEach-Object { $_.Groups[1].Value })
  if($yy.Count -ne 1 -or $yy[0] -ne "InpMagic"){ throw ("ini OTT " + $cella.Prova + ": assi Y = [" + ($yy -join ", ") + "] invece del solo InpMagic.") }
  if($inputs -notmatch ('(?m)^InpMagic=' + $magic + '\|\|' + $magic + '\|\|1\|\|' + ($magic+1) + '\|\|Y\r?$')){ throw ("ini OTT: InpMagic non pinnato a " + $magic + "/" + ($magic+1)) }
  $testo = @"
[Charts]
MaxBars=2000000000

[Experts]
AllowLiveTrading=false
AllowDllImport=false

[Tester]
Expert=$Ea.ex5
Symbol=$($cella.Sym)
Period=M15
Model=$modello
Spread=$SpreadIni
Optimization=1
OptimizationCriterion=6
FromDate=$da
ToDate=$a
ForwardMode=0
Deposit=$Deposito
Currency=EUR
Leverage=100
ExecutionMode=0
ReplaceReport=1
ShutdownTerminal=1
Report=$report

[TesterInputs]
$inputs
"@
  GateDateIni ("ini OTT " + $cella.Prova) $testo $da $a
  Set-Content -LiteralPath $dest -Value $testo -Encoding ASCII
}
function IniSingola($cella,[string]$da,[string]$a,[int]$magic,[int]$modello,[string]$dest,[string]$report){
  GateDate ("ini SINGOLA " + $cella.Prova) $da $a
  $out = New-Object System.Collections.ArrayList
  foreach($r in $Vive[$cella.Prova]){
    $nome = NomeDi $r
    if($nome -eq "InpMagic"){ [void]$out.Add("InpMagic=" + $magic) }
    else { [void]$out.Add($nome + "=" + (ValoreDi $r)) }
  }
  $inputs = ($out -join "`r`n")
  if(@($out).Count -ne $RigheAtte){ throw ("ini SINGOLA " + $cella.Prova + ": " + @($out).Count + " parametri invece di " + $RigheAtte) }
  #  un "||" rimasto vorrebbe dire un'OTTIMIZZAZIONE TRAVESTITA, e in
  #  ottimizzazione non esiste nessun report .htm da leggere: il PASSO 0
  #  resterebbe muto e nessuno saprebbe perche' (checklist 34).
  if($inputs -match '\|\|'){ throw ("ini SINGOLA " + $cella.Prova + ": e' rimasto uno sweep '||'.") }
  if($inputs -notmatch ('(?m)^InpMagic=' + $magic + '\r?$')){ throw ("ini SINGOLA: InpMagic non pinnato a " + $magic) }
  if($inputs -notmatch '(?m)^InpVerbose=true\r?$'){ throw "ini SINGOLA: InpVerbose non e' true (senza, il gate A0 non ha niente da leggere)." }
  if($inputs -notmatch '(?m)^InpAutoTest=true\r?$'){ throw "ini SINGOLA: InpAutoTest non e' true (senza, l'autotest non stampa e il gate A0 non esiste)." }
  $testo = @"
[Charts]
MaxBars=2000000000

[Experts]
AllowLiveTrading=false
AllowDllImport=false

[Tester]
Expert=$Ea.ex5
Symbol=$($cella.Sym)
Period=M15
Model=$modello
Spread=$SpreadIni
Optimization=0
FromDate=$da
ToDate=$a
ForwardMode=0
Deposit=$Deposito
Currency=EUR
Leverage=100
ExecutionMode=0
ReplaceReport=1
ShutdownTerminal=1
Report=$report

[TesterInputs]
$inputs
"@
  GateDateIni ("ini SINGOLA " + $cella.Prova) $testo $da $a
  Set-Content -LiteralPath $dest -Value $testo -Encoding ASCII
}

#  --- LANCIA UN .ini E TORNA I MINUTI. Uno solo per volta, mai in parallelo.
function Lancia([string]$ini){
  $t0 = Get-Date
  (Start-Process -FilePath $Terminal -ArgumentList ("/config:`"" + $ini + "`"") -PassThru).WaitForExit()
  return [math]::Round((New-TimeSpan -Start $t0 -End (Get-Date)).TotalMinutes,1)
}
#  --- TROVA IL REPORT .htm SCRITTO DOPO $dopo. MT5 lo scrive dove gli
#      pare (install dir, cartella dati, cartella di lavoro): si cerca in
#      tutte, e SI GUARDA LA DATA -- un .htm di ieri non e' un report
#      (checklist 23).
function TrovaReport([string]$nome,[datetime]$dopo){
  foreach($rad in @($InstDir,$DataFolder,$Work,$MqlFiles)){
    if([string]::IsNullOrEmpty($rad)){ continue }
    if(-not (Test-Path -LiteralPath $rad)){ continue }
    $c = @(Get-ChildItem -LiteralPath $rad -Filter ($nome + "*.htm*") -File -ErrorAction SilentlyContinue |
           Where-Object { $_.LastWriteTime -ge $dopo } | Sort-Object LastWriteTime -Descending)
    if($c.Count -gt 0){ return $c[0].FullName }
  }
  return ""
}

# =====================================================================
#  L'ORDINE DELLE CELLE. Dentro ogni simbolo il LONG gira prima dello
#  SHORT, e i simboli sono in ordine ALFABETICO (Sort-Object -Unique
#  ORDINA: checklist 70, l'ordine promesso deve essere quello reale).
# =====================================================================
$Ordinati = @()
foreach($s in $SymLavoro){
  $Ordinati += @($Lavori | Where-Object { $_.Sym -eq $s.Sym -and $_.Lato -eq "LONG" })
  $Ordinati += @($Lavori | Where-Object { $_.Sym -eq $s.Sym -and $_.Lato -eq "SHORT" })
}

# =====================================================================
#  4. IL COLLAUDO DELL'AUTOTEST -- gate A0 (criteri par. 3.1)
#     Una cella, un mese, MODELLO 1, magic dedicato. NON produce NESSUN
#     numero di round: serve solo a far girare OnInit e a leggere le
#     righe [ATREXH][AUTOTEST].
#     >>> E' il gate che deve FALLIRE PRESTO: senza, un DIVERGE si
#         scoprirebbe dopo ore di tick reali, su numeri gia' prodotti e
#         gia' guardati.
# =====================================================================
Titolo "4. COLLAUDO DELL'AUTOTEST (gate A0)"
$cCollaudo = $Ordinati[0]
$iniColl = Join-Path $Work "collaudo_autotest.ini"
IniSingola $cCollaudo $CollaudoDa $CollaudoA $CollaudoMagic 1 $iniColl "R109_collaudo_autotest"
Copy-Item -LiteralPath $iniColl -Destination (Join-Path $Sosta "collaudo_autotest.ini") -Force
Dico ("collaudo: " + $cCollaudo.Sym + " " + $cCollaudo.Id + " | " + $CollaudoDa + " -> " + $CollaudoA + " | modello 1 | magic " + $CollaudoMagic)
if($SoloControllo){
  $AutotestStato = "NON ESEGUITO (giro a vuoto: l'autotest si legge ESEGUENDO, non compilando -- checklist 20)"
  Dico "SoloControllo: il collaudo NON gira. L'autotest richiede un'ESECUZIONE." "Yellow"
} else {
  $tA = Get-Date
  $minA = Lancia $iniColl
  Dico ("  ... collaudo: " + $minA.ToString("0.0",$INV) + " minuti") "Gray"
  $at = LeggiAutotest $tA
  $AutotestStato = $at.Stato
  $AutotestRighe = @($at.Righe)
  $AutotestFile  = $at.File
  foreach($r in $AutotestRighe){ Write-Host ("    " + $r) -ForegroundColor DarkCyan }
  if($at.Variante){
    [void]$Problemi.Add("IL LOG DEL COLLAUDO CONTIENE 'ATTENZIONE: almeno una variante e' accesa'. E' l'EA che dichiara da solo che quella cella NON e' la cella AUTORE del porting. I criteri par. 6 dicono il contrario: c'e' da guardare il file prova PRIMA di leggere qualunque numero.")
  }
  if($AutotestStato -eq "DIVERGE"){
    #  >>> NON e' "quella cella": il codice e' lo stesso su tutte e sei.
    throw ("GATE A0 FALLITO -- L'AUTOTEST DELL'EA STAMPA 'DIVERGE'. La tesi (par. 8.8) dice: 'Se stampa DIVERGE, i risultati non si usano'. Il nucleo puro del motore NON ragiona come la sua firma: prima si guarda il codice, poi si rifa' il round. Le righe [ATREXH][AUTOTEST] sono qui sopra e nel referto, e dicono QUALE blocco e' fallito. NESSUNA passata di misura e' stata lanciata: non c'e' niente da salvare e niente da leggere.")
  }
  if($AutotestStato -like "SUPERATO*"){ Dico ("GATE A0 SUPERATO: sette blocchi su sette") "Green" }
  else {
    [void]$Problemi.Add("GATE A0 NON LETTO: " + $AutotestStato + " >>> NON e' un autotest superato, ed e' la decisione D5: si prosegue, ma OGNI NUMERO DI QUESTO ROUND ESCE MARCATO 'NON CONVALIDATO'. Non aver trovato il log non e' aver letto un esito (checklist 28-bis, il verde per assenza)." +
                        " >>> E DA CHE PARTE STA IL DUBBIO, DICHIARATO: le cinque radici in cui questo driver cerca il log dell'agente del tester NON SONO MAI STATE MISURATE SU UN MT5 VERO -- sono l'ipotesi migliore di chi ha scritto la riga, non un fatto. Quindi 'NON LETTO' e' molto piu' probabilmente NOSTRO (cerchiamo nel posto sbagliato) che dell'EA: NON e' un indizio che il motore sbagli, e NON va letto come un mezzo-DIVERGE. Se il motore divergesse davvero, l'esito sarebbe 'DIVERGE' e il round si sarebbe gia' fermato." +
                        " COME TOGLIERE IL DUBBIO IN CINQUE MINUTI: aprire MT5, Strategy Tester, ricaricare collaudo_autotest.ini (e' nello zip) in test singolo, leggere la scheda Esperti e copiare in chat le righe [ATREXH][AUTOTEST]. E annotare DOVE stava il file: cosi' la prossima riga cerca nel posto misurato invece che nei cinque ipotizzati.")
    Dico ("GATE A0 NON LETTO: " + $AutotestStato) "Yellow"
  }
}

# =====================================================================
#  5. LA CATENA. Una cella alla volta.
#     Dentro ogni cella: prima la SINGOLA (che porta il PASSO 0 e il
#     cancello zero), poi le GEMELLE. L'ordine e' quello dei criteri:
#     PRIMA SI CONTA, POI SI GUARDA IL COSTO, POI TUTTO IL RESTO.
#     >>> E se S0a fallisce su una cella, le altre proseguono (D6).
# =====================================================================
Titolo ("5. LA CATENA - " + $Ordinati.Count + " celle, una alla volta")
$idx = 0
foreach($c in $Ordinati){
  $idx++
  $s = @($SIMBOLI | Where-Object { $_.Sym -eq $c.Sym })[0]
  $trascorse = (New-TimeSpan -Start $Avvio -End (Get-Date)).TotalHours
  if($trascorse -ge $OreMax){
    $c.Esito = "NON INIZIATA (tetto ore raggiunto)"
    [void]$Problemi.Add("TEMPO SCADUTO prima di " + $c.Prova + ": il round NON e' completo. Riprendi con -SoloCella " + $c.Prova + " (il collaudo dell'autotest rigira da solo).")
    continue
  }
  Write-Host ""
  Write-Host "------------------------------------------------------------------" -ForegroundColor Cyan
  Write-Host ("  [" + $idx + "/" + $Ordinati.Count + "]  " + $c.Prova + "   <<< " + $c.Lato + " SOLO") -ForegroundColor Cyan
  Write-Host ("           " + $c.Desc) -ForegroundColor Cyan
  Write-Host ("           M15 | modello " + $c.Modello + " | " + $DataDa + " -> " + $DataA + " | magic base " + $c.Base) -ForegroundColor Cyan
  Write-Host "------------------------------------------------------------------" -ForegroundColor Cyan
  $tCella = Get-Date

  # --- gli .ini di questa cella, scritti SEMPRE (anche a vuoto): sono
  #     GLI STESSI che girano nella corsa vera, non un secondo artefatto.
  $iniSing = Join-Path $Work ($c.Sym + "_" + $c.Id + "_singola.ini")
  $iniInt  = Join-Path $Work ($c.Sym + "_" + $c.Id + "_gemelle.ini")
  $repSing = "R109_" + $c.Sym + "_" + $c.Id + "_singola"
  IniSingola $c $DataDa $DataA ($c.Base + 2) $c.Modello $iniSing $repSing
  IniOtt     $c $DataDa $DataA  $c.Base      $c.Modello $iniInt  ("R109_" + $c.Sym + "_" + $c.Id + "_gemelle")
  Copy-Item -LiteralPath $iniSing -Destination (Join-Path $Sosta ($c.Sym + "_" + $c.Id + "_singola.ini")) -Force
  Copy-Item -LiteralPath $iniInt  -Destination (Join-Path $Sosta ($c.Sym + "_" + $c.Id + "_gemelle.ini")) -Force

  if($SoloControllo){
    # --- IL GIRO A VUOTO LEGGE GLI .ini CHE HA APPENA SCRITTO. E' tutto
    #     quello che puo' fare, e lo dice.
    $guai = New-Object System.Collections.ArrayList
    foreach($pair in @(@($iniSing,"singola"),@($iniInt,"gemelle"))){
      $atx = Get-Content -LiteralPath $pair[0] -Raw
      if($atx -notmatch ('(?m)^Model=' + $c.Modello + '\r?$')){ [void]$guai.Add($pair[1] + ": Model non e' " + $c.Modello) }
      if($atx -notmatch '(?m)^Period=M15\r?$'){ [void]$guai.Add($pair[1] + ": Period non e' M15") }
      if($atx -notmatch ('(?m)^Symbol=' + $c.Sym + '\r?$')){ [void]$guai.Add($pair[1] + ": Symbol non e' " + $c.Sym) }
      if($atx -notmatch '(?m)^AllowLiveTrading=false\r?$'){ [void]$guai.Add($pair[1] + ": manca AllowLiveTrading=false (checklist 51!)") }
      if($atx -notmatch ('(?m)^InpAllowLong=' + $c.Val["InpAllowLong"] + '(\||\r|$)')){ [void]$guai.Add($pair[1] + ": InpAllowLong non e' " + $c.Val["InpAllowLong"] + " NELL'INI CHE GIRA") }
      if($atx -notmatch ('(?m)^InpAllowShort=' + $c.Val["InpAllowShort"] + '(\||\r|$)')){ [void]$guai.Add($pair[1] + ": InpAllowShort non e' " + $c.Val["InpAllowShort"] + " NELL'INI CHE GIRA") }
      if($atx -notmatch '(?m)^InpAutoTest=true(\||\r|$)'){ [void]$guai.Add($pair[1] + ": InpAutoTest non e' true NELL'INI CHE GIRA") }
      #  >>> LA FINESTRA, che il 25/08 e' passata da TUTTI i controlli qui
      #      sopra con dentro il dump dei TesterInputs. Si legge la riga
      #      COM'E' SCRITTA NELL'INI, non la variabile che l'ha prodotta.
      $mf = [regex]::Match($atx,'(?m)^FromDate=(.*?)\r?$')
      $mt = [regex]::Match($atx,'(?m)^ToDate=(.*?)\r?$')
      if(-not $mf.Success -or $mf.Groups[1].Value -notmatch '^\d{4}\.\d{2}\.\d{2}$'){
        [void]$guai.Add($pair[1] + ": FromDate NELL'INI CHE GIRA non e' una data ma [" + $(if($mf.Success){ $mf.Groups[1].Value } else { "riga assente" }) + "]")
      }
      if(-not $mt.Success -or $mt.Groups[1].Value -notmatch '^\d{4}\.\d{2}\.\d{2}$'){
        [void]$guai.Add($pair[1] + ": ToDate NELL'INI CHE GIRA non e' una data ma [" + $(if($mt.Success){ $mt.Groups[1].Value } else { "riga assente" }) + "]")
      }
      if($mf.Success -and $mt.Success -and $mf.Groups[1].Value -ne $DataDa){ [void]$guai.Add($pair[1] + ": FromDate e' " + $mf.Groups[1].Value + " invece di " + $DataDa) }
      if($mf.Success -and $mt.Success -and $mt.Groups[1].Value -ne $DataA){  [void]$guai.Add($pair[1] + ": ToDate e' "   + $mt.Groups[1].Value + " invece di " + $DataA) }
    }
    if($guai.Count -gt 0){
      foreach($g in $guai){ [void]$Problemi.Add("giro a vuoto / " + $c.Sym + " " + $c.Id + ": " + $g) }
      $c.Esito = "SOLO CONTROLLO (con " + $guai.Count + " rilievi sugli .ini)"
    } else {
      $c.Esito = "SOLO CONTROLLO"
    }
    Write-Host ("    esito: " + $c.Esito) -ForegroundColor Gray
    continue
  }

  # -------------------------------------------------------------------
  #  5a. LA PASSATA SINGOLA -> il report .htm -> TUTTO IL PASSO 0
  # -------------------------------------------------------------------
  Write-Host ("  -- PASSATA SINGOLA " + $DataDa + " -> " + $DataA + " (magic " + ($c.Base+2) + ")") -ForegroundColor White
  $t0 = Get-Date
  $minS = Lancia $iniSing
  Dico ("  ... passata singola: " + $minS.ToString("0.0",$INV) + " minuti") "Gray"
  #  ogni passata ristampa l'autotest in OnInit: se il collaudo non si era
  #  letto, si prova di nuovo qui. Non e' ridondanza: e' l'unica seconda
  #  occasione che abbiamo, e costa zero.
  if($AutotestStato -notlike "SUPERATO*" -and $AutotestStato -ne "DIVERGE"){
    $at2 = LeggiAutotest $t0
    if($at2.Stato -eq "DIVERGE"){
      throw ("GATE A0 FALLITO IN CORSA -- l'autotest stampa 'DIVERGE' (letto nel log della passata singola di " + $c.Prova + "). I risultati non si usano: mi fermo qui. Righe: " + (@($at2.Righe) -join " | "))
    }
    if($at2.Stato -like "SUPERATO*"){
      $AutotestStato = "SUPERATO (letto nel log della passata singola di " + $c.Prova + ", non nel collaudo)"
      $AutotestRighe = @($at2.Righe); $AutotestFile = $at2.File
      Dico ("GATE A0 SUPERATO (recuperato dal log di " + $c.Prova + ")") "Green"
    }
  }
  $c.Autotest = $AutotestStato
  $rep = TrovaReport $repSing $t0
  if($rep -eq ""){
    $c.P0Stato = "NON MISURATO (nessun report .htm scritto dopo l'avvio)"
    [void]$Problemi.Add($c.Prova + ": NON ho trovato nessun report '" + $repSing + "*.htm' scritto dopo l'avvio della passata (cercato in " + $InstDir + ", " + $DataFolder + ", " + $Work + ", " + $MqlFiles + "). TUTTO IL PASSO 0 di questa cella resta NON MISURATO e NON si inventa: niente conteggio, niente take, niente durata, niente peggior giornata. COME AVERLO A MANO: aprire MT5, Strategy Tester, ricaricare l'ini (e' nello zip) in test singolo, tasto destro sul risultato -> Report.")
  } else {
    Copy-Item -LiteralPath $rep -Destination (Join-Path $Sosta ($c.Sym + "_" + $c.Id + "_report_singola.htm")) -Force -ErrorAction SilentlyContinue
    $deal = LeggiDeal $rep
    if(@($deal).Count -eq 0){
      $c.P0Stato = "NON MISURATO (deal non riconosciuti nel report)"
      [void]$Problemi.Add($c.Prova + ": report trovato ma NESSUN deal riconosciuto. Colonne viste: [" + $script:DealColonne + "]. Prime intestazioni: [" + (($script:DealIntestazioni | Select-Object -First 3) -join "  //  ") + "]")
    } else {
      $p0 = Passo0 $deal $s.Punto 900 ([double]$Deposito) 3
      $c.P0Stato = $p0.Stato
      $c.P0Prima = $p0.Prima
      $c.P0Ultima = $p0.Ultima
      $c.P0N     = $p0.N
      $c.P0Sedute = $p0.Sedute
      $c.P0OpSeduta = $p0.OpSeduta
      $c.P0GiorniOp = $p0.GiorniOp
      $c.P0MaxGiorno = $p0.MaxGiorno
      $c.P0GiorniAlCap = $p0.GiorniAlCap
      $c.P0TakeNetMed   = $p0.TakeNetMed
      $c.P0TakeNetMedia = $p0.TakeNetMedia
      $c.P0PerdMed      = $p0.PerdMed
      $c.P0DurMed       = $p0.DurMed
      $c.P0DurMedia     = $p0.DurMedia
      $c.P0Pegg         = $p0.Pegg
      $c.P0PeggData     = $p0.PeggData
      if($p0.Anomalie -gt 0){
        #  >>> IL MARCHIO VA NELLA TABELLA, non in una nota tre pagine piu'
        #      giu' (difetto 67): con la sequenza spaiata anche il CONTEGGIO
        #      e' sospetto, e la colonna FINESTRA e' l'ultima della tabella
        #      "SI CONTA" -- cioe' quella che si legge accanto a n.
        $c.P0Finestra = "NON AFFIDABILE (vedi PROBLEMI: anche n e' sospetto)"
        [void]$Problemi.Add($c.Prova + ": " + $p0.Anomalie + " deal ANOMALI -- " + $p0.Stato + " >>> Le misure del PASSO 0 di questa cella sono DICHIARATE NON MISURATE e non si stimano (criteri par. 3.3).")
      }
      # --- LA FINESTRA VERA (criteri par. 4.1)
      #     >>> l'ANOMALIA VIENE PRIMA: se la sequenza in/out e' spaiata, la
      #         colonna FINESTRA deve restare il marchio "NON AFFIDABILE" e
      #         non farsi sovrascrivere da un verdetto PIENA/ACCORCIATA che
      #         suonerebbe rassicurante su un conteggio sospetto.
      if($p0.Anomalie -eq 0 -and $p0.Prima -ne "NON MISURATA"){
        $dIni = [datetime]::ParseExact($DataDa,"yyyy.MM.dd",$INV)
        $dPri = [datetime]::ParseExact($p0.Prima,"yyyy.MM.dd",$INV)
        if($dPri -le $dIni.AddMonths($MesiPrimaOp)){
          $c.P0Finestra = "PIENA (prima op. " + $p0.Prima + ", ultima " + $p0.Ultima + ")"
        } else {
          $c.P0Finestra = "ACCORCIATA (prima op. " + $p0.Prima + ", finestra dal " + $DataDa + ")"
          [void]$Problemi.Add($c.Prova + " FINESTRA ACCORCIATA: la prima operazione e' del " + $p0.Prima + ", la finestra dichiarata parte dal " + $DataDa + " (che e' MISURATO: sonda del 17/08, stato COMPLETO). Se lo scarto e' grande, o il motore ha impiegato mesi a sparare -- e allora e' una MISURA DI FREQUENZA -- oppure i dati partono dopo. Va deciso QUALE dei due PRIMA di leggere qualunque numero di questa cella.")
        }
      }
      # --- IL CANARINO n (criteri G1). NON E' UN GATE.
      if([int]$p0.N -ge 0 -and [int]$p0.N -lt 20){
        [void]$Rilievi.Add("CANARINO " + $c.Sym + " " + $c.Lato + ": n = " + $p0.N + ", sotto 20. Il verdetto su questa cella e' NON MISURABILE, MAI 'non funziona' (criteri G1). E' una risposta del round: la stima del cacciatore era 0,5-2 operazioni AL GIORNO per lato.")
      } elseif([int]$p0.N -ge 20 -and [int]$p0.N -lt 150){
        [void]$Rilievi.Add("CANARINO " + $c.Sym + " " + $c.Lato + ": n = " + $p0.N + ", sotto i 150 dell'Emendamento regola A. Il MERITO su questa cella e' SOSPESO -- e lo era gia' per costruzione (criteri par. 7: un solo regime). Il RISCHIO si legge lo stesso, a qualunque n (regola B).")
      }
      # --- IL CAP CHE CENSURA LA FREQUENZA (criteri S0b, decisione D7)
      if([int]$p0.GiorniAlCap -gt 0 -and [int]$p0.GiorniOp -gt 0){
        $quota = 100.0 * [double]$p0.GiorniAlCap / [double]$p0.GiorniOp
        if($quota -ge 20.0){
          [void]$Rilievi.Add("FREQUENZA CENSURATA su " + $c.Sym + " " + $c.Lato + ": " + $p0.GiorniAlCap + " giornate su " + $p0.GiorniOp + " operative (" + $quota.ToString("0",$INV) + "%) hanno toccato il cap di 3. Le operazioni per seduta di questa cella sono un LIMITE INFERIORE, non la frequenza del motore: chi legge il numero senza questa riga legge un numero mutilato.")
        }
      }
      # --- LO STOP TROPPO STRETTO (criteri S0d)
      if([double]$p0.PerdMed -ge 0 -and [double]$p0.PerdMed -lt $RMinPunti){
        [void]$Rilievi.Add("STOP STRETTO su " + $c.Sym + " " + $c.Lato + ": perdita mediana " + ([double]$p0.PerdMed).ToString("0.00",$INV) + " punti indice, sotto i " + $RMinPunti.ToString("0",$INV) + " dichiarati. La perdita mediana e' la miglior stima di R che il report contenga: uno stop cosi' stretto vuol dire LOTTO GRANDE, e R55 ha misurato che 1,5 punti indice di slippage sfondavano il 10% sull'ORB. Il pavimento InpMinSLPts esiste, oggi e' SPENTO, ed e' la domanda del round dopo.")
      }
      # --- LA DURATA (criteri S0c)
      if([double]$p0.DurMed -ge 0 -and [double]$p0.DurMed -le 3.0){
        [void]$Rilievi.Add("DURATA CORTA su " + $c.Sym + " " + $c.Lato + ": mediana " + ([double]$p0.DurMed).ToString("0.0",$INV) + " barre M15. arXiv 2605.04004 par. 6.2 misura che i soli segnali intraday sopravvissuti alla falsificazione tengono 12-15 barre, non 1-6. E' un ALLARME SULLA ROBUSTEZZA anche a cancelli verdi, non un cancello.")
      }
      # --- IL CANCELLO ZERO S0a (criteri par. 3.3)
      #  >>> E SOLO A TICK REALI. Con -ScreenOhlcM15 la cella e' girata a
      #      OHLC M1: il take viene misurato sui prezzi di deal costruiti da
      #      barre finte, ed e' PROPRIO la grandezza che l'OHLC distorce di
      #      piu' su M15. Dare li' un SUPERATO/FALLITO sarebbe un verdetto
      #      verde su un numero che non esiste (checklist 67: e' un if).
      if($ScreenOhlcM15){
        $c.S0a = "NON GIUDICABILE -- questa cella e' girata a OHLC M1 (-ScreenOhlcM15): il take misurato su barre OHLC NON e' il take, e su questo motore l'ingresso nasce da un ESTREMO DI BARRA con lo stop a un tick dal minimo. Nessun verdetto S0a si da' qui, ne' SUPERATO ne' FALLITO."
      } else {
        $v = VerdettoS0a ([double]$p0.TakeNetMed)
        $c.P0TakeLordoMed = [double]$v.Lordo
        $c.P0Rapporto     = [double]$v.Rapporto
        $c.S0a            = $v.Verdetto
        if($v.Verdetto -like "SOSPESO*"){ [void]$Rilievi.Add("S0a " + $c.Sym + " " + $c.Lato + ": " + $v.Verdetto) }
        if($v.Verdetto -like "FALLITO*"){
          [void]$Problemi.Add("CANCELLO ZERO S0a FALLITO su " + $c.Sym + " " + $c.Lato + ": " + $v.Verdetto +
                              " >>> E' LA RISPOSTA DEL ROUND SU QUESTA CELLA, NON UN GUASTO: il take non copre il costo, e i numeri di PF/DD che seguono si leggono SAPENDO questo. Le altre celle proseguono (criteri D6).")
        }
      }
    }
  }
  #  il file per-trade dell'EA: non serve al take (non ha il prezzo
  #  d'ingresso) ma e' una seconda vista sui netti, e nello zip ci va.
  if(Test-Path -LiteralPath $CommonFiles){
    $pt = Join-Path $CommonFiles ("abtg_trades_" + $Ea + "_" + $c.Sym + "_" + ($c.Base+2) + ".csv")
    if(Test-Path -LiteralPath $pt){
      Copy-Item -LiteralPath $pt -Destination (Join-Path $Sosta ($c.Sym + "_" + $c.Id + "_pertrade_singola.csv")) -Force -ErrorAction SilentlyContinue
    }
  }

  # -------------------------------------------------------------------
  #  5b. LE GEMELLE -> profitto / PF / DD / n / peggior giornata
  # -------------------------------------------------------------------
  $optCsv = Join-Path $MqlFiles ("OptResults_" + $Ea + "_" + $c.Sym + ".csv")
  Write-Host ("  -- GEMELLE (magic " + $c.Base + "/" + ($c.Base+1) + ")") -ForegroundColor White
  Remove-Item -LiteralPath $optCsv -Force -ErrorAction SilentlyContinue
  $minI = Lancia $iniInt
  Dico ("  ... gemelle: " + $minI.ToString("0.0",$INV) + " minuti") "Gray"
  $dstInt = Join-Path $Risultati ($Ea + "_" + $c.Sym + "_" + $c.Id + "_INTERA.csv")
  if(Test-Path -LiteralPath $optCsv){ Copy-Item -LiteralPath $optCsv -Destination $dstInt -Force; Remove-Item -LiteralPath $optCsv -Force -ErrorAction SilentlyContinue }
  $rInt = LeggiOpt $dstInt
  $c.GemInt = Gemelli $rInt
  if($null -eq $rInt){
    [void]$Problemi.Add($c.Prova + ": CSV non letto o colonne non riconosciute. Intestazioni viste: [" + (($script:CsvIntestazioni | Select-Object -First 12) -join " | ") + "]")
  } elseif(@($rInt).Count -ge 1){
    if($null -ne $rInt[0].Pf){     $c.PfInt   = [double]$rInt[0].Pf }
    if($null -ne $rInt[0].Dd){     $c.DdInt   = [double]$rInt[0].Dd }
    if($null -ne $rInt[0].N){      $c.NInt    = [int]$rInt[0].N }
    if($null -ne $rInt[0].Profit){ $c.ProfInt = [double]$rInt[0].Profit }
    if($null -ne $rInt[0].Pg){     $c.PgInt   = [double]$rInt[0].Pg }
  }
  if($c.GemInt -ne "IDENTICI" -and $c.GemInt -ne "NON MISURATO (CSV non letto)"){
    [void]$Problemi.Add($c.Prova + ": gemelli " + $c.GemInt + ". Le due righe dovevano essere identiche al centesimo: il banco non e' sano e questa cella non si legge.")
  }
  #  >>> IL CONTROINCROCIO CHE COSTA ZERO: il PASSO 0 (report .htm) e le
  #      gemelle (OPTFRAME) contano le stesse operazioni con due strumenti
  #      diversi. Se i due n NON coincidono, uno dei due sta leggendo
  #      un'altra cosa -- ed e' meglio saperlo adesso che in un referto.
  if([int]$c.P0N -ge 0 -and [int]$c.NInt -ge 0 -and [int]$c.P0N -ne [int]$c.NInt){
    [void]$Problemi.Add($c.Prova + ": il conteggio NON torna fra i due strumenti -- report .htm dice n=" + $c.P0N + ", il CSV dell'OPTFRAME dice n=" + $c.NInt + ". Sono la STESSA cella sulla STESSA finestra: uno dei due sta contando un'altra cosa (o il parser dei deal, o il magic). Nessun numero di questa cella si legge finche' non si sa quale.")
  }

  $c.Esito = "OK"
  #  >>> LO SCREEN OHLC NON PRODUCE UN ESITO 'OK'. La riga della TABELLA
  #      MADRE porta il marchio addosso, non in una nota a tre pagine di
  #      distanza (difetto 67).
  if($ScreenOhlcM15){ $c.Esito = "NON GIUDICABILE" }
  elseif($AutotestStato -notlike "SUPERATO*"){ $c.Esito = "NON CONVALIDATA (gate A0)" }
  if([int]$c.NInt -lt 0 -or $c.P0Stato -notlike "MISURATO*"){ $c.Esito = "INCOMPLETA (vedi PROBLEMI)" }

  $c.Min = [math]::Round((New-TimeSpan -Start $tCella -End (Get-Date)).TotalMinutes,1)
  Write-Host ("    esito: " + $c.Esito + "   [" + $c.Min.ToString("0.0",$INV) + " min]") -ForegroundColor Gray
}

if($SoloControllo){
  $nAnt = @(Get-ChildItem -LiteralPath $Sosta -Filter "*.ini" -ErrorAction SilentlyContinue).Count
  $attesi = 1 + ($Ordinati.Count * 2)
  if($nAnt -ne $attesi){ [void]$Problemi.Add("giro a vuoto: " + $nAnt + " file .ini in sosta invece di " + $attesi + ".") }
  Write-Host ""
  Write-Host ("    .ini scritti e verificati: " + $nAnt + " su " + $attesi + "   -> " + $Sosta) -ForegroundColor White
  Write-Host  "    >>> COSA SI LEGGE NEGLI .ini, e cosa no:" -ForegroundColor Yellow
  Write-Host  "        SI LEGGE: Symbol, Period, Model, FromDate/ToDate, AllowLiveTrading=false," -ForegroundColor Yellow
  Write-Host  "          l'unico asse Y (InpMagic), il magic, il LATO e InpAutoTest." -ForegroundColor Yellow
  Write-Host  "        E NON SI LEGGE NESSUN NUMERO DI ROUND: niente n, niente PF, niente DD," -ForegroundColor Yellow
  Write-Host  "          niente take, NIENTE S0 e -- soprattutto -- NIENTE AUTOTEST: quello" -ForegroundColor Yellow
  Write-Host  "          si legge ESEGUENDO (checklist 20), e un giro a vuoto non esegue." -ForegroundColor Yellow
  Write-Host  "        QUELLO CHE INVECE SI LEGGE DAVVERO, ed e' il motivo per cui questo" -ForegroundColor Green
  Write-Host  "          giro conta piu' del solito: SE L'EA COMPILA. Non era mai successo." -ForegroundColor Green
}

}catch{
  $Fatale = $_.Exception.Message
  Write-Host ""
  Write-Host ("!!! FERMATO: " + $Fatale) -ForegroundColor Red
}

# =====================================================================
#  6. RACCOLTA. Si fa SEMPRE, anche a esito parziale o fermato.
# =====================================================================
Titolo "6. RACCOLTA SUL DESKTOP"
#  >>> OGNI ARTEFATTO DICE IN QUALE MODO E' STATO PRODOTTO (checklist 50). <<<
$Modo = "CORSA"
if($SoloControllo){ $Modo = "CONTROLLO" }
elseif($ScreenOhlcM15){ $Modo = "SCREENOHLC" }
elseif($SoloCella -ne ""){ $Modo = "RIPRESA" }
elseif($SoloSimbolo -ne ""){ $Modo = "SOLO" + ($SoloSimbolo.ToUpper() -replace '[,\s]+','') }
$Cart = Join-Path $Dsk ("R109_ATREXH_" + $Modo + "_" + $Stamp)
$Zip  = Join-Path $Dsk ("R109_ATREXH_" + $Modo + "_" + $Stamp + ".zip")
$Referto = Join-Path $Cart "REFERTO_R109.txt"
try{
  New-Item -ItemType Directory -Force -Path $Cart | Out-Null
  foreach($sorg in @($Risultati,$Prove,$Sosta)){
    if(Test-Path -LiteralPath $sorg){
      foreach($f in @(Get-ChildItem -LiteralPath $sorg -File -ErrorAction SilentlyContinue)){
        Copy-Item -LiteralPath $f.FullName -Destination (Join-Path $Cart $f.Name) -Force
      }
    }
  }

  $RefTxt = New-Object System.Collections.ArrayList
  [void]$RefTxt.Add("REFERTO R109 - ATR EXHAUSTION & VOLUME SPIKE, la PRIMA misura in assoluto")
  [void]$RefTxt.Add("ABTG_AtrExhaustVol v" + $EaVer + " su D30EUR, U30USD, NASUSD -- M15")
  [void]$RefTxt.Add("SEI celle: tre simboli x DUE LATI (long e short SEPARATI, regola di casa 25/08)")
  [void]$RefTxt.Add("porting del candidato P2 della caccia M5/M15 indici del 25/08 (voto 9/10)")
  if($SoloControllo){ [void]$RefTxt.Add("modo: " + $Modo + "   <<< GIRO A VUOTO: NESSUNA passata, NESSUN CSV, NESSUN numero di round qui dentro") }
  else              { [void]$RefTxt.Add("modo: " + $Modo) }
  $sw = @()
  if($SoloControllo){ $sw += "-SoloControllo (nessuna passata; MA COMPILA)" }
  if($CriteriFirmati){ $sw += "-CriteriFirmati (FIRMA IN RIGA di Claudio: il file dei criteri portava ancora [DA FIRMARE])" }
  if($ScreenOhlcM15){ $sw += "-ScreenOhlcM15 (OHLC M1: NIENTE di questo giro e' GIUDICABILE)" }
  if($SoloSimbolo -ne ""){ $sw += "-SoloSimbolo " + $SoloSimbolo }
  if($SoloCella -ne ""){ $sw += "-SoloCella " + $SoloCella }
  if($sw.Count -eq 0){ $sw += "nessuno (corsa piena)" }
  [void]$RefTxt.Add("switch di questo giro: " + ($sw -join " | "))
  [void]$RefTxt.Add("stato dei criteri: " + $Firma)
  [void]$RefTxt.Add("data: " + (Get-Date).ToString("yyyy-MM-dd HH:mm:ss",$INV) + "   (questa data deve essere di ADESSO)")
  [void]$RefTxt.Add("     ATTENZIONE: la data fresca NON distingue un giro a vuoto da una corsa.")
  [void]$RefTxt.Add("     Quello che lo distingue e' la riga 'modo:' qui sopra e il NOME della cartella.")
  [void]$RefTxt.Add("avvio: " + $Avvio.ToString("yyyy-MM-dd HH:mm:ss",$INV) + "   durata: " + ((New-TimeSpan -Start $Avvio -End (Get-Date)).TotalHours).ToString("0.0",$INV) + " ore")
  [void]$RefTxt.Add("pin: " + $Pin)
  [void]$RefTxt.Add("criteri: risultati_archivio\R109_CRITERI.md   tesi: ATREXHAUST_TESI.md")
  [void]$RefTxt.Add("dossier: caccia_strategie\CACCIA_M5M15_INDICI_2026-08-25.md (P2)")
  [void]$RefTxt.Add("compilato: " + $(if($Compilato){ "SI, .ex5 riscritto adesso" + $(if($Warning -ge 0){ " (" + $Warning + " warning)" } else { "" }) } else { "NO" }))
  [void]$RefTxt.Add("     >>> ED E' LA PRIMA COMPILAZIONE DELLA VITA DI QUESTO EA: il .mq5")
  [void]$RefTxt.Add("         dichiara in testa di non essere mai stato compilato ne' testato.")
  [void]$RefTxt.Add("")
  [void]$RefTxt.Add("--- IL GATE A0: L'AUTOTEST DEL MOTORE ---")
  [void]$RefTxt.Add("  stato: " + $AutotestStato)
  [void]$RefTxt.Add("  log:   " + $AutotestFile)
  if(@($AutotestRighe).Count -gt 0){
    foreach($r in $AutotestRighe){ [void]$RefTxt.Add("    " + $r) }
  } else {
    [void]$RefTxt.Add("    (nessuna riga [ATREXH][AUTOTEST] raccolta)")
  }
  [void]$RefTxt.Add("  >>> 'NON LETTO' NON E' 'SUPERATO'. Se l'esito non e' SUPERATO, ogni numero")
  [void]$RefTxt.Add("      di questo referto e' NON CONVALIDATO (criteri D5). L'autotest si legge")
  [void]$RefTxt.Add("      ESEGUENDO, non compilando: nel giro a vuoto NON esiste, ed e' giusto.")
  [void]$RefTxt.Add("  >>> MA 'NON LETTO' NON E' NEMMENO UN INDIZIO CONTRO L'EA, e va detto da che")
  [void]$RefTxt.Add("      parte sta il dubbio: LE CINQUE RADICI in cui questo driver cerca il log")
  [void]$RefTxt.Add("      dell'agente del tester NON SONO MAI STATE MISURATE SU UN MT5 VERO. Sono")
  [void]$RefTxt.Add("      l'ipotesi migliore di chi ha scritto la riga. 'NON LETTO' vuol dire quasi")
  [void]$RefTxt.Add("      sempre CHE CERCHIAMO NEL POSTO SBAGLIATO NOI, non che il motore diverga:")
  [void]$RefTxt.Add("      se divergesse, l'esito sarebbe DIVERGE e il round si sarebbe fermato da")
  [void]$RefTxt.Add("      solo. Si toglie in cinque minuti ricaricando collaudo_autotest.ini in")
  [void]$RefTxt.Add("      test singolo e leggendo la scheda Esperti -- e annotando DOVE stava il file.")
  [void]$RefTxt.Add("")
  [void]$RefTxt.Add("--- LA FINESTRA, IL MODELLO E IL RISCHIO ---")
  #  >>> LA FINESTRA SI CONTROLLA ANCHE QUI, ED E' L'ULTIMA RETE (25/08).
  #      Il 25/08 la data di FINE e' arrivata FIN QUI corrotta e il referto
  #      ha stampato "2024.09.26 -> InpUsaGuardian=true||..." senza che
  #      nulla protestasse. Un referto che stampa una finestra impossibile
  #      deve DIRLO, non limitarsi a mostrarla: chi legge il fondo del
  #      referto non ricontrolla gli .ini.
  $finOk = ($DataDa -match '^\d{4}\.\d{2}\.\d{2}$') -and ($DataA -match '^\d{4}\.\d{2}\.\d{2}$')
  if(-not $finOk){
    [void]$Problemi.Add("LA FINESTRA DEL ROUND NON E' UNA COPPIA DI DATE: FromDate=[" + $DataDa + "] ToDate=[" + $DataA + "]. NESSUN numero di questo referto risponde alla domanda, perche' non si sa su QUALE periodo sia stato misurato. Non leggere niente: rilancia con la riga corretta.")
    [void]$RefTxt.Add("  !!! FINESTRA CORROTTA: [" + $DataDa + "] -> [" + $DataA + "]")
    [void]$RefTxt.Add("      >>> NESSUN NUMERO DI QUESTO REFERTO E' LEGGIBILE: non si sa su quale")
    [void]$RefTxt.Add("          periodo sia stato misurato. Vedi PROBLEMI.")
  }
  if($ScreenOhlcM15){
    [void]$RefTxt.Add("  " + $DataDa + " -> " + $DataA + "   modello 1 (OHLC M1)  <<< SCREEN")
    [void]$RefTxt.Add("     >>> OGNI RIGA DI QUESTO REFERTO E' *NON GIUDICABILE*. Su M5/M15 l'OHLC")
    [void]$RefTxt.Add("         inganna, ed e' MISURATO in casa (REGISTRO_TEST.md par. 2). E qui")
    [void]$RefTxt.Add("         morde di piu': l'ingresso nasce da un ESTREMO DI BARRA e lo stop sta")
    [void]$RefTxt.Add("         a un tick dal minimo, quindi stop e target dello stesso trade sono")
    [void]$RefTxt.Add("         decisi da un'IPOTESI sull'ordine di visita dentro la barra.")
  } else {
    [void]$RefTxt.Add("  " + $DataDa + " -> " + $DataA + "   modello 4 (TICK REALI)")
  }
  [void]$RefTxt.Add("  NIENTE IS/OOS (criteri D3): l'Emendamento A dimensiona l'IS sulle OPERAZIONI,")
  [void]$RefTxt.Add("     e le operazioni non le conoscevamo. Questo round CONTA; il taglio si fa")
  [void]$RefTxt.Add("     dopo, sui conteggi veri. >>> Quindi da qui NON esce nessun out-of-sample.")
  [void]$RefTxt.Add("  UN SOLO REGIME: lo storico BCM sugli indici parte dal 2024.09.26 (MISURATO,")
  [void]$RefTxt.Add("     stato COMPLETO = il broker non ha altro) ed e' prevalentemente RIALZISTA.")
  [void]$RefTxt.Add("     Questo motore e' CONTROTENDENZA. >>> IL MERITO E' SOSPESO PER COSTRUZIONE")
  [void]$RefTxt.Add("     (criteri par. 7), a QUALUNQUE n. Il RISCHIO invece si legge tutto: un")
  [void]$RefTxt.Add("     drawdown e' un fatto accaduto (Emendamento regola B).")
  [void]$RefTxt.Add("  NESSUN DATO DUKASCOPY: sugli indici i file _EXT NON ESISTONO ancora. Questo")
  [void]$RefTxt.Add("     round gira SOLO su BCM, con i costi di BCM. Non e' una proprieta' del")
  [void]$RefTxt.Add("     mercato: e' una proprieta' di un broker.")
  [void]$RefTxt.Add("  spread: Spread=" + $SpreadIni + " scritto NELL'INI = spread CORRENTE del feed BCM.")
  [void]$RefTxt.Add("     A modello 4 il bid/ask arriva dai tick. In nessun modello c'e' SLIPPAGE.")
  [void]$RefTxt.Add("  rischio: 1,00% nei file prova (default del porting). IN CAMPO SI GIRA A 0,65%")
  [void]$RefTxt.Add("     e l'autore usava 0,5%: ogni euro e ogni % di DD qui dentro va MOLTIPLICATO")
  [void]$RefTxt.Add("     per 0,65 (o 0,5) prima di confrontarlo con qualcos'altro.")
  [void]$RefTxt.Add("  cap giornaliero: 3 PER CELLA, cioe' PER LATO. >>> LA SOMMA DEI DUE LATI DI UN")
  [void]$RefTxt.Add("     SIMBOLO NON E' LA CELLA 'ENTRAMBI': e' un LIMITE SUPERIORE. In R109 long e")
  [void]$RefTxt.Add("     short non si bloccano a vicenda, in campo si'.")
  [void]$RefTxt.Add("")
  [void]$RefTxt.Add("--- CONVENZIONE DI SENTINELLA (checklist 66) ---")
  [void]$RefTxt.Add("  Un numero NON MISURATO si scrive 'n/d'. MAI -1, MAI 0.000. Vale per TUTTE le")
  [void]$RefTxt.Add("  colonne: profitto, PF, DD, n, take, perdita, durata e peggior giornata.")
  [void]$RefTxt.Add("")
  [void]$RefTxt.Add("--- LA PROFONDITA' DEI TICK (criteri D2) ---")
  foreach($s in $SymLavoro){
    [void]$RefTxt.Add("  " + $s.Sym.PadRight(8) + " " + $s.TickMisurati + "   [" + $s.TickData + "]")
  }
  [void]$RefTxt.Add("  >>> A modello 4 senza tick reali MT5 NON SI FERMA: ripiega e produce numeri")
  [void]$RefTxt.Add("      PLAUSIBILI E FALSI, e nessuna guardia di questo driver puo' accorgersene.")
  [void]$RefTxt.Add("")
  [void]$RefTxt.Add("--- IL PASSO 0, PRIMA PARTE: SI CONTA (criteri par. 3.0 e S0b) ---")
  [void]$RefTxt.Add(("  {0,-8} {1,-7} {2,-6} {3,-11} {4,-11} {5,-7} {6,-7} {7,-8} {8,-7} {9}" -f `
                "SIMB","LATO","n","PRIMA-OP","ULTIMA-OP","GIORNI","MAX/GG","AL-CAP","OP/SED","FINESTRA"))
  foreach($c in $Ordinati){
    [void]$RefTxt.Add(("  {0,-8} {1,-7} {2,-6} {3,-11} {4,-11} {5,-7} {6,-7} {7,-8} {8,-7} {9}" -f `
                  $c.Sym,$c.Lato,(FmtN $c.P0N),$c.P0Prima,$c.P0Ultima,(FmtN $c.P0GiorniOp),
                  (FmtN $c.P0MaxGiorno),(FmtN $c.P0GiorniAlCap),(Fmt2 $c.P0OpSeduta),$c.P0Finestra))
  }
  [void]$RefTxt.Add("  GIORNI = giornate con almeno un'operazione. MAX/GG = massimo in una giornata.")
  [void]$RefTxt.Add("  AL-CAP = giornate che hanno toccato il cap di 3: se sono tante, OP/SED e' un")
  [void]$RefTxt.Add("     LIMITE INFERIORE e non la frequenza del motore (criteri D7).")
  [void]$RefTxt.Add("  OP/SED = n diviso i GIORNI FERIALI fra prima e ultima operazione. E' un")
  [void]$RefTxt.Add("     DERIVATO, non una misura: NON toglie le feste di borsa, quindi SOTTOSTIMA.")
  [void]$RefTxt.Add("  ATTESA DICHIARATA PRIMA: 0,5-2 operazioni al giorno per lato, ed era una")
  [void]$RefTxt.Add("     [STIMA DEL CACCIATORE], mai una misura nostra. Se n esce molto piu' basso,")
  [void]$RefTxt.Add("     quello E' GIA' UN RISULTATO: la frequenza e' la ragione per cui il round")
  [void]$RefTxt.Add("     esiste (challenge).")
  [void]$RefTxt.Add("")
  [void]$RefTxt.Add("--- IL PASSO 0, SECONDA PARTE: IL CANCELLO ZERO SUL COSTO (criteri par. 3) ---")
  [void]$RefTxt.Add("  Si legge PRIMA di qualunque PF. Il take e' misurato SUI PREZZI dei deal")
  [void]$RefTxt.Add("  (in -> out) del report .htm, in PUNTI INDICE (su BCM questi tre indici hanno")
  [void]$RefTxt.Add("  2 decimali: 1 punto indice = 1,00 di prezzo = 100 punti MT5). Su un indice il")
  [void]$RefTxt.Add("  'pip' NON ESISTE. Il take e' GIA' AL NETTO dello spread (entry all'ask, uscita")
  [void]$RefTxt.Add("  al bid): il LORDO si ottiene aggiungendo lo spread dichiarato.")
  [void]$RefTxt.Add("  spread DICHIARATO: " + $SpreadPuntiDich.ToString("0.0",$INV) + " punti indice   [NON MISURATO -- criteri D4]")
  [void]$RefTxt.Add("  soglia S0a: take LORDO MEDIANO dei vincenti >= " + $S0aMult.ToString("0.0",$INV) + "x lo spread")
  [void]$RefTxt.Add(("  {0,-8} {1,-7} {2,-10} {3,-10} {4,-10} {5,-9} {6,-9} {7}" -f `
                "SIMB","LATO","TAKEnet","TAKElordo","RAPPORTO","PERDmed","DURmed","STATO PASSO 0"))
  foreach($c in $Ordinati){
    [void]$RefTxt.Add(("  {0,-8} {1,-7} {2,-10} {3,-10} {4,-10} {5,-9} {6,-9} {7}" -f `
                  $c.Sym,$c.Lato,(Fmt2 $c.P0TakeNetMed),(Fmt2 $c.P0TakeLordoMed),(Fmt2 $c.P0Rapporto),
                  (Fmt2 $c.P0PerdMed),(Fmt2 $c.P0DurMed),$c.P0Stato))
  }
  [void]$RefTxt.Add("  (TAKE e PERD in PUNTI INDICE, MEDIANE -- non medie. DUR in barre M15.)")
  [void]$RefTxt.Add("  PERDmed e' la miglior stima di R che il report contenga: le perdenti escono")
  [void]$RefTxt.Add("     allo stop. Sotto " + $RMinPunti.ToString("0",$INV) + " punti indice = stop stretto = LOTTO GRANDE, e lo")
  [void]$RefTxt.Add("     slippage si mangia l'operazione (R55). Il pavimento InpMinSLPts e' SPENTO.")
  [void]$RefTxt.Add("")
  foreach($c in $Ordinati){
    [void]$RefTxt.Add("  S0a " + $c.Sym + " " + $c.Lato + ": " + $c.S0a)
    [void]$RefTxt.Add("      take medio (non mediano) sui vincenti: " + (Fmt2 $c.P0TakeNetMedia) + " punti indice netti")
    [void]$RefTxt.Add("      durata media (non mediana): " + (Fmt2 $c.P0DurMedia) + " barre M15")
    [void]$RefTxt.Add("      peggior giornata (dal report): " + (FmtPg $c.P0Pegg) + "%  il " + $c.P0PeggData + "   (muro prop: -5,00%)")
  }
  [void]$RefTxt.Add("")
  [void]$RefTxt.Add("--- LA TABELLA MADRE ---   (attese: " + $CelleAttese + " righe per CSV, " + $PassateAttese + " passate)")
  [void]$RefTxt.Add(("  {0,-8} {1,-7} {2,-10} {3,-8} {4,-8} {5,-7} {6,-12} {7}" -f `
                "SIMB","LATO","PROFITTO","PF","DD%","n","GEMELLI","ESITO"))
  foreach($c in $Ordinati){
    [void]$RefTxt.Add(("  {0,-8} {1,-7} {2,-10} {3,-8} {4,-8} {5,-7} {6,-12} {7}" -f `
                  $c.Sym,$c.Lato,(FmtE $c.ProfInt),(Fmt3 $c.PfInt),(Fmt2 $c.DdInt),(FmtN $c.NInt),
                  $c.GemInt,$c.Esito))
  }
  [void]$RefTxt.Add("  >>> IL PF DI QUESTA TABELLA NON E' UN VERDETTO DI MERITO. Un solo regime, un")
  [void]$RefTxt.Add("      motore controtendenza, nessun out-of-sample: il numero dice quanto e'")
  [void]$RefTxt.Add("      costato opporsi a QUESTO toro, non se l'idea funziona (criteri par. 7).")
  [void]$RefTxt.Add("")
  [void]$RefTxt.Add("--- G4: LA PEGGIOR GIORNATA (muro prop: -5,00% su 100k) ---")
  [void]$RefTxt.Add("  E' IL NUMERO DA GUARDARE, piu' del DD totale: la peggiore misurata in casa e'")
  [void]$RefTxt.Add("  -2,06% (R51), e i tre indici si esauriscono spesso INSIEME.")
  [void]$RefTxt.Add(("  {0,-8} {1,-7} {2,-12} {3,-12} {4}" -f "SIMB","LATO","htm","quando","csv (OPTFRAME)"))
  foreach($c in $Ordinati){
    [void]$RefTxt.Add(("  {0,-8} {1,-7} {2,-12} {3,-12} {4}" -f `
                  $c.Sym,$c.Lato,(FmtPg $c.P0Pegg),$c.P0PeggData,(FmtPg $c.PgInt)))
  }
  [void]$RefTxt.Add("  (tutti in % del deposito, a rischio 1,00%. 'n/d' = NON MISURATA, mai 0.)")
  [void]$RefTxt.Add("  >>> E LE DUE VISTE SONO DUE STRUMENTI DIVERSI: la colonna htm viene dal report")
  [void]$RefTxt.Add("      della passata singola, la colonna csv dall'OPTFRAME della gemella. Se")
  [void]$RefTxt.Add("      divergono e' un'informazione, non un guasto.")
  [void]$RefTxt.Add("")
  [void]$RefTxt.Add("--- LE CELLE, COME SONO SCRITTE NEI FILE CHE HANNO GIRATO ---")
  foreach($c in $Ordinati){
    [void]$RefTxt.Add(("  {0,-8} {1,-7} magic {2}/{3} (gemelle) {4} (singola)  modello {5}" -f `
                  $c.Sym,$c.Lato,$c.Base,($c.Base+1),($c.Base+2),$c.Modello))
    [void]$RefTxt.Add("       InpAllowLong=" + $c.Val["InpAllowLong"] + "  InpAllowShort=" + $c.Val["InpAllowShort"] + "  " + $c.Desc)
  }
  [void]$RefTxt.Add("  collaudo autotest: magic " + $CollaudoMagic + ", " + $CollaudoDa + " -> " + $CollaudoA + ", modello 1 (nessun numero di round)")
  [void]$RefTxt.Add("  >>> 774401, il DEFAULT COMPILATO dell'EA, e' VIETATO in tutto il round: se una")
  [void]$RefTxt.Add("      cella girasse col default, il magic lo direbbe.")
  [void]$RefTxt.Add("")
  [void]$RefTxt.Add("--- QUELLO CHE QUESTO REFERTO NON DICE, DICHIARATO ---")
  [void]$RefTxt.Add("  * NON PROMUOVE E NON BOCCIA NIENTE (G5). Questo EA NON va in forward: lo dice")
  [void]$RefTxt.Add("    la sua stessa tesi, in testa.")
  [void]$RefTxt.Add("  * NON APPLICA G2 (merito) E G3 (coerenza cross-simbolo): il merito e' sospeso")
  [void]$RefTxt.Add("    per costruzione. Se S0 e G1 sono verdi su piu' celle, il passo dopo e' un")
  [void]$RefTxt.Add("    ROUND NUOVO, non una promozione.")
  [void]$RefTxt.Add("  * NON HA GIRATO NESSUNA ABLAZIONE (criteri D1): prossimita' PERC vs ATR,")
  [void]$RefTxt.Add("    grilletto AUTORE vs CLOSE, buffer/pavimento dello SL, parziale+BE+trailing")
  [void]$RefTxt.Add("    restano tutte da misurare, e solo SE questo round passa S0.")
  [void]$RefTxt.Add("  * NON MISURA LO SPREAD: la soglia di S0a usa un valore DICHIARATO.")
  [void]$RefTxt.Add("  * NON MISURA LA PROFONDITA' DEI TICK (esiste solo per U30USD).")
  [void]$RefTxt.Add("  * NON FA LA PROVA DI REGIME, e non la puo' fare: il broker non ha altro")
  [void]$RefTxt.Add("    storico. Quando ci sara' la pipeline Dukascopy _EXT sugli indici, questo")
  [void]$RefTxt.Add("    round va RIFATTO su una finestra che contenga almeno un orso.")
  [void]$RefTxt.Add("  * NIENTE M5 e niente cella 'entrambi i lati'.")
  [void]$RefTxt.Add("  * NESSUN NUMERO D'AUTORE e' entrato qui dentro: Pine -> MQL5 non e' un")
  [void]$RefTxt.Add("    porting, e' una riscrittura, e i conteggi divergono per costruzione (cap")
  [void]$RefTxt.Add("    giornaliero, media del volume, STOPS_LEVEL, short simmetrizzato).")
  [void]$RefTxt.Add("")
  if($Rilievi.Count -gt 0){
    [void]$RefTxt.Add("--- RILIEVI (NON sono guasti: sono RISULTATI del round) ---   (" + $Rilievi.Count + ")")
    foreach($n in $Rilievi){ [void]$RefTxt.Add("  - " + $n) }
    [void]$RefTxt.Add("")
  }
  [void]$RefTxt.Add("--- PROBLEMI (questi SI sono guasti, o risposte scomode) ---   (" + $Problemi.Count + ")")
  if($Problemi.Count -eq 0){ [void]$RefTxt.Add("  nessuno.") }
  foreach($p in $Problemi){ [void]$RefTxt.Add("  - " + $p) }
  if($Fatale -ne ""){
    [void]$RefTxt.Add("")
    [void]$RefTxt.Add("--- FERMATO ---")
    [void]$RefTxt.Add("  " + $Fatale)
  }
  [void]$RefTxt.Add("")
  # --- L'ESITO SCRITTO NEL REFERTO DICE LE STESSE PAROLE DELLO SCHERMO,
  #     e distingue PARZIALE da COMPLETO CON RILIEVI (checklist 47 e 68).
  $koR = @($Ordinati | Where-Object { $_.Esito -ne "OK" -and $_.Esito -notlike "SOLO CONTROLLO*" -and $_.Esito -ne "NON GIUDICABILE" })
  if($Fatale -ne ""){
    [void]$RefTxt.Add("ESITO: FERMATO -- " + $Fatale)
  }
  elseif($ScreenOhlcM15 -and -not $SoloControllo){
    [void]$RefTxt.Add("ESITO: SCREEN OHLC -- NESSUN VERDETTO. Le celle sono girate a MODELLO 1 (OHLC M1), non a tick reali: nessun cancello si applica, nessun S0a e' stato dato, e ogni riga e' marcata NON GIUDICABILE. Questo giro puo' produrre AL MASSIMO il PERMESSO di un giro a tick reali. Celle senza numeri: " + $koR.Count + " - problemi: " + $Problemi.Count + " - rilievi: " + $Rilievi.Count + ".")
  }
  elseif($SoloControllo){
    if($koR.Count -gt 0 -or $Problemi.Count -gt 0){
      [void]$RefTxt.Add("ESITO: GIRO A VUOTO CON PROBLEMI (" + $Problemi.Count + ") -- NESSUNA passata. NON lanciare la corsa vera prima di aver letto i PROBLEMI.")
    } else {
      [void]$RefTxt.Add("ESITO: GIRO A VUOTO COMPLETATO -- NESSUNA passata, NESSUN CSV, NESSUN numero, NESSUN autotest. QUESTO ZIP NON E' IL ROUND. Ma L'EA COMPILA, e quella e' una notizia: non era mai stato compilato.")
    }
  }
  elseif($koR.Count -gt 0){
    [void]$RefTxt.Add("ESITO: PARZIALE -- " + $koR.Count + " celle su " + $Ordinati.Count + " NON hanno prodotto i numeri attesi, piu' " + $Problemi.Count + " problemi. NON e' un round completo.")
  }
  elseif($Problemi.Count -gt 0){
    [void]$RefTxt.Add("ESITO: COMPLETO CON PROBLEMI -- tutte e " + $Ordinati.Count + " le celle hanno prodotto i numeri, ma ci sono " + $Problemi.Count + " problemi (fra cui puo' esserci un S0a FALLITO, che e' una RISPOSTA e non un guasto). I numeri si leggono ACCANTO ai problemi, non invece dei problemi.")
  }
  elseif($Rilievi.Count -gt 0){
    [void]$RefTxt.Add("ESITO: COMPLETO CON RILIEVI -- tutte e " + $Ordinati.Count + " le celle hanno prodotto i numeri attesi. I " + $Rilievi.Count + " rilievi sono RISULTATI del round (canarino, frequenza censurata, stop stretto, durata corta, tick non misurati, S0a sospeso), non guasti.")
  }
  else{
    [void]$RefTxt.Add("ESITO: OK -- tutte le celle hanno prodotto i numeri attesi, nessun problema e nessun rilievo.")
  }
  [void]$RefTxt.Add("")
  [void]$RefTxt.Add("--- COME SI RIPRENDE ---")
  [void]$RefTxt.Add('  un simbolo solo    : ... & $p -Pin <PIN> -CriteriFirmati -SoloSimbolo ''U30USD''')
  [void]$RefTxt.Add('  due simboli        : ... & $p -Pin <PIN> -CriteriFirmati -SoloSimbolo ''D30EUR,NASUSD''   <-- FRA APICI (checklist 65)')
  [void]$RefTxt.Add('  una cella sola     : ... & $p -Pin <PIN> -CriteriFirmati -SoloCella ''R109_U30USD_01_short.txt''')
  [void]$RefTxt.Add("  >>> in tutti i casi il COLLAUDO DELL'AUTOTEST rigira: costa minuti, ed e' la")
  [void]$RefTxt.Add("      prova che il motore ragiona come la sua firma. Senza, i numeri non si")
  [void]$RefTxt.Add("      convalidano.")
  [void]$RefTxt.Add("  >>> E OGNI RIGA DI RIPRESA E' UN BLOCCO INTERO col suo irm e la sua guardia")
  [void]$RefTxt.Add("      (checklist 42): i tre puntini stanno per il blocco di RIGA_R109_DA_MANDARE.md.")
  #  >>> APICI SINGOLI, E NON E' UN VEZZO (trovato ESEGUENDO, 25/08). In apici
  #      DOPPI questa riga espandeva $p -- che in questo script NON e' il path
  #      dello script scaricato, ma la variabile del foreach dei PROBLEMI venti
  #      righe piu' su (in PowerShell la variabile di un foreach SOPRAVVIVE al
  #      ciclo). Risultato: senza problemi la frase usciva "Una riga '&  ...'",
  #      e CON problemi ci finiva dentro il TESTO INTERO dell'ultimo problema.
  #      La riga che deve MOSTRARE del codice si scrive in apici singoli.
  [void]$RefTxt.Add('      Una riga ''& $p ...'' incollata da sola riusa la copia locale e il pin di prima.')

  Set-Content -LiteralPath $Referto -Value ($RefTxt -join "`r`n") -Encoding UTF8
  if(Test-Path -LiteralPath $Zip){ Remove-Item -LiteralPath $Zip -Force -ErrorAction SilentlyContinue }
  Compress-Archive -Path (Join-Path $Cart "*") -DestinationPath $Zip -Force
}catch{
  Write-Host ("!!! RACCOLTA PARZIALE: " + $_.Exception.Message) -ForegroundColor Red
}

Write-Host ""
Write-Host "=====================================================================" -ForegroundColor White
Write-Host "  R109 - FINE" -ForegroundColor White
function Riga3([string]$path,[string]$coda){
  if(Test-Path -LiteralPath $path){ Write-Host ("   " + $path + "   " + $coda) -ForegroundColor White }
  else                            { Write-Host ("   " + $path + "   <<< NON ESISTE") -ForegroundColor Red }
}
Riga3 $Cart    ""
Riga3 $Zip     "<- e' questo che mi mandi"
Riga3 $Referto "<- la riga 'data:' deve essere di ADESSO, la riga 'modo:' dice se e' il round o un giro a vuoto"
Write-Host "=====================================================================" -ForegroundColor White
if($SoloControllo){
  Write-Host ("  MODO: " + $Modo + " -- GIRO A VUOTO. NESSUNA passata, NESSUN CSV, NESSUN") -ForegroundColor Yellow
  Write-Host  "        numero di round, e NESSUN AUTOTEST (si legge ESEGUENDO)." -ForegroundColor Yellow
  Write-Host  "        QUESTO ZIP NON E' IL ROUND e non va mandato come risultato." -ForegroundColor Yellow
  Write-Host ("  MA HA COMPILATO: " + $(if($Compilato){ "SI -- ed e' la prima volta per questo EA" } else { "NO" })) -ForegroundColor $(if($Compilato){ "Green" } else { "Red" })
} else {
  Write-Host ("  MODO: " + $Modo) -ForegroundColor White
  Write-Host ("  ATTESE:  " + $PassateAttese + " passate, " + $CelleAttese + " righe per CSV di ottimizzazione.") -ForegroundColor White
  Write-Host ("  GATE A0 (autotest): " + $AutotestStato) -ForegroundColor $(if($AutotestStato -like "SUPERATO*"){ "Green" } else { "Yellow" })
  if($ScreenOhlcM15){
    Write-Host  "  >>> -ScreenOhlcM15 ACCESO: OGNI RIGA E' NON GIUDICABILE." -ForegroundColor Yellow
  }
  foreach($c in $Ordinati){
    $col = "Yellow"
    if($c.S0a -like "SUPERATO*"){ $col = "Green" }
    if($c.S0a -like "FALLITO*"){ $col = "Red" }
    Write-Host ("  S0a " + $c.Sym + " " + $c.Lato + ": " + $c.S0a) -ForegroundColor $col
  }
}
foreach($c in $Ordinati){
  $col = "Green"; if($c.Esito -ne "OK" -and $c.Esito -notlike "SOLO CONTROLLO*"){ $col = "Yellow" }
  Write-Host ("   " + ($c.Sym + " " + $c.Lato).PadRight(22) + " " + $c.Esito) -ForegroundColor $col
}
if($Rilievi.Count -gt 0){
  Write-Host ""
  Write-Host "   RILIEVI (risultati del round, NON guasti):" -ForegroundColor Yellow
  foreach($n in $Rilievi){ Write-Host ("    - " + $n) -ForegroundColor Yellow }
}
if($Problemi.Count -gt 0){
  Write-Host ""
  Write-Host "   PROBLEMI DA LEGGERE:" -ForegroundColor Red
  foreach($p in $Problemi){ Write-Host ("    - " + $p) -ForegroundColor Red }
}
Write-Host ""
# =====================================================================
#  L'ESITO IN CONSOLE DICE LE STESSE PAROLE DEL REFERTO, o i due si
#  contraddicono: chi legge lo schermo e manda lo zip non ha visto il
#  referto.
#  >>> E OGNI RAMO FINISCE CON UN exit ESPLICITO. Senza, il codice di
#      uscita e' quello dell'ULTIMO comando eseguito e il blocco che si
#      incolla in chat puo' annunciare "PARZIALE O FERMO" su un round
#      perfetto.
#  >>> E GLI STATI SONO PIU' DI DUE (checklist 68): "COMPLETO CON RILIEVI"
#      e' un successo e esce 0.
#      CODICI: 0 = OK / COMPLETO CON RILIEVI
#              1 = parziale, fermato, con problemi, screen, o selettore a vuoto
#              2 = criteri non firmati
# =====================================================================
if($Fatale -ne ""){ Write-Host ("ESITO: FERMATO -- " + $Fatale) -ForegroundColor Red; exit 1 }
$ko = @($Ordinati | Where-Object { $_.Esito -ne "OK" -and $_.Esito -notlike "SOLO CONTROLLO*" -and $_.Esito -ne "NON GIUDICABILE" })
if($ScreenOhlcM15 -and -not $SoloControllo){
  Write-Host  "ESITO: SCREEN OHLC -- NESSUN VERDETTO. Le celle sono girate a OHLC M1:" -ForegroundColor Yellow
  Write-Host  "       nessun cancello, nessun S0a, ogni riga marcata NON GIUDICABILE." -ForegroundColor Yellow
  Write-Host ("       Celle senza numeri: " + $ko.Count + " - problemi: " + $Problemi.Count + " - rilievi: " + $Rilievi.Count + ". Lo zip esiste: mandalo.") -ForegroundColor Yellow
  exit 1
}
if($SoloControllo){
  if($ko.Count -gt 0 -or $Problemi.Count -gt 0){
    Write-Host ("ESITO: GIRO A VUOTO CON PROBLEMI (" + $Problemi.Count + ") -- NESSUNA passata, e c'e' da leggere il referto") -ForegroundColor Yellow
    exit 1
  }
  Write-Host "ESITO: GIRO A VUOTO COMPLETATO -- NESSUNA passata, NESSUN CSV. QUESTO ZIP NON E' IL ROUND." -ForegroundColor Green
  exit 0
}
if($ko.Count -gt 0){
  Write-Host ("ESITO: PARZIALE (" + $ko.Count + " celle su " + $Ordinati.Count + " non hanno prodotto i numeri, " + $Problemi.Count + " problemi) -- lo zip esiste: mandalo") -ForegroundColor Yellow
  exit 1
}
if($Problemi.Count -gt 0){
  Write-Host ("ESITO: COMPLETO CON PROBLEMI (" + $Problemi.Count + ") -- i numeri ci sono TUTTI, ma vanno letti ACCANTO ai problemi. Lo zip esiste: mandalo.") -ForegroundColor Yellow
  exit 1
}
if($Rilievi.Count -gt 0){
  Write-Host ("ESITO: COMPLETO CON RILIEVI (" + $Rilievi.Count + " rilievi da leggere nel referto, nessuna cella mancante e nessun guasto)") -ForegroundColor Green
  exit 0
}
Write-Host "ESITO: OK" -ForegroundColor Green
exit 0
